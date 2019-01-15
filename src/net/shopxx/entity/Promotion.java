/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.entity;

import java.math.BigDecimal;
import java.math.MathContext;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.Lob;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.OrderBy;
import javax.persistence.PreRemove;
import javax.persistence.Transient;
import javax.validation.constraints.Digits;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;

import org.apache.commons.lang.StringUtils;
import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;

import groovy.lang.Binding;
import groovy.lang.GroovyShell;

/**
 * Entity促销
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Entity
public class Promotion extends OrderedEntity<Long> {

	private static final long serialVersionUID = 3536993535267962279L;

	/**
	 * 路径
	 */
	private static final String PATH = "/promotion/detail/%d";

	/**
	 * 类型
	 */
	public enum Type {

		/**
		 * 折扣
		 */
		discount,

		/**
		 * 满减
		 */
		fullReduction
	}

	/**
	 * 名称
	 */
	@NotEmpty
	@Length(max = 200)
	@Column(nullable = false)
	private String name;

	/**
	 * 标题
	 */
	@NotEmpty
	@Length(max = 200)
	@Column(nullable = false)
	private String title;

	/**
	 * 类型
	 */
	@Column(nullable = false)
	private Promotion.Type type;

	/**
	 * 图片
	 */
	@Length(max = 200)
	@Pattern(regexp = "^(?i)(http:\\/\\/|https:\\/\\/|\\/).*$")
	private String image;

	/**
	 * 起始日期
	 */
	private Date beginDate;

	/**
	 * 结束日期
	 */
	private Date endDate;

	/**
	 * 最小SKU价格
	 */
	@Min(0)
	@Digits(integer = 12, fraction = 3)
	@Column(precision = 21, scale = 6)
	private BigDecimal minimumPrice;

	/**
	 * 最大SKU价格
	 */
	@Min(0)
	@Digits(integer = 12, fraction = 3)
	@Column(precision = 21, scale = 6)
	private BigDecimal maximumPrice;

	/**
	 * 最小SKU数量
	 */
	@Min(0)
	private Integer minimumQuantity;

	/**
	 * 最大SKU数量
	 */
	@Min(0)
	private Integer maximumQuantity;

	/**
	 * 价格运算表达式
	 */
	private String priceExpression;

	/**
	 * 是否免运费
	 */
	@NotNull
	@Column(nullable = false)
	private Boolean isFreeShipping;

	/**
	 * 是否允许使用优惠券
	 */
	@NotNull
	@Column(nullable = false)
	private Boolean isCouponAllowed;

	/**
	 * 介绍
	 */
	@Lob
	private String introduction;

	/**
	 * 条件金额
	 */
	@Min(0)
	@Digits(integer = 12, fraction = 3)
	@Column(precision = 21, scale = 6)
	private BigDecimal conditionsAmount;

	/**
	 * 减免金额
	 */
	@Min(0)
	@Digits(integer = 12, fraction = 3)
	@Column(precision = 21, scale = 6)
	private BigDecimal creditAmount;

	/**
	 * 条件数量
	 */
	@Min(0)
	private Integer conditionsNumber;

	/**
	 * 满减数量
	 */
	@Min(0)
	private Integer creditNumber;

	/**
	 * 折扣
	 */
	@Digits(integer = 12, fraction = 3)
	@Column(precision = 21, scale = 6)
	private Double discount;

	/**
	 * 是否启用
	 */
	@NotNull
	@Column(nullable = false)
	private Boolean isEnabled;

	/**
	 * 店铺
	 */
	@NotNull
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(nullable = false)
	private Store store;

	/**
	 * 允许参加会员等级
	 */
	@ManyToMany(fetch = FetchType.LAZY)
	private Set<MemberRank> memberRanks = new HashSet<>();

	/**
	 * 赠送优惠券
	 */
	@ManyToMany(fetch = FetchType.LAZY)
	private Set<Coupon> coupons = new HashSet<>();

	/**
	 * 赠品
	 */
	@ManyToMany(fetch = FetchType.LAZY)
	private Set<Sku> gifts = new HashSet<>();

	/**
	 * 商品
	 */
	@ManyToMany(mappedBy = "promotions", fetch = FetchType.LAZY)
	private Set<Product> products = new HashSet<>();

	/**
	 * 商品分类
	 */
	@ManyToMany(mappedBy = "promotions", fetch = FetchType.LAZY)
	@OrderBy("order asc")
	private Set<ProductCategory> productCategories = new HashSet<>();

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
	 * 获取标题
	 * 
	 * @return 标题
	 */
	public String getTitle() {
		return title;
	}

	/**
	 * 设置标题
	 * 
	 * @param title
	 *            标题
	 */
	public void setTitle(String title) {
		this.title = title;
	}

	/**
	 * 获取类型
	 * 
	 * @return 类型
	 */
	public Promotion.Type getType() {
		return type;
	}

	/**
	 * 设置类型
	 * 
	 * @param type
	 *            类型
	 */
	public void setType(Promotion.Type type) {
		this.type = type;
	}

	/**
	 * 获取图片
	 * 
	 * @return 图片
	 */
	public String getImage() {
		return image;
	}

	/**
	 * 设置图片
	 * 
	 * @param image
	 *            图片
	 */
	public void setImage(String image) {
		this.image = image;
	}

	/**
	 * 获取起始日期
	 * 
	 * @return 起始日期
	 */
	public Date getBeginDate() {
		return beginDate;
	}

	/**
	 * 设置起始日期
	 * 
	 * @param beginDate
	 *            起始日期
	 */
	public void setBeginDate(Date beginDate) {
		this.beginDate = beginDate;
	}

	/**
	 * 获取结束日期
	 * 
	 * @return 结束日期
	 */
	public Date getEndDate() {
		return endDate;
	}

	/**
	 * 设置结束日期
	 * 
	 * @param endDate
	 *            结束日期
	 */
	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}

	/**
	 * 获取最小SKU价格
	 * 
	 * @return 最小SKU价格
	 */
	public BigDecimal getMinimumPrice() {
		return minimumPrice;
	}

	/**
	 * 设置最小SKU价格
	 * 
	 * @param minimumPrice
	 *            最小SKU价格
	 */
	public void setMinimumPrice(BigDecimal minimumPrice) {
		this.minimumPrice = minimumPrice;
	}

	/**
	 * 获取最大SKU价格
	 * 
	 * @return 最大SKU价格
	 */
	public BigDecimal getMaximumPrice() {
		return maximumPrice;
	}

	/**
	 * 设置最大SKU价格
	 * 
	 * @param maximumPrice
	 *            最大SKU价格
	 */
	public void setMaximumPrice(BigDecimal maximumPrice) {
		this.maximumPrice = maximumPrice;
	}

	/**
	 * 获取最小SKU数量
	 * 
	 * @return 最小SKU数量
	 */
	public Integer getMinimumQuantity() {
		return minimumQuantity;
	}

	/**
	 * 设置最小SKU数量
	 * 
	 * @param minimumQuantity
	 *            最小SKU数量
	 */
	public void setMinimumQuantity(Integer minimumQuantity) {
		this.minimumQuantity = minimumQuantity;
	}

	/**
	 * 获取最大SKU数量
	 * 
	 * @return 最大SKU数量
	 */
	public Integer getMaximumQuantity() {
		return maximumQuantity;
	}

	/**
	 * 设置最大SKU数量
	 * 
	 * @param maximumQuantity
	 *            最大SKU数量
	 */
	public void setMaximumQuantity(Integer maximumQuantity) {
		this.maximumQuantity = maximumQuantity;
	}

	/**
	 * 获取价格运算表达式
	 * 
	 * @return 价格运算表达式
	 */
	public String getPriceExpression() {
		return priceExpression;
	}

	/**
	 * 设置价格运算表达式
	 * 
	 * @param priceExpression
	 *            价格运算表达式
	 */
	public void setPriceExpression(String priceExpression) {
		this.priceExpression = priceExpression;
	}

	/**
	 * 获取是否免运费
	 * 
	 * @return 是否免运费
	 */
	public Boolean getIsFreeShipping() {
		return isFreeShipping;
	}

	/**
	 * 设置是否免运费
	 * 
	 * @param isFreeShipping
	 *            是否免运费
	 */
	public void setIsFreeShipping(Boolean isFreeShipping) {
		this.isFreeShipping = isFreeShipping;
	}

	/**
	 * 获取是否允许使用优惠券
	 * 
	 * @return 是否允许使用优惠券
	 */
	public Boolean getIsCouponAllowed() {
		return isCouponAllowed;
	}

	/**
	 * 设置是否允许使用优惠券
	 * 
	 * @param isCouponAllowed
	 *            是否允许使用优惠券
	 */
	public void setIsCouponAllowed(Boolean isCouponAllowed) {
		this.isCouponAllowed = isCouponAllowed;
	}

	/**
	 * 获取介绍
	 * 
	 * @return 介绍
	 */
	public String getIntroduction() {
		return introduction;
	}

	/**
	 * 设置介绍
	 * 
	 * @param introduction
	 *            介绍
	 */
	public void setIntroduction(String introduction) {
		this.introduction = introduction;
	}

	/**
	 * 获取条件金额
	 * 
	 * @return 条件金额
	 */
	public BigDecimal getConditionsAmount() {
		return conditionsAmount;
	}

	/**
	 * 设置条件金额
	 * 
	 * @param conditionsAmount
	 *            条件金额
	 */
	public void setConditionsAmount(BigDecimal conditionsAmount) {
		this.conditionsAmount = conditionsAmount;
	}

	/**
	 * 获取减免金额
	 * 
	 * @return 减免金额
	 */
	public BigDecimal getCreditAmount() {
		return creditAmount;
	}

	/**
	 * 设置减免金额
	 * 
	 * @param creditAmount
	 *            减免金额
	 */
	public void setCreditAmount(BigDecimal creditAmount) {
		this.creditAmount = creditAmount;
	}

	/**
	 * 获取条件数量
	 * 
	 * @return 条件数量
	 */
	public Integer getConditionsNumber() {
		return conditionsNumber;
	}

	/**
	 * 设置条件数量
	 * 
	 * @param conditionsNumber
	 *            条件数量
	 */
	public void setConditionsNumber(Integer conditionsNumber) {
		this.conditionsNumber = conditionsNumber;
	}

	/**
	 * 获取满减数量
	 * 
	 * @return 满减数量
	 */
	public Integer getCreditNumber() {
		return creditNumber;
	}

	/**
	 * 设置满减数量
	 * 
	 * @param creditNumber
	 *            满减数量
	 */
	public void setCreditNumber(Integer creditNumber) {
		this.creditNumber = creditNumber;
	}

	/**
	 * 获取折扣
	 * 
	 * @return 折扣
	 */
	public Double getDiscount() {
		return discount;
	}

	/**
	 * 设置折扣
	 * 
	 * @param discount
	 *            折扣
	 */
	public void setDiscount(Double discount) {
		this.discount = discount;
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
	 * 获取允许参加会员等级
	 * 
	 * @return 允许参加会员等级
	 */
	public Set<MemberRank> getMemberRanks() {
		return memberRanks;
	}

	/**
	 * 设置允许参加会员等级
	 * 
	 * @param memberRanks
	 *            允许参加会员等级
	 */
	public void setMemberRanks(Set<MemberRank> memberRanks) {
		this.memberRanks = memberRanks;
	}

	/**
	 * 获取赠送优惠券
	 * 
	 * @return 赠送优惠券
	 */
	public Set<Coupon> getCoupons() {
		return coupons;
	}

	/**
	 * 设置赠送优惠券
	 * 
	 * @param coupons
	 *            赠送优惠券
	 */
	public void setCoupons(Set<Coupon> coupons) {
		this.coupons = coupons;
	}

	/**
	 * 获取赠品
	 * 
	 * @return 赠品
	 */
	public Set<Sku> getGifts() {
		return gifts;
	}

	/**
	 * 设置赠品
	 * 
	 * @param gifts
	 *            赠品
	 */
	public void setGifts(Set<Sku> gifts) {
		this.gifts = gifts;
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
	 * 获取商品分类
	 * 
	 * @return 商品分类
	 */
	public Set<ProductCategory> getProductCategories() {
		return productCategories;
	}

	/**
	 * 设置商品分类
	 * 
	 * @param productCategories
	 *            商品分类
	 */
	public void setProductCategories(Set<ProductCategory> productCategories) {
		this.productCategories = productCategories;
	}

	/**
	 * 获取路径
	 * 
	 * @return 路径
	 */
	@Transient
	public String getPath() {
		return String.format(Promotion.PATH, getId());
	}

	/**
	 * 判断是否已开始
	 * 
	 * @return 是否已开始
	 */
	@Transient
	public boolean hasBegun() {
		return getBeginDate() == null || !getBeginDate().after(new Date());
	}

	/**
	 * 判断是否已结束
	 * 
	 * @return 是否已结束
	 */
	@Transient
	public boolean hasEnded() {
		return getEndDate() != null && !getEndDate().after(new Date());
	}

	/**
	 * 计算促销价格
	 * 
	 * @param price
	 *            SKU价格
	 * @param quantity
	 *            SKU数量
	 * @return 促销价格
	 */
	@Transient
	public BigDecimal calculatePrice(BigDecimal price, Integer quantity) {
		if (price == null || quantity == null || StringUtils.isEmpty(getPriceExpression())) {
			return price;
		}
		BigDecimal result = BigDecimal.ZERO;
		try {
			Binding binding = new Binding();
			binding.setVariable("quantity", quantity);
			binding.setVariable("price", price);
			GroovyShell groovyShell = new GroovyShell(binding);
			result = new BigDecimal(groovyShell.evaluate(getPriceExpression()).toString(), MathContext.DECIMAL32);
		} catch (Exception e) {
			return price;
		}
		if (result.compareTo(price) > 0) {
			return price;
		}
		return result.compareTo(BigDecimal.ZERO) > 0 ? result : BigDecimal.ZERO;
	}

	/**
	 * 删除前处理
	 */
	@PreRemove
	public void preRemove() {
		Set<Product> products = getProducts();
		if (products != null) {
			for (Product product : products) {
				product.getPromotions().remove(this);
			}
		}
		Set<ProductCategory> productCategories = getProductCategories();
		if (productCategories != null) {
			for (ProductCategory productCategory : productCategories) {
				productCategory.getPromotions().remove(this);
			}
		}
	}

}