lure.rom = {}
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function lure.rom.init()
	-- ROM DEPENDENCIES
	
	require(lure.require_path .. "rom//ns_lure_rom_layout")
	
	require(lure.require_path .. "rom//objects//lure_rom_romParser")	
	require(lure.require_path .. "rom//objects//lure_rom_node")
	require(lure.require_path .. "rom//objects//lure_rom_nodeattribute")
	require(lure.require_path .. "rom//objects//lure_rom_nodelist")
	require(lure.require_path .. "rom//objects//lure_rom_namednodemap")
	require(lure.require_path .. "rom//objects//lure_rom_box")
	require(lure.require_path .. "rom//objects//lure_rom_blockBox")
	require(lure.require_path .. "rom//objects//lure_rom_inlineBox")
	require(lure.require_path .. "rom//objects//lure_rom_inlineBlockBox")
	require(lure.require_path .. "rom//objects//lure_rom_lineBox")
	require(lure.require_path .. "rom//objects//lure_rom_boxComputedStyle")
	require(lure.require_path .. "rom//objects//lure_rom_boxRenderStyle")	
	require(lure.require_path .. "rom//objects//lure_rom_viewport")
	require(lure.require_path .. "rom//objects//lure_rom_textNode")
	require(lure.require_path .. "rom//objects//lure_rom_layoutResponse")
	--require(lure.require_path .. "rom//objects//html//lure_rom_HTMLRenderElement")
	--require(lure.require_path .. "rom//objects//html//lure_rom_HTMLAnonymousBlockRender")
	--require(lure.require_path .. "rom//objects//html//lure_rom_HTMLAnonymousInlineRender")
	--require(lure.require_path .. "rom//objects//html//lure_rom_HTMLAnonymousLineRender")
	--require(lure.require_path .. "rom//objects//html//lure_rom_HTMLBodyRender")
	--require(lure.require_path .. "rom//objects//html//lure_rom_HTMLDivRender")
	--require(lure.require_path .. "rom//objects//html//lure_rom_HTMLImgRender")
	require(lure.require_path .. "rom//definitions//lure_rom_colorDefs")

	-- ROM NODE TYPES
	lure.rom.nodeTypes 		= {}
	lure.rom.nodeTypes[1]	= "BOX_NODE"
	lure.rom.nodeTypes[2]	= "VIEWPORT_NODE"
	lure.rom.nodeTypes[3]	= "TEXT_NODE"

	-- ROM BOX TYPES
	lure.rom.boxTypes		= {}
	lure.rom.boxTypes[1]	= "BLOCK_BOX"
	lure.rom.boxTypes[2]	= "INLINE_BOX"		
	lure.rom.boxTypes[3]	= "LINE_BOX"
	lure.rom.boxTypes[4]	= "INLINE_BLOCK_BOX"
	
	-- ROM FORMATING CONTEXTS
	lure.rom.formatingContexts		= {}
	lure.rom.formatingContexts[1] 	= "BLOCK"
	lure.rom.formatingContexts[2] 	= "INLINE"
	lure.rom.formatingContexts[3]	= "LINE"
	lure.rom.formatingContexts[4] 	= "INLINE-BLOCK"
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function lure.rom.romTreeDump( pRootRomNode )
	local indent = "  "
	local indent_count = 0
	local node_count = 0
	
	print("    ")
	lure.throw(1, "calling lure.rom.romTreeDump()")
	print("-----------------------------------------")
	recurseOutput = function(pRomNode)
		node_count = node_count + 1
		if pRomNode ~= nil then
			local curr_indent = ""
			for a=1, indent_count do curr_indent = curr_indent .. indent end
			if pRomNode.nodeType == 3 then
				print(curr_indent .. tostring(pRomNode.nodeDesc) .. "(FC:" .. tostring(pRomNode.formatingContext)  .. " BT:".. tostring(pRomNode.boxType) .." NT:".. tostring(pRomNode.nodeType) .. " DN:" .. tostring(pRomNode.domNode) .. ")" )
				--print(curr_indent .. tostring(pRomNode.nodeDesc) .. "(FC:" .. tostring(pRomNode.formatingContext)  .. " BT:".. tostring(pRomNode.boxType) .." NT:".. tostring(pRomNode.nodeType) .. "PTB:" .. tostring(pRomNode.isPrincipleTextNode()) .. " DATA:" .. pRomNode.data .. ")" )				
			else
				print(curr_indent .. tostring(pRomNode.nodeDesc) .. "(FC:" .. tostring(pRomNode.formatingContext)  .. " BT:".. tostring(pRomNode.boxType) .." NT:".. tostring(pRomNode.nodeType) .. " DN:" .. tostring(pRomNode.domNode) .. ")" )
			end			
			
			if pRomNode.hasChildNodes() then
				indent_count = indent_count + 1
				for b=1, pRomNode.childNodes.length do
					recurseOutput(pRomNode.childNodes[b])
				end
				indent_count = indent_count - 1
			end				
		end
	end	
	recurseOutput(pRootRomNode)
	print("NodeCount: " .. tostring(node_count))
	print("-----------------------------------------")
	print("    ")	
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function lure.rom.appendChild( pRomNode, pNode, pSkipFormatChecks )
	local self = pRomNode
	
	--print("appending: " .. tostring(pNode.nodeDesc) .. "(FC:" .. tostring(pNode.formatingContext) .. " BT:" .. tostring(pNode.boxType) .. ") to node " .. 
			--tostring(pRomNode.nodeDesc) .. "(FC:" .. tostring(pRomNode.formatingContext) .. " BT:" .. tostring(pRomNode.boxType) .. ")")		
		
	--skip formating checks if desired
	if pSkipFormatChecks == true then
		local newNode = self.childNodes.addItem(pNode)
		newNode.parentNode = self
		return newNode
	end
	
	--do formating context based checks
	if pSkipFormatChecks == false or pSkipFormatChecks == nil then
		if pNode.boxType == 1 then --BLOCK_BOX				
			if self.formatingContext == 1 or self.formatingContext == 4 then				
				return lure.rom.appendChild(self, pNode, true)
			elseif self.formatingContext == 2 then
				lure.throw(1, "cannot append block-level box inside inline formating context")
				return self.parentNode.appendChild(pNode, true)
			else
				lure.throw(1, "unspecified ROM node appention error")
			end
		elseif pNode.boxType == 2 or pNode.boxType == 4 then --INLINE_BOX OR INLINE_BLOCK_BOX
			if self.formatingContext == 1 or self.formatingContext == 4 then --establish new inline formating context						
				local newBlockBox = lure.rom.newBlockBoxObject()
				newBlockBox.formatingContext = 2
				newBlockBox.appendChild(pNode, true)
				self.appendChild(newBlockBox, true)
			elseif self.formatingContext == 2 or self.formatingContext == 4 then --continue with inline formating context				
				return self.appendChild( pNode, true )
			else
				lure.throw(1, "unspecified ROM node appention error")
			end
		elseif pNode.nodeType == 3 then --TEXT_NODE
			if self.formatingContext == 2 then				
				self.appendChild(pNode, true)
			elseif self.formatingContext == 1 then
				lure.throw(1, "cannot append text-node indside established block formating context")
				local newBlockBox = lure.rom.newBlockBoxObject()
				newBlockBox.formatingContext = 2
				newBlockBox.appendChild(pNode)
				self.appendChild(newBlockBox, true)
			else
				lure.throw(1, "unspecified ROM node appention error")			
			end
		end
	end
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- ::: VIEWPORT SPECIFIC ROM METHODS                                             ::
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function lure.rom.computeViewportRenderStyleTop( pViewportNode )
	self = pViewportNode
	if self.nodeType == 2 then -- NODE_TYPE VIEWPORT_NODE		
		if self.renderStyle.top ~= nil then						
			local dec, meas = string.match(self.renderStyle.top, "([%d]+)(p?x?e?m?%%?)")												
			if meas == "px" then
				return tonumber(dec)
			elseif meas == "%" then
				return (dec * .01) * love.graphics.getHeight()
			else
				return tonumber(dec)
			end
		else
			return 0
		end		
	end	
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function lure.rom.computeViewportRenderStyleLeft( pViewportNode )
	self = pViewportNode
	if self.nodeType == 2 then -- NODE_TYPE VIEWPORT_NODE		
		if self.renderStyle.left ~= nil then						
			local dec, meas = string.match(self.renderStyle.left, "([%d]+)(p?x?e?m?%%?)")												
			if meas == "px" then
				return tonumber(dec)
			elseif meas == "%" then
				return (dec * .01) * love.graphics.getWidth()
			else
				return tonumber(dec)
			end
		else
			return 0
		end		
	end	
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function lure.rom.computeViewportRenderStyleWidth( pViewportNode )
	self = pViewportNode
	if self.nodeType == 2 then -- NODE_TYPE VIEWPORT_NODE		
		if self.renderStyle.width ~= nil then						
			local dec, meas = string.match(self.renderStyle.width, "([%d]+)(p?x?e?m?%%?)")												
			if meas == "px" then				
				return tonumber(dec)
			elseif meas == "%" then
				return (dec * .01) * love.graphics.getWidth()
			else
				return tonumber(dec)
			end
		else
			return love.graphics.getWidth()
		end		
	end
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function lure.rom.computeViewportRenderStyleHeight( pViewportNode )
	self = pViewportNode
	if self.nodeType == 2 then -- NODE_TYPE VIEWPORT_NODE		
		if self.renderStyle.height ~= nil then
			if self.renderStyle.height == "auto" then
				return love.graphics.getHeight()
			end
			local dec, meas = string.match(self.renderStyle.height, "([%d]+)(p?x?e?m?%%?)")												
			if meas == "px" then
				return tonumber(dec)
			elseif meas == "%" then
				return tonumber( (dec * .01) * love.graphics.getHeight() )			
			else
				return tonumber(dec)
			end
		else
			return love.graphics.getHeight()
		end		
	end
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function lure.rom.getNodesByBoxType( pRomNode, pBoxType, pDepthLimit )
	local self 			= pRomNode
	local returnlist 	= lure.rom.nodeListObj.new()
	local depthLimit	= pDepthLimit or 0
	local currentDepth	= 0
	
	recurse = function( pStartNode, pBoxType )
		currentDepth = currentDepth + 1
		if pStartNode.hasChildNodes() then
			for a=1, pStartNode.childNodes.length do
				local child = pStartNode.childNodes[a]
				if child.boxType ~= nil and child.boxType == pBoxType then
					returnlist.addItem(child)
				end
				if currentDepth < depthLimit then
					recurse(pStartNode.childNode[a], pBoxType)
				end
			end
		end
	end
	recurse(self, pBoxType)
	
	return returnlist
