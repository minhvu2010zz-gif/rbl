-- MV Hub | Axiom Build v4.1
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

-- // UI Variables
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton")
local ToggleBtn = Instance.new("TextButton")
local ResizeHandle = Instance.new("Frame")
local ResizeCorner = Instance.new("ImageLabel")
local ScrollFrame = Instance.new("ScrollingFrame")
local UIList = Instance.new("UIListLayout")

-- // Resize Variables
local MinSize = 400
local MaxSize = 700
local IsResizing = false
local ResizeStartPos
local ResizeStartSize

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
    NightVision = false
}

-- // Fly Variables
local FlySpeed = 50
local JumpPower = 250
local GhostStealth = 0.3

-- // Menu State
local MenuOpen = false

-- // Teleport Variables
local SelectedMapPoint = nil
local SelectedMapName = "Chưa chọn"
local DetectedMapPoints = {}
local MapButtons = {}

-- // ESP Distance tracking
local ESPObjects = {}
local ESPUpdateRate = 0.3  -- Cập nhật khoảng cách mỗi 0.3 giây

-- // Scan Map Function
local function ScanMap()
    DetectedMapPoints = {}
    MapButtons = {}
    
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
    
    print("🔍 Đã quét được " .. #DetectedMapPoints .. " điểm map")
    return DetectedMapPoints
end

-- // CREATE ESP WITH DISTANCE
local function CreateESP(object, color, text, objectType)
    if not object or not object:IsA("BasePart") then return end
    
    -- Xóa ESP cũ
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

    -- Tên
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

    -- Khoảng cách (Distance)
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

    -- Lưu vào table để cập nhật khoảng cách
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
                        local distText = distM .. "m"
                        
                        -- Đổi màu theo khoảng cách
                        local color
                        if distM < 50 then
                            color = Color3.fromRGB(0, 255, 0)      -- Xanh lá (gần)
                        elseif distM < 150 then
                            color = Color3.fromRGB(255, 255, 0)    -- Vàng (trung bình)
                        else
                            color = Color3.fromRGB(255, 100, 0)    -- Cam (xa)
                        end
                        
                        if data.DistLabel then
                            data.DistLabel.Text = distText
                            data.DistLabel.TextColor3 = color
                        end
                    end
                else
                    -- Xóa khỏi table nếu object đã bị xóa
                    data.Active = false
                end
            end

            -- Dọn dẹp các mục không còn active
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

-- // ESP LOOP (tạo mới ESP)
local function ESPLoop()
    spawn(function()
        while wait(0.5) do
            -- PLAYER ESP
            if Toggles.ESPPlayers then
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local root = player.Character.HumanoidRootPart
                        -- Kiểm tra xem đã có ESP chưa
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

            -- MOB ESP
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

            -- FRUIT ESP
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

            -- Xóa ESP của những object không còn tồn tại hoặc toggle tắt
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

-- // Build Map Selection UI
local function BuildMapUI()
    for _, btn in pairs(MapButtons) do
        if btn and btn.Parent then
            btn:Destroy()
        end
    end
    MapButtons = {}
    
    ScanMap()
    
    local insertPosition = nil
    local yOffset = 0
    
    for _, child in pairs(ScrollFrame:GetChildren()) do
        if child:IsA("Frame") and child.Size.Y.Offset == 2 then
            insertPosition = child
            break
        end
    end
    
    if not insertPosition then
        local sep = Instance.new("Frame")
        sep.Parent = ScrollFrame
        sep.Size = UDim2.new(0.95, 0, 0, 2)
        sep.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
        sep.BorderSizePixel = 0
        insertPosition = sep
    end
    
    local toggleCount = 0
    for _, child in pairs(ScrollFrame:GetChildren()) do
        if child:IsA("TextButton") and (child.Text:find("OFF") or child.Text:find("ON")) then
            toggleCount = toggleCount + 1
        end
    end
    
    yOffset = toggleCount * 42 + 20
    
    local mapLabel = Instance.new("TextLabel")
    mapLabel.Parent = ScrollFrame
    mapLabel.Size = UDim2.new(0.95, 0, 0, 28)
    mapLabel.Position = UDim2.new(0.025, 0, 0, yOffset)
    mapLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 55)
    mapLabel.Text = "🗺️ MAP SERVER (" .. #DetectedMapPoints .. " điểm)"
    mapLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
    mapLabel.TextScaled = true
    mapLabel.Font = Enum.Font.GothamBold
    mapLabel.BorderSizePixel = 0
    mapLabel.BackgroundTransparency = 0.2
    table.insert(MapButtons, mapLabel)
    yOffset = yOffset + 34
    
    local selectedMapText = Instance.new("TextLabel")
    selectedMapText.Parent = ScrollFrame
    selectedMapText.Size = UDim2.new(0.7, 0, 0, 32)
    selectedMapText.Position = UDim2.new(0.025, 0, 0, yOffset)
    selectedMapText.BackgroundColor3 = Color3.fromRGB(20, 20, 45)
    selectedMapText.Text = "📌 " .. SelectedMapName
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
    teleportBtn.Text = "🚀 Dịch Chuyển"
    teleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    teleportBtn.TextScaled = true
    teleportBtn.Font = Enum.Font.GothamBold
    teleportBtn.BorderSizePixel = 0
    
    teleportBtn.MouseButton1Click:Connect(function()
        if SelectedMapPoint then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local oldPos = char.HumanoidRootPart.Position
                char.HumanoidRootPart.CFrame = CFrame.new(SelectedMapPoint + Vector3.new(0, 5, 0))
                
                local bp = Instance.new("Part")
                bp.Size = Vector3.new(3, 3, 3)
                bp.Position = oldPos
                bp.Anchored = true
                bp.CanCollide = false
                bp.BrickColor = BrickColor.new("Bright blue")
                bp.Material = Enum.Material.Neon
                bp.Parent = workspace
                TweenService:Create(bp, TweenInfo.new(0.5), {Size = Vector3.new(30, 30, 30), Transparency = 1}):Play()
                game:GetService("Debris"):AddItem(bp, 0.5)
                
                local bp2 = Instance.new("Part")
                bp2.Size = Vector3.new(3, 3, 3)
                bp2.Position = SelectedMapPoint
                bp2.Anchored = true
                bp2.CanCollide = false
                bp2.BrickColor = BrickColor.new("Bright green")
                bp2.Material = Enum.Material.Neon
                bp2.Parent = workspace
                TweenService:Create(bp2, TweenInfo.new(0.5), {Size = Vector3.new(30, 30, 30), Transparency = 1}):Play()
                game:GetService("Debris"):AddItem(bp2, 0.5)
                
                print("🚀 Teleported to: " .. SelectedMapName)
            end
        else
            print("⚠️ Chưa chọn map!")
        end
    end)
    table.insert(MapButtons, teleportBtn)
    yOffset = yOffset + 40
    
    local refreshBtn = Instance.new("TextButton")
    refreshBtn.Parent = ScrollFrame
    refreshBtn.Size = UDim2.new(0.45, 0, 0, 28)
    refreshBtn.Position = UDim2.new(0.025, 0, 0, yOffset)
    refreshBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
    refreshBtn.Text = "🔄 Quét Lại Map"
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
    clearBtn.Text = "🧹 Bỏ Chọn"
    clearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    clearBtn.TextScaled = true
    clearBtn.Font = Enum.Font.GothamBold
    clearBtn.BorderSizePixel = 0
    
    clearBtn.MouseButton1Click:Connect(function()
        SelectedMapPoint = nil
        SelectedMapName = "Chưa chọn"
        selectedMapText.Text = "📌 Chưa chọn"
        for _, btn in pairs(MapButtons) do
            if btn:IsA("TextButton") and btn.Text:find("✅") then
                btn.Text = btn.Text:gsub(" ✅", "")
                btn.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
            end
        end
    end)
    table.insert(MapButtons, clearBtn)
    yOffset = yOffset + 36
    
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
            selectedMapText.Text = "📌 " .. mapData.Name
            
            for _, btn in pairs(MapButtons) do
                if btn:IsA("TextButton") and btn.Text:find("✅") then
                    btn.Text = btn.Text:gsub(" ✅", "")
                    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
                end
            end
            mapBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
            mapBtn.Text = mapData.Name .. " ✅"
            
            print("📍 Đã chọn: " .. mapData.Name .. " tại " .. tostring(mapData.Position))
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

-- // Create UI
local function CreateUI()
    ScreenGui.Parent = LocalPlayer.PlayerGui
    ScreenGui.Name = "MVHack"
    ScreenGui.ResetOnSpawn = false

    MainFrame.Parent = ScreenGui
    MainFrame.Size = UDim2.new(0, 420, 0, 580)
    MainFrame.Position = UDim2.new(0.5, -210, 0.5, -290)
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    MainFrame.BackgroundTransparency = 0.05
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Visible = false
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true

    local blur = Instance.new("BlurEffect")
    blur.Parent = MainFrame
    blur.Size = 10

    Title.Parent = MainFrame
    Title.Size = UDim2.new(1, 0, 0, 45)
    Title.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
    Title.Text = "⚡ MV HACK v4.1 - ESP Distance"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextScaled = true
    Title.Font = Enum.Font.GothamBold
    Title.BorderSizePixel = 0

    CloseBtn.Parent = MainFrame
    CloseBtn.Size = UDim2.new(0, 35, 0, 35)
    CloseBtn.Position = UDim2.new(1, -42, 0, 5)
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

    ResizeHandle.Parent = MainFrame
    ResizeHandle.Size = UDim2.new(0, 25, 0, 25)
    ResizeHandle.Position = UDim2.new(1, -25, 1, -25)
    ResizeHandle.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
    ResizeHandle.BackgroundTransparency = 0.5
    ResizeHandle.ZIndex = 10

    ResizeCorner.Parent = ResizeHandle
    ResizeCorner.Size = UDim2.new(1, 0, 1, 0)
    ResizeCorner.BackgroundTransparency = 1
    ResizeCorner.Image = "rbxassetid://6023420974"
    ResizeCorner.ImageColor3 = Color3.fromRGB(200, 200, 255)

    ResizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            IsResizing = true
            ResizeStartPos = input.Position
            ResizeStartSize = MainFrame.Size
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if IsResizing and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - ResizeStartPos
            local newWidth = math.clamp(ResizeStartSize.X.Offset + delta.X, MinSize, MaxSize)
            local newHeight = math.clamp(ResizeStartSize.Y.Offset + delta.Y, MinSize, MaxSize)
            MainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            IsResizing = false
        end
    end)

    ToggleBtn.Parent = ScreenGui
    ToggleBtn.Size = UDim2.new(0, 65, 0, 65)
    ToggleBtn.Position = UDim2.new(0, 15, 0.5, -32)
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
        end
        TweenService:Create(ToggleBtn, TweenInfo.new(0.1), {BackgroundTransparency = 0.5}):Play()
        wait(0.1)
        TweenService:Create(ToggleBtn, TweenInfo.new(0.1), {BackgroundTransparency = 0.2}):Play()
    end)

    ScrollFrame.Parent = MainFrame
    ScrollFrame.Size = UDim2.new(1, -10, 1, -55)
    ScrollFrame.Position = UDim2.new(0, 5, 0, 50)
    ScrollFrame.BackgroundTransparency = 1
    ScrollFrame.BorderSizePixel = 0
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollFrame.ScrollBarThickness = 6
    ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 150)

    UIList.Parent = ScrollFrame
    UIList.SortOrder = Enum.SortOrder.LayoutOrder
    UIList.Padding = UDim.new(0, 6)

    local function BuildToggles()
        local toggleList = {
            {"🔧 Fix Lag", "FixLag"},
            {"🦘 Super Jump", "SuperJump"},
            {"✈️ Fly", "Fly"},
            {"👻 Noclip", "Noclip"},
            {"👤 ESP Players", "ESPPlayers"},
            {"👾 ESP Mobs", "ESPMobs"},
            {"🍎 ESP Fruits", "ESPFruits"},
            {"👻 Ghost (F1)", "Ghost"},
            {"🌙 Night Vision (F2)", "NightVision"}
        }

        for _, item in ipairs(toggleList) do
            local label = item[1]
            local key = item[2]
            local btn = Instance.new("TextButton")
            btn.Parent = ScrollFrame
            btn.Size = UDim2.new(0.95, 0, 0, 36)
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
            btn.Text = label .. " [OFF]"
            btn.TextColor3 = Color3.fromRGB(220, 220, 220)
            btn.TextScaled = true
            btn.Font = Enum.Font.Gotham
            btn.BorderSizePixel = 0
            btn.BackgroundTransparency = 0.2

            local corner = Instance.new("UICorner")
            corner.Parent = btn
            corner.CornerRadius = UDim.new(0, 6)

            btn.MouseButton1Click:Connect(function()
                Toggles[key] = not Toggles[key]
                btn.Text = label .. (Toggles[key] and " [ON]" or " [OFF]")
                btn.BackgroundColor3 = Toggles[key] and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(40, 40, 65)
            end)
        end

        local sep = Instance.new("Frame")
        sep.Parent = ScrollFrame
        sep.Size = UDim2.new(0.95, 0, 0, 2)
        sep.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
        sep.BorderSizePixel = 0
    end

    BuildToggles()
    BuildMapUI()
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

