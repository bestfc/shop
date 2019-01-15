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
 * Entity订单记录
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Entity
public class OrderLog extends BaseEntity<Long> {

	private static final long serialVersionUID = -2704154761295319939L;

	/**
	 * 类型
	 */
	public enum Type {

		/**
		 * 订单创建
		 */
		create,

		/**
		 * 订单修改
		 */
		modify,

		/**
		 * 订单取消
		 */
		cancel,

		/**
		 * 订单审核
		 */
		review,

		/**
		 * 订单收款
		 */
		payment,

		/**
		 * 订单退款
		 */
		refunds,

		/**
		 * 订单发货
		 */
		shipping,

		/**
		 * 订单退货
		 */
		returns,

		/**
		 * 订单收货
		 */
		receive,

		/**
		 * 订单完成
		 */
		complete,

		/**
		 * 订单失败
		 */
		fail,
		/**
		 * 订单申请退款
		 */
		refundsApply,

		/**
		 * 订单同意退款
		 */
		refundsAudited,
		/**
		 * 订单已退款
		 */
		refundsRefunded,
		/**
		 * 拒绝退款
		 */
		refundsDenied,
		/**
		 * 取消退款
		 */
		refundsCanceled
	}

	/**
	 * 类型
	 */
	@Column(nullable = false, updatable = false)
	private OrderLog.Type type;

	/**
	 * 详情
	 */
	@Column(updatable = false)
	private String detail;

	/**
	 * 订单
	 */
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "orders", nullable = false, updatable = false)
	private Order order;

	/**
	 * 获取类型
	 * 
	 * @return 类型
	 */
	public OrderLog.Type getType() {
		return type;
	}

	/**
	 * 设置类型
	 * 
	 * @param type
	 *            类型
	 */
	public void setType(OrderLog.Type type) {
		this.type = type;
	}

	/**
	 * 获取详情
	 * 
	 * @return 详情
	 */
	public String getDetail() {
		return detail;
	}

	/**
	 * 设置详情
	 * 
	 * @param detail
	 *            详情
	 */
	public void setDetail(String detail) {
		this.detail = detail;
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

}