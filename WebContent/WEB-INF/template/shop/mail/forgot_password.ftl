<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html;charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>SHOP ++</title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
</head>
<body>
	<p>尊敬的会员</p>
	<p>您在${setting.siteName}申请了重置密码服务，请点击以下链接并根据页面提示完成密码重置</p>
	<p>
		<a href="${setting.siteUrl}/password/reset?type=${type}&username=${username}&key=${safeKey.value}" target="_blank">${setting.siteUrl}/password/reset?type=${type}&username=${username}&key=${safeKey.value}</a>
	</p>
</body>
</html>