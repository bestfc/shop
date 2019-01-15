<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	[@seo type = "articleDetail"]
		[#if article.resolveSeoKeywords()?has_content]
			<meta name="keywords" content="${article.resolveSeoKeywords()}">
		[#elseif seo.resolveKeywords()?has_content]
			<meta name="keywords" content="${seo.resolveKeywords()}">
		[/#if]
		[#if article.resolveSeoDescription()?has_content]
			<meta name="description" content="${article.resolveSeoDescription()}">
		[#elseif seo.resolveDescription()?has_content]
			<meta name="description" content="${seo.resolveDescription()}">
		[/#if]
		<title>[#if article.resolveSeoTitle()?has_content]${article.resolveSeoTitle()}[#else]${seo.resolveTitle()}[/#if][#if showPowered] [/#if]</title>
	[/@seo]
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/mobile/shop/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/animate.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/common.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/article.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/mobile/shop/js/html5shiv.js"></script>
		<script src="${base}/resources/mobile/shop/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/mobile/shop/js/jquery.js"></script>
	<script src="${base}/resources/mobile/shop/js/bootstrap.js"></script>
	<script src="${base}/resources/mobile/shop/js/underscore.js"></script>
	<script src="${base}/resources/mobile/shop/js/common.js"></script>
	<script type="text/javascript">
	$().ready(function() {
		
		var $searchForm = $("#searchForm");
		var $keyword = $("#keyword");
		var $hits = $("#hits");
		
		// 搜索
		$searchForm.submit(function() {
			if ($.trim($keyword.val()) == "") {
				return false;
			}
		});
		
		// 查看点击数
		$.ajax({
			url: "${base}/article/hits/${article.id}",
			type: "GET",
			success: function(data) {
				$hits.text(data.hits);
			}
		});
	
	});
	</script>
</head>
<body class="article-detail">
	<header class="header-fixed">
		<div class="container-fluid">
			<div class="row">
				<div class="col-xs-2 text-center">
					<a href="javascript: history.back();">
						<span class="glyphicon glyphicon-menu-left"></span>
					</a>
				</div>
				<div class="col-xs-8">
					<form id="searchForm" action="${base}/article/search" method="get">
						<div class="input-group">
							<input id="keyword" name="keyword" class="form-control" type="text" placeholder="${message("shop.article.search")}">
							<span class="input-group-btn">
								<button class="btn btn-default" type="submit">
									<span class="glyphicon glyphicon-search"></span>
								</button>
							</span>
						</div>
					</form>
				</div>
				<div class="col-xs-2 text-center">
					<div class="menu dropdown">
						<a href="javascript:;" data-toggle="dropdown">
							<span class="glyphicon glyphicon-th-list"></span>
							<span class="caret"></span>
						</a>
						<ul class="dropdown-menu">
							<li>
								<a href="${base}/">
									<span class="glyphicon glyphicon-home"></span>
									${message("shop.common.index")}
								</a>
							</li>
							<li>
								<a href="${base}/cart/list">
									<span class="glyphicon glyphicon-shopping-cart"></span>
									${message("shop.common.cart")}
								</a>
							</li>
							<li>
								<a href="${base}/member/index">
									<span class="glyphicon glyphicon-user"></span>
									${message("shop.common.member")}
								</a>
							</li>
						</ul>
					</div>
				</div>
			</div>
		</div>
	</header>
	<main>
		<div class="container-fluid">
			<h1>${article.title}</h1>
			<div class="summary gray-darker">
				<span>${message("shop.article.createdDate")}: ${article.createdDate}</span>
				[#if article.author?has_content]
					<span>${message("shop.article.author")}: ${article.author}</span>
				[/#if]
				<span>
					${message("shop.article.hits")}:
					<em id="hits">&nbsp;</em>
				</span>
			</div>
			[#noautoesc]
				<article>${article.content}</article>
			[/#noautoesc]
		</div>
	</main>
</body>
</html>