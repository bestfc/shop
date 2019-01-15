<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("admin.parameter.add")} </title>
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
	var $addNameButton = $("#addNameButton");
	var $nameTable = $("#nameTable");
	
	[@flash_message /]
	
	// 增加参数名称
	$addNameButton.click(function() {
		$nameTable.append(
			[@compress single_line = true]
				'<tr>
					<td>
						<input type="text" name="names" class="text" maxlength="200" \/>
					<\/td>
					<td>
						<a href="javascript:;" class="remove">[${message("admin.common.delete")}]<\/a>
					<\/td>
				<\/tr>'
			[/@compress]
		);
	});
	
	// 删除参数名称
	$nameTable.on("click", "a.remove", function() {
		if ($nameTable.find("tr").size() <= 2) {
			$.message("warn", "${message("admin.common.deleteAllNotAllowed")}");
			return false;
		}
		$(this).closest("tr").remove();
	});
	
	// 表单验证
	$inputForm.validate({
		rules: {
			productCategoryId: "required",
			group: "required",
			order: "digits",
			names: "required"
		}
	});

});
</script>
</head>
<body>
	<div class="breadcrumb">
		<a href="${base}/admin/index">${message("admin.breadcrumb.home")}</a> &raquo; ${message("admin.parameter.add")}
	</div>
	<form id="inputForm" action="save" method="post">
		<table class="input">
			<tr>
				<th>
					${message("Parameter.productCategory")}:
				</th>
				<td>
					<select name="productCategoryId">
						[#list productCategoryTree as productCategory]
							<option value="${productCategory.id}">
								[#if productCategory.grade != 0]
									[#list 1..productCategory.grade as i]
										&nbsp;&nbsp;
									[/#list]
								[/#if]
								${productCategory.name}
							</option>
						[/#list]
					</select>
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("Parameter.group")}:
				</th>
				<td>
					<input type="text" name="group" class="text" maxlength="200" />
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
					&nbsp;
				</th>
				<td>
					<a href="javascript:;" id="addNameButton" class="button">${message("admin.parameter.addName")}</a>
				</td>
			</tr>
			<tr>
				<th>
					&nbsp;
				</th>
				<td>
					<table id="nameTable" class="item">
						<tr>
							<th>
								${message("Parameter.names")}
							</th>
							<th>
								${message("admin.common.action")}
							</th>
						</tr>
						[#if sample??]
							[#list sample.names as name]
								<tr>
									<td>
										<input type="text" name="names" class="text" value="${name}" maxlength="200" />
									</td>
									<td>
										<a href="javascript:;" class="remove">[${message("admin.common.delete")}]</a>
									</td>
								</tr>
							[/#list]
						[#else]
							<tr>
								<td>
									<input type="text" name="names" class="text" maxlength="200" />
								</td>
								<td>
									<a href="javascript:;" class="remove">[${message("admin.common.delete")}]</a>
								</td>
							</tr>
						[/#if]
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