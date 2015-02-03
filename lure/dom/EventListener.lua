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
    set='public';
    type='any';
}

--
-- Class Constructor
--
function private:__construct(EVENT_NAME, CALLBACK)
    self.name = EVENT_NAME
    self.callback = CALLBACK
end

--
-- Calls the event listener callback
--
function public:call(...)
    return self.callback(...)
end

--
-- Compile Class
--
return lure.lib.upperclass:compile(EventListener)