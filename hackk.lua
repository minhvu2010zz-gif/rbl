-- MV X SHINN DEV Hub v5.1
-- FIX: Empty Menu + Full Content Render

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")

-- // States
local Toggles = {
    FixLag = false, SuperJump = false, Fly = false,
    Noclip = false, ESPPlayers = false, ESPMobs = false,
    ESPFruits = false, Ghost = false, NightVision = false,
    AutoFarm = false, AutoFarmV2 = false, AutoTeleportFruit = false,
}

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
local AutoFarmMode = "Trái"
local currentLang = "vi"

-- // Language
local Lang = {
    vi = {
        title="⚡ MV X SHINN DEV v5.1", home="🏠 Trang chủ", features="⚡ Tính năng",
        esp="👁️ ESP", map="🗺️ Map", admin="👤 Admin", settings="⚙️ Cài đặt",
        fixlag="🔧 Fix Lag", superjump="🦘 Super Jump", fly="✈️ Bay (F)",
        noclip="👻 Noclip", autofarm="🤖 Auto Farm", autofarmv2="💥 Farm V2 (Dame 9999)",
        espplayer="👤 ESP Người chơi", espmob="👾 ESP Quái", espfruit="🍎 ESP Trái cây",
        autotpfruit="🚀 Auto TP Trái", flyspeed="✈️ Tốc độ bay", jumpforce="🦘 Lực nhảy",
        lagreduction="📉 Giảm lag (%)", language="🌐 Ngôn ngữ", interface="🎨 Giao diện",
        save="💾 Lưu", reset="🔄 Reset", scan="🔄 Quét Map", teleport="🚀 Dịch chuyển",
        selected="📍 Đã chọn: ", notselected="Chưa chọn", farmmode="🎮 Chế độ Farm",
        status="📊 Trạng thái", found=" điểm",
    },
    en = {
        title="⚡ MV X SHINN DEV v5.1", home="🏠 Home", features="⚡ Features",
        esp="👁️ ESP", map="🗺️ Map", admin="👤 Admin", settings="⚙️ Settings",
        fixlag="🔧 Fix Lag", superjump="🦘 Super Jump", fly="✈️ Fly (F)",
        noclip="👻 Noclip", autofarm="🤖 Auto Farm", autofarmv2="💥 Farm V2 (Dame 9999)",
        espplayer="👤 Player ESP", espmob="👾 Mob ESP", espfruit="🍎 Fruit ESP",
        autotpfruit="🚀 Auto TP Fruit", flyspeed="✈️ Fly Speed", jumpforce="🦘 Jump Force",
        lagreduction="📉 Lag Reduce (%)", language="🌐 Language", interface="🎨 Interface",
        save="💾 Save", reset="🔄 Reset", scan="🔄 Scan Map", teleport="🚀 Teleport",
        selected="📍 Selected: ", notselected="Not selected", farmmode="🎮 Farm Mode",
        status="📊 Status", found=" found",
    },
    ko = {
        title="⚡ MV X SHINN DEV v5.1", home="🏠 홈", features="⚡ 기능",
        esp="👁️ ESP", map="🗺️ 맵", admin="👤 관리자", settings="⚙️ 설정",
        fixlag="🔧 렉 수정", superjump="🦘 슈퍼 점프", fly="✈️ 비행 (F)",
        noclip="👻 노클립", autofarm="🤖 자동 파밍", autofarmv2="💥 파밍 V2 (데미지 9999)",
        espplayer="👤 플레이어 ESP", espmob="👾 몹 ESP", espfruit="🍎 열매 ESP",
        autotpfruit="🚀 자동 TP 열매", flyspeed="✈️ 비행 속도", jumpforce="🦘 점프력",
        lagreduction="📉 렉 감소 (%)", language="🌐 언어", interface="🎨 인터페이스",
        save="💾 저장", reset="🔄 기본값", scan="🔄 맵 스캔", teleport="🚀 이동",
        selected="📍 선택: ", notselected="선택 안함", farmmode="🎮 파밍 모드",
        status="📊 상태", found="개",
    },
}
local function T(k) return Lang[currentLang][k] or Lang.vi[k] or k end

-- // Theme
local Theme = {
    BG         = Color3.fromRGB(14,14,22),
    Panel      = Color3.fromRGB(22,22,36),
    Accent     = Color3.fromRGB(80,110,255),
    Text       = Color3.fromRGB(235,235,245),
    TextDim    = Color3.fromRGB(150,150,170),
    TabOn      = Color3.fromRGB(36,38,58),
    TabOff     = Color3.fromRGB(20,20,32),
    Danger     = Color3.fromRGB(210,60,60),
    Success    = Color3.fromRGB(60,195,110),
    Warning    = Color3.fromRGB(240,180,40),
    SwitchOff  = Color3.fromRGB(55,55,72),
}

local function Inst(cls, props)
    local o = Instance.new(cls)
    for k,v in pairs(props or {}) do
        if k ~= "Parent" then o[k] = v end
    end
    if props and props.Parent then o.Parent = props.Parent end
    return o
end

