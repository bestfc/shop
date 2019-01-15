/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.admin;

import java.util.List;
import java.util.regex.Pattern;
import java.util.regex.PatternSyntaxException;

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
import net.shopxx.entity.Member;
import net.shopxx.entity.MemberAttribute;
import net.shopxx.service.MemberAttributeService;

/**
 * Controller会员注册项
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("adminMemberAttributeController")
@RequestMapping("/admin/member_attribute")
public class MemberAttributeController extends BaseController {

	@Inject
	private MemberAttributeService memberAttributeService;

	/**
	 * 检查配比语法是否正确
	 */
	@GetMapping("/check_pattern")
	public @ResponseBody boolean checkPattern(String pattern) {
		if (StringUtils.isEmpty(pattern)) {
			return false;
		}
		try {
			Pattern.compile(pattern);
		} catch (PatternSyntaxException e) {
			return false;
		}
		return true;
	}

	/**
	 * 添加
	 */
	@GetMapping("/add")
	public String add(ModelMap model, RedirectAttributes redirectAttributes) {
		if (memberAttributeService.findUnusedPropertyIndex() == null) {
			addFlashMessage(redirectAttributes, Message.warn("admin.memberAttribute.addCountNotAllowed", Member.ATTRIBUTE_VALUE_PROPERTY_COUNT));
			return "redirect:list";
		}
		return "admin/member_attribute/add";
	}

	/**
	 * 保存
	 */
	@PostMapping("/save")
	public String save(MemberAttribute memberAttribute, RedirectAttributes redirectAttributes) {
		if (!isValid(memberAttribute, BaseEntity.Save.class)) {
			return ERROR_VIEW;
		}
		if (MemberAttribute.Type.select.equals(memberAttribute.getType()) || MemberAttribute.Type.checkbox.equals(memberAttribute.getType())) {
			List<String> options = memberAttribute.getOptions();
			CollectionUtils.filter(options, new AndPredicate(new UniquePredicate(), new Predicate() {
				public boolean evaluate(Object object) {
					String option = (String) object;
					return StringUtils.isNotEmpty(option);
				}
			}));
			if (CollectionUtils.isEmpty(options)) {
				return ERROR_VIEW;
			}
			memberAttribute.setPattern(null);
		} else if (MemberAttribute.Type.text.equals(memberAttribute.getType())) {
			memberAttribute.setOptions(null);
		} else {
			return ERROR_VIEW;
		}
		if (StringUtils.isNotEmpty(memberAttribute.getPattern())) {
			try {
				Pattern.compile(memberAttribute.getPattern());
			} catch (PatternSyntaxException e) {
				return ERROR_VIEW;
			}
		}
		Integer propertyIndex = memberAttributeService.findUnusedPropertyIndex();
		if (propertyIndex == null) {
			return ERROR_VIEW;
		}
		memberAttribute.setPropertyIndex(null);
		memberAttributeService.save(memberAttribute);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 编辑
	 */
	@GetMapping("/edit")
	public String edit(Long id, ModelMap model) {
		model.addAttribute("memberAttribute", memberAttributeService.find(id));
		return "admin/member_attribute/edit";
	}

	/**
	 * 更新
	 */
	@PostMapping("/update")
	public String update(MemberAttribute memberAttribute, RedirectAttributes redirectAttributes) {
		if (!isValid(memberAttribute)) {
			return ERROR_VIEW;
		}
		MemberAttribute pMemberAttribute = memberAttributeService.find(memberAttribute.getId());
		if (pMemberAttribute == null) {
			return ERROR_VIEW;
		}
		if (MemberAttribute.Type.select.equals(pMemberAttribute.getType()) || MemberAttribute.Type.checkbox.equals(pMemberAttribute.getType())) {
			List<String> options = memberAttribute.getOptions();
			CollectionUtils.filter(options, new AndPredicate(new UniquePredicate(), new Predicate() {
				public boolean evaluate(Object object) {
					String option = (String) object;
					return StringUtils.isNotEmpty(option);
				}
			}));
			if (CollectionUtils.isEmpty(options)) {
				return ERROR_VIEW;
			}
			memberAttribute.setPattern(null);
		} else {
			memberAttribute.setOptions(null);
		}
		if (StringUtils.isNotEmpty(memberAttribute.getPattern())) {
			try {
				Pattern.compile(memberAttribute.getPattern());
			} catch (PatternSyntaxException e) {
				return ERROR_VIEW;
			}
		}
		memberAttributeService.update(memberAttribute, "type", "propertyIndex");
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Pageable pageable, ModelMap model) {
		model.addAttribute("page", memberAttributeService.findPage(pageable));
		return "admin/member_attribute/list";
	}

	/**
	 * 删除
	 */
	@PostMapping("/delete")
	public @ResponseBody Message delete(Long[] ids) {
		memberAttributeService.delete(ids);
		return SUCCESS_MESSAGE;
	}

}