/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.business;

import javax.inject.Inject;

import org.springframework.beans.BeanUtils;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import net.shopxx.Pageable;
import net.shopxx.Results;
import net.shopxx.entity.InstantMessage;
import net.shopxx.entity.Store;
import net.shopxx.exception.UnauthorizedException;
import net.shopxx.security.CurrentStore;
import net.shopxx.service.InstantMessageService;

/**
 * Controller即时通讯
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("businessInstantMessageController")
@RequestMapping("/business/instant_message")
public class InstantMessageController extends BaseController {

	@Inject
	private InstantMessageService instantMessageService;

	/**
	 * 添加属性
	 */
	@ModelAttribute
	public void populateModel(Long instantMessageId, @CurrentStore Store currentStore, ModelMap model) {
		InstantMessage instantMessage = instantMessageService.find(instantMessageId);
		if (instantMessage != null && !currentStore.equals(instantMessage.getStore())) {
			throw new UnauthorizedException();
		}
		model.addAttribute("instantMessage", instantMessage);
	}

	/**
	 * 添加
	 */
	@GetMapping("/add")
	public String add(ModelMap model) {
		model.addAttribute("types", InstantMessage.Type.values());
		return "business/instant_message/add";
	}

	/**
	 * 保存
	 */
	@PostMapping("/save")
	public String save(@ModelAttribute("instantMessageForm") InstantMessage instantMessageForm, @CurrentStore Store currentStore, RedirectAttributes redirectAttributes) {
		if (!isValid(instantMessageForm)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		instantMessageForm.setStore(currentStore);
		instantMessageService.save(instantMessageForm);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 编辑
	 */
	@GetMapping("/edit")
	public String edit(@ModelAttribute(binding = false) InstantMessage instantMessage, ModelMap model) {
		if (instantMessage == null) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}

		model.addAttribute("types", InstantMessage.Type.values());
		model.addAttribute("instantMessage", instantMessage);
		return "business/instant_message/edit";
	}

	/**
	 * 更新
	 */
	@PostMapping("/update")
	public String update(@ModelAttribute("instantMessageForm") InstantMessage instantMessageForm, @ModelAttribute(binding = false) InstantMessage instantMessage, RedirectAttributes redirectAttributes) {
		if (!isValid(instantMessageForm)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (instantMessage == null) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}

		BeanUtils.copyProperties(instantMessageForm, instantMessage, "id", "store");
		instantMessageService.update(instantMessage);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Pageable pageable, @CurrentStore Store currentStore, ModelMap model) {
		model.addAttribute("page", instantMessageService.findPage(currentStore, pageable));
		return "business/instant_message/list";
	}

	/**
	 * 删除
	 */
	@PostMapping("/delete")
	public ResponseEntity<?> delete(Long[] ids, @CurrentStore Store currentStore) {
		for (Long id : ids) {
			InstantMessage instantMessage = instantMessageService.find(id);
			if (instantMessage == null || !currentStore.equals(instantMessage.getStore())) {
				return Results.UNPROCESSABLE_ENTITY;
			}
			instantMessageService.delete(id);
		}
		return Results.OK;
	}

}