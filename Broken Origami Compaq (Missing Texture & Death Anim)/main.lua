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


function BrokenOrigami:SavePlayerData()
    local player = Isaac.GetPlayer(0)
    local data = player:GetData()

    -- Salva tutte le variabili del giocatore
    AllPlayerDataToSave = {
        OrigamiSwanRelative = data.OrigamiSwanRelative or 0,
        OrigamiSwanPreviousCounter = data.OrigamiSwanPreviousCounter or 0,
        OrigamiShurikenRelative = data.OrigamiShurikenRelative or 0,
        OrigamiShurikenPreviousCounter = data.OrigamiShurikenPreviousCounter or 0,
        OrigamiShurikenDamageBoost = data.OrigamiShurikenDamageBoost or 0,
        OrigamiKolibriRelative = data.OrigamiKolibriRelative or 0,
        OrigamiKolibriPreviousCounter = data.OrigamiKolibriPreviousCounter or 0,
        kolibriTearsCount = data.kolibriTearsCount or 0,
        OrigamiKolibriSpeedBoost = data.OrigamiKolibriSpeedBoost or 0,
        OrigamiKolibriLimit = data.OrigamiKolibriLimit or 0,
        chargeMemory = data.chargeMemory or 0,
        OrigamiCrowRelative = data.OrigamiCrowRelative or 0,
        OrigamiCrowPreviousCounter = data.OrigamiCrowPreviousCounter or 0,
        brokenHeartsCount = data.brokenHeartsCount or 0,
        holdingItemforStats = data.holdingItemforStats or 0,
        MeteorRelative = data.MeteorRelative or 0,
        MeteorPreviousCounter = data.MeteorPreviousCounter or 0,
        FortuneTellerRelative = data.FortuneTellerRelative or 0,
        FortuneTellerPreviousCounter = data.FortuneTellerPreviousCounter or 0,
        FortuneTellerLuckBoost = data.FortuneTellerLuckBoost or 0,
        BrokenFluxPreviousBrokenHearts = data.BrokenFluxPreviousBrokenHearts or 0,
        BrokenFluxCharge = data.BrokenFluxCharge or 0
    }

    BrokenOrigami:SaveData(JsonSaveFile.encode(AllPlayerDataToSave))
end

-- Funzione di caricamento dei dati
function BrokenOrigami:LoadPlayerData()
    local player = Isaac.GetPlayer(0)
    local data = player:GetData()

    if BrokenOrigami:HasData() then
        -- Carica i dati solo se sono presenti nel file
        AllPlayerDataToSave = JsonSaveFile.decode(BrokenOrigami:LoadData())

        -- Assegna le variabili salvate al giocatore
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
    else
        -- Se non ci sono dati salvati, resetta i dati del giocatore
        BrokenOrigami:EraseData()
    end
end

-- Funzione per cancellare i dati alla fine di una partita
function BrokenOrigami:EraseDataOnNewGameOrEnd()
    isNewGame = true  -- Reset flag
    BrokenOrigami:SaveData("{}")  -- Cancella i dati salvati
end

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

BrokenOrigami:AddCallback(ModCallbacks.MC_EXECUTE_CMD,BrokenOrigami.ExecuteConsoleCommand)

BrokenOrigami:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, BrokenOrigami.SavePlayerData)

--BrokenOrigami:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, BrokenOrigami.LoadPlayerData)

--BrokenOrigami:AddCallback(ModCallbacks.MC_POST_GAME_END, BrokenOrigami.EraseDataOnNewGameOrEnd)

--BrokenOrigami:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, BrokenOrigami.EraseDataOnNewGameOrEnd)
