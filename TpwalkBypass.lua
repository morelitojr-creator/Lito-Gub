local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")
local cam = Workspace.CurrentCamera

local tpwalkSpeed = 16
local enabled = true

-- Update character references after respawn
local function updateCharacter(newChar)
    char = newChar
    hrp = char:WaitForChild("HumanoidRootPart")
    humanoid = char:WaitForChild("Humanoid")
end
player.CharacterAdded:Connect(updateCharacter)

-- Move player with camera-relative TPWalk Bypass
RunService.RenderStepped:Connect(function(dt)
    if not enabled or not hrp then return end
    local moveDir = humanoid.MoveDirection
    if moveDir.Magnitude > 0 then
        local camCF = cam.CFrame
        local moveVector = (camCF.LookVector * moveDir.Z + camCF.RightVector * moveDir.X)
        moveVector = Vector3.new(moveVector.X, 0, moveVector.Z)
        hrp.CFrame = hrp.CFrame + moveVector * tpwalkSpeed * dt
    end
end)

-- Mobile-compatible jump (optional)
humanoid.Jumping:Connect(function(active)
    if active and enabled then
        hrp.Velocity = Vector3.new(hrp.Velocity.X, 50, hrp.Velocity.Z)
    end
end)
