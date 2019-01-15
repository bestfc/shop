<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("shop.product.compare")}</title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/shop/css/animate.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/product.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/shop/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/common.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $parameterTr = $("table.parameterTable tr");
	
	$parameterTr.hover(
		function() {
			var $this = $(this);
			var group = $this.data("group");
			var name = $this.data("name");
			$parameterTr.filter("[data-group='" + group + "'][data-name='" + name + "']").addClass("current");
		},
		function() {
			$parameterTr.removeClass("current");
		}
	);

});
</script>
</head>
<body>
	[#include "/shop/include/header.ftl" /]
	<div class="container productCompare">
		<div class="row">
			<div class="span2">
				[#include "/shop/include/hot_product_category.ftl" /]
				[#include "/shop/include/hot_brand.ftl" /]
				[#include "/shop/include/hot_product.ftl" /]
				[#include "/shop/include/hot_promotion.ftl" /]
			</div>
			<div class="span10">
				<div class="breadcrumb">
					<ul>
						<li>
							<a href="${base}/">${message("shop.breadcrumb.home")}</a>
						</li>
						<li>${message("shop.product.compare")}</li>
					</ul>
				</div>
				<ul class="main">
					[#list products as product]
						<li>
							<table>
								<tr>
									<td>
										<a href="${base}${product.path}" target="_blank">${product.name}</a>
									</td>
								</tr>
								<tr>
									<td>
										<img src="${product.thumbnail!setting.defaultThumbnailProductImage}" alt="${product.name}" />
									</td>
								</tr>
								<tr>
									<td>
										<strong>${currency(product.price, true)}</strong>
									</td>
								</tr>
							</table>
							[#if product.parameterValues?has_content]
								<table class="parameterTable">
									[#list product.parameterValues as parameterValue]
										<tr>
											<th class="group" colspan="2">${parameterValue.group}</th>
										</tr>
										[#list parameterValue.entries as entry]
											<tr data-group="${parameterValue.group}" data-name="${entry.name}">
												<th>${entry.name}</th>
												<td>${entry.value}</td>
											</tr>
										[/#list]
									[/#list]
								</table>
							[/#if]
						</li>
					[/#list]
				</ul>
			</div>
		</div>
	</div>
	[#include "/shop/include/footer.ftl" /]
</body>
</html>