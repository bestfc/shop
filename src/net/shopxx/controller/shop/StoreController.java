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
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import net.shopxx.entity.Store;
import net.shopxx.exception.ResourceNotFoundException;
import net.shopxx.service.StoreProductCategoryService;
import net.shopxx.service.StoreProductTagService;
import net.shopxx.service.StoreService;

/**
 * Controller店铺
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("shopStoreController")
@RequestMapping("/store")
public class StoreController extends BaseController {

	@Inject
	private StoreService storeService;
	@Inject
	private StoreProductCategoryService storeProductCategoryService;
	@Inject
	private StoreProductTagService storeProductTagService;

	/**
	 * 首页
	 */
	@GetMapping("/{storeId}")
	public String index(@PathVariable Long storeId, ModelMap model) {
		Store store = storeService.find(storeId);
		if (store == null) {
			throw new ResourceNotFoundException();
		}
		model.addAttribute("store", store);
		model.addAttribute("storeProductCategoryTree", storeProductCategoryService.findTree(store));
		model.addAttribute("storeProductTags", storeProductTagService.findList(store, true));
		return "shop/store/index";
	}

}