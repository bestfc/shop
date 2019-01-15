[#assign defaultSku = product.defaultSku /]
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
[@seo type = "productDetail"]
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
<link href="${base}/resources/shop/css/product.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/shop/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/jquery.tools.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/jquery.jqzoom.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/common.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $shoppingCar = $("#shoppingCar");
	var $headerCart = $("#headerCart");
	var $historyProduct = $("#historyProduct");
	var $clearHistoryProduct = $("#historyProduct a.clear");
	var $zoom = $("#zoom");
	var $thumbnailScrollable = $("#thumbnailScrollable");
	var $thumbnail = $("#thumbnailScrollable a");
	var $dialogOverlay = $("#dialogOverlay");
	var $preview = $("#preview");
	var $previewClose = $("#preview a.close");
	var $previewScrollable = $("#previewScrollable");
	var $price = $("#price");
	var $marketPrice = $("#marketPrice");
	var $rewardPoint = $("#rewardPoint");
	var $exchangePoint = $("#exchangePoint");
	var $specification = $("#specification dl");
	var $specificationTips = $("#specification div");
	var $specificationValue = $("#specification a");
	var $productNotifyForm = $("#productNotifyForm");
	var $productNotify = $("#productNotify");
	var $productNotifyEmail = $("#productNotify input");
	var $addProductNotify = $("#addProductNotify");
	var $quantity = $("#quantity");
	var $increase = $("#increase");
	var $decrease = $("#decrease");
	var $addCart = $("#addCart");
	var $exchange = $("#exchange");
	var $addProductFavorite = $("#addProductFavorite");
	var $addStoreFavorite = $("#addStoreFavorite");
	var $window = $(window);
	var $bar = $("#bar ul");
	var $introductionTab = $("#introductionTab");
	var $parameterTab = $("#parameterTab");
	var $reviewTab = $("#reviewTab");
	var $consultationTab = $("#consultationTab");
	var $introduction = $("#introduction");
	var $parameter = $("#parameter");
	var $review = $("#review");
	var $addReview = $("#addReview");
	var $consultation = $("#consultation");
	var $addConsultation = $("#addConsultation");
	var $storeInfo = $("#storeInfo");
	var barTop = $bar.offset().top;
	var barWidth = $bar.width();
	var skuId = ${defaultSku.id};
	var skuData = {};
	
	[#if product.hasSpecification()]
		[#list product.skus as sku]
			skuData["${sku.specificationValueIds?join(",")}"] = {
				id: ${sku.id},
				price: ${sku.price},
				marketPrice: ${sku.marketPrice},
				rewardPoint: ${sku.rewardPoint},
				exchangePoint: ${sku.exchangePoint},
				isOutOfStock: ${sku.isOutOfStock?string("true", "false")}
			};
		[/#list]
		
		// 锁定规格值
		lockSpecificationValue();
	[/#if]
	
	// 商品图片放大镜
	$zoom.jqzoom({
		zoomWidth: 368,
		zoomHeight: 368,
		title: false,
		preloadText: null,
		preloadImages: false
	});
	
	// SKU缩略图滚动
	$thumbnailScrollable.scrollable();
	
	$thumbnail.hover(function() {
		var $this = $(this);
		if ($this.hasClass("current")) {
			return false;
		}
		
		$thumbnail.removeClass("current");
		$this.addClass("current").click();
	});
	
	var previewScrollable = $previewScrollable.scrollable({
		keyboard: true
	});
	
	// 商品图片预览
	$zoom.click(function() {
		$preview.show().find("img[data-original]").each(function() {
			var $this = $(this);
			$this.attr("src", $this.attr("data-original")).removeAttr("data-original");
		});
		previewScrollable.data("scrollable").seekTo($thumbnail.filter(".current").index(), 0);
		$dialogOverlay.show();
		return false;
	});
	
	$previewClose.click(function() {
		$preview.hide();
		$dialogOverlay.hide();
	});
	
	// 规格值选择
	$specificationValue.click(function() {
		var $this = $(this);
		if ($this.hasClass("locked")) {
			return false;
		}
		
		$this.toggleClass("selected").parent().siblings().children("a").removeClass("selected");
		lockSpecificationValue();
		return false;
	});
	
	// 锁定规格值
	function lockSpecificationValue() {
		var currentSpecificationValueIds = $specification.map(function() {
			$selected = $(this).find("a.selected");
			return $selected.size() > 0 ? $selected.attr("val") : [null];
		}).get();
		$specification.each(function(i) {
			$(this).find("a").each(function(j) {
				var $this = $(this);
				var specificationValueIds = currentSpecificationValueIds.slice(0);
				specificationValueIds[i] = $this.attr("val");
				if (isValid(specificationValueIds)) {
					$this.removeClass("locked");
				} else {
					$this.addClass("locked");
				}
			});
		});
		var sku = skuData[currentSpecificationValueIds.join(",")];
		if (sku != null) {
			skuId = sku.id;
			$price.text(currency(sku.price, true));
			$marketPrice.text(currency(sku.marketPrice, true));
			$rewardPoint.text(sku.rewardPoint);
			$exchangePoint.text(sku.exchangePoint);
			if (sku.isOutOfStock) {
				if ($addProductNotify.val() == "${message("shop.product.productNotifySubmit")}") {
					$productNotify.show();
				}
				$addProductNotify.show();
				$quantity.closest("dl").hide();
				$addCart.hide();
				$exchange.hide();
			} else {
				$productNotify.hide();
				$addProductNotify.hide();
				$quantity.closest("dl").show();
				$addCart.show();
				$exchange.show();
			}
		} else {
			skuId = null;
		}
	}
	
	// 判断规格值ID是否有效
	function isValid(specificationValueIds) {
		for(var key in skuData) {
			var ids = key.split(",");
			if (match(specificationValueIds, ids)) {
				return true;
			}
		}
		return false;
	}
	
	// 判断数组是否配比
	function match(array1, array2) {
		if (array1.length != array2.length) {
			return false;
		}
		for(var i = 0; i < array1.length; i ++) {
			if (array1[i] != null && array2[i] != null && array1[i] != array2[i]) {
				return false;
			}
		}
		return true;
	}
	
	// 到货通知
	$addProductNotify.click(function() {
		if (skuId == null) {
			$specificationTips.fadeIn(150).fadeOut(150).fadeIn(150);
			return false;
		}
		if ($addProductNotify.val() == "${message("shop.product.addProductNotify")}") {
			$addProductNotify.val("${message("shop.product.productNotifySubmit")}");
			$productNotify.show();
			$productNotifyEmail.focus();
			if ($.trim($productNotifyEmail.val()) == "") {
				$.ajax({
					url: "${base}/product_notify/email",
					type: "GET",
					dataType: "json",
					cache: false,
					success: function(data) {
						$productNotifyEmail.val(data.email);
					}
				});
			}
		} else {
			$productNotifyForm.submit();
		}
		return false;
	});
	
	// 到货通知表单验证
	$productNotifyForm.validate({
		rules: {
			email: {
				required: true,
				email: true
			}
		},
		submitHandler: function(form) {
			$.ajax({
				url: "${base}/product_notify/save",
				type: "POST",
				data: {skuId: skuId, email: $productNotifyEmail.val()},
				dataType: "json",
				cache: false,
				beforeSend: function() {
					$addProductNotify.prop("disabled", true);
				},
				success: function(data) {
					$addProductNotify.val("${message("shop.product.addProductNotify")}");
					$productNotify.hide();
				},
				complete: function() {
					$addProductNotify.prop("disabled", false);
				}
			});
		}
	});
	
	// 购买数量
	$quantity.keypress(function(event) {
		return (event.which >= 48 && event.which <= 57) || event.which == 8;
	});
	
	// 增加购买数量
	$increase.click(function() {
		var quantity = $quantity.val();
		if (/^\d*[1-9]\d*$/.test(quantity)) {
			$quantity.val(parseInt(quantity) + 1);
		} else {
			$quantity.val(1);
		}
	});
	
	// 减少购买数量
	$decrease.click(function() {
		var quantity = $quantity.val();
		if (/^\d*[1-9]\d*$/.test(quantity) && parseInt(quantity) > 1) {
			$quantity.val(parseInt(quantity)1);
		} else {
			$quantity.val(1);
		}
	});
	
	[#if product.type == "general"]
		// 加入购物车
		$addCart.click(function() {
			if (skuId == null) {
				$specificationTips.fadeIn(150).fadeOut(150).fadeIn(150);
				return false;
			}
			var quantity = $quantity.val();
			if (/^\d*[1-9]\d*$/.test(quantity)) {
				$.ajax({
					url: "${base}/cart/add",
					type: "POST",
					data: {skuId: skuId, quantity: quantity},
					dataType: "json",
					success: function() {
						if ($headerCart.size() > 0 && window.XMLHttpRequest) {
							var $image = $zoom.find("img");
							var cartOffset = $headerCart.offset();
							var imageOffset = $image.offset();
							$image.clone().css({
								width: 300,
								height: 300,
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
			} else {
				$.alert("${message("shop.product.quantityPositive")}");
			}
		});
	[#elseif product.type == "exchange"]
		// 积分兑换
		$exchange.click(function() {
			if (skuId == null) {
				$specificationTips.fadeIn(150).fadeOut(150).fadeIn(150);
				return false;
			}
			var quantity = $quantity.val();
			if (/^\d*[1-9]\d*$/.test(quantity)) {
				$.ajax({
					url: "${base}/order/check_exchange",
					type: "GET",
					data: {skuId: skuId, quantity: quantity},
					dataType: "json",
					cache: false,
					success: function() {
						location.href = "${base}/order/checkout?type=exchange&skuId=" + skuId + "&quantity=" + quantity;
					}
				});
			} else {
				$.alert("${message("shop.product.quantityPositive")}");
			}
		});
	[/#if]
	
	// 添加SKU收藏
	$addProductFavorite.click(function() {
		$.ajax({
			url: "${base}/member/product_favorite/add",
			type: "POST",
			data: {productId: ${product.id}},
			dataType: "json"
		});
		return false;
	});
	
	// 添加店铺收藏
	$addStoreFavorite.click(function() {
		$.ajax({
			url: "${base}/member/store_favorite/add",
			type: "POST",
			data: {storeId: ${product.store.id}},
			dataType: "json"
		});
		return false;
	});
	
	$bar.width(barWidth);
	
	$window.scroll(function() {
		var scrollTop = $(this).scrollTop();
		if (scrollTop > barTop) {
			$bar.addClass("fixed");
			var introductionTop = $introduction.size() > 0 ? $introduction.offset().top36 : null;
			var parameterTop = $parameter.size() > 0 ? $parameter.offset().top36 : null;
			var reviewTop = $review.size() > 0 ? $review.offset().top36 : null;
			var consultationTop = $consultation.size() > 0 ? $consultation.offset().top36 : null;
			if (consultationTop != null && scrollTop >= consultationTop) {
				$bar.find("li").removeClass("current");
				$consultationTab.addClass("current");
			} else if (reviewTop != null && scrollTop >= reviewTop) {
				$bar.find("li").removeClass("current");
				$reviewTab.addClass("current");
			} else if (parameterTop != null && scrollTop >= parameterTop) {
				$bar.find("li").removeClass("current");
				$parameterTab.addClass("current");
			} else if (introductionTop != null && scrollTop >= introductionTop) {
				$bar.find("li").removeClass("current");
				$introductionTab.addClass("current");
			}
		} else {
			$bar.removeClass("fixed").find("li").removeClass("current");
		}
	});
	
	[#if setting.isReviewEnabled]
		// 发表SKU评论
		$addReview.click(function() {
			if ($.checkLogin()) {
				return true;
			} else {
				$.redirectLogin("${base}/review/add/${product.id}", "${message("shop.product.addReviewNotAllowed")}");
				return false;
			}
		});
	[/#if]
	
	[#if setting.isConsultationEnabled]
		// 发表SKU咨询
		$addConsultation.click(function() {
			if ($.checkLogin()) {
				return true;
			} else {
				$.redirectLogin("${base}/consultation/add/${product.id}", "${message("shop.product.addConsultationNotAllowed")}");
				return false;
			}
		});
	[/#if]
	
	// 浏览记录
	var historyProduct = getCookie("historyProduct");
	var historyProductIds = historyProduct != null ? historyProduct.split(",") : [];
	for (var i = 0; i < historyProductIds.length; i ++) {
		if (historyProductIds[i] == ${product.id}) {
			historyProductIds.splice(i, 1);
			break;
		}
	}
	historyProductIds.unshift(${product.id});
	if (historyProductIds.length > 6) {
		historyProductIds.pop();
	}
	addCookie("historyProduct", historyProductIds.join(","));
	$.ajax({
		url: "${base}/product/history",
		type: "GET",
		data: {productIds: historyProductIds},
		dataType: "json",
		cache: true,
		success: function(data) {
			$.each(data, function (i, item) {
				var thumbnail = item.thumbnail != null ? item.thumbnail : "${setting.defaultThumbnailProductImage}";
				$clearHistoryProduct.parent().before(
					[@compress single_line = true]
						'<dd>
							<img src="' + escapeHtml(thumbnail) + '" \/>
							<a href="${base}' + escapeHtml(item.path) + '" title="' + escapeHtml(item.name) + '">' + escapeHtml(abbreviate(item.name, 30)) + '<\/a>
							<strong>' + currency(item.price, true) + '<\/strong>
						<\/dd>'
					[/@compress]
				);
			});
		}
	});
	
	// 清空浏览记录
	$clearHistoryProduct.click(function() {
		$historyProduct.remove();
		removeCookie("historyProduct");
	});
	
	// 点击数
	$.ajax({
		url: "${base}/product/hits/${product.id}",
		type: "GET",
		cache: true
	});

});
</script>
</head>
<body>
	<div id="dialogOverlay" class="dialogOverlay"></div>
	[#include "/shop/include/header.ftl" /]
	[#assign productCategory = product.productCategory /]
	<div class="container productDetail">
		<div class="row">
			<div class="span2">
				[#include "/shop/include/hot_product_category.ftl" /]
				[#include "/shop/include/hot_brand.ftl" /]
				[#include "/shop/include/hot_product.ftl" /]
				[#include "/shop/include/history_product.ftl" /]
			</div>
			<div class="span10">
				<div class="breadcrumb">
					<ul>
						<li>
							<a href="${base}/">${message("shop.breadcrumb.home")}</a>
						</li>
						[@product_category_parent_list productCategoryId = productCategory.id]
							[#list productCategories as productCategory]
								<li>
									<a href="${base}${productCategory.path}">${productCategory.name}</a>
								</li>
							[/#list]
						[/@product_category_parent_list]
						<li>
							<a href="${base}${productCategory.path}">${productCategory.name}</a>
						</li>
					</ul>
				</div>
				<div class="productImage">
					[#if product.productImages?has_content]
						<a href="${product.productImages[0].large}" id="zoom" rel="gallery">
							<img class="medium" src="${product.productImages[0].medium}" />
						</a>
					[#else]
						<a href="${setting.defaultLargeProductImage}" id="zoom" rel="gallery">
							<img class="medium" src="${setting.defaultMediumProductImage}" />
						</a>
					[/#if]
					<a href="javascript:;" class="prev">&nbsp;</a>
					<div id="thumbnailScrollable" class="scrollable">
						<div class="items">
							[#if product.productImages?has_content]
								[#list product.productImages as productImage]
									<a[#if productImage_index == 0] class="current"[/#if] href="javascript:;" rel="{gallery: 'gallery', smallimage: '${productImage.medium}', largeimage: '${productImage.large}'}">
										<img src="${productImage.thumbnail}" title="${productImage.title}" />
									</a>
								[/#list]
							[#else]
								<a href="javascript:;" class="current">
									<img src="${setting.defaultThumbnailProductImage}" />
								</a>
							[/#if]
						</div>
					</div>
					<a href="javascript:;" class="next">&nbsp;</a>
				</div>
				<div id="preview" class="preview">
					<a href="javascript:;" class="close">&nbsp;</a>
					<a href="javascript:;" class="prev">&nbsp;</a>
					<div id="previewScrollable" class="scrollable">
						<div class="items">
							[#if product.productImages?has_content]
								[#list product.productImages as productImage]
									<img src="${base}/upload/image/blank.gif" data-original="${productImage.large}" title="${productImage.title}" />
								[/#list]
							[#else]
								<img src="${base}/upload/image/blank.gif" data-original="${setting.defaultLargeProductImage}" />
							[/#if]
						</div>
					</div>
					<a href="javascript:;" class="next">&nbsp;</a>
				</div>
				<div class="sku">	
					<div class="info">
						<h1>
							${product.name}
							[#if product.caption?has_content]
								<em>${product.caption}</em>
							[/#if]
						</h1>
						<dl>
							<dt>${message("Product.sn")}:</dt>
							<dd>
								${product.sn}
							</dd>
						</dl>
						[#if product.type != "general"]
							<dl>
								<dt>${message("Product.type")}:</dt>
								<dd>
									${message("Product.Type." + product.type)}
								</dd>
							</dl>
						[/#if]
						[#if product.scoreCount > 0]
							<dl>
								<dt>${message("Product.score")}:</dt>
								<dd>
									<div class="score${(product.score * 2)?string("0")}"></div>
								</dd>
							</dl>
						[/#if]
						[#if product.type == "general"]
							<dl>
								<dt>${message("Sku.price")}:</dt>
								<dd>
									<strong id="price">${currency(defaultSku.price, true)}</strong>
								</dd>
								[#if setting.isShowMarketPrice]
									<dd>
										<span>
											(<em>${message("Sku.marketPrice")}:</em>
											<del id="marketPrice">${currency(defaultSku.marketPrice, true)}</del>)
										</span>
									</dd>
								[/#if]
							</dl>
							[#if product.validPromotions?has_content]
								<dl>
									<dt>${message("Product.promotions")}:</dt>
									<dd>
										[#list product.validPromotions as promotion]
											<a href="${base}${promotion.path}" target="_blank" title="${promotion.name}[#if promotion.beginDate?? || promotion.endDate??] (${promotion.beginDate} ~ ${promotion.endDate})[/#if]">${promotion.name}</a>
										[/#list]
									</dd>
								</dl>
							[/#if]
							[#if defaultSku.rewardPoint > 0]
								<dl>
									<dt>${message("Sku.rewardPoint")}:</dt>
									<dd id="rewardPoint">
										${defaultSku.rewardPoint}
									</dd>
								</dl>
							[/#if]
						[#else]
							[#if product.type == "exchange"]
								<dl>
									<dt>${message("Sku.exchangePoint")}:</dt>
									<dd>
										<strong id="exchangePoint">${defaultSku.exchangePoint}</strong>
									</dd>
								</dl>
							[/#if]
							[#if setting.isShowMarketPrice]
								<dl>
									<dt>${message("Sku.marketPrice")}:</dt>
									<dd id="marketPrice">
										${currency(defaultSku.marketPrice, true)}
									</dd>
								</dl>
							[/#if]
						[/#if]
					</div>
					[#if product.type == "general" || product.type == "exchange"]
						<div class="action">
							[#if product.hasSpecification()]
								[#assign defaultSpecificationValueIds = defaultSku.specificationValueIds /]
								<div id="specification" class="specification clearfix">
									<div class="title">${message("shop.product.specificationTips")}</div>
									[#list product.specificationItems as specificationItem]
										<dl>
											<dt>
												<span title="${specificationItem.name}">${abbreviate(specificationItem.name, 8)}:</span>
											</dt>
											[#list specificationItem.entries as entry]
												[#if entry.isSelected]
													<dd>
														<a href="javascript:;"[#if defaultSpecificationValueIds[specificationItem_index] == entry.id] class="selected"[/#if] val="${entry.id}">
															${entry.value}<span title="${message("shop.product.selected")}">&nbsp;</span>
														</a>
													</dd>
												[/#if]
											[/#list]
										</dl>
									[/#list]
								</div>
							[/#if]
							<form id="productNotifyForm" action="${base}/product_notify/save" method="post">
								<dl id="productNotify" class="productNotify hidden">
									<dt>${message("shop.product.productNotifyEmail")}:</dt>
									<dd>
										<input type="text" name="email" maxlength="200" />
									</dd>
								</dl>
							</form>
							<dl class="quantity[#if defaultSku.isOutOfStock] hidden[/#if]">
								<dt>${message("shop.product.quantity")}:</dt>
								<dd>
									<span id="decrease" class="decrease" onselectstart="return false;">-</span>
									<input type="text" id="quantity" name="quantity" value="1" maxlength="4" onpaste="return false;" />
									<span id="increase" class="increase" onselectstart="return false;">+</span>
								</dd>
								<dd>
									${product.unit!message("shop.product.defaultUnit")}
								</dd>
							</dl>
							<div class="buy">
								<input type="button" id="addProductNotify" class="addProductNotify[#if !defaultSku.isOutOfStock] hidden[/#if]" value="${message("shop.product.addProductNotify")}" />
								[#if product.type == "general"]
									<input type="button" id="addCart" class="addCart[#if defaultSku.isOutOfStock] hidden[/#if]" value="${message("shop.product.addCart")}" />
								[#else]
									<input type="button" id="exchange" class="exchange[#if defaultSku.isOutOfStock] hidden[/#if]" value="${message("shop.product.exchange")}" />
								[/#if]
								<a href="javascript:;" id="addProductFavorite">${message("shop.product.addProductFavorite")}</a>
							</div>
						</div>
					[/#if]
					<div class="share">
						<div id="bdshare" class="bdshare_t bds_tools get-codes-bdshare">
							<a class="bds_qzone"></a>
							<a class="bds_tsina"></a>
							<a class="bds_tqq"></a>
							<a class="bds_renren"></a>
							<a class="bds_t163"></a>
							<span class="bds_more"></span>
							<a class="shareCount"></a>
						</div>
					</div>
				</div>
				[#if product.store.business != null]
					<div id="storeInfo" class="storeInfo">
						<img src="${product.store.logo!setting.defaultStoreLogo}" alt="${product.store.name}" />
						<strong>
							<a href="${base}${product.store.path}">${abbreviate(product.store.name, 50, "...")}</a>
						</strong>
						<p class="clearfix">
							<a href="${base}${product.store.path}">${message("shop.product.inShop")}</a>
							<a href="javascript:;" id="addStoreFavorite">${message("shop.product.collectShop")}</a>
						</p>
						[#if product.store.address?has_content && product.store.phone?has_content]
							<div class="divider"></div>
						[/#if]
						[#if product.store.address?has_content]
							<span>${message("shop.product.companyAddress")}：${product.store.address}</span>
						[/#if]
						[#if product.store.phone?has_content]
							<span>${message("shop.product.contact")}：${product.store.phone}</span>
						[/#if]
						[#if product.store.instantMessages?has_content]
							<div class="instantMessage">
								[#list product.store.instantMessages as instantMessage]
									[#if instantMessage.type == "qq"]
										<a href="http://wpa.qq.com/msgrd?v=3&uin=${instantMessage.account}&menu=yes" target="_blank" title="${instantMessage.name}">
											<img src="${base}/resources/shop/images/instant_message_qq.png" alt="${instantMessage.name}" />
										</a>
									[#elseif instantMessage.type == "aliTalk"]
										<a href="http://amos.alicdn.com/getcid.aw?v=2&uid=${instantMessage.account}&site=cntaobao&s=2&groupid=0&charset=utf-8" target="_blank" title="${instantMessage.name}">
											<img src="${base}/resources/shop/images/instant_message_wangwang.png" alt="${instantMessage.name}" />
										</a>
									[/#if]
								[/#list]
							</div>
						[/#if]
					</div>
				[/#if]	
				<div id="bar" class="bar">
					<ul>
						[#if product.introduction?has_content]
							<li id="introductionTab">
								<a href="#introduction">${message("shop.product.introduction")}</a>
							</li>
						[/#if]
						[#if product.parameterValues?has_content]
							<li id="parameterTab">
								<a href="#parameter">${message("shop.product.parameter")}</a>
							</li>
						[/#if]
						[#if setting.isReviewEnabled]
							<li id="reviewTab">
								<a href="#review">${message("shop.product.review")}</a>
							</li>
						[/#if]
						[#if setting.isConsultationEnabled]
							<li id="consultationTab">
								<a href="#consultation">${message("shop.product.consultation")}</a>
							</li>
						[/#if]
					</ul>
				</div>
				[#if product.introduction?has_content]
					<div id="introduction" name="introduction" class="introduction">
						<div class="title">
							<strong>${message("shop.product.introduction")}</strong>
						</div>
						[#noautoesc]
							<div>${product.introduction}</div>
						[/#noautoesc]
					</div>
				[/#if]
				[#if product.parameterValues?has_content]
					<div id="parameter" name="parameter" class="parameter">
						<div class="title">
							<strong>${message("shop.product.parameter")}</strong>
						</div>
						<table>
							[#list product.parameterValues as parameterValue]
								<tr>
									<th class="group" colspan="2">${parameterValue.group}</th>
								</tr>
								[#list parameterValue.entries as entry]
									<tr>
										<th>${entry.name}</th>
										<td>${entry.value}</td>
									</tr>
								[/#list]
							[/#list]
						</table>
					</div>
				[/#if]
				[#if setting.isReviewEnabled]
					<div id="review" name="review" class="review">
						<div class="title">${message("shop.product.review")}</div>
						<div class="content clearfix">
							[#if product.scoreCount > 0]
								<div class="score">
									<strong>${product.score?string("0.0")}</strong>
									<div>
										<div class="score${(product.score * 2)?string("0")}"></div>
										<div>${message("Product.scoreCount")}: ${product.scoreCount}</div>
									</div>
								</div>
								<div class="graph">
									<span style="width: ${(product.score * 20)?string("0.0")}%">
										<em>${product.score?string("0.0")}</em>
									</span>
									<div>&nbsp;</div>
									<ul>
										<li>${message("shop.product.graph1")}</li>
										<li>${message("shop.product.graph2")}</li>
										<li>${message("shop.product.graph3")}</li>
										<li>${message("shop.product.graph4")}</li>
										<li>${message("shop.product.graph5")}</li>
									</ul>
								</div>
								<div class="action">
									<a href="${base}/review/add/${product.id}" id="addReview">${message("shop.product.addReview")}</a>
								</div>
								[@review_list productId = product.id count = 5]
									[#if reviews?has_content]
										<table>
											[#list reviews as review]
													<tr>
														<th>
															<div class="score${(review.score * 2)?string("0")}"></div>
															${review.content}
														</th>
														<td>
															<div>${review.member.memberRank.name}</div>
															[#if review.member??]
																${review.member.username}
															[/#if]
															<span title="${review.createdDate?string("yyyy-MM-dd HH:mm:ss")}">${review.createdDate?string("yyyy-MM-dd")}</span>
														</td>
													</tr>
												[#if review.replyReviews?has_content]
													[#list review.replyReviews as replyReview]
														<tr>
															<th>
																&nbsp;&nbsp;&nbsp;&nbsp;${message("shop.review.storekeeper")}：${replyReview.content}
															</th>
															<td>
																<span title="${review.createdDate?string("yyyy-MM-dd HH:mm:ss")}">${review.createdDate?string("yyyy-MM-dd")}</span>
															</td>
														</tr>
													[/#list]
												[/#if]
											[/#list]
										</table>
										<p>
											<a href="${base}/review/detail/${product.id}">[${message("shop.product.viewReview")}]</a>
										</p>
									[/#if]
								[/@review_list]
							[#else]
								<p>
									${message("shop.product.noReview")} <a href="${base}/review/add/${product.id}" id="addReview">[${message("shop.product.addReview")}]</a>
								</p>
							[/#if]
						</div>
					</div>
				[/#if]
				[#if setting.isConsultationEnabled]
					<div id="consultation" name="consultation" class="consultation">
						<div class="title">${message("shop.product.consultation")}</div>
						<div class="content">
							[@consultation_list productId = product.id count = 5]
								[#if consultations?has_content]
									<ul>
										[#list consultations as consultation]
											<li>
												${consultation.content}
												<span>
													[#if consultation.member??]
														${consultation.member.username}
													[#else]
														${message("shop.product.anonymous")}
													[/#if]
													<span title="${consultation.createdDate?string("yyyy-MM-dd HH:mm:ss")}">${consultation.createdDate?string("yyyy-MM-dd")}</span>
												</span>
												[#if consultation.replyConsultations?has_content]
													<div class="arrow"></div>
													<ul>
														[#list consultation.replyConsultations as replyConsultation]
															<li>
																${replyConsultation.content}
																<span title="${replyConsultation.createdDate?string("yyyy-MM-dd HH:mm:ss")}">${replyConsultation.createdDate?string("yyyy-MM-dd")}</span>
															</li>
														[/#list]
													</ul>
												[/#if]
											</li>
										[/#list]
									</ul>
									<p>
										<a href="${base}/consultation/add/${product.id}" id="addConsultation">[${message("shop.product.addConsultation")}]</a>
										<a href="${base}/consultation/detail/${product.id}">[${message("shop.product.viewConsultation")}]</a>
									</p>
								[#else]
									<p>
										${message("shop.product.noConsultation")} <a href="${base}/consultation/add/${product.id}" id="addConsultation">[${message("shop.product.addConsultation")}]</a>
									</p>
								[/#if]
							[/@consultation_list]
						</div>
					</div>
				[/#if]
			</div>
		</div>
	</div>
	[#include "/shop/include/footer.ftl" /]
	<script type="text/javascript" id="bdshare_js" data="type=tools&amp;uid=0"></script>
	<script type="text/javascript" id="bdshell_js"></script>
	<script type="text/javascript">
		document.getElementById("bdshell_js").src = "http://bdimg.share.baidu.com/static/js/shell_v2.js?cdnversion=" + Math.ceil(new Date() / 3600000)
	</script>
</body>
</html>