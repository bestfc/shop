package net.shopxx.service.impl;

import net.shopxx.Results;
import net.shopxx.controller.shop.PaymentController;
import net.shopxx.dao.SnDao;
import net.shopxx.entity.*;
import net.shopxx.exception.BusinessException;
import net.shopxx.plugin.PaymentPlugin;
import net.shopxx.plugin.alipayPayment.AlipayPaymentPlugin;
import net.shopxx.plugin.weixinNativePayment.WeixinNativePaymentPlugin;
import net.shopxx.service.*;
import net.shopxx.util.alibaba.AliPayUtils;
import net.shopxx.util.alibaba.model.AlipayRefundParam;
import net.shopxx.util.tencent.WechatUtils;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.inject.Inject;
import java.math.BigDecimal;
import java.util.*;

@Service
public class PayServiceImpl implements PayService {

    @Inject
    private OrderService orderService;

    @Inject
    private MemberService shopMemberService;

    @Inject
    private PluginService pluginService;

    @Inject
    private PaymentTransactionService paymentTransactionService;

    @Inject
    private SnDao snDao;


    @Inject
    private AlipayPaymentPlugin alipayPaymentPlugin;

    @Inject
    private WeixinNativePaymentPlugin weixinNativePaymentPlugin;

    @Inject
    private WechatUtils wechatPayUtil;

    private Logger log = LoggerFactory.getLogger(this.getClass());

    @Override
    public boolean paymentTransactionCallback(PaymentTransaction paymentTransaction) {

        return false;
    }

    @Override
    public Results appOrderPay(Member member, PaymentController.PaymentItemListForm paymentItemListForm, Boolean containWelfare, Boolean containDeposit, Boolean containWechat, Boolean containAlipay) {

        return null;
    }

    @Override
    public String preDepositRecharge(Long memberId, String thirdpartyPayType, BigDecimal rechargeAmount) {
        return null;
    }

    @Override
    public boolean tradeRefund(PaymentTransaction paymentTransaction, String refundSn, BigDecimal refundAmount, String refundReason) throws BusinessException {
        if(refundAmount.equals(BigDecimal.ZERO))
            return true;
        String paymentPluginId=paymentTransaction.getPaymentPluginId();
        //支付宝
        if (paymentPluginId.contains(PaymentPlugin.ID_Alipay)) {
            return alipayPaymentPlugin.refund(paymentTransaction,refundSn,refundAmount,refundReason);
        }
        //微信
        else if(paymentPluginId.contains(PaymentPlugin.ID_Wechat) || (paymentPluginId.contains(PaymentPlugin.ID_Weixin))) {
            return weixinNativePaymentPlugin.refund(paymentTransaction,refundSn,refundAmount,refundReason);
        }
        log.error("no find PaymentPluginId" + paymentPluginId);
        return false;
    }
}
