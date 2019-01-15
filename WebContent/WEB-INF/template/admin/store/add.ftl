<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("admin.store.add")} </title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/admin/css/selectmultiple.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.tools.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/webuploader.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.autocomplete.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.selectmultiple.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/input.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $inputForm = $("#inputForm");
	var $businessId = $("#businessId");
	var $businessSelect = $("#businessSelect");
	var $username = $("#username");
	var $type = $("#type");
	var $filePicker = $("#filePicker");
	var $productCategoryIds = $("#productCategoryIds");
	
	[@flash_message /]
	
	$filePicker.uploader();
	
	// 商家选择
	$businessSelect.autocomplete("business_select", {
		dataType: "json",
		max: 20,
		width: 218,
		scrollHeight: 300,
		parse: function(data) {
			return $.map(data, function(item) {
				return {
					data: item,
					value: item.name
				}
			});
		},
		formatItem: function(item) {
			return '<span title="' + escapeHtml(item.username) + '">' + escapeHtml(abbreviate(item.username, 50, "...")) + '<\/span>';
		}
	}).result(function(event, item) {
		$businessId.val(item.id);
		$username.text(item.username).closest("tr").show();
	});
	
	// 类型
	$type.change(function() {
		switch ($type.val()) {
			case "general":
				$generalStoreRank.prop("disabled", false).show();
				$selfStoreRank.prop("disabled", true).hide();
				break;
			case "self":
				$generalStoreRank.prop("disabled", true).hide();
				$selfStoreRank.prop("disabled", false).show();
				break;
		}
	});
	
	// 经营分类
	$productCategoryIds.selectMultiple();
	
	// 表单验证
	$inputForm.validate({
		rules: {
			name: {
				required: true,
				remote: {
					url: "check_name",
					cache: false
				}
			},
			logo: {
				pattern: /^(http:\/\/|https:\/\/|\/).*$/i
			},
			email: {
				required: true,
				email: true
			},
			mobile:{
				required: true,
				pattern: /^1[3|4|5|7|8]\d{9}$/
			},
			introduction: {
				maxlength: 200
			}
		},
		messages: {
			name: {
				remote: "${message("common.validate.exist")}"
			},
			mobile: {
				pattern: "${message("common.validate.pattern")}"
			}
		},
		submitHandler: function(form) {
			if ($businessId.val() == "") {
				$.message("warn", "${message("admin.store.businessRequired")}");
				return false;
			}
			$(form).find("input:submit").prop("disabled", true);
			form.submit();
		}
	});

});
</script>
</head>
<body>
	<div class="breadcrumb">
		<a href="${base}/admin/index">${message("admin.breadcrumb.home")}</a> &raquo; ${message("admin.store.add")}
	</div>
	<form id="inputForm" action="save" method="post">
		<input type="hidden" id="businessId" name="businessId" />
		<table class="input">
			<tr>
				<th>
					<span class="requiredField">*</span>${message("admin.store.businessSelect")}:
				</th>
				<td>
					<input type="text" id="businessSelect" name="businessSelect" class="text" maxlength="200" title="${message("admin.store.businessSelectTitle")}" />
				</td>
			</tr>
			<tr class="hidden">
				<th>
					${message("Business.username")}:
				</th>
				<td id="username"></td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("Store.name")}:
				</th>
				<td>
					<input type="text" name="name" class="text" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Store.type")}:
				</th>
				<td>
					<select id="type" name="type">
						[#list types as type]
							<option value="${type}">${message("Store.Type." + type)}</option>
						[/#list]
					</select>
				</td>
			</tr>
			<tr>
				<th>
					${message("Store.logo")}:
				</th>
				<td>
					<span class="fieldSet">
						<input type="text" name="logo" class="text" maxlength="200" />
						<a href="javascript:;" id="filePicker" class="button">${message("admin.upload.filePicker")}</a>
					</span>
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("Store.email")}:
				</th>
				<td>
					<input type="text" name="email" class="text" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("Store.mobile")}:
				</th>
				<td>
					<input type="text" name="mobile" class="text" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Store.phone")}:
				</th>
				<td>
					<input type="text" name="phone" class="text" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Store.address")}:
				</th>
				<td>
					<input type="text" name="address" class="text" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Store.zipCode")}:
				</th>
				<td>
					<input type="text" name="zipCode" class="text" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Store.introduction")}:
				</th>
				<td>
					<textarea name="introduction" class="text"></textarea>
				</td>
			</tr>
			<tr>
				<th>
					${message("Store.keyword")}:
				</th>
				<td>
					<input type="text" name="keyword" class="text" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Store.storeRank")}:
				</th>
				<td>
					<select name="storeRankId">
						[#list storeRanks as storeRank]
							<option value="${storeRank.id}">${storeRank.name}</option>
						[/#list]
					</select>
				</td>
			</tr>
			<tr>
				<th>
					${message("Store.storeCategory")}:
				</th>
				<td>
					<select id="storeCategoryId" name="storeCategoryId">
						[#list storeCategories as storeCategory]
							<option value="${storeCategory.id}">${storeCategory.name}</option>
						[/#list]
					</select>
				</td>
			</tr>
			<tr>
				<th>
					${message("Store.productCategories")}:
				</th>
				<td>
					<select id="productCategoryIds" name="productCategoryIds" multiple="multiple">
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
					${message("admin.common.setting")}:
				</th>
				<td>
					<label>
						<input type="checkbox" name="isEnabled" value="true" checked="checked" />${message("Store.isEnabled")}
						<input type="hidden" name="_isEnabled" value="false" />
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