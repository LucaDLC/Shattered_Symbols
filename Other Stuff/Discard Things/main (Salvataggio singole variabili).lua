BrokenOrigami = RegisterMod("Broken Origami", 1)

local JsonSaveFile = require("json")
local AllPlayerDataToSave = {}
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

for Load = 1, #ItemScript do
    require("script.item." .. ItemScript[Load])
end

-- Funzione di salvataggio dei dati
function BrokenOrigami:SavePlayerData()
    local NumPlayer = 0
    local player = Isaac.GetPlayer(NumPlayer)
    local data = player:GetData()

    -- Salvataggio delle variabili del giocatore in un formato JSON
    AllPlayerDataToSave = {
        OrigamiSwanRelative = data.OrigamiSwanRelative,
        OrigamiSwanPreviousCounter = data.OrigamiSwanPreviousCounter,

        OrigamiShurikenRelative = data.OrigamiShurikenRelative,
        OrigamiShurikenPreviousCounter = data.OrigamiShurikenPreviousCounter,
        OrigamiShurikenDamageBoost = data.OrigamiShurikenDamageBoost,

        OrigamiKolibriRelative = data.OrigamiKolibriRelative,
        OrigamiKolibriPreviousCounter = data.OrigamiKolibriPreviousCounter,
        kolibriTearsCount = data.kolibriTearsCount,
        OrigamiKolibriSpeedBoost = data.OrigamiKolibriSpeedBoost,
        OrigamiKolibriLimit = data.OrigamiKolibriLimit,

        chargeMemory = data.chargeMemory,
        OrigamiCrowRelative = data.OrigamiCrowRelative,
        OrigamiCrowPreviousCounter = data.OrigamiCrowPreviousCounter,

        brokenHeartsCount = data.brokenHeartsCount,
        holdingItemforStats = data.holdingItemforStats,

        MeteorRelative = data.MeteorRelative,
        MeteorPreviousCounter = data.MeteorPreviousCounter,

        FortuneTellerRelative = data.FortuneTellerRelative,
        FortuneTellerPreviousCounter = data.FortuneTellerPreviousCounter,
        FortuneTellerLuckBoost = data.FortuneTellerLuckBoost,

        BrokenFluxPreviousBrokenHearts = data.BrokenFluxPreviousBrokenHearts,
        BrokenFluxCharge = data.BrokenFluxCharge
    }

    -- Salva i dati in formato JSON
    BrokenOrigami:SaveData(JsonSaveFile.encode(AllPlayerDataToSave)) 
end

-- Funzione di caricamento dei dati
-- Funzione di caricamento dei dati
function BrokenOrigami:LoadPlayerData()
    local player = Isaac.GetPlayer(0)

    if BrokenOrigami:HasData() then
        -- Carica i dati salvati dal file JSON
        AllPlayerDataToSave = JsonSaveFile.decode(BrokenOrigami:LoadData())

        -- Ottieni l'oggetto `data` del giocatore
        local data = player:GetData()

        -- Carica e assegna i dati specifici con controllo di esistenza
        data.OrigamiSwanRelative = AllPlayerDataToSave.OrigamiSwanRelative or 0
        data.OrigamiSwanPreviousCounter = AllPlayerDataToSave.OrigamiSwanPreviousCounter or 0

        data.OrigamiShurikenRelative = AllPlayerDataToSave.OrigamiShurikenRelative or 0
        data.OrigamiShurikenPreviousCounter = AllPlayerDataToSave.OrigamiShurikenPreviousCounter or 0
        data.OrigamiShurikenDamageBoost = AllPlayerDataToSave.OrigamiShurikenDamageBoost or 0

        data.OrigamiKolibriRelative = AllPlayerDataToSave.OrigamiKolibriRelative or 0
        data.OrigamiKolibriPreviousCounter = AllPlayerDataToSave.OrigamiKolibriPreviousCounter or 0
        data.kolibriTearsCount = AllPlayerDataToSave.kolibriTearsCount or 0
        data.OrigamiKolibriSpeedBoost = AllPlayerDataToSave.OrigamiKolibriSpeedBoost or 0
        data.OrigamiKolibriLimit = AllPlayerDataToSave.OrigamiKolibriLimit or 0

        data.chargeMemory = AllPlayerDataToSave.chargeMemory or 0
        data.OrigamiCrowRelative = AllPlayerDataToSave.OrigamiCrowRelative or 0
        data.OrigamiCrowPreviousCounter = AllPlayerDataToSave.OrigamiCrowPreviousCounter or 0

        data.brokenHeartsCount = AllPlayerDataToSave.brokenHeartsCount or 0
        data.holdingItemforStats = AllPlayerDataToSave.holdingItemforStats or 0

        data.MeteorRelative = AllPlayerDataToSave.MeteorRelative or 0
        data.MeteorPreviousCounter = AllPlayerDataToSave.MeteorPreviousCounter or 0

        data.FortuneTellerRelative = AllPlayerDataToSave.FortuneTellerRelative or 0
        data.FortuneTellerPreviousCounter = AllPlayerDataToSave.FortuneTellerPreviousCounter or 0
        data.FortuneTellerLuckBoost = AllPlayerDataToSave.FortuneTellerLuckBoost or 0

        data.BrokenFluxPreviousBrokenHearts = AllPlayerDataToSave.BrokenFluxPreviousBrokenHearts or 0
        data.BrokenFluxCharge = AllPlayerDataToSave.BrokenFluxCharge or 0
    end
end


-- Funzione per eseguire comandi dalla console
function BrokenOrigami:ExecuteConsoleCommand(_, Command)
    if Command == "Launch" then 
        for Load = 1, #ItemScript do
            require("script.item." .. ItemScript[Load])
        end
        print("Broken Origami: Scripts Launched")
    end
    if Command == "Script" then 
        for Load = 1, #ItemScript do
            print("script.item." .. ItemScript[Load])
        end
    end
end

-- Callback per salvare i dati prima di uscire dal gioco
BrokenOrigami:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, BrokenOrigami.SavePlayerData)

-- Callback per caricare i dati quando il giocatore è appena iniziato
BrokenOrigami:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, BrokenOrigami.LoadPlayerData)

-- Callback per i comandi della console
BrokenOrigami:AddCallback(ModCallbacks.MC_EXECUTE_CMD, BrokenOrigami.ExecuteConsoleCommand)
