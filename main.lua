-- Main.lua template for Lito-Gub
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

-- Draggable
local dragging, dragInput, dragStart, startPos
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
    if input == dragInput and dragging then update(input) end
end)

-- Tab bar
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, 0, 0, 30)
tabBar.Position = UDim2.new(0, 0, 0, 0)
tabBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
tabBar.BorderSizePixel = 0
tabBar.Parent = main

local tabs = {"Misc","PVP","Visuals","Troll"}
local tabFrames = {}
local selectedTab = nil

for i, tabName in ipairs(tabs) do
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1/#tabs,0,1,0)
    button.Position = UDim2.new((i-1)/#tabs,0,0,0)
    button.Text = tabName
    button.BackgroundColor3 = Color3.fromRGB(40,40,40)
    button.TextColor3 = Color3.new(1,1,1)
    button.BorderSizePixel = 0
    button.Parent = tabBar
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,0,1,-30)
    frame.Position = UDim2.new(0,0,0,30)
    frame.BackgroundTransparency = 1
    frame.Visible = false
    frame.Parent = main
    tabFrames[tabName] = frame
    
    local scrolling = Instance.new("ScrollingFrame")
    scrolling.Size = UDim2.new(1,0,1,0)
    scrolling.BackgroundTransparency = 1
    scrolling.ScrollBarThickness = 4
    scrolling.Parent = frame
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0,10)
    layout.Parent = scrolling
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrolling.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 20)
    end)
    
    button.MouseButton1Click:Connect(function()
        if selectedTab then tabFrames[selectedTab].Visible = false end
        frame.Visible = true
        selectedTab = tabName
    end)
end

-- Select first tab
tabFrames[tabs[1]].Visible = true
selectedTab = tabs[1]

-- Feature creation helper
local function createFeature(parent, name, url)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,-10,0,40)
    frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0,100,0,30)
    toggle.Position = UDim2.new(0,5,0,5)
    toggle.Text = name..": Off"
    toggle.BackgroundColor3 = Color3.fromRGB(50,50,50)
    toggle.TextColor3 = Color3.new(1,1,1)
    toggle.BorderSizePixel = 0
    toggle.Parent = frame
    
    toggle.MouseButton1Click:Connect(function()
        if string.find(toggle.Text,"Off") then
            toggle.Text = name..": On"
            toggle.BackgroundColor3 = Color3.fromRGB(0,170,0)
            loadstring(game:HttpGet(url))()
        else
            toggle.Text = name..": Off"
            toggle.BackgroundColor3 = Color3.fromRGB(50,50,50)
        end
    end)
end

-- Add all features
local miscFrame = tabFrames["Misc"].ScrollingFrame
local pvpFrame = tabFrames["PVP"].ScrollingFrame
local visualsFrame = tabFrames["Visuals"].ScrollingFrame

-- Misc
createFeature(miscFrame,"Float","https://raw.githubusercontent.com/morelitojr-creator/Lito-Gub/main/Float.lua")
createFeature(miscFrame,"FloatBypass","https://raw.githubusercontent.com/morelitojr-creator/Lito-Gub/main/FloatBypass.lua")
createFeature(miscFrame,"Tpwalk","https://raw.githubusercontent.com/morelitojr-creator/Lito-Gub/main/Tpwalk.lua")
createFeature(miscFrame,"TpwalkBypass","https://raw.githubusercontent.com/morelitojr-creator/Lito-Gub/main/TpwalkBypass.lua")
createFeature(miscFrame,"FPS Boost","https://raw.githubusercontent.com/morelitojr-creator/Lito-Gub/main/FpsBoost.lua")

-- PVP
createFeature(pvpFrame,"HitboxExpander","https://raw.githubusercontent.com/morelitojr-creator/Lito-Gub/main/HitboxExpander.lua")
createFeature(pvpFrame,"Invisible","https://raw.githubusercontent.com/morelitojr-creator/Lito-Gub/main/Invisible.lua")

-- Visuals
createFeature(visualsFrame,"NameTags","https://raw.githubusercontent.com/morelitojr-creator/Lito-Gub/main/NameTags.lua")
createFeature(visualsFrame,"ESP","https://raw.githubusercontent.com/morelitojr-creator/Lito-Gub/main/ESP.lua")
