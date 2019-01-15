/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.entity;

import java.util.Map;

import javax.persistence.Column;
import javax.persistence.Convert;
import javax.persistence.Converter;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.ManyToOne;

import net.shopxx.BaseAttributeConverter;

/**
 * Entity审计日志
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Entity
public class AuditLog extends BaseEntity<Long> {

	private static final long serialVersionUID = -4494144902110236826L;

	/**
	 * "审计日志"属性名称
	 */
	public static final String AUDIT_LOG_ATTRIBUTE_NAME = AuditLog.class.getName() + ".AUDIT_LOG";

	/**
	 * 动作
	 */
	@Column(nullable = false, updatable = false)
	private String action;

	/**
	 * 详情
	 */
	@Column(updatable = false)
	private String detail;

	/**
	 * IP
	 */
	@Column(nullable = false, updatable = false)
	private String ip;

	/**
	 * 请求URL
	 */
	@Column(nullable = false, updatable = false)
	private String requestUrl;

	/**
	 * 请求参数
	 */
	@Column(updatable = false, length = 4000)
	@Convert(converter = ParameterConverter.class)
	private Map<String, String[]> parameters;

	/**
	 * 用户
	 */
	@ManyToOne(fetch = FetchType.LAZY)
	private User user;

	/**
	 * 获取动作
	 * 
	 * @return 动作
	 */
	public String getAction() {
		return action;
	}

	/**
	 * 设置动作
	 * 
	 * @param action
	 *            动作
	 */
	public void setAction(String action) {
		this.action = action;
	}

	/**
	 * 获取详情
	 * 
	 * @return 详情
	 */
	public String getDetail() {
		return detail;
	}

	/**
	 * 设置详情
	 * 
	 * @param detail
	 *            详情
	 */
	public void setDetail(String detail) {
		this.detail = detail;
	}

	/**
	 * 获取IP
	 * 
	 * @return IP
	 */
	public String getIp() {
		return ip;
	}

	/**
	 * 设置IP
	 * 
	 * @param ip
	 *            IP
	 */
	public void setIp(String ip) {
		this.ip = ip;
	}

	/**
	 * 获取请求URL
	 * 
	 * @return 请求URL
	 */
	public String getRequestUrl() {
		return requestUrl;
	}

	/**
	 * 设置请求URL
	 * 
	 * @param requestUrl
	 *            请求URL
	 */
	public void setRequestUrl(String requestUrl) {
		this.requestUrl = requestUrl;
	}

	/**
	 * 获取请求参数
	 * 
	 * @return 请求参数
	 */
	public Map<String, String[]> getParameters() {
		return parameters;
	}

	/**
	 * 设置请求参数
	 * 
	 * @param parameters
	 *            请求参数
	 */
	public void setParameters(Map<String, String[]> parameters) {
		this.parameters = parameters;
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

	/**
	 * 类型转换请求参数
	 * 
	 * @author SHOP++ Team
	 * @version 5.0
	 */
	@Converter
	public static class ParameterConverter extends BaseAttributeConverter<Map<String, String[]>> {
	}

}