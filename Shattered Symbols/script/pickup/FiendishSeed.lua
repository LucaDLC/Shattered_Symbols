local game = Game()
local FiendishSeedLocalID = Isaac.GetCardIdByName("Fiendish Seed")

if EID then
    EID:addCard(FiendishSeedLocalID, "{{SoulHeart}} Convert your Full Soul Heart in Black Heart")
end

-- Callback per quando il giocatore usa una runa
function ShatteredSymbols:useFiendishSeed(card, player, useFlags)
    local soulHearts = player:GetSoulHearts()
    while soulHearts >= 2 do
        -- Rimuovi un Soul Heart
        player:AddSoulHearts(-2)
        player:AddBlackHearts(2)
        soulHearts = soulHearts - 2
    end
        
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_USE_CARD, ShatteredSymbols.useFiendishSeed, FiendishSeedLocalID)
