ItemFilter = RegisterMod("Item Filter", 1)
local mod = ItemFilter
local itemManager = require("scripts.ItemManager")

-- Initialize the mod
itemManager.init(mod)


-- Register callbacks
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, itemManager.getItems)
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, itemManager.replaceItem, PickupVariant.PICKUP_COLLECTIBLE)
