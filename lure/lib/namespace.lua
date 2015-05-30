--[[
The MIT License (MIT)

Copyright (c) 2014 Regan Daniel Laitila

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
-- Our Namespace object
--
local namespace = {}

--
-- Our NamespaceMetatable
--
local NamespaceMetatable = {}

--
-- NamespaceMetatable __index
--
function NamespaceMetatable:__index(KEY)
    if KEY == '_keys' then
        return rawget(self, '_keys')
    end
    
    if type(rawget(self, '_keys')[KEY]) == 'function' then
        return rawget(self, '_keys')[KEY]
    elseif package.loaded[rawget(self, '_keys')[KEY]] ~= nil then
        return package.loaded[rawget(self, '_keys')[KEY]]
    else
        return require(rawget(self, '_keys')[KEY])
    end
end

--
-- NamespaceMetatable __newindex
--
function NamespaceMetatable:__newindex(KEY, VALUE)
    rawget(self, '_keys')[KEY] = VALUE
end

--
-- NamespaceMetatable __call
--
function NamespaceMetatable:__call()
    local instance = {_keys = {}}
    setmetatable(instance, NamespaceMetatable)
    return instance
end

--
-- Set NamespaceObject Metatable
--
setmetatable(namespace, NamespaceMetatable)

--
-- Return Namespace
--
return namespace