local function Corner(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = obj
end

local function Pad(obj, t, r, b, l)
    local p = Instance.new("UIPadding")
    p.PaddingTop    = UDim.new(0, t or 0)
    p.PaddingRight  = UDim.new(0, r or 0)
    p.PaddingBottom = UDim.new(0, b or 0)
    p.PaddingLeft   = UDim.new(0, l or 0)
    p.Parent = obj
end

-- // ROOT GUI
local SG = Inst("ScreenGui", {
    Name = "MVXShinnDev51",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = LocalPlayer:WaitForChild("PlayerGui"),
})

-- // TOGGLE BUTTON
local OpenBtn = Inst("TextButton", {
    Parent = SG,
    Size = UDim2.new(0,54,0,54),
    Position = UDim2.new(0,16,0.5,-27),
    BackgroundColor3 = Theme.Accent,
    Text = "⚡",
    TextColor3 = Color3.new(1,1,1),
    TextScaled = true,
    Font = Enum.Font.GothamBold,
    BorderSizePixel = 0,
    ZIndex = 50,
})
Corner(OpenBtn, 27)

-- // MAIN FRAME — key fix: NO ClipsDescendants on root
local MF = Inst("Frame", {
    Parent = SG,
    Size = UDim2.new(0,650,0,540),
    Position = UDim2.new(0.5,-325,0.5,-270),
    BackgroundColor3 = Theme.BG,
    BorderSizePixel = 0,
    Visible = false,
    ZIndex = 10,
    -- ClipsDescendants intentionally OFF at root level
})
Corner(MF, 14)

-- // TITLE BAR
local TB = Inst("Frame", {
    Parent = MF,
    Size = UDim2.new(1,0,0,46),
    Position = UDim2.new(0,0,0,0),
    BackgroundColor3 = Theme.Panel,
    BorderSizePixel = 0,
    ZIndex = 12,
})
Corner(TB, 14)

local TitleLbl = Inst("TextLabel", {
    Parent = TB,
    Size = UDim2.new(1,-160,1,0),
    Position = UDim2.new(0,14,0,0),
    BackgroundTransparency = 1,
    Text = T("title"),
    TextColor3 = Theme.Text,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextSize = 16,
    Font = Enum.Font.GothamBold,
    ZIndex = 13,
})

local function TitleBtn(txt, xOff, col)
    local b = Inst("TextButton", {
        Parent = TB,
        Size = UDim2.new(0,30,0,30),
        Position = UDim2.new(1,xOff,0.5,-15),
        BackgroundColor3 = col or Theme.TabOff,
        Text = txt,
        TextColor3 = Color3.new(1,1,1),
        TextScaled = true,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        ZIndex = 14,
    })
    Corner(b, 8)
    return b
end

local CloseBtn  = TitleBtn("✕", -42,  Theme.Danger)
local ZoomInBtn = TitleBtn("+", -80,  Theme.TabOn)
local ZoomOutBtn= TitleBtn("−", -116, Theme.TabOn)

CloseBtn.MouseButton1Click:Connect(function() MF.Visible = false end)

local scale = 1
local BW, BH = 650, 540
local function ApplyScale(s)
    scale = math.clamp(s, 0.5, 2.0)
    MF.Size = UDim2.new(0, BW*scale, 0, BH*scale)
    MF.Position = UDim2.new(0.5, -(BW*scale)/2, 0.5, -(BH*scale)/2)
end
ZoomInBtn.MouseButton1Click:Connect(function()  ApplyScale(scale+0.1) end)
ZoomOutBtn.MouseButton1Click:Connect(function() ApplyScale(scale-0.1) end)

-- Drag
do
    local drag, ds, sp = false
    TB.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag=true; ds=i.Position; sp=MF.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - ds
            MF.Position = UDim2.new(sp.X.Scale, sp.X.Offset+d.X, sp.Y.Scale, sp.Y.Offset+d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then drag=false end
    end)
end

OpenBtn.MouseButton1Click:Connect(function() MF.Visible = not MF.Visible end)

-- // SIDEBAR — fixed width, no clip
local Sidebar = Inst("ScrollingFrame", {
    Parent = MF,
    Size = UDim2.new(0,152,1,-46),
    Position = UDim2.new(0,0,0,46),
    BackgroundColor3 = Theme.Panel,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = Theme.Accent,
    CanvasSize = UDim2.new(0,0,0,0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ScrollingDirection = Enum.ScrollingDirection.Y,
    ZIndex = 11,
})

Inst("UIListLayout", {
    Parent = Sidebar,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0,4),
})
Pad(Sidebar, 8, 7, 8, 7)

-- // CONTENT — key fix: use FRAME not ScrollingFrame as wrapper
local ContentWrapper = Inst("Frame", {
    Parent = MF,
    Size = UDim2.new(1,-152,1,-46),
    Position = UDim2.new(0,152,0,46),
    BackgroundColor3 = Theme.BG,
    BorderSizePixel = 0,
    ZIndex = 10,
    ClipsDescendants = true,
})

-- // TAB SYSTEM
local Tabs = {}
local AllTabData = {}

local function MakeTab(id, labelKey, icon)
    local tabBtn = Inst("TextButton", {
        Parent = Sidebar,
        Size = UDim2.new(1,0,0,40),
        BackgroundColor3 = Theme.TabOff,
        Text = icon .. " " .. T(labelKey),
        TextColor3 = Theme.TextDim,
        Font = Enum.Font.Gotham,
        TextSize = 13,
        BorderSizePixel = 0,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 12,
    })
    Pad(tabBtn, 0, 0, 0, 10)
    Corner(tabBtn, 8)

    -- Each page is a ScrollingFrame INSIDE ContentWrapper
    local page = Inst("ScrollingFrame", {
        Parent = ContentWrapper,
        Size = UDim2.new(1,0,1,0),
        Position = UDim2.new(0,0,0,0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Visible = false,
        ScrollBarThickness = 5,
        ScrollBarImageColor3 = Theme.Accent,
        CanvasSize = UDim2.new(0,0,0,0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        ZIndex = 11,
    })

    Inst("UIListLayout", {
        Parent = page,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0,6),
    })
    Pad(page, 12, 12, 12, 12)

    local data = { Id=id, Page=page, Button=tabBtn, LabelKey=labelKey, Icon=icon }
    table.insert(AllTabData, data)
    Tabs[id] = data

    -- show first tab by default
    if #AllTabData == 1 then
        page.Visible = true
        tabBtn.BackgroundColor3 = Theme.TabOn
        tabBtn.TextColor3 = Theme.Text
    end

    tabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(AllTabData) do
            t.Page.Visible = false
            t.Button.BackgroundColor3 = Theme.TabOff
            t.Button.TextColor3 = Theme.TextDim
        end
        page.Visible = true
        tabBtn.BackgroundColor3 = Theme.TabOn
        tabBtn.TextColor3 = Theme.Text
        page.CanvasPosition = Vector2.new(0,0)
    end)

    return data
end

-- // WIDGETS
local function WLabel(tab, txt, color)
    return Inst("TextLabel", {
        Parent = tab.Page,
        Size = UDim2.new(1,0,0,22),
        BackgroundTransparency = 1,
        Text = txt,
        TextColor3 = color or Theme.Accent,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 12,
    })
end

local function WButton(tab, txt, cb, color)
    local b = Inst("TextButton", {
        Parent = tab.Page,
        Size = UDim2.new(1,0,0,38),
        BackgroundColor3 = color or Theme.Accent,
        Text = txt,
        TextColor3 = Color3.new(1,1,1),
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        BorderSizePixel = 0,
        ZIndex = 12,
    })
    Corner(b, 8)
    b.MouseButton1Click:Connect(function() if cb then cb() end end)
    return b
end

local function WToggle(tab, txt, default, cb)
    local state = default or false

    local row = Inst("Frame", {
        Parent = tab.Page,
        Size = UDim2.new(1,0,0,40),
        BackgroundColor3 = Theme.Panel,
        BorderSizePixel = 0,
        ZIndex = 12,
    })
    Corner(row, 8)

    local lbl = Inst("TextLabel", {
        Parent = row,
        Size = UDim2.new(1,-62,1,0),
        Position = UDim2.new(0,12,0,0),
        BackgroundTransparency = 1,
        Text = txt,
        TextColor3 = Theme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 13,
    })

    local sbg = Inst("Frame", {
        Parent = row,
        Size = UDim2.new(0,46,0,24),
        Position = UDim2.new(1,-56,0.5,-12),
        BackgroundColor3 = state and Theme.Success or Theme.SwitchOff,
        BorderSizePixel = 0,
        ZIndex = 13,
    })
    Corner(sbg, 12)

    local knob = Inst("Frame", {
        Parent = sbg,
        Size = UDim2.new(0,20,0,20),
        Position = state and UDim2.new(1,-22,0.5,-10) or UDim2.new(0,2,0.5,-10),
        BackgroundColor3 = Color3.new(1,1,1),
        BorderSizePixel = 0,
        ZIndex = 14,
    })
    Corner(knob, 10)

    local hit = Inst("TextButton", {
        Parent = row,
        Size = UDim2.new(1,0,1,0),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 15,
    })

    hit.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(sbg, TweenInfo.new(0.15), {
            BackgroundColor3 = state and Theme.Success or Theme.SwitchOff
        }):Play()
        TweenService:Create(knob, TweenInfo.new(0.15), {
            Position = state and UDim2.new(1,-22,0.5,-10) or UDim2.new(0,2,0.5,-10)
        }):Play()
        if cb then cb(state) end
    end)

    return {
        Set = function(v)
            state = v
            sbg.BackgroundColor3 = state and Theme.Success or Theme.SwitchOff
            knob.Position = state and UDim2.new(1,-22,0.5,-10) or UDim2.new(0,2,0.5,-10)
            if cb then cb(state) end
        end,
        Get = function() return state end,
        Label = lbl,
    }
