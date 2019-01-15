<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html;charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("admin.admin.list")} </title>
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
		${message("admin.admin.list")} <span>(${message("admin.page.total", page.total)})</span>
	</div>
	<form id="listForm" action="list" method="get">
		<div class="bar">
			<a href="add" class="iconButton">
				<span class="addIcon">&nbsp;</span>${message("admin.common.add")}
			</a>
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
					<li[#if page.searchProperty == "username"] class="current"[/#if] val="username">${message("Admin.username")}</li>
					<li[#if page.searchProperty == "email"] class="current"[/#if] val="email">${message("Admin.email")}</li>
					<li[#if page.searchProperty == "name"] class="current"[/#if] val="name">${message("Admin.name")}</li>
				</ul>
			</div>
		</div>
		<table id="listTable" class="list">
			<tr>
				<th class="check">
					<input type="checkbox" id="selectAll" />
				</th>
				<th>
					<a href="javascript:;" class="sort" name="username">${message("Admin.username")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="email">${message("Admin.email")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="name">${message("Admin.name")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="department">${message("Admin.department")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="lastLoginIp">${message("User.lastLoginIp")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="lastLoginDate">${message("User.lastLoginDate")}</a>
				</th>
				<th>
					<span>${message("admin.admin.status")}</span>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="createdDate">${message("admin.common.createdDate")}</a>
				</th>
				<th>
					<span>${message("admin.common.action")}</span>
				</th>
			</tr>
			[#list page.content as admin]
				<tr>
					<td>
						<input type="checkbox" name="ids" value="${admin.id}" />
					</td>
					<td>
						${admin.username}
					</td>
					<td>
						${admin.email}
					</td>
					<td>
						${admin.name}
					</td>
					<td>
						${admin.department}
					</td>
					<td>
						${admin.lastLoginIp}
					</td>
					<td>
						[#if admin.lastLoginDate??]
							<span title="${admin.lastLoginDate?string("yyyy-MM-dd HH:mm:ss")}">${admin.lastLoginDate}</span>
						[#else]
							-
						[/#if]
					</td>
					<td>
						[#if !admin.isEnabled]
							<span class="red">${message("admin.admin.disabled")}</span>
						[#elseif admin.isLocked]
							<span class="red"> ${message("admin.admin.locked")} </span>
						[#else]
							<span class="green">${message("admin.admin.normal")}</span>
						[/#if]
					</td>
					<td>
						<span title="${admin.createdDate?string("yyyy-MM-dd HH:mm:ss")}">${admin.createdDate}</span>
					</td>
					<td>
						<a href="edit?id=${admin.id}">[${message("admin.common.edit")}]</a>
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