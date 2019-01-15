<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("business.product.list")} </title>
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
		
		var $delete = $("#delete");
		var $shelves = $("#shelves");
		var $shelf = $("#shelf");
		var $checkAll = $("[data-toggle='checkAll']");
		var $ids = $("input[name='ids']");
		
		[#if flashMessage?has_content]
			$.alert("${flashMessage}");
		[/#if]
		
		// 删除
		$delete.deleteItem({
			url: "${base}/business/product/delete",
			data: function() {
				return $ids.serialize();
			},
			removeElement: function() {
				return $ids.filter(":checked").closest("tr");
			},
			complete: function() {
				$ids = $("input[name='ids']");
				$delete.add($shelves).add($shelf).attr("disabled", true);
				$checkAll.checkAll("uncheck");
				if ($ids.size() < 1) {
					setTimeout(function() {
						location.reload(true);
					}, 3000);
				}
			}
		});
		
		// 上架
		$shelves.click(function() {
			if (confirm("${message("business.product.shelvesConfirm")}")) {
				$.post("${base}/business/product/shelves", $ids.serialize(), function() {
					setTimeout(function() {
						location.reload(true);
					}, 3000);
				});
			}
		});
		
		// 下架
		$shelf.click(function() {
			if (confirm("${message("business.product.shelfConfirm")}")) {
				$.post("${base}/business/product/shelf", $ids.serialize(), function() {
					setTimeout(function() {
						location.reload(true);
					}, 3000);
				});
			}
		});
		
		// ID多选框
		$ids.on("ifChanged", function() {
			$delete.add($shelves).add($shelf).attr("disabled", $ids.filter(":checked").size() < 1);
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
					<h1>${message("business.product.list")}</h1>
					<ol class="breadcrumb">
						<li>
							<a href="/shop/business/index">
								<i class="fa fa-home"></i>
								${message("business.common.index")}
							</a>
						</li>
						<li class="active">${message("business.product.list")}</li>
					</ol>
				</section>
				<section class="content">
					<div class="row">
						<div class="col-xs-12">
							<form action="${base}/business/product/list" method="get">
								<input name="pageSize" type="hidden" value="${page.pageSize}">
								<input name="pageNumber" type="hidden" value="${page.pageNumber}">
								<input name="searchProperty" type="hidden" value="${page.searchProperty}">
								<input name="orderProperty" type="hidden" value="${page.orderProperty}">
								<input name="orderDirection" type="hidden" value="${page.orderDirection}">
								<input name="isActive" type="hidden" value="[#if isActive??]${isActive?string("true", "false")}[/#if]">
								<input name="isMarketable" type="hidden" value="[#if isMarketable??]${isMarketable?string("true", "false")}[/#if]">
								<input name="isList" type="hidden" value="[#if isList??]${isList?string("true", "false")}[/#if]">
								<input name="isTop" type="hidden" value="[#if isTop??]${isTop?string("true", "false")}[/#if]">
								<input name="isOutOfStock" type="hidden" value="[#if isOutOfStock??]${isOutOfStock?string("true", "false")}[/#if]">
								<input name="isStockAlert" type="hidden" value="[#if isStockAlert??]${isStockAlert?string("true", "false")}[/#if]">
								<div id="filterModal" class="modal fade" tabindex="-1">
									<div class="modal-dialog">
										<div class="modal-content">
											<div class="modal-header">
												<button class="close" type="button" data-dismiss="modal">&times;</button>
												<h4 class="modal-title">${message("business.common.moreOption")}</h4>
											</div>
											<div class="modal-body form-horizontal">
												<div class="form-group">
													<label class="col-xs-3 control-label">${message("Product.productCategory")}:</label>
													<div class="col-xs-7">
														<select name="productCategoryId" class="selectpicker form-control" data-live-search="true" data-size="10">
															<option value="">${message("business.common.choose")}</option>
															[#list productCategoryTree as productCategory]
																[#if allowedProductCategories?seq_contains(productCategory) || allowedProductCategoryParents?seq_contains(productCategory)]
																	<option value="${productCategory.id}" title="${productCategory.name}"[#if productCategory.id == productCategoryId] selected[/#if][#if !allowedProductCategories?seq_contains(productCategory)] disabled[/#if]>
																		[#if productCategory.grade != 0]
																			[#list 1..productCategory.grade as i]
																				&nbsp;&nbsp;
																			[/#list]
																		[/#if]
																		${productCategory.name}
																	</option>
																[/#if]
															[/#list]
														</select>
													</div>
												</div>
												<div class="form-group">
													<label class="col-xs-3 control-label">${message("Product.type")}:</label>
													<div class="col-xs-7">
														<select name="type" class="selectpicker form-control" data-live-search="true" data-size="10">
															<option value="">${message("business.common.choose")}</option>
															[#list types as item]
																<option value="${item}"[#if item == type] selected[/#if]>${message("Product.Type." + item)}</option>
															[/#list]
														</select>
													</div>
												</div>
												<div class="form-group">
													<label class="col-xs-3 control-label">${message("Product.brand")}:</label>
													<div class="col-xs-7">
														<select name="brandId" class="selectpicker form-control" data-live-search="true" data-size="10">
															<option value="">${message("business.common.choose")}</option>
															[#list brands as brand]
																<option value="${brand.id}"[#if brand.id == brandId] selected[/#if]>${brand.name}</option>
															[/#list]
														</select>
													</div>
												</div>
												<div class="form-group">
													<label class="col-xs-3 control-label">${message("Product.productTags")}:</label>
													<div class="col-xs-7">
														<select name="productTagId" class="selectpicker form-control" data-live-search="true" data-size="10">
															<option value="">${message("business.common.choose")}</option>
															[#list productTags as productTag]
																<option value="${productTag.id}"[#if productTag.id == productTagId] selected[/#if]>${productTag.name}</option>
															[/#list]
														</select>
													</div>
												</div>
												<div class="form-group">
													<label class="col-xs-3 control-label">${message("Product.storeProductTags")}:</label>
													<div class="col-xs-7">
														<select name="storeProductTagId" class="selectpicker form-control" data-live-search="true" data-size="10">
															<option value="">${message("business.common.choose")}</option>
															[#list storeProductTags as storeProductTag]
																<option value="${storeProductTag.id}"[#if storeProductTag.id == storeProductTagId] selected[/#if]>${storeProductTag.name}</option>
															[/#list]
														</select>
													</div>
												</div>
												<div class="form-group">
													<label class="col-xs-3 control-label">${message("Product.promotions")}:</label>
													<div class="col-xs-7">
														<select name="promotionId" class="selectpicker form-control" data-live-search="true" data-size="10">
															<option value="">${message("business.common.choose")}</option>
															[#list promotions as promotion]
																<option value="${promotion.id}"[#if promotion.id == promotionId] selected[/#if]>${promotion.name}</option>
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
													<a class="btn btn-default" href="${base}/business/product/add">
														<i class="fa fa-plus"></i>
														${message("business.common.add")}
													</a>
													<button id="delete" class="btn btn-default" type="button" disabled>
														<i class="fa fa-times"></i>
														${message("business.common.delete")}
													</button>
													<button class="btn btn-default" type="button" data-toggle="refresh">
														<i class="fa fa-refresh"></i>
														${message("business.common.refresh")}
													</button>
													<button id="shelves" class="btn btn-default" type="button" disabled>
														<i class="fa fa-chevron-up"></i>
														${message("business.product.shelves")}
													</button>
													<button id="shelf" class="btn btn-default" type="button" disabled>
														<i class="fa fa-chevron-down"></i>
														${message("business.product.shelf")}
													</button>
													<div class="btn-group">
														<button class="btn btn-default dropdown-toggle" type="button" data-toggle="dropdown">
															${message("business.product.filter")}
															<span class="caret"></span>
														</button>
														<ul class="dropdown-menu">
															<li[#if isActive?? && isActive] class="active"[/#if] data-filter-property="isActive" data-filter-value="true">
																<a href="javascript:;">${message("business.product.isActive")}</a>
															</li>
															<li[#if isActive?? && !isActive] class="active"[/#if] data-filter-property="isActive" data-filter-value="false">
																<a href="javascript:;">${message("business.product.notActive")}</a>
															</li>
															<li class="divider"></li>
															<li[#if isMarketable?? && isMarketable] class="active"[/#if] data-filter-property="isMarketable" data-filter-value="true">
																<a href="javascript:;">${message("business.product.isMarketable")}</a>
															</li>
															<li[#if isMarketable?? && !isMarketable] class="active"[/#if] data-filter-property="isMarketable" data-filter-value="false">
																<a href="javascript:;">${message("business.product.notMarketable")}</a>
															</li>
															<li class="divider"></li>
															<li[#if isList?? && isList] class="active"[/#if] data-filter-property="isList" data-filter-value="true">
																<a href="javascript:;">${message("business.product.isList")}</a>
															</li>
															<li[#if isList?? && !isList] class="active"[/#if] data-filter-property="isList" data-filter-value="false">
																<a href="javascript:;">${message("business.product.notList")}</a>
															</li>
															<li class="divider"></li>
															<li[#if isTop?? && isTop] class="active"[/#if] data-filter-property="isTop" data-filter-value="true">
																<a href="javascript:;">${message("business.product.isTop")}</a>
															</li>
															<li[#if isTop?? && !isTop] class="active"[/#if] data-filter-property="isTop" data-filter-value="false">
																<a href="javascript:;">${message("business.product.notTop")}</a>
															</li>
															<li class="divider"></li>
															<li[#if isOutOfStock?? && !isOutOfStock] class="active"[/#if] data-filter-property="isOutOfStock" data-filter-value="false">
																<a href="javascript:;">${message("business.product.isStack")}</a>
															</li>
															<li[#if isOutOfStock?? && isOutOfStock] class="active"[/#if] data-filter-property="isOutOfStock" data-filter-value="true">
																<a href="javascript:;">${message("business.product.isOutOfStack")}</a>
															</li>
															<li class="divider"></li>
															<li[#if isStockAlert?? && !isStockAlert] class="active"[/#if] data-filter-property="isStockAlert" data-filter-value="false">
																<a href="javascript:;">${message("business.product.normalStore")}</a>
															</li>
															<li[#if isStockAlert?? && isStockAlert] class="active"[/#if] data-filter-property="isStockAlert" data-filter-value="true">
																<a href="javascript:;">${message("business.product.isStockAlert")}</a>
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
																	[#case "name"]
																		<span>${message("Product.name")}</span>
																		[#break]
																	[#case "productCategory.name"]
																		<span>${message("Product.productCategory")}</span>
																		[#break]
																	[#default]
																		<span>${message("Product.sn")}</span>
																[/#switch]
																<i class="caret"></i>
															</button>
															<ul class="dropdown-menu">
																<li[#if !page.searchProperty?? || page.searchProperty == "sn"] class="active"[/#if] data-search-property="sn">
																	<a href="javascript:;">${message("Product.sn")}</a>
																</li>
																<li[#if page.searchProperty == "name"] class="active"[/#if] data-search-property="name">
																	<a href="javascript:;">${message("Product.name")}</a>
																</li>
																<li[#if page.searchProperty == "productCategory.name"] class="active"[/#if] data-search-property="productCategory.name">
																	<a href="javascript:;">${message("Product.productCategory")}</a>
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
															${message("Product.sn")}
															<i class="fa fa-sort"></i>
														</a>
													</th>
													<th>
														<a href="javascript:;" data-order-property="name">
															${message("Product.name")}
															<i class="fa fa-sort"></i>
														</a>
													</th>
													<th>
														<a href="javascript:;" data-order-property="productCategory">
															${message("Product.productCategory")}
															<i class="fa fa-sort"></i>
														</a>
													</th>
													<th>
														<a href="javascript:;" data-order-property="price">
															${message("Product.price")}
															<i class="fa fa-sort"></i>
														</a>
													</th>
													<th>
														<a href="javascript:;" data-order-property="isMarketable">
															${message("Product.isMarketable")}
															<i class="fa fa-sort"></i>
														</a>
													</th>
													<th>
														<a href="javascript:;" data-order-property="isActive">
															${message("Product.isActive")}
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
												[#list page.content as product]
													<tr>
														<td>
															<input name="ids" type="checkbox" value="${product.id}">
														</td>
														<td>
															<span class="[#if product.isOutOfStock] red[#elseif product.isStockAlert] blue[/#if]">${product.sn}</span>
														</td>
														<td>
															<span title="${product.name}">${abbreviate(product.name, 50, "...")}</span>
															[#if product.type != "general"]
																<span class="red">*</span>
															[/#if]
															[#list product.validPromotions as promotion]
																<span class="promotion orange" title="${promotion.title}">${promotion.name}</span>
															[/#list]
														</td>
														<td>${product.productCategory.name}</td>
														<td>${currency(product.price, true)}</td>
														<td>
															[#if product.isMarketable]
																<i class="fa fa-check"></i>
															[#else]
																<i class="fa fa-times"></i>
															[/#if]
														</td>
														<td>
															[#if product.isActive]
																<i class="fa fa-check"></i>
															[#else]
																<i class="fa fa-times"></i>
															[/#if]
														</td>
														<td>
															<span title="${product.createdDate?string("yyyy-MM-dd HH:mm:ss")}">${product.createdDate}</span>
														</td>
														<td>
															<a href="${base}/business/product/edit?productId=${product.id}">[${message("business.common.edit")}]</a>
															[#if product.isMarketable && product.isActive]
																<a href="${base}${product.path}" target="_blank">[${message("business.common.view")}]</a>
															[#else]
																<span title="${message("business.product.notMarketable")}">[${message("business.common.view")}]</span>
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