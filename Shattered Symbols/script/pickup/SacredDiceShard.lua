local game = Game()
local SacredDiceShardLocalID = Isaac.GetCardIdByName("Sacred Dice Shard")
local collectedItems = {}
local itemIgnoreList = {
    238, 239, 550, 551, 626, 627, 668
}

-- EID (External Item Descriptions)
if EID then
    EID:addCard(SacredDiceShardLocalID, "{{Collectible105}} Rerolls all items in the room, into random items of 1 quality higher #{{BrokenHeart}} Gives 1 Broken Heart")
end

local function tablecontains(tbl, element)
    for _, value in ipairs(tbl) do
        if value == element then
            return true
        end
    end
    return false
end

local function BrokenHeartRemovingSystem(player)
    local slotRemoved = false

    if player:GetMaxHearts() >= 2 and not slotRemoved then
        player:AddMaxHearts(-2)  
        slotRemoved = true
    end

    if not slotRemoved and player:GetBoneHearts() >= 1 then
        player:AddBoneHearts(-1) 
        slotRemoved = true
    end

    if not slotRemoved and player:GetSoulHearts() >= 2 then
        player:AddSoulHearts(-2)  
        slotRemoved = true
    end

    if not slotRemoved and player:GetBlackHearts() >= 2 then
        player:AddBlackHearts(-2)  
        slotRemoved = true
    end

    player:AddBrokenHearts(1)

end

function ShatteredSymbols:useSacredDiceShard(cardID, player, useFlags)
    if cardID == SacredDiceShardLocalID then
        local tier0ItemPool = {}
        local tier1ItemPool = {}
        local tier2ItemPool = {}
        local tier3ItemPool = {}
        local tier4ItemPool = {}

        local entities = Isaac.GetRoomEntities();

        for i = 1, #Isaac.GetItemConfig():GetCollectibles() do
            local itemConfig = Isaac.GetItemConfig():GetCollectible(i)
            if itemConfig and itemConfig.Quality == 0 and not tablecontains(collectedItems, itemConfig.ID) and not tablecontains(itemIgnoreList, itemConfig.ID) then
                table.insert(tier0ItemPool, i)
            end
            if itemConfig and itemConfig.Quality == 1 and not tablecontains(collectedItems, itemConfig.ID) and not tablecontains(itemIgnoreList, itemConfig.ID) then
                table.insert(tier1ItemPool, i)
            end
            if itemConfig and itemConfig.Quality == 2 and not tablecontains(collectedItems, itemConfig.ID) and not tablecontains(itemIgnoreList, itemConfig.ID) then
                table.insert(tier2ItemPool, i)
            end
            if itemConfig and itemConfig.Quality == 3 and not tablecontains(collectedItems, itemConfig.ID) and not tablecontains(itemIgnoreList, itemConfig.ID) then
                table.insert(tier3ItemPool, i)
            end
            if itemConfig and itemConfig.Quality == 4 and not tablecontains(collectedItems, itemConfig.ID) and not tablecontains(itemIgnoreList, itemConfig.ID) then
                table.insert(tier4ItemPool, i)
            end    
        end

        for _, entity in ipairs(entities) do
            if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE and entity.SubType ~= 0 and entity.SubType ~= 668 then

                local currentItemQuality = Isaac.GetItemConfig():GetCollectible(entity.SubType)
                local randomCollectibleID = 0
                if currentItemQuality and currentItemQuality.Quality == 0 then
                    if #tier1ItemPool == 0 then
                    else
                        local randomIndex = math.random(#tier1ItemPool)
                        randomCollectibleID = tier1ItemPool[randomIndex]
                        table.remove(tier1ItemPool, randomIndex)
                    end
                end
                if currentItemQuality and currentItemQuality.Quality == 1 then
                    if #tier2ItemPool == 0 then
                    else
                        local randomIndex = math.random(#tier2ItemPool)
                        randomCollectibleID = tier2ItemPool[randomIndex]
                        table.remove(tier2ItemPool, randomIndex)
                    end 
                end
                if currentItemQuality and currentItemQuality.Quality == 2 then
                    if #tier3ItemPool == 0 then
                    else
                        local randomIndex = math.random(#tier3ItemPool)
                        randomCollectibleID = tier3ItemPool[randomIndex]
                        table.remove(tier3ItemPool, randomIndex)
                    end 
                end
                if currentItemQuality and currentItemQuality.Quality == 3 then
                    if #tier4ItemPool == 0 then
                    else
                        local randomIndex = math.random(#tier4ItemPool)
                        randomCollectibleID = tier4ItemPool[randomIndex]
                        table.remove(tier4ItemPool, randomIndex)
                    end 
                end
                if currentItemQuality and currentItemQuality.Quality == 4 then
                    if #tier4ItemPool == 0 then
                    else
                        local randomIndex = math.random(#tier4ItemPool)
                        randomCollectibleID = tier4ItemPool[randomIndex]
                        table.remove(tier4ItemPool, randomIndex)
                    end 
                end

                if randomCollectibleID == 0 then
                    entity:ToPickup():Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, Isaac.GetItemIdByName("Breakfast"), true)
                    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, -1, entity.Position, entity.Velocity, nil)    
                else
                    entity:ToPickup():Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, randomCollectibleID, true)
                    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, -1, entity.Position, entity.Velocity, nil)
                end 
            end
        end
        BrokenHeartRemovingSystem(player)
    end
    
end

function ShatteredSymbols:AddItemToList(pickup)
    if pickup.Type == EntityType.ENTITY_PICKUP and pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE and pickup.SubType ~= 0 and pickup.SubType ~= 668 then
    local itemID = pickup.SubType
    table.insert(collectedItems, itemID)
    end
end

function ShatteredSymbols:ClearList()
    collectedItems = {}
end



ShatteredSymbols:AddCallback(ModCallbacks.MC_USE_CARD, ShatteredSymbols.useSacredDiceShard, SacredDiceShardLocalID)
ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, ShatteredSymbols.AddItemToList)
ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, ShatteredSymbols.ClearList)