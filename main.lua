local repoBase = "https://raw.githubusercontent.com/morelitojr-creator/Lito-Gub/main/"

local featureFiles = {
    "FloatBypass.lua",
    "InvisibleFE.lua",
    "FlingPVP.lua",
    "HitboxPVP.lua",
    "NametagMISC.lua",
    "FPSBoostMISC.lua",
    "ESP.lua"
}

for _, fileName in ipairs(featureFiles) do
    local url = repoBase .. fileName
    local success, err = pcall(function()
        loadstring(game:HttpGet(url))()
    end)
    if not success then
        warn("Failed to load " .. fileName .. ": " .. err)
    end
end
