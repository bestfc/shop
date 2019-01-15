/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.admin;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
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
import net.shopxx.Pageable;
import net.shopxx.entity.BaseEntity;
import net.shopxx.entity.Business;
import net.shopxx.entity.Store;
import net.shopxx.service.BusinessService;
import net.shopxx.service.ProductCategoryService;
import net.shopxx.service.StoreCategoryService;
import net.shopxx.service.StoreRankService;
import net.shopxx.service.StoreService;

/**
 * Controller店铺
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("adminStoreController")
@RequestMapping("/admin/store")
public class StoreController extends BaseController {

	@Inject
	private StoreService storeService;
	@Inject
	private BusinessService businessService;
	@Inject
	private StoreRankService storeRankService;
	@Inject
	private StoreCategoryService storeCategoryService;
	@Inject
	private ProductCategoryService productCategoryService;

	/**
	 * 检查名称是否唯一
	 */
	@GetMapping("/check_name")
	public @ResponseBody boolean checkName(Long id, String name) {
		return StringUtils.isNotEmpty(name) && storeService.nameUnique(id, name);
	}

	/**
	 * 商家选择
	 */
	@GetMapping("/business_select")
	public @ResponseBody List<Map<String, Object>> businessSelect(@RequestParam("q") String keyword, @RequestParam("limit") Integer count) {
		List<Map<String, Object>> data = new ArrayList<>();
		if (StringUtils.isEmpty(keyword)) {
			return data;
		}
		List<Business> businesses = businessService.search(keyword, count);
		for (Business businesse : businesses) {
			if (businesse.getStore() == null) {
				Map<String, Object> item = new HashMap<String, Object>();
				item.put("id", businesse.getId());
				item.put("username", businesse.getUsername());
				data.add(item);
			}
		}
		return data;
	}

	/**
	 * 查看
	 */
	@GetMapping("/view")
	public String view(Long id, ModelMap model) {
		model.addAttribute("store", storeService.find(id));
		model.addAttribute("productCategoryTree", productCategoryService.findTree());
		return "admin/store/view";
	}

	/**
	 * 添加
	 */
	@GetMapping("/add")
	public String add(ModelMap model) {
		model.addAttribute("types", Store.Type.values());
		model.addAttribute("storeRanks", storeRankService.findAll());
		model.addAttribute("storeCategories", storeCategoryService.findAll());
		model.addAttribute("productCategoryTree", productCategoryService.findTree());
		return "admin/store/add";
	}

	/**
	 * 保存
	 */
	@PostMapping("/save")
	public String save(Store store, Long businessId, Long storeRankId, Long storeCategoryId, Long[] productCategoryIds, RedirectAttributes redirectAttributes) {
		store.setBusiness(businessService.find(businessId));
		store.setStoreRank(storeRankService.find(storeRankId));
		store.setStoreCategory(storeCategoryService.find(storeCategoryId));
		store.setProductCategories(new HashSet<>(productCategoryService.findList(productCategoryIds)));
		store.setStatus(Store.Status.pending);
		store.setEndDate(new Date());
		store.setDiscountPromotionEndDate(null);
		store.setFullReductionPromotionEndDate(null);
		store.setBailPaid(BigDecimal.ZERO);
		store.setStoreAdImages(null);
		store.setInstantMessages(null);
		store.setStoreProductCategories(null);
		store.setCategoryApplications(null);
		store.setStoreProductTags(null);
		store.setProducts(null);
		store.setPromotions(null);
		store.setCoupons(null);
		store.setOrders(null);
		store.setStoreFavorites(null);
		store.setDeliveryTemplates(null);
		store.setDeliveryCenters(null);
		store.setDefaultFreightConfigs(null);
		store.setAreaFreightConfigs(null);
		store.setSvcs(null);
		store.setPaymentTransactions(null);
		store.setConsultations(null);
		store.setReviews(null);
		store.setStatistics(null);
		if (storeService.nameExists(store.getName())) {
			return ERROR_VIEW;
		}
		if (!isValid(store, BaseEntity.Save.class)) {
			return ERROR_VIEW;
		}
		storeService.save(store);
		storeService.review(store, true, null);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 编辑
	 */
	@GetMapping("/edit")
	public String edit(Long id, ModelMap model) {
		model.addAttribute("store", storeService.find(id));
		model.addAttribute("types", Store.Type.values());
		model.addAttribute("storeRanks", storeRankService.findAll());
		model.addAttribute("storeCategories", storeCategoryService.findAll());
		model.addAttribute("productCategoryTree", productCategoryService.findTree());
		return "admin/store/edit";
	}

	/**
	 * 更新
	 */
	@PostMapping("/update")
	public String update(Store store, Long id, Long storeRankId, Long storeCategoryId, Long[] productCategoryIds, RedirectAttributes redirectAttributes) {
		if (!storeService.nameUnique(id, store.getName())) {
			return ERROR_VIEW;
		}
		Store pStore = storeService.find(id);
		pStore.setName(store.getName());
		pStore.setLogo(store.getLogo());
		pStore.setEmail(store.getEmail());
		pStore.setMobile(store.getMobile());
		pStore.setPhone(store.getPhone());
		pStore.setAddress(store.getAddress());
		pStore.setZipCode(store.getZipCode());
		pStore.setIntroduction(store.getIntroduction());
		pStore.setKeyword(store.getKeyword());
		pStore.setEndDate(store.getEndDate());
		pStore.setIsEnabled(store.getIsEnabled());
		pStore.setStoreRank(storeRankService.find(storeRankId));
		pStore.setStoreCategory(storeCategoryService.find(storeCategoryId));
		pStore.setProductCategories(new HashSet<>(productCategoryService.findList(productCategoryIds)));
		if (!isValid(pStore, BaseEntity.Update.class)) {
			return ERROR_VIEW;
		}
		storeService.update(pStore);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Store.Type type, Store.Status status, Boolean isEnabled, Boolean hasExpired, Pageable pageable, ModelMap model) {
		model.addAttribute("type", type);
		model.addAttribute("status", status);
		model.addAttribute("isEnabled", isEnabled);
		model.addAttribute("hasExpired", hasExpired);
		model.addAttribute("page", storeService.findPage(type, status, isEnabled, hasExpired, pageable));
		return "admin/store/list";
	}

	/**
	 * 删除
	 */
	@PostMapping("/delete")
	public @ResponseBody Message delete(Long[] ids) {
		if (ids != null) {
			for (Long id : ids) {
				Store store = storeService.find(id);
				if (store != null && Store.Status.success.equals(store.getStatus())) {
					return Message.error("admin.store.deleteSuccessNotAllowed", store.getName());
				}
			}
			storeService.delete(ids);
		}
		return SUCCESS_MESSAGE;
	}

	/**
	 * 审核
	 */
	@GetMapping("/review")
	public String review(Long id, ModelMap model) {
		model.addAttribute("store", storeService.find(id));
		model.addAttribute("productCategoryTree", productCategoryService.findTree());
		return "admin/store/review";
	}

	/**
	 * 审核
	 */
	@PostMapping("/review")
	public String review(Long id, Boolean passed, String content, RedirectAttributes redirectAttributes) {
		Store store = storeService.find(id);
		if (store == null || !Store.Status.pending.equals(store.getStatus()) || passed == null || (!passed && StringUtils.isEmpty(content))) {
			return ERROR_VIEW;
		}
		storeService.review(store, passed, content);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

}