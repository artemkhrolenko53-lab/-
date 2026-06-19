-- ============================================
-- AMAZING RP FPS PACK - МЕНЮ F2 (ПОЛНЫЙ КОД)
-- ============================================

local menuOpen = false
local currentTab = 1
local tabs = {"⚡ FPS BOOST", "🎯 AIM", "👁 VISUALS", "🔫 ОРУЖИЕ", "🔊 SOUNDS"}

-- Цвета меню
local accentR, accentG, accentB = 0, 198, 255
local accent2R, accent2G, accent2B = 123, 47, 247
local bgR, bgG, bgB, bgA = 15, 15, 20, 230
local tabBgR, tabBgG, tabBgB, tabBgA = 25, 25, 35, 240

-- Размеры меню
local menuWidth = 700
local menuHeight = 500
local menuX = 0
local menuY = 0
local tabWidth = 150
local contentWidth = 530

-- ============================================
-- ОТКРЫТЬ/ЗАКРЫТЬ МЕНЮ
-- ============================================
function toggleMenu()
    menuOpen = not menuOpen
    if menuOpen then
        local screenW, screenH = GetScreenResolution()
        menuX = (screenW - menuWidth) / 2
        menuY = (screenH - menuHeight) / 2
    end
end

function isMenuOpen()
    return menuOpen
end

-- ============================================
-- ОТРИСОВКА МЕНЮ
-- ============================================
function drawMenu(settings)
    if not menuOpen then return end
    
    local screenW, screenH = GetScreenResolution()
    menuX = (screenW - menuWidth) / 2
    menuY = (screenH - menuHeight) / 2
    
    -- Фон меню
    DrawRect(menuX + menuWidth/2, menuY + menuHeight/2, menuWidth, menuHeight, bgR, bgG, bgB, bgA)
    
    -- Заголовок
    SetTextFont(1)
    SetTextScale(0.6, 0.6)
    SetTextColour(accentR, accentG, accentB, 255)
    SetTextEntry("STRING")
    AddTextComponentString("AMAZING RP FPS PACK")
    DrawText(menuX + 15, menuY + 10)
    
    -- Версия
    SetTextScale(0.3, 0.3)
    SetTextColour(150, 150, 150, 200)
    SetTextEntry("STRING")
    AddTextComponentString("v2.0")
    DrawText(menuX + 15, menuY + 35)
    
    -- Линия-разделитель
    DrawRect(menuX + menuWidth/2, menuY + 50, menuWidth - 20, 1, accentR, accentG, accentB, 100)
    
    -- ============================================
    -- ВКЛАДКИ СЛЕВА
    -- ============================================
    for i, tab in ipairs(tabs) do
        local tabY = menuY + 80 + (i - 1) * 45
        
        if i == currentTab then
            DrawRect(menuX + tabWidth/2 + 5, tabY + 15, tabWidth - 10, 40, accentR, accentG, accentB, 80)
            DrawRect(menuX + 3, tabY + 15, 3, 40, accentR, accentG, accentB, 255)
        end
        
        SetTextFont(0)
        SetTextScale(0.4, 0.4)
        if i == currentTab then
            SetTextColour(255, 255, 255, 255)
        else
            SetTextColour(150, 150, 150, 200)
        end
        SetTextEntry("STRING")
        AddTextComponentString(tab)
        DrawText(menuX + 20, tabY + 10)
    end
    
    -- Разделитель между вкладками и контентом
    DrawRect(menuX + tabWidth + 5, menuY + menuHeight/2 - 20, 1, menuHeight - 100, accentR, accentG, accentB, 60)
    
    -- ============================================
    -- КОНТЕНТ СПРАВА
    -- ============================================
    local contentX = menuX + tabWidth + 20
    local contentY = menuY + 70
    
    if currentTab == 1 then
        drawPerformanceTab(settings, contentX, contentY)
    elseif currentTab == 2 then
        drawAimTab(settings, contentX, contentY)
    elseif currentTab == 3 then
        drawVisualsTab(settings, contentX, contentY)
    elseif currentTab == 4 then
        drawWeaponTab(settings, contentX, contentY)
    elseif currentTab == 5 then
        drawSoundsTab(settings, contentX, contentY)
    end
    
    -- ============================================
    -- НИЖНЯЯ ПАНЕЛЬ
    -- ============================================
    local btnY = menuY + menuHeight - 40
    
    -- Кнопка Сохранить
    if drawButton("💾 Сохранить", menuX + 20, btnY, 120, 25, 0, 200, 100, 200) then
        saveSettings()
    end
    
    -- Кнопка Сброс
    if drawButton("🔄 Сброс", menuX + 160, btnY, 100, 25, 200, 100, 0, 200) then
        resetSettings()
    end
    
    -- Кнопка Очистить память
    if drawButton("🧹 Очистить", menuX + 280, btnY, 110, 25, 100, 100, 200, 200) then
        forceClearMemory()
    end
    
    -- FPS в правом нижнем углу
    local fps = math.floor(1.0 / GetFrameTime())
    SetTextFont(0)
    SetTextScale(0.35, 0.35)
    SetTextColour(0, 255, 0, 200)
    SetTextEntry("STRING")
    AddTextComponentString("FPS: " .. fps)
    DrawText(menuX + menuWidth - 80, btnY + 5)
    
    -- Подсказка
    SetTextScale(0.3, 0.3)
    SetTextColour(150, 150, 150, 150)
    SetTextEntry("STRING")
    AddTextComponentString("F2 — закрыть | Стрелки — табы")
    DrawText(menuX + menuWidth - 200, btnY + 5)
