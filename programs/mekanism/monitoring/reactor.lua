local bigFont = require "lib/bigfont"
local Graph = require "lib/graph"
local mathHelper = require "lib/math-helper"

local monitor = nil

local tempGraph = nil
local coolantGraph = nil
local fuelGraph = nil

function setup(mon)
    monitor = mon

    print("Setting up monitor...")
    monitor.setTextScale(0.5)
    term.redirect(monitor)
    tempGraph = Graph.create(200, 1000, 2, 19, 55, 5)
    tempGraph:setFilled(true)

    coolantGraph = Graph.create(0, 1, 2, 12, 26, 4)
    coolantGraph:setFilled(true)

    fuelGraph = Graph.create(0, 1, 30, 12, 26, 4)
    fuelGraph:setFilled(true)

    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
    term.clear()
    term.setCursorPos(2,2)
    bigFont.bigPrint("REACTOR")
end

function update(reactorData)
    term.redirect(monitor)
    term.setCursorPos(2,5)
    term.clearLine()
    term.setTextColor(reactorData.running and colors.green or colors.red)
    term.write(reactorData.running == true and "RUNNING" or "OFFLINE")

    term.setCursorPos(2,7)
    term.setTextColor(colors.white)
    term.clearLine()
    term.write("Burn Rate: " .. mathHelper.fixedDecimals(reactorData.actualBurnRate, 1) .. "/" .. mathHelper.fixedDecimals(reactorData.burnRate, 1) .. " mB/t")

    term.setCursorPos(2,8)
    term.setTextColor(colors.white)
    term.clearLine()
    term.write("Heating Rate: " .. mathHelper.fixedDecimals(reactorData.heatingRate, 0) .. " mB/t")

    term.setCursorPos(2,9)
    term.setTextColor(colors.white)
    term.clearLine()
    term.write("Temp: " .. mathHelper.fixedDecimals(reactorData.temp, 2) .. "K")

    term.setTextColor(colors.white)
    term.setCursorPos(2,11)
    term.clearLine()
    term.write("Coolant: " .. mathHelper.fixedDecimals(reactorData.coolantTank*100, 1) .. "%")
    coolantGraph:addData(reactorData.coolantTank)
    coolantGraph:render()
    term.setCursorPos(30,11)
    term.write("Fuel: " .. mathHelper.fixedDecimals(reactorData.fuelTank*100, 1) .. "%")
    fuelGraph:addData(reactorData.fuelTank)
    fuelGraph:render()

    term.setCursorPos(2,18)
    term.setTextColor(colors.white)
    term.write("Temperature Graph:")
    tempGraph:addData(reactorData.temp)
    tempGraph:render()

end

return {setup = setup, update = update}