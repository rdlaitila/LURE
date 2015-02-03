function lure.rom.newTextNodeObject( pTextData, pDoWrap, pPrincipleTextNode, pWrapType)
	local self = lure.rom.newBoxObject( {nodeType=3, boxType=2, formatingContext=2, nodeDesc="ROMTextNode"} )	
	
	--===================================================================
	-- PROPERTIES                                                       =
	--===================================================================
	self.data 				= pTextData	
	---------------------------------------------------------------------		
	self.principleTextNode 	= pPrincipleTextNode or self
	---------------------------------------------------------------------		
	self.childTextNodes 	= lure.rom.nodeListObj.new()
	---------------------------------------------------------------------
	self.font				= love.graphics.newFont(15)
	---------------------------------------------------------------------
	self.layoutResponse 	= lure.rom.newLayoutResponseObject()
	---------------------------------------------------------------------
	self.doWrap				= pDoWrap or false
	---------------------------------------------------------------------	
	self.wrapType			= pWrapType or 1
	--1: character wrap
	--2: word wrap	
	---------------------------------------------------------------------
	
	--====================================================================
	-- METHODS	                                                         =	
	--====================================================================
	self.normalize = function()
		local principle = self.principleTextNode
		principle.data = principle.getFullDataString()		
		principle.destroyChildTextNodes()		
	end
	---------------------------------------------------------------------	
	self.isPrincipleTextNode = function()
		if self.principleTextNode == self then
			return true
		else
			return false
		end
	end	
	---------------------------------------------------------------------	
	self.getFullDataString = function()
		local data = self.principleTextNode.data		
		for a=1, self.principleTextNode.childTextNodes.length do
			local child = self.principleTextNode.childTextNodes[a]
			data = data .. child.data
		end				
		return data	
	end
	---------------------------------------------------------------------	
	self.destroyChildTextNodes = function()
		local principle = self.principleTextNode
		local childList	= {}
		
		for a=1, principle.childTextNodes.length do
			table.insert(childList, principle.childTextNodes[a])
		end
		for a=1, table.getn(childList) do			
			childList[a].parentNode.removeChild( childList[a] )			
		end		
		principle.childTextNodes = lure.rom.nodeListObj.new()
	end	
	---------------------------------------------------------------------		
	self.layout = function()
		--lure.throw(1, "callling layout on node: " .. tostring(self.nodeDesc) .. "(FC:".. tostring(self.formatingContext) .." BT:".. tostring(self.boxType) .." NT:".. tostring(self.nodeType) ..")")
		self.layoutResponse = lure.rom.newLayoutResponseObject()
	
		self.computedStyle.display 	= "inline"
		self.computedStyle.left 	= lure.rom.computeBoxRenderStyleLeft( self )
		self.computedStyle.top 		= lure.rom.computeBoxRenderStyleTop( self )
		self.computedStyle.color	= lure.rom.computeBoxRenderStyleColor( self.principleTextNode )		
		self.computedStyle.width 	= 0 --set to zero as to not break text width calculations below		
		
		if self.doWrap then
			if self.wrapType == 1 then				
				for a=1, self.data:len() do
					local currentWidth	 = self.font:getWidth( self.data:sub(1, a) )
					local remainingWidth = self.parentNode.computedStyle.width - self.parentNode.getTotalChildWidths(1, self.parentNode.childNodes.getNodeIndex(self) )					
					if currentWidth > remainingWidth and self.data:len() > 1 then
						if self.parentNode.childNodes[1] == self and remainingWidth == 0 then
							break
						end
						local newTextNode 	= lure.rom.newTextNodeObject( self.data:sub( a, self.data:len() ), self.principleTextNode.doWrap, self.principleTextNode, self.principleTextNode.wrapType )					
						newTextNode.font	= self.principleTextNode.font						
						self.data 			= self.data:sub(1, a-1 )
						self.layoutResponse.type = 1
						table.insert( self.layoutResponse.nodes, self.principleTextNode.childTextNodes.addItem( newTextNode ) )					
						break			
					end			
				end	
			elseif self.wrapType == 2 then
				local currentWidth 		= 0
				local remainingWidth 	= self.parentNode.computedStyle.width - self.parentNode.getTotalChildWidths(1, self.parentNode.childNodes.getNodeIndex(self) )			
				local words 			= {}
				for word in string.gmatch(self.data, "%a+") do
					table.insert(words, word)					
				end				
				for a=1, table.getn( words ) do
					local word = words[a]					
					currentWidth = currentWidth + self.font:getWidth( word ) + self.font:getWidth(" ")
					if  currentWidth > remainingWidth and a > 1 or currentWidth > remainingWidth and self.parentNode.childNodes.length > 1 and self.parentNode.childNodes[1] ~= self then
						if self.parentNode.childNodes[1] == self and remainingWidth == 0 then
							break
						end						
						local currString = ""
						local newString = ""
						for b=1, a-1 do	currString = currString .. words[b] .. " " end
						for b=a, table.getn(words) do newString = newString .. words[b] .. " " end						
						local newTextNode 	= lure.rom.newTextNodeObject( newString, self.principleTextNode.doWrap, self.principleTextNode, self.principleTextNode.wrapType )					
						newTextNode.font	= self.principleTextNode.font						
						self.data 			= currString
						self.layoutResponse.type = 1
						table.insert( self.layoutResponse.nodes, self.principleTextNode.childTextNodes.addItem( newTextNode ) )					
						break
					end
				end
			end
		end
		
		self.computedStyle.width 	= self.font:getWidth( self.data )
		
		if self.data:len() > 0 and self.data ~= "" then
			self.computedStyle.height 	= self.font:getHeight()
		else
			self.computedStyle.height = 0
		end
		
		return self.layoutResponse
	end
	---------------------------------------------------------------------	
	self.draw = function()
		love.graphics.setFont( self.font )		
		love.graphics.setColor( self.computedStyle.color[1] or 0, self.computedStyle.color[2] or 0, self.computedStyle.color[3] or 0, 255 )
		love.graphics.print( self.data, self.computedStyle.left, self.computedStyle.top  )
	end
	---------------------------------------------------------------------	
	
	return self
end