end

-- ============================================
-- ВКЛАДКА: FPS BOOST
-- ============================================
function drawPerformanceTab(settings, x, y)
    local items = {
        {"Отключить тени", "disable_shadows"},
        {"Отключить отражения", "disable_reflections"},
        {"Отключить траву", "disable_grass"},
        {"Отключить воду", "disable_water"},
        {"Отключить bloom", "disable_bloom"},
        {"Отключить lens flare", "disable_lensflare"},
        {"Отключить частицы", "disable_particles"},
        {"Отключить AO", "disable_ao"},
    }
    
    for i, item in ipairs(items) do
        local itemY = y + (i - 1) * 35
        drawToggle(item[1], settings[item[2]], x, itemY, function(val)
            settings[item[2]] = val
            setSetting(item[2], val)
            applyAllFpsSettings(getAllSettings())
        end)
    end
    
    local lodY = y + #items * 35 + 10
    drawSlider("Дальность LOD", settings.lod_distance, 0, 100, x, lodY, function(val)
        settings.lod_distance = val
        setSetting("lod_distance", val)
        setLodDistance(val)
    end)
    
    local autoY = lodY + 40
    drawToggle("Автоочистка памяти", settings.auto_clear_memory, x, autoY, function(val)
        settings.auto_clear_memory = val
        setSetting("auto_clear_memory", val)
        if val then startAutoClean(getAllSettings()) else stopAutoClean() end
    end)
    
    local intervalY = autoY + 35
    drawSlider("Интервал очистки (мин)", settings.auto_clear_interval, 1, 30, x, intervalY, function(val)
        settings.auto_clear_interval = val
        setSetting("auto_clear_interval", val)
        if settings.auto_clear_memory then
            startAutoClean(getAllSettings())
        end
    end)
end

