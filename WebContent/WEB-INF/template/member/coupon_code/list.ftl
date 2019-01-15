<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("member.couponCode.list")}[#if showPowered] [/#if]</title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/member/css/animate.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/member/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/member/css/member.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/member/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/member/js/common.js"></script>
<script type="text/javascript">
$().ready(function() {

	[#if flashMessage?has_content]
		$.alert("${flashMessage}");
	[/#if]

});
</script>
</head>
<body>
	[#assign current = "couponCodeList" /]
	[#include "/shop/include/header.ftl" /]
	<div class="container member">
		<div class="row">
			[#include "/member/include/navigation.ftl" /]
			<div class="span10">
				<div class="list">
					<div class="title">${message("member.couponCode.list")}</div>
					<table class="list">
						<thead>
							<tr>
								<th>${message("Coupon.store")}</th>
								<th>${message("member.couponCode.name")}</th>
								<th>${message("CouponCode.code")}</th>
								<th>${message("CouponCode.isUsed")}</th>
								<th>${message("CouponCode.usedDate")}</th>
								<th>${message("member.couponCode.expire")}</th>
							</tr>
						</thead>
						<tbody>
						[#list page.content as couponCode]
							<tr[#if !couponCode_has_next] class="last"[/#if]>
								<td>${abbreviate(couponCode.coupon.store.name, 20, "...")}</td>
								<td>${couponCode.coupon.name}</td>
								<td>${couponCode.code}</td>
								<td>${couponCode.isUsed?string(message("member.common.true"), message("member.common.false"))}</td>
								<td>
									[#if couponCode.usedDate??]
										<span title="${couponCode.usedDate?string("yyyy-MM-dd HH:mm:ss")}">${couponCode.usedDate}</span>
									[#else]
										-
									[/#if]
								</td>
								<td>
									[#if couponCode.coupon.endDate??]
										<span title="${couponCode.coupon.endDate?string("yyyy-MM-dd HH:mm:ss")}">${couponCode.coupon.endDate}</span>
									[#else]
										-
									[/#if]
								</td>
							</tr>
						[/#list]
						</tbody>
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