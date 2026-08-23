-- MV Hub | Axiom Build v4.2
-- ModernUI Framework Integrated
-- ESP Players & Mobs hiển thị khoảng cách (mét)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- // MODERN UI FRAMEWORK
local ModernUI = {}


-- Tạo menu ModernUI
local function CreateModernUI()
    local UI = {} -- Định nghĩa UI framework inline
    
    -- THEME
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

    -- Tạo Window
    local self = {}
    self.Language = "vi"
    self.Tabs = {}
    self.LocalizedObjects = {}

    -- ScreenGui
    self.ScreenGui = New("ScreenGui", {
        Name = "ModernUI_MVHub",
        ResetOnSpawn = false,
        Parent = LocalPlayer:WaitForChild("PlayerGui"),
    })

    -- Nút mở menu
    self.ToggleButton = New("TextButton", {
        Parent = self.ScreenGui,
        Size = UDim2.new(0, 56, 0, 56),
        Position = UDim2.new(0, 20, 0.5, -28),
        BackgroundColor3 = Theme.Accent,
        Text = "⚡",
        TextColor3 = Color3.new(1,1,1),
        TextScaled = true,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        AutoButtonColor = true,
    })
    Round(self.ToggleButton, UDim.new(1,0))

    -- Khung chính
    self.MainFrame = New("Frame", {
        Parent = self.ScreenGui,
        Size = UDim2.new(0, 620, 0, 500),
        Position = UDim2.new(0.5, -310, 0.5, -250),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Visible = false,
        Active = true,
        ClipsDescendants = true,
    })
    Round(self.MainFrame, UDim.new(0, 14))

    -- Thanh tiêu đề
    local TitleBar = New("Frame", {
        Parent = self.MainFrame,
        Size = UDim2.new(1, 0, 0, 46),
        BackgroundColor3 = Theme.Panel,
        BorderSizePixel = 0,
    })
    Round(TitleBar, UDim.new(0, 14))
    New("Frame", {
        Parent = TitleBar,
        Size = UDim2.new(1, 0, 0, 14),
        Position = UDim2.new(0, 0, 1, -14),
        BackgroundColor3 = Theme.Panel,
        BorderSizePixel = 0,
    })

    self.TitleLabel = New("TextLabel", {
        Parent = TitleBar,
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.new(0, 16, 0, 0),
        BackgroundTransparency = 1,
        Text = "⚡ MV HUB",
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
        self.MainFrame.Visible = false
    end)

    -- Kéo thả
    do
        local dragging, dragStart, startPos = false, nil, nil
        TitleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = self.MainFrame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                self.MainFrame.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            end
        end)
    end

    self.ToggleButton.MouseButton1Click:Connect(function()
        self.MainFrame.Visible = not self.MainFrame.Visible
    end)

    -- Tab List bên trái
    self.TabListFrame = New("ScrollingFrame", {
        Parent = self.MainFrame,
        Size = UDim2.new(0, 160, 1, -46),
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

    -- Content Area
    self.ContentArea = New("Frame", {
        Parent = self.MainFrame,
        Size = UDim2.new(1, -160, 1, -46),
        Position = UDim2.new(0, 160, 0, 46),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
    })

    -- Hàm thêm Tab
    function self:AddTab(id, titleTable, icon)
        local isFirst = (next(self.Tabs) == nil)

        local TabButton = New("TextButton", {
            Parent = self.TabListFrame,
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundColor3 = isFirst and Theme.TabActive or Theme.TabInactive,
            Text = (icon and (icon.." ") or "") .. ResolveText(titleTable, self.Language),
            TextColor3 = Theme.TextPrimary,
            Font = Enum.Font.Gotham,
            TextSize = 14,
            BorderSizePixel = 0,
            AutoButtonColor = true,
        })
        Round(TabButton, UDim.new(0, 8))
        self.LocalizedObjects[TabButton] = { kind = "tabButton", data = titleTable, icon = icon }

        local Page = New("ScrollingFrame", {
            Parent = self.ContentArea,
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
            for _, t in pairs(self.Tabs) do
                t.Page.Visible = false
                t.Button.BackgroundColor3 = Theme.TabInactive
            end
            Page.Visible = true
            TabButton.BackgroundColor3 = Theme.TabActive
        end)

        local tabObj = {
            Id = id,
            Page = Page,
            Button = TabButton,
            Window = self,
        }
        self.Tabs[id] = tabObj
        return tabObj
    end

    -- Hàm thêm Label
    function self:AddLabel(tab, textTable)
        local lbl = New("TextLabel", {
            Parent = tab.Page,
            Size = UDim2.new(1, 0, 0, 24),
            BackgroundTransparency = 1,
            Text = ResolveText(textTable, self.Language),
            TextColor3 = Theme.TextSecondary,
            Font = Enum.Font.GothamBold,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
        })
        self.LocalizedObjects[lbl] = { kind = "text", data = textTable }
        return lbl
    end

    -- Hàm thêm Button
    function self:AddButton(tab, textTable, callback)
        local btn = New("TextButton", {
            Parent = tab.Page,
            Size = UDim2.new(1, 0, 0, 38),
            BackgroundColor3 = Theme.Accent,
            Text = ResolveText(textTable, self.Language),
            TextColor3 = Color3.new(1,1,1),
            Font = Enum.Font.GothamBold,
            TextSize = 14,
            BorderSizePixel = 0,
            AutoButtonColor = true,
        })
        Round(btn)
        self.LocalizedObjects[btn] = { kind = "text", data = textTable }
        btn.MouseButton1Click:Connect(function()
            if callback then callback() end
        end)
        return btn
    end

    -- Hàm thêm Toggle
    function self:AddToggle(tab, textTable, default, callback)
        local state = default or false

        local row = New("Frame", {
            Parent = tab.Page,
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
            Text = ResolveText(textTable, self.Language),
            TextColor3 = Theme.TextPrimary,
            Font = Enum.Font.Gotham,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
        })
        self.LocalizedObjects[lbl] = { kind = "text", data = textTable }

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

    -- Hàm thêm Slider
    function self:AddSlider(tab, textTable, minVal, maxVal, default, step, callback)
        local value = default or minVal

        local container = New("Frame", {
            Parent = tab.Page,
            Size = UDim2.new(1, 0, 0, 50),
            BackgroundColor3 = Theme.Panel,
            BorderSizePixel = 0,
        })
        Round(container)
        New("UIPadding", {
            Parent = container,
            PaddingTop = UDim.new(0, 8),
            PaddingLeft = UDim.new(0, 12),
            PaddingRight = UDim.new(0, 12),
        })

        local lbl = New("TextLabel", {
            Parent = container,
            Size = UDim2.new(0.6, 0, 0, 20),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            Text = ResolveText(textTable, self.Language),
            TextColor3 = Theme.TextSecondary,
            Font = Enum.Font.Gotham,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
        })
        self.LocalizedObjects[lbl] = { kind = "text", data = textTable }

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
            Position = UDim2.new(0, 0, 0, 26),
            BackgroundColor3 = Theme.TabInactive,
            BorderSizePixel = 0,
        })
        Round(sliderBg, UDim.new(1,0))

        local sliderFill = New("Frame", {
            Parent = sliderBg,
            Size = UDim2.new((value - minVal) / (maxVal - minVal), 0, 1, 0),
            BackgroundColor3 = Theme.Accent,
            BorderSizePixel = 0,
        })
        Round(sliderFill, UDim.new(1,0))

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

    -- Hàm thêm Dropdown
    function self:AddDropdown(tab, textTable, options, default, callback)
        local selectedId = default

        local container = New("Frame", {
            Parent = tab.Page,
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
            Text = ResolveText(textTable, self.Language),
            TextColor3 = Theme.TextPrimary,
            Font = Enum.Font.Gotham,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 2,
        })
        self.LocalizedObjects[lbl] = { kind = "text", data = textTable }

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
            Text = ResolveText(findOption(selectedId).label, self.Language) .. " ▾",
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

        local optionButtons = {}
        for i, opt in ipairs(options) do
            local ob = New("TextButton", {
                Parent = dropdownList,
                Size = UDim2.new(1, 0, 0, 28),
                BackgroundColor3 = Theme.TabInactive,
                Text = ResolveText(opt.label, self.Language),
                TextColor3 = Theme.TextPrimary,
                Font = Enum.Font.Gotham,
                TextSize = 13,
                BorderSizePixel = 0,
                ZIndex = 5,
            })
            self.LocalizedObjects[ob] = { kind = "text", data = opt.label }
            ob.MouseButton1Click:Connect(function()
                selectedId = opt.id
                selectBtn.Text = ResolveText(opt.label, self.Language) .. " ▾"
                dropdownList.Visible = false
                if callback then callback(selectedId) end
            end)
            optionButtons[opt.id] = ob
        end

        selectBtn.MouseButton1Click:Connect(function()
            dropdownList.Visible = not dropdownList.Visible
        end)

        return {
            Get = function() return selectedId end,
            Set = function(id)
                selectedId = id
                selectBtn.Text = ResolveText(findOption(id).label, self.Language) .. " ▾"
            end,
        }
    end

    -- Hàm thêm Info Card
    function self:AddInfoCard(tab, rows)
        local card = New("Frame", {
            Parent = tab.Page,
            Size = UDim2.new(1, 0, 0, 30 * #rows + 16),
            BackgroundColor3 = Theme.Panel,
            BorderSizePixel = 0,
        })
        Round(card)
        New("UIListLayout", {
            Parent = card,
            Padding = UDim.new(0, 4),
            SortOrder = Enum.SortOrder.LayoutOrder,
        })
        New("UIPadding", {
            Parent = card,
            PaddingTop = UDim.new(0, 8),
            PaddingLeft = UDim.new(0, 12),
            PaddingRight = UDim.new(0, 12),
        })

        local valueLabels = {}
        for _, row in ipairs(rows) do
            local rowFrame = New("Frame", {
                Parent = card,
                Size = UDim2.new(1, 0, 0, 22),
                BackgroundTransparency = 1,
            })
            local lbl = New("TextLabel", {
                Parent = rowFrame,
                Size = UDim2.new(0.4, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = ResolveText(row.label, self.Language) .. ":",
                TextColor3 = Theme.TextSecondary,
                Font = Enum.Font.Gotham,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
            })
            self.LocalizedObjects[lbl] = { kind = "text", data = row.label, suffix = ":" }

            local val = New("TextLabel", {
                Parent = rowFrame,
                Size = UDim2.new(0.6, 0, 1, 0),
                Position = UDim2.new(0.4, 0, 0, 0),
                BackgroundTransparency = 1,
                Text = row.value or "",
                TextColor3 = Theme.TextPrimary,
                Font = Enum.Font.GothamBold,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
            })
            valueLabels[row.key or row.value] = val
        end
        return card, valueLabels
    end

    -- Hàm đổi ngôn ngữ
    function self:SetLanguage(lang)
        self.Language = lang
        for inst, info in pairs(self.LocalizedObjects) do
            if not inst.Parent then continue end
            if info.kind == "text" then
                inst.Text = ResolveText(info.data, lang) .. (info.suffix or "")
            elseif info.kind == "tabButton" then
                inst.Text = (info.icon and (info.icon.." ") or "") .. ResolveText(info.data, lang)
            end
        end
    end

    return self
end

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
}

-- // Variables
local FlySpeed = 50
local JumpPower = 250
local GhostStealth = 0.3
local flyEnabled = false
local bodyVelocity = nil
local AutoFarmTarget = nil
local AutoFarmQueue = {}
local SelectedMapPoint = nil
local SelectedMapName = "Chưa chọn"
local DetectedMapPoints = {}
local ESPObjects = {}
local ESPUpdateRate = 0.3

-- // Khởi tạo ModernUI
local UI = CreateModernUI()

-- // Tạo các Tab
local tabMain = UI:AddTab("main", { vi="🏠 Trang chủ", en="🏠 Home", ko="🏠 홈" })
local tabFeatures = UI:AddTab("features", { vi="⚡ Tính năng", en="⚡ Features", ko="⚡ 기능" })
local tabESP = UI:AddTab("esp", { vi="👁️ ESP", en="👁️ ESP", ko="👁️ ESP" })
local tabMap = UI:AddTab("map", { vi="🗺️ Map", en="🗺️ Map", ko="🗺️ 지도" })
local tabAdmin = UI:AddTab("admin", { vi="👤 Admin", en="👤 Admin", ko="👤 관리자" })
local tabSettings = UI:AddTab("settings", { vi="⚙️ Cài đặt", en="⚙️ Settings", ko="⚙️ 설정" })

-- // ===== TAB MAIN =====
UI:AddLabel(tabMain, { vi="🎮 MV HUB v4.2 - Modern UI", en="🎮 MV HUB v4.2 - Modern UI", ko="🎮 MV HUB v4.2 - 모던 UI" })

-- Thông tin ngày giờ
local function updateDateTime()
    local now = os.time()
    local dateInfo = os.date("*t", now)
    local dateStr = string.format("%02d/%02d/%04d", dateInfo.day, dateInfo.month, dateInfo.year)
    local timeStr = os.date("%H:%M:%S", now)
    return "📅 " .. dateStr .. "  ⏰ " .. timeStr
end

local dateTimeLabel = UI:AddLabel(tabMain, { vi="⏰ Đang cập nhật...", en="⏰ Updating...", ko="⏰ 업데이트 중..." })
spawn(function()
    while wait(1) do
        local text = updateDateTime()
        dateTimeLabel.Text = text
    end
end)

UI:AddLabel(tabMain, { vi="📊 Trạng thái:", en="📊 Status:", ko="📊 상태:" })

local statusCard, statusLabels = UI:AddInfoCard(tabMain, {
    { label = { vi="👤 Người chơi", en="Player", ko="플레이어" }, key = "player", value = LocalPlayer.Name },
    { label = { vi="🌐 Ping", en="Ping", ko="핑" }, key = "ping", value = "0ms" },
    { label = { vi="📍 Vị trí", en="Position", ko="위치" }, key = "position", value = "0, 0, 0" },
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

UI:AddButton(tabMain, { vi="🔄 Quét lại Map", en="🔄 Rescan Map", ko="🔄 지도 재검색" }, function()
    ScanMap()
    BuildMapUI()
end)

-- // ===== TAB FEATURES =====
UI:AddLabel(tabFeatures, { vi="🔧 Tính năng chính", en="🔧 Main Features", ko="🔧 주요 기능" })

-- Các toggle
local toggleFixLag = UI:AddToggle(tabFeatures, { vi="🔧 Fix Lag", en="🔧 Fix Lag", ko="🔧 랙 수정" }, false, function(state)
    Toggles.FixLag = state
end)

local toggleSuperJump = UI:AddToggle(tabFeatures, { vi="🦘 Super Jump", en="🦘 Super Jump", ko="🦘 슈퍼 점프" }, false, function(state)
    Toggles.SuperJump = state
end)

local toggleFly = UI:AddToggle(tabFeatures, { vi="✈️ Fly (F)", en="✈️ Fly (F)", ko="✈️ 비행 (F)" }, false, function(state)
    Toggles.Fly = state
    if not state and flyEnabled then
        flyEnabled = false
        if bodyVelocity then bodyVelocity:Destroy() end
        bodyVelocity = nil
    end
end)

local toggleNoclip = UI:AddToggle(tabFeatures, { vi="👻 Noclip", en="👻 Noclip", ko="👻 노클립" }, false, function(state)
    Toggles.Noclip = state
end)

local toggleAutoFarm = UI:AddToggle(tabFeatures, { vi="🤖 Auto Farm", en="🤖 Auto Farm", ko="🤖 자동 파밍" }, false, function(state)
    Toggles.AutoFarm = state
    if state then
        StartAutoFarm()
    else
        StopAutoFarm()
    end
end)

-- Sliders
UI:AddLabel(tabFeatures, { vi="📊 Điều chỉnh", en="📊 Adjustments", ko="📊 조정" })

local speedSlider = UI:AddSlider(tabFeatures, { vi="✈️ Tốc độ bay", en="✈️ Fly Speed", ko="✈️ 비행 속도" }, 10, 200, 50, 1, function(val)
    FlySpeed = val
end)

local jumpSlider = UI:AddSlider(tabFeatures, { vi="🦘 Lực nhảy", en="🦘 Jump Power", ko="🦘 점프력" }, 50, 500, 250, 10, function(val)
    JumpPower = val
end)

-- // ===== TAB ESP =====
UI:AddLabel(tabESP, { vi="👁️ Cài đặt ESP", en="👁️ ESP Settings", ko="👁️ ESP 설정" })

local toggleESPPlayers = UI:AddToggle(tabESP, { vi="👤 ESP Người chơi", en="👤 Player ESP", ko="👤 플레이어 ESP" }, false, function(state)
    Toggles.ESPPlayers = state
end)

local toggleESPMobs = UI:AddToggle(tabESP, { vi="👾 ESP Quái", en="👾 Mob ESP", ko="👾 몹 ESP" }, false, function(state)
    Toggles.ESPMobs = state
end)

local toggleESPFruits = UI:AddToggle(tabESP, { vi="🍎 ESP Trái cây", en="🍎 Fruit ESP", ko="🍎 과일 ESP" }, false, function(state)
    Toggles.ESPFruits = state
end)

local toggleAutoTeleportFruit = UI:AddToggle(tabESP, { vi="🚀 Tự động dịch chuyển đến trái cây", en="🚀 Auto teleport to fruit", ko="🚀 과일로 자동 텔레포트" }, false, function(state)
    Toggles.AutoTeleportFruit = state
    if state then
        StartAutoTeleportFruit()
    else
        StopAutoTeleportFruit()
    end
end)

-- // ===== TAB MAP =====
UI:AddLabel(tabMap, { vi="🗺️ Bản đồ Server", en="🗺️ Server Map", ko="🗺️ 서버 지도" })

local selectedMapLabel = UI:AddLabel(tabMap, { vi="📍 Đã chọn: Chưa chọn", en="📍 Selected: None", ko="📍 선택됨: 없음" })

-- Map list container
local mapContainer = New("Frame", {
    Parent = tabMap.Page,
    Size = UDim2.new(1, 0, 0, 200),
    BackgroundColor3 = Theme.Panel,
    BorderSizePixel = 0,
})
Round(mapContainer)
New("UIListLayout", {
    Parent = mapContainer,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 4),
})
New("UIPadding", {
    Parent = mapContainer,
    PaddingTop = UDim.new(0, 8),
    PaddingLeft = UDim.new(0, 8),
    PaddingRight = UDim.new(0, 8),
})

-- Hàm quét map
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
    end
    if #DetectedMapPoints > 30 then
        local newList = {}
        for i = 1, 30 do
            newList[i] = DetectedMapPoints[i]
        end
        DetectedMapPoints = newList
    end
    return DetectedMapPoints
end

-- Hàm build Map UI
function BuildMapUI()
    -- Clear existing map buttons
    for _, child in pairs(mapContainer:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    ScanMap()
    
    -- Refresh button
    local refreshBtn = UI:AddButton(tabMap, { vi="🔄 Quét lại", en="🔄 Rescan", ko="🔄 재검색" }, function()
        BuildMapUI()
    end)
    
    -- Map points
    for _, mapData in ipairs(DetectedMapPoints) do
        local btn = New("TextButton", {
            Parent = mapContainer,
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = Theme.TabInactive,
            Text = mapData.Name,
            TextColor3 = Theme.TextPrimary,
            TextScaled = true,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            BorderSizePixel = 0,
        })
        Round(btn, UDim.new(0, 4))
        
        btn.MouseButton1Click:Connect(function()
            SelectedMapPoint = mapData.Position
            SelectedMapName = mapData.Name
            selectedMapLabel.Text = "📍 " .. SelectedMapName
            
            -- Highlight selected
            for _, child in pairs(mapContainer:GetChildren()) do
                if child:IsA("TextButton") then
                    child.BackgroundColor3 = Theme.TabInactive
                end
            end
            btn.BackgroundColor3 = Theme.Success
        end)
    end
    
    -- Teleport button
    local teleportBtn = UI:AddButton(tabMap, { vi="🚀 Dịch chuyển", en="🚀 Teleport", ko="🚀 텔레포트" }, function()
        if SelectedMapPoint then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = CFrame.new(SelectedMapPoint + Vector3.new(0, 5, 0))
                print("🚀 Teleported to: " .. SelectedMapName)
            end
        else
            print("⚠️ Chưa chọn điểm đến!")
        end
    end)
end

BuildMapUI()

-- // ===== TAB ADMIN =====
UI:AddLabel(tabAdmin, { vi="👤 Thông tin Admin", en="👤 Admin Info", ko="👤 관리자 정보" })

UI:AddInfoCard(tabAdmin, {
    { label = { vi="👤 Tên", en="Name", ko="이름" }, key = "name", value = "MV Boss" },
    { label = { vi="📅 Ngày sinh", en="Birthday", ko="생일" }, key = "birthday", value = "01/01/2000" },
    { label = { vi="📝 Bio", en="Bio", ko="자기소개" }, key = "bio", value = "⚡ MV HUB Developer" },
    { label = { vi="🕐 Giờ hoạt động", en="Active Time", ko="활동 시간" }, key = "active", value = "24/7" },
})

-- // ===== TAB SETTINGS =====
UI:AddLabel(tabSettings, { vi="⚙️ Cài đặt", en="⚙️ Settings", ko="⚙️ 설정" })

-- Language dropdown
local languageOptions = {
    { id = "vi", label = { vi="🇻🇳 Tiếng Việt", en="🇻🇳 Vietnamese", ko="🇻🇳 베트남어" } },
    { id = "en", label = { vi="🇬🇧 Tiếng Anh", en="🇬🇧 English", ko="🇬🇧 영어" } },
    { id = "ko", label = { vi="🇰🇷 Tiếng Hàn", en="🇰🇷 Korean", ko="🇰🇷 한국어" } },
}

local langDropdown = UI:AddDropdown(tabSettings, { vi="🌐 Ngôn ngữ", en="🌐 Language", ko="🌐 언어" }, languageOptions, "vi", function(id)
    UI:SetLanguage(id)
end)

UI:AddButton(tabSettings, { vi="💾 Lưu cài đặt", en="💾 Save Settings", ko="💾 설정 저장" }, function()
    print("💾 Settings saved!")
end)

-- // ===== FUNCTIONS =====

-- Fix Lag
local function FixLag()
    spawn(function()
        while wait(1) do
            if Toggles.FixLag then
                settings().Rendering.QualityLevel = 1
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                        v.Enabled = false
                    end
                end
                Lighting.GlobalShadows = false
                Lighting.Brightness = 2
            end
        end
    end)
end

-- Super Jump
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

-- Fly
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
            else
                if bodyVelocity then bodyVelocity:Destroy() end
                bodyVelocity = nil
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
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + Camera.CFrame.LookVector * Vector3.new(1, 0, 1) end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - Camera.CFrame.LookVector * Vector3.new(1, 0, 1) end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - Camera.CFrame.RightVector * Vector3.new(1, 0, 1) end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + Camera.CFrame.RightVector * Vector3.new(1, 0, 1) end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDirection = moveDirection - Vector3.new(0, 1, 0) end

                if moveDirection.Magnitude > 0 then
                    moveDirection = moveDirection.Unit * FlySpeed
                end
                bodyVelocity.Velocity = moveDirection
            end
        end
    end)
end

-- Noclip
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

-- Ghost Mode
local function GhostMode()
    spawn(function()
        while wait(0.1) do
            if Toggles.Ghost then
                local char = LocalPlayer.Character
                if char then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.Transparency = GhostStealth
                            if GhostStealth <= 0.1 then
                                part.CanCollide = false
                            end
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

-- Night Vision
local function NightVision()
    spawn(function()
        while wait(0.5) do
            if Toggles.NightVision then
                Lighting.Brightness = 5
                Lighting.ClockTime = 12
                Lighting.FogEnd = 99999
                Lighting.GlobalShadows = false
                Lighting.Ambient = Color3.fromRGB(255, 255, 255)
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

-- ESP Functions
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
        while wait(ESPUpdateRate) do
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

            local newList = {}
            for _, data in pairs(ESPObjects) do
                if data.Active ~= false and data.Object and data.Object.Parent then
                    table.insert(newList, data)
                end
            end
            ESPObjects = newList
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

            if Toggles.ESPFruits then
                for _, v in pairs(Workspace:GetDescendants()) do
                    if v:IsA("Model") and v.Name:lower():find("fruit") then
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

-- Auto Teleport to Fruit
local fruitTarget = nil
local fruitTeleportEnabled = false

function StartAutoTeleportFruit()
    fruitTeleportEnabled = true
    spawn(function()
        while fruitTeleportEnabled and Toggles.AutoTeleportFruit do
            local char = LocalPlayer.Character
            if not char then wait(0.5) continue end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then wait(0.5) continue end
            
            -- Tìm trái cây gần nhất
            local nearestFruit = nil
            local nearestDist = math.huge
            
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("Model") and v.Name:lower():find("fruit") then
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
            
            if nearestFruit and nearestDist < 500 then
                root.CFrame = CFrame.new(nearestFruit.Position + Vector3.new(0, 3, 0))
                print("🍎 Teleported to fruit!")
                wait(1)
            end
            wait(0.5)
        end
    end)
end

function StopAutoTeleportFruit()
    fruitTeleportEnabled = false
end

-- Auto Farm
function StartAutoFarm()
    spawn(function()
        while Toggles.AutoFarm do
            local char = LocalPlayer.Character
            if not char then wait(0.5) continue end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then wait(0.5) continue end
            
            -- Tìm quái gần nhất
            local nearestMob = nil
            local nearestDist = math.huge
            
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                    local name = v.Name:lower()
                    if name:find("npc") or name:find("mob") or name:find("boss") or name:find("enemy") then
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
                
                -- Đánh quái
                local humanoid = nearestMob:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.Health = 0
                end
                wait(0.5)
            else
                -- Di chuyển đến vị trí random nếu không có quái
                local randomPos = Vector3.new(
                    math.random(-100, 100),
                    10,
                    math.random(-100, 100)
                )
                root.CFrame = CFrame.new(randomPos)
                wait(1)
            end
            wait(0.3)
        end
    end)
end

function StopAutoFarm()
    -- Clean up
end

-- Anti-Idle
local function AntiIdle()
    spawn(function()
        while wait(60) do
            game:GetService("Players").LocalPlayer.Idled:Connect(function()
                game:GetService("VirtualUser"):ClickButton2(Vector2.new())
            end)
        end
    end)
end

-- // Khởi tạo
FixLag()
SuperJump()
Fly()
Noclip()
ESPLoop()
UpdateDistances()
GhostMode()
NightVision()
AntiIdle()

-- // Hotkeys
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.M then
        UI.MainFrame.Visible = not UI.MainFrame.Visible
    end
    if input.KeyCode == Enum.KeyCode.F1 then
        Toggles.Ghost = not Toggles.Ghost
        -- Update toggle UI
    end
    if input.KeyCode == Enum.KeyCode.F2 then
        Toggles.NightVision = not Toggles.NightVision
    end
end)

print("⚡ MV HUB v4.2 - ModernUI Integrated - Loaded Successfully!")
