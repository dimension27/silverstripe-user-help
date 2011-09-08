<% if Pagination %>
<div id="page-numbers">
	<% if Pagination.NotFirstPage %>
		<a class="prev" href="$Results.PrevLink" title="View the previous page">Prev</a>
	<% end_if %>
	
	<% control Pagination.SummaryPagination(9) %>
		<% if CurrentBool %>
			<span>$PageNum</span>
			<% else %>
			<a href="$Link" title="View page number $PageNum">$PageNum</a>
		<% end_if %>
	<% end_control %>
	
	<% if Pagination.NotLastPage %>
		<a class="next" href="$Results.NextLink" title="View the next page">Next</a>
	<% end_if %>
</div>
<% end_if %>