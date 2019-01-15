<header class="main-header">
	<a class="logo" href="/shop/business/index">
		<span class="logo-mini">
			<img class="img-circle" src="${currentStore.logo!setting.defaultStoreLogo}" alt="${currentStore.name}">
		</span>
		<span class="logo-lg">${abbreviate(currentStore.name, 16, "...")}</span>
	</a>
	<nav class="navbar navbar-static-top">
		<div class="container-fluid">
			<a class="sidebar-toggle" href="javascript:;" data-toggle="offcanvas"></a>
			<div class="navbar-custom-menu">
				<ul class="nav navbar-nav">
					<li>
						<a href="${base}/business/store/setting">
							<img class="img-circle" src="${currentStore.logo!setting.defaultStoreLogo}" alt="${currentStore.name}">
							<span class="hidden-xs">${currentUser.username}</span>
						</a>
					</li>
					<li class="dropdown notifications-menu">
						<a class="dropdown-toggle" href="javascript:;" data-toggle="dropdown">
							<span class="fa fa-bell-o"></span>
							[@order_count storeId = currentStore.id status = "pendingPayment" hasExpired = false]
								[#assign pendingPaymentCount = count]
							[/@order_count]
							[@order_count storeId = currentStore.id status = "pendingReview" hasExpired = false]
								[#assign pendingReviewCount = count]
							[/@order_count]
							[@order_count storeId = currentStore.id status = "pendingShipment"]
								[#assign pendingShipmentCount = count]
							[/@order_count]
							[@order_count storeId = currentStore.id isPendingRefunds = true]
								[#assign isPendingRefundsCount = count]
							[/@order_count]
							<div class="label">
								[#if pendingPaymentCount + pendingReviewCount + pendingShipmentCount + isPendingRefundsCount > 0]
									<span class="fa fa-circle text-red"></span>
								[/#if]
							</div>
						</a>
						<ul class="dropdown-menu">
							<li class="header">
								<span class="fa fa-warning text-orange"></span>
								<strong>${message("business.mainHeader.notifications")}</strong>
							</li>
							<li>
								<ul class="menu">
									<li>
										<a href="${base}/business/order/list?status=pendingPayment&hasExpired=false">
											<span class="fa fa-credit-card text-aqua"></span>
											${message("business.mainHeader.pendingPayment", pendingPaymentCount)}
										</a>
									</li>
									<li>
										<a href="${base}/business/order/list?status=pendingReview&hasExpired=false">
											<span class="fa fa-user-o text-red"></span>
											${message("business.mainHeader.pendingReview", pendingReviewCount)}
										</a>
									</li>
									<li>
										<a href="${base}/business/order/list?status=pendingShipment">
											<span class="fa fa-truck text-green"></span>
											${message("business.mainHeader.pendingShipment", pendingShipmentCount)}
										</a>
									</li>
									<li>
										<a href="${base}/business/order/list?isPendingRefunds=true">
											<span class="fa fa-rmb text-yellow"></span>
											${message("business.mainHeader.pendingRefunds", isPendingRefundsCount)}
										</a>
									</li>
								</ul>
							</li>
							<li class="footer">
								<a href="${base}/business/order/list">${message("business.mainHeader.viewOrders")}</a>
							</li>
						</ul>
					</li>
					<li>
						<a class="logout" href="${base}/business/logout">
							<span class="fa fa-sign-out"></span>
							${message("business.mainHeader.logout")}
						</a>
					</li>
				</ul>
			</div>
		</div>
	</nav>
</header>