<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("admin.profile.edit")} </title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/input.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $inputForm = $("#inputForm");
	
	[@flash_message /]
	
	$.validator.addMethod("requiredTo", 
		function(value, element, param) {
			var parameterValue = $(param).val();
			if ($.trim(parameterValue) == "" || ($.trim(parameterValue) != "" && $.trim(value) != "")) {
				return true;
			} else {
				return false;
			}
		},
		"${message("admin.profile.requiredTo")}"
	);
	
	// 表单验证
	$inputForm.validate({
		rules: {
			currentPassword: {
				requiredTo: "#password",
				remote: {
					url: "check_current_password",
					cache: false
				}
			},
			password: {
				minlength: 4
			},
			rePassword: {
				equalTo: "#password"
			},
			email: {
				required: true,
				email: true
			}
		}
	});

});
</script>
</head>
<body>
	<div class="breadcrumb">
		<a href="${base}/admin/index">${message("admin.breadcrumb.home")}</a> &raquo; ${message("admin.profile.edit")}
	</div>
	<form id="inputForm" action="update" method="post">
		<table class="input">
			<tr>
				<th>
					${message("Admin.username")}:
				</th>
				<td>
					${admin.username}
				</td>
			</tr>
			<tr>
				<th>
					${message("Admin.name")}:
				</th>
				<td>
					${admin.name}
				</td>
			</tr>
			<tr>
				<th>
					${message("Admin.department")}:
				</th>
				<td>
					${admin.department}
				</td>
			</tr>
			<tr>
				<th>
					${message("admin.profile.currentPassword")}:
				</th>
				<td>
					<input type="password" name="currentPassword" class="text" maxlength="20" autocomplete="off" />
				</td>
			</tr>
			<tr>
				<th>
					${message("admin.profile.password")}:
				</th>
				<td>
					<input type="password" id="password" name="password" class="text" maxlength="20" autocomplete="off" />
				</td>
			</tr>
			<tr>
				<th>
					${message("admin.profile.rePassword")}:
				</th>
				<td>
					<input type="password" name="rePassword" class="text" maxlength="20" autocomplete="off" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("Admin.email")}:
				</th>
				<td>
					<input type="text" name="email" class="text" value="${admin.email}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					&nbsp;
				</th>
				<td>
					<span class="tips">${message("admin.profile.tips")}</span>
				</td>
			</tr>
			<tr>
				<th>
					&nbsp;
				</th>
				<td>
					<input type="submit" class="button" value="${message("admin.common.submit")}" />
					<input type="button" class="button" value="${message("admin.common.back")}" onclick="history.back(); return false;" />
				</td>
			</tr>
		</table>
	</form>
</body>
</html>