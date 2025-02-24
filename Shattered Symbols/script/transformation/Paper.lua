local game = Game()

-- Lista degli oggetti che compongono l'evoluzione
local PAPER_ITEMS = {
    Isaac.GetItemIdByName("Origami Crow"),
    Isaac.GetItemIdByName("Origami Bat"),
    Isaac.GetItemIdByName("Origami Kolibri"),
    Isaac.GetItemIdByName("Origami Swan"),
    Isaac.GetItemIdByName("Origami Boat"),
    Isaac.GetItemIdByName("Origami Shuriken"),
    Isaac.GetItemIdByName("Fortune Teller")
}


if EID then
    EID:createTransformation("PaperShattered", "Paper")
    for _, item in ipairs(PAPER_ITEMS) do
        EID:assignTransformation("collectible", item, "PaperShattered")
    end
end


local function HasPaperTransformation(player)
    local count = 0
    for _, item in ipairs(PAPER_ITEMS) do
        if player:HasCollectible(item) then
            count = count + 1
        end
    end
    return count >= 3
end

function ShatteredSymbols:PaperTransformation()
    for playerIndex = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(playerIndex)
        local data = player:GetData()
        if HasPaperTransformation(player) and data.PaperTransformation then
            player:AddBlackHearts(1)
        end
    end
end

function ShatteredSymbols:CheckPaperTransformation(player)
    local data = player:GetData()
    if not data.PaperTransformation then data.PaperTransformation = false end
    if not data.PaperTransformation and HasPaperTransformation(player) then
        Game():GetHUD():ShowItemText("Paper!")
        SFXManager():Play(SoundEffect.SOUND_POWERUP_SPEWER)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, player.Position, Vector.Zero, player)
        data.PaperTransformation = true
    elseif data.PaperTransformation and not HasPaperTransformation(player) then
        data.PaperTransformation = false
    end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ShatteredSymbols.CheckPaperTransformation)
ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, ShatteredSymbols.PaperTransformation)