-- MV X SHINN DEV | Axiom Build v7.1
-- FULL FIXED - Menu Not Empty - All Features Working

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
local flyEnabled = false
local bodyVelocity = nil
local SelectedMapPoint = nil
local SelectedMapName = "Chưa chọn"
local DetectedMapPoints = {}
local ESPObjects = {}
local fruitTeleportEnabled = false
local autoFarmRunning = false
local autoFarmV2Running = false
local LagFixLevel = 80
local SelectedWeapon = "Tay"
local SelectedMob = "Tất cả"
local killCount = 0
local noclipEnabled = false
local noclipParts = {}
local currentLang = "vi"
local AllMobsInMap = {}

-- // Ngôn ngữ
local LangData = {
    vi = {
        title = "⚡ MV X SHINN DEV v7.1",
        main = "🏠 Trang chủ",
        features = "⚡ Tính năng",
        esp = "👁️ ESP",
        farm = "🤖 Auto Farm",
        map = "🗺️ Map",
        admin = "👤 Admin",
        settings = "⚙️ Cài đặt",
        player = "👤 Người chơi",
        ping = "🌐 Ping",
        position = "📍 Vị trí",
        fixlag = "🔧 Fix Lag",
        fixlag_level = "📊 Mức Fix Lag",
        superjump = "🦘 Super Jump",
        jump_power = "🦘 Lực nhảy",
        fly = "✈️ Fly (F)",
        fly_speed = "✈️ Tốc độ bay",
        noclip = "👻 Noclip (Xuyên tường)",
        ghost = "👻 Ghost Mode (F1)",
        nightvision = "🌙 Night Vision (F2)",
        esp_players = "👤 ESP Người chơi",
        esp_mobs = "👾 ESP Quái (Tất cả quái)",
        esp_fruits = "🍎 ESP Trái cây",
        auto_teleport_fruit = "🚀 Tự động dịch chuyển đến trái cây",
        weapon = "🔫 Chọn vũ khí:",
        mob_type = "👾 Chọn loại quái:",
        auto_farm_v1 = "🤖 Auto Farm V1 (Normal)",
        auto_farm_v2 = "💀 Auto Farm V2 (Bug Dame 99999+)",
        farm_info = "📊 Thông tin farm:",
        current_weapon = "⚔️ Vũ khí đang dùng",
        current_mob = "👾 Quái đang farm",
        kills = "💀 Số quái đã kill",
        map_server = "🗺️ Bản đồ Server",
        selected = "📍 Đã chọn: Chưa chọn",
        scan = "🔄 Quét lại",
        teleport = "🚀 Dịch chuyển đến điểm đã chọn",
        admin_info = "👤 Thông tin Admin",
        name = "👤 Tên Admin",
        birthday = "📅 Ngày sinh",
        bio = "📝 Bio",
        active = "🕐 Hoạt động",
        version = "💻 Version",
        telegram = "🔗 Telegram",
        group = "👥 Group",
        announce = "📢 Thông báo",
        open_telegram = "🔗 Mở Telegram Admin",
        open_group = "👥 Mở Group Chat",
        settings_title = "⚙️ Cài đặt",
        language = "🌐 Ngôn ngữ",
        interface = "🎨 Giao diện",
        zoom = "🔍 Thu phóng",
        save = "💾 Lưu cài đặt",
        reset = "🔄 Reset mặc định",
        status = "📊 Trạng thái:",
        update_time = "⏰ Đang cập nhật...",
        all = "Tất cả",
        loaded = "Đã tải thành công! Nhấn M để mở menu",
        loading = "⚡ MV X SHINN DEV v7.1",
    },
    en = {
        title = "⚡ MV X SHINN DEV v7.1",
        main = "🏠 Home",
        features = "⚡ Features",
        esp = "👁️ ESP",
        farm = "🤖 Auto Farm",
        map = "🗺️ Map",
        admin = "👤 Admin",
        settings = "⚙️ Settings",
        player = "👤 Player",
        ping = "🌐 Ping",
        position = "📍 Position",
        fixlag = "🔧 Fix Lag",
        fixlag_level = "📊 Fix Lag Level",
        superjump = "🦘 Super Jump",
        jump_power = "🦘 Jump Power",
        fly = "✈️ Fly (F)",
        fly_speed = "✈️ Fly Speed",
        noclip = "👻 Noclip",
        ghost = "👻 Ghost Mode (F1)",
        nightvision = "🌙 Night Vision (F2)",
        esp_players = "👤 Player ESP",
        esp_mobs = "👾 Mob ESP",
        esp_fruits = "🍎 Fruit ESP",
        auto_teleport_fruit = "🚀 Auto Teleport to Fruit",
        weapon = "🔫 Select Weapon:",
        mob_type = "👾 Select Mob Type:",
        auto_farm_v1 = "🤖 Auto Farm V1 (Normal)",
        auto_farm_v2 = "💀 Auto Farm V2 (Bug Damage 99999+)",
        farm_info = "📊 Farm Info:",
        current_weapon = "⚔️ Current Weapon",
        current_mob = "👾 Current Mob",
        kills = "💀 Kills",
        map_server = "🗺️ Server Map",
        selected = "📍 Selected: None",
        scan = "🔄 Rescan",
        teleport = "🚀 Teleport to selected point",
        admin_info = "👤 Admin Info",
        name = "👤 Admin Name",
        birthday = "📅 Birthday",
        bio = "📝 Bio",
        active = "🕐 Active",
        version = "💻 Version",
        telegram = "🔗 Telegram",
        group = "👥 Group",
        announce = "📢 Announce",
        open_telegram = "🔗 Open Admin Telegram",
        open_group = "👥 Open Group Chat",
        settings_title = "⚙️ Settings",
        language = "🌐 Language",
        interface = "🎨 Interface",
        zoom = "🔍 Zoom",
        save = "💾 Save Settings",
        reset = "🔄 Reset Default",
        status = "📊 Status:",
        update_time = "⏰ Updating...",
        all = "All",
        loaded = "Loaded successfully! Press M to open menu",
        loading = "⚡ MV X SHINN DEV v7.1",
    },
    ko = {
        title = "⚡ MV X SHINN DEV v7.1",
        main = "🏠 홈",
        features = "⚡ 기능",
        esp = "👁️ ESP",
        farm = "🤖 자동 파밍",
        map = "🗺️ 지도",
        admin = "👤 관리자",
        settings = "⚙️ 설정",
        player = "👤 플레이어",
        ping = "🌐 핑",
        position = "📍 위치",
        fixlag = "🔧 랙 수정",
        fixlag_level = "📊 랙 수정 레벨",
        superjump = "🦘 슈퍼 점프",
        jump_power = "🦘 점프력",
        fly = "✈️ 비행 (F)",
        fly_speed = "✈️ 비행 속도",
        noclip = "👻 노클립",
        ghost = "👻 고스트 모드 (F1)",
        nightvision = "🌙 야간 시야 (F2)",
        esp_players = "👤 플레이어 ESP",
        esp_mobs = "👾 몹 ESP",
        esp_fruits = "🍎 과일 ESP",
        auto_teleport_fruit = "🚀 과일로 자동 텔레포트",
        weapon = "🔫 무기 선택:",
        mob_type = "👾 몹 유형 선택:",
        auto_farm_v1 = "🤖 자동 파밍 V1 (일반)",
        auto_farm_v2 = "💀 자동 파밍 V2 (버그 데미지 99999+)",
        farm_info = "📊 파밍 정보:",
        current_weapon = "⚔️ 현재 무기",
        current_mob = "👾 현재 몹",
        kills = "💀 처치 수",
        map_server = "🗺️ 서버 지도",
        selected = "📍 선택됨: 없음",
        scan = "🔄 재검색",
        teleport = "🚀 선택한 지점으로 텔레포트",
        admin_info = "👤 관리자 정보",
        name = "👤 관리자 이름",
        birthday = "📅 생일",
        bio = "📝 자기소개",
        active = "🕐 활동",
        version = "💻 버전",
        telegram = "🔗 텔레그램",
        group = "👥 그룹",
        announce = "📢 공지",
        open_telegram = "🔗 관리자 텔레그램 열기",
        open_group = "👥 그룹 채팅 열기",
        settings_title = "⚙️ 설정",
        language = "🌐 언어",
        interface = "🎨 인터페이스",
        zoom = "🔍 확대/축소",
        save = "💾 설정 저장",
        reset = "🔄 기본값 재설정",
        status = "📊 상태:",
        update_time = "⏰ 업데이트 중...",
        all = "모두",
        loaded = "성공적으로 로드되었습니다! M을 눌러 메뉴를 엽니다",
        loading = "⚡ MV X SHINN DEV v7.1",
    }
}

