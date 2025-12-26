local Lighting = game:GetService("Lighting")
local Terrain = workspace:FindFirstChildOfClass("Terrain")
local RunService = game:GetService("RunService")

local mode = "Low" -- change manually or control via UI later

local function applyFPS(mode)
    if mode == "Low" then
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 1e9
        Lighting.Brightness = 1
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material = Enum.Material.Plastic
                v.Reflectance = 0
                v.Color = Color3.fromRGB(150,150,150)
            end
        end

    elseif mode == "Medium" then
        Lighting.GlobalShadows = false
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material = Enum.Material.Plastic
                v.Reflectance = 0
            end
        end

    elseif mode == "High" then
        Lighting.GlobalShadows = true

    elseif mode == "MAX" then
        Lighting.GlobalShadows = true
        Lighting.Technology = Enum.Technology.Future
        Lighting.EnvironmentDiffuseScale = 1
        Lighting.EnvironmentSpecularScale = 1
        Lighting.ClockTime = 16
        Lighting.Brightness = 3

        if Terrain then
            Terrain.WaterReflectance = 1
            Terrain.WaterTransparency = 0.1
            Terrain.WaterWaveSize = 0.2
            Terrain.WaterWaveSpeed = 10
        end
    end
end

applyFPS(mode)

-- FPS counter (logic only, no UI)
local fps = 0
local frames = 0
local last = tick()

RunService.RenderStepped:Connect(function()
    frames += 1
    if tick() - last >= 1 then
        fps = frames
        frames = 0
        last = tick()
    end
end)
