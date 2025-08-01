local game = Game()
local DystopicFaithLocalID = Isaac.GetItemIdByName("Dystopic Faith")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(DystopicFaithLocalID, "{{Collectible}} After death, it disappear and spawn: #{{AngelRoom}} An Angel Room item if the player has taken a Devil Deal #{{DevilRoom}} A Devil Room item if the player has not taken any Devil Deal #{{SecretRoom}} In each case spawns also a Secret Room item")
end


function ShatteredSymbols:useDystopicFaith()
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        local data = player:GetData()
        if not data.IsDeadDystopicFaith then data.IsDeadDystopicFaith = false end 
        if player:IsDead() and player:HasCollectible(DystopicFaithLocalID) then  
            data.IsDeadDystopicFaith = true
        end
        if not player:IsDead() and data.IsDeadDystopicFaith and player:HasCollectible(DystopicFaithLocalID) then
            player:RemoveCollectible(DystopicFaithLocalID)

            local rng = RNG()
            rng:SetSeed(math.random(1, 99999999), 1)

            if game:GetDevilRoomDeals() > 0 then
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, game:GetItemPool():GetCollectible(ItemPoolType.POOL_ANGEL, false, rng:Next()), player.Position + Vector(0, 50), Vector(0,0), nil)
            else
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, game:GetItemPool():GetCollectible(ItemPoolType.POOL_DEVIL, false, rng:Next()), player.Position + Vector(0, 50), Vector(0,0), nil)
            end
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, game:GetItemPool():GetCollectible(ItemPoolType.POOL_SECRET, false, rng:Next()), player.Position + Vector(0, -50), Vector(0,0), nil)
            
            data.IsDeadDystopicFaith = false
            SFXManager():Play(SoundEffect.SOUND_HOLY)
        end
    end
end


ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_UPDATE, ShatteredSymbols.useDystopicFaith)
