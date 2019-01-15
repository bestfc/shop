/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service;

import java.util.List;

import net.shopxx.Filter;
import net.shopxx.Order;
import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.entity.Member;
import net.shopxx.entity.Product;
import net.shopxx.entity.Review;
import net.shopxx.entity.Store;

/**
 * Service评论
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
public interface ReviewService extends BaseService<Review, Long> {

	/**
	 * 查找评论
	 * 
	 * @param member
	 *            会员
	 * @param product
	 *            商品
	 * @param type
	 *            类型
	 * @param isShow
	 *            是否显示
	 * @param count
	 *            数量
	 * @param filters
	 *            筛选
	 * @param orders
	 *            排序
	 * @return 评论
	 */
	List<Review> findList(Member member, Product product, Review.Type type, Boolean isShow, Integer count, List<Filter> filters, List<Order> orders);

	/**
	 * 查找评论
	 * 
	 * @param memberId
	 *            会员ID
	 * @param productId
	 *            商品ID
	 * @param type
	 *            类型
	 * @param isShow
	 *            是否显示
	 * @param count
	 *            数量
	 * @param filters
	 *            筛选
	 * @param orders
	 *            排序
	 * @param useCache
	 *            是否使用缓存
	 * @return 评论
	 */
	List<Review> findList(Long memberId, Long productId, Review.Type type, Boolean isShow, Integer count, List<Filter> filters, List<Order> orders, boolean useCache);

	/**
	 * 查找评论分页
	 * 
	 * @param member
	 *            会员
	 * @param product
	 *            商品
	 * @param store
	 *            店铺
	 * @param type
	 *            类型
	 * @param isShow
	 *            是否显示
	 * @param pageable
	 *            分页信息
	 * @return 评论分页
	 */
	Page<Review> findPage(Member member, Product product, Store store, Review.Type type, Boolean isShow, Pageable pageable);

	/**
	 * 查找评论数量
	 * 
	 * @param member
	 *            会员
	 * @param product
	 *            商品
	 * @param type
	 *            类型
	 * @param isShow
	 *            是否显示
	 * @return 评论数量
	 */
	Long count(Member member, Product product, Review.Type type, Boolean isShow);

	/**
	 * 评论回复
	 * 
	 * @param review
	 *            评论
	 * @param replyReview
	 *            回复评论
	 */
	void reply(Review review, Review replyReview);

	/**
	 * 判断是否拥有评论权限
	 * 
	 * @param member
	 *            会员
	 * @param product
	 *            商品
	 * @return 是否拥有评论权限
	 */
	boolean hasPermission(Member member, Product product);
}