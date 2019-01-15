/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.plugin.yeepayPayment;

import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.LinkedHashMap;
import java.util.Map;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.ModelAndView;

import net.shopxx.entity.PaymentTransaction;
import net.shopxx.entity.PluginConfig;
import net.shopxx.plugin.PaymentPlugin;
import net.shopxx.util.WebUtils;

/**
 * Plugin易宝支付
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Component("yeepayPaymentPlugin")
public class YeepayPaymentPlugin extends PaymentPlugin {

	@Override
	public String getName() {
		return "易宝支付";
	}

	@Override
	public String getVersion() {
		return "1.0";
	}

	@Override
	public String getAuthor() {
		return "SHOP++";
	}

	@Override
	public String getSiteUrl() {
		return "http://www.shopxx.net";
	}

	@Override
	public String getInstallUrl() {
		return "yeepay_payment/install";
	}

	@Override
	public String getUninstallUrl() {
		return "yeepay_payment/uninstall";
	}

	@Override
	public String getSettingUrl() {
		return "yeepay_payment/setting";
	}

	@Override
	public void payHandle(PaymentPlugin paymentPlugin, PaymentTransaction paymentTransaction, String paymentDescription, String extra, HttpServletRequest request, HttpServletResponse response, ModelAndView modelAndView) throws Exception {
		PluginConfig pluginConfig = getPluginConfig();
		Map<String, Object> parameterMap = new LinkedHashMap<>();
		parameterMap.put("p0_Cmd", "Buy");
		parameterMap.put("p1_MerId", pluginConfig.getAttribute("partner"));
		parameterMap.put("p2_Order", paymentTransaction.getSn());
		parameterMap.put("p3_Amt", paymentTransaction.getAmount().setScale(2).toString());
		parameterMap.put("p4_Cur", "CNY");
		parameterMap.put("p5_Pid", StringUtils.abbreviate(paymentDescription.replaceAll("[^0-9a-zA-Z\\u4e00-\\u9fa5 ]", ""), 20));
		parameterMap.put("p7_Pdesc", StringUtils.abbreviate(paymentDescription.replaceAll("[^0-9a-zA-Z\\u4e00-\\u9fa5 ]", ""), 20));
		parameterMap.put("p8_Url", getPostPayUrl(paymentPlugin, paymentTransaction));
		parameterMap.put("p9_SAF", "0");
		parameterMap.put("pa_MP", "shopxx");
		parameterMap.put("pr_NeedResponse", "1");
		parameterMap.put("hmac", generateSign(parameterMap));

		modelAndView.addObject("requestUrl", "https://www.yeepay.com/app-merchant-proxy/node");
		modelAndView.addObject("requestCharset", "GBK");
		modelAndView.addObject("parameterMap", parameterMap);
		modelAndView.setViewName(PaymentPlugin.DEFAULT_PAY_VIEW_NAME);
	}

	@Override
	public void postPayHandle(PaymentPlugin paymentPlugin, PaymentTransaction paymentTransaction, String paymentDescription, String extra, boolean isPaySuccess, HttpServletRequest request, HttpServletResponse response, ModelAndView modelAndView) throws Exception {
		super.postPayHandle(paymentPlugin, paymentTransaction, paymentDescription, extra, isPaySuccess, request, response, modelAndView);

		if ("2".equals(WebUtils.parse(request.getQueryString(), "GBK").get("r9_BType"))) {
			modelAndView.addObject("message", "success");
		}
	}

	@Override
	public boolean isPaySuccess(PaymentPlugin paymentPlugin, PaymentTransaction paymentTransaction, String paymentDescription, String extra, HttpServletRequest request, HttpServletResponse response) throws Exception {
		PluginConfig pluginConfig = getPluginConfig();
		Map<String, String> parameterValuesMap = WebUtils.parse(request.getQueryString(), "GBK");
		Map<String, Object> parameterMap = new LinkedHashMap<>();
		parameterMap.put("p1_MerId", parameterValuesMap.get("p1_MerId"));
		parameterMap.put("r0_Cmd", parameterValuesMap.get("r0_Cmd"));
		parameterMap.put("r1_Code", parameterValuesMap.get("r1_Code"));
		parameterMap.put("r2_TrxId", parameterValuesMap.get("r2_TrxId"));
		parameterMap.put("r3_Amt", parameterValuesMap.get("r3_Amt"));
		parameterMap.put("r4_Cur", parameterValuesMap.get("r4_Cur"));
		parameterMap.put("r5_Pid", parameterValuesMap.get("r5_Pid"));
		parameterMap.put("r6_Order", parameterValuesMap.get("r6_Order"));
		parameterMap.put("r7_Uid", parameterValuesMap.get("r7_Uid"));
		parameterMap.put("r8_MP", parameterValuesMap.get("r8_MP"));
		parameterMap.put("r9_BType", parameterValuesMap.get("r9_BType"));
		if (StringUtils.equals(generateSign(parameterMap), parameterValuesMap.get("hmac")) && StringUtils.equals(pluginConfig.getAttribute("partner"), parameterValuesMap.get("p1_MerId")) && StringUtils.equals(parameterValuesMap.get("r1_Code"), "1")
				&& paymentTransaction.getAmount().compareTo(new BigDecimal(parameterValuesMap.get("r3_Amt"))) == 0) {
			return true;
		}
		return false;
	}

	@Override
	public boolean cancel(String outTradeNo) {
		return false;
	}

	@Override
	public boolean refund(PaymentTransaction paymentTransaction, String refundSn, BigDecimal refundAmount, String refundReason) {
		return false;
	}

	/**
	 * 生成签名
	 * 
	 * @param parameterMap
	 *            参数
	 * @return 签名
	 */
	private String generateSign(Map<String, Object> parameterMap) {
		PluginConfig pluginConfig = getPluginConfig();
		return hmacDigest(joinValue(parameterMap, null, null, null, false, "hmac"), pluginConfig.getAttribute("key"));
	}

	/**
	 * Hmac加密
	 * 
	 * @param value
	 *            值
	 * @param key
	 *            密钥
	 * @return 密文
	 */
	private String hmacDigest(String value, String key) {
		try {
			Mac mac = Mac.getInstance("HmacMD5");
			mac.init(new SecretKeySpec(key.getBytes("UTF-8"), "HmacMD5"));
			byte[] bytes = mac.doFinal(value.getBytes("UTF-8"));

			StringBuilder digest = new StringBuilder();
			for (int i = 0; i < bytes.length; i++) {
				String hex = Integer.toHexString(0xFF & bytes[i]);
				if (hex.length() == 1) {
					digest.append("0");
				}
				digest.append(hex);
			}
			return digest.toString();
		} catch (NoSuchAlgorithmException e) {
			throw new RuntimeException(e.getMessage(), e);
		} catch (UnsupportedEncodingException e) {
			throw new RuntimeException(e.getMessage(), e);
		} catch (InvalidKeyException e) {
			throw new RuntimeException(e.getMessage(), e);
		}
	}

}