BrokenOrigami = RegisterMod("Broken Origami", 1)

local ItemScript = {
    'SacredLantern',
    'FortuneTeller',
    'OrigamiShuriken',
    'OrigamiBoat',
    'UpsideDownDeckofCard',
    'Constellation',
    'OrigamiSwan',
    'Meteor',
    'ShawtysLetter',
    'Girlfriend',
    'TornHook',
    'WrigglingShadow',
    'OrigamiCrow',
    'OrigamiKolibri',
    'BrokenFlux'
}

for i = 1, #ItemScript do
	require (ItemScript[i])
end

local JsonSaveFile = require("json")
local AllPlayerDataToSave = {}

function BrokenOrigami:SavePlayerData()
    local player = Isaac.GetPlayer(0)
    AllPlayerDataToSave = player:GetData() -- Recupera tutte le variabili salvate in GetData
    BrokenOrigami:SaveData(JsonSaveFile.encode(AllPlayerDataToSave)) -- Salva i dati in JSON
end

-- Funzione per caricare tutte le variabili del player
function BrokenOrigami:LoadPlayerData()
    if BrokenOrigami:HasData() then
        local player = Isaac.GetPlayer(0)
        AllPlayerDataToSave = JsonSaveFile.decode(BrokenOrigami:LoadData())
        
        -- Ripristina tutte le variabili salvate su GetData del player
        for key, value in pairs(AllPlayerDataToSave) do
            player:GetData()[key] = value
        end
    end
end

-- Callback per salvare i dati all’uscita
BrokenOrigami:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, BrokenOrigami.SavePlayerData)

-- Callback per caricare i dati all'inizio del gioco
BrokenOrigami:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, BrokenOrigami.LoadPlayerData)