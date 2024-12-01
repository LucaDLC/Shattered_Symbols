local game = Game()
local ForbiddenMindLocalID = Isaac.GetItemIdByName("Forbidden Mind")

-- EID (se usi EID per la descrizione)
if EID then
    EID:addCollectible(ForbiddenMindLocalID, "{{Room}} After clearing a Room have 25% to open a Red Room #{{TreasureRoom}} At every floor have 40% to trasform Treasure Room in Red Treasure Room")
end

function BrokenOrigami:onRoomClearForbiddenMind()
    for playerIndex = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(playerIndex)
        if player:HasCollectible(ForbiddenMindLocalID) then
            if math.random(100) <= 25 then
                local level = game:GetLevel()
                local currentRoomDesc = level:GetCurrentRoomDesc()
                local directions = {Direction.LEFT, Direction.RIGHT, Direction.UP, Direction.DOWN} --non prende tutte le possibili porte 

                for _, direction in ipairs(directions) do --Non controlla per far si che ruoti posizione e ne prenda un altra non vuota o con altre porte se la direzione scelta non va bene
                    if level:MakeRedRoomDoor(currentRoomDesc.SafeGridIndex, direction) then  --apre delle I_AM_AN_ERROR Room
                        break
                    end
                end
            end
        end
    end
end


function BrokenOrigami:redTreasureForbiddenMind()
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


BrokenOrigami:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, BrokenOrigami.onRoomClearForbiddenMind)
BrokenOrigami:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, BrokenOrigami.redTreasureForbiddenMind)
