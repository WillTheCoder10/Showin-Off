local battery = require("battery")
local util    = require("util")

battery.startMain(10, 87)
util.sleep(3)
battery.startMain(5, 87)