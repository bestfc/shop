/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.entity;

import java.math.BigDecimal;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.Lob;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.OrderBy;
import javax.persistence.PrePersist;
import javax.persistence.PreUpdate;
import javax.persistence.Transient;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;

import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.lang.StringUtils;
import org.hibernate.search.annotations.Analyze;
import org.hibernate.search.annotations.Boost;
import org.hibernate.search.annotations.Field;
import org.hibernate.search.annotations.Index;
import org.hibernate.search.annotations.Indexed;
import org.hibernate.validator.constraints.Email;
import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;

import com.fasterxml.jackson.annotation.JsonView;

/**
 * Entity店铺
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Indexed
@Entity
public class Store extends BaseEntity<Long> {

	private static final long serialVersionUID = -406440213727498768L;

	/**
	 * 路径
	 */
	private static final String PATH = "/store/%d";

	/**
	 * 类型
	 */
	public enum Type {

		/**
		 * 普通
		 */
		general,

		/**
		 * 自营
		 */
		self
	}

	/**
	 * 状态
	 */
	public enum Status {

		/**
		 * 等待审核
		 */
		pending,

		/**
		 * 审核失败
		 */
		failed,

		/**
		 * 审核通过
		 */
		approved,

		/**
		 * 开店成功
		 */
		success
	}

	/**
	 * 名称
	 */
	@JsonView(BaseView.class)
	@Field(store = org.hibernate.search.annotations.Store.YES, index = Index.YES, analyze = Analyze.YES)
	@Boost(1.5F)
	@NotEmpty
	@Length(max = 200)
	@Column(nullable = false, unique = true)
	private String name;

	/**
	 * 类型
	 */
	@JsonView(BaseView.class)
	@Field(store = org.hibernate.search.annotations.Store.YES, index = Index.YES, analyze = Analyze.NO)
	@NotNull
	@Column(nullable = false, updatable = false)
	private Store.Type type;

	/**
	 * 状态
	 */
	@Field(store = org.hibernate.search.annotations.Store.YES, index = Index.YES, analyze = Analyze.NO)
	@Column(nullable = false)
	private Store.Status status;

	/**
	 * logo
	 */
	@JsonView(BaseView.class)
	@Length(max = 200)
	@Pattern(regexp = "^(?i)(http:\\/\\/|https:\\/\\/|\\/).*$")
	private String logo;

	/**
	 * E-mail
	 */
	@NotEmpty
	@Email
	@Length(max = 200)
	@Column(nullable = false)
	private String email;

	/**
	 * 手机
	 */
	@NotEmpty
	@Length(max = 200)
	@Pattern(regexp = "^1[3|4|5|7|8]\\d{9}$")
	@Column(nullable = false)
	private String mobile;

	/**
	 * 电话
	 */
	@Length(max = 200)
	private String phone;

	/**
	 * 地址
	 */
	@Length(max = 200)
	private String address;

	/**
	 * 邮编
	 */
	@Length(max = 200)
	private String zipCode;

	/**
	 * 简介
	 */
	@Lob
	private String introduction;

	/**
	 * 搜索关键词
	 */
	@Field(store = org.hibernate.search.annotations.Store.YES, index = Index.YES, analyze = Analyze.YES)
	@Boost(1.5F)
	@Length(max = 200)
	private String keyword;

	/**
	 * 到期日期
	 */
	@NotNull
	@Column(nullable = false)
	private Date endDate;

	/**
	 * 折扣促销到期日期
	 */
	private Date discountPromotionEndDate;

	/**
	 * 满减促销到期日期
	 */
	private Date fullReductionPromotionEndDate;

	/**
	 * 是否启用
	 */
	@Field(store = org.hibernate.search.annotations.Store.YES, index = Index.YES, analyze = Analyze.NO)
	@NotNull
	@Column(nullable = false)
	private Boolean isEnabled;

	/**
	 * 已付保证金
	 */
	@Column(nullable = false, precision = 27, scale = 12)
	private BigDecimal bailPaid;

	/**
	 * 商家
	 */
	@NotNull
	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(nullable = false, updatable = false)
	private Business business;

	/**
	 * 店铺等级
	 */
	@NotNull
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(nullable = false)
	private StoreRank storeRank;

	/**
	 * 店铺分类
	 */
	@NotNull
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(nullable = false)
	private StoreCategory storeCategory;

	/**
	 * 店铺广告图片
	 */
	@OneToMany(mappedBy = "store", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
	@OrderBy("order asc")
	private Set<StoreAdImage> storeAdImages = new HashSet<>();

	/**
	 * 即时通讯
	 */
	@OneToMany(mappedBy = "store", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
	@OrderBy("order asc")
	private Set<InstantMessage> instantMessages = new HashSet<>();

	/**
	 * 店铺商品分类
	 */
	@OneToMany(mappedBy = "store", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
	@OrderBy("order asc")
	private Set<StoreProductCategory> storeProductCategories = new HashSet<>();

	/**
	 * 经营分类
	 */
	@ManyToMany(fetch = FetchType.LAZY)
	@OrderBy("order asc")
	private Set<ProductCategory> productCategories = new HashSet<>();

	/**
	 * 经营分类申请
	 */
	@OneToMany(mappedBy = "store", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
	private Set<CategoryApplication> categoryApplications = new HashSet<>();

	/**
	 * 店铺商品标签
	 */
	@OneToMany(mappedBy = "store", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
	@OrderBy("order asc")
	private Set<StoreProductTag> storeProductTags = new HashSet<>();

	/**
	 * 商品
	 */
	@OneToMany(mappedBy = "store", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
	private Set<Product> products = new HashSet<>();

	/**
	 * 促销
	 */
	@OneToMany(mappedBy = "store", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
	@OrderBy("order asc")
	private Set<Promotion> promotions = new HashSet<>();

	/**
	 * 优惠券
	 */
	@OneToMany(mappedBy = "store", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
	private Set<Coupon> coupons = new HashSet<>();

	/**
	 * 订单
	 */
	@OneToMany(mappedBy = "store", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
	private Set<Order> orders = new HashSet<>();

	/**
	 * 店铺收藏
	 */
	@OneToMany(mappedBy = "store", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
	private Set<StoreFavorite> storeFavorites = new HashSet<>();

	/**
	 * 快递单模板
	 */
	@OneToMany(mappedBy = "store", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
	private Set<DeliveryTemplate> deliveryTemplates = new HashSet<>();

	/**
	 * 发货点
	 */
	@OneToMany(mappedBy = "store", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
	private Set<DeliveryCenter> deliveryCenters = new HashSet<>();

	/**
	 * 默认运费配置
	 */
	@OneToMany(mappedBy = "store", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
	private Set<DefaultFreightConfig> defaultFreightConfigs = new HashSet<>();

	/**
	 * 地区运费配置
	 */
	@OneToMany(mappedBy = "store", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
	private Set<AreaFreightConfig> areaFreightConfigs = new HashSet<>();

	/**
	 * 服务
	 */
	@OneToMany(mappedBy = "store", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
	private Set<Svc> svcs = new HashSet<>();

	/**
	 * 支付事务
	 */
	@OneToMany(mappedBy = "store", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
	private Set<PaymentTransaction> paymentTransactions = new HashSet<>();

	/**
	 * 咨询
	 */
	@OneToMany(mappedBy = "store", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
	private Set<Consultation> consultations = new HashSet<>();

	/**
	 * 评论
	 */
	@OneToMany(mappedBy = "store", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
	private Set<Review> reviews = new HashSet<>();

	/**
	 * 统计
	 */
	@OneToMany(mappedBy = "store", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
	private Set<Statistic> statistics = new HashSet<>();

	/**
	 * 获取名称
	 * 
	 * @return 名称
	 */
	public String getName() {
		return name;
	}

	/**
	 * 设置名称
	 * 
	 * @param name
	 *            名称
	 */
	public void setName(String name) {
		this.name = name;
	}

	/**
	 * 获取类型
	 * 
	 * @return 类型
	 */
	public Store.Type getType() {
		return type;
	}

	/**
	 * 设置类型
	 * 
	 * @param type
	 *            类型
	 */
	public void setType(Store.Type type) {
		this.type = type;
	}

	/**
	 * 获取状态
	 * 
	 * @return 状态
	 */
	public Store.Status getStatus() {
		return status;
	}

	/**
	 * 设置状态
	 * 
	 * @param status
	 *            状态
	 */
	public void setStatus(Store.Status status) {
		this.status = status;
	}

	/**
	 * 获取logo
	 * 
	 * @return logo
	 */
	public String getLogo() {
		return logo;
	}

	/**
	 * 设置logo
	 * 
	 * @param logo
	 *            logo
	 */
	public void setLogo(String logo) {
		this.logo = logo;
	}

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
	 * 获取手机
	 * 
	 * @return 手机
	 */
	public String getMobile() {
		return mobile;
	}

	/**
	 * 设置手机
	 * 
	 * @param mobile
	 *            手机
	 */
	public void setMobile(String mobile) {
		this.mobile = mobile;
	}

	/**
	 * 获取电话
	 * 
	 * @return 电话
	 */
	public String getPhone() {
		return phone;
	}

	/**
	 * 设置电话
	 * 
	 * @param phone
	 *            电话
	 */
	public void setPhone(String phone) {
		this.phone = phone;
	}

	/**
	 * 获取地址
	 * 
	 * @return 地址
	 */
	public String getAddress() {
		return address;
	}

	/**
	 * 设置地址
	 * 
	 * @param address
	 *            地址
	 */
	public void setAddress(String address) {
		this.address = address;
	}

	/**
	 * 获取邮编
	 * 
	 * @return 邮编
	 */
	public String getZipCode() {
		return zipCode;
	}

	/**
	 * 设置邮编
	 * 
	 * @param zipCode
	 *            邮编
	 */
	public void setZipCode(String zipCode) {
		this.zipCode = zipCode;
	}

	/**
	 * 获取简介
	 * 
	 * @return 简介
	 */
	public String getIntroduction() {
		return introduction;
	}

	/**
	 * 设置简介
	 * 
	 * @param introduction
	 *            简介
	 */
	public void setIntroduction(String introduction) {
		this.introduction = introduction;
	}

	/**
	 * 获取搜索关键词
	 * 
	 * @return 搜索关键词
	 */
	public String getKeyword() {
		return keyword;
	}

	/**
	 * 设置搜索关键词
	 * 
	 * @param keyword
	 *            搜索关键词
	 */
	public void setKeyword(String keyword) {
		if (keyword != null) {
			keyword = keyword.replaceAll("[,\\s]*,[,\\s]*", ",").replaceAll("^,|,$", "");
		}
		this.keyword = keyword;
	}

	/**
	 * 获取到期日期
	 * 
	 * @return 到期日期
	 */
	public Date getEndDate() {
		return endDate;
	}

	/**
	 * 设置到期日期
	 * 
	 * @param endDate
	 *            到期日期
	 */
	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}

	/**
	 * 获取折扣促销到期日期
	 * 
	 * @return 折扣促销到期日期
	 */
	public Date getDiscountPromotionEndDate() {
		return discountPromotionEndDate;
	}

	/**
	 * 设置折扣促销到期日期
	 * 
	 * @param discountPromotionEndDate
	 *            折扣促销到期日期
	 */
	public void setDiscountPromotionEndDate(Date discountPromotionEndDate) {
		this.discountPromotionEndDate = discountPromotionEndDate;
	}

	/**
	 * 获取满减促销到期日期
	 * 
	 * @return 满减促销到期日期
	 */
	public Date getFullReductionPromotionEndDate() {
		return fullReductionPromotionEndDate;
	}

	/**
	 * 设置满减促销到期日期
	 * 
	 * @param fullReductionPromotionEndDate
	 *            满减促销到期日期
	 */
	public void setFullReductionPromotionEndDate(Date fullReductionPromotionEndDate) {
		this.fullReductionPromotionEndDate = fullReductionPromotionEndDate;
	}

	/**
	 * 获取是否启用
	 * 
	 * @return 是否启用
	 */
	public Boolean getIsEnabled() {
		return isEnabled;
	}

	/**
	 * 设置是否启用
	 * 
	 * @param isEnabled
	 *            是否启用
	 */
	public void setIsEnabled(Boolean isEnabled) {
		this.isEnabled = isEnabled;
	}

	/**
	 * 获取已付保证金
	 * 
	 * @return 已付保证金
	 */
	public BigDecimal getBailPaid() {
		return bailPaid;
	}

	/**
	 * 设置已付保证金
	 * 
	 * @param bailPaid
	 *            已付保证金
	 */
	public void setBailPaid(BigDecimal bailPaid) {
		this.bailPaid = bailPaid;
	}

	/**
	 * 获取商家
	 * 
	 * @return 商家
	 */
	public Business getBusiness() {
		return business;
	}

	/**
	 * 设置商家
	 * 
	 * @param business
	 *            商家
	 */
	public void setBusiness(Business business) {
		this.business = business;
	}

	/**
	 * 获取店铺等级
	 * 
	 * @return 店铺等级
	 */
	public StoreRank getStoreRank() {
		return storeRank;
	}

	/**
	 * 设置店铺等级
	 * 
	 * @param storeRank
	 *            店铺等级
	 */
	public void setStoreRank(StoreRank storeRank) {
		this.storeRank = storeRank;
	}

	/**
	 * 获取店铺分类
	 * 
	 * @return 店铺分类
	 */
	public StoreCategory getStoreCategory() {
		return storeCategory;
	}

	/**
	 * 设置店铺分类
	 * 
	 * @param storeCategory
	 *            店铺分类
	 */
	public void setStoreCategory(StoreCategory storeCategory) {
		this.storeCategory = storeCategory;
	}

	/**
	 * 获取店铺广告图片
	 * 
	 * @return 店铺广告图片
	 */
	public Set<StoreAdImage> getStoreAdImages() {
		return storeAdImages;
	}

	/**
	 * 设置店铺广告图片
	 * 
	 * @param storeAdImages
	 *            店铺广告图片
	 */
	public void setStoreAdImages(Set<StoreAdImage> storeAdImages) {
		this.storeAdImages = storeAdImages;
	}

	/**
	 * 获取即时通讯
	 * 
	 * @return 即时通讯
	 */
	public Set<InstantMessage> getInstantMessages() {
		return instantMessages;
	}

	/**
	 * 设置即时通讯
	 * 
	 * @param instantMessages
	 *            即时通讯
	 */
	public void setInstantMessages(Set<InstantMessage> instantMessages) {
		this.instantMessages = instantMessages;
	}

	/**
	 * 获取店铺商品分类
	 * 
	 * @return 店铺商品分类
	 */
	public Set<StoreProductCategory> getStoreProductCategories() {
		return storeProductCategories;
	}

	/**
	 * 设置店铺商品分类
	 * 
	 * @param storeProductCategories
	 *            店铺商品分类
	 */
	public void setStoreProductCategories(Set<StoreProductCategory> storeProductCategories) {
		this.storeProductCategories = storeProductCategories;
	}

	/**
	 * 获取经营分类
	 * 
	 * @return 经营分类
	 */
	public Set<ProductCategory> getProductCategories() {
		return productCategories;
	}

	/**
	 * 设置经营分类
	 * 
	 * @param productCategories
	 *            经营分类
	 */
	public void setProductCategories(Set<ProductCategory> productCategories) {
		this.productCategories = productCategories;
	}

	/**
	 * 获取经营分类申请
	 * 
	 * @return 经营分类申请
	 */
	public Set<CategoryApplication> getCategoryApplications() {
		return categoryApplications;
	}

	/**
	 * 设置经营分类申请
	 * 
	 * @param categoryApplications
	 *            经营分类申请
	 */
	public void setCategoryApplications(Set<CategoryApplication> categoryApplications) {
		this.categoryApplications = categoryApplications;
	}

	/**
	 * 获取店铺商品标签
	 * 
	 * @return 店铺商品标签
	 */
	public Set<StoreProductTag> getStoreProductTags() {
		return storeProductTags;
	}

	/**
	 * 设置店铺商品标签
	 * 
	 * @param storeProductTags
	 *            店铺商品标签
	 */
	public void setStoreProductTags(Set<StoreProductTag> storeProductTags) {
		this.storeProductTags = storeProductTags;
	}

	/**
	 * 获取商品
	 * 
	 * @return 商品
	 */
	public Set<Product> getProducts() {
		return products;
	}

	/**
	 * 设置商品
	 * 
	 * @param products
	 *            商品
	 */
	public void setProducts(Set<Product> products) {
		this.products = products;
	}

	/**
	 * 获取促销
	 * 
	 * @return 促销
	 */
	public Set<Promotion> getPromotions() {
		return promotions;
	}

	/**
	 * 设置促销
	 * 
	 * @param promotions
	 *            促销
	 */
	public void setPromotions(Set<Promotion> promotions) {
		this.promotions = promotions;
	}

	/**
	 * 获取优惠券
	 * 
	 * @return 优惠券
	 */
	public Set<Coupon> getCoupons() {
		return coupons;
	}

	/**
	 * 设置优惠券
	 * 
	 * @param coupons
	 *            优惠券
	 */
	public void setCoupons(Set<Coupon> coupons) {
		this.coupons = coupons;
	}

	/**
	 * 获取订单
	 * 
	 * @return 订单
	 */
	public Set<Order> getOrders() {
		return orders;
	}

	/**
	 * 设置订单
	 * 
	 * @param orders
	 *            订单
	 */
	public void setOrders(Set<Order> orders) {
		this.orders = orders;
	}

	/**
	 * 获取店铺收藏
	 * 
	 * @return 店铺收藏
	 */
	public Set<StoreFavorite> getStoreFavorites() {
		return storeFavorites;
	}

	/**
	 * 设置店铺收藏
	 * 
	 * @param storeFavorites
	 *            店铺收藏
	 */
	public void setStoreFavorites(Set<StoreFavorite> storeFavorites) {
		this.storeFavorites = storeFavorites;
	}

	/**
	 * 获取快递单模板
	 * 
	 * @return 快递单模板
	 */
	public Set<DeliveryTemplate> getDeliveryTemplates() {
		return deliveryTemplates;
	}

	/**
	 * 设置快递单模板
	 * 
	 * @param deliveryTemplates
	 *            快递单模板
	 */
	public void setDeliveryTemplates(Set<DeliveryTemplate> deliveryTemplates) {
		this.deliveryTemplates = deliveryTemplates;
	}

	/**
	 * 获取发货点
	 * 
	 * @return 发货点
	 */
	public Set<DeliveryCenter> getDeliveryCenters() {
		return deliveryCenters;
	}

	/**
	 * 设置发货点
	 * 
	 * @param deliveryCenters
	 *            发货点
	 */
	public void setDeliveryCenters(Set<DeliveryCenter> deliveryCenters) {
		this.deliveryCenters = deliveryCenters;
	}

	/**
	 * 获取默认运费配置
	 * 
	 * @return 默认运费配置
	 */
	public Set<DefaultFreightConfig> getDefaultFreightConfigs() {
		return defaultFreightConfigs;
	}

	/**
	 * 设置默认运费配置
	 * 
	 * @param defaultFreightConfigs
	 *            默认运费配置
	 */
	public void setDefaultFreightConfigs(Set<DefaultFreightConfig> defaultFreightConfigs) {
		this.defaultFreightConfigs = defaultFreightConfigs;
	}

	/**
	 * 获取地区运费配置
	 * 
	 * @return 地区运费配置
	 */
	public Set<AreaFreightConfig> getAreaFreightConfigs() {
		return areaFreightConfigs;
	}

	/**
	 * 设置地区运费配置
	 * 
	 * @param areaFreightConfigs
	 *            地区运费配置
	 */
	public void setAreaFreightConfigs(Set<AreaFreightConfig> areaFreightConfigs) {
		this.areaFreightConfigs = areaFreightConfigs;
	}

	/**
	 * 获取服务
	 * 
	 * @return 服务
	 */
	public Set<Svc> getSvcs() {
		return svcs;
	}

	/**
	 * 设置服务
	 * 
	 * @param svcs
	 *            服务
	 */
	public void setSvcs(Set<Svc> svcs) {
		this.svcs = svcs;
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

	/**
	 * 获取咨询
	 * 
	 * @return 咨询
	 */
	public Set<Consultation> getConsultations() {
		return consultations;
	}

	/**
	 * 设置咨询
	 * 
	 * @param consultations
	 *            咨询
	 */
	public void setConsultations(Set<Consultation> consultations) {
		this.consultations = consultations;
	}

	/**
	 * 获取评论
	 * 
	 * @return 评论
	 */
	public Set<Review> getReviews() {
		return reviews;
	}

	/**
	 * 设置评论
	 * 
	 * @param reviews
	 *            评论
	 */
	public void setReviews(Set<Review> reviews) {
		this.reviews = reviews;
	}

	/**
	 * 获取统计
	 * 
	 * @return 统计
	 */
	public Set<Statistic> getStatistics() {
		return statistics;
	}

	/**
	 * 设置统计
	 * 
	 * @param statistics
	 *            统计
	 */
	public void setStatistics(Set<Statistic> statistics) {
		this.statistics = statistics;
	}

	/**
	 * 获取路径
	 * 
	 * @return 路径
	 */
	@JsonView(BaseView.class)
	@Transient
	public String getPath() {
		return String.format(Store.PATH, getId());
	}

	/**
	 * 获取应付保证金
	 * 
	 * @return 应付保证金
	 */
	@Transient
	public BigDecimal getBailPayable() {
		if (Store.Status.approved.equals(getStatus())) {
			BigDecimal bailPayable = getStoreCategory().getBail().subtract(getBailPaid());
			return bailPayable.compareTo(BigDecimal.ZERO) >= 0 ? bailPayable : BigDecimal.ZERO;
		}
		return BigDecimal.ZERO;
	}

	/**
	 * 判断是否为自营店铺
	 * 
	 * @return 是否为自营店铺
	 */
	@Transient
	public boolean isSelf() {
		return Type.self.equals(getType());
	}

	/**
	 * 判断店铺是否有效
	 * 
	 * @return 店铺是否有效
	 */
	@Transient
	public boolean isActive() {
		return BooleanUtils.isTrue(getIsEnabled()) && Status.success.equals(getStatus()) && !hasExpired();
	}

	/**
	 * 判断店铺是否已过期
	 * 
	 * @return 店铺是否已过期
	 */
	@Transient
	public boolean hasExpired() {
		return getEndDate() != null && !getEndDate().after(new Date());
	}

	/**
	 * 判断折扣促销是否已过期
	 * 
	 * @return 折扣促销是否已过期
	 */
	@Transient
	public boolean discountPromotionHasExpired() {
		return !Type.self.equals(getType()) && (getDiscountPromotionEndDate() == null || !getDiscountPromotionEndDate().after(new Date()));
	}

	/**
	 * 判断满减促销是否已过期
	 * 
	 * @return 满减促销是否已过期
	 */
	@Transient
	public boolean fullReductionPromotionHasExpired() {
		return !Type.self.equals(getType()) && (getFullReductionPromotionEndDate() == null || !getFullReductionPromotionEndDate().after(new Date()));
	}

	/**
	 * 持久化前处理
	 */
	@PrePersist
	public void prePersist() {
		setEmail(StringUtils.lowerCase(getEmail()));
		setMobile(StringUtils.lowerCase(getMobile()));
	}

	/**
	 * 更新前处理
	 */
	@PreUpdate
	public void preUpdate() {
		setEmail(StringUtils.lowerCase(getEmail()));
		setMobile(StringUtils.lowerCase(getMobile()));
	}

}