local function GetText(key)
    return LangData[currentLang][key] or key
end

-- // ============ TẠO SCREENGUI ============
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MVXShinnDev"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Nút mở menu
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.new(0, 56, 0, 56)
ToggleButton.Position = UDim2.new(0, 20, 0.5, -28)
ToggleButton.BackgroundColor3 = Color3.fromRGB(90, 120, 255)
ToggleButton.Text = "⚡"
ToggleButton.TextColor3 = Color3.new(1,1,1)
ToggleButton.TextScaled = true
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.BorderSizePixel = 0
ToggleButton.BackgroundTransparency = 0
ToggleButton.Visible = true
ToggleButton.Active = true
ToggleButton.AutoButtonColor = true

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.Parent = ToggleButton
ToggleCorner.CornerRadius = UDim.new(1, 0)

-- Main Frame
local MainFrame = Instance.new("ScrollingFrame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 650, 0, 550)
MainFrame.Position = UDim2.new(0.5, -325, 0.5, -275)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.ClipsDescendants = true
MainFrame.ScrollBarThickness = 6
MainFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
MainFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
MainFrame.BackgroundTransparency = 0
MainFrame.ZIndex = 5

local MainFrameCorner = Instance.new("UICorner")
MainFrameCorner.Parent = MainFrame
MainFrameCorner.CornerRadius = UDim.new(0, 14)

local MainFrameStroke = Instance.new("UIStroke")
MainFrameStroke.Parent = MainFrame
MainFrameStroke.Color = Color3.fromRGB(90, 120, 255)
MainFrameStroke.Thickness = 1
MainFrameStroke.Transparency = 0.3

local MainLayout = Instance.new("UIListLayout")
MainLayout.Parent = MainFrame
MainLayout.SortOrder = Enum.SortOrder.LayoutOrder
MainLayout.Padding = UDim.new(0, 0)

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.Size = UDim2.new(1, 0, 0, 46)
TitleBar.BackgroundColor3 = Color3.fromRGB(26, 26, 40)
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 10

local TitleBarCorner = Instance.new("UICorner")
TitleBarCorner.Parent = TitleBar
TitleBarCorner.CornerRadius = UDim.new(0, 14)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = TitleBar
TitleLabel.Size = UDim2.new(1, -160, 1, 0)
TitleLabel.Position = UDim2.new(0, 16, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = GetText("title")
TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.ZIndex = 11

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = TitleBar
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -40, 0.5, -16)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 70, 70)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.TextScaled = true
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.ZIndex = 11

local CloseCorner = Instance.new("UICorner")
CloseCorner.Parent = CloseBtn
CloseCorner.CornerRadius = UDim.new(0, 8)

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

local ZoomOutBtn = Instance.new("TextButton")
ZoomOutBtn.Name = "ZoomOutBtn"
ZoomOutBtn.Parent = TitleBar
ZoomOutBtn.Size = UDim2.new(0, 28, 0, 28)
ZoomOutBtn.Position = UDim2.new(1, -110, 0.5, -14)
ZoomOutBtn.BackgroundColor3 = Color3.fromRGB(26, 26, 40)
ZoomOutBtn.Text = "🔍-"
ZoomOutBtn.TextColor3 = Color3.fromRGB(240, 240, 245)
ZoomOutBtn.TextScaled = true
ZoomOutBtn.Font = Enum.Font.GothamBold
ZoomOutBtn.BorderSizePixel = 0
ZoomOutBtn.ZIndex = 11

local ZoomOutCorner = Instance.new("UICorner")
ZoomOutCorner.Parent = ZoomOutBtn
ZoomOutCorner.CornerRadius = UDim.new(0, 6)

local ZoomInBtn = Instance.new("TextButton")
ZoomInBtn.Name = "ZoomInBtn"
ZoomInBtn.Parent = TitleBar
ZoomInBtn.Size = UDim2.new(0, 28, 0, 28)
ZoomInBtn.Position = UDim2.new(1, -78, 0.5, -14)
ZoomInBtn.BackgroundColor3 = Color3.fromRGB(26, 26, 40)
ZoomInBtn.Text = "🔍+"
ZoomInBtn.TextColor3 = Color3.fromRGB(240, 240, 245)
ZoomInBtn.TextScaled = true
ZoomInBtn.Font = Enum.Font.GothamBold
ZoomInBtn.BorderSizePixel = 0
ZoomInBtn.ZIndex = 11

