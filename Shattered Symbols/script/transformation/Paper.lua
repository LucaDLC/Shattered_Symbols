local game = Game()

if EID then
    EID:createTransformation("Paper", "Paper")
    EID:assignTransformation(CollectibleType.COLLECTIBLE_THE_PACT, 5, "Paper")
    EID:assignTransformation(CollectibleType.COLLECTIBLE_MISSING_PAGE_2, 5, "Paper")
    EID:assignTransformation(CollectibleType.COLLECTIBLE_CONTRACT_FROM_BELOW, 5, "Paper")
    EID:assignTransformation(CollectibleType.COLLECTIBLE_DEATHS_LIST, 5, "Paper")
    EID:assignTransformation(CollectibleType.COLLECTIBLE_DIVORCE_PAPERS, 5, "Paper")
end

-- Lista degli oggetti che compongono l'evoluzione
local PAPER_ITEMS = {
    CollectibleType.COLLECTIBLE_THE_PACT,
    CollectibleType.COLLECTIBLE_MISSING_PAGE_2,
    CollectibleType.COLLECTIBLE_CONTRACT_FROM_BELOW,
    CollectibleType.COLLECTIBLE_DEATHS_LIST,
    CollectibleType.COLLECTIBLE_DIVORCE_PAPERS
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
            if player:GetBrokenHearts() > 0 then
                player:AddBrokenHearts(-1)
            end
            player:AddBlackHearts(2)
        end
    end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, ShatteredSymbols.PaperTransformation)