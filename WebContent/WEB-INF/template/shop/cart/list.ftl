<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("shop.cart.title")}[#if showPowered] [/#if]</title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/shop/css/animate.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/cart.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/shop/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/common.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $promotionTr = $(".cartTable tr.promotion-tr");
	var $giftTr = $(".cartTable .gift-tr");
	var $quantity = $(".cartTable input[name='quantity']");
	var $increase = $(".cartTable span.increase");
	var $decrease = $(".cartTable span.decrease");
	var $remove = $(".cartTable a.remove");
	var $promotionDiscount = $("#promotionDiscount");
	var $effectiveRewardPoint = $("#effectiveRewardPoint");
	var $effectivePrice = $("#effectivePrice");
	var $clear = $("#clear");
	var $submit = $("#submit");
	var timeouts = {};
	
	[#if flashMessage?has_content]
		$.alert("${flashMessage}");
	[/#if]
	
	// 初始数量
	$quantity.each(function() {
		var $this = $(this);
		$this.data("value", $this.val());
	});
	
	// 数量
	$quantity.keypress(function(event) {
		return (event.which >= 48 && event.which <= 57) || event.which == 8;
	});
	
	// 增加数量
	$increase.click(function() {
		var $quantity = $(this).siblings("input");
		var quantity = $quantity.val();
		if (/^\d*[1-9]\d*$/.test(quantity)) {
			$quantity.val(parseInt(quantity) + 1);
		} else {
			$quantity.val(1);
		}
		modify($quantity);
	});
	
	// 减少数量
	$decrease.click(function() {
		var $quantity = $(this).siblings("input");
		var quantity = $quantity.val();
		if (/^\d*[1-9]\d*$/.test(quantity) && parseInt(quantity) > 1) {
			$quantity.val(parseInt(quantity)1);
		} else {
			$quantity.val(1);
		}
		modify($quantity);
	});
	
	// 修改数量
	$quantity.on("input propertychange change", function(event) {
		if (event.type != "propertychange" || event.originalEvent.propertyName == "value") {
			modify($(this));
		}
	});
	
	// 修改数量
	function modify($quantity) {
		var quantity = $quantity.val();
		var $gift = $quantity.closest("tbody").find("dl.gift");
		var $promotion = $quantity.closest("tbody").find("dl.promotion");
		if (/^\d*[1-9]\d*$/.test(quantity)) {
			var $tr = $quantity.closest("tr");
			var skuId = $tr.find("input[name='id']").val();
			clearTimeout(timeouts[skuId]);
			timeouts[skuId] = setTimeout(function() {
				$.ajax({
					url: "modify",
					type: "POST",
					data: {skuId: skuId, quantity: quantity},
					dataType: "json",
					cache: false,
					beforeSend: function() {
						$submit.prop("disabled", true);
					},
					success: function(data) {
						$quantity.data("value", quantity);
						$tr.find("span.subtotal").text(currency(data.subtotal, true));
						if (data.giftNames != null && data.giftNames.length > 0) {
							$giftTr.show();
							$gift.html('<dt>${message("shop.cart.gift")}:<\/dt>');
							$.each(data.giftNames, function(i, giftName) {
								$gift.append('<dd title="' + escapeHtml(giftName) + '">' + escapeHtml(abbreviate(giftName, 50)) + ' &times; 1<\/dd>');
							});
							"opacity" in document.documentElement.style ? $gift.fadeIn() : $gift.show();
						} else {
							"opacity" in document.documentElement.style ? $gift.fadeOut() : $gift.hide();
						}
						if (data.promotionNames != null && data.promotionNames.length > 0) {
							$promotionTr.show();
							$promotion.html('<dt>${message("shop.cart.promotionDiscount")}:<\/dt>');
							$.each(data.promotionNames, function(i, promotionName) {
								$promotion.append('<dd title="' + escapeHtml(promotionName) + '">' + escapeHtml(abbreviate(promotionName, 50)) + '<\/dd>');
							});
							"opacity" in document.documentElement.style ? $promotion.fadeIn() : $promotion.show();
						} else {
							"opacity" in document.documentElement.style ? $promotion.fadeOut() : $promotion.hide();
						}
						if (!data.isLowStock) {
							$tr.find("span.lowStock").remove();
						}
						$effectiveRewardPoint.text(data.effectiveRewardPoint);
						$effectivePrice.text(currency(data.effectivePrice, true, true));
						$promotionDiscount.text(currency(data.promotionDiscount, true, true));
					},	
					warn: function() {
						$quantity.val($quantity.data("value"));
					},
					error: function() {
						$quantity.val($quantity.data("value"));
						setTimeout(function() {
							location.reload(true);
						}, 3000);
					},
					complete: function() {
						$submit.prop("disabled", false);
					}
				});
			}, 500);
		} else {
			$quantity.val($quantity.data("value"));
		}
	}
	
	// 移除
	$remove.click(function() {
		if (confirm("${message("shop.dialog.deleteConfirm")}")) {
			var $this = $(this);
			var $tr = $this.closest("tr");
			var skuId = $tr.find("input[name='id']").val();
			var $gift = $quantity.closest("tbody").find("dl.gift");
			var $promotion = $quantity.closest("tbody").find("dl.promotion");
			$.ajax({
				url: "remove",
				type: "POST",
				data: {skuId: skuId},
				dataType: "json",
				cache: false,
				beforeSend: function() {
					$submit.prop("disabled", true);
				},
				success: function(data) {
					if (data.quantity > 0) {
						$tr.remove();
						if (data.giftNames != null && data.giftNames.length > 0) {
							$gift.html('<dt>${message("shop.cart.gift")}:<\/dt>');
							$.each(data.giftNames, function(i, giftName) {
								$gift.append('<dd title="' + escapeHtml(giftName) + '">' + escapeHtml(abbreviate(giftName, 50)) + ' &times; 1<\/dd>');
							});
							"opacity" in document.documentElement.style ? $gift.fadeIn() : $gift.show();
						} else {
							"opacity" in document.documentElement.style ? $gift.fadeOut() : $gift.hide();
						}
						if (data.promotionNames != null && data.promotionNames.length > 0) {
							$promotion.html('<dt>${message("shop.cart.promotionDiscount")}:<\/dt>');
							$.each(data.promotionNames, function(i, promotionName) {
								$promotion.append('<dd title="' + escapeHtml(promotionName) + '">' + escapeHtml(abbreviate(promotionName, 50)) + '<\/dd>');
							});
							"opacity" in document.documentElement.style ? $promotion.fadeIn() : $promotion.show();
						} else {
							"opacity" in document.documentElement.style ? $promotion.fadeOut() : $promotion.hide();
						}
						$effectiveRewardPoint.text(data.effectiveRewardPoint);
						$effectivePrice.text(currency(data.effectivePrice, true, true));
						$promotionDiscount.text(currency(data.promotionDiscount, true, true));
					} else {
						location.reload(true);
					}
				},
				complete: function() {
					$submit.prop("disabled", false);
				}
			});
		}
		return false;
	});
	
	// 清空
	$clear.click(function() {
		if (confirm("${message("shop.dialog.clearConfirm")}")) {
			$.each(timeouts, function(i, timeout) {
				clearTimeout(timeout);
			});
			$.ajax({
				url: "clear",
				type: "POST",
				dataType: "json",
				cache: false,
				success: function(data) {
					location.reload(true);
				}
			});
		}
		return false;
	});
	
	// 提交
	$submit.click(function() {
		if (!$.checkLogin()) {
			$.redirectLogin("${base}/cart/list", "${message("shop.cart.accessDenied")}");
			return false;
		}
	});

});
</script>
</head>
<body>
	[#include "/shop/include/header.ftl" /]
	<div class="container cart">
		<div class="row">
			<div class="span12">
				<div class="step">
					<ul>
						<li class="current">${message("shop.cart.step1")}</li>
						<li>${message("shop.cart.step2")}</li>
						<li>${message("shop.cart.step3")}</li>
					</ul>
				</div>
				[#if currentCart?? && currentCart.cartItems?has_content && currentCart.stores?has_content]
					<table class="cartTable">
						<tr class="title" >
							<th>${message("shop.cart.image")}</th>
							<th>${message("shop.cart.sku")}</th>
							<th>${message("shop.cart.price")}</th>
							<th>${message("shop.cart.quantity")}</th>
							<th>${message("shop.cart.subtotal")}</th>
							<th>${message("shop.cart.action")}</th>
						</tr>
						[#list currentCart.stores as store]
							<tbody class="cartDiv">
								<tr>
									<th class="cartNull">
										&nbsp;
									</th>
								</tr>
								<tr>
									<th class="storeName" colspan="6">
										<a href="${base}${store.path}">${abbreviate(store.name, 20, "...")}</a>[#if store.type == "self"]&nbsp;&nbsp;&nbsp;<span>${message("shop.cart.self")}</span>[/#if]
									</th>
								</tr>
								[#list currentCart.getCartItems(store) as cartItem]
									<tr>
										<td width="60">
											<input type="hidden" name="id" value="${cartItem.sku.id}" />
											<img src="${cartItem.sku.thumbnail!setting.defaultThumbnailProductImage}" alt="${abbreviate(cartItem.sku.name, 50, "...")}" />
										</td>
										<td width="240">
											<a href="${base}${cartItem.sku.path}" title="${cartItem.sku.name}" target="_blank">${abbreviate(cartItem.sku.name, 50, "...")}</a>
											[#if cartItem.sku.specifications?has_content]
												<span class="silver">[${cartItem.sku.specifications?join(", ")}]</span>
											[/#if]
											[#if !cartItem.isMarketable]
												<span class="red">[${message("shop.cart.notMarketable")}]</span>
											[/#if]
											[#if cartItem.isLowStock]
												<span class="red lowStock">[${message("shop.cart.lowStock")}]</span>
											[/#if]
											[#if !cartItem.isActive]
												<span class="red">[${message("shop.cart.notActive")}]</span>
											[/#if]
										</td>
										<td class="price" width="180">
											<span>${currency(cartItem.price, true)}</span>
										</td>
										<td class="quantity" width="130">
											<span class="decrease" onselectstart="return false;">-</span>
											<input type="text" name="quantity" value="${cartItem.quantity}" maxlength="4" onpaste="return false;" />
											<span class="increase" onselectstart="return false;">+</span>
										</td>
										<td width="140">
											<span class="subtotal">${currency(cartItem.subtotal, true)}</span>
										</td>
										<td>
											<a href="javascript:;" class="remove">${message("shop.cart.delete")}</a>
										</td>
									</tr>
								[/#list]
								[#assign promotionNames = currentCart.getPromotionNames(store) /]
								<tr class="promotion-tr[#if !promotionNames?has_content] hidden[/#if]">
									<td colspan="6">
										<dl class="promotion clearfix">
											<dt[#if !promotionNames?has_content] class="hidden"[/#if]>${message("shop.cart.promotionDiscount")}:</dt>
											[#list promotionNames as promotionName]
												<dd title="${promotionName}">${abbreviate(promotionName, 50)}</dd>
											[/#list]
										</dl>
									</td>
								</tr>
								[#assign giftNames = currentCart.getGiftNames(store) /]
								<tr class="gift-tr[#if !giftNames?has_content] hidden[/#if]">
									<td colspan="6">
										<dl class="gift clearfix">
											<dt[#if !giftNames?has_content] class="hidden"[/#if]>${message("shop.cart.gift")}:</dt>
											[#list giftNames as giftName]
												<dd title="${giftName}">${abbreviate(giftName, 50)} &times; 1</dd>
											[/#list]
										</dl>
									</td>
								</tr>
							</tbody>
						[/#list]
					</table>
				[#else]
					<p>
						<a href="${base}/">${message("shop.cart.empty")}</a>
					</p>
				[/#if]
			</div>
		</div>
		[#if currentCart?? && currentCart.cartItems?has_content]
			<div class="row">
				<div class="span12">
					<div class="bottom">
						<span class="total">
							[#if !currentUser??]
								<em>${message("shop.cart.promotionTips")}</em>
							[#else]
								${message("shop.cart.promotionDiscount")}: <em id="promotionDiscount">${currency(currentCart.getDiscountTotal(currentCart.stores),true,true)}</em>	
							[/#if]
							${message("shop.cart.effectiveRewardPoint")}: <em id="effectiveRewardPoint">${currentCart.getEffectiveRewardPointTotal(currentCart.stores)}</em>
							${message("shop.cart.effectivePrice")}: <strong id="effectivePrice">${currency(currentCart.getEffectivePriceTotal(currentCart.stores), true, true)}</strong>
						</span>
						<span>
							<a href="javascript:;" id="clear" class="clear">${message("shop.cart.clear")}</a>
							<a href="${base}/order/checkout" id="submit" class="submit">${message("shop.cart.submit")}</a>
						</span>
					</div>
				</div>
			</div>
		[/#if]
	</div>
	[#include "/shop/include/footer.ftl" /]
</body>
</html>