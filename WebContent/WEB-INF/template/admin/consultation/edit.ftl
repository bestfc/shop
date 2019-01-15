<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("admin.consultation.edit")} </title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/input.js"></script>
<script type="text/javascript">
$().ready(function() {

	[@flash_message /]

});
</script>
</head>
<body>
	<div class="breadcrumb">
		<a href="${base}/admin/index">${message("admin.breadcrumb.home")}</a> &raquo; ${message("admin.consultation.edit")}
	</div>
	<form id="inputForm" action="update" method="post">
		<input type="hidden" name="id" value="${consultation.id}" />
		<table class="input">
			<tr>
				<th>
					${message("Consultation.product")}:
				</th>
				<td colspan="3">
					<a href="${base}${consultation.product.path}" target="_blank">${consultation.product.name}</a>
				</td>
			</tr>
			<tr>
				<th>
					${message("Consultation.member")}:
				</th>
				<td colspan="3">
					[#if consultation.member??]
						<a href="../member/view?id=${consultation.member.id}">${consultation.member.username}</a>
					[#else]
						${message("admin.consultation.anonymous")}
					[/#if]
				</td>
			</tr>
			<tr>
				<th>
					${message("Consultation.content")}:
				</th>
				<td colspan="3">
					${consultation.content}
				</td>
			</tr>
			<tr>
				<th>
					${message("Consultation.ip")}:
				</th>
				<td colspan="3">
					${consultation.ip}
				</td>
			</tr>
			[#if consultation.replyConsultations?has_content]
				<tr>
					<td colspan="4">
						&nbsp;
					</td>
				</tr>
				[#list consultation.replyConsultations as replyConsultation]
					<tr>
						<th>
							&nbsp;
						</th>
						<td>
							${replyConsultation.content}
						</td>
						<td width="80">
							<span title="${replyConsultation.createdDate?string("yyyy-MM-dd HH:mm:ss")}">${replyConsultation.createdDate}</span>
						</td>
					</tr>
				[/#list]
			[/#if]
			<tr>
				<th>
					${message("Consultation.isShow")}:
				</th>
				<td colspan="3">
					<input type="checkbox" name="isShow" value="true"[#if consultation.isShow] checked="checked"[/#if] />
				</td>
			</tr>
			<tr>
				<th>
					&nbsp;
				</th>
				<td colspan="3">
					<input type="submit" class="button" value="${message("admin.common.submit")}" />
					<input type="button" class="button" value="${message("admin.common.back")}" onclick="history.back(); return false;" />
				</td>
			</tr>
		</table>
	</form>
</body>
</html>