local bigFont = require "lib/bigfont"
local Graph = require "lib/graph"

local tArgs = {...}
local monitor = peripheral.wrap(tArgs[1])

print("Setting up monitor...")
monitor.setTextScale(0.5)
term.redirect(monitor)

local graph = Graph.create(0, 4300, 2, 6, 25, 10)
graph:setMarkings(false)

local graph2 = Graph.create(0, 4300, 28, 6, 25, 10)
graph2:setFilled(true)
graph2:setMarkings(false)
-- graph2:setAutoMax(true)

math.randomseed(os.epoch())
local lastVal = -100
local dir = 1
function tick()
    -- inserting
--     local rand = math.random(math.max(lastVal-5, x), math.min(lastVal+5, pixelHeight))
    local rand = lastVal + (dir*math.random(1,40))
    if rand < -100 then
        rand = -100
        dir = dir * -1
    end
    if rand > 4300 then
        rand = 4300
        dir = dir * -1
    end
    lastVal = rand

    graph:addData(rand)
    graph:render()

    graph2:addData(4300 - rand)
    graph2:render()

    -- draw text
--     term.setCursorPos(28, 6)
--     term.write(lastVal)
end
function starfield()
    for i=1, pixelWidth do
        for j=1, pixelHeight do
            c:setPixel(i, j, math.random() > 0.5)
        end
    end
    c:draw()
end

term.redirect(monitor)
term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)
term.clear()
term.setCursorPos(2,2)
bigFont.bigPrint(string.upper(tArgs[1]))
while true do
    os.sleep(0.1)
    tick()
end
