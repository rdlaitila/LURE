function lure.dom.createNamedNodeMapObj()
	local self = {}
	local cnnmo_mt = {}		
	
	--===================================================================
	-- PROPERTIES                                                       =
	--===================================================================
	self.nodes 	= {}
	---------------------------------------------------------------------
	self.length = table.getn(self.nodes)
	---------------------------------------------------------------------
	
	--===================================================================
	-- OBJECT METATABLE                                                 =
	--===================================================================
	cnnmo_mt.__index = function(t, k)		
		if type(k) == "number" then
			return self.nodes[k]
		elseif type(k) == "string" then
			for i, v in ipairs(self.nodes) do
				if self.nodes[i].nodeName == k then
					return self.nodes[i]
				end
			end
		else
			return nil
		end		
	end
	---------------------------------------------------------------------		
	cnnmo_mt.__tostring = function(t)
		return "[object]:NamedNodeMap"
	end
	---------------------------------------------------------------------	
	
	--====================================================================
	-- METHODS	                                                         =	
	--====================================================================	
	self.setNamedItem = function(pNode, pIndex)				
		if self.length == 0 then			
			table.insert(self.nodes, pNode)
			self.length = table.getn(self.nodes)
			return pNode
		elseif self.length > 0 then
			for i, v in ipairs(self.nodes) do
				if self.nodes[i].nodeName == pNode.nodeName then
					self.nodes[i] = pNode
					return pNode
				else
					local oldNode = self.nodes[i]
					table.insert(self.nodes, pNode)
					self.length = table.getn(self.nodes)
					return oldNode
				end
			end
		end		
	end
	---------------------------------------------------------------------
	self.getNamedItem = function(pName)		
		local returnvalue = nil
		for k, v in ipairs(self.nodes) do			
			if self.nodes[k].nodeName == pName then				
				returnvalue = self.nodes[k]
			end
		end
		return returnvalue
	end
	---------------------------------------------------------------------
	self.removeNamedItem = function(pName)
		if self.length > 0 then
			for k, v in ipairs(self.nodes) do
				if self.nodes[k].nodeName == pName then
					local oldNode = self.nodes[k]
					table.remove(self.nodes, k)
					self.length = self.length - 1
					return oldNode
				end
			end
		end
	end
	---------------------------------------------------------------------
	self.item = function(pIndex)
		if self.length > 0 then
			return self.nodes[pIndex]
		else
			return nil
		end
	end
	---------------------------------------------------------------------	
	
	setmetatable(self, cnnmo_mt)
	return self
end
