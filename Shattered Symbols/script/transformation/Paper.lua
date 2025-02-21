local game = Game()

if EID then
    EID:createTransformation("Paper", "Paper")
    EID:assignTransformation(CollectibleType.COLLECTIBLE_THE_PACT, 5, "Paper")
    EID:assignTransformation(CollectibleType.COLLECTIBLE_MISSING_PAGE_2, 5, "Paper")
    EID:assignTransformation(CollectibleType.COLLECTIBLE_CONTRACT_FROM_BELOW, 5, "Paper")
    EID:assignTransformation(CollectibleType.COLLECTIBLE_DEATHS_LIST, 5, "Paper")
    EID:assignTransformation(CollectibleType.COLLECTIBLE_DIVORCE_PAPERS, 5, "Paper")
    EID:assignTransformation(Isaac.GetItemIdByName("Origami Crow"), 5, "Paper")
    EID:assignTransformation(Isaac.GetItemIdByName("Origami Bat"), 5, "Paper")
    EID:assignTransformation(Isaac.GetItemIdByName("Origami Kolibri"), 5, "Paper")
    EID:assignTransformation(Isaac.GetItemIdByName("Torn Hook"), 5, "Paper")
    EID:assignTransformation(Isaac.GetItemIdByName("Origami Swan"), 5, "Paper")
    EID:assignTransformation(Isaac.GetItemIdByName("Origami Boat"), 5, "Paper")
    EID:assignTransformation(Isaac.GetItemIdByName("Origami Shuriken"), 5, "Paper")
    EID:assignTransformation(Isaac.GetItemIdByName("Fortune Teller"), 5, "Paper")
end

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
            player:AddBlackHearts(2)
        end
    end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, ShatteredSymbols.PaperTransformation)