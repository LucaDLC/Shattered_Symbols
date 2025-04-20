local game = Game()
local ShawtysEssenceLocalID = Isaac.GetItemIdByName("Shawty's Essence")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(ShawtysEssenceLocalID, "{{ArrowUp}} Give a random familiar #{{BrokenHeart}} Give 1 Broken Heart which does replace Heart in this order {{Heart}}{{BoneHeart}}{{SoulHeart}}{{BlackHeart}} #{{Collectible}} After use, you have a 35% chance of the item disappearing #{{Player10}} Give 2 Wisps that poison enemies")
end

local familiars = {}

local function onGameStartShawtysEssence()
    for i = 1, Isaac.GetItemConfig():GetCollectibles().Size do
        local itemConfig = Isaac.GetItemConfig():GetCollectible(i)
        if itemConfig and itemConfig.Type == ItemType.ITEM_FAMILIAR and not itemConfig:HasTags(ItemConfig.TAG_QUEST) then
            if i ~= CollectibleType.COLLECTIBLE_KEY_PIECE_1 
            and i ~= CollectibleType.COLLECTIBLE_KEY_PIECE_2 
            and i ~= CollectibleType.COLLECTIBLE_KNIFE_PIECE_1 
            and i ~= CollectibleType.COLLECTIBLE_KNIFE_PIECE_2 then
                table.insert(familiars, i)
            end
        end
    end
end

local function BrokenHeartRemovingSystem(player)
    local slotRemoved = false

    if player:GetMaxHearts() >= 2 and not slotRemoved then
        player:AddMaxHearts(-2)  
        slotRemoved = true
    end

    if not slotRemoved and player:GetBoneHearts() >= 1 then
        player:AddBoneHearts(-1) 
        slotRemoved = true
    end

    if not slotRemoved and player:GetSoulHearts() >= 2 then
        player:AddSoulHearts(-2)  
        slotRemoved = true
    end

    if not slotRemoved and player:GetBlackHearts() >= 2 then
        player:AddBlackHearts(-2)  
        slotRemoved = true
    end

    player:AddBrokenHearts(1)

end

function ShatteredSymbols:useShawtysEssence(_, rng, player)
    local playerType = player:GetPlayerType()
    if player:HasCollectible(ShawtysEssenceLocalID) then
        local familiarID = familiars[rng:RandomInt(#familiars) + 1]
        
        if playerType == PlayerType.PLAYER_THELOST or playerType == PlayerType.PLAYER_THELOST_B then
            for i = 1, 2 do
                player:AddWisp(ShawtysEssenceLocalID, player.Position)
            end 
        else
            BrokenHeartRemovingSystem(player)
            player:AddCollectible(familiarID)
        end
    end
    if rng:RandomFloat() < 0.35 then
        return {
            Discharge = true,
            Remove = true,
            ShowAnim = true
        }
    else
        return {
            Discharge = true,
            Remove = false,
            ShowAnim = true
        }
    end
end

function ShatteredSymbols:ShawtysEssenceWispInit(wisp)
	if  wisp.Player and wisp.Player:HasCollectible(ShawtysEssenceLocalID) then
		if wisp.SubType == ShawtysEssenceLocalID then
			wisp.SubType = 642
		end
	end
end


ShatteredSymbols:AddCallback(ModCallbacks.MC_USE_ITEM, ShatteredSymbols.useShawtysEssence, ShawtysEssenceLocalID)
ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, onGameStartShawtysEssence)
ShatteredSymbols:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, ShatteredSymbols.ShawtysEssenceWispInit, FamiliarVariant.WISP)
