[@article_category_root_list count = 10]
	<div class="hotArticleCategory">
		<dl>
			<dt>${message("shop.article.hotArticleCategory")}</dt>
			[#list articleCategories as articleCategory]
				<dd>
					<a href="${base}${articleCategory.path}">${articleCategory.name}</a>
				</dd>
			[/#list]
		</dl>
	</div>
[/@article_category_root_list]