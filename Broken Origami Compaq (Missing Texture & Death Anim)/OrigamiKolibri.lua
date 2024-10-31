local game = Game()
local OrigamiKolibriLocalID = Isaac.GetItemIdByName("Origami Kolibri")
local kolibriTearsCount = 0

-- EID (se usi EID per la descrizione)
if EID then
    EID:assignTransformation("collectible", OrigamiKolibriLocalID, EID.TRANSFORMATION["ORIGAMI"])
    EID:addCollectible(OrigamiKolibriLocalID, "#{{ArrowUp}} After 64 hits, heal half heart {{HalfHeart}} #{{ArrowUp}} Halve the number of hits for each Origami Kolibri #{{ArrowUp}} +0.2 Speed {{Speed}} #{{ArrowDown}} Gives 1 Broken Hearts {{BrokenHeart}}")
end

function BrokenOrigami:useOrigamiKolibri(player)
    -- Get the player's data table
    local data = player:GetData()
    
    -- Initialize the OrigamiKolibriCounter if it doesn't exist
    if not data.OrigamiKolibriCounter then
        data.OrigamiKolibriCounter = 0
        data.OrigamiKolibriRelative = 0
        data.OrigamiKolibriPreviousCounter = 1
    end

    -- Check if the player has picked up the item
    if player:HasCollectible(OrigamiKolibriLocalID) then
        -- Increase the counter
        data.OrigamiKolibriCounter = player:GetCollectibleNum(OrigamiKolibriLocalID)
        
        -- Apply the effect based on the number of items picked up
        if data.OrigamiKolibriCounter >= data.OrigamiKolibriPreviousCounter then
            data.OrigamiKolibriPreviousCounter = data.OrigamiKolibriPreviousCounter + 1
            data.OrigamiKolibriRelative = data.OrigamiKolibriRelative + 1
            kolibriTearsCount = 0
            data.OrigamiKolibriSpeedBoost = 0.2*data.OrigamiKolibriRelative
            player:AddBrokenHearts(1)
            player:AddCacheFlags(CacheFlag.CACHE_SPEED)
            player:EvaluateItems()
        end
    else
        data.OrigamiKolibriCounter = 0
        data.OrigamiKolibriPreviousCounter = 1
    end
    if data.OrigamiKolibriRelative > data.OrigamiKolibriCounter then
        data.OrigamiKolibriPreviousCounter = data.OrigamiKolibriCounter +1
    end
end

function BrokenOrigami:onTearDamageOrigamiKolibri(entity, damageAmount, damageFlags, source, countdownFrames)
    local player = Isaac.GetPlayer(0)
    if entity:IsEnemy() and player:HasCollectible(OrigamiKolibriLocalID) and source.Type == EntityType.ENTITY_TEAR then
        kolibriTearsCount = kolibriTearsCount + 1
        local OrigamiKolibrisCounter = player:GetCollectibleNum(OrigamiKolibriLocalID)
        if OrigamiKolibrisCounter > 7 then
            OrigamiKolibrisCounter = 7
        end
        if kolibriTearsCount >= (128 / 2^OrigamiKolibrisCounter) then
            kolibriTearsCount = 0
            if not (player:GetHearts() >= player:GetMaxHearts()) then
                player:AddHearts(1)  -- cura di mezzo cuore
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEART, 0, player.Position + Vector(0, -75), Vector(0,0), player)
                SFXManager():Play(SoundEffect.SOUND_VAMP_GULP)
            end
        end
    end
end

function BrokenOrigami:onEvaluateCacheOrigamiKolibri(player, cacheFlag)
    local data = player:GetData()
    if cacheFlag == CacheFlag.CACHE_SPEED then
        if data.OrigamiKolibriSpeedBoost then
            player.MoveSpeed = player.MoveSpeed + data.OrigamiKolibriSpeedBoost
        end
    end
end

BrokenOrigami:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, BrokenOrigami.useOrigamiKolibri)
BrokenOrigami:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, BrokenOrigami.onTearDamageOrigamiKolibri)
BrokenOrigami:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, BrokenOrigami.onEvaluateCacheOrigamiKolibri)