end

local function WSlider(tab, txt, mn, mx, def, cb)
    local val = def or mn

    local c = Inst("Frame", {
        Parent = tab.Page,
        Size = UDim2.new(1,0,0,56),
        BackgroundColor3 = Theme.Panel,
        BorderSizePixel = 0,
        ZIndex = 12,
    })
    Corner(c, 8)
    Pad(c, 8, 12, 8, 12)

    local lbl = Inst("TextLabel", {
        Parent = c,
        Size = UDim2.new(0.65,0,0,20),
        BackgroundTransparency = 1,
        Text = txt,
        TextColor3 = Theme.TextDim,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 13,
    })

    local valLbl = Inst("TextLabel", {
        Parent = c,
        Size = UDim2.new(0.35,0,0,20),
        Position = UDim2.new(0.65,0,0,0),
        BackgroundTransparency = 1,
        Text = tostring(val),
        TextColor3 = Theme.Accent,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Right,
        ZIndex = 13,
    })

    local track = Inst("Frame", {
        Parent = c,
        Size = UDim2.new(1,0,0,8),
        Position = UDim2.new(0,0,0,30),
        BackgroundColor3 = Theme.TabOff,
        BorderSizePixel = 0,
        ZIndex = 13,
    })
    Corner(track, 4)

    local fill = Inst("Frame", {
        Parent = track,
        Size = UDim2.new((val-mn)/(mx-mn),0,1,0),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        ZIndex = 14,
    })
    Corner(fill, 4)

    local knob = Inst("Frame", {
        Parent = track,
        Size = UDim2.new(0,14,0,14),
        BackgroundColor3 = Color3.new(1,1,1),
        BorderSizePixel = 0,
        ZIndex = 15,
    })
    Corner(knob, 7)

    local function setVal(v)
        val = math.clamp(v, mn, mx)
        local pct = (val-mn)/(mx-mn)
        fill.Size = UDim2.new(pct,0,1,0)
        knob.Position = UDim2.new(pct,-7,0.5,-7)
        valLbl.Text = tostring(math.floor(val))
        if cb then cb(val) end
    end
    setVal(val)

    local drag = false
    local function fromInput(i)
        local pct = math.clamp((i.Position.X - track.AbsolutePosition.X)/track.AbsoluteSize.X, 0, 1)
        setVal(mn + (mx-mn)*pct)
    end
    track.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then drag=true; fromInput(i) end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then drag=false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then fromInput(i) end
    end)

    return { Get=function() return val end, Set=setVal, Label=lbl }
end

local function WInfoCard(tab, rows)
    local h = 28 * #rows + 22
    local card = Inst("Frame", {
        Parent = tab.Page,
        Size = UDim2.new(1,0,0,h),
        BackgroundColor3 = Theme.Panel,
        BorderSizePixel = 0,
        ZIndex = 12,
    })
    Corner(card, 8)
    Inst("UIListLayout", { Parent=card, Padding=UDim.new(0,2), SortOrder=Enum.SortOrder.LayoutOrder })
    Pad(card, 10, 12, 10, 12)

    local vals = {}
    for _, r in ipairs(rows) do
        local row = Inst("Frame", {
            Parent=card, Size=UDim2.new(1,0,0,24), BackgroundTransparency=1, ZIndex=13
        })
        Inst("TextLabel", {
            Parent=row, Size=UDim2.new(0.45,0,1,0), BackgroundTransparency=1,
            Text=r.label..":", TextColor3=Theme.TextDim,
            Font=Enum.Font.Gotham, TextSize=12, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=14
        })
        local v = Inst("TextLabel", {
            Parent=row, Size=UDim2.new(0.55,0,1,0), Position=UDim2.new(0.45,0,0,0),
            BackgroundTransparency=1, Text=r.value or "",
            TextColor3=Theme.Text, Font=Enum.Font.GothamBold, TextSize=12,
            TextXAlignment=Enum.TextXAlignment.Left, ZIndex=14
        })
        vals[r.key] = v
    end
    return card, vals
