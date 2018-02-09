Stack = {}
function Stack.new()
    return { }
end

function Stack.push(s, value)
    if not s then error("no stack given") end
    if not value then error("no value given") end
    s[#s + 1] = value
end

function Stack.pop(s)
    if not s then error("no stack given") end
    if #s == 0 then error("stack is empty") end
    local value = s[#s]
    s[#s] = nil
    return value
end

function Stack.peek(s)
    if not s then error("no stack given") end
    if #s == 0 then error("stack is empty") end
    return s[#s]
end
