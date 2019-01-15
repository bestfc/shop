<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("business.productNotify.list")} </title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/business/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/business/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/business/css/animate.css" rel="stylesheet">
	<link href="${base}/resources/business/css/adminLTE.css" rel="stylesheet">
	<link href="${base}/resources/business/css/common.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/business/js/html5shiv.js"></script>
		<script src="${base}/resources/business/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/business/js/jquery.js"></script>
	<script src="${base}/resources/business/js/bootstrap.js"></script>
	<script src="${base}/resources/business/js/velocity.js"></script>
	<script src="${base}/resources/business/js/velocity.ui.js"></script>
	<script src="${base}/resources/business/js/icheck.js"></script>
	<script src="${base}/resources/business/js/adminLTE.js"></script>
	<script src="${base}/resources/business/js/common.js"></script>
	<script type="text/javascript">
	$().ready(function() {
		
		var $send = $("#send");
		var $delete = $("#delete");
		var $checkAll = $("[data-toggle='checkAll']");
		var $ids = $("input[name='ids']");
		
		$ids.on("ifChanged", function() {
			$send.add($delete).attr("disabled", $ids.filter(":checked").size() < 1);
		});
		
		// 删除
		$delete.deleteItem({
			url: "${base}/business/product_notify/delete",
			data: function() {
				return $ids.serialize();
			},
			removeElement: function() {
				return $ids.filter(":checked").closest("tr");
			},
			complete: function() {
				$ids = $("input[name='ids']");
				$send.add($delete).attr("disabled", true);
				$checkAll.checkAll("uncheck");
				if ($ids.size() < 1) {
					$send.add($delete).attr("disabled", true);
					setTimeout(function() {
						location.reload(true);
					}, 3000);
				}
			}
		});
		
		// 发送到货通知
		$send.click(function() {
			if (confirm("${message("business.productNotify.sendConfirm")}")) {
				$ids = $("input[name='ids']");
				$.post("${base}/business/product_notify/send", $ids.serialize(), function() {
					setTimeout(function() {
						location.reload(true);
					}, 3000);
				});
			}
		});
	
	});
	</script>
