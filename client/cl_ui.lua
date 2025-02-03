-- Função para mostrar a UI
function mostrarUI()
    SendNUIMessage({
        action = "showUI"
    })
end

-- Função para esconder a UI
function esconderUI()
    SendNUIMessage({
        action = "hideUI"
    })
end

-- Função para atualizar o progresso na UI
function atualizarUI(progresso)
    SendNUIMessage({
        action = "updateProgress",
        progress = progresso
    })
end

-- Evento para receber comandos da UI (opcional, caso precise de interações da UI para o jogo)
RegisterNUICallback('comandoDaUI', function(data, cb)
    -- Exemplo: Se a UI enviar um comando, você pode processá-lo aqui
    if data.acao == "fechar" then
        esconderUI()
    end
    cb('ok')
end)