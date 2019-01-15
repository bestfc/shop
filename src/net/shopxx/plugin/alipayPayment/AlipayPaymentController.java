package net.shopxx.plugin.alipayPayment;

import net.shopxx.Message;
import net.shopxx.controller.admin.BaseController;
import net.shopxx.entity.PluginConfig;
import net.shopxx.plugin.PaymentPlugin;
import net.shopxx.service.PluginConfigService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.inject.Inject;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

/**
 * Controller支付宝支付
 */
@Controller("adminAlipayPaymentController")
@RequestMapping("/admin/payment_plugin/alipay_payment")
public class AlipayPaymentController extends BaseController {
    @Inject
    private AlipayPaymentPlugin alipayPaymentPlugin;
    @Inject
    private PluginConfigService pluginConfigService;
    /**
     * 安装
     */
    @PostMapping("/install")
    public @ResponseBody Message install() {
        if (!alipayPaymentPlugin.getIsInstalled()) {
            PluginConfig pluginConfig = new PluginConfig();
            pluginConfig.setPluginId(alipayPaymentPlugin.getId());
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
    public @ResponseBody
    Message uninstall() {
        if (alipayPaymentPlugin.getIsInstalled()) {
            pluginConfigService.deleteByPluginId(alipayPaymentPlugin.getId());
        }
        return SUCCESS_MESSAGE;
    }

    /**
     * 设置
     */
    @GetMapping("/setting")
    public String setting(ModelMap model) {
        PluginConfig pluginConfig = alipayPaymentPlugin.getPluginConfig();
        model.addAttribute("feeTypes", PaymentPlugin.FeeType.values());
        model.addAttribute("pluginConfig", pluginConfig);
        return "/net/shopxx/plugin/alipayPayment/setting";
    }

    /**
     * 更新
     */
    @PostMapping("/update")
    public String update(String paymentName, String appId, String appPrivateKey, String alipayPublicKey, PaymentPlugin.FeeType feeType, BigDecimal fee, String logo, String description, @RequestParam(defaultValue = "false") Boolean isEnabled, Integer order, RedirectAttributes redirectAttributes) {
        PluginConfig pluginConfig = alipayPaymentPlugin.getPluginConfig();
        Map<String, String> attributes = new HashMap<>();
        attributes.put(PaymentPlugin.PAYMENT_NAME_ATTRIBUTE_NAME, paymentName);
        attributes.put("appId", appId);
        attributes.put("appPrivateKey", appPrivateKey);
        attributes.put("alipayPublicKey", alipayPublicKey);
        attributes.put(PaymentPlugin.FEE_TYPE_ATTRIBUTE_NAME, String.valueOf(feeType));
        attributes.put(PaymentPlugin.FEE_ATTRIBUTE_NAME, String.valueOf(fee));
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
