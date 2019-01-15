/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.plugin.abcPayment;

import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.security.PrivateKey;
import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;

import org.apache.commons.io.IOUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import net.shopxx.Message;
import net.shopxx.controller.admin.BaseController;
import net.shopxx.entity.PluginConfig;
import net.shopxx.plugin.PaymentPlugin;
import net.shopxx.service.PluginConfigService;
import net.shopxx.util.RSAUtils;

/**
 * Controller中国农业银行网上支付
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("adminAbcPaymentController")
@RequestMapping("/admin/payment_plugin/abc_payment")
public class AbcPaymentController extends BaseController {

	@Inject
	private AbcPaymentPlugin abcPaymentPlugin;
	@Inject
	private PluginConfigService pluginConfigService;

	/**
	 * 安装
	 */
	@PostMapping("/install")
	public @ResponseBody Message install() {
		if (!abcPaymentPlugin.getIsInstalled()) {
			PluginConfig pluginConfig = new PluginConfig();
			pluginConfig.setPluginId(abcPaymentPlugin.getId());
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
		if (abcPaymentPlugin.getIsInstalled()) {
			pluginConfigService.deleteByPluginId(abcPaymentPlugin.getId());
		}
		return SUCCESS_MESSAGE;
	}

	/**
	 * 设置
	 */
	@GetMapping("/setting")
	public String setting(ModelMap model) {
		PluginConfig pluginConfig = abcPaymentPlugin.getPluginConfig();
		model.addAttribute("feeTypes", PaymentPlugin.FeeType.values());
		model.addAttribute("pluginConfig", pluginConfig);
		return "/net/shopxx/plugin/abcPayment/setting";
	}

	/**
	 * 更新
	 */
	@PostMapping("/update")
	public String update(String paymentName, String merchantId, MultipartFile keyFile, String keyPassword, PaymentPlugin.FeeType feeType, BigDecimal fee, String logo, String description, @RequestParam(defaultValue = "false") Boolean isEnabled, Integer order, RedirectAttributes redirectAttributes) {
		PluginConfig pluginConfig = abcPaymentPlugin.getPluginConfig();
		Map<String, String> attributes = new HashMap<>();
		attributes.put(PaymentPlugin.PAYMENT_NAME_ATTRIBUTE_NAME, paymentName);
		attributes.put("merchantId", merchantId);
		if (keyFile != null && !keyFile.isEmpty()) {
			InputStream inputStream = null;
			try {
				inputStream = keyFile.getInputStream();
				PrivateKey privateKey = (PrivateKey) RSAUtils.getKey("PKCS12", inputStream, keyPassword);
				attributes.put("key", RSAUtils.getKeyString(privateKey));
			} catch (IOException e) {
				throw new RuntimeException(e.getMessage(), e);
			} catch (RuntimeException e) {
				addFlashMessage(redirectAttributes, Message.warn("admin.plugin.abcPayment.keyInvalid"));
				return "redirect:setting";
			} finally {
				IOUtils.closeQuietly(inputStream);
			}
		} else {
			attributes.put("key", pluginConfig.getAttribute("key"));
		}
		attributes.put(PaymentPlugin.FEE_TYPE_ATTRIBUTE_NAME, feeType.toString());
		attributes.put(PaymentPlugin.FEE_ATTRIBUTE_NAME, fee.toString());
		attributes.put(PaymentPlugin.LOGO_ATTRIBUTE_NAME, logo);
		attributes.put(PaymentPlugin.DESCRIPTION_ATTRIBUTE_NAME, description);
		pluginConfig.setAttributes(attributes);
		pluginConfig.setIsEnabled(isEnabled);
		pluginConfig.setOrder(order);
		pluginConfigService.update(pluginConfig);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:/admin/payment_plugin/list";
	}

}