/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.plugin.discountPromotion;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;

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
import net.shopxx.entity.Promotion;
import net.shopxx.plugin.PromotionPlugin;
import net.shopxx.service.PluginConfigService;
import net.shopxx.service.PromotionService;

/**
 * Controller折扣促销
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("adminDiscountPromotionController")
@RequestMapping("/admin/promotion_plugin/discount_promotion")
public class DiscountPromotionController extends BaseController {

	@Inject
	private DiscountPromotionPlugin discountPromotionPlugin;
	@Inject
	private PluginConfigService pluginConfigService;
	@Inject
	private PromotionService promotionService;

	/**
	 * 安装
	 */
	@PostMapping("/install")
	public @ResponseBody Message install() {
		if (!discountPromotionPlugin.getIsInstalled()) {
			PluginConfig pluginConfig = new PluginConfig();
			pluginConfig.setPluginId(discountPromotionPlugin.getId());
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
		if (discountPromotionPlugin.getIsInstalled()) {
			pluginConfigService.deleteByPluginId(discountPromotionPlugin.getId());
			promotionService.shutDownPromotion(Promotion.Type.discount);
		}
		return SUCCESS_MESSAGE;
	}

	/**
	 * 设置
	 */
	@GetMapping("/setting")
	public String setting(ModelMap model) {
		PluginConfig pluginConfig = discountPromotionPlugin.getPluginConfig();
		model.addAttribute("pluginConfig", pluginConfig);
		return "/net/shopxx/plugin/discountPromotion/setting";
	}

	/**
	 * 更新
	 */
	@PostMapping("/update")
	public String update(BigDecimal price, @RequestParam(defaultValue = "false") Boolean isEnabled, Integer order, RedirectAttributes redirectAttributes) {
		if (price == null || price.compareTo(BigDecimal.ZERO) < 0) {
			return ERROR_VIEW;
		}
		PluginConfig pluginConfig = discountPromotionPlugin.getPluginConfig();
		Map<String, String> attributes = new HashMap<>();
		pluginConfig.setAttributes(attributes);
		attributes.put(PromotionPlugin.PRICE, price.toString());
		pluginConfig.setIsEnabled(isEnabled);
		pluginConfig.setOrder(order);
		pluginConfigService.update(pluginConfig);
		if (!pluginConfig.getIsEnabled()) {
			promotionService.shutDownPromotion(Promotion.Type.discount);
		}
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:/admin/promotion_plugin/list";
	}

}