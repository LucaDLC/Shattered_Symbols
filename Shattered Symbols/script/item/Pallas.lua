local game = Game()
local PallasLocalID = Isaac.GetItemIdByName("Pallas")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(PallasLocalID, "{{}} Occasionally, ")
end

local function triggerPallas(player)
    
    
end

function ShatteredSymbols:PallasEffect(player)
    local data = player:GetData()

    if player:HasCollectible(PallasLocalID) then

        local numberOfPallass = player:GetCollectibleNum(PallasLocalID)
        if numberOfPallass > 0 then
            if numberOfPallass > 5 then numberOfPallass = 5 end
            local randomValue = math.random(1, math.floor(1024 / 2^numberOfPallass))
        
            if randomValue == 1 then
                triggerPallas(player)  
            end
        end
    end

end

ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ShatteredSymbols.PallasEffect)

