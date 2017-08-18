-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

function lure.rom.newInlineBoxObject( pParamTable )	
	local self = lure.rom.newBoxObject( {nodeType=1, boxType=2, formatingContext=2, nodeDesc="ROMInlineBoxNode"} )
	
	
	--===================================================================
	-- PROPERTIES                                                       =
	--===================================================================
	self.layoutResponse 	= lure.rom.newLayoutResponseObject()	
	---------------------------------------------------------------------
	--====================================================================
	-- METHODS	                                                         =	
	--====================================================================	
	self.layout = function()
		--lure.throw(1, "callling layout on node: " .. tostring(self.nodeDesc) .. "(FC:".. tostring(self.formatingContext) .." BT:".. tostring(self.boxType) .." NT:".. tostring(self.nodeType) ..")")
		self.layoutResponse.clear()
		
		self.computedStyle.display 			= lure.rom.computeBoxRenderStyleDisplay( self )		
		self.computedStyle.position			= lure.rom.computeBoxRenderStylePosition( self )		
		self.computedStyle.backgroundColor 	= lure.rom.computeBoxRenderStyleBackgroundColor( self )
		self.computedStyle.top 				= lure.rom.computeBoxRenderStyleTop( self )
		self.computedStyle.left				= lure.rom.computeBoxRenderStyleLeft( self )
		self.computedStyle.width 	= lure.rom.computeBoxRenderStyleWidth( self )
		
		--do child layouts
		lure.rom.layout.doInlineChildLayouts( self )
		
		
		self.computedStyle.height 	= lure.rom.computeBoxRenderStyleHeight( self )				
		
		self.layoutResponse.type = 3
		return self.layoutResponse
	end	
	---------------------------------------------------------------------
	
	
	return self
end

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::