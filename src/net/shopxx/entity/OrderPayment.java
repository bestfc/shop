/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.entity;

import java.math.BigDecimal;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.PrePersist;
import javax.persistence.Transient;
import javax.validation.constraints.Digits;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;

import org.apache.commons.lang.StringUtils;
import org.hibernate.validator.constraints.Length;

/**
 * Entity订单支付
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Entity
public class OrderPayment extends BaseEntity<Long> {

	private static final long serialVersionUID = -5052430116564638634L;

	/**
	 * 方式
	 */
	public enum Method {

		/**
		 * 在线支付
		 */
		online,

		/**
		 * 线下支付
		 */
		offline,

		/**
		 * 预存款支付
		 */
		deposit
	}
	/**
	 * 状态
	 */
	public enum Status {

		/**
		 * 已支付
		 */
		payed,

		/**
		 * 已退款
		 */
		refunded
	}

	/**
	 * 状态
	 */
	private OrderPayment.Status status;

	/**
	 * 编号
	 */
	@Column(nullable = false, updatable = false, unique = true)
	private String sn;

	/**
	 * 方式
	 */
	@NotNull
	@Column(nullable = false, updatable = false)
	private OrderPayment.Method method;

	/**
	 * 支付方式
	 */
	@Column(updatable = false)
	private String paymentMethod;

	/**
	 * 在线支付类别
	 */
	@Length(max = 20)
	@Column(updatable = false)
	private String onlinePayType;

	/**
	 * 收款银行
	 */
	@Length(max = 200)
	@Column(updatable = false)
	private String bank;

	/**
	 * 收款账号
	 */
	@Length(max = 200)
	@Column(updatable = false)
	private String account;

	/**
	 * 付款金额
	 */
	@NotNull
	@Min(0)
	@Digits(integer = 12, fraction = 3)
	@Column(nullable = false, updatable = false, precision = 21, scale = 6)
	private BigDecimal amount;
	/**
	 * 退款金额
	 */
	@NotNull
	@Min(0)
	@Digits(integer = 12, fraction = 3)
	@Column(nullable = false, updatable = false, precision = 21, scale = 6)
	private BigDecimal refundamount;

	/**
	 * 支付手续费
	 */
	@Column(nullable = false, updatable = false, precision = 21, scale = 6)
	private BigDecimal fee;

	/**
	 * 付款人
	 */
	@Length(max = 200)
	@Column(updatable = false)
	private String payer;

	/**
	 * 备注
	 */
	@Length(max = 200)
	@Column(updatable = false)
	private String memo;

	/**
	 * 订单
	 */
	@NotNull
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "orders", nullable = false, updatable = false)
	private Order order;

	//支付事务
	@ManyToOne
	private PaymentTransaction paymentTransaction;

	public PaymentTransaction getPaymentTransaction() {
		return paymentTransaction;
	}

	public void setPaymentTransaction(PaymentTransaction paymentTransaction) {
		this.paymentTransaction = paymentTransaction;
	}

	public Status getStatus() {
		return status;
	}

	public void setStatus(Status status) {
		this.status = status;
	}

	/**
	 * 获取编号
	 * 
	 * @return 编号
	 */
	public String getSn() {
		return sn;
	}

	/**
	 * 设置编号
	 * 
	 * @param sn
	 *            编号
	 */
	public void setSn(String sn) {
		this.sn = sn;
	}

	/**
	 * 获取方式
	 * 
	 * @return 方式
	 */
	public OrderPayment.Method getMethod() {
		return method;
	}

	/**
	 * 设置方式
	 * 
	 * @param method
	 *            方式
	 */
	public void setMethod(OrderPayment.Method method) {
		this.method = method;
	}

	/**
	 * 获取支付方式
	 * 
	 * @return 支付方式
	 */
	public String getPaymentMethod() {
		return paymentMethod;
	}

	/**
	 * 设置支付方式
	 * 
	 * @param paymentMethod
	 *            支付方式
	 */
	public void setPaymentMethod(String paymentMethod) {
		this.paymentMethod = paymentMethod;
	}

	/**
	 * 获取在线支付类别
	 *
	 */
	public String getOnlinePayType() {
		return onlinePayType;
	}
	/**
	 * 设置在线支付类别
	 *
	 */
	public void setOnlinePayType(String onlinePayType) {
		this.onlinePayType = onlinePayType;
	}

	/**
	 * 获取收款银行
	 * 
	 * @return 收款银行
	 */
	public String getBank() {
		return bank;
	}

	/**
	 * 设置收款银行
	 * 
	 * @param bank
	 *            收款银行
	 */
	public void setBank(String bank) {
		this.bank = bank;
	}

	/**
	 * 获取收款账号
	 * 
	 * @return 收款账号
	 */
	public String getAccount() {
		return account;
	}

	/**
	 * 设置收款账号
	 * 
	 * @param account
	 *            收款账号
	 */
	public void setAccount(String account) {
		this.account = account;
	}

	/**
	 * 获取付款金额
	 * 
	 * @return 付款金额
	 */
	public BigDecimal getAmount() {
		return amount;
	}

	/**
	 * 设置付款金额
	 * 
	 * @param amount
	 *            付款金额
	 */
	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}

	/**
	 * 获取支付手续费
	 * 
	 * @return 支付手续费
	 */
	public BigDecimal getFee() {
		return fee;
	}

	/**
	 * 设置支付手续费
	 * 
	 * @param fee
	 *            支付手续费
	 */
	public void setFee(BigDecimal fee) {
		this.fee = fee;
	}

	public BigDecimal getRefundamount() {
		return refundamount;
	}

	public void setRefundamount(BigDecimal refundamount) {
		this.refundamount = refundamount;
	}

	/**
	 * 获取付款人
	 * 
	 * @return 付款人
	 */
	public String getPayer() {
		return payer;
	}

	/**
	 * 设置付款人
	 * 
	 * @param payer
	 *            付款人
	 */
	public void setPayer(String payer) {
		this.payer = payer;
	}

	/**
	 * 获取备注
	 * 
	 * @return 备注
	 */
	public String getMemo() {
		return memo;
	}

	/**
	 * 设置备注
	 * 
	 * @param memo
	 *            备注
	 */
	public void setMemo(String memo) {
		this.memo = memo;
	}

	/**
	 * 获取订单
	 * 
	 * @return 订单
	 */
	public Order getOrder() {
		return order;
	}

	/**
	 * 设置订单
	 * 
	 * @param order
	 *            订单
	 */
	public void setOrder(Order order) {
		this.order = order;
	}

	/**
	 * 获取有效金额
	 * 
	 * @return 有效金额
	 */
	@Transient
	public BigDecimal getEffectiveAmount() {
		BigDecimal effectiveAmount = getAmount().subtract(getFee());
		return effectiveAmount.compareTo(BigDecimal.ZERO) >= 0 ? effectiveAmount : BigDecimal.ZERO;
	}

	/**
	 * 设置支付方式
	 * 
	 * @param paymentMethod
	 *            支付方式
	 */
	@Transient
	public void setPaymentMethod(PaymentMethod paymentMethod) {
		setPaymentMethod(paymentMethod != null ? paymentMethod.getName() : null);
	}

	/**
	 * 持久化前处理
	 */
	@PrePersist
	public void prePersist() {
		setSn(StringUtils.lowerCase(getSn()));
	}

	@Transient
	public boolean isAbleRefundableAmount(BigDecimal amount) {
		BigDecimal payEffectoveAmount = getEffectiveAmount();
		BigDecimal refundAmount = getOrder().getRefundAmount();
		return payEffectoveAmount.subtract(refundAmount).subtract(amount).compareTo(BigDecimal.ZERO) >= 0;
	}

}