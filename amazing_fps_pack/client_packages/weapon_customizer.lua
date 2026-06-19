-- ============================================
-- AMAZING RP FPS PACK - ОБВЕСЫ НА ВСЁ ОРУЖИЕ
-- ============================================

local WEAPON_ATTACHMENTS = {

    -- ==================== ПИСТОЛЕТЫ ====================
    ["WEAPON_PISTOL"] = {  -- ПМ
        name = "ПМ",
        suppressor = {name = "Глушитель", sound = "pm_sup"},
        skin = {
            name = "Скин",
            options = {"Стандарт", "Чёрный", "Воронёный"},
            textures = {nil, "pm_black", "pm_dark"}
        },
    },

    ["WEAPON_PISTOL50"] = {  -- ТТ
        name = "ТТ",
        suppressor = {name = "Глушитель", sound = "tt_sup"},
        skin = {
            name = "Скин",
            options = {"Стандарт", "Чёрный", "Серебро"},
            textures = {nil, "tt_black", "tt_silver"}
        },
        grip = {name = "Щёчки", recoil_anim = 0.85},
    },

    ["WEAPON_APPISTOL"] = {  -- Glock 18
        name = "Glock 18",
        suppressor = {name = "Глушитель", sound = "glock_sup"},
        skin = {
            name = "Скин",
            options = {"Стандарт", "Чёрный", "Олива", "Песок"},
            textures = {nil, "glock_black", "glock_olive", "glock_sand"}
        },
        laser = {name = "ЛЦУ", color = {255, 0, 0}},
        magazine = {name = "Увел. магазин", reload_speed = 1.15},
    },

    ["WEAPON_REVOLVER"] = {  -- Наган
        name = "Наган",
        skin = {
            name = "Скин",
            options = {"Стандарт", "Чёрный", "Никель"},
            textures = {nil, "nagan_black", "nagan_nickel"}
        },
        magazine = {name = "Барабан", reload_speed = 1.2},
    },

    ["WEAPON_DEAGLE"] = {  -- Desert Eagle
        name = "Desert Eagle",
        suppressor = {name = "Глушитель", sound = "deagle_sup"},
        skin = {
            name = "Скин",
            options = {"Стандарт", "Чёрный", "Золотой", "Тигр", "Камуфляж"},
            textures = {nil, "deagle_black", "deagle_gold", "deagle_tiger", "deagle_camo"}
        },
        grip = {name = "Рукоятка", recoil_anim = 0.7},
        laser = {name = "ЛЦУ", color = {0, 255, 0}},
        muzzle = {name = "ДТК", flash_type = 2},
    },

    ["WEAPON_COMBATPISTOL"] = {  -- АПС
        name = "АПС",
        suppressor = {name = "Глушитель", sound = "aps_sup"},
        skin = {
            name = "Скин",
            options = {"Стандарт", "Чёрный"},
            textures = {nil, "aps_black"}
        },
        laser = {name = "ЛЦУ", color = {255, 0, 0}},
        magazine = {name = "Увел. магазин", reload_speed = 1.1},
    },

    ["WEAPON_MACHINEPISTOL"] = {  -- TEC-9
        name = "TEC-9",
        suppressor = {name = "Глушитель", sound = "tec9_sup"},
        skin = {
            name = "Скин",
            options = {"Стандарт", "Чёрный", "Хром"},
            textures = {nil, "tec9_black", "tec9_chrome"}
        },
        laser = {name = "ЛЦУ", color = {255, 0, 0}},
        magazine = {name = "Барабан", reload_speed = 1.3},
    },

    -- ==================== АВТОМАТЫ ====================
    ["WEAPON_ASSAULTRIFLE"] = {  -- АК-47
        name = "АК-47",
        suppressor = {name = "Глушитель", sound = "ak_sup"},
        skin = {
            name = "Скин",
            options = {"Стандарт", "Чёрный", "Золотой", "Тигр", "Сетка", "Ржавчина"},
            textures = {nil, "ak_black", "ak_gold", "ak_tiger", "ak_mesh", "ak_rust"}
        },
        scope = {
            name = "Прицел",
            options = {"Стандарт", "Коллиматор", "ACOG", "Кобра", "ПСО-1"},
            crosshair = {1, 2, 3, 4, 5}
        },
        muzzle = {name = "ДТК", flash_type = 2},
        grip = {name = "Цевьё", recoil_anim = 0.6},
        laser = {name = "ЛЦУ", color = {0, 255, 0}},
        magazine = {name = "Увел. магазин", reload_speed = 1.2},
    },

    ["WEAPON_ASSAULTRIFLE_MK2"] = {  -- АКС-74У
        name = "АКС-74У",
        suppressor = {name = "Глушитель", sound = "aks_sup"},
        skin = {
            name = "Скин",
            options = {"Стандарт", "Чёрный", "Камуфляж", "Олива"},
            textures = {nil, "aks_black", "aks_camo", "aks_olive"}
        },
        scope = {
            name = "Прицел",
            options = {"Стандарт", "Коллиматор", "Кобра"},
            crosshair = {1, 2, 4}
        },
        grip = {name = "Цевьё", recoil_anim = 0.7},
        laser = {name = "ЛЦУ", color = {0, 255, 0}},
    },

    ["WEAPON_SPECIALCARBINE"] = {  -- АК-105М
        name = "АК-105М",
        suppressor = {name = "Глушитель", sound = "ak105_sup"},
        skin = {
            name = "Скин",
            options = {"Стандарт", "Чёрный", "Пустыня", "Мультикам"},
            textures = {nil, "ak105_black", "ak105_desert", "ak105_multi"}
        },
        scope = {
            name = "Прицел",
            options = {"Стандарт", "Коллиматор", "ACOG", "EOTech"},
            crosshair = {1, 2, 3, 5}
        },
        muzzle = {name = "ДТК", flash_type = 3},
        grip = {name = "Такт. рукоятка", recoil_anim = 0.55},
        laser = {name = "ЛЦУ", color = {0, 255, 0}},
        magazine = {name = "Увел. магазин", reload_speed = 1.15},
        flashlight = {name = "Фонарик", brightness = 1.0},
    },

    ["WEAPON_BULLPUPRIFLE"] = {  -- АН-94 Абакан
        name = "АН-94 Абакан",
        suppressor = {name = "Глушитель", sound = "an94_sup"},
        skin = {
            name = "Скин",
            options = {"Стандарт", "Чёрный", "Камуфляж"},
            textures = {nil, "an94_black", "an94_camo"}
        },
        scope = {
            name = "Прицел",
            options = {"Стандарт", "Коллиматор", "ACOG", "ПСО-1"},
            crosshair = {1, 2, 3, 5}
        },
        muzzle = {name = "ДТК", flash_type = 2},
        grip = {name = "Рукоятка", recoil_anim = 0.5},
        laser = {name = "ЛЦУ", color = {0, 255, 0}},
        magazine = {name = "Увел. магазин", reload_speed = 1.1},
    },

    ["WEAPON_CARBINERIFLE"] = {  -- M4A4
        name = "M4A4",
        suppressor = {name = "Глушитель", sound = "m4_sup"},
        skin = {
            name = "Скин",
            options = {"Стандарт", "Чёрный", "Олива", "Пустыня", "Город"},
            textures = {nil, "m4_black", "m4_olive", "m4_desert", "m4_urban"}
        },
        scope = {
            name = "Прицел",
            options = {"Стандарт", "EOTech", "ACOG"},
            crosshair = {1, 5, 3}
        },
        muzzle = {name = "ДТК", flash_type = 3},
        grip = {name = "Такт. рукоятка", recoil_anim = 0.55},
        laser = {name = "ЛЦУ", color = {0, 0, 255}},
        magazine = {name = "Увел. магазин", reload_speed = 1.2},
        flashlight = {name = "Фонарик", brightness = 1.0},
    },

    ["WEAPON_ADVANCEDRIFLE"] = {  -- M4A1
        name = "M4A1",
        suppressor = {name = "Глушитель", sound = "m4a1_sup"},
        skin = {
            name = "Скин",
            options = {"Стандарт", "Чёрный", "Олива", "Зима"},
            textures = {nil, "m4a1_black", "m4a1_olive", "m4a1_winter"}
        },
        scope = {
            name = "Прицел",
            options = {"Стандарт", "EOTech", "ACOG", "Коллиматор"},
            crosshair = {1, 5, 3, 2}
        },
        muzzle = {name = "ДТК", flash_type = 3},
        grip = {name = "Такт. рукоятка", recoil_anim = 0.5},
        laser = {name = "ЛЦУ", color = {0, 0, 255}},
        magazine = {name = "Увел. магазин", reload_speed = 1.15},
        flashlight = {name = "Фонарик", brightness = 1.0},
    },

    ["WEAPON_BULLPUP"] = {  -- ОЦ-14 Гроза
        name = "ОЦ-14 Гроза",
        suppressor = {name = "Глушитель", sound = "groza_sup"},
        skin = {
            name = "Скин",
            options = {"Стандарт", "Чёрный", "Камуфляж"},
            textures = {nil, "groza_black", "groza_camo"}
        },
        scope = {
            name = "Прицел",
            options = {"Стандарт", "Коллиматор", "ACOG"},
            crosshair = {1, 2, 3}
        },
        muzzle = {name = "ДТК", flash_type = 2},
        grip = {name = "Рукоятка", recoil_anim = 0.5},
        laser = {name = "ЛЦУ", color = {0, 255, 0}},
        magazine = {name = "Увел. магазин", reload_speed = 1.1},
    },

    ["WEAPON_VAL"] = {  -- ВАЛ
        name = "ВАЛ",
        skin = {
            name = "Скин",
            options = {"Стандарт", "Чёрный", "Камуфляж"},
            textures = {nil, "val_black", "val_camo"}
        },
        scope = {
            name = "Прицел",
            options = {"Стандарт", "Коллиматор", "ПСО-1"},
            crosshair = {1, 2, 5}
        },
        laser = {name = "ЛЦУ", color = {255, 0, 0}},
        magazine = {name = "Увел. магазин", reload_speed = 1.2},
    },

    -- ==================== ПП ====================
    ["WEAPON_MICROSMG"] = {  -- Uzi
        name = "Uzi",
        suppressor = {name = "Глушитель", sound = "uzi_sup"},
        skin = {
            name = "Скин",
            options = {"Стандарт", "Чёрный", "Воронёный"},
            textures = {nil, "uzi_black", "uzi_dark"}
        },
        scope = {
            name = "Прицел",
            options = {"Стандарт", "Коллиматор"},
            crosshair = {1, 2}
        },
        grip = {name = "Рукоятка", recoil_anim = 0.75},
        laser = {name = "ЛЦУ", color = {255, 0, 0}},
        magazine = {name = "Увел. магазин", reload_speed = 1.25},
    },

    -- ==================== СНАЙПЕРСКИЕ ====================
    ["WEAPON_SNIPERRIFLE"] = {  -- СВД с ПСО
        name = "СВД",
        skin = {
            name = "Скин",
            options = {"Стандарт", "Чёрный", "Камуфляж", "Пустыня"},
            textures = {nil, "svd_black", "svd_camo", "svd_desert"}
        },
        scope = {
            name = "Прицел",
            options = {"ПСО-1", "ПСО-1 (подсветка)", "Ночной"},
            crosshair = {5, 5, 6}
        },
        muzzle = {name = "ДТК", flash_type = 2},
    },

    ["WEAPON_HEAVYSNIPER"] = {  -- Охотничье ружьё (СVD)
        name = "Охотничье ружьё",
        skin = {
            name = "Скин",
            options = {"Стандарт", "Дерево", "Камуфляж"},
            textures = {nil, "hunter_wood", "hunter_camo"}
        },
        muzzle = {name = "ДТК", flash_type = 2},
    },

    ["WEAPON_SNIPERRIFLE2"] = {  -- ВСС Винторез
        name = "ВСС Винторез",
        skin = {
            name = "Скин",
            options = {"Стандарт", "Чёрный", "Камуфляж"},
            textures = {nil, "vss_black", "vss_camo"}
        },
        scope = {
            name = "Прицел",
            options = {"ПСО-1", "Ночной"},
            crosshair = {5, 6}
        },
        laser = {name = "ЛЦУ", color = {255, 0, 0}},
    },

    -- ==================== ДРОБОВИКИ ====================
    ["WEAPON_PUMPSHOTGUN"] = {  -- Дробовик
        name = "Дробовик",
        suppressor = {name = "Глушитель", sound = "shotgun_sup"},
        skin = {
            name = "Скин",
            options = {"Стандарт", "Чёрный", "Камуфляж"},
            textures = {nil, "shotgun_black", "shotgun_camo"}
        },
        grip = {name = "Рукоятка", recoil_anim = 0.8},
        flashlight = {name = "Фонарик", brightness = 1.2},
    },

    ["WEAPON_SAWNOFFSHOTGUN"] = {  -- Обрез
        name = "Обрез",
        skin = {
            name = "Скин",
            options = {"Стандарт", "Ржавый", "Воронёный"},
            textures = {nil, "sawnoff_rust", "sawnoff_dark"}
        },
        grip = {name = "Обмотка", recoil_anim = 0.9},
    },

    ["WEAPON_HEAVYSHOTGUN"] = {  -- Сайга
        name = "Сайга",
        suppressor = {name = "Глушитель", sound = "saiga_sup"},
        skin = {
            name = "Скин",
            options = {"Стандарт", "Чёрный", "Охотничий", "Камуфляж"},
            textures = {nil, "saiga_black", "saiga_hunter", "saiga_camo"}
        },
        scope = {
            name = "Прицел",
            options = {"Стандарт", "Коллиматор", "ACOG"},
            crosshair = {1, 2, 3}
        },
        grip = {name = "Цевьё", recoil_anim = 0.65},
        laser = {name = "ЛЦУ", color = {0, 255, 0}},
        magazine = {name = "Барабан", reload_speed = 1.3},
        flashlight = {name = "Фонарик", brightness = 1.0},
    },

    -- ==================== ХОЛОДНОЕ ====================
    ["WEAPON_BAT"] = {  -- Бита
        name = "Бита",
        skin = {
            name = "Скин",
            options = {"Дерево", "Алюминий", "Чёрная"},
            textures = {nil, "bat_alu", "bat_black"}
        },
    },

    ["WEAPON_NIGHTSTICK"] = {  -- Дубинка
        name = "Дубинка",
        skin = {
            name = "Скин",
            options = {"Стандарт", "Чёрная"},
            textures = {nil, "nightstick_black"}
        },
    },

    ["WEAPON_STUNGUN"] = {  -- Тайзер
        name = "Тайзер",
        laser = {name = "ЛЦУ", color = {255, 255, 0}},
        flashlight = {name = "Фонарик", brightness = 0.6},
    },
}

