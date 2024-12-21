local game = Game()
local UpsideDownDeckofCardsLocalID = Isaac.GetItemIdByName("Upside Down Deck of Cards")
local DeckofCardID = Isaac.GetItemIdByName("Deck of Cards")

--EID
if EID then
    EID:addCollectible(UpsideDownDeckofCardsLocalID, "{{Card}} Spawns 1 reverse card #{{Collectible85}} After use it goes back to being the Deck of Cards")
end

-- Definisci la funzione per l'utilizzo dell'item
function ShatteredSymbols:useUpsideDownDeckCard(_, rng, player)
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
    for i = 0, 3 do
        local activeItem = player:GetActiveItem(i)
        if activeItem == UpsideDownDeckofCardsLocalID then
            player:RemoveCollectible(UpsideDownDeckofCardsLocalID, false, i)
            player:AddCollectible(DeckofCardID, 0, false, i)
        end
    end
    return {
        Discharge = true,
        Remove = false,
        ShowAnim = true
    }
end

function ShatteredSymbols:removeUpsideDownDeckofCardsFromPool()
    Game():GetItemPool():RemoveCollectible(UpsideDownDeckofCardsLocalID)
end

function ShatteredSymbols:mutateUpsideDownDeck(_, rng, player)
    local mutateValue = rng:RandomFloat()
    if mutateValue > 0.925 then
        for i = 0, 3 do
            local activeItem = player:GetActiveItem(i)
            if activeItem == DeckofCardID then
                player:RemoveCollectible(DeckofCardID, false, i)
                player:AddCollectible(UpsideDownDeckofCardsLocalID, 0, false, i)
            end
        end
    end
end

function ShatteredSymbols:UpsideDownWispInit(wisp)
	if  wisp.Player and wisp.Player:HasCollectible(UpsideDownDeckofCardsLocalID) then
		if wisp.SubType == UpsideDownDeckofCardsLocalID then
			wisp.SubType = 85
		end
	end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, ShatteredSymbols.UpsideDownWispInit, FamiliarVariant.WISP)
ShatteredSymbols:AddCallback(ModCallbacks.MC_USE_ITEM, ShatteredSymbols.useUpsideDownDeckCard, UpsideDownDeckofCardsLocalID)
ShatteredSymbols:AddCallback(ModCallbacks.MC_USE_ITEM, ShatteredSymbols.mutateUpsideDownDeck, DeckofCardID)
ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, ShatteredSymbols.removeUpsideDownDeckofCardsFromPool)

