<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("business.deliveryCenter.edit")} </title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/business/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/business/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/business/css/bootstrap-checkbox-x.css" rel="stylesheet">
	<link href="${base}/resources/business/css/animate.css" rel="stylesheet">
	<link href="${base}/resources/business/css/adminLTE.css" rel="stylesheet">
	<link href="${base}/resources/business/css/common.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/business/js/html5shiv.js"></script>
		<script src="${base}/resources/business/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/business/js/jquery.js"></script>
	<script src="${base}/resources/business/js/bootstrap.js"></script>
	<script src="${base}/resources/business/js/bootstrap-checkbox-x.js"></script>
	<script src="${base}/resources/business/js/jquery.validate.js"></script>
	<script src="${base}/resources/business/js/adminLTE.js"></script>
	<script src="${base}/resources/business/js/jquery.lSelect.js"></script>
	<script src="${base}/resources/business/js/common.js"></script>
	<script type="text/javascript">
	$().ready(function() {
	
		var $deliveryCenterForm = $("#deliveryCenterForm");
		var $areaId = $("input[name='areaId']");
		
		[#if flashMessage?has_content]
			$.alert("${flashMessage}");
		[/#if]
		
		// 地区选择
		$areaId.lSelect({
			url: "${base}/common/area"
		});
		
		// 表单验证
		$deliveryCenterForm.validate({
			rules: {
				name: "required",
				contact: "required",
				areaId: "required",
				address: "required",
				zipCode: {
					pattern: /^\d{6}$/
				},
				phone: {
					pattern: /^\d{3,4}-?\d{7,9}$/
				}
			}
		});
	
	});
	</script>
</head>
<body class="hold-transition sidebar-mini">
	<div class="wrapper">
		[#include "/business/include/main_header.ftl" /]
		[#include "/business/include/main_sidebar.ftl" /]
		<div class="content-wrapper">
			<div class="container-fluid">
				<section class="content-header">
					<h1>${message("business.deliveryCenter.edit")}</h1>
					<ol class="breadcrumb">
						<li>
							<a href="/shop/business/index">
								<i class="fa fa-home"></i>
								${message("business.common.index")}
							</a>
						</li>
						<li class="active">${message("business.deliveryCenter.edit")}</li>
					</ol>
				</section>
				<section class="content">
					<div class="row">
						<div class="col-xs-12">
							<form id="deliveryCenterForm" class="form-horizontal" action="${base}/business/delivery_center/update" method="post">
								<input name="deliveryCenterId" type="hidden" value="${deliveryCenter.id}">
								<div class="box">
									<div class="box-body">
										<div class="form-group">
											<label class="col-xs-2 control-label item-required" for="name">${message("DeliveryCenter.name")}:</label>
											<div class="col-xs-4">
												<input id="name" name="name" class="form-control" type="text" value="${deliveryCenter.name}" maxlength="200">
											</div>
										</div>
										<div class="form-group">
											<label class="col-xs-2 control-label item-required" for="contact">${message("DeliveryCenter.contact")}:</label>
											<div class="col-xs-4">
												<input id="contact" name="contact" class="form-control" type="text" value="${deliveryCenter.contact}" maxlength="200">
											</div>
										</div>
										<div class="form-group">
											<label class="col-xs-2 control-label item-required">${message("DeliveryCenter.area")}:</label>
											<div class="col-xs-4">
												<input name="areaId" type="hidden" value="${(deliveryCenter.area.id)!}" treePath="${(deliveryCenter.area.treePath)!}">
											</div>
										</div>
										<div class="form-group">
											<label class="col-xs-2 control-label item-required" for="address">${message("DeliveryCenter.address")}:</label>
											<div class="col-xs-4">
												<input id="address" name="address" class="form-control" type="text" value="${deliveryCenter.address}" maxlength="200">
											</div>
										</div>
										<div class="form-group">
											<label class="col-xs-2 control-label" for="zipCode">${message("DeliveryCenter.zipCode")}:</label>
											<div class="col-xs-4">
												<input id="zipCode" name="zipCode" class="form-control" type="text" value="${deliveryCenter.zipCode}" maxlength="200">
											</div>
										</div>
										<div class="form-group">
											<label class="col-xs-2 control-label" for="phone">${message("DeliveryCenter.phone")}:</label>
											<div class="col-xs-4">
												<input id="phone" name="phone" class="form-control" type="text" value="${deliveryCenter.phone}" maxlength="200">
											</div>
										</div>
										<div class="form-group">
											<label class="col-xs-2 control-label" for="mobile">${message("DeliveryCenter.mobile")}:</label>
											<div class="col-xs-4">
												<input id="mobile" name="mobile" class="form-control" type="text" value="${deliveryCenter.mobile}" maxlength="200">
											</div>
										</div>
										<div class="form-group">
											<label for="isDefault" class="col-xs-2 control-label">${message("DeliveryCenter.isDefault")}:</label>
											<div class="col-xs-10 checkbox">
												<input id="isDefault" name="isDefault" type="text" value="${deliveryCenter.isDefault?string("true", "false")}" data-toggle="checkbox-x">
											</div>
										</div>
										<div class="form-group">
											<label class="col-xs-2 control-label" for="memo">${message("DeliveryCenter.memo")}:</label>
											<div class="col-xs-4">
												<input id="memo" name="memo" class="form-control" type="text" value="${deliveryCenter.memo}" maxlength="200">
											</div>
										</div>
									</div>
									<div class="box-footer">
										<div class="row">
											<div class="col-xs-4 col-xs-offset-2">
												<button class="btn btn-primary" type="submit">${message("business.common.submit")}</button>
												<button class="btn btn-default" type="button" data-toggle="back">${message("business.common.back")}</button>
											</div>
										</div>
									</div>
								</div>
							</form>
						</div>
					</div>
				</section>
			</div>
		</div>
		[#include "/business/include/main_footer.ftl" /]
	</div>
</body>
</html>