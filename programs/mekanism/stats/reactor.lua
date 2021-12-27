local bigFont = require "../lib/bigFont"
local Graph = require "../lib/graph"

local tArgs = {...}
local monitor = peripheral.wrap(tArgs[1])

print("Setting up monitor...")
monitor.setTextScale(0.5)
term.redirect(monitor)

local graph = Graph.create(0, 4300, 2, 6, 25, 10)
graph:setMarkings(false)

function tick()
    graph:addData(rand)
    graph:render()
end
term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)
term.clear()
term.setCursorPos(2,2)
bigFont.bigPrint(string.upper(tArgs[1]))
while true do
    os.sleep(0.1)
    tick()
end
