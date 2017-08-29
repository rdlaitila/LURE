local lure = require(select('1', ...):match(".-lure%.")..'init')

--
-- Define Class
--
local class = lure.lib.upperclass:define("lure.bom.Window")

--
-- Returns the window canvas
--
class.public : canvas {
    setter='private';
    type='any';
}

--
-- Enabled debug messages
--
class.public : debugMessages {
    default=false;
    type='boolean';
}

--
-- Returns the Document object for the window
--
class.public : document {
    type='lure.dom.Document';
}

--
-- Gets the width of the content area of the browser window including, if rendered, the vertical scrollbar.
--
class.public : innerWidth {
    default=100;
    setter='private';
    type='number';
}

--
-- Gets the height of the content area of the browser window including, if rendered, the horizontal scrollbar.
--
class.public : innerHeight {
    default=100;
    setter='private';
    type='number';
}

--
-- The windows location object
--
class.public : location {
    setter='private';
    type='lure.bom.Location';
}

--
-- Returns the windows left x position
--
class.private : left {
    default=0;
    type='number';
}

--
-- Returns the windows left y position
--
class.private : top {
    default=0;
    type='number';
}

--
-- Gets the width of the outside of the browser window.
--
class.public : outerWidth {
    default=100;
    setter='private';
    type='number';
}

--
-- Gets the height of the outside of the browser window.
--
class.public : outerHeight {
    default=100;
    setter='private';
    type='number';
}

--
-- Returns the windows resource loader
--
class.public : resourceLoader {
    setter='private';
    type='ResourceLoader';
}

--
-- Class Constructor
--
function class.public:init()   
    --Initialize document
    self.document = lure.dom.Document()
    
    -- Initialize Canvas
    self.canvas = love.graphics.newCanvas(self.outerWidth, self.outerHeight)
    
    -- Initialize Resource Loader
    self.resourceLoader = lure.bom.ResourceLoader()
end

--
-- Draw loop
--
function class.public:draw()
    love.graphics.print(os.clock(), 0, 0)
    love.graphics.rectangle("line", self.left, self.top, self.outerWidth, self.outerHeight)
end

--
-- Update loop
--
function class.public:update(DT)
    -- Update our resource loader for any async lodas
    self.resourceLoader:update(DT)
    
    -- Update XMLHttpRequest for any async requests
    lure.dom.XMLHttpRequest:update(DT)
end

--
-- Dynamically resizes window.
--
function class.public:resizeTo(WIDTH, HEIGHT)
    lure.lib.upperclass:expect(WIDTH):type('number'):gte(0):throw()
    lure.lib.upperclass:expect(HEIGHT):type('number'):gte(0):throw()
    
    self.outerWidth = WIDTH
    self.outerHeight = HEIGHT
end

--
-- Love2d Mouse Pressed Callback
--
function class.public:mousepressed(X, Y, BUTTON)    
    -- nothing yet
end

--
-- Love2d Mouse Released Callback
--
function class.public:mousereleased(X, Y, BUTTON)
    -- nothing yet
end

--
-- Moves the window to the specified coordinates.
--
function class.public:moveTo(LEFT, TOP)
    lure.lib.upperclass:expect(LEFT):type('number'):throw()
    lure.lib.upperclass:expect(TOP):type('number'):throw()
    
    self.left = LEFT
    self.top = TOP
end

--
-- The open() method opens a new browser window.
--
function class.public:open(URI)
    lure.lib.upperclass:expect(URI):type('string'):throw()
    
    local document = self.document
    self.resourceLoader:load(URI, function(RESPONSE)
        if self.debugMessages then
            print("CALLBACK: ", RESPONSE.result, RESPONSE.code, RESPONSE.message, RESPONSE.content)
        end
        
        -- Setup DOM events
        self.document:addEventListener('click',         {self, 'onDomEvent'}, false)
        self.document:addEventListener('contextmenu',   {self, 'onDomEvent'}, false)
        self.document:addEventListener('dblclick',      {self, 'onDomEvent'}, false)
        self.document:addEventListener('DOMNodeInsertedIntoDocument', {self, 'onDomEvent'}, false)
        self.document:addEventListener('DOMContentLoaded', {self, 'onDomEvent'}, false)
        self.document:addEventListener('mousedown',     {self, 'onDomEvent'}, false)
        self.document:addEventListener('mouseup',       {self, 'onDomEvent'}, false)
        self.document:addEventListener('mousemove',     {self, 'onDomEvent'}, false)                
        self.document:addEventListener('mouseover',     {self, 'onDomEvent'}, false)
        self.document:addEventListener('mouseout',      {self, 'onDomEvent'}, false)
        self.document:addEventListener('mouseenter',    {self, 'onDomEvent'}, false)
        self.document:addEventListener('mouseleave',    {self, 'onDomEvent'}, false)        
        
        -- Begin parsing document
        document:write(RESPONSE.content)
        document:close()
    end)    
end

function class.public:onDomEvent(EVENT)
    if self.debugMessages then
        print(
            "T:"..tostring(EVENT.type), 
            "P:"..tostring(EVENT.eventPhase), 
            "CT:"..tostring(EVENT.currentTarget.nodeName), 
            "TG:"..tostring(EVENT.target.nodeName)
        )
    end
end

-- 
-- Compile Class
--
return lure.lib.upperclass:compile(class)