[@article_list articleCategoryId = articleCategory.id count = 10 orderBy = "hits desc"]
	[#if articles?has_content]
		<div class="hotArticle">
			<dl>
				<dt>${message("shop.article.hotArticle")}</dt>
				[#list articles as article]
					<dd>
						<a href="${base}${article.path}" title="${article.title}">${abbreviate(article.title, 26)}</a>
					</dd>
				[/#list]
			</dl>
		</div>
	[/#if]
[/@article_list]