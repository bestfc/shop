<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.socialUser.list")}[#if showPowered] [/#if]</title>
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
	<script src="${base}/resources/mobile/member/js/velocity.js"></script>
	<script src="${base}/resources/mobile/member/js/velocity.ui.js"></script>
	<script src="${base}/resources/mobile/member/js/underscore.js"></script>
	<script src="${base}/resources/mobile/member/js/common.js"></script>
	<script type="text/javascript">
		$().ready(function() {
			
		var $delete = $("a.delete");
		
		[#if flashMessage?has_content]
			$.alert("${flashMessage}");
		[/#if]
	
		// 解除绑定
		$delete.click(function() {
			if (confirm("${message("member.socialUser.deleteConfirm")}")) {
				var $element = $(this);
				var socialUserId = $element.data("social-user-id");
				$.ajax({
					url: "delete",
					type: "POST",
					data: {
						id: socialUserId
					},
					dataType: "json",
					cache: false,
					success: function() {
						$element.closest("div.panel").velocity("slideUp", {
							complete: function() {
								var $panel = $(this);
								if ($panel.siblings("div.panel").size() < 1) {
									setTimeout(function() {
										location.reload(true);
									}, 3000);
								}
								$panel.remove();
							}
						});
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
		${message("member.socialUser.list")}
	</header>
	<main>
		<div class="container-fluid">
			[#if page.content?has_content]
				[#list page.content as socialUser]
					<div class="panel panel-flat">
						<div class="panel-body">
							<div class="list-group list-group-flat small">
								<div class="list-group-item">
									${message("member.common.createdDate")}:
									<span title="${socialUser.createdDate?string("yyyy-MM-dd HH:mm:ss")}">${socialUser.createdDate}</span>
								</div>
								<div class="list-group-item">
									${message("member.socialUser.bindMethod")}
									<span class="pull-right orange">${message("LoginPlugin."+socialUser.loginPluginId)}</span>
								</div>
							</div>
						</div>
						<div class="panel-footer text-right">
							<a class="delete btn btn-sm btn-default" href="javascript:;" data-social-user-id="${socialUser.id}">${message("member.socialUser.remove")}</a>
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