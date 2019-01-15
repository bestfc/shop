package net.shopxx.plugin.kdniaoExpress;

import net.shopxx.Message;
import net.shopxx.controller.admin.BaseController;
import net.shopxx.entity.PluginConfig;
import net.shopxx.plugin.ExpressPlugin;
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
 * Controller快递鸟查询接口
 *
 * @author young
 * @version 2.0
 */
@Controller("kdniaoController")
@RequestMapping("/admin/express_plugin/kdniao")
public class KdniaoController extends BaseController {


    @Inject
    private KdniaoTrackQuery kdniaoTrackQuery;
    @Inject
    private PluginConfigService pluginConfigService;

    /**
     * 安装
     */
    @PostMapping("/install")
    public @ResponseBody
    Message install() {
        if (!kdniaoTrackQuery.getIsInstalled()) {
            PluginConfig pluginConfig = new PluginConfig();
            pluginConfig.setPluginId(kdniaoTrackQuery.getId());
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
        if (kdniaoTrackQuery.getIsInstalled()) {
            pluginConfigService.deleteByPluginId(kdniaoTrackQuery.getId());
        }
        return SUCCESS_MESSAGE;
    }

    /**
     * 设置
     */
    @GetMapping("/setting")
    public String setting(ModelMap model) {
        PluginConfig pluginConfig = kdniaoTrackQuery.getPluginConfig();
        model.addAttribute("pluginConfig", pluginConfig);
        return "/net/shopxx/plugin/kdniaoExpress/setting";
    }

    /**
     * 更新
     */
    @PostMapping("/update")
    public String update(String expressapiName, String EBusinessID, String AppKey, String description, @RequestParam(defaultValue = "false") Boolean isEnabled, Integer order, RedirectAttributes redirectAttributes) {
        PluginConfig pluginConfig = kdniaoTrackQuery.getPluginConfig();
        Map<String, String> attributes = new HashMap<>();
        attributes.put(ExpressPlugin.EXPRESS_API_ATTRIBUTE_NAME,expressapiName);
        attributes.put("AppKey", AppKey);
        attributes.put("EBusinessID", EBusinessID);
        attributes.put("description", description);
        pluginConfig.setAttributes(attributes);
        pluginConfig.setIsEnabled(isEnabled);
        pluginConfig.setOrder(order);
        pluginConfigService.update(pluginConfig);
        addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
        return "redirect:/admin/express_plugin/list";
    }

}
