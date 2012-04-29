function lure.dom.createElementNodeObj(pTagName)
	local tagName = lure.trim(pTagName:lower())
	self = {}
	
	-- match for HTML Elements
	if 		tagName == "a" 			then	self = lure.dom.createHTMLAnchorElement()
	elseif 	tagName == "area"	 	then	self = lure.dom.createHTMLAreaElement()
	elseif 	tagName == "base"	 	then	self = lure.dom.createHTMLBaseElement()
	elseif 	tagName == "body"	 	then	self = lure.dom.createHTMLBodyElement()
	elseif 	tagName == "button" 	then	self = lure.dom.createHTMLButtonElement()
	elseif 	tagName == "div"	 	then	self = lure.dom.createHTMLDivElement()
	elseif 	tagName == "html"	 	then	self = lure.dom.createHTMLRootElement()
	elseif 	tagName == "h1"	 		then	self = lure.dom.createHTMLHeadingElement(tagName)
	elseif 	tagName == "h2"	 		then	self = lure.dom.createHTMLHeadingElement(tagName)
	elseif 	tagName == "h3"	 		then	self = lure.dom.createHTMLHeadingElement(tagName)
	elseif 	tagName == "h4"	 		then	self = lure.dom.createHTMLHeadingElement(tagName)
	elseif 	tagName == "h5"	 		then	self = lure.dom.createHTMLHeadingElement(tagName)
	elseif 	tagName == "h6"	 		then	self = lure.dom.createHTMLHeadingElement(tagName)
	elseif 	tagName == "form"	 	then	self = lure.dom.createHTMLFormElement()
	elseif 	tagName == "frame" 		then	self = lure.dom.createHTMLFrameElement()
	elseif 	tagName == "iframe" 	then	self = lure.dom.createHTMLIFrameElement()
	elseif 	tagName == "frameset" 	then	self = lure.dom.createHTMLFramesetElement()
	elseif 	tagName == "image" 		then	self = lure.dom.createHTMLImageElement()
	elseif 	tagName == "input" 		then	self = lure.dom.createHTMLInputElement()
	elseif 	tagName == "link"	 	then	self = lure.dom.createHTMLLinkElement()
	elseif 	tagName == "meta"	 	then	self = lure.dom.createHTMLMetaElement()
	elseif 	tagName == "object" 	then	self = lure.dom.createHTMLObjectElement()
	elseif 	tagName == "option" 	then	self = lure.dom.createHTMLOptionElement()
	elseif 	tagName == "p" 			then	self = lure.dom.createHTMLPElement()
	elseif 	tagName == "select" 	then	self = lure.dom.createHTMLSelectElement()
	elseif 	tagName == "style" 		then	self = lure.dom.createHTMLStyleElement()
	elseif 	tagName == "script" 	then	self = lure.dom.createHTMLScriptElement()
	elseif 	tagName == "table" 		then	self = lure.dom.createHTMLTableElement()
	elseif 	tagName == "tr" 	 	then	self = lure.dom.createHTMLTrElement()
	elseif 	tagName == "td" 	 	then	self = lure.dom.createHTMLTdElement()
	elseif 	tagName == "th" 		then	self = lure.dom.createHTMLThElement()
	elseif 	tagName == "textarea" 	then	self = lure.dom.createHTMLTextareaElement()
	else	
		---------------------------------------------------------------------
		self 			= lure.dom.nodeObj.new(1)
		---------------------------------------------------------------------
		self.nodeName 	= string.upper(pTagName)
		---------------------------------------------------------------------
		self.tagName 	= pTagName
		---------------------------------------------------------------------		
	end	
		
	return self
end