-- MV Hub | Axiom Build v5.0
-- Full Feature: Auto Farm, Fly, ESP Distance, Multi-Language

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

-- // LANGUAGE SETTINGS
local Languages = {
    ["🇻🇳 Tiếng Việt"] = {
        code = "vi",
        title = "⚡ MV HACK v5.0",
        toggle_fixlag = "🔧 Sửa Lag",
        toggle_superjump = "🦘 Siêu Nhảy",
        toggle_fly = "✈️ Bay",
        toggle_noclip = "👻 Xuyên Tường",
        toggle_espplayers = "👤 ESP Người Chơi",
        toggle_espmobs = "👾 ESP Quái",
        toggle_espfruits = "🍎 ESP Trái Cây",
        toggle_ghost = "👻 Tàng Hình (F1)",
        toggle_nightvision = "🌙 Nhìn Đêm (F2)",
        toggle_autofarm = "🤖 Auto Farm",
        map_title = "🗺️ MAP SERVER",
        map_selected = "📌 Đã Chọn",
        map_teleport = "🚀 Dịch Chuyển",
        map_refresh = "🔄 Quét Lại",
        map_clear = "🧹 Bỏ Chọn",
        map_none = "Chưa chọn",
        fly_speed = "✈️ Tốc Độ Bay",
        jump_power = "🦘 Sức Nhảy",
        admin_title = "👑 ADMIN",
        weapon_title = "🔫 VŨ KHÍ",
        mob_title = "👾 QUÁI VẬT",
        auto_farm_title = "⚙️ AUTO FARM",
        settings_title = "⚙️ CÀI ĐẶT",
        language_title = "🌐 NGÔN NGỮ",
        farm_status = "Trạng thái Farm",
        farm_start = "▶️ Bắt Đầu",
        farm_stop = "⏹️ Dừng",
        farm_gathering = "📦 Gom Quái",
        farm_auto = "Tự Động",
        farm_manual = "Thủ Công",
        selected = "✅ Đã chọn",
        distance = "m"
    },
    ["🇬🇧 English"] = {
        code = "en",
        title = "⚡ MV HACK v5.0",
        toggle_fixlag = "🔧 Fix Lag",
        toggle_superjump = "🦘 Super Jump",
        toggle_fly = "✈️ Fly",
        toggle_noclip = "👻 Noclip",
        toggle_espplayers = "👤 ESP Players",
        toggle_espmobs = "👾 ESP Mobs",
        toggle_espfruits = "🍎 ESP Fruits",
        toggle_ghost = "👻 Ghost (F1)",
        toggle_nightvision = "🌙 Night Vision (F2)",
        toggle_autofarm = "🤖 Auto Farm",
        map_title = "🗺️ MAP SERVER",
        map_selected = "📌 Selected",
        map_teleport = "🚀 Teleport",
        map_refresh = "🔄 Refresh",
        map_clear = "🧹 Clear",
        map_none = "None selected",
        fly_speed = "✈️ Fly Speed",
        jump_power = "🦘 Jump Power",
        admin_title = "👑 ADMIN",
        weapon_title = "🔫 WEAPONS",
        mob_title = "👾 MOBS",
        auto_farm_title = "⚙️ AUTO FARM",
        settings_title = "⚙️ SETTINGS",
        language_title = "🌐 LANGUAGE",
        farm_status = "Farm Status",
        farm_start = "▶️ Start",
        farm_stop = "⏹️ Stop",
        farm_gathering = "📦 Gather Mobs",
        farm_auto = "Auto",
        farm_manual = "Manual",
        selected = "✅ Selected",
        distance = "m"
    },
    ["🇰🇷 한국어"] = {
        code = "kr",
        title = "⚡ MV HACK v5.0",
        toggle_fixlag = "🔧 랙 수정",
        toggle_superjump = "🦘 슈퍼 점프",
        toggle_fly = "✈️ 비행",
        toggle_noclip = "👻 노클립",
        toggle_espplayers = "👤 ESP 플레이어",
        toggle_espmobs = "👾 ESP 몹",
        toggle_espfruits = "🍎 ESP 과일",
        toggle_ghost = "👻 고스트 (F1)",
        toggle_nightvision = "🌙 야간 투시 (F2)",
        toggle_autofarm = "🤖 자동 파밍",
        map_title = "🗺️ 서버 맵",
        map_selected = "📌 선택됨",
        map_teleport = "🚀 텔레포트",
        map_refresh = "🔄 새로고침",
        map_clear = "🧹 지우기",
        map_none = "선택 없음",
        fly_speed = "✈️ 비행 속도",
        jump_power = "🦘 점프 파워",
        admin_title = "👑 관리자",
        weapon_title = "🔫 무기",
        mob_title = "👾 몹",
        auto_farm_title = "⚙️ 자동 파밍",
        settings_title = "⚙️ 설정",
        language_title = "🌐 언어",
        farm_status = "파밍 상태",
        farm_start = "▶️ 시작",
        farm_stop = "⏹️ 중지",
        farm_gathering = "📦 몹 수집",
        farm_auto = "자동",
        farm_manual = "수동",
        selected = "✅ 선택됨",
        distance = "m"
    }
}

-- // Current Language
local CurrentLang = Languages["🇻🇳 Tiếng Việt"]
local LangCode = "vi"

-- // UI Variables
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton")
local ToggleBtn = Instance.new("TextButton")
local ScrollFrame = Instance.new("ScrollingFrame")
local UIList = Instance.new("UIListLayout")

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
    AutoFarm = false
}

-- // Fly Variables
local FlySpeed = 50
local JumpPower = 250
local GhostStealth = 0.3
local IsFlying = false
local BodyVelocity = nil

