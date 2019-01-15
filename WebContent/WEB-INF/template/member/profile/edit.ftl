<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("member.profile.edit")}[#if showPowered] [/#if]</title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/member/css/animate.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/member/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/member/css/member.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/member/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/member/js/jquery.lSelect.js"></script>
<script type="text/javascript" src="${base}/resources/member/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/member/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/member/datePicker/WdatePicker.js"></script>
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
				pattern: "${message("common.validate.mobile")}",
				remote: "${message("common.validate.exist")}"
			}
		}
	});

});
</script>
</head>
<body>
	[#assign current = "profileEdit" /]
	[#include "/shop/include/header.ftl" /]
	<div class="container member">
		<div class="row">
			[#include "/member/include/navigation.ftl" /]
			<div class="span10">
				<div class="input">
					<div class="title">${message("member.profile.edit")}</div>
					<form id="inputForm" action="update" method="post">
						<table class="input">
							<tr>
								<th>
									${message("Member.username")}:
								</th>
								<td>
									${currentUser.username}
								</td>
							</tr>
							<tr>
								<th>
									<span class="requiredField">*</span>${message("Member.email")}:
								</th>
								<td>
									<input type="text" name="email" class="text" value="${currentUser.email}" maxlength="200" />
								</td>
							</tr>
							<tr>
								<th>
									${message("Member.mobile")}:
								</th>
								<td>
									<input type="text" name="mobile" class="text" value="${currentUser.mobile}" maxlength="200" />
								</td>
							</tr>
							[@member_attribute_list]
								[#list memberAttributes as memberAttribute]
									<tr>
										<th>
											[#if memberAttribute.isRequired]<span class="requiredField">*</span>[/#if]${memberAttribute.name}:
										</th>
										<td>
											[#if memberAttribute.type == "name"]
												<input type="text" name="memberAttribute_${memberAttribute.id}" class="text" value="${currentUser.name}" maxlength="200" />
											[#elseif memberAttribute.type == "gender"]
												<span class="fieldSet">
													[#list genders as gender]
														<label>
															<input type="radio" name="memberAttribute_${memberAttribute.id}" value="${gender}"[#if gender == currentUser.gender] checked="checked"[/#if] />${message("Member.Gender." + gender)}
														</label>
													[/#list]
												</span>
											[#elseif memberAttribute.type == "birth"]
												<input type="text" name="memberAttribute_${memberAttribute.id}" class="text" value="${currentUser.birth}" onfocus="WdatePicker();" />
											[#elseif memberAttribute.type == "area"]
												<span class="fieldSet">
													<input type="hidden" id="areaId" name="memberAttribute_${memberAttribute.id}" value="${(currentUser.area.id)!}" treePath="${(currentUser.area.treePath)!}" />
												</span>
											[#elseif memberAttribute.type == "address"]
												<input type="text" name="memberAttribute_${memberAttribute.id}" class="text" value="${currentUser.address}" maxlength="200" />
											[#elseif memberAttribute.type == "zipCode"]
												<input type="text" name="memberAttribute_${memberAttribute.id}" class="text" value="${currentUser.zipCode}" maxlength="200" />
											[#elseif memberAttribute.type == "phone"]
												<input type="text" name="memberAttribute_${memberAttribute.id}" class="text" value="${currentUser.phone}" maxlength="200" />
											[#elseif memberAttribute.type == "text"]
												<input type="text" name="memberAttribute_${memberAttribute.id}" class="text" value="${currentUser.getAttributeValue(memberAttribute)}" maxlength="200" />
											[#elseif memberAttribute.type == "select"]
												<select name="memberAttribute_${memberAttribute.id}">
													<option value="">${message("member.common.choose")}</option>
													[#list memberAttribute.options as option]
														<option value="${option}"[#if option == currentUser.getAttributeValue(memberAttribute)] selected="selected"[/#if]>
															${option}
														</option>
													[/#list]
												</select>
											[#elseif memberAttribute.type == "checkbox"]
												<span class="fieldSet">
													[#list memberAttribute.options as option]
														<label>
															<input type="checkbox" name="memberAttribute_${memberAttribute.id}" value="${option}"[#if (currentUser.getAttributeValue(memberAttribute)?seq_contains(option))!] checked="checked"[/#if] />
															${option}
														</label>
													[/#list]
												</span>
											[/#if]
										</td>
									</tr>
								[/#list]
							[/@member_attribute_list]
							<tr>
								<th>
									&nbsp;
								</th>
								<td>
									<input type="submit" class="button" value="${message("member.common.submit")}" />
									<a href="${base}/member/index" class="backButton button">${message("member.common.back")}</a>
								</td>
							</tr>
						</table>
					</form>
				</div>
			</div>
		</div>
	</div>
	[#include "/shop/include/footer.ftl" /]
</body>
</html>