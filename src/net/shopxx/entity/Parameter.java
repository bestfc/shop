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
import javax.validation.constraints.NotNull;

import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;

import net.shopxx.BaseAttributeConverter;

/**
 * Entity参数
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Entity
public class Parameter extends OrderedEntity<Long> {

	private static final long serialVersionUID = -6159626519016913987L;

	/**
	 * 参数组
	 */
	@NotEmpty
	@Length(max = 200)
	@Column(name = "parameterGroup", nullable = false)
	private String group;

	/**
	 * 绑定分类
	 */
	@NotNull(groups = Save.class)
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(nullable = false, updatable = false)
	private ProductCategory productCategory;

	/**
	 * 参数名称
	 */
	@NotEmpty
	@Column(nullable = false, length = 4000)
	@Convert(converter = NameConverter.class)
	private List<String> names = new ArrayList<>();

	/**
	 * 获取参数组
	 * 
	 * @return 参数组
	 */
	public String getGroup() {
		return group;
	}

	/**
	 * 设置参数组
	 * 
	 * @param group
	 *            参数组
	 */
	public void setGroup(String group) {
		this.group = group;
	}

	/**
	 * 获取绑定分类
	 * 
	 * @return 绑定分类
	 */
	public ProductCategory getProductCategory() {
		return productCategory;
	}

	/**
	 * 设置绑定分类
	 * 
	 * @param productCategory
	 *            绑定分类
	 */
	public void setProductCategory(ProductCategory productCategory) {
		this.productCategory = productCategory;
	}

	/**
	 * 获取参数名称
	 * 
	 * @return 参数名称
	 */
	public List<String> getNames() {
		return names;
	}

	/**
	 * 设置参数名称
	 * 
	 * @param names
	 *            参数名称
	 */
	public void setNames(List<String> names) {
		this.names = names;
	}

	/**
	 * 类型转换参数名称
	 * 
	 * @author SHOP++ Team
	 * @version 5.0
	 */
	@Converter
	public static class NameConverter extends BaseAttributeConverter<List<String>> {
	}

}