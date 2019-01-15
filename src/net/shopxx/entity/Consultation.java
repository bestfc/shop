/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.entity;

import java.util.HashSet;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OrderBy;
import javax.persistence.Transient;

import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;

import com.fasterxml.jackson.annotation.JsonView;

/**
 * Entity咨询
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Entity
public class Consultation extends BaseEntity<Long> {

	private static final long serialVersionUID = -3950317769006303385L;

	/**
	 * 路径
	 */
	private static final String PATH = "/consultation/detail/%d";

	/**
	 * 内容
	 */
	@JsonView(BaseView.class)
	@NotEmpty
	@Length(max = 200)
	@Column(nullable = false, updatable = false)
	private String content;

	/**
	 * 是否显示
	 */
	@Column(nullable = false)
	private Boolean isShow;

	/**
	 * IP
	 */
	@Column(nullable = false, updatable = false)
	private String ip;

	/**
	 * 会员
	 */
	@JsonView(BaseView.class)
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(updatable = false)
	private Member member;

	/**
	 * 商品
	 */
	@JsonView(BaseView.class)
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(nullable = false, updatable = false)
	private Product product;

	/**
	 * 咨询
	 */
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(updatable = false)
	private Consultation forConsultation;

	/**
	 * 回复
	 */
	@JsonView(BaseView.class)
	@OneToMany(mappedBy = "forConsultation", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
	@OrderBy("createdDate asc")
	private Set<Consultation> replyConsultations = new HashSet<>();

	/**
	 * 店铺
	 */
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(nullable = false)
	private Store store;

	/**
	 * 获取内容
	 * 
	 * @return 内容
	 */
	public String getContent() {
		return content;
	}

	/**
	 * 设置内容
	 * 
	 * @param content
	 *            内容
	 */
	public void setContent(String content) {
		this.content = content;
	}

	/**
	 * 获取是否显示
	 * 
	 * @return 是否显示
	 */
	public Boolean getIsShow() {
		return isShow;
	}

	/**
	 * 设置是否显示
	 * 
	 * @param isShow
	 *            是否显示
	 */
	public void setIsShow(Boolean isShow) {
		this.isShow = isShow;
	}

	/**
	 * 获取IP
	 * 
	 * @return IP
	 */
	public String getIp() {
		return ip;
	}

	/**
	 * 设置IP
	 * 
	 * @param ip
	 *            IP
	 */
	public void setIp(String ip) {
		this.ip = ip;
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
	 * 获取商品
	 * 
	 * @return 商品
	 */
	public Product getProduct() {
		return product;
	}

	/**
	 * 设置商品
	 * 
	 * @param product
	 *            商品
	 */
	public void setProduct(Product product) {
		this.product = product;
	}

	/**
	 * 获取咨询
	 * 
	 * @return 咨询
	 */
	public Consultation getForConsultation() {
		return forConsultation;
	}

	/**
	 * 设置咨询
	 * 
	 * @param forConsultation
	 *            咨询
	 */
	public void setForConsultation(Consultation forConsultation) {
		this.forConsultation = forConsultation;
	}

	/**
	 * 获取回复
	 * 
	 * @return 回复
	 */
	public Set<Consultation> getReplyConsultations() {
		return replyConsultations;
	}

	/**
	 * 设置回复
	 * 
	 * @param replyConsultations
	 *            回复
	 */
	public void setReplyConsultations(Set<Consultation> replyConsultations) {
		this.replyConsultations = replyConsultations;
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
	 * 获取路径
	 * 
	 * @return 路径
	 */
	@JsonView(BaseView.class)
	@Transient
	public String getPath() {
		return String.format(Consultation.PATH, getProduct().getId());
	}

}