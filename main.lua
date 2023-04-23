local rprint = rconsoleprint
local clear = rconsoleclear
local rname = rconsolename
local input = rconsoleinput

rname("Module editor - none")

local types = {
    ["function"] = "@@GREEN@@",
    ["string"] = "@@YELLOW@@",
    ["number"] = "@@BLUE@@",
    ["vector"] = "@@CYAN@@",
    ["userdata"] = "@@RED@@",
    ["boolean"] = "@@LIGHT_BLUE@@",
    ["table"] = "@@LIGHT_GREEN@@",
    ["nil"] = "@@LIGHT_RED@@",
    ["thread"] = "@@LIGHT_GRAY@@"
}

local path = nil

function getpath()
    rprint("Enter path: ")
    local inp = input()
    path = loadstring("return "..inp)()
    if path ~= nil then
        rname("Module editor - "..inp)
        rprint("\n")
        return path
    else    
        rprint("Invalid path!\n")
        getpath()
    end
end 

function list()
    local re = require(path)
    local values = {}
    rprint("\n------------------\n")
    if type(re) == "function" then
        for i,v in pairs(getsenv(re)) do 
            --values[tostring(i)] = v
            rprint("\n{\""..i.."\"} = ")
            rprint("("..type(v)..") "..types[type(v)])
            rprint(tostring(v))
            rprint("@@WHITE@@")
        end
    else 
        for i,v in pairs(re) do 
            --values[tostring(i)] = v
            rprint("\n{\""..i.."\"} = ")
            rprint(types[type(v)])
            rprint(tostring(v))
            rprint("@@WHITE@@")
        end
    end
    rprint("\n------------------\n")
    return values
end

local funcs = {
    ["edit"] = function(values)
        rprint("select index: ")
        local num = input()
            rprint("Enter type (string,number,boolean,nil): ")
            local val = input()
            rprint("Enter new value: ")
            local inputval = input()
            if val == "number" then
                inputval = tonumber(inputval)
            elseif val == "boolean" then 
                if inputval == "true" or inputval == "True" then 
                    inputval = true 
                else 
                    inputval = false 
                end
            elseif val == "nil" then 
                inputval = nil 
            end
            values[num] = inputval
        rprint("| edit | close | commit | save |\n")
        loop(values)
    end,
    ["close"] = function(values)
        start()
    end,
    ["commit"] = function(values)
        local p = require(path)
        print(p)
        if type(p) == "function" then
            for i,v in pairs(values) do 
                getsenv(p)[i] = v
            end
        else
            for i,v in pairs(values) do 
                p[i] = values[i]
            end
        end
        rprint("Commited!\n")
        rprint("| edit | close | commit | save |\n")
        loop(values)
    end,
    ["save"] = function(values)
        local out = "local module = require(game."..path:GetFullName()..")"
        for i,v in pairs(values) do 
            out = out.."\nmodule[\""..tostring(i).."\"] = "..tostring(v)..""
        end
        rprint("Save as: ")
        writefile(input(),out)
        rprint("Saved!\n")
        rprint("| edit | close | commit | save |\n")
        loop(values)
    end
}

function loop(values)
    local inp = input()
    if funcs[inp] ~= nil then
        funcs[inp](values)
    else
        rprint("Invalid value!\n")
    end
end

function start()
    clear()
    local path = getpath()
    local values = list(path)
    rprint("| edit | close | commit | save |\n")
    loop(values)
end

start()
