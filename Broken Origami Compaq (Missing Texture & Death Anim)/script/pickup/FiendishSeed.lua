local game = Game()
local FiendishSeedLocalID = Isaac.GetCardIdByName("Fiendish Seed")

if EID then
    EID:addCard(FiendishSeedLocalID, "{{SoulHeart}} Convert your Full Soul Heart in Black Heart")
end

-- Callback per quando il giocatore usa una runa
function BrokenOrigami:useFiendishSeed(card, player, useFlags)
    local soulHearts = player:GetSoulHearts()
    while soulHearts >= 2 do
        -- Rimuovi un Soul Heart
        player:AddSoulHearts(-2)
        player:AddBlackHearts(2)
        soulHearts = soulHearts - 2
    end
        
end

BrokenOrigami:AddCallback(ModCallbacks.MC_USE_CARD, BrokenOrigami.useFiendishSeed, FiendishSeedLocalID)
