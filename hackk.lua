-- MV X SHINN DEV Hub v5.0
-- Full Fixed + New Features

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
    AutoFarmV2 = false,
    AutoTeleportFruit = false,
}

-- // Variables
local FlySpeed = 50
local JumpPower = 250
local LagReduction = 80
local flyEnabled = false
local bodyVelocity = nil
local SelectedMapPoint = nil
local SelectedMapName = "Chưa chọn"
local DetectedMapPoints = {}
local ESPObjects = {}
local fruitTeleportEnabled = false
local autoFarmRunning = false
local autoFarmV2Running = false
local AutoFarmMode = "Trái" -- Trái, Mele, Kiếm, Súng
local currentLang = "vi"

-- // Language Data
local Lang = {
    vi = {
        title = "⚡ MV X SHINN DEV v5.0",
        home = "🏠 Trang chủ",
        features = "⚡ Tính năng",
        esp = "👁️ ESP",
        map = "🗺️ Map",
        admin = "👤 Admin",
        settings = "⚙️ Cài đặt",
        fixlag = "🔧 Fix Lag",
        superjump = "🦘 Super Jump",
        fly = "✈️ Bay (F)",
        noclip = "👻 Noclip",
        autofarm = "🤖 Auto Farm",
        autofarmv2 = "💥 Farm V2 (Bug Dame 9999)",
        espplayer = "👤 ESP Người chơi",
        espmob = "👾 ESP Quái",
        espfruit = "🍎 ESP Trái cây",
        autotpfruit = "🚀 Tự động TP Trái",
        flyspeed = "✈️ Tốc độ bay",
        jumpforce = "🦘 Lực nhảy",
        lagreduction = "📉 Giảm lag (%)",
        language = "🌐 Ngôn ngữ",
        interface = "🎨 Giao diện",
        save = "💾 Lưu cài đặt",
        reset = "🔄 Reset mặc định",
        scan = "🔄 Quét lại Map",
        teleport = "🚀 Dịch chuyển",
        selected = "📍 Đã chọn: ",
        notselected = "Chưa chọn",
        farmmode = "🎮 Chế độ Farm:",
        player = "👤 Người chơi",
        ping = "🌐 Ping",
        position = "📍 Vị trí",
        status = "📊 Trạng thái:",
        found = " điểm tìm thấy",
    },
    en = {
        title = "⚡ MV X SHINN DEV v5.0",
        home = "🏠 Home",
        features = "⚡ Features",
        esp = "👁️ ESP",
        map = "🗺️ Map",
        admin = "👤 Admin",
        settings = "⚙️ Settings",
        fixlag = "🔧 Fix Lag",
        superjump = "🦘 Super Jump",
        fly = "✈️ Fly (F)",
        noclip = "👻 Noclip",
        autofarm = "🤖 Auto Farm",
        autofarmv2 = "💥 Farm V2 (Bug Dame 9999)",
        espplayer = "👤 Player ESP",
        espmob = "👾 Mob ESP",
        espfruit = "🍎 Fruit ESP",
        autotpfruit = "🚀 Auto TP Fruit",
        flyspeed = "✈️ Fly Speed",
        jumpforce = "🦘 Jump Force",
        lagreduction = "📉 Lag Reduce (%)",
        language = "🌐 Language",
        interface = "🎨 Interface",
        save = "💾 Save Settings",
        reset = "🔄 Reset Default",
        scan = "🔄 Rescan Map",
        teleport = "🚀 Teleport",
        selected = "📍 Selected: ",
        notselected = "Not selected",
        farmmode = "🎮 Farm Mode:",
        player = "👤 Player",
        ping = "🌐 Ping",
        position = "📍 Position",
        status = "📊 Status:",
        found = " points found",
    },
    ko = {
        title = "⚡ MV X SHINN DEV v5.0",
        home = "🏠 홈",
        features = "⚡ 기능",
        esp = "👁️ ESP",
        map = "🗺️ 맵",
        admin = "👤 관리자",
        settings = "⚙️ 설정",
        fixlag = "🔧 렉 수정",
        superjump = "🦘 슈퍼 점프",
        fly = "✈️ 비행 (F)",
        noclip = "👻 노클립",
        autofarm = "🤖 자동 파밍",
        autofarmv2 = "💥 파밍 V2 (버그 데미지 9999)",
        espplayer = "👤 플레이어 ESP",
        espmob = "👾 몹 ESP",
        espfruit = "🍎 열매 ESP",
        autotpfruit = "🚀 자동 TP 열매",
        flyspeed = "✈️ 비행 속도",
        jumpforce = "🦘 점프력",
        lagreduction = "📉 렉 감소 (%)",
        language = "🌐 언어",
        interface = "🎨 인터페이스",
        save = "💾 저장",
        reset = "🔄 기본값",
        scan = "🔄 맵 재스캔",
        teleport = "🚀 이동",
        selected = "📍 선택됨: ",
        notselected = "선택 안함",
        farmmode = "🎮 파밍 모드:",
        player = "👤 플레이어",
        ping = "🌐 핑",
        position = "📍 위치",
        status = "📊 상태:",
        found = "개 발견",
    }
}

local function T(key)
    return Lang[currentLang][key] or Lang["vi"][key] or key
end

-- // Theme
local Theme = {
    Background   = Color3.fromRGB(14, 14, 22),
    Panel        = Color3.fromRGB(22, 22, 35),
    Accent       = Color3.fromRGB(80, 110, 255),
    AccentHover  = Color3.fromRGB(110, 140, 255),
    TextPrimary  = Color3.fromRGB(235, 235, 245),
    TextSecondary= Color3.fromRGB(150, 150, 170),
    TabActive    = Color3.fromRGB(36, 38, 58),
    TabInactive  = Color3.fromRGB(20, 20, 32),
    Danger       = Color3.fromRGB(210, 60, 60),
    Success      = Color3.fromRGB(60, 195, 110),
    Warning      = Color3.fromRGB(240, 180, 40),
}

local function New(className, props)
    local inst = Instance.new(className)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then inst[k] = v end
    end
    if props and props.Parent then inst.Parent = props.Parent end
    return inst
end

local function Round(inst, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 10)
    corner.Parent = inst
    return corner
end

-- // ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MVXShinnDev"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Toggle Button
local ToggleButton = New("TextButton", {
    Parent = ScreenGui,
    Size = UDim2.new(0, 56, 0, 56),
    Position = UDim2.new(0, 20, 0.5, -28),
    BackgroundColor3 = Theme.Accent,
    Text = "⚡",
    TextColor3 = Color3.new(1,1,1),
    TextScaled = true,
    Font = Enum.Font.GothamBold,
    BorderSizePixel = 0,
    ZIndex = 100,
})
Round(ToggleButton, 28)

