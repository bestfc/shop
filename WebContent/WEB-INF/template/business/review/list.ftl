<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("business.review.list")} </title>
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
</head>
<body class="hold-transition sidebar-mini">
	<div class="wrapper">
		[#include "/business/include/main_header.ftl" /]
		[#include "/business/include/main_sidebar.ftl" /]
		<div class="content-wrapper">
			<div class="container-fluid">
				<section class="content-header">
					<h1>${message("business.review.list")}</h1>
					<ol class="breadcrumb">
						<li>
							<a href="/shop/business/index">
								<i class="fa fa-home"></i>
								${message("business.common.index")}
							</a>
						</li>
						<li class="active">${message("business.review.list")}</li>
					</ol>
				</section>
				<section class="content">
					<div class="row">
						<div class="col-xs-12">
							<form action="${base}/business/review/list" method="get">
								<input name="pageSize" type="hidden" value="${page.pageSize}">
								<input name="pageNumber" type="hidden" value="${page.pageNumber}">
								<input name="searchProperty" type="hidden" value="${page.searchProperty}">
								<input name="orderProperty" type="hidden" value="${page.orderProperty}">
								<input name="orderDirection" type="hidden" value="${page.orderDirection}">
								<input name="type" type="hidden" value="${type}">
								<div class="box">
									<div class="box-header">
										<div class="row">
											<div class="col-xs-9">
												<div class="btn-group">
													<button class="btn btn-default" type="button" data-toggle="refresh">
														<i class="fa fa-refresh"></i>
														${message("business.common.refresh")}
													</button>
													<div class="btn-group">
														<button class="btn btn-default dropdown-toggle" type="button" data-toggle="dropdown">
															[#if type??]
																${message("Review.Type." + type)}
															[#else]
																${message("business.review.allType")}
															[/#if]
															<span class="caret"></span>
														</button>
														<ul class="dropdown-menu">
															<li[#if !type??] class="active"[/#if] data-filter-property="type">
																<a href="javascript:;">${message("business.review.allType")}</a>
															</li>
															[#list types as item]
																<li[#if item == type] class="active"[/#if] data-filter-property="type" data-filter-value="${item}">
																	<a href="javascript:;">${message("Review.Type." + item)}</a>
																</li>
															[/#list]
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
																	[#case "product.name"]
																		<span>${message("Review.product")}</span>
																		[#break]
																	[#case "member.username"]
																		<span>${message("Review.member")}</span>
																	[#break]
																	[#default]
																		<span>${message("Review.content")}</span>
																[/#switch]
																<i class="caret"></i>
															</button>
															<ul class="dropdown-menu">
																<li[#if !page.searchProperty?? || page.searchProperty == "content"] class="active"[/#if] data-search-property="content">
																	<a href="javascript:;">${message("Review.content")}</a>
																</li>
																<li[#if page.searchProperty == "product.name"] class="active"[/#if] data-search-property="product.name">
																	<a href="javascript:;">${message("Review.product")}</a>
																</li>
																<li[#if page.searchProperty == "member.username"] class="active"[/#if] data-search-property="member.username">
																	<a href="javascript:;">${message("Review.member")}</a>
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
														<a href="javascript:;" data-order-property="product">
															${message("Review.product")}
															<i class="fa fa-sort"></i>
														</a>
													</th>
													<th>
														<a href="javascript:;" data-order-property="score">
															${message("Review.score")}
															<i class="fa fa-sort"></i>
														</a>
													</th>
													<th>
														<a href="javascript:;" data-order-property="content">
															${message("Review.content")}
															<i class="fa fa-sort"></i>
														</a>
													</th>
													<th>
														<a href="javascript:;" data-order-property="member">
															${message("Review.member")}
															<i class="fa fa-sort"></i>
														</a>
													</th>
													<th>
														<a href="javascript:;" data-order-property="isShow">
															${message("Review.isShow")}
															<i class="fa fa-sort"></i>
														</a>
													</th>
													<th>${message("business.review.isReply")}</th>
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
												[#list page.content as review]
													<tr>
														<td>
															<a href="${base}${review.product.path}" title="${review.product.name}" target="_blank">${abbreviate(review.product.name, 50, "...")}</a>
														</td>
														<td>${review.score}</td>
														<td>
															<span title="${review.content}">${abbreviate(review.content, 50, "...")}</span>
														</td>
														<td>
															[#if review.member??]
																${review.member.username}
															[#else]
																${message("business.review.anonymous")}
															[/#if]
														</td>
														<td>
															[#if review.isShow]
																<i class="fa fa-check"></i>
															[#else]
																<i class="fa fa-times"></i>
															[/#if]
														</td>
														<td>
															[#if review.replyReviews?has_content]
																<i class="fa fa-check"></i>
															[#else]
																<i class="fa fa-times"></i>
															[/#if]
														</td>
														<td>
															<span title="${review.createdDate?string("yyyy-MM-dd HH:mm:ss")}">${review.createdDate}</span>
														</td>
														<td>
															<a href="${base}/business/review/reply?reviewId=${review.id}">[${message("business.review.reply")}]</a>
															<a href="${base}/business/review/edit?reviewId=${review.id}">[${message("business.common.edit")}]</a>
															<a href="${base}${review.path}" target="_blank">[${message("business.common.view")}]</a>
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