/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.entity;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.validation.constraints.NotNull;

/**
 * Entity用户
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Entity
@Table(name = "Users")
@Inheritance(strategy = InheritanceType.JOINED)
public abstract class User extends BaseEntity<Long> {

	private static final long serialVersionUID = 400776999956262L;

	/**
	 * 密码找回类型
	 */
	public enum PasswordType {

		/**
		 * 会员
		 */
		member,

		/**
		 * 商家
		 */
		business
	}

	/**
	 * "登录失败尝试次数"缓存名称
	 */
	public static final String FAILED_LOGIN_ATTEMPTS_CACHE_NAME = "failedLoginAttempts";

	/**
	 * 是否启用
	 */
	@NotNull
	@Column(nullable = false)
	private Boolean isEnabled;

	/**
	 * 是否锁定
	 */
	@Column(nullable = false)
	private Boolean isLocked;

	/**
	 * 锁定日期
	 */
	private Date lockDate;

	/**
	 * 最后登录IP
	 */
	private String lastLoginIp;

	/**
	 * 最后登录日期
	 */
	private Date lastLoginDate;

	/**
	 * 社会化用户
	 */
	@OneToMany(mappedBy = "user", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
	private Set<SocialUser> socialUsers = new HashSet<>();

	/**
	 * 支付事务
	 */
	@OneToMany(mappedBy = "user", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
	private Set<PaymentTransaction> paymentTransactions = new HashSet<>();

	/**
	 * 审计日志
	 */
	@OneToMany(mappedBy = "user", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
	private Set<AuditLog> auditLogs = new HashSet<>();

	/**
	 * 获取是否启用
	 * 
	 * @return 是否启用
	 */
	public Boolean getIsEnabled() {
		return isEnabled;
	}

	/**
	 * 设置是否启用
	 * 
	 * @param isEnabled
	 *            是否启用
	 */
	public void setIsEnabled(Boolean isEnabled) {
		this.isEnabled = isEnabled;
	}

	/**
	 * 获取是否锁定
	 * 
	 * @return 是否锁定
	 */
	public Boolean getIsLocked() {
		return isLocked;
	}

	/**
	 * 设置是否锁定
	 * 
	 * @param isLocked
	 *            是否锁定
	 */
	public void setIsLocked(Boolean isLocked) {
		this.isLocked = isLocked;
	}

	/**
	 * 获取锁定日期
	 * 
	 * @return 锁定日期
	 */
	public Date getLockDate() {
		return lockDate;
	}

	/**
	 * 设置锁定日期
	 * 
	 * @param lockDate
	 *            锁定日期
	 */
	public void setLockDate(Date lockDate) {
		this.lockDate = lockDate;
	}

	/**
	 * 获取最后登录IP
	 * 
	 * @return 最后登录IP
	 */
	public String getLastLoginIp() {
		return lastLoginIp;
	}

	/**
	 * 设置最后登录IP
	 * 
	 * @param lastLoginIp
	 *            最后登录IP
	 */
	public void setLastLoginIp(String lastLoginIp) {
		this.lastLoginIp = lastLoginIp;
	}

	/**
	 * 获取最后登录日期
	 * 
	 * @return 最后登录日期
	 */
	public Date getLastLoginDate() {
		return lastLoginDate;
	}

	/**
	 * 设置最后登录日期
	 * 
	 * @param lastLoginDate
	 *            最后登录日期
	 */
	public void setLastLoginDate(Date lastLoginDate) {
		this.lastLoginDate = lastLoginDate;
	}

	/**
	 * 获取社会化用户
	 * 
	 * @return 社会化用户
	 */
	public Set<SocialUser> getSocialUsers() {
		return socialUsers;
	}

	/**
	 * 设置社会化用户
	 * 
	 * @param socialUsers
	 *            社会化用户
	 */
	public void setSocialUsers(Set<SocialUser> socialUsers) {
		this.socialUsers = socialUsers;
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
	 * 获取审计日志
	 * 
	 * @return 审计日志
	 */
	public Set<AuditLog> getAuditLogs() {
		return auditLogs;
	}

	/**
	 * 设置审计日志
	 * 
	 * @param auditLogs
	 *            审计日志
	 */
	public void setAuditLogs(Set<AuditLog> auditLogs) {
		this.auditLogs = auditLogs;
	}

	/**
	 * 获取显示名称
	 * 
	 * @return 显示名称
	 */
	@Transient
	public abstract String getDisplayName();

	/**
	 * 获取身份
	 * 
	 * @return 身份
	 */
	@Transient
	public abstract Object getPrincipal();

	/**
	 * 获取凭证
	 * 
	 * @return 凭证
	 */
	@Transient
	public abstract Object getCredentials();

	/**
	 * 判断凭证是否正确
	 * 
	 * @param credentials
	 *            凭证
	 * @return 凭证是否正确
	 */
	@Transient
	public abstract boolean isValidCredentials(Object credentials);

}