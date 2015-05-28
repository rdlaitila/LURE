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
-- Here We Go! :)
--
local upperclass = {}

--
-- Our version: Major.Minor.Patch
--
upperclass.VERSION = "0.4.0-dev"

--
-- Define some internal constants
--
upperclass.DEFAULT_BEHAVIOR       = {}
upperclass.SCOPE_PRIVATE          = {string='private'}
upperclass.SCOPE_PROTECTED        = {string='protected'}
upperclass.SCOPE_PUBLIC           = {string='public'} 
upperclass.SCOPE_NOBODY           = {string='nobody'}
upperclass.MEMBER_TYPE_PROPERTY   = {string='property'}
upperclass.MEMBER_TYPE_METHOD     = {string='method'}
upperclass.TYPE_ANY               = {string='any'}
upperclass.TYPE_STRING            = {string='string'}
upperclass.TYPE_TABLE             = {string='table'}
upperclass.TYPE_FUNCTION          = {string='function'}
upperclass.TYPE_NUMBER            = {string='number'}
upperclass.TYPE_USERDATA          = {string='userdata'}
upperclass.TYPE_NIL               = {string='nil'}
upperclass.TYPE_BOOLEAN           = {string='boolean'}
upperclass.TYPE_CLASS             = {string='class'}
upperclass.D_INVALID_EXISTING_MEMBER_ASSIGNMENT = {errno=0,    stage="definition",  message="Attempt to redefine existing member '%s' in class '%s' is disallowed"}; 
upperclass.D_INVALID_PROPERTY_TYPE_ASSIGNMENT   = {errno=1,    stage="definition",  message="Attempt to define class member property '%s' as type '%s' when supplied value is of type '%s' is disallowed"};
upperclass.R_INVALID_MEMBER_LOOKUP              = {errno=200,  stage="runtime",     message="Attempt to get class member '%s' in class '%s' is disallowed. No such member defined"};
upperclass.R_INVALID_SCOPE_ACCESS               = {errno=201,  stage="runtime",     message="Attempt to retrieve '%s' member '%s' from outside of class '%s' is disallowed"};    
upperclass.R_INVALID_MEMBER_ASSIGNMENT          = {errno=202,  stage="runtime",     message="Attempt to set '%s' member '%s' in class '%s' is disallowed"};
upperclass.R_INVALID_MEMBER_SCOPED_ASSIGNMENT   = {errno=203,  stage="runtime",     message="Attempt to set '%s' member '%s' from outside of class '%s' is disallowed"};
upperclass.R_INVALID_MEMBER_TYPE_ASSIGNMENT     = {errno=204,  stage="runtime",     message="Attempt to set '%s' member '%s' of type '%s' with type '%s' in class '%s' is disallowed"};
upperclass.R_INVALID_METAMETHOD_LOOKUP          = {errno=205,  stage="runtime",     message="Attempt to call '%s' metamethod on class '%s' is disallowed. No such metamethod defined"};

--
-- Holds the metatable used during the class definition stage
--
local ClassDefinitionMetatable = {classDefinitionTable = nil}

--
-- Holds the metatable used during class runtime operations
--
local ClassRuntimeMetatable = {}

--
-- Throws an upperclass error
--
function upperclass:throw(ERROR, ...)
    local errorname = nil
    for key, value in pairs(upperclass) do
        if upperclass[key] == ERROR then
            errorname = key
            break
        end
    end    
    error(errorname..": "..ERROR.message:format(...))
end

