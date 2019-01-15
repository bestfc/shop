<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("admin.messageConfig.list")} </title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/list.js"></script>
<script type="text/javascript">
$().ready(function() {

	[@flash_message /]

});
</script>
</head>
<body>
	<div class="breadcrumb">
		<a href="${base}/admin/index">${message("admin.breadcrumb.home")}</a> &raquo; ${message("admin.messageConfig.list")}
	</div>
	<form id="listForm" action="list" method="get">
		<div class="bar">
			<div class="buttonGroup">
				<a href="javascript:;" id="refreshButton" class="iconButton">
					<span class="refreshIcon">&nbsp;</span>${message("admin.common.refresh")}
				</a>
			</div>
		</div>
		<table class="list">
			<tr>
				<th>
					<span>${message("MessageConfig.type")}</span>
				</th>
				<th>
					<span>${message("MessageConfig.isMailEnabled")}</span>
				</th>
				<th>
					<span>${message("MessageConfig.isSmsEnabled")}</span>
				</th>
				<th>
					<span>${message("admin.common.action")}</span>
				</th>
			</tr>
			[#list messageConfigs as messageConfig]
				<tr>
					<td>
						${message("MessageConfig.Type." + messageConfig.type)}
					</td>
					<td>
						<span class="${messageConfig.isMailEnabled?string("true", "false")}Icon">&nbsp;</span>
					</td>
					<td>
						<span class="${messageConfig.isSmsEnabled?string("true", "false")}Icon">&nbsp;</span>
					</td>
					<td>
						<a href="edit?id=${messageConfig.id}">[${message("admin.common.edit")}]</a>
					</td>
				</tr>
			[/#list]
		</table>
	</form>
</body>
</html>