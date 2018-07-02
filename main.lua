-----------------------------------------------------------------------------------------
--
-- main.lua
-- author Kaio César Bezerra da Silva
--
-----------------------------------------------------------------------------------------

--Criar Snake
function criarSnake()
    snake = {}
    snake[1] = display.newRect(display.contentWidth*0.5, display.contentHeight*0.5, 10, 10)
end

-----------------------------------------------------------------------------------------
--Pontuação
local pontos = 0

function pontuar(ponto)
    pontos = pontos + ponto
    mostrarPontuacao()
    dificutarJogo()
end

function zerarPontos()
    pontos = 0
    mostrarPontuacao()
end

local score = display.newText("Score: 0", 50, -15)

function mostrarPontuacao()
    score.isVisible = false
    score = display.newText("Score: "..pontos, 50, -15)
end

local hiscore = display.newText("Hi-Score: 0", 280, -15, 120, 20, native.systemFont)
local ultimoRecode = 0

function mostrarUltimaPontuacao()
    local recode = pontos

    if recode >= ultimoRecode then
        hiscore.isVisible = false
        hiscore = display.newText("Hi-Score: "..recode, 280, -15, 120, 20, native.systemFont)
        ultimoRecode = recode
    end
end

-----------------------------------------------------------------------------------------
--Criar comida
function criarComida()
    comida = display.newRect(math.random(12, 300), math.random(15, 330), 10, 10)
end

--Criar comida bonus
local bonus = nil

function validarPosicaoBonus()
    local posBonusX = math.random(18, 300)
    local posBonusY = math.random(15, 330)

    if posBonusX ~= comida.x or posBonusY ~= comida.y then
        bonus.x = posBonusX
        bonus.y = posBonusY
    else
        validarPosicaoBonus()
    end
end

local imagemTipo = nil
function gerarBonus()
    imagemTipo = math.random(1, 4)
    bonus = display.newImageRect("imagem"..imagemTipo..".png", 16, 10)
    validarPosicaoBonus()
end

function removerBonus() 
    if bonus ~= nil then
        display.remove(bonus)
        display.remove(iconBonus)
        display.remove(tempoText)
        bonus = nil
    end
end

function mostrarBonus()
    if pontos%50 == 0 then
        gerarBonus()
        tempoRestBonus()
        mostrarTempoRestBonus()
        timer.performWithDelay(10000, removerBonus)
    end
end

--Timer bonus
local tempoRest = 10
function mostrarTempoRestBonus()
    iconBonus = display.newImageRect("imagem"..imagemTipo..".png", 16, 10)
    iconBonus.x, iconBonus.y = display.contentWidth*0.5-10, -15
    tempoText = display.newText(tempoRest, display.contentWidth*0.5+10, -15)
    
end

function contarTempoRestBonus()
    tempoRest = tempoRest - 1
    tempoText.text = tempoRest
    if tempoRest == 0 then
        tempoRest = 10
    end
end

function tempoRestBonus()
    timer.performWithDelay(1000, contarTempoRestBonus, 10)
end

-----------------------------------------------------------------------------------------
--Criar senario
function criarCenario()
    linhaTop = display.newRect(display.contentWidth * 0.5, 0, 320, 5)
    linhaRight = display.newRect(display.contentWidth - 2, 175, 5, 350)
    linhaBotton = display.newRect(display.contentWidth * 0.5, 352, 320, 5)
    linhaLeft = display.newRect(2, 175, 5, 350)
end

--Criar botoes
function criarBotoes() 
    botaoUp = display.newRect(display.contentWidth * 0.5, 390, 80, 40)
    local textoUp = {x = 160, y = 390, text = "Up"}
    local textoBotaoUp = display.newText(textoUp)
    textoBotaoUp:setTextColor(0, 0, 0)

    botaoRight = display.newRect(display.contentWidth * 0.8, 440, 80, 40)
    local textoRight = {x = 256, y = 440, text = "Right"}
    local textoBotaoRight = display.newText(textoRight)
    textoBotaoRight:setTextColor(0, 0, 0)

    botaoDown = display.newRect(display.contentWidth * 0.5, 490, 80, 40)
    local textoDown = {x = 160, y = 490, text = "Down"}
    local textoBotaoDown = display.newText(textoDown)
    textoBotaoDown:setTextColor(0, 0, 0)

    botaoLeft = display.newRect(display.contentWidth * 0.2, 440, 80, 40)
    local textoLeft = {x = 65, y = 440, text = "Left"}
    local textoBotaoLeft = display.newText(textoLeft)
    textoBotaoLeft:setTextColor(0, 0, 0)
end

-----------------------------------------------------------------------------------------
--Nivel de velocidade do snake
local velocidade = 3

function dificutarJogo()
    if pontos == 0 then
        velocidade = 3
    elseif pontos >= 110 and pontos < 210 then
        velocidade = 5
    elseif pontos >= 210 and pontos < 400 then
        velocidade = 8
    elseif pontos > 400 then
        velocidade = 10
    end
end

