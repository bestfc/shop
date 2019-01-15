<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("business.coupon.edit")} </title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/business/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/business/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/business/css/bootstrap-checkbox-x.css" rel="stylesheet">
	<link href="${base}/resources/business/css/animate.css" rel="stylesheet">
	<link href="${base}/resources/business/css/summernote.css" rel="stylesheet">
	<link href="${base}/resources/business/css/bootstrap-datetimepicker.css" rel="stylesheet">
	<link href="${base}/resources/business/css/adminLTE.css" rel="stylesheet">
	<link href="${base}/resources/business/css/common.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/business/js/html5shiv.js"></script>
		<script src="${base}/resources/business/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/business/js/jquery.js"></script>
	<script src="${base}/resources/business/js/bootstrap.js"></script>
	<script src="${base}/resources/business/js/bootstrap-checkbox-x.js"></script>
	<script src="${base}/resources/business/js/velocity.js"></script>
	<script src="${base}/resources/business/js/velocity.ui.js"></script>
	<script src="${base}/resources/business/js/summernote.js"></script>
	<script src="${base}/resources/business/js/moment.js"></script>
	<script src="${base}/resources/business/js/bootstrap-datetimepicker.js"></script>
	<script src="${base}/resources/business/js/jquery.validate.js"></script>
	<script src="${base}/resources/business/js/adminLTE.js"></script>
	<script src="${base}/resources/business/js/common.js"></script>
	<script type="text/javascript">
	$().ready(function() {
	
		var $couponForm = $("#couponForm");
		var $isExchange = $("#isExchange");
		var $point = $("#point");
		
		// 是否允许积分兑换
		$isExchange.change(function() {
			var $element = $(this);
			
			if ($element.val() == "true") {
				$point.prop("disabled", false).closest(".form-group").velocity("slideDown");
			} else {
				$point.closest(".form-group").velocity("slideUp", {
					complete: function() {
						$point.prop("disabled", true);
					}
				});
			}
		});
		
		$.validator.addMethod("compare", function(value, element, param) {
			var parameterValue = $(param).val();
			if ($.trim(parameterValue) == "" || $.trim(value) == "") {
				return true;
			}
			try {
				return parseFloat(parameterValue) <= parseFloat(value);
			} catch(e) {
				return false;
			}
		}, "${message("business.coupon.compare")}");
		
		// 表单验证
		$couponForm.validate({
			rules: {
				name: "required",
				prefix: "required",
				minimumPrice: {
					min: 0,
					decimal: {
						integer: 12,
						fraction: ${setting.priceScale}
					}
				},
				maximumPrice: {
					min: 0,
					decimal: {
						integer: 12,
						fraction: ${setting.priceScale}
					},
					compare: "#minimumPrice"
				},
				minimumQuantity: "digits",
				maximumQuantity: {
					digits: true,
					compare: "#minimumQuantity"
				},
				priceExpression: {
					remote: {
						url: "${base}/business/coupon/check_price_expression",
						cache: false
					}
				},
				point: {
					required: true,
					digits: true
				}
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
					<h1>${message("business.coupon.edit")}</h1>
					<ol class="breadcrumb">
						<li>
							<a href="/shop/business/index">
								<i class="fa fa-home"></i>
								${message("business.common.index")}
							</a>
						</li>
						<li class="active">${message("business.coupon.edit")}</li>
					</ol>
				</section>
				<section class="content">
					<div class="row">
						<div class="col-xs-12">
							<form id="couponForm" class="form-horizontal" action="${base}/business/coupon/update" method="post">
								<input name="couponId" type="hidden" value="${coupon.id}">
								<div class="box">
									<div class="box-body">
										<ul class="nav nav-tabs">
											<li class="active">
												<a href="#base" data-toggle="tab">${message("business.coupon.base")}</a>
											</li>
											<li>
												<a href="#introduction" data-toggle="tab">${message("Coupon.introduction")}</a>
											</li>
										</ul>
										<div class="tab-content">
											<div id="base" class="tab-pane active">
												<div class="form-group">
													<label class="col-xs-2 control-label item-required" for="name">${message("Coupon.name")}:</label>
													<div class="col-xs-4">
														<input id="name" name="name" class="form-control" type="text" value="${coupon.name}" maxlength="200">
													</div>
												</div>
												<div class="form-group">
													<label class="col-xs-2 control-label item-required" for="prefix">${message("Coupon.prefix")}:</label>
													<div class="col-xs-4">
														<input id="prefix" name="prefix" class="form-control" type="text" value="${coupon.prefix}" maxlength="200">
													</div>
												</div>
												<div class="form-group">
													<label class="col-xs-2 control-label" for="beginDate">${message("business.common.dateRange")}:</label>
													<div class="col-xs-4">
														<div class="input-group" data-provide="datetimerangepicker" data-date-format="YYYY-MM-DD HH:mm:ss">
															<input id="beginDate" name="beginDate" class="form-control" type="text" value="[#if coupon.beginDate??]${coupon.beginDate?string("yyyy-MM-dd HH:mm:ss")}[/#if]">
															<div class="input-group-addon">-</div>
															<input name="endDate" class="form-control" type="text" value="[#if coupon.endDate??]${coupon.endDate?string("yyyy-MM-dd HH:mm:ss")}[/#if]">
														</div>
													</div>
												</div>
												<div class="form-group">
													<label class="col-xs-2 control-label" for="minimumPrice">${message("business.common.priceRange")}:</label>
													<div class="col-xs-4">
														<div class="input-group">
															<input id="minimumPrice" name="minimumPrice" class="form-control" type="text" value="${coupon.minimumPrice}" maxlength="16">
															<div class="input-group-addon">-</div>
															<input name="maximumPrice" class="form-control" type="text" value="${coupon.maximumPrice}" maxlength="16">
														</div>
													</div>
												</div>
												<div class="form-group">
													<label class="col-xs-2 control-label" for="minimumQuantity">${message("business.common.quantityRange")}:</label>
													<div class="col-xs-4">
														<div class="input-group">
															<input id="minimumQuantity" name="minimumQuantity" class="form-control" type="text" value="${coupon.minimumQuantity}" maxlength="9">
															<div class="input-group-addon">-</div>
															<input name="maximumQuantity" class="form-control" type="text" value="${coupon.maximumQuantity}" maxlength="9">
														</div>
													</div>
												</div>
												<div class="form-group">
													<label class="col-xs-2 control-label" for="priceExpression">${message("Coupon.priceExpression")}:</label>
													<div class="col-xs-4">
														<input id="priceExpression" name="priceExpression" class="form-control" type="text" value="${coupon.priceExpression}" maxlength="200" title="${message("business.coupon.priceExpressionTitle")}">
													</div>
												</div>
												<div class="form-group">
													<label class="col-xs-2 control-label">${message("business.common.setting")}:</label>
													<div class="col-xs-10 checkbox">
														<input id="isEnabled" name="isEnabled" type="text" value="${coupon.isEnabled?string("true", "false")}" data-toggle="checkbox-x">
														<label for="isEnabled" class="cbx-label">${message("Coupon.isEnabled")}</label>
														<input id="isExchange" name="isExchange" type="text" value="${coupon.isExchange?string("true", "false")}" data-toggle="checkbox-x">
														<label for="isExchange" class="cbx-label">${message("Coupon.isExchange")}</label>
													</div>
												</div>
												<div class="form-group[#if !coupon.isExchange] hidden-element[/#if]">
													<label class="col-xs-2 control-label item-required" for="point">${message("Coupon.point")}:</label>
													<div class="col-xs-4">
														<input id="point" name="point" class="form-control" type="text" value="${coupon.point}" maxlength="9"[#if !coupon.isExchange] disabled[/#if]>
													</div>
												</div>
											</div>
											<div id="introduction" class="tab-pane">
												<textarea name="introduction" data-provide="editor">${coupon.introduction}</textarea>
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