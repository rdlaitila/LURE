local lure = require(select('1', ...):match(".-lure%.")..'init')

--
-- Define Class
--
local class = lure.lib.upperclass:define("EventListener")

--
-- Returns the name of the event this listener is attached to
--
class.public : name {
    type='string';
}

--
-- Returns the function callback registered with this event listener
--
class.public : callback { 
    setter='private';
    type='any';
}

--
-- Determines if this event listener is invoked on the lure.dom.Event.CAPTURE_PHASE
--
class.public : useCapture { 
    default=false;
    type='boolean';
}

--
-- Class Constructor
--
function class.public:init(EVENT_NAME, CALLBACK, USE_CAPTURE)
    lure.lib.upperclass:expect(EVENT_NAME):type('string'):throw()    
    
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
function class.public:handleEvent(EVENT)    
    if type(self.callback) == 'function' then        
        self.callback(EVENT)
    elseif type(self.callback) == 'table' then        
        self.callback[1][self.callback[2]](self.callback[1], EVENT)
    end
end

--
-- Compile Class
--
return lure.lib.upperclass:compile(class)