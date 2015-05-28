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