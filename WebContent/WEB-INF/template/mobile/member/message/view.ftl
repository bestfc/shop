<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.message.view")}[#if showPowered] [/#if]</title>
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
	<script src="${base}/resources/mobile/member/js/jquery.validate.js"></script>
	<script src="${base}/resources/mobile/member/js/underscore.js"></script>
	<script src="${base}/resources/mobile/member/js/common.js"></script>
	<script type="text/javascript">
	$().ready(function() {
		
		var $inputForm = $("#inputForm");
		
		[#if flashMessage?has_content]
			$.alert("${flashMessage}");
		[/#if]
		
		// 表单验证
		$inputForm.validate({
			rules: {
				content: {
					required: true,
					maxlength: 4000
				}
			}
		});
	
	});
	</script>
</head>
<body class="profile">
	<header class="header-fixed">
		<a class="pull-left" href="${base}/member/message/list">
			<span class="glyphicon glyphicon-menu-left"></span>
		</a>
		${message("member.message.view")}
	</header>
	<main>
		<div class="container-fluid">
			<form id="inputForm" action="reply" method="post">
				<input name="memberMessageId" type="hidden" value="${memberMessage.id}">
				<div class="panel panel-flat">
					<div class="panel-body">
						<div class="messages list-group list-group-flat">
							<div class="list-group-item">
								<dl>
									<dt>
										<h4 class="blue">${abbreviate(memberMessage.title, 20, "...")}</h4>
										<span class="small">
											[#if memberMessage.sender == currentUser]
												${message("Message.receiver")}:
												[#if memberMessage.receiver??]
													${memberMessage.receiver.username}
												[#else]
													${message("member.message.admin")}
												[/#if]
											[#else]
												${message("Message.sender")}:
												[#if memberMessage.sender??]
													${memberMessage.sender.username}
												[#else]
													${message("member.message.admin")}
												[/#if]
											[/#if]
										</span>
									</dt>
									<dd class="clearfix">
										<div class="popover[#if memberMessage.sender == currentUser] left pull-right[#else] right pull-left[/#if]">
											<div class="arrow"></div>
											<p>${memberMessage.content}</p>
											<span class="small gray-darker">
												[#if memberMessage.sender??]
													[${memberMessage.sender.username}]
												[#else]
													[${message("member.message.admin")}]
												[/#if]
												${memberMessage.createdDate?string("yyyy-MM-dd HH:mm:ss")}
											</span>
										</div>
									</dd>
									[#list memberMessage.replyMessages as replyMessage]
										<dd class="clearfix">
											<div class="popover[#if replyMessage.sender == currentUser] left pull-right[#else] right pull-left[/#if]">
												<div class="arrow"></div>
												<p>${replyMessage.content}</p>
												<span class="small gray-darker">
													[#if replyMessage.sender??]
														[${replyMessage.sender.username}]
													[#else]
														[${message("member.message.admin")}]
													[/#if]
													${replyMessage.createdDate?string("yyyy-MM-dd HH:mm:ss")}
												</span>
											</div>
										</dd>
									[/#list]
								</dl>
							</div>
							<div class="list-group-item">
								<div class="form-group">
									<label for="content">${message("member.message.reply")}</label>
									<textarea id="content" name="content" class="form-control" rows="5">${(draftMessage.content)!}</textarea>
								</div>
							</div>
						</div>
					</div>
					<div class="panel-footer text-center">
						<button class="btn btn-primary" type="submit">${message("member.message.send")}</button>
						<a class="btn btn-default" href="${base}/member/message/list">${message("member.common.back")}</a>
					</div>
				</div>
			</form>
		</div>
	</main>
</body>
</html>