/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service.impl;

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

import javax.inject.Inject;
import javax.persistence.LockModeType;
import javax.servlet.http.HttpServletRequest;

import net.shopxx.exception.ErrorCode;
import net.shopxx.util.EhcacheUtils;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.lang.time.DateUtils;
import org.apache.poi.ss.formula.functions.T;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.DisabledAccountException;
import org.apache.shiro.authc.HostAuthenticationToken;
import org.apache.shiro.authc.IncorrectCredentialsException;
import org.apache.shiro.authc.LockedAccountException;
import org.apache.shiro.authc.UnknownAccountException;
import org.apache.shiro.subject.Subject;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import net.sf.ehcache.CacheManager;
import net.sf.ehcache.Ehcache;
import net.sf.ehcache.Element;
import net.shopxx.Setting;
import net.shopxx.dao.UserDao;
import net.shopxx.entity.User;
import net.shopxx.event.UserLoggedInEvent;
import net.shopxx.event.UserLoggedOutEvent;
import net.shopxx.event.UserRegisteredEvent;
import net.shopxx.security.AuthenticationProvider;
import net.shopxx.security.SocialUserAuthenticationToken;
import net.shopxx.security.UserAuthenticationToken;
import net.shopxx.service.UserService;
import net.shopxx.util.SystemUtils;

/**
 * Service用户
 *
 * @author SHOP++ Team
 * @version 5.0
 */
@Service
public class UserServiceImpl extends BaseServiceImpl<User, Long> implements UserService {

	/**
	 * 认证Provider缓存
	 */
	private static final Map<Class<?>, AuthenticationProvider> AUTHENTICATION_PROVIDER_CACHE = new ConcurrentHashMap<>();

	@Inject
	private ApplicationEventPublisher applicationEventPublisher;
	@Inject
	private List<AuthenticationProvider> authenticationProviders;
	@Inject
	private CacheManager cacheManager;
	@Inject
	private UserDao userDao;

	@Transactional(readOnly = true)
	public User getCurrentAuditor() {
		return getCurrent();
	}

	@Transactional(noRollbackFor = AuthenticationException.class)
	public User getUser(AuthenticationToken authenticationToken) {

		/**判断token合法性*/
		Assert.notNull(authenticationToken);
		Assert.state(authenticationToken instanceof UserAuthenticationToken || authenticationToken instanceof SocialUserAuthenticationToken);
		/**
		 *获取类、用户名
		 * */
		User user = null;
		Object principal = null;
		if (authenticationToken instanceof UserAuthenticationToken) {
			UserAuthenticationToken userAuthenticationToken = (UserAuthenticationToken) authenticationToken;
			Class<?> userClass = userAuthenticationToken.getUserClass();
			principal = userAuthenticationToken.getPrincipal();

			if (userClass == null || principal == null) {
				throw new UnknownAccountException();
			}
			AuthenticationProvider authenticationProvider = getAuthenticationProvider(userClass);
			user = authenticationProvider != null ? authenticationProvider.getUser(principal) : null;
		} else if (authenticationToken instanceof SocialUserAuthenticationToken) {
			SocialUserAuthenticationToken socialUserAuthenticationToken = (SocialUserAuthenticationToken) authenticationToken;
			/**通过用户名或者手机号获取用户*/
			user = socialUserAuthenticationToken.getSocialUser() != null ? socialUserAuthenticationToken.getSocialUser().getUser() : null;
		}

		if (user == null) {
			throw new UnknownAccountException();
		}
		if (BooleanUtils.isNotTrue(user.getIsEnabled())) {
			throw new DisabledAccountException();
		}
		if (BooleanUtils.isTrue(user.getIsLocked()) && !tryUnlock(user)) {
			throw new LockedAccountException();
		}
		if (authenticationToken instanceof UserAuthenticationToken) {
			if (authenticationToken.getCredentials() instanceof char[]) {
				//未加密密码或验证码
				char[] a = (char[]) authenticationToken.getCredentials();
				if (a.length == 4) {
					//长度为4，验证码
					EhcacheUtils ehcacheUtils = new EhcacheUtils();
					String code = ehcacheUtils.getCache(principal.toString()).toString();
					if (new String(a).equals(code)) {
						return user;
					}
				}
			}
			Object credentials = authenticationToken.getCredentials();
			if (!user.isValidCredentials(credentials)) {
				addFailedLoginAttempt(user);
				tryLock(user);
				throw new IncorrectCredentialsException();
			}
		}
		if (authenticationToken instanceof HostAuthenticationToken) {
			HostAuthenticationToken hostAuthenticationToken = (HostAuthenticationToken) authenticationToken;
			user.setLastLoginIp(hostAuthenticationToken.getHost());
		}
		user.setLastLoginDate(new Date());
		resetFailedLoginAttempts(user);
		return user;
	}

	@Transactional(readOnly = true)
	public Set<String> getPermissions(User user) {
		Assert.notNull(user);

		AuthenticationProvider authenticationProvider = getAuthenticationProvider(user.getClass());
		return authenticationProvider != null ? authenticationProvider.getPermissions(user) : null;
	}

	public void register(User user) {
		Assert.notNull(user);
		Assert.isTrue(user.isNew());

		userDao.persist(user);

		applicationEventPublisher.publishEvent(new UserRegisteredEvent(this, user));
	}

	public void login(AuthenticationToken authenticationToken) {
		Assert.notNull(authenticationToken);

		Subject subject = SecurityUtils.getSubject();
		subject.login(authenticationToken);

		applicationEventPublisher.publishEvent(new UserLoggedInEvent(this, getCurrent()));
	}

	public void logout() {
		applicationEventPublisher.publishEvent(new UserLoggedOutEvent(this, getCurrent()));

		Subject subject = SecurityUtils.getSubject();
		subject.logout();
	}

