<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("business.print.delivery")} </title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/business/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/business/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/business/css/bootstrap-select.css" rel="stylesheet">
	<link href="${base}/resources/business/css/adminLTE.css" rel="stylesheet">
	<link href="${base}/resources/business/css/common.css" rel="stylesheet">
	<link href="${base}/resources/business/css/print.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/business/js/html5shiv.js"></script>
		<script src="${base}/resources/business/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/business/js/jquery.js"></script>
	<script src="${base}/resources/business/js/bootstrap.js"></script>
	<script src="${base}/resources/business/js/bootstrap-select.js"></script>
	<script src="${base}/resources/business/js/adminLTE.js"></script>
	<script src="${base}/resources/business/js/common.js"></script>
	[#if deliveryTemplate??]
		<style type="text/css">
			main {
				[#if deliveryTemplate.width??]
					width: ${deliveryTemplate.width}px;
				[/#if]
				[#if deliveryTemplate.height??]
					height: ${deliveryTemplate.height}px;
				[/#if]
				[#if deliveryTemplate.background??]
					background: url(${deliveryTemplate.background}) 0px 0px no-repeat;
				[/#if]
			}
		</style>
		<style type="text/css" media="print">
			main {
				[#if deliveryTemplate.offsetX??]
					margin-left: ${deliveryTemplate.offsetX}px;
				[/#if]
				[#if deliveryTemplate.offsetY??]
					margin-top: ${deliveryTemplate.offsetY}px;
				[/#if]
				background: none;
			}
		</style>
	[/#if]
	<script type="text/javascript">
	$().ready(function() {
		
		var $printForm = $("#printForm");
		var $print = $("#print");
		var $deliveryTemplate = $("#deliveryTemplate");
		var $deliveryCenter = $("#deliveryCenter");
		
		[#if flashMessage?has_content]
			$.alert("${flashMessage}");
		[/#if]
		
		$deliveryTemplate.add($deliveryCenter).change(function() {
			if ($deliveryTemplate.val() != "" && $deliveryCenter.val() != "") {
				$printForm.submit();
			}
		});
		
		// 打印
		$print.click(function() {
			if ($deliveryTemplate.val() == "") {
				$.alert("${message("business.print.deliveryTemplateRequired")}");
				return false;
			}
			if ($deliveryCenter.val() == "") {
				$.alert("${message("business.print.deliveryCenterRequired")}");
				return false;
			}
			window.print();
		});
	
	});
	</script>
</head>
<body class="print">
	<form id="printForm" class="form-inline" action="${base}/business/print/delivery" method="get">
		<input name="orderId" type="hidden" value="${order.id}">
		<div class="bar hidden-print">
			<div class="form-group">
				<button id="print" class="btn btn-default" type="button">
					<i class="fa fa-print"></i>
					${message("business.print.print")}
				</button>
			</div>
			<div class="form-group">
				<label>${message("business.print.deliveryTemplate")}</label>
				<select id="deliveryTemplate" name="deliveryTemplateId" class="selectpicker" data-size="5">
					<option value="">${message("business.common.choose")}</option>
					[#list deliveryTemplates as value]
						<option value="${value.id}"[#if value == deliveryTemplate] selected[/#if]>${value.name}</option>
					[/#list]
				</select>
			</div>
			<div class="form-group">
				<label>${message("business.print.deliveryCenter")}:</label>
				<select id="deliveryCenter" name="deliveryCenterId" class="selectpicker" data-size="5">
					<option value="">${message("business.common.choose")}</option>
					[#list deliveryCenters as value]
						<option value="${value.id}"[#if value == deliveryCenter] selected[/#if]>${value.name}</option>
					[/#list]
				</select>
			</div>
		</div>
		[#if deliveryTemplate?? && deliveryCenter??]
			[#noautoesc]
				<main>${content}</main>
			[/#noautoesc]
		[/#if]
	</form>
</body>
</html>