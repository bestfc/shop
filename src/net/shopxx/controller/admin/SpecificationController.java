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
import net.shopxx.entity.Specification;
import net.shopxx.service.ProductCategoryService;
import net.shopxx.service.SpecificationService;

/**
 * Controller规格
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("adminSpecificationController")
@RequestMapping("/admin/specification")
public class SpecificationController extends BaseController {

	@Inject
	private SpecificationService specificationService;
	@Inject
	private ProductCategoryService productCategoryService;

	/**
	 * 添加
	 */
	@GetMapping("/add")
	public String add(Long sampleId, ModelMap model) {
		model.addAttribute("sample", specificationService.find(sampleId));
		model.addAttribute("productCategoryTree", productCategoryService.findTree());
		return "admin/specification/add";
	}

	/**
	 * 保存
	 */
	@PostMapping("/save")
	public String save(Specification specification, Long productCategoryId, RedirectAttributes redirectAttributes) {
		CollectionUtils.filter(specification.getOptions(), new AndPredicate(new UniquePredicate(), new Predicate() {
			public boolean evaluate(Object object) {
				String option = (String) object;
				return StringUtils.isNotEmpty(option);
			}
		}));
		specification.setProductCategory(productCategoryService.find(productCategoryId));
		if (!isValid(specification, BaseEntity.Save.class)) {
			return ERROR_VIEW;
		}
		specificationService.save(specification);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 编辑
	 */
	@GetMapping("/edit")
	public String edit(Long id, ModelMap model) {
		model.addAttribute("productCategoryTree", productCategoryService.findTree());
		model.addAttribute("specification", specificationService.find(id));
		return "admin/specification/edit";
	}

	/**
	 * 更新
	 */
	@PostMapping("/update")
	public String update(Specification specification, RedirectAttributes redirectAttributes) {
		CollectionUtils.filter(specification.getOptions(), new AndPredicate(new UniquePredicate(), new Predicate() {
			public boolean evaluate(Object object) {
				String option = (String) object;
				return StringUtils.isNotEmpty(option);
			}
		}));
		if (!isValid(specification)) {
			return ERROR_VIEW;
		}
		specificationService.update(specification, "productCategory");
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Pageable pageable, ModelMap model) {
		model.addAttribute("page", specificationService.findPage(pageable));
		return "admin/specification/list";
	}

	/**
	 * 删除
	 */
	@PostMapping("/delete")
	public @ResponseBody Message delete(Long[] ids) {
		specificationService.delete(ids);
		return SUCCESS_MESSAGE;
	}

}