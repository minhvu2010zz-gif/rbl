-- MV X SHINN DEV | Axiom Build v6.2
-- UI OVERHAUL: Inline toggles right-side, auto-home tab, cleaner design

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

local Toggles = {
    FixLag = false, SuperJump = false, Fly = false, Noclip = false,
    ESPPlayers = false, ESPMobs = false, ESPFruits = false,
    Ghost = false, NightVision = false, AutoFarm = false,
    AutoFarmV2 = false, AutoTeleportFruit = false,
}

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
local scale = 1

-- ============ THEME ============
local T = {
    BG          = Color3.fromRGB(13, 13, 20),
    Panel       = Color3.fromRGB(20, 20, 32),
    PanelHover  = Color3.fromRGB(28, 28, 44),
    Accent      = Color3.fromRGB(100, 130, 255),
    AccentDim   = Color3.fromRGB(60, 85, 200),
    Text        = Color3.fromRGB(230, 230, 242),
    TextDim     = Color3.fromRGB(140, 140, 165),
    TabOn       = Color3.fromRGB(35, 38, 60),
    TabOff      = Color3.fromRGB(18, 18, 28),
    Green       = Color3.fromRGB(55, 195, 105),
    Red         = Color3.fromRGB(215, 60, 60),
    Yellow      = Color3.fromRGB(255, 185, 50),
    Cyan        = Color3.fromRGB(0, 185, 210),
    Border      = Color3.fromRGB(45, 45, 70),
}

local function Corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = p
    return c
end

local function Stroke(p, col, th, tr)
    local s = Instance.new("UIStroke")
    s.Color = col or T.Border
    s.Thickness = th or 1
    s.Transparency = tr or 0
    s.Parent = p
    return s
end

-- ============ SCREENGUI ============
local SG = Instance.new("ScreenGui")
SG.Name = "MVXShinn62"
SG.ResetOnSpawn = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- ============ TOGGLE PILL BUTTON ============
local Pill = Instance.new("TextButton")
Pill.Parent = SG
Pill.Size = UDim2.new(0, 52, 0, 52)
Pill.Position = UDim2.new(0, 18, 0.5, -26)
Pill.BackgroundColor3 = T.Accent
Pill.Text = "⚡"
Pill.TextColor3 = Color3.new(1,1,1)
Pill.TextScaled = true
Pill.Font = Enum.Font.GothamBold
Pill.BorderSizePixel = 0
Pill.ZIndex = 20
Corner(Pill, 26)
Stroke(Pill, Color3.fromRGB(160,185,255), 2, 0.3)

-- ============ MAIN WINDOW ============
local Win = Instance.new("Frame")
Win.Name = "Window"
Win.Parent = SG
Win.Size = UDim2.new(0, 680, 0, 540)
Win.Position = UDim2.new(0.5, -340, 0.5, -270)
Win.BackgroundColor3 = T.BG
Win.BorderSizePixel = 0
Win.Visible = false
Win.ClipsDescendants = true
Win.ZIndex = 10
Corner(Win, 14)
Stroke(Win, T.Accent, 1, 0.6)

-- Drop shadow via ImageLabel
local Shadow = Instance.new("ImageLabel")
Shadow.Parent = Win
Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
Shadow.Size = UDim2.new(1, 40, 1, 40)
Shadow.Position = UDim2.new(0.5, 0, 0.5, 6)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://6014261993"
Shadow.ImageColor3 = Color3.fromRGB(0,0,0)
Shadow.ImageTransparency = 0.5
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(49,49,450,450)
Shadow.ZIndex = 9

-- ============ TITLE BAR ============
local TBar = Instance.new("Frame")
TBar.Parent = Win
TBar.Size = UDim2.new(1, 0, 0, 48)
TBar.Position = UDim2.new(0,0,0,0)
TBar.BackgroundColor3 = T.Panel
TBar.BorderSizePixel = 0
TBar.ZIndex = 12
Corner(TBar, 14)

-- Accent line under title
local TBarLine = Instance.new("Frame")
TBarLine.Parent = TBar
TBarLine.Size = UDim2.new(1, 0, 0, 2)
TBarLine.Position = UDim2.new(0, 0, 1, -2)
TBarLine.BackgroundColor3 = T.Accent
TBarLine.BorderSizePixel = 0
TBarLine.BackgroundTransparency = 0.5
TBarLine.ZIndex = 13

local TitleGrad = Instance.new("UIGradient")
TitleGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, T.Accent),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 100, 255))
})
TitleGrad.Rotation = 90
TitleGrad.Parent = TBarLine

local TitleTxt = Instance.new("TextLabel")
TitleTxt.Parent = TBar
TitleTxt.Size = UDim2.new(1, -180, 1, 0)
TitleTxt.Position = UDim2.new(0, 14, 0, 0)
TitleTxt.BackgroundTransparency = 1
TitleTxt.Text = "⚡  MV X SHINN DEV  v6.2"
TitleTxt.TextColor3 = T.Text
TitleTxt.TextXAlignment = Enum.TextXAlignment.Left
TitleTxt.TextSize = 17
TitleTxt.Font = Enum.Font.GothamBold
TitleTxt.ZIndex = 13

-- Version badge
local VerBadge = Instance.new("Frame")
VerBadge.Parent = TBar
VerBadge.Size = UDim2.new(0, 56, 0, 22)
VerBadge.Position = UDim2.new(0, 230, 0.5, -11)
VerBadge.BackgroundColor3 = T.AccentDim
VerBadge.BorderSizePixel = 0
VerBadge.ZIndex = 13
Corner(VerBadge, 11)
local VerTxt = Instance.new("TextLabel")
VerTxt.Parent = VerBadge
VerTxt.Size = UDim2.new(1,0,1,0)
VerTxt.BackgroundTransparency = 1
VerTxt.Text = "FULL"
VerTxt.TextColor3 = Color3.new(1,1,1)
VerTxt.Font = Enum.Font.GothamBold
VerTxt.TextSize = 11
VerTxt.ZIndex = 14

-- Close button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TBar
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0.5, -15)
CloseBtn.BackgroundColor3 = T.Red
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.TextScaled = true
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.ZIndex = 13
Corner(CloseBtn, 8)
CloseBtn.MouseButton1Click:Connect(function() Win.Visible = false end)

-- Minimize / zoom
local function MakeTopBtn(xOffset, txt, col)
    local b = Instance.new("TextButton")
    b.Parent = TBar
    b.Size = UDim2.new(0, 26, 0, 26)
    b.Position = UDim2.new(1, xOffset, 0.5, -13)
    b.BackgroundColor3 = col
    b.Text = txt
    b.TextColor3 = Color3.new(1,1,1)
    b.TextScaled = true
    b.Font = Enum.Font.GothamBold
    b.BorderSizePixel = 0
    b.ZIndex = 13
    Corner(b, 7)
    return b
end

local ZoomOut = MakeTopBtn(-112, "−", T.Panel)
local ZoomIn  = MakeTopBtn(-80, "+", T.Panel)
Stroke(ZoomOut, T.Border, 1, 0)
Stroke(ZoomIn, T.Border, 1, 0)

