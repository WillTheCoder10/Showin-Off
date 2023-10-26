local battery = {}
local util = require("util")
local maxCharge = 550.0
local currentCharge = maxCharge
local goalCurr = 0
local clock = os.clock

function battery.roundedCharge()
    return (math.floor(((currentCharge/maxCharge)*100)*100)/100)
end

local charge = coroutine.create(function()
    while true do
        repeat
            util.sleep(1)
            currentCharge = currentCharge+10
            print("Charging, now at: "..battery.roundedCharge().."%")
        until currentCharge >= maxCharge*.99
        print("\nFully charged, resuming regular activity...\n")
        util.sleep(2.5)
        coroutine.yield()
    end
end)

local regular = coroutine.create(function(goal, chargePerc)
    print("Starting new activity.\nGoal to reach: "..goal.."\nStopping at "..chargePerc.."% battery to charge if necessary.\n")
    while true do
        if goalCurr >= goal then
            print("Goal reached, exiting.\n")
            goalCurr = 0
            goal, chargePerc = coroutine.yield()
            print("Starting new activity. Goal to reach: "..goal.."\nStopping at "..chargePerc.."% battery to charge if necessary.\n")
        elseif currentCharge <= maxCharge*(chargePerc/100) then
            print("\nBelow recommended battery levels, now at "..battery.roundedCharge().."%, moving to an autocharger...\n")
            util.sleep(2.5)
            coroutine.resume(charge)
        else
            util.sleep(1)
            currentCharge = currentCharge-10
            goalCurr = goalCurr+1
            print("Goal Progress: "..goalCurr)
        end
    end
end)

function battery.startMain(goal, chargePerc)
    coroutine.resume(regular, goal, chargePerc+0.0)
end

return battery
