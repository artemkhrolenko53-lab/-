-- ============================================
-- AMAZING RP FPS PACK - УМНЫЙ ПРИЦЕЛ v2.0
-- ПОЛНЫЙ КОД
-- ============================================

local currentTarget = nil
local lastAimCheck = 0
local AIM_CHECK_INTERVAL = 40 -- мс

-- ============================================
-- КОСТИ ДЛЯ ПРИЦЕЛИВАНИЯ
-- ============================================
local BONES = {
    head = 0x796E,      -- SKEL_Head
    neck = 0x322C,      -- SKEL_Neck1
    chest = 0x0B6C,     -- SKEL_Spine3
    pelvis = 0x2E28,    -- SKEL_Pelvis
    legs = 0xE39F,      -- SKEL_L_Thigh
}

-- ============================================
-- НАСТРОЙКИ AIM
-- ============================================
local aimSettings = {
    aim_enabled = true,
    aim_lock = true,
    aim_strength = 70,
    aim_smooth = 60,
    aim_fov = 90,
    aim_color_enemy = {255, 0, 0, 255},
    aim_color_default = {0, 255, 0, 255},
    no_recoil = true,
    no_spread = true,
    spread_value = 0,
    fire_rate_multiplier = 1.0,
    aim_dynamic_size = true,
    aim_bone = "head",
    aim_priority = "distance",
    aim_ignore_vehicles = false,
    aim_ignore_dead = true,
    aim_smooth_x = 60,
    aim_smooth_y = 60,
    aim_deadzone = 15,
    aim_activation_key = 0,
    aim_visible_check = true,
    aim_max_distance = 200,
}

-- ============================================
-- ОБНОВИТЬ НАСТРОЙКИ ИЗ settings
-- ============================================
function updateAimSettings(settings)
    aimSettings.aim_enabled = settings.aim_enabled
    aimSettings.aim_lock = settings.aim_lock
    aimSettings.aim_strength = settings.aim_strength
    aimSettings.aim_smooth = settings.aim_smooth
    aimSettings.aim_fov = settings.aim_fov
    aimSettings.aim_color_enemy = settings.aim_color_enemy
    aimSettings.aim_color_default = settings.aim_color_default
    aimSettings.no_recoil = settings.no_recoil
    aimSettings.no_spread = settings.no_spread
    aimSettings.spread_value = settings.spread_value
    aimSettings.fire_rate_multiplier = settings.fire_rate_multiplier
    aimSettings.aim_dynamic_size = settings.aim_dynamic_size
    aimSettings.aim_bone = settings.aim_bone or "head"
    aimSettings.aim_priority = settings.aim_priority or "distance"
    aimSettings.aim_ignore_vehicles = settings.aim_ignore_vehicles or false
    aimSettings.aim_ignore_dead = settings.aim_ignore_dead or true
    aimSettings.aim_smooth_x = settings.aim_smooth_x or settings.aim_smooth or 60
    aimSettings.aim_smooth_y = settings.aim_smooth_y or settings.aim_smooth or 60
    aimSettings.aim_deadzone = settings.aim_deadzone or 15
    aimSettings.aim_activation_key = settings.aim_activation_key or 0
    aimSettings.aim_visible_check = settings.aim_visible_check or true
    aimSettings.aim_max_distance = settings.aim_max_distance or 200
end

-- ============================================
-- ПОЛУЧИТЬ ID КОСТИ ПО НАЗВАНИЮ
-- ============================================
local function getBoneId(boneName)
    return BONES[boneName] or BONES["head"]
end

-- ============================================
-- ПОЛУЧИТЬ ЭКРАННЫЕ КООРДИНАТЫ КОСТИ
-- ============================================
local function getBoneScreenCoords(ped, boneName)
    local boneId = getBoneId(boneName)
    local boneCoords = GetPedBoneCoords(ped, boneId, 0.0, 0.0, 0.0)
    local screenX, screenY = GetScreenCoordFromWorldCoord(boneCoords.x, boneCoords.y, boneCoords.z)
    return screenX, screenY, boneCoords
end

