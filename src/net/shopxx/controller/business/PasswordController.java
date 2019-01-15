/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.business;

import javax.inject.Inject;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import net.shopxx.entity.Business;
import net.shopxx.security.CurrentUser;
import net.shopxx.service.BusinessService;

/**
 * Controller密码
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("businessPasswordController")
@RequestMapping("/business/password")
public class PasswordController extends BaseController {

	@Inject
	private BusinessService businessService;

	/**
	 * 验证当前密码
	 */
	@GetMapping("/check_current_password")
	public @ResponseBody boolean checkCurrentPassword(String currentPassword, @CurrentUser Business currentUser) {
		return StringUtils.isNotEmpty(currentPassword) && currentUser.isValidCredentials(currentPassword);
	}

	/**
	 * 编辑
	 */
	@GetMapping("/edit")
	public String edit() {
		return "business/password/edit";
	}

	/**
	 * 更新
	 */
	@PostMapping("/update")
	public String update(String currentPassword, String password, @CurrentUser Business currentUser, RedirectAttributes redirectAttributes) {
		if (StringUtils.isEmpty(currentPassword) || StringUtils.isEmpty(password)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (!currentUser.isValidCredentials(currentPassword)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (!isValid(Business.class, "password", password)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		currentUser.setPassword(password);
		businessService.update(currentUser);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:edit";
	}

}