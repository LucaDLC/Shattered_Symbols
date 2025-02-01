
local game = Game()
local PyriteLocalID = Isaac.GetItemIdByName("Pyrite")

-- EID (se usi EID per la descrizione)
if EID then
    EID:addCollectible(PyriteLocalID, "{{Coin}} ")
end

