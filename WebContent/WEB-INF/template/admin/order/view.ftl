<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("admin.order.view")} </title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.tools.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.lSelect.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/input.js"></script>
<style type="text/css">
	.shipping, .returns {
		height: 380px;
		overflow-x: hidden;
		overflow-y: auto;
	}
	
	.shipping .item, .returns .item {
		margin: 6px 0px;
	}
	
	.transitSteps {
		height: 240px;
		line-height: 28px;
		padding: 0px 6px;
		overflow-x: hidden;
		overflow-y: auto;
	}
	
	.transitSteps th {
		width: 150px;
		color: #888888;
		font-weight: normal;
		text-align: left;
	}
</style>
<script type="text/javascript">
$().ready(function() {

	// 物流动态
	$transitStep.click(function() {
		var $this = $(this);
		$.ajax({
			url: "transit_step?shippingId=" + $this.attr("shippingId"),
			type: "GET",
			dataType: "json",
			cache: true,
			beforeSend: function() {
				$this.hide().after('<span class="loadingIcon">&nbsp;<\/span>');
			},
			success: function(data) {
				if (data.message.type == "success") {
					if (data.transitSteps.length <= 0) {
						$.message("warn", "${message("admin.order.noResult")}");
						return false;
					}
					var transitStepsHtml = "";
					$.each(data.transitSteps, function(i, transitStep) {
						transitStepsHtml += 
							[@compress single_line = true]
								'<tr>
									<th>' + escapeHtml(transitStep.time) + '<\/th>
									<td>' + escapeHtml(transitStep.context) + '<\/td>
								<\/tr>'
							[/@compress]
						;
					});
					$.dialog({
						title: "${message("admin.order.transitStep")}",
						content: 
							[@compress single_line = true]
								'<div class="transitSteps">
									<table>' + transitStepsHtml + '<\/table>
								<\/div>'
							[/@compress]
						,
						width: 600,
						modal: true,
						ok: null,
						cancel: null
					});
				} else {
					$.message(data.message);
				}
			},
			complete: function() {
				$this.show().next("span.loadingIcon").remove();
			}
		});
		return false;
	});

});
</script>
</head>
<body>
	<div class="breadcrumb">
		<a href="${base}/admin/index">${message("admin.breadcrumb.home")}</a> &raquo; ${message("admin.order.view")}
	</div>
	<ul id="tab" class="tab">
		<li>
			<input type="button" value="${message("admin.order.orderInfo")}" />
		</li>
		<li>
			<input type="button" value="${message("admin.order.productInfo")}" />
		</li>
		<li>
			<input type="button" value="${message("admin.order.paymentInfo")}" />
		</li>
		<li>
			<input type="button" value="${message("admin.order.orderRefundsInfo")}" />
		</li>
		<li>
			<input type="button" value="${message("admin.order.orderShippingInfo")}" />
		</li>
		<li>
			<input type="button" value="${message("admin.order.orderReturnsInfo")}" />
		</li>
		<li>
			<input type="button" value="${message("admin.order.orderLog")}" />
		</li>
	</ul>
	<table class="input tabContent">
		<tr>
			<th>
				${message("Order.sn")}:
			</th>
			<td width="360">
				${order.sn}
			</td>
			<th>
				${message("admin.common.createdDate")}:
			</th>
			<td>
				${order.createdDate?string("yyyy-MM-dd HH:mm:ss")}
			</td>
		</tr>
		<tr>
			<th>
				${message("Order.type")}:
			</th>
			<td>
				${message("Order.Type." + order.type)}
			</td>
			<th>
				${message("Order.status")}:
			</th>
			<td>
				${message("Order.Status." + order.status)}
				[#if order.hasExpired()]
					<span class="silver">(${message("admin.order.hasExpired")})</span>
				[#else]
					[#if order.expire??]
						<span class="silver">(${message("Order.expire")}: ${order.expire?string("yyyy-MM-dd HH:mm:ss")})</span>
					[/#if]
				[/#if]
			</td>
		</tr>
		<tr>
			<th>
				${message("Order.member")}:
			</th>
			<td>
				<a href="../member/view?id=${order.member.id}">${order.member.username}</a>
			</td>
			<th>
				${message("Member.memberRank")}:
			</th>
			<td>
				${order.member.memberRank.name}
			</td>
		</tr>
		<tr>
			<th>
				${message("Order.store")}:
			</th>
			<td>
				${order.store.name}
			</td>
			<th>
				${message("Store.storeRank")}:
			</th>
			<td>
				${order.store.storeRank.name}
			</td>
		</tr>
		<tr>
			<th>
				${message("Order.price")}:
			</th>
			<td>
				${currency(order.price, true)}
			</td>
			<th>
				${message("Order.exchangePoint")}:
			</th>
			<td>
				${order.exchangePoint}
			</td>
		</tr>
		<tr>
			<th>
				${message("Order.amount")}:
			</th>
			<td>
				<span class="red">${currency(order.amount, true)}</span>
			</td>
			<th>
				${message("Order.amountPaid")}:
			</th>
			<td>
				${currency(order.amountPaid, true)}
				[#if order.amountPayable > 0]
					<span class="silver">(${message("Order.amountPayable")}: ${currency(order.amountPayable, true)})</span>
				[/#if]
			</td>
		</tr>
		[#if order.refundAmount > 0 || order.refundableAmount > 0]
			<tr>
				<th>
					${message("Order.refundAmount")}:
				</th>
				<td>
					${currency(order.refundAmount, true)}
				</td>
				<th>
					${message("Order.refundableAmount")}:
				</th>
				<td>
					${currency(order.refundableAmount, true)}
				</td>
			</tr>
		[/#if]
		<tr>
			<th>
				${message("Order.weight")}:
			</th>
			<td>
				${order.weight}
			</td>
			<th>
				${message("Order.quantity")}:
			</th>
			<td>
				${order.quantity}
			</td>
		</tr>
		<tr>
			<th>
				${message("Order.shippedQuantity")}:
			</th>
			<td>
				${order.shippedQuantity}
			</td>
			<th>
				${message("Order.returnedQuantity")}:
			</th>
			<td>
				${order.returnedQuantity}
			</td>
		</tr>
		<tr>
			<th>
				${message("admin.order.promotion")}:
			</th>
			<td>
				[#if order.promotionNames?has_content]
					${order.promotionNames?join(", ")}
				[#else]
					-
				[/#if]
			</td>
			<th>
				${message("Order.promotionDiscount")}:
			</th>
			<td>
				${currency(order.promotionDiscount, true)}
			</td>
		</tr>
		<tr>
			<th>
				${message("admin.order.coupon")}:
			</th>
			<td>
				${(order.couponCode.coupon.name)!"-"}
			</td>
			<th>
				${message("Order.couponDiscount")}:
			</th>
			<td>
				${currency(order.couponDiscount, true)}
			</td>
		</tr>
		<tr>
			<th>
				${message("Order.fee")}:
			</th>
			<td>
				${currency(order.fee, true)}
			</td>
			<th>
				${message("Order.freight")}:
			</th>
			<td>
				${currency(order.freight, true)}
			</td>
		</tr>
		<tr>
			<th>
				${message("Order.offsetAmount")}:
			</th>
			<td>
				${currency(order.offsetAmount, true)}
			</td>
			<th>
				${message("Order.rewardPoint")}:
			</th>
			<td>
				${order.rewardPoint}
			</td>
		</tr>
		<tr>
			<th>
				${message("Order.paymentMethod")}:
			</th>
			<td>
				${order.paymentMethodName!"-"}
			</td>
			<th>
				${message("Order.shippingMethod")}:
			</th>
			<td>
				${order.shippingMethodName!"-"}
			</td>
		</tr>
		[#if order.invoice??]
			<tr>
				<th>
					${message("Invoice.title")}:
				</th>
				<td>
					${order.invoice.title}
				</td>
				<th>
					${message("Order.tax")}:
				</th>
				<td>
					${currency(order.tax, true)}
				</td>
			</tr>
		[/#if]
		<tr>
			<th>
				${message("Order.consignee")}:
			</th>
			<td>
				${order.consignee}
			</td>
			<th>
				${message("Order.area")}:
			</th>
			<td>
				${order.areaName}
			</td>
		</tr>
		<tr>
			<th>
				${message("Order.address")}:
			</th>
			<td>
				${order.address}
			</td>
			<th>
				${message("Order.zipCode")}:
			</th>
			<td>
				${order.zipCode}
			</td>
		</tr>
		<tr>
			<th>
				${message("Order.phone")}:
			</th>
			<td>
				${order.phone}
			</td>
			<th>
				${message("Order.memo")}:
			</th>
			<td>
				${order.memo}
			</td>
		</tr>
	</table>
	<table class="item tabContent">
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
		</tr>
		[#list order.orderItems as orderItem]
			<tr>
				<td>
					${orderItem.sn}
				</td>
				<td width="400">
					[#if orderItem.sku??]
						<a href="${base}${orderItem.sku.path}" title="${orderItem.name}" target="_blank">${abbreviate(orderItem.name, 50, "...")}</a>
					[#else]
						<span title="${orderItem.name}">${abbreviate(orderItem.name, 50, "...")}</span>
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
			</tr>
		[/#list]
	</table>
	<table class="item tabContent">
		<tr>
			<th>
				${message("OrderPayment.sn")}
			</th>
			<th>
				${message("OrderPayment.method")}
			</th>
			<th>
				${message("OrderPayment.paymentMethod")}
			</th>
			<th>
				${message("OrderPayment.fee")}
			</th>
			<th>
				${message("OrderPayment.amount")}
			</th>
			<th>
				${message("admin.common.createdDate")}
			</th>
		</tr>
		[#list order.orderPayments as orderPayment]
			<tr>
				<td>
					${payment.sn}
				</td>
				<td>
					${message("OrderPayment.Method." + orderPayment.method)}
				</td>
				<td>
					${orderPayment.paymentMethod!"-"}
				</td>
				<td>
					${currency(orderPayment.fee, true)}
				</td>
				<td>
					${currency(orderPayment.amount, true)}
				</td>
				<td>
					<span title="${orderPayment.createdDate?string("yyyy-MM-dd HH:mm:ss")}">${orderPayment.createdDate}</span>
				</td>
			</tr>
		[/#list]
	</table>
	<table class="item tabContent">
		<tr>
			<th>
				${message("OrderRefunds.sn")}
			</th>
			<th>
				${message("OrderRefunds.method")}
			</th>
			<th>
				${message("OrderRefunds.paymentMethod")}
			</th>
			<th>
				${message("OrderRefunds.amount")}
			</th>
			<th>
				${message("admin.common.createdDate")}
			</th>
		</tr>
		[#list order.orderRefunds as orderRefunds]
			<tr>
				<td>
					${orderRefunds.sn}
				</td>
				<td>
					${message("OrderRefunds.Method." + orderRefunds.method)}
				</td>
				<td>
					${orderRefunds.paymentMethod!"-"}
				</td>
				<td>
					${currency(orderRefunds.amount, true)}
				</td>
				<td>
					<span title="${orderRefunds.createdDate?string("yyyy-MM-dd HH:mm:ss")}">${orderRefunds.createdDate}</span>
				</td>
			</tr>
		[/#list]
	</table>
	<table class="item tabContent">
		<tr>
			<th>
				${message("OrderShipping.sn")}
			</th>
			<th>
				${message("OrderShipping.shippingMethod")}
			</th>
			<th>
				${message("OrderShipping.deliveryCorp")}
			</th>
			<th>
				${message("OrderShipping.trackingNo")}
			</th>
			<th>
				${message("OrderShipping.consignee")}
			</th>
			<th>
				${message("OrderShipping.isDelivery")}
			</th>
			<th>
				${message("admin.common.createdDate")}
			</th>
		</tr>
		[#list order.orderShippings as orderShipping]
			<tr>
				<td>
					${orderShipping.sn}
				</td>
				<td>
					${orderShipping.shippingMethod!"-"}
				</td>
				<td>
					${orderShipping.deliveryCorp!"-"}
				</td>
				<td width="260">
					${orderShipping.trackingNo!"-"}
					[#if isKuaidi100Enabled && orderShipping.deliveryCorpCode?has_content && orderShipping.trackingNo?has_content]
						<a href="javascript:;" class="transitStep" shippingId="${orderShipping.id}">[${message("admin.order.transitStep")}]</a>
					[/#if]
				</td>
				<td>
					${orderShipping.consignee!"-"}
				</td>
				<td>
					${message(orderShipping.isDelivery?string('admin.common.true', 'admin.common.false'))}
				</td>
				<td>
					<span title="${orderShipping.createdDate?string("yyyy-MM-dd HH:mm:ss")}">${orderShipping.createdDate}</span>
				</td>
			</tr>
		[/#list]
	</table>
	<table class="item tabContent">
		<tr>
			<th>
				${message("OrderReturns.sn")}
			</th>
			<th>
				${message("OrderReturns.shippingMethod")}
			</th>
			<th>
				${message("OrderReturns.deliveryCorp")}
			</th>
			<th>
				${message("OrderReturns.trackingNo")}
			</th>
			<th>
				${message("OrderReturns.shipper")}
			</th>
			<th>
				${message("admin.common.createdDate")}
			</th>
		</tr>
		[#list order.orderReturns as orderReturns]
			<tr>
				<td>
					${orderReturns.sn}
				</td>
				<td>
					${orderReturns.shippingMethod!"-"}
				</td>
				<td>
					${orderReturns.deliveryCorp!"-"}
				</td>
				<td>
					${orderReturns.trackingNo!"-"}
				</td>
				<td>
					${orderReturns.shipper}
				</td>
				<td>
					<span title="${orderReturns.createdDate?string("yyyy-MM-dd HH:mm:ss")}">${orderReturns.createdDate}</span>
				</td>
			</tr>
		[/#list]
	</table>
	<table class="item tabContent">
		<tr>
			<th>
				${message("OrderLog.type")}
			</th>
			<th>
				${message("OrderLog.detail")}
			</th>
			<th>
				${message("admin.common.createdDate")}
			</th>
		</tr>
		[#list order.orderLogs as orderLog]
			<tr>
				<td>
					${message("OrderLog.Type." + orderLog.type)}
				</td>
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
	</table>
	<table class="input">
		<tr>
			<th>
				&nbsp;
			</th>
			<td>
				<input type="button" class="button" value="${message("admin.common.back")}" onclick="history.back(); return false;" />
			</td>
		</tr>
	</table>
</body>
</html>