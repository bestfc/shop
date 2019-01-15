/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.shop;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * Controller首页
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("shopIndexController")
@RequestMapping("/")
public class IndexController extends BaseController {

	/**
	 * 首页
	 */
	@GetMapping
	public String index(ModelMap model) {
		return "shop/index";
	}

}