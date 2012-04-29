function lure.core.newAlertBoxObject(pData, pIsBlocking, pCallback)
	local self = {}
	
	--===================================================================
	-- OBJECT METATABLE                                                 =
	--===================================================================
	local self_mt = {}	
	---------------------------------------------------------------------	
	self_mt.__tostring = function(t)
		return "[object]:AlertBox"
	end
	---------------------------------------------------------------------
	
	--===================================================================
	-- PROPERTIES                                                       =
	--===================================================================
	self.data 					= ""
	---------------------------------------------------------------------
	self.isBlocking				= pIsBlocking or false
	---------------------------------------------------------------------
	self.style					= {}
	---------------------------------------------------------------------
	self.style.width 			= 300
	---------------------------------------------------------------------
	self.style.height 			= 300
	---------------------------------------------------------------------
	self.style.left 			= (love.graphics.getWidth() /2) - (self.style.width / 2) 
	---------------------------------------------------------------------
	self.style.top 				= (love.graphics.getHeight() /2) - (self.style.height / 2)
	---------------------------------------------------------------------
	self.style.padding 			= {5, 5, 5, 5}	
	---------------------------------------------------------------------
	self.style.backgroundColor 	= {211, 211, 211, 0}	
	---------------------------------------------------------------------
	self.style.borderWidth		= {0, 0, 0, 0}
	---------------------------------------------------------------------
	self.style.borderColor		= {"black", "black", "black", "black"}
	---------------------------------------------------------------------
	self.style.borderStyle		= "solid"
	---------------------------------------------------------------------
	self.style.wrap				= 300
	---------------------------------------------------------------------
	self.style.fontSize			= 12
	---------------------------------------------------------------------
	self.style.font				= love.graphics.newFont( self.style.fontSize ) 
	---------------------------------------------------------------------
	
	--====================================================================
	-- METHODS	                                                         =
	--====================================================================
	self.init = function()
		self.data 			= tostring(pData)		
		self.style.wrap 	= (self.style.width - (self.style.padding[1] + self.style.padding[4] ))
		local w, l 			= self.style.font:getWrap(self.data, self.style.wrap)		
		self.style.height 	= (l * self.style.fontSize) + (l * 2)		
	end
	---------------------------------------------------------------------
	self.update = function()
		local returnResponse = nil
		-- returnResponse:
		-- 1: DESTROY
		
		if self.checkButtonHit() == true then
			returnResponse = 1
		end		
			
		return returnResponse
	end
	---------------------------------------------------------------------
	self.draw = function()
		love.graphics.setColor(211, 211, 211)
		
		love.graphics.rectangle( "fill", self.style.left, self.style.top, self.style.width + self.style.padding[4] + self.style.padding[1], self.style.height + self.style.padding[1] + self.style.padding[2] )
		love.graphics.setColor(0, 0, 0)		
		love.graphics.printf( self.data, self.style.left + self.style.padding[4], self.style.top + self.style.padding[1], 10, "left")
	end
	---------------------------------------------------------------------
	self.checkButtonHit = function()		
		for e, a, b, c, d in love.event.poll() do
			if e == "keypressed" then
				if a == "return" then
					return true
				end
			end
		end
	end
	---------------------------------------------------------------------
	
	self.init()
	setmetatable(self, self_mt)	
	return self
end