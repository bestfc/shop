/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.member;

import javax.inject.Inject;

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
import net.shopxx.entity.Store;
import net.shopxx.entity.StoreFavorite;
import net.shopxx.exception.UnauthorizedException;
import net.shopxx.security.CurrentUser;
import net.shopxx.service.StoreFavoriteService;
import net.shopxx.service.StoreService;

/**
 * Controller店铺收藏
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("memberStoreFavoriteController")
@RequestMapping("/member/store_favorite")
public class StoreFavoriteController extends BaseController {

	/**
	 * 每页记录数
	 */
	private static final int PAGE_SIZE = 10;

	@Inject
	private StoreFavoriteService storeFavoriteService;
	@Inject
	private StoreService storeService;

	/**
	 * 添加属性
	 */
	@ModelAttribute
	public void populateModel(Long storeId, Long storeFavoriteId, @CurrentUser Member currentUser, ModelMap model) {
		model.addAttribute("store", storeService.find(storeId));

		StoreFavorite storeFavorite = storeFavoriteService.find(storeFavoriteId);
		if (storeFavorite != null && !currentUser.equals(storeFavorite.getMember())) {
			throw new UnauthorizedException();
		}
		model.addAttribute("storeFavorite", storeFavorite);
	}

	/**
	 * 添加
	 */
	@PostMapping("/add")
	public ResponseEntity<?> add(@ModelAttribute(binding = false) Store store, @CurrentUser Member currentUser) {
		if (store == null) {
			return Results.NOT_FOUND;
		}

		if (storeFavoriteService.exists(currentUser, store)) {
			return Results.unprocessableEntity("member.storeFavorite.exist");
		}
		if (StoreFavorite.MAX_STORE_FAVORITE_SIZE != null && storeFavoriteService.count(currentUser) >= StoreFavorite.MAX_STORE_FAVORITE_SIZE) {
			return Results.unprocessableEntity("member.storeFavorite.addCountNotAllowed", StoreFavorite.MAX_STORE_FAVORITE_SIZE);
		}
		StoreFavorite storeFavorite = new StoreFavorite();
		storeFavorite.setMember(currentUser);
		storeFavorite.setStore(store);
		storeFavoriteService.save(storeFavorite);
		return Results.OK;
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Integer pageNumber, @CurrentUser Member currentUser, ModelMap model) {
		Pageable pageable = new Pageable(pageNumber, PAGE_SIZE);
		model.addAttribute("page", storeFavoriteService.findPage(currentUser, pageable));
		return "member/store_favorite/list";
	}

	/**
	 * 列表
	 */
	@GetMapping(path = "/list", produces = MediaType.APPLICATION_JSON_VALUE)
	@JsonView(BaseEntity.BaseView.class)
	public ResponseEntity<?> list(Integer pageNumber, @CurrentUser Member currentUser) {
		Pageable pageable = new Pageable(pageNumber, PAGE_SIZE);
		return ResponseEntity.ok(storeFavoriteService.findPage(currentUser, pageable).getContent());
	}

	/**
	 * 删除
	 */
	@PostMapping("/delete")
	public ResponseEntity<?> delete(@ModelAttribute(binding = false) StoreFavorite storeFavorite) {
		if (storeFavorite == null) {
			return Results.NOT_FOUND;
		}

		storeFavoriteService.delete(storeFavorite);
		return Results.OK;
	}

}