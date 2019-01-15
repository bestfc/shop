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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import net.shopxx.entity.MessageConfig;
import net.shopxx.service.MessageConfigService;

/**
 * Controller消息配置
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("adminMessageConfigController")
@RequestMapping("/admin/message_config")
public class MessageConfigController extends BaseController {

	@Inject
	private MessageConfigService messageConfigService;

	/**
	 * 编辑
	 */
	@GetMapping("/edit")
	public String edit(Long id, ModelMap model) {
		model.addAttribute("messageConfig", messageConfigService.find(id));
		return "admin/message_config/edit";
	}

	/**
	 * 更新
	 */
	@PostMapping("/update")
	public String update(MessageConfig messageConfig, RedirectAttributes redirectAttributes) {
		if (!isValid(messageConfig)) {
			return ERROR_VIEW;
		}
		messageConfigService.update(messageConfig, "type");
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(ModelMap model) {
		model.addAttribute("messageConfigs", messageConfigService.findAll());
		return "admin/message_config/list";
	}

}