[@product_category_root_list count = 6]
	<div class="hotProductCategory">
		[#list productCategories as productCategory]
			<dl class="[#if (productCategory_index + 1) % 2 == 0]even[#else]odd[/#if] clearfix">
				<dt>
					<a href="${base}${productCategory.path}">${productCategory.name}</a>
				</dt>
				[@product_category_children_list productCategoryId = productCategory.id recursive = false count = 4]
					[#list productCategories as productCategory]
						<dd>
							<a href="${base}${productCategory.path}">${productCategory.name}</a>
						</dd>
					[/#list]
				[/@product_category_children_list]
			</dl>
		[/#list]
	</div>
[/@product_category_root_list]