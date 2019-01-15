/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.member;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import net.shopxx.entity.Member;
import net.shopxx.entity.MemberAttribute;
import net.shopxx.security.CurrentUser;
import net.shopxx.service.MemberAttributeService;
import net.shopxx.service.MemberService;

/**
 * Controller个人资料
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("memberProfileController")
@RequestMapping("/member/profile")
public class ProfileController extends BaseController {

	@Inject
	private MemberService memberService;
	@Inject
	private MemberAttributeService memberAttributeService;

	/**
	 * 检查E-mail是否唯一
	 */
	@GetMapping("/check_email")
	public @ResponseBody boolean checkEmail(String email, @CurrentUser Member currentUser) {
		return StringUtils.isNotEmpty(email) && memberService.emailUnique(currentUser.getId(), email);
	}

	/**
	 * 检查手机是否唯一
	 */
	@GetMapping("/check_mobile")
	public @ResponseBody boolean checkMobile(String mobile, @CurrentUser Member currentUser) {
		return StringUtils.isNotEmpty(mobile) && memberService.mobileUnique(currentUser.getId(), mobile);
	}

	/**
	 * 编辑
	 */
	@GetMapping("/edit")
	public String edit(ModelMap model) {
		model.addAttribute("genders", Member.Gender.values());
		return "member/profile/edit";
	}

	/**
	 * 更新
	 */
	@PostMapping("/update")
	public String update(String email, String mobile, @CurrentUser Member currentUser, HttpServletRequest request, RedirectAttributes redirectAttributes) {
		if (!isValid(Member.class, "email", email) || !isValid(Member.class, "mobile", mobile)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (!memberService.emailUnique(currentUser.getId(), email)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (!memberService.mobileUnique(currentUser.getId(), mobile)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		currentUser.setEmail(email);
		currentUser.setMobile(mobile);
		currentUser.removeAttributeValue();
		for (MemberAttribute memberAttribute : memberAttributeService.findList(true, true)) {
			String[] values = request.getParameterValues("memberAttribute_" + memberAttribute.getId());
			if (!memberAttributeService.isValid(memberAttribute, values)) {
				return UNPROCESSABLE_ENTITY_VIEW;
			}
			Object memberAttributeValue = memberAttributeService.toMemberAttributeValue(memberAttribute, values);
			currentUser.setAttributeValue(memberAttribute, memberAttributeValue);
		}
		memberService.update(currentUser);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:edit";
	}

}