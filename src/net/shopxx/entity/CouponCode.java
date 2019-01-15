/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.entity;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.PrePersist;
import javax.persistence.PreRemove;

import org.apache.commons.lang.StringUtils;

import com.fasterxml.jackson.annotation.JsonView;

/**
 * Entity优惠码
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Entity
public class CouponCode extends BaseEntity<Long> {

	private static final long serialVersionUID = -1812874037224306719L;

	/**
	 * 号码
	 */
	@JsonView(BaseView.class)
	@Column(nullable = false, updatable = false, unique = true)
	private String code;

	/**
	 * 是否已使用
	 */
	@JsonView(BaseView.class)
	@Column(nullable = false)
	private Boolean isUsed;

	/**
	 * 使用日期
	 */
	@JsonView(BaseView.class)
	private Date usedDate;

	/**
	 * 优惠券
	 */
	@JsonView(BaseView.class)
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(nullable = false, updatable = false)
	private Coupon coupon;

	/**
	 * 会员
	 */
	@ManyToOne(fetch = FetchType.LAZY)
	private Member member;

	/**
	 * 订单
	 */
	@JsonView(BaseView.class)
	@OneToOne(mappedBy = "couponCode", fetch = FetchType.LAZY)
	@JoinColumn(name = "orders")
	private Order order;

	/**
	 * 获取号码
	 * 
	 * @return 号码
	 */
	public String getCode() {
		return code;
	}

	/**
	 * 设置号码
	 * 
	 * @param code
	 *            号码
	 */
	public void setCode(String code) {
		this.code = code;
	}

	/**
	 * 获取是否已使用
	 * 
	 * @return 是否已使用
	 */
	public Boolean getIsUsed() {
		return isUsed;
	}

	/**
	 * 设置是否已使用
	 * 
	 * @param isUsed
	 *            是否已使用
	 */
	public void setIsUsed(Boolean isUsed) {
		this.isUsed = isUsed;
	}

	/**
	 * 获取使用日期
	 * 
	 * @return 使用日期
	 */
	public Date getUsedDate() {
		return usedDate;
	}

	/**
	 * 设置使用日期
	 * 
	 * @param usedDate
	 *            使用日期
	 */
	public void setUsedDate(Date usedDate) {
		this.usedDate = usedDate;
	}

	/**
	 * 获取优惠券
	 * 
	 * @return 优惠券
	 */
	public Coupon getCoupon() {
		return coupon;
	}

	/**
	 * 设置优惠券
	 * 
	 * @param coupon
	 *            优惠券
	 */
	public void setCoupon(Coupon coupon) {
		this.coupon = coupon;
	}

	/**
	 * 获取会员
	 * 
	 * @return 会员
	 */
	public Member getMember() {
		return member;
	}

	/**
	 * 设置会员
	 * 
	 * @param member
	 *            会员
	 */
	public void setMember(Member member) {
		this.member = member;
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
	 * 持久化前处理
	 */
	@PrePersist
	public void prePersist() {
		setCode(StringUtils.lowerCase(getCode()));
	}

	/**
	 * 删除前处理
	 */
	@PreRemove
	public void preRemove() {
		if (getOrder() != null) {
			getOrder().setCouponCode(null);
		}
	}

}