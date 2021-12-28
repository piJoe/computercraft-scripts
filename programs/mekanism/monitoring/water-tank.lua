local bigFont = require "lib/bigfont"
local Graph = require "lib/graph"
local mathHelper = require "lib/math-helper"

local monitor = nil

function setup(mon)
    monitor = mon
    term.redirect(monitor)
    print("Setting up monitor...")
    monitor.setTextScale(0.5)

    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
    term.clear()
    term.setCursorPos(2,2)
    bigFont.bigPrint("WATER RESERVE")
    term.setCursorPos(2,5)
    term.write("TANK STATUS")
end

function update(data)
    term.redirect(monitor)

    term.setCursorPos(2, 12)
    bigFont.hugePrint(mathHelper.fixedDecimals(data.tank*100, 1) .. "%  ")
end

return {setup = setup, update = update}