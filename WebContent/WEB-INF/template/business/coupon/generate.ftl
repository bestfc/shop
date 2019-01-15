<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("business.coupon.generate")} </title>
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
	
		var $couponForm = $("#couponForm");
		var $totalCount = $(".totalCount");
		var $count = $("#count");
		var totalCount = ${totalCount};
		
		// 表单验证
		$couponForm.validate({
			rules: {
				count: {
					required: true,
					integer: true,
					min: 1
				}
			},
			submitHandler: function(form) {
				totalCount = totalCount + parseInt($count.val());
				$totalCount.text(totalCount);
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
					<h1>${message("business.coupon.generate")}</h1>
					<ol class="breadcrumb">
						<li>
							<a href="/shop/business/index">
								<i class="fa fa-home"></i>
								${message("business.common.index")}
							</a>
						</li>
						<li class="active">${message("business.coupon.generate")}</li>
					</ol>
				</section>
				<section class="content">
					<div class="row">
						<div class="col-xs-12">
							<form id="couponForm" class="form-horizontal" action="${base}/business/coupon/download" method="post">
								<input name="couponId" type="hidden" value="${coupon.id}">
								<div class="box">
									<div class="box-body">
										<div class="row">
											<div class="col-xs-6">
												<dl class="items dl-horizontal">
													<dt>${message("Coupon.name")}:</dt>
													<dd>${coupon.name}</dd>
													<dt>${message("Coupon.beginDate")}:</dt>
													<dd>[#if coupon.beginDate??] ${coupon.beginDate?string("yyyy-MM-dd")}[#else] -[/#if]</dd>
													<dt>${message("Coupon.endDate")}:</dt>
													<dd>[#if coupon.endDate??] ${coupon.endDate?string("yyyy-MM-dd")}[#else] -[/#if]</dd>
													<dt>${message("business.coupon.totalCount")}:</dt>
													<dd class="totalCount">${totalCount}</dd>
													<dt>${message("business.coupon.usedCount")}:</dt>
													<dd>${usedCount}</dd>
												</dl>
											</div>
										</div>
										<div class="form-group">
											<label class="col-xs-2 control-label item-required" for="count">${message("business.coupon.count")}:</label>
											<div class="col-xs-4">
												<input id="count" name="count" class="form-control" type="text" value="100" maxlength="9">
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
				</div>
			</section>
		</div>
		[#include "/business/include/main_footer.ftl" /]
	</div>
</body>
</html>