-- // Farm Variables
local FarmRunning = false
local FarmMode = "auto" -- auto or manual
local SelectedWeapon = nil
local SelectedMob = nil
local FarmRadius = 50
local FarmDelay = 0.5
local MobsList = {}
local WeaponsList = {}

-- // ESP Variables
local ESPObjects = {}
local ESPUpdateRate = 0.3

-- // Menu State
local MenuOpen = false

-- // Teleport Variables
local SelectedMapPoint = nil
local SelectedMapName = "Chưa chọn"
local DetectedMapPoints = {}
local MapButtons = {}

-- // Scan Weapons
local function ScanWeapons()
    WeaponsList = {}
    local player = LocalPlayer
    local char = player.Character
    if char then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("Tool") and v:FindFirstChild("Handle") then
                table.insert(WeaponsList, {
                    Name = v.Name,
                    Tool = v
                })
            end
        end
    end
    -- Tìm trong Backpack
    for _, v in pairs(player.Backpack:GetChildren()) do
        if v:IsA("Tool") and v:FindFirstChild("Handle") then
            table.insert(WeaponsList, {
                Name = v.Name,
                Tool = v
            })
        end
    end
    return WeaponsList
end

-- // Scan Mobs
local function ScanMobs()
    MobsList = {}
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
            local name = v.Name:lower()
            if name:find("npc") or name:find("mob") or name:find("boss") or name:find("enemy") or name:find("zombie") or name:find("skeleton") then
                table.insert(MobsList, {
                    Name = v.Name,
                    Model = v,
                    Humanoid = v.Humanoid,
                    Root = v.HumanoidRootPart
                })
            end
        end
    end
    return MobsList
end

-- // Auto Farm Function
local function AutoFarm()
    spawn(function()
        while wait(FarmDelay) do
            if not Toggles.AutoFarm or not FarmRunning then continue end
            
            local char = LocalPlayer.Character
            if not char then continue end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then continue end
            
            -- Tìm quái gần nhất
            local nearestMob = nil
            local nearestDist = FarmRadius
            
            for _, mob in pairs(MobsList) do
                if mob.Root and mob.Root.Parent and mob.Humanoid and mob.Humanoid.Health > 0 then
                    local dist = (root.Position - mob.Root.Position).Magnitude
                    if dist < nearestDist then
                        nearestDist = dist
                        nearestMob = mob
                    end
                end
            end
            
            if nearestMob then
                -- Di chuyển đến quái
                root.CFrame = CFrame.new(nearestMob.Root.Position + Vector3.new(0, 3, 0))
                wait(0.1)
                
                -- Tấn công quái
                if SelectedWeapon then
                    local tool = char:FindFirstChild(SelectedWeapon.Name)
                    if tool then
                        tool:Activate()
                    end
                end
                
                -- Gom quái (loot)
                if FarmMode == "auto" then
                    for _, v in pairs(Workspace:GetDescendants()) do
                        if v:IsA("Model") and v.Name:lower():find("drop") or v.Name:lower():find("loot") or v.Name:lower():find("item") then
                            local lootRoot = v:FindFirstChild("HumanoidRootPart") or v.PrimaryPart
                            if lootRoot and (root.Position - lootRoot.Position).Magnitude < 20 then
                                root.CFrame = CFrame.new(lootRoot.Position + Vector3.new(0, 2, 0))
                                wait(0.2)
                            end
                        end
                    end
                end
            else
                -- Không có quái, tìm quái khác
                ScanMobs()
                if #MobsList == 0 then
                    wait(2)
                end
            end
        end
    end)
end

-- // CREATE ESP WITH DISTANCE
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
    distLabel.Text = "0" .. CurrentLang.distance
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

-- // UPDATE DISTANCE LOOP
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
                        local distText = distM .. CurrentLang.distance
                        
                        local color
                        if distM < 50 then
                            color = Color3.fromRGB(0, 255, 0)
                        elseif distM < 150 then
                            color = Color3.fromRGB(255, 255, 0)
                        else
                            color = Color3.fromRGB(255, 100, 0)
                        }
                        
                        if data.DistLabel then
                            data.DistLabel.Text = distText
                            data.DistLabel.TextColor3 = color
                        end
                    end
                else
                    data.Active = false
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

-- // ESP LOOP
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

-- // FLY SYSTEM - Press Jump to Fly
local function FlySystem()
    UserInputService.JumpRequest:Connect(function()
        if Toggles.Fly then
            local char = LocalPlayer.Character
            if not char then return end
            local rootPart = char:FindFirstChild("HumanoidRootPart")
            local humanoid = char:FindFirstChild("Humanoid")
            if not rootPart or not humanoid then return end
            
            IsFlying = not IsFlying
            
            if IsFlying then
                BodyVelocity = Instance.new("BodyVelocity")
                BodyVelocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
                BodyVelocity.Parent = rootPart
                humanoid.PlatformStand = true
                
                -- Tạo hiệu ứng bay
                local effect = Instance.new("Part")
                effect.Size = Vector3.new(1, 1, 1)
                effect.Position = rootPart.Position
                effect.Anchored = true
                effect.CanCollide = false
                effect.BrickColor = BrickColor.new("Bright blue")
                effect.Material = Enum.Material.Neon
                effect.Transparency = 0.5
                effect.Parent = workspace
                TweenService:Create(effect, TweenInfo.new(0.5), {Transparency = 1, Size = Vector3.new(5, 5, 5)}):Play()
                game:GetService("Debris"):AddItem(effect, 0.5)
            else
                if BodyVelocity then BodyVelocity:Destroy() end
                BodyVelocity = nil
                humanoid.PlatformStand = false
            end
        end
    end)
    
    spawn(function()
        while wait() do
            if IsFlying and Toggles.Fly and BodyVelocity then
                local rootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not rootPart then
                    IsFlying = false
                    if BodyVelocity then BodyVelocity:Destroy() end
                    BodyVelocity = nil
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
                BodyVelocity.Velocity = moveDirection
            end
        end
    end)
