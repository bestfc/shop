<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
[@seo type = "storeIndex"]
	<title>${seo.resolveTitle()}[#if showPowered] [/#if]</title>
	[#if seo.resolveKeywords()?has_content]
		<meta name="keywords" content="${seo.resolveKeywords()}" />
	[/#if]
	[#if seo.resolveDescription()?has_content]
		<meta name="description" content="${seo.resolveDescription()}" />
	[/#if]
[/@seo]
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/shop/bxslider/bxslider.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/animate.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/product.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/store.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/shop/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/jquery.lazyload.js"></script>
<script type="text/javascript" src="${base}/resources/shop/bxslider/bxslider.min.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/common.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $slider = $("#slider");
	var $shoppingCar = $("#shoppingCar");
	var $compareBar = $("#compareBar");
	var $compareForm = $("#compareBar form");
	var $compareSubmit = $("#compareBar a.submit");
	var $clearCompare = $("#compareBar a.clear");
	var $result = $("#result");
	var $productImage = $("#result img");
	var $addCart = $("#result a.addCart");
	var $exchange = $("#result a.exchange");
	var $addProductFavorite = $("#result a.addProductFavorite");
	var $addCompare = $("#result a.addCompare");
	var $storeId = $("#storeId");
	$slider.bxSlider({
		mode: "vertical",
		auto: true,
		controls: false
	});
	
	$productImage.lazyload({
		threshold: 100,
		effect: "fadeIn"
	});
	
	// 加入购物车
	$addCart.click(function() {
		var $this = $(this);
		var skuId = $this.attr("skuId");
		$.ajax({
			url: "${base}/cart/add",
			type: "POST",
			data: {skuId: skuId, quantity: 1},
			dataType: "json",
			cache: false,
			success: function(message) {
				if ($shoppingCar.size() > 0 && window.XMLHttpRequest) {
					var $image = $this.closest("li").find("img");
					var cartOffset = $shoppingCar.offset();
					var imageOffset = $image.offset();
					$image.clone().css({
						width: 170,
						height: 170,
						position: "absolute",
						"z-index": 20,
						top: imageOffset.top,
						left: imageOffset.left,
						opacity: 0.8,
						border: "1px solid #dddddd",
						"background-color": "#eeeeee"
					}).appendTo("body").animate({
						width: 30,
						height: 30,
						top: cartOffset.top,
						left: cartOffset.left,
						opacity: 0.2
					}, 1000, function() {
						$(this).remove();
					});
				}
			}
		});
		return false;
	});
	
	// 积分兑换
	$exchange.click(function() {
		var skuId = $(this).attr("skuId");
		$.ajax({
			url: "${base}/order/check_exchange",
			type: "GET",
			data: {skuId: skuId, quantity: 1},
			dataType: "json",
			cache: false,
			success: function() {
				location.href = "${base}/order/checkout?type=exchange&skuId=" + skuId + "&quantity=1";
			}
		});
		return false;
	});
	
	// 添加SKU收藏
	$addProductFavorite.click(function() {
		var productId = $(this).attr("productId");
		$.ajax({
			url: "${base}/member/product_favorite/add",
			type: "POST",
			data: {productId: productId},
			dataType: "json"
		});
		return false;
	});
	
	// 对比栏
	var compareProduct = getCookie("compareProduct");
	var compareProductIds = compareProduct != null ? compareProduct.split(",") : [];
	if (compareProductIds.length > 0) {
		$.ajax({
			url: "${base}/product/compare_bar",
			type: "GET",
			data: {productIds: compareProductIds},
			dataType: "json",
			cache: true,
			success: function(data) {
				$.each(data, function (i, item) {
					var thumbnail = item.thumbnail != null ? item.thumbnail : "${setting.defaultThumbnailProductImage}";
					$compareBar.find("dt").after(
						[@compress single_line = true]
							'<dd>
								<input type="hidden" name="productIds" value="' + item.id + '" \/>
								<a href="${base}' + escapeHtml(item.path) + '" target="_blank">
									<img src="' + escapeHtml(thumbnail) + '" \/>
									<span title="' + escapeHtml(item.name) + '">' + escapeHtml(abbreviate(item.name, 50)) + '<\/span>
								<\/a>
								<strong>' + currency(item.price, true) + '[#if setting.isShowMarketPrice]<del>' + currency(item.marketPrice, true) + '<\/del>[/#if]<\/strong>
								<a href="javascript:;" class="remove" productId="' + item.id + '">[${message("shop.common.delete")}]<\/a>
							<\/dd>'
						[/@compress]
					);
				});
				$compareBar.fadeIn();
			}
		});
		
		$.each(compareProductIds, function(i, productId) { 
			$addCompare.filter("[productId='" + productId + "']").addClass("selected");
		});
	}
	
	// 移除对比
	$compareBar.on("click", "a.remove", function() {
		var $this = $(this);
		var productId = $this.attr("productId");
		$this.closest("dd").remove();
		for (var i = 0; i < compareProductIds.length; i ++) {
			if (compareProductIds[i] == productId) {
				compareProductIds.splice(i, 1);
				break;
			}
		}
		$addCompare.filter("[productId='" + productId + "']").removeClass("selected");
		if (compareProductIds.length == 0) {
			$compareBar.fadeOut();
			removeCookie("compareProduct");
		} else {
			addCookie("compareProduct", compareProductIds.join(","));
		}
		return false;
	});
	
	$compareSubmit.click(function() {
		if (compareProductIds.length < 2) {
			$.alert("${message("shop.product.compareNotAllowed")}");
			return false;
		}
		
		$compareForm.submit();
		return false;
	});
	
	// 清除对比
	$clearCompare.click(function() {
		$addCompare.removeClass("selected");
		$compareBar.fadeOut().find("dd:not(.action)").remove();
		compareProductIds = [];
		removeCookie("compareProduct");
		return false;
	});
	
	// 添加对比
	$addCompare.click(function() {
		var $this = $(this);
		var productId = $this.attr("productId");
		if ($.inArray(productId, compareProductIds) >= 0) {
			return false;
		}
		if (compareProductIds.length >= 4) {
			$.alert("${message("shop.product.addCompareNotAllowed")}");
			return false;
		}
		$.ajax({
			url: "${base}/product/add_compare",
			type: "GET",
			data: {productId: productId},
			dataType: "json",
			cache: false,
			success: function(data) {
				$this.addClass("selected");
				var thumbnail = data.thumbnail != null ? data.thumbnail : "${setting.defaultThumbnailProductImage}";
				$compareBar.show().find("dd.action").before(
					[@compress single_line = true]
						'<dd>
							<input type="hidden" name="productIds" value="' + data.id + '" \/>
							<a href="${base}' + escapeHtml(data.path) + '" target="_blank">
								<img src="' + escapeHtml(thumbnail) + '" \/>
								<span title="' + escapeHtml(data.name) + '">' + escapeHtml(abbreviate(data.name, 50)) + '<\/span>
							<\/a>
							<strong>' + currency(data.price, true) + '[#if setting.isShowMarketPrice]<del>' + currency(data.marketPrice, true) + '<\/del>[/#if]<\/strong>
							<a href="javascript:;" class="remove" productId="' + data.id + '">[${message("shop.common.delete")}]<\/a>
						<\/dd>'
					[/@compress]
				);
				compareProductIds.unshift(productId);
				addCookie("compareProduct", compareProductIds.join(","));
			}
		});
		return false;
	});
	
})
</script>
</head>
<body>
[#include "/shop/include/header.ftl" /]
<div class="container products">
	<div id="compareBar" class="compareBar">
		<form action="${base}/product/compare" method="get">
			<dl>
				<dt>${message("shop.product.compareBar")}</dt>
				<dd class="action">
					<a href="javascript:;" class="submit">${message("shop.product.compareSubmit")}</a>
					<a href="javascript:;" class="clear">${message("shop.product.clearCompare")}</a>
				</dd>
			</dl>
		</form>
	</div>
	[#include "/shop/include/store_left.ftl" /]
	<div id="result" class="storeRight">
		[#if store.storeAdImages?has_content]
			<div class="storeBanner">
				<div id="slider" class="slider">
					[#list store.storeAdImages as ad]
						<li>
							<a href="${(ad.url)!"javascript:;"}"[#if ad.title?has_content] title="${ad.title}"[/#if]>
								<img src="${ad.image}"[#if ad.title?has_content] alt="${ad.title}"[/#if] />
							</a>
						</li>
					[/#list]
				</div>
			</div>
		[/#if]
		[#list storeProductTags as storeProductTag]
			[@product_list storeId = store.id storeProductTagId = storeProductTag.id]
				[#if products?has_content]
					<div class="storeProductTag">
						<div>
							[#if storeProductTag.icon?has_content]
								<img src="${storeProductTag.icon}" alt="${storeProductTag.name}" />
							[/#if]
						</div>
						<span>${storeProductTag.name}</span>
					</div>
					<div class="result grid clearfix">
						[#list products as product]
							<ul>
								[#assign defaultSku = product.defaultSku /]
								<li>
									<a href="${base}${product.path}">
										<img src="${base}/upload/image/blank.gif" data-original="${product.thumbnail!setting.defaultThumbnailProductImage}" />
										<div>${abbreviate(product.name, 48)}</div>
									</a>
									<strong>
										[#if product.type == "general"]
											${currency(defaultSku.price, true)}
										[#elseif product.type == "exchange"]
											<em>${message("Sku.exchangePoint")}:</em>
											${defaultSku.exchangePoint}
										[/#if]
									</strong>
									<div class="listShop">
										<div class="shopName">
											<a href="${base}${product.store.path}" title="${product.store.name}">${abbreviate(product.store.name, 14)}</a>
											[#if product.store != null && product.store.type == "self"]
												<em>${message("Store.Type.self")}</em>
											[/#if]
										</div>
									</div>
									<div class="action">
										[#if product.type == "general"]
											<a href="javascript:;" class="addCart" skuId="${defaultSku.id}">${message("shop.product.addCart")}</a>
										[#elseif product.type == "exchange"]
											<a href="javascript:;" class="exchange" skuId="${defaultSku.id}">${message("shop.product.exchange")}</a>
										[/#if]
										<a href="javascript:;" class="addProductFavorite" title="${message("shop.product.addProductFavorite")}" productId="${product.id}">&nbsp;</a>
										<a href="javascript:;" class="addCompare" title="${message("shop.product.addCompare")}" productId="${product.id}">&nbsp;</a>
									</div>
								</li>
							[/#list]
						</ul>
					</div>
				[/#if]
			[/@product_list]
		[/#list]
	</div>
</div>
[#include "/shop/include/footer.ftl" /]
</body>
</html>