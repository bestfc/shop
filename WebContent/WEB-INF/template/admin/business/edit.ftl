<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html;charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("admin.business.edit")} </title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.tools.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.lSelect.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/webuploader.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/input.js"></script>
<script type="text/javascript" src="${base}/resources/admin/datePicker/WdatePicker.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $inputForm = $("#inputForm");
	var $areaId = $("#areaId");
	var $filePicker = $("a.filePicker");
	
	[@flash_message /]
	
	$.validator.addMethod("notAllowBlank",
		function(value, element) {
			return this.optional(element) || /^\S*$/.test(value);
		},
		"${message("common.validate.illegal")}"
	);
	
	// 文件上传
	$filePicker.uploader();
	
	// 表单验证
	$inputForm.validate({
		rules: {
			password: {
				notAllowBlank: true,
				minlength: 4
			},
			rePassword: {
				notAllowBlank: true,
				equalTo: "#password"
			},
			email: {
				required: true,
				email: true,
				remote: {
					url: "check_email?id=${business.id}",
					cache: false
				}
			},
			mobile: {
				pattern: /^1[3|4|5|7|8]\d{9}$/,
				remote: {
					url: "check_mobile?id=${business.id}",
					cache: false
				}
			}
			[#list businessAttributes as businessAttribute]
				[#if businessAttribute.isRequired || businessAttribute.pattern?has_content]
					,businessAttribute_${businessAttribute.id}: {
						[#if businessAttribute.isRequired]
							required: true
							[#if businessAttribute.pattern?has_content],[/#if]
						[/#if]
						[#if businessAttribute.pattern?has_content]
							pattern: /${businessAttribute.pattern}/
						[/#if]
					}
				[/#if]
			[/#list]
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
<body>
	<div class="breadcrumb">
		<a href="${base}/admin/index">${message("admin.breadcrumb.home")}</a> &raquo; ${message("admin.business.edit")}
	</div>
	<form id="inputForm" action="update" method="post">
		<input type="hidden" name="id" value="${business.id}" />
		<ul id="tab" class="tab">
			<li>
				<input type="button" value="${message("admin.business.base")}" />
			</li>
			[#if businessAttributes?has_content]
				<li>
					<input type="button" value="${message("admin.business.profile")}" />
				</li>
			[/#if]
		</ul>
		<table class="input tabContent">
			<tr>
				<th>
					${message("Business.username")}:
				</th>
				<td>
					${business.username}
					[#if loginPlugin??]
						<span class="silver">[${loginPlugin.name}]</span>
					[/#if]
				</td>
			</tr>
			<tr>
				<th>
					${message("Business.password")}:
				</th>
				<td>
					<input type="password" id="password" name="password" class="text" maxlength="20" autocomplete="off" />
				</td>
			</tr>
			<tr>
				<th>
					${message("admin.business.rePassword")}:
				</th>
				<td>
					<input type="password" name="rePassword" class="text" maxlength="20" autocomplete="off" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("Business.email")}:
				</th>
				<td>
					<input type="text" name="email" class="text" value="${business.email}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Business.mobile")}:
				</th>
				<td>
					<input type="text" name="mobile" class="text" value="${business.mobile}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Business.balance")}:
				</th>
				<td>
					${currency(business.balance, true)}
				</td>
			</tr>
			[#if business.frozenFund > 0]
				<tr>
					<th>
						${message("Business.frozenFund")}:
					</th>
					<td>
						${currency(business.frozenFund, true)}
					</td>
				</tr>
			[/#if]
			<tr>
				<th>
					${message("admin.common.setting")}:
				</th>
				<td>
					<label>
						<input type="checkbox" name="isEnabled" value="true"[#if business.isEnabled] checked="checked"[/#if] />${message("User.isEnabled")}
						<input type="hidden" name="_isEnabled" value="false" />
					</label>
					[#if business.isLocked]
						<label>
							<input type="checkbox" name="unlock" value="true" />${message("admin.business.unlock")}
						</label>
					[/#if]
				</td>
			</tr>
			<tr>
				<th>
					${message("admin.common.createdDate")}:
				</th>
				<td>
					${business.createdDate?string("yyyy-MM-dd HH:mm:ss")}
				</td>
			</tr>
		</table>
		[#if businessAttributes?has_content]
			<table class="input tabContent">
				[#list businessAttributes as businessAttribute]
					<tr>
						<th>
							[#if businessAttribute.isRequired]<span class="requiredField">*</span>[/#if]${businessAttribute.name}:
						</th>
						<td>
							[#if businessAttribute.type == "name"]
								<input type="text" name="businessAttribute_${businessAttribute.id}" class="text" value="${business.name}" maxlength="200" />
							[#elseif businessAttribute.type == "text" || businessAttribute.type == "name" || businessAttribute.type == "licenseNumber" || businessAttribute.type == "legalPerson" || businessAttribute.type == "idCard" || businessAttribute.type == "phone" || businessAttribute.type == "organizationCode" || businessAttribute.type == "identificationNumber" || businessAttribute.type == "bankName" || businessAttribute.type == "bankAccount"]
								<input type="text" name="businessAttribute_${businessAttribute.id}" class="text" value="${business.getAttributeValue(businessAttribute)}" maxlength="200" />
							[#elseif businessAttribute.type == "image" || businessAttribute.type == "licenseImage" || businessAttribute.type == "idCardImage" || businessAttribute.type == "organizationImage" || businessAttribute.type == "taxImage"]
								<span class="fieldSet">
									<input type="text" name="businessAttribute_${businessAttribute.id}" class="text" value="${business.getAttributeValue(businessAttribute)}" maxlength="200"/>
									<a href="javascript:;" class="button filePicker">${message("admin.upload.filePicker")}</a>
									[#if business.getAttributeValue(businessAttribute)??]
										<a href="${business.getAttributeValue(businessAttribute)}" target="_blank">${message("admin.common.view")}</a>
									[/#if]
								</span>
							[#elseif businessAttribute.type == "select"]
								<select name="businessAttribute_${businessAttribute.id}">
									<option value="">${message("admin.common.choose")}</option>
									[#list businessAttribute.options as option]
										<option value="${option}"[#if option == business.getAttributeValue(businessAttribute)] selected="selected"[/#if]>
											${option}
										</option>
									[/#list]
								</select>
							[#elseif businessAttribute.type == "checkbox"]
								<span class="fieldSet">
									[#list businessAttribute.options as option]
										<label>
											<input type="checkbox" name="businessAttribute_${businessAttribute.id}" value="${option}"[#if (business.getAttributeValue(businessAttribute)?seq_contains(option))!] checked="checked"[/#if] />${option}
										</label>
									[/#list]
								</span>
							[#elseif businessAttribute.type == "date"]
								<input type="text" name="businessAttribute_${businessAttribute.id}" class="text Wdate" value="[#if business.getAttributeValue(businessAttribute)??]${business.getAttributeValue(businessAttribute)}[/#if]" onfocus="WdatePicker({dateFmt: 'yyyy-MM-dd HH:mm:ss'});" />
							[/#if]
						</td>
					</tr>
				[/#list]
			</table>
		[/#if]
		<table class="input">
			<tr>
				<th>
					&nbsp;
				</th>
				<td>
					<input type="submit" class="button" value="${message("admin.common.submit")}" />
					<input type="button" class="button" value="${message("admin.common.back")}" onclick="history.back(); return false;" />
				</td>
			</tr>
		</table>
	</form>
</body>
</html>