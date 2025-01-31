local game = Game()
local JadeIvoryMaskLocalID = Isaac.GetItemIdByName("Jade & Ivory Mask")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(JadeIvoryMaskLocalID, "{{ArrowUp}} On each floor, there is a 35% chance to upgrade a random item you have previously picked up (only items with quality 3 or lower) into a random item with quality increased by 1")
end

function ShatteredSymbols:OnNewLevelJadeIvoryMask()
    for p = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(p)
        if player:HasCollectible(JadeIvoryMaskLocalID) then
            if math.random() < 0.35 then

                local eligibleItems = {}
                for i = 0, CollectibleType.NUM_COLLECTIBLES - 1 do
                    -- Escludi Jade & Ivory Mask
                    if i ~= JadeIvoryMaskLocalID and player:HasCollectible(i) then
                        local itemConfig = Isaac.GetItemConfig():GetCollectible(i)
                        if itemConfig then
                            local quality = itemConfig:GetQuality()
                            if quality >= 0 and quality <= 3 then
                                table.insert(eligibleItems, i)
                            end
                        end
                    end
                end

                if #eligibleItems > 0 then
                    -- Seleziona un oggetto casuale tra quelli eleggibili
                    local oldItemID = eligibleItems[math.random(1, #eligibleItems)]
                    local oldItemConfig = Isaac.GetItemConfig():GetCollectible(oldItemID)
                    local oldQuality = oldItemConfig:GetQuality()
                    local newQuality = oldQuality + 1

                    local pool = {}
                    -- Cerca nella lista degli oggetti uno (o più) con la qualità incrementata
                    for i = 0, CollectibleType.NUM_COLLECTIBLES - 1 do
                        local itemConfig = Isaac.GetItemConfig():GetCollectible(i)
                        if itemConfig and itemConfig:GetQuality() == newQuality then
                            table.insert(pool, i)
                        end
                    end

                    if #pool > 0 then
                        local newItemID = pool[math.random(1, #pool)]
                        -- Rimuovi l'oggetto vecchio e aggiungi quello nuovo
                        player:RemoveCollectible(oldItemID)
                        player:AddCollectible(newItemID, 0, false)
                        -- Eventuale effetto visivo/suono per indicare la sostituzione
                        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, player.Position, Vector(0,0), player)
                    end
                end
            end
        end
    end
end

-- Aggiunge la callback che si attiva ad ogni nuovo livello (piano)
ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, ShatteredSymbols.OnNewLevelJadeIvoryMask)
