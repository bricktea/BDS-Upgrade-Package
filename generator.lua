package.path = package.path..';.\\share\\?.lua'
package.cpath = package.cpath..';.\\lib\\?.dll'

local fs = require('filesystem')
local version = {
    old = "1.18.33.02",
    new = "1.19.1.01"
}

PATH = { current = fs:getCurrentPath() }
PATH.old = PATH.current..'bedrock-server-'..version.old
PATH.new = PATH.current..'bedrock-server-'..version.new
PATH.output = PATH.current..'output\\'

--- Checks
if fs:isExist(PATH.new) then
    print('checking path('..version.new..') ...')
else
    error('something wrong when checking path('..version.new..').')
end
if fs:isExist(PATH.old) then
    print('checking path('..version.old..') ...')
else
    error('something wrong when checking path('..version.old..').')
end

--- Gen file list
print('creating file list ...')
local file_list = {
    new = fs:getDirectoryList(PATH.new),
    old = fs:getDirectoryList(PATH.old)
}

local path_lengths = {
    old = string.len(PATH.old) + 1,
    new = string.len(PATH.new) + 1
}
for i,v in pairs(file_list.new) do -- to relative
    file_list.new[i] = string.sub(v,path_lengths.new)
end
for i,v in pairs(file_list.old) do -- to relative
    file_list.old[i] = string.sub(v,path_lengths.old)
end

---- Compare all files
local need_pack_files = {}
local need_remove_files = {}

--- filename compare.
print('start to compare '..math.min(#file_list.new,#file_list.old)..' files ...')
function array_BuildOpposite(tab)
    local res = {}
    for i,v in pairs(tab) do
        res[v] = 0
    end
    return res
end
function array_TakeOut(new,old) -- get new and deleted.
    local result = { new={}, old={} }
    local ops = { new=array_BuildOpposite(new), old=array_BuildOpposite(old) }
    for n,cont in pairs(new) do -- new file
        if ops.old[cont]==nil then
            result.new[#result.new+1]=cont
        end
    end
    for n,cont in pairs(old) do -- deleted file
        if ops.new[cont]==nil then
            result.old[#result.old+1]=cont
        end
    end
    return result
end
function array_Plus(arr1,arr2)
    local res = {}
    for i,v in pairs(arr1) do
        res[#res+1] = v
    end
    for i,v in pairs(arr2) do
        res[#res+1] = v
    end
    return res
end
function array_Minus(arr,minus_this)
    local res = {}
    local a = array_BuildOpposite(minus_this)
    for i,v in pairs(arr) do
        if a[v]==nil then
            res[#res+1] = v
        end
    end
    return res
end
local res = array_TakeOut(file_list.new,file_list.old)
need_remove_files = res.old
print(version.new..' (File) -> '..#res.new..'++, '..#res.old..'--')

--- file content compare.
local need_compare_files = array_Minus(file_list.new,array_Plus(res.new,res.old))
print(version.new..' (Cont) -> comparing '..#need_compare_files..' files ...')
for i,filename in pairs(need_compare_files) do
    if (fs:getType(PATH.new..filename) ~= 'directory' and fs:getType(PATH.old..filename) ~= 'directory') and not(fs:isSame(PATH.new..filename,PATH.old..filename)) then
        need_pack_files[#need_pack_files+1] = filename
    end
end
print(version.new..' (Cont) -> '..#need_pack_files..' files changed.')

--- do output (copy)
function getPathByFile(filepath)
    local p = string.find(string.reverse(filepath),'\\')
    if p==nil then
        return ''
    end
    local loc = string.len(filepath) - p
    return string.sub(filepath,1,loc)
end
if not fs:isExist(PATH.output) then
    fs:mkdir(PATH.output)
end
for i,file in pairs(need_pack_files) do -- change
    local path = getPathByFile(file)
    if not fs:isExist(PATH.output..path) then
        fs:mkdir(PATH.output..path)
    end
    fs:copy(PATH.output..file,PATH.new..file)
end
for i,file in pairs(res.new) do -- new
    if fs:getType(PATH.new..file) ~= 'directory' then
        local path = getPathByFile(file)
        if not fs:isExist(PATH.output..path) then
            fs:mkdir(PATH.output..path)
        end
        fs:copy(PATH.output..file,PATH.new..file)
    end
end
if #need_remove_files~=0 then -- remove
    local bat_cont = "@echo off\n\n:: "..version.new.." removed files\n"
    for i,file in pairs(need_remove_files) do
        if fs:getType(PATH.old..file)~='directory' then
            bat_cont = bat_cont..'del '..file..'\n'
        else
            bat_cont = bat_cont..'rmdir '..file..' /s /q \n'
        end
    end
    bat_cont = bat_cont.."pause"
    fs:writeTo(PATH.output..'removeOldFiles.bat',bat_cont)
end

print('All works done.')