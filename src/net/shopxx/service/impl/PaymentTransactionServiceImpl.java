/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service.impl;

import java.math.BigDecimal;
import java.util.Collection;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

import javax.inject.Inject;
import javax.persistence.LockModeType;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import net.shopxx.Setting;
import net.shopxx.dao.PaymentTransactionDao;
import net.shopxx.dao.SnDao;
import net.shopxx.entity.Business;
import net.shopxx.entity.BusinessDepositLog;
import net.shopxx.entity.Member;
import net.shopxx.entity.MemberDepositLog;
import net.shopxx.entity.Order;
import net.shopxx.entity.OrderPayment;
import net.shopxx.entity.PaymentItem;
import net.shopxx.entity.PaymentMethod;
import net.shopxx.entity.PaymentTransaction;
import net.shopxx.entity.PaymentTransaction.LineItem;
import net.shopxx.entity.PlatformSvc;
import net.shopxx.entity.PromotionPluginSvc;
import net.shopxx.entity.Sn;
import net.shopxx.entity.Store;
import net.shopxx.entity.Svc;
import net.shopxx.entity.User;
import net.shopxx.plugin.PaymentPlugin;
import net.shopxx.plugin.discountPromotion.DiscountPromotionPlugin;
import net.shopxx.plugin.fullReductionPromotion.FullReductionPromotionPlugin;
import net.shopxx.service.BusinessService;
import net.shopxx.service.MemberService;
import net.shopxx.service.OrderService;
import net.shopxx.service.PaymentTransactionService;
import net.shopxx.service.ProductService;
import net.shopxx.service.StoreService;
import net.shopxx.service.SvcService;
import net.shopxx.service.UserService;
import net.shopxx.util.SystemUtils;

