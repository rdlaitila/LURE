lure.rom.nodeListObj = {}

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

function lure.rom.nodeListObj.new()
	local self = {}
	local self_mt = {}
	setmetatable(self, self_mt)
	
	--===================================================================
	-- OBJECT METATABLE                                                 =
	--===================================================================
	self_mt.__tostring = function(t)
		return "[object]:NodeList"
	end
	---------------------------------------------------------------------
	self_mt.__index = function(t,k)
		local mutatorfound = false
		if rawget(t,"mutators") then			
			for i,v in pairs( t.mutators ) do -- loop through the mutators table to see if we can match a getter
				if ( "GET"..tostring( k ):upper() ) == i:upper() then										
					return t.mutators[i]()					
				end
			end
		end
		if mutatorfound == false then
			if type(k) == "number" then
				return self.item(k)
			else			
				return rawget(t,k) --if no mutator found, simply return the rawget key if exists
			end
		end
	end
	---------------------------------------------------------------------
	self_mt.__newindex = function(t,k,v)				
		local mutatorfound = false
		local mutatorkey = "SET"..k:upper()		
		if rawget(t, "mutators") then			
			for key in pairs(t.mutators) do -- loop through the mutators table to see if we can match a setter
				if key:upper() == mutatorkey then					
					t.mutators[key](v)
					mutatorfound = true
				end
			end	
		end		
		if mutatorfound == false then
			rawset(t,k,v) --if no mutator found, simply rawset the key and value
		end		
	end	
	---------------------------------------------------------------------
	
	--===================================================================
	-- MUTATORS                                                         =
	--===================================================================
	self.mutators = {}
	---------------------------------------------------------------------	
	self.mutators.getLength = function()
		return table.getn(self.nodes)
	end
	---------------------------------------------------------------------	
	self.mutators.setLength = function()
		lure.throw(4, "Cannot set length property on object: '".. tostring(self) .. "'. Reason: NOT_ALLOWED")
	end
	---------------------------------------------------------------------	
	
	-- PROPERTIES -------------------------------------------------------	
	self.nodes = {}		
	---------------------------------------------------------------------
	
	-- METHODS ----------------------------------------------------------	
	self.item = function(pIndex)
		return self.nodes[pIndex]
	end	
	---------------------------------------------------------------------
	self.addItem = function(pNodeObj)
		table.insert(self.nodes, pNodeObj)		
		return pNodeObj
	end
	---------------------------------------------------------------------
	self.removeItem = function(pNodeObj)
		if self.length > 0 then
			for k, v in ipairs(self.nodes) do
				if self.nodes[k] == pNodeObj then
					local oldNode = self.nodes[k]
					table.remove(self.nodes, k)					
					return oldNode
				end
			end
		end
	end
	---------------------------------------------------------------------
	self.getNodeIndex = function( pNode )
		for a=1, table.getn(self.nodes) do
			if self.nodes[a] == pNode then
				return a
			end
		end
		return nil
	end
	---------------------------------------------------------------------
	return self
end

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::