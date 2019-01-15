/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.admin;

import javax.inject.Inject;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import net.shopxx.Message;
import net.shopxx.Pageable;
import net.shopxx.entity.Navigation;
import net.shopxx.service.ArticleCategoryService;
import net.shopxx.service.NavigationService;
import net.shopxx.service.ProductCategoryService;

/**
 * Controller导航
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("adminNavigationController")
@RequestMapping("/admin/navigation")
public class NavigationController extends BaseController {

	@Inject
	private NavigationService navigationService;
	@Inject
	private ArticleCategoryService articleCategoryService;
	@Inject
	private ProductCategoryService productCategoryService;

	/**
	 * 添加
	 */
	@GetMapping("/add")
	public String add(ModelMap model) {
		model.addAttribute("positions", Navigation.Position.values());
		model.addAttribute("articleCategoryTree", articleCategoryService.findTree());
		model.addAttribute("productCategoryTree", productCategoryService.findTree());
		return "admin/navigation/add";
	}

	/**
	 * 保存
	 */
	@PostMapping("/save")
	public String save(Navigation navigation, RedirectAttributes redirectAttributes) {
		if (!isValid(navigation)) {
			return ERROR_VIEW;
		}
		navigationService.save(navigation);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 编辑
	 */
	@GetMapping("/edit")
	public String edit(Long id, ModelMap model) {
		model.addAttribute("positions", Navigation.Position.values());
		model.addAttribute("articleCategoryTree", articleCategoryService.findTree());
		model.addAttribute("productCategoryTree", productCategoryService.findTree());
		model.addAttribute("navigation", navigationService.find(id));
		return "admin/navigation/edit";
	}

	/**
	 * 更新
	 */
	@PostMapping("/update")
	public String update(Navigation navigation, RedirectAttributes redirectAttributes) {
		if (!isValid(navigation)) {
			return ERROR_VIEW;
		}
		navigationService.update(navigation);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Pageable pageable, ModelMap model) {
		model.addAttribute("topNavigations", navigationService.findList(Navigation.Position.top));
		model.addAttribute("middleNavigations", navigationService.findList(Navigation.Position.middle));
		model.addAttribute("bottomNavigations", navigationService.findList(Navigation.Position.bottom));
		return "admin/navigation/list";
	}

	/**
	 * 删除
	 */
	@PostMapping("/delete")
	public @ResponseBody Message delete(Long[] ids) {
		navigationService.delete(ids);
		return SUCCESS_MESSAGE;
	}

}