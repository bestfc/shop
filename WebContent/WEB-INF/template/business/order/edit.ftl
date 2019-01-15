<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("business.order.edit")} </title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/business/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/business/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/business/css/bootstrap-select.css" rel="stylesheet">
	<link href="${base}/resources/business/css/adminLTE.css" rel="stylesheet">
	<link href="${base}/resources/business/css/common.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/business/js/html5shiv.js"></script>
		<script src="${base}/resources/business/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/business/js/jquery.js"></script>
	<script src="${base}/resources/business/js/bootstrap.js"></script>
	<script src="${base}/resources/business/js/bootstrap-select.js"></script>
	<script src="${base}/resources/business/js/jquery.validate.js"></script>
	<script src="${base}/resources/business/js/icheck.js"></script>
	<script src="${base}/resources/business/js/adminLTE.js"></script>
	<script src="${base}/resources/business/js/jquery.lSelect.js"></script>
	<script src="${base}/resources/business/js/common.js"></script>
	<script type="text/javascript">
	$().ready(function() {
	
		var $orderForm = $("#orderForm");
		var $amount = $("#amount");
		var $freight = $("#freight");
		var $offsetAmount = $("#offsetAmount");
		var $isInvoice = $("input[name='isInvoice']");
		var $invoiceTitle = $("#invoiceTitle");
		var $tax = $("#tax");
		var $areaId = $("[name='areaId']");
		var isLocked = false;
		var timeouts = {};
		
		[#if flashMessage?has_content]
			$.alert("${flashMessage}");
		[/#if]
		
		// 地区选择
		$areaId.lSelect({
			url: "${base}/common/area"
		});
		
		// 检查锁定
		function acquireLock() {
			$.ajax({
				url: "${base}/business/order/acquire_lock",
				type: "POST",
				data: {
					orderId: ${order.id}
				},
				dataType: "json",
				cache: false,
				success: function(data) {
					if(!data) {
						$orderForm.find(":input:not(:button)").prop("disabled", true);
						isLocked = true;
					}
				}
			});
		}
		
		// 检查锁定
		acquireLock();
		
		setInterval(function() {
			acquireLock();
		}, 50000);
		
		// 开具发票
		$isInvoice.on("ifChecked", function() {
			$invoiceTitle.prop("disabled", false);
			$tax.prop("disabled", false);
		});
		$isInvoice.on("ifUnchecked", function() {
			$invoiceTitle.prop("disabled", true);
				$tax.prop("disabled", true);
		});
		
		// 计算
		$amount.add($freight).add($offsetAmount).add($isInvoice).add($invoiceTitle).add($tax).on("input propertychange change", function(event) {
			if (event.type != "propertychange" || event.originalEvent.propertyName == "value") {
				calculate($(this));
			}
		});
		
		// 计算
		function calculate($input) {
			var name = $input.attr("name");
			clearTimeout(timeouts[name]);
			timeouts[name] = setTimeout(function() {
				if ($orderForm.valid()) {
					$.ajax({
						url: "${base}/business/order/calculate",
						type: "POST",
						data: {
							orderId: ${order.id},
							freight: $freight.val(),
							offsetAmount: $offsetAmount.val(),
							tax: !$tax.prop("disabled") ? $tax.val() : 0
						},
						dataType: "json",
						cache: false,
						success: function(data) {
							$amount.text(currency(data.amount, true));
						}
					});
				}
			}, 500);
		}
		
		// 表单验证
		$orderForm.validate({
			rules: {
				freight: {
					required: true,
					min: 0,
					decimal: {
						integer: 12,
						fraction: ${setting.priceScale}
					}
				},
				offsetAmount: {
					required: true,
					number: true,
					decimal: {
						integer: 12,
						fraction: ${setting.priceScale}
					}
				},
				rewardPoint: {
					required: true,
					digits: true
				},
				invoiceTitle: "required",
				tax: {
					required: true,
					min: 0,
					decimal: {
						integer: 12,
						fraction: ${setting.priceScale}
					}
				},
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
			}
		});
	
	});
	</script>
</head>
<body class="hold-transition sidebar-mini">
	<div class="wrapper">
		[#include "/business/include/main_header.ftl" /]
		[#include "/business/include/main_sidebar.ftl" /]
		<div class="content-wrapper">
			<div class="container-fluid">
				<section class="content-header">
					<h1>${message("business.order.edit")}</h1>
					<ol class="breadcrumb">
						<li>
							<a href="/shop/business/index">
								<i class="fa fa-home"></i>
								${message("business.common.index")}
							</a>
						</li>
						<li class="active">${message("business.order.edit")}</li>
					</ol>
				</section>
				<section class="content">
					<div class="row">
						<div class="col-xs-12">
							<form id="orderForm" class="form-horizontal" action="${base}/business/order/update" method="post">
								<input name="orderId" type="hidden" value="${order.id}">
								<div class="box">
									<div class="box-body">
										<ul class="nav nav-tabs">
											<li class="active">
												<a href="#base" data-toggle="tab">${message("business.product.base")}</a>
											</li>
											<li>
												<a href="#specification" data-toggle="tab">${message("business.product.specification")}</a>
											</li>
										</ul>
										<div class="tab-content">
											<div id="base" class="tab-pane active">
												<div class="row">
													<div class="col-xs-6">
														<dl class="items dl-horizontal">
															<dt>${message("Order.sn")}:</dt>
															<dd>${order.sn}</dd>
															<dt>${message("Order.type")}:</dt>
															<dd>${message("Order.Type." + order.type)}</dd>
															<dt>${message("Order.member")}:</dt>
															<dd>${order.member.username}</dd>
															<dt>${message("Order.price")}:</dt>
															<dd>${currency(order.price, true)}</dd>
															<dt>${message("Order.amount")}:</dt>
															<dd id="amount" class="text-red">${currency(order.amount, true)}</dd>
															<dt>${message("Order.weight")}:</dt>
															<dd>${order.weight}</dd>
															<dt>${message("business.order.promotion")}:</dt>
															<dd>
																[#if order.promotionNames?has_content]
																	${order.promotionNames?join(", ")}
																[#else]
																	-
																[/#if]
															</dd>
															<dt>${message("business.order.coupon")}:</dt>
															<dd>${(order.couponCode.coupon.name)!"-"}</dd>
															<dt>${message("Order.fee")}:</dt>
															<dd>${currency(order.fee, true)}</dd>
														</dl>
													</div>
													<div class="col-xs-6">
														<dl class="items dl-horizontal">
															<dt>${message("business.common.createdDate")}:</dt>
															<dd>${order.createdDate?string("yyyy-MM-dd HH:mm:ss")}</dd>
															<dt>${message("Order.status")}:</dt>
															<dd>
																${message("Order.Status." + order.status)}
																[#if order.hasExpired()]
																	(${message("business.order.hasExpired")})
																[#else]
																	[#if order.expire??]
																		(${message("Order.expire")}: ${order.expire?string("yyyy-MM-dd HH:mm:ss")})
																	[/#if]
																[/#if]
															</dd>
															<dt>${message("Member.memberRank")}:</dt>
															<dd>${order.member.memberRank.name}</dd>
															<dt>${message("Order.exchangePoint")}:</dt>
															<dd>${order.exchangePoint}</dd>
															<dt>${message("Order.amountPaid")}:</dt>
															<dd>
																${currency(order.amountPaid, true)}
																[#if order.amountPayable > 0]
																	(${message("Order.amountPayable")}: ${currency(order.amountPayable, true)})
																[/#if]
															</dd>
															<dt>${message("Order.quantity")}:</dt>
															<dd>${order.quantity}</dd>
															<dt>${message("Order.promotionDiscount")}:</dt>
															<dd>${currency(order.promotionDiscount, true)}</dd>
															<dt>${message("Order.couponDiscount")}:</dt>
															<dd>${currency(order.couponDiscount, true)}</dd>
														</dl>
													</div>
												</div>
												<div class="row">
													<div class="col-xs-6">
														<div class="form-group">
															<label class="col-xs-4 control-label" for="freight">${message("Order.freight")}:</label>
															<div class="col-xs-8">
																<input id="freight" name="freight" class="form-control" type="text" value="${order.freight}" maxlength="16">
															</div>
														</div>
													</div>
													<div class="col-xs-6">
														<div class="form-group">
															<label class="col-xs-4 control-label" for="offsetAmount">${message("Order.offsetAmount")}:</label>
															<div class="col-xs-8">
																<input id="offsetAmount" name="offsetAmount" class="form-control" type="text" value="${order.offsetAmount}" maxlength="16">
															</div>
														</div>
													</div>
													<div class="col-xs-6">
														<div class="form-group">
															<label class="col-xs-4 control-label" for="rewardPoint">${message("Order.rewardPoint")}:</label>
															<div class="col-xs-8">
																<input id="rewardPoint" name="rewardPoint" class="form-control" type="text" value="${order.rewardPoint}" maxlength="9">
															</div>
														</div>
													</div>
													<div class="col-xs-6">
														<div class="form-group">
															<label class="col-xs-4 control-label">${message("Order.paymentMethod")}:</label>
															<div class="col-xs-8">
																<select name="paymentMethodId" class="selectpicker form-control" data-size="5">
																	<option value="">${message("business.common.choose")}</option>
																	[#list paymentMethods as paymentMethod]
																		<option value="${paymentMethod.id}"[#if paymentMethod == order.paymentMethod] selected[/#if]>${paymentMethod.name}</option>
																	[/#list]
																</select>
															</div>
														</div>
													</div>
													<div class="col-xs-6">
														<div class="form-group">
															<label class="col-xs-4 control-label">${message("Order.shippingMethod")}:</label>
															<div class="col-xs-8">
																[#if order.isDelivery]
																	<select name="shippingMethodId" class="selectpicker form-control" data-size="5">
																		<option value="">${message("business.common.choose")}</option>
																		[#list shippingMethods as shippingMethod]
																			<option value="${shippingMethod.id}"[#if shippingMethod == order.shippingMethod] selected[/#if]>${shippingMethod.name}</option>
																		[/#list]
																	</select>
																[#else]
																	-
																[/#if]
															</div>
														</div>
													</div>
													<div class="col-xs-6">
														<div class="form-group">
															<label class="col-xs-4 control-label" for="invoiceTitle">${message("Invoice.title")}:</label>
															<div class="col-xs-8">
																<div class="input-group">
																	<input id="invoiceTitle" name="invoiceTitle" class="form-control" type="text" value="${(order.invoice.title)!}" maxlength="200"[#if !order.invoice??] disabled[/#if]>
																	<span class="input-group-addon">
																		<input name="isInvoice" class="icheck" type="checkbox" value="true"[#if order.invoice??] checked[/#if]>
																	</span>
																</div>
															</div>
														</div>
													</div>
													<div class="col-xs-6">
														<div class="form-group">
															<label class="col-xs-4 control-label" for="tax">${message("Order.tax")}:</label>
															<div class="col-xs-8">
																<input id="tax" name="tax" class="form-control" type="text" value="${order.tax}" maxlength="16"[#if !order.invoice??] disabled[/#if]>
															</div>
														</div>
													</div>
													[#if order.isDelivery]
														<div class="col-xs-6">
															<div class="form-group">
																<label class="col-xs-4 control-label" for="consignee">${message("Order.consignee")}:</label>
																<div class="col-xs-8">
																	<input id="consignee" name="consignee" class="form-control" type="text" value="${order.consignee}" maxlength="200">
																</div>
															</div>
														</div>
														<div class="col-xs-6">
															<div class="form-group">
																<label class="col-xs-4 control-label">${message("Order.area")}:</label>
																<div class="col-xs-8">
																	<input name="areaId" type="hidden" value="${(order.area.id)!}" treePath="${(order.area.treePath)!}">
																</div>
															</div>
														</div>
														<div class="col-xs-6">
															<div class="form-group">
																<label class="col-xs-4 control-label" for="address">${message("Order.address")}:</label>
																<div class="col-xs-8">
																	<input id="address" name="address" class="form-control" type="text" value="${order.address}" maxlength="200">
																</div>
															</div>
														</div>
														<div class="col-xs-6">
															<div class="form-group">
																<label class="col-xs-4 control-label" for="zipCode">${message("Order.zipCode")}:</label>
																<div class="col-xs-8">
																	<input id="zipCode" name="zipCode" class="form-control" type="text" value="${order.zipCode}" maxlength="200">
																</div>
															</div>
														</div>
														<div class="col-xs-6">
															<div class="form-group">
																<label class="col-xs-4 control-label" for="phone">${message("Order.phone")}:</label>
																<div class="col-xs-8">
																	<input id="phone" name="phone" class="form-control" type="text" value="${order.phone}" maxlength="200">
																</div>
															</div>
														</div>
														<div class="col-xs-6">
															<div class="form-group">
																<label class="col-xs-4 control-label" for="memo">${message("Order.memo")}:</label>
																<div class="col-xs-8">
																	<input id="memo" name="memo" class="form-control" type="text" value="${order.memo}" maxlength="200">
																</div>
															</div>
														</div>
													[/#if]
												</div>
											</div>
											<div id="specification" class="tab-pane">
												<table class="table table-hover">
													<thead>
														<tr>
															<th>${message("OrderItem.sn")}</th>
															<th>${message("OrderItem.name")}</th>
															<th>${message("OrderItem.price")}</th>
															<th>${message("OrderItem.quantity")}</th>
															<th>${message("OrderItem.subtotal")}</th>
														</tr>
													</thead>
													<tbody>
														[#list order.orderItems as orderItem]
															<tr>
																<td>${orderItem.sn}</td>
																<td>
																	[#if orderItem.sku??]
																		<a href="${base}${orderItem.sku.path}" title="${orderItem.name}" target="_blank">${abbreviate(orderItem.name, 50, "...")}</a>
																	[#else]
																		<span title="${orderItem.name}">${abbreviate(orderItem.name, 50, "...")}</span>
																	[/#if]
																	[#if orderItem.specifications?has_content]
																		<span class="gray-darker">[${orderItem.specifications?join(", ")}]</span>
																	[/#if]
																	[#if orderItem.type != "general"]
																		<span class="text-red">[${message("Product.Type." + orderItem.type)}]</span>
																	[/#if]
																</td>
																<td>
																	[#if orderItem.type == "general"]
																		${currency(orderItem.price, true)}
																	[#else]
																		-
																	[/#if]
																</td>
																<td>${orderItem.quantity}</td>
																<td>
																	[#if orderItem.type == "general"]
																		${currency(orderItem.subtotal, true)}
																	[#else]
																		-
																	[/#if]
																</td>
															</tr>
														[/#list]
													</tbody>
												</table>
											</div>
										</div>
									</div>
									<div class="box-footer">
										<div class="row">
											<div class="col-xs-4 col-xs-offset-2">
												<button class="btn btn-primary" type="submit">${message("business.common.submit")}</button>
												<button class="btn btn-default" type="button" data-toggle="back">${message("business.common.back")}</button>
											</div>
										</div>
									</div>
								</div>
							</form>
						</div>
					</div>
				</section>
			</div>
		</div>
		[#include "/business/include/main_footer.ftl" /]
	</div>
</body>
</html>