</head>
<body class="hold-transition sidebar-mini">
	<div class="wrapper">
		[#include "/business/include/main_header.ftl" /]
		[#include "/business/include/main_sidebar.ftl" /]
		<div class="content-wrapper">
			<div class="container-fluid">
				<section class="content-header">
					<h1>${message("business.productNotify.list")}</h1>
					<ol class="breadcrumb">
						<li>
							<a href="/shop/business/index">
								<i class="fa fa-home"></i>
								${message("business.common.index")}
							</a>
						</li>
						<li class="active">${message("business.productNotify.list")}</li>
					</ol>
				</section>
				<section class="content">
					<div class="row">
						<div class="col-xs-12">
							<form action="${base}/business/product_notify/list" method="get">
								<input name="pageSize" type="hidden" value="${page.pageSize}">
								<input name="pageNumber" type="hidden" value="${page.pageNumber}">
								<input name="searchProperty" type="hidden" value="${page.searchProperty}">
								<input name="orderProperty" type="hidden" value="${page.orderProperty}">
								<input name="orderDirection" type="hidden" value="${page.orderDirection}">
								<input name="isMarketable" type="hidden" value="[#if isMarketable??]${isMarketable?string("true", "false")}[/#if]">
								<input name="isOutOfStock" type="hidden" value="[#if isOutOfStock??]${isOutOfStock?string("true", "false")}[/#if]">
								<input name="hasSent" type="hidden" value="[#if hasSent??]${hasSent?string("true", "false")}[/#if]">
								<div class="box">
									<div class="box-header">
										<div class="row">
											<div class="col-xs-9">
												<div class="btn-group">
													<button id="send" class="btn btn-default" type="button" disabled>
														<i class="fa fa-envelope"></i>
														${message("business.productNotify.send")}
													</button>
													<button id="delete" class="btn btn-default" type="button" disabled>
														<i class="fa fa-times"></i>
														${message("business.common.delete")}
													</button>
													<button class="btn btn-default" type="button" data-toggle="refresh">
														<i class="fa fa-refresh"></i>
														${message("business.common.refresh")}
													</button>
													<div class="btn-group">
														<button class="btn btn-default dropdown-toggle" type="button" data-toggle="dropdown">
															${message("business.productNotify.filter")}
															<span class="caret"></span>
														</button>
														<ul class="dropdown-menu">
															<li[#if isMarketable] class="active"[/#if] data-filter-property="isMarketable" data-filter-value="true">
																<a href="javascript:;">${message("business.productNotify.marketable")}</a>
															</li>
															<li[#if isMarketable?? && !isMarketable] class="active"[/#if] data-filter-property="isMarketable" data-filter-value="false">
																<a href="javascript:;">${message("business.productNotify.notMarketable")}</a>
															</li>
															<li class="divider"></li>
															<li[#if isOutOfStock] class="active"[/#if] data-filter-property="isOutOfStock" data-filter-value="true">
																<a href="javascript:;">${message("business.productNotify.outOfStock")}</a>
															</li>
															<li[#if isOutOfStock?? && !isOutOfStock] class="active"[/#if] data-filter-property="isOutOfStock" data-filter-value="false">
																<a href="javascript:;">${message("business.productNotify.inStock")}</a>
															</li>
															<li class="divider"></li>
															<li[#if hasSent] class="active"[/#if] data-filter-property="hasSent" data-filter-value="true">
																<a href="javascript:;">${message("business.productNotify.hasSent")}</a>
															</li>
															<li[#if hasSent?? && !hasSent] class="active"[/#if] data-filter-property="hasSent" data-filter-value="false">
																<a href="javascript:;">${message("business.productNotify.hasNotSent")}</a>
															</li>
														</ul>
													</div>
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
																	[#case "sku.product.name"]
																		<span>${message("business.productNotify.sku")}</span>
																	[#break]
																	[#case "member.username"]
																		<span>${message("ProductNotify.member")}</span>
																	[#break]
																	[#default]
																		<span>${message("ProductNotify.email")}</span>
																[/#switch]
																<i class="caret"></i>
															</button>
															<ul class="dropdown-menu">
																<li[#if !page.searchProperty?? || page.searchProperty == "email"] class="active"[/#if] data-search-property="email">
																	<a href="javascript:;">${message("ProductNotify.email")}</a>
																</li>
																<li[#if page.searchProperty == "sku.product.name"] class="active"[/#if] data-search-property="sku.product.name">
																	<a href="javascript:;">${message("business.productNotify.sku")}</a>
																</li>
																<li[#if page.searchProperty == "member.username"] class="active"[/#if] data-search-property="member.username">
																	<a href="javascript:;">${message("ProductNotify.member")}</a>
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
														<a href="javascript:;" data-order-property="sku">
															${message("business.productNotify.skuName")}
															<i class="fa fa-sort"></i>
														</a>
													</th>
													<th>
														<a href="javascript:;" data-order-property="member">
															${message("ProductNotify.member")}
															<i class="fa fa-sort"></i>
														</a>
													</th>
													<th>
														<a href="javascript:;" data-order-property="email">
															${message("ProductNotify.email")}
															<i class="fa fa-sort"></i>
														</a>
													</th>
													<th>
														<a href="javascript:;" data-order-property="createdDate">
															${message("business.productNotify.createdDate")}
															<i class="fa fa-sort"></i>
														</a>
													</th>
													<th>
														<a href="javascript:;" data-order-property="lastModifiedDate">
															${message("business.productNotify.notifyDate")}
															<i class="fa fa-sort"></i>
														</a>
													</th>
													<th>${message("business.productNotify.status")}</th>
													<th>
														<a href="javascript:;" data-order-property="hasSent">
															${message("business.productNotify.hasSent")}
															<i class="fa fa-sort"></i>
														</a>
													</th>
												</tr>
											</thead>
											<tbody>
												[#list page.content as productNotify]
													<tr>
														<td>
															<input name="ids" type="checkbox" value="${productNotify.id}">
														</td>
														<td>
															<a href="${base}${productNotify.sku.path}" title="${productNotify.sku.name}" target="_blank">${abbreviate(productNotify.sku.name, 50, "...")}</a>
															[#if productNotify.sku.specifications?has_content]
																<span class="gray-darker">[${productNotify.sku.specifications?join(", ")}]</span>
															[/#if]
														</td>
														<td>
															[#if productNotify.member??]
																${productNotify.member.username}
															[#else]
																-
															[/#if]
														</td>
														<td>${productNotify.email}</td>
														<td>
															<span title="${productNotify.createdDate?string("yyyy-MM-dd HH:mm:ss")}">${productNotify.createdDate}</span>
														</td>
														<td>
															[#if productNotify.hasSent]
																<span title="${productNotify.lastModifiedDate?string("yyyy-MM-dd HH:mm:ss")}">${productNotify.lastModifiedDate}</span>
															[#else]
																-
															[/#if]
														</td>
														<td>
															[#if productNotify.sku.isMarketable]
																<span class="green">${message("business.productNotify.marketable")}</span>
															[#else]
																${message("business.productNotify.notMarketable")}
															[/#if]
															[#if productNotify.sku.isOutOfStock]
																${message("business.productNotify.outOfStock")}
															[#else]
																<span class="green">${message("business.productNotify.inStock")}</span>
															[/#if]
														</td>
														<td>
															[#if productNotify.hasSent?has_content]
																<i class="fa fa-check"></i>
															[#else]
																<i class="fa fa-times"></i>
															[/#if]
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