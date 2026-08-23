-- MV Hub | Axiom Build v4.1 + ModernUI Framework
-- Integrated Modern UI System with ESP, Auto Farm, Fly Jump, Settings

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

------------------------------------------------------------
-- MODERNUI FRAMEWORK
------------------------------------------------------------
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
    CornerRadius = UDim.new(0, 10),
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
    New("UICorner", { CornerRadius = radius or Theme.CornerRadius, Parent = inst })
end

local function ResolveText(textOrTable, lang)
    if type(textOrTable) == "table" then
        return textOrTable[lang] or textOrTable.en or textOrTable.vi or "?"
    end
    return textOrTable
end

local UI = {}
UI.__index = UI

function UI.CreateWindow(config)
    config = config or {}
    local self = setmetatable({}, UI)

    self.Language = config.DefaultLanguage or "vi"
    self.Tabs = {}
    self.LocalizedObjects = {}

    self.ScreenGui = New("ScreenGui", {
        Name = config.Name or "ModernUI",
        ResetOnSpawn = false,
        Parent = LocalPlayer:WaitForChild("PlayerGui"),
    })

    self.ToggleButton = New("TextButton", {
        Parent = self.ScreenGui,
        Size = UDim2.new(0, 56, 0, 56),
        Position = UDim2.new(0, 20, 0.5, -28),
        BackgroundColor3 = Theme.Accent,
        Text = config.ToggleIcon or "☰",
        TextColor3 = Color3.new(1,1,1),
        TextScaled = true,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        AutoButtonColor = true,
    })
    Round(self.ToggleButton, UDim.new(1,0))

    self.MainFrame = New("Frame", {
        Parent = self.ScreenGui,
        Size = UDim2.new(0, 560, 0, 500),
        Position = UDim2.new(0.5, -280, 0.5, -250),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Visible = false,
        Active = true,
        Draggable = true,
        ClipsDescendants = true,
    })
    Round(self.MainFrame, UDim.new(0, 14))

    local TitleBar = New("Frame", {
        Parent = self.MainFrame,
        Size = UDim2.new(1, 0, 0, 46),
        BackgroundColor3 = Theme.Panel,
        BorderSizePixel = 0,
    })
    Round(TitleBar, UDim.new(0, 14))

    self.TitleLabel = New("TextLabel", {
        Parent = TitleBar,
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.new(0, 16, 0, 0),
        BackgroundTransparency = 1,
        Text = ResolveText(config.Title or "Menu", self.Language),
        TextColor3 = Theme.TextPrimary,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextScaled = false,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
    })

    local CloseBtn = New("TextButton", {
        Parent = TitleBar,
        Size = UDim2.new(0, 32, 0, 32),
        Position = UDim2.new(1, -40, 0.5, -16),
        BackgroundColor3 = Theme.Danger,
        Text = "✕",
        TextColor3 = Color3.new(1,1,1),
        TextScaled = true,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
    })
    Round(CloseBtn, UDim.new(0, 8))
    CloseBtn.MouseButton1Click:Connect(function()
        self:SetVisible(false)
    end)

    self.TabListFrame = New("ScrollingFrame", {
        Parent = self.MainFrame,
        Size = UDim2.new(0, 150, 1, -46),
        Position = UDim2.new(0, 0, 0, 46),
        BackgroundColor3 = Theme.Panel,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        CanvasSize = UDim2.new(0,0,0,0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
    })
    New("UIListLayout", {
        Parent = self.TabListFrame,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4),
    })
    New("UIPadding", {
        Parent = self.TabListFrame,
        PaddingTop = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
    })

    self.ContentArea = New("Frame", {
        Parent = self.MainFrame,
        Size = UDim2.new(1, -150, 1, -46),
        Position = UDim2.new(0, 150, 0, 46),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
    })

    self.ToggleButton.MouseButton1Click:Connect(function()
        self:SetVisible(not self.MainFrame.Visible)
    end)

    return self
end

function UI:SetVisible(state)
    self.MainFrame.Visible = state
end

