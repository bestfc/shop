<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.password.edit")}[#if showPowered] [/#if]</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/mobile/member/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/animate.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/common.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/profile.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/mobile/member/js/html5shiv.js"></script>
		<script src="${base}/resources/mobile/member/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/mobile/member/js/jquery.js"></script>
	<script src="${base}/resources/mobile/member/js/bootstrap.js"></script>
	<script src="${base}/resources/mobile/member/js/jquery.validate.js"></script>
	<script src="${base}/resources/mobile/member/js/underscore.js"></script>
	<script src="${base}/resources/mobile/member/js/common.js"></script>
	<script type="text/javascript">
		$().ready(function() {
			
			var $inputForm = $("#inputForm");
			
			[#if flashMessage?has_content]
				$.alert("${flashMessage}");
			[/#if]
			
			// 表单验证
			$inputForm.validate({
				rules: {
					currentPassword: {
						required: true,
						remote: {
							url: "check_current_password",
							cache: false
						}
					},
					password: {
						required: true,
						minlength: 4
					},
					rePassword: {
						required: true,
						equalTo: "#password"
					}
				}
			});
		
		});
	</script>
</head>
<body class="profile">
	<header class="header-fixed">
		<a class="pull-left" href="${base}/member/index">
			<span class="glyphicon glyphicon-menu-left"></span>
		</a>
		${message("member.password.edit")}
	</header>
	<main>
		<div class="container-fluid">
			<form id="inputForm" action="update" method="post">
				<div class="panel panel-flat">
					<div class="panel-body">
						<div class="form-group">
							<label for="currentPassword">${message("member.password.currentPassword")}</label>
							<input id="currentPassword" name="currentPassword" class="form-control" type="password" maxlength="200" autocomplete="off">
						</div>
						<div class="form-group">
							<label for="password">${message("member.password.newPassword")}</label>
							<input id="password" name="password" class="form-control" type="password" maxlength="20" autocomplete="off">
						</div>
						<div class="form-group">
							<label for="rePassword">${message("member.password.rePassword")}</label>
							<input id="rePassword" name="rePassword" class="form-control" type="password" maxlength="20" autocomplete="off">
						</div>
					</div>
					<div class="panel-footer text-center">
						<button class="btn btn-primary" type="submit">${message("member.common.submit")}</button>
						<a class="btn btn-default" href="${base}/member/index">${message("member.common.back")}</a>
					</div>
				</div>
			</form>
		</div>
	</main>
</body>
</html>