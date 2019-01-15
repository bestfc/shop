/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service.impl;

import java.util.List;
import java.util.Set;

import javax.inject.Inject;
import javax.persistence.LockModeType;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.Predicate;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import net.shopxx.dao.SkuDao;
import net.shopxx.dao.StockLogDao;
import net.shopxx.entity.Product;
import net.shopxx.entity.Sku;
import net.shopxx.entity.StockLog;
import net.shopxx.entity.Store;
import net.shopxx.service.SkuService;

/**
 * ServiceSKU
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Service
public class SkuServiceImpl extends BaseServiceImpl<Sku, Long> implements SkuService {

	@Inject
	private SkuDao skuDao;
	@Inject
	private StockLogDao stockLogDao;

	@Transactional(readOnly = true)
	public boolean snExists(String sn) {
		return skuDao.exists("sn", StringUtils.lowerCase(sn));
	}

	@Transactional(readOnly = true)
	public Sku findBySn(String sn) {
		return skuDao.find("sn", StringUtils.lowerCase(sn));
	}

	@Transactional(readOnly = true)
	public List<Sku> search(Store store, Product.Type type, String keyword, Set<Sku> excludes, Integer count) {
		return skuDao.search(store, type, keyword, excludes, count);
	}

	public void addStock(Sku sku, int amount, StockLog.Type type, String memo) {
		Assert.notNull(sku);
		Assert.notNull(type);

		if (amount == 0) {
			return;
		}

		if (!LockModeType.PESSIMISTIC_WRITE.equals(skuDao.getLockMode(sku))) {
			skuDao.flush();
			skuDao.refresh(sku, LockModeType.PESSIMISTIC_WRITE);
		}

		Assert.notNull(sku.getStock());
		Assert.state(sku.getStock() + amount >= 0);

		sku.setStock(sku.getStock() + amount);
		skuDao.flush();

		StockLog stockLog = new StockLog();
		stockLog.setType(type);
		stockLog.setInQuantity(amount > 0 ? amount : 0);
		stockLog.setOutQuantity(amount < 0 ? Math.abs(amount) : 0);
		stockLog.setStock(sku.getStock());
		stockLog.setMemo(memo);
		stockLog.setSku(sku);
		stockLogDao.persist(stockLog);
	}

	public void addAllocatedStock(Sku sku, int amount) {
		Assert.notNull(sku);

		if (amount == 0) {
			return;
		}

		if (!LockModeType.PESSIMISTIC_WRITE.equals(skuDao.getLockMode(sku))) {
			skuDao.flush();
			skuDao.refresh(sku, LockModeType.PESSIMISTIC_WRITE);
		}

		Assert.notNull(sku.getAllocatedStock());
		Assert.state(sku.getAllocatedStock() + amount >= 0);

		sku.setAllocatedStock(sku.getAllocatedStock() + amount);
		skuDao.flush();
	}

	@Transactional(readOnly = true)
	public void filter(List<Sku> skus) {
		CollectionUtils.filter(skus, new Predicate() {
			public boolean evaluate(Object object) {
				Sku sku = (Sku) object;
				return sku != null && sku.getStock() != null;
			}
		});
	}

}