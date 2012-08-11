-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

function lure.rom.newLineBoxObject(  )	
	local self = lure.rom.newBoxObject( {nodeType=1, boxType=3, formatingContext=2, nodeDesc="ROMLineBoxNode"} )
		
	--===================================================================
	-- PROPERTIES                                                       =
	--===================================================================
	self.layoutResponse = lure.rom.newLayoutResponseObject()
	---------------------------------------------------------------------		
	
	--====================================================================
	-- METHODS	                                                         =	
	--====================================================================	
	self.getRemainingWidth = function()
		local lineBoxWidth 	= self.computedStyle.width
		local childWidths 	= 0
		for a=1, self.childNodes.length do
			childWidths = childWidths + self.childNodes[a].computedStyle.width
		end
		if lineBoxWidth - childWidths >=0 then
			return lineBoxWidth - childWidths
		else
			return 0
		end		
	end
	---------------------------------------------------------------------		
	self.isFull = function()
		local totalWidth = 0
		for a=1, self.childNodes.length do
			totalWidth = totalWidth + self.childNodes[a].computedStyle.width
			if totalWidth > self.computedStyle.width then
				return true
			end							
		end
		return false
	end
	---------------------------------------------------------------------			
	self.layout = function()				
		--lure.throw(1, "callling layout on node: " .. tostring(self.nodeDesc) .. "(FC:".. tostring(self.formatingContext) .." BT:".. tostring(self.boxType) .." NT:".. tostring(self.nodeType) ..")")
		self.layoutResponse.clear()
		
		self.computedStyle.left		= lure.rom.computeBoxRenderStyleLeft( self )
		self.computedStyle.width 	= lure.rom.computeBoxRenderStyleWidth( self )		
		self.computedStyle.top		= lure.rom.computeBoxRenderStyleTop( self )			
		
		--do childlayout
		lure.rom.layout.doLineChildLayouts( self )						
		
		--determine line box height based on child with the largest height
		local height = 0
		for a=1, self.childNodes.length do
			child = self.childNodes[a]
			if child.computedStyle.height >= height then
				height = child.computedStyle.height
			end
		end
		self.computedStyle.height = height or 0		
		
		return self.layoutResponse
	end	
	---------------------------------------------------------------------
	self.draw = function()
		--loop through children and call subsequent draw() methods
		selfCS = self.computedStyle
		love.graphics.setColor(192, 192, 192, 255)
		--love.graphics.rectangle("line", selfCS.left, selfCS.top, selfCS.width, selfCS.height )
		for a=1, self.childNodes.length do
			local child = self.childNodes[a]			
			child.draw()
		end
	end
	---------------------------------------------------------------------
	
	
	return self
end

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::