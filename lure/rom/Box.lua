-- Obtain our base require path
local BASE_PATH = select('1', ...):match(".-lure%.")

-- Require dependencies
local lure = require(BASE_PATH..'init')

--
-- Define Class
--
local Box = lure.lib.upperclass:define("ROMBox")

--
-- Returns the box's formatting context
--
property : formattingContext {
    nil;
    get='public';
    set='private';
    type='number';
}

--
-- Class Constructor
--
function private:__construct()
end

--
-- Layout
--
function public:layout()
end

--
-- Paint
--
function public:paint()
end

--
-- Compile Class
--
return lure.lib.upperclass:compile(Box)