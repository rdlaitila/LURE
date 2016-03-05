local lure = require(select('1', ...):match(".-lure%.")..'init')

--
-- Define Class
--
local class = lure.lib.upperclass:define("Event")

--
-- Event Phase NONE Constant
--
class.public : NONE {
    default=0;    
    setter='nobody';
    type='number';
}

--
-- Event phase CAPTURING_PHASE constant
--
class.public : CAPTURING_PHASE {
    default=1;    
    setter='nobody';
    type='number';
}

--
-- Event Phase AT_TARGET constant
--
class.public : AT_TARGET {
    default=2;    
    setter='nobody';
    type='number';
}

--
-- Event Phase BUBBLING_PHASE constant
--
class.public : BUBBLING_PHASE {
    default=3;    
    setter='nobody';
    type='number';
}

--
-- A boolean indicating whether the event bubbles up through the DOM or not.
--
class.public : bubbles {
    default=false;        
    type='boolean';
}

--
-- A boolean indicating whether the event is cancelable.
--
class.public : cancelable {
    default=true;
    type='boolean';
}

--
-- A reference to the currently registered target for the event.
--
class.public : currentTarget {    
    type='any';
}

--
-- Indicates whether or not event.preventDefault() has been called on the event.
--
class.public : defaultPrevented {
    default=false;    
    setter='private';
    type='boolean';
}

--
-- Indicates which phase of the event flow is being processed.
--
class.public : eventPhase {    
    type='any';
}

--
-- A reference to the target to which the event was originally dispatched.
--
class.public : target {    
    type='any';
}

--
-- The time that the event was created.
--
class.public : timeStamp {    
    type='any';
}

--
-- The name of the event (case-insensitive).
--
class.public : type {    
    setter='private';
    type='string';
}

--
-- Indicates whether or not the event was initiated by the browser (after a user click for instance) or by a script (using an event creation method, like event.initEvent)
--
class.public : isTrusted {
    default=false;    
    setter='private';
    type='boolean';
}

-- 
-- Indicates that st
--
class.public : isCanceled {
    default=false;    
    setter='private';
    type='boolean';
}

--
-- Class Constructor
--
function class.public:init(EVENT_TYPE, EVENT_INIT)
    lure.lib.upperclass:expect(EVENT_TYPE):type('string'):ne(""):throw()
    
    self.type = EVENT_TYPE
    
    self.eventPhase = lure.dom.Event.NONE
    
    for key, value in pairs(EVENT_INIT) do
        self[key] = value
    end
end
    
--
-- Cancels the event (if it is cancelable).
--
function class.public:preventDefault()
    self.defaultPrevented = true
end

--
-- For this particular event, no other listener will be called. Neither those attached on the same element, nor those attached on elements which will be traversed later (in capture phase, for instance)
--
function class.public:stopImmediatePropagation()
    if self.cancelable then
        self.isCanceled = true
    end
end

--
-- Stops the propagation of events further along in the DOM.
--
function class.public:stopPropagation()
    if self.cancelable then
        self.isCanceled = true
    end
end

-- 
-- Compile Class
--
return lure.lib.upperclass:compile(class)