-- ============================================
-- ВКЛАДКА: AIM
-- ============================================
function drawAimTab(settings, x, y)
    local line = 0
    local lineH = 33
    
    drawToggle("Умный прицел", settings.aim_enabled, x, y + line * lineH, function(val)
        settings.aim_enabled = val
        setSetting("aim_enabled", val)
    end)
    line = line + 1
    
    drawToggle("Доводка до цели", settings.aim_lock, x, y + line * lineH, function(val)
        settings.aim_lock = val
        setSetting("aim_lock", val)
    end)
    line = line + 1
    
    local keys = {"Всегда", "ЛКМ", "ПКМ", "LAlt", "E", "Shift"}
    local keyVals = {0, 1, 2, 18, 38, 21}
    local currentKeyIndex = 1
    for i, kv in ipairs(keyVals) do
        if kv == (settings.aim_activation_key or 0) then
            currentKeyIndex = i
            break
        end
    end
    drawCombo("Клавиша активации", keys, currentKeyIndex, x, y + line * lineH, function(index)
        settings.aim_activation_key = keyVals[index]
        setSetting("aim_activation_key", keyVals[index])
    end)
    line = line + 1
    
    local boneNames = {"Голова", "Шея", "Грудь", "Таз", "Ноги"}
    local boneVals = {"head", "neck", "chest", "pelvis", "legs"}
    local boneIndex = getBoneIndex(settings.aim_bone or "head")
    drawCombo("Точка прицеливания", boneNames, boneIndex, x, y + line * lineH, function(index)
        settings.aim_bone = boneVals[index]
        setSetting("aim_bone", boneVals[index])
    end)
    line = line + 1
    
    local prioNames = {"Дистанция", "Здоровье", "Угол"}
    local prioVals = {"distance", "health", "angle"}
    local prioIndex = getPriorityIndex(settings.aim_priority or "distance")
    drawCombo("Приоритет целей", prioNames, prioIndex, x, y + line * lineH, function(index)
        settings.aim_priority = prioVals[index]
        setSetting("aim_priority", prioVals[index])
    end)
    line = line + 1
    
    drawSlider("Сила доводки", settings.aim_strength or 70, 0, 100, x, y + line * lineH, function(val)
        settings.aim_strength = val
        setSetting("aim_strength", val)
    end)
    line = line + 1
    
    drawSlider("Плавность X", settings.aim_smooth_x or 60, 0, 100, x, y + line * lineH, function(val)
        settings.aim_smooth_x = val
        setSetting("aim_smooth_x", val)
    end)
    line = line + 1
    
    drawSlider("Плавность Y", settings.aim_smooth_y or 60, 0, 100, x, y + line * lineH, function(val)
        settings.aim_smooth_y = val
        setSetting("aim_smooth_y", val)
    end)
    line = line + 1
    
    drawSlider("FOV прицеливания", settings.aim_fov or 90, 10, 360, x, y + line * lineH, function(val)
        settings.aim_fov = val
        setSetting("aim_fov", val)
    end)
    line = line + 1
    
    drawSlider("Мёртвая зона", settings.aim_deadzone or 15, 0, 100, x, y + line * lineH, function(val)
        settings.aim_deadzone = val
        setSetting("aim_deadzone", val)
    end)
    line = line + 1
    
    drawSlider("Макс дистанция", settings.aim_max_distance or 200, 50, 500, x, y + line * lineH, function(val)
        settings.aim_max_distance = val
        setSetting("aim_max_distance", val)
    end)
    line = line + 1
    
    drawToggle("Игнор мёртвых", settings.aim_ignore_dead, x, y + line * lineH, function(val)
        settings.aim_ignore_dead = val
        setSetting("aim_ignore_dead", val)
    end)
    line = line + 1
    
    drawToggle("Игнор в транспорте", settings.aim_ignore_vehicles, x, y + line * lineH, function(val)
        settings.aim_ignore_vehicles = val
        setSetting("aim_ignore_vehicles", val)
    end)
    line = line + 1
    
    drawToggle("Проверка видимости", settings.aim_visible_check, x, y + line * lineH, function(val)
        settings.aim_visible_check = val
        setSetting("aim_visible_check", val)
    end)
    line = line + 1
    
    drawToggle("Динам. размер прицела", settings.aim_dynamic_size, x, y + line * lineH, function(val)
        settings.aim_dynamic_size = val
        setSetting("aim_dynamic_size", val)
    end)
    line = line + 1
    
    drawToggle("No Recoil", settings.no_recoil, x, y + line * lineH, function(val)
        settings.no_recoil = val
        setSetting("no_recoil", val)
    end)
    line = line + 1
    
    drawToggle("No Spread", settings.no_spread, x, y + line * lineH, function(val)
        settings.no_spread = val
        setSetting("no_spread", val)
    end)
    line = line + 1
    
    drawSlider("Разброс %", settings.spread_value or 0, 0, 100, x, y + line * lineH, function(val)
        settings.spread_value = val
        setSetting("spread_value", val)
    end)
    line = line + 1
    
    local fireRate = math.floor((settings.fire_rate_multiplier or 1.0) * 100)
    drawSlider("Скорострельность %", fireRate, 50, 200, x, y + line * lineH, function(val)
        settings.fire_rate_multiplier = val / 100
        setSetting("fire_rate_multiplier", val / 100)
    end)
