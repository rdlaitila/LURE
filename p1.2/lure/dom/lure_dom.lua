lure.dom 			= {}
---------------------------------------------------------------------
lure.dom.hasChanged = false

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

function lure.dom.init()
	-- NODE TYPE DEFINITIONS
	lure.dom.nodeTypes 		= {}
	lure.dom.nodeTypes[1]	=  "ELEMENT_NODE" 
	lure.dom.nodeTypes[2]	=  "ATTRIBUTE_NODE"
	lure.dom.nodeTypes[3]	=  "TEXT_NODE"
	lure.dom.nodeTypes[4]	=  "CDATA_SECTION_NODE"
	lure.dom.nodeTypes[5]	=  "ENTITY_REFERENCE_NODE"
	lure.dom.nodeTypes[6]	=  "ENTITY_NODE"
	lure.dom.nodeTypes[7]	=  "PROCESSING_INSTRUCTION_NODE"
	lure.dom.nodeTypes[8]	=  "COMMENT_NODE"
	lure.dom.nodeTypes[9]	=  "DOCUMENT_NODE" 
	lure.dom.nodeTypes[10]	=  "DOCUMENT_TYPE_NODE"
	lure.dom.nodeTypes[11]	=  "DOCUMENT_FRAGMENT_NODE"
	lure.dom.nodeTypes[12]	=  "NOTATION_NODE"
	lure.dom.nodeTypes[13]	=  "NODE_LIST"
	
	-- DOM DEPENDENCIES
	require(lure.require_path .. "dom//definitions/lure_dom_cssPropertyDefs")

	require(lure.require_path .. "dom//objects//lure_dom_DOMParser")
	require(lure.require_path .. "dom//objects//lure_dom_node")
	require(lure.require_path .. "dom//objects//lure_dom_nodelist")
	require(lure.require_path .. "dom//objects//lure_dom_namednodemap")
	require(lure.require_path .. "dom//objects//lure_dom_document")
	require(lure.require_path .. "dom//objects//lure_dom_element")
	require(lure.require_path .. "dom//objects//lure_dom_attribute")
	require(lure.require_path .. "dom//objects//lure_dom_cdata")
	require(lure.require_path .. "dom//objects//lure_dom_text")
	require(lure.require_path .. "dom//objects//lure_dom_comment")	
	require(lure.require_path .. "dom//objects//lure_dom_computedStyle")
	require(lure.require_path .. "dom//objects//lure_dom_HTMLAnchor")
	require(lure.require_path .. "dom//objects//lure_dom_HTMLArea")
	require(lure.require_path .. "dom//objects//lure_dom_HTMLBase")
	require(lure.require_path .. "dom//objects//lure_dom_HTMLBody")	
	require(lure.require_path .. "dom//objects//lure_dom_HTMLButton")
	require(lure.require_path .. "dom//objects//lure_dom_HTMLDiv")
	require(lure.require_path .. "dom//objects//lure_dom_HTMLHtml")
	require(lure.require_path .. "dom//objects//lure_dom_HTMLHeading")
	require(lure.require_path .. "dom//objects//lure_dom_HTMLForm")
	require(lure.require_path .. "dom//objects//lure_dom_HTMLFrame")
	require(lure.require_path .. "dom//objects//lure_dom_HTMLFrameset")
	require(lure.require_path .. "dom//objects//lure_dom_HTMLIFrame")
	require(lure.require_path .. "dom//objects//lure_dom_HTMLImage")
	require(lure.require_path .. "dom//objects//lure_dom_HTMLInput")
	require(lure.require_path .. "dom//objects//lure_dom_HTMLLink")
	require(lure.require_path .. "dom//objects//lure_dom_HTMLMeta")
	require(lure.require_path .. "dom//objects//lure_dom_HTMLObject")
	require(lure.require_path .. "dom//objects//lure_dom_HTMLOption")
	require(lure.require_path .. "dom//objects//lure_dom_HTMLP")
	require(lure.require_path .. "dom//objects//lure_dom_HTMLSelect")
	require(lure.require_path .. "dom//objects//lure_dom_HTMLStyle")
	require(lure.require_path .. "dom//objects//lure_dom_HTMLStylesheet")
	require(lure.require_path .. "dom//objects//lure_dom_HTMLNodeStyle")
	require(lure.require_path .. "dom//objects//lure_dom_HTMLCssRule")
	require(lure.require_path .. "dom//objects//lure_dom_HTMLCssRuleStyle")
	require(lure.require_path .. "dom//objects//lure_dom_HTMLScript")
	require(lure.require_path .. "dom//objects//lure_dom_HTMLTable")
	require(lure.require_path .. "dom//objects//lure_dom_HTMLTr")
	require(lure.require_path .. "dom//objects//lure_dom_HTMLTd")
	require(lure.require_path .. "dom//objects//lure_dom_HTMLTh")
	require(lure.require_path .. "dom//objects//lure_dom_HTMLTextarea")	
	require(lure.require_path .. "dom//objects//lure_dom_XMLHttpRequest//XMLHttpRequest")
	
	-- CSS STYLE LOOKUP TABLE
	-- this table is used to store node sytle css key/value pairs. 
	-- this should speed up el.style lookups for objects that
	-- retain style data as well as reduce style data storage
	lure.dom.style_lookup = {}
