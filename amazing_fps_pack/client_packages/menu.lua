-- ============================================
-- AMAZING RP FPS PACK - МЕНЮ F2
-- ============================================

local menuOpen = false
local currentTab = 1
local tabs = {"⚡ FPS BOOST", "🎯 AIM", "👁 VISUALS", "🔊 SOUNDS"}

-- Цвета меню
local accentR, accentG, accentB = 0, 198, 255    -- #00c6ff
local accent2R, accent2G, accent2B = 123, 47, 247 -- #7b2ff7
local bgR, bgG, bgB, bgA = 15, 15, 20, 230
local tabBgR, tabBgG, tabBgB, tabBgA = 25, 25, 35, 240

-- Размеры меню
local menuWidth = 650
local menuHeight = 450
local menuX = 0
local menuY = 0
local tabWidth = 150
local contentWidth = 480

-- ============================================
-- ОТКРЫТЬ/ЗАКРЫТЬ МЕНЮ
-- ============================================
function toggleMenu()
    menuOpen = not menuOpen
    if menuOpen then
        menuX = (GetScreenResolution() - menuWidth) / 2
        menuY = (GetScreenResolution() - menuHeight) / 2
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
    
    screenW, screenH = GetScreenResolution()
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
    AddTextComponentString("v1.0 by Niko")
    DrawText(menuX + 15, menuY + 35)
    
    -- Линия-разделитель
    DrawRect(menuX + menuWidth/2, menuY + 50, menuWidth - 20, 1, accentR, accentG, accentB, 100)
    
    -- ============================================
    -- ВКЛАДКИ СЛЕВА
    -- ============================================
    for i, tab in ipairs(tabs) do
        local tabY = menuY + 80 + (i - 1) * 45
        
        -- Фон вкладки
        if i == currentTab then
            DrawRect(menuX + tabWidth/2 + 5, tabY + 15, tabWidth - 10, 40, accentR, accentG, accentB, 80)
            -- Акцентная полоска слева
            DrawRect(menuX + 3, tabY + 15, 3, 40, accentR, accentG, accentB, 255)
        end
        
        -- Текст вкладки
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
    DrawRect(menuX + tabWidth + 5, menuY + menuHeight/2, 1, menuHeight - 80, accentR, accentG, accentB, 60)
    
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
        drawSoundsTab(settings, contentX, contentY)
    end
    
    -- ============================================
    -- НИЖНЯЯ ПАНЕЛЬ (КНОПКИ)
    -- ============================================
    local btnY = menuY + menuHeight - 40
    
    -- Кнопка Сохранить
    if drawButton("💾 Сохранить", menuX + 20, btnY, 120, 25, 0, 200, 100, 200) then
        saveSettings()
    end
    
    -- Кнопка Сброс
    if drawButton("🔄 Сброс", menuX + 160, btnY, 100, 25, 200, 100, 0, 200) then
        resetSettings()
        applyAllFpsSettings(getAllSettings())
    end
    
    -- Кнопка Очистить память
    if drawButton("🧹 Очистить", menuX + 280, btnY, 110, 25, 100, 100, 200, 200) then
        forceClearMemory()
    end
    
    -- FPS в правом нижнем углу меню
    local fps = math.floor(1.0 / GetFrameTime())
    SetTextFont(0)
    SetTextScale(0.35, 0.35)
    SetTextColour(0, 255, 0, 200)
    SetTextEntry("STRING")
    AddTextComponentString("FPS: " .. fps)
    DrawText(menuX + menuWidth - 80, btnY + 5)
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
    
    -- LOD слайдер
    local lodY = y + #items * 35 + 10
    drawSlider("Дальность LOD", settings.lod_distance, 0, 100, x, lodY, function(val)
        settings.lod_distance = val
        setSetting("lod_distance", val)
        setLodDistance(val)
    end)
    
    -- Автоочистка
    local autoY = lodY + 40
    drawToggle("Автоочистка памяти", settings.auto_clear_memory, x, autoY, function(val)
        settings.auto_clear_memory = val
        setSetting("auto_clear_memory", val)
        if val then startAutoClean(getAllSettings()) else stopAutoClean() end
    end)
end

