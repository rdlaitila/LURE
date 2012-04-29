function lure.dom.createAttributeNodeObj(pAttributeName, pAttributeValue)
	local self = lure.dom.nodeObj.new(2)
	
	--===================================================================
	-- PROPERTIES                                                       =
	--===================================================================
	self.nodeName 	= pAttributeName
	---------------------------------------------------------------------
	self.nodeValue 	= pAttributeValue
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
	self.mutators.getName = function()
		return self.nodeName
	end
	---------------------------------------------------------------------
	self.mutators.getValue = function()
		return self.nodeValue
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
	self.hasChildNodes 			= nil --method not allowed
	---------------------------------------------------------------------
	self.hasAttributes 			= nil --method not allowed
	---------------------------------------------------------------------
	self.replaceChild 			= nil --method not allowed
	---------------------------------------------------------------------
	self.isEqualNode 			= nil --method not allowed
	---------------------------------------------------------------------
	self.isSameNode 			= nil --method not allowed
	---------------------------------------------------------------------	
	
	return self
end