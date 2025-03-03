local game = Game()
local PallasLocalID = Isaac.GetItemIdByName("Pallas")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(PallasLocalID, "{{}} Every room you have 5% of chance to substitute a not volatile Item with an Mutable Onyx #{{}} Occasionally, active effects of a rune #{{ArrowUp}} Both effects increasing with numbers of Vesta you have")
end

local function triggerPallas(player)
    
    -- rune effects
    
end

function ShatteredSymbols:PallasEffect(player)
    local data = player:GetData()

    if player:HasCollectible(PallasLocalID) then

        local numberOfPallass = player:GetCollectibleNum(PallasLocalID)
        if numberOfPallass > 0 then

            --Take 1 Item that isn't inside the data.MutableOnyxItemEffectID table, is not Mutable Onyx and is not Pallas and substitute with a Mutable Onyx


            if numberOfPallass > 5 then numberOfPallass = 5 end
            local randomValue = math.random(1, math.floor(1024 / 2^numberOfPallass))
        
            if randomValue == 1 then
                triggerPallas(player)  
            end
        end
    end

end

ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ShatteredSymbols.PallasEffect)

