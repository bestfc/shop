<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("business.storeProductCategory.list")} </title>
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
	
		var $delete = $("#storeProductCategoryForm a.delete");
		
		[#if flashMessage?has_content]
			$.alert("${flashMessage}");
		[/#if]
		
		// 删除
		$delete.deleteItem({
			url: "${base}/business/store_product_category/delete",
			data: function() {
				return {
					storeProductCategoryId: $(this).data("id")
				};
			},
			removeElement: function() {
				return $(this).closest("tr");
			},
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
					<h1>${message("business.storeProductCategory.list")}</h1>
					<ol class="breadcrumb">
						<li>
							<a href="/shop/business/index">
								<i class="fa fa-home"></i>
								${message("business.common.index")}
							</a>
						</li>
						<li class="active">${message("business.storeProductCategory.list")}</li>
					</ol>
				</section>
				<section class="content">
					<div class="row">
						<div class="col-xs-12">
							<form id="storeProductCategoryForm" action="${base}/business/store_product_category/list" method="get">
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
													<a class="btn btn-default" href="${base}/business/store_product_category/add">
														<i class="fa fa-plus"></i>
														${message("business.common.add")}
													</a>
													<button class="btn btn-default" type="button" data-toggle="refresh">
														<i class="fa fa-refresh"></i>
														${message("business.common.refresh")}
													</button>
												</div>
											</div>
										</div>
									</div>
									<div class="box-body table-responsive no-padding">
										<table class="table table-hover">
											<thead>
												<tr>
													<th>${message("StoreProductCategory.name")}</th>
													<th>${message("business.common.order")}</th>
													<th>${message("business.common.action")}</th>
												</tr>
											</thead>
											<tbody>
												[#list storeProductCategoryTree as storeProductCategory]
													<tr>
														<td>
															<span style="margin-left: ${storeProductCategory.grade * 20}px;[#if storeProductCategory.grade == 0] color: #000000;[/#if]">${storeProductCategory.name}</span>
														</td>
														<td>${storeProductCategory.order}</td>
														<td>
															<a href="${base}${storeProductCategory.path}" target="_blank">[${message("business.common.view")}]</a>
															<a href="${base}/business/store_product_category/edit?storeProductCategoryId=${storeProductCategory.id}">[${message("business.common.edit")}]</a>
															<a class="delete" href="javascript:;" data-id="${storeProductCategory.id}">[${message("business.common.delete")}]</a>
														</td>
													</tr>
												[/#list]
											</tbody>
										</table>
										[#if !storeProductCategoryTree?has_content]
											<p class="no-result">${message("business.common.noResult")}</p>
										[/#if]
									</div>
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