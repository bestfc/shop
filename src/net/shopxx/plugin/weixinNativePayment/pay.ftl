<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("shop.payment.pay")} </title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/business/css/common.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/business/js/html5shiv.js"></script>
		<script src="${base}/resources/business/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/business/js/jquery.js"></script>
	<script src="${base}/resources/business/js/common.js"></script>
	<style type="text/css">
	body {
		padding: 60px;
		text-align: center;
		color: #ffffff;
		background-color: #333333;
	}
	
	h1 {
		line-height: 30px;
		font-size: 20px;
	}
	
	img {
		width: 250px;
		height: 250px;
		margin: 15px 0px;
		padding: 15px;
		background-color: #ffffff;
	}
	
	.hint {
		width: 260px;
		padding: 20px 10px;
		margin: 0px auto;
		font-size: 14px;
		border-radius: 100px;
		-moz-border-radius: 100px;
		-webkit-border-radius: 100px;
		box-shadow: inset 0px 5px 10px -5px #191919, 0px 1px 0px 0px #444444;
		-moz-box-shadow: inset 0px 5px 10px -5px #191919, 0px 1px 0px 0px #444444;
		-webkit-box-shadow: inset 0px 5px 10px -5px #191919, 0px 1px 0px 0px #444444;
		background-color: #232323;
	}
	</style>
	<script type="text/javascript">
	$().ready(function() {
		
		var paymentTransactionSn = ${paymentTransactionSn}
		
		// 检查是否支付成功
		setInterval(function() {
			$.ajax({
				url: "${base}/payment/check_is_pay_success",
				data: {paymentTransactionSn: paymentTransactionSn},
				type: "POST",
				dataType: "json",
				cache: false,
				success: function(data) {
					if (data) {
						location.href = "${base}/payment/post_pay_" + paymentTransactionSn;
					}
				}
			});
		}, 10000);
		
	});
	</script>
</head>
<body>
	<main>
		<h1>${message("shop.payment.weixinNativePayment")}</h1>
		<img src="data:image/jpg;base64,${imageBase64}">
		<div class="hint">${message("shop.payment.weixinNativePaymentHint")}</div>
	</main>
</body>
</html>