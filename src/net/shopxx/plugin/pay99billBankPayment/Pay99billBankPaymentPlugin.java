/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.plugin.pay99billBankPayment;

import java.math.BigDecimal;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateFormatUtils;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.ModelAndView;

import net.shopxx.entity.PaymentTransaction;
import net.shopxx.entity.PluginConfig;
import net.shopxx.plugin.PaymentPlugin;

/**
 * Plugin快钱支付(网银直连)
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Component("pay99billBankPaymentPlugin")
public class Pay99billBankPaymentPlugin extends PaymentPlugin {

	/**
	 * 默认银行
	 */
	private static final String DEFAULT_BANK = "ICBC";

	/**
	 * 银行参数名称
	 */
	public static final String BANK_PARAMETER_NAME = "bank";

	@Override
	public String getName() {
		return "快钱支付(网银直连)";
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
		return "pay_99bill_bank_payment/install";
	}

	@Override
	public String getUninstallUrl() {
		return "pay_99bill_bank_payment/uninstall";
	}

	@Override
	public String getSettingUrl() {
		return "pay_99bill_bank_payment/setting";
	}

	@Override
	public void payHandle(PaymentPlugin paymentPlugin, PaymentTransaction paymentTransaction, String paymentDescription, String extra, HttpServletRequest request, HttpServletResponse response, ModelAndView modelAndView) throws Exception {
		PluginConfig pluginConfig = getPluginConfig();
		Map<String, Object> parameterMap = new LinkedHashMap<>();
		parameterMap.put("inputCharset", "1");
		parameterMap.put("pageUrl", getPostPayUrl(paymentPlugin, paymentTransaction));
		parameterMap.put("bgUrl", getPostPayUrl(paymentPlugin, paymentTransaction, "notify"));
		parameterMap.put("version", "v2.0");
		parameterMap.put("language", "1");
		parameterMap.put("signType", "1");
		parameterMap.put("merchantAcctId", pluginConfig.getAttribute("partner"));
		parameterMap.put("payerIP", request.getLocalAddr());
		parameterMap.put("orderId", paymentTransaction.getSn());
		parameterMap.put("orderAmount", paymentTransaction.getAmount().multiply(new BigDecimal(100)).setScale(0).toString());
		parameterMap.put("orderTime", DateFormatUtils.format(new Date(), "yyyyMMddhhmmss"));
		parameterMap.put("orderTimestamp", DateFormatUtils.format(new Date(), "yyyyMMddhhmmss"));
		parameterMap.put("productName", StringUtils.abbreviate(paymentDescription.replaceAll("[^0-9a-zA-Z\\u4e00-\\u9fa5 ]", ""), 100));
		parameterMap.put("productDesc", StringUtils.abbreviate(paymentDescription.replaceAll("[^0-9a-zA-Z\\u4e00-\\u9fa5 ]", ""), 400));
		parameterMap.put("ext1", "shopxx");
		parameterMap.put("payType", "10");
		String bank = request.getParameter(BANK_PARAMETER_NAME);
		parameterMap.put("bankId", StringUtils.isNotEmpty(bank) ? bank : DEFAULT_BANK);
		parameterMap.put("signMsg", generateSign(parameterMap));

		modelAndView.addObject("requestUrl", "https://www.99bill.com/gateway/recvMerchantInfoAction.htm");
		modelAndView.addObject("parameterMap", parameterMap);
		modelAndView.setViewName(PaymentPlugin.DEFAULT_PAY_VIEW_NAME);
	}

	@Override
	public void postPayHandle(PaymentPlugin paymentPlugin, PaymentTransaction paymentTransaction, String paymentDescription, String extra, boolean isPaySuccess, HttpServletRequest request, HttpServletResponse response, ModelAndView modelAndView) throws Exception {
		super.postPayHandle(paymentPlugin, paymentTransaction, paymentDescription, extra, isPaySuccess, request, response, modelAndView);

		if (StringUtils.equals(extra, "notify")) {
			modelAndView.addObject("message", "<result>1</result><redirecturl>" + getPostPayUrl(paymentPlugin, paymentTransaction) + "</redirecturl>");
		}
	}

	@Override
	public boolean isPaySuccess(PaymentPlugin paymentPlugin, PaymentTransaction paymentTransaction, String paymentDescription, String extra, HttpServletRequest request, HttpServletResponse response) throws Exception {
		PluginConfig pluginConfig = getPluginConfig();
		Map<String, Object> parameterMap = new LinkedHashMap<>();
		parameterMap.put("merchantAcctId", request.getParameter("merchantAcctId"));
		parameterMap.put("version", request.getParameter("version"));
		parameterMap.put("language", request.getParameter("language"));
		parameterMap.put("signType", request.getParameter("signType"));
		parameterMap.put("payType", request.getParameter("payType"));
		parameterMap.put("bankId", request.getParameter("bankId"));
		parameterMap.put("orderId", request.getParameter("orderId"));
		parameterMap.put("orderTime", request.getParameter("orderTime"));
		parameterMap.put("orderAmount", request.getParameter("orderAmount"));
		parameterMap.put("bindCard", request.getParameter("bindCard"));
		parameterMap.put("bindMobile", request.getParameter("bindMobile"));
		parameterMap.put("dealId", request.getParameter("dealId"));
		parameterMap.put("bankDealId", request.getParameter("bankDealId"));
		parameterMap.put("dealTime", request.getParameter("dealTime"));
		parameterMap.put("payAmount", request.getParameter("payAmount"));
		parameterMap.put("fee", request.getParameter("fee"));
		parameterMap.put("ext1", request.getParameter("ext1"));
		parameterMap.put("ext2", request.getParameter("ext2"));
		parameterMap.put("payResult", request.getParameter("payResult"));
		parameterMap.put("errCode", request.getParameter("errCode"));
		parameterMap.put("signMsg", request.getParameter("signMsg"));
		if (StringUtils.equals(generateSign(parameterMap), request.getParameter("signMsg")) && StringUtils.equals(pluginConfig.getAttribute("partner"), request.getParameter("merchantAcctId")) && StringUtils.equals(request.getParameter("payResult"), "10")
				&& paymentTransaction.getAmount().multiply(new BigDecimal(100)).compareTo(new BigDecimal(request.getParameter("payAmount"))) == 0) {
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
		return DigestUtils.md5Hex(joinKeyValue(parameterMap, null, "&key=" + pluginConfig.getAttribute("key"), "&", true, "signMsg")).toUpperCase();
	}

}