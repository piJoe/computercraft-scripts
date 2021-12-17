local injectors = { peripheral.find("draconicevolution:crafting_injector") }
local coreInv = peripheral.find("entangled:tile")
local itemCrate = peripheral.find("krate:krate_large")
local rsInterface = peripheral.find("refinedstorage:interface")
local coreRedstoneSide = "top"

local coreInputSlot = 1
local coreResultSlot = 2

local recipes = {
    draconic_core = {
        name = "Draconic Core",
        core = {"minecraft:nether_star", 1},
        injectors = {
            {"draconicevolution:wyvern_core", 4},
            {"draconicevolution:awakened_draconium_ingot", 4},
        },
    },

    chaotic_core = {
        name = "Chaotic Core",
        core = {"draconicevolution:large_chaos_frag", 1},
        injectors = {
            {"draconicevolution:large_chaos_frag", 4},
            {"draconicevolution:awakened_core", 4},
            {"draconicevolution:awakened_draconium_ingot", 4},
        },
    },

    wyvern_injector = {
        name = "Wyvern Crafting Injector",
        core = {"draconicevolution:basic_crafting_injector", 1},
        injectors = {
            {"draconicevolution:wyvern_core", 1},
            {"draconicevolution:draconium_core", 2},
            {"draconicevolution:draconium_block", 1},
            {"minecraft:diamond", 4},
        },
    },

    draconic_injector = {
        name = "Draconic Crafting Injector",
        core = {"draconicevolution:wyvern_crafting_injector", 1},
        injectors = {
            {"draconicevolution:wyvern_core", 2},
            {"draconicevolution:awakened_draconium_block", 1},
            {"minecraft:diamond", 4},
        },
    },

    chaotic_injector = {
        name = "Chaotic Crafting Injector",
        core = {"draconicevolution:awakened_crafting_injector", 1},
        injectors = {
            {"draconicevolution:large_chaos_frag", 4},
            {"minecraft:dragon_egg", 1},
            {"minecraft:diamond", 4},
        },
    },

    energy_crystal = {
        name = "Draconic Energy Crystal",
        core = {"draconicevolution:wyvern_relay_crystal", 4},
        injectors = {
            {"draconicevolution:wyvern_energy_core", 4},
            {"minecraft:diamond", 4},
            {"draconicevolution:wyvern_core", 1},
        },
    },

    powerpot_mk1 = {
        name = "PowerPot MK1",
        core = {"botanypots:hopper_botany_pot", 1},
        injectors = {
            {"ftbjarmod:cast_iron_block", 4},
            {"minecraft:emerald_block", 2},
            {"mekanism:basic_energy_cube", 1},
        },
    },

    powerpot_mk2 = {
        name = "PowerPot MK2",
        core = {"ftb-power-pots:power_pot_mk1", 1},
        injectors = {
            {"ftbjarmod:cast_iron_block", 4},
            {"botania:blaze_block", 2},
            {"mekanism:advanced_energy_cube", 1},
        },
    },

    powerpot_mk3 = {
        name = "PowerPot MK3",
        core = {"ftb-power-pots:power_pot_mk2", 1},
        injectors = {
            {"ftbjarmod:cast_iron_block", 4},
            {"botania:mana_diamond_block", 2},
            {"mekanism:elite_energy_cube", 1},
        },
    },

    powerpot_mk4 = {
        name = "PowerPot MK4",
        core = {"ftb-power-pots:power_pot_mk3", 1},
        injectors = {
            {"ftbjarmod:cast_iron_block", 4},
            {"draconicevolution:draconium_block", 2},
            {"mekanism:ultimate_energy_cube", 1},
        },
    },
}

local craftInitItems = {
    ["minecraft:white_carpet"] = "draconic_core",

    ["minecraft:orange_carpet"] = "chaotic_core",

    ["minecraft:magenta_carpet"] = "powerpot_mk1",
    ["minecraft:light_blue_carpet"] = "powerpot_mk2",
    ["minecraft:yellow_carpet"] = "powerpot_mk3",
    ["minecraft:lime_carpet"] = "powerpot_mk4",

    ["minecraft:pink_carpet"] = "singularity",

    ["minecraft:gray_carpet"] = "energy_crystal",

    ["minecraft:light_gray_carpet"] = "wyvern_injector",
    ["minecraft:cyan_carpet"] = "draconic_injector",
    ["minecraft:purple_carpet"] = "chaotic_injector",
}

