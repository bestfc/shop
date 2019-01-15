/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * 
 * JavaScriptCommon
 * Version: 5.0
 */

// UUID
var uuidChars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz".split("");
function uuid() {
	var r;
	var uuid = [];
	uuid[8] = uuid[13] = uuid[18] = uuid[23] = "-";
	uuid[14] = "4";
	
	for (i = 0; i < 36; i++) {
		if (!uuid[i]) {
			r = 0 | Math.random() * 16;
			uuid[i] = uuidChars[(i == 19) ? (r & 0x3) | 0x8 : r];
		}
	}
	return uuid.join("");
}

// 添加Cookie
function addCookie(name, value, options) {
	if (arguments.length > 1 && name != null) {
		if (options == null) {
			options = {};
		}
		if (value == null) {
			options.expires = -1;
		}
		if (typeof options.expires == "number") {
			var time = options.expires;
			var expires = options.expires = new Date();
			expires.setTime(expires.getTime() + time * 1000);
		}
		if (options.path == null) {
			options.path = "${setting.cookiePath}";
		}
		if (options.domain == null) {
			options.domain = "${setting.cookieDomain}";
		}
		document.cookie = encodeURIComponent(String(name)) + "=" + encodeURIComponent(String(value)) + (options.expires != null ? "; expires=" + options.expires.toUTCString() : "") + (options.path != "" ? "; path=" + options.path : "") + (options.domain != "" ? "; domain=" + options.domain : "") + (options.secure != null ? "; secure" : "");
	}
}

// 获取Cookie
function getCookie(name) {
	if (name != null) {
		var value = new RegExp("(?:^|; )" + encodeURIComponent(String(name)) + "=([^;]*)").exec(document.cookie);
		return value ? decodeURIComponent(value[1]) : null;
	}
}

// 移除Cookie
function removeCookie(name, options) {
	addCookie(name, null, options);
}

// Html转义
function escapeHtml(str) {
	return str.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
}

// 字符串缩略
function abbreviate(str, width, ellipsis) {
	if ($.trim(str) == "" || width == null) {
		return str;
	}
	var i = 0;
	for (var strWidth = 0; i < str.length; i++) {
		strWidth = /^[\u4e00-\u9fa5\ufe30-\uffa0]$/.test(str.charAt(i)) ? strWidth + 2 : strWidth + 1;
		if (strWidth >= width) {
			break;
		}
	}
	return ellipsis != null && i < str.length1 ? str.substring(0, i) + ellipsis : str.substring(0, i);
}

