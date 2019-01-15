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
import javax.persistence.PrePersist;
import javax.persistence.Transient;

import org.apache.commons.lang.StringUtils;
import org.hibernate.validator.constraints.Email;
import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;

import com.fasterxml.jackson.annotation.JsonView;

/**
 * Entity到货通知
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Entity
public class ProductNotify extends BaseEntity<Long> {

	private static final long serialVersionUID = 3192904068727393421L;

	/**
	 * E-mail
	 */
	@JsonView(BaseView.class)
	@NotEmpty
	@Email
	@Length(max = 200)
	@Column(nullable = false, updatable = false)
	private String email;

	/**
	 * 是否已发送
	 */
	@Column(nullable = false)
	private Boolean hasSent;

	/**
	 * 会员
	 */
	@JsonView(BaseView.class)
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(updatable = false)
	private Member member;

	/**
	 * SKU
	 */
	@JsonView(BaseView.class)
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(nullable = false, updatable = false)
	private Sku sku;

	/**
	 * 获取E-mail
	 * 
	 * @return E-mail
	 */
	public String getEmail() {
		return email;
	}

	/**
	 * 设置E-mail
	 * 
	 * @param email
	 *            E-mail
	 */
	public void setEmail(String email) {
		this.email = email;
	}

	/**
	 * 获取是否已发送
	 * 
	 * @return 是否已发送
	 */
	public Boolean getHasSent() {
		return hasSent;
	}

	/**
	 * 设置是否已发送
	 * 
	 * @param hasSent
	 *            是否已发送
	 */
	public void setHasSent(Boolean hasSent) {
		this.hasSent = hasSent;
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
	 * 获取SKU
	 * 
	 * @return SKU
	 */
	public Sku getSku() {
		return sku;
	}

	/**
	 * 设置SKU
	 * 
	 * @param sku
	 *            SKU
	 */
	public void setSku(Sku sku) {
		this.sku = sku;
	}

	/**
	 * 获取所属店铺
	 * 
	 * @return 所属店铺
	 */
	@JsonView(BaseView.class)
	@Transient
	public Store getStore() {
		return getSku().getProduct().getStore();
	}

	/**
	 * 持久化前处理
	 */
	@PrePersist
	public void prePersist() {
		setEmail(StringUtils.lowerCase(getEmail()));
	}

}