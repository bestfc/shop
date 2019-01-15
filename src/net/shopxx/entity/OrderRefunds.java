/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.entity;

import java.math.BigDecimal;

import javax.persistence.*;
import javax.validation.constraints.Digits;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;

import com.fasterxml.jackson.annotation.JsonView;
import org.apache.commons.lang.StringUtils;
import org.hibernate.validator.constraints.Length;

/**
 * Entity订单退款
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Entity
public class OrderRefunds extends BaseEntity<Long> {

	private static final long serialVersionUID = 354885216604823632L;

	/**
	 * 类型
	 */
	public enum Type {

		/**
		 * 退款退货
		 */
		refundsReturns,

		/**
		 * 仅退款
		 */
		onlyRefunds
	}

	/**
	 * 状态
	 */
	public enum Status {

		/**
		 * 等待审核
		 */
		pendingAudit,

		/**
		 * 同意退款
		 */
		audited,
		/**
		 * 已退款
		 */
		refunded,

		/**
		 * 已拒绝
		 */
		denied,

		/**
		 * 已取消
		 */
		canceled
	}
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
	 * 编号
	 */
	@Column(nullable = false, updatable = false, unique = true)
	private String sn;

	/**
	 * 方式
	 */
	@NotNull
	@Column(nullable = false, updatable = false)
	private OrderRefunds.Method method;

	/**
	 * 支付方式
	 */
	@Column(updatable = false)
	private String paymentMethod;

	/**
	 * 退款银行
	 */
	@Length(max = 200)
	@Column(updatable = false)
	private String bank;

	/**
	 * 退款账号
	 */
	@Length(max = 200)
	@Column(updatable = false)
	private String account;

	/**
	 * 退款金额
	 */
	@NotNull
	@Min(0)
	@Digits(integer = 12, fraction = 3)
	@Column(nullable = false, updatable = false, precision = 21, scale = 6)
	private BigDecimal amount;

	/**
	 * 收款人
	 */
	@Length(max = 200)
	@Column(updatable = false)
	private String payee;

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
	@ManyToOne
	@JoinColumn(name = "orders", nullable = false, updatable = false)
	private Order order;

	/**
	 * 订单子项
	 */
	@NotNull
	@OneToOne
	@JoinColumn(name = "orderItem", nullable = false, updatable = false)
	private OrderItem orderItem;

	/**
	 * 订单关联用户
	 */
	@NotNull
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "member", nullable = false, updatable = false)
	private Member member;

	/**
	 * 类型
	 */
	@Column(nullable = false)
	private OrderRefunds.Type type;

	/**
	 * 状态
	 */
	@Column(nullable = false)
	private OrderRefunds.Status status;

	/**
	 * 退款原因  选择
	 */
	@Length(max = 200)
	@Column(updatable = false)
	private String reason;

	/**
	 * 退款说明
	 */
	@Length(max = 200)
	@Column(updatable = false)
	private String content;

	public Member getMember() {
		return member;
	}

	public void setMember(Member member) {
		this.member = member;
	}

	public Type getType() {
		return type;
	}

	public void setType(Type type) {
		this.type = type;
	}

	public Status getStatus() {
		return status;
	}

	public void setStatus(Status status) {
		this.status = status;
	}

	public String getReason() {
		return reason;
	}

	public void setReason(String reason) {
		this.reason = reason;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
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
	public OrderRefunds.Method getMethod() {
		return method;
	}

	/**
	 * 设置方式
	 *
	 * @param method
	 *            方式
	 */
	public void setMethod(OrderRefunds.Method method) {
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
	 * 获取退款银行
	 * 
	 * @return 退款银行
	 */
	public String getBank() {
		return bank;
	}

	/**
	 * 设置退款银行
	 * 
	 * @param bank
	 *            退款银行
	 */
	public void setBank(String bank) {
		this.bank = bank;
	}

	/**
	 * 获取退款账号
	 * 
	 * @return 退款账号
	 */
	public String getAccount() {
		return account;
	}

	/**
	 * 设置退款账号
	 * 
	 * @param account
	 *            退款账号
	 */
	public void setAccount(String account) {
		this.account = account;
	}

	/**
	 * 获取退款金额
	 * 
	 * @return 退款金额
	 */
	public BigDecimal getAmount() {
		return amount;
	}

	/**
	 * 设置退款金额
	 * 
	 * @param amount
	 *            退款金额
	 */
	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}

	/**
	 * 获取收款人
	 * 
	 * @return 收款人
	 */
	public String getPayee() {
		return payee;
	}

	/**
	 * 设置收款人
	 * 
	 * @param payee
	 *            收款人
	 */
	public void setPayee(String payee) {
		this.payee = payee;
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

	public OrderItem getOrderItem() {
		return orderItem;
	}

	public void setOrderItem(OrderItem orderItem) {
		this.orderItem = orderItem;
	}
}