-- ============================================
-- ТЕКУЩИЕ ОБВЕСЫ ИГРОКА
-- ============================================
local currentAttachments = {}

-- ============================================
-- СБРОС ОБВЕСОВ ДЛЯ ОРУЖИЯ
-- ============================================
function resetAttachments(weaponName)
    currentAttachments[weaponName] = {
        suppressor = false,
        skin = 1,
        scope = 1,
        laser = false,
        flashlight = false,
        muzzle = false,
        grip = false,
        magazine = false,
    }
end

-- ============================================
-- ПРИМЕНИТЬ ГЛУШИТЕЛЬ
-- ============================================
function applySuppressor(weaponName, enable)
    local weaponHash = GetHashKey(weaponName)
    if enable then
        SetWeaponMuzzleFlashEnabled(weaponHash, false)
    else
        SetWeaponMuzzleFlashEnabled(weaponHash, true)
    end
end

-- ============================================
-- ПРИМЕНИТЬ СКИН
-- ============================================
function applySkin(weaponName, skinIndex)
    -- Замена текстуры (заглушка, нужны .ytd файлы)
end

-- ============================================
-- ПРИМЕНИТЬ ПРИЦЕЛ
-- ============================================
function applyScope(weaponName, scopeIndex)
    local attachments = WEAPON_ATTACHMENTS[weaponName]
    if attachments and attachments.scope then
        local style = attachments.scope.crosshair[scopeIndex] or 1
        -- Установка стиля прицела для этого оружия
    end
