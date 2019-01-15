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
import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;

import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;

import com.fasterxml.jackson.annotation.JsonView;

/**
 * Entity评论
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Entity
public class Review extends BaseEntity<Long> {

	private static final long serialVersionUID = 8795901519290584100L;

	/**
	 * 路径
	 */
	private static final String PATH = "/review/detail/%d";

	/**
	 * 类型
	 */
	public enum Type {

		/**
		 * 好评
		 */
		positive,

		/**
		 * 中评
		 */
		moderate,

		/**
		 * 差评
		 */
		negative
	}

	/**
	 * 评分
	 */
	@JsonView(BaseView.class)
	@NotNull
	@Min(1)
	@Max(5)
	@Column(nullable = false, updatable = false)
	private Integer score;

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
	@JoinColumn(nullable = false, updatable = false)
	private Member member;

	/**
	 * 商品
	 */
	@JsonView(BaseView.class)
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(nullable = false, updatable = false)
	private Product product;

	/**
	 * 店铺
	 */
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(nullable = false)
	private Store store;

	/**
	 * 回复
	 */
	@JsonView(BaseView.class)
	@OneToMany(mappedBy = "forReview", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
	@OrderBy("createdDate asc")
	private Set<Review> replyReviews = new HashSet<>();

	/**
	 * 评论
	 */
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(updatable = false)
	private Review forReview;

	/**
	 * 获取评分
	 * 
	 * @return 评分
	 */
	public Integer getScore() {
		return score;
	}

	/**
	 * 设置评分
	 * 
	 * @param score
	 *            评分
	 */
	public void setScore(Integer score) {
		this.score = score;
	}

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
	 * 获取回复
	 * 
	 * @return 回复
	 */
	public Set<Review> getReplyReviews() {
		return replyReviews;
	}

	/**
	 * 设置回复
	 * 
	 * @param replyReviews
	 *            回复
	 */
	public void setReplyReviews(Set<Review> replyReviews) {
		this.replyReviews = replyReviews;
	}

	/**
	 * 获取评论
	 * 
	 * @return 评论
	 */
	public Review getForReview() {
		return forReview;
	}

	/**
	 * 设置评论
	 * 
	 * @param forReview
	 *            评论
	 */
	public void setForReview(Review forReview) {
		this.forReview = forReview;
	}

	/**
	 * 获取路径
	 * 
	 * @return 路径
	 */
	@JsonView(BaseView.class)
	@Transient
	public String getPath() {
		return String.format(Review.PATH, getProduct().getId());
	}

}