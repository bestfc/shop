<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("business.store.payment")} </title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/business/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/business/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/business/css/animate.css" rel="stylesheet">
	<link href="${base}/resources/business/css/adminLTE.css" rel="stylesheet">
	<link href="${base}/resources/business/css/common.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/business/js/html5shiv.js"></script>
		<script src="${base}/resources/business/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/business/js/jquery.js"></script>
	<script src="${base}/resources/business/js/bootstrap.js"></script>
	<script src="${base}/resources/business/js/jquery.spinner.js"></script>
	<script src="${base}/resources/business/js/velocity.js"></script>
	<script src="${base}/resources/business/js/velocity.ui.js"></script>
	<script src="${base}/resources/business/js/moment.js"></script>
	<script src="${base}/resources/business/js/jquery.validate.js"></script>
	<script src="${base}/resources/business/js/underscore.js"></script>
	<script src="${base}/resources/business/js/adminLTE.js"></script>
	<script src="${base}/resources/business/js/common.js"></script>
	<script type="text/javascript">
	$().ready(function() {
		
		var $paymentModal = $("#paymentModal");
		var $mainHeaderNav = $("header.main-header a:not(.logout)");
		var $mainSidebarNav = $("aside.main-sidebar a, aside.main-sidebar button");
		var $storeForm = $("#storeForm");
		var $paymentPluginId = $("#paymentPluginId");
		var $spinner = $("#spinner");
		var $years = $("#years");
		var $feeItem = $("#feeItem");
		var $fee = $("#fee");
		var $amount = $("#amount");
		var $paymentPlugin = $("#paymentPlugin");
		var $paymentPluginItem = $("#paymentPlugin div.media");
		var currentEndDate = ${currentStore.endDate?long};
		
		[#if currentStore.status == "approved" || currentStore.hasExpired()]
			// 主顶部导航
			$mainHeaderNav.click(function() {
				return false;
			});
			
			// 主侧边导航
			$mainSidebarNav.click(function() {
				return false;
			});
		[/#if]
		
		[#if currentStore.status == "approved"]
			// 检查店铺状态
			setInterval(function() {
				$.ajax({
					url: "${base}/business/store/store_status",
					type: "GET",
					dataType: "json",
					success: function(data) {
						if (data.status != "approved") {
							location.href = "/shop/business/index";
						}
					}
				});
			}, 10000);
		[#else]
			// 检查店铺日期
			setInterval(function() {
				$.ajax({
					url: "${base}/business/store/end_date",
					type: "GET",
					dataType: "json",
					success: function(data) {
						if (moment(data.endDate).isAfter(currentEndDate)) {
							location.href = "/shop/business/index";
						}
					}
				});
			}, 10000);
		[/#if]
		
		// 购买时长
		$spinner.spinner({
			[#if !currentStore.hasExpired() && currentStore.bailPayable > 0]
				min: 0,
			[#else]
				min: 1,
			[/#if]
			max: 99
		}).spinner("changing", function(e, newValue, oldValue) {
			calculate();
		});
		
		// 支付插件
		$paymentPluginItem.click(function() {
			var $element = $(this);
			$element.addClass("active").siblings().removeClass("active");
			var paymentPluginId = $element.data("payment-plugin-id");
			$paymentPluginId.val(paymentPluginId);
			calculate();
		});
		
		// 计算
		var calculate = _.debounce(function() {
			if (!$storeForm.valid()) {
				return;
			}
			$.ajax({
				url: "${base}/business/store/calculate",
				type: "GET",
				data: {
					paymentPluginId: $paymentPluginId.val(),
					years: $years.val()
				},
				dataType: "json",
				success: function(data) {
					$amount.text(currency(data.amount, true));
					if (data.fee > 0) {
						$fee.text(currency(data.fee, true));
						if ($feeItem.is(":hidden")) {
							$feeItem.velocity("slideDown");
						}
					} else {
						if ($feeItem.is(":visible")) {
							$feeItem.velocity("slideUp");
						}
					}
					if (data.amount > 0) {
						if ($paymentPlugin.is(":hidden")) {
							$paymentPlugin.velocity("slideDown");
						}
					} else {
						if ($paymentPlugin.is(":visible")) {
							$paymentPlugin.velocity("slideUp");
						}
					}
				}
			});
		}, 200);
		
		calculate();
		
		// 表单验证
		$storeForm.validate({
			rules: {
				years: {
					required: true,
					[#if !currentStore.hasExpired() && currentStore.bailPayable > 0]
						min: 0,
					[#else]
						min: 1,
					[/#if]
					max: 99
				}
			},
			submitHandler: function(form) {
				$.ajax({
					url: "${base}/business/store/payment",
					type: "POST",
					data: {
						years: $years.val()
					},
					dataType: "json",
					async: false,
					success: function(data) {
						if (data.platformSvcSn != null || (data.bail != null && data.bail > 0)) {
							$paymentModal.modal({
								backdrop: "static",
								keyboard: false
							}).modal("show");
							
							var i = 0;
							if (data.platformSvcSn != null) {
								$('<input name="paymentItemList[' + i + '].type" type="hidden">').appendTo($storeForm).val("SVC_PAYMENT");
								$('<input name="paymentItemList[' + i + '].svcSn" type="hidden">').appendTo($storeForm).val(data.platformSvcSn);
								i++;
							}
							if (data.bail != null && data.bail > 0) {
								$('<input name="paymentItemList[' + i + '].type" type="hidden">').appendTo($storeForm).val("BAIL_PAYMENT");
								$('<input name="paymentItemList[' + i + '].amount" type="hidden">').appendTo($storeForm).val(data.bail);
							}
							form.submit();
						} else {
							location.reload(true);
						}
					}
				});
			}
		});
		
	});
	</script>
</head>
<body class="hold-transition sidebar-mini">
	<div id="paymentModal" class="modal fade" tabindex="-1">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title">${message("business.paymentModal.title")}</h4>
				</div>
				<div class="modal-body text-center">
					[#noautoesc]
						${message("business.paymentModal.content")}
					[/#noautoesc]
				</div>
				<div class="modal-footer">
					<a class="btn btn-primary" href="/shop/business/index">${message("business.paymentModal.paid")}</a>
					<a class="btn btn-default" href="${base}/">${message("business.paymentModal.trouble")}</a>
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
					<h1>${message("business.store.payment")}</h1>
					<ol class="breadcrumb">
						<li>
							<a href="/shop/business/index">
								<i class="fa fa-home"></i>
								${message("business.common.index")}
							</a>
						</li>
						<li class="active">${message("business.store.payment")}</li>
					</ol>
				</section>
				<section class="content">
					<div class="row">
						<div class="col-xs-12">
							<form id="storeForm" class="form-horizontal" action="${base}/payment" method="post" target="_blank">
								<input id="paymentPluginId" name="paymentPluginId" type="hidden" value="${defaultPaymentPlugin.id}">
								<div class="box">
									<div class="box-body">
										<div class="row">
											<div class="col-xs-6">
												<dl class="items dl-horizontal clearfix">
													<dt>${message("Store.name")}:</dt>
													<dd>${currentStore.name}</dd>
													<dt>${message("Store.storeRank")}:</dt>
													<dd>${currentStore.storeRank.name}</dd>
													[#if currentStore.status == "success"]
														<dt>${message("Store.endDate")}:</dt>
														<dd>
															<span class="text-orange">${currentStore.endDate}</span>
															[#if currentStore.hasExpired()]
																<span class="text-red">(${message("business.store.hasExpired")})</span>
															[/#if]
														</dd>
													[/#if]
													<dt>${message("StoreRank.serviceFee")}:</dt>
													<dd>${message("business.store.serviceFee", currency(currentStore.storeRank.serviceFee, true))}</dd>
													[#if currentStore.status == "approved"]
														<dt>${message("StoreCategory.bail")}:</dt>
														<dd>${currency(currentStore.bailPayable, true)}</dd>
													[/#if]
												</dl>
											</div>
										</div>
										<div class="form-group">
											<label class="col-xs-2 control-label" for="years">${message("business.store.years")}:</label>
											<div class="col-xs-2">
												<div class="input-group">
													<div id="spinner" class="spinner input-group">
														<div class="input-group-addon" data-spin="down">-</div>
														<input id="years" name="years" class="form-control" type="text" value="1" maxlength="4" title="${message("business.store.yearsTitle")}">
														<div class="input-group-addon" data-spin="up">+</div>
													</div>
												</div>
											</div>
										</div>
										<div id="feeItem" class="hidden-element form-group">
											<label class="col-xs-2 control-label">${message("business.store.fee")}:</label>
											<div class="col-xs-4">
												<p id="fee" class="form-control-static text-red"></p>
											</div>
										</div>
										<div class="form-group">
											<label class="col-xs-2 control-label">${message("business.store.amount")}:</label>
											<div class="col-xs-4">
												<p id="amount" class="form-control-static text-red"></p>
											</div>
										</div>
										[#if paymentPlugins?has_content]
											<div id="paymentPlugin" class="hidden-element payment-plugin panel panel-default">
												<div class="panel-heading">${message("business.store.paymentPlugin")}</div>
												<div class="panel-body">
													[#list paymentPlugins as paymentPlugin]
														<div class="media[#if paymentPlugin == defaultPaymentPlugin] active[/#if]" data-payment-plugin-id="${paymentPlugin.id}">
															<div class="media-left media-middle">
																<span class="glyphicon glyphicon-ok-circle"></span>
															</div>
															<div class="media-body media-middle">
																<div class="media-object">
																	[#if paymentPlugin.logo?has_content]
																		<img src="${paymentPlugin.logo}" alt="${paymentPlugin.paymentName}">
																	[#else]
																		${paymentPlugin.paymentName}
																	[/#if]
																</div>
															</div>
														</div>
													[/#list]
												</div>
											</div>
										[/#if]
									</div>
									<div class="box-footer">
										<div class="row">
											<div class="col-xs-4 col-xs-offset-2">
												[#if currentStore.endDate?? || currentStore.status != "success"]
													<button class="btn btn-primary" type="submit">${message("business.common.submit")}</button>
												[/#if]
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