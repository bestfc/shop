/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.shop;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.inject.Inject;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fasterxml.jackson.annotation.JsonView;

import net.shopxx.Results;
import net.shopxx.entity.BaseEntity;
import net.shopxx.entity.Cart;
import net.shopxx.entity.CartItem;
import net.shopxx.entity.Coupon;
import net.shopxx.entity.CouponCode;
import net.shopxx.entity.Invoice;
import net.shopxx.entity.Member;
import net.shopxx.entity.Order;
import net.shopxx.entity.PaymentMethod;
import net.shopxx.entity.Product;
import net.shopxx.entity.Receiver;
import net.shopxx.entity.ShippingMethod;
import net.shopxx.entity.Sku;
import net.shopxx.entity.Store;
import net.shopxx.plugin.PaymentPlugin;
import net.shopxx.security.CurrentCart;
import net.shopxx.security.CurrentUser;
import net.shopxx.service.AreaService;
import net.shopxx.service.CouponCodeService;
import net.shopxx.service.OrderService;
import net.shopxx.service.PaymentMethodService;
import net.shopxx.service.PluginService;
import net.shopxx.service.ReceiverService;
import net.shopxx.service.ShippingMethodService;
import net.shopxx.service.SkuService;
import net.shopxx.util.WebUtils;

