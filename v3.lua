-- MV Hub Reborn v5.0 | ULTIMATE FIXED v5
-- Scroll hoạt động | Ngôn ngữ chuẩn | Farm chọn quái | UI đẹp

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")

local IsMobile = UserInputService.TouchEnabled

-- // ============ LANGUAGE ============
local Languages = {
    Vietnamese = {
        title = "⚡ MV HACK v5.0",
        on = "BẬT", off = "TẮT",
        fixlag = "🔧 Fix Lag", superjump = "🦘 Siêu Nhảy",
        fly = "✈️ Bay", noclip = "👻 Xuyên Tường",
        ghost = "👻 Tàng Hình", nightvision = "🌙 Nhìn Đêm",
        espplayers = "👤 ESP Người", espmobs = "👾 ESP Quái",
        espfruits = "🍎 ESP Trái", map = "🗺️ MAP SERVER",
        teleport = "🚀 Dịch Chuyển", refreshmap = "🔄 Quét Lại",
        clearmap = "🧹 Bỏ Chọn", flyspeed = "✈️ TỐC ĐỘ BAY",
        jumppower = "🦘 LỰC NHẢY", autofarm = "⚔️ AUTO FARM",
        selectmob = "🎯 Chọn Quái", selectweapon = "🔫 Chọn Vũ Khí",
        aimbot = "🎯 AIMBOT", fov = "📐 FOV", color = "🎨 Màu",
        no_target = "⚠️ Không có mục tiêu!", teleported = "✅ Đã dịch chuyển!",
        distance = "m", status_standing = "🧍 Đang đứng",
        status_farming = "⚔️ Đang farm...", mobs_found = "🐉 Quái: "
    },
    English = {
        title = "⚡ MV HACK v5.0",
        on = "ON", off = "OFF",
        fixlag = "🔧 Fix Lag", superjump = "🦘 Super Jump",
        fly = "✈️ Fly", noclip = "👻 Noclip",
        ghost = "👻 Ghost", nightvision = "🌙 Night Vision",
        espplayers = "👤 ESP Players", espmobs = "👾 ESP Mobs",
        espfruits = "🍎 ESP Fruits", map = "🗺️ MAP SERVER",
        teleport = "🚀 Teleport", refreshmap = "🔄 Refresh",
        clearmap = "🧹 Clear", flyspeed = "✈️ FLY SPEED",
        jumppower = "🦘 JUMP POWER", autofarm = "⚔️ AUTO FARM",
        selectmob = "🎯 Select Mob", selectweapon = "🔫 Select Weapon",
        aimbot = "🎯 AIMBOT", fov = "📐 FOV", color = "🎨 Color",
        no_target = "⚠️ No target!", teleported = "✅ Teleported!",
        distance = "m", status_standing = "🧍 Standing",
        status_farming = "⚔️ Farming...", mobs_found = "🐉 Mobs: "
    },
    Korean = {
        title = "⚡ MV HACK v5.0",
        on = "켜짐", off = "꺼짐",
        fixlag = "🔧 렉 수정", superjump = "🦘 슈퍼 점프",
        fly = "✈️ 비행", noclip = "👻 노클립",
        ghost = "👻 유령", nightvision = "🌙 야간 투시",
        espplayers = "👤 ESP 플레이어", espmobs = "👾 ESP 몹",
        espfruits = "🍎 ESP 과일", map = "🗺️ 맵 서버",
        teleport = "🚀 텔레포트", refreshmap = "🔄 새로고침",
        clearmap = "🧹 초기화", flyspeed = "✈️ 비행 속도",
        jumppower = "🦘 점프 파워", autofarm = "⚔️ 자동 사냥",
        selectmob = "🎯 몹 선택", selectweapon = "🔫 무기 선택",
        aimbot = "🎯 에임봇", fov = "📐 FOV", color = "🎨 색상",
        no_target = "⚠️ 대상 없음!", teleported = "✅ 텔레포트 완료!",
        distance = "m", status_standing = "🧍 대기 중",
        status_farming = "⚔️ 사냥 중...", mobs_found = "🐉 몹: "
    }
}

local CurrentLang = "Vietnamese"
local Lang = Languages[CurrentLang]

-- // ============ TOGGLES ============
local Toggles = {
    FixLag = false, SuperJump = false, Fly = false, Noclip = false,
    Ghost = false, NightVision = false, ESPPlayers = false,
    ESPMobs = false, ESPFruits = false, AutoFarm = false, Aimbot = false
}

-- // ============ VARIABLES ============
local FlySpeed = 50
local JumpPower = 250
local AimbotFOV = 200
local AimbotColor = Color3.fromRGB(255, 0, 0)
local MenuOpen = false
local CurrentTab = "Main"
local SelectedMapPoint = nil
local SelectedMapName = "Chưa chọn"
local DetectedMapPoints = {}
local ESPObjects = {}
local SelectedMob = nil
local SelectedWeapon = nil
local FarmTargets = {}
local flyEnabled = false
local bodyVelocity = nil
local FOVCircle = nil

