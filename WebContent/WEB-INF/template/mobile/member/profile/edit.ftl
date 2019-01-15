<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.profile.edit")}[#if showPowered] [/#if]</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/mobile/member/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/bootstrap-datepicker.css" rel="stylesheet">
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
			var $datepicker = $("input.datepicker");
			
			[#if flashMessage?has_content]
				$.alert("${flashMessage}");
			[/#if]
			
			// 地区选择
			$areaId.lSelect({
				url: "${base}/common/area"
			});
			
			// 日期选择
			$datepicker.datepicker({
				language: "${locale}",
				format: "yyyy-mm-dd",
				todayHighlight: true,
				autoclose: true
			});
			
			$.validator.addMethod("notAllNumber",
				function(value, element) {
					return this.optional(element) || /^.*[^\d].*$/.test(value);
				},
				"${message("member.profile.notAllNumber")}"
			);
				
			// 表单验证
			$inputForm.validate({
				rules: {
					email: {
						required: true,
						email: true,
						remote: {
							url: "check_email",
							cache: false
						}
					},
					mobile: {
						pattern: /^1[3|4|5|7|8]\d{9}$/,
						remote: {
							url: "check_mobile",
							cache: false
						}
					}
					[@member_attribute_list]
						[#list memberAttributes as memberAttribute]
							[#if memberAttribute.isRequired || memberAttribute.pattern?has_content]
								,memberAttribute_${memberAttribute.id}: {
									[#if memberAttribute.isRequired]
										required: true
										[#if memberAttribute.pattern?has_content],[/#if]
									[/#if]
									[#if memberAttribute.pattern?has_content]
										pattern: /${memberAttribute.pattern}/
									[/#if]
								}
							[/#if]
						[/#list]
					[/@member_attribute_list]
				},
				messages: {
					email: {
						remote: "${message("common.validate.exist")}"
					},
					mobile: {
						remote: "${message("common.validate.exist")}"
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
		${message("member.profile.edit")}
	</header>
	<main>
		<div class="container-fluid">
			<form id="inputForm" action="update" method="post">
				<input name="id" type="hidden" value="${receiver.id}">
				<div class="panel panel-flat">
					<div class="panel-body">
						<div class="form-group">
							<label for="email">${message("Member.email")}</label>
							<input id="email" name="email" class="form-control" type="text" value="${currentUser.email}" maxlength="200">
						</div>
						<div class="form-group">
							<label for="mobile">${message("Member.mobile")}</label>
							<input id="mobile" name="mobile" class="form-control" type="text" value="${currentUser.mobile}" maxlength="200">
						</div>
						[@member_attribute_list]
							[#list memberAttributes as memberAttribute]
								<div class="form-group">
									<label[#if memberAttribute.type != "gender" && memberAttribute.type != "area" && memberAttribute.type != "checkbox"] for="memberAttribute_${memberAttribute.id}"[/#if]>${memberAttribute.name}</label>
									[#if memberAttribute.type == "name"]
										<input id="memberAttribute_${memberAttribute.id}" name="memberAttribute_${memberAttribute.id}" class="form-control" type="text" value="${currentUser.name}" maxlength="200">
									[#elseif memberAttribute.type == "gender"]
										<div class="radio">
											[#list genders as gender]
												<label>
													<input name="memberAttribute_${memberAttribute.id}" type="radio" value="${gender}"[#if gender == currentUser.gender] checked[/#if]>
													${message("Member.Gender." + gender)}
												</label>
											[/#list]
										</div>
									[#elseif memberAttribute.type == "birth"]
										<input id="memberAttribute_${memberAttribute.id}" name="memberAttribute_${memberAttribute.id}" class="datepicker form-control" type="text" value="${currentUser.birth}">
									[#elseif memberAttribute.type == "area"]
										<div class="input-group">
											<input id="areaId" name="memberAttribute_${memberAttribute.id}" type="hidden" value="${(currentUser.area.id)!}" treePath="${(currentUser.area.treePath)!}">
										</div>
									[#elseif memberAttribute.type == "address"]
										<input id="memberAttribute_${memberAttribute.id}" name="memberAttribute_${memberAttribute.id}" class="form-control" type="text" value="${currentUser.address}" maxlength="200">
									[#elseif memberAttribute.type == "zipCode"]
										<input id="memberAttribute_${memberAttribute.id}" name="memberAttribute_${memberAttribute.id}" class="form-control" type="text" value="${currentUser.zipCode}" maxlength="200">
									[#elseif memberAttribute.type == "phone"]
										<input id="memberAttribute_${memberAttribute.id}" name="memberAttribute_${memberAttribute.id}" class="form-control" type="text" value="${currentUser.phone}" maxlength="200">
									[#elseif memberAttribute.type == "text"]
										<input id="memberAttribute_${memberAttribute.id}" name="memberAttribute_${memberAttribute.id}" class="form-control" type="text" value="${currentUser.getAttributeValue(memberAttribute)}" maxlength="200">
									[#elseif memberAttribute.type == "select"]
										<select id="memberAttribute_${memberAttribute.id}" name="memberAttribute_${memberAttribute.id}" class="form-control">
											<option value="">${message("member.common.choose")}</option>
											[#list memberAttribute.options as option]
												<option value="${option}"[#if option == currentUser.getAttributeValue(memberAttribute)] selected[/#if]>${option}</option>
											[/#list]
										</select>
									[#elseif memberAttribute.type == "checkbox"]
										<div class="checkbox">
											[#list memberAttribute.options as option]
												<label>
													<input name="memberAttribute_${memberAttribute.id}" type="checkbox" value="${option}"[#if (currentUser.getAttributeValue(memberAttribute)?seq_contains(option))!] checked[/#if]>
													${option}
												</label>
											[/#list]
										</div>
									[/#if]
								</div>
							[/#list]
						[/@member_attribute_list]
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