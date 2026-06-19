-- ============================================
-- AMAZING RP FPS PACK - УМНЫЙ ПРИЦЕЛ
-- ============================================

local aimActive = false
local currentTarget = nil
local lastAimCheck = 0
local AIM_CHECK_INTERVAL = 50 -- мс (лёгкая нагрузка)

-- ============================================
-- ПОЛУЧИТЬ ЭКРАННЫЕ КООРДИНАТЫ СУЩНОСТИ
-- ============================================
local function getScreenCoords(entity)
    local coords = GetEntityCoords(entity)
    local screenX, screenY = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z)
    
    if screenX and screenY then
        return screenX, screenY
    end
    return nil, nil
end

-- ============================================
-- ПРОВЕРИТЬ, ВИДИМ ЛИ ИГРОК
-- ============================================
local function isPlayerVisible(player)
    local ped = GetPlayerPed(player)
    if not DoesEntityExist(ped) then return false end
    
    local playerCoords = GetEntityCoords(PlayerPedId())
    local targetCoords = GetEntityCoords(ped)
    
    -- Проверка дистанции
    local dist = #(playerCoords - targetCoords)
    if dist > 200 then return false end
    
    -- Проверка линии видимости (луч)
    local ray = StartShapeTestRay(playerCoords.x, playerCoords.y, playerCoords.z,
                                   targetCoords.x, targetCoords.y, targetCoords.z,
                                   -1, PlayerPedId(), 0)
    local _, hit, _, _, entityHit = GetShapeTestResult(ray)
    
    return not hit or entityHit == ped
end

-- ============================================
-- ПОЛУЧИТЬ БЛИЖАЙШЕГО ИГРОКА В FOV
-- ============================================
local function getClosestPlayerInFov(fov)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local screenW, screenH = GetScreenResolution()
    local centerX, centerY = screenW / 2, screenH / 2
    
    local closestPlayer = nil
    local closestDist = fov * (screenW / 100) -- Конвертация FOV в пиксели
    
    for _, player in ipairs(GetActivePlayers()) do
        if player ~= PlayerId() then
            local ped = GetPlayerPed(player)
            if DoesEntityExist(ped) and not IsPedDeadOrDying(ped, true) then
                local sx, sy = getScreenCoords(ped)
                if sx and sy then
                    -- Проверка в FOV
                    local distX = math.abs(sx - centerX)
                    local distY = math.abs(sy - centerY)
                    local screenDist = math.sqrt(distX * distX + distY * distY)
                    
                    if screenDist < closestDist and isPlayerVisible(player) then
                        closestDist = screenDist
                        closestPlayer = ped
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

-- ============================================
-- ПЛАВНОЕ ДОВЕДЕНИЕ ПРИЦЕЛА
-- ============================================
local function smoothAim(targetPed, strength, smooth)
    if not DoesEntityExist(targetPed) then return end
    
    local targetCoords = GetEntityCoords(targetPed)
    local targetBone = GetPedBoneCoords(targetPed, 0x796E, 0.0, 0.0, 0.0) -- SKEL_Head
    
    -- Точка прицеливания (голова)
    local aimX, aimY = getScreenCoords(targetPed)
    if not aimX then return end
    
    local screenW, screenH = GetScreenResolution()
    local centerX, centerY = screenW / 2, screenH / 2
    
    -- Смещение от центра
    local diffX = aimX - centerX
    local diffY = aimY - centerY
    
    -- Применяем плавность и силу
    local moveX = diffX * (strength / 100) * (smooth / 100)
    local moveY = diffY * (strength / 100) * (smooth / 100)
    
    -- Двигаем камеру
    SetCursorLocation(centerX + moveX, centerY + moveY)
end

-- ============================================
-- УБРАТЬ ОТДАЧУ
-- ============================================
local function noRecoil()
    local playerPed = PlayerPedId()
    SetPedRecoilForce(playerPed, 0.0)
    SetPedRecoilShake(playerPed, 0.0)
end

-- ============================================
-- УБРАТЬ РАЗБРОС
-- ============================================
local function noSpread(value)
    -- value: 0 = полное отключение, 100 = стандартный разброс
    local spread = (100 - value) / 100
    SetPlayerWeaponDamageModifier(PlayerId(), 1.0)
    SetPlayerWeaponDefenseModifier(PlayerId(), 1.0)
    
    -- Установка точности оружия
    local weapon = GetSelectedPedWeapon(PlayerPedId())
    if weapon ~= -1569615261 then -- Не кулак
        SetWeaponAccuracy(weapon, spread)
        SetWeaponRecoil(weapon, 0.0)
    end
end

-- ============================================
-- СКОРОСТРЕЛЬНОСТЬ
-- ============================================
local function setFireRate(multiplier)
    local weapon = GetSelectedPedWeapon(PlayerPedId())
    if weapon ~= -1569615261 then
        SetWeaponFireRate(weapon, multiplier)
    end
end

-- ============================================
-- ОСНОВНОЙ ЦИКЛ АИМА
-- ============================================
function aimLoop(settings)
    if not settings.aim_enabled then
        currentTarget = nil
        return
    end
    
    local now = GetGameTimer()
    if now - lastAimCheck < AIM_CHECK_INTERVAL then return end
    lastAimCheck = now
    
    -- Проверка, прицеливается ли игрок
    if not IsPlayerFreeAiming(PlayerId()) then
        currentTarget = nil
        return
    end
    
    -- Поиск цели
    local target = getClosestPlayerInFov(settings.aim_fov)
    
    if target and settings.aim_lock then
        currentTarget = target
        smoothAim(target, settings.aim_strength, settings.aim_smooth)
    else
        currentTarget = nil
    end
    
    -- No recoil
    if settings.no_recoil then
        noRecoil()
    end
    
    -- No spread
    if settings.no_spread then
        noSpread(settings.spread_value)
    end
    
    -- Fire rate
    if settings.fire_rate_multiplier ~= 1.0 then
        setFireRate(settings.fire_rate_multiplier)
    end
end

-- ============================================
-- ПОЛУЧИТЬ ТЕКУЩУЮ ЦЕЛЬ
-- ============================================
function getCurrentTarget()
    return currentTarget
end

-- ============================================
-- ПРОВЕРИТЬ, НАВЕДЁН ЛИ ПРИЦЕЛ НА ИГРОКА
-- ============================================
function isAimingAtPlayer()
    if not currentTarget then return false end
    return DoesEntityExist(currentTarget) and not IsPedDeadOrDying(currentTarget, true)
end
