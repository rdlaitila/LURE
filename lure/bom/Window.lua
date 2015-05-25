local lure = require(select('1', ...):match(".-lure%.")..'init')

--
-- Define Class
--
local Window = lure.lib.upperclass:define("BOMWindow")

--
-- Returns the window canvas
--
property : canvas {
    nil;
    get='public';
    set='private';
    type='any';
}

--
-- Enabled debug messages
--
property : debugMessages {
    false;
    get='public';
    set='public';
    type='boolean';
}

--
-- Returns the Document object for the window
--
property : document {
    nil;
    get='public';
    set='public';
    type='any';
}

--
-- The window's DOMParser
--
property : DOMParser {
    nil;
    get='public';
    set='public';
    type='any';
}

--
-- Gets the width of the content area of the browser window including, if rendered, the vertical scrollbar.
--
property : innerWidth {
    100;
    get='public';
    set='private';
    type='number';
}

--
-- Gets the height of the content area of the browser window including, if rendered, the horizontal scrollbar.
--
property : innerHeight {
    100;
    get='public';
    set='private';
    type='number';
}

--
-- The windows location object
--
property : location {
    nil;
    get='public';
    set='private';
    type='table';
}

--
-- Returns the windows left x position
--
property : left {
    0;
    get='private';
    set='private';
    type='number';
}

--
-- Returns the windows left y position
--
property : top {
    0;
    get='private';
    set='private';
    type='number';
}

--
-- Gets the width of the outside of the browser window.
--
property : outerWidth {
    100;
    get='public';
    set='private';
    type='number';
}

--
-- Gets the height of the outside of the browser window.
--
property : outerHeight {
    100;
    get='public';
    set='private';
    type='number';
}

--
-- Returns the windows resource loader
--
property : resourceLoader {
    nil;
    get='public';
    set='private';
    type='table';
}

--
-- Class Constructor
--
function private:__construct()    
    -- Create a new DOMParser
    self.DOMParser = lure.dom.DOMParser()
    
    -- Initialize Canvas
    self.canvas = love.graphics.newCanvas(self.outerWidth, self.outerHeight)
    
    -- Initialize Resource Loader
    self.resourceLoader = lure.bom.ResourceLoader()
end

--
-- Draw loop
--
function public:draw()
    love.graphics.print(os.clock(), 0, 0)
    love.graphics.rectangle("line", self.left, self.top, self.outerWidth, self.outerHeight)
end

--
-- Update loop
--
function public:update(DT)
    -- Update our resource loader for any async lodas
    self.resourceLoader:update(DT)
    
    -- Update XMLHttpRequest for any async requests
    lure.dom.XMLHttpRequest:update(DT)
end

--
-- Dynamically resizes window.
--
function public:resizeTo(WIDTH, HEIGHT)
    self.outerWidth = WIDTH
    self.outerHeight = HEIGHT
end

--
-- Love2d Mouse Pressed Callback
--
function public:mousepressed(X, Y, BUTTON)    
    -- nothing yet
end

--
-- Love2d Mouse Released Callback
--
function public:mousereleased(X, Y, BUTTON)
    -- nothing yet
end

--
-- Moves the window to the specified coordinates.
--
function public:moveTo(LEFT, TOP)
    self.left = LEFT
    self.top = TOP
end

--
-- The open() method opens a new browser window.
--
function public:open(URI)
    self.resourceLoader:load(URI, function(RESPONSE)
        if self.debugMessages then
            print("CALLBACK: ", RESPONSE.result, RESPONSE.code, RESPONSE.message, RESPONSE.content)
        end
        
        -- Reinitialize our DOM Parser
        self.DOMParser = lure.dom.DOMParser()
        
        -- Set window document to DOMParser document
        self.document = self.DOMParser.document
        
        -- Setup DOM events
        self.document:addEventListener('click',         {self, 'onDomEvent'}, false)
        self.document:addEventListener('contextmenu',   {self, 'onDomEvent'}, false)
        self.document:addEventListener('dblclick',      {self, 'onDomEvent'}, false)
        self.document:addEventListener('DOMNodeInsertedIntoDocument', {self, 'onDomEvent'}, false)
        self.document:addEventListener('mousedown',     {self, 'onDomEvent'}, false)
        self.document:addEventListener('mouseup',       {self, 'onDomEvent'}, false)
        self.document:addEventListener('mousemove',     {self, 'onDomEvent'}, false)                
        self.document:addEventListener('mouseover',     {self, 'onDomEvent'}, false)
        self.document:addEventListener('mouseout',      {self, 'onDomEvent'}, false)
        self.document:addEventListener('mouseenter',    {self, 'onDomEvent'}, false)
        self.document:addEventListener('mouseleave',    {self, 'onDomEvent'}, false)        
        
        -- Begin parsing document
        self.DOMParser:parseFromString(RESPONSE.content)    
    end)    
end

function public:onDomEvent(EVENT)
    if self.debugMessages then
        print(EVENT.type, EVENT.eventPhase, EVENT.currentTarget.nodeName, EVENT.target.nodeName)
    end
    
    if EVENT.type == 'DOMNodeInsertedIntoDocument' then
        if EVENT.target.nodeType == 1 then
            
            print(EVENT.target.tagName)
        end
    end
end

-- 
-- Compile Class
--
return lure.lib.upperclass:compile(Window)