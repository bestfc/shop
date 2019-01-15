[@product_list productCategoryId = productCategory.id count = 3 orderBy = "monthSales desc"]
	[#if products?has_content]
		<div class="hotProduct">
			<dl>
				<dt>${message("shop.product.hotProduct")}</dt>
				[#list products as product]
					<dd>
						<a href="${base}${product.path}">
							<img src="${product.thumbnail!setting.defaultThumbnailProductImage}" alt="${product.name}" />
							<span title="${product.name}">${abbreviate(product.name, 52)}</span>
						</a>
						<strong>
							${currency(product.price, true)}
							[#if setting.isShowMarketPrice]
								<del>${currency(product.marketPrice, true)}</del>
							[/#if]
						</strong>
					</dd>
				[/#list]
			</dl>
		</div>
	[/#if]
[/@product_list]