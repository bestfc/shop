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
import net.shopxx.entity.CategoryApplication;
import net.shopxx.entity.ProductCategory;
import net.shopxx.entity.Store;
import net.shopxx.plugin.PromotionPlugin;

/**
 * Service店铺
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
public interface StoreService extends BaseService<Store, Long> {

	/**
	 * 判断名称是否存在
	 * 
	 * @param name
	 *            名称(忽略大小写)
	 * @return 名称是否存在
	 */
	boolean nameExists(String name);

	/**
	 * 判断名称是否唯一
	 * 
	 * @param id
	 *            ID
	 * @param name
	 *            名称(忽略大小写)
	 * @return 名称是否唯一
	 */
	boolean nameUnique(Long id, String name);

	/**
	 * 判断经营分类是否存在
	 * 
	 * @param store
	 *            店铺
	 * @param productCategory
	 *            商品分类
	 * @return 经营分类是否存在
	 */
	boolean productCategoryExists(Store store, ProductCategory productCategory);

	/**
	 * 根据名称查找店铺
	 * 
	 * @param name
	 *            名称(忽略大小写)
	 * @return 店铺
	 */
	Store findByName(String name);

	/**
	 * 查找店铺
	 * 
	 * @param type
	 *            类型
	 * @param status
	 *            状态
	 * @param isEnabled
	 *            是否启用
	 * @param hasExpired
	 *            是否过期
	 * @param first
	 *            起始记录
	 * @param count
	 *            数量
	 * @return 店铺
	 */
	List<Store> findList(Store.Type type, Store.Status status, Boolean isEnabled, Boolean hasExpired, Integer first, Integer count);

	/**
	 * 查找经营分类
	 * 
	 * @param store
	 *            店铺
	 * @param status
	 *            状态
	 * @return 经营分类
	 */
	List<ProductCategory> findProductCategoryList(Store store, CategoryApplication.Status status);

	/**
	 * 查找店铺分页
	 * 
	 * @param type
	 *            类型
	 * @param status
	 *            状态
	 * @param isEnabled
	 *            是否启用
	 * @param hasExpired
	 *            是否过期
	 * @param pageable
	 *            分页信息
	 * @return 店铺分页
	 */
	Page<Store> findPage(Store.Type type, Store.Status status, Boolean isEnabled, Boolean hasExpired, Pageable pageable);

	/**
	 * 获取当前登录商家店铺
	 * 
	 * @return 当前登录商家店铺，若不存在则返回null
	 */
	Store getCurrent();

	/**
	 * 增加到期天数
	 * 
	 * @param store
	 *            店铺
	 * @param amount
	 *            值
	 */
	void addEndDays(Store store, int amount);

	/**
	 * 增加折扣促销到期天数
	 * 
	 * @param store
	 *            店铺
	 * @param amount
	 *            值
	 */
	void addDiscountPromotionEndDays(Store store, int amount);

	/**
	 * 增加满减促销到期天数
	 * 
	 * @param store
	 *            店铺
	 * @param amount
	 *            值
	 */
	void addFullReductionPromotionEndDays(Store store, int amount);

	/**
	 * 增加已付保证金
	 * 
	 * @param store
	 *            店铺
	 * @param amount
	 *            值
	 */
	void addBailPaid(Store store, BigDecimal amount);

	/**
	 * 审核
	 * 
	 * @param store
	 *            店铺
	 * @param passed
	 *            是否审核成功
	 * @param content
	 *            审核失败内容
	 */
	void review(Store store, boolean passed, String content);

	/**
	 * 购买促销插件
	 * 
	 * @param store
	 *            店铺
	 * @param promotionPlugin
	 *            促销插件
	 * @param months
	 *            月数
	 */
	void buy(Store store, PromotionPlugin promotionPlugin, int months);

	/**
	 * 过期店铺处理
	 */
	void expiredStoreProcessing();

}