/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.entity;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.hibernate.validator.constraints.Length;

/**
 * Entity发票
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Embeddable
public class Invoice implements Serializable {

	private static final long serialVersionUID = 168692131912350330L;

	/**
	 * 抬头
	 */
	@Length(max = 200)
	@Column(name = "invoiceTitle")
	private String title;

	/**
	 * 内容
	 */
	@Length(max = 200)
	@Column(name = "invoiceContent")
	private String content;

	/**
	 * 构造方法
	 */
	public Invoice() {
	}

	/**
	 * 构造方法
	 * 
	 * @param title
	 *            抬头
	 * @param content
	 *            内容
	 */
	public Invoice(String title, String content) {
		this.title = title;
		this.content = content;
	}

	/**
	 * 获取抬头
	 * 
	 * @return 抬头
	 */
	public String getTitle() {
		return title;
	}

	/**
	 * 设置抬头
	 * 
	 * @param title
	 *            抬头
	 */
	public void setTitle(String title) {
		this.title = title;
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
	 * 重写equals方法
	 * 
	 * @param obj
	 *            对象
	 * @return 是否相等
	 */
	@Override
	public boolean equals(Object obj) {
		return EqualsBuilder.reflectionEquals(this, obj);
	}

	/**
	 * 重写hashCode方法
	 * 
	 * @return HashCode
	 */
	@Override
	public int hashCode() {
		return HashCodeBuilder.reflectionHashCode(this);
	}

}