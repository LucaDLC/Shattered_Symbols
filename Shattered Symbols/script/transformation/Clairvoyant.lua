local game = Game()

-- Lista degli oggetti che compongono l'evoluzione
local CLAIRVOYANT_ITEMS = {
    CollectibleType.COLLECTIBLE_DECK_OF_CARDS,
    CollectibleType.COLLECTIBLE_BOOSTER_PACK,
    CollectibleType.COLLECTIBLE_STARTER_DECK,
    CollectibleType.COLLECTIBLE_TAROT_CLOTH,
    CollectibleType.COLLECTIBLE_BLANK_CARD,
    CollectibleType.COLLECTIBLE_CRYSTAL_BALL,
    Isaac.GetItemIdByName("Extra Deck of Cards"),
    Isaac.GetItemIdByName("Upside Down Deck of Cards")
}

local CARDS_LIST = {
    Card.CARD_REVERSE_FOOL, Card.CARD_REVERSE_MAGICIAN, Card.CARD_REVERSE_HIGH_PRIESTESS,
    Card.CARD_REVERSE_EMPRESS, Card.CARD_REVERSE_EMPEROR, Card.CARD_REVERSE_HIEROPHANT,
    Card.CARD_REVERSE_LOVERS, Card.CARD_REVERSE_CHARIOT, Card.CARD_REVERSE_JUSTICE,
    Card.CARD_REVERSE_HERMIT, Card.CARD_REVERSE_WHEEL_OF_FORTUNE, Card.CARD_REVERSE_STRENGTH,
    Card.CARD_REVERSE_HANGED_MAN, Card.CARD_REVERSE_DEATH, Card.CARD_REVERSE_TEMPERANCE,
    Card.CARD_REVERSE_DEVIL, Card.CARD_REVERSE_TOWER, Card.CARD_REVERSE_STARS,
    Card.CARD_REVERSE_MOON, Card.CARD_REVERSE_SUN, Card.CARD_REVERSE_JUDGEMENT,
    Card.CARD_REVERSE_WORLD, Card.CARD_FOOL, Card.CARD_MAGICIAN, Card.CARD_HIGH_PRIESTESS,
    Card.CARD_EMPRESS, Card.CARD_EMPEROR, Card.CARD_HIEROPHANT,
    Card.CARD_LOVERS, Card.CARD_CHARIOT, Card.CARD_JUSTICE,
    Card.CARD_HERMIT, Card.CARD_WHEEL_OF_FORTUNE, Card.CARD_STRENGTH,
    Card.CARD_HANGED_MAN, Card.CARD_DEATH, Card.CARD_TEMPERANCE,
    Card.CARD_DEVIL, Card.CARD_TOWER, Card.CARD_STARS,
    Card.CARD_MOON, Card.CARD_SUN, Card.CARD_JUDGEMENT,
    Card.CARD_WORLD, Card.CARD_CLUBS_2, Card.CARD_DIAMONDS_2, Card.CARD_SPADES_2,
    Card.CARD_HEARTS_2, Card.CARD_ACE_OF_CLUBS, Card.CARD_ACE_OF_DIAMONDS,
    Card.CARD_ACE_OF_SPADES, Card.CARD_ACE_OF_HEARTS, Card.CARD_JOKER,
    Card.CARD_SUICIDE_KING, Card.CARD_QUEEN_OF_HEARTS, Card.CARD_CHAOS,
    Card.CARD_HUGE_GROWTH, Card.CARD_ANCIENT_RECALL, Card.CARD_ERA_WALK,
    Card.CARD_CREDIT, Card.CARD_RULES, Card.CARD_QUESTIONMARK,
    Card.CARD_HUMANITY, Card.CARD_GET_OUT_OF_JAIL, Card.CARD_HOLY, Card.CARD_WILD, Card.CARD_EMERGENCY_CONTACT
}

if EID then
    EID:createTransformation("ClairvoyantShattered", "Clairvoyant")
    for _, item in ipairs(CLAIRVOYANT_ITEMS) do
        EID:assignTransformation("collectible", item, "ClairvoyantShattered")
    end
end

function table.contains(table, element)
    for _, value in ipairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

local function HasClairvoyantTransformation(player)
    local count = 0
    local data = player:GetData()
    for _, item in ipairs(CLAIRVOYANT_ITEMS) do
        if data.CapturedActiveItems == {} then
            if player:HasCollectible(item) then
                count = count + 1
            end
        else
            if player:HasCollectible(item) or table.contains(data.CapturedActiveItems, item) then
                count = count + 1
            end
        end
    end
    return count >= 3
end

function ShatteredSymbols:ClairvoyantTransformation()
    for playerIndex = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(playerIndex)
        local data = player:GetData()
        if HasClairvoyantTransformation(player) and data.ClairvoyantTransformation then
            player:AddSoulHearts(1)
            local selectedCard = CARDS_LIST[math.random(#CARDS_LIST)]
        
            local position = game:GetRoom():GetCenterPos()
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, selectedCard, position + Vector(0, 40), Vector.Zero, nil)
        end
    end
end

function ShatteredSymbols:CheckClairvoyantTransformation(player)
    local data = player:GetData()
    if not data.ClairvoyantTransformation then data.ClairvoyantTransformation = false end
    if not data.CapturedActiveItems then data.CapturedActiveItems = {} end

    if not data.ClairvoyantTransformation and HasClairvoyantTransformation(player) then
        Game():GetHUD():ShowItemText("Clairvoyant!")
        SFXManager():Play(SoundEffect.SOUND_POWERUP_SPEWER)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, player.Position, Vector.Zero, player)
        data.ClairvoyantTransformation = true
    elseif data.ClairvoyantTransformation and not HasClairvoyantTransformation(player) then
        data.ClairvoyantTransformation = false
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

ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ShatteredSymbols.CheckClairvoyantTransformation)
ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, ShatteredSymbols.ClairvoyantTransformation)