-----------------------------------------------------------------------------------------
--Iniciar jogo
local function resetarJogo()
	limparJogo()
	
	--criar display
	criarSnake()
	criarComida()
    mostrarUltimaPontuacao()
    zerarPontos()
    dificutarJogo()
end

function limparJogo()
    --remove a serpente do display
	for i, v in ipairs(snake) do
        v:removeSelf()
    end
      
      comida:removeSelf()
      removerBonus()
end

-----------------------------------------------------------------------------------------
--Evento
local eixoX = velocidade
local eixoY = 0

local function checarColisao()
	local posX = snake[1].x
	local posY = snake[1].y
	
	--Checar colisão
    if posX < 15 or posX > 305 then
		iniciarJogo()
	    return
	end

    if posY < 10 or posY > 340 then
	    iniciarJogo()
	    return
	end
	
	for i, v in ipairs(snake) do
		if (posX + eixoX) == v.x and (posY + eixoY) == v.y then
            if i ~= #snake then
				iniciarJogo()
				return
			end
		end
	end

	--comer comida
	local xnext = posX + eixoX
    local ynext = posY + eixoY
    
	if (xnext >= comida.x-10 and xnext <= comida.x+10) and (ynext >= comida.y-10 and ynext <= comida.y+10) then
		snake[#snake+1] = display.newRect(snake[#snake].x-5, snake[#snake].y-5, 10, 10)

		--resposicionar comida
		comida.x = math.random(12, 300)
        comida.y = math.random(15, 330)
        pontuar(10)
        mostrarBonus()
    end
    
    if bonus ~= nil then
        if (xnext >= bonus.x-10 and xnext <= bonus.x+10) and (ynext >= bonus.y-10 and ynext <= bonus.y+10) then
            snake[#snake+1] = display.newRect(snake[#snake].x-5, snake[#snake].y-5, 10, 10)
            pontuar(20)
            removerBonus()
        end
    end	
end

-----------------------------------------------------------------------------------------
--movimentação do snake
function movimentarSnake()
    if #snake == 1 then
		snake[1]:translate(eixoX, eixoY)
	else
		for i, v in ipairs(snake) do
			v.xold = v.x
            v.yold = v.y
            
            if i == 1 then 
                v:translate(eixoX, eixoY)
            else 
                v:translate(snake[i-1].xold - v.x, snake[i-1].yold - v.y)
			end
		end
	end	
end

-----------------------------------------------------------------------------------------
--Jogar o jogo
function jogar()
    checarColisao()
    movimentarSnake()
end

-----------------------------------------------------------------------------------------
--Iniciar jogo
function iniciarJogo()
    timer.pause(timerEvento)
    local cenario = display.newRect(0, 0, display.contentWidth*2, display.contentHeight*3)
    cenario:setFillColor(0, 0, 0)

    local logo = display.newImageRect("logojogo.png", 200, 100)
    logo.x, logo.y = display.contentWidth*0.5, display.contentHeight*0.25
    
    local mensGameOver = display.newText("Game Over", display.contentWidth*0.5, display.contentHeight*0.55, native.systemFont, 20)

    local botaoNovoJogo = display.newRect(display.contentWidth*0.5, display.contentHeight*0.8, 120, 40)
    local textoBotaoNovoJogo = {x = display.contentWidth*0.5, y = display.contentHeight*0.8, text = "Novo Jogo"}
    local textoNovoJogo = display.newText(textoBotaoNovoJogo)
    textoNovoJogo:setTextColor(0, 0, 0)

    function botaoNovoJogo:touch(event)
        if event.phase == "began" then
            display.remove(mensGameOver)
            display.remove(cenario)
            display.remove(logo)
            display.remove(botaoNovoJogo)
            textoBotaoNovoJogo = nil
            display.remove(textoNovoJogo)
            resetarJogo()
            timer.resume(timerEvento)
            return true 
        end
    end
    botaoNovoJogo:addEventListener("touch", botaoNovoJogo)
end

-----------------------------------------------------------------------------------------
--Ações
timerEvento = timer.performWithDelay(100, jogar, 0)
criarSnake()
criarComida()
criarCenario()
criarBotoes()
mostrarPontuacao()
mostrarUltimaPontuacao()

-----------------------------------------------------------------------------------------
 --Event botões
 function botaoUp:touch(event)
    if event.phase == "began" then
            eixoX = 0
            eixoY = -(velocidade)
        return true
    end
end
botaoUp:addEventListener("touch", botaoUp)

function botaoRight:touch(event)
    if event.phase == "began" then
            eixoX = velocidade
            eixoY = 0
        return true
    end
end
botaoRight:addEventListener("touch", botaoRight)

function botaoDown:touch(event)
    if event.phase == "began" then
            eixoX = 0
            eixoY = velocidade
        return true
    end
end
botaoDown:addEventListener("touch", botaoDown)

function botaoLeft:touch(event)
    if event.phase == "began" then
            eixoX = -(velocidade)
            eixoY = 0
        return true
    end
end
botaoLeft:addEventListener("touch", botaoLeft)
