-- ============================================
-- AMAZING RP FPS PACK - НАСТРОЙКИ
-- ============================================

local SETTINGS_FILE = "amazing_fps_pack.json"

-- Дефолтные настройки
local DEFAULTS = {
    -- FPS BOOST
    disable_shadows = true,
    disable_reflections = true,
    disable_grass = true,
    disable_water = false,
    disable_bloom = true,
    disable_lensflare = true,
    disable_particles = false,
    disable_ao = true,
    lod_distance = 30,           -- 0-100%
    auto_clear_memory = true,
    auto_clear_interval = 5,     -- минуты

    -- AIM
    aim_enabled = true,
    aim_lock = true,
    aim_strength = 70,           -- 0-100%
    aim_smooth = 60,             -- 0-100%
    aim_fov = 90,                -- угол
    aim_color_enemy = {255, 0, 0, 255},
    aim_color_default = {0, 255, 0, 255},
    no_recoil = true,
    no_spread = true,
    spread_value = 0,            -- 0-100%
    fire_rate_multiplier = 1.0,  -- 0.5 - 2.0
    aim_dynamic_size = true,

    -- VISUALS
    black_roads = true,
    road_darkness = 80,          -- 0-100%
    custom_crosshair = true,
    crosshair_style = 1,         -- 1-5
    crosshair_size = 15,
    crosshair_alpha = 200,
    crosshair_color = {0, 255, 0, 255},
    custom_fist_icon = true,
    custom_weapon_icons = true,
    custom_money_font = true,
    custom_chat_font = true,
    muzzle_flash = true,
    muzzle_flash_type = 1,       -- 1-4
    blood_effects = true,
    blood_size = 50,             -- 0-100%

    -- SOUNDS
    sound_pack_enabled = true,
    sound_deagle = 1,            -- 1-3
    sound_ak47 = 1,              -- 1-3
    sound_m4 = 1,                -- 1-2
    sound_pistol = 1,            -- 1-2
    sound_sniper = 1,
    sound_shotgun = 1,
    weapon_volume = 80,          -- 0-100%
    hitsound = true,
    hitsound_type = 1,           -- 1-3

    -- MONITOR
    show_fps = true,
    fps_position = 1             -- 1-4
}

-- Таблица с текущими настройками
local currentSettings = {}

-- ============================================
-- ГЛУБОКОЕ КОПИРОВАНИЕ ТАБЛИЦЫ
-- ============================================
local function deepCopy(orig)
    local copy = {}
    for k, v in pairs(orig) do
        if type(v) == "table" then
            copy[k] = deepCopy(v)
        else
            copy[k] = v
        end
    end
    return copy
end

-- ============================================
-- ЗАГРУЗКА НАСТРОЕК
-- ============================================
function loadSettings()
    currentSettings = deepCopy(DEFAULTS)
    
    -- В RAGE:MP Lua нет прямого доступа к mp.storage как в JS
    -- Используем файловую систему или оставляем сброс при каждом запуске
    -- Позже добавим сохранение через server-side
    
    return currentSettings
end

-- ============================================
-- СОХРАНЕНИЕ НАСТРОЕК
-- ============================================
function saveSettings()
    -- Будет реализовано через TriggerServerEvent
    -- Пока заглушка
end

-- ============================================
-- СБРОС НА ДЕФОЛТ
-- ============================================
function resetSettings()
    currentSettings = deepCopy(DEFAULTS)
    saveSettings()
end

-- ============================================
-- ПОЛУЧИТЬ / ИЗМЕНИТЬ НАСТРОЙКУ
-- ============================================
function getSetting(key)
    return currentSettings[key]
end

function setSetting(key, value)
    currentSettings[key] = value
end

function getAllSettings()
    return currentSettings
end