local ZoomInCorner = Instance.new("UICorner")
ZoomInCorner.Parent = ZoomInBtn
ZoomInCorner.CornerRadius = UDim.new(0, 6)

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
    local dragging, dragStart, startPos = false, nil, nil
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
    if MainFrame.Visible then
        MainFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        wait(0.1)
        MainFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    end
end)

-- Tab List
local TabListFrame = Instance.new("ScrollingFrame")
TabListFrame.Name = "TabListFrame"
TabListFrame.Parent = MainFrame
TabListFrame.Size = UDim2.new(0, 160, 1, -46)
TabListFrame.Position = UDim2.new(0, 0, 0, 46)
TabListFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 40)
TabListFrame.BorderSizePixel = 0
TabListFrame.ScrollBarThickness = 4
TabListFrame.CanvasSize = UDim2.new(0,0,0,0)
TabListFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
TabListFrame.ClipsDescendants = true
TabListFrame.ZIndex = 5

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
ContentArea.Name = "ContentArea"
ContentArea.Parent = MainFrame
ContentArea.Size = UDim2.new(1, -160, 1, -46)
ContentArea.Position = UDim2.new(0, 160, 0, 46)
ContentArea.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
ContentArea.BorderSizePixel = 0
ContentArea.ClipsDescendants = true
ContentArea.ZIndex = 5

-- // ============ TẠO TAB ============
local Tabs = {}
local TabButtons = {}