end

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

function lure.dom.domTreeDump(pRootDomNode)
	local indent = "	"
	local indent_count = 0
	
	lure.throw(1, "calling lure.dom.domTreeDump()")
	print("-----------------------------------------")
	recurseOutput = function(pDomNode)
		local curr_indent = ""
		for a=1, indent_count do curr_indent = curr_indent .. indent end
		print(curr_indent .. tostring(pDomNode.nodeDesc))
		
		if pDomNode.hasChildNodes() then
			indent_count = indent_count + 1
			for b=1, pDomNode.childNodes.length do
				recurseOutput(pDomNode.childNodes[b])
			end
			indent_count = indent_count - 1
		end				
	end	
	recurseOutput(pRootDomNode)
	print("-----------------------------------------")
end

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

function lure.dom.getElementById(pObjRef, pId)
	local self = pObjRef
	local returnnode = nil
	local stopsearch = false
	local checkId = nil
	local search = {}		
	search = function(pSearchNode, pSearchId)
		if stopsearch == false then
			if self.getAttribute ~= nil then 
				checkId = pSearchNode.getAttribute("id") 
			end
			if checkId ~= nil and checkId == pSearchId  then
				returnnode = pSearchNode
				stopsearch = true
			else
				if pSearchNode.hasChildNodes() then
					for i=1, pSearchNode.childNodes.length do
						if pSearchNode.childNodes[i].getAttribute ~= nil then
							search(pSearchNode.childNodes[i], pId)
						end
					end
				end				
			end
		end
	end		
	search(self, pId)
	return returnnode
end

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

function lure.dom.getElementsByTagName(pObjRef, pTagName)	
	local self 				= pObjRef
	local returnnodelist 	= lure.dom.createNodeListObj()
	local stopsearch 		= false
	local checkTag 			= nil
	local search 			= {}
	
	search = function(pSearchNode, pSearchTag)		
		if pSearchNode ~= nil then
			if pSearchNode.tagName ~= nil then
				checkTag = pSearchNode.tagName
				if checkTag ~= nil and checkTag == pSearchTag  then
					returnnodelist.addItem(pSearchNode)
				end
			end				
			if pSearchNode.hasChildNodes ~= nil then
				if pSearchNode.hasChildNodes() then
					for i=1, pSearchNode.childNodes.length do
						search(pSearchNode.childNodes[i], pTagName)
					end				
				end
			end
		end
	end		
	search(self, pTagName)
	
	return returnnodelist
end

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

function lure.dom.getElementsByClassName(pObjRef, pClassName)
	local self = pObjRef
	local returnnodelist = lure.dom.createNodeListObj()
	local stopsearch = false
	local checkClass = nil
	local search = {}		
	search = function(pSearchNode, pSearchClass)
		if stopsearch == false then
			if pSearchNode.getAttribute ~= nil then
				checkClass = pSearchNode.getAttribute("class")
				if checkClass ~= nil and checkClass == pSearchClass  then					
					returnnodelist.addItem(pSearchNode)
				end
			end			
			if pSearchNode.hasChildNodes() then
				for i=1, pSearchNode.childNodes.length do
					search(pSearchNode.childNodes[i], pClassName)
				end				
			end
		end
	end		
	search(self, pClassName)
	return returnnodelist
end

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

function lure.dom.getElementsByAttributeName( pObjRef, pAttrName )
	local self = pObjRef
	local returnnodelist = lure.dom.createNodeListObj()
	local stopsearch = false
	local checkAttr = nil
	local search = {}		
	search = function(pSearchNode, pSearchAttr)
		if stopsearch == false then
			if pSearchNode.getAttribute ~= nil then
				checkAttr = pSearchNode.getAttribute(pAttrName)
				if checkAttr ~= nil  then					
					returnnodelist.addItem(pSearchNode)
				end
			end
			
			if pSearchNode.hasChildNodes() then
				for i=1, pSearchNode.childNodes.length do
					search(pSearchNode.childNodes[i], pAttrName)
				end				
			end
		end
	end		
	search(self, pAttrName)
	return returnnodelist
