-- MV Hub Reborn v5.0 | MOBILE OPTIMIZED
-- Thêm touch controls, UI resize, on-screen buttons

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")  -- ĐÃ SỬA
local Workspace = game:GetService("Workspace")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local VirtualUser = game:GetService("VirtualUser")
local Debris = game:GetService("Debris")
local HttpService = game:GetService("HttpService")

-- KIỂM TRA MOBILE
local IsMobile = UserInputService.TouchEnabled
local ViewportSize = Camera.ViewportSize

-- // ============ LANGUAGE SYSTEM ============
local Languages = {
    Vietnamese = {
        title = "⚡ MV HACK v5.0",
        toggle_on = "BẬT",
        toggle_off = "TẮT",
        fixlag = "🔧 Fix Lag",
        superjump = "🦘 Siêu Nhảy",
        fly = "✈️ Bay",
        noclip = "👻 Xuyên Tường",
        espplayers = "👤 ESP Người Chơi",
        espmobs = "👾 ESP Quái",
        espfruits = "🍎 ESP Trái Cây",
        ghost = "👻 Tàng Hình",
        nightvision = "🌙 Nhìn Đêm",
        map = "🗺️ MAP SERVER",
        teleport = "🚀 Dịch Chuyển",
        refreshmap = "🔄 Quét Lại",
        clearmap = "🧹 Bỏ Chọn",
        flyspeed = "✈️ TỐC ĐỘ BAY",
        jumppower = "🦘 LỰC NHẢY",
        autofarm = "⚔️ AUTO FARM",
        selectmob = "🎯 Chọn Quái",
        selectweapon = "🔫 Chọn Vũ Khí",
        aimbot = "🎯 AIMBOT",
        fov = "📐 FOV",
        color = "🎨 Màu",
        no_target = "⚠️ Không có mục tiêu!",
        teleported = "✅ Đã dịch chuyển!",
        selected = "✅ Đã chọn: ",
        distance = "m",
        loading = "🔄 Đang tải...",
        status_standing = "🧍 Đang đứng",
        status_farming = "⚔️ Đang farm...",
        mobs_found = "🐉 Quái tìm thấy: "
    },
    English = {
        title = "⚡ MV HACK v5.0",
        toggle_on = "ON",
        toggle_off = "OFF",
        fixlag = "🔧 Fix Lag",
        superjump = "🦘 Super Jump",
        fly = "✈️ Fly",
        noclip = "👻 Noclip",
        espplayers = "👤 ESP Players",
        espmobs = "👾 ESP Mobs",
        espfruits = "🍎 ESP Fruits",
        ghost = "👻 Ghost",
        nightvision = "🌙 Night Vision",
        map = "🗺️ MAP SERVER",
        teleport = "🚀 Teleport",
        refreshmap = "🔄 Refresh",
        clearmap = "🧹 Clear",
        flyspeed = "✈️ FLY SPEED",
        jumppower = "🦘 JUMP POWER",
        autofarm = "⚔️ AUTO FARM",
        selectmob = "🎯 Select Mob",
        selectweapon = "🔫 Select Weapon",
        aimbot = "🎯 AIMBOT",
        fov = "📐 FOV",
        color = "🎨 Color",
        no_target = "⚠️ No target!",
        teleported = "✅ Teleported!",
        selected = "✅ Selected: ",
        distance = "m",
        loading = "🔄 Loading...",
        status_standing = "🧍 Standing",
        status_farming = "⚔️ Farming...",
        mobs_found = "🐉 Mobs found: "
    },
    Korean = {
        title = "⚡ MV HACK v5.0",
        toggle_on = "켜짐",
        toggle_off = "꺼짐",
        fixlag = "🔧 렉 수정",
        superjump = "🦘 슈퍼 점프",
        fly = "✈️ 비행",
        noclip = "👻 노클립",
        espplayers = "👤 ESP 플레이어",
        espmobs = "👾 ESP 몹",
        espfruits = "🍎 ESP 과일",
        ghost = "👻 유령",
        nightvision = "🌙 야간 투시",
        map = "🗺️ 맵 서버",
        teleport = "🚀 텔레포트",
        refreshmap = "🔄 새로고침",
        clearmap = "🧹 초기화",
        flyspeed = "✈️ 비행 속도",
        jumppower = "🦘 점프 파워",
        autofarm = "⚔️ 자동 사냥",
        selectmob = "🎯 몹 선택",
        selectweapon = "🔫 무기 선택",
        aimbot = "🎯 에임봇",
        fov = "📐 FOV",
        color = "🎨 색상",
        no_target = "⚠️ 대상 없음!",
        teleported = "✅ 텔레포트 완료!",
        selected = "✅ 선택됨: ",
        distance = "m",
        loading = "🔄 로딩 중...",
        status_standing = "🧍 대기 중",
        status_farming = "⚔️ 사냥 중...",
        mobs_found = "🐉 몹 발견: "
    }
}

local CurrentLang = "Vietnamese"
local Lang = Languages[CurrentLang]

-- // ============ TOGGLE STATES ============
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
    Aimbot = false
}

