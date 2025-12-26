local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 500, 0, 400)
main.Position = UDim2.new(0.5, -250, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.BorderSizePixel = 0
main.Parent = gui

-- Draggable functionality
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        
        local connection
        connection = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                connection:Disconnect()
            end
        end)
    end
end)

main.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Collapse/Expand button
local collapseButton = Instance.new("TextButton")
collapseButton.Size = UDim2.new(0, 30, 0, 30)
collapseButton.Position = UDim2.new(0, 0, 0, 0)
collapseButton.Text = "-"
collapseButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
collapseButton.TextColor3 = Color3.new(1, 1, 1)
collapseButton.BorderSizePixel = 0
collapseButton.Parent = main

-- Destroy button
local destroyButton = Instance.new("TextButton")
destroyButton.Size = UDim2.new(0, 30, 0, 30)
destroyButton.Position = UDim2.new(1, -30, 0, 0)
destroyButton.Text = "X"
destroyButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
destroyButton.TextColor3 = Color3.new(1, 1, 1)
destroyButton.BorderSizePixel = 0
destroyButton.Parent = main

destroyButton.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Tab bar
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, 0, 0, 30)
tabBar.Position = UDim2.new(0, 0, 0, 30)
tabBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
tabBar.BorderSizePixel = 0
tabBar.Parent = main

local tabs = {"Misc", "PVP", "Visuals", "Troll"}
local tabFrames = {}
local selectedTab = nil
local isCollapsed = false
local expandedSize = main.Size

collapseButton.MouseButton1Click:Connect(function()
    if isCollapsed then
        main.Size = expandedSize
        collapseButton.Text = "-"
        tabBar.Visible = true
        for _, frame in pairs(tabFrames) do
            frame.Visible = selectedTab == frame.Name
        end
        isCollapsed = false
    else
        main.Size = UDim2.new(0, 500, 0, 30)
        collapseButton.Text = "+"
        tabBar.Visible = false
        for _, frame in pairs(tabFrames) do
            frame.Visible = false
        end
        isCollapsed = true
    end
end)

for i, tabName in ipairs(tabs) do
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1 / #tabs, 0, 1, 0)
    button.Position = UDim2.new((i - 1) / #tabs, 0, 0, 0)
    button.Text = tabName
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.BorderSizePixel = 0
    button.Parent = tabBar
    
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = tabName
    contentFrame.Size = UDim2.new(1, 0, 1, -60)
    contentFrame.Position = UDim2.new(0, 0, 0, 60)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Visible = false
    contentFrame.Parent = main
    
    local scrolling = Instance.new("ScrollingFrame")
    scrolling.Size = UDim2.new(1, 0, 1, 0)
    scrolling.BackgroundTransparency = 1
    scrolling.ScrollBarThickness = 4
    scrolling.Parent = contentFrame
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 10)
    layout.Parent = scrolling
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrolling.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
    end)
    
    tabFrames[tabName] = contentFrame
    
    button.MouseButton1Click:Connect(function()
        if selectedTab then
            tabFrames[selectedTab].Visible = false
        end
        contentFrame.Visible = true
        selectedTab = tabName
    end)
end

-- Select first tab by default
if tabs[1] then
    tabFrames[tabs[1]].Visible = true
    selectedTab = tabs[1]
end

-- Notification system
local notificationContainer = Instance.new("Frame")
notificationContainer.Size = UDim2.new(0, 200, 0, 0)
notificationContainer.Position = UDim2.new(1, -210, 0, 10)
notificationContainer.BackgroundTransparency = 1
notificationContainer.Parent = gui

local notifyLayout = Instance.new("UIListLayout")
notifyLayout.SortOrder = Enum.SortOrder.LayoutOrder
notifyLayout.Padding = UDim.new(0, 5)
notifyLayout.Parent = notificationContainer

local function showNotification(message)
    local notify = Instance.new("TextLabel")
    notify.Size = UDim2.new(1, 0, 0, 20)
    notify.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    notify.TextColor3 = Color3.new(1, 1, 1)
    notify.Text = message
    notify.BackgroundTransparency = 0.2
    notify.TextTransparency = 0
    notify.BorderSizePixel = 0
    notify.Font = Enum.Font.SourceSans
    notify.TextSize = 14
    notify.Parent = notificationContainer
    
    spawn(function()
        wait(2.5)
        local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tweenOut = TweenService:Create(notify, tweenInfo, {TextTransparency = 1, BackgroundTransparency = 1})
        tweenOut:Play()
        tweenOut.Completed:Wait()
        notify:Destroy()
    end)
end

