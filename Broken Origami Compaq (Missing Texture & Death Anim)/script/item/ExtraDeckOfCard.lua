local game = Game()
local ExtraDeckLocalID = Isaac.GetItemIdByName("Extra Deck of Cards")
local DeckofCardID = Isaac.GetItemIdByName("Deck of Cards")

-- EID
if EID then
    EID:addCollectible(ExtraDeckLocalID, "{{RedCard}} Spawns 1 special card #{{Collectible85}} After use it goes back to being the Deck of Cards")
end

-- Lista delle carte speciali con dorso rosso
local specialCards = {
    Card.CARD_CLUBS_2, Card.CARD_DIAMONDS_2, Card.CARD_SPADES_2,
    Card.CARD_HEARTS_2, Card.CARD_ACE_OF_CLUBS, Card.CARD_ACE_OF_DIAMONDS,
    Card.CARD_ACE_OF_SPADES, Card.CARD_ACE_OF_HEARTS, Card.CARD_JOKER,
    Card.CARD_SUICIDE_KING, Card.CARD_QUEEN_OF_HEARTS, Card.CARD_CHAOS,
    Card.CARD_HUGE_GROWTH, Card.CARD_ANCIENT_RECALL, Card.CARD_ERA_WALK,
    Card.CARD_CREDIT, Card.CARD_RULES, Card.CARD_QUESTIONMARK,
    Card.CARD_HUMANITY, Card.CARD_GET_OUT_OF_JAIL, Card.CARD_HOLY, Card.CARD_WILD, Card.CARD_EMERGENCY_CONTACT
}

-- Funzione per l'utilizzo dell'item
function BrokenOrigami:useExtraDeck(_, rng, player)
    -- Droppa una carta casuale dal pool delle carte speciali
    local card = specialCards[math.random(#specialCards)]
    player:AddCard(card)
    for i = 0, 3 do
        local activeItem = player:GetActiveItem(i)
        if activeItem == ExtraDeckLocalID then
            player:RemoveCollectible(ExtraDeckLocalID, false, i)
            player:AddCollectible(DeckofCardID, 0, false, i)
        end
    end
    return {
        Discharge = true,
        Remove = false,
        ShowAnim = true
    }
end

function BrokenOrigami:removeExtraDeckFromPool()
    Game():GetItemPool():RemoveCollectible(ExtraDeckLocalID)
end

function BrokenOrigami:mutateExtraDeck(_, rng, player)
    local mutateValue = rng:RandomFloat()
    if mutateValue < 0.075 then
        for i = 0, 3 do
            local activeItem = player:GetActiveItem(i)
            if activeItem == DeckofCardID then
                player:RemoveCollectible(DeckofCardID, false, i)
                player:AddCollectible(ExtraDeckLocalID, 0, false, i)
            end
        end
    end
end


-- Associa la funzione all'item
BrokenOrigami:AddCallback(ModCallbacks.MC_USE_ITEM, BrokenOrigami.useExtraDeck, ExtraDeckLocalID)
BrokenOrigami:AddCallback(ModCallbacks.MC_USE_ITEM, BrokenOrigami.mutateExtraDeck, DeckofCardID)
BrokenOrigami:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, BrokenOrigami.removeExtraDeckFromPool)
