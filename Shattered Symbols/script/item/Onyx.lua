local game = Game()
local OnyxLocalID = Isaac.GetItemIdByName("Onyx")

-- EID (se usi EID per la descrizione)
if EID then
    EID:addCollectible(OnyxLocalID, "{{Collectible}} On each floor, it mutates into a different collectible effect #{{Collectible}} The collectible appear in the item pool of player")
end

local function GetRandomPassiveItem()
    local passiveItems = {}
    for id = 1, Isaac.GetItemConfig():GetCollectibles().Size do
        local config = Isaac.GetItemConfig():GetCollectible(id)
        if config and config.Type == ItemType.ITEM_PASSIVE 
        and not config:HasTags(ItemConfig.TAG_QUEST)
        and id ~= OnyxLocalID then 
            table.insert(passiveItems, id)
        end
    end
    if #passiveItems > 0 then return passiveItems[math.random(#passiveItems)] else return nil end
end

-- Callback chiamato ad ogni nuovo piano
function ShatteredSymbols:OnNewLevelOnyx()
    for pl = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(pl)
        local data = player:GetData()
        if not data.OnyxItemEffectID then data.OnyxItemEffectID = {} end
        if player:HasCollectible(OnyxLocalID) then
            for i = #data.OnyxItemEffectID, 1, -1 do
                local effectID = data.OnyxItemEffectID[i]
                if player:HasCollectible(effectID) then
                    player:RemoveCollectible(effectID)
                    local newEffect = GetRandomPassiveItem()
                    data.OnyxItemEffectID[i] = newEffect
                    player:AddCollectible(newEffect)
                else
                    table.remove(data.OnyxItemEffectID, i)
                end
            end
            -- Aggiungiamo un nuovo effetto per ogni Onyx raccolto
            for i = 1, player:GetCollectibleNum(OnyxLocalID) do
                local newEffect = GetRandomPassiveItem()
                table.insert(data.OnyxItemEffectID, newEffect)
                player:AddCollectible(newEffect)
            end
            -- Rimuoviamo tutte le copie di Onyx dalla collezione del giocatore
            while player:HasCollectible(OnyxLocalID) do
                player:RemoveCollectible(OnyxLocalID)
            end
        elseif #data.OnyxItemEffectID > 0 then
            for i = #data.OnyxItemEffectID, 1, -1 do
                local effectID = data.OnyxItemEffectID[i]
                if player:HasCollectible(effectID) then
                    player:RemoveCollectible(effectID)
                    local newEffect = GetRandomPassiveItem()
                    data.OnyxItemEffectID[i] = newEffect
                    player:AddCollectible(newEffect)
                else
                    table.remove(data.OnyxItemEffectID, i)
                end
            end
        end
    end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, ShatteredSymbols.OnNewLevelOnyx)