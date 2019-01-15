<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("member.index.title")}[#if showPowered] [/#if]</title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/member/css/animate.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/member/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/member/css/member.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/member/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/member/js/common.js"></script>
</head>
<body>
	[#assign current = "indexMember" /]
	[#include "/shop/include/header.ftl" /]
	<div class="container member">
		<div class="row">
			[#include "/member/include/navigation.ftl" /]
			<div class="span10">
				<div class="index">
					<div class="top clearfix">
						<div>
							<ul>
								<li class="payment">
									<a href="order/list?status=pendingPayment&hasExpired=false">${message("member.index.pendingPaymentOrderList")}(<em>${pendingPaymentOrderCount}</em>)</a>
								</li>
								<li class="shipment">
									<a href="order/list?status=pendingShipment&hasExpired=false">${message("member.index.pendingShipmentOrderList")}(<em>${pendingShipmentOrderCount}</em>)</a>
								</li>
								<li class="messageCount">
									<a href="message/list">
										${message("member.index.messageList")}
										(<em>${messageCount}</em>)
									</a>
								</li>
								<li class="couponCode">
									<a href="coupon_code/list">
										${message("member.index.couponCodeList")}
										(<em>${couponCodeCount}</em>)
									</a>
								</li>
								<li class="productFavorite">
									<a href="product_favorite/list">
										${message("member.index.productFavoriteList")}
										(<em>${productFavoriteCount}</em>)
									</a>
								</li>
								<li class="productNotify">
									<a href="product_notify/list">
										${message("member.index.productNotifyList")}
										(<em>${productNotifyCount}</em>)
									</a>
								</li>
								<li class="review">
									<a href="review/list">
										${message("member.index.reviewList")}
										(<em>${reviewCount}</em>)
									</a>
								</li>
								<li class="consultation">
									<a href="consultation/list">
										${message("member.index.consultationList")}
										(<em>${consultationCount}</em>)
									</a>
								</li>
							</ul>
						</div>
					</div>
					<div class="memberLeft">
						<div class="leftTitle">
							<p>${message("member.index.transactionAlerts")}</p>
							<span>
								<a href="${base}/member/order/list">${message("member.index.checkAllOrder")}</a>
							</span>
						</div>
						<div class="leftMain">
							[#if newOrders?has_content]
								<table>
									[#list newOrders as order]
										<tr [#if !order_has_next] class="last"[/#if]>
											<td>${order.sn}</td>
											<td class="orderStoreName">${abbreviate(order.store.name, 20, "...")}</td>
											<td class="orderPrice">
												<span class="pagePrice">${currency(order.amount, true)}</span>${order.paymentMethodName}
											</td>
											<td class="orderDate">
												<span title="${order.createdDate?string("yyyy-MM-dd HH:mm:ss")}">${order.createdDate}</span>
											</td>
											<td>
												${message("Order.Status." + order.status)}
												[#if order.hasExpired()]
													<span class="silver">(${message("member.order.hasExpired")})</span>
												[/#if]
											</td>
											<td>
												<a href="${base}/member/order/view?orderSn=${order.sn}">[${message("member.order.view")}]</a>
											</td>
										</tr>
									[/#list]
								</table>
							[#else]
								<p class="noResult">${message("member.common.noResult")}</p>
							[/#if]
						</div>
					</div>
					<div class="memberRight">
						<div class="rightTitle">
							<p>${message("member.index.cart")}</p>
							<span>
								<a href="${base}/cart/list">${message("member.index.shoppingCart")}</a>
							</span>
						</div>
						<div class="rightMain">
							[#if currentUser.cart.cartItems?has_content]
								<table>
									[#list currentUser.cart.cartItems as cartItem]
										<tr [#if !cartItem_has_next] class="last"[/#if]>
											<td width="90">
												<a href="${base}${cartItem.sku.path}">
													<img src="${cartItem.sku.thumbnail!setting.defaultThumbnailProductImage}" width="60" height="60"/>
												</a>
											</td>
											<td width="200">${cartItem.sku.name}</td>
											<td class="tdCenter">${message("member.index.price")}<span class="pagePrice">${cartItem.price}</span></td>
										</tr>
										[#if cartItem_index == 2]
											[#break /]
										[/#if]
									[/#list]
								</table>
							[#else]
								<p class="noResult">${message("member.common.noResult")}</p>
							[/#if]
						</div>
					</div>
					<div class="memberLeft">
						<div class="leftTitle">
							<p>${message("member.index.productFavorite")}</p>
							<span><a href="${base}/member/product_favorite/list">${message("member.index.checkAllProductFavorite")}</a></span>
						</div>
						<div class="leftMain">
							[@product_favorite member = currentUser]
								[#if productFavorites?has_content]
									<table>
										[#list productFavorites as productFavorite]
											<tr [#if !productFavorite_has_next] class="last"[/#if]>
												<td width="60">
													<img src="${productFavorite.product.thumbnail!setting.defaultThumbnailProductImage}" class="productThumbnail" alt="${productFavorite.product.name}" />
												</td>
												<td>
													<a href="${base}${productFavorite.product.path}" title="${productFavorite.product.name}" target="_blank">${abbreviate(productFavorite.product.name, 30)}</a>
												</td>
												<td>
													${message("member.index.price")}
													<span class="pagePrice">${currency(productFavorite.product.price, true)}</span>
												</td>
											</tr>
											[#if productFavorite_index == 2]
												[#break /]
											[/#if]
										[/#list]
									</table>
								[#else]
									<p class="noResult">${message("member.common.noResult")}</p>
								[/#if]
							[/@product_favorite]
						</div>
					</div>
					<div class="memberRight">
						<div class="rightTitle">
							<p>${message("member.index.storeFavorite")}</p>
							<span>
								<a href="${base}/member/store_favorite/list">${message("member.index.checkAllStoreFavorite")}</a>
							</span>
						</div>
						<div class="rightMain">
							[@store_favorite member = currentUser]
								[#if storeFavorites?has_content]
									<table>
										[#list storeFavorites as storeFavorite]
											<tr [#if !storeFavorite_has_next] class="last"[/#if]>
												<td><img src="${storeFavorite.store.logo!setting.defaultStoreLogo}" width="100" height="50"/></td>
												<td>${abbreviate(storeFavorite.store.name, 20, "...")}</td>
												<td class="tdCenter"><a href="${base}${storeFavorite.store.path}" title="${storeFavorite.store.name}" target="_blank">${message("member.index.inShop")}</a></td>
											</tr>
											[#if storeFavorite_index == 2]
												[#break /]
											[/#if]
										[/#list]
									</table>
								[#else]
									<p class="noResult">${message("member.common.noResult")}</p>
								[/#if]
							[/@store_favorite]
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	[#include "/shop/include/footer.ftl" /]
</body>
</html>