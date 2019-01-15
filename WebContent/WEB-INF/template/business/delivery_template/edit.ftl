<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("business.deliveryTemplate.edit")} </title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/business/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/business/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/business/css/bootstrap-select.css" rel="stylesheet">
	<link href="${base}/resources/business/css/bootstrap-checkbox-x.css" rel="stylesheet">
	<link href="${base}/resources/business/css/bootstrap-fileinput.css" rel="stylesheet">
	<link href="${base}/resources/business/css/summernote.css" rel="stylesheet">
	<link href="${base}/resources/business/css/animate.css" rel="stylesheet">
	<link href="${base}/resources/business/css/adminLTE.css" rel="stylesheet">
	<link href="${base}/resources/business/css/common.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/business/js/html5shiv.js"></script>
		<script src="${base}/resources/business/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/business/js/jquery.js"></script>
	<script src="${base}/resources/business/js/bootstrap.js"></script>
	<script src="${base}/resources/business/js/bootstrap-select.js"></script>
	<script src="${base}/resources/business/js/bootstrap-checkbox-x.js"></script>
	<script src="${base}/resources/business/js/bootstrap-fileinput.js"></script>
	<script src="${base}/resources/business/js/summernote.js"></script>
	<script src="${base}/resources/business/js/jquery.validate.js"></script>
	<script src="${base}/resources/business/js/underscore.js"></script>
	<script src="${base}/resources/business/js/adminLTE.js"></script>
	<script src="${base}/resources/business/js/common.js"></script>
	<script id="tagSelectTemplate" type="text/template">
		<select name="tagSelect" class="form-control">
			<option value="">${message("business.deliveryTemplate.addTags")}</option>
			<%_.each(tagOptions, function(tagOption, i) {%>
				<option value="<%-tagOption.value%>"><%-tagOption.name%></option>
			<%})%>
		</select>
	</script>
	<script type="text/javascript">
	$().ready(function() {
		
		var $deliveryTemplateForm = $("#deliveryTemplateForm");
		var $content = $("#content");
		var $background = $("#background");
		var $width = $("#width");
		var $height = $("#height");
		var tagSelectTemplate = _.template($("#tagSelectTemplate").html());
		var tagOptions = [
			[#list storeAttributes as storeAttribute]
				{
					name: "${message("DeliveryTemplate.StoreAttribute." + storeAttribute)}",
					value: "${storeAttribute.tagName}"
				},
			[/#list]
			[#list deliveryCenterAttributes as deliveryCenterAttribute]
				{
					name: "${message("DeliveryTemplate.DeliveryCenterAttribute." + deliveryCenterAttribute)}",
					value: "${deliveryCenterAttribute.tagName}"
				},
			[/#list]
			[#list orderAttributes as orderAttribute]
				{
					name: "${message("DeliveryTemplate.OrderAttribute." + orderAttribute)}",
					value: "${orderAttribute.tagName}"
				}
				[#if orderAttribute_has_next],[/#if]
			[/#list]
		];
		var summernoteOptions = {
			width: ${deliveryTemplate.width},
			height: ${deliveryTemplate.height},
			tableClassName: "table table-dashed",
			insertTableMaxSize: {
				col: 30,
				row: 30
			},
			toolbar: [
				["addTags", ["addTags"]],
				["style", ["bold", "italic", "underline", "clear"]],
				["font", ["strikethrough", "superscript", "subscript"]],
				["fontname", ["fontname"]],
				["fontsize", ["fontsize"]],
				["color", ["color"]],
				["height", ["height"]],
				["para", ["ul", "ol", "paragraph"]],
				["insert", ["table", "picture", "hr"]],
				["view", ["codeview"]]
			],
			buttons: {
				addTags: function() {
					return tagSelectTemplate({
						tagOptions: tagOptions
					});
				}
			},
			hint: {
				words: $.map(tagOptions, function(tagOption) {
					return tagOption.value;
				}),
				match: /\B\{(\w*)$/,
				search: function(keyword, callback) {
					callback($.grep(this.words, function(item) {
						return item.indexOf(keyword) === 0;
					}));
				}
			},
			callbacks: {
				onInit: function() {
					$("[name='tagSelect']").selectpicker({
						width: "auto"
					}).on("change", function() {
						var $element = $(this);
						
						$content.summernote("insertText", $element.val());
					});
				}
			}
		}
		
		[#if flashMessage?has_content]
			$.alert("${flashMessage}");
		[/#if]
		
		// 内容
		$content.summernote(summernoteOptions);
		$content.data("summernote").layoutInfo.editable.css("background", "url(${deliveryTemplate.background?js_string}) 0px 0px no-repeat");
		
		// 背景图
		$background.data("file").on("fileuploaded", function(event, data, previewId, index) {
			refreshSummernote();
		});
		
		// 宽度、高度
		$width.add($height).on("input propertychange change", function() {
			refreshSummernote();
		});
		
		// 刷新文本编辑器
		function refreshSummernote() {
			var validator = $deliveryTemplateForm.validate();
			var code = $content.summernote("code");
			var width = $width.val();
			var height = $height.val();
			var background = $background.val();
			
			if (validator.element($width) && validator.element($height) && (summernoteOptions.width != width || summernoteOptions.height != height)) {
				$.extend(summernoteOptions, {
					width: width,
					height: height
				});
				if ($content.data("summernote") != null) {
					$content.summernote("destroy");
				}
				$content.summernote(summernoteOptions).summernote("code", code);
			}
			
			$content.data("summernote").layoutInfo.editable.css("background", "url(" + background + ") 0px 0px no-repeat");
		}
		
		$.validator.addMethod("notEmpty", function(value, element, param) {
			var $element = $(element);
			
			return $element.data("summernote") != null && !$element.summernote("isEmpty");
		}, "${message("business.deliveryTemplate.emptyNotAllow")}");
		
		// 表单验证
		$deliveryTemplateForm.validate({
			rules: {
				name: "required",
				content: "notEmpty",
				width: {
					required: true,
					integer: true,
					min: 1
				},
				height: {
					required: true,
					integer: true,
					min: 1
				},
				offsetX: {
					required: true,
					integer: true
				},
				offsetY: {
					required: true,
					integer: true
				}
			}
		});
	
	});
	</script>
</head>
<body class="hold-transition sidebar-mini">
	<div class="wrapper">
		[#include "/business/include/main_header.ftl" /]
		[#include "/business/include/main_sidebar.ftl" /]
		<div class="content-wrapper">
			<div class="container-fluid">
				<section class="content-header">
					<h1>${message("business.deliveryTemplate.edit")}</h1>
					<ol class="breadcrumb">
						<li>
							<a href="/shop/business/index">
								<i class="fa fa-home"></i>
								${message("business.common.index")}
							</a>
						</li>
						<li class="active">${message("business.deliveryTemplate.edit")}</li>
					</ol>
				</section>
				<section class="content">
					<div class="row">
						<div class="col-xs-12">
							<form id="deliveryTemplateForm" class="form-horizontal" action="${base}/business/delivery_template/update" method="post">
								<input name="deliveryTemplateId" type="hidden" value="${deliveryTemplate.id}">
								<div class="box">
									<div class="box-body">
										<div class="form-group">
											<label class="col-xs-2 control-label item-required" for="name">${message("DeliveryTemplate.name")}:</label>
											<div class="col-xs-4">
												<input id="name" name="name" class="form-control" type="text" value="${deliveryTemplate.name}" maxlength="200">
											</div>
										</div>
										<div class="form-group">
											<label class="col-xs-2 control-label item-required">${message("DeliveryTemplate.content")}:</label>
											<div class="col-xs-10">
												<textarea id="content" name="content">${deliveryTemplate.content}</textarea>
											</div>
										</div>
										<div class="form-group">
											<label class="col-xs-2 control-label">${message("DeliveryTemplate.background")}:</label>
											<div class="col-xs-4">
												<input id="background" name="background" type="hidden" value="${deliveryTemplate.background}" data-provide="fileinput" data-file-type="image" data-show-preview="false">
											</div>
										</div>
										<div class="form-group">
											<label class="col-xs-2 control-label item-required" for="width">${message("DeliveryTemplate.width")}:</label>
											<div class="col-xs-4">
												<input id="width" name="width" class="form-control" type="text" value="${deliveryTemplate.width}" maxlength="9">
											</div>
										</div>
										<div class="form-group">
											<label class="col-xs-2 control-label item-required" for="height">${message("DeliveryTemplate.height")}:</label>
											<div class="col-xs-4">
												<input id="height" name="height" class="form-control" type="text" value="${deliveryTemplate.height}" maxlength="9">
											</div>
										</div>
										<div class="form-group">
											<label class="col-xs-2 control-label item-required" for="offsetX">${message("DeliveryTemplate.offsetX")}:</label>
											<div class="col-xs-4">
												<input id="offsetX" name="offsetX" class="form-control" type="text" value="${deliveryTemplate.offsetX}" maxlength="9">
											</div>
										</div>
										<div class="form-group">
											<label class="col-xs-2 control-label item-required" for="offsetY">${message("DeliveryTemplate.offsetY")}:</label>
											<div class="col-xs-4">
												<input id="offsetY" name="offsetY" class="form-control" type="text" value="${deliveryTemplate.offsetY}" maxlength="9">
											</div>
										</div>
										<div class="form-group">
											<label for="isDefault" class="col-xs-2 control-label" for="isDefault">${message("DeliveryTemplate.isDefault")}:</label>
											<div class="col-xs-10 checkbox">
												<input id="isDefault" name="isDefault" type="text" value="${deliveryTemplate.isDefault?string("true", "false")}" data-toggle="checkbox-x">
											</div>
										</div>
										<div class="form-group">
											<label class="col-xs-2 control-label" for="memo">${message("DeliveryTemplate.memo")}:</label>
											<div class="col-xs-4">
												<input id="memo" name="memo" class="form-control" type="text" value="${deliveryTemplate.memo}" maxlength="200">
											</div>
										</div>
									</div>
									<div class="box-footer">
										<div class="row">
											<div class="col-xs-4 col-xs-offset-2">
												<button class="btn btn-primary" type="submit">${message("business.common.submit")}</button>
												<button class="btn btn-default" type="button" data-toggle="back">${message("business.common.back")}</button>
											</div>
										</div>
									</div>
								</div>
							</form>
						</div>
					</div>
				</section>
			</div>
		</div>
		[#include "/business/include/main_footer.ftl" /]
	</div>
</body>
</html>