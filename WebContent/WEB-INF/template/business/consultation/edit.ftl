<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("business.consultation.edit")} </title>
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
	<script src="${base}/resources/business/js/velocity.js"></script>
	<script src="${base}/resources/business/js/velocity.ui.js"></script>
	<script src="${base}/resources/business/js/adminLTE.js"></script>
	<script src="${base}/resources/business/js/common.js"></script>
	<script type="text/javascript">
	$().ready(function() {
	
		var $delete = $("#consultationForm a.delete");
		
		[#if flashMessage?has_content]
			$.alert("${flashMessage}");
		[/#if]
		
		// 删除
		$delete.deleteItem({
			url: "${base}/business/consultation/delete_reply",
			data: function() {
				return {
					consultationId: $(this).data("id")
				};
			},
			removeElement: function() {
				return $(this).closest(".form-group");
			},
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
					<h1>${message("business.consultation.edit")}</h1>
					<ol class="breadcrumb">
						<li>
							<a href="/shop/business/index">
								<i class="fa fa-home"></i>
								${message("business.common.index")}
							</a>
						</li>
						<li class="active">${message("business.consultation.edit")}</li>
					</ol>
				</section>
				<section class="content">
					<div class="row">
						<div class="col-xs-12">
							<form id="consultationForm" class="form-horizontal" action="${base}/business/consultation/update" method="post">
								<input name="consultationId" type="hidden" value="${consultation.id}">
								<div class="box">
									<div class="box-body">
										<div class="row">
											<div class="col-xs-6">
												<dl class="items dl-horizontal">
													<dt>${message("Consultation.product")}:</dt>
													<dd>
														<a href="${base}${consultation.product.path}" target="_blank">${consultation.product.name}</a>
													</dd>
													<dt>${message("Consultation.member")}:</dt>
													<dd>
														[#if consultation.member??]
															${consultation.member.username}
														[#else]
															${message("business.consultation.anonymous")}
														[/#if]
													</dd>
													<dt>${message("Consultation.content")}:</dt>
													<dd>${consultation.content}</dd>
													<dt>${message("Consultation.ip")}:</dt>
													<dd>${consultation.ip}</dd>
												</dl>
											</div>
										</div>
										[#if consultation.replyConsultations?has_content]
											[#list consultation.replyConsultations as replyConsultation]
												<div class="form-group">
													<div class="col-xs-3 col-xs-offset-2">
														<p class="form-control-static">${replyConsultation.content}</p>
													</div>
													<div class="col-xs-1">
														<p class="form-control-static" title="${replyConsultation.createdDate?string("yyyy-MM-dd HH:mm:ss")}">${replyConsultation.createdDate}</p>
													</div>
													<div class="col-xs-1">
														<p class="form-control-static">
															<a class="delete" href="javascript:;" data-id="${replyConsultation.id}">[${message("business.common.delete")}]</a>
														</p>
													</div>
												</div>
											[/#list]
										[/#if]
										<div class="form-group">
											<label for="isShow" class="col-xs-2 control-label">${message("Consultation.isShow")}:</label>
											<div class="col-xs-10 checkbox">
												<input id="isShow" name="isShow" type="text" value="${consultation.isShow?string("true", "false")}" data-toggle="checkbox-x">
											</div>
										</div>
									</div>
									<div class="box-footer">
										<div class="row">
											<div class="col-xs-4 col-xs-offset-2">
												<button class="btn btn-primary" type="submit">${message("business.common.submit")}</button>
												<button class="btn btn-default" data-toggle="back">${message("business.common.back")}</button>
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