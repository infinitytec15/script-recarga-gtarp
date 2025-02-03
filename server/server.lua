-- Variável para armazenar o estado de carregamento dos jogadores
local carregando = {}

-- Evento para iniciar o carregamento
RegisterServerEvent('electric_charging:iniciarCarregamento')
AddEventHandler('electric_charging:iniciarCarregamento', function()
    local playerId = source
    carregando[playerId] = true
    TriggerClientEvent('electric_charging:atualizarUI', playerId, 0) -- Inicia a UI no cliente
end)

-- Evento para parar o carregamento
RegisterServerEvent('electric_charging:pararCarregamento')
AddEventHandler('electric_charging:pararCarregamento', function()
    local playerId = source
    carregando[playerId] = nil
    TriggerClientEvent('electric_charging:esconderUI', playerId) -- Esconde a UI no cliente
end)

-- Evento para atualizar o progresso do carregamento
RegisterServerEvent('electric_charging:atualizarProgresso')
AddEventHandler('electric_charging:atualizarProgresso', function(progresso)
    local playerId = source
    TriggerClientEvent('electric_charging:atualizarUI', playerId, progresso) -- Atualiza a UI no cliente
end)