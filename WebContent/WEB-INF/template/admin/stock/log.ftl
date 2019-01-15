<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("admin.stock.log")} </title>
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
		<a href="${base}/admin/index">${message("admin.breadcrumb.home")}</a> &raquo; ${message("admin.stock.log")} <span>(${message("admin.page.total", page.total)})</span>
	</div>
	<form id="listForm" action="log" method="get">
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
					<li[#if page.searchProperty == "sku.sn"] class="current"[/#if] val="sku.sn">${message("Sku.sn")}</li>
				</ul>
			</div>
		</div>
		<table id="listTable" class="list">
			<tr>
				<th>
					<a href="javascript:;" class="sort" name="sku">${message("Sku.sn")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="sku">${message("admin.stockLog.sku")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="type">${message("StockLog.type")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="inQuantity">${message("StockLog.inQuantity")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="outQuantity">${message("StockLog.outQuantity")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="stock">${message("StockLog.stock")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="memo">${message("StockLog.memo")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="createdDate">${message("admin.common.createdDate")}</a>
				</th>
			</tr>
			[#list page.content as stockLog]
				<tr>
					<td>
						${stockLog.sku.sn}
					</td>
					<td>
						<span title="${stockLog.sku.name}">${abbreviate(stockLog.sku.name, 50, "...")}</span>
						[#if stockLog.sku.specifications?has_content]
							<span class="silver">[${stockLog.sku.specifications?join(", ")}]</span>
						[/#if]
					</td>
					<td>
						${message("StockLog.Type." + stockLog.type)}
					</td>
					<td>
						${stockLog.inQuantity}
					</td>
					<td>
						${stockLog.outQuantity}
					</td>
					<td>
						${stockLog.stock}
					</td>
					<td>
						[#if stockLog.memo??]
							<span title="${stockLog.memo}">${abbreviate(stockLog.memo, 50, "...")}</span>
						[/#if]
					</td>
					<td>
						<span title="${stockLog.createdDate?string("yyyy-MM-dd HH:mm:ss")}">${stockLog.createdDate}</span>
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