end

-- ============================================
-- ВКЛАДКА: VISUALS
-- ============================================
function drawVisualsTab(settings, x, y)
    local line = 0
    local lineH = 35
    
    drawToggle("Тёмные дороги", settings.black_roads, x, y + line * lineH, function(val)
        settings.black_roads = val
        setSetting("black_roads", val)
        if val then enableBlackRoads(settings.road_darkness) else disableBlackRoads() end
    end)
    line = line + 1
    
    drawSlider("Темнота дорог", settings.road_darkness or 80, 0, 100, x, y + line * lineH, function(val)
        settings.road_darkness = val
        setSetting("road_darkness", val)
        if settings.black_roads then enableBlackRoads(val) end
    end)
    line = line + 1
    
    drawToggle("Кастомный прицел", settings.custom_crosshair, x, y + line * lineH, function(val)
        settings.custom_crosshair = val
        setSetting("custom_crosshair", val)
    end)
    line = line + 1
    
    local styles = {"Точка", "Крест", "Круг", "Т-образный", "Шеврон"}
    drawCombo("Стиль прицела", styles, settings.crosshair_style or 1, x, y + line * lineH, function(index)
        settings.crosshair_style = index
        setSetting("crosshair_style", index)
    end)
    line = line + 1
    
    drawSlider("Размер прицела", settings.crosshair_size or 15, 5, 40, x, y + line * lineH, function(val)
        settings.crosshair_size = val
        setSetting("crosshair_size", val)
    end)
    line = line + 1
    
    drawToggle("Эффекты крови", settings.blood_effects, x, y + line * lineH, function(val)
        settings.blood_effects = val
        setSetting("blood_effects", val)
        if val then enableBloodEffects(settings.blood_size) else disableBloodEffects() end
    end)
    line = line + 1
    
    drawSlider("Размер крови", settings.blood_size or 50, 10, 100, x, y + line * lineH, function(val)
        settings.blood_size = val
        setSetting("blood_size", val)
    end)
    line = line + 1
    
    drawToggle("Вспышки выстрелов", settings.muzzle_flash, x, y + line * lineH, function(val)
        settings.muzzle_flash = val
        setSetting("muzzle_flash", val)
    end)
    line = line + 1
    
    local flashTypes = {"Лёгкая", "Стандарт", "Яркая", "Очень яркая"}
    drawCombo("Тип вспышек", flashTypes, settings.muzzle_flash_type or 1, x, y + line * lineH, function(index)
        settings.muzzle_flash_type = index
        setSetting("muzzle_flash_type", index)
    end)
end