--
-- Dumps class members
--
function upperclass:dumpClassMembers(CLASS, SORT_COLUMN)
    -- Some spacing
    print(" ")
    print("-= MEMBER DUMP START =- ")
    
    -- Sets which colum of output to sort
    if SORT_COLUMN == nil then SORT_COLUMN = 1 end
    
    -- Function to generate a string of specified length
    local genstring = function(LEN)
        local str = ""
        for a=1, LEN do
            str = str .. " "
        end
        return str
    end
    
    -- Holds our table of class members
    local dumpTable = {}
    
    -- Walk the class and its parents obtaining members
    local targetClass = CLASS
    while targetClass ~= nil do
        for key, value in pairs(targetClass.__imp__.members) do
            table.insert(dumpTable, {
                tostring(key),
                targetClass.__imp__.members[key].member_scope_get,
                targetClass.__imp__.members[key].member_scope_set,
                targetClass.__imp__.members[key].member_type,
                targetClass.__imp__.members[key].value_type,
                tostring(targetClass.__imp__.members[key].value_default),
                tostring(upperclass:getClassMemberValue(targetClass, key)),
                tostring(targetClass.__imp__.name),
            })
        end
        
        if targetClass.__parent__ ~= nil then
            targetClass = targetClass.__parent__
        else
            targetClass = nil
        end
    end
    
    -- Replace values in dumptable with friendly names
    for a=1, #dumpTable do
        for b=1, #dumpTable[a] do
            if dumpTable[a][b] == upperclass.MEMBER_TYPE_METHOD then
                dumpTable[a][b] = "method"
            elseif dumpTable[a][b] == upperclass.MEMBER_TYPE_PROPERTY then
                dumpTable[a][b] = "property"
            elseif dumpTable[a][b] == upperclass.SCOPE_PUBLIC then
                dumpTable[a][b] = "public"
            elseif dumpTable[a][b] == upperclass.SCOPE_PRIVATE then
                dumpTable[a][b] = "private"
            elseif dumpTable[a][b] == upperclass.SCOPE_PROTECTED then
                dumpTable[a][b] = "protected"
            elseif dumpTable[a][b] == upperclass.SCOPE_NOBODY then
                dumpTable[a][b] = "nobody"
            elseif dumpTable[a][b] == upperclass.TYPE_STRING then
                dumpTable[a][b] = "string"
            elseif dumpTable[a][b] == upperclass.TYPE_NUMBER then
                dumpTable[a][b] = "number"
            elseif dumpTable[a][b] == upperclass.TYPE_TABLE then
                dumpTable[a][b] = "table"
            elseif dumpTable[a][b] == upperclass.TYPE_BOOLEAN then
                dumpTable[a][b] = "boolean"
            elseif dumpTable[a][b] == upperclass.TYPE_FUNCTION then
                dumpTable[a][b] = "function"
            elseif dumpTable[a][b] == upperclass.TYPE_NIL then
                dumpTable[a][b] = "nil"
            elseif dumpTable[a][b] == upperclass.TYPE_ANY then
                dumpTable[a][b] = "any"            
            end
        end        
    end
    
    -- Determine the longest key for each column    
    local dumpTableColumnSpacing = {0, 0, 0, 0, 0, 0, 0, 0}
    
    -- Our header row
    local header = {"MEMBER_NAME", "MEMBER_SCOPE_GET", "MEMBER_SCOPE_SET", "MEMBER_TYPE", "MEMBER_VALUE_TYPE", "MEMBER_VALUE_DEFAULT", "MEMBER_VALUE_CURRENT", "MEMBER_CLASS_IMPL"}    
    for a=1, #header do
        if header[a]:len() > dumpTableColumnSpacing[a] then
            dumpTableColumnSpacing[a] = header[a]:len()
        end
    end
    
    -- Set the longest key value per column
    for a=1, #dumpTable do       
        for b=1, #dumpTable[a] do            
            if tostring(dumpTable[a][b]):len() > dumpTableColumnSpacing[b] then
                dumpTableColumnSpacing[b] = tostring(dumpTable[a][b]):len() or 0
            end
        end
    end
    
    -- Update the dumpTable values with appropriate spacing
    local dumpTableSpaced = {}
    for a=1, #dumpTable do
        for b=1, #dumpTable[a] do            
            dumpTable[a][b] = tostring(dumpTable[a][b]) .. genstring(dumpTableColumnSpacing[b] + 2 - tostring(dumpTable[a][b]):len())             
        end
    end
    
    -- Update the header values with appropriate spacing
    for a=1, #header do
        header[a] = header[a] .. genstring(dumpTableColumnSpacing[a] + 2 - header[a]:len())
    end
    print(unpack(header))
    
    -- Sort our table
    table.sort(dumpTable, function(A, B)
        return A[SORT_COLUMN] < B[SORT_COLUMN]            
    end)

    -- Print our dump table
    for a=1, #dumpTable do        
       print(unpack(dumpTable[a]))
    end
    
    -- Print additional spacing
    print("-= MEMBER DUMP END =- ")  
    print(" ")
end

--
-- Returns a class member
--
function upperclass:getClassMember(CLASS, KEY)
    if rawget(CLASS, '__imp__').members[KEY] ~= nil then
        return rawget(CLASS, '__imp__').members[KEY]
    elseif rawget(CLASS, '__parent__') ~= nil then
        return upperclass:getClassMember(rawget(CLASS, '__parent__'), KEY)    
    end
end

--
-- Returns all class members, searching through all parents
--
function upperclass:getClassMembers(CLASS, RECURSE)
    local targetClass = CLASS
    local members = {}
    
    if RECURSE == nil then
        RECURSE = false
    end
    
    while targetClass ~= nil do
        for key, value in pairs(targetClass.__imp__.members) do
            table.insert(members, targetClass.__imp__.members[key])
        end
        
        if RECURSE == true then
            if targetClass.__parent__ ~= nil then
                targetClass = targetClass.__parent__
            else
                targetClass = nil
            end
        else
            targetClass = nil
        end
    end

    return members
