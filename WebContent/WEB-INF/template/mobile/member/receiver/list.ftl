<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.receiver.list")}[#if showPowered] [/#if]</title>
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
			
			// 删除
			$delete.click(function() {
				if (confirm("${message("member.dialog.deleteConfirm")}")) {
					var $element = $(this);
					var receiverId = $element.data("receiver-id");
					$.ajax({
						url: "delete",
						type: "POST",
						data: {
							receiverId: receiverId
						},
						dataType: "json",
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
		${message("member.receiver.list")}
	</header>
	<main>
		<div class="container-fluid">
			[#if page.content?has_content]
				[#list page.content as receiver]
					<div class="panel panel-flat">
						<div class="panel-body">
							<div class="list-group list-group-flat">
								<div class="list-group-item">
									<div class="media">
										<h4 class="media-heading">
											${abbreviate(receiver.consignee, 10, "...")}
											<span class="pull-right">${receiver.phone}</span>
										</h4>
										<span class="small" title="${receiver.areaName}${receiver.address}">${receiver.areaName}${abbreviate(receiver.address, 30, "...")}</span>
									</div>
								</div>
								<div class="list-group-item">
									<em class="small orange">${message("Receiver.isDefault")}: ${receiver.isDefault?string(message("member.common.true"), message("member.common.false"))}</em>
								</div>
							</div>
						</div>
						<div class="panel-footer text-right">
							<a class="btn btn-sm btn-default" href="edit?receiverId=${receiver.id}">${message("member.common.edit")}</a>
							<a class="delete btn btn-sm btn-default" href="javascript:;" data-receiver-id="${receiver.id}">${message("member.common.delete")}</a>
						</div>
					</div>
				[/#list]
			[#else]
				<p class="no-result">${message("member.common.noResult")}</p>
			[/#if]
		</div>
	</main>
	<footer class="footer-fixed">
		<div class="container-fluid">
			<a class="btn btn-primary btn-flat btn-block" href="add">${message("member.receiver.add")}</a>
		</div>
	</footer>
</body>
</html>