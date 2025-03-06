local game = Game()
local ShawtysLetterLocalID = Isaac.GetItemIdByName("Shawty's Letter")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(ShawtysLetterLocalID, "{{Warning}} SINGLE USE {{Warning}}#Spawns a random origami item")
end

local Origami_items = {
    Isaac.GetItemIdByName("Fortune Teller"),
    Isaac.GetItemIdByName("Origami Shuriken"),
    Isaac.GetItemIdByName("Origami Boat"),
    Isaac.GetItemIdByName("Origami Swan"),
    Isaac.GetItemIdByName("Origami Crow"),
    Isaac.GetItemIdByName("Origami Kolibri"),
    Isaac.GetItemIdByName("Origami Bat")
}

local Shawty_Table = {}

function ShatteredSymbols:useShawtysLetter(_, rng, player)
    Shawty_Table = {}

    for _, v in pairs(Origami_items) do
        table.insert(Shawty_Table, v)
    end
    local selectedItem = Shawty_Table[rng:RandomInt(#Shawty_Table) + 1]

    local spawnPosition = game:GetRoom():FindFreePickupSpawnPosition(player.Position, 40, true)
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, selectedItem, spawnPosition, Vector(0, 0), nil)
    
    SFXManager():Play(SoundEffect.SOUND_PAPER_OUT)

    return {
        Discharge = true,
        Remove = true,
        ShowAnim = true
    }
end

function ShatteredSymbols:onGameStartShawtysLetter()
    local Shawty_Table = {}
end

function ShatteredSymbols:ShawtyWispInit(wisp)
	if  wisp.Player and wisp.Player:HasCollectible(ShawtysLetterLocalID) then
		if wisp.SubType == ShawtysLetterLocalID then
			wisp.SubType = 642
		end
	end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, ShatteredSymbols.ShawtyWispInit, FamiliarVariant.WISP)
ShatteredSymbols:AddCallback(ModCallbacks.MC_USE_ITEM, ShatteredSymbols.useShawtysLetter, ShawtysLetterLocalID)
ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, ShatteredSymbols.onGameStartShawtysLetter)


