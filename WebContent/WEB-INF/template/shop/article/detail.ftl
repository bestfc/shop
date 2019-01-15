<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
[@seo type = "articleDetail"]
	<title>[#if article.resolveSeoTitle()?has_content]${article.resolveSeoTitle()}[#else]${seo.resolveTitle()}[/#if][#if showPowered] [/#if]</title>
	<meta name="author" content="SHOP++ Team" />
	<meta name="copyright" content="SHOP++" />
	[#if article.resolveSeoKeywords()?has_content]
		<meta name="keywords" content="${article.resolveSeoKeywords()}" />
	[#elseif seo.resolveKeywords()?has_content]
		<meta name="keywords" content="${seo.resolveKeywords()}" />
	[/#if]
	[#if article.resolveSeoDescription()?has_content]
		<meta name="description" content="${article.resolveSeoDescription()}" />
	[#elseif seo.resolveDescription()?has_content]
		<meta name="description" content="${seo.resolveDescription()}" />
	[/#if]
[/@seo]
<link href="${base}/resources/shop/css/animate.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/article.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/shop/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/common.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $hits = $("#hits");
	var $articleSearchForm = $("#articleSearchForm");
	var $keyword = $("#articleSearchForm input");
	
	// 查看点击数
	$.ajax({
		url: "${base}/article/hits/${article.id}",
		type: "GET",
		cache: true,
		success: function(data) {
			$hits.text(data.hits);
		}
	});
	
	$articleSearchForm.submit(function() {
		if ($.trim($keyword.val()) == "") {
			return false;
		}
	});

});
</script>
</head>
<body>
	[#assign articleCategory = article.articleCategory /]
	[#include "/shop/include/header.ftl" /]
	<div class="container articleDetail">
		<div class="row">
			<div class="span2">
				[#include "/shop/include/hot_article_category.ftl" /]
				[#include "/shop/include/hot_article.ftl" /]
				[#include "/shop/include/article_search.ftl" /]
			</div>
			<div class="span10">
				<div class="breadcrumb">
					<ul>
						<li>
							<a href="${base}/">${message("shop.breadcrumb.home")}</a>
						</li>
						[@article_category_parent_list articleCategoryId = articleCategory.id]
							[#list articleCategories as articleCategory]
								<li>
									<a href="${base}${articleCategory.path}">${articleCategory.name}</a>
								</li>
							[/#list]
						[/@article_category_parent_list]
						<li>
							<a href="${base}${articleCategory.path}">${articleCategory.name}</a>
						</li>
					</ul>
				</div>
				<div class="main">
					<h1 class="title">${article.title}[#if pageNumber > 1] (${pageNumber})[/#if]</h1>
					<div class="info">
						${message("shop.article.createdDate")}: ${article.createdDate?string("yyyy-MM-dd HH:mm:ss")}
						${message("shop.article.author")}: ${article.author}
						${message("shop.article.hits")}: <span id="hits">&nbsp;</span>
					</div>
					[#noautoesc]
						<div class="content">${article.getPageContent(pageNumber)}</div>
					[/#noautoesc]
				</div>
				[@pagination pageNumber = pageNumber totalPages = article.totalPages pattern = article.id + "_{pageNumber}"]
					[#include "/shop/include/pagination.ftl"]
				[/@pagination]
			</div>
		</div>
	</div>
	[#include "/shop/include/footer.ftl" /]
</body>
</html>