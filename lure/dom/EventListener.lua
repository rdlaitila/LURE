-- Obtain our base require path
local BASE_PATH = select('1', ...):match(".-lure%.")

-- Require dependencies
local lure = require(BASE_PATH..'init')

--
-- Define Class
--
local EventListener = lure.lib.upperclass:define("EventListener")

--
-- Returns the name of the event this listener is attached to
--
property : name {
    nil;
    get='public';
    set='public';
    type='string';
}

--
-- Returns the function callback registered with this event listener
--
property : callback {
    nil;
    get='public';
    set='private';
    type='any';
}

--
-- Determines if this event listener is invoked on the lure.dom.Event.CAPTURE_PHASE
--
property : useCapture { 
    false;
    get='public';
    set='public';
}

--
-- Class Constructor
--
function private:__construct(EVENT_NAME, CALLBACK, USE_CAPTURE)
    self.name = EVENT_NAME    
    
    self.callback = CALLBACK
    
    if USE_CAPTURE == nil then        
        self.useCapture = false
    else
        self.useCapture = USE_CAPTURE
    end
end

--
-- This method is called whenever an event occurs of the type for which the EventListener interface was registered. 
--
function public:handleEvent(EVENT)    
    if type(self.callback) == 'function' then        
        self.callback(EVENT)
    elseif type(self.callback) == 'table' then        
        self.callback[1][self.callback[2]](self.callback[1], EVENT)
    end
end

--
-- Compile Class
--
return lure.lib.upperclass:compile(EventListener)