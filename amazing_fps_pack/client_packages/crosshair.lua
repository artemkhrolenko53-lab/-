-- ============================================
-- AMAZING RP FPS PACK - КАСТОМНЫЙ ПРИЦЕЛ
-- ============================================

local screenW, screenH = 0, 0

-- ============================================
-- СКРЫТЬ СТАНДАРТНЫЙ ПРИЦЕЛ
-- ============================================
function hideDefaultCrosshair()
    HideHudComponentThisFrame(14) -- Crosshair
end

-- ============================================
-- ОТРИСОВКА КАСТОМНОГО ПРИЦЕЛА
-- ============================================
function drawCustomCrosshair(settings)
    if not settings.custom_crosshair then return end
    
    screenW, screenH = GetScreenResolution()
    local cx, cy = screenW / 2, screenH / 2
    local size = settings.crosshair_size
    local r, g, b, a = table.unpack(settings.crosshair_color)
    local alpha = settings.crosshair_alpha
    
    -- Меняем цвет если на враге
    if isAimingAtPlayer() then
        r, g, b, a = table.unpack(settings.aim_color_enemy)
    end
    
    -- Динамический размер от разброса
    if settings.aim_dynamic_size then
        local weapon = GetSelectedPedWeapon(PlayerPedId())
        if weapon ~= -1569615261 then
            local spread = GetWeaponSpread(weapon)
            size = size + (spread * 100)
        end
    end
    
    local style = settings.crosshair_style
    
    if style == 1 then
        -- Точка
        DrawRect(cx, cy, 2, 2, r, g, b, alpha)
        
    elseif style == 2 then
        -- Крест
        DrawRect(cx, cy, size, 2, r, g, b, alpha)
        DrawRect(cx, cy, 2, size, r, g, b, alpha)
        
    elseif style == 3 then
        -- Круг с точкой
        DrawCircle(cx, cy, size / 2, r, g, b, alpha)
        DrawRect(cx, cy, 2, 2, r, g, b, alpha)
        
    elseif style == 4 then
        -- Т-образный
        DrawRect(cx, cy - size/2, 2, size/2, r, g, b, alpha)
        DrawRect(cx - size/2, cy - size/2, size, 1, r, g, b, alpha)
        DrawRect(cx, cy + size/2, 2, size/2, r, g, b, alpha)
        DrawRect(cx - size/2, cy + size/2, size, 1, r, g, b, alpha)
        DrawRect(cx - size/2, cy, size/2, 2, r, g, b, alpha)
        DrawRect(cx + size/2, cy, size/2, 2, r, g, b, alpha)
        
    elseif style == 5 then
        -- Шеврон
        DrawRect(cx, cy - size/2, 2, size/2, r, g, b, alpha)
        DrawRect(cx - 2, cy - size/2, 4, 1, r, g, b, alpha)
        DrawRect(cx + 2, cy - size/2, 4, 1, r, g, b, alpha)
    end
end

-- ============================================
-- ХИТМАРКЕР
-- ============================================
local hitmarkerActive = false
local hitmarkerTime = 0
local HITMARKER_DURATION = 200 -- мс

function showHitmarker()
    hitmarkerActive = true
    hitmarkerTime = GetGameTimer()
end

function drawHitmarker()
    if not hitmarkerActive then return end
    
    local now = GetGameTimer()
    if now - hitmarkerTime > HITMARKER_DURATION then
        hitmarkerActive = false
        return
    end
    
    local cx, cy = screenW / 2, screenH / 2
    local size = 10
    
    -- Белый крестик
    DrawRect(cx, cy - size, 2, size, 255, 255, 255, 255)
    DrawRect(cx, cy + size, 2, size, 255, 255, 255, 255)
    DrawRect(cx - size, cy, size, 2, 255, 255, 255, 255)
    DrawRect(cx + size, cy, size, 2, 255, 255, 255, 255)
end