-- // Fly
local function Fly()
    local flyEnabled = false
    local bodyVelocity = nil

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

-- // Speed Sliders (thêm vào menu)
local function AddSliders()
    -- Tìm vị trí cuối cùng để chèn slider
    local yOffset = 0
    for _, child in pairs(ScrollFrame:GetChildren()) do
        if child:IsA("TextButton") then
            yOffset = math.max(yOffset, child.Position.Y.Offset + 42)
        end
    end
    
    -- Fly Speed
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Parent = ScrollFrame
    speedLabel.Size = UDim2.new(0.95, 0, 0, 22)
    speedLabel.Position = UDim2.new(0.025, 0, 0, yOffset)
    speedLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 55)
    speedLabel.Text = "✈️ FLY SPEED"
    speedLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    speedLabel.TextScaled = true
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.BorderSizePixel = 0
    yOffset = yOffset + 28

    local speedSlider = Instance.new("TextLabel")
    speedSlider.Parent = ScrollFrame
    speedSlider.Size = UDim2.new(0.6, 0, 0, 30)
    speedSlider.Position = UDim2.new(0.025, 0, 0, yOffset)
    speedSlider.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
    speedSlider.Text = "Speed: " .. FlySpeed
    speedSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedSlider.TextScaled = true
    speedSlider.Font = Enum.Font.Gotham
    speedSlider.BorderSizePixel = 0

    local speedUp = Instance.new("TextButton")
    speedUp.Parent = ScrollFrame
    speedUp.Size = UDim2.new(0.12, 0, 0, 30)
    speedUp.Position = UDim2.new(0.7, 0, 0, yOffset)
    speedUp.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
    speedUp.Text = "+"
    speedUp.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedUp.TextScaled = true
    speedUp.BorderSizePixel = 0
    speedUp.MouseButton1Click:Connect(function()
        FlySpeed = FlySpeed + 5
        speedSlider.Text = "Speed: " .. FlySpeed
    end)

    local speedDown = Instance.new("TextButton")
    speedDown.Parent = ScrollFrame
    speedDown.Size = UDim2.new(0.12, 0, 0, 30)
    speedDown.Position = UDim2.new(0.83, 0, 0, yOffset)
    speedDown.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    speedDown.Text = "-"
    speedDown.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedDown.TextScaled = true
    speedDown.BorderSizePixel = 0
    speedDown.MouseButton1Click:Connect(function()
        FlySpeed = math.max(10, FlySpeed - 5)
        speedSlider.Text = "Speed: " .. FlySpeed
    end)

    yOffset = yOffset + 38

    -- Jump Power
    local jumpLabel = Instance.new("TextLabel")
    jumpLabel.Parent = ScrollFrame
    jumpLabel.Size = UDim2.new(0.95, 0, 0, 22)
    jumpLabel.Position = UDim2.new(0.025, 0, 0, yOffset)
    jumpLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 55)
    jumpLabel.Text = "🦘 JUMP POWER"
    jumpLabel.TextColor3 = Color3.fromRGB(200, 255, 200)
    jumpLabel.TextScaled = true
    jumpLabel.Font = Enum.Font.GothamBold
    jumpLabel.BorderSizePixel = 0
    yOffset = yOffset + 28

    local jumpSlider = Instance.new("TextLabel")
    jumpSlider.Parent = ScrollFrame
    jumpSlider.Size = UDim2.new(0.6, 0, 0, 30)
    jumpSlider.Position = UDim2.new(0.025, 0, 0, yOffset)
    jumpSlider.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
    jumpSlider.Text = "Jump: " .. JumpPower
    jumpSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
    jumpSlider.TextScaled = true
    jumpSlider.Font = Enum.Font.Gotham
    jumpSlider.BorderSizePixel = 0

    local jumpUp = Instance.new("TextButton")
    jumpUp.Parent = ScrollFrame
    jumpUp.Size = UDim2.new(0.12, 0, 0, 30)
    jumpUp.Position = UDim2.new(0.7, 0, 0, yOffset)
    jumpUp.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
    jumpUp.Text = "+"
    jumpUp.TextColor3 = Color3.fromRGB(255, 255, 255)
    jumpUp.TextScaled = true
    jumpUp.BorderSizePixel = 0
    jumpUp.MouseButton1Click:Connect(function()
        JumpPower = JumpPower + 50
        jumpSlider.Text = "Jump: " .. JumpPower
    end)

    local jumpDown = Instance.new("TextButton")
    jumpDown.Parent = ScrollFrame
    jumpDown.Size = UDim2.new(0.12, 0, 0, 30)
    jumpDown.Position = UDim2.new(0.83, 0, 0, yOffset)
    jumpDown.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    jumpDown.Text = "-"
    jumpDown.TextColor3 = Color3.fromRGB(255, 255, 255)
    jumpDown.TextScaled = true
    jumpDown.BorderSizePixel = 0
    jumpDown.MouseButton1Click:Connect(function()
        JumpPower = math.max(50, JumpPower - 50)
        jumpSlider.Text = "Jump: " .. JumpPower
    end)

    yOffset = yOffset + 45
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset + 20)
end

-- // Khởi tạo
CreateUI()
AddSliders()
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
        MenuOpen = not MenuOpen
        MainFrame.Visible = MenuOpen
        if MenuOpen then
            BuildMapUI()
        end
    end
    if input.KeyCode == Enum.KeyCode.F1 then
        Toggles.Ghost = not Toggles.Ghost
    end
    if input.KeyCode == Enum.KeyCode.F2 then
        Toggles.NightVision = not Toggles.NightVision
    end
end)

print("⚡ MV HACK v4.1 LOADED - ESP có khoảng cách mét - Boss man, fuck yeah!")
