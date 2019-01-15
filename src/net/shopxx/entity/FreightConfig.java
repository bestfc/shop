/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.entity;

import java.math.BigDecimal;

import javax.persistence.Column;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.MappedSuperclass;
import javax.validation.constraints.Digits;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;

/**
 * Entity运费配置
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@MappedSuperclass
public abstract class FreightConfig extends BaseEntity<Long> {

	private static final long serialVersionUID = 4986982516016224635L;

	/**
	 * 首重量
	 */
	@NotNull
	@Min(0)
	@Column(nullable = false)
	private Integer firstWeight;

	/**
	 * 续重量
	 */
	@NotNull
	@Min(1)
	@Column(nullable = false)
	private Integer continueWeight;

	/**
	 * 首重价格
	 */
	@NotNull
	@Min(0)
	@Digits(integer = 12, fraction = 3)
	@Column(nullable = false, precision = 21, scale = 6)
	private BigDecimal firstPrice;

	/**
	 * 续重价格
	 */
	@NotNull
	@Min(0)
	@Digits(integer = 12, fraction = 3)
	@Column(nullable = false, precision = 21, scale = 6)
	private BigDecimal continuePrice;

	/**
	 * 配送方式
	 */
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(nullable = false, updatable = false)
	private ShippingMethod shippingMethod;

	/**
	 * 店铺
	 */
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(nullable = false, updatable = false)
	private Store store;

	/**
	 * 获取首重量
	 * 
	 * @return 首重量
	 */
	public Integer getFirstWeight() {
		return firstWeight;
	}

	/**
	 * 设置首重量
	 * 
	 * @param firstWeight
	 *            首重量
	 */
	public void setFirstWeight(Integer firstWeight) {
		this.firstWeight = firstWeight;
	}

	/**
	 * 获取续重量
	 * 
	 * @return 续重量
	 */
	public Integer getContinueWeight() {
		return continueWeight;
	}

	/**
	 * 设置续重量
	 * 
	 * @param continueWeight
	 *            续重量
	 */
	public void setContinueWeight(Integer continueWeight) {
		this.continueWeight = continueWeight;
	}

	/**
	 * 获取首重价格
	 * 
	 * @return 首重价格
	 */
	public BigDecimal getFirstPrice() {
		return firstPrice;
	}

	/**
	 * 设置首重价格
	 * 
	 * @param firstPrice
	 *            首重价格
	 */
	public void setFirstPrice(BigDecimal firstPrice) {
		this.firstPrice = firstPrice;
	}

	/**
	 * 获取续重价格
	 * 
	 * @return 续重价格
	 */
	public BigDecimal getContinuePrice() {
		return continuePrice;
	}

	/**
	 * 设置续重价格
	 * 
	 * @param continuePrice
	 *            续重价格
	 */
	public void setContinuePrice(BigDecimal continuePrice) {
		this.continuePrice = continuePrice;
	}

	/**
	 * 获取配送方式
	 * 
	 * @return 配送方式
	 */
	public ShippingMethod getShippingMethod() {
		return shippingMethod;
	}

	/**
	 * 设置配送方式
	 * 
	 * @param shippingMethod
	 *            配送方式
	 */
	public void setShippingMethod(ShippingMethod shippingMethod) {
		this.shippingMethod = shippingMethod;
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

}