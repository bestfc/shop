package net.shopxx.service.impl;

import javax.inject.Inject;

import net.shopxx.dao.OrderItemDao;
import net.shopxx.dao.OrderLogDao;
import net.shopxx.dao.OrderRefundsDao;
import net.shopxx.entity.*;
import net.shopxx.event.OrderCheckCancelEvent;
import net.shopxx.exception.BusinessException;
import net.shopxx.exception.ErrorCode;
import net.shopxx.service.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import net.shopxx.dao.SnDao;

import java.math.BigDecimal;
import java.util.Set;

/**
 * Service订单退款
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Service
public class OrderRefundsServiceImpl extends BaseServiceImpl<OrderRefunds, Long> implements OrderRefundsService {
	interface refundCallback {
		void callback();
	}

	@Inject
	private SnDao snDao;
	@Inject
	private UserService userService;
	@Inject
	private OrderRefundsDao orderRefundsDao;
	@Inject
	private OrderLogDao orderLogDao;
	@Inject
	private MailService mailService;
	@Inject
	private SmsService smsService;
	@Inject
	private OrderItemDao orderItemDao;
	@Inject
	private OrderService orderService;
	@Inject
	private OrderRefundsService orderRefundsService;
	@Inject
	private PayService payService;
	@Inject
	private OrderPaymentService orderPaymentService;
	@Inject
	private ApplicationEventPublisher applicationEventPublisher;
	@Inject
	private MemberService memberService;
	@Inject
	private OrderReturnsService orderReturnsService;

	static final Logger logger = LoggerFactory.getLogger(OrderRefundsServiceImpl.class);

	@Override
	@Transactional
	public OrderRefunds save(OrderRefunds orderRefunds) {
		Assert.notNull(orderRefunds);

		orderRefunds.setSn(snDao.generate(Sn.Type.orderRefunds));

		return super.save(orderRefunds);
	}

	@Override
	public void refundApply(OrderItem orderItem, OrderRefunds orderRefunds) {
		Member member=(Member) userService.<Member>getCurrent();
		Assert.notNull(orderItem);
		Order order = orderItem.getOrder();
		Assert.notNull(order);
		Assert.isTrue(!order.isNew());	//订单不是新创建
		Assert.isTrue(!order.hasExpired());	//订单未过期
		Assert.notNull(orderRefunds);
		Assert.isTrue(orderRefunds.isNew());
		Assert.state(order.getMember().getId()==member.getId());

		orderRefunds.setSn(snDao.generate(Sn.Type.orderRefunds));
		orderRefunds.setOrder(order);
		orderRefunds.setOrderItem(orderItem);
		orderRefunds.setMember(member);
		orderRefunds.setAmount(orderItem.getRefundable());
		orderRefunds.setMethod(OrderRefunds.Method.online);
		orderRefunds.setStatus(OrderRefunds.Status.pendingAudit);

		orderRefundsDao.persist(orderRefunds);
		if(order.getOrderRefunds().size()+1 >= order.getOrderItems().size()){
			order.setStatus(Order.Status.close);
			orderService.update(order);
		}

		OrderLog orderLog = new OrderLog();
		orderLog.setType(OrderLog.Type.refundsApply);
		orderLog.setOrder(order);
		orderLogDao.persist(orderLog);

		mailService.sendRefundsOrderMail(order);
		smsService.sendRefundsOrderSms(order);
	}

	@Override
	public void refundsCancel(OrderRefunds orderRefunds) {
		Member member=(Member)userService.getCurrent();
		Assert.notNull(member);
		Assert.notNull(orderRefunds);
		Assert.isTrue(!orderRefunds.isNew());
		Assert.state(orderRefunds.getStatus()==OrderRefunds.Status.pendingAudit);
		Order order=orderRefunds.getOrder();
		Assert.notNull(order);
		Assert.isTrue(!order.hasExpired());
		Assert.isTrue(orderService.acquireLock(order,member));

		orderRefunds.setStatus(OrderRefunds.Status.canceled);
		update(orderRefunds);

		OrderLog orderLog = new OrderLog();
		orderLog.setType(OrderLog.Type.refunds);
		orderLog.setOrder(order);
		orderLogDao.persist(orderLog);

		mailService.sendRefundsOrderMail(order);
		smsService.sendRefundsOrderSms(order);
	}

	@Override
	public void refundsAudit(OrderRefunds orderRefunds, OrderRefunds.Status status) {
		Order order=orderRefunds.getOrder();
		Assert.notNull(orderRefunds);
		Assert.isTrue(!orderRefunds.isNew());
		Assert.notNull(order);
		Assert.state(orderRefunds.getStatus()==OrderRefunds.Status.pendingAudit);
		Assert.isTrue(!order.hasExpired());

		if(OrderRefunds.Status.audited.equals(status) || OrderRefunds.Status.denied.equals(status)){
			orderRefunds.setStatus(status);
			update(orderRefunds);

			OrderLog orderLog = new OrderLog();
			if (OrderRefunds.Status.audited.equals(status)) {
				orderLog.setType(OrderLog.Type.refundsAudited);
			} else {
				orderLog.setType(OrderLog.Type.refundsDenied);
			}
			orderLog.setOrder(order);
			orderLogDao.persist(orderLog);
		}
	}

	@Override
	public void refundsPay(OrderRefunds orderRefunds, boolean bAdmin) throws Exception {
		Business business = (Business) userService.<Business>getCurrent();
		Assert.notNull(business);
		Assert.notNull(orderRefunds);
		Assert.isTrue(!orderRefunds.isNew());
		Order order=orderRefunds.getOrder();
		Assert.state(business.getStore().equals(order.getStore()));
		Assert.isTrue(order.isAbleRefundableAmount(order.getRefundable()));

		//退款支付
		if (bAdmin) {
			if (orderRefunds.getStatus() != OrderRefunds.Status.audited && orderRefunds.getStatus() != OrderRefunds.Status.denied) {
				throw new BusinessException(ErrorCode.UNAUTHORIZED);
			}
		} else {
			if (orderRefunds.getStatus() != OrderRefunds.Status.audited) {
				throw new BusinessException(ErrorCode.SHOP_REFUND_STATE_NOT_audited);
			}
		}
		if (!(order.getStatus().equals(Order.Status.pendingReview) || order.getStatus().equals(Order.Status.pendingShipment) || order.getStatus().equals(Order.Status.shipped)
				|| order.getStatus().equals(Order.Status.received) || order.getStatus().equals(Order.Status.denied)
				|| order.getStatus().equals(Order.Status.completed) || order.getStatus().equals(Order.Status.close) )) {
			throw new BusinessException(ErrorCode.SHOP_ORDER_STATE_ERROR);
		}
		if (!orderRefunds.getOrder().isAlreadyRefund() || orderRefunds.getStatus().equals(OrderRefunds.Status.audited)) {
			Set<OrderPayment> orderPayments = order.getOrderPayments();
			for (OrderPayment orderPayment : orderPayments) {
				if (orderPayment.getMethod().equals(OrderPayment.Method.online)){
					if (orderPayment.getStatus() == OrderPayment.Status.refunded){
						//已经有退款记录，可能是其他OrderItem退过款的情况
					}
					refundOnline(order, orderPayment.getPaymentTransaction(), orderRefunds.getSn(), orderPayment, orderRefunds.getAmount(), "订单退款", () -> {
						orderPayment.setStatus(OrderPayment.Status.refunded);
						orderPaymentService.update(orderPayment);
					});
				}
				if(orderPayment.getMethod().equals(OrderPayment.Method.deposit)){
					refundDeposit(order, orderPayment, orderPayment.getAmount(), "商城退款", () -> {
						orderPayment.setStatus(OrderPayment.Status.refunded);
						orderPaymentService.update(orderPayment);
					});
				}
			}

		}
		orderRefunds.setStatus(OrderRefunds.Status.refunded); // 已退款
		orderRefundsService.update(orderRefunds);

		OrderLog orderLog = new OrderLog();
		orderLog.setType(OrderLog.Type.refundsRefunded);
		orderLog.setOrder(order);
		orderLog.setOrder(orderRefunds.getOrder());
		orderLogDao.persist(orderLog);

		//检查是否可以设置为关闭状态
		applicationEventPublisher.publishEvent(new OrderCheckCancelEvent(this, order));
	}

	//online退款
	public void refundOnline(Order order, PaymentTransaction paymentTransaction, String refundSn, OrderPayment orderPayment, BigDecimal refundAmountCalc, String reason, refundCallback callback) throws BusinessException {
		if (paymentTransaction == null) {
			logger.error("paymentTransaction是空");
			throw new BusinessException("在线支付事务获取异常");
		}
		if(paymentTransaction.getParent()!=null){
			paymentTransaction=paymentTransaction.getParent();
		}
		//判断是否足够支付
		if (!orderPayment.isAbleRefundableAmount(refundAmountCalc)) {
			throw new BusinessException("退款金额不足，不能退款");
		}

		if (payService.tradeRefund(paymentTransaction, refundSn, refundAmountCalc, reason)) {
			callback.callback();
			orderPayment.setRefundamount(orderPayment.getRefundamount().add(refundAmountCalc));
			orderPaymentService.update(orderPayment);
			order.setAmountPaid(order.getAmountPaid().subtract(refundAmountCalc));
			order.setRefundAmount(order.getRefundAmount().add(refundAmountCalc));
		} else {
			logger.error("在线支付类型错误");
			throw new BusinessException("在线支付类型错误");
		}
	}
	//余额退款
	public void refundDeposit(Order order, OrderPayment orderPayment, BigDecimal refundAmountCalc, String reason, refundCallback callback) throws BusinessException {
		//判断是否足够支付
		if (!orderPayment.isAbleRefundableAmount(refundAmountCalc)) {
			throw new BusinessException("退款金额不足，不能退款");
		}
		memberService.addBalance(order.getMember(), refundAmountCalc,
				MemberDepositLog.Type.orderRefunds, reason);

		callback.callback();
		orderPayment.setRefundamount(orderPayment.getRefundamount().add(refundAmountCalc));
		orderPaymentService.update(orderPayment);
		order.setAmountPaid(order.getAmountPaid().subtract(refundAmountCalc));
		order.setRefundAmount(order.getRefundAmount().add(refundAmountCalc));
	}

	@Override
	public void returns(OrderItem orderItem, OrderReturns orderReturns) {
		Assert.notNull(orderItem);
		Assert.isTrue(!orderItem.isNew());
		//Assert.state(order.getReturnableQuantity() > 0);
		Assert.notNull(orderReturns);
		Assert.isTrue(orderReturns.isNew());
		//Assert.notEmpty(orderReturns.getOrderReturnsItems());
		Order order=orderItem.getOrder();

		orderReturns.setSn(snDao.generate(Sn.Type.orderReturns));
		orderReturns.setOrderItem(orderItem);
		orderReturns.setOrder(order);
		orderReturnsService.save(orderReturns);

		OrderLog orderLog = new OrderLog();
		orderLog.setType(OrderLog.Type.returns);
		orderLog.setOrder(order);
		orderLogDao.persist(orderLog);

		mailService.sendReturnsOrderMail(order);
		smsService.sendReturnsOrderSms(order);
	}

	@Override
	public void orderCancleRefunds(Order order) throws BusinessException {

		Set<OrderPayment> orderPayments = order.getOrderPayments();
		for (OrderPayment orderPayment : orderPayments) {
			//计算退款的金额
			BigDecimal refundAmountCalc = orderPayment.getAmount();
			Set<OrderRefunds> orderRefundsSet = order.getOrderRefunds();
			//如果已有退款记录，减去退过款的金额
			if (orderRefundsSet.size() >= 1) {
				for (OrderRefunds orderRefunds : orderRefundsSet) {
					if (orderRefunds.getStatus().equals(OrderRefunds.Status.refunded)) {
						refundAmountCalc = refundAmountCalc.subtract(orderRefunds.getAmount());
					}
				}
			}

			//判断支付方式
			if (orderPayment.getMethod().equals(OrderPayment.Method.online)) {
				refundOnline(order, orderPayment.getPaymentTransaction(), orderPayment.getSn(), orderPayment, refundAmountCalc, "订单取消", () -> {
					orderPayment.setStatus(OrderPayment.Status.refunded);
					orderPaymentService.update(orderPayment);
				});
			}
			if (orderPayment.getMethod().equals(OrderPayment.Method.deposit)) {
				refundDeposit(order, orderPayment, refundAmountCalc, "商城订单取消", () -> {
					orderPayment.setStatus(OrderPayment.Status.refunded);
					orderPaymentService.update(orderPayment);
				});
			}
		}
	}
}