/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service.impl;

import java.math.BigDecimal;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import net.shopxx.dao.MemberDao;
import net.shopxx.dao.OrderDao;
import net.shopxx.dao.StatisticDao;
import net.shopxx.dao.StoreDao;
import net.shopxx.entity.Statistic;
import net.shopxx.entity.Store;
import net.shopxx.service.StatisticService;

/**
 * Service统计
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Service
public class StatisticServiceImpl extends BaseServiceImpl<Statistic, Long> implements StatisticService {

	@Inject
	private StatisticDao statisticDao;
	@Inject
	private MemberDao memberDao;
	@Inject
	private OrderDao orderDao;
	@Inject
	private StoreDao storeDao;

	@Transactional(readOnly = true)
	public boolean exists(Statistic.Type type, Store store, int year, int month, int day) {
		return statisticDao.exists(type, store, year, month, day);
	}

	public void collect(int year, int month, int day) {
		for (Statistic.Type type : Statistic.Type.values()) {
			collect(type, null, year, month, day);
		}
		for (int i = 0;; i += 100) {
			List<Store> stores = storeDao.findList(null, Store.Status.success, null, null, i, 100);
			for (Store store : stores) {
				for (Statistic.Type type : Statistic.Type.values()) {
					if (!Statistic.Type.registerMemberCount.equals(type)) {
						collect(type, store, year, month, day);
					}
				}
			}
			storeDao.flush();
			storeDao.clear();
			if (stores.size() < 100) {
				break;
			}
		}
	}

	public void collect(Statistic.Type type, Store store, int year, int month, int day) {
		Assert.notNull(type);
		Assert.state(month >= 0);
		Assert.state(day >= 0);

		if (Statistic.Type.registerMemberCount.equals(type)) {
			if (statisticDao.exists(type, null, year, month, day)) {
				return;
			}
		} else if (statisticDao.exists(type, store, year, month, day)) {
			return;
		}

		Calendar beginCalendar = Calendar.getInstance();
		beginCalendar.set(year, month, day);
		beginCalendar.set(Calendar.HOUR_OF_DAY, beginCalendar.getActualMinimum(Calendar.HOUR_OF_DAY));
		beginCalendar.set(Calendar.MINUTE, beginCalendar.getActualMinimum(Calendar.MINUTE));
		beginCalendar.set(Calendar.SECOND, beginCalendar.getActualMinimum(Calendar.SECOND));
		Date beginDate = beginCalendar.getTime();

		Calendar endCalendar = Calendar.getInstance();
		endCalendar.set(year, month, day);
		endCalendar.set(Calendar.HOUR_OF_DAY, beginCalendar.getActualMaximum(Calendar.HOUR_OF_DAY));
		endCalendar.set(Calendar.MINUTE, beginCalendar.getActualMaximum(Calendar.MINUTE));
		endCalendar.set(Calendar.SECOND, beginCalendar.getActualMaximum(Calendar.SECOND));
		Date endDate = endCalendar.getTime();

		BigDecimal value = null;
		switch (type) {
		case registerMemberCount:
			value = new BigDecimal(memberDao.registerMemberCount(beginDate, endDate));
			break;
		case createOrderCount:
			value = new BigDecimal(orderDao.createOrderCount(store, beginDate, endDate));
			break;
		case completeOrderCount:
			value = new BigDecimal(orderDao.completeOrderCount(store, beginDate, endDate));
			break;
		case createOrderAmount:
			value = orderDao.createOrderAmount(store, beginDate, endDate);
			break;
		case completeOrderAmount:
			value = orderDao.completeOrderAmount(store, beginDate, endDate);
			break;
		}

		Statistic statistic = new Statistic();
		statistic.setType(type);
		statistic.setYear(year);
		statistic.setMonth(month);
		statistic.setDay(day);
		statistic.setValue(value);
		statistic.setStore(store);
		statisticDao.persist(statistic);
	}

	@Transactional(readOnly = true)
	public List<Statistic> analyze(Statistic.Type type, Store store, Statistic.Period period, Date beginDate, Date endDate) {
		return statisticDao.analyze(type, store, period, beginDate, endDate);
	}

}