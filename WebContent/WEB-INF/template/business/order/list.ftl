<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("business.order.list")} </title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/business/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/business/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/business/css/bootstrap-select.css" rel="stylesheet">
	<link href="${base}/resources/business/css/animate.css" rel="stylesheet">
	<link href="${base}/resources/business/css/adminLTE.css" rel="stylesheet">
	<link href="${base}/resources/business/css/common.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/business/js/html5shiv.js"></script>
		<script src="${base}/resources/business/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/business/js/jquery.js"></script>
	<script src="${base}/resources/business/js/bootstrap.js"></script>
	<script src="${base}/resources/business/js/bootstrap-select.js"></script>
	<script src="${base}/resources/business/js/velocity.js"></script>
	<script src="${base}/resources/business/js/velocity.ui.js"></script>
	<script src="${base}/resources/business/js/icheck.js"></script>
	<script src="${base}/resources/business/js/adminLTE.js"></script>
	<script src="${base}/resources/business/js/common.js"></script>
	<script type="text/javascript">
	$().ready(function() {
		
		var $printModal = $("#printModal");
		var $printSelect = $("#printSelect");
		var $printButton = $("#printButton");
		var $print = $("a.print");
		var orderId;
		var isDelivery;
		
		// 打印
		$printButton.click(function() {
			switch ($printSelect.val()) {
				case "order":
					window.open("${base}/business/print/order?orderId=" + orderId);
					break;
				case "product":
					window.open("${base}/business/print/product?orderId=" + orderId);
					break;
				case "shipping":
					window.open("${base}/business/print/shipping?orderId=" + orderId);
					break;
				case "delivery":
					window.open("${base}/business/print/delivery?orderId=" + orderId);
					break;
			}
		});
		
		// 打印
		$print.click(function() {
			var $element = $(this);
			var $deliveryOption = $printSelect.find("option[value='delivery']");
			orderId = $element.data("order-id");
			isDelivery = $element.data("is-delivery");
			
			if (isDelivery) {
				if ($deliveryOption.size() <= 0) {
					$printSelect.append('<option value="delivery">${message("business.order.deliveryPrint")}</option>');
					$printSelect.selectpicker("refresh");
				}
			} else {
				if ($deliveryOption.size() > 0) {
					$deliveryOption.remove();
					$printSelect.selectpicker("refresh");
				}
			}
			$printModal.modal();
		});
	
	});
	</script>
