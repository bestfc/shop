/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.dao;

import java.io.Serializable;
import java.util.List;

import javax.persistence.LockModeType;

import net.shopxx.Filter;
import net.shopxx.Order;
import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.entity.BaseEntity;

/**
 * Dao基类
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
public interface BaseDao<T extends BaseEntity<ID>, ID extends Serializable> {

	/**
	 * 判断是否存在
	 * 
	 * @param attributeName
	 *            属性名称
	 * @param attributeValue
	 *            属性值
	 * @return 是否存在
	 */
	boolean exists(String attributeName, Object attributeValue);

	/**
	 * 判断是否存在
	 * 
	 * @param attributeName
	 *            属性名称
	 * @param attributeValue
	 *            属性值
	 * @param ignoreCase
	 *            忽略大小写
	 * @return 是否存在
	 */
	boolean exists(String attributeName, String attributeValue, boolean ignoreCase);

	/**
	 * 判断是否唯一
	 * 
	 * @param id
	 *            ID
	 * @param attributeName
	 *            属性名称
	 * @param attributeValue
	 *            属性值
	 * @return 是否唯一
	 */
	boolean unique(ID id, String attributeName, Object attributeValue);

	/**
	 * 判断是否唯一
	 * 
	 * @param id
	 *            ID
	 * @param attributeName
	 *            属性名称
	 * @param attributeValue
	 *            属性值
	 * @param ignoreCase
	 *            忽略大小写
	 * @return 是否唯一
	 */
	boolean unique(ID id, String attributeName, String attributeValue, boolean ignoreCase);

	/**
	 * 查找实体对象
	 * 
	 * @param id
	 *            ID
	 * @return 实体对象，若不存在则返回null
	 */
	T find(ID id);

	/**
	 * 查找实体对象
	 * 
	 * @param id
	 *            ID
	 * @param lockModeType
	 *            锁定方式
	 * @return 实体对象，若不存在则返回null
	 */
	T find(ID id, LockModeType lockModeType);

	/**
	 * 查找实体对象
	 * 
	 * @param attributeName
	 *            属性名称
	 * @param attributeValue
	 *            属性值
	 * @return 实体对象，若不存在则返回null
	 */
	T find(String attributeName, Object attributeValue);

	/**
	 * 查找实体对象
	 * 
	 * @param attributeName
	 *            属性名称
	 * @param attributeValue
	 *            属性值
	 * @param ignoreCase
	 *            忽略大小写
	 * @return 实体对象，若不存在则返回null
	 */
	T find(String attributeName, String attributeValue, boolean ignoreCase);

	/**
	 * 查找实体对象
	 * 
	 * @param attributeName
	 *            属性名称
	 * @param attributeValue
	 *            属性值
	 * @param lockModeType
	 *            锁定方式
	 * @return 实体对象，若不存在则返回null
	 */
	T find(String attributeName, Object attributeValue, LockModeType lockModeType);

	/**
	 * 查找实体对象
	 * 
	 * @param attributeName
	 *            属性名称
	 * @param attributeValue
	 *            属性值
	 * @param ignoreCase
	 *            忽略大小写
	 * @param lockModeType
	 *            锁定方式
	 * @return 实体对象，若不存在则返回null
	 */
	T find(String attributeName, String attributeValue, boolean ignoreCase, LockModeType lockModeType);

	/**
	 * 查找实体对象集合
	 * 
	 * @param first
	 *            起始记录
	 * @param count
	 *            数量
	 * @param filters
	 *            筛选
	 * @param orders
	 *            排序
	 * @return 实体对象集合
	 */
	List<T> findList(Integer first, Integer count, List<Filter> filters, List<Order> orders);

	/**
	 * 查找实体对象分页
	 * 
	 * @param pageable
	 *            分页信息
	 * @return 实体对象分页
	 */
	Page<T> findPage(Pageable pageable);

	/**
	 * 查询实体对象数量
	 * 
	 * @param filters
	 *            筛选
	 * @return 实体对象数量
	 */
	long count(Filter... filters);

	/**
	 * 持久化实体对象
	 * 
	 * @param entity
	 *            实体对象
	 */
	void persist(T entity);

	/**
	 * 合并实体对象
	 * 
	 * @param entity
	 *            实体对象
	 * @return 实体对象
	 */
	T merge(T entity);

	/**
	 * 移除实体对象
	 * 
	 * @param entity
	 *            实体对象
	 */
	void remove(T entity);

	/**
	 * 刷新实体对象
	 * 
	 * @param entity
	 *            实体对象
	 */
	void refresh(T entity);

	/**
	 * 刷新实体对象
	 * 
	 * @param entity
	 *            实体对象
	 * @param lockModeType
	 *            锁定方式
	 */
	void refresh(T entity, LockModeType lockModeType);

	/**
	 * 获取实体对象ID
	 * 
	 * @param entity
	 *            实体对象
	 * @return 实体对象ID
	 */
	ID getIdentifier(T entity);

	/**
	 * 判断实体对象是否已加载
	 * 
	 * @param entity
	 *            实体对象
	 * @return 实体对象是否已加载
	 */
	boolean isLoaded(T entity);

	/**
	 * 判断实体对象属性是否已加载
	 * 
	 * @param entity
	 *            实体对象
	 * @param attributeName
	 *            属性名称
	 * @return 实体对象属性是否已加载
	 */
	boolean isLoaded(T entity, String attributeName);

	/**
	 * 判断是否为托管状态
	 * 
	 * @param entity
	 *            实体对象
	 * @return 是否为托管状态
	 */
	boolean isManaged(T entity);

	/**
	 * 设置为游离状态
	 * 
	 * @param entity
	 *            实体对象
	 */
	void detach(T entity);

	/**
	 * 获取锁定方式
	 * 
	 * @param entity
	 *            实体对象
	 * @return 锁定方式
	 */
	LockModeType getLockMode(T entity);

	/**
	 * 锁定实体对象
	 * 
	 * @param entity
	 *            实体对象
	 * @param lockModeType
	 *            锁定方式
	 */
	void lock(T entity, LockModeType lockModeType);

	/**
	 * 清除缓存
	 */
	void clear();

	/**
	 * 同步数据
	 */
	void flush();

}