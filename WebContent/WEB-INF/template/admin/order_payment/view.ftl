<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("admin.orderPayment.view")} </title>
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
		<a href="${base}/admin/index">${message("admin.breadcrumb.home")}</a> &raquo; ${message("admin.orderPayment.view")}
	</div>
	<table class="input">
		<tr>
			<th>
				${message("OrderPayment.sn")}:
			</th>
			<td>
				${orderPayment.sn}
			</td>
			<th>
				${message("admin.common.createdDate")}:
			</th>
			<td>
				${orderPayment.createdDate?string("yyyy-MM-dd HH:mm:ss")}
			</td>
		</tr>
		<tr>
			<th>
				${message("OrderPayment.method")}:
			</th>
			<td>
				${message("OrderPayment.Method." + orderPayment.method)}
			</td>
			<th>
				${message("OrderPayment.paymentMethod")}:
			</th>
			<td>
				${orderPayment.paymentMethod!"-"}
			</td>
		</tr>
		<tr>
			<th>
				${message("OrderPayment.bank")}:
			</th>
			<td>
				${orderPayment.bank!"-"}
			</td>
			<th>
				${message("OrderPayment.account")}:
			</th>
			<td>
				${orderPayment.account!"-"}
			</td>
		</tr>
		<tr>
			<th>
				${message("OrderPayment.amount")}:
			</th>
			<td>
				${currency(orderPayment.amount, true)}
				[#if orderPayment.fee > 0]
					<span class="silver">${message("OrderPayment.fee")}: (${currency(orderPayment.fee, true)})</span>
				[/#if]
			</td>
			<th>
				${message("OrderPayment.payer")}:
			</th>
			<td>
				${orderPayment.payer!"-"}
			</td>
		</tr>
		<tr>
			<th>
				${message("OrderPayment.order")}:
			</th>
			<td>
				${orderPayment.order.sn}
			</td>
		</tr>
		<tr>
			<th>
				${message("OrderPayment.memo")}:
			</th>
			<td colspan="3">
				${orderPayment.memo!"-"}
			</td>
		</tr>
		<tr>
			<th>
				&nbsp;
			</th>
			<td colspan="3">
				<input type="button" class="button" value="${message("admin.common.back")}" onclick="history.back(); return false;" />
			</td>
		</tr>
	</table>
</body>
</html>