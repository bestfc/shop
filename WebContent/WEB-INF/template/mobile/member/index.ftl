<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.index.title")}[#if showPowered] [/#if]</title>
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
</head>
<body class="profile">
	<header class="header-fixed">
		<a class="pull-left" href="javascript: history.back();">
			<span class="glyphicon glyphicon-menu-left"></span>
		</a>
		${message("member.index.title")}
	</header>
	<main>
		<div class="container-fluid">
			<div class="panel panel-flat">
				<div class="panel-heading">
					${message("member.index.welcome")}
					<span class="red">${currentUser.username}</span>
					<span class="pull-right">
						${message("member.index.memberRank")}:
						<span class="red">${currentUser.memberRank.name}</span>
					</span>
				</div>
				<div class="panel-body small">
					<div class="row">
						<div class="col-xs-3 text-center">
							<a class="icon" href="${base}/member/product_favorite/list">
								<span class="fa fa-heart-o gray"></span>
								<span class="badge">${productFavoriteCount}</span>
								${message("member.index.productFavoriteList")}
							</a>
						</div>
						<div class="col-xs-3 text-center">
							<a class="icon" href="${base}/member/product_notify/list">
								<span class="fa fa-envelope-o gray"></span>
								<span class="badge">${productNotifyCount}</span>
								${message("member.index.productNotifyList")}
							</a>
						</div>
						<div class="col-xs-3 text-center">
							<a class="icon" href="${base}/member/review/list">
								<span class="fa fa-comment-o gray"></span>
								<span class="badge">${reviewCount}</span>
								${message("member.index.reviewList")}
							</a>
						</div>
						<div class="col-xs-3 text-center">
							<a class="icon" href="${base}/member/consultation/list">
								<span class="fa fa-question-circle-o gray"></span>
								<span class="badge">${consultationCount}</span>
								${message("member.index.consultationList")}
							</a>
						</div>
					</div>
				</div>
			</div>
			<div class="panel panel-flat">
				<div class="panel-heading">
					${message("member.index.order")}
					<a class="pull-right gray-darker" href="${base}/member/order/list">
						${message("member.index.orderList")}
						<span class="glyphicon glyphicon-menu-right"></span>
					</a>
				</div>
				<div class="panel-body small">
					<div class="row">
						<div class="col-xs-4 text-center">
							<a class="icon" href="${base}/member/order/list?status=pendingPayment&hasExpired=false">
								<span class="fa fa-credit-card gray"></span>
								<span class="badge">${pendingPaymentOrderCount}</span>
								${message("member.index.pendingPaymentOrderList")}
							</a>
						</div>
						<div class="col-xs-4 text-center">
							<a class="icon" href="${base}/member/order/list?status=pendingShipment&hasExpired=false">
								<span class="fa fa-calendar-minus-o gray"></span>
								<span class="badge">${pendingShipmentOrderCount}</span>
								${message("member.index.pendingShipmentOrderList")}
							</a>
						</div>
						<div class="col-xs-4 text-center">
							<a class="icon" href="${base}/member/order/list?status=shipped">
								<span class="fa fa-truck gray"></span>
								<span class="badge">${shippedOrderCount}</span>
								${message("member.index.shippedOrderList")}
							</a>
						</div>
					</div>
				</div>
			</div>
			<div class="panel panel-flat">
				<div class="panel-heading">${message("member.index.message")}</div>
				<div class="panel-body small">
					<div class="row">
						<div class="col-xs-4 text-center">
							<a class="icon" href="${base}/member/message/list">
								<span class="fa fa-commenting blue"></span>
								${message("member.index.messageList")}
							</a>
						</div>
						<div class="col-xs-4 text-center">
							<a class="icon" href="${base}/member/message/send">
								<span class="fa fa-send-o green"></span>
								${message("member.index.messageSend")}
							</a>
						</div>
						<div class="col-xs-4 text-center">
							<a class="icon" href="${base}/member/message/draft">
								<span class="fa fa-sticky-note-o orange-light"></span>
								${message("member.index.messageDraft")}
							</a>
						</div>
					</div>
				</div>
			</div>
			<div class="panel panel-flat">
				<div class="panel-heading">${message("member.index.other")}</div>
				<div class="panel-body small">
					<div class="list-group list-group-flat">
						<div class="list-group-item">
							<div class="row">
								<div class="col-xs-4 text-center">
									<a class="icon" href="${base}/member/store_favorite/list">
										<span class="fa fa-star-o yellow"></span>
										${message("member.index.storeFavoriteList")}
									</a>
								</div>
								<div class="col-xs-4 text-center">
									<a class="icon" href="${base}/member/coupon_code/list">
										<span class="fa fa-ticket orange-lighter"></span>
										${message("member.index.couponCodeList")}
									</a>
								</div>
								<div class="col-xs-4 text-center">
									<a class="icon" href="${base}/member/coupon_code/exchange">
										<span class="fa fa-exchange green-darker"></span>
										${message("member.index.couponCodeExchange")}
									</a>
								</div>
							</div>
						</div>
						<div class="list-group-item">
							<div class="row">
								<div class="col-xs-4 text-center">
									<a class="icon" href="${base}/member/point_log/list">
										<span class="fa fa-gift purple-lighter"></span>
										${message("member.index.pointLogList")}
									</a>
								</div>
								<div class="col-xs-4 text-center">
									<a class="icon" href="${base}/member/deposit/log">
										<span class="fa fa-rmb blue-dark"></span>
										${message("member.index.depositLog")}
									</a>
								</div>
								<div class="col-xs-4 text-center">
									<a class="icon" href="${base}/member/deposit/recharge">
										<span class="fa fa-money magenta"></span>
										${message("member.index.depositRecharge")}
									</a>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="list-group list-group-flat">
				<div class="list-group-item">
					${message("member.index.receiverList")}
					<a class="pull-right gray-darker" href="${base}/member/receiver/list">
						${message("member.index.receiverList")}
						<span class="glyphicon glyphicon-menu-right"></span>
					</a>
				</div>
			</div>
			<div class="list-group list-group-flat">
				<div class="list-group-item">
					${message("member.index.profileEdit")}
					<a class="pull-right gray-darker" href="${base}/member/profile/edit">
						${message("member.index.profileEdit")}
						<span class="glyphicon glyphicon-menu-right"></span>
					</a>
				</div>
			</div>
			<div class="list-group list-group-flat">
				<div class="list-group-item">
					${message("member.index.passwordEdit")}
					<a class="pull-right gray-darker" href="${base}/member/password/edit">
						${message("member.index.passwordEdit")}
						<span class="glyphicon glyphicon-menu-right"></span>
					</a>
				</div>
			</div>
			<div class="list-group list-group-flat">
				<div class="list-group-item">
					${message("member.index.socialUserList")}
					<a class="pull-right gray-darker" href="${base}/member/social_user/list">
						${message("member.index.socialUserList")}
						<span class="glyphicon glyphicon-menu-right"></span>
					</a>
				</div>
			</div>
			<div class="list-group list-group-flat">
				<div class="list-group-item">
					<a class="btn btn-lg btn-primary btn-flat btn-block" href="${base}/member/logout">${message("member.index.logout")}</a>
				</div>
			</div>
		</div>
	</main>
	<footer class="footer-fixed">
		<div class="container-fluid">
			<div class="row">
				<div class="col-xs-3 text-center">
					<span class="glyphicon glyphicon-home"></span>
					<a href="${base}/">${message("member.common.index")}</a>
				</div>
				<div class="col-xs-3 text-center">
					<span class="glyphicon glyphicon-th-list"></span>
					<a href="${base}/product_category">${message("member.common.productCategory")}</a>
				</div>
				<div class="col-xs-3 text-center">
					<span class="glyphicon glyphicon-shopping-cart"></span>
					<a href="${base}/cart/list">${message("member.common.cart")}</a>
				</div>
				<div class="col-xs-3 text-center active">
					<span class="glyphicon glyphicon-user"></span>
					<a href="${base}/member/index">${message("member.common.member")}</a>
				</div>
			</div>
		</div>
	</footer>
</body>
</html>