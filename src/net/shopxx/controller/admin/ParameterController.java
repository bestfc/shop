/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.admin;

import javax.inject.Inject;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.Predicate;
import org.apache.commons.collections.functors.AndPredicate;
import org.apache.commons.collections.functors.UniquePredicate;
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
import net.shopxx.entity.BaseEntity;
import net.shopxx.entity.Parameter;
import net.shopxx.service.ParameterService;
import net.shopxx.service.ProductCategoryService;

/**
 * Controller参数
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("adminParameterController")
@RequestMapping("/admin/parameter")
public class ParameterController extends BaseController {

	@Inject
	private ParameterService parameterService;
	@Inject
	private ProductCategoryService productCategoryService;

	/**
	 * 添加
	 */
	@GetMapping("/add")
	public String add(Long sampleId, ModelMap model) {
		model.addAttribute("sample", parameterService.find(sampleId));
		model.addAttribute("productCategoryTree", productCategoryService.findTree());
		return "admin/parameter/add";
	}

	/**
	 * 保存
	 */
	@PostMapping("/save")
	public String save(Parameter parameter, Long productCategoryId, RedirectAttributes redirectAttributes) {
		CollectionUtils.filter(parameter.getNames(), new AndPredicate(new UniquePredicate(), new Predicate() {
			public boolean evaluate(Object object) {
				String name = (String) object;
				return StringUtils.isNotEmpty(name);
			}
		}));
		parameter.setProductCategory(productCategoryService.find(productCategoryId));
		if (!isValid(parameter, BaseEntity.Save.class)) {
			return ERROR_VIEW;
		}
		parameterService.save(parameter);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 编辑
	 */
	@GetMapping("/edit")
	public String edit(Long id, ModelMap model) {
		model.addAttribute("parameter", parameterService.find(id));
		return "admin/parameter/edit";
	}

	/**
	 * 更新
	 */
	@PostMapping("/update")
	public String update(Parameter parameter, RedirectAttributes redirectAttributes) {
		CollectionUtils.filter(parameter.getNames(), new AndPredicate(new UniquePredicate(), new Predicate() {
			public boolean evaluate(Object object) {
				String name = (String) object;
				return StringUtils.isNotEmpty(name);
			}
		}));
		if (!isValid(parameter, BaseEntity.Update.class)) {
			return ERROR_VIEW;
		}
		parameterService.update(parameter, "productCategory");
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Pageable pageable, ModelMap model) {
		model.addAttribute("page", parameterService.findPage(pageable));
		return "admin/parameter/list";
	}

	/**
	 * 删除
	 */
	@PostMapping("/delete")
	public @ResponseBody Message delete(Long[] ids) {
		parameterService.delete(ids);
		return SUCCESS_MESSAGE;
	}

}