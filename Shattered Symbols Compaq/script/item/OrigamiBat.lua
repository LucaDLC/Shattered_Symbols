
local game = Game()
local OrigamiBatLocalID = Isaac.GetItemIdByName("Origami Bat")

-- EID (se usi EID per la descrizione)
if EID then
    EID:assignTransformation("collectible", OrigamiBatLocalID, EID.TRANSFORMATION["ORIGAMI"])
    EID:addCollectible(OrigamiBatLocalID, "#{{ArrowUp}} After 64 hits, heal half heart {{HalfHeart}} #{{ArrowUp}} Halve the number of hits for each Origami Bat #{{ArrowUp}} +0.1 Speed {{Speed}} #{{ArrowDown}} Gives 1 Broken Hearts which does not replace Heart{{BrokenHeart}}")
end

function ShatteredSymbols:useOrigamiBat(player)
    -- Get the player's data table
    local data = player:GetData()
    local OrigamiBatCounter = player:GetCollectibleNum(OrigamiBatLocalID)

    if not data.OrigamiBatTearsCount then data.OrigamiBatTearsCount = 0 end
    if not data.OrigamiBatRelative then data.OrigamiBatRelative = 0 end
    if not data.OrigamiBatPreviousCounter then data.OrigamiBatPreviousCounter = 1 end
    if not data.OrigamiBatSpeedBoost then data.OrigamiBatSpeedBoost = 0 end
    if not data.OrigamiBatLimit then data.OrigamiBatLimit = 0 end

    -- Check if the player has picked up the item
    if player:HasCollectible(OrigamiBatLocalID) then
        
        -- Apply the effect based on the number of items picked up
        if OrigamiBatCounter >= data.OrigamiBatPreviousCounter then
            data.OrigamiBatPreviousCounter = data.OrigamiBatPreviousCounter + 1
            data.OrigamiBatRelative = data.OrigamiBatRelative + 1
            data.OrigamiBatTearsCount = 0
            data.OrigamiBatSpeedBoost = 0.1*data.OrigamiBatRelative
            player:AddBrokenHearts(1)
            player:AddCacheFlags(CacheFlag.CACHE_SPEED)
            player:EvaluateItems()
        end
    else
        OrigamiBatCounter = 0
        data.OrigamiBatPreviousCounter = 1
    end
    if data.OrigamiBatRelative > OrigamiBatCounter then
        data.OrigamiBatPreviousCounter = OrigamiBatCounter +1
    end
end

function ShatteredSymbols:onTearDamageOrigamiBat(entity, damageAmount, damageFlags, source, countdownFrames)
    for playerIndex = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(playerIndex)
        local data = player:GetData()
        if entity:IsEnemy() and player:HasCollectible(OrigamiBatLocalID) and source.Type == EntityType.ENTITY_TEAR then
            data.OrigamiBatTearsCount = data.OrigamiBatTearsCount + 1
            data.OrigamiBatLimit = player:GetCollectibleNum(OrigamiBatLocalID)
            if data.OrigamiBatLimit > 7 then
                data.OrigamiBatLimit = 7
            end
            if data.OrigamiBatTearsCount >= (128 / 2^data.OrigamiBatLimit) then
                data.OrigamiBatTearsCount = 0
                if not (player:GetHearts() >= player:GetEffectiveMaxHearts()) then
                    player:AddHearts(1)  -- cura di mezzo cuore
                    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEART, 0, player.Position + Vector(0, -75), Vector(0,0), player)
                    SFXManager():Play(SoundEffect.SOUND_VAMP_GULP)
                end
            end
        end
    end
end

function ShatteredSymbols:onEvaluateCacheOrigamiBat(player, cacheFlag)
    local data = player:GetData()
    if cacheFlag == CacheFlag.CACHE_SPEED then
        if data.OrigamiBatSpeedBoost then
            player.MoveSpeed = player.MoveSpeed + data.OrigamiBatSpeedBoost
        end
    end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ShatteredSymbols.useOrigamiBat)
ShatteredSymbols:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, ShatteredSymbols.onTearDamageOrigamiBat)
ShatteredSymbols:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, ShatteredSymbols.onEvaluateCacheOrigamiBat)
