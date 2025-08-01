local game = Game()
local TeaBagLocalID = Isaac.GetCardIdByName("Tea Bag")

-- EID (External Item Descriptions)
if EID then
    EID:addCard(TeaBagLocalID, "{{AngelRoom}} Converts Devil Room chance into Angel Room chance for this floor. #{{DevilRoom}} Still works after making Devil deals, but doesn't restore or improve Angel Room spawn rate.")
end

function ShatteredSymbols:useTeaBag(card, player, useFlags)
    local level = game:GetLevel()
    
    level:AddAngelRoomChance(1)
        
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_USE_CARD, ShatteredSymbols.useTeaBag, TeaBagLocalID)