function getNextCraftingRecipe()
    local items = itemCrate.list()
    for slot, item in pairs(items) do
        local recipeId = craftInitItems[item.name]
        if recipeId ~= nil then
            local recipe = recipes[recipeId]
            if recipe == nil then
                print("ERROR: No recipe found for " .. item.name .. " / " .. recipeId );
            else
                -- todo: pull this item out (only 1) into the rsInterface
                rsInterface.pullItems(peripheral.getName(itemCrate), slot, 1)
                return recipe
            end
        end
    end
    return nil
end

function getEmptyInjector()
    for _, injector in pairs(injectors) do
        if injector.getItemDetail(1) == nil then
            return injector
        end
    end
    return nil
end

function findItemSlotInCrate(itemName)
    for slot, item in pairs(itemCrate.list()) do
        if (item.name == itemName) then
            return slot
        end
    end
    return nil
end

function insertIngredients(recipe)
    -- insert ingredients into injectors
    for _, item in pairs(recipe.injectors) do
        local itemName = item[1]
        local itemCount = item[2]

        print("INGREDIENT: " .. itemCount .. "x " .. itemName)
        for i=1,itemCount do
            local injector = getEmptyInjector()
            if injector == nil then
                print("ERROR! No more empty injectors, aborting...")
                cleanupCrafting()
                return
            end

            local slot = findItemSlotInCrate(itemName)
            while slot == nil do
                slot = findItemSlotInCrate(itemName)
                os.sleep(0.1)
            end
            injector.pullItems(peripheral.getName(itemCrate), slot, 1)
        end
    end

    -- insert into core
    local itemName = recipe.core[1]
    local itemCount = recipe.core[2]
    print("INGREDIENT: " .. itemCount .. "x " .. itemName)

    local slot = findItemSlotInCrate(itemName)
    while slot == nil or itemCrate.getItemDetail(slot).count < itemCount do
        slot = findItemSlotInCrate(itemName)
        os.sleep(0.1)
    end
    coreInv.pullItems(peripheral.getName(itemCrate), slot, itemCount)
end

function cleanupCrafting()
    -- remove any items in the injector
    for _, injector in pairs(injectors) do
        rsInterface.pullItems(peripheral.getName(injector), 1)
    end

    -- remove core crafting ingredient and result
    local coreIngredient = coreInv.getItemDetail(coreInputSlot)
    if coreIngredient ~= nil then
        print("CORE INPUT CLOGGED! PLEASE REMOVE MANUALLY!")
        print("CORE INPUT CLOGGED! PLEASE REMOVE MANUALLY!")
        print("CORE INPUT CLOGGED! PLEASE REMOVE MANUALLY!")
        repeat
            os.sleep(1)
            coreIngredient = coreInv.getItemDetail(coreInputSlot)
        until coreIngredient == nil
    end
--     rsInterface.pullItems(peripheral.getName(coreInv), coreInputSlot) -- ingredient
    rsInterface.pullItems(peripheral.getName(coreInv), coreResultSlot) -- result
end

function sendStartImpulse()
    rs.setOutput(coreRedstoneSide, false)
    os.sleep(0.1)
    rs.setOutput(coreRedstoneSide, true)
    os.sleep(0.1)
    rs.setOutput(coreRedstoneSide, false)
end

function waitForResult()
    local result = nil
    repeat
        result = coreInv.getItemDetail(coreResultSlot)
    until result ~= nil
    os.sleep(1)
end

function craftRecipe(recipe)
    cleanupCrafting()

    print("CRAFT: " .. recipe.name)

    insertIngredients(recipe)
    sendStartImpulse()
    waitForResult()

    print("Crafting finished, extracting results")
    rsInterface.pullItems(peripheral.getName(coreInv), coreResultSlot) -- result
end

function loop()
    local recipe = getNextCraftingRecipe()
    if recipe == nil then
        return
    end
    craftRecipe(recipe)
end

print("Welcome to Draconic Auto-Crafter")
while true do
    loop()
    os.sleep(1)
end