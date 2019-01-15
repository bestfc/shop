/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.plugin.ccbPayment;

import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.security.PublicKey;
import java.util.LinkedHashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.ModelAndView;

import net.shopxx.entity.PaymentTransaction;
import net.shopxx.entity.PluginConfig;
import net.shopxx.plugin.PaymentPlugin;
import net.shopxx.util.RSAUtils;

/**
 * Plugin中国建设银行网上支付
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Component("ccbPaymentPlugin")
public abstract class CcbPaymentPlugin extends PaymentPlugin {

	@Override
	public String getName() {
		return "中国建设银行网上支付";
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
		return "ccb_payment/install";
	}

	@Override
	public String getUninstallUrl() {
		return "ccb_payment/uninstall";
	}

	@Override
	public String getSettingUrl() {
		return "ccb_payment/setting";
	}

	@Override
	public void payHandle(PaymentPlugin paymentPlugin, PaymentTransaction paymentTransaction, String paymentDescription, String extra, HttpServletRequest request, HttpServletResponse response, ModelAndView modelAndView) throws Exception {
		PluginConfig pluginConfig = getPluginConfig();
		Map<String, Object> parameterMap = new LinkedHashMap<>();
		parameterMap.put("MERCHANTID", pluginConfig.getAttribute("partner"));
		parameterMap.put("POSID", pluginConfig.getAttribute("posId"));
		parameterMap.put("BRANCHID", pluginConfig.getAttribute("branchId"));
		parameterMap.put("ORDERID", paymentTransaction.getSn());
		parameterMap.put("PAYMENT", paymentTransaction.getAmount().setScale(2).toString());
		parameterMap.put("CURCODE", "01");
		parameterMap.put("TXCODE", "520100");
		parameterMap.put("REMARK1", "shopxx");
		parameterMap.put("REMARK2", "");
		if (StringUtils.equals(pluginConfig.getAttribute("isPhishing"), "true")) {
			String key = pluginConfig.getAttribute("key");
			parameterMap.put("TYPE", "1");
			parameterMap.put("PUB", StringUtils.substring(key, -30, key.length()));
			parameterMap.put("GATEWAY", "");
			parameterMap.put("CLIENTIP", request.getRemoteAddr());
			parameterMap.put("REGINFO", "");
			parameterMap.put("PROINFO", "");
			parameterMap.put("REFERER", "");
		}
		parameterMap.put("MAC", generateSign(parameterMap));
		parameterMap.remove("PUB");

		modelAndView.addObject("requestUrl", "https://ibsbjstar.ccb.com.cn/app/ccbMain");
		modelAndView.addObject("parameterMap", parameterMap);
		modelAndView.setViewName(PaymentPlugin.DEFAULT_PAY_VIEW_NAME);
	}

	@Override
	public boolean isPaySuccess(PaymentPlugin paymentPlugin, PaymentTransaction paymentTransaction, String paymentDescription, String extra, HttpServletRequest request, HttpServletResponse response) throws Exception {
		PluginConfig pluginConfig = getPluginConfig();
		Map<String, Object> signMap = new LinkedHashMap<>();
		signMap.put("POSID", request.getParameter("POSID"));
		signMap.put("BRANCHID", request.getParameter("BRANCHID"));
		signMap.put("ORDERID", request.getParameter("ORDERID"));
		signMap.put("PAYMENT", request.getParameter("PAYMENT"));
		signMap.put("CURCODE", request.getParameter("CURCODE"));
		signMap.put("REMARK1", request.getParameter("REMARK1"));
		signMap.put("REMARK2", request.getParameter("REMARK2"));
		if (StringUtils.equals(extra, "notify")) {
			signMap.put("ACC_TYPE", request.getParameter("ACC_TYPE"));
		}
		signMap.put("SUCCESS", request.getParameter("SUCCESS"));
		if (StringUtils.equals(pluginConfig.getAttribute("isPhishing"), "true")) {
			signMap.put("TYPE", request.getParameter("TYPE"));
			signMap.put("REFERER", request.getParameter("REFERER"));
			signMap.put("CLIENTIP", request.getParameter("CLIENTIP"));
		}
		if (verifySign(signMap, request.getParameter("SIGN")) && StringUtils.equals(request.getParameter("SUCCESS"), "Y") && paymentTransaction.getAmount().compareTo(new BigDecimal(request.getParameter("PAYMENT"))) == 0) {
			return true;
		}
		return false;
	}

	/**
	 * 生成签名
	 * 
	 * @param parameterMap
	 *            参数
	 * @return 签名
	 */
	private String generateSign(Map<String, ?> parameterMap) {
		return DigestUtils.md5Hex(joinKeyValue(new LinkedHashMap<>(parameterMap), null, null, "&", false, "MAC"));
	}

	/**
	 * 验证签名
	 * 
	 * @param parameterMap
	 *            参数
	 * @param sign
	 *            签名
	 * @return 是否验证通过
	 */
	private boolean verifySign(Map<String, ?> parameterMap, String sign) {
		try {
			PluginConfig pluginConfig = getPluginConfig();
			PublicKey publicKey = RSAUtils.generatePublicKey(toBytes(pluginConfig.getAttribute("key")));
			return RSAUtils.verify("MD5withRSA", publicKey, toBytes(sign), joinKeyValue(new LinkedHashMap<>(parameterMap), null, null, "&", false, "SIGN").getBytes("UTF-8"));
		} catch (UnsupportedEncodingException e) {
			throw new RuntimeException(e.getMessage(), e);
		}
	}

	/**
	 * 转换字符串为字节数组
	 * 
	 * @param str
	 *            字符串
	 * @return 字节数组
	 */
	private byte[] toBytes(String str) {
		byte[] bytes = new byte[str.length() / 2];
		for (int i = 0; i < bytes.length; i++) {
			bytes[i] = (byte) Integer.parseInt(str.substring(2 * i, 2 * i + 2), 16);
		}
		return bytes;
	}

}