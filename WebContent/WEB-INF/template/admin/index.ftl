[#assign shiro = JspTaglibs["/WEB-INF/tld/shiro.tld"] /]
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html;charset=utf-8" />
<title>${message("admin.index.title")} </title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/admin/css/index.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $nav = $("#nav a:not(:last)");
	var $menu = $("#menu dl");
	var $menuItem = $("#menu a");
	var $iframe = $("#iframe");
	
	$nav.click(function() {
		var $this = $(this);
		$nav.removeClass("current");
		$this.addClass("current");
		var $currentMenu = $($this.attr("href"));
		$menu.hide();
		$currentMenu.show();
		return false;
	});
	
	$menuItem.click(function() {
		var $this = $(this);
		$menuItem.removeClass("current");
		$this.addClass("current");
	});
	
	$iframe.load(function() {
		if ($iframe.is(":hidden") && $iframe.contents().find("body").html() != "") {
			$iframe.show().siblings().hide();
		}
	});

});
</script>
</head>
<body>
	<script type="text/javascript">
		if (self != top) {
			top.location = self.location;
		}
	</script>
	<table class="index">
		<tr>
			<th class="logo">
				<a href="index">
					<img src="${base}/resources/admin/images/header_logo.gif" alt="SHOP++" />
				</a>
			</th>
			<th>
				<div id="nav" class="nav">
					<ul>
						[#list ["admin:business", "admin:store", "admin:storeCategory", "admin:storeRank", "admin:businessAttribute", "admin:cash", "admin:categoryApplication", "admin:businessDeposit"] as permission]
							[@shiro.hasPermission name = permission]
								<li>
									<a href="#store">${message("admin.index.storeNav")}</a>
								</li>
								[#break /]
							[/@shiro.hasPermission]
						[/#list]
						[#list ["admin:product", "admin:stock", "admin:productCategory", "admin:productTag", "admin:parameter", "admin:attribute", "admin:specification", "admin:brand"] as permission]
							[@shiro.hasPermission name = permission]
								<li>
									<a href="#product">${message("admin.index.productNav")}</a>
								</li>
								[#break /]
							[/@shiro.hasPermission]
						[/#list]
						[#list ["admin:order", "admin:orderPayment", "admin:orderRefunds", "admin:orderShipping", "admin:orderReturns", "admin:deliveryCenter", "admin:deliveryTemplate"] as permission]
							[@shiro.hasPermission name = permission]
								<li>
									<a href="#order">${message("admin.index.orderNav")}</a>
								</li>
								[#break /]
							[/@shiro.hasPermission]
						[/#list]
						[#list ["admin:member", "admin:memberRank", "admin:memberAttribute", "admin:point", "admin:memberDeposit", "admin:review", "admin:consultation", "admin:messageConfig"] as permission]
							[@shiro.hasPermission name = permission]
								<li>
									<a href="#member">${message("admin.index.memberNav")}</a>
								</li>
								[#break /]
							[/@shiro.hasPermission]
						[/#list]
						[#list ["admin:navigation", "admin:article", "admin:articleCategory", "admin:articleTag", "admin:friendLink", "admin:adPosition", "admin:ad", "admin:template", "admin:cache"] as permission]
							[@shiro.hasPermission name = permission]
								<li>
									<a href="#content">${message("admin.index.contentNav")}</a>
								</li>
								[#break /]
							[/@shiro.hasPermission]
						[/#list]
						[#list ["admin:promotion", "admin:coupon", "admin:seo"] as permission]
							[@shiro.hasPermission name = permission]
								<li>
									<a href="#marketing">${message("admin.index.marketingNav")}</a>
								</li>
								[#break /]
							[/@shiro.hasPermission]
						[/#list]
						[#list ["admin:setting", "admin:area", "admin:paymentMethod", "admin:shippingMethod", "admin:deliveryCorp", "admin:paymentPlugin", "admin:storagePlugin", "admin:loginPlugin", "admin:promotionPlugin", "admin:admin", "admin:role", "admin:message", "admin:auditLog"] as permission]
							[@shiro.hasPermission name = permission]
								<li>
									<a href="#system">${message("admin.index.systemNav")}</a>
								</li>
								[#break /]
							[/@shiro.hasPermission]
						[/#list]
						<li>
							<a href="${base}/" target="_blank">${message("admin.index.home")}</a>
						</li>
					</ul>
				</div>
				<div class="link">
					<a href="http://www.shopxx.net" target="_blank">${message("admin.index.official")}</a>|
					<a href="http://bbs.shopxx.net" target="_blank">${message("admin.index.bbs")}</a>|
					<a href="http://www.shopxx.net/about.html" target="_blank">${message("admin.index.about")}</a>
				</div>
				<div class="link">
					<strong>[@shiro.principal property = "displayName" /]</strong>
					${message("admin.index.hello")}!
					<a href="profile/edit" target="iframe">[${message("admin.index.profile")}]</a>
					<a href="logout" target="_top">[${message("admin.index.logout")}]</a>
				</div>
			</th>
		</tr>
		<tr>
			<td id="menu" class="menu">
				<dl id="store" class="default">
					<dt>${message("admin.index.storeGroup")}</dt>
					[@shiro.hasPermission name = "admin:business"]
						<dd>
							<a href="business/list" target="iframe">${message("admin.index.business")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:store"]
						<dd>
							<a href="store/list" target="iframe">${message("admin.index.store")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:storeCategory"]
						<dd>
							<a href="store_category/list" target="iframe">${message("admin.index.storeCategory")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:storeRank"]
						<dd>
							<a href="store_rank/list" target="iframe">${message("admin.index.storeRank")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:businessAttribute"]
						<dd>
							<a href="business_attribute/list" target="iframe">${message("admin.index.businessAttribute")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:cash"]
						<dd>
							<a href="cash/list" target="iframe">${message("admin.index.cash")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:categoryApplication"]
						<dd>
							<a href="category_application/list" target="iframe">${message("admin.index.categoryApplication")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:businessDeposit"]
						<dd>
							<a href="business_deposit/log" target="iframe">${message("admin.index.businessDeposit")}</a>
						</dd>
					[/@shiro.hasPermission]
				</dl>
				<dl id="product">
					<dt>${message("admin.index.productGroup")}</dt>
					[@shiro.hasPermission name = "admin:product"]
						<dd>
							<a href="product/list" target="iframe">${message("admin.index.product")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:stock"]
						<dd>
							<a href="stock/log" target="iframe">${message("admin.index.stock")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:productCategory"]
						<dd>
							<a href="product_category/list" target="iframe">${message("admin.index.productCategory")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:productTag"]
						<dd>
							<a href="product_tag/list" target="iframe">${message("admin.index.productTag")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:parameter"]
						<dd>
							<a href="parameter/list" target="iframe">${message("admin.index.parameter")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:attribute"]
						<dd>
							<a href="attribute/list" target="iframe">${message("admin.index.attribute")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:specification"]
						<dd>
							<a href="specification/list" target="iframe">${message("admin.index.specification")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:brand"]
						<dd>
							<a href="brand/list" target="iframe">${message("admin.index.brand")}</a>
						</dd>
					[/@shiro.hasPermission]
				</dl>
				<dl id="order">
					<dt>${message("admin.index.orderGroup")}</dt>
					[@shiro.hasPermission name = "admin:order"]
						<dd>
							<a href="order/list" target="iframe">${message("admin.index.order")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:orderPayment"]
						<dd>
							<a href="order_payment/list" target="iframe">${message("admin.index.orderPayment")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:orderRefunds"]
						<dd>
							<a href="refunds/list" target="iframe">${message("admin.index.orderRefunds")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:orderShipping"]
						<dd>
							<a href="shipping/list" target="iframe">${message("admin.index.orderShipping")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:orderReturns"]
						<dd>
							<a href="returns/list" target="iframe">${message("admin.index.orderReturns")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:deliveryCenter"]
						<dd>
							<a href="delivery_center/list" target="iframe">${message("admin.index.deliveryCenter")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:deliveryTemplate"]
						<dd>
							<a href="delivery_template/list" target="iframe">${message("admin.index.deliveryTemplate")}</a>
						</dd>
					[/@shiro.hasPermission]
				</dl>
				<dl id="member">
					<dt>${message("admin.index.memberGroup")}</dt>
					[@shiro.hasPermission name = "admin:member"]
						<dd>
							<a href="member/list" target="iframe">${message("admin.index.member")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:memberRank"]
						<dd>
							<a href="member_rank/list" target="iframe">${message("admin.index.memberRank")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:memberAttribute"]
						<dd>
							<a href="member_attribute/list" target="iframe">${message("admin.index.memberAttribute")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:point"]
						<dd>
							<a href="point/log" target="iframe">${message("admin.index.point")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:memberDeposit"]
						<dd>
							<a href="member_deposit/log" target="iframe">${message("admin.index.memberDeposit")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:review"]
						<dd>
							<a href="review/list" target="iframe">${message("admin.index.review")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:consultation"]
						<dd>
							<a href="consultation/list" target="iframe">${message("admin.index.consultation")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:messageConfig"]
						<dd>
							<a href="message_config/list" target="iframe">${message("admin.index.messageConfig")}</a>
						</dd>
					[/@shiro.hasPermission]
				</dl>
				<dl id="content">
					<dt>${message("admin.index.contentGroup")}</dt>
					[@shiro.hasPermission name = "admin:navigation"]
						<dd>
							<a href="navigation/list" target="iframe">${message("admin.index.navigation")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:article"]
						<dd>
							<a href="article/list" target="iframe">${message("admin.index.article")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:articleCategory"]
						<dd>
							<a href="article_category/list" target="iframe">${message("admin.index.articleCategory")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:articleTag"]
						<dd>
							<a href="article_tag/list" target="iframe">${message("admin.index.articleTag")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:friendLink"]
						<dd>
							<a href="friend_link/list" target="iframe">${message("admin.index.friendLink")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:adPosition"]
						<dd>
							<a href="ad_position/list" target="iframe">${message("admin.index.adPosition")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:ad"]
						<dd>
							<a href="ad/list" target="iframe">${message("admin.index.ad")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:template"]
						<dd>
							<a href="template/list" target="iframe">${message("admin.index.template")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:cache"]
						<dd>
							<a href="cache/clear" target="iframe">${message("admin.index.cache")}</a>
						</dd>
					[/@shiro.hasPermission]
				</dl>
				<dl id="marketing">
					<dt>${message("admin.index.marketingGroup")}</dt>
					[@shiro.hasPermission name = "admin:promotion"]
						<dd>
							<a href="promotion/list" target="iframe">${message("admin.index.promotion")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:coupon"]
						<dd>
							<a href="coupon/list" target="iframe">${message("admin.index.coupon")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:seo"]
						<dd>
							<a href="seo/list" target="iframe">${message("admin.index.seo")}</a>
						</dd>
					[/@shiro.hasPermission]
				</dl>
				<dl id="system">
					<dt>${message("admin.index.systemGroup")}</dt>
					[@shiro.hasPermission name = "admin:setting"]
						<dd>
							<a href="setting/edit" target="iframe">${message("admin.index.setting")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:area"]
						<dd>
							<a href="area/list" target="iframe">${message("admin.index.area")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:paymentMethod"]
						<dd>
							<a href="payment_method/list" target="iframe">${message("admin.index.paymentMethod")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:shippingMethod"]
						<dd>
							<a href="shipping_method/list" target="iframe">${message("admin.index.shippingMethod")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:deliveryCorp"]
						<dd>
							<a href="delivery_corp/list" target="iframe">${message("admin.index.deliveryCorp")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:deliveryCorp"]
						<dd>
                            <a href="express_plugin/list" target="iframe">${message("admin.index.expressPlugin")}</a>
                        </dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:paymentPlugin"]
						<dd>
							<a href="payment_plugin/list" target="iframe">${message("admin.index.paymentPlugin")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:storagePlugin"]
						<dd>
							<a href="storage_plugin/list" target="iframe">${message("admin.index.storagePlugin")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:loginPlugin"]
						<dd>
							<a href="login_plugin/list" target="iframe">${message("admin.index.loginPlugin")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:promotionPlugin"]
						<dd>
							<a href="promotion_plugin/list" target="iframe">${message("admin.index.promotion_plugin")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:admin"]
						<dd>
							<a href="admin/list" target="iframe">${message("admin.index.admin")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:role"]
						<dd>
							<a href="role/list" target="iframe">${message("admin.index.role")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:message"]
						<dd>
							<a href="message/send" target="iframe">${message("admin.index.send")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:message"]
						<dd>
							<a href="message/list" target="iframe">${message("admin.index.message")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:message"]
						<dd>
							<a href="message/draft" target="iframe">${message("admin.index.draft")}</a>
						</dd>
					[/@shiro.hasPermission]
					[@shiro.hasPermission name = "admin:auditLog"]
						<dd>
							<a href="audit_log/list" target="iframe">${message("admin.index.auditLog")}</a>
						</dd>
					[/@shiro.hasPermission]
				</dl>
			</td>
			<td>
				<div class="breadcrumb">
					${message("admin.index.title")}
				</div>
				<table class="input">
					<tr>
						<th>
							${message("admin.index.systemName")}:
						</th>
						<td>
							${systemName}
							<a href="http://www.shopxx.net" class="silver" target="_blank">[${message("admin.index.license")}]</a>
						</td>
						<th>
							${message("admin.index.systemVersion")}:
						</th>
						<td>
							${systemVersion}
						</td>
					</tr>
					<tr>
						<th>
							${message("admin.index.official")}:
						</th>
						<td>
							<a href="http://www.shopxx.net" target="_blank">http://www.shopxx.net</a>
						</td>
						<th>
							${message("admin.index.bbs")}:
						</th>
						<td>
							<a href="http://bbs.shopxx.net" target="_blank">http://bbs.shopxx.net</a>
						</td>
					</tr>
					<tr>
						<td colspan="4">
							&nbsp;
						</td>
					</tr>
					<tr>
						<th>
							${message("admin.index.javaVersion")}:
						</th>
						<td>
							${javaVersion}
						</td>
						<th>
							${message("admin.index.javaHome")}:
						</th>
						<td>
							${javaHome}
						</td>
					</tr>
					<tr>
						<th>
							${message("admin.index.osName")}:
						</th>
						<td>
							${osName}
						</td>
						<th>
							${message("admin.index.osArch")}:
						</th>
						<td>
							${osArch}
						</td>
					</tr>
					<tr>
						<th>
							${message("admin.index.serverInfo")}:
						</th>
						<td>
							<span title="${serverInfo}">${abbreviate(serverInfo, 30, "...")}</span>
						</td>
						<th>
							${message("admin.index.servletVersion")}:
						</th>
						<td>
							${servletVersion}
						</td>
					</tr>
					<tr>
						<td colspan="4">
							&nbsp;
						</td>
					</tr>
					<tr>
						<th>
							${message("admin.index.pendingReviewOrderCount")}:
						</th>
						<td>
							${pendingReviewOrderCount}
						</td>
						<th>
							${message("admin.index.pendingShipmentOrderCount")}:
						</th>
						<td>
							${pendingShipmentOrderCount}
						</td>
					</tr>
					<tr>
						<th>
							${message("admin.index.pendingReceiveOrderCount")}:
						</th>
						<td>
							${pendingReceiveOrderCount}
						</td>
						<th>
							${message("admin.index.pendingRefundsOrderCount")}:
						</th>
						<td>
							${pendingRefundsOrderCount}
						</td>
					</tr>
					<tr>
						<th>
							${message("admin.index.marketableProductCount")}:
						</th>
						<td>
							${marketableSkuCount}
						</td>
						<th>
							${message("admin.index.notMarketableProductCount")}:
						</th>
						<td>
							${notMarketableSkuCount}
						</td>
					</tr>
					<tr>
						<th>
							${message("admin.index.stockAlertProductCount")}:
						</th>
						<td>
							${stockAlertSkuCount}
						</td>
						<th>
							${message("admin.index.outOfStockProductCount")}:
						</th>
						<td>
							${outOfStockSkuCount}
						</td>
					</tr>
					<tr>
						<th>
							${message("admin.index.memberCount")}:
						</th>
						<td>
							${memberCount}
						</td>
						<th>
							${message("admin.index.unreadMessageCount")}:
						</th>
						<td>
							${unreadMessageCount}
						</td>
					</tr>
					<tr>
						<td class="powered" colspan="4">
							COPYRIGHT © 2005-2017 SHOPXX.NET ALL RIGHTS RESERVED.
						</td>
					</tr>
				</table>
				<iframe id="iframe" name="iframe" frameborder="0"></iframe>
			</td>
		</tr>
	</table>
</body>
</html>