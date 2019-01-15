<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.login.title")}[#if showPowered] [/#if]</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/mobile/member/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/animate.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/common.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/login.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/mobile/member/js/html5shiv.js"></script>
		<script src="${base}/resources/mobile/member/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/mobile/member/js/jquery.js"></script>
	<script src="${base}/resources/mobile/member/js/bootstrap.js"></script>
	<script src="${base}/resources/mobile/member/js/velocity.js"></script>
	<script src="${base}/resources/mobile/member/js/velocity.ui.js"></script>
	<script src="${base}/resources/mobile/member/js/jquery.validate.js"></script>
	<script src="${base}/resources/mobile/member/js/underscore.js"></script>
	<script src="${base}/resources/mobile/member/js/common.js"></script>
	<script type="text/javascript">
	$().ready(function() {
		
		var $loginForm = $("#loginForm");
		var $input = $("input");
		var $username = $("#username");
		var $password = $("#password");
		var $captcha = $("#captcha");
		var $isRememberUsername = $("#isRememberUsername");
		var $submit = $("button:submit");
		var $footer = $("footer");
		
		// 记住用户名
		if (getCookie("memberUsername") != null) {
			$isRememberUsername.prop("checked", true);
			$username.val(getCookie("memberUsername"));
			$password.focus();
		} else {
			$isRememberUsername.prop("checked", false);
			$username.focus();
		}
		
		// 输入框
		$input.focus(function() {
			$footer.css("position", "static");
		}).blur(function() {
			$footer.css("position", "fixed");
		});
		
		// 验证码图片
		$captcha.captchaImage();
		
		// 底部
		$footer.velocity("transition.slideUpBigIn");
		
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
							addCookie("memberUsername", $username.val(), {
								expires: 7 * 24 * 60 * 60
							});
						} else {
							removeCookie("memberUsername");
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
	<header class="header-fixed">
		<a class="pull-left" href="javascript: history.back();">
			<span class="glyphicon glyphicon-menu-left"></span>
		</a>
		[#if socialUserId?has_content && uniqueId?has_content]
			${message("member.login.bind")}
		[#else]
			${message("member.login.title")}
		[/#if]
	</header>
	<main>
		<div class="container-fluid">
			<form id="loginForm" action="${base}/member/login" method="post">
				<input name="socialUserId" type="hidden" value="${socialUserId}">
				<input name="uniqueId" type="hidden" value="${uniqueId}">
				<div class="form-group">
					<div class="input-group">
						<div class="input-group-addon">
							<span class="glyphicon glyphicon-user"></span>
						</div>
						<input id="username" name="username" class="form-control" type="text" maxlength="20" placeholder="${message("member.login.usernameTitle")}">
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<div class="input-group-addon">
							<span class="glyphicon glyphicon-lock"></span>
						</div>
						<input id="password" name="password" class="form-control" type="password" maxlength="20" placeholder="${message("member.login.password")}" autocomplete="off">
					</div>
				</div>
				[#if setting.captchaTypes?? && setting.captchaTypes?seq_contains("memberLogin")]
					<div class="form-group">
						<div class="input-group">
							<div class="input-group-addon">
								<span class="glyphicon glyphicon-picture"></span>
							</div>
							<input id="captcha" name="captcha" class="captcha form-control" type="text" maxlength="4" placeholder="${message("common.captcha.name")}" autocomplete="off">
							<span class="input-group-btn"></span>
						</div>
					</div>
				[/#if]
				<div class="checkbox">
					<label>
						<input id="isRememberUsername" name="isRememberUsername" type="checkbox" value="true">
						${message("member.login.isRememberUsername")}
					</label>
				</div>
				[#if socialUserId?has_content && uniqueId?has_content]
					<button class="btn btn-lg btn-primary btn-block" type="submit">${message("member.login.bind")}</button>
				[#else]
					<button class="btn btn-lg btn-primary btn-block" type="submit">${message("member.login.submit")}</button>
				[/#if]
			</form>
			<div class="row">
				<div class="col-xs-6 text-left">
				[#if socialUserId?has_content && uniqueId?has_content]
					<a href="${base}/member/register?socialUserId=${socialUserId}&uniqueId=${uniqueId}">${message("member.login.registerBind")}</a>
				[#else]
					<a href="${base}/member/register">${message("member.login.register")}</a>
				[/#if]
				</div>
				<div class="col-xs-6 text-right">
					<a href="${base}/password/forgot?type=member">${message("member.login.forgotPassword")}</a>
				</div>
			</div>
		</div>
	</main>
	<footer class="text-center">
		[#if loginPlugins?has_content && !socialUserId?has_content && !uniqueId?has_content]
			[#list loginPlugins as loginPlugin]
				<a href="${base}/social_user_login?loginPluginId=${loginPlugin.id}"[#if loginPlugin.description??] title="${loginPlugin.description}"[/#if]>
					[#if loginPlugin.logo?has_content]
						<img src="${loginPlugin.logo}" alt="${loginPlugin.loginMethodName}">
					[#else]
						${loginPlugin.loginMethodName}
					[/#if]
				</a>
			[/#list]
		[/#if]
	</footer>
</body>
</html>