-- ============================================
-- ВКЛАДКА: AIM
-- ============================================
function drawAimTab(settings, x, y)
    drawToggle("Умный прицел", settings.aim_enabled, x, y, function(val)
        settings.aim_enabled = val
        setSetting("aim_enabled", val)
    end)
    
    drawToggle("Доводка до цели", settings.aim_lock, x, y + 35, function(val)
        settings.aim_lock = val
        setSetting("aim_lock", val)
    end)
    
    drawSlider("Сила доводки", settings.aim_strength, 0, 100, x, y + 70, function(val)
        settings.aim_strength = val
        setSetting("aim_strength", val)
    end)
    
    drawSlider("Плавность", settings.aim_smooth, 0, 100, x, y + 105, function(val)
        settings.aim_smooth = val
        setSetting("aim_smooth", val)
    end)
    
    drawSlider("FOV", settings.aim_fov, 10, 360, x, y + 140, function(val)
        settings.aim_fov = val
        setSetting("aim_fov", val)
    end)
    
    drawToggle("No Recoil", settings.no_recoil, x, y + 175, function(val)
        settings.no_recoil = val
        setSetting("no_recoil", val)
    end)
    
    drawToggle("No Spread", settings.no_spread, x, y + 210, function(val)
        settings.no_spread = val
        setSetting("no_spread", val)
    end)
    
    drawSlider("Разброс %", settings.spread_value, 0, 100, x, y + 245, function(val)
        settings.spread_value = val
        setSetting("spread_value", val)
    end)
end

-- ============================================
-- ВКЛАДКА: VISUALS
-- ============================================
function drawVisualsTab(settings, x, y)
    drawToggle("Тёмные дороги", settings.black_roads, x, y, function(val)
        settings.black_roads = val
        setSetting("black_roads", val)
        if val then enableBlackRoads(settings.road_darkness) else disableBlackRoads() end
    end)
    
    drawSlider("Темнота дорог", settings.road_darkness, 0, 100, x, y + 35, function(val)
        settings.road_darkness = val
        setSetting("road_darkness", val)
        if settings.black_roads then enableBlackRoads(val) end
    end)
    
    drawToggle("Кастомный прицел", settings.custom_crosshair, x, y + 70, function(val)
        settings.custom_crosshair = val
        setSetting("custom_crosshair", val)
    end)
    
    drawSlider("Стиль прицела", settings.crosshair_style, 1, 5, x, y + 105, function(val)
        settings.crosshair_style = val
        setSetting("crosshair_style", val)
    end)
    
    drawToggle("Эффекты крови", settings.blood_effects, x, y + 140, function(val)
        settings.blood_effects = val
        setSetting("blood_effects", val)
        if val then enableBloodEffects(settings.blood_size) else disableBloodEffects() end
    end)
end

-- ============================================
-- ВКЛАДКА: SOUNDS
-- ============================================
function drawSoundsTab(settings, x, y)
    drawToggle("Звуковой пак", settings.sound_pack_enabled, x, y, function(val)
        settings.sound_pack_enabled = val
        setSetting("sound_pack_enabled", val)
        if val then loadSoundPack() else unloadSoundPack() end
    end)
    
    drawSlider("Deagle звук", settings.sound_deagle, 1, 3, x, y + 35, function(val)
        settings.sound_deagle = val
        setSetting("sound_deagle", val)
        replaceWeaponSound("deagle", val)
    end)
    
    drawSlider("AK-47 звук", settings.sound_ak47, 1, 3, x, y + 70, function(val)
        settings.sound_ak47 = val
        setSetting("sound_ak47", val)
        replaceWeaponSound("ak47", val)
    end)
    
    drawSlider("Громкость", settings.weapon_volume, 0, 100, x, y + 105, function(val)
        settings.weapon_volume = val
        setSetting("weapon_volume", val)
        setWeaponVolume(val)
    end)
    
    drawToggle("Звук попадания", settings.hitsound, x, y + 140, function(val)
        settings.hitsound = val
        setSetting("hitsound", val)
    end)
end

-- ============================================
-- КОМПОНЕНТ: TOGGLE
-- ============================================
function drawToggle(label, value, x, y, callback)
    -- Фон переключателя
    local toggleW = 30
    local toggleH = 16
    local toggleX = x + 250
    
    if value then
        DrawRect(toggleX + toggleW/2, y + toggleH/2, toggleW, toggleH, accentR, accentG, accentB, 255)
    else
        DrawRect(toggleX + toggleW/2, y + toggleH/2, toggleW, toggleH, 60, 60, 60, 200)
    end
    
    -- Текст
    SetTextFont(0)
    SetTextScale(0.35, 0.35)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    AddTextComponentString(label)
    DrawText(x, y)
    
    -- Обработка клика (упрощённо)
    if IsControlJustPressed(0, 24) then -- ЛКМ
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
    -- Текст
    SetTextFont(0)
    SetTextScale(0.35, 0.35)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    AddTextComponentString(label .. ": " .. value)
    DrawText(x, y)
    
    -- Полоска слайдера
    local sliderW = 200
    local sliderH = 6
    local sliderX = x
    local sliderY = y + 18
    local percent = (value - min) / (max - min)
    
    DrawRect(sliderX + sliderW/2, sliderY, sliderW, sliderH, 60, 60, 60, 200)
    DrawRect(sliderX + (sliderW * percent)/2, sliderY, sliderW * percent, sliderH, accentR, accentG, accentB, 255)
    DrawRect(sliderX + sliderW * percent, sliderY, 8, 14, 255, 255, 255, 255)
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
    
    return false -- Заглушка
end
