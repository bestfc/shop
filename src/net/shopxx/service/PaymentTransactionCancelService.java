package net.shopxx.service;

import net.shopxx.entity.PaymentTransaction;

/**
 * Service支付取消事务
 */
public interface PaymentTransactionCancelService extends BaseService<PaymentTransaction, Long> {

	//创建cancel
	void CreatePaymentTransactionCancel(PaymentTransaction paymentTransaction, String refundReason);
}