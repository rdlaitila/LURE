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
-- Here We Go :)
--
local upperclass = {}

--
-- Our version: Major.Minor.Patch
--
upperclass.version = "0.4.0-dev"

--
-- Table to use for all expect calls
--
local expectTable = {}

--
-- Registry holds the implimenation of all
-- defined classes. Upperclass makes heavy
-- use of the registry to locate members,
-- callers, parents and childs etc
--
local registry = {}

--
-- Move global debug to local debug
--
local rawdebug = debug

--
-- Move global type to local type
--
local rawtype = type

--
-- Runtime metatable
--
local RuntimeMetatable = {}

--
-- expect
--
function upperclass:expect(value)
    expectTable.__value = value;
    expectTable.__errors = {};
    return expectTable
end

--
-- expect_gt
--
function upperclass:expect_gt(expected)
    if self.__value == nil or self.__value <= expected then
        table.insert(
            self.__errors, 
            {'gt', string.format("Expected Greater Than '%s' recieved '%s'", expected, self.__value)
        })        
    end
    return self 
end

--
-- expect_gte
--
function upperclass:expect_gte(expected)
    if self.__value == nil or self.__value < expected then
        table.insert(
            self.__errors, 
            {'gte', string.format("Expected Greater or Equal to '%s' recieved '%s'", expected, self.__value)
        })        
    end
    return self 
end

--
-- expect_not
--
function upperclass:expect_ne(expected)
    if self.__value == expected then
        table.insert(
            self.__errors, 
            {'ne', string.format("Expected '%s' to not equal '%s'", self.__value, expected)
        })
    end
    return self
end

--
-- expect_type
--
function upperclass:expect_type(expected)
    local result = upperclass:type(self.__value)
    if result ~= expected then
        table.insert(
            self.__errors, 
            {'type', string.format("Expected type '%s' recieved type '%s'", expected, result)
        })         
    end
    return self
end

--
-- expect_throw
--
function upperclass:expect_throw()
    if #self.__errors > 0 then
        upperclass:throw(self.__errors[1][2])
    end
end

