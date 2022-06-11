--[[ ----------------------------------------

    [Deps] Lua File System.

--]] ----------------------------------------

require "native-type-helper"
local wf = require "winfile"

Fs = {}
local function directory(path)
    path = path .. '\\'
    path = string.gsub(path,'/','\\')
    path = string.gsub(path,'\\\\','\\')
    return path
end

function Fs:getCurrentPath()
    return directory(wf.currentdir())
end

function Fs:getDirectoryList(path)
    local list = {}
    path = path or self:getCurrentPath()
    path = directory(path)
    for file in wf.dir(path) do
        if file~='.' and file~='..' then
            local attr = wf.attributes(path..file)
            if attr and attr.mode=='directory' then
                list = Array.Concat(list,self:getDirectoryList(path..file..'\\'))
            end
            list[#list+1] = path..file
        end
    end
    return list
end

function Fs:writeTo(path,content)
	local file = assert(wf.open(path, "wb"))
	file:write(content)
	file:close()
    return true
end

function Fs:readFrom(path)
    local file = assert(wf.open(path, "rb"))
    local content = file:read("*all")
    file:close()
    return content
end

function Fs:mkdir(path)
    path = directory(path)
    local dirs = string.split(path,'\\')
    for k,v in pairs(dirs) do
        wf.mkdir(table.concat(dirs,'\\',1,k)..'\\')
    end
    return true
end

function Fs:rmdir(path,forceMode)
    local m = wf.rmdir(directory(path))
    if m then
       return true
    elseif forceMode then
        for a,tph in pairs(self:getDirectoryList(path)) do
            wf.remove(tph)
        end
        return self:rmdir(path)
    end
    return false
end

function Fs:getFileSize(path)
    return wf.attributes(path).size
end

function Fs:getType(path)
    return wf.attributes(path).mode
end

function Fs:isExist(path)
    return wf.attributes(path) ~= nil
end

function Fs:isSame(path1,path2)
    return Fs:readFrom(path1) == Fs:readFrom(path2)
end

function Fs:copy(to_path,from_path)
    Fs:writeTo(to_path,Fs:readFrom(from_path))
end

function Fs:remove(path)
    return wf.remove(path)
end

function Fs:open(path,mode)
    return wf.open(path,mode)
end

return Fs