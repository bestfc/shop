<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("member.socialUser.list")}[#if showPowered] [/#if]</title>
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

	// 解除绑定
	$delete.click(function() {
		if (confirm("${message("member.socialUser.deleteConfirm")}")) {
			var $tr = $(this).closest("tr");
			var id = $tr.find("input[name='id']").val();
			$.ajax({
				url: "delete",
				type: "POST",
				data: {
					id: id
				},
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
	[#assign current = "socialUserList" /]
	[#include "/shop/include/header.ftl" /]
	<div class="container member">
		<div class="row">
			[#include "/member/include/navigation.ftl" /]
			<div class="span10">
				<div class="list">
					<div class="title">${message("member.socialUser.list")}</div>
					<table id="listTable" class="list">
						<tr>
							<th>
								${message("member.socialUser.bindMethod")}
							</th>
							<th>
								${message("member.common.createdDate")}
							</th>
							<th>
								${message("member.common.action")}
							</th>
						</tr>
						[#list page.content as socialUser]
							<tr[#if !socialUser_has_next] class="last"[/#if]>
								<td>
									<input type="hidden" name="id" value="${socialUser.id}" />
									${message("LoginPlugin."+socialUser.loginPluginId)}
								</td>
								<td>
									<span title="${socialUser.createdDate?string("yyyy-MM-dd HH:mm:ss")}">${socialUser.createdDate}</span>
								</td>
								<td>
									<a href="javascript:;" class="delete">[${message("member.socialUser.remove")}]</a>
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