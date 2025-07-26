local game = Game()
local ExtraDeckLocalID = Isaac.GetItemIdByName("Extra Deck of Cards")
local DeckofCardID = Isaac.GetItemIdByName("Deck of Cards")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(ExtraDeckLocalID, "{{RedCard}} Spawns 1 special card #{{Collectible85}} After use it goes back to being the Deck of Cards")
end

local notSpecialCards = {
    Card.CARD_REVERSE_FOOL, Card.CARD_REVERSE_MAGICIAN, Card.CARD_REVERSE_HIGH_PRIESTESS,
    Card.CARD_REVERSE_EMPRESS, Card.CARD_REVERSE_EMPEROR, Card.CARD_REVERSE_HIEROPHANT,
    Card.CARD_REVERSE_LOVERS, Card.CARD_REVERSE_CHARIOT, Card.CARD_REVERSE_JUSTICE,
    Card.CARD_REVERSE_HERMIT, Card.CARD_REVERSE_WHEEL_OF_FORTUNE, Card.CARD_REVERSE_STRENGTH,
    Card.CARD_REVERSE_HANGED_MAN, Card.CARD_REVERSE_DEATH, Card.CARD_REVERSE_TEMPERANCE,
    Card.CARD_REVERSE_DEVIL, Card.CARD_REVERSE_TOWER, Card.CARD_REVERSE_STARS,
    Card.CARD_REVERSE_MOON, Card.CARD_REVERSE_SUN, Card.CARD_REVERSE_JUDGEMENT,
    Card.CARD_REVERSE_WORLD,Card.CARD_FOOL, Card.CARD_MAGICIAN, Card.CARD_HIGH_PRIESTESS,
    Card.CARD_EMPRESS, Card.CARD_EMPEROR, Card.CARD_HIEROPHANT,
    Card.CARD_LOVERS, Card.CARD_CHARIOT, Card.CARD_JUSTICE,
    Card.CARD_HERMIT, Card.CARD_WHEEL_OF_FORTUNE, Card.CARD_STRENGTH,
    Card.CARD_HANGED_MAN, Card.CARD_DEATH, Card.CARD_TEMPERANCE,
    Card.CARD_DEVIL, Card.CARD_TOWER, Card.CARD_STARS,
    Card.CARD_MOON, Card.CARD_SUN, Card.CARD_JUDGEMENT,
    Card.CARD_WORLD
}

--[[ local specialCards = {
    Card.CARD_CLUBS_2, Card.CARD_DIAMONDS_2, Card.CARD_SPADES_2,
    Card.CARD_HEARTS_2, Card.CARD_ACE_OF_CLUBS, Card.CARD_ACE_OF_DIAMONDS,
    Card.CARD_ACE_OF_SPADES, Card.CARD_ACE_OF_HEARTS, Card.CARD_JOKER,
    Card.CARD_SUICIDE_KING, Card.CARD_QUEEN_OF_HEARTS, Card.CARD_CHAOS,
    Card.CARD_HUGE_GROWTH, Card.CARD_ANCIENT_RECALL, Card.CARD_ERA_WALK,
    Card.CARD_CREDIT, Card.CARD_RULES, Card.CARD_QUESTIONMARK,
    Card.CARD_HUMANITY, Card.CARD_GET_OUT_OF_JAIL, Card.CARD_HOLY, Card.CARD_WILD, Card.CARD_EMERGENCY_CONTACT, Isaac.GetCardIdByName("Queen of Spades")
} --]]

local function isCardAllowed(card)
    for _, forbidden in ipairs(notSpecialCards) do
        if card == forbidden then
            return false
        end
    end
    return true
end

function ShatteredSymbols:useExtraDeck(_, rng, player)
    local card
    repeat 
        card = game:GetItemPool():GetCard(rng:Next(),true,false,false)
    until isCardAllowed(card)

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
