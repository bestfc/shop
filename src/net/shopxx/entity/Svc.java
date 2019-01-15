/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.entity;

import java.math.BigDecimal;
import java.util.HashSet;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;

/**
 * Entity服务
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Entity
@Inheritance(strategy = InheritanceType.JOINED)
public abstract class Svc extends BaseEntity<Long> {

	private static final long serialVersionUID = -7367901462418664073L;

	/**
	 * 编号
	 */
	@Column(nullable = false, updatable = false, unique = true)
	private String sn;

	/**
	 * 金额
	 */
	@Column(nullable = false, updatable = false, precision = 21, scale = 6)
	private BigDecimal amount;

	/**
	 * 有效天数
	 */
	private Integer durationDays;

	/**
	 * 店铺
	 */
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(updatable = false)
	private Store store;

	/**
	 * 支付事务
	 */
	@OneToMany(mappedBy = "svc", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
	private Set<PaymentTransaction> paymentTransactions = new HashSet<>();

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
	 * 获取金额
	 * 
	 * @return 金额
	 */
	public BigDecimal getAmount() {
		return amount;
	}

	/**
	 * 设置金额
	 * 
	 * @param amount
	 *            金额
	 */
	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}

	/**
	 * 获取有效天数
	 * 
	 * @return 有效天数
	 */
	public Integer getDurationDays() {
		return durationDays;
	}

	/**
	 * 设置有效天数
	 * 
	 * @param durationDays
	 *            有效天数
	 */
	public void setDurationDays(Integer durationDays) {
		this.durationDays = durationDays;
	}

	/**
	 * 获取店铺
	 * 
	 * @return 店铺
	 */
	public Store getStore() {
		return store;
	}

	/**
	 * 设置店铺
	 * 
	 * @param store
	 *            店铺
	 */
	public void setStore(Store store) {
		this.store = store;
	}

	/**
	 * 获取支付事务
	 * 
	 * @return 支付事务
	 */
	public Set<PaymentTransaction> getPaymentTransactions() {
		return paymentTransactions;
	}

	/**
	 * 设置支付事务
	 * 
	 * @param paymentTransactions
	 *            支付事务
	 */
	public void setPaymentTransactions(Set<PaymentTransaction> paymentTransactions) {
		this.paymentTransactions = paymentTransactions;
	}

}