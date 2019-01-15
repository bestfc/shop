<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("admin.messageConfig.edit")} </title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/input.js"></script>
<script type="text/javascript">
$().ready(function() {

	[@flash_message /]
	
});
</script>
</head>
<body>
	<div class="breadcrumb">
		<a href="${base}/admin/index">${message("admin.breadcrumb.home")}</a> &raquo; ${message("admin.messageConfig.edit")}
	</div>
	<form id="inputForm" action="update" method="post">
		<input type="hidden" name="id" value="${messageConfig.id}" />
		<table class="input">
			<tr>
				<th>
					${message("MessageConfig.type")}:
				</th>
				<td>
					${message("MessageConfig.Type." + messageConfig.type)}
				</td>
			</tr>
			<tr>
				<th>
					${message("MessageConfig.isMailEnabled")}:
				</th>
				<td>
					<label>
						<input type="checkbox" name="isMailEnabled" value="true"[#if messageConfig.isMailEnabled] checked="checked"[/#if] />
						<input type="hidden" name="_isMailEnabled" value="false" />
					</label>
				</td>
			</tr>
			<tr>
				<th>
					${message("MessageConfig.isSmsEnabled")}:
				</th>
				<td>
					<label>
						<input type="checkbox" name="isSmsEnabled" value="true"[#if messageConfig.isSmsEnabled] checked="checked"[/#if] />
						<input type="hidden" name="_isSmsEnabled" value="false" />
					</label>
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