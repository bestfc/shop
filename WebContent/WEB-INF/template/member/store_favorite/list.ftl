<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("member.storeFavorite.list")}[#if showPowered] [/#if]</title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/member/css/animate.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/member/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/member/css/member.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/member/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/member/js/common.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $delete = $("#listTable a.delete");
	
	// 删除
	$delete.click(function() {
		if (confirm("${message("member.dialog.deleteConfirm")}")) {
			var $element = $(this);
			var storeFavoriteId = $element.data("store-favorite-id");
			$.ajax({
				url: "delete",
				type: "POST",
				data: {storeFavoriteId: storeFavoriteId},
				dataType: "json",
				success: function() {
					var $item = $element.closest("tr");
					if ($item.siblings("tr").size() < 2) {
						setTimeout(function() {
							location.reload(true);
						}, 3000);
					}
					$item.remove();
				}
			});
		}
		return false;
	});

});
</script>
</head>
<body>
	[#assign current = "storeFavoriteList" /]
	[#include "/shop/include/header.ftl" /]
	<div class="container member">
		<div class="row">
			[#include "/member/include/navigation.ftl" /]
			<div class="span10">
				<div class="list">
					<div class="title">${message("member.storeFavorite.list")}</div>
					<table id="listTable" class="list">
						<tr>
							<th>
								${message("Store.logo")}
							</th>
							<th>
								${message("Store.name")}
							</th>
							<th>
								${message("Store.type")}
							</th>
							<th>
								${message("member.common.action")}
							</th>
						</tr>
						[#list page.content as storeFavorite]
							<tr>
								<td width="110">
									<img src="${storeFavorite.store.logo!setting.defaultStoreLogo}" class="thumbnail" />
								</td>
								<td>
									<a href="${base}${storeFavorite.store.path}" title="${storeFavorite.store.name}" target="_blank">${abbreviate(storeFavorite.store.name, 30)}</a>
								</td>
								<td>
									${message("Store.Type." + storeFavorite.store.type)}
								</td>
								<td width="120">
									<a href="${base}${storeFavorite.store.path}" class="gotoStore">[${message("member.storeFavorite.inShop")}]</a>
									<a href="javascript:;" class="delete" data-store-favorite-id="${storeFavorite.id}">[${message("member.common.delete")}]</a>
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