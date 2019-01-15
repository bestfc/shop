<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("admin.store.edit")} </title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/admin/css/selectmultiple.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.tools.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/webuploader.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.selectmultiple.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/input.js"></script>
<script type="text/javascript" src="${base}/resources/admin/datePicker/WdatePicker.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $inputForm = $("#inputForm");
	var $filePicker = $("#filePicker");
	var $productCategoryIds = $("#productCategoryIds");
	
	[@flash_message /]
	
	$filePicker.uploader();
	
	// 经营分类
	$productCategoryIds.selectMultiple();
	
	// 表单验证
	$inputForm.validate({
		rules: {
			name: {
				required: true,
				remote: {
					url: "check_name?id=${store.id}",
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
			},
			endDate: "required"
		},
		messages: {
			name: {
				remote: "${message("common.validate.exist")}"
			},
			mobile: {
				pattern: "${message("common.validate.pattern")}"
			}
		}
	});

});
</script>
</head>
<body>
	<div class="breadcrumb">
		<a href="${base}/admin/index">${message("admin.breadcrumb.home")}</a> &raquo; ${message("admin.store.edit")}
	</div>
	<form id="inputForm" action="update" method="post">
		<input type="hidden" name="id" value="${store.id}" />
		<table class="input">
			<tr>
				<th>
					<span class="requiredField">*</span>${message("Store.name")}:
				</th>
				<td>
					<input type="text" name="name" class="text" value="${store.name}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Store.type")}:
				</th>
				<td>
					${message("Store.Type." + store.type)}
				</td>
			</tr>
			<tr>
				<th>
					${message("Store.logo")}:
				</th>
				<td>
					<span class="fieldSet">
						<input type="text" name="logo" class="text" value="${store.logo}" maxlength="200" />
						<a href="javascript:;" id="filePicker" class="button">${message("admin.upload.filePicker")}</a>
						[#if store.logo?has_content]
							<a href="${store.logo}" target="_blank">${message("admin.common.view")}</a>
						[/#if]
					</span>
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("Store.email")}:
				</th>
				<td>
					<input type="text" name="email" class="text" value="${store.email}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("Store.mobile")}:
				</th>
				<td>
					<input type="text" name="mobile" class="text" value="${store.mobile}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Store.phone")}:
				</th>
				<td>
					<input type="text" name="phone" class="text" value="${store.phone}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Store.address")}:
				</th>
				<td>
					<input type="text" name="address" class="text" value="${store.address}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Store.zipCode")}:
				</th>
				<td>
					<input type="text" name="zipCode" class="text" value="${store.zipCode}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Store.introduction")}:
				</th>
				<td>
					<textarea name="introduction" class="text">${store.introduction}</textarea>
				</td>
			</tr>
			<tr>
				<th>
					${message("Store.keyword")}:
				</th>
				<td>
					<input type="text" name="keyword" class="text" value="${store.keyword}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Store.storeRank")}:
				</th>
				<td>
					<select name="storeRankId">
						[#list storeRanks as storeRank]
							<option value="${storeRank.id}"[#if storeRank == store.storeRank] selected="selected"[/#if]>${storeRank.name}</option>
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
							<option value="${storeCategory.id}"[#if storeCategory == store.storeCategory] selected="selected"[/#if]>${storeCategory.name}</option>
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
							<option value="${productCategory.id}"[#if store.productCategories?seq_contains(productCategory)] selected="selected"[/#if]>
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
					<span class="requiredField">*</span>${message("Store.endDate")}:
				</th>
				<td>
					<input type="text" name="endDate" class="text Wdate" value="${store.endDate?string("yyyy-MM-dd HH:mm:ss")}" onfocus="WdatePicker({dateFmt: 'yyyy-MM-dd HH:mm:ss'});" />
				</td>
			</tr>
			<tr>
				<th>
					${message("admin.common.setting")}:
				</th>
				<td>
					<label>
						<input type="checkbox" name="isEnabled" value="true"[#if store.isEnabled] checked="checked"[/#if] />${message("Store.isEnabled")}
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