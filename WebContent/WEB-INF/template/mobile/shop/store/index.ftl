<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	[@seo type = "storeIndex"]
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
	<link href="${base}/resources/mobile/shop/css/store.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/mobile/shop/js/html5shiv.js"></script>
		<script src="${base}/resources/mobile/shop/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/mobile/shop/js/jquery.js"></script>
	<script src="${base}/resources/mobile/shop/js/bootstrap.js"></script>
	<script src="${base}/resources/mobile/shop/js/jquery.lazyload.js"></script>
	<script src="${base}/resources/mobile/shop/js/jquery.validate.js"></script>
	<script src="${base}/resources/mobile/shop/js/velocity.js"></script>
	<script src="${base}/resources/mobile/shop/js/velocity.ui.js"></script>
	<script src="${base}/resources/mobile/shop/js/underscore.js"></script>
	<script src="${base}/resources/mobile/shop/js/hammer.js"></script>
	<script src="${base}/resources/mobile/shop/js/common.js"></script>
	<script type="text/javascript">
	$().ready(function() {
		
		var $storeProductCategory = $("#storeProductCategory");
		var $storeProductCategoryContent = $("#storeProductCategory div.store-product-category-content");
		var $closeStoreProductCategory = $("#closeStoreProductCategory");
		var $searchForm = $("#searchForm");
		var $keyword = $("#keyword");
		var $addStoreFavorite = $("#addStoreFavorite");
		var $masthead = $("#masthead");
		var $productImage = $("div.thumbnail img");
		var $showStoreProductCategory = $("#showStoreProductCategory");
		
		// 店铺商品分类
		$closeStoreProductCategory.click(function() {
			$storeProductCategory.velocity("transition.slideRightBigOut").parent().velocity("fadeOut");
		});
		
		// 搜索
		$searchForm.submit(function() {
			if ($.trim($keyword.val()) == "") {
				return false;
			}
		});
		
		// 店铺收藏
		$addStoreFavorite.click(function() {
			$.ajax({
				url: "${base}/member/store_favorite/add",
				type: "POST",
				data: {
					storeId: ${store.id}
				},
				dataType: "json",
				cache: false
			});
			return false;
		});
		
		[#if store.storeAdImages?has_content]
			// 店铺广告图片
			new Hammer($masthead.get(0)).on("swipeleft", function() {
				$masthead.carousel("next");
			}).on("swiperight", function() {
				$masthead.carousel("prev");
			});
		[/#if]
		
		// 商品图片
		$productImage.lazyload({
			threshold: 100,
			effect: "fadeIn"
		});
		
		// 店铺商品分类
		$showStoreProductCategory.click(function() {
			$storeProductCategory.velocity("transition.slideRightBigIn").parent().velocity("fadeIn");
		});
	
	});
	</script>
</head>
<body class="store-index">
	[@store_product_category_root_list storeId = store.id]
		[#if storeProductCategories?has_content]
			<div class="store-product-category-wrapper">
				<div id="storeProductCategory" class="store-product-category">
					<div class="store-product-category-content">
						<div class="store-product-category-body">
							[#list storeProductCategories as storeProductCategory]
								<dl class="clearfix">
									<dt>
										<a href="${base}${storeProductCategory.path}">${abbreviate(storeProductCategory.name, 15)}</a>
									</dt>
									[@store_product_category_children_list storeProductCategoryId = storeProductCategory.id storeId = store.id recursive = false]
										[#list storeProductCategories as storeProductCategory]
											<dd>
												<a href="${base}${storeProductCategory.path}">${abbreviate(storeProductCategory.name, 15)}</a>
											</dd>
										[/#list]
									[/@store_product_category_children_list]
								</dl>
							[/#list]
						</div>
						<div class="store-product-category-footer">
							<button id="closeStoreProductCategory" class="btn btn-lg btn-primary btn-flat btn-block" type="button">${message("shop.store.close")}</button>
						</div>
					</div>
				</div>
			</div>
		[/#if]
	[/@store_product_category_root_list]
	<header class="header-fixed">
		<div class="container-fluid">
			<div class="row">
				<div class="col-xs-2 text-center">
					<a href="javascript: history.back();">
						<span class="glyphicon glyphicon-menu-left"></span>
					</a>
				</div>
				<div class="col-xs-8">
					<form id="searchForm" action="${base}/product/search" method="get">
						<input name="storeId" type="hidden" value="${store.id}">
						<div class="input-group">
							<input id="keyword" name="keyword" class="form-control" type="text" placeholder="${message("shop.store.search")}">
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
			<div class="media">
				<div class="media-left media-middle">
					<img src="${store.logo!setting.defaultStoreLogo}" alt="${store.name}">
				</div>
				<div class="media-body media-middle">
					<h4 class="media-heading">${abbreviate(store.name, 20, "...")}</h4>
					[#if store.type == "self"]
						<em>${message("Store.Type.self")}</em>
					[/#if]
				</div>
				<div class="media-right media-middle">
					<a id="addStoreFavorite" class="small" href="javascript:;">
						<span class="fa fa-star-o"></span>
						${message("shop.store.addStoreFavorite")}
					</a>
				</div>
			</div>
			[#if store.storeAdImages?has_content]
				<div id="masthead" class="masthead carousel slide" data-ride="carousel">
					<ol class="carousel-indicators">
						[#list store.storeAdImages as storeAdImage]
							<li[#if storeAdImage_index == 0] class="active"[/#if] data-target="#masthead" data-slide-to="${storeAdImage_index}"></li>
						[/#list]
					</ol>
					<ul class="carousel-inner">
						[#list store.storeAdImages as storeAdImage]
							<li class="item[#if storeAdImage_index == 0] active[/#if]">
								[#if storeAdImage.url??]
									<a href="${storeAdImage.url}" title="${storeAdImage.title}">
										<img src="${storeAdImage.image}" alt="${storeAdImage.title}">
									</a>
								[#else]
									<img src="${storeAdImage.image}" alt="${storeAdImage.title}">
								[/#if]
							</li>
						[/#list]
					</ul>
				</div>
			[/#if]
			[#if store.storeProductTags?has_content]
				[#list storeProductTags as storeProductTag]
					[@product_list storeId = store.id storeProductTagId = storeProductTag.id count = 10]
						<div class="products panel panel-flat panel-condensed">
							<div class="panel-heading">
								[#if storeProductTag.icon?has_content]
									<img src="${storeProductTag.icon}" alt="${storeProductTag.name}">
								[/#if]
								${storeProductTag.name}
							</div>
							<div class="panel-body">
								<div class="row">
									[#list products as product]
										[#assign defaultSku = product.defaultSku /]
										<div class="col-xs-6">
											<div class="thumbnail thumbnail-flat thumbnail-condensed">
												<a href="${base}${product.path}">
													<img class="img-responsive center-block" src="${base}/upload/image/blank.gif" alt="${product.name}" data-original="${product.thumbnail!setting.defaultThumbnailProductImage}">
													<h4 class="text-overflow">${product.name}</h4>
													<p class="text-overflow text-muted small">${product.caption}</p>
												</a>
												[#if product.type == "general"]
													<strong class="red">${currency(defaultSku.price, true)}</strong>
												[#elseif product.type == "exchange"]
													<span class="small">${message("Sku.exchangePoint")}:</span>
													<strong class="red">${defaultSku.exchangePoint}</strong>
												[/#if]
												<p>
													[#if product.store.type == "self"]
														<em class="small">${message("Store.Type.self")}</em>
													[/#if]
													<a class="small gray-darker" href="${base}${product.store.path}" title="${product.store.name}">${abbreviate(product.store.name, 16, "...")}</a>
												</p>
											</div>
										</div>
									[/#list]
								</div>
							</div>
						</div>
					[/@product_list]
				[/#list]
			[/#if]
		</div>
	</main>
	<footer class="footer-fixed">
		<div class="container-fluid">
			<div class="row">
				<div class="col-xs-3 text-center">
					<span class="glyphicon glyphicon-home"></span>
					<a href="${base}/">${message("shop.common.index")}</a>
				</div>
				<div class="col-xs-3 text-center">
					<span class="glyphicon glyphicon-th-list"></span>
					<a id="showStoreProductCategory" href="javascript:;">${message("shop.store.storeProductCategory")}</a>
				</div>
				<div class="col-xs-3 text-center">
					<span class="glyphicon glyphicon-shopping-cart"></span>
					<a href="${base}/cart/list">${message("shop.common.cart")}</a>
				</div>
				<div class="col-xs-3 text-center">
					<span class="glyphicon glyphicon-user"></span>
					<a href="${base}/member/index">${message("shop.common.member")}</a>
				</div>
			</div>
		</div>
	</footer>
</body>
</html>