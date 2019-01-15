package net.shopxx.plugin.weixinNativePayment;

import java.awt.image.BufferedImage;
import java.io.*;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;
import java.util.TreeMap;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.github.wxpay.sdk.WXPayConstants;
import net.shopxx.exception.BusinessException;
import net.shopxx.exception.ErrorCode;
import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.RandomStringUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.net.util.Base64;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.mobile.device.Device;
import org.springframework.mobile.device.DeviceUtils;
import org.springframework.stereotype.Component;
import org.springframework.util.ResourceUtils;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.core.type.TypeReference;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.WriterException;
import com.google.zxing.common.BitMatrix;

import net.shopxx.entity.PaymentTransaction;
import net.shopxx.entity.PluginConfig;
import net.shopxx.plugin.PaymentPlugin;
import net.shopxx.util.WebUtils;
import net.shopxx.util.XmlUtils;

/**
 * Plugin微信支付(扫码支付)
 */
@Component("weixinNativePaymentPlugin")
public class WeixinNativePaymentPlugin extends PaymentPlugin {

	private static Logger logger = LoggerFactory.getLogger(WeixinNativePaymentPlugin.class);
	//微信证书在classpath下的位置
	private static final String CERT_FILE_PATH="1440873102_20180914_cert.p12";
	//code_url请求URL
	private static final String CODE_URL_REQUEST_URL = "https://api.mch.weixin.qq.com/pay/unifiedorder";
	//退款请求URL
	public static final String REFUND_URL= "https://api.mch.weixin.qq.com/secapi/pay/refund";
	// 查询订单请求URL
	private static final String ORDER_QUERY_REQUEST_URL = "https://api.mch.weixin.qq.com/pay/orderquery";

	/*
	//沙箱环境
	//1.使用沙箱环境前需要获取沙箱APIKEY，可参考https://pay.weixin.qq.com/wiki/doc/api/native.php?chapter=23_1或直接运行test.weixintest.Sandbox.class的main方法获得
	//2.将请求的域名后加/sandboxnew，就是下面的链接
	//3.手机微信关注“微信支付商户验收助手”-我的验收-查询验收用例中绑定微信商家后设置支付的case，，必须与本次支付的金额相同
	//4.在网站中使用微信支付即可
	//code_url请求URL
	private static final String CODE_URL_REQUEST_URL = "https://api.mch.weixin.qq.com/sandboxnew/pay/unifiedorder";
	//退款请求URL
	public static final String REFUND_URL= "https://api.mch.weixin.qq.com/sandboxnew/secapi/pay/refund";
	// 查询订单请求URL
	private static final String ORDER_QUERY_REQUEST_URL = "https://api.mch.weixin.qq.com/sandboxnew/pay/orderquery";
	*/
	@Override
	public String getName() {
		return "微信支付(扫码支付)";
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
		return "weixin_native_payment/install";
	}

	@Override
	public String getUninstallUrl() {
		return "weixin_native_payment/uninstall";
	}

	@Override
	public String getSettingUrl() {
		return "weixin_native_payment/setting";
	}

	@Override
	public boolean supports(HttpServletRequest request) {
		Device device = DeviceUtils.getCurrentDevice(request);
		return device != null && (device.isNormal() || device.isTablet());
	}

