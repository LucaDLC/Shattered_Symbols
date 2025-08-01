local game = Game()
local WrigglingShadowLocalID = Isaac.GetItemIdByName("Wriggling Shadow")
local TornHookExternalID = Isaac.GetItemIdByName("Torn Hook")
local AncientHookExternalID = Isaac.GetItemIdByName("Ancient Hook")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(WrigglingShadowLocalID, "{{Warning}} SINGLE USE {{Warning}} #{{BrokenHeart}} Remove the 50% of your Broken Hearts and give 1 Empty Heart Container for each Broken Heart removed #{{ArrowDown}} It gives you a random Hook")
end


function ShatteredSymbols:useWrigglingShadow(_, rng, player)
    if player:HasCollectible(WrigglingShadowLocalID) then

        local hookProb = math.random(0, 1)
        local brokenHearts = player:GetBrokenHearts()
        local removedHearts
        
        if brokenHearts < 2 then
            removedHearts = math.ceil(brokenHearts / 2)
        else
            removedHearts = math.floor(brokenHearts / 2)
        end

        player:AddBrokenHearts(-removedHearts)
        player:AddMaxHearts(removedHearts*2)
        player:AddHearts(removedHearts*2)

        if hookProb == 0 then
            player:AddCollectible(TornHookExternalID)
        else
            player:AddCollectible(AncientHookExternalID)
        end
        
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PURGATORY, 0, player.Position, Vector(0,0), player)
        SFXManager():Play(SoundEffect.SOUND_SATAN_HURT)

    end

    return {
        Discharge = true,
        Remove = true,
        ShowAnim = true
    }
end

function ShatteredSymbols:WrigglingShadowWispInit(wisp)
	if  wisp.Player and wisp.Player:HasCollectible(WrigglingShadowLocalID) then
		if wisp.SubType == WrigglingShadowLocalID then
			wisp.SubType = 83
		end
	end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, ShatteredSymbols.WrigglingShadowWispInit, FamiliarVariant.WISP)
ShatteredSymbols:AddCallback(ModCallbacks.MC_USE_ITEM, ShatteredSymbols.useWrigglingShadow, WrigglingShadowLocalID)