end

-- // Build Map UI
local function BuildMapUI()
    for _, btn in pairs(MapButtons) do
        if btn and btn.Parent then
            btn:Destroy()
        end
    end
    MapButtons = {}
    
    -- Scan map points
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
    
    if #DetectedMapPoints > 50 then
        local newList = {}
        for i = 1, 50 do
            newList[i] = DetectedMapPoints[i]
        end
        DetectedMapPoints = newList
    end
    
    -- Tìm vị trí chèn
    local yOffset = 0
    for _, child in pairs(ScrollFrame:GetChildren()) do
        if child:IsA("TextButton") and child.Size.Y.Offset == 36 then
            yOffset = math.max(yOffset, child.Position.Y.Offset + 42)
        end
    end
    
    -- Map Title
    local mapLabel = Instance.new("TextLabel")
    mapLabel.Parent = ScrollFrame
    mapLabel.Size = UDim2.new(0.95, 0, 0, 28)
    mapLabel.Position = UDim2.new(0.025, 0, 0, yOffset)
    mapLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 55)
    mapLabel.Text = CurrentLang.map_title .. " (" .. #DetectedMapPoints .. " điểm)"
    mapLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
    mapLabel.TextScaled = true
    mapLabel.Font = Enum.Font.GothamBold
    mapLabel.BorderSizePixel = 0
    mapLabel.BackgroundTransparency = 0.2
    table.insert(MapButtons, mapLabel)
    yOffset = yOffset + 34
    
    -- Selected Map
    local selectedMapText = Instance.new("TextLabel")
    selectedMapText.Parent = ScrollFrame
    selectedMapText.Size = UDim2.new(0.7, 0, 0, 32)
    selectedMapText.Position = UDim2.new(0.025, 0, 0, yOffset)
    selectedMapText.BackgroundColor3 = Color3.fromRGB(20, 20, 45)
    selectedMapText.Text = CurrentLang.map_selected .. ": " .. SelectedMapName
    selectedMapText.TextColor3 = Color3.fromRGB(255, 255, 255)
    selectedMapText.TextScaled = true
    selectedMapText.Font = Enum.Font.Gotham
    selectedMapText.BorderSizePixel = 0
    selectedMapText.BackgroundTransparency = 0.1
    table.insert(MapButtons, selectedMapText)
    
    local teleportBtn = Instance.new("TextButton")
    teleportBtn.Parent = ScrollFrame
    teleportBtn.Size = UDim2.new(0.22, 0, 0, 32)
    teleportBtn.Position = UDim2.new(0.73, 0, 0, yOffset)
    teleportBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 200)
    teleportBtn.Text = CurrentLang.map_teleport
    teleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    teleportBtn.TextScaled = true
    teleportBtn.Font = Enum.Font.GothamBold
    teleportBtn.BorderSizePixel = 0
    
    teleportBtn.MouseButton1Click:Connect(function()
        if SelectedMapPoint then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = CFrame.new(SelectedMapPoint + Vector3.new(0, 5, 0))
                print("🚀 Teleported to: " .. SelectedMapName)
            end
        end
    end)
    table.insert(MapButtons, teleportBtn)
    yOffset = yOffset + 40
    
    local refreshBtn = Instance.new("TextButton")
    refreshBtn.Parent = ScrollFrame
    refreshBtn.Size = UDim2.new(0.45, 0, 0, 28)
    refreshBtn.Position = UDim2.new(0.025, 0, 0, yOffset)
    refreshBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
    refreshBtn.Text = CurrentLang.map_refresh
    refreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    refreshBtn.TextScaled = true
    refreshBtn.Font = Enum.Font.GothamBold
    refreshBtn.BorderSizePixel = 0
    refreshBtn.MouseButton1Click:Connect(function()
        BuildMapUI()
    end)
    table.insert(MapButtons, refreshBtn)
    
    local clearBtn = Instance.new("TextButton")
    clearBtn.Parent = ScrollFrame
    clearBtn.Size = UDim2.new(0.45, 0, 0, 28)
    clearBtn.Position = UDim2.new(0.525, 0, 0, yOffset)
    clearBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    clearBtn.Text = CurrentLang.map_clear
    clearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    clearBtn.TextScaled = true
    clearBtn.Font = Enum.Font.GothamBold
    clearBtn.BorderSizePixel = 0
    clearBtn.MouseButton1Click:Connect(function()
        SelectedMapPoint = nil
        SelectedMapName = CurrentLang.map_none
        selectedMapText.Text = CurrentLang.map_selected .. ": " .. CurrentLang.map_none
    end)
    table.insert(MapButtons, clearBtn)
    yOffset = yOffset + 36
    
    -- Map buttons
    local mapYOffset = yOffset
    local col = 1
    local row = 0
    
    for i, mapData in ipairs(DetectedMapPoints) do
        local mapBtn = Instance.new("TextButton")
        mapBtn.Parent = ScrollFrame
        
        local xPos = (col == 1) and 0.025 or 0.525
        local yPos = mapYOffset + row * 34
        
        mapBtn.Size = UDim2.new(0.45, 0, 0, 30)
        mapBtn.Position = UDim2.new(xPos, 0, 0, yPos)
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
            selectedMapText.Text = CurrentLang.map_selected .. ": " .. mapData.Name
            for _, btn in pairs(MapButtons) do
                if btn:IsA("TextButton") and btn.Text:find("✅") then
                    btn.Text = btn.Text:gsub(" ✅", "")
                    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
                end
            end
            mapBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
            mapBtn.Text = mapData.Name .. " ✅"
        end)
        
        table.insert(MapButtons, mapBtn)
        
        if col == 1 then
            col = 2
        else
            col = 1
            row = row + 1
        end
    end
    
    local totalRows = math.ceil(#DetectedMapPoints / 2)
    local finalY = yOffset + totalRows * 34 + 60
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, finalY)
end

