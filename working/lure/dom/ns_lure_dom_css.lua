lure.dom.css = {}
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function lure.dom.css.init()
	require(lure.require_path .. "dom//definitions/lure_dom_cssDefs")
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function lure.dom.css.dumpElementStyles(pElement)
	local styles = {}
	local elements = {}
	
	if type(pElement) == "table" then
		elements = pElement
	else
		table.insert(elements,pElement)
	end
	
	for a=1, table.getn(lure.dom.cssDefs) do
		table.insert(styles, lure.dom.cssDefs[a].cssToStyle)
	end
	
	for a=1, #elements do
		print("------------------------------")
		print("Dumping Element styles for:" .. tostring(elements[a].tagName))
		print("------------------------------")
		print("Inline Style:")
		print("Computed Style:")
		for b=1, #styles do
			print("--" .. styles[b] .. ":" .. elements[a].computedStyle[styles[b]] )
		end	
	end
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function lure.dom.css.querySelectorAll(pElement, ...)
	---------------------------------------------------
	-- FUNCTION INIT
	---------------------------------------------------	
	local self = {}
	local startNode = pElement
	local selectors = {}
	local subjectList = lure.dom.createNodeListObj()
	
	local previousSubjects 	= { startNode }
	local currentSubjects	= {  }
	
	--pull in selectors from function args
	for k, v in ipairs(arg) do
		table.insert(selectors, v)
	end
	
	--calculate selector chains
	for k, v in ipairs(selectors) do
		selectors[k] = lure.dom.css.computeCssSelectorChain( selectors[k] )
	end
	---------------------------------------------------	
	
	---------------------------------------------------
	-- INTERNAL METHODS
	---------------------------------------------------
	self.insertTableUnique = function(pTable, pItem)
		local founddup = false
		for k, v in pairs(pTable) do
			local item = pTable[k]
			if item == pItem then
				founddup = true
			end
		end
		if founddup == false then
			table.insert(pTable, pItem)
		end
	end
	---------------------------------------------------
	self.printSelectorChainItems = function(pSelectorChain)
		print(" ")
		print(pSelectorChain.text)
		print("-------------------------")
		for a=1, table.getn(pSelectorChain.items) do
			print("Type: " .. pSelectorChain.items[a].type)
			print("Data: " .. pSelectorChain.items[a].data)
			print("  ")
		end
		print("-------------------------")
		print(" ")
	end
	---------------------------------------------------
	self.printFinalSubjects = function()
		print("  ")
		print("FINAL SUBJECTS")
		print("---------------")
		for a=1, subjectList.length do
			print(subjectList[a])
		end
		if subjectList.length == 0 then
			print('no subjects were selected')
		end
		print("---------------")
		print("  ")	
	end
	---------------------------------------------------
	self.processSelectorAttributeSubType = function( pFoundSubjects, pAttribute )
		local attribute = ""
		local value		= ""		
		for attr, val in string.gmatch(pAttribute, "%[([%w%d%_]+)=?\"?(.-)\"?%]") do
			attribute = lure.trim(attr)
			value = lure.trim(val)			
		end		
		for a=1, table.getn(pFoundSubjects) do
			if pFoundSubjects[a].hasAttribute(attribute) then
				if value ~= nil or value ~= "" then	
					if pFoundSubjects[a].getAttribute(attribute) == value then
						self.insertTableUnique(currentSubjects, pFoundSubjects[a])
					end
				else
					self.insertTableUnique(currentSubjects, pFoundSubjects[a])
				end
			end
		end
		
	end
	---------------------------------------------------
	self.processSelectorPseudoSubType = function()
	end
	---------------------------------------------------
	self.processSelectorClassSubType = function(pFoundSubjects, pClass)
		for a=1, table.getn(pFoundSubjects) do
			if pFoundSubjects[a].hasClass(pClass) then
				self.insertTableUnique(currentSubjects, pFoundSubjects[a])
			end
		end
	end
	---------------------------------------------------	
	
	
	---------------------------------------------------
	-- START FINDING SUBJECTS
	---------------------------------------------------
	for a=1, table.getn(selectors) do		
		local selectorChain = selectors[a]
		local searchMode = 1
		--[[ searchModes
				1: no search mode specified, ex: first selector in chain
				2: decendent	: " "
				3: child		: ">"
				4: sibling		: "+"
				5: group		: ","
		]]
		
		--self.printSelectorChainItems(selectorChain)
			
		---------------------------------------------------
		--loop through all selectorChain items
		---------------------------------------------------
		for b=1, table.getn(selectorChain.items) do			
			local selectorItem 	= selectorChain.items[b]
			
			---------------------------------------------------
			-- if chain item is a selector, locate its subjects
			---------------------------------------------------
			if selectorItem.type == "selector" then
				local selectorData = selectorItem.data
				local selectorBaseType = 1
				--[[ selectorBaseTypes [num : description : example]
						The following selector types are being targeted as allowed:						
						1: wild						: ex *
						2: id						: ex #div
						3: class					: ex .class
						4: attribute				: ex [attr=value] or [attr]
						5: element					: ex h1						
				]]
				local selectorSubType = 1
				--[[ selectorSubTypes [num : description : example]
						1: no sub type				: ex */#id/.class/[attr=value]
						2: wild with class			: ex *.class  div.class  #id.class
						3: wild with attribute		: ex *[attr=value] div[attr=value] #id[attr=value]
						4: wild with pseudo			: ex *:pseudo div:pseudo #id:pseudo						
				]]				
				
				---------------------------------------------------
				-- Match selector type 
				---------------------------------------------------
				-- 1.) LETS MATCH THE FIRST CHARACTER IN THE ITEM TO DETERMINE ITS BASE TYPE
				baseType = string.match(selectorData, "[%a%*%#%.%:%[]?")
				--print("BASETYPE: " .. tostring(baseType))				
				if baseType == string.match(baseType, "^%a") then 
					selectorBaseType = 5					
				elseif baseType == "*" then
					selectorBaseType = 1															
				elseif baseType == "#" then
					selectorBaseType = 2					
				elseif baseType == "." then
					selectorBaseType = 3				
				elseif baseType == ":" then
					selectorBaseType = 6				
				elseif baseType == "[" then
					selectorBaseType = 4				
				end
				-- 2.) CONTINUE REFINING SELECTORSUBTYPE				
				if string.match(selectorData, "%.[%a%d%_]") then selectorSubType = 2
				elseif string.match(selectorData, "%[.+%]") then selectorSubType = 3						
				elseif string.match(selectorData, "%:[%a%d%_]") then selectorSubType = 4
				end			
				
				---------------------------------------------------
				-- find subjects based on selector type and searchMode
				---------------------------------------------------
				local foundSubjects = {}
				if selectorBaseType == 1 then					
					if searchMode == 1 or searchMode == 2 or searchMode == 5 then
						for c=1, table.getn(previousSubjects) do
							local elements = lure.dom.getAllElements(previousSubjects[a])
							for d=1, elements.length do								
								self.insertTableUnique(foundSubjects, elements.items[d])
							end
						end
					elseif searchMode == 3 then						
						for c=1, table.getn(previousSubjects) do							
							for d=1, previousSubjects[c].childNodes.length do
								local elements = lure.dom.getAllElements(previousSubjects[c].childNodes[d])
								for e=1, elements.length do									
									self.insertTableUnique(foundSubjects, elements.items[e])
								end
							end
						end					
					elseif searchMode == 4 then
						for c=1, table.getn(previousSubjects) do
							local previousSubject = previousSubjects[c]
							if previousSubject.parentNode ~= nil then
								for d=1, previousSubject.parentNode.childNodes.length do
									local sibling = previousSubject.parentNode.childNodes[d]
									if sibling ~= previousSubject then										
										self.insertTableUnique(foundSubjects, sibling)
									end
								end
							end							
						end
					end							
				---------------------------------------------------
				elseif selectorBaseType == 2 then
					local id = lure.trim(string.match(selectorData, "[%#%a%d]+"):gsub("[%#]", ""))
					if searchMode == 1 or searchMode == 5 then
						for c=1, table.getn(previousSubjects) do
							local previousSubject = previousSubjects[c]							
							self.insertTableUnique(foundSubjects, lure.dom.getElementById(previousSubject, id))
						end
					elseif searchMode == 2 then
						local idfound = false
						for c=1, table.getn(previousSubjects) do
							local previousSubject = previousSubjects[c]
							local node = lure.dom.getElementById(previousSubject, id)
							if node ~= nil then
								idfound = true
								self.insertTableUnique(foundSubjects, node)
								break
							end
						end
					elseif searchMode == 3 then
						local idfound = false
						for c=1, table.getn(previousSubjects) do
							local previousSubject = previousSubjects[c]
							for d=1, previousSubject.childNodes.length do
								local child = previousSubject.childNodes[d]
								if child.getAttribute ~= nil then
									if child.getAttribute('id') == id then
										idfound = true
										self.insertTableUnique(foundSubjects, child)
										break
									end
								end
							end
							if idfound == true then break end
						end
					elseif searchMode == 4 then
						local idfound = false
						for c=1, table.getn(previousSubjects) do
							local previousSubject = previousSubjects[c]
							if previousSubject.parentNode ~= nil then
								for d=1, previousSubject.parentNode.childNodes.length do
									local sibling = previousSubject.parentNode.childNodes[d]
									if sibling ~= previousSubject then
										if sibling.getAttribute ~= nil and sibling.getAttribute('id') == id then
											idfound = true
											self.insertTableUnique(foundSubjects, sibling)
											break
										end
									end
								end
								if idfound == true then break end
							end
						end					
					end				
				---------------------------------------------------
				elseif selectorBaseType == 3 then
					local className = lure.trim( selectorData:gsub("[%.]", "") )
					if searchMode == 1 or searchMode == 5 or searchMode == 2 then
						for c=1, table.getn(previousSubjects) do
							local previousSubject = previousSubjects[c]
							local elements = lure.dom.getElementsByClassName(previousSubject, className)
							for d=1, elements.length do
								self.insertTableUnique(foundSubjects, elements.nodes[d])
							end
						end					
					elseif searchMode == 3 then
						for c=1, table.getn(previousSubjects) do
							local previousSubject = previousSubjects[c]
							for d=1, previousSubject.childNodes.length do
								local child = previousSubject.childNodes[d]
								if child.getAttribute ~= nil then
									if child.getAttribute ~= nil and child.getAttribute('class') ~= nil then
										for class in string.gmatch(child.getAttribute('class'), "[%a%d]+") do										
											if class ~= nil then
												if lure.trim(class) == lure.trim(className) then
													self.insertTableUnique(foundSubjects, child)
												end
											end
										end
									end
								end
							end
						end
					elseif searchMode == 4 then
						for c=1, table.getn(previousSubjects) do
							local previousSubject = previousSubjects[c]
							if previousSubject.parentNode ~= nil then
								for d=1, previousSubject.parentNode.childNodes.length do
									local sibling = previousSubject.parentNode.childNodes[d]
									if sibling ~= previousSubject then
										if sibling.getAttribute ~= nil then
											local class = sibling.getAttribute('class')
											for class in string.gmatch(sibling.getAttribute('class'), "[%a%d]+") do										
												if class ~= nil then
													if lure.trim(class) == lure.trim(className) then
														self.insertTableUnique(foundSubjects, sibling)
													end
												end
											end
										end
									end
								end
							end
						end
					end	
				---------------------------------------------------
				elseif selectorBaseType == 4 then					
					local attribute = ""
					local value		= ""
					for attr, val in string.gmatch(selectorData, "%[([%w%d%_]+)=?\"?(.-)\"?%]") do
						attribute = lure.trim(attr)
						value = lure.trim(val)						
					end										
					if searchMode == 1 or searchMode == 2 or searchMode == 5 then
						for c=1, table.getn(previousSubjects) do
							local previousSubject = previousSubjects[c]														
							local elements = lure.dom.getElementsByAttributeName(previousSubject, attribute)
							if value ~= nil or value ~= "" then								
								for d=1, elements.length do									
									local element = elements.nodes[d]
									if element.getAttribute(attribute) == value then
										self.insertTableUnique(foundSubjects, element)
									end
								end
							else								
								for d=1, elements.length do
									local element = elements.nodes[d]
									self.insertTableUnique(foundSubjects, element)
								end
							end
						end					
					elseif searchMode == 3 then
						for c=1, table.getn(previousSubjects) do
							local previousSubject = previousSubjects[c]
							for d=1, previousSubject.childNodes.length do
								local child = previousSubject.childNodes[d]
								if child.getAttribute() ~= nil and child.getAttribute(attribute) ~= nil then
									if value ~= nil or value ~= "" then
										if child.getAttribute(attribute) == value then
											self.insertTableUnique(foundSubjects, child)
										end
									else
										self.insertTableUnique(foundSubjects, child)
									end
								end								
							end
						end
					elseif searchMode == 4 then
						for c=1, table.getn(previousSubjects) do
							local previousSubject = previousSubjects[c]
							for d=1, previousSubject.parentNode.childNodes.length do
								local sibling = previousSubject.parentNode.childNodes[d]
								if sibling ~= previousSubject then
									if sibling.getAttribute ~= nil and sibling.getAttribute(attribute) ~= nil then
										if value ~= nil or value ~= "" then
											if sibling.getAttribute(attribute) == value then
												self.insertTableUnique(foundSubjects, sibling)
											end
										else
											self.insertTableUnique(foundSubjects, sibling)
										end
									end
								end
							end
						end
					end	
				---------------------------------------------------
				elseif selectorBaseType == 5 then
					local tagName = lure.trim(string.match(selectorData, "[%a%d]+"))
					if searchMode == 1 or searchMode == 5 then						
						for c=1, table.getn(previousSubjects) do
							local previousSubject = previousSubjects[c]
							local elements = lure.dom.getElementsByTagName(previousSubject, tagName )
							for d=1, elements.length do
								--table.insert(foundSubjects, elements.nodes[d])
								self.insertTableUnique(foundSubjects, elements.nodes[d])
							end
						end
					elseif searchMode == 2 then						
						for c=1, table.getn(previousSubjects) do
							local previousSubject = previousSubjects[c]
							local elements = lure.dom.getElementsByTagName(previousSubject, tagName)
							for d=1, elements.length do
								local element = elements.nodes[d]
								if element.tagName ~= nil and element.tagName == tagName then
									self.insertTableUnique(foundSubjects, element)
								end
							end
						end
					elseif searchMode == 3 then						
						for c=1, table.getn(previousSubjects) do
							local previousSubject = previousSubjects[c]							
							for d=1, previousSubject.childNodes.length do
								local child = previousSubject.childNodes[d]
								if child.tagName == tagName then									
									--table.insert(foundSubjects, child)
									self.insertTableUnique(foundSubjects, child)
								end
							end
						end
					elseif searchMode == 4 then
						for c=1, table.getn(previousSubjects) do
							local previousSubject = previousSubjects[c]
							if previousSubject.parentNode ~= nil then
								for d=1, previousSubject.parentNode.childNodes.length do
									local sibling = previousSubject.parentNode.childNodes[d]
									if sibling ~= previousSubject then
										if sibling.tagName == tagName then
											--table.insert(foundSubjects, sibling)
											self.insertTableUnique(foundSubjects, sibling)
										end
									end
								end
							end
						end						
					end	
				---------------------------------------------------
				end				
				
				---------------------------------------------------
				-- REFINE SUBJECTS BY SUBTYPE
				---------------------------------------------------				
				if selectorSubType == 1 then
					for c=1, table.getn(foundSubjects) do
						self.insertTableUnique(currentSubjects, foundSubjects[c])
					end
				elseif selectorSubType == 2 or selectorSubType == 5 or selectorSubType == 8 then
					local class = string.match(selectorData, "%.([%a%d%_]+)")						
					self.processSelectorClassSubType(foundSubjects, class)						
				elseif selectorSubType == 3 or selectorSubType == 6 or selectorSubType == 9 then
					local attr = string.match(selectorData, "(%[.+%])")									
					self.processSelectorAttributeSubType(foundSubjects, attr)
				elseif selectorSubType == 4 then
					--do pseudo 
				end		
			end
			
			---------------------------------------------------
			-- if chain item is a combinator, change selector search mode
			-- and save subjects
			---------------------------------------------------
			if selectorItem.type == "combinator" then
				combinatorData = selectorItem.data
				setPreviousToCurrentSubjects = false				
						
				if combinatorData == " " then					
					searchMode = 2
					setPreviousToCurrentSubjects = true
				elseif combinatorData == ">" then					
					searchMode = 3
					setPreviousToCurrentSubjects = true
				elseif combinatorData == "+" then					
					searchMode = 4
					setPreviousToCurrentSubjects = true
				elseif combinatorData == "," then					
					searchMode = 5
					for k, v in ipairs(currentSubjects) do
						subjectList.addItem(currentSubjects[k])
					end
				end	

				if setPreviousToCurrentSubjects == true then
					previousSubjects = {}
					for k, v in pairs(currentSubjects) do										
						rawset(previousSubjects, k, v)					
					end								
				end
				
				currentSubjects = {}
			end
			---------------------------------------------------
			-- were done looping over selectorChain items, add 
			-- current subjecst to subjectList
			---------------------------------------------------
			if b == table.getn(selectorChain.items) then				
				for k, v in ipairs(currentSubjects) do					
					subjectList.addItem(currentSubjects[k])
				end
			end			
		end
		---------------------------------------------------
	end
	---------------------------------------------------			
	
	return subjectList
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function lure.dom.css.applyCssRuleToElementComputedStyle(pCssRule, pElement)
	--print("lure.dom.applyCssRuleToElementComputedStyle()")
	if pElement ~= nil then		
		if pElement.nodeType ~= nil then			
			if pElement.nodeType == 1 then				
				if pElement.computedStyle == nil then					
					pElement.computedStyle = lure.dom.createComputedStyleObj(pElement)					
				end				
				if pElement.computedStyle ~= nil then
					--print(pCssRule.cssText)
					for styleName, styleValue in string.gmatch(pCssRule.cssText, "(.-):(.-);") do						
						for a=1, table.getn(lure.dom.cssDefs) do
							local def = lure.dom.cssDefs[a]							
							if def.name == styleName then																						
								pElement.computedStyle[def.cssToStyle] = styleValue																	
							end
						end
					end
				end				
			end
		end
	end
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function lure.dom.css.applyInlineStyleToElementComputedStyle( pElement )
	--ensure element has a computedStyle object:
	if pElement.computedStyle == nil then
		pElement.computedStyle = lure.dom.createComputedStyleObj(pElement)
	end
	
	if pElement.getAttribute("style") ~= nil then
		for styleName, styleValue in string.gmatch(pElement.getAttribute("style"), "(.-):(.-);") do
			--print(tostring(styleName) .. ":" .. tostring(styleValue))				
			for a=1, table.getn(lure.dom.cssDefs) do				
				local def = lure.dom.cssDefs[a]				
				if def.name == styleName then					
					pElement.computedStyle[def.cssToStyle] = styleValue	
					--print( tostring(pElement.computedStyle[def.cssToStyle]) )
				end
			end		
		end
	end	
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function lure.dom.css.computeCssCascade( pDocumentObj, pStyleSheets )
	--print("lure.dom.computeCssCascade()")
	local pDomObj 		= pDocumentObj
	local stylesheets 	= pStyleSheets
	local sortedRules	= {}		
	
	-- GATHER ALL STYLESHEET CSS RULES
	for k, v in ipairs(stylesheets) do		
		for rK,rV in ipairs(stylesheets[k].cssRules.nodes) do		
			table.insert(sortedRules, stylesheets[k].cssRules[rK])		
		end		
	end
	
	--[[for k, v in ipairs(sortedRules) do
		local s = sortedRules[k].style.specificity[1] .. sortedRules[k].style.specificity[2] .. sortedRules[k].style.specificity[3] .. sortedRules[k].style.specificity[4]
		print(s .. ":" ..sortedRules[k].selectorText )
	end]]
	
	-- SORT CSS RULES BY SPECIFICITY ASC
	local sortRules = function(a, b)		
		local a_spec = a.style.specificity[1] .. a.style.specificity[2] .. a.style.specificity[3] .. a.style.specificity[4]
		local b_spec = b.style.specificity[1] .. b.style.specificity[2] .. b.style.specificity[3] .. b.style.specificity[4]
			
		return a_spec < b_spec		
	end
	table.sort(sortedRules, sortRules)	
	
	-- WALK CSSRULE SELECTOR CHAIN, LOCATE SUBJECT ELEMENTS
	for k, v in ipairs(sortedRules) do				
		local subjectElements = lure.dom.css.querySelectorAll(pDomObj, sortedRules[k].selectorText)	
				
		for a=1, table.getn(subjectElements.nodes) do			
			lure.dom.css.applyCssRuleToElementComputedStyle( sortedRules[k], subjectElements.nodes[a] )
		end		
	end
	
	-- APPLY EACH ELEMENTS INLINE STYLE TO ELEMENTS COMPUTED STYLE
	local elements = lure.dom.getAllElements( pDomObj )
	for a=1, elements.length do
		lure.dom.css.applyInlineStyleToElementComputedStyle( elements.nodes[a] )
	end	
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function lure.dom.css.computeCssSelectorChain( pCssSelectorText )
	local self				= {}
	local selectorText		= pCssSelectorText
	local selectorChain		= {}

	selectorChain.items 	= {}
	selectorChain.subjects 	= {}
	selectorChain.text 		= pCssSelectorText
	
	if selectorText ~= nil then							
		selectorText = string.gsub(selectorText, "([%s]+)", " ") --collapse uneeded whitespace:		
		selectorText = string.gsub(selectorText, "(%s*)>(%s*)", ">") --remove spaces around child combinator '>':		
		selectorText = string.gsub(selectorText, "(%s*)%+(%s*)", "+") --remove spaces around sibling combinator '+':		
		selectorText = string.gsub(selectorText, "(%s*)%,(%s*)", ",") --remove spaces around group combinator ',':		
		selectorText = string.gsub(selectorText, "(%s*)%:", ":") --collapse space between selector & pseudo element		
		selectorText = lure.trim(selectorText) -- trim leading/trailing whitespace
		---------------------------------------------------------------------
		local buildChainItem = function(selc, comb)
			local selector 		= {}
			local combinator 	= {}			
			if selc ~= nil then
				selector.type = "selector"
				selector.data = selc
				table.insert(selectorChain.items, selector)
			end
			if comb ~= nil then
				combinator.type = "combinator"
				combinator.data = comb
				table.insert(selectorChain.items, combinator)		
			end
		end
		---------------------------------------------------------------------		
		local char = function(charIndex) return  selectorText:sub(charIndex,charIndex) end				
		---------------------------------------------------------------------
		
		--PARSE SELECTOR TEXT INTO RESPECTIVE SELECTOR/COMBINATOR CHAIN ITEMS		
		local index = 1
		local selectorBuffer = ""		
		local isParsingAttr = false
		while index <= selectorText:len() do			
			if char(index) == " " then
				if isParsingAttr == false then
					buildChainItem(selectorBuffer, " ")
					selectorBuffer = ""
				end
			elseif char(index) == ">" then
				if isParsingAttr == false then
					buildChainItem(selectorBuffer, ">")
					selectorBuffer = ""
				end
			elseif char(index) == "+" then
				if isParsingAttr == false then
					buildChainItem(selectorBuffer, "+")
					selectorBuffer = ""
				end
			elseif char(index) == "," then
				if isParsingAttr == false then
					buildChainItem(selectorBuffer, ",")
					selectorBuffer = ""
				end
			elseif char(index) == "[" then
				isParsingAttr = true
				selectorBuffer = selectorBuffer .. char(index)
			elseif char(index) == "]" then
				isParsingAttr = false
				selectorBuffer = selectorBuffer .. char(index)				
			else
				selectorBuffer = selectorBuffer .. char(index)
			end			
			--finish up on last selector
			if index == selectorText:len() then
				buildChainItem(selectorBuffer, nil)
			end			
			index = index + 1
		end		
		
		--LEGACY::SPLIT SELECTOR TEXT INTO RESPECTIVE SELECTOR/COMBINATOR PAIRS		
		--[[for selc, comb in string.gmatch( selectorText, "([%*%.?#?%[?%]?=?\"?;?:?%-?%a%d_]+)([%s?,?>?%+?]?)" ) do			
			local selector 		= {}
			local combinator 	= {}
			
			selector.type = "selector"
			selector.data = selc
			table.insert(selectorChain.items, selector)
			
			combinator.type = "combinator"
			combinator.data = comb
			table.insert(selectorChain.items, combinator)			
		end]]
		
		-- remove last item in selector chain if is combinator, and is of type decendent (space).		
		if selectorChain.items[table.getn(selectorChain.items)].type == "combinator" and
		   selectorChain.items[table.getn(selectorChain.items)].data == "" then
		   table.remove(selectorChain.items, table.getn(selectorChain.items))
		end
	end	
	--return selectorChain.items
	return selectorChain
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function lure.dom.css.computeCssRuleSpecificity( pSelectorText )
	local returnWeight = { 0, 0, 0, 0 }
	local selectorText = lure.trim(pSelectorText)	
	
	-- match ID selectors
	for matchID in string.gmatch( selectorText, "#[%a%d]+" ) do
		local rtrn, occr = string.gsub(selectorText, lure.literalize(matchID), "")
		selectorText = rtrn
		returnWeight[2] = returnWeight[2] + 1
	end
	
	-- match class selectors 
	for matchClass in string.gmatch( selectorText, "%.[%a%d]+" ) do
		local rtrn, occr = string.gsub(selectorText, lure.literalize(matchClass), "")
		selectorText = rtrn
		returnWeight[3] = returnWeight[3] + 1
	end
	
	-- match attribute selectors
	for matchAttr in string.gmatch( selectorText, "%[.-%]+" ) do		
		local rtrn, occr = string.gsub(selectorText, lure.literalize(matchAttr), "")
		selectorText = rtrn
		returnWeight[3] = returnWeight[3] + 1
	end
	
	-- match psuedo elements	
	for matchPel in string.gmatch( selectorText, ":[%a%d]+" ) do		
		local rtrn, occr = string.gsub(selectorText, lure.literalize(matchPel), "")
		selectorText = rtrn
		returnWeight[3] = returnWeight[3] + 1
	end
	
	-- match element selectors
	for matchEl in string.gmatch( selectorText, "[%a%d]+" ) do		
		local rtrn, occr = string.gsub(selectorText, lure.literalize(matchEl), "")
		selectorText = rtrn
		returnWeight[4] = returnWeight[4] + 1
	end		
	
	return returnWeight	
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function lure.dom.css.computeElementStyleSpecificity( pElement )
	local returnWeight = { 0, 0, 0, 0 }		
	
	if pElement ~= nil then
		if pElement.nodeType ~= nil and pElement.nodeType == 1 then
			if pElement.hasAttribute('style') then
				-- is inline style
				returnWeight[1] = 1
			
				-- match ID attribute	
				if pElement.hasAttribute("id") then
					returnWeight[2] = 1
				end
				
				-- match class attribute 
				if pElement.hasAttribute("class") then
					for classes in string.gmatch( pElement.getAttribute('class'), "[%a%d]+" ) do
						returnWeight[3] = returnWeight[3] + 1
					end
				end
								
				-- match element selectors
				returnWeight[4] = 1
			end
		end
	end	
	
	--print(returnWeight[1] .. returnWeight[2] .. returnWeight[3] .. returnWeight[4])
	
	return returnWeight	
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
lure.dom.css.init()