<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("business.fullReductionPromotion.buy")} </title>
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
	<script src="${base}/resources/business/js/icheck.js"></script>
	<script src="${base}/resources/business/js/moment.js"></script>
	<script src="${base}/resources/business/js/jquery.validate.js"></script>
	<script src="${base}/resources/business/js/underscore.js"></script>
	<script src="${base}/resources/business/js/adminLTE.js"></script>
	<script src="${base}/resources/business/js/common.js"></script>
	<script type="text/javascript">
	$().ready(function() {
		
		[#if currentStore.endDate??]
			var $paymentModal = $("#paymentModal");
			var $fullReductionPromotionForm = $("#fullReductionPromotionForm");
			var $paymentPluginId = $("#paymentPluginId");
			var $svcSn = $("#svcSn");
			var $spinner = $("#spinner");
			var $months = $("#months");
			var $amount = $("#amount");
			var $feeItem = $("#feeItem");
			var $fee = $("#fee");
			var $useBalance = $("#useBalance");
			var $paymentPlugin = $("#paymentPlugin");
			var $paymentPluginItem = $("#paymentPlugin div.media");
			var currentEndDate = ${(currentStore.fullReductionPromotionEndDate?long)!0};
			
			// 购买时长
			$spinner.spinner({
				min: 1
			}).spinner("changing", function(e, newValue, oldValue) {
				calculate();
			});
			
			// 使用余额
			$useBalance.iCheck({
				checkboxClass: "icheckbox-flat-blue",
				radioClass: "iradio-flat-blue"
			}).on("ifChanged", function() {
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
				if (!$fullReductionPromotionForm.valid()) {
					return;
				}
				
				$.ajax({
					url: "${base}/business/full_reduction_promotion/calculate",
					type: "GET",
					data: {
						paymentPluginId: $paymentPluginId.val(),
						months: $months.val(),
						useBalance: $useBalance.prop("checked")
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
						if (data.amount > 0 && !data.useBalance) {
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
			
			// 检查到期日期
			setInterval(function() {
				$.ajax({
					url: "${base}/business/full_reduction_promotion/end_date",
					type: "GET",
					dataType: "json",
					success: function(data) {
						if (moment(data.endDate).isAfter(currentEndDate)) {
							alert("111");
							location.href = "${base}/business/full_reduction_promotion/list";
						}
					}
				});
			}, 10000);
			
			// 表单验证
			$fullReductionPromotionForm.validate({
				rules: {
					months: {
						required: true,
						min: 1
					}
				},
				submitHandler: function(form) {
					$.ajax({
						url: "${base}/business/full_reduction_promotion/buy",
						type: "POST",
						data: {
							months: $months.val(),
							useBalance: $useBalance.prop("checked")
						},
						dataType: "json",
						async: false,
						success: function(data) {
							if (data.promotionPluginSvcSn != null) {
								$paymentModal.modal({
									backdrop: "static",
									keyboard: false
								}).modal("show");
								
								$svcSn.val(data.promotionPluginSvcSn);
								form.submit();
							} else {
								location.href = "${base}/business/full_reduction_promotion/list";
							}
						}
					});
				}
			});
		[/#if]
	
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
					<a class="btn btn-primary" href="${base}/business/full_reduction_promotion/list">${message("business.paymentModal.paid")}</a>
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
					<h1>${message("business.fullReductionPromotion.buy")}</h1>
					<ol class="breadcrumb">
						<li>
							<a href="/shop/business/index">
								<i class="fa fa-home"></i>
								${message("business.common.index")}
							</a>
						</li>
						<li class="active">${message("business.fullReductionPromotion.buy")}</li>
					</ol>
				</section>
				<section class="content">
					<div class="row">
						<div class="col-xs-12">
							<form id="fullReductionPromotionForm" class="form-horizontal" action="${base}/payment" method="post" target="_blank">
								<input id="paymentPluginId" name="paymentPluginId" type="hidden" value="${defaultPaymentPlugin.id}">
								<input name="paymentItemList[0].type" type="hidden" value="SVC_PAYMENT">
								<input id="svcSn" name="paymentItemList[0].svcSn" type="hidden">
								<div class="box">
									<div class="box-body">
										[#if currentStore.endDate??]
											[#if currentStore.fullReductionPromotionEndDate??]
												<div class="form-group">
													<label class="col-xs-2 control-label">${message("Store.fullReductionPromotionEndDate")}:</label>
													<div class="col-xs-4">
														<p class="form-control-static text-orange">${currentStore.fullReductionPromotionEndDate}</p>
													</div>
												</div>
											[/#if]
											<div class="form-group">
												<label class="col-xs-2 control-label">${message("PromotionPlugin.price")}:</label>
												<div class="col-xs-4">
													<p class="form-control-static">${message("business.fullReductionPromotion.price", currency(promotionPlugin.price, true))}</p>
												</div>
											</div>
											<div class="form-group">
												<label class="col-xs-2 control-label" for="months">${message("business.fullReductionPromotion.months")}:</label>
												<div class="col-xs-4">
													<div id="spinner" class="spinner input-group">
														<div class="input-group-addon" data-spin="down">-</div>
														<input id="months" name="months" class="form-control" type="text" value="1" maxlength="4" title="${message("business.fullReductionPromotion.monthsTitle")}">
														<div class="input-group-addon" data-spin="up">+</div>
													</div>
												</div>
											</div>
											<div class="form-group">
												<label class="col-xs-2 control-label">${message("business.fullReductionPromotion.amount")}:</label>
												<div class="col-xs-4">
													<p id="amount" class="form-control-static"></p>
												</div>
											</div>
											[#if promotionPlugin.price > 0]
												<div id="feeItem" class="hidden-element form-group">
													<label class="col-xs-2 control-label">${message("business.fullReductionPromotion.fee")}:</label>
													<div class="col-xs-4">
														<p id="fee" class="form-control-static text-red"></p>
													</div>
												</div>
												[#if currentUser.balance > 0]
													<div class="form-group">
														<label class="col-xs-2 control-label">${message("business.fullReductionPromotion.useBalance")}:</label>
														<div class="col-xs-4 checkbox">
															<input id="useBalance" name="useBalance" type="checkbox" value="true">
														</div>
													</div>
												[/#if]
												[#if paymentPlugins?has_content]
													<div id="paymentPlugin" class="hidden-element payment-plugin panel panel-default">
														<div class="panel-heading">${message("business.fullReductionPromotion.paymentPlugin")}</div>
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
											[/#if]
										[#else]
											<span class="text-red">${message("business.fullReductionPromotion.noBuy")}</span>
										[/#if]
									</div>
									<div class="box-footer">
										<div class="row">
											<div class="col-xs-4 col-xs-offset-2">
												[#if currentStore.endDate??]
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