<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
[@seo type = "articleSearch"]
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
<link href="${base}/resources/shop/css/article.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/shop/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/common.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $articleSearchForm = $("#articleSearchForm");
	var $keyword = $("#articleSearchForm input");
	var defaultKeyword = $keyword.val();
	
	$keyword.focus(function() {
		if ($.trim($keyword.val()) == defaultKeyword) {
			$keyword.val("");
		}
	});
	
	$keyword.blur(function() {
		if ($.trim($keyword.val()) == "") {
			$keyword.val(defaultKeyword);
		}
	});
	
	$articleSearchForm.submit(function() {
		if ($.trim($keyword.val()) == "" || $.trim($keyword.val()) == defaultKeyword) {
			return false;
		}
	});

});
</script>
</head>
<body>
	[#include "/shop/include/header.ftl" /]
	<div class="container articleList">
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
						<li>${message("shop.article.searchPath", articleKeyword)}</li>
					</ul>
				</div>
				<div class="result">
					[#if page.content?has_content]
						<ul>
							[#list page.content as article]
								<li>
									<a href="${base}${article.path}" title="${article.title}">${abbreviate(article.title, 80, "...")}</a>
									${article.author}
									<span title="${article.createdDate?string("yyyy-MM-dd HH:mm:ss")}">${article.createdDate}</span>
									<p>${abbreviate(article.text, 220, "...")}</p>
								</li>
							[/#list]
						</ul>
					[#else]
						[#noautoesc]
							${message("shop.article.noSearchResult", articleKeyword?html)}
						[/#noautoesc]
					[/#if]
				</div>
				[@pagination pageNumber = page.pageNumber totalPages = page.totalPages pattern = "search?keyword=${articleKeyword?url}&pageNumber={pageNumber}"]
					[#include "/shop/include/pagination.ftl"]
				[/@pagination]
			</div>
		</div>
	</div>
	[#include "/shop/include/footer.ftl" /]
</body>
</html>