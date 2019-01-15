<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
[@seo type = "index"]
	<title>${seo.resolveTitle()}[#if showPowered] [/#if]</title>
	[#if seo.resolveKeywords()?has_content]
		<meta name="keywords" content="${seo.resolveKeywords()}" />
	[/#if]
	[#if seo.resolveDescription()?has_content]
		<meta name="description" content="${seo.resolveDescription()}" />
	[/#if]
[/@seo]
<link href="${base}/favicon.ico" rel="icon" type="image/x-icon" />
<link href="${base}/resources/shop/jslides/jslides.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/animate.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/index.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/shop/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/jquery.tools.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/jquery.lazyload.js"></script>
<script type="text/javascript" src="${base}/resources/shop/jslides/jslides.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/common.js"></script>
<style type="text/css">
.header {
	margin-bottom: 0px;
}
</style>
<script type="text/javascript">
$().ready(function() {

	var $productCategoryMenuItem = $("#productCategoryMenu li");
	var $newArticleTab = $("#newArticle ul.tab");
	var $hotProductImage = $("div.hotProduct img");
	$productCategoryMenuItem.hover(
		function() {
			$(this).children("div.menu").show();
		}, function() {
			$(this).children("div.menu").hide();
		}
	);

	$newArticleTab.tabs("ul.tabContent", {
		tabs: "li",
		event: "mouseover"
	});
	
	$hotProductImage.lazyload({
		threshold: 100,
		effect: "fadeIn",
		skip_invisible: false
	});
	
});
</script>
</head>
[#assign current = "indexMember" /]
<body>
	[#include "/shop/include/header.ftl" /]
	<div class="containerIndex index">
		[@ad_position id = 1]
			[#noautoesc]
				${adPosition.resolveTemplate()}
			[/#noautoesc]
		[/@ad_position]
	</div>
	<div class="container index">
		<div class="row">
			<div class="span2">
				[@product_category_root_list count = 6]
					<div id="productCategoryMenu" class="productCategoryMenu">
						<ul>
							[#list productCategories as productCategory]
								<li>
									[@product_category_children_list productCategoryId = productCategory.id recursive = false count = 3]
										<div class="item[#if !productCategory_has_next] last[/#if]">
											<div>
												[#list productCategories as productCategory]
													<a href="${base}${productCategory.path}">
														<strong>${productCategory.name}</strong>
													</a>
												[/#list]
											</div>
											<div>
												[@brand_list productCategoryId = productCategory.id count = 4]
													[#list brands as brand]
														<a href="${base}${brand.path}">${brand.name}</a>
													[/#list]
												[/@brand_list]
											</div>
										</div>
									[/@product_category_children_list]
									[@product_category_children_list productCategoryId = productCategory.id recursive = false count = 8]
										<div class="menu">
											[#list productCategories as productCategory]
												<dl class="clearfix[#if !productCategory_has_next] last[/#if]">
													<dt>
														<a href="${base}${productCategory.path}">${productCategory.name}</a>
													</dt>
													[@product_category_children_list productCategoryId = productCategory.id recursive = false]
														[#list productCategories as productCategory]
															<dd>
																<a href="${base}${productCategory.path}">${productCategory.name}</a>[#if productCategory_has_next]|[/#if]
															</dd>
														[/#list]
													[/@product_category_children_list]
												</dl>
											[/#list]
											<div class="auxiliary">
												[@brand_list productCategoryId = productCategory.id count = 8]
													[#if brands?has_content]
														<div>
															<strong>${message("shop.index.recommendBrand")}</strong>
															[#list brands as brand]
																<a href="${base}${brand.path}">${brand.name}</a>
															[/#list]
														</div>
													[/#if]
												[/@brand_list]
												[@promotion_list productCategoryId = productCategory.id hasEnded = false count = 4]
													[#if promotions?has_content]
														<div>
															<strong>${message("shop.index.hotPromotion")}</strong>
															[#list promotions as promotion]
																[#if promotion.image?has_content]
																	<a href="${base}${promotion.path}" title="${promotion.title}">
																		<img src="${promotion.image}" alt="${promotion.title}" />
																	</a>
																[/#if]
															[/#list]
														</div>
													[/#if]
												[/@promotion_list]
											</div>
										</div>
									[/@product_category_children_list]
								</li>
							[/#list]
						</ul>
					</div>
				[/@product_category_root_list]
			</div>
		</div>
		<div class="row">
			<div class="span9">
				[@ad_position id = 2]
					[#noautoesc]
						${adPosition.resolveTemplate()}
					[/#noautoesc]
				[/@ad_position]
			</div>
			<div class="span3">
				[@article_category_root_list count = 2]
					[#if articleCategories?has_content]
						<div id="newArticle" class="newArticle">
							<ul class="tab">
								[#list articleCategories as articleCategory]
									<li>
										<a href="${base}${articleCategory.path}" target="_blank">${articleCategory.name}</a>
									</li>
								[/#list]
							</ul>
							[#list articleCategories as articleCategory]
								[@article_list articleCategoryId = articleCategory.id count = 6]
									<ul class="tabContent[#if articleCategory_index > 0] hidden[/#if]">
										[#list articles as article]
											<li>
												<a href="${base}${article.path}" title="${article.title}" target="_blank">${abbreviate(article.title, 40)}</a>
											</li>
										[/#list]
									</ul>
								[/@article_list]
							[/#list]
						</div>
					[/#if]
				[/@article_category_root_list]
			</div>
		</div>
		<div class="row">
			<div class="span12">
				[@ad_position id = 3]
					[#noautoesc]
						${adPosition.resolveTemplate()}
					[/#noautoesc]
				[/@ad_position]
			</div>
		</div>
		[@product_category_root_list count = 3]
			[@ad_position id = 4]
				[#if adPosition??]
					[#assign adIterator = adPosition.ads.iterator() /]
				[/#if]
			[/@ad_position]
			[#list productCategories as productCategory]
				[@product_list productCategoryId = productCategory.id productTagId = 1 count = 10]
					<div class="row">
						<div class="span12">
							<div class="hotProduct">
								[@product_category_children_list productCategoryId = productCategory.id recursive = false count = 8]
									<dl class="title${productCategory_index + 1}">
										<dt>
											<a href="${base}${productCategory.path}">${productCategory.name}</a>
										</dt>
										[#list productCategories as productCategory]
											<dd>
												<a href="${base}${productCategory.path}">${productCategory.name}</a>
											</dd>
										[/#list]
									</dl>
								[/@product_category_children_list]
								<div>
									[#if adIterator?? && adIterator.hasNext()]
										[#assign ad = adIterator.next() /]
										[#if ad.type == "image" && ad.hasBegun() && !ad.hasEnded()]
											[#if ad.url??]
												<a href="${ad.url}">
													<img src="${ad.path}" alt="${ad.title}" title="${ad.title}" />
												</a>
											[#else]
												<img src="${ad.path}" alt="${ad.title}" title="${ad.title}" />
											[/#if]
										[/#if]
									[/#if]
								</div>
								<ul>
									[#list products as product]
										[#if product_index < 5]
											<li>
												<a href="${base}${product.path}" title="${product.name}" target="_blank">
													<div>
														[#if product.caption?has_content]
															<span title="${product.name}">${abbreviate(product.name, 24)}</span>
															<em title="${product.caption}">${abbreviate(product.caption, 24)}</em>
														[#else]
															${abbreviate(product.name, 48)}
														[/#if]
													</div>
													<strong>${currency(product.price, true)}</strong>
													<img src="${base}/upload/image/blank.gif" data-original="${product.image!setting.defaultThumbnailProductImage}" />
												</a>
											</li>
										[#else]
											<li class="low">
												<a href="${base}${product.path}" title="${product.name}" target="_blank">
													<img src="${base}/upload/image/blank.gif" data-original="${product.image!setting.defaultThumbnailProductImage}" />
													<span title="${product.name}">${abbreviate(product.name, 24)}</span>
													<strong>${currency(product.price, true)}</strong>
												</a>
											</li>
										[/#if]
									[/#list]
								</ul>
							</div>
						</div>
					</div>
				[/@product_list]
			[/#list]
		[/@product_category_root_list]
		<div class="row">
			<div class="span12">
				[@ad_position id = 5]
					[#noautoesc]
						${adPosition.resolveTemplate()}
					[/#noautoesc]
				[/@ad_position]
			</div>
		</div>
		<div class="row">
			<div class="span12">
				[@brand_list type = "image" count = 10]
					[#if brands?has_content]
						<div class="hotBrand">
							<ul class="clearfix">
								[#list brands as brand]
									<li>
										<a href="${base}${brand.path}" title="${brand.name}">
											<img src="${brand.logo}" alt="${brand.name}" />
										</a>
									</li>
								[/#list]
							</ul>
						</div>
					[/#if]
				[/@brand_list]
			</div>
		</div>
	</div>
	[#include "/shop/include/footer.ftl" /]
</body>
</html>