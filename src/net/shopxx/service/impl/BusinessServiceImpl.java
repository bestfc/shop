/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service.impl;

import java.math.BigDecimal;
import java.util.List;
import java.util.Set;
import java.util.regex.Pattern;

import javax.inject.Inject;
import javax.persistence.LockModeType;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import net.shopxx.dao.BusinessDao;
import net.shopxx.dao.BusinessDepositLogDao;
import net.shopxx.entity.Business;
import net.shopxx.entity.BusinessDepositLog;
import net.shopxx.entity.Store;
import net.shopxx.entity.User;
import net.shopxx.service.BusinessService;
import net.shopxx.service.MailService;
import net.shopxx.service.SmsService;

/**
 * Service商家
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Service
public class BusinessServiceImpl extends BaseServiceImpl<Business, Long> implements BusinessService {

	/**
	 * E-mail身份配比
	 */
	private static final Pattern EMAIL_PRINCIPAL_PATTERN = Pattern.compile(".*@.*");

	/**
	 * 手机身份配比
	 */
	private static final Pattern MOBILE_PRINCIPAL_PATTERN = Pattern.compile("\\d+");

	@Inject
	private BusinessDao businessDao;
	@Inject
	private BusinessDepositLogDao businessDepositLogDao;
	@Inject
	private MailService mailService;
	@Inject
	private SmsService smsService;

	@Transactional(readOnly = true)
	public Business getUser(Object principal) {
		Assert.notNull(principal);
		Assert.isInstanceOf(String.class, principal);

		String value = (String) principal;
		if (EMAIL_PRINCIPAL_PATTERN.matcher(value).matches()) {
			return findByEmail(value);
		} else if (MOBILE_PRINCIPAL_PATTERN.matcher(value).matches()) {
			return findByMobile(value);
		} else {
			return findByUsername(value);
		}
	}

	@Transactional(readOnly = true)
	public Set<String> getPermissions(User user) {
		Assert.notNull(user);
		Assert.isInstanceOf(Business.class, user);

		Business business = (Business) user;
		Business pBusiness = businessDao.find(business.getId());
		Store store = pBusiness.getStore();
		return store != null && store.isActive() ? Business.NORMAL_BUSINESS_PERMISSIONS : Business.RESTRICT_BUSINESS_PERMISSIONS;
	}

	@Transactional(readOnly = true)
	public boolean supports(Class<?> userClass) {
		return userClass != null && Business.class.isAssignableFrom(userClass);
	}

	@Transactional(readOnly = true)
	public boolean usernameExists(String username) {
		return businessDao.exists("username", StringUtils.lowerCase(username));
	}

	@Transactional(readOnly = true)
	public Business findByUsername(String username) {
		return businessDao.find("username", StringUtils.lowerCase(username));
	}

	@Transactional(readOnly = true)
	public boolean emailExists(String email) {
		return businessDao.exists("email", StringUtils.lowerCase(email));
	}

	@Transactional(readOnly = true)
	public boolean emailUnique(Long id, String email) {
		return businessDao.unique(id, "email", StringUtils.lowerCase(email));
	}

	@Transactional(readOnly = true)
	public Business findByEmail(String email) {
		return businessDao.find("email", StringUtils.lowerCase(email));
	}

	@Transactional(readOnly = true)
	public boolean mobileExists(String mobile) {
		return businessDao.exists("mobile", StringUtils.lowerCase(mobile));
	}

	@Transactional(readOnly = true)
	public boolean mobileUnique(Long id, String mobile) {
		return businessDao.unique(id, "mobile", StringUtils.lowerCase(mobile));
	}

	@Transactional(readOnly = true)
	public Business findByMobile(String mobile) {
		return businessDao.find("mobile", StringUtils.lowerCase(mobile));
	}

	@Transactional(readOnly = true)
	public List<Business> search(String keyword, Integer count) {
		return businessDao.search(keyword, count);
	}

	@Override
	@Transactional
	public Business save(Business business) {
		Assert.notNull(business);

		Business pBusiness = super.save(business);
		mailService.sendRegisterBusinessMail(pBusiness);
		smsService.sendRegisterBusinessSms(pBusiness);
		return super.save(business);
	}

	public void addBalance(Business business, BigDecimal amount, BusinessDepositLog.Type type, String memo) {
		Assert.notNull(business);
		Assert.notNull(amount);
		Assert.notNull(type);

		if (amount.compareTo(BigDecimal.ZERO) == 0) {
			return;
		}

		if (!LockModeType.PESSIMISTIC_WRITE.equals(businessDao.getLockMode(business))) {
			businessDao.flush();
			businessDao.refresh(business, LockModeType.PESSIMISTIC_WRITE);
		}

		Assert.notNull(business.getBalance());
		Assert.state(business.getBalance().add(amount).compareTo(BigDecimal.ZERO) >= 0);

		business.setBalance(business.getBalance().add(amount));
		businessDao.flush();

		BusinessDepositLog businessDepositLog = new BusinessDepositLog();
		businessDepositLog.setType(type);
		businessDepositLog.setCredit(amount.compareTo(BigDecimal.ZERO) > 0 ? amount : BigDecimal.ZERO);
		businessDepositLog.setDebit(amount.compareTo(BigDecimal.ZERO) < 0 ? amount.abs() : BigDecimal.ZERO);
		businessDepositLog.setBalance(business.getBalance());
		businessDepositLog.setMemo(memo);
		businessDepositLog.setBusiness(business);
		businessDepositLogDao.persist(businessDepositLog);
	}

	public void addFrozenFund(Business business, BigDecimal amount) {
		Assert.notNull(business);
		Assert.notNull(amount);

		if (amount.compareTo(BigDecimal.ZERO) == 0) {
			return;
		}

		if (!LockModeType.PESSIMISTIC_WRITE.equals(businessDao.getLockMode(business))) {
			businessDao.flush();
			businessDao.refresh(business, LockModeType.PESSIMISTIC_WRITE);
		}

		Assert.notNull(business.getFrozenFund());
		Assert.state(business.getFrozenFund().add(amount).compareTo(BigDecimal.ZERO) >= 0);

		business.setFrozenFund(business.getFrozenFund().add(amount));
		businessDao.flush();
	}

}