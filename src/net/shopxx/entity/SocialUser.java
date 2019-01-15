/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.UniqueConstraint;

/**
 * Entity社会化用户
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Entity
@Table(uniqueConstraints = @UniqueConstraint(columnNames = { "loginPluginId", "uniqueId" }))
public class SocialUser extends BaseEntity<Long> {

	private static final long serialVersionUID = 3962190474369671955L;

	/**
	 * 登录插件ID
	 */
	@Column(nullable = false, updatable = false)
	private String loginPluginId;

	/**
	 * 唯一ID
	 */
	@Column(nullable = false, updatable = false)
	private String uniqueId;

	/**
	 * 用户
	 */
	@ManyToOne(fetch = FetchType.EAGER)
	private User user;

	/**
	 * 获取登录插件ID
	 * 
	 * @return 登录插件ID
	 */

	public String getLoginPluginId() {
		return loginPluginId;
	}

	/**
	 * 设置登录插件ID
	 * 
	 * @param loginPluginId
	 *            登录插件ID
	 */
	public void setLoginPluginId(String loginPluginId) {
		this.loginPluginId = loginPluginId;
	}

	/**
	 * 获取唯一ID
	 * 
	 * @return 唯一ID
	 */
	public String getUniqueId() {
		return uniqueId;
	}

	/**
	 * 设置唯一ID
	 * 
	 * @param uniqueId
	 *            唯一ID
	 */
	public void setUniqueId(String uniqueId) {
		this.uniqueId = uniqueId;
	}

	/**
	 * 获取用户
	 * 
	 * @return 用户
	 */
	public User getUser() {
		return user;
	}

	/**
	 * 设置用户
	 * 
	 * @param user
	 *            用户
	 */
	public void setUser(User user) {
		this.user = user;
	}

}