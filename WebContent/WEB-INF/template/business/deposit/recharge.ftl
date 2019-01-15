<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("business.businessDeposit.recharge")} </title>
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
	<script src="${base}/resources/business/js/velocity.js"></script>
	<script src="${base}/resources/business/js/velocity.ui.js"></script>
	<script src="${base}/resources/business/js/jquery.validate.js"></script>
	<script src="${base}/resources/business/js/underscore.js"></script>
	<script src="${base}/resources/business/js/adminLTE.js"></script>
	<script src="${base}/resources/business/js/common.js"></script>
	<script type="text/javascript">
		$().ready(function() {
			
			var $paymentModal = $("#paymentModal");
			var $depositForm = $("#depositForm");
			var $paymentPluginId = $("#paymentPluginId");
			var $rechargeAmount = $("#rechargeAmount");
			var $feeItem = $("#feeItem");
			var $fee = $("#fee");
			var $paymentPlugin = $("#paymentPlugin");
			var $paymentPluginItem = $("#paymentPlugin div.media");
			
			[#if flashMessage?has_content]
				$.alert("${flashMessage}");
			[/#if]
			
			// 充值金额
			$rechargeAmount.on("input propertychange change", function(event) {
				if (event.type != "propertychange" || event.originalEvent.propertyName == "value") {
					calculate();
				}
			});
			
			// 支付插件
			$paymentPluginItem.click(function() {
				var $element = $(this);
				$element.addClass("active").siblings().removeClass("active");
				var paymentPluginId = $element.data("payment-plugin-id");
				$paymentPluginId.val(paymentPluginId);
				calculate();
			});
			
			// 计算支付手续费
			var calculate = _.debounce(function() {
				if (!$depositForm.valid()) {
					if ($feeItem.is(":visible")) {
						$feeItem.velocity("slideUp");
					}
					return;
				}
				$.ajax({
					url: "${base}/business/deposit/calculate",
					type: "GET",
					data: {
						paymentPluginId: $paymentPluginId.val(),
						rechargeAmount: $rechargeAmount.val()
					},
					dataType: "json",
					cache: false,
					success: function(data) {
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
					}
				});
			}, 200);
			
			// 检查余额
			setInterval(function() {
				$.ajax({
					url: "${base}/business/deposit/check_balance",
					type: "POST",
					dataType: "json",
					cache: false,
					success: function(data) {
						if (data.balance > ${currentUser.balance}) {
							location.href = "${base}/business/deposit/log";
						}
					}
				});
			}, 10000);
			
			// 表单验证
			$depositForm.validate({
				rules: {
					"paymentItemList[0].amount": {
						required: true,
						positive: true,
						decimal: {
							integer: 7,
							fraction: ${setting.priceScale}
						}
					}
				},
				submitHandler: function(form) {
					$paymentModal.modal({
						backdrop: "static",
						keyboard: false
					}).modal("show");
					
					form.submit();
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
					<a class="btn btn-primary" href="${base}/business/deposit/log">${message("business.paymentModal.paid")}</a>
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
					<h1>${message("business.businessDeposit.recharge")}</h1>
					<ol class="breadcrumb">
						<li>
							<a href="/shop/business/index">
								<i class="fa fa-home"></i>
								${message("business.common.index")}
							</a>
						</li>
						<li class="active">${message("business.businessDeposit.recharge")}</li>
					</ol>
				</section>
				<section class="content">
					<div class="row">
						<div class="col-xs-12">
							<form id="depositForm" class="form-horizontal" action="${base}/payment" method="post" target="_blank">
								<input id="paymentPluginId" name="paymentPluginId" type="hidden" value="${defaultPaymentPlugin.id}">
								<input name="paymentItemList[0].type" type="hidden" value="DEPOSIT_RECHARGE">
								<div class="box">
									<div class="box-body">
										<div class="form-group">
											<label class="col-xs-2 control-label">${message("business.businessDeposit.balance")}:</label>
											<div class="col-xs-2">
												<p class="form-control-static">${currency(currentUser.balance, true, true)}</p>
											</div>
										</div>
										<div class="form-group">
											<label class="col-xs-2 control-label item-required" for="rechargeAmount">${message("business.businessDeposit.amount")}:</label>
											<div class="col-xs-2">
												<input id="rechargeAmount" name="paymentItemList[0].amount" class="form-control" type="text" maxlength="16">
											</div>
										</div>
										<div id="feeItem" class="hidden-element form-group">
											<label class="col-xs-2 control-label">${message("business.businessDeposit.fee")}:</label>
											<div class="col-xs-2">
												<p id="fee" class="form-control-static text-red"></p>
											</div>
										</div>
										[#if paymentPlugins?has_content]
											<div id="paymentPlugin" class="payment-plugin panel panel-default">
												<div class="panel-heading">${message("business.businessDeposit.paymentPlugin")}</div>
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