<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html;charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("admin.memberAttribute.add")} </title>
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
	var $type = $("#type");
	var $pattern = $("#pattern");
	var $addOptionButton = $("#addOptionButton");
	var $optionTable = $("#optionTable");
	
	[@flash_message /]
	
	// 类型
	$type.change(function() {
		if ($type.val() == "select" || $type.val() == "checkbox") {
			$pattern.prop("disabled", true).closest("tr").hide();
			$addOptionButton.closest("tr").show();
			$optionTable.show().find(":input").prop("disabled", false);
		} else {
			$pattern.prop("disabled", false).closest("tr").show();
			$addOptionButton.closest("tr").hide();
			$optionTable.hide().find(":input").prop("disabled", true);
		}
	});
	
	// 增加可选项
	$addOptionButton.click(function() {
		$optionTable.append(
			[@compress single_line = true]
				'<tr>
					<td>
						<input type="text" name="options" class="text options" maxlength="200" \/>
					<\/td>
					<td>
						<a href="javascript:;" class="remove">[${message("admin.common.delete")}]<\/a>
					<\/td>
				<\/tr>'
			[/@compress]
		);
	});
	
	// 删除可选项
	$optionTable.on("click", "a.remove", function() {
		if ($optionTable.find("tr").size() <= 2) {
			$.message("warn", "${message("admin.common.deleteAllNotAllowed")}");
			return false;
		}
		$(this).closest("tr").remove();
	});
	
	$.validator.addClassRules({
		options: {
			required: true
		}
	});
	
	// 表单验证
	$inputForm.validate({
		rules: {
			type: "required",
			name: "required",
			pattern: {
				remote: {
					url: "check_pattern",
					cache: false
				}
			},
			order: "digits"
		},
		messages: {
			pattern: {
				remote: "${message("admin.memberAttribute.syntaxError")}"
			}
		}
	});

});
</script>
</head>
<body>
	<div class="breadcrumb">
		${message("admin.memberAttribute.add")}
	</div>
	<form id="inputForm" action="save" method="post">
		<table class="input">
			<tr>
				<th>
					<span class="requiredField">*</span>${message("MemberAttribute.name")}:
				</th>
				<td>
					<input type="text" name="name" class="text" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					${message("MemberAttribute.type")}:
				</th>
				<td>
					<select id="type" name="type">
						<option value="text">${message("MemberAttribute.Type.text")}</option>
						<option value="select">${message("MemberAttribute.Type.select")}</option>
						<option value="checkbox">${message("MemberAttribute.Type.checkbox")}</option>
					</select>
				</td>
			</tr>
			<tr>
				<th>
					${message("MemberAttribute.pattern")}:
				</th>
				<td>
					<input type="text" id="pattern" name="pattern" class="text" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					${message("admin.common.order")}:
				</th>
				<td>
					<input type="text" name="order" class="text" maxlength="9" />
				</td>
			</tr>
			<tr>
				<th>
					${message("admin.common.setting")}:
				</th>
				<td>
					<label>
						<input type="checkbox" name="isEnabled" value="true" checked="checked" />${message("MemberAttribute.isEnabled")}
						<input type="hidden" name="_isEnabled" value="false" />
					</label>
					<label>
						<input type="checkbox" name="isRequired" value="true" />${message("MemberAttribute.isRequired")}
						<input type="hidden" name="_isRequired" value="false" />
					</label>
				</td>
			</tr>
			<tr class="hidden">
				<th>
					&nbsp;
				</th>
				<td>
					<a href="javascript:;" id="addOptionButton" class="button">${message("admin.memberAttribute.addOption")}</a>
				</td>
			</tr>
			<tr>
				<th>
					&nbsp;
				</th>
				<td>
					<table id="optionTable" class="item hidden">
						<tr>
							<th>
								${message("MemberAttribute.options")}
							</th>
							<th>
								${message("admin.common.action")}
							</th>
						</tr>
						<tr>
							<td>
								<input type="text" name="options" class="text options" maxlength="200" disabled="disabled" />
							</td>
							<td>
								<a href="javascript:;" class="remove">[${message("admin.common.delete")}]</a>
							</td>
						</tr>
					</table>
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