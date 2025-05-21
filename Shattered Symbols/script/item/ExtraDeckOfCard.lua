local game = Game()
local ExtraDeckLocalID = Isaac.GetItemIdByName("Extra Deck of Cards")
local DeckofCardID = Isaac.GetItemIdByName("Deck of Cards")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(ExtraDeckLocalID, "{{RedCard}} Spawns 1 special card #{{Collectible85}} After use it goes back to being the Deck of Cards")
end


local specialCards = {
    Card.CARD_CLUBS_2, Card.CARD_DIAMONDS_2, Card.CARD_SPADES_2,
    Card.CARD_HEARTS_2, Card.CARD_ACE_OF_CLUBS, Card.CARD_ACE_OF_DIAMONDS,
    Card.CARD_ACE_OF_SPADES, Card.CARD_ACE_OF_HEARTS, Card.CARD_JOKER,
    Card.CARD_SUICIDE_KING, Card.CARD_QUEEN_OF_HEARTS, Card.CARD_CHAOS,
    Card.CARD_HUGE_GROWTH, Card.CARD_ANCIENT_RECALL, Card.CARD_ERA_WALK,
    Card.CARD_CREDIT, Card.CARD_RULES, Card.CARD_QUESTIONMARK,
    Card.CARD_HUMANITY, Card.CARD_GET_OUT_OF_JAIL, Card.CARD_HOLY, Card.CARD_WILD, Card.CARD_EMERGENCY_CONTACT, Isaac.GetCardIdByName("Queen of Spades")
}


function ShatteredSymbols:useExtraDeck(_, rng, player)
    
    local card = specialCards[math.random(#specialCards)]
    player:AddCard(card)
    player:AnimateCard(card, "Pickup")
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

function ShatteredSymbols:removeExtraDeckFromPool()
    Game():GetItemPool():RemoveCollectible(ExtraDeckLocalID)
end

function ShatteredSymbols:mutateExtraDeck(_, rng, player)
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


function ShatteredSymbols:ExtraWispInit(wisp)
	if  wisp.Player and wisp.Player:HasCollectible(ExtraDeckLocalID) then
		if wisp.SubType == ExtraDeckLocalID then
			wisp.SubType = 85
		end
	end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, ShatteredSymbols.ExtraWispInit, FamiliarVariant.WISP)
ShatteredSymbols:AddCallback(ModCallbacks.MC_USE_ITEM, ShatteredSymbols.useExtraDeck, ExtraDeckLocalID)
ShatteredSymbols:AddCallback(ModCallbacks.MC_USE_ITEM, ShatteredSymbols.mutateExtraDeck, DeckofCardID)
ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, ShatteredSymbols.removeExtraDeckFromPool)
