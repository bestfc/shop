<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.memberDeposit.recharge")}[#if showPowered] [/#if]</title>
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
	<script src="${base}/resources/mobile/member/js/velocity.js"></script>
	<script src="${base}/resources/mobile/member/js/velocity.ui.js"></script>
	<script src="${base}/resources/mobile/member/js/jquery.validate.js"></script>
	<script src="${base}/resources/mobile/member/js/underscore.js"></script>
	<script src="${base}/resources/mobile/member/js/common.js"></script>
	<script type="text/javascript">
		$().ready(function() {
			
			var $rechargeForm = $("#rechargeForm");
			var $paymentPluginId = $("#paymentPluginId");
			var $rechargeAmount = $("#rechargeAmount");
			var $feeItem = $("#feeItem");
			var $fee = $("#fee");
			var $paymentPluginItem = $("#paymentPlugin div.list-group-item");
			
			// 充值金额
			$rechargeAmount.on("input propertychange change", function(event) {
				if (event.type != "propertychange" || event.originalEvent.propertyName == "value") {
					calculateFee();
				}
			});
			
			// 支付插件
			$paymentPluginItem.click(function() {
				var $element = $(this);
				$element.addClass("active").siblings().removeClass("active");
				var paymentPluginId = $element.data("payment-plugin-id");
				$paymentPluginId.val(paymentPluginId);
				calculateFee();
			});
			
			// 计算支付手续费
			var calculateFee = _.debounce(function() {
				if ($rechargeForm.valid()) {
					$.ajax({
						url: "calculate_fee",
						type: "POST",
						data: {
							paymentPluginId: $paymentPluginId.val(),
							rechargeAmount: $rechargeAmount.val()
						},
						dataType: "json",
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
				}
			}, 200);
			
			// 检查余额
			setInterval(function() {
				$.ajax({
					url: "check_balance",
					type: "POST",
					dataType: "json",
					success: function(data) {
						if (data.balance > ${currentUser.balance}) {
							location.href = "log";
						}
					}
				});
			}, 10000);
			
			// 表单验证
			$rechargeForm.validate({
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
					form.submit();
				}
			});
		
		});
	</script>
</head>
<body class="profile">
	<header class="header-fixed">
		<a class="pull-left" href="${base}/member/index">
			<span class="glyphicon glyphicon-menu-left"></span>
		</a>
		${message("member.memberDeposit.recharge")}
	</header>
	<main>
		<div class="container-fluid">
			<form id="rechargeForm" action="${base}/payment" method="post">
				<input name="paymentItemList[0].type" type="hidden" value="DEPOSIT_RECHARGE">
				<input id="paymentPluginId" name="paymentPluginId" type="hidden" value="${defaultPaymentPlugin.id}">
				<div class="list-group list-group-flat">
					<div class="list-group-item">
						<div class="form-group">
							<label for="rechargeAmount">${message("member.memberDeposit.rechargeAmount")}</label>
							<input id="rechargeAmount" name="paymentItemList[0].amount" class="form-control" type="text" maxlength="16" onpaste="return false;">
						</div>
					</div>
					<div id="feeItem" class="fee-item list-group-item small">
						${message("member.memberDeposit.fee")}:
						<strong id="fee"></strong>
					</div>
					<div class="list-group-item small">${message("member.memberDeposit.balance")}: ${currency(currentUser.balance, true)}</div>
				</div>
				[#if paymentPlugins??]
					<div class="panel panel-flat">
						<div class="panel-heading">${message("member.memberDeposit.paymentPlugin")}</div>
						<div class="panel-body">
							<div id="paymentPlugin" class="list-group list-group-flat">
								[#list paymentPlugins as paymentPlugin]
									<div class="[#if paymentPlugin == defaultPaymentPlugin]active [/#if]list-group-item" data-payment-plugin-id="${paymentPlugin.id}">
										<div class="media">
											<div class="media-left media-middle">
												<div class="media-object">
													[#if paymentPlugin.logo?has_content]
														<img src="${paymentPlugin.logo}" alt="${paymentPlugin.paymentName}">
													[#else]
														${paymentPlugin.paymentName}
													[/#if]
												</div>
											</div>
											<div class="media-body media-middle">
												<span class="small">${abbreviate(paymentPlugin.description, 100, "...")}</span>
											</div>
											<div class="media-right media-middle">
												<span class="glyphicon glyphicon-ok-circle"></span>
											</div>
										</div>
									</div>
								[/#list]
							</div>
						</div>
						<div class="panel-footer text-center">
							<button class="btn btn-primary" type="submit">${message("member.common.submit")}</button>
							<a class="btn btn-default" href="${base}/member/index">${message("member.common.back")}</a>
						</div>
					</div>
				[/#if]
			</form>
		</div>
	</main>
</body>
</html>