[#assign shiro = JspTaglibs["/WEB-INF/tld/shiro.tld"] /]
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("admin.order.list")} </title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/list.js"></script>
<style type="text/css">
.moreTable th {
	width: 80px;
	line-height: 25px;
	padding: 5px 10px 5px 0px;
	text-align: right;
	font-weight: normal;
	color: #333333;
	background-color: #f8fbff;
}

.moreTable td {
	line-height: 25px;
	padding: 5px;
	color: #666666;
}
</style>
<script type="text/javascript">
$().ready(function() {

	var $listForm = $("#listForm");
	var $filterMenu = $("#filterMenu");
	var $filterMenuItem = $("#filterMenu li");
	var $moreButton = $("#moreButton");
	var $print = $("#listTable select[name='print']");
	
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
	
	// 更多选项
	$moreButton.click(function() {
		$.dialog({
			title: "${message("admin.order.moreOption")}",
			content: 
				[@compress single_line = true]
					'<table id="moreTable" class="moreTable">
						<tr>
							<th>
								${message("Order.type")}:
							<\/th>
							<td>
								<select name="type">
									<option value="">${message("admin.common.choose")}<\/option>
									[#list types as value]
										<option value="${value}"[#if value == type] selected="selected"[/#if]>${message("Order.Type." + value)}<\/option>
									[/#list]
								<\/select>
							<\/td>
						<\/tr>
						<tr>
							<th>
								${message("Order.status")}:
							<\/th>
							<td>
								<select name="status">
									<option value="">${message("admin.common.choose")}<\/option>
									[#list statuses as value]
										<option value="${value}"[#if value == status] selected="selected"[/#if]>${message("Order.Status." + value)}<\/option>
									[/#list]
								<\/select>
							<\/td>
						<\/tr>
						<tr>
							<th>
								${message("admin.order.memberUsername")}:
							<\/th>
							<td>
								<input type="text" name="memberUsername" class="text" value="${memberUsername}" maxlength="200" \/>
							<\/td>
						<\/tr>
					<\/table>'
				[/@compress]
			,
			width: 470,
			modal: true,
			ok: "${message("admin.dialog.ok")}",
			cancel: "${message("admin.dialog.cancel")}",
			onOk: function() {
				$("#moreTable :input").each(function() {
					var $this = $(this);
					$("#" + $this.attr("name")).val($this.val());
				});
				$listForm.submit();
			}
		});
	});
	
	// 打印选择
	$print.change(function() {
		var $this = $(this);
		if ($this.val() != "") {
			window.open($this.val());
		}
	});

});
</script>
</head>
<body>
	<div class="breadcrumb">
		<a href="${base}/admin/index">${message("admin.breadcrumb.home")}</a> &raquo; ${message("admin.order.list")} <span>(${message("admin.page.total", page.total)})</span>
	</div>
	<form id="listForm" action="list" method="get">
		<input type="hidden" id="type" name="type" value="${type}" />
		<input type="hidden" id="status" name="status" value="${status}" />
		<input type="hidden" id="memberUsername" name="memberUsername" value="${memberUsername}" />
		<input type="hidden" id="isPendingReceive" name="isPendingReceive" value="${(isPendingReceive?string("true", "false"))!}" />
		<input type="hidden" id="isPendingRefunds" name="isPendingRefunds" value="${(isPendingRefunds?string("true", "false"))!}" />
		<input type="hidden" id="isAllocatedStock" name="isAllocatedStock" value="${(isAllocatedStock?string("true", "false"))!}" />
		<input type="hidden" id="hasExpired" name="hasExpired" value="${(hasExpired?string("true", "false"))!}" />
		<div class="bar">
			<div class="buttonGroup">
				<a href="javascript:;" id="refreshButton" class="iconButton">
					<span class="refreshIcon">&nbsp;</span>${message("admin.common.refresh")}
				</a>
				<div id="filterMenu" class="dropdownMenu">
					<a href="javascript:;" class="button">
						${message("admin.order.filter")}<span class="arrow">&nbsp;</span>
					</a>
					<ul class="check">
						<li name="isPendingReceive"[#if isPendingReceive?? && isPendingReceive] class="checked"[/#if] val="true">${message("admin.order.pendingReceive")}</li>
						<li name="isPendingReceive"[#if isPendingReceive?? && !isPendingReceive] class="checked"[/#if] val="false">${message("admin.order.unPendingReceive")}</li>
						<li class="divider">&nbsp;</li>
						<li name="isPendingRefunds"[#if isPendingRefunds?? && isPendingRefunds] class="checked"[/#if] val="true">${message("admin.order.pendingRefunds")}</li>
						<li name="isPendingRefunds"[#if isPendingRefunds?? && !isPendingRefunds] class="checked"[/#if] val="false">${message("admin.order.unPendingRefunds")}</li>
						<li class="divider">&nbsp;</li>
						<li name="isAllocatedStock"[#if isAllocatedStock?? && isAllocatedStock] class="checked"[/#if] val="true">${message("admin.order.allocatedStock")}</li>
						<li name="isAllocatedStock"[#if isAllocatedStock?? && !isAllocatedStock] class="checked"[/#if] val="false">${message("admin.order.unAllocatedStock")}</li>
						<li class="divider">&nbsp;</li>
						<li name="hasExpired"[#if hasExpired?? && hasExpired] class="checked"[/#if] val="true">${message("admin.order.hasExpired")}</li>
						<li name="hasExpired"[#if hasExpired?? && !hasExpired] class="checked"[/#if] val="false">${message("admin.order.unexpired")}</li>
					</ul>
				</div>
				<a href="javascript:;" id="moreButton" class="button">${message("admin.order.moreOption")}</a>
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
					<li[#if page.searchProperty == "sn"] class="current"[/#if] val="sn">${message("Order.sn")}</li>
					<li[#if page.searchProperty == "consignee"] class="current"[/#if] val="consignee">${message("Order.consignee")}</li>
					<li[#if page.searchProperty == "areaName"] class="current"[/#if] val="areaName">${message("Order.area")}</li>
					<li[#if page.searchProperty == "address"] class="current"[/#if] val="address">${message("Order.address")}</li>
					<li[#if page.searchProperty == "zipCode"] class="current"[/#if] val="zipCode">${message("Order.zipCode")}</li>
					<li[#if page.searchProperty == "phone"] class="current"[/#if] val="phone">${message("Order.phone")}</li>
				</ul>
			</div>
		</div>
		<table id="listTable" class="list">
			<tr>
				<th>
					<a href="javascript:;" class="sort" name="sn">${message("Order.sn")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="amount">${message("Order.amount")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="member">${message("Order.member")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="business">${message("Order.store")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="consignee">${message("Order.consignee")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="paymentMethodName">${message("Order.paymentMethod")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="shippingMethodName">${message("Order.shippingMethod")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="status">${message("Order.status")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="createdDate">${message("admin.common.createdDate")}</a>
				</th>
				[@shiro.hasPermission name = "admin:print"]
					<th>
						<span>${message("admin.order.print")}</span>
					</th>
				[/@shiro.hasPermission]
				<th>
					<span>${message("admin.common.action")}</span>
				</th>
			</tr>
			[#list page.content as order]
				<tr>
					<td>
						${order.sn}
					</td>
					<td>
						${currency(order.amount, true)}
					</td>
					<td>
						${order.member.username}
					</td>
					<td>
						${order.store.name}
					</td>
					<td>
						${order.consignee}
					</td>
					<td>
						${order.paymentMethodName}
					</td>
					<td>
						${order.shippingMethodName}
					</td>
					<td>
						${message("Order.Status." + order.status)}
						[#if order.hasExpired()]
							<span class="silver">(${message("admin.order.hasExpired")})</span>
						[/#if]
					</td>
					<td>
						<span title="${order.createdDate?string("yyyy-MM-dd HH:mm:ss")}">${order.createdDate}</span>
					</td>
					[@shiro.hasPermission name = "admin:print"]
						<td>
							<select name="print">
								<option value="">${message("admin.common.choose")}</option>
								<option value="../print/order?id=${order.id}">${message("admin.order.orderPrint")}</option>
							</select>
						</td>
					[/@shiro.hasPermission]
					<td>
						<a href="view?id=${order.id}">[${message("admin.common.view")}]</a>
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