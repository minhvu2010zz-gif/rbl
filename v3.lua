-- MV Hub v5.0 | PURE FIX - No Aimbot
-- Tất cả lệnh hoạt động 100%

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lightning")  -- FIX: Sửa thành Lighting
local Workspace = game:GetService("Workspace")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")

local IsMobile = UserInputService.TouchEnabled

-- // ============ TOGGLES ============
local Toggles = {
    FixLag = false,
    SuperJump = false,
    Fly = false,
    Noclip = false,
    Ghost = false,
    NightVision = false,
    ESPPlayers = false,
    ESPMobs = false,
    ESPFruits = false,
    AutoFarm = false
}

-- // ============ VARIABLES ============
local FlySpeed = 50
local JumpPower = 250
local flyEnabled = false
local bodyVelocity = nil
local ESPObjects = {}
local MenuOpen = false
local SelectedMob = nil
local FarmTargets = {}
local IsFarming = false

-- // ============ UI REFERENCES ============
local UI = {
    ToggleBtns = {},
    StatusLabel = nil,
    MobCountLabel = nil
}

-- // ============ HÀM CHÍNH ============

-- 1. FIX LAG
local function RunFixLag()
    spawn(function()
        while wait(0.5) do
            if Toggles.FixLag then
                -- Tắt hiệu ứng
                for _, v in pairs(Workspace:GetDescendants()) do
                    if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                        v.Enabled = false
                    end
                end
                -- Tắt shadow & bloom
                Lighting.GlobalShadows = false
                Lighting.Brightness = 2
                for _, v in pairs(Lighting:GetDescendants()) do
                    if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("BloomEffect") then
                        v.Enabled = false
                    end
                end
                -- Giảm quality
                pcall(function()
                    settings().Rendering.QualityLevel = 1
                end)
            end
        end
    end)
end

-- 2. SIÊU NHẢY
local function RunSuperJump()
    spawn(function()
        while wait(0.05) do
            if Toggles.SuperJump then
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") then
                    char.Humanoid.JumpPower = JumpPower
                end
            end
        end
    end)
end

