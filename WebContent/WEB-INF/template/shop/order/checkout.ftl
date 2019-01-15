<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("shop.order.checkout")}[#if showPowered] [/#if]</title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/shop/css/animate.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/order.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/shop/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/jquery.lSelect.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/common.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $dialogOverlay = $("#dialogOverlay");
	var $receiverForm = $("#receiverForm");
	var $receiverItem = $("#receiver ul");
	var $otherReceiverButton = $("#otherReceiverButton");
	var $newReceiverButton = $("#newReceiverButton");
	var $newReceiver = $("#newReceiver");
	var $areaId = $("#areaId");
	var $newReceiverSubmit = $("#newReceiverSubmit");
	var $newReceiverCancelButton = $("#newReceiverCancelButton");
	var $orderForm = $("#orderForm");
	var $receiverId = $("#receiverId");
	var $paymentMethod = $("#paymentMethod");
	var $shippingMethod = $("#shippingMethod");
	var $paymentMethodId = $("#paymentMethod input:radio");
	var $shippingMethodId = $("#shippingMethod input:radio");
	var $isInvoice = $("#isInvoice");
	var $invoiceTitle = $("#invoiceTitle");
	var $code = $("#code");
	var $couponCode = $("#couponCode");
	var $couponName = $("#couponName");
	var $couponButton = $("#couponButton");
	var $freight = $("#freight");
	var $tax = $("#tax");
	var $promotionDiscount = $("#promotionDiscount");
	var $couponDiscount = $("#couponDiscount");
	var $amount = $("#amount");
	var $useBalance = $("#useBalance");
	var $balance = $("#balance");
	var $submit = $("#submit");
	var amount = ${amount};
	var amountPayable = ${amountPayable};
	var paymentMethodIds = {};
	[@compress single_line = true]
		[#list shippingMethods as shippingMethod]
			paymentMethodIds["${shippingMethod.id}"] = [
				[#list shippingMethod.paymentMethods as paymentMethod]
					"${paymentMethod.id}"[#if paymentMethod_has_next],[/#if]
				[/#list]
			];
		[/#list]
	[/@compress]
	
	[#if isDelivery]
		[#if !currentUser.receivers?has_content]
			$dialogOverlay.show();
		[/#if]
		
		// 地区选择
		$areaId.lSelect({
			url: "${base}/common/area"
		});
		
		// 收货地址
		$receiverItem.on("click", "li", function() {
			var $this = $(this);
			$receiverId.val($this.attr("receiverId"));
			$this.addClass("selected").siblings().removeClass("selected");
			calculate();
		});
		
		// 其它收货地址
		$otherReceiverButton.click(function() {
			$receiverItem.height("auto");
			$otherReceiverButton.hide();
			$newReceiverButton.removeClass("hidden");
		});
		
		// 新收货地址
		$newReceiverButton.click(function() {
			$receiverItem.height("auto");
			$receiverForm.find("input:text").val("");
			$dialogOverlay.show();
			$newReceiver.show();
		});
		
		// 新收货地址取消
		$newReceiverCancelButton.click(function() {
			if ($receiverId.val() == "") {
				$.alert("${message("shop.order.receiverRequired")}");
				return false;
			}
			$dialogOverlay.hide();
			$newReceiver.hide();
		});
	[/#if]
	
	// 计算
	function calculate() {
		$.ajax({
			url: "calculate",
			type: "GET",
			data: $orderForm.serialize(),
			dataType: "json",
			cache: false,
			success: function(data) {
				$freight.text(currency(data.freight, true));
				if (data.tax > 0) {
					$tax.text(currency(data.tax, true)).parent().show();
				} else {
					$tax.parent().hide();
				}
				if (data.promotionDiscount > 0) {
					$promotionDiscount.text(currency(data.promotionDiscount, true)).parent().show();
				} else {
					$promotionDiscount.parent().hide();
				}
				if (data.couponDiscount > 0) {
					$couponDiscount.text(currency(data.couponDiscount, true)).parent().show();
				} else {
					$couponDiscount.parent().hide();
				}
				if (data.amount != amount) {
					$balance.val("0");
					amountPayable = data.amount;
				} else {
					amountPayable = data.amountPayable;
				}
				amount = data.amount;
				$amount.text(currency(amount, true, true));
				if (amount > 0) {
					$useBalance.parent().show();
				} else {
					$useBalance.parent().hide();
				}
				if (amountPayable > 0) {
					$paymentMethod.show();
				} else {
					$paymentMethod.hide();
				}
			}
		});
	}
	
	// 支付方式
	$paymentMethodId.click(function() {
		var $this = $(this);
		if ($this.prop("disabled")) {
			return false;
		}
		$this.closest("dd").addClass("selected").siblings().removeClass("selected");
		var paymentMethodId = $this.val();
		$shippingMethodId.each(function() {
			var $this = $(this);
			if ($.inArray(paymentMethodId, paymentMethodIds[$this.val()]) >= 0) {
				$this.prop("disabled", false);
			} else {
				$this.prop("disabled", true).prop("checked", false).closest("dd").removeClass("selected");
			}
		});
		calculate();
	});
	
	[#if isDelivery]
		// 配送方式
		$shippingMethodId.click(function() {
			var $this = $(this);
			if ($this.prop("disabled")) {
				return false;
			}
			$this.closest("dd").addClass("selected").siblings().removeClass("selected");
			var shippingMethodId = $this.val();
			$paymentMethodId.each(function() {
				var $this = $(this);
				if ($.inArray($this.val(), paymentMethodIds[shippingMethodId]) >= 0) {
					$this.prop("disabled", false);
				} else {
					$this.prop("disabled", true).prop("checked", false).closest("dd").removeClass("selected");
				}
			});
			calculate();
		});
	[/#if]
	
	// 开具发票
	$isInvoice.click(function() {
		if ($(this).prop("checked")) {
			$invoiceTitle.prop("disabled", false).closest("tr").show();
		} else {
			$invoiceTitle.prop("disabled", true).closest("tr").hide();
		}
		calculate();
	});
	
	// 发票抬头
	$invoiceTitle.focus(function() {
		if ($.trim($invoiceTitle.val()) == "${message("shop.order.defaultInvoiceTitle")}") {
			$invoiceTitle.val("");
		}
	});
	
	// 发票抬头
	$invoiceTitle.blur(function() {
		if ($.trim($invoiceTitle.val()) == "") {
			$invoiceTitle.val("${message("shop.order.defaultInvoiceTitle")}");
		}
	});
	
	// 优惠券
	$couponButton.click(function() {
		if ($code.val() == "") {
			if ($.trim($couponCode.val()) == "") {
				return false;
			}
			$.ajax({
				url: "check_coupon",
				type: "GET",
				data: {code : $couponCode.val()},
				dataType: "json",
				cache: false,
				beforeSend: function() {
					$couponButton.prop("disabled", true);
				},
				success: function(data) {
					$code.val($couponCode.val());
					$couponCode.hide();
					$couponName.text(data.couponName).show();
					$couponButton.text("${message("shop.order.codeCancel")}");
					calculate();
				},
				complete: function() {
					$couponButton.prop("disabled", false);
				}
			});
		} else {
			$code.val("");
			$couponCode.show();
			$couponName.hide();
			$couponButton.text("${message("shop.order.codeConfirm")}");
			calculate();
		}
	});
	
	// 使用余额
	$useBalance.click(function() {
		var $this = $(this);
		if ($this.prop("checked")) {
			$balance.prop("disabled", false).parent().show();
		} else {
			$balance.prop("disabled", true).parent().hide();
		}
		calculate();
	});
	
	// 余额
	$balance.keypress(function(event) {
		return (event.which >= 48 && event.which <= 57) || (event.which == 46 && $(this).val().indexOf(".") < 0) || event.which == 8;
	});
	
	// 余额
	$balance.change(function() {
		var $this = $(this);
		if (/^\d+(\.\d{0,${setting.priceScale}})?$/.test($this.val())) {
			var max = ${currentUser.balance} >= amount ? amount : ${currentUser.balance};
			if (parseFloat($this.val()) > max) {
				$this.val(max);
			}
		} else {
			$this.val("0");
		}
		calculate();
	});
	
	// 订单提交
	$submit.click(function() {
		if (amountPayable > 0) {
			if ($paymentMethodId.filter(":checked").size() <= 0) {
				$.alert("${message("shop.order.paymentMethodRequired")}");
				return false;
			}
		} else {
			$paymentMethodId.prop("disabled", true);
		}
		[#if isDelivery]
			if ($shippingMethodId.filter(":checked").size() <= 0) {
				$.alert("${message("shop.order.shippingMethodRequired")}");
				return false;
			}
		[/#if]
		[#if setting.isInvoiceEnabled]
			if ($isInvoice.prop("checked") && $.trim($invoiceTitle.val()) == "") {
				$.alert("${message("shop.order.invoiceTitleRequired")}");
				return false;
			}
		[/#if]
		$.ajax({
			url: "create",
			type: "POST",
			data: $orderForm.serialize(),
			dataType: "json",
			cache: false,
			beforeSend: function() {
				$submit.prop("disabled", true);
			},
			success: function(data) {
				if(amountPayable > 0){
					location.href = "payment?orderSns="+data.orderSns;
				}else{
					location.href = "${base}/member/order/list";
				}
			},
			complete: function() {
				$submit.prop("disabled", false);
			}
		});
	});
	
	[#if isDelivery]
		// 收货地址表单验证
		$receiverForm.validate({
			rules: {
				consignee: "required",
				areaId: "required",
				address: "required",
				zipCode: {
					required: true,
					pattern: /^\d{6}$/
				},
				phone: {
					required: true,
					pattern: /^\d{3,4}-?\d{7,9}$/
				}
			},
			submitHandler: function(form) {
				$.ajax({
					url: "save_receiver",
					type: "POST",
					data: $receiverForm.serialize(),
					dataType: "json",
					cache: false,
					beforeSend: function() {
						$newReceiverSubmit.prop("disabled", true);
					},
					success: function(data) {
						$receiverId.val(data.id);
						$receiverItem.show();
						$(
							[@compress single_line = true]
								'<li class="selected" receiverId="' + data.id + '">
									<span>
										<strong>' + escapeHtml(data.consignee) + '<\/strong>
										${message("shop.order.receive")}
									<\/span>
									<span>' + escapeHtml(data.areaName + data.address) + '<\/span>
									<span>' + escapeHtml(data.phone) + '<\/span>
								<\/li>'
							[/@compress]
						).appendTo($receiverItem).siblings().removeClass("selected");
						$dialogOverlay.hide();
						$newReceiver.hide();
						calculate();
					},
					complete: function() {
						$newReceiverSubmit.prop("disabled", false);
					}
				});
			}
		});
	[/#if]

});
</script>
</head>
<body>
	<div id="dialogOverlay" class="dialogOverlay"></div>
	[#include "/shop/include/header.ftl" /]
	<div class="container checkout">
		<div class="row">
			<div class="span12">
				<div class="step">
					<ul>
						<li>${message("shop.order.step1")}</li>
						<li class="current">${message("shop.order.step2")}</li>
						<li>${message("shop.order.step3")}</li>
					</ul>
				</div>
				[#if isDelivery]
					<form id="receiverForm" action="save_receiver" method="post">
						<div id="receiver" class="receiver">
							<div class="title">${message("shop.order.receiver")}</div>
							<ul class="clearfix[#if !currentUser.receivers?has_content] hidden[/#if]">
								[#list currentUser.receivers as receiver]
									<li[#if receiver == defaultReceiver] class="selected"[/#if] receiverId="${receiver.id}">
										<span>
											<strong>${receiver.consignee}</strong>
											${message("shop.order.receive")}
										</span>
										<span>${receiver.areaName}${receiver.address}</span>
										<span>${receiver.phone}</span>
									</li>
								[/#list]
							</ul>
							<div>
								[#if currentUser.receivers?size > 5]
									<a href="javascript:;" id="otherReceiverButton" class="button">${message("shop.order.otherReceiver")}</a>
								[/#if]
								<a href="javascript:;" id="newReceiverButton" class="button[#if currentUser.receivers?size > 5] hidden[/#if]">${message("shop.order.newReceiver")}</a>
							</div>
						</div>
						<div id="newReceiver" class="newReceiver[#if currentUser.receivers?has_content] hidden[/#if]">
							<table>
								<tr>
									<th width="100">
										<span class="requiredField">*</span>${message("Receiver.consignee")}:
									</th>
									<td>
										<input type="text" id="consignee" name="consignee" class="text" maxlength="200" />
									</td>
								</tr>
								<tr>
									<th>
										<span class="requiredField">*</span>${message("Receiver.area")}:
									</th>
									<td class="selectMap">
										<span class="fieldSet">
											<input type="hidden" id="areaId" name="areaId" />
										</span>
									</td>
								</tr>
								<tr>
									<th>
										<span class="requiredField">*</span>${message("Receiver.address")}:
									</th>
									<td>
										<input type="text" id="address" name="address" class="text" maxlength="200" />
									</td>
								</tr>
								<tr>
									<th>
										<span class="requiredField">*</span>${message("Receiver.zipCode")}:
									</th>
									<td>
										<input type="text" id="zipCode" name="zipCode" class="text" maxlength="200" />
									</td>
								</tr>
								<tr>
									<th>
										<span class="requiredField">*</span>${message("Receiver.phone")}:
									</th>
									<td>
										<input type="text" id="phone" name="phone" class="text" maxlength="200" />
									</td>
								</tr>
								<tr>
									<th>
										${message("Receiver.isDefault")}:
									</th>
									<td>
										<input type="checkbox" name="isDefault" value="true" />
										<input type="hidden" name="_isDefault" value="false" />
									</td>
								</tr>
								<tr>
									<th>
										&nbsp;
									</th>
									<td>
										<input type="submit" id="newReceiverSubmit" class="button" value="${message("shop.dialog.ok")}" />
										<input type="button" id="newReceiverCancelButton" class="button" value="${message("shop.dialog.cancel")}" />
									</td>
								</tr>
							</table>
						</div>
					</form>
				[/#if]
			</div>
		</div>
		<form id="orderForm" action="create" method="post">
			[#if orderType == "exchange"]
				<input type="hidden" name="type" value="exchange" />
				<input type="hidden" name="skuId" value="${skuId}" />
				<input type="hidden" name="quantity" value="${quantity}" />
			[/#if]
			<div class="row">
				<div class="span12">
					[#if isDelivery]
						<input type="hidden" id="receiverId" name="receiverId"[#if defaultReceiver??] value="${defaultReceiver.id}"[/#if] />
					[/#if]
					[#if orderType == "general"]
						<input type="hidden" name="cartTag" value="${cartTag}" />
					[/#if]
					<dl id="paymentMethod" class="select[#if amountPayable <= 0] hidden[/#if]">
						<dt>${message("Order.paymentMethod")}</dt>
						[#list paymentMethods as paymentMethod]
							<dd>
								<label for="paymentMethod_${paymentMethod.id}">
									<input type="radio" id="paymentMethod_${paymentMethod.id}" name="paymentMethodId" value="${paymentMethod.id}" />
									<span>
										[#if paymentMethod.icon?has_content]
											<em style="border-right: none; background: url(${paymentMethod.icon}) center no-repeat;">&nbsp;</em>
										[/#if]
										<strong>${paymentMethod.name}</strong>
									</span>
									<span>${abbreviate(paymentMethod.description, 100, "...")}</span>
								</label>
							</dd>
						[/#list]
					</dl>
					[#if isDelivery]
						<dl id="shippingMethod" class="select">
							<dt>${message("Order.shippingMethod")}</dt>
							[#list shippingMethods as shippingMethod]
								<dd>
									<label for="shippingMethod_${shippingMethod.id}">
										<input type="radio" id="shippingMethod_${shippingMethod.id}" name="shippingMethodId" value="${shippingMethod.id}" />
										<span>
											[#if shippingMethod.icon?has_content]
												<em style="border-right: none; background: url(${shippingMethod.icon}) center no-repeat;">&nbsp;</em>
											[/#if]
											<strong>${shippingMethod.name}</strong>
										</span>
										<span>${abbreviate(shippingMethod.description, 100, "...")}</span>
									</label>
								</dd>
							[/#list]
						</dl>
					[/#if]
					[#if orderType == "general" && setting.isInvoiceEnabled]
						<table>
							<tr>
								<th colspan="2">${message("shop.order.invoiceInfo")}</th>
							</tr>
							<tr>
								<td width="100">
									${message("shop.order.isInvoice")}:
								</td>
								<td>
									<label for="isInvoice">
										<input type="checkbox" id="isInvoice" name="isInvoice" value="true" />
										[#if setting.isTaxPriceEnabled](${message("Order.tax")}: ${setting.taxRate * 100}%)[/#if]
									</label>
								</td>
							</tr>
							<tr class="hidden">
								<td width="100">
									${message("shop.order.invoiceTitle")}:
								</td>
								<td>
									<input type="text" id="invoiceTitle" name="invoiceTitle" class="text" value="${message("shop.order.defaultInvoiceTitle")}" maxlength="200" disabled="disabled" />
								</td>
							</tr>
						</table>
					[/#if]
					<table class="sku">
						<tr>
							<th width="60">${message("shop.order.image")}</th>
							<th>${message("shop.order.sku")}</th>
							<th>${message("shop.order.price")}</th>
							<th>${message("shop.order.quantity")}</th>
							<th>${message("shop.order.subTotal")}</th>
						</tr>
						[#list orders as order]
							<tr>
								<td colspan="5">${abbreviate(order.store.name, 50, "...")}</td>
							</tr>	
							[#list order.orderItems as orderItem]
								[#if orderItem.sku?? && orderItem.sku.product??]
									<tr>
										<td>
											<img src="${orderItem.sku.thumbnail!setting.defaultThumbnailProductImage}" alt="${orderItem.sku.name}" />
										</td>
										<td>
											<a href="${base}${orderItem.sku.path}" title="${orderItem.sku.name}" target="_blank">${abbreviate(orderItem.sku.name, 50, "...")}</a>
											[#if orderItem.sku.specifications?has_content]
												<span class="silver">[${orderItem.sku.specifications?join(", ")}]</span>
											[/#if]
											[#if orderItem.type != "general"]
												<span class="red">[${message("Product.Type." + orderItem.type)}]</span>
											[/#if]
										</td>
										<td>
											[#if orderItem.type == "general"]
												${currency(orderItem.price, true)}
											[#else]
												-
											[/#if]
										</td>
										<td>
											${orderItem.quantity}
										</td>
										<td>
											[#if orderItem.type == "general"]
												${currency(orderItem.subtotal, true)}
											[#else]
												-
											[/#if]
										</td>
									</tr>
								[/#if]
							[/#list]
						[/#list]
					</table>
				</div>
			</div>
			<div class="row">
				<div class="span6">
					<dl class="memo">
						<dt>${message("Order.memo")}:</dt>
						<dd>
							<input type="text" name="memo" maxlength="200" />
						</dd>
					</dl>
					[#if orderType == "general"]
						<dl class="coupon">
							<dt>${message("shop.order.coupon")}:</dt>
							<dd>
								<input type="hidden" id="code" name="code" maxlength="200" />
								<input type="text" id="couponCode" maxlength="200" />
								<span id="couponName">&nbsp;</span>
								<button type="button" id="couponButton">${message("shop.order.codeConfirm")}</button>
							</dd>
						</dl>
					[/#if]
				</div>
				<div class="span6">
					<ul class="statistic">
						<li>
							[#if isDelivery]
								<span>
									${message("Order.freight")}: <em id="freight">${currency(freight, true)}</em>
								</span>
							[/#if]
							[#if orderType == "general"]
								[#if setting.isInvoiceEnabled && setting.isTaxPriceEnabled]
									<span class="hidden">
										${message("Order.tax")}: <em id="tax">${currency(tax, true)}</em>
									</span>
								[/#if]
								<span>
									${message("Order.rewardPoint")}: <em>${rewardPoint}</em>
								</span>
							[/#if]
						</li>
						[#if orderType == "general"]
							<li>
								<span[#if promotionDiscount == 0] class="hidden"[/#if]>
									${message("Order.promotionDiscount")}: <em id="promotionDiscount">${currency(promotionDiscount, true)}</em>
								</span>
								<span[#if couponDiscount == 0] class="hidden"[/#if]>
									${message("Order.couponDiscount")}: <em id="couponDiscount">${currency(couponDiscount, true)}</em>
								</span>
							</li>
						[/#if]
						[#if orderType == "exchange"]
							<li>
								<span>
									${message("Order.exchangePoint")}: <strong>${exchangePoint}</strong>
								</span>
							</li>
						[/#if]
						<li>
							<span>
								${message("Order.amount")}: <strong id="amount">${currency(amount, true, true)}</strong>
							</span>
						</li>
						[#if currentUser.balance > 0]
							<li[#if amount <= 0] class="hidden"[/#if]>
								<input type="checkbox" id="useBalance" name="useBalance" value="true" />
								<label for="useBalance">
									${message("shop.order.useBalance")}
								</label>
								<span class="hidden">
									<input type="text" id="balance" name="balance" class="balance" value="0" maxlength="16" onpaste="return false;" />
									<p>${message("shop.order.balance")}: ${currency(currentUser.balance, true)}</p>
								</span>
							</li>
						[/#if]
					</ul>
				</div>
			</div>
			<div class="row">
				<div class="span12">
					<div class="bottom">
						<a href="${base}/cart/list" class="back">${message("shop.order.back")}</a>
						<a href="javascript:;" id="submit" class="submit">${message("shop.order.submit")}</a>
					</div>
				</div>
			</div>
		</form>
	</div>
	[#include "/shop/include/footer.ftl" /]
</body>
</html>