-- // ============ VARIABLES ============
local FlySpeed = 50
local JumpPower = 250
local GhostStealth = 0.3
local MenuOpen = false
local CurrentTab = "Main"
local SelectedMapPoint = nil
local SelectedMapName = "Chưa chọn"
local DetectedMapPoints = {}
local ESPObjects = {}
local ESPUpdateRate = 0.3
local SelectedMob = nil
local SelectedWeapon = nil
local IsFarming = false
local FarmTargets = {}
local AimbotFOV = 200
local AimbotColor = Color3.fromRGB(255, 0, 0)
local AimbotEnabled = false
local AimbotTarget = nil
local FOVCircle = nil

-- // Fly variables
local flyEnabled = false
local bodyVelocity = nil
local noclipParts = {}

-- // ============ RAINBOW COLOR GENERATOR ============
local function RainbowColor(offset)
    local t = tick() % 5 / 5 + (offset or 0)
    return Color3.fromHSV(t % 1, 1, 1)
end

-- // ============ INFO DISPLAY ============
local function CreateInfoDisplay()
    local infoGui = Instance.new("ScreenGui")
    infoGui.Name = "MVInfo"
    infoGui.Parent = LocalPlayer.PlayerGui
    infoGui.ResetOnSpawn = false

    local infoFrame = Instance.new("Frame")
    infoFrame.Parent = infoGui
    infoFrame.Size = UDim2.new(0, 280, 0, 70)
    infoFrame.Position = UDim2.new(1, -290, 0, 10)
    infoFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 25)
    infoFrame.BackgroundTransparency = 0.3
    infoFrame.BorderSizePixel = 0

    local corner = Instance.new("UICorner")
    corner.Parent = infoFrame
    corner.CornerRadius = UDim.new(0, 8)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = infoFrame
    titleLabel.Size = UDim2.new(1, 0, 0.5, 0)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "Shinn Dev Bot X Hack Game"
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextStrokeTransparency = 0.2

    local timeLabel = Instance.new("TextLabel")
    timeLabel.Parent = infoFrame
    timeLabel.Size = UDim2.new(1, 0, 0.5, 0)
    timeLabel.Position = UDim2.new(0, 0, 0.5, 0)
    timeLabel.BackgroundTransparency = 1
    timeLabel.Text = ""
    timeLabel.TextScaled = true
    timeLabel.Font = Enum.Font.Gotham
    timeLabel.TextStrokeTransparency = 0.2

    spawn(function()
        while wait(0.1) do
            local color = RainbowColor()
            titleLabel.TextColor3 = color
            timeLabel.TextColor3 = RainbowColor(0.3)
            timeLabel.Text = os.date("%H:%M:%S - %d/%m/%Y")
        end
    end)

    return infoFrame
end

-- // ============ FOV CIRCLE ============
local function CreateFOVCircle()
    if FOVCircle then FOVCircle:Destroy() end

    local circle = Instance.new("Frame")
    circle.Parent = LocalPlayer.PlayerGui
    circle.Size = UDim2.new(0, AimbotFOV * 2, 0, AimbotFOV * 2)
    circle.Position = UDim2.new(0.5, -AimbotFOV, 0.5, -AimbotFOV)
    circle.BackgroundTransparency = 1
    circle.ZIndex = 999
    circle.Visible = Toggles.Aimbot

    local drawing = Instance.new("ImageLabel")
    drawing.Parent = circle
    drawing.Size = UDim2.new(1, 0, 1, 0)
    drawing.BackgroundTransparency = 1
    drawing.Image = "rbxassetid://6023420974"
    drawing.ImageColor3 = AimbotColor
    drawing.ImageTransparency = 0.5
    drawing.ZIndex = 999

    FOVCircle = circle
    return circle
end

-- // ============ AIMBOT SYSTEM ============
local function GetTargetsInFOV()
    local targets = {}
    local char = LocalPlayer.Character
    if not char then return targets end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return targets end

    local myPos = root.Position

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local screenPos, onScreen = Camera:WorldToScreenPoint(targetRoot.Position)
                if onScreen then
                    local dist = (myPos - targetRoot.Position).Magnitude
                    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                    local fovDist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                    if fovDist <= AimbotFOV then
                        table.insert(targets, {
                            Object = targetRoot,
                            Distance = dist,
                            FOVDist = fovDist,
                            Type = "player",
                            Name = player.Name
                        })
                    end
                end
            end
        end
    end

    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
            local name = v.Name:lower()
            if name:find("npc") or name:find("mob") or name:find("boss") or name:find("enemy") then
                local targetRoot = v.HumanoidRootPart
                local screenPos, onScreen = Camera:WorldToScreenPoint(targetRoot.Position)
                if onScreen then
                    local dist = (myPos - targetRoot.Position).Magnitude
                    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                    local fovDist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                    if fovDist <= AimbotFOV then
                        table.insert(targets, {
                            Object = targetRoot,
                            Distance = dist,
                            FOVDist = fovDist,
                            Type = "mob",
                            Name = v.Name
                        })
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
            if not Toggles.Aimbot then 
                if FOVCircle then FOVCircle.Visible = false end
                continue 
            end
            if FOVCircle then FOVCircle.Visible = true end

            local targets = GetTargetsInFOV()
            if #targets > 0 then
                local target = targets[1]
                AimbotTarget = target

                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local root = char.HumanoidRootPart
                    local direction = (target.Object.Position - root.Position).Unit
                    local lookAt = root.Position + direction * 100
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, lookAt)
                end
            else
                AimbotTarget = nil
            end
        end
    end)
end

-- // ============ AUTO FARM SYSTEM ============
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

