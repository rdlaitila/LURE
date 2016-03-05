local lure = require(select('1', ...):match(".-lure%.")..'init')

--
-- Define Class
--
local class = lure.lib.upperclass:define("ResourceLoaderResponse")

--
-- Holds the resource error html content
--
class.public : content {
    setter='private';
    type='string';
}

--
-- Holds the resource response code
--
class.public : code {
    default=0;
    setter='private';
    type='number';
}

--
-- Holds the resource response success 
--
class.public : result {
    default=false;
    setter='private';
    type='boolean';
}

--
-- Holds the resource response message
--
class.public : message {
    setter='private';
    type='string';
}

--
-- Class Constructor
--
function class.public:init(RESULT, CODE, CONTENT, MESSAGE)
    self.result = RESULT
    self.code = CODE
    self.content = CONTENT
    self.message = MESSAGE
end

--
-- Compile Class
--
return lure.lib.upperclass:compile(class)