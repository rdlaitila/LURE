function lure.dom.createHTMLRootElement()
	local self = lure.dom.nodeObj.new(1)
	
	--===================================================================
	-- PROPERTIES                                                       =
	--===================================================================
	self.tagName 	= "html"
	---------------------------------------------------------------------
	self.nodeName 	= "HTML"	
	---------------------------------------------------------------------
	self.nodeDesc	= "HTMLRootElement"
	---------------------------------------------------------------------
	self.style		= lure.dom.HTMLNodeStyleobj.new(self)
	---------------------------------------------------------------------
	
	--===================================================================
	-- MUTATORS                                                         =
	--===================================================================
	
	--===================================================================
	-- METHODS	                                                        =	
	--===================================================================
	self.attach = function()
		local newRomNode = lure.rom.newViewportObject()
		
		newRomNode.domNode 						= self
		self.romNode							= newRomNode
		newRomNode.renderStyle.left				= self.computedStyle.left
		newRomNode.renderStyle.top				= self.computedStyle.top
		newRomNode.renderStyle.width			= self.computedStyle.width
		newRomNode.renderStyle.height			= self.computedStyle.height
		newRomNode.renderStyle.backgroundColor 	= self.computedStyle.backgroundColor
		
		return newRomNode
	end
	---------------------------------------------------------------------
	
	return self
end