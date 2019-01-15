/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.business;

import java.math.BigDecimal;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import javax.inject.Inject;

import net.shopxx.*;
import net.shopxx.entity.*;
import net.shopxx.entity.Order;
import net.shopxx.plugin.kdniaoExpress.KdniaoTrackQuery;
import net.shopxx.service.*;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import net.shopxx.exception.UnauthorizedException;
import net.shopxx.security.CurrentStore;
import net.shopxx.security.CurrentUser;
import net.shopxx.util.SystemUtils;

/**
 * Controller订单
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("businessOrderController")
@RequestMapping("/business/order")
public class OrderController extends BaseController {
	Logger logger = LoggerFactory.getLogger(OrderController.class);

	@Inject
	private AreaService areaService;
	@Inject
	private OrderService orderService;
	@Inject
	private ShippingMethodService shippingMethodService;
	@Inject
	private PaymentMethodService paymentMethodService;
	@Inject
	private DeliveryCorpService deliveryCorpService;
	@Inject
	private OrderShippingService orderShippingService;
	@Inject
	private MemberService memberService;
	@Inject
	private OrderRefundsService orderRefundsService;
	@Inject
	private KdniaoTrackQuery kdniaoTrackQuery;
	@Inject
	private ShippingTracesService shippingTracesService;
	/**
	 * 添加属性
	 */
	@ModelAttribute
	public void populateModel(Long orderId, @CurrentStore Store currentStore, ModelMap model) {
		Order order = orderService.find(orderId);
		if (order != null && !currentStore.equals(order.getStore())) {
			throw new UnauthorizedException();
		}
		model.addAttribute("order", order);
	}

	/**
	 * 获取订单锁
	 */
	@PostMapping("/acquire_lock")
	public @ResponseBody boolean acquireLock(@ModelAttribute(binding = false) Order order) {
		return order != null && orderService.acquireLock(order);
	}

	/**
	 * 计算
	 */
	@PostMapping("/calculate")
	public ResponseEntity<?> calculate(@ModelAttribute(binding = false) Order order, BigDecimal freight, BigDecimal tax, BigDecimal offsetAmount) {
		if (order == null) {
			return Results.UNPROCESSABLE_ENTITY;
		}

		Map<String, Object> data = new HashMap<>();
		data.put("amount", orderService.calculateAmount(order.getPrice(), order.getFee(), freight, tax, order.getPromotionDiscount(), order.getCouponDiscount(), offsetAmount));
		return ResponseEntity.ok(data);
	}

	/**
	 * 物流动态
	 */
	@GetMapping("/transit_step")
	public ResponseEntity<?> transitStep(Long shippingId, @CurrentStore Store currentStore) {
		Map<String, Object> data = new HashMap<>();
		OrderShipping orderShipping = orderShippingService.find(shippingId);
		if (orderShipping == null || !currentStore.equals(orderShipping.getOrder().getStore())) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		Setting setting = SystemUtils.getSetting();
		if (StringUtils.isEmpty(setting.getKuaidi100Key()) || StringUtils.isEmpty(orderShipping.getDeliveryCorpCode()) || StringUtils.isEmpty(orderShipping.getTrackingNo())) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		data.put("transitSteps", orderShippingService.getTransitSteps(orderShipping));
		return ResponseEntity.ok(data);
	}

	/**
	 * 编辑
	 */
	@GetMapping("/edit")
	public String edit(@ModelAttribute(binding = false) Order order, ModelMap model) {
		if (order == null || order.hasExpired() || (!Order.Status.pendingPayment.equals(order.getStatus()) && !Order.Status.pendingReview.equals(order.getStatus()))) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		model.addAttribute("paymentMethods", paymentMethodService.findAll());
		model.addAttribute("shippingMethods", shippingMethodService.findAll());
		model.addAttribute("order", order);
		return "business/order/edit";
	}

	/**
	 * 更新
	 */
	@PostMapping("/update")
	public String update(@ModelAttribute(binding = false) Order order, Long areaId, Long paymentMethodId, Long shippingMethodId, BigDecimal freight, BigDecimal tax, BigDecimal offsetAmount, Long rewardPoint, String consignee, String address, String zipCode, String phone, String invoiceTitle,
			String memo, @CurrentUser Business currentUser, RedirectAttributes redirectAttributes) {
		Area area = areaService.find(areaId);
		PaymentMethod paymentMethod = paymentMethodService.find(paymentMethodId);
		ShippingMethod shippingMethod = shippingMethodService.find(shippingMethodId);

		if (order == null || !orderService.acquireLock(order)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (order.hasExpired() || (!Order.Status.pendingPayment.equals(order.getStatus()) && !Order.Status.pendingReview.equals(order.getStatus()))) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}

		Invoice invoice = StringUtils.isNotEmpty(invoiceTitle) ? new Invoice(invoiceTitle, null) : null;
		order.setTax(invoice != null ? tax : BigDecimal.ZERO);
		order.setOffsetAmount(offsetAmount);
		order.setRewardPoint(rewardPoint);
		order.setMemo(memo);
		order.setInvoice(invoice);
		order.setPaymentMethod(paymentMethod);
		if (order.getIsDelivery()) {
			order.setFreight(freight);
			order.setConsignee(consignee);
			order.setAddress(address);
			order.setZipCode(zipCode);
			order.setPhone(phone);
			order.setArea(area);
			order.setShippingMethod(shippingMethod);
			if (!isValid(order, Order.Delivery.class)) {
				return UNPROCESSABLE_ENTITY_VIEW;
			}
		} else {
			order.setFreight(BigDecimal.ZERO);
			order.setConsignee(null);
			order.setAreaName(null);
			order.setAddress(null);
			order.setZipCode(null);
			order.setPhone(null);
			order.setShippingMethodName(null);
			order.setArea(null);
			order.setShippingMethod(null);
			if (!isValid(order)) {
				return UNPROCESSABLE_ENTITY_VIEW;
			}
		}
		orderService.modify(order);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 查看
	 */
	@GetMapping("/view")
	public String view(@ModelAttribute(binding = false) Order order, ModelMap model) {
		if (order == null) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}

		Setting setting = SystemUtils.getSetting();
		model.addAttribute("methods", OrderPayment.Method.values());
		model.addAttribute("refundsMethods", OrderRefunds.Method.values());
		model.addAttribute("paymentMethods", paymentMethodService.findAll());
		model.addAttribute("shippingMethods", shippingMethodService.findAll());
		model.addAttribute("deliveryCorps", deliveryCorpService.findAll());
		model.addAttribute("isKuaidi100Enabled", StringUtils.isNotEmpty(setting.getKuaidi100Key()));
		model.addAttribute("order", order);
		return "business/order/view";
	}

	/**
	 * 审核
	 */
	@PostMapping("/review")
	public String review(@ModelAttribute(binding = false) Order order, Boolean passed, @CurrentUser Business currentUser, RedirectAttributes redirectAttributes) {
		if (order == null || order.hasExpired() || !Order.Status.pendingReview.equals(order.getStatus()) || passed == null) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (!orderService.acquireLock(order, currentUser)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		orderService.review(order, passed);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:view?orderId=" + order.getId();
	}

	/**
	 * 收款
	 */
	@PostMapping("/payment")
	public String payment(OrderPayment orderPaymentForm, @ModelAttribute(binding = false) Order order, Long paymentMethodId, @CurrentUser Business currentUser, @CurrentStore Store currentStore, RedirectAttributes redirectAttributes) {
		if (order == null || !Store.Type.self.equals(currentStore.getType())) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		orderPaymentForm.setOrder(order);
		orderPaymentForm.setPaymentMethod(paymentMethodService.find(paymentMethodId));
		if (!isValid(orderPaymentForm)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (!orderService.acquireLock(order, currentUser)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		orderPaymentForm.setFee(BigDecimal.ZERO);
		orderService.payment(order, orderPaymentForm);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:view?orderId=" + order.getId();
	}

	/**
	 * 退款
	 */
	@PostMapping("/refunds")
	public String refunds(OrderRefunds orderRefundsForm, @ModelAttribute(binding = false) Order order, Long paymentMethodId, @CurrentUser Business currentUser, RedirectAttributes redirectAttributes) {
		if (order == null || order.hasExpired() || order.getRefundableAmount().compareTo(BigDecimal.ZERO) <= 0) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		orderRefundsForm.setOrder(order);
		orderRefundsForm.setPaymentMethod(paymentMethodService.find(paymentMethodId));
		if (!isValid(orderRefundsForm)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (OrderRefunds.Method.deposit.equals(orderRefundsForm.getMethod()) && orderRefundsForm.getAmount().compareTo(order.getStore().getBusiness().getBalance()) > 0) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (!orderService.acquireLock(order, currentUser)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		//orderRefundsService.refunds(orderItem, orderRefundsForm);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:view?orderId=" + order.getId();
	}

	/**
	 * 退款审核
	 */
	@PostMapping("/refunds-audit")
	@ResponseBody
	public ResultBean refundsAudit(Long refundID, OrderRefunds.Status status, RedirectAttributes redirectAttributes) {
		if (refundID == null) {
			return ResultBean.Error();
		}
		try {
			orderRefundsService.refundsAudit(orderRefundsService.find(refundID), status);
		} catch (Exception e) {
			return ResultBean.Error(e.getMessage());
		}
		return ResultBean.OK();
	}

	/**
	 * 退款支付
	 *
	 * @param refundID
	 * @return
	 */
	@PostMapping("/refunds-pay")
	@ResponseBody
	public ResultBean refundsPay(Long refundID) {
		if (refundID == null ) {
			return ResultBean.Error();
		}
		OrderRefunds orderRefunds = orderRefundsService.find(refundID);
		if(orderRefunds == null || orderRefunds.getOrder() == null || orderRefunds.getOrder().hasExpired()){
			return ResultBean.Error();
		}
		if(orderRefunds.getOrder().isAlreadyRefund() && orderRefunds.getStatus().equals(OrderRefunds.Status.refunded))
			return ResultBean.OK("重复操作");
		try {
			orderRefundsService.refundsPay(orderRefunds, false);
		} catch (Exception e) {
			return ResultBean.Error();
		}
		return ResultBean.OK();
	}


	/**
	 * 发货
	 */
	@PostMapping("/shipping")
	public String shipping(OrderShipping orderShippingForm, @ModelAttribute(binding = false) Order order, Long shippingMethodId, Long deliveryCorpId, Long areaId, @CurrentUser Business currentUser, RedirectAttributes redirectAttributes) {
		if (order == null || order.getShippableQuantity() <= 0) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		boolean isDelivery = false;
		for (Iterator<OrderShippingItem> iterator = orderShippingForm.getOrderShippingItems().iterator(); iterator.hasNext();) {
			OrderShippingItem orderShippingItem = iterator.next();
			if (orderShippingItem == null || StringUtils.isEmpty(orderShippingItem.getSn()) || orderShippingItem.getQuantity() == null || orderShippingItem.getQuantity() <= 0) {
				iterator.remove();
				continue;
			}
			OrderItem orderItem = order.getOrderItem(orderShippingItem.getSn());
			if (orderItem == null || orderShippingItem.getQuantity() > orderItem.getShippableQuantity()) {
				return UNPROCESSABLE_ENTITY_VIEW;
			}
			Sku sku = orderItem.getSku();
			if (sku != null && orderShippingItem.getQuantity() > sku.getStock()) {
				return UNPROCESSABLE_ENTITY_VIEW;
			}
			orderShippingItem.setName(orderItem.getName());
			orderShippingItem.setIsDelivery(orderItem.getIsDelivery());
			orderShippingItem.setSku(sku);
			orderShippingItem.setOrderShipping(orderShippingForm);
			orderShippingItem.setSpecifications(orderItem.getSpecifications());
			if (orderItem.getIsDelivery()) {
				isDelivery = true;
			}
		}
		orderShippingForm.setOrder(order);
		orderShippingForm.setShippingMethod(shippingMethodService.find(shippingMethodId));
		orderShippingForm.setDeliveryCorp(deliveryCorpService.find(deliveryCorpId));
		Area area=areaService.find(areaId);
		orderShippingForm.setArea(area);
		if (isDelivery) {
			if (!isValid(orderShippingForm, OrderShipping.Delivery.class)) {
				return UNPROCESSABLE_ENTITY_VIEW;
			}
		} else {
			orderShippingForm.setShippingMethod((String) null);
			orderShippingForm.setDeliveryCorp((String) null);
			orderShippingForm.setDeliveryCorpUrl(null);
			orderShippingForm.setDeliveryCorpCode(null);
			orderShippingForm.setTrackingNo(null);
			orderShippingForm.setFreight(null);
			orderShippingForm.setConsignee(null);
			orderShippingForm.setArea((String) null);
			orderShippingForm.setAddress(null);
			orderShippingForm.setZipCode(null);
			orderShippingForm.setPhone(null);
			if (!isValid(orderShippingForm)) {
				return UNPROCESSABLE_ENTITY_VIEW;
			}
		}
		if (!orderService.acquireLock(order, currentUser)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		orderService.shipping(order, orderShippingForm);
		if(orderShippingForm.getTrackingNo() != null){
			if(kdniaoTrackQuery.orderTracesSubByJson(orderShippingForm,area)){
				ShippingTraces shippingTraces=new ShippingTraces();
				shippingTraces.setTrackingNo(orderShippingForm.getTrackingNo());
				shippingTraces.setDeliveryCorpCode(orderShippingForm.getDeliveryCorpCode());
				shippingTraces.setDeliveryCorp(orderShippingForm.getDeliveryCorp());
				shippingTraces.setCreatedDate(new Date());
				shippingTraces.setLastModifiedDate(new Date());
				shippingTraces.setVersion(1L);
				shippingTracesService.save(shippingTraces);
				logger.info("》》》已订阅"+orderShippingForm.getDeliveryCorp()+orderShippingForm.getTrackingNo()+"的信息《《《");
			}
		}
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:view?orderId=" + order.getId();
	}

	/**
	 * 退货
	 */
	@PostMapping("/returns")
	public String returns(OrderReturns orderReturnsForm, @ModelAttribute(binding = false) Order order, Long shippingMethodId, Long deliveryCorpId, Long areaId, @CurrentUser Business currentUser, RedirectAttributes redirectAttributes) {
		if (order == null || order.getReturnableQuantity() <= 0) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		for (Iterator<OrderReturnsItem> iterator = orderReturnsForm.getOrderReturnsItems().iterator(); iterator.hasNext();) {
			OrderReturnsItem orderReturnsItem = iterator.next();
			if (orderReturnsItem == null || StringUtils.isEmpty(orderReturnsItem.getSn()) || orderReturnsItem.getQuantity() == null || orderReturnsItem.getQuantity() <= 0) {
				iterator.remove();
				continue;
			}
			OrderItem orderItem = order.getOrderItem(orderReturnsItem.getSn());
			if (orderItem == null || orderReturnsItem.getQuantity() > orderItem.getReturnableQuantity()) {
				return UNPROCESSABLE_ENTITY_VIEW;
			}
			orderReturnsItem.setName(orderItem.getName());
			orderReturnsItem.setOrderReturns(orderReturnsForm);
			orderReturnsItem.setSpecifications(orderItem.getSpecifications());
		}
		orderReturnsForm.setOrder(order);
		orderReturnsForm.setShippingMethod(shippingMethodService.find(shippingMethodId));
		orderReturnsForm.setDeliveryCorp(deliveryCorpService.find(deliveryCorpId));
		orderReturnsForm.setArea(areaService.find(areaId));
		if (!isValid(orderReturnsForm)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (!orderService.acquireLock(order, currentUser)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		//orderRefundsService.returns(orderItem, orderReturnsForm);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:view?orderId=" + order.getId();
	}

	/**
	 * 完成
	 */
	@PostMapping("/complete")
	public String complete(@ModelAttribute(binding = false) Order order, @CurrentUser Business currentUser, RedirectAttributes redirectAttributes) {
		if (order == null || order.hasExpired() || !Order.Status.received.equals(order.getStatus())) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (!orderService.acquireLock(order, currentUser)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		orderService.complete(order);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:view?orderId=" + order.getId();
	}

	/**
	 * 失败
	 */
	@PostMapping("/fail")
	public String fail(@ModelAttribute(binding = false) Order order, @CurrentUser Business currentUser, RedirectAttributes redirectAttributes) {
		if (order == null || order.hasExpired() || (!Order.Status.pendingShipment.equals(order.getStatus()) && !Order.Status.shipped.equals(order.getStatus()) && !Order.Status.received.equals(order.getStatus()))) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (!orderService.acquireLock(order, currentUser)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		orderService.fail(order);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:view?orderId=" + order.getId();
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Order.Type type, Order.Status status, String memberUsername, Boolean isPendingReceive, Boolean isPendingRefunds, Boolean isAllocatedStock, Boolean hasExpired, Pageable pageable, @CurrentStore Store currentStore, ModelMap model) {
		model.addAttribute("types", Order.Type.values());
		model.addAttribute("statuses", Order.Status.values());
		model.addAttribute("type", type);
		model.addAttribute("status", status);
		model.addAttribute("memberUsername", memberUsername);
		model.addAttribute("isPendingReceive", isPendingReceive);
		model.addAttribute("isPendingRefunds", isPendingRefunds);
		model.addAttribute("isAllocatedStock", isAllocatedStock);
		model.addAttribute("hasExpired", hasExpired);

		Member member = memberService.findByUsername(memberUsername);
		if (StringUtils.isNotEmpty(memberUsername) && member == null) {
			model.addAttribute("page", Page.emptyPage(pageable));
		} else {
			model.addAttribute("page", orderService.findPage(type, status, currentStore, member, null, isPendingReceive, isPendingRefunds, null, null, isAllocatedStock, hasExpired, pageable));
		}
		return "business/order/list";
	}

	/**
	 * 删除
	 */
	@PostMapping("/delete")
	public ResponseEntity<?> delete(Long[] ids, @CurrentUser Business currentUser, @CurrentStore Store currentStore) {
		if (ids != null) {
			for (Long id : ids) {
				Order order = orderService.find(id);
				if (order == null || !currentStore.equals(order.getStore())) {
					return Results.UNPROCESSABLE_ENTITY;
				}
				if (!orderService.acquireLock(order, currentUser)) {
					return Results.unprocessableEntity("business.order.deleteLockedNotAllowed", order.getSn());
				}
				if (!order.canDelete()) {
					return Results.unprocessableEntity("business.order.deleteStatusNotAllowed", order.getSn());
				}
			}
			orderService.delete(ids);
		}
		return Results.OK;
	}

}