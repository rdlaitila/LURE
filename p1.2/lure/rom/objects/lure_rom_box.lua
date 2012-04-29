-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

function lure.rom.newBoxObject( pParamTable )
	--pParamTable: {nodeDesc=STRING, nodeType=NUMBER, boxType=NUMBER, formatingContext=NUMBER}	
	local self = lure.rom.newNodeObject(pParamTable["nodeType"]) --INHERIT FROM LURE_ROM_NODE		
	
	--===================================================================
	-- PROPERTIES                                                       =
	--===================================================================	
	self.nodeDesc				= pParamTable["nodeDesc"] 
	---------------------------------------------------------------------	
	self.boxType				= pParamTable["boxType"] 
	---------------------------------------------------------------------	
	self.formatingContext 		= pParamTable["formatingContext"]
	---------------------------------------------------------------------
	self.renderStyle			= lure.rom.newBoxRenderStyleObject()
	---------------------------------------------------------------------
	self.computedStyle			= lure.rom.newBoxComputedStyleObject()
	---------------------------------------------------------------------
	
	--====================================================================
	-- METHODS	                                                         =	
	--====================================================================	
	self.appendChild = function( pNode, pSkipFormatChecks )
		--moved to lure.rom namespace for object size reduction
		return lure.rom.appendChild( self, pNode, pSkipFormatChecks )
	end
	---------------------------------------------------------------------	
	self.getTotalChildWidths = function(pStart, pStop)
		local totalWidth = 0
		local start = pStart or 1
		local stop 	= pStop or self.childNodes.length
		for a=start, stop do
			totalWidth = totalWidth + ( self.childNodes[a].computedStyle.width or 0 )
		end
		return totalWidth
	end
	---------------------------------------------------------------------		
	self.normalizeTextNodes = function()		
		local textNodes = lure.rom.nodeListObj.new()
		for a=1, self.childNodes.length do
			if self.childNodes[a].boxType == 3 then
				for b=1, self.childNodes[a].childNodes.length do
					local child = self.childNodes[a].childNodes[b]
					if child.nodeType == 3 then
						textNodes.addItem( child )
					end
				end
			end
		end		
		
		local principleTextNodeList = {}		
		for a=1, textNodes.length do
			if textNodes[a].isPrincipleTextNode() then
				print(textNodes[a])
				table.insert( principleTextNodeList, textNodes[a] )
			end
		end
		
		for a=1, table.getn( principleTextNodeList ) do
			principleTextNodeList[a].normalize()
		end
	end
	---------------------------------------------------------------------	
	self.normalizeLineBoxes = function()
		local lineBoxes = {}
		for a=1, self.childNodes.length do
			if self.childNodes[a].boxType == 3 then
				table.insert(lineBoxes, self.childNodes[a])
			end			
		end
		for a=1, table.getn( lineBoxes ) do
			local lineBox = lineBoxes[a]
			while lineBox.hasChildNodes() == true do				
				self.appendChild( lineBox.removeChild( lineBox.childNodes[1] ), true )				
			end
		end
		for a=1, table.getn( lineBoxes ) do
			self.removeChild( lineBoxes[a] )
		end
	end
	---------------------------------------------------------------------
	--[[self.layout = function()
		lure.throw(1, "callling layout on node: " .. tostring(self.nodeDesc) .. "(FC:".. tostring(self.formatingContext) .." BT:".. tostring(self.boxType) .." NT:".. tostring(self.nodeType) ..")")
		
		if self.hasChildNodes() then
			-- we create a reference list only because using node.childNodes.length can change
			-- depending on if the child propogates to the parent to change rom node position
			-- ex: child node has position:fixed and gets moved to child of viewport
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
		
	end]]	
	---------------------------------------------------------------------
	self.draw = function()		
		--backgroundColor
		selfCS = self.computedStyle
		if selfCS.backgroundColor ~= nil then			
			love.graphics.setColor( selfCS.backgroundColor[1], selfCS.backgroundColor[2], selfCS.backgroundColor[3], selfCS.backgroundColor[4] )
			love.graphics.rectangle("fill", selfCS.left, selfCS.top, selfCS.width, selfCS.height )
		end	

		love.graphics.setColor(192, 192, 192, 255)
		--love.graphics.rectangle("line", selfCS.left, selfCS.top, selfCS.width, selfCS.height )
		
		--loop through children and call subsequent draw() methods
		for a=1, self.childNodes.length do
			local child = self.childNodes[a]			
			child.draw()
		end
	end
	---------------------------------------------------------------------
	
	return self
end

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::