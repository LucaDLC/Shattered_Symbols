local game = Game()
local MeteorLocalID = Isaac.GetItemIdByName("Meteor")

if EID then
    EID:addCollectible(MeteorLocalID, "{{ArrowUp}} Remove 2 Broken Hearts {{BrokenHeart}} #{{ArrowUp}} If you have 1 Broken Hearts {{BrokenHeart}} remove it and gain 1 Black Heart {{BlackHeart}} #{{ArrowUp}} If you don't have Broken Hearts {{BrokenHeart}} gain 3 Black Heart {{BlackHeart}}")
end

-- Controlla se il giocatore ha l'oggetto Meteor e avvia il sistema randomico
function BrokenOrigami:useMeteor(player)
    -- Get the player's data table
    local data = player:GetData()
    
    -- Initialize the MeteorCounter if it doesn't exist
    if not data.MeteorCounter then
        data.MeteorCounter = 0
        data.MeteorRelative = 0
        data.MeteorPreviousCounter = 1
    end

    -- Check if the player has picked up the item
    if player:HasCollectible(MeteorLocalID) then
        -- Increase the counter
        data.MeteorCounter = player:GetCollectibleNum(MeteorLocalID)
        
        -- Apply the effect based on the number of items picked up
        if data.MeteorCounter >= data.MeteorPreviousCounter then
            data.MeteorPreviousCounter = data.MeteorPreviousCounter + 1
            data.MeteorRelative = data.MeteorRelative + 1
            if player:GetBrokenHearts() >= 2 then
                player:AddBrokenHearts(-2) -- Remove 2 broken heart
            elseif player:GetBrokenHearts() == 1 then
                player:AddBrokenHearts(-1)
                player:AddBlackHearts(2)
            elseif player:GetBrokenHearts() == 0 then
                player:AddBlackHearts(6)
            end
        end
    else
        data.MeteorCounter = 0
        data.MeteorPreviousCounter = 1
    end
    if data.MeteorRelative > data.MeteorCounter then
        data.MeteorPreviousCounter = data.MeteorCounter +1
    end
end

-- Registra la funzione di aggiornamento
BrokenOrigami:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, BrokenOrigami.useMeteor)