-- ============================================
-- ПРОВЕРКА ВИДИМОСТИ ИГРОКА
-- ============================================
local function isPlayerVisible(player, boneName)
    if not aimSettings.aim_visible_check then return true end
    
    local ped = GetPlayerPed(player)
    if not DoesEntityExist(ped) then return false end
    
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local boneCoords = GetPedBoneCoords(ped, getBoneId(boneName), 0.0, 0.0, 0.0)
    
    -- Проверка дистанции
    local dist = #(playerCoords - boneCoords)
    if dist > aimSettings.aim_max_distance then return false end
    
    -- Трассировка луча
    local flags = -1
    if aimSettings.aim_ignore_vehicles then
        flags = 1 | 16 | 256 -- Пропускаем машины
    end
    
    local ray = StartShapeTestRay(
        playerCoords.x, playerCoords.y, playerCoords.z,
        boneCoords.x, boneCoords.y, boneCoords.z,
        flags, playerPed, 0
    )
    local _, hit, _, _, entityHit = GetShapeTestResult(ray)
    
    if hit and entityHit ~= ped then
        local hitPed = GetPedFromEntity(entityHit)
        return hitPed == ped
    end
    
    return not hit or entityHit == ped
end

-- ============================================
-- ПОЛУЧИТЬ ВСЕХ ВИДИМЫХ ВРАГОВ В FOV
-- ============================================
local function getEnemiesInFov(fov, boneName)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local screenW, screenH = GetScreenResolution()
    local centerX, centerY = screenW / 2, screenH / 2
    local fovPixels = (fov / 100) * screenW
    
    local enemies = {}
    
    for _, player in ipairs(GetActivePlayers()) do
        if player ~= PlayerId() then
            local ped = GetPlayerPed(player)
            
            if DoesEntityExist(ped) then
                -- Пропуск мёртвых
                if aimSettings.aim_ignore_dead and IsPedDeadOrDying(ped, true) then
                    goto continue
                end
                
                -- Пропуск в транспорте
                if aimSettings.aim_ignore_vehicles and IsPedInAnyVehicle(ped, false) then
                    goto continue
                end
                
                -- Экранные координаты кости
                local sx, sy, boneCoords = getBoneScreenCoords(ped, boneName)
                
                if sx and sy then
                    local distX = math.abs(sx - centerX)
                    local distY = math.abs(sy - centerY)
                    local screenDist = math.sqrt(distX * distX + distY * distY)
                    
                    -- В FOV и не в deadzone
                    if screenDist <= fovPixels and screenDist > aimSettings.aim_deadzone then
                        if isPlayerVisible(player, boneName) then
                            local health = GetEntityHealth(ped)
                            local distance = #(playerCoords - boneCoords)
                            
                            table.insert(enemies, {
                                player = player,
                                ped = ped,
                                screenX = sx,
                                screenY = sy,
                                screenDist = screenDist,
                                health = health,
                                distance = distance,
                            })
                        end
                    end
                end
            end
        end
        ::continue::
    end
    
    -- Сортировка
    if aimSettings.aim_priority == "distance" then
        table.sort(enemies, function(a, b) return a.distance < b.distance end)
    elseif aimSettings.aim_priority == "health" then
        table.sort(enemies, function(a, b) return a.health < b.health end)
    elseif aimSettings.aim_priority == "angle" then
        table.sort(enemies, function(a, b) return a.screenDist < b.screenDist end)
    end
    
    return enemies
end

-- ============================================
-- ПЛАВНОЕ ДОВЕДЕНИЕ ПРИЦЕЛА
-- ============================================
local function smoothAim(targetPed, screenX, screenY, strength, smoothX, smoothY)
    if not DoesEntityExist(targetPed) then return end
    
    local screenW, screenH = GetScreenResolution()
    local centerX, centerY = screenW / 2, screenH / 2
    
    -- Смещение от центра
    local diffX = screenX - centerX
    local diffY = screenY - centerY
    
    -- Применяем плавность X/Y
    local moveX = diffX * (strength / 100) * (smoothX / 100)
    local moveY = diffY * (strength / 100) * (smoothY / 100)
    
    -- Ease-in-out (человеческое замедление)
    local dist = math.sqrt(diffX * diffX + diffY * diffY)
    local ease = 1.0
    if dist > 100 then
        ease = 0.3 -- Быстрее издалека
    elseif dist < 20 then
        ease = 0.08 -- Медленнее вблизи (точнее)
    elseif dist < 50 then
        ease = 0.15
    end
    
    moveX = moveX * ease
    moveY = moveY * ease
    
    -- Применяем движение
    local newX = centerX + moveX
    local newY = centerY + moveY
    
    SetCursorLocation(newX, newY)
end

