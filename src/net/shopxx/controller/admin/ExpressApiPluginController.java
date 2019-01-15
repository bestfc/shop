package net.shopxx.controller.admin;

import net.shopxx.service.PluginService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.inject.Inject;

/**
 * Controller快递接口插件
 * 
 * @author young
 * @version 1.0
 */
@Controller("adminExpressApiPluginController")
@RequestMapping("/admin/express_plugin")
public class ExpressApiPluginController extends BaseController {

	@Inject
	private PluginService pluginService;

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(ModelMap model) {
		model.addAttribute("expressPlugins", pluginService.getExpressPlugins());
		return "admin/express_plugin/list";
	}

}