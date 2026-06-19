-- ============================================
-- AMAZING RP FPS PACK - FPS МОНИТОР
-- ============================================

local screenWidth, screenHeight = GetScreenResolution()

-- ============================================
-- ОТРИСОВКА FPS
-- ============================================
function drawFPS(settings)
    if not settings.show_fps then return end
    
    local fps = math.floor(1.0 / GetFrameTime())
    
    -- Позиция
    local x, y = 0, 0
    local pos = settings.fps_position or 1
    
    if pos == 1 then       -- Правый верх
        x = screenWidth - 120
        y = 10
    elseif pos == 2 then   -- Левый верх
        x = 10
        y = 10
    elseif pos == 3 then   -- Правый низ
        x = screenWidth - 120
        y = screenHeight - 40
    elseif pos == 4 then   -- Левый низ
        x = 10
        y = screenHeight - 40
    end
    
    -- Цвет в зависимости от FPS
    local r, g, b
    if fps >= 60 then
        r, g, b = 0, 255, 0      -- Зелёный
    elseif fps >= 30 then
        r, g, b = 255, 255, 0    -- Жёлтый
    else
        r, g, b = 255, 0, 0      -- Красный
    end
    
    -- Отрисовка текста
    SetTextFont(0)
    SetTextScale(0.5, 0.5)
    SetTextColour(r, g, b, 200)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString("FPS: " .. fps)
    DrawText(x, y)
end
