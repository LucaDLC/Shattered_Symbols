local glyphMod = RegisterMod("Glyph Mod", 1)
local glyphRuneID = Isaac.GetItemIdByName("Glyph")

if EID then
    EID:addCollectible(glyphRuneID, "Remove 1 Broken Heart {{BrokenHeart}}", "Glyph")
end

-- Aggiunta della nuova runa Glyph
local glyphRune = {
    ID = glyphRuneID,
    Name = "Glyph",
    Type = "Rune",
    Description = "Brighten your destiny"
}

-- Callback per quando il giocatore usa una runa
function glyphMod:onUseCard(cardID, player, useFlags)
    if cardID == glyphRuneID then
        local brokenHearts = player:GetBrokenHearts()
        if brokenHearts > 0 then
            player:AddBrokenHearts(-1)  -- Rimuove un broken heart
        end 
    end
    
end

-- Registrazione del callback
glyphMod:AddCallback(ModCallbacks.MC_USE_CARD, glyphMod.onUseCard)


