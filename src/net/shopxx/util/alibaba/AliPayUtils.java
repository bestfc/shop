package net.shopxx.util.alibaba;

import com.alipay.api.AlipayApiException;
import com.alipay.api.AlipayClient;
import com.alipay.api.DefaultAlipayClient;
import com.alipay.api.domain.AlipayTradeQueryModel;
import com.alipay.api.internal.util.AlipaySignature;
import com.alipay.api.request.*;
import com.alipay.api.response.*;
import net.shopxx.exception.BusinessException;
import net.shopxx.exception.ErrorCode;
import net.shopxx.util.PropertiesUtil;
import net.shopxx.util.alibaba.model.AlipayCFG;
import net.shopxx.util.alibaba.model.AlipayPayParam;
import net.shopxx.util.alibaba.model.AlipayRefundParam;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.Map;
import java.util.concurrent.TimeUnit;

@Service("aliPayUtils")
public class AliPayUtils{
    private static Logger logger = LoggerFactory.getLogger(AliPayUtils.class);

    @Autowired
    public PropertiesUtil propertieUtil;

    private String SERVER_URL;
    private String APP_ID;
    private String APP_PRIVATE_KEY;
    private String ALIPAY_PUBLIC_KEY;
    private String CHARSET;
    private String SIGN_TYPE;
    @PostConstruct
    public void setValue(){
        SERVER_URL=propertieUtil.getValue("alipay.SERVER_URL");
        APP_ID=propertieUtil.getValue("alipay.APP_ID");
        APP_PRIVATE_KEY=propertieUtil.getValue("alipay.APP_PRIVATE_KEY");
        ALIPAY_PUBLIC_KEY=propertieUtil.getValue("alipay.ALIPAY_PUBLIC_KEY");
        CHARSET=propertieUtil.getValue("alipay.CHARSET");
        SIGN_TYPE=propertieUtil.getValue("alipay.SIGN_TYPE");
    }

