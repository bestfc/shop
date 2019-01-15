[#if message?has_content]
	[#noautoesc]
		${message}
	[/#noautoesc]
[#else]
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("shop.payment.payResult")}[#if showPowered] [/#if]</title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/shop/css/animate.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/payment.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/shop/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/common.js"></script>
</head>
<body>
	[#include "/shop/include/header.ftl" /]
	<div class="container payment">
		<div class="row">
			<div class="span12">
				[#if paymentTransaction?has_content]
					<div class="title">
						[#if paymentTransaction.isSuccess]
							${message("shop.payment.payCompleted")}
						[#else]
							${message("shop.payment.wait")}
						[/#if]
					</div>
					<div class="bottom">
						<a href="${base}/">${message("shop.payment.index")}</a>
					</div>
				[#else]
					<div class="title">
						${message("shop.payment.failure")}
					</div>
				[/#if]
			</div>
		</div>
	</div>
	[#include "/shop/include/footer.ftl" /]
</body>
</html>
[/#if]