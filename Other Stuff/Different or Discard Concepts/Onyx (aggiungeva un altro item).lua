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
        if not data.OnyxItemEffectID then data.OnyxItemEffectID = nil end
        if player:HasCollectible(OnyxLocalID) then
            local newItemID = GetRandomPassiveItem()
            if newItemID then
                if data.OnyxItemEffectID ~= nil and not player:HasCollectible(data.OnyxItemEffectID) then  
                    player:RemoveCollectible(OnyxLocalID)
                    data.OnyxItemEffectID = nil
                else
                    if data.OnyxItemEffectID ~= nil then  
                        player:RemoveCollectible(data.OnyxItemEffectID)
                    end
                    data.OnyxItemEffectID = newItemID
                    player:AddCollectible(data.OnyxItemEffectID)
                end
            end
        else 
            if data.OnyxItemEffectID ~= nil and player:HasCollectible(data.OnyxItemEffectID) then  
                player:RemoveCollectible(data.OnyxItemEffectID)
            end
            data.OnyxItemEffectID = nil
        end
    end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, ShatteredSymbols.OnNewLevelOnyx)