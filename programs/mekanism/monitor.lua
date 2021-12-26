local bigFont = require "/programs/mekanism/lib/bigFont"
local Canvas = require "/programs/mekanism/lib/pixel-canvas"

local tArgs = {...}
local monitor = peripheral.wrap(tArgs[1])

print("Setting up monitor...")
term.redirect(monitor)
local termW, termH = term.getSize()
local c = Canvas.create(2, 6, 25, 10)

local x, y, w, h = c:getSize()
local pixelWidth = w*2
local pixelHeight = h*3

local fill = false

local columns = {}
local columnCount = 0

function map(x, in_min, in_max, out_min, out_max)
  return out_min + (x - in_min)*(out_max - out_min)/(in_max - in_min)
end

math.randomseed(os.epoch())
local lastVal = 4300
local dir = -1
function graph()
    -- inserting
--     local rand = math.random(math.max(lastVal-5, x), math.min(lastVal+5, pixelHeight))
    local rand = lastVal + (dir*math.random(0,4))
    if rand < 0 then
        rand = 0
        dir = dir * -1
    end
    if rand > 4300 then
        rand = 4300
        dir = dir * -1
    end
    table.insert(columns, rand)
    lastVal = rand
    columnCount=columnCount+1
    if columnCount > pixelWidth-3 then
        table.remove(columns, 1)
        columnCount=columnCount-1
    end

    -- drawing
    term.setBackgroundColor(colors.black)
    local x = 3
    local prevVal = -1
    -- draw axis
    for i=1, pixelWidth do
        c:setPixel(i, pixelHeight, true)
    end
    for i=1, pixelHeight do
        c:setPixel(1, i, true)
    end
    -- draw values
    for _, val in pairs(columns) do
        val = map(val, 0, 4300, 2, pixelHeight-2) -- TODO: set mapping "from" values (0, 500) via api method from outside
        val = math.floor(pixelHeight - val)
        if fill then
            prevVal = pixelHeight-1
        end
        if prevVal > -1 then
            local step = 1
            if val < prevVal then
                step = -1
            end
            for i=prevVal+step,val, step do
                c:setPixel(x, i, true)
            end
        end
        c:setPixel(x, val, true)
        x = x + 1
        prevVal = val
    end
    c:draw()
    c:flush()

    -- draw text
    term.setCursorPos(28, 6)
    term.write(lastVal)
end
function starfield()
    for i=1, pixelWidth do
        for j=1, pixelHeight do
            c:setPixel(i, j, math.random() > 0.5)
        end
    end
    c:draw()
end

--     term.setBackgroundColor(colors.black)
--     term.setTextColor(colors.white)
--     term.setCursorPos(2,2)
--     bigFont.bigPrint(" MY STATIC ")
--     term.setCursorPos(2,5)
--     bigFont.bigPrint(" BRINGS ALL ")
--     term.setCursorPos(2,8)
--     bigFont.bigPrint(" THE BOYS ")
--     term.setCursorPos(2,11)
--     bigFont.bigPrint(" TO THE YARD. ")
term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)
term.clear()
term.setCursorPos(2,2)
bigFont.bigPrint(string.upper(tArgs[1]))
while true do
    os.sleep(0.2)
    graph()
end
