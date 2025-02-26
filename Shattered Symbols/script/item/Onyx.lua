local game = Game()
local OnyxLocalID = Isaac.GetItemIdByName("Onyx")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(OnyxLocalID, "{{Collectible}} On each floor, it mutates into a different collectible effect")
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
            for i = 1, player:GetCollectibleNum(OnyxLocalID) do
                local newEffect = GetRandomPassiveItem()
                table.insert(data.OnyxItemEffectID, newEffect)
                player:AddCollectible(newEffect)
            end
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

function ShatteredSymbols:ClearInvalidOnyx()
    for pl = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(pl)
        local data = player:GetData()
        if data.OnyxItemEffectID then 
            for i = #data.OnyxItemEffectID, 1, -1 do
                local effectID = data.OnyxItemEffectID[i]
                if Isaac.GetItemConfig():GetCollectibles().Size - 1 < effectID then
                    data.OnyxItemEffectID[i] = rng:RandomInt(Isaac.GetItemConfig():GetCollectibles().Size - 1) + 1
                    player:AddCollectible(data.OnyxItemEffectID[i])
                end
            end
        end
    end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, ShatteredSymbols.OnNewLevelOnyx)
ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, ShatteredSymbols.ClearInvalidOnyx)
