local game = Game()
local OrigamiShurikenLocalID = Isaac.GetItemIdByName("Origami Shuriken")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(OrigamiShurikenLocalID, "{{DamageSmall}} +3 Damage #{{BrokenHeart}} Gives 1 Broken Heart which replaces Hearts in this order {{Heart}}{{BoneHeart}}{{SoulHeart}}{{BlackHeart}}")
end

local function BrokenHeartRemovingSystem(player)
    local slotRemoved = false

    if player:GetMaxHearts() >= 2 and not slotRemoved then
        player:AddMaxHearts(-2)  
        slotRemoved = true
    end

    if not slotRemoved and player:GetBoneHearts() >= 1 then
        player:AddBoneHearts(-1) 
        slotRemoved = true
    end

    if not slotRemoved and player:GetSoulHearts() >= 2 then
        player:AddSoulHearts(-2)  
        slotRemoved = true
    end

    if not slotRemoved and player:GetBlackHearts() >= 2 then
        player:AddBlackHearts(-2)  
        slotRemoved = true
    end

    player:AddBrokenHearts(1)

end

function ShatteredSymbols:useOrigamiShuriken(player)
    local data = player:GetData()
    local OrigamiShurikenCounter = player:GetCollectibleNum(OrigamiShurikenLocalID)

    if not data.OrigamiShurikenRelative then data.OrigamiShurikenRelative = 0 end
    if not data.OrigamiShurikenPreviousCounter then data.OrigamiShurikenPreviousCounter = 1 end
    if not data.OrigamiShurikenDamageBoost then data.OrigamiShurikenDamageBoost = 0 end

    if player:HasCollectible(OrigamiShurikenLocalID) then
        
        if OrigamiShurikenCounter >= data.OrigamiShurikenPreviousCounter then
            data.OrigamiShurikenPreviousCounter = data.OrigamiShurikenPreviousCounter + 1
            data.OrigamiShurikenRelative = data.OrigamiShurikenRelative + 1
            BrokenHeartRemovingSystem(player) 
            data.OrigamiShurikenDamageBoost = 3*data.OrigamiShurikenRelative 
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            player:EvaluateItems()
        end
    else
        OrigamiShurikenCounter = 0
        data.OrigamiShurikenPreviousCounter = 1
    end
    if data.OrigamiShurikenRelative > OrigamiShurikenCounter then
        data.OrigamiShurikenPreviousCounter = OrigamiShurikenCounter +1
    end
end

function ShatteredSymbols:onEvaluateCacheOrigamiShuriken(player, cacheFlag)
    local data = player:GetData()
    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        if data.OrigamiShurikenDamageBoost then
            player.Damage = player.Damage + data.OrigamiShurikenDamageBoost
        end
    end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ShatteredSymbols.useOrigamiShuriken)
ShatteredSymbols:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, ShatteredSymbols.onEvaluateCacheOrigamiShuriken)
