function resolvePath(path, str)
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

function readFile(start, path)
    local pStr = resolvePath(start, path)
    local d = Systems[Terminal.ip].fs
    local p = { "/" }

    local exists = true
    for match in string.gmatch(pStr, "[^/]+") do
        if d[match] then
            d = d[match]
            p[#p + 1] = match
            p[#p + 1] = "/"
        else
            exists = false
            d[match] = { }
            d = d[match]
            p[#p + 1] = match
            p[#p + 1] = "/"
        end
    end

    p[#p] = nil

    if not exists or type(d) == "table" then return nil, p end
    return d, p
end

function getDirectory(start, path)
    local pStr = resolvePath(start, path)
    local d = Systems[Terminal.ip].fs
    local p = { "/" }

    for match in string.gmatch(pStr, "[^/]+") do
        if d[match] and type(d[match]) == "table" then
            d = d[match]
            p[#p + 1] = match
            p[#p + 1] = "/"
        else
            return nil
        end
    end
    return d, p
end

function getParentDirectory(path)
    return getDirectory("/", path .. "/..")
end

function getParentDirectoryPath(path)
    local index = string.find(path, "/[^/]+/?$") or 1
    return string.sub(path, 1, index)
end

function getFilename(start, path)
    local p = resolvePath(start, path)
    if p == "/" then return "" end
    local s, e = string.find(p, "[^/]+/$")
    if not s then s, e = string.find(p, "[^/]+$") else e = e - 1 end
    if not s then return nil end
    return string.sub(p, s, e)
end