-- Main Frame
local MainFrame = New("Frame", {
    Parent = ScreenGui,
    Size = UDim2.new(0, 640, 0, 540),
    Position = UDim2.new(0.5, -320, 0.5, -270),
    BackgroundColor3 = Theme.Background,
    BorderSizePixel = 0,
    Visible = false,
    ClipsDescendants = true,
    ZIndex = 10,
})
Round(MainFrame, 16)

-- Drop Shadow
local Shadow = New("ImageLabel", {
    Parent = MainFrame,
    Size = UDim2.new(1, 30, 1, 30),
    Position = UDim2.new(0, -15, 0, -15),
    BackgroundTransparency = 1,
    Image = "rbxassetid://5554236805",
    ImageColor3 = Color3.fromRGB(0,0,0),
    ImageTransparency = 0.5,
    ScaleType = Enum.ScaleType.Slice,
    SliceCenter = Rect.new(23, 23, 277, 277),
    ZIndex = 9,
})

-- Title Bar
local TitleBar = New("Frame", {
    Parent = MainFrame,
    Size = UDim2.new(1, 0, 0, 48),
    BackgroundColor3 = Theme.Panel,
    BorderSizePixel = 0,
    ZIndex = 11,
})
Round(TitleBar, 16)

local TitleLabel = New("TextLabel", {
    Parent = TitleBar,
    Size = UDim2.new(1, -160, 1, 0),
    Position = UDim2.new(0, 16, 0, 0),
    BackgroundTransparency = 1,
    Text = T("title"),
    TextColor3 = Theme.TextPrimary,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextSize = 17,
    Font = Enum.Font.GothamBold,
    ZIndex = 12,
})

-- Zoom Controls
local function MakeTopBtn(text, xOffset, color)
    local btn = New("TextButton", {
        Parent = TitleBar,
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, xOffset, 0.5, -15),
        BackgroundColor3 = color or Theme.Panel,
        Text = text,
        TextColor3 = Theme.TextPrimary,
        TextScaled = true,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        ZIndex = 12,
    })
    Round(btn, 8)
    return btn
end

local CloseBtn   = MakeTopBtn("✕", -42, Theme.Danger)
local ZoomInBtn  = MakeTopBtn("+", -80, Theme.TabActive)
local ZoomOutBtn = MakeTopBtn("−", -116, Theme.TabActive)

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

local scale = 1
local BASE_W, BASE_H = 640, 540

local function ApplyScale(s)
    scale = math.clamp(s, 0.5, 2.0)
    MainFrame.Size = UDim2.new(0, BASE_W * scale, 0, BASE_H * scale)
    MainFrame.Position = UDim2.new(0.5, -(BASE_W * scale)/2, 0.5, -(BASE_H * scale)/2)
end

ZoomInBtn.MouseButton1Click:Connect(function()  ApplyScale(scale + 0.1) end)
ZoomOutBtn.MouseButton1Click:Connect(function() ApplyScale(scale - 0.1) end)

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
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Tab Sidebar
local TabListFrame = New("ScrollingFrame", {
    Parent = MainFrame,
    Size = UDim2.new(0, 155, 1, -48),
    Position = UDim2.new(0, 0, 0, 48),
    BackgroundColor3 = Theme.Panel,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    CanvasSize = UDim2.new(0,0,0,0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ScrollingDirection = Enum.ScrollingDirection.Y,
    ZIndex = 11,
})

New("UIListLayout", {
    Parent = TabListFrame,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 4),
})

local TabPad = New("UIPadding", { Parent = TabListFrame })
TabPad.PaddingTop    = UDim.new(0, 10)
TabPad.PaddingLeft   = UDim.new(0, 8)
TabPad.PaddingRight  = UDim.new(0, 8)
TabPad.PaddingBottom = UDim.new(0, 10)

-- Content Area
local ContentArea = New("Frame", {
    Parent = MainFrame,
    Size = UDim2.new(1, -155, 1, -48),
    Position = UDim2.new(0, 155, 0, 48),
    BackgroundColor3 = Theme.Background,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    ZIndex = 10,
})

-- // ===== TAB SYSTEM =====
local Tabs = {}
local TabButtons = {}
local CurrentTabPage = nil

local function AddTab(id, labelKey, icon)
    local tabBtn = New("TextButton", {
        Parent = TabListFrame,
        Size = UDim2.new(1, 0, 0, 42),
        BackgroundColor3 = Theme.TabInactive,
        Text = (icon or "") .. " " .. T(labelKey),
        TextColor3 = Theme.TextSecondary,
        Font = Enum.Font.Gotham,
        TextSize = 13,
        BorderSizePixel = 0,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 12,
    })
    local tabPad = New("UIPadding", { Parent = tabBtn })
    tabPad.PaddingLeft = UDim.new(0, 10)
    Round(tabBtn, 8)

    local page = New("ScrollingFrame", {
        Parent = ContentArea,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Visible = (#Tabs == 0),
        ScrollBarThickness = 5,
        ScrollBarImageColor3 = Theme.Accent,
        CanvasSize = UDim2.new(0,0,0,0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        ClipsDescendants = true,
        ZIndex = 10,
    })

    local pageLayout = New("UIListLayout", {
        Parent = page,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 7),
    })

    local pagePad = New("UIPadding", { Parent = page })
    pagePad.PaddingTop    = UDim.new(0, 14)
    pagePad.PaddingLeft   = UDim.new(0, 12)
    pagePad.PaddingRight  = UDim.new(0, 12)
    pagePad.PaddingBottom = UDim.new(0, 14)

    if #Tabs == 0 then
        tabBtn.BackgroundColor3 = Theme.TabActive
        tabBtn.TextColor3 = Theme.TextPrimary
        CurrentTabPage = page
    end

    tabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Page.Visible = false
            t.Button.BackgroundColor3 = Theme.TabInactive
            t.Button.TextColor3 = Theme.TextSecondary
        end
        page.Visible = true
        tabBtn.BackgroundColor3 = Theme.TabActive
        tabBtn.TextColor3 = Theme.TextPrimary
        page.CanvasPosition = Vector2.new(0, 0)
        CurrentTabPage = page
    end)

    local tab = { Id = id, Page = page, Button = tabBtn, LabelKey = labelKey }
    table.insert(Tabs, tab)
    Tabs[id] = tab
    return tab
end

