local rsI = peripheral.wrap("right")
local detector = peripheral.wrap("bottom")

local positions = {
    {x = 211, y = 113, z = 4706},
    {x = 205, y = 115, z = 4704},
}

function doorState(open)
    rs.setOutput("top", open)
    rsI.setOutput("top", open)
end

function detectPlayer(posA, posB)
    return detector.isPlayersInCoords(posA, posB)
end

while true do
    local playerNear = detectPlayer(positions[1], positions[2])
    doorState(playerNear)
end