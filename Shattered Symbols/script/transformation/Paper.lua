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

-- EID (External Item Descriptions)
if EID then
    EID:createTransformation("PaperShattered", "Paper")
    for _, item in ipairs(PAPER_ITEMS) do
        EID:assignTransformation("collectible", item, "PaperShattered")
    end
end

function table.contains(table, element)
    if not table or #table == 0 then
        return false
    end
    for _, value in ipairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

local function HasPaperTransformation(player)
    local count = 0
    local data = player:GetData()
    for _, item in ipairs(PAPER_ITEMS) do
        if player:HasCollectible(item) and not table.contains(data.CapturedActiveItems, item) then
            count = count + player:GetCollectibleNum(item)
        end
        if table.contains(data.CapturedActiveItems, item) then
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
            player:AddCoins(player:GetBrokenHearts() * 5)
        end
    end
end

function ShatteredSymbols:CheckPaperTransformation(player)
    local data = player:GetData()
    if not data.PaperTransformation then data.PaperTransformation = false end
    if not data.CapturedActiveItems then data.CapturedActiveItems = {} end

    if not data.PaperTransformation and HasPaperTransformation(player) then
        Game():GetHUD():ShowItemText("Paper!")
        SFXManager():Play(SoundEffect.SOUND_POWERUP_SPEWER)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, player.Position, Vector.Zero, player)
        data.PaperTransformation = true
    elseif data.PaperTransformation and not HasPaperTransformation(player) then
        data.PaperTransformation = false
    end

    if player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) ~= 0 and not table.contains(data.CapturedActiveItems, player:GetActiveItem(ActiveSlot.SLOT_PRIMARY)) then
        table.insert(data.CapturedActiveItems, player:GetActiveItem(ActiveSlot.SLOT_PRIMARY))
    end
    if player:GetActiveItem(ActiveSlot.SLOT_SECONDARY) ~= 0 and not table.contains(data.CapturedActiveItems, player:GetActiveItem(ActiveSlot.SLOT_SECONDARY)) then
        table.insert(data.CapturedActiveItems, player:GetActiveItem(ActiveSlot.SLOT_SECONDARY))
    end
    if player:GetActiveItem(ActiveSlot.SLOT_POCKET) ~= 0 and not table.contains(data.CapturedActiveItems, player:GetActiveItem(ActiveSlot.SLOT_POCKET)) then
        table.insert(data.CapturedActiveItems, player:GetActiveItem(ActiveSlot.SLOT_POCKET))
    end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ShatteredSymbols.CheckPaperTransformation)
ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, ShatteredSymbols.PaperTransformation)