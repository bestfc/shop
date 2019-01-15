<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.productFavorite.list")}[#if showPowered] [/#if]</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/mobile/member/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/animate.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/common.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/profile.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/mobile/member/js/html5shiv.js"></script>
		<script src="${base}/resources/mobile/member/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/mobile/member/js/jquery.js"></script>
	<script src="${base}/resources/mobile/member/js/bootstrap.js"></script>
	<script src="${base}/resources/mobile/member/js/velocity.js"></script>
	<script src="${base}/resources/mobile/member/js/velocity.ui.js"></script>
	<script src="${base}/resources/mobile/member/js/underscore.js"></script>
	<script src="${base}/resources/mobile/member/js/common.js"></script>
	<script id="productFavoriteTemplate" type="text/template">
		<%_.each(productFavorites, function(productFavorite, i) {%>
			<div class="panel panel-flat">
				<div class="panel-heading small">${message("Product.sn")}: <%-productFavorite.product.sn%></div>
				<div class="panel-body">
					<div class="media">
						<div class="media-left media-middle">
							<a href="${base}<%-productFavorite.product.path%>" title="<%-productFavorite.product.name%>">
								<img src="<%-productFavorite.product.thumbnail != null ? productFavorite.product.thumbnail : "${setting.defaultThumbnailProductImage}"%>" alt="<%-productFavorite.product.name%>">
							</a>
						</div>
						<div class="media-body media-middle">
							<h4 class="media-heading">
								<a href="${base}<%-productFavorite.product.path%>" title="<%-productFavorite.product.name%>"><%-abbreviate(productFavorite.product.name, 30)%></a>
							</h4>
						</div>
						<div class="media-right media-middle">
							<%-currency(productFavorite.product.price, true)%>
						</div>
					</div>
				</div>
				<div class="panel-footer text-right">
					<a class="delete btn btn-sm btn-default" href="javascript:;" data-product-favorite-id="<%-productFavorite.id%>">${message("member.common.delete")}</a>
				</div>
			</div>
		<%})%>
	</script>
	<script type="text/javascript">
		$().ready(function() {
			
			var $productFavoriteItems = $("#productFavoriteItems");
			var productFavoriteTemplate = _.template($("#productFavoriteTemplate").html());
			
			// 删除
			$productFavoriteItems.on("click", "a.delete", function() {
				if (confirm("${message("member.dialog.deleteConfirm")}")) {
					var $element = $(this);
					var productFavoriteId = $element.data("product-favorite-id");
					$.ajax({
						url: "delete",
						type: "POST",
						data: {
							productFavoriteId: productFavoriteId
						},
						dataType: "json",
						success: function() {
							$element.closest("div.panel").velocity("slideUp", {
								complete: function() {
									var $panel = $(this);
									if ($panel.siblings("div.panel").size() < 1) {
										setTimeout(function() {
											location.reload(true);
										}, 3000);
									}
									$panel.remove();
								}
							});
						}
					});
				}
				return false;
			});
			
			// 无限滚动加载
			$productFavoriteItems.infiniteScroll({
				url: function(pageNumber) {
					return "${base}/member/product_favorite/list?pageNumber=" + pageNumber;
				},
				pageSize: 10,
				template: function(pageNumber, data) {
					return productFavoriteTemplate({
						productFavorites: data
					});
				}
			});
			
		});
	</script>
</head>
<body class="profile">
	<header class="header-fixed">
		<a class="pull-left" href="${base}/member/index">
			<span class="glyphicon glyphicon-menu-left"></span>
		</a>
		${message("member.productFavorite.list")}
	</header>
	<main>
		<div class="container-fluid">
			<div id="productFavoriteItems"></div>
		</div>
	</main>
</body>
</html>