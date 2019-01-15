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

import net.shopxx.Message;
import net.shopxx.Pageable;
import net.shopxx.entity.Brand;
import net.shopxx.service.BrandService;

/**
 * Controller品牌
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("adminBrandController")
@RequestMapping("/admin/brand")
public class BrandController extends BaseController {

	@Inject
	private BrandService brandService;

	/**
	 * 添加
	 */
	@GetMapping("/add")
	public String add(ModelMap model) {
		model.addAttribute("types", Brand.Type.values());
		return "admin/brand/add";
	}

	/**
	 * 保存
	 */
	@PostMapping("/save")
	public String save(Brand brand, RedirectAttributes redirectAttributes) {
		if (!isValid(brand)) {
			return ERROR_VIEW;
		}
		if (Brand.Type.text.equals(brand.getType())) {
			brand.setLogo(null);
		} else if (StringUtils.isEmpty(brand.getLogo())) {
			return ERROR_VIEW;
		}
		brand.setProducts(null);
		brand.setProductCategories(null);
		brandService.save(brand);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 编辑
	 */
	@GetMapping("/edit")
	public String edit(Long id, ModelMap model) {
		model.addAttribute("types", Brand.Type.values());
		model.addAttribute("brand", brandService.find(id));
		return "admin/brand/edit";
	}

	/**
	 * 更新
	 */
	@PostMapping("/update")
	public String update(Brand brand, RedirectAttributes redirectAttributes) {
		if (!isValid(brand)) {
			return ERROR_VIEW;
		}
		if (Brand.Type.text.equals(brand.getType())) {
			brand.setLogo(null);
		} else if (StringUtils.isEmpty(brand.getLogo())) {
			return ERROR_VIEW;
		}
		brandService.update(brand, "products", "productCategories");
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Pageable pageable, ModelMap model) {
		model.addAttribute("page", brandService.findPage(pageable));
		return "admin/brand/list";
	}

	/**
	 * 删除
	 */
	@PostMapping("/delete")
	public @ResponseBody Message delete(Long[] ids) {
		brandService.delete(ids);
		return SUCCESS_MESSAGE;
	}

}