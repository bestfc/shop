/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.plugin.ossStorage;

import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import net.shopxx.Message;
import net.shopxx.controller.admin.BaseController;
import net.shopxx.entity.PluginConfig;
import net.shopxx.service.PluginConfigService;

/**
 * Controller阿里云存储
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("adminOssStorageController")
@RequestMapping("/admin/storage_plugin/oss_storage")
public class OssStorageController extends BaseController {

	@Inject
	private OssStoragePlugin ossStoragePlugin;
	@Inject
	private PluginConfigService pluginConfigService;

	/**
	 * 安装
	 */
	@PostMapping("/install")
	public @ResponseBody Message install() {
		if (!ossStoragePlugin.getIsInstalled()) {
			PluginConfig pluginConfig = new PluginConfig();
			pluginConfig.setPluginId(ossStoragePlugin.getId());
			pluginConfig.setIsEnabled(false);
			pluginConfig.setAttributes(null);
			pluginConfigService.save(pluginConfig);
		}
		return SUCCESS_MESSAGE;
	}

	/**
	 * 卸载
	 */
	@PostMapping("/uninstall")
	public @ResponseBody Message uninstall() {
		if (ossStoragePlugin.getIsInstalled()) {
			pluginConfigService.deleteByPluginId(ossStoragePlugin.getId());
		}
		return SUCCESS_MESSAGE;
	}

	/**
	 * 设置
	 */
	@GetMapping("/setting")
	public String setting(ModelMap model) {
		PluginConfig pluginConfig = ossStoragePlugin.getPluginConfig();
		model.addAttribute("pluginConfig", pluginConfig);
		return "/net/shopxx/plugin/ossStorage/setting";
	}

	/**
	 * 更新
	 */
	@PostMapping("/update")
	public String update(String endpoint, String accessId, String accessKey, String bucketName, String urlPrefix, @RequestParam(defaultValue = "false") Boolean isEnabled, Integer order, RedirectAttributes redirectAttributes) {
		PluginConfig pluginConfig = ossStoragePlugin.getPluginConfig();
		Map<String, String> attributes = new HashMap<>();
		attributes.put("endpoint", endpoint);
		attributes.put("accessId", accessId);
		attributes.put("accessKey", accessKey);
		attributes.put("bucketName", bucketName);
		attributes.put("urlPrefix", StringUtils.removeEnd(urlPrefix, "/"));
		pluginConfig.setAttributes(attributes);
		pluginConfig.setIsEnabled(isEnabled);
		pluginConfig.setOrder(order);
		pluginConfigService.update(pluginConfig);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:/admin/storage_plugin/list";
	}

}