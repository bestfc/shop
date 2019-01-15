<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
[@seo type = "brandDetail"]
	<title>${seo.resolveTitle()}[#if showPowered] [/#if]</title>
	[#if seo.resolveKeywords()?has_content]
		<meta name="keywords" content="${seo.resolveKeywords()}" />
	[/#if]
	[#if seo.resolveDescription()?has_content]
		<meta name="description" content="${seo.resolveDescription()}" />
	[/#if]
[/@seo]
<link href="${base}/resources/shop/css/animate.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/product.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/brand.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/shop/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/common.js"></script>
</head>
<body>
	[#include "/shop/include/header.ftl" /]
	<div class="container brandContent">
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
						<li>
							<a href="${base}/brand/list/1">${message("shop.brand.title")}</a>
						</li>
					</ul>
				</div>
				<div class="top">
					[#if brand.type == "image"]
						<img src="${brand.logo}" alt="${brand.name}" />
					[/#if]
					<strong>${brand.name}</strong>
					[#if brand.url??]
						<a href="${brand.url}" target="_blank">${brand.url}</a>
					[/#if]
				</div>
				<div class="introduction">
					[#noautoesc]
						${brand.introduction}
					[/#noautoesc]
				</div>
				[#if brand.productCategories?has_content]
					<div class="product">
						<dl>
							<dt>
								<a href="${base}/product/list?brandId=${brand.id}">${message("shop.brand.products")}</a>
							</dt>
							[#list brand.productCategories as productCategory]
								<dd>
									<a href="${base}${productCategory.path}?brandId=${brand.id}">${productCategory.name}</a>
								</dd>
								[#if productCategory_index == 5]
									[#break /]
								[/#if]
							[/#list]
						</dl>
					</div>
				[/#if]
			</div>
		</div>
	</div>
	[#include "/shop/include/footer.ftl" /]
</body>
</html>