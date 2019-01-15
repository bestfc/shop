<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("shop.productCategory.title")}[#if showPowered] [/#if]</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/mobile/shop/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/animate.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/common.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/product_category.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/mobile/shop/js/html5shiv.js"></script>
		<script src="${base}/resources/mobile/shop/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/mobile/shop/js/jquery.js"></script>
	<script src="${base}/resources/mobile/shop/js/bootstrap.js"></script>
	<script src="${base}/resources/mobile/shop/js/underscore.js"></script>
	<script src="${base}/resources/mobile/shop/js/common.js"></script>
</head>
<body class="product-category">
	<header class="header-fixed">
		<a class="pull-left" href="javascript: history.back();">
			<span class="glyphicon glyphicon-menu-left"></span>
		</a>
		${message("shop.productCategory.title")}
	</header>
	<main>
		<table>
			[#list rootProductCategories as rootProductCategory]
				<tr[#if !rootProductCategory_has_next] class="last"[/#if]>
					<th>
						<a href="${base}${rootProductCategory.path}">${rootProductCategory.name}</a>
					</th>
					<td>
						[#list rootProductCategory.children as productCategory]
							<a href="${base}${productCategory.path}">${productCategory.name}</a>
						[/#list]
					</td>
				</tr>
			[/#list]
		</table>
	</main>
	<footer class="footer-fixed">
		<div class="container-fluid">
			<div class="row">
				<div class="col-xs-3 text-center">
					<span class="glyphicon glyphicon-home"></span>
					<a href="${base}/">${message("shop.common.index")}</a>
				</div>
				<div class="col-xs-3 text-center active">
					<span class="glyphicon glyphicon-th-list"></span>
					<a href="${base}/product_category">${message("shop.common.productCategory")}</a>
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