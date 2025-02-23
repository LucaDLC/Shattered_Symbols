local game = Game()

-- Lista degli oggetti che compongono l'evoluzione
local PAPER_ITEMS = {
    CollectibleType.COLLECTIBLE_THE_PACT,
    CollectibleType.COLLECTIBLE_MISSING_PAGE_2,
    CollectibleType.COLLECTIBLE_CONTRACT_FROM_BELOW,
    CollectibleType.COLLECTIBLE_DEATHS_LIST,
    CollectibleType.COLLECTIBLE_DIVORCE_PAPERS,
    Isaac.GetItemIdByName("Origami Crow"),
    Isaac.GetItemIdByName("Origami Bat"),
    Isaac.GetItemIdByName("Origami Kolibri"),
    Isaac.GetItemIdByName("Torn Hook"),
    Isaac.GetItemIdByName("Origami Swan"),
    Isaac.GetItemIdByName("Origami Boat"),
    Isaac.GetItemIdByName("Origami Shuriken"),
    Isaac.GetItemIdByName("Fortune Teller")
}


if EID then
    EID:createTransformation("PaperShattered", "Paper")
    for _, item in ipairs(CLAIRVOYANT_ITEMS) then
        EID:assignTransformation("collectible", item, "PaperShattered")
    end
end


local function HasPaperEvolution(player)
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
        if HasPaperEvolution(player) then
            Game():GetHUD():ShowItemText("Paper!")
            SFXManager():Play(SoundEffect.SOUND_POWERUP_SPEWER)
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, p.Position, Vector.Zero, p)
            player:AddBlackHearts(2)
        end
    end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, ShatteredSymbols.PaperTransformation)