<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("business.categoryApplication.add")} </title>
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
	<script src="${base}/resources/business/js/jquery.validate.js"></script>
	<script src="${base}/resources/business/js/adminLTE.js"></script>
	<script src="${base}/resources/business/js/common.js"></script>
	<script type="text/javascript">
	$().ready(function() {
		
		var $categoryApplicationForm = $("#categoryApplicationForm");
		var $productCategoryId = $("#productCategoryId");
		var $rate = $("#rate");
		
		// 商品分类
		$productCategoryId.change(function() {
			var $element = $(this);
			
			if($element.val() != "") {
				var rate = $element.find("option:selected").data("rate");
				
				$rate.text(rate);
				if ($rate.closest(".form-group").is(":hidden")) {
					$rate.closest(".form-group").velocity("slideDown");
				}
			}
		});
		
		// 表单验证
		$categoryApplicationForm.validate({
			rules: {
				productCategoryId: "required"
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
					<h1>${message("business.categoryApplication.add")}</h1>
					<ol class="breadcrumb">
						<li>
							<a href="/shop/business/index">
								<i class="fa fa-home"></i>
								${message("business.common.index")}
							</a>
						</li>
						<li class="active">${message("business.categoryApplication.add")}</li>
					</ol>
				</section>
				<section class="content">
					<div class="row">
						<div class="col-xs-12">
							<form id="categoryApplicationForm" class="form-horizontal" action="${base}/business/category_application/save" method="post">
								<div class="box">
									<div class="box-body">
										<div class="form-group">
											<label class="col-xs-2 control-label">${message("CategoryApplication.productCategory")}:</label>
											<div class="col-xs-4">
												<select id="productCategoryId" name="productCategoryId" class="selectpicker form-control" data-live-search="true" data-size="10">
													[#list productCategoryTree as productCategory]
														<option value="${productCategory.id}" title="${productCategory.name}" data-rate="[#if currentStore.isSelf()]${productCategory.selfRate}[#else]${productCategory.generalRate}[/#if]"[#if currentStore.productCategories?seq_contains(productCategory) || appliedProductCategories?seq_contains(productCategory)] disabled[/#if]>
															[#if productCategory.grade != 0]
																[#list 1..productCategory.grade as i]
																	&nbsp;&nbsp;
																[/#list]
															[/#if]
															${productCategory.name}
														</option>
													[/#list]
												</select>
											</div>
										</div>
										<div class="hidden-element form-group">
											<label class="col-xs-2 control-label">${message("CategoryApplication.rate")}:</label>
											<div class="col-xs-4">
												<p id="rate" class="form-control-static"></p>
											</div>
										</div>
									</div>
									<div class="box-footer">
										<div class="row">
											<div class="col-xs-4 col-xs-offset-2">
												<button class="btn btn-primary" type="submit">${message("business.common.submit")}</button>
												<button class="btn btn-default" type="button" data-toggle="back">${message("business.common.back")}</button>
											</div>
										</div>
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