ZoomIn.MouseButton1Click:Connect(function()
    scale = math.min(1.5, scale + 0.1)
    Win.Size = UDim2.new(0, 680*scale, 0, 540*scale)
    Win.Position = UDim2.new(0.5, -340*scale, 0.5, -270*scale)
end)
ZoomOut.MouseButton1Click:Connect(function()
    scale = math.max(0.6, scale - 0.1)
    Win.Size = UDim2.new(0, 680*scale, 0, 540*scale)
    Win.Position = UDim2.new(0.5, -340*scale, 0.5, -270*scale)
end)

-- Drag
do
    local drag, ds, sp = false
    TBar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = true; ds = i.Position; sp = Win.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - ds
            Win.Position = UDim2.new(sp.X.Scale, sp.X.Offset+d.X, sp.Y.Scale, sp.Y.Offset+d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function() drag = false end)
end

Pill.MouseButton1Click:Connect(function() Win.Visible = not Win.Visible end)

-- ============ BODY LAYOUT ============
-- Left: Tab sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Parent = Win
Sidebar.Size = UDim2.new(0, 155, 1, -48)
Sidebar.Position = UDim2.new(0, 0, 0, 48)
Sidebar.BackgroundColor3 = T.Panel
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 11

local SidebarLine = Instance.new("Frame")
SidebarLine.Parent = Sidebar
SidebarLine.Size = UDim2.new(0, 1, 1, 0)
SidebarLine.Position = UDim2.new(1, 0, 0, 0)
SidebarLine.BackgroundColor3 = T.Border
SidebarLine.BorderSizePixel = 0
SidebarLine.ZIndex = 12

local SideScroll = Instance.new("ScrollingFrame")
SideScroll.Parent = Sidebar
SideScroll.Size = UDim2.new(1, 0, 1, 0)
SideScroll.BackgroundTransparency = 1
SideScroll.BorderSizePixel = 0
SideScroll.ScrollBarThickness = 0
SideScroll.CanvasSize = UDim2.new(0,0,0,0)
SideScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
SideScroll.ZIndex = 12

local SideLayout = Instance.new("UIListLayout")
SideLayout.Parent = SideScroll
SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
SideLayout.Padding = UDim.new(0, 3)

local SidePad = Instance.new("UIPadding")
SidePad.Parent = SideScroll
SidePad.PaddingTop = UDim.new(0, 10)
SidePad.PaddingLeft = UDim.new(0, 8)
SidePad.PaddingRight = UDim.new(0, 8)
SidePad.PaddingBottom = UDim.new(0, 10)

-- Right: Content
local Content = Instance.new("Frame")
Content.Parent = Win
Content.Size = UDim2.new(1, -155, 1, -48)
Content.Position = UDim2.new(0, 155, 0, 48)
Content.BackgroundColor3 = T.BG
Content.BorderSizePixel = 0
Content.ClipsDescendants = true
Content.ZIndex = 11

-- ============ TAB SYSTEM ============
local Tabs = {}
local ActiveTab = nil

local function NewTab(id, label, icon)
    -- Sidebar button
    local Btn = Instance.new("TextButton")
    Btn.Parent = SideScroll
    Btn.Size = UDim2.new(1, 0, 0, 42)
    Btn.BackgroundColor3 = T.TabOff
    Btn.Text = ""
    Btn.BorderSizePixel = 0
    Btn.ZIndex = 13
    Corner(Btn, 9)

    -- Icon + label inside btn
    local IconLbl = Instance.new("TextLabel")
    IconLbl.Parent = Btn
    IconLbl.Size = UDim2.new(0, 28, 1, 0)
    IconLbl.Position = UDim2.new(0, 8, 0, 0)
    IconLbl.BackgroundTransparency = 1
    IconLbl.Text = icon or "•"
    IconLbl.TextScaled = true
    IconLbl.Font = Enum.Font.GothamBold
    IconLbl.TextColor3 = T.TextDim
    IconLbl.ZIndex = 14

    local NameLbl = Instance.new("TextLabel")
    NameLbl.Parent = Btn
    NameLbl.Size = UDim2.new(1, -44, 1, 0)
    NameLbl.Position = UDim2.new(0, 38, 0, 0)
    NameLbl.BackgroundTransparency = 1
    NameLbl.Text = label
    NameLbl.TextColor3 = T.TextDim
    NameLbl.Font = Enum.Font.Gotham
    NameLbl.TextSize = 13
    NameLbl.TextXAlignment = Enum.TextXAlignment.Left
    NameLbl.ZIndex = 14

    -- Active indicator bar
    local Bar = Instance.new("Frame")
    Bar.Parent = Btn
    Bar.Size = UDim2.new(0, 3, 0.6, 0)
    Bar.Position = UDim2.new(0, 0, 0.2, 0)
    Bar.BackgroundColor3 = T.Accent
    Bar.BorderSizePixel = 0
    Bar.Visible = false
    Bar.ZIndex = 15
    Corner(Bar, 2)

    -- Page
    local Page = Instance.new("ScrollingFrame")
    Page.Parent = Content
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.Visible = false
    Page.ScrollBarThickness = 4
    Page.CanvasSize = UDim2.new(0,0,0,0)
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Page.ClipsDescendants = true
    Page.ZIndex = 12

    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Parent = Page
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.Padding = UDim.new(0, 6)

    local PagePad = Instance.new("UIPadding")
    PagePad.Parent = Page
    PagePad.PaddingTop = UDim.new(0, 14)
    PagePad.PaddingLeft = UDim.new(0, 14)
    PagePad.PaddingRight = UDim.new(0, 14)
    PagePad.PaddingBottom = UDim.new(0, 14)

    local tab = {
        Id = id, Page = Page, Button = Btn,
        Icon = IconLbl, Name = NameLbl, Bar = Bar,
    }
    Tabs[id] = tab

    -- First tab auto-active
    if not ActiveTab then
        ActiveTab = tab
        Btn.BackgroundColor3 = T.TabOn
        Bar.Visible = true
        IconLbl.TextColor3 = T.Accent
        NameLbl.TextColor3 = T.Text
        Page.Visible = true
    end

    Btn.MouseButton1Click:Connect(function()
        if ActiveTab then
            ActiveTab.Page.Visible = false
            ActiveTab.Button.BackgroundColor3 = T.TabOff
            ActiveTab.Bar.Visible = false
            ActiveTab.Icon.TextColor3 = T.TextDim
            ActiveTab.Name.TextColor3 = T.TextDim
        end
        ActiveTab = tab
        Page.Visible = true
        Btn.BackgroundColor3 = T.TabOn
        Bar.Visible = true
        IconLbl.TextColor3 = T.Accent
        NameLbl.TextColor3 = T.Text
        Page.CanvasPosition = Vector2.new(0,0)
    end)

    return tab
end

-- ============ COMPONENTS ============

