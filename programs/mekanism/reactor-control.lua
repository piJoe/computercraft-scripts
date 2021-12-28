local reactor = peripheral.find("fissionReactor")
local turbine = peripheral.find("turbine")
local waterTank = peripheral.find("dynamicTank")
local wasteBarrel = peripheral.find("wasteBarrel")

local monitorReactor = require "monitoring/reactor"
pcall(monitorReactor.setup, peripheral.wrap("left"))

local monitorTurbine = require "monitoring/turbine"
pcall(monitorTurbine.setup, peripheral.wrap("right"))

local monitorWaste = require "monitoring/waste"
pcall(monitorWaste.setup, peripheral.wrap("monitor_1"))

local monitorWater = require "monitoring/water-tank"
pcall(monitorWater.setup, peripheral.wrap("monitor_4"))

function controlReactor()
    local data = {
        running = reactor.getStatus(),
        actualBurnRate = reactor.getActualBurnRate(),
        burnRate = reactor.getBurnRate(),
        heatingRate = reactor.getHeatingRate(),
        temp = reactor.getTemperature(),
        coolantTank = reactor.getCoolantFilledPercentage(),
        steamTank = reactor.getHeatedCoolantFilledPercentage(),
        fuelTank = reactor.getFuelFilledPercentage(),
        wasteTank = reactor.getWasteFilledPercentage(),
        damage = reactor.getDamagePercent()
    }

    if data.wasteTank > 0.5
    or data.coolantTank < 0.5
    or data.steamTank > 0.01
    or data.temp > 900
    or data.damage > 0 then
        if data.running == true then
            reactor.scram()
        end
        return data
    end

    if data.running == false then
        reactor.activate()
    end

    data.running = reactor.getStatus()

    return data
end

function updateStatus(reactorData, turbineData, waterReserveData, wasteData)
    monitorReactor.update(reactorData)
    monitorTurbine.update(turbineData)
    monitorWaste.update(wasteData)
    monitorWater.update(waterReserveData)
end

while true do
    local reactorData = controlReactor(reactorData)

    local turbineData = {
        running = turbine.getProductionRate() > 100,
        productionRate = turbine.getProductionRate(),
        maxProduction = reactorData.burnRate*20 * turbine.getCoils() * 285,
    }

    local waterReserveData = {
        tank = waterTank.getFilledPercentage(),
    }

    local wasteData = {
        permanentRepositoryTank = wasteBarrel.getFilledPercentage(),
        reactorWasteTank = reactorData.wasteTank,
    }

    local ok, err = pcall(updateStatus, reactorData, turbineData, waterReserveData, wasteData)
    if ok == false then
        print(err)
    end

    os.sleep(0.1)
end