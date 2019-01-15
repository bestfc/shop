<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.message.list")}[#if showPowered] [/#if]</title>
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
	<script src="${base}/resources/mobile/member/js/moment.js"></script>
	<script src="${base}/resources/mobile/member/js/common.js"></script>
	<script id="messageTemplate" type="text/template">
		<%_.each(messages, function(message, i) {%>
			<div class="panel panel-flat small">
				<div class="panel-heading">
					${message("member.common.createdDate")}:
					<span title="<%-moment(new Date(message.createdDate)).format('YYYY-MM-DD HH:mm:ss')%>"><%-moment(new Date(message.createdDate)).format('YYYY-MM-DD')%></span>
				</div>
				<div class="panel-body">
					<div class="list-group list-group-flat">
						<div class="list-group-item">
							${message("Message.title")}:
							<span title="<%-message.title%>"><%-abbreviate(message.title, 30, "...")%></span>
						</div>
						<div class="list-group-item">
							${message("member.message.opposite")}:
							<%if (message.receiver != null && message.receiver.id == ${currentUser.id}) {%>
								<%-message.sender != null ? message.sender.username : "${message("member.message.admin")}"%>
							<%} else {%>
								<%-message.receiver != null ? message.receiver.username : "${message("member.message.admin")}"%>
							<%}%>
						</div>
						<div class="list-group-item">
							${message("member.message.new")}:
							<%if (message.receiver != null && message.receiver.id == ${currentUser.id}) {%>
								<%-message.receiverRead ? "-" : "${message("member.message.new")}"%>
							<%} else {%>
								<%-message.senderRead ? "-" : "${message("member.message.new")}"%>
							<%}%>
						</div>
					</div>
				</div>
				<div class="panel-footer text-right">
					<a class="btn btn-sm btn-default" href="view?memberMessageId=<%-message.id%>">${message("member.common.view")}</a>
					<a class="delete btn btn-sm btn-default" href="javascript:;" data-message-id="<%-message.id%>">${message("member.common.delete")}</a>
				</div>
			</div>
		<%})%>
	</script>
	<script type="text/javascript">
		$().ready(function() {
			
			var $messageItems = $("#messageItems");
			var messageTemplate = _.template($("#messageTemplate").html());
			
			[#if flashMessage?has_content]
				$.alert("${flashMessage}");
			[/#if]
			
			// 删除
			$messageItems.on("click", "a.delete", function() {
				if (confirm("${message("member.dialog.deleteConfirm")}")) {
					var $element = $(this);
					var messageId = $element.data("message-id");
					$.ajax({
						url: "delete",
						type: "POST",
						data: {
							messageId: messageId
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
			
			// 无限滚动加载
			$messageItems.infiniteScroll({
				url: function(pageNumber) {
					return "${base}/member/message/list?pageNumber=" + pageNumber;
				},
				pageSize: 10,
				template: function(pageNumber, data) {
					return messageTemplate({
						messages: data
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
		${message("member.message.list")}
	</header>
	<main>
		<div class="container-fluid">
			<div id="messageItems"></div>
		</div>
	</main>
</body>
</html>