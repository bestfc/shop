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
	var $orderReturnsForm = $("#orderReturnsForm");

	<!--[#if flashMessage?has_content]
		$.alert("${flashMessage}");
	[/#if] -->

	// 表单验证
	$orderReturnsForm.validate({
		rules: {
			deliveryCorpId: {
				required: true
			},
			trackingNo: {
				required: true
			}
		},
		submitHandler: function(form) {
			$.ajax({
				url: "returns-submit",
				type: "POST",
				data: $orderReturnsForm.serialize(),
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
					<div class="title">退货提交</div>	
	
					<form id="orderReturnsForm" action="update" method="post">
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
								${message("OrderReturns.deliveryCorp")}:
								</th>
								<td>
									<select name="deliveryCorpId" class="selectpicker text" data-size="5">
										<option value="">${message("business.common.choose")}</option>
										[#list deliveryCorps as deliveryCorp]
											[#noautoesc]
												<option value="${deliveryCorp.id}">${deliveryCorp.name?html?js_string}</option>
											[/#noautoesc]
										[/#list]
									</select>
								</td>
							</tr>
							<tr>
								<th>
									<span class="requiredField">*</span>${message("OrderReturns.trackingNo")}:
								</th>
								<td>
									<input id="trackingNo" name="trackingNo" class="text" type="text" maxlength="200"/>
								</td>
							</tr>
							<tr>
								<th>
									说明:
								</th>
								<td>
									<input type="text" name="memo" class="text"  maxlength="200" />
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