function lure.rom.createRenderElementNodeObj(pTagName)
	local tagName = lure.trim(pTagName:lower())
	self = {}
	
	-- match for HTML Elements	
	if		tagName == "body"	 	then	self = lure.rom.HTMLBodyRenderObj.new()	
	elseif 	tagName == "div"	 	then	self = lure.rom.HTMLDivRenderObj.new()
	elseif 	tagName == "img"	 	then	self = lure.rom.HTMLImgRenderObj.new()
	else
		self = nil
	end
	
	return self
end