
local game = Game()
local TornHookLocalID = Isaac.GetItemIdByName("Torn Hook")

-- EID (se usi EID per la descrizione)
if EID then
    EID:assignTransformation("collectible", TornHookLocalID, EID.TRANSFORMATION["ORIGAMI"])
    EID:addCollectible(TornHookLocalID, "{{BrokenHeart}} Gives 1 Broken Hearts at every Floor #Every floor you have 15% of chance (+10% for each Torn Hook after first) of spawn Death Certificate #Jacob and Esau have +5% chance and both have their own percent")
end

function BrokenOrigami:onTornHook()
    for playerIndex = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(playerIndex)
        if player:HasCollectible(TornHookLocalID) then
            local TornHooksCounter = player:GetCollectibleNum(TornHookLocalID)
            player:AddBrokenHearts(1*TornHooksCounter)
            local TornHookChance = 0
            TornHookChance = 0.20 + ((TornHooksCounter - 1) * 0.10)
            if player:GetPlayerType() == PlayerType.PLAYER_JACOB or player:GetPlayerType() == PlayerType.PLAYER_ESAU then
                TornHookChance = TornHookChance + 0.05
            end
            if math.random() < TornHookChance then
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_DEATH_CERTIFICATE, player.Position + Vector(0, 50), Vector(0,0), nil)
                for i = 1, player:GetCollectibleNum(TornHookExternalID) do
                    player:RemoveCollectible(TornHookExternalID)
                end
            end
        end
    end
end

BrokenOrigami:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, BrokenOrigami.onTornHook)
