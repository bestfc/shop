/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.entity;

import java.math.BigDecimal;
import java.util.*;

import javax.persistence.*;

import com.fasterxml.jackson.annotation.JsonView;

import net.shopxx.BaseAttributeConverter;

/**
 * Entity订单项
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Entity
public class OrderItem extends BaseEntity<Long> {

	private static final long serialVersionUID = -4999926022604479334L;

	/**
	 * 编号
	 */
	@Column(nullable = false, updatable = false)
	private String sn;

	/**
	 * 名称
	 */
	@JsonView(BaseView.class)
	@Column(nullable = false, updatable = false)
	private String name;

	/**
	 * 类型
	 */
	@JsonView(BaseView.class)
	@Column(nullable = false, updatable = false)
	private Product.Type type;

	/**
	 * 价格
	 */
	@Column(nullable = false, updatable = false, precision = 21, scale = 6)
	private BigDecimal price;

	/**
	 * 重量
	 */
	@Column(updatable = false)
	private Integer weight;

	/**
	 * 是否需要物流
	 */
	@Column(nullable = false, updatable = false)
	private Boolean isDelivery;

	/**
	 * 缩略图
	 */
	@JsonView(BaseView.class)
	@Column(updatable = false)
	private String thumbnail;

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
	 * 佣金小计
	 */
	@Column(nullable = false, precision = 21, scale = 6)
	private BigDecimal commissionTotals;

	/**
	 * SKU
	 */
	@ManyToOne(fetch = FetchType.LAZY)
	private Sku sku;

	/**
	 * 订单
	 */
	@ManyToOne()
	@JoinColumn(name = "orders", nullable = false, updatable = false)
	private Order order;

	/**
	 * 规格
	 */
	@JsonView(BaseView.class)
	@Column(updatable = false, length = 4000)
	@Convert(converter = SpecificationConverter.class)
	private List<String> specifications = new ArrayList<>();

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
	public Product.Type getType() {
		return type;
	}

	/**
	 * 设置类型
	 * 
	 * @param type
	 *            类型
	 */
	public void setType(Product.Type type) {
		this.type = type;
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
	 * 获取是否需要物流
	 * 
	 * @return 是否需要物流
	 */
	public Boolean getIsDelivery() {
		return isDelivery;
	}

	/**
	 * 设置是否需要物流
	 * 
	 * @param isDelivery
	 *            是否需要物流
	 */
	public void setIsDelivery(Boolean isDelivery) {
		this.isDelivery = isDelivery;
	}

	/**
	 * 获取缩略图
	 * 
	 * @return 缩略图
	 */
	public String getThumbnail() {
		return thumbnail;
	}

	/**
	 * 设置缩略图
	 * 
	 * @param thumbnail
	 *            缩略图
	 */
	public void setThumbnail(String thumbnail) {
		this.thumbnail = thumbnail;
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
	 * 获取佣金小计
	 * 
	 * @return 佣金小计
	 */
	public BigDecimal getCommissionTotals() {
		return commissionTotals;
	}

	/**
	 * 设置佣金小计
	 * 
	 * @param commissionTotals
	 *            佣金小计
	 */
	public void setCommissionTotals(BigDecimal commissionTotals) {
		this.commissionTotals = commissionTotals;
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
	 * 获取规格
	 * 
	 * @return 规格
	 */
	public List<String> getSpecifications() {
		return specifications;
	}

	/**
	 * 设置规格
	 * 
	 * @param specifications
	 *            规格
	 */
	public void setSpecifications(List<String> specifications) {
		this.specifications = specifications;
	}

	/**
	 * 获取总重量
	 * 
	 * @return 总重量
	 */
	@Transient
	public int getTotalWeight() {
		if (getWeight() != null && getQuantity() != null) {
			return getWeight() * getQuantity();
		} else {
			return 0;
		}
	}

	/**
	 * 获取小计
	 * 
	 * @return 小计
	 */
	@Transient
	public BigDecimal getSubtotal() {
		if (getPrice() != null && getQuantity() != null) {
			return getPrice().multiply(new BigDecimal(getQuantity()));
		} else {
			return BigDecimal.ZERO;
		}
	}

	/**
	 * 获取可发货数
	 * 
	 * @return 可发货数
	 */
	@Transient
	public int getShippableQuantity() {
		int shippableQuantity = getQuantity()getShippedQuantity();
		return shippableQuantity >= 0 ? shippableQuantity : 0;
	}

	/**
	 * 获取可退货数
	 * 
	 * @return 可退货数
	 */
	@Transient
	public int getReturnableQuantity() {
		int returnableQuantity = getShippedQuantity()getReturnedQuantity();
		return returnableQuantity >= 0 ? returnableQuantity : 0;
	}

    public BigDecimal getRefundable() {
		//订单总付款金额
		BigDecimal orderPayAmount=this.getOrder().getRefundable();
		BigDecimal itemPayAmount=orderPayAmount;
		if(getOrder().getOrderItems().size()>1){
		//计算子订单的金额,按子订单占比计算
		itemPayAmount=(getPrice().multiply(orderPayAmount)
											.divide(order.getPrice(),10,BigDecimal.ROUND_HALF_UP))
											.setScale(2,BigDecimal.ROUND_HALF_UP);
		}
		return itemPayAmount.compareTo(BigDecimal.ZERO) >= 0 ? itemPayAmount : BigDecimal.ZERO;
    }
    public OrderRefunds getOrderRefund(){
		Iterator<OrderRefunds> it=this.getOrder().getOrderRefunds().iterator();
		OrderRefunds orderRefunds=null;
		while (it.hasNext()){
			OrderRefunds temp=it.next();
			if((this.getSn()).equals(temp.getOrderItem().getSn())){
				orderRefunds=temp;
				break;
			}
		}
		return orderRefunds;
	}
    /**
	 * 类型转换规格
	 * 
	 * @author SHOP++ Team
	 * @version 5.0
	 */
	@Converter
	public static class SpecificationConverter extends BaseAttributeConverter<List<String>> {
	}

}