-- ============================================
-- AMAZING RP FPS PACK - BMW M5 G90 SPEEDOMETER
-- ============================================

-- Настройки
local speedoConfig = {
    enabled = true,
    sportMode = false,
    showRoad = true,
    position = {x = 0.02, y = 0.70}, -- нижний левый угол
    size = 1.0,
    opacity = 220,
}

-- ============================================
-- ОСНОВНАЯ ОТРИСОВКА
-- ============================================
function drawSpeedometer()
    if not speedoConfig.enabled then return end
    
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    
    if vehicle == 0 then return end
    
    -- Данные машины
    local speed = GetEntitySpeed(vehicle) * 3.6 -- km/h
    local rpm = GetVehicleCurrentRpm(vehicle)
    local gear = GetVehicleCurrentGear(vehicle)
    local fuel = getVehicleFuel(vehicle)
    local engineHealth = GetVehicleEngineHealth(vehicle)
    local oilTemp = getOilTemp(vehicle)
    
    -- Размеры экрана
    local screenW, screenH = GetScreenResolution()
    local posX = screenW * speedoConfig.position.x
    local posY = screenH * speedoConfig.position.y
    local scale = speedoConfig.size
    
    -- ============================================
    -- ФОН ДИСПЛЕЯ (ИЗОГНУТЫЙ)
    -- ============================================
    local panelW = 420 * scale
    local panelH = 250 * scale
    local panelX = posX + panelW / 2
    local panelY = posY + panelH / 2
    
    -- Тёмный фон
    DrawRect(panelX, panelY, panelW, panelH, 10, 10, 15, speedoConfig.opacity)
    
    -- Рамка (изогнутая — имитация линиями)
    local borderColor = speedoConfig.sportMode and {255, 30, 30} or {0, 255, 100}
    DrawRect(panelX, posY, panelW, 2, borderColor[1], borderColor[2], borderColor[3], 255)
    DrawRect(panelX, posY + panelH, panelW, 2, borderColor[1], borderColor[2], borderColor[3], 255)
    
    -- ============================================
    -- ШКАЛА СКОРОСТИ (ДУГА)
    -- ============================================
    local arcCenterX = panelX
    local arcCenterY = posY + 90 * scale
    local arcRadius = 160 * scale
    
    -- Деления: 0, 40, 80, 120, 160, 200, 240
    for i = 0, 240, 20 do
        local percent = i / 240
        local angle = math.pi * (0.15 + percent * 0.7) -- от 0.15π до 0.85π
        local x1 = arcCenterX - math.cos(angle) * arcRadius
        local y1 = arcCenterY - math.sin(angle) * arcRadius
        local x2 = arcCenterX - math.cos(angle) * (arcRadius - 15 * scale)
        local y2 = arcCenterY - math.sin(angle) * (arcRadius - 15 * scale)
        
        local r, g, b = 150, 150, 150
        
        -- Подсветка текущей зоны скорости
        if speed >= i and speed < i + 20 then
            r, g, b = borderColor[1], borderColor[2], borderColor[3]
        end
        
        -- Крупные деления
        if i % 40 == 0 then
            DrawLine(x1, y1, x2, y2, r, g, b, 255)
            
            -- Цифры
            SetTextFont(0)
            SetTextScale(0.25 * scale, 0.25 * scale)
            SetTextColour(r, g, b, 255)
            SetTextEntry("STRING")
            AddTextComponentString(tostring(i))
            DrawText(x2 - 8 * scale, y2 - 15 * scale)
        else
            DrawLine(x1, y1, x2, y2, r, g, b, 120)
        end
    end
    
    -- ============================================
    -- СТРЕЛКА СКОРОСТИ
    -- ============================================
    local speedPercent = math.min(speed / 240, 1.0)
    local speedAngle = math.pi * (0.15 + speedPercent * 0.7)
    local arrowTipX = arcCenterX - math.cos(speedAngle) * (arcRadius - 5 * scale)
    local arrowTipY = arcCenterY - math.sin(speedAngle) * (arcRadius - 5 * scale)
    
    -- Линия стрелки
    DrawLine(arcCenterX, arcCenterY, arrowTipX, arrowTipY, borderColor[1], borderColor[2], borderColor[3], 255)
    
    -- Наконечник (треугольник)
    DrawPoly(arrowTipX, arrowTipY, arrowTipX - 3*scale, arrowTipY - 8*scale, 
             arrowTipX + 3*scale, arrowTipY - 8*scale, borderColor[1], borderColor[2], borderColor[3], 255)
    
    -- ============================================
    -- ЦЕНТРАЛЬНАЯ ЦИФРА СКОРОСТИ
    -- ============================================
    local speedColor = speedoConfig.sportMode and {255, 30, 30} or {0, 255, 100}
    
    SetTextFont(7)
    SetTextScale(1.2 * scale, 1.2 * scale)
    SetTextColour(speedColor[1], speedColor[2], speedColor[3], 255)
    SetTextEntry("STRING")
    AddTextComponentString(string.format("%.0f", speed))
    DrawText(panelX - 50 * scale, arcCenterY - 10 * scale)
    
    -- km/h
    SetTextFont(0)
    SetTextScale(0.3 * scale, 0.3 * scale)
    SetTextColour(180, 180, 180, 255)
    SetTextEntry("STRING")
    AddTextComponentString("km/h")
    DrawText(panelX + 5 * scale, arcCenterY - 5 * scale)
    
    -- ============================================
    -- ГЕОМЕТРИЯ (КАК В BMW)
    -- ============================================
    -- Красные линии геометрии на фоне
    for i = 1, 3 do
        local gx = panelX - 100 * scale + i * 30 * scale
        local gy = arcCenterY + 30 * scale
        DrawRect(gx, gy, 20 * scale, 1, borderColor[1], borderColor[2], borderColor[3], 40)
        DrawRect(gx, gy + 5 * scale, 20 * scale, 1, borderColor[1], borderColor[2], borderColor[3], 25)
        DrawRect(gx, gy + 10 * scale, 20 * scale, 1, borderColor[1], borderColor[2], borderColor[3], 15)
    end
    
    -- ============================================
    -- НИЖНЯЯ ПАНЕЛЬ: ТОПЛИВО, ПЕРЕДАЧА, ТЕМП
    -- ============================================
    local bottomY = posY + panelH - 60 * scale
    
    -- Передача
    local gearText = getGearText(gear)
    SetTextFont(7)
    SetTextScale(0.7 * scale, 0.7 * scale)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    AddTextComponentString(gearText)
    DrawText(panelX - 180 * scale, bottomY)
    
    -- RPM полоска
    local rpmWidth = 150 * scale
    local rpmX = panelX - 60 * scale
    local rpmPercent = math.min(rpm / 1.0, 1.0)
    
    DrawRect(rpmX, bottomY + 15 * scale, rpmWidth, 4 * scale, 40, 40, 40, 200)
    DrawRect(rpmX - rpmWidth/2 + (rpmPercent * rpmWidth)/2, bottomY + 15 * scale, 
             rpmPercent * rpmWidth, 4 * scale, borderColor[1], borderColor[2], borderColor[3], 255)
    
    SetTextFont(0)
    SetTextScale(0.25 * scale, 0.25 * scale)
    SetTextColour(180, 180, 180, 255)
    SetTextEntry("STRING")
    AddTextComponentString(string.format("RPM %.1fk", rpm))
    DrawText(rpmX - 30 * scale, bottomY + 22 * scale)
    
    -- Топливо
    local fuelWidth = 100 * scale
    local fuelX = panelX + 100 * scale
    local fuelPercent = math.min(fuel / 100, 1.0)
    
    DrawRect(fuelX, bottomY + 15 * scale, fuelWidth, 4 * scale, 40, 40, 40, 200)
    DrawRect(fuelX - fuelWidth/2 + (fuelPercent * fuelWidth)/2, bottomY + 15 * scale,
             fuelPercent * fuelWidth, 4 * scale, 0, 180, 255, 255)
    
    SetTextScale(0.25 * scale, 0.25 * scale)
    SetTextColour(180, 180, 180, 255)
    SetTextEntry("STRING")
    AddTextComponentString(string.format("⛽ %.0f%%", fuel))
    DrawText(fuelX - 20 * scale, bottomY + 22 * scale)
    
    -- Температура масла
    local tempX = panelX + 100 * scale
    SetTextEntry("STRING")
    AddTextComponentString(string.format("🌡️ %d°C", oilTemp))
    DrawText(tempX, bottomY - 15 * scale)
    
    -- ============================================
    -- ДОРОГА В РЕАЛЬНОМ ВРЕМЕНИ
    -- ============================================
    if speedoConfig.showRoad then
        local roadX = posX + panelW + 15 * scale
        local roadY = posY
        local roadW = 180 * scale
        local roadH = 250 * scale
        
        -- Рамка "камеры"
        DrawRect(roadX + roadW/2, roadY + roadH/2, roadW, roadH, 5, 5, 10, 200)
        DrawRect(roadX + roadW/2, roadY, roadW, 2, borderColor[1], borderColor[2], borderColor[3], 200)
        DrawRect(roadX + roadW/2, roadY + roadH, roadW, 2, borderColor[1], borderColor[2], borderColor[3], 200)
        
        -- Камера (рендер сцены в миниатюре)
        -- Используем камеру от первого лица или камеру за машиной
        renderRoadCamera(roadX, roadY, roadW, roadH, vehicle)
        
        -- Подпись
        SetTextFont(0)
        SetTextScale(0.22 * scale, 0.22 * scale)
        SetTextColour(borderColor[1], borderColor[2], borderColor[3], 200)
        SetTextEntry("STRING")
        AddTextComponentString("ROAD VIEW")
        DrawText(roadX + 5 * scale, roadY + 5 * scale)
        
        -- Перекрестие по центру
        local roadCX = roadX + roadW/2
        local roadCY = roadY + roadH/2
        DrawRect(roadCX, roadCY, 20 * scale, 1, 255, 255, 255, 80)
        DrawRect(roadCX, roadCY, 1, 20 * scale, 255, 255, 255, 80)
    end
    
    -- ============================================
    -- ИНДИКАТОР РЕЖИМА
    -- ============================================
    local modeY = posY + panelH + 10 * scale
    local modeText = speedoConfig.sportMode and "SPORT" or "COMFORT"
    local modeColor = speedoConfig.sportMode and {255, 30, 30} or {0, 200, 100}
    
    SetTextFont(0)
    SetTextScale(0.3 * scale, 0.3 * scale)
    SetTextColour(modeColor[1], modeColor[2], modeColor[3], 255)
    SetTextEntry("STRING")
    AddTextComponentString("MODE: " .. modeText)
    DrawText(posX, modeY)
    
    -- Подвеска
    local suspensionText = speedoConfig.sportMode and "LOW" or "STANDARD"
    SetTextEntry("STRING")
    AddTextComponentString("SUSP: " .. suspensionText)
    DrawText(posX + 150 * scale, modeY)
    
    -- Подсказка
    SetTextScale(0.25 * scale, 0.25 * scale)
    SetTextColour(150, 150, 150, 200)
    SetTextEntry("STRING")
    AddTextComponentString("F6 — Sport Mode | F7 — Toggle Road View")
    DrawText(posX, modeY + 20 * scale)