/**
 * Controller订单
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("shopOrderController")
@RequestMapping("/order")
public class OrderController extends BaseController {

	@Inject
	private SkuService skuService;
	@Inject
	private AreaService areaService;
	@Inject
	private ReceiverService receiverService;
	@Inject
	private PaymentMethodService paymentMethodService;
	@Inject
	private ShippingMethodService shippingMethodService;
	@Inject
	private CouponCodeService couponCodeService;
	@Inject
	private OrderService orderService;
	@Inject
	private PluginService pluginService;

	/**
	 * 检查积分兑换
	 */
	@GetMapping("/check_exchange")
	public ResponseEntity<?> checkExchange(Long skuId, Integer quantity, @CurrentUser Member currentUser) {
		if (quantity == null || quantity < 1) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		Sku sku = skuService.find(skuId);
		if (sku == null) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (!Product.Type.exchange.equals(sku.getType())) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (!sku.getIsActive()) {
			return Results.unprocessableEntity("shop.order.skuNotActive");
		}
		if (!sku.getIsMarketable()) {
			return Results.unprocessableEntity("shop.order.skuNotMarketable");
		}
		if (quantity > sku.getAvailableStock()) {
			return Results.unprocessableEntity("shop.order.skuLowStock");
		}
		if (currentUser.getPoint() < sku.getExchangePoint() * quantity) {
			return Results.unprocessableEntity("shop.order.lowPoint");
		}
		return Results.OK;
	}

	/**
	 * 获取收货地址
	 */
	@GetMapping("/receiver_list")
	@JsonView(BaseEntity.BaseView.class)
	public ResponseEntity<?> receiverList(@CurrentUser Member currentUser) {
		return ResponseEntity.ok(receiverService.findList(currentUser));
	}

	/**
	 * 保存收货地址
	 */
	@PostMapping("/save_receiver")
	@JsonView(BaseEntity.BaseView.class)
	public ResponseEntity<?> saveReceiver(Receiver receiver, Long areaId, @CurrentUser Member currentUser) {
		receiver.setArea(areaService.find(areaId));
		if (!isValid(receiver)) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (Receiver.MAX_RECEIVER_COUNT != null && currentUser.getReceivers().size() >= Receiver.MAX_RECEIVER_COUNT) {
			return Results.unprocessableEntity("shop.order.addReceiverCountNotAllowed", Receiver.MAX_RECEIVER_COUNT);
		}
		receiver.setAreaName(null);
		receiver.setMember(currentUser);
		return ResponseEntity.ok(receiverService.save(receiver));
	}

	/**
	 * 订单锁定
	 */
	@PostMapping("/lock")
	public @ResponseBody void lock(String[] orderSns, @CurrentUser Member currentUser) {
		for (String orderSn : orderSns) {
			Order order = orderService.findBySn(orderSn);
			if (order != null && currentUser.equals(order.getMember()) && order.getPaymentMethod() != null && PaymentMethod.Method.online.equals(order.getPaymentMethod().getMethod()) && order.getAmountPayable().compareTo(BigDecimal.ZERO) > 0) {
				orderService.acquireLock(order, currentUser);
			}
		}
	}

	/**
	 * 检查等待付款
	 */
	@GetMapping("/check_pending_payment")
	public @ResponseBody boolean checkPendingPayment(String[] orderSns, @CurrentUser Member currentUser) {
		boolean flag = false;
		for (String orderSn : orderSns) {
			Order order = orderService.findBySn(orderSn);
			flag = order != null && currentUser.equals(order.getMember()) && order.getPaymentMethod() != null && PaymentMethod.Method.online.equals(order.getPaymentMethod().getMethod()) && order.getAmountPayable().compareTo(BigDecimal.ZERO) > 0;
		}
		return flag;
	}

	/**
	 * 检查优惠券
	 */
	@GetMapping("/check_coupon")
	public ResponseEntity<?> checkCoupon(String code, @CurrentCart Cart currentCart) {
		Map<String, Object> data = new HashMap<>();
		if (currentCart == null || currentCart.isEmpty()) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		CouponCode couponCode = couponCodeService.findByCode(code);
		if (couponCode != null && couponCode.getCoupon() != null) {
			Coupon coupon = couponCode.getCoupon();
			Store store = coupon.getStore();
			if (couponCode.getIsUsed()) {
				return Results.unprocessableEntity("shop.order.couponCodeUsed");
			}
			if (!coupon.getIsEnabled()) {
				return Results.unprocessableEntity("shop.order.couponDisabled");
			}
			if (!coupon.hasBegun()) {
				return Results.unprocessableEntity("shop.order.couponNotBegin");
			}
			if (coupon.hasExpired()) {
				return Results.unprocessableEntity("shop.order.couponHasExpired");
			}
			if (!currentCart.isValid(coupon, store)) {
				return Results.unprocessableEntity("shop.order.couponInvalid");
			}
			if (currentCart.getStores().contains(store) && !currentCart.isCouponAllowed(store)) {
				return Results.unprocessableEntity("shop.order.couponNotAllowed");
			}
			data.put("couponName", coupon.getName());
			return ResponseEntity.ok(data);
		} else {
			return Results.unprocessableEntity("shop.order.couponCodeNotExist");
		}
	}

	/**
	 * 结算
	 */
	@GetMapping("/checkout")
	public String checkout(@CurrentUser Member currentUser, @CurrentCart Cart currentCart, ModelMap model, RedirectAttributes redirectAttributes) {
		if (currentCart == null || currentCart.isEmpty()) {
			return "redirect:/cart/list";
		}
		if (currentCart.hasNotActive(null)) {
			addFlashMessage(redirectAttributes, "shop.order.hasNotActive");
			return "redirect:/cart/list";
		}
		if (currentCart.hasNotMarketable(null)) {
			addFlashMessage(redirectAttributes, "shop.order.hasNotMarketable");
			return "redirect:/cart/list";
		}
		Receiver defaultReceiver = receiverService.findDefault(currentUser);
		List<Order> orders = orderService.generate(Order.Type.general, currentCart, defaultReceiver, null, null, null, null, null, null);

		BigDecimal price = BigDecimal.ZERO;
		BigDecimal fee = BigDecimal.ZERO;
		BigDecimal freight = BigDecimal.ZERO;
		BigDecimal tax = BigDecimal.ZERO;
		BigDecimal promotionDiscount = BigDecimal.ZERO;
		BigDecimal amount = BigDecimal.ZERO;
		BigDecimal amountPayable = BigDecimal.ZERO;
		BigDecimal couponDiscount = BigDecimal.ZERO;
		Long rewardPoint = 0L;
		Boolean isDelivery = false;

		for (Order order : orders) {
			price = price.add(order.getPrice());
			fee = fee.add(order.getFee());
			freight = freight.add(order.getFreight());
			tax = fee.add(order.getTax());
			promotionDiscount = promotionDiscount.add(order.getPromotionDiscount());
			couponDiscount = couponDiscount.add(order.getCouponDiscount());
			amount = amount.add(order.getAmount());
			amountPayable = amountPayable.add(order.getAmountPayable());
			rewardPoint = rewardPoint + order.getRewardPoint();
			if (order.getIsDelivery()) {
				isDelivery = true;
			}
		}

		model.addAttribute("price", price);
		model.addAttribute("fee", fee);
		model.addAttribute("freight", freight);
		model.addAttribute("tax", tax);
		model.addAttribute("promotionDiscount", promotionDiscount);
		model.addAttribute("couponDiscount", couponDiscount);
		model.addAttribute("amount", amount);
		model.addAttribute("amountPayable", amountPayable);
		model.addAttribute("isDelivery", isDelivery);
		model.addAttribute("rewardPoint", rewardPoint);
		model.addAttribute("orderType", Order.Type.general);
		model.addAttribute("orders", orders);
		model.addAttribute("defaultReceiver", defaultReceiver);
		model.addAttribute("cartTag", currentCart.getTag());
		List<PaymentMethod> paymentMethods = paymentMethodService.findAll();
		List<PaymentMethod> availablePaymentMethods = new ArrayList<>();
		for (PaymentMethod paymentMethod : paymentMethods) {
			if (currentCart.isContainGeneral()) {
				if (paymentMethod.getMethod().equals(PaymentMethod.Method.online)) {
					availablePaymentMethods.add(paymentMethod);
				}
			} else {
				availablePaymentMethods.add(paymentMethod);
			}
		}
		model.addAttribute("member", currentUser);
		model.addAttribute("paymentMethods", availablePaymentMethods);
		model.addAttribute("shippingMethods", shippingMethodService.findAll());
		return "shop/order/checkout";
	}

	/**
	 * 结算
	 */
	@GetMapping(path = "/checkout", params = "type=exchange")
	public String checkout(Long skuId, Integer quantity, @CurrentUser Member currentUser, ModelMap model) {
		if (quantity == null || quantity < 1) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		Sku sku = skuService.find(skuId);
		if (sku == null) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (!Product.Type.exchange.equals(sku.getType())) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (!sku.getIsActive()) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (!sku.getIsMarketable()) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (quantity > sku.getAvailableStock()) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (currentUser.getPoint() < sku.getExchangePoint() * quantity) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		Set<CartItem> cartItems = new HashSet<>();
		CartItem cartItem = new CartItem();
		cartItem.setSku(sku);
		cartItem.setQuantity(quantity);
		cartItems.add(cartItem);
		Cart cart = new Cart();
		cart.setMember(currentUser);
		cart.setCartItems(cartItems);
		Receiver defaultReceiver = receiverService.findDefault(currentUser);
		List<Order> orders = orderService.generate(Order.Type.exchange, cart, defaultReceiver, null, null, null, null, null, null);

		Long exchangePoint = 0L;
		Long rewardPoint = 0L;
		Boolean isDelivery = false;
		BigDecimal fee = BigDecimal.ZERO;
		BigDecimal freight = BigDecimal.ZERO;
		BigDecimal tax = BigDecimal.ZERO;
		BigDecimal promotionDiscount = BigDecimal.ZERO;
		BigDecimal amount = BigDecimal.ZERO;
		BigDecimal amountPayable = BigDecimal.ZERO;
		BigDecimal couponDiscount = BigDecimal.ZERO;

		for (Order order : orders) {
			exchangePoint = exchangePoint + order.getExchangePoint();
			rewardPoint = rewardPoint + order.getRewardPoint();
			fee = fee.add(order.getFee());
			freight = freight.add(order.getFreight());
			tax = fee.add(order.getTax());
			promotionDiscount = promotionDiscount.add(order.getPromotionDiscount());
			couponDiscount = couponDiscount.add(order.getCouponDiscount());
			amount = amount.add(order.getAmount());
			amountPayable = amountPayable.add(order.getAmountPayable());
			if (order.getIsDelivery()) {
				isDelivery = true;
			}
		}

		model.addAttribute("orders", orders);
		model.addAttribute("exchangePoint", exchangePoint);
		model.addAttribute("rewardPoint", rewardPoint);
		model.addAttribute("fee", fee);
		model.addAttribute("freight", freight);
		model.addAttribute("tax", tax);
		model.addAttribute("promotionDiscount", promotionDiscount);
		model.addAttribute("couponDiscount", couponDiscount);
		model.addAttribute("amount", amount);
		model.addAttribute("amountPayable", amountPayable);
		model.addAttribute("skuId", skuId);
		model.addAttribute("quantity", quantity);
		model.addAttribute("isDelivery", isDelivery);
		model.addAttribute("orderType", Order.Type.exchange);
		model.addAttribute("defaultReceiver", defaultReceiver);
		model.addAttribute("paymentMethods", paymentMethodService.findAll());
		List<PaymentMethod> paymentMethods = paymentMethodService.findAll();
		List<PaymentMethod> availablePaymentMethods = new ArrayList<>();
		for (PaymentMethod paymentMethod : paymentMethods) {
			if (cart.isContainGeneral()) {
				if (paymentMethod.getMethod().equals(PaymentMethod.Method.online)) {
					availablePaymentMethods.add(paymentMethod);
				}
			} else {
				availablePaymentMethods.add(paymentMethod);
			}
		}
		model.addAttribute("shippingMethods", shippingMethodService.findAll());
		return "shop/order/checkout";
	}

	/**
	 * 计算
	 */
	@GetMapping("/calculate")
	public ResponseEntity<?> calculate(Long receiverId, Long paymentMethodId, Long shippingMethodId, String code, String invoiceTitle, BigDecimal balance, String memo, @CurrentUser Member currentUser, @CurrentCart Cart currentCart) {
		Map<String, Object> data = new HashMap<>();
		if (currentCart == null || currentCart.isEmpty()) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		Receiver receiver = receiverService.find(receiverId);
		if (receiver != null && !currentUser.equals(receiver.getMember())) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (balance != null && balance.compareTo(BigDecimal.ZERO) < 0) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (balance != null && balance.compareTo(currentUser.getBalance()) > 0) {
			return Results.unprocessableEntity("shop.order.insufficientBalance");
		}

		PaymentMethod paymentMethod = paymentMethodService.find(paymentMethodId);
		ShippingMethod shippingMethod = shippingMethodService.find(shippingMethodId);
		CouponCode couponCode = couponCodeService.findByCode(code);
		Invoice invoice = StringUtils.isNotEmpty(invoiceTitle) ? new Invoice(invoiceTitle, null) : null;
		List<Order> orders = orderService.generate(Order.Type.general, currentCart, receiver, paymentMethod, shippingMethod, couponCode, invoice, balance, memo);

		BigDecimal price = BigDecimal.ZERO;
		BigDecimal fee = BigDecimal.ZERO;
		BigDecimal freight = BigDecimal.ZERO;
		BigDecimal tax = BigDecimal.ZERO;
		BigDecimal promotionDiscount = BigDecimal.ZERO;
		BigDecimal amount = BigDecimal.ZERO;
		BigDecimal amountPayable = BigDecimal.ZERO;
		BigDecimal couponDiscount = BigDecimal.ZERO;

		for (Order order : orders) {
			price = price.add(order.getPrice());
			fee = fee.add(order.getFee());
			freight = freight.add(order.getFreight());
			tax = fee.add(order.getTax());
			promotionDiscount = promotionDiscount.add(order.getPromotionDiscount());
			couponDiscount = couponDiscount.add(order.getCouponDiscount());
			amount = amount.add(order.getAmount());
			amountPayable = amountPayable.add(order.getAmountPayable());
		}

		data.put("price", price);
		data.put("fee", fee);
		data.put("freight", freight);
		data.put("tax", tax);
		data.put("promotionDiscount", promotionDiscount);
		data.put("couponDiscount", couponDiscount);
		data.put("amount", amount);
		data.put("amountPayable", amountPayable);
		return ResponseEntity.ok(data);
	}

	/**
	 * 计算
	 */
	@GetMapping(path = "/calculate", params = "type=exchange")
	public ResponseEntity<?> calculate(Long skuId, Integer quantity, Long receiverId, Long paymentMethodId, Long shippingMethodId, BigDecimal balance, String memo, @CurrentUser Member currentUser) {
		Map<String, Object> data = new HashMap<>();
		if (quantity == null || quantity < 1) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		Sku sku = skuService.find(skuId);
		if (sku == null) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		Receiver receiver = receiverService.find(receiverId);
		if (receiver != null && !currentUser.equals(receiver.getMember())) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (balance != null && balance.compareTo(BigDecimal.ZERO) < 0) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (balance != null && balance.compareTo(currentUser.getBalance()) > 0) {
			return Results.unprocessableEntity("shop.order.insufficientBalance");
		}
		PaymentMethod paymentMethod = paymentMethodService.find(paymentMethodId);
		ShippingMethod shippingMethod = shippingMethodService.find(shippingMethodId);
		Set<CartItem> cartItems = new HashSet<>();
		CartItem cartItem = new CartItem();
		cartItem.setSku(sku);
		cartItem.setQuantity(quantity);
		cartItems.add(cartItem);
		Cart cart = new Cart();
		cart.setMember(currentUser);
		cart.setCartItems(cartItems);
		List<Order> orders = orderService.generate(Order.Type.general, cart, receiver, paymentMethod, shippingMethod, null, null, balance, null);
		BigDecimal price = BigDecimal.ZERO;
		BigDecimal fee = BigDecimal.ZERO;
		BigDecimal freight = BigDecimal.ZERO;
		BigDecimal tax = BigDecimal.ZERO;
		BigDecimal promotionDiscount = BigDecimal.ZERO;
		BigDecimal amount = BigDecimal.ZERO;
		BigDecimal amountPayable = BigDecimal.ZERO;
		BigDecimal couponDiscount = BigDecimal.ZERO;

		for (Order order : orders) {
			price = price.add(order.getPrice());
			fee = fee.add(order.getFee());
			freight = freight.add(order.getFreight());
			tax = fee.add(order.getTax());
			promotionDiscount = promotionDiscount.add(order.getPromotionDiscount());
			couponDiscount = couponDiscount.add(order.getCouponDiscount());
			amount = amount.add(order.getAmount());
			amountPayable = amountPayable.add(order.getAmountPayable());
		}

		data.put("price", price);
		data.put("fee", fee);
		data.put("freight", freight);
		data.put("tax", tax);
		data.put("promotionDiscount", promotionDiscount);
		data.put("couponDiscount", couponDiscount);
		data.put("amount", amount);
		data.put("amountPayable", amountPayable);
		return ResponseEntity.ok(data);
	}

	/**
	 * 创建
	 */
	@PostMapping("/create")
	public ResponseEntity<?> create(String cartTag, Long receiverId, Long paymentMethodId, Long shippingMethodId, String code, String invoiceTitle, BigDecimal balance, String memo, @CurrentUser Member currentUser, @CurrentCart Cart currentCart) {
		Map<String, Object> data = new HashMap<>();
		if (currentCart == null || currentCart.isEmpty()) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (!StringUtils.equals(currentCart.getTag(), cartTag)) {
			return Results.unprocessableEntity("shop.order.cartHasChanged");
		}
		if (currentCart.hasNotActive(null)) {
			return Results.unprocessableEntity("shop.order.hasNotActive");
		}
		if (currentCart.hasNotMarketable(null)) {
			return Results.unprocessableEntity("shop.order.hasNotMarketable");
		}
		if (currentCart.getIsLowStock(null)) {
			return Results.unprocessableEntity("shop.order.cartLowStock");
		}
		Receiver receiver = null;
		ShippingMethod shippingMethod = null;
		PaymentMethod paymentMethod = paymentMethodService.find(paymentMethodId);
		if (currentCart.getIsDelivery(null)) {
			receiver = receiverService.find(receiverId);
			if (receiver == null || !currentUser.equals(receiver.getMember())) {
				return Results.UNPROCESSABLE_ENTITY;
			}
			shippingMethod = shippingMethodService.find(shippingMethodId);
			if (shippingMethod == null) {
				return Results.UNPROCESSABLE_ENTITY;
			}
		}
		CouponCode couponCode = couponCodeService.findByCode(code);
		if (couponCode != null && couponCode.getCoupon() != null && !currentCart.isValid(couponCode, couponCode.getCoupon().getStore())) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (balance != null && balance.compareTo(BigDecimal.ZERO) < 0) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (balance != null && balance.compareTo(currentUser.getBalance()) > 0) {
			return Results.unprocessableEntity("shop.order.insufficientBalance");
		}
		Invoice invoice = StringUtils.isNotEmpty(invoiceTitle) ? new Invoice(invoiceTitle, null) : null;
		List<Order> orders = orderService.create(Order.Type.general, currentCart, receiver, paymentMethod, shippingMethod, couponCode, invoice, balance, memo);
		List<String> orderSns = new ArrayList<>();
		for (Order order : orders) {
			if (order != null) {
				orderSns.add(order.getSn());
			}
		}
		data.put("orderSns", orderSns);
		return ResponseEntity.ok(data);
	}

	/**
	 * 创建
	 */
	@PostMapping(path = "/create", params = "type=exchange")
	public ResponseEntity<?> create(Long skuId, Integer quantity, Long receiverId, Long paymentMethodId, Long shippingMethodId, BigDecimal balance, String memo, @CurrentUser Member currentUser) {
		Map<String, Object> data = new HashMap<>();
		if (quantity == null || quantity < 1) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		Sku sku = skuService.find(skuId);
		if (sku == null) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (!Product.Type.exchange.equals(sku.getType())) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (!sku.getIsActive()) {
			return Results.unprocessableEntity("shop.order.skuNotActive");
		}
		if (!sku.getIsMarketable()) {
			return Results.unprocessableEntity("shop.order.skuNotMarketable");
		}
		if (quantity > sku.getAvailableStock()) {
			return Results.unprocessableEntity("shop.order.skuLowStock");
		}
		Receiver receiver = null;
		ShippingMethod shippingMethod = null;
		PaymentMethod paymentMethod = paymentMethodService.find(paymentMethodId);
		if (sku.getIsDelivery()) {
			receiver = receiverService.find(receiverId);
			if (receiver == null || !currentUser.equals(receiver.getMember())) {
				return Results.UNPROCESSABLE_ENTITY;
			}
			shippingMethod = shippingMethodService.find(shippingMethodId);
			if (shippingMethod == null) {
				return Results.UNPROCESSABLE_ENTITY;
			}
		}
		if (currentUser.getPoint() < sku.getExchangePoint() * quantity) {
			return Results.unprocessableEntity("shop.order.lowPoint");
		}
		if (balance != null && balance.compareTo(currentUser.getBalance()) > 0) {
			return Results.unprocessableEntity("shop.order.insufficientBalance");
		}
		Set<CartItem> cartItems = new HashSet<>();
		CartItem cartItem = new CartItem();
		cartItem.setSku(sku);
		cartItem.setQuantity(quantity);
		cartItems.add(cartItem);
		Cart cart = new Cart();
		cart.setMember(currentUser);
		cart.setCartItems(cartItems);
		List<String> orderSns = new ArrayList<>();
		List<Order> orders = orderService.create(Order.Type.exchange, cart, receiver, paymentMethod, shippingMethod, null, null, balance, memo);
		for (Order order : orders) {
			if (order != null) {
				orderSns.add(order.getSn());
			}
		}
		data.put("orderSns", orderSns);
		return ResponseEntity.ok(data);
	}

	/**
	 * 支付
	 */
	@GetMapping("/payment")
	public String payment(String[] orderSns, @CurrentUser Member currentUser, ModelMap model, RedirectAttributes redirectAttributes) {
		if (orderSns.length <= 0) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		List<PaymentPlugin> paymentPlugins = pluginService.getActivePaymentPlugins(WebUtils.getRequest());
		PaymentPlugin defaultPaymentPlugin = null;
		BigDecimal fee = BigDecimal.ZERO;
		BigDecimal amount = BigDecimal.ZERO;
		List<String> pOrderSn = new ArrayList<>();
		boolean online = false;
		List<Order> orders = new ArrayList<>();
		for (String orderSn : orderSns) {
			Order order = orderService.findBySn(orderSn);
			if (order == null) {
				return UNPROCESSABLE_ENTITY_VIEW;
			}
			if (order.getAmount().compareTo(order.getAmountPaid()) != 0) {
				if (!currentUser.equals(order.getMember()) || order.getPaymentMethod() == null || order.getAmountPayable().compareTo(BigDecimal.ZERO) <= 0) {
					return UNPROCESSABLE_ENTITY_VIEW;
				}
				if (PaymentMethod.Method.online.equals(order.getPaymentMethod().getMethod())) {
					if (!orderService.acquireLock(order, currentUser)) {
						addFlashMessage(redirectAttributes, "shop.order.locked");
						return "redirect:/member/order/list";
					}
					if (CollectionUtils.isNotEmpty(paymentPlugins)) {
						defaultPaymentPlugin = paymentPlugins.get(0);
						amount = amount.add(order.getAmountPayable());
					}
					online = true;
				} else {
					amount = amount.add(order.getAmountPayable());
					fee = fee.add(order.getFee());
					online = false;
				}
				pOrderSn.add(order.getSn());
				orders.add(order);
			}
		}
		if (defaultPaymentPlugin != null) {
			amount = defaultPaymentPlugin.calculateFee(amount).add(amount);
			model.addAttribute("fee", defaultPaymentPlugin.calculateFee(amount));
			model.addAttribute("online", online);
			model.addAttribute("fee", fee);
			model.addAttribute("defaultPaymentPlugin", defaultPaymentPlugin);
			model.addAttribute("paymentPlugins", paymentPlugins);
		}
		model.addAttribute("fee", online && defaultPaymentPlugin != null ? defaultPaymentPlugin.calculateFee(amount) : fee);
		model.addAttribute("amount", amount);
		model.addAttribute("shippingMethodName", orders.get(0).getShippingMethodName());
		model.addAttribute("paymentMethodName", orders.get(0).getPaymentMethodName());
		model.addAttribute("paymentMethod", orders.get(0).getPaymentMethod());
		model.addAttribute("expireDate", orders.get(0).getExpire());
		model.addAttribute("orders", orders);
		model.addAttribute("orderSns", pOrderSn);
		return "shop/order/payment";
	}

	/**
	 * 计算支付金额
	 */
	@GetMapping("/calculate_amount")
	public ResponseEntity<?> calculateAmount(String paymentPluginId, String[] orderSns, @CurrentUser Member currentUser) {
		Map<String, Object> data = new HashMap<>();
		if (orderSns.length <= 0) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		PaymentPlugin paymentPlugin = pluginService.getPaymentPlugin(paymentPluginId);
		BigDecimal amount = BigDecimal.ZERO;
		for (String orderSn : orderSns) {
			Order order = orderService.findBySn(orderSn);
			if (order == null || !currentUser.equals(order.getMember()) || paymentPlugin == null || !paymentPlugin.getIsEnabled()) {
				return Results.UNPROCESSABLE_ENTITY;
			}
			amount = amount.add(order.getAmountPayable());
		}
		BigDecimal fee = paymentPlugin.calculateFee(amount);
		data.put("fee", fee);
		data.put("amount", amount.add(fee));
		return ResponseEntity.ok(data);
	}

}