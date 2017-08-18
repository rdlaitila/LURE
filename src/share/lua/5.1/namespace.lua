--[[
The MIT License (MIT)

Copyright (c) 2016 Regan Daniel Laitila

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

--
-- Namespace provides a defered require mechanism on tables. Each table key 
-- can contain any value on assignment, with the special case that when assigning 
-- a string value to a table key, that table key (the string value) indicates a lua
-- package path to require when that key is accessed.
--
local Namespace = {}

--
-- Global to local references for performance
--
local package = package
local rawset = rawset
local require = require
local setmetatable = setmetatable
local type = type

--
-- __call creates a new namespace
--
function Namespace:__call(base)    
    return setmetatable({__keys={};__base=base}, Namespace)    
end

--
-- __index indicates that the namespace key does not yet
-- exist on the table, thus it must be required
--
function Namespace:__index(k)       
    local key = self.__keys[k]
    
    if key == nil then return end
    
    local r = require(self.__base.."."..key)
    
    rawset(self, k, r)
    
    return r
end

--
-- __newindex will assign the value to the table key 
-- if it is any value other than a string, in which case
-- it will be added to our __keys for deferred require
--
function Namespace:__newindex(k, v)
    local t = type(v)
    
    if t ~= 'string' then
        rawset(self, k, v)
        return
    end
    
    self.__keys[k] = v
end

function Namespace.base(path)
    return select('1', path):gsub("%.-init$", "")
end

--
-- :D
--
return setmetatable(Namespace, Namespace)