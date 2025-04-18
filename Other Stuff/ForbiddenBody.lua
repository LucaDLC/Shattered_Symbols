local game = Game()
local ForbiddenBodyLocalID = Isaac.GetItemIdByName("Forbidden Body")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(ForbiddenBodyLocalID, "{{EthernalHeart}} Half Eternal Heart count as 2 and can remove 1 Broken Heart #{{BossRoom}} When you enter in the Boss Room for the first time you have 20% to obtain an Half Eternal Heart #{{Player10}} Half Eternal Heart count as Holy Card effect")
end

function ShatteredSymbols:useForbidenBody(player)
    local data = player:GetData()
    local playerType = player:GetPlayerType()
    local currentStage = game:GetLevel():GetStage()
    
    if not data.ForbiddenBodyMantleCounter then data.ForbiddenBodyMantleCounter = 0 end
    if not data.ForbiddenBodyMantlePreviousCounter then data.ForbiddenBodyMantlePreviousCounter = 0 end
    if not data.LastForbiddenBodyStage then data.LastForbiddenBodyStage = currentStage end
    
    if player:GetEternalHearts() == 1 and player:HasCollectible(ForbiddenBodyLocalID) then
        if playerType == PlayerType.PLAYER_THELOST or playerType == PlayerType.PLAYER_THELOST_B then
            player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE, true, 1)
            data.ForbiddenBodyMantleCounter = player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_HOLY_MANTLE)
        else
            player:AddBrokenHearts(-1) 
            player:AddEternalHearts(1) 
        end
    end

    if (playerType == PlayerType.PLAYER_THELOST or playerType == PlayerType.PLAYER_THELOST_B) then
        local currentMantle = player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_HOLY_MANTLE)
        if currentMantle < data.ForbiddenBodyMantleCounter then
            data.ForbiddenBodyMantlePreviousCounter = data.ForbiddenBodyMantleCounter
            data.ForbiddenBodyMantleCounter = currentMantle
        end
        if currentStage ~= data.LastForbiddenBodyStage then
            data.LastForbiddenBodyStage = currentStage
    
            if player:HasCollectible(ForbiddenBodyLocalID) then
                for i = 1, data.ForbiddenBodyMantlePreviousCounter - player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_HOLY_MANTLE) do
                    player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE, true, 1)
                end
                data.ForbiddenBodyMantleCounter = player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_HOLY_MANTLE)
            end
        end
    end
end  

function ShatteredSymbols:holdingForbidenBody(pickup, collider)
    if collider:ToPlayer() then
        local player = collider:ToPlayer()
        local playerType = player:GetPlayerType()
        local data = player:GetData()
        if pickup.Variant == PickupVariant.PICKUP_HEART and 
           pickup.SubType == HeartSubType.HEART_ETERNAL and 
           player:HasCollectible(ForbiddenBodyLocalID) then
            if playerType == PlayerType.PLAYER_THELOST or playerType == PlayerType.PLAYER_THELOST_B then
                player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE, true, 1)
                data.ForbiddenBodyMantleCounter = player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_HOLY_MANTLE)
            else
                player:AddBrokenHearts(-1) 
                player:AddEternalHearts(1)
            end 
        end
    end
end

function ShatteredSymbols:onBossRoomForbidenBody()
    local room = game:GetRoom()
    for playerIndex = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(playerIndex)
        local data = player:GetData()
        if not data.ForbiddenBodyMantleCounter then data.ForbiddenBodyMantleCounter = 0 end

        if data.ForbiddenBodyMantleCounter > 0 then
            for i = 1, data.ForbiddenBodyMantleCounter do
                player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE, true, 1)
            end
        end

        if room:GetType() == RoomType.ROOM_BOSS and room:IsFirstVisit() and player:HasCollectible(ForbiddenBodyLocalID) then
            local playerType = player:GetPlayerType()
            if math.random() <= 0.20 then 
                if playerType == PlayerType.PLAYER_THELOST or playerType == PlayerType.PLAYER_THELOST_B then
                    player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE, true, 1)
                    data.ForbiddenBodyMantleCounter = player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_HOLY_MANTLE)
                else
                    player:AddEternalHearts(1) 
                end
            end
        end
    end
end


ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ShatteredSymbols.useForbidenBody)
ShatteredSymbols:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, ShatteredSymbols.holdingForbidenBody)
ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, ShatteredSymbols.onBossRoomForbidenBody)
