local Players = game:GetService("Players")

local enabled = true
local highlights = {}

local function applyESP(player)
    if player == Players.LocalPlayer then return end
    if not player.Character then return end
    if highlights[player] then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "ESPHighlight"
    highlight.FillTransparency = 1
    highlight.OutlineTransparency = 0
    highlight.OutlineColor = Color3.new(1, 0, 0)
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = player.Character

    highlights[player] = highlight
end

local function removeESP(player)
    if highlights[player] then
        highlights[player]:Destroy()
        highlights[player] = nil
    end
end

for _, p in ipairs(Players:GetPlayers()) do
    if p.Character then
        applyESP(p)
    end
    p.CharacterAdded:Connect(function()
        task.wait(1)
        if enabled then
            applyESP(p)
        end
    end)
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(1)
        if enabled then
            applyESP(player)
        end
    end)
end)

Players.PlayerRemoving:Connect(removeESP)