end

-- ============================================
-- РЕНДЕР ДОРОГИ (МИНИ-КАМЕРА)
-- ============================================
function renderRoadCamera(x, y, w, h, vehicle)
    -- Создаём камеру за машиной
    local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    
    local vehPos = GetEntityCoords(vehicle)
    local vehForward = GetEntityForwardVector(vehicle)
    
    -- Камера над и позади машины
    local camPosX = vehPos.x - vehForward.x * 5.0
    local camPosY = vehPos.y - vehForward.y * 5.0
    local camPosZ = vehPos.z + 3.0
    
    SetCamCoord(cam, camPosX, camPosY, camPosZ)
    PointCamAtEntity(cam, vehicle, 0.0, 0.0, 0.0, true)
    
    -- Рендерим в прямоугольник
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 0, true, false)
    
    -- Возвращаем основную камеру
    DestroyCam(cam, false)
end

-- ============================================
-- ПОЛУЧИТЬ ТОПЛИВО
-- ============================================
function getVehicleFuel(vehicle)
    -- Пробуем получить через декоратор сервера
    local fuel = DecorGetFloat(vehicle, "vehicle_fuel")
    if fuel and fuel > 0 then return fuel end
    
    -- Или через стейт (Amazing RP)
    local fuelState = GetVehicleFuelLevel(vehicle)
    if fuelState then return fuelState end
    
    -- Заглушка
    return math.random(40, 100)
