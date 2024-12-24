local game = Game()
local ForbiddenMindLocalID = Isaac.GetItemIdByName("Forbidden Mind")

-- EID (se usi EID per la descrizione)
if EID then
    EID:addCollectible(ForbiddenMindLocalID, "{{Room}} After clearing a Room have 25% to open Red Rooms around it")
end

function ShatteredSymbols:onRoomClearForbiddenMind()
    for playerIndex = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(playerIndex)
        if player:HasCollectible(ForbiddenMindLocalID) then
            if math.random(100) <= 25 then 
                local level = game:GetLevel()
                local currentRoom = level:GetCurrentRoomIndex()
                for i = 0, DoorSlot.NUM_DOOR_SLOTS - 1 do
                    if level:CanSpawnDoorOutline(currentRoom, i) then
						level:MakeRedRoomDoor(currentRoom, i)
					end
                end
            end
        end
    end
end


ShatteredSymbols:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, ShatteredSymbols.onRoomClearForbiddenMind)