function UI:AddTab(id, titleTable, icon)
    local self_win = self
    local Tab = {}
    Tab.__index = Tab

    local isFirst = (next(self_win.Tabs) == nil)

    local TabButton = New("TextButton", {
        Parent = self_win.TabListFrame,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = isFirst and Theme.TabActive or Theme.TabInactive,
        Text = (icon and (icon.." ") or "") .. ResolveText(titleTable, self_win.Language),
        TextColor3 = Theme.TextPrimary,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        BorderSizePixel = 0,
        AutoButtonColor = true,
    })
    Round(TabButton, UDim.new(0, 8))

    local Page = New("ScrollingFrame", {
        Parent = self_win.ContentArea,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Visible = isFirst,
        ScrollBarThickness = 5,
        CanvasSize = UDim2.new(0,0,0,0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
    })
    New("UIListLayout", {
        Parent = Page,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
    })
    New("UIPadding", {
        Parent = Page,
        PaddingTop = UDim.new(0, 14),
        PaddingLeft = UDim.new(0, 14),
        PaddingRight = UDim.new(0, 14),
        PaddingBottom = UDim.new(0, 14),
    })

    TabButton.MouseButton1Click:Connect(function()
        for _, t in pairs(self_win.Tabs) do
            t.Page.Visible = false
            t.Button.BackgroundColor3 = Theme.TabInactive
        end
        Page.Visible = true
        TabButton.BackgroundColor3 = Theme.TabActive
    end)

    local tabObj = setmetatable({
        Id = id,
        Page = Page,
        Button = TabButton,
        Window = self_win,
    }, Tab)

    self_win.Tabs[id] = tabObj
    return tabObj
end

function UI.AddLabel(self, textTable)
    local lbl = New("TextLabel", {
        Parent = self.Page,
        Size = UDim2.new(1, 0, 0, 24),
        BackgroundTransparency = 1,
        Text = ResolveText(textTable, self.Window.Language),
        TextColor3 = Theme.TextSecondary,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    return lbl
end

function UI.AddButton(self, textTable, callback)
    local btn = New("TextButton", {
        Parent = self.Page,
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = Theme.Accent,
        Text = ResolveText(textTable, self.Window.Language),
        TextColor3 = Color3.new(1,1,1),
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        BorderSizePixel = 0,
        AutoButtonColor = true,
    })
    Round(btn)
    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    return btn
end

function UI.AddToggle(self, textTable, default, callback)
    local state = default or false

    local row = New("Frame", {
        Parent = self.Page,
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = Theme.Panel,
        BorderSizePixel = 0,
    })
    Round(row)

    local lbl = New("TextLabel", {
        Parent = row,
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = ResolveText(textTable, self.Window.Language),
        TextColor3 = Theme.TextPrimary,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local switchBg = New("Frame", {
        Parent = row,
        Size = UDim2.new(0, 44, 0, 22),
        Position = UDim2.new(1, -54, 0.5, -11),
        BackgroundColor3 = state and Theme.Success or Color3.fromRGB(60,60,75),
        BorderSizePixel = 0,
    })
    Round(switchBg, UDim.new(1,0))

    local knob = New("Frame", {
        Parent = switchBg,
        Size = UDim2.new(0, 18, 0, 18),
        Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9),
        BackgroundColor3 = Color3.new(1,1,1),
        BorderSizePixel = 0,
    })
    Round(knob, UDim.new(1,0))

    local clickArea = New("TextButton", {
        Parent = row,
        Size = UDim2.new(1,0,1,0),
        BackgroundTransparency = 1,
        Text = "",
    })
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

    return { Set = function(v) state = v end, Get = function() return state end }
end

function UI.AddDropdown(self, textTable, options, default, callback)
    local selectedId = default

    local container = New("Frame", {
        Parent = self.Page,
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = Theme.Panel,
        BorderSizePixel = 0,
        ClipsDescendants = false,
        ZIndex = 2,
    })
    Round(container)

    local lbl = New("TextLabel", {
        Parent = container,
        Size = UDim2.new(0.5, 0, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = ResolveText(textTable, self.Window.Language),
        TextColor3 = Theme.TextPrimary,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 2,
    })

    local function findOption(id)
        for _, o in ipairs(options) do
            if o.id == id then return o end
        end
        return options[1]
    end

    local selectBtn = New("TextButton", {
        Parent = container,
        Size = UDim2.new(0.42, 0, 0, 28),
        Position = UDim2.new(0.56, 0, 0.5, -14),
        BackgroundColor3 = Theme.TabInactive,
        Text = ResolveText(findOption(selectedId).label, self.Window.Language) .. " ▾",
        TextColor3 = Theme.TextPrimary,
        Font = Enum.Font.Gotham,
        TextSize = 13,
        BorderSizePixel = 0,
        ZIndex = 2,
    })
    Round(selectBtn, UDim.new(0,6))

    local dropdownList = New("Frame", {
        Parent = container,
        Size = UDim2.new(0.42, 0, 0, #options * 28),
        Position = UDim2.new(0.56, 0, 1, 2),
        BackgroundColor3 = Theme.TabInactive,
        Visible = false,
        BorderSizePixel = 0,
        ZIndex = 5,
    })
    Round(dropdownList, UDim.new(0,6))
    New("UIListLayout", { Parent = dropdownList, SortOrder = Enum.SortOrder.LayoutOrder })

    for i, opt in ipairs(options) do
        local ob = New("TextButton", {
            Parent = dropdownList,
            Size = UDim2.new(1, 0, 0, 28),
            BackgroundColor3 = Theme.TabInactive,
            Text = ResolveText(opt.label, self.Window.Language),
            TextColor3 = Theme.TextPrimary,
            Font = Enum.Font.Gotham,
            TextSize = 13,
            BorderSizePixel = 0,
            ZIndex = 5,
        })
        ob.MouseButton1Click:Connect(function()
            selectedId = opt.id
            selectBtn.Text = ResolveText(opt.label, self.Window.Language) .. " ▾"
            dropdownList.Visible = false
            if callback then callback(selectedId) end
        end)
    end

    selectBtn.MouseButton1Click:Connect(function()
        dropdownList.Visible = not dropdownList.Visible
    end)

    return {
        Get = function() return selectedId end,
        Set = function(id)
            selectedId = id
            selectBtn.Text = ResolveText(findOption(id).label, self.Window.Language) .. " ▾"
        end,
    }
end

function UI:SetLanguage(lang)
    self.Language = lang
    for inst, info in pairs(self.LocalizedObjects) do
        if not inst.Parent then continue end
        if info.kind == "text" then
            inst.Text = ResolveText(info.data, lang) .. (info.suffix or "")
        end
    end
end

------------------------------------------------------------
-- GAME CONFIG & TOGGLES
------------------------------------------------------------
local Config = {
    Language = "vi",
    AdminName = "MV Boss",
    AdminBirthDate = "01/01/2000",
    AdminBio = "Exploit Master 🔥",
    FlySpeed = 50,
    JumpPower = 250,
    GhostStealth = 0.3,
}

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
}

local FlyState = {
    enabled = false,
    bodyVelocity = nil,
    jumpCount = 0,
    currentHeight = 0,
}

local ESPObjects = {}
local SelectedWeapon = "default"
local SelectedMob = "all"
local SelectedMapPoint = nil
local SelectedMapName = "Chưa chọn"
local DetectedMapPoints = {}

------------------------------------------------------------
-- LANGUAGE TABLE
------------------------------------------------------------
local Texts = {
    vi = {
        home = "Trang chủ",
        features = "Tính năng",
        settings = "Cài đặt",
        map = "Bản đồ",
        farmAuto = "Tự động nông trại",
        fixLag = "Sửa lag",
        superJump = "Nhảy siêu",
        fly = "Bay",
        noclip = "Xuyên tường",
        espPlayers = "ESP Người chơi",
        espMobs = "ESP Quái",
        espFruits = "ESP Trái cây",
        ghost = "Chế độ ma",
        nightVision = "Nhìn đêm",
        adminInfo = "Thông tin Admin",
        adminName = "Tên Admin",
        adminBirth = "Ngày sinh",
        adminBio = "Tiểu sử",
        language = "Ngôn ngữ",
        currentTime = "Thời gian hiện tại",
        selectWeapon = "Chọn vũ khí",
        selectMob = "Chọn quái",
        flySpeed = "Tốc độ bay",
        jumpPower = "Lực nhảy",
        teleport = "Dịch chuyển",
        scanMap = "Quét bản đồ",
        refresh = "Làm mới",
    },
    en = {
        home = "Home",
        features = "Features",
        settings = "Settings",
        map = "Map",
        farmAuto = "Auto Farm",
        fixLag = "Fix Lag",
        superJump = "Super Jump",
        fly = "Fly",
        noclip = "Noclip",
        espPlayers = "ESP Players",
        espMobs = "ESP Mobs",
        espFruits = "ESP Fruits",
        ghost = "Ghost Mode",
        nightVision = "Night Vision",
        adminInfo = "Admin Info",
        adminName = "Admin Name",
        adminBirth = "Birth Date",
        adminBio = "Bio",
        language = "Language",
        currentTime = "Current Time",
        selectWeapon = "Select Weapon",
        selectMob = "Select Mob",
        flySpeed = "Fly Speed",
        jumpPower = "Jump Power",
        teleport = "Teleport",
        scanMap = "Scan Map",
        refresh = "Refresh",
    },
    ko = {
        home = "홈",
        features = "특성",
        settings = "설정",
        map = "지도",
        farmAuto = "자동 농장",
        fixLag = "지연 수정",
        superJump = "슈퍼 점프",
        fly = "날기",
        noclip = "벽통과",
        espPlayers = "ESP 플레이어",
        espMobs = "ESP 몹",
        espFruits = "ESP 과일",
        ghost = "유령 모드",
        nightVision = "야간 투시",
        adminInfo = "관리자 정보",
        adminName = "관리자 이름",
        adminBirth = "생년월일",
        adminBio = "소개",
        language = "언어",
        currentTime = "현재 시간",
        selectWeapon = "무기 선택",
        selectMob = "몹 선택",
        flySpeed = "비행 속도",
        jumpPower = "점프력",
        teleport = "텔레포트",
        scanMap = "맵 스캔",
        refresh = "새로고침",
    }
}

local function T(key)
    return Texts[Config.Language][key] or key
end

------------------------------------------------------------
-- CREATE MAIN UI
------------------------------------------------------------
local Window = UI.CreateWindow({
    Title = "⚡ MV HACK v4.1",
    Name = "MVHackUI",
    DefaultLanguage = "vi",
})

-- HOME TAB
local TabHome = Window:AddTab("home", T("home"), "🏠")
TabHome:AddLabel(T("adminInfo"))
local adminCard, adminLabels = UI.AddInfoCard(TabHome, {
    {label = {vi="Tên", en="Name", ko="이름"}, value = Config.AdminName, key="name"},
    {label = {vi="Ngày sinh", en="Birthday", ko="생일"}, value = Config.AdminBirthDate, key="birth"},
    {label = {vi="Tiểu sử", en="Bio", ko="소개"}, value = Config.AdminBio, key="bio"},
})

TabHome:AddLabel({vi="⏰ Thời gian", en="⏰ Time", ko="⏰ 시간"})
local timeLabel = New("TextLabel", {
    Parent = TabHome.Page,
    Size = UDim2.new(1, 0, 0, 32),
    BackgroundColor3 = Theme.Panel,
    Text = os.date("%H:%M:%S | %d/%m/%Y"),
    TextColor3 = Theme.TextPrimary,
    TextScaled = true,
    Font = Enum.Font.Gotham,
    BorderSizePixel = 0,
})
Round(timeLabel)

-- Update time every second
spawn(function()
    while wait(1) do
        if timeLabel.Parent then
            timeLabel.Text = os.date("%H:%M:%S | %d/%m/%Y")
        end
    end
end)

-- FEATURES TAB
local TabFeatures = Window:AddTab("features", T("features"), "⚙️")

-- Auto Farm
TabFeatures:AddLabel({vi="🔄 Tự động", en="🔄 Auto", ko="🔄 자동"})
UI.AddToggle(TabFeatures, {vi="Tự động nông trại", en="Auto Farm", ko="자동 농장"}, false, function(state)
    Toggles.AutoFarm = state
end)

TabFeatures:AddDropdown(TabFeatures, {vi="Chọn vũ khí", en="Select Weapon", ko="무기 선택"}, {
    {id="default", label={vi="Mặc định", en="Default", ko="기본"}},
    {id="sword", label={vi="Kiếm", en="Sword", ko="검"}},
    {id="gun", label={vi="Súng", en="Gun", ko="총"}},
}, "default", function(sel)
    SelectedWeapon = sel
end)

TabFeatures:AddDropdown(TabFeatures, {vi="Chọn quái", en="Select Mob", ko="몹 선택"}, {
    {id="all", label={vi="Tất cả", en="All", ko="모두"}},
    {id="boss", label={vi="Boss", en="Boss", ko="보스"}},
    {id="mini", label={vi="Mini", en="Mini", ko="미니"}},
}, "all", function(sel)
    SelectedMob = sel
end)

-- Movement Features
TabFeatures:AddLabel({vi="🚀 Vận động", en="🚀 Movement", ko="🚀 이동"})
UI.AddToggle(TabFeatures, {vi="Siêu nhảy", en="Super Jump", ko="슈퍼 점프"}, false, function(state)
    Toggles.SuperJump = state
end)

UI.AddToggle(TabFeatures, {vi="Bay (Space để bay/hạ)", en="Fly (Space to fly/down)", ko="날기 (스페이스)"}, false, function(state)
    Toggles.Fly = state
end)

UI.AddToggle(TabFeatures, {vi="Xuyên tường", en="Noclip", ko="벽통과"}, false, function(state)
    Toggles.Noclip = state
end)

-- ESP Features
TabFeatures:AddLabel({vi="👁️ ESP", en="👁️ ESP", ko="👁️ ESP"})
UI.AddToggle(TabFeatures, {vi="ESP Người chơi", en="ESP Players", ko="ESP 플레이어"}, false, function(state)
    Toggles.ESPPlayers = state
end)

UI.AddToggle(TabFeatures, {vi="ESP Quái", en="ESP Mobs", ko="ESP 몹"}, false, function(state)
    Toggles.ESPMobs = state
end)

UI.AddToggle(TabFeatures, {vi="ESP Trái cây", en="ESP Fruits", ko="ESP 과일"}, false, function(state)
    Toggles.ESPFruits = state
end)

-- Visuals
TabFeatures:AddLabel({vi="🌈 Hình ảnh", en="🌈 Visuals", ko="🌈 시각"})
UI.AddToggle(TabFeatures, {vi="Chế độ ma", en="Ghost Mode", ko="유령 모드"}, false, function(state)
    Toggles.Ghost = state
end)

UI.AddToggle(TabFeatures, {vi="Nhìn đêm", en="Night Vision", ko="야간 투시"}, false, function(state)
    Toggles.NightVision = state
end)

UI.AddToggle(TabFeatures, {vi="Sửa lag", en="Fix Lag", ko="지연 수정"}, false, function(state)
    Toggles.FixLag = state
end)

-- SETTINGS TAB
local TabSettings = Window:AddTab("settings", T("settings"), "⚙️")

TabSettings:AddLabel({vi="⚙️ Ngôn ngữ", en="⚙️ Language", ko="⚙️ 언어"})
UI.AddDropdown(TabSettings, {vi="Chọn ngôn ngữ", en="Select Language", ko="언어 선택"}, {
    {id="vi", label={vi="🇻🇳 Tiếng Việt", en="🇻🇳 Vietnamese", ko="🇻 베트남어"}},
    {id="en", label={vi="🇺🇸 English", en="🇺🇸 English", ko="🇺🇸 영어"}},
    {id="ko", label={vi="🇰🇷 한국어", en="🇰🇷 Korean", ko="🇰🇷 한국어"}},
}, "vi", function(lang)
    Config.Language = lang
    Window:SetLanguage(lang)
end)

TabSettings:AddLabel({vi="🎮 Tùy chỉnh", en="🎮 Customization", ko="🎮 맞춤설정"})

-- Fly Speed Slider
local flySpeedLabel = New("TextLabel", {
    Parent = TabSettings.Page,
    Size = UDim2.new(1, 0, 0, 22),
    BackgroundTransparency = 1,
    Text = "✈️ Tốc độ bay: " .. Config.FlySpeed,
    TextColor3 = Theme.TextPrimary,
    TextScaled = true,
    Font = Enum.Font.GothamBold,
})

local flySpeedRow = New("Frame", {
    Parent = TabSettings.Page,
    Size = UDim2.new(1, 0, 0, 32),
    BackgroundColor3 = Theme.Panel,
    BorderSizePixel = 0,
})
Round(flySpeedRow)

local flyMinus = New("TextButton", {
    Parent = flySpeedRow,
    Size = UDim2.new(0.2, 0, 1, 0),
    BackgroundColor3 = Theme.Danger,
    Text = "−",
    TextColor3 = Color3.new(1,1,1),
    Font = Enum.Font.GothamBold,
    BorderSizePixel = 0,
})
Round(flyMinus, UDim.new(0,6))
flyMinus.MouseButton1Click:Connect(function()
    Config.FlySpeed = math.max(10, Config.FlySpeed - 5)
    flySpeedLabel.Text = "✈️ Tốc độ bay: " .. Config.FlySpeed
end)

local flyValue = New("TextLabel", {
    Parent = flySpeedRow,
    Size = UDim2.new(0.6, 0, 1, 0),
    Position = UDim2.new(0.2, 0, 0, 0),
    BackgroundTransparency = 1,
    Text = Config.FlySpeed,
    TextColor3 = Theme.TextPrimary,
    TextScaled = true,
    Font = Enum.Font.GothamBold,
})

local flyPlus = New("TextButton", {
    Parent = flySpeedRow,
    Size = UDim2.new(0.2, 0, 1, 0),
    Position = UDim2.new(0.8, 0, 0, 0),
    BackgroundColor3 = Theme.Success,
    Text = "+",
    TextColor3 = Color3.new(1,1,1),
    Font = Enum.Font.GothamBold,
    BorderSizePixel = 0,
})
Round(flyPlus, UDim.new(0,6))
flyPlus.MouseButton1Click:Connect(function()
    Config.FlySpeed = Config.FlySpeed + 5
    flySpeedLabel.Text = "✈️ Tốc độ bay: " .. Config.FlySpeed
    flyValue.Text = Config.FlySpeed
end)

-- MAP TAB
local TabMap = Window:AddTab("map", T("map"), "🗺️")

local function ScanMap()
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
                        Model = model
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
                    Part = part
                })
            end
        end
    end
    
    if #DetectedMapPoints == 0 then
        table.insert(DetectedMapPoints, {Name = "🌍 Center", Position = Vector3.new(0, 10, 0)})
        table.insert(DetectedMapPoints, {Name = "⬆️ High", Position = Vector3.new(0, 200, 0)})
    end
    
    if #DetectedMapPoints > 30 then
        local newList = {}
        for i = 1, 30 do
            newList[i] = DetectedMapPoints[i]
        end
        DetectedMapPoints = newList
    end
end

TabMap:AddLabel({vi="🗺️ Điểm bản đồ", en="🗺️ Map Points", ko="🗺️ 지도 포인트"})

local selectedMapLabel = New("TextLabel", {
    Parent = TabMap.Page,
    Size = UDim2.new(1, 0, 0, 32),
    BackgroundColor3 = Theme.Panel,
    Text = "📌 " .. SelectedMapName,
    TextColor3 = Theme.TextPrimary,
    TextScaled = true,
    Font = Enum.Font.Gotham,
    BorderSizePixel = 0,
})
Round(selectedMapLabel)

TabMap:AddButton({vi="🔄 Quét", en="🔄 Scan", ko="🔄 스캔"}, function()
    ScanMap()
    print("📍 Quét " .. #DetectedMapPoints .. " điểm")
end)

-- Show first 10 map points
ScanMap()
for i, mapData in ipairs(DetectedMapPoints) do
    if i > 10 then break end
    TabMap:AddButton(mapData.Name, function()
        SelectedMapPoint = mapData.Position
        SelectedMapName = mapData.Name
        selectedMapLabel.Text = "📌 " .. mapData.Name
    end)
end

TabMap:AddButton({vi="🚀 Dịch chuyển", en="🚀 Teleport", ko="🚀 텔레포트"}, function()
    if SelectedMapPoint and LocalPlayer.Character then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = CFrame.new(SelectedMapPoint + Vector3.new(0, 5, 0))
        end
    end
end)

------------------------------------------------------------
-- FEATURE IMPLEMENTATIONS
------------------------------------------------------------

-- Fix Lag
spawn(function()
    while wait(1) do
        if Toggles.FixLag then
            settings().Rendering.QualityLevel = 1
            Lighting.GlobalShadows = false
            Lighting.Brightness = 3
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Trail") then
                    v.Enabled = false
                end
            end
        end
    end
end)

-- Super Jump
spawn(function()
    while wait(0.1) do
        if Toggles.SuperJump then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.JumpPower = Config.JumpPower
            end
        end
    end
end)

-- Fly with Jump Activation
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Space and Toggles.Fly then
        local char = LocalPlayer.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        FlyState.jumpCount = FlyState.jumpCount + 1
        
        if FlyState.jumpCount == 1 then
            -- First jump: activate fly
            FlyState.enabled = true
            FlyState.bodyVelocity = Instance.new("BodyVelocity")
            FlyState.bodyVelocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
            FlyState.bodyVelocity.Parent = root
            FlyState.currentHeight = root.Position.Y
        elseif FlyState.jumpCount >= 2 then
            -- Subsequent jumps: increase height
            FlyState.currentHeight = FlyState.currentHeight + 10
        end
    end
end)

-- Fly Movement Loop
spawn(function()
    while wait() do
        if FlyState.enabled and Toggles.Fly and FlyState.bodyVelocity then
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not root or not FlyState.bodyVelocity.Parent then
                FlyState.enabled = false
                if FlyState.bodyVelocity then FlyState.bodyVelocity:Destroy() end
                FlyState.bodyVelocity = nil
                FlyState.jumpCount = 0
                FlyState.currentHeight = 0
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

            if moveDirection.Magnitude > 0 then
                moveDirection = moveDirection.Unit * Config.FlySpeed
            end

            moveDirection = moveDirection + Vector3.new(0, 0, 0)
            FlyState.bodyVelocity.Velocity = moveDirection
        end
    end
end)

-- Stop fly on jump when disabled
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Space and not Toggles.Fly then
        FlyState.jumpCount = 0
    end
end)

-- Noclip
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

-- Ghost Mode
spawn(function()
    while wait(0.1) do
        if Toggles.Ghost then
            local char = LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Transparency = Config.GhostStealth
                    end
                end
            end
        else
            local char = LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "Head" then
                        part.Transparency = 0
                    end
                end
            end
        end
    end
end)

-- Night Vision
spawn(function()
    while wait(0.5) do
        if Toggles.NightVision then
            Lighting.Brightness = 5
            Lighting.ClockTime = 12
            Lighting.FogEnd = 99999
            Lighting.GlobalShadows = false
        else
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = true
        end
    end
end)

-- ESP System
local function CreateESP(object, color, text)
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
    })
