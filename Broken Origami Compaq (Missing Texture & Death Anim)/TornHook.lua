local game = Game()
local TornHookLocalID = Isaac.GetItemIdByName("Torn Hook")
local WrigglingShadowExternalID = Isaac.GetItemIdByName("Wriggling Shadow")

-- EID (se usi EID per la descrizione)
if EID then
    EID:assignTransformation("collectible", TornHookLocalID, EID.TRANSFORMATION["ORIGAMI"])
    EID:addCollectible(TornHookLocalID, "{{ArrowDown}} Gives 1 Broken Hearts {{BrokenHeart}} at every Floor#Every floor you have 12,5% of chance (+10% for each Torn Hook after first) of spawn Wriggling Shadow#If you have 5 of Luck {{Luck}} or higher you have 15% of chance (+12,5% for each Torn Hook after first)")
end


function BrokenOrigami:onTornHook()
    local player = Isaac.GetPlayer(0)
    if player:HasCollectible(TornHookLocalID) then
        local TornHooksCounter = player:GetCollectibleNum(TornHookLocalID)
        player:AddBrokenHearts(1*TornHooksCounter)
        local TornHookChance = 0
        if player.Luck >= 5 then
            TornHookChance = 0.15 + ((TornHooksCounter - 1) * 0.125)
        else
            TornHookChance = 0.125 + ((TornHooksCounter - 1) * 0.10)
        end
        if math.random() < TornHookChance then
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, WrigglingShadowExternalID, player.Position + Vector(0, 50), Vector(0,0), nil)
        end
    end
end

BrokenOrigami:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, BrokenOrigami.onTornHook)
