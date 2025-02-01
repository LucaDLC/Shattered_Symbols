local game = Game()
local TeaBagLocalID = Isaac.GetCardIdByName("Tea Bag")

if EID then
    EID:addCard(TeaBagLocalID, "{{AngelRoom}} Convert the percentage to the opening of the Devil Room into the Angel Room #{{DevilRoom}} It's works even if satanic pacts were made but only for the current floor, it doesn't give back the possibility of increase or restore chance of spawning Angel Room")
end

-- Callback per quando il giocatore usa una runa
function ShatteredSymbols:useTeaBag(card, player, useFlags)
    local level = game:GetLevel()
    
    level:AddAngelRoomChance(1)
        
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_USE_CARD, ShatteredSymbols.useTeaBag, TeaBagLocalID)
