package net.shopxx.plugin.alipayPayment;

import com.alipay.api.*;
import com.alipay.api.domain.AlipayTradePagePayModel;
import com.alipay.api.domain.AlipayTradeQueryModel;
import com.alipay.api.domain.AlipayTradeWapPayModel;
import com.alipay.api.request.AlipayTradePagePayRequest;
import com.alipay.api.request.AlipayTradeQueryRequest;
import com.alipay.api.request.AlipayTradeRefundRequest;
import com.alipay.api.request.AlipayTradeWapPayRequest;
import com.alipay.api.response.AlipayTradeQueryResponse;
import com.alipay.api.response.AlipayTradeRefundResponse;
import net.shopxx.entity.PaymentTransaction;
import net.shopxx.exception.BusinessException;
import net.shopxx.exception.ErrorCode;
import net.shopxx.plugin.PaymentPlugin;
import net.shopxx.util.SpringUtils;
import net.shopxx.util.alibaba.model.AlipayRefundParam;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.mobile.device.Device;
import org.springframework.mobile.device.DeviceUtils;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.math.BigDecimal;

/**
 * Plugin支付宝支付
 */
@Component("alipayPaymentPlugin")
public class AlipayPaymentPlugin extends PaymentPlugin {
    private static Logger logger = LoggerFactory.getLogger(AlipayPaymentPlugin.class);
    /**
     * 正式环境网关URL
     */
    private static final String SERVER_URL = "https://openapi.alipay.com/gateway.do";

    // 沙箱环境
    //private static final String SERVER_URL = "https://openapi.alipaydev.com/gateway.do";

    @Override
    public String getName() {
        return "支付宝支付";
    }

    @Override
    public String getVersion() {
        return "1.0";
    }

    @Override
    public String getAuthor() {
        return "*";
    }

    @Override
    public String getSiteUrl() {
        return "#";
    }

    @Override
    public String getInstallUrl() {
        return "alipay_payment/install";
    }

    @Override
    public String getUninstallUrl() {
        return "alipay_payment/uninstall";
    }

    @Override
    public String getSettingUrl() {
        return "alipay_payment/setting";
    }
    Device device=null;
    @Override
    public void prePayHandle(PaymentPlugin paymentPlugin, PaymentTransaction paymentTransaction, String paymentDescription, String extra, HttpServletRequest request, HttpServletResponse response, ModelAndView modelAndView) throws Exception {
        this.device = DeviceUtils.getCurrentDevice(request);
        if(device.isMobile() || device.isTablet()){
            modelAndView.addObject("payUrl", getPayUrl(paymentPlugin, paymentTransaction, extra));
            modelAndView.addObject("paymentTransactionSn", paymentTransaction.getSn());
            modelAndView.setViewName("net/shopxx/plugin/alipayPayment/pre_pay");
        }else{
            modelAndView.setViewName("redirect:" + paymentPlugin.getPayUrl(paymentPlugin, paymentTransaction));
        }
    }

    @Override
    public void payHandle(PaymentPlugin paymentPlugin, PaymentTransaction paymentTransaction, String paymentDescription, String extra, HttpServletRequest request, HttpServletResponse response, ModelAndView modelAndView) throws Exception {
        AlipayRequest alipayRequest=null;
        if(device.isMobile() || device.isTablet()) {
            AlipayTradeWapPayModel alipayTradeWapPayModel = new AlipayTradeWapPayModel();
            alipayTradeWapPayModel.setOutTradeNo(paymentTransaction.getSn());
            alipayTradeWapPayModel.setProductCode("QUICK_WAP_PAY");
            alipayTradeWapPayModel.setTotalAmount(String.valueOf(paymentTransaction.getAmount().setScale(2)));
            alipayTradeWapPayModel.setSubject(StringUtils.abbreviate(paymentDescription.replaceAll("[^0-9a-zA-Z\\u4e00-\\u9fa5 ]", StringUtils.EMPTY), 60));

            AlipayTradeWapPayRequest alipayTradeWapPayRequest = new AlipayTradeWapPayRequest();
            alipayTradeWapPayRequest.setReturnUrl(getPostPayUrl(paymentPlugin, paymentTransaction));
            alipayTradeWapPayRequest.setNotifyUrl(getPostPayUrl(paymentPlugin, paymentTransaction));
            alipayTradeWapPayRequest.setBizModel(alipayTradeWapPayModel);
            alipayRequest=alipayTradeWapPayRequest;
        }else{
            AlipayTradePagePayModel alipayTradePagePayModel = new AlipayTradePagePayModel();
            alipayTradePagePayModel.setOutTradeNo(paymentTransaction.getSn());
            alipayTradePagePayModel.setProductCode("FAST_INSTANT_TRADE_PAY");
            alipayTradePagePayModel.setTotalAmount(String.valueOf(paymentTransaction.getAmount().setScale(2)));
            alipayTradePagePayModel.setSubject(StringUtils.abbreviate(paymentDescription.replaceAll("[^0-9a-zA-Z\\u4e00-\\u9fa5 ]", StringUtils.EMPTY), 60));

            AlipayTradePagePayRequest alipayTradePagePayRequest = new AlipayTradePagePayRequest();
            alipayTradePagePayRequest.setReturnUrl(getPostPayUrl(paymentPlugin, paymentTransaction));
            alipayTradePagePayRequest.setNotifyUrl(getPostPayUrl(paymentPlugin, paymentTransaction));
            alipayTradePagePayRequest.setBizModel(alipayTradePagePayModel);
            alipayRequest=alipayTradePagePayRequest;
        }
        try {
            modelAndView.addObject("body", getAlipayClient().pageExecute(alipayRequest).getBody());
            modelAndView.setViewName("net/shopxx/plugin/alipayPayment/pay");
        } catch (AlipayApiException e) {
            modelAndView.addObject("errorMessage", SpringUtils.getMessage("admin.plugin.alipayPayment.paymentConfigurationError", getName()));
            modelAndView.setViewName("common/error/unprocessable_entity");
        }
    }

