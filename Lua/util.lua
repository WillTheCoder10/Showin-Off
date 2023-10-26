local util = {}
local clock = os.clock

function util.sleep(n)
    local t0 = clock()
    while clock()-t0 <= n do end
end

return util