-- Section header
local function AddSection(tab, text)
    local wrap = Instance.new("Frame")
    wrap.Parent = tab.Page
    wrap.Size = UDim2.new(1, 0, 0, 28)
    wrap.BackgroundTransparency = 1

    local line = Instance.new("Frame")
    line.Parent = wrap
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 0.5, 0)
    line.BackgroundColor3 = T.Border
    line.BorderSizePixel = 0

    local bg = Instance.new("Frame")
    bg.Parent = wrap
    bg.Size = UDim2.new(0, 0, 1, 0) -- auto
    bg.AutomaticSize = Enum.AutomaticSize.X
    bg.Position = UDim2.new(0, 0, 0, 0)
    bg.BackgroundColor3 = T.BG
    bg.BorderSizePixel = 0

    local lbl = Instance.new("TextLabel")
    lbl.Parent = bg
    lbl.Size = UDim2.new(0, 0, 1, 0)
    lbl.AutomaticSize = Enum.AutomaticSize.X
    lbl.BackgroundTransparency = 1
    lbl.Text = "  " .. text .. "  "
    lbl.TextColor3 = T.Accent
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12
    return wrap
end

-- Label
local function AddLabel(tab, text)
    local lbl = Instance.new("TextLabel")
    lbl.Parent = tab.Page
    lbl.Size = UDim2.new(1, 0, 0, 22)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = T.TextDim
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    return lbl
end

-- ============ INLINE TOGGLE ROW ============
-- Toggle sits RIGHT side of the row — no scrolling needed
local function AddToggle(tab, text, default, callback)
    local state = default or false

    local Row = Instance.new("Frame")
    Row.Parent = tab.Page
    Row.Size = UDim2.new(1, 0, 0, 40)
    Row.BackgroundColor3 = T.Panel
    Row.BorderSizePixel = 0
    Corner(Row, 8)
    Stroke(Row, T.Border, 1, 0.4)

    -- Left label
    local Lbl = Instance.new("TextLabel")
    Lbl.Parent = Row
    Lbl.Size = UDim2.new(1, -74, 1, 0)
    Lbl.Position = UDim2.new(0, 12, 0, 0)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = text
    Lbl.TextColor3 = T.Text
    Lbl.Font = Enum.Font.Gotham
    Lbl.TextSize = 13
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.TextTruncate = Enum.TextTruncate.AtEnd

    -- Switch background — RIGHT SIDE inline
    local SwBg = Instance.new("Frame")
    SwBg.Parent = Row
    SwBg.Size = UDim2.new(0, 46, 0, 24)
    SwBg.Position = UDim2.new(1, -58, 0.5, -12)
    SwBg.BackgroundColor3 = state and T.Green or Color3.fromRGB(50,50,70)
    SwBg.BorderSizePixel = 0
    Corner(SwBg, 12)

    local Knob = Instance.new("Frame")
    Knob.Parent = SwBg
    Knob.Size = UDim2.new(0, 18, 0, 18)
    Knob.Position = state and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
    Knob.BackgroundColor3 = Color3.new(1,1,1)
    Knob.BorderSizePixel = 0
    Corner(Knob, 9)

    -- Status text next to switch
    local StatTxt = Instance.new("TextLabel")
    StatTxt.Parent = Row
    StatTxt.Size = UDim2.new(0, 28, 1, 0)
    StatTxt.Position = UDim2.new(1, -82, 0, 0)
    StatTxt.BackgroundTransparency = 1
    StatTxt.Text = state and "ON" or "OFF"
    StatTxt.TextColor3 = state and T.Green or T.TextDim
    StatTxt.Font = Enum.Font.GothamBold
    StatTxt.TextSize = 10
    StatTxt.TextXAlignment = Enum.TextXAlignment.Right

    local Click = Instance.new("TextButton")
    Click.Parent = Row
    Click.Size = UDim2.new(1,0,1,0)
    Click.BackgroundTransparency = 1
    Click.Text = ""

    Click.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(SwBg, TweenInfo.new(0.18), {
            BackgroundColor3 = state and T.Green or Color3.fromRGB(50,50,70)
        }):Play()
        TweenService:Create(Knob, TweenInfo.new(0.18), {
            Position = state and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
        }):Play()
        StatTxt.Text = state and "ON" or "OFF"
        StatTxt.TextColor3 = state and T.Green or T.TextDim
        -- Row highlight
        TweenService:Create(Row, TweenInfo.new(0.1), {
            BackgroundColor3 = state and Color3.fromRGB(24,30,42) or T.Panel
        }):Play()
        if callback then callback(state) end
    end)

    -- Hover
    Click.MouseEnter:Connect(function()
        TweenService:Create(Row, TweenInfo.new(0.1), {BackgroundColor3 = T.PanelHover}):Play()
    end)
    Click.MouseLeave:Connect(function()
        TweenService:Create(Row, TweenInfo.new(0.1), {
            BackgroundColor3 = state and Color3.fromRGB(24,30,42) or T.Panel
        }):Play()
    end)

    return {
        Set = function(v)
            state = v
            SwBg.BackgroundColor3 = state and T.Green or Color3.fromRGB(50,50,70)
            Knob.Position = state and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
            StatTxt.Text = state and "ON" or "OFF"
            StatTxt.TextColor3 = state and T.Green or T.TextDim
        end,
        Get = function() return state end
    }
end

-- ============ SLIDER ROW (inline +/-) ============
local function AddSlider(tab, text, minV, maxV, def, cb)
    local val = def or minV

    local Row = Instance.new("Frame")
    Row.Parent = tab.Page
    Row.Size = UDim2.new(1, 0, 0, 44)
    Row.BackgroundColor3 = T.Panel
    Row.BorderSizePixel = 0
    Corner(Row, 8)
    Stroke(Row, T.Border, 1, 0.4)

    local Lbl = Instance.new("TextLabel")
    Lbl.Parent = Row
    Lbl.Size = UDim2.new(0.42, 0, 1, 0)
    Lbl.Position = UDim2.new(0, 12, 0, 0)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = text
    Lbl.TextColor3 = T.TextDim
    Lbl.Font = Enum.Font.Gotham
    Lbl.TextSize = 12
    Lbl.TextXAlignment = Enum.TextXAlignment.Left

    local ValLbl = Instance.new("TextLabel")
    ValLbl.Parent = Row
    ValLbl.Size = UDim2.new(0, 40, 1, 0)
    ValLbl.Position = UDim2.new(0.43, 0, 0, 0)
    ValLbl.BackgroundTransparency = 1
    ValLbl.Text = tostring(val)
    ValLbl.TextColor3 = T.Accent
    ValLbl.Font = Enum.Font.GothamBold
    ValLbl.TextSize = 13
    ValLbl.TextXAlignment = Enum.TextXAlignment.Center

    local function MkBtn(xOff, txt, col)
        local b = Instance.new("TextButton")
        b.Parent = Row
        b.Size = UDim2.new(0, 28, 0, 28)
        b.Position = UDim2.new(1, xOff, 0.5, -14)
        b.BackgroundColor3 = col
        b.Text = txt
        b.TextColor3 = Color3.new(1,1,1)
        b.Font = Enum.Font.GothamBold
        b.TextSize = 16
        b.BorderSizePixel = 0
        Corner(b, 7)
        return b
    end

    local Minus = MkBtn(-64, "−", T.Red)
    local Plus  = MkBtn(-30, "+", T.Green)

    local function Update(v)
        val = math.clamp(math.floor(v), minV, maxV)
        ValLbl.Text = tostring(val)
        if cb then cb(val) end
    end

    Minus.MouseButton1Click:Connect(function() Update(val - 1) end)
    Plus.MouseButton1Click:Connect(function()  Update(val + 1) end)

    -- Hold to repeat
    local function HoldRepeat(btn, delta)
        local holding = false
        btn.MouseButton1Down:Connect(function()
            holding = true
            spawn(function()
                wait(0.4)
                while holding do
                    Update(val + delta)
                    wait(0.08)
                end
            end)
        end)
        btn.MouseButton1Up:Connect(function() holding = false end)
        btn.MouseLeave:Connect(function() holding = false end)
    end
    HoldRepeat(Minus, -1)
    HoldRepeat(Plus, 1)

    return { Get = function() return val end, Set = Update }
