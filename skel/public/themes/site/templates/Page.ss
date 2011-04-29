<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" >
<head>
	<% include Head %>
</head>
<body class="page_$URLSegment type_$ClassName">
	<div id="cn">
		<div id="cnLeft"></div>
		<div id="cnRight"></div>
		<div id="doc">
			<div id="hd">
				<div id="hdLeft"></div>
				<div id="hdRight"></div>
				<div id="logo"><a id="homeLink" title="$SiteConfig.Title" href="/">$SiteConfig.Title</a></div>
				<div id="topNav"><% include TopNav %></div>
			</div>
			<div id="bd">
				$Layout
			</div>
			<div id="ft">
				<% include Footer %>
			</div>
		</div>
		<div class="clearing"></div>
	</div>
	<% if PastMember %>
		$SilverStripeNavigator
	<% end_if %>	
</body>
</html>