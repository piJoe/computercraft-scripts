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
    bigFont.bigPrint("WASTE DEPOSIT")
    term.setCursorPos(2,5)
    term.write("FILL STATUS")
end

-- local wasteData = {
--         permanentRepositoryTank = wasteBarrel.getFilledPercentage(),
--         reactorWasteTank = reactorData.wasteTank,
--     }

function update(data)
    term.redirect(monitor)

    term.setCursorPos(2,10)
    term.setTextColor(colors.white)
    term.clearLine()
    term.write("NUCLEAR WASTE BACKUP:")
    term.setCursorPos(2, 12)
    bigFont.bigPrint(mathHelper.fixedDecimals(data.reactorWasteTank*100, 2) .. "%  ")

    term.setCursorPos(2,17)
    term.setTextColor(colors.white)
    term.clearLine()
    term.write("SPENT WASTE DEPOSIT:")
    term.setCursorPos(2, 19)
    bigFont.bigPrint(mathHelper.fixedDecimals(data.permanentRepositoryTank*100, 2) .. "%  ")
end

return {setup = setup, update = update}