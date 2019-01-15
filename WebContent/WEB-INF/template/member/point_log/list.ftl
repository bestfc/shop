<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("member.pointLog.list")}[#if showPowered] [/#if]</title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/member/css/animate.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/member/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/member/css/member.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/member/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/member/js/common.js"></script>
<script type="text/javascript">
$().ready(function() {

	[#if flashMessage?has_content]
		$.alert("${flashMessage}");
	[/#if]

});
</script>
</head>
<body>
	[#assign current = "pointLogList" /]
	[#include "/shop/include/header.ftl" /]
	<div class="container member">
		<div class="row">
			[#include "/member/include/navigation.ftl" /]
			<div class="span10">
				<div class="list">
					<div class="title">${message("member.pointLog.list")}</div>
					<table class="list">
						<tr>
							<th>
								${message("PointLog.type")}
							</th>
							<th>
								${message("PointLog.credit")}
							</th>
							<th>
								${message("PointLog.debit")}
							</th>
							<th>
								${message("PointLog.balance")}
							</th>
							<th>
								${message("member.common.createdDate")}
							</th>
						</tr>
						[#list page.content as pointLog]
							<tr[#if !point_has_next] class="last"[/#if]>
								<td>
									${message("PointLog.Type." + pointLog.type)}
								</td>
								<td>
									${pointLog.credit!"-"}
								</td>
								<td>
									${pointLog.debit!"-"}
								</td>
								<td>
									${pointLog.balance}
								</td>
								<td>
									<span title="${pointLog.createdDate?string("yyyy-MM-dd HH:mm:ss")}">${pointLog.createdDate}</span>
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