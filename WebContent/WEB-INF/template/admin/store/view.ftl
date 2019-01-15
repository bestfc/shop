<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("admin.store.view")} </title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/admin/css/selectmultiple.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.tools.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.selectmultiple.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/input.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $productCategoryIds = $("#productCategoryIds");
	
	// 经营分类
	$productCategoryIds.selectMultiple({
		disabledClass: "readonly"
	});

});
</script>
</head>
<body>
	<div class="breadcrumb">
		<a href="${base}/admin/index">${message("admin.breadcrumb.home")}</a> &raquo; ${message("admin.store.view")}
	</div>
	<ul id="tab" class="tab">
		<li>
			<input type="button" value="${message("admin.store.business")}" />
		</li>
		<li>
			<input type="button" value="${message("admin.store.store")}" />
		</li>
	</ul>
	<table class="input tabContent">
		[@business_attribute_list]
			[#list businessAttributes as businessAttribute]
				<tr>
					<th>
						${businessAttribute.name}:
					</th>
					[#if businessAttribute.type == "image" || businessAttribute.type == "licenseImage" || businessAttribute.type == "idCardImage" || businessAttribute.type == "organizationImage" || businessAttribute.type == "taxImage"]
						<td>
							<a href="${store.business.getAttributeValue(businessAttribute)}" target="_blank">
								<img src="${store.business.getAttributeValue(businessAttribute)}" width="50" height="50" />
							</a>
						</td>
					[#else]
						<td>
							${store.business.getAttributeValue(businessAttribute)}
						</td>
					[/#if]
				</tr>
			[/#list]
		[/@business_attribute_list]
	</table>
	<table class="input tabContent">
		<tr>
			<th>
				${message("Store.name")}:
			</th>
			<td>
				${store.name}
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
				${message("Store.status")}:
			</th>
			<td>
				<span class="[#if store.status == "approved" || store.status == "success"]green[#else]red[/#if]">${message("Store.Status." + store.status)}</span>
			</td>
		</tr>
		<tr>
			<th>
				${message("Store.logo")}:
			</th>
			<td>
				[#if store.logo?has_content]
					<a href="${store.logo}" target="_blank">
						<img src="${store.logo}" width="50" height="50" />
					</a>
				[/#if]
			</td>
		</tr>
		<tr>
			<th>
				${message("Store.email")}:
			</th>
			<td>
				${store.email}
			</td>
		</tr>
		<tr>
			<th>
				${message("Store.mobile")}:
			</th>
			<td>
				${store.mobile}
			</td>
		</tr>
		<tr>
			<th>
				${message("Store.phone")}:
			</th>
			<td>
				${store.phone}
			</td>
		</tr>
		<tr>
			<th>
				${message("Store.address")}:
			</th>
			<td>
				${store.address}
			</td>
		</tr>
		<tr>
			<th>
				${message("Store.zipCode")}:
			</th>
			<td>
				${store.zipCode}
			</td>
		</tr>
		<tr>
			<th>
				${message("Store.introduction")}:
			</th>
			<td>
				${store.introduction}
			</td>
		</tr>
		<tr>
			<th>
				${message("Store.keyword")}:
			</th>
			<td>
				${store.keyword}
			</td>
		</tr>
		<tr>
			<th>
				${message("Store.storeRank")}:
			</th>
			<td>
				${store.storeRank.name}
			</td>
		</tr>
		<tr>
			<th>
				${message("Store.storeCategory")}:
			</th>
			<td>
				${store.storeCategory.name}
			</td>
		</tr>
		<tr>
			<th>
				${message("Store.productCategories")}:
			</th>
			<td>
				<select id="productCategoryIds" name="productCategoryIds" multiple="multiple" disabled="disabled">
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
				&nbsp;
			</th>
			<td>
				<input type="button" class="button" value="${message("admin.common.back")}" onclick="history.back(); return false;" />
			</td>
		</tr>
	</table>
</body>
</html>