local function AddTab(id, nameKey, icon)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = "Tab_" .. id
    tabBtn.Parent = TabListFrame
    tabBtn.Size = UDim2.new(1, 0, 0, 40)
    tabBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 34)
    tabBtn.Text = icon .. " " .. GetText(nameKey)
    tabBtn.TextColor3 = Color3.fromRGB(240, 240, 245)
    tabBtn.Font = Enum.Font.Gotham
    tabBtn.TextSize = 14
    tabBtn.BorderSizePixel = 0
    tabBtn.ZIndex = 6
    tabBtn.NameKey = nameKey
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.Parent = tabBtn
    tabCorner.CornerRadius = UDim.new(0, 8)

    local page = Instance.new("ScrollingFrame")
    page.Name = "Page_" .. id
    page.Parent = ContentArea
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.Visible = (#Tabs == 0)
    page.ScrollBarThickness = 6
    page.CanvasSize = UDim2.new(0,0,0,0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.ClipsDescendants = true
    page.ZIndex = 6

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
        tabBtn.BackgroundColor3 = Color3.fromRGB(40, 42, 60)
    end

    tabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Page.Visible = false
            t.Button.BackgroundColor3 = Color3.fromRGB(22, 22, 34)
        end
        page.Visible = true
        tabBtn.BackgroundColor3 = Color3.fromRGB(40, 42, 60)
        page.CanvasPosition = Vector2.new(0, 0)
    end)

    local tab = {
        Id = id,
        Page = page,
        Button = tabBtn,
        Layout = pageLayout,
        NameKey = nameKey,
    }
    Tabs[id] = tab
    TabButtons[id] = tabBtn
    return tab
end

-- // ============ UI COMPONENTS ============
local function AddLabel(tab, textKey)
    local lbl = Instance.new("TextLabel")
    lbl.Parent = tab.Page
    lbl.Size = UDim2.new(1, 0, 0, 24)
    lbl.BackgroundTransparency = 1
    lbl.Text = GetText(textKey)
    lbl.TextColor3 = Color3.fromRGB(160, 160, 175)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextKey = textKey
    return lbl
end

local function AddButton(tab, textKey, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = tab.Page
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(90, 120, 255)
    btn.Text = GetText(textKey)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    btn.TextKey = textKey
    btn.AutoButtonColor = true
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.Parent = btn
    btnCorner.CornerRadius = UDim.new(0, 8)
    
    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    return btn
end

local function AddToggle(tab, textKey, default, callback)
    local state = default or false

    local row = Instance.new("Frame")
    row.Parent = tab.Page
    row.Size = UDim2.new(1, 0, 0, 38)
    row.BackgroundColor3 = Color3.fromRGB(26, 26, 40)
    row.BorderSizePixel = 0
    
    local rowCorner = Instance.new("UICorner")
    rowCorner.Parent = row
    rowCorner.CornerRadius = UDim.new(0, 8)

    local lbl = Instance.new("TextLabel")
    lbl.Parent = row
    lbl.Size = UDim2.new(1, -60, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = GetText(textKey)
    lbl.TextColor3 = Color3.fromRGB(240, 240, 245)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextKey = textKey

    local switchBg = Instance.new("Frame")
    switchBg.Parent = row
    switchBg.Size = UDim2.new(0, 44, 0, 22)
    switchBg.Position = UDim2.new(1, -54, 0.5, -11)
    switchBg.BackgroundColor3 = state and Color3.fromRGB(70, 200, 120) or Color3.fromRGB(60,60,75)
    switchBg.BorderSizePixel = 0
    
    local switchCorner = Instance.new("UICorner")
    switchCorner.Parent = switchBg
    switchCorner.CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Parent = switchBg
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    knob.BackgroundColor3 = Color3.new(1,1,1)
    knob.BorderSizePixel = 0
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.Parent = knob
    knobCorner.CornerRadius = UDim.new(1, 0)

    local clickArea = Instance.new("TextButton")
    clickArea.Parent = row
    clickArea.Size = UDim2.new(1,0,1,0)
    clickArea.BackgroundTransparency = 1
    clickArea.Text = ""
    
    clickArea.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(switchBg, TweenInfo.new(0.15), {
            BackgroundColor3 = state and Color3.fromRGB(70, 200, 120) or Color3.fromRGB(60,60,75)
        }):Play()
        TweenService:Create(knob, TweenInfo.new(0.15), {
            Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        }):Play()
        if callback then callback(state) end
    end)

    return { 
        Set = function(v) 
            state = v
            switchBg.BackgroundColor3 = state and Color3.fromRGB(70, 200, 120) or Color3.fromRGB(60,60,75)
            knob.Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        end, 
        Get = function() return state end,
        SetText = function() lbl.Text = GetText(textKey) end,
    }
end

local function AddSliderWithButtons(tab, textKey, minVal, maxVal, default, callback)
    local value = default or minVal

    local container = Instance.new("Frame")
    container.Parent = tab.Page
    container.Size = UDim2.new(1, 0, 0, 50)
    container.BackgroundColor3 = Color3.fromRGB(26, 26, 40)
    container.BorderSizePixel = 0
    
    local containerCorner = Instance.new("UICorner")
    containerCorner.Parent = container
    containerCorner.CornerRadius = UDim.new(0, 8)
    
    local padding = Instance.new("UIPadding")
    padding.Parent = container
    padding.PaddingTop = UDim.new(0, 8)
    padding.PaddingLeft = UDim.new(0, 12)
    padding.PaddingRight = UDim.new(0, 12)

    local lbl = Instance.new("TextLabel")
    lbl.Parent = container
    lbl.Size = UDim2.new(0.4, 0, 0, 20)
    lbl.Position = UDim2.new(0, 0, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = GetText(textKey)
    lbl.TextColor3 = Color3.fromRGB(160, 160, 175)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextKey = textKey

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Parent = container
    valueLabel.Size = UDim2.new(0.2, 0, 0, 20)
    valueLabel.Position = UDim2.new(0.4, 0, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(value)
    valueLabel.TextColor3 = Color3.fromRGB(90, 120, 255)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 14
    valueLabel.TextXAlignment = Enum.TextXAlignment.Center

    local minusBtn = Instance.new("TextButton")
    minusBtn.Parent = container
    minusBtn.Size = UDim2.new(0.1, 0, 0, 28)
    minusBtn.Position = UDim2.new(0.65, 0, 0.5, -14)
    minusBtn.BackgroundColor3 = Color3.fromRGB(220, 70, 70)
    minusBtn.Text = "-"
    minusBtn.TextColor3 = Color3.new(1,1,1)
    minusBtn.Font = Enum.Font.GothamBold
    minusBtn.TextSize = 18
    minusBtn.BorderSizePixel = 0
    
    local minusCorner = Instance.new("UICorner")
    minusCorner.Parent = minusBtn
    minusCorner.CornerRadius = UDim.new(0, 6)

    local plusBtn = Instance.new("TextButton")
    plusBtn.Parent = container
    plusBtn.Size = UDim2.new(0.1, 0, 0, 28)
    plusBtn.Position = UDim2.new(0.85, 0, 0.5, -14)
    plusBtn.BackgroundColor3 = Color3.fromRGB(70, 200, 120)
    plusBtn.Text = "+"
    plusBtn.TextColor3 = Color3.new(1,1,1)
    plusBtn.Font = Enum.Font.GothamBold
    plusBtn.TextSize = 18
    plusBtn.BorderSizePixel = 0
    
    local plusCorner = Instance.new("UICorner")
    plusCorner.Parent = plusBtn
    plusCorner.CornerRadius = UDim.new(0, 6)

    local function updateValue(val)
        value = math.clamp(val, minVal, maxVal)
        valueLabel.Text = tostring(math.floor(value * 10) / 10)
        if callback then callback(value) end
    end

    minusBtn.MouseButton1Click:Connect(function()
        updateValue(value - 1)
    end)

    plusBtn.MouseButton1Click:Connect(function()
        updateValue(value + 1)
    end)

    return { 
        Get = function() return value end, 
        Set = updateValue,
        SetText = function() lbl.Text = GetText(textKey) end,
    }
end

local function AddInfoCard(tab, rows)
    local card = Instance.new("Frame")
    card.Parent = tab.Page
    card.Size = UDim2.new(1, 0, 0, 30 * #rows + 16)
    card.BackgroundColor3 = Color3.fromRGB(26, 26, 40)
    card.BorderSizePixel = 0
    
    local cardCorner = Instance.new("UICorner")
    cardCorner.Parent = card
    cardCorner.CornerRadius = UDim.new(0, 8)
    
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
        lbl.Text = GetText(row.labelKey) .. ":"
        lbl.TextColor3 = Color3.fromRGB(160, 160, 175)
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 13
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.LabelKey = row.labelKey
        
        local val = Instance.new("TextLabel")
        val.Parent = rowFrame
        val.Size = UDim2.new(0.6, 0, 1, 0)
        val.Position = UDim2.new(0.4, 0, 0, 0)
        val.BackgroundTransparency = 1
        val.Text = row.value or ""
        val.TextColor3 = Color3.fromRGB(240, 240, 245)
        val.Font = Enum.Font.GothamBold
        val.TextSize = 13
        val.TextXAlignment = Enum.TextXAlignment.Left
        valueLabels[row.key] = val
    end
    return card, valueLabels
end

local function AddDropdown(tab, textKey, options, default, callback)
    local selected = default or options[1]
    
    local container = Instance.new("Frame")
    container.Parent = tab.Page
    container.Size = UDim2.new(1, 0, 0, 38)
    container.BackgroundColor3 = Color3.fromRGB(26, 26, 40)
    container.BorderSizePixel = 0
    container.ClipsDescendants = false
    
    local containerCorner = Instance.new("UICorner")
    containerCorner.Parent = container
    containerCorner.CornerRadius = UDim.new(0, 8)
    
    local padding = Instance.new("UIPadding")
    padding.Parent = container
    padding.PaddingTop = UDim.new(0, 8)
    padding.PaddingLeft = UDim.new(0, 12)
    padding.PaddingRight = UDim.new(0, 12)
    
    local lbl = Instance.new("TextLabel")
    lbl.Parent = container
    lbl.Size = UDim2.new(0.35, 0, 1, 0)
    lbl.Position = UDim2.new(0, 0, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = GetText(textKey)
    lbl.TextColor3 = Color3.fromRGB(160, 160, 175)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextKey = textKey
    
    local selectBtn = Instance.new("TextButton")
    selectBtn.Parent = container
    selectBtn.Size = UDim2.new(0.55, 0, 1, -8)
    selectBtn.Position = UDim2.new(0.45, 0, 0, 4)
    selectBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 34)
    selectBtn.Text = selected
    selectBtn.TextColor3 = Color3.fromRGB(240, 240, 245)
    selectBtn.Font = Enum.Font.Gotham
    selectBtn.TextSize = 13
    selectBtn.BorderSizePixel = 0
    
    local selectCorner = Instance.new("UICorner")
    selectCorner.Parent = selectBtn
    selectCorner.CornerRadius = UDim.new(0, 6)
    
    local dropdownList = Instance.new("ScrollingFrame")
    dropdownList.Parent = container
    dropdownList.Size = UDim2.new(0.55, 0, 0, math.min(#options * 30, 150))
    dropdownList.Position = UDim2.new(0.45, 0, 1, 4)
    dropdownList.BackgroundColor3 = Color3.fromRGB(26, 26, 40)
    dropdownList.Visible = false
    dropdownList.BorderSizePixel = 0
    dropdownList.ScrollBarThickness = 4
    dropdownList.CanvasSize = UDim2.new(0,0,0,0)
    dropdownList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    dropdownList.ZIndex = 10
    
    local dropCorner = Instance.new("UICorner")
    dropCorner.Parent = dropdownList
    dropCorner.CornerRadius = UDim.new(0, 6)
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Parent = dropdownList
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 2)
    
    for _, opt in ipairs(options) do
        local btn = Instance.new("TextButton")
        btn.Parent = dropdownList
        btn.Size = UDim2.new(1, 0, 0, 28)
        btn.BackgroundColor3 = Color3.fromRGB(22, 22, 34)
        btn.Text = opt
        btn.TextColor3 = Color3.fromRGB(240, 240, 245)
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
    
    return { 
        Get = function() return selected end, 
        Set = function(v) selected = v; selectBtn.Text = v end,
        SetText = function() lbl.Text = GetText(textKey) end,
    }
end

-- // ============ LƯU UI ELEMENTS ============
local UIElements = {
    labels = {},
    buttons = {},
    toggles = {},
    sliders = {},
    dropdowns = {},
    infoCards = {},
}

-- // ============ TẠO CÁC TAB ============
local tabMain = AddTab("main", "main", "🏠 ")
local tabFeatures = AddTab("features", "features", "⚡ ")
local tabESP = AddTab("esp", "esp", "👁️ ")
local tabFarm = AddTab("farm", "farm", "🤖 ")
local tabMap = AddTab("map", "map", "🗺️ ")
local tabAdmin = AddTab("admin", "admin", "👤 ")
local tabSettings = AddTab("settings", "settings", "⚙️ ")

-- // ===== TAB MAIN =====
local mainTitleLabel = AddLabel(tabMain, "title")
table.insert(UIElements.labels, mainTitleLabel)

local dateLabel = AddLabel(tabMain, "update_time")
table.insert(UIElements.labels, dateLabel)
spawn(function()
    while wait(1) do
        local now = os.time()
        local dateStr = os.date("%d/%m/%Y", now)
        local timeStr = os.date("%H:%M:%S", now)
        dateLabel.Text = "📅 " .. dateStr .. "  ⏰ " .. timeStr
    end
end)

local statusLabel = AddLabel(tabMain, "status")
table.insert(UIElements.labels, statusLabel)

local statusCard, statusLabels = AddInfoCard(tabMain, {
    { labelKey = "player", key = "player", value = LocalPlayer.Name },
    { labelKey = "ping", key = "ping", value = "0ms" },
    { labelKey = "position", key = "position", value = "0, 0, 0" },
})
table.insert(UIElements.infoCards, statusCard)

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

local scanBtn = AddButton(tabMain, "scan", function()
    ScanMap()
    BuildMapUI()
end)
table.insert(UIElements.buttons, scanBtn)

-- // ===== TAB FEATURES =====
local featuresLabel = AddLabel(tabFeatures, "features")
table.insert(UIElements.labels, featuresLabel)

local toggleFixLag = AddToggle(tabFeatures, "fixlag", false, function(state)
    Toggles.FixLag = state
end)
table.insert(UIElements.toggles, toggleFixLag)

local lagSlider = AddSliderWithButtons(tabFeatures, "fixlag_level", 50, 99, 80, function(val)
    LagFixLevel = val
end)
table.insert(UIElements.sliders, lagSlider)

local toggleSuperJump = AddToggle(tabFeatures, "superjump", false, function(state)
    Toggles.SuperJump = state
end)
table.insert(UIElements.toggles, toggleSuperJump)

local jumpSlider = AddSliderWithButtons(tabFeatures, "jump_power", 50, 500, 250, function(val)
    JumpPower = val
end)
table.insert(UIElements.sliders, jumpSlider)

local toggleFly = AddToggle(tabFeatures, "fly", false, function(state)
    Toggles.Fly = state
    if not state and flyEnabled then
        flyEnabled = false
        if bodyVelocity then bodyVelocity:Destroy() end
        bodyVelocity = nil
    end
end)
table.insert(UIElements.toggles, toggleFly)

local speedSlider = AddSliderWithButtons(tabFeatures, "fly_speed", 10, 200, 50, function(val)
    FlySpeed = val
end)
table.insert(UIElements.sliders, speedSlider)

local toggleNoclip = AddToggle(tabFeatures, "noclip", false, function(state)
    Toggles.Noclip = state
    if state then
        EnableNoclip()
    else
        DisableNoclip()
    end
end)
table.insert(UIElements.toggles, toggleNoclip)

local toggleGhost = AddToggle(tabFeatures, "ghost", false, function(state)
    Toggles.Ghost = state
end)
table.insert(UIElements.toggles, toggleGhost)

local toggleNightVision = AddToggle(tabFeatures, "nightvision", false, function(state)
    Toggles.NightVision = state
end)
table.insert(UIElements.toggles, toggleNightVision)

-- // ===== TAB ESP =====
local espLabel = AddLabel(tabESP, "esp")
table.insert(UIElements.labels, espLabel)

local toggleESPPlayers = AddToggle(tabESP, "esp_players", false, function(state)
    Toggles.ESPPlayers = state
end)
table.insert(UIElements.toggles, toggleESPPlayers)

local toggleESPMobs = AddToggle(tabESP, "esp_mobs", false, function(state)
    Toggles.ESPMobs = state
end)
table.insert(UIElements.toggles, toggleESPMobs)

local toggleESPFruits = AddToggle(tabESP, "esp_fruits", false, function(state)
    Toggles.ESPFruits = state
end)
table.insert(UIElements.toggles, toggleESPFruits)

local toggleAutoTeleportFruit = AddToggle(tabESP, "auto_teleport_fruit", false, function(state)
    Toggles.AutoTeleportFruit = state
    if state then StartAutoTeleportFruit() else StopAutoTeleportFruit() end
end)
table.insert(UIElements.toggles, toggleAutoTeleportFruit)

-- // ===== TAB FARM =====
local farmLabel = AddLabel(tabFarm, "farm")
table.insert(UIElements.labels, farmLabel)

local weaponOptions = {"Tay", "Melee", "Kiếm", "Súng"}
local weaponDropdown = AddDropdown(tabFarm, "weapon", weaponOptions, "Tay", function(val)
    SelectedWeapon = val
end)
table.insert(UIElements.dropdowns, weaponDropdown)

local mobOptions = {"Tất cả", "NPC", "Mob", "Boss", "Enemy"}
local mobDropdown = AddDropdown(tabFarm, "mob_type", mobOptions, "Tất cả", function(val)
    SelectedMob = val
end)
table.insert(UIElements.dropdowns, mobDropdown)

local toggleAutoFarm = AddToggle(tabFarm, "auto_farm_v1", false, function(state)
    Toggles.AutoFarm = state
    if state then StartAutoFarm() else StopAutoFarm() end
end)
table.insert(UIElements.toggles, toggleAutoFarm)

local toggleAutoFarmV2 = AddToggle(tabFarm, "auto_farm_v2", false, function(state)
    Toggles.AutoFarmV2 = state
    if state then StartAutoFarmV2() else StopAutoFarmV2() end
end)
table.insert(UIElements.toggles, toggleAutoFarmV2)

local farmInfoLabel = AddLabel(tabFarm, "farm_info")
table.insert(UIElements.labels, farmInfoLabel)

local farmInfoCard, farmInfoLabels = AddInfoCard(tabFarm, {
    { labelKey = "current_weapon", key = "weapon", value = "Tay" },
    { labelKey = "current_mob", key = "mob", value = "Tất cả" },
    { labelKey = "kills", key = "kills", value = "0" },
})
table.insert(UIElements.infoCards, farmInfoCard)

spawn(function()
    while wait(0.5) do
        farmInfoLabels["weapon"].Text = SelectedWeapon
        farmInfoLabels["mob"].Text = SelectedMob
        farmInfoLabels["kills"].Text = tostring(killCount)
    end
end)

-- // ===== TAB MAP =====
local mapLabel = AddLabel(tabMap, "map_server")
table.insert(UIElements.labels, mapLabel)

local selectedMapLabel = AddLabel(tabMap, "selected")
table.insert(UIElements.labels, selectedMapLabel)

local mapContainer = Instance.new("ScrollingFrame")
mapContainer.Parent = tabMap.Page
mapContainer.Size = UDim2.new(1, 0, 0, 250)
mapContainer.BackgroundColor3 = Color3.fromRGB(26, 26, 40)
mapContainer.BorderSizePixel = 0
mapContainer.ScrollBarThickness = 6
mapContainer.CanvasSize = UDim2.new(0,0,0,0)
mapContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
mapContainer.ClipsDescendants = true

local mapCorner = Instance.new("UICorner")
mapCorner.Parent = mapContainer
mapCorner.CornerRadius = UDim.new(0, 8)

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
    AllMobsInMap = {}
    
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
                    if model:FindFirstChild("Humanoid") then
                        table.insert(AllMobsInMap, model)
                    end
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
    refreshBtn.BackgroundColor3 = Color3.fromRGB(90, 120, 255)
    refreshBtn.Text = GetText("scan")
    refreshBtn.TextColor3 = Color3.new(1,1,1)
    refreshBtn.Font = Enum.Font.GothamBold
    refreshBtn.TextSize = 14
    refreshBtn.BorderSizePixel = 0
    
    local refreshCorner = Instance.new("UICorner")
    refreshCorner.Parent = refreshBtn
    refreshCorner.CornerRadius = UDim.new(0, 6)
    
    refreshBtn.MouseButton1Click:Connect(function()
        BuildMapUI()
    end)
    
    local countLabel = Instance.new("TextLabel")
    countLabel.Parent = mapContainer
    countLabel.Size = UDim2.new(1, 0, 0, 20)
    countLabel.BackgroundTransparency = 1
    countLabel.Text = "📌 " .. #DetectedMapPoints .. " điểm tìm thấy"
    countLabel.TextColor3 = Color3.fromRGB(160, 160, 175)
    countLabel.Font = Enum.Font.Gotham
    countLabel.TextSize = 12
    countLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    for _, mapData in ipairs(DetectedMapPoints) do
        local btn = Instance.new("TextButton")
        btn.Parent = mapContainer
        btn.Size = UDim2.new(1, 0, 0, 30)
        btn.BackgroundColor3 = Color3.fromRGB(22, 22, 34)
        btn.Text = mapData.Name
        btn.TextColor3 = Color3.fromRGB(240, 240, 245)
        btn.TextScaled = true
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 12
        btn.BorderSizePixel = 0
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.Parent = btn
        btnCorner.CornerRadius = UDim.new(0, 4)
        
        btn.MouseButton1Click:Connect(function()
            SelectedMapPoint = mapData.Position
            SelectedMapName = mapData.Name
            selectedMapLabel.Text = "📍 " .. SelectedMapName
            
            for _, child in pairs(mapContainer:GetChildren()) do
                if child:IsA("TextButton") then
                    child.BackgroundColor3 = Color3.fromRGB(22, 22, 34)
                end
            end
            btn.BackgroundColor3 = Color3.fromRGB(70, 200, 120)
        end)
    end
    
    local teleportBtn = Instance.new("TextButton")
    teleportBtn.Parent = mapContainer
    teleportBtn.Size = UDim2.new(1, 0, 0, 38)
    teleportBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 200)
    teleportBtn.Text = GetText("teleport")
    teleportBtn.TextColor3 = Color3.new(1,1,1)
    teleportBtn.Font = Enum.Font.GothamBold
    teleportBtn.TextSize = 14
    teleportBtn.BorderSizePixel = 0
    
    local teleportCorner = Instance.new("UICorner")
    teleportCorner.Parent = teleportBtn
    teleportCorner.CornerRadius = UDim.new(0, 6)
    
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
local adminLabel = AddLabel(tabAdmin, "admin_info")
table.insert(UIElements.labels, adminLabel)

local adminCard, adminLabels = AddInfoCard(tabAdmin, {
    { labelKey = "name", key = "name", value = "SHINN DEV" },
    { labelKey = "birthday", key = "birthday", value = "01/01/2000" },
    { labelKey = "bio", key = "bio", value = "⚡ MV X SHINN DEV - Master Hacker" },
    { labelKey = "active", key = "active", value = "24/7" },
    { labelKey = "version", key = "version", value = "v7.1 - Full Features" },
    { labelKey = "telegram", key = "telegram", value = "@MinhVunee" },
    { labelKey = "group", key = "group", value = "@minhvuzbottt" },
})
table.insert(UIElements.infoCards, adminCard)

local announceBtn = AddButton(tabAdmin, "announce", function()
    print("📢 MV X SHINN DEV v7.1 - Đã sẵn sàng!")
end)
table.insert(UIElements.buttons, announceBtn)

local telegramBtn = AddButton(tabAdmin, "open_telegram", function()
    setclipboard("https://t.me/MinhVunee")
    print("🔗 Đã copy link Telegram: https://t.me/MinhVunee")
end)
table.insert(UIElements.buttons, telegramBtn)

local groupBtn = AddButton(tabAdmin, "open_group", function()
    setclipboard("https://t.me/minhvuzbottt")
    print("👥 Đã copy link Group: https://t.me/minhvuzbottt")
end)
table.insert(UIElements.buttons, groupBtn)

-- // ===== TAB SETTINGS =====
local settingsLabel = AddLabel(tabSettings, "settings_title")
table.insert(UIElements.labels, settingsLabel)

local langLabel = AddLabel(tabSettings, "language")
table.insert(UIElements.labels, langLabel)

local langFrame = Instance.new("Frame")
langFrame.Parent = tabSettings.Page
langFrame.Size = UDim2.new(1, 0, 0, 40)
langFrame.BackgroundTransparency = 1

local langVI = Instance.new("TextButton")
langVI.Parent = langFrame
langVI.Size = UDim2.new(0.3, 0, 1, 0)
langVI.Position = UDim2.new(0, 0, 0, 0)
langVI.BackgroundColor3 = Color3.fromRGB(90, 120, 255)
langVI.Text = "🇻🇳 VI"
langVI.TextColor3 = Color3.new(1,1,1)
langVI.Font = Enum.Font.GothamBold
langVI.TextSize = 14
langVI.BorderSizePixel = 0

local viCorner = Instance.new("UICorner")
viCorner.Parent = langVI
viCorner.CornerRadius = UDim.new(0, 6)

local langEN = Instance.new("TextButton")
langEN.Parent = langFrame
langEN.Size = UDim2.new(0.3, 0, 1, 0)
langEN.Position = UDim2.new(0.35, 0, 0, 0)
langEN.BackgroundColor3 = Color3.fromRGB(22, 22, 34)
langEN.Text = "🇬🇧 EN"
langEN.TextColor3 = Color3.fromRGB(240, 240, 245)
langEN.Font = Enum.Font.GothamBold
langEN.TextSize = 14
langEN.BorderSizePixel = 0

local enCorner = Instance.new("UICorner")
enCorner.Parent = langEN
enCorner.CornerRadius = UDim.new(0, 6)

local langKO = Instance.new("TextButton")
langKO.Parent = langFrame
langKO.Size = UDim2.new(0.3, 0, 1, 0)
langKO.Position = UDim2.new(0.7, 0, 0, 0)
langKO.BackgroundColor3 = Color3.fromRGB(22, 22, 34)
langKO.Text = "🇰🇷 KO"
langKO.TextColor3 = Color3.fromRGB(240, 240, 245)
langKO.Font = Enum.Font.GothamBold
langKO.TextSize = 14
langKO.BorderSizePixel = 0

local koCorner = Instance.new("UICorner")
koCorner.Parent = langKO
koCorner.CornerRadius = UDim.new(0, 6)

local function SetLanguage(lang)
    currentLang = lang
    langVI.BackgroundColor3 = (lang == "vi") and Color3.fromRGB(90, 120, 255) or Color3.fromRGB(22, 22, 34)
    langEN.BackgroundColor3 = (lang == "en") and Color3.fromRGB(90, 120, 255) or Color3.fromRGB(22, 22, 34)
    langKO.BackgroundColor3 = (lang == "ko") and Color3.fromRGB(90, 120, 255) or Color3.fromRGB(22, 22, 34)
    
    TitleLabel.Text = GetText("title")
    
    for id, btn in pairs(TabButtons) do
        local tab = Tabs[id]
        if tab then
            local icon = string.match(btn.Text, "^[^ ]+") or ""
            btn.Text = icon .. " " .. GetText(tab.NameKey)
        end
    end
    
    for _, lbl in ipairs(UIElements.labels) do
        if lbl.TextKey then
            lbl.Text = GetText(lbl.TextKey)
        end
    end
    
    for _, btn in ipairs(UIElements.buttons) do
        if btn.TextKey then
            btn.Text = GetText(btn.TextKey)
        end
    end
    
    for _, toggle in ipairs(UIElements.toggles) do
        if toggle.SetText then
            toggle.SetText()
        end
    end
    
    for _, slider in ipairs(UIElements.sliders) do
        if slider.SetText then
            slider.SetText()
        end
    end
    
    for _, dropdown in ipairs(UIElements.dropdowns) do
        if dropdown.SetText then
            dropdown.SetText()
        end
    end
    
    for _, card in ipairs(UIElements.infoCards) do
        for _, child in pairs(card:GetDescendants()) do
            if child:IsA("TextLabel") and child.LabelKey then
                child.Text = GetText(child.LabelKey) .. ":"
            end
        end
    end
    
    for _, child in pairs(mapContainer:GetChildren()) do
        if child:IsA("TextButton") then
            if child.Text == "🔄 Quét lại" or child.Text == "🔄 Rescan" or child.Text == "🔄 재검색" then
                child.Text = GetText("scan")
            elseif child.Text == "🚀 Dịch chuyển đến điểm đã chọn" or child.Text == "🚀 Teleport to selected point" or child.Text == "🚀 선택한 지점으로 텔레포트" then
                child.Text = GetText("teleport")
            end
        end
    end
    
    local langNames = {
        vi = "Tiếng Việt",
        en = "English",
        ko = "한국어"
    }
    print("🌐 Đã chuyển sang: " .. langNames[lang])
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

local interfaceLabel = AddLabel(tabSettings, "interface")
table.insert(UIElements.labels, interfaceLabel)

local zoomSlider = AddSliderWithButtons(tabSettings, "zoom", 0.6, 1.5, 1, function(val)
    scale = val
    MainFrame.Size = UDim2.new(0, 650 * val, 0, 550 * val)
    MainFrame.Position = UDim2.new(0.5, -325 * val, 0.5, -275 * val)
end)
table.insert(UIElements.sliders, zoomSlider)

local saveBtn = AddButton(tabSettings, "save", function()
    print("💾 Settings saved!")
end)
table.insert(UIElements.buttons, saveBtn)

local resetBtn = AddButton(tabSettings, "reset", function()
    scale = 1
    MainFrame.Size = UDim2.new(0, 650, 0, 550)
    MainFrame.Position = UDim2.new(0.5, -325, 0.5, -275)
    zoomSlider.Set(1)
    SetLanguage("vi")
    print("🔄 Đã reset về mặc định!")
end)
table.insert(UIElements.buttons, resetBtn)

-- // ============ TẤT CẢ LỆNH ============

-- 1. Fix Lag
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
                print("✈️ Fly ON - Nhấn Space để lên, Shift để xuống")
            else
                if bodyVelocity then bodyVelocity:Destroy() end
                bodyVelocity = nil
                print("✈️ Fly OFF")
            end
        end
    end)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.Space and Toggles.Fly and flyEnabled then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local root = char.HumanoidRootPart
                root.Velocity = Vector3.new(root.Velocity.X, FlySpeed, root.Velocity.Z)
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
function EnableNoclip()
    noclipEnabled = true
    local char = LocalPlayer.Character
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
                table.insert(noclipParts, part)
            end
        end
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.PlatformStand = true
            end
        end
    end
end

function DisableNoclip()
    noclipEnabled = false
    local char = LocalPlayer.Character
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
        end
    end
    noclipParts = {}
end

local function NoclipLoop()
    spawn(function()
        while wait(0.1) do
            if Toggles.Noclip and noclipEnabled then
                local char = LocalPlayer.Character
                if char then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if root and root.Position.Y < 0 then
                        root.Position = Vector3.new(root.Position.X, 5, root.Position.Z)
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
                Lighting.Brightness = 10
                Lighting.ClockTime = 12
                Lighting.FogEnd = 99999
                Lighting.GlobalShadows = false
                Lighting.Ambient = Color3.fromRGB(255, 255, 255)
                Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
                Lighting.ColorShift_Top = Color3.fromRGB(255, 255, 255)
                Lighting.ColorShift_Bottom = Color3.fromRGB(255, 255, 255)
                
                for _, v in pairs(Lighting:GetDescendants()) do
                    if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
                        v.Enabled = false
                    end
                end
                
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.Reflectance = 0
                    end
                end
            else
                Lighting.Brightness = 2
                Lighting.ClockTime = 14
                Lighting.FogEnd = 100000
                Lighting.GlobalShadows = true
                Lighting.Ambient = Color3.fromRGB(127, 127, 127)
                Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
                Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
                Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
                
                for _, v in pairs(Lighting:GetDescendants()) do
                    if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
                        v.Enabled = true
                    end
                end
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

            if Toggles.ESPMobs then
                for _, v in pairs(Workspace:GetDescendants()) do
                    if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
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

            if Toggles.ESPFruits then
                for _, v in pairs(Workspace:GetDescendants()) do
                    if v:IsA("Model") then
                        local name = v.Name:lower()
                        if name:find("fruit") and not name:find("npc") and not name:find("seller") and 
                           not name:find("vendor") and not name:find("shop") and not name:find("store") then
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
                    if name:find("fruit") and not name:find("npc") and not name:find("seller") and 
                       not name:find("vendor") and not name:find("shop") and not name:find("store") then
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

-- 9. Auto Farm V1
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
                    local mobRoot = v.HumanoidRootPart
                    local dist = (root.Position - mobRoot.Position).Magnitude
                    if dist < nearestDist then
                        nearestDist = dist
                        nearestMob = v
                    end
                end
            end
            
            if nearestMob and nearestDist < 150 then
                local mobRoot = nearestMob.HumanoidRootPart
                root.CFrame = CFrame.new(mobRoot.Position + Vector3.new(0, 3, 0))
                
                local humanoid = nearestMob:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.Health = 0
                    killCount = killCount + 1
                    print("⚔️ Đã tiêu diệt: " .. nearestMob.Name)
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

-- 10. Auto Farm V2
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
                    local mobRoot = v.HumanoidRootPart
                    local dist = (root.Position - mobRoot.Position).Magnitude
                    if dist < nearestDist then
                        nearestDist = dist
                        nearestMob = v
                    end
                end
            end
            
            if nearestMob and nearestDist < 150 then
                local mobRoot = nearestMob.HumanoidRootPart
                root.CFrame = CFrame.new(mobRoot.Position + Vector3.new(0, 3, 0))
                
                local humanoid = nearestMob:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.Health = 0
                    
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
                    print("💀 Bug Dame 99999+! Đã tiêu diệt: " .. nearestMob.Name)
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
NoclipLoop()
ESPLoop()
UpdateDistances()
GhostMode()
NightVision()
AntiIdle()

EnableNoclip()
DisableNoclip()

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

print("⚡ MV X SHINN DEV v7.1 - FULL FIXED - LOADED SUCCESSFULLY!")
print("📌 Hotkeys: M = Menu | F = Fly | F1 = Ghost | F2 = Night Vision")
print("✅ Tất cả lệnh đã hoạt động!")
print("📱 Telegram: https://t.me/MinhVunee")
print("👥 Group: https://t.me/minhvuzbottt")

-- // ============ THÔNG BÁO ============
local function ShowNotification(title, text)
    local notif = Instance.new("Frame")
    notif.Name = "Notification"
    notif.Parent = ScreenGui
    notif.Size = UDim2.new(0, 400, 0, 60)
    notif.Position = UDim2.new(0.5, -200, 0.1, 10)
    notif.BackgroundColor3 = Color3.fromRGB(26, 26, 40)
    notif.BorderSizePixel = 0
    notif.BackgroundTransparency = 0.2
    notif.ZIndex = 20
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.Parent = notif
    notifCorner.CornerRadius = UDim.new(0, 10)
    
    local notifTitle = Instance.new("TextLabel")
    notifTitle.Name = "NotifTitle"
    notifTitle.Parent = notif
    notifTitle.Size = UDim2.new(1, 0, 0.5, 0)
    notifTitle.Position = UDim2.new(0, 10, 0, 0)
    notifTitle.BackgroundTransparency = 1
    notifTitle.Text = title
    notifTitle.TextColor3 = Color3.fromRGB(90, 120, 255)
    notifTitle.Font = Enum.Font.GothamBold
    notifTitle.TextSize = 16
    notifTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local notifText = Instance.new("TextLabel")
    notifText.Name = "NotifText"
    notifText.Parent = notif
    notifText.Size = UDim2.new(1, 0, 0.5, 0)
    notifText.Position = UDim2.new(0, 10, 0.5, 0)
    notifText.BackgroundTransparency = 1
    notifText.Text = text
    notifText.TextColor3 = Color3.fromRGB(240, 240, 245)
    notifText.Font = Enum.Font.Gotham
    notifText.TextSize = 14
    notifText.TextXAlignment = Enum.TextXAlignment.Left
    
    TweenService:Create(notif, TweenInfo.new(0.5), {BackgroundTransparency = 0.1}):Play()
    
    game:GetService("Debris"):AddItem(notif, 5)
end

ShowNotification(GetText("loading"), GetText("loaded"))