-- ============================================
-- ПРОВЕРКА КЛАВИШИ АКТИВАЦИИ
-- ============================================
local function isActivationKeyPressed()
    local key = aimSettings.aim_activation_key
    if key == 0 then return true end
    
    -- 1 = ЛКМ, 2 = ПКМ, 18 = LAlt
    return IsControlPressed(0, key) or IsDisabledControlPressed(0, key)
end

-- ============================================
-- NO RECOIL
-- ============================================
local function applyNoRecoil()
    local playerPed = PlayerPedId()
    SetPedRecoilForce(playerPed, 0.0)
    SetPedRecoilShake(playerPed, 0.0)
end

-- ============================================
-- NO SPREAD
-- ============================================
local function applyNoSpread(spreadValue)
    local weapon = GetSelectedPedWeapon(PlayerPedId())
    if weapon ~= -1569615261 then -- Не кулак
        local accuracy = (100 - (spreadValue or 0)) / 100
        SetWeaponAccuracy(weapon, accuracy)
    end
end

-- ============================================
-- FIRE RATE
-- ============================================
local function applyFireRate(multiplier)
    local weapon = GetSelectedPedWeapon(PlayerPedId())
    if weapon ~= -1569615261 then
        SetWeaponFireRate(weapon, multiplier)
    end
end

-- ============================================
-- ОСНОВНОЙ ЦИКЛ (ВЫЗЫВАТЬ В КАЖДОМ КАДРЕ)
-- ============================================
function aimLoop()
    if not aimSettings.aim_enabled then
        currentTarget = nil
        return
    end
    
    -- Клавиша активации
    if not isActivationKeyPressed() then
        currentTarget = nil
        return
    end
    
    -- Интервал проверки
    local now = GetGameTimer()
    if now - lastAimCheck < AIM_CHECK_INTERVAL then
        -- No recoil всё равно каждый кадр
        if aimSettings.no_recoil then
            applyNoRecoil()
        end
        return
    end
    lastAimCheck = now
    
    -- Прицеливается ли игрок
    if not IsPlayerFreeAiming(PlayerId()) then
        currentTarget = nil
        return
    end
    
    -- Параметры
    local boneName = aimSettings.aim_bone or "head"
    local fov = aimSettings.aim_fov or 90
    local strength = aimSettings.aim_strength or 70
    local smoothX = aimSettings.aim_smooth_x or aimSettings.aim_smooth or 60
    local smoothY = aimSettings.aim_smooth_y or aimSettings.aim_smooth or 60
    
    -- Поиск целей
    local enemies = getEnemiesInFov(fov, boneName)
    
    if #enemies > 0 and aimSettings.aim_lock then
        local target = enemies[1]
        currentTarget = target.ped
        smoothAim(target.ped, target.screenX, target.screenY, strength, smoothX, smoothY)
    else
        currentTarget = nil
    end
    
    -- Применяем no recoil
    if aimSettings.no_recoil then
        applyNoRecoil()
    end
    
    -- Применяем no spread
    if aimSettings.no_spread then
        applyNoSpread(aimSettings.spread_value)
    end
    
    -- Применяем fire rate
    if aimSettings.fire_rate_multiplier and aimSettings.fire_rate_multiplier ~= 1.0 then
        applyFireRate(aimSettings.fire_rate_multiplier)
    end
end

-- ============================================
-- ПОЛУЧИТЬ ТЕКУЩУЮ ЦЕЛЬ
-- ============================================
function getCurrentTarget()
    return currentTarget
end

-- ============================================
-- НАВЕДЁН ЛИ ПРИЦЕЛ НА ИГРОКА
-- ============================================
function isAimingAtPlayer()
    if not currentTarget then return false end
    return DoesEntityExist(currentTarget) and not IsPedDeadOrDying(currentTarget, true)
end

-- ============================================
-- ПОЛУЧИТЬ ЦВЕТ ПРИЦЕЛА ДЛЯ ВРАГА
-- ============================================
function getEnemyCrosshairColor()
    return aimSettings.aim_color_enemy
end

-- ============================================
-- ПОЛУЧИТЬ ЦВЕТ ПРИЦЕЛА ОБЫЧНЫЙ
-- ============================================
function getDefaultCrosshairColor()
    return aimSettings.aim_color_default
end

-- ============================================
-- ВКЛЮЧЕН ЛИ ДИНАМИЧЕСКИЙ РАЗМЕР
-- ============================================
function isDynamicSizeEnabled()
    return aimSettings.aim_dynamic_size
end
