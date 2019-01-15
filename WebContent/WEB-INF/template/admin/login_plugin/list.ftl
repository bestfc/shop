<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("admin.loginPlugin.list")} </title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/list.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $listTable = $("#listTable");
	var $install = $("#listTable a.install");
	var $uninstall = $("#listTable a.uninstall");
	
	[@flash_message /]

	// 安装
	$install.click(function() {
		var $this = $(this);
		$.dialog({
			type: "warn",
			content: "${message("admin.loginPlugin.installConfirm")}",
			onOk: function() {
				$.ajax({
					url: $this.attr("href"),
					type: "POST",
					dataType: "json",
					cache: false,
					success: function(message) {
						if (message.type == "success") {
							location.reload(true);
						} else {
							$.message(message);
						}
					}
				});
			}
		});
		return false;
	});
	
	// 卸载
	$uninstall.click(function() {
		var $this = $(this);
		$.dialog({
			type: "warn",
			content: "${message("admin.loginPlugin.uninstallConfirm")}",
			onOk: function() {
				$.ajax({
					url: $this.attr("href"),
					type: "POST",
					dataType: "json",
					cache: false,
					success: function(message) {
						if (message.type == "success") {
							location.reload(true);
						} else {
							$.message(message);
						}
					}
				});
			}
		});
		return false;
	});

});
</script>
</head>
<body>
	<div class="breadcrumb">
		<a href="${base}/admin/index">${message("admin.breadcrumb.home")}</a> &raquo; ${message("admin.loginPlugin.list")} <span>(${message("admin.page.total", loginPlugins?size)})</span>
	</div>
	<form id="listForm" action="list" method="get">
		<div class="bar">
			<div class="buttonGroup">
				<a href="javascript:;" id="refreshButton" class="iconButton">
					<span class="refreshIcon">&nbsp;</span>${message("admin.common.refresh")}
				</a>
			</div>
		</div>
		<table id="listTable" class="list">
			<tr>
				<th>
					<span>${message("LoginPlugin.name")}</span>
				</th>
				<th>
					<span>${message("LoginPlugin.version")}</span>
				</th>
				<th>
					<span>${message("LoginPlugin.author")}</span>
				</th>
				<th>
					<span>${message("LoginPlugin.isEnabled")}</span>
				</th>
				<th>
					<span>${message("admin.common.action")}</span>
				</th>
			</tr>
			[#list loginPlugins as loginPlugin]
				<tr>
					<td>
						[#if loginPlugin.siteUrl??]
							<a href="${loginPlugin.siteUrl}" target="_blank">${loginPlugin.name}</a>
						[#else]
							${loginPlugin.name}
						[/#if]
					</td>
					<td>
						${loginPlugin.version!'-'}
					</td>
					<td>
						${loginPlugin.author!'-'}
					</td>
					<td>
						<span class="${loginPlugin.isEnabled?string("true", "false")}Icon">&nbsp;</span>
					</td>
					<td>
						[#if loginPlugin.isInstalled]
							[#if loginPlugin.settingUrl??]
								<a href="${loginPlugin.settingUrl}">[${message("admin.loginPlugin.setting")}]</a>
							[/#if]
							[#if loginPlugin.uninstallUrl??]
								<a href="${loginPlugin.uninstallUrl}" class="uninstall">[${message("admin.loginPlugin.uninstall")}]</a>
							[/#if]
						[#else]
							[#if loginPlugin.installUrl??]
								<a href="${loginPlugin.installUrl}" class="install">[${message("admin.loginPlugin.install")}]</a>
							[/#if]
						[/#if]
					</td>
				</tr>
			[/#list]
		</table>
	</form>
</body>
</html>