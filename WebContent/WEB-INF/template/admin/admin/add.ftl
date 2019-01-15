<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html;charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("admin.admin.add")} </title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.tools.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/input.js"></script>
<style type="text/css">
.roles label {
	width: 150px;
	display: block;
	float: left;
	padding-right: 6px;
}
</style>
<script type="text/javascript">
$().ready(function() {

	var $inputForm = $("#inputForm");
	
	[@flash_message /]
	
	$.validator.addMethod("notAllNumber",
		function(value, element) {
			return this.optional(element) || /^.*[^\d].*$/.test(value);
		},
		"${message("admin.admin.notAllNumber")}"
	);
	
	// 表单验证
	$inputForm.validate({
		rules: {
			username: {
				required: true,
				minlength: 4,
				pattern: /^[0-9a-zA-Z_\u4e00-\u9fa5]+$/,
				notAllNumber: true,
				remote: {
					url: "check_username",
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
					url: "check_email",
					cache: false
				}
			},
			roleIds: "required"
		},
		messages: {
			username: {
				pattern: "${message("common.validate.illegal")}",
				remote: "${message("common.validate.exist")}"
			},
			email: {
				remote: "${message("common.validate.exist")}"
			}
		}
	});

});
</script>
</head>
<body>
	<div class="breadcrumb">
		${message("admin.admin.add")}
	</div>
	<form id="inputForm" action="save" method="post">
		<ul id="tab" class="tab">
			<li>
				<input type="button" value="${message("admin.admin.base")}" />
			</li>
			<li>
				<input type="button" value="${message("admin.admin.profile")}" />
			</li>
		</ul>
		<table class="input tabContent">
			<tr>
				<th>
					<span class="requiredField">*</span>${message("Admin.username")}:
				</th>
				<td>
					<input type="text" name="username" class="text" maxlength="20" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("Admin.password")}:
				</th>
				<td>
					<input type="password" id="password" name="password" class="text" maxlength="20" autocomplete="off" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("admin.admin.rePassword")}:
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
					<input type="text" name="email" class="text" maxlength="200" />
				</td>
			</tr>
			<tr class="roles">
				<th>
					<span class="requiredField">*</span>${message("Admin.roles")}:
				</th>
				<td>
					<span class="fieldSet">
						[#list roles as role]
							<label>
								<input type="checkbox" name="roleIds" value="${role.id}" />${role.name}
							</label>
						[/#list]
					</span>
				</td>
			</tr>
			<tr>
				<th>
					${message("admin.common.setting")}:
				</th>
				<td>
					<label>
						<input type="checkbox" name="isEnabled" value="true" checked="checked" />${message("User.isEnabled")}
						<input type="hidden" name="_isEnabled" value="false" />
					</label>
				</td>
			</tr>
		</table>
		<table class="input tabContent">
			<tr>
				<th>
					${message("Admin.department")}:
				</th>
				<td>
					<input type="text" name="department" class="text" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Admin.name")}:
				</th>
				<td>
					<input type="text" name="name" class="text" maxlength="200" />
				</td>
			</tr>
		</table>
		<table class="input">
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