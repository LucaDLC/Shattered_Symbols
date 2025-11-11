
local game = Game()
local PyriteLocalID = Isaac.GetItemIdByName("Pyrite")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(PyriteLocalID, "{{Coin}} All coins turn into Golden Pennies #{{ArrowDown}} Resets your coin to 0 at the start of each floor")
end

local PyriteData = {
    spawnLog = {},
    paused = false,
}

function ShatteredSymbols:OnPickupInitPyrite(entity)
    local coin = entity:ToPickup()

    if not PyriteData.paused then
        local now = game:GetFrameCount()
        table.insert(PyriteData.spawnLog, now)

        for i = #PyriteData.spawnLog, 1, -1 do
            if now - PyriteData.spawnLog[i] > 30 then
                table.remove(PyriteData.spawnLog, i)
            end
        end

        if #PyriteData.spawnLog > 20 then
            PyriteData.paused = true
            print("[Pyrite] Flood Detected! The effect is paused, change room for resume it")
            return
        end

        for playerIndex = 0, game:GetNumPlayers() - 1 do
            local player = Isaac.GetPlayer(playerIndex)

            if coin and coin.Variant == PickupVariant.PICKUP_COIN and player:HasCollectible(PyriteLocalID) and coin.SubType ~= CoinSubType.COIN_GOLDEN then
                coin:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_GOLDEN, true, false, false)

            end
        end
    end
end

function ShatteredSymbols:OnNewLevelPyrite()
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        local currentCoins = player:GetNumCoins()
        if currentCoins ~= 0 and player:HasCollectible(PyriteLocalID) then
            player:AddCoins(-currentCoins)
        end
    end
end

function ShatteredSymbols:OnNewRoomPyrite()
    PyriteData.spawnLog = {}
    PyriteData.paused = false
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, ShatteredSymbols.OnPickupInitPyrite, PickupVariant.PICKUP_COIN)
ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, ShatteredSymbols.OnNewLevelPyrite)
ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, ShatteredSymbols.OnNewRoomPyrite)
