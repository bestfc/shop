<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	[@seo type = "articleSearch"]
		<title>${seo.resolveTitle()}[#if showPowered] [/#if]</title>
		[#if seo.resolveKeywords()?has_content]
			<meta name="keywords" content="${seo.resolveKeywords()}">
		[/#if]
		[#if seo.resolveDescription()?has_content]
			<meta name="description" content="${seo.resolveDescription()}">
		[/#if]
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
	<script src="${base}/resources/mobile/shop/js/moment.js"></script>
	<script src="${base}/resources/mobile/shop/js/common.js"></script>
	<script id="articleTemplate" type="text/template">
		<%_.each(articles, function(article, i) {%>
			<li>
				<a href="${base}<%-article.path%>">
					<strong><%-article.title%></strong>
					<p><%-article.text%></p>
					<span class="gray" title="<%-moment(new Date(article.createdDate)).format('YYYY-MM-DD HH:mm:ss')%>"><%-moment(new Date(article.createdDate)).format('YYYY-MM-DD')%></span>
				</a>
			</li>
		<%})%>
	</script>
	<script type="text/javascript">
	$().ready(function() {
		
		var $searchForm = $("#searchForm");
		var $keyword = $("#keyword");
		var $articleItems = $("#list ul");
		var articleTemplate = _.template($("#articleTemplate").html());
		
		// 搜索
		$searchForm.submit(function() {
			if ($.trim($keyword.val()) == "") {
				return false;
			}
		});
		
		// 无限滚动加载
		$articleItems.infiniteScroll({
			url: function(pageNumber) {
				return "${base}/article/search?pageNumber=" + pageNumber;
			},
			data: {
				keyword: "${articleKeyword?js_string}"
			},
			pageSize: 20,
			template: function(pageNumber, data) {
				$articleItems.append(articleTemplate({
					articles: data
				}));
			}
		});
	
	});
	</script>
</head>
<body class="article-list">
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
							<input id="keyword" name="keyword" class="form-control" type="text" value="${articleKeyword}" placeholder="${message("shop.article.search")}">
							<span class="input-group-btn">
								<button class="btn btn-default" type="submit">
									<span class="glyphicon glyphicon-search"></span>
								</button>
							</span>
						</div>
					</form>
				</div>
				<div class="col-xs-2 text-center">
					<a href="javascript:;">
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
					</a>
				</div>
			</div>
		</div>
	</header>
	<main>
		<div class="container-fluid">
			<div id="list" class="list">
				<ul></ul>
			</div>
		</div>
	</main>
</body>
</html>