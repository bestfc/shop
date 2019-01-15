<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("business.login.title")} </title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/business/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/business/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/business/css/adminLTE.css" rel="stylesheet">
	<link href="${base}/resources/business/css/common.css" rel="stylesheet">
	<link href="${base}/resources/business/css/login.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/business/js/html5shiv.js"></script>
		<script src="${base}/resources/business/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/business/js/jquery.js"></script>
	<script src="${base}/resources/business/js/bootstrap.js"></script>
	<script src="${base}/resources/business/js/jquery.validate.js"></script>
	<script src="${base}/resources/business/js/icheck.js"></script>
	<script src="${base}/resources/business/js/adminLTE.js"></script>
	<script src="${base}/resources/business/js/common.js"></script>
	<script type="text/javascript">
	$().ready(function() {
		
		var $loginForm = $("#loginForm");
		var $username = $("input[name='username']");
		var $password = $("input[name='password']");
		var $captcha = $("#captcha");
		var $isRememberUsername = $("input[name='isRememberUsername']");
		var $submit = $("button[type='submit']");
		
		// 记住用户名
		if (getCookie("businessUsername") != null) {
			$isRememberUsername.iCheck("check");
			$username.val(getCookie("businessUsername"));
			$password.focus();
		} else {
			$isRememberUsername.iCheck("uncheck");
			$username.focus();
		}
		
		// 验证码图片
		$captcha.captchaImage();
		
		// 表单验证、记住用户名
		$loginForm.validate({
			rules: {
				username: "required",
				password: "required",
				captcha: "required"
			},
			submitHandler: function(form) {
				$.ajax({
					url: $loginForm.attr("action"),
					type: "POST",
					data: $loginForm.serialize(),
					dataType: "json",
					beforeSend: function() {
						$submit.prop("disabled", true);
					},
					success: function(data) {
						if ($isRememberUsername.prop("checked")) {
							addCookie("businessUsername", $username.val(), {
								expires: 7 * 29 * 60 * 60
							});
						} else {
							removeCookie("businessUsername");
						}
						[#if redirectUrl?has_content]
							location.href = "${redirectUrl?js_string}";
						[#else]
							if (data.redirectUrl != null) {
								location.href = data.redirectUrl;
							} else {
								location.href = "${base}/";
							}
						[/#if]
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
<body class="login">
	[#include "/business/include/header.ftl" /]
	<main>
		<div class="container">
			<div class="row">
				<div class="col-xs-5 col-xs-offset-7">
					<div class="box">
						<div class="box-body">
							<form id="loginForm" action="${base}/business/login" method="post">
								<div class="form-group">
									<div class="input-group">
										<span class="input-group-addon">
											<i class="glyphicon glyphicon-user gray-lighter"></i>
										</span>
										<input name="username" class="form-control" type="text" maxlength="200" placeholder="${message("business.login.usernameTitle")}">
									</div>
								</div>
								<div class="form-group">
									<div class="input-group">
										<span class="input-group-addon">
											<i class="glyphicon glyphicon-lock gray-lighter"></i>
										</span>
										<input name="password" class="form-control" type="password" maxlength="200" placeholder="${message("business.login.password")}" autocomplete="off">
									</div>
								</div>
								[#if setting.captchaTypes?? && setting.captchaTypes?seq_contains("businessLogin")]
									<div class="form-group">
										<div class="input-group">
											<div class="input-group-addon">
												<span class="glyphicon glyphicon-picture gray-lighter"></span>
											</div>
											<input id="captcha" name="captcha" class="captcha form-control" type="text" maxlength="4" placeholder="${message("common.captcha.name")}" autocomplete="off">
											<div class="input-group-btn"></div>
										</div>
									</div>
								[/#if]
								<div class="form-group">
									<input id="isRememberUsername" name="isRememberUsername" class="icheck" type="checkbox" value="true">
									<label for="isRememberUsername">${message("business.login.isRememberUsername")}</label>
									<a class="pull-right" href="${base}/password/forgot?type=business">${message("business.login.forgotPassword")}</a>
								</div>
								<div class="form-group">
									<button class="btn btn-primary btn-block bg-orange" type="submit">${message("business.login.submit")}</button>
								</div>
								<div class="form-group">${message("business.login.noAccount")}${message("business.login.tips")}</div>
								<div class="form-group">
									<a class="text-orange" href="${base}/business/register">${message("business.login.register")}</a>
								</div>
							</form>
						</div>
					</div>
				</div>
			</div>
		</div>
	</main>
	[#include "/business/include/footer.ftl" /]
</body>
</html>