-- ============================================
-- ВКЛАДКА: ОРУЖИЕ (ОБВЕСЫ)
-- ============================================
function drawWeaponTab(settings, x, y)
    local line = 0
    local lineH = 33
    
    -- Выбор оружия
    local weapons = getWeaponList()
    local selectedWeapon = settings.selected_weapon or "WEAPON_DEAGLE"
    
    local weaponNames = {}
    local weaponIndex = 1
    for i, w in ipairs(weapons) do
        weaponNames[i] = getWeaponDisplayName(w)
        if w == selectedWeapon then weaponIndex = i end
    end
    
    SetTextFont(0)
    SetTextScale(0.33, 0.33)
    SetTextColour(220, 220, 220, 255)
    SetTextEntry("STRING")
    AddTextComponentString("Оружие:")
    DrawText(x, y)
    
    drawCombo("", weaponNames, weaponIndex, x + 60, y, function(index)
        settings.selected_weapon = weapons[index]
        setSetting("selected_weapon", weapons[index])
        -- Сбросить обвесы при смене оружия
        if not currentAttachments[weapons[index]] then
            resetAttachments(weapons[index])
        end
        applyAllAttachments(weapons[index])
    end)
    line = line + 2
    
    -- Обвесы для выбранного оружия
    local attachments = getAvailableAttachments(selectedWeapon)
    
    if #attachments == 0 then
        SetTextFont(0)
        SetTextScale(0.33, 0.33)
        SetTextColour(150, 150, 150, 200)
        SetTextEntry("STRING")
        AddTextComponentString("Нет доступных обвесов")
        DrawText(x, y + line * lineH)
        return
    end
    
    for _, att in ipairs(attachments) do
        if att.type == "suppressor" then
            local val = currentAttachments[selectedWeapon] and currentAttachments[selectedWeapon].suppressor or false
            drawToggle(att.name, val, x, y + line * lineH, function(newVal)
                if not currentAttachments[selectedWeapon] then
                    resetAttachments(selectedWeapon)
                end
                currentAttachments[selectedWeapon].suppressor = newVal
                applySuppressor(selectedWeapon, newVal)
            end)
            
        elseif att.type == "skin" then
            local currentSkin = currentAttachments[selectedWeapon] and currentAttachments[selectedWeapon].skin or 1
            drawCombo(att.name, att.data.options, currentSkin, x, y + line * lineH, function(index)
                if not currentAttachments[selectedWeapon] then
                    resetAttachments(selectedWeapon)
                end
                currentAttachments[selectedWeapon].skin = index
                applySkin(selectedWeapon, index)
            end)
            
        elseif att.type == "scope" then
            local currentScope = currentAttachments[selectedWeapon] and currentAttachments[selectedWeapon].scope or 1
            drawCombo(att.name, att.data.options, currentScope, x, y + line * lineH, function(index)
                if not currentAttachments[selectedWeapon] then
                    resetAttachments(selectedWeapon)
                end
                currentAttachments[selectedWeapon].scope = index
                applyScope(selectedWeapon, index)
            end)
            
        elseif att.type == "laser" then
            local val = currentAttachments[selectedWeapon] and currentAttachments[selectedWeapon].laser or false
            drawToggle(att.name, val, x, y + line * lineH, function(newVal)
                if not currentAttachments[selectedWeapon] then
                    resetAttachments(selectedWeapon)
                end
                currentAttachments[selectedWeapon].laser = newVal
                applyLaser(selectedWeapon, newVal)
            end)
            
        elseif att.type == "flashlight" then
            local val = currentAttachments[selectedWeapon] and currentAttachments[selectedWeapon].flashlight or false
            drawToggle(att.name, val, x, y + line * lineH, function(newVal)
                if not currentAttachments[selectedWeapon] then
                    resetAttachments(selectedWeapon)
                end
                currentAttachments[selectedWeapon].flashlight = newVal
                applyFlashlight(selectedWeapon, newVal)
            end)
            
        elseif att.type == "muzzle" then
            local val = currentAttachments[selectedWeapon] and currentAttachments[selectedWeapon].muzzle or false
            drawToggle(att.name, val, x, y + line * lineH, function(newVal)
                if not currentAttachments[selectedWeapon] then
                    resetAttachments(selectedWeapon)
                end
                currentAttachments[selectedWeapon].muzzle = newVal
                applyMuzzle(selectedWeapon, newVal)
            end)
            
        elseif att.type == "grip" then
            local val = currentAttachments[selectedWeapon] and currentAttachments[selectedWeapon].grip or false
            drawToggle(att.name, val, x, y + line * lineH, function(newVal)
                if not currentAttachments[selectedWeapon] then
                    resetAttachments(selectedWeapon)
                end
                currentAttachments[selectedWeapon].grip = newVal
                applyGrip(selectedWeapon, newVal)
            end)
            
        elseif att.type == "magazine" then
            local val = currentAttachments[selectedWeapon] and currentAttachments[selectedWeapon].magazine or false
            drawToggle(att.name, val, x, y + line * lineH, function(newVal)
                if not currentAttachments[selectedWeapon] then
                    resetAttachments(selectedWeapon)
                end
                currentAttachments[selectedWeapon].magazine = newVal
                applyMagazine(selectedWeapon, newVal)
            end)
        end
        
        line = line + 1
    end
    
    -- Кнопка сброса обвесов
    line = line + 1
    if drawButton("🔄 Сбросить обвесы", x, y + line * lineH, 150, 22, 200, 50, 50, 200) then
        resetAttachments(selectedWeapon)
    end
