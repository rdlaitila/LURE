--
-- Define Class
--
local utils = {}

--
-- Trims a string
--
function utils:trim(STRING)
    if STRING ~= nil then
        return STRING:match'^()%s*$' and '' or STRING:match'^%s*(.*%S)'
    end    
end

--
-- Generates a UUID
--
function utils:uuid()
    local chars = {"0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"}
    local uuid = {[9]="-",[14]="-",[15]="4",[19]="-",[24]="-"}
    local r, index
    for i = 1,36 do
        if(uuid[i]==nil)then
            -- r = 0 | Math.random()*16;
            r = math.random (16)
            if(i == 20 and BinDecHex)then 
                -- (r & 0x3) | 0x8
                index = tonumber(Hex2Dec(BMOr(BMAnd(Dec2Hex(r), Dec2Hex(3)), Dec2Hex(8))))
                if(index < 1 or index > 16)then 
                    print("WARNING Index-19:",index)
                    return UUID() -- should never happen - just try again if it does ;-)
                end
            else
                index = r
            end
            uuid[i] = chars[index]
        end
    end
    return table.concat(uuid)
end

--
-- Literalizes a string
--
function utils:literalize(STRING)
    text, occur =  STRING:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", function(c)        
        return "%" .. c 
    end)
    return self:trim(text)
end

--
-- Splits a string by delim
--
function utils:split(STRING, PATTERN)
    local t = {}  -- NOTE: use {n = 0} in Lua-5.0
    local fpat = "(.-)" .. PATTERN
    local last_end = 1
    local s, e, cap = STRING:find(fpat, 1)
    
    while s do
        if s ~= 1 or cap ~= "" then
            table.insert(t,cap)
        end
        last_end = e+1
        s, e, cap = STRING:find(fpat, last_end)
    end
    
    if last_end <= #STRING then
        cap = STRING:sub(last_end)
        table.insert(t, cap)
    end
    
    return t
end

--
-- Return class
--
return utils