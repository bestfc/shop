<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("business.stock.stockOut")} </title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/business/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/business/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/business/css/bootstrap-select.css" rel="stylesheet">
	<link href="${base}/resources/business/css/ajax-bootstrap-select.css" rel="stylesheet">
	<link href="${base}/resources/business/css/animate.css" rel="stylesheet">
	<link href="${base}/resources/business/css/adminLTE.css" rel="stylesheet">
	<link href="${base}/resources/business/css/common.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/business/js/html5shiv.js"></script>
		<script src="${base}/resources/business/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/business/js/jquery.js"></script>
	<script src="${base}/resources/business/js/bootstrap.js"></script>
	<script src="${base}/resources/business/js/bootstrap-select.js"></script>
	<script src="${base}/resources/business/js/ajax-bootstrap-select.js"></script>
	<script src="${base}/resources/business/js/velocity.js"></script>
	<script src="${base}/resources/business/js/velocity.ui.js"></script>
	<script src="${base}/resources/business/js/jquery.validate.js"></script>
	<script src="${base}/resources/business/js/adminLTE.js"></script>
	<script src="${base}/resources/business/js/common.js"></script>
	<script type="text/javascript">
		$().ready(function() {
		
			var $stockForm = $("#stockForm");
			var $skuSelect = $(".sku-select");
			var $stock = $("#stock");
			var $quantity = $("#quantity");
			
			[#if flashMessage?has_content]
				$.alert("${flashMessage}");
			[/#if]
			
			// SKU
			$skuSelect.selectpicker({
				liveSearch: true
			}).ajaxSelectPicker({
				ajax: {
					url: "${base}/business/stock/sku_select",
					type: "GET",
					data: function () {
						return {
							keyword: "{{{q}}}"
						};
					},
					dataType: "json"
				},
				preprocessData: function(data) {
					return $.map(data, function(item) {
						return {
							value: item.sn,
							text: item.name,
							data: {
								subtext: item.specifications.length > 0 ? '<span class="gray-darker">' + escapeHtml(item.specifications.join(",")) + '</span>' : null,
								stock: item.stock
							},
							disabled: false
						};
					});
				},
				preserveSelected: false
			});
			
			[#if sku?has_content]
				showStock();
			[/#if]
			
			// 库存
			$skuSelect.change(function() {
				$quantity.val("");
				showStock();
			})
			
			function showStock() {
				var value = $skuSelect.selectpicker("val");
				var stock = $skuSelect.find("option:selected").data("stock");
				if(value != "") {
					$stock.velocity("slideDown").find("p").text(stock);
				}
			}
			
			// 表单验证
			$stockForm.validate({
				rules: {
					quantity: {
						required: true,
						integer: true,
						min: 1
					}
				},
				submitHandler: function(form) {
					var value = $skuSelect.selectpicker("val");
					var stock = parseInt($stock.find("p").text());
					var quantity = parseInt($quantity.val());
					if (value == "") {
						$.alert("${message("business.stock.skuRequired")}");
						return false;
					}
					if (stock != null && stockquantity < 0) {
						$.alert("${message("business.stock.insufficientStock")}");
						return false;
					}
					$(form).find("button:submit").prop("disabled", true);
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
					<h1>${message("business.stock.stockOut")}</h1>
					<ol class="breadcrumb">
						<li>
							<a href="/shop/business/index">
								<i class="fa fa-home"></i>
								${message("business.common.index")}
							</a>
						</li>
						<li class="active">${message("business.stock.stockOut")}</li>
					</ol>
				</section>
				<section class="content">
					<div class="row">
						<div class="col-xs-12">
							<form id="stockForm" class="form-horizontal" action="${base}/business/stock/stock_out" method="post">
								<div class="box">
									<div class="box-body">
										<div class="form-group">
											<label class="col-xs-2 control-label">${message("business.stock.skuSelect")}:</label>
											<div class="col-xs-4">
												<select name="skuSn" class="sku-select form-control" title="${message("business.stock.skuSelectTitle")}">
													[#if sku??]
														<option value="${sku.sn}" selected>${sku.name}</option>
													[/#if]
												</select>
											</div>
										</div>
										<div id="stock" class="form-group hidden-element">
											<label class="col-xs-2 control-label">${message("Sku.stock")}:</label>
											<div class="col-xs-4">
												<p class="form-control-static">${(sku.stock)!}</p>
											</div>
										</div>
										<div class="form-group">
											<label class="col-xs-2 control-label item-required" for="quantity">${message("business.stock.stockOutQuantity")}:</label>
											<div class="col-xs-4">
												<input id="quantity" name="quantity" class="form-control" type="text" maxlength="9">
											</div>
										</div>
										<div class="form-group">
											<label class="col-xs-2 control-label" for="memo">${message("business.stock.memo")}:</label>
											<div class="col-xs-4">
												<input id="memo" name="memo" class="form-control" type="text" maxlength="200">
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