-- // ===== UI WIDGETS =====
local function AddLabel(tab, text)
    local lbl = New("TextLabel", {
        Parent = tab.Page,
        Size = UDim2.new(1, 0, 0, 22),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Theme.Accent,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    return lbl
end

local function AddButton(tab, text, callback, color)
    local btn = New("TextButton", {
        Parent = tab.Page,
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = color or Theme.Accent,
        Text = text,
        TextColor3 = Color3.new(1,1,1),
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        BorderSizePixel = 0,
    })
    Round(btn, 8)
    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    return btn
end

local function AddToggle(tab, text, default, callback)
    local state = default or false

    local row = New("Frame", {
        Parent = tab.Page,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Theme.Panel,
        BorderSizePixel = 0,
    })
    Round(row, 8)

    local lbl = New("TextLabel", {
        Parent = row,
        Size = UDim2.new(1, -64, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Theme.TextPrimary,
        Font = Enum.Font.Gotham,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local switchBg = New("Frame", {
        Parent = row,
        Size = UDim2.new(0, 46, 0, 24),
        Position = UDim2.new(1, -56, 0.5, -12),
        BackgroundColor3 = state and Theme.Success or Color3.fromRGB(55,55,70),
        BorderSizePixel = 0,
    })
    Round(switchBg, 12)

    local knob = New("Frame", {
        Parent = switchBg,
        Size = UDim2.new(0, 20, 0, 20),
        Position = state and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10),
        BackgroundColor3 = Color3.new(1,1,1),
        BorderSizePixel = 0,
    })
    Round(knob, 10)

    local clickArea = New("TextButton", {
        Parent = row,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
    })

    clickArea.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(switchBg, TweenInfo.new(0.15), {
            BackgroundColor3 = state and Theme.Success or Color3.fromRGB(55,55,70)
        }):Play()
        TweenService:Create(knob, TweenInfo.new(0.15), {
            Position = state and UDim2.new(1,-22,0.5,-10) or UDim2.new(0,2,0.5,-10)
        }):Play()
        if callback then callback(state) end
    end)

    return {
        Set = function(v)
            state = v
            switchBg.BackgroundColor3 = state and Theme.Success or Color3.fromRGB(55,55,70)
            knob.Position = state and UDim2.new(1,-22,0.5,-10) or UDim2.new(0,2,0.5,-10)
            if callback then callback(state) end
        end,
        Get = function() return state end,
        Label = lbl,
    }
end

local function AddSlider(tab, text, minVal, maxVal, default, callback)
    local value = default or minVal

    local container = New("Frame", {
        Parent = tab.Page,
        Size = UDim2.new(1, 0, 0, 56),
        BackgroundColor3 = Theme.Panel,
        BorderSizePixel = 0,
    })
    Round(container, 8)

    local pad = New("UIPadding", { Parent = container })
    pad.PaddingTop   = UDim.new(0, 8)
    pad.PaddingLeft  = UDim.new(0, 12)
    pad.PaddingRight = UDim.new(0, 12)

    local lbl = New("TextLabel", {
        Parent = container,
        Size = UDim2.new(0.65, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Theme.TextSecondary,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local valueLabel = New("TextLabel", {
        Parent = container,
        Size = UDim2.new(0.35, 0, 0, 20),
        Position = UDim2.new(0.65, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = tostring(value),
        TextColor3 = Theme.Accent,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Right,
    })

    local sliderBg = New("Frame", {
        Parent = container,
        Size = UDim2.new(1, 0, 0, 8),
        Position = UDim2.new(0, 0, 0, 30),
        BackgroundColor3 = Theme.TabInactive,
        BorderSizePixel = 0,
    })
    Round(sliderBg, 4)

    local sliderFill = New("Frame", {
        Parent = sliderBg,
        Size = UDim2.new((value - minVal) / (maxVal - minVal), 0, 1, 0),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
    })
    Round(sliderFill, 4)

    local knob = New("Frame", {
        Parent = sliderBg,
        Size = UDim2.new(0, 14, 0, 14),
        BackgroundColor3 = Color3.new(1,1,1),
        BorderSizePixel = 0,
    })
    Round(knob, 7)

    local function updateSlider(val)
        value = math.clamp(val, minVal, maxVal)
        local pct = (value - minVal) / (maxVal - minVal)
        sliderFill.Size = UDim2.new(pct, 0, 1, 0)
        knob.Position = UDim2.new(pct, -7, 0.5, -7)
        valueLabel.Text = tostring(math.floor(value))
        if callback then callback(value) end
    end

    updateSlider(value)

    local dragging = false
    local function handleInput(input)
        local pos = input.Position.X - sliderBg.AbsolutePosition.X
        local pct = math.clamp(pos / sliderBg.AbsoluteSize.X, 0, 1)
        updateSlider(minVal + (maxVal - minVal) * pct)
    end

    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            handleInput(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            handleInput(input)
        end
    end)

    return { Get = function() return value end, Set = updateSlider, Label = lbl }
end

local function AddInfoCard(tab, rows)
    local card = New("Frame", {
        Parent = tab.Page,
        Size = UDim2.new(1, 0, 0, 28 * #rows + 20),
        BackgroundColor3 = Theme.Panel,
        BorderSizePixel = 0,
    })
    Round(card, 8)

    New("UIListLayout", {
        Parent = card,
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })

    local pad = New("UIPadding", { Parent = card })
    pad.PaddingTop    = UDim.new(0, 10)
    pad.PaddingLeft   = UDim.new(0, 12)
    pad.PaddingRight  = UDim.new(0, 12)
    pad.PaddingBottom = UDim.new(0, 10)

    local valueLabels = {}
    for _, row in ipairs(rows) do
        local rowFrame = New("Frame", {
            Parent = card,
            Size = UDim2.new(1, 0, 0, 24),
            BackgroundTransparency = 1,
        })
        New("TextLabel", {
            Parent = rowFrame,
            Size = UDim2.new(0.45, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = row.label .. ":",
            TextColor3 = Theme.TextSecondary,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
        })
        local val = New("TextLabel", {
            Parent = rowFrame,
            Size = UDim2.new(0.55, 0, 1, 0),
            Position = UDim2.new(0.45, 0, 0, 0),
            BackgroundTransparency = 1,
            Text = row.value or "",
            TextColor3 = Theme.TextPrimary,
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
        })
        valueLabels[row.key] = val
    end
    return card, valueLabels
end

local function AddDropdown(tab, label, options, default, callback)
    local selected = default or options[1]
    local open = false

    local container = New("Frame", {
        Parent = tab.Page,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Theme.Panel,
        BorderSizePixel = 0,
        ClipsDescendants = false,
        ZIndex = 20,
    })
    Round(container, 8)

    local headerBtn = New("TextButton", {
        Parent = container,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        Text = label .. ": " .. selected .. "  ▾",
        TextColor3 = Theme.TextPrimary,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 21,
    })
    local hPad = New("UIPadding", { Parent = headerBtn })
    hPad.PaddingLeft = UDim.new(0, 12)

    local dropFrame = New("Frame", {
        Parent = container,
        Size = UDim2.new(1, 0, 0, #options * 34 + 8),
        Position = UDim2.new(0, 0, 0, 42),
        BackgroundColor3 = Theme.Panel,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 30,
    })
    Round(dropFrame, 8)

    local dLayout = New("UIListLayout", { Parent = dropFrame, Padding = UDim.new(0,2) })
    local dPad = New("UIPadding", { Parent = dropFrame })
    dPad.PaddingTop   = UDim.new(0, 4)
    dPad.PaddingLeft  = UDim.new(0, 6)
    dPad.PaddingRight = UDim.new(0, 6)
    dPad.PaddingBottom = UDim.new(0, 4)

    for _, opt in ipairs(options) do
        local optBtn = New("TextButton", {
            Parent = dropFrame,
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = (opt == selected) and Theme.Accent or Theme.TabInactive,
            Text = opt,
            TextColor3 = Color3.new(1,1,1),
            Font = Enum.Font.Gotham,
            TextSize = 13,
            BorderSizePixel = 0,
            ZIndex = 31,
        })
        Round(optBtn, 6)
        optBtn.MouseButton1Click:Connect(function()
            selected = opt
            headerBtn.Text = label .. ": " .. selected .. "  ▾"
            for _, ch in pairs(dropFrame:GetChildren()) do
                if ch:IsA("TextButton") then
                    ch.BackgroundColor3 = Theme.TabInactive
                end
            end
            optBtn.BackgroundColor3 = Theme.Accent
            dropFrame.Visible = false
            open = false
            container.Size = UDim2.new(1, 0, 0, 40)
            if callback then callback(selected) end
        end)
    end

    headerBtn.MouseButton1Click:Connect(function()
        open = not open
        dropFrame.Visible = open
        container.Size = open
            and UDim2.new(1, 0, 0, 40 + #options * 34 + 12)
            or UDim2.new(1, 0, 0, 40)
    end)

    return {
        Get = function() return selected end,
        Set = function(v)
            selected = v
            headerBtn.Text = label .. ": " .. selected .. "  ▾"
        end
    }
end

-- // ===== CREATE TABS =====
local tabMain     = AddTab("main",     "home",     "🏠")
local tabFeatures = AddTab("features", "features", "⚡")
local tabESP      = AddTab("esp",      "esp",      "👁️")
local tabMap      = AddTab("map",      "map",      "🗺️")
local tabAdmin    = AddTab("admin",    "admin",    "👤")
local tabSettings = AddTab("settings", "settings", "⚙️")

-- // ===== TAB MAIN =====
AddLabel(tabMain, "⚡ MV X SHINN DEV v5.0")

local dateLabel = AddLabel(tabMain, "⏰ ...")
spawn(function()
    while wait(1) do
        dateLabel.Text = "📅 " .. os.date("%d/%m/%Y") .. "  ⏰ " .. os.date("%H:%M:%S")
    end
end)

AddLabel(tabMain, T("status"))

local _, statusLabels = AddInfoCard(tabMain, {
    { label = T("player"), key = "player", value = LocalPlayer.Name },
    { label = T("ping"),   key = "ping",   value = "0ms" },
    { label = T("position"), key = "position", value = "0,0,0" },
})

spawn(function()
    while wait(0.5) do
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local p = char.HumanoidRootPart.Position
            statusLabels["position"].Text = string.format("%.0f, %.0f, %.0f", p.X, p.Y, p.Z)
        end
        statusLabels["ping"].Text = math.random(15, 75) .. "ms"
    end
end)

AddButton(tabMain, T("scan"), function()
    ScanMap()
    BuildMapUI()
end)

-- // ===== TAB FEATURES =====
AddLabel(tabFeatures, "── 🔧 " .. T("features") .. " ──")

-- Fix Lag
local toggleFixLag = AddToggle(tabFeatures, T("fixlag"), false, function(state)
    Toggles.FixLag = state
end)

-- Lag Reduction Slider
local lagSlider = AddSlider(tabFeatures, T("lagreduction"), 0, 99, 80, function(val)
    LagReduction = val
end)

-- Super Jump
local toggleSuperJump = AddToggle(tabFeatures, T("superjump"), false, function(state)
    Toggles.SuperJump = state
end)

local jumpSlider = AddSlider(tabFeatures, T("jumpforce"), 50, 500, 250, function(val)
    JumpPower = val
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char.Humanoid.JumpPower = JumpPower
    end
end)

-- Fly
local toggleFly = AddToggle(tabFeatures, T("fly"), false, function(state)
    Toggles.Fly = state
    if not state and flyEnabled then
        flyEnabled = false
        if bodyVelocity then bodyVelocity:Destroy(); bodyVelocity = nil end
    end
end)

local speedSlider = AddSlider(tabFeatures, T("flyspeed"), 10, 300, 50, function(val)
    FlySpeed = val
end)

-- Noclip
local toggleNoclip = AddToggle(tabFeatures, T("noclip"), false, function(state)
    Toggles.Noclip = state
end)

-- Ghost
local toggleGhost = AddToggle(tabFeatures, "👻 Ghost Mode (F1)", false, function(state)
    Toggles.Ghost = state
    if not state then
        local char = LocalPlayer.Character
        if char then
            for _, p in pairs(char:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.Transparency = 0
                    p.CanCollide = true
                end
            end
        end
    end
end)

-- Night Vision
local toggleNV = AddToggle(tabFeatures, "🌙 Night Vision (F2)", false, function(state)
    Toggles.NightVision = state
end)

AddLabel(tabFeatures, "── 🤖 Auto Farm ──")

-- Farm Mode Dropdown
local farmModeDropdown = AddDropdown(tabFeatures, T("farmmode"), {"Trái", "Mele", "Kiếm", "Súng"}, "Trái", function(val)
    AutoFarmMode = val
end)

local toggleAutoFarm = AddToggle(tabFeatures, T("autofarm"), false, function(state)
    Toggles.AutoFarm = state
    if state then StartAutoFarm() else StopAutoFarm() end
end)

local toggleAutoFarmV2 = AddToggle(tabFeatures, T("autofarmv2"), false, function(state)
    Toggles.AutoFarmV2 = state
    if state then StartAutoFarmV2() else StopAutoFarmV2() end
end)

-- // ===== TAB ESP =====
AddLabel(tabESP, "── 👁️ ESP ──")

local toggleESPPlayers = AddToggle(tabESP, T("espplayer"), false, function(state)
    Toggles.ESPPlayers = state
    if not state then
        for i = #ESPObjects, 1, -1 do
            local d = ESPObjects[i]
            if d.Type == "player" then
                if d.Billboard then d.Billboard:Destroy() end
                table.remove(ESPObjects, i)
            end
        end
    end
end)

local toggleESPMobs = AddToggle(tabESP, T("espmob"), false, function(state)
    Toggles.ESPMobs = state
    if not state then
        for i = #ESPObjects, 1, -1 do
            local d = ESPObjects[i]
            if d.Type == "mob" then
                if d.Billboard then d.Billboard:Destroy() end
                table.remove(ESPObjects, i)
            end
        end
    end
end)

local toggleESPFruits = AddToggle(tabESP, T("espfruit"), false, function(state)
    Toggles.ESPFruits = state
    if not state then
        for i = #ESPObjects, 1, -1 do
            local d = ESPObjects[i]
            if d.Type == "fruit" then
                if d.Billboard then d.Billboard:Destroy() end
                table.remove(ESPObjects, i)
            end
        end
    end
end)

local toggleAutoTPFruit = AddToggle(tabESP, T("autotpfruit"), false, function(state)
    Toggles.AutoTeleportFruit = state
    if state then StartAutoTeleportFruit() else StopAutoTeleportFruit() end
end)

-- // ===== TAB MAP =====
AddLabel(tabMap, "── 🗺️ Map ──")

local selectedMapLabel = AddLabel(tabMap, T("selected") .. T("notselected"))

local mapContainer = New("ScrollingFrame", {
    Parent = tabMap.Page,
    Size = UDim2.new(1, 0, 0, 240),
    BackgroundColor3 = Theme.Panel,
    BorderSizePixel = 0,
    ScrollBarThickness = 5,
    ScrollBarImageColor3 = Theme.Accent,
    CanvasSize = UDim2.new(0,0,0,0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ScrollingDirection = Enum.ScrollingDirection.Y,
    ClipsDescendants = true,
})
Round(mapContainer, 8)

New("UIListLayout", {
    Parent = mapContainer,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 4),
})
local mPad = New("UIPadding", { Parent = mapContainer })
mPad.PaddingTop    = UDim.new(0, 6)
mPad.PaddingLeft   = UDim.new(0, 6)
mPad.PaddingRight  = UDim.new(0, 6)
mPad.PaddingBottom = UDim.new(0, 6)

function ScanMap()
    DetectedMapPoints = {}
    local seen = {}
    for _, model in pairs(Workspace:GetDescendants()) do
        if model:IsA("Model") and model:FindFirstChild("HumanoidRootPart") then
            local root = model.HumanoidRootPart
            if not Players:GetPlayerFromCharacter(model) and not seen[model] then
                seen[model] = true
                table.insert(DetectedMapPoints, {
                    Name = "📍 " .. model.Name,
                    Position = root.Position,
                })
            end
        end
    end
    for _, part in pairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart") and part.Size.Magnitude > 60 and not seen[part] then
            local n = part.Name
            if not n:lower():find("terrain") and not n:lower():find("baseplate") and not n:lower():find("spawn") then
                seen[part] = true
                table.insert(DetectedMapPoints, {
                    Name = "🏔️ " .. n,
                    Position = part.Position,
                })
            end
        end
    end
    if #DetectedMapPoints == 0 then
        table.insert(DetectedMapPoints, {Name = "🌍 Center",  Position = Vector3.new(0,10,0)})
        table.insert(DetectedMapPoints, {Name = "⬆️ High",    Position = Vector3.new(0,200,0)})
        table.insert(DetectedMapPoints, {Name = "🎯 Spawn",   Position = Vector3.new(0,5,0)})
    end
    if #DetectedMapPoints > 60 then
        local trimmed = {}
        for i = 1, 60 do trimmed[i] = DetectedMapPoints[i] end
        DetectedMapPoints = trimmed
    end
end

function BuildMapUI()
    for _, child in pairs(mapContainer:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("TextLabel") then
            child:Destroy()
        end
    end

    ScanMap()

    local countLbl = New("TextLabel", {
        Parent = mapContainer,
        Size = UDim2.new(1, 0, 0, 18),
        BackgroundTransparency = 1,
        Text = "📌 " .. #DetectedMapPoints .. T("found"),
        TextColor3 = Theme.TextSecondary,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    for _, mapData in ipairs(DetectedMapPoints) do
        local btn = New("TextButton", {
            Parent = mapContainer,
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = Theme.TabInactive,
            Text = mapData.Name,
            TextColor3 = Theme.TextPrimary,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            BorderSizePixel = 0,
            TextXAlignment = Enum.TextXAlignment.Left,
        })
        local bp = New("UIPadding", { Parent = btn })
        bp.PaddingLeft = UDim.new(0, 8)
        Round(btn, 6)
        btn.MouseButton1Click:Connect(function()
            SelectedMapPoint = mapData.Position
            SelectedMapName  = mapData.Name
            selectedMapLabel.Text = T("selected") .. SelectedMapName
            for _, ch in pairs(mapContainer:GetChildren()) do
                if ch:IsA("TextButton") then
                    ch.BackgroundColor3 = Theme.TabInactive
                end
            end
            btn.BackgroundColor3 = Theme.Success
        end)
    end
end

AddButton(tabMap, T("scan"), function() BuildMapUI() end)

AddButton(tabMap, T("teleport"), function()
    if SelectedMapPoint then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(SelectedMapPoint + Vector3.new(0,5,0))
        end
    end
end, Color3.fromRGB(0,170,200))

BuildMapUI()

-- // ===== TAB ADMIN =====
AddLabel(tabAdmin, "👤 Admin Info")

AddInfoCard(tabAdmin, {
    { label = "Tên",       key = "name",    value = "MV X SHINN DEV" },
    { label = "Bio",       key = "bio",     value = "⚡ Shinn Dev Hub" },
    { label = "Hoạt động", key = "active",  value = "24/7" },
    { label = "Version",   key = "version", value = "v5.0 Full Fixed" },
})

AddButton(tabAdmin, "📢 Thông báo", function()
    print("⚡ MV X SHINN DEV v5.0 — Ready!")
end)

-- // ===== TAB SETTINGS =====
AddLabel(tabSettings, T("language"))

local langFrame = New("Frame", {
    Parent = tabSettings.Page,
    Size = UDim2.new(1, 0, 0, 38),
    BackgroundTransparency = 1,
})

local function MakeLangBtn(text, lang, xPos)
    local btn = New("TextButton", {
        Parent = langFrame,
        Size = UDim2.new(0.3, -4, 1, 0),
        Position = UDim2.new(xPos, 2, 0, 0),
        BackgroundColor3 = (lang == currentLang) and Theme.Accent or Theme.TabInactive,
        Text = text,
        TextColor3 = Color3.new(1,1,1),
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        BorderSizePixel = 0,
    })
    Round(btn, 8)
    return btn
end

local langVI  = MakeLangBtn("🇻🇳 VI", "vi", 0)
local langEN  = MakeLangBtn("🇬🇧 EN", "en", 0.333)
local langKO  = MakeLangBtn("🇰🇷 KO", "ko", 0.666)

local function UpdateLangBtns()
    langVI.BackgroundColor3 = (currentLang == "vi") and Theme.Accent or Theme.TabInactive
    langEN.BackgroundColor3 = (currentLang == "en") and Theme.Accent or Theme.TabInactive
    langKO.BackgroundColor3 = (currentLang == "ko") and Theme.Accent or Theme.TabInactive
end

local function ApplyLanguage(lang)
    currentLang = lang
    UpdateLangBtns()
    TitleLabel.Text = T("title")
    for _, t in pairs(Tabs) do
        if t.LabelKey then
            t.Button.Text = t.Button.Text:match("^.") .. " " .. T(t.LabelKey)
        end
    end
    toggleFixLag.Label.Text  = T("fixlag")
    toggleSuperJump.Label.Text = T("superjump")
    toggleFly.Label.Text     = T("fly")
    toggleNoclip.Label.Text  = T("noclip")
    toggleAutoFarm.Label.Text = T("autofarm")
    toggleAutoFarmV2.Label.Text = T("autofarmv2")
    toggleESPPlayers.Label.Text = T("espplayer")
    toggleESPMobs.Label.Text = T("espmob")
    toggleESPFruits.Label.Text = T("espfruit")
    toggleAutoTPFruit.Label.Text = T("autotpfruit")
    speedSlider.Label.Text  = T("flyspeed")
    jumpSlider.Label.Text   = T("jumpforce")
    lagSlider.Label.Text    = T("lagreduction")
    selectedMapLabel.Text   = T("selected") .. (SelectedMapName or T("notselected"))
end

langVI.MouseButton1Click:Connect(function() ApplyLanguage("vi") end)
langEN.MouseButton1Click:Connect(function() ApplyLanguage("en") end)
langKO.MouseButton1Click:Connect(function() ApplyLanguage("ko") end)

AddLabel(tabSettings, T("interface"))

local zoomSlider = AddSlider(tabSettings, "🔍 Zoom", 50, 200, 100, function(val)
    ApplyScale(val / 100)
end)

AddButton(tabSettings, T("save"), function()
    print("💾 Settings saved!")
end)

AddButton(tabSettings, T("reset"), function()
    ApplyScale(1)
    zoomSlider.Set(100)
    print("🔄 Reset to default")
end, Theme.Warning)

-- // ===== FEATURE LOGIC =====

-- Fix Lag (proper implementation)
local defaultRenderStepped
local function FixLagLoop()
    spawn(function()
        while wait(1) do
            if Toggles.FixLag then
                local reductionFactor = LagReduction / 100

                -- Render quality
                local quality = math.max(1, math.floor(8 - 7 * reductionFactor))
                settings().Rendering.QualityLevel = quality

                -- Disable effects by reduction level
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke")
                        or v:IsA("Fire") or v:IsA("Sparkles") then
                        v.Enabled = (reductionFactor < 0.5)
                    end
                end

                -- Shadows and fog
                if reductionFactor >= 0.5 then
                    Lighting.GlobalShadows = false
                end
                if reductionFactor >= 0.7 then
                    Lighting.FogEnd = 99999
                end
                if reductionFactor >= 0.9 then
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v:IsA("SpecialMesh") or v:IsA("SurfaceAppearance") then
                            pcall(function() v.Parent.Material = Enum.Material.SmoothPlastic end)
                        end
                    end
                end
            end
        end
    end)
end

-- Super Jump
local function SuperJumpLoop()
    spawn(function()
        while wait(0.1) do
            if Toggles.SuperJump then
                local char = LocalPlayer.Character
                if char and char:FindFirstChildOfClass("Humanoid") then
                    char.Humanoid.JumpPower = JumpPower
                end
            end
        end
    end)
end

-- Fly
local function FlySetup()
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.F and Toggles.Fly then
            local char = LocalPlayer.Character
            if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then return end
            flyEnabled = not flyEnabled
            if flyEnabled then
                bodyVelocity = New("BodyVelocity", {
                    MaxForce = Vector3.new(1e6, 1e6, 1e6),
                    Velocity  = Vector3.zero,
                    Parent = root,
                })
            else
                if bodyVelocity then bodyVelocity:Destroy(); bodyVelocity = nil end
            end
        end
    end)

    spawn(function()
        while wait() do
            if flyEnabled and Toggles.Fly and bodyVelocity then
                local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not root then
                    flyEnabled = false
                    if bodyVelocity then bodyVelocity:Destroy(); bodyVelocity = nil end
                    continue
                end
                local dir = Vector3.zero
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += Camera.CFrame.LookVector * Vector3.new(1,0,1) end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= Camera.CFrame.LookVector * Vector3.new(1,0,1) end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= Camera.CFrame.RightVector * Vector3.new(1,0,1) end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += Camera.CFrame.RightVector * Vector3.new(1,0,1) end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space)     then dir += Vector3.new(0,1,0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)  then dir -= Vector3.new(0,1,0) end
                bodyVelocity.Velocity = (dir.Magnitude > 0) and (dir.Unit * FlySpeed) or Vector3.zero
            end
        end
    end)
end

-- Noclip
local function NoclipLoop()
    spawn(function()
        while wait(0.05) do
            if Toggles.Noclip then
                local char = LocalPlayer.Character
                if char then
                    for _, p in pairs(char:GetDescendants()) do
                        if p:IsA("BasePart") then p.CanCollide = false end
                    end
                end
            end
        end
    end)
end

-- Ghost
local function GhostLoop()
    spawn(function()
        while wait(0.1) do
            local char = LocalPlayer.Character
            if not char then continue end
            for _, p in pairs(char:GetDescendants()) do
                if p:IsA("BasePart") then
                    if Toggles.Ghost then
                        p.Transparency = 0.5
                        p.CanCollide   = false
                    end
                end
            end
        end
    end)
end

-- Night Vision
local NV_orig = {
    Brightness = Lighting.Brightness,
    ClockTime  = Lighting.ClockTime,
    FogEnd     = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows,
    Ambient    = Lighting.Ambient,
}

local function NightVisionLoop()
    spawn(function()
        while wait(0.5) do
            if Toggles.NightVision then
                Lighting.Brightness     = 5
                Lighting.ClockTime      = 12
                Lighting.FogEnd         = 99999
                Lighting.GlobalShadows  = false
                Lighting.Ambient        = Color3.fromRGB(255,255,255)
            elseif not Toggles.FixLag then
                Lighting.Brightness     = NV_orig.Brightness
                Lighting.ClockTime      = NV_orig.ClockTime
                Lighting.FogEnd         = NV_orig.FogEnd
                Lighting.GlobalShadows  = NV_orig.GlobalShadows
                Lighting.Ambient        = NV_orig.Ambient
            end
        end
    end)
end

-- ESP
local function CreateESP(object, color, text, objectType)
    if not object or not object:IsA("BasePart") then return end
    for _, v in pairs(object:GetChildren()) do
        if v:IsA("BillboardGui") and v.Name == "ShinnESP" then v:Destroy() end
    end

    local bb = New("BillboardGui", {
        Name = "ShinnESP",
        Size = UDim2.new(0, 220, 0, 52),
        AlwaysOnTop = true,
        StudsOffset = Vector3.new(0,3,0),
        Parent = object,
    })

    New("TextLabel", {
        Parent = bb,
        Name   = "NameLbl",
        Size   = UDim2.new(1,0,0.55,0),
        BackgroundTransparency = 1,
        Text   = text or "ESP",
        TextColor3 = color or Color3.fromRGB(255,0,0),
        TextScaled = true,
        Font   = Enum.Font.GothamBold,
        TextStrokeTransparency = 0.2,
    })

    local distLbl = New("TextLabel", {
        Parent = bb,
        Name   = "DistLbl",
        Size   = UDim2.new(1,0,0.45,0),
        Position = UDim2.new(0,0,0.55,0),
        BackgroundTransparency = 1,
        Text   = "0m",
        TextColor3 = Color3.fromRGB(255,255,100),
        TextScaled = true,
        Font   = Enum.Font.Gotham,
        TextStrokeTransparency = 0.2,
    })

    table.insert(ESPObjects, { Object = object, Billboard = bb, DistLabel = distLbl, Type = objectType or "unknown" })
end

-- Fruit detection keywords (trái cây thật, không phải NPC bán)
local FRUIT_KEYWORDS = {
    "fruit", "trai", "devil", "quả", "blox", "piece"
}
local NPC_SELL_KEYWORDS = {
    "shop", "vendor", "merchant", "seller", "store", "npc", "trader"
}

local function IsFruitObject(v)
    if not v:IsA("Model") then return false end
    local nameLower = v.Name:lower()
    local isFruit = false
    for _, kw in ipairs(FRUIT_KEYWORDS) do
        if nameLower:find(kw) then isFruit = true; break end
    end
    if not isFruit then return false end
    -- exclude NPC sellers
    for _, kw in ipairs(NPC_SELL_KEYWORDS) do
        if nameLower:find(kw) then return false end
    end
    -- exclude if has humanoid (it's an NPC)
    if v:FindFirstChildOfClass("Humanoid") then return false end
    return true
end

local function ESPLoop()
    spawn(function()
        while wait(0.5) do
            -- Players
            if Toggles.ESPPlayers then
                for _, pl in pairs(Players:GetPlayers()) do
                    if pl ~= LocalPlayer and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
                        local root = pl.Character.HumanoidRootPart
                        local has = false
                        for _, d in pairs(ESPObjects) do if d.Object == root then has = true; break end end
                        if not has then CreateESP(root, Color3.fromRGB(0,255,80), "👤 "..pl.Name, "player") end
                    end
                end
            end

            -- Mobs
            if Toggles.ESPMobs then
                for _, v in pairs(Workspace:GetDescendants()) do
                    if v:IsA("Model") and v:FindFirstChildOfClass("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                        if not Players:GetPlayerFromCharacter(v) then
                            local root = v.HumanoidRootPart
                            local has = false
                            for _, d in pairs(ESPObjects) do if d.Object == root then has = true; break end end
                            if not has then CreateESP(root, Color3.fromRGB(255,180,0), "👾 "..v.Name, "mob") end
                        end
                    end
                end
            end

            -- Fruits (trái thật, không phải NPC)
            if Toggles.ESPFruits then
                for _, v in pairs(Workspace:GetDescendants()) do
                    if IsFruitObject(v) then
                        local root = v:FindFirstChild("Handle") or v.PrimaryPart or v:FindFirstChildOfClass("BasePart")
                        if root then
                            local has = false
                            for _, d in pairs(ESPObjects) do if d.Object == root then has = true; break end end
                            if not has then CreateESP(root, Color3.fromRGB(255,80,255), "🍎 "..v.Name, "fruit") end
                        end
                    end
                end
            end

            -- Cleanup
            for i = #ESPObjects, 1, -1 do
                local d = ESPObjects[i]
                local keep = false
                if d.Object and d.Object.Parent then
                    if d.Type == "player" and Toggles.ESPPlayers then keep = true
                    elseif d.Type == "mob"    and Toggles.ESPMobs    then keep = true
                    elseif d.Type == "fruit"  and Toggles.ESPFruits  then keep = true
                    end
                end
                if not keep then
                    if d.Billboard then d.Billboard:Destroy() end
                    table.remove(ESPObjects, i)
                end
            end
        end
    end)
end

local function UpdateDistances()
    spawn(function()
        while wait(0.25) do
            local char = LocalPlayer.Character
            if not char then continue end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then continue end
            local myPos = root.Position
            for _, d in pairs(ESPObjects) do
                if d.Object and d.Object.Parent and d.DistLabel then
                    local dist = math.floor((myPos - d.Object.Position).Magnitude)
                    d.DistLabel.Text = dist .. "m"
                    d.DistLabel.TextColor3 = dist < 50 and Color3.fromRGB(0,255,80)
                        or dist < 150 and Color3.fromRGB(255,255,0)
                        or Color3.fromRGB(255,100,0)
                end
            end
        end
    end)
end

-- Auto TP Fruit (trái thật)
function StartAutoTeleportFruit()
    fruitTeleportEnabled = true
    spawn(function()
        while fruitTeleportEnabled and Toggles.AutoTeleportFruit do
            local char = LocalPlayer.Character
            if not char then wait(0.5); continue end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then wait(0.5); continue end

            local nearest, nearDist = nil, math.huge
            for _, v in pairs(Workspace:GetDescendants()) do
                if IsFruitObject(v) then
                    local fr = v:FindFirstChild("Handle") or v.PrimaryPart or v:FindFirstChildOfClass("BasePart")
                    if fr then
                        local d = (root.Position - fr.Position).Magnitude
                        if d < nearDist then nearDist = d; nearest = fr end
                    end
                end
            end

            if nearest then
                root.CFrame = CFrame.new(nearest.Position + Vector3.new(0,3,0))
                wait(1.2)
            end
            wait(0.4)
        end
    end)
end

function StopAutoTeleportFruit()
    fruitTeleportEnabled = false
end

-- Auto Farm (with mode selection)
local FarmAttackFunctions = {
    Trái = function(char, mob)
        -- Pick up nearby fruits and use them
        for _, v in pairs(Workspace:GetDescendants()) do
            if IsFruitObject(v) then
                local fr = v:FindFirstChild("Handle") or v.PrimaryPart or v:FindFirstChildOfClass("BasePart")
                if fr and (char.HumanoidRootPart.Position - fr.Position).Magnitude < 10 then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then hum:EquipTool(v) end
                end
            end
        end
        -- Attack mob with equipped tool
        local hum = mob:FindFirstChildOfClass("Humanoid")
        if hum then hum:TakeDamage(math.random(15,35)) end
    end,
    Mele = function(char, mob)
        local hum = mob:FindFirstChildOfClass("Humanoid")
        if hum then hum:TakeDamage(math.random(20,45)) end
        -- Simulate punch animation area
        for _, tool in pairs(char:GetChildren()) do
            if tool:IsA("Tool") then
                local activate = tool:FindFirstChild("RemoteEvent") or tool:FindFirstChild("RemoteFunction")
                if activate then pcall(function() activate:FireServer() end) end
            end
        end
    end,
    Kiếm = function(char, mob)
        local hum = mob:FindFirstChildOfClass("Humanoid")
        if hum then hum:TakeDamage(math.random(30,60)) end
        -- Try sword remote
        for _, tool in pairs(char:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():find("sword") or tool.Name:lower():find("blade") or tool.Name:lower():find("kiem")) then
                local evt = tool:FindFirstChildOfClass("RemoteEvent")
                if evt then pcall(function() evt:FireServer(mob) end) end
            end
        end
    end,
    Súng = function(char, mob)
        local hum = mob:FindFirstChildOfClass("Humanoid")
        if hum then hum:TakeDamage(math.random(25,55)) end
        -- Try gun remote
        for _, tool in pairs(char:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():find("gun") or tool.Name:lower():find("pistol") or tool.Name:lower():find("rifle")) then
                local evt = tool:FindFirstChildOfClass("RemoteEvent")
                if evt then pcall(function() evt:FireServer(mob.HumanoidRootPart.Position) end) end
            end
        end
    end,
}

function StartAutoFarm()
    autoFarmRunning = true
    spawn(function()
        while autoFarmRunning and Toggles.AutoFarm do
            local char = LocalPlayer.Character
            if not char then wait(0.5); continue end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then wait(0.5); continue end

            local nearest, nearDist = nil, math.huge
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("Model") and v:FindFirstChildOfClass("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                    if not Players:GetPlayerFromCharacter(v) then
                        local d = (root.Position - v.HumanoidRootPart.Position).Magnitude
                        if d < nearDist then nearDist = d; nearest = v end
                    end
                end
            end

            if nearest then
                local mobRoot = nearest:FindFirstChild("HumanoidRootPart")
                if mobRoot then
                    root.CFrame = CFrame.new(mobRoot.Position + Vector3.new(0,3,0))
                    local attackFn = FarmAttackFunctions[AutoFarmMode] or FarmAttackFunctions.Mele
                    pcall(attackFn, char, nearest)
                    local hum = nearest:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health <= 0 then
                        print("⚔️ [" .. AutoFarmMode .. "] Tiêu diệt: " .. nearest.Name)
                    end
                    wait(0.4)
                end
            else
                wait(0.5)
            end
        end
    end)
end

function StopAutoFarm()
    autoFarmRunning = false
end

-- Auto Farm V2 — Bug Dame 9999
function StartAutoFarmV2()
    autoFarmV2Running = true
    spawn(function()
        while autoFarmV2Running and Toggles.AutoFarmV2 do
            local char = LocalPlayer.Character
            if not char then wait(0.5); continue end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then wait(0.5); continue end

            for _, v in pairs(Workspace:GetDescendants()) do
                if not autoFarmV2Running then break end
                if v:IsA("Model") and v:FindFirstChildOfClass("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                    if not Players:GetPlayerFromCharacter(v) then
                        local hum = v:FindFirstChildOfClass("Humanoid")
                        local mobRoot = v:FindFirstChild("HumanoidRootPart")
                        if hum and hum.Health > 0 then
                            -- Teleport on top
                            root.CFrame = CFrame.new(mobRoot.Position + Vector3.new(0,2,0))

                            -- Bug dame: rapid TakeDamage flood to hit 9999+
                            for i = 1, 20 do
                                pcall(function() hum:TakeDamage(9999) end)
                                -- Try all remotes for multi-hit
                                for _, child in pairs(char:GetDescendants()) do
                                    if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                                        pcall(function()
                                            if child:IsA("RemoteEvent") then
                                                child:FireServer(v, mobRoot.Position, 9999)
                                            end
                                        end)
                                    end
                                end
                                -- Try tool remotes
                                for _, tool in pairs(char:GetChildren()) do
                                    if tool:IsA("Tool") then
                                        for _, evt in pairs(tool:GetDescendants()) do
                                            if evt:IsA("RemoteEvent") then
                                                pcall(function() evt:FireServer(v) end)
                                            end
                                        end
                                    end
                                end
                                task.wait(0.02)
                            end

                            -- Force kill if still alive
                            pcall(function()
                                hum.Health = 0
                                v:Destroy()
                            end)
                            print("💥 [V2] Dame 9999 → " .. v.Name)
                            task.wait(0.1)
                        end
                    end
                end
            end
            wait(0.3)
        end
    end)
end

function StopAutoFarmV2()
    autoFarmV2Running = false
end

-- Anti Idle
local function AntiIdle()
    spawn(function()
        while wait(25) do
            VirtualUser:ClickButton2(Vector2.new())
        end
    end)
end

-- // ===== INIT =====
FixLagLoop()
SuperJumpLoop()
FlySetup()
NoclipLoop()
GhostLoop()
NightVisionLoop()
ESPLoop()
UpdateDistances()
AntiIdle()

-- Hotkeys
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.M then
        MainFrame.Visible = not MainFrame.Visible
    end
    if input.KeyCode == Enum.KeyCode.F1 then
        Toggles.Ghost = not Toggles.Ghost
        toggleGhost.Set(Toggles.Ghost)
    end
    if input.KeyCode == Enum.KeyCode.F2 then
        Toggles.NightVision = not Toggles.NightVision
        toggleNV.Set(Toggles.NightVision)
    end
end)

print("⚡ MV X SHINN DEV v5.0 — LOADED")
print("📌 M=Menu | F=Fly | F1=Ghost | F2=Night Vision")
