/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.shop;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import net.shopxx.entity.PaymentItem;
import net.shopxx.entity.PaymentTransaction;
import net.shopxx.entity.PaymentTransaction.LineItem;
import net.shopxx.plugin.PaymentPlugin;
import net.shopxx.service.PaymentTransactionService;
import net.shopxx.service.PluginService;

/**
 * Controller支付
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("shopPaymentController")
@RequestMapping("/payment")
public class PaymentController extends BaseController {

	@Inject
	private PluginService pluginService;
	@Inject
	private PaymentTransactionService paymentTransactionService;

	/**
	 * 检查是否支付成功
	 */
	@PostMapping("/check_is_pay_success")
	public @ResponseBody boolean checkIsPaySuccess(String paymentTransactionSn) {
		PaymentTransaction paymentTransaction = paymentTransactionService.findBySn(paymentTransactionSn);
		return paymentTransaction != null && paymentTransaction.getIsSuccess();
	}

	/**
	 * 首页
	 */
	@RequestMapping
	public String index(String paymentPluginId, PaymentItemListForm paymentItemListForm) {
		PaymentPlugin paymentPlugin = pluginService.getPaymentPlugin(paymentPluginId);
		if (paymentPlugin == null || BooleanUtils.isNotTrue(paymentPlugin.getIsEnabled())) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		List<PaymentItem> paymentItems = paymentItemListForm != null ? paymentItemListForm.getPaymentItemList() : null;
		if (CollectionUtils.isEmpty(paymentItems)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}

		PaymentTransaction paymentTransaction = null;
		if (paymentItems.size() > 1) {
			Set<PaymentTransaction.LineItem> lineItems = new HashSet<>();
			for (PaymentItem paymentItem : paymentItems) {
				LineItem lineItem = paymentTransactionService.generate(paymentItem);
				if (lineItem != null) {
					lineItems.add(lineItem);
				}
			}
			paymentTransaction = paymentTransactionService.generateParent(lineItems, paymentPlugin);
		} else {
			PaymentItem paymentItem = paymentItems.get(0);
			LineItem lineItem = paymentTransactionService.generate(paymentItem);
			paymentTransaction = paymentTransactionService.generate(lineItem, paymentPlugin);
		}
		return "redirect:" + paymentPlugin.getPrePayUrl(paymentPlugin, paymentTransaction);
	}

	/**
	 * 支付前处理
	 */
	@RequestMapping({ "/pre_pay_{paymentTransactionSn:[^_]+}", "/pre_pay_{paymentTransactionSn[^_]+}_{extra}" })
	public ModelAndView prePay(@PathVariable String paymentTransactionSn, @PathVariable(required = false) String extra, HttpServletRequest request, HttpServletResponse response) throws Exception {
		PaymentTransaction paymentTransaction = paymentTransactionService.findBySn(paymentTransactionSn);
		if (paymentTransaction == null || paymentTransaction.hasExpired()) {
			return new ModelAndView(UNPROCESSABLE_ENTITY_VIEW);
		}
		if (paymentTransaction.getIsSuccess()) {
			return new ModelAndView(UNPROCESSABLE_ENTITY_VIEW, "errorMessage", message("shop.payment.payCompleted"));
		}
		String paymentPluginId = paymentTransaction.getPaymentPluginId();
		PaymentPlugin paymentPlugin = StringUtils.isNotEmpty(paymentPluginId) ? pluginService.getPaymentPlugin(paymentPluginId) : null;
		if (paymentPlugin == null || BooleanUtils.isNotTrue(paymentPlugin.getIsEnabled())) {
			return new ModelAndView(UNPROCESSABLE_ENTITY_VIEW);
		}

		ModelAndView modelAndView = new ModelAndView();
		paymentPlugin.prePayHandle(paymentPlugin, paymentTransaction, getPaymentDescription(paymentTransaction), extra, request, response, modelAndView);
		return modelAndView;
	}

	/**
	 * 支付处理
	 */
	@RequestMapping({ "/pay_{paymentTransactionSn:[^_]+}", "/pay_{paymentTransactionSn[^_]+}_{extra}" })
	public ModelAndView pay(@PathVariable String paymentTransactionSn, @PathVariable(required = false) String extra, HttpServletRequest request, HttpServletResponse response) throws Exception {
		PaymentTransaction paymentTransaction = paymentTransactionService.findBySn(paymentTransactionSn);
		if (paymentTransaction == null || paymentTransaction.hasExpired()) {
			return new ModelAndView(UNPROCESSABLE_ENTITY_VIEW);
		}
		if (paymentTransaction.getIsSuccess()) {
			return new ModelAndView(UNPROCESSABLE_ENTITY_VIEW, "errorMessage", message("shop.payment.payCompleted"));
		}
		String paymentPluginId = paymentTransaction.getPaymentPluginId();
		PaymentPlugin paymentPlugin = StringUtils.isNotEmpty(paymentPluginId) ? pluginService.getPaymentPlugin(paymentPluginId) : null;
		if (paymentPlugin == null || BooleanUtils.isNotTrue(paymentPlugin.getIsEnabled())) {
			return new ModelAndView(UNPROCESSABLE_ENTITY_VIEW);
		}

		ModelAndView modelAndView = new ModelAndView();
		paymentPlugin.payHandle(paymentPlugin, paymentTransaction, getPaymentDescription(paymentTransaction), extra, request, response, modelAndView);
		return modelAndView;
	}

	/**
	 * 支付后处理
	 */
	@RequestMapping({ "/post_pay_{paymentTransactionSn:[^_]+}", "/post_pay_{paymentTransactionSn:[^_]+}_{extra}" })
	public ModelAndView postPay(@PathVariable String paymentTransactionSn, @PathVariable(required = false) String extra, HttpServletRequest request, HttpServletResponse response) throws Exception {
		PaymentTransaction paymentTransaction = paymentTransactionService.findBySn(paymentTransactionSn);
		if (paymentTransaction == null) {
			return new ModelAndView(UNPROCESSABLE_ENTITY_VIEW);
		}
		String paymentPluginId = paymentTransaction.getPaymentPluginId();
		PaymentPlugin paymentPlugin = StringUtils.isNotEmpty(paymentPluginId) ? pluginService.getPaymentPlugin(paymentPluginId) : null;
		if (paymentPlugin == null || BooleanUtils.isNotTrue(paymentPlugin.getIsEnabled())) {
			return new ModelAndView(UNPROCESSABLE_ENTITY_VIEW);
		}

		boolean isPaySuccess = paymentPlugin.isPaySuccess(paymentPlugin, paymentTransaction, getPaymentDescription(paymentTransaction), extra, request, response);
		if (isPaySuccess) {
			paymentTransactionService.handle(paymentTransaction);
		}
		ModelAndView modelAndView = new ModelAndView();
		paymentPlugin.postPayHandle(paymentPlugin, paymentTransaction, getPaymentDescription(paymentTransaction), extra, isPaySuccess, request, response, modelAndView);
		return modelAndView;
	}

	/**
	 * 获取支付描述
	 * 
	 * @param paymentTransaction
	 *            支付事务
	 * @return 支付描述
	 */
	private String getPaymentDescription(PaymentTransaction paymentTransaction) {
		Assert.notNull(paymentTransaction);
		if (CollectionUtils.isEmpty(paymentTransaction.getChildren())) {
			Assert.notNull(paymentTransaction.getType());
		} else {
			return message("shop.payment.paymentDescription", paymentTransaction.getSn());
		}

		switch (paymentTransaction.getType()) {
		case ORDER_PAYMENT:
			return message("shop.payment.orderPaymentDescription", paymentTransaction.getOrder().getSn());
		case SVC_PAYMENT:
			return message("shop.payment.svcPaymentDescription", paymentTransaction.getSvc().getSn());
		case DEPOSIT_RECHARGE:
			return message("shop.payment.depositRechargeDescription", paymentTransaction.getSn());
		case BAIL_PAYMENT:
			return message("shop.payment.bailPaymentDescription", paymentTransaction.getSn());
		default:
			return message("shop.payment.paymentDescription", paymentTransaction.getSn());
		}
	}

	/**
	 * FormBean支付项
	 * 
	 * @author SHOP++ Team
	 * @version 5.0
	 */
	public static class PaymentItemListForm {

		/**
		 * 支付项
		 */
		private List<PaymentItem> paymentItemList;

		/**
		 * 获取支付项
		 * 
		 * @return 支付项
		 */
		public List<PaymentItem> getPaymentItemList() {
			return paymentItemList;
		}

		/**
		 * 设置支付项
		 * 
		 * @param paymentItemList
		 *            支付项
		 */
		public void setPaymentItemList(List<PaymentItem> paymentItemList) {
			this.paymentItemList = paymentItemList;
		}
	}

}