end

-- ============================================
-- ВКЛАДКА: SOUNDS
-- ============================================
function drawSoundsTab(settings, x, y)
    local line = 0
    local lineH = 35
    
    drawToggle("Звуковой пак", settings.sound_pack_enabled, x, y + line * lineH, function(val)
        settings.sound_pack_enabled = val
        setSetting("sound_pack_enabled", val)
        if val then loadSoundPack() else unloadSoundPack() end
    end)
    line = line + 1
    
    local deagleSounds = {"Стандарт", "Чёткий", "Тяжёлый"}
    drawCombo("Deagle", deagleSounds, settings.sound_deagle or 1, x, y + line * lineH, function(index)
        settings.sound_deagle = index
        setSetting("sound_deagle", index)
    end)
    line = line + 1
    
    local akSounds = {"Стандарт", "Тактический", "Глушитель"}
    drawCombo("AK-47", akSounds, settings.sound_ak47 or 1, x, y + line * lineH, function(index)
        settings.sound_ak47 = index
        setSetting("sound_ak47", index)
    end)
    line = line + 1
    
    local m4Sounds = {"Стандарт", "Мягкий"}
    drawCombo("M4", m4Sounds, settings.sound_m4 or 1, x, y + line * lineH, function(index)
        settings.sound_m4 = index
        setSetting("sound_m4", index)
    end)
    line = line + 1
    
    local pistolSounds = {"Стандарт", "Глушитель"}
    drawCombo("Pistol", pistolSounds, settings.sound_pistol or 1, x, y + line * lineH, function(index)
        settings.sound_pistol = index
        setSetting("sound_pistol", index)
    end)
    line = line + 1
    
    drawSlider("Громкость", settings.weapon_volume or 80, 0, 100, x, y + line * lineH, function(val)
        settings.weapon_volume = val
        setSetting("weapon_volume", val)
    end)
    line = line + 1
    
    drawToggle("Звук попадания", settings.hitsound, x, y + line * lineH, function(val)
        settings.hitsound = val
        setSetting("hitsound", val)
    end)
    line = line + 1
    
    local hitSounds = {"Стандарт", "CoD", "Rust"}
    drawCombo("Тип hitsound", hitSounds, settings.hitsound_type or 1, x, y + line * lineH, function(index)
        settings.hitsound_type = index
        setSetting("hitsound_type", index)
    end)
end

-- ============================================
-- КОМПОНЕНТ: TOGGLE
-- ============================================
function drawToggle(label, value, x, y, callback)
    local toggleW = 34
    local toggleH = 18
    local toggleX = x + 270
    
    if value then
        DrawRect(toggleX + toggleW/2, y + 8, toggleW, toggleH, accentR, accentG, accentB, 255)
    else
        DrawRect(toggleX + toggleW/2, y + 8, toggleW, toggleH, 60, 60, 60, 220)
    end
    
    local circleX = value and (toggleX + toggleW - 9) or (toggleX + 9)
    DrawRect(circleX, y + 8, 14, 14, 255, 255, 255, 255)
    
    SetTextFont(0)
    SetTextScale(0.33, 0.33)
    SetTextColour(220, 220, 220, 255)
    SetTextEntry("STRING")
    AddTextComponentString(label)
    DrawText(x, y)
    
    if IsControlJustPressed(0, 24) then
        local mouseX, mouseY = GetCursorScreenPosition()
        if mouseX >= toggleX and mouseX <= toggleX + toggleW and
           mouseY >= y and mouseY <= y + toggleH then
            callback(not value)
        end
    end
