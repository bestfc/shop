<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("admin.expressPlugin.list")} </title>
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
			content: "${message("admin.expressPlugin.installConfirm")}",
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
			content: "${message("admin.expressPlugin.uninstallConfirm")}",
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
		<a href="${base}/admin/index">${message("admin.breadcrumb.home")}</a> &raquo; ${message("admin.expressPlugin.list")} <span>(${message("admin.page.total", expressPlugins?size)})</span>
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
					<span>${message("ExpressPlugin.name")}</span>
				</th>
				<th>
					<span>${message("ExpressPlugin.version")}</span>
				</th>
				<th>
					<span>${message("ExpressPlugin.author")}</span>
				</th>
				<th>
					<span>${message("ExpressPlugin.isEnabled")}</span>
				</th>
				<th>
					<span>${message("admin.common.action")}</span>
				</th>
			</tr>
			[#list expressPlugins as expressPlugin]
				<tr>
					<td>
						[#if expressPlugin.siteUrl??]
							<a href="${expressPlugin.siteUrl}" target="_blank">${expressPlugin.name}</a>
						[#else]
							${expressPlugin.name}
						[/#if]
					</td>
					<td>
						${expressPlugin.version!'-'}
					</td>
					<td>
						${expressPlugin.author!'-'}
					</td>
					<td>
						<span class="${expressPlugin.isEnabled?string("true", "false")}Icon">&nbsp;</span>
					</td>
					<td>
						[#if expressPlugin.isInstalled]
							[#if expressPlugin.settingUrl??]
								<a href="${expressPlugin.settingUrl}">[${message("admin.expressPlugin.setting")}]</a>
							[/#if]
							[#if expressPlugin.uninstallUrl??]
								<a href="${expressPlugin.uninstallUrl}" class="uninstall">[${message("admin.expressPlugin.uninstall")}]</a>
							[/#if]
						[#else]
							[#if expressPlugin.installUrl??]
								<a href="${expressPlugin.installUrl}" class="install">[${message("admin.expressPlugin.install")}]</a>
							[/#if]
						[/#if]
					</td>
				</tr>
			[/#list]
		</table>
	</form>
</body>
</html>