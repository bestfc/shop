package net.shopxx.util.tencent;


import com.alibaba.fastjson.JSON;
import com.fasterxml.jackson.core.type.TypeReference;

import com.github.wxpay.sdk.WXPay;
import com.github.wxpay.sdk.WXPayConfig;
import com.github.wxpay.sdk.WXPayConstants;
import net.shopxx.exception.BusinessException;
import net.shopxx.exception.ErrorCode;
import net.shopxx.util.PropertiesUtil;
import net.shopxx.util.WebUtils;
import net.shopxx.util.XmlUtils;
import org.apache.commons.beanutils.ConvertUtils;
import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.httpclient.NameValuePair;
import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang.RandomStringUtils;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.xml.sax.SAXException;

import javax.annotation.PostConstruct;
import javax.servlet.http.HttpServletRequest;
import javax.xml.parsers.ParserConfigurationException;
import java.io.*;
import java.util.*;
import java.util.concurrent.TimeUnit;

@Service("wechatUtils")
public class WechatUtils implements WXPayConfig {
    @Autowired
    private PropertiesUtil propertiesUtil;

    private static Logger logger = LoggerFactory.getLogger(WechatUtils.class);

    /** appId*/
    private String APP_ID;
    private String WECHAT_SECRET ;
    private String WECHAT_REDIRECTURL ;
    /** 商户号*/
    private String MCH_ID;
    public String PAY_ENCODE_KEY;
    /** 支付回调地址*/
    private String NOTIFTY_URL ;
    /** 退款回调地址*/
    private String REFUND_NOTIFTY_URL;
    private boolean USESANDBOX ;
    private String certfile;

    @PostConstruct
    public void setValue(){
        APP_ID = propertiesUtil.getValue("wechatapp.APP_ID");
        WECHAT_SECRET = propertiesUtil.getValue("wechatapp.WECHAT_SECRET");
        WECHAT_REDIRECTURL = propertiesUtil.getValue("wechatapp.WECHAT_REDIRECTURL");
        APP_ID=propertiesUtil.getValue("wechatapp.APP_ID");
        MCH_ID=propertiesUtil.getValue("wechatapp.MCH_ID");
        PAY_ENCODE_KEY=propertiesUtil.getValue("wechatapp.PAY_ENCODE_KEY");
        NOTIFTY_URL=propertiesUtil.getValue("wechatapp.NOTIFTY_URL");
        REFUND_NOTIFTY_URL=propertiesUtil.getValue("wechatapp.REFUND_NOTIFTY_URL");
        USESANDBOX=Boolean.valueOf(propertiesUtil.getValue("wechatapp.USESANDBOX")).booleanValue();
        certfile=propertiesUtil.getValue("wechatapp.certfile");
    }

    //#####微信APP登陆START#####
    /**
     * @param code
     * @return 实际返回unionid
     */
    @SuppressWarnings("unchecked")
    public final String getWechatOpenid(String code) throws BusinessException {
        NameValuePair[] params = new NameValuePair[5];
        params[0] = new NameValuePair("grant_type", "authorization_code");
        params[1] = new NameValuePair("appid", APP_ID);
        params[2] = new NameValuePair("secret", WECHAT_SECRET);
        params[3] = new NameValuePair("code", code);
        params[4] = new NameValuePair("redirect_uri", WECHAT_REDIRECTURL);
        String tokenReponseStr = WebUtils.post("https://api.weixin.qq.com/sns/oauth2/access_token", params);
        if (tokenReponseStr != null && tokenReponseStr.indexOf("access_token") > -1) {
            Map<String, Object> tokenMap = JSON.parseObject(tokenReponseStr, Map.class);
            String access_token = tokenMap.get("access_token").toString();
            String openid = tokenMap.get("openid").toString();
            return getUnionID(access_token, openid);
        } else {
            logger.error(tokenReponseStr);
            throw new BusinessException(ErrorCode.THIRD_ERROR_WECHAT_LOGIN_NOTOKEN);
        }
    }

    public String getUnionID(String access_token, String openid) throws BusinessException {
        NameValuePair[] params = new NameValuePair[2];
        params[0] = new NameValuePair("access_token", access_token);
        params[1] = new NameValuePair("openid", openid);
        String tokenReponseStr = WebUtils.post("https://api.weixin.qq.com/sns/userinfo", params);
        if (tokenReponseStr != null && tokenReponseStr.indexOf("unionid") > -1) {
            Map<String, Object> map = JSON.parseObject(tokenReponseStr, Map.class);
            return map.get("unionid").toString();
        } else {
            logger.error(tokenReponseStr);
            throw new BusinessException(ErrorCode.THIRD_ERROR_WECHAT_LOGIN_NOTOKEN);
        }
    }
    //#####微信APP登陆END####