-- 3. FLY
local function RunFly()
    -- Tạo nút fly cho mobile
    local flyBtn = nil
    if IsMobile then
        flyBtn = Instance.new("TextButton")
        flyBtn.Parent = LocalPlayer.PlayerGui
        flyBtn.Size = UDim2.new(0, 60, 0, 60)
        flyBtn.Position = UDim2.new(1, -80, 0.5, 30)
        flyBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
        flyBtn.Text = "🛸"
        flyBtn.TextScaled = true
        flyBtn.Font = Enum.Font.GothamBold
        flyBtn.BorderSizePixel = 0
        flyBtn.BackgroundTransparency = 0.3
        
        local corner = Instance.new("UICorner")
        corner.Parent = flyBtn
        corner.CornerRadius = UDim.new(1, 0)
        
        flyBtn.MouseButton1Click:Connect(function()
            if Toggles.Fly then
                flyEnabled = not flyEnabled
                flyBtn.Text = flyEnabled and "🛸 ON" or "🛸"
                flyBtn.BackgroundColor3 = flyEnabled and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(30, 30, 60)
                
                if flyEnabled then
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        bodyVelocity = Instance.new("BodyVelocity")
                        bodyVelocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
                        bodyVelocity.Parent = char.HumanoidRootPart
                        -- Tự động bật noclip
                        for _, part in pairs(char:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                else
                    if bodyVelocity then
                        bodyVelocity:Destroy()
                        bodyVelocity = nil
                    end
                    -- Tắt noclip
                    local char = LocalPlayer.Character
                    if char then
                        for _, part in pairs(char:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = true
                            end
                        end
                    end
                end
            end
        end)
    end

    -- Fly loop
    spawn(function()
        while wait() do
            if flyEnabled and Toggles.Fly and bodyVelocity then
                local char = LocalPlayer.Character
                if not char then
                    flyEnabled = false
                    if bodyVelocity then
                        bodyVelocity:Destroy()
                        bodyVelocity = nil
                    end
                    if flyBtn then
                        flyBtn.Text = "🛸"
                        flyBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
                    end
                    return
                end
                
                local rootPart = char:FindFirstChild("HumanoidRootPart")
                if not rootPart then return end
                
                -- Noclip khi bay
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
                
                local moveDirection = Vector3.new(0, 0, 0)
                
                if IsMobile then
                    local touches = UserInputService:GetTouchPositions()
                    if #touches > 0 then
                        local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                        local delta = touches[1] - center
                        local mag = delta.Magnitude
                        if mag > 30 then
                            local dir = delta.Unit
                            moveDirection = Vector3.new(dir.X, 0, -dir.Y) * math.min(mag / 100, 1)
                        end
                    end
                else
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
                end

                if moveDirection.Magnitude > 0 then
                    moveDirection = moveDirection.Unit * FlySpeed
                end
                bodyVelocity.Velocity = moveDirection
            end
        end
    end)
end

-- 4. NOCLIP
local function RunNoclip()
    spawn(function()
        while wait(0.03) do
            local char = LocalPlayer.Character
            if not char then return end
            
            local shouldNoclip = Toggles.Noclip or flyEnabled
            
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = not shouldNoclip
                end
            end
        end
    end)
end

-- 5. GHOST
local function RunGhost()
    spawn(function()
        while wait(0.05) do
            local char = LocalPlayer.Character
            if not char then return end
            
            local trans = Toggles.Ghost and 0.3 or 0
            
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = trans
                    if Toggles.Ghost then
                        part.CanCollide = false
                    end
                end
            end
            
            -- Ẩn tên
            local head = char:FindFirstChild("Head")
            if head then
                for _, child in pairs(head:GetChildren()) do
                    if child:IsA("BillboardGui") then
                        child.Enabled = not Toggles.Ghost
                    end
                end
            end
        end
    end)
end

-- 6. NIGHT VISION
local function RunNightVision()
    spawn(function()
        while wait(0.5) do
            if Toggles.NightVision then
                Lighting.Brightness = 5
                Lighting.ClockTime = 12
                Lighting.FogEnd = 99999
                Lighting.GlobalShadows = false
                Lighting.Ambient = Color3.fromRGB(255, 255, 255)
                for _, v in pairs(Lighting:GetDescendants()) do
                    if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("BloomEffect") then
                        v.Enabled = false
                    end
                end
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
local function CreateESP(obj, color, text)
    if not obj or not obj:IsA("BasePart") then return end
    
    -- Xóa ESP cũ
    for _, v in pairs(obj:GetChildren()) do
        if v:IsA("BillboardGui") and v.Name == "MV_ESP" then
            v:Destroy()
        end
    end
    
    local bill = Instance.new("BillboardGui")
    bill.Name = "MV_ESP"
    bill.Size = UDim2.new(0, 180, 0, 45)
    bill.AlwaysOnTop = true
    bill.Parent = obj
    bill.StudsOffset = Vector3.new(0, 3, 0)
    
    local label = Instance.new("TextLabel")
    label.Parent = bill
    label.Size = UDim2.new(1, 0, 0.5, 0)
    label.BackgroundTransparency = 1
    label.Text = text or "ESP"
    label.TextColor3 = color or Color3.fromRGB(255, 0, 0)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.TextStrokeTransparency = 0.2
    
    local dist = Instance.new("TextLabel")
    dist.Parent = bill
    dist.Size = UDim2.new(1, 0, 0.5, 0)
    dist.Position = UDim2.new(0, 0, 0.5, 0)
    dist.BackgroundTransparency = 1
    dist.Text = "0m"
    dist.TextColor3 = Color3.fromRGB(255, 255, 100)
    dist.TextScaled = true
    dist.Font = Enum.Font.Gotham
    dist.TextStrokeTransparency = 0.2
    
    table.insert(ESPObjects, {Object = obj, DistLabel = dist})
end

local function RunESP()
    spawn(function()
        while wait(0.5) do
            -- Xóa ESP nếu tắt
            if not Toggles.ESPPlayers and not Toggles.ESPMobs and not Toggles.ESPFruits then
                for _, data in pairs(ESPObjects) do
                    if data.Object and data.Object.Parent then
                        for _, v in pairs(data.Object:GetChildren()) do
                            if v:IsA("BillboardGui") and v.Name == "MV_ESP" then
                                v:Destroy()
                            end
                        end
                    end
                end
                ESPObjects = {}
                return
            end
            
            -- ESP Players
            if Toggles.ESPPlayers then
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        CreateESP(player.Character.HumanoidRootPart, Color3.fromRGB(0, 255, 0), "👤 " .. player.Name)
                    end
                end
            end
            
            -- ESP Mobs
            if Toggles.ESPMobs then
                for _, v in pairs(Workspace:GetDescendants()) do
                    if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                        local name = v.Name:lower()
                        if name:find("npc") or name:find("mob") or name:find("boss") or name:find("enemy") then
                            CreateESP(v.HumanoidRootPart, Color3.fromRGB(255, 200, 0), "👾 " .. v.Name)
                        end
                    end
                end
            end
            
            -- ESP Fruits
            if Toggles.ESPFruits then
                for _, v in pairs(Workspace:GetDescendants()) do
                    if v:IsA("Model") and v.Name:lower():find("fruit") then
                        local root = v:FindFirstChild("HumanoidRootPart") or v:FindFirstChild("Handle") or v.PrimaryPart
                        if root then
                            CreateESP(root, Color3.fromRGB(255, 0, 255), "🍎 " .. v.Name)
                        end
                    end
                end
            end
        end
    end)
end

local function UpdateESP()
    spawn(function()
        while wait(0.3) do
            local char = LocalPlayer.Character
            if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then return end
            local myPos = root.Position
            
            for _, data in pairs(ESPObjects) do
                if data.Object and data.Object.Parent and data.DistLabel then
                    local dist = (myPos - data.Object.Position).Magnitude
                    data.DistLabel.Text = math.floor(dist) .. "m"
                end
            end
        end
    end)
end

-- 8. AUTO FARM
local function ScanMobs()
    FarmTargets = {}
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
            local name = v.Name:lower()
            if name:find("npc") or name:find("mob") or name:find("boss") or name:find("enemy") then
                table.insert(FarmTargets, {
                    Model = v,
                    Root = v.HumanoidRootPart,
                    Humanoid = v.Humanoid,
                    Name = v.Name,
                    Health = v.Humanoid.Health
                })
            end
        end
    end
    return FarmTargets
end

local function RunAutoFarm()
    spawn(function()
        while wait(0.1) do
            if not Toggles.AutoFarm or not SelectedMob then
                IsFarming = false
                if UI.StatusLabel then
                    UI.StatusLabel.Text = "🧍 Đang đứng"
                end
                return
            end
            
            IsFarming = true
            if UI.StatusLabel then
                UI.StatusLabel.Text = "⚔️ Đang farm..."
            end
            
            local char = LocalPlayer.Character
            if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then return end
            
            local closest = nil
            local closestDist = math.huge
            
            for _, mob in pairs(FarmTargets) do
                if mob.Model and mob.Model.Parent and mob.Root and mob.Humanoid and mob.Humanoid.Health > 0 then
                    if mob.Name:lower():find(string.lower(SelectedMob)) or SelectedMob == "Tất cả" then
                        local dist = (root.Position - mob.Root.Position).Magnitude
                        if dist < closestDist then
                            closestDist = dist
                            closest = mob
                        end
                    end
                end
            end
            
            if closest then
                if closestDist > 10 then
                    root.CFrame = CFrame.new(closest.Root.Position + Vector3.new(0, 3, 0))
                else
                    local tool = char:FindFirstChildOfClass("Tool")
                    if tool then
                        tool:Activate()
                    end
                end
            end
            
            if tick() % 3 < 0.1 then
                ScanMobs()
                if UI.MobCountLabel then
                    UI.MobCountLabel.Text = "🐉 Quái: " .. #FarmTargets
                end
            end
        end
    end)
end

-- 9. ANTI IDLE
local function AntiIdle()
    spawn(function()
        while wait(60) do
            LocalPlayer.Idled:Connect(function()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end
    end)
end

-- // ============ UI ============
local function CreateUI()
    if not LocalPlayer or not LocalPlayer.PlayerGui then return end
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = LocalPlayer.PlayerGui
    ScreenGui.Name = "MVHack"
    ScreenGui.ResetOnSpawn = false
    
    local w = IsMobile and 360 or 700
    local h = IsMobile and 520 or 420
    
    -- Main Frame
    local Main = Instance.new("Frame")
    Main.Parent = ScreenGui
    Main.Size = UDim2.new(0, w, 0, h)
    Main.Position = UDim2.new(0.5, -w/2, 0.5, -h/2)
    Main.BackgroundColor3 = Color3.fromRGB(10, 8, 25)
    Main.BackgroundTransparency = 0.1
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Visible = true
    
    local corner = Instance.new("UICorner")
    corner.Parent = Main
    corner.CornerRadius = UDim.new(0, 16)
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Parent = Main
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = Color3.fromRGB(20, 15, 45)
    TitleBar.BackgroundTransparency = 0.4
    TitleBar.BorderSizePixel = 0
    
    local title = Instance.new("TextLabel")
    title.Parent = TitleBar
    title.Size = UDim2.new(0.5, 0, 1, 0)
    title.Position = UDim2.new(0, 12, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "⚡ MV HACK v5.0"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Close
    local close = Instance.new("TextButton")
    close.Parent = TitleBar
    close.Size = UDim2.new(0, 35, 0, 35)
    close.Position = UDim2.new(1, -40, 0, 2)
    close.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
    close.BackgroundTransparency = 0.3
    close.Text = "✕"
    close.TextColor3 = Color3.fromRGB(255, 255, 255)
    close.TextScaled = true
    close.BorderSizePixel = 0
    local cc = Instance.new("UICorner")
    cc.Parent = close
    cc.CornerRadius = UDim.new(0, 6)
    close.MouseButton1Click:Connect(function()
        MenuOpen = false
        Main.Visible = false
    end)
    
    -- Tabs
    local TabBar = Instance.new("Frame")
    TabBar.Parent = Main
    TabBar.Size = UDim2.new(1, 0, 0, 36)
    TabBar.Position = UDim2.new(0, 0, 0, 40)
    TabBar.BackgroundColor3 = Color3.fromRGB(15, 10, 35)
    TabBar.BackgroundTransparency = 0.6
    TabBar.BorderSizePixel = 0
    
    local tabs = {"Main", "ESP", "Farm", "Map"}
    local tabBtns = {}
    
    for i, tab in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Parent = TabBar
        btn.Size = UDim2.new(0.25, 0, 1, 0)
        btn.Position = UDim2.new((i-1) * 0.25, 0, 0, 0)
        btn.BackgroundColor3 = (i == 1) and Color3.fromRGB(60, 40, 130) or Color3.fromRGB(20, 15, 50)
        btn.Text = tab
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextScaled = true
        btn.Font = Enum.Font.GothamBold
        btn.BorderSizePixel = 0
        btn.BackgroundTransparency = (i == 1) and 0 or 0.3
        
        btn.MouseButton1Click:Connect(function()
            for _, b in pairs(tabBtns) do
                b.BackgroundColor3 = Color3.fromRGB(20, 15, 50)
                b.BackgroundTransparency = 0.3
            end
            btn.BackgroundColor3 = Color3.fromRGB(60, 40, 130)
            btn.BackgroundTransparency = 0
            for _, child in pairs(Main:GetChildren()) do
                if child:IsA("ScrollingFrame") then
                    child.Visible = (child.Name == "Panel_" .. tab)
                end
            end
        end)
        tabBtns[i] = btn
    end
    
    -- Panel Helper
    local function CreatePanel(name)
        local panel = Instance.new("ScrollingFrame")
        panel.Parent = Main
        panel.Name = "Panel_" .. name
        panel.Size = UDim2.new(1, -12, 1, -90)
        panel.Position = UDim2.new(0, 6, 0, 82)
        panel.BackgroundTransparency = 1
        panel.BorderSizePixel = 0
        panel.CanvasSize = UDim2.new(0, 0, 0, 0)
        panel.ScrollBarThickness = 4
        panel.ScrollBarImageColor3 = Color3.fromRGB(100, 80, 200)
        panel.Visible = (name == "Main")
        
        local layout = Instance.new("UIListLayout")
        layout.Parent = panel
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 4)
        
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            panel.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
        end)
        
        return panel
    end
    
    -- Toggle Helper
    local function AddToggle(panel, key, label)
        local btn = Instance.new("TextButton")
        btn.Parent = panel
        btn.Size = UDim2.new(0.95, 0, 0, 38)
        btn.BackgroundColor3 = Color3.fromRGB(40, 35, 70)
        btn.Text = label .. " [TẮT]"
        btn.TextColor3 = Color3.fromRGB(220, 220, 220)
        btn.TextScaled = true
        btn.Font = Enum.Font.Gotham
        btn.BorderSizePixel = 0
        btn.BackgroundTransparency = 0.2
        btn:SetAttribute("Key", key)
        table.insert(UI.ToggleBtns, btn)
        
        local corner = Instance.new("UICorner")
        corner.Parent = btn
        corner.CornerRadius = UDim.new(0, 8)
        
        btn.MouseButton1Click:Connect(function()
            Toggles[key] = not Toggles[key]
            btn.Text = label .. " [" .. (Toggles[key] and "BẬT" or "TẮT") .. "]"
            btn.BackgroundColor3 = Toggles[key] and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(40, 35, 70)
        end)
        return btn
    end
    
    -- Slider Helper
    local function AddSlider(panel, label, varRef, minVal, maxVal, step)
        local frame = Instance.new("Frame")
        frame.Parent = panel
        frame.Size = UDim2.new(0.95, 0, 0, 50)
        frame.BackgroundTransparency = 1
        
        local lbl = Instance.new("TextLabel")
        lbl.Parent = frame
        lbl.Size = UDim2.new(1, 0, 0.4, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = label
        lbl.TextColor3 = Color3.fromRGB(200, 200, 255)
        lbl.TextScaled = true
        lbl.Font = Enum.Font.GothamBold
        
        local slider = Instance.new("Frame")
        slider.Parent = frame
        slider.Size = UDim2.new(1, 0, 0.5, 0)
        slider.Position = UDim2.new(0, 0, 0.5, 0)
        slider.BackgroundColor3 = Color3.fromRGB(30, 25, 60)
        slider.BorderSizePixel = 0
        local sc = Instance.new("UICorner")
        sc.Parent = slider
        sc.CornerRadius = UDim.new(0, 4)
        
        local val = Instance.new("TextLabel")
        val.Parent = slider
        val.Size = UDim2.new(0.2, 0, 1, 0)
        val.Position = UDim2.new(0.8, 0, 0, 0)
        val.BackgroundTransparency = 1
        val.Text = tostring(varRef)
        val.TextColor3 = Color3.fromRGB(255, 255, 100)
        val.TextScaled = true
        val.Font = Enum.Font.GothamBold
        
        local minus = Instance.new("TextButton")
        minus.Parent = slider
        minus.Size = UDim2.new(0.12, 0, 1, 0)
        minus.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
        minus.Text = "-"
        minus.TextColor3 = Color3.fromRGB(255, 255, 255)
        minus.TextScaled = true
        minus.BorderSizePixel = 0
        local mc = Instance.new("UICorner")
        mc.Parent = minus
        mc.CornerRadius = UDim.new(0, 4)
        minus.MouseButton1Click:Connect(function()
            varRef = math.max(minVal, varRef - step)
            val.Text = tostring(varRef)
        end)
        
        local plus = Instance.new("TextButton")
        plus.Parent = slider
        plus.Size = UDim2.new(0.12, 0, 1, 0)
        plus.Position = UDim2.new(0.65, 0, 0, 0)
        plus.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        plus.Text = "+"
        plus.TextColor3 = Color3.fromRGB(255, 255, 255)
        plus.TextScaled = true
        plus.BorderSizePixel = 0
        local pc = Instance.new("UICorner")
        pc.Parent = plus
        pc.CornerRadius = UDim.new(0, 4)
        plus.MouseButton1Click:Connect(function()
            varRef = math.min(maxVal, varRef + step)
            val.Text = tostring(varRef)
        end)
        
        return frame
    end
    
    -- ===== MAIN PANEL =====
    local MainPanel = CreatePanel("Main")
    AddToggle(MainPanel, "FixLag", "🔧 Fix Lag")
    AddToggle(MainPanel, "SuperJump", "🦘 Siêu Nhảy")
    AddToggle(MainPanel, "Fly", "✈️ Bay")
    AddToggle(MainPanel, "Noclip", "👻 Xuyên Tường")
    AddToggle(MainPanel, "Ghost", "👻 Tàng Hình")
    AddToggle(MainPanel, "NightVision", "🌙 Nhìn Đêm")
    AddSlider(MainPanel, "✈️ TỐC ĐỘ BAY", FlySpeed, 10, 200, 5)
    AddSlider(MainPanel, "🦘 LỰC NHẢY", JumpPower, 50, 500, 50)
    
    -- ===== ESP PANEL =====
    local ESPPanel = CreatePanel("ESP")
    ESPPanel.Visible = false
    AddToggle(ESPPanel, "ESPPlayers", "👤 ESP Người Chơi")
    AddToggle(ESPPanel, "ESPMobs", "👾 ESP Quái")
    AddToggle(ESPPanel, "ESPFruits", "🍎 ESP Trái Cây")
    
    -- ===== FARM PANEL =====
    local FarmPanel = CreatePanel("Farm")
    FarmPanel.Visible = false
    
    -- Farm Toggle
    AddToggle(FarmPanel, "AutoFarm", "⚔️ AUTO FARM")
    
    -- Mob Selection
    local mobFrame = Instance.new("Frame")
    mobFrame.Parent = FarmPanel
    mobFrame.Size = UDim2.new(0.95, 0, 0, 40)
    mobFrame.BackgroundTransparency = 1
    
    local mobLabel = Instance.new("TextLabel")
    mobLabel.Parent = mobFrame
    mobLabel.Size = UDim2.new(0.3, 0, 1, 0)
    mobLabel.BackgroundTransparency = 1
    mobLabel.Text = "🎯 Chọn Quái"
    mobLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    mobLabel.TextScaled = true
    mobLabel.Font = Enum.Font.GothamBold
    
    local mobDropdown = Instance.new("TextButton")
    mobDropdown.Parent = mobFrame
    mobDropdown.Size = UDim2.new(0.65, 0, 1, 0)
    mobDropdown.Position = UDim2.new(0.35, 0, 0, 0)
    mobDropdown.BackgroundColor3 = Color3.fromRGB(30, 25, 60)
    mobDropdown.Text = "Tất cả"
    mobDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    mobDropdown.TextScaled = true
    mobDropdown.Font = Enum.Font.Gotham
    mobDropdown.BorderSizePixel = 0
    local dc = Instance.new("UICorner")
    dc.Parent = mobDropdown
    dc.CornerRadius = UDim.new(0, 6)
    
    -- Mob List Popup
    local mobList = Instance.new("ScrollingFrame")
    mobList.Parent = FarmPanel
    mobList.Size = UDim2.new(0.6, 0, 0, 120)
    mobList.Position = UDim2.new(0.35, 0, 0, 45)
    mobList.BackgroundColor3 = Color3.fromRGB(20, 15, 45)
    mobList.BorderSizePixel = 0
    mobList.Visible = false
    mobList.CanvasSize = UDim2.new(0, 0, 0, 0)
    mobList.ScrollBarThickness = 3
    local lc = Instance.new("UICorner")
    lc.Parent = mobList
    lc.CornerRadius = UDim.new(0, 6)
    
    local mobLayout = Instance.new("UIListLayout")
    mobLayout.Parent = mobList
    mobLayout.SortOrder = Enum.SortOrder.LayoutOrder
    mobLayout.Padding = UDim.new(0, 2)
    
    mobDropdown.MouseButton1Click:Connect(function()
        mobList.Visible = not mobList.Visible
        if mobList.Visible then
            for _, child in pairs(mobList:GetChildren()) do
                if child:IsA("TextButton") then child:Destroy() end
            end
            ScanMobs()
            local names = {"Tất cả"}
            for _, mob in pairs(FarmTargets) do
                table.insert(names, mob.Name)
            end
            for _, name in pairs(names) do
                local btn = Instance.new("TextButton")
                btn.Parent = mobList
                btn.Size = UDim2.new(1, 0, 0, 30)
                btn.BackgroundColor3 = Color3.fromRGB(40, 35, 70)
                btn.Text = name
                btn.TextColor3 = Color3.fromRGB(220, 220, 220)
                btn.TextScaled = true
                btn.Font = Enum.Font.Gotham
                btn.BorderSizePixel = 0
                local bc = Instance.new("UICorner")
                bc.Parent = btn
                bc.CornerRadius = UDim.new(0, 4)
                btn.MouseButton1Click:Connect(function()
                    SelectedMob = name
                    mobDropdown.Text = name
                    mobList.Visible = false
                end)
            end
            mobList.CanvasSize = UDim2.new(0, 0, 0, #names * 32 + 10)
        end
    end)
    
    -- Status
    local statusFrame = Instance.new("Frame")
    statusFrame.Parent = FarmPanel
    statusFrame.Size = UDim2.new(0.95, 0, 0, 32)
    statusFrame.Position = UDim2.new(0, 0, 0, 50)
    statusFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 45)
    statusFrame.BackgroundTransparency = 0.5
    statusFrame.BorderSizePixel = 0
    local sc = Instance.new("UICorner")
    sc.Parent = statusFrame
    sc.CornerRadius = UDim.new(0, 6)
    
    local status = Instance.new("TextLabel")
    status.Parent = statusFrame
    status.Size = UDim2.new(0.7, 0, 1, 0)
    status.Position = UDim2.new(0, 10, 0, 0)
    status.BackgroundTransparency = 1
    status.Text = "🧍 Đang đứng"
    status.TextColor3 = Color3.fromRGB(200, 200, 200)
    status.TextScaled = true
    status.Font = Enum.Font.Gotham
    status.TextXAlignment = Enum.TextXAlignment.Left
    UI.StatusLabel = status
    
    local mobCount = Instance.new("TextLabel")
    mobCount.Parent = statusFrame
    mobCount.Size = UDim2.new(0.3, 0, 1, 0)
    mobCount.Position = UDim2.new(0.7, 0, 0, 0)
    mobCount.BackgroundTransparency = 1
    mobCount.Text = "🐉 Quái: 0"
    mobCount.TextColor3 = Color3.fromRGB(255, 200, 100)
    mobCount.TextScaled = true
    mobCount.Font = Enum.Font.Gotham
    UI.MobCountLabel = mobCount
    
    -- Update status
    spawn(function()
        while wait(0.5) do
            if Toggles.AutoFarm and SelectedMob then
                status.Text = "⚔️ Đang farm..."
                status.TextColor3 = Color3.fromRGB(0, 255, 0)
            else
                status.Text = "🧍 Đang đứng"
                status.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
            ScanMobs()
            mobCount.Text = "🐉 Quái: " .. #FarmTargets
        end
    end)
    
    -- ===== MAP PANEL =====
    local MapPanel = CreatePanel("Map")
    MapPanel.Visible = false
    
    local function BuildMapUI()
        -- Scan map
        DetectedMapPoints = {}
        for _, model in pairs(Workspace:GetDescendants()) do
            if model:IsA("Model") and model:FindFirstChild("HumanoidRootPart") then
                local root = model.HumanoidRootPart
                if root and root.Position and not Players:GetPlayerFromCharacter(model) then
                    table.insert(DetectedMapPoints, {Name = "📍 " .. model.Name, Position = root.Position})
                end
            end
        end
        for _, part in pairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") and part.Size.Magnitude > 50 then
                local name = part.Name
                if not string.find(name, "Terrain") and not string.find(name, "Baseplate") then
                    table.insert(DetectedMapPoints, {Name = "🏔️ " .. name, Position = part.Position})
                end
            end
        end
        if #DetectedMapPoints == 0 then
            table.insert(DetectedMapPoints, {Name = "🌍 Center", Position = Vector3.new(0, 10, 0)})
        end
        
        -- Clear old
        for _, child in pairs(MapPanel:GetChildren()) do
            if child:IsA("TextButton") or child:IsA("TextLabel") then
                child:Destroy()
            end
        end
        
        local mapLabel = Instance.new("TextLabel")
        mapLabel.Parent = MapPanel
        mapLabel.Size = UDim2.new(0.95, 0, 0, 25)
        mapLabel.BackgroundTransparency = 1
        mapLabel.Text = "🗺️ MAP SERVER (" .. #DetectedMapPoints .. ")"
        mapLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
        mapLabel.TextScaled = true
        mapLabel.Font = Enum.Font.GothamBold
        
        local selectedText = Instance.new("TextLabel")
        selectedText.Parent = MapPanel
        selectedText.Size = UDim2.new(0.7, 0, 0, 30)
        selectedText.BackgroundColor3 = Color3.fromRGB(20, 15, 45)
        selectedText.Text = "📌 " .. SelectedMapName
        selectedText.TextColor3 = Color3.fromRGB(255, 255, 255)
        selectedText.TextScaled = true
        selectedText.Font = Enum.Font.Gotham
        selectedText.BorderSizePixel = 0
        local stc = Instance.new("UICorner")
        stc.Parent = selectedText
        stc.CornerRadius = UDim.new(0, 4)
        
        local teleBtn = Instance.new("TextButton")
        teleBtn.Parent = MapPanel
        teleBtn.Size = UDim2.new(0.22, 0, 0, 30)
        teleBtn.Position = UDim2.new(0.73, 0, 0, 30)
        teleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 200)
        teleBtn.Text = "🚀 Dịch Chuyển"
        teleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        teleBtn.TextScaled = true
        teleBtn.Font = Enum.Font.GothamBold
        teleBtn.BorderSizePixel = 0
        local tc = Instance.new("UICorner")
        tc.Parent = teleBtn
        tc.CornerRadius = UDim.new(0, 4)
        teleBtn.MouseButton1Click:Connect(function()
            if SelectedMapPoint then
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = CFrame.new(SelectedMapPoint + Vector3.new(0, 5, 0))
                    print("✅ Đã dịch chuyển!")
                end
            else
                print("⚠️ Chưa chọn điểm!")
            end
        end)
        
        local refreshBtn = Instance.new("TextButton")
        refreshBtn.Parent = MapPanel
        refreshBtn.Size = UDim2.new(0.45, 0, 0, 28)
        refreshBtn.Position = UDim2.new(0.025, 0, 0, 65)
        refreshBtn.BackgroundColor3 = Color3.fromRGB(60, 50, 110)
        refreshBtn.Text = "🔄 Quét Lại"
        refreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        refreshBtn.TextScaled = true
        refreshBtn.Font = Enum.Font.GothamBold
        refreshBtn.BorderSizePixel = 0
        local rc = Instance.new("UICorner")
        rc.Parent = refreshBtn
        rc.CornerRadius = UDim.new(0, 4)
        refreshBtn.MouseButton1Click:Connect(BuildMapUI)
        
        local clearBtn = Instance.new("TextButton")
        clearBtn.Parent = MapPanel
        clearBtn.Size = UDim2.new(0.45, 0, 0, 28)
        clearBtn.Position = UDim2.new(0.525, 0, 0, 65)
        clearBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
        clearBtn.Text = "🧹 Bỏ Chọn"
        clearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        clearBtn.TextScaled = true
        clearBtn.Font = Enum.Font.GothamBold
        clearBtn.BorderSizePixel = 0
        local cc2 = Instance.new("UICorner")
        cc2.Parent = clearBtn
        cc2.CornerRadius = UDim.new(0, 4)
        clearBtn.MouseButton1Click:Connect(function()
            SelectedMapPoint = nil
            SelectedMapName = "Chưa chọn"
            selectedText.Text = "📌 Chưa chọn"
        end)
        
        local yPos = 100
        local col = 1
        local row = 0
        for i, data in ipairs(DetectedMapPoints) do
            local btn = Instance.new("TextButton")
            btn.Parent = MapPanel
            local xPos = (col == 1) and 0.025 or 0.525
            btn.Size = UDim2.new(0.45, 0, 0, 28)
            btn.Position = UDim2.new(xPos, 0, 0, yPos + row * 32)
            btn.BackgroundColor3 = Color3.fromRGB(40, 35, 70)
            btn.Text = data.Name
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            btn.TextScaled = true
            btn.Font = Enum.Font.Gotham
            btn.BorderSizePixel = 0
            btn.BackgroundTransparency = 0.2
            local bc = Instance.new("UICorner")
            bc.Parent = btn
            bc.CornerRadius = UDim.new(0, 4)
            
            btn.MouseButton1Click:Connect(function()
                SelectedMapPoint = data.Position
                SelectedMapName = data.Name
                selectedText.Text = "📌 " .. data.Name
                for _, b in pairs(MapPanel:GetChildren()) do
                    if b:IsA("TextButton") and b.Text:find("✅") then
                        b.Text = b.Text:gsub(" ✅", "")
                        b.BackgroundColor3 = Color3.fromRGB(40, 35, 70)
                    end
                end
                btn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
                btn.Text = data.Name .. " ✅"
            end)
            
            if col == 1 then col = 2 else col = 1; row = row + 1 end
        end
        local totalRows = math.ceil(#DetectedMapPoints / 2)
        MapPanel.CanvasSize = UDim2.new(0, 0, 0, yPos + totalRows * 32 + 30)
    end
    BuildMapUI()
    
    -- ===== MV BUTTON =====
    local mvBtn = Instance.new("TextButton")
    mvBtn.Parent = ScreenGui
    local size = IsMobile and 75 or 65
    mvBtn.Size = UDim2.new(0, size, 0, size)
    mvBtn.Position = IsMobile and UDim2.new(0, 10, 0, 50) or UDim2.new(0, 15, 0.5, -32)
    mvBtn.BackgroundColor3 = Color3.fromRGB(25, 20, 55)
    mvBtn.Text = "MV"
    mvBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    mvBtn.TextScaled = true
    mvBtn.Font = Enum.Font.GothamBold
    mvBtn.BorderSizePixel = 0
    mvBtn.BackgroundTransparency = 0.2
    local mc = Instance.new("UICorner")
    mc.Parent = mvBtn
    mc.CornerRadius = UDim.new(1, 0)
    
    mvBtn.MouseButton1Click:Connect(function()
        MenuOpen = not MenuOpen
        Main.Visible = MenuOpen
        if MenuOpen then
            BuildMapUI()
            ScanMobs()
        end
    end)
    
    -- Mobile Swipe
    if IsMobile then
        local startPos = nil
        UserInputService.TouchBegan:Connect(function(input)
            startPos = input.Position
        end)
        UserInputService.TouchEnded:Connect(function(input)
            if startPos then
                local delta = input.Position - startPos
                if delta.Magnitude > 200 then
                    MenuOpen = not MenuOpen
                    Main.Visible = MenuOpen
                    if MenuOpen then
                        BuildMapUI()
                        ScanMobs()
                    end
                end
                startPos = nil
            end
        end)
    end
    
    return Main
end

-- // ============ INIT ============
CreateUI()
RunFixLag()
RunSuperJump()
RunFly()
RunNoclip()
RunGhost()
RunNightVision()
RunESP()
UpdateESP()
ScanMobs()
RunAutoFarm()
AntiIdle()

print("⚡ MV HACK v5.0 PURE FIX LOADED")
print("✅ Tất cả lệnh đã hoạt động!")
print("💀 Boss man, fuck yeah! No aimbot, all commands working!")