	@Override
	public void payHandle(PaymentPlugin paymentPlugin, PaymentTransaction paymentTransaction, String paymentDescription, String extra, HttpServletRequest request, HttpServletResponse response, ModelAndView modelAndView) throws Exception {
		Map<String, Object> parameterMap = new HashMap<>();
		parameterMap.put("appid", getAppId());
		parameterMap.put("mch_id", getMchId());
		parameterMap.put("nonce_str", DigestUtils.md5Hex(UUID.randomUUID() + RandomStringUtils.randomAlphabetic(30)));
		parameterMap.put("body", StringUtils.abbreviate(paymentDescription.replaceAll("[^0-9a-zA-Z\\u4e00-\\u9fa5 ]", ""), 600));
		parameterMap.put("out_trade_no", paymentTransaction.getSn());
		parameterMap.put("total_fee", paymentTransaction.getAmount().multiply(new BigDecimal(100)).setScale(0).toString());
		parameterMap.put("spbill_create_ip", request.getLocalAddr());
		parameterMap.put("notify_url", getPostPayUrl(paymentPlugin, paymentTransaction));
		parameterMap.put("trade_type", "NATIVE");
		parameterMap.put("product_id", paymentTransaction.getSn());
		parameterMap.put("sign", generateSign(parameterMap));
		String result = WebUtils.post(CODE_URL_REQUEST_URL, XmlUtils.toXml(parameterMap));
		Map<String, String> resultMap = XmlUtils.toObject(result, new TypeReference<Map<String, String>>() {});
		String returnCode = resultMap.get("return_code");
		String resultCode = resultMap.get("result_code");
		String tradeType = resultMap.get("trade_type");
		modelAndView.addObject("imageBase64", paymentTransaction.getUser());
		if (StringUtils.equals(returnCode, "SUCCESS") && StringUtils.equals(resultCode, "SUCCESS") && StringUtils.equals(tradeType, "NATIVE")) {
			String codeUrl = resultMap.get("code_url");
			ByteArrayOutputStream arrayOutputStream = new ByteArrayOutputStream();
			try {
				BufferedImage image = generateQrcode(codeUrl, 300, 300);
				ImageIO.write(image, "jpg", arrayOutputStream);
				modelAndView.addObject("imageBase64", Base64.encodeBase64String(arrayOutputStream.toByteArray()));
				modelAndView.addObject("paymentTransactionSn", paymentTransaction.getSn());
				modelAndView.setViewName("net/shopxx/plugin/weixinNativePayment/pay");
			} catch (IOException e) {
				throw new RuntimeException(e.getMessage(), e);
			} finally {
				IOUtils.closeQuietly(arrayOutputStream);
			}
		} else if (StringUtils.equals(returnCode, "FAIL") || StringUtils.equals(resultCode, "FAIL")) {
			String returnMsg = resultMap.get("return_msg");
			modelAndView.addObject("errorMessage", returnMsg);
			modelAndView.setViewName("common/error/unprocessable_entity");
		}

	}

	@Override
	public void postPayHandle(PaymentPlugin paymentPlugin, PaymentTransaction paymentTransaction, String paymentDescription, String extra, boolean isPaySuccess, HttpServletRequest request, HttpServletResponse response, ModelAndView modelAndView) throws Exception {
		super.postPayHandle(paymentPlugin, paymentTransaction, paymentDescription, extra, isPaySuccess, request, response, modelAndView);

		String xml = IOUtils.toString(request.getInputStream(), "UTF-8");
		if (StringUtils.isEmpty(xml)) {
			return;
		}
		Map<String, String> resultMap = XmlUtils.toObject(xml, new TypeReference<Map<String, String>>() {
		});
		if (StringUtils.equals(resultMap.get("return_code"), "SUCCESS")) {
			modelAndView.addObject("message", "<xml><return_code><![CDATA[SUCCESS]]></return_code><return_msg><![CDATA[OK]]></return_msg></xml>");
		}
	}

	@Override
	public boolean isPaySuccess(PaymentPlugin paymentPlugin, PaymentTransaction paymentTransaction, String paymentDescription, String extra, HttpServletRequest request, HttpServletResponse response) throws Exception {
		Map<String, Object> parameterMap = new TreeMap<>();
		parameterMap.put("appid", getAppId());
		parameterMap.put("mch_id", getMchId());
		parameterMap.put("out_trade_no", paymentTransaction.getSn());
		parameterMap.put("nonce_str", DigestUtils.md5Hex(UUID.randomUUID() + RandomStringUtils.randomAlphabetic(30)));
		parameterMap.put("sign", generateSign(parameterMap));
		String result = WebUtils.post(ORDER_QUERY_REQUEST_URL, XmlUtils.toXml(parameterMap));
		Map<String, String> resultMap = XmlUtils.toObject(result, new TypeReference<Map<String, String>>() {
		});
		return StringUtils.equals(resultMap.get("return_code"), "SUCCESS") && StringUtils.equals(resultMap.get("result_code"), "SUCCESS") && StringUtils.equals(resultMap.get("trade_state"), "SUCCESS")
				&& paymentTransaction.getAmount().multiply(new BigDecimal(100)).compareTo(new BigDecimal(resultMap.get("total_fee"))) == 0;
	}

	@Override
	public boolean cancel(String outTradeNo) {
		return false;
	}

