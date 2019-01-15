/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service;

import java.math.BigDecimal;
import java.util.List;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.entity.Article;
import net.shopxx.entity.Product;
import net.shopxx.entity.Store;

/**
 * Service搜索
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
public interface SearchService {

	/**
	 * 创建索引
	 * 
	 * @param type
	 *            索引类型
	 */
	void index(Class<?> type);

	/**
	 * 创建索引
	 * 
	 * @param type
	 *            索引类型
	 * @param purgeAll
	 *            是否清空已存在索引
	 */
	void index(Class<?> type, boolean purgeAll);

	/**
	 * 搜索文章分页
	 * 
	 * @param keyword
	 *            关键词
	 * @param pageable
	 *            分页信息
	 * @return 文章分页
	 */
	Page<Article> search(String keyword, Pageable pageable);

	/**
	 * 搜索商品分页
	 * 
	 * @param keyword
	 *            关键词
	 * @param store
	 *            店铺
	 * @param startPrice
	 *            最低价格
	 * @param endPrice
	 *            最高价格
	 * @param orderType
	 *            排序类型
	 * @param pageable
	 *            分页信息
	 * @return 商品分页
	 */
	Page<Product> search(String keyword, Store store, BigDecimal startPrice, BigDecimal endPrice, Product.OrderType orderType, Pageable pageable);

	/**
	 * 搜索店铺集合
	 * 
	 * @param keyword
	 *            关键词
	 * @return 店铺集合
	 */
	List<Store> searchStore(String keyword);

}