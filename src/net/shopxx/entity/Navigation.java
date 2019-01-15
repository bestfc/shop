/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;

import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;

/**
 * Entity导航
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Entity
public class Navigation extends OrderedEntity<Long> {

	private static final long serialVersionUID = -7635757647887646795L;

	/**
	 * 位置
	 */
	public enum Position {

		/**
		 * 顶部
		 */
		top,

		/**
		 * 中间
		 */
		middle,

		/**
		 * 底部
		 */
		bottom
	}

	/**
	 * 名称
	 */
	@NotEmpty
	@Length(max = 200)
	@Column(nullable = false)
	private String name;

	/**
	 * 位置
	 */
	@NotNull
	@Column(nullable = false)
	private Navigation.Position position;

	/**
	 * 链接地址
	 */
	@NotEmpty
	@Length(max = 200)
	@Pattern(regexp = "^(?i)(http:\\/\\/|https:\\/\\/|ftp:\\/\\/|mailto:|\\/|#).*$")
	@Column(nullable = false)
	private String url;

	/**
	 * 是否新窗口打开
	 */
	@NotNull
	@Column(nullable = false)
	private Boolean isBlankTarget;

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
	 * 获取位置
	 * 
	 * @return 位置
	 */
	public Navigation.Position getPosition() {
		return position;
	}

	/**
	 * 设置位置
	 * 
	 * @param position
	 *            位置
	 */
	public void setPosition(Navigation.Position position) {
		this.position = position;
	}

	/**
	 * 获取链接地址
	 * 
	 * @return 链接地址
	 */
	public String getUrl() {
		return url;
	}

	/**
	 * 设置链接地址
	 * 
	 * @param url
	 *            链接地址
	 */
	public void setUrl(String url) {
		this.url = url;
	}

	/**
	 * 获取是否新窗口打开
	 * 
	 * @return 是否新窗口打开
	 */
	public Boolean getIsBlankTarget() {
		return isBlankTarget;
	}

	/**
	 * 设置是否新窗口打开
	 * 
	 * @param isBlankTarget
	 *            是否新窗口打开
	 */
	public void setIsBlankTarget(Boolean isBlankTarget) {
		this.isBlankTarget = isBlankTarget;
	}

}