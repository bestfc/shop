<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html;charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("admin.login.title")} </title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/admin/css/login.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
<script type="text/javascript">
$().ready( function() {

	var $loginForm = $("#loginForm");
	var $username = $("#username");
	var $password = $("#password");
	var $captcha = $("#captcha");
	var $isRememberUsername = $("#isRememberUsername");
	var $submit = $("input:submit");
	
	// 记住用户名
	if (getCookie("adminUsername") != null) {
		$isRememberUsername.prop("checked", true);
		$username.val(getCookie("adminUsername"));
		$password.focus();
	} else {
		$isRememberUsername.prop("checked", false);
		$username.focus();
	}
	
	// 验证码图片
	$captcha.captchaImage();
	
	// 表单验证、记住用户名
	$loginForm.validate({
		rules: {
			username: "required",
			password: "required"
			[#if setting.captchaTypes?? && setting.captchaTypes?seq_contains("adminLogin")]
				,captcha: "required"
			[/#if]
		},
		submitHandler: function(form) {
			$.ajax({
				url: $loginForm.attr("action"),
				type: $loginForm.attr("method"),
				data: $loginForm.serialize(),
				dataType: "json",
				cache: false,
				beforeSend: function() {
					$submit.prop("disabled", true);
				},
				success: function(data) {
					if ($isRememberUsername.prop("checked")) {
						addCookie("adminUsername", $username.val(), {expires: 7 * 24 * 60 * 60});
					} else {
						removeCookie("adminUsername");
					}
					if (data.redirectUrl != null) {
						location.href = data.redirectUrl;
					} else {
						location.href = "${base}/";
					}
				},
				error: function(xhr, textStatus, errorThrown) {
					$submit.prop("disabled", false);
					[#if setting.captchaTypes?? && setting.captchaTypes?seq_contains("adminLogin")]
						$captcha.captchaImage("refresh", true);
					[/#if]
				}
			});
		}
	});

});
</script>
</head>
<body>
	<div class="login">
		<form id="loginForm" action="login" method="post">
			<table>
				<tr>
					<td width="190" rowspan="2" align="center" valign="bottom">
						<img src="${base}/resources/admin/images/login_logo.gif" alt="SHOP++" />
					</td>
					<th>
						${message("admin.login.username")}:
					</th>
					<td>
						<input type="text" id="username" name="username" class="text" maxlength="20" />
					</td>
				</tr>
				<tr>
					<th>
						${message("admin.login.password")}:
					</th>
					<td>
						<input type="password" id="password" name="password" class="text" maxlength="20" autocomplete="off" />
					</td>
				</tr>
				[#if setting.captchaTypes?? && setting.captchaTypes?seq_contains("adminLogin")]
					<tr>
						<td>
							&nbsp;
						</td>
						<th>
							${message("common.captcha.name")}:
						</th>
						<td>
							<span class="fieldSet"><input type="text" id="captcha" name="captcha" class="text captcha" maxlength="4" autocomplete="off" /></span>
						</td>
					</tr>
				[/#if]
				<tr>
					<td>
						&nbsp;
					</td>
					<th>
						&nbsp;
					</th>
					<td>
						<label>
							<input type="checkbox" id="isRememberUsername" value="true" />${message("admin.login.isRememberUsername")}
						</label>
					</td>
				</tr>
				<tr>
					<td>
						&nbsp;
					</td>
					<th>
						&nbsp;
					</th>
					<td>
						<input type="button" class="homeButton" value="" onclick="location.href='${base}/'" /><input type="submit" class="loginButton" value="${message("admin.login.login")}" />
					</td>
				</tr>
			</table>
			<div class="powered">COPYRIGHT © 2008-2017 SHOPXX.NET ALL RIGHTS RESERVED.</div>
			<div class="link">
				<a href="${base}/">${message("admin.login.home")}</a> |
				<a href="http://www.shopxx.net">${message("admin.login.official")}</a> |
				<a href="http://bbs.shopxx.net">${message("admin.login.bbs")}</a> |
				<a href="http://www.shopxx.net/about.html">${message("admin.login.about")}</a> |
				<a href="http://www.shopxx.net/contact.html">${message("admin.login.contact")}</a> |
				<a href="http://www.shopxx.net/license.html">${message("admin.login.license")}</a>
			</div>
		</form>
	</div>
</body>
</html>