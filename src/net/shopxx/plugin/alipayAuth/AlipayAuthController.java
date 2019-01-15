package net.shopxx.plugin.alipayAuth;

import net.shopxx.Message;
import net.shopxx.controller.admin.BaseController;
import net.shopxx.entity.PluginConfig;
import net.shopxx.plugin.LoginPlugin;
import net.shopxx.plugin.PaymentPlugin;
import net.shopxx.service.PluginConfigService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.inject.Inject;
import java.util.HashMap;
import java.util.Map;

/**
 * Controller支付宝授权2.0接口
 * 
 * @author young
 * @version 2.0
 */
@Controller("adminAlipayAuthController")
@RequestMapping("/admin/login_plugin/alipay_auth")
public class AlipayAuthController extends BaseController {

	@Inject
	private AlipayAuthPlugin alipayAuthPlugin;
	@Inject
	private PluginConfigService pluginConfigService;

	/**
	 * 安装
	 */
	@PostMapping("/install")
	public @ResponseBody Message install() {
		if (!alipayAuthPlugin.getIsInstalled()) {
			PluginConfig pluginConfig = new PluginConfig();
			pluginConfig.setPluginId(alipayAuthPlugin.getId());
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
		if (alipayAuthPlugin.getIsInstalled()) {
			pluginConfigService.deleteByPluginId(alipayAuthPlugin.getId());
		}
		return SUCCESS_MESSAGE;
	}

	/**
	 * 设置
	 */
	@GetMapping("/setting")
	public String setting(ModelMap model) {
		PluginConfig pluginConfig = alipayAuthPlugin.getPluginConfig();
		model.addAttribute("pluginConfig", pluginConfig);
		return "/net/shopxx/plugin/alipayAuth/setting";
	}

	/**
	 * 更新
	 */
	@PostMapping("/update")
	public String update(String loginMethodName, String appId, String appPrivateKey, String alipayPublicKey,String logo, String description, @RequestParam(defaultValue = "false") Boolean isEnabled, Integer order, RedirectAttributes redirectAttributes) {
		PluginConfig pluginConfig = alipayAuthPlugin.getPluginConfig();
		Map<String, String> attributes = new HashMap<>();
		attributes.put(LoginPlugin.LOGIN_METHOD_NAME_ATTRIBUTE_NAME, loginMethodName);
		attributes.put("appId", appId);
		attributes.put("appPrivateKey", appPrivateKey);
		attributes.put("alipayPublicKey", alipayPublicKey);
		attributes.put(LoginPlugin.LOGO_ATTRIBUTE_NAME, logo);
		attributes.put(LoginPlugin.DESCRIPTION_ATTRIBUTE_NAME, description);
		pluginConfig.setAttributes(attributes);
		pluginConfig.setIsEnabled(isEnabled);
		pluginConfig.setOrder(order);
		pluginConfigService.update(pluginConfig);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:/admin/login_plugin/list";
	}

}