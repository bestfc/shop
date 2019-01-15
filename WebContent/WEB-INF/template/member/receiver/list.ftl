<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("member.receiver.list")}[#if showPowered] [/#if]</title>
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
			var receiverId = $tr.find("input[name='id']").val();
			$.ajax({
				url: "delete",
				type: "POST",
				data: {receiverId: receiverId},
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
	[#assign current = "receiverList" /]
	[#include "/shop/include/header.ftl" /]
	<div class="container member">
		<div class="row">
			[#include "/member/include/navigation.ftl" /]
			<div class="span10">
				<div class="list">
					<div class="title">${message("member.receiver.list")}</div>
					<div class="bar">
						<a href="add" class="button">${message("member.receiver.add")}</a>
					</div>
					<table id="listTable" class="list">
						<tr>
							<th>
								${message("Receiver.consignee")}
							</th>
							<th>
								${message("Receiver.address")}
							</th>
							<th>
								${message("Receiver.isDefault")}
							</th>
							<th>
								${message("member.common.action")}
							</th>
						</tr>
						[#list page.content as receiver]
							<tr[#if !receiver_has_next] class="last"[/#if]>
								<td>
									<input type="hidden" name="id" value="${receiver.id}" />
									${receiver.consignee}
								</td>
								<td>
									<span title="${receiver.areaName}${receiver.address}">${receiver.areaName}${abbreviate(receiver.address, 30, "...")}</span>
								</td>
								<td>
									${receiver.isDefault?string(message("member.common.true"), message("member.common.false"))}
								</td>
								<td>
									<a href="edit?receiverId=${receiver.id}">[${message("member.common.edit")}]</a>
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