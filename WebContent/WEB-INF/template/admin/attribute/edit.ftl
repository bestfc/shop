<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("admin.attribute.edit")} </title>
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
	var $addOptionButton = $("#addOptionButton");
	var $optionTable = $("#optionTable");
	
	[@flash_message /]
	
	// 增加可选项
	$addOptionButton.click(function() {
		$optionTable.append(
			[@compress single_line = true]
				'<tr>
					<td>
						<input type="text" name="options" class="text" maxlength="200" \/>
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
	
	// 表单验证
	$inputForm.validate({
		rules: {
			name: "required",
			order: "digits",
			options: "required"
		}
	});

});
</script>
</head>
<body>
	<div class="breadcrumb">
		<a href="${base}/admin/index">${message("admin.breadcrumb.home")}</a> &raquo; ${message("admin.attribute.edit")}
	</div>
	<form id="inputForm" action="update" method="post">
		<input type="hidden" name="id" value="${attribute.id}" />
		<table class="input">
			<tr>
				<th>
					${message("Attribute.productCategory")}:
				</th>
				<td>
					${attribute.productCategory.name}
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("Attribute.name")}:
				</th>
				<td>
					<input type="text" name="name" class="text" value="${attribute.name}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					${message("admin.common.order")}:
				</th>
				<td>
					<input type="text" name="order" class="text" value="${attribute.order}" maxlength="9" />
				</td>
			</tr>
			<tr>
				<th>
					&nbsp;
				</th>
				<td>
					<a href="javascript:;" id="addOptionButton" class="button">${message("admin.attribute.addOption")}</a>
				</td>
			</tr>
			<tr>
				<th>
					&nbsp;
				</th>
				<td>
					<table id="optionTable" class="item">
						<tr>
							<th>
								${message("Attribute.options")}
							</th>
							<th>
								${message("admin.common.action")}
							</th>
						</tr>
						[#list attribute.options as option]
							<tr>
								<td>
									<input type="text" name="options" class="text" value="${option}" maxlength="200" />
								</td>
								<td>
									<a href="javascript:;" class="remove">[${message("admin.common.delete")}]</a>
								</td>
							</tr>
						[/#list]
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