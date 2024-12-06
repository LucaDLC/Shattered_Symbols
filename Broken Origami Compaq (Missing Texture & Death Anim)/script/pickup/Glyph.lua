local game = Game()
local GlyphLocalID = Isaac.GetCardIdByName("Glyph")

if EID then
    EID:addCard(GlyphLocalID, "{{BrokenHeart}} Remove 1 Broken Heart #{{Confusion}} Give Confusion at the enemies in the room for 5 seconds")
end

function BrokenOrigami:UseGlyph(card, player, useFlags)
    if REPENTOGON then
		ItemOverlay.Show(Isaac.GetGiantBookIdByName("Glyph"), 0 , player)
    end
    local room = game:GetRoom()
    local entities = Isaac.GetRoomEntities()

    for _, entity in ipairs(entities) do
        if entity:IsActiveEnemy(false) then
            entity:AddConfusion(EntityRef(player), 150, false)
        end
    end
    if player:GetBrokenHearts() > 0 then
        player:AddBrokenHearts(-1)  
    end
    
end

-- Collega l'effetto della runa al suo utilizzo
BrokenOrigami:AddCallback(ModCallbacks.MC_USE_CARD, BrokenOrigami.UseGlyph, GlyphLocalID)
