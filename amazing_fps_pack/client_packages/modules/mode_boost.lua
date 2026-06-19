-- ============================================
-- AMAZING RP FPS PACK
-- МОДУЛЬ: РЕЖИМЫ ВОЖДЕНИЯ (MODE BOOST)
-- F5 — смена режима
-- Все скорости взяты из вики Amazing RP
-- ============================================

local MODES = {
    [1] = {
        name = "COMFORT",
        color = {0, 255, 100},
        speedBonus = 0,
        fuelMultiplier = 1.0,
        acceleration = 1.0,
        handling = 1.0,
        suspension = 0.0,
    },
    [2] = {
        name = "SPORT",
        color = {255, 30, 30},
        speedBonus = 40,
        fuelMultiplier = 1.4,
        acceleration = 1.25,
        handling = 1.15,
        suspension = -0.12,
    },
    [3] = {
        name = "SPORT+",
        color = {255, 140, 0},
        speedBonus = 90,
        fuelMultiplier = 1.8,
        acceleration = 1.5,
        handling = 1.3,
        suspension = -0.18,
    },
    [4] = {
        name = "ECO PRO",
        color = {0, 180, 255},
        speedBonus = -40,
        fuelMultiplier = 0.6,
        acceleration = 0.75,
        handling = 0.9,
        suspension = 0.02,
    },
}

local currentMode = 1

