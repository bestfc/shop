/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.entity;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Convert;
import javax.persistence.Converter;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.OrderBy;
import javax.persistence.PrePersist;
import javax.persistence.PreUpdate;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.validation.Valid;
import javax.validation.constraints.Digits;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;
import javax.validation.groups.Default;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.Predicate;
import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.lang.StringUtils;
import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;

import com.fasterxml.jackson.annotation.JsonView;

import net.shopxx.BaseAttributeConverter;

/**
 * Entity订单
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Entity
@Table(name = "Orders")
public class Order extends BaseEntity<Long> {

	private static final long serialVersionUID = 8370942500343156156L;

	/**
	 * "订单锁"缓存名称
	 */
	public static final String ORDER_LOCK_CACHE_NAME = "orderLock";

	/**
	 * 配送验证组
	 */
	public interface Delivery extends Default {

	}

	/**
	 * 类型
	 */
	public enum Type {

		/**
		 * 普通订单
		 */
		general,

		/**
		 * 兑换订单
		 */
		exchange
	}

	/**
	 * 状态
	 */
	public enum Status {

		/**
		 * 等待付款
		 */
		pendingPayment,

		/**
		 * 等待审核
		 */
		pendingReview,

		/**
		 * 等待发货
		 */
		pendingShipment,

		/**
		 * 已发货
		 */
		shipped,

		/**
		 * 已收货
		 */
		received,

		/**
		 * 已完成
		 */
		completed,

		/**
		 * 已失败
		 */
		failed,

		/**
		 * 已取消
		 */
		canceled,

		/**
		 * 已拒绝
		 */
		denied,
		/**
		 * 交易关闭
		 */
		close,//程序认定关闭
		/**
		 * 全部退款
		 */
		refund
	}

	/**
	 * 编号
	 */
	@JsonView(BaseView.class)
	@Column(nullable = false, updatable = false, unique = true)
	private String sn;

	/**
	 * 类型
	 */
	@JsonView(BaseView.class)
	@Column(nullable = false, updatable = false)
	private Order.Type type;

	/**
	 * 状态
	 */
	@JsonView(BaseView.class)
	@Column(nullable = false)
	private Order.Status status;

	/**
	 * 价格
	 */
	@JsonView(BaseView.class)
	@Column(nullable = false, updatable = false, precision = 21, scale = 6)
	private BigDecimal price;

	/**
	 * 支付手续费
	 */
	@Column(nullable = false, precision = 21, scale = 6)
	private BigDecimal fee;

	/**
	 * 运费
	 */
	@NotNull(groups = Delivery.class)
	@Min(0)
	@Digits(integer = 12, fraction = 3)
	@Column(nullable = false, precision = 21, scale = 6)
	private BigDecimal freight;

	/**
	 * 税金
	 */
	@Min(0)
	@Digits(integer = 12, fraction = 3)
	@Column(nullable = false, precision = 21, scale = 6)
	private BigDecimal tax;

	/**
	 * 促销折扣
	 */
	@Column(nullable = false, updatable = false, precision = 21, scale = 6)
	private BigDecimal promotionDiscount;

	/**
	 * 优惠券折扣
	 */
	@Column(nullable = false, updatable = false, precision = 21, scale = 6)
	private BigDecimal couponDiscount;

	/**
	 * 调整金额
	 */
	@NotNull
	@Digits(integer = 12, fraction = 3)
	@Column(nullable = false, precision = 21, scale = 6)
	private BigDecimal offsetAmount;

	/**
	 * 订单金额
	 */
	@JsonView(BaseView.class)
	@Column(nullable = false, precision = 21, scale = 6)
	private BigDecimal amount;

	/**
	 * 已付金额
	 */
	@Column(nullable = false, precision = 21, scale = 6)
	private BigDecimal amountPaid;

	/**
	 * 退款金额
	 */
	@Column(nullable = false, precision = 21, scale = 6)
	private BigDecimal refundAmount;

	/**
	 * 赠送积分
	 */
	@Min(0)
	@Column(nullable = false)
	private Long rewardPoint;

	/**
	 * 兑换积分
	 */
	@Column(nullable = false, updatable = false)
	private Long exchangePoint;

	/**
	 * 重量
	 */
	@Column(nullable = false, updatable = false)
	private Integer weight;

	/**
	 * 数量
	 */
	@Column(nullable = false, updatable = false)
	private Integer quantity;

	/**
	 * 已发货数量
	 */
	@Column(nullable = false)
	private Integer shippedQuantity;

	/**
	 * 已退货数量
	 */
	@Column(nullable = false)
	private Integer returnedQuantity;

	/**
	 * 收货人
	 */
	@NotEmpty(groups = Delivery.class)
	@Length(max = 200)
	private String consignee;

	/**
	 * 地区名称
	 */
	private String areaName;

	/**
	 * 地址
	 */
	@NotEmpty(groups = Delivery.class)
	@Length(max = 200)
	private String address;

	/**
	 * 邮编
	 */
	@NotEmpty(groups = Delivery.class)
	@Length(max = 200)
	@Pattern(regexp = "^\\d{6}$")
	private String zipCode;

	/**
	 * 电话
	 */
	@NotEmpty(groups = Delivery.class)
	@Length(max = 200)
	@Pattern(regexp = "^\\d{3,4}-?\\d{7,9}$")
	private String phone;

	/**
	 * 附言
	 */
	@Length(max = 200)
	private String memo;

	/**
	 * 过期时间
	 */
	private Date expire;

	/**
	 * 是否已使用优惠码
	 */
	@Column(nullable = false)
	private Boolean isUseCouponCode;

	/**
	 * 是否已兑换积分
	 */
	@Column(nullable = false)
	private Boolean isExchangePoint;

	/**
	 * 是否已分配库存
	 */
	@Column(nullable = false)
	private Boolean isAllocatedStock;

	/**
	 * 支付方式名称
	 */
	private String paymentMethodName;

	/**
	 * 支付方式类型
	 */
	private PaymentMethod.Type paymentMethodType;

	/**
	 * 配送方式名称
	 */
	private String shippingMethodName;

	/**
	 * 完成日期
	 */
	private Date completeDate;

	/**
	 * 发票
	 */
	@Valid
	@Embedded
	private Invoice invoice;

	/**
	 * 地区
	 */
	@NotNull(groups = Delivery.class)
	@ManyToOne(fetch = FetchType.LAZY)
	private Area area;

	/**
	 * 支付方式
	 */
	@ManyToOne(fetch = FetchType.LAZY)
	private PaymentMethod paymentMethod;

	/**
	 * 配送方式
	 */
	@ManyToOne(fetch = FetchType.LAZY)
	private ShippingMethod shippingMethod;

	/**
	 * 会员
	 */
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(nullable = false, updatable = false)
	private Member member;

	/**
	 * 优惠码
	 */
	@OneToOne(fetch = FetchType.LAZY)
	private CouponCode couponCode;

	/**
	 * 店铺
	 */
	@JsonView(BaseView.class)
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(nullable = false)
	private Store store;

	/**
	 * 促销名称
	 */
	@Column(updatable = false, length = 4000)
	@Convert(converter = PromotionNameConverter.class)
	private List<String> promotionNames = new ArrayList<>();

	/**
	 * 赠送优惠券
	 */
	@ManyToMany(fetch = FetchType.LAZY)
	private List<Coupon> coupons = new ArrayList<>();

	/**
	 * 订单项
	 */
	@JsonView(BaseView.class)
	@OneToMany(mappedBy = "order", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
	@OrderBy("type asc")
	private List<OrderItem> orderItems = new ArrayList<>();

	/**
	 * 支付事务
	 */
	@OneToMany(mappedBy = "order", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
	@OrderBy("createdDate asc")
	private Set<PaymentTransaction> paymentTransactions = new HashSet<>();

	/**
	 * 订单支付
	 */
	@OneToMany(mappedBy = "order", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
	@OrderBy("createdDate asc")
	private Set<OrderPayment> orderPayments = new HashSet<>();

	/**
	 * 订单退款
	 */
	@OneToMany(mappedBy = "order", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
	@OrderBy("createdDate asc")
	private Set<OrderRefunds> orderRefunds = new HashSet<>();

	/**
	 * 订单发货
	 */
	@OneToMany(mappedBy = "order", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
	@OrderBy("createdDate asc")
	private Set<OrderShipping> orderShippings = new HashSet<>();

	/**
	 * 订单退货
	 */
	@OneToMany(mappedBy = "order", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
	@OrderBy("createdDate asc")
	private Set<OrderReturns> orderReturns = new HashSet<>();

	/**
	 * 订单记录
	 */
	@OneToMany(mappedBy = "order", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
	@OrderBy("createdDate asc")
	private Set<OrderLog> orderLogs = new HashSet<>();

	/**
	 * 获取编号
	 * 
	 * @return 编号
	 */
	public String getSn() {
		return sn;
	}

	/**
	 * 设置编号
	 * 
	 * @param sn
	 *            编号
	 */
	public void setSn(String sn) {
		this.sn = sn;
	}

	/**
	 * 获取类型
	 * 
	 * @return 类型
	 */
	public Order.Type getType() {
		return type;
	}

	/**
	 * 设置类型
	 * 
	 * @param type
	 *            类型
	 */
	public void setType(Order.Type type) {
		this.type = type;
	}

	/**
	 * 获取状态
	 * 
	 * @return 状态
	 */
	public Order.Status getStatus() {
		return status;
	}

	/**
	 * 设置状态
	 * 
	 * @param status
	 *            状态
	 */
	public void setStatus(Order.Status status) {
		this.status = status;
	}

	/**
	 * 获取价格
	 * 
	 * @return 价格
	 */
	public BigDecimal getPrice() {
		return price;
	}

	/**
	 * 设置价格
	 * 
	 * @param price
	 *            价格
	 */
	public void setPrice(BigDecimal price) {
		this.price = price;
	}

	/**
	 * 获取支付手续费
	 * 
	 * @return 支付手续费
	 */
	public BigDecimal getFee() {
		return fee;
	}

	/**
	 * 设置支付手续费
	 * 
	 * @param fee
	 *            支付手续费
	 */
	public void setFee(BigDecimal fee) {
		this.fee = fee;
	}

	/**
	 * 获取运费
	 * 
	 * @return 运费
	 */
	public BigDecimal getFreight() {
		return freight;
	}

	/**
	 * 设置运费
	 * 
	 * @param freight
	 *            运费
	 */
	public void setFreight(BigDecimal freight) {
		this.freight = freight;
	}

	/**
	 * 获取税金
	 * 
	 * @return 税金
	 */
	public BigDecimal getTax() {
		return tax;
	}

	/**
	 * 设置税金
	 * 
	 * @param tax
	 *            税金
	 */
	public void setTax(BigDecimal tax) {
		this.tax = tax;
	}

	/**
	 * 获取促销折扣
	 * 
	 * @return 促销折扣
	 */
	public BigDecimal getPromotionDiscount() {
		return promotionDiscount;
	}

	/**
	 * 设置促销折扣
	 * 
	 * @param promotionDiscount
	 *            促销折扣
	 */
	public void setPromotionDiscount(BigDecimal promotionDiscount) {
		this.promotionDiscount = promotionDiscount;
	}

	/**
	 * 获取优惠券折扣
	 * 
	 * @return 优惠券折扣
	 */
	public BigDecimal getCouponDiscount() {
		return couponDiscount;
	}

	/**
	 * 设置优惠券折扣
	 * 
	 * @param couponDiscount
	 *            优惠券折扣
	 */
	public void setCouponDiscount(BigDecimal couponDiscount) {
		this.couponDiscount = couponDiscount;
	}

	/**
	 * 获取调整金额
	 * 
	 * @return 调整金额
	 */
	public BigDecimal getOffsetAmount() {
		return offsetAmount;
	}

	/**
	 * 设置调整金额
	 * 
	 * @param offsetAmount
	 *            调整金额
	 */
	public void setOffsetAmount(BigDecimal offsetAmount) {
		this.offsetAmount = offsetAmount;
	}

	/**
	 * 获取订单金额
	 * 
	 * @return 订单金额
	 */
	public BigDecimal getAmount() {
		return amount;
	}

	/**
	 * 设置订单金额
	 * 
	 * @param amount
	 *            订单金额
	 */
	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}

	/**
	 * 获取已付金额
	 * 
	 * @return 已付金额
	 */
	public BigDecimal getAmountPaid() {
		return amountPaid;
	}

	/**
	 * 设置已付金额
	 * 
	 * @param amountPaid
	 *            已付金额
	 */
	public void setAmountPaid(BigDecimal amountPaid) {
		this.amountPaid = amountPaid;
	}

	/**
	 * 获取退款金额
	 * 
	 * @return 退款金额
	 */
	public BigDecimal getRefundAmount() {
		return refundAmount;
	}

	/**
	 * 设置退款金额
	 * 
	 * @param refundAmount
	 *            退款金额
	 */
	public void setRefundAmount(BigDecimal refundAmount) {
		this.refundAmount = refundAmount;
	}

	/**
	 * 获取赠送积分
	 * 
	 * @return 赠送积分
	 */
	public Long getRewardPoint() {
		return rewardPoint;
	}

	/**
	 * 设置赠送积分
	 * 
	 * @param rewardPoint
	 *            赠送积分
	 */
	public void setRewardPoint(Long rewardPoint) {
		this.rewardPoint = rewardPoint;
	}

	/**
	 * 获取兑换积分
	 * 
	 * @return 兑换积分
	 */
	public Long getExchangePoint() {
		return exchangePoint;
	}

	/**
	 * 设置兑换积分
	 * 
	 * @param exchangePoint
	 *            兑换积分
	 */
	public void setExchangePoint(Long exchangePoint) {
		this.exchangePoint = exchangePoint;
	}

	/**
	 * 获取重量
	 * 
	 * @return 重量
	 */
	public Integer getWeight() {
		return weight;
	}

	/**
	 * 设置重量
	 * 
	 * @param weight
	 *            重量
	 */
	public void setWeight(Integer weight) {
		this.weight = weight;
	}

	/**
	 * 获取数量
	 * 
	 * @return 数量
	 */
	public Integer getQuantity() {
		return quantity;
	}

	/**
	 * 设置数量
	 * 
	 * @param quantity
	 *            数量
	 */
	public void setQuantity(Integer quantity) {
		this.quantity = quantity;
	}

	/**
	 * 获取已发货数量
	 * 
	 * @return 已发货数量
	 */
	public Integer getShippedQuantity() {
		return shippedQuantity;
	}

	/**
	 * 设置已发货数量
	 * 
	 * @param shippedQuantity
	 *            已发货数量
	 */
	public void setShippedQuantity(Integer shippedQuantity) {
		this.shippedQuantity = shippedQuantity;
	}

	/**
	 * 获取已退货数量
	 * 
	 * @return 已退货数量
	 */
	public Integer getReturnedQuantity() {
		return returnedQuantity;
	}

	/**
	 * 设置已退货数量
	 * 
	 * @param returnedQuantity
	 *            已退货数量
	 */
	public void setReturnedQuantity(Integer returnedQuantity) {
		this.returnedQuantity = returnedQuantity;
	}

	/**
	 * 获取收货人
	 * 
	 * @return 收货人
	 */
	public String getConsignee() {
		return consignee;
	}

	/**
	 * 设置收货人
	 * 
	 * @param consignee
	 *            收货人
	 */
	public void setConsignee(String consignee) {
		this.consignee = consignee;
	}

	/**
	 * 获取地区名称
	 * 
	 * @return 地区名称
	 */
	public String getAreaName() {
		return areaName;
	}

	/**
	 * 设置地区名称
	 * 
	 * @param areaName
	 *            地区名称
	 */
	public void setAreaName(String areaName) {
		this.areaName = areaName;
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
	 * 获取附言
	 * 
	 * @return 附言
	 */
	public String getMemo() {
		return memo;
	}

	/**
	 * 设置附言
	 * 
	 * @param memo
	 *            附言
	 */
	public void setMemo(String memo) {
		this.memo = memo;
	}

	/**
	 * 获取过期时间
	 * 
	 * @return 过期时间
	 */
	public Date getExpire() {
		return expire;
	}

	/**
	 * 设置过期时间
	 * 
	 * @param expire
	 *            过期时间
	 */
	public void setExpire(Date expire) {
		this.expire = expire;
	}

	/**
	 * 获取是否已使用优惠码
	 * 
	 * @return 是否已使用优惠码
	 */
	public Boolean getIsUseCouponCode() {
		return isUseCouponCode;
	}

	/**
	 * 设置是否已使用优惠码
	 * 
	 * @param isUseCouponCode
	 *            是否已使用优惠码
	 */
	public void setIsUseCouponCode(Boolean isUseCouponCode) {
		this.isUseCouponCode = isUseCouponCode;
	}

	/**
	 * 获取是否已兑换积分
	 * 
	 * @return 是否已兑换积分
	 */
	public Boolean getIsExchangePoint() {
		return isExchangePoint;
	}

	/**
	 * 设置是否已兑换积分
	 * 
	 * @param isExchangePoint
	 *            是否已兑换积分
	 */
	public void setIsExchangePoint(Boolean isExchangePoint) {
		this.isExchangePoint = isExchangePoint;
	}

	/**
	 * 获取是否已分配库存
	 * 
	 * @return 是否已分配库存
	 */
	public Boolean getIsAllocatedStock() {
		return isAllocatedStock;
	}

	/**
	 * 设置是否已分配库存
	 * 
	 * @param isAllocatedStock
	 *            是否已分配库存
	 */
	public void setIsAllocatedStock(Boolean isAllocatedStock) {
		this.isAllocatedStock = isAllocatedStock;
	}

	/**
	 * 获取支付方式名称
	 * 
	 * @return 支付方式名称
	 */
	public String getPaymentMethodName() {
		return paymentMethodName;
	}

	/**
	 * 设置支付方式名称
	 * 
	 * @param paymentMethodName
	 *            支付方式名称
	 */
	public void setPaymentMethodName(String paymentMethodName) {
		this.paymentMethodName = paymentMethodName;
	}

	/**
	 * 获取支付方式类型
	 * 
	 * @return 支付方式类型
	 */
	public PaymentMethod.Type getPaymentMethodType() {
		return paymentMethodType;
	}

	/**
	 * 设置支付方式类型
	 * 
	 * @param paymentMethodType
	 *            支付方式类型
	 */
	public void setPaymentMethodType(PaymentMethod.Type paymentMethodType) {
		this.paymentMethodType = paymentMethodType;
	}

	/**
	 * 获取配送方式名称
	 * 
	 * @return 配送方式名称
	 */
	public String getShippingMethodName() {
		return shippingMethodName;
	}

	/**
	 * 设置配送方式名称
	 * 
	 * @param shippingMethodName
	 *            配送方式名称
	 */
	public void setShippingMethodName(String shippingMethodName) {
		this.shippingMethodName = shippingMethodName;
	}

	/**
	 * 获取完成日期
	 * 
	 * @return 完成日期
	 */
	public Date getCompleteDate() {
		return completeDate;
	}

	/**
	 * 设置完成日期
	 * 
	 * @param completeDate
	 *            完成日期
	 */
	public void setCompleteDate(Date completeDate) {
		this.completeDate = completeDate;
	}

	/**
	 * 获取发票
	 * 
	 * @return 发票
	 */
	public Invoice getInvoice() {
		return invoice;
	}

	/**
	 * 设置发票
	 * 
	 * @param invoice
	 *            发票
	 */
	public void setInvoice(Invoice invoice) {
		this.invoice = invoice;
	}

	/**
	 * 获取地区
	 * 
	 * @return 地区
	 */
	public Area getArea() {
		return area;
	}

	/**
	 * 设置地区
	 * 
	 * @param area
	 *            地区
	 */
	public void setArea(Area area) {
		this.area = area;
	}

	/**
	 * 获取支付方式
	 * 
	 * @return 支付方式
	 */
	public PaymentMethod getPaymentMethod() {
		return paymentMethod;
	}

	/**
	 * 设置支付方式
	 * 
	 * @param paymentMethod
	 *            支付方式
	 */
	public void setPaymentMethod(PaymentMethod paymentMethod) {
		this.paymentMethod = paymentMethod;
	}

	/**
	 * 获取配送方式
	 * 
	 * @return 配送方式
	 */
	public ShippingMethod getShippingMethod() {
		return shippingMethod;
	}

	/**
	 * 设置配送方式
	 * 
	 * @param shippingMethod
	 *            配送方式
	 */
	public void setShippingMethod(ShippingMethod shippingMethod) {
		this.shippingMethod = shippingMethod;
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
	 * 获取优惠码
	 * 
	 * @return 优惠码
	 */
	public CouponCode getCouponCode() {
		return couponCode;
	}

	/**
	 * 设置优惠码
	 * 
	 * @param couponCode
	 *            优惠码
	 */
	public void setCouponCode(CouponCode couponCode) {
		this.couponCode = couponCode;
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
	 * 获取促销名称
	 * 
	 * @return 促销名称
	 */
	public List<String> getPromotionNames() {
		return promotionNames;
	}

	/**
	 * 设置促销名称
	 * 
	 * @param promotionNames
	 *            促销名称
	 */
	public void setPromotionNames(List<String> promotionNames) {
		this.promotionNames = promotionNames;
	}

	/**
	 * 获取赠送优惠券
	 * 
	 * @return 赠送优惠券
	 */
	public List<Coupon> getCoupons() {
		return coupons;
	}

	/**
	 * 设置赠送优惠券
	 * 
	 * @param coupons
	 *            赠送优惠券
	 */
	public void setCoupons(List<Coupon> coupons) {
		this.coupons = coupons;
	}

	/**
	 * 获取订单项
	 * 
	 * @return 订单项
	 */
	public List<OrderItem> getOrderItems() {
		return orderItems;
	}

	/**
	 * 设置订单项
	 * 
	 * @param orderItems
	 *            订单项
	 */
	public void setOrderItems(List<OrderItem> orderItems) {
		this.orderItems = orderItems;
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
	 * 获取订单支付
	 * 
	 * @return 订单支付
	 */
	public Set<OrderPayment> getOrderPayments() {
		return orderPayments;
	}

	/**
	 * 设置订单支付
	 * 
	 * @param orderPayments
	 *            订单支付
	 */
	public void setOrderPayments(Set<OrderPayment> orderPayments) {
		this.orderPayments = orderPayments;
	}

	/**
	 * 获取订单退款
	 * 
	 * @return 订单退款
	 */
	public Set<OrderRefunds> getOrderRefunds() {
		return orderRefunds;
	}

	/**
	 * 设置订单退款
	 * 
	 * @param orderRefunds
	 *            订单退款
	 */
	public void setOrderRefunds(Set<OrderRefunds> orderRefunds) {
		this.orderRefunds = orderRefunds;
	}

	/**
	 * 获取订单发货
	 * 
	 * @return 订单发货
	 */
	public Set<OrderShipping> getOrderShippings() {
		return orderShippings;
	}

	/**
	 * 设置订单发货
	 * 
	 * @param orderShippings
	 *            订单发货
	 */
	public void setOrderShippings(Set<OrderShipping> orderShippings) {
		this.orderShippings = orderShippings;
	}

	/**
	 * 获取订单退货
	 * 
	 * @return 订单退货
	 */
	public Set<OrderReturns> getOrderReturns() {
		return orderReturns;
	}

	/**
	 * 设置订单退货
	 * 
	 * @param orderReturns
	 *            订单退货
	 */
	public void setOrderReturns(Set<OrderReturns> orderReturns) {
		this.orderReturns = orderReturns;
	}

	/**
	 * 获取订单记录
	 * 
	 * @return 订单记录
	 */
	public Set<OrderLog> getOrderLogs() {
		return orderLogs;
	}

	/**
	 * 设置订单记录
	 * 
	 * @param orderLogs
	 *            订单记录
	 */
	public void setOrderLogs(Set<OrderLog> orderLogs) {
		this.orderLogs = orderLogs;
	}

	/**
	 * 获取是否需要物流
	 * 
	 * @return 是否需要物流
	 */
	@Transient
	public boolean getIsDelivery() {
		return CollectionUtils.exists(getOrderItems(), new Predicate() {
			@Override
			public boolean evaluate(Object object) {
				OrderItem orderItem = (OrderItem) object;
				return orderItem != null && BooleanUtils.isTrue(orderItem.getIsDelivery());
			}
		});
	}

	/**
	 * 获取应付金额
	 * 
	 * @return 应付金额
	 */
	@Transient
	public BigDecimal getAmountPayable() {
		if (!hasExpired() && !Order.Status.completed.equals(getStatus()) && !Order.Status.failed.equals(getStatus()) && !Order.Status.canceled.equals(getStatus()) && !Order.Status.denied.equals(getStatus())) {
			BigDecimal amountPayable = getAmount().subtract(getAmountPaid());
			return amountPayable.compareTo(BigDecimal.ZERO) >= 0 ? amountPayable : BigDecimal.ZERO;
		}
		return BigDecimal.ZERO;
	}

	/**
	 * 获取应收金额
	 * 
	 * @return 应收金额
	 */
	@Transient
	public BigDecimal getAmountReceivable() {
		if (!hasExpired() && PaymentMethod.Type.cashOnDelivery.equals(getPaymentMethodType()) && !Order.Status.completed.equals(getStatus()) && !Order.Status.failed.equals(getStatus()) && !Order.Status.canceled.equals(getStatus()) && !Order.Status.denied.equals(getStatus())) {
			BigDecimal amountReceivable = getAmount().subtract(getAmountPaid());
			return amountReceivable.compareTo(BigDecimal.ZERO) >= 0 ? amountReceivable : BigDecimal.ZERO;
		}
		return BigDecimal.ZERO;
	}

	/**
	 * 获取应退金额
	 * 
	 * @return 应退金额
	 */
	@Transient
	public BigDecimal getRefundableAmount() {
		if (hasExpired() || Order.Status.failed.equals(getStatus()) || Order.Status.canceled.equals(getStatus()) || Order.Status.denied.equals(getStatus())) {
			BigDecimal refundableAmount = getAmountPaid();
			return refundableAmount.compareTo(BigDecimal.ZERO) >= 0 ? refundableAmount : BigDecimal.ZERO;
		}
		if (Order.Status.completed.equals(getStatus())) {
			BigDecimal refundableAmount = getAmountPaid().subtract(getAmount());
			return refundableAmount.compareTo(BigDecimal.ZERO) >= 0 ? refundableAmount : BigDecimal.ZERO;
		}
		return BigDecimal.ZERO;
	}
	@Transient
	public BigDecimal getRefundable() {
		BigDecimal payAmount = getAmountPaid().subtract(getOffsetAmount()).subtract(getFee()).subtract(getTax());
		return payAmount.compareTo(BigDecimal.ZERO) >= 0 ? payAmount : BigDecimal.ZERO;
	}
	/**
	 * 判断当前金额是否可退
	 *
	 * @return 是否可退
	 */
	@Transient
	public boolean isAbleRefundableAmount(BigDecimal amount) {
		BigDecimal payAmount = getAmountPaid().subtract(getOffsetAmount()).subtract(getFee()).subtract(getTax());
		return payAmount.subtract(amount).compareTo(BigDecimal.ZERO) >= 0;
	}
	/**
	 * 返回是否需要退款
	 */
	@Transient
	public boolean isNeedRefund(){
		BigDecimal payAmount = getAmountPaid().subtract(getOffsetAmount()).subtract(getFee()).subtract(getTax());
		return payAmount.compareTo(BigDecimal.ZERO) >= 0;
	}

	/**
	 * 获取佣金
	 * 
	 * @return 佣金
	 */
	@Transient
	public BigDecimal getCommission() {
		BigDecimal commission = BigDecimal.ZERO;
		if (getOrderItems() != null) {
			for (OrderItem orderItem : getOrderItems()) {
				if (orderItem != null && orderItem.getCommissionTotals().compareTo(BigDecimal.ZERO) > 0) {
					commission = commission.add(orderItem.getCommissionTotals());
				}
			}
		}
		return commission;
	}

	/**
	 * 获取结算金额
	 * 
	 * @return 结算金额
	 */
	@Transient
	public BigDecimal getSettlementAmount() {
		return getCommission() != null && getCommission().compareTo(BigDecimal.ZERO) > 0 ? getAmount().subtract(getCommission()) : getAmount();
	}

	/**
	 * 获取可发货数
	 * 
	 * @return 可发货数
	 */
	@Transient
	public int getShippableQuantity() {
		if (!hasExpired() && Order.Status.pendingShipment.equals(getStatus())) {
			int shippableQuantity = getQuantity()getShippedQuantity();
			return shippableQuantity >= 0 ? shippableQuantity : 0;
		}
		return 0;
	}

	/**
	 * 获取可退货数
	 * 
	 * @return 可退货数
	 */
	@Transient
	public int getReturnableQuantity() {
		if (!hasExpired() && Order.Status.failed.equals(getStatus())) {
			int returnableQuantity = getShippedQuantity()getReturnedQuantity();
			return returnableQuantity >= 0 ? returnableQuantity : 0;
		}
		return 0;
	}

	/**
	 * 判断是否已过期
	 * 
	 * @return 是否已过期
	 */
	@JsonView(BaseView.class)
	@Transient
	public boolean hasExpired() {
		return getExpire() != null && !getExpire().after(new Date());
	}

	/**
	 * 获取订单项
	 * 
	 * @param sn
	 *            SKU编号
	 * @return 订单项
	 */
	@Transient
	public OrderItem getOrderItem(String sn) {
		if (StringUtils.isEmpty(sn) || CollectionUtils.isEmpty(getOrderItems())) {
			return null;
		}
		for (OrderItem orderItem : getOrderItems()) {
			if (orderItem != null && StringUtils.equalsIgnoreCase(orderItem.getSn(), sn)) {
				return orderItem;
			}
		}
		return null;
	}

	/**
	 * 判断订单是否允许刪除
	 * 
	 * @return 订单是否允许刪除
	 */
	@Transient
	public boolean canDelete() {
		return Order.Status.canceled.equals(getStatus()) || Order.Status.failed.equals(getStatus()) || Order.Status.denied.equals(getStatus());
	}

	/**
	 * 持久化前处理
	 */
	@PrePersist
	public void prePersist() {
		setSn(StringUtils.lowerCase(getSn()));
		if (getArea() != null) {
			setAreaName(getArea().getFullName());
		}
		if (getPaymentMethod() != null) {
			setPaymentMethodName(getPaymentMethod().getName());
			setPaymentMethodType(getPaymentMethod().getType());
		}
		if (getShippingMethod() != null) {
			setShippingMethodName(getShippingMethod().getName());
		}
	}

	/**
	 * 更新前处理
	 */
	@PreUpdate
	public void preUpdate() {
		if (getArea() != null) {
			setAreaName(getArea().getFullName());
		}
		if (getPaymentMethod() != null) {
			setPaymentMethodName(getPaymentMethod().getName());
			setPaymentMethodType(getPaymentMethod().getType());
		}
		if (getShippingMethod() != null) {
			setShippingMethodName(getShippingMethod().getName());
		}
	}

	/**
	 * 类型转换促销名称
	 * 
	 * @author SHOP++ Team
	 * @version 5.0
	 */
	@Converter
	public static class PromotionNameConverter extends BaseAttributeConverter<List<String>> {
	}

	/**
	 * 判断是否退过款
	 * @return
	 */
	public boolean isAlreadyRefund() {
		if (orderPayments.size() > 0) {
			if (orderPayments.iterator().next().getStatus() == OrderPayment.Status.payed) {
				return false;
			}
		}
		return true;
	}
}