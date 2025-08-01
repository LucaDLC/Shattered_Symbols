local game = Game()
local QueenOfSpadesID = Isaac.GetCardIdByName("Queen of Spades")

-- EID (External Item Descriptions)
if EID then
    EID:addCard(QueenOfSpadesID, "{{Collectible}} De-evolve an quality 1 or higher item you have in two random items of one lower tier. If you have no items of that quality, nothing happens.")
end

function ShatteredSymbols:useQueenOfSpades(card, player, useFlags)
    local eligibleItems = {}
            
    for id = 1, Isaac.GetItemConfig():GetCollectibles().Size do
        local itemConfig = Isaac.GetItemConfig():GetCollectible(id)
        if itemConfig and not itemConfig:HasTags(ItemConfig.TAG_QUEST) and player:HasCollectible(id) then
            if itemConfig.Quality > 0 then
                table.insert(eligibleItems, id)
            end
        end
    end

    if #eligibleItems > 0 then
        local oldItemID = eligibleItems[math.random(1, #eligibleItems)]
        local oldItemConfig = Isaac.GetItemConfig():GetCollectible(oldItemID)
        local newQuality = oldItemConfig.Quality - 1
        local pool = {}
        local activeItem = player:GetActiveItem(ActiveSlot.SLOT_PRIMARY)
        if activeItem == 0 or activeItem == CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES then
            for id = 1, Isaac.GetItemConfig():GetCollectibles().Size do
                local itemConfig = Isaac.GetItemConfig():GetCollectible(id)
                if itemConfig and not itemConfig:HasTags(ItemConfig.TAG_QUEST) and itemConfig.Quality == newQuality then
                    table.insert(pool, id)
                end
            end
        else
            for id = 1, Isaac.GetItemConfig():GetCollectibles().Size do
                local itemConfig = Isaac.GetItemConfig():GetCollectible(id)
                if itemConfig and not itemConfig:HasTags(ItemConfig.TAG_QUEST) and itemConfig.Quality == newQuality and itemConfig.Type == ItemType.ITEM_PASSIVE then
                    table.insert(pool, id)
                end
            end
        end

        if #pool > 0 then
            player:RemoveCollectible(oldItemID)

            local newItemID = pool[math.random(1, #pool)]
            player:AddCollectible(newItemID, 0, false)

            for i, v in ipairs(pool) do
                if v == newItemID then
                    table.remove(pool, i)
                    break
                end
            end

            if #pool > 0 then
                newItemID = pool[math.random(1, #pool)]
                player:AddCollectible(newItemID, 0, false)
            else
                player:AddCollectible(newItemID, 0, false)
            end
            
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, player.Position, Vector(0,0), player)
        end
    end
    SFXManager():Play(Isaac.GetSoundIdByName("Queen of Spades"))
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_USE_CARD, ShatteredSymbols.useQueenOfSpades, QueenOfSpadesID)
