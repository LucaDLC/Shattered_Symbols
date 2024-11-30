local game = Game()
local ShawtysLetterLocalID = Isaac.GetItemIdByName("Shawty's Letter")

--EID
if EID then
    EID:addCollectible(ShawtysLetterLocalID, "{{Warning}} SINGLE USE {{Warning}}#Spawns a random origami item")
end

-- Liste degli oggetti zodiacali e del planetario

local Origami_items = {
    Isaac.GetItemIdByName("Fortune Teller"),
    Isaac.GetItemIdByName("Origami Shuriken"),
    Isaac.GetItemIdByName("Origami Boat"),
    Isaac.GetItemIdByName("Origami Swan"),
    Isaac.GetItemIdByName("Torn Hook"),
    Isaac.GetItemIdByName("Origami Crow"),
    Isaac.GetItemIdByName("Origami Kolibri")
}

local Shawty_Table = {}

-- Funzione per gestire l'uso dell'oggetto "Fortune Teller"
function BrokenOrigami:useShawtysLetter(_, rng, player)
    -- Svuota la tabella ogni volta che l'oggetto viene usato
    Shawty_Table = {}

    for _, v in pairs(Origami_items) do
        table.insert(Shawty_Table, v)
    end
    -- Scegli un oggetto casuale dalla lista combinata
    local selectedItem = Shawty_Table[rng:RandomInt(#Shawty_Table) + 1]

    -- Spawna l'oggetto scelto nella stanza
    local spawnPosition = game:GetRoom():FindFreePickupSpawnPosition(player.Position, 40, true)
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, selectedItem, spawnPosition, Vector(0, 0), nil)
    

    return {
        Discharge = true,
        Remove = true,
        ShowAnim = true
    }
end

-- Funzione di inizializzazione della mod
function BrokenOrigami:onGameStartShawtysLetter()
    local Shawty_Table = {}
end

function BrokenOrigami:ShawtyWispInit(wisp)
	if  wisp.Player and wisp.Player:HasCollectible(ShawtysLetterLocalID) then
		if wisp.SubType == ShawtysLetterLocalID then
            local wispVar = rng:RandomFloat()
            if wispVar < 0.5 then
			    wisp.SubType = 39
            else
                wisp.SubType = 642
            end
		end
	end
end

BrokenOrigami:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, BrokenOrigami.ShawtyWispInit, FamiliarVariant.WISP)
BrokenOrigami:AddCallback(ModCallbacks.MC_USE_ITEM, BrokenOrigami.useShawtysLetter, ShawtysLetterLocalID)
BrokenOrigami:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, BrokenOrigami.onGameStartShawtysLetter)


