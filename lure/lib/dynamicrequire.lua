--
-- Our DynamicRequire object
--
local DynamicRequireObject = {}

--
-- Our DynamicRequireMetatable
--
local DynamicRequireMetatable = {}

--
-- DynamicRequireMetatable __index
--
function DynamicRequireMetatable:__index(KEY)
    if KEY == '_keys' then
        return rawget(self, '_keys')
    end
    if package.loaded[rawget(self, '_keys')[KEY]] ~= nil then
        return package.loaded[rawget(self, '_keys')[KEY]]
    else
        return require(rawget(self, '_keys')[KEY])
    end
end

--
-- DynamicRequireMetatable __newindex
--
function DynamicRequireMetatable:__newindex(KEY, VALUE)
    rawget(self, '_keys')[KEY] = VALUE
end

--
-- DynamicRequireMetatable __call
--
function DynamicRequireMetatable:__call()
    local instance = {_keys = {}}
    setmetatable(instance, DynamicRequireMetatable)
    return instance
end

--
-- Set DynamicRequireObject Metatable
--
setmetatable(DynamicRequireObject, DynamicRequireMetatable)

--
-- Return DynamicRequire
--
return DynamicRequireObject