<script type="text/javascript">
$().ready(function() {

	var $window = $(window);
	var $headerName = $("#headerName");
	var $headerLogin = $("#headerLogin");
	var $headerRegister = $("#headerRegister");
	var $headerLogout = $("#headerLogout");
	var $productSearchForm = $("#productSearchForm");
	var $productSearchKeyword = $("#productSearchForm [name='keyword']");
	var $headerCart = $("#headerCart");
	var $headerCartQuantity = $("#headerCart a.cartButton em");
	var $headerCartDetail = $("#headerCart div.detail");
	var $headerCartItems = $("#headerCart div.items");
	var $headerCartSummary = $("#headerCart div.summary");
	var $broadsideNav = $("#broadsideNav");
	var currentMemberUsername = getCookie("currentMemberUsername");
	var defaultProductSearchKeyword = "${message("shop.header.keyword")}";
	
	if ($.trim(currentMemberUsername) != "") {
		$headerName.text(currentMemberUsername).show();
		$headerLogout.show();
	} else {
		$headerLogin.show();
		$headerRegister.show();
	}
	
	$productSearchKeyword.focus(function() {
		if ($.trim($productSearchKeyword.val()) == defaultProductSearchKeyword) {
			$productSearchKeyword.val("");
		}
	});
	
	$productSearchKeyword.blur(function() {
		if ($.trim($productSearchKeyword.val()) == "") {
			$productSearchKeyword.val(defaultProductSearchKeyword);
		}
	});
	
	$productSearchForm.submit(function() {
		if ($.trim($productSearchKeyword.val()) == "" || $productSearchKeyword.val() == defaultProductSearchKeyword) {
			return false;
		}
	});
	
	// 购物车信息
	$window.on("cartInfoLoad", function(event, cartInfo) {
		var skuQuantity = cartInfo != null && cartInfo.skuQuantity != null ? cartInfo.skuQuantity : 0;
		var effectivePrice = cartInfo != null && cartInfo.effectivePrice != null ? cartInfo.effectivePrice : 0;
		if ($headerCartQuantity.text() != skuQuantity && "opacity" in document.documentElement.style) {
			$headerCartQuantity.fadeOut(function() {
				$headerCartQuantity.text(skuQuantity).fadeIn();
			});
		} else {
			$headerCartQuantity.text(skuQuantity);
		}
		var cartItems = cartInfo.items;
		if(cartItems == null || cartItems.length <= 0){
			$headerCartItems.html(
				[@compress single_line = true]
					'<table>
						<tr>
							<td>${message("shop.header.cartEmpty")}<\/td>
						<\/tr>
					<\/table>'
				[/@compress]
			);
		} else {
			var $headerCartTable = $headerCartItems.html('<table id="cartTable"><\/table>');
			$.each(cartItems, function(i, cartItem) {
				$('#cartTable').append(
					[@compress single_line = true]
						'<tr>
							<td>
								<a href="${base}' + cartItem.skuPath + '">
									<img src="' + cartItem.skuThumbnail + '" \/>
								<\/a>
							<\/td>
							<td>
								<a href="${base}' + cartItem.skuPath + '">' + escapeHtml(abbreviate(cartItem.skuName, 20, "...")) + '<\/a>
							<\/td>
							<td>
								<span>' + currency(cartItem.price, true, false) + '<\/span>&nbsp; &nbsp;<em>x' + cartItem.quantity + '<\/em>
							<\/td>
						<\/tr>'
					[/@compress]
				);
			});
		}
		$headerCartSummary.html(message('[#noautoesc]${message("shop.header.totalQuantity")}[/#noautoesc]', skuQuantity) + '&nbsp;&nbsp;&nbsp;&nbsp;${message("shop.header.totalPrice")}: <em>' + currency(effectivePrice, true, true) + '<\/em><a href="${base}/cart/list">${message("shop.header.checkout")}<\/a>');
	});
	
	// 购物车详情
	$headerCart.hover(
		function() {
			if ($headerCartDetail.is(":hidden")) {
				$headerCart.addClass("active");
				$headerCartDetail.slideDown("fast");
			}
		},
		function() {
			if ($headerCartDetail.is(":visible")) {
				$headerCart.removeClass("active");
				$headerCartDetail.slideUp("fast");
			}
		}
	);
	
	$broadsideNav.find("li").hover(
		function() {
			$(this).find("em").show();
		},function(){
			$(this).find("em").hide();
		}
	);

});
</script>
<div class="header">
	<div class="top">
		<div class="topNav">
			<ul class="left">
				<li>
					<span>${message("shop.header.welcome", setting.siteName)}</span>
					<span id="headerName" class="headerName">&nbsp;</span>
				</li>
				<li id="headerLogin" class="headerLogin">
					<a href="${base}/member/login">${message("shop.header.login")}</a>|
				</li>
				<li id="headerRegister" class="headerRegister">
					<a href="${base}/member/register">${message("shop.header.register")}</a>
				</li>
				<li id="headerLogout" class="headerLogout">
					<a href="${base}/member/logout">[${message("shop.header.logout")}]</a>
				</li>
			</ul>
			<ul class="right">
				[@navigation_list position = "top"]
					[#list navigations as navigation]
						<li>
						<a href="${navigation.url}"[#if navigation.isBlankTarget] target="_blank"[/#if]>${navigation.name}</a>
						</li>
					[/#list]
				[/@navigation_list]
			</ul>
		</div>
	</div>
	<div class="container">
		<div class="row">
			<div class="span3">
				<a href="${base}/">
					<img src="${setting.logo}" alt="${setting.siteName}" />
				</a>
			</div>
			<div class="span6" style="padding-top: 20px;">
				<div class="search">
					<form id="productSearchForm" action="${base}/product/search" method="get">
						[#if store??]
							<input name="storeId" type="hidden" value="${store.id}" />
						[#elseif storeProductCategory??]
							<input name="storeId" type="hidden" value="${storeProductCategory.store.id}" />
						[/#if]
						<input name="keyword" class="keyword" value="${productKeyword!message("shop.header.keyword")}" autocomplete="off" x-webkit-speech="x-webkit-speech" x-webkit-grammar="builtin:search" maxlength="30" />
						<button type="submit">&nbsp;</button>
					</form>
				</div>
				<div class="hotSearch">
					[#if setting.hotSearches?has_content]
						${message("shop.header.hotSearch")}:
						[#list setting.hotSearches as hotSearch]
							<a href="${base}/product/search?keyword=${hotSearch?url}">${hotSearch}</a>
						[/#list]
					[/#if]
				</div>
			</div>
			<div id="headerCart" class="headerCart" style="padding-top: 20px;">
				<a class="cartButton" href="${base}/cart/list"><span>${message("shop.header.cart")}(<em></em>)</span></a>
				<div class="detail">
					<div class="title">${message("shop.header.cartItemTitle")}</div>
					<div class="items"></div>
					<div class="summary"></div>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="span12">
				<dl class="mainNav">

					<dt>
						<a href="/shop/product_category">所有商品分类</a>
					</dt>
					<dd>
						<a href="/shop/">首页</a>
					</dd>
					<dd>
						<a href="/shop/product/list/1">手机数码</a>
					</dd>
					<dd>
						<a href="/shop/product/list/2">电脑办公</a>
					</dd>
					<dd>
						<a href="/shop/product/list/3">家用电器</a>
					</dd>
					<dd>
						<a href="/shop/product/list/4">服装鞋靴</a>
					</dd>
					<dd>
						<a href="/shop/product/list/5">化妆护理</a>
					</dd>
					<dd>
						<a href="/shop/product/list?type=exchange">积分商城</a>
					</dd>

				</dl>
			</div>
		</div>
		<div id="broadsideNav" class="broadsideNav">
			<ul>
				<li class="shoppingCart">
					<a href="${base}/cart/list"><em>${message("shop.header.cart")}</em></a>
				</li>
				<li class="memberCenter">
					<a href="/member/index"><em>${message("shop.header.member")}</em></a>
				</li>
				<li class="myCoupons">
					<a href="${base}/member/coupon_code/exchange"><em>${message("shop.header.couponCode")}</em></a>
				</li>
				<li class="collectCenter">
					<a href="${base}/member/product_favorite/list"><em>${message("shop.header.productFavorite")}</em></a>
				</li>
			</ul>
			<div id="goTop" class="goTop"></div>
		</div>
	</div>
</div>