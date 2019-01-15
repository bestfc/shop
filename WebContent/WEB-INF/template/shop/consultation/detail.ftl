<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${product.name} ${message("shop.consultation.title")}[#if showPowered] [/#if]</title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/shop/css/animate.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/product.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/consultation.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/shop/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/common.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $addConsultation = $("#addConsultation");
	
	$addConsultation.click(function() {
		if ($.checkLogin()) {
			return true;
		} else {
			$.redirectLogin("${base}/consultation/add/${product.id}", "${message("shop.consultation.accessDenied")}");
			return false;
		}
	});
	
});
</script>
</head>
<body>
	[#include "/shop/include/header.ftl" /]
	<div class="container consultation">
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
						<li>${message("shop.consultation.title")}</li>
					</ul>
				</div>
				<table class="info">
					<tr>
						<th rowspan="3">
							<img src="${product.thumbnail!setting.defaultThumbnailProductImage}" alt="${product.name}" />
						</th>
						<td>
							<a href="${base}${product.path}">${abbreviate(product.name, 50, "...")}</a>
						</td>
						<td class="action" rowspan="3">
							<a href="${base}/consultation/add/${product.id}" id="addConsultation">[${message("shop.consultation.add")}]</a>
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
						<ul>
							[#list page.content as consultation]
								<li[#if !consultation_has_next] class="last"[/#if]>
									${consultation.content}
									<span>
										[#if consultation.member??]
											${consultation.member.username}
										[#else]
											${message("shop.consultation.anonymous")}
										[/#if]
										<span title="${consultation.createdDate?string("yyyy-MM-dd HH:mm:ss")}">${consultation.createdDate}</span>
									</span>
									[#if consultation.replyConsultations?has_content]
										<div class="arrow"></div>
										<ul>
											[#list consultation.replyConsultations as replyConsultation]
												<li>
													${replyConsultation.content}
													<span title="${replyConsultation.createdDate?string("yyyy-MM-dd HH:mm:ss")}">${replyConsultation.createdDate}</span>
												</li>
											[/#list]
										</ul>
									[/#if]
								</li>
							[/#list]
						</ul>
					[#else]
						<p>${message("shop.consultation.noResult")}</p>
					[/#if]
				</div>
				[@pagination pageNumber = page.pageNumber totalPages = page.totalPages pattern = "?pageNumber={pageNumber}"]
					[#include "/shop/include/pagination.ftl"]
				[/@pagination]
			</div>
		</div>
	</div>
	[#include "/shop/include/footer.ftl" /]
</body>
</html>