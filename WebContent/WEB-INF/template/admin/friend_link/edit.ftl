<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("admin.friendLink.edit")} </title>
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
	var $type = $("#type");
	var $logo = $("#logo");
	var $filePicker = $("#filePicker");
	
	[@flash_message /]
	
	$filePicker.uploader();
	
	$type.change(function() {
		if ($(this).val() == "text") {
			$logo.prop("disabled", true).closest("tr").hide();
		} else {
			$logo.prop("disabled", false).closest("tr").show();
		}
	});
	
	// 表单验证
	$inputForm.validate({
		rules: {
			name: "required",
			logo: {
				required: true,
				pattern: /^(http:\/\/|https:\/\/|\/).*$/i
			},
			url: {
				required: true,
				pattern: /^(http:\/\/|https:\/\/|ftp:\/\/|mailto:|\/|#).*$/i
			},
			order: "digits"
		}
	});

});
</script>
</head>
<body>
	<div class="breadcrumb">
		<a href="${base}/admin/index">${message("admin.breadcrumb.home")}</a> &raquo; ${message("admin.friendLink.edit")}
	</div>
	<form id="inputForm" action="update" method="post">
		<input type="hidden" name="id" value="${friendLink.id}" />
		<table class="input">
			<tr>
				<th>
					<span class="requiredField">*</span>${message("FriendLink.name")}:
				</th>
				<td>
					<input type="text" name="name" class="text" value="${friendLink.name}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					${message("FriendLink.type")}:
				</th>
				<td>
					<select id="type" name="type">
						[#list types as type]
							<option value="${type}"[#if type == friendLink.type] selected="selected"[/#if]>${message("FriendLink.Type." + type)}</option>
						[/#list]
					</select>
				</td>
			</tr>
			<tr[#if friendLink.type == "text"] class="hidden"[/#if]>
				<th>
					${message("FriendLink.logo")}:
				</th>
				<td>
					<span class="fieldSet">
						<input type="text" id="logo" name="logo" class="text" value="${friendLink.logo}" maxlength="200"[#if friendLink.type == "text"] disabled="disabled"[/#if] />
						<a href="javascript:;" id="filePicker" class="button">${message("admin.upload.filePicker")}</a>
						[#if friendLink.type == "image"]
							<a href="${friendLink.logo}" target="_blank">${message("admin.common.view")}</a>
						[/#if]
					</span>
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("FriendLink.url")}:
				</th>
				<td>
					<input type="text" name="url" class="text" value="${friendLink.url}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					${message("admin.common.order")}:
				</th>
				<td>
					<input type="text" name="order" class="text" value="${friendLink.order}" maxlength="9" />
				</td>
			</tr>
			<tr>
				<th>
					&nbsp;
				</th>
				<td>
					<input type="submit" class="button" value="${message("admin.common.submit")}" />
					<input type="button" class="button" value="${message("admin.common.back")}" onclick="history.back(); return false;" />
				</td>
			</tr>
		</table>
	</form>
</body>
</html>