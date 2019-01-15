<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("business.print.shipping")} </title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/business/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/business/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/business/css/adminLTE.css" rel="stylesheet">
	<link href="${base}/resources/business/css/common.css" rel="stylesheet">
	<link href="${base}/resources/business/css/print.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/business/js/html5shiv.js"></script>
		<script src="${base}/resources/business/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/business/js/jquery.js"></script>
	<script src="${base}/resources/business/js/bootstrap.js"></script>
	<script type="text/javascript">
	$().ready(function() {
		
		var $print = $("#print");
		
		// 打印
		$print.click(function() {
			window.print();
		});
	
	});
	</script>
</head>
<body class="print">
	<div class="bar hidden-print">
		<button id="print" class="btn btn-default" type="button">
			<i class="fa fa-print"></i>
			${message("business.print.print")}
		</button>
	</div>
	<main>
		<table class="table table-bordered">
			<tr>
				<td>
					<img src="${setting.logo}" alt="${setting.siteName}">
				</td>
				<td>
					<p>${setting.siteName}</p>
					<p>${setting.siteUrl}</p>
				</td>
				<td style="vertical-align: middle;">${message("Order.member")}: ${order.member.username}</td>
			</tr>
			<tr>
				<td>${message("Order.sn")}: ${order.sn}</td>
				<td>${message("business.common.createdDate")}: ${order.createdDate?string("yyyy-MM-dd")}</td>
				<td>${message("business.print.printDate")}: ${.now?string("yyyy-MM-dd")}</td>
			</tr>
			[#if order.isDelivery]
				<tr>
					<td>${message("Order.consignee")}: ${order.consignee}</td>
					<td>${message("Order.zipCode")}: ${order.zipCode}</td>
					<td>${message("Order.phone")}: ${order.phone}</td>
				</tr>
				<tr>
					<td colspan="3">${message("Order.address")}: ${order.areaName}${order.address}</td>
				</tr>
			[/#if]
		</table>
		<table class="table table-bordered">
			<thead>
				<th>${message("business.print.number")}</th>
				<th>${message("OrderItem.sn")}</th>
				<th>${message("OrderItem.name")}</th>
				<th>${message("OrderItem.quantity")}</th>
			</thead>
			<tbody>
				[#list order.orderItems as orderItem]
					<tr>
						<td>${orderItem_index + 1}</td>
						<td>${orderItem.sn}</td>
						<td>
							${abbreviate(orderItem.name, 50, "...")}
							[#if orderItem.specifications?has_content]
								<span class="gray-darker">[${orderItem.specifications?join(", ")}]</span>
							[/#if]
							[#if orderItem.type != "general"]
								<span class="text-red">[${message("Product.Type." + orderItem.type)}]</span>
							[/#if]
						</td>
						<td>${orderItem.quantity}</td>
					</tr>
				[/#list]
			</tbody>
		</table>
		<div class="text-right">Powered By shopxx.net</div>
	</main>
</body>
</html>