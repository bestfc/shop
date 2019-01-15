<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("member.memberDeposit.recharge")}[#if showPowered] [/#if]</title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/member/css/animate.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/member/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/member/css/member.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/member/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/member/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/member/js/common.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $inputForm = $("#inputForm");
	var $rechargeAmount = $("#rechargeAmount");
	var $paymentPluginId = $("#paymentPlugin input:radio");
	var $fee = $("#fee");
	var timeout;
	
	[#if flashMessage?has_content]
		$.alert("${flashMessage}");
	[/#if]
	
	// 充值金额
	$rechargeAmount.on("input propertychange change", function(event) {
		if (event.type != "propertychange" || event.originalEvent.propertyName == "value") {
			calculateFee();
		}
	});
	
	// 支付插件
	$paymentPluginId.click(function() {
		calculateFee();
	});
	
	// 计算支付手续费
	function calculateFee() {
		clearTimeout(timeout);
		timeout = setTimeout(function() {
			if ($inputForm.valid()) {
				var paymentPluginId = $paymentPluginId.filter(":checked").val();
				$.ajax({
					url: "calculate_fee",
					type: "POST",
					data: {paymentPluginId: paymentPluginId, rechargeAmount: $rechargeAmount.val()},
					dataType: "json",
					cache: false,
					success: function(data) {
						if (data.fee > 0) {
							$fee.text(currency(data.fee, true)).closest("tr").show();
						} else {
							$fee.closest("tr").hide();
						}
					}
				});
			} else {
				$fee.closest("tr").hide();
			}
		}, 500);
	}
	
	// 检查余额
	setInterval(function() {
		$.ajax({
			url: "check_balance",
			type: "POST",
			dataType: "json",
			cache: false,
			success: function(data) {
				if (data.balance > ${currentUser.balance}) {
					location.href = "log";
				}
			}
		});
	}, 10000);
	
	// 表单验证
	$inputForm.validate({
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
<body>
	[#assign current = "depositRecharge" /]
	[#include "/shop/include/header.ftl" /]
	<div class="container member">
		<div class="row">
			[#include "/member/include/navigation.ftl" /]
			<div class="span10">
				<div class="input deposit">
					<div class="title">${message("member.memberDeposit.recharge")}</div>
					<form id="inputForm" action="${base}/payment" method="post" target="_blank">
						<input type="hidden" name="paymentItemList[0].type" value="DEPOSIT_RECHARGE" />
						<table class="input">
							<tr>
								<th>
									${message("member.memberDeposit.balance")}:
								</th>
								<td>
									${currency(currentUser.balance, true, true)}
								</td>
							</tr>
							<tr>
								<th>
									<span class="requiredField">*</span>${message("member.memberDeposit.recharge")}:
								</th>
								<td>
									<input type="text" id="rechargeAmount" name="paymentItemList[0].amount" class="text" maxlength="16" onpaste="return false;" />
								</td>
							</tr>
							<tr>
								<th>
									${message("member.memberDeposit.paymentPlugin")}:
								</th>
								<td>
									<div id="paymentPlugin" class="paymentPlugin clearfix">
										[#if paymentPlugins??]
											[#list paymentPlugins as paymentPlugin]
												<div>
													<input type="radio" id="${paymentPlugin.id}" name="paymentPluginId" value="${paymentPlugin.id}"[#if paymentPlugin == defaultPaymentPlugin] checked="checked"[/#if] />
													<label for="${paymentPlugin.id}">
														[#if paymentPlugin.logo?has_content]
															<em title="${paymentPlugin.paymentName}" style="background-image: url(${paymentPlugin.logo});">&nbsp;</em>
														[#else]
															<em>${paymentPlugin.paymentName}</em>
														[/#if]
													</label>
												</div>
											[/#list]
										[/#if]
									</div>
								</td>
							</tr>
							<tr class="hidden">
								<th>
									${message("member.memberDeposit.fee")}:
								</th>
								<td>
									<span id="fee"></span>
								</td>
							</tr>
							<tr>
								<th>
									&nbsp;
								</th>
								<td>
									<input type="submit" class="button" value="${message("member.common.submit")}" />
									<input type="button" class="button" value="${message("member.common.back")}" onclick="history.back(); return false;" />
								</td>
							</tr>
						</table>
					</form>
				</div>
			</div>
		</div>
	</div>
	[#include "/shop/include/footer.ftl" /]
</body>
</html>