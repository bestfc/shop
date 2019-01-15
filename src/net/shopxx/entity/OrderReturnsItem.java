/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.entity;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Convert;
import javax.persistence.Converter;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;

import net.shopxx.BaseAttributeConverter;

/**
 * Entity退货项
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Entity
public class OrderReturnsItem extends BaseEntity<Long> {

	private static final long serialVersionUID = -4112374596087084162L;

	/**
	 * 编号
	 */
	@Column(nullable = false, updatable = false)
	private String sn;

	/**
	 * 名称
	 */
	@Column(nullable = false, updatable = false)
	private String name;

	/**
	 * 数量
	 */
	@NotNull
	@Min(1)
	@Column(nullable = false, updatable = false)
	private Integer quantity;

	/**
	 * 订单退货
	 */
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(nullable = false, updatable = false)
	private OrderReturns orderReturns;

	/**
	 * 规格
	 */
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
	 * 获取订单退货
	 * 
	 * @return 订单退货
	 */
	public OrderReturns getOrderReturns() {
		return orderReturns;
	}

	/**
	 * 设置订单退货
	 * 
	 * @param orderReturns
	 *            订单退货
	 */
	public void setOrderReturns(OrderReturns orderReturns) {
		this.orderReturns = orderReturns;
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
	 * 类型转换规格
	 * 
	 * @author SHOP++ Team
	 * @version 5.0
	 */
	@Converter
	public static class SpecificationConverter extends BaseAttributeConverter<List<String>> {
	}

}