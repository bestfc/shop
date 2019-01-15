/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.dao.impl;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.LockModeType;
import javax.persistence.NoResultException;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Fetch;
import javax.persistence.criteria.From;
import javax.persistence.criteria.Join;
import javax.persistence.criteria.Path;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import javax.persistence.criteria.Selection;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.core.ResolvableType;
import org.springframework.util.Assert;

import net.shopxx.Filter;
import net.shopxx.Order;
import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.dao.BaseDao;
import net.shopxx.entity.BaseEntity;
import net.shopxx.entity.OrderedEntity;

/**
 * Dao基类
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
public abstract class BaseDaoImpl<T extends BaseEntity<ID>, ID extends Serializable> implements BaseDao<T, ID> {

	/**
	 * 属性分隔符
	 */
	private static final String ATTRIBUTE_SEPARATOR = ".";

	/**
	 * 别名前缀
	 */
	private static final String ALIAS_PREFIX = "shopxxGeneratedAlias";

	/**
	 * 别名数
	 */
	private static volatile long aliasCount = 0L;

	/**
	 * 实体类类型
	 */
	private Class<T> entityClass;

	@PersistenceContext
	protected EntityManager entityManager;

	/**
	 * 构造方法
	 */
	@SuppressWarnings("unchecked")
	public BaseDaoImpl() {
		ResolvableType resolvableType = ResolvableType.forClass(getClass());
		entityClass = (Class<T>) resolvableType.as(BaseDaoImpl.class).getGeneric().resolve();
	}

	public boolean exists(String attributeName, Object attributeValue) {
		Assert.hasText(attributeName);

		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		CriteriaQuery<Long> criteriaQuery = criteriaBuilder.createQuery(Long.class);
		Root<T> root = criteriaQuery.from(entityClass);
		criteriaQuery.select(criteriaBuilder.count(root));
		criteriaQuery.where(criteriaBuilder.equal(root.get(attributeName), attributeValue));
		TypedQuery<Long> query = entityManager.createQuery(criteriaQuery);
		return query.getSingleResult() > 0;
	}

	public boolean exists(String attributeName, String attributeValue, boolean ignoreCase) {
		Assert.hasText(attributeName);

		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		CriteriaQuery<Long> criteriaQuery = criteriaBuilder.createQuery(Long.class);
		Root<T> root = criteriaQuery.from(entityClass);
		criteriaQuery.select(criteriaBuilder.count(root));
		if (ignoreCase) {
			criteriaQuery.where(criteriaBuilder.equal(criteriaBuilder.lower(root.<String>get(attributeName)), StringUtils.lowerCase(attributeValue)));
		} else {
			criteriaQuery.where(criteriaBuilder.equal(root.get(attributeName), attributeValue));
		}
		TypedQuery<Long> query = entityManager.createQuery(criteriaQuery);
		return query.getSingleResult() > 0;
	}

	public boolean unique(ID id, String attributeName, Object attributeValue) {
		Assert.hasText(attributeName);

		if (id != null) {
			CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
			CriteriaQuery<Long> criteriaQuery = criteriaBuilder.createQuery(Long.class);
			Root<T> root = criteriaQuery.from(entityClass);
			criteriaQuery.select(criteriaBuilder.count(root));
			criteriaQuery.where(criteriaBuilder.and(criteriaBuilder.equal(root.get(attributeName), attributeValue), criteriaBuilder.notEqual(root.get(BaseEntity.ID_PROPERTY_NAME), id)));
			TypedQuery<Long> query = entityManager.createQuery(criteriaQuery);
			return query.getSingleResult() <= 0;
		} else {
			return !exists(attributeName, attributeValue);
		}
	}

	public boolean unique(ID id, String attributeName, String attributeValue, boolean ignoreCase) {
		Assert.hasText(attributeName);

		if (id != null) {
			CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
			CriteriaQuery<Long> criteriaQuery = criteriaBuilder.createQuery(Long.class);
			Root<T> root = criteriaQuery.from(entityClass);
			criteriaQuery.select(criteriaBuilder.count(root));
			if (ignoreCase) {
				criteriaQuery.where(criteriaBuilder.and(criteriaBuilder.equal(criteriaBuilder.lower(root.<String>get(attributeName)), StringUtils.lowerCase(attributeValue)), criteriaBuilder.notEqual(root.get(BaseEntity.ID_PROPERTY_NAME), id)));
			} else {
				criteriaQuery.where(criteriaBuilder.and(criteriaBuilder.equal(root.get(attributeName), attributeValue), criteriaBuilder.notEqual(root.get(BaseEntity.ID_PROPERTY_NAME), id)));
			}
			TypedQuery<Long> query = entityManager.createQuery(criteriaQuery);
			return query.getSingleResult() <= 0;
		} else {
			return !exists(attributeName, attributeValue);
		}
	}

	public T find(ID id) {
		if (id == null) {
			return null;
		}
		return entityManager.find(entityClass, id);
	}

	public T find(ID id, LockModeType lockModeType) {
		if (id == null) {
			return null;
		}
		if (lockModeType != null) {
			return entityManager.find(entityClass, id, lockModeType);
		} else {
			return entityManager.find(entityClass, id);
		}
	}

	public T find(String attributeName, Object attributeValue) {
		Assert.hasText(attributeName);

		return find(attributeName, attributeValue, null);
	}

	public T find(String attributeName, String attributeValue, boolean ignoreCase) {
		Assert.hasText(attributeName);

		return find(attributeName, attributeValue, ignoreCase, null);
	}

	public T find(String attributeName, Object attributeValue, LockModeType lockModeType) {
		Assert.hasText(attributeName);

		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		CriteriaQuery<T> criteriaQuery = criteriaBuilder.createQuery(entityClass);
		Root<T> root = criteriaQuery.from(entityClass);
		criteriaQuery.select(root);
		criteriaQuery.where(criteriaBuilder.equal(root.get(attributeName), attributeValue));
		TypedQuery<T> query = entityManager.createQuery(criteriaQuery);
		if (lockModeType != null) {
			query.setLockMode(lockModeType);
		}
		try {
			return query.getSingleResult();
		} catch (NoResultException e) {
			return null;
		}
	}

	public T find(String attributeName, String attributeValue, boolean ignoreCase, LockModeType lockModeType) {
		Assert.hasText(attributeName);

		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		CriteriaQuery<T> criteriaQuery = criteriaBuilder.createQuery(entityClass);
		Root<T> root = criteriaQuery.from(entityClass);
		criteriaQuery.select(root);
		criteriaQuery.where();
		if (ignoreCase) {
			criteriaQuery.where(criteriaBuilder.equal(criteriaBuilder.lower(root.<String>get(attributeName)), StringUtils.lowerCase(attributeValue)));
		} else {
			criteriaQuery.where(criteriaBuilder.equal(root.get(attributeName), attributeValue));
		}
		TypedQuery<T> query = entityManager.createQuery(criteriaQuery);
		if (lockModeType != null) {
			query.setLockMode(lockModeType);
		}
		try {
			return query.getSingleResult();
		} catch (NoResultException e) {
			return null;
		}
	}

	public List<T> findList(Integer first, Integer count, List<Filter> filters, List<Order> orders) {
		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		CriteriaQuery<T> criteriaQuery = criteriaBuilder.createQuery(entityClass);
		criteriaQuery.select(criteriaQuery.from(entityClass));
		return findList(criteriaQuery, first, count, filters, orders);
	}

	public Page<T> findPage(Pageable pageable) {
		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		CriteriaQuery<T> criteriaQuery = criteriaBuilder.createQuery(entityClass);
		criteriaQuery.select(criteriaQuery.from(entityClass));
		return findPage(criteriaQuery, pageable);
	}

	public long count(Filter... filters) {
		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		CriteriaQuery<T> criteriaQuery = criteriaBuilder.createQuery(entityClass);
		criteriaQuery.select(criteriaQuery.from(entityClass));
		return count(criteriaQuery, ArrayUtils.isNotEmpty(filters) ? Arrays.asList(filters) : null);
	}

	public void persist(T entity) {
		Assert.notNull(entity);

		entityManager.persist(entity);
	}

	public T merge(T entity) {
		Assert.notNull(entity);

		return entityManager.merge(entity);
	}

	public void remove(T entity) {
		if (entity != null) {
			entityManager.remove(entity);
		}
	}

	public void refresh(T entity) {
		if (entity != null) {
			entityManager.refresh(entity);
		}
	}

	public void refresh(T entity, LockModeType lockModeType) {
		if (entity != null) {
			if (lockModeType != null) {
				entityManager.refresh(entity, lockModeType);
			} else {
				entityManager.refresh(entity);
			}
		}
	}

	@SuppressWarnings("unchecked")
	public ID getIdentifier(T entity) {
		Assert.notNull(entity);

		return (ID) entityManager.getEntityManagerFactory().getPersistenceUnitUtil().getIdentifier(entity);
	}

	public boolean isLoaded(T entity) {
		Assert.notNull(entity);

		return entityManager.getEntityManagerFactory().getPersistenceUnitUtil().isLoaded(entity);
	}

	public boolean isLoaded(T entity, String attributeName) {
		Assert.notNull(entity);
		Assert.hasText(attributeName);

		return entityManager.getEntityManagerFactory().getPersistenceUnitUtil().isLoaded(entity, attributeName);
	}

	public boolean isManaged(T entity) {
		Assert.notNull(entity);

		return entityManager.contains(entity);
	}

	public void detach(T entity) {
		if (entity != null) {
			entityManager.detach(entity);
		}
	}

	public LockModeType getLockMode(T entity) {
		Assert.notNull(entity);

		return entityManager.getLockMode(entity);
	}

	public void lock(T entity, LockModeType lockModeType) {
		if (entity != null && lockModeType != null) {
			entityManager.lock(entity, lockModeType);
		}
	}

	public void clear() {
		entityManager.clear();
	}

	public void flush() {
		entityManager.flush();
	}

	/**
	 * 查找实体对象集合
	 * 
	 * @param criteriaQuery
	 *            查询条件
	 * @param first
	 *            起始记录
	 * @param count
	 *            数量
	 * @param filters
	 *            筛选
	 * @param orders
	 *            排序
	 * @param lockModeType
	 *            锁定方式
	 * @return 实体对象集合
	 */
	protected List<T> findList(CriteriaQuery<T> criteriaQuery, Integer first, Integer count, List<Filter> filters, List<Order> orders, LockModeType lockModeType) {
		Assert.notNull(criteriaQuery);
		Assert.notNull(criteriaQuery.getSelection());
		Assert.notEmpty(criteriaQuery.getRoots());

		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		Root<T> root = findRoot(criteriaQuery, criteriaQuery.getResultType());

		Predicate restrictions = criteriaQuery.getRestriction() != null ? criteriaQuery.getRestriction() : criteriaBuilder.conjunction();
		restrictions = criteriaBuilder.and(restrictions, toPredicate(root, filters));
		criteriaQuery.where(restrictions);

		List<javax.persistence.criteria.Order> orderList = new ArrayList<>();
		orderList.addAll(criteriaQuery.getOrderList());
		orderList.addAll(toOrders(root, orders));
		if (CollectionUtils.isEmpty(orderList)) {
			if (OrderedEntity.class.isAssignableFrom(entityClass)) {
				orderList.add(criteriaBuilder.asc(getPath(root, OrderedEntity.ORDER_PROPERTY_NAME)));
			} else {
				orderList.add(criteriaBuilder.desc(getPath(root, OrderedEntity.CREATED_DATE_PROPERTY_NAME)));
			}
		}
		criteriaQuery.orderBy(orderList);

		TypedQuery<T> query = entityManager.createQuery(criteriaQuery);
		if (first != null) {
			query.setFirstResult(first);
		}
		if (count != null) {
			query.setMaxResults(count);
		}
		if (lockModeType != null) {
			query.setLockMode(lockModeType);
		}
		return query.getResultList();
	}

	/**
	 * 查找实体对象集合
	 * 
	 * @param criteriaQuery
	 *            查询条件
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
	protected List<T> findList(CriteriaQuery<T> criteriaQuery, Integer first, Integer count, List<Filter> filters, List<Order> orders) {
		return findList(criteriaQuery, first, count, filters, orders, null);
	}

	/**
	 * 查找实体对象集合
	 * 
	 * @param criteriaQuery
	 *            查询条件
	 * @param first
	 *            起始记录
	 * @param count
	 *            数量
	 * @return 实体对象集合
	 */
	protected List<T> findList(CriteriaQuery<T> criteriaQuery, Integer first, Integer count) {
		return findList(criteriaQuery, first, count, null, null, null);
	}

	/**
	 * 查找实体对象集合
	 * 
	 * @param criteriaQuery
	 *            查询条件
	 * @return 实体对象集合
	 */
	protected List<T> findList(CriteriaQuery<T> criteriaQuery) {
		return findList(criteriaQuery, null, null, null, null, null);
	}

	/**
	 * 查找实体对象分页
	 * 
	 * @param criteriaQuery
	 *            查询条件
	 * @param pageable
	 *            分页信息
	 * @param lockModeType
	 *            锁定方式
	 * @return 实体对象分页
	 */
	protected Page<T> findPage(CriteriaQuery<T> criteriaQuery, Pageable pageable, LockModeType lockModeType) {
		Assert.notNull(criteriaQuery);
		Assert.notNull(criteriaQuery.getSelection());
		Assert.notEmpty(criteriaQuery.getRoots());

		if (pageable == null) {
			pageable = new Pageable();
		}

		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		Root<T> root = findRoot(criteriaQuery, criteriaQuery.getResultType());

		Predicate restrictions = criteriaQuery.getRestriction() != null ? criteriaQuery.getRestriction() : criteriaBuilder.conjunction();
		restrictions = criteriaBuilder.and(restrictions, toPredicate(root, pageable.getFilters()));
		String searchProperty = pageable.getSearchProperty();
		String searchValue = pageable.getSearchValue();
		if (StringUtils.isNotEmpty(searchProperty) && StringUtils.isNotEmpty(searchValue)) {
			Path<String> searchPath = getPath(root, searchProperty);
			if (searchPath != null) {
				restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.like(searchPath, "%" + searchValue + "%"));
			}
		}
		criteriaQuery.where(restrictions);

		List<javax.persistence.criteria.Order> orderList = new ArrayList<>();
		orderList.addAll(criteriaQuery.getOrderList());
		orderList.addAll(toOrders(root, pageable.getOrders()));
		String orderProperty = pageable.getOrderProperty();
		Order.Direction orderDirection = pageable.getOrderDirection();
		if (StringUtils.isNotEmpty(orderProperty) && orderDirection != null) {
			Path<?> orderPath = getPath(root, orderProperty);
			if (orderPath != null) {
				switch (orderDirection) {
				case asc:
					orderList.add(criteriaBuilder.asc(orderPath));
					break;
				case desc:
					orderList.add(criteriaBuilder.desc(orderPath));
					break;
				}
			}
		}
		if (CollectionUtils.isEmpty(orderList)) {
			if (OrderedEntity.class.isAssignableFrom(entityClass)) {
				orderList.add(criteriaBuilder.asc(getPath(root, OrderedEntity.ORDER_PROPERTY_NAME)));
			} else {
				orderList.add(criteriaBuilder.desc(getPath(root, OrderedEntity.LAST_MODIFIED_DATE_PROPERTY_NAME)));
			}
		}
		criteriaQuery.orderBy(orderList);

		long total = count(criteriaQuery, null);
		TypedQuery<T> query = entityManager.createQuery(criteriaQuery);
		query.setFirstResult((pageable.getPageNumber()1) * pageable.getPageSize());
		query.setMaxResults(pageable.getPageSize());
		if (lockModeType != null) {
			query.setLockMode(lockModeType);
		}
		return new Page<>(query.getResultList(), total, pageable);
	}

	/**
	 * 查找实体对象分页
	 * 
	 * @param criteriaQuery
	 *            查询条件
	 * @param pageable
	 *            分页信息
	 * @return 实体对象分页
	 */
	protected Page<T> findPage(CriteriaQuery<T> criteriaQuery, Pageable pageable) {
		return findPage(criteriaQuery, pageable, null);
	}

	/**
	 * 查询实体对象数量
	 * 
	 * @param criteriaQuery
	 *            查询条件
	 * @param filters
	 *            筛选
	 * @return 实体对象数量
	 */
	protected Long count(CriteriaQuery<T> criteriaQuery, List<Filter> filters) {
		Assert.notNull(criteriaQuery);
		Assert.notNull(criteriaQuery.getSelection());
		Assert.notEmpty(criteriaQuery.getRoots());

		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		Root<T> root = findRoot(criteriaQuery, criteriaQuery.getResultType());

		Predicate restrictions = criteriaQuery.getRestriction() != null ? criteriaQuery.getRestriction() : criteriaBuilder.conjunction();
		restrictions = criteriaBuilder.and(restrictions, toPredicate(root, filters));
		criteriaQuery.where(restrictions);

		CriteriaQuery<Long> countCriteriaQuery = criteriaBuilder.createQuery(Long.class);
		copyCriteriaWithoutSelectionAndOrder(criteriaQuery, countCriteriaQuery);

		Root<?> countRoot = findRoot(countCriteriaQuery, criteriaQuery.getResultType());
		if (criteriaQuery.isDistinct()) {
			countCriteriaQuery.select(criteriaBuilder.countDistinct(countRoot));
		} else {
			countCriteriaQuery.select(criteriaBuilder.count(countRoot));
		}
		return entityManager.createQuery(countCriteriaQuery).getSingleResult();
	}

	/**
	 * 查询实体对象数量
	 * 
	 * @param criteriaQuery
	 *            查询条件
	 * @return 实体对象数量
	 */
	protected Long count(CriteriaQuery<T> criteriaQuery) {
		return count(criteriaQuery, null);
	}

	/**
	 * 查找Root
	 * 
	 * @param criteriaQuery
	 *            查询条件
	 * @param clazz
	 *            类型
	 * @return Root
	 */
	@SuppressWarnings("unchecked")
	private Root<T> findRoot(CriteriaQuery<?> criteriaQuery, Class<T> clazz) {
		Assert.notNull(criteriaQuery);
		Assert.notNull(clazz);

		for (Root<?> root : criteriaQuery.getRoots()) {
			if (clazz.equals(root.getJavaType())) {
				return (Root<T>) root.as(clazz);
			}
		}
		return (Root<T>) criteriaQuery.getRoots().iterator().next();
	}

	/**
	 * 获取Path
	 * 
	 * @param path
	 *            Path
	 * @param attributeName
	 *            属性名称
	 * @return Path
	 */
	@SuppressWarnings("unchecked")
	private <X> Path<X> getPath(Path<?> path, String attributeName) {
		if (path == null || StringUtils.isEmpty(attributeName)) {
			return (Path<X>) path;
		}
		return getPath(path.get(StringUtils.substringBefore(attributeName, ATTRIBUTE_SEPARATOR)), StringUtils.substringAfter(attributeName, ATTRIBUTE_SEPARATOR));
	}

	/**
	 * 获取或创建别名
	 * 
	 * @param selection
	 *            Selection
	 * @return 别名
	 */
	private synchronized String getOrCreateAlias(Selection<?> selection) {
		Assert.notNull(selection);

		String alias = selection.getAlias();
		if (alias == null) {
			if (aliasCount > 1000) {
				aliasCount = 0;
			}
			alias = ALIAS_PREFIX + aliasCount++;
			selection.alias(alias);
		}
		return alias;

	}

	/**
	 * 拷贝Join
	 * 
	 * @param from
	 *            源
	 * @param to
	 *            目标
	 */
	private void copyJoins(From<?, ?> from, From<?, ?> to) {
		Assert.notNull(from);
		Assert.notNull(to);

		for (Join<?, ?> fromJoin : from.getJoins()) {
			Join<?, ?> toJoin = to.join(fromJoin.getAttribute().getName(), fromJoin.getJoinType());
			toJoin.alias(getOrCreateAlias(fromJoin));
			copyJoins(fromJoin, toJoin);
		}
	}

	/**
	 * 拷贝Fetch
	 * 
	 * @param from
	 *            源
	 * @param to
	 *            目标
	 */
	private void copyFetches(From<?, ?> from, From<?, ?> to) {
		Assert.notNull(from);
		Assert.notNull(to);

		for (Fetch<?, ?> fromFetch : from.getFetches()) {
			Fetch<?, ?> toFetch = to.fetch(fromFetch.getAttribute().getName());
			copyFetches(fromFetch, toFetch);
		}
	}

	/**
	 * 拷贝Fetch
	 * 
	 * @param from
	 *            源
	 * @param to
	 *            目标
	 */
	private void copyFetches(Fetch<?, ?> from, Fetch<?, ?> to) {
		Assert.notNull(from);
		Assert.notNull(to);

		for (Fetch<?, ?> fromFetch : from.getFetches()) {
			Fetch<?, ?> toFetch = to.fetch(fromFetch.getAttribute().getName());
			copyFetches(fromFetch, toFetch);
		}
	}

	/**
	 * 拷贝查询条件(不包含Selection、Order)
	 * 
	 * @param from
	 *            源
	 * @param to
	 *            目标
	 */
	private void copyCriteriaWithoutSelectionAndOrder(CriteriaQuery<?> from, CriteriaQuery<?> to) {
		Assert.notNull(from);
		Assert.notNull(to);

		for (Root<?> root : from.getRoots()) {
			Root<?> dest = to.from(root.getJavaType());
			dest.alias(getOrCreateAlias(root));
			copyJoins(root, dest);
			copyFetches(root, dest);
		}

		to.groupBy(from.getGroupList());
		to.distinct(from.isDistinct());

		if (from.getGroupRestriction() != null) {
			to.having(from.getGroupRestriction());
		}

		if (from.getRestriction() != null) {
			to.where(from.getRestriction());
		}
	}

	/**
	 * 转换为Predicate
	 * 
	 * @param root
	 *            Root
	 * @param filters
	 *            筛选
	 * @return Predicate
	 */
	@SuppressWarnings("unchecked")
	private Predicate toPredicate(Root<T> root, List<Filter> filters) {
		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		Predicate restrictions = criteriaBuilder.conjunction();
		if (root == null || CollectionUtils.isEmpty(filters)) {
			return restrictions;
		}
		for (Filter filter : filters) {
			if (filter == null) {
				continue;
			}
			String property = filter.getProperty();
			Filter.Operator operator = filter.getOperator();
			Object value = filter.getValue();
			Boolean ignoreCase = filter.getIgnoreCase();
			Path<?> path = getPath(root, property);
			if (path == null) {
				continue;
			}
			switch (operator) {
			case eq:
				if (value != null) {
					if (BooleanUtils.isTrue(ignoreCase) && String.class.isAssignableFrom(path.getJavaType()) && value instanceof String) {
						restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(criteriaBuilder.lower((Path<String>) path), ((String) value).toLowerCase()));
					} else {
						restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(path, value));
					}
				} else {
					restrictions = criteriaBuilder.and(restrictions, path.isNull());
				}
				break;
			case ne:
				if (value != null) {
					if (BooleanUtils.isTrue(ignoreCase) && String.class.isAssignableFrom(path.getJavaType()) && value instanceof String) {
						restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.notEqual(criteriaBuilder.lower((Path<String>) path), ((String) value).toLowerCase()));
					} else {
						restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.notEqual(path, value));
					}
				} else {
					restrictions = criteriaBuilder.and(restrictions, path.isNotNull());
				}
				break;
			case gt:
				if (Number.class.isAssignableFrom(path.getJavaType()) && value instanceof Number) {
					restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.gt((Path<Number>) path, (Number) value));
				}
				break;
			case lt:
				if (Number.class.isAssignableFrom(path.getJavaType()) && value instanceof Number) {
					restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.lt((Path<Number>) path, (Number) value));
				}
				break;
			case ge:
				if (Number.class.isAssignableFrom(path.getJavaType()) && value instanceof Number) {
					restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.ge((Path<Number>) path, (Number) value));
				}
				break;
			case le:
				if (Number.class.isAssignableFrom(path.getJavaType()) && value instanceof Number) {
					restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.le((Path<Number>) path, (Number) value));
				}
				break;
			case like:
				if (String.class.isAssignableFrom(path.getJavaType()) && value instanceof String) {
					if (BooleanUtils.isTrue(ignoreCase)) {
						restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.like(criteriaBuilder.lower((Path<String>) path), ((String) value).toLowerCase()));
					} else {
						restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.like((Path<String>) path, (String) value));
					}
				}
				break;
			case in:
				restrictions = criteriaBuilder.and(restrictions, path.in(value));
				break;
			case isNull:
				restrictions = criteriaBuilder.and(restrictions, path.isNull());
				break;
			case isNotNull:
				restrictions = criteriaBuilder.and(restrictions, path.isNotNull());
				break;
			}
		}
		return restrictions;
	}

	/**
	 * 转换为Order
	 * 
	 * @param root
	 *            Root
	 * @param orders
	 *            排序
	 * @return Order
	 */
	private List<javax.persistence.criteria.Order> toOrders(Root<T> root, List<Order> orders) {
		List<javax.persistence.criteria.Order> orderList = new ArrayList<>();
		if (root == null || CollectionUtils.isEmpty(orders)) {
			return orderList;
		}
		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		for (Order order : orders) {
			if (order == null) {
				continue;
			}
			String property = order.getProperty();
			Order.Direction direction = order.getDirection();
			Path<?> path = getPath(root, property);
			if (path == null || direction == null) {
				continue;
			}
			switch (direction) {
			case asc:
				orderList.add(criteriaBuilder.asc(path));
				break;
			case desc:
				orderList.add(criteriaBuilder.desc(path));
				break;
			}
		}
		return orderList;
	}

}