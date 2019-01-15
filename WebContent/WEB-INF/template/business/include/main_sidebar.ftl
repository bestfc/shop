<script type="text/javascript">

	$().ready(function() {
		var $includeForm = $("#includeForm");
		var $searchValue = $("input[name='searchValue']");
		
		$includeForm.submit(function() {
			if($.trim($searchValue.val()) == "") {
				return false;
			}
		})
	});

</script>
<aside class="main-sidebar">
	<section class="sidebar">
		<form id="includeForm" class="sidebar-form" action="${base}/business/product/list" method="get">
			<input name="searchProperty" type="hidden" value="name">
			<div class="active input-group">
				<input name="searchValue" class="form-control" type="text" placeholder="${message("business.mainSidebar.search")}">
				<span class="input-group-btn">
					<button class="btn btn-flat" type="submit">
						<i class="fa fa-search"></i>
					</button>
				</span>
			</div>
		</form>
		<ul class="sidebar-menu">
			<li class="treeview[#if .main_template_name?matches(".*/product/.*|.*/stock/.*|.*/product_notify/.*|.*/consultation/.*|.*/review/.*")] active[/#if]">
				<a href="javascript:;">
					<i class="fa fa-clone"></i>
					<span>${message("business.mainSidebar.product")}</span>
					<span class="pull-right-container">
						<i class="fa fa-angle-left pull-right"></i>
					</span>
				</a>
				<ul class="treeview-menu">
					<li[#if .main_template_name?matches(".*/product/.*")] class="active"[/#if]>
						<a href="${base}/business/product/list">
							<i class="fa fa-circle-o"></i>
							${message("business.mainSidebar.productList")}
							<span class="pull-right-container">
								[@product_count storeId = currentStore.id isOutOfStock = true]
									<span class="label pull-right bg-red" title="${message("business.index.outOfStack")}">${count}</span>
								[/@product_count]
								[@product_count storeId = currentStore.id isStockAlert = true]
									<span class="label pull-right bg-orange" title="${message("business.index.stockAlert")}">${count}</span>
								[/@product_count]
							</span>
						</a>
					</li>
					<li[#if .main_template_name?matches(".*/stock/.*")] class="active"[/#if]>
						<a href="${base}/business/stock/log">
							<i class="fa fa-circle-o"></i>
							${message("business.mainSidebar.stockLog")}
						</a>
					</li>
					<li[#if .main_template_name?matches(".*/product_notify/.*")] class="active"[/#if]>
						<a href="${base}/business/product_notify/list">
							<i class="fa fa-circle-o"></i>
							${message("business.mainSidebar.productNotifyList")}
						</a>
					</li>
					<li[#if .main_template_name?matches(".*/consultation/.*")] class="active"[/#if]>
						<a href="${base}/business/consultation/list">
							<i class="fa fa-circle-o"></i>
							${message("business.mainSidebar.consultationList")}
						</a>
					</li>
					<li[#if .main_template_name?matches(".*/review/.*")] class="active"[/#if]>
						<a href="${base}/business/review/list">
							<i class="fa fa-circle-o"></i>
							${message("business.mainSidebar.reviewList")}
						</a>
					</li>
				</ul>
			</li>
			<li class="treeview[#if .main_template_name?matches(".*/order/.*|.*/delivery_template/.*|.*/delivery_center/.*")] active[/#if]">
				<a href="javascript:;">
					<i class="fa fa-list-ul"></i>
					<span>${message("business.mainSidebar.order")}</span>
					<span class="pull-right-container">
						<i class="fa fa-angle-left pull-right"></i>
					</span>
				</a>
				<ul class="treeview-menu">
					[@order_count status = "pendingReview" storeId = currentStore.id hasExpired = false]
						<li[#if .main_template_name?matches(".*/order/.*")] class="active"[/#if]>
							<a href="${base}/business/order/list">
								<i class="fa fa-circle-o"></i>
								${message("business.mainSidebar.orderList")}
								<span class="pull-right-container">
									<span class="label pull-right bg-orange" title="${message("business.mainSidebar.pendingOrder")}">${count}</span>
								</span>
							</a>
						</li>
					[/@order_count]
					<li[#if .main_template_name?matches(".*/delivery_template/.*")] class="active"[/#if]>
						<a href="${base}/business/delivery_template/list">
							<i class="fa fa-circle-o"></i>
							${message("business.mainSidebar.deliveryTemplateList")}
						</a>
					</li>
					<li[#if .main_template_name?matches(".*/delivery_center/.*")] class="active"[/#if]>
						<a href="${base}/business/delivery_center/list">
							<i class="fa fa-circle-o"></i>
							${message("business.mainSidebar.deliveryCenterList")}
						</a>
					</li>
				</ul>
			</li>
			<li class="treeview[#if .main_template_name?matches(".*/store/setting.*|.*/store_product_category/.*|.*/store_product_tag/.*|.*/category_application/.*|.*/store/payment.*|.*/shipping_method/.*|.*/area_freight_config/.*|.*/store_ad_image/.*")] active[/#if]">
				<a href="javascript:;">
					<i class="fa fa-tags"></i>
					<span>${message("business.mainSidebar.store")}</span>
					<span class="pull-right-container">
						<i class="fa fa-angle-left pull-right"></i>
					</span>
				</a>
				<ul class="treeview-menu">
					<li[#if .main_template_name?matches(".*/store/setting.*")] class="active"[/#if]>
						<a href="${base}/business/store/setting">
							<i class="fa fa-circle-o"></i>
							${message("business.mainSidebar.storeSetting")}
						</a>
					</li>
					<li[#if .main_template_name?matches(".*/store_product_category/.*")] class="active"[/#if]>
						<a href="${base}/business/store_product_category/list">
							<i class="fa fa-circle-o"></i>
							${message("business.mainSidebar.storeProductCategoryList")}
						</a>
					</li>
					<li[#if .main_template_name?matches(".*/store_product_tag/.*")] class="active"[/#if]>
						<a href="${base}/business/store_product_tag/list">
							<i class="fa fa-circle-o"></i>
							${message("business.mainSidebar.storeProductTagList")}
						</a>
					</li>
					<li[#if .main_template_name?matches(".*/category_application/.*")] class="active"[/#if]>
						<a href="${base}/business/category_application/list">
							<i class="fa fa-circle-o"></i>
							${message("business.mainSidebar.categoryApplicationList")}
						</a>
					</li>
					<li[#if .main_template_name?matches(".*/store/payment.*")] class="active"[/#if]>
						<a href="${base}/business/store/payment">
							<i class="fa fa-circle-o"></i>
							${message("business.mainSidebar.payment")}
						</a>
					</li>
					<li[#if .main_template_name?matches(".*/shipping_method/.*|.*/area_freight_config/.*")] class="active"[/#if]>
						<a href="${base}/business/shipping_method/list">
							<i class="fa fa-circle-o"></i>
							${message("business.mainSidebar.shippingMethodList")}
						</a>
					</li>
					<li[#if .main_template_name?matches(".*/store_ad_image/.*")] class="active"[/#if]>
						<a href="${base}/business/store_ad_image/list">
							<i class="fa fa-circle-o"></i>
							<span>${message("business.mainSidebar.storeAdImageList")}</span>
						</a>
					</li>
				</ul>
			</li>
			<li class="treeview[#if .main_template_name?matches(".*/discount_promotion/.*|.*/full_reduction_promotion/.*|.*/coupon/.*")] active[/#if]">
				<a href="javascript:;">
					<i class="fa fa-heart-o"></i>
					<span>${message("business.mainSidebar.promotion")}</span>
					<span class="pull-right-container">
						<i class="fa fa-angle-left pull-right"></i>
					</span>
				</a>
				<ul class="treeview-menu">
					[@promotion_plugin promotionPluginId = "discountPromotionPlugin"]
						[#if promotionPlugin.isEnabled == true]
							<li[#if .main_template_name?matches(".*/discount_promotion/.*")] class="active"[/#if]>
								<a href="${base}/business/discount_promotion/list">
									<i class="fa fa-circle-o"></i>
									${message("business.mainSidebar.discountPromotionList")}
								</a>
							</li>
						[/#if]
					[/@promotion_plugin]
					[@promotion_plugin promotionPluginId = "fullReductionPromotionPlugin"]
						[#if promotionPlugin.isEnabled == true]
							<li[#if .main_template_name?matches(".*/full_reduction_promotion/.*")] class="active"[/#if]>
								<a href="${base}/business/full_reduction_promotion/list">
									<i class="fa fa-circle-o"></i>
									${message("business.mainSidebar.fullReductionPromotionList")}
								</a>
							</li>
						[/#if]
					[/@promotion_plugin]
					<li[#if .main_template_name?matches(".*/coupon/.*")] class="active"[/#if]>
						<a href="${base}/business/coupon/list">
							<i class="fa fa-circle-o"></i>
							${message("business.mainSidebar.couponList")}
						</a>
					</li>
				</ul>
			</li>
			<li class="treeview[#if .main_template_name?matches(".*/deposit/.*|.*/cash/.*")] active[/#if]">
				<a href="javascript:;">
					<i class="fa fa-credit-card"></i>
					<span>${message("business.mainSidebar.deposit")}</span>
					<span class="pull-right-container">
						<i class="fa fa-angle-left pull-right"></i>
					</span>
				</a>
				<ul class="treeview-menu">
					<li[#if .main_template_name?matches(".*/deposit/recharge.*")] class="active"[/#if]>
						<a href="${base}/business/deposit/recharge">
							<i class="fa fa-circle-o"></i>
							${message("business.mainSidebar.depositRecharge")}
						</a>
					</li>
					<li[#if .main_template_name?matches(".*/cash/.*")] class="active"[/#if]>
						<a href="${base}/business/cash/list">
							<i class="fa fa-circle-o"></i>
							${message("business.mainSidebar.cashList")}
						</a>
					</li>
					<li[#if .main_template_name?matches(".*/deposit/log.*")] class="active"[/#if]>
						<a href="${base}/business/deposit/log">
							<i class="fa fa-circle-o"></i>
							${message("business.mainSidebar.depositLog")}
						</a>
					</li>
				</ul>
			</li>
			<li class="treeview[#if .main_template_name?matches(".*/profile/.*|.*/password/.*")] active[/#if]">
				<a href="#">
					<i class="fa fa-user-o"></i>
					<span>${message("business.mainSidebar.profileList")}</span>
					<span class="pull-right-container">
						<i class="fa fa-angle-left pull-right"></i>
					</span>
				</a>
				<ul class="treeview-menu">
					<li[#if .main_template_name?matches(".*/profile/.*")] class="active"[/#if]>
						<a href="${base}/business/profile/edit">
							<i class="fa fa-circle-o"></i>
							${message("business.mainSidebar.profile")}
						</a>
					</li>
					<li[#if .main_template_name?matches(".*/password/.*")] class="active"[/#if]>
						<a href="${base}/business/password/edit">
							<i class="fa fa-circle-o"></i>
							${message("business.mainSidebar.password")}
						</a>
					</li>
				</ul>
			</li>
			<li[#if .main_template_name?matches(".*/instant_message/.*")] class="active"[/#if]>
				<a href="${base}/business/instant_message/list">
					<i class="fa fa-comment-o"></i>
					<span>${message("business.mainSidebar.instantMessageList")}</span>
				</a>
			</li>
			<li class="header">${message("business.mainSidebar.statistics")}</li>
			<li[#if .main_template_name?matches(".*/order_statistic/.*")] class="active"[/#if]>
				<a href="${base}/business/order_statistic/list">
					<i class="fa fa-line-chart text-red"></i>
					<span>${message("business.mainSidebar.orderStatisticList")}</span>
				</a>
			</li>
			<li[#if .main_template_name?matches(".*/product_ranking/.*")] class="active"[/#if]>
				<a href="${base}/business/product_ranking/list">
					<i class="fa fa-bar-chart text-yellow"></i>
					<span>${message("business.mainSidebar.productRankingList")}</span>
				</a>
			</li>
		</ul>
	</section>
</aside>