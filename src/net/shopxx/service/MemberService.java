/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service;

import java.math.BigDecimal;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.entity.Member;
import net.shopxx.entity.MemberDepositLog;
import net.shopxx.entity.PointLog;
import net.shopxx.security.AuthenticationProvider;

/**
 * Service会员
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
public interface MemberService extends BaseService<Member, Long>, AuthenticationProvider {

	/**
	 * 判断用户名是否存在
	 * 
	 * @param username
	 *            用户名(忽略大小写)
	 * @return 用户名是否存在
	 */
	boolean usernameExists(String username);

	/**
	 * 根据用户名查找会员
	 * 
	 * @param username
	 *            用户名(忽略大小写)
	 * @return 会员，若不存在则返回null
	 */
	Member findByUsername(String username);

	/**
	 * 判断E-mail是否存在
	 * 
	 * @param email
	 *            E-mail(忽略大小写)
	 * @return E-mail是否存在
	 */
	boolean emailExists(String email);

	/**
	 * 判断E-mail是否唯一
	 * 
	 * @param id
	 *            ID
	 * @param email
	 *            E-mail(忽略大小写)
	 * @return E-mail是否唯一
	 */
	boolean emailUnique(Long id, String email);

	/**
	 * 根据E-mail查找会员
	 * 
	 * @param email
	 *            E-mail(忽略大小写)
	 * @return 会员，若不存在则返回null
	 */
	Member findByEmail(String email);

	/**
	 * 判断手机是否存在
	 * 
	 * @param mobile
	 *            手机(忽略大小写)
	 * @return 手机是否存在
	 */
	boolean mobileExists(String mobile);

	/**
	 * 判断手机是否唯一
	 * 
	 * @param id
	 *            ID
	 * @param mobile
	 *            手机(忽略大小写)
	 * @return 手机是否唯一
	 */
	boolean mobileUnique(Long id, String mobile);

	/**
	 * 根据手机查找会员
	 * 
	 * @param mobile
	 *            手机(忽略大小写)
	 * @return 会员，若不存在则返回null
	 */
	Member findByMobile(String mobile);

	/**
	 * 查找会员分页
	 * 
	 * @param rankingType
	 *            排名类型
	 * @param pageable
	 *            分页信息
	 * @return 会员分页
	 */
	Page<Member> findPage(Member.RankingType rankingType, Pageable pageable);

	/**
	 * 增加余额
	 * 
	 * @param member
	 *            会员
	 * @param amount
	 *            值
	 * @param type
	 *            类型
	 * @param memo
	 *            备注
	 */
	void addBalance(Member member, BigDecimal amount, MemberDepositLog.Type type, String memo);

	/**
	 * 增加积分
	 * 
	 * @param member
	 *            会员
	 * @param amount
	 *            值
	 * @param type
	 *            类型
	 * @param memo
	 *            备注
	 */
	void addPoint(Member member, long amount, PointLog.Type type, String memo);

	/**
	 * 增加消费金额
	 * 
	 * @param member
	 *            会员
	 * @param amount
	 *            值
	 */
	void addAmount(Member member, BigDecimal amount);

}