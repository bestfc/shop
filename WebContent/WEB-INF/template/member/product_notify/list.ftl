<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("member.productNotify.list")}[#if showPowered] [/#if]</title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/member/css/animate.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/member/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/member/css/member.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/member/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/member/js/common.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $listTable = $("#listTable");
	var $delete = $("#listTable a.delete");
	
	[#if flashMessage?has_content]
		$.alert("${flashMessage}");
	[/#if]

	$delete.click(function() {
		if (confirm("${message("member.dialog.deleteConfirm")}")) {
			var $element = $(this);
			var productNotifyId = $element.data("product-notify-id");
			$.ajax({
				url: "delete",
				type: "POST",
				data: {productNotifyId: productNotifyId},
				dataType: "json",
				success: function() {
					var $item = $element.closest("tr");
					if ($item.siblings("tr").size() < 2) {
						setTimeout(function() {
							location.reload(true);
						}, 3000);
					}
					$item.remove();
				}
			});
		}
		return false;
	});
});
</script>
</head>
<body>
	[#assign current = "productNotifyList" /]
	[#include "/shop/include/header.ftl" /]
	<div class="container member">
		<div class="row">
			[#include "/member/include/navigation.ftl" /]
			<div class="span10">
				<div class="list">
					<div class="title">${message("member.productNotify.list")}</div>
					<table id="listTable" class="list">
						<tr>
							<th>
								${message("member.productNotify.productImage")}
							</th>
							<th>
								${message("member.productNotify.skuName")}
							</th>
							<th>
								${message("member.productNotify.skuPrice")}
							</th>
							<th>
								${message("member.productNotify.email")}
							</th>
							<th>
								${message("member.common.action")}
							</th>
						</tr>
						[#list page.content as productNotify]
							<tr[#if !sku_has_next] class="last"[/#if]>
								<td>
									<img src="${productNotify.sku.thumbnail!setting.defaultThumbnailProductImage}" class="productThumbnail" alt="${productNotify.sku.name}" />
								</td>
								<td>
									<a href="${base}${productNotify.sku.path}" title="${productNotify.sku.name}" target="_blank">${abbreviate(productNotify.sku.name, 30)}</a>
									[#if productNotify.sku.specifications?has_content]
										<span class="silver">[${productNotify.sku.specifications?join(", ")}]</span>
									[/#if]
								</td>
								<td>
									${currency(productNotify.sku.price, true)}
								</td>
								<td>
									${productNotify.email}
								</td>
								<td>
									<a href="javascript:;" class="delete" data-product-notify-id="${productNotify.id}">[${message("member.common.delete")}]</a>
								</td>
							</tr>
						[/#list]
					</table>
					[#if !currentUser.productNotifies?has_content]
						<p>${message("member.common.noResult")}</p>
					[/#if]
				</div>
				[@pagination pageNumber = page.pageNumber totalPages = page.totalPages pattern = "?pageNumber={pageNumber}"]
					[#include "/shop/include/pagination.ftl"]
				[/@pagination]
			</div>
		</div>
	</div>
	[#include "/shop/include/footer.ftl" /]
</body>
</html>