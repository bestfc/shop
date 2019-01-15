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
import javax.validation.constraints.NotNull;

import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;

/**
 * Entity即时通讯
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Entity
public class InstantMessage extends OrderedEntity<Long> {

	private static final long serialVersionUID = 163292786603104144L;

	/**
	 * 类型
	 */
	public enum Type {

		/**
		 * QQ
		 */
		qq,

		/**
		 * 阿里旺旺
		 */
		aliTalk
	}

	/**
	 * 名称
	 */
	@NotEmpty
	@Length(max = 200)
	@Column(nullable = false)
	private String name;

	/**
	 * 类型
	 */
	@NotNull
	@Column(nullable = false)
	private InstantMessage.Type type;

	/**
	 * 账号
	 */
	@NotNull
	@Length(max = 200)
	@Column(nullable = false)
	private String account;

	/**
	 * 店铺
	 */
	@ManyToOne(fetch = FetchType.LAZY)
	private Store store;

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
	public InstantMessage.Type getType() {
		return type;
	}

	/**
	 * 设置类型
	 * 
	 * @param type
	 *            类型
	 */
	public void setType(InstantMessage.Type type) {
		this.type = type;
	}

	/**
	 * 获取账号
	 * 
	 * @return 账号
	 */
	public String getAccount() {
		return account;
	}

	/**
	 * 设置账号
	 * 
	 * @param account
	 *            账号
	 */
	public void setAccount(String account) {
		this.account = account;
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

}