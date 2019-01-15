<div class="span2">
	<div class="memberInfo">
		<p>
			${message("member.navigation.welcome")}
			<strong>${currentUser.username}</strong>
		</p>
		<p>
			${message("member.index.memberRank")}:
			<span class="red">${currentUser.memberRank.name}</span>
		</p>
		<p>
			${message("member.index.balance")}:
			<span class="red">${currency(currentUser.balance, true, true)}</span>
		</p>
		<p>
			${message("member.index.amount")}:
			<span class="red">${currency(currentUser.amount, true, true)}</span>
		</p>
		<p>
			${message("member.index.point")}:
			<em>${currentUser.point}</em>
			<a href="${base}/member/coupon_code/exchange" class="silver">[${message("member.index.exchange")}]</a>
		</p>
	</div>
	<div class="menu">
		<h2>
			<a href="${base}/member/index">${message("member.navigation.title")}</a>
		</h2>
		<dl>
			<dt>${message("member.navigation.order")}</dt>
			<dd [#if current == "orderList"] class="current"[/#if]>
				<a href="${base}/member/order/list">${message("member.order.list")}</a>
			</dd>
			<dd [#if current == "couponCodeList"] class="current"[/#if]>
				<a href="${base}/member/coupon_code/list">${message("member.couponCode.list")}</a>
			</dd>
			<dd [#if current == "couponCodeExchange"] class="current"[/#if]>
				<a href="${base}/member/coupon_code/exchange">${message("member.couponCode.exchange")}</a>
			</dd>
			<dd [#if current == "pointLogList"] class="current"[/#if]>
				<a href="${base}/member/point_log/list">${message("member.pointLog.list")}</a>
			</dd>
		</dl>
		<dl>
			<dt>${message("member.navigation.productFavorite")}</dt>
			<dd [#if current == "productFavoriteList"] class="current"[/#if]>
				<a href="${base}/member/product_favorite/list">${message("member.productFavorite.list")}</a>
			</dd>
			<dd [#if current == "storeFavoriteList"] class="current"[/#if]>
				<a href="${base}/member/store_favorite/list">${message("member.storeFavorite.list")}</a>
			</dd>
			<dd [#if current == "productNotifyList"] class="current"[/#if]>
				<a href="${base}/member/product_notify/list">${message("member.productNotify.list")}</a>
			</dd>
			<dd [#if current == "reviewList"] class="current"[/#if]>
				<a href="${base}/member/review/list">${message("member.review.list")}</a>
			</dd>
			<dd [#if current == "consultationList"] class="current"[/#if]>
				<a href="${base}/member/consultation/list">${message("member.consultation.list")}</a>
			</dd>
		</dl>
		<dl>
			<dt>${message("member.navigation.message")}</dt>
			<dd [#if current == "messageSend"] class="current"[/#if]>
				<a href="${base}/member/message/send">${message("member.message.send")}</a>
			</dd>
			<dd [#if current == "messageList"] class="current"[/#if]>
				<a href="${base}/member/message/list">${message("member.message.list")}</a>
			</dd>
			<dd [#if current == "messageDraft"] class="current"[/#if]>
				<a href="${base}/member/message/draft">${message("member.message.draft")}</a>
			</dd>
		</dl>
		<dl>
			<dt>${message("member.navigation.profile")}</dt>
			<dd [#if current == "profileEdit"] class="current"[/#if]>
				<a href="${base}/member/profile/edit">${message("member.profile.edit")}</a>
			</dd>
			<dd [#if current == "passwordEdit"] class="current"[/#if]>
				<a href="${base}/member/password/edit">${message("member.password.edit")}</a>
			</dd>
			<dd [#if current == "receiverList"] class="current"[/#if]>
				<a href="${base}/member/receiver/list">${message("member.receiver.list")}</a>
			</dd>
			<dd [#if current == "socialUserList"] class="current"[/#if]>
				<a href="${base}/member/social_user/list">${message("member.socialUser.list")}</a>
			</dd>
		</dl>
		<dl>
			<dt>${message("member.navigation.deposit")}</dt>
			<dd [#if current == "depositRecharge"] class="current"[/#if]>
				<a href="${base}/member/deposit/recharge">${message("member.memberDeposit.recharge")}</a>
			</dd>
			<dd class="last[#if current == "memberDepositLog"] current[/#if]">
				<a href="${base}/member/deposit/log">${message("member.memberDeposit.log")}</a>
			</dd>
		</dl>
	</div>
</div>