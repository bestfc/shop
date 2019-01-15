<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("member.message.view")}[#if showPowered] [/#if]</title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/member/css/animate.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/member/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/member/css/member.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/member/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/member/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/member/js/common.js"></script>
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
<body>
	[#assign current = "messageList" /]
	[#include "/shop/include/header.ftl" /]
	<div class="container member">
		<div class="row">
			[#include "/member/include/navigation.ftl" /]
			<div class="span10">
				<div class="message">
					<div class="title">${message("member.message.view")}</div>
					<dl>
						<dt>
							<strong>${memberMessage.title}</strong>
							[#if memberMessage.sender == currentUser]
								<span>${message("Message.receiver")}: [#if memberMessage.receiver??]${memberMessage.receiver.username}[#else]${message("member.message.admin")}[/#if]</span>
							[#else]
								<span>${message("Message.sender")}: [#if memberMessage.sender??]${memberMessage.sender.username}[#else]${message("member.message.admin")}[/#if]</span>
							[/#if]
						</dt>
						<dd>
							<div class="[#if memberMessage.sender == currentUser]right[#else]left[/#if]">
								<p>${memberMessage.content}</p>
								<span>[#if memberMessage.sender??][${memberMessage.sender.username}][#else][${message("member.message.admin")}][/#if] ${memberMessage.createdDate?string("yyyy-MM-dd HH:mm:ss")}</span>
								<div class="arrow"></div>
							</div>
						</dd>
						[#list memberMessage.replyMessages as replyMessage]
							<dd>
								<div class="[#if replyMessage.sender == currentUser]right[#else]left[/#if]">
									<p>${replyMessage.content}</p>
									<span>[#if replyMessage.sender??][${replyMessage.sender.username}][#else][${message("member.message.admin")}][/#if] ${replyMessage.createdDate?string("yyyy-MM-dd HH:mm:ss")}</span>
									<div class="arrow"></div>
								</div>
							</dd>
						[/#list]
					</dl>
				</div>
				<div class="input">
					<div class="title">${message("member.message.reply")}</div>
					<form id="inputForm" action="reply" method="post">
						<input type="hidden" name="memberMessageId" value="${memberMessage.id}" />
						<table class="input">
							<tr>
								<th>
									<span class="requiredField">*</span>${message("Message.content")}:
								</th>
								<td>
									<textarea name="content" class="text"></textarea>
								</td>
							</tr>
							<tr>
								<th>
									&nbsp;
								</th>
								<td>
									<input type="submit" class="button" value="${message("member.message.send")}" />
									<input type="button" class="button" value="${message("member.common.back")}" onclick="history.back(); return false;" />
								</td>
							</tr>
						</table>
					</form>
				</div>
			</div>
		</div>
	</div>
	[#include "/shop/include/footer.ftl" /]
</body>
</html>