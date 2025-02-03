-- Configurações
local config = {
    carregadorProp = "prop_elecbox_10", -- Prop do carregador elétrico
    carrosEletricos = { -- Lista de modelos de carros elétricos
        "tezeract",
        "neon",
        "raiden"
    },
    tempoCarregamento = 30, -- Tempo de carregamento em segundos
    carregadorCoords = vector3(120.0, -200.0, 54.0) -- Coordenadas do carregador
}

-- Variáveis globais
local carregando = false
local progresso = 0

-- Função para verificar se o veículo é elétrico
local function isCarroEletrico(modelo)
    for _, carro in ipairs(config.carrosEletricos) do
        if modelo == GetHashKey(carro) then
            return true
        end
    end
    return false
end

-- Função para atualizar a UI
local function atualizarUI(progresso)
    SendNUIMessage({
        action = "updateProgress",
        progress = progresso
    })
end

-- Função principal de carregamento
local function carregarVeiculo()
    local playerPed = PlayerPedId()
    local veiculo = GetVehiclePedIsIn(playerPed, false)

    if veiculo and IsPedInAnyVehicle(playerPed, false) then
        local modelo = GetEntityModel(veiculo)

        if isCarroEletrico(modelo) then
            if not carregando then
                carregando = true
                local tempoInicial = GetGameTimer()

                -- Mostrar UI
                SendNUIMessage({ action = "showUI" })

                -- Loop de carregamento
                while carregando do
                    Citizen.Wait(1000)
                    local tempoDecorrido = (GetGameTimer() - tempoInicial) / 1000
                    progresso = math.floor((tempoDecorrido / config.tempoCarregamento) * 100)

                    -- Atualizar UI
                    atualizarUI(progresso)

                    if progresso >= 100 then
                        carregando = false
                        SetVehicleFuelLevel(veiculo, 100.0) -- Define o combustível como 100%
                        SendNUIMessage({ action = "hideUI" })
                        TriggerEvent("chat:addMessage", { args = { "Seu carro elétrico foi carregado com sucesso!" } })
                    end
                end
            else
                TriggerEvent("chat:addMessage", { args = { "Você já está carregando o veículo." } })
            end
        else
            TriggerEvent("chat:addMessage", { args = { "Este veículo não é elétrico." } })
        end
    else
        TriggerEvent("chat:addMessage", { args = { "Você precisa estar dentro de um veículo para carregar." } })
    end
end

-- Criação do ponto de carregamento
Citizen.CreateThread(function()
    local carregador = CreateObject(GetHashKey(config.carregadorProp), config.carregadorCoords.x, config.carregadorCoords.y, config.carregadorCoords.z, true, true, true)
    FreezeEntityPosition(carregador, true)

    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        if #(playerCoords - config.carregadorCoords) < 2.0 then
            DrawText3D(config.carregadorCoords.x, config.carregadorCoords.y, config.carregadorCoords.z, "Pressione ~g~E~w~ para carregar o veículo.")
            if IsControlJustReleased(0, 38) then -- 38 é a tecla E
                carregarVeiculo()
            end
        end
    end
end)

-- Função para desenhar texto 3D
function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
end