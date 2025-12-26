local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")
local cam = Workspace.CurrentCamera

local clone = nil
local controllingClone = false
local jumpHeight = 7 -- studs to teleport when jumping
local playerHeight = 1000 -- studs above clone
local platform = nil

-- Spawn clone
local function spawnClone()
    if clone then return end

    clone = Instance.new("Model")
    clone.Name = "InvisibleClone"
    clone.Parent = Workspace

    local eyeHeight = cam.CFrame.Y - hrp.Position.Y -- match camera height
    local cloneHRP = Instance.new("Part")
    cloneHRP.Name = "HumanoidRootPart"
    cloneHRP.Size = Vector3.new(2, 2, 1)
    cloneHRP.Transparency = 1
    cloneHRP.Anchored = false
    cloneHRP.CanCollide = true
    cloneHRP.Position = hrp.Position + Vector3.new(0, eyeHeight, 0)
    cloneHRP.Parent = clone

    local cloneHumanoid = Instance.new("Humanoid")
    cloneHumanoid.Parent = clone
    cloneHumanoid.WalkSpeed = 16
    cloneHumanoid.JumpPower = 0 -- disable normal jump

    -- Camera follows clone
    cam.CameraSubject = cloneHumanoid
    controllingClone = true

    -- Teleport player high above clone
    hrp.CFrame = cloneHRP.CFrame + Vector3.new(0, playerHeight, 0)

    -- Spawn platform beneath player
    platform = Instance.new("Part")
    platform.Size = Vector3.new(10, 1, 10)
    platform.Anchored = true
    platform.CanCollide = true
    platform.Color = Color3.fromRGB(255, 0, 0)
    platform.Position = hrp.Position - Vector3.new(0, humanoid.HipHeight + 1, 0)
    platform.Parent = Workspace
end

-- Destroy clone & teleport player to it
local function destroyClone()
    if clone then
        local cloneHRP = clone:FindFirstChild("HumanoidRootPart")
        if cloneHRP then
            hrp.CFrame = cloneHRP.CFrame + Vector3.new(0, 3, 0)
        end
        cam.CameraSubject = humanoid
        clone:Destroy()
        clone = nil
        controllingClone = false
    end

    if platform then
        platform:Destroy()
        platform = nil
    end
end

-- Mobile-compatible jump for clone
humanoid.Jumping:Connect(function(active)
    if active and controllingClone and clone then
        local hrpClone = clone:FindFirstChild("HumanoidRootPart")
        local cloneHumanoid = clone:FindFirstChildOfClass("Humanoid")
        if hrpClone and cloneHumanoid and cloneHumanoid.FloorMaterial ~= Enum.Material.Air then
            hrpClone.CFrame = hrpClone.CFrame + Vector3.new(0, jumpHeight, 0)
        end
    end
end)

-- Move clone & update platform horizontally
RunService.RenderStepped:Connect(function(dt)
    if controllingClone and clone then
        local moveDir = humanoid.MoveDirection
        local hrpClone = clone:FindFirstChild("HumanoidRootPart")
        local cloneHumanoid = clone:FindFirstChildOfClass("Humanoid")
        if hrpClone and cloneHumanoid then
            hrpClone.CFrame = hrpClone.CFrame + moveDir * cloneHumanoid.WalkSpeed * dt

            -- Move platform horizontally under player
            if platform then
                platform.Position = Vector3.new(hrp.Position.X, platform.Position.Y, hrp.Position.Z)
            end
        end
    end
end)

-- Expose functions for external control (like UI)
return {
    Spawn = spawnClone,
    Destroy = destroyClone,
    IsActive = function() return controllingClone end
}