end

--
-- Atempts to obtain a class member value
--
function upperclass:getClassMemberValue(CLASS, KEY)
    if rawget(CLASS, '__inst__').memberValueOverrides[KEY] ~= nil then
        return rawget(CLASS, '__inst__').memberValueOverrides[KEY].value
    elseif rawget(CLASS, '__imp__').members[KEY] ~= nil then        
        return rawget(CLASS, '__imp__').members[KEY].value_default        
    elseif rawget(CLASS, '__parent__') ~= nil then
        return upperclass:getClassMemberValue(rawget(CLASS, '__parent__'), KEY)
    end
end

--
-- Attempts to locate a supplied value's type table
--
function upperclass:getTypeTableFromValue(VALUE)
    if type(VALUE) == 'string' then
        return upperclass.TYPE_STRING
        
    elseif type(VALUE) == 'boolean' then
        return upperclass.TYPE_BOOLEAN
        
    elseif type(VALUE) == 'number' then
        return upperclass.TYPE_NUMBER
        
    elseif type(VALUE) == 'function' then
        return upperclass.TYPE_FUNCTION
        
    elseif type(VALUE) == 'userdata' then
        return upperclass.TYPE_USERDATA
        
    elseif type(VALUE) == nil then
        return upperclass.TYPE_NIL
        
    elseif type(VALUE) == 'table' and rawget(VALUE, "__imp__") == nil then
        return upperclass.TYPE_TABLE
        
    elseif type(VALUE) == 'table' and rawget(VALUE, "__imp__") ~= nil then
        return upperclass.TYPE_CLASS
    else
        return upperclass.TYPE_ANY
    end
end

--
-- Attempts to locate a supplied string's type table
--
function upperclass:getTypeTableFromString(STRING)
    if STRING == 'string' then
        return upperclass.TYPE_STRING
        
    elseif STRING == 'table' then
        return upperclass.TYPE_TABLE
        
    elseif STRING == 'function' then
        return upperclass.TYPE_FUNCTION
    
    elseif STRING == 'number' then
        return upperclass.TYPE_NUMBER
    
    elseif STRING == 'boolean' then
        return upperclass.TYPE_BOOLEAN
        
    elseif STRING == 'userdata' then
        return upperclass.TYPE_USERDATA
        
    elseif STRING == 'nil' then
        return upperclass.TYPE_NIL
        
    elseif rawget(loadfile(STRING)(), "__imp__") ~= nil then
        return upperclass.TYPE_CLASS
        
    end
end

--
-- Attempts to locate a scope table from string
--
function upperclass:getScopeTableFromString(STRING)
    if STRING == 'public' then
        return upperclass.SCOPE_PUBLIC
        
    elseif STRING == 'private' then
        return upperclass.SCOPE_PRIVATE
        
    elseif STRING == 'protected' then
        return upperclass.SCOPE_PROTECTED
        
    elseif STRING == 'nobody' then
        return upperclass.SCOPE_NOBODY
        
    else
        return upperclass.SCOPE_PUBLIC
    end
end

--
-- Attempts to locate member type table from value
--
function upperclass:getMemberTypeTableFromValue(VALUE)
    if type(VALUE) == "function" then 
        return upperclass.MEMBER_TYPE_METHOD
    else 
        return upperclass.MEMBER_TYPE_PROPERTY 
    end
end

--
-- Upperclass Define function.
--
function upperclass:define(CLASS_NAME, PARENT)    
    local classdef = {}    
    
    -- Gracefully take over globals: public, private, protected, property
    -- we will set them back to orig values after definition
    classdef.public_orig_value     = rawget(_G, "public")    
    classdef.private_orig_value    = rawget(_G, "private")
    classdef.protected_orig_value  = rawget(_G, "protected")
    classdef.property_orig_value   = rawget(_G, "property")
    
    -- Create class implimentation table
    classdef.__imp__ = {
        name = tostring(CLASS_NAME),
        members = {}        
    }    
    
    -- Store the class file
    if debug ~= nil then
        classdef.__imp__.file = debug.getinfo(2, "S").source:sub(2)
    else
        classdef.__imp__.file = nil
    end
    
    -- Create tables to hold instance values
    classdef.__inst__ = {        
        isClassInstance         = false,
        memberValueOverrides    = {},
        permitMetamethodCalls   = true,       
    }        
  
    -- Create table to hold reference to our parent class, if specified
    classdef.__parent__ = PARENT or nil
  
    -- During the definition stage, the user may place property and method definitions in the following tables
    rawset(_G, "public",    {})
    rawset(_G, "private",   {})
    rawset(_G, "protected", {})
    rawset(_G, "property",  {})   
    
    -- Set our metatables. 
    setmetatable(classdef,  ClassDefinitionMetatable)
    setmetatable(public,    ClassDefinitionMetatable)
    setmetatable(private,   ClassDefinitionMetatable)
    setmetatable(protected, ClassDefinitionMetatable)    
    setmetatable(property,  ClassDefinitionMetatable)
  
    -- The ClassDefinitionMetatable will need a reference to the ClassDefinitionTable
    ClassDefinitionMetatable.classDefinitionTable = classdef
  
    return classdef
