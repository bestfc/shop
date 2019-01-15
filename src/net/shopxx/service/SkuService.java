/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service;

import java.util.List;
import java.util.Set;

import net.shopxx.entity.Product;
import net.shopxx.entity.Sku;
import net.shopxx.entity.StockLog;
import net.shopxx.entity.Store;

/**
 * ServiceSKU
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
public interface SkuService extends BaseService<Sku, Long> {

	/**
	 * 判断编号是否存在
	 * 
	 * @param sn
	 *            编号(忽略大小写)
	 * @return 编号是否存在
	 */
	boolean snExists(String sn);

	/**
	 * 根据编号查找SKU
	 * 
	 * @param sn
	 *            编号(忽略大小写)
	 * @return SKU，若不存在则返回null
	 */
	Sku findBySn(String sn);

	/**
	 * 通过编号、名称查找SKU
	 * 
	 * @param store
	 *            店铺
	 * @param type
	 *            类型
	 * @param keyword
	 *            关键词
	 * @param excludes
	 *            排除SKU
	 * @param count
	 *            数量
	 * @return SKU
	 */
	List<Sku> search(Store store, Product.Type type, String keyword, Set<Sku> excludes, Integer count);

	/**
	 * 增加库存
	 * 
	 * @param sku
	 *            SKU
	 * @param amount
	 *            值
	 * @param type
	 *            类型
	 * @param memo
	 *            备注
	 */
	void addStock(Sku sku, int amount, StockLog.Type type, String memo);

	/**
	 * 增加已分配库存
	 * 
	 * @param sku
	 *            SKU
	 * @param amount
	 *            值
	 */
	void addAllocatedStock(Sku sku, int amount);

	/**
	 * SKU过滤
	 * 
	 * @param skus
	 *            SKU
	 */
	void filter(List<Sku> skus);

}