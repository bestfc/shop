<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("business.fullReductionPromotion.list")} </title>
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
		
		[#if flashMessage?has_content]
			$.alert("${flashMessage}");
		[/#if]
		
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
					<h1>${message("business.fullReductionPromotion.list")}</h1>
					<ol class="breadcrumb">
						<li>
							<a href="/shop/business/index">
								<i class="fa fa-home"></i>
								${message("business.common.index")}
							</a>
						</li>
						<li class="active">${message("business.fullReductionPromotion.list")}</li>
					</ol>
				</section>
				<section class="content">
					<div class="row">
						<div class="col-xs-12">
							<form action="${base}/business/full_reduction_promotion/list" method="get">
								<input name="pageSize" type="hidden" value="${page.pageSize}">
								<input name="pageNumber" type="hidden" value="${page.pageNumber}">
								<input name="searchProperty" type="hidden" value="${page.searchProperty}">
								<input name="orderProperty" type="hidden" value="${page.orderProperty}">
								<input name="orderDirection" type="hidden" value="${page.orderDirection}">
								<div class="box">
									<div class="box-header">
										<div class="row">
											<div class="col-xs-9">
												<div class="btn-group">
													<a class="btn btn-default" href="${base}/business/full_reduction_promotion/add">
														<i class="fa fa-plus"></i>
														${message("business.common.add")}
													</a>
													<button class="btn btn-default" type="button" data-toggle="delete" disabled>
														<i class="fa fa-times"></i>
														${message("business.common.delete")}
													</button>
													[#if !currentStore.isSelf()]
														<a class="btn btn-default" href="${base}/business/full_reduction_promotion/buy">
															<i class="fa fa-shopping-cart"></i>
															${message("business.fullReductionPromotion.buy")}
														</a>
													[/#if]
													<button class="btn btn-default" type="button" data-toggle="refresh">
														<i class="fa fa-refresh"></i>
														${message("business.common.refresh")}
													</button>
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
																	[#case "title"]
																		<span>${message("Promotion.title")}</span>
																	[#break]
																	[#default]
																		<span>${message("Promotion.name")}</span>
																[/#switch]
																<i class="caret"></i>
															</button>
															<ul class="dropdown-menu">
																<li[#if !page.searchProperty?? || page.searchProperty == "name"] class="active"[/#if] data-search-property="name">
																	<a href="javascript:;">${message("Promotion.name")}</a>
																</li>
																<li[#if page.searchProperty == "title"] class="active"[/#if] data-search-property="title">
																	<a href="javascript:;">${message("Promotion.title")}</a>
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
														<a href="javascript:;" data-order-property="name">
															${message("Promotion.name")}
															<i class="fa fa-sort"></i>
														</a>
													</th>
													<th>
														<a href="javascript:;" data-order-property="title">
															${message("Promotion.title")}
															<i class="fa fa-sort"></i>
														</a>
													</th>
													<th>
														<a href="javascript:;" data-order-property="beginDate">
															${message("Promotion.beginDate")}
															<i class="fa fa-sort"></i>
														</a>
													</th>
													<th>
														<a href="javascript:;" data-order-property="endDate">
															${message("Promotion.endDate")}
															<i class="fa fa-sort"></i>
														</a>
													</th>
													<th>
														<a href="javascript:;" data-order-property="isEnabled">
															${message("Promotion.isEnabled")}
															<i class="fa fa-sort"></i>
														</a>
													</th>
													<th>${message("business.common.action")}</th>
												</tr>
											</thead>
											<tbody>
												[#list page.content as promotion]
													<tr>
														<td>
															<input name="ids" type="checkbox" value="${promotion.id}">
														</td>
														<td>
															<span title="${promotion.name}">${abbreviate(promotion.name, 50, "...")}</span>
														</td>
														<td>
															<span title="${promotion.title}">${abbreviate(promotion.title, 50, "...")}</span>
														</td>
														<td>
															[#if promotion.beginDate??]
																<span title="${promotion.beginDate?string("yyyy-MM-dd HH:mm:ss")}">${promotion.beginDate}</span>
															[#else]
																-
															[/#if]
														</td>
														<td>
															[#if promotion.endDate??]
																<span title="${promotion.endDate?string("yyyy-MM-dd HH:mm:ss")}">${promotion.endDate}</span>
															[#else]
																-
															[/#if]
														</td>
														<td>
															[#if promotion.isEnabled]
																<i class="fa fa-check"></i>
															[#else]
																<i class="fa fa-times"></i>
															[/#if]
														</td>
														<td>
															<a href="${base}/business/full_reduction_promotion/edit?promotionId=${promotion.id}">[${message("business.common.edit")}]</a>
															<a href="${base}${promotion.path}" target="_blank">[${message("business.common.view")}]</a>
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