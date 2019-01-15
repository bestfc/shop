<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("admin.storeRank.edit")} </title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.tools.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/input.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $inputForm = $("#inputForm");
	
	[@flash_message /]
	
	// 表单验证
	$inputForm.validate({
		rules: {
			name: {
				required: true,
				remote: {
					url: "check_name?id=${storeRank.id}",
					cache: false
				}
			},
			serviceFee: {
				required: true,
				min: 0,
				decimal: {
					integer: 12,
					fraction: ${setting.priceScale}
				}
			},
			quantity: "digits",
			order: "digits"
		},
		messages: {
			name: {
				remote: "${message("common.validate.exist")}"
			}
		}
	});

});
</script>
</head>
<body>
	<div class="breadcrumb">
		<a href="${base}/admin/index">${message("admin.breadcrumb.home")}</a> &raquo; ${message("admin.storeRank.edit")}
	</div>
	<form id="inputForm" action="update" method="post">
		<input type="hidden" name="id" value="${storeRank.id}" />
		<table class="input">
			<tr>
				<th>
					<span class="requiredField">*</span>${message("StoreRank.name")}:
				</th>
				<td>
					<input type="text" name="name" value="${storeRank.name}" class="text" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("StoreRank.serviceFee")}:
				</th>
				<td>
					<input type="text" name="serviceFee" value="${storeRank.serviceFee}" class="text" maxlength="16" />
				</td>
			</tr>
			<tr>
				<th>
					${message("StoreRank.quantity")}:
				</th>
				<td>
					<input type="text" name="quantity" value="${storeRank.quantity}" class="text" maxlength="16" title="${message("admin.storeRank.unlimited")}" />
				</td>
			</tr>
			<tr>
				<th>
					${message("StoreRank.memo")}:
				</th>
				<td>
					<input type="text" name="memo" value="${storeRank.memo}" class="text" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					${message("admin.common.order")}:
				</th>
				<td>
					<input type="text" name="order" value="${storeRank.order}" class="text" maxlength="9" />
				</td>
			</tr>
			<tr>
				<th>
					${message("admin.common.setting")}:
				</th>
				<td>
					<label>
						<input type="checkbox" name="isAllowRegister" value="true"[#if storeRank.isAllowRegister] checked="checked"[/#if] />${message("StoreRank.isAllowRegister")}
						<input type="hidden" name="_isAllowRegister" value="false" />
					</label>
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