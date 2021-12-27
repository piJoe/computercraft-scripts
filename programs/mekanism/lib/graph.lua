local Canvas = require "lib/pixel-canvas"

local Graph = {}
Graph.__index = Graph

-- helper functions
function clamp(val, min, max)
    return math.min(math.max(val, min), max)
end
function map(x, in_min, in_max, out_min, out_max)
  return out_min + (x - in_min)*(out_max - out_min)/(in_max - in_min)
end

function round(x)
return x + 0.5 - (x + 0.5) % 1
end

function Graph.create(min, max, x,y, width, height, textColor, backgroundColor)
    local self = {}
	setmetatable (self, {__index=Graph})

    -- setup size, canvas and other visuals
	self.x = x or 1
	self.y = y or 1
	self.character = {}
	local termW, termH = term.getSize()
	self.width = width or (termW - self.x + 1)
	self.height = height or (termH - self.y + 1)
	self.canvas = Canvas.create(self.x, self.y, self.width, self.height, textColor or colors.white, backgroundColor or colors.black)
	self.pixelWidth = self.width*2
	self.pixelHeight = self.height*3
	self.style = {filled = false, markings = true}

    -- setup data point table
    self.minValue = min or 0
    self.maxValue = max or 255
	self.data = {}
	self.dataCount = 0
    self.autoMax = false

	return self
end

function Graph:setMinValue(val)
    self.minValue = val
end
function Graph:setMaxValue(val)
    self.maxValue = val
end

function Graph:setFilled(filled)
    self.style.filled = filled
end
function Graph:setMarkings(markings)
    self.style.markings = markings
end
function Graph:setAutoMax(b)
    self.autoMax = b
end

function Graph:addData(value)
    table.insert(self.data, value)
    self.dataCount = self.dataCount + 1

    local countLimit = 1
    if self.style.markings == true then
        countLimit = 2
    end
    if self.dataCount > self.pixelWidth-countLimit then
        table.remove(self.data, 1)
        self.dataCount=self.dataCount-1
    end

    if self.autoMax == true then
        local highestVal = -math.huge
        for _, val in pairs(self.data) do
            if val > highestVal then
                highestVal = val
            end
        end
        self.maxValue = highestVal
    end
end

function Graph:render()
    term.setBackgroundColor(colors.black)
    local axisOffset = 1
    if self.style.markings == true then
        axisOffset = 2
    end
    local x = axisOffset+1
    local prevVal = -1

    -- draw axis
    for i=1, self.pixelWidth do
        self.canvas:setPixel(i, self.pixelHeight, true)
    end

    for i=1, self.pixelHeight do
        if self.style.markings == true and (self.pixelHeight / i == 2 or i == 1) then
            self.canvas:setPixel(axisOffset-1, i, true)
        end
        self.canvas:setPixel(axisOffset, i, true)
    end

    -- draw values
    for _, val in pairs(self.data) do
        val = clamp(val, self.minValue, self.maxValue)
        val = map(val, self.minValue, self.maxValue, 0, self.pixelHeight-1)
        val = round(self.pixelHeight - val)
        if self.style.filled then
            prevVal = self.pixelHeight
        end
        if prevVal > -1 then
            local step = 1
            if val < prevVal then
                step = -1
            end
            for i=prevVal+step,val, step do
                self.canvas:setPixel(x, i, true)
            end
        end
        self.canvas:setPixel(x, val, true)
        x = x + 1
        prevVal = val
    end
    self.canvas:draw()
    self.canvas:flush()
end


return Graph