// 货币格式化
function currency(value, showSign, showUnit) {
	if (value != null) {
		[#if setting.priceRoundType == "roundUp"]
			var price = (Math.ceil(value * Math.pow(10, ${setting.priceScale})) / Math.pow(10, ${setting.priceScale})).toFixed(${setting.priceScale});
		[#elseif setting.priceRoundType == "roundDown"]
			var price = (Math.floor(value * Math.pow(10, ${setting.priceScale})) / Math.pow(10, ${setting.priceScale})).toFixed(${setting.priceScale});
		[#else]
			var price = (Math.round(value * Math.pow(10, ${setting.priceScale})) / Math.pow(10, ${setting.priceScale})).toFixed(${setting.priceScale});
		[/#if]
		if (showSign) {
			price = "${setting.currencySign}" + price;
		}
		if (showUnit) {
			price += "${setting.currencyUnit}";
		}
		return price;
	}
}

(function($) {

	// 警告框
	$.alert = function() {
		var type = arguments.length >= 2 ? arguments[0] : null;
		var message = arguments.length >= 2 ? arguments[1] : arguments[0];
		var alertClass;
		switch(type) {
			case "success":
				alertClass = "alert-success";
				break;
			case "info":
				alertClass = "alert-info";
				break;
			case "warning":
				alertClass = "alert-warning";
				break;
			case "danger":
				alertClass = "alert-danger";
				break;
			default:
				alertClass = "alert-dark";
		}
		var $alert = $('<div class="growl animated fadeInDown alert' + (alertClass != null ? ' ' + alertClass : '') + ' alert-dismissible fade in"><button class="close" type="button" data-dismiss="alert"><span>&times;<\/span><\/button>' + message + '<\/div>').appendTo("body");
		setTimeout(function() {
			$alert.alert("close");
		}, 3000);
	};
	
	// 重定向登录页面
	$.redirectLogin = function(redirectUrl) {
		var loginUrl = "${base}/business/login";
		if ($.trim(redirectUrl) != "") {
			var redirectToken = uuid();
			addCookie("redirectToken", redirectToken);
			loginUrl += "?redirectUrl=" + encodeURIComponent(redirectUrl) + "&redirectToken=" + encodeURIComponent(redirectToken);
		}
		location.href = loginUrl;
	};

})(jQuery);

// 验证码图片
(function($) {

	$.fn.captchaImage = function() {
		var method = arguments[0];
		
		if (methods[method]) {
			method = methods[method];
			arguments = Array.prototype.slice.call(arguments, 1);
		} else if (typeof(method) == "object" || !method) {
			method = methods.init;
		}
		return method.apply(this, arguments);
	};
	
	$.fn.captchaImage.defaults = {
		captchaIdParameterName: "captchaId",
		imgClass: "captcha-image",
		imgSrc: function(captchaIdParameterName, captchaId) {
			return "${base}/common/captcha/image?" + captchaIdParameterName + '=' + captchaId + '&timestamp=' + new Date().getTime();
		},
		imgTitle: "${message("common.captcha.imageTitle")}",
		imgPlacement: function($captchaImage) {
			var $element = $(this);
			
			$inputGroupBtn = $element.nextAll(".input-group-btn");
			if ($inputGroupBtn.size() > 0) {
				$captchaImage.appendTo($inputGroupBtn);
			} else {
				$captchaImage.insertAfter($element);
			}
		}
	};
	
	var methods = {
		init: function(options) {
			return this.each(function() {
				var settings = $.extend({}, $.fn.captchaImage.defaults, options);
				var element = this;
				var $element = $(element);
				var captchaId = uuid();
				
				var refresh = function(clearValue) {
					if (clearValue) {
						$element.val("");
					}
					$captchaImage.attr("src", $.isFunction(settings.imgSrc) ? settings.imgSrc.call(element, settings.captchaIdParameterName, captchaId) : settings.imgSrc);
				};
				$element.data("refresh", refresh);
				
				var $captchaId = $('<input name="' + settings.captchaIdParameterName + '" type="hidden" value="' + captchaId + '">').insertAfter($element);
				var $captchaImage = $('<img' + (settings.imgClass != null ? ' class="' + settings.imgClass + '"' : '') + ' src="' + ($.isFunction(settings.imgSrc) ? settings.imgSrc.call(element, settings.captchaIdParameterName, captchaId) : settings.imgSrc) + '"' + (settings.imgTitle != null ? ' title="' + settings.imgTitle + '"' : '') + '>');
				if ($.isFunction(settings.imgPlacement)) {
					settings.imgPlacement.call(element, $captchaImage);
				}
				$captchaImage.click(function() {
					refresh(true);
				});
			});
		},
		refresh: function(options) {
			return this.each(function() {
				var element = this;
				var $element = $(element);
				
				var refresh = $element.data("refresh");
				if (refresh != null) {
					refresh(options);
				}
			});
		}
	};

})(jQuery);

// 删除项目
(function($) {

	$.fn.deleteItem = function() {
		var method = arguments[0];
		
		if (methods[method]) {
			method = methods[method];
			arguments = Array.prototype.slice.call(arguments, 1);
		} else if (typeof(method) == "object" || !method) {
			method = methods.init;
		}
		return method.apply(this, arguments);
	};
	
	$.fn.deleteItem.defaults = {
		url: "delete",
		type: "POST",
		data: null,
		dataType: "json",
		removeElement: null,
		complete: null
	};
	
	var methods = {
		init: function(options) {
			return this.each(function() {
				var settings = $.extend({}, $.fn.deleteItem.defaults, options);
				var element = this;
				var $element = $(element);
				
				$element.click(function() {
					if (confirm("${message("business.common.deleteConfirm")}")) {
						var data = $.isFunction(settings.data) ? settings.data.call(element) : settings.data;
						$.ajax({
							url: settings.url,
							type: settings.type,
							data: data,
							dataType: settings.dataType,
							success: function() {
								$removeElement = $.isFunction(settings.removeElement) ? settings.removeElement.call(element) : $(settings.removeElement);
								if ($removeElement != null) {
									$removeElement.velocity("fadeOut", {
										complete: function() {
											$(this).remove();
											if ($.isFunction(settings.complete)) {
												settings.complete.call(element, data);
											}
										}
									});
								} else {
									if ($.isFunction(settings.complete)) {
										settings.complete.call(element, data);
									}
								}
							}
						});
					}
				});
			});
		}
	};

})(jQuery);

// 全选
(function($) {

	$.fn.checkAll = function() {
		var method = arguments[0];
		
		if (methods[method]) {
			method = methods[method];
			arguments = Array.prototype.slice.call(arguments, 1);
		} else if (typeof(method) == "object" || !method) {
			method = methods.init;
		}
		return method.apply(this, arguments);
	};
	
	$.fn.checkAll.defaults = {
		target: "input[name='ids']"
	};
	
	function check($element, $target) {
		$element.removeClass("fa-square-o").addClass("fa-check-square-o").data("checked", true);
		$target.iCheck("check");
	}
	
	function uncheck($element, $target) {
		$element.removeClass("fa-check-square-o").addClass("fa-square-o").data("checked", false);
		$target.iCheck("uncheck");
	}
	
	var methods = {
		init: function(options) {
			return this.each(function() {
				var settings = $.extend({}, $.fn.checkAll.defaults, options);
				var element = this;
				var $element = $(element);
				
				$element.click(function() {
					var $target = $(settings.target);
					var checked = $element.data("checked");
					
					if (checked) {
						uncheck($element, $target);
					} else {
						check($element, $target);
					}
				});
			});
		},
		check: function(options) {
			return this.each(function() {
				var settings = $.extend({}, $.fn.checkAll.defaults, options);
				var $element = $(this);
				var $target = $(settings.target);
				
				check($element, $target);
			});
		},
		uncheck: function(options) {
			return this.each(function() {
				var settings = $.extend({}, $.fn.checkAll.defaults, options);
				var $element = $(this);
				var $target = $(settings.target);
				
				uncheck($element, $target);
			});
		}
	};

})(jQuery);

// 添加项目
(function($) {

	$.fn.addItem = function() {
		var method = arguments[0];
		
		if (methods[method]) {
			method = methods[method];
			arguments = Array.prototype.slice.call(arguments, 1);
		} else if (typeof(method) == "object" || !method) {
			method = methods.init;
		}
		return method.apply(this, arguments);
	};
	
	$.fn.addItem.defaults = {
		target: null,
		template: null,
		data: null,
		complete: null
	};
	
	var methods = {
		init: function(options) {
			return this.each(function() {
				var settings = $.extend({}, $.fn.addItem.defaults, options);
				var element = this;
				var $element = $(element);
				var target = $.isFunction(settings.target) ? settings.target.call(element) : settings.target;
				var $target = target instanceof jQuery ? target : $(target);
				var template = _.template($.isFunction(settings.template) ? settings.template.call(element) : settings.template);
				var data = $.isFunction(settings.data) ? settings.data.call(element) : settings.data;
				var index = 0;
				
				$element.click(function() {
					var actualData = $.extend({}, data, {
						index: index ++
					});
					var $item = $(template(actualData)).hide().appendTo($target).velocity("fadeIn");
					if ($.isFunction(settings.complete)) {
						settings.complete.call(element, $item, actualData);
					}
				});
			});
		}
	};

})(jQuery);

$().ready(function() {

	var $form = $("form");
	var $pageSize = $("input[name='pageSize']");
	var $pageNumber = $("input[name='pageNumber']");
	var $searchProperty = $("input[name='searchProperty']");
	var $orderProperty = $("input[name='orderProperty']");
	var $orderDirection = $("input[name='orderDirection']");
	var $button = $(".btn");
	var $deleteToggle = $("[data-toggle='delete']");
	var $refreshToggle = $("[data-toggle='refresh']");
	var $filterPropertyItem = $("[data-filter-property]");
	var $pageSizeItem = $("[data-page-size]");
	var $searchPropertyItem = $("[data-search-property]");
	var $searchValue = $("#search input[name='searchValue']");
	var $searchSubmit = $("#search :submit");
	var $checkAllToggle = $("[data-toggle='checkAll']");
	var $ids = $("input[name='ids']");
	var $orderPropertyItem = $("[data-order-property]");
	var $pageNumberItem = $("[data-page-number]");
	var $backToggle = $("[data-toggle='back']");
	
	// 按钮
	$button.click(function() {
		var $element = $(this);
		
		if ($.support.transition) {
			$element.addClass("btn-clicked").one("bsTransitionEnd", function() {
				$(this).removeClass("btn-clicked");
			}).emulateTransitionEnd(300);
		}
	});
	
	// 日期选择
	if ($.fn.datetimepicker != null) {
		var $dateTimePicker = $("[data-provide='datetimepicker']");
		var $dateTimeRangePicker = $("[data-provide='datetimerangepicker']");
		
		$.extend($.fn.datetimepicker.defaults, {
			locale: moment.locale("${locale}"),
			format: "YYYY-MM-DD"
		});
		
		$dateTimePicker.datetimepicker({
			format: $(this).data("date-format")
		});
		
		$dateTimeRangePicker.each(function() {
			var $element = $(this);
			var $startDateTimePicker = $element.find("input:text:eq(0)");
			var $endDateTimePicker = $element.find("input:text:eq(1)");
			
			$startDateTimePicker.datetimepicker({
				format: $element.data("date-format")
			}).on("dp.change", function(e) {
				$endDateTimePicker.data("DateTimePicker").minDate(e.date);
			});
			
			$endDateTimePicker.datetimepicker({
				format: $element.data("date-format"),
				useCurrent: false
			}).on("dp.change", function(e) {
				$startDateTimePicker.data("DateTimePicker").maxDate(e.date);
			});
		});
	}
	
	// 文本编辑器
	if ($.fn.summernote != null) {
		var $editor = $("[data-provide='editor']");
		
		$editor.summernote({
			minHeight: 300
		});
	}
	
	// 文件上传
	if ($.fn.fileinput != null) {
		var $fileinput = $("[data-provide='fileinput']");
		
		$fileinput.each(function() {
			var $element = $(this);
			var fileType = $element.data("file-type");
			var showPreview = $element.data("show-preview");
			var allowedFileExtensions;
			
			switch(fileType) {
				case "media":
					allowedFileExtensions = "${setting.uploadMediaExtension}".split(",");
					break;
				case "file":
					allowedFileExtensions = "${setting.uploadFileExtension}".split(",");
					break;
				default:
					allowedFileExtensions = "${setting.uploadImageExtension}".split(",");
			}
			
			var $file = $('<input name="file" type="file">').insertAfter($element).fileinput({
				uploadUrl: "${base}/business/file/upload",
				uploadExtraData: {
					fileType: fileType != null ? fileType : "image"
				},
				allowedFileExtensions: allowedFileExtensions,
				[#if setting.uploadMaxSize != 0]
					maxFileSize: ${setting.uploadMaxSize} * 1024,
				[/#if]
				maxFileCount: 1,
				autoReplace: true,
				showUpload: false,
				showRemove: false,
				showClose: false,
				showUploadedThumbs: false,
				dropZoneEnabled: false,
				initialPreview: $element.val(),
				initialPreviewAsData: true,
				showPreview: showPreview != null ? showPreview : true,
				previewClass: "single-file-preview",
				layoutTemplates: {
					footer: '<div class="file-thumbnail-footer">{actions}</div>',
					actions: '<div class="file-actions"><div class="file-footer-buttons">{upload} {delete} {zoom} {other}</div></div>'
				},
				fileActionSettings: {
					showUpload: false,
					showRemove: false,
					showDrag: false
				},
				removeFromPreviewOnError: true,
				showAjaxErrorDetails: false
			}).on("fileloaded", function(event, file, previewId, index, reader) {
				$(this).fileinput("upload");
			}).on("fileuploaded", function(event, data, previewId, index) {
				$element.val(data.response.url);
			});
			
			$element.data("file", $file);
		});
	}
	
	// 删除
	$deleteToggle.deleteItem({
		url: "delete",
		data: function() {
			return $ids.serialize();
		},
		removeElement: function() {
			return $ids.filter(":checked").closest("tr");
		},
		complete: function() {
			$ids = $("input[name='ids']");
			$(this).attr("disabled", true);
			$checkAllToggle.checkAll("uncheck");
			if ($ids.size() < 1) {
				setTimeout(function() {
					location.reload(true);
				}, 3000);
			}
		}
	});
	
	// 刷新
	$refreshToggle.click(function() {
		location.reload(true);
		return false;
	});
	
	// 筛选
	$filterPropertyItem.click(function() {
		var $element = $(this);
		var filterProperty = $element.data("filter-property");
		var filterValue = $element.data("filter-value");
		
		$("input[name='" + filterProperty + "']").val($element.hasClass("active") ? "" : filterValue);
		$pageNumber.val(1);
		$form.submit();
	});
	
	// 每页显示
	$pageSizeItem.click(function() {
		var $element = $(this);
		
		$pageSize.val($element.data("page-size"));
		$pageNumber.val(1);
		$form.submit();
	});
	
	// 搜索属性
	$searchPropertyItem.click(function() {
		var $element = $(this);
		
		$element.addClass("active").siblings().removeClass("active");
		$element.closest("div.input-group").find("[data-toggle='dropdown'] span").text($element.text());
	});
	
	// 搜索值
	$searchValue.keypress(function(event) {
		if (event.which == 13) {
			$searchSubmit.click();
			return false;
		}
	});
	
	// 搜索提交
	$searchSubmit.click(function() {
		$pageNumber.val(1);
		$searchProperty.val($searchPropertyItem.filter(".active").data("search-property"));
	});
	
	// 全选
	$checkAllToggle.checkAll();
	
	// ID多选框
	if ($.fn.iCheck != null) {
		$ids.iCheck({
			checkboxClass: "icheckbox-flat-blue",
			radioClass: "iradio-flat-blue"
		}).on("ifChanged", function() {
			$deleteToggle.attr("disabled", $ids.filter(":checked").size() < 1);
		});
	}
	
	// 排序
	$("[data-order-property='" + $orderProperty.val() + "'] .fa").removeClass("fa-sort").addClass($orderDirection.val() == "asc" ? "fa-sort-asc" : "fa-sort-desc");
	$orderPropertyItem.click(function() {
		var $element = $(this);
		
		$orderProperty.val($element.data("order-property"));
		$orderDirection.val($orderDirection.val() == "asc" ? "desc" : "asc");
		$form.submit();
		return false;
	});
	
	// 页码
	$pageNumberItem.click(function() {
		var $element = $(this);
		
		$pageNumber.val($element.data("page-number"));
		$form.submit();
		return false;
	});
	
	// 返回
	$backToggle.click(function() {
		history.back();
		return false;
	});
	
	// AJAX全局设置
	$.ajaxSetup({
		traditional: true,
		statusCode: {
			401: function(xhr, textStatus, errorThrown) {
				var data = $.parseJSON(xhr.responseText);
				if (data.message != null) {
					$.alert("danger", data.message);
				}
				setTimeout(function() {
					$.redirectLogin(location.href);
				}, 3000);
			},
			403: function(xhr, textStatus, errorThrown) {
				var data = $.parseJSON(xhr.responseText);
				if (data.message != null) {
					$.alert("danger", data.message);
				}
			},
			422: function(xhr, textStatus, errorThrown) {
				var data = $.parseJSON(xhr.responseText);
				if (data.message != null) {
					$.alert("warning", data.message);
				}
			}
		}
	});
	
	// AJAX全局设置
	$(document).ajaxSuccess(function(event, xhr, settings, data) {
		if (data.message != null) {
			$.alert(data.message);
		}
	});
	
	// CSRF令牌
	$("form").submit(function() {
		var $element = $(this);
		
		if (!/^(GET|HEAD|TRACE|OPTIONS)$/i.test($element.attr("method")) && $element.find("input[name='csrfToken']").size() == 0) {
			var csrfToken = getCookie("csrfToken");
			if (csrfToken != null) {
				$element.append('<input name="csrfToken" type="hidden" value="' + csrfToken + '">');
			}
		}
	});
	
	// CSRF令牌
	$(document).ajaxSend(function(event, xhr, settings) {
		if (!settings.crossDomain && !/^(GET|HEAD|TRACE|OPTIONS)$/i.test(settings.type)) {
			var csrfToken = getCookie("csrfToken");
			if (csrfToken != null) {
				xhr.setRequestHeader("X-Csrf-Token", csrfToken);
			}
		}
	});

});

$().ready(function() {

	var $icheck = $("input.icheck");
	var $addItemToggle = $("[data-toggle='add-item']");
	
	// 多选框
	if ($.fn.iCheck != null) {
		$icheck.iCheck({
			checkboxClass: "icheckbox-flat-blue",
			radioClass: "iradio-flat-blue"
		});
	}
	
	// 添加项目
	$addItemToggle.addItem({
		target: function() {
			return $(this).data("target");
		},
		template: function() {
			var $element = $(this);
			
			return $($element.data("template")).html();
		}
	});
	
});

(function($) {

	// 表单验证
	if ($.validator != null) {
		$.extend($.validator.messages, {
			required: "${message("common.validate.required")}",
			email: "${message("common.validate.email")}",
			url: "${message("common.validate.url")}",
			date: "${message("common.validate.date")}",
			dateISO: "${message("common.validate.dateISO")}",
			pointcard: "${message("common.validate.pointcard")}",
			number: "${message("common.validate.number")}",
			digits: "${message("common.validate.digits")}",
			minlength: $.validator.format("${message("common.validate.minlength")}"),
			maxlength: $.validator.format("${message("common.validate.maxlength")}"),
			rangelength: $.validator.format("${message("common.validate.rangelength")}"),
			min: $.validator.format("${message("common.validate.min")}"),
			max: $.validator.format("${message("common.validate.max")}"),
			range: $.validator.format("${message("common.validate.range")}"),
			accept: "${message("common.validate.accept")}",
			equalTo: "${message("common.validate.equalTo")}",
			remote: "${message("common.validate.remote")}",
			integer: "${message("common.validate.integer")}",
			positive: "${message("common.validate.positive")}",
			negative: "${message("common.validate.negative")}",
			decimal: "${message("common.validate.decimal")}",
			pattern: "${message("common.validate.pattern")}",
			extension: "${message("common.validate.extension")}"
		});
		
		$.validator.setDefaults({
			ignore: ".ignore",
			ignoreTitle: true,
			errorElement: "span",
			errorClass: "help-block",
			highlight: function(element, errorClass, validClass) {
				$(element).closest(".form-group").addClass("has-error");
			},
			unhighlight: function(element, errorClass, validClass) {
				$(element).closest(".form-group").removeClass("has-error");
			},
			errorPlacement: function($error, $element) {
				var $formGroup = $element.closest("td, [class^='col-'], .radio, .checkbox, .form-group");
				if ($formGroup.size() > 0) {
					$error.appendTo($formGroup);
				} else {
					$error.insertAfter($element);
				}
			},
			submitHandler: function(form) {
				$(form).find("button:submit").prop("disabled", true);
				form.submit();
			}
		});
	}
	
	// 选择框
	if ($.fn.checkboxX != null) {
		$.extend($.fn.checkboxX.defaults, {
			size: "xs",
			threeState: false,
			valueChecked: "true",
			valueUnchecked: "false"
		});
	}
	
	// 下拉菜单
	if ($.fn.selectpicker != null) {
		$.fn.selectpicker.defaults = $.extend($.fn.selectpicker.defaults, {
			noneSelectedText: "${message("business.selectpicker.noneSelectedText")}",
			noneResultsText: "${message("business.selectpicker.noneResultsText")}",
			countSelectedText: "${message("business.selectpicker.countSelectedText")}",
			maxOptionsText: "${message("business.selectpicker.maxOptionsText")}",
			maxGroupOptionsText: "${message("business.selectpicker.maxGroupOptionsText")}",
			multipleSeparator: "${message("business.selectpicker.multipleSeparator")}"
		});
	}
	
	// 下拉菜单搜索
	if ($.fn.ajaxSelectPicker != null) {
		$.extend($.fn.ajaxSelectPicker.defaults, {
			langCode: "${locale}"
		});
		$.fn.ajaxSelectPicker.locale["${locale}"] = {
			searchPlaceholder: "${message("business.ajaxSelectPicker.searchPlaceholder")}",
			statusInitialized: "${message("business.ajaxSelectPicker.statusInitialized")}",
			statusNoResults: "${message("business.ajaxSelectPicker.statusNoResults")}"
		}
	}
	
	// 文件上传
	if ($.fn.fileinput != null) {
		$.extend($.fn.fileinput.defaults, {
			language: "${locale}"
		});
		
		$.fn.fileinputLocales["${locale}"] = {
			fileSingle: "${message("business.fileinput.fileSingle")}",
			filePlural: "${message("business.fileinput.filePlural")}",
			browseLabel: "${message("business.fileinput.browseLabel")}",
			removeLabel: "${message("business.fileinput.removeLabel")}",
			removeTitle: "${message("business.fileinput.removeTitle")}",
			cancelLabel: "${message("business.fileinput.cancelLabel")}",
			cancelTitle: "${message("business.fileinput.cancelTitle")}",
			uploadLabel: "${message("business.fileinput.uploadLabel")}",
			uploadTitle: "${message("business.fileinput.uploadTitle")}",
			msgNo: "${message("business.fileinput.msgNo")}",
			msgNoFilesSelected: "${message("business.fileinput.msgNoFilesSelected")}",
			msgCancelled: "${message("business.fileinput.msgCancelled")}",
			msgZoomModalHeading: "${message("business.fileinput.msgZoomModalHeading")}",
			msgSizeTooSmall: "${message("business.fileinput.msgSizeTooSmall")}",
			msgSizeTooLarge: "${message("business.fileinput.msgSizeTooLarge")}",
			msgFilesTooLess: "${message("business.fileinput.msgFilesTooLess")}",
			msgFilesTooMany: "${message("business.fileinput.msgFilesTooMany")}",
			msgFileNotFound: "${message("business.fileinput.msgFileNotFound")}",
			msgFileSecured: "${message("business.fileinput.msgFileSecured")}",
			msgFileNotReadable: "${message("business.fileinput.msgFileNotReadable")}",
			msgFilePreviewAborted: "${message("business.fileinput.msgFilePreviewAborted")}",
			msgFilePreviewError: "${message("business.fileinput.msgFilePreviewError")}",
			msgInvalidFileName: "${message("business.fileinput.msgInvalidFileName")}",
			msgInvalidFileType: "${message("business.fileinput.msgInvalidFileType")}",
			msgInvalidFileExtension: "${message("business.fileinput.msgInvalidFileExtension")}",
			msgFileTypes: {
				image: "${message("business.fileinput.msgFileTypesImage")}",
				html: "${message("business.fileinput.msgFileTypesHtml")}",
				text: "${message("business.fileinput.msgFileTypesText")}",
				video: "${message("business.fileinput.msgFileTypesVideo")}",
				audio: "${message("business.fileinput.msgFileTypesAudio")}",
				flash: "${message("business.fileinput.msgFileTypesFlash")}",
				pdf: "${message("business.fileinput.msgFileTypesPdf")}",
				object: "${message("business.fileinput.msgFileTypesObject")}"
			},
			msgUploadAborted: "${message("business.fileinput.msgUploadAborted")}",
			msgUploadThreshold: "${message("business.fileinput.msgUploadThreshold")}",
			msgUploadBegin: "${message("business.fileinput.msgUploadBegin")}",
			msgUploadEnd: "${message("business.fileinput.msgUploadEnd")}",
			msgUploadEmpty: "${message("business.fileinput.msgUploadEmpty")}",
			msgValidationError: "${message("business.fileinput.msgValidationError")}",
			msgLoading: "${message("business.fileinput.msgLoading")}",
			msgProgress: "${message("business.fileinput.msgProgress")}",
			msgSelected: "${message("business.fileinput.msgSelected")}",
			msgFoldersNotAllowed: "${message("business.fileinput.msgFoldersNotAllowed")}",
			msgImageWidthSmall: "${message("business.fileinput.msgImageWidthSmall")}",
			msgImageHeightSmall: "${message("business.fileinput.msgImageHeightSmall")}",
			msgImageWidthLarge: "${message("business.fileinput.msgImageWidthLarge")}",
			msgImageHeightLarge: "${message("business.fileinput.msgImageHeightLarge")}",
			msgImageResizeError: "${message("business.fileinput.msgImageResizeError")}",
			msgImageResizeException: "${message("business.fileinput.msgImageResizeException")}",
			msgAjaxError: "${message("business.fileinput.msgAjaxError")}",
			msgAjaxProgressError: "${message("business.fileinput.msgAjaxProgressError")}",
			ajaxOperations: {
				deleteThumb: "${message("business.fileinput.ajaxOperationsDeleteThumb")}",
				uploadThumb: "${message("business.fileinput.ajaxOperationsUploadThumb")}",
				uploadBatch: "${message("business.fileinput.ajaxOperationsUploadBatch")}",
				uploadExtra: "${message("business.fileinput.ajaxOperationsUploadExtra")}"
			},
			dropZoneTitle: "${message("business.fileinput.dropZoneTitle")}",
			dropZoneClickTitle: "${message("business.fileinput.dropZoneClickTitle")}",
			fileActionSettings: {
				removeTitle: "${message("business.fileinput.fileActionSettingsRemoveTitle")}",
				uploadTitle: "${message("business.fileinput.fileActionSettingsUploadTitle")}",
				zoomTitle: "${message("business.fileinput.fileActionSettingsZoomTitle")}",
				dragTitle: "${message("business.fileinput.fileActionSettingsDragTitle")}",
				indicatorNewTitle: "${message("business.fileinput.fileActionSettingsIndicatorNewTitle")}",
				indicatorSuccessTitle: "${message("business.fileinput.fileActionSettingsIndicatorSuccessTitle")}",
				indicatorErrorTitle: "${message("business.fileinput.fileActionSettingsIndicatorErrorTitle")}",
				indicatorLoadingTitle: "${message("business.fileinput.fileActionSettingsIndicatorLoadingTitle")}"
			},
			previewZoomButtonTitles: {
				prev: "${message("business.fileinput.previewZoomButtonTitlesPrev")}",
				next: "${message("business.fileinput.previewZoomButtonTitlesNext")}",
				toggleheader: "${message("business.fileinput.previewZoomButtonTitlesToggleheader")}",
				fullscreen: "${message("business.fileinput.previewZoomButtonTitlesFullscreen")}",
				borderless: "${message("business.fileinput.previewZoomButtonTitlesBorderless")}",
				close: "${message("business.fileinput.previewZoomButtonTitlesClose")}"
			}
		};
	}
	
	// 文本编辑器
	if ($.summernote != null) {
		$.extend($.summernote.options, {
			lang: "${locale}",
			dialogsInBody: true,
			dialogsFade: true,
			callbacks: {
				onImageUpload: function(files) {
					var $element = $(this);
					var $files = $(files);
					
					$files.each(function() {
						var file = this;
						var formData = new FormData();
						
						formData.append("fileType", "image");
						formData.append("file", file);
						$.ajax({
							url: "${base}/business/file/upload",
							type: "POST",
							data: formData,
							dataType: "json",
							contentType: false,
							cache: false,
							processData: false,
							success: function(data) {
								$element.summernote("insertImage", data.url);
							}
						});
					});
				}
			}
		});
		
		$.extend($.summernote.lang, {
			"${locale}": {
				font: {
					bold: "${message("business.summernote.fontBold")}",
					italic: "${message("business.summernote.fontItalic")}",
					underline: "${message("business.summernote.fontUnderline")}",
					clear: "${message("business.summernote.fontClear")}",
					height: "${message("business.summernote.fontHeight")}",
					name: "${message("business.summernote.fontName")}",
					strikethrough: "${message("business.summernote.fontStrikethrough")}",
					subscript: "${message("business.summernote.fontSubscript")}",
					superscript: "${message("business.summernote.fontSuperscript")}",
					size: "${message("business.summernote.fontSize")}"
				},
				image: {
					image: "${message("business.summernote.imageImage")}",
					insert: "${message("business.summernote.imageInsert")}",
					resizeFull: "${message("business.summernote.imageResizeFull")}",
					resizeHalf: "${message("business.summernote.imageResizeHalf")}",
					resizeQuarter: "${message("business.summernote.imageResizeQuarter")}",
					floatLeft: "${message("business.summernote.imageFloatLeft")}",
					floatRight: "${message("business.summernote.imageFloatRight")}",
					floatNone: "${message("business.summernote.imageFloatNone")}",
					shapeRounded: "${message("business.summernote.imageShapeRounded")}",
					shapeCircle: "${message("business.summernote.imageShapeCircle")}",
					shapeThumbnail: "${message("business.summernote.imageShapeThumbnail")}",
					shapeNone: "${message("business.summernote.imageShapeNone")}",
					dragImageHere: "${message("business.summernote.imageDragImageHere")}",
					selectFromFiles: "${message("business.summernote.imageSelectFromFiles")}",
					maximumFileSize: "${message("business.summernote.imageMaximumFileSize")}",
					maximumFileSizeError: "${message("business.summernote.imageMaximumFileSizeError")}",
					url: "${message("business.summernote.imageUrl")}",
					remove: "${message("business.summernote.imageRemove")}"
				},
				video: {
					video: "${message("business.summernote.videoVideo")}",
					videoLink: "${message("business.summernote.videoVideoLink")}",
					insert: "${message("business.summernote.videoInsert")}",
					url: "${message("business.summernote.videoUrl")}",
					providers: "${message("business.summernote.videoProviders")}"
				},
				link: {
					link: "${message("business.summernote.linkLink")}",
					insert: "${message("business.summernote.linkInsert")}",
					unlink: "${message("business.summernote.linkUnlink")}",
					edit: "${message("business.summernote.linkEdit")}",
					textToDisplay: "${message("business.summernote.linkTextToDisplay")}",
					url: "${message("business.summernote.linkUrl")}",
					openInNewWindow: "${message("business.summernote.linkOpenInNewWindow")}"
				},
				table: {
					table: "${message("business.summernote.tableTable")}"
				},
				hr: {
					insert: "${message("business.summernote.hrInsert")}"
				},
				style: {
					style: "${message("business.summernote.styleStyle")}",
					p: "${message("business.summernote.styleP")}",
					blockquote: "${message("business.summernote.styleBlockquote")}",
					pre: "${message("business.summernote.stylePre")}",
					h1: "${message("business.summernote.styleH1")}",
					h2: "${message("business.summernote.styleH2")}",
					h3: "${message("business.summernote.styleH3")}",
					h4: "${message("business.summernote.styleH4")}",
					h5: "${message("business.summernote.styleH5")}",
					h6: "${message("business.summernote.styleH6")}"
				},
				lists: {
					unordered: "${message("business.summernote.listsUnordered")}",
					ordered: "${message("business.summernote.listsOrdered")}"
				},
				options: {
					help: "${message("business.summernote.optionsHelp")}",
					fullscreen: "${message("business.summernote.optionsFullscreen")}",
					codeview: "${message("business.summernote.optionsCodeview")}"
				},
				paragraph: {
					paragraph: "${message("business.summernote.paragraphParagraph")}",
					outdent: "${message("business.summernote.paragraphOutdent")}",
					indent: "${message("business.summernote.paragraphIndent")}",
					left: "${message("business.summernote.paragraphLeft")}",
					center: "${message("business.summernote.paragraphCenter")}",
					right: "${message("business.summernote.paragraphRight")}",
					justify: "${message("business.summernote.paragraphJustify")}"
				},
				color: {
					recent: "${message("business.summernote.colorRecent")}",
					more: "${message("business.summernote.colorMore")}",
					background: "${message("business.summernote.colorBackground")}",
					foreground: "${message("business.summernote.colorForeground")}",
					transparent: "${message("business.summernote.colorTransparent")}",
					setTransparent: "${message("business.summernote.colorSetTransparent")}",
					reset: "${message("business.summernote.colorReset")}",
					resetToDefault: "${message("business.summernote.colorResetToDefault")}"
				},
				shortcut: {
					shortcuts: "${message("business.summernote.shortcutShortcuts")}",
					close: "${message("business.summernote.shortcutClose")}",
					textFormatting: "${message("business.summernote.shortcutTextFormatting")}",
					action: "${message("business.summernote.shortcutAction")}",
					paragraphFormatting: "${message("business.summernote.shortcutParagraphFormatting")}",
					documentStyle: "${message("business.summernote.shortcutDocumentStyle")}",
					extraKeys: "${message("business.summernote.shortcutExtraKeys")}"
				},
				history: {
					undo: "${message("business.summernote.historyUndo")}",
					redo: "${message("business.summernote.historyRedo")}"
				}
			}
		});
	}

})(jQuery);