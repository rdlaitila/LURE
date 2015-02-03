--[[------------------------------------------------
	-- Love Frames - A GUI library for LOVE --
	-- Copyright (c) 2012-2014 Kenny Shields --
--]]------------------------------------------------

-- get the current require path
local path = string.sub(..., 1, string.len(...) - string.len(".objects.internal.columnlist.columnlistrow"))
local loveframes = require(path .. ".libraries.common")

-- columnlistrow class
local newobject = loveframes.NewObject("columnlistrow", "loveframes_object_columnlistrow", true)

--[[---------------------------------------------------------
	- func: initialize()
	- desc: intializes the element
--]]---------------------------------------------------------
function newobject:initialize(parent, data)

	self.type = "columnlistrow"
	self.parent = parent
	self.state = parent.state
	self.colorindex = self.parent.rowcolorindex
	self.font = loveframes.basicfontsmall
	self.width = 80
	self.height = 25
	self.textx = 5
	self.texty = 5
	self.selected = false
	self.internal = true
	self.columndata = {}
	
	for k, v in ipairs(data) do
		self.columndata[k] = tostring(v)
	end
	
	-- apply template properties to the object
	loveframes.templates.ApplyToObject(self)
	
end

--[[---------------------------------------------------------
	- func: update(deltatime)
	- desc: updates the object
--]]---------------------------------------------------------
function newobject:update(dt)
	
	if not self.visible then
		if not self.alwaysupdate then
			return
		end
	end
	
	local parent = self.parent
	local update = self.Update
	
	self:CheckHover()
	
	-- move to parent if there is a parent
	if parent ~= loveframes.base then
		self.x = parent.x + self.staticx
		self.y = parent.y + self.staticy
	end
	
	if update then
		update(self, dt)
	end

end

--[[---------------------------------------------------------
	- func: draw()
	- desc: draws the object
--]]---------------------------------------------------------
function newobject:draw()

	if not self.visible then
		return
	end
	
	local skins = loveframes.skins.available
	local skinindex = loveframes.config["ACTIVESKIN"]
	local defaultskin = loveframes.config["DEFAULTSKIN"]
	local selfskin = self.skin
	local skin = skins[selfskin] or skins[skinindex]
	local drawfunc = skin.DrawColumnListRow or skins[defaultskin].DrawColumnListRow
	local draw = self.Draw
	local drawcount = loveframes.drawcount
	
	-- set the object's draw order
	self:SetDrawOrder()
		
	if draw then
		draw(self)
	else
		drawfunc(self)
	end
	
end

--[[---------------------------------------------------------
	- func: mousepressed(x, y, button)
	- desc: called when the player presses a mouse button
--]]---------------------------------------------------------
function newobject:mousepressed(x, y, button)

	if not self.visible then
		return
	end
	
	if self.hover and button == "l" then
		local baseparent = self:GetBaseParent()
		if baseparent and baseparent.type == "frame" then
			baseparent:MakeTop()
		end
		self:GetParent():GetParent():SelectRow(self, loveframes.util.IsCtrlDown())
	end

end

--[[---------------------------------------------------------
	- func: mousereleased(x, y, button)
	- desc: called when the player releases a mouse button
--]]---------------------------------------------------------
function newobject:mousereleased(x, y, button)

	if not self.visible then
		return
	end
	
	if self.hover then
		local parent = self:GetParent():GetParent()
		if button == "l" then
			local onrowclicked = parent.OnRowClicked
			if onrowclicked then
				onrowclicked(parent, self, self.columndata)
			end
		elseif button == "r" then
			local onrowrightclicked = parent.OnRowRightClicked
			if onrowrightclicked then
				onrowrightclicked(parent, self, self.columndata)
			end
		end
	end
	
end

--[[---------------------------------------------------------
	- func: SetTextPos(x, y)
	- desc: sets the positions of the object's text
--]]---------------------------------------------------------
function newobject:SetTextPos(x, y)

	self.textx = x
	self.texty = y

end

--[[---------------------------------------------------------
	- func: GetTextX()
	- desc: gets the object's text x position
--]]---------------------------------------------------------
function newobject:GetTextX()

	return self.textx

end

--[[---------------------------------------------------------
	- func: GetTextY()
	- desc: gets the object's text y position
--]]---------------------------------------------------------
function newobject:GetTextY()

	return self.texty

end

--[[---------------------------------------------------------
	- func: SetFont(font)
	- desc: sets the object's font
--]]---------------------------------------------------------
function newobject:SetFont(font)

	self.font = font

end

--[[---------------------------------------------------------
	- func: GetFont()
	- desc: gets the object's font
--]]---------------------------------------------------------
function newobject:GetFont()

	return self.font

end

--[[---------------------------------------------------------
	- func: GetColorIndex()
	- desc: gets the object's color index
--]]---------------------------------------------------------
function newobject:GetColorIndex()

	return self.colorindex

end

--[[---------------------------------------------------------
	- func: SetColumnData(data)
	- desc: sets the object's column data
--]]---------------------------------------------------------
function newobject:SetColumnData(data)

	self.columndata = data
	
end

--[[---------------------------------------------------------
	- func: GetColumnData()
	- desc: gets the object's column data
--]]---------------------------------------------------------
function newobject:GetColumnData()

	return self.columndata
	
end

--[[---------------------------------------------------------
	- func: SetSelected(selected)
	- desc: sets whether or not the object is selected
--]]---------------------------------------------------------
function newobject:SetSelected(selected)

	self.selected = true

end

--[[---------------------------------------------------------
	- func: GetSelected()
	- desc: gets whether or not the object is selected
--]]---------------------------------------------------------
function newobject:GetSelected()

	return self.selected
	
end
