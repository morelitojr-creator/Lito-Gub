local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

local hoverPlatform = nil
local enabled = true
local debounce = false
local jumping = false
local prevVelocityY = 0
local lastPlatformY = nil
local tpInterval = 3 -- bypass interval
local tpDebounce = false

-- Detect jump state
humanoid.StateChanged:Connect(function(_, newState)
    if newState == Enum.HumanoidStateType.Jumping then
        jumping = true
    elseif newState == Enum.HumanoidStateType.Landed then
        jumping = false
    end
end)

-- Spawn platform
local function spawnPlatform()
    if hoverPlatform then
        hoverPlatform:Destroy()
    end

    local platform = Instance.new("Part")
    platform.Anchored = true
    platform.CanCollide = true
    platform.Size = Vector3.new(8, 1, 8)
    platform.Transparency = 0.9 -- almost invisible
    platform.Color = Color3.fromRGB(0, 200, 255)
    platform.Position = hrp.Position - Vector3.new(0, humanoid.HipHeight + 0.1, 0) -- right under feet
    platform.Parent = Workspace
    hoverPlatform = platform
    lastPlatformY = platform.Position.Y

    hrp.Velocity = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z)
end

-- Bypass teleport down and back
local function bypassTP()
    if not hoverPlatform or tpDebounce then return end
    tpDebounce = true

    local rayOrigin = hrp.Position
    local rayDirection = Vector3.new(0, -500, 0)
    local ignoreList = {char}
    if hoverPlatform then table.insert(ignoreList, hoverPlatform) end

    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = ignoreList

    local raycastResult = Workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    if raycastResult then
        local groundY = raycastResult.Position.Y
        hrp.CFrame = CFrame.new(hrp.Position.X, groundY + 2, hrp.Position.Z) -- place feet on ground
        task.wait(0.1)
        hrp.CFrame = CFrame.new(hrp.Position.X, lastPlatformY + 0.5, hrp.Position.Z)
    end

    tpDebounce = false
end

-- Heartbeat loop
local tpTimer = 0
RunService.Heartbeat:Connect(function(dt)
    if not enabled or not hrp then return end
    local velY = hrp.Velocity.Y
    local decelY = prevVelocityY - velY

    if jumping and velY < 0 and decelY > 0 and not debounce then
        debounce = true
        task.delay(0.1, function()
            if enabled and hrp then spawnPlatform() end
        end)
    elseif velY > 0 then
        debounce = false
    end

    if hoverPlatform and hrp then
        hoverPlatform.Position = hoverPlatform.Position:Lerp(
            Vector3.new(hrp.Position.X, hoverPlatform.Position.Y, hrp.Position.Z),
            0.2
        )
    end

    tpTimer = tpTimer + dt
    if tpTimer >= tpInterval then
        tpTimer = 0
        bypassTP()
    end

    prevVelocityY = velY
end)

-- Update character references after respawn
local function updateCharacter(newChar)
    char = newChar
    hrp = char:WaitForChild("HumanoidRootPart")
    humanoid = char:WaitForChild("Humanoid")

    -- Reset jump state and platform
    jumping = false
    if hoverPlatform then
        hoverPlatform:Destroy()
        hoverPlatform = nil
    end
end
player.CharacterAdded:Connect(updateCharacter)
