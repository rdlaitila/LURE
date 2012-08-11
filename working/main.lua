function love.load()
	gfx = love.graphics
	gfx.setBackgroundColor(255,255,255)
	
	require('lure//lure')		
	
	debug.sethook(lure.trace, "c")
	
	htmldoc = lure.load("lure//tests//layout//block-layouts//index.html")	
	
	--print(htmldoc.getElementsByTagName("h3")[1].computedStyle.fontSize)
end
function love.update(dt)		
	print("UPDATE")
	lure.update(dt)
end
function love.draw()	
	gfx.setColor(0,0,0)	
	print("DRAW")
	lure.draw()	
end
function love.keypressed(key, unicode)
	if key == "6" then
		lure.rom.romTreeDump(lure.layers[1].viewport)
	end
	if key == "7" then
		lure.layers[1].load("test.html")
	end
	if key == "8" then
		lure.layers[1].viewport.renderStyle.width = lure.layers[1].viewport.renderStyle.width - 10
		lure.layers[1].viewport.layout()
	end
	if key == "9" then
		lure.layers[1].viewport.renderStyle.width = lure.layers[1].viewport.renderStyle.width + 10
		lure.layers[1].viewport.layout()
	end
end
