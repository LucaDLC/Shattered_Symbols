local fiendishSeed = RegisterMod("Fiendish Seed", 1)
local fiendishSeedID = Isaac.GetItemIdByName("Fiendish Seed")

if EID then
    EID:addCollectible(fiendishSeedID, "Add 1 Broken Heart {{BrokenHeart}} and ", "Glyph")
end

-- Aggiunta della nuova runa Glyph
local fiendishSeed = {
    ID = fiendishSeedID,
    Name = "Fiendish Seed",
    Type = "Rune",
    Description = "Feed me"
}

-- Callback per quando il giocatore usa una runa
function fiendishSeed:onUseCard(cardID, player, useFlags)
    if cardID == fiendishSeedID then
        local tier0ItemPool = {}
        local tier1ItemPool = {}
        local tier2ItemPool = {}
        local tier3ItemPool = {}
        local tier4ItemPool = {}

        local entities = Isaac.GetRoomEntities();

        for i = 1, #Isaac.GetItemConfig():GetCollectibles() do
            local itemConfig = Isaac.GetItemConfig():GetCollectible(i)
            if itemConfig and itemConfig.Quality == 0 and not table.contains(collectedItems, itemConfig.ID) and not table.contains(itemIgnoreList, itemConfig.ID) then
                table.insert(tier0ItemPool, i)
            end
            if itemConfig and itemConfig.Quality == 1 and not table.contains(collectedItems, itemConfig.ID) and not table.contains(itemIgnoreList, itemConfig.ID) then
                table.insert(tier1ItemPool, i)
            end
            if itemConfig and itemConfig.Quality == 2 and not table.contains(collectedItems, itemConfig.ID) and not table.contains(itemIgnoreList, itemConfig.ID) then
                table.insert(tier2ItemPool, i)
            end
            if itemConfig and itemConfig.Quality == 3 and not table.contains(collectedItems, itemConfig.ID) and not table.contains(itemIgnoreList, itemConfig.ID) then
                table.insert(tier3ItemPool, i)
            end
            if itemConfig and itemConfig.Quality == 4 and not table.contains(collectedItems, itemConfig.ID) and not table.contains(itemIgnoreList, itemConfig.ID) then
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
        player:AddBrokenHearts(1)
    end
    
end

--Support function
function table.contains(tbl, element)
    for _, value in ipairs(tbl) do
        if value == element then
            return true
        end
    end
    return false
end

function fiendishSeed:AddItemToList(pickup)
    if pickup.Type == EntityType.ENTITY_PICKUP and pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE and pickup.SubType ~= 0 and pickup.SubType ~= 668 then
    local itemID = pickup.SubType
    table.insert(collectedItems, itemID)
    end
end

function fiendishSeed:ClearList()
    collectedItems = {}
end



fiendishSeed:AddCallback(ModCallbacks.MC_USE_CARD, fiendishSeed.onUseCard)
fiendishSeed:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, fiendishSeed.AddItemToList)
fiendishSeed:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, fiendishSeed.ClearList)