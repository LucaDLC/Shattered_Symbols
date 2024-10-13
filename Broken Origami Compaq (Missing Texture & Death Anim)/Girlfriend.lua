local game = Game()
local GirlfriendLocalID = Isaac.GetItemIdByName("Girlfriend")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(GirlfriendLocalID, "{{ArrowUp}} Give a random familiar #{{ArrowDown}} Give 1 Broken Heart {{BrokenHeart}}")
end

local familiars = {}

local function onGameStartGirlfriend()
    for i = 1, Isaac.GetItemConfig():GetCollectibles().Size do
        local itemConfig = Isaac.GetItemConfig():GetCollectible(i)
        if itemConfig and itemConfig.Type == ItemType.ITEM_FAMILIAR then
            if i ~= CollectibleType.COLLECTIBLE_KEY_PIECE_1 
            and i ~= CollectibleType.COLLECTIBLE_KEY_PIECE_2 
            and i ~= CollectibleType.COLLECTIBLE_KNIFE_PIECE_1 
            and i ~= CollectibleType.COLLECTIBLE_KNIFE_PIECE_2 then
                table.insert(familiars, i)
            end
        end
    end
end

function BrokenOrigami:useGirlfriend(_, rng, player)
    if player:HasCollectible(GirlfriendLocalID) then
        local familiarID = familiars[rng:RandomInt(#familiars) + 1]
        player:AddBrokenHearts(1)
        player:AddCollectible(familiarID)
    end

    return {
        Discharge = true,
        Remove = false,
        ShowAnim = true
    }
end


BrokenOrigami:AddCallback(ModCallbacks.MC_USE_ITEM, BrokenOrigami.useGirlfriend, GirlfriendLocalID)
BrokenOrigami:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, onGameStartGirlfriend)
