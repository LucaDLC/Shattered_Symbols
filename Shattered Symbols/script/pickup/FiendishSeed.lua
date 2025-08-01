local game = Game()
local FiendishSeedLocalID = Isaac.GetCardIdByName("Fiendish Seed")

-- EID (External Item Descriptions)
if EID then
    EID:addCard(FiendishSeedLocalID, "{{SoulHeart}} Convert your Full Soul Hearts in Black Hearts")
end

function ShatteredSymbols:useFiendishSeed(card, player, useFlags)
    local soulHearts = player:GetSoulHearts()
    while soulHearts >= 2 do
        player:AddSoulHearts(-2)
        player:AddBlackHearts(2)
        soulHearts = soulHearts - 2
    end
        
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_USE_CARD, ShatteredSymbols.useFiendishSeed, FiendishSeedLocalID)