local function AutoFarmLoop()
    spawn(function()
        while wait(0.1) do
            if not Toggles.AutoFarm or not SelectedMob then
                IsFarming = false
                continue
            end

            IsFarming = true
            local char = LocalPlayer.Character
            if not char then continue end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then continue end

            local closest = nil
            local closestDist = math.huge
            for _, mob in pairs(FarmTargets) do
                if mob.Model and mob.Model.Parent and mob.Root then
                    if mob.Name:lower():find(string.lower(SelectedMob)) or SelectedMob == "Tất cả" then
                        local dist = (root.Position - mob.Root.Position).Magnitude
                        if dist < closestDist and mob.Humanoid and mob.Humanoid.Health > 0 then
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

            if tick() % 5 < 0.1 then
                ScanMobs()
            end
        end
    end)
end

-- // ============ FLY SYSTEM (Mobile) ============
local function InitFly()
    -- Fly toggle via on-screen button or double tap
    local flyButton = nil
    
    if IsMobile then
        -- Tạo nút Fly trên màn hình cho mobile
        local flyBtn = Instance.new("TextButton")
        flyBtn.Parent = LocalPlayer.PlayerGui
        flyBtn.Size = UDim2.new(0, 60, 0, 60)
        flyBtn.Position = UDim2.new(1, -80, 0.5, 30)
        flyBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
        flyBtn.Text = "🛸"
        flyBtn.TextScaled = true
        flyBtn.Font = Enum.Font.GothamBold
        flyBtn.BorderSizePixel = 0
        flyBtn.BackgroundTransparency = 0.3
        flyBtn.Visible = true
        
        local flyCorner = Instance.new("UICorner")
        flyCorner.Parent = flyBtn
        flyCorner.CornerRadius = UDim.new(1, 0)
        
        flyBtn.MouseButton1Click:Connect(function()
            if Toggles.Fly then
                flyEnabled = not flyEnabled
                flyBtn.Text = flyEnabled and "🛸 ON" or "🛸"
                flyBtn.BackgroundColor3 = flyEnabled and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(30, 30, 60)
                
                local char = LocalPlayer.Character
                if not char then return end
                local rootPart = char:FindFirstChild("HumanoidRootPart")
                if not rootPart then return end
                
                if flyEnabled then
                    bodyVelocity = Instance.new("BodyVelocity")
                    bodyVelocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
                    bodyVelocity.Parent = rootPart
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                else
                    if bodyVelocity then bodyVelocity:Destroy() end
                    bodyVelocity = nil
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = true
                        end
                    end
                end
            end
        end)
        
        flyButton = flyBtn
    end

    spawn(function()
        while wait() do
            if flyEnabled and Toggles.Fly and bodyVelocity then
                local rootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not rootPart then
                    flyEnabled = false
                    if bodyVelocity then bodyVelocity:Destroy() end
                    bodyVelocity = nil
                    if flyButton then
                        flyButton.Text = "🛸"
                        flyButton.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
                    end
                    continue
                end

                local moveDirection = Vector3.new(0, 0, 0)
                
                -- Mobile touch controls (virtual joystick)
                if IsMobile then
                    -- Sử dụng touch movement
                    local touchPos = UserInputService:GetTouchPositions()
                    if #touchPos > 0 then
                        local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                        local delta = touchPos[1] - center
                        local magnitude = delta.Magnitude
                        if magnitude > 50 then
                            local dir = delta.Unit
                            moveDirection = Vector3.new(dir.X, 0, -dir.Y) * math.min(magnitude / 100, 1)
                        end
                    end
                else
                    -- PC controls (vẫn giữ cho test)
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

-- // ============ FIXED NOCLIP ============
local function InitNoclip()
    spawn(function()
        while wait(0.05) do
            if Toggles.Noclip or flyEnabled then
                local char = LocalPlayer.Character
                if char then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            elseif not Toggles.Noclip and not flyEnabled then
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

-- // ============ ESP WITH DISTANCE ============
local function CreateESP(object, color, text, objectType)
    if not object or not object:IsA("BasePart") then return end

    for _, v in pairs(object:GetChildren()) do
        if v:IsA("BillboardGui") and v.Name == "MV_ESP" then
            v:Destroy()
        end
    end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "MV_ESP"
    billboard.Size = UDim2.new(0, 200, 0, 50)
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
                        local distText = distM .. Lang.distance

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

-- // ============ MAP SCAN ============
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
    end

    return DetectedMapPoints
end

-- // ============ MOBILE UI ============
local function CreateUI()
    if not LocalPlayer or not LocalPlayer.PlayerGui then
        warn("PlayerGui not found, retrying...")
        return nil
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = LocalPlayer.PlayerGui
    ScreenGui.Name = "MVHack"
    ScreenGui.ResetOnSpawn = false

    -- Mobile-optimized size
    local menuWidth = IsMobile and 350 or 700
    local menuHeight = IsMobile and 500 or 400
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Parent = ScreenGui
    MainFrame.Size = UDim2.new(0, menuWidth, 0, menuHeight)
    MainFrame.Position = UDim2.new(0.5, -menuWidth/2, 0.5, -menuHeight/2)
    MainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 20)
    MainFrame.BackgroundTransparency = 0.08
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Visible = true
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true

    local corner = Instance.new("UICorner")
    corner.Parent = MainFrame
    corner.CornerRadius = UDim.new(0, 12)

    -- // Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Parent = MainFrame
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 50)
    TitleBar.BorderSizePixel = 0

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Parent = TitleBar
    TitleLabel.Size = UDim2.new(0.5, 0, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Lang.title
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextScaled = true
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- // Language Dropdown
    local LangBtn = Instance.new("TextButton")
    LangBtn.Parent = TitleBar
    LangBtn.Size = UDim2.new(0, 60, 0, 28)
    LangBtn.Position = UDim2.new(0.65, 0, 0, 6)
    LangBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
    LangBtn.Text = "🇻🇳"
    LangBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    LangBtn.TextScaled = true
    LangBtn.Font = Enum.Font.GothamBold
    LangBtn.BorderSizePixel = 0

    local langIndex = 1
    local langList = {"Vietnamese", "English", "Korean"}
    local langFlags = {"🇻🇳", "🇬🇧", "🇰🇷"}

    LangBtn.MouseButton1Click:Connect(function()
        langIndex = langIndex % 3 + 1
        CurrentLang = langList[langIndex]
        Lang = Languages[CurrentLang]
        LangBtn.Text = langFlags[langIndex]
        TitleLabel.Text = Lang.title
        for _, btn in pairs(MainFrame:GetDescendants()) do
            if btn:IsA("TextButton") and btn.Name == "ToggleBtn" then
                local key = btn:GetAttribute("ToggleKey")
                if key and Toggles[key] ~= nil then
                    btn.Text = Lang[key] .. " [" .. (Toggles[key] and Lang.toggle_on or Lang.toggle_off) .. "]"
                end
            end
        end
    end)

    -- // Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Parent = TitleBar
    CloseBtn.Size = UDim2.new(0, 35, 0, 35)
    CloseBtn.Position = UDim2.new(1, -40, 0, 2)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.TextScaled = true
    CloseBtn.BorderSizePixel = 0
    CloseBtn.BackgroundTransparency = 0.3
    CloseBtn.MouseButton1Click:Connect(function()
        MenuOpen = false
        MainFrame.Visible = false
    end)

    -- // Tab Bar - Horizontal
    local TabBar = Instance.new("Frame")
    TabBar.Parent = MainFrame
    TabBar.Size = UDim2.new(1, 0, 0, 35)
    TabBar.Position = UDim2.new(0, 0, 0, 40)
    TabBar.BackgroundColor3 = Color3.fromRGB(15, 15, 35)
    TabBar.BorderSizePixel = 0

    local tabs = {"Main", "ESP", "Farm", "Aimbot", "Map"}
    local tabButtons = {}

    for i, tab in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Parent = TabBar
        btn.Size = UDim2.new(0.2, 0, 1, 0)
        btn.Position = UDim2.new((i-1) * 0.2, 0, 0, 0)
        btn.BackgroundColor3 = (i == 1) and Color3.fromRGB(40, 40, 80) or Color3.fromRGB(20, 20, 50)
        btn.Text = tab
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextScaled = true
        btn.Font = Enum.Font.GothamBold
        btn.BorderSizePixel = 0
        btn.Name = "Tab_" .. tab

        btn.MouseButton1Click:Connect(function()
            CurrentTab = tab
            for _, b in pairs(tabButtons) do
                b.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
            end
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 80)
            for _, child in pairs(MainFrame:GetChildren()) do
                if child:IsA("ScrollingFrame") then
                    child.Visible = (child.Name == "Content_" .. tab)
                end
            end
        end)

        tabButtons[i] = btn
    end

    -- // Content Panels
    local function CreateContentPanel(tabName)
        local panel = Instance.new("ScrollingFrame")
        panel.Parent = MainFrame
        panel.Name = "Content_" .. tabName
        panel.Size = UDim2.new(1, -10, 1, -85)
        panel.Position = UDim2.new(0, 5, 0, 80)
        panel.BackgroundTransparency = 1
        panel.BorderSizePixel = 0
        panel.CanvasSize = UDim2.new(0, 0, 0, 0)
        panel.ScrollBarThickness = 4
        panel.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 120)
        panel.Visible = (tabName == "Main")

        local layout = Instance.new("UIListLayout")
        layout.Parent = panel
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 5)

        return panel
    end

    -- // Main Panel
    local MainPanel = CreateContentPanel("Main")
    local function AddMainToggle(panel, labelKey, toggleKey)
        local btn = Instance.new("TextButton")
        btn.Parent = panel
        btn.Size = UDim2.new(0.45, 0, 0, 40)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
        btn.Text = Lang[labelKey] .. " [" .. Lang.toggle_off .. "]"
        btn.TextColor3 = Color3.fromRGB(220, 220, 220)
        btn.TextScaled = true
        btn.Font = Enum.Font.Gotham
        btn.BorderSizePixel = 0
        btn.BackgroundTransparency = 0.2
        btn.Name = "ToggleBtn"
        btn:SetAttribute("ToggleKey", toggleKey)

        local corner = Instance.new("UICorner")
        corner.Parent = btn
        corner.CornerRadius = UDim.new(0, 6)

        btn.MouseButton1Click:Connect(function()
            Toggles[toggleKey] = not Toggles[toggleKey]
            btn.Text = Lang[labelKey] .. " [" .. (Toggles[toggleKey] and Lang.toggle_on or Lang.toggle_off) .. "]"
            btn.BackgroundColor3 = Toggles[toggleKey] and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(40, 40, 65)
        end)

        return btn
    end

    -- Add toggles in 2 columns
    local mainToggles = {
        {"fixlag", "FixLag"},
        {"superjump", "SuperJump"},
        {"fly", "Fly"},
        {"noclip", "Noclip"},
        {"ghost", "Ghost"},
        {"nightvision", "NightVision"}
    }

    for i, data in ipairs(mainToggles) do
        local btn = AddMainToggle(MainPanel, data[1], data[2])
        if i % 2 == 0 then
            btn.Position = UDim2.new(0.52, 0, 0, (math.floor((i-1)/2)) * 45 + 5)
        else
            btn.Position = UDim2.new(0.02, 0, 0, (math.floor((i-1)/2)) * 45 + 5)
        end
    end

    -- // Fly Speed Slider
    local function AddSlider(panel, labelKey, varRef, minVal, maxVal, step)
        local frame = Instance.new("Frame")
        frame.Parent = panel
        frame.Size = UDim2.new(0.45, 0, 0, 60)
        frame.BackgroundTransparency = 1

        local label = Instance.new("TextLabel")
        label.Parent = frame
        label.Size = UDim2.new(1, 0, 0.4, 0)
        label.BackgroundTransparency = 1
        label.Text = Lang[labelKey]
        label.TextColor3 = Color3.fromRGB(200, 200, 255)
        label.TextScaled = true
        label.Font = Enum.Font.GothamBold

        local sliderFrame = Instance.new("Frame")
        sliderFrame.Parent = frame
        sliderFrame.Size = UDim2.new(1, 0, 0.5, 0)
        sliderFrame.Position = UDim2.new(0, 0, 0.5, 0)
        sliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
        sliderFrame.BorderSizePixel = 0

        local valueLabel = Instance.new("TextLabel")
        valueLabel.Parent = sliderFrame
        valueLabel.Size = UDim2.new(0.2, 0, 1, 0)
        valueLabel.Position = UDim2.new(0.8, 0, 0, 0)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = tostring(varRef)
        valueLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
        valueLabel.TextScaled = true
        valueLabel.Font = Enum.Font.GothamBold

        local minus = Instance.new("TextButton")
        minus.Parent = sliderFrame
        minus.Size = UDim2.new(0.12, 0, 1, 0)
        minus.Position = UDim2.new(0, 0, 0, 0)
        minus.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
        minus.Text = "-"
        minus.TextColor3 = Color3.fromRGB(255, 255, 255)
        minus.TextScaled = true
        minus.BorderSizePixel = 0
        minus.MouseButton1Click:Connect(function()
            varRef = math.max(minVal, varRef - step)
            valueLabel.Text = tostring(varRef)
        end)

        local plus = Instance.new("TextButton")
        plus.Parent = sliderFrame
        plus.Size = UDim2.new(0.12, 0, 1, 0)
        plus.Position = UDim2.new(0.65, 0, 0, 0)
        plus.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        plus.Text = "+"
        plus.TextColor3 = Color3.fromRGB(255, 255, 255)
        plus.TextScaled = true
        plus.BorderSizePixel = 0
        plus.MouseButton1Click:Connect(function()
            varRef = math.min(maxVal, varRef + step)
            valueLabel.Text = tostring(varRef)
        end)

        return frame
    end

    AddSlider(MainPanel, "flyspeed", FlySpeed, 10, 200, 5)
    AddSlider(MainPanel, "jumppower", JumpPower, 50, 500, 50)

    -- // ESP Panel
    local ESPPanel = CreateContentPanel("ESP")
    ESPPanel.Visible = false

    local espToggles = {
        {"espplayers", "ESPPlayers"},
        {"espmobs", "ESPMobs"},
        {"espfruits", "ESPFruits"}
    }

    for i, data in ipairs(espToggles) do
        local btn = AddMainToggle(ESPPanel, data[1], data[2])
        btn.Position = UDim2.new(0.02, 0, 0, (i-1) * 45 + 5)
    end

    -- // Farm Panel
    local FarmPanel = CreateContentPanel("Farm")
    FarmPanel.Visible = false

    local farmToggle = AddMainToggle(FarmPanel, "autofarm", "AutoFarm")
    farmToggle.Position = UDim2.new(0.02, 0, 0, 5)

    local mobFrame = Instance.new("Frame")
    mobFrame.Parent = FarmPanel
    mobFrame.Size = UDim2.new(0.45, 0, 0, 40)
    mobFrame.Position = UDim2.new(0.02, 0, 0, 50)
    mobFrame.BackgroundTransparency = 1

    local mobLabel = Instance.new("TextLabel")
    mobLabel.Parent = mobFrame
    mobLabel.Size = UDim2.new(0.4, 0, 1, 0)
    mobLabel.BackgroundTransparency = 1
    mobLabel.Text = Lang.selectmob
    mobLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    mobLabel.TextScaled = true
    mobLabel.Font = Enum.Font.GothamBold

    local mobDropdown = Instance.new("TextButton")
    mobDropdown.Parent = mobFrame
    mobDropdown.Size = UDim2.new(0.55, 0, 1, 0)
    mobDropdown.Position = UDim2.new(0.45, 0, 0, 0)
    mobDropdown.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
    mobDropdown.Text = "Tất cả"
    mobDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    mobDropdown.TextScaled = true
    mobDropdown.Font = Enum.Font.Gotham
    mobDropdown.BorderSizePixel = 0

    mobDropdown.MouseButton1Click:Connect(function()
        ScanMobs()
        local mobNames = {"Tất cả"}
        for _, mob in pairs(FarmTargets) do
            table.insert(mobNames, mob.Name)
        end
        local current = mobDropdown.Text
        local index = 1
        for i, name in ipairs(mobNames) do
            if name == current then
                index = i % #mobNames + 1
                break
            end
        end
        mobDropdown.Text = mobNames[index]
        SelectedMob = mobNames[index]
    end)

    local weaponFrame = Instance.new("Frame")
    weaponFrame.Parent = FarmPanel
    weaponFrame.Size = UDim2.new(0.45, 0, 0, 40)
    weaponFrame.Position = UDim2.new(0.52, 0, 0, 50)
    weaponFrame.BackgroundTransparency = 1

    local weaponLabel = Instance.new("TextLabel")
    weaponLabel.Parent = weaponFrame
    weaponLabel.Size = UDim2.new(0.4, 0, 1, 0)
    weaponLabel.BackgroundTransparency = 1
    weaponLabel.Text = Lang.selectweapon
    weaponLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    weaponLabel.TextScaled = true
    weaponLabel.Font = Enum.Font.GothamBold

    local weaponDropdown = Instance.new("TextButton")
    weaponDropdown.Parent = weaponFrame
    weaponDropdown.Size = UDim2.new(0.55, 0, 1, 0)
    weaponDropdown.Position = UDim2.new(0.45, 0, 0, 0)
    weaponDropdown.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
    weaponDropdown.Text = "Auto"
    weaponDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    weaponDropdown.TextScaled = true
    weaponDropdown.Font = Enum.Font.Gotham
    weaponDropdown.BorderSizePixel = 0

    weaponDropdown.MouseButton1Click:Connect(function()
        local char = LocalPlayer.Character
        if not char then return end
        local weapons = {"Auto"}
        for _, tool in pairs(char:GetChildren()) do
            if tool:IsA("Tool") then
                table.insert(weapons, tool.Name)
            end
        end
        local current = weaponDropdown.Text
        local index = 1
        for i, name in ipairs(weapons) do
            if name == current then
                index = i % #weapons + 1
                break
            end
        end
        weaponDropdown.Text = weapons[index]
        SelectedWeapon = weapons[index]
    end)

    local statusFrame = Instance.new("Frame")
    statusFrame.Parent = FarmPanel
    statusFrame.Size = UDim2.new(0.95, 0, 0, 30)
    statusFrame.Position = UDim2.new(0.025, 0, 0, 100)
    statusFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 45)
    statusFrame.BorderSizePixel = 0

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Parent = statusFrame
    statusLabel.Size = UDim2.new(1, 0, 1, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = Lang.status_standing
    statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    statusLabel.TextScaled = true
    statusLabel.Font = Enum.Font.Gotham

    local mobCountLabel = Instance.new("TextLabel")
    mobCountLabel.Parent = FarmPanel
    mobCountLabel.Size = UDim2.new(0.95, 0, 0, 25)
    mobCountLabel.Position = UDim2.new(0.025, 0, 0, 135)
    mobCountLabel.BackgroundTransparency = 1
    mobCountLabel.Text = Lang.mobs_found .. "0"
    mobCountLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    mobCountLabel.TextScaled = true
    mobCountLabel.Font = Enum.Font.Gotham

    spawn(function()
        while wait(0.5) do
            if Toggles.AutoFarm and SelectedMob then
                statusLabel.Text = Lang.status_farming
                statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            else
                statusLabel.Text = Lang.status_standing
                statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
            ScanMobs()
            mobCountLabel.Text = Lang.mobs_found .. #FarmTargets
        end
    end)

    -- // Aimbot Panel
    local AimbotPanel = CreateContentPanel("Aimbot")
    AimbotPanel.Visible = false

    local aimToggle = AddMainToggle(AimbotPanel, "aimbot", "Aimbot")
    aimToggle.Position = UDim2.new(0.02, 0, 0, 5)

    local fovFrame = Instance.new("Frame")
    fovFrame.Parent = AimbotPanel
    fovFrame.Size = UDim2.new(0.45, 0, 0, 50)
    fovFrame.Position = UDim2.new(0.02, 0, 0, 50)
    fovFrame.BackgroundTransparency = 1

    local fovLabel = Instance.new("TextLabel")
    fovLabel.Parent = fovFrame
    fovLabel.Size = UDim2.new(1, 0, 0.4, 0)
    fovLabel.BackgroundTransparency = 1
    fovLabel.Text = Lang.fov
    fovLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    fovLabel.TextScaled = true
    fovLabel.Font = Enum.Font.GothamBold

    local fovSliderFrame = Instance.new("Frame")
    fovSliderFrame.Parent = fovFrame
    fovSliderFrame.Size = UDim2.new(1, 0, 0.5, 0)
    fovSliderFrame.Position = UDim2.new(0, 0, 0.5, 0)
    fovSliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
    fovSliderFrame.BorderSizePixel = 0

    local fovValue = Instance.new("TextLabel")
    fovValue.Parent = fovSliderFrame
    fovValue.Size = UDim2.new(0.2, 0, 1, 0)
    fovValue.Position = UDim2.new(0.8, 0, 0, 0)
    fovValue.BackgroundTransparency = 1
    fovValue.Text = tostring(AimbotFOV)
    fovValue.TextColor3 = Color3.fromRGB(255, 255, 100)
    fovValue.TextScaled = true
    fovValue.Font = Enum.Font.GothamBold

    local fovMinus = Instance.new("TextButton")
    fovMinus.Parent = fovSliderFrame
    fovMinus.Size = UDim2.new(0.12, 0, 1, 0)
    fovMinus.Position = UDim2.new(0, 0, 0, 0)
    fovMinus.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
    fovMinus.Text = "-"
    fovMinus.TextColor3 = Color3.fromRGB(255, 255, 255)
    fovMinus.TextScaled = true
    fovMinus.BorderSizePixel = 0
    fovMinus.MouseButton1Click:Connect(function()
        AimbotFOV = math.max(50, AimbotFOV - 10)
        fovValue.Text = tostring(AimbotFOV)
        CreateFOVCircle()
    end)

    local fovPlus = Instance.new("TextButton")
    fovPlus.Parent = fovSliderFrame
    fovPlus.Size = UDim2.new(0.12, 0, 1, 0)
    fovPlus.Position = UDim2.new(0.65, 0, 0, 0)
    fovPlus.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
    fovPlus.Text = "+"
    fovPlus.TextColor3 = Color3.fromRGB(255, 255, 255)
    fovPlus.TextScaled = true
    fovPlus.BorderSizePixel = 0
    fovPlus.MouseButton1Click:Connect(function()
        AimbotFOV = math.min(400, AimbotFOV + 10)
        fovValue.Text = tostring(AimbotFOV)
        CreateFOVCircle()
    end)

    local colorFrame = Instance.new("Frame")
    colorFrame.Parent = AimbotPanel
    colorFrame.Size = UDim2.new(0.45, 0, 0, 40)
    colorFrame.Position = UDim2.new(0.52, 0, 0, 50)
    colorFrame.BackgroundTransparency = 1

    local colorLabel = Instance.new("TextLabel")
    colorLabel.Parent = colorFrame
    colorLabel.Size = UDim2.new(0.4, 0, 1, 0)
    colorLabel.BackgroundTransparency = 1
    colorLabel.Text = Lang.color
    colorLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    colorLabel.TextScaled = true
    colorLabel.Font = Enum.Font.GothamBold

    local colorBtn = Instance.new("TextButton")
    colorBtn.Parent = colorFrame
    colorBtn.Size = UDim2.new(0.55, 0, 1, 0)
    colorBtn.Position = UDim2.new(0.45, 0, 0, 0)
    colorBtn.BackgroundColor3 = AimbotColor
    colorBtn.Text = "●"
    colorBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    colorBtn.TextScaled = true
    colorBtn.Font = Enum.Font.GothamBold
    colorBtn.BorderSizePixel = 0

    local colors = {
        Color3.fromRGB(255, 0, 0),
        Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(0, 0, 255),
        Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(255, 0, 255),
        Color3.fromRGB(0, 255, 255)
    }
    local colorIndex = 1

    colorBtn.MouseButton1Click:Connect(function()
        colorIndex = colorIndex % #colors + 1
        AimbotColor = colors[colorIndex]
        colorBtn.BackgroundColor3 = AimbotColor
        CreateFOVCircle()
    end)

    -- // Map Panel
    local MapPanel = CreateContentPanel("Map")
    MapPanel.Visible = false

    local function BuildMapUI()
        ScanMap()
        for _, child in pairs(MapPanel:GetChildren()) do
            if child:IsA("TextButton") or child:IsA("TextLabel") then
                child:Destroy()
            end
        end

        local mapLabel = Instance.new("TextLabel")
        mapLabel.Parent = MapPanel
        mapLabel.Size = UDim2.new(0.95, 0, 0, 25)
        mapLabel.Position = UDim2.new(0.025, 0, 0, 5)
        mapLabel.BackgroundTransparency = 1
        mapLabel.Text = Lang.map .. " (" .. #DetectedMapPoints .. ")"
        mapLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
        mapLabel.TextScaled = true
        mapLabel.Font = Enum.Font.GothamBold

        local selectedText = Instance.new("TextLabel")
        selectedText.Parent = MapPanel
        selectedText.Size = UDim2.new(0.7, 0, 0, 30)
        selectedText.Position = UDim2.new(0.025, 0, 0, 35)
        selectedText.BackgroundColor3 = Color3.fromRGB(20, 20, 45)
        selectedText.Text = "📌 " .. SelectedMapName
        selectedText.TextColor3 = Color3.fromRGB(255, 255, 255)
        selectedText.TextScaled = true
        selectedText.Font = Enum.Font.Gotham
        selectedText.BorderSizePixel = 0

        local teleportBtn = Instance.new("TextButton")
        teleportBtn.Parent = MapPanel
        teleportBtn.Size = UDim2.new(0.22, 0, 0, 30)
        teleportBtn.Position = UDim2.new(0.73, 0, 0, 35)
        teleportBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 200)
        teleportBtn.Text = Lang.teleport
        teleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        teleportBtn.TextScaled = true
        teleportBtn.Font = Enum.Font.GothamBold
        teleportBtn.BorderSizePixel = 0

        teleportBtn.MouseButton1Click:Connect(function()
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

        local refreshBtn = Instance.new("TextButton")
        refreshBtn.Parent = MapPanel
        refreshBtn.Size = UDim2.new(0.45, 0, 0, 28)
        refreshBtn.Position = UDim2.new(0.025, 0, 0, 70)
        refreshBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
        refreshBtn.Text = Lang.refreshmap
        refreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        refreshBtn.TextScaled = true
        refreshBtn.Font = Enum.Font.GothamBold
        refreshBtn.BorderSizePixel = 0
        refreshBtn.MouseButton1Click:Connect(function()
            BuildMapUI()
        end)

        local clearBtn = Instance.new("TextButton")
        clearBtn.Parent = MapPanel
        clearBtn.Size = UDim2.new(0.45, 0, 0, 28)
        clearBtn.Position = UDim2.new(0.525, 0, 0, 70)
        clearBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
        clearBtn.Text = Lang.clearmap
        clearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        clearBtn.TextScaled = true
        clearBtn.Font = Enum.Font.GothamBold
        clearBtn.BorderSizePixel = 0
        clearBtn.MouseButton1Click:Connect(function()
            SelectedMapPoint = nil
            SelectedMapName = "Chưa chọn"
            selectedText.Text = "📌 Chưa chọn"
        end)

        local yPos = 105
        local col = 1
        local row = 0

        for i, mapData in ipairs(DetectedMapPoints) do
            local mapBtn = Instance.new("TextButton")
            mapBtn.Parent = MapPanel

            local xPos = (col == 1) and 0.025 or 0.525
            local yOffset = yPos + row * 34

            mapBtn.Size = UDim2.new(0.45, 0, 0, 30)
            mapBtn.Position = UDim2.new(xPos, 0, 0, yOffset)
            mapBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
            mapBtn.Text = mapData.Name
            mapBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
            mapBtn.TextScaled = true
            mapBtn.Font = Enum.Font.Gotham
            mapBtn.BorderSizePixel = 0
            mapBtn.BackgroundTransparency = 0.2

            local corner = Instance.new("UICorner")
            corner.Parent = mapBtn
            corner.CornerRadius = UDim.new(0, 4)

            mapBtn.MouseButton1Click:Connect(function()
                SelectedMapPoint = mapData.Position
                SelectedMapName = mapData.Name
                selectedText.Text = "📌 " .. mapData.Name

                for _, btn in pairs(MapPanel:GetChildren()) do
                    if btn:IsA("TextButton") and btn.Text:find("✅") then
                        btn.Text = btn.Text:gsub(" ✅", "")
                        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
                    end
                end
                mapBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
                mapBtn.Text = mapData.Name .. " ✅"
            end)

            if col == 1 then
                col = 2
            else
                col = 1
                row = row + 1
            end
        end

        local totalRows = math.ceil(#DetectedMapPoints / 2)
        MapPanel.CanvasSize = UDim2.new(0, 0, 0, yPos + totalRows * 34 + 60)
    end

    BuildMapUI()

    -- // Toggle Button - MV Icon (Mobile friendly - bigger)
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Parent = ScreenGui
    local btnSize = IsMobile and 75 or 65
    ToggleBtn.Size = UDim2.new(0, btnSize, 0, btnSize)
    ToggleBtn.Position = IsMobile and UDim2.new(0, 10, 0, 50) or UDim2.new(0, 15, 0.5, -32)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 50)
    ToggleBtn.Text = "MV"
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.TextScaled = true
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.BorderSizePixel = 0
    ToggleBtn.BackgroundTransparency = 0.2

    local glow = Instance.new("UICorner")
    glow.Parent = ToggleBtn
    glow.CornerRadius = UDim.new(1, 0)

    ToggleBtn.MouseButton1Click:Connect(function()
        MenuOpen = not MenuOpen
        MainFrame.Visible = MenuOpen
        if MenuOpen then
            BuildMapUI()
            ScanMobs()
        end
        TweenService:Create(ToggleBtn, TweenInfo.new(0.1), {BackgroundTransparency = 0.5}):Play()
        wait(0.1)
        TweenService:Create(ToggleBtn, TweenInfo.new(0.1), {BackgroundTransparency = 0.2}):Play()
    end)

    -- // Mobile Gesture Controls (Swipe to toggle menu)
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
                    MainFrame.Visible = MenuOpen
                    if MenuOpen then
                        BuildMapUI()
                        ScanMobs()
                    end
                end
                startPos = nil
            end
        end)
    end

    return MainFrame
end

-- // ============ FEATURE FUNCTIONS ============
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
                    local head = char:FindFirstChild("Head")
                    if head then
                        for _, child in pairs(head:GetChildren()) do
                            if child:IsA("BillboardGui") then
                                child.Enabled = false
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
                    local head = char:FindFirstChild("Head")
                    if head then
                        for _, child in pairs(head:GetChildren()) do
                            if child:IsA("BillboardGui") then
                                child.Enabled = true
                            end
                        end
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

local function AntiIdle()
    spawn(function()
        while wait(60) do
            LocalPlayer.Idled:Connect(function()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end
    end)
end

-- // ============ INIT ============
CreateUI()
CreateInfoDisplay()
CreateFOVCircle()
FixLag()
SuperJump()
InitFly()
InitNoclip()
ESPLoop()
UpdateDistances()
GhostMode()
NightVision()
AutoFarmLoop()
RunAimbot()
AntiIdle()
ScanMobs()

print("⚡ MV HUB v5.0 MOBILE LOADED")
print("📱 Touch: Tap MV icon | Swipe to toggle")
print("🛸 Fly button on right side")
print("💀 Boss man, fuck yeah! Mobile ready!")