end

--
-- Upperclass Compile Function
--
function upperclass:compile(CLASS)      
    -- Return our stolen globals to original state
    rawset(_G, "public",    CLASS.public_orig_value)
    rawset(_G, "private",   CLASS.private_orig_value)
    rawset(_G, "protected", CLASS.protected_orig_value)
    rawset(_G, "property",  CLASS.property_orig_value)
    
    setmetatable(CLASS, nil)
    
    -- If __construct was not defined, define it now
    if CLASS.__imp__.members["__construct"] == nil then        
        CLASS.__imp__.members["__construct"] = {
            member_scope_get = upperclass.SCOPE_PRIVATE,                    
            member_scope_set = upperclass.SCOPE_NOBODY,                    
            member_type = upperclass.MEMBER_TYPE_METHOD,
            value_type = upperclass.TYPE_FUNCTION,
            value_default = function() end,            
        }
    end
    
    -- Define __constructparent() method
    CLASS.__imp__.members["__constructparent"] = {
        member_scope_get = upperclass.SCOPE_PRIVATE,
        member_scope_set = upperclass.SCOPE_NOBODY,
        member_type = upperclass.MEMBER_TYPE_METHOD,
        value_type = upperclass.TYPE_FUNCTION,
        value_default = function(self, ...)            
            local constructArgs = {...}
            if self.__parent__.__inst__.isClassInstance == false then
                self.__parent__ = self.__parent__(unpack(constructArgs))
            end
        end,
    }
    
    -- Set the class's metatable to ClassRuntimeMetatable
    setmetatable(CLASS, ClassRuntimeMetatable)
    
    return CLASS
end

--
-- ClassDefinitionMetatable __call method
--
function ClassDefinitionMetatable.__call(...)
    local tables = {...}
        
    -- Get our implimentation table
    local imp = rawget(ClassDefinitionMetatable.classDefinitionTable, "__imp__")
    
    -- Get our implimentation members table
    local members = rawget(imp, "members")
    
    -- Get our property definition values
    local propertyTable         = tables[3]
    local propertyGetterValue   = propertyTable.get
    local propertySetterValue   = propertyTable.set
    local propertyTypeValue     = propertyTable.type
    local propertyDefaultValue  = propertyTable[1]
    
    -- Holds our last property name
    local lastpropertyname = ClassDefinitionMetatable.last_property_name
    
    -- If property table length is 0, then set member values to defaults
    local proptablelen = 0
    
    -- Determine the number of property items    
    for key, value in pairs(propertyTable) do proptablelen = proptablelen +1 end
    
    -- Set to defaults if no definition items supplied
    if proptablelen == 0 then
        members[lastpropertyname].member_scope_get = upperclass.SCOPE_PUBLIC
        members[lastpropertyname].member_scope_set = upperclass.SCOPE_PUBLIC
        members[lastpropertyname].value_type = upperclass.TYPE_ANY
        members[lastpropertyname].value_default = nil            
    
    -- Determine value type & value        
    else 
        if propertyTypeValue == 'any' then
            members[lastpropertyname].value_type = upperclass.TYPE_ANY
            members[lastpropertyname].value_default = propertyDefaultValue            
        elseif propertyTypeValue == nil and propertyDefaultValue ~= nil then
            members[lastpropertyname].value_type = upperclass:getTypeTableFromValue(propertyDefaultValue)            
            members[lastpropertyname].value_default = propertyDefaultValue            
        elseif propertyTypeValue ~= nil and propertyDefaultValue == nil then            
            members[lastpropertyname].value_type = upperclass:getTypeTableFromString(propertyTypeValue)         
            members[lastpropertyname].value_default = nil
        elseif propertyTypeValue ~= nil and propertyDefaultValue ~= nil then            
            if type(propertyTypeValue) == 'string' and upperclass:getTypeTableFromString(propertyTypeValue) == upperclass:getTypeTableFromValue(propertyDefaultValue) then
                members[lastpropertyname].value_type = upperclass:getTypeTableFromString(propertyTypeValue)
                
            elseif type(propertyTypeValue) == 'table' and upperclass:getTypeTableFromValue(propertyTypeValue) == upperclass:getTypeTableFromValue(propertyDefaultValue) then
                members[lastpropertyname].value_type = upperclass:getTypeTableFromValue(propertyDefaultValue)            
                
            elseif type(propertyTypeValue) == 'string' and upperclass:getTypeTableFromString(propertyTypeValue) ~= upperclass:getTypeTableFromValue(propertyDefaultValue) then
                upperclass:throw(upperclass.D_INVALID_PROPERTY_TYPE_ASSIGNMENT, lastpropertyname, tostring(propertyTypeValue), tostring(type(propertyDefaultValue)))              
                
            elseif type(propertyTypeValue) == 'table' and upperclass:getTypeTableFromValue(propertyTypeValue) ~= upperclass:getTypeTableFromValue(propertyDefaultValue) then
                upperclass:throw(upperclass.D_INVALID_PROPERTY_TYPE_ASSIGNMENT, lastpropertyname, upperclass:getTypeTableFromValue(propertyTypeValue).string, tostring(type(propertyDefaultValue)))              
                
            end
            
            members[lastpropertyname].value_default = propertyDefaultValue
        elseif propertyTypeValue == nil and propertyDefaultValue == nil then
            members[lastpropertyname].value_type = upperclass.TYPE_ANY
            members[lastpropertyname].value_default = propertyDefaultValue        
        else
            upperclass:throw(upperclass.D_INVALID_PROPERTY_TYPE_ASSIGNMENT, lastpropertyname, tostring(propertyTypeValue), tostring(type(propertyDefaultValue)))                                        
        end            
        
        -- Determine getter scope
        members[lastpropertyname].member_scope_get = upperclass:getScopeTableFromString(propertyGetterValue)        
        
        -- Determine setter scope
        members[lastpropertyname].member_scope_set = upperclass:getScopeTableFromString(propertySetterValue)        
    end
