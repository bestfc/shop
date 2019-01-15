<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("member.couponCode.exchange")}[#if showPowered] [/#if]</title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/member/css/animate.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/member/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/member/css/member.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/member/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/member/js/common.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $listTable = $("#listTable");
	var $exchange = $("#listTable a.exchange");
	
	[#if flashMessage?has_content]
		$.alert("${flashMessage}");
	[/#if]

	// 兑换
	$exchange.click(function() {
		if (confirm("${message("member.couponCode.exchangeConfirm")}")) {
			var $element = $(this);
			var couponId = $element.data("coupon-id");
			$.ajax({
				url: "exchange",
				type: "POST",
				data: {
					couponId: couponId
					},
				dataType: "json",
				success: function() {
					setTimeout(function() {
						location.href = "list";
					}, 3000);
				}
			});
		}
		return false;
	});

});
</script>
</head>
<body>
	[#assign current = "couponCodeExchange" /]
	[#include "/shop/include/header.ftl" /]
	<div class="container member">
		<div class="row">
			[#include "/member/include/navigation.ftl" /]
			<div class="span10">
				<div class="list">
					<div class="title">${message("member.couponCode.exchange")}</div>
					<table id="listTable" class="list">
						<tr>
							<th>${message("Coupon.store")}</th>
							<th>${message("Coupon.name")}</th>
							<th>${message("Coupon.point")}</th>
							<th>${message("Coupon.beginDate")}</th>
							<th>${message("Coupon.endDate")}</th>
							<th>${message("member.common.action")}</th>
						</tr>
						[#list page.content as coupon]
							<tr[#if !coupon_has_next] class="last"[/#if]>
								<td>${abbreviate(coupon.store.name, 20, "...")}</td>
								<td>${coupon.name}</td>
								<td>${coupon.point}</td>
								<td>
									[#if coupon.beginDate??]
										<span title="${coupon.beginDate?string("yyyy-MM-dd HH:mm:ss")}">${coupon.beginDate}</span>
									[#else]
										-
									[/#if]
								</td>
								<td>
									[#if coupon.endDate??]
										<span title="${coupon.endDate?string("yyyy-MM-dd HH:mm:ss")}">${coupon.endDate}</span>
									[#else]
										-
									[/#if]
								</td>
								<td>
									<a href="javascript:;" class="exchange" data-coupon-id="${coupon.id}">[${message("member.couponCode.exchange")}]</a>
								</td>
							</tr>
						[/#list]
					</table>
					[#if !page.content?has_content]
						<p>${message("member.common.noResult")}</p>
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