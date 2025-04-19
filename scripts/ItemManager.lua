local itemManager = {}
local itemConfig = Isaac.GetItemConfig()
local rng = RNG()
local json = require("json")

local itemsData = {}
local modRef

function itemManager.init(mod)
    modRef = mod
end
-- Registers all items and saves them using SaveData
function itemManager.registerItems(_, isContinued)
    if isContinued then return end -- Don't overwrite on continued games

    itemsData = {}
    local lastItemID = 1
    local removedItem = false
    local noMoreItems = false
    while not noMoreItems do
        local item = itemConfig:GetCollectible(lastItemID)
        if item then
            item.Name = itemManager.getCleanItemName(item.Name) -- Clean the item name
            itemsData[lastItemID] = { name = item.Name, id = lastItemID, replaceWith = lastItemID } -- Default replacement is itself
            lastItemID = lastItemID + 1
            removedItem = false -- Reset removed item flag
        elseif(not removedItem) then
            -- If we encounter a removed item, we stop processing
            lastItemID = lastItemID + 1
            removedItem = true
        else
            noMoreItems = true -- No more items to process
        end
    end

    -- Save the data using SaveData
    modRef:SaveData(json.encode(itemsData))
    print("Items registered and saved.")
end

-- Loads item data from SaveData
function itemManager.loadItems()
    if modRef:HasData() then
        itemsData = json.decode(modRef:LoadData())
        print("Items loaded from SaveData.")
    else
        print("No saved data found. Items will be registered on game start.")
    end
end

-- Replaces an item based on the replacement ID
function itemManager.replaceItem(_, pickup)
    local itemID = pickup.SubType
    if itemsData[itemID] then
        local replacementID = itemsData[itemID].replaceWith

        if replacementID == "R" then
            -- Reroll to a random item in the item pool
            local pool = Game():GetItemPool()
            replacementID = pool:GetCollectible(ItemPoolType.POOL_TREASURE, true, rng:Next())
        end

        -- Replace the item
        pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, replacementID, true, false, false)
    end
end

function itemManager.getCleanItemName(rawName)
    -- Remove the leading '#' and '_NAME' suffix
    local cleanName = rawName:gsub("^#", ""):gsub("_NAME$", "")
    -- Replace underscores with spaces and capitalize words
    cleanName = cleanName:gsub("_", " "):gsub("(%a)(%w*)", function(first, rest)
        return first:upper() .. rest:lower()
    end)
    return cleanName
end
return itemManager