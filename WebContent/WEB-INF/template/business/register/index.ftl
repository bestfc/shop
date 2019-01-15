<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("business.register.title")} </title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/business/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/business/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/business/css/bootstrap-select.css" rel="stylesheet">
	<link href="${base}/resources/business/css/bootstrap-fileinput.css" rel="stylesheet">
	<link href="${base}/resources/business/css/bootstrap-datetimepicker.css" rel="stylesheet">
	<link href="${base}/resources/business/css/adminLTE.css" rel="stylesheet">
	<link href="${base}/resources/business/css/common.css" rel="stylesheet">
	<link href="${base}/resources/business/css/register.css" rel="stylesheet">
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
		
		var $registerForm = $("#registerForm");
		var $captcha = $("#captcha");
		var $submit = $("button[type='submit']");
		
		// 验证码图片
		$captcha.captchaImage();
		
		$.validator.addMethod("notAllNumber",
			function(value, element) {
				return this.optional(element) || /^.*[^\d].*$/.test(value);
			},
			"${message("business.register.notAllNumber")}"
		);
		
		// 表单验证
		$registerForm.validate({
			rules: {
				username: {
					required: true,
					minlength: 4,
					pattern: /^[0-9a-zA-Z_\u4e00-\u9fa5]+$/,
					notAllNumber: true,
					remote: {
						url: "${base}/business/register/check_username",
						cache: false
					}
				},
				password: {
					required: true,
					minlength: 4
				},
				rePassword: {
					required: true,
					equalTo: "#password"
				},
				email: {
					required: true,
					email: true,
					remote: {
						url: "${base}/business/register/check_email",
						cache: false
					}
				},
				mobile: {
					pattern: /^1[3|4|5|7|8]\d{9}$/,
					remote: {
						url: "${base}/business/register/check_mobile",
						cache: false
					}
				},
				captcha: "required"
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
				username: {
					pattern: "${message("business.register.usernameIllegal")}",
					remote: "${message("business.register.usernameExist")}"
				},
				email: {
					remote: "${message("business.register.emailExist")}"
				},
				mobile: {
					pattern: "${message("business.register.mobileIllegal")}",
					remote: "${message("business.register.mobileExist")}"
				}
			},
			submitHandler: function(form) {
				$.ajax({
					url: $registerForm.attr("action"),
					type: "POST",
					data: $registerForm.serialize(),
					dataType: "json",
					beforeSend: function() {
						$submit.prop("disabled", true);
					},
					success: function() {
						setTimeout(function() {
							location.href = "${base}/";
						}, 3000);
					},
					error: function(xhr, textStatus, errorThrown) {
						$captcha.captchaImage("refresh", true);
					},
					complete: function() {
						$submit.prop("disabled", false);
					}
				});
			}
		});
	
	});
	</script>
