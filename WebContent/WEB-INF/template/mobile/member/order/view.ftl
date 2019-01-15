<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.order.view")}[#if showPowered] [/#if]</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/mobile/member/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/animate.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/common.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/profile.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/mobile/member/js/html5shiv.js"></script>
		<script src="${base}/resources/mobile/member/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/mobile/member/js/jquery.js"></script>
	<script src="${base}/resources/mobile/member/js/bootstrap.js"></script>
	<script src="${base}/resources/mobile/member/js/underscore.js"></script>
	<script src="${base}/resources/mobile/member/js/common.js"></script>
	<script id="transitStepTemplate" type="text/template">
		<%if (_.isEmpty(data.transitSteps)) {%>
			<p class="gray-darker">${message("member.common.noResult")}</p>
		<%} else {%>
			<div class="list-group list-group-flat">
				<%_.each(data.transitSteps, function(transitStep, i) {%>
					<div class="list-group-item small">
						<p class="gray-darker"><%-transitStep.time%></p>
						<p><%-transitStep.context%></p>
					</div>
				<%})%>
			</div>
		<%}%>
	</script>
	<script type="text/javascript">
		$().ready(function() {
			
			var $payment = $("#payment");
			var $cancel = $("#cancel");
			var $receive = $("#receive");
			var $transitStep = $("a.transitStep");
			var $transitStepModal = $("#transitStepModal");
			var $transitStepModalBody = $("#transitStepModal div.modal-body");
			var transitStepTemplate = _.template($("#transitStepTemplate").html());
			
			[#if flashMessage?has_content]
				$.alert("${flashMessage}");
			[/#if]
			
			// 订单支付
			$payment.click(function() {
				$.ajax({
					url: "check_lock",
					type: "POST",
					data: {
						orderSn: ${order.sn}
					},
					dataType: "json",
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
						url: "${base}/member/order/cancel?orderSn=${order.sn}",
						type: "POST",
						dataType: "json",
						success: function() {
							setTimeout(function() {
								location.reload();
							}, 3000);
						}
					});
				}
				return false;
			});
			
			// 订单收货
			$receive.click(function() {
				if (confirm("${message("member.order.receiveConfirm")}")) {
					$.ajax({
						url: "${base}/member/order/receive?orderSn=${order.sn}",
						type: "POST",
						dataType: "json",
						success: function() {
							setTimeout(function() {
								location.reload();
							}, 3000);
						}
					});
				}
				return false;
			});
			
			// 物流动态
			$transitStep.click(function() {
				var $element = $(this);
				$.ajax({
					url: "${base}/member/order/transit_step",
					type: "GET",
					data: {
						orderShippingSn: $element.data("order-shipping-sn")
					},
					dataType: "json",
					beforeSend: function() {
						$transitStepModalBody.empty();
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
<body class="profile">
	<div id="transitStepModal" class="transit-step-modal modal fade" tabindex="-1">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button class="close" type="button" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">${message("member.order.transitStep")}</h4>
				</div>
				<div class="modal-body"></div>
				<div class="modal-footer">
					<button class="btn btn-sm btn-default" type="button" data-dismiss="modal">${message("member.order.close")}</button>
				</div>
			</div>
		</div>
	</div>
	<header class="header-fixed">
		<a class="pull-left" href="${base}/member/order/list">
			<span class="glyphicon glyphicon-menu-left"></span>
		</a>
		${message("member.order.view")}
	</header>
	<main>
		<div class="container-fluid">
			<div class="list-group list-group-flat">
				<div class="list-group-item">
					<span class="small">${message("Order.sn")}: ${order.sn}</span>
					[#if order.hasExpired()]
						<em class="pull-right gray-darker">${message("member.order.hasExpired")}</em>
					[#else]
						<em class="pull-right orange">${message("Order.Status." + order.status)}</em>
					[/#if]
				</div>
			</div>
			<div class="list-group list-group-flat small">
				<div class="list-group-item">
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
				</div>
				[#if order.expire?? && !order.hasExpired()]
					<div class="list-group-item orange">${message("Order.expire")}: ${order.expire?string("yyyy-MM-dd HH:mm:ss")}</div>
				[/#if]
			</div>
			[#if order.isDelivery]
				<div class="list-group list-group-flat">
					<div class="list-group-item">
						${message("Order.consignee")}: ${abbreviate(order.consignee, 10, "...")}
						<span class="pull-right">${message("Order.phone")}: ${order.phone}</span>
					</div>
					<div class="list-group-item">${message("Order.address")}: ${order.areaName}${order.address}</div>
				</div>
			[/#if]
			<div class="list-group list-group-flat">
				<div class="list-group-item">${message("Store.name")}: ${order.store.name}</div>
				[#list order.orderItems as orderItem]
					<div class="list-group-item">
						<div class="media">
							<div class="media-left media-middle">
								<a href="${base}${orderItem.sku.path}">
									<img src="${orderItem.thumbnail!setting.defaultThumbnailProductImage}" alt="${orderItem.name}">
								</a>
							</div>
							<div class="media-body media-middle">
								<h4 class="media-heading">
									<a href="${base}${orderItem.sku.path}">${orderItem.name}</a>
								</h4>
								[#if orderItem.specifications?has_content]
									<span class="small gray-darker">${orderItem.specifications?join(", ")}</span>
								[/#if]
								[#if orderItem.type != "general"]
									<strong class="small red">[${message("Product.Type." + orderItem.type)}]</strong>
								[/#if]
							</div>
							<div class="media-right media-middle">
								${currency(orderItem.price, true)}
								<span class="small gray-darker">&times; ${orderItem.quantity}</span>
							</div>
						</div>
					</div>
				[/#list]
				<div class="list-group-item small">${message("member.common.createdDate")}: ${order.createdDate?string("yyyy-MM-dd HH:mm:ss")}</div>
			</div>
			<div class="list-group list-group-flat small">
				<div class="list-group-item">
					${message("member.order.quantity", order.quantity)}
					<span class="pull-right">
						${message("Order.amount")}:
						<span class="red">${currency(order.amount, true)}</span>
					</span>
				</div>
				[#if order.paymentMethodName?has_content || order.shippingMethodName?has_content]
					<div class="list-group-item">
						${message("Order.paymentMethod")}: ${(order.paymentMethodName)!"-"}
						<span class="pull-right">${message("Order.shippingMethod")}: ${(order.shippingMethodName)!"-"}</span>
					</div>
				[/#if]
				[#if order.invoice??]
					<div class="list-group-item">
						${message("Invoice.title")}: ${order.invoice.title}
						[#if order.tax > 0]
							<span class="pull-right">${message("Order.tax")}: ${currency(order.tax, true)}</span>
						[/#if]
					</div>
				[/#if]
			</div>
			[#if order.orderShippings?has_content]
				<div class="list-group list-group-flat small">
					[#list order.orderShippings as orderShipping]
						<div class="list-group-item">
							${message("OrderShipping.deliveryCorp")}:
							[#if orderShipping.deliveryCorp??]
								${orderShipping.deliveryCorp}
							[#else]
								${orderShipping.deliveryCorp!"-"}
							[/#if]
							[#if isKuaidi100Enabled && orderShipping.deliveryCorpCode?has_content && orderShipping.trackingNo?has_content]
								<a class="transitStep" href="javascript:;" data-order-shipping-sn="${orderShipping.sn}">[${message("member.common.view")}]</a>
							[/#if]
							<span class="pull-right">
								${message("OrderShipping.trackingNo")}:
								[#if orderShipping.trackingNo??]
									${orderShipping.trackingNo}
								[#else]
									${orderShipping.trackingNo!"-"}
								[/#if]
							</span>
						</div>
					[/#list]
				</div>
			[/#if]
			<div class="list-group list-group-flat small">
				[#if order.fee > 0]
					<div class="list-group-item">
						${message("Order.fee")}
						<span class="pull-right">${currency(order.fee, true)}</span>
					</div>
				[/#if]
				[#if order.freight > 0]
					<div class="list-group-item">
						${message("Order.freight")}
						<span class="pull-right">${currency(order.freight, true)}</span>
					</div>
				[/#if]
				[#if order.promotionDiscount > 0]
					<div class="list-group-item">
						${message("Order.promotionDiscount")}
						<span class="pull-right">${currency(order.promotionDiscount, true)}</span>
					</div>
				[/#if]
				[#if order.couponDiscount > 0]
					<div class="list-group-item">
						${message("Order.couponDiscount")}
						<span class="pull-right">${currency(order.couponDiscount, true)}</span>
					</div>
				[/#if]
				[#if order.offsetAmount != 0]
					<div class="list-group-item">
						${message("Order.offsetAmount")}
						<span class="pull-right">${currency(order.offsetAmount, true)}</span>
					</div>
				[/#if]
				[#if order.amountPaid > 0]
					<div class="list-group-item">
						${message("Order.amountPaid")}
						<span class="pull-right">${currency(order.amountPaid, true)}</span>
					</div>
				[/#if]
				[#if order.refundAmount > 0]
					<div class="list-group-item">
						${message("Order.refundAmount")}
						<span class="pull-right">${currency(order.refundAmount, true)}</span>
					</div>
				[/#if]
				[#if order.amountPayable > 0]
					<div class="list-group-item">
						${message("Order.amountPayable")}
						<span class="pull-right red">${currency(order.amountPayable, true)}</span>
					</div>
				[/#if]
				[#if order.rewardPoint > 0]
					<div class="list-group-item">
						${message("Order.rewardPoint")}
						<span class="pull-right">${order.rewardPoint}</span>
					</div>
				[/#if]
				[#if order.exchangePoint > 0]
					<div class="list-group-item">
						${message("Order.exchangePoint")}
						<span class="pull-right red">${order.exchangePoint}</span>
					</div>
				[/#if]
				[#if order.couponCode??]
					<div class="list-group-item">
						${message("member.order.coupon")}
						<span class="pull-right">${order.couponCode.coupon.name}</span>
					</div>
				[/#if]
				[#if order.promotionNames?has_content]
					<div class="list-group-item">
						${message("member.order.promotion")}
						<span class="pull-right">${order.promotionNames?join(", ")}</span>
					</div>
				[/#if]
				[#if order.memo?has_content]
					<div class="list-group-item">
						${message("Order.memo")}
						<span class="pull-right">${order.memo}</span>
					</div>
				[/#if]
			</div>
		</div>
	</main>
	[#if (order.paymentMethod?? && order.amountPayable > 0) || (!order.hasExpired() && (order.status == "pendingPayment" || order.status == "pendingReview")) || (!order.hasExpired() && order.status == "shipped")]
		<footer class="footer-fixed text-right">
			[#if order.paymentMethod?? && order.amountPayable > 0]
				<a id="payment" class="btn btn-sm btn-default" href="javascript:;">${message("member.order.payment")}</a>
			[/#if]
			[#if !order.hasExpired() && (order.status == "pendingPayment" || order.status == "pendingReview")]
				<a id="cancel" class="btn btn-sm btn-default" href="javascript:;">${message("member.order.cancel")}</a>
			[/#if]
			[#if !order.hasExpired() && order.status == "shipped"]
				<a id="receive" class="btn btn-sm btn-default" href="javascript:;">${message("member.order.receive")}</a>
			[/#if]
		</footer>
	[/#if]
</body>
</html>