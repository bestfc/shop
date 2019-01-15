package net.shopxx.service;

import net.shopxx.Results;
import net.shopxx.controller.shop.PaymentController;
import net.shopxx.entity.Member;
import net.shopxx.entity.PaymentTransaction;
import net.shopxx.exception.BusinessException;

import java.math.BigDecimal;

public interface PayService {


    /**
     * APP第三方支付回调，包括订单支付和预存款充值
     * @param paymentTransaction
     * @return
     */
    boolean paymentTransactionCallback(PaymentTransaction paymentTransaction);

    /**
     * APP 订单支付
     * @param paymentItemListForm
     * @param containWelfare
     * @return
     */
    Results appOrderPay(Member member, PaymentController.PaymentItemListForm paymentItemListForm,
                        Boolean containWelfare,
                        Boolean containDeposit,
                        Boolean containWechat,
                        Boolean containAlipay);

    /**
     * App预存款充值前调用,生产支付事务
     * @param memberId
     * @param thirdpartyPayType
     * @param rechargeAmount
     * @return
     */
    String preDepositRecharge(Long memberId, String thirdpartyPayType,BigDecimal rechargeAmount) ;

    /**
     * 订单退款
     * @param paymentTransaction
     * @param refundSn
     * @param refundAmount
     * @param refundReason
     * @return
     */
    boolean tradeRefund(PaymentTransaction paymentTransaction, String refundSn, BigDecimal refundAmount, String refundReason) throws BusinessException;
}
