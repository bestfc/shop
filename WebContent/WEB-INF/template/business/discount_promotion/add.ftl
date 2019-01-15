<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("business.discountPromotion.add")} </title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/business/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/business/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/business/css/bootstrap-select.css" rel="stylesheet">
	<link href="${base}/resources/business/css/ajax-bootstrap-select.css" rel="stylesheet">
	<link href="${base}/resources/business/css/bootstrap-checkbox-x.css" rel="stylesheet">
	<link href="${base}/resources/business/css/bootstrap-fileinput.css" rel="stylesheet">
	<link href="${base}/resources/business/css/bootstrap-datetimepicker.css" rel="stylesheet">
	<link href="${base}/resources/business/css/summernote.css" rel="stylesheet">
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
	<script src="${base}/resources/business/js/ajax-bootstrap-select.js"></script>
	<script src="${base}/resources/business/js/bootstrap-checkbox-x.js"></script>
	<script src="${base}/resources/business/js/bootstrap-fileinput.js"></script>
	<script src="${base}/resources/business/js/moment.js"></script>
	<script src="${base}/resources/business/js/bootstrap-datetimepicker.js"></script>
	<script src="${base}/resources/business/js/summernote.js"></script>
	<script src="${base}/resources/business/js/jquery.validate.js"></script>
	<script src="${base}/resources/business/js/icheck.js"></script>
	<script src="${base}/resources/business/js/adminLTE.js"></script>
	<script src="${base}/resources/business/js/common.js"></script>
	<script type="text/javascript">
	$().ready(function() {
		
		var $discountPromotionForm = $("#discountPromotionForm");
		var $browserButton = $("a.browserButton");
		var $giftSelect = $(".gift-select");
		var $introduction = $("#introduction");
		
		[#if flashMessage?has_content]
			$.alert("${flashMessage}");
		[/#if]
		
		// 赠品选择
		$giftSelect.selectpicker({
			liveSearch: true
		}).ajaxSelectPicker({
			ajax: {
				url: "${base}/business/discount_promotion/gift_select",
				type: "GET",
				data: function () {
					return {
						keyword: "{{{q}}}"
					};
				},
				dataType: "json"
			},
			preprocessData: function(data) {
				return $.map(data, function(item) {
					return {
						value: item.id,
						text: item.name,
						data: {
							subtext: item.specifications.length > 0 ? '<span class="gray-darker">' + escapeHtml(item.specifications.join(",")) + '</span>' : null
						},
						disabled: false
					};
				});
			},
			preserveSelected: false
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
		}, "${message("business.discountPromotion.compare")}");
		
		// 表单验证
		$discountPromotionForm.validate({
			rules: {
				name: "required",
				title: "required",
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
				discount: {
					min: 0,
					decimal: {
						integer: 3,
						fraction: 3
					}
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
					<h1>${message("business.discountPromotion.add")}</h1>
					<ol class="breadcrumb">
						<li>
							<a href="/shop/business/index">
								<i class="fa fa-home"></i>
								${message("business.common.index")}
							</a>
						</li>
						<li class="active">${message("business.discountPromotion.add")}</li>
					</ol>
				</section>
				<section class="content">
					<div class="row">
						<div class="col-xs-12">
							<form id="discountPromotionForm" class="form-horizontal" action="${base}/business/discount_promotion/save" method="post">
								<div class="box">
									<div class="box-body">
										<ul class="nav nav-tabs">
											<li class="active">
												<a href="#base" data-toggle="tab">${message("business.discountPromotion.base")}</a>
											</li>
											<li>
												<a href="#introduction" data-toggle="tab">${message("Promotion.introduction")}</a>
											</li>
										</ul>
										<div class="tab-content">
											<div id="base" class="tab-pane active">
												<div class="form-group">
													<label class="col-xs-2 control-label item-required" for="name">${message("Promotion.name")}:</label>
													<div class="col-xs-4">
														<input id="name" name="name" class="form-control" type="text" maxlength="200">
													</div>
												</div>
												<div class="form-group">
													<label class="col-xs-2 control-label item-required" for="title">${message("Promotion.title")}:</label>
													<div class="col-xs-4">
														<input id="title" name="title" class="form-control" type="text" maxlength="200">
													</div>
												</div>
												<div class="form-group">
													<label class="col-xs-2 control-label">${message("Promotion.image")}:</label>
													<div class="col-xs-4">
														<input name="image" type="hidden" data-provide="fileinput" data-file-type="image">
													</div>
												</div>
												<div class="form-group">
													<label class="col-xs-2 control-label" for="beginDate">${message("business.common.dateRange")}:</label>
													<div class="col-xs-4">
														<div class="input-group" data-provide="datetimerangepicker" data-date-format="YYYY-MM-DD HH:mm:ss">
															<input id="beginDate" name="beginDate" class="form-control" type="text">
															<div class="input-group-addon">-</div>
															<input name="endDate" class="form-control" type="text">
														</div>
													</div>
												</div>
												<div class="form-group">
													<label class="col-xs-2 control-label" for="minimumPrice">${message("business.common.priceRange")}:</label>
													<div class="col-xs-4">
														<div class="input-group">
															<input id="minimumPrice" name="minimumPrice" class="form-control" type="text" maxlength="16">
															<div class="input-group-addon">-</div>
															<input name="maximumPrice" class="form-control" type="text" maxlength="16">
														</div>
													</div>
												</div>
												<div class="form-group">
													<label class="col-xs-2 control-label" for="minimumQuantity">${message("business.common.quantityRange")}:</label>
													<div class="col-xs-4">
														<div class="input-group">
															<input id="minimumQuantity" name="minimumQuantity" class="form-control" type="text" maxlength="9">
															<div class="input-group-addon">-</div>
															<input name="maximumQuantity" class="form-control" type="text" maxlength="9">
														</div>
													</div>
												</div>
												<div class="form-group">
													<label class="col-xs-2 control-label" for="discount">${message("Promotion.discount")}:</label>
													<div class="col-xs-4">
														<input id="discount" name="discount" class="form-control" type="text" maxlength="9" title="${message("business.fullReductionPromotion.discountNote")}">
													</div>
												</div>
												<div class="form-group">
													<label class="col-xs-2 control-label">${message("Promotion.memberRanks")}:</label>
													<div class="col-xs-10">
														[#list memberRanks as memberRank]
															<label class="checkbox-inline">
																<input name="memberRankIds" class="icheck" type="checkbox" value="${memberRank.id}">
																${memberRank.name}
															</label>
														[/#list]
													</div>
												</div>
												[#if coupons?has_content]
													<div class="form-group">
														<label class="col-xs-2 control-label">${message("Promotion.coupons")}:</label>
														<div class="col-xs-10">
															[#list coupons as coupon]
																<label class="checkbox-inline">
																	<input name="couponIds" class="icheck" type="checkbox" value="${coupon.id}">
																	${coupon.name}
																</label>
															[/#list]
														</div>
													</div>
												[/#if]
												<div class="form-group">
													<label class="col-xs-2 control-label">${message("business.common.setting")}:</label>
													<div class="col-xs-10 checkbox">
														<input id="isFreeShipping" name="isFreeShipping" type="text" value="false" data-toggle="checkbox-x">
														<label for="isFreeShipping" class="cbx-label">${message("Promotion.isFreeShipping")}</label>
														<input id="isCouponAllowed" name="isCouponAllowed" type="text" value="true" data-toggle="checkbox-x">
														<label for="isCouponAllowed" class="cbx-label">${message("Promotion.isCouponAllowed")}</label>
														<input id="isEnabled" name="isEnabled" type="text" value="true" data-toggle="checkbox-x">
														<label for="isEnabled" class="cbx-label">${message("Promotion.isEnabled")}</label>
													</div>
												</div>
												<div class="form-group">
													<label class="col-xs-2 control-label">${message("Promotion.gifts")}:</label>
													<div class="col-xs-4">
														<select name="giftIds" class="gift-select form-control" title="${message("business.discountPromotion.giftSelectTitle")}" multiple></select>
													</div>
												</div>
											</div>
											<div id="introduction" class="tab-pane">
												<textarea name="introduction" data-provide="editor"></textarea>
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