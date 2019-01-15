<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html;charset=utf-8" />
<title>${message("admin.plugin.alipayLogin.setting")} </title>
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
			loginMethodName: "required",
			partner: "required",
			key: "required",
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
		${message("admin.plugin.kdniaoExpress.setting")}
	</div>
	<form id="inputForm" action="update" method="post">
		<table class="input">
			<tr>
				<th>
					<span class="requiredField">*</span>${message("ExpressPlugin.ExpressApiName")}:
				</th>
				<td>
					<input type="text" name="expressapiName" class="text" value="${pluginConfig.getAttribute("expressapiName")}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("admin.plugin.kdniaoExpress.AppKey")}:
				</th>
				<td>
					<input type="text" name="AppKey" class="text" value="${pluginConfig.getAttribute("AppKey")}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("admin.plugin.kdniaoExpress.EBusinessID")}:
				</th>
				<td>
					<input type="text" name="EBusinessID" class="text" value="${pluginConfig.getAttribute("EBusinessID")}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					${message("ExpressPlugin.description")}:
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
					${message("ExpressPlugin.isEnabled")}:
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