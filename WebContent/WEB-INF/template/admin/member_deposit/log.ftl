<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("admin.memberDeposit.log")} </title>
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
		<a href="${base}/admin/index">${message("admin.breadcrumb.home")}</a> &raquo; ${message("admin.memberDeposit.log")} <span>(${message("admin.page.total", page.total)})</span>
	</div>
	<form id="listForm" action="log" method="get">
		[#if member??]
			<input type="hidden" name="memberId" value="${member.id}" />
		[/#if]
		<div class="bar">
			<div class="buttonGroup">
				[#if member??]
					<a href="javascript:;" class="button" onclick="history.back(); return false;">${message("admin.common.back")}</a>
				[/#if]
				<a href="adjust" class="button">
					${message("admin.memberDeposit.adjust")}
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
					<li[#if page.searchProperty == "member.username"] class="current"[/#if] val="member.username">${message("MemberDepositLog.member")}</li>
				</ul>
			</div>
		</div>
		<table id="listTable" class="list">
			<tr>
				<th>
					<a href="javascript:;" class="sort" name="type">${message("MemberDepositLog.type")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="credit">${message("MemberDepositLog.credit")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="debit">${message("MemberDepositLog.debit")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="balance">${message("MemberDepositLog.balance")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="member">${message("MemberDepositLog.member")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="memo">${message("MemberDepositLog.memo")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="createdDate">${message("admin.common.createdDate")}</a>
				</th>
			</tr>
			[#list page.content as memberDepositLog]
				<tr>
					<td>
						${message("MemberDepositLog.Type." + memberDepositLog.type)}
					</td>
					<td>
						${currency(memberDepositLog.credit, true)}
					</td>
					<td>
						${currency(memberDepositLog.debit, true)}
					</td>
					<td>
						${currency(memberDepositLog.balance, true)}
					</td>
					<td>
						[#if memberDepositLog.member??]
							<a href="../member/view?id=${memberDepositLog.member.id}">${memberDepositLog.member.username}</a>
						[#else]
							-
						[/#if]
					</td>
					<td>
						[#if memberDepositLog.memo??]
							<span title="${memberDepositLog.memo}">${abbreviate(memberDepositLog.memo, 50, "...")}</span>
						[/#if]
					</td>
					<td>
						<span title="${memberDepositLog.createdDate?string("yyyy-MM-dd HH:mm:ss")}">${memberDepositLog.createdDate}</span>
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