<header>
	<div class="header-top">
		<div class="container">
			<div class="row">
				<div class="col-xs-4">${message("business.header.welcome", setting.siteName)}</div>
				<div class="col-xs-8 text-right">
					<ul class="list-inline">
						<li>
							<a href="${base}/business/login">${message("business.header.businessLogin")}</a>|
						</li>
						<li>
							<a href="${base}/business/register">${message("business.header.businessRegister")}</a>
						</li>
					</ul>
				</div>
			</div>
		</div>
	</div>
	<div class="header-main navbar">
		<div class="container">
			<div class="row">
				<div class="col-xs-4">
					<a class="logo" href="${base}/">
						<img src="${setting.logo}" alt="${setting.siteName}">
					</a>
				</div>
				<div class="col-xs-8">
					<ul class="nav navbar-nav navbar-right">
						[#--[@navigation_list position = "top"]--]
							[#--[#list navigations as navigation]--]
								[#--<li>--]
									[#--<a href="${navigation.url}"[#if navigation.isBlankTarget] target="_blank"[/#if]>${navigation.name}</a>--]
								[#--</li>--]
							[#--[/#list]--]
						[#--[/@navigation_list]--]
						<li>
							<a href="/shop/member/index">会员中心</a>
						</li>
						<li>
							<a href="/shop/business/index">商家中心</a>
						</li>
						<li>
							<a href="/shop/article/list/3">帮助中心</a>
						</li>

					</ul>
				</div>
			</div>
		</div>
	</div>
</header>