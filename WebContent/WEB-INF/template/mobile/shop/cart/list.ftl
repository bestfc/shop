<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("shop.cart.title")}[#if showPowered] [/#if]</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/mobile/shop/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/animate.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/common.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/cart.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/mobile/shop/js/html5shiv.js"></script>
		<script src="${base}/resources/mobile/shop/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/mobile/shop/js/jquery.js"></script>
	<script src="${base}/resources/mobile/shop/js/bootstrap.js"></script>
	<script src="${base}/resources/mobile/shop/js/jquery.spinner.js"></script>
	<script src="${base}/resources/mobile/shop/js/velocity.js"></script>
	<script src="${base}/resources/mobile/shop/js/velocity.ui.js"></script>
	<script src="${base}/resources/mobile/shop/js/underscore.js"></script>
	<script src="${base}/resources/mobile/shop/js/common.js"></script>
	<script id="giftTemplate" type="text/template">
		<%if (!_.isEmpty(giftNames)) {%>
			<dl class="clearfix">
				<dt>${message("shop.cart.gift")}</dt>
				<%_.each(giftNames, function(giftName, i) {%>
					<dd title="<%-giftName%>"><%-abbreviate(giftName, 50)%></dd>
				<%})%>
			</dl>
		<%}%>
	</script>
	<script id="promotionTemplate" type="text/template">
		<%if (!_.isEmpty(promotionNames)) {%>
			<dl class="clearfix">
				<dt>${message("shop.cart.promotionDiscount")}</dt>
				<%_.each(promotionNames, function(promotionName, i) {%>
					<dd title="<%-promotionName%>"><%-abbreviate(promotionName, 50)%></dd>
				<%})%>
			</dl>
		<%}%>
	</script>
	<script type="text/javascript">
	$().ready(function() {
		
		var $modify = $("#modify");
		var $spinner = $("div.spinner");
		var $remove = $("button.remove");
		var $effectivePrice = $("#effectivePrice");
		var $clear = $("#clear");
		var $checkout = $("#checkout");
		var giftTemplate = _.template($("#giftTemplate").html());
		var promotionTemplate = _.template($("#promotionTemplate").html());
		
		[#if flashMessage?has_content]
			$.alert("${flashMessage}");
		[/#if]
		
		// 修改
		$modify.click(function() {
			var $element = $(this);
			if ($element.hasClass("active")) {
				$element.text("${message("shop.cart.modify")}");
				$remove.add($clear).velocity("fadeOut");
			} else {
				$element.text("${message("shop.cart.complete")}");
				$remove.velocity("fadeIn");
				$clear.velocity("fadeIn", {
					display: "block"
				});
			}
			$element.toggleClass("active");
		});
		
		// 数量
		$spinner.spinner({
			min: 1,
			max: 10000
		}).spinner("changing", function(e, newValue, oldValue) {
			var $element = $(this);
			var skuId = $element.data("sku-id");
			var storeGift = $element.closest("div.list-group").siblings("div.gift");
			var storePromotion = $element.closest("div.list-group").siblings("div.promotion");
			$.ajax({
				url: "modify",
				type: "POST",
				data: {
					skuId: skuId,
					quantity: newValue
				},
				dataType: "json",
				beforeSend: function() {
					$checkout.prop("disabled", true);
				},
				success: function(data) {
					if (!data.isLowStock) {
						$element.closest("div.list-group-item").find("a.product-image strong").remove();
					}
					storeGift.html(giftTemplate({
						giftNames: data.giftNames
					}));
					storePromotion.html(promotionTemplate({
						promotionNames: data.promotionNames
					}));
					$effectivePrice.text(currency(data.effectivePrice, true, true));
				},
				error: function() {
					if (newValue > oldValue) {
						$element.val(oldValue);
					}
				},
				complete: function() {
					$checkout.prop("disabled", false);
				}
			});
		});
		
		// 移除
		$remove.click(function() {
			if (confirm("${message("shop.dialog.deleteConfirm")}")) {
				var $element = $(this);
				var skuId = $element.data("sku-id");
				var storeGift = $element.closest("div.list-group").siblings("div.gift");
				var storePromotion = $element.closest("div.list-group").siblings("div.promotion");
				$.ajax({
					url: "remove",
					type: "POST",
					data: {
						skuId: skuId
					},
					dataType: "json",
					beforeSend: function() {
						$checkout.prop("disabled", true);
					},
					success: function(data) {
						if (data.quantity > 0) {
							$element.closest("div.list-group-item").velocity("slideUp");
							storeGift.html(giftTemplate({
								giftNames: data.giftNames
							}));
							storePromotion.html(promotionTemplate({
								promotionNames: data.promotionNames
							}));
							$effectivePrice.text(currency(data.effectivePrice, true, true));
						} else {
							location.reload(true);
						}
					},
					complete: function() {
						$checkout.prop("disabled", false);
					}
				});
			}
		});
		
		// 清空
		$clear.click(function() {
			if (confirm("${message("shop.dialog.clearConfirm")}")) {
				$.ajax({
					url: "clear",
					type: "POST",
					dataType: "json",
					success: function() {
						location.reload(true);
					}
				});
			}
		});
		
		// 结算
		$checkout.click(function() {
			location.href = "${base}/order/checkout";
		});
	
	});
	</script>
</head>
<body class="cart-list">
	<header class="header-fixed">
		<a class="pull-left" href="javascript: history.back();">
			<span class="glyphicon glyphicon-menu-left"></span>
		</a>
		${message("shop.cart.title")}
		[#if currentCart?? && currentCart.cartItems?has_content && currentCart.stores?has_content]
			<a id="modify" class="pull-right" href="javascript:;">${message("shop.cart.modify")}</a>
		[/#if]
	</header>
	<main>
		<div class="container-fluid">
			[#if currentCart?? && currentCart.cartItems?has_content && currentCart.stores?has_content]
				[#list currentCart.stores as store]
					<div class="list">
						<div class="list-group list-group-flat">
							<div class="title list-group-item">
								[#if store.type == "self"]
									<em class="small">${message("shop.cart.self")}</em>
								[/#if]
								<a href="${base}${store.path}">${abbreviate(store.name, 50, "...")}</a>
							</div>
							[#list currentCart.getCartItems(store) as cartItem]
								<div class="list-group-item">
									<div class="media">
										<div class="media-left media-middle">
											<a class="product-image" href="${base}${cartItem.sku.path}" title="${cartItem.sku.name}">
												<img class="img-responsive center-block" src="${cartItem.sku.thumbnail!setting.defaultThumbnailProductImage}" alt="${cartItem.sku.name}">
												[#if !cartItem.isMarketable]
													<strong>${message("shop.cart.notMarketable")}</strong>
												[/#if]
												[#if cartItem.isLowStock]
													<strong>${message("shop.cart.lowStock")}</strong>
												[/#if]
											</a>
										</div>
										<div class="media-body">
											<h4 class="media-heading">
												<a href="${base}${cartItem.sku.path}" title="${cartItem.sku.name}">${abbreviate(cartItem.sku.name, 50, "...")}</a>
											</h4>
											[#if cartItem.sku.specifications?has_content]
												<span class="small gray-darker">${cartItem.sku.specifications?join(", ")}</span>
											[/#if]
											<strong class="red">${currency(cartItem.price, true)}</strong>
										</div>
										<div class="media-right media-bottom text-right">
											<button class="remove btn btn-sm btn-red" type="button" data-sku-id="${cartItem.sku.id}">${message("shop.cart.remove")}</button>
											<div class="spinner input-group input-group-sm">
												<div class="input-group-addon" data-spin="down">-</div>
												<input class="form-control" type="text" value="${cartItem.quantity}" maxlength="4" data-sku-id="${cartItem.sku.id}">
												<div class="input-group-addon" data-spin="up">+</div>
											</div>
										</div>
									</div>
								</div>
								[#if !currentUser??]
									<div class="list-group-item">
										<a class="small orange" href="${base}/member/login">${message("shop.cart.promotionTips")}</a>
									</div>
								[/#if]
							[/#list]
						</div>
						<div class="gift">
							[#if currentCart.getGiftNames(store)?has_content]
								<dl class="clearfix">
									<dt class="red">${message("shop.cart.gift")}</dt>
									[#list currentCart.getGiftNames(store) as giftName]
										<dd class="gray" title="${giftName}">${abbreviate(giftName, 50)}</dd>
									[/#list]
								</dl>
							[/#if]
						</div>
						<div class="promotion">
							[#if currentCart.getPromotionNames(store)?has_content]
								<dl class="clearfix">
									<dt class="red">${message("shop.cart.promotionDiscount")}</dt>
									[#list currentCart.getPromotionNames(store) as promotionName]
										<dd class="gray" title="${promotionName}">${abbreviate(promotionName, 50)}</dd>
									[/#list]
								</dl>
							[/#if]
						</div>
					</div>
				[/#list]
			[#else]
				<p>
					<a href="${base}/">${message("shop.cart.empty")}</a>
				</p>
			[/#if]
		</div>
	</main>
	<footer class="footer-fixed">
		<div class="container-fluid">
			<div class="row">
				<div class="col-xs-6 text-center">
					[#if currentCart?? && currentCart.cartItems?has_content]
						${message("shop.cart.total")}:
						<strong id="effectivePrice" class="red">${currency(currentCart.getEffectivePriceTotal(currentCart.stores), true, true)}</strong>
					[/#if]
				</div>
				<div class="col-xs-3">
					<button id="clear" class="clear btn btn-orange btn-flat btn-block" type="button">${message("shop.cart.clear")}</button>
				</div>
				<div class="col-xs-3">
					<button id="checkout" class="btn btn-red btn-flat btn-block" type="button"[#if !currentCart?? || !currentCart.cartItems?has_content] disabled[/#if]>${message("shop.cart.checkout")}</button>
				</div>
			</div>
		</div>
	</footer>
</body>
</html>