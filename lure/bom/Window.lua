-- Obtain our base require path
local BASE_PATH = select('1', ...):match(".-lure%.")

-- Require dependencies
local lure = require(BASE_PATH..'init')

--
-- Define Class
--
local Window = lure.lib.upperclass:define("BOMWindow", lure.dom.Node)

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
-- Returns the Document object for the window
--
property : document {
    nil;
    get='public';
    set='private';
    type='any';
}

--
-- The window's DOMParser
--
property : DOMParser {
    nil;
    get='public';
    set='private';
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
-- Returns the list of events in the event stack
--
property : eventStack {
    nil;
    get='public';
    set='private';
    type='table';
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
-- Class Constructor
--
function private:__construct()
    -- Construct parent
    self:__constructparent(901)
    
    -- Create a new DOMParser
    self.DOMParser = lure.dom.DOMParser()
    
    -- Initialize Event Stack
    self.eventStack = {}
    
    -- Initialize Canvas
    self.canvas = love.graphics.newCanvas(self.outerWidth, self.outerHeight)
end

--
-- Draw loop
--
function public:draw()
    love.graphics.rectangle("line", self.left, self.top, self.outerWidth, self.outerHeight)
end

--
-- Update loop
--
function public:update(DT)
    self:processEvents(false)
end

--
-- Processes event objects in the stack
--
function public:processEvents(PROCESS_ALL)
    if PROCESS_ALL == nil then
        PROCESS_ALL = false
    end
    
    while #self.eventStack > 0 do
        local event = self.eventStack[1]
        
        print("PROCESSING EVENT: ", event.type)
        
        -- EVENT PROCESSING DONE, REMOVE FROM eventStack
        table.remove(self.eventStack, 1)
        
        -- Stop if we are not proceessing all events
        if PROCESS_ALL == false then            
            break
        end
    end
end

--
-- Dynamically resizes window.
--
function public:resizeTo(WIDTH, HEIGHT)
    self.outerWidth = WIDTH
    self.outerHeight = HEIGHT
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
function public:open(URI, NAME, SPECS, REPLACE)
    local loaderResponse = lure.bom.ResourceLoader:load(URI)
    if loaderResponse.result == true then
        error("Successfully Loaded Resource")
    else
        error("Error Loading Resource")
    end
end

-- 
-- Compile Class
--
return lure.lib.upperclass:compile(Window)