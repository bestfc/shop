/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

/**
 * Entity经营分类申请
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Entity
public class CategoryApplication extends BaseEntity<Long> {

	private static final long serialVersionUID = 2586352101555595765L;

	/**
	 * 状态
	 */
	public enum Status {

		/**
		 * 等待审核
		 */
		pending,

		/**
		 * 审核通过
		 */
		approved,

		/**
		 * 审核失败
		 */
		failed
	}

	/**
	 * 状态
	 */
	@Column(nullable = false)
	private CategoryApplication.Status status;

	/**
	 * 分佣比例
	 */
	@Column(nullable = false, updatable = false)
	private Double rate;

	/**
	 * 店铺
	 */
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(nullable = false, updatable = false)
	private Store store;

	/**
	 * 经营分类
	 */
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(nullable = false, updatable = false)
	private ProductCategory productCategory;

	/**
	 * 获取状态
	 * 
	 * @return 状态
	 */
	public Status getStatus() {
		return status;
	}

	/**
	 * 设置状态
	 * 
	 * @param status
	 *            状态
	 */
	public void setStatus(Status status) {
		this.status = status;
	}

	/**
	 * 获取分佣比例
	 * 
	 * @return 分佣比例
	 */
	public Double getRate() {
		return rate;
	}

	/**
	 * 设置分佣比例
	 * 
	 * @param rate
	 *            分佣比例
	 */
	public void setRate(Double rate) {
		this.rate = rate;
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
	 * 获取经营分类
	 * 
	 * @return 经营分类
	 */
	public ProductCategory getProductCategory() {
		return productCategory;
	}

	/**
	 * 设置经营分类
	 * 
	 * @param productCategory
	 *            经营分类
	 */
	public void setProductCategory(ProductCategory productCategory) {
		this.productCategory = productCategory;
	}

}