end

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

function lure.rom.getNodesByNodeType( pRomNode, pNodeType, pDepthLimit )	
	local returnlist 	= lure.rom.nodeListObj.new()
	local depthLimit	= pDepthLimit or 0
	local currentDepth	= 0
	
	recurse = function( pStartNode, pNodeType )
		local searchNode = pStartNode
		local searchType = pNodeType
		currentDepth = currentDepth + 1
		if searchNode.hasChildNodes() then
			for a=1, searchNode.childNodes.length do
				local child = searchNode.childNodes[a]
				if child.nodeType ~= nil and child.nodeType == searchType then
					returnlist.addItem(child)
				end
				if currentDepth < depthLimit then
					recurse(searchNode.childNodes[a], searchType)
				end
			end
		end
	end
	recurse(pRomNode, pNodeType)
	
	return returnlist
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- ::: BOX RENDERSTYLE METHODS                                                   ::
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function lure.rom.computeBoxRenderStyleDisplay( pBoxNode )
	local self = pBoxNode
	
	if self.boxType == 1 then
		if self.renderStyle.display ~= nil then
			if self.renderStyle.display == "block" then
				return "block"
			end
		else
			return "block"
		end
	elseif self.boxType == 2 then
		if self.renderStyle.display ~= nil then
			if self.renderStyle.display == "inline" then
				return "inline"
			else
				return "inline"
			end
		else
			return "inline"
		end	
	elseif self.boxType == 4 then
		if self.renderStyle.display ~= nil then
			if self.renderStyle.display == "inline-block" then
				return "inline-block"
			else
				return "inline-block"
			end
		end
	end	
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function lure.rom.computeBoxRenderStyleBackgroundColor( pBoxNode )
	local self = pBoxNode
	if self.renderStyle.backgroundColor ~= nil then
		local RSBG = {0, 0, 0, 0}
		local foundMath = false
		for a=1, table.getn(lure.rom.color_definitions) do
			if string.lower(self.renderStyle.backgroundColor) == string.lower(lure.rom.color_definitions[a].name) then
				foundMatch = true	
				RSBG[1], RSBG[2], RSBG[3] = lure.hex2rgb( lure.rom.color_definitions[a].hex )
				RSBG[4] = 255										
				return RSBG
			end
		end			
		if foundMatch == false then
			if string.match(value, "#[%d%a]+") ~= nil then
				RSBG[1], RSBG[2], RSBG[3] = lure.hex2rgb( self.renderStyle.backgroundColor )
				RSBG[4] = 255					
				return RSBG
			end						
		end				
	end	
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function lure.rom.computeBoxRenderStyleColor( pBoxNode )
	local self = pBoxNode
	if self.renderStyle.color ~= nil then
		local RSBG = {0, 0, 0, 0}
		local foundMath = false
		for a=1, table.getn(lure.rom.color_definitions) do
			if string.lower(self.renderStyle.color) == string.lower(lure.rom.color_definitions[a].name) then
				foundMatch = true	
				RSBG[1], RSBG[2], RSBG[3] = lure.hex2rgb( lure.rom.color_definitions[a].hex )
				RSBG[4] = 255										
				return RSBG
			end
		end			
		if foundMatch == false then
			if string.match(value, "#[%d%a]+") ~= nil then
				RSBG[1], RSBG[2], RSBG[3] = lure.hex2rgb( self.renderStyle.color )
				RSBG[4] = 255					
				return RSBG
			end						
		end				
	end	
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function lure.rom.computeBoxRenderStylePosition( pBoxNode )
	local self = pBoxNode
	if self.renderStyle.position == "static" then
		return "static"
	elseif self.renderStyle.position == "fixed" then						
		locateViewport = function(pStartNode, appendChild)						
			if pStartNode.parentNode == nil then
				newNode = pStartNode.appendChild(appendChild)														
			else
				locateViewport(pStartNode.parentNode, appendChild)
			end
		end
		locateViewport( self, self.parentNode.removeChild(self) )					
		return "fixed"
	elseif self.renderStyle.position == "absolute" then
		return "absolute"
	elseif self.renderStyle.position == "relative" then
		return "relative"
	elseif self.renderStyle.position == "inherit" then
		if self.parentNode ~= nil then
			return self.parentNode.renderStyle.position
		else
			return "static"
		end
	else
		return "static"
	end	
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function lure.rom.computeBoxRenderStyleLeft( pBoxNode )
	local self 		= pBoxNode	
	local selfRS 	= self.renderStyle
	local selfCS	= self.computedStyle
	local parentRS 	= self.parentNode.renderStyle
	local parentCS	= self.parentNode.computedStyle
	
	--do if its a line box
	if self.boxType == 3 then
		return self.parentNode.computedStyle.left
	end
	
	if selfCS.display == "block" then
		if 	selfCS.position == "static" or 
			selfCS.position == "" or
			selfCS.position == "fixed" or
			selfCS.position == nil then												
			return parentCS.left + parentCS.padding[4] + selfCS.margin[4]
		elseif selfCS.position == "relative" then						
			local left = 0
			local dec, meas = string.match(selfRS.left, "([%d]+)(p?x?e?m?%%?)")												
			if meas == "px" then
				left = dec
			else
				left = (dec * .01) * parentCS.width
			end													
			return left + parentCS.left
		else
			return 0
		end
	elseif selfCS.display == "inline" or selfCS.display == "inline-block" then
		if 	selfCS.position == "static" or 
			selfCS.position == "" or			
			selfCS.position == nil then			
			local left = self.parentNode.computedStyle.left			
			for a=1, self.parentNode.childNodes.length do				
				sibling = self.parentNode.childNodes[a]					
				if sibling ~= self then
					left = left + sibling.computedStyle.width
				elseif sibling == self then
					return left
				end
			end
			return left
		elseif selfCS.position == "relative" then
			--do relative offsets
		end
	end	
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function lure.rom.computeBoxRenderStyleTop( pBoxNode )
	local self		= pBoxNode
	local selfRS 	= self.renderStyle
	local selfCS	= self.computedStyle
	local parentRS 	= self.parentNode.renderStyle
	local parentCS	= self.parentNode.computedStyle	
	
	--do if its a line box
	if self.boxType == 3 then
		lineBoxRefList = {}
		for a=1, self.parentNode.childNodes.length do
			sibling = self.parentNode.childNodes[a]
			if sibling.boxType == 3 then
				table.insert(lineBoxRefList, sibling)
			end
		end
		local top = self.parentNode.computedStyle.top
		for a=1, table.getn(lineBoxRefList) do
			lineBox = lineBoxRefList[a]
			if lineBox ~= self then			
				top = top + lineBox.computedStyle.height
			elseif lineBox == self then
				return top
			end
		end		
	end
	
	if selfCS.display == "block" then
		if 	selfCS.position == "static" or 			
			selfCS.position == "" or 
			selfCS.position == nil then			
			local top = parentCS.top
			if self.parentNode.hasChildNodes() then			
				for a=1, self.parentNode.childNodes.length do
					sibling = self.parentNode.childNodes[a]
					if sibling ~= self then
						top = top + sibling.computedStyle.height + ( sibling.computedStyle.margin[1]  + sibling.computedStyle.margin[3] )
					elseif sibling == self then
						top = top + parentCS.padding[1] + selfCS.margin[1]
						return tonumber(top)
					end					
				end				
			end			
		elseif selfCS.position == "relative" then							
			--TODO: relative position top				
		elseif selfCS.position == "fixed" then			
			--TODO: do fixed move
		end
	elseif selfCS.display == "inline" or selfCS.display == "inline-block" then		
		if 	selfCS.position == "static" or 			
			selfCS.position == "" or 
			selfCS.position == nil then			
			return self.parentNode.computedStyle.top
		elseif selfCS.position == "relative" then
			--TODO: do relative offsets
		elseif selfCS.position == "fixed" then
			--TODO: move node elsewhere
		end
	end
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function lure.rom.computeBoxRenderStyleWidth( pBoxNode )
	local self		= pBoxNode
	local selfRS 	= self.renderStyle
	local selfCS	= self.computedStyle
	local parentRS 	= self.parentNode.renderStyle
	local parentCS	= self.parentNode.computedStyle
	
	--do if its a line box
	if self.boxType == 3 then
		return self.parentNode.computedStyle.width
	end
	
	if selfCS.display == "block" then
		if 	selfCS.position == "static" or 
			selfCS.position == "relative" or
			selfCS.position == "fixed" or
			selfCS.position == "" or
			selfCS.position == nil then
			if selfRS.width ~= nil then				
				local dec, meas = string.match(selfRS.width, "([%d]+)(p?x?e?m?%%?)")
				if meas == "%" then
					return (dec * .01) * parentCS.width - (parentCS.padding[4] + parentCS.padding[2]) - (selfCS.margin[2] + selfCS.margin[4])
				else
					return dec - (parentCS.padding[4] + parentCS.padding[2]) - (selfCS.margin[2] + selfCS.margin[4])
				end
			else
				return parentCS.width - (parentCS.padding[4] + parentCS.padding[2]) - (selfCS.margin[2] + selfCS.margin[4]) --inherit width			
			end			
		end
	elseif selfCS.display == "inline" or selfCS.display == "inline-block" then
		if selfRS.width ~= nil then
			local dec, meas = string.match(selfRS.width, "([%d]+)(p?x?e?m?%%?)")
			if meas == "%" then
				return (dec * .01) * parentCS.width
			else
				return dec
			end
		else
			width = 0
			for a=1, self.childNodes.length do
				child = self.childNodes[a]
				if child.computedStyle.width >= width then
					width = child.computedStyle.width
				end
			end
			return width
		end
	end
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function lure.rom.computeBoxRenderStyleHeight( pBoxNode )
	local self		= pBoxNode
	local selfRS 	= self.renderStyle
	local selfCS	= self.computedStyle
	local parentRS 	= self.parentNode.renderStyle
	local parentCS	= self.parentNode.computedStyle
	
	if selfCS.display == "block" then
		if 	selfCS.position == "static"	or 
			selfCS.position == "relative" or 
			selfCS.position == "fixed" or
			selfCS.position == "" or
			selfCS.position == nil then			
			if selfRS.height ~= nil and selfRS.height ~= "auto" then
				local dec, meas = string.match( selfRS.height, "([%d]+)(p?x?e?m?%%?)" )
				if meas == "px" then
					return tonumber(dec)
				elseif meas == "%" then
					return (dec * .01) * parentCS.height
				else
					return tonumber(dec)
				end
			else
				local height = 0
				for a=1, self.childNodes.length do
					height = height + self.childNodes[a].computedStyle.height + ( self.childNodes[a].computedStyle.margin[1] + self.childNodes[a].computedStyle.margin[3] )
				end							
				return height + (selfCS.padding[1] + selfCS.padding[3])
			end			
		end
	elseif selfCS.display == "inline" or selfCS.display == "inline-block" then
		if selfRS.height ~= nil then
			local dec, meas = string.match(selfRS.height, "([%d]+)(p?x?e?m?%%?)")
			if meas == "%" then
				return (dec * .01) * parentCS.width
			else
				return tonumber(dec)
			end
		else
			height = 0
			for a=1, self.childNodes.length do
				child = self.childNodes[a]
				if child.computedStyle.height >= height then
					height = child.computedStyle.height
				end
			end
			print(height)
			return tonumber(height)
		end
	end	
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function lure.rom.computeBoxRenderStyleMargin( pRomNode )
	local self = pRomNode
	local returnMargin = {0, 0, 0, 0}
	
	for a=1, table.getn( self.renderStyle.margin ) do
		local dec, meas = string.match(self.renderStyle.margin[a], "(%d+)(p?x?e?m?%%?)")		
		if meas == "px" or meas == "" then						
			returnMargin[a] = tonumber(dec) or 0
		elseif meas == "%" then
			if a == 1 then
				returnMargin[a] = (dec * .01) * self.parentNode.computedStyle.height
			elseif a == 2 then
				returnMargin[a] = (dec * .01) * self.parentNode.computedStyle.width
			elseif a == 3 then
				returnMargin[a] = (dec * .01) * self.parentNode.computedStyle.height
			elseif a == 4 then
				returnMargin[a] = (dec * .01) * self.parentNode.computedStyle.width
			end			
		end
	end
	
	return returnMargin
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function lure.rom.computeBoxRenderStylePadding( pRomNode )
	local self = pRomNode
	local returnPadding = {0, 0, 0, 0}
	
	for a=1, table.getn( self.renderStyle.padding ) do
		local dec, meas = string.match(self.renderStyle.padding[a], "(%d+)(p?x?e?m?%%?)")		
		if meas == "px" or meas == "" then						
			returnPadding[a] = tonumber(dec) or 0
		elseif meas == "%" then
			if a == 1 then
				returnPadding[a] = (dec * .01) * self.parentNode.computedStyle.height
			elseif a == 2 then
				returnPadding[a] = (dec * .01) * self.parentNode.computedStyle.width
			elseif a == 3 then
				returnPadding[a] = (dec * .01) * self.parentNode.computedStyle.height
			elseif a == 4 then
				returnPadding[a] = (dec * .01) * self.parentNode.computedStyle.width
			end			
		end
	end
	
	return returnPadding
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
lure.rom.init()