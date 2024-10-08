local game = Game()

-- Definisci l'oggetto Meteor
local MeteorItemId = Isaac.GetItemIdByName("Meteor")

if EID then
    EID:addCollectible(MeteorItemId, "{{Warning}} DANGER {{Warning}}#{{Warning}} YOU CAN PROBABLY HIT BY A METEOR {{Warning}}")
end

-- Funzione per attivare Crack of the Sky in una posizione casuale nella stanza
local function triggerCrackOfTheSky()
    local room = game:GetRoom()  -- Ottieni la stanza attuale
    local roomWidth = room:GetGridWidth() * 40  -- Dimensioni della stanza in base alla griglia (ogni cella è 40 pixel)
    local roomHeight = room:GetGridHeight() * 40

    -- Genera una posizione casuale all'interno della stanza
    local randomX = math.random(room:GetTopLeftPos().X, room:GetBottomRightPos().X)
    local randomY = math.random(room:GetTopLeftPos().Y, room:GetBottomRightPos().Y)
    local randomPosition = Vector(randomX, randomY)

    -- Crea l'effetto Crack of the Sky in quella posizione
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACK_THE_SKY, 0, randomPosition, Vector(0,0), nil)
end

-- Controlla se il giocatore ha l'oggetto Meteor e avvia il sistema randomico
function BrokenOrigami:OnUpdate()
    local player = Isaac.GetPlayer(0)
    local numberOfMeteors = player:GetCollectibleNum(MeteorItemId)
    
    if numberOfMeteors > 0 then
        -- Estrai un numero da 1 a 1024. La probabilità aumenta con il numero di meteore
        local randomValue = math.random(1, math.floor(1024 / numberOfMeteors))
        
        if randomValue == 1 then
            triggerCrackOfTheSky()  -- Attiva il raggio in una posizione randomica nella stanza
        end
    end
end

-- Registra la funzione di aggiornamento
BrokenOrigami:AddCallback(ModCallbacks.MC_POST_UPDATE, BrokenOrigami.OnUpdate)


