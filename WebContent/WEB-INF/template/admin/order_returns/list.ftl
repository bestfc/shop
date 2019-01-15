<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("admin.orderReturns.list")} </title>
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
		<a href="${base}/admin/index">${message("admin.breadcrumb.home")}</a> &raquo; ${message("admin.orderReturns.list")} <span>(${message("admin.page.total", page.total)})</span>
	</div>
	<form id="listForm" action="list" method="get">
		<div class="bar">
			<div class="buttonGroup">
				<a href="javascript:;" id="deleteButton" class="iconButton disabled">
					<span class="deleteIcon">&nbsp;</span>${message("admin.common.delete")}
				</a>
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
					<li[#if page.searchProperty == "sn"] class="current"[/#if] val="sn">${message("OrderReturns.sn")}</li>
					<li[#if page.searchProperty == "trackingNo"] class="current"[/#if] val="trackingNo">${message("OrderReturns.trackingNo")}</li>
					<li[#if page.searchProperty == "shipper"] class="current"[/#if] val="shipper">${message("OrderReturns.shipper")}</li>
					<li[#if page.searchProperty == "area"] class="current"[/#if] val="area">${message("OrderReturns.area")}</li>
					<li[#if page.searchProperty == "address"] class="current"[/#if] val="address">${message("OrderReturns.address")}</li>
					<li[#if page.searchProperty == "zipCode"] class="current"[/#if] val="zipCode">${message("OrderReturns.zipCode")}</li>
					<li[#if page.searchProperty == "phone"] class="current"[/#if] val="phone">${message("OrderReturns.phone")}</li>
				</ul>
			</div>
		</div>
		<table id="listTable" class="list">
			<tr>
				<th class="check">
					<input type="checkbox" id="selectAll" />
				</th>
				<th>
					<a href="javascript:;" class="sort" name="sn">${message("OrderReturns.sn")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="shippingMethod">${message("OrderReturns.shippingMethod")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="deliveryCorp">${message("OrderReturns.deliveryCorp")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="trackingNo">${message("OrderReturns.trackingNo")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="shipper">${message("OrderReturns.shipper")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="createdDate">${message("admin.common.createdDate")}</a>
				</th>
				<th>
					<span>${message("admin.common.action")}</span>
				</th>
			</tr>
			[#list page.content as returns]
				<tr>
					<td>
						<input type="checkbox" name="ids" value="${returns.id}" />
					</td>
					<td>
						${returns.sn}
					</td>
					<td>
						${returns.shippingMethod}
					</td>
					<td>
						${returns.deliveryCorp}
					</td>
					<td>
						${returns.trackingNo}
					</td>
					<td>
						${returns.shipper}
					</td>
					<td>
						<span title="${returns.createdDate?string("yyyy-MM-dd HH:mm:ss")}">${returns.createdDate}</span>
					</td>
					<td>
						<a href="view?id=${returns.id}">[${message("admin.common.view")}]</a>
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