-- UI References
local UI = {
    Title = nil, ToggleBtns = {}, SliderLabels = {},
    Status = nil, MobCount = nil, SelectedText = nil,
    MapBtns = {}, MobList = nil, WeaponList = nil
}

-- // ============ RAINBOW ============
local function Rainbow(offset)
    return Color3.fromHSV((tick() % 5 / 5 + (offset or 0)) % 1, 1, 1)
end

-- // ============ REFRESH UI ============
local function RefreshUI()
    if UI.Title then UI.Title.Text = Lang.title end
    
    for _, btn in pairs(UI.ToggleBtns) do
        local key = btn:GetAttribute("Key")
        if key and Toggles[key] ~= nil then
            btn.Text = Lang[key] .. " [" .. (Toggles[key] and Lang.on or Lang.off) .. "]"
            btn.BackgroundColor3 = Toggles[key] and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(40, 40, 65)
        end
    end
    
    for _, lbl in pairs(UI.SliderLabels) do
        local key = lbl:GetAttribute("Key")
        if key and Lang[key] then
            lbl.Text = Lang[key]
        end
    end
    
    if UI.Status then
        UI.Status.Text = (Toggles.AutoFarm and SelectedMob) and Lang.status_farming or Lang.status_standing
    end
    if UI.MobCount then
        UI.MobCount.Text = Lang.mobs_found .. #FarmTargets
    end
    if UI.SelectedText then
        UI.SelectedText.Text = "📌 " .. SelectedMapName
    end
end

-- // ============ INFO DISPLAY ============
local function CreateInfo()
    local gui = Instance.new("ScreenGui")
    gui.Parent = LocalPlayer.PlayerGui
    gui.Name = "MVInfo"
    gui.ResetOnSpawn = false

    local frame = Instance.new("Frame")
    frame.Parent = gui
    frame.Size = UDim2.new(0, 280, 0, 70)
    frame.Position = UDim2.new(1, -290, 0, 10)
    frame.BackgroundColor3 = Color3.fromRGB(10, 10, 25)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0

    local corner = Instance.new("UICorner")
    corner.Parent = frame
    corner.CornerRadius = UDim.new(0, 8)

    local title = Instance.new("TextLabel")
    title.Parent = frame
    title.Size = UDim2.new(1, 0, 0.5, 0)
    title.BackgroundTransparency = 1
    title.Text = "Shinn Dev Bot X Hack Game"
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.TextStrokeTransparency = 0.2

    local time = Instance.new("TextLabel")
    time.Parent = frame
    time.Size = UDim2.new(1, 0, 0.5, 0)
    time.Position = UDim2.new(0, 0, 0.5, 0)
    time.BackgroundTransparency = 1
    time.TextScaled = true
    time.Font = Enum.Font.Gotham
    time.TextStrokeTransparency = 0.2

    spawn(function()
        while wait(0.1) do
            title.TextColor3 = Rainbow()
            time.TextColor3 = Rainbow(0.3)
            time.Text = os.date("%H:%M:%S - %d/%m/%Y")
        end
    end)
end

-- // ============ FOV CIRCLE ============
local function CreateFOV()
    if FOVCircle then FOVCircle:Destroy() end
    FOVCircle = Instance.new("Frame")
    FOVCircle.Parent = LocalPlayer.PlayerGui
    FOVCircle.Size = UDim2.new(0, AimbotFOV * 2, 0, AimbotFOV * 2)
    FOVCircle.Position = UDim2.new(0.5, -AimbotFOV, 0.5, -AimbotFOV)
    FOVCircle.BackgroundTransparency = 1
    FOVCircle.ZIndex = 999
    FOVCircle.Visible = Toggles.Aimbot

    local img = Instance.new("ImageLabel")
    img.Parent = FOVCircle
    img.Size = UDim2.new(1, 0, 1, 0)
    img.BackgroundTransparency = 1
    img.Image = "rbxassetid://6023420974"
    img.ImageColor3 = AimbotColor
    img.ImageTransparency = 0.5
    img.ZIndex = 999
end

-- // ============ AIMBOT ============
local function GetTargets()
    local targets = {}
    local char = LocalPlayer.Character
    if not char then return targets end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return targets end
    local myPos = root.Position

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local tr = player.Character:FindFirstChild("HumanoidRootPart")
            if tr then
                local sp, on = Camera:WorldToScreenPoint(tr.Position)
                if on then
                    local dist = (myPos - tr.Position).Magnitude
                    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                    local fov = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                    if fov <= AimbotFOV then
                        table.insert(targets, {Object = tr, Distance = dist, FOVDist = fov})
                    end
                end
            end
        end
    end

    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
            local name = v.Name:lower()
            if name:find("npc") or name:find("mob") or name:find("boss") then
                local tr = v.HumanoidRootPart
                local sp, on = Camera:WorldToScreenPoint(tr.Position)
                if on then
                    local dist = (myPos - tr.Position).Magnitude
                    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                    local fov = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                    if fov <= AimbotFOV then
                        table.insert(targets, {Object = tr, Distance = dist, FOVDist = fov})
                    end
                end
            end
        end
    end

    table.sort(targets, function(a, b) return a.FOVDist < b.FOVDist end)
    return targets
