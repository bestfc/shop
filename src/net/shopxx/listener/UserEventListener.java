/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.listener;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;
import org.springframework.util.Assert;

import net.shopxx.Setting;
import net.shopxx.entity.Business;
import net.shopxx.entity.Cart;
import net.shopxx.entity.Member;
import net.shopxx.entity.PointLog;
import net.shopxx.entity.SocialUser;
import net.shopxx.entity.User;
import net.shopxx.event.UserLoggedInEvent;
import net.shopxx.event.UserLoggedOutEvent;
import net.shopxx.event.UserRegisteredEvent;
import net.shopxx.service.CartService;
import net.shopxx.service.MemberService;
import net.shopxx.service.SocialUserService;
import net.shopxx.util.SystemUtils;
import net.shopxx.util.WebUtils;

/**
 * Listener用户事件
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Component
public class UserEventListener {

	@Inject
	private MemberService memberService;
	@Inject
	private CartService cartService;
	@Inject
	private SocialUserService socialUserService;

	/**
	 * 事件处理
	 * 
	 * @param userRegisteredEvent
	 *            用户注册事件
	 */
	@EventListener
	public void handle(UserRegisteredEvent userRegisteredEvent) {
		User user = userRegisteredEvent.getUser();
		HttpServletRequest request = WebUtils.getRequest();

		if (user instanceof Member) {
			String socialUserId = request.getParameter("socialUserId");
			String uniqueId = request.getParameter("uniqueId");
			if (StringUtils.isNotEmpty(socialUserId) && StringUtils.isNotEmpty(uniqueId)) {
				SocialUser socialUser = socialUserService.find(Long.parseLong(socialUserId));
				if (socialUser != null && socialUser.getUser() == null) {
					socialUserService.bindUser(user, socialUser, uniqueId);
				}
			}

			Member member = (Member) user;
			Setting setting = SystemUtils.getSetting();
			if (setting.getRegisterPoint() > 0) {
				memberService.addPoint(member, setting.getRegisterPoint(), PointLog.Type.reward, null);
			}
		}
	}

	/**
	 * 事件处理
	 * 
	 * @param userLoggedInEvent
	 *            用户登录事件
	 */
	@EventListener
	public void handle(UserLoggedInEvent userLoggedInEvent) {
		User user = userLoggedInEvent.getUser();
		HttpServletRequest request = WebUtils.getRequest();
		HttpServletResponse response = WebUtils.getResponse();

		if (user instanceof Member) {
			String socialUserId = request.getParameter("socialUserId");
			String uniqueId = request.getParameter("uniqueId");
			if (StringUtils.isNotEmpty(socialUserId) && StringUtils.isNotEmpty(uniqueId)) {
				SocialUser socialUser = socialUserService.find(Long.parseLong(socialUserId));
				if (socialUser != null && socialUser.getUser() == null) {
					socialUserService.bindUser(user, socialUser, uniqueId);
				}
			}

			Member member = (Member) user;
			Subject subject = SecurityUtils.getSubject();
			sessionFixationProtection(subject);

			Cart cart = member.getCart();
			cartService.merge(cart != null ? cart : cartService.create());

			WebUtils.addCookie(request, response, Member.CURRENT_USERNAME_COOKIE_NAME, member.getUsername());
		} else if (user instanceof Business) {
			Subject subject = SecurityUtils.getSubject();
			sessionFixationProtection(subject);

			WebUtils.removeCookie(request, response, Member.CURRENT_USERNAME_COOKIE_NAME);
		}

	}

	/**
	 * 事件处理
	 * 
	 * @param userLoggedOutEvent
	 *            用户注销事件
	 */
	@EventListener
	public void handle(UserLoggedOutEvent userLoggedOutEvent) {
		HttpServletRequest request = WebUtils.getRequest();
		HttpServletResponse response = WebUtils.getResponse();

		WebUtils.removeCookie(request, response, Member.CURRENT_USERNAME_COOKIE_NAME);
	}

	/**
	 * Session固定攻击防护
	 * 
	 * @param subject
	 *            Subject
	 */
	private void sessionFixationProtection(Subject subject) {
		Assert.notNull(subject);

		Session session = subject.getSession();
		Map<Object, Object> attributes = new HashMap<>();
		Collection<Object> attributeKeys = session.getAttributeKeys();
		for (Object attributeKey : attributeKeys) {
			attributes.put(attributeKey, session.getAttribute(attributeKey));
		}
		session.stop();
		session = subject.getSession(true);
		for (Map.Entry<Object, Object> entry : attributes.entrySet()) {
			session.setAttribute(entry.getKey(), entry.getValue());
		}
	}

}