    //#####微信支付START#####
    /**查询订单请求URL*/
    private static String ORDER_QUERY_REQUEST_URL = "https://api.mch.weixin.qq.com/pay/orderquery";
    /** 退款URL*/
    private static final String REFUND_URL = "https://api.mch.weixin.qq.com/secapi/pay/refund";
    /**退款查询URL*/
    private static final String REFUND_QUERY_URL = "https://api.mch.weixin.qq.com/pay/refundquery";

    private WXPay wxPay = null;

    private WXPay getWXPayInstance() {
        if (null == wxPay) {
            wxPay = new WXPay(this, WXPayConstants.SignType.MD5, USESANDBOX);
        }
        return wxPay;
    }

    /**
     * 连接Map键值对
     *
     * @param map              Map
     * @param prefix           前缀
     * @param suffix           后缀
     * @param separator        连接符
     * @param ignoreEmptyValue 忽略空值
     * @param ignoreKeys       忽略Key
     * @return 字符串
     */
    protected static String joinKeyValue(Map<String, Object> map, String prefix, String suffix, String separator,
                                         boolean ignoreEmptyValue, String... ignoreKeys) {
        List<String> list = new ArrayList<>();
        if (map != null) {
            for (Map.Entry<String, Object> entry : map.entrySet()) {
                String key = entry.getKey();
                String value = ConvertUtils.convert(entry.getValue());
                if (StringUtils.isNotEmpty(key) && !ArrayUtils.contains(ignoreKeys, key)
                        && (!ignoreEmptyValue || StringUtils.isNotEmpty(value))) {
                    list.add(key + "=" + (value != null ? value : ""));
                }
            }
        }
        return (prefix != null ? prefix : "") + StringUtils.join(list, separator) + (suffix != null ? suffix : "");
    }

    /**
     * 微信支付签名算法sign
     * tom
     * @param parameters
     * @return
     */
    public static String createSign(Map<String, Object> parameters, String payKey) {
        return StringUtils.upperCase(DigestUtils
                .md5Hex(joinKeyValue(parameters, null, "&key=" + payKey, "&", true)));
    }

    protected String generateSign(Map<String, Object> parameters) {
        return createSign(parameters, PAY_ENCODE_KEY);
    }

    /**
     * 获取客户端真实IP
     */
    private String getRealIp(HttpServletRequest request) {
        String realIp = request.getHeader("X-Forwarded-For");
        if (StringUtils.isNotEmpty(realIp) && !StringUtils.equalsIgnoreCase("unknown", realIp)) {
            String[] realIps = StringUtils.split(realIp, ",");
            if (ArrayUtils.isNotEmpty(realIps)) {
                return realIps[0];
            } else {
                return realIp;
            }
        }
        realIp = request.getHeader("X-Real-IP");
        if (StringUtils.isNotEmpty(realIp) && !StringUtils.equalsIgnoreCase("unknown", realIp)) {
            return realIp;
        }
        return request.getRemoteAddr();
    }

    public Map<String, Object> prePay(String total_fee, String out_trade_no, String attach, String body,
                                      HttpServletRequest request) throws BusinessException {
        if (StringUtils.isBlank(total_fee) || StringUtils.isBlank(out_trade_no) || StringUtils.isBlank(attach)) {
            throw new BusinessException(ErrorCode.INVALID_PARAMETERS);
        }

        Map<String, String> requestParam = new HashMap<String, String>();
        requestParam.put("appid", APP_ID);
        requestParam.put("mch_id", MCH_ID);// 商户号
        requestParam.put("nonce_str", UUID.randomUUID().toString().replace("-", ""));// 32位随机数
        requestParam.put("attach", attach);// 附加数据
        requestParam.put("body", body);// body
        requestParam.put("notify_url", NOTIFTY_URL);// 回调url
        requestParam.put("out_trade_no", out_trade_no);// 订单编号
        requestParam.put("spbill_create_ip", getRealIp(request));// 用户的真实ip
        requestParam.put("total_fee", total_fee);// 总价格,单位分
        requestParam.put("trade_type", "APP");// 支付类型

        WXPay wxPay = getWXPayInstance();
        Map<String, String> responseMap = null;
        try {
            responseMap = wxPay.unifiedOrder(requestParam);
        } catch (Exception e) {
            e.printStackTrace();
            throw new BusinessException(ErrorCode.THIRD_ERROR_WECHAT_EXECFAIL);
        }
        if (WXPayConstants.SUCCESS.equals(responseMap.get("result_code"))) {
            SortedMap<String, Object> resultParters = new TreeMap<String, Object>();
            resultParters.put("appid", APP_ID);
            resultParters.put("timestamp", new Date().getTime() / 1000);// 10位数的时间戳
            resultParters.put("noncestr", responseMap.get("nonce_str"));// 随机数
            resultParters.put("partnerid", MCH_ID);// 商户号
            resultParters.put("prepayid", responseMap.get("prepay_id"));// 微信返回的订单Id
            resultParters.put("package", "Sign=WXPay");// app支付这里写死
            // TODO二次签名,不能使用微信返回来的sign
            resultParters.put("sign", generateSign(resultParters));
            return resultParters;
        }
        throw new BusinessException(ErrorCode.THIRD_ERROR_WHCHAT_CALCELRETERROR, responseMap.get("return_msg"));
    }

