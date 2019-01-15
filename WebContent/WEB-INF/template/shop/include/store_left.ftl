<script type="text/javascript">
$().ready(function() {

	var $addStoreFavorite = $("#addStoreFavorite");
	var $storeProductSearchForm = $("#storeProductSearchForm");
	var $storeProductSearchKeyword = $("#storeProductSearchForm [name='keyword']");
	var $toggleCollapse = $("[data-toggle='collapse']");
	var defaultStoreProductSearchKeyword = "${message("shop.store.search")}";
	
	// 店铺收藏
	$addStoreFavorite.click(function() {
		$.ajax({
			url: "${base}/member/store_favorite/add",
			type: "POST",
			data: {
				storeId: ${store.id}
			},
			dataType: "json"
		});
		return false;
	});
	
	$storeProductSearchKeyword.focus(function() {
		if ($.trim($storeProductSearchKeyword.val()) == defaultStoreProductSearchKeyword) {
			$storeProductSearchKeyword.val("");
		}
	});
	
	$storeProductSearchKeyword.blur(function() {
		if ($.trim($storeProductSearchKeyword.val()) == "") {
			$storeProductSearchKeyword.val(defaultStoreProductSearchKeyword);
		}
	});
	
	$storeProductSearchForm.submit(function() {
		if ($.trim($storeProductSearchKeyword.val()) == "" || $.trim($storeProductSearchKeyword.val()) == defaultStoreProductSearchKeyword) {
			return false;
		}
	});
	
	// 折叠
	$toggleCollapse.click(function() {
		var $element = $(this);
		$element.toggleClass("active");
		$target = $($element.data("target"));
		if ($element.hasClass("active")) {
			$target.slideDown();
		} else {
			$target.slideUp();
		}
		return false;
	});

});
</script>
<div class="storeLeft">
	<div class="storeInfo">
		<h2>${message("shop.store.storeInfo")}</h2>
		<img src="${store.logo!setting.defaultStoreLogo}" class="logo" alt="${store.name}" />
		<strong>
			${abbreviate(store.name, 14)}
			[#if store.type == "self"]
				<em>${message("Store.Type.self")}</em>
			[/#if]
		</strong>
		<p class="clearfix">
			<a href="${base}${store.path}">${message("shop.product.inShop")}</a>
			<a href="javascript:;" id="addStoreFavorite">${message("shop.store.storeFavorite")}</a>
		</p>
		[#if store.instantMessages?has_content]
			<div class="instantMessage">
				[#list store.instantMessages as instantMessage]
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
	<div class="storeSearch">
		<form id="storeProductSearchForm" action="${base}/product/search" method="get">
			<input type="hidden" name="storeId" value="${store.id}">
			<input type="text" name="keyword" value="${message("shop.store.search")}" autocomplete="off" x-webkit-speech="x-webkit-speech" x-webkit-grammar="builtin:search" maxlength="30" maxlength="30" /><button type="submit">${message("shop.store.searchButton")}</button>
		</form>
	</div>
	[@store_product_category_root_list storeId = store.id]
		[#if storeProductCategories?has_content]
			<div class="storeClassify">
				<dl>
					<dt>${message("shop.store.storeProductCategory")}</dt>
					[#list storeProductCategories as storeProductCategory]
						<dd>
							[@store_product_category_children_list storeProductCategoryId = storeProductCategory.id storeId = store.id recursive = false]
								<a href="${base}${storeProductCategory.path}">
									${abbreviate(storeProductCategory.name, 15)}
									[#if storeProductCategories?has_content]
										<span class="caret active" data-toggle="collapse" data-target="#storeProductCategory${storeProductCategory.id}"></span>
									[/#if]
								</a>
								[#if storeProductCategories?has_content]
									<ul id="storeProductCategory${storeProductCategory.id}">
										[#list storeProductCategories as storeProductCategory]
											<li>
												<a href="${base}${storeProductCategory.path}">${abbreviate(storeProductCategory.name, 15)}</a>
											</li>
										[/#list]
									</ul>
								[/#if]
							[/@store_product_category_children_list]
						</dd>
					[/#list]
				</dl>
			</div>
		[/#if]
	[/@store_product_category_root_list]
</div>