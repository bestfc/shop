<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html;charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("admin.role.add")} </title>
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
		${message("admin.role.add")}
	</div>
	<form id="inputForm" action="save" method="post">
		<table class="input">
			<tr>
				<th>
					<span class="requiredField">*</span>${message("Role.name")}:
				</th>
				<td>
					<input type="text" name="name" class="text" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Role.description")}:
				</th>
				<td>
					<input type="text" name="description" class="text" maxlength="200" />
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
							<input type="checkbox" name="permissions" value="admin:business" />${message("admin.role.business")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:store" />${message("admin.role.store")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:storeCategory" />${message("admin.role.storeCategory")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:storeRank" />${message("admin.role.storeRank")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:businessAttribute" />${message("admin.role.businessAttribute")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:cash" />${message("admin.role.cash")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:categoryApplication" />${message("admin.role.categoryApplication")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:businessDeposit" />${message("admin.role.businessDeposit")}
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
							<input type="checkbox" name="permissions" value="admin:product" />${message("admin.role.product")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:stock" />${message("admin.role.stock")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:productCategory" />${message("admin.role.productCategory")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:productTag" />${message("admin.role.productTag")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:parameter" />${message("admin.role.parameter")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:attribute" />${message("admin.role.attribute")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:specification" />${message("admin.role.specification")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:brand" />${message("admin.role.brand")}
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
							<input type="checkbox" name="permissions" value="admin:order" />${message("admin.role.order")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:print" />${message("admin.role.print")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:orderPayment" />${message("admin.role.orderPayment")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:orderRefunds" />${message("admin.role.orderRefunds")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:orderShipping" />${message("admin.role.orderShipping")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:orderReturns" />${message("admin.role.orderReturns")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:deliveryCenter" />${message("admin.role.deliveryCenter")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:deliveryTemplate" />${message("admin.role.deliveryTemplate")}
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
							<input type="checkbox" name="permissions" value="admin:member" />${message("admin.role.member")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:memberRank" />${message("admin.role.memberRank")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:memberAttribute" />${message("admin.role.memberAttribute")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:point" />${message("admin.role.point")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:memberDeposit" />${message("admin.role.memberDeposit")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:review" />${message("admin.role.review")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:consultation" />${message("admin.role.consultation")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:messageConfig" />${message("admin.role.messageConfig")}
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
							<input type="checkbox" name="permissions" value="admin:navigation" />${message("admin.role.navigation")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:article" />${message("admin.role.article")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:articleCategory" />${message("admin.role.articleCategory")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:articleTag" />${message("admin.role.articleTag")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:friendLink" />${message("admin.role.friendLink")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:adPosition" />${message("admin.role.adPosition")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:ad" />${message("admin.role.ad")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:template" />${message("admin.role.template")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:cache" />${message("admin.role.cache")}
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
							<input type="checkbox" name="permissions" value="admin:promotion" />${message("admin.role.promotion")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:coupon" />${message("admin.role.coupon")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:seo" />${message("admin.role.seo")}
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
							<input type="checkbox" name="permissions" value="admin:setting" />${message("admin.role.setting")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:area" />${message("admin.role.area")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:paymentMethod" />${message("admin.role.paymentMethod")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:shippingMethod" />${message("admin.role.shippingMethod")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:deliveryCorp" />${message("admin.role.deliveryCorp")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:paymentPlugin" />${message("admin.role.paymentPlugin")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:storagePlugin" />${message("admin.role.storagePlugin")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:loginPlugin" />${message("admin.role.loginPlugin")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:promotionPlugin" />${message("admin.role.promotionPlugin")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:admin" />${message("admin.role.admin")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:role" />${message("admin.role.role")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:message" />${message("admin.role.message")}
						</label>
						<label>
							<input type="checkbox" name="permissions" value="admin:auditLog" />${message("admin.role.auditLog")}
						</label>
					</span>
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