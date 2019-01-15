<!DOCTYPE html>
<html>
<head>
	<meta charset="${requestCharset!"utf-8"}">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("shop.payment.prePay")}[#if showPowered] [/#if]</title>
</head>
<body onload="javascript: document.forms[0].submit();">
	<form action="${requestUrl}" method="${requestMethod!"get"}"[#if requestCharset?has_content] accept-charset="${requestCharset}"[/#if]>
		[#list parameterMap.entrySet() as entry]
			<input type="hidden" name="${entry.key}" value="${entry.value}">
		[/#list]
	</form>
</body>
</html>