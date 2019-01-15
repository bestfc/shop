<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("admin.deliveryCenter.list")} </title>
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
		<a href="${base}/admin/index">${message("admin.breadcrumb.home")}</a> &raquo; ${message("admin.deliveryCenter.list")} <span>(${message("admin.page.total", page.total)})</span>
	</div>
	<form id="listForm" action="list" method="get">
		<div class="bar">
			<div class="buttonGroup">
				<a href="javascript:;" id="refreshButton" class="iconButton">
					<span class="refreshIcon">&nbsp;</span>${message("admin.common.refresh")}
				</a>
				<div id="pageSizeMenu" class="dropdownMenu">
					<a href="javascript:;" class="button">
						${message("admin.page.pageSize")}<span class="arrow">&nbsp;</span>
					</a>
					<ul>
						<li[#if page.pageSize == 10] class="current"[/#if] val="10">10</li>
						<li[#if page.pageSize == 20] class="current"[/#if] val="20">20</li>
						<li[#if page.pageSize == 50] class="current"[/#if] val="50">50</li>
						<li[#if page.pageSize == 100] class="current"[/#if] val="100">100</li>
					</ul>
				</div>	
			</div>
			<div id="searchPropertyMenu" class="dropdownMenu">
				<div class="search">
					<span class="arrow">&nbsp;</span>
					<input type="text" id="searchValue" name="searchValue" value="${page.searchValue}" maxlength="200" />
					<button type="submit">&nbsp;</button>
				</div>
				<ul>
					<li[#if page.searchProperty == "name"] class="current"[/#if] val="name">${message("DeliveryCenter.name")}</li>
					<li[#if page.searchProperty == "contact"] class="current"[/#if] val="contact">${message("DeliveryCenter.contact")}</li>
					<li[#if page.searchProperty == "phone"] class="current"[/#if] val="phone">${message("DeliveryCenter.phone")}</li>
					<li[#if page.searchProperty == "mobile"] class="current"[/#if] val="mobile">${message("DeliveryCenter.mobile")}</li>
				</ul>
			</div>
		</div>
		<table id="listTable" class="list">
			<tr>
				<th>
					<a href="javascript:;" class="sort" name="name">${message("DeliveryCenter.name")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="contact">${message("DeliveryCenter.contact")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="areaName">${message("DeliveryCenter.areaName")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="address">${message("DeliveryCenter.address")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="zipCode">${message("DeliveryCenter.zipCode")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="phone">${message("DeliveryCenter.phone")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="mobile">${message("DeliveryCenter.mobile")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="isDefault">${message("DeliveryCenter.isDefault")}</a>
				</th>
			</tr>
			[#list page.content as deliveryCenter]
				<tr>
					<td>
						${deliveryCenter.name}
					</td>
					<td>
						${deliveryCenter.contact}
					</td>
					<td>
						${deliveryCenter.areaName}
					</td>
					<td>
						<span title="${deliveryCenter.address}">${abbreviate(deliveryCenter.address, 50, "...")}</span>
					</td>
					<td>
						${deliveryCenter.zipCode}
					</td>
					<td>
						${deliveryCenter.phone}
					</td>
					<td>
						${deliveryCenter.mobile}
					</td>
					<td>
						<span class="${deliveryCenter.isDefault?string("true", "false")}Icon">&nbsp;</span>
					</td>
				</tr>
			[/#list]
		</table>
		[@pagination pageNumber = page.pageNumber totalPages = page.totalPages]
			[#include "/admin/include/pagination.ftl"]
		[/@pagination]
	</form>
</body>
</html>