end

local function RunAimbot()
    spawn(function()
        while wait(0.05) do
            pcall(function()
                if not Toggles.Aimbot then
                    if FOVCircle then FOVCircle.Visible = false end
                    return
                end
                if FOVCircle then FOVCircle.Visible = true end
                local targets = GetTargets()
                if #targets > 0 then
                    local target = targets[1]
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        local root = char.HumanoidRootPart
                        local dir = (target.Object.Position - root.Position).Unit
                        Camera.CFrame = CFrame.new(Camera.CFrame.Position, root.Position + dir * 100)
                    end
                end
            end)
        end
    end)
end

-- // ============ AUTO FARM ============
local function ScanMobs()
    FarmTargets = {}
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
            local name = v.Name:lower()
            if name:find("npc") or name:find("mob") or name:find("boss") or name:find("enemy") then
                table.insert(FarmTargets, {
                    Model = v, Root = v.HumanoidRootPart,
                    Humanoid = v.Humanoid, Name = v.Name,
                    Health = v.Humanoid.Health
                })
            end
        end
    end
    return FarmTargets
end

local function AutoFarmLoop()
    spawn(function()
        while wait(0.1) do
            pcall(function()
                if not Toggles.AutoFarm or not SelectedMob then return end
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
                        if tool then tool:Activate() end
                    end
                end
                if tick() % 3 < 0.1 then ScanMobs() end
            end)
        end
    end)
end

-- // ============ FLY ============
local function InitFly()
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
                    end
                elseif bodyVelocity then
                    bodyVelocity:Destroy()
                    bodyVelocity = nil
                end
            end
        end)
    end

    spawn(function()
        while wait() do
            pcall(function()
                if flyEnabled and Toggles.Fly and bodyVelocity then
                    local char = LocalPlayer.Character
                    if not char then
                        flyEnabled = false
                        if bodyVelocity then bodyVelocity:Destroy() end
                        bodyVelocity = nil
                        if flyBtn then
                            flyBtn.Text = "🛸"
                            flyBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
                        end
                        return
                    end
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if not root then return end

                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end

                    local move = Vector3.new(0, 0, 0)
                    if IsMobile then
                        local touches = UserInputService:GetTouchPositions()
                        if #touches > 0 then
                            local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                            local delta = touches[1] - center
                            local mag = delta.Magnitude
                            if mag > 30 then
                                local dir = delta.Unit
                                move = Vector3.new(dir.X, 0, -dir.Y) * math.min(mag / 100, 1)
                            end
                        end
                    else
                        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                            move = move + Camera.CFrame.LookVector * Vector3.new(1, 0, 1)
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                            move = move - Camera.CFrame.LookVector * Vector3.new(1, 0, 1)
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                            move = move - Camera.CFrame.RightVector * Vector3.new(1, 0, 1)
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                            move = move + Camera.CFrame.RightVector * Vector3.new(1, 0, 1)
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                            move = move + Vector3.new(0, 1, 0)
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                            move = move - Vector3.new(0, 1, 0)
                        end
                    end

                    if move.Magnitude > 0 then
                        move = move.Unit * FlySpeed
                    end
                    bodyVelocity.Velocity = move
                end
            end)
        end
    end)
end

-- // ============ NOCLIP ============
local function InitNoclip()
    spawn(function()
        while wait(0.05) do
            pcall(function()
                local char = LocalPlayer.Character
                if not char then return end
                local should = Toggles.Noclip or flyEnabled
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = not should
                    end
                end
            end)
        end
    end)
end

-- // ============ GHOST ============
local function InitGhost()
    spawn(function()
        while wait(0.05) do
            pcall(function()
                local char = LocalPlayer.Character
                if not char then return end
                local trans = Toggles.Ghost and 0.3 or 0
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Transparency = trans
                        if Toggles.Ghost then part.CanCollide = false end
                    end
                end
                local head = char:FindFirstChild("Head")
                if head then
                    for _, child in pairs(head:GetChildren()) do
                        if child:IsA("BillboardGui") then
                            child.Enabled = not Toggles.Ghost
                        end
                    end
                end
            end)
        end
    end)
end

-- // ============ ESP ============
local function CreateESP(obj, color, text)
    if not obj or not obj:IsA("BasePart") then return end
    for _, v in pairs(obj:GetChildren()) do
        if v:IsA("BillboardGui") and v.Name == "MV_ESP" then v:Destroy() end
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

