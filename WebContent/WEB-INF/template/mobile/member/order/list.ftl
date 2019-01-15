<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.order.list")}[#if showPowered] [/#if]</title>
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
	<script id="orderTemplate" type="text/template">
		<%
			function statusText(status) {
				switch(status) {
					case "pendingPayment":
						return "${message("Order.Status.pendingPayment")}";
					case "pendingReview":
						return "${message("Order.Status.pendingReview")}";
					case "pendingShipment":
						return "${message("Order.Status.pendingShipment")}";
					case "shipped":
						return "${message("Order.Status.shipped")}";
					case "received":
						return "${message("Order.Status.received")}";
					case "completed":
						return "${message("Order.Status.completed")}";
					case "failed":
						return "${message("Order.Status.failed")}";
					case "canceled":
						return "${message("Order.Status.canceled")}";
					case "denied":
						return "${message("Order.Status.denied")}";
				}
			}
			
			function productType(type) {
				switch(type) {
					case "exchange":
						return "${message("Product.Type.exchange")}";
					case "gift":
						return "${message("Product.Type.gift")}";
				}
			}
		%>
		<%_.each(orders, function(order, i) {%>
			<div class="panel panel-flat">
				<div class="panel-heading">
					<span class="small">${message("OrderItem.sn")}: <%-order.sn%></span>
					<%if (order.hasExpired) {%>
						<em class="pull-right gray-darker">${message("member.order.hasExpired")}</em>
					<%} else {%>
						<em class="pull-right orange">
							<%-statusText(order.status)%>
						</em>
					<%}%>
				</div>
				<div class="panel-body">
					<div class="list-group list-group-flat">
						<%_.each(order.orderItems, function(orderItem, i) {%>
							<div class="list-group-item">
								<div class="media">
									<div class="media-left media-middle">
										<a href="view?orderSn=<%-order.sn%>">
											<img src="<%-orderItem.thumbnail != null ? orderItem.thumbnail : "${setting.defaultThumbnailProductImage}"%>" alt="<%-orderItem.name%>">
										</a>
									</div>
									<div class="media-body media-middle">
										<h4 class="media-heading">
											<a href="view?orderSn=<%-order.sn%>"><%-orderItem.name%></a>
										</h4>
										<%if (orderItem.specifications.length > 0) {%>
											<span class="small gray-darker"><%-orderItem.specifications.join(", ")%></span>
										<%}%>
										<%if (order.type != "general") {%>
											<strong class="small red">[<%-productType(order.type)%>]</strong>
										<%}%>
									</div>
								</div>
							</div>
						<%})%>
					</div>
				</div>
				<div class="panel-footer text-right">
					[#if isKuaidi100Enabled]
						<%var orderShipping = !_.isEmpty(order.orderShippings) ? order.orderShippings[0] : null;%>
						<%if (orderShipping != null && orderShipping.deliveryCorp != null && orderShipping.trackingNo != null) {%>
							<button class="transit-step btn btn-sm btn-default" type="button" data-order-shipping-sn="<%-orderShipping.sn%>">${message("member.order.transitStep")}</button>
						<%}%>
					[/#if]
					<a class="btn btn-sm btn-default" href="view?orderSn=<%-order.sn%>">${message("member.order.view")}</a>
				</div>
			</div>
		<%})%>
	</script>
	<script id="transitStepTemplate" type="text/template">
		<%if (_.isEmpty(data.transitSteps)) {%>
			<p class="gray-darker">${message("member.common.noResult")}</p>
		<%} else {%>
			<div class="list-group list-group-flat">
				<%_.each(data.transitSteps, function(transitStep, i) {%>
					<div class="list-group-item">
						<p class="small gray-darker"><%-transitStep.time%></p>
						<p class="small"><%-transitStep.context%></p>
					</div>
				<%})%>
			</div>
		<%}%>
	</script>
	<script type="text/javascript">
	$().ready(function() {
		
		var $transitStepModal = $("#transitStepModal");
		var $transitStepModalBody = $("#transitStepModal div.modal-body");
		var $orderItems = $("#orderItems");
		var orderTemplate = _.template($("#orderTemplate").html());
		var transitStepTemplate = _.template($("#transitStepTemplate").html());
		
		// 无限滚动加载
		$orderItems.infiniteScroll({
			url: function(pageNumber) {
				return "${base}/member/order/list?pageNumber=" + pageNumber + "&status=${status}" + "&hasExpired=${(hasExpired?string("true", "false"))!}";
			},
			pageSize: 10,
			template: function(pageNumber, data) {
				return orderTemplate({
					orders: data
				});
			}
		});
		
		// 物流动态
		$orderItems.on("click", "button.transit-step", function() {
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
		<a class="pull-left" href="${base}/member/index">
			<span class="glyphicon glyphicon-menu-left"></span>
		</a>
		${message("member.order.list")}
	</header>
	<main>
		<div class="container-fluid">
			<div id="orderItems"></div>
		</div>
	</main>
</body>
</html>