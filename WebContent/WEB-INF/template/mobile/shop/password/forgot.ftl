<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("shop.password.forgot")}[#if showPowered] [/#if]</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/mobile/shop/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/animate.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/common.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/password.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/mobile/shop/js/html5shiv.js"></script>
		<script src="${base}/resources/mobile/shop/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/mobile/shop/js/jquery.js"></script>
	<script src="${base}/resources/mobile/shop/js/bootstrap.js"></script>
	<script src="${base}/resources/mobile/shop/js/jquery.validate.js"></script>
	<script src="${base}/resources/mobile/shop/js/underscore.js"></script>
	<script src="${base}/resources/mobile/shop/js/common.js"></script>
	<script type="text/javascript">
	$().ready(function() {
	
		var $passwordForm = $("#passwordForm");
		var $username = $("#username");
		var $email = $("#email");
		var $captcha = $("#captcha");
		var $submit = $("button:submit");
		
		// 验证码图片
		$captcha.captchaImage();
		
		// 表单验证
		$passwordForm.validate({
			rules: {
				username: "required",
				email: {
					required: true,
					email: true
				},
				captcha: "required"
			},
			submitHandler: function(form) {
				$.ajax({
					url: $passwordForm.attr("action"),
					type: "POST",
					data: $passwordForm.serialize(),
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
<body class="password">
	<header class="header-fixed">
		<a class="pull-left" href="javascript: history.back();">
			<span class="glyphicon glyphicon-menu-left"></span>
		</a>
		${message("shop.password.forgot")}
	</header>
	<main>
		<div class="container-fluid">
			<form id="passwordForm" action="forgot" method="post">
				<input name="type" type="hidden" value="member" />
				<div class="form-group">
					<label for="username">${message("shop.password.username")}</label>
					<input id="username" name="username" class="form-control" type="text" maxlength="200">
				</div>
				<div class="form-group">
					<label for="email">${message("shop.password.email")}</label>
					<input id="email" name="email" class="form-control" type="text" maxlength="200">
				</div>
				[#if setting.captchaTypes?? && setting.captchaTypes?seq_contains("forgotPassword")]
					<div class="form-group">
						<label for="captcha">${message("common.captcha.name")}</label>
						<div class="input-group">
							<input id="captcha" name="captcha" class="captcha form-control" type="text" maxlength="4" autocomplete="off">
							<span class="input-group-btn"></span>
						</div>
					</div>
				[/#if]
				<div class="text-center">
					<button class="btn btn-lg btn-primary btn-block" type="submit">${message("shop.password.submit")}</button>
				</div>
			</form>
		</div>
	</main>
</body>
</html>