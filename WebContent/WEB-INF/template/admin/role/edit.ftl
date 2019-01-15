<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html;charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("admin.role.edit")} </title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/input.js"></script>
<style type="text/css">
.permissions label {
	min-width: 120px;
	_width: 120px;
	display: block;
	float: left;
	padding-right: 4px;
	_white-space: nowrap;
}
</style>
<script type="text/javascript">
$().ready(function() {

	var $inputForm = $("#inputForm");
	var $selectAll = $("#inputForm .selectAll");
	
	[@flash_message /]
	
	$selectAll.click(function() {
		var $this = $(this);
		var $thisCheckbox = $this.closest("tr").find("input:checkbox");
		if ($thisCheckbox.filter(":checked").size() > 0) {
			$thisCheckbox.prop("checked", false);
		} else {
			$thisCheckbox.prop("checked", true);
		}
		return false;
	});
	
	// 表单验证
	$inputForm.validate({
		rules: {
			name: "required",
			permissions: "required"
		}
	});

});
</script>
</head>
<body>
	<div class="breadcrumb">
		${message("admin.role.edit")}
	</div>
	<form id="inputForm" action="update" method="post">
		<input type="hidden" name="id" value="${role.id}" />
		<table class="input">
			<tr>
				<th>
					<span class="requiredField">*</span>${message("Role.name")}:
				</th>
				<td>
					<input type="text" name="name" class="text" value="${role.name}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Role.description")}:
				</th>
				<td>
					<input type="text" name="description" class="text" value="${role.description}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<td colspan="2">
					&nbsp;
				</td>
			</tr>
			<tr class="permissions">
				<th>
					<a href="javascript:;" class="selectAll" title="${message("admin.role.selectAll")}">${message("admin.role.storeGroup")}</a>
				</th>
				<td>
					<span class="fieldSet">
						<label>
							<input type="checkbox" name="permissions" value="admin:business"[#if role.permissions?seq_contains("admin:business")] checked="checked"[/#if] />${message("admin.role.business")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:store"[#if role.permissions?seq_contains("admin:store")] checked="checked"[/#if] />${message("admin.role.store")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:storeCategory"[#if role.permissions?seq_contains("admin:storeCategory")] checked="checked"[/#if] />${message("admin.role.storeCategory")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:storeRank"[#if role.permissions?seq_contains("admin:storeRank")] checked="checked"[/#if] />${message("admin.role.storeRank")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:businessAttribute"[#if role.permissions?seq_contains("admin:businessAttribute")] checked="checked"[/#if] />${message("admin.role.businessAttribute")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:cash"[#if role.permissions?seq_contains("admin:cash")] checked="checked"[/#if] />${message("admin.role.cash")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:categoryApplication"[#if role.permissions?seq_contains("admin:categoryApplication")] checked="checked"[/#if] />${message("admin.role.categoryApplication")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:businessDeposit"[#if role.permissions?seq_contains("admin:businessDeposit")] checked="checked"[/#if] />${message("admin.role.businessDeposit")}
						</label>
					</span>
				</td>
			</tr>
			<tr class="permissions">
				<th>
					<a href="javascript:;" class="selectAll" title="${message("admin.role.selectAll")}">${message("admin.role.productGroup")}</a>
				</th>
				<td>
					<span class="fieldSet">
						<label>
							<input type="checkbox" name="permissions" value="admin:product"[#if role.permissions?seq_contains("admin:product")] checked="checked"[/#if] />${message("admin.role.product")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:stock"[#if role.permissions?seq_contains("admin:stock")] checked="checked"[/#if] />${message("admin.role.stock")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:productCategory"[#if role.permissions?seq_contains("admin:productCategory")] checked="checked"[/#if] />${message("admin.role.productCategory")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:productTag"[#if role.permissions?seq_contains("admin:productTag")] checked="checked"[/#if] />${message("admin.role.productTag")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:parameter"[#if role.permissions?seq_contains("admin:parameter")] checked="checked"[/#if] />${message("admin.role.parameter")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:attribute"[#if role.permissions?seq_contains("admin:attribute")] checked="checked"[/#if] />${message("admin.role.attribute")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:specification"[#if role.permissions?seq_contains("admin:specification")] checked="checked"[/#if] />${message("admin.role.specification")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:brand"[#if role.permissions?seq_contains("admin:brand")] checked="checked"[/#if] />${message("admin.role.brand")}
						</label>
					</span>
				</td>
			</tr>
			<tr class="permissions">
				<th>
					<a href="javascript:;" class="selectAll" title="${message("admin.role.selectAll")}">${message("admin.role.orderGroup")}</a>
				</th>
				<td>
					<span class="fieldSet">
						<label>
							<input type="checkbox" name="permissions" value="admin:order"[#if role.permissions?seq_contains("admin:order")] checked="checked"[/#if] />${message("admin.role.order")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:print"[#if role.permissions?seq_contains("admin:print")] checked="checked"[/#if] />${message("admin.role.print")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:orderPayment"[#if role.permissions?seq_contains("admin:orderPayment")] checked="checked"[/#if] />${message("admin.role.orderPayment")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:orderRefunds"[#if role.permissions?seq_contains("admin:orderRefunds")] checked="checked"[/#if] />${message("admin.role.orderRefunds")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:orderShipping"[#if role.permissions?seq_contains("admin:orderShipping")] checked="checked"[/#if] />${message("admin.role.orderShipping")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:orderReturns"[#if role.permissions?seq_contains("admin:orderReturns")] checked="checked"[/#if] />${message("admin.role.orderReturns")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:deliveryCenter"[#if role.permissions?seq_contains("admin:deliveryCenter")] checked="checked"[/#if] />${message("admin.role.deliveryCenter")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:deliveryTemplate"[#if role.permissions?seq_contains("admin:deliveryTemplate")] checked="checked"[/#if] />${message("admin.role.deliveryTemplate")}
						</label>
					</span>
				</td>
			</tr>
			<tr class="permissions">
				<th>
					<a href="javascript:;" class="selectAll" title="${message("admin.role.selectAll")}">${message("admin.role.memberGroup")}</a>
				</th>
				<td>
					<span class="fieldSet">
						<label>
							<input type="checkbox" name="permissions" value="admin:member"[#if role.permissions?seq_contains("admin:member")] checked="checked"[/#if] />${message("admin.role.member")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:memberRank"[#if role.permissions?seq_contains("admin:memberRank")] checked="checked"[/#if] />${message("admin.role.memberRank")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:memberAttribute"[#if role.permissions?seq_contains("admin:memberAttribute")] checked="checked"[/#if] />${message("admin.role.memberAttribute")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:point"[#if role.permissions?seq_contains("admin:point")] checked="checked"[/#if] />${message("admin.role.point")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:memberDeposit"[#if role.permissions?seq_contains("admin:memberDeposit")] checked="checked"[/#if] />${message("admin.role.memberDeposit")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:review"[#if role.permissions?seq_contains("admin:review")] checked="checked"[/#if] />${message("admin.role.review")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:consultation"[#if role.permissions?seq_contains("admin:consultation")] checked="checked"[/#if] />${message("admin.role.consultation")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:messageConfig"[#if role.permissions?seq_contains("admin:messageConfig")] checked="checked"[/#if] />${message("admin.role.messageConfig")}
						</label>
					</span>
				</td>
			</tr>
			<tr class="permissions">
				<th>
					<a href="javascript:;" class="selectAll" title="${message("admin.role.selectAll")}">${message("admin.role.contentGroup")}</a>
				</th>
				<td>
					<span class="fieldSet">
						<label>
							<input type="checkbox" name="permissions" value="admin:navigation"[#if role.permissions?seq_contains("admin:navigation")] checked="checked"[/#if] />${message("admin.role.navigation")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:article"[#if role.permissions?seq_contains("admin:article")] checked="checked"[/#if] />${message("admin.role.article")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:articleCategory"[#if role.permissions?seq_contains("admin:articleCategory")] checked="checked"[/#if] />${message("admin.role.articleCategory")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:articleTag"[#if role.permissions?seq_contains("admin:articleTag")] checked="checked"[/#if] />${message("admin.role.articleTag")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:friendLink"[#if role.permissions?seq_contains("admin:friendLink")] checked="checked"[/#if] />${message("admin.role.friendLink")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:adPosition"[#if role.permissions?seq_contains("admin:adPosition")] checked="checked"[/#if] />${message("admin.role.adPosition")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:ad"[#if role.permissions?seq_contains("admin:ad")] checked="checked"[/#if] />${message("admin.role.ad")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:template"[#if role.permissions?seq_contains("admin:template")] checked="checked"[/#if] />${message("admin.role.template")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:cache"[#if role.permissions?seq_contains("admin:cache")] checked="checked"[/#if] />${message("admin.role.cache")}
						</label>
					</span>
				</td>
			</tr>
			<tr class="permissions">
				<th>
					<a href="javascript:;" class="selectAll" title="${message("admin.role.selectAll")}">${message("admin.role.marketingGroup")}</a>
				</th>
				<td>
					<span class="fieldSet">
						<label>
							<input type="checkbox" name="permissions" value="admin:promotion"[#if role.permissions?seq_contains("admin:promotion")] checked="checked"[/#if] />${message("admin.role.promotion")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:coupon"[#if role.permissions?seq_contains("admin:coupon")] checked="checked"[/#if] />${message("admin.role.coupon")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:seo"[#if role.permissions?seq_contains("admin:seo")] checked="checked"[/#if] />${message("admin.role.seo")}
						</label>
					</span>
				</td>
			</tr>
			<tr class="permissions">
				<th>
					<a href="javascript:;" class="selectAll" title="${message("admin.role.selectAll")}">${message("admin.role.systemGroup")}</a>
				</th>
				<td>
					<span class="fieldSet">
						<label>
							<input type="checkbox" name="permissions" value="admin:setting"[#if role.permissions?seq_contains("admin:setting")] checked="checked"[/#if] />${message("admin.role.setting")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:area"[#if role.permissions?seq_contains("admin:area")] checked="checked"[/#if] />${message("admin.role.area")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:paymentMethod"[#if role.permissions?seq_contains("admin:paymentMethod")] checked="checked"[/#if] />${message("admin.role.paymentMethod")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:shippingMethod"[#if role.permissions?seq_contains("admin:shippingMethod")] checked="checked"[/#if] />${message("admin.role.shippingMethod")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:deliveryCorp"[#if role.permissions?seq_contains("admin:deliveryCorp")] checked="checked"[/#if] />${message("admin.role.deliveryCorp")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:paymentPlugin"[#if role.permissions?seq_contains("admin:paymentPlugin")] checked="checked"[/#if] />${message("admin.role.paymentPlugin")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:storagePlugin"[#if role.permissions?seq_contains("admin:storagePlugin")] checked="checked"[/#if] />${message("admin.role.storagePlugin")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:loginPlugin"[#if role.permissions?seq_contains("admin:loginPlugin")] checked="checked"[/#if] />${message("admin.role.loginPlugin")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:promotionPlugin"[#if role.permissions?seq_contains("admin:promotionPlugin")] checked="checked"[/#if] />${message("admin.role.promotionPlugin")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:admin"[#if role.permissions?seq_contains("admin:admin")] checked="checked"[/#if] />${message("admin.role.admin")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:role"[#if role.permissions?seq_contains("admin:role")] checked="checked"[/#if] />${message("admin.role.role")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:message"[#if role.permissions?seq_contains("admin:message")] checked="checked"[/#if] />${message("admin.role.message")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:auditLog"[#if role.permissions?seq_contains("admin:auditLog")] checked="checked"[/#if] />${message("admin.role.auditLog")}
						</label>
					</span>
				</td>
			</tr>
			[#if role.isSystem]
				<tr>
					<th>
						&nbsp;
					</th>
					<td>
						<span class="tips">${message("admin.role.editSystemNotAllowed")}</span>
					</td>
				</tr>
			[/#if]
			<tr>
				<th>
					&nbsp;
				</th>
				<td>
					<input type="submit" class="button" value="${message("admin.common.submit")}"[#if role.isSystem] disabled="disabled"[/#if] />
					<input type="button" class="button" value="${message("admin.common.back")}" onclick="history.back(); return false;" />
				</td>
			</tr>
		</table>
	</form>
</body>
</html>