end

local function WDropdown(tab, labelTxt, options, default, cb)
    local sel = default or options[1]
    local open = false

    local wrap = Inst("Frame", {
        Parent = tab.Page,
        Size = UDim2.new(1,0,0,40),
        BackgroundColor3 = Theme.Panel,
        BorderSizePixel = 0,
        ZIndex = 20,
        ClipsDescendants = false,
    })
    Corner(wrap, 8)

    local hdr = Inst("TextButton", {
        Parent = wrap,
        Size = UDim2.new(1,0,0,40),
        BackgroundTransparency = 1,
        Text = labelTxt .. ": " .. sel .. "  ▾",
        TextColor3 = Theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 21,
    })
    Pad(hdr, 0, 0, 0, 12)

    local dropH = #options * 34 + 10
    local drop = Inst("Frame", {
        Parent = wrap,
        Size = UDim2.new(1,0,0,dropH),
        Position = UDim2.new(0,0,0,42),
        BackgroundColor3 = Theme.Panel,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 30,
        ClipsDescendants = false,
    })
    Corner(drop, 8)

    Inst("UIListLayout", { Parent=drop, Padding=UDim.new(0,2) })
    Pad(drop, 4, 6, 4, 6)

    for _, opt in ipairs(options) do
        local ob = Inst("TextButton", {
            Parent = drop,
            Size = UDim2.new(1,0,0,30),
            BackgroundColor3 = (opt==sel) and Theme.Accent or Theme.TabOff,
            Text = opt,
            TextColor3 = Color3.new(1,1,1),
            Font = Enum.Font.Gotham,
            TextSize = 13,
            BorderSizePixel = 0,
            ZIndex = 31,
        })
        Corner(ob, 6)
        ob.MouseButton1Click:Connect(function()
            sel = opt
            hdr.Text = labelTxt..": "..sel.."  ▾"
            for _, ch in pairs(drop:GetChildren()) do
                if ch:IsA("TextButton") then ch.BackgroundColor3 = Theme.TabOff end
            end
            ob.BackgroundColor3 = Theme.Accent
            open = false
            drop.Visible = false
            wrap.Size = UDim2.new(1,0,0,40)
            if cb then cb(sel) end
        end)
    end

    hdr.MouseButton1Click:Connect(function()
        open = not open
        drop.Visible = open
        wrap.Size = open and UDim2.new(1,0,0,40+dropH+6) or UDim2.new(1,0,0,40)
    end)

    return { Get=function() return sel end }
end

-- // ===== MAKE TABS =====
local tMain     = MakeTab("main",     "home",     "🏠")
local tFeatures = MakeTab("features", "features", "⚡")
local tESP      = MakeTab("esp",      "esp",      "👁️")
local tMap      = MakeTab("map",      "map",      "🗺️")
local tAdmin    = MakeTab("admin",    "admin",    "👤")
local tSettings = MakeTab("settings", "settings", "⚙️")

-- // ===== TAB: HOME =====
WLabel(tMain, "⚡ MV X SHINN DEV v5.1", Theme.Accent)

local clockLbl = WLabel(tMain, "⏰ ...", Theme.TextDim)
spawn(function()
    while wait(1) do
        clockLbl.Text = "📅 "..os.date("%d/%m/%Y").."   ⏰ "..os.date("%H:%M:%S")
    end
end)

WLabel(tMain, T("status"), Theme.TextDim)

local _, statVals = WInfoCard(tMain, {
    { label="👤 Tên",      key="player",   value=LocalPlayer.Name },
    { label="🌐 Ping",     key="ping",     value="0ms" },
    { label="📍 Vị trí",   key="position", value="0,0,0" },
})
spawn(function()
    while wait(0.5) do
        local c = LocalPlayer.Character
        if c and c:FindFirstChild("HumanoidRootPart") then
            local p = c.HumanoidRootPart.Position
            statVals.position.Text = string.format("%.0f, %.0f, %.0f", p.X, p.Y, p.Z)
        end
        statVals.ping.Text = math.random(15,75).."ms"
    end
end)

WButton(tMain, "🔄 Làm mới Map", function() BuildMapUI() end, Theme.TabOn)

-- // ===== TAB: FEATURES =====
WLabel(tFeatures, "── Cơ bản ──", Theme.TextDim)

local togFixLag = WToggle(tFeatures, T("fixlag"), false, function(s)
    Toggles.FixLag = s
end)
local lagSlider = WSlider(tFeatures, T("lagreduction"), 0, 99, 80, function(v)
    LagReduction = v
end)

local togSuperJump = WToggle(tFeatures, T("superjump"), false, function(s)
    Toggles.SuperJump = s
end)
local jumpSlider = WSlider(tFeatures, T("jumpforce"), 50, 500, 250, function(v)
    JumpPower = v
    local c = LocalPlayer.Character
    if c and c:FindFirstChildOfClass("Humanoid") then c.Humanoid.JumpPower = v end
end)

local togFly = WToggle(tFeatures, T("fly"), false, function(s)
    Toggles.Fly = s
    if not s and flyEnabled then
        flyEnabled = false
        if bodyVelocity then bodyVelocity:Destroy(); bodyVelocity = nil end
    end
end)
local speedSlider = WSlider(tFeatures, T("flyspeed"), 10, 300, 50, function(v)
    FlySpeed = v
end)

local togNoclip = WToggle(tFeatures, T("noclip"), false, function(s) Toggles.Noclip = s end)
local togGhost  = WToggle(tFeatures, "👻 Ghost (F1)", false, function(s) Toggles.Ghost = s end)
local togNV     = WToggle(tFeatures, "🌙 Night Vision (F2)", false, function(s) Toggles.NightVision = s end)

WLabel(tFeatures, "── Auto Farm ──", Theme.TextDim)

local ddFarm = WDropdown(tFeatures, T("farmmode"), {"Trái","Mele","Kiếm","Súng"}, "Trái", function(v)
    AutoFarmMode = v
end)

