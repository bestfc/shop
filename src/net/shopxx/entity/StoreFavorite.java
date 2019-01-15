/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.entity;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.UniqueConstraint;

import com.fasterxml.jackson.annotation.JsonView;

/**
 * Entity店铺收藏
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Entity
@Table(uniqueConstraints = @UniqueConstraint(columnNames = { "member_id", "store_id" }))
public class StoreFavorite extends BaseEntity<Long> {

	private static final long serialVersionUID = -2817086898251865976L;

	/**
	 * 最大店铺收藏数
	 */
	public static final Integer MAX_STORE_FAVORITE_SIZE = 10;

	/**
	 * 会员
	 */
	@JsonView(BaseView.class)
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(nullable = false, updatable = false)
	private Member member;

	/**
	 * 店铺
	 */
	@JsonView(BaseView.class)
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(nullable = false, updatable = false)
	private Store store;

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