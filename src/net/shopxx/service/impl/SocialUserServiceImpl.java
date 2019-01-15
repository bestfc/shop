/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service.impl;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.dao.SocialUserDao;
import net.shopxx.entity.SocialUser;
import net.shopxx.entity.User;
import net.shopxx.service.SocialUserService;

/**
 * Service社会化用户
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Service
public class SocialUserServiceImpl extends BaseServiceImpl<SocialUser, Long> implements SocialUserService {

	@Inject
	private SocialUserDao socialUserDao;

	@Transactional(readOnly = true)
	public SocialUser find(String loginPluginId, String uniqueId) {
		return socialUserDao.find(loginPluginId, uniqueId);
	}

	@Transactional(readOnly = true)
	public Page<SocialUser> findPage(User user, Pageable pageable) {
		return socialUserDao.findPage(user, pageable);
	}

	public void bindUser(User user, SocialUser socialUser, String uniqueId) {
		Assert.notNull(socialUser);
		Assert.hasText(uniqueId);

		if (!socialUser.getUniqueId().equals(uniqueId) || socialUser.getUser() != null) {
			return;
		}

		socialUser.setUser(user);
	}

}