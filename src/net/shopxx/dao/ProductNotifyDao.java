/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.dao;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.entity.Member;
import net.shopxx.entity.ProductNotify;
import net.shopxx.entity.Sku;
import net.shopxx.entity.Store;

/**
 * Dao到货通知
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
public interface ProductNotifyDao extends BaseDao<ProductNotify, Long> {

	/**
	 * 判断到货通知是否存在
	 * 
	 * @param sku
	 *            SKU
	 * @param email
	 *            E-mail(忽略大小写)
	 * @return 到货通知是否存在
	 */
	boolean exists(Sku sku, String email);

	/**
	 * 查找到货通知分页
	 * 
	 * @param store
	 *            店铺
	 * @param member
	 *            会员
	 * @param isMarketable
	 *            是否上架
	 * @param isOutOfStock
	 *            SKU是否缺货
	 * @param hasSent
	 *            是否已发送.
	 * @param pageable
	 *            分页信息
	 * @return 到货通知分页
	 */
	Page<ProductNotify> findPage(Store store, Member member, Boolean isMarketable, Boolean isOutOfStock, Boolean hasSent, Pageable pageable);

	/**
	 * 查找到货通知数量
	 * 
	 * @param member
	 *            会员
	 * @param isMarketable
	 *            是否上架
	 * @param isOutOfStock
	 *            SKU是否缺货
	 * @param hasSent
	 *            是否已发送.
	 * @return 到货通知数量
	 */
	Long count(Member member, Boolean isMarketable, Boolean isOutOfStock, Boolean hasSent);

}