-- Helper function to create a feature frame
local function createFeatureFrame(parent, name, modes, hasTextbox, textboxValidator)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 0)
    frame.AutomaticSize = Enum.AutomaticSize.Y
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 20)
    title.Text = name
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Parent = frame
    
    local innerLayout = Instance.new("UIListLayout")
    innerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    innerLayout.Padding = UDim.new(0, 5)
    innerLayout.Parent = frame
    innerLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    if modes then
        local modeFrame = Instance.new("Frame")
        modeFrame.Size = UDim2.new(1, 0, 0, 30)
        modeFrame.BackgroundTransparency = 1
        modeFrame.Parent = frame
        
        local modeLayout = Instance.new("UIGridLayout")
        modeLayout.CellSize = UDim2.new(0, 80, 1, 0)
        modeLayout.CellPadding = UDim2.new(0, 5, 0, 0)
        modeLayout.SortOrder = Enum.SortOrder.LayoutOrder
        modeLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        modeLayout.Parent = modeFrame
        
        local buttons = {}
        local selectedMode = modes[1]
        
        for _, mode in ipairs(modes) do
            local button = Instance.new("TextButton")
            button.Text = mode
            button.BackgroundColor3 = mode == selectedMode and Color3.fromRGB(80, 80, 80) or Color3.fromRGB(50, 50, 50)
            button.TextColor3 = Color3.new(1, 1, 1)
            button.BorderSizePixel = 0
            button.Parent = modeFrame
            
            buttons[mode] = button
            
            button.MouseButton1Click:Connect(function()
                selectedMode = mode
                local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                for m, btn in pairs(buttons) do
                    local targetColor = m == mode and Color3.fromRGB(80, 80, 80) or Color3.fromRGB(50, 50, 50)
                    TweenService:Create(btn, tweenInfo, {BackgroundColor3 = targetColor}):Play()
                end
                -- Placeholder for mode change logic
            end)
        end
    end
    
    if hasTextbox then
        local textbox = Instance.new("TextBox")
        textbox.Size = UDim2.new(0, 100, 0, 30)
        textbox.PlaceholderText = hasTextbox
        textbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        textbox.TextColor3 = Color3.new(1, 1, 1)
        textbox.BorderSizePixel = 0
        textbox.Parent = frame
        
        if textboxValidator then
            textbox.FocusLost:Connect(function()
                local value = tonumber(textbox.Text)
                if value then
                    textbox.Text = tostring(textboxValidator(value))
                else
                    textbox.Text = ""
                end
                -- Placeholder for value change logic
            end)
        end
    end
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 100, 0, 30)
    toggle.Text = name .. ": Off"
    toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    toggle.TextColor3 = Color3.new(1, 1, 1)
    toggle.BorderSizePixel = 0
    toggle.Parent = frame
    
    toggle.MouseButton1Click:Connect(function()
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        if string.find(toggle.Text, "Off") then
            toggle.Text = name .. ": On"
            TweenService:Create(toggle, tweenInfo, {BackgroundColor3 = Color3.fromRGB(0, 170, 0)}):Play()
            showNotification(name .. " Enabled")
            -- Placeholder for enable logic
        else
            toggle.Text = name .. ": Off"
            TweenService:Create(toggle, tweenInfo, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
            showNotification(name .. " Disabled")
            -- Placeholder for disable logic
        end
    end)
end

-- Define feature placements
local featureConfig = {
    Misc = {
        {name = "Float", modes = {"Normal", "Bypass"}},
        {name = "FloatBypass", modes = {"Normal", "Bypass"}},
        {name = "Tpwalk", modes = {"Normal", "Bypass"}, hasTextbox = "Speed", textboxValidator = function(v) return math.max(v, 0) end},
        {name = "TpwalkBypass", modes = {"Normal", "Bypass"}, hasTextbox = "Speed", textboxValidator = function(v) return math.max(v, 0) end},
        {name = "FPS Boost", modes = {"Low", "Medium", "High", "MAX"}},
    },
    PVP = {
        {name = "HitboxExpander", hasTextbox = "Size (1-50)", textboxValidator = function(v) return math.clamp(v, 1, 50) end},
        {name = "Invisible", modes = {"Normal", "PVP"}},
    },
    Visuals = {
        {name = "NameTags"},
        {name = "ESP"},
    },
    Troll = {}
}

-- Create feature frames
for tabName, features in pairs(featureConfig) do
    local scrolling = tabFrames[tabName].ScrollingFrame
    for _, feature in ipairs(features) do
        createFeatureFrame(
            scrolling,
            feature.name,
            feature.modes,
            feature.hasTextbox,
            feature.textboxValidator
        )
    end
end
