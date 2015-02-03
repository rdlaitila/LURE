function love.load()    
    lure = require('lure.init')
    
    window = lure.bom.Window()
    
    window:open("file://res/html/about_blank.html")
end
function love.update(dt)
    lure.lib.lovebird.update(dt)
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
    browser:mousereleased(X, Y, BUTTON)
end
function love.textinput(STRING)
    browser:textinput(STRING)
end