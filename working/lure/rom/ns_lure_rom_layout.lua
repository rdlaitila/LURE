lure.rom.layout = {}
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
lure.rom.layout.doBlockChildLayouts = function(pRomNode)
	local self = pRomNode
	if self.hasChildNodes() then
		--[[we create a reference list only because using node.childNodes.length can change
		depending on if the child propogates to the parent to change rom node position
		ex: child node has position:fixed and gets moved to child of viewport]]	
		local childRefList = {}
		for a=1, self.childNodes.length do
			table.insert(childRefList, self.childNodes[a])
		end			
		for a=1, table.getn(childRefList) do
				local child = childRefList[a]
			if child.nodeType == 1 then
				child.layout()					
			end
		end
		childRefList = nil
	end
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
lure.rom.layout.doInlineChildLayouts = function(pRomNode)
	local self = pRomNode
	
	--move all children to single line box			
	self.normalizeTextNodes()
	self.normalizeLineBoxes()			
	if self.hasChildNodes() then
		local childList   = {}
		local newLineBox  = lure.rom.newLineBoxObject()
		for a=1, self.childNodes.length do
			local child = self.childNodes[a]
			if child.boxType == 1 or child.boxType == 2 then						
				table.insert( childList, child )
			end
		end				
		for a=1, table.getn( childList ) do
			newLineBox.appendChild( self.removeChild( childList[a] ), true )
		end
		self.appendChild( newLineBox, true )				
		
		--do child layouts				
		local a	= 1
		local layoutCompleted = false
		while layoutCompleted == false do
			local childLayoutResponse 	= lure.rom.newLayoutResponseObject()
			local child 				= self.childNodes[a]
			if child.boxType == 3 then
				childLayoutResponse = child.layout()
				if childLayoutResponse.type == 1 then
					if table.getn(childLayoutResponse.nodes) > 0 then
						local newLineBox = lure.rom.newLineBoxObject()							
						for b=1, table.getn( childLayoutResponse.nodes ) do									
							newLineBox.appendChild( childLayoutResponse.nodes[b], true )
						end
						self.appendChild(newLineBox, true)
					end
				end
			end
			if a >= self.childNodes.length then
				layoutCompleted = true
			else
				a = a + 1
			end					
		end				
	end		
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
lure.rom.layout.doLineChildLayouts = function( pRomNode )
	local self = pRomNode	
	if self.hasChildNodes() then
		local childLayoutResponse = lure.rom.newLayoutResponseObject()
		local a = 1	
		local layoutCompleted = false
		while layoutCompleted == false do			
			local child = self.childNodes[a]
			if child.nodeType == 1 then				
				childLayoutResponse = child.layout()
				if a > 1 then
					if self.getTotalChildWidths(1, a) > self.computedStyle.width then														
						self.layoutResponse.type 	= 1						
						local childList 			= {}					
						for b=a, self.childNodes.length do							
							table.insert( childList, self.childNodes[b] )														
						end
						for b=1, table.getn(childList) do
							table.insert( self.layoutResponse.nodes, self.removeChild( childList[b] ))
						end
						break
					end
				end					
			elseif child.nodeType == 3 then
				childLayoutResponse = child.layout()					
				if childLayoutResponse.type == 1 then 
					self.layoutResponse.type = 1
					for b=1, table.getn( childLayoutResponse.nodes ) do														
						table.insert( self.layoutResponse.nodes, childLayoutResponse.nodes[b] )							
					end
					local childList = {}						
					for b=a+1, self.childNodes.length do
						if self.childNodes[b] ~= nil then								
							table.insert( childList, self.childNodes[b] )
						end
					end
					for b=1, table.getn(childList) do  
						table.insert( self.layoutResponse.nodes, self.removeChild( childList[b] ))
					end						
					break
				end					
			end				
			
			--check to stop while loop
			if a >= self.childNodes.length then 
				layoutCompleted = true 
			else
				a = a + 1				
			end				
		end				
	end
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