end

-- ============================================
-- ТЕМПЕРАТУРА МАСЛА
-- ============================================
function getOilTemp(vehicle)
    -- Зависит от RPM и скорости
    local rpm = GetVehicleCurrentRpm(vehicle)
    local speed = GetEntitySpeed(vehicle) * 3.6
    
    local temp = 80 + (rpm * 15) + (speed * 0.05)
    return math.floor(math.min(temp, 130))
end

-- ============================================
-- ТЕКСТ ПЕРЕДАЧИ
-- ============================================
function getGearText(gear)
    if gear == 0 then return "N"
    elseif gear == -1 then return "R"
    elseif gear == 1 then return "P"
    else return "D" .. tostring(gear - 1)
    end
end

-- ============================================
-- ПЕРЕКЛЮЧЕНИЕ СПОРТ-РЕЖИМА
-- ============================================
function toggleSportMode()
    speedoConfig.sportMode = not speedoConfig.sportMode
    
    -- Применяем гидравлику (если есть)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    
    if vehicle ~= 0 then
        if speedoConfig.sportMode then
            -- Занижаем подвеску
            SetVehicleSuspensionHeight(vehicle, -0.15)
            SetVehicleHandlingFloat(vehicle, "CHandlingData", "fSuspensionDampingCompression", 1.5)
        else
            -- Стандартная подвеска
            SetVehicleSuspensionHeight(vehicle, 0.0)
            SetVehicleHandlingFloat(vehicle, "CHandlingData", "fSuspensionDampingCompression", 1.0)
        end
    end
end

-- ============================================
-- ПЕРЕКЛЮЧЕНИЕ ВИДА ДОРОГИ
-- ============================================
function toggleRoadView()
    speedoConfig.showRoad = not speedoConfig.showRoad
end

-- ============================================
-- УПРАВЛЕНИЕ
-- ============================================
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        -- F6 — спорт-режим
        if IsControlJustPressed(0, 311) then -- F6
            toggleSportMode()
        end
        
        -- F7 — вид дороги
        if IsControlJustPressed(0, 312) then -- F7
            toggleRoadView()
        end
    end
end)
