local cubelua = require "tucube.http.router" 
local router = cubelua.Router:new()
router:setCallback('/member/(?<number>\\d+)', 'GET', function(request) print(request.parameters['number']) end)
local request = {}
request.parameters = {}
request.pathInfo = '/member/1254'
request.method = 'GET'
router:route(request)
