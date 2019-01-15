<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html;charset=utf-8" />
<title>${message("admin.plugin.alipayEscowPayment.setting")} </title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/webuploader.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/input.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $inputForm = $("#inputForm");
	var $filePicker = $("#filePicker");
	
	[@flash_message /]
	
	$filePicker.uploader();
	
	// 表单验证
	$inputForm.validate({
		errorClass: "fieldError",
		ignoreTitle: true,
		rules: {
			paymentName: "required",
			partner: "required",
			key: "required",
			fee: {
				required: true,
				min: 0,
				decimal: {
					integer: 12,
					fraction: ${setting.priceScale}
				}
			},
			logo: {
				pattern: /^(http:\/\/|https:\/\/|\/).*$/i
			},
			order: "digits"
		}
	});
	
});
</script>
</head>
<body>
	<div class="breadcrumb">
		${message("admin.plugin.alipayEscowPayment.setting")}
	</div>
	<form id="inputForm" action="update" method="post">
		<table class="input">
			<tr>
				<th>
					<span class="requiredField">*</span>${message("PaymentPlugin.paymentName")}:
				</th>
				<td>
					<input type="text" name="paymentName" class="text" value="${pluginConfig.getAttribute("paymentName")}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("admin.plugin.alipayEscowPayment.partner")}:
				</th>
				<td>
					<input type="text" name="partner" class="text" value="${pluginConfig.getAttribute("partner")}" maxlength="200" />
					<a href="http://bizpartner.alipay.com/shopxx/" target="_blank">[${message("admin.plugin.alipayEscowPayment.register")}]</a>
					<a href="https://b.alipay.com/order/pidKey.htm?pid=2088302375676665&product=escrow" target="_blank">[${message("admin.plugin.alipayEscowPayment.query")}]</a>
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("admin.plugin.alipayEscowPayment.key")}:
				</th>
				<td>
					<input type="text" name="key" class="text" value="${pluginConfig.getAttribute("key")}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					${message("PaymentPlugin.feeType")}:
				</th>
				<td>
					<select name="feeType">
						[#list feeTypes as feeType]
							<option value="${feeType}"[#if feeType == pluginConfig.getAttribute("feeType")] selected="selected"[/#if]>${message("PaymentPlugin.FeeType." + feeType)}</option>
						[/#list]
					</select>
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("PaymentPlugin.fee")}:
				</th>
				<td>
					<input type="text" name="fee" class="text" value="${pluginConfig.getAttribute("fee")}" maxlength="16" />
				</td>
			</tr>
			<tr>
				<th>
					${message("PaymentPlugin.logo")}:
				</th>
				<td>
					<span class="fieldSet">
						<input type="text" name="logo" class="text" value="${pluginConfig.getAttribute("logo")}" maxlength="200" />
						<a href="javascript:;" id="filePicker" class="button">${message("admin.upload.filePicker")}</a>
						[#if pluginConfig.getAttribute("logo")?has_content]
							<a href="${pluginConfig.getAttribute("logo")}" target="_blank">${message("admin.common.view")}</a>
						[/#if]
					</span>
				</td>
			</tr>
			<tr>
				<th>
					${message("PaymentPlugin.description")}:
				</th>
				<td>
					<textarea name="description" class="text">${pluginConfig.getAttribute("description")}</textarea>
				</td>
			</tr>
			<tr>
				<th>
					${message("admin.common.order")}:
				</th>
				<td>
					<input type="text" name="order" class="text" value="${pluginConfig.order}" maxlength="9" />
				</td>
			</tr>
			<tr>
				<th>
					${message("PaymentPlugin.isEnabled")}:
				</th>
				<td>
					<label>
						<input type="checkbox" name="isEnabled" value="true"[#if pluginConfig.isEnabled] checked[/#if] />
					</label>
				</td>
			</tr>
			<tr>
				<th>
					&nbsp;
				</th>
				<td>
					<input type="submit" class="button" value="${message("admin.common.submit")}" />
					<input type="button" class="button" value="${message("admin.common.back")}" onclick="location.href='../list'" />
				</td>
			</tr>
		</table>
	</form>
</body>
</html>