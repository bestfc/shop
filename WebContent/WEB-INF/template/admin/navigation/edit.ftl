<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("admin.navigation.edit")} </title>
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
	var $systemUrl = $("#systemUrl");
	var $url = $("#url");
	
	[@flash_message /]

	// 系统内容
	$systemUrl.change(function() {
		$url.val($systemUrl.val());
	});
	
	// 链接地址
	$url.keypress(function() {
		$systemUrl.val("");
	});
	
	// 表单验证
	$inputForm.validate({
		rules: {
			name: "required",
			url: {
				required: true,
				pattern: /^(http:\/\/|https:\/\/|ftp:\/\/|mailto:|\/|#).*$/i
			},
			order: "digits"
		}
	});

});
</script>
</head>
<body>
	<div class="breadcrumb">
		<a href="${base}/admin/index">${message("admin.breadcrumb.home")}</a> &raquo; ${message("admin.navigation.edit")}
	</div>
	<form id="inputForm" action="update" method="post">
		<input type="hidden" name="id" value="${navigation.id}" />
		<table class="input">
			<tr>
				<th>
					<span class="requiredField">*</span>${message("Navigation.name")}:
				</th>
				<td>
					<input type="text" id="name" name="name" class="text" value="${navigation.name}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					${message("admin.navigation.systemUrl")}:
				</th>
				<td>
					<select id="systemUrl">
						<option value="">------------</option>
						<option value="${base}/"[#if navigation.url == base + "/"] selected="selected"[/#if]>${message("admin.navigation.home")}</option>
						<option value="${base}/product_category"[#if navigation.url == base + "/product_category"] selected="selected"[/#if]>${message("admin.navigation.productCategory")}</option>
						<option value="${base}/friend_link"[#if navigation.url == base + "/friend_link"] selected="selected"[/#if]>${message("admin.navigation.friendLink")}</option>
						<option value="${base}/member/index"[#if navigation.url == base + "/member/index"] selected="selected"[/#if]>${message("admin.navigation.member")}</option>
						<option value="${base}/business/index"[#if navigation.url == base + "/business/index"] selected="selected"[/#if]>${message("admin.navigation.business")}</option>
						[#list articleCategoryTree as articleCategory]
							<option value="${base}${articleCategory.path}"[#if base + articleCategory.path == navigation.url] selected="selected"[/#if]>
								[#if articleCategory.grade != 0]
									[#list 1..articleCategory.grade as i]
										&nbsp;&nbsp;
									[/#list]
								[/#if]
								${articleCategory.name}
							</option>
						[/#list]
						[#list productCategoryTree as productCategory]
							<option value="${base}${productCategory.path}"[#if base + productCategory.path == navigation.url] selected="selected"[/#if]>
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
					<span class="requiredField">*</span>${message("Navigation.url")}:
				</th>
				<td>
					<input type="text" id="url" name="url" class="text" value="${navigation.url}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Navigation.position")}:
				</th>
				<td>
					<select name="position">
						[#list positions as position]
							<option value="${position}"[#if position == navigation.position] selected="selected"[/#if]>${message("Navigation.Position." + position)}</option>
						[/#list]
					</select>
				</td>
			</tr>
			<tr>
				<th>
					${message("admin.common.setting")}:
				</th>
				<td>
					<label>
						<input type="checkbox" name="isBlankTarget" value="true"[#if navigation.isBlankTarget] checked="checked"[/#if] />${message("Navigation.isBlankTarget")}
						<input type="hidden" name="_isBlankTarget" value="false" />
					</label>
				</td>
			</tr>
			<tr>
				<th>
					${message("admin.common.order")}:
				</th>
				<td>
					<input type="text" name="order" class="text" value="${navigation.order}" maxlength="9" />
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