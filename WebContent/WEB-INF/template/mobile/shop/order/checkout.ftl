<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("shop.order.checkout")}[#if showPowered] [/#if]</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/mobile/shop/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/animate.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/common.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/order.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/mobile/shop/js/html5shiv.js"></script>
		<script src="${base}/resources/mobile/shop/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/mobile/shop/js/jquery.js"></script>
	<script src="${base}/resources/mobile/shop/js/bootstrap.js"></script>
	<script src="${base}/resources/mobile/shop/js/velocity.js"></script>
	<script src="${base}/resources/mobile/shop/js/velocity.ui.js"></script>
	<script src="${base}/resources/mobile/shop/js/jquery.validate.js"></script>
	<script src="${base}/resources/mobile/shop/js/jquery.lSelect.js"></script>
	<script src="${base}/resources/mobile/shop/js/underscore.js"></script>
	<script src="${base}/resources/mobile/shop/js/common.js"></script>
	<script id="currentReceiverTemplate" type="text/template">
		<div class="media">
			<div class="media-left media-middle">
				<span class="glyphicon glyphicon-map-marker"></span>
			</div>
			<div class="media-body media-middle">
				<h4 class="media-heading">
					<%-currentReceiver.consignee%>
					<span class="pull-right"><%-currentReceiver.phone%></span>
				</h4>
				<span class="small"><%-currentReceiver.areaName%><%-currentReceiver.address%></span>
			</div>
			<div class="media-right media-middle">
				<span class="glyphicon glyphicon-menu-right"></span>
			</div>
		</div>
	</script>
	<script id="receiverListTemplate" type="text/template">
		<%_.each(receivers, function(receiver, i) {%>
			<div class="<%-receiver.id == currentReceiverId ? "active " : ""%>list-group-item" data-receiver="<%-JSON.stringify(receiver)%>">
				<div class="media">
					<div class="media-body media-middle">
						<h4 class="media-heading">
							<%-receiver.consignee%>
							<span class="pull-right"><%-receiver.phone%></span>
						</h4>
						<span class="small"><%-receiver.areaName%><%-receiver.address%></span>
					</div>
					<div class="media-right media-middle">
						<span class="glyphicon glyphicon-ok-circle"></span>
					</div>
				</div>
			</div>
		<%})%>
	</script>
	<script type="text/javascript">
		$().ready(function() {
			
			var $togglePage = $("[data-toggle='page']");
			var $toggleItem = $("[data-toggle='item']");
			var $dataItem = $("[data-name]");
			var $selection = $("div.selection");
			var $orderForm = $("#orderForm");
			var $receiverId = $("#receiverId");
			var $paymentMethodId = $("#paymentMethodId");
			var $shippingMethodId = $("#shippingMethodId");
			var $useBalance = $("#useBalance");
			var $currentReceiver = $("#currentReceiver");
			var $currentPaymentMethod = $("#currentPaymentMethod");
			var $currentShippingMethod = $("#currentShippingMethod");
			var $invoiceTitle = $("#invoiceTitle");
			var $couponName = $("#couponName");
			var $couponCode = $("#couponCode");
			var $useBalanceItem = $("#useBalanceItem");
			var $balance = $("#balance");
			var $receiverList = $("#receiverPage div.list-group");
			var $addReceiverForm = $("#addReceiverForm");
			var $areaId = $("#areaId");
			var $addReceiverSubmit = $("#addReceiverForm :submit");
			var $paymentMethodItem = $("#paymentMethodPage div.list-group-item");
			var $shippingMethodItem = $("#shippingMethodPage div.list-group-item");
			var $submit = $("#submit");
			var currentReceiverTemplate = _.template($("#currentReceiverTemplate").html());
			var receiverListTemplate = _.template($("#receiverListTemplate").html());
			var amount = ${amount};
			var amountPayable = ${amountPayable};
			var paymentMethodIds = {};
			[@compress single_line = true]
				[#list shippingMethods as shippingMethod]
					paymentMethodIds["${shippingMethod.id}"] = [
						[#list shippingMethod.paymentMethods as paymentMethod]
							${paymentMethod.id}[#if paymentMethod_has_next],[/#if]
						[/#list]
					];
				[/#list]
			[/@compress]
			
			[#if isDelivery]
				// 加载收货地址
				loadReceiver();
			[/#if]
			
			// 切换页面
			$togglePage.click(function() {
				var $element = $(this);
				togglePage($element.data("target"));
			});
			
			// 切换页面
			var toggling = false;
			function togglePage(target) {
				if (toggling) {
					return;
				}
				toggling = true;
				$(target).velocity("fadeIn", {
					begin: function() {
						$(this).css("z-index", 200);
					},
					complete: function() {
						$(this).siblings(".page:visible").hide().end().css("z-index", 100);
						toggling = false;
					}
				});
			}
			
			// 切换条目
			$toggleItem.click(function() {
				var $element = $(this);
				$element.toggleClass("active");
				$target = $($element.data("target"));
				if ($element.hasClass("active")) {
					$target.velocity("slideDown").find("input").prop("disabled", false);
				} else {
					$target.velocity("slideUp").find("input").prop("disabled", true);
				}
				calculate();
			});
			
			// 可选列表
			$selection.on("click", "div.list-group-item", function() {
				var $element = $(this);
				if ($element.hasClass("disabled")) {
					return;
				}
				
				$element.addClass("active").siblings().removeClass("active");
				togglePage("#mainPage");
				calculate();
			});
			
			// 发票抬头
			$invoiceTitle.focus(function() {
				var $element = $(this);
				if ($.trim($element.val()) == "${message("shop.order.defaultInvoiceTitle")}") {
					$element.val("");
				}
			});
			
			// 发票抬头
			$invoiceTitle.blur(function() {
				var $element = $(this);
				if ($.trim($element.val()) == "") {
					$element.val("${message("shop.order.defaultInvoiceTitle")}");
				}
			});
			
			// 优惠券名称
			$couponName.click(function() {
				$couponName.velocity("fadeOut", {
					complete: function() {
						$couponCode.show();
					}
				});
			});
			
			// 优惠码
			$couponCode.blur(function() {
				var $element = $(this);
				if ($.trim($element.val()) != "") {
					$.ajax({
						url: "check_coupon",
						type: "GET",
						data: {
							code: $element.val()
						},
						dataType: "json",
						success: function(data) {
							$couponCode.hide();
							$couponName.text(data.couponName).velocity("fadeIn");
						},
						complete: function() {
							calculate();
						}
					});
				} else {
					calculate();
				}
			});
			
			// 余额
			$balance.change(function() {
				var $element = $(this);
				if (/^\d+(\.\d{0,${setting.priceScale}})?$/.test($element.val())) {
					var max = ${currentUser.balance} >= amount ? amount : ${currentUser.balance};
					if (parseFloat($element.val()) > max) {
						$element.val(max);
					}
				} else {
					$element.val("0");
				}
				calculate();
			});
			
			// 收货地址列表
			$receiverList.on("click", "div.list-group-item", function() {
				var $element = $(this);
				var receiver = $element.data("receiver");
				$receiverId.val(receiver.id);
				$currentReceiver.html(currentReceiverTemplate({
					currentReceiver: receiver
				}));
			});
			
			// 加载收货地址
			function loadReceiver() {
				$.ajax({
					url: "receiver_list",
					type: "GET",
					dataType: "json",
					success: function(data) {
						$receiverList.html(receiverListTemplate({
							currentReceiverId: $receiverId.val(),
							receivers: data
						}));
					}
				});
			}
			
			// 地区选择
			$areaId.lSelect({
				url: "${base}/common/area"
			});
			
			// 添加收货地址表单验证
			$addReceiverForm.validate({
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
						data: $addReceiverForm.serialize(),
						dataType: "json",
						beforeSend: function() {
							$addReceiverSubmit.prop("disabled", true);
						},
						success: function(data) {
							$receiverId.val(data.id);
							$currentReceiver.html(currentReceiverTemplate({
								currentReceiver: data
							}));
							loadReceiver();
							togglePage("#mainPage");
							calculate();
						},
						complete: function() {
							$addReceiverSubmit.prop("disabled", false);
						}
					});
				}
			});
			
			// 支付方式
			$paymentMethodItem.click(function() {
				var $element = $(this);
				if ($element.hasClass("disabled")) {
					return;
				}
				
				var paymentMethodId = $element.data("payment-method-id");
				var paymentMethodName = $element.data("payment-method-name");
				$paymentMethodId.val(paymentMethodId);
				$currentPaymentMethod.find("span.name").text(paymentMethodName);
				
				$shippingMethodItem.each(function() {
					var $element = $(this);
					var shippingMethodId = $element.data("shipping-method-id");
					if ($.inArray(paymentMethodId, paymentMethodIds[shippingMethodId]) >= 0) {
						$element.removeClass("disabled");
					} else {
						$element.addClass("disabled");
						if ($element.hasClass("active")) {
							$element.removeClass("active");
							$shippingMethodId.val("");
							$currentShippingMethod.find("span.name").text("${message("shop.order.choose")}");
						}
					}
				});
			});
			
			// 配送方式
			$shippingMethodItem.click(function() {
				var $element = $(this);
				if ($element.hasClass("disabled")) {
					return;
				}
				
				var shippingMethodId = $element.data("shipping-method-id");
				var shippingMethodName = $element.data("shipping-method-name");
				$shippingMethodId.val(shippingMethodId);
				$currentShippingMethod.find("span.name").text(shippingMethodName);
				
				$paymentMethodItem.each(function() {
					var $element = $(this);
					var paymentMethodId = $element.data("payment-method-id");
					if ($.inArray(paymentMethodId, paymentMethodIds[shippingMethodId]) >= 0) {
						$element.removeClass("disabled");
					} else {
						$element.addClass("disabled");
						if ($element.hasClass("active")) {
							$element.removeClass("active");
							$paymentMethodId.val("");
							$currentPaymentMethod.find("span.name").text("${message("shop.order.choose")}");
						}
					}
				});
			});
			
			// 订单提交
			$submit.click(function() {
				[#if isDelivery]
					if ($receiverId.val() == "") {
						$.alert("${message("shop.order.receiverRequired")}");
						return false;
					}
				[/#if]
				if (amountPayable > 0) {
					if ($paymentMethodId.val() == "") {
						$.alert("${message("shop.order.paymentMethodRequired")}");
						return false;
					}
				} else {
					$paymentMethodId.prop("disabled", true);
				}
				[#if isDelivery]
					if ($shippingMethodId.val() == "") {
						$.alert("${message("shop.order.shippingMethodRequired")}");
						return false;
					}
				[/#if]
				$.ajax({
					url: "create",
					type: "POST",
					data: $orderForm.serialize(),
					dataType: "json",
					beforeSend: function() {
						$submit.prop("disabled", true);
					},
					success: function(data) {
						location.href = amountPayable > 0 ? "payment?orderSns=" + data.orderSns : "${base}/member/order/list";
					},
					complete: function() {
						$submit.prop("disabled", false);
					}
				});
			});
			
			// 计算
			function calculate() {
				$.ajax({
					url: "calculate",
					type: "GET",
					data: $orderForm.serialize(),
					dataType: "json",
					success: function(data) {
						$dataItem.each(function() {
							var $element = $(this);
							var name = $element.data("name");
							var type = $element.data("type");
							if (name in data) {
								var value = data[name];
								switch(type) {
									case "currency":
										$element.text(currency(value, true, true));
										break;
									default:
										$element.text(value);
								}
							}
						});
						if (data.amount != amount) {
							$balance.val("0");
							amountPayable = data.amount;
						} else {
							amountPayable = data.amountPayable;
						}
						amount = data.amount;
						if (amountPayable > 0) {
							if ($currentPaymentMethod.is(":hidden")) {
								$currentPaymentMethod.velocity("slideDown");
							}
							$paymentMethodId.prop("disabled", false);
							if ($useBalanceItem.is(":hidden")) {
								$useBalanceItem.velocity("slideDown");
							}
						} else {
							if ($currentPaymentMethod.is(":visible")) {
								$currentPaymentMethod.velocity("slideUp");
							}
							$paymentMethodId.prop("disabled", true);
							if (parseFloat($balance.val()) <= 0) {
								if ($useBalanceItem.is(":visible")) {
									$useBalanceItem.velocity("slideUp");
								}
								var $toggleItem = $useBalanceItem.find("[data-toggle='item']");
								if ($toggleItem.hasClass("active")) {
									$toggleItem.trigger("click");
								}
							}
						}
					}
				});
			}
		
		});
	</script>
</head>
<body class="order-checkout">
	<div id="mainPage" class="main-page page">
		<form id="orderForm" action="create" method="post">
			[#if orderType == "general"]
				<input name="cartTag" type="hidden" value="${cartTag}">
			[#elseif orderType == "exchange"]
				<input name="type" type="hidden" value="exchange">
				<input name="skuId" type="hidden" value="${skuId}">
				<input name="quantity" type="hidden" value="${quantity}">
			[/#if]
			[#if isDelivery]
				<input id="receiverId" name="receiverId" type="hidden"[#if defaultReceiver??] value="${defaultReceiver.id}"[/#if]>
			[/#if]
			<input id="paymentMethodId" name="paymentMethodId" type="hidden"[#if defaultPaymentMethod??] value="${defaultPaymentMethod.id}"[/#if]>
			<input id="shippingMethodId" name="shippingMethodId" type="hidden"[#if defaultShippingMethod??] value="${defaultShippingMethod.id}"[/#if]>
			<input id="useBalance" name="useBalance" type="hidden" value="false">
			<div class="header-fixed">
				<a class="pull-left" href="javascript: history.back();">
					<span class="glyphicon glyphicon-menu-left"></span>
				</a>
				${message("shop.order.checkout")}
			</div>
			<div class="page-body">
				<div class="container-fluid">
					[#if isDelivery]
						<div id="currentReceiver" class="current-receiver" data-toggle="page" data-target="#receiverPage">
							<div class="media">
								<div class="media-left media-middle">
									<span class="glyphicon glyphicon-map-marker"></span>
								</div>
								<div class="media-body media-middle">
									[#if defaultReceiver??]
										<h4 class="media-heading">
											${defaultReceiver.consignee}
											<span class="pull-right">${defaultReceiver.phone}</span>
										</h4>
										<span class="small">${defaultReceiver.areaName}${defaultReceiver.address}</span>
									[#else]
										<strong class="red">${message("shop.order.addReceiver")}</strong>
									[/#if]
								</div>
								<div class="media-right media-middle">
									<span class="glyphicon glyphicon-menu-right"></span>
								</div>
							</div>
						</div>
					[/#if]
					<div class="list-group list-group-flat">
						<div id="currentPaymentMethod" class="[#if amountPayable <= 0]hidden-element [/#if]list-group-item text-right" data-toggle="page" data-target="#paymentMethodPage">
							<span class="pull-left">${message("Order.paymentMethod")}</span>
							<span class="name gray-darker">${(defaultPaymentMethod.name)!message("shop.order.choose")}</span>
							<span class="glyphicon glyphicon-menu-right"></span>
						</div>
						[#if isDelivery]
							<div id="currentShippingMethod" class="list-group-item text-right" data-toggle="page" data-target="#shippingMethodPage">
								<span class="pull-left">${message("Order.shippingMethod")}</span>
								<span class="name gray-darker">${(defaultShippingMethod.name)!message("shop.order.choose")}</span>
								<span class="glyphicon glyphicon-menu-right"></span>
							</div>
						[/#if]
						[#if orderType == "general"]
							[#if setting.isInvoiceEnabled]
								<div class="list-group-item">
									<div class="row">
										<div class="col-xs-3">${message("shop.order.isInvoice")}</div>
										<div class="col-xs-7">
											[#if setting.isTaxPriceEnabled]
												<span class="gray-darker">${message("Order.tax")}: ${setting.taxRate * 100}%</span>
											[/#if]
										</div>
										<div class="col-xs-2 text-right">
											<span class="glyphicon glyphicon-check" data-toggle="item" data-target="#invoiceTitleItem"></span>
										</div>
									</div>
								</div>
								<div id="invoiceTitleItem" class="hidden-element list-group-item">
									<div class="row">
										<div class="col-xs-3">${message("shop.order.invoiceTitle")}</div>
										<div class="col-xs-9">
											<input id="invoiceTitle" name="invoiceTitle" type="text" value="${message("shop.order.defaultInvoiceTitle")}" maxlength="200" disabled>
										</div>
									</div>
								</div>
							[/#if]
							<div class="list-group-item">
								<div class="row">
									<div class="col-xs-3">${message("shop.order.coupon")}</div>
									<div class="col-xs-9">
										<span id="couponName" class="coupon-name red"></span>
										<input id="couponCode" name="code" type="text" maxlength="200" placeholder="${message("shop.order.couponCodePlaceholder")}">
									</div>
								</div>
							</div>
						[/#if]
						[#if currentUser.balance > 0]
							<div id="useBalanceItem" class="[#if amount <= 0]hidden-element [/#if]list-group-item">
								<div class="row">
									<div class="col-xs-3">${message("shop.order.balance")}</div>
									<div class="col-xs-7">
										<span class="gray-darker">${currency(currentUser.balance, true, true)}</span>
									</div>
									<div class="col-xs-2 text-right">
										<span class="glyphicon glyphicon-check" data-toggle="item" data-target="#balanceItem"></span>
									</div>
								</div>
							</div>
							<div id="balanceItem" class="hidden-element list-group-item">
								<div class="row">
									<div class="col-xs-3">${message("shop.order.useAmount")}</div>
									<div class="col-xs-9">
										<input id="balance" name="balance" type="text" value="0" maxlength="16" onpaste="return false;" disabled>
									</div>
								</div>
							</div>
						[/#if]
						<div class="list-group-item">
							<div class="row">
								<div class="col-xs-3">${message("Order.memo")}</div>
								<div class="col-xs-9">
									<input name="memo" type="text" maxlength="200" placeholder="${message("shop.order.memoPlaceholder")}">
								</div>
							</div>
						</div>
					</div>
					<div class="list-group list-group-flat">
						[#list orders as order]
							<div class="order list-group-item">
								<a href="javascript:;">${abbreviate(order.store.name, 50, "...")}</a>
							</div>
							[#list order.orderItems as orderItem]
								<div class="order-item list-group-item">
									<div class="media">
										<div class="media-left media-middle">
											<a href="${base}${orderItem.sku.path}">
												<img class="media-object" src="${orderItem.sku.thumbnail!setting.defaultThumbnailProductImage}" alt="${orderItem.name}">
											</a>
										</div>
										<div class="media-body media-middle">
											<h4 class="media-heading">
												<a href="${base}${orderItem.sku.path}">${orderItem.sku.name}</a>
											</h4>
											[#if orderItem.sku.specifications?has_content]
												<span class="small gray-darker">${orderItem.sku.specifications?join(", ")}</span>
											[/#if]
											[#if orderItem.type != "general"]
												<strong class="small">[${message("Product.Type." + orderItem.type)}]</strong>
											[/#if]
										</div>
										<div class="media-right media-middle">
											${currency(orderItem.price, true)}
											<span class="small gray-darker">&times; ${orderItem.quantity}</span>
										</div>
									</div>
								</div>
							[/#list]
						[/#list]
					</div>
					<div class="list-group list-group-flat">
						[#if orderType == "general"]
							[#if rewardPoint > 0]
								<div class="list-group-item small">
									${message("Order.rewardPoint")}
									<strong class="pull-right red">${rewardPoint}</strong>
								</div>
							[/#if]
							<div class="list-group-item small">
								${message("Order.promotionDiscount")}
								<strong class="pull-right" data-name="promotionDiscount" data-type="currency">${currency(promotionDiscount, true, true)}</strong>
							</div>
							<div class="list-group-item small">
								${message("Order.couponDiscount")}
								<strong class="pull-right" data-name="couponDiscount" data-type="currency">${currency(couponDiscount, true, true)}</strong>
							</div>
							[#if setting.isInvoiceEnabled && setting.isTaxPriceEnabled]
								<div class="list-group-item small">
									${message("Order.tax")}
									<strong class="pull-right" data-name="tax" data-type="currency">${currency(tax, true, true)}</strong>
								</div>
							[/#if]
						[#elseif orderType == "exchange"]
							<div class="list-group-item small">
								${message("Order.exchangePoint")}
								<strong class="pull-right red">${exchangePoint}</strong>
							</div>
						[/#if]
						[#if isDelivery]
							<div class="list-group-item small">
								${message("Order.freight")}
								<strong class="pull-right" data-name="freight" data-type="currency">${currency(freight, true, true)}</strong>
							</div>
						[/#if]
					</div>
				</div>
			</div>
			<div class="footer-fixed">
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-8 text-center">
							[#if orderType == "general"]
								${message("Order.amount")}:
								<strong class="red" data-name="amount" data-type="currency">${currency(amount, true, true)}</strong>
							[#elseif orderType == "exchange"]
								${message("Order.exchangePoint")}:
								<strong class="red">${exchangePoint}</strong>
							[/#if]
						</div>
						<div class="col-xs-4">
							<button id="submit" class="btn btn-red btn-flat btn-block" type="button">${message("shop.order.checkout")}</button>
						</div>
					</div>
				</div>
			</div>
		</form>
	</div>
	<div id="receiverPage" class="receiver-page page">
		<div class="header-fixed">
			<a class="pull-left" href="javascript:;" data-toggle="page" data-target="#mainPage">
				<span class="glyphicon glyphicon-menu-left"></span>
			</a>
			${message("shop.order.selectReceiver")}
		</div>
		<div class="page-body">
			<div class="selection list-group list-group-flat"></div>
		</div>
		<div class="footer-fixed">
			<button id="addReceiver" class="btn btn-red btn-flat btn-block" type="button" data-toggle="page" data-target="#addReceiverPage">${message("shop.order.addReceiver")}</button>
		</div>
	</div>
	<div id="addReceiverPage" class="add-receiver-page page">
		<form id="addReceiverForm" action="receiver_save" method="post">
			<div class="header-fixed">
				<a class="pull-left" href="javascript:;" data-toggle="page" data-target="#receiverPage">
					<span class="glyphicon glyphicon-menu-left"></span>
				</a>
				${message("shop.order.addReceiver")}
			</div>
			<div class="page-body">
				<div class="form-group">
					<label for="consignee">${message("Receiver.consignee")}</label>
					<input id="consignee" name="consignee" class="form-control" type="text" maxlength="200">
				</div>
				<div class="form-group">
					<label>${message("Receiver.area")}</label>
					<div class="input-group">
						<input id="areaId" name="areaId" type="hidden">
					</div>
				</div>
				<div class="form-group">
					<label for="address">${message("Receiver.address")}</label>
					<input id="address" name="address" class="form-control" type="text" maxlength="200">
				</div>
				<div class="form-group">
					<label for="zipCode">${message("Receiver.zipCode")}</label>
					<input id="zipCode" name="zipCode" class="form-control" type="text" maxlength="200">
				</div>
				<div class="form-group">
					<label for="phone">${message("Receiver.phone")}</label>
					<input id="phone" name="phone" class="form-control" type="text" maxlength="200">
				</div>
				<div class="form-group">
					<label>${message("Receiver.isDefault")}</label>
					<input name="isDefault" type="checkbox" value="true">
					<input name="_isDefault" type="hidden" value="false">
				</div>
			</div>
			<div class="footer-fixed">
				<button class="btn btn-red btn-flat btn-block" type="submit">${message("shop.order.useAndSave")}</button>
			</div>
		</form>
	</div>
	<div id="paymentMethodPage" class="payment-method-page page">
		<div class="header-fixed">
			<a class="pull-left" href="javascript:;" data-toggle="page" data-target="#mainPage">
				<span class="glyphicon glyphicon-menu-left"></span>
			</a>
			${message("Order.paymentMethod")}
		</div>
		<div class="page-body">
			<div class="selection list-group list-group-flat">
				[#list paymentMethods as paymentMethod]
					<div class="[#if paymentMethod == defaultPaymentMethod]active [/#if]list-group-item" data-payment-method-id="${paymentMethod.id}" data-payment-method-name="${paymentMethod.name}">
						<div class="media">
							<div class="media-left media-middle">
								<div class="media-object">
									[#if paymentMethod.icon?has_content]
										<img src="${paymentMethod.icon}" alt="${paymentMethod.name}">
									[/#if]
									${paymentMethod.name}
								</div>
							</div>
							<div class="media-body media-middle">
								<span class="small gray-darker">${abbreviate(paymentMethod.description, 100, "...")}</span>
							</div>
							<div class="media-right media-middle">
								<span class="glyphicon glyphicon-ok-circle"></span>
							</div>
						</div>
					</div>
				[/#list]
			</div>
		</div>
		<div class="footer-fixed">
			<button class="btn btn-red btn-flat btn-block" type="button" data-toggle="page" data-target="#mainPage">${message("shop.order.close")}</button>
		</div>
	</div>
	<div id="shippingMethodPage" class="shipping-method-page page">
		<div class="header-fixed">
			<a class="pull-left" href="javascript:;" data-toggle="page" data-target="#mainPage">
				<span class="glyphicon glyphicon-menu-left"></span>
			</a>
			${message("Order.shippingMethod")}
		</div>
		<div class="page-body">
			<div class="selection list-group list-group-flat">
				[#list shippingMethods as shippingMethod]
					<div class="[#if shippingMethod == defaultShippingMethod]active [/#if]list-group-item" data-shipping-method-id="${shippingMethod.id}" data-shipping-method-name="${shippingMethod.name}">
						<div class="media">
							<div class="media-left media-middle">
								<div class="media-object">
									[#if shippingMethod.icon?has_content]
										<img src="${shippingMethod.icon}" alt="${shippingMethod.name}">
									[/#if]
									${shippingMethod.name}
								</div>
							</div>
							<div class="media-body media-middle">
								<span class="small gray-darker">${abbreviate(shippingMethod.description, 100, "...")}</span>
							</div>
							<div class="media-right media-middle">
								<span class="glyphicon glyphicon-ok-circle"></span>
							</div>
						</div>
					</div>
				[/#list]
			</div>
		</div>
		<div class="footer-fixed">
			<button class="btn btn-red btn-flat btn-block" type="button" data-toggle="page" data-target="#mainPage">${message("shop.order.close")}</button>
		</div>
	</div>
</body>
</html>