/**
 * Service支付事务
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Service
public class PaymentTransactionServiceImpl extends BaseServiceImpl<PaymentTransaction, Long> implements PaymentTransactionService {

	@Inject
	private PaymentTransactionDao paymentTransactionDao;
	@Inject
	private SnDao snDao;
	@Inject
	private ProductService productService;
	@Inject
	private OrderService orderService;
	@Inject
	private UserService userService;
	@Inject
	private MemberService memberService;
	@Inject
	private BusinessService businessService;
	@Inject
	private StoreService storeService;
	@Inject
	private SvcService svcService;

	@Transactional(readOnly = true)
	public PaymentTransaction findBySn(String sn) {
		return paymentTransactionDao.find("sn", StringUtils.lowerCase(sn));
	}

	public PaymentTransaction generate(PaymentTransaction.LineItem lineItem, PaymentPlugin paymentPlugin) {
		Assert.notNull(lineItem);
		Assert.notNull(paymentPlugin);
		Assert.notNull(lineItem.getAmount());
		Assert.notNull(lineItem.getType());
		Assert.notNull(lineItem.getTarget());

		PaymentTransaction paymentTransaction = paymentTransactionDao.findAvailable(lineItem, paymentPlugin);
		if (paymentTransaction == null) {
			paymentTransaction = new PaymentTransaction();
			paymentTransaction.setSn(snDao.generate(Sn.Type.paymentTransaction));
			paymentTransaction.setType(lineItem.getType());
			paymentTransaction.setAmount(paymentPlugin.calculateAmount(lineItem.getAmount()));
			paymentTransaction.setFee(paymentPlugin.calculateFee(lineItem.getAmount()));
			paymentTransaction.setIsSuccess(false);
			paymentTransaction.setExpire(DateUtils.addSeconds(new Date(), paymentPlugin.getTimeout()));
			paymentTransaction.setParent(null);
			paymentTransaction.setChildren(null);
			paymentTransaction.setTarget(lineItem.getTarget());
			paymentTransaction.setPaymentPlugin(paymentPlugin);
			paymentTransactionDao.persist(paymentTransaction);
		}
		return paymentTransaction;
	}

	public PaymentTransaction generateParent(Collection<PaymentTransaction.LineItem> lineItems, PaymentPlugin paymentPlugin) {
		Assert.notEmpty(lineItems);
		Assert.notNull(paymentPlugin);
		Assert.isTrue(lineItems.size() > 1);

		PaymentTransaction parentPaymentTransaction = paymentTransactionDao.findAvailableParent(lineItems, paymentPlugin);
		if (parentPaymentTransaction == null) {
			BigDecimal amount = BigDecimal.ZERO;
			for (PaymentTransaction.LineItem lineItem : lineItems) {
				Assert.notNull(lineItem);
				Assert.notNull(lineItem.getAmount());
				Assert.notNull(lineItem.getType());
				Assert.notNull(lineItem.getTarget());

				amount = amount.add(lineItem.getAmount());
			}

			parentPaymentTransaction = new PaymentTransaction();
			parentPaymentTransaction.setSn(snDao.generate(Sn.Type.paymentTransaction));
			parentPaymentTransaction.setType(null);
			parentPaymentTransaction.setAmount(paymentPlugin.calculateAmount(amount));
			parentPaymentTransaction.setFee(paymentPlugin.calculateFee(amount));
			parentPaymentTransaction.setIsSuccess(false);
			parentPaymentTransaction.setExpire(DateUtils.addSeconds(new Date(), paymentPlugin.getTimeout()));
			parentPaymentTransaction.setParent(null);
			parentPaymentTransaction.setChildren(null);
			parentPaymentTransaction.setTarget(null);
			parentPaymentTransaction.setPaymentPlugin(paymentPlugin);
			paymentTransactionDao.persist(parentPaymentTransaction);
			for (PaymentTransaction.LineItem lineItem : lineItems) {
				Assert.notNull(lineItem);
				Assert.notNull(lineItem.getAmount());
				Assert.notNull(lineItem.getType());
				Assert.notNull(lineItem.getTarget());

				PaymentTransaction paymentTransaction = new PaymentTransaction();
				paymentTransaction.setSn(snDao.generate(Sn.Type.paymentTransaction));
				paymentTransaction.setType(lineItem.getType());
				paymentTransaction.setAmount(paymentPlugin.calculateAmount(lineItem.getAmount()));
				paymentTransaction.setFee(paymentPlugin.calculateFee(lineItem.getAmount()));
				paymentTransaction.setIsSuccess(null);
				paymentTransaction.setExpire(null);
				paymentTransaction.setChildren(null);
				paymentTransaction.setTarget(lineItem.getTarget());
				paymentTransaction.setPaymentPlugin(null);
				paymentTransaction.setParent(parentPaymentTransaction);
				paymentTransactionDao.persist(paymentTransaction);
			}
		}
		return parentPaymentTransaction;
	}

	public void handle(PaymentTransaction paymentTransaction) {
		Assert.notNull(paymentTransaction);

		if (!LockModeType.PESSIMISTIC_WRITE.equals(paymentTransactionDao.getLockMode(paymentTransaction))) {
			paymentTransactionDao.flush();
			paymentTransactionDao.refresh(paymentTransaction, LockModeType.PESSIMISTIC_WRITE);
		}

		if (BooleanUtils.isNotFalse(paymentTransaction.getIsSuccess())) {
			return;
		}

		Set<PaymentTransaction> paymentTransactions = new HashSet<>();
		Set<PaymentTransaction> childrenList = paymentTransaction.getChildren();
		if (CollectionUtils.isNotEmpty(childrenList)) {
			paymentTransaction.setIsSuccess(true);
			paymentTransactions = childrenList;
		} else {
			paymentTransactions.add(paymentTransaction);
		}

		for (PaymentTransaction transaction : paymentTransactions) {
			Svc svc = transaction.getSvc();
			Store store = transaction.getStore();
			User user = transaction.getUser();
			BigDecimal effectiveAmount = transaction.getEffectiveAmount();

			Assert.notNull(transaction.getType());
			switch (transaction.getType()) {
			case ORDER_PAYMENT:
				Order order = transaction.getOrder();
				if (order != null) {
					OrderPayment orderPayment = new OrderPayment();
					orderPayment.setMethod(OrderPayment.Method.online);
					if(transaction.getPaymentPluginId()==null || (transaction.getPaymentPluginId()).equals("")){
						transaction.setPaymentPluginId(paymentTransaction.getPaymentPluginId());
						transaction.setPaymentPluginName(paymentTransaction.getPaymentPluginName());
					}
					orderPayment.setPaymentMethod(transaction.getPaymentPluginName());
					if (transaction.getPaymentPluginId().indexOf("alipay") == 0) {
						orderPayment.setOnlinePayType("alipay");
					} else if (transaction.getPaymentPluginId().indexOf("weixin") == 0 || transaction.getPaymentPluginId().indexOf("wechat") == 0) {
						orderPayment.setOnlinePayType("wechat");
					} else {
						orderPayment.setOnlinePayType("");
					}
					orderPayment.setAmount(transaction.getAmount());
					orderPayment.setFee(transaction.getFee());
					orderPayment.setOrder(order);
					orderPayment.setPaymentTransaction(transaction);
					orderService.payment(order, orderPayment);
				}
				break;
			case SVC_PAYMENT:
				if (svc == null || svc.getStore() == null) {
					break;
				}
				store = svc.getStore();

				Integer durationDays = svc.getDurationDays();
				if (svc instanceof PlatformSvc) {
					storeService.addEndDays(store, durationDays);
					if (Store.Status.approved.equals(store.getStatus()) && !store.hasExpired() && store.getBailPayable().compareTo(BigDecimal.ZERO) == 0) {
						store.setStatus(Store.Status.success);
					} else {
						productService.refreshActive(store);
					}
				} else if (svc instanceof PromotionPluginSvc) {
					String promotionPluginId = ((PromotionPluginSvc) svc).getPromotionPluginId();
					switch (promotionPluginId) {
					case DiscountPromotionPlugin.ID:
						storeService.addDiscountPromotionEndDays(store, durationDays);
						break;
					case FullReductionPromotionPlugin.ID:
						storeService.addFullReductionPromotionEndDays(store, durationDays);
						break;
					}
				}
				break;
			case DEPOSIT_RECHARGE:
				if (user instanceof Member) {
					memberService.addBalance((Member) user, effectiveAmount, MemberDepositLog.Type.recharge, null);
				} else if (user instanceof Business) {
					businessService.addBalance((Business) user, effectiveAmount, BusinessDepositLog.Type.recharge, null);
				}
				break;
			case BAIL_PAYMENT:
				if (store == null) {
					break;
				}

				storeService.addBailPaid(store, effectiveAmount);
				if (Store.Status.approved.equals(store.getStatus()) && !store.hasExpired() && store.getBailPayable().compareTo(BigDecimal.ZERO) == 0) {
					store.setStatus(Store.Status.success);
				} else {
					productService.refreshActive(store);
				}
				break;
			}
			transaction.setIsSuccess(true);
		}
	}

	public LineItem generate(PaymentItem paymentItem) {
		if (paymentItem == null || paymentItem.getType() == null) {
			return null;
		}
		Setting setting = SystemUtils.getSetting();
		User user = userService.getCurrent();
		switch (paymentItem.getType()) {
		case ORDER_PAYMENT:
			Member member = (Member) user;
			if (member == null) {
				return null;
			}
			Order order = orderService.findBySn(paymentItem.getOrderSn());
			if (order == null || !member.equals(order.getMember()) || !orderService.acquireLock(order, member)) {
				return null;
			}
			if (order.getPaymentMethod() == null || !PaymentMethod.Method.online.equals(order.getPaymentMethod().getMethod())) {
				return null;
			}
			if (order.getAmountPayable().compareTo(BigDecimal.ZERO) <= 0) {
				return null;
			}
			return new PaymentTransaction.OrderLineItem(order);
		case SVC_PAYMENT:
			Svc svc = svcService.findBySn(paymentItem.getSvcSn());
			if (svc == null) {
				return null;
			}
			if (svc.getAmount().compareTo(BigDecimal.ZERO) <= 0) {
				return null;
			}
			return new PaymentTransaction.SvcLineItem(svc);
		case DEPOSIT_RECHARGE:
			if (user == null) {
				return null;
			}
			if (paymentItem.getAmount() == null || paymentItem.getAmount().compareTo(BigDecimal.ZERO) <= 0 || paymentItem.getAmount().precision() > 15 || paymentItem.getAmount().scale() > setting.getPriceScale()) {
				return null;
			}
			if (user instanceof Member) {
				return new PaymentTransaction.DepositRechargerLineItem(user, paymentItem.getAmount());
			} else if (user instanceof Business) {
				return new PaymentTransaction.DepositRechargerLineItem(user, paymentItem.getAmount());
			} else {
				return null;
			}
		case BAIL_PAYMENT:
			Store store = storeService.getCurrent();
			if (store == null) {
				return null;
			}
			if (paymentItem.getAmount() == null || paymentItem.getAmount().compareTo(BigDecimal.ZERO) <= 0 || paymentItem.getAmount().precision() > 15 || paymentItem.getAmount().scale() > setting.getPriceScale()) {
				return null;
			}
			return new PaymentTransaction.BailPaymentLineItem(store, paymentItem.getAmount());
		}
		return null;
	}


	@Override
	@Transactional
	public PaymentTransaction save(PaymentTransaction paymentTransaction) {
		Assert.notNull(paymentTransaction);
		paymentTransaction.setSn(snDao.generate(Sn.Type.paymentTransaction));

		return super.save(paymentTransaction);
	}

}