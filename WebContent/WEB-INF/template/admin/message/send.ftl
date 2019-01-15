<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("admin.message.send")} </title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/input.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $inputForm = $("#inputForm");
	var $isDraft = $("#isDraft");
	var $send = $("#send");
	var $save = $("#save");
	
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
	
	// 表单验证
	$inputForm.validate({
		rules: {
			username: {
				required: true,
				remote: {
					url: "check_username",
					cache: false
				}
			},
			title: {
				required: true
			},
			content: {
				required: true,
				maxlength: 4000
			}
		},
		messages: {
			username: {
				remote: "${message("admin.message.memberNotExist")}"
			}
		}
	});
});
</script>
</head>
<body>
	<div class="breadcrumb">
		<a href="${base}/admin/index">${message("admin.breadcrumb.home")}</a> &raquo; ${message("admin.message.send")}
	</div>
	<form id="inputForm" action="send" method="post">
		<input type="hidden" name="draftMessageId" value="${(draftMessage.id)!}" />
		<input type="hidden" id="isDraft" name="isDraft" value="false" />
		<table class="input">
			<tr>
				<th>
					<span class="requiredField">*</span>${message("Message.receiver")}:
				</th>
				<td>
					<input type="text" name="username" class="text" value="${(draftMessage.receiver.username)!}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("Message.title")}:
				</th>
				<td>
					<input type="text" name="title" class="text" value="${(draftMessage.title)!}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("Message.content")}:
				</th>
				<td>
					<textarea name="content" class="text">${(draftMessage.content)!}</textarea>
				</td>
			</tr>
			<tr>
				<th>
					&nbsp;
				</th>
				<td>
					<input type="button" id="send" class="button" value="${message("admin.message.submit")}" />
					[#if !draftMessage??]
						<input type="button" id="save" class="button" value="${message("admin.message.saveDraft")}" />
					[/#if]
				</td>
			</tr>
		</table>
	</form>
</body>
</html>