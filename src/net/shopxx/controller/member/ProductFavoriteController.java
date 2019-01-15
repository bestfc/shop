/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.member;

import javax.inject.Inject;

import org.apache.commons.lang.BooleanUtils;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.fasterxml.jackson.annotation.JsonView;

import net.shopxx.Pageable;
import net.shopxx.Results;
import net.shopxx.entity.BaseEntity;
import net.shopxx.entity.Member;
import net.shopxx.entity.Product;
import net.shopxx.entity.ProductFavorite;
import net.shopxx.exception.UnauthorizedException;
import net.shopxx.security.CurrentUser;
import net.shopxx.service.ProductFavoriteService;
import net.shopxx.service.ProductService;

/**
 * Controller商品收藏
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("memberProductFavoriteController")
@RequestMapping("/member/product_favorite")
public class ProductFavoriteController extends BaseController {

	/**
	 * 每页记录数
	 */
	private static final int PAGE_SIZE = 10;

	@Inject
	private ProductFavoriteService productFavoriteService;
	@Inject
	private ProductService productService;

	/**
	 * 添加属性
	 */
	@ModelAttribute
	public void populateModel(Long productId, Long productFavoriteId, @CurrentUser Member currentUser, ModelMap model) {
		model.addAttribute("product", productService.find(productId));

		ProductFavorite productFavorite = productFavoriteService.find(productFavoriteId);
		if (productFavorite != null && !currentUser.equals(productFavorite.getMember())) {
			throw new UnauthorizedException();
		}
		model.addAttribute("productFavorite", productFavorite);
	}

	/**
	 * 添加
	 */
	@PostMapping("/add")
	public ResponseEntity<?> add(@ModelAttribute(binding = false) Product product, @CurrentUser Member currentUser) {
		if (product == null || BooleanUtils.isNotTrue(product.getIsActive())) {
			return Results.NOT_FOUND;
		}
		if (productFavoriteService.exists(currentUser, product)) {
			return Results.unprocessableEntity("member.productFavorite.exist");
		}
		if (BooleanUtils.isNotTrue(product.getIsMarketable())) {
			return Results.unprocessableEntity("member.productFavorite.notMarketable");
		}
		if (ProductFavorite.MAX_PRODUCT_FAVORITE_SIZE != null && productFavoriteService.count(currentUser) >= ProductFavorite.MAX_PRODUCT_FAVORITE_SIZE) {
			return Results.unprocessableEntity("member.productFavorite.addCountNotAllowed", ProductFavorite.MAX_PRODUCT_FAVORITE_SIZE);
		}
		ProductFavorite productFavorite = new ProductFavorite();
		productFavorite.setMember(currentUser);
		productFavorite.setProduct(product);
		productFavoriteService.save(productFavorite);
		return Results.OK;
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Integer pageNumber, @CurrentUser Member currentUser, ModelMap model) {
		Pageable pageable = new Pageable(pageNumber, PAGE_SIZE);
		model.addAttribute("page", productFavoriteService.findPage(currentUser, pageable));
		return "member/product_favorite/list";
	}

	/**
	 * 列表
	 */
	@GetMapping(path = "/list", produces = MediaType.APPLICATION_JSON_VALUE)
	@JsonView(BaseEntity.BaseView.class)
	public ResponseEntity<?> list(Integer pageNumber, @CurrentUser Member currentUser) {
		Pageable pageable = new Pageable(pageNumber, PAGE_SIZE);
		return ResponseEntity.ok(productFavoriteService.findPage(currentUser, pageable).getContent());
	}

	/**
	 * 删除
	 */
	@PostMapping("/delete")
	public ResponseEntity<?> delete(@ModelAttribute(binding = false) ProductFavorite productFavorite) {
		if (productFavorite == null) {
			return Results.NOT_FOUND;
		}

		productFavoriteService.delete(productFavorite);
		return Results.OK;
	}

}