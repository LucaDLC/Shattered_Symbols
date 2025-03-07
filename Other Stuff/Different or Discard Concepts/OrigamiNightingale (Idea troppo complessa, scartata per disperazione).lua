local game = Game()
local OrigamiNightingaleLocalID = Isaac.GetItemIdByName("Origami Nightingale")

-- EID (se usi EID per la descrizione)
if EID then
    EID:assignTransformation("collectible", OrigamiNightingaleLocalID, EID.TRANSFORMATION["ORIGAMI"])
    EID:addCollectible(OrigamiNightingaleLocalID, "{{Room}} After clearing a Room have 10% to open a Red Room #{{Luck}} Every Luck point increase of +1% the chance #{{ArrowDown}} Gives 1 Broken Hearts {{BrokenHeart}}")
end

-- Function to handle item pickup
function BrokenOrigami:useOrigamiNightingale(player)
    -- Get the player's data table
    local data = player:GetData()
    local OrigamiNightingaleCounter = player:GetCollectibleNum(OrigamiNightingaleLocalID)

    if not data.OrigamiNightingaleRelative then data.OrigamiNightingaleRelative = 0 end
    if not data.OrigamiNightingalePreviousCounter then data.OrigamiNightingalePreviousCounter = 1 end

    -- Check if the player has picked up the item
    if player:HasCollectible(OrigamiNightingaleLocalID) then
        
        -- Apply the effect based on the number of items picked up
        if OrigamiNightingaleCounter >= data.OrigamiNightingalePreviousCounter then
            data.OrigamiNightingalePreviousCounter = data.OrigamiNightingalePreviousCounter + 1
            data.OrigamiNightingaleRelative = data.OrigamiNightingaleRelative + 1
            player:AddBrokenHearts(1) -- Add 1 broken heart 
        end
    else
        OrigamiNightingaleCounter = 0
        data.OrigamiNightingalePreviousCounter = 1
    end
    if data.OrigamiNightingaleRelative > OrigamiNightingaleCounter then
        data.OrigamiNightingalePreviousCounter = OrigamiNightingaleCounter +1
    end
end

function BrokenOrigami:onRoomClearOrigamiNightingale()
    for playerIndex = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(playerIndex)
        if player:HasCollectible(OrigamiNightingaleLocalID) then
            local LuckIncreaseRedDoor = player.Luck
            -- Se è Jacob e Esau non tainted, raddoppia il Luck
            if player:GetPlayerType() == PlayerType.PLAYER_JACOB or player:GetPlayerType() == PlayerType.PLAYER_ESAU then
                LuckIncreaseRedDoor = LuckIncreaseRedDoor * 2
            end

            if LuckIncreaseRedDoor > 90 then LuckIncreaseRedDoor = 90 end

            if math.random(100) <= (10 + LuckIncreaseRedDoor) then
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


BrokenOrigami:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, BrokenOrigami.onRoomClearOrigamiNightingale)
BrokenOrigami:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, BrokenOrigami.useOrigamiNightingale)
