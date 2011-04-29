<?php
$tables = explode("\n", 
"ArchiveWidget
BlogEntry
BlogEntry_Live
BlogEntry_versions
BlogHolder
BlogHolder_Live
BlogHolder_versions
BlogTree
BlogTree_Live
BlogTree_versions
Email_BounceRecord
ErrorPage
ErrorPage_Live
ErrorPage_versions
File
Group
Group_Members
Group_Roles
LoginAttempt
Member
MemberPassword
Newsletter
NewsletterEmailBlacklist
NewsletterType
Newsletter_Recipient
Newsletter_SentRecipient
Page
PageComment
Page_Live
Page_versions
Permission
PermissionRole
PermissionRoleCode
QueuedEmail
RSSWidget
RedirectorPage
RedirectorPage_Live
RedirectorPage_versions
SiteConfig
SiteConfig_CreateTopLevelGroups
SiteConfig_EditorGroups
SiteConfig_ViewerGroups
SiteTree
SiteTree_EditorGroups
SiteTree_ImageTracking
SiteTree_LinkTracking
SiteTree_Live
SiteTree_ViewerGroups
SiteTree_versions
SubscriptionPage
SubscriptionPage_Live
SubscriptionPage_versions
TagCloudWidget
TrackBackPing
UnsubscribeRecord
VirtualPage
VirtualPage_Live
VirtualPage_versions
Widget
WidgetArea



CategoryListingPage
CategoryListingPage_Live
CategoryListingPage_versions
ClientHolder
ClientHolder_Live
ClientHolder_versions
ClientPage
ClientPage_Live
ClientPage_versions
ClientProject
ClientProject_Live
ClientProject_versions
EmbedPage
EmbedPage_Live
EmbedPage_versions
ImageResource");

foreach( $tables as $table ) {
	if( $table ) {
		echo "RENAME TABLE `".strtolower($table)."` TO `{$table}_tmp`;\n";
		echo "RENAME TABLE `{$table}_tmp` TO `{$table}`;\n";
	}
}
?>