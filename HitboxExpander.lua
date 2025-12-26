local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local hitboxSize = 10 -- default size
local enabled = true

-- Function to update hitboxes
local function updateHitboxes()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = plr.Character.HumanoidRootPart
            if hrp:FindFirstChild("Hitbox") then
                hrp.Hitbox.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
            else
                local hb = Instance.new("Part")
                hb.Name = "Hitbox"
                hb.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                hb.Transparency = 1
                hb.CanCollide = false
                hb.Anchored = false
                hb.Parent = hrp
                -- Weld to HRP
                local weld = Instance.new("WeldConstraint")
                weld.Part0 = hrp
                weld.Part1 = hb
                weld.Parent = hrp
            end
        end
    end
end

-- RunService loop to keep updating hitboxes
RunService.RenderStepped:Connect(function()
    if enabled then
        updateHitboxes()
    end
end)

-- Optional functions for external control
local HitboxModule = {}

function HitboxModule.SetSize(size)
    hitboxSize = math.clamp(size, 1, 50)
end

function HitboxModule.Enable()
    enabled = true
end

function HitboxModule.Disable()
    enabled = false
end

return HitboxModule
