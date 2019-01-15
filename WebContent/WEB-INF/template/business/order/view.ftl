<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("business.order.view")} </title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/business/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/business/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/business/css/bootstrap-select.css" rel="stylesheet">
	<link href="${base}/resources/business/css/animate.css" rel="stylesheet">
	<link href="${base}/resources/business/css/adminLTE.css" rel="stylesheet">
	<link href="${base}/resources/business/css/common.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/business/js/html5shiv.js"></script>
		<script src="${base}/resources/business/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/business/js/jquery.js"></script>
	<script src="${base}/resources/business/js/bootstrap.js"></script>
	<script src="${base}/resources/business/js/bootstrap-select.js"></script>
	<script src="${base}/resources/business/js/jquery.lSelect.js"></script>
	<script src="${base}/resources/business/js/jquery.validate.js"></script>
	<script src="${base}/resources/business/js/adminLTE.js"></script>
	<script src="${base}/resources/business/js/underscore.js"></script>
	<script src="${base}/resources/business/js/common.js"></script>
	<style>
		.returns-items-quantity, .shipping-items-quantity {
			width: 50px;
		}
		div.modal .table tbody tr td {
			vertical-align: middle;
		}
	</style>
	<script id="transitStepTemplate" type="text/template">
		<%if (_.isEmpty(data.transitSteps)) {%>
			<p class="gray-darker">${message("business.order.noResult")}</p>
		<%} else {%>
			<div class="list-group list-group-flat">
				<%_.each(data.transitSteps, function(transitStep, i) {%>
					<div class="list-group-item">
						<p class="gray-darker"><%-transitStep.time%></p>
						<p><%-transitStep.context%></p>
					</div>
				<%})%>
			</div>
		<%}%>
	</script>
	<script type="text/javascript">
        // 退款审核
        function refundsAudit(status, nRefundsID){
            $.ajax({
                url: "${base}/business/order/refunds-audit",
                type: "POST",
                data: {
                    refundID: nRefundsID,
                    status: status
                },
                dataType: "json",
                success: function(result) {
                    console.log(result.code)
                    console.log(result)
                    if(result.code&&result.code==50000){
                        $.alert("操作成功");
                        location.href="view?orderId=${order.id}";
                    }else {
                        $.alert("操作失败");
                    }
                }
            });
            return false;
        }
        function refundsPay(nRefundsID){
            $.ajax({
                url: "${base}/business/order/refunds-pay",
                type: "POST",
                data: {
                    refundID:nRefundsID
                },
                dataType: "json",
                success: function(result) {
                    console.log(result)
                    if(result.code&&result.code==50000){
                        $.alert("操作成功");
                        location.href="view?orderId=${order.id}";
                    }else {
                        $.alert("退款失败");
                    }
                }
            });
            return false;
        }

	$().ready(function() {
		var $reviewButton = $("#reviewButton");
		var $passed = $("#passed");
		var $reviewDismissButton = $("#reviewDismissButton");
		var $paymentForm = $("#paymentForm");
		var $amount = $("#paymentForm input[name='amount']");
		var $refundsForm = $("#refundsForm");
		var $refundsMethod = $("#refundsForm select[name='method']");
		var $refundsButton = $("#refundsButton");
		var $areaId = $("[name='areaId']");
		var $shippingForm = $("#shippingForm");
		var $shippingItemsQuantity = $("#shippingForm .shipping-items-quantity");
		var $shippingLogistics = $("#shippingLogistics");
		var $shippingButton = $("#shippingButton");
		var $returnsForm = $("#returnsForm");
		var $returnsItemsQuantity = $("#returnsForm .returns-items-quantity");
		var $returnsButton = $("#returnsButton");
		var $transitStep = $("#transitStep");
		var transitStepTemplate = _.template($("#transitStepTemplate").html());
		var $transitStepModal = $("#transitStepModal");
		var $transitStepModalBody = $("#transitStepModal div.modal-body");
		var isLocked = false;
		
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
						$.alert("${message("business.order.locked")}");
						$("#reviewModalButton").add($("#paymentModalButton")).add($("#refundsModalButton")).add($("#shippingModalButton")).add($("#returnsModalButton")).add($("#completeModalButton")).add($("#failModalButton")).prop("disabled", true);
						isLocked = true;
					}
				}
			});
		}
		
		// 获取订单锁
		acquireLock();
		setInterval(function() {
			if (!isLocked) {
				acquireLock();
			}
		}, 50000);
		
		// 审核
		$reviewButton.click(function() {
			$passed.val("true");
		});
		
		$reviewDismissButton.click(function() {
			$passed.val("false");
		});
		
		// 收款
		$paymentForm.validate({
			rules: {
				amount: {
					required: true,
					positive: true,
					decimal: {
						integer: 12,
						fraction: ${setting.priceScale}
					}
				}
			},
			submitHandler: function(form) {
				if (parseFloat($amount.val()) <= ${order.amountPayable} || confirm("${message("business.order.paymentConfirm")}")) {
					form.submit();
				}
			}
		});
		
		// 退款
		$refundsForm.validate({
			rules: {
				amount: {
					required: true,
					positive: true,
					max: ${order.refundableAmount},
					decimal: {
						integer: 12,
						fraction: ${setting.priceScale}
					}
				}
			}
		});
		
		$refundsButton.click(function() {
			if ($refundsMethod.val() == "deposit") {
				[#if currentUser.balance < order.refundableAmount]
					$.alert("${message("business.order.insufficientBalance")}");
					return false;
				[/#if]
			}
			$("#refundsForm").submit();
			return false;
		});
		
		// 发货
		function checkDelivery() {
			var isDelivery = false;
			$shippingItemsQuantity.each(function() {
				var $element = $(this);
				
				if ($element.data("is-delivery") && $element.val() > 0) {
					isDelivery = true;
					return false;
				}
			});
			if (isDelivery) {
				$shippingLogistics.find(":input:not([name='memo'])").prop("disabled", false);
			} else {
				$shippingLogistics.find(":input:not([name='memo'])").prop("disabled", true);
			}
		}
		
		checkDelivery();
		
		$shippingItemsQuantity.on("input propertychange change", function(event) {
			if (event.type != "propertychange" || event.originalEvent.propertyName == "value") {
				checkDelivery()
			}
		});
		
		$.validator.addClassRules({
			"shipping-items-quantity": {
				required: true,
				digits: true
			}
		});
		
		$shippingForm.validate({
			rules: {
				deliveryCorpId: "required",
				freight: {
					min: 0,
					decimal: {
						integer: 12,
						fraction: ${setting.priceScale}
					}
				},
				consignee: "required",
				zipCode: {
					required: true,
					pattern: /^\d{6}$/
				},
				areaId: "required",
				address: "required",
				phone: {
					required: true,
					pattern: /^\d{3,4}-?\d{7,9}$/
				}
			}
		});
		
		$shippingButton.click(function() {
			var total = 0;
			$shippingItemsQuantity.each(function() {
				var quantity = $(this).val();
				
				if ($.isNumeric(quantity)) {
					total += parseInt(quantity);
				}
			});
			if (total <= 0) {
				$.alert("${message("business.order.shippingQuantityPositive")}");
				return false;
			} else {
				$shippingForm.submit();
			}
		});
		
		// 退货
		$.validator.addClassRules({
			"returns-items-quantity": {
				required: true,
				digits: true
			}
		});
		
		$returnsForm.validate({
			rules: {
				freight: {
					min: 0,
					decimal: {
						integer: 12,
						fraction: ${setting.priceScale}
					}
				},
				zipCode: {
					pattern: /^\d{6}$/
				},
				phone: {
					pattern: /^\d{3,4}-?\d{7,9}$/
				},
				orderReturnsItemsQuantity: {
					required: true,
					digits: true
				}
			}
		});
		
		$returnsButton.click(function() {
			var total = 0;
			$returnsItemsQuantity.each(function() {
				var quantity = $(this).val();
				
				if ($.isNumeric(quantity)) {
					total += parseInt(quantity);
				}
			});
			if (total <= 0) {
				$.alert("${message("business.order.shippingQuantityPositive")}");
				return false;
			}
		});
		
		// 物流动态
		$transitStep.click(function() {
			var $element = $(this);
			$.ajax({
				url: "${base}/business/order/transit_step",
				type: "GET",
				data: {
					shippingId: $element.data("shipping-id")
				},
				dataType: "json",
				beforeSend: function() {
					$transitStepModal.modal();
				},
				success: function(data) {
					$transitStepModalBody.html(transitStepTemplate({
						data: data
					}));
				}
			});
			return false;
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
                <h1>${message("business.order.view")}</h1>
                <ol class="breadcrumb">
                    <li>
                        <a href="/shop/business/index">
                            <i class="fa fa-home"></i>
						${message("business.common.index")}
                        </a>
                    </li>
                    <li class="active">${message("business.order.view")}</li>
                </ol>
            </section>
            <section class="content">
                <div class="row">
                    <div class="col-xs-12">
                        <div class="box">
                            <div class="box-body">
									[#if !order.hasExpired() && order.status == "pendingReview"]
										<form class="form-horizontal" action="${base}/business/order/review" method="post">
                                            <input name="csrfToken" type="hidden" value="${csrfToken}">
                                            <input name="orderId" type="hidden" value="${order.id}">
                                            <input id="passed" name="passed" type="hidden">
                                            <div id="reviewModal" class="modal fade" tabindex="-1">
                                                <div class="modal-dialog">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <button class="close" type="button" data-dismiss="modal">&times;</button>
                                                        </div>
                                                        <div class="modal-body">
                                                            <p>${message("business.order.reviewConfirm")}</p>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button id="reviewButton" class="btn btn-primary" type="submit">${message("business.common.true")}</button>
                                                            <button id="reviewDismissButton" class="btn btn-default" type="submit">${message("business.common.false")}</button>
                                                            <button class="btn btn-default" type="button" data-dismiss="modal">${message("business.common.cancel")}</button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </form>
									[/#if]
									[#if currentStore.isSelf()]
										<form id="paymentForm" class="form-horizontal" action="${base}/business/order/payment" method="post">
                                            <input name="csrfToken" type="hidden" value="${csrfToken}">
                                            <input name="orderId" type="hidden" value="${order.id}">
                                            <div id="paymentModal" class="modal fade" tabindex="-1">
                                                <div class="modal-dialog modal-lg">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <button class="close" type="button" data-dismiss="modal">&times;</button>
                                                            <h4 class="modal-title">${message("business.order.payment")}</h4>
                                                        </div>
                                                        <div class="modal-body">
                                                            <div class="row">
                                                                <div class="col-xs-6">
                                                                    <dl class="items dl-horizontal">
                                                                        <dt>${message("Order.sn")}:</dt>
                                                                        <dd>${order.sn}</dd>
                                                                        <dt>${message("Order.amount")}:</dt>
                                                                        <dd>${currency(order.amount, true)}</dd>
                                                                    </dl>
                                                                </div>
                                                                <div class="col-xs-6">
                                                                    <dl class="items dl-horizontal">
                                                                        <dt>${message("business.common.createdDate")}:</dt>
                                                                        <dd>${order.createdDate?string("yyyy-MM-dd HH:mm:ss")}</dd>
                                                                        <dt>${message("Order.amountPayable")}:</dt>
                                                                        <dd>${currency(order.amountPayable, true)}</dd>
                                                                    </dl>
                                                                </div>
                                                                <div class="col-xs-6">
                                                                    <div class="form-group">
                                                                        <label class="col-xs-4 control-label" for="bank">${message("OrderPayment.bank")}:</label>
                                                                        <div class="col-xs-8">
                                                                            <input id="bank" name="bank" class="form-control" type="text" maxlength="200">
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="col-xs-6">
                                                                    <div class="form-group">
                                                                        <label class="col-xs-4 control-label" for="account">${message("OrderPayment.account")}:</label>
                                                                        <div class="col-xs-8">
                                                                            <input id="account" name="account" class="form-control" type="text" maxlength="200">
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="col-xs-6">
                                                                    <div class="form-group">
                                                                        <label class="col-xs-4 control-label item-required" for="amount">${message("OrderPayment.amount")}:</label>
                                                                        <div class="col-xs-8">
                                                                            <input id="amount" name="amount" class="form-control" type="text"[#if order.amountPayable > 0] value="${order.amountPayable}"[/#if] maxlength="16">
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="col-xs-6">
                                                                    <div class="form-group">
                                                                        <label class="col-xs-4 control-label" for="payer">${message("OrderPayment.payer")}:</label>
                                                                        <div class="col-xs-8">
                                                                            <input id="payer" name="payer" class="form-control" type="text" maxlength="200">
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="col-xs-6">
                                                                    <div class="form-group">
                                                                        <label class="col-xs-4 control-label">${message("OrderPayment.method")}:</label>
                                                                        <div class="col-xs-8">
                                                                            <select name="method" class="selectpicker form-control" data-size="5">
																				[#list methods as method]
																					[#if method != "deposit"]<option value="${method}">${message("OrderPayment.Method." + method)}</option>[/#if]
																				[/#list]
                                                                            </select>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="col-xs-6">
                                                                    <div class="form-group">
                                                                        <label class="col-xs-4 control-label">${message("OrderPayment.paymentMethod")}:</label>
                                                                        <div class="col-xs-8">
                                                                            <select name="paymentMethodId" class="selectpicker form-control" data-size="5">
                                                                                <option value="">${message("business.common.choose")}</option>
																				[#list paymentMethods as paymentMethod]
																					[#noautoesc]
																						<option value="${paymentMethod.id}">${paymentMethod.name?html?js_string}</option>
																					[/#noautoesc]
																				[/#list]
                                                                            </select>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="col-xs-6">
                                                                    <div class="form-group">
                                                                        <label class="col-xs-4 control-label" for="memo">${message("OrderPayment.memo")}:</label>
                                                                        <div class="col-xs-8">
                                                                            <input id="memo" name="memo" class="form-control" type="text" maxlength="200">
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button class="btn btn-primary" type="submit">${message("business.common.ok")}</button>
                                                            <button class="btn btn-default" type="button" data-dismiss="modal">${message("business.common.cancel")}</button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </form>
									[/#if]
									[#if !order.hasExpired() && order.refundableAmount > 0]
										<form id="refundsForm" class="form-horizontal" action="${base}/business/order/refunds" method="post">
                                            <input name="csrfToken" type="hidden" value="${csrfToken}">
                                            <input name="orderId" type="hidden" value="${order.id}">
                                            <div id="refundsModal" class="modal fade" tabindex="-1">
                                                <div class="modal-dialog modal-lg">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <button class="close" type="button" data-dismiss="modal">&times;</button>
                                                            <h4 class="modal-title">${message("business.order.orderRefunds")}</h4>
                                                        </div>
                                                        <div class="modal-body">
                                                            <div class="row">
                                                                <div class="col-xs-6">
                                                                    <dl class="items dl-horizontal">
                                                                        <dt>${message("Order.sn")}:</dt>
                                                                        <dd>${order.sn}</dd>
                                                                        <dt>${message("Order.amount")}:</dt>
                                                                        <dd>${currency(order.amount, true)}</dd>
                                                                    </dl>
                                                                </div>
                                                                <div class="col-xs-6">
                                                                    <dl class="items dl-horizontal">
                                                                        <dt>${message("business.common.createdDate")}:</dt>
                                                                        <dd>${order.createdDate?string("yyyy-MM-dd HH:mm:ss")}</dd>
                                                                        <dt>${message("Order.refundableAmount")}:</dt>
                                                                        <dd>${currency(order.refundableAmount, true)}</dd>
                                                                    </dl>
                                                                </div>
                                                                <div class="col-xs-6">
                                                                    <div class="form-group">
                                                                        <label class="col-xs-4 control-label" for="bank">${message("OrderRefunds.bank")}:</label>
                                                                        <div class="col-xs-8">
                                                                            <input id="bank" name="bank" class="form-control" type="text" maxlength="200">
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="col-xs-6">
                                                                    <div class="form-group">
                                                                        <label class="col-xs-4 control-label" for="account">${message("OrderRefunds.account")}:</label>
                                                                        <div class="col-xs-8">
                                                                            <input id="account" name="account" class="form-control" type="text" maxlength="200">
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="col-xs-6">
                                                                    <div class="form-group">
                                                                        <label class="col-xs-4 control-label item-required" for="amount">${message("OrderRefunds.amount")}:</label>
                                                                        <div class="col-xs-8">
                                                                            <input id="amount" name="amount" class="form-control" type="text" value="${order.refundableAmount}" maxlength="16">
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="col-xs-6">
                                                                    <div class="form-group">
                                                                        <label class="col-xs-4 control-label" for="payee">${message("OrderRefunds.payee")}:</label>
                                                                        <div class="col-xs-8">
                                                                            <input id="payee" name="payee" class="form-control" type="text" maxlength="200">
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="col-xs-6">
                                                                    <div class="form-group">
                                                                        <label class="col-xs-4 control-label">${message("OrderRefunds.method")}:</label>
                                                                        <div class="col-xs-8">
                                                                            <select name="method" class="selectpicker form-control" data-size="5">
																				[#list refundsMethods as refundsMethod]
                                                                                    <option value="${refundsMethod}">${message("OrderRefunds.Method." + refundsMethod)}</option>
																				[/#list]
                                                                            </select>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="col-xs-6">
                                                                    <div class="form-group">
                                                                        <label class="col-xs-4 control-label">${message("OrderRefunds.paymentMethod")}:</label>
                                                                        <div class="col-xs-8">
                                                                            <select name="paymentMethodId" class="selectpicker form-control" data-size="5">
                                                                                <option value="">${message("business.common.choose")}</option>
																				[#list paymentMethods as paymentMethod]
																					[#noautoesc]
																						<option value="${paymentMethod.id}">${paymentMethod.name?html?js_string}</option>
																					[/#noautoesc]
																				[/#list]
                                                                            </select>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="col-xs-6">
                                                                    <div class="form-group">
                                                                        <label class="col-xs-4 control-label" for="memo">${message("OrderRefunds.memo")}:</label>
                                                                        <div class="col-xs-8">
                                                                            <input id="memo" name="memo" class="form-control" type="text" maxlength="200">
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button id="refundsButton" class="btn btn-primary" type="submit">${message("business.common.ok")}</button>
                                                            <button class="btn btn-default" type="button" data-dismiss="modal">${message("business.common.cancel")}</button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </form>
									[/#if]
									[#if order.shippableQuantity > 0]
										<form id="shippingForm" class="form-horizontal" action="${base}/business/order/shipping" method="post">
                                            <input name="csrfToken" type="hidden" value="${csrfToken}">
                                            <input name="orderId" type="hidden" value="${order.id}">
                                            <div id="shippingModal" class="modal fade" tabindex="-1">
                                                <div class="modal-dialog modal-lg">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <button class="close" type="button" data-dismiss="modal">&times;</button>
                                                            <h4 class="modal-title">${message("business.order.orderShipping")}</h4>
                                                        </div>
                                                        <div class="modal-body">
                                                            <div id="shippingLogistics" class="row">
                                                                <div class="col-xs-6">
                                                                    <dl class="items dl-horizontal">
                                                                        <dt>${message("Order.sn")}:</dt>
                                                                        <dd>${order.sn}</dd>
                                                                    </dl>
                                                                </div>
                                                                <div class="col-xs-6">
                                                                    <dl class="items dl-horizontal">
                                                                        <dt>${message("business.common.createdDate")}:</dt>
                                                                        <dd>${order.createdDate?string("yyyy-MM-dd HH:mm:ss")}</dd>
                                                                    </dl>
                                                                </div>
                                                                <div class="col-xs-6">
                                                                    <div class="form-group">
                                                                        <label class="col-xs-4 control-label">${message("OrderShipping.shippingMethod")}:</label>
                                                                        <div class="col-xs-8">
                                                                            <select name="shippingMethodId" class="selectpicker form-control" data-size="5">
                                                                                <option value="">${message("business.common.choose")}</option>
																				[#list shippingMethods as shippingMethod]
																					[#noautoesc]
																						<option value="${shippingMethod.id}"[#if shippingMethod == order.shippingMethod] selected[/#if]>${shippingMethod.name?html?js_string}</option>
																					[/#noautoesc]
																				[/#list]
                                                                            </select>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="col-xs-6">
                                                                    <div class="form-group">
                                                                        <label class="col-xs-4 control-label">${message("OrderShipping.deliveryCorp")}:</label>
                                                                        <div class="col-xs-8">
                                                                            <select name="deliveryCorpId" class="selectpicker form-control" data-size="5">
                                                                                <option value="">${message("business.common.choose")}</option>
																				[#list deliveryCorps as deliveryCorp]
																					[#noautoesc]
																						<option value="${deliveryCorp.id}"[#if order.shippingMethod?? && deliveryCorp == order.shippingMethod.defaultDeliveryCorp] selected[/#if]>${deliveryCorp.name?html?js_string}</option>
																					[/#noautoesc]
																				[/#list]
                                                                            </select>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="col-xs-6">
                                                                    <div class="form-group">
                                                                        <label class="col-xs-4 control-label" for="trackingNo">${message("OrderShipping.trackingNo")}:</label>
                                                                        <div class="col-xs-8">
                                                                            <input id="trackingNo" name="trackingNo" class="form-control" type="text" maxlength="200">
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="col-xs-6">
                                                                    <div class="form-group">
                                                                        <label class="col-xs-4 control-label" for="freight">${message("OrderShipping.freight")}:</label>
                                                                        <div class="col-xs-8">
                                                                            <input id="freight" name="freight" class="form-control" type="text" maxlength="16">
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="col-xs-6">
                                                                    <div class="form-group">
                                                                        <label class="col-xs-4 control-label item-required" for="consignee">${message("OrderShipping.consignee")}:</label>
                                                                        <div class="col-xs-8">
                                                                            <input id="consignee" name="consignee" class="form-control" type="text" value="[#noautoesc]${order.consignee?html?js_string}[/#noautoesc]" maxlength="200">
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="col-xs-6">
                                                                    <div class="form-group">
                                                                        <label class="col-xs-4 control-label item-required" for="zipCode">${message("OrderShipping.zipCode")}:</label>
                                                                        <div class="col-xs-8">
                                                                            <input id="zipCode" name="zipCode" class="form-control" type="text" value="[#noautoesc]${order.zipCode?html?js_string}[/#noautoesc]" maxlength="200">
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="col-xs-6">
                                                                    <div class="form-group">
                                                                        <label class="col-xs-4 control-label item-required">${message("OrderShipping.area")}:</label>
                                                                        <div class="col-xs-8">
                                                                            <input name="areaId" type="hidden" value="${(order.area.id)!}" treePath="${(order.area.treePath)!}">
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="col-xs-6">
                                                                    <div class="form-group">
                                                                        <label class="col-xs-4 control-label item-required" for="address">${message("OrderShipping.address")}:</label>
                                                                        <div class="col-xs-8">
                                                                            <input id="address" name="address" class="form-control" type="text" value="[#noautoesc]${order.address?html?js_string}[/#noautoesc]" maxlength="200">
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="col-xs-6">
                                                                    <div class="form-group">
                                                                        <label class="col-xs-4 control-label item-required" for="phone">${message("OrderShipping.phone")}:</label>
                                                                        <div class="col-xs-8">
                                                                            <input id="phone" name="phone" class="form-control" type="text" value="[#noautoesc]${order.phone?html?js_string}[/#noautoesc]" maxlength="200">
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="col-xs-6">
                                                                    <div class="form-group">
                                                                        <label class="col-xs-4 control-label" for="memo">${message("OrderShipping.memo")}:</label>
                                                                        <div class="col-xs-8">
                                                                            <input id="memo" name="memo" class="form-control" type="text" maxlength="200">
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <table class="table table-hover">
                                                                <thead>
                                                                <tr>
                                                                    <th>${message("business.orderShippingItem.sn")}</th>
                                                                    <th>${message("business.orderShippingItem.name")}</th>
                                                                    <th>${message("OrderShippingItem.isDelivery")}</th>
                                                                    <th>${message("business.order.skuStock")}</th>
                                                                    <th>${message("business.order.skuQuantity")}</th>
                                                                    <th>${message("business.order.shippedQuantity")}</th>
                                                                    <th>${message("business.order.shippingQuantity")}</th>
                                                                </tr>
                                                                </thead>
                                                                <tbody>
																	[#list order.orderItems as orderItem]
                                                                    <tr>
                                                                        <td>
                                                                            <input name="orderShippingItems[${orderItem_index}].sn" type="hidden" value="${orderItem.sn}">
																			${orderItem.sn}
                                                                        </td>
																			[#noautoesc]
																				<td>
                                                                                    <span title="${orderItem.name?html?js_string}">${abbreviate(orderItem.name, 50, "...")?html?js_string}</span>
																					[#if orderItem.specifications?has_content]
																						<span class="gray-darker">[${orderItem.specifications?join(", ")?html?js_string}]</span>
																					[/#if]
																					[#if orderItem.type != "general"]
																						<span class="text-red">[${message("Product.Type." + orderItem.type)}]</span>
																					[/#if]
                                                                                </td>
																			[/#noautoesc]
                                                                        <td>${message(orderItem.isDelivery?string('business.common.true', 'business.common.false'))}</td>
                                                                        <td>${(orderItem.sku.stock)!"-"}</td>
                                                                        <td>${orderItem.quantity}</td>
                                                                        <td>${orderItem.shippedQuantity}</td>
                                                                        <td>
																				[#if orderItem.sku?? && orderItem.sku.stock < orderItem.shippableQuantity]
																					[#assign shippingQuantity = orderItem.sku.stock /]
																				[#else]
																					[#assign shippingQuantity = orderItem.shippableQuantity /]
																				[/#if]
                                                                            <input name="orderShippingItems[${orderItem_index}].quantity" class="shipping-items-quantity form-control" type="text" value="${shippingQuantity}" max="${shippingQuantity}" data-is-delivery="${orderItem.isDelivery?string('true', 'false')}"[#if shippingQuantity <= 0] disabled[/#if]>
                                                                        </td>
                                                                    </tr>
																	[/#list]
                                                                </tbody>
                                                            </table>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button id="shippingButton" class="btn btn-primary" type="submit">${message("business.common.ok")}</button>
                                                            <button class="btn btn-default" type="button" data-dismiss="modal">${message("business.common.cancel")}</button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </form>
									[/#if]
									[#if order.returnableQuantity > 0]
										<form id="returnsForm" class="form-horizontal" action="${base}/business/order/returns" method="post">
                                            <input name="csrfToken" type="hidden" value="${csrfToken}">
                                            <input name="orderId" type="hidden" value="${order.id}">
                                            <div id="returnsModal" class="modal fade" tabindex="-1">
                                                <div class="modal-dialog modal-lg">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <button class="close" type="button" data-dismiss="modal">&times;</button>
                                                            <h4 class="modal-title">${message("business.order.orderReturns")}</h4>
                                                        </div>
                                                        <div class="modal-body">
                                                            <div class="row">
                                                                <div class="col-xs-6">
                                                                    <dl class="items dl-horizontal">
                                                                        <dt>${message("Order.sn")}:</dt>
                                                                        <dd>${order.sn}</dd>
                                                                    </dl>
                                                                </div>
                                                                <div class="col-xs-6">
                                                                    <dl class="items dl-horizontal">
                                                                        <dt>${message("business.common.createdDate")}:</dt>
                                                                        <dd>${order.createdDate?string("yyyy-MM-dd HH:mm:ss")}</dd>
                                                                    </dl>
                                                                </div>
                                                                <div class="col-xs-6">
                                                                    <div class="form-group">
                                                                        <label class="col-xs-4 control-label">${message("OrderReturns.shippingMethod")}:</label>
                                                                        <div class="col-xs-8">
                                                                            <select name="shippingMethodId" class="selectpicker form-control" data-size="5">
                                                                                <option value="">${message("business.common.choose")}</option>
																				[#list shippingMethods as shippingMethod]
																					[#noautoesc]
																						<option value="${shippingMethod.id}">${shippingMethod.name?html?js_string}</option>
																					[/#noautoesc]
																				[/#list]
                                                                            </select>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="col-xs-6">
                                                                    <div class="form-group">
                                                                        <label class="col-xs-4 control-label">${message("OrderReturns.deliveryCorp")}:</label>
                                                                        <div class="col-xs-8">
                                                                            <select name="deliveryCorpId" class="selectpicker form-control" data-size="5">
                                                                                <option value="">${message("business.common.choose")}</option>
																				[#list deliveryCorps as deliveryCorp]
																					[#noautoesc]
																						<option value="${deliveryCorp.id}">${deliveryCorp.name?html?js_string}</option>
																					[/#noautoesc]
																				[/#list]
                                                                            </select>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="col-xs-6">
                                                                    <div class="form-group">
                                                                        <label class="col-xs-4 control-label" for="trackingNo">${message("OrderReturns.trackingNo")}:</label>
                                                                        <div class="col-xs-8">
                                                                            <input id="trackingNo" name="trackingNo" class="form-control" type="text" maxlength="200">
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="col-xs-6">
                                                                    <div class="form-group">
                                                                        <label class="col-xs-4 control-label" for="freight">${message("OrderReturns.freight")}:</label>
                                                                        <div class="col-xs-8">
                                                                            <input id="freight" name="freight" class="form-control" type="text" maxlength="16">
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="col-xs-6">
                                                                    <div class="form-group">
                                                                        <label class="col-xs-4 control-label" for="shipper">${message("OrderReturns.shipper")}:</label>
                                                                        <div class="col-xs-8">
                                                                            <input id="shipper" name="shipper" class="form-control" type="text" value="[#noautoesc]${order.consignee?html?js_string}[/#noautoesc]" maxlength="200">
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="col-xs-6">
                                                                    <div class="form-group">
                                                                        <label class="col-xs-4 control-label" for="zipCode">${message("OrderReturns.zipCode")}:</label>
                                                                        <div class="col-xs-8">
                                                                            <input id="zipCode" name="zipCode" class="form-control" type="text" value="[#noautoesc]${order.zipCode?html?js_string}[/#noautoesc]" maxlength="200">
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="col-xs-6">
                                                                    <div class="form-group">
                                                                        <label class="col-xs-4 control-label">${message("OrderReturns.area")}:</label>
                                                                        <div class="col-xs-8">
                                                                            <input name="areaId" type="hidden" value="${(order.area.id)!}" treePath="${(order.area.treePath)!}">
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="col-xs-6">
                                                                    <div class="form-group">
                                                                        <label class="col-xs-4 control-label" for="address">${message("OrderReturns.address")}:</label>
                                                                        <div class="col-xs-8">
                                                                            <input id="address" name="address" class="form-control" type="text" value="[#noautoesc]${order.address?html?js_string}[/#noautoesc]" maxlength="200">
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="col-xs-6">
                                                                    <div class="form-group">
                                                                        <label class="col-xs-4 control-label" for="phone">${message("OrderReturns.phone")}:</label>
                                                                        <div class="col-xs-8">
                                                                            <input id="phone" name="phone" class="form-control" type="text" value="[#noautoesc]${order.phone?html?js_string}[/#noautoesc]" maxlength="200">
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="col-xs-6">
                                                                    <div class="form-group">
                                                                        <label class="col-xs-4 control-label" for="memo">${message("OrderReturns.memo")}:</label>
                                                                        <div class="col-xs-8">
                                                                            <input id="memo" name="memo" class="form-control" type="text" maxlength="200">
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <table class="table table-hover">
                                                                <thead>
                                                                <tr>
                                                                    <th>${message("OrderReturnsItem.sn")}</th>
                                                                    <th>${message("OrderReturnsItem.name")}</th>
                                                                    <th>${message("business.order.skuStock")}</th>
                                                                    <th>${message("business.order.shippedQuantity")}</th>
                                                                    <th>${message("business.order.returnedQuantity")}</th>
                                                                    <th>${message("business.order.returnsQuantity")}</th>
                                                                </tr>
                                                                </thead>
                                                                <tbody>
																	[#list order.orderItems as orderItem]
                                                                    <tr>
                                                                        <td>
                                                                            <input name="orderReturnsItems[${orderItem_index}].sn" type="hidden" value="${orderItem.sn}">
																			${orderItem.sn}
                                                                        </td>
																			[#noautoesc]
																				<td>
                                                                                    <span title="${orderItem.name?html?js_string}">${abbreviate(orderItem.name, 50, "...")?html?js_string}</span>
																					[#if orderItem.specifications?has_content]
																						<span class="gray-darker">[${orderItem.specifications?join(", ")?html?js_string}]</span>
																					[/#if]
																					[#if orderItem.type != "general"]
																						<span class="text-red">[${message("Product.Type." + orderItem.type)}]</span>
																					[/#if]
                                                                                </td>
																			[/#noautoesc]
                                                                        <td>${(orderItem.sku.stock)!"-"}</td>
                                                                        <td>${orderItem.shippedQuantity}</td>
                                                                        <td>${orderItem.returnedQuantity}</td>
                                                                        <td>
                                                                            <input name="orderReturnsItems[${orderItem_index}].quantity" class="returns-items-quantity form-control" type="text" value="${orderItem.returnableQuantity}" maxlength="9" max="${orderItem.returnableQuantity}"[#if orderItem.returnableQuantity <= 0] disabled[/#if]>
                                                                        </td>
                                                                    </tr>
																	[/#list]
                                                                </tbody>
                                                            </table>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button id="returnsButton" class="btn btn-primary" type="submit">${message("business.common.ok")}</button>
                                                            <button class="btn btn-default" type="button" data-dismiss="modal">${message("business.common.cancel")}</button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </form>
									[/#if]
									[#if !order.hasExpired() && order.status == "received"]
										<form class="form-horizontal" action="${base}/business/order/complete" method="post">
                                            <input name="orderId" type="hidden" value="${order.id}">
                                            <div id="completeModal" class="modal fade" tabindex="-1">
                                                <div class="modal-dialog">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <button class="close" type="button" data-dismiss="modal">&times;</button>
                                                        </div>
                                                        <div class="modal-body">
                                                            <p class="form-control-static">${message("business.order.completeConfirm")}</p>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button class="btn btn-primary" type="submit">${message("business.common.true")}</button>
                                                            <button class="btn btn-default" type="button" data-dismiss="modal">${message("business.common.cancel")}</button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </form>
									[/#if]
									[#if !order.hasExpired() && (order.status == "pendingShipment" || order.status == "shipped" || order.status == "received")]
										<form class="form-horizontal" action="${base}/business/order/fail" method="post">
                                            <input name="orderId" type="hidden" value="${order.id}">
                                            <div id="failModal" class="modal fade" tabindex="-1">
                                                <div class="modal-dialog">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <button class="close" type="button" data-dismiss="modal">&times;</button>
                                                        </div>
                                                        <div class="modal-body">
                                                            <p class="form-control-static">${message("business.order.failConfirm")}</p>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button class="btn btn-primary" type="submit">${message("business.common.true")}</button>
                                                            <button class="btn btn-default" type="button" data-dismiss="modal">${message("business.common.cancel")}</button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </form>
									[/#if]
                                <div id="transitStepModal" class="transit-step-modal modal fade" tabindex="-1">
                                    <div class="modal-dialog">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <button class="close" type="button" data-dismiss="modal">&times;</button>
                                                <h4 class="modal-title">${message("business.order.transitStep")}</h4>
                                            </div>
                                            <div class="modal-body"></div>
                                            <div class="modal-footer">
                                                <button class="btn btn-default" type="button" data-dismiss="modal">${message("business.common.cancel")}</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <form class="form-horizontal">
                                    <ul class="nav nav-tabs">
                                        <li class="active">
                                            <a href="#orderInfo" data-toggle="tab">${message("business.order.orderInfo")}</a>
                                        </li>
                                        <li>
                                            <a href="#productInfo" data-toggle="tab">${message("business.order.productInfo")}</a>
                                        </li>
                                        <li>
                                            <a href="#paymentInfo" data-toggle="tab">${message("business.order.paymentInfo")}</a>
                                        </li>
                                        <li>
                                            <a href="#orderRefundsInfo" data-toggle="tab">${message("business.order.orderRefundsInfo")}</a>
                                        </li>
                                        <li>
                                            <a href="#orderShippingInfo" data-toggle="tab">${message("business.order.orderShippingInfo")}</a>
                                        </li>
                                        <li>
                                            <a href="#oderReturnsInfo" data-toggle="tab">${message("business.order.oderReturnsInfo")}</a>
                                        </li>
                                        <li>
                                            <a href="#orderLog" data-toggle="tab">${message("business.order.orderLog")}</a>
                                        </li>
                                    </ul>
                                    <div class="tab-content">
                                        <div id="orderInfo" class="tab-pane active">
                                            <div class="row">
                                                <div class="col-xs-6 col-xs-offset-2">
                                                    <div class="form-group">
                                                        <button id="reviewModalButton" class="btn btn-default" type="button" data-toggle="modal" data-target="#reviewModal"[#if order.hasExpired() || order.status != "pendingReview"] disabled[/#if]>${message("business.order.review")}</button>
                                                        <!--  [#if currentStore.isSelf()]
																<button id="paymentModalButton" class="btn btn-default" type="button" data-toggle="modal" data-target="#paymentModal"[#if order.hasExpired()] disabled[/#if]>${message("business.order.payment")}</button>
															[/#if]
															<button id="refundsModalButton" class="btn btn-default" type="button" data-toggle="modal" data-target="#refundsModal"[#if order.hasExpired() || order.refundableAmount <= 0] disabled[/#if]>${message("business.order.orderRefunds")}</button>
															-->
                                                        <button id="shippingModalButton" class="btn btn-default" type="button" data-toggle="modal" data-target="#shippingModal"[#if order.shippableQuantity <= 0] disabled[/#if]>${message("business.order.orderShipping")}</button>
                                                        <!--
															<button id="returnsModalButton" class="btn btn-default" type="button" data-toggle="modal" data-target="#returnsModal" >${message("business.order.orderReturns")}</button>

															<button id="returnsModalButton" class="btn btn-default" type="button" data-toggle="modal" data-target="#returnsModal"[#if order.returnableQuantity <= 0] disabled[/#if]>${message("business.order.orderReturns")}</button>
															-->
                                                        <button id="completeModalButton" class="btn btn-default" type="button" data-toggle="modal" data-target="#completeModal"[#if order.hasExpired() || order.status != "received"] disabled[/#if]>${message("business.order.complete")}</button>
                                                        <button id="failModalButton" class="btn btn-default" type="button" data-toggle="modal" data-target="#failModal"[#if order.hasExpired() || (order.status != "pendingShipment" && order.status != "shipped" && order.status != "received")] disabled[/#if]>${message("business.order.fail")}</button>
                                                    </div>
                                                </div>
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
                                                        <dd>${currency(order.amount, true)}</dd>
															[#if order.refundAmount > 0 || order.refundableAmount > 0]
																<dt>${message("Order.refundAmount")}:</dt>
																<dd>${currency(order.refundAmount, true)}</dd>
																<dt>${message("Order.refundableAmount")}:</dt>
																<dd>${currency(order.refundableAmount, true)}</dd>
															[/#if]
                                                        <dt>${message("Order.weight")}:</dt>
                                                        <dd>${order.weight}</dd>
                                                        <dt>${message("Order.shippedQuantity")}:</dt>
                                                        <dd>${order.shippedQuantity}</dd>
                                                        <dt>${message("business.order.promotion")}:</dt>
                                                        <dd>
																[#if order.promotionNames?has_content]
                                                                    <span>${order.promotionNames?join(", ")}</span>
																[#else]
																	-
																[/#if]
                                                        </dd>
                                                        <dt>${message("business.order.coupon")}:</dt>
                                                        <dd>${(order.couponCode.coupon.name)!"-"}</dd>
                                                        <dt>${message("Order.fee")}:</dt>
                                                        <dd>${currency(order.fee, true)}</dd>
                                                        <dt>${message("Order.offsetAmount")}:</dt>
                                                        <dd>${currency(order.offsetAmount, true)}</dd>
                                                        <dt>${message("Order.paymentMethod")}:</dt>
                                                        <dd>${order.paymentMethodName!"-"}</dd>
                                                        <dt>${message("Order.consignee")}:</dt>
                                                        <dd>${order.consignee}</dd>
                                                        <dt>${message("Order.address")}:</dt>
                                                        <dd>${order.address}</dd>
                                                        <dt>${message("Order.phone")}:</dt>
                                                        <dd>${order.phone}</dd>
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
																	<span class="gray-darker">(${message("business.order.hasExpired")})</span>
																[#else]
																	[#if order.expire??]
																		<span class="orange">(${message("Order.expire")}: ${order.expire?string("yyyy-MM-dd HH:mm:ss")})</span>
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
																	<span class="orange">(${message("Order.amountPayable")}: ${currency(order.amountPayable, true)})</span>
																[/#if]
                                                        </dd>
															[#if order.invoice??]
																<dt>${message("Invoice.title")}:</dt>
																<dd>${order.invoice.title}</dd>
																<dt>${message("Order.tax")}:</dt>
																<dd>${currency(order.tax, true)}</dd>
															[/#if]
                                                        <dt>${message("Order.quantity")}:</dt>
                                                        <dd>${order.quantity}</dd>
                                                        <dt>${message("Order.returnedQuantity")}:</dt>
                                                        <dd>${order.returnedQuantity}</dd>
                                                        <dt>${message("Order.promotionDiscount")}:</dt>
                                                        <dd>${currency(order.promotionDiscount, true)}</dd>
                                                        <dt>${message("Order.couponDiscount")}:</dt>
                                                        <dd>${currency(order.couponDiscount, true)}</dd>
                                                        <dt>${message("Order.freight")}:</dt>
                                                        <dd>${currency(order.freight, true)}</dd>
                                                        <dt>${message("Order.rewardPoint")}:</dt>
                                                        <dd>${order.rewardPoint}</dd>
                                                        <dt>${message("Order.shippingMethod")}:</dt>
                                                        <dd>${order.shippingMethodName!"-"}</dd>
                                                        <dt>${message("Order.area")}:</dt>
                                                        <dd>${order.areaName}</dd>
                                                        <dt>${message("Order.zipCode")}:</dt>
                                                        <dd>${order.zipCode}</dd>
                                                        <dt>${message("Order.memo")}:</dt>
                                                        <dd>${order.memo}</dd>
                                                    </dl>
                                                </div>
                                            </div>
                                        </div>
                                        <div id="productInfo" class="tab-pane">
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
                                        <div id="paymentInfo" class="tab-pane">
                                            <table class="table table-hover">
                                                <thead>
                                                <tr>
                                                    <th>${message("OrderPayment.sn")}</th>
                                                    <th>${message("OrderPayment.method")}</th>
                                                    <th>${message("OrderPayment.paymentMethod")}</th>
                                                    <th>${message("OrderPayment.fee")}</th>
                                                    <th>${message("OrderPayment.amount")}</th>
                                                    <th>${message("business.common.createdDate")}</th>
                                                </tr>
                                                </thead>
                                                <tbody>
														[#list order.orderPayments as orderPayment]
                                                        <tr>
                                                            <td>${orderPayment.sn}</td>
                                                            <td>${message("OrderPayment.Method." + orderPayment.method)}</td>
                                                            <td>${orderPayment.paymentMethod!"-"}</td>
                                                            <td>${currency(orderPayment.fee, true)}</td>
                                                            <td>${currency(orderPayment.amount, true)}</td>
                                                            <td>
                                                                <span title="${orderPayment.createdDate?string("yyyy-MM-dd HH:mm:ss")}">${orderPayment.createdDate}</span>
                                                            </td>
                                                        </tr>
														[/#list]
                                                </tbody>
                                            </table>
                                        </div>
                                        <div id="orderRefundsInfo" class="tab-pane">
                                            <table class="table table-hover">
                                                <thead>
                                                <tr>
                                                    <th>${message("OrderRefunds.sn")}</th>
                                                    <th>${message("OrderRefunds.method")}</th>
                                                    <th>${message("OrderRefunds.paymentMethod")}</th>
                                                    <th>${message("OrderRefunds.amount")}</th>
                                                    <th>退款类型</th>
                                                    <th>状态</th>
                                                    <th>退款原因</th>
                                                    <th>退款说明</th>
                                                    <th>${message("business.common.createdDate")}</th>
                                                    <th>操作</th>
                                                </tr>
                                                </thead>
                                                <tbody>
														[#list order.orderRefunds as orderRefunds]
                                                        <tr>
                                                            <td>${orderRefunds.sn}</td>
                                                            <td>${message("OrderRefunds.Method." + orderRefunds.method)}</td>
                                                            <td>${orderRefunds.paymentMethod!"-"}</td>
                                                            <td>${currency(orderRefunds.amount, true)}</td>
                                                            <td>
																[#if orderRefunds.type == "refundsReturns"]退款退货
																[#elseif orderRefunds.type == "onlyRefunds"]仅退款
																[/#if]
                                                            </td>
                                                            <td>${message("OrderRefunds.Status." + orderRefunds.status)}</td>
                                                            <td>${orderRefunds.reason}</td>
                                                            <td>${orderRefunds.content}</td>
                                                            <td>
                                                                <span title="${orderRefunds.createdDate?string("yyyy-MM-dd HH:mm:ss")}">${orderRefunds.createdDate?string("yyyy-MM-dd HH:mm:ss")}</span>
                                                            </td>
                                                            <td>
                                                                <a id="refundsDetail" class="button" data-toggle="modal" data-target="#refundsDetailModel${orderRefunds.orderItem.id}" style="cursor:pointer;">查看</a>
                                                                <!-- 查看退款详情模态框（Modal） -->
                                                                <div class="modal fade" id="refundsDetailModel${orderRefunds.orderItem.id}" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                                                                    <div class="modal-dialog">
                                                                        <div class="modal-content">
                                                                            <div class="modal-header">
                                                                                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                                                                                <h4 class="modal-title" id="myModalLabel">退款详情</h4>
                                                                            </div>
                                                                            <div class="modal-body">
                                                                                <table style="margin-left: auto;margin-right: auto">
                                                                                    <tr>
                                                                                        <td colspan="2"><img src="${orderRefunds.orderItem.thumbnail}"/></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td>订单编号：</td>
                                                                                        <td>${orderRefunds.order.sn}</td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td>退款编号：</td>
                                                                                        <td>${orderRefunds.sn}</td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td>商品名称：</td>
                                                                                        <td>${orderRefunds.orderItem.name}</td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td>商品数量：</td>
                                                                                        <td>${orderRefunds.orderItem.quantity}</td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td>商品单价：</td>
                                                                                        <td>${currency(orderRefunds.orderItem.price,true)}</td>
                                                                                    </tr>
                                                                                </table>
                                                                        	</div>
                                                                        	<div class="modal-footer">
                                                                            <button type="button" lass="btn btn-default" data-dismiss="modal">关闭</button>
                                                                        	</div>
                                                                    	</div><!-- /.modal-content -->
                                                                	</div><!-- /.modal-dialog -->
                                                                </div><!-- /.modal -->
																[#if orderRefunds.status == "pendingAudit"]
																	<a href="javascript:void(0);" id="refundsAuditPass" class="button" onclick="refundsAudit('audited', ${orderRefunds.id})">同意退款</a>
																	<a href="javascript:void(0);" id="refundsAuditNoPass" class="button" onclick="refundsAudit('denied', ${orderRefunds.id})">拒绝退款</a>
																[#elseif orderRefunds.status == "audited"]
																	<a href="javascript:void(0);" id="refundsPay" class="button" onclick="refundsPay(${orderRefunds.id})">立即退款</a>
																[/#if]
                                                            </td>
                                                        </tr>
														[/#list]
                                                </tbody>
                                            </table>
                                        </div>
                                        <div id="orderShippingInfo" class="tab-pane">
                                            <table class="table table-hover">
                                                <thead>
                                                <tr>
                                                    <th>${message("OrderShipping.sn")}</th>
                                                    <th>${message("OrderShipping.shippingMethod")}</th>
                                                    <th>${message("OrderShipping.deliveryCorp")}</th>
                                                    <th>${message("OrderShipping.trackingNo")}</th>
                                                    <th>${message("OrderShipping.consignee")}</th>
                                                    <th>${message("OrderShipping.isDelivery")}</th>
                                                    <th>${message("business.common.createdDate")}</th>
                                                </tr>
                                                </thead>
                                                <tbody>
														[#list order.orderShippings as orderShipping]
                                                        <tr>
                                                            <td>${orderShipping.sn}</td>
                                                            <td>${orderShipping.shippingMethod!"-"}</td>
                                                            <td>${orderShipping.deliveryCorp!"-"}</td>
                                                            <td>
																${orderShipping.trackingNo!"-"}
																	[#if isKuaidi100Enabled && orderShipping.deliveryCorpCode?has_content && orderShipping.trackingNo?has_content]
																		<a id="transitStep" href="javascript:;" data-shipping-id="${orderShipping.id}">[${message("business.order.transitStep")}]</a>
																	[/#if]
                                                            </td>
                                                            <td>${orderShipping.consignee!"-"}</td>
                                                            <td>${message(orderShipping.isDelivery?string('business.common.true', 'business.common.false'))}</td>
                                                            <td>
                                                                <span title="${orderShipping.createdDate?string("yyyy-MM-dd HH:mm:ss")}">${orderShipping.createdDate}</span>
                                                            </td>
                                                        </tr>
														[/#list]
                                                </tbody>
                                            </table>
                                        </div>
                                        <div id="oderReturnsInfo" class="tab-pane">
                                            <table class="table table-hover">
                                                <thead>
                                                <tr>
                                                    <th>${message("OrderReturns.sn")}</th>
                                                    <th>${message("OrderReturns.shippingMethod")}</th>
                                                    <th>${message("OrderReturns.deliveryCorp")}</th>
                                                    <th>${message("OrderReturns.trackingNo")}</th>
                                                    <th>${message("OrderReturns.shipper")}</th>
                                                    <th>${message("business.common.createdDate")}</th>
                                                </tr>
                                                </thead>
                                                <tbody>
														[#list order.orderReturns as orderReturns]
                                                        <tr>
                                                            <td>${orderReturns.sn}</td>
                                                            <td>${orderReturns.shippingMethod!"-"}</td>
                                                            <td>${orderReturns.deliveryCorp!"-"}</td>
                                                            <td>${orderReturns.trackingNo!"-"}</td>
                                                            <td>${orderReturns.shipper}</td>
                                                            <td>
                                                                <span title="${orderReturns.createdDate?string("yyyy-MM-dd HH:mm:ss")}">${orderReturns.createdDate}</span>
                                                            </td>
                                                        </tr>
														[/#list]
                                                </tbody>
                                            </table>
                                        </div>
                                        <div id="orderLog" class="tab-pane">
                                            <table class="table table-hover">
                                                <thead>
                                                <tr>
                                                    <th>${message("OrderLog.type")}</th>
                                                    <th>${message("OrderLog.detail")}</th>
                                                    <th>${message("business.common.createdDate")}</th>
                                                </tr>
                                                </thead>
                                                <tbody>
														[#list order.orderLogs as orderLog]
                                                        <tr>
                                                            <td>${message("OrderLog.Type." + orderLog.type)}</td>
                                                            <td>
																	[#if orderLog.detail??]
                                                                        <span title="${orderLog.detail}">${abbreviate(orderLog.detail, 50, "...")}</span>
																	[#else]
																		-
																	[/#if]
                                                            </td>
                                                            <td>
                                                                <span title="${orderLog.createdDate?string("yyyy-MM-dd HH:mm:ss")}">${orderLog.createdDate}</span>
                                                            </td>
                                                        </tr>
														[/#list]
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </form>
                            </div>
                            <div class="box-footer">
                                <div class="row">
                                    <div class="col-xs-4 col-xs-offset-2">
                                        <button class="btn btn-default" type="button" data-toggle="back">${message("business.common.back")}</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    </div>
		[#include "/business/include/main_footer.ftl" /]
</div>
</body>
</html>