    /**
     * 检验API返回的数据里面的签名是否合法，避免数据在传输的过程中被第三方篡改
     *
     * @param map API返回的XML数据字符串
     * @return API签名是否合法
     * @throws ParserConfigurationException
     * @throws IOException
     * @throws SAXException
     */
    public boolean checkIsSignValidFromResponseString(Map<String, String> map) {
        if (null == map.get("return_code") || "FAIL".equals(map.get("return_code")))
            return false;//如果微信返回码为FAIL代表支付失败

        if (null == map.get("sign")) {
//        	log.info("API返回的数据签名数据不存在，有可能被第三方篡改!!!");
            return false;
        }
        String signFromAPIResponse = map.get("sign").toString();
//        log.info("服务器回包里面的签名是:" + signFromAPIResponse);
        //清掉返回数据对象里面的Sign数据（不能把这个数据也加进去进行签名），然后用签名算法进行签名
        map.put("sign", "");
        Map<String, Object> sortedMap = new TreeMap<String, Object>();
        sortedMap.putAll(map);
        //将API返回的数据根据用签名算法进行计算新的签名，用来跟API返回的签名进行比较
        String signForAPIResponse = generateSign(sortedMap);
        if (!signForAPIResponse.equals(signFromAPIResponse)) {
            return false;
        }
        return true;
    }

    public Map<String, String> query(String outTradeNo) throws BusinessException {
        Map<String, Object> parameterMap = new TreeMap<>();
        parameterMap.put("appid", APP_ID);
        parameterMap.put("mch_id", MCH_ID);
        parameterMap.put("out_trade_no", outTradeNo);
        parameterMap.put("nonce_str",
                DigestUtils.md5Hex(UUID.randomUUID() + RandomStringUtils.randomAlphabetic(30)));
        parameterMap.put("sign", generateSign(parameterMap));
        String result = WebUtils.post(ORDER_QUERY_REQUEST_URL, XmlUtils.toXml(parameterMap));
        Map<String, String> ret = XmlUtils.toObject(result, new TypeReference<Map<String, String>>() {
        });
        if (!checkIsSignValidFromResponseString(ret)) {
            throw new BusinessException(ErrorCode.THIRD_ERROR_WHCHAT_SIGNERROR);
        }
        return ret;
    }

    public boolean cancel(String out_trade_no, int count) throws BusinessException {
        Map<String, String> requestParam = new HashMap<>();
        requestParam.put("out_trade_no", out_trade_no);
        WXPay wxPay = getWXPayInstance();
        Map<String, String> responseMap = null;
        try {
            responseMap = wxPay.reverse(requestParam);
        } catch (Exception e) {
            e.printStackTrace();
            throw new BusinessException(ErrorCode.THIRD_ERROR_WECHAT_EXECFAIL);
        }
        if (WXPayConstants.FAIL.equals(responseMap.get("result_code"))) {
            throw new BusinessException(ErrorCode.THIRD_ERROR_WHCHAT_CALCELRETERROR, responseMap.get("return_msg"));
        }
        if ("N".equals(responseMap.get("recall")))
            return true;
        if ("SYSTEMERROR".equals(responseMap.get("err_code"))) {
            //未知异常无法确定订单是否完成，开始轮询查询订单，三秒调用一次，执行十秒
            if (count < 10) {
                try {
                    TimeUnit.SECONDS.sleep(3);
                } catch (InterruptedException e) {
                    logger.error("微信订单查询定时器失败,订单号:" + out_trade_no + ",当前请求次数:" + count);
                }
                return cancel(out_trade_no, ++count);
            } else {
                throw new BusinessException(ErrorCode.THIRD_ERROR_WHCHAT_UNKNOWERR, "微信订单异常,商家订单编号:" + out_trade_no);
            }
        } else {
            String errorMsg = responseMap.get("err_code_des");
            if(errorMsg == null){
                errorMsg = responseMap.get("return_msg");
            }
            else{
                errorMsg += responseMap.get("err_code_des");
            }
            throw new BusinessException(ErrorCode.THIRD_ERROR_WHCHAT_CALCELRETERROR, errorMsg);
        }
    }

