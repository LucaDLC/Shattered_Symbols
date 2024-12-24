local game = Game()
local ForbiddenMindLocalID = Isaac.GetItemIdByName("Forbidden Mind")

-- EID (se usi EID per la descrizione)
if EID then
    EID:addCollectible(ForbiddenMindLocalID, "{{Room}} After clearing a Room have 25% to open Red Rooms around it #{{TreasureRoom}} At every floor have 40% to trasform Treasure Room in Red Treasure Room")
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


function ShatteredSymbols:redTreasureForbiddenMind()
    for playerIndex = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(playerIndex)
        if player:HasCollectible(ForbiddenMindLocalID) then
            if math.random(100) <= 40 then
                local level = game:GetLevel()
                level:ChangeRoomType(RoomType.ROOM_RED_TREASURE)
            end
        end
    end
end


ShatteredSymbols:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, ShatteredSymbols.onRoomClearForbiddenMind)
ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, ShatteredSymbols.redTreasureForbiddenMind)
