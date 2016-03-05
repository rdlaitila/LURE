print(_VERSION)
local lure = require('lure.init')
local window = lure.bom.Window()

function love.load()
    if arg[#arg] == "-debug" then require("mobdebug").start() end
    
    window.debugMessages = true
    window:resizeTo(love.graphics.getWidth(), 200)
    window:open("file://lure/res/html/about_blank.html")
end
function love.update(dt)
    window:update(DT)
end
function love.draw()	
    window:draw()
end
function love.keypressed(key, unicode)
    window:keypressed(key, unicode)
end
function love.keyreleased(key)
    window:keyreleased(key)
end
function love.mousepressed(X, Y, BUTTON)
    window:mousepressed(X, Y, BUTTON)
end
function love.mousereleased(X, Y, BUTTON)
    window:mousereleased(X, Y, BUTTON)
end
function love.textinput(STRING)
    window:textinput(STRING)
end
function love.threaderror(t, e)
     error(e)
end