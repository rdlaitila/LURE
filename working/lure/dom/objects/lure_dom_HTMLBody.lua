function lure.dom.createHTMLBodyElement()
	local self = lure.dom.nodeObj.new(1)
	
	--===================================================================
	-- PROPERTIES                                                       =
	--===================================================================
	self.tagName 	= "body"
	---------------------------------------------------------------------
	self.nodeName 	= "BODY"	
	---------------------------------------------------------------------
	self.nodeDesc	= "HTMLBodyElement"
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
		local newRomNode = lure.rom.newBlockBoxObject()
		
		newRomNode.domNode 						= self
		self.romNode							= newRomNode
		newRomNode.renderStyle.display			= self.computedStyle.display
		newRomNode.renderStyle.left				= self.computedStyle.left
		newRomNode.renderStyle.top				= self.computedStyle.top
		newRomNode.renderStyle.width			= self.computedStyle.width
		newRomNode.renderStyle.height			= self.computedStyle.height
		newRomNode.renderStyle.backgroundColor 	= self.computedStyle.backgroundColor
		
		--set margin	
		newRomNode.renderStyle.margin[1] = self.computedStyle.marginTop	or 0	
		newRomNode.renderStyle.margin[2] = self.computedStyle.marginRight or 0	
		newRomNode.renderStyle.margin[3] = self.computedStyle.marginBottom or 0		
		newRomNode.renderStyle.margin[4] = self.computedStyle.marginLeft or 0
		
		--set padding
		newRomNode.renderStyle.padding[1] = self.computedStyle.paddingTop	or 0	
		newRomNode.renderStyle.padding[2] = self.computedStyle.paddingRight or 0	
		newRomNode.renderStyle.padding[3] = self.computedStyle.paddingBottom or 0		
		newRomNode.renderStyle.padding[4] = self.computedStyle.paddingLeft or 0
		
		self.parentNode.romNode.appendChild(newRomNode)		
		return newRomNode
	end
	---------------------------------------------------------------------
	
	return self
end