end

-- ============================================
-- КОМПОНЕНТ: SLIDER
-- ============================================
function drawSlider(label, value, min, max, x, y, callback)
    SetTextFont(0)
    SetTextScale(0.33, 0.33)
    SetTextColour(220, 220, 220, 255)
    SetTextEntry("STRING")
    AddTextComponentString(label)
    DrawText(x, y - 2)
    
    SetTextColour(accentR, accentG, accentB, 255)
    SetTextEntry("STRING")
    AddTextComponentString(tostring(value))
    DrawText(x + 130, y - 2)
    
    local sliderW = 180
    local sliderH = 5
    local sliderX = x + 160
    local sliderY = y + 5
    local percent = (value - min) / (max - min)
    
    DrawRect(sliderX + sliderW/2, sliderY, sliderW, sliderH, 50, 50, 50, 200)
    DrawRect(sliderX + (sliderW * percent)/2, sliderY, sliderW * percent, sliderH, accentR, accentG, accentB, 255)
    DrawRect(sliderX + sliderW * percent, sliderY, 8, 16, 255, 255, 255, 255)
end

-- ============================================
-- КОМПОНЕНТ: COMBOBOX
-- ============================================
function drawCombo(label, options, selectedIndex, x, y, callback)
    if label ~= "" then
        SetTextFont(0)
        SetTextScale(0.33, 0.33)
        SetTextColour(220, 220, 220, 255)
        SetTextEntry("STRING")
        AddTextComponentString(label)
        DrawText(x, y)
    end
    
    local selectedText = options[selectedIndex] or options[1]
    local offsetX = label ~= "" and 170 or 110
    
    SetTextColour(150, 150, 150, 200)
    SetTextEntry("STRING")
    AddTextComponentString("◄")
    DrawText(x + offsetX, y)
    
    SetTextColour(accentR, accentG, accentB, 255)
    SetTextEntry("STRING")
    AddTextComponentString(selectedText)
    DrawText(x + offsetX + 20, y)
    
    SetTextColour(150, 150, 150, 200)
    SetTextEntry("STRING")
    AddTextComponentString("►")
    DrawText(x + offsetX + 120, y)
    
    if IsControlJustPressed(0, 24) then
        local mouseX, mouseY = GetCursorScreenPosition()
        
        if mouseX >= x + offsetX and mouseX <= x + offsetX + 20 and
           mouseY >= y and mouseY <= y + 20 then
            local newIndex = selectedIndex - 1
            if newIndex < 1 then newIndex = #options end
            callback(newIndex)
        end
        
        if mouseX >= x + offsetX + 120 and mouseX <= x + offsetX + 140 and
           mouseY >= y and mouseY <= y + 20 then
            local newIndex = selectedIndex + 1
            if newIndex > #options then newIndex = 1 end
            callback(newIndex)
        end
    end
end

-- ============================================
-- КОМПОНЕНТ: BUTTON
-- ============================================
function drawButton(label, x, y, w, h, r, g, b, a)
    DrawRect(x + w/2, y + h/2, w, h, r, g, b, a)
    
    SetTextFont(0)
    SetTextScale(0.3, 0.3)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    AddTextComponentString(label)
    DrawText(x + 10, y + 5)
    
    if IsControlJustPressed(0, 24) then
        local mouseX, mouseY = GetCursorScreenPosition()
        if mouseX >= x and mouseX <= x + w and
           mouseY >= y and mouseY <= y + h then
            return true
        end
    end
    
    return false
end

-- ============================================
-- ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
-- ============================================
function getBoneIndex(bone)
    local bones = {head = 1, neck = 2, chest = 3, pelvis = 4, legs = 5}
    return bones[bone] or 1
end

function getPriorityIndex(priority)
    local priorities = {distance = 1, health = 2, angle = 3}
    return priorities[priority] or 1
end