end

--
-- ClassDefinitionMetatable __index method
--
function ClassDefinitionMetatable:__index(KEY)
    -- Check what kind of index we are retreiving. If requesting table is 'property'
    -- we must create a skeleton member entry with the requested key for later use 
    -- in the __call metamethod.
    if self == property then
        -- Get our implimentation table
        local imp = rawget(ClassDefinitionMetatable.classDefinitionTable, "__imp__")
        
        -- Get our implimentation members table
        local members = rawget(imp, "members")
         
        -- Ensure we are not redefining an existing member
        if members[KEY] ~= nil then            
            upperclass:throw(upperclass.D_INVALID_EXISTING_MEMBER_ASSIGNMENT, tostring(KEY), tostring(imp.name))            
        end
         
        -- Setup our member property table with defaults that will be later thrown away
        -- in the __call metamethod
        members[KEY] = {
            member_scope_get    = upperclass.SCOPE_NOBODY,                
            member_scope_set    = upperclass.SCOPE_NOBODY, 
            member_type         = upperclass.MEMBER_TYPE_PROPERTY,
            value_type          = upperclass.TYPE_NIL,
            value_default       = nil,                
        }    
            
        -- Set the last property name being defined for use in the __call metamethod
        ClassDefinitionMetatable.last_property_name = KEY
           
        return property
    else
        return rawget(self, KEY)
    end
end

--
-- ClassDefinitionMetatable __newindex
--
function ClassDefinitionMetatable.__newindex(TABLE, KEY, VALUE)
    -- Get our implimentation table
    local imp = rawget(ClassDefinitionMetatable.classDefinitionTable, "__imp__")
        
    -- Get our implimentation members table
    local members = rawget(imp, "members")
        
    -- Ensure we are not redefining an existing member
    if members[KEY] ~= nil then
        error("Attempt to redefine existing member '"..KEY.."' in class '"..imp.name.."' is disallowed")                
    end
                
    -- Create our members based on type and scope
    members[KEY] = {
        member_scope_get    = upperclass.SCOPE_NOBODY,                
        member_scope_set    = upperclass.SCOPE_NOBODY, 
        member_type         = upperclass:getMemberTypeTableFromValue(VALUE),
        value_type          = upperclass:getTypeTableFromValue(VALUE),
        value_default       = VALUE                      
    }
    
    -- Determine member scopes
    if TABLE == rawget(_G, "public") then
        members[KEY].member_scope_get = upperclass.SCOPE_PUBLIC
        members[KEY].member_scope_set = upperclass.SCOPE_PUBLIC                 
    elseif TABLE == rawget(_G, "private") then
        members[KEY].member_scope_get = upperclass.SCOPE_PRIVATE
        members[KEY].member_scope_set = upperclass.SCOPE_PRIVATE   
    elseif TABLE == rawget(_G, "protected") then
        members[KEY].member_scope_get = upperclass.SCOPE_PROTECTED
        members[KEY].member_scope_set = upperclass.SCOPE_PROTECTED           
    end
        
    -- If we are defining a function, set setter scope to nobody as you cannot redefine functions at runtime
    if type(VALUE) == "function" then
        members[KEY].member_scope_set = upperclass.SCOPE_NOBODY
    end
