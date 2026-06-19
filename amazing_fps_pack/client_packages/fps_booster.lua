-- ============================================
-- AMAZING RP FPS PACK - FPS BOOSTER
-- ============================================

local fpsBefore = 0
local fpsAfter = 0

-- ============================================
-- ТЕНИ
-- ============================================
function disableShadows()
    SetShadowQuality(0)
    CascadeShadowsSetCascadeBoundsScale(0.0)
    CascadeShadowsSetDynamicDepthMode(false)
    CascadeShadowsSetEntityTrackerScale(0.0)
end

function enableShadows()
    SetShadowQuality(3)
    CascadeShadowsSetCascadeBoundsScale(1.0)
    CascadeShadowsSetDynamicDepthMode(true)
    CascadeShadowsSetEntityTrackerScale(1.0)
end

-- ============================================
-- ОТРАЖЕНИЯ
-- ============================================
function disableReflections()
    SetReflectionQuality(0)
end

function enableReflections()
    SetReflectionQuality(3)
end

-- ============================================
-- ТРАВА
-- ============================================
function disableGrass()
    SetGrassQuality(0)
    SetGrassLodScale(0.0)
end

function enableGrass()
    SetGrassQuality(3)
    SetGrassLodScale(1.0)
end

-- ============================================
-- ВОДА
-- ============================================
function disableWater()
    SetWaterQuality(0)
end

function enableWater()
    SetWaterQuality(3)
end

-- ============================================
-- BLOOM
-- ============================================
function disableBloom()
    SetBloomEnabled(false)
    SetBloomScale(0.0)
end

function enableBloom()
    SetBloomEnabled(true)
    SetBloomScale(1.0)
end

-- ============================================
-- LENS FLARE
-- ============================================
function disableLensFlare()
    SetLensFlareEnabled(false)
end

function enableLensFlare()
    SetLensFlareEnabled(true)
end

-- ============================================
-- ЧАСТИЦЫ
-- ============================================
function disableParticles()
    SetParticlesQuality(0)
end

function enableParticles()
    SetParticlesQuality(3)
end

-- ============================================
-- AMBIENT OCCLUSION
-- ============================================
function disableAO()
    SetAmbientOcclusionEnabled(false)
    SetAmbientOcclusionQuality(0)
end

function enableAO()
    SetAmbientOcclusionEnabled(true)
    SetAmbientOcclusionQuality(3)
end

-- ============================================
-- LOD (ДАЛЬНОСТЬ ПРОРИСОВКИ)
-- ============================================
function setLodDistance(value)
    -- value: 0-100
    local scaled = 0.1 + (value / 100) * 0.9
    SetLodScale(scaled)
    SetLodLightDistanceScale(scaled)
end

-- ============================================
-- ОТКЛЮЧИТЬ ТЕССЕЛЯЦИЮ
-- ============================================
function disableTessellation()
    SetTessellationEnabled(false)
end

-- ============================================
-- ПРИМЕНИТЬ ВСЕ НАСТРОЙКИ FPS
-- ============================================
function applyAllFpsSettings(settings)
    if settings.disable_shadows then disableShadows() else enableShadows() end
    if settings.disable_reflections then disableReflections() else enableReflections() end
    if settings.disable_grass then disableGrass() else enableGrass() end
    if settings.disable_water then disableWater() else enableWater() end
    if settings.disable_bloom then disableBloom() else enableBloom() end
    if settings.disable_lensflare then disableLensFlare() else enableLensFlare() end
    if settings.disable_particles then disableParticles() else enableParticles() end
    if settings.disable_ao then disableAO() else enableAO() end
    setLodDistance(settings.lod_distance)
    disableTessellation()
end

-- ============================================
-- ПОЛУЧИТЬ ТЕКУЩИЙ FPS
-- ============================================
function getFPS()
    return math.floor(1.0 / GetFrameTime())
end

-- ============================================
-- СОХРАНИТЬ БАЗОВЫЙ FPS
-- ============================================
function saveBaseFPS()
    fpsBefore = getFPS()
end

-- ============================================
-- ПРИРОСТ FPS
-- ============================================
function getFPSGain()
    fpsAfter = getFPS()
    return fpsAfter - fpsBefore
end

function getFPSGainPercent()
    if fpsBefore <= 0 then return 0 end
    return math.floor(((fpsAfter - fpsBefore) / fpsBefore) * 100)
end
