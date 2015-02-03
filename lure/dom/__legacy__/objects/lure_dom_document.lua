function lure.dom.createDocumentNodeObj()	
	local self = lure.dom.nodeObj.new(9)
	
	--===================================================================
	-- PROPERTIES                                                       =
	--===================================================================	
	self.nodeName 			= "#document"
	---------------------------------------------------------------------
	self.defaultStyleSheet 	=  lure.dom.HTMLStylesheetObj.new()
	---------------------------------------------------------------------
	self.stylesheets 		= lure.dom.createNodeListObj()
	---------------------------------------------------------------------
	self.images				= lure.dom.createNodeListObj()
	---------------------------------------------------------------------	
	
	--===================================================================
	-- MUTATORS                                                         =
	--===================================================================
	self.mutators.getDocumentElement = function()
		return self.firstChild
	end
	---------------------------------------------------------------------
	
	--====================================================================
	-- METHODS	                                                         =	
	--====================================================================
	self.createElement 		= function(pTagName)
		local elementNodeObj = lure.dom.createElementNodeObj(pTagName)		
		return elementNodeObj
	end
	---------------------------------------------------------------------
	self.createAttribute 	= function(pAttributeName)
		local attributeNode = lure.dom.createAttributeNodeObj(pAttributeName)
		return attributeNode
	end
	---------------------------------------------------------------------
	self.createTextNode  	= function(pText)
		local textNode = lure.dom.createTextNodeObj(pText)
		return textNode
	end
	---------------------------------------------------------------------
	self.createCDATASection = function(pCDATAText)
		local CDATASectionNode = lure.dom.createCharacterDataNodeObj(pCDATAText)
		return CDATASectionNode
	end
	---------------------------------------------------------------------
	self.createComment 		= function(pCommentText)
		local commentNode = lure.dom.createCommentNodeObj(pCommentText)
		return commentNode
	end	
	---------------------------------------------------------------------
	self.createStylesheet = function(pCssText)
		local stylesheet = lure.dom.HTMLStylesheetObj.new()
		if pCssText ~= nil and type(pCssText) == "string" then			
			stylesheet.insertRule(pCssText)
		end		
		return stylesheet
	end
	---------------------------------------------------------------------
	
	return self
end