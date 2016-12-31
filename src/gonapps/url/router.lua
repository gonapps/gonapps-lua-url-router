local _M = {}
local regex = require "rex_pcre"
local urlDecoder = require "gonapps.url.decoder"
local Path = {}
Path.__index = Path

function Path.new(pattern, method, callback)
    local self = setmetatable({}, Path)
    self.regex = assert(regex.new(pattern))
    self.method = method
    self.callback = callback
    return self
end

function Path:match(pattern, method)
    if self.method == method then
        local _, _, result = self.regex:tfind(pattern)
        return result
    else
        return nil
    end
end

function _M.new()
    local self = setmetatable({}, {__index = _M})
    self.paths = {}
    return self
end

function _M:setCallback(pattern, method, callback)
    table.insert(self.paths, Path.new(pattern, method, callback))
end

function _M:route(request)
    local result
    for _, path in ipairs(self.paths) do
        result = path:match(request.pathInfo, request.method)
        if result ~= nil then
            for key, value in pairs(result) do
                if type(key) == "string" then
                    request.parameters[urlDecoder.rawDecode(key)] = urlDecoder.rawDecode(value)
                end
            end
            return path.callback(request)
        end
    end
    return 404, {["Content-Type"] = "text/html; charset=utf8"}, "404 Not Found"
end

return _M
