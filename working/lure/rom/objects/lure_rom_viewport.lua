-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

function lure.rom.newViewportObject()
	--INHERIT FROM LURE_ROM_BOX	
	local self = lure.rom.newBoxObject( {nodeType=2,boxType=1,formatingContext=1} )
	
	--===================================================================
	-- PROPERTIES                                                       =
	--===================================================================
	self.nodeDesc		= "ROMViewportNode"	
	---------------------------------------------------------------------	
	
	--====================================================================
	-- METHODS	                                                         =	
	--====================================================================	
	self.layout = function()		
		--lure.throw(1, "callling layout on node: " .. tostring(self.nodeDesc) .. "(FC:".. tostring(self.formatingContext) .." BT:".. tostring(self.boxType) .." NT:".. tostring(self.nodeType) ..")")
		
		self.computedStyle.backgroundColor 	= lure.rom.computeBoxRenderStyleBackgroundColor( self )
		self.computedStyle.left				= lure.rom.computeViewportRenderStyleLeft( self )
		self.computedStyle.top				= lure.rom.computeViewportRenderStyleTop( self )		
		self.computedStyle.width 			= lure.rom.computeViewportRenderStyleWidth( self )
		if self.computedStyle.height ~= "auto" then
			self.computedStyle.height			= lure.rom.computeViewportRenderStyleHeight( self )
		end
		
		--do child node layouts
		if self.hasChildNodes() then
			for a=1, self.childNodes.length do
				if self.childNodes[a].nodeType == 1 then					
					self.childNodes[a].layout()
				end
			end
		end

		if self.computedStyle.height == "auto" then
			self.computedStyle.height = lure.rom.computeViewportRenderStyleHeight( self )
		end		
	end
	---------------------------------------------------------------------	
	self.draw = function()		
		-- grab previous scissor
		local prevScissor 	= {}		
		prevScissor.x, prevScissor.y, prevScissor.width, prevScissor.height = love.graphics.getScissor()		
		
		-- set scissor to viewport dimensions		
		love.graphics.setScissor( self.computedStyle.left, self.computedStyle.top, self.computedStyle.width, self.computedStyle.height )			
		
		--backgroundColor
		selfRS = self.computedStyle
		if self.computedStyle.backgroundColor ~= nil then
			love.graphics.setColor( selfRS.backgroundColor[1], selfRS.backgroundColor[2], selfRS.backgroundColor[3], selfRS.backgroundColor[4] )
			love.graphics.rectangle("fill", selfRS.left, selfRS.top, selfRS.width, selfRS.height )
		end		
		
		--loop through children and call subsequent draw() methods
		for a=1, self.childNodes.length do
			local child = self.childNodes[a]			
			child.draw()
		end
		
		-- set scissor back	to original value prior to viewport draw
		prevScissor.x 		= prevScissor.x or 0
		prevScissor.y 		= prevScissor.y or 0
		prevScissor.width 	= prevScissor.width or love.graphics.getWidth()
		prevScissor.height 	= prevScissor.height or love.graphics.getHeight()
		love.graphics.setScissor( prevScissor.x, prevScissor.y, prevScissor.width, prevScissor.height )	
	end
	---------------------------------------------------------------------
	
	return self
end

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::