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
			price = '${setting.currencySign}' + price;
		}
		if (showUnit) {
			price += '${setting.currencyUnit}';
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
		var loginUrl = "${base}/member/login";
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

// 无限滚动加载
(function($) {

	var $window = $(window);
	
	$.fn.infiniteScroll = function() {
		var method = arguments[0];
		
		if (methods[method]) {
			method = methods[method];
			arguments = Array.prototype.slice.call(arguments, 1);
		} else if (typeof(method) == "object" || !method) {
			method = methods.init;
		}
		return method.apply(this, arguments);
	};
	
	$.fn.infiniteScroll.defaults = {
		url: null,
		type: "GET",
		data: null,
		dataType: "json",
		pageSize: 20,
		sensitivity: 200,
		prefill: true,
		loader: '<div class="infinite-scroll-loading">${message("common.infiniteScroll.loading")}</div>',
		template: function(pageNumber, data) {},
		finished: function(pageNumber, data) {
			var $element = $(this);
			if (pageNumber > 1 || data.length > 0) {
				$element.append('<div class="infinite-scroll-tips">${message("common.infiniteScroll.noMoreResults")}</div>');
			} else {
				$element.append('<div class="infinite-scroll-tips">${message("common.infiniteScroll.noResult")}</div>');
			}
		}
	};
	
	var methods = {
		init: function(options) {
			return this.each(function() {
				var settings = $.extend({}, $.fn.infiniteScroll.defaults, options);
				var element = this;
				var $element = $(element);
				var pageNumber = 1;
				var loading = false;
				var hasNext = true;
				
				var handle = function() {
					if (loading || !hasNext) {
						return;
					}
					
					var $loader = $(settings.loader);
					$.ajax({
						url: $.isFunction(settings.url) ? settings.url.call(element, pageNumber) : settings.url,
						type: settings.type,
						data: settings.data,
						dataType: settings.dataType,
						beforeSend: function() {
							loading = true;
							setTimeout(function() {
								if ($loader != null) {
									$loader.appendTo($element);
								}
							}, 500);
						},
						success: function(data) {
							if ($.isFunction(settings.template)) {
								$element.append(settings.template.call(element, pageNumber, data));
							} else {
								$element.append(settings.template);
							}
							if (data.length < settings.pageSize) {
								hasNext = false;
								if ($.isFunction(settings.finished)) {
									settings.finished.call(element, pageNumber, data);
								}
							}
						},
						complete: function() {
							pageNumber ++;
							loading = false;
							$loader.remove();
							$loader = null;
						}
					});
				};
				
				if (settings.prefill) {
					handle();
				}
				
				var refresh = function() {
					pageNumber = 1;
					hasNext = true;
					
					$element.empty();
					if (settings.prefill) {
						handle();
					}
				};
				$element.data("refresh", refresh);
				
				$window.scroll(_.throttle(function() {
					if ($element.height() + $element.offset().top < $window.height() + $window.scrollTop() + settings.sensitivity) {
						handle();
					}
				}, 200));
			
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

$().ready(function() {

	var $window = $(window);
	var $backTop = $('<div class="back-top"><span class="fa fa-arrow-up"><\/span><\/div>').appendTo("body");
	var $footer = $("footer");
	
	// 回到顶部
	$window.scroll(_.throttle(function() {
		if ($window.scrollTop() > 500) {
			$backTop.fadeIn();
			if ($footer.size() > 0) {
				if ($footer.offset().top <= $backTop.offset().top + $backTop.outerHeight()) {
					$backTop.animate({
						bottom: $footer.outerHeight() + 10
					});
				} else if ($footer.offset().top >= $backTop.offset().top + $backTop.outerHeight() + 15) {
					$backTop.animate({
						bottom: 10
					});
				}
			}
		} else {
			$backTop.fadeOut();
		}
	}, 500));
	
	// 回到顶部
	$backTop.click(function() {
		$("body, html").animate({
			scrollTop: 0
		});
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

// 表单验证
if ($.validator != null) {

	$.extend($.validator.messages, {
		required: '${message("common.validate.required")}',
		email: '${message("common.validate.email")}',
		url: '${message("common.validate.url")}',
		date: '${message("common.validate.date")}',
		dateISO: '${message("common.validate.dateISO")}',
		pointcard: '${message("common.validate.pointcard")}',
		number: '${message("common.validate.number")}',
		digits: '${message("common.validate.digits")}',
		minlength: $.validator.format('${message("common.validate.minlength")}'),
		maxlength: $.validator.format('${message("common.validate.maxlength")}'),
		rangelength: $.validator.format('${message("common.validate.rangelength")}'),
		min: $.validator.format('${message("common.validate.min")}'),
		max: $.validator.format('${message("common.validate.max")}'),
		range: $.validator.format('${message("common.validate.range")}'),
		accept: '${message("common.validate.accept")}',
		equalTo: '${message("common.validate.equalTo")}',
		remote: '${message("common.validate.remote")}',
		integer: '${message("common.validate.integer")}',
		positive: '${message("common.validate.positive")}',
		negative: '${message("common.validate.negative")}',
		decimal: '${message("common.validate.decimal")}',
		pattern: '${message("common.validate.pattern")}',
		extension: '${message("common.validate.extension")}'
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
			var $formGroup = $element.closest("[class^='col-'], .radio, .checkbox, .form-group");
			if ($formGroup.size() > 0) {
				$error.appendTo($formGroup);
			} else {
				$error.insertAfter($element);
			}
		},
		submitHandler: function(form) {
			$(form).find("input:submit").prop("disabled", true);
			form.submit();
		}
	});

}

// "日期选择"多语言
if ($.fn.datepicker != null) {
	!function(a){a.fn.datepicker.dates["zh_CN"]={days:["星期日","星期一","星期二","星期三","星期四","星期五","星期六"],daysShort:["周日","周一","周二","周三","周四","周五","周六"],daysMin:["日","一","二","三","四","五","六"],months:["一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月"],monthsShort:["1月","2月","3月","4月","5月","6月","7月","8月","9月","10月","11月","12月"],today:"今日",clear:"清除",format:"yyyy年mm月dd日",titleFormat:"yyyy年mm月",weekStart:1}}(jQuery);
	!function(a){a.fn.datepicker.dates["zh_TW"]={days:["星期日","星期一","星期二","星期三","星期四","星期五","星期六"],daysShort:["週日","週一","週二","週三","週四","週五","週六"],daysMin:["日","一","二","三","四","五","六"],months:["一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月"],monthsShort:["1月","2月","3月","4月","5月","6月","7月","8月","9月","10月","11月","12月"],today:"今天",format:"yyyy年mm月dd日",weekStart:1,clear:"清除"}}(jQuery);
}