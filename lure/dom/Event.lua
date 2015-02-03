-- Obtain our base require path
local BASE_PATH = select('1', ...):match(".-lure%.")

-- Require dependencies
local lure = require(BASE_PATH..'init')

--
-- Define Class
--
local Event = lure.lib.upperclass:define("Event")

--
-- Event Phase NONE Constant
--
property : NONE {
    0;
    get='public';
    set='nobody';
    type='number';
}

--
-- Event phase CAPTURING_PHASE constant
property : CAPTURING_PHASE {
    1;
    get='public';
    set='nobody';
    type='number';
}

--
-- Event Phase AT_TARGET constant
--
property : AT_TARGET {
    2;
    get='public';
    set='nobody';
    type='number';
}

--
-- Event Phase BUBBLING_PHASE constant
--
property : BUBBLING_PHASE {
    3;
    get='public';
    set='nobody';
    type='number';
}

--
-- A boolean indicating whether the event bubbles up through the DOM or not.
--
property : bubbles {
    false;
    get='public';
    set='public';
    type='boolean';
}

--
-- A boolean indicating whether the event is cancelable.
--
property : cancelable {
    true;
    get='public';
    set='public';
    type='boolean';
}

--
-- A reference to the currently registered target for the event.
--
property : currentTarget {
    nil;
    get='public';
    set='public';
    type='any';
}

--
-- Indicates whether or not event.preventDefault() has been called on the event.
--
property : defaultPrevented {
    false;
    get='public';
    set='private';
    type='boolean';
}

--
-- Indicates which phase of the event flow is being processed.
--
property : eventPhase {
    nil;
    get='public';
    set='public';
    type='any';
}

--
-- A reference to the target to which the event was originally dispatched.
--
property : target {
    nil;
    get='public';
    set='public';
    type='any';
}

--
-- The time that the event was created.
--
property : timeStamp {
    nil;
    get='public';
    set='public';
    type='any';
}

--
-- The name of the event (case-insensitive).
--
property : type {
    nil;
    get='public';
    set='private';
    type='string';
}

--
-- Indicates whether or not the event was initiated by the browser (after a user click for instance) or by a script (using an event creation method, like event.initEvent)
--
property : isTrusted {
    false;
    get='public';
    set='private';
    type='boolean';
}


--
-- Class Constructor
--
function private:__construct(EVENT_TYPE, EVENT_INIT)
    self.type = EVENT_TYPE
    
    for key, value in pairs(EVENT_INIT) do
        self[key] = value
    end
end
    
--
-- Cancels the event (if it is cancelable).
--
function public:preventDefault()
    error("Function Not Implimented")
end

--
-- For this particular event, no other listener will be called. Neither those attached on the same element, nor those attached on elements which will be traversed later (in capture phase, for instance)
--
function public:stopImmediatePropagation()
    error("Function Not Implimented")
end

--
-- Stops the propagation of events further along in the DOM.
--
function public:stopPropagation()
    error("Function Not Implimented")
end

--
-- Processes the event flow
--
function public:process()
    
end

-- 
-- Compile Class
--
return lure.lib.upperclass:compile(Event)