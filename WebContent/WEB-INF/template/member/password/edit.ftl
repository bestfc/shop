<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("member.password.edit")}[#if showPowered] [/#if]</title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/member/css/animate.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/member/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/member/css/member.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/member/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/member/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/member/js/common.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $inputForm = $("#inputForm");
	
	[#if flashMessage?has_content]
		$.alert("${flashMessage}");
	[/#if]
	
	$.validator.addMethod("notAllowBlank",
		function(value, element) {
			return this.optional(element) || /^\S*$/.test(value);
		},
		"${message("common.validate.illegal")}"
	);
	
	// 表单验证
	$inputForm.validate({
		rules: {
			currentPassword: {
				required: true,
				remote: {
					url: "check_current_password",
					cache: false
				}
			},
			password: {
				required: true,
				notAllowBlank: true,
				minlength: 4
			},
			rePassword: {
				required: true,
				notAllowBlank: true,
				equalTo: "#password"
			}
		}
	});

});
</script>
</head>
<body>
	[#assign current = "passwordEdit" /]
	[#include "/shop/include/header.ftl" /]
	<div class="container member">
		<div class="row">
			[#include "/member/include/navigation.ftl" /]
			<div class="span10">
				<div class="input">
					<div class="title">${message("member.password.edit")}</div>
					<form id="inputForm" action="update" method="post">
						<table class="input">
							<tr>
								<th>
									<span class="requiredField">*</span>${message("member.password.currentPassword")}:
								</th>
								<td>
									<input type="password" name="currentPassword" class="text" maxlength="200" autocomplete="off" />
								</td>
							</tr>
							<tr>
								<th>
									<span class="requiredField">*</span>${message("member.password.newPassword")}:
								</th>
								<td>
									<input type="password" id="password" name="password" class="text" maxlength="20" autocomplete="off" />
								</td>
							</tr>
							<tr>
								<th>
									<span class="requiredField">*</span>${message("member.password.rePassword")}:
								</th>
								<td>
									<input type="password" name="rePassword" class="text" maxlength="20" autocomplete="off" />
								</td>
							</tr>
							<tr>
								<th>
									&nbsp;
								</th>
								<td>
									<input type="submit" class="button" value="${message("member.common.submit")}" />
									<input type="button" class="button" value="${message("member.common.back")}" onclick="history.back(); return false;" />
								</td>
							</tr>
						</table>
					</form>
				</div>
			</div>
		</div>
	</div>
	[#include "/shop/include/footer.ftl" /]
</body>
</html>