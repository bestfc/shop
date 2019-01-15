/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.admin;

import javax.inject.Inject;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import net.shopxx.entity.Admin;
import net.shopxx.security.CurrentUser;
import net.shopxx.service.AdminService;

/**
 * Controller个人资料
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("adminProfileController")
@RequestMapping("/admin/profile")
public class ProfileController extends BaseController {

	@Inject
	private AdminService adminService;

	/**
	 * 验证当前密码
	 */
	@GetMapping("/check_current_password")
	public @ResponseBody boolean checkCurrentPassword(String currentPassword, @CurrentUser Admin currentUser) {
		return StringUtils.isNotEmpty(currentPassword) && currentUser.isValidCredentials(currentPassword);
	}

	/**
	 * 编辑
	 */
	@GetMapping("/edit")
	public String edit(@CurrentUser Admin currentUser, ModelMap model) {
		model.addAttribute("admin", currentUser);
		return "admin/profile/edit";
	}

	/**
	 * 更新
	 */
	@PostMapping("/update")
	public String update(String currentPassword, String password, String email, @CurrentUser Admin currentUser, RedirectAttributes redirectAttributes) {
		if (!isValid(Admin.class, "email", email)) {
			return ERROR_VIEW;
		}
		if (StringUtils.isNotEmpty(currentPassword) && StringUtils.isNotEmpty(password)) {
			if (!isValid(Admin.class, "password", password)) {
				return ERROR_VIEW;
			}
			if (!currentUser.isValidCredentials(currentPassword)) {
				return ERROR_VIEW;
			}
			currentUser.setPassword(password);
		}
		currentUser.setEmail(email);
		adminService.update(currentUser);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:edit";
	}

}