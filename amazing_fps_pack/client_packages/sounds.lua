-- ============================================
-- AMAZING RP FPS PACK - ЗВУКИ ОРУЖИЯ
-- ============================================

local soundPackEnabled = false
local weaponVolume = 80

-- ============================================
-- ПУТИ К ЗВУКАМ
-- ============================================
local SOUND_PATHS = {
    deagle = {
        [1] = "sounds/deagle_default.wav",
        [2] = "sounds/deagle_crisp.wav",
        [3] = "sounds/deagle_heavy.wav",
    },
    ak47 = {
        [1] = "sounds/ak_default.wav",
        [2] = "sounds/ak_tactical.wav",
        [3] = "sounds/ak_suppressed.wav",
    },
    m4 = {
        [1] = "sounds/m4_default.wav",
        [2] = "sounds/m4_soft.wav",
    },
    pistol = {
        [1] = "sounds/pistol_default.wav",
        [2] = "sounds/pistol_suppressed.wav",
    },
    sniper = {
        [1] = "sounds/sniper_default.wav",
    },
    shotgun = {
        [1] = "sounds/shotgun_default.wav",
    },
    hitsound = {
        [1] = "sounds/hit_default.wav",
        [2] = "sounds/hit_cod.wav",
        [3] = "sounds/hit_rust.wav",
    }
}

-- ============================================
-- ЗАГРУЗКА ЗВУКОВОГО ПАКА
-- ============================================
function loadSoundPack()
    soundPackEnabled = true
    -- В RAGE:MP Lua загрузка звуков через аудио-движок
    -- Большинство серверов блокируют замену звуков оружия
    -- Поэтому оставляем интерфейс, реализация зависит от сервера
end

function unloadSoundPack()
    soundPackEnabled = false
end

-- ============================================
-- ВОСПРОИЗВЕСТИ ЗВУК ПОПАДАНИЯ
-- ============================================
function playHitSound(soundType)
    if not soundPackEnabled then return end
    
    local soundPath = SOUND_PATHS.hitsound[soundType]
    if soundPath then
        -- PlaySoundFrontend(-1, soundName, soundSet, false)
        -- Заглушка, т.к. нужен доступ к аудио-банкам
    end
end

-- ============================================
-- ЗАМЕНИТЬ ЗВУК ОРУЖИЯ
-- ============================================
function replaceWeaponSound(weaponType, soundVariant)
    if not soundPackEnabled then return end
    
    local soundPath = SOUND_PATHS[weaponType]
    if soundPath and soundPath[soundVariant] then
        -- Замена через аудио-движок
        -- Заглушка
    end
end

-- ============================================
-- УСТАНОВИТЬ ГРОМКОСТЬ
-- ============================================
function setWeaponVolume(volume)
    weaponVolume = volume
    SetAudioFlag("WeaponVolume", true)
    -- Кастомная громкость
end
