local Players = game:GetService("Players")

local enabled = true
local tags = {}

local function createTag(player)
    if player == Players.LocalPlayer then return end
    if not player.Character then return end
    if tags[player] then return end

    local head = player.Character:FindFirstChild("Head")
    if not head then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "CustomNametag"
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = head

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Text = player.Name
    label.TextStrokeTransparency = 0
    label.Parent = billboard

    local function updateColor()
        if player.Team and player.Team.TeamColor then
            label.TextColor3 = player.Team.TeamColor.Color
        else
            label.TextColor3 = Color3.new(1, 1, 1)
        end
    end

    updateColor()
    player:GetPropertyChangedSignal("Team"):Connect(updateColor)

    tags[player] = billboard
end

local function removeTag(player)
    if tags[player] then
        tags[player]:Destroy()
        tags[player] = nil
    end
end

for _, p in ipairs(Players:GetPlayers()) do
    if p.Character then
        createTag(p)
    end
    p.CharacterAdded:Connect(function()
        task.wait(1)
        if enabled then
            createTag(p)
        end
    end)
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(1)
        if enabled then
            createTag(player)
        end
    end)
end)

Players.PlayerRemoving:Connect(removeTag)