</head>
<body class="register">
	[#include "/business/include/header.ftl" /]
	<main>
		<div class="container">
			<div class="row">
				<div class="col-xs-12">
					<form id="registerForm" class="form-horizontal" action="${base}/business/register/submit" method="post">
						<div class="panel panel-default">
							<div class="panel-heading">
								<div class="panel-title">
									<h1 class="blue">${message("business.register.title")}</h1>
								</div>
							</div>
							<div class="panel-body">
								<div class="form-group">
									<label class="col-xs-3 control-label item-required" for="username">${message("business.register.username")}:</label>
									<div class="col-xs-5">
										<input id="username" name="username" class="form-control" type="text" maxlength="20">
									</div>
								</div>
								<div class="form-group">
									<label class="col-xs-3 control-label item-required" for="password">${message("business.register.password")}:</label>
									<div class="col-xs-5">
										<input id="password" name="password" class="form-control" type="password" maxlength="20" autocomplete="off">
									</div>
								</div>
								<div class="form-group">
									<label class="col-xs-3 control-label item-required" for="rePassword">${message("business.register.rePassword")}:</label>
									<div class="col-xs-5">
										<input id="rePassword" name="rePassword" class="form-control" type="password" maxlength="20" autocomplete="off">
									</div>
								</div>
								<div class="form-group">
									<label class="col-xs-3 control-label item-required" for="email">${message("business.register.email")}:</label>
									<div class="col-xs-5">
										<input id="email" name="email" class="form-control" type="text" maxlength="200">
									</div>
								</div>
								<div class="form-group">
									<label class="col-xs-3 control-label" for="mobile">${message("business.register.mobile")}:</label>
									<div class="col-xs-5">
										<input id="mobile" name="mobile" class="form-control" type="text" maxlength="200">
									</div>
								</div>
								[@business_attribute_list]
									[#list businessAttributes as businessAttribute]
										<div class="form-group">
											<label class="col-xs-3 control-label[#if businessAttribute.isRequired] item-required[/#if]" for="businessAttribute_${businessAttribute.id}">${businessAttribute.name}:</label>
											[#if businessAttribute.type == "name" || businessAttribute.type == "licenseNumber" || businessAttribute.type == "legalPerson" || businessAttribute.type == "idCard" || businessAttribute.type == "phone" || businessAttribute.type == "organizationCode" || businessAttribute.type == "identificationNumber" || businessAttribute.type == "bankName" || businessAttribute.type == "bankAccount" || businessAttribute.type == "text"]
												<div class="col-xs-5">
													<input id="businessAttribute_${businessAttribute.id}" name="businessAttribute_${businessAttribute.id}" class="form-control" type="text" maxlength="200">
												</div>
											[#elseif businessAttribute.type == "licenseImage" || businessAttribute.type == "idCardImage" || businessAttribute.type == "organizationImage" || businessAttribute.type == "taxImage" || businessAttribute.type == "image"]
												<div class="col-xs-5">
													<input name="businessAttribute_${businessAttribute.id}" type="hidden" data-provide="fileinput" data-file-type="image">
												</div>
											[#elseif businessAttribute.type == "select"]
												<div class="col-xs-5">
													<select name="businessAttribute_${businessAttribute.id}" class="selectpicker form-control" data-size="5">
														<option value="">${message("business.common.choose")}</option>
														[#list businessAttribute.options as option]
															<option value="${option}">${option}</option>
														[/#list]
													</select>
												</div>
											[#elseif businessAttribute.type == "checkbox"]
												<div class="col-xs-9">
													[#list businessAttribute.options as option]
														<label class="checkbox-inline">
															<input name="businessAttribute_${businessAttribute.id}" class="icheck" type="checkbox" value="${option}">
															${option}
														</label>
													[/#list]
												</div>
											[#elseif businessAttribute.type == "date"]
												<div class="col-xs-5">
													<input id="businessAttribute_${businessAttribute.id}" name="businessAttribute_${businessAttribute.id}" class="form-control" type="text" data-provide="datetimepicker">
												</div>
											[/#if]
										</div>
									[/#list]
								[/@business_attribute_list]
								[#if setting.captchaTypes?? && setting.captchaTypes?seq_contains("businessRegister")]
									<div class="form-group">
										<label class="col-xs-3 control-label item-required" for="captcha">${message("common.captcha.name")}:</label>
										<div class="col-xs-5">
											<div class="input-group">
												<input id="captcha" name="captcha" class="captcha form-control" type="text" maxlength="4" autocomplete="off">
												<div class="input-group-btn"></div>
											</div>
										</div>
									</div>
								[/#if]
							</div>
							<div class="panel-footer">
								<div class="form-group">
									<div class="col-xs-5 col-xs-offset-3">
										<button class="btn btn-primary btn-block" type="submit">${message("business.register.submit")}</button>
									</div>
								</div>
								<div class="form-group">
									<div class="col-xs-5 col-xs-offset-3">
										<a href="${base}/article/detail/1_1" target="_blank">${message("business.register.agreement", setting.siteName)}</a>
									</div>
								</div>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</main>
	[#include "/business/include/footer.ftl" /]
</body>
</html>