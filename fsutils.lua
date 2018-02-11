local function getParentDirectoryPath(path)
    local index = string.find(path, "/[^/]+/?$") or 1
    return string.sub(path, 1, index)
end

local function resolvePath(path, str)
    local res = "" .. path or ""
    local c = "" .. str or ""
    while #c > 0 do
        local n, m = string.find(c, "^/?[^/]+")
        if n == nil then break end

        local pSub = string.sub(c, n, m)
        if pSub == ".." then
            res = getParentDirectoryPath(res)
        else
            res = res .. (string.find(res, "/$") and "" or "/") .. pSub
        end
        c = string.sub(c, m + 2)
    end
    return res
end

local function fileExists(ip, start, path)
    local pStr = resolvePath(start, path)
    local d = Systems[ip].fs
    local p = { "/" }
    local exists = true
    for match in string.gmatch(pStr, "[^/]+") do
        if d[match] then
            d = d[match]
            p[#p + 1] = match
            p[#p + 1] = "/"
        else
            exists = false
            break
        end
    end
    return exists, d, p
end

function getFile(ip, start, path)
    local exists, d, p = fileExists(ip, start, path)
    if exists and (type(d) ~= "table") then return d, p
    else return nil end
end

function getDirectory(ip, start, path)
    local exists, d, p = fileExists(ip, start, path)
    if exists and type(d) == "table" then return d, p else return nil end
end

function getFileOrDirectory(ip, start, path)
    local exists, d, p = fileExists(ip, start, path)
    if not exists then return nil end
    if type(d) ~= "table" then p[#p] = nil end
    return d, p
end

function getFilename(start, path)
    local p = resolvePath(start, path)
    if p == "/" then return "" end
    local s, e = string.find(p, "[^/]+/$")
    if not s then s, e = string.find(p, "[^/]+$") else e = e - 1 end
    if not s then return nil end
    return string.sub(p, s, e)
end
