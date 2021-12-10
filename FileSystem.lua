require("lfs")

function mixArray(tab1,tab2)
    for n,cont in pairs(tab2) do
        tab1[#tab1+1] = cont
    end
    return tab1
end
function split(str,reps)
    local result = {}
    string.gsub(str,'[^'..reps..']+',function (n)
        table.insert(result,n)
    end)
    return result
end
function fixPath(path)
    local a = string.reverse(path)
    if string.find(a,'\\')==1 then
        return string.sub(path,1,string.len(path)-1)
    end
    return path
end

FileSystem = { _VERSION = 100 }
function FileSystem.getCurrentPath() -- rtn: <string> C:\example\ 
    return lfs.currentdir()..'\\'
end
function FileSystem.getDirectoryList(path) -- var: <string:path> C:\example\
    local list = {}
    for file in lfs.dir(path) do
        if file~='.' and file~='..' then
            list[#list+1] = path..file
            local attr = lfs.attributes(fixPath(path))
            if attr~=nil and attr.mode=='directory' then
                list = mixArray(list,FileSystem.getDirectoryList(path..file..'\\'))
            end
        end
    end
    return list
end
function FileSystem.writeTo(path,content) -- var: <string:path> C:\example\a.txt <table/string:content> <bool:isBinary>
	local file = assert(io.open(path, "wb"))
	file:write(content)
	file:close()
end
function FileSystem.readFrom(path) -- var: <string:path> C:\example\a.txt
    local file = assert(io.open(path, "rb"))
    local content = file:read("*all")
    file:close()
    return content
end
function FileSystem.mkdir(path) -- var: <string:path> C:\example\
    if string.find(path,'\\')==nil then
        return lfs.mkdir(path)
    else
        local ms = split(path,'\\')
        table.remove(ms,1) -- rm first "\"
        local npath = ""
        for i,path_t in pairs(ms) do
            npath = npath..'\\'..path_t
            lfs.mkdir(npath)
        end
    end
    
end
function FileSystem.rmdir(path) -- var: <string:path> C:\example\
    return lfs.rmdir(path)
end
function FileSystem.getFileSize(path) -- var: <string:path> C:\example\a.txt
    local attr = lfs.attributes(path)
    return attr.size
end
function FileSystem.getType(path)
    local attr = lfs.attributes(path)
    return attr.mode
end
function FileSystem.isExist(path)
    local attr = lfs.attributes(fixPath(path))
    return attr ~= nil
end
function FileSystem.isSame(path1,path2)
    local a = FileSystem.readFrom(path1)
    local b = FileSystem.readFrom(path2)
    return a == b
end
function FileSystem.copy(to_path,from_path)
    FileSystem.writeTo(to_path,FileSystem.readFrom(from_path))
end

return FileSystem