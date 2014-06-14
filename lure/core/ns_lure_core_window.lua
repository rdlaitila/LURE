lure.core.windowObj = {}

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

function lure.core.windowObj.new()	
	local self 		= {}
	
	--===================================================================
	-- OBJECT METATABLE                                                 =
	--===================================================================
	local self_mt = {}	
	---------------------------------------------------------------------
	self_mt.__tostring = function(t)
		return "[object]:Window"
	end
	---------------------------------------------------------------------
	self_mt.__index = function(t,k)
		local mutatorfound = false
		--print(rawget(t,k))
		if rawget(t,k) == nil then
			-- loop through the mutators table to see if we can match a getter
			for i,v in pairs( t.mutators ) do
				--print(i)
				if ("GET"..k:upper()) == i:upper() then
					--print("match")
					return t.mutators[i]()
				end
			end
		else
			--if no mutator found, simply return the rawget key
			return rawget(t,k)
		end
	end
	---------------------------------------------------------------------
	self_mt.__newindex = function(t,k,v)				
		local mutatorfound = false
		local mutatorkey = "SET"..k:upper()
		--print(k)		
		if rawget(t, "mutators") then
			-- loop through the mutators table to see if we can match a setter
			for key in pairs(t.mutators) do
				if key:upper() == mutatorkey then					
					t.mutators[key](v)
					mutatorfound = true
				end
			end	
		end
		--if no mutator found, simply rawset the key and value
		if mutatorfound == false then
			rawset(t,k,v)			
		end		
	end
	---------------------------------------------------------------------
	
	--===================================================================
	-- MUTATORS                                                         =
	--===================================================================
	self.mutators = {}
	---------------------------------------------------------------------
	self.mutators.getDocument = function()		
		return lure.document
	end
	self.mutators.setDocument = function()
		print("LURE ERROR:: You cannot set the value of window.document!")
	end
	---------------------------------------------------------------------
	
	--===================================================================
	-- PROPERTIES                                                       =
	--===================================================================
	self.isAlerting 		= false
	---------------------------------------------------------------------	
	self.innerWidth 		= love.graphics.getWidth()
	---------------------------------------------------------------------	
	self.innerHeight 		= love.graphics.getHeight()
	---------------------------------------------------------------------
	self.timeouts			= {} -- holds setTimeouts objects
	---------------------------------------------------------------------
	self.intervals			= {} -- holds setInterval objects
	---------------------------------------------------------------------
	self.modalDialogStack 	= {}
	---------------------------------------------------------------------
	
	--====================================================================
	-- METHODS	                                                         =
	--====================================================================
	self.update = function()		
		-- assert setTimeout's
		for k, v in ipairs(self.timeouts) do
			if love.timer.getTime() >= self.timeouts[k].endDT then				
				if type(self.timeouts[k].callback) == "function" then
					self.timeouts[k].callback()
					self.clearTimeout(self.timeouts[k])				
				elseif type(self.timeouts[k].callback) == "string" then
					assert(loadstring(self.timeouts[k].callback))()
					self.clearTimeout(self.timeouts[k])
				end				
			end			
		end
		
		-- assert setInterval's
		for k, v in ipairs(self.intervals) do
			if love.timer.getTime() >= self.intervals[k].startDT then				
				if type(self.intervals[k].callback) == "function" then
					self.intervals[k].callback()
					self.intervals[k].startDT 		= self.intervals[k].startDT + self.intervals[k].recallDT
					self.intervals[k].iterations 	= self.intervals[k].iterations + 1
				elseif type(self.intervals[k].callback) == "string" then
					assert(loadstring(self.intervals[k].callback))()
					self.intervals[k].startDT 		= self.intervals[k].startDT + self.intervals[k].recallDT
					self.intervals[k].iterations 	= self.intervals[k].iterations + 1					
				end				
			end			
		end	

		--update first modal dialog in the stack
		if table.getn( self.modalDialogStack ) >= 1 then
			local returnResponse = self.modalDialogStack[1].update()			
			if returnResponse == 1 then				
				table.remove(self.modalDialogStack, 1)
			end
		end
		
	end
	---------------------------------------------------------------------
	self.draw = function()		
		--draw first modal dialog in the stack
		if table.getn( self.modalDialogStack ) >= 1 then
			self.modalDialogStack[1].draw()
		end
	end	
	---------------------------------------------------------------------
	self.alert = function(pValue, pIsBlocking, pCallback)
		local alertObject = lure.core.newAlertBoxObject(pValue, pIsBlocking, pCallback)
		table.insert(self.modalDialogStack, alertObject)
	end	
	---------------------------------------------------------------------
	self.clearInterval = function(pInterval)
		for k, v in ipairs(self.intervals) do
			if pInterval.id == self.intervals[k].id then
				table.remove(self.intervals, k)
			end
		end
	end
	---------------------------------------------------------------------
	self.clearTimeout = function(pTimeout)		
		for k, v in ipairs(self.timeouts) do
			if pTimeout.id == self.timeouts[k].id then
				table.remove(self.timeouts, k)
			end
		end
	end
	---------------------------------------------------------------------
	self.close = function()
	end
	---------------------------------------------------------------------
	self.confirm = function()
	end
	---------------------------------------------------------------------
	self.createPopup = function()
	end
	---------------------------------------------------------------------
	self.focus = function()
	end
	---------------------------------------------------------------------
	self.moveBy = function()
	end
	---------------------------------------------------------------------
	self.moveTo = function()
	end
	---------------------------------------------------------------------
	self.open = function()
	end
	---------------------------------------------------------------------
	self.print = function()
	end
	---------------------------------------------------------------------
	self.prompt = function()
	end
	---------------------------------------------------------------------
	self.resizeBy = function()
	end
	---------------------------------------------------------------------
	self.resizeTo = function()
	end
	---------------------------------------------------------------------
	self.scroll = function()
	end
	---------------------------------------------------------------------
	self.scrollBy = function()
	end
	---------------------------------------------------------------------
	self.scrollTo = function()
	end
	---------------------------------------------------------------------
	self.setInterval = function( pCode, pMillisec )
		local interval = {}
		
		interval.id			= lure.UUID()
		interval.startDT 	= love.timer.getTime()
		interval.recallDT	= pMillisec * .001
		interval.callback	= pCode
		interval.iterations	= 0
		
		table.insert( self.intervals, interval )
		return interval		
	end
	---------------------------------------------------------------------
	self.setTimeout = function( pCode, pMillisec )
		local timeout = {}
		
		timeout.id 			= lure.UUID()
		timeout.startDT 	= love.timer.getTime()	
		timeout.endDT 		= timeout.startDT + (pMillisec * .001)		
		timeout.callback 	= pCode
		
		table.insert( self.timeouts, timeout )
		return timeout
	end
	---------------------------------------------------------------------
	
	setmetatable(self, self_mt)
	return self
end