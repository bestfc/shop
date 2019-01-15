<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("business.password.edit")} </title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/business/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/business/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/business/css/adminLTE.css" rel="stylesheet">
	<link href="${base}/resources/business/css/common.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/business/js/html5shiv.js"></script>
		<script src="${base}/resources/business/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/business/js/jquery.js"></script>
	<script src="${base}/resources/business/js/bootstrap.js"></script>
	<script src="${base}/resources/business/js/jquery.validate.js"></script>
	<script src="${base}/resources/business/js/adminLTE.js"></script>
	<script src="${base}/resources/business/js/common.js"></script>
	<script type="text/javascript">
	$().ready(function() {
		
		var $passwordForm = $("#passwordForm");
		
		[#if flashMessage?has_content]
			$.alert("${flashMessage}");
		[/#if]
		
		$.validator.addMethod("notAllowBlank",
			function(value, element) {
				return this.optional(element) || /^\S*$/.test(value);
			},
			"${message("common.validate.illegal")}"
		);
		
		// 表单验证
		$passwordForm.validate({
			rules: {
				currentPassword: {
					required: true,
					remote: {
						url: "${base}/business/password/check_current_password",
						cache: false
					}
				},
				password: {
					required: true,
					notAllowBlank: true,
					minlength: 4
				},
				rePassword: {
					required: true,
					notAllowBlank: true,
					equalTo: "#password"
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
					<h1>${message("business.password.edit")}</h1>
					<ol class="breadcrumb">
						<li>
							<a href="/shop/business/index">
								<i class="fa fa-home"></i>
								${message("business.common.index")}
							</a>
						</li>
						<li class="active">${message("business.password.edit")}</li>
					</ol>
				</section>
				<section class="content">
					<div class="row">
						<div class="col-xs-12">
							<form id="passwordForm" class="form-horizontal" action="${base}/business/password/update" method="post">
								<div class="box">
									<div class="box-body">
										<div class="form-group">
											<label class="col-xs-2 control-label item-required" for="currentPassword">${message("business.password.currentPassword")}:</label>
											<div class="col-xs-4">
												<input id="currentPassword" name="currentPassword" class="form-control" type="password" maxlength="200" autocomplete="off">
											</div>
										</div>
										<div class="form-group">
											<label class="col-xs-2 control-label item-required" for="password">${message("business.password.password")}:</label>
											<div class="col-xs-4">
												<input id="password" name="password" class="form-control" type="password" maxlength="20" autocomplete="off">
											</div>
										</div>
										<div class="form-group">
											<label class="col-xs-2 control-label item-required" for="rePassword">${message("business.password.rePassword")}:</label>
											<div class="col-xs-4">
												<input id="rePassword" name="rePassword" class="form-control" type="password" maxlength="20" autocomplete="off">
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