/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.entity;

import javax.persistence.Column;
import javax.persistence.Entity;

/**
 * Entity序列号
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Entity
public class Sn extends BaseEntity<Long> {

	private static final long serialVersionUID = -2330598144835706164L;

	/**
	 * 类型
	 */
	public enum Type {

		/**
		 * 商品
		 */
		product,

		/**
		 * 订单
		 */
		order,

		/**
		 * 订单支付
		 */
		orderPayment,

		/**
		 * 订单退款
		 */
		orderRefunds,

		/**
		 * 订单发货
		 */
		orderShipping,

		/**
		 * 订单退货
		 */
		orderReturns,

		/**
		 * 支付事务
		 */
		paymentTransaction,

		/**
		 * 平台服务
		 */
		platformService
	}

	/**
	 * 类型
	 */
	@Column(nullable = false, updatable = false, unique = true)
	private Sn.Type type;

	/**
	 * 末值
	 */
	@Column(nullable = false)
	private Long lastValue;

	/**
	 * 获取类型
	 * 
	 * @return 类型
	 */
	public Sn.Type getType() {
		return type;
	}

	/**
	 * 设置类型
	 * 
	 * @param type
	 *            类型
	 */
	public void setType(Sn.Type type) {
		this.type = type;
	}

	/**
	 * 获取末值
	 * 
	 * @return 末值
	 */
	public Long getLastValue() {
		return lastValue;
	}

	/**
	 * 设置末值
	 * 
	 * @param lastValue
	 *            末值
	 */
	public void setLastValue(Long lastValue) {
		this.lastValue = lastValue;
	}

}