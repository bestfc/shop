<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("member.message.draft")}[#if showPowered] [/#if]</title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/member/css/animate.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/member/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/member/css/member.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/member/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/member/js/common.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $listTable = $("#listTable");
	var $delete = $("#listTable a.delete");
	
	[#if flashMessage?has_content]
		$.alert("${flashMessage}");
	[/#if]
	
	// 删除
	$delete.click(function() {
		if (confirm("${message("member.dialog.deleteConfirm")}")) {
			var $tr = $(this).closest("tr");
			var messageId = $tr.find("input[name='messageId']").val();
			$.ajax({
				url: "delete",
				type: "POST",
				data: {messageId: messageId},
				dataType: "json",
				cache: false,
				success: function() {
					var $siblings = $tr.siblings();
					if ($siblings.size() <= 1) {
						$listTable.after('<p>${message("member.common.noResult")}<\/p>');
					} else {
						$siblings.last().addClass("last");
					}
					$tr.remove();
				}
			});
		}
		return false;
	});

});	
</script>
</head>
<body>
	[#assign current = "messageDraft" /]
	[#include "/shop/include/header.ftl" /]
	<div class="container member">
		<div class="row">
			[#include "/member/include/navigation.ftl" /]
			<div class="span10">
				<div class="list">
					<div class="title">${message("member.message.draft")} <span>(${message("member.message.total", page.total)})</span></div>
					<table id="listTable" class="list">
						<tr>
							<th>
								${message("Message.title")}
							</th>
							<th>
								${message("Message.receiver")}
							</th>
							<th>
								${message("member.common.createdDate")}
							</th>
							<th>
								${message("member.common.action")}
							</th>
						</tr>
						[#list page.content as memberMessage]
							<tr[#if !memberMessage_has_next] class="last"[/#if]>
								<td>
									<input type="hidden" name="messageId" value="${memberMessage.id}" />
									<span title="${memberMessage.title}">${abbreviate(memberMessage.title, 30)}</span>
								</td>
								<td>
									[#if memberMessage.receiver??]${memberMessage.receiver.username}[#else]${message("member.message.admin")}[/#if]
								</td>
								<td>
									<span title="${memberMessage.createdDate?string("yyyy-MM-dd HH:mm:ss")}">${memberMessage.createdDate}</span>
								</td>
								<td>
									<a href="send?draftMessageId=${memberMessage.id}">[${message("member.common.view")}]</a>
									<a href="javascript:;" class="delete">[${message("member.common.delete")}]</a>
								</td>
							</tr>
						[/#list]
					</table>
					[#if !page.content?has_content]
						<p>${message("member.common.noResult")}</p>
					[/#if]
				</div>
				[@pagination pageNumber = page.pageNumber totalPages = page.totalPages pattern = "?pageNumber={pageNumber}"]
					[#include "/shop/include/pagination.ftl"]
				[/@pagination]
			</div>
		</div>
	</div>
	[#include "/shop/include/footer.ftl" /]
</body>
</html>