end

--
-- ClassRuntimeMetatable __call method
--
function ClassRuntimeMetatable:__call(...)
    -- Pack args
    local arguments = {...}
            
    -- Define instance table to return
    local instance = {}
            
    -- Setup reference to class implimentation
    instance.__imp__ = rawget(self, '__imp__')
            
    -- Setup table to hold instance implimentation
    instance.__inst__ = {
        isClassInstance = true,
        memberValueOverrides = {},
        permitMetamethodCalls = true
    }
        
    -- Set parent reference
    instance.__parent__ = rawget(self, '__parent__')
    
    -- Activate the instance by setting its metatable
    setmetatable(instance, ClassRuntimeMetatable)
            
    -- Call class constructor
    local __construct = rawget(self, '__imp__').members["__construct"].value_default
    __construct(instance, unpack(arguments, 1, table.maxn(arguments)))
     
    -- Construct parent if it was not constructed by class constructor
    if rawget(instance, '__parent__') ~= nil and rawget(instance, '__parent__').__inst__.isClassInstance == false then                         
        instance.__parent__ = rawget(self, '__parent__')()
    end
        
    return instance   
end

--
-- ClassRuntimeMetatable __index method
--
function ClassRuntimeMetatable:__index(KEY)
    -- Ensure we return some important keys.
    if KEY == "__imp__" or KEY == "__inst__" or KEY == "__parent__" then
        return rawget(self, KEY)
    end
        
    -- Attempt to locate a user defined __index member and call it
    if KEY ~= '__index' and rawget(self, '__inst__').permitMetamethodCalls == true and upperclass:getClassMember(self, '__index') ~= nil then        
        -- We must set permitMetamethodCalls to false to stop recursive behavior
        rawget(self, '__inst__').permitMetamethodCalls = false            
            
        -- Call the __index user defined member
        local indexMetamethodMemberRetVal = upperclass:getClassMember(self, '__index').value_default(self, KEY)            
            
        -- Reenable permitMetamethodCalls
        rawget(self, '__inst__').permitMetamethodCalls = true            
        
        if indexMetamethodMemberRetVal ~= upperclass.DEFAULT_BEHAVIOR then
            return indexMetamethodMemberRetVal
        end        
    end
    
    -- get our target member
    local targetMember = upperclass:getClassMember(self, KEY)
        
    -- Halt if our target member is nil
    if targetMember == nil then
        upperclass:throw(upperclass.R_INVALID_MEMBER_LOOKUP, tostring(KEY), tostring(rawget(self, '__imp__').name))        
    end
    
    --[[
        ANY LOGIC PAST THIS POINT ASSUMES A VALID MEMBER LOOKUP
    --]]
        
    -- Return members based on scope
    if debug == nil or targetMember.member_scope_get == upperclass.SCOPE_PUBLIC then        
        return upperclass:getClassMemberValue(self, KEY)
    elseif targetMember.member_scope_get == upperclass.SCOPE_PRIVATE then
        local caller = debug.getinfo(2, 'f').func            
        local members = upperclass:getClassMembers(self, false)
        for a=1, #members do                
            if caller == members[a].value_default then                                
                return upperclass:getClassMemberValue(self, KEY)
            end
        end
        upperclass:throw(upperclass.R_INVALID_SCOPE_ACCESS, 'private', tostring(KEY), tostring(rawget(self, '__imp__').name))        
    elseif targetMember.member_scope_get == upperclass.SCOPE_PROTECTED then
        local caller = debug.getinfo(2, 'f').func            
        local members = upperclass:getClassMembers(self, true)        
        for a=1, #members do                        
            if caller == members[a].value_default then                                  
                return upperclass:getClassMemberValue(self, KEY)
            end
        end          
        upperclass:throw(upperclass.R_INVALID_SCOPE_ACCESS, 'protected', tostring(KEY), tostring(rawget(self, '__imp__').name))        
    end
end

