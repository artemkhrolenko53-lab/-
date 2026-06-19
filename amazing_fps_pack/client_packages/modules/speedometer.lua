-- ============================================
-- AMAZING RP FPS PACK
-- BMW M5 G90 CURVED DISPLAY v4.0
-- МАКСИМАЛЬНО ПРИБЛИЖЕН К РЕАЛЬНОСТИ
-- ============================================

local Config = {
    enabled = true,
    mode = 1, -- 1=Comfort, 2=Sport, 3=Sport+, 4=Eco Pro
    showRoad = true,
    position = {x = 0.02, y = 0.68},
    currentPosition = 1,
    scale = 1.0,
    unit = "km/h",
    needleSmoothing = 0.94,
    smoothedSpeed = 0,
    smoothedRpm = 0,
    fadeAlpha = 0,
    cruiseEnabled = false,
    cruiseSpeed = 0,
}

local modes = {
    [1] = {name = "COMFORT",  accent = {255, 255, 255}, secondary = {0, 200, 100},  redZone = 220, bgColor = {12, 12, 16}},
    [2] = {name = "SPORT",    accent = {255, 40, 40},   secondary = {255, 80, 80},   redZone = 200, bgColor = {8, 8, 12}},
    [3] = {name = "SPORT+",   accent = {255, 140, 0},   secondary = {255, 60, 0},    redZone = 160, bgColor = {4, 4, 8}},
    [4] = {name = "ECO PRO",  accent = {0, 180, 255},   secondary = {0, 140, 220},   redZone = 240, bgColor = {10, 12, 16}},
}

local positions = {
    [1] = {x = 0.02, y = 0.70},
    [2] = {x = 0.26, y = 0.70},
    [3] = {x = 0.50, y = 0.70},
    [4] = {x = 0.02, y = 0.02},
    [5] = {x = 0.26, y = 0.02},
    [6] = {x = 0.50, y = 0.02},
}

-- ============================================
-- ПОЛУЧИТЬ ДАННЫЕ
-- ============================================
local function getVehicleData()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if vehicle == 0 then return nil end

    local speed = GetEntitySpeed(vehicle)
    if Config.unit == "mph" then speed = speed * 2.2369
    else speed = speed * 3.6 end

    local rpm = GetVehicleCurrentRpm(vehicle)
    local boost = math.max(0, (rpm - 0.3) * 2.2)

    return {
        speed = speed,
        rpm = rpm,
        gear = GetVehicleCurrentGear(vehicle),
        fuel = DecorGetFloat(vehicle, "vehicle_fuel") or math.random(40, 100),
        oilTemp = math.floor(80 + rpm * 20 + speed * 0.03),
        boost = math.min(boost, 2.5),
        odometer = math.floor(GetEntityCoords(vehicle).x * 100) % 999999,
        lightsOn = GetVehicleLightsState(vehicle) > 0,
        highBeam = GetVehicleLightsState(vehicle) == 2,
        turnLeft = DecorGetBool(vehicle, "indicator_left") or false,
        turnRight = DecorGetBool(vehicle, "indicator_right") or false,
    }
end

-- ============================================
-- ПЛАВНОСТЬ
-- ============================================
local function smoothValue(current, target, smoothing)
    return current + (target - current) * (1 - smoothing)
end

-- ============================================
-- ПЕРЕДАЧА
-- ============================================
local function getGearText(gear)
    if gear == 0 then return "N"
    elseif gear == -1 then return "R"
    elseif gear == 1 then return "P"
    else return "D" .. tostring(gear - 1)
    end
end

