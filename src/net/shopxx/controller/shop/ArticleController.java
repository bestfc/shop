/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.shop;

import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;

import org.apache.commons.lang.StringUtils;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import com.fasterxml.jackson.annotation.JsonView;

import net.shopxx.Pageable;
import net.shopxx.Results;
import net.shopxx.entity.Article;
import net.shopxx.entity.ArticleCategory;
import net.shopxx.entity.BaseEntity;
import net.shopxx.exception.ResourceNotFoundException;
import net.shopxx.service.ArticleCategoryService;
import net.shopxx.service.ArticleService;
import net.shopxx.service.SearchService;

/**
 * Controller文章
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("shopArticleController")
@RequestMapping("/article")
public class ArticleController extends BaseController {

	/**
	 * 每页记录数
	 */
	private static final int PAGE_SIZE = 20;

	@Inject
	private ArticleService articleService;
	@Inject
	private ArticleCategoryService articleCategoryService;
	@Inject
	private SearchService searchService;

	/**
	 * 详情
	 */
	@GetMapping("/detail/{articleId}_{pageNumber}")
	public String detail(@PathVariable Long articleId, @PathVariable Integer pageNumber, ModelMap model) {
		Article article = articleService.find(articleId);
		if (article == null || pageNumber < 1 || pageNumber > article.getTotalPages()) {
			throw new ResourceNotFoundException();
		}
		model.addAttribute("article", article);
		model.addAttribute("pageNumber", pageNumber);
		return "shop/article/detail";
	}

	/**
	 * 列表
	 */
	@GetMapping("/list/{articleCategoryId}")
	public String list(@PathVariable Long articleCategoryId, Integer pageNumber, ModelMap model) {
		ArticleCategory articleCategory = articleCategoryService.find(articleCategoryId);
		if (articleCategory == null) {
			throw new ResourceNotFoundException();
		}
		Pageable pageable = new Pageable(pageNumber, PAGE_SIZE);
		model.addAttribute("articleCategory", articleCategory);
		model.addAttribute("page", articleService.findPage(articleCategory, null, true, pageable));
		return "shop/article/list";
	}

	/**
	 * 列表
	 */
	@GetMapping(path = "/list", produces = MediaType.APPLICATION_JSON_VALUE)
	@JsonView(BaseEntity.BaseView.class)
	public ResponseEntity<?> list(Long articleCategoryId, Integer pageNumber) {
		ArticleCategory articleCategory = articleCategoryService.find(articleCategoryId);
		if (articleCategory == null) {
			return Results.NOT_FOUND;
		}

		Pageable pageable = new Pageable(pageNumber, PAGE_SIZE);
		return ResponseEntity.ok(articleService.findPage(articleCategory, null, true, pageable).getContent());
	}

	/**
	 * 搜索
	 */
	@GetMapping("/search")
	public String search(String keyword, Integer pageNumber, ModelMap model) {
		if (StringUtils.isEmpty(keyword)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		Pageable pageable = new Pageable(pageNumber, PAGE_SIZE);
		model.addAttribute("articleKeyword", keyword);
		model.addAttribute("page", searchService.search(keyword, pageable));
		return "shop/article/search";
	}

	/**
	 * 搜索
	 */
	@GetMapping(path = "/search", produces = MediaType.APPLICATION_JSON_VALUE)
	@JsonView(BaseEntity.BaseView.class)
	public ResponseEntity<?> search(String keyword, Integer pageNumber) {
		if (StringUtils.isEmpty(keyword)) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		Pageable pageable = new Pageable(pageNumber, PAGE_SIZE);
		return ResponseEntity.ok(searchService.search(keyword, pageable).getContent());
	}

	/**
	 * 点击数
	 */
	@GetMapping("/hits/{articleId}")
	public ResponseEntity<?> hits(@PathVariable Long articleId) {
		Map<String, Object> data = new HashMap<>();
		data.put("hits", articleService.viewHits(articleId));
		return ResponseEntity.ok(data);
	}

}