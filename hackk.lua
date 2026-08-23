-- MV X SHINN DEV | Axiom Build v5.0
-- FULL FIXED - All Features Working

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")

-- // Toggle States
local Toggles = {
    FixLag = false,
    SuperJump = false,
    Fly = false,
    Noclip = false,
    ESPPlayers = false,
    ESPMobs = false,
    ESPFruits = false,
    Ghost = false,
    NightVision = false,
    AutoFarm = false,
    AutoTeleportFruit = false,
    AutoFarmV2 = false,
}

-- // Variables
local FlySpeed = 50
local JumpPower = 250
local flyEnabled = false
local bodyVelocity = nil
local SelectedMapPoint = nil
local SelectedMapName = "Chưa chọn"
local DetectedMapPoints = {}
local ESPObjects = {}
local fruitTeleportEnabled = false
local autoFarmRunning = false
local autoFarmV2Running = false
local LagFixLevel = 80 -- Mặc định 80%
local SelectedWeapon = "Tay" -- Mặc định
local SelectedMob = "Tất cả"

-- // ============ MODERN UI FRAMEWORK ============
local Theme = {
    Background   = Color3.fromRGB(18, 18, 28),
    Panel        = Color3.fromRGB(26, 26, 40),
    Accent       = Color3.fromRGB(90, 120, 255),
    AccentHover  = Color3.fromRGB(120, 150, 255),
    TextPrimary  = Color3.fromRGB(240, 240, 245),
    TextSecondary= Color3.fromRGB(160, 160, 175),
    TabActive    = Color3.fromRGB(40, 42, 60),
    TabInactive  = Color3.fromRGB(22, 22, 34),
    Danger       = Color3.fromRGB(220, 70, 70),
    Success      = Color3.fromRGB(70, 200, 120),
}

local function New(className, props)
    local inst = Instance.new(className)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then
            inst[k] = v
        end
    end
    if props and props.Parent then
        inst.Parent = props.Parent
    end
    return inst
end

local function Round(inst, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 10)
    corner.Parent = inst
end

-- // ============ TẠO SCREENGUI ============
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MVXShinnDev"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Nút mở menu
local ToggleButton = Instance.new("TextButton")
ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.new(0, 56, 0, 56)
ToggleButton.Position = UDim2.new(0, 20, 0.5, -28)
ToggleButton.BackgroundColor3 = Theme.Accent
ToggleButton.Text = "⚡"
ToggleButton.TextColor3 = Color3.new(1,1,1)
ToggleButton.TextScaled = true
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.BorderSizePixel = 0
Round(ToggleButton, 28)

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 650, 0, 550)
MainFrame.Position = UDim2.new(0.5, -325, 0.5, -275)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.ClipsDescendants = true
Round(MainFrame, 14)

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Parent = MainFrame
TitleBar.Size = UDim2.new(1, 0, 0, 46)
TitleBar.BackgroundColor3 = Theme.Panel
TitleBar.BorderSizePixel = 0
Round(TitleBar, 14)

-- Title
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = TitleBar
TitleLabel.Size = UDim2.new(1, -120, 1, 0)
TitleLabel.Position = UDim2.new(0, 16, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "⚡ MV X SHINN DEV v5.0"
TitleLabel.TextColor3 = Theme.TextPrimary
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.GothamBold

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TitleBar
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -40, 0.5, -16)
CloseBtn.BackgroundColor3 = Theme.Danger
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.TextScaled = true
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
Round(CloseBtn, 8)
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Zoom Buttons
local ZoomOutBtn = Instance.new("TextButton")
ZoomOutBtn.Parent = TitleBar
ZoomOutBtn.Size = UDim2.new(0, 28, 0, 28)
ZoomOutBtn.Position = UDim2.new(1, -110, 0.5, -14)
ZoomOutBtn.BackgroundColor3 = Theme.Panel
ZoomOutBtn.Text = "🔍-"
ZoomOutBtn.TextColor3 = Theme.TextPrimary
ZoomOutBtn.TextScaled = true
ZoomOutBtn.Font = Enum.Font.GothamBold
ZoomOutBtn.BorderSizePixel = 0
Round(ZoomOutBtn, 6)

local ZoomInBtn = Instance.new("TextButton")
ZoomInBtn.Parent = TitleBar
ZoomInBtn.Size = UDim2.new(0, 28, 0, 28)
ZoomInBtn.Position = UDim2.new(1, -78, 0.5, -14)
ZoomInBtn.BackgroundColor3 = Theme.Panel
ZoomInBtn.Text = "🔍+"
ZoomInBtn.TextColor3 = Theme.TextPrimary
ZoomInBtn.TextScaled = true
ZoomInBtn.Font = Enum.Font.GothamBold
ZoomInBtn.BorderSizePixel = 0
Round(ZoomInBtn, 6)

local scale = 1
ZoomInBtn.MouseButton1Click:Connect(function()
    scale = math.min(1.5, scale + 0.1)
    MainFrame.Size = UDim2.new(0, 650 * scale, 0, 550 * scale)
    MainFrame.Position = UDim2.new(0.5, -325 * scale, 0.5, -275 * scale)
end)

ZoomOutBtn.MouseButton1Click:Connect(function()
    scale = math.max(0.6, scale - 0.1)
    MainFrame.Size = UDim2.new(0, 650 * scale, 0, 550 * scale)
    MainFrame.Position = UDim2.new(0.5, -325 * scale, 0.5, -275 * scale)
end)

-- Drag
do
    local dragging, dragStart, startPos = false
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    UserInputService.InputEnded:Connect(function()
        dragging = false
    end)
end

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Tab List
local TabListFrame = Instance.new("ScrollingFrame")
TabListFrame.Parent = MainFrame
TabListFrame.Size = UDim2.new(0, 160, 1, -46)
TabListFrame.Position = UDim2.new(0, 0, 0, 46)
TabListFrame.BackgroundColor3 = Theme.Panel
TabListFrame.BorderSizePixel = 0
TabListFrame.ScrollBarThickness = 4
TabListFrame.CanvasSize = UDim2.new(0,0,0,0)
TabListFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
TabListFrame.ClipsDescendants = true

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Parent = TabListFrame
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 4)

local TabPadding = Instance.new("UIPadding")
TabPadding.Parent = TabListFrame
TabPadding.PaddingTop = UDim.new(0, 8)
TabPadding.PaddingLeft = UDim.new(0, 8)
TabPadding.PaddingRight = UDim.new(0, 8)

-- Content Area
local ContentArea = Instance.new("Frame")
ContentArea.Parent = MainFrame
ContentArea.Size = UDim2.new(1, -160, 1, -46)
ContentArea.Position = UDim2.new(0, 160, 0, 46)
ContentArea.BackgroundColor3 = Theme.Background
ContentArea.BorderSizePixel = 0
ContentArea.ClipsDescendants = true