-- // Create UI - New Beautiful Design
local function CreateUI()
    ScreenGui.Parent = LocalPlayer.PlayerGui
    ScreenGui.Name = "MVHack"
    ScreenGui.ResetOnSpawn = false

    MainFrame.Parent = ScreenGui
    MainFrame.Size = UDim2.new(0, 480, 0, 650)
    MainFrame.Position = UDim2.new(0.5, -240, 0.5, -325)
    MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 25)
    MainFrame.BackgroundTransparency = 0.05
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Visible = false
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true

    -- Main Frame Corner
    local mainCorner = Instance.new("UICorner")
    mainCorner.Parent = MainFrame
    mainCorner.CornerRadius = UDim.new(0, 12)

    -- Title Bar with Gradient
    local titleBar = Instance.new("Frame")
    titleBar.Parent = MainFrame
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 55)
    titleBar.BorderSizePixel = 0
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.Parent = titleBar
    titleCorner.CornerRadius = UDim.new(0, 12)

    Title.Parent = titleBar
    Title.Size = UDim2.new(1, -60, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = CurrentLang.title
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextScaled = true
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- Close Button
    CloseBtn.Parent = titleBar
    CloseBtn.Size = UDim2.new(0, 35, 0, 35)
    CloseBtn.Position = UDim2.new(1, -42, 0, 7)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.TextScaled = true
    CloseBtn.BorderSizePixel = 0
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.Parent = CloseBtn
    closeCorner.CornerRadius = UDim.new(0, 6)
    
    CloseBtn.MouseButton1Click:Connect(function()
        MenuOpen = false
        MainFrame.Visible = false
    end)

    -- Toggle Button (Menu Button)
    ToggleBtn.Parent = ScreenGui
    ToggleBtn.Size = UDim2.new(0, 60, 0, 60)
    ToggleBtn.Position = UDim2.new(0, 15, 0.5, -30)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 45)
    ToggleBtn.Text = "MV"
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.TextScaled = true
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.BorderSizePixel = 0
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.Parent = ToggleBtn
    toggleCorner.CornerRadius = UDim.new(1, 0)
    
    -- Toggle Glow
    local toggleGlow = Instance.new("ImageLabel")
    toggleGlow.Parent = ToggleBtn
    toggleGlow.Size = UDim2.new(1.2, 0, 1.2, 0)
    toggleGlow.Position = UDim2.new(-0.1, 0, -0.1, 0)
    toggleGlow.BackgroundTransparency = 1
    toggleGlow.Image = "rbxassetid://6023420974"
    toggleGlow.ImageColor3 = Color3.fromRGB(100, 100, 255)
    toggleGlow.ImageTransparency = 0.5

    ToggleBtn.MouseButton1Click:Connect(function()
        MenuOpen = not MenuOpen
        MainFrame.Visible = MenuOpen
        if MenuOpen then
            ScanWeapons()
            ScanMobs()
            BuildMapUI()
        end
    end)

    -- Scroll Frame
    ScrollFrame.Parent = MainFrame
    ScrollFrame.Size = UDim2.new(1, -20, 1, -65)
    ScrollFrame.Position = UDim2.new(0, 10, 0, 55)
    ScrollFrame.BackgroundTransparency = 1
    ScrollFrame.BorderSizePixel = 0
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollFrame.ScrollBarThickness = 4
    ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 150)

    UIList.Parent = ScrollFrame
    UIList.SortOrder = Enum.SortOrder.LayoutOrder
    UIList.Padding = UDim.new(0, 4)

    -- Build All Sections
    BuildToggles()
    BuildWeaponSection()
    BuildMobSection()
    BuildAutoFarmSection()
    BuildAdminSection()
    BuildSettingsSection()
    
    -- Update Canvas
    updateCanvas()
end

