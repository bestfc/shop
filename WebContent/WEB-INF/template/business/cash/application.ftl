<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("business.cash.application")} </title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/business/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/business/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/business/css/animate.css" rel="stylesheet">
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
	
		var $cashForm = $("#cashForm");
		
		// 表单验证
		$cashForm.validate({
			rules: {
				amount: {
					required: true,
					positive: true,
					decimal: {
						integer: 12,
						fraction: ${setting.priceScale}
					},
					remote: {
						url: "${base}/business/cash/check_balance",
						cache: false
					}
				},
				bank: "required",
				account: "required"
			},
			messages: {
				amount: {
					remote: "${message("business.cash.notCurrentAccountBalance")}"
				}
			},
			submitHandler: function(form) {
				form.submit();
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
					<h1>${message("business.cash.application")}</h1>
					<ol class="breadcrumb">
						<li>
							<a href="/shop/business/index">
								<i class="fa fa-home"></i>
								${message("business.common.index")}
							</a>
						</li>
						<li class="active">${message("business.cash.application")}</li>
					</ol>
				</section>
				<section class="content">
					<div class="row">
						<div class="col-xs-12">
							<form id="cashForm" class="form-horizontal" action="${base}/business/cash/save" method="post">
								<div class="box">
									<div class="box-body">
										<div class="form-group">
											<label class="col-xs-2 control-label">${message("business.businessDeposit.balance")}:</label>
											<div class="col-xs-4">
												<p class="form-control-static">${currency(currentUser.balance, true, true)}</p>
											</div>
										</div>
										[#if currentUser.frozenFund > 0]
											<div class="form-group">
												<label class="col-xs-2 control-label">${message("Business.frozenFund")}:</label>
												<div class="col-xs-4">
													<p class="form-control-static">${currency(currentUser.frozenFund, true, true)}</p>
												</div>
											</div>
										[/#if]
										<div class="form-group">
											<label class="col-xs-2 control-label item-required" for="amount">${message("Cash.amount")}:</label>
											<div class="col-xs-4">
												<input id="amount" name="amount" class="form-control" type="text" maxlength="16">
											</div>
										</div>
										<div class="form-group">
											<label class="col-xs-2 control-label item-required" for="bank">${message("Cash.bank")}:</label>
											<div class="col-xs-4">
												<input id="bank" name="bank" class="form-control" type="text" maxlength="200">
											</div>
										</div>
										<div class="form-group">
											<label class="col-xs-2 control-label item-required" for="account">${message("Cash.account")}:</label>
											<div class="col-xs-4">
												<input id="account" name="account" class="form-control" type="text" maxlength="200">
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