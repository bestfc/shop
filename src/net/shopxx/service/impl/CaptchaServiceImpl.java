/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service.impl;

import java.awt.image.BufferedImage;

import javax.inject.Inject;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.util.Assert;

import com.google.code.kaptcha.Producer;

import net.sf.ehcache.CacheManager;
import net.sf.ehcache.Ehcache;
import net.sf.ehcache.Element;
import net.shopxx.service.CaptchaService;

/**
 * Service验证码
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Service
public class CaptchaServiceImpl implements CaptchaService {

	/**
	 * "验证码"缓存名称
	 */
	private static final String CAPTCHA_CACHE_NAME = "captcha";

	@Inject
	private Producer captchaProducer;
	@Inject
	private CacheManager cacheManager;

	public BufferedImage createImage(String captchaId) {
		Assert.hasText(captchaId);

		String captcha = captchaProducer.createText();
		Ehcache cache = cacheManager.getEhcache(CAPTCHA_CACHE_NAME);
		cache.put(new Element(captchaId, captcha));
		return captchaProducer.createImage(captcha);
	}

	public boolean isValid(String captchaId, String captcha) {
		if (StringUtils.isEmpty(captchaId) || StringUtils.isEmpty(captcha)) {
			return false;
		}

		Ehcache cache = cacheManager.getEhcache(CAPTCHA_CACHE_NAME);
		Element element = cache.get(captchaId);
		if (element != null) {
			String value = (String) element.getObjectValue();
//			cache.remove(captchaId);
			return StringUtils.equalsIgnoreCase(captcha, value);
		}
		return false;
	}

}