    @Override
    public boolean isPaySuccess(PaymentPlugin paymentPlugin, PaymentTransaction paymentTransaction, String paymentDescription, String extra, HttpServletRequest request, HttpServletResponse response) throws Exception {
        AlipayTradeQueryModel alipayTradeQueryModel = new AlipayTradeQueryModel();
        alipayTradeQueryModel.setOutTradeNo(paymentTransaction.getSn());
        alipayTradeQueryModel.setTradeNo(request.getParameter("trade_no"));

        AlipayTradeQueryRequest alipayTradeQueryRequest = new AlipayTradeQueryRequest();
        alipayTradeQueryRequest.setBizModel(alipayTradeQueryModel);
        try {

            AlipayTradeQueryResponse alipayTradeQueryResponse = getAlipayClient().execute(alipayTradeQueryRequest);
            return alipayTradeQueryResponse.isSuccess() && (StringUtils.equalsIgnoreCase(alipayTradeQueryResponse.getTradeStatus(), "TRADE_SUCCESS") || StringUtils.equalsIgnoreCase(alipayTradeQueryResponse.getTradeStatus(), "TRADE_FINISHED"))
                    && paymentTransaction.getAmount().compareTo(new BigDecimal(alipayTradeQueryResponse.getTotalAmount())) == 0;
        } catch (AlipayApiException e) {
            throw new RuntimeException(e.getMessage(), e);
        }
    }

    @Override
    public boolean cancel(String outTradeNo) {
        return false;
    }

    @Override
    public boolean refund(PaymentTransaction paymentTransaction, String refundSn, BigDecimal refundAmount, String refundReason){
        AlipayRefundParam alipayRefundParam = new AlipayRefundParam.Builder()
                .refundAmount(refundAmount.setScale(2).toString())      //退款金额
                .outTradeNo(paymentTransaction.getSn())                 //商户订单号
                .refundReason(refundReason)                             //退款原因
                .out_request_no(refundSn)                              //标识一次退款请求，同一笔交易多次退款需要保证唯一，如需部分退款，则此参数必传。
                .build();
        try {
            return refundHandle(alipayRefundParam);
        } catch (BusinessException e) {
            e.printStackTrace();
            return false;
        }
    }
    public boolean refundHandle(AlipayRefundParam alipayRefundParam) throws BusinessException {
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
            logger.error("支付宝退款失败" + alipayRefundParam.getOutTradeNo());
        }
        return response.isSuccess();
    }
    /**
     * 获取AppID
     *
     * @return AppID
     */
    private String getAppId() {
        return getAttribute("appId");
    }

    /**
     * 获取开发者应用私钥
     *
     * @return 开发者应用私钥
     */
    private String getAppPrivateKey() {
        return getAttribute("appPrivateKey");
    }

    /**
     * 获取支付宝公钥
     *
     * @return 支付宝公钥
     */
    private String getAlipayPublicKey() {
        return getAttribute("alipayPublicKey");
    }

    /**
     * 获取AlipayClient
     *
     * @return AlipayClient
     */
    private AlipayClient getAlipayClient() {
        return new DefaultAlipayClient(SERVER_URL, getAppId(), getAppPrivateKey(), "json", "UTF-8", getAlipayPublicKey(), "RSA2");
    }

}
