local game = Game()
local JadeIvoryMaskLocalID = Isaac.GetItemIdByName("Jade & Ivory Mask")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(JadeIvoryMaskLocalID, "{{Collectible}} On each floor, upgrade a random item you have previously picked up, with quality 3 or lower, into a random item with quality increased by 1")
end

function ShatteredSymbols:OnNewLevelJadeIvoryMask()
    for p = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(p)
        if player:HasCollectible(JadeIvoryMaskLocalID) then

            local eligibleItems = {}
            
            for id = 1, Isaac.GetItemConfig():GetCollectibles().Size do
                local itemConfig = Isaac.GetItemConfig():GetCollectible(id)
                if itemConfig and id ~= JadeIvoryMaskLocalID and not itemConfig:HasTags(ItemConfig.TAG_QUEST) and player:HasCollectible(id) then
                    if itemConfig.Quality >= 0 and itemConfig.Quality <= 3 then
                        table.insert(eligibleItems, id)
                    end
                end
            end
            
            if #eligibleItems > 0 then
                
                local oldItemID = eligibleItems[math.random(1, #eligibleItems)]
                local oldItemConfig = Isaac.GetItemConfig():GetCollectible(oldItemID)
                local newQuality = oldItemConfig.Quality + 1
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
                    local newItemID = pool[math.random(1, #pool)]
                    
                    player:RemoveCollectible(oldItemID)
                    player:AddCollectible(newItemID, 0, false)
                    
                    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, player.Position, Vector(0,0), player)
                    SFXManager():Play(SoundEffect.SOUND_1UP)
                end
            end
        end
    end
end


ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, ShatteredSymbols.OnNewLevelJadeIvoryMask)