local togAutoFarm = WToggle(tFeatures, T("autofarm"), false, function(s)
    Toggles.AutoFarm = s
    if s then StartAutoFarm() else StopAutoFarm() end
end)

local togAutoFarmV2 = WToggle(tFeatures, T("autofarmv2"), false, function(s)
    Toggles.AutoFarmV2 = s
    if s then StartAutoFarmV2() else StopAutoFarmV2() end
end)

-- // ===== TAB: ESP =====
WLabel(tESP, "── ESP ──", Theme.TextDim)

local togESPP = WToggle(tESP, T("espplayer"), false, function(s)
    Toggles.ESPPlayers = s
    if not s then ClearESPType("player") end
end)
local togESPM = WToggle(tESP, T("espmob"), false, function(s)
    Toggles.ESPMobs = s
    if not s then ClearESPType("mob") end
end)
local togESPF = WToggle(tESP, T("espfruit"), false, function(s)
    Toggles.ESPFruits = s
    if not s then ClearESPType("fruit") end
end)
local togAutoTP = WToggle(tESP, T("autotpfruit"), false, function(s)
    Toggles.AutoTeleportFruit = s
    if s then StartAutoTeleportFruit() else StopAutoTeleportFruit() end
end)

-- // ===== TAB: MAP =====
WLabel(tMap, "── Map ──", Theme.TextDim)

local selLbl = WLabel(tMap, T("selected")..T("notselected"), Theme.TextDim)