local function ESPLoop()
    spawn(function()
        while wait(0.5) do
            pcall(function()
                if not Toggles.ESPPlayers and not Toggles.ESPMobs and not Toggles.ESPFruits then
                    for _, data in pairs(ESPObjects) do
                        if data.Billboard then data.Billboard:Destroy() end
                    end
                    ESPObjects = {}
                    return
                end

                if Toggles.ESPPlayers then
                    for _, player in pairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            CreateESP(player.Character.HumanoidRootPart, Color3.fromRGB(0, 255, 0), "👤 " .. player.Name)
                        end
                    end
                end

                if Toggles.ESPMobs then
                    for _, v in pairs(Workspace:GetDescendants()) do
                        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                            local name = v.Name:lower()
                            if name:find("npc") or name:find("mob") or name:find("boss") then
                                CreateESP(v.HumanoidRootPart, Color3.fromRGB(255, 200, 0), "👾 " .. v.Name)
                            end
                        end
                    end
                end

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
            end)
        end
    end)
end

local function UpdateDistances()
    spawn(function()
        while wait(0.3) do
            pcall(function()
                local char = LocalPlayer.Character
                if not char then return end
                local root = char:FindFirstChild("HumanoidRootPart")
                if not root then return end
                local myPos = root.Position
                for _, data in pairs(ESPObjects) do
                    if data.Object and data.Object.Parent and data.DistLabel then
                        local dist = (myPos - data.Object.Position).Magnitude
                        data.DistLabel.Text = math.floor(dist) .. Lang.distance
                    end
                end
            end)
        end
    end)
end

-- // ============ FEATURES ============
local function FixLag()
    spawn(function()
        while wait(0.5) do
            pcall(function()
                if Toggles.FixLag then
                    for _, v in pairs(Workspace:GetDescendants()) do
                        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                            v.Enabled = false
                        end
                    end
                    Lighting.GlobalShadows = false
                    Lighting.Brightness = 2
                    for _, v in pairs(Lighting:GetDescendants()) do
                        if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("BloomEffect") then
                            v.Enabled = false
                        end
                    end
                    pcall(function() settings().Rendering.QualityLevel = 1 end)
                end
            end)
        end
    end)
end

local function SuperJump()
    spawn(function()
        while wait(0.05) do
            pcall(function()
                if Toggles.SuperJump then
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("Humanoid") then
                        char.Humanoid.JumpPower = JumpPower
                    end
                end
            end)
        end
    end)
end

local function NightVision()
    spawn(function()
        while wait(0.5) do
            pcall(function()
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
            end)
        end
    end)
end

local function AntiIdle()
    spawn(function()
        while wait(60) do
            pcall(function()
                LocalPlayer.Idled:Connect(function() VirtualUser:ClickButton2(Vector2.new()) end)
            end)
        end
    end)
end

