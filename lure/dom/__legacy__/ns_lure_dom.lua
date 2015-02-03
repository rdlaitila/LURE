lure.dom 			= {}
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
	
	-- REQUIRE NAMESPACES
	require(lure.require_path .. "dom//ns_lure_dom_css")		
	
	-- DOM DEPENDENCIES
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
	local indent = "--"
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
function lure.dom.getAllElements(pObjRef)
	local self = pObjRef
	local returnList = lure.dom.createNodeListObj()
	
	recurse = function(pSearchNode)	
		if pSearchNode.nodeType == 1 then returnList.addItem( pSearchNode ) end
		if pSearchNode.hasChildNodes() then
			for a=1, pSearchNode.childNodes.length do
				recurse(pSearchNode.childNodes[a])
			end
		end
	end
	recurse(self)
	return returnList
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
				if checkClass ~= nil then
					for class in string.gmatch(checkClass, "[%a%d]+") do
						if class ~= nil and lure.trim(class) == lure.trim(pSearchClass)  then					
							returnnodelist.addItem(pSearchNode)
						end
					end
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
lure.dom.init()