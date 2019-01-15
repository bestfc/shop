<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("business.store.setting")} </title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/business/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/business/css/font-awesome.css" rel="stylesheet">
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
	<script src="${base}/resources/business/js/velocity.js"></script>
	<script src="${base}/resources/business/js/velocity.ui.js"></script>
	<script src="${base}/resources/business/js/bootstrap-fileinput.js"></script>
	<script src="${base}/resources/business/js/jquery.validate.js"></script>
	<script src="${base}/resources/business/js/adminLTE.js"></script>
	<script src="${base}/resources/business/js/underscore.js"></script>
	<script src="${base}/resources/business/js/common.js"></script>
	<script type="text/javascript">
	$().ready(function() {
		
		var $storeForm = $("#storeForm");
		
		[#if flashMessage?has_content]
			$.alert("${flashMessage}");
		[/#if]
		
		// 表单验证
		$storeForm.validate({
			rules: {
				name: {
					required: true,
					remote: {
						url: "${base}/business/store/check_name?id=${currentStore.id}",
						cache: false
					}
				},
				email: {
					required: true,
					email: true
				},
				mobile: {
					required: true,
					pattern: /^1[3|4|5|7|8]\d{9}$/
				}
			},
			messages: {
				name: {
					remote: "${message("common.validate.exist")}"
				},
				mobile: {
					pattern: "${message("common.validate.pattern")}"
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
					<h1>${message("business.store.setting")}</h1>
					<ol class="breadcrumb">
						<li>
							<a href="/shop/business/index">
								<i class="fa fa-home"></i>
								${message("business.common.index")}
							</a>
						</li>
						<li class="active">${message("business.store.setting")}</li>
					</ol>
				</section>
				<section class="content">
					<div class="row">
						<div class="col-xs-12">
							<form id="storeForm" class="form-horizontal" action="${base}/business/store/setting" method="post">
								<div class="box">
									<div class="box-body">
										<div class="form-group">
											<label class="col-xs-2 control-label item-required" for="name">${message("Store.name")}:</label>
											<div class="col-xs-4">
												<input id="name" name="name" class="form-control" type="text" value="${currentStore.name}" maxlength="200">
											</div>
										</div>
										<div class="form-group">
											<label class="col-xs-2 control-label">${message("Store.storeRank")}:</label>
											<div class="col-xs-4">
												<p class="form-control-static">${currentStore.storeRank.name}</p>
											</div>
										</div>
										<div class="form-group">
											<label class="col-xs-2 control-label">${message("Store.logo")}:</label>
											<div class="col-xs-4">
												<input name="logo" type="hidden" value="${currentStore.logo}" data-provide="fileinput" data-file-type="image">
											</div>
										</div>
										<div class="form-group">
											<label class="col-xs-2 control-label item-required" for="email">${message("Store.email")}:</label>
											<div class="col-xs-4">
												<input id="email" name="email" class="form-control" type="text" value="${currentStore.email}" maxlength="200">
											</div>
										</div>
										<div class="form-group">
											<label class="col-xs-2 control-label item-required" for="mobile">${message("Store.mobile")}:</label>
											<div class="col-xs-4">
												<input id="mobile" name="mobile" class="form-control" type="text" value="${currentStore.mobile}" maxlength="16">
											</div>
										</div>
										<div class="form-group">
											<label class="col-xs-2 control-label" for="phone">${message("Store.phone")}:</label>
											<div class="col-xs-4">
												<input id="phone" name="phone" class="form-control" type="text" value="${currentStore.phone}" maxlength="200">
											</div>
										</div>
										<div class="form-group">
											<label class="col-xs-2 control-label" for="address">${message("Store.address")}:</label>
											<div class="col-xs-4">
												<input id="address" name="address" class="form-control" type="text" value="${currentStore.address}" maxlength="200">
											</div>
										</div>
										<div class="form-group">
											<label class="col-xs-2 control-label" for="zipCode">${message("Store.zipCode")}:</label>
											<div class="col-xs-4">
												<input id="zipCode" name="zipCode" class="form-control" type="text" value="${currentStore.zipCode}" maxlength="200">
											</div>
										</div>
										<div class="form-group">
											<label class="col-xs-2 control-label" for="introduction">${message("Store.introduction")}:</label>
											<div class="col-xs-4">
												<textarea id="introduction" name="introduction" class="form-control" maxlength="200">${currentStore.introduction}</textarea>
											</div>
										</div>
										<div class="form-group">
											<label class="col-xs-2 control-label" for="keyword">${message("Store.keyword")}:</label>
											<div class="col-xs-4">
												<input id="keyword" name="keyword" class="form-control" type="text" value="${currentStore.keyword}" maxlength="200" title="${message("business.store.keywordTitle")}">
											</div>
										</div>
										[#if currentStore.productCategories?has_content]
											<div class="form-group">
												<label class="col-xs-2 control-label">${message("Store.productCategories")}:</label>
												<div class="col-xs-4">
													<table class="table table-hover">
														<thead>
															<tr>
																<th>${message("ProductCategory.name")}</th>
																<th>${message("ProductCategory.generalRate")}</th>
															</tr>
														</thead>
														<tbody>
															[#list currentStore.productCategories as productCategory]
																<tr>
																	<td>${productCategory.name}</td>
																	<td>${productCategory.generalRate}</td>
																</tr>
															[/#list]
														</tbody>
													</table>
												</div>
											</div>
										[/#if]
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