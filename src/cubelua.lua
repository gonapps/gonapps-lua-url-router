local _M = {}
local regex = require 'rex_pcre'

local Path = {}
Path.__index = Path

function Path.new(pattern, callback)
    local self = setmetatable({}, Path)
    self.regex = assert(regex.new(pattern))
    self.callback = callback
    return self
end

function Path:match(pattern)
    local _
    local result
    _, _, result = self.regex:tfind(pattern)
    return result
end

_M.Router = {}
_M.Router.__index = _M.Router

function _M.Router.new()
    local self = setmetatable({}, _M.Router)
    self.paths = {}
    return self
end

function _M.Router:setCallback(pattern, callback)
    table.insert(self.paths, Path.new(pattern, callback))
end

function _M.Router:route(request)
    local result
    for _, path in ipairs(self.paths) do
        result = path:match(request.pathInfo)
        if result ~= nil then
            for key, value in pairs(result) do
                if type(key) == 'string' then
                    request.parameter[key] = value
                end
            end
            path.callback(request)
            return true 
        end
    end
    return false
end

return _M
