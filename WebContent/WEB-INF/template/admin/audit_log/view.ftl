<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html;charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("admin.auditLog.view")} </title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/input.js"></script><style type="text/css">
.parameters strong {
	margin-right: 10px;
	font-weight: bold;
}
</style>
</head>
<body>
	<div class="breadcrumb">
		${message("admin.auditLog.view")}
	</div>
	<table class="input">
		<tr>
			<th>
				${message("AuditLog.action")}:
			</th>
			<td>
				${auditLog.action}
			</td>
		</tr>
		<tr>
			<th>
				${message("AuditLog.detail")}:
			</th>
			<td>
				${auditLog.detail}
			</td>
		</tr>
		<tr>
			<th>
				${message("AuditLog.ip")}:
			</th>
			<td>
				${auditLog.ip}
			</td>
		</tr>
		<tr>
			<th>
				${message("AuditLog.requestUrl")}:
			</th>
			<td>
				${auditLog.requestUrl}
			</td>
		</tr>
		<tr>
			<th>
				${message("AuditLog.parameters")}:
			</th>
			<td>
				[#if auditLog.parameters?has_content]
					<ul class="parameters">
						[#list auditLog.parameters.entrySet() as entry]
							<li>
								<strong>${entry.key}</strong>${entry.value?join(", ")}
							</li>
						[/#list]
					</ul>
				[/#if]
			</td>
		</tr>
		<tr>
			<th>
				${message("AuditLog.user")}:
			</th>
			<td>
				[#if auditLog.user??]
					${auditLog.user.displayName}
				[/#if]
			</td>
		</tr>
		<tr>
			<th>
				${message("admin.common.createdDate")}:
			</th>
			<td>
				${auditLog.createdDate?string("yyyy-MM-dd HH:mm:ss")}
			</td>
		</tr>
		<tr>
			<th>
				&nbsp;
			</th>
			<td>
				<input type="button" class="button" value="${message("admin.common.back")}" onclick="history.back(); return false;" />
			</td>
		</tr>
	</table>
</body>
</html>