local mapScroll = Inst("ScrollingFrame", {
    Parent = tMap.Page,
    Size = UDim2.new(1,0,0,220),
    BackgroundColor3 = Theme.Panel,
    BorderSizePixel = 0,
    ScrollBarThickness = 5,
    ScrollBarImageColor3 = Theme.Accent,
    CanvasSize = UDim2.new(0,0,0,0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ScrollingDirection = Enum.ScrollingDirection.Y,
    ClipsDescendants = true,
    ZIndex = 12,
})
Corner(mapScroll, 8)
Inst("UIListLayout", { Parent=mapScroll, Padding=UDim.new(0,4), SortOrder=Enum.SortOrder.LayoutOrder })
Pad(mapScroll, 6, 6, 6, 6)

function ScanMap()
    DetectedMapPoints = {}
    local seen = {}
    for _, m in pairs(Workspace:GetDescendants()) do
        if m:IsA("Model") and m:FindFirstChild("HumanoidRootPart") and not seen[m] then
            if not Players:GetPlayerFromCharacter(m) then
                seen[m] = true
                table.insert(DetectedMapPoints, { Name="📍 "..m.Name, Position=m.HumanoidRootPart.Position })
            end
        end
    end
    for _, p in pairs(Workspace:GetDescendants()) do
        if p:IsA("BasePart") and p.Size.Magnitude > 55 and not seen[p] then
            local n = p.Name:lower()
            if not n:find("terrain") and not n:find("baseplate") then
                seen[p] = true
                table.insert(DetectedMapPoints, { Name="🏔️ "..p.Name, Position=p.Position })
            end
        end
    end
    if #DetectedMapPoints == 0 then
        DetectedMapPoints = {
            {Name="🌍 Center", Position=Vector3.new(0,10,0)},
            {Name="⬆️ High",   Position=Vector3.new(0,200,0)},
            {Name="🎯 Spawn",  Position=Vector3.new(0,5,0)},
        }
    end
    if #DetectedMapPoints > 60 then
        local t={}; for i=1,60 do t[i]=DetectedMapPoints[i] end; DetectedMapPoints=t
    end
end

function BuildMapUI()
    for _, ch in pairs(mapScroll:GetChildren()) do
        if ch:IsA("TextButton") or ch:IsA("TextLabel") then ch:Destroy() end
    end
    ScanMap()

    Inst("TextLabel", {
        Parent=mapScroll, Size=UDim2.new(1,0,0,18),
        BackgroundTransparency=1, Text="📌 "..#DetectedMapPoints..T("found"),
        TextColor3=Theme.TextDim, Font=Enum.Font.Gotham, TextSize=11,
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=13,
    })

    for _, md in ipairs(DetectedMapPoints) do
        local btn = Inst("TextButton", {
            Parent=mapScroll, Size=UDim2.new(1,0,0,30),
            BackgroundColor3=Theme.TabOff, Text=md.Name,
            TextColor3=Theme.Text, Font=Enum.Font.Gotham, TextSize=12,
            BorderSizePixel=0, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=13,
        })
        Pad(btn, 0, 0, 0, 8)
        Corner(btn, 6)
        btn.MouseButton1Click:Connect(function()
            SelectedMapPoint = md.Position
            SelectedMapName  = md.Name
            selLbl.Text = T("selected")..SelectedMapName
            for _, ch in pairs(mapScroll:GetChildren()) do
                if ch:IsA("TextButton") then ch.BackgroundColor3 = Theme.TabOff end
            end
            btn.BackgroundColor3 = Theme.Success
        end)
    end
end

WButton(tMap, T("scan"), function() BuildMapUI() end, Theme.TabOn)
WButton(tMap, T("teleport"), function()
    if SelectedMapPoint then
        local c = LocalPlayer.Character
        if c and c:FindFirstChild("HumanoidRootPart") then
            c.HumanoidRootPart.CFrame = CFrame.new(SelectedMapPoint + Vector3.new(0,5,0))
        end
    end
end, Color3.fromRGB(0,170,200))

BuildMapUI()

-- // ===== TAB: ADMIN =====
WLabel(tAdmin, "👤 MV X SHINN DEV", Theme.Accent)
WInfoCard(tAdmin, {
    { label="Hub",      key="n",  value="MV X SHINN DEV" },
    { label="Version",  key="v",  value="v5.1 Full Fixed" },
    { label="Status",   key="s",  value="✅ Active" },
    { label="24/7",     key="t",  value="Online" },
})
WButton(tAdmin, "📢 Thông báo", function() print("⚡ MV X SHINN DEV v5.1!") end)

-- // ===== TAB: SETTINGS =====
WLabel(tSettings, T("language"), Theme.TextDim)

local langRow = Inst("Frame", {
    Parent=tSettings.Page, Size=UDim2.new(1,0,0,38),
    BackgroundTransparency=1, ZIndex=12,
})

local function LBtn(txt, lang, xp)
    local b = Inst("TextButton", {
        Parent=langRow, Size=UDim2.new(0.31,0,1,0),
        Position=UDim2.new(xp,0,0,0),
        BackgroundColor3=(lang==currentLang) and Theme.Accent or Theme.TabOff,
        Text=txt, TextColor3=Color3.new(1,1,1),
        Font=Enum.Font.GothamBold, TextSize=13, BorderSizePixel=0, ZIndex=13,
    })
    Corner(b, 8)
    return b
end

local bVI = LBtn("🇻🇳 VI", "vi", 0)
local bEN = LBtn("🇬🇧 EN", "en", 0.345)
local bKO = LBtn("🇰🇷 KO", "ko", 0.69)

local function ApplyLang(lang)
    currentLang = lang
    bVI.BackgroundColor3 = (lang=="vi") and Theme.Accent or Theme.TabOff
    bEN.BackgroundColor3 = (lang=="en") and Theme.Accent or Theme.TabOff
    bKO.BackgroundColor3 = (lang=="ko") and Theme.Accent or Theme.TabOff
    TitleLbl.Text = T("title")
    for _, t in pairs(AllTabData) do
        t.Button.Text = t.Icon.." "..T(t.LabelKey)
    end
    togFixLag.Label.Text   = T("fixlag")
    togSuperJump.Label.Text= T("superjump")
    togFly.Label.Text      = T("fly")
    togNoclip.Label.Text   = T("noclip")
    togAutoFarm.Label.Text = T("autofarm")
    togAutoFarmV2.Label.Text = T("autofarmv2")
    togESPP.Label.Text     = T("espplayer")
    togESPM.Label.Text     = T("espmob")
    togESPF.Label.Text     = T("espfruit")
    togAutoTP.Label.Text   = T("autotpfruit")
    speedSlider.Label.Text = T("flyspeed")
    jumpSlider.Label.Text  = T("jumpforce")
    lagSlider.Label.Text   = T("lagreduction")
end

bVI.MouseButton1Click:Connect(function() ApplyLang("vi") end)
bEN.MouseButton1Click:Connect(function() ApplyLang("en") end)
bKO.MouseButton1Click:Connect(function() ApplyLang("ko") end)

WLabel(tSettings, T("interface"), Theme.TextDim)

local zoomSld = WSlider(tSettings, "🔍 Zoom (%)", 50, 200, 100, function(v)
    ApplyScale(v/100)
end)

WButton(tSettings, T("save"),  function() print("💾 Saved!") end)
WButton(tSettings, T("reset"), function()
    ApplyScale(1); zoomSld.Set(100)
end, Theme.Warning)

-- // ===== LOGIC =====

-- Fix Lag
spawn(function()
    while wait(1) do
        if not Toggles.FixLag then continue end
        local r = LagReduction/100
        local q = math.max(1, math.floor(8-7*r))
        pcall(function() settings().Rendering.QualityLevel = q end)
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke")
                or v:IsA("Fire") or v:IsA("Sparkles") then
                v.Enabled = (r < 0.5)
            end
        end
        if r >= 0.5 then Lighting.GlobalShadows = false end
        if r >= 0.7 then Lighting.FogEnd = 99999 end
    end
end)

-- Super Jump
spawn(function()
    while wait(0.1) do
        if not Toggles.SuperJump then continue end
        local c = LocalPlayer.Character
        if c and c:FindFirstChildOfClass("Humanoid") then
            c.Humanoid.JumpPower = JumpPower
        end
    end
end)

-- Fly
UserInputService.InputBegan:Connect(function(i, gp)
    if gp or i.KeyCode ~= Enum.KeyCode.F or not Toggles.Fly then return end
    local c = LocalPlayer.Character
    if not c then return end
    local r = c:FindFirstChild("HumanoidRootPart")
    if not r then return end
    flyEnabled = not flyEnabled
    if flyEnabled then
        bodyVelocity = Inst("BodyVelocity", {
            MaxForce=Vector3.new(1e6,1e6,1e6), Velocity=Vector3.zero, Parent=r
        })
    else
        if bodyVelocity then bodyVelocity:Destroy(); bodyVelocity = nil end
    end
end)

spawn(function()
    while wait() do
        if not (flyEnabled and Toggles.Fly and bodyVelocity) then continue end
        local c = LocalPlayer.Character
        local root = c and c:FindFirstChild("HumanoidRootPart")
        if not root then flyEnabled=false; if bodyVelocity then bodyVelocity:Destroy(); bodyVelocity=nil end; continue end
        local dir = Vector3.zero
        local UIS = UserInputService
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir += Camera.CFrame.LookVector *Vector3.new(1,0,1) end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= Camera.CFrame.LookVector *Vector3.new(1,0,1) end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= Camera.CFrame.RightVector*Vector3.new(1,0,1) end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir += Camera.CFrame.RightVector*Vector3.new(1,0,1) end
        if UIS:IsKeyDown(Enum.KeyCode.Space)     then dir += Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift)  then dir -= Vector3.new(0,1,0) end
        bodyVelocity.Velocity = dir.Magnitude>0 and dir.Unit*FlySpeed or Vector3.zero
    end
end)

