-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

function lure.rom.newNodeObject(pNodeType)
	local self = {}	
	
	--===================================================================
	-- OBJECT METATABLE                                                 =
	--===================================================================
	local self_mt = {}	
	---------------------------------------------------------------------
	self_mt.__tostring = function(t)
		return "[object]:" .. tostring(self.nodeDesc)
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
	-- PROPERTIES                                                       =
	--===================================================================	
	self.nodeType 			= pNodeType	
	---------------------------------------------------------------------	
	self.nodeDesc			= lure.rom.nodeTypes[pNodeType]
	---------------------------------------------------------------------	
	self.attributes 		= lure.rom.namedNodeMapObj.new()
	---------------------------------------------------------------------
	self.childNodes 		= lure.rom.nodeListObj.new()
	---------------------------------------------------------------------
	self.parentNode 		= nil	
	---------------------------------------------------------------------		
	
	--===================================================================
	-- MUTATORS                                                         =
	--===================================================================
	self.mutators = {}
	---------------------------------------------------------------------		
	
	--====================================================================
	-- METHODS	                                                         =	
	--====================================================================			
	self.appendChild = function( pNodeObj )
		local newNode = self.childNodes.addItem(pNodeObj)
		newNode.parentNode = self
		return newNode
	end	
	---------------------------------------------------------------------
	self.removeChild = function( pNodeObj )		
		local removedNode = self.childNodes.removeItem(pNodeObj)
		removedNode.parentNode = nil
		return removedNode
	end
	---------------------------------------------------------------------
	self.setAttribute = function(pAttributeName, pAttributeValue)
		local attribute = lure.dom.createAttributeNodeObj(pAttributeName, pAttributeValue)		
		self.attributes.setNamedItem(attribute)		
	end
	---------------------------------------------------------------------
	self.removeAttribute = function(pAttributeName)
		local attribute = self.attributes.removeNamedItem(self.attributes.getNamedItem(pAttributeName).nodeName)				
		return attribute		
	end
	---------------------------------------------------------------------
	self.getAttribute = function(pAttributeName)				
		if self.attributes ~= nil then
			local attribute = self.attributes.getNamedItem(pAttributeName)		
			if attribute == nil then
				return nil
			else
				return attribute.nodeValue
			end
		else
			return nil
		end
	end
	---------------------------------------------------------------------
	self.hasChildNode = function( pNodeObj )
		if self.hasChildNodes() then
			for a=1, self.childNodes.length do
				local child = self.childNodes[a]
				if child == pNodeObj then
					return true
				end
			end
		else
			return false
		end
	end
	---------------------------------------------------------------------
	self.hasChildNodes = function()
		if self.childNodes ~= nil and self.childNodes.length >= 1 then
			return true
		else
			return false
		end
	end
	---------------------------------------------------------------------
	self.hasAttributes = function()
		if self.attributes ~= nil and self.attributes.length > 0 then
			return true
		else
			return false
		end
	end
	---------------------------------------------------------------------
	self.hasAttribute = function( pAttribute )
		local response = self.getAttribute(pAttribute)		
		if response ~= nil then
			return true
		else
			return false
		end
	end
	---------------------------------------------------------------------
	self.isSameNode = function(pCompareNode)
		if self == pCompareNode then
			return true
		else
			return false
		end
	end
	---------------------------------------------------------------------	
	self.getSiblingIndex = function()
		--returns the index position of this node in relation to sibling nodes
		local pos = 0
		for a=1, self.parentNode.childNodes.length do
			sibling = self.parentNode.childNodes[a]
			if self ~= sibling then
				pos = pos + 1
			elseif self == sibling then
				return pos
			end
		end
	end
	---------------------------------------------------------------------	
	self.insertBefore = function(pNewRomNode, pRefRomNode)
		for a=1, self.childNodes.length do
			local child = self.childNodes[a]
			if child == pRefRomNode then
				table.insert(self.childNodes.nodes, a-1, pNewRomNode)
				pNewRomNode.parentNode = self
			end
			break
		end
		return pNewRomNode
	end
	---------------------------------------------------------------------	
	self.insertAfter = function(pNewRomNode, pRefRomNode)
		for a=1, self.childNodes.length do
			local child = self.childNodes[a]
			if child == pRefRomNode then
				table.insert(self.childNodes.nodes, a+1, pNewRomNode)
				pNewRomNode.parentNode = self
			end
			break
		end
		return pNewRomNode
	end
	---------------------------------------------------------------------	
	
	setmetatable(self, self_mt)	
	return self
end

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::