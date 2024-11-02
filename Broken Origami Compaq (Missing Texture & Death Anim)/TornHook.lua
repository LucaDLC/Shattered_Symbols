local game = Game()
local TornHookLocalID = Isaac.GetItemIdByName("Torn Hook")
local WrigglingShadowExternalID = Isaac.GetItemIdByName("Wriggling Shadow")

-- EID (se usi EID per la descrizione)
if EID then
    EID:assignTransformation("collectible", TornHookLocalID, EID.TRANSFORMATION["ORIGAMI"])
    EID:addCollectible(TornHookLocalID, "{{ArrowDown}} Gives 1 Broken Hearts {{BrokenHeart}} at every Floor #Every floor you have 20% of chance (+10% for each Torn Hook after first) of spawn Wriggling Shadow #Jacob and Esau have +10% chance")
end


function BrokenOrigami:onTornHook()
    local player = Isaac.GetPlayer(0)
    if player:HasCollectible(TornHookLocalID) then
        local TornHooksCounter = player:GetCollectibleNum(TornHookLocalID)
        player:AddBrokenHearts(1*TornHooksCounter)
        local TornHookChance = 0
        TornHookChance = 0.20 + ((TornHooksCounter - 1) * 0.10)
        if player:GetPlayerType() == PlayerType.PLAYER_JACOB or player:GetPlayerType() == PlayerType.PLAYER_ESAU then
            TornHookChance = TornHookChance + 0.10
        end
        if math.random() < TornHookChance then
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, WrigglingShadowExternalID, player.Position + Vector(0, 50), Vector(0,0), nil)
        end
    end
end

BrokenOrigami:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, BrokenOrigami.onTornHook)
