<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.productNotify.list")}[#if showPowered] [/#if]</title>
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
	<script id="productNotifyTemplate" type="text/template">
		<%_.each(productNotifys, function(productNotify, i) {%>
			<div class="panel panel-flat">
				<div class="panel-heading small">${message("member.productNotify.sn")}: <%-productNotify.sku.sn%></div>
				<div class="panel-body">
					<div class="media">
						<div class="media-left media-middle">
							<a href="${base}<%-productNotify.sku.path%>">
								<img src="<%-productNotify.sku.thumbnail != null ? productNotify.sku.thumbnail : "${setting.defaultThumbnailProductImage}"%>" alt="<%-productNotify.sku.name%>">
							</a>
						</div>
						<div class="media-body media-middle">
							<h4 class="media-heading">
								<a href="${base}<%-productNotify.sku.path%>" title="<%-productNotify.sku.name%>"><%-abbreviate(productNotify.sku.name, 30)%></a>
							</h4>
							<span class="small gray-darker">${message("member.productNotify.email")}: <%-productNotify.email%></span>
						</div>
					</div>
				</div>
				<div class="panel-footer text-right">
					<a class="delete btn btn-sm btn-default" href="javascript:;" data-product-notify-id="<%-productNotify.id%>">${message("member.common.delete")}</a>
				</div>
			</div>
		<%})%>
	</script>
	<script type="text/javascript">
		$().ready(function() {
			
			var $productNotifyItems = $("#productNotifyItems");
			var productNotifyTemplate = _.template($("#productNotifyTemplate").html());
			
			// 删除
			$productNotifyItems.on("click", "a.delete", function() {
				if (confirm("${message("member.dialog.deleteConfirm")}")) {
					var $element = $(this);
					var productNotifyId = $element.data("product-notify-id");
					$.ajax({
						url: "delete",
						type: "POST",
						data: {
							productNotifyId: productNotifyId
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
			$productNotifyItems.infiniteScroll({
				url: function(pageNumber) {
					return "${base}/member/product_notify/list?pageNumber=" + pageNumber;
				},
				pageSize: 10,
				template: function(pageNumber, data) {
					return productNotifyTemplate({
						productNotifys: data
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
		${message("member.productNotify.list")}
	</header>
	<main>
		<div class="container-fluid">
			<div id="productNotifyItems"></div>
		</div>
	</main>
</body>
</html>