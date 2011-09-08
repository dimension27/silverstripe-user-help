<div id="Sidebar" class="left-col">
	<% if Menu(1) %>	
		<ul id="sub-navigation">
			<% control Menu(1) %>
				<li class="$LinkingMode $FirstLast">
					<a href="$Link"><span>$MenuTitle</span></a>
					
					<% if LinkOrSection = section %>
						<% if Children %>
							<ul>
								<% control Children %>
									<li class="$LinkingMode">
										<a href="$Link"><span>$MenuTitle</span></a>
										
										<% if LinkOrSection = section %>
											<% if Children %>
												<ul>
													<% control Children %>
														<li class="$LinkingMode">
															<a href="$Link"><span>$MenuTitle</span></a>
														</li>
													<% end_control %>
												</ul>
											<% end_if %>
										<% end_if %>
									</li>	
								<% end_control %>
							</ul>
						<% end_if %>
					<% end_if %>
				</li>
			<% end_control %>
		</ul>
	<% end_if %>
</div>