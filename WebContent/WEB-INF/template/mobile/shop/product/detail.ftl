[#assign defaultSku = product.defaultSku /]
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	[@seo type = "productDetail"]
		<title>${seo.resolveTitle()}[#if showPowered] [/#if]</title>
		[#if seo.resolveKeywords()?has_content]
			<meta name="keywords" content="${seo.resolveKeywords()}">
		[/#if]
		[#if seo.resolveDescription()?has_content]
			<meta name="description" content="${seo.resolveDescription()}">
		[/#if]
	[/@seo]
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/mobile/shop/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/animate.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/common.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/product.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/mobile/shop/js/html5shiv.js"></script>
		<script src="${base}/resources/mobile/shop/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/mobile/shop/js/jquery.js"></script>
	<script src="${base}/resources/mobile/shop/js/bootstrap.js"></script>
	<script src="${base}/resources/mobile/shop/js/jquery.spinner.js"></script>
	<script src="${base}/resources/mobile/shop/js/iscroll-probe.js"></script>
	<script src="${base}/resources/mobile/shop/js/velocity.js"></script>
	<script src="${base}/resources/mobile/shop/js/velocity.ui.js"></script>
	<script src="${base}/resources/mobile/shop/js/hammer.js"></script>
	<script src="${base}/resources/mobile/shop/js/underscore.js"></script>
	<script src="${base}/resources/mobile/shop/js/moment.js"></script>
	<script src="${base}/resources/mobile/shop/js/common.js"></script>
	<script id="reviewTemplate" type="text/template">
		<%_.each(reviews, function(review, i) {%>
			<li>
				<p>
					<strong><%-review.member.username%></strong>
					<em class="pull-right small orange">${message("shop.product.scoreDescTitle")}: <%-review.score%></em>
				</p>
				<p><%-review.content%></p>
				<%if (review.replyReviews != null) {%>
					<%_.each(review.replyReviews, function(replyReview, i) {%>
						<p>
							<span class="label label-primary">${message("Review.replyReviews")}</span>
							<span class="content"><%-replyReview.content%></span>
						</p>
					<%})%>
				<%}%>
				<span class="small gray-darker"><%-moment(new Date(review.createdDate)).format('YYYY-MM-DD HH:mm:ss')%></span>
			</li>
		<%})%>
	</script>
	<script id="consultationTemplate" type="text/template">
		<%_.each(consultations, function(consultation, i) {%>
			<li>
				<p>
					<%if (consultation.member != null) {%>
						<%-consultation.member.username%>
					<%} else {%>
						${message("shop.product.anonymous")}
					<%}%>
					<span class="pull-right small gray-darker"><%-moment(new Date(consultation.createdDate)).format('YYYY-MM-DD HH:mm:ss')%></span>
				</p>
				<p>
					<span class="label label-success">Q</span>
					<%-consultation.content%>
				</p>
				<%if (consultation.replyConsultations != null) {%>
					<%_.each(consultation.replyConsultations, function(replyConsultation, i) {%>
						<p class="content">
							<span class="label label-primary">A</span>
							<%-replyConsultation.content%>
						</p>
					<%})%>
				<%}%>
			</li>
		<%})%>
	</script>
	<script type="text/javascript">
	var parameterScroll;
	var specificationScroll;
	var tabContentScroll;
	
	function loaded() {
		
		var $window = $(window);
		var $document = $(document);
		var $nav = $("#nav");
		var $tabContentWrapper = $("#tabContentWrapper");
		var $tabContent = $("#tabContent");
		var $pullDownTips = $("#pullDownTips");
		var $pullUpTips = $("#pullUpTips");
		var $tabPane = $("#tabContent div.tab-pane");
		var $review = $("#review");
		var $reviewItems = $("#review ul");
		var $consultation = $("#consultation");
		var $consultationItems = $("#consultation ul");
		var $nextNavElement;
		var $reviewLoader = $('<div class="infinite-scroll-loading">${message("common.infiniteScroll.loading")}</div>');
		var $consultationLoader = $('<div class="infinite-scroll-loading">${message("common.infiniteScroll.loading")}</div>');
		var reviewTemplate = _.template($("#reviewTemplate").html());
		var consultationTemplate = _.template($("#consultationTemplate").html());
		var reviewPageNumber = 1;
		var consultationPageNumber = 1;
		var reviewLoading = false;
		var consultationLoading = false;
		var hasNextReview = true;
		var hasNextConsultation = true;
		
		$tabPane.each(function() {
			$(this).css("min-height", $tabContentWrapper.height() + 1);
		});
		
		$window.resize(_.debounce(function() {
			$tabPane.each(function() {
				$(this).css("min-height", $tabContentWrapper.height() + 1);
			});
		}, 50));
		
		[#if product.parameterValues?has_content]
			parameterScroll = new IScroll("#parameterBodyWrapper", {
				scrollbars: true,
				fadeScrollbars: true
			});
		[/#if]
		
		[#if product.hasSpecification()]
			specificationScroll = new IScroll("#specificationBodyWrapper", {
				scrollbars: true,
				fadeScrollbars: true,
				tap: true
			});
		[/#if]
		
		tabContentScroll = new IScroll("#tabContentWrapper", {
			tap: true,
			probeType: 2,
			deceleration: 0.001
		});
		
		// 加载评论
		function loadReview() {
			if (reviewLoading || !hasNextReview) {
				return;
			}
			
			$.ajax({
				url: "${base}/review/list",
				type: "GET",
				data: {
					productId: ${product.id},
					pageNumber: reviewPageNumber
				},
				dataType: "json",
				beforeSend: function() {
					reviewLoading = true;
					$reviewLoader.appendTo($reviewItems);
				},
				success: function(data) {
					$reviewItems.append(reviewTemplate({
						reviews: data
					}));
					if (data.length < 10) {
						hasNextReview = false;
						if (reviewPageNumber > 1 || data.length > 0) {
							$reviewItems.append('<div class="infinite-scroll-tips">${message("common.infiniteScroll.noMoreResults")}</div>');
						} else {
							$reviewItems.append('<div class="infinite-scroll-tips">${message("common.infiniteScroll.noResult")}</div>');
						}
					}
				},
				complete: function() {
					reviewPageNumber ++;
					reviewLoading = false;
					$reviewLoader.remove();
					tabContentScroll.refresh();
				}
			});
		}
		
		loadReview();
		
		// 加载咨询
		function loadConsultation() {
			if (consultationLoading || !hasNextConsultation) {
				return;
			}
			
			$.ajax({
				url: "${base}/consultation/list",
				type: "GET",
				data: {
					productId: ${product.id},
					pageNumber: consultationPageNumber
				},
				dataType: "json",
				beforeSend: function() {
					consultationLoading = true;
					$consultationLoader.appendTo($consultationItems);
				},
				success: function(data) {
					$consultationItems.append(consultationTemplate({
						consultations: data
					}));
					if (data.length < 10) {
						hasNextConsultation = false;
						if (consultationPageNumber > 1 || data.length > 0) {
							$consultationItems.append('<div class="infinite-scroll-tips">${message("common.infiniteScroll.noMoreResults")}</div>');
						} else {
							$consultationItems.append('<div class="infinite-scroll-tips">${message("common.infiniteScroll.noResult")}</div>');
						}
					}
				},
				complete: function() {
					consultationPageNumber ++;
					consultationLoading = false;
					$consultationLoader.remove();
					tabContentScroll.refresh();
				}
			});
		}
		
		loadConsultation();
		
		tabContentScroll.on("scroll", function() {
			if (this.y > 0) {
				if (!$nav.find("li:first").hasClass("active")) {
					$pullDownTips.show();
				}
			} else if (this.y < this.maxScrollY) {
				if (!$nav.find("li:last").hasClass("active")) {
					$pullUpTips.show();
				}
			}
			
			if (this.y <= this.maxScrollY && $review.hasClass("active")) {
				loadReview();
			}
			
			if (this.y <= this.maxScrollY && $consultation.hasClass("active")) {
				loadConsultation();
			}
		});
		
		tabContentScroll.on("scrollEnd", function() {
			if (this.y <= 0 && this.y >= this.maxScrollY) {
				$pullDownTips.hide();
				$pullUpTips.hide();
			}
			if ($nextNavElement != null && $nextNavElement.size() > 0) {
				$nav.removeClass("disabled");
				$nextNavElement.tab("show");
				$nextNavElement = null;
			}
		});
		
		$(document).on("touchend", function() {
			if (tabContentScroll.y >= 50) {
				$nextNavElement = $nav.find("li.active").prev("li").find("a");
			} else if (tabContentScroll.y <= tabContentScroll.maxScrollY50) {
				$nextNavElement = $nav.find("li.active").next("li").find("a");
			}
			if ($nextNavElement != null && $nextNavElement.size() > 0) {
				var $nextTabPane = $($nextNavElement.attr("href"));
				if ($nextTabPane.size() > 0) {
					$nav.addClass("disabled");
					$nextTabPane.addClass("active");
					setTimeout(function() {
						tabContentScroll.refresh();
						tabContentScroll.scrollToElement($nav.find("li.active a").attr("href"), 0);
						tabContentScroll.scrollToElement($nextTabPane[0], 1000);
					}, 0);
				}
			}
		});
	}
	
	document.addEventListener("touchmove", function(e) {
		e.preventDefault();
	}, false);
	
	$().ready(function() {
		
		var $nav = $("#nav");
		var $addContent = $("#addContent");
		var $parameter = $("#parameter");
		var $parameterBodyWrapper = $("#parameterBodyWrapper");
		var $parameterBody = $("#parameterBody");
		var $specification = $("#specification");
		var $specificationImage = $("#specification img");
		var $specificationTips = $("#specificationTips");
		var $specificationBodyWrapper = $("#specificationBodyWrapper");
		var $specificationBody = $("#specificationBody");
		var $specificationItem = $("#specificationBody dl");
		var $specificationValue = $("#specificationBody a");
		var $price = $("#specification strong.price, #summary strong.price");
		var $marketPrice = $("#specification del.market-price, #summary del.market-price");
		var $exchangePoint = $("#specification strong.exchange-point, #summary strong.exchange-point");
		var $spinner = $("#spinner");
		var $quantity = $("#quantity");
		var $addCart = $("#addCart");
		var $exchange = $("#exchange");
		var $productImage = $("#productImage");
		var $viewParameter = $("#viewParameter");
		var $closeParameter = $("#parameter button.close");
		var $viewSpecification = $("#viewSpecification");
		var $closeSpecification = $("#specification button.close");
		var $goToStore = $("#goToStore");
		var $addProductFavorite = $("#addProductFavorite");
		var $addStoreFavorite = $("#addStoreFavorite");
		var $willAddCart = $("#willAddCart");
		var $willExchange = $("#willExchange");
		var skuId = ${defaultSku.id};
		var skuData = {};
		
		[#if product.hasSpecification()]
			[#list product.skus as sku]
				skuData["${sku.specificationValueIds?join(",")}"] = {
					id: ${sku.id},
					price: ${sku.price},
					marketPrice: ${sku.marketPrice},
					rewardPoint: ${sku.rewardPoint},
					exchangePoint: ${sku.exchangePoint},
					isOutOfStock: ${sku.isOutOfStock?string("true", "false")}
				};
			[/#list]
			
			// 锁定规格值
			lockSpecificationValue();
		[/#if]
		
		$nav.find("a").click(function() {
			if ($nav.hasClass("disabled")) {
				return false;
			}
		}).on("shown.bs.tab", function(e) {
			var $target = $(e.target);
			if ($target.attr("href") == "#review") {
				$addContent.attr("href", "${base}/review/add/${product.id}");
				if ($addContent.is(":hidden")) {
					$addContent.velocity("fadeIn");
				}
			} else if ($target.attr("href") == "#consultation") {
				$addContent.attr("href", "${base}/consultation/add/${product.id}");
				if ($addContent.is(":hidden")) {
					$addContent.velocity("fadeIn");
				}
			} else {
				if ($addContent.is(":visible")) {
					$addContent.velocity("fadeOut");
				}
			}
			tabContentScroll.refresh();
			tabContentScroll.scrollTo(0, 0);
		})
		
		new Hammer($productImage.get(0)).on("swipeleft", function() {
			$productImage.carousel("next");
		}).on("swiperight", function() {
			$productImage.carousel("prev");
		});
		
		$viewParameter.on("tap", function() {
			$parameter.show().height($parameterBody.outerHeight() + 40);
			if ($.support.transition) {
				$parameter.addClass("animated fadeInUp").one("bsTransitionEnd", function() {
					$(this).removeClass("animated fadeInUp");
				}).emulateTransitionEnd(500);
			}
			if (parameterScroll != null) {
				parameterScroll.refresh();
			}
			return false;
		});
		
		$closeParameter.click(function() {
			if ($.support.transition) {
				$parameter.addClass("animated fadeOutDown").one("bsTransitionEnd", function() {
					$(this).hide().removeClass("animated fadeOutDown");
				}).emulateTransitionEnd(500);
			} else {
				$parameter.hide();
			}
			return false;
		});
		
		$viewSpecification.on("tap", function() {
			$specification.show().height($specificationBody.outerHeight() + 190);
			if ($.support.transition) {
				$specification.addClass("animated fadeInUp").one("bsTransitionEnd", function() {
					$(this).removeClass("animated fadeInUp");
				}).emulateTransitionEnd(500);
			}
			if (specificationScroll != null) {
				specificationScroll.refresh();
			}
			return false;
		});
		
		$closeSpecification.click(function() {
			if ($.support.transition) {
				$specification.addClass("animated fadeOutDown").one("bsTransitionEnd", function() {
					$(this).hide().removeClass("animated fadeOutDown");
				}).emulateTransitionEnd(500);
			} else {
				$specification.hide();
			}
			return false;
		});
		
		$goToStore.on("tap", function() {
			location.href = "${base}${product.store.path}";
		});
		
		// 规格值选择
		$specificationValue.on("tap", function() {
			var $element = $(this);
			if ($element.hasClass("disabled")) {
				return false;
			}
			
			$element.toggleClass("active").parent().siblings().children("a").removeClass("active");
			lockSpecificationValue();
			return false;
		});
		
		// 锁定规格值
		function lockSpecificationValue() {
			var activeSpecificationValueIds = $specificationItem.map(function() {
				$active = $(this).find("a.active");
				return $active.size() > 0 ? $active.data("specification-item-entry-id") : [null];
			}).get();
			$specificationItem.each(function(i) {
				$(this).find("a").each(function(j) {
					var $element = $(this);
					var specificationValueIds = activeSpecificationValueIds.slice(0);
					specificationValueIds[i] = $element.data("specification-item-entry-id");
					if (isValid(specificationValueIds)) {
						$element.removeClass("disabled");
					} else {
						$element.addClass("disabled");
					}
				});
			});
			var sku = skuData[activeSpecificationValueIds.join(",")];
			if (sku != null) {
				skuId = sku.id;
				$price.text(currency(sku.price, true));
				$marketPrice.text(currency(sku.marketPrice, true));
				$exchangePoint.text(sku.exchangePoint);
				if (sku.isOutOfStock) {
					$specificationTips.text("${message("shop.product.skuLowStock")}").velocity("fadeIn", {
						display: "block"
					});
					$addCart.add($exchange).prop("disabled", true);
					return;
				}
			} else {
				skuId = null;
			}
			$specificationTips.velocity("fadeOut");
			$addCart.add($exchange).prop("disabled", false);
		}
		
		// 判断规格值ID是否有效
		function isValid(specificationValueIds) {
			for(var key in skuData) {
				var ids = key.split(",");
				if (match(specificationValueIds, ids)) {
					return true;
				}
			}
			return false;
		}
		
		// 判断数组是否配比
		function match(array1, array2) {
			if (array1.length != array2.length) {
				return false;
			}
			for(var i = 0; i < array1.length; i ++) {
				if (array1[i] != null && array2[i] != null && array1[i] != array2[i]) {
					return false;
				}
			}
			return true;
		}
		
		// 数量
		$spinner.spinner({
			min: 1,
			max: 10000
		});
		
		// 加入购物车
		$addCart.click(function() {
			if (skuId == null) {
				$.alert("${message("shop.product.specificationTips")}");
				return false;
			}
			$.ajax({
				url: "${base}/cart/add",
				type: "POST",
				data: {
					skuId: skuId,
					quantity: $quantity.val()
				},
				dataType: "json",
				success: function() {
					if ($.support.transition) {
						$specificationImage.clone().velocity({
							width: "50px",
							height: "50px",
							translateX: $addCart.offset().left$specificationImage.offset().left + $addCart.outerWidth() / 225,
							translateY: $addCart.offset().top$specificationImage.offset().top80,
							translateZ: 0,
							rotateZ: "1800deg",
							opacity: 0.2
						}, {
							duration: 1000,
							begin: function() {
								$(this).insertAfter($specificationImage);
							}
						}).velocity({
							translateY: "+=50",
							opacity: 0
						}, {
							complete: function() {
								$(this).remove();
								$closeSpecification.trigger("click");
							}
						});
					} else {
						$closeSpecification.trigger("click");
					}
				}
			});
		});
		
		// 积分兑换
		$exchange.click(function() {
			if (skuId == null) {
				$.alert("${message("shop.product.specificationTips")}");
				return false;
			}
			$.ajax({
				url: "${base}/order/check_exchange",
				type: "GET",
				data: {
					skuId: skuId,
					quantity: $quantity.val()
				},
				dataType: "json",
				success: function() {
					location.href = "${base}/order/checkout?type=exchange&skuId=" + skuId + "&quantity=" + $quantity.val();
				}
			});
		});
		
		// 添加商品收藏
		$addProductFavorite.click(function() {
			$.ajax({
				url: "${base}/member/product_favorite/add",
				type: "POST",
				data: {
					productId: ${product.id}
				},
				dataType: "json"
			});
			return false;
		});
		
		// 添加店铺收藏
		$addStoreFavorite.on("tap", function() {
			$.ajax({
				url: "${base}/member/store_favorite/add",
				type: "POST",
				data: {storeId: ${product.store.id}},
				dataType: "json",
				cache: false
			});
			return false;
		});
		
		// 将要加入购物车
		$willAddCart.click(function() {
			if ($specification.is(":hidden")) {
				$viewSpecification.trigger("tap");
				return false;
			}
		});
		
		// 将要积分兑换
		$willExchange.click(function() {
			if ($specification.is(":hidden")) {
				$viewSpecification.trigger("tap");
				return false;
			}
		});
	
	});
	</script>
</head>
<body class="product-detail" onload="loaded();">
	<header>
		<div class="container-fluid">
			<div class="row">
				<div class="col-xs-1 text-center">
					<a href="javascript: history.back();">
						<span class="glyphicon glyphicon-menu-left"></span>
					</a>
				</div>
				<div class="col-xs-10">
					<ul id="nav" class="nav nav-pills">
						<li class="active">
							<a href="#summary" data-toggle="pill">${message("shop.product.summaryNav")}</a>
						</li>
						<li>
							<a href="#detail" data-toggle="pill">${message("shop.product.detailNav")}</a>
						</li>
						<li>
							<a href="#review" data-toggle="pill">${message("shop.product.reviewNav")}</a>
						</li>
						<li>
							<a href="#consultation" data-toggle="pill">${message("shop.product.consultationNav")}</a>
						</li>
					</ul>
				</div>
				<div class="col-xs-1">
					<a id="addContent" class="add-content" href="#">
						<span class="fa fa-pencil-square-o"></span>
					</a>
				</div>
			</div>
		</div>
	</header>
	<main>
		[#if product.parameterValues?has_content]
			<div id="parameter" class="parameter">
				<div class="parameter-header">
					${message("shop.product.parameter")}
					<button class="close" type="button">
						<span>&times;</span>
					</button>
				</div>
				<div id="parameterBodyWrapper" class="parameter-body-wrapper">
					<div id="parameterBody" class="parameter-body">
						<table>
							[#list product.parameterValues as parameterValue]
								<tr>
									<th class="group" colspan="2">${parameterValue.group}</th>
								</tr>
								[#list parameterValue.entries as entry]
									<tr>
										<th>${entry.name}</th>
										<td>${entry.value}</td>
									</tr>
								[/#list]
							[/#list]
						</table>
					</div>
				</div>
			</div>
		[/#if]
		[#assign defaultSpecificationValueIds = defaultSku.specificationValueIds /]
		<div id="specification" class="specification">
			<div class="specification-header">
				<img src="${product.thumbnail!setting.defaultThumbnailProductImage}" alt="${product.name}">
				<button class="close" type="button">
					<span>&times;</span>
				</button>
				[#if product.type == "general"]
					<strong class="price red">${currency(defaultSku.price, true)}</strong>
					[#if setting.isShowMarketPrice]
						<del class="market-price gray-darker">${currency(defaultSku.marketPrice, true)}</del>
					[/#if]
				[#elseif product.type == "exchange"]
					${message("Sku.exchangePoint")}:
					<strong class="exchange-point red">${defaultSku.exchangePoint}</strong>
				[#elseif product.type == "gift"]
					<p class="red">${message("shop.product.giftNoBuy")}</p>
				[/#if]
				<span id="specificationTips" class="specification-tips red-dark"></span>
			</div>
			[#if product.hasSpecification()]
				<div id="specificationBodyWrapper" class="specification-body-wrapper">
					<div id="specificationBody" class="specification-body">
						[#list product.specificationItems as specificationItem]
							<dl class="clearfix">
								<dt>
									<span title="${specificationItem.name}">${abbreviate(specificationItem.name, 8)}:</span>
								</dt>
								[#list specificationItem.entries as entry]
									[#if entry.isSelected]
										<dd>
											<a[#if defaultSpecificationValueIds[specificationItem_index] == entry.id] class="active"[/#if] href="javascript:;" data-specification-item-entry-id="${entry.id}">${entry.value}</a>
										</dd>
									[/#if]
								[/#list]
							</dl>
						[/#list]
					</div>
				</div>
			[/#if]
			[#if product.type == "general" || product.type == "exchange"]
				<div class="specification-footer">
					<div class="container-fluid">
						<div class="row">
							<div class="col-xs-9">${message("shop.product.quantity")}</div>
							<div class="col-xs-3 text-right">
								<div id="spinner" class="spinner input-group input-group-sm">
									<div class="input-group-addon" data-spin="down">-</div>
									<input id="quantity" class="form-control" type="text" value="1" maxlength="4">
									<div class="input-group-addon" data-spin="up">+</div>
								</div>
							</div>
						</div>
						[#if product.type == "general"]
							<button id="addCart" class="btn btn-lg btn-primary btn-flat btn-block" type="button">${message("shop.product.addCart")}</button>
						[#elseif product.type == "exchange"]
							<button id="exchange" class="btn btn-lg btn-primary btn-flat btn-block" type="button">${message("shop.product.exchange")}</button>
						[/#if]
					</div>
				</div>
			[/#if]
		</div>
		<div class="container-fluid">
			<div id="tabContentWrapper" class="tab-content-wrapper">
				<div id="tabContent" class="tab-content">
					<div id="pullDownTips" class="pull-down-tips">${message("shop.product.pullDownTips")}</div>
					<div id="pullUpTips" class="pull-up-tips">${message("shop.product.pullUpTips")}</div>
					<div id="summary" class="summary tab-pane active">
						<div id="productImage" class="product-image carousel slide">
							<ol class="carousel-indicators">
								[#list product.productImages as productImage]
									<li[#if productImage_index == 0] class="active"[/#if] data-target="#productImage" data-slide-to="${productImage_index}"></li>
								[/#list]
							</ol>
							<ul class="carousel-inner">
								[#if product.productImages?has_content]
									[#list product.productImages as productImage]
										<li class="item[#if productImage_index == 0] active[/#if]">
											<img class="img-responsive center-block" src="${productImage.medium}" alt="${productImage.title}">
										</li>
									[/#list]
								[#else]
									<li class="item active">
										<img class="img-responsive center-block" src="${setting.defaultMediumProductImage}">
									</li>
								[/#if]
							</ul>
						</div>
						<section>
							<h1>
								[#if product.store.type == "self"]
									<em class="small">${message("Store.Type.self")}</em>
								[/#if]
								${product.name}
								[#if product.caption?has_content]
									<span class="orange">${product.caption}</span>
								[/#if]
							</h1>
						</section>
						<section>
							[#if product.type == "general"]
								<strong class="price red">${currency(defaultSku.price, true)}</strong>
								[#if setting.isShowMarketPrice]
									<del class="market-price gray-darker">${currency(defaultSku.marketPrice, true)}</del>
								[/#if]
							[#elseif product.type == "exchange"]
								${message("Sku.exchangePoint")}:
								<strong class="exchange-point red">${defaultSku.exchangePoint}</strong>
							[#elseif product.type == "gift"]
								<p class="red">${message("shop.product.giftNoBuy")}</p>
							[/#if]
						</section>
						[#if product.parameterValues?has_content]
							<section>
								<a id="viewParameter" href="javascript:;">
									${message("shop.product.parameter")}
									<span class="glyphicon glyphicon-option-horizontal gray"></span>
								</a>
							</section>
						[/#if]
						<section>
							<a id="viewSpecification" href="javascript:;">
								${message("shop.product.specification")}
								<span class="glyphicon glyphicon-option-horizontal gray"></span>
							</a>
						</section>
					</div>
					<div id="detail" class="detail tab-pane">
						[#noautoesc]
							${product.introduction}
						[/#noautoesc]
					</div>
					<div id="review" class="review tab-pane">
						<ul></ul>
					</div>
					<div id="consultation" class="consultation tab-pane">
						<ul></ul>
					</div>
				</div>
			</div>
		</div>
	</main>
	<footer class="footer-fixed">
		<div class="container-fluid">
			<div class="row">
				<div class="col-xs-2 text-center">
					<span class="glyphicon glyphicon-home"></span>
					<a href="${base}/">${message("shop.common.index")}</a>
				</div>
				<div class="col-xs-2 text-center">
					<span class="glyphicon glyphicon-tags"></span>
					<a href="${base}${product.store.path}">${message("shop.product.store")}</a>
				</div>
				<div class="col-xs-2 text-center">
					<span class="glyphicon glyphicon-heart"></span>
					<a id="addProductFavorite" href="javascript:;">${message("shop.product.addProductFavorite")}</a>
				</div>
				<div class="col-xs-3 text-center">
					<span class="glyphicon glyphicon-shopping-cart"></span>
					<a href="${base}/cart/list">${message("shop.common.cart")}</a>
				</div>
				<div class="col-xs-3 text-right">
					[#if product.type == "general"]
						<button id="willAddCart" class="btn btn-primary btn-flat btn-block" type="button">${message("shop.product.addCart")}</button>
					[#elseif product.type == "exchange"]
						<button id="willExchange" class="btn btn-primary btn-flat btn-block" type="button">${message("shop.product.exchange")}</button>
					[#elseif product.type == "gift"]
						<button class="btn btn-primary btn-flat btn-block disabled" type="button">${message("shop.product.addCart")}</button>
					[/#if]
				</div>
			</div>
		</div>
	</footer>
</body>
</html>