	@Transactional(readOnly = true)
	public User getCurrent() {
		return getCurrent(null, null);
	}

	@Transactional(readOnly = true)
	public <T extends User> T getCurrent(Class<T> userClass) {
		return getCurrent(userClass, null);
	}

	@SuppressWarnings("unchecked")
	@Transactional(readOnly = true)
	public <T extends User> T getCurrent(Class<T> userClass, LockModeType lockModeType) {
		Subject subject = SecurityUtils.getSubject();
		User principal = subject != null && subject.getPrincipal() instanceof User ? (User) subject.getPrincipal() : null;
		if (principal != null) {
			User user = userDao.find(principal.getId(), lockModeType);
			if (userClass == null || (user != null && userClass.isAssignableFrom(user.getClass()))) {
				return (T) user;
			}
		}
		return null;
	}

	@Transactional(readOnly = true)
	public int getFailedLoginAttempts(User user) {
		Assert.notNull(user);
		Assert.isTrue(!user.isNew());

		Ehcache cache = cacheManager.getEhcache(User.FAILED_LOGIN_ATTEMPTS_CACHE_NAME);
		Element element = cache.get(user.getId());
		AtomicInteger failedLoginAttempts = element != null ? (AtomicInteger) element.getObjectValue() : null;
		return failedLoginAttempts != null ? failedLoginAttempts.get() : 0;
	}

	@Transactional(readOnly = true)
	public void addFailedLoginAttempt(User user) {
		Assert.notNull(user);
		Assert.isTrue(!user.isNew());

		Long userId = user.getId();
		Ehcache cache = cacheManager.getEhcache(User.FAILED_LOGIN_ATTEMPTS_CACHE_NAME);
		cache.acquireWriteLockOnKey(userId);
		try {
			Element element = cache.get(userId);
			AtomicInteger failedLoginAttempts = element != null ? (AtomicInteger) element.getObjectValue() : null;
			if (failedLoginAttempts != null) {
				failedLoginAttempts.incrementAndGet();
			} else {
				cache.put(new Element(userId, new AtomicInteger(1)));
			}
		} finally {
			cache.releaseWriteLockOnKey(userId);
		}
	}

	@Transactional(readOnly = true)
	public void resetFailedLoginAttempts(User user) {
		Assert.notNull(user);
		Assert.isTrue(!user.isNew());

		Ehcache cache = cacheManager.getEhcache(User.FAILED_LOGIN_ATTEMPTS_CACHE_NAME);
		cache.remove(user.getId());
	}

	public boolean tryLock(User user) {
		Assert.notNull(user);
		Assert.isTrue(!user.isNew());

		if (BooleanUtils.isTrue(user.getIsLocked())) {
			return true;
		}

		Setting setting = SystemUtils.getSetting();
		if (setting.getMaxFailedLoginAttempts() != null) {
			int failedLoginAttempts = getFailedLoginAttempts(user);
			if (failedLoginAttempts >= setting.getMaxFailedLoginAttempts()) {
				user.setIsLocked(true);
				user.setLockDate(new Date());
				return true;
			}
		}
		return false;
	}

	public boolean tryUnlock(User user) {
		Assert.notNull(user);
		Assert.isTrue(!user.isNew());

		if (BooleanUtils.isFalse(user.getIsLocked())) {
			return true;
		}

		Setting setting = SystemUtils.getSetting();
		if (setting.getPasswordLockTime() != null) {
			Date lockDate = user.getLockDate();
			Date unlockDate = DateUtils.addMinutes(lockDate, setting.getPasswordLockTime());
			if (new Date().after(unlockDate)) {
				unlock(user);
				return true;
			}
		}
		return false;
	}

	public void unlock(User user) {
		Assert.notNull(user);
		Assert.isTrue(!user.isNew());

		if (BooleanUtils.isFalse(user.getIsLocked())) {
			return;
		}

		user.setIsLocked(false);
		user.setLockDate(null);
		resetFailedLoginAttempts(user);
	}

	@Override
	@Transactional
	@CacheEvict(value = "authorization", allEntries = true)
	public User save(User user) {
		return super.save(user);
	}

	@Override
	@Transactional
	@CacheEvict(value = "authorization", allEntries = true)
	public User update(User user) {
		return super.update(user);
	}

	@Override
	@Transactional
	@CacheEvict(value = "authorization", allEntries = true)
	public User update(User user, String... ignoreProperties) {
		return super.update(user, ignoreProperties);
	}

	@Override
	@Transactional
	@CacheEvict(value = "authorization", allEntries = true)
	public void delete(Long id) {
		super.delete(id);
	}

	@Override
	@Transactional
	@CacheEvict(value = "authorization", allEntries = true)
	public void delete(Long... ids) {
		super.delete(ids);
	}

	@Override
	@Transactional
	@CacheEvict(value = "authorization", allEntries = true)
	public void delete(User user) {
		super.delete(user);
	}

	/**
	 * 获取认证Provider
	 *
	 * @param userClass
	 *            用户类型
	 * @return 认证Provider，若不存在则返回null
	 */
	private AuthenticationProvider getAuthenticationProvider(Class<?> userClass) {
		Assert.notNull(userClass);

		if (AUTHENTICATION_PROVIDER_CACHE.containsKey(userClass)) {
			return AUTHENTICATION_PROVIDER_CACHE.get(userClass);
		}

		if (CollectionUtils.isNotEmpty(authenticationProviders)) {
			for (AuthenticationProvider authenticationProvider : authenticationProviders) {
				if (authenticationProvider != null && authenticationProvider.supports(userClass)) {
					AUTHENTICATION_PROVIDER_CACHE.put(userClass, authenticationProvider);
					return authenticationProvider;
				}
			}
		}
		return null;
	}

}