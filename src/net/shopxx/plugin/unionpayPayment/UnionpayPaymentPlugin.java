/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.plugin.unionpayPayment;

import java.math.BigDecimal;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.TreeMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateFormatUtils;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.ModelAndView;

import net.shopxx.Setting;
import net.shopxx.entity.PaymentTransaction;
import net.shopxx.entity.PluginConfig;
import net.shopxx.plugin.PaymentPlugin;
import net.shopxx.util.SystemUtils;
import net.shopxx.util.WebUtils;

/**
 * Plugin银联在线支付
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Component("unionpayPaymentPlugin")
public class UnionpayPaymentPlugin extends PaymentPlugin {

	/**
	 * 货币
	 */
	private static final String CURRENCY = "156";

	@Override
	public String getName() {
		return "银联在线支付";
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
		return "unionpay_payment/install";
	}

	@Override
	public String getUninstallUrl() {
		return "unionpay_payment/uninstall";
	}

	@Override
	public String getSettingUrl() {
		return "unionpay_payment/setting";
	}

	@Override
	public void payHandle(PaymentPlugin paymentPlugin, PaymentTransaction paymentTransaction, String paymentDescription, String extra, HttpServletRequest request, HttpServletResponse response, ModelAndView modelAndView) throws Exception {
		Setting setting = SystemUtils.getSetting();
		PluginConfig pluginConfig = getPluginConfig();
		Map<String, Object> parameterMap = new HashMap<>();
		parameterMap.put("version", "1.0.0");
		parameterMap.put("charset", "UTF-8");
		parameterMap.put("transType", "01");
		parameterMap.put("origQid", "");
		parameterMap.put("merId", pluginConfig.getAttribute("partner"));
		parameterMap.put("merAbbr", StringUtils.abbreviate(setting.getSiteName().replaceAll("[^0-9a-zA-Z\\u4e00-\\u9fa5 ]", ""), 40));
		parameterMap.put("acqCode", "");
		parameterMap.put("merCode", "");
		parameterMap.put("commodityUrl", setting.getSiteUrl());
		parameterMap.put("commodityName", StringUtils.abbreviate(paymentDescription.replaceAll("[^0-9a-zA-Z\\u4e00-\\u9fa5 ]", ""), 200));
		parameterMap.put("commodityUnitPrice", "");
		parameterMap.put("commodityQuantity", "");
		parameterMap.put("commodityDiscount", "");
		parameterMap.put("transferFee", "");
		parameterMap.put("orderNumber", paymentTransaction.getSn());
		parameterMap.put("orderAmount", paymentTransaction.getAmount().multiply(new BigDecimal(100)).setScale(0).toString());
		parameterMap.put("orderCurrency", CURRENCY);
		parameterMap.put("orderTime", DateFormatUtils.format(new Date(), "yyyyMMddHHmmss"));
		parameterMap.put("customerIp", request.getLocalAddr());
		parameterMap.put("customerName", "");
		parameterMap.put("defaultPayType", "");
		parameterMap.put("defaultBankNumber", "");
		parameterMap.put("transTimeout", 10080000);
		parameterMap.put("frontEndUrl", getPostPayUrl(paymentPlugin, paymentTransaction));
		parameterMap.put("backEndUrl", getPostPayUrl(paymentPlugin, paymentTransaction, "notify"));
		parameterMap.put("merReserved", "");
		parameterMap.put("signMethod", "MD5");
		parameterMap.put("signature", generateSign(parameterMap));

		modelAndView.addObject("requestUrl", "https://unionpaysecure.com/api/Pay.action");
		modelAndView.addObject("requestMethod", "post");
		modelAndView.addObject("parameterMap", parameterMap);
		modelAndView.setViewName(PaymentPlugin.DEFAULT_PAY_VIEW_NAME);
	}

	@Override
	public boolean isPaySuccess(PaymentPlugin paymentPlugin, PaymentTransaction paymentTransaction, String paymentDescription, String extra, HttpServletRequest request, HttpServletResponse response) throws Exception {
		PluginConfig pluginConfig = getPluginConfig();
		if (StringUtils.equals(generateSign(request.getParameterMap()), request.getParameter("signature")) && StringUtils.equals(pluginConfig.getAttribute("partner"), request.getParameter("merId")) && StringUtils.equals(request.getParameter("orderCurrency"), CURRENCY)
				&& StringUtils.equals(request.getParameter("respCode"), "00") && paymentTransaction.getAmount().multiply(new BigDecimal(100)).compareTo(new BigDecimal(request.getParameter("orderAmount"))) == 0) {
			Map<String, Object> parameterMap = new HashMap<>();
			parameterMap.put("version", "1.0.0");
			parameterMap.put("charset", "UTF-8");
			parameterMap.put("transType", "01");
			parameterMap.put("merId", pluginConfig.getAttribute("partner"));
			parameterMap.put("orderNumber", paymentTransaction.getSn());
			parameterMap.put("orderTime", DateFormatUtils.format(new Date(), "yyyyMMddHHmmss"));
			parameterMap.put("merReserved", "");
			parameterMap.put("signMethod", "MD5");
			parameterMap.put("signature", generateSign(parameterMap));
			String result = WebUtils.post("https://query.unionpaysecure.com/api/Query.action", parameterMap);
			if (ArrayUtils.contains(StringUtils.split(result, "&"), "respCode=00")) {
				return true;
			}
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
	private String generateSign(Map<String, ?> parameterMap) {
		PluginConfig pluginConfig = getPluginConfig();
		return DigestUtils.md5Hex(joinKeyValue(new TreeMap<>(parameterMap), null, "&" + DigestUtils.md5Hex(pluginConfig.getAttribute("key")), "&", false, "signMethod", "signature"));
	}

}