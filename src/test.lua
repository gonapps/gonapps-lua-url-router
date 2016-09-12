local cubelua = require 'cubelua'
local router = cubelua.Router:new()
router:setCallback('/member/(?<number>\\d+)', 'GET', function(request) print(request.parameter['number']) end)
local request = {}
request.parameter = {}
request.pathInfo = '/member/1254'
request.method = 'GET'
router:route(request)
