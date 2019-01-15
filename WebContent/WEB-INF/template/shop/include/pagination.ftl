<input type="hidden" id="pageNumber" name="pageNumber" value="${page.pageNumber}" />
<input type="hidden" id="pageSize" name="pageSize" value="${page.pageSize}" />
<input type="hidden" id="searchProperty" name="searchProperty" value="${page.searchProperty}" />
<input type="hidden" id="orderProperty" name="orderProperty" value="${page.orderProperty}" />
<input type="hidden" id="orderDirection" name="orderDirection" value="${page.orderDirection}" />
[#if totalPages > 1]
	<div class="pagination">
		[#if isFirst]
			<span class="firstPage">${message("shop.page.firstPage")}</span>
		[#else]
			<a href="[@pattern?replace("{pageNumber}", "${firstPageNumber}")?interpret /]" class="firstPage">${message("shop.page.firstPage")}</a>
		[/#if]
		[#if hasPrevious]
			<a href="[@pattern?replace("{pageNumber}", "${previousPageNumber}")?interpret /]" class="previousPage">${message("shop.page.previousPage")}</a>
		[#else]
			<span class="previousPage">${message("shop.page.previousPage")}</span>
		[/#if]
		[#list segment as segmentPageNumber]
			[#if segmentPageNumber_index == 0 && segmentPageNumber > firstPageNumber + 1]
				<span class="pageBreak">...</span>
			[/#if]
			[#if segmentPageNumber != pageNumber]
				<a href="[@pattern?replace("{pageNumber}", "${segmentPageNumber}")?interpret /]">${segmentPageNumber}</a>
			[#else]
				<span class="currentPage">${segmentPageNumber}</span>
			[/#if]
			[#if !segmentPageNumber_has_next && segmentPageNumber < lastPageNumber1]
				<span class="pageBreak">...</span>
			[/#if]
		[/#list]
		[#if hasNext]
			<a href="[@pattern?replace("{pageNumber}", "${nextPageNumber}")?interpret /]" class="nextPage">${message("shop.page.nextPage")}</a>
		[#else]
			<span class="nextPage">${message("shop.page.nextPage")}</span>
		[/#if]
		[#if isLast]
			<span class="lastPage">${message("shop.page.lastPage")}</span>
		[#else]
			<a href="[@pattern?replace("{pageNumber}", "${lastPageNumber}")?interpret /]" class="lastPage">${message("shop.page.lastPage")}</a>
		[/#if]
	</div>
[/#if]