</head>
<body class="hold-transition sidebar-mini">
	<div id="printModal" class="modal fade" tabindex="-1">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button class="close" type="button" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">${message("business.order.print")}</h4>
				</div>
				<div class="modal-body text-center">
					<select id="printSelect" class="selectpicker">
						<option value="order">${message("business.order.orderPrint")}</option>
						<option value="product">${message("business.order.productPrint")}</option>
						<option value="shipping">${message("business.order.shippingPrint")}</option>
					</select>
				</div>
				<div class="modal-footer">
					<button id="printButton" class="btn btn-primary" type="button">${message("business.common.ok")}</button>
					<button class="btn btn-default" type="button" data-dismiss="modal">${message("business.common.cancel")}</button>
				</div>
			</div>
		</div>
	</div>
	<div class="wrapper">
		[#include "/business/include/main_header.ftl" /]
		[#include "/business/include/main_sidebar.ftl" /]
		<div class="content-wrapper">
			<div class="container-fluid">
				<section class="content-header">
					<h1>${message("business.order.list")}</h1>
					<ol class="breadcrumb">
						<li>
							<a href="/shop/business/index">
								<i class="fa fa-home"></i>
								${message("business.common.index")}
							</a>
						</li>
						<li class="active">${message("business.order.list")}</li>
					</ol>
				</section>
				<section class="content">
					<div class="row">
						<div class="col-xs-12">
							<form action="${base}/business/order/list" method="get">
								<input name="pageSize" type="hidden" value="${page.pageSize}">
								<input name="pageNumber" type="hidden" value="${page.pageNumber}">
								<input name="searchProperty" type="hidden" value="${page.searchProperty}">
								<input name="orderProperty" type="hidden" value="${page.orderProperty}">
								<input name="orderDirection" type="hidden" value="${page.orderDirection}">
								<input name="isPendingReceive" type="hidden" value="[#if isPendingReceive??]${isPendingReceive?string("true", "false")}[/#if]">
								<input name="isPendingRefunds" type="hidden" value="[#if isPendingRefunds??]${isPendingRefunds?string("true", "false")}[/#if]">
								<input name="isAllocatedStock" type="hidden" value="[#if isAllocatedStock??]${isAllocatedStock?string("true", "false")}[/#if]">
								<input name="hasExpired" type="hidden" value="[#if hasExpired??]${hasExpired?string("true", "false")}[/#if]">
								<div id="filterModal" class="modal fade" tabindex="-1">
									<div class="modal-dialog">
										<div class="modal-content">
											<div class="modal-header">
												<button class="close" type="button" data-dismiss="modal">&times;</button>
												<h4 class="modal-title">${message("business.common.moreOption")}</h4>
											</div>
											<div class="modal-body form-horizontal">
												<div class="form-group">
													<label class="col-xs-3 control-label">${message("Order.type")}:</label>
													<div class="col-xs-7">
														<select name="type" class="selectpicker form-control" data-size="5">
															<option value="">${message("business.common.choose")}</option>
															[#list types as value]
																<option value="${value}"[#if value == type] selected[/#if]>${message("Order.Type." + value)}</option>
															[/#list]
														</select>
													</div>
												</div>
												<div class="form-group">
													<label class="col-xs-3 control-label">${message("Order.status")}:</label>
													<div class="col-xs-7">
														<select name="status" class="selectpicker form-control" data-size="5">
															<option value="">${message("business.common.choose")}</option>
															[#list statuses as value]
																<option value="${value}"[#if value == status] selected[/#if]>${message("Order.Status." + value)}</option>
															[/#list]
														</select>
													</div>
												</div>
											</div>
											<div class="modal-footer">
												<button class="btn btn-primary" type="submit">${message("business.common.ok")}</button>
												<button class="btn btn-default" type="button" data-dismiss="modal">${message("business.common.cancel")}</button>
											</div>
										</div>
									</div>
								</div>
								<div class="box">
									<div class="box-header">
										<div class="row">
											<div class="col-xs-9">
												<div class="btn-group">
													<button class="btn btn-default" type="button" data-toggle="delete" disabled>
														<i class="fa fa-times"></i>
														${message("business.common.delete")}
													</button>
													<button class="btn btn-default" type="button" data-toggle="refresh">
														<i class="fa fa-refresh"></i>
														${message("business.common.refresh")}
													</button>
													<div class="btn-group">
														<button class="btn btn-default dropdown-toggle" type="button" data-toggle="dropdown">
															${message("business.order.filter")}
															<span class="caret"></span>
														</button>
														<ul class="dropdown-menu">
															<li[#if isPendingReceive?? && isPendingReceive] class="active"[/#if] data-filter-property="isPendingReceive" data-filter-value="true">
																<a href="javascript:;">${message("business.order.pendingReceive")}</a>
															</li>
															<li[#if isPendingReceive?? && !isPendingReceive] class="active"[/#if] data-filter-property="isPendingReceive" data-filter-value="false">
																<a href="javascript:;">${message("business.order.unPendingReceive")}</a>
															</li>
															<li class="divider"></li>
															<li[#if isPendingRefunds?? && isPendingRefunds] class="active"[/#if] data-filter-property="isPendingRefunds" data-filter-value="true">
																<a href="javascript:;">${message("business.order.pendingRefunds")}</a>
															</li>
															<li[#if isPendingRefunds?? && !isPendingRefunds] class="active"[/#if] data-filter-property="isPendingRefunds" data-filter-value="false">
																<a href="javascript:;">${message("business.order.unPendingRefunds")}</a>
															</li>
															<li class="divider"></li>
															<li[#if isAllocatedStock?? && isAllocatedStock] class="active"[/#if] data-filter-property="isAllocatedStock" data-filter-value="true">
																<a href="javascript:;">${message("business.order.allocatedStock")}</a>
															</li>
															<li[#if isAllocatedStock?? && !isAllocatedStock] class="active"[/#if] data-filter-property="isAllocatedStock" data-filter-value="false">
																<a href="javascript:;">${message("business.order.unAllocatedStock")}</a>
															</li>
															<li class="divider"></li>
															<li[#if hasExpired?? && hasExpired] class="active"[/#if] data-filter-property="hasExpired" data-filter-value="true">
																<a href="javascript:;">${message("business.order.hasExpired")}</a>
															</li>
															<li[#if hasExpired?? && !hasExpired] class="active"[/#if] data-filter-property="hasExpired" data-filter-value="false">
																<a href="javascript:;">${message("business.order.unexpired")}</a>
															</li>
														</ul>
													</div>
													<button class="btn btn-default" type="button" data-toggle="modal" data-target="#filterModal">${message("business.common.moreOption")}</button>
													<div class="btn-group">
														<button class="btn btn-default dropdown-toggle" type="button" data-toggle="dropdown">
															${message("business.common.pageSize")}
															<span class="caret"></span>
														</button>
														<ul class="dropdown-menu">
															<li[#if page.pageSize == 10] class="active"[/#if] data-page-size="10">
																<a href="javascript:;">10</a>
															</li>
															<li[#if page.pageSize == 20] class="active"[/#if] data-page-size="20">
																<a href="javascript:;">20</a>
															</li>
															<li[#if page.pageSize == 50] class="active"[/#if] data-page-size="50">
																<a href="javascript:;">50</a>
															</li>
															<li[#if page.pageSize == 100] class="active"[/#if] data-page-size="100">
																<a href="javascript:;">100</a>
															</li>
														</ul>
													</div>
												</div>
											</div>
											<div class="col-xs-3">
												<div class="box-tools">
													<div id="search" class="input-group">
														<div class="input-group-btn">
															<button class="btn btn-default" type="button" data-toggle="dropdown">
																[#switch page.searchProperty]
																	[#case "consignee"]
																		<span>${message("Order.consignee")}</span>
																		[#break]
																	[#case "areaName"]
																		<span>${message("Order.area")}</span>
																		[#break]
																	[#case "address"]
																		<span>${message("Order.address")}</span>
																		[#break]
																	[#case "zipCode"]
																		<span>${message("Order.zipCode")}</span>
																		[#break]
																	[#case "phone"]
																		<span>${message("Order.phone")}</span>
																		[#break]
																	[#default]
																		<span>${message("Order.sn")}</span>
																[/#switch]
																<i class="caret"></i>
															</button>
															<ul class="dropdown-menu">
																<li[#if !page.searchProperty?? || page.searchProperty == "sn"] class="active"[/#if] data-search-property="sn">
																	<a href="javascript:;">${message("Order.sn")}</a>
																</li>
																<li[#if page.searchProperty == "consignee"] class="active"[/#if] data-search-property="consignee">
																	<a href="javascript:;">${message("Order.consignee")}</a>
																</li>
																<li[#if page.searchProperty == "areaName"] class="active"[/#if] data-search-property="areaName">
																	<a href="javascript:;">${message("Order.area")}</a>
																</li>
																<li[#if page.searchProperty == "address"] class="active"[/#if] data-search-property="address">
																	<a href="javascript:;">${message("Order.address")}</a>
																</li>
																<li[#if page.searchProperty == "zipCode"] class="active"[/#if] data-search-property="zipCode">
																	<a href="javascript:;">${message("Order.zipCode")}</a>
																</li>
																<li[#if page.searchProperty == "phone"] class="active"[/#if] data-search-property="phone">
																	<a href="javascript:;">${message("Order.phone")}</a>
																</li>
															</ul>
														</div>
														<input name="searchValue" class="form-control" type="text" value="${page.searchValue}" placeholder="${message("business.common.search")}">
														<div class="input-group-btn">
															<button class="btn btn-default" type="submit">
																<i class="fa fa-search"></i>
															</button>
														</div>
													</div>
												</div>
											</div>
										</div>
									</div>
									<div class="box-body table-responsive no-padding">
										<table class="table table-hover">
											<thead>
												<tr>
													<th>
														<i class="check-all fa fa-square-o" data-toggle="checkAll"></i>
													</th>
													<th>
														<a href="javascript:;" data-order-property="sn">
															${message("Order.sn")}
															<i class="fa fa-sort"></i>
														</a>
													</th>
													<th>
														<a href="javascript:;" data-order-property="amount">
															${message("Order.amount")}
															<i class="fa fa-sort"></i>
														</a>
													</th>
													<th>
														<a href="javascript:;" data-order-property="member">
															${message("Order.member")}
															<i class="fa fa-sort"></i>
														</a>
													</th>
													<th>
														<a href="javascript:;" data-order-property="consignee">
															${message("Order.consignee")}
															<i class="fa fa-sort"></i>
														</a>
													</th>
													<th>
														<a href="javascript:;" data-order-property="paymentMethod">
															${message("Order.paymentMethod")}
															<i class="fa fa-sort"></i>
														</a>
													</th>
													<th>
														<a href="javascript:;" data-order-property="shippingMethod">
															${message("Order.shippingMethod")}
															<i class="fa fa-sort"></i>
														</a>
													</th>
													<th>
														<a href="javascript:;" data-order-property="status">
															${message("Order.status")}
															<i class="fa fa-sort"></i>
														</a>
													</th>
													<th>
														<a href="javascript:;" data-order-property="createdDate">
															${message("business.common.createdDate")}
															<i class="fa fa-sort"></i>
														</a>
													</th>
													<th>${message("business.common.action")}</th>
												</tr>
											</thead>
											<tbody>
												[#list page.content as order]
													<tr>
														<td>
															<input name="ids" type="checkbox" value="${order.id}">
														</td>
														<td>${order.sn}</td>
														<td>${currency(order.amount, true)}</td>
														<td>${order.member.username}</td>
														<td>${order.consignee}</td>
														<td>${order.paymentMethodName}</td>
														<td>${order.shippingMethodName}</td>
														<td>
															${message("Order.Status." + order.status)}
															[#if order.hasExpired()]
																<span class="gray-darker">(${message("business.order.hasExpired")})</span>
															[/#if]
														</td>
														<td>
															<span title="${order.createdDate?string("yyyy-MM-dd HH:mm:ss")}">${order.createdDate}</span>
														</td>
														<td>
															<a href="${base}/business/order/view?orderId=${order.id}">[${message("business.common.view")}]</a>
															[#if !order.hasExpired() && (order.status == "pendingPayment" || order.status == "pendingReview")]
																<a href="${base}/business/order/edit?orderId=${order.id}">[${message("business.common.edit")}]</a>
															[#else]
																<span title="${message("business.order.editNotAllowed")}">[${message("business.common.edit")}]</span>
															[/#if]
															<a class="print" href="javascript:;" data-order-id="${order.id}" data-is-delivery="${order.isDelivery?string("true", "false")}">[${message("business.order.print")}]</a>
														</td>
													</tr>
												[/#list]
											</tbody>
										</table>
										[#if !page.content?has_content]
											<p class="no-result">${message("business.common.noResult")}</p>
										[/#if]
									</div>
									[@pagination pageNumber = page.pageNumber totalPages = page.totalPages]
										[#if totalPages > 1]
											<div class="box-footer clearfix">
												[#include "/business/include/pagination.ftl"]
											</div>
										[/#if]
									[/@pagination]
								</div>
							</form>
						</div>
					</div>
				</section>
			</div>
		</div>
		[#include "/business/include/main_footer.ftl" /]
	</div>
</body>
</html>