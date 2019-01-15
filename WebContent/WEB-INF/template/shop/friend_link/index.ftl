<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("shop.friendLink.title")}[#if showPowered] [/#if]</title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/shop/css/animate.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/article.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/friend_link.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/shop/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/common.js"></script>
</head>
<body>
	[#include "/shop/include/header.ftl" /]
	<div class="container friendLink">
		<div class="row">
			<div class="span2">
				[#include "/shop/include/hot_article_category.ftl" /]
				[#include "/shop/include/hot_article.ftl" /]
			</div>
			<div class="span10">
				<div class="breadcrumb">
					<ul>
						<li>
							<a href="${base}/">${message("shop.breadcrumb.home")}</a>
						</li>
						<li>${message("shop.friendLink.title")}</li>
					</ul>
				</div>
				[#if imageFriendLinks?has_content]
					<div class="list clearfix">
						<ul>
							[#list imageFriendLinks as friendLink]
								<li>
									<a href="${friendLink.url}" target="_blank">
										<img src="${friendLink.logo}" alt="${friendLink.name}" title="${friendLink.name}" />
									</a>
								</li>
							[/#list]
						</ul>
					</div>
				[/#if]
				[#if textFriendLinks?has_content]
					<div class="list clearfix">
						<ul>
							[#list textFriendLinks as friendLink]
								<li>
									<a href="${friendLink.url}" target="_blank">${friendLink.name}</a>
								</li>
							[/#list]
						</ul>
					</div>
				[/#if]
			</div>
		</div>
	</div>
	[#include "/shop/include/footer.ftl" /]
</body>
</html>