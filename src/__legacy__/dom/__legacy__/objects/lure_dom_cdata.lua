function lure.dom.createCharacterDataNodeObj(pData)
	--INHERIT FROM DOM NODE
	local self = lure.dom.nodeObj.new(4)
	
	--===================================================================
	-- PROPERTIES                                                       =
	--===================================================================
	self.nodeName 	= "#CDATASECTION"
	---------------------------------------------------------------------
	self.nodeValue 	= pData
	---------------------------------------------------------------------
	self.attributes = nil --property not allowed
	---------------------------------------------------------------------
	self.parentNode = nil --property not allowed
	---------------------------------------------------------------------
	self.childNodes = nil --property not allowed
	---------------------------------------------------------------------	

	--===================================================================
	-- MUTATORS                                                         =
	--===================================================================
	self.mutators.getData = function()
		return self.nodeValue
	end
	---------------------------------------------------------------------
	self.mutators.getLength = function()
		return self.nodeValue:len()
	end
	---------------------------------------------------------------------
	self.mutators.setData = function(pText)
		self.nodeValue = pText
	end	
	self.mutators.setLength = function()
		return "LURE ERROR:: You cannot set the lengh property"
	end
	---------------------------------------------------------------------
	self.mutators.getId					= nil --mutator not allowed
	---------------------------------------------------------------------
	self.mutators.getClass				= nil --mutator not allowed
	---------------------------------------------------------------------
	self.mutators.getFirstChild 		= nil --mutator not allowed
	---------------------------------------------------------------------
	self.mutators.getLastChild			= nil --mutator not allowed
	---------------------------------------------------------------------
	self.mutators.getNextSibling 		= nil --mutator not allowed
	---------------------------------------------------------------------
	self.mutators.getPreviousSilbing 	= nil --mutator not allowed
	---------------------------------------------------------------------
	self.mutators.setId					= nil --mutator not allowed
	---------------------------------------------------------------------
	self.mutators.setClass				= nil --mutator not allowed
	---------------------------------------------------------------------	
	
	--===================================================================
	-- METHODS	                                                        =	
	--===================================================================	
	self.appendData = function(pString)
		if type(pString) == "string" then
			self.nodeValue = self.nodeValue + pString
		else
			print("LURE:ERROR: appendData only accepts parameter of type 'string'")
		end
	end
	---------------------------------------------------------------------
	self.deleteData = function(pStart, pLength)				
	end
	---------------------------------------------------------------------
	self.appendChild 			= nil --method not allowed
	---------------------------------------------------------------------
	self.getElementById 		= nil --method not allowed
	---------------------------------------------------------------------
	self.getElementsByTagName 	= nil --method not allowed
	---------------------------------------------------------------------
	self.getElementsByClassName = nil --method not allowed
	---------------------------------------------------------------------
	self.removeChild 			= nil --method not allowed
	---------------------------------------------------------------------
	self.setAttribute			= nil --method not allowed
	---------------------------------------------------------------------
	self.getAttribute 			= nil --method not allowed
	---------------------------------------------------------------------
	self.removeAttribute 		= nil --method not allowed
	---------------------------------------------------------------------
	self.hasChildNodes 			= function() return false end
	---------------------------------------------------------------------
	self.hasAttributes 			= function() return false end
	---------------------------------------------------------------------
	self.replaceChild 			= nil --method not allowed
	---------------------------------------------------------------------
	self.isEqualNode 			= nil --method not allowed
	---------------------------------------------------------------------
	self.isSameNode 			= nil --method not allowed
	---------------------------------------------------------------------
	
	return self
end