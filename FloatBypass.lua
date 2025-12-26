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

-- Troll TP to ground every 3 seconds
local trollTPInterval = 3

-- Detect jump state
humanoid.StateChanged:Connect(function(_, newState)
    if newState == Enum.HumanoidStateType.Jumping then
        jumping = true
    elseif newState == Enum.HumanoidStateType.Landed then
        jumping = false
    end
end)

-- Spawn platform under player
local function spawnPlatform()
    if hoverPlatform then
        hoverPlatform:Destroy()
    end

    local platform = Instance.new("Part")
    platform.Anchored = true
    platform.CanCollide = true
    platform.Size = Vector3.new(8, 1, 8) -- bigger platform
    platform.Transparency = 0.5
    platform.Color = Color3.fromRGB(0, 200, 255)
    platform.Position = hrp.Position - Vector3.new(0, humanoid.HipHeight + 0.1, 0)
    platform.Parent = Workspace
    hoverPlatform = platform
end

-- Heartbeat loop
RunService.Heartbeat:Connect(function(dt)
    if not enabled or not hrp then return end
    local velY = hrp.Velocity.Y
    local decelY = prevVelocityY - velY

    -- Spawn platform only when decelerating from jump
    if jumping and velY < 0 and decelY > 0 and not debounce then
        debounce = true
        task.delay(0.1, function()
            if enabled and hrp then spawnPlatform() end
        end)
    elseif velY > 0 then
        debounce = false
    end

    -- Smooth horizontal platform follow
    if hoverPlatform and hrp then
        hoverPlatform.Position = hoverPlatform.Position:Lerp(
            Vector3.new(hrp.Position.X, hoverPlatform.Position.Y, hrp.Position.Z),
            0.2
        )
    end
end)

-- Troll TP every 3 seconds
task.spawn(function()
    while task.wait(trollTPInterval) do
        if enabled and hrp then
            local ray = Workspace:Raycast(hrp.Position, Vector3.new(0, -500, 0))
            if ray then
                hrp.CFrame = CFrame.new(ray.Position + Vector3.new(0, 3, 0))
            end
        end
    end
end)

-- Update character references after respawn
local function updateCharacter(newChar)
    char = newChar
    hrp = char:WaitForChild("HumanoidRootPart")
    humanoid = char:WaitForChild("Humanoid")
end
player.CharacterAdded:Connect(updateCharacter)
