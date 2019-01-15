<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html;charset=utf-8" />
<title>${message("admin.plugin.weixinLogin.setting")} </title>
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
			appId: "required",
			appSecret: "required",
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
		${message("admin.plugin.weixinLogin.setting")}
	</div>
	<form id="inputForm" action="update" method="post">
		<table class="input">
			<tr>
				<th>
					<span class="requiredField">*</span>${message("LoginPlugin.loginMethodName")}:
				</th>
				<td>
					<input type="text" name="loginMethodName" class="text" value="${pluginConfig.getAttribute("loginMethodName")}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("admin.plugin.weixinLogin.appId")}:
				</th>
				<td>
					<input type="text" name="appId" class="text" value="${pluginConfig.getAttribute("appId")}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("admin.plugin.weixinLogin.appSecret")}:
				</th>
				<td>
					<input type="text" name="appSecret" class="text" value="${pluginConfig.getAttribute("appSecret")}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					${message("LoginPlugin.logo")}:
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
					${message("LoginPlugin.description")}:
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
					${message("LoginPlugin.isEnabled")}:
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