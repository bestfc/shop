package net.shopxx.dao;

import net.shopxx.entity.PaymentTransactionCancel;

import java.util.List;

public interface PaymentTransactionCancelDao extends BaseDao<PaymentTransactionCancel, Long> {
    /**
     * 查找所有需要cancel的事务
     */
    List<PaymentTransactionCancel> findCancelList();
}