-- ============================================
-- ОСНОВНАЯ ОТРИСОВКА
-- ============================================
function drawSpeedometer()
    if not Config.enabled then return end

    local data = getVehicleData()
    if not data then
        Config.smoothedSpeed = 0
        Config.smoothedRpm = 0
        Config.fadeAlpha = 0
        return
    end

    Config.smoothedSpeed = smoothValue(Config.smoothedSpeed, data.speed, Config.needleSmoothing)
    Config.smoothedRpm = smoothValue(Config.smoothedRpm, data.rpm, Config.needleSmoothing)

    if Config.fadeAlpha < 255 then
        Config.fadeAlpha = math.min(Config.fadeAlpha + 6, 255)
    end

    local mode = modes[Config.mode]
    local screenW, screenH = GetScreenResolution()
    local posX = screenW * Config.position.x
    local posY = screenH * Config.position.y
    local s = Config.scale
    local alpha = Config.fadeAlpha
    local speed = Config.smoothedSpeed
    local rpm = Config.smoothedRpm
    local maxSpeed = Config.unit == "mph" and 160 or 260

    -- ============================================
    -- ДИСПЛЕЙ (ИЗОГНУТЫЙ)
    -- ============================================
    local panelW = 520 * s
    local panelH = 290 * s
    local pX = posX + panelW / 2
    local pY = posY + panelH / 2
    local bg = mode.bgColor

    -- Основной фон
    DrawRect(pX, pY, panelW, panelH, bg[1], bg[2], bg[3], math.min(alpha, 240))

    -- Зернистость (антиблик)
    for i = 1, 30 do
        local gx = posX + math.random() * panelW
        local gy = posY + math.random() * panelH
        DrawRect(gx, gy, 1, 1, 255, 255, 255, math.random(3, 8))
    end

    -- Хромированная рамка
    for i = 0, 60 do
        local t = i / 60
        local curveX = posX + t * panelW
        local curveY = posY + math.sin(t * math.pi) * 10 * s
        DrawRect(curveX, curveY, panelW / 60 + 1, 2.5 * s, 180, 180, 190, math.floor(alpha * 0.6))

        curveY = posY + panelH - math.sin(t * math.pi) * 10 * s
        DrawRect(curveX, curveY, panelW / 60 + 1, 2.5 * s, 180, 180, 190, math.floor(alpha * 0.6))
    end

    -- ============================================
    -- ШКАЛА СКОРОСТИ (ВЕРХНЯЯ ДУГА)
    -- ============================================
    local arcCX = pX
    local arcCY = posY + 80 * s
    local arcR = 175 * s

    -- Световая дорожка (пройденный путь)
    if speed > 0 then
        local trailPercent = math.min(speed / maxSpeed, 1.0)
        for i = 1, math.floor(trailPercent * 100) do
            local t = i / 100
            local angle = math.pi * (0.15 + t * 0.7)
            local tx = arcCX - math.cos(angle) * arcR
            local ty = arcCY - math.sin(angle) * arcR
            local col = mode.accent
            DrawRect(tx, ty, 2, 4 * s, col[1], col[2], col[3], math.floor(alpha * 0.7))
        end
    end

    -- Деления
    for i = 0, maxSpeed, 5 do
        local percent = i / maxSpeed
        local angle = math.pi * (0.15 + percent * 0.7)
        local x1 = arcCX - math.cos(angle) * arcR
        local y1 = arcCY - math.sin(angle) * arcR

        local lineLen
        local thickness
        local r, g, b

        if i % 20 == 0 then
            lineLen = 22 * s
            thickness = 2
            r, g, b = 220, 220, 220
        elseif i % 10 == 0 then
            lineLen = 14 * s
            thickness = 1.5
            r, g, b = 180, 180, 180
        else
            lineLen = 8 * s
            thickness = 1
            r, g, b = 120, 120, 120
        end

        -- Красная зона
        if i >= mode.redZone then
            r, g, b = 255, 50, 50
        end

        -- Текущая зона ярче
        if speed >= i and speed < i + 5 then
            r, g, b = mode.accent[1], mode.accent[2], mode.accent[3]
        end

        local x2 = arcCX - math.cos(angle) * (arcR - lineLen)
        local y2 = arcCY - math.sin(angle) * (arcR - lineLen)

        DrawLine(x1, y1, x2, y2, r, g, b, math.floor(alpha * 0.85))

        -- Цифры
        if i % 20 == 0 then
            local tx = arcCX - math.cos(angle) * (arcR - 30 * s)
            local ty = arcCY - math.sin(angle) * (arcR - 30 * s)
            SetTextFont(0)
            SetTextScale(0.24 * s, 0.24 * s)
            SetTextColour(r, g, b, math.floor(alpha * 0.9))
            SetTextCentre(true)
            SetTextEntry("STRING")
            AddTextComponentString(tostring(i))
            DrawText(tx, ty)
        end
    end

    -- ============================================
    -- СТРЕЛКА (ЛАЗЕРНАЯ)
    -- ============================================
    local speedPercent = math.min(speed / maxSpeed, 1.0)
    local speedAngle = math.pi * (0.15 + speedPercent * 0.7)
    local tipX = arcCX - math.cos(speedAngle) * (arcR - 5 * s)
    local tipY = arcCY - math.sin(speedAngle) * (arcR - 5 * s)

    -- Тень
    DrawLine(arcCX + 2*s, arcCY + 2*s, tipX + 2*s, tipY + 2*s, 0, 0, 0, math.floor(alpha * 0.4))

    -- Стрелка
    local color = mode.accent
    if mode.name == "COMFORT" or mode.name == "ECO PRO" then
        color = {255, 255, 255}
    end
    DrawLine(arcCX, arcCY, tipX, tipY, color[1], color[2], color[3], math.floor(alpha))

    -- Наконечник
    local perp = speedAngle + math.pi / 2
    DrawPoly(
        tipX + math.cos(perp) * 3*s, tipY + math.sin(perp) * 3*s,
        tipX - math.cos(perp) * 3*s, tipY - math.sin(perp) * 3*s,
        arcCX - math.cos(speedAngle) * (arcR - 18*s),
        arcCY - math.sin(speedAngle) * (arcR - 18*s),
        color[1], color[2], color[3], math.floor(alpha)
    )

    -- Центр
    DrawCircle(arcCX, arcCY, 5*s, color[1], color[2], color[3], math.floor(alpha))

    -- ============================================
    -- ЦЕНТРАЛЬНАЯ ЦИФРА
    -- ============================================
    local speedStr = string.format("%.0f", speed)

    -- Glow
    for i = 6, 1, -1 do
        local a = math.floor(alpha * (0.08 / i))
        SetTextFont(7)
        SetTextScale(1.0 * s, 1.0 * s)
        SetTextColour(255, 255, 255, a)
        SetTextCentre(true)
        SetTextEntry("STRING")
        AddTextComponentString(speedStr)
        DrawText(pX, arcCY - 2*s)
    end

    -- Основной текст
    SetTextFont(7)
    SetTextScale(1.0 * s, 1.0 * s)
    SetTextColour(255, 255, 255, math.floor(alpha))
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString(speedStr)
    DrawText(pX, arcCY - 2*s)

    -- Единицы
    SetTextFont(0)
    SetTextScale(0.25 * s, 0.25 * s)
    SetTextColour(160, 160, 160, math.floor(alpha))
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString(Config.unit)
    DrawText(pX, arcCY + 22*s)

    -- ============================================
    -- ПЕРЕДАЧА
    -- ============================================
    local gearText = getGearText(data.gear)
    SetTextFont(7)
    SetTextScale(0.6 * s, 0.6 * s)
    SetTextColour(255, 255, 255, math.floor(alpha))
    SetTextEntry("STRING")
    AddTextComponentString(gearText)
    DrawText(pX - 210*s, posY + panelH - 70*s)

    -- ============================================
    -- RPM (ДУГА ВНИЗУ)
    -- ============================================
    local rpmArcCY = posY + panelH - 45*s
    local rpmArcR = 140*s

    -- Фоновая дуга
    for i = 0, 100, 2 do
        local t = i / 100
        local angle = math.pi * (0.2 + t * 0.6)
        local x1 = arcCX - math.cos(angle) * rpmArcR
        local y1 = rpmArcCY - math.sin(angle) * rpmArcR
        local r, g, b = 80, 80, 80

        if t > 0.7 then r, g, b = 200, 50, 50
        elseif t > 0.6 then r, g, b = 200, 180, 50 end

        DrawRect(x1, y1, 2, 3*s, r, g, b, math.floor(alpha * 0.5))
    end

    -- Текущие RPM
    if rpm > 0 then
        local rpmPercent = math.min(rpm / 1.0, 1.0)
        for i = 1, math.floor(rpmPercent * 100) do
            local t = i / 100
            local angle = math.pi * (0.2 + t * 0.6)
            local tx = arcCX - math.cos(angle) * rpmArcR
            local ty = rpmArcCY - math.sin(angle) * rpmArcR
            local r, g, b = mode.accent[1], mode.accent[2], mode.accent[3]
            if t > 0.7 then r, g, b = 255, 50, 50 end
            DrawRect(tx, ty, 2, 3*s, r, g, b, math.floor(alpha * 0.9))
        end
    end

    -- ============================================
    -- ТОПЛИВО
    -- ============================================
    local fuelX = pX + 160*s
    local fuelY = posY + panelH - 60*s
    local fuelPercent = math.min(data.fuel / 100, 1.0)
    local fuelColor = {100, 200, 100}
    if data.fuel < 20 then fuelColor = {200, 180, 50} end
    if data.fuel < 10 then fuelColor = {200, 50, 50} end

    SetTextFont(0)
    SetTextScale(0.2*s, 0.2*s)
    SetTextColour(140, 140, 140, math.floor(alpha))
    SetTextEntry("STRING")
    AddTextComponentString("⛽")
    DrawText(fuelX - 15*s, fuelY - 10*s)

    local fuelBarW = 80*s
    DrawRect(fuelX + fuelBarW/2, fuelY, fuelBarW, 3*s, 40, 40, 40, math.floor(alpha * 0.8))
    DrawRect(fuelX + (fuelPercent * fuelBarW)/2, fuelY, fuelPercent * fuelBarW, 3*s, fuelColor[1], fuelColor[2], fuelColor[3], math.floor(alpha))

    -- ============================================
    -- ТЕМПЕРАТУРА МАСЛА
    -- ============================================
    local tempStr = string.format("🌡️ %d°", data.oilTemp)
    SetTextFont(0)
    SetTextScale(0.2*s, 0.2*s)
    SetTextColour(140, 140, 140, math.floor(alpha))
    SetTextEntry("STRING")
    AddTextComponentString(tempStr)
    DrawText(fuelX, fuelY + 12*s)

    -- ============================================
    -- BOOST
    -- ============================================
    local boostStr = string.format("🔥 %.1f bar", data.boost)
    SetTextFont(0)
    SetTextScale(0.2*s, 0.2*s)
    local boostColor = data.boost > 1.5 and {255, 140, 0} or {140, 200, 255}
    SetTextColour(boostColor[1], boostColor[2], boostColor[3], math.floor(alpha))
    SetTextEntry("STRING")
    AddTextComponentString(boostStr)
    DrawText(fuelX, fuelY + 28*s)

    -- ============================================
    -- ОДОМЕТР
    -- ============================================
    local odoStr = string.format("%d km", data.odometer)
    SetTextFont(0)
    SetTextScale(0.18*s, 0.18*s)
    SetTextColour(120, 120, 120, math.floor(alpha * 0.7))
    SetTextEntry("STRING")
    AddTextComponentString(odoStr)
    DrawText(pX + 160*s, posY + panelH - 15*s)

    -- ============================================
    -- ПОВОРОТНИКИ
    -- ============================================
    local turnBlink = math.floor(GetGameTimer() / 500) % 2 == 0
    if data.turnLeft and turnBlink then
        DrawTriangle(pX - 60*s, arcCY, pX - 45*s, arcCY - 8*s, pX - 45*s, arcCY + 8*s, 0, 255, 100, math.floor(alpha))
    end
    if data.turnRight and turnBlink then
        DrawTriangle(pX + 60*s, arcCY, pX + 45*s, arcCY - 8*s, pX + 45*s, arcCY + 8*s, 0, 255, 100, math.floor(alpha))
    end

    -- ============================================
    -- КРУИЗ-КОНТРОЛЬ
    -- ============================================
    if Config.cruiseEnabled then
        SetTextFont(0)
        SetTextScale(0.22*s, 0.22*s)
        SetTextColour(0, 220, 100, math.floor(alpha))
        SetTextEntry("STRING")
        AddTextComponentString(string.format("CRUISE: %d", Config.cruiseSpeed))
        DrawText(pX - 210*s, posY + panelH - 20*s)
    end

    -- ============================================
    -- ДОРОГА (AR)
    -- ============================================
    if Config.showRoad then
        local roadX = posX + panelW + 15*s
        local roadY = posY
        local roadW = 180*s
        local roadH = 290*s
        local roadCX = roadX + roadW/2
        local roadCY = roadY + roadH/2

        DrawRect(roadCX, roadCY, roadW, roadH, 2, 2, 6, math.floor(alpha * 0.8))
        DrawRect(roadCX, roadY, roadW, 2*s, mode.accent[1], mode.accent[2], mode.accent[3], math.floor(alpha * 0.6))
        DrawRect(roadCX, roadY + roadH, roadW, 2*s, mode.accent[1], mode.accent[2], mode.accent[3], math.floor(alpha * 0.6))

        -- Разметка
        for i = 1, 8 do
            local ly = roadY + i * (roadH / 9)
            DrawRect(roadCX, ly, 3*s, roadH/20, 255, 255, 255, math.floor(alpha * 0.1))
        end

        -- Центр
        DrawRect(roadCX, roadCY, 20*s, 1, 255, 255, 255, math.floor(alpha * 0.25))
        DrawRect(roadCX, roadCY, 1, 20*s, 255, 255, 255, math.floor(alpha * 0.25))

        -- Заголовок
        SetTextFont(0)
        SetTextScale(0.2*s, 0.2*s)
        SetTextColour(mode.accent[1], mode.accent[2], mode.accent[3], math.floor(alpha * 0.7))
        SetTextEntry("STRING")
        AddTextComponentString("ROAD")
        DrawText(roadX + 5*s, roadY + 4*s)
    end

    -- ============================================
    -- РЕЖИМ
    -- ============================================
    SetTextFont(0)
    SetTextScale(0.26*s, 0.26*s)
    SetTextColour(mode.accent[1], mode.accent[2], mode.accent[3], math.floor(alpha))
    SetTextEntry("STRING")
    AddTextComponentString(mode.name)
    DrawText(posX, posY + panelH + 6*s)
end

-- ============================================
-- УПРАВЛЕНИЕ
-- ============================================
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if IsControlJustPressed(0, 311) then -- F6
            Config.mode = Config.mode + 1
            if Config.mode > 4 then Config.mode = 1 end
        end

        if IsControlJustPressed(0, 312) then -- F7
            Config.showRoad = not Config.showRoad
        end

        if IsControlJustPressed(0, 313) then -- F8
            Config.enabled = not Config.enabled
        end

        if IsControlJustPressed(0, 314) then -- F9
            Config.currentPosition = Config.currentPosition + 1
            if Config.currentPosition > 6 then Config.currentPosition = 1 end
            Config.position = positions[Config.currentPosition]
        end

        if IsControlJustPressed(0, 57) then -- F10
            Config.unit = Config.unit == "km/h" and "mph" or "km/h"
        end
    end
end)
