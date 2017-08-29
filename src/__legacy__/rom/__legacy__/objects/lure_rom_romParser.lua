-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

function lure.rom.newRomParserObject()
	local self = {}
	
	--===================================================================
	-- PROPERTIES                                                       =
	--===================================================================
	self.parseDebug = true
	---------------------------------------------------------------------	
	
	--===================================================================
	-- METHODS	                                                        =	
	--===================================================================
	self.parseFromDOM = function( pDomObj )
		local document = pDomObj
		local viewport = lure.dom.getElementsByTagName(document, "html")[1].attach()
		
		--Dom Recurse Function for attachments
		recurseDom = function(pDomNode)			
			if pDomNode.nodeType == 1 or pDomNode.nodeType == 9  or pDomNode.nodeType == 3 then				
				if pDomNode.attach ~= nil then					
					pDomNode.attach()					
					if pDomNode.hasChildNodes() then
						for a=1, pDomNode.childNodes.length do
							recurseDom(pDomNode.childNodes[a])
						end
					end
				end		
			end
		end
		
		-- loop through dom and begin attachments
		local body = lure.dom.getElementsByTagName(document, "body")[1]
		recurseDom(body)
		
		return viewport
	end
	---------------------------------------------------------------------	
	
	return self
end

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::