<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("shop.payment.pay")}[#if showPowered] [/#if]</title>
	<script type="text/javascript" src="${base}/resources/shop/js/jweixin.js"></script>
	<script type="text/javascript">
		if (typeof WeixinJSBridge == "undefined") {
			if (document.addEventListener) {
				document.addEventListener("WeixinJSBridgeReady", onBridgeReady, false);
			} else if (document.attachEvent) {
				document.attachEvent("WeixinJSBridgeReady", onBridgeReady);
				document.attachEvent("onWeixinJSBridgeReady", onBridgeReady);
			}
		} else {
			onBridgeReady();
		}
		
		function onBridgeReady() {
			WeixinJSBridge.invoke("getBrandWCPayRequest", {
				appId: "${appId}",
				timeStamp: "${timeStamp}",
				nonceStr: "${nonceStr}",
				package: "${package}",
				signType: "${signType}",
				paySign: "${paySign}"
			}, function(res) {
				if(res.err_msg == "get_brand_wcpay_request:ok") {
					location.href = "${postPayUrl}";
				}
			});
		}
	</script>
</head>
<body>
</body>
</html>