<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.receiver.edit")}[#if showPowered] [/#if]</title>
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
	<script src="${base}/resources/mobile/member/js/bootstrap-datepicker.js"></script>
	<script src="${base}/resources/mobile/member/js/jquery.validate.js"></script>
	<script src="${base}/resources/mobile/member/js/jquery.lSelect.js"></script>
	<script src="${base}/resources/mobile/member/js/underscore.js"></script>
	<script src="${base}/resources/mobile/member/js/common.js"></script>
	<script type="text/javascript">
		$().ready(function() {

			var $inputForm = $("#inputForm");
			var $areaId = $("#areaId");
			
			[#if flashMessage?has_content]
				$.alert("${flashMessage}");
			[/#if]
			
			// 地区选择
			$areaId.lSelect({
				url: "${base}/common/area"
			});
			
			$.validator.addMethod("requiredOne",
				function(value, element, param) {
					return $.trim(value) != "" || $.trim($(param).val()) != "";
				},
				"${message("member.receiver.requiredOne")}"
			);
			
			// 表单验证
			$inputForm.validate({
				rules: {
					consignee: "required",
					areaId: "required",
					address: "required",
					zipCode: {
						required: true,
						pattern: /^\d{6}$/
					},
					phone: {
						required: true,
						pattern: /^\d{3,4}-?\d{7,9}$/
					}
				}
			});
		
		});
	</script>
</head>
<body class="profile">
	<header class="header-fixed">
		<a class="pull-left" href="${base}/member/receiver/list">
			<span class="glyphicon glyphicon-menu-left"></span>
		</a>
		${message("member.receiver.edit")}
	</header>
	<main>
		<div class="container-fluid">
			<form id="inputForm" action="update" method="post">
				<input name="receiverId" type="hidden" value="${receiver.id}">
				<div class="panel panel-flat">
					<div class="panel-body">
						<div class="form-group">
							<label for="consignee">${message("Receiver.consignee")}</label>
							<input id="consignee" name="consignee" class="form-control" type="text" value="${receiver.consignee}" maxlength="20">
						</div>
						<div class="form-group">
							<label>${message("Receiver.area")}</label>
							<div class="input-group">
								<input id="areaId" name="areaId" type="hidden" value="${(receiver.area.id)!}" treePath="${(receiver.area.treePath)!}">
							</div>
						</div>
						<div class="form-group">
							<label for="address">${message("Receiver.address")}</label>
							<input id="address" name="address" class="form-control" type="text" value="${receiver.address}" maxlength="200">
						</div>
						<div class="form-group">
							<label for="zipCode">${message("Receiver.zipCode")}</label>
							<input id="zipCode" name="zipCode" class="form-control" type="text" value="${receiver.zipCode}" maxlength="200">
						</div>
						<div class="form-group">
							<label for="phone">${message("Receiver.phone")}</label>
							<input id="phone" name="phone" class="form-control" type="text" value="${receiver.phone}" maxlength="200">
						</div>
						<div class="form-group">
							<label>${message("Receiver.isDefault")}</label>
							<input name="isDefault" type="checkbox" value="true" [#if receiver.isDefault] checked[/#if]>
							<input name="_isDefault" type="hidden" value="false">
						</div>
					</div>
					<div class="panel-footer text-center">
						<button class="btn btn-primary" type="submit">${message("member.common.submit")}</button>
						<a class="btn btn-default" href="${base}/member/receiver/list">${message("member.common.back")}</a>
					</div>
				</div>
			</form>
		</div>
	</main>
</body>
</html>