--
-- Define
--
function upperclass:define(name, parent, impliments)
    upperclass:expect(name):type('string'):ne(''):throw()

    if parent ~= nil and rawtype(parent) == 'table' and parent.__isupperclass then
        parent = registry[parent.__name]
    end

    if impliments ~= nil and rawtype(impliments) ~= 'table' then
        upperclass:throw("Argument 'impliments' must be a table")
    elseif impliments ~= nil and rawtype(impliments) == 'table' then
        for index, iface in ipairs(impliments) do
            if rawtype(iface) ~= 'table' or iface.__isupperclass == nil then
                upperclass:throw("Impliments table index %s is not a class", index)
            end
        end
    end

    --
    -- Check our registry for a class already defined
    -- with the same name supplied from the user
    --
    if registry[name] ~= nil then
        upperclass:throw("Attempt to re-define existing class '%s' is disallowed", name)
    else
        registry[name] = {
            name      = name;
            parent    = parent;
            childs    = {};
            members   = {};
            callers   = {
                private = {};
                protected = {};
            };
            impliments = impliments;
        }

        if parent ~= nil then
            parent.childs[name] = registry[name]
        end
    end

    --
    -- Hold a reference to our spot in the registry
    --
    local classdef = registry[name]

    --
    -- hold a reference to our members
    --
    local members = classdef.members

    --
    -- Holds the last scope supplied during definition
    --
    local lastscope = 'public'

    --
    -- Metatables
    --
    local DefinitionMetatable = {}

    --
    -- Static Metatable
    --
    function DefinitionMetatable:__index(key)
        if key == 'public' or key == 'private' or key == 'protected' or key == 'static' then
            lastscope = key;return self
        end
        
        return function(...)
            local args = {...}
            local proptable = nil
            
            if #args == 0 then
                upperclass:throw("No property table supplied to member definition '%s'", key)
            else
                proptable = args[#args]
            end
            
            members[key] = {
                getter = proptable.getter or lastscope;
                setter = proptable.setter or lastscope;
                nullable = proptable.nullable or false;
                default = proptable.default;
                types = {};
            }
            
            local function parsetypes(types, t)
                if rawtype(t) == 'string' then
                    table.insert(types, t)
                elseif rawtype(t) == 'table' and t.__isupperclass ~= nil and t.__name ~= nil then
                    table.insert(types, t.__name)
                elseif rawtype(t) == 'table' then
                    for _, item in ipairs(t) do
                        types = parsetypes(types, item)
                    end
                end
                return types
            end
            members[key].types = parsetypes({}, proptable.type)

            if members[key].types['any'] ~= nil and members[key].default ~= nil and members[key].type ~= upperclass:type(members[key].default) then
                upperclass:throw("default/type mismatch in property '%s' in '%s'", key, classdef.name)
            end
            
            lastscope = 'public'
        end        
    end
    function DefinitionMetatable:__newindex(key, value)
        members[key] = {
            getter = lastscope;
            setter = 'nobody';
            nullable = false;
            type = 'function';
            default = value;
        }
        
        table.insert(classdef.callers.private, value)
        table.insert(classdef.callers.protected, value)
        local parent = classdef.parent
        while parent ~= nil do
            table.insert(parent.callers.protected, value)
            parent = parent.parent
        end
        
        lastscope = 'public'
    end

    return setmetatable({__name=name}, DefinitionMetatable)
end

--
-- Compile
--
function upperclass:compile(classobj)
    local classdef = registry[classobj.__name]

    --
    -- Object is our static/instantiable table
    --
    local object = {
        __name = classdef.name;
        __overrides = {};
        __isinstance = false;
        __isupperclass = true;
        __mmindex=true;
        __mmnewindex=true;
    }

    --
    -- Return
    --
    return setmetatable(object, RuntimeMetatable)
end

--
-- Dumps a table
--
function upperclass:dumptable(t)
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end

--
-- Lookup Class member
--
function upperclass:lookup(classdef, key)
    local member = classdef.members[key]
    local parent = classdef.parent

    if member ~= nil then
        return classdef, member
    elseif parent ~= nil then
        return upperclass:lookup(parent, key)
    else
        return classdef, nil
    end
end

--
-- Lookup class member of a caller
--
function upperclass:lookupcaller(caller)
    for _, def in pairs(registry) do
        local classdef = def
        while classdef ~= nil do
            for mkey, mvalue in pairs(def.members) do
                if mvalue.default == caller then
                    return def, mvalue, mkey
                end
            end
            classdef = classdef.parent
        end
    end
end

--
-- Throws an error
--
function upperclass:throw(errstr, ...)
    error(string.format(errstr, ...))
end

--
-- Looks up a class type or data type
--
function upperclass:type(value)
    local t = rawtype(value)
    if t == 'table' then
        if value.__isupperclass then
            return value.__name
        else
            return t
        end
    else
        return t
    end
end

--
-- __call
--
function RuntimeMetatable:__call(...)
    local classdef = registry[self.__name]

    local instance = setmetatable({
        __name = classdef.name;
        __overrides = {};
        __isinstance = true;
        __isupperclass = true;
        __mmindex=true;
        __mmnewindex=true;
    }, RuntimeMetatable)

    if classdef.members['init'] ~= nil then
        instance:init(...)
    end

    return instance
end

--
-- __index
--
function RuntimeMetatable:__index(key)    
    local classdef = registry[self.__name]
    
    local mdef, member = classdef, nil
    while mdef ~= nil do
        if mdef.members[key] ~= nil then
            member = mdef.members[key]
            break
        else
            mdef = mdef.parent
        end
    end

    if member == nil and key ~= '__index' and self.__mmindex and classdef.members['__index'] ~= nil  then
        self.__mmindex = false
        local __index = classdef.members['__index'].default
        local val = __index(self, key)
        self.__mmindex = true
        return val   
    end

    if member == nil then
        upperclass:throw("Attempt to index non-existant member '%s' is disallowed", key)
    end

    -- Bool indicating if we are of proper scope
    local scopepermit = false

    -- Check scopes
    if rawdebug == nil or member.getter == 'public' then
        scopepermit = true
    elseif member.getter == 'private' or member.getter == 'protected' then
        local caller = rawdebug.getinfo(2, 'f').func        
        for _, func in ipairs(mdef.callers[member.getter]) do
            if func == caller then
                scopepermit = true
                break
            end
        end
    end
    
    if scopepermit then
        local override = self.__overrides[key]
        if override == nil then
            return member.default
        else
            return override.value
        end
    else
        upperclass:throw("Attempt to access '%s' member '%s' of class '%s' from outside of class is disallowed", member.getter, key, mdef.name)
    end

    upperclass:throw("__index failure")
end

--
-- __newindex
--
function RuntimeMetatable:__newindex(key, value)
    local classdef = registry[self.__name]
    
    local mdef, member = classdef, nil      
    while mdef ~= nil do
        if mdef.members[key] ~= nil then
            member = mdef.members[key]
            break
        else
            mdef = mdef.parent
        end
    end

    if member == nil and key ~= '__newindex' and self.__mmnewindex and classdef.members['__newindex'] ~= nil  then
        obj.__mmnewindex = false
        local __newindex = classdef.members['__newindex'].default
        __newindex(self, key, value)
        self.__mmnewindex = true
        return
    end

    if member == nil then
        upperclass:throw("Attempt to newindex non-existant member %s is disallowed", key)
    end

    -- Bool indicating if we are of proper scope
    local scopepermit = false

    -- Scope check
    if rawdebug == nil or member.setter == 'public' then
        scopepermit = true
    elseif member.setter == 'private' or member.setter == 'protected' then
        local caller = rawdebug.getinfo(2, 'f').func       
        for _, func in ipairs(mdef.callers[member.setter]) do
            if func == caller then
                scopepermit = true
                break
            end
        end        
    else
        upperclass:throw("Attempt to assign value to member with setter scope of '%s' is disallowed", member.setter)
    end

    -- Type Check
    if scopepermit then
        if value == nil and member.nullable then
            if self.__overrides[key] ~= nil then
                self.__overrides[key].value = value
            else
                self.__overrides[key] = {value=value}
            end
            return
        end
        
        local valuetype = upperclass:type(value)
        
        for _, t in ipairs(member.types) do
            if t == 'any' or valuetype == t then
                if self.__overrides[key] ~= nil then
                    self.__overrides[key].value = value
                else
                    self.__overrides[key] = {value=value}
                end
                return
            end
        end
        
        upperclass:throw("Attempt to assign value to member '%s' of class '%s' with mismatched value of type '%s' is disallowed", key, mdef.name, valuetype)
    else
        upperclass:throw("Attempt to assign value to '%s' member '%s' from class '%s' failed. Caller is not in scope", member.setter, key, mdef.name)
    end

    upperclass:throw("__newindex failure")
end

--
-- Expect table to use for all expect calls
-- Must be set at the bottom of the module
-- to ensure all expect methods have been parsed
--
expectTable = {
    __errors = {};
    __value = nil;        
    gt = upperclass.expect_gt;
    gte = upperclass.expect_gte;
    ne = upperclass.expect_ne;
    neq = upperclass.expect_ne;
    type = upperclass.expect_type;
    throw = upperclass.expect_throw;
}

--
-- Return upperclass
--
return upperclass
