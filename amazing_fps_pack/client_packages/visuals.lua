-- ============================================
-- AMAZING RP FPS PACK - ВИЗУАЛ
-- ============================================

-- ============================================
-- ТЁМНЫЕ ДОРОГИ
-- ============================================
local roadsEnabled = false

function enableBlackRoads(darkness)
    roadsEnabled = true
    -- Затемнение через пост-обработку для асфальта
    SetBlackoutForRoads(true, darkness / 100)
end

function disableBlackRoads()
    roadsEnabled = false
    SetBlackoutForRoads(false, 0.0)
end

-- ============================================
-- ВСПЫШКИ ВЫСТРЕЛОВ (MUZZLE FLASH)
-- ============================================
function applyMuzzleFlash(flashType)
    -- flashType 1-4
    local intensity = 1.0
    
    if flashType == 1 then
        intensity = 0.5  -- Лёгкая
    elseif flashType == 2 then
        intensity = 1.0  -- Стандартная
    elseif flashType == 3 then
        intensity = 1.5  -- Яркая
    elseif flashType == 4 then
        intensity = 2.0  -- Очень яркая
    end
    
    SetWeaponMuzzleFlashIntensity(intensity)
end

-- ============================================
-- ЭФФЕКТЫ КРОВИ
-- ============================================
local bloodEffectsEnabled = false
local bloodSize = 50

function enableBloodEffects(size)
    bloodEffectsEnabled = true
    bloodSize = size
end

function disableBloodEffects()
    bloodEffectsEnabled = false
end

-- Обработчик попадания по игроку
function onPlayerHit(targetPlayer, bone)
    if not bloodEffectsEnabled then return end
    
    local ped = GetPlayerPed(targetPlayer)
    local coords = GetPedBoneCoords(ped, bone, 0.0, 0.0, 0.0)
    
    -- Создание эффекта крови
    local scale = bloodSize / 100
    UseParticleFxAsset("core")
    StartParticleFxNonLoopedAtCoord("blood_impact", coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, scale, false, false, false)
end

-- ============================================
-- КАСТОМНЫЕ ИКОНКИ ОРУЖИЯ (ЗАГЛУШКА)
-- ============================================
function applyCustomWeaponIcons()
    -- В RAGE:MP Lua смена иконок требует замены .ytd файлов
    -- Это делается через стриминг ассетов, оставляем заглушку
end

function applyCustomFistIcon()
    -- Аналогично, замена текстуры кулака
end

-- ============================================
-- КАСТОМНЫЕ ШРИФТЫ (ЗАГЛУШКА)
-- ============================================
function applyCustomFonts()
    -- Шрифты меняются через CEF или замену файлов
    -- В чистом Lua сложно, оставляем заглушку
end
