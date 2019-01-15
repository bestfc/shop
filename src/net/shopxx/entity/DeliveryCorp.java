/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.entity;

import java.util.HashSet;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.OneToMany;
import javax.persistence.PreRemove;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;

import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;

/**
 * Entity物流公司
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Entity
public class DeliveryCorp extends OrderedEntity<Long> {

	private static final long serialVersionUID = 10595703086045998L;

	/**
	 * 名称
	 */
	@NotEmpty
	@Length(max = 200)
	@Column(nullable = false)
	private String name;

	/**
	 * 网址
	 */
	@Length(max = 200)
	@Pattern(regexp = "^(?i)(http:\\/\\/|https:\\/\\/|ftp:\\/\\/|mailto:|\\/|#).*$")
	private String url;

	/**
	 * 代码
	 */
	@Length(max = 200)
	private String code;

	/**
	 * 配送方式
	 */
	@OneToMany(mappedBy = "defaultDeliveryCorp", fetch = FetchType.LAZY)
	private Set<ShippingMethod> shippingMethods = new HashSet<>();

	/**
	 * is use
	 * @return
	 */
	@NotNull
	@Column(nullable = false)
	Boolean bUse;

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
	 * 获取网址
	 * 
	 * @return 网址
	 */
	public String getUrl() {
		return url;
	}

	/**
	 * 设置网址
	 * 
	 * @param url
	 *            网址
	 */
	public void setUrl(String url) {
		this.url = url;
	}

	/**
	 * 获取代码
	 * 
	 * @return 代码
	 */
	public String getCode() {
		return code;
	}

	/**
	 * 设置代码
	 * 
	 * @param code
	 *            代码
	 */
	public void setCode(String code) {
		this.code = code;
	}

	/**
	 * 获取配送方式
	 * 
	 * @return 配送方式
	 */
	public Set<ShippingMethod> getShippingMethods() {
		return shippingMethods;
	}

	/**
	 * 设置配送方式
	 * 
	 * @param shippingMethods
	 *            配送方式
	 */
	public void setShippingMethods(Set<ShippingMethod> shippingMethods) {
		this.shippingMethods = shippingMethods;
	}

	public Boolean getbUse() {
		return bUse;
	}

	public void setbUse(Boolean bUse) {
		this.bUse = bUse;
	}

	/**
	 * 删除前处理
	 */
	@PreRemove
	public void preRemove() {
		Set<ShippingMethod> shippingMethods = getShippingMethods();
		if (shippingMethods != null) {
			for (ShippingMethod shippingMethod : shippingMethods) {
				shippingMethod.setDefaultDeliveryCorp(null);
			}
		}
	}

}