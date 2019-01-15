/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.dao.impl;

import java.io.IOException;

import javax.persistence.EntityManager;
import javax.persistence.LockModeType;
import javax.persistence.PersistenceContext;

import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;
import org.springframework.util.Assert;

import freemarker.template.TemplateException;
import net.shopxx.dao.SnDao;
import net.shopxx.entity.Sn;
import net.shopxx.util.FreeMarkerUtils;

/**
 * Dao序列号
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Repository
public class SnDaoImpl implements SnDao, InitializingBean {

	/**
	 * 商品编号生成器
	 */
	private HiloOptimizer productHiloOptimizer;

	/**
	 * 订单编号生成器
	 */
	private HiloOptimizer orderHiloOptimizer;

	/**
	 * 订单支付编号生成器
	 */
	private HiloOptimizer orderPaymentHiloOptimizer;

	/**
	 * 订单退款编号生成器
	 */
	private HiloOptimizer orderRefundsHiloOptimizer;

	/**
	 * 订单发货编号生成器
	 */
	private HiloOptimizer orderShippingHiloOptimizer;

	/**
	 * 订单退货编号生成器
	 */
	private HiloOptimizer orderReturnsHiloOptimizer;

	/**
	 * 支付事务编号生成器
	 */
	private HiloOptimizer paymentTransactionHiloOptimizer;

	/**
	 * 平台服务编号生成器
	 */
	private HiloOptimizer platformServiceHiloOptimizer;

	@PersistenceContext
	private EntityManager entityManager;

	@Value("${sn.product.prefix}")
	private String productPrefix;
	@Value("${sn.product.maxLo}")
	private int productMaxLo;
	@Value("${sn.order.prefix}")
	private String orderPrefix;
	@Value("${sn.order.maxLo}")
	private int orderMaxLo;
	@Value("${sn.orderPayment.prefix}")
	private String orderPaymentPrefix;
	@Value("${sn.orderPayment.maxLo}")
	private int orderPaymentMaxLo;
	@Value("${sn.orderRefunds.prefix}")
	private String orderRefundsPrefix;
	@Value("${sn.orderRefunds.maxLo}")
	private int orderRefundsMaxLo;
	@Value("${sn.orderShipping.prefix}")
	private String orderShippingPrefix;
	@Value("${sn.orderShipping.maxLo}")
	private int orderShippingMaxLo;
	@Value("${sn.orderReturns.prefix}")
	private String orderReturnsPrefix;
	@Value("${sn.orderReturns.maxLo}")
	private int orderReturnsMaxLo;
	@Value("${sn.paymentTransaction.prefix}")
	private String paymentTransactionPrefix;
	@Value("${sn.paymentTransaction.maxLo}")
	private int paymentTransactionMaxLo;
	@Value("${sn.platformService.prefix}")
	private String platformServicePrefix;
	@Value("${sn.platformService.maxLo}")
	private int platformServiceMaxLo;

	/**
	 * 初始化
	 */
	public void afterPropertiesSet() throws Exception {
		productHiloOptimizer = new HiloOptimizer(Sn.Type.product, productPrefix, productMaxLo);
		orderHiloOptimizer = new HiloOptimizer(Sn.Type.order, orderPrefix, orderMaxLo);
		orderPaymentHiloOptimizer = new HiloOptimizer(Sn.Type.orderPayment, orderPaymentPrefix, orderPaymentMaxLo);
		orderRefundsHiloOptimizer = new HiloOptimizer(Sn.Type.orderRefunds, orderRefundsPrefix, orderRefundsMaxLo);
		orderShippingHiloOptimizer = new HiloOptimizer(Sn.Type.orderShipping, orderShippingPrefix, orderShippingMaxLo);
		orderReturnsHiloOptimizer = new HiloOptimizer(Sn.Type.orderReturns, orderReturnsPrefix, orderReturnsMaxLo);
		paymentTransactionHiloOptimizer = new HiloOptimizer(Sn.Type.paymentTransaction, paymentTransactionPrefix, paymentTransactionMaxLo);
		platformServiceHiloOptimizer = new HiloOptimizer(Sn.Type.platformService, platformServicePrefix, platformServiceMaxLo);
	}

	/**
	 * 生成序列号
	 * 
	 * @param type
	 *            类型
	 * @return 序列号
	 */
	public String generate(Sn.Type type) {
		Assert.notNull(type);

		switch (type) {
		case product:
			return productHiloOptimizer.generate();
		case order:
			return orderHiloOptimizer.generate();
		case orderPayment:
			return orderPaymentHiloOptimizer.generate();
		case orderRefunds:
			return orderRefundsHiloOptimizer.generate();
		case orderShipping:
			return orderShippingHiloOptimizer.generate();
		case orderReturns:
			return orderReturnsHiloOptimizer.generate();
		case paymentTransaction:
			return paymentTransactionHiloOptimizer.generate();
		case platformService:
			return platformServiceHiloOptimizer.generate();
		}
		return null;
	}

	/**
	 * 获取末值
	 * 
	 * @param type
	 *            类型
	 * @return 末值
	 */
	private long getLastValue(Sn.Type type) {
		String jpql = "select sn from Sn sn where sn.type = :type";
		Sn sn = entityManager.createQuery(jpql, Sn.class).setLockMode(LockModeType.PESSIMISTIC_WRITE).setParameter("type", type).getSingleResult();
		long lastValue = sn.getLastValue();
		sn.setLastValue(lastValue + 1);
		return lastValue;
	}

	/**
	 * 高低位算法生成器
	 */
	private class HiloOptimizer {

		/**
		 * 类型
		 */
		private Sn.Type type;

		/**
		 * 前缀
		 */
		private String prefix;

		/**
		 * 最大低位值
		 */
		private int maxLo;

		/**
		 * 低位值
		 */
		private int lo;

		/**
		 * 高位值
		 */
		private long hi;

		/**
		 * 末值
		 */
		private long lastValue;

		/**
		 * 构造方法
		 * 
		 * @param type
		 *            类型
		 * @param prefix
		 *            前缀
		 * @param maxLo
		 *            最大低位值
		 */
		HiloOptimizer(Sn.Type type, String prefix, int maxLo) {
			this.type = type;
			this.prefix = prefix != null ? prefix.replace("{", "${") : "";
			this.maxLo = maxLo;
			this.lo = maxLo + 1;
		}

		/**
		 * 生成序列号
		 * 
		 * @return 序列号
		 */
		public synchronized String generate() {
			if (lo > maxLo) {
				lastValue = getLastValue(type);
				lo = lastValue == 0 ? 1 : 0;
				hi = lastValue * (maxLo + 1);
			}
			try {
				return FreeMarkerUtils.process(prefix) + (hi + lo++);
			} catch (IOException e) {
				throw new RuntimeException(e.getMessage(), e);
			} catch (TemplateException e) {
				throw new RuntimeException(e.getMessage(), e);
			}
		}
	}

}