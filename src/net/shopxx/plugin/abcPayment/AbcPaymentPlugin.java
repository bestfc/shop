/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.plugin.abcPayment;

import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.security.PrivateKey;
import java.security.cert.Certificate;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateFormatUtils;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.ModelAndView;

import net.shopxx.Setting;
import net.shopxx.entity.PaymentTransaction;
import net.shopxx.entity.PluginConfig;
import net.shopxx.plugin.PaymentPlugin;
import net.shopxx.util.RSAUtils;
import net.shopxx.util.SystemUtils;

/**
 * Plugin中国农业银行网上支付
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Component("abcPaymentPlugin")
public class AbcPaymentPlugin extends PaymentPlugin {

	/**
	 * 证书文件路径
	 */
	private static final String CERTIFICATE_FILE_PATH = AbcPaymentPlugin.class.getResource("").getFile() + "TrustPay.cer";

	/**
	 * 证书
	 */
	private static final Certificate CERTIFICATE;

	static {
		InputStream inputStream = null;
		try {
			inputStream = new BufferedInputStream(new FileInputStream(CERTIFICATE_FILE_PATH));
			CERTIFICATE = RSAUtils.getCertificate("X.509", inputStream);
		} catch (IOException e) {
			throw new RuntimeException(e.getMessage(), e);
		} finally {
			IOUtils.closeQuietly(inputStream);
		}
	}

	@Override
	public String getName() {
		return "中国农业银行网上支付";
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
		return "abc_payment/install";
	}

	@Override
	public String getUninstallUrl() {
		return "abc_payment/uninstall";
	}

	@Override
	public String getSettingUrl() {
		return "abc_payment/setting";
	}

	@Override
	public void payHandle(PaymentPlugin paymentPlugin, PaymentTransaction paymentTransaction, String paymentDescription, String extra, HttpServletRequest request, HttpServletResponse response, ModelAndView modelAndView) throws Exception {
		Setting setting = SystemUtils.getSetting();
		PluginConfig pluginConfig = getPluginConfig();

		Document document = DocumentHelper.createDocument();
		Element msg = document.addElement("MSG");
		Element message = msg.addElement("Message");

		Element merchant = message.addElement("Merchant");
		merchant.addElement("ECMerchantType").setText("B2C");
		merchant.addElement("MerchantID").setText(pluginConfig.getAttribute("merchantId"));

		Element trxRequest = message.addElement("TrxRequest");
		trxRequest.addElement("TrxType").setText("PayReq");

		Element order = trxRequest.addElement("Order");
		order.addElement("OrderNo").setText(paymentTransaction.getSn());
		order.addElement("ExpiredDate").setText("7");
		order.addElement("OrderAmount").setText(paymentTransaction.getAmount().setScale(2).toString());
		order.addElement("OrderDesc").setText(StringUtils.abbreviate(paymentDescription, 60));
		order.addElement("OrderDate").setText(DateFormatUtils.format(new Date(), "yyyy/MM/dd"));
		order.addElement("OrderTime").setText(DateFormatUtils.format(new Date(), "HH:mm:ss"));
		order.addElement("OrderURL").setText(setting.getSiteUrl());
		order.addElement("BuyIP").setText(request.getRemoteAddr());
		order.addElement("OrderItems");

		trxRequest.addElement("ProductType").setText("2");
		trxRequest.addElement("PaymentType").setText("A");
		trxRequest.addElement("NotifyType").setText("1");
		trxRequest.addElement("ResultNotifyURL").setText(getPostPayUrl(paymentPlugin, paymentTransaction, "notify"));
		trxRequest.addElement("MerchantRemarks").setText("shopxx");
		trxRequest.addElement("PaymentLinkType").setText("1");

		msg.addElement("Signature-Algorithm").setText("SHA1withRSA");
		msg.addElement("Signature").setText(generateSign(merchant.asXML() + trxRequest.asXML()));

		Map<String, Object> parameterMap = new HashMap<>();
		parameterMap.put("Signature", document.getRootElement().asXML());
		parameterMap.put("errorPage", setting.getSiteUrl());

		modelAndView.addObject("requestUrl", "https://easyabc.95599.cn/b2c/trustpay/ReceiveMerchantIERequestServlet");
		modelAndView.addObject("parameterMap", parameterMap);
		modelAndView.addObject("requestCharset", "gb2312");
		modelAndView.setViewName(PaymentPlugin.DEFAULT_PAY_VIEW_NAME);
	}

	@Override
	public void postPayHandle(PaymentPlugin paymentPlugin, PaymentTransaction paymentTransaction, String paymentDescription, String extra, boolean isPaySuccess, HttpServletRequest request, HttpServletResponse response, ModelAndView modelAndView) throws Exception {
		super.postPayHandle(paymentPlugin, paymentTransaction, paymentDescription, extra, isPaySuccess, request, response, modelAndView);

		if (StringUtils.equals(extra, "notify")) {
			modelAndView.addObject("message", "<URL>" + getPostPayUrl(paymentPlugin, paymentTransaction) + "?MSG=" + URLEncoder.encode(request.getParameter("MSG"), "UTF-8") + "</URL>");
		}
	}

	@Override
	public boolean isPaySuccess(PaymentPlugin paymentPlugin, PaymentTransaction paymentTransaction, String paymentDescription, String extra, HttpServletRequest request, HttpServletResponse response) throws Exception {
		try {
			PluginConfig pluginConfig = getPluginConfig();
			String message = request.getParameter("MSG");
			Document document = DocumentHelper.parseText(message);
			String amount = document.selectSingleNode("/MSG/Message/TrxResponse/Amount").getText().trim();
			String returnCode = document.selectSingleNode("/MSG/Message/TrxResponse/ReturnCode").getText().trim();
			String merchantId = document.selectSingleNode("/MSG/Message/TrxResponse/MerchantID").getText().trim();

			if (verifySign(message) && StringUtils.equals(pluginConfig.getAttribute("merchantId"), merchantId) && StringUtils.equals(returnCode, "0000") && paymentTransaction.getAmount().compareTo(new BigDecimal(amount)) == 0) {
				return true;
			}
			return false;
		} catch (DocumentException e) {
			throw new RuntimeException(e.getMessage(), e);
		}
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
	 * @param message
	 *            消息
	 * @return 签名
	 */
	private String generateSign(String message) {
		try {
			PluginConfig pluginConfig = getPluginConfig();
			PrivateKey privateKey = RSAUtils.generatePrivateKey(pluginConfig.getAttribute("key"));
			return Base64.encodeBase64String(RSAUtils.sign("SHA1withRSA", privateKey, message.getBytes("UTF-8")));
		} catch (UnsupportedEncodingException e) {
			throw new RuntimeException(e.getMessage(), e);
		}
	}

	/**
	 * 验证签名
	 * 
	 * @param message
	 *            消息
	 * @return 是否验证通过
	 */
	private boolean verifySign(String message) {
		try {
			Document document = DocumentHelper.parseText(message);
			byte[] sign = Base64.decodeBase64(document.selectSingleNode("/MSG/Signature").getText().trim());
			byte[] data = document.selectSingleNode("/MSG/Message").getText().trim().getBytes("gb2312");
			return RSAUtils.verify("SHA1withRSA", CERTIFICATE, sign, data);
		} catch (DocumentException e) {
			throw new RuntimeException(e.getMessage(), e);
		} catch (UnsupportedEncodingException e) {
			throw new RuntimeException(e.getMessage(), e);
		}
	}

}