end

-- ESP Loop
spawn(function()
    while wait(0.5) do
        if Toggles.ESPPlayers then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local root = player.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        local hasESP = false
                        for _, data in pairs(ESPObjects) do
                            if data.Object == root then hasESP = true break end
                        end
                        if not hasESP then
                            CreateESP(root, Color3.fromRGB(0, 255, 0), "👤 " .. player.Name)
                        end
                    end
                end
            end
        end

        if Toggles.ESPMobs then
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                    local name = v.Name:lower()
                    if name:find("npc") or name:find("mob") or name:find("boss") then
                        local root = v.HumanoidRootPart
                        local hasESP = false
                        for _, data in pairs(ESPObjects) do
                            if data.Object == root then hasESP = true break end
                        end
                        if not hasESP then
                            CreateESP(root, Color3.fromRGB(255, 200, 0), "👾 " .. v.Name)
                        end
                    end
                end
            end
        end

        -- Clean up destroyed ESPs
        for i = #ESPObjects, 1, -1 do
            if not ESPObjects[i].Object or not ESPObjects[i].Object.Parent then
                if ESPObjects[i].Billboard then ESPObjects[i].Billboard:Destroy() end
                table.remove(ESPObjects, i)
            end
        end
    end
end)

-- Update ESP Distances
spawn(function()
    while wait(0.3) do
        local char = LocalPlayer.Character
        if not char then continue end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then continue end
        local myPos = root.Position

        for _, data in pairs(ESPObjects) do
            if data.Object and data.Object.Parent then
                local dist = (myPos - data.Object.Position).Magnitude
                local distText = math.floor(dist) .. "m"
                
                local color = Color3.fromRGB(0, 255, 0)
                if dist > 150 then
                    color = Color3.fromRGB(255, 100, 0)
                elseif dist > 50 then
                    color = Color3.fromRGB(255, 255, 0)
                end
                
                if data.DistLabel then
                    data.DistLabel.Text = distText
                    data.DistLabel.TextColor3 = color
                end
            end
        end
    end
end)

-- Hotkeys
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.M then
        Window:SetVisible(not Window.MainFrame.Visible)
    end
    if input.KeyCode == Enum.KeyCode.F1 then
        Toggles.Ghost = not Toggles.Ghost
    end
    if input.KeyCode == Enum.KeyCode.F2 then
        Toggles.NightVision = not Toggles.NightVision
    end
end)

print("⚡ MV HACK v4.1 + ModernUI LOADED - Oil up, gng, 6767!")
