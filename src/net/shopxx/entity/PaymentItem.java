/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.entity;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * Entity支付项
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
public class PaymentItem implements Serializable {

	private static final long serialVersionUID = -4913487735837005177L;

	/**
	 * 类型
	 */
	public enum Type {

		/**
		 * 订单支付
		 */
		ORDER_PAYMENT,

		/**
		 * 服务支付
		 */
		SVC_PAYMENT,

		/**
		 * 预存款充值
		 */
		DEPOSIT_RECHARGE,

		/**
		 * 保证金支付
		 */
		BAIL_PAYMENT
	}

	/**
	 * 类型
	 */
	private PaymentItem.Type type;

	/**
	 * 支付金额
	 */
	private BigDecimal amount;

	/**
	 * 订单编号
	 */
	private String orderSn;

	/**
	 * 服务编号
	 */
	private String svcSn;

	/**
	 * 获取类型
	 * 
	 * @return 类型
	 */
	public PaymentItem.Type getType() {
		return type;
	}

	/**
	 * 设置类型
	 * 
	 * @param type
	 *            类型
	 */
	public void setType(PaymentItem.Type type) {
		this.type = type;
	}

	/**
	 * 获取支付金额
	 * 
	 * @return 支付金额
	 */
	public BigDecimal getAmount() {
		return amount;
	}

	/**
	 * 设置支付金额
	 * 
	 * @param amount
	 *            支付金额
	 */
	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}

	/**
	 * 获取订单编号
	 * 
	 * @return 订单编号
	 */
	public String getOrderSn() {
		return orderSn;
	}

	/**
	 * 设置订单编号
	 * 
	 * @param orderSn
	 *            订单编号
	 */
	public void setOrderSn(String orderSn) {
		this.orderSn = orderSn;
	}

	/**
	 * 获取服务编号
	 * 
	 * @return 服务编号
	 */
	public String getSvcSn() {
		return svcSn;
	}

	/**
	 * 设置服务编号
	 * 
	 * @param svcSn
	 *            服务编号
	 */
	public void setSvcSn(String svcSn) {
		this.svcSn = svcSn;
	}

}