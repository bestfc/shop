<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("business.review.edit")} </title>
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
	<script src="${base}/resources/business/js/velocity.js"></script>
	<script src="${base}/resources/business/js/velocity.ui.js"></script>
	<script src="${base}/resources/business/js/adminLTE.js"></script>
	<script src="${base}/resources/business/js/common.js"></script>
	<script type="text/javascript">
	$().ready(function() {
	
		var $delete = $("#reviewForm a.delete");
		
		[#if flashMessage?has_content]
			$.alert("${flashMessage}");
		[/#if]
		
		// 删除
		$delete.deleteItem({
			url: "${base}/business/review/delete_reply",
			data: function() {
				return {
					reviewId: $(this).data("id")
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
					<h1>${message("business.review.edit")}</h1>
					<ol class="breadcrumb">
						<li>
							<a href="/shop/business/index">
								<i class="fa fa-home"></i>
								${message("business.common.index")}
							</a>
						</li>
						<li class="active">${message("business.review.edit")}</li>
					</ol>
				</section>
				<section class="content">
					<div class="row">
						<div class="col-xs-12">
							<form id="reviewForm" class="form-horizontal" action="${base}/business/review/update" method="post">
								<input name="reviewId" type="hidden" value="${deliveryCenter.id}">
								<div class="box">
									<div class="box-body">
										<div class="row">
											<div class="col-xs-6">
												<dl class="items dl-horizontal clearfix">
													<dt>${message("Review.product")}:</dt>
													<dd>
														<a href="${base}${review.product.path}" target="_blank">${review.product.name}</a>
													</dd>
													<dt>${message("Review.member")}:</dt>
													<dd>
														[#if review.member??]
															${review.member.username}
														[#else]
															${message("business.review.anonymous")}
														[/#if]
													</dd>
													<dt>${message("Review.ip")}:</dt>
													<dd>${review.ip}</dd>
													<dt>${message("Review.score")}:</dt>
													<dd>${review.score}</dd>
													<dt>${message("Review.content")}:</dt>
													<dd>${review.content}</dd>
												</dl>
											</div>
										</div>
										[#if review.replyReviews?has_content]
											[#list review.replyReviews as replyReview]
												<div class="form-group">
													<div class="col-xs-3 col-xs-offset-2">
														<p class="form-control-static">${replyReview.content}</p>
													</div>
													<div class="col-xs-1">
														<p class="form-control-static" title="${replyReview.createdDate?string("yyyy-MM-dd HH:mm:ss")}">${replyReview.createdDate}</p>
													</div>
													<div class="col-xs-1">
														<p class="form-control-static">
															<a class="delete" href="javascript:;" data-id="${replyReview.id}">[${message("business.common.delete")}]</a>
														</p>
													</div>
												</div>
											[/#list]
										[/#if]
									</div>
									<div class="box-footer">
										<div class="form-group">
											<div class="col-xs-offset-2 col-xs-4">
												<button class="btn btn-default" data-toggle="back">${message("business.common.back")}</button>
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