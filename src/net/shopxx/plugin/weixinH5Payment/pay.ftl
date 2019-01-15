<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="author" content="fantiejia Team">
	<meta name="copyright" content="fantiejia">
	<title>${message("shop.payment.pay")}Powered By fantiejia</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/mobile/shop/css/common.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/mobile/shop/js/html5shiv.js"></script>
		<script src="${base}/resources/mobile/shop/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/mobile/shop/js/jquery.js"></script>
	<script type="text/javascript">
	$().ready(function() {
		
		var $payForm = $("#payForm");
		
		// 表单提交
		$payForm.submit();
	
	});
	</script>
</head>
<body class="pay">
	<form id="payForm" action="${mwebUrl}" method="post"></form>
</body>
</html>