    //支付宝登录部分
    public String getSign(String unsignedStr) throws BusinessException {
        unsignedStr = URLDecoder.decode(unsignedStr);
        logger.info(unsignedStr);
        String signedStr = null;
        try {
            signedStr = AlipaySignature.rsaSign(unsignedStr, APP_PRIVATE_KEY, CHARSET, SIGN_TYPE);
        } catch (AlipayApiException e) {
            throw new BusinessException(ErrorCode.THIRD_ERROR_ALIPAY_EXECFAIL, e.getErrMsg() + " " + e.getErrCode());
        }
        try {
            signedStr = URLEncoder.encode(signedStr, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            throw new BusinessException(ErrorCode.THIRD_ERROR_ALIPAY_EXECFAIL, e.getMessage());
        }
        logger.info(signedStr);
        return signedStr;
    }

    public String getUserId(String code) throws BusinessException {
        String accessToken = getAccessToken(code);
        return getAlipayUserId(accessToken);
    }

    public String getAccessToken(String code) throws BusinessException {
        //通过code获取access_token
        AlipayClient alipayClient = this.getAlipayClient();
        AlipaySystemOauthTokenRequest request = new AlipaySystemOauthTokenRequest();
        request.setCode(code);
        request.setGrantType("authorization_code");
        AlipaySystemOauthTokenResponse oauthTokenResponse = null;
        try {
            oauthTokenResponse = alipayClient.execute(request);
        } catch (AlipayApiException e) {
            throw new BusinessException(ErrorCode.THIRD_ERROR_ALIPAY_EXECFAIL, e.getErrMsg() + " " + e.getErrCode());
        }
        return oauthTokenResponse.getAccessToken();
    }

    public String getAlipayUserId(String accessToken) throws BusinessException {
        AlipayClient alipayClient = this.getAlipayClient();
        AlipayUserInfoShareRequest request = new AlipayUserInfoShareRequest();
        String token = accessToken;
        AlipayUserInfoShareResponse response;
        try {
            response = alipayClient.execute(request, token);
        } catch (AlipayApiException e) {
            throw new BusinessException(ErrorCode.THIRD_ERROR_ALIPAY_EXECFAIL, e.getErrMsg() + " " + e.getErrCode());
        }
        if (response.isSuccess()) {
            return response.getUserId();
        } else {
            logger.error("getAlipayUserId error", response.getSubCode() + ":" + response.getSubMsg());
            throw new BusinessException(ErrorCode.ALIPAYPOWERROR);
        }
    }

    //支付宝支付部分
    public String rsaSign(Map<String, String> map) throws BusinessException {
        try {
            return AlipaySignature.rsaSign(map, APP_PRIVATE_KEY, "UTF-8");
        } catch (AlipayApiException e) {
            throw new BusinessException(ErrorCode.THIRD_ERROR_ALIPAY_EXECFAIL, e.getErrMsg() + " " + e.getErrCode());
        }
    }

    public boolean rsaCheckV2(Map<String, String> map) throws BusinessException {
        try {
            return AlipaySignature.rsaCheckV2(map, ALIPAY_PUBLIC_KEY, "UTF-8");
        } catch (AlipayApiException e) {
            throw new BusinessException(ErrorCode.THIRD_ERROR_ALIPAY_EXECFAIL, e.getErrMsg() + " " + e.getErrCode());
        }
    }

    public boolean rsaCheckV1(Map<String, String> map){
        try {
            return AlipaySignature.rsaCheckV1(map, ALIPAY_PUBLIC_KEY, "UTF-8");
        } catch (AlipayApiException e) {
            logger.error(e.toString());
        }
        return false;
    }

    public AlipayClient getAlipayClient() {
        return new DefaultAlipayClient(SERVER_URL, APP_ID, APP_PRIVATE_KEY,"json", CHARSET, ALIPAY_PUBLIC_KEY, SIGN_TYPE);
    }

    /**
     * 支付宝订单支付
     *
     * <pre>
     * 支付宝状态返回支付成功或等待用户支付正常返回
     * 其它情况直接抛出业务异常
     * </pre>
     * @param alipayParam
     * @return
     *
     *<pre>
     *订单状态
     *</pre>
     */
    public String alipayPay(AlipayPayParam alipayParam) throws BusinessException {
        AlipayClient alipayClient = getAlipayClient();
        AlipayTradePayRequest request = new AlipayTradePayRequest(); // 创建API对应的request类
        request.setBizContent(alipayParam.toString()); // 设置业务参数
        AlipayTradePayResponse response = null;
        try {
            response = alipayClient.execute(request);
        } catch (AlipayApiException e) {
            throw new BusinessException(ErrorCode.THIRD_ERROR_ALIPAY_EXECFAIL, e.getErrMsg() + " " + e.getErrCode());
        }
        // 支付为等待用户支付和支付成功返回状态，其它情况直接抛出异常
        if (response.getCode().equals(AlipayCFG.RequestStatus.SUCCESS.getCode())) {
            return AlipayCFG.TradeStatus.TRADE_SUCCESS;
        } else if (response.getCode().equals(AlipayCFG.RequestStatus.WAIT_BUYER_PAY.getCode())) {
            return AlipayCFG.TradeStatus.WAIT_BUYER_PAY;
        } else if (response.getCode().equals(AlipayCFG.RequestStatus.FAILURE.getCode())) {
            throw new BusinessException(ErrorCode.PAY_ERROR_ALIPAY_PAYFAILURE, response.getSubMsg());
        } else if (response.getCode().equals(AlipayCFG.RequestStatus.UNKNOW_ERROE.getCode())) {
            return this.alipayTradeQuery(alipayParam.getOutTradeNo());
        } else {
            logger.error("支付宝支付异常," + response.getBody());
            throw new BusinessException(ErrorCode.THIRD_ERROR_ALIPAY_UNKNOWERR);
        }
    }

    /**
     * 支付宝订单查询
     *
     * <pre>
     * 支付宝状态返回支付成功或等待用户支付正常返回
     * 其它情况直接抛出业务异常
     * </pre>
     *
     * tom
     *
     * @param outTradeNo
     *            商家订单编号
     * @return
     *
     *         <pre>
     *         订单状态
     *         </pre>
     */
    public String alipayTradeQuery(String outTradeNo) throws BusinessException {
        return alipayTradeQuery(outTradeNo, 0);
    }

    private String alipayTradeQuery(String outTradeNo, int count) throws BusinessException {
        AlipayClient alipayClient = getAlipayClient();
        AlipayTradeQueryRequest request = new AlipayTradeQueryRequest();// 创建API对应的request类
        request.setBizContent("{" + "    \"out_trade_no\":\"" + outTradeNo + "\"}"); // 设置业务参数
        AlipayTradeQueryResponse response = null;
        try {
            response = alipayClient.execute(request);
        } catch (AlipayApiException e) {
            e.printStackTrace();
        }
        System.out.println("支付宝查询数据=========>" + response.getBody());
        // 支付为等待用户支付和支付成功返回状态，其它情况直接抛出异常
        if (AlipayCFG.RequestStatus.SUCCESS.getCode().equals(response.getCode())) {
            return response.getTradeStatus();
        } else if (AlipayCFG.RequestStatus.FAILURE.getCode().equals(response.getCode())) {
            throw new BusinessException(ErrorCode.PAY_ERROR_ALIPAY_PAYFAILURE, response.getSubMsg());
        } else if (AlipayCFG.RequestStatus.UNKNOW_ERROE.getCode().equals(response.getCode())) {
            // 未知异常无法确定订单是否完成，开始轮询查询订单，三秒调用一次，执行十秒
            if (count <= 10) {
                try {
                    TimeUnit.SECONDS.sleep(3);
                } catch (InterruptedException e) {
                    logger.error("支付宝订单查询定时器失败,订单号:" + outTradeNo + ",当前请求次数:" + count);
                }
                return alipayTradeQuery(outTradeNo, ++count);
            } else {
                throw new BusinessException(ErrorCode.PAY_ERROR_ALIPAY_QUERYFAIL, "支付宝订单查询失败,商家订单编号:" + outTradeNo);
            }
        } else {
            // TODO 记录错误日志
            logger.error("支付宝返回异常code," + response.getCode());
            throw new BusinessException(ErrorCode.PAY_ERROR_ALIPAY_QUERYFAIL, "支付宝订单异常,商家订单编号:" + outTradeNo);
        }
    }

    public boolean getAlipayTradeQueryStatus(String outTradeNo) throws BusinessException {
        AlipayTradeQueryResponse alipayTradeQueryResponse = this.getAlipayTradeQueryResponse(outTradeNo);
        if (alipayTradeQueryResponse.isSuccess()
                && (StringUtils.equalsIgnoreCase(alipayTradeQueryResponse.getTradeStatus(), "TRADE_SUCCESS")
                || StringUtils.equalsIgnoreCase(alipayTradeQueryResponse.getTradeStatus(),
                "TRADE_FINISHED"))) {
            return true;
        }
        return false;
    }


    public AlipayTradeQueryResponse getAlipayTradeQueryResponse(String outTradeNo) throws BusinessException {
        AlipayClient alipayClient = getAlipayClient();
        AlipayTradeQueryRequest alipayTradeQueryRequest = new AlipayTradeQueryRequest();// 创建API对应的request类
        // alipayTradeQueryRequest.setBizContent("{" +
        // " \"out_trade_no\":\"" + outTradeNo + "\"}"); //设置业务参数

        AlipayTradeQueryModel alipayTradeQueryModel = new AlipayTradeQueryModel();
        alipayTradeQueryModel.setOutTradeNo(outTradeNo);
        // alipayTradeQueryModel.setTradeNo(request.getParameter("trade_no"));
        alipayTradeQueryRequest.setBizModel(alipayTradeQueryModel);

        AlipayTradeQueryResponse response = null;
        try {
            response = alipayClient.execute(alipayTradeQueryRequest);
        } catch (AlipayApiException e) {
            throw new BusinessException(ErrorCode.THIRD_ERROR_ALIPAY_EXECFAIL, e.getErrMsg() + " " + e.getErrCode());
        }

        if(!response.isSuccess()){
            logger.error("SubCode:" + response.getSubCode());
            logger.error("SubMsg:" + response.getSubMsg());
            logger.error("支付宝查询失败" + outTradeNo);
        }
        // System.out.println("支付宝查询数据=========>" + response.getBody());

        return response;
    }

    /**
     * 支付宝订单撤销 tom
     *
     * @param outTradeNo
     *            商家订单编号
     * @return true 撤销成功 false 撤销失败
     */
    public boolean alipayTradeCancel(String outTradeNo) throws BusinessException {
        return alipayTradeCancel(outTradeNo, 0);
    }

    private boolean alipayTradeCancel(String outTradeNo, int count) throws BusinessException {
        AlipayClient alipayClient = getAlipayClient();
        AlipayTradeCancelRequest request = new AlipayTradeCancelRequest();// 创建API对应的request类
        request.setBizContent("{" + "    \"out_trade_no\":\"" + outTradeNo + "\"}"); // 设置业务参数
        AlipayTradeCancelResponse response = null;
        try {
            response = alipayClient.execute(request);
        } catch (AlipayApiException e) {
            throw new BusinessException(ErrorCode.THIRD_ERROR_ALIPAY_EXECFAIL, e.getErrMsg() + " " + e.getErrCode());
        }
        System.out.print(response.getBody());
        System.out.println(response.getRetryFlag());
        System.out.println(response.getAction());
        // 根据response中的结果继续业务逻辑处理
        if (AlipayCFG.RequestStatus.SUCCESS.getCode().equals(response.getCode())) {
            return "N".equals(response.getRetryFlag());
        } else if (AlipayCFG.RequestStatus.FAILURE.getCode().equals(response.getCode())) {
            throw new BusinessException(ErrorCode.PAY_ERROR_ALIPAY_CANCELFAIL, response.getSubMsg());
        } else if (AlipayCFG.RequestStatus.UNKNOW_ERROE.getCode().equals(response.getCode())) {
            // 未知异常无法确定订单是否完成，开始轮询查询订单，三秒调用一次，执行十秒
            if (count <= 10) {
                try {
                    TimeUnit.SECONDS.sleep(3);
                } catch (InterruptedException e) {
                    logger.error("支付宝订单查询定时器失败,订单号:" + outTradeNo + ",当前请求次数:" + count);
                }
                return alipayTradeCancel(outTradeNo, ++count);
            } else {
                throw new BusinessException(ErrorCode.THIRD_ERROR_ALIPAY_UNKNOWERR, "无法确认订单是否撤销,商家订单编号:" + outTradeNo);
            }
        } else {
            // TODO 记录错误日志
            throw new BusinessException(ErrorCode.THIRD_ERROR_ALIPAY_UNKNOWERR, "支付宝返回异常code," + response.getCode());
        }
    };

    /**
     * 支付宝订单退款 tom
     *
     * @param alipayRefundParam
     *            商家订单编号
     * @return true 退款成功 false 退款失败
     */
    public boolean alipayTradeRefund(AlipayRefundParam alipayRefundParam) throws BusinessException {
        AlipayClient alipayClient = getAlipayClient();
        AlipayTradeRefundRequest request = new AlipayTradeRefundRequest();
        request.setBizContent(alipayRefundParam.toString());
        AlipayTradeRefundResponse response = null;
        try {
            response = alipayClient.execute(request);
        } catch (AlipayApiException e) {
            throw new BusinessException(ErrorCode.THIRD_ERROR_ALIPAY_EXECFAIL, e.getErrMsg() + " " + e.getErrCode());
        }

        if (!response.isSuccess()) {
            logger.error("SubCode:" + response.getSubCode());
            logger.error("SubMsg:" + response.getSubMsg());
            logger.error("支付宝撤退款失败" + alipayRefundParam.getOutTradeNo());
        }
        return response.isSuccess();
    };
}
