local game = Game()
local PallasLocalID = Isaac.GetItemIdByName("Pallas")
local MutableOnyxExternalID = Isaac.GetItemIdByName("Mutable Onyx")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(PallasLocalID, "{{Room}} After clearyng a room you have 5% of chance to substitute a not Volatile Item with an Mutable Onyx #{{Crown}} Occasionally, give one of these: #{{Bomb}} 1 Bomb #{{Key}} 1 Key #{{Coin}} 3 Coins #{{ArrowUp}} Both effects increasing with numbers of Pallas you have")
end

local itemIgnoreList = {
    238, 239, 550, 551, 626, 627, 668
}

local itemIgnoreSet = {}
for _, v in ipairs(itemIgnoreList) do
    itemIgnoreSet[v] = true
end

local function triggerPallas(player)
    local randomReward = math.random(1, 3)

    if randomReward == 1 then
        player:AddBombs(1)
    elseif randomReward == 2 then
        player:AddKeys(1)
    elseif randomReward == 3 then
        player:AddCoins(3)
    end
    
end

function ShatteredSymbols:PallasEffect(player)
    local data = player:GetData()

    if player:HasCollectible(PallasLocalID) then
        local numberOfPallas = player:GetCollectibleNum(PallasLocalID)
        if numberOfPallas > 0 then
            local randomValue = math.random(1, math.floor(1024 / (2*numberOfPallas)))
        
            if randomValue == 1 then
                triggerPallas(player)  
            end
        end
    end
end

function ShatteredSymbols:PallasRoomEffect()
    for p = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(p)
        local data = player:GetData()
        if player:HasCollectible(PallasLocalID) and (math.random() < (0.05 * player:GetCollectibleNum(PallasLocalID))) then
            local eligibleItems = {}
            local mutableSet = {}

            if data.MutableOnyxItemEffectID then
                for _, id in ipairs(data.MutableOnyxItemEffectID) do
                    mutableSet[id] = true
                end
            end

            for id = 1, Isaac.GetItemConfig():GetCollectibles().Size do
                local itemConfig = Isaac.GetItemConfig():GetCollectible(id)
                if itemConfig and id ~= PallasLocalID and id ~= MutableOnyxExternalID and not itemIgnoreSet[id] and not mutableSet[id] and player:HasCollectible(id) and itemConfig.Type == ItemType.ITEM_PASSIVE then
                    table.insert(eligibleItems, id)
                end
            end

            if #eligibleItems > 0 then
                local itemToRemove = eligibleItems[math.random(1, #eligibleItems)]
                player:RemoveCollectible(itemToRemove)
                player:AddCollectible(MutableOnyxExternalID, 0, false)
                
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, player.Position, Vector(0,0), player)
                SFXManager():Play(SoundEffect.SOUND_1UP)
            end
        end
    end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ShatteredSymbols.PallasEffect)
ShatteredSymbols:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, ShatteredSymbols.PallasRoomEffect)
