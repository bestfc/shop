<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("member.order.view")}[#if showPowered]Powered By  [/#if]</title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/member/css/animate.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/member/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/member/css/member.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/member/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/member/js/jquery.lSelect.js"></script>
<script type="text/javascript" src="${base}/resources/member/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/member/js/common.js"></script>
<script type="text/javascript">
$().ready(function() {
	var $submit = $("#btn_submit");
	var $orderRefundsForm = $("#orderRefundsForm");
	
	<!--[#if flashMessage?has_content]
		$.alert("${flashMessage}");
	[/#if] -->

	// 表单验证
	$orderRefundsForm.validate({
		rules: {
			type: {
				required: true
			},
			reason: {
				required: true
			}
		},
		submitHandler: function(form) {
			$.ajax({
				url: "refunds-apply",
				type: "POST",
				data: $orderRefundsForm.serialize(),
				dataType: "json",
				cache: false,
				beforeSend: function() {
					$submit.prop("disabled", true);
				},
				success: function(data) {
					location.href="view?orderSn=${orderItem.order.sn}";
				},
				complete: function() {
					$submit.prop("disabled", false);
				}
			});
		}
	});
});
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
					<div class="title">申请退款</div>	
					
					<form id="orderRefundsForm" action="update" method="post">
						<table class="input">
							<tr>
								<th>
									${message("Order.sn")}:
								</th>
								<td>
									${orderItem.sn}
									<input type="hidden" name="sn"  value="${orderItem.sn}"></input>
								</td>
							</tr>
							<tr>
								<th>
								
								</th>
								<td>
									<label> 退款退货 <input type="radio"  name="type" value="refundsReturns"/></label>
                                    <label> 仅退款<input type="radio" name="type"  value="onlyRefunds"/></label>
								</td>
							</tr>
							<tr>
								<th>
									<span class="requiredField">*</span>退款原因:
								</th>
								<td>
									<select name="reason" class="text">
										<option>七天无理由退换货</option>
										<option>外观/型号/参数等与描述不符</option>
										<option>质量问题</option>
										<option>少件/漏发</option>
										<option>卖家发错货</option>
										<option>包装/商品破损/污渍</option>
										<option>其它</option>
									</select>
								</td>
							</tr>
							<tr>
								<th>
									退款说明:
								</th>
								<td>
									<input type="text" name="content" class="text" value="" maxlength="200" />
								</td>
							</tr>

							<tr>
								<th>
									&nbsp;
								</th>
								<td>
									<input id="btn_submit" type="submit" class="button" value="${message("member.common.submit")}" />
									<a href="view?orderSn=${orderItem.order.sn}" class="backButton button">${message("member.common.back")}</a>
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