<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${product.name} ${message("shop.review.title")}[#if showPowered] [/#if]</title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/shop/css/animate.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/product.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/review.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/shop/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/list.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $addReview = $("#addReview");
	var $type = $("#type");
	var $typeMenu = $("#typeMenu");
	var $typeMenuItem = $("#typeMenu li");
	var $listForm = $("#listForm");
	
	$addReview.click(function() {
		if ($.checkLogin()) {
			return true;
		} else {
			$.redirectLogin("${base}/review/add/${product.id}", "${message("shop.review.accessDenied")}");
			return false;
		}
	});
	
	$typeMenu.hover(
		function() {
			$(this).children("ul").show();
		}, function() {
			$(this).children("ul").hide();
		}
	);
	
	$typeMenuItem.click(function() {
		$type.val($(this).attr("val"));
		$listForm.submit();
	});
	
});
</script>
</head>
<body>
	[#include "/shop/include/header.ftl" /]
	<div class="container review">
		<div class="row">
			<div class="span2">
				[#include "/shop/include/hot_product_category.ftl" /]
				[#include "/shop/include/hot_brand.ftl" /]
				[#include "/shop/include/hot_product.ftl" /]
				[#include "/shop/include/hot_promotion.ftl" /]
			</div>
			<div class="span10">
				<div class="breadcrumb">
					<ul>
						<li>
							<a href="${base}/">${message("shop.breadcrumb.home")}</a>
						</li>
						<li>
							<a href="${base}${product.path}">${abbreviate(product.name, 30)}</a>
						</li>
						<li>${message("shop.review.title")}</li>
					</ul>
				</div>
				<form id="listForm" action="${base}/review/detail/${product.id}" method="get">
					<input type="hidden" id="type" name="type" value="${type}" />
					<table class="info">
						<tr>
							<th rowspan="3">
								<img src="${product.thumbnail!setting.defaultThumbnailProductImage}" alt="${product.name}" />
							</th>
							<td>
								<a href="${base}${product.path}">${abbreviate(product.name, 50, "...")}</a>
							</td>
							<td rowspan="3">
								<div id="typeMenu" class="dropdownMenu">
									[#if type??]
										<span>${message("Review.Type." + type)}</span>
									[#else]
										<span>${message("shop.review.allType")}</span>
									[/#if]
									<ul>
										<li[#if type == null] class="current"[/#if] val="">${message("shop.review.allType")}</li>
										[#assign currentType = type]
										[#list types as type]
											<li[#if type == currentType] class="current"[/#if] val="${type}">${message("Review.Type." + type)}</li>
										[/#list]
									</ul>
								</div>
							</td>
							<td class="action" rowspan="3">
								<a href="${base}/review/add/${product.id}" id="addReview">[${message("shop.review.add")}]</a>
							</td>
						</tr>
						<tr>
							<td>
								${message("Product.price")}: <strong>${currency(product.price, true, true)}</strong>
							</td>
						</tr>
						<tr>
							<td>
								[#if product.scoreCount > 0]
									<div>${message("Product.score")}: </div>
									<div class="score${(product.score * 2)?string("0")}"></div>
									<div>${product.score?string("0.0")}</div>
								[#else]
									[#if setting.isShowMarketPrice]
										${message("Product.marketPrice")}:
										<del>${currency(product.marketPrice, true, true)}</del>
									[/#if]
								[/#if]
							</td>
						</tr>
					</table>
					<div class="content">
						[#if page.content?has_content]
							<table>
								[#list page.content as review]
									<tr[#if !review_has_next] class="last"[/#if]>
										<th>
											<div class="score${(review.score * 2)?string("0")}"></div>
											${review.content}
										</th>
										<td>
											<div>${review.member.memberRank.name}</div>
											[#if review.member??]
												${review.member.username}
											[#else]
												${message("shop.review.anonymous")}
											[/#if]
											<div><span title="${review.createdDate?string("yyyy-MM-dd HH:mm:ss")}">${review.createdDate}</span></div>
										</td>
										[#if review.replyReviews?has_content]
											<div class="arrow"></div>
											[#list review.replyReviews as replyReview]
												<tr>
													<th>
														&nbsp;&nbsp;&nbsp;&nbsp;${message("shop.review.storekeeper")}：${replyReview.content}
													</th>
													<td>
														<span title="${replyReview.createdDate?string("yyyy-MM-dd HH:mm:ss")}">${replyReview.createdDate}</span>
													</td>
												</tr>
											[/#list]
										[/#if]
									</tr>
								[/#list]
							</table>
						[#else]
							<p>${message("shop.review.noResult")}</p>
						[/#if]
					</div>
					[@pagination pageNumber = page.pageNumber totalPages = page.totalPages pattern = "javascript: $.pageSkip({pageNumber});"]
						[#include "/shop/include/pagination.ftl"]
					[/@pagination]
				</form>
			</div>
		</div>
	</div>
	[#include "/shop/include/footer.ftl" /]
</body>
</html>