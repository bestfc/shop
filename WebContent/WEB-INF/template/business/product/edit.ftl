<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("business.product.edit")} </title>
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
	<script src="${base}/resources/business/js/velocity.js"></script>
	<script src="${base}/resources/business/js/velocity.ui.js"></script>
	<script src="${base}/resources/business/js/summernote.js"></script>
	<script src="${base}/resources/business/js/sortable.js"></script>
	<script src="${base}/resources/business/js/jquery.validate.js"></script>
	<script src="${base}/resources/business/js/icheck.js"></script>
	<script src="${base}/resources/business/js/underscore.js"></script>
	<script src="${base}/resources/business/js/adminLTE.js"></script>
	<script src="${base}/resources/business/js/common.js"></script>
	<script id="productImageInputTemplate" type="text/template">
		<input name="productImages[<%-productImageIndex%>].source" type="hidden" value="<%-productImage.source%>">
		<input name="productImages[<%-productImageIndex%>].large" type="hidden" value="<%-productImage.large%>">
		<input name="productImages[<%-productImageIndex%>].medium" type="hidden" value="<%-productImage.medium%>">
		<input name="productImages[<%-productImageIndex%>].thumbnail" type="hidden" value="<%-productImage.thumbnail%>">
		<input name="productImages[<%-productImageIndex%>].order" type="hidden" value="<%-productImage.order%>">
	</script>
	<script id="addParameterGroupTemplate" type="text/template">
		<div class="item" data-parameter-index="<%-parameterIndex%>">
			<div class="form-group">
				<div class="col-xs-1 col-xs-offset-1 text-right">
					<p class="form-control-static">${message("Parameter.group")}:</p>
				</div>
				<div class="col-xs-4">
					<input name="parameterValues[<%-parameterIndex%>].group" class="parameter-group form-control" type="text" maxlength="200">
				</div>
				<div class="col-xs-6">
					<p class="form-control-static">
						<a class="remove group" href="javascript:;">[${message("business.common.delete")}]</a>
						<a class="add" href="javascript:;">[${message("business.common.add")}]</a>
					</p>
				</div>
			</div>
			<div class="form-group">
				<div class="col-xs-1 col-xs-offset-1">
					<input name="parameterValues[<%-parameterIndex%>].entries[<%-parameterEntryIndex%>].name" class="parameter-entry-name form-control text-right" type="text" maxlength="200">
				</div>
				<div class="col-xs-4">
					<input name="parameterValues[<%-parameterIndex%>].entries[<%-parameterEntryIndex%>].value" class="parameter-entry-value form-control" type="text" maxlength="200">
				</div>
				<div class="col-xs-6">
					<a class="remove" href="javascript:;">[${message("business.common.delete")}]</a>
				</div>
			</div>
		</div>
	</script>
	<script id="addParameterTemplate" type="text/template">
		<div class="form-group">
			<div class="col-xs-1 col-xs-offset-1">
				<input name="parameterValues[<%-parameterIndex%>].entries[<%-parameterEntryIndex%>].name" class="parameter-entry-name form-control" type="text" maxlength="200">
			</div>
			<div class="col-xs-4">
				<input name="parameterValues[<%-parameterIndex%>].entries[<%-parameterEntryIndex%>].value" class="parameter-entry-value form-control" type="text" maxlength="200">
			</div>
			<div class="col-xs-6">
				<a class="remove" href="javascript:;">[${message("business.common.delete")}]</a>
			</div>
		</div>
	</script>
	<script id="parameterGroupTemplate" type="text/template">
		<%_.each(parameters, function(parameter, i) {%>
			<div class="item" data-parameter-index="<%-parameterIndex%>">
				<div class="form-group">
					<div class="col-xs-1 col-xs-offset-1 text-right">
						<p class="form-control-static">${message("Parameter.group")}:</p>
					</div>
					<div class="col-xs-4">
						<input name="parameterValues[<%-parameterIndex%>].group" class="parameter-group form-control" type="text" value="<%-parameter.group%>" maxlength="200">
					</div>
					<div class="col-xs-6">
						<p class="form-control-static">
							<a class="remove group" href="javascript:;">[${message("business.common.delete")}]</a>
							<a class="add" href="javascript:;">[${message("business.common.add")}]</a>
						</p>
					</div>
				</div>
				<% var parameterEntryIndex = 0 %>
				<%_.each(parameter.names, function(name, i) {%>
					<div class="form-group">
						<div class="col-xs-1 col-xs-offset-1">
							<input name="parameterValues[<%-parameterIndex%>].entries[<%-parameterEntryIndex%>].name" class="parameter-entry-name form-control text-right" type="text" value="<%-name%>" maxlength="200">
						</div>
						<div class="col-xs-4">
							<input name="parameterValues[<%-parameterIndex%>].entries[<%-parameterEntryIndex%>].value" class="parameter-entry-value form-control" type="text" maxlength="200">
						</div>
						<div class="col-xs-6">
							<a class="remove" href="javascript:;">[${message("business.common.delete")}]</a>
						</div>
					</div>
					<% parameterEntryIndex ++ %>
				<%})%>
				<% parameterIndex ++ %>
			</div>
		<%})%>
	</script>
	<script id="attributeTemplate" type="text/template">
		<%_.each(attributes, function(attribute, i) {%>
			<div class="form-group">
				<label class="col-xs-2 control-label"><%-attribute.name%></label>
				<div class="col-xs-4">
					<select name="attribute_<%-attribute.id%>" class="form-control">
						<option value="">${message("business.common.choose")}</option>
						<%_.each(attribute.options, function(option, i) {%>
							<option value="<%-option%>"><%-option%></option>
						<%})%>
					</select>
				</div>
			</div>
		<%})%>
	</script>
	<script id="specificationTemplate" type="text/template">
		<%_.each(specifications, function(specification, i) {%>
			<div class="specification-item form-group">
				<div class="col-xs-2">
					<input name="specificationItems[<%-i%>].name" class="specification-item-name form-control text-right" type="text" value="<%-specification.name%>" data-value=<%-specification.name%>>
				</div>
				<div class="col-xs-10">
					<div class="row">
						<%_.each(specification.options, function(option, j) {%>
							<div class="col-xs-2">
								<div class="input-group">
									<span class="input-group-addon">
										<input name="specificationItems[<%-i%>].entries[<%-j%>].isSelected" class="icheckd" type="checkbox" value="true">
									</span>
									<input name="specificationItems[<%-i%>].entries[<%-j%>].value" class="specification-item-entry-value form-control" type="text" value="<%-option%>" data-value=<%-specification.name%>>
									<input name="_specificationItems[<%-i%>].entries[<%-j%>].isSelected" type="hidden" value="false">
									<input name="specificationItems[<%-i%>].entries[<%-j%>].id" class="specification-item-entry-id" type="hidden" value="<%-_.uniqueId()%>">
								</div>
							</div>
						<%})%>
					</div>
				</div>
			</div>
		<%})%>
	</script>
	<script id="skuTemplate" type="text/template">
		<table class="table table-hover">
			<thead>
				<tr>
					<%_.each(specificationItems, function(specificationItem, i) {%>
						<th><%-specificationItem.name%></th>
					<%})%>
					[#if product.type == "general"]
						<th>${message("Sku.price")}</th>
					[/#if]
					<th>${message("Sku.cost")}</th>
					<th>${message("Sku.marketPrice")}</th>
					[#if product.type == "general"]
						<th>${message("Sku.rewardPoint")}</th>
					[/#if]
					[#if product.type == "exchange"]
						<th>${message("Sku.exchangePoint")}</th>
					[/#if]
					<th>${message("Sku.stock")}</th>
					<th>${message("Sku.isDefault")}</th>
					<th>${message("business.product.isEnabled")}</th>
				</tr>
			</thead>
			<tbody>
				<%_.each(skus, function(entries, i) {%>
					<%
						var ids = [];
						_.each(entries, function(entry, j) {
							ids.push(entry.id);
						});
						var initSkuValue = initSkuValues[ids.join(",")];
					%>
					<tr data-ids="<%-ids.join(",")%>" <%if (initSkuValue != null) {%>title="${message("Sku.sn")}: <%-initSkuValue.sn%>"<%}%>>
						<%
							var skuValue = skuValues[ids.join(",")];
							var price = skuValue != null && skuValue.price != null ? skuValue.price : "";
							var cost = skuValue != null && skuValue.cost != null ? skuValue.cost : "";
							var marketPrice = skuValue != null && skuValue.marketPrice != null ? skuValue.marketPrice : "";
							var rewardPoint = skuValue != null && skuValue.rewardPoint != null ? skuValue.rewardPoint : "";
							var exchangePoint = skuValue != null && skuValue.exchangePoint != null ? skuValue.exchangePoint : "";
							var stock = skuValue != null && skuValue.stock != null ? skuValue.stock : "";
							var isDefault = skuValue != null && skuValue.isDefault != null ? skuValue.isDefault : false;
							var isEnabled = skuValue != null && skuValue.isEnabled != null ? skuValue.isEnabled : false;
						%>
						<%_.each(entries, function(entry, j) {%>
							<td>
								<p class="form-control-static"><%-entry.value%></p>
								<input name="skuList[<%-i%>].specificationValues[<%-j%>].id" type="hidden" value="<%-entry.id%>">
								<input name="skuList[<%-i%>].specificationValues[<%-j%>].value" type="hidden" value="<%-entry.value%>">
							</td>
						<%})%>
						[#if product.type == "general"]
							<td>
								<input name="skuList[<%-i%>].price" class="price form-control" type="text" value="<%-price%>" maxlength="16"<%-!isEnabled ? " disabled" : ""%>>
							</td>
						[/#if]
						<td>
							<input name="skuList[<%-i%>].cost" class="cost form-control" type="text" value="<%-cost%>" maxlength="16"<%-!isEnabled ? " disabled" : ""%>>
						</td>
						<td>
							<input name="skuList[<%-i%>].marketPrice" class="market-price form-control" type="text" value="<%-marketPrice%>" maxlength="16"<%-!isEnabled ? " disabled" : ""%>>
						</td>
						[#if product.type == "general"]
							<td>
								<input name="skuList[<%-i%>].rewardPoint" class="reward-point form-control" type="text" value="<%-rewardPoint%>" maxlength="9"<%-!isEnabled ? " disabled" : ""%>>
							</td>
						[/#if]
						[#if product.type == "exchange"]
							<td>
								<input name="skuList[<%-i%>].exchangePoint" class="exchange-point form-control" type="text" value="<%-exchangePoint%>" maxlength="9"<%-!isEnabled ? " disabled" : ""%>>
							</td>
						[/#if]
						<td>
							<%if (initSkuValue != null) {%>
								<div class="input-group">
									<input name="skuList[<%-i%>].stock" class="stock form-control" type="text" value="<%-initSkuValue.stock%>" maxlength="9" title="${message("Sku.allocatedStock")}: <%-initSkuValue.allocatedStock%>" readonly>
									<div class="input-group-btn">
										<a class="sn btn btn-default" href="../stock/stock_in?skuSn=<%-initSkuValue.sn%>" title="${message("business.product.stockIn")}">+</a>
										<a class="sn btn btn-default" href="../stock/stock_out?skuSn=<%-initSkuValue.sn%>" title="${message("business.product.stockOut")}">-</a>
									</div>
								</div>
							<%} else {%>
								<input name="skuList[<%-i%>].stock" class="stock form-control" type="text" value="<%-stock%>" maxlength="9"<%-!isEnabled ? " disabled" : ""%>>
							<%}%>
						</td>
						<td>
							<input name="skuList[<%-i%>].isDefault" class="is-default" type="checkbox" value="true"<%-isDefault ? " checked" : ""%><%-!isEnabled ? " disabled" : ""%>>
							<input name="_skuList[<%-i%>].isDefault" type="hidden" value="false">
						</td>
						<td>
							<input name="isEnabled" class="is-enabled" type="checkbox" value="true"<%-isEnabled ? " checked" : ""%>>
						</td>
					</tr>
				<%})%>
			</tbody>
		</table>
	</script>
	<script type="text/javascript">
		$().ready(function() {
			
			var $productForm = $("#productForm");
			var $isDefault = $("#isDefault");
			var $productCategoryId = $("#productCategoryId");
			var $confirmButton = $("#confirmButton");
			var $dismissButton = $("#dismissButton");
			var $price = $("#price");
			var $cost = $("#cost");
			var $marketPrice = $("#marketPrice");
			var $rewardPoint = $("#rewardPoint");
			var $exchangePoint = $("#exchangePoint");
			var $stock = $("#stock");
			var $promotionIds = $("input[name='promotionIds']");
			var $productImage = $("#productImage");
			var $productImageFile = $("#productImage input:file");
			var $parameter = $("#parameter");
			var $addParameterButton = $("#addParameterButton");
			var $resetParameterButton = $("#resetParameterButton");
			var $parameterContent = $("#parameterContent");
			var $attribute = $("#attribute");
			var $resetSpecificationButton = $("#resetSpecificationButton");
			var $specificationContent = $("#specificationContent");
			var $sku = $("#sku");
			var productImageInputTemplate = _.template($("#productImageInputTemplate").html());
			var addParameterGroupTemplate = _.template($("#addParameterGroupTemplate").html());
			var addParameterTemplate = _.template($("#addParameterTemplate").html());
			var parameterGroupTemplate = _.template($("#parameterGroupTemplate").html());
			var attributeTemplate = _.template($("#attributeTemplate").html());
			var specificationTemplate = _.template($("#specificationTemplate").html());
			var skuTemplate = _.template($("#skuTemplate").html());
			var previousProductCategoryId = ${product.productCategory.id};
			var productImageIndex = 0;
			var parameterIndex = ${(product.parameterValues?size)!0};
			var parameterEntryIndex = 0;
			var hasSpecification = ${product.hasSpecification()?string("true", "false")};
			var productImages = [];
			var initSkuValues = {};
			
			[#if flashMessage?has_content]
				$.alert("${flashMessage}");
			[/#if]
			
			productImages = [
				[#list product.productImages as productImage]
					{
						source: "${productImage.source?js_string}",
						large: "${productImage.large?js_string}",
						medium: "${productImage.medium?js_string}",
						thumbnail: "${productImage.thumbnail?js_string}",
						order: "${productImage.order?js_string}"
					}[#if productImage_has_next],[/#if]
				[/#list]
			];
			
			[#if !product.parameterValues?has_content]
				loadParameter();
			[/#if]
			
			[#if product.hasSpecification()]
				[#list product.skus as sku]
					initSkuValues["${sku.specificationValueIds?join(",")}"] = {
						id: ${sku.id},
						sn: "${sku.sn}",
						price: ${sku.price},
						cost: ${sku.cost!"null"},
						marketPrice: ${sku.marketPrice},
						rewardPoint: ${sku.rewardPoint},
						exchangePoint: ${sku.exchangePoint},
						stock: ${sku.stock},
						allocatedStock: ${sku.allocatedStock},
						isDefault: ${sku.isDefault?string("true", "false")},
						isEnabled: true
					};
				[/#list]
				buildSkuTable(initSkuValues);
			[#else]
				loadSpecification();
			[/#if]
			
			// 商品分类
			$productCategoryId.change(function() {
				if (!isEmpty($attribute.find("select"))) {
					$("#resetAttributeModal").modal();
					$confirmButton.click(function() {
						if (isEmpty($parameterContent.find("input.parameter-entry-value"))) {
							loadParameter();
						}
						loadAttribute();
						if (isEmpty($sku.find("input:text"))) {
							loadSpecification();
						}
						previousProductCategoryId = $productCategoryId.val();
					});
					$dismissButton.click(function() {
						$productCategoryId.val(previousProductCategoryId);
					});
				} else {
					if (isEmpty($parameterContent.find("input.parameter-entry-value"))) {
						loadParameter();
					}
					loadAttribute();
					if (isEmpty($sku.find("input:text"))) {
						loadSpecification();
					}
					previousProductCategoryId = $productCategoryId.val();
				}
			});
			
			// 判断是否为空
			function isEmpty($elements) {
				var isEmpty = true;
				
				$elements.each(function() {
					var $element = $(this);
					if ($.trim($element.val()) != "") {
						isEmpty = false;
						return false;
					}
				});
				return isEmpty;
			}
			
			// 修改视图
			function changeView() {
				if (hasSpecification) {
					$isDefault.prop("disabled", true);
					$price.add($cost).add($marketPrice).add($rewardPoint).add($exchangePoint).add($stock).prop("disabled", true).closest("div.form-group").velocity("slideUp");
				} else {
					$isDefault.prop("disabled", false);
					$price.add($cost).add($marketPrice).add($rewardPoint).add($exchangePoint).add($stock).prop("disabled", false).closest("div.form-group").velocity("slideUp");
				}
			}
			
			// 商品图片
			$productImageFile.fileinput({
				uploadUrl: "${base}/business/product/upload_product_image",
				allowedFileExtensions: "${setting.uploadImageExtension}".split(","),
				[#if setting.uploadMaxSize != 0]
					maxFileSize: ${setting.uploadMaxSize} * 1024,
				[/#if]
				showRemove: false,
				showClose: false,
				dropZoneEnabled: false,
				overwriteInitial: false,
				previewClass: "multiple-file-preview",
				previewThumbTags: {
					"{inputs}": function() {
						return productImageInputTemplate({
							productImageIndex: productImageIndex ++
						});
					}
				},
				layoutTemplates: {
					footer: '<div class="file-thumbnail-footer">{inputs}{actions}</div>',
					actions: '<div class="file-actions"><div class="file-footer-buttons">{upload} {delete} {zoom} {other}</div></div>'
				},
				initialPreviewAsData: true,
				initialPreview: $.map(productImages, function(productImage) {
					return productImage.large;
				}),
				initialPreviewConfig: $.map(productImages, function(productImage, i) {
					return {
						url: "${base}/business/product/delete_product_image",
						key: i
					}
				}),
				initialPreviewThumbTags: $.map(productImages, function(productImage) {
					return {
						"{inputs}": productImageInputTemplate({
							productImageIndex: productImageIndex ++,
							productImage: productImage
						})
					}
				}),
				fileActionSettings: {
					showUpload: false,
					showRemove: true,
					showDrag: false
				},
				removeFromPreviewOnError: true,
				showAjaxErrorDetails: false
			}).on("fileuploaded", function(event, data, previewId, index) {
				var $preview = $("#" + previewId);
				var productImage = data.response;
				
				$preview.find("input[name$='.source']").val(productImage.source);
				$preview.find("input[name$='.large']").val(productImage.large);
				$preview.find("input[name$='.medium']").val(productImage.medium);
				$preview.find("input[name$='.thumbnail']").val(productImage.thumbnail);
			});
			
			// 商品图片排序
			Sortable.create($productImage.find(".file-preview-thumbnails")[0], {
				animation: 300
			});
			
			// 增加参数
			$addParameterButton.click(function() {
				var parameterIndex = $parameterContent.children(".item").size();
				$parameterContent.append(addParameterGroupTemplate({
					parameterIndex: parameterIndex,
					parameterEntryIndex: parameterEntryIndex
				}));
			});
			
			// 重置参数
			$resetParameterButton.click(function() {
				loadParameter();
			});
			
			// 删除参数
			$parameterContent.on("click", "a.remove", function() {
				var $element = $(this);
				
				if ($element.hasClass("group")) {
					$element.closest("div.item").velocity("fadeOut", {
						complete: function() {
							$(this).remove();
						}
					});
				} else {
					if ($element.closest("div.item").find("div.form-group").size() <= 2) {
						$.alert("${message("business.product.deleteAllNotAllowed")}");
						return false;
					}
					$element.closest("div.form-group").velocity("fadeOut", {
						complete: function() {
							$(this).remove();
						}
					});
				}
			});
			
			// 添加参数
			$parameterContent.on("click", "a.add", function() {
				var $element = $(this);
				var $item = $element.closest(".item");
				var parameterIndex = $item.data("parameter-index");
				var parameterEntryIndex = ($item.find(".form-group").size())-1;
				
				$item.append(addParameterTemplate({
					parameterIndex: parameterIndex,
					parameterEntryIndex: parameterEntryIndex
				}));
			});
			
			// 加载参数
			function loadParameter() {
				$.ajax({
					url: "${base}/business/product/parameters",
					type: "GET",
					data: {
						productCategoryId: $productCategoryId.val()
					},
					dataType: "json",
					success: function(parameters) {
						$parameterContent.html(parameterGroupTemplate({
							parameters: parameters,
							parameterIndex: parameterIndex
						}));
					}
				});
			}
			
			// 加载属性
			function loadAttribute() {
				$.ajax({
					url: "${base}/business/product/attributes",
					type: "GET",
					data: {
						productCategoryId: $productCategoryId.val()
					},
					dataType: "json",
					success: function(attributes) {
						$attribute.html(attributeTemplate({
							attributes: attributes
						}));
					}
				});
			}
			
			// 重置规格
			$resetSpecificationButton.click(function() {
				hasSpecification = false;
				changeView();
				loadSpecification();
			});
			
			// 选择规格
			$specificationContent.on("ifChanged", "input.icheckd", function() {
				hasSpecification = $specificationContent.find("input:checkbox:checked").size() > 0;
				changeView();
				buildSkuTable();
				if ($sku.find("input.is-default:not(:disabled):checked").size() == 0) {
					$sku.find("input.is-default:not(:disabled):first").prop("checked", true);
				}
			});
			
			// 规格
			$specificationContent.on("change", "input:text", function() {
				var $element = $(this);
				var value = $.trim($element.val());
				
				if (value == "") {
					$element.val($element.data("value"));
					return false;
				}
				if ($element.hasClass("specification-item-entry-value")) {
					var values = $element.closest("div.specification-item").find("input.specification-item-entry-value").not($element).map(function() {
						return $.trim($(this).val());
					}).get();
					if ($.inArray(value, values) >= 0) {
						$.alert("${message("business.product.specificationItemEntryValueRepeated")}");
						$element.val($element.data("value"));
						return false;
					}
				}
				$element.data("value", value);
				buildSkuTable();
			});
			
			// 是否默认
			$sku.on("change", "input.is-default", function() {
				var $element = $(this);
				
				if ($element.prop("checked")) {
					$sku.find("input.is-default").not($element).prop("checked", false);
				} else {
					$element.prop("checked", true);
				}
			});
			
			// 是否启用
			$sku.on("change", "input.is-enabled", function() {
				var $element = $(this);
				
				if ($element.prop("checked")) {
					$element.closest("tr").find("input:not(input.is-enabled)").prop("disabled", false);
				} else {
					$element.closest("tr").find("input:not(input.is-enabled)").prop("disabled", true).end().find("input.is-default").prop("checked", false);
				}
				if ($sku.find("input.is-default:not(:disabled):checked").size() == 0) {
					$sku.find("input.is-default:not(:disabled):first").prop("checked", true);
				}
			});
			
			// 生成SKU表
			function buildSkuTable(skuValues) {
				var specificationItems = [];
				
				if (!hasSpecification) {
					$sku.empty()
					return false;
				}
				$specificationContent.find("div.specification-item").each(function() {
					var $element = $(this);
					var $checked = $element.find("input:checkbox:checked");
					
					if ($checked.size() > 0) {
						var specificationItem = {};
						specificationItem.name = $element.find("input.specification-item-name").val();
						specificationItem.entries = $checked.map(function() {
							var $element = $(this);
							return {
								id: $element.closest("div.input-group").find("input.specification-item-entry-id").val(),
								value: $element.closest("div.input-group").find("input.specification-item-entry-value").val()
							};
						}).get();
						specificationItems.push(specificationItem);
					}
				});
				var skus = cartesianSkuOf($.map(specificationItems, function(specificationItem) {
					return [specificationItem.entries];
				}));
				if (skuValues == null) {
					skuValues = {};
					$sku.find("tr").each(function() {
						var $element = $(this);
						skuValues[$element.data("ids")] = {
							sn: $element.find("a.sn").data("id"),
							price: $element.find("input.price").val(),
							cost: $element.find("input.cost").val(),
							marketPrice: $element.find("input.market-price").val(),
							rewardPoint: $element.find("input.reward-point").val(),
							exchangePoint: $element.find("input.exchange-point").val(),
							stock: $element.find("input.stock").val(),
							isDefault: $element.find("input.is-default").prop("checked"),
							isEnabled: $element.find("input.is-enabled").prop("checked")
						};
					});
				}
				$sku.html(skuTemplate({
					initSkuValues: initSkuValues,
					specificationItems: specificationItems,
					skus: skus,
					skuValues: skuValues
				}));
			}
			
			// 笛卡尔积
			function cartesianSkuOf(array) {
				function addTo(current, args) {
					var i, copy;
					var rest = args.slice(1);
					var isLast = !rest.length;
					var result = [];
					for (i = 0; i < args[0].length; i++) {
						copy = current.slice();
						copy.push(args[0][i]);
						if (isLast) {
							result.push(copy);
						} else {
							result = result.concat(addTo(copy, rest));
						}
					}
					return result;
				}
				return addTo([], array);
			}
			
			// 加载规格
			function loadSpecification() {
				$.ajax({
					url: "${base}/business/product/specifications",
					type: "GET",
					data: {
						productCategoryId: $productCategoryId.val()
					},
					dataType: "json",
					success: function(specifications) {
						$specificationContent.html(specificationTemplate({
							specifications: specifications
						}));
						$sku.empty();
					},
					complete: function() {
						var $icheckd = $("input.icheckd");
						$icheckd.iCheck({
							checkboxClass: "icheckbox-flat-blue",
							radioClass: "iradio-flat-blue"
						});
					}
				});
			}
			
			$.validator.addClassRules({
				"parameter-group": {
					required: true
				},
				price: {
					required: true,
					min: 0,
					decimal: {
						integer: 12,
						fraction: ${setting.priceScale}
					}
				},
				cost: {
					min: 0,
					decimal: {
						integer: 12,
						fraction: ${setting.priceScale}
					}
				},
				"market-price": {
					min: 0,
					decimal: {
						integer: 12,
						fraction: ${setting.priceScale}
					}
				},
				"reward-point": {
					digits: true,
					max: function(element) {
						var $element = $(element);
						var price = $element.closest("tr").find("input.price").val();
						return $.isNumeric(price) ? parseInt(price * ${setting.maxPointScale}) : 999999999;
					}
				},
				"exchange-point": {
					required: true,
					digits: true
				},
				stock: {
					required: true,
					digits: true
				}
			});
			
			// 表单验证
			$productForm.validate({
				rules: {
					productCategoryId: "required",
					name: "required",
					"sku.price": {
						required: true,
						min: 0,
						decimal: {
							integer: 12,
							fraction: ${setting.priceScale}
						}
					},
					"sku.cost": {
						min: 0,
						decimal: {
							integer: 12,
							fraction: ${setting.priceScale}
						}
					},
					"sku.marketPrice": {
						min: 0,
						decimal: {
							integer: 12,
							fraction: ${setting.priceScale}
						}
					},
					weight: "digits",
					"sku.rewardPoint": {
						digits: true,
						max: function() {
							return parseInt($price.val() * ${setting.maxPointScale});
						}
					},
					"sku.exchangePoint": {
						digits: true,
						required: true
					},
					"sku.stock": {
						required: true,
						digits: true
					}
				},
				messages: {
					sn: {
						pattern: "${message("common.validate.illegal")}",
						remote: "${message("common.validate.exist")}"
					}
				},
				submitHandler: function(form) {
					if (hasSpecification && $sku.find("input.is-enabled:checked").size() < 1) {
						$.alert("${message("business.product.specificationSkuRequired")}");
						return false;
					}
					if ($productImageFile.fileinput("getFileStack").length > 0) {
						$.alert("${message("business.product.productImageUnupload")}");
						return false;
					}
					$productImage.find(".kv-preview-thumb input[name$='.order']").each(function(i) {
						$(this).val(i);
					});
					$productImage.find(".kv-zoom-thumb input").each(function() {
						$(this).prop("disabled", true);
					});
					addCookie("previousProductCategoryId", $productCategoryId.val(), {
						expires: 24 * 60 * 60
					});
					$(form).find("button:submit").prop("disabled", true);
					form.submit();
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
					<h1>${message("business.product.edit")}</h1>
					<ol class="breadcrumb">
						<li>
							<a href="/shop/business/index">
								<i class="fa fa-home"></i>
								${message("business.common.index")}
							</a>
						</li>
						<li class="active">${message("business.product.edit")}</li>
					</ol>
				</section>
				<section class="content">
					<div class="row">
						<div class="col-xs-12">
							<form id="productForm" class="form-horizontal" action="${base}/business/product/update" method="post">
								<input name="productId" type="hidden" value="${product.id}">
								<input id="isDefault" name="sku.isDefault" type="hidden" value="true">
								<div class="box">
									<div class="box-body">
										<div id="resetParameterModal" class="modal fade" tabindex="-1">
											<div class="modal-dialog">
												<div class="modal-content">
													<div class="modal-header">
														<button class="close" type="button" data-dismiss="modal">&times;</button>
													</div>
													<div class="modal-body">
														<p>${message("business.product.resetParameterConfirm")}</p>
													</div>
													<div class="modal-footer">
														<button id="resetParameterButton" class="btn btn-primary" type="button" data-dismiss="modal">${message("business.common.ok")}</button>
														<button class="btn btn-default" type="button" data-dismiss="modal">${message("business.common.cancel")}</button>
													</div>
												</div>
											</div>
										</div>
										<div id="resetSpecificationModal" class="modal fade" tabindex="-1">
											<div class="modal-dialog">
												<div class="modal-content">
													<div class="modal-header">
														<button class="close" type="button" data-dismiss="modal">&times;</button>
													</div>
													<div class="modal-body">
														<p>${message("business.product.resetSpecificationConfirm")}</p>
													</div>
													<div class="modal-footer">
														<button id="resetSpecificationButton" class="btn btn-primary" type="button" data-dismiss="modal">${message("business.common.ok")}</button>
														<button class="btn btn-default" type="button" data-dismiss="modal">${message("business.common.cancel")}</button>
													</div>
												</div>
											</div>
										</div>
										<div id="resetAttributeModal" class="modal fade" tabindex="-1">
											<div class="modal-dialog">
												<div class="modal-content">
													<div class="modal-header">
														<button class="close" type="button" data-dismiss="modal">&times;</button>
													</div>
													<div class="modal-body">
														<p>${message("business.product.productCategoryChangeConfirm")}</p>
													</div>
													<div class="modal-footer">
														<button id="confirmButton" class="btn btn-primary" type="button" data-dismiss="modal">${message("business.common.ok")}</button>
														<button id="dismissButton" class="btn btn-default" type="button" data-dismiss="modal">${message("business.common.cancel")}</button>
													</div>
												</div>
											</div>
										</div>
										<ul class="nav nav-tabs">
											<li class="active">
												<a href="#base" data-toggle="tab">${message("business.product.base")}</a>
											</li>
											<li>
												<a href="#introduction" data-toggle="tab">${message("business.product.introduction")}</a>
											</li>
											<li>
												<a href="#productImage" data-toggle="tab">${message("business.product.productImage")}</a>
											</li>
											<li>
												<a href="#parameter" data-toggle="tab">${message("business.product.parameter")}</a>
											</li>
											<li>
												<a href="#attribute" data-toggle="tab">${message("business.product.attribute")}</a>
											</li>
											<li>
												<a href="#specification" data-toggle="tab">${message("business.product.specification")}</a>
											</li>
										</ul>
										<div class="tab-content">
											<div id="base" class="tab-pane active">
												<div class="form-group">
													<label class="col-xs-2 control-label">${message("Product.productCategory")}:</label>
													<div class="col-xs-4">
														<select id="productCategoryId" name="productCategoryId" class="selectpicker form-control" data-live-search="true" data-size="10">
															<option value="">${message("business.common.choose")}</option>
															[#list productCategoryTree as productCategory]
																[#if allowedProductCategories?seq_contains(productCategory) || allowedProductCategoryParents?seq_contains(productCategory)]
																	<option value="${productCategory.id}" title="${productCategory.name}"[#if productCategory == product.productCategory] selected[/#if][#if !allowedProductCategories?seq_contains(productCategory)] disabled[/#if]>
																		[#if productCategory.grade != 0]
																			[#list 1..productCategory.grade as i]
																				&nbsp;&nbsp;
																			[/#list]
																		[/#if]
																		${productCategory.name}
																	</option>
																[/#if]
															[/#list]
														</select>
													</div>
												</div>
												<div class="form-group">
													<label class="col-xs-2 control-label">${message("Product.storeProductCategory")}:</label>
													<div class="col-xs-4">
														<select name="storeProductCategoryId" class="selectpicker form-control" data-live-search="true" data-size="10">
															<option value="">${message("business.common.choose")}</option>
															[#list storeProductCategoryTree as storeProductCategory]
																<option value="${storeProductCategory.id}" title="${storeProductCategory.name}"[#if storeProductCategory == product.storeProductCategory] selected[/#if]>
																	[#if storeProductCategory.grade != 0]
																		[#list 1..storeProductCategory.grade as i]
																			&nbsp;&nbsp;
																		[/#list]
																	[/#if]
																	${storeProductCategory.name}
																</option>
															[/#list]
														</select>
													</div>
												</div>
												<div class="form-group">
													<label class="col-xs-2 control-label">${message("Product.type")}:</label>
													<div class="col-xs-4">
														<p class="form-control-static">${message("Product.Type." + product.type)}</p>
													</div>
												</div>
												<div class="form-group">
													<label class="col-xs-2 control-label">${message("Product.sn")}:</label>
													<div class="col-xs-4">
														<p class="form-control-static">${product.sn}</p>
													</div>
												</div>
												<div class="form-group">
													<label class="col-xs-2 control-label item-required" for="name">${message("Product.name")}:</label>
													<div class="col-xs-4">
														<input id="name" name="name" class="form-control" type="text" value="${product.name}" maxlength="200">
													</div>
												</div>
												<div class="form-group">
													<label class="col-xs-2 control-label" for="caption">${message("Product.caption")}:</label>
													<div class="col-xs-4">
														<input id="caption" name="caption" class="form-control" type="text" value="${product.caption}" maxlength="200">
													</div>
												</div>
												[#if product.type == "general"]
													<div class="form-group[#if product.hasSpecification()] hidden[/#if]">
														<label class="col-xs-2 control-label item-required" for="price">${message("Sku.price")}:</label>
														<div class="col-xs-4">
															<input id="price" name="sku.price" class="form-control" type="text" value="${product.defaultSku.price}" maxlength="16"[#if product.hasSpecification()] disabled[/#if]>
														</div>
													</div>
												[/#if]
												<div class="form-group[#if product.hasSpecification()] hidden[/#if]">
													<label class="col-xs-2 control-label" for="cost">${message("Sku.cost")}:</label>
													<div class="col-xs-4">
														<input id="cost" name="sku.cost" class="form-control" type="text" value="${product.defaultSku.cost}" maxlength="16" title="${message("business.product.costTitle")}"[#if product.hasSpecification()] disabled[/#if]>
													</div>
												</div>
												<div class="form-group[#if product.hasSpecification()] hidden[/#if]">
													<label class="col-xs-2 control-label" for="marketPrice">${message("Sku.marketPrice")}:</label>
													<div class="col-xs-4">
														<input id="marketPrice" name="sku.marketPrice" class="form-control" type="text" value="${product.defaultSku.marketPrice}" maxlength="16" title="${message("business.product.marketPriceTitle")}"[#if product.hasSpecification()] disabled[/#if]>
													</div>
												</div>
												<div class="form-group">
													<label class="col-xs-2 control-label">${message("Product.image")}:</label>
													<div class="col-xs-4">
														<input name="image" type="hidden" value="${product.image}" data-provide="fileinput" data-file-type="image">
													</div>
												</div>
												<div class="form-group">
													<label class="col-xs-2 control-label" for="unit">${message("Product.unit")}:</label>
													<div class="col-xs-4">
														<input id="unit" name="unit" class="form-control" type="text" value="${product.unit}" maxlength="200">
													</div>
												</div>
												<div class="form-group">
													<label class="col-xs-2 control-label" for="weight">${message("Product.weight")}:</label>
													<div class="col-xs-4">
														<input id="weight" name="weight" class="form-control" type="text" value="${product.weight}" maxlength="9" title="${message("business.product.weightTitle")}">
													</div>
												</div>
												[#if product.type == "general"]
													<div class="form-group[#if product.hasSpecification()] hidden[/#if]">
														<label class="col-xs-2 control-label" for="rewardPoint">${message("Sku.rewardPoint")}:</label>
														<div class="col-xs-4">
															<input id="rewardPoint" name="sku.rewardPoint" class="form-control" type="text" value="${product.defaultSku.rewardPoint}" maxlength="9" title="${message("business.product.rewardPointTitle")}"[#if product.hasSpecification()] disabled[/#if]>
														</div>
													</div>
												[/#if]
												[#if product.type == "exchange"]
													<div class="form-group[#if product.hasSpecification()] hidden[/#if]">
														<label class="col-xs-2 control-label item-required" for="exchangePoint">${message("Sku.exchangePoint")}:</label>
														<div class="col-xs-4">
															<input id="exchangePoint" name="sku.exchangePoint" class="form-control" type="text" value="${product.defaultSku.exchangePoint}" maxlength="9"[#if product.hasSpecification()] disabled[/#if]>
														</div>
													</div>
												[/#if]
												[#if product.hasSpecification()]
													<div class="form-group hidden">
														<label class="col-xs-2 control-label item-required" for="stock">${message("Sku.stock")}:</label>
														<div class="col-xs-4">
															<input id="stock" name="sku.stock" class="form-control" type="text" value="1" maxlength="9" disabled>
														</div>
													</div>
												[#else]
													<div class="form-group">
														<label class="col-xs-2 control-label" for="stock">${message("Sku.stock")}:</label>
														<div class="col-xs-4">
															<div class="input-group">
																<input id="stock" name="sku.stock" class="form-control" type="text" value="${product.defaultSku.stock}" maxlength="9" title="${message("Sku.allocatedStock")}: ${product.defaultSku.allocatedStock}" readonly>
																<div class="input-group-btn">
																	<a class="btn btn-default" href="../stock/stock_in?skuSn=${product.defaultSku.sn}" title="${message("business.product.stockIn")}">+</a>
																	<a class="btn btn-default" href="../stock/stock_out?skuSn=${product.defaultSku.sn}" title="${message("business.product.stockOut")}">-</a>
																</div>
															</div>
														</div>
													</div>
												[/#if]
												<div class="form-group">
													<label class="col-xs-2 control-label">${message("Product.brand")}:</label>
													<div class="col-xs-4">
														<select name="brandId" class="selectpicker form-control" data-live-search="true" data-size="10">
															<option value="">${message("business.common.choose")}</option>
															[#list brands as brand]
																<option value="${brand.id}"[#if brand == product.brand] selected[/#if]>${brand.name}</option>
															[/#list]
														</select>
													</div>
												</div>
												[#if product.type == "general" && promotions?has_content]
													<div class="form-group">
														<label class="col-xs-2 control-label">${message("Product.promotions")}:</label>
														<div class="col-xs-10">
															[#list promotions as promotion]
																<label class="checkbox-inline" title="${promotion.name}">
																	<input name="promotionIds" class="icheck" type="checkbox" value="${promotion.id}"[#if product.promotions?seq_contains(promotion)] checked[/#if]>
																	${promotion.name}
																</label>
															[/#list]
														</div>
													</div>
												[/#if]
												[#if productTags?has_content]
													<div class="form-group">
														<label class="col-xs-2 control-label item-required">${message("Product.productTags")}:</label>
														<div class="col-xs-10">
															[#list productTags as productTag]
																<label class="checkbox-inline">
																	<input name="productTagIds" class="icheck" type="checkbox" value="${productTag.id}"[#if product.productTags?seq_contains(productTag)] checked[/#if]>
																	${productTag.name}
																</label>
															[/#list]
														</div>
													</div>
												[/#if]
												[#if storeProductTags?has_content]
													<div class="form-group">
														<label class="col-xs-2 control-label item-required">${message("Product.storeProductTags")}:</label>
														<div class="col-xs-10">
															[#list storeProductTags as storeProductTag]
																<label class="checkbox-inline">
																	<input name="storeProductTagIds" class="icheck" type="checkbox" value="${storeProductTag.id}"[#if product.storeProductTags?seq_contains(storeProductTag)] checked[/#if]>
																	${storeProductTag.name}
																</label>
															[/#list]
														</div>
													</div>
												[/#if]
												<div class="form-group">
													<label class="col-xs-2 control-label">${message("business.common.setting")}:</label>
													<div class="col-xs-10 checkbox">
														<input id="isMarketable" name="isMarketable" type="text" value="${product.isMarketable?string("true", "false")}" data-toggle="checkbox-x">
														<label for="isMarketable" class="cbx-label">${message("Product.isMarketable")}</label>
														<input id="isList" name="isList" type="text" value="${product.isList?string("true", "false")}" data-toggle="checkbox-x">
														<label for="isList" class="cbx-label">${message("Product.isList")}</label>
														<input id="isTop" name="isTop" type="text" value="${product.isTop?string("true", "false")}" data-toggle="checkbox-x">
														<label for="isTop" class="cbx-label">${message("Product.isTop")}</label>
														<input id="isDelivery" name="isDelivery" type="text" value="${product.isDelivery?string("true", "false")}" data-toggle="checkbox-x">
														<label for="isDelivery" class="cbx-label">${message("Product.isDelivery")}</label>
													</div>
												</div>
												<div class="form-group">
													<label class="col-xs-2 control-label" for="memo">${message("Product.memo")}:</label>
													<div class="col-xs-4">
														<input id="memo" name="memo" class="form-control" type="text" value="${product.memo}" maxlength="200">
													</div>
												</div>
												<div class="form-group">
													<label class="col-xs-2 control-label" for="keyword">${message("Product.keyword")}:</label>
													<div class="col-xs-4">
														<input id="keyword" name="keyword" class="form-control" type="text" value="${product.keyword}" maxlength="200" title="${message("business.product.keywordTitle")}">
													</div>
												</div>
											</div>
											<div id="introduction" class="tab-pane">
												<textarea name="introduction" data-provide="editor">${product.introduction}</textarea>
											</div>
											<div id="productImage" class="tab-pane">
												<div class="form-group">
													<div class="col-xs-6">
														<input name="file" type="file" multiple>
													</div>
												</div>
											</div>
											<div id="parameter" class="tab-pane">
												<div class="form-group">
													<div class="col-xs-10 col-xs-offset-2">
														<button id="addParameterButton" class="btn btn-default" type="button">
															<i class="fa fa-plus"></i>
															${message("business.product.addParameter")}
														</button>
														<button class="btn btn-default" type="button" data-toggle="modal" data-target="#resetParameterModal">
															<i class="fa fa-repeat"></i>
															${message("business.product.resetParameter")}
														</button>
													</div>
												</div>
												<div id="parameterContent">
													[#list product.parameterValues as parameterValue]
														<div class="item" data-parameter-index="${parameterValue_index}" data-parameter-entry-index="${parameterValue.entries?size}">
															<div class="form-group">
																<div class="col-xs-1 col-xs-offset-1 text-right">
																	<p class="form-control-static">${message("Parameter.group")}:</p>
																</div>
																<div class="col-xs-4">
																	<input name="parameterValues[${parameterValue_index}].group" class="parameter-group form-control" type="text" value="${parameterValue.group}" maxlength="200">
																</div>
																<div class="col-xs-6">
																	<p class="form-control-static">
																		<a class="remove group" href="javascript:;">[${message("business.common.delete")}]</a>
																		<a class="add" href="javascript:;">[${message("business.common.add")}]</a>
																	</p>
																</div>
															</div>
															[#list parameterValue.entries as entry]
																<div class="form-group">
																	<div class="col-xs-1 col-xs-offset-1">
																		<input name="parameterValues[${parameterValue_index}].entries[${entry_index}].name" class="parameter-entry-name form-control text-right" type="text" value="${entry.name}" maxlength="200">
																	</div>
																	<div class="col-xs-4">
																		<input name="parameterValues[${parameterValue_index}].entries[${entry_index}].value" class="parameter-entry-value form-control" type="text" value="${entry.value}" maxlength="200">
																	</div>
																	<div class="col-xs-6">
																		<p class="form-control-static">
																			<a class="remove" href="javascript:;">[${message("business.common.delete")}]</a>
																		</p>
																	</div>
																</div>
															[/#list]
														</div>
													[/#list]
												</div>
											</div>
											<div id="attribute" class="tab-pane">
												[#list product.productCategory.attributes as attribute]
													<div class="form-group">
														<label class="col-xs-2 control-label">${attribute.name}:</label>
														<div class="col-xs-4">
															<select name="attribute_${attribute.id}" class="form-control">
																<option value="">${message("business.common.choose")}</option>
																[#list attribute.options as option]
																	<option value="${option}"[#if option == product.getAttributeValue(attribute)] selected[/#if]>${option}</option>
																[/#list]
															</select>
														</div>
													</div>
												[/#list]
											</div>
											<div id="specification" class="tab-pane">
												<div class="form-group">
													<div class="col-xs-4 col-xs-offset-2">
														<button class="btn btn-default" type="button" data-toggle="modal" data-target="#resetSpecificationModal">
															<i class="fa fa-repeat"></i>
															${message("business.product.resetSpecification")}
														</button>
													</div>
												</div>
												<div id="specificationContent">
													[#list product.specificationItems as specificationItem]
														<div class="specification-item form-group">
															<div class="col-xs-2">
																<input name="specificationItems[${specificationItem_index}].name" class="specification-item-name form-control text-right" type="text" value="${specificationItem.name}" data-value="${specificationItem.name}">
															</div>
															<div class="col-xs-10">
																<div class="row">
																	[#list specificationItem.entries as entry]
																		<div class="col-xs-2">
																			<div class="input-group">
																				<span class="input-group-addon">
																					<input name="specificationItems[${specificationItem_index}].entries[${entry_index}].isSelected" class="icheck icheckd" type="checkbox" value="true"[#if entry.isSelected] checked[/#if]>
																				</span>
																				<input name="specificationItems[${specificationItem_index}].entries[${entry_index}].value" class="specification-item-entry-value form-control" type="text" value="${entry.value}" data-value="${entry.value}">
																				<input name="_specificationItems[${specificationItem_index}].entries[${entry_index}].isSelected" type="hidden" value="false">
																				<input name="specificationItems[${specificationItem_index}].entries[${entry_index}].id" class="specification-item-entry-id" type="hidden" value="${entry.id}">
																			</div>
																		</div>
																	[/#list]
																</div>
															</div>
														</div>
													[/#list]
												</div>
												<div id="sku"></div>
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