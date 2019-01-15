/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.member;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.shopxx.ResultBean;
import net.shopxx.entity.*;
import net.shopxx.plugin.PaymentPlugin;
import net.shopxx.service.*;
import org.apache.commons.lang.StringUtils;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import com.fasterxml.jackson.annotation.JsonView;

import net.shopxx.Pageable;
import net.shopxx.Results;
import net.shopxx.Setting;
import net.shopxx.exception.UnauthorizedException;
import net.shopxx.security.CurrentUser;
import net.shopxx.util.SystemUtils;

/**
 * Controller订单
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("memberOrderController")
@RequestMapping("/member/order")
public class OrderController extends BaseController {
	/**
	 * 每页记录数
	 */
	private static final int PAGE_SIZE = 10;

	@Inject
	private OrderService orderService;
	@Inject
	private OrderShippingService orderShippingService;
	@Inject
	private ShippingMethodService shippingMethodService;
	@Inject
	private DeliveryCorpService deliveryCorpService;
	@Inject
    private PaymentTransactionService paymentTransactionService;
	@Inject
    private PluginService pluginService;
	@Inject
	private OrderItemService orderItemService;
	@Inject
	private OrderRefundsService orderRefundsService;
	@Inject
	private ShippingTracesService shippingTracesService;
	/**
	 * 添加属性
	 */
	@ModelAttribute
	public void populateModel(String orderSn, String orderShippingSn, @CurrentUser Member currentUser, ModelMap model) {
		Order order = orderService.findBySn(orderSn);
		if (order != null && !currentUser.equals(order.getMember())) {
			throw new UnauthorizedException();
		}
		model.addAttribute("order", order);

		OrderShipping orderShipping = orderShippingService.findBySn(orderShippingSn);
		if (orderShipping != null && orderShipping.getOrder() != null && !currentUser.equals(orderShipping.getOrder().getMember())) {
			throw new UnauthorizedException();
		}
		model.addAttribute("orderShipping", orderShipping);
	}

	/**
	 * 检查锁定
	 */
	@PostMapping("/check_lock")
	public ResponseEntity<?> checkLock(@ModelAttribute(binding = false) Order order) {
		if (order == null) {
			return Results.NOT_FOUND;
		}

		if (!orderService.acquireLock(order)) {
			return Results.unprocessableEntity("member.order.locked");
		}
		return Results.OK;
	}

	/**
	 * 物流动态
	 */
	@GetMapping("/transit_step")
	public ResponseEntity<?> transitStep(@ModelAttribute(binding = false) OrderShipping orderShipping, @CurrentUser Member currentUser) {
		Map<String, Object> data = new HashMap<>();
		if (orderShipping == null) {
			return Results.NOT_FOUND;
		}

		Setting setting = SystemUtils.getSetting();
		if (StringUtils.isEmpty(setting.getKuaidi100Key()) || StringUtils.isEmpty(orderShipping.getDeliveryCorpCode()) || StringUtils.isEmpty(orderShipping.getTrackingNo())) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		data.put("transitSteps", orderShippingService.getTransitSteps(orderShipping));
		return ResponseEntity.ok(data);
	}

	/**
	 * 列表
	 */
	@RequestMapping("/list")
	public String list(Order.Status status, Boolean hasExpired, Integer pageNumber, @CurrentUser Member currentUser, ModelMap model,
                       @RequestParam(value="orderSns", required=false)String[] orderSns, HttpServletRequest request, HttpServletResponse response) throws Exception {
		//当付款之后没有自动跳转时
		//点击完成付款验证是否付款成功
        if (orderSns != null) {
        	Order order1=orderService.findBySn(orderSns[0]);
			PaymentTransaction transaction=order1.getPaymentTransactions().iterator().next();
			if(transaction.getParent()!=null){
				transaction=transaction.getParent();
			}
			String paymentPluginId=transaction.getPaymentPluginId();
			PaymentPlugin paymentPlugin = StringUtils.isNotEmpty(paymentPluginId) ? pluginService.getPaymentPlugin(paymentPluginId) : null;
			if (paymentPlugin.isPaySuccess(paymentPlugin, transaction, null, null, request, response)) {
				paymentTransactionService.handle(transaction);
			}
        }
		Pageable pageable = new Pageable(pageNumber, PAGE_SIZE);
		Setting setting = SystemUtils.getSetting();
		model.addAttribute("status", status);
		model.addAttribute("hasExpired", hasExpired);
		model.addAttribute("isKuaidi100Enabled", StringUtils.isNotEmpty(setting.getKuaidi100Key()));
		model.addAttribute("page", orderService.findPage(null, status, null, currentUser, null, null, null, null, null, null, hasExpired, pageable));
		return "member/order/list";
	}

	/**
	 * 列表
	 */
	@GetMapping(path = "/list", produces = MediaType.APPLICATION_JSON_VALUE)
	@JsonView(BaseEntity.BaseView.class)
	public ResponseEntity<?> list(Order.Status status, Boolean hasExpired, Integer pageNumber, @CurrentUser Member currentUser) {
		Pageable pageable = new Pageable(pageNumber, PAGE_SIZE);
		return ResponseEntity.ok(orderService.findPage(null, status, null, currentUser, null, null, null, null, null, null, hasExpired, pageable).getContent());
	}

	/**
	 * 查看
	 */
	@GetMapping("/view")
	public String view(@ModelAttribute(binding = false) Order order, @CurrentUser Member currentUser, ModelMap model) {
		if (order == null) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}

		Setting setting = SystemUtils.getSetting();
		//model.addAttribute("isKuaidi100Enabled", StringUtils.isNotEmpty(setting.getKuaidi100Key()));
		model.addAttribute("order", order);
		Set<ShippingTraces> shippingTraces = shippingTracesService.findOrderTraces(order.getId());
		if (shippingTraces.size()>=1){
			model.addAttribute("shippingTraces",shippingTraces);
		}
		return "member/order/view";
	}

	/**
	 * 取消订单
	 */
	@PostMapping("/cancel")
	public ResponseEntity<?> cancel(@ModelAttribute(binding = false) Order order, @CurrentUser Member currentUser) {
		if (order == null) {
			return Results.NOT_FOUND;
		}

		if (order.hasExpired() || (!Order.Status.pendingPayment.equals(order.getStatus()) && !Order.Status.pendingReview.equals(order.getStatus()))) {
			return Results.NOT_FOUND;
		}
		if (!orderService.acquireLock(order, currentUser)) {
			return Results.unprocessableEntity("member.order.locked");
		}
		orderService.cancel(order);
		return Results.OK;
	}

	/**
	 * 收货
	 */
	@PostMapping("/receive")
	public ResponseEntity<?> receive(@ModelAttribute(binding = false) Order order, @CurrentUser Member currentUser) {
		if (order == null) {
			return Results.NOT_FOUND;
		}

		if (order.hasExpired() || !Order.Status.shipped.equals(order.getStatus())) {
			return Results.NOT_FOUND;
		}
		if (!orderService.acquireLock(order, currentUser)) {
			return Results.unprocessableEntity("member.order.locked");
		}
		orderService.receive(order);
		return Results.OK;
	}

	/**
	 * 申请退款页面
	 */
	@GetMapping("/refunds")
	public String refundsPage(String sn, Model model){
		if(sn!=null || sn!=""){
			OrderItem orderItem = orderItemService.findBySn(sn);
			if(orderItem == null){
				return UNPROCESSABLE_ENTITY_VIEW;
			}else{
				model.addAttribute("orderItem",orderItem);
				return "member/order/refunds";
			}
		}
		return UNPROCESSABLE_ENTITY_VIEW;
	}
	/**
	 * 退货页面
	 */
	@GetMapping("/returns")
	public String returnsPage(String sn, ModelMap model){
		OrderItem orderItem=orderItemService.findBySn(sn);
		if (orderItem == null) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		model.addAttribute("orderItem", orderItem);
		model.addAttribute("shippingMethods", shippingMethodService.findAll());
		model.addAttribute("deliveryCorps", deliveryCorpService.findUseTotal());
		return "member/order/returns";
	}
	/**
	 * 申请退款
	 */
	@PostMapping("/refunds-apply")
	public ResponseEntity<?> refundsApply(OrderRefunds refundRequestParam) {
		OrderItem orderItem=orderItemService.findBySn(refundRequestParam.getSn());
		try {
			orderRefundsService.refundApply(orderItem,refundRequestParam);
		}catch (Exception e){
			e.printStackTrace();
			return Results.unprocessableEntity(e.getMessage());
		}
		return Results.OK;
	}

	/**
	 * 子订单退款取消
	 */
	@PostMapping("/refunds-cancel")
	public ResponseEntity<?> refundsCancel(String sn) {
		try {
			OrderItem orderItem = orderItemService.findBySn(sn);
			OrderRefunds orderRefund = orderItem.getOrderRefund();
			orderRefundsService.refundsCancel(orderRefund);
		}catch (Exception e){
			return Results.unprocessableEntity(e.getMessage());
		}
		return Results.OK;
	}


	/**
	 * 退货提交
	 * @param orderReturnsForm
	 * 			退货表单
	 * @param sn
	 * 			关联子订单编号
	 * @param deliveryCorpId
	 * 			快递id
	 * @param member
	 * 			当前用户
	 * @return
	 */
	@PostMapping("/returns-submit")
	public ResponseEntity<?> returnsSubmit(OrderReturns orderReturnsForm,String sn, Long deliveryCorpId, @CurrentUser Member member) {
		OrderItem orderItem=orderItemService.findBySn(sn);
		Order order=orderItem.getOrder();
		if (order == null ) {
			return Results.NOT_FOUND;
		}
		DeliveryCorp deliveryCorp=deliveryCorpService.find(deliveryCorpId);
		if(deliveryCorp == null ){
			return Results.NOT_FOUND;
		}
		orderReturnsForm.setOrderItem(orderItem);
		orderReturnsForm.setOrder(order);
		orderReturnsForm.setDeliveryCorp(deliveryCorp);
		/*if (!orderService.acquireLock(order, member)) {
			return Results.unprocessableEntity("member.order.locked");
		}*/
		orderRefundsService.returns(orderItem, orderReturnsForm);
		return Results.OK;
	}
	@RequestMapping("traces")
	@ResponseBody
	public ResultBean getTraces (Long orderId){
		try{
			return ResultBean.OK(shippingTracesService.findOrderTraces(orderId));
		}catch (Exception e){
			return  ResultBean.Error(e.toString());
		}
	}
}