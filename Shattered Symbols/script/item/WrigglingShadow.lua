local game = Game()
local WrigglingShadowLocalID = Isaac.GetItemIdByName("Wriggling Shadow")
local TornHookExternalID = Isaac.GetItemIdByName("Torn Hook")
local AncientHookExternalID = Isaac.GetItemIdByName("Ancient Hook")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(WrigglingShadowLocalID, "{{Warning}} SINGLE USE {{Warning}} #{{ArrowUp}} Remove all Hooks, remove 50% of all your Broken Hearts and give 1 Empty Heart Container for each Broken Heart removed if you have at least 1 Hook #{{ArrowDown}} If you don't have any Hooks, it gives you one")
end


function ShatteredSymbols:useWrigglingShadow(_, rng, player)
    if (player:HasCollectible(TornHookExternalID) or player:HasCollectible(AncientHookExternalID)) and player:HasCollectible(WrigglingShadowLocalID) then

        for i = 1, player:GetCollectibleNum(TornHookExternalID) do
            player:RemoveCollectible(TornHookExternalID)
        end

        for i = 1, player:GetCollectibleNum(AncientHookExternalID) do
            player:RemoveCollectible(AncientHookExternalID)
        end

        player:AddBrokenHearts(-(player:GetBrokenHearts()/2))
        player:AddMaxHearts(player:GetBrokenHearts())
        player:AddHearts(player:GetBrokenHearts())

        SFXManager():Play(SoundEffect.SOUND_SATAN_HURT)

    elseif (not player:HasCollectible(TornHookExternalID) and not player:HasCollectible(AncientHookExternalID)) and player:HasCollectible(WrigglingShadowLocalID) then
        local hookProb = math.random(0, 1)
        if hookProb == 0 then
            player:AddCollectible(TornHookExternalID)
        else
            player:AddCollectible(AncientHookExternalID)
        end
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PURGATORY, 0, player.Position, Vector(0,0), player)
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