end

-- ============================================
-- ПРИМЕНИТЬ ЛЦУ
-- ============================================
function applyLaser(weaponName, enable)
    if enable then
        -- Отрисовка точки лазера
    else
        -- Скрыть точку
    end
end

-- ============================================
-- ПРИМЕНИТЬ ФОНАРИК
-- ============================================
function applyFlashlight(weaponName, enable)
    if enable then
        SetFlashlightKeepOnWhileMoving(true)
        SetFlashlightEnabled(true)
    else
        SetFlashlightEnabled(false)
    end
end

-- ============================================
-- ПРИМЕНИТЬ ДТК
-- ============================================
function applyMuzzle(weaponName, enable)
    if enable then
        -- Изменить тип вспышки
    end
end

-- ============================================
-- ПРИМЕНИТЬ РУКОЯТКУ
-- ============================================
function applyGrip(weaponName, enable)
    -- Визуальное изменение анимации отдачи
end

-- ============================================
-- ПРИМЕНИТЬ МАГАЗИН
-- ============================================
function applyMagazine(weaponName, enable)
    -- Ускорение перезарядки
end

-- ============================================
-- ПРИМЕНИТЬ ВСЕ ОБВЕСЫ РАЗОМ
-- ============================================
function applyAllAttachments(weaponName)
    local attachments = currentAttachments[weaponName]
    if not attachments then
        resetAttachments(weaponName)
        attachments = currentAttachments[weaponName]
    end

    if attachments.suppressor then applySuppressor(weaponName, true) end
    if attachments.skin and attachments.skin > 1 then applySkin(weaponName, attachments.skin) end
    if attachments.scope and attachments.scope > 1 then applyScope(weaponName, attachments.scope) end
    if attachments.laser then applyLaser(weaponName, true) end
    if attachments.flashlight then applyFlashlight(weaponName, true) end
    if attachments.muzzle then applyMuzzle(weaponName, true) end
    if attachments.grip then applyGrip(weaponName, true) end
    if attachments.magazine then applyMagazine(weaponName, true) end
end

-- ============================================
-- ПОЛУЧИТЬ ДОСТУПНЫЕ ОБВЕСЫ
-- ============================================
function getAvailableAttachments(weaponName)
    local data = WEAPON_ATTACHMENTS[weaponName]
    if not data then return {} end

    local list = {}
    for key, val in pairs(data) do
        if key ~= "name" then
            table.insert(list, {
                id = key,
                name = val.name,
                type = key,
                data = val,
            })
        end
    end
    return list
end

-- ============================================
-- ПОЛУЧИТЬ НАЗВАНИЕ ОРУЖИЯ
-- ============================================
function getWeaponDisplayName(weaponName)
    local data = WEAPON_ATTACHMENTS[weaponName]
    if data and data.name then return data.name end
    return weaponName
end

-- ============================================
-- ПОЛУЧИТЬ ВЕСЬ СПИСОК ОРУЖИЯ
-- ============================================
function getWeaponList()
    local list = {}
    for name, _ in pairs(WEAPON_ATTACHMENTS) do
        table.insert(list, name)
    end
    return list
end
