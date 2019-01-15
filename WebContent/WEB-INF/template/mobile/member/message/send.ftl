<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.message.send")}[#if showPowered] [/#if]</title>
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
			var $isDraft = $("#isDraft");
			var $type = $("input[name='type']");
			var $username = $("#username");
			var $send = $("#send");
			var $save = $("#save");
			
			// 发送类型
			$type.click(function() {
				var $element = $(this);
				if ($element.val() == "member") {
					$username.prop("disabled", false).parent().show();
				} else {
					$username.prop("disabled", true).parent().hide();
				}
			});
			
			// 立即发送
			$send.click(function() {
				$isDraft.val("false");
				$inputForm.submit();
			});
			
			// 保存为草稿
			$save.click(function() {
				$isDraft.val("true");
				$inputForm.submit();
			});
			
			$.validator.addMethod("notEqualsIgnoreCase",
				function(value, element, param) {
					return this.optional(element) || param.toLowerCase() != value.toLowerCase()
				}
			);
			
			// 表单验证
			$inputForm.validate({
				rules: {
					username: {
						required: true,
						notEqualsIgnoreCase: "${currentUser.username}",
						remote: {
							url: "check_username",
							cache: false
						}
					},
					title: "required",
					content: {
						required: true,
						maxlength: 4000
					}
				},
				messages: {
					username: {
						notEqualsIgnoreCase: "${message("member.message.notAllowSelf")}",
						remote: "${message("member.message.memberNotExist")}"
					}
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
		${message("member.message.send")}
	</header>
	<main>
		<div class="container-fluid">
			<form id="inputForm" action="send" method="post">
				<input name="draftMessageId" type="hidden" value="${(draftMessage.id)!}">
				<input id="isDraft" name="isDraft" type="hidden" value="false">
				<div class="panel panel-flat">
					<div class="panel-body">
						<div class="form-group">
							<label>${message("member.message.sendTo")}</label>
							<div class="radio">
								<label>
									<input name="type" type="radio" value="member"[#if !draftMessage?? || (draftMessage?? && draftMessage.receiver??)] checked[/#if]>
									${message("member.message.otherMember")}
								</label>
								<label>
									<input name="type" type="radio" value="admin"[#if draftMessage?? && !draftMessage.receiver??] checked[/#if]>
									${message("member.message.admin")}
								</label>
							</div>
						</div>
						<div class="[#if draftMessage?? && !draftMessage.receiver??]hidden-element [/#if]form-group">
							<label for="username">${message("member.message.receiverUsername")}</label>
							<input id="username" name="username" class="form-control" type="text" value="${(draftMessage.receiver.username)!}" maxlength="200"[#if draftMessage?? && !draftMessage.receiver??] disabled[/#if]>
						</div>
						<div class="form-group">
							<label for="title">${message("Message.title")}</label>
							<input id="title" name="title" class="form-control" type="text" value="${(draftMessage.title)!}" maxlength="200">
						</div>
						<div class="form-group">
							<label for="content">${message("Message.content")}</label>
							<textarea id="content" name="content" class="form-control" rows="5">${(draftMessage.content)!}</textarea>
						</div>
					</div>
					<div class="panel-footer text-center">
						<button id="send" class="btn btn-primary" type="button">${message("member.message.sendNow")}</button>
						[#if !draftMessage??]
							<button id="save" class="btn btn-default" type="button">${message("member.message.saveDraft")}</button>
						[#else]
							<a class="btn btn-default" href="javascript: history.back();">${message("member.common.back")}</a>
						[/#if]
					</div>
				</div>
			</form>
		</div>
	</main>
</body>
</html>