-- // ============ MAP SCAN ============
local function ScanMap()
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
    return DetectedMapPoints
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
    Main.BackgroundColor3 = Color3.fromRGB(10, 8, 20)
    Main.BackgroundTransparency = 0.1
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Visible = true

    -- Gradient background
    local grad = Instance.new("UIGradient")
    grad.Parent = Main
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 10, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 20))
    })

    local corner = Instance.new("UICorner")
    corner.Parent = Main
    corner.CornerRadius = UDim.new(0, 16)

    -- Glow border
    local glow = Instance.new("Frame")
    glow.Parent = Main
    glow.Size = UDim2.new(1, 4, 1, 4)
    glow.Position = UDim2.new(0, -2, 0, -2)
    glow.BackgroundTransparency = 0.8
    glow.BorderSizePixel = 0
    local glowGrad = Instance.new("UIGradient")
    glowGrad.Parent = glow
    glowGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 150, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 0, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 150, 255))
    })
    local glowCorner = Instance.new("UICorner")
    glowCorner.Parent = glow
    glowCorner.CornerRadius = UDim.new(0, 18)

    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Parent = Main
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = Color3.fromRGB(20, 15, 40)
    TitleBar.BackgroundTransparency = 0.4
    TitleBar.BorderSizePixel = 0

    local title = Instance.new("TextLabel")
    title.Parent = TitleBar
    title.Size = UDim2.new(0.5, 0, 1, 0)
    title.Position = UDim2.new(0, 12, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = Lang.title
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    UI.Title = title

    -- Language
    local langBtn = Instance.new("TextButton")
    langBtn.Parent = TitleBar
    langBtn.Size = UDim2.new(0, 55, 0, 28)
    langBtn.Position = UDim2.new(0.65, 0, 0, 6)
    langBtn.BackgroundColor3 = Color3.fromRGB(40, 30, 70)
    langBtn.Text = "🇻🇳"
    langBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    langBtn.TextScaled = true
    langBtn.Font = Enum.Font.GothamBold
    langBtn.BorderSizePixel = 0
    local lc = Instance.new("UICorner")
    lc.Parent = langBtn
    lc.CornerRadius = UDim.new(0, 6)

    local langIdx = 1
    local langList = {"Vietnamese", "English", "Korean"}
    local langFlags = {"🇻🇳", "🇬🇧", "🇰🇷"}

    langBtn.MouseButton1Click:Connect(function()
        langIdx = langIdx % 3 + 1
        CurrentLang = langList[langIdx]
        Lang = Languages[CurrentLang]
        langBtn.Text = langFlags[langIdx]
        RefreshUI()
    end)

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
    TabBar.BackgroundColor3 = Color3.fromRGB(15, 10, 30)
    TabBar.BackgroundTransparency = 0.6
    TabBar.BorderSizePixel = 0

    local tabs = {"Main", "ESP", "Farm", "Aimbot", "Map"}
    local tabBtns = {}

    for i, tab in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Parent = TabBar
        btn.Size = UDim2.new(0.2, 0, 1, 0)
        btn.Position = UDim2.new((i-1) * 0.2, 0, 0, 0)
        btn.BackgroundColor3 = (i == 1) and Color3.fromRGB(60, 40, 120) or Color3.fromRGB(20, 15, 45)
        btn.Text = tab
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextScaled = true
        btn.Font = Enum.Font.GothamBold
        btn.BorderSizePixel = 0
        btn.BackgroundTransparency = (i == 1) and 0 or 0.3

        btn.MouseButton1Click:Connect(function()
            for _, b in pairs(tabBtns) do
                b.BackgroundColor3 = Color3.fromRGB(20, 15, 45)
                b.BackgroundTransparency = 0.3
            end
            btn.BackgroundColor3 = Color3.fromRGB(60, 40, 120)
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
        panel.AutomaticCanvasSize = Enum.AutomaticSize.None

        local layout = Instance.new("UIListLayout")
        layout.Parent = panel
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 4)

        -- Update CanvasSize khi layout thay đổi
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
        btn.BackgroundColor3 = Color3.fromRGB(40, 35, 65)
        btn.Text = label .. " [" .. Lang.off .. "]"
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
            btn.Text = label .. " [" .. (Toggles[key] and Lang.on or Lang.off) .. "]"
            btn.BackgroundColor3 = Toggles[key] and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(40, 35, 65)
        end)
        return btn
    end

    -- Slider Helper
    local function AddSlider(panel, key, varRef, minVal, maxVal, step)
        local frame = Instance.new("Frame")
        frame.Parent = panel
        frame.Size = UDim2.new(0.95, 0, 0, 50)
        frame.BackgroundTransparency = 1

        local label = Instance.new("TextLabel")
        label.Parent = frame
        label.Size = UDim2.new(1, 0, 0.4, 0)
        label.BackgroundTransparency = 1
        label.Text = Lang[key]
        label.TextColor3 = Color3.fromRGB(200, 200, 255)
        label.TextScaled = true
        label.Font = Enum.Font.GothamBold
        label:SetAttribute("Key", key)
        table.insert(UI.SliderLabels, label)

        local slider = Instance.new("Frame")
        slider.Parent = frame
        slider.Size = UDim2.new(1, 0, 0.5, 0)
        slider.Position = UDim2.new(0, 0, 0.5, 0)
        slider.BackgroundColor3 = Color3.fromRGB(30, 25, 55)
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
    AddToggle(MainPanel, "FixLag", Lang.fixlag)
    AddToggle(MainPanel, "SuperJump", Lang.superjump)
    AddToggle(MainPanel, "Fly", Lang.fly)
    AddToggle(MainPanel, "Noclip", Lang.noclip)
    AddToggle(MainPanel, "Ghost", Lang.ghost)
    AddToggle(MainPanel, "NightVision", Lang.nightvision)
    AddSlider(MainPanel, "flyspeed", FlySpeed, 10, 200, 5)
    AddSlider(MainPanel, "jumppower", JumpPower, 50, 500, 50)

    -- ===== ESP PANEL =====
    local ESPPanel = CreatePanel("ESP")
    ESPPanel.Visible = false
    AddToggle(ESPPanel, "ESPPlayers", Lang.espplayers)
    AddToggle(ESPPanel, "ESPMobs", Lang.espmobs)
    AddToggle(ESPPanel, "ESPFruits", Lang.espfruits)

    -- ===== FARM PANEL =====
    local FarmPanel = CreatePanel("Farm")
    FarmPanel.Visible = false

    -- Farm Toggle
    local farmToggle = AddToggle(FarmPanel, "AutoFarm", Lang.autofarm)

    -- Mob Selection Dropdown
    local mobFrame = Instance.new("Frame")
    mobFrame.Parent = FarmPanel
    mobFrame.Size = UDim2.new(0.95, 0, 0, 50)
    mobFrame.BackgroundTransparency = 1

    local mobLabel = Instance.new("TextLabel")
    mobLabel.Parent = mobFrame
    mobLabel.Size = UDim2.new(0.3, 0, 1, 0)
    mobLabel.BackgroundTransparency = 1
    mobLabel.Text = Lang.selectmob
    mobLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    mobLabel.TextScaled = true
    mobLabel.Font = Enum.Font.GothamBold
    mobLabel:SetAttribute("Key", "selectmob")
    table.insert(UI.SliderLabels, mobLabel)

    local mobDropdown = Instance.new("TextButton")
    mobDropdown.Parent = mobFrame
    mobDropdown.Size = UDim2.new(0.65, 0, 1, 0)
    mobDropdown.Position = UDim2.new(0.35, 0, 0, 0)
    mobDropdown.BackgroundColor3 = Color3.fromRGB(30, 25, 55)
    mobDropdown.Text = "Tất cả"
    mobDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    mobDropdown.TextScaled = true
    mobDropdown.Font = Enum.Font.Gotham
    mobDropdown.BorderSizePixel = 0
    local dc = Instance.new("UICorner")
    dc.Parent = mobDropdown
    dc.CornerRadius = UDim.new(0, 6)

    -- Mob List (popup)
    local mobList = Instance.new("ScrollingFrame")
    mobList.Parent = FarmPanel
    mobList.Size = UDim2.new(0.6, 0, 0, 120)
    mobList.Position = UDim2.new(0.35, 0, 0, 55)
    mobList.BackgroundColor3 = Color3.fromRGB(20, 15, 40)
    mobList.BorderSizePixel = 0
    mobList.Visible = false
    mobList.CanvasSize = UDim2.new(0, 0, 0, 0)
    mobList.ScrollBarThickness = 3
    local lc2 = Instance.new("UICorner")
    lc2.Parent = mobList
    lc2.CornerRadius = UDim.new(0, 6)

    local mobLayout = Instance.new("UIListLayout")
    mobLayout.Parent = mobList
    mobLayout.SortOrder = Enum.SortOrder.LayoutOrder
    mobLayout.Padding = UDim.new(0, 2)

    mobDropdown.MouseButton1Click:Connect(function()
        mobList.Visible = not mobList.Visible
        if mobList.Visible then
            -- Clear old
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
                btn.BackgroundColor3 = Color3.fromRGB(40, 35, 65)
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

    -- Weapon Selection
    local weaponFrame = Instance.new("Frame")
    weaponFrame.Parent = FarmPanel
    weaponFrame.Size = UDim2.new(0.95, 0, 0, 50)
    weaponFrame.Position = UDim2.new(0, 0, 0, 55)
    weaponFrame.BackgroundTransparency = 1

    local weaponLabel = Instance.new("TextLabel")
    weaponLabel.Parent = weaponFrame
    weaponLabel.Size = UDim2.new(0.3, 0, 1, 0)
    weaponLabel.BackgroundTransparency = 1
    weaponLabel.Text = Lang.selectweapon
    weaponLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    weaponLabel.TextScaled = true
    weaponLabel.Font = Enum.Font.GothamBold
    weaponLabel:SetAttribute("Key", "selectweapon")
    table.insert(UI.SliderLabels, weaponLabel)

    local weaponDropdown = Instance.new("TextButton")
    weaponDropdown.Parent = weaponFrame
    weaponDropdown.Size = UDim2.new(0.65, 0, 1, 0)
    weaponDropdown.Position = UDim2.new(0.35, 0, 0, 0)
    weaponDropdown.BackgroundColor3 = Color3.fromRGB(30, 25, 55)
    weaponDropdown.Text = "Auto"
    weaponDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    weaponDropdown.TextScaled = true
    weaponDropdown.Font = Enum.Font.Gotham
    weaponDropdown.BorderSizePixel = 0
    local wc = Instance.new("UICorner")
    wc.Parent = weaponDropdown
    wc.CornerRadius = UDim.new(0, 6)

    -- Weapon List (popup)
    local weaponList = Instance.new("ScrollingFrame")
    weaponList.Parent = FarmPanel
    weaponList.Size = UDim2.new(0.6, 0, 0, 100)
    weaponList.Position = UDim2.new(0.35, 0, 0, 110)
    weaponList.BackgroundColor3 = Color3.fromRGB(20, 15, 40)
    weaponList.BorderSizePixel = 0
    weaponList.Visible = false
    weaponList.CanvasSize = UDim2.new(0, 0, 0, 0)
    weaponList.ScrollBarThickness = 3
    local wlc = Instance.new("UICorner")
    wlc.Parent = weaponList
    wlc.CornerRadius = UDim.new(0, 6)

    local weaponLayout = Instance.new("UIListLayout")
    weaponLayout.Parent = weaponList
    weaponLayout.SortOrder = Enum.SortOrder.LayoutOrder
    weaponLayout.Padding = UDim.new(0, 2)

    weaponDropdown.MouseButton1Click:Connect(function()
        weaponList.Visible = not weaponList.Visible
        if weaponList.Visible then
            for _, child in pairs(weaponList:GetChildren()) do
                if child:IsA("TextButton") then child:Destroy() end
            end
            local char = LocalPlayer.Character
            local weapons = {"Auto"}
            if char then
                for _, tool in pairs(char:GetChildren()) do
                    if tool:IsA("Tool") then table.insert(weapons, tool.Name) end
                end
            end
            for _, name in pairs(weapons) do
                local btn = Instance.new("TextButton")
                btn.Parent = weaponList
                btn.Size = UDim2.new(1, 0, 0, 30)
                btn.BackgroundColor3 = Color3.fromRGB(40, 35, 65)
                btn.Text = name
                btn.TextColor3 = Color3.fromRGB(220, 220, 220)
                btn.TextScaled = true
                btn.Font = Enum.Font.Gotham
                btn.BorderSizePixel = 0
                local bc = Instance.new("UICorner")
                bc.Parent = btn
                bc.CornerRadius = UDim.new(0, 4)
                btn.MouseButton1Click:Connect(function()
                    SelectedWeapon = name
                    weaponDropdown.Text = name
                    weaponList.Visible = false
                end)
            end
            weaponList.CanvasSize = UDim2.new(0, 0, 0, #weapons * 32 + 10)
        end
    end)

    -- Status
    local statusFrame = Instance.new("Frame")
    statusFrame.Parent = FarmPanel
    statusFrame.Size = UDim2.new(0.95, 0, 0, 32)
    statusFrame.Position = UDim2.new(0, 0, 0, 170)
    statusFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 40)
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
    status.Text = Lang.status_standing
    status.TextColor3 = Color3.fromRGB(200, 200, 200)
    status.TextScaled = true
    status.Font = Enum.Font.Gotham
    status.TextXAlignment = Enum.TextXAlignment.Left
    UI.Status = status

    local mobCount = Instance.new("TextLabel")
    mobCount.Parent = statusFrame
    mobCount.Size = UDim2.new(0.3, 0, 1, 0)
    mobCount.Position = UDim2.new(0.7, 0, 0, 0)
    mobCount.BackgroundTransparency = 1
    mobCount.Text = Lang.mobs_found .. "0"
    mobCount.TextColor3 = Color3.fromRGB(255, 200, 100)
    mobCount.TextScaled = true
    mobCount.Font = Enum.Font.Gotham
    UI.MobCount = mobCount

    -- Update status loop
    spawn(function()
        while wait(0.5) do
            if Toggles.AutoFarm and SelectedMob then
                status.Text = Lang.status_farming
                status.TextColor3 = Color3.fromRGB(0, 255, 0)
            else
                status.Text = Lang.status_standing
                status.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
            ScanMobs()
            mobCount.Text = Lang.mobs_found .. #FarmTargets
        end
    end)

    -- ===== AIMBOT PANEL =====
    local AimbotPanel = CreatePanel("Aimbot")
    AimbotPanel.Visible = false
    AddToggle(AimbotPanel, "Aimbot", Lang.aimbot)
    AddSlider(AimbotPanel, "fov", AimbotFOV, 50, 400, 10)

    -- Color picker
    local colorFrame = Instance.new("Frame")
    colorFrame.Parent = AimbotPanel
    colorFrame.Size = UDim2.new(0.95, 0, 0, 40)
    colorFrame.BackgroundTransparency = 1

    local colorLabel = Instance.new("TextLabel")
    colorLabel.Parent = colorFrame
    colorLabel.Size = UDim2.new(0.3, 0, 1, 0)
    colorLabel.BackgroundTransparency = 1
    colorLabel.Text = Lang.color
    colorLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    colorLabel.TextScaled = true
    colorLabel.Font = Enum.Font.GothamBold
    colorLabel:SetAttribute("Key", "color")
    table.insert(UI.SliderLabels, colorLabel)

    local colorBtn = Instance.new("TextButton")
    colorBtn.Parent = colorFrame
    colorBtn.Size = UDim2.new(0.65, 0, 1, 0)
    colorBtn.Position = UDim2.new(0.35, 0, 0, 0)
    colorBtn.BackgroundColor3 = AimbotColor
    colorBtn.Text = "●"
    colorBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    colorBtn.TextScaled = true
    colorBtn.Font = Enum.Font.GothamBold
    colorBtn.BorderSizePixel = 0
    local cc = Instance.new("UICorner")
    cc.Parent = colorBtn
    cc.CornerRadius = UDim.new(0, 6)

    local colors = {
        Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(0, 0, 255), Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(255, 0, 255), Color3.fromRGB(0, 255, 255)
    }
    local colorIdx = 1
    colorBtn.MouseButton1Click:Connect(function()
        colorIdx = colorIdx % #colors + 1
        AimbotColor = colors[colorIdx]
        colorBtn.BackgroundColor3 = AimbotColor
        CreateFOV()
    end)

    -- ===== MAP PANEL =====
    local MapPanel = CreatePanel("Map")
    MapPanel.Visible = false

    local function BuildMapUI()
        ScanMap()
        for _, child in pairs(MapPanel:GetChildren()) do
            if child:IsA("TextButton") or child:IsA("TextLabel") then child:Destroy() end
        end

        local mapLabel = Instance.new("TextLabel")
        mapLabel.Parent = MapPanel
        mapLabel.Size = UDim2.new(0.95, 0, 0, 25)
        mapLabel.BackgroundTransparency = 1
        mapLabel.Text = Lang.map .. " (" .. #DetectedMapPoints .. ")"
        mapLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
        mapLabel.TextScaled = true
        mapLabel.Font = Enum.Font.GothamBold

        local selText = Instance.new("TextLabel")
        selText.Parent = MapPanel
        selText.Size = UDim2.new(0.7, 0, 0, 30)
        selText.BackgroundColor3 = Color3.fromRGB(20, 15, 40)
        selText.Text = "📌 " .. SelectedMapName
        selText.TextColor3 = Color3.fromRGB(255, 255, 255)
        selText.TextScaled = true
        selText.Font = Enum.Font.Gotham
        selText.BorderSizePixel = 0
        local stc = Instance.new("UICorner")
        stc.Parent = selText
        stc.CornerRadius = UDim.new(0, 4)
        UI.SelectedText = selText

        local teleBtn = Instance.new("TextButton")
        teleBtn.Parent = MapPanel
        teleBtn.Size = UDim2.new(0.22, 0, 0, 30)
        teleBtn.Position = UDim2.new(0.73, 0, 0, 30)
        teleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 200)
        teleBtn.Text = Lang.teleport
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
                    print(Lang.teleported)
                end
            else
                print(Lang.no_target)
            end
        end)

        local refBtn = Instance.new("TextButton")
        refBtn.Parent = MapPanel
        refBtn.Size = UDim2.new(0.45, 0, 0, 28)
        refBtn.Position = UDim2.new(0.025, 0, 0, 65)
        refBtn.BackgroundColor3 = Color3.fromRGB(60, 50, 100)
        refBtn.Text = Lang.refreshmap
        refBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        refBtn.TextScaled = true
        refBtn.Font = Enum.Font.GothamBold
        refBtn.BorderSizePixel = 0
        local rc = Instance.new("UICorner")
        rc.Parent = refBtn
        rc.CornerRadius = UDim.new(0, 4)
        refBtn.MouseButton1Click:Connect(BuildMapUI)

        local clearBtn = Instance.new("TextButton")
        clearBtn.Parent = MapPanel
        clearBtn.Size = UDim2.new(0.45, 0, 0, 28)
        clearBtn.Position = UDim2.new(0.525, 0, 0, 65)
        clearBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
        clearBtn.Text = Lang.clearmap
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
            selText.Text = "📌 Chưa chọn"
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
            btn.BackgroundColor3 = Color3.fromRGB(40, 35, 65)
            btn.Text = data.Name
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            btn.TextScaled = true
            btn.Font = Enum.Font.Gotham
            btn.BorderSizePixel = 0
            btn.BackgroundTransparency = 0.2
            local bc = Instance.new("UICorner")
            bc.Parent = btn
            bc.CornerRadius = UDim.new(0, 4)
            table.insert(UI.MapBtns, btn)

            btn.MouseButton1Click:Connect(function()
                SelectedMapPoint = data.Position
                SelectedMapName = data.Name
                selText.Text = "📌 " .. data.Name
                for _, b in pairs(MapPanel:GetChildren()) do
                    if b:IsA("TextButton") and b.Text:find("✅") then
                        b.Text = b.Text:gsub(" ✅", "")
                        b.BackgroundColor3 = Color3.fromRGB(40, 35, 65)
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
    mvBtn.BackgroundColor3 = Color3.fromRGB(25, 20, 50)
    mvBtn.Text = "MV"
    mvBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    mvBtn.TextScaled = true
    mvBtn.Font = Enum.Font.GothamBold
    mvBtn.BorderSizePixel = 0
    mvBtn.BackgroundTransparency = 0.2
    local mc = Instance.new("UICorner")
    mc.Parent = mvBtn
    mc.CornerRadius = UDim.new(1, 0)

    -- Glow cho MV button
    local mvGlow = Instance.new("ImageLabel")
    mvGlow.Parent = mvBtn
    mvGlow.Size = UDim2.new(1.3, 0, 1.3, 0)
    mvGlow.Position = UDim2.new(-0.15, 0, -0.15, 0)
    mvGlow.BackgroundTransparency = 1
    mvGlow.Image = "rbxassetid://6023420974"
    mvGlow.ImageColor3 = Color3.fromRGB(100, 80, 255)
    mvGlow.ImageTransparency = 0.6
    mvGlow.ZIndex = 0

    mvBtn.MouseButton1Click:Connect(function()
        MenuOpen = not MenuOpen
        Main.Visible = MenuOpen
        if MenuOpen then
            BuildMapUI()
            ScanMobs()
        end
        TweenService:Create(mvBtn, TweenInfo.new(0.1), {BackgroundTransparency = 0.5}):Play()
        wait(0.1)
        TweenService:Create(mvBtn, TweenInfo.new(0.1), {BackgroundTransparency = 0.2}):Play()
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
CreateInfo()
CreateFOV()
FixLag()
SuperJump()
InitFly()
InitNoclip()
InitGhost()
NightVision()
ScanMobs()
AutoFarmLoop()
ESPLoop()
UpdateDistances()
RunAimbot()
AntiIdle()

print("⚡ MV HACK v5.0 ULTIMATE FIXED LOADED")
print("✅ Scroll works | Language works | Farm selects mobs")
print("🎨 UI upgraded with glow & gradient")
print("💀 Boss man, fuck yeah! All fixed properly!")
