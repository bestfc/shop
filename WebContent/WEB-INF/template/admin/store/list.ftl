<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("admin.store.list")} </title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/list.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $listForm = $("#listForm");
	var $filterMenu = $("#filterMenu");
	var $filterMenuItem = $("#filterMenu li");
	
	[@flash_message /]
	
	// 筛选菜单
	$filterMenu.hover(
		function() {
			$(this).children("ul").show();
		}, function() {
			$(this).children("ul").hide();
		}
	);
	
	// 筛选
	$filterMenuItem.click(function() {
		var $this = $(this);
		var $dest = $("#" + $this.attr("name"));
		if ($this.hasClass("checked")) {
			$dest.val("");
		} else {
			$dest.val($this.attr("val"));
		}
		$listForm.submit();
	});

});
</script>
</head>
<body>
	<div class="breadcrumb">
		<a href="${base}/admin/index">${message("admin.breadcrumb.home")}</a> &raquo; ${message("admin.store.list")} <span>(${message("admin.page.total", page.total)})</span>
	</div>
	<form id="listForm" action="list" method="get">
		<input type="hidden" id="type" name="type" value="${type}" />
		<input type="hidden" id="status" name="status" value="${status}" />
		<input type="hidden" id="isEnabled" name="isEnabled" value="${(isEnabled?string("true", "false"))!}" />
		<input type="hidden" id="hasExpired" name="hasExpired" value="${(hasExpired?string("true", "false"))!}" />
		<div class="bar">
			<div class="buttonGroup">
				<a href="add" class="iconButton">
					<span class="addIcon">&nbsp;</span>${message("admin.common.add")}
				</a>
				<a href="javascript:;" id="deleteButton" class="iconButton disabled">
					<span class="deleteIcon">&nbsp;</span>${message("admin.common.delete")}
				</a>
				<a href="javascript:;" id="refreshButton" class="iconButton">
					<span class="refreshIcon">&nbsp;</span>${message("admin.common.refresh")}
				</a>
				<div id="filterMenu" class="dropdownMenu">
					<a href="javascript:;" class="button">
						${message("admin.store.filter")}<span class="arrow">&nbsp;</span>
					</a>
					<ul class="check">
						<li name="type"[#if type?? && type == "general"] class="checked"[/#if] val="general">${message("Store.Type.general")}</li>
						<li name="type"[#if type?? && type == "self"] class="checked"[/#if] val="self">${message("Store.Type.self")}</li>
						<li class="divider">&nbsp;</li>
						<li name="status"[#if status?? && status == "pending"] class="checked"[/#if] val="pending">${message("Store.Status.pending")}</li>
						<li name="status"[#if status?? && status == "failed"] class="checked"[/#if] val="failed">${message("Store.Status.failed")}</li>
						<li name="status"[#if status?? && status == "approved"] class="checked"[/#if] val="approved">${message("Store.Status.approved")}</li>
						<li name="status"[#if status?? && status == "success"] class="checked"[/#if] val="success">${message("Store.Status.success")}</li>
						<li class="divider">&nbsp;</li>
						<li name="isEnabled"[#if isEnabled?? && isEnabled] class="checked"[/#if] val="true">${message("admin.store.enabled")}</li>
						<li name="isEnabled"[#if isEnabled?? && !isEnabled] class="checked"[/#if] val="false">${message("admin.store.disabled")}</li>
						<li class="divider">&nbsp;</li>
						<li name="hasExpired"[#if hasExpired?? && hasExpired] class="checked"[/#if] val="true">${message("admin.store.hasExpired")}</li>
						<li name="hasExpired"[#if hasExpired?? && !hasExpired] class="checked"[/#if] val="false">${message("admin.store.unexpired")}</li>
					</ul>
				</div>
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
					<li[#if page.searchProperty == "name"] class="current"[/#if] val="name">${message("Store.name")}</li>
					<li[#if page.searchProperty == "email"] class="current"[/#if] val="email">${message("Store.email")}</li>
					<li[#if page.searchProperty == "mobile"] class="current"[/#if] val="mobile">${message("Store.mobile")}</li>
				</ul>
			</div>
		</div>
		<table id="listTable" class="list">
			<tr>
				<th class="check">
					<input type="checkbox" id="selectAll" />
				</th>
				<th>
					<a href="javascript:;" class="sort" name="name">${message("Store.name")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="type">${message("Store.type")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="business">${message("Store.business")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="storeRank">${message("Store.storeRank")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="storeCategory">${message("Store.storeCategory")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="status" >${message("Store.status")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="isEnabled" >${message("Store.isEnabled")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="createdDate">${message("admin.common.createdDate")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="endDate">${message("Store.endDate")}</a>
				</th>
				<th>
					<span>${message("admin.common.action")}</span>
				</th>
			</tr>
			[#list page.content as store]
				<tr>
					<td>
						<input type="checkbox" name="ids" value="${store.id}" />
					</td>
					<td>
						${store.name}
					</td>
					<td>
						${message("Store.Type." + store.type)}
					</td>
					<td>
						${store.business.username}
					</td>
					<td>
						${store.storeRank.name}
					</td>
					<td>
						${store.storeCategory.name}
					</td>
					<td>
						<span class="[#if store.status == "approved" || store.status == "success"]green[#else]red[/#if]">${message("Store.Status." + store.status)}</span>
						[#if store.hasExpired()]
							<span class="silver">(${message("admin.store.hasExpired")})</span>
						[/#if]
					</td>
					<td>
						[#if store.isEnabled]
							<span class="green">${message("admin.store.enabled")}</span>
						[#else]
							<span class="red">${message("admin.store.disabled")}</span>
						[/#if]
					</td>
					<td>
						<span title="${store.createdDate?string("yyyy-MM-dd HH:mm:ss")}">${store.createdDate}</span>
					</td>
					<td>
						[#if store.endDate??]
							<span title="${store.endDate?string("yyyy-MM-dd HH:mm:ss")}">${store.endDate}</span>
						[#else]
							-
						[/#if]
					</td>
					<td>
						<a href="view?id=${store.id}">[${message("admin.common.view")}]</a>
						<a href="edit?id=${store.id}">[${message("admin.common.edit")}]</a>
						[#if store.status == "pending"]
							<a href="review?id=${store.id}">[${message("admin.common.review")}]</a>
						[/#if]
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