    public boolean refund(Map<String, String> parameters, int count) throws BusinessException {
        WXPay wxPay = getWXPayInstance();
        Map<String, String> responseMap = null;
        try {
            responseMap = wxPay.refund(parameters);
        } catch (Exception e) {
            e.printStackTrace();
            throw new BusinessException(ErrorCode.THIRD_ERROR_WECHAT_EXECFAIL);
        }
        if (StringUtils.isBlank(responseMap.get("result_code"))) {
            String errorMsg = StringUtils.isNotBlank(responseMap.get("return_msg"))
                    ? responseMap.get("return_msg") : responseMap.get("err_code_des");
            throw new BusinessException(ErrorCode.THIRD_ERROR_WHCHAT_CALCELRETERROR, errorMsg);
        }
        if (WXPayConstants.SUCCESS.equals(responseMap.get("result_code")))
            return true;
        if ("SYSTEMERROR".equals(responseMap.get("err_code"))) {
            //未知异常无法确定订单是否完成，开始轮询查询订单，三秒调用一次，执行十秒
            if (count < 10) {
                try {
                    TimeUnit.SECONDS.sleep(3);
                } catch (InterruptedException e) {
                    logger.error("微信订单退款失败,订单号:" + parameters.get("out_trade_no") + ",当前请求次数:" + count);
                }
                return refund(parameters, ++count);
            } else {
                throw new BusinessException(ErrorCode.THIRD_ERROR_WHCHAT_UNKNOWERR, "微信订单异常,商家订单编号:" + parameters.get("out_trade_no"));
            }
        } else {
            String errorMsg = responseMap.get("err_code_des");
            if(errorMsg == null){
                errorMsg = responseMap.get("return_msg");
            }
            else{
                errorMsg += responseMap.get("err_code_des");
            }
            throw new BusinessException(ErrorCode.THIRD_ERROR_WHCHAT_CALCELRETERROR, errorMsg);
        }
    }

    public boolean refund(String total_fee, String refund_fee, String out_trade_no, String out_refund_no, String reason, int count) throws BusinessException {
        if (StringUtils.isBlank(total_fee) || StringUtils.isBlank(refund_fee) || StringUtils.isBlank(out_trade_no) || StringUtils.isBlank(out_refund_no)) {
            throw new BusinessException(ErrorCode.INVALID_PARAMETERS);
        }
        Map<String, String> parameters = new HashMap<>();
        parameters.put("appid", APP_ID);
        parameters.put("mch_id", MCH_ID);// 商户号
        parameters.put("nonce_str", UUID.randomUUID().toString().replace("-", ""));// 32位随机数
        parameters.put("notify_url", REFUND_NOTIFTY_URL);// 退款回调url
        parameters.put("out_trade_no", out_trade_no);// 订单编号
        parameters.put("out_refund_no", out_refund_no);//退款单号
        parameters.put("total_fee", total_fee);// 订单金额,单位分
        parameters.put("refund_fee", refund_fee);// 退款金额,单位分
     //   parameters.put("transaction_id", "");
        parameters.put("refund_desc", reason);
        return refund(parameters, 0);
    }

    @Override
    public String getAppID() {
        return APP_ID;
    }

    @Override
    public String getMchID() {
        return MCH_ID;
    }

    @Override
    public String getKey() {
        return PAY_ENCODE_KEY;
    }

    @Override
    public InputStream getCertStream() {
        String path2 = Thread.currentThread().getContextClassLoader().getResource("").getPath();
        InputStream is = null;
        try {
            is = new FileInputStream(new File(path2 + certfile));
        } catch (FileNotFoundException e) {
            e.printStackTrace();
            throw new RuntimeException("微信支付证书加载失败");
        }
        return is;
    }

    @Override
    public int getHttpConnectTimeoutMs() {
        return 10000;
    }

    @Override
    public int getHttpReadTimeoutMs() {
        return 10000;
    }

    /**
     * 微信支付END
     */
}