-- ============================================
-- МАКСИМАЛЬНЫЕ СКОРОСТИ ВСЕХ МАШИН AMAZING RP
-- ============================================
local AMAZING_MAX_SPEEDS = {
    -- Alfa Romeo
    ["alfaromeogiulia"] = 225,
    
    -- Audi
    ["audir8"] = 240,
    ["audirs7"] = 240,
    ["audirsq8"] = 230,
    ["audirs4b5"] = 220,
    ["audirs6c7"] = 240,
    ["audirs6c8"] = 240,
    ["audis3sedan"] = 220,
    ["audis5b9"] = 220,
    ["auditt3g"] = 220,
    
    -- Aurus
    ["aurussenat"] = 200,
    ["aurussenatconvertible"] = 200,
    
    -- Bentley
    ["bentleybentayga"] = 240,
    ["bentleycontinentalgt"] = 230,
    ["bentleyultratank"] = 165,
    
    -- BMW
    ["bmw2002turbo"] = 190,
    ["bmw750il"] = 217,
    ["bmwi8"] = 230,
    ["bmwm2f87"] = 220,
    ["bmwm3e30"] = 215,
    ["bmwm3e36"] = 220,
    ["bmwm3e46"] = 231,
    ["bmwm3e92"] = 240,
    ["bmwm3f80"] = 225,
    ["bmwm3touring"] = 240,
    ["bmwm4f82"] = 220,
    ["bmwm4g82"] = 240,
    ["bmwm5e34"] = 220,
    ["bmwm5e39"] = 210,
    ["bmwm5e60"] = 230,
    ["bmwm5f10"] = 220,
    ["bmwm5f90"] = 250,
    ["bmwm6f13"] = 225,
    ["bmwm8f92"] = 240,
    ["bmwx5e53"] = 210,
    ["bmwx5m"] = 240,
    ["bmwx7"] = 225,
    
    -- Bugatti
    ["bugattichiron"] = 285,
    
    -- BRP
    ["canam"] = 141,
    
    -- Cadillac
    ["cadillacescalade"] = 210,
    
    -- Chevrolet
    ["corvettec3"] = 225,
    ["corvettec8"] = 265,
    ["impala"] = 210,
    ["chevroletmonster"] = 107,
    
    -- DeLorean
    ["delorean"] = 208,
    
    -- Dodge
    ["dodgechallenger"] = 220,
    ["dodgecharger"] = 231,
    ["dodgeramtrx"] = 208,
    ["dodgeviper"] = 235,
    
    -- Ducati
    ["ducatidesmosedici"] = 207,
    ["ducatixdiavel"] = 132,
    
    -- Ferrari
    ["ferrari488"] = 280,
    ["ferrarif12"] = 280,
    ["ferrarigtc4"] = 250,
    
    -- Fiat
    ["fiat500"] = 125,
    
    -- Flanker
    ["flankerf"] = 291,
    
    -- Ford
    ["fordraptor"] = 185,
    ["fordfocus"] = 175,
    ["fordhotrod"] = 231,
    ["fordhoonicorn"] = 294,
    
    -- GMC
    ["gmc"] = 132,
    
    -- Harley-Davidson
    ["harley"] = 135,
    
    -- HiPhi
    ["hiphiz"] = 220,
    
    -- Holden
    ["holden"] = 150,
    
    -- Honda
    ["civictyperek9"] = 215,
    ["civictypefk8"] = 210,
    ["nsx"] = 225,
    ["s2000"] = 213,
    
    -- Hummer
    ["hummerh1"] = 176,
    
    -- Infiniti
    ["infinitiq50"] = 220,
    
    -- Jaguar
    ["jaguarftype"] = 220,
    
    -- Jeep
    ["jeepgladiator"] = 215,
    ["jeepsrt8"] = 208,
    
    -- Kia
    ["kiario"] = 190,
    
    -- Lada
    ["lada4x4"] = 170,
    ["ladagranta"] = 154,
    ["ladalargus"] = 160,
    ["ladalarguscross"] = 160,
    ["ladaniva"] = 150,
    ["ladapriora"] = 180,
    ["ladavesta"] = 160,
    ["ladavestasw"] = 184,
    
    -- Lamborghini
    ["lamboaventador"] = 270,
    ["lambohuracan"] = 260,
    ["lambourus"] = 240,
    
    -- Lexus
    ["lexusis300xe10"] = 190,
    ["lexusis300xe30"] = 225,
    ["lexusisf"] = 225,
    ["lexuslx570"] = 210,
    ["lexuslx600"] = 220,
    ["lexusrx350"] = 210,
    
    -- Lincoln
    ["lincolncontinental"] = 210,
    
    -- Land Rover
    ["rangerover"] = 215,
    
    -- Mazda
    ["mazdarx8"] = 210,
    
    -- McLaren
    ["mclarensenna"] = 340,
    
    -- Mercedes-Benz
    ["mercedesamggt"] = 250,
    ["mercedesamggtr"] = 260,
    ["mercedescls"] = 230,
    ["mercedese500"] = 200,
    ["mercedese55"] = 220,
    ["mercedese63w212"] = 220,
    ["mercedese63sw213"] = 250,
    ["mercedeseqs"] = 220,
    ["mercedesg634x4"] = 187,
    ["mercedesg63w464"] = 215,
    ["mercedesg65"] = 210,
    ["mercedesgle63"] = 240,
    ["mercedess450"] = 216,
    ["mercedess600"] = 220,
    ["mercedessprinter"] = 158,
    ["mercedesunimog"] = 110,
    ["mercedesvclass"] = 210,
    ["mercedesvisionavtr"] = 296,
    ["mercedesxclass"] = 200,
    ["mercedesmaybachgls"] = 240,
    ["mercedesmaybachs650"] = 222,
    
    -- MINI
    ["minicoopers"] = 200,
    ["minijcw"] = 210,
    
    -- Mitsubishi
    ["mitsubishievox"] = 220,
    ["mitsubishipajero"] = 200,
    
    -- Nissan
    ["nissan240sx"] = 200,
    ["nissan370z"] = 220,
    ["nissanfairlady240z"] = 215,
    ["nissanfairladyz"] = 235,
    ["nissangtr"] = 250,
    ["nissanpulsar"] = 200,
    ["nissansilvias13"] = 200,
    ["nissansilvias14"] = 210,
    ["nissansilvias15"] = 220,
    ["nissanskyline33"] = 210,
    ["nissanskyline34"] = 220,
    
    -- Peugeot
    ["peugeot406"] = 184,
    
    -- Porsche
    ["porsche911930"] = 220,
    ["porsche911992"] = 260,
    ["porsche911991"] = 250,
    ["porschecayennecoupe"] = 230,
    ["porschecayenneturbo"] = 230,
    ["porschetaycan"] = 250,
    
    -- Proto Speedster
    ["protospeedster"] = 96,
    
    -- Quadra
    ["quadra"] = 255,
    
    -- Range Rover
    ["rangerovervelar"] = 210,
    
    -- Renault
    ["renaultlogan"] = 166,
    ["renaultmegane"] = 170,
    
    -- Rolls-Royce
    ["rollsroycecullinan"] = 230,
    ["rollsroycedawn"] = 220,
    ["rollsroyceghost"] = 210,
    ["rollsroycephantom"] = 210,
    
    -- Saleen
    ["saleens7"] = 270,
    
    -- Skoda
    ["skodaoctavia"] = 210,
    
    -- Subaru
    ["subaruimprezagd"] = 225,
    ["subaruimprezagj"] = 215,
}

