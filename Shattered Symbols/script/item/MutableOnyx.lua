local game = Game()
local MutableOnyxLocalID = Isaac.GetItemIdByName("Mutable Onyx")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(MutableOnyxLocalID, "{{Collectible}} On each floor, it mutates into a different collectible effect")
end

local function GetRandomPassiveItem()
    local passiveItems = {}
    for id = 1, Isaac.GetItemConfig():GetCollectibles().Size do
        local config = Isaac.GetItemConfig():GetCollectible(id)
        if config and config.Type == ItemType.ITEM_PASSIVE 
        and not config:HasTags(ItemConfig.TAG_QUEST)
        and id ~= MutableOnyxLocalID then 
            table.insert(passiveItems, id)
        end
    end
    if #passiveItems > 0 then return passiveItems[math.random(#passiveItems)] else return nil end
end

function ShatteredSymbols:OnNewLevelMutableOnyx()
    for pl = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(pl)
        local data = player:GetData()
        if not data.MutableOnyxItemEffectID then data.MutableOnyxItemEffectID = {} end
        if player:HasCollectible(MutableOnyxLocalID) then
            for i = #data.MutableOnyxItemEffectID, 1, -1 do
                local effectID = data.MutableOnyxItemEffectID[i]
                if player:HasCollectible(effectID) then
                    player:RemoveCollectible(effectID)
                    local newEffect = GetRandomPassiveItem()
                    data.MutableOnyxItemEffectID[i] = newEffect
                    player:AddCollectible(newEffect)
                else
                    table.remove(data.MutableOnyxItemEffectID, i)
                end
            end
            for i = 1, player:GetCollectibleNum(MutableOnyxLocalID) do
                local newEffect = GetRandomPassiveItem()
                table.insert(data.MutableOnyxItemEffectID, newEffect)
                player:AddCollectible(newEffect)
            end
            while player:HasCollectible(MutableOnyxLocalID) do
                player:RemoveCollectible(MutableOnyxLocalID)
            end
        elseif #data.MutableOnyxItemEffectID > 0 then
            for i = #data.MutableOnyxItemEffectID, 1, -1 do
                local effectID = data.MutableOnyxItemEffectID[i]
                if player:HasCollectible(effectID) then
                    player:RemoveCollectible(effectID)
                    local newEffect = GetRandomPassiveItem()
                    data.MutableOnyxItemEffectID[i] = newEffect
                    player:AddCollectible(newEffect)
                else
                    table.remove(data.MutableOnyxItemEffectID, i)
                end
            end
        end
    end
end

function ShatteredSymbols:ClearInvalidMutableOnyx()
    for pl = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(pl)
        local data = player:GetData()
        if data.MutableOnyxItemEffectID then 
            for i = #data.MutableOnyxItemEffectID, 1, -1 do
                local effectID = data.MutableOnyxItemEffectID[i]
                if Isaac.GetItemConfig():GetCollectibles().Size - 1 < effectID then
                    data.MutableOnyxItemEffectID[i] = rng:RandomInt(Isaac.GetItemConfig():GetCollectibles().Size - 1) + 1
                    player:AddCollectible(data.MutableOnyxItemEffectID[i])
                end
            end
        end
    end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, ShatteredSymbols.OnNewLevelMutableOnyx)
ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, ShatteredSymbols.ClearInvalidMutableOnyx)
