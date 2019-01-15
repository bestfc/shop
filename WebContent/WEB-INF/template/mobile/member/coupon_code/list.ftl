<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.couponCode.list")}[#if showPowered] [/#if]</title>
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
	<script src="${base}/resources/mobile/member/js/moment.js"></script>
	<script src="${base}/resources/mobile/member/js/common.js"></script>
	<script id="couponCodeTemplate" type="text/template">
		<%_.each(couponCodes, function(couponCode, i) {%>
			<div class="panel panel-flat">
				<div class="panel-heading clearfix">
					<h4><%-couponCode.coupon.store.name%></h4>
					<span class="pull-right orange"><%-couponCode.coupon.name%></span>
				</div>
				<div class="panel-body">
					<div class="list-group list-group-flat small">
						<div class="list-group-item">
							${message("CouponCode.code")}
							<span class="pull-right"><%-couponCode.code%></span>
						</div>
						<div class="list-group-item">
							${message("CouponCode.usedDate")}
							<%if (couponCode.usedDate) {%>
								<span class="pull-right" title="<%-moment(new Date(couponCode.usedDate)).format('YYYY-MM-DD HH:mm:ss')%>"><%-moment(new Date(couponCode.usedDate)).format('YYYY-MM-DD')%></span>
							<%} else {%>
								<span class="pull-right">-</span>
							<%}%>
						</div>
						<div class="list-group-item">
							${message("member.couponCode.expire")}
							<%if (couponCode.coupon.endDate) {%>
								<span class="pull-right" title="<%-moment(new Date(couponCode.coupon.endDate)).format('YYYY-MM-DD HH:mm:ss')%>"><%-moment(new Date(couponCode.coupon.endDate)).format('YYYY-MM-DD')%></span>
							<%} else {%>
								<span class="pull-right">-</span>
							<%}%>
						</div>
						<div class="list-group-item">
							<em class="orange">${message("CouponCode.isUsed")}: <%-couponCode.isUsed ? "${message("member.common.true")}" : "${message("member.common.false")}"%></em>
						</div>
					</div>
				</div>
				<%if (!couponCode.isUsed) {%>
					<div class="panel-footer text-right">
						<a class="btn btn-sm btn-default" href="${base}<%-couponCode.coupon.store.path%>">${message("member.couponCode.use")}</a>
					</div>
				<%}%>
			</div>
		<%})%>
	</script>
	<script>
		$().ready(function() {
			
			var $couponCodeItems = $("#couponCodeItems");
			var couponCodeTemplate = _.template($("#couponCodeTemplate").html());
			
			// 无限滚动加载
			$couponCodeItems.infiniteScroll({
				url: function(pageNumber) {
					return "${base}/member/coupon_code/list?pageNumber=" + pageNumber;
				},
				pageSize: 10,
				template: function(pageNumber, data) {
					return couponCodeTemplate({
						couponCodes: data
					});
				}
			});
		
		});
	</script>
</head>
<body class="profile">
	<header class="header-fixed">
		<a class="pull-left" href="${base}/member/index">
			<span class="glyphicon glyphicon-menu-left"></span>
		</a>
		${message("member.couponCode.list")}
	</header>
	<main>
		<div class="container-fluid">
			<div id="couponCodeItems"></div>
		</div>
	</main>
</body>
</html>