end

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

function lure.dom.assertScriptTags(pDocumentObj)	
	local document = pDocumentObj
	if document ~= nil then
		scripts = document.getElementsByTagName('script')		
		for scriptK,scriptV in pairs(scripts.nodes) do
			if scriptV.getAttribute('type') ~= nil then
				if lure.trim(scriptV.getAttribute('type')) == "text/lua" then
					if scriptV.childNodes[1].data ~= nil then
						assert(loadstring(scriptV.childNodes[1].data))()
					end				
				end
			end
		end
	end
end

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

function lure.dom.applyCssRuleToElementComputedStyle(pCssRule, pElement)
	--print("lure.dom.applyCssRuleToElementComputedStyle()")
	if pElement ~= nil then		
		if pElement.nodeType ~= nil then			
			if pElement.nodeType == 1 then				
				if pElement.computedStyle == nil then					
					pElement.computedStyle = lure.dom.computedStyleObj.new(pElement)					
				end				
				if pElement.computedStyle ~= nil then
					--print(pCssRule.cssText)
					for styleName, styleValue in string.gmatch(pCssRule.cssText, "(.-):(.-);") do						
						for a=1, table.getn(lure.dom.css_property_definitions) do
							local def = lure.dom.css_property_definitions[a]							
							if def.name == styleName then																						
								pElement.computedStyle[def.css_to_style_equiv] = styleValue																	
							end
						end
					end
				end
				if pElement.style ~= nil then
					if pElement.getAttribute("style") ~= nil then
						for styleName, styleValue in string.gmatch(pElement.getAttribute("style"), "(.-):(.-);") do							
							for a=1, table.getn(lure.dom.css_property_definitions) do
								local def = lure.dom.css_property_definitions[a]							
								if def.name == styleName then														
									pElement.computedStyle[def.css_to_style_equiv] = styleValue																		
								end
							end
						end
					end
				end
			end
		end
	end
end

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

function lure.dom.computeCssCascade( pDocumentObj )
	--print("lure.dom.computeCssCascade()")
	local pDomObj 		= pDocumentObj
	local stylesheets 	= {} 
	local sortedRules	= {}	
	
	-- GATHER ALL STYLESHEETS
	if pDomObj.defaultStylesheet ~= nil then
		table.insert(stylesheets, pDomObj.defaultStylesheet)
	end
	for k,v in ipairs(pDomObj.stylesheets.nodes) do
		table.insert(stylesheets, v)
	end	
	
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
	
	-- CALC SELECTOR CHAIN FOR EACH CSS RULE
	for k, v in ipairs(sortedRules) do
		local chain = lure.dom.computeCssRuleSelectorChain( sortedRules[k].selectorText )
		sortedRules[k].selectorChain = chain
	end	
	
	-- WALK CSSRULE SELECTOR CHAIN, LOCATE SUBJECT ELEMENTS
	for k, v in ipairs(sortedRules) do				
		local subjectElements = lure.dom.locateCssSelectorSubjects( sortedRules[k], pDomObj )
		
		--DEBUG CODE
		--[[print( "                         " )
		print( sortedRules[k].selectorText .. " :: Subjects" )
		print( "-------------------------" )
		for k2, v2 in ipairs(subjectElements) do			
			print("tagname: ".. tostring(subjectElements[k2].tagName))
			print("id: ".. tostring(subjectElements[k2].id))
			print("nodetype: ".. tostring(subjectElements[k2].nodeType))
			print( "                         " )
		end]]
		
		for a=1, table.getn(subjectElements) do			
			lure.dom.applyCssRuleToElementComputedStyle( sortedRules[k], subjectElements[a] )
		end		
	end
	
end

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

