lure.core.layers = {}
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function lure.core.layers.new()
	local self = {}
	
	--===================================================================
	-- PROPERTIES                                                       =
	--===================================================================
	self.document = nil
	---------------------------------------------------------------------	
	self.viewport = nil
	---------------------------------------------------------------------	
	self.zIndex	  = 0
	---------------------------------------------------------------------	
	
	--===================================================================
	-- METHODS	                                                        =	
	--===================================================================
	self.load = function(pLoadObj)		
		local srcText 	= love.filesystem.read(pLoadObj)		
		local DOMParser	= lure.dom.DOMParser:new()
		local ROMParser	= lure.rom.newRomParserObject()
				
		--create local document object from parser
		self.document = DOMParser.parseFromString(srcText)
		
		--compute the css cascade for this document
		local defaultStylesheets = {}
		table.insert( defaultStylesheets, self.document.createStylesheet(love.filesystem.read(lure.require_path .. "res//css//defaultStylesheet.css")) )		
		lure.dom.css.computeCssCascade(self.document, defaultStylesheets)		
		local userStylesheets = {}
		for k,v in ipairs(self.document.stylesheets.nodes) do			
			table.insert(userStylesheets, v)
		end	
		lure.dom.css.computeCssCascade(self.document, userStylesheets)
		
		--assert all document script tags
		lure.dom.assertScriptTags(self.document)
				
		--were done with the dom parser
		DOMparser = nil
		
		--create local rom objet from ROMParser
		self.viewport = ROMParser.parseFromDOM(self.document)				
		
		--were done with the rom parser
		ROMparser = nil		
		
		--do initial layout
		self.viewport.layout()
		
		--return document to caller
		return self.document
	end
	---------------------------------------------------------------------	
	self.close = function()
	end
	---------------------------------------------------------------------		
	
	return self
end

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::