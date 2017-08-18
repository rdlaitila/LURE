function lure.dom.createNodeListObj()
	local self = {}
	local self_mt = {}
	setmetatable(self, self_mt)
	
	-- PROPERTIES -------------------------------------------------------	
	self.nodes 		= {}
	self.length 	= table.getn(self.nodes)
	self.nodeType 	= 13
	---------------------------------------------------------------------
	
	-- METHODS ----------------------------------------------------------
	self_mt.__index = function(t, k)
		if type(k) == "number" then
			return self.item(k)
		else
			return self.nodes
		end		
	end	
	self_mt.__tostring = function(t)
		return "[object]:NodeList"
	end
	---------------------------------------------------------------------
	self.item = function(pIndex)
		return self.nodes[pIndex]
	end	
	---------------------------------------------------------------------
	self.addItem = function(pNodeObj, pIndex)
		if pIndex ~= nil and type(pIndex) == "number" then
			table.insert(self.nodes, pIndex, pNodeObj)
		else
			table.insert(self.nodes, pNodeObj)
		end
		self.length = self.length + 1
		return pNodeObj
	end
	---------------------------------------------------------------------
	self.removeItem = function(pNodeObj)
		if self.length > 0 then
			for k, v in ipairs(self.nodes) do
				if self.nodes[k] == pNodeObj then
					local oldNode = self.nodes[k]
					table.remove(self.nodes, k)
					self.length = self.length - 1
					return oldNode
				end
			end
		end
	end
	---------------------------------------------------------------------
	return self
end