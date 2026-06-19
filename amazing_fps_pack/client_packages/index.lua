-- ============================================
-- AMAZING RP FPS PACK - ТОЧКА ВХОДА
-- ============================================

local settings = nil
local menuActive = false

-- ============================================
-- ЗАГРУЗКА ВСЕХ МОДУЛЕЙ
-- ============================================
Citizen.CreateThread(function()
    -- Загружаем настройки
    settings = loadSettings()
    
    -- Применяем FPS твики сразу
    applyAllFpsSettings(settings)
    saveBaseFPS()
    
    -- Запускаем автоочистку памяти
    startAutoClean(settings)
    
    -- Уведомление
    SetNotificationTextEntry("STRING")
    AddTextComponentString("~g~[FPS PACK] ~w~Сборка активирована! ~b~F2 ~w~— меню")
    DrawNotification(false, true)
    
    -- ============================================
    -- ГЛАВНЫЙ ЦИКЛ
    -- ============================================
    while true do
        Citizen.Wait(0)
        
        -- Обработчик F2
        if IsControlJustPressed(0, 57) then -- F2
            menuActive = not menuActive
            if not menuActive then
                -- При закрытии меню сразу применяем настройки
                applyAllFpsSettings(settings)
            end
        end
        
        -- Скрываем стандартный прицел
        if settings.custom_crosshair then
            HideHudComponentThisFrame(14)
        end
        
        -- Отрисовка меню
        if menuActive then
            drawMenu(settings)
        end
        
        -- Отрисовка FPS
        if settings.show_fps and not menuActive then
            drawFPS(settings)
        end
        
        -- Отрисовка кастомного прицела
        if settings.custom_crosshair and not menuActive then
            drawCustomCrosshair(settings)
        end
        
        -- Отрисовка хитмаркера
        drawHitmarker()
        
        -- Работа умного прицела
        if not menuActive then
            aimLoop(settings)
        end
        
        -- No recoil постоянно (если включен)
        if settings.no_recoil and not menuActive then
            local playerPed = PlayerPedId()
            if IsPedArmed(playerPed, 4) then -- Любое оружие
                SetPedRecoilForce(playerPed, 0.0)
                SetPedRecoilShake(playerPed, 0.0)
            end
        end
    end
end)
