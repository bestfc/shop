<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("member.order.view")}[#if showPowered] [/#if]</title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/member/css/animate.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/member/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/member/css/member.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/member/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/member/js/common.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $dialogOverlay = $("#dialogOverlay");
	var $dialog = $("#dialog");
	var $close = $("#close");
	var $transitStep = $("a.transitStep");
	var $transitStepTable = $("#transitSteps table");
	var $payment = $("#payment");
	var $cancel = $("#cancel");
	var $receive = $("#receive");
	var $transitStep = $("a.transitStep");
    var $refundsCancel = $("#refundsCancel");
	
	[#if flashMessage?has_content]
		$.alert("${flashMessage}");
	[/#if]
	
	// 订单支付
	$payment.click(function() {
		$.ajax({
			url: "check_lock",
			type: "POST",
			data: {orderSn: ${order.sn}},
			dataType: "json",
			cache: false,
			success: function() {
				location.href = "${base}/order/payment?orderSns=${order.sn}";
			}
		});
		return false;
	});
	
	// 订单取消
	$cancel.click(function() {
		if (confirm("${message("member.order.cancelConfirm")}")) {
			$.ajax({
				url: "cancel?orderSn=${order.sn}",
				type: "POST",
				dataType: "json",
				cache: false,
				success: function() {
					location.reload(true);
				}
			});
		}
		return false;
	});
	
	// 订单收货
	$receive.click(function() {
		if (confirm("${message("member.order.receiveConfirm")}")) {
			$.ajax({
				url: "receive?orderSn=${order.sn}",
				type: "POST",
				dataType: "json",
				cache: false,
				success: function() {
					location.reload(true);
				}
			});
		}
		return false;
	});
	
	// 物流动态
	$transitStep.click(function() {
		var $this = $(this);
		$.ajax({
			url: "transit_step?orderShippingSn=" + $this.attr("shippingSn"),
			type: "GET",
			dataType: "json",
			cache: true,
			beforeSend: function() {
				$this.hide().after('<span class="loadingIcon">&nbsp;<\/span>');
			},
			success: function(data) {
				if (data.transitSteps.length <= 0) {
					$.alert("${message("member.common.noResult")}");
					return false;
				}
				$dialog.show();
				$dialogOverlay.show();
				$transitStepTable.empty();
				$.each(data.transitSteps, function(i, transitStep) {
					$transitStepTable.append(
						[@compress single_line = true]
							'<tr>
								<th>' + escapeHtml(transitStep.time) + '<\/th>
								<td>' + escapeHtml(transitStep.context) + '<\/td>
							<\/tr>'
						[/@compress]
					);
				});
			},
			complete: function() {
				$this.show().next("span.loadingIcon").remove();
			}
		});
		return false;
	});
	
	// 关闭物流动态
	$close.click(function() {
		$dialog.hide();
		$dialogOverlay.hide();
	});

});
    // 退款取消
    function refundsCancel(sn) {
        if (confirm("确认取消退款吗？")) {
            $.ajax({
                url: "${base}/member/order/refunds-cancel?sn="+sn,
                type: "POST",
                dataType: "json",
                success: function() {
                    setTimeout(function() {
                        location.reload();
                    }, 1000);
                }
            });
        }
        return false;
    }
</script>
</head>
<body>
	<div id="dialogOverlay" class="dialogOverlay"></div>
	[#assign current = "orderList" /]
	[#include "/shop/include/header.ftl" /]
	<div class="container member">
		<div class="row">
			[#include "/member/include/navigation.ftl" /]
			<div class="span10">
				<div class="input order">
					<div id="dialog" class="dialog">
						<div id="close" class="close"></div>
						<ul>
							<li>${message("member.order.time")}</li>
							<li>${message("member.order.content")}</li>
						</ul>
						<div id="transitSteps" class="transitSteps">
							<table></table>
						</div>
					</div>
					<div class="title">${message("member.order.view")}</div>
					<div class="top">
						<span>${message("Order.sn")}: ${order.sn}</span>
						<span>
							[#if order.hasExpired()]
								${message("Order.status")}: <strong>${message("member.order.hasExpired")}</strong>
							[#else]
								${message("Order.status")}: <strong>${message("Order.Status." + order.status)}</strong>
							[/#if]
						</span>
                        <div class="action">
							[#--[#if order.paymentMethod?? && order.amountPayable > 0]--]
							[#if !order.hasExpired() && order.status == "pendingPayment"]
								<a href="javascript:;" id="payment" class="button">${message("member.order.payment")}</a>
							[/#if]
							[#if !order.hasExpired() && (order.status == "pendingPayment" || order.status == "pendingReview")]
								<a href="javascript:;" id="cancel" class="button">${message("member.order.cancel")}</a>
							[/#if]
							[#if !order.hasExpired() && order.status == "shipped"]
								<a href="javascript:;" id="receive" class="button">${message("member.order.receive")}</a>
							[/#if]
                        </div>
						<div class="tips">
							[#if order.hasExpired()]
								${message("member.order.hasExpiredTips")}
							[#elseif order.status == "pendingPayment"]
								${message("member.order.pendingPaymentTips")}
							[#elseif order.status == "pendingReview"]
								${message("member.order.pendingReviewTips")}
							[#elseif order.status == "pendingShipment"]
								${message("member.order.pendingShipmentTips")}
							[#elseif order.status == "shipped"]
								${message("member.order.shippedTips")}
							[#elseif order.status == "received"]
								${message("member.order.receivedTips")}
							[#elseif order.status == "completed"]
								${message("member.order.completedTips")}
							[#elseif order.status == "failed"]
								${message("member.order.failedTips")}
							[#elseif order.status == "canceled"]
								${message("member.order.canceledTips")}
							[#elseif order.status == "denied"]
								${message("member.order.deniedTips")}
							[/#if]
							[#if order.expire?? && !order.hasExpired()]
								<em>(${message("Order.expire")}: ${order.expire?string("yyyy-MM-dd HH:mm:ss")})</em>
							[/#if]
						</div>
					</div>
					<table class="info">
						<tr>
							<th>
								${message("member.common.createdDate")}:
							</th>
							<td>
								${order.createdDate?string("yyyy-MM-dd HH:mm:ss")}
							</td>
						</tr>
						[#if order.paymentMethodName??]
							<tr>
								<th>
									${message("Order.paymentMethod")}:
								</th>
								<td>
									${order.paymentMethodName}
								</td>
							</tr>
						[/#if]
						[#if order.shippingMethodName??]
							<tr>
								<th>
									${message("Order.shippingMethod")}:
								</th>
								<td>
									${order.shippingMethodName}
								</td>
							</tr>
						[/#if]
						<tr>
							<th>
								${message("Order.price")}:
							</th>
							<td>
								${currency(order.price, true)}
							</td>
						</tr>
						[#if order.fee > 0]
							<tr>
								<th>
									${message("Order.fee")}:
								</th>
								<td>
									${currency(order.fee, true)}
								</td>
							</tr>
						[/#if]
						[#if order.freight > 0]
							<tr>
								<th>
									${message("Order.freight")}:
								</th>
								<td>
									${currency(order.freight, true)}
								</td>
							</tr>
						[/#if]
						[#if order.promotionDiscount > 0]
							<tr>
								<th>
									${message("Order.promotionDiscount")}:
								</th>
								<td>
									${currency(order.promotionDiscount, true)}
								</td>
							</tr>
						[/#if]
						[#if order.couponDiscount > 0]
							<tr>
								<th>
									${message("Order.couponDiscount")}:
								</th>
								<td>
									${currency(order.couponDiscount, true)}
								</td>
							</tr>
						[/#if]
						[#if order.offsetAmount != 0]
							<tr>
								<th>
									${message("Order.offsetAmount")}:
								</th>
								<td>
									${currency(order.offsetAmount, true)}
								</td>
							</tr>
						[/#if]
						<tr>
							<th>
								${message("Order.amount")}:
							</th>
							<td>
								${currency(order.amount, true)}
							</td>
						</tr>
						[#if order.amountPaid > 0]
							<tr>
								<th>
									${message("Order.amountPaid")}:
								</th>
								<td>
									${currency(order.amountPaid, true)}
								</td>
							</tr>
						[/#if]
						[#if order.refundAmount > 0]
							<tr>
								<th>
									${message("Order.refundAmount")}:
								</th>
								<td>
									${currency(order.refundAmount, true)}
								</td>
							</tr>
						[/#if]
						[#if order.amountPayable > 0]
							<tr>
								<th>
									${message("Order.amountPayable")}:
								</th>
								<td>
									${currency(order.amountPayable, true)}
								</td>
							</tr>
						[/#if]
						[#if order.rewardPoint > 0]
							<tr>
								<th>
									${message("Order.rewardPoint")}:
								</th>
								<td>
									${order.rewardPoint}
								</td>
							</tr>
						[/#if]
						[#if order.exchangePoint > 0]
							<tr>
								<th>
									${message("Order.exchangePoint")}:
								</th>
								<td>
									${order.exchangePoint}
								</td>
							</tr>
						[/#if]
						[#if order.couponCode??]
							<tr>
								<th>
									${message("member.order.coupon")}:
								</th>
								<td>
									${order.couponCode.coupon.name}
								</td>
							</tr>
						[/#if]
						[#if order.promotionNames?has_content]
							<tr>
								<th>
									${message("member.order.promotion")}:
								</th>
								<td>
									${order.promotionNames?join(", ")}
								</td>
							</tr>
						[/#if]
						<tr>
							<th>
								${message("Order.memo")}:
							</th>
							<td>
								${order.memo}
							</td>
						</tr>
					</table>
					[#if order.invoice??]
						<table class="info">
							<tr>
								<th>
									${message("Invoice.title")}:
								</th>
								<td>
									${order.invoice.title}
								</td>
							</tr>
							<tr>
								<th>
									${message("Order.tax")}:
								</th>
								<td>
									${currency(order.tax, true)}
								</td>
							</tr>
						</table>
					[/#if]
					[#if order.isDelivery]
						<table class="info">
							<tr>
								<th>
									${message("Order.consignee")}:
								</th>
								<td>
									${order.consignee}
								</td>
							</tr>
							<tr>
								<th>
									${message("Order.zipCode")}:
								</th>
								<td>
									${order.zipCode}
								</td>
							</tr>
							<tr>
								<th>
									${message("Order.address")}:
								</th>
								<td>
									${order.areaName}${order.address}
								</td>
							</tr>
							<tr>
								<th>
									${message("Order.phone")}:
								</th>
								<td>
									${order.phone}
								</td>
							</tr>
						</table>
					[/#if]
					[#if order.orderShippings?has_content]
						<table class="info">
							[#list order.orderShippings as orderShipping]
								<tr>
									<th>
										${message("OrderShipping.deliveryCorp")}:
									</th>
									<td>
										[#if orderShipping.deliveryCorpUrl??]
											<a href="${orderShipping.deliveryCorpUrl}" target="_blank">${orderShipping.deliveryCorp}</a>
										[#else]
											${orderShipping.deliveryCorp!"-"}
										[/#if]
									</td>
									<th>
										${message("OrderShipping.trackingNo")}:
									</th>
									<td width="260">
										${orderShipping.trackingNo!"-"}
										[#if isKuaidi100Enabled && orderShipping.deliveryCorpCode?has_content && orderShipping.trackingNo?has_content]
											<a href="javascript:;" class="transitStep" shippingSn="${orderShipping.sn}">[${message("member.order.transitStep")}]</a>
										[/#if]
									</td>
									<th>
										${message("member.order.deliveryDate")}:
									</th>
									<td>
										${orderShipping.createdDate?string("yyyy-MM-dd HH:mm")}
									</td>
								</tr>
								[#if shippingTraces??]
								    [#list shippingTraces as shippingTrace]
										[#if shippingTrace.trackingNo == orderShipping.trackingNo]
											<tr>
												<td colspan="6" style="padding-left: 70px;padding-right: 70px">
													<ul>
														[#list shippingTrace.traces?eval as jsonitem]
															<li style="border-top: inset;border-top-width: thin;border-top-style: outset;line-height: 20px;padding: 8px 0px 8px 0px;">
																<p style="color: red">${jsonitem.acceptTime} (${jsonitem.remark})</p>
                                                                <p>${jsonitem.acceptStation}</p>
															</li>
														[/#list]
													</ul>
												</td>
											</tr>
										[/#if]
									[/#list]
								[/#if]
								<tr></tr>
							[/#list]
						</table>
					[/#if]
					<table class="orderItem">
						<tr>
							<th>
								${message("OrderItem.sn")}
							</th>
							<th>
								${message("OrderItem.name")}
							</th>
							<th>
								${message("OrderItem.price")}
							</th>
							<th>
								${message("OrderItem.quantity")}
							</th>
							<th>
								${message("OrderItem.subtotal")}
							</th>
							<th></th>
                            <th></th>
						</tr>
						[#list order.orderItems as orderItem]
							<tr>
								<td>
									${orderItem.sn}
								</td>
								<td>
									[#if orderItem.sku??]
										<a href="${base}${orderItem.sku.path}" title="${orderItem.name}" target="_blank">${abbreviate(orderItem.name, 30)}</a>
									[#else]
										<span title="${orderItem.name}">${abbreviate(orderItem.name, 30)}</span>
									[/#if]
									[#if orderItem.specifications?has_content]
										<span class="silver">[${orderItem.specifications?join(", ")}]</span>
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
								[#assign orderRefund=orderItem.getOrderRefund()]
								[#if orderRefund?has_content]
									[#if orderRefund.status == "pendingAudit" ]
										<td style="max-width: 125px">
											<a href="javascript:;" id="refundsCancel" onclick="refundsCancel(${orderItem.sn})" class="button">取消退款</a>
											[#if !orderItem.order.orderReturns?has_content && orderRefund.type == "refundsReturns"]
												<a href="returns?sn=${orderItem.sn}" id="returns" class="button">填写退货物流</a>
											[/#if]
										</td>
									[/#if]
									<td style="color: red">
										${message("OrderRefunds.Status." + orderRefund.status)}
									</td>
								<!-- 等待审核/等待发货/已发货/已收货状态下可退款 -->
								[#elseif !orderItem.order.hasExpired() && (orderItem.order.status == "pendingShipment" || orderItem.order.status == "shipped" || orderItem.order.status == "received")]
									<td style="max-width: 125px">
										<a href="refunds?sn=${orderItem.sn}" id="refunds" class="button">申请退款</a>
									</td>
								[/#if]
							</tr>
						[/#list]
					</table>
				</div>
			</div>
		</div>
	</div>
	[#include "/shop/include/footer.ftl" /]
</body>
</html>