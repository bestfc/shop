/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.business;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.inject.Inject;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.Predicate;
import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import net.shopxx.Pageable;
import net.shopxx.Results;
import net.shopxx.entity.Business;
import net.shopxx.entity.Product;
import net.shopxx.entity.Promotion;
import net.shopxx.entity.PromotionPluginSvc;
import net.shopxx.entity.Sku;
import net.shopxx.entity.Store;
import net.shopxx.exception.UnauthorizedException;
import net.shopxx.plugin.PaymentPlugin;
import net.shopxx.plugin.PromotionPlugin;
import net.shopxx.plugin.discountPromotion.DiscountPromotionPlugin;
import net.shopxx.security.CurrentStore;
import net.shopxx.security.CurrentUser;
import net.shopxx.service.CouponService;
import net.shopxx.service.MemberRankService;
import net.shopxx.service.PluginService;
import net.shopxx.service.PromotionService;
import net.shopxx.service.SkuService;
import net.shopxx.service.StoreService;
import net.shopxx.service.SvcService;
import net.shopxx.util.WebUtils;

/**
 * Controller折扣促销
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("businessDiscountPromotionController")
@RequestMapping("/business/discount_promotion")
public class DiscountPromotionController extends BaseController {

	@Inject
	private PromotionService promotionService;
	@Inject
	private MemberRankService memberRankService;
	@Inject
	private SkuService skuService;
	@Inject
	private CouponService couponService;
	@Inject
	private StoreService storeService;
	@Inject
	private PluginService pluginService;
	@Inject
	private SvcService svcService;

	/**
	 * 添加属性
	 */
	@ModelAttribute
	public void populateModel(Long promotionId, @CurrentStore Store currentStore, ModelMap model) {
		Promotion promotion = promotionService.find(promotionId);
		if (promotion != null && !currentStore.equals(promotion.getStore())) {
			throw new UnauthorizedException();
		}
		model.addAttribute("promotion", promotion);
	}

	/**
	 * 计算
	 */
	@GetMapping("/calculate")
	public ResponseEntity<?> calculate(String paymentPluginId, Integer months, Boolean useBalance) {
		Map<String, Object> data = new HashMap<>();
		PromotionPlugin promotionPlugin = pluginService.getPromotionPlugin(DiscountPromotionPlugin.ID);
		if (promotionPlugin == null || !promotionPlugin.getIsEnabled()) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (months == null || months <= 0) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		BigDecimal amount = promotionPlugin.getPrice().multiply(new BigDecimal(months));
		if (BooleanUtils.isTrue(useBalance)) {
			data.put("fee", BigDecimal.ZERO);
			data.put("amount", amount);
			data.put("useBalance", true);
		} else {
			PaymentPlugin paymentPlugin = pluginService.getPaymentPlugin(paymentPluginId);
			if (paymentPlugin == null || !paymentPlugin.getIsEnabled()) {
				return Results.UNPROCESSABLE_ENTITY;
			}
			data.put("fee", paymentPlugin.calculateFee(amount));
			data.put("amount", paymentPlugin.calculateAmount(amount));
			data.put("useBalance", false);
		}
		return ResponseEntity.ok(data);
	}

	/**
	 * 到期日期
	 */
	@GetMapping("/end_date")
	public @ResponseBody Map<String, Object> endDate(@CurrentStore Store currentStore) {
		Map<String, Object> data = new HashMap<>();
		data.put("endDate", currentStore.getDiscountPromotionEndDate());
		return data;
	}

	/**
	 * 购买
	 */
	@GetMapping("/buy")
	public String buy(@CurrentStore Store currentStore, ModelMap model) {
		PromotionPlugin promotionPlugin = pluginService.getPromotionPlugin(DiscountPromotionPlugin.ID);
		if (currentStore.getType().equals(Store.Type.self) && currentStore.getDiscountPromotionEndDate() == null) {
			return "redirect:list";
		}
		if (promotionPlugin == null || !promotionPlugin.getIsEnabled()) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		List<PaymentPlugin> paymentPlugins = pluginService.getActivePaymentPlugins(WebUtils.getRequest());
		if (CollectionUtils.isNotEmpty(paymentPlugins)) {
			model.addAttribute("defaultPaymentPlugin", paymentPlugins.get(0));
			model.addAttribute("paymentPlugins", paymentPlugins);
		}
		model.addAttribute("promotionPlugin", promotionPlugin);
		return "business/discount_promotion/buy";
	}

	/**
	 * 购买
	 */
	@PostMapping("/buy")
	public ResponseEntity<?> buy(Integer months, Boolean useBalance, @CurrentStore Store currentStore, @CurrentUser Business currentUser) {
		Map<String, Object> data = new HashMap<>();
		PromotionPlugin promotionPlugin = pluginService.getPromotionPlugin(DiscountPromotionPlugin.ID);
		if (currentStore.getType().equals(Store.Type.self) && currentStore.getDiscountPromotionEndDate() == null) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (promotionPlugin == null || !promotionPlugin.getIsEnabled()) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (months == null || months <= 0) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		int days = months * 30;
		BigDecimal amount = promotionPlugin.getPrice().multiply(new BigDecimal(months));
		if (amount.compareTo(BigDecimal.ZERO) > 0) {
			if (BooleanUtils.isTrue(useBalance)) {
				if (currentUser.getBalance().compareTo(amount) < 0) {
					return Results.unprocessableEntity("business.discountPromotion.insufficientBalance");
				}
				storeService.buy(currentStore, promotionPlugin, months);
			} else {
				PromotionPluginSvc promotionPluginSvc = new PromotionPluginSvc();
				promotionPluginSvc.setAmount(amount);
				promotionPluginSvc.setDurationDays(days);
				promotionPluginSvc.setStore(currentStore);
				promotionPluginSvc.setPromotionPluginId(DiscountPromotionPlugin.ID);
				svcService.save(promotionPluginSvc);
				data.put("promotionPluginSvcSn", promotionPluginSvc.getSn());
			}
		} else {
			storeService.addDiscountPromotionEndDays(currentStore, days);
		}
		return ResponseEntity.ok(data);
	}

	/**
	 * 赠品选择
	 */
	@GetMapping("/gift_select")
	public @ResponseBody List<Map<String, Object>> giftSelect(String keyword, Long[] excludeIds, @CurrentUser Business currentUser) {
		List<Map<String, Object>> data = new ArrayList<>();
		if (StringUtils.isEmpty(keyword)) {
			return data;
		}
		Set<Sku> excludes = new HashSet<>(skuService.findList(excludeIds));
		List<Sku> skus = skuService.search(currentUser.getStore(), Product.Type.gift, keyword, excludes, null);
		for (Sku sku : skus) {
			Map<String, Object> item = new HashMap<>();
			item.put("id", sku.getId());
			item.put("sn", sku.getSn());
			item.put("name", sku.getName());
			item.put("specifications", sku.getSpecifications());
			item.put("path", sku.getPath());
			data.add(item);
		}
		return data;
	}

	/**
	 * 添加
	 */
	@GetMapping("/add")
	public String add(@CurrentStore Store currentStore, ModelMap model) {
		model.addAttribute("memberRanks", memberRankService.findAll());
		model.addAttribute("coupons", couponService.findList(currentStore));
		return "business/discount_promotion/add";
	}

	/**
	 * 保存
	 */
	@PostMapping("/save")
	public String save(@ModelAttribute("promotionForm") Promotion promotionForm, Boolean useAmountPromotion, Boolean useNumberPromotion, Long[] memberRankIds, Long[] couponIds, Long[] giftIds, @CurrentStore Store currentStore, RedirectAttributes redirectAttributes) {
		promotionForm.setType(Promotion.Type.discount);
		promotionForm.setStore(currentStore);
		promotionForm.setMemberRanks(new HashSet<>(memberRankService.findList(memberRankIds)));
		promotionForm.setCoupons(new HashSet<>(couponService.findList(couponIds)));
		if (ArrayUtils.isNotEmpty(giftIds)) {
			List<Sku> gifts = skuService.findList(giftIds);
			CollectionUtils.filter(gifts, new Predicate() {
				public boolean evaluate(Object object) {
					Sku gift = (Sku) object;
					return gift != null && Product.Type.gift.equals(gift.getType());
				}
			});
			promotionForm.setGifts(new HashSet<>(gifts));
		} else {
			promotionForm.setGifts(null);
		}
		if (!isValid(promotionForm)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (promotionForm.getBeginDate() != null && promotionForm.getEndDate() != null && promotionForm.getBeginDate().after(promotionForm.getEndDate())) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (promotionForm.getMinimumQuantity() != null && promotionForm.getMaximumQuantity() != null && promotionForm.getMinimumQuantity() > promotionForm.getMaximumQuantity()) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (promotionForm.getMinimumPrice() != null && promotionForm.getMaximumPrice() != null && promotionForm.getMinimumPrice().compareTo(promotionForm.getMaximumPrice()) > 0) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		PromotionPlugin promotionPlugin = pluginService.getPromotionPlugin(DiscountPromotionPlugin.ID);
		String priceExpression = promotionPlugin.getPriceExpression(promotionForm, useAmountPromotion, useNumberPromotion);
		if (StringUtils.isNotEmpty(priceExpression) && !promotionService.isValidPriceExpression(priceExpression)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		promotionForm.setPriceExpression(priceExpression);
		promotionForm.setProducts(null);
		promotionForm.setProductCategories(null);
		promotionService.save(promotionForm);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 编辑
	 */
	@GetMapping("/edit")
	public String edit(@ModelAttribute(binding = false) Promotion promotion, @CurrentStore Store currentStore, ModelMap model) {
		if (promotion == null) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}

		model.addAttribute("promotion", promotion);
		model.addAttribute("memberRanks", memberRankService.findAll());
		model.addAttribute("coupons", couponService.findList(currentStore));
		return "business/discount_promotion/edit";
	}

	/**
	 * 更新
	 */
	@PostMapping("/update")
	public String update(@ModelAttribute("promotionForm") Promotion promotionForm, @ModelAttribute(binding = false) Promotion promotion, Boolean useAmountPromotion, Boolean useNumberPromotion, Long[] memberRankIds, Long[] couponIds, Long[] giftIds, @CurrentStore Store currentStore,
			RedirectAttributes redirectAttributes) {
		if (promotion == null) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}

		promotionForm.setMemberRanks(new HashSet<>(memberRankService.findList(memberRankIds)));
		promotionForm.setCoupons(new HashSet<>(couponService.findList(couponIds)));
		if (ArrayUtils.isNotEmpty(giftIds)) {
			List<Sku> gifts = skuService.findList(giftIds);
			CollectionUtils.filter(gifts, new Predicate() {
				public boolean evaluate(Object object) {
					Sku gift = (Sku) object;
					return gift != null && Product.Type.gift.equals(gift.getType());
				}
			});
			promotionForm.setGifts(new HashSet<>(gifts));
		} else {
			promotionForm.setGifts(null);
		}
		if (promotionForm.getBeginDate() != null && promotionForm.getEndDate() != null && promotionForm.getBeginDate().after(promotionForm.getEndDate())) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (promotionForm.getMinimumQuantity() != null && promotionForm.getMaximumQuantity() != null && promotionForm.getMinimumQuantity() > promotionForm.getMaximumQuantity()) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (promotionForm.getMinimumPrice() != null && promotionForm.getMaximumPrice() != null && promotionForm.getMinimumPrice().compareTo(promotionForm.getMaximumPrice()) > 0) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}

		PromotionPlugin promotionPlugin = pluginService.getPromotionPlugin(DiscountPromotionPlugin.ID);
		String priceExpression = promotionPlugin.getPriceExpression(promotionForm, useAmountPromotion, useNumberPromotion);
		if (StringUtils.isNotEmpty(priceExpression) && !promotionService.isValidPriceExpression(priceExpression)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (useAmountPromotion != null && useAmountPromotion) {
			promotionForm.setConditionsNumber(null);
			promotionForm.setCreditNumber(null);
		} else if (useNumberPromotion != null && useNumberPromotion) {
			promotionForm.setConditionsAmount(null);
			promotionForm.setCreditAmount(null);
		} else {
			promotionForm.setConditionsNumber(null);
			promotionForm.setCreditNumber(null);
			promotionForm.setConditionsAmount(null);
			promotionForm.setCreditAmount(null);
		}
		promotionForm.setPriceExpression(priceExpression);

		BeanUtils.copyProperties(promotionForm, promotion, "id", "type", "store", "product", "productCategories");
		promotionService.update(promotion);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Pageable pageable, @CurrentStore Store currentStore, ModelMap model) {
		PromotionPlugin promotionPlugin = pluginService.getPromotionPlugin(DiscountPromotionPlugin.ID);
		model.addAttribute("isEnabled", promotionPlugin.getIsEnabled());
		model.addAttribute("page", promotionService.findPage(currentStore, Promotion.Type.discount, pageable));
		return "business/discount_promotion/list";
	}

	/**
	 * 删除
	 */
	@PostMapping("/delete")
	public ResponseEntity<?> delete(Long[] ids, @CurrentStore Store currentStore) {
		for (Long id : ids) {
			Promotion promotion = promotionService.find(id);
			if (promotion == null) {
				return Results.UNPROCESSABLE_ENTITY;
			}
			if (!currentStore.equals(promotion.getStore())) {
				return Results.UNPROCESSABLE_ENTITY;
			}
		}
		promotionService.delete(ids);
		return Results.OK;
	}

}