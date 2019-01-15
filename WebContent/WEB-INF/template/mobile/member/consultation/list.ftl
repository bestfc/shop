<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.consultation.list")}[#if showPowered] [/#if]</title>
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
	<script id="consultationTemplate" type="text/template">
		<%_.each(consultations, function(consultation, i) {%>
			<div class="panel panel-flat">
				<div class="panel-heading small">
					${message("member.common.createdDate")}:
					<span title="<%-moment(new Date(consultation.createdDate)).format('YYYY-MM-DD HH:mm:ss')%>"><%-moment(new Date(consultation.createdDate)).format('YYYY-MM-DD')%></span>
				</div>
				<div class="panel-body">
					<div class="media">
						<div class="media-left media-middle">
							<a href="${base}<%-consultation.product.path%>#consultation" title="<%-consultation.product.name%>">
								<img src="<%-consultation.product.thumbnail != null ? consultation.product.thumbnail : "${setting.defaultThumbnailProductImage}"%>" alt="<%-consultation.product.name%>">
							</a>
						</div>
						<div class="media-body media-middle">
							<h4 class="media-heading">
								<a href="${base}<%-consultation.product.path%>#consultation" title="<%-consultation.product.name%>" disabled><%-abbreviate(consultation.product.name, 30)%></a>
							</h4>
						</div>
					</div>
				</div>
				<div class="panel-footer text-right">
					<a class="btn btn-sm btn-default" href="${base}<%-consultation.product.path%>#consultation">${message("member.common.view")}</a>
				</div>
			</div>
		<%})%>
	</script>
	<script type="text/javascript">
	$().ready(function() {
		
		var $consultationItems = $("#consultationItems");
		var consultationTemplate = _.template($("#consultationTemplate").html());
		
		// 无限滚动加载
		$consultationItems.infiniteScroll({
			url: function(pageNumber) {
				return "${base}/member/consultation/list?pageNumber=" + pageNumber;
			},
			pageSize: 10,
			template: function(pageNumber, data) {
				return consultationTemplate({
					consultations: data
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
		${message("member.consultation.list")}
	</header>
	<main>
		<div class="container-fluid">
			<div id="consultationItems"></div>
		</div>
	</main>
</body>
</html>