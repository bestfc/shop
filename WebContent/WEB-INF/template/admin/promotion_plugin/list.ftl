<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("admin.promotionPlugin.list")} </title>
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
			content: "${message("admin.promotionPlugin.installConfirm")}",
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
			content: "${message("admin.promotionPlugin.uninstallConfirm")}",
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
		<a href="${base}/admin/index">${message("admin.breadcrumb.home")}</a> &raquo; ${message("admin.promotionPlugin.list")} <span>(${message("admin.page.total", promotionPlugins?size)})</span>
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
					<span>${message("PromotionPlugin.name")}</span>
				</th>
				<th>
					<span>${message("PromotionPlugin.version")}</span>
				</th>
				<th>
					<span>${message("PromotionPlugin.author")}</span>
				</th>
				<th>
					<span>${message("PromotionPlugin.price")}</span>
				</th>
				<th>
					<span>${message("PromotionPlugin.isEnabled")}</span>
				</th>
				<th>
					<span>${message("admin.common.action")}</span>
				</th>
			</tr>
			[#list promotionPlugins as promotionPlugin]
				<tr>
					<td>
						${promotionPlugin.name}
					</td>
					<td>
						${promotionPlugin.version!'-'}
					</td>
					<td>
						${promotionPlugin.author!'-'}
					</td>
					<td>
						[#if promotionPlugin.price??]
							${currency(promotionPlugin.price)}
						[/#if]
					</td>
					<td>
						<span class="${promotionPlugin.isEnabled?string("true", "false")}Icon">&nbsp;</span>
					</td>
					<td>
						[#if promotionPlugin.isInstalled]
							[#if promotionPlugin.settingUrl??]
								<a href="${promotionPlugin.settingUrl}">[${message("admin.promotionPlugin.setting")}]</a>
							[/#if]
							[#if promotionPlugin.uninstallUrl??]
								<a href="${promotionPlugin.uninstallUrl}" class="uninstall">[${message("admin.promotionPlugin.uninstall")}]</a>
							[/#if]
						[#else]
							[#if promotionPlugin.installUrl??]
								<a href="${promotionPlugin.installUrl}" class="install">[${message("admin.promotionPlugin.install")}]</a>
							[/#if]
						[/#if]
					</td>
				</tr>
			[/#list]
		</table>
	</form>
</body>
</html>