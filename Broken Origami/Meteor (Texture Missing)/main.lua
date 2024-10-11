local MeteorMod = RegisterMod("Meteor", 1)
local game = Game()

-- Definisci l'oggetto Meteor
local MeteorItemId = Isaac.GetItemIdByName("Meteor")

if EID then
    EID:addCollectible(MeteorItemId, "{{ArrowUp}} Remove 2 Broken Hearts {{BrokenHeart}}")
end


-- Controlla se il giocatore ha l'oggetto Meteor e avvia il sistema randomico
function MeteorMod:OnUpdate()
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
            player:AddBrokenHearts(-2) -- Remove 2 broken heart
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
MeteorMod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, MeteorMod.OnUpdate)


