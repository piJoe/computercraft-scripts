local bigFont = require "lib/bigfont"
local Graph = require "lib/graph"
local mathHelper = require "lib/math-helper"

local monitor = nil

local productionGraph = nil

function setup(mon)
    monitor = mon
    term.redirect(monitor)
    print("Setting up monitor...")
    monitor.setTextScale(0.5)
    productionGraph = Graph.create(0, 1000000, 2, 9, 55, 15)
    productionGraph:setFilled(true)

    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
    term.clear()
    term.setCursorPos(2,2)
    bigFont.bigPrint("TURBINE")
end

-- local turbineData = {
--         running = turbine.getProductionRate() > 100,
--         productionRate = turbine.getProductionRate(),
--     }

function update(data)
    term.redirect(monitor)

    term.setCursorPos(2,5)
    term.clearLine()
    term.setTextColor(data.running and colors.green or colors.red)
    term.write(data.running == true and "RUNNING" or "OFFLINE")

    term.setCursorPos(2,7)
    term.setTextColor(colors.white)
    term.clearLine()
    local productionVal, unit = mathHelper.si(data.productionRate, 2)
    term.write("Production: " .. productionVal .. " " .. unit .. "FE/t")
    productionGraph:addData(data.productionRate)
    productionGraph:setMaxValue(data.maxProduction)
    productionGraph:render()

end

return {setup = setup, update = update}