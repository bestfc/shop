<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.register.title")}[#if showPowered] [/#if]</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/mobile/member/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/bootstrap-datepicker.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/animate.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/common.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/register.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/mobile/member/js/html5shiv.js"></script>
		<script src="${base}/resources/mobile/member/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/mobile/member/js/jquery.js"></script>
	<script src="${base}/resources/mobile/member/js/bootstrap.js"></script>
	<script src="${base}/resources/mobile/member/js/bootstrap-datepicker.js"></script>
	<script src="${base}/resources/mobile/member/js/jquery.validate.js"></script>
	<script src="${base}/resources/mobile/member/js/jquery.lSelect.js"></script>
	<script src="${base}/resources/mobile/member/js/underscore.js"></script>
	<script src="${base}/resources/mobile/member/js/common.js"></script>
	<script type="text/javascript">
	$().ready(function() {
		
		var $registerForm = $("#registerForm");
		var $areaId = $("#areaId");
		var $datepicker = $("input.datepicker");
		var $captcha = $("#captcha");
		var $submit = $("button:submit");
		
		// 地区选择
		$areaId.lSelect({
			url: "${base}/common/area"
		});
		
		// 日期选择
		$datepicker.datepicker({
			language: "${locale}",
			format: "yyyy-mm-dd",
			todayHighlight: true,
			autoclose: true
		});
		
		// 验证码图片
		$captcha.captchaImage();
		
		$.validator.addMethod("notAllNumber",
			function(value, element) {
				return this.optional(element) || /^.*[^\d].*$/.test(value);
			},
			"${message("member.register.notAllNumber")}"
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
						url: "${base}/member/register/check_username",
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
						url: "${base}/member/register/check_email",
						cache: false
					}
				},
				mobile: {
					pattern: /^1[3|4|5|7|8]\d{9}$/,
					remote: {
						url: "${base}/member/register/check_mobile",
						cache: false
					}
				},
				captcha: "required"
				[@member_attribute_list]
					[#list memberAttributes as memberAttribute]
						[#if memberAttribute.isRequired || memberAttribute.pattern?has_content]
							,memberAttribute_${memberAttribute.id}: {
								[#if memberAttribute.isRequired]
									required: true
									[#if memberAttribute.pattern?has_content],[/#if]
								[/#if]
								[#if memberAttribute.pattern?has_content]
									pattern: /${memberAttribute.pattern}/
								[/#if]
							}
						[/#if]
					[/#list]
				[/@member_attribute_list]
			},
			messages: {
				username: {
					pattern: "${message("member.register.usernameIllegal")}",
					remote: "${message("member.register.usernameExist")}"
				},
				email: {
					remote: "${message("member.register.emailExist")}"
				},
				mobile: {
					pattern: "${message("member.register.mobileIllegal")}",
					remote: "${message("member.register.mobileExist")}"
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
	<header class="header-fixed">
		<a class="pull-left" href="javascript: history.back();">
			<span class="glyphicon glyphicon-menu-left"></span>
		</a>
		[#if socialUserId?has_content && uniqueId?has_content]
			${message("member.register.bind")}
		[#else]
			${message("member.register.title")}
		[/#if]
	</header>
	<main>
		<div class="container-fluid">
			<form id="registerForm" action="${base}/member/register/submit" method="post">
				<input name="socialUserId" type="hidden" value="${socialUserId}">
				<input name="uniqueId" type="hidden" value="${uniqueId}">
				<div class="form-group">
					<label for="username">${message("member.register.username")}</label>
					<input id="username" name="username" class="form-control" type="text" maxlength="20">
				</div>
				<div class="form-group">
					<label for="password">${message("member.register.password")}</label>
					<input id="password" name="password" class="form-control" type="password" maxlength="20" autocomplete="off">
				</div>
				<div class="form-group">
					<label for="rePassword">${message("member.register.rePassword")}</label>
					<input id="rePassword" name="rePassword" class="form-control" type="password" maxlength="20" autocomplete="off">
				</div>
				<div class="form-group">
					<label for="email">${message("member.register.email")}</label>
					<input id="email" name="email" class="form-control" type="text" maxlength="200">
				</div>
				<div class="form-group">
					<label for="mobile">${message("member.register.mobile")}</label>
					<input id="mobile" name="mobile" class="form-control" type="text" maxlength="200">
				</div>
				[@member_attribute_list]
					[#list memberAttributes as memberAttribute]
						<div class="form-group">
							<label[#if memberAttribute.type != "gender" && memberAttribute.type != "area" && memberAttribute.type != "checkbox"] for="memberAttribute_${memberAttribute.id}"[/#if]>${memberAttribute.name}</label>
							[#if memberAttribute.type == "name"]
								<input id="memberAttribute_${memberAttribute.id}" name="memberAttribute_${memberAttribute.id}" class="form-control" type="text" maxlength="200">
							[#elseif memberAttribute.type == "gender"]
								<div class="radio">
									[#list genders as gender]
										<label>
											<input name="memberAttribute_${memberAttribute.id}" type="radio" value="${gender}">
											${message("Member.Gender." + gender)}
										</label>
									[/#list]
								</div>
							[#elseif memberAttribute.type == "birth"]
								<input id="memberAttribute_${memberAttribute.id}" name="memberAttribute_${memberAttribute.id}" class="datepicker form-control" type="text">
							[#elseif memberAttribute.type == "area"]
								<div class="input-group">
									<input id="areaId" name="memberAttribute_${memberAttribute.id}" type="hidden">
								</div>
							[#elseif memberAttribute.type == "address"]
								<input id="memberAttribute_${memberAttribute.id}" name="memberAttribute_${memberAttribute.id}" class="form-control" type="text" maxlength="200">
							[#elseif memberAttribute.type == "zipCode"]
								<input id="memberAttribute_${memberAttribute.id}" name="memberAttribute_${memberAttribute.id}" class="form-control" type="text" maxlength="200">
							[#elseif memberAttribute.type == "phone"]
								<input id="memberAttribute_${memberAttribute.id}" name="memberAttribute_${memberAttribute.id}" class="form-control" type="text" maxlength="200">
							[#elseif memberAttribute.type == "text"]
								<input id="memberAttribute_${memberAttribute.id}" name="memberAttribute_${memberAttribute.id}" class="form-control" type="text" maxlength="200">
							[#elseif memberAttribute.type == "select"]
								<select id="memberAttribute_${memberAttribute.id}" name="memberAttribute_${memberAttribute.id}" class="form-control">
									<option value="">${message("member.common.choose")}</option>
									[#list memberAttribute.options as option]
										<option value="${option}">${option}</option>
									[/#list]
								</select>
							[#elseif memberAttribute.type == "checkbox"]
								<div class="checkbox">
									[#list memberAttribute.options as option]
										<label>
											<input name="memberAttribute_${memberAttribute.id}" type="checkbox" value="${option}">
											${option}
										</label>
									[/#list]
								</div>
							[/#if]
						</div>
					[/#list]
				[/@member_attribute_list]
				[#if setting.captchaTypes?? && setting.captchaTypes?seq_contains("memberRegister")]
					<div class="form-group">
						<label for="captcha">${message("common.captcha.name")}</label>
						<div class="input-group">
							<input id="captcha" name="captcha" class="captcha form-control" type="text" maxlength="4" autocomplete="off">
							<span class="input-group-btn"></span>
						</div>
					</div>
				[/#if]
				<button class="btn btn-lg btn-primary btn-block" type="submit">${message("member.register.submit")}</button>
			</form>
			<div class="row">
				<div class="col-xs-6 text-left">
					<a href="${base}/article/detail/1_1">${message("member.register.agreement")}</a>
				</div>
				<div class="col-xs-6 text-right">
					<a href="${base}/member/login">${message("member.register.login")}</a>
				</div>
			</div>
		</div>
	</main>
</body>
</html>