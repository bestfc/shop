<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("business.store.reapply")} </title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/business/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/business/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/business/css/bootstrap-select.css" rel="stylesheet">
	<link href="${base}/resources/business/css/animate.css" rel="stylesheet">
	<link href="${base}/resources/business/css/summernote.css" rel="stylesheet">
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
	<script src="${base}/resources/business/js/summernote.js"></script>
	<script src="${base}/resources/business/js/jquery.validate.js"></script>
	<script src="${base}/resources/business/js/adminLTE.js"></script>
	<script src="${base}/resources/business/js/underscore.js"></script>
	<script src="${base}/resources/business/js/common.js"></script>
	<script type="text/javascript">
	$().ready(function() {
		
		var $mainHeaderNav = $("header.main-header a").not("a.logout");
		var $mainSidebarNav = $("aside.main-sidebar a, aside.main-sidebar button");
		var $storeForm = $("#storeForm");
		var $name = $("#name");
		var $storeRank = $("select[name='storeRankId']");
		var $storeRankQuantitySelected = $storeRank.find(":selected").data("store-rank-quantity");
		var $storeRankServiceFeeSelected = $storeRank.find(":selected").data("store-rank-service-fee");
		var $storeRankQuantity = $("#storeRankQuantity");
		var $storeRankServiceFee = $("#storeRankServiceFee");
		var $storeCategory = $("select[name='storeCategoryId']");
		var $storeCategoryBail = $("#storeCategoryBail");
		var $storeCategoryBailSelected = $storeCategory.find(":selected").data("store-category-bail");
		var $browserButton = $("a.browserButton");
		var $submit = $("button[type='submit']");
		
		// 主顶部导航
		$mainHeaderNav.click(function() {
			return false;
		});
		
		// 主侧边导航
		$mainSidebarNav.click(function() {
			return false;
		});
		
		// 店铺等级
		$storeRankQuantity.text($storeRankQuantitySelected);
		$storeRankServiceFee.text(currency($storeRankServiceFeeSelected, true));
		$storeRank.change(function() {
			var $element = $(this);
			var storeRankQuantity = $element.find(":selected").data("store-rank-quantity");
			var storeRankServiceFee = $element.find(":selected").data("store-rank-service-fee");
			$storeRankQuantity.velocity("fadeIn").text(storeRankQuantity);
			$storeRankServiceFee.velocity("fadeIn").text(currency(storeRankServiceFee, true));
		});
		
		// 店铺分类
		$storeCategoryBail.text(currency($storeCategoryBailSelected, true));
		$storeCategory.change(function() {
			var $element = $(this);
			var storeCategoryBail = $element.find(":selected").data("store-category-bail");
			$storeCategoryBail.velocity("fadeIn").text(currency(storeCategoryBail, true));
		});
		
		// 表单验证
		$storeForm.validate({
			rules: {
				name: {
					required: true,
					remote: {
						url: "${base}/business/store/check_name",
						data: {
							id: ${currentStore.id}
						},
						cache: false
					}
				},
				mobile: {
					required: true,
					pattern: /^1[3|4|5|7|8]\d{9}$/
				},
				email: {
					required: true,
					email: true
				}
				[@business_attribute_list]
					[#list businessAttributes as businessAttribute]
						[#if businessAttribute.isRequired || businessAttribute.pattern?has_content]
							,businessAttribute_${businessAttribute.id}: {
								[#if businessAttribute.isRequired]
									required: true
									[#if businessAttribute.pattern?has_content],[/#if]
								[/#if]
								[#if businessAttribute.pattern?has_content]
									pattern: /${businessAttribute.pattern}/
								[/#if]
							}
						[/#if]
					[/#list]
				[/@business_attribute_list]
			},
			messages: {
				name: {
					remote: "${message("common.validate.exist")}"
				},
				mobile: {
					pattern: "${message("common.validate.pattern")}",
					remote: "${message("common.validate.exist")}"
				},
				email: {
					remote: "${message("common.validate.exist")}"
				}
			},
			submitHandler: function(form) {
				$.ajax({
					url: $storeForm.attr("action"),
					type: "POST",
					data: $storeForm.serializeArray(),
					dataType: "json",
					cache: false,
					success: function() {
						setTimeout(function() {
							$submit.prop("disabled", false);
							location.href = "/shop/business/index";
						}, 2000);
					}
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
					<h1>${message("business.store.reapply")}</h1>
				</section>
				<section class="content">
					<div class="row">
						<div class="col-xs-12">
							<form id="storeForm" class="form-horizontal" action="${base}/business/store/reapply" method="post">
								<input name="id" type="hidden" value="${currentStore.id}">
								<div class="box">
									<div class="box-body">
										<ul class="nav nav-tabs">
											<li class="active">
												<a href="#info" data-toggle="tab">${message("business.store.info")}</a>
											</li>
											<li>
												<a href="#productCategories" data-toggle="tab">${message("Store.productCategories")}</a>
											</li>
										</ul>
										<div class="tab-content">
											<div id="info" class="tab-pane active">
												<div class="form-group">
													<label class="col-xs-2 control-label item-required" for="name">${message("Store.name")}:</label>
													<div class="col-xs-4">
														<input id="name" name="name" class="form-control" type="text" value="${currentStore.name}" maxlength="200">
													</div>
												</div>
												<div class="form-group[#if !storeRanks??] hidden-element[/#if]">
													<label class="col-xs-2 control-label">${message("Store.storeRank")}:</label>
													<div class="col-xs-4">
														<select name="storeRankId" class="selectpicker form-control" data-size="5">
															[#list storeRanks as storeRank]
																[#if storeRank.isAllowRegister]
																	<option value="${storeRank.id}" data-store-rank-quantity="${(storeRank.quantity)!'${message("business.store.infiniteQuantity")}'}" data-store-rank-service-fee="${storeRank.serviceFee}"[#if storeRank == currentStore.storeRank] selected[/#if]>${storeRank.name}</option>
																[/#if]
															[/#list]
														</select>
													</div>
												</div>
												<div class="form-group">
													<label class="col-xs-2 control-label">${message("StoreRank.quantity")}:</label>
													<div class="col-xs-4">
														<p id="storeRankQuantity" class="form-control-static"></p>
													</div>
												</div>
												<div class="form-group">
													<label class="col-xs-2 control-label">${message("StoreRank.serviceFee")}:</label>
													<div class="col-xs-4">
														<p id="storeRankServiceFee" class="form-control-static text-red"></p>
													</div>
												</div>
												<div class="form-group[#if !storeCategories??] hidden-element[/#if]">
													<label class="col-xs-2 control-label">${message("Store.storeCategory")}:</label>
													<div class="col-xs-4">
														<select name="storeCategoryId" class="selectpicker form-control" data-size="5">
															[#list storeCategories as storeCategory]
																<option value="${storeCategory.id}" data-store-category-bail="${storeCategory.bail}"[#if currentStore.storeCategory.id == storeCategory.id] selected[/#if]>${storeCategory.name}</option>
															[/#list]
														</select>
													</div>
												</div>
												<div class="form-group">
													<label class="col-xs-2 control-label">${message("StoreCategory.bail")}:</label>
													<div class="col-xs-4">
														<p id="storeCategoryBail" class="form-control-static text-red"></p>
													</div>
												</div>
												<div class="form-group">
													<label class="col-xs-2 control-label item-required" for="mobile">${message("Store.mobile")}:</label>
													<div class="col-xs-4">
														<input id="mobile" name="mobile" class="form-control" type="text" value="${currentStore.mobile}" maxlength="16">
													</div>
												</div>
												<div class="form-group">
													<label class="col-xs-2 control-label item-required" for="email">${message("Store.email")}:</label>
													<div class="col-xs-4">
														<input id="email" name="email" class="form-control" type="text" value="${currentStore.email}" maxlength="200">
													</div>
												</div>
											</div>
											<div id="productCategories" class="tab-pane">
												<div class="form-group">
													<label class="col-xs-2 control-label">${message("Store.storeCategory")}:</label>
													<div class="col-xs-4">
														<select name="productCategoryIds" class="selectpicker form-control" data-none-selected-text="${message("business.common.choose")}" multiple>
															[#list productCategoryTree as productCategory]
																<option name="${productCategory.generalRate}" value="${productCategory.id}" title="${productCategory.name}"[#list currentStore.productCategories as currentProductCategory][#if currentProductCategory.id == productCategory.id] selected[/#if][/#list]>
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
											</div>
										</div>
									</div>
									<div class="box-footer">
										<div class="form-group">
											<div class="col-xs-4 col-xs-offset-2">
												<button class="btn btn-primary" type="submit">${message("business.store.submit")}</button>
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