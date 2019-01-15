<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html;charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("admin.template.list")} </title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/list.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $listForm = $("#listForm");
	var $type = $("#type");
	var $typeMenu = $("#typeMenu");
	var $typeMenuItem = $("#typeMenu li");

	[@flash_message /]
	
	$typeMenu.hover(
		function() {
			$(this).children("ul").show();
		}, function() {
			$(this).children("ul").hide();
		}
	);
	
	$typeMenuItem.click(function() {
		$type.val($(this).attr("val"));
		$listForm.submit();
	});

});
</script>
</head>
<body>
	<div class="breadcrumb">
		${message("admin.template.list")}
	</div>
	<form id="listForm" action="list" method="get">
		<input type="hidden" id="type" name="type" value="${type}" />
		<div class="bar">
			<div class="buttonGroup">
				<a href="javascript:;" id="refreshButton" class="iconButton">
					<span class="refreshIcon">&nbsp;</span>${message("admin.common.refresh")}
				</a>
				<div id="typeMenu" class="dropdownMenu">
					<a href="javascript:;" class="button">
						${message("TemplateConfig.type")}<span class="arrow">&nbsp;</span>
					</a>
					<ul>
						<li[#if !type??] class="current"[/#if] val="">${message("admin.template.allType")}</li>
						[#assign currentType = type]
						[#list types as type]
							<li[#if type == currentType] class="current"[/#if] val="${type}">${message("TemplateConfig.Type." + type)}</li>
						[/#list]
					</ul>
				</div>
			</div>
		</div>
		<table id="listTable" class="list">
			<tr>
				<th>
					<span>${message("TemplateConfig.name")}</span>
				</th>
				<th>
					<span>${message("TemplateConfig.type")}</span>
				</th>
				<th>
					<span>${message("TemplateConfig.templatePath")}</span>
				</th>
				<th>
					<span>${message("TemplateConfig.description")}</span>
				</th>
				<th>
					<span>${message("admin.common.action")}</span>
				</th>
			</tr>
			[#list templateConfigs as templateConfig]
				<tr>
					<td>
						${templateConfig.name}
					</td>
					<td>
						${message("TemplateConfig.Type." + templateConfig.type)}
					</td>
					<td>
						${templateConfig.templatePath}
					</td>
					<td>
						[#if templateConfig.description??]
							<span title="${templateConfig.description}">${abbreviate(templateConfig.description, 50, "...")}</span>
						[/#if]
					</td>
					<td>
						<a href="edit?id=${templateConfig.id}">[${message("admin.common.edit")}]</a>
					</td>
				</tr>
			[/#list]
		</table>
	</form>
</body>
</html>