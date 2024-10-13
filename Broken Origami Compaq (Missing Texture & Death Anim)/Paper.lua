local PaperSettings = {
    --PaperTexture = Isaac.GetCostumeIdByPath("gfx/characters/costume_PaperTransformation.anm2"), -- Assicurati che il percorso sia corretto
    isPaper = false,
    PaperItems = {
        "Fortune Teller", 
        "Origami Boat", 
        "Origami Shuriken", 
        "Shawty's Letter", 
        "Torn Hook"
    }
}

-- Funzione per ottenere l'ID di un oggetto in base al nome
function BrokenOrigami:GetItemIdByName(itemName)
    return Isaac.GetItemIdByName(itemName)
end

function BrokenOrigami:HasPaperTransformation(player)
    local itemCount = 0

    -- Controlla se il giocatore possiede gli oggetti specificati
    for _, itemName in ipairs(PaperSettings.PaperItems) do
        local itemId = BrokenOrigami:GetItemIdByName(itemName)
        if player:GetCollectibleNum(itemId, false) > 0 then
            itemCount = itemCount + 1
        end
    end

    -- Verifica se ha almeno 3 oggetti della lista
    return itemCount >= 3
end

function BrokenOrigami:ApplyPaperTransformation(player)
    if not PaperSettings.isPaper then
        player:AddNullCostume(PaperSettings.PaperTexture)
        PaperSettings.isPaper = true
        -- Puoi aggiungere ulteriori bonus qui
    end
end

function BrokenOrigami:RemovePaperTransformation(player)
    if PaperSettings.isPaper then
        player:TryRemoveNullCostume(PaperSettings.PaperTexture)
        PaperSettings.isPaper = false
    end
end

function BrokenOrigami:PaperTransformation(player)
    if BrokenOrigami:HasPaperTransformation(player) then
        BrokenOrigami:ApplyPaperTransformation(player)
    else
        BrokenOrigami:RemovePaperTransformation(player)
    end
end

-- Callback per verificare la trasformazione ad ogni aggiornamento
BrokenOrigami:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    BrokenOrigami:PaperTransformation(player)
end)