	@Override
	public boolean refund(PaymentTransaction paymentTransaction, String refundSn, BigDecimal refundAmount, String refundReason) {
		Map<String, String> parameters = new HashMap<>();
		parameters.put("appid", getAppId());
		parameters.put("mch_id", getMchId());// 商户号
		parameters.put("nonce_str", DigestUtils.md5Hex(UUID.randomUUID() + RandomStringUtils.randomAlphabetic(30)));// 32位随机数
		parameters.put("notify_url", getPostrefundUrl(this,paymentTransaction));// 退款回调url
		parameters.put("out_trade_no", paymentTransaction.getSn());// 订单编号
		parameters.put("out_refund_no", refundSn);//退款单号
		parameters.put("total_fee", String.valueOf(paymentTransaction.getAmount().multiply(new BigDecimal(100)).intValue()));// 订单金额,单位分
		parameters.put("refund_fee", String.valueOf(refundAmount.multiply(new BigDecimal(100)).intValue()));// 退款金额,单位分
		//parameters.put("transaction_id", "");   //微信交易单号与商家订单号(out_trade_no)二选一
		parameters.put("refund_desc", refundReason);
        parameters.put("sign", generateSign(parameters));
		try {
			return refundHandle(parameters,0);
		}catch (BusinessException e){
			e.printStackTrace();
			return false;
		}
	}
	public boolean refundHandle(Map<String, String> parameters,int count) throws BusinessException {
		//String result = WebUtils.post(REFUND_URL, XmlUtils.toXml(parameters));
		String result = WebUtils.postWithCert(REFUND_URL,parameters,getCertStream(),parameters.get("mch_id"));
		Map<String, String> responseMap = XmlUtils.toObject(result, new TypeReference<Map<String, String>>() {});
		if (StringUtils.isBlank(responseMap.get("result_code"))) {
			String errorMsg = StringUtils.isNotBlank(responseMap.get("return_msg")) ? responseMap.get("return_msg") : responseMap.get("err_code_des");
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
				return refundHandle(parameters, ++count);
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
	/**
	 * 获取公众号ID
	 * 
	 * @return 公众号ID
	 */
	private String getAppId() {
		PluginConfig pluginConfig = getPluginConfig();
		return pluginConfig.getAttribute("appId");
	}

	/**
	 * 获取商户号
	 * 
	 * @return 商户号
	 */
	private String getMchId() {
		PluginConfig pluginConfig = getPluginConfig();
		return pluginConfig.getAttribute("mchId");
	}

	/**
	 * 生成签名
	 * 
	 * @param parameterMap
	 *            参数
	 * @return 签名
	 */
	private String generateSign(Map<String, ?> parameterMap) {
		PluginConfig pluginConfig = getPluginConfig();
		return StringUtils.upperCase(DigestUtils.md5Hex(joinKeyValue(new TreeMap<>(parameterMap), null, "&key=" + pluginConfig.getAttribute("apiKey"), "&", true)));
	}

	/**
	 * 生成二维码图片
	 * 
	 * @param text
	 *            内容
	 * @param width
	 *            宽度
	 * @param height
	 *            高度
	 * @return 二维码图片
	 */
	public BufferedImage generateQrcode(String text, int width, int height) {
		int WHITE = 0xFFFFFFFF;
		int BLACK = 0xFF000000;
		Map<EncodeHintType, Object> hints = new HashMap<EncodeHintType, Object>();
		hints.put(EncodeHintType.CHARACTER_SET, "UTF-8");
		hints.put(EncodeHintType.MARGIN, 0);
		try {
			BitMatrix bitMatrix = new MultiFormatWriter().encode(text, BarcodeFormat.QR_CODE, width, height, hints);
			BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
			for (int x = 0; x < width; x++) {
				for (int y = 0; y < height; y++) {
					image.setRGB(x, y, bitMatrix.get(x, y) ? BLACK : WHITE);
				}
			}
			return image;
		} catch (WriterException e) {
			throw new RuntimeException(e.getMessage(), e);
		}
	}

	public InputStream getCertStream() {
		InputStream is = null;
		try {
			File file=ResourceUtils.getFile("classpath:"+CERT_FILE_PATH);
			is = new FileInputStream(file);
		} catch (FileNotFoundException e) {
			e.printStackTrace();
			throw new RuntimeException("微信支付证书加载失败");
		}
		return is;
	}

}