-- // Build Toggles Section
function BuildToggles()
    local yOffset = 0
    
    -- Toggle Grid
    local toggleGrid = Instance.new("Frame")
    toggleGrid.Parent = ScrollFrame
    toggleGrid.Size = UDim2.new(1, 0, 0, 0)
    toggleGrid.BackgroundTransparency = 1
    toggleGrid.LayoutOrder = 0
    
    local gridLayout = Instance.new("UIGridLayout")
    gridLayout.Parent = toggleGrid
    gridLayout.CellSize = UDim2.new(0, 220, 0, 36)
    gridLayout.CellPadding = UDim2.new(0, 8, 0, 4)
    
    local toggleList = {
        {CurrentLang.toggle_fixlag, "FixLag"},
        {CurrentLang.toggle_superjump, "SuperJump"},
        {CurrentLang.toggle_fly, "Fly"},
        {CurrentLang.toggle_noclip, "Noclip"},
        {CurrentLang.toggle_espplayers, "ESPPlayers"},
        {CurrentLang.toggle_espmobs, "ESPMobs"},
        {CurrentLang.toggle_espfruits, "ESPFruits"},
        {CurrentLang.toggle_ghost, "Ghost"},
        {CurrentLang.toggle_nightvision, "NightVision"},
        {CurrentLang.toggle_autofarm, "AutoFarm"}
    }

    for _, item in ipairs(toggleList) do
        local label = item[1]
        local key = item[2]
        local btn = Instance.new("TextButton")
        btn.Parent = toggleGrid
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 55)
        btn.Text = label .. " [OFF]"
        btn.TextColor3 = Color3.fromRGB(220, 220, 220)
        btn.TextScaled = true
        btn.Font = Enum.Font.Gotham
        btn.BorderSizePixel = 0

        local corner = Instance.new("UICorner")
        corner.Parent = btn
        corner.CornerRadius = UDim.new(0, 6)
        
        -- Hover effect
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 75)}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Toggles[key] and Color3.fromRGB(0, 160, 0) or Color3.fromRGB(30, 30, 55)}):Play()
        end)

        btn.MouseButton1Click:Connect(function()
            Toggles[key] = not Toggles[key]
            btn.Text = label .. (Toggles[key] and " [ON]" or " [OFF]")
            btn.BackgroundColor3 = Toggles[key] and Color3.fromRGB(0, 160, 0) or Color3.fromRGB(30, 30, 55)
            
            if key == "AutoFarm" then
                FarmRunning = Toggles.AutoFarm
                if FarmRunning then
                    AutoFarm()
                end
            end
        end)
    end
    
    toggleGrid.Size = UDim2.new(1, 0, 0, math.ceil(#toggleList / 2) * 40 + 10)
end

-- // Build Weapon Section
function BuildWeaponSection()
    local section = Instance.new("Frame")
    section.Parent = ScrollFrame
    section.Size = UDim2.new(1, 0, 0, 0)
    section.BackgroundTransparency = 1
    section.LayoutOrder = 1
    
    local title = Instance.new("TextLabel")
    title.Parent = section
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundColor3 = Color3.fromRGB(25, 25, 50)
    title.Text = CurrentLang.weapon_title
    title.TextColor3 = Color3.fromRGB(255, 200, 100)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.BorderSizePixel = 0
    
    local weaponGrid = Instance.new("Frame")
    weaponGrid.Parent = section
    weaponGrid.Size = UDim2.new(1, 0, 0, 0)
    weaponGrid.Position = UDim2.new(0, 0, 0, 35)
    weaponGrid.BackgroundTransparency = 1
    
    local gridLayout = Instance.new("UIGridLayout")
    gridLayout.Parent = weaponGrid
    gridLayout.CellSize = UDim2.new(0, 140, 0, 30)
    gridLayout.CellPadding = UDim2.new(0, 6, 0, 4)
    
    -- Refresh weapons
    ScanWeapons()
    
    local weaponButtons = {}
    for _, weapon in pairs(WeaponsList) do
        local btn = Instance.new("TextButton")
        btn.Parent = weaponGrid
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 60)
        btn.Text = weapon.Name
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.TextScaled = true
        btn.Font = Enum.Font.Gotham
        btn.BorderSizePixel = 0
        
        local corner = Instance.new("UICorner")
        corner.Parent = btn
        corner.CornerRadius = UDim.new(0, 4)
        
        btn.MouseButton1Click:Connect(function()
            SelectedWeapon = weapon
            for _, b in pairs(weaponButtons) do
                b.BackgroundColor3 = Color3.fromRGB(35, 35, 60)
                b.Text = b.Text:gsub(" ✅", "")
            end
            btn.BackgroundColor3 = Color3.fromRGB(0, 160, 0)
            btn.Text = weapon.Name .. " ✅"
        end)
        
        table.insert(weaponButtons, btn)
    end
    
    weaponGrid.Size = UDim2.new(1, 0, 0, math.ceil(#WeaponsList / 3) * 34 + 10)
    section.Size = UDim2.new(1, 0, 0, 35 + weaponGrid.Size.Y.Offset + 10)
end

-- // Build Mob Section
function BuildMobSection()
    local section = Instance.new("Frame")
    section.Parent = ScrollFrame
    section.Size = UDim2.new(1, 0, 0, 0)
    section.BackgroundTransparency = 1
    section.LayoutOrder = 2
    
    local title = Instance.new("TextLabel")
    title.Parent = section
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundColor3 = Color3.fromRGB(25, 25, 50)
    title.Text = CurrentLang.mob_title
    title.TextColor3 = Color3.fromRGB(255, 150, 100)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.BorderSizePixel = 0
    
    local mobGrid = Instance.new("Frame")
    mobGrid.Parent = section
    mobGrid.Size = UDim2.new(1, 0, 0, 0)
    mobGrid.Position = UDim2.new(0, 0, 0, 35)
    mobGrid.BackgroundTransparency = 1
    
    local gridLayout = Instance.new("UIGridLayout")
    gridLayout.Parent = mobGrid
    gridLayout.CellSize = UDim2.new(0, 140, 0, 30)
    gridLayout.CellPadding = UDim2.new(0, 6, 0, 4)
    
    -- Refresh mobs
    ScanMobs()
    
    local mobButtons = {}
    for _, mob in pairs(MobsList) do
        local btn = Instance.new("TextButton")
        btn.Parent = mobGrid
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 60)
        btn.Text = mob.Name
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.TextScaled = true
        btn.Font = Enum.Font.Gotham
        btn.BorderSizePixel = 0
        
        local corner = Instance.new("UICorner")
        corner.Parent = btn
        corner.CornerRadius = UDim.new(0, 4)
        
        btn.MouseButton1Click:Connect(function()
            SelectedMob = mob
            for _, b in pairs(mobButtons) do
                b.BackgroundColor3 = Color3.fromRGB(35, 35, 60)
                b.Text = b.Text:gsub(" ✅", "")
            end
            btn.BackgroundColor3 = Color3.fromRGB(0, 160, 0)
            btn.Text = mob.Name .. " ✅"
        end)
        
        table.insert(mobButtons, btn)
    end
    
    mobGrid.Size = UDim2.new(1, 0, 0, math.ceil(#MobsList / 3) * 34 + 10)
    section.Size = UDim2.new(1, 0, 0, 35 + mobGrid.Size.Y.Offset + 10)
end

-- // Build Auto Farm Section
function BuildAutoFarmSection()
    local section = Instance.new("Frame")
    section.Parent = ScrollFrame
    section.Size = UDim2.new(1, 0, 0, 0)
    section.BackgroundTransparency = 1
    section.LayoutOrder = 3
    
    local title = Instance.new("TextLabel")
    title.Parent = section
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundColor3 = Color3.fromRGB(25, 25, 50)
    title.Text = CurrentLang.auto_farm_title
    title.TextColor3 = Color3.fromRGB(100, 255, 150)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.BorderSizePixel = 0
    
    local content = Instance.new("Frame")
    content.Parent = section
    content.Size = UDim2.new(1, 0, 0, 100)
    content.Position = UDim2.new(0, 0, 0, 35)
    content.BackgroundTransparency = 1
    
    -- Farm Status
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Parent = content
    statusLabel.Size = UDim2.new(0.6, 0, 0, 25)
    statusLabel.Position = UDim2.new(0.02, 0, 0, 0)
    statusLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 45)
    statusLabel.Text = CurrentLang.farm_status .. ": " .. (FarmRunning and "🟢 Running" or "🔴 Stopped")
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    statusLabel.TextScaled = true
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.BorderSizePixel = 0
    
    -- Start/Stop Buttons
    local startBtn = Instance.new("TextButton")
    startBtn.Parent = content
    startBtn.Size = UDim2.new(0.18, 0, 0, 30)
    startBtn.Position = UDim2.new(0.63, 0, 0, 0)
    startBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
    startBtn.Text = CurrentLang.farm_start
    startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    startBtn.TextScaled = true
    startBtn.Font = Enum.Font.GothamBold
    startBtn.BorderSizePixel = 0
    
    local stopBtn = Instance.new("TextButton")
    stopBtn.Parent = content
    stopBtn.Size = UDim2.new(0.18, 0, 0, 30)
    stopBtn.Position = UDim2.new(0.82, 0, 0, 0)
    stopBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    stopBtn.Text = CurrentLang.farm_stop
    stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    stopBtn.TextScaled = true
    stopBtn.Font = Enum.Font.GothamBold
    stopBtn.BorderSizePixel = 0
    
    startBtn.MouseButton1Click:Connect(function()
        FarmRunning = true
        Toggles.AutoFarm = true
        statusLabel.Text = CurrentLang.farm_status .. ": 🟢 Running"
        AutoFarm()
    end)
    
    stopBtn.MouseButton1Click:Connect(function()
        FarmRunning = false
        Toggles.AutoFarm = false
        statusLabel.Text = CurrentLang.farm_status .. ": 🔴 Stopped"
    end)
    
    -- Farm Mode
    local modeLabel = Instance.new("TextLabel")
    modeLabel.Parent = content
    modeLabel.Size = UDim2.new(0.3, 0, 0, 25)
    modeLabel.Position = UDim2.new(0.02, 0, 0, 35)
    modeLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 45)
    modeLabel.Text = CurrentLang.farm_gathering .. ": " .. (FarmMode == "auto" and CurrentLang.farm_auto or CurrentLang.farm_manual)
    modeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    modeLabel.TextScaled = true
    modeLabel.Font = Enum.Font.Gotham
    modeLabel.BorderSizePixel = 0
    
    local modeBtn = Instance.new("TextButton")
    modeBtn.Parent = content
    modeBtn.Size = UDim2.new(0.25, 0, 0, 25)
    modeBtn.Position = UDim2.new(0.35, 0, 0, 35)
    modeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
    modeBtn.Text = FarmMode == "auto" and CurrentLang.farm_auto or CurrentLang.farm_manual
    modeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    modeBtn.TextScaled = true
    modeBtn.Font = Enum.Font.Gotham
    modeBtn.BorderSizePixel = 0
    
    modeBtn.MouseButton1Click:Connect(function()
        FarmMode = FarmMode == "auto" and "manual" or "auto"
        modeBtn.Text = FarmMode == "auto" and CurrentLang.farm_auto or CurrentLang.farm_manual
        modeLabel.Text = CurrentLang.farm_gathering .. ": " .. (FarmMode == "auto" and CurrentLang.farm_auto or CurrentLang.farm_manual)
    end)
    
    section.Size = UDim2.new(1, 0, 0, 140)
end

-- // Build Admin Section
function BuildAdminSection()
    local section = Instance.new("Frame")
    section.Parent = ScrollFrame
    section.Size = UDim2.new(1, 0, 0, 0)
    section.BackgroundTransparency = 1
    section.LayoutOrder = 4
    
    local title = Instance.new("TextLabel")
    title.Parent = section
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundColor3 = Color3.fromRGB(25, 25, 50)
    title.Text = CurrentLang.admin_title
    title.TextColor3 = Color3.fromRGB(255, 100, 100)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.BorderSizePixel = 0
    
    local content = Instance.new("Frame")
    content.Parent = section
    content.Size = UDim2.new(1, 0, 0, 120)
    content.Position = UDim2.new(0, 0, 0, 35)
    content.BackgroundTransparency = 1
    
    -- Admin Info
    local adminInfo = {
        {label = "👤 Tên:", value = "MV Creator"},
        {label = "📅 Ngày sinh:", value = "01/01/2000"},
        {label = "📝 Bio:", value = "Script Developer & Gamer"}
    }
    
    local y = 0
    for _, info in pairs(adminInfo) do
        local lbl = Instance.new("TextLabel")
        lbl.Parent = content
        lbl.Size = UDim2.new(0.3, 0, 0, 25)
        lbl.Position = UDim2.new(0.02, 0, 0, y)
        lbl.BackgroundTransparency = 1
        lbl.Text = info.label
        lbl.TextColor3 = Color3.fromRGB(255, 200, 100)
        lbl.TextScaled = true
        lbl.Font = Enum.Font.GothamBold
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        
        local val = Instance.new("TextLabel")
        val.Parent = content
        val.Size = UDim2.new(0.6, 0, 0, 25)
        val.Position = UDim2.new(0.35, 0, 0, y)
        val.BackgroundTransparency = 1
        val.Text = info.value
        val.TextColor3 = Color3.fromRGB(255, 255, 255)
        val.TextScaled = true
        val.Font = Enum.Font.Gotham
        val.TextXAlignment = Enum.TextXAlignment.Left
        
        y = y + 28
    end
    
    -- Date & Time
    local datetime = Instance.new("TextLabel")
    datetime.Parent = content
    datetime.Size = UDim2.new(0.6, 0, 0, 25)
    datetime.Position = UDim2.new(0.35, 0, 0, y)
    datetime.BackgroundTransparency = 1
    datetime.Text = os.date("%d/%m/%Y %H:%M:%S")
    datetime.TextColor3 = Color3.fromRGB(100, 200, 255)
    datetime.TextScaled = true
    datetime.Font = Enum.Font.Gotham
    
    -- Update time every second
    spawn(function()
        while wait(1) do
            datetime.Text = os.date("%d/%m/%Y %H:%M:%S")
        end
    end)
    
    section.Size = UDim2.new(1, 0, 0, 160)
end

-- // Build Settings Section
function BuildSettingsSection()
    local section = Instance.new("Frame")
    section.Parent = ScrollFrame
    section.Size = UDim2.new(1, 0, 0, 0)
    section.BackgroundTransparency = 1
    section.LayoutOrder = 5
    
    local title = Instance.new("TextLabel")
    title.Parent = section
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundColor3 = Color3.fromRGB(25, 25, 50)
    title.Text = CurrentLang.settings_title
    title.TextColor3 = Color3.fromRGB(200, 200, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.BorderSizePixel = 0
    
    local content = Instance.new("Frame")
    content.Parent = section
    content.Size = UDim2.new(1, 0, 0, 80)
    content.Position = UDim2.new(0, 0, 0, 35)
    content.BackgroundTransparency = 1
    
    -- Language
    local langLabel = Instance.new("TextLabel")
    langLabel.Parent = content
    langLabel.Size = UDim2.new(0.3, 0, 0, 30)
    langLabel.Position = UDim2.new(0.02, 0, 0, 0)
    langLabel.BackgroundTransparency = 1
    langLabel.Text = CurrentLang.language_title
    langLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    langLabel.TextScaled = true
    langLabel.Font = Enum.Font.GothamBold
    langLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local langGrid = Instance.new("Frame")
    langGrid.Parent = content
    langGrid.Size = UDim2.new(0.6, 0, 0, 30)
    langGrid.Position = UDim2.new(0.35, 0, 0, 0)
    langGrid.BackgroundTransparency = 1
    
    local gridLayout = Instance.new("UIGridLayout")
    gridLayout.Parent = langGrid
    gridLayout.CellSize = UDim2.new(0, 100, 0, 28)
    gridLayout.CellPadding = UDim2.new(0, 4, 0, 0)
    
    local langButtons = {}
    for langName, langData in pairs(Languages) do
        local btn = Instance.new("TextButton")
        btn.Parent = langGrid
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 60)
        btn.Text = langName
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.TextScaled = true
        btn.Font = Enum.Font.Gotham
        btn.BorderSizePixel = 0
        
        local corner = Instance.new("UICorner")
        corner.Parent = btn
        corner.CornerRadius = UDim.new(0, 4)
        
        if langData.code == LangCode then
            btn.BackgroundColor3 = Color3.fromRGB(0, 160, 0)
            btn.Text = langName .. " ✅"
        end
        
        btn.MouseButton1Click:Connect(function()
            CurrentLang = langData
            LangCode = langData.code
            
            -- Cập nhật lại UI
            for _, b in pairs(langButtons) do
                b.BackgroundColor3 = Color3.fromRGB(35, 35, 60)
                b.Text = b.Text:gsub(" ✅", "")
            end
            btn.BackgroundColor3 = Color3.fromRGB(0, 160, 0)
            btn.Text = langName .. " ✅"
            
            -- Refresh UI
            RefreshUI()
        end)
        
        table.insert(langButtons, btn)
    end
    
    section.Size = UDim2.new(1, 0, 0, 120)
end

-- // Refresh UI
function RefreshUI()
    -- Clear and rebuild
    for _, child in pairs(ScrollFrame:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") or child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    -- Rebuild all sections
    BuildToggles()
    BuildWeaponSection()
    BuildMobSection()
    BuildAutoFarmSection()
    BuildAdminSection()
    BuildSettingsSection()
    BuildMapUI()
    updateCanvas()
    
    -- Update Title
    Title.Text = CurrentLang.title
end

-- // Update Canvas Size
function updateCanvas()
    local totalHeight = 0
    for _, child in pairs(ScrollFrame:GetChildren()) do
        if child:IsA("Frame") then
            totalHeight = totalHeight + child.Size.Y.Offset + 6
        end
    end
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight + 50)
end

-- // Fix Lag
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

-- // Super Jump
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

-- // Noclip
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

-- // Ghost Mode
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

-- // Night Vision
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

-- // Anti-Idle
local function AntiIdle()
    spawn(function()
        while wait(60) do
            game:GetService("Players").LocalPlayer.Idled:Connect(function()
                game:GetService("VirtualUser"):ClickButton2(Vector2.new())
            end)
        end
    end)
end

-- // Speed Sliders
local function AddSliders()
    local section = Instance.new("Frame")
    section.Parent = ScrollFrame
    section.Size = UDim2.new(1, 0, 0, 0)
    section.BackgroundTransparency = 1
    section.LayoutOrder = 6
    
    -- Fly Speed
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Parent = section
    speedLabel.Size = UDim2.new(0.45, 0, 0, 25)
    speedLabel.Position = UDim2.new(0.02, 0, 0, 0)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = CurrentLang.fly_speed .. ": " .. FlySpeed
    speedLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    speedLabel.TextScaled = true
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local speedBtnFrame = Instance.new("Frame")
    speedBtnFrame.Parent = section
    speedBtnFrame.Size = UDim2.new(0.4, 0, 0, 25)
    speedBtnFrame.Position = UDim2.new(0.5, 0, 0, 0)
    speedBtnFrame.BackgroundTransparency = 1
    
    local speedDown = Instance.new("TextButton")
    speedDown.Parent = speedBtnFrame
    speedDown.Size = UDim2.new(0.3, 0, 1, 0)
    speedDown.Position = UDim2.new(0, 0, 0, 0)
    speedDown.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    speedDown.Text = "-"
    speedDown.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedDown.TextScaled = true
    speedDown.BorderSizePixel = 0
    
    local speedUp = Instance.new("TextButton")
    speedUp.Parent = speedBtnFrame
    speedUp.Size = UDim2.new(0.3, 0, 1, 0)
    speedUp.Position = UDim2.new(0.7, 0, 0, 0)
    speedUp.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
    speedUp.Text = "+"
    speedUp.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedUp.TextScaled = true
    speedUp.BorderSizePixel = 0
    
    speedDown.MouseButton1Click:Connect(function()
        FlySpeed = math.max(10, FlySpeed - 5)
        speedLabel.Text = CurrentLang.fly_speed .. ": " .. FlySpeed
    end)
    
    speedUp.MouseButton1Click:Connect(function()
        FlySpeed = FlySpeed + 5
        speedLabel.Text = CurrentLang.fly_speed .. ": " .. FlySpeed
    end)
    
    -- Jump Power
    local jumpLabel = Instance.new("TextLabel")
    jumpLabel.Parent = section
    jumpLabel.Size = UDim2.new(0.45, 0, 0, 25)
    jumpLabel.Position = UDim2.new(0.02, 0, 0, 30)
    jumpLabel.BackgroundTransparency = 1
    jumpLabel.Text = CurrentLang.jump_power .. ": " .. JumpPower
    jumpLabel.TextColor3 = Color3.fromRGB(200, 255, 200)
    jumpLabel.TextScaled = true
    jumpLabel.Font = Enum.Font.GothamBold
    jumpLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local jumpBtnFrame = Instance.new("Frame")
    jumpBtnFrame.Parent = section
    jumpBtnFrame.Size = UDim2.new(0.4, 0, 0, 25)
    jumpBtnFrame.Position = UDim2.new(0.5, 0, 0, 30)
    jumpBtnFrame.BackgroundTransparency = 1
    
    local jumpDown = Instance.new("TextButton")
    jumpDown.Parent = jumpBtnFrame
    jumpDown.Size = UDim2.new(0.3, 0, 1, 0)
    jumpDown.Position = UDim2.new(0, 0, 0, 0)
    jumpDown.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    jumpDown.Text = "-"
    jumpDown.TextColor3 = Color3.fromRGB(255, 255, 255)
    jumpDown.TextScaled = true
    jumpDown.BorderSizePixel = 0
    
    local jumpUp = Instance.new("TextButton")
    jumpUp.Parent = jumpBtnFrame
    jumpUp.Size = UDim2.new(0.3, 0, 1, 0)
    jumpUp.Position = UDim2.new(0.7, 0, 0, 0)
    jumpUp.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
    jumpUp.Text = "+"
    jumpUp.TextColor3 = Color3.fromRGB(255, 255, 255)
    jumpUp.TextScaled = true
    jumpUp.BorderSizePixel = 0
    
    jumpDown.MouseButton1Click:Connect(function()
        JumpPower = math.max(50, JumpPower - 50)
        jumpLabel.Text = CurrentLang.jump_power .. ": " .. JumpPower
    end)
    
    jumpUp.MouseButton1Click:Connect(function()
        JumpPower = JumpPower + 50
        jumpLabel.Text = CurrentLang.jump_power .. ": " .. JumpPower
    end)
    
    section.Size = UDim2.new(1, 0, 0, 65)
end

-- // Initialize everything
CreateUI()
AddSliders()
FixLag()
SuperJump()
FlySystem()
Noclip()
ESPLoop()
UpdateDistances()
GhostMode()
NightVision()
AntiIdle()

-- // Hotkeys
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- Menu toggle
    if input.KeyCode == Enum.KeyCode.M then
        MenuOpen = not MenuOpen
        MainFrame.Visible = MenuOpen
        if MenuOpen then
            ScanWeapons()
            ScanMobs()
            BuildMapUI()
        end
    end
    
    -- Ghost toggle
    if input.KeyCode == Enum.KeyCode.F1 then
        Toggles.Ghost = not Toggles.Ghost
    end
    
    -- Night Vision toggle
    if input.KeyCode == Enum.KeyCode.F2 then
        Toggles.NightVision = not Toggles.NightVision
    end
    
    -- Auto Farm toggle
    if input.KeyCode == Enum.KeyCode.F3 then
        Toggles.AutoFarm = not Toggles.AutoFarm
        FarmRunning = Toggles.AutoFarm
        if FarmRunning then
            AutoFarm()
        end
    end
end)

print("⚡ MV HACK v5.0 LOADED - Multi-Language, Auto Farm, Fly System")
print("📌 Hotkeys: M=Menu, F1=Ghost, F2=Night Vision, F3=Auto Farm")
