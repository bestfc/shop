/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.business;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import net.shopxx.entity.Product;
import net.shopxx.entity.Store;
import net.shopxx.security.CurrentStore;
import net.shopxx.service.ProductService;

/**
 * Controller商品排名
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("businessProductRankingController")
@RequestMapping("/business/product_ranking")
public class ProductRankingController extends BaseController {

	/**
	 * 默认排名类型
	 */
	private static final Product.RankingType DEFAULT_RANKING_TYPE = Product.RankingType.score;

	/**
	 * 默认数量
	 */
	private static final int DEFAULT_SIZE = 10;

	@Inject
	private ProductService productService;

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Model model) {
		model.addAttribute("rankingTypes", Product.RankingType.values());
		model.addAttribute("rankingType", DEFAULT_RANKING_TYPE);
		model.addAttribute("size", DEFAULT_SIZE);
		return "business/product_ranking/list";
	}

	/**
	 * 数据
	 */
	@GetMapping("/data")
	public ResponseEntity<?> data(Product.RankingType rankingType, Integer size, @CurrentStore Store currentStore) {
		if (rankingType == null) {
			rankingType = DEFAULT_RANKING_TYPE;
		}
		if (size == null) {
			size = DEFAULT_SIZE;
		}
		List<Map<String, Object>> data = new ArrayList<>();
		for (Product product : productService.findList(rankingType, currentStore, size)) {
			Object value = null;
			switch (rankingType) {
			case score:
				value = product.getScore();
				break;
			case scoreCount:
				value = product.getScoreCount();
				break;
			case weekHits:
				value = product.getWeekHits();
				break;
			case monthHits:
				value = product.getMonthHits();
				break;
			case hits:
				value = product.getHits();
				break;
			case weekSales:
				value = product.getWeekSales();
				break;
			case monthSales:
				value = product.getMonthSales();
				break;
			case sales:
				value = product.getSales();
				break;
			}
			Map<String, Object> item = new HashMap<>();
			item.put("name", product.getName());
			item.put("value", value);
			data.add(item);
		}
		return ResponseEntity.ok(data);
	}

}