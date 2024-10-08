local game = Game()
local UpsideDownDeckofCardsLocalID = Isaac.GetItemIdByName("Upside Down Deck of Cards")

--EID
if EID then
    EID:addCollectible(UpsideDownDeckofCardsLocalID, "{{Card}} Spawns 1 reverse card")
end

-- Definisci la funzione per l'utilizzo dell'item
function BrokenOrigami:useUpsideDownDeckCard()
    local player = Isaac.GetPlayer(0)
    local reverseCards = {
        Card.CARD_REVERSE_FOOL, Card.CARD_REVERSE_MAGICIAN, Card.CARD_REVERSE_HIGH_PRIESTESS,
        Card.CARD_REVERSE_EMPRESS, Card.CARD_REVERSE_EMPEROR, Card.CARD_REVERSE_HIEROPHANT,
        Card.CARD_REVERSE_LOVERS, Card.CARD_REVERSE_CHARIOT, Card.CARD_REVERSE_JUSTICE,
        Card.CARD_REVERSE_HERMIT, Card.CARD_REVERSE_WHEEL_OF_FORTUNE, Card.CARD_REVERSE_STRENGTH,
        Card.CARD_REVERSE_HANGED_MAN, Card.CARD_REVERSE_DEATH, Card.CARD_REVERSE_TEMPERANCE,
        Card.CARD_REVERSE_DEVIL, Card.CARD_REVERSE_TOWER, Card.CARD_REVERSE_STARS,
        Card.CARD_REVERSE_MOON, Card.CARD_REVERSE_SUN, Card.CARD_REVERSE_JUDGEMENT,
        Card.CARD_REVERSE_WORLD
    }

    -- Droppa una carta casuale dal pool delle carte reverse
    local card = reverseCards[math.random(#reverseCards)]
    player:AddCard(card)
    return {
        Discharge = true,
        Remove = false,
        ShowAnim = true
    }
end

-- Associa la funzione all'item
BrokenOrigami:AddCallback(ModCallbacks.MC_USE_ITEM, BrokenOrigami.useUpsideDownDeckCard, UpsideDownDeckofCardsLocalID)

-- Imposta l'item con 6 cariche
BrokenOrigami:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function(_, player)
    player:SetActiveCharge(6, ActiveSlot.SLOT_PRIMARY)
end)
