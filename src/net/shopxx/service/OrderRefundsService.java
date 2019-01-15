/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service;

import net.shopxx.entity.Order;
import net.shopxx.entity.OrderItem;
import net.shopxx.entity.OrderRefunds;
import net.shopxx.entity.OrderReturns;
import net.shopxx.exception.BusinessException;

/**
 * Service订单退款
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
public interface OrderRefundsService extends BaseService<OrderRefunds, Long> {
    /**
     * 订单退款申请，与子订单关联
     *
     * @param orderItem    订单
     * @param orderRefunds 订单退款
     */
    void refundApply(OrderItem orderItem, OrderRefunds orderRefunds);

    /**
     * 用户取消退款
     *
     * @param orderRefunds
     */
    void refundsCancel(OrderRefunds orderRefunds);


    /**
     * 订单退款审核
     *
     * @param orderRefunds
     * @param status
     */
    void refundsAudit(OrderRefunds orderRefunds, OrderRefunds.Status status);

    /**
     * 订单退款打款
     *
     * @param orderRefunds
     */
    void refundsPay(OrderRefunds orderRefunds, boolean bAdmin) throws Exception;


    /**
     * 订单退货
     *
     * @param orderItem    子订单
     * @param orderReturns 订单退货
     */
    void returns(OrderItem orderItem, OrderReturns orderReturns);

    /**
     * 取消订单时的退款操作
     * @param order     订单
     */
    void orderCancleRefunds(Order order) throws BusinessException;
}