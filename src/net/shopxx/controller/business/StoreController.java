/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.business;

import java.math.BigDecimal;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import net.shopxx.Results;
import net.shopxx.entity.BaseEntity;
import net.shopxx.entity.Business;
import net.shopxx.entity.PlatformSvc;
import net.shopxx.entity.Store;
import net.shopxx.entity.StoreRank;
import net.shopxx.plugin.PaymentPlugin;
import net.shopxx.security.CurrentStore;
import net.shopxx.security.CurrentUser;
import net.shopxx.service.PluginService;
import net.shopxx.service.ProductCategoryService;
import net.shopxx.service.StoreCategoryService;
import net.shopxx.service.StoreRankService;
import net.shopxx.service.StoreService;
import net.shopxx.service.SvcService;
import net.shopxx.util.WebUtils;

/**
 * Controller店铺
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("businessStoreController")
@RequestMapping("/business/store")
public class StoreController extends BaseController {

	@Inject
	private StoreService storeService;
	@Inject
	private StoreRankService storeRankService;
	@Inject
	private StoreCategoryService storeCategoryService;
	@Inject
	private ProductCategoryService productCategoryService;
	@Inject
	private PluginService pluginService;
	@Inject
	private SvcService svcService;

	/**
	 * 检查名称是否唯一
	 */
	@GetMapping("/check_name")
	public @ResponseBody boolean checkName(String name, Store store) {
		return StringUtils.isNotEmpty(name) && storeService.nameUnique(store.getId(), name);
	}

	/**
	 * 店铺状态
	 */
	@GetMapping("/store_status")
	public @ResponseBody Map<String, Object> storeStatus(@CurrentStore Store currentStore) {
		Map<String, Object> data = new HashMap<>();
		data.put("status", currentStore.getStatus());
		return data;
	}

	/**
	 * 到期日期
	 */
	@GetMapping("/end_date")
	public @ResponseBody Map<String, Object> endDate(@CurrentStore Store currentStore) {
		Map<String, Object> data = new HashMap<>();
		data.put("endDate", currentStore.getEndDate());
		return data;
	}

	/**
	 * 计算
	 */
	@GetMapping("/calculate")
	public ResponseEntity<?> calculate(String paymentPluginId, Integer years, @CurrentStore Store currentStore) {
		Map<String, Object> data = new HashMap<>();
		PaymentPlugin paymentPlugin = pluginService.getPaymentPlugin(paymentPluginId);
		if (paymentPlugin == null || !paymentPlugin.getIsEnabled()) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (years == null || years < 0) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		BigDecimal amount = currentStore.getStoreRank().getServiceFee().multiply(new BigDecimal(years));
		if (Store.Status.approved.equals(currentStore.getStatus())) {
			amount = amount.add(currentStore.getBailPayable());
		}
		data.put("fee", paymentPlugin.calculateFee(amount));
		data.put("amount", paymentPlugin.calculateAmount(amount));
		return ResponseEntity.ok(data);
	}

	/**
	 * 申请
	 */
	@GetMapping("/register")
	public String register(@CurrentStore Store currentStore, ModelMap model) {
		if (currentStore != null) {
			return "redirect:/business/index";
		}

		model.addAttribute("storeRanks", storeRankService.findList(true, null, null));
		model.addAttribute("storeCategories", storeCategoryService.findAll());
		model.addAttribute("productCategoryTree", productCategoryService.findTree());
		return "business/store/register";
	}

	/**
	 * 申请
	 */
	@PostMapping("/register")
	public ResponseEntity<?> register(String name, String email, String mobile, Long storeRankId, Long storeCategoryId, Long[] productCategoryIds, @CurrentUser Business currentUser) {
		if (currentUser == null) {
			return Results.unprocessableEntity("common.message.unauthorized");
		}
		if (storeService.nameExists(name)) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		StoreRank storeRank = storeRankService.find(storeRankId);
		if (!storeRank.getIsAllowRegister()) {
			return Results.UNPROCESSABLE_ENTITY;
		}

		Store store = new Store();
		store.setName(name);
		store.setType(Store.Type.general);
		store.setStatus(Store.Status.pending);
		store.setEmail(email);
		store.setMobile(mobile);
		store.setEndDate(new Date());
		store.setIsEnabled(true);
		store.setBailPaid(BigDecimal.ZERO);
		store.setBusiness(currentUser);
		store.setStoreRank(storeRank);
		store.setStoreCategory(storeCategoryService.find(storeCategoryId));
		store.setProductCategories(new HashSet<>(productCategoryService.findList(productCategoryIds)));
		if (!isValid(store, BaseEntity.Save.class)) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		storeService.save(store);
		return Results.OK;
	}

	/**
	 * 重新申请
	 */
	@GetMapping("/reapply")
	public String reapply(@CurrentStore Store currentStore, ModelMap model) {
		if (currentStore == null) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (!Store.Status.failed.equals(currentStore.getStatus())) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}

		model.addAttribute("storeRanks", storeRankService.findList(true, null, null));
		model.addAttribute("storeCategories", storeCategoryService.findAll());
		model.addAttribute("productCategoryTree", productCategoryService.findTree());
		return "business/store/reapply";
	}

	/**
	 * 重新申请
	 */
	@PostMapping("/reapply")
	public ResponseEntity<?> reapply(String name, String email, String mobile, Long storeRankId, Long storeCategoryId, Long[] productCategoryIds, @CurrentStore Store currentStore) {
		if (currentStore == null) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (!Store.Status.failed.equals(currentStore.getStatus())) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		StoreRank storeRank = storeRankService.find(storeRankId);
		if (!storeRank.getIsAllowRegister()) {
			return Results.UNPROCESSABLE_ENTITY;
		}

		currentStore.setName(name);
		currentStore.setStatus(Store.Status.pending);
		currentStore.setEmail(email);
		currentStore.setMobile(mobile);
		currentStore.setStoreRank(storeRank);
		currentStore.setStoreCategory(storeCategoryService.find(storeCategoryId));
		currentStore.setProductCategories(new HashSet<>(productCategoryService.findList(productCategoryIds)));
		if (!isValid(currentStore, BaseEntity.Update.class)) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		storeService.update(currentStore);
		return Results.OK;
	}

	/**
	 * 缴费
	 */
	@GetMapping("/payment")
	public String payment(@CurrentStore Store currentStore, ModelMap model) {
		if (currentStore == null) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (!Store.Status.approved.equals(currentStore.getStatus()) && !Store.Status.success.equals(currentStore.getStatus())) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}

		List<PaymentPlugin> paymentPlugins = pluginService.getActivePaymentPlugins(WebUtils.getRequest());
		if (CollectionUtils.isNotEmpty(paymentPlugins)) {
			model.addAttribute("defaultPaymentPlugin", paymentPlugins.get(0));
			model.addAttribute("paymentPlugins", paymentPlugins);
		}
		return "business/store/payment";
	}

	/**
	 * 缴费
	 */
	@PostMapping("/payment")
	public ResponseEntity<?> payment(Integer years, @CurrentStore Store currentStore) {
		Map<String, Object> data = new HashMap<>();
		if (years == null || years < 0) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (!Store.Status.approved.equals(currentStore.getStatus()) && !Store.Status.success.equals(currentStore.getStatus())) {
			return Results.UNPROCESSABLE_ENTITY;
		}

		int days = years * 365;
		BigDecimal serviceFee = currentStore.getStoreRank().getServiceFee().multiply(new BigDecimal(years));
		BigDecimal bail = Store.Status.approved.equals(currentStore.getStatus()) ? currentStore.getBailPayable() : BigDecimal.ZERO;
		if (serviceFee.compareTo(BigDecimal.ZERO) > 0) {
			PlatformSvc platformSvc = new PlatformSvc();
			platformSvc.setAmount(serviceFee);
			platformSvc.setDurationDays(days);
			platformSvc.setStore(currentStore);
			platformSvc.setPaymentTransactions(null);
			svcService.save(platformSvc);

			data.put("platformSvcSn", platformSvc.getSn());
		} else {
			storeService.addEndDays(currentStore, days);
			if (bail.compareTo(BigDecimal.ZERO) <= 0) {
				currentStore.setStatus(Store.Status.success);
				storeService.update(currentStore);
			}
		}

		if (bail.compareTo(BigDecimal.ZERO) > 0) {
			data.put("bail", bail);
		}
		return ResponseEntity.ok(data);
	}

	/**
	 * 设置
	 */
	@GetMapping("/setting")
	public String setting() {
		return "business/store/setting";
	}

	/**
	 * 设置
	 */
	@PostMapping("/setting")
	public String setting(Store store, @CurrentStore Store currentStore, RedirectAttributes redirectAttributes) {
		if (store == null) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (!storeService.nameUnique(currentStore.getId(), store.getName())) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		currentStore.setName(store.getName());
		currentStore.setLogo(store.getLogo());
		currentStore.setEmail(store.getEmail());
		currentStore.setMobile(store.getMobile());
		currentStore.setPhone(store.getPhone());
		currentStore.setAddress(store.getAddress());
		currentStore.setZipCode(store.getZipCode());
		currentStore.setIntroduction(store.getIntroduction());
		currentStore.setKeyword(store.getKeyword());
		if (!isValid(currentStore, BaseEntity.Update.class)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		storeService.update(currentStore);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:setting";
	}

}