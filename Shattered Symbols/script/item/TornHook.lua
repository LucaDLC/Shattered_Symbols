
local game = Game()
local TornHookLocalID = Isaac.GetItemIdByName("Torn Hook")

-- EID (se usi EID per la descrizione)
if EID then
    EID:assignTransformation("collectible", TornHookLocalID, EID.TRANSFORMATION["ORIGAMI"])
    EID:addCollectible(TornHookLocalID, "{{BrokenHeart}} Gives 1 Broken Hearts which does not replace Heart at every Floor #Every floor you have 15% of chance for each Torn Hook of spawn Death Certificate #{{Luck}} You have same Chance as Luck to remove Torn Hooks on each floor, at the floor when Torn Hooks removed the effects not activate")
end

function ShatteredSymbols:onTornHook()
    for playerIndex = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(playerIndex)
        if player:HasCollectible(TornHookLocalID) then
            local luck = math.max(player.Luck, 0)
            if math.random(1, 100) <= luck then
                for i = 1, player:GetCollectibleNum(TornHookLocalID) do
                    player:RemoveCollectible(TornHookLocalID)
                end
            else
                local TornHooksCounter = player:GetCollectibleNum(TornHookLocalID)
                player:AddBrokenHearts(1*TornHooksCounter)
                local TornHookChance = 0
                TornHookChance = TornHooksCounter * 0.15
                if math.random() < TornHookChance then
                    local pocketItem = player:GetActiveItem(ActiveSlot.SLOT_POCKET)
                    local activeItem = player:GetActiveItem(ActiveSlot.SLOT_PRIMARY)
                    if pocketItem == 0 then
                        player:SetPocketActiveItem(CollectibleType.COLLECTIBLE_DEATH_CERTIFICATE, ActiveSlot.SLOT_POCKET)
                    elseif activeItem == 0 then
                        player:AddCollectible(CollectibleType.COLLECTIBLE_DEATH_CERTIFICATE, 1, false)
                    else
                        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_DEATH_CERTIFICATE, player.Position + Vector(0, 50), Vector(0,0), nil)
                    end
                end
            end
        end
    end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, ShatteredSymbols.onTornHook)
