<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("shop.password.reset")}[#if showPowered] [/#if]</title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/shop/css/animate.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/password.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/shop/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/common.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $passwordForm = $("#passwordForm");
	var $password = $("#password");
	var $captcha = $("#captcha");
	var $submit = $("input:submit");
	
	// 验证码图片
	$captcha.captchaImage();
	
	// 表单验证
	$passwordForm.validate({
		rules: {
			newPassword: {
				required: true,
				minlength: 4
			},
			rePassword: {
				required: true,
				equalTo: "#newPassword"
			},
			captcha: "required"
		},
		submitHandler: function(form) {
			$.ajax({
				url: $passwordForm.attr("action"),
				type: "POST",
				data: $passwordForm.serialize(),
				dataType: "json",
				cache: false,
				beforeSend: function() {
					$submit.prop("disabled", true);
				},
				success: function(message) {
					setTimeout(function() {
						$submit.prop("disabled", false);
						location.href = "${base}/";
					}, 3000);
				},
				error: function(xhr, textStatus, errorThrown) {
					setTimeout(function() {
						$submit.prop("disabled", false);
					}, 3000);
					$captcha.captchaImage("refresh", true);
				}
			});
		}
	});

});
</script>
</head>
<body>
	[#include "/shop/include/header.ftl" /]
	<div class="container password">
		<div class="row">
			<div class="span12">
				<div class="wrap">
					<div class="main">
						<div class="title">
							<strong>${message("shop.password.reset")}</strong>RESET PASSWORD
						</div>
						<form id="passwordForm" action="reset" method="post">
							<input type="hidden" name="username" value="${user.username}" />
							<input type="hidden" name="key" value="${key}" />
							<input type="hidden" name="type" value="${type}" />
							<table>
								<tr>
									<th>
										${message("shop.password.username")}:
									</th>
									<td>
										${user.username}
									</td>
								</tr>
								<tr>
									<th>
										<span class="requiredField">*</span>${message("shop.password.newPassword")}:
									</th>
									<td>
										<input type="password" id="newPassword" name="newPassword" class="text" maxlength="20" autocomplete="off" />
									</td>
								</tr>
								<tr>
									<th>
										<span class="requiredField">*</span>${message("shop.password.rePassword")}:
									</th>
									<td>
										<input type="password" name="rePassword" class="text" maxlength="20" autocomplete="off" />
									</td>
								</tr>
								[#if setting.captchaTypes?? && setting.captchaTypes?seq_contains("resetPassword")]
									<tr>
										<th>
											<span class="requiredField">*</span>${message("shop.captcha.name")}:
										</th>
										<td>
											<span class="fieldSet">
												<input type="text" id="captcha" name="captcha" class="text captcha" maxlength="4" autocomplete="off" />
											</span>
										</td>
									</tr>
								[/#if]
								<tr>
									<th>
										&nbsp;
									</th>
									<td>
										<input type="submit" class="submit" value="${message("shop.password.submit")}" />
									</td>
								</tr>
							</table>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
	[#include "/shop/include/footer.ftl" /]
</body>
</html>