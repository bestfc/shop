/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.admin;

import java.util.HashSet;

import javax.inject.Inject;

import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import net.shopxx.Message;
import net.shopxx.Pageable;
import net.shopxx.entity.Admin;
import net.shopxx.entity.BaseEntity;
import net.shopxx.service.AdminService;
import net.shopxx.service.RoleService;
import net.shopxx.service.UserService;

/**
 * Controller管理员
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("adminAdminController")
@RequestMapping("/admin/admin")
public class AdminController extends BaseController {

	@Inject
	private AdminService adminService;
	@Inject
	private UserService userService;
	@Inject
	private RoleService roleService;

	/**
	 * 检查用户名是否存在
	 */
	@GetMapping("/check_username")
	public @ResponseBody boolean checkUsername(String username) {
		return StringUtils.isNotEmpty(username) && !adminService.usernameExists(username);
	}

	/**
	 * 检查E-mail是否唯一
	 */
	@GetMapping("/check_email")
	public @ResponseBody boolean checkEmail(Long id, String email) {
		return StringUtils.isNotEmpty(email) && adminService.emailUnique(id, email);
	}

	/**
	 * 添加
	 */
	@GetMapping("/add")
	public String add(ModelMap model) {
		model.addAttribute("roles", roleService.findAll());
		return "admin/admin/add";
	}

	/**
	 * 保存
	 */
	@PostMapping("/save")
	public String save(Admin admin, Long[] roleIds, RedirectAttributes redirectAttributes) {
		admin.setRoles(new HashSet<>(roleService.findList(roleIds)));
		if (!isValid(admin, BaseEntity.Save.class)) {
			return ERROR_VIEW;
		}
		if (adminService.usernameExists(admin.getUsername())) {
			return ERROR_VIEW;
		}
		if (adminService.emailExists(admin.getEmail())) {
			return ERROR_VIEW;
		}
		admin.setIsLocked(false);
		admin.setLockDate(null);
		admin.setLastLoginIp(null);
		admin.setLastLoginDate(null);
		admin.setPaymentTransactions(null);
		adminService.save(admin);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 编辑
	 */
	@GetMapping("/edit")
	public String edit(Long id, ModelMap model) {
		model.addAttribute("roles", roleService.findAll());
		model.addAttribute("admin", adminService.find(id));
		return "admin/admin/edit";
	}

	/**
	 * 更新
	 */
	@PostMapping("/update")
	public String update(Admin admin, Long id, Long[] roleIds, Boolean unlock, RedirectAttributes redirectAttributes) {
		admin.setRoles(new HashSet<>(roleService.findList(roleIds)));
		if (!isValid(admin)) {
			return ERROR_VIEW;
		}
		if (!adminService.emailUnique(id, admin.getEmail())) {
			return ERROR_VIEW;
		}
		Admin pAdmin = adminService.find(id);
		if (pAdmin == null) {
			return ERROR_VIEW;
		}
		if (BooleanUtils.isTrue(pAdmin.getIsLocked()) && BooleanUtils.isTrue(unlock)) {
			userService.unlock(admin);
			adminService.update(admin, "username", "encodedPassword", "lastLoginIp", "lastLoginDate", "paymentTransactions");
		} else {
			adminService.update(admin, "username", "encodedPassword", "isLocked", "lockDate", "lastLoginIp", "lastLoginDate", "paymentTransactions");
		}
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Pageable pageable, ModelMap model) {
		model.addAttribute("page", adminService.findPage(pageable));
		return "admin/admin/list";
	}

	/**
	 * 删除
	 */
	@PostMapping("/delete")
	public @ResponseBody Message delete(Long[] ids) {
		if (ids.length >= adminService.count()) {
			return Message.error("admin.common.deleteAllNotAllowed");
		}
		adminService.delete(ids);
		return SUCCESS_MESSAGE;
	}

}