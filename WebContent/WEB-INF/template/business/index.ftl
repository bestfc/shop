<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("business.index.title")} </title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/business/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/business/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/business/css/animate.css" rel="stylesheet">
	<link href="${base}/resources/business/css/adminLTE.css" rel="stylesheet">
	<link href="${base}/resources/business/css/common.css" rel="stylesheet">
	<link href="${base}/resources/business/css/index.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/business/js/html5shiv.js"></script>
		<script src="${base}/resources/business/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/business/js/jquery.js"></script>
	<script src="${base}/resources/business/js/bootstrap.js"></script>
	<script src="${base}/resources/business/js/moment.js"></script>
	<script src="${base}/resources/business/js/g2.js"></script>
	<script src="${base}/resources/business/js/adminLTE.js"></script>
	<script src="${base}/resources/business/js/common.js"></script>
	<script type="text/javascript">
	$().ready(function() {
		
		var $modal = $("#modal");
		
		[#if !currentStore?? || !currentStore.isActive()]
			$modal.modal({
				backdrop: "static",
				keyboard: false
			}).modal("show");
		[/#if]
		
		// 订单完成数图表
		var completeOrderCountChart = new G2.Chart({
			id: "completeOrderCountChart",
			height: 200,
			forceFit: true,
			plotCfg: {
				margin: [20, 20, 30, 80]
			}
		});
		
		completeOrderCountChart.source([], {
			date: {
				type: "time",
				tickCount: 10,
				formatter: function(value) {
					return moment(value).format("YYYY-MM-DD");
				}
			},
			value: {
				alias: "${message("Statistic.Type.completeOrderCount")}"
			}
		});
		completeOrderCountChart.axis("date", {
			title: null,
			formatter: function(value) {
				return moment(value).format("MM-DD");
			}
		});
		completeOrderCountChart.axis("value", {
			title: null
		});
		completeOrderCountChart.line().position("date*value").color("#66baff");
		completeOrderCountChart.render();
		
		$.ajax({
			url: "${base}/business/order_statistic/data",
			type: "get",
			data: {
				type: "completeOrderCount"
			},
			dataType: "json",
			success: function(data) {
				completeOrderCountChart.changeData(data);
			}
		});
		
		// 订单完成金额图表
		var completeOrderAmountChart = new G2.Chart({
			id: "completeOrderAmountChart",
			height: 200,
			forceFit: true,
			plotCfg: {
				margin: [20, 20, 30, 80]
			}
		});
		
		completeOrderAmountChart.source([], {
			date: {
				type: "time",
				tickCount: 10,
				formatter: function(value) {
					return moment(value).format("YYYY-MM-DD");
				}
			},
			value: {
				alias: "${message("Statistic.Type.completeOrderAmount")}",
				formatter: function(value) {
					return currency(value, true);
				}
			}
		});
		completeOrderAmountChart.axis("date", {
			title: null,
			formatter: function(value) {
				return moment(value).format("MM-DD");
			}
		});
		completeOrderAmountChart.axis("value", {
			title: null
		});
		completeOrderAmountChart.line().position("date*value").color("#ffab66");
		completeOrderAmountChart.render();
		
		$.ajax({
			url: "${base}/business/order_statistic/data",
			type: "get",
			data: {
				type: "completeOrderAmount"
			},
			dataType: "json",
			success: function(data) {
				completeOrderAmountChart.changeData(data);
			}
		});
	
	});
	</script>
</head>
<body class="index hold-transition sidebar-mini">
	<div id="modal" class="modal fade" tabindex="-1">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title">${message("business.index.modalTitle")}</h4>
				</div>
				<div class="modal-body">
					[#if !currentStore??]
						${message("business.index.storeNotExists")}
					[#elseif currentStore.status == "pending"]
						${message("business.index.storePending")}
					[#elseif currentStore.status == "failed"]
						${message("business.index.storeFailed")}
					[#elseif currentStore.status == "approved"]
						${message("business.index.storeApproved")}
					[#elseif currentStore.hasExpired()]
						${message("business.index.storeHasExpired")}
					[#else]
						${message("business.index.storeClose")}
					[/#if]
				</div>
				<div class="modal-footer">
					[#if !currentStore??]
						<a class="btn btn-primary" href="${base}/business/store/register">${message("business.index.storeRegister")}</a>
					[#elseif currentStore.status == "pending"]
						<a class="btn btn-primary" href="${base}/">${message("business.common.index")}</a>
					[#elseif currentStore.status == "failed"]
						<a class="btn btn-primary" href="${base}/business/store/reapply">${message("business.index.storeReapply")}</a>
					[#elseif currentStore.status == "approved"]
						<a class="btn btn-primary" href="${base}/business/store/payment">${message("business.index.storePayment")}</a>
					[#elseif currentStore.hasExpired()]
						<a class="btn btn-primary" href="${base}/business/store/payment">${message("business.index.storeRenewal")}</a>
					[/#if]
					<a class="btn btn-default" href="${base}/business/logout">${message("business.index.logout")}</a>
				</div>
			</div>
		</div>
	</div>
	<div class="wrapper">
		[#include "/business/include/main_header.ftl" /]
		[#include "/business/include/main_sidebar.ftl" /]
		<div class="content-wrapper">
			<div class="container-fluid">
				<section class="content-header">
					<h1>${message("business.index.title")}</h1>
				</section>
				<section class="content">
					[#if currentStore?? && currentStore.status == "success"]
						<div class="store-info box">
							<div class="box-body">
								<div class="row">
									<div class="col-xs-2">
										<a class="logo" target="_blank" href="${base}${currentStore.path}">
											<img src="${currentStore.logo!setting.defaultStoreLogo}" alt="${currentStore.name}">
										</a>
									</div>
									<div class="col-xs-4">
										<p>${message("Store.name")}: ${abbreviate(currentStore.name, 10)}</p>
										<p>${message("Store.storeRank")}: ${currentStore.storeRank.name}</p>
									</div>
									<div class="col-xs-6">
										<p>
											${message("Business.balance")}:
											<span class="orange">${currency(currentUser.balance, true, true)}</span>
											[#if currentUser.frozenFund > 0]
												<span class="gray-darker">(${message("Business.frozenFund")}: ${currency(currentUser.frozenFund, true)})</span>
											[/#if]
										</p>
										<p>
											${message("Store.endDate")}:
											<span class="orange">${(currentStore.endDate)!message("business.index.infinite")}</span>
										</p>
									</div>
								</div>
							</div>
						</div>
					[/#if]
					<div class="row">
						<div class="col-xs-6">
							<div class="order-info box">
								<div class="box-header with-border">
									<h4>${message("business.index.orderInfo")}</h4>
								</div>
								<div class="box-body">
									<a href="${base}/business/order/list?status=pendingPayment">
										<div class="img-circle" style="background-color: #5ec4f7">
											<span class="fa fa-credit-card"></span>
										</div>
										<div class="pull-left">
											<p>${message("Order.Status.pendingPayment")}</p>
											[@order_count storeId = currentStore.id status = "pendingPayment" hasExpired = false]
												${message("business.index.count")}: ${count}
											[/@order_count]
										</div>
									</a>
									<a href="${base}/business/order/list?status=pendingReview">
										<div class="img-circle" style="background-color: #fa8144">
											<span class="fa fa-user-o"></span>
										</div>
										<div class="pull-left">
											<p>${message("Order.Status.pendingReview")}</p>
											[@order_count storeId = currentStore.id status = "pendingReview" hasExpired = false]
												${message("business.index.count")}: ${count}
											[/@order_count]
										</div>
									</a>
									<a href="${base}/business/order/list?status=pendingShipment">
										<div class="img-circle" style="background-color: #fbb040">
											<span class="fa fa-truck"></span>
										</div>
										<div class="pull-left">
											<p>${message("Order.Status.pendingShipment")}</p>
											[@order_count storeId = currentStore.id status = "pendingShipment"]
												${message("business.index.count")}: ${count}
											[/@order_count]
										</div>
									</a>
									<a href="${base}/business/order/list?isPendingRefunds=true">
										<div class="img-circle" style="background-color: #f2d549">
											<span class="fa fa-rmb"></span>
										</div>
										<div class="pull-left">
											<p>${message("business.index.pendingRefunds")}</p>
											[@order_count storeId = currentStore.id isPendingRefunds = true]
												${message("business.index.count")}: ${count}
											[/@order_count]
										</div>
									</a>
									<a href="${base}/business/order/list?status=received">
										<div class="img-circle" style="background-color: #72ce52">
											<span class="fa fa-check-square-o"></span>
										</div>
										<div class="pull-left">
											<p>${message("Order.Status.received")}</p>
											[@order_count storeId = currentStore.id status = "received"]
												${message("business.index.count")}: ${count}
											[/@order_count]
										</div>
									</a>
								</div>
							</div>
						</div>
						<div class="col-xs-6">
							<div class="product-info box">
								<div class="box-header with-border">
									<h4>${message("business.index.productInfo")}</h4>
								</div>
								<div class="box-body">
									<a class="btn btn-default" href="${base}/business/product/list?isMarketable=true">
										${message("business.index.marketable")}
										[@product_count storeId = currentStore.id isMarketable = true]
											<span class="badge">${count}</span>
										[/@product_count]
									</a>
									<a class="btn btn-default" href="${base}/business/product/list?isOutOfStock=true">
										${message("business.index.outOfStack")}
										[@product_count storeId = currentStore.id isOutOfStock = true]
											<span class="badge">${count}</span>
										[/@product_count]
									</a>
									<a class="btn btn-default" href="${base}/business/product/list?isActive=false">
										${message("business.index.inactive")}
										[@product_count storeId = currentStore.id isActive = false]
											<span class="badge">${count}</span>
										[/@product_count]
									</a>
									<a class="btn btn-default" href="${base}/business/product/list?isTop=true">
										${message("business.index.top")}
										[@product_count storeId = currentStore.id isTop = true]
											<span class="badge">${count}</span>
										[/@product_count]
									</a>
									<a class="btn btn-default" href="${base}/business/product/list?isStockAlert=true">
										${message("business.index.stockAlert")}
										[@product_count storeId = currentStore.id isStockAlert = true]
											<span class="badge">${count}</span>
										[/@product_count]
									</a>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-xs-6">
							<div class="box">
								<div class="box-header with-border">
									<h4>${message("business.index.completeOrderCountStatistic")}</h4>
								</div>
								<div class="box-body">
									<div id="completeOrderCountChart"></div>
								</div>
							</div>
						</div>
						<div class="col-xs-6">
							<div class="box">
								<div class="box-header with-border">
									<h4>${message("business.index.completeOrderAmountStatistic")}</h4>
								</div>
								<div class="box-body">
									<div id="completeOrderAmountChart"></div>
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