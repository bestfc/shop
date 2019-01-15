<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${product.name} ${message("shop.consultation.title")}[#if showPowered] [/#if]</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/mobile/shop/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/animate.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/common.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/consultation.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/mobile/shop/js/html5shiv.js"></script>
		<script src="${base}/resources/mobile/shop/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/mobile/shop/js/jquery.js"></script>
	<script src="${base}/resources/mobile/shop/js/bootstrap.js"></script>
	<script src="${base}/resources/mobile/shop/js/jquery.validate.js"></script>
	<script src="${base}/resources/mobile/shop/js/underscore.js"></script>
	<script src="${base}/resources/mobile/shop/js/common.js"></script>
	<script type="text/javascript">
	$().ready(function() {
		
		var $consultationForm = $("#consultationForm");
		var $captcha = $("#captcha");
		var $submit = $("button:submit");
		
		// 验证码图片
		$captcha.captchaImage();
		
		// 表单验证
		$consultationForm.validate({
			rules: {
				content: {
					required: true,
					maxlength: 200
				},
				captcha: "required"
			},
			submitHandler: function(form) {
				$.ajax({
					url: $consultationForm.attr("action"),
					type: "POST",
					data: $consultationForm.serialize(),
					dataType: "json",
					beforeSend: function() {
						$submit.prop("disabled", true);
					},
					success: function() {
						setTimeout(function() {
							location.href = "${base}/product/detail/${product.id}#consultation";
						}, 3000);
					},
					error: function(xhr, textStatus, errorThrown) {
						$captcha.captchaImage("refresh", true);
					},
					complete: function() {
						$submit.prop("disabled", false);
					}
				});
			}
		});
	
	});
	</script>
</head>
<body class="add-consultation">
	<header class="header-fixed">
		<a class="pull-left" href="${base}/product/detail/${product.id}#consultation">
			<span class="glyphicon glyphicon-menu-left"></span>
		</a>
		${message("shop.consultation.title")}
	</header>
	<main>
		<div class="media">
			<div class="media-left">
				<a href="${base}${product.path}">
					<img src="${product.thumbnail!setting.defaultThumbnailProductImage}" alt="${product.name}">
				</a>
			</div>
			<div class="media-body">
				<h4 class="media-heading">${abbreviate(product.name, 30, "...")}</h4>
				<span>
					${message("Product.price")}:
					<strong class="red">${currency(product.price, true, true)}</strong>
				</span>
				[#if product.scoreCount > 0]
					<span>${message("Product.score")}: ${product.score?string("0.0")}</span>
				[#elseif setting.isShowMarketPrice]
					<span>
						${message("Product.marketPrice")}:
						<del class="gray-darker">${currency(product.marketPrice, true, true)}</del>
					</span>
				[/#if]
			</div>
		</div>
		<form id="consultationForm" action="${base}/consultation/save" method="post">
			<input name="productId" type="hidden" value="${product.id}">
			<div class="form-group">
				<label for="content">${message("Consultation.content")}</label>
				<textarea id="content" name="content" class="form-control" rows="5"></textarea>
			</div>
			[#if setting.captchaTypes?? && setting.captchaTypes?seq_contains("consultation")]
				<div class="form-group">
					<label for="captcha">${message("common.captcha.name")}</label>
					<div class="input-group">
						<input id="captcha" name="captcha" class="captcha form-control" type="text" maxlength="4" autocomplete="off">
						<span class="input-group-btn"></span>
					</div>
				</div>
			[/#if]
			<button class="btn btn-lg btn-primary btn-block" type="submit">${message("shop.consultation.submit")}</button>
		</form>
	</main>
</body>
</html>