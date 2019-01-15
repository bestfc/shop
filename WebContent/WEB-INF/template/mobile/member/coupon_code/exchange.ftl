<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.couponCode.exchange")}[#if showPowered] [/#if]</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/mobile/member/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/animate.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/common.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/profile.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/mobile/member/js/html5shiv.js"></script>
		<script src="${base}/resources/mobile/member/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/mobile/member/js/jquery.js"></script>
	<script src="${base}/resources/mobile/member/js/bootstrap.js"></script>
	<script src="${base}/resources/mobile/member/js/underscore.js"></script>
	<script src="${base}/resources/mobile/member/js/common.js"></script>
	<script>
		$().ready(function() {
			
			var $exchange = $("a.exchange");
			
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
<body class="profile">
	<header class="header-fixed">
		<a class="pull-left" href="${base}/member/index">
			<span class="glyphicon glyphicon-menu-left"></span>
		</a>
		${message("member.couponCode.exchange")}
	</header>
	<main>
		<div class="container-fluid">
			[#if page.content?has_content]
				[#list page.content as coupon]
					<div class="panel panel-flat">
						<div class="panel-heading clearfix">
							<h4>${coupon.store.name}</h4>
							<span class="pull-right orange">${coupon.name}</span>
						</div>
						<div class="panel-body">
							<div class="list-group list-group-flat small">
								<div class="list-group-item">
									${message("Coupon.point")}
									<span class="pull-right">${coupon.point}</span>
								</div>
								<div class="list-group-item">
									${message("Coupon.beginDate")}
									<span class="pull-right">
										[#if coupon.beginDate??]
											<span title="${coupon.beginDate?string("yyyy-MM-dd HH:mm:ss")}">${coupon.beginDate?string("yyyy-MM-dd HH:mm")}</span>
										[#else]
											-
										[/#if]
									</span>
								</div>
								<div class="list-group-item">
									${message("Coupon.endDate")}
									<span class="pull-right">
										[#if coupon.endDate??]
											<span title="${coupon.endDate?string("yyyy-MM-dd HH:mm:ss")}">${coupon.endDate?string("yyyy-MM-dd HH:mm")}</span>
										[#else]
											-
										[/#if]
									</span>
								</div>
							</div>
						</div>
						<div class="panel-footer text-right">
							<a class="exchange btn btn-sm btn-default" href="javascript:;" data-coupon-id="${coupon.id}">${message("member.couponCode.exchange")}</a>
						</div>
					</div>
				[/#list]
			[#else]
				<p class="no-result">${message("member.common.noResult")}</p>
			[/#if]
		</div>
	</main>
</body>
</html>