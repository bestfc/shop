/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.shop;

import javax.inject.Inject;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import net.shopxx.entity.FriendLink;
import net.shopxx.service.FriendLinkService;

/**
 * Controller友情链接
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("shopFriendLinkController")
@RequestMapping("/friend_link")
public class FriendLinkController extends BaseController {

	@Inject
	private FriendLinkService friendLinkService;

	/**
	 * 首页
	 */
	@GetMapping
	public String index(ModelMap model) {
		model.addAttribute("textFriendLinks", friendLinkService.findList(FriendLink.Type.text));
		model.addAttribute("imageFriendLinks", friendLinkService.findList(FriendLink.Type.image));
		return "shop/friend_link/index";
	}

}