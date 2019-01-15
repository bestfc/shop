<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html;charset=utf-8" />
<title>${message("admin.plugin.ossStorage.setting")} </title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/input.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $inputForm = $("#inputForm");
	
	[@flash_message /]
	
	// 表单验证
	$inputForm.validate({
		errorClass: "fieldError",
		ignoreTitle: true,
		rules: {
			endpoint: "required",
			accessId: "required",
			accessKey: "required",
			bucketName: "required",
			urlPrefix: "required",
			order: "digits"
		}
	});
	
});
</script>
</head>
<body>
	<div class="breadcrumb">
		${message("admin.plugin.ossStorage.setting")}
	</div>
	<form id="inputForm" action="update" method="post">
		<table class="input">
			<tr>
				<th>
					<span class="requiredField">*</span>${message("admin.plugin.ossStorage.endpoint")}:
				</th>
				<td>
					<input type="text" name="endpoint" class="text" value="${pluginConfig.getAttribute("endpoint")}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("admin.plugin.ossStorage.accessId")}:
				</th>
				<td>
					<input type="text" name="accessId" class="text" value="${pluginConfig.getAttribute("accessId")}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("admin.plugin.ossStorage.accessKey")}:
				</th>
				<td>
					<input type="text" name="accessKey" class="text" value="${pluginConfig.getAttribute("accessKey")}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("admin.plugin.ossStorage.bucketName")}:
				</th>
				<td>
					<input type="text" name="bucketName" class="text" value="${pluginConfig.getAttribute("bucketName")}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("admin.plugin.ossStorage.urlPrefix")}:
				</th>
				<td>
					<input type="text" name="urlPrefix" class="text" value="${pluginConfig.getAttribute("urlPrefix")}" maxlength="200" />
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
					${message("StoragePlugin.isEnabled")}:
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