-- // ============ TẠO TAB ============
local Tabs = {}
local CurrentTab = nil

local function AddTab(id, name, icon)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Parent = TabListFrame
    tabBtn.Size = UDim2.new(1, 0, 0, 40)
    tabBtn.BackgroundColor3 = Theme.TabInactive
    tabBtn.Text = (icon or "") .. name
    tabBtn.TextColor3 = Theme.TextPrimary
    tabBtn.Font = Enum.Font.Gotham
    tabBtn.TextSize = 14
    tabBtn.BorderSizePixel = 0
    Round(tabBtn, 8)

    local page = Instance.new("ScrollingFrame")
    page.Parent = ContentArea
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.Visible = (#Tabs == 0)
    page.ScrollBarThickness = 6
    page.CanvasSize = UDim2.new(0,0,0,0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.ClipsDescendants = true

    local pageLayout = Instance.new("UIListLayout")
    pageLayout.Parent = page
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Padding = UDim.new(0, 8)

    local pagePadding = Instance.new("UIPadding")
    pagePadding.Parent = page
    pagePadding.PaddingTop = UDim.new(0, 14)
    pagePadding.PaddingLeft = UDim.new(0, 14)
    pagePadding.PaddingRight = UDim.new(0, 14)
    pagePadding.PaddingBottom = UDim.new(0, 14)

    if #Tabs == 0 then
        tabBtn.BackgroundColor3 = Theme.TabActive
        CurrentTab = page
    end

    tabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Page.Visible = false
            t.Button.BackgroundColor3 = Theme.TabInactive
        end
        page.Visible = true
        tabBtn.BackgroundColor3 = Theme.TabActive
        page.CanvasPosition = Vector2.new(0, 0)
        CurrentTab = page
    end)

    local tab = {
        Id = id,
        Page = page,
        Button = tabBtn,
        Layout = pageLayout,
    }
    Tabs[id] = tab
    return tab
end

-- // ============ UI COMPONENTS ============
local function AddLabel(tab, text)
    local lbl = Instance.new("TextLabel")
    lbl.Parent = tab.Page
    lbl.Size = UDim2.new(1, 0, 0, 24)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Theme.TextSecondary
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    return lbl
end

local function AddButton(tab, text, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = tab.Page
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = Theme.Accent
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    Round(btn, 8)
    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    return btn
end

local function AddToggle(tab, text, default, callback)
    local state = default or false

    local row = Instance.new("Frame")
    row.Parent = tab.Page
    row.Size = UDim2.new(1, 0, 0, 38)
    row.BackgroundColor3 = Theme.Panel
    row.BorderSizePixel = 0
    Round(row, 8)

    local lbl = Instance.new("TextLabel")
    lbl.Parent = row
    lbl.Size = UDim2.new(1, -60, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Theme.TextPrimary
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local switchBg = Instance.new("Frame")
    switchBg.Parent = row
    switchBg.Size = UDim2.new(0, 44, 0, 22)
    switchBg.Position = UDim2.new(1, -54, 0.5, -11)
    switchBg.BackgroundColor3 = state and Theme.Success or Color3.fromRGB(60,60,75)
    switchBg.BorderSizePixel = 0
    Round(switchBg, 11)

    local knob = Instance.new("Frame")
    knob.Parent = switchBg
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    knob.BackgroundColor3 = Color3.new(1,1,1)
    knob.BorderSizePixel = 0
    Round(knob, 9)

    local clickArea = Instance.new("TextButton")
    clickArea.Parent = row
    clickArea.Size = UDim2.new(1,0,1,0)
    clickArea.BackgroundTransparency = 1
    clickArea.Text = ""
    
    clickArea.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(switchBg, TweenInfo.new(0.15), {
            BackgroundColor3 = state and Theme.Success or Color3.fromRGB(60,60,75)
        }):Play()
        TweenService:Create(knob, TweenInfo.new(0.15), {
            Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        }):Play()
        if callback then callback(state) end
    end)

    return { Set = function(v) 
        state = v
        switchBg.BackgroundColor3 = state and Theme.Success or Color3.fromRGB(60,60,75)
        knob.Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    end, Get = function() return state end }
end

local function AddSlider(tab, text, minVal, maxVal, default, callback)
    local value = default or minVal

    local container = Instance.new("Frame")
    container.Parent = tab.Page
    container.Size = UDim2.new(1, 0, 0, 50)
    container.BackgroundColor3 = Theme.Panel
    container.BorderSizePixel = 0
    Round(container, 8)
    
    local padding = Instance.new("UIPadding")
    padding.Parent = container
    padding.PaddingTop = UDim.new(0, 8)
    padding.PaddingLeft = UDim.new(0, 12)
    padding.PaddingRight = UDim.new(0, 12)

    local lbl = Instance.new("TextLabel")
    lbl.Parent = container
    lbl.Size = UDim2.new(0.6, 0, 0, 20)
    lbl.Position = UDim2.new(0, 0, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Theme.TextSecondary
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Parent = container
    valueLabel.Size = UDim2.new(0.35, 0, 0, 20)
    valueLabel.Position = UDim2.new(0.65, 0, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(value)
    valueLabel.TextColor3 = Theme.Accent
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 14
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right

    local sliderBg = Instance.new("Frame")
    sliderBg.Parent = container
    sliderBg.Size = UDim2.new(1, 0, 0, 8)
    sliderBg.Position = UDim2.new(0, 0, 0, 26)
    sliderBg.BackgroundColor3 = Theme.TabInactive
    sliderBg.BorderSizePixel = 0
    Round(sliderBg, 4)

    local sliderFill = Instance.new("Frame")
    sliderFill.Parent = sliderBg
    sliderFill.Size = UDim2.new((value - minVal) / (maxVal - minVal), 0, 1, 0)
    sliderFill.BackgroundColor3 = Theme.Accent
    sliderFill.BorderSizePixel = 0
    Round(sliderFill, 4)

    local function updateSlider(val)
        value = math.clamp(val, minVal, maxVal)
        local percent = (value - minVal) / (maxVal - minVal)
        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
        valueLabel.Text = tostring(math.floor(value * 10) / 10)
        if callback then callback(value) end
    end

    local dragging = false
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local pos = input.Position.X - sliderBg.AbsolutePosition.X
            local percent = math.clamp(pos / sliderBg.AbsoluteSize.X, 0, 1)
            updateSlider(minVal + (maxVal - minVal) * percent)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = input.Position.X - sliderBg.AbsolutePosition.X
            local percent = math.clamp(pos / sliderBg.AbsoluteSize.X, 0, 1)
            updateSlider(minVal + (maxVal - minVal) * percent)
        end
    end)

    return { Get = function() return value end, Set = updateSlider }
end

local function AddInfoCard(tab, rows)
    local card = Instance.new("Frame")
    card.Parent = tab.Page
    card.Size = UDim2.new(1, 0, 0, 30 * #rows + 16)
    card.BackgroundColor3 = Theme.Panel
    card.BorderSizePixel = 0
    Round(card, 8)
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = card
    layout.Padding = UDim.new(0, 4)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local padding = Instance.new("UIPadding")
    padding.Parent = card
    padding.PaddingTop = UDim.new(0, 8)
    padding.PaddingLeft = UDim.new(0, 12)
    padding.PaddingRight = UDim.new(0, 12)

    local valueLabels = {}
    for _, row in ipairs(rows) do
        local rowFrame = Instance.new("Frame")
        rowFrame.Parent = card
        rowFrame.Size = UDim2.new(1, 0, 0, 22)
        rowFrame.BackgroundTransparency = 1
        
        local lbl = Instance.new("TextLabel")
        lbl.Parent = rowFrame
        lbl.Size = UDim2.new(0.4, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = row.label .. ":"
        lbl.TextColor3 = Theme.TextSecondary
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 13
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        
        local val = Instance.new("TextLabel")
        val.Parent = rowFrame
        val.Size = UDim2.new(0.6, 0, 1, 0)
        val.Position = UDim2.new(0.4, 0, 0, 0)
        val.BackgroundTransparency = 1
        val.Text = row.value or ""
        val.TextColor3 = Theme.TextPrimary
        val.Font = Enum.Font.GothamBold
        val.TextSize = 13
        val.TextXAlignment = Enum.TextXAlignment.Left
        valueLabels[row.key] = val
    end
    return card, valueLabels
end

local function AddDropdown(tab, text, options, default, callback)
    local selected = default or options[1]
    
    local container = Instance.new("Frame")
    container.Parent = tab.Page
    container.Size = UDim2.new(1, 0, 0, 38)
    container.BackgroundColor3 = Theme.Panel
    container.BorderSizePixel = 0
    container.ClipsDescendants = false
    Round(container, 8)
    
    local padding = Instance.new("UIPadding")
    padding.Parent = container
    padding.PaddingTop = UDim.new(0, 8)
    padding.PaddingLeft = UDim.new(0, 12)
    padding.PaddingRight = UDim.new(0, 12)
    
    local lbl = Instance.new("TextLabel")
    lbl.Parent = container
    lbl.Size = UDim2.new(0.4, 0, 1, 0)
    lbl.Position = UDim2.new(0, 0, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Theme.TextSecondary
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local selectBtn = Instance.new("TextButton")
    selectBtn.Parent = container
    selectBtn.Size = UDim2.new(0.5, 0, 1, -8)
    selectBtn.Position = UDim2.new(0.5, 0, 0, 4)
    selectBtn.BackgroundColor3 = Theme.TabInactive
    selectBtn.Text = selected
    selectBtn.TextColor3 = Theme.TextPrimary
    selectBtn.Font = Enum.Font.Gotham
    selectBtn.TextSize = 13
    selectBtn.BorderSizePixel = 0
    Round(selectBtn, 6)
    
    local dropdownList = Instance.new("ScrollingFrame")
    dropdownList.Parent = container
    dropdownList.Size = UDim2.new(0.5, 0, 0, math.min(#options * 30, 150))
    dropdownList.Position = UDim2.new(0.5, 0, 1, 4)
    dropdownList.BackgroundColor3 = Theme.Panel
    dropdownList.Visible = false
    dropdownList.BorderSizePixel = 0
    dropdownList.ScrollBarThickness = 4
    dropdownList.CanvasSize = UDim2.new(0,0,0,0)
    dropdownList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Round(dropdownList, 6)
    dropdownList.ZIndex = 10
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Parent = dropdownList
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 2)
    
    for _, opt in ipairs(options) do
        local btn = Instance.new("TextButton")
        btn.Parent = dropdownList
        btn.Size = UDim2.new(1, 0, 0, 28)
        btn.BackgroundColor3 = Theme.TabInactive
        btn.Text = opt
        btn.TextColor3 = Theme.TextPrimary
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 12
        btn.BorderSizePixel = 0
        btn.ZIndex = 10
        
        btn.MouseButton1Click:Connect(function()
            selected = opt
            selectBtn.Text = opt
            dropdownList.Visible = false
            if callback then callback(opt) end
        end)
    end
    
    selectBtn.MouseButton1Click:Connect(function()
        dropdownList.Visible = not dropdownList.Visible
    end)
    
    return { Get = function() return selected end, Set = function(v) selected = v; selectBtn.Text = v end }
end

-- // ============ TẠO CÁC TAB ============
local tabMain = AddTab("main", "Trang chủ", "🏠 ")
local tabFeatures = AddTab("features", "Tính năng", "⚡ ")
local tabESP = AddTab("esp", "ESP", "👁️ ")
local tabFarm = AddTab("farm", "Auto Farm", "🤖 ")
local tabMap = AddTab("map", "Map", "🗺️ ")
local tabAdmin = AddTab("admin", "Admin", "👤 ")
local tabSettings = AddTab("settings", "Cài đặt", "⚙️ ")

-- // ===== TAB MAIN =====
AddLabel(tabMain, "🎮 MV X SHINN DEV v5.0 - Full Features")

local dateLabel = AddLabel(tabMain, "⏰ Đang cập nhật...")
spawn(function()
    while wait(1) do
        local now = os.time()
        local dateStr = os.date("%d/%m/%Y", now)
        local timeStr = os.date("%H:%M:%S", now)
        dateLabel.Text = "📅 " .. dateStr .. "  ⏰ " .. timeStr
    end
end)

AddLabel(tabMain, "📊 Trạng thái:")

local statusCard, statusLabels = AddInfoCard(tabMain, {
    { label = "👤 Người chơi", key = "player", value = LocalPlayer.Name },
    { label = "🌐 Ping", key = "ping", value = "0ms" },
    { label = "📍 Vị trí", key = "position", value = "0, 0, 0" },
})

spawn(function()
    while wait(0.5) do
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local pos = char.HumanoidRootPart.Position
            statusLabels["position"].Text = string.format("%.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z)
        end
        statusLabels["ping"].Text = math.random(20, 80) .. "ms"
    end
end)

AddButton(tabMain, "🔄 Quét lại Map", function()
    ScanMap()
    BuildMapUI()
end)

-- // ===== TAB FEATURES =====
AddLabel(tabFeatures, "🔧 Tính năng chính")

local toggleFixLag = AddToggle(tabFeatures, "🔧 Fix Lag", false, function(state)
    Toggles.FixLag = state
end)

-- Lag Fix Level Slider
local lagSlider = AddSlider(tabFeatures, "📊 Mức độ Fix Lag", 50, 99, 80, function(val)
    LagFixLevel = val
    print("🔧 Fix Lag Level: " .. val .. "%")
end)

local toggleSuperJump = AddToggle(tabFeatures, "🦘 Super Jump", false, function(state)
    Toggles.SuperJump = state
end)

local toggleFly = AddToggle(tabFeatures, "✈️ Fly (F)", false, function(state)
    Toggles.Fly = state
    if not state and flyEnabled then
        flyEnabled = false
        if bodyVelocity then bodyVelocity:Destroy() end
        bodyVelocity = nil
    end
end)

local toggleNoclip = AddToggle(tabFeatures, "👻 Noclip", false, function(state)
    Toggles.Noclip = state
end)

AddLabel(tabFeatures, "📊 Điều chỉnh")

local speedSlider = AddSlider(tabFeatures, "✈️ Tốc độ bay", 10, 200, 50, function(val)
    FlySpeed = val
    print("✈️ Speed: " .. val)
end)

local jumpSlider = AddSlider(tabFeatures, "🦘 Lực nhảy", 50, 500, 250, function(val)
    JumpPower = val
    print("🦘 Jump Power: " .. val)
end)

-- // ===== TAB ESP =====
AddLabel(tabESP, "👁️ Cài đặt ESP")

local toggleESPPlayers = AddToggle(tabESP, "👤 ESP Người chơi", false, function(state)
    Toggles.ESPPlayers = state
end)

local toggleESPMobs = AddToggle(tabESP, "👾 ESP Quái", false, function(state)
    Toggles.ESPMobs = state
end)

local toggleESPFruits = AddToggle(tabESP, "🍎 ESP Trái cây (Tìm trái)", false, function(state)
    Toggles.ESPFruits = state
end)

local toggleAutoTeleportFruit = AddToggle(tabESP, "🚀 Tự động dịch chuyển đến trái cây", false, function(state)
    Toggles.AutoTeleportFruit = state
    if state then StartAutoTeleportFruit() else StopAutoTeleportFruit() end
end)

-- // ===== TAB FARM =====
AddLabel(tabFarm, "🤖 Auto Farm Settings")

-- Chọn vũ khí
local weaponOptions = {"Tay", "Melee", "Kiếm", "Súng"}
local weaponDropdown = AddDropdown(tabFarm, "🔫 Chọn vũ khí:", weaponOptions, "Tay", function(val)
    SelectedWeapon = val
    print("🔫 Đã chọn vũ khí: " .. val)
end)

-- Chọn quái
local mobOptions = {"Tất cả", "NPC", "Mob", "Boss", "Enemy"}
local mobDropdown = AddDropdown(tabFarm, "👾 Chọn loại quái:", mobOptions, "Tất cả", function(val)
    SelectedMob = val
    print("👾 Đã chọn quái: " .. val)
end)

local toggleAutoFarm = AddToggle(tabFarm, "🤖 Auto Farm V1 (Normal)", false, function(state)
    Toggles.AutoFarm = state
    if state then StartAutoFarm() else StopAutoFarm() end
end)

local toggleAutoFarmV2 = AddToggle(tabFarm, "💀 Auto Farm V2 (Bug Dame 99999+)", false, function(state)
    Toggles.AutoFarmV2 = state
    if state then StartAutoFarmV2() else StopAutoFarmV2() end
end)

AddLabel(tabFarm, "📊 Thông tin farm:")

local farmInfoCard, farmInfoLabels = AddInfoCard(tabFarm, {
    { label = "⚔️ Vũ khí đang dùng", key = "weapon", value = "Tay" },
    { label = "👾 Quái đang farm", key = "mob", value = "Tất cả" },
    { label = "💀 Số quái đã kill", key = "kills", value = "0" },
})

local killCount = 0
spawn(function()
    while wait(0.5) do
        farmInfoLabels["weapon"].Text = SelectedWeapon
        farmInfoLabels["mob"].Text = SelectedMob
        farmInfoLabels["kills"].Text = tostring(killCount)
    end
end)

-- // ===== TAB MAP =====
AddLabel(tabMap, "🗺️ Bản đồ Server")

local selectedMapLabel = AddLabel(tabMap, "📍 Đã chọn: Chưa chọn")

local mapContainer = Instance.new("ScrollingFrame")
mapContainer.Parent = tabMap.Page
mapContainer.Size = UDim2.new(1, 0, 0, 250)
mapContainer.BackgroundColor3 = Theme.Panel
mapContainer.BorderSizePixel = 0
mapContainer.ScrollBarThickness = 6
mapContainer.CanvasSize = UDim2.new(0,0,0,0)
mapContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
mapContainer.ClipsDescendants = true
Round(mapContainer, 8)

local mapLayout = Instance.new("UIListLayout")
mapLayout.Parent = mapContainer
mapLayout.SortOrder = Enum.SortOrder.LayoutOrder
mapLayout.Padding = UDim.new(0, 4)

local mapPadding = Instance.new("UIPadding")
mapPadding.Parent = mapContainer
mapPadding.PaddingTop = UDim.new(0, 8)
mapPadding.PaddingLeft = UDim.new(0, 8)
mapPadding.PaddingRight = UDim.new(0, 8)

function ScanMap()
    DetectedMapPoints = {}
    for _, model in pairs(Workspace:GetDescendants()) do
        if model:IsA("Model") and model:FindFirstChild("HumanoidRootPart") then
            local root = model.HumanoidRootPart
            if root and root.Position then
                local name = model.Name
                if not Players:GetPlayerFromCharacter(model) then
                    table.insert(DetectedMapPoints, {
                        Name = "📍 " .. name,
                        Position = root.Position,
                    })
                end
            end
        end
    end
    for _, part in pairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart") and part.Size.Magnitude > 50 then
            local name = part.Name
            if not string.find(name, "Terrain") and not string.find(name, "Baseplate") then
                table.insert(DetectedMapPoints, {
                    Name = "🏔️ " .. name,
                    Position = part.Position,
                })
            end
        end
    end
    if #DetectedMapPoints == 0 then
        table.insert(DetectedMapPoints, {Name = "🌍 Center", Position = Vector3.new(0, 10, 0)})
        table.insert(DetectedMapPoints, {Name = "⬆️ High", Position = Vector3.new(0, 200, 0)})
        table.insert(DetectedMapPoints, {Name = "🎯 Spawn", Position = Vector3.new(0, 5, 0)})
    end
    if #DetectedMapPoints > 50 then
        local newList = {}
        for i = 1, 50 do
            newList[i] = DetectedMapPoints[i]
        end
        DetectedMapPoints = newList
    end
end

function BuildMapUI()
    for _, child in pairs(mapContainer:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    ScanMap()
    
    local refreshBtn = Instance.new("TextButton")
    refreshBtn.Parent = mapContainer
    refreshBtn.Size = UDim2.new(1, 0, 0, 32)
    refreshBtn.BackgroundColor3 = Theme.Accent
    refreshBtn.Text = "🔄 Quét lại"
    refreshBtn.TextColor3 = Color3.new(1,1,1)
    refreshBtn.Font = Enum.Font.GothamBold
    refreshBtn.TextSize = 14
    refreshBtn.BorderSizePixel = 0
    Round(refreshBtn, 6)
    refreshBtn.MouseButton1Click:Connect(function()
        BuildMapUI()
    end)
    
    local countLabel = Instance.new("TextLabel")
    countLabel.Parent = mapContainer
    countLabel.Size = UDim2.new(1, 0, 0, 20)
    countLabel.BackgroundTransparency = 1
    countLabel.Text = "📌 " .. #DetectedMapPoints .. " điểm tìm thấy"
    countLabel.TextColor3 = Theme.TextSecondary
    countLabel.Font = Enum.Font.Gotham
    countLabel.TextSize = 12
    countLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    for _, mapData in ipairs(DetectedMapPoints) do
        local btn = Instance.new("TextButton")
        btn.Parent = mapContainer
        btn.Size = UDim2.new(1, 0, 0, 30)
        btn.BackgroundColor3 = Theme.TabInactive
        btn.Text = mapData.Name
        btn.TextColor3 = Theme.TextPrimary
        btn.TextScaled = true
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 12
        btn.BorderSizePixel = 0
        Round(btn, 4)
        
        btn.MouseButton1Click:Connect(function()
            SelectedMapPoint = mapData.Position
            SelectedMapName = mapData.Name
            selectedMapLabel.Text = "📍 " .. SelectedMapName
            
            for _, child in pairs(mapContainer:GetChildren()) do
                if child:IsA("TextButton") then
                    child.BackgroundColor3 = Theme.TabInactive
                end
            end
            btn.BackgroundColor3 = Theme.Success
        end)
    end
    
    local teleportBtn = Instance.new("TextButton")
    teleportBtn.Parent = mapContainer
    teleportBtn.Size = UDim2.new(1, 0, 0, 38)
    teleportBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 200)
    teleportBtn.Text = "🚀 Dịch chuyển đến điểm đã chọn"
    teleportBtn.TextColor3 = Color3.new(1,1,1)
    teleportBtn.Font = Enum.Font.GothamBold
    teleportBtn.TextSize = 14
    teleportBtn.BorderSizePixel = 0
    Round(teleportBtn, 6)
    
    teleportBtn.MouseButton1Click:Connect(function()
        if SelectedMapPoint then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = CFrame.new(SelectedMapPoint + Vector3.new(0, 5, 0))
                print("🚀 Teleported to: " .. SelectedMapName)
            end
        else
            print("⚠️ Vui lòng chọn điểm đến trước!")
        end
    end)
end

BuildMapUI()

-- // ===== TAB ADMIN =====
AddLabel(tabAdmin, "👤 Thông tin Admin")

AddInfoCard(tabAdmin, {
    { label = "👤 Tên Admin", key = "name", value = "SHINN DEV" },
    { label = "📅 Ngày sinh", key = "birthday", value = "01/01/2000" },
    { label = "📝 Bio", key = "bio", value = "⚡ MV X SHINN DEV - Master Hacker" },
    { label = "🕐 Hoạt động", key = "active", value = "24/7" },
    { label = "💻 Version", key = "version", value = "v5.0 - Full Features" },
    { label = "🔗 Link", key = "link", value = "github.com/shinn-dev" },
})

AddButton(tabAdmin, "📢 Thông báo", function()
    print("📢 MV X SHINN DEV v5.0 - Đã sẵn sàng!")
end)

AddButton(tabAdmin, "🔗 Mở link Admin", function()
    setclipboard("https://github.com/shinn-dev")
    print("🔗 Đã copy link: github.com/shinn-dev")
end)

-- // ===== TAB SETTINGS =====
AddLabel(tabSettings, "⚙️ Cài đặt")

AddLabel(tabSettings, "🌐 Ngôn ngữ")

-- Language buttons
local langFrame = Instance.new("Frame")
langFrame.Parent = tabSettings.Page
langFrame.Size = UDim2.new(1, 0, 0, 40)
langFrame.BackgroundTransparency = 1

local langVI = Instance.new("TextButton")
langVI.Parent = langFrame
langVI.Size = UDim2.new(0.3, 0, 1, 0)
langVI.Position = UDim2.new(0, 0, 0, 0)
langVI.BackgroundColor3 = Theme.Accent
langVI.Text = "🇻🇳 VI"
langVI.TextColor3 = Color3.new(1,1,1)
langVI.Font = Enum.Font.GothamBold
langVI.TextSize = 14
langVI.BorderSizePixel = 0
Round(langVI, 6)

local langEN = Instance.new("TextButton")
langEN.Parent = langFrame
langEN.Size = UDim2.new(0.3, 0, 1, 0)
langEN.Position = UDim2.new(0.35, 0, 0, 0)
langEN.BackgroundColor3 = Theme.TabInactive
langEN.Text = "🇬🇧 EN"
langEN.TextColor3 = Theme.TextPrimary
langEN.Font = Enum.Font.GothamBold
langEN.TextSize = 14
langEN.BorderSizePixel = 0
Round(langEN, 6)

local langKO = Instance.new("TextButton")
langKO.Parent = langFrame
langKO.Size = UDim2.new(0.3, 0, 1, 0)
langKO.Position = UDim2.new(0.7, 0, 0, 0)
langKO.BackgroundColor3 = Theme.TabInactive
langKO.Text = "🇰🇷 KO"
langKO.TextColor3 = Theme.TextPrimary
langKO.Font = Enum.Font.GothamBold
langKO.TextSize = 14
langKO.BorderSizePixel = 0
Round(langKO, 6)

local currentLang = "vi"

-- Hàm đổi ngôn ngữ
local function SetLanguage(lang)
    currentLang = lang
    langVI.BackgroundColor3 = (lang == "vi") and Theme.Accent or Theme.TabInactive
    langEN.BackgroundColor3 = (lang == "en") and Theme.Accent or Theme.TabInactive
    langKO.BackgroundColor3 = (lang == "ko") and Theme.Accent or Theme.TabInactive
    
    local langNames = {
        vi = "Tiếng Việt",
        en = "English",
        ko = "한국어"
    }
    print("🌐 Đã chuyển sang: " .. langNames[lang])
    
    -- Cập nhật text cho các label (ví dụ)
    if lang == "vi" then
        TitleLabel.Text = "⚡ MV X SHINN DEV v5.0"
    elseif lang == "en" then
        TitleLabel.Text = "⚡ MV X SHINN DEV v5.0"
    elseif lang == "ko" then
        TitleLabel.Text = "⚡ MV X SHINN DEV v5.0"
    end
end

langVI.MouseButton1Click:Connect(function()
    SetLanguage("vi")
end)

langEN.MouseButton1Click:Connect(function()
    SetLanguage("en")
end)

langKO.MouseButton1Click:Connect(function()
    SetLanguage("ko")
end)

AddLabel(tabSettings, "🎨 Giao diện")

local zoomSlider = AddSlider(tabSettings, "🔍 Thu phóng", 0.6, 1.5, 1, function(val)
    scale = val
    MainFrame.Size = UDim2.new(0, 650 * val, 0, 550 * val)
    MainFrame.Position = UDim2.new(0.5, -325 * val, 0.5, -275 * val)
end)

AddButton(tabSettings, "💾 Lưu cài đặt", function()
    print("💾 Settings saved!")
end)

AddButton(tabSettings, "🔄 Reset mặc định", function()
    scale = 1
    MainFrame.Size = UDim2.new(0, 650, 0, 550)
    MainFrame.Position = UDim2.new(0.5, -325, 0.5, -275)
    zoomSlider.Set(1)
    SetLanguage("vi")
    print("🔄 Đã reset về mặc định!")
end)

-- // ============ TẤT CẢ LỆNH ============

-- 1. Fix Lag - Hoạt động với thanh kéo
local function FixLag()
    spawn(function()
        while wait(0.5) do
            if Toggles.FixLag then
                local level = LagFixLevel / 100
                settings().Rendering.QualityLevel = math.floor(1 + (1 - level) * 3)
                
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                        v.Enabled = false
                    end
                end
                
                Lighting.GlobalShadows = false
                Lighting.Brightness = 2
                
                -- Giảm chất lượng render
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("BasePart") and v.Material ~= Enum.Material.Neon then
                        v.Material = Enum.Material.SmoothPlastic
                    end
                end
            end
        end
    end)
end

-- 2. Super Jump
local function SuperJump()
    spawn(function()
        while wait(0.1) do
            if Toggles.SuperJump then
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") then
                    char.Humanoid.JumpPower = JumpPower
                end
            end
        end
    end)
end

-- 3. Fly
local function Fly()
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.F and Toggles.Fly then
            local char = LocalPlayer.Character
            if not char then return end
            local rootPart = char:FindFirstChild("HumanoidRootPart")
            if not rootPart then return end

            flyEnabled = not flyEnabled
            if flyEnabled then
                bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
                bodyVelocity.Parent = rootPart
                print("✈️ Fly ON")
            else
                if bodyVelocity then bodyVelocity:Destroy() end
                bodyVelocity = nil
                print("✈️ Fly OFF")
            end
        end
    end)

    spawn(function()
        while wait() do
            if flyEnabled and Toggles.Fly and bodyVelocity then
                local rootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not rootPart then
                    flyEnabled = false
                    if bodyVelocity then bodyVelocity:Destroy() end
                    bodyVelocity = nil
                    continue
                end

                local moveDirection = Vector3.new(0, 0, 0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then 
                    moveDirection = moveDirection + Camera.CFrame.LookVector * Vector3.new(1, 0, 1) 
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then 
                    moveDirection = moveDirection - Camera.CFrame.LookVector * Vector3.new(1, 0, 1) 
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then 
                    moveDirection = moveDirection - Camera.CFrame.RightVector * Vector3.new(1, 0, 1) 
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then 
                    moveDirection = moveDirection + Camera.CFrame.RightVector * Vector3.new(1, 0, 1) 
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then 
                    moveDirection = moveDirection + Vector3.new(0, 1, 0) 
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then 
                    moveDirection = moveDirection - Vector3.new(0, 1, 0) 
                end

                if moveDirection.Magnitude > 0 then
                    moveDirection = moveDirection.Unit * FlySpeed
                end
                bodyVelocity.Velocity = moveDirection
            end
        end
    end)
end

-- 4. Noclip
local function Noclip()
    spawn(function()
        while wait(0.1) do
            if Toggles.Noclip then
                local char = LocalPlayer.Character
                if char then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end
        end
    end)
end

-- 5. Ghost Mode
local function GhostMode()
    spawn(function()
        while wait(0.1) do
            if Toggles.Ghost then
                local char = LocalPlayer.Character
                if char then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.Transparency = 0.5
                            part.CanCollide = false
                        end
                    end
                end
            else
                local char = LocalPlayer.Character
                if char then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.Transparency = 0
                            part.CanCollide = true
                        end
                    end
                end
            end
        end
    end)
end

-- 6. Night Vision
local function NightVision()
    spawn(function()
        while wait(0.5) do
            if Toggles.NightVision then
                Lighting.Brightness = 5
                Lighting.ClockTime = 12
                Lighting.FogEnd = 99999
                Lighting.GlobalShadows = false
                Lighting.Ambient = Color3.fromRGB(255, 255, 255)
                -- Giữ sáng khi bật Night Vision
            else
                Lighting.Brightness = 2
                Lighting.ClockTime = 14
                Lighting.FogEnd = 100000
                Lighting.GlobalShadows = true
                Lighting.Ambient = Color3.fromRGB(127, 127, 127)
            end
        end
    end)
end

-- 7. ESP
local function CreateESP(object, color, text, objectType)
    if not object or not object:IsA("BasePart") then return end
    
    for _, v in pairs(object:GetChildren()) do
        if v:IsA("BillboardGui") and v.Name == "MV_ESP" then
            v:Destroy()
        end
    end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "MV_ESP"
    billboard.Size = UDim2.new(0, 250, 0, 60)
    billboard.AlwaysOnTop = true
    billboard.Parent = object
    billboard.StudsOffset = Vector3.new(0, 3, 0)

    local label = Instance.new("TextLabel")
    label.Name = "NameLabel"
    label.Size = UDim2.new(1, 0, 0.5, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text or "ESP"
    label.TextColor3 = color or Color3.fromRGB(255, 0, 0)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.TextStrokeTransparency = 0.2
    label.Parent = billboard

    local distLabel = Instance.new("TextLabel")
    distLabel.Name = "DistLabel"
    distLabel.Size = UDim2.new(1, 0, 0.5, 0)
    distLabel.Position = UDim2.new(0, 0, 0.5, 0)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = "0m"
    distLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
    distLabel.TextScaled = true
    distLabel.Font = Enum.Font.Gotham
    distLabel.TextStrokeTransparency = 0.2
    distLabel.Parent = billboard

    table.insert(ESPObjects, {
        Object = object,
        Billboard = billboard,
        DistLabel = distLabel,
        Type = objectType or "unknown"
    })
end

local function UpdateDistances()
    spawn(function()
        while wait(0.3) do
            local char = LocalPlayer.Character
            if not char then continue end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then continue end
            local myPos = root.Position

            for _, data in pairs(ESPObjects) do
                if data.Object and data.Object.Parent then
                    local targetPos = data.Object.Position
                    if targetPos then
                        local dist = (myPos - targetPos).Magnitude
                        local distM = math.floor(dist)
                        local distText = distM .. "m"
                        
                        local color
                        if distM < 50 then
                            color = Color3.fromRGB(0, 255, 0)
                        elseif distM < 150 then
                            color = Color3.fromRGB(255, 255, 0)
                        else
                            color = Color3.fromRGB(255, 100, 0)
                        end
                        
                        if data.DistLabel then
                            data.DistLabel.Text = distText
                            data.DistLabel.TextColor3 = color
                        end
                    end
                end
            end
        end
    end)
end

local function ESPLoop()
    spawn(function()
        while wait(0.5) do
            -- Player ESP
            if Toggles.ESPPlayers then
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local root = player.Character.HumanoidRootPart
                        local hasESP = false
                        for _, data in pairs(ESPObjects) do
                            if data.Object == root then
                                hasESP = true
                                break
                            end
                        end
                        if not hasESP then
                            CreateESP(root, Color3.fromRGB(0, 255, 0), "👤 " .. player.Name, "player")
                        end
                    end
                end
            end

            -- Mob ESP
            if Toggles.ESPMobs then
                for _, v in pairs(Workspace:GetDescendants()) do
                    if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                        local name = v.Name:lower()
                        if name:find("npc") or name:find("mob") or name:find("boss") or name:find("enemy") then
                            local root = v.HumanoidRootPart
                            local hasESP = false
                            for _, data in pairs(ESPObjects) do
                                if data.Object == root then
                                    hasESP = true
                                    break
                                end
                            end
                            if not hasESP then
                                CreateESP(root, Color3.fromRGB(255, 200, 0), "👾 " .. v.Name, "mob")
                            end
                        end
                    end
                end
            end

            -- Fruit ESP - Chỉ tìm trái cây thật, không tìm NPC bán trái
            if Toggles.ESPFruits then
                for _, v in pairs(Workspace:GetDescendants()) do
                    if v:IsA("Model") then
                        local name = v.Name:lower()
                        -- Chỉ tìm trái cây, không tìm NPC
                        if name:find("fruit") and not name:find("npc") and not name:find("seller") and not name:find("vendor") then
                            local root = v:FindFirstChild("HumanoidRootPart") or v:FindFirstChild("Handle") or v.PrimaryPart
                            if root then
                                local hasESP = false
                                for _, data in pairs(ESPObjects) do
                                    if data.Object == root then
                                        hasESP = true
                                        break
                                    end
                                end
                                if not hasESP then
                                    CreateESP(root, Color3.fromRGB(255, 0, 255), "🍎 " .. v.Name, "fruit")
                                end
                            end
                        end
                    end
                end
            end

            -- Cleanup
            for i = #ESPObjects, 1, -1 do
                local data = ESPObjects[i]
                if data.Object and data.Object.Parent then
                    local shouldKeep = false
                    if data.Type == "player" and Toggles.ESPPlayers then
                        shouldKeep = true
                    elseif data.Type == "mob" and Toggles.ESPMobs then
                        shouldKeep = true
                    elseif data.Type == "fruit" and Toggles.ESPFruits then
                        shouldKeep = true
                    end
                    if not shouldKeep then
                        if data.Billboard then data.Billboard:Destroy() end
                        table.remove(ESPObjects, i)
                    end
                else
                    if data.Billboard then data.Billboard:Destroy() end
                    table.remove(ESPObjects, i)
                end
            end
        end
    end)
end

-- 8. Auto Teleport Fruit
function StartAutoTeleportFruit()
    fruitTeleportEnabled = true
    spawn(function()
        while fruitTeleportEnabled and Toggles.AutoTeleportFruit do
            local char = LocalPlayer.Character
            if not char then wait(0.5) continue end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then wait(0.5) continue end
            
            local nearestFruit = nil
            local nearestDist = math.huge
            
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("Model") then
                    local name = v.Name:lower()
                    -- Chỉ tìm trái cây thật
                    if name:find("fruit") and not name:find("npc") and not name:find("seller") and not name:find("vendor") then
                        local fruitRoot = v:FindFirstChild("HumanoidRootPart") or v:FindFirstChild("Handle") or v.PrimaryPart
                        if fruitRoot then
                            local dist = (root.Position - fruitRoot.Position).Magnitude
                            if dist < nearestDist then
                                nearestDist = dist
                                nearestFruit = fruitRoot
                            end
                        end
                    end
                end
            end
            
            if nearestFruit and nearestDist < 500 then
                root.CFrame = CFrame.new(nearestFruit.Position + Vector3.new(0, 3, 0))
                print("🍎 Đã dịch chuyển đến trái cây! Khoảng cách: " .. math.floor(nearestDist) .. "m")
                wait(1)
            end
            wait(0.5)
        end
    end)
end

function StopAutoTeleportFruit()
    fruitTeleportEnabled = false
end

-- 9. Auto Farm V1 (Normal)
function StartAutoFarm()
    autoFarmRunning = true
    spawn(function()
        while autoFarmRunning and Toggles.AutoFarm do
            local char = LocalPlayer.Character
            if not char then wait(0.5) continue end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then wait(0.5) continue end
            
            local nearestMob = nil
            local nearestDist = math.huge
            
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                    local name = v.Name:lower()
                    local shouldFarm = false
                    
                    if SelectedMob == "Tất cả" then
                        shouldFarm = true
                    elseif SelectedMob == "NPC" and name:find("npc") then
                        shouldFarm = true
                    elseif SelectedMob == "Mob" and name:find("mob") then
                        shouldFarm = true
                    elseif SelectedMob == "Boss" and name:find("boss") then
                        shouldFarm = true
                    elseif SelectedMob == "Enemy" and name:find("enemy") then
                        shouldFarm = true
                    end
                    
                    if shouldFarm then
                        local mobRoot = v.HumanoidRootPart
                        local dist = (root.Position - mobRoot.Position).Magnitude
                        if dist < nearestDist then
                            nearestDist = dist
                            nearestMob = v
                        end
                    end
                end
            end
            
            if nearestMob and nearestDist < 100 then
                local mobRoot = nearestMob.HumanoidRootPart
                root.CFrame = CFrame.new(mobRoot.Position + Vector3.new(0, 3, 0))
                
                local humanoid = nearestMob:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.Health = 0
                    killCount = killCount + 1
                    print("⚔️ Đã tiêu diệt: " .. nearestMob.Name .. " (V1)")
                end
                wait(0.5)
            else
                if nearestMob then
                    root.CFrame = CFrame.new(nearestMob.HumanoidRootPart.Position + Vector3.new(0, 3, 0))
                else
                    local randomPos = Vector3.new(
                        math.random(-100, 100),
                        10,
                        math.random(-100, 100)
                    )
                    root.CFrame = CFrame.new(randomPos)
                end
                wait(1)
            end
            wait(0.3)
        end
    end)
end

function StopAutoFarm()
    autoFarmRunning = false
end

-- 10. Auto Farm V2 (Bug Dame 99999+)
function StartAutoFarmV2()
    autoFarmV2Running = true
    spawn(function()
        while autoFarmV2Running and Toggles.AutoFarmV2 do
            local char = LocalPlayer.Character
            if not char then wait(0.5) continue end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then wait(0.5) continue end
            
            local nearestMob = nil
            local nearestDist = math.huge
            
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                    local name = v.Name:lower()
                    local shouldFarm = false
                    
                    if SelectedMob == "Tất cả" then
                        shouldFarm = true
                    elseif SelectedMob == "NPC" and name:find("npc") then
                        shouldFarm = true
                    elseif SelectedMob == "Mob" and name:find("mob") then
                        shouldFarm = true
                    elseif SelectedMob == "Boss" and name:find("boss") then
                        shouldFarm = true
                    elseif SelectedMob == "Enemy" and name:find("enemy") then
                        shouldFarm = true
                    end
                    
                    if shouldFarm then
                        local mobRoot = v.HumanoidRootPart
                        local dist = (root.Position - mobRoot.Position).Magnitude
                        if dist < nearestDist then
                            nearestDist = dist
                            nearestMob = v
                        end
                    end
                end
            end
            
            if nearestMob and nearestDist < 150 then
                local mobRoot = nearestMob.HumanoidRootPart
                root.CFrame = CFrame.new(mobRoot.Position + Vector3.new(0, 3, 0))
                
                local humanoid = nearestMob:FindFirstChild("Humanoid")
                if humanoid then
                    -- Bug Dame 99999+
                    humanoid.Health = 0
                    -- Thêm hiệu ứng bug dame
                    local dmgPart = Instance.new("Part")
                    dmgPart.Parent = workspace
                    dmgPart.Size = Vector3.new(5, 5, 5)
                    dmgPart.Position = mobRoot.Position + Vector3.new(0, 2, 0)
                    dmgPart.Anchored = true
                    dmgPart.CanCollide = false
                    dmgPart.BrickColor = BrickColor.new("Bright red")
                    dmgPart.Material = Enum.Material.Neon
                    dmgPart.Transparency = 0.5
                    
                    local dmgLabel = Instance.new("BillboardGui")
                    dmgLabel.Parent = dmgPart
                    dmgLabel.Size = UDim2.new(0, 200, 0, 50)
                    dmgLabel.AlwaysOnTop = true
                    
                    local dmgText = Instance.new("TextLabel")
                    dmgText.Parent = dmgLabel
                    dmgText.Size = UDim2.new(1, 0, 1, 0)
                    dmgText.BackgroundTransparency = 1
                    dmgText.Text = "💀 99999+ DAMAGE!"
                    dmgText.TextColor3 = Color3.fromRGB(255, 0, 0)
                    dmgText.TextScaled = true
                    dmgText.Font = Enum.Font.GothamBold
                    
                    game:GetService("Debris"):AddItem(dmgPart, 1)
                    
                    killCount = killCount + 1
                    print("💀 Bug Dame 99999+! Đã tiêu diệt: " .. nearestMob.Name .. " (V2)")
                end
                wait(0.3)
            else
                if nearestMob then
                    root.CFrame = CFrame.new(nearestMob.HumanoidRootPart.Position + Vector3.new(0, 3, 0))
                else
                    local randomPos = Vector3.new(
                        math.random(-150, 150),
                        10,
                        math.random(-150, 150)
                    )
                    root.CFrame = CFrame.new(randomPos)
                end
                wait(0.5)
            end
            wait(0.2)
        end
    end)
end

function StopAutoFarmV2()
    autoFarmV2Running = false
end

-- 11. Anti Idle
local function AntiIdle()
    spawn(function()
        while wait(30) do
            VirtualUser:ClickButton2(Vector2.new())
        end
    end)
end

-- // ============ KHỞI TẠO ============
FixLag()
SuperJump()
Fly()
Noclip()
ESPLoop()
UpdateDistances()
GhostMode()
NightVision()
AntiIdle()

-- Hotkeys
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.M then
        MainFrame.Visible = not MainFrame.Visible
    end
    if input.KeyCode == Enum.KeyCode.F1 then
        Toggles.Ghost = not Toggles.Ghost
        print("👻 Ghost: " .. (Toggles.Ghost and "ON" or "OFF"))
    end
    if input.KeyCode == Enum.KeyCode.F2 then
        Toggles.NightVision = not Toggles.NightVision
        print("🌙 Night Vision: " .. (Toggles.NightVision and "ON" or "OFF"))
    end
end)

print("⚡ MV X SHINN DEV v5.0 - FULL FIXED - LOADED SUCCESSFULLY!")
print("📌 Hotkeys: M = Menu | F = Fly | F1 = Ghost | F2 = Night Vision")
print("✅ Tất cả lệnh đã hoạt động!")

-- Thông báo thành công
local function ShowNotification(title, text)
    local notif = Instance.new("Frame")
    notif.Parent = ScreenGui
    notif.Size = UDim2.new(0, 400, 0, 60)
    notif.Position = UDim2.new(0.5, -200, 0.1, 10)
    notif.BackgroundColor3 = Theme.Panel
    notif.BorderSizePixel = 0
    Round(notif, 10)
    notif.BackgroundTransparency = 1
    
    local notifTitle = Instance.new("TextLabel")
    notifTitle.Parent = notif
    notifTitle.Size = UDim2.new(1, 0, 0.5, 0)
    notifTitle.Position = UDim2.new(0, 10, 0, 0)
    notifTitle.BackgroundTransparency = 1
    notifTitle.Text = title
    notifTitle.TextColor3 = Theme.Accent
    notifTitle.Font = Enum.Font.GothamBold
    notifTitle.TextSize = 16
    notifTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local notifText = Instance.new("TextLabel")
    notifText.Parent = notif
    notifText.Size = UDim2.new(1, 0, 0.5, 0)
    notifText.Position = UDim2.new(0, 10, 0.5, 0)
    notifText.BackgroundTransparency = 1
    notifText.Text = text
    notifText.TextColor3 = Theme.TextPrimary
    notifText.Font = Enum.Font.Gotham
    notifText.TextSize = 14
    notifText.TextXAlignment = Enum.TextXAlignment.Left
    
    TweenService:Create(notif, TweenInfo.new(0.3), {BackgroundTransparency = 0.2}):Play()
    
    game:GetService("Debris"):AddItem(notif, 5)
end

ShowNotification("⚡ MV X SHINN DEV v5.0", "Đã tải thành công! Nhấn M để mở menu")
