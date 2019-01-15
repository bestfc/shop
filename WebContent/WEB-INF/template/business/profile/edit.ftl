<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("business.profile.edit")} </title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/business/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/business/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/business/css/bootstrap-select.css" rel="stylesheet">
	<link href="${base}/resources/business/css/bootstrap-fileinput.css" rel="stylesheet">
	<link href="${base}/resources/business/css/bootstrap-datetimepicker.css" rel="stylesheet">
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
	<script src="${base}/resources/business/js/bootstrap-fileinput.js"></script>
	<script src="${base}/resources/business/js/moment.js"></script>
	<script src="${base}/resources/business/js/bootstrap-datetimepicker.js"></script>
	<script src="${base}/resources/business/js/jquery.validate.js"></script>
	<script src="${base}/resources/business/js/icheck.js"></script>
	<script src="${base}/resources/business/js/adminLTE.js"></script>
	<script src="${base}/resources/business/js/common.js"></script>
	<script type="text/javascript">
	$().ready(function() {
		
		var $profileForm = $("#profileForm");
		
		[#if flashMessage?has_content]
			$.alert("${flashMessage}");
		[/#if]
		
		// 表单验证
		$profileForm.validate({
			rules: {
				email: {
					required: true,
					email: true,
					remote: {
						url: "${base}/business/profile/check_email",
						cache: false
					}
				},
				mobile: {
					pattern: /^1[3|4|5|7|8]\d{9}$/,
					remote: {
						url: "${base}/business/profile/check_mobile",
						cache: false
					}
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
				email: {
					remote: "${message("common.validate.exist")}"
				},
				mobile: {
					pattern: "${message("common.validate.pattern")}",
					remote: "${message("common.validate.exist")}"
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
					<h1>${message("business.profile.edit")}</h1>
					<ol class="breadcrumb">
						<li>
							<a href="/shop/business/index">
								<i class="fa fa-home"></i>
								${message("business.common.index")}
							</a>
						</li>
						<li class="active">${message("business.profile.edit")}</li>
					</ol>
				</section>
				<section class="content">
					<div class="row">
						<div class="col-xs-12">
							<form id="profileForm" class="form-horizontal" action="${base}/business/profile/update" method="post">
								<div class="box">
									<div class="box-body">
										<div class="row">
											<div class="col-xs-6">
												<dl class="items dl-horizontal clearfix">
													<dt>${message("Business.username")}:</dt>
													<dd>${currentUser.username}</dd>
													<dt>${message("Business.balance")}:</dt>
													<dd>${currency(currentUser.balance, true)}</dd>
													[#if currentUser.frozenFund > 0]
														<dt>${message("Business.frozenFund")}:</dt>
														<dd>${currency(currentUser.frozenFund, true)}</dd>
													[/#if]
													<dt>${message("Store.bailPaid")}:</dt>
													<dd>${currency(currentStore.bailPaid, true)}</dd>
													<dt>${message("business.common.createdDate")}:</dt>
													<dd>${currentUser.createdDate?string("yyyy-MM-dd HH:mm:ss")}</dd>
												</dl>
											</div>
										</div>
										<div class="form-group">
											<label class="col-xs-2 control-label item-required" for="email">${message("Business.email")}:</label>
											<div class="col-xs-4">
												<input id="email" name="email" class="form-control" type="text" value="${currentUser.email}" maxlength="200">
											</div>
										</div>
										<div class="form-group">
											<label class="col-xs-2 control-label" for="mobile">${message("Business.mobile")}:</label>
											<div class="col-xs-4">
												<input id="mobile" name="mobile" class="form-control" type="text" value="${currentUser.mobile}" maxlength="200">
											</div>
										</div>
										[@business_attribute_list]
											[#list businessAttributes as businessAttribute]
												<div class="form-group">
													<label class="col-xs-2 control-label[#if businessAttribute.isRequired] item-required[/#if]" for="businessAttribute_${businessAttribute.id}">${businessAttribute.name}:</label>
													[#if businessAttribute.type == "name" || businessAttribute.type == "licenseNumber" || businessAttribute.type == "legalPerson" || businessAttribute.type == "idCard" || businessAttribute.type == "phone" || businessAttribute.type == "organizationCode" || businessAttribute.type == "identificationNumber" || businessAttribute.type == "bankName" || businessAttribute.type == "bankAccount" || businessAttribute.type == "text"]
														<div class="col-xs-4">
															<input id="businessAttribute_${businessAttribute.id}" name="businessAttribute_${businessAttribute.id}" class="form-control" type="text" value="${currentUser.getAttributeValue(businessAttribute)}" maxlength="200">
														</div>
													[#elseif businessAttribute.type == "licenseImage" || businessAttribute.type == "idCardImage" || businessAttribute.type == "organizationImage" || businessAttribute.type == "taxImage" || businessAttribute.type == "image"]
														<div class="col-xs-4">
															<input name="businessAttribute_${businessAttribute.id}" type="hidden" value="${currentUser.getAttributeValue(businessAttribute)}" data-provide="fileinput" data-file-type="image">
														</div>
													[#elseif businessAttribute.type == "select"]
														<div class="col-xs-4">
															<select name="businessAttribute_${businessAttribute.id}" class="selectpicker form-control" data-size="5">
																<option value="">${message("business.common.choose")}</option>
																[#list businessAttribute.options as option]
																	<option value="${option}"[#if option == currentUser.getAttributeValue(businessAttribute)] selected[/#if]>${option}</option>
																[/#list]
															</select>
														</div>
													[#elseif businessAttribute.type == "checkbox"]
														<div class="col-xs-10">
															[#list businessAttribute.options as option]
																<label class="checkbox-inline">
																	<input name="businessAttribute_${businessAttribute.id}" class="icheck" type="checkbox" value="${option}"[#if (currentUser.getAttributeValue(businessAttribute)?seq_contains(option))!] checked[/#if]>
																	${option}
																</label>
															[/#list]
														</div>
													[#elseif businessAttribute.type == "date"]
														<div class="col-xs-4">
															<input id="businessAttribute_${businessAttribute.id}" name="businessAttribute_${businessAttribute.id}" class="form-control" type="text" value="${currentUser.getAttributeValue(businessAttribute)}" data-provide="datetimepicker">
														</div>
													[/#if]
												</div>
											[/#list]
										[/@business_attribute_list]
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