function lure.dom.locateCssSelectorSubjects( pCssRule, pDocumentObj )
	--print("lure.dom.locateCssSelectorSubjects()::pDocumentObj::"..tostring(pDocumentObj))	
	--print("lure.dom.locateCssSelectorSubjects()")
	local document		= pDocumentObj
	local rule 			= pCssRule
	local subjects 		= {}
	local currSubjects 	= {}
	local prevSubjects	= { document }
	local searchMode	= "group"

	local id, class, attrname, attrvalue, element
	local matchCond = true
	
	-- PARSE THROUGH EACH SELECTOR CHAIN ITEM, DETERMINE SUBJECT ELEMENTS
	---------------------------------------------------------------------
	for k, v in ipairs(rule.selectorChain) do
		--print(rule.selectorChain[k].type)
		if rule.selectorChain[k].type == "selector" then
			local selectorData = rule.selectorChain[k].data
			
			-- MATCH ID/CLASS/ATTRIBUTES/ELEMENTS FROM SELECTOR TEXT
			---------------------------------------------------------------------			
			id = string.match(selectorData, "#[%d%a_]+")
			if id ~= nil then selectorData = string.gsub(selectorData, id, "") 	end
			
			class = string.match(selectorData, "%.[%a%d]+")
			if class ~= nil then selectorData = string.gsub(selectorData, class, "") end
			
			attrname, attrvalue = string.match(selectorData, "%[(.-)=\"(.-)\"%]")
			selectorData = string.gsub(selectorData, "%[.-%]", "")
			
			element = string.match(selectorData, "[%a%d]+")
			if element ~= nil then selectorData = string.gsub(selectorData, element, "") end				
			
			-- GRAB ELEMENTS BY ID BASED ON SEARCHMODE
			---------------------------------------------------------------------
			if id ~=nil then
				if 	searchMode == "group" or searchMode == "decendent" then
					for i=1, table.getn(prevSubjects) do					
						table.insert( currSubjects, lure.dom.getElementById(prevSubjects[i], string.gsub(id, "#", "")) )			
					end					
				elseif	searchMode == "child" then										
					for i=1, table.getn(prevSubjects) do						
						if prevSubjects[i].hasChildNodes() then
							for b=1, prevSubjects[i].childNodes.length do								
								if prevSubjects[i].childNodes[b].nodeType == 1 then
									if prevSubjects[i].childNodes[b].getAttribute("id") == string.gsub(id, "#", "") then
										table.insert(currSubjects, prevSubjects[i].childNodes[b])
										break
									end
								end
							end
						end
					end
				elseif 	searchMode == "sibling" 	then
					local found = false					
					for i=1, table.getn(prevSubjects) do
						for b=1, prevSubjects[i].parentNode.childNodes.length do
							local sibling = prevSubjects[i].parentNode.childNodes[b]
							if sibling ~= nil then
								if prevSubjects[i].isSameNode(sibling) == false then
									if sibling.nodeType == 1 then									
										if prevSubjects[i].parentNode.childNodes[b].id == string.gsub(id, "#", "") then
											table.insert(currSubjects, prevSubjects[i].parentNode.childNodes[b])
											found = true
											break
										end
									end
								end
							end
						end
						if found == true then break end						
					end
				end
			end
			
			-- GRAB ELEMENTS BY TAGNAME BASED ON SEARCH MODE
			---------------------------------------------------------------------
			if element ~= nil then
				if 	searchMode == "group" then					
					currSubjects = lure.dom.getElementsByTagName(document, element).nodes	
				elseif searchMode == "decendent" then
					for a=1, table.getn(prevSubjects) do
						local nodes = lure.dom.getElementsByTagName(prevSubjects[a], element).nodes
						for b=1, table.getn(nodes) do
							if prevSubjects[a].isSameNode(nodes[b]) == false then
								table.insert(currSubjects, nodes[b])
							end
						end
					end
				elseif	searchMode == "child" then
					for a=1, table.getn(prevSubjects) do
						for b=1, prevSubjects[a].childNodes.length do
							local child = prevSubjects[a].childNodes[b]
							if child.nodeType == 1 then
								if child.tagName == element then
									table.insert(currSubjects, child)
								end
							end
						end
					end
				elseif 	searchMode == "sibling" 	then
					for a=1, table.getn(prevSubjects) do
						for b=1, prevSubjects[a].parentNode.childNodes.length do
							local sibling = prevSubjects[a].parentNode.childNodes[b]
							if sibling ~= nil then
								if prevSubjects[a].isSameNode(sibling) == false then
									if sibling.nodeType == 1 then									
										if sibling.tagName == element then
											table.insert( currSubjects, sibling )
										end
									end
								end
							end
						end
					end
				end
			end
			
			-- GRAB ELEMENTS BY CLASS BASED ON SEARCH NODE
			---------------------------------------------------------------------
			if class ~= nil then
				if id ~= nil or element ~= nil then
					-- direct class search
					removeDupSubject = function()
						for a=1, table.getn(currSubjects) do							
							if currSubjects[a].getAttribute("class") ~= string.gsub(class, "%.", "") then
								table.remove(currSubjects, a)
								removeDupSubject()
								break
							end
						end
					end
					removeDupSubject()
				else
					if searchMode == "decendent" then												
						for a=1, table.getn(prevSubjects) do														
							local nodes = lure.dom.getElementsByClassName(prevSubjects[a], string.gsub(class, "%.", "")).nodes							
							for b=1, table.getn(nodes) do								
								if nodes[b].getAttribute("class") == string.gsub(class, "%.", "") then
									if nodes[b].isSameNode(prevSubjects[a]) == false then
										table.insert(currSubjects, nodes[b])
									end
								end
							end
						end
					elseif searchMode == "child" then
						for a=1, table.getn(prevSubjects) do
							for b=1, prevSubjects[a].childNodes.length do
								local child = prevSubjects[a].childNodes[b]
								if child.nodeType == 1 then
									if child.getAttribute("class") == string.gsub(class, "%.", "") then
										table.insert(currSubjects, child)
									end
								end
							end
						end
					elseif searchMode == "sibling" then	
						for a=1, table.getn(prevSubjects) do
							for b=1, prevSubjects[a].parentNode.childNodes.length do
								local sibling = prevSubjects[a].parentNode.childNodes[b]
								if sibling.nodeType == 1 then
									if sibling.getAttribute("class") == string.gsub(class, "%.", "") then										
										if table.getn(currSubjects) == 0 then
											table.insert(currSubjects, sibling)
										else
											local foundmatch = false
											for c=1, table.getn(currSubjects) do
												if sibling.isSameNode(currSubjects[c]) == true then
													foundmatch = true
												end												
											end		
											if foundmatch == false then
												table.insert(currSubjects, sibling)
											end
										end
									end
								end
							end
						end						
					end
				end				
			end			
			
			-- GRAB ELEMENTS BY ATTRIBUTES BY SEARCH MODE
			---------------------------------------------------------------------
			--[[if attrname ~= nil and matchCond == true then
				if attrvalue ~= nil then
					
				else
					
				end
			end]]					
		
		---------------------------------------------------------------------		
		elseif rule.selectorChain[k].type == "combinator" then
			local combinatorData = rule.selectorChain[k].data
			
			-- SAVE LAST LOOPS CURRSUBJECTS
			prevSubjects = {}
			for k, v in ipairs(currSubjects) do				
				rawset(prevSubjects, k, v)				
			end			
			
			if combinatorData == "," then				
				for k3, v3 in ipairs(currSubjects) do					
					table.insert(subjects, currSubjects[k3])
				end				
				searchMode = "group"
			elseif combinatorData == " " then				
				searchMode = "decendent"
			elseif combinatorData == ">" then
				searchMode = "child"
			elseif combinatorData == "+" then				
				searchMode = "sibling"
			else
				for k3, v3 in ipairs(currSubjects) do					
					table.insert(subjects, currSubjects[k3])
				end				
				searchMode = "group"
			end	
			currSubjects = {}
		end
	end
	---------------------------------------------------------------------
	
	return subjects
