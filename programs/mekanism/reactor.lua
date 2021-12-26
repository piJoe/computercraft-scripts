local monitors = { peripheral.find("monitor") }
local scripts = {}

for _, monitor in pairs(monitors) do
    monitor.setTextScale(0.5)
    local id = shell.openTab("/programs/mekanism/monitor.lua", peripheral.getName(monitor))
    multishell.setTitle(id, peripheral.getName(monitor))
end