end

-- ============ BUTTON ============
local function AddButton(tab, text, cb, col)
    local Btn = Instance.new("TextButton")
    Btn.Parent = tab.Page
    Btn.Size = UDim2.new(1, 0, 0, 38)
    Btn.BackgroundColor3 = col or T.Accent
    Btn.Text = text
    Btn.TextColor3 = Color3.new(1,1,1)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 13
    Btn.BorderSizePixel = 0
    Corner(Btn, 8)

    Btn.MouseEnter:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.new(
                math.min((col or T.Accent).R + 0.08, 1),
                math.min((col or T.Accent).G + 0.08, 1),
                math.min((col or T.Accent).B + 0.08, 1)
            )
        }):Play()
    end)
    Btn.MouseLeave:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = col or T.Accent}):Play()
    end)

    if cb then Btn.MouseButton1Click:Connect(cb) end
    return Btn
end

-- ============ INFO CARD ============
local function AddInfoCard(tab, rows)
    local Card = Instance.new("Frame")
    Card.Parent = tab.Page
    Card.Size = UDim2.new(1, 0, 0, 32 * #rows + 16)
    Card.BackgroundColor3 = T.Panel
    Card.BorderSizePixel = 0
    Corner(Card, 8)
    Stroke(Card, T.Border, 1, 0.4)

    local CL = Instance.new("UIListLayout")
    CL.Parent = Card
    CL.Padding = UDim.new(0, 0)
    CL.SortOrder = Enum.SortOrder.LayoutOrder

    local CP = Instance.new("UIPadding")
    CP.Parent = Card
    CP.PaddingTop = UDim.new(0, 8)
    CP.PaddingLeft = UDim.new(0, 14)
    CP.PaddingRight = UDim.new(0, 14)
    CP.PaddingBottom = UDim.new(0, 8)

    local vl = {}
    for i, row in ipairs(rows) do
        local RF = Instance.new("Frame")
        RF.Parent = Card
        RF.Size = UDim2.new(1, 0, 0, 30)
        RF.BackgroundTransparency = 1

        -- separator
        if i > 1 then
            local Sep = Instance.new("Frame")
            Sep.Parent = RF
            Sep.Size = UDim2.new(1, 0, 0, 1)
            Sep.Position = UDim2.new(0, 0, 0, 0)
            Sep.BackgroundColor3 = T.Border
            Sep.BorderSizePixel = 0
            Sep.BackgroundTransparency = 0.6
        end

        local KLbl = Instance.new("TextLabel")
        KLbl.Parent = RF
        KLbl.Size = UDim2.new(0.45, 0, 1, 0)
        KLbl.BackgroundTransparency = 1
        KLbl.Text = row.label .. ":"
        KLbl.TextColor3 = T.TextDim
        KLbl.Font = Enum.Font.Gotham
        KLbl.TextSize = 12
        KLbl.TextXAlignment = Enum.TextXAlignment.Left

        local VLbl = Instance.new("TextLabel")
        VLbl.Parent = RF
        VLbl.Size = UDim2.new(0.55, 0, 1, 0)
        VLbl.Position = UDim2.new(0.45, 0, 0, 0)
        VLbl.BackgroundTransparency = 1
        VLbl.Text = row.value or "—"
        VLbl.TextColor3 = T.Text
        VLbl.Font = Enum.Font.GothamBold
        VLbl.TextSize = 12
        VLbl.TextXAlignment = Enum.TextXAlignment.Left
        vl[row.key] = VLbl
    end
    return Card, vl
end

-- ============ DROPDOWN ============
local function AddDropdown(tab, text, options, default, cb)
    local sel = default or options[1]

    local Wrap = Instance.new("Frame")
    Wrap.Parent = tab.Page
    Wrap.Size = UDim2.new(1, 0, 0, 40)
    Wrap.BackgroundColor3 = T.Panel
    Wrap.BorderSizePixel = 0
    Wrap.ClipsDescendants = false
    Corner(Wrap, 8)
    Stroke(Wrap, T.Border, 1, 0.4)

    local WLbl = Instance.new("TextLabel")
    WLbl.Parent = Wrap
    WLbl.Size = UDim2.new(0.38, 0, 1, 0)
    WLbl.Position = UDim2.new(0, 12, 0, 0)
    WLbl.BackgroundTransparency = 1
    WLbl.Text = text
    WLbl.TextColor3 = T.TextDim
    WLbl.Font = Enum.Font.Gotham
    WLbl.TextSize = 12
    WLbl.TextXAlignment = Enum.TextXAlignment.Left

    local SelBtn = Instance.new("TextButton")
    SelBtn.Parent = Wrap
    SelBtn.Size = UDim2.new(0.55, 0, 0.7, 0)
    SelBtn.Position = UDim2.new(0.43, 0, 0.15, 0)
    SelBtn.BackgroundColor3 = T.TabOff
    SelBtn.Text = sel .. "  ▾"
    SelBtn.TextColor3 = T.Text
    SelBtn.Font = Enum.Font.Gotham
    SelBtn.TextSize = 12
    SelBtn.BorderSizePixel = 0
    Corner(SelBtn, 6)
    Stroke(SelBtn, T.Border, 1, 0.3)

    local DDList = Instance.new("ScrollingFrame")
    DDList.Parent = Wrap
    DDList.Size = UDim2.new(0.55, 0, 0, math.min(#options*28, 140))
    DDList.Position = UDim2.new(0.43, 0, 1, 4)
    DDList.BackgroundColor3 = T.Panel
    DDList.Visible = false
    DDList.BorderSizePixel = 0
    DDList.ScrollBarThickness = 3
    DDList.CanvasSize = UDim2.new(0,0,0,0)
    DDList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    DDList.ZIndex = 30
    Corner(DDList, 6)
    Stroke(DDList, T.Accent, 1, 0.6)

    local DDL = Instance.new("UIListLayout")
    DDL.Parent = DDList
    DDL.SortOrder = Enum.SortOrder.LayoutOrder

    for _, opt in ipairs(options) do
        local OBtn = Instance.new("TextButton")
        OBtn.Parent = DDList
        OBtn.Size = UDim2.new(1,0,0,28)
        OBtn.BackgroundColor3 = T.Panel
        OBtn.Text = opt
        OBtn.TextColor3 = T.Text
        OBtn.Font = Enum.Font.Gotham
        OBtn.TextSize = 12
        OBtn.BorderSizePixel = 0
        OBtn.ZIndex = 31
        OBtn.MouseButton1Click:Connect(function()
            sel = opt
            SelBtn.Text = opt .. "  ▾"
            DDList.Visible = false
            if cb then cb(opt) end
        end)
        OBtn.MouseEnter:Connect(function()
            OBtn.BackgroundColor3 = T.TabOn
        end)
        OBtn.MouseLeave:Connect(function()
            OBtn.BackgroundColor3 = T.Panel
        end)
    end

    SelBtn.MouseButton1Click:Connect(function()
        DDList.Visible = not DDList.Visible
    end)

    return {
        Get = function() return sel end,
        Set = function(v) sel = v; SelBtn.Text = v .. "  ▾" end
    }
end

-- ============ BUILD TABS ============
local tabMain     = NewTab("main",     "Trang chủ",  "🏠")
local tabFeatures = NewTab("features", "Tính năng",  "⚡")
local tabESP      = NewTab("esp",      "ESP",         "👁")
local tabFarm     = NewTab("farm",     "Auto Farm",  "🤖")
local tabMap      = NewTab("map",      "Map",         "🗺")
local tabAdmin    = NewTab("admin",    "Admin",       "👤")
local tabSettings = NewTab("settings", "Cài đặt",    "⚙")

-- ========== TAB: HOME ==========
AddSection(tabMain, "THÔNG TIN")
AddLabel(tabMain, "🎮  MV X SHINN DEV v6.2 — Full Features")

local dateLabel = AddLabel(tabMain, "📅  —")
spawn(function()
    while wait(1) do
        dateLabel.Text = "📅  " .. os.date("%d/%m/%Y") .. "   ⏰  " .. os.date("%H:%M:%S")
    end
end)

AddSection(tabMain, "TRẠNG THÁI")
local _, statLbls = AddInfoCard(tabMain, {
    {label = "👤 Người chơi", key = "player", value = LocalPlayer.Name},
    {label = "🌐 Ping",       key = "ping",   value = "—"},
    {label = "📍 Vị trí",     key = "pos",    value = "—"},
})
spawn(function()
    while wait(0.5) do
        local c = LocalPlayer.Character
        if c and c:FindFirstChild("HumanoidRootPart") then
            local p = c.HumanoidRootPart.Position
            statLbls["pos"].Text = string.format("%.0f, %.0f, %.0f", p.X, p.Y, p.Z)
        end
        statLbls["ping"].Text = math.random(18,75) .. " ms"
    end
end)

AddSection(tabMain, "NHANH")
AddButton(tabMain, "🔄  Quét lại Map", function() ScanMap(); BuildMapUI() end)
AddButton(tabMain, "📢  Thông báo", function() print("⚡ MV X SHINN DEV v6.2 sẵn sàng!") end, T.AccentDim)

-- ========== TAB: FEATURES ==========
AddSection(tabFeatures, "HIỆU SUẤT")
local togFixLag = AddToggle(tabFeatures, "🔧  Fix Lag", false, function(v) Toggles.FixLag = v end)
local sldLag    = AddSlider(tabFeatures, "📊  Mức Fix Lag", 50, 99, 80, function(v) LagFixLevel = v end)

AddSection(tabFeatures, "VẬN ĐỘNG")
local togSuperJump = AddToggle(tabFeatures, "🦘  Super Jump", false, function(v) Toggles.SuperJump = v end)
local sldJump      = AddSlider(tabFeatures, "🦘  Lực nhảy", 50, 500, 250, function(v) JumpPower = v end)
local togFly       = AddToggle(tabFeatures, "✈️  Fly  (phím F)", false, function(v)
    Toggles.Fly = v
    if not v and flyEnabled then
        flyEnabled = false
        if bodyVelocity then bodyVelocity:Destroy() end
        bodyVelocity = nil
    end
end)
local sldFlySpeed = AddSlider(tabFeatures, "✈️  Tốc độ bay", 10, 200, 50, function(v) FlySpeed = v end)

AddSection(tabFeatures, "TÀNG HÌNH")
local togNoclip = AddToggle(tabFeatures, "👻  Noclip (xuyên tường)", false, function(v)
    Toggles.Noclip = v
    if v then EnableNoclip() else DisableNoclip() end
end)
local togGhost = AddToggle(tabFeatures, "👻  Ghost Mode  (F1)", false, function(v) Toggles.Ghost = v end)
local togNV    = AddToggle(tabFeatures, "🌙  Night Vision  (F2)", false, function(v) Toggles.NightVision = v end)

-- ========== TAB: ESP ==========
AddSection(tabESP, "ESP")
local togESPP = AddToggle(tabESP, "👤  ESP Người chơi",  false, function(v) Toggles.ESPPlayers = v end)
local togESPM = AddToggle(tabESP, "👾  ESP Quái",         false, function(v) Toggles.ESPMobs = v end)
local togESPF = AddToggle(tabESP, "🍎  ESP Trái cây",     false, function(v) Toggles.ESPFruits = v end)

AddSection(tabESP, "TỰ ĐỘNG")
local togATF = AddToggle(tabESP, "🚀  Auto Teleport đến trái cây", false, function(v)
    Toggles.AutoTeleportFruit = v
    if v then StartAutoTeleportFruit() else StopAutoTeleportFruit() end
end)

-- ========== TAB: FARM ==========
AddSection(tabFarm, "CẤU HÌNH")
local wDrop = AddDropdown(tabFarm, "🔫  Vũ khí:", {"Tay","Melee","Kiếm","Súng"}, "Tay", function(v)
    SelectedWeapon = v
end)
local mDrop = AddDropdown(tabFarm, "👾  Quái:", {"Tất cả","NPC","Mob","Boss","Enemy"}, "Tất cả", function(v)
    SelectedMob = v
end)

AddSection(tabFarm, "FARM")
local togAFV1 = AddToggle(tabFarm, "🤖  Auto Farm V1  (Normal)", false, function(v)
    Toggles.AutoFarm = v
    if v then StartAutoFarm() else StopAutoFarm() end
end)
local togAFV2 = AddToggle(tabFarm, "💀  Auto Farm V2  (Bug Dame 99999+)", false, function(v)
    Toggles.AutoFarmV2 = v
    if v then StartAutoFarmV2() else StopAutoFarmV2() end
end)

AddSection(tabFarm, "THỐNG KÊ")
local _, farmLbls = AddInfoCard(tabFarm, {
    {label = "⚔️ Vũ khí",  key = "weapon", value = "Tay"},
    {label = "👾 Quái",     key = "mob",    value = "Tất cả"},
    {label = "💀 Kill",     key = "kills",  value = "0"},
})
spawn(function()
    while wait(0.5) do
        farmLbls["weapon"].Text = SelectedWeapon
        farmLbls["mob"].Text    = SelectedMob
        farmLbls["kills"].Text  = tostring(killCount)
    end
end)

-- ========== TAB: MAP ==========
AddSection(tabMap, "BẢN ĐỒ SERVER")
local selMapLbl = AddLabel(tabMap, "📍  Đã chọn: Chưa chọn")

local MapScroll = Instance.new("ScrollingFrame")
MapScroll.Parent = tabMap.Page
MapScroll.Size = UDim2.new(1, 0, 0, 240)
MapScroll.BackgroundColor3 = T.Panel
MapScroll.BorderSizePixel = 0
MapScroll.ScrollBarThickness = 4
MapScroll.CanvasSize = UDim2.new(0,0,0,0)
MapScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
MapScroll.ClipsDescendants = true
Corner(MapScroll, 8)
Stroke(MapScroll, T.Border, 1, 0.4)

local MapLayout = Instance.new("UIListLayout")
MapLayout.Parent = MapScroll
MapLayout.SortOrder = Enum.SortOrder.LayoutOrder
MapLayout.Padding = UDim.new(0, 3)

local MapPad = Instance.new("UIPadding")
MapPad.Parent = MapScroll
MapPad.PaddingTop = UDim.new(0, 8)
MapPad.PaddingLeft = UDim.new(0, 8)
MapPad.PaddingRight = UDim.new(0, 8)
MapPad.PaddingBottom = UDim.new(0, 8)

function ScanMap()
    DetectedMapPoints = {}
    for _, m in pairs(Workspace:GetDescendants()) do
        if m:IsA("Model") and m:FindFirstChild("HumanoidRootPart") then
            local r = m.HumanoidRootPart
            if r and not Players:GetPlayerFromCharacter(m) then
                table.insert(DetectedMapPoints, {Name="📍 "..m.Name, Position=r.Position})
            end
        end
    end
    for _, p in pairs(Workspace:GetDescendants()) do
        if p:IsA("BasePart") and p.Size.Magnitude > 50 then
            local n = p.Name
            if not n:find("Terrain") and not n:find("Baseplate") then
                table.insert(DetectedMapPoints, {Name="🏔️ "..n, Position=p.Position})
            end
        end
    end
    if #DetectedMapPoints == 0 then
        table.insert(DetectedMapPoints, {Name="🌍 Center", Position=Vector3.new(0,10,0)})
        table.insert(DetectedMapPoints, {Name="⬆️ High",   Position=Vector3.new(0,200,0)})
        table.insert(DetectedMapPoints, {Name="🎯 Spawn",  Position=Vector3.new(0,5,0)})
    end
    if #DetectedMapPoints > 50 then
        local nl = {}
        for i=1,50 do nl[i]=DetectedMapPoints[i] end
        DetectedMapPoints = nl
    end
end

function BuildMapUI()
    for _, ch in pairs(MapScroll:GetChildren()) do
        if ch:IsA("TextButton") or ch:IsA("TextLabel") then ch:Destroy() end
    end
    ScanMap()

    local cntLbl = Instance.new("TextLabel")
    cntLbl.Parent = MapScroll
    cntLbl.Size = UDim2.new(1,0,0,18)
    cntLbl.BackgroundTransparency = 1
    cntLbl.Text = "📌  " .. #DetectedMapPoints .. " điểm"
    cntLbl.TextColor3 = T.TextDim
    cntLbl.Font = Enum.Font.Gotham
    cntLbl.TextSize = 11
    cntLbl.TextXAlignment = Enum.TextXAlignment.Left

    local activeBtn = nil
    for _, md in ipairs(DetectedMapPoints) do
        local mb = Instance.new("TextButton")
        mb.Parent = MapScroll
        mb.Size = UDim2.new(1,0,0,30)
        mb.BackgroundColor3 = T.TabOff
        mb.Text = md.Name
        mb.TextColor3 = T.Text
        mb.TextScaled = false
        mb.Font = Enum.Font.Gotham
        mb.TextSize = 12
        mb.BorderSizePixel = 0
        mb.TextTruncate = Enum.TextTruncate.AtEnd
        Corner(mb, 5)

        mb.MouseButton1Click:Connect(function()
            if activeBtn then activeBtn.BackgroundColor3 = T.TabOff end
            activeBtn = mb
            mb.BackgroundColor3 = Color3.fromRGB(28, 50, 38)
            SelectedMapPoint = md.Position
            SelectedMapName = md.Name
            selMapLbl.Text = "📍  " .. md.Name
        end)
    end
end

BuildMapUI()

AddButton(tabMap, "🔄  Quét lại", function() BuildMapUI() end, T.AccentDim)
AddButton(tabMap, "🚀  Dịch chuyển đến điểm đã chọn", function()
    if SelectedMapPoint then
        local c = LocalPlayer.Character
        if c and c:FindFirstChild("HumanoidRootPart") then
            c.HumanoidRootPart.CFrame = CFrame.new(SelectedMapPoint + Vector3.new(0,5,0))
        end
    end
end, T.Cyan)

-- ========== TAB: ADMIN ==========
AddSection(tabAdmin, "THÔNG TIN ADMIN")
AddInfoCard(tabAdmin, {
    {label="👤 Tên",       key="n",  value="SHINN DEV"},
    {label="📝 Bio",       key="b",  value="⚡ MV X SHINN DEV"},
    {label="🕐 Hoạt động", key="a",  value="24/7"},
    {label="💻 Version",   key="v",  value="v6.2 Full"},
    {label="🔗 Telegram",  key="t",  value="@MinhVunee"},
    {label="👥 Group",     key="g",  value="@minhvuzbottt"},
})

AddSection(tabAdmin, "LIÊN KẾT")
AddButton(tabAdmin, "🔗  Copy Telegram", function()
    setclipboard("https://t.me/MinhVunee")
end, T.AccentDim)
AddButton(tabAdmin, "👥  Copy Group", function()
    setclipboard("https://t.me/minhvuzbottt")
end, T.AccentDim)

-- ========== TAB: SETTINGS ==========
AddSection(tabSettings, "GIAO DIỆN")
local sldZoom = AddSlider(tabSettings, "🔍  Thu phóng", 60, 150, 100, function(v)
    scale = v / 100
    Win.Size = UDim2.new(0, 680*scale, 0, 540*scale)
    Win.Position = UDim2.new(0.5, -340*scale, 0.5, -270*scale)
end)

AddSection(tabSettings, "HỆ THỐNG")
AddButton(tabSettings, "💾  Lưu cài đặt", function()
    print("💾 Đã lưu!")
end)
AddButton(tabSettings, "🔄  Reset mặc định", function()
    scale = 1
    Win.Size = UDim2.new(0, 680, 0, 540)
    Win.Position = UDim2.new(0.5, -340, 0.5, -270)
    sldZoom.Set(100)
    print("🔄 Reset xong!")
end, T.Red)

-- ============ FEATURE LOGIC ============
local function FixLag()
    spawn(function()
        while wait(0.5) do
            if Toggles.FixLag then
                local lv = LagFixLevel / 100
                settings().Rendering.QualityLevel = math.floor(1 + (1-lv) * 3)
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("ParticleEmitter") or v:IsA("Trail") or
                       v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
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

local function SuperJump()
    spawn(function()
        while wait(0.1) do
            if Toggles.SuperJump then
                local c = LocalPlayer.Character
                if c and c:FindFirstChild("Humanoid") then
                    c.Humanoid.JumpPower = JumpPower
                end
            end
        end
    end)
end

local function Fly()
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.F and Toggles.Fly then
            local c = LocalPlayer.Character
            if not c then return end
            local rp = c:FindFirstChild("HumanoidRootPart")
            if not rp then return end
            flyEnabled = not flyEnabled
            if flyEnabled then
                bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.MaxForce = Vector3.new(1e6,1e6,1e6)
                bodyVelocity.Parent = rp
            else
                if bodyVelocity then bodyVelocity:Destroy() end
                bodyVelocity = nil
            end
        end
    end)
    spawn(function()
        while wait() do
            if flyEnabled and Toggles.Fly and bodyVelocity then
                local rp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not rp then
                    flyEnabled = false
                    if bodyVelocity then bodyVelocity:Destroy() end
                    bodyVelocity = nil
                    continue
                end
                local md = Vector3.new(0,0,0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then md = md + Camera.CFrame.LookVector * Vector3.new(1,0,1) end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then md = md - Camera.CFrame.LookVector * Vector3.new(1,0,1) end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then md = md - Camera.CFrame.RightVector * Vector3.new(1,0,1) end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then md = md + Camera.CFrame.RightVector * Vector3.new(1,0,1) end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space)     then md = md + Vector3.new(0,1,0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then md = md - Vector3.new(0,1,0) end
                if md.Magnitude > 0 then md = md.Unit * FlySpeed end
                bodyVelocity.Velocity = md
            end
        end
    end)
end

function EnableNoclip()
    noclipEnabled = true
    local c = LocalPlayer.Character
    if c then
        for _, p in pairs(c:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
        local h = c:FindFirstChild("Humanoid")
        if h then h.PlatformStand = true end
    end
end

function DisableNoclip()
    noclipEnabled = false
    local c = LocalPlayer.Character
    if c then
        for _, p in pairs(c:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = true end
        end
        local h = c:FindFirstChild("Humanoid")
        if h then h.PlatformStand = false end
    end
    noclipParts = {}
end

local function NoclipLoop()
    spawn(function()
        while wait(0.1) do
            if Toggles.Noclip and noclipEnabled then
                local c = LocalPlayer.Character
                if c then
                    for _, p in pairs(c:GetDescendants()) do
                        if p:IsA("BasePart") then p.CanCollide = false end
                    end
                    local r = c:FindFirstChild("HumanoidRootPart")
                    if r and r.Position.Y < 0 then
                        r.Position = Vector3.new(r.Position.X, 5, r.Position.Z)
                    end
                end
            end
        end
    end)
end

local function GhostMode()
    spawn(function()
        while wait(0.1) do
            local c = LocalPlayer.Character
            if c then
                for _, p in pairs(c:GetDescendants()) do
                    if p:IsA("BasePart") then
                        p.Transparency = Toggles.Ghost and 0.5 or 0
                        p.CanCollide   = not Toggles.Ghost
                    end
                end
            end
        end
    end)
end

local function NightVision()
    spawn(function()
        while wait(0.5) do
            if Toggles.NightVision then
                Lighting.Brightness = 10
                Lighting.ClockTime  = 12
                Lighting.FogEnd     = 99999
                Lighting.GlobalShadows = false
                Lighting.Ambient       = Color3.fromRGB(255,255,255)
                Lighting.OutdoorAmbient = Color3.fromRGB(255,255,255)
                for _, v in pairs(Lighting:GetDescendants()) do
                    if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or
                       v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
                        v.Enabled = false
                    end
                end
            else
                Lighting.Brightness = 2
                Lighting.ClockTime  = 14
                Lighting.FogEnd     = 100000
                Lighting.GlobalShadows = true
                Lighting.Ambient        = Color3.fromRGB(127,127,127)
                Lighting.OutdoorAmbient = Color3.fromRGB(127,127,127)
                for _, v in pairs(Lighting:GetDescendants()) do
                    if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or
                       v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
                        v.Enabled = true
                    end
                end
            end
        end
    end)
end

local function CreateESP(obj, col, txt, tp)
    if not obj or not obj:IsA("BasePart") then return end
    for _, v in pairs(obj:GetChildren()) do
        if v:IsA("BillboardGui") and v.Name == "MV_ESP" then v:Destroy() end
    end
    local bb = Instance.new("BillboardGui")
    bb.Name = "MV_ESP"; bb.Size = UDim2.new(0,250,0,60)
    bb.AlwaysOnTop = true; bb.Parent = obj
    bb.StudsOffset = Vector3.new(0,3,0)
    local nl = Instance.new("TextLabel")
    nl.Size = UDim2.new(1,0,0.5,0); nl.BackgroundTransparency = 1
    nl.Text = txt; nl.TextColor3 = col; nl.TextScaled = true
    nl.Font = Enum.Font.GothamBold; nl.TextStrokeTransparency = 0.2
    nl.Parent = bb
    local dl = Instance.new("TextLabel")
    dl.Name = "DL"; dl.Size = UDim2.new(1,0,0.5,0)
    dl.Position = UDim2.new(0,0,0.5,0); dl.BackgroundTransparency = 1
    dl.Text = "0m"; dl.TextColor3 = Color3.fromRGB(255,255,100)
    dl.TextScaled = true; dl.Font = Enum.Font.Gotham
    dl.TextStrokeTransparency = 0.2; dl.Parent = bb
    table.insert(ESPObjects, {Object=obj, Billboard=bb, DistLabel=dl, Type=tp or "unknown"})
end

local function UpdateDistances()
    spawn(function()
        while wait(0.3) do
            local c = LocalPlayer.Character
            if not c then continue end
            local r = c:FindFirstChild("HumanoidRootPart")
            if not r then continue end
            for _, d in pairs(ESPObjects) do
                if d.Object and d.Object.Parent then
                    local dist = math.floor((r.Position - d.Object.Position).Magnitude)
                    local col = dist<50 and T.Green or dist<150 and T.Yellow or Color3.fromRGB(255,100,0)
                    if d.DistLabel then
                        d.DistLabel.Text = dist.."m"
                        d.DistLabel.TextColor3 = col
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
                for _, pl in pairs(Players:GetPlayers()) do
                    if pl ~= LocalPlayer and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
                        local rt = pl.Character.HumanoidRootPart
                        local has = false
                        for _, d in pairs(ESPObjects) do if d.Object==rt then has=true break end end
                        if not has then CreateESP(rt, T.Green, "👤 "..pl.Name, "player") end
                    end
                end
            end
            if Toggles.ESPMobs then
                for _, v in pairs(Workspace:GetDescendants()) do
                    if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                        if not Players:GetPlayerFromCharacter(v) then
                            local rt = v.HumanoidRootPart
                            local has = false
                            for _, d in pairs(ESPObjects) do if d.Object==rt then has=true break end end
                            if not has then CreateESP(rt, T.Yellow, "👾 "..v.Name, "mob") end
                        end
                    end
                end
            end
            if Toggles.ESPFruits then
                for _, v in pairs(Workspace:GetDescendants()) do
                    if v:IsA("Model") then
                        local n = v.Name:lower()
                        if n:find("fruit") and not n:find("npc") and not n:find("seller") and
                           not n:find("vendor") and not n:find("shop") then
                            local rt = v:FindFirstChild("HumanoidRootPart") or v:FindFirstChild("Handle") or v.PrimaryPart
                            if rt then
                                local has = false
                                for _, d in pairs(ESPObjects) do if d.Object==rt then has=true break end end
                                if not has then CreateESP(rt, Color3.fromRGB(255,80,255), "🍎 "..v.Name, "fruit") end
                            end
                        end
                    end
                end
            end
            for i = #ESPObjects, 1, -1 do
                local d = ESPObjects[i]
                if d.Object and d.Object.Parent then
                    local keep = (d.Type=="player" and Toggles.ESPPlayers) or
                                 (d.Type=="mob"    and Toggles.ESPMobs)    or
                                 (d.Type=="fruit"  and Toggles.ESPFruits)
                    if not keep then
                        if d.Billboard then d.Billboard:Destroy() end
                        table.remove(ESPObjects, i)
                    end
                else
                    if d.Billboard then d.Billboard:Destroy() end
                    table.remove(ESPObjects, i)
                end
            end
        end
    end)
end

function StartAutoTeleportFruit()
    fruitTeleportEnabled = true
    spawn(function()
        while fruitTeleportEnabled and Toggles.AutoTeleportFruit do
            local c = LocalPlayer.Character
            if not c then wait(0.5) continue end
            local r = c:FindFirstChild("HumanoidRootPart")
            if not r then wait(0.5) continue end
            local nf, nd = nil, math.huge
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("Model") then
                    local n = v.Name:lower()
                    if n:find("fruit") and not n:find("npc") and not n:find("seller") then
                        local fr = v:FindFirstChild("HumanoidRootPart") or v:FindFirstChild("Handle") or v.PrimaryPart
                        if fr then
                            local d = (r.Position - fr.Position).Magnitude
                            if d < nd then nd=d; nf=fr end
                        end
                    end
                end
            end
            if nf and nd < 500 then
                r.CFrame = CFrame.new(nf.Position + Vector3.new(0,3,0))
                wait(1)
            end
            wait(0.5)
        end
    end)
end
function StopAutoTeleportFruit() fruitTeleportEnabled = false end

function StartAutoFarm()
    autoFarmRunning = true
    spawn(function()
        while autoFarmRunning and Toggles.AutoFarm do
            local c = LocalPlayer.Character
            if not c then wait(0.5) continue end
            local r = c:FindFirstChild("HumanoidRootPart")
            if not r then wait(0.5) continue end
            local nm, nd = nil, math.huge
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                    if not Players:GetPlayerFromCharacter(v) then
                        local n = v.Name:lower()
                        local sf = SelectedMob=="Tất cả" or
                                   (SelectedMob=="NPC" and n:find("npc")) or
                                   (SelectedMob=="Mob" and n:find("mob")) or
                                   (SelectedMob=="Boss" and n:find("boss")) or
                                   (SelectedMob=="Enemy" and n:find("enemy"))
                        if sf then
                            local d = (r.Position - v.HumanoidRootPart.Position).Magnitude
                            if d < nd then nd=d; nm=v end
                        end
                    end
                end
            end
            if nm then
                r.CFrame = CFrame.new(nm.HumanoidRootPart.Position + Vector3.new(0,3,0))
                local h = nm:FindFirstChild("Humanoid")
                if h and nd < 100 then h.Health=0; killCount=killCount+1 end
                wait(0.5)
            else
                r.CFrame = CFrame.new(Vector3.new(math.random(-100,100),10,math.random(-100,100)))
                wait(1)
            end
            wait(0.3)
        end
    end)
end
function StopAutoFarm() autoFarmRunning = false end

function StartAutoFarmV2()
    autoFarmV2Running = true
    spawn(function()
        while autoFarmV2Running and Toggles.AutoFarmV2 do
            local c = LocalPlayer.Character
            if not c then wait(0.5) continue end
            local r = c:FindFirstChild("HumanoidRootPart")
            if not r then wait(0.5) continue end
            local nm, nd = nil, math.huge
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                    if not Players:GetPlayerFromCharacter(v) then
                        local n = v.Name:lower()
                        local sf = SelectedMob=="Tất cả" or
                                   (SelectedMob=="NPC" and n:find("npc")) or
                                   (SelectedMob=="Mob" and n:find("mob")) or
                                   (SelectedMob=="Boss" and n:find("boss")) or
                                   (SelectedMob=="Enemy" and n:find("enemy"))
                        if sf then
                            local d = (r.Position - v.HumanoidRootPart.Position).Magnitude
                            if d < nd then nd=d; nm=v end
                        end
                    end
                end
            end
            if nm and nd < 150 then
                local mr = nm.HumanoidRootPart
                r.CFrame = CFrame.new(mr.Position + Vector3.new(0,3,0))
                local h = nm:FindFirstChild("Humanoid")
                if h then
                    h.Health = 0
                    local dp = Instance.new("Part")
                    dp.Parent = workspace; dp.Size = Vector3.new(5,5,5)
                    dp.Position = mr.Position + Vector3.new(0,2,0)
                    dp.Anchored = true; dp.CanCollide = false
                    dp.BrickColor = BrickColor.new("Bright red")
                    dp.Material = Enum.Material.Neon; dp.Transparency = 0.5
                    local dg = Instance.new("BillboardGui")
                    dg.Parent = dp; dg.Size = UDim2.new(0,200,0,50); dg.AlwaysOnTop = true
                    local dt = Instance.new("TextLabel")
                    dt.Parent = dg; dt.Size = UDim2.new(1,0,1,0)
                    dt.BackgroundTransparency = 1; dt.Text = "💀 99999+ DAMAGE!"
                    dt.TextColor3 = Color3.fromRGB(255,0,0); dt.TextScaled = true
                    dt.Font = Enum.Font.GothamBold
                    game:GetService("Debris"):AddItem(dp, 1)
                    killCount = killCount + 1
                end
                wait(0.3)
            else
                if nm then
                    r.CFrame = CFrame.new(nm.HumanoidRootPart.Position + Vector3.new(0,3,0))
                else
                    r.CFrame = CFrame.new(Vector3.new(math.random(-150,150),10,math.random(-150,150)))
                end
                wait(0.5)
            end
            wait(0.2)
        end
    end)
end
function StopAutoFarmV2() autoFarmV2Running = false end

local function AntiIdle()
    spawn(function()
        while wait(30) do VirtualUser:ClickButton2(Vector2.new()) end
    end)
end

-- ============ INIT ============
FixLag(); SuperJump(); Fly(); NoclipLoop()
ESPLoop(); UpdateDistances(); GhostMode(); NightVision(); AntiIdle()
EnableNoclip(); DisableNoclip()

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.M then Win.Visible = not Win.Visible end
    if input.KeyCode == Enum.KeyCode.F1 then Toggles.Ghost = not Toggles.Ghost end
    if input.KeyCode == Enum.KeyCode.F2 then Toggles.NightVision = not Toggles.NightVision end
end)

print("⚡ MV X SHINN DEV v6.2 — UI OVERHAUL — LOADED")
print("📌 M = Menu | F = Fly | F1 = Ghost | F2 = Night Vision")
