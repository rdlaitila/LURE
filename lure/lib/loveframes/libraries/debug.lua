--[[------------------------------------------------
	-- Love Frames - A GUI library for LOVE --
	-- Copyright (c) 2012-2014 Kenny Shields --
--]]------------------------------------------------

-- get the current require path
local path = string.sub(..., 1, string.len(...) - string.len(".debug"))
local loveframes = require(path .. ".common")

-- debug library
loveframes.debug = {}

--[[---------------------------------------------------------
	- func: draw()
	- desc: draws debug information
--]]---------------------------------------------------------
function loveframes.debug.draw()
	
	-- do not draw anthing if debug is off
	local debug = loveframes.config["DEBUG"]
	if not debug then
		return
	end
	
	local infox = 5
	local infoy = 40
	local topcol = {type = "None", children = {}, x = 0, y = 0, width = 0, height = 0}
	local hoverobject = loveframes.hoverobject
	--local objects = loveframes.util.GetAllObjects()
	local version = loveframes.version
	local stage = loveframes.stage
	local basedir = loveframes.config["DIRECTORY"]
	local loveversion = love._version
	local fps = love.timer.getFPS()
	local deltatime = love.timer.getDelta()
	local font = loveframes.basicfontsmall
	
	if hoverobject then
		topcol = hoverobject
	end
	
	-- show frame docking zones
	if topcol.type == "frame" then
		for k, v in pairs(topcol.dockzones) do
			love.graphics.setLineWidth(1)
			love.graphics.setColor(255, 0, 0, 100)
			love.graphics.rectangle("fill", v.x, v.y, v.width, v.height)
			love.graphics.setColor(255, 0, 0, 255)
			love.graphics.rectangle("line", v.x, v.y, v.width, v.height)
		end
	end
	
	-- outline the object that the mouse is hovering over
	love.graphics.setColor(255, 204, 51, 255)
	love.graphics.setLineWidth(2)
	love.graphics.rectangle("line", topcol.x - 1, topcol.y - 1, topcol.width + 2, topcol.height + 2)
	
	-- draw main debug box
	love.graphics.setFont(font)
	love.graphics.setColor(0, 0, 0, 200)
	love.graphics.rectangle("fill", infox, infoy, 200, 70)
	love.graphics.setColor(255, 0, 0, 255)
	love.graphics.print("Love Frames - Debug (" ..version.. " - " ..stage.. ")", infox + 5, infoy + 5)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.print("LOVE Version: " ..loveversion, infox + 10, infoy + 20)
	love.graphics.print("FPS: " ..fps, infox + 10, infoy + 30)
	love.graphics.print("Delta Time: " ..deltatime, infox + 10, infoy + 40)
	love.graphics.print("Total Objects: " ..loveframes.objectcount, infox + 10, infoy + 50)
	
	-- draw object information if needed
	if topcol.type ~= "base" then
		love.graphics.setColor(0, 0, 0, 200)
		love.graphics.rectangle("fill", infox, infoy + 75, 200, 100)
		love.graphics.setColor(255, 0, 0, 255)
		love.graphics.print("Object Information", infox + 5, infoy + 80)
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.print("Type: " ..topcol.type, infox + 10, infoy + 95)
		if topcol.children then
			love.graphics.print("# of children: " .. #topcol.children, infox + 10, infoy + 105)
		else
			love.graphics.print("# of children: 0", infox + 10, infoy + 105)
		end
		if topcol.internals then
			love.graphics.print("# of internals: " .. #topcol.internals, infox + 10, infoy + 115)
		else
			love.graphics.print("# of internals: 0", infox + 10, infoy + 115)
		end
		love.graphics.print("X: " ..topcol.x, infox + 10, infoy + 125)
		love.graphics.print("Y: " ..topcol.y, infox + 10, infoy + 135)
		love.graphics.print("Width: " ..topcol.width, infox + 10, infoy + 145)
		love.graphics.print("Height: " ..topcol.height, infox + 10, infoy + 155)
	end
	
end
