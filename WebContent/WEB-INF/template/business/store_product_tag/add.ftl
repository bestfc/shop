<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("business.storeProductTag.add")} </title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/business/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/business/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/business/css/bootstrap-checkbox-x.css" rel="stylesheet">
	<link href="${base}/resources/business/css/bootstrap-fileinput.css" rel="stylesheet">
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
	<script src="${base}/resources/business/js/bootstrap-fileinput.js"></script>
	<script src="${base}/resources/business/js/jquery.validate.js"></script>
	<script src="${base}/resources/business/js/adminLTE.js"></script>
	<script src="${base}/resources/business/js/common.js"></script>
	<script type="text/javascript">
	$().ready(function() {
		
		var $storeProductTagForm = $("#storeProductTagForm");
		
		[#if flashMessage?has_content]
			$.alert("${flashMessage}");
		[/#if]
		
		// 表单验证
		$storeProductTagForm.validate({
			rules: {
				name: "required",
				order: "digits"
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
					<h1>${message("business.storeProductTag.add")}</h1>
					<ol class="breadcrumb">
						<li>
							<a href="/shop/business/index">
								<i class="fa fa-home"></i>
								${message("business.common.index")}
							</a>
						</li>
						<li class="active">${message("business.storeProductTag.add")}</li>
					</ol>
				</section>
				<section class="content">
					<div class="row">
						<div class="col-xs-12">
							<form id="storeProductTagForm" class="form-horizontal" action="${base}/business/store_product_tag/save" method="post">
								<div class="box">
									<div class="box-body">
										<div class="form-group">
											<label class="col-xs-2 control-label item-required" for="name">${message("StoreProductTag.name")}:</label>
											<div class="col-xs-4">
												<input id="name" name="name" class="form-control" type="text" maxlength="200">
											</div>
										</div>
										<div class="form-group">
											<label class="col-xs-2 control-label">${message("StoreProductTag.icon")}:</label>
											<div class="col-xs-4">
												<input name="icon" type="hidden" data-provide="fileinput" data-file-type="image">
											</div>
										</div>
										<div class="form-group">
											<label for="isEnabled" class="col-xs-2 control-label">${message("StoreProductTag.isEnabled")}:</label>
											<div class="col-xs-10 checkbox">
												<input id="isEnabled" name="isEnabled" type="text" value="true" data-toggle="checkbox-x">
											</div>
										</div>
										<div class="form-group">
											<label class="col-xs-2 control-label" for="memo">${message("StoreProductTag.memo")}:</label>
											<div class="col-xs-4">
												<input id="memo" name="memo" class="form-control" type="text" maxlength="200">
											</div>
										</div>
										<div class="form-group">
											<label class="col-xs-2 control-label" for="order">${message("business.common.order")}:</label>
											<div class="col-xs-4">
												<input id="order" name="order" class="form-control" type="text" maxlength="9">
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