--
-- ClassRuntimeMetatable __newindex method
--
function ClassRuntimeMetatable:__newindex(KEY, VALUE)    
    -- Ensure we do not attempt to overwrite important keys
    if KEY == "__imp__" or KEY == "__inst__" or KEY == "__parent__" then
        upperclass:throw(upperclass.R_INVALID_MEMBER_ASSIGNMENT, 'internal', tostring(KEY), tostring(rawget(self, '__imp__').name))       
    end
    
    -- Attempt to locate a user defined __newindex member and call it
    if KEY ~= '__newindex' and rawget(self, '__inst__').permitMetamethodCalls == true and upperclass:getClassMember(self, '__newindex') ~= nil then        
        -- We must set permitMetamethodCalls to false to stop recursive behavior
        rawget(self, '__inst__').permitMetamethodCalls = false            
            
        -- Call the __index user defined member
        local newindexMetamethodMemberRetVal = upperclass:getClassMember(self, '__newindex').value_default(self, KEY, VALUE)            
            
        -- Reenable permitMetamethodCalls
        rawget(self, '__inst__').permitMetamethodCalls = true            
            
        if newindexMetamethodMemberRetVal ~= upperclass.DEFAULT_BEHAVIOR then
            return newindexMetamethodMemberRetVal
        end        
    end
    
    -- Attempt to locate a target member
    local targetMember = upperclass:getClassMember(self, KEY)
    
    -- Halt if our target member is nil
    if targetMember == nil then
        upperclass:throw(upperclass.R_INVALID_MEMBER_LOOKUP, tostring(KEY), tostring(rawget(self, '__imp__').name))        
    end
    
    -- Halt if our target member is a method
    if targetMember.member_type == upperclass.MEMBER_TYPE_METHOD then
        upperclass:throw(upperclass.R_INVALID_MEMBER_ASSIGNMENT, 'method', tostring(KEY), tostring(rawget(self, '__imp__').name))        
    end
    
    --[[
        ANY LOGIC PAST THIS POINT ASSUMES A VALID MEMBER LOOKUP
    --]]
        
    -- Holds a boolean determining if our scope is proper
    local scopePermitted = false
    
    -- Holds a boolean determining if edit is allowed
    local editPermitted = false
    
    -- Conduct scope check
    if debug == nil or targetMember.member_scope_set == upperclass.SCOPE_PUBLIC then
        scopePermitted = true        
    elseif targetMember.member_scope_set == upperclass.SCOPE_PRIVATE then                 
        local caller = debug.getinfo(2, 'f').func            
        local members = upperclass:getClassMembers(self, false)
        for a=1, #members do                
            if caller == members[a].value_default then                                        
                scopePermitted = true
            end
        end
        if scopePermitted == false then
            upperclass:throw(upperclass.R_INVALID_MEMBER_SCOPED_ASSIGNMENT, 'private', tostring(KEY), tostring(rawget(self, '__imp__').name))            
        end
    elseif targetMember.member_scope_set == upperclass.SCOPE_PROTECTED then
        local caller = debug.getinfo(2, 'f').func            
        local members = upperclass:getClassMembers(self, true)
        for a=1, #members do                
            if caller == members[a].value_default then                    
                scopePermitted = true
            end
        end         
        if scopePermitted == false then
            upperclass:throw(upperclass.R_INVALID_MEMBER_SCOPED_ASSIGNMENT, 'protected', tostring(KEY), tostring(rawget(self, '__imp__').name))            
        end
    end
    
    -- Conduct edit allowed check
    if targetMember.value_type == upperclass.TYPE_ANY then
        editPermitted = true
    elseif targetMember.value_type.string == type(VALUE) then
        editPermitted = true    
    else
        upperclass:throw(
            upperclass.R_INVALID_MEMBER_TYPE_ASSIGNMENT,  
            targetMember.member_scope_set.string, 
            tostring(KEY), 
            targetMember.value_type.string, 
            tostring(type(VALUE)), 
            tostring(rawget(self, '__imp__').name)
        )        
    end
    
    -- Conduct edit
    if editPermitted == true then
        rawget(self, '__inst__').memberValueOverrides[KEY] = {value=VALUE}
    end
end


--
-- ClassRuntimeMetatable __tostring method
--
function ClassRuntimeMetatable:__tostring()
    local member = upperclass:getClassMember(self, '__tostring')
    if member ~= nil then
        local tostringMetamethodRetVal = member.value_default(self)        
        if tostringMetamethodRetVal == upperclass.DEFAULT_BEHAVIOR then
            return "class "..rawget(self, '__imp__').name.." ("..tostring(self.__inst__)..")"
        else
            return tostringMetamethodRetVal
        end
    else
        return "class "..rawget(self, '__imp__').name.." ("..tostring(self.__inst__)..")"
    end
end

--
-- ClassRuntimeMetatable __add method
--
function ClassRuntimeMetatable:__add(RIGHT)
    local member = upperclass:getClassMember(self, '__add')
    if member ~= nil then
        return member.value_default(self, RIGHT)
    else        
        upperclass:throw(upperclass.R_INVALID_METAMETHOD_LOOKUP, '__add', tostring(rawget(self, '__imp__').name))
    end
end

--
-- ClassRuntimeMetatable __sub method
--
function ClassRuntimeMetatable:__sub(RIGHT)
    local member = upperclass:getClassMember(self, '__sub')
    if member ~= nil then
        return member.value_default(self, RIGHT)
    else
        upperclass:throw(upperclass.R_INVALID_METAMETHOD_LOOKUP, '__sub', tostring(rawget(self, '__imp__').name))
    end
