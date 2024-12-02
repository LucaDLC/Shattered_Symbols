local game = Game()
local GlyphLocalID = Isaac.GetCardIdByName("Glyph")

if EID then
    EID:addCard(GlyphLocalID, "{{Collectible105}} Reroll all item in the room up to 1 quality #{{BrokenHeart}} Give 2 Broken Heart")
end

function BrokenOrigami:UseGlyph(card, player, useFlags)

    if player:GetBrokenHearts() > 0 then
        player:AddBrokenHearts(-1)  
    end
end

-- Collega l'effetto della runa al suo utilizzo
BrokenOrigami:AddCallback(ModCallbacks.MC_USE_CARD, BrokenOrigami.UseGlyph, GlyphLocalID)
