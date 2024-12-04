local game = Game()
local TeaBagLocalID = Isaac.GetCardIdByName("Tea Bag")

if EID then
    EID:addCard(TeaBagLocalID, "{{AngelRoom}} Adds a percentage to the opening of the Angel Room equal to Luck")
end

-- Callback per quando il giocatore usa una runa
function BrokenOrigami:useTeaBag(card, player, useFlags)

    local luck = player.Luck
    local level = game:GetLevel()
    print(luck/100)
    
    level:AddAngelRoomChance(luck/100)
        
end

BrokenOrigami:AddCallback(ModCallbacks.MC_USE_CARD, BrokenOrigami.useTeaBag, TeaBagLocalID)