-- ============================================
-- ПОЛУЧИТЬ БАЗОВУЮ МАКСИМАЛЬНУЮ СКОРОСТЬ
-- ============================================
local function getBaseMaxSpeed(vehicle)
    if vehicle == 0 then return 200 end
    
    local model = GetEntityModel(vehicle)
    local modelName = GetDisplayNameFromVehicleModel(model)
    local modelLower = string.lower(modelName)
    
    -- Ищем в таблице Amazing RP
    if AMAZING_MAX_SPEEDS[modelLower] then
        return AMAZING_MAX_SPEEDS[modelLower]
    end
    
    -- Если нет в таблице — автоопределение
    local dragCoeff = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDragCoeff")
    local driveForce = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveForce")
    
    if dragCoeff and dragCoeff > 0 and driveForce then
        local estimated = (driveForce / dragCoeff) * 280
        estimated = math.max(estimated, 100)
        estimated = math.min(estimated, 350)
        return math.floor(estimated)
    end
    
    return 200
end

-- ============================================
-- ПРИМЕНИТЬ РЕЖИМ К МАШИНЕ
-- ============================================
local function applyMode(vehicle, modeIndex)
    if vehicle == 0 then return end
    
    local mode = MODES[modeIndex]
    local baseMax = getBaseMaxSpeed(vehicle)
    local newMax = math.max(baseMax + mode.speedBonus, 80)
    
    -- Максимальная скорость
    local dragCoeff = 10.0 / newMax
    SetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDragCoeff", dragCoeff)
    
    -- Ускорение
    local accel = mode.acceleration
    SetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveForce", accel * 0.35)
    SetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveMaxFlatVel", accel * 165.0)
    SetVehicleHandlingFloat(vehicle, "CHandlingData", "fClutchChangeRateScaleUpShift", accel * 3.5)
    SetVehicleHandlingFloat(vehicle, "CHandlingData", "fClutchChangeRateScaleDownShift", accel * 3.5)
    
    -- Управляемость
    local handling = mode.handling
    SetVehicleHandlingFloat(vehicle, "CHandlingData", "fSteeringLock", handling * 45.0)
    SetVehicleHandlingFloat(vehicle, "CHandlingData", "fTractionCurveMax", handling * 2.9)
    SetVehicleHandlingFloat(vehicle, "CHandlingData", "fTractionCurveMin", handling * 2.4)
    SetVehicleHandlingFloat(vehicle, "CHandlingData", "fTractionCurveLateral", handling * 22.5)
    
    -- Подвеска
    local suspension = mode.suspension
    SetVehicleSuspensionHeight(vehicle, suspension)
    SetVehicleHandlingFloat(vehicle, "CHandlingData", "fSuspensionForce", 1.5 + math.abs(suspension) * 3)
    SetVehicleHandlingFloat(vehicle, "CHandlingData", "fSuspensionDampingCompression", 1.0 + math.abs(suspension) * 4)
    SetVehicleHandlingFloat(vehicle, "CHandlingData", "fSuspensionDampingRebound", 1.0 + math.abs(suspension) * 4)
    
    -- Расход топлива
    DecorSetFloat(vehicle, "fuel_multiplier", mode.fuelMultiplier)
end

-- ============================================
-- СМЕНИТЬ РЕЖИМ
-- ============================================
local function switchMode(newMode)
    currentMode = newMode
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if vehicle ~= 0 then applyMode(vehicle, newMode) end
end

function getCurrentMode()
    return currentMode
end

function getCurrentModeData()
    return MODES[currentMode]
end

-- ============================================
-- АВТОПРИМЕНЕНИЕ ПРИ СМЕНЕ МАШИНЫ
-- ============================================
Citizen.CreateThread(function()
    local lastVehicle = 0
    while true do
        Citizen.Wait(500)
        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        if vehicle ~= lastVehicle then
            if vehicle ~= 0 then applyMode(vehicle, currentMode) end
            lastVehicle = vehicle
        end
    end
end)

-- ============================================
-- УПРАВЛЕНИЕ: F5
-- ============================================
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(0, 311) then
            local newMode = currentMode + 1
            if newMode > 4 then newMode = 1 end
            switchMode(newMode)
            
            local mode = MODES[newMode]
            SetNotificationTextEntry("STRING")
            AddTextComponentString(string.format(
                "~r~>>> ~w~РЕЖИМ: ~b~%s ~w~| ~g~Скорость: %+d км/ч ~w~| ~y~Расход: %.0f%%",
                mode.name, mode.speedBonus, mode.fuelMultiplier * 100
            ))
            DrawNotification(false, true)
        end
    end
end)
