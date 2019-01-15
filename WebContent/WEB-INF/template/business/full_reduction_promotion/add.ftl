<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("business.fullReductionPromotion.add")} </title>
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
	<script src="${base}/resources/business/js/velocity.js"></script>
	<script src="${base}/resources/business/js/velocity.ui.js"></script>
	<script src="${base}/resources/business/js/moment.js"></script>
	<script src="${base}/resources/business/js/bootstrap-datetimepicker.js"></script>
	<script src="${base}/resources/business/js/summernote.js"></script>
	<script src="${base}/resources/business/js/jquery.validate.js"></script>
	<script src="${base}/resources/business/js/icheck.js"></script>
	<script src="${base}/resources/business/js/adminLTE.js"></script>
	<script src="${base}/resources/business/js/common.js"></script>
	<script type="text/javascript">
	$().ready(function() {
		
		var $fullReductionPromotionForm = $("#fullReductionPromotionForm");
		var $browserButton = $("a.browserButton");
		var $introduction = $("#introduction");
		var $useAmountPromotion = $("#useAmountPromotion");
		var $useNumberPromotion = $("#useNumberPromotion");
		var $conditionsAmount = $("#conditionsAmount");
		var $creditAmount = $("#creditAmount");
		var $conditionsNumber = $("#conditionsNumber");
		var $creditNumber = $("#creditNumber");
		var $giftSelect = $(".gift-select");
		
		[#if flashMessage?has_content]
			$.alert("${flashMessage}");
		[/#if]
		
		// 使用金额促销
		$useAmountPromotion.on("ifChecked", function() {
			$conditionsAmount.add($creditAmount).prop("disabled", false).closest(".form-group").velocity("slideDown");
			$useNumberPromotion.iCheck("uncheck");
		});
		$useAmountPromotion.on("ifUnchecked", function() {
			$conditionsAmount.add($creditAmount).closest(".form-group").velocity("slideUp", {
				complete: function() {
					$conditionsAmount.add($creditAmount).prop("disabled", true);
				}
			});
		});
		
		// 使用数量促销
		$useNumberPromotion.on("ifChecked", function() {
			$conditionsNumber.add($creditNumber).prop("disabled", false).closest(".form-group").velocity("slideDown");
			$useAmountPromotion.iCheck("uncheck");
		});
		$useNumberPromotion.on("ifUnchecked", function() {
			$conditionsNumber.add($creditNumber).closest(".form-group").velocity("slideUp", {
				complete: function() {
					$conditionsNumber.add($creditNumber).prop("disabled", true);
				}
			});
		});
		
		// 赠品选择
		$giftSelect.selectpicker({
			liveSearch: true
		}).ajaxSelectPicker({
			ajax: {
				url: "${base}/business/full_reduction_promotion/gift_select",
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
		}, "${message("business.fullReductionPromotion.compare")}");
		
		$.validator.addMethod("compareTo", function(value, element, param) {
			var parameterValue = $(param).val();
			if ($.trim(parameterValue) == "" || $.trim(value) == "") {
				return true;
			}
			try {
				return parseFloat(parameterValue) >= parseFloat(value);
			} catch(e) {
				return false;
			}
		}, "${message("business.fullReductionPromotion.compareTo")}");
		
		// 表单验证
		$fullReductionPromotionForm.validate({
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
				conditionsAmount: {
					required: true,
					min: 0,
					decimal: {
						integer: 12,
						fraction: ${setting.priceScale}
					}
				},
				creditAmount: {
					required: true,
					min: 0,
					decimal: {
						integer: 12,
						fraction: ${setting.priceScale}
					},
					compareTo: "#conditionsAmount"
				},
				conditionsNumber: {
					required: true,
					digits: true
				},
				creditNumber: {
					required: true,
					digits: true,
					compareTo: "#conditionsNumber"
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
					<h1>${message("business.fullReductionPromotion.add")}</h1>
					<ol class="breadcrumb">
						<li>
							<a href="/shop/business/index">
								<i class="fa fa-home"></i>
								${message("business.common.index")}
							</a>
						</li>
						<li class="active">${message("business.fullReductionPromotion.add")}</li>
					</ol>
				</section>
				<section class="content">
					<div class="row">
						<div class="col-xs-12">
							<form id="fullReductionPromotionForm" class="form-horizontal" action="${base}/business/full_reduction_promotion/save" method="post">
								<div class="box">
									<div class="box-body">
										<ul class="nav nav-tabs">
											<li class="active">
												<a href="#base" data-toggle="tab">${message("business.fullReductionPromotion.base")}</a>
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
													<label class="col-xs-2 control-label">${message("business.common.setting")}:</label>
													<div class="col-xs-10">
														<label class="checkbox-inline">
															<input id="useAmountPromotion" name="useAmountPromotion" class="icheck" type="checkbox" value="true">
															${message("business.fullReductionPromotion.useAmountPromotion")}
														</label>
														<label class="checkbox-inline">
															<input id="useNumberPromotion" name="useNumberPromotion" class="icheck" type="checkbox" value="true">
															${message("business.fullReductionPromotion.useNumberPromotion")}
														</label>
													</div>
												</div>
												<div class="hidden-element form-group">
													<label class="col-xs-2 control-label" for="conditionsAmount">${message("Promotion.conditionsAmount")}:</label>
													<div class="col-xs-4">
														<input id="conditionsAmount" name="conditionsAmount" class="form-control" type="text" maxlength="16" disabled>
													</div>
												</div>
												<div class="hidden-element form-group">
													<label class="col-xs-2 control-label" for="creditAmount">${message("Promotion.creditAmount")}:</label>
													<div class="col-xs-4">
														<input id="creditAmount" name="creditAmount" class="form-control" type="text" maxlength="16" disabled>
													</div>
												</div>
												<div class="hidden-element form-group">
													<label class="col-xs-2 control-label" for="conditionsNumber">${message("Promotion.conditionsNumber")}:</label>
													<div class="col-xs-4">
														<input id="conditionsNumber" name="conditionsNumber" class="form-control" type="text" maxlength="9" disabled>
													</div>
												</div>
												<div class="hidden-element form-group">
													<label class="col-xs-2 control-label" for="creditNumber">${message("Promotion.creditNumber")}:</label>
													<div class="col-xs-4">
														<input id="creditNumber" name="creditNumber" class="form-control" type="text" maxlength="9" disabled>
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
														<select name="giftIds" class="gift-select form-control" title="${message("business.fullReductionPromotion.giftSelectTitle")}" multiple></select>
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