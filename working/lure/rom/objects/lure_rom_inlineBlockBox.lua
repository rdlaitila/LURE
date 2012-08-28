-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function lure.rom.newInlineBlockBoxObject( pParamTable )	
	local self = lure.rom.newBoxObject( {nodeType=1, boxType=4, formatingContext=4, nodeDesc="ROMInlineBlockBoxNode"} )
	
	
	--===================================================================
	-- PROPERTIES                                                       =
	--===================================================================	
	---------------------------------------------------------------------		
	
	--====================================================================
	-- METHODS	                                                         =	
	--====================================================================			
	self.layout = function()
		lure.throw(1, "callling layout on node: " .. tostring(self.nodeDesc) .. "(FC:".. tostring(self.formatingContext) .." BT:".. tostring(self.boxType) .." NT:".. tostring(self.nodeType) ..")")
		
		self.computedStyle.display 			= lure.rom.computeBoxRenderStyleDisplay( self )
		self.computedStyle.position			= lure.rom.computeBoxRenderStylePosition( self )		
		self.computedStyle.backgroundColor 	= lure.rom.computeBoxRenderStyleBackgroundColor( self )
		
		self.computedStyle.margin	= lure.rom.computeBoxRenderStyleMargin( self )
		self.computedStyle.padding	= lure.rom.computeBoxRenderStylePadding( self )
		self.computedStyle.left 	= lure.rom.computeBoxRenderStyleLeft( self )
		self.computedStyle.top		= lure.rom.computeBoxRenderStyleTop( self )			
		self.computedStyle.width 	= lure.rom.computeBoxRenderStyleWidth( self )			
		
		-- calcuate height if statically set and its not auto (same as 100%)
		if 	self.renderStyle.height ~= "auto"  and self.renderStyle.height ~= nil then
			self.computedStyle.height = lure.rom.computeBoxRenderStyleHeight( self )
		end						
		
		-- do child layouts
		if self.formatingContext == 1 or self.formatingContext == 4 then
			lure.rom.layout.doBlockChildLayouts( self )
		elseif self.formatingContext == 2 then			
			lure.rom.layout.doInlineChildLayouts( self )
		end								
					
		-- no height specified, calculate computeRenderHeight() should calculate all child heights
		if 	self.renderStyle.height == "auto" or self.renderStyle.height == nil then
			self.computedStyle.height = lure.rom.computeBoxRenderStyleHeight( self )
		end
	end			
	---------------------------------------------------------------------
	
	return self
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::