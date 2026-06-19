-- ============================================
-- AMAZING RP FPS PACK - ОЧИСТКА ПАМЯТИ
-- ============================================

local cleanTimer = nil

-- ============================================
-- ПРИНУДИТЕЛЬНАЯ ОЧИСТКА
-- ============================================
function forceClearMemory()
    -- Очистка фокуса стриминга
    ClearFocus()
    
    -- Удаление ассетов
    RemoveAllWeaponAssets()
    RemoveAllAnimAssets()
    RemoveAllClothingAssets()
    
    -- Очистка памяти (натив)
    Citizen.InvokeNative(0x10D0A8A259E93AC9)
end

-- ============================================
-- АВТООЧИСТКА
-- ============================================
function startAutoClean(settings)
    stopAutoClean()
    
    if not settings.auto_clear_memory then return end
    
    local intervalMs = (settings.auto_clear_interval or 5) * 60000
    
    cleanTimer = SetTimer(forceClearMemory, intervalMs, 0)
end

function stopAutoClean()
    if cleanTimer then
        ClearTimer(cleanTimer)
        cleanTimer = nil
    end
end