end

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

function lure.dom.computeCssRuleSelectorChain( pCssSelectorText )
	local self				= {}
	local selectorText		= pCssSelectorText
	local selectorChain		= {}

	selectorChain.items 	= {}
	selectorChain.subjects 	= {}
	
	if selectorText ~= nil then			
		--collapse uneeded whitespace:
		selectorText = string.gsub(selectorText, "([%s]+)", " ")		
		--remove spaces around child combinator '>':
		selectorText = string.gsub(selectorText, "(%s*)>(%s*)", ">")		
		--remove spaces around sibling combinator '+':
		selectorText = string.gsub(selectorText, "(%s*)%+(%s*)", "+")		
		--remove spaces around group combinator ',':
		selectorText = string.gsub(selectorText, "(%s*)%,(%s*)", ",")
		-- trim leading/trailing whitespace
		selectorText = lure.trim(selectorText)		
		
		--SPLIT SELECTOR TEXT INTO RESPECTIVE SELECTOR/COMBINATOR PAIRS		
		for selc, comb in string.gmatch( selectorText, "([%.?#?%[?%]?=?\"?;?:?%-?%a%d_]+)([%s?,?>?%+?]?)" ) do			
			local selector 		= {}
			local combinator 	= {}
			
			selector.type = "selector"
			selector.data = selc
			table.insert(selectorChain.items, selector)
			
			combinator.type = "combinator"
			combinator.data = comb
			table.insert(selectorChain.items, combinator)			
		end
		
		--[[for k, v in ipairs(selectorChain.items) do
			print(selectorChain.items[k].type .. ": " .. selectorChain.items[k].data)
		end]]
	end	
	return selectorChain.items
end

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

function lure.dom.computeCssRuleSpecificity( pSelectorText )
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

function lure.dom.computeElementStyleSpecificity( pElement )
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

lure.dom.init()