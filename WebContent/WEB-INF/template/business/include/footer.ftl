<footer>
	<div class="service">
		<div class="container">
			<div class="row">
				<div class="col-xs-2 col-xs-offset-1 text-center">
					<dl>
						<dt>
							<a href="#">
								<div class="img-circle" style="background-color: #5ec4f7">
									<span class="fa fa-heart"></span>
								</div>
								<span class="pull-left">新手指南</span>
							</a>
						</dt>
						<dd>
							<a href="#">购物流程</a>
						</dd>
						<dd>
							<a href="#">会员注册</a>
						</dd>
						<dd>
							<a href="#">购买宝贝</a>
						</dd>
						<dd>
							<a href="#">支付货款</a>
						</dd>
						<dd>
							<a href="#">用户协议</a>
						</dd>
					</dl>
				</div>
				<div class="col-xs-2 text-center">
					<dl>
						<dt>
							<a href="#">
								<div class="img-circle" style="background-color: #fbb040">
									<span class="glyphicon glyphicon-wrench"></span>
								</div>
								<span class="pull-left">特色服务</span>
							</a>
						</dt>
						<dd>
							<a href="#">购物流程</a>
						</dd>
						<dd>
							<a href="#">会员注册</a>
						</dd>
						<dd>
							<a href="#">购买宝贝</a>
						</dd>
						<dd>
							<a href="#">支付货款</a>
						</dd>
						<dd>
							<a href="#">用户协议</a>
						</dd>
					</dl>
				</div>
				<div class="col-xs-2 text-center">
					<dl>
						<dt>
							<a href="#">
								<div class="img-circle" style="background-color: #f2d549">
									<span class="fa fa-rmb"></span>
								</div>
								<span class="pull-left">支付方式</span>
							</a>
						</dt>
						<dd>
							<a href="#">购物流程</a>
						</dd>
						<dd>
							<a href="#">会员注册</a>
						</dd>
						<dd>
							<a href="#">购买宝贝</a>
						</dd>
						<dd>
							<a href="#">支付货款</a>
						</dd>
						<dd>
							<a href="#">用户协议</a>
						</dd>
					</dl>
				</div>
				<div class="col-xs-2 text-center">
					<dl>
						<dt>
							<a href="#">
								<div class="img-circle" style="background-color: #72ce52">
									<span class="fa fa-truck"></span>
								</div>
								<span class="pull-left">配送方式</span>
							</a>
						</dt>
						<dd>
							<a href="#">购物流程</a>
						</dd>
						<dd>
							<a href="#">会员注册</a>
						</dd>
						<dd>
							<a href="#">购买宝贝</a>
						</dd>
						<dd>
							<a href="#">支付货款</a>
						</dd>
						<dd>
							<a href="#">用户协议</a>
						</dd>
					</dl>
				</div>
				[#--<div class="col-xs-2 text-center">--]
					[#--<img src="${base}/resources/business/images/qr_code.jpg" alt="${message("business.footer.weixin")}">--]
					[#--<p>${message("business.footer.weixin")}</p>--]
				[#--</div>--]
			</div>
		</div>
	</div>
	<nav class="navbar navbar-default">
		<div class="container-fluid">
			<div class="info text-center">
				<ul class="list-inline">
					[@navigation_list position = "bottom"]
						[#list navigations as navigation]
							<li>
								<a href="${navigation.url}"[#if navigation.isBlankTarget] target="_blank"[/#if]>${navigation.name}</a>
								[#if navigation_has_next]|[/#if]
							</li>
						[/#list]
					[/@navigation_list]
				</ul>
				<p class="text-center">${setting.certtext}</p>
				<p class="text-center">${message("business.footer.copyright", setting.siteName)}</p>
				[@friend_link_list type = "image" count = 8]
					<ul class="list-inline">
						[#list friendLinks as friendLink]
							<li>
								<a href="${friendLink.url}" target="_blank">
									<img src="${friendLink.logo}" alt="${friendLink.name}">
								</a>
							</li>
						[/#list]
					</ul>
				[/@friend_link_list]
			</div>
		</div>
	</nav>
</footer>