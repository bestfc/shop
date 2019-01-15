<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("admin.setting.edit")} </title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.tools.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/webuploader.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/input.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $inputForm = $("#inputForm");
	var $filePicker = $("a.filePicker");
	var $smtpHost = $("#smtpHost");
	var $smtpPort = $("#smtpPort");
	var $smtpUsername = $("#smtpUsername");
	var $smtpPassword = $("#smtpPassword");
	var $smtpSSLEnabled = $("#smtpSSLEnabled");
	var $smtpFromMail = $("#smtpFromMail");
	var $testSmtp = $("#testSmtp");
	var $toMail = $("#toMail");
	var $sendMail = $("#sendMail");
	var $testSmtpStatus = $("#testSmtpStatus");
	var $smsBalance = $("#smsBalance");
	
	[@flash_message /]
	
	$filePicker.uploader();
	
	// 邮件测试
	$testSmtp.click(function() {
		$testSmtp.closest("tr").hide();
		$toMail.closest("tr").show();
	});
	
	// 发送邮件
	$sendMail.click(function() {
		$toMail.removeClass("ignore");
		var validator = $inputForm.validate();
		var isValid = validator.element($smtpFromMail) & validator.element($smtpHost) & validator.element($smtpPort) & validator.element($smtpUsername) & validator.element($toMail);
		$toMail.addClass("ignore");
		$.ajax({
			url: "test_smtp",
			type: "POST",
			data: {smtpHost: $smtpHost.val(), smtpPort: $smtpPort.val(), smtpUsername: $smtpUsername.val(), smtpPassword: $smtpPassword.val(), smtpSSLEnabled: $smtpSSLEnabled.prop("checked"), smtpFromMail: $smtpFromMail.val(), toMail: $toMail.val()},
			dataType: "json",
			cache: false,
			beforeSend: function() {
				if (!isValid) {
					return false;
				}
				$testSmtpStatus.html('<span class="loadingIcon">&nbsp;<\/span>${message("admin.setting.sendMailLoading")}');
				$sendMail.prop("disabled", true);
			},
			success: function(message) {
				$testSmtpStatus.empty();
				$sendMail.prop("disabled", false);
				$.message(message);
			}
		});
	});
	
	// 短信余额查询
	$smsBalance.click(function() {
		var $this = $(this);
		$.ajax({
			url: "sms_balance",
			type: "GET",
			dataType: "json",
			cache: false,
			beforeSend: function() {
				$this.prop("disabled", true).after('<span class="loadingIcon">&nbsp;<\/span>');
			},
			success: function(message) {
				$this.prop("disabled", false).nextAll("span").remove();
				if (message.type == "success") {
					$.dialog({
						type: "warn",
						content: message.content,
						modal: true,
						ok: null,
						cancel: null
					});
				} else {
					$.message(message);
				}
			}
		});
		return false;
	});
	
	$.validator.addMethod("compareLength", 
		function(value, element, param) {
			return this.optional(element) || $.trim(value) == "" || $.trim($(param).val()) == "" || parseFloat(value) >= parseFloat($(param).val());
		},
		"${message("admin.setting.compareLength")}"
	);
	
	$.validator.addMethod("requiredTo", 
		function(value, element, param) {
			var parameterValue = $(param).val();
			if ($.trim(parameterValue) == "" || ($.trim(parameterValue) != "" && $.trim(value) != "")) {
				return true;
			} else {
				return false;
			}
		},
		"${message("admin.setting.requiredTo")}"
	);
	
	$.validator.addMethod("comparePointScale", 
		function(value, element, param) {
			var parameterValue = $(param).val();
			if ($.trim(parameterValue) == "" || $.trim(value) == "") {
				return true;
			}
			try {
				return parseFloat(parameterValue) <= parseFloat(value);
			} catch(e) {
				return false;
			}
		},
		"${message("admin.setting.comparePointScale")}"
	);
	
	// 表单验证
	$inputForm.validate({
		rules: {
			siteName: "required",
			siteUrl: {
				required: true,
				pattern: /^(http:\/\/|https:\/\/).*$/i
			},
			logo: {
				required: true,
				pattern: /^(http:\/\/|https:\/\/|\/).*$/i
			},
			email: "email",
			largeProductImageWidth: {
				required: true,
				integer: true,
				min: 1
			},
			largeProductImageHeight: {
				required: true,
				integer: true,
				min: 1
			},
			mediumProductImageWidth: {
				required: true,
				integer: true,
				min: 1
			},
			mediumProductImageHeight: {
				required: true,
				integer: true,
				min: 1
			},
			thumbnailProductImageWidth: {
				required: true,
				integer: true,
				min: 1
			},
			thumbnailProductImageHeight: {
				required: true,
				integer: true,
				min: 1
			},
			defaultLargeProductImage: {
				required: true,
				pattern: /^(http:\/\/|https:\/\/|\/).*$/i
			},
			defaultMediumProductImage: {
				required: true,
				pattern: /^(http:\/\/|https:\/\/|\/).*$/i
			},
			defaultThumbnailProductImage: {
				required: true,
				pattern: /^(http:\/\/|https:\/\/|\/).*$/i
			},
			watermarkAlpha: {
				required: true,
				digits: true,
				max: 100
			},
			watermarkImageFile: {
				extension: "${setting.uploadImageExtension}"
			},
			defaultMarketPriceScale: {
				required: true,
				min: 0,
				decimal: {
					integer: 3,
					fraction: 3
				}
			},
			registerPoint: {
				required: true,
				integer: true,
				min: 0
			},
			maxFailedLoginAttempts: {
				required: true,
				integer: true,
				min: 1
			},
			passwordLockTime: {
				required: true,
				digits: true
			},
			safeKeyExpiryTime: {
				required: true,
				digits: true
			},
			uploadMaxSize: {
				required: true,
				digits: true
			},
			imageUploadPath: "required",
			mediaUploadPath: "required",
			fileUploadPath: "required",
			smtpFromMail: {
				required: true,
				email: true
			},
			smtpHost: "required",
			smtpPort: {
				required: true,
				digits: true
			},
			smtpUsername: "required",
			toMail: {
				required: true,
				email: true
			},
			currencySign: "required",
			currencyUnit: "required",
			stockAlertCount: {
				required: true,
				digits: true
			},
			automaticReceiveTime: {
				required: true,
				digits: true
			},
			defaultPointScale: {
				required: true,
				min: 0,
				decimal: {
					integer: 3,
					fraction: 3
				}
			},
			maxPointScale: {
				required: true,
				min: 0,
				decimal: {
					integer: 3,
					fraction: 3
				},
				comparePointScale: "#defaultPointScale"
			},
			taxRate: {
				required: true,
				min: 0,
				decimal: {
					integer: 3,
					fraction: 3
				}
			},
			cookiePath: "required",
			smsKey: {
				requiredTo: "#smsSn"
			}
		}
	});

});
</script>
</head>
<body>
	<div class="breadcrumb">
		<a href="${base}/admin/index">${message("admin.breadcrumb.home")}</a> &raquo; ${message("admin.setting.edit")}
	</div>
	<form id="inputForm" action="update" method="post" enctype="multipart/form-data">
		<ul id="tab" class="tab">
			<li>
				<input type="button" value="${message("admin.setting.base")}" />
			</li>
			<li>
				<input type="button" value="${message("admin.setting.show")}" />
			</li>
			<li>
				<input type="button" value="${message("admin.setting.registerSecurity")}" />
			</li>
			<li>
				<input type="button" value="${message("admin.setting.mail")}" />
			</li>
			<li>
				<input type="button" value="${message("admin.setting.other")}" />
			</li>
		</ul>
		<table class="input tabContent">
			<tr>
				<th>
					<span class="requiredField">*</span>${message("Setting.siteName")}:
				</th>
				<td>
					<input type="text" name="siteName" class="text" value="${setting.siteName}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("Setting.siteUrl")}:
				</th>
				<td>
					<input type="text" name="siteUrl" class="text" value="${setting.siteUrl}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("Setting.logo")}:
				</th>
				<td>
					<span class="fieldSet">
						<input type="text" name="logo" class="text" value="${setting.logo}" maxlength="200" />
						<a href="javascript:;" class="button filePicker">${message("admin.upload.filePicker")}</a>
						<a href="${setting.logo}" target="_blank">${message("admin.common.view")}</a>
					</span>
				</td>
			</tr>
			<tr>
				<th>
					${message("Setting.hotSearch")}:
				</th>
				<td>
					<input type="text" name="hotSearch" class="text" value="${setting.hotSearch}" maxlength="200" title="${message("admin.setting.hotSearchTitle")}" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Setting.address")}:
				</th>
				<td>
					<input type="text" name="address" class="text" value="${setting.address}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Setting.phone")}:
				</th>
				<td>
					<input type="text" name="phone" class="text" value="${setting.phone}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Setting.zipCode")}:
				</th>
				<td>
					<input type="text" name="zipCode" class="text" value="${setting.zipCode}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Setting.email")}:
				</th>
				<td>
					<input type="text" name="email" class="text" value="${setting.email}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Setting.certtext")}:
				</th>
				<td>
					<input type="text" name="certtext" class="text" value="${setting.certtext}" maxlength="200" />
				</td>
			</tr>
		</table>
		<table class="input tabContent">
			<tr>
				<th>
					${message("Setting.locale")}:
				</th>
				<td>
					<select name="locale">
						[#list locales as locale]
							<option value="${locale}"[#if locale == setting.locale] selected="selected"[/#if]>${message("Setting.Locale." + locale)}</option>
						[/#list]
					</select>
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("admin.setting.largeProductImage")}:
				</th>
				<td>
					${message("admin.setting.width")}:
					<input type="text" name="largeProductImageWidth" class="text" value="${setting.largeProductImageWidth}" maxlength="9" style="width: 50px;" title="${message("admin.setting.widthTitle")}" />
					${message("admin.setting.height")}:
					<input type="text" name="largeProductImageHeight" class="text" value="${setting.largeProductImageHeight}" maxlength="9" style="width: 50px;" title="${message("admin.setting.heightTitle")}" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("admin.setting.mediumProductImage")}:
				</th>
				<td>
					${message("admin.setting.width")}:
					<input type="text" name="mediumProductImageWidth" class="text" value="${setting.mediumProductImageWidth}" maxlength="9" style="width: 50px;" title="${message("admin.setting.widthTitle")}" />
					${message("admin.setting.height")}:
					<input type="text" name="mediumProductImageHeight" class="text" value="${setting.mediumProductImageHeight}" maxlength="9" style="width: 50px;" title="${message("admin.setting.heightTitle")}" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("admin.setting.thumbnailProductImage")}:
				</th>
				<td>
					${message("admin.setting.width")}:
					<input type="text" name="thumbnailProductImageWidth" class="text" value="${setting.thumbnailProductImageWidth}" maxlength="9" style="width: 50px;" title="${message("admin.setting.widthTitle")}" />
					${message("admin.setting.height")}:
					<input type="text" name="thumbnailProductImageHeight" class="text" value="${setting.thumbnailProductImageHeight}" maxlength="9" style="width: 50px;" title="${message("admin.setting.heightTitle")}" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("admin.setting.defaultLargeProductImage")}:
				</th>
				<td>
					<span class="fieldSet">
						<input type="text" name="defaultLargeProductImage" class="text" value="${setting.defaultLargeProductImage}" maxlength="200" />
						<a href="javascript:;" class="button filePicker">${message("admin.upload.filePicker")}</a>
						<a href="${setting.defaultLargeProductImage}" target="_blank">${message("admin.common.view")}</a>
					</span>
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("admin.setting.defaultMediumProductImage")}:
				</th>
				<td>
					<span class="fieldSet">
						<input type="text" name="defaultMediumProductImage" class="text" value="${setting.defaultMediumProductImage}" maxlength="200" />
						<a href="javascript:;" class="button filePicker">${message("admin.upload.filePicker")}</a>
						<a href="${setting.defaultMediumProductImage}" target="_blank">${message("admin.common.view")}</a>
					</span>
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("admin.setting.defaultThumbnailProductImage")}:
				</th>
				<td>
					<span class="fieldSet">
						<input type="text" name="defaultThumbnailProductImage" class="text" value="${setting.defaultThumbnailProductImage}" maxlength="200" />
						<a href="javascript:;" class="button filePicker">${message("admin.upload.filePicker")}</a>
						<a href="${setting.defaultThumbnailProductImage}" target="_blank">${message("admin.common.view")}</a>
					</span>
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("admin.setting.defaultStoreLogo")}:
				</th>
				<td>
					<span class="fieldSet">
						<input type="text" name="defaultStoreLogo" class="text" value="${setting.defaultStoreLogo}" maxlength="200" />
						<a href="javascript:;" class="button filePicker">${message("admin.upload.filePicker")}</a>
						<a href="${setting.defaultStoreLogo}" target="_blank">${message("admin.common.view")}</a>
					</span>
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("Setting.watermarkAlpha")}:
				</th>
				<td>
					<input type="text" name="watermarkAlpha" class="text" value="${setting.watermarkAlpha}" maxlength="9" title="${message("admin.setting.watermarkAlphaTitle")}" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Setting.watermarkImage")}:
				</th>
				<td>
					<span class="fieldSet">
						<input type="file" name="watermarkImageFile" />
						<a href="${base}${setting.watermarkImage}" target="_blank">${message("admin.common.view")}</a>
					</span>
				</td>
			</tr>
			<tr>
				<th>
					${message("Setting.watermarkPosition")}:
				</th>
				<td>
					<select name="watermarkPosition">
						[#list watermarkPositions as watermarkPosition]
							<option value="${watermarkPosition}"[#if watermarkPosition == setting.watermarkPosition] selected="selected"[/#if]>${message("Setting.WatermarkPosition." + watermarkPosition)}</option>
						[/#list]
					</select>
				</td>
			</tr>
			<tr>
				<th>
					${message("Setting.priceScale")}:
				</th>
				<td>
					<select name="priceScale">
						<option value="0"[#if setting.priceScale == 0] selected="selected"[/#if]>${message("admin.setting.priceScale0")}</option>
						<option value="1"[#if setting.priceScale == 1] selected="selected"[/#if]>${message("admin.setting.priceScale1")}</option>
						<option value="2"[#if setting.priceScale == 2] selected="selected"[/#if]>${message("admin.setting.priceScale2")}</option>
						<option value="3"[#if setting.priceScale == 3] selected="selected"[/#if]>${message("admin.setting.priceScale3")}</option>
					</select>
				</td>
			</tr>
			<tr>
				<th>
					${message("Setting.priceRoundType")}:
				</th>
				<td>
					<select name="priceRoundType">
						[#list roundTypes as roundType]
							<option value="${roundType}"[#if roundType == setting.priceRoundType] selected="selected"[/#if]>${message("Setting.RoundType." + roundType)}</option>
						[/#list]
					</select>
				</td>
			</tr>
			<tr>
				<th>
					${message("Setting.isShowMarketPrice")}:
				</th>
				<td>
					<input type="checkbox" name="isShowMarketPrice" value="true"[#if setting.isShowMarketPrice] checked="checked"[/#if] />
					<input type="hidden" name="_isShowMarketPrice" value="false" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("Setting.defaultMarketPriceScale")}:
				</th>
				<td>
					<input type="text" name="defaultMarketPriceScale" class="text" value="${setting.defaultMarketPriceScale}" maxlength="7" title="${message("admin.setting.defaultMarketPriceScaleTitle")}" />
				</td>
			</tr>
		</table>
		<table class="input tabContent">
			<tr>
				<th>
					${message("Setting.allowedRegisterTypes")}:
				</th>
				<td>
					[#list registerTypes as registerType]
						<label>
							<input type="checkbox" name="allowedRegisterTypes" value="${registerType}"[#if setting.allowedRegisterTypes?? && setting.allowedRegisterTypes?seq_contains(registerType)] checked="checked"[/#if] />${message("Setting.RegisterType." + registerType)}
						</label>
					[/#list]
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("Setting.registerPoint")}:
				</th>
				<td>
					<input type="text" name="registerPoint" class="text" value="${setting.registerPoint}" maxlength="9" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Setting.captchaTypes")}:
				</th>
				<td>
					[#list captchaTypes as captchaType]
						<label>
							<input type="checkbox" name="captchaTypes" value="${captchaType}"[#if setting.captchaTypes?? && setting.captchaTypes?seq_contains(captchaType)] checked="checked"[/#if] />${message("Setting.CaptchaType." + captchaType)}
						</label>
					[/#list]
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("Setting.maxFailedLoginAttempts")}:
				</th>
				<td>
					<input type="text" name="maxFailedLoginAttempts" class="text" value="${setting.maxFailedLoginAttempts}" maxlength="9" title="${message("admin.setting.maxFailedLoginAttemptsTitle")}" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("Setting.passwordLockTime")}:
				</th>
				<td>
					<input type="text" name="passwordLockTime" class="text" value="${setting.passwordLockTime}" maxlength="9" title="${message("admin.setting.passwordLockTimeTitle")}" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("Setting.safeKeyExpiryTime")}:
				</th>
				<td>
					<input type="text" name="safeKeyExpiryTime" class="text" value="${setting.safeKeyExpiryTime}" maxlength="9" title="${message("admin.setting.safeKeyExpiryTimeTitle")}" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("Setting.uploadMaxSize")}:
				</th>
				<td>
					<input type="text" name="uploadMaxSize" class="text" value="${setting.uploadMaxSize}" maxlength="9" title="${message("admin.setting.uploadMaxSizeTitle")}" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Setting.uploadImageExtension")}:
				</th>
				<td>
					<input type="text" name="uploadImageExtension" class="text" value="${setting.uploadImageExtension}" maxlength="200" title="${message("admin.setting.uploadImageExtensionTitle")}" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Setting.uploadMediaExtension")}:
				</th>
				<td>
					<input type="text" name="uploadMediaExtension" class="text" value="${setting.uploadMediaExtension}" maxlength="200" title="${message("admin.setting.uploadMediaExtensionTitle")}" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Setting.uploadFileExtension")}:
				</th>
				<td>
					<input type="text" name="uploadFileExtension" class="text" value="${setting.uploadFileExtension}" maxlength="200" title="${message("admin.setting.uploadFileExtensionTitle")}" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("Setting.imageUploadPath")}:
				</th>
				<td>
					<input type="text" name="imageUploadPath" class="text" value="${setting.imageUploadPath}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("Setting.mediaUploadPath")}:
				</th>
				<td>
					<input type="text" name="mediaUploadPath" class="text" value="${setting.mediaUploadPath}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("Setting.fileUploadPath")}:
				</th>
				<td>
					<input type="text" name="fileUploadPath" class="text" value="${setting.fileUploadPath}" maxlength="200" />
				</td>
			</tr>
		</table>
		<table class="input tabContent">
			<tr>
				<th>
					<span class="requiredField">*</span>${message("Setting.smtpHost")}:
				</th>
				<td>
					<input type="text" id="smtpHost" name="smtpHost" class="text" value="${setting.smtpHost}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("Setting.smtpPort")}:
				</th>
				<td>
					<input type="text" id="smtpPort" name="smtpPort" class="text" value="${setting.smtpPort}" maxlength="9" title="${message("admin.setting.smtpPortTitle")}" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("Setting.smtpUsername")}:
				</th>
				<td>
					<input type="text" id="smtpUsername" name="smtpUsername" class="text" value="${setting.smtpUsername}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Setting.smtpPassword")}:
				</th>
				<td>
					<input type="password" id="smtpPassword" name="smtpPassword" class="text" maxlength="200" autocomplete="off" title="${message("admin.setting.smtpPasswordTitle")}" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Setting.smtpSSLEnabled")}:
				</th>
				<td>
					<input type="checkbox" id="smtpSSLEnabled" name="smtpSSLEnabled" value="true"[#if setting.smtpSSLEnabled] checked="checked"[/#if] />
					<input type="hidden" name="_smtpSSLEnabled" value="false" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("Setting.smtpFromMail")}:
				</th>
				<td>
					<input type="text" id="smtpFromMail" name="smtpFromMail" class="text" value="${setting.smtpFromMail}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					&nbsp;
				</th>
				<td>
					<a href="javascript:;" id="testSmtp">[${message("admin.setting.testSmtp")}]</a>
				</td>
			</tr>
			<tr class="hidden">
				<th>
					${message("admin.setting.toMail")}:
				</th>
				<td>
					<span class="fieldSet">
						<input type="text" id="toMail" name="toMail" class="text ignore" maxlength="200" />
						<input type="button" id="sendMail" class="button" value="${message("admin.setting.sendMail")}" />
						<span id="testSmtpStatus">&nbsp;</span>
					</span>
				</td>
			</tr>
		</table>
		<table class="input tabContent">
			<tr>
				<th>
					<span class="requiredField">*</span>${message("Setting.currencySign")}:
				</th>
				<td>
					<input type="text" name="currencySign" class="text" value="${setting.currencySign}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("Setting.currencyUnit")}:
				</th>
				<td>
					<input type="text" name="currencyUnit" class="text" value="${setting.currencyUnit}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("Setting.stockAlertCount")}:
				</th>
				<td>
					<input type="text" name="stockAlertCount" class="text" value="${setting.stockAlertCount}" maxlength="9" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("Setting.automaticReceiveTime")}:
				</th>
				<td>
					<input type="text" name="automaticReceiveTime" class="text" value="${setting.automaticReceiveTime}" maxlength="9" title="${message("admin.setting.automaticReceiveTimeTitle")}" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Setting.stockAllocationTime")}:
				</th>
				<td>
					<select name="stockAllocationTime">
						[#list stockAllocationTimes as stockAllocationTime]
							<option value="${stockAllocationTime}"[#if stockAllocationTime == setting.stockAllocationTime] selected="selected"[/#if]>${message("Setting.StockAllocationTime." + stockAllocationTime)}</option>
						[/#list]
					</select>
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("Setting.defaultPointScale")}:
				</th>
				<td>
					<input type="text" id="defaultPointScale" name="defaultPointScale" class="text" value="${setting.defaultPointScale}" maxlength="7" title="${message("admin.setting.defaultPointScaleTitle")}" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("Setting.maxPointScale")}:
				</th>
				<td>
					<input type="text" name="maxPointScale" class="text" value="${setting.maxPointScale}" maxlength="7" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Setting.isDevelopmentEnabled")}:
				</th>
				<td>
					<label title="${message("admin.setting.isDevelopmentEnabledTitle")}">
						<input type="checkbox" name="isDevelopmentEnabled" value="true"[#if setting.isDevelopmentEnabled] checked="checked"[/#if] />
						<input type="hidden" name="_isDevelopmentEnabled" value="false" />
					</label>
				</td>
			</tr>
			<tr>
				<th>
					${message("Setting.isReviewEnabled")}:
				</th>
				<td>
					<input type="checkbox" name="isReviewEnabled" value="true"[#if setting.isReviewEnabled] checked="checked"[/#if] />
					<input type="hidden" name="_isReviewEnabled" value="false" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Setting.isReviewCheck")}:
				</th>
				<td>
					<input type="checkbox" name="isReviewCheck" value="true"[#if setting.isReviewCheck] checked="checked"[/#if] />
					<input type="hidden" name="_isReviewCheck" value="false" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Setting.isConsultationEnabled")}:
				</th>
				<td>
					<input type="checkbox" name="isConsultationEnabled" value="true"[#if setting.isConsultationEnabled] checked="checked"[/#if] />
					<input type="hidden" name="_isConsultationEnabled" value="false" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Setting.isConsultationCheck")}:
				</th>
				<td>
					<input type="checkbox" name="isConsultationCheck" value="true"[#if setting.isConsultationCheck] checked="checked"[/#if] />
					<input type="hidden" name="_isConsultationCheck" value="false" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Setting.isInvoiceEnabled")}:
				</th>
				<td>
					<input type="checkbox" name="isInvoiceEnabled" value="true"[#if setting.isInvoiceEnabled] checked="checked"[/#if] />
					<input type="hidden" name="_isInvoiceEnabled" value="false" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Setting.isTaxPriceEnabled")}:
				</th>
				<td>
					<input type="checkbox" name="isTaxPriceEnabled" value="true" title="${message("admin.setting.taxRateTitle")}"[#if setting.isTaxPriceEnabled] checked="checked"[/#if] />
					<input type="hidden" name="_isTaxPriceEnabled" value="false" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("Setting.taxRate")}:
				</th>
				<td>
					<input type="text" name="taxRate" class="text" value="${setting.taxRate}" maxlength="7" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("Setting.cookiePath")}:
				</th>
				<td>
					<input type="text" name="cookiePath" class="text" value="${setting.cookiePath}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Setting.cookieDomain")}:
				</th>
				<td>
					<input type="text" name="cookieDomain" class="text" value="${setting.cookieDomain}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Setting.kuaidi100Key")}:
				</th>
				<td>
					<input type="text" name="kuaidi100Key" class="text" value="${setting.kuaidi100Key}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					${message("Setting.smsSn")}:
				</th>
				<td>
					<input type="text" id="smsSn" name="smsSn" class="text" value="${setting.smsSn}" maxlength="200" />
					[#if setting.smsSn?has_content && setting.smsKey?has_content]
						<a href="javascript:;" id="smsBalance">[${message("admin.setting.smsBalance")}]</a>
					[/#if]
				</td>
			</tr>
			<tr>
				<th>
					${message("Setting.smsKey")}:
				</th>
				<td>
					<input type="text" name="smsKey" class="text" value="${setting.smsKey}" maxlength="200" />
				</td>
			</tr>
		</table>
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