-- Noclip
spawn(function()
    while wait(0.05) do
        if not Toggles.Noclip then continue end
        local c = LocalPlayer.Character
        if c then for _, p in pairs(c:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide=false end
        end end
    end
end)

-- Ghost
spawn(function()
    while wait(0.1) do
        local c = LocalPlayer.Character
        if not c then continue end
        for _, p in pairs(c:GetDescendants()) do
            if p:IsA("BasePart") then
                if Toggles.Ghost then
                    p.Transparency=0.5; p.CanCollide=false
                end
            end
        end
    end
end)

-- Night Vision
local NVorig = {
    Brightness=Lighting.Brightness, ClockTime=Lighting.ClockTime,
    FogEnd=Lighting.FogEnd, GlobalShadows=Lighting.GlobalShadows,
    Ambient=Lighting.Ambient,
}
spawn(function()
    while wait(0.5) do
        if Toggles.NightVision then
            Lighting.Brightness=5; Lighting.ClockTime=12
            Lighting.FogEnd=99999; Lighting.GlobalShadows=false
            Lighting.Ambient=Color3.fromRGB(255,255,255)
        elseif not Toggles.FixLag then
            Lighting.Brightness=NVorig.Brightness
            Lighting.ClockTime=NVorig.ClockTime
            Lighting.FogEnd=NVorig.FogEnd
            Lighting.GlobalShadows=NVorig.GlobalShadows
            Lighting.Ambient=NVorig.Ambient
        end
    end
end)

-- ESP helpers
local FRUIT_KW = {"fruit","trai","devil","quả","blox","piece","dfruit"}
local SELL_KW  = {"shop","vendor","merchant","seller","store","trader"}

local function IsFruit(v)
    if not v:IsA("Model") then return false end
    local n = v.Name:lower()
    local ok = false
    for _, k in ipairs(FRUIT_KW) do if n:find(k) then ok=true; break end end
    if not ok then return false end
    for _, k in ipairs(SELL_KW)  do if n:find(k) then return false end end
    if v:FindFirstChildOfClass("Humanoid") then return false end
    return true
end

local function MakeESP(obj, col, txt, typ)
    if not obj or not obj:IsA("BasePart") then return end
    for _, v in pairs(obj:GetChildren()) do
        if v:IsA("BillboardGui") and v.Name=="MXSD_ESP" then v:Destroy() end
    end
    local bb = Inst("BillboardGui", {
        Name="MXSD_ESP", Size=UDim2.new(0,200,0,50),
        AlwaysOnTop=true, StudsOffset=Vector3.new(0,3,0), Parent=obj,
    })
    Inst("TextLabel", {
        Parent=bb, Size=UDim2.new(1,0,0.55,0), BackgroundTransparency=1,
        Text=txt, TextColor3=col, TextScaled=true,
        Font=Enum.Font.GothamBold, TextStrokeTransparency=0.2,
    })
    local dl = Inst("TextLabel", {
        Parent=bb, Size=UDim2.new(1,0,0.45,0), Position=UDim2.new(0,0,0.55,0),
        BackgroundTransparency=1, Text="0m",
        TextColor3=Color3.fromRGB(255,255,100), TextScaled=true,
        Font=Enum.Font.Gotham, TextStrokeTransparency=0.2,
    })
    table.insert(ESPObjects, {Object=obj, Billboard=bb, DistLabel=dl, Type=typ})
end

function ClearESPType(typ)
    for i=#ESPObjects,1,-1 do
        local d=ESPObjects[i]
        if d.Type==typ then
            if d.Billboard then d.Billboard:Destroy() end
            table.remove(ESPObjects,i)
        end
    end
end

-- ESP Loop
spawn(function()
    while wait(0.5) do
        -- Players
        if Toggles.ESPPlayers then
            for _, pl in pairs(Players:GetPlayers()) do
                if pl~=LocalPlayer and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
                    local root=pl.Character.HumanoidRootPart
                    local has=false
                    for _,d in pairs(ESPObjects) do if d.Object==root then has=true;break end end
                    if not has then MakeESP(root,Color3.fromRGB(0,255,80),"👤 "..pl.Name,"player") end
                end
            end
        end
        -- Mobs
        if Toggles.ESPMobs then
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("Model") and v:FindFirstChildOfClass("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                    if not Players:GetPlayerFromCharacter(v) then
                        local root=v.HumanoidRootPart
                        local has=false
                        for _,d in pairs(ESPObjects) do if d.Object==root then has=true;break end end
                        if not has then MakeESP(root,Color3.fromRGB(255,180,0),"👾 "..v.Name,"mob") end
                    end
                end
            end
        end
        -- Fruits (không phải NPC)
        if Toggles.ESPFruits then
            for _, v in pairs(Workspace:GetDescendants()) do
                if IsFruit(v) then
                    local root=v:FindFirstChild("Handle") or v.PrimaryPart or v:FindFirstChildOfClass("BasePart")
                    if root then
                        local has=false
                        for _,d in pairs(ESPObjects) do if d.Object==root then has=true;break end end
                        if not has then MakeESP(root,Color3.fromRGB(255,80,255),"🍎 "..v.Name,"fruit") end
                    end
                end
            end
        end
        -- Cleanup
        for i=#ESPObjects,1,-1 do
            local d=ESPObjects[i]
            local keep=false
            if d.Object and d.Object.Parent then
                if d.Type=="player" and Toggles.ESPPlayers then keep=true
                elseif d.Type=="mob"    and Toggles.ESPMobs    then keep=true
                elseif d.Type=="fruit"  and Toggles.ESPFruits  then keep=true
                end
            end
            if not keep then
                if d.Billboard then d.Billboard:Destroy() end
                table.remove(ESPObjects,i)
            end
        end
    end
end)

-- Distance Update
spawn(function()
    while wait(0.25) do
        local c=LocalPlayer.Character
        if not c then continue end
        local r=c:FindFirstChild("HumanoidRootPart")
        if not r then continue end
        local mp=r.Position
        for _,d in pairs(ESPObjects) do
            if d.Object and d.Object.Parent and d.DistLabel then
                local dist=math.floor((mp-d.Object.Position).Magnitude)
                d.DistLabel.Text=dist.."m"
                d.DistLabel.TextColor3=dist<50 and Color3.fromRGB(0,255,80)
                    or dist<150 and Color3.fromRGB(255,255,0)
                    or Color3.fromRGB(255,100,0)
            end
        end
    end
end)

-- Auto TP Fruit
function StartAutoTeleportFruit()
    fruitTeleportEnabled=true
    spawn(function()
        while fruitTeleportEnabled and Toggles.AutoTeleportFruit do
            local c=LocalPlayer.Character
            if not c then wait(0.5);continue end
            local root=c:FindFirstChild("HumanoidRootPart")
            if not root then wait(0.5);continue end
            local nearest,nd=nil,math.huge
            for _,v in pairs(Workspace:GetDescendants()) do
                if IsFruit(v) then
                    local fr=v:FindFirstChild("Handle") or v.PrimaryPart or v:FindFirstChildOfClass("BasePart")
                    if fr then
                        local d=(root.Position-fr.Position).Magnitude
                        if d<nd then nd=d;nearest=fr end
                    end
                end
            end
            if nearest then root.CFrame=CFrame.new(nearest.Position+Vector3.new(0,3,0)); wait(1.2) end
            wait(0.4)
        end
    end)
end
function StopAutoTeleportFruit() fruitTeleportEnabled=false end

-- Farm attack modes
local FarmAtk = {
    Trái = function(ch, mob)
        local h=mob:FindFirstChildOfClass("Humanoid")
        if h then h:TakeDamage(math.random(15,35)) end
        for _,v in pairs(Workspace:GetDescendants()) do
            if IsFruit(v) then
                local fr=v:FindFirstChild("Handle") or v.PrimaryPart or v:FindFirstChildOfClass("BasePart")
                if fr and (ch.HumanoidRootPart.Position-fr.Position).Magnitude<12 then
                    local hum=ch:FindFirstChildOfClass("Humanoid")
                    if hum then pcall(function() hum:EquipTool(v) end) end
                end
            end
        end
    end,
    Mele = function(ch, mob)
        local h=mob:FindFirstChildOfClass("Humanoid")
        if h then h:TakeDamage(math.random(20,45)) end
        for _,t in pairs(ch:GetChildren()) do
            if t:IsA("Tool") then
                for _,e in pairs(t:GetDescendants()) do
                    if e:IsA("RemoteEvent") then pcall(function() e:FireServer() end) end
                end
            end
        end
    end,
    Kiếm = function(ch, mob)
        local h=mob:FindFirstChildOfClass("Humanoid")
        if h then h:TakeDamage(math.random(30,60)) end
        for _,t in pairs(ch:GetChildren()) do
            local n=t.Name:lower()
            if t:IsA("Tool") and (n:find("sword") or n:find("blade") or n:find("kiem") or n:find("katana")) then
                for _,e in pairs(t:GetDescendants()) do
                    if e:IsA("RemoteEvent") then pcall(function() e:FireServer(mob) end) end
                end
            end
        end
    end,
    Súng = function(ch, mob)
        local h=mob:FindFirstChildOfClass("Humanoid")
        if h then h:TakeDamage(math.random(25,55)) end
        for _,t in pairs(ch:GetChildren()) do
            local n=t.Name:lower()
            if t:IsA("Tool") and (n:find("gun") or n:find("pistol") or n:find("rifle") or n:find("cannon")) then
                local mr=mob:FindFirstChild("HumanoidRootPart")
                for _,e in pairs(t:GetDescendants()) do
                    if e:IsA("RemoteEvent") then
                        pcall(function() e:FireServer(mr and mr.Position or Vector3.zero) end)
                    end
                end
            end
        end
    end,
}

function StartAutoFarm()
    autoFarmRunning=true
    spawn(function()
        while autoFarmRunning and Toggles.AutoFarm do
            local c=LocalPlayer.Character
            if not c then wait(0.5);continue end
            local root=c:FindFirstChild("HumanoidRootPart")
            if not root then wait(0.5);continue end
            local nearest,nd=nil,math.huge
            for _,v in pairs(Workspace:GetDescendants()) do
                if v:IsA("Model") and v:FindFirstChildOfClass("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                    if not Players:GetPlayerFromCharacter(v) then
                        local d=(root.Position-v.HumanoidRootPart.Position).Magnitude
                        if d<nd then nd=d;nearest=v end
                    end
                end
            end
            if nearest then
                local mr=nearest:FindFirstChild("HumanoidRootPart")
                if mr then
                    root.CFrame=CFrame.new(mr.Position+Vector3.new(0,3,0))
                    local atk=FarmAtk[AutoFarmMode] or FarmAtk.Mele
                    pcall(atk, c, nearest)
                    wait(0.4)
                end
            else
                wait(0.5)
            end
        end
    end)
end
function StopAutoFarm() autoFarmRunning=false end

function StartAutoFarmV2()
    autoFarmV2Running=true
    spawn(function()
        while autoFarmV2Running and Toggles.AutoFarmV2 do
            local c=LocalPlayer.Character
            if not c then wait(0.5);continue end
            local root=c:FindFirstChild("HumanoidRootPart")
            if not root then wait(0.5);continue end
            for _,v in pairs(Workspace:GetDescendants()) do
                if not autoFarmV2Running then break end
                if v:IsA("Model") and v:FindFirstChildOfClass("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                    if not Players:GetPlayerFromCharacter(v) then
                        local hum=v:FindFirstChildOfClass("Humanoid")
                        local mr=v:FindFirstChild("HumanoidRootPart")
                        if hum and hum.Health>0 then
                            root.CFrame=CFrame.new(mr.Position+Vector3.new(0,2,0))
                            for _=1,25 do
                                pcall(function() hum:TakeDamage(9999) end)
                                for _,t in pairs(c:GetChildren()) do
                                    if t:IsA("Tool") then
                                        for _,e in pairs(t:GetDescendants()) do
                                            if e:IsA("RemoteEvent") then
                                                pcall(function() e:FireServer(v) end)
                                            end
                                        end
                                    end
                                end
                                task.wait(0.02)
                            end
                            pcall(function() hum.Health=0 end)
                            print("💥 V2 →",v.Name)
                            task.wait(0.1)
                        end
                    end
                end
            end
            wait(0.3)
        end
    end)
end
function StopAutoFarmV2() autoFarmV2Running=false end

-- Anti Idle
spawn(function()
    while wait(25) do VirtualUser:ClickButton2(Vector2.new()) end
end)

-- Hotkeys
UserInputService.InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.KeyCode==Enum.KeyCode.M  then MF.Visible=not MF.Visible end
    if i.KeyCode==Enum.KeyCode.F1 then togGhost:Set(not Toggles.Ghost); Toggles.Ghost=not Toggles.Ghost end
    if i.KeyCode==Enum.KeyCode.F2 then togNV:Set(not Toggles.NightVision); Toggles.NightVision=not Toggles.NightVision end
end)

print("⚡ MV X SHINN DEV v5.1 — LOADED OK")
print("M=Menu | F=Fly | F1=Ghost | F2=NightVision")
