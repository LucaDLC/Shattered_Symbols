local glyphRune = {
    ID = Isaac.GetCardIdByName("Glyph"),  
}

function BrokenOrigami:UseGlyph(card, player, useFlags)
    -- Verifica che il giocatore abbia un broken heart da rimuovere
    if player:GetBrokenHearts() > 0 then
        player:AddBrokenHearts(-1)  -- Rimuove un broken heart
        return true  -- Conferma che l'uso è andato a buon fine
    end
    return false  -- Se il giocatore non ha broken heart, la runa non ha effetto
end

-- Collega l'effetto della runa al suo utilizzo
BrokenOrigami:AddCallback(ModCallbacks.MC_USE_CARD, glyphRune.UseGlyph, glyphRune.ID)
