local game = Game()
local OrigamiKolibriLocalID = Isaac.GetItemIdByName("Origami Kolibri")
local kolibriTearsCount = 0

-- EID (se usi EID per la descrizione)
if EID then
    EID:assignTransformation("collectible", OrigamiKolibriLocalID, EID.TRANSFORMATION["ORIGAMI"])
    EID:addCollectible(OrigamiKolibriLocalID, "#{{ArrowUp}} After 64 hits, heal half heart {{HalfHeart}} #{{ArrowUp}} Halve the number of hits for each Origami Kolibri #{{ArrowDown}} Gives 1 Broken Hearts {{BrokenHeart}}")
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
            player:AddBrokenHearts(1)
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
            player:AddHearts(1)  -- cura di mezzo cuore
            kolibriTearsCount = 0
        end
    end
end

BrokenOrigami:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, BrokenOrigami.useOrigamiKolibri)
BrokenOrigami:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, BrokenOrigami.onTearDamageOrigamiKolibri)