end

--
-- ClassRuntimeMetatable __unm method
--
function ClassRuntimeMetatable:__unm()
    local member = upperclass:getClassMember(self, '__unm')
    if member ~= nil then
        return member.value_default(self)
    else
        upperclass:throw(upperclass.R_INVALID_METAMETHOD_LOOKUP, '__unm', tostring(rawget(self, '__imp__').name))
    end
end

--
-- ClassRuntimeMetatable __concat method
--
function ClassRuntimeMetatable:__concat(RIGHT)
    local member = upperclass:getClassMember(self, '__concat')
    if member ~= nil then
        return member.value_default(self, RIGHT)
    else
        upperclass:throw(upperclass.R_INVALID_METAMETHOD_LOOKUP, '__concat', tostring(rawget(self, '__imp__').name))
    end
end

--
-- ClassRuntimeMetatable __mul method
--
function ClassRuntimeMetatable:__mul(RIGHT)
    local member = upperclass:getClassMember(self, '__mul')
    if member ~= nil then
        return member.value_default(self, RIGHT)
    else
        upperclass:throw(upperclass.R_INVALID_METAMETHOD_LOOKUP, '__mul', tostring(rawget(self, '__imp__').name))
    end
end

--
-- ClassRuntimeMetatable __div method
--
function ClassRuntimeMetatable:__div(RIGHT)
    local member = upperclass:getClassMember(self, '__div')
    if member ~= nil then
        return membervalue_default(self, RIGHT)
    else
        upperclass:throw(upperclass.R_INVALID_METAMETHOD_LOOKUP, '__div', tostring(rawget(self, '__imp__').name))
    end
end

--
-- ClassRuntimeMetatable __mod method
--
function ClassRuntimeMetatable:__mod(RIGHT)
    local member = upperclass:getClassMember(self, '__mod')
    if member ~= nil then
        return member.value_default(self, RIGHT)
    else
        upperclass:throw(upperclass.R_INVALID_METAMETHOD_LOOKUP, '__mod', tostring(rawget(self, '__imp__').name))
    end
end

--
-- ClassRuntimeMetatable __pow method
--
function ClassRuntimeMetatable:__pow(RIGHT)
    local member = upperclass:getClassMember(self, '__pow')
    if member ~= nil then
        return member.value_default(self, RIGHT)
    else
        upperclass:throw(upperclass.R_INVALID_METAMETHOD_LOOKUP, '__pow', tostring(rawget(self, '__imp__').name))
    end
end

--
-- ClassRuntimeMetatable __eq method
--
function ClassRuntimeMetatable:__eq(RIGHT)
    local member = upperclass:getClassMember(self, '__eq')
    if member ~= nil then
        return member.value_default(self, RIGHT)
    else
        local comp = false
        local mt = getmetatable(self)
        setmetatable(self, nil)        
        if self == RIGHT then comp = true end
        setmetatable(self, mt)
        return comp
    end
end

--
-- ClassRuntimeMetatable __lt method
--
function ClassRuntimeMetatable:__lt(RIGHT)
    local member = upperclass:getClassMember(self, '__lt')
    if member ~= nil then
        return member.value_default(self, RIGHT)
    else
        upperclass:throw(upperclass.R_INVALID_METAMETHOD_LOOKUP, '__lt', tostring(rawget(self, '__imp__').name))
    end
end

--
-- ClassRuntimeMetatable __le method
--
function ClassRuntimeMetatable:__le(RIGHT)
    local member = upperclass:getClassMember(self, '__le')
    if member ~= nil then
        return member.value_default(self, RIGHT)
    else
        upperclass:throw(upperclass.R_INVALID_METAMETHOD_LOOKUP, '__le', tostring(rawget(self, '__imp__').name))
    end
end

--
-- ClassRuntimeMetatable __gc method
--
--[[function ClassRuntimeMetatable:__gc()
    local member = upperclass:getClassMember(self, '__gc')
    if member ~= nil then
        return member.value_default(self, RIGHT)
    else
        upperclass:throw(upperclass.R_INVALID_METAMETHOD_LOOKUP, '__gc', tostring(rawget(self, '__imp__').name))
    end
end]]

--
-- ClassRuntimeMetatable __len method
--
function ClassRuntimeMetatable:__len()
    local member = upperclass:getClassMember(self, '__len')
    if member ~= nil then
        return member.value_default(self, RIGHT)
    else
        upperclass:throw(upperclass.R_INVALID_METAMETHOD_LOOKUP, '__len', tostring(rawget(self, '__imp__').name))
    end
end

--
-- Return upperclass
--
return upperclass