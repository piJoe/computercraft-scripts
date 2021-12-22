local rsI = peripheral.wrap("right")
local detector = peripheral.wrap("bottom")

local scanRange = 5
local allowedPlayers = {
    ["madGoldfish"] = true,
    ["Waldro"] = true
}

function doorState(open)
    rs.setOutput("top", open)
    rsI.setOutput("top", open)
end

function detectPlayer(range)
    local players = detector.getPlayersInRange(range)
    for _, player in pairs(players) do
        return true
    end
    return false
end

while true do
    local playerNear = detectPlayer(scanRange)
    doorState(playerNear)
end