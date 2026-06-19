-- ============================================
-- AMAZING RP FPS PACK - НАСТРОЙКИ
-- ============================================

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
    lod_distance = 30,
    auto_clear_memory = true,
    auto_clear_interval = 5,

    -- AIM
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

    -- VISUALS
    black_roads = true,
    road_darkness = 80,
    custom_crosshair = true,
    crosshair_style = 1,
    crosshair_size = 15,
    crosshair_alpha = 200,
    crosshair_color = {0, 255, 0, 255},
    custom_fist_icon = true,
    custom_weapon_icons = true,
    custom_money_font = true,
    custom_chat_font = true,
    muzzle_flash = true,
    muzzle_flash_type = 1,
    blood_effects = true,
    blood_size = 50,

    -- SOUNDS
    sound_pack_enabled = true,
    sound_deagle = 1,
    sound_ak47 = 1,
    sound_m4 = 1,
    sound_pistol = 1,
    sound_sniper = 1,
    sound_shotgun = 1,
    weapon_volume = 80,
    hitsound = true,
    hitsound_type = 1,

    -- MONITOR
    show_fps = true,
    fps_position = 1
}

local currentSettings = {}

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

function loadSettings()
    currentSettings = deepCopy(DEFAULTS)
    return currentSettings
end

function saveSettings()
end

function resetSettings()
    currentSettings = deepCopy(DEFAULTS)
end

function getSetting(key)
    return currentSettings[key]
end

function setSetting(key, value)
    currentSettings[key] = value
end

function getAllSettings()
    return currentSettings
end
