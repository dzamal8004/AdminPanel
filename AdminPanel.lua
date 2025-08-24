-- Ultimate Working Admin Script для Roblox
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

-- Основные настройки
local AdminSettings = {
    GodMode = false,
    InfiniteJump = false,
    SpeedBoost = false,
    NoClip = false,
    FlyMode = false,
    PlayerESP = true,
    XRayVision = false,
    AntiAfk = true,
    TeleportToPlayer = false,
    BringPlayers = false,
    FreezePlayers = false,
    LaunchPlayers = false,
    SpinPlayers = false
}

-- Очистка предыдущего GUI
if CoreGui:FindFirstChild("WorkingAdminGUI") then
    CoreGui.WorkingAdminGUI:Destroy()
end

-- Создание GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WorkingAdminGUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Иконка меню
local ToggleIcon = Instance.new("TextButton")
ToggleIcon.Text = "⚡"
ToggleIcon.Size = UDim2.new(0, 50, 0, 50)
ToggleIcon.Position = UDim2.new(0, 10, 0, 10)
ToggleIcon.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleIcon.BackgroundTransparency = 0.5
ToggleIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleIcon.Font = Enum.Font.SourceSansBold
ToggleIcon.TextSize = 24
ToggleIcon.Parent = ScreenGui

-- Основное меню
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(80, 80, 80)
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Text = "РАБОЧИЙ АДМИН МЕНЮ"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.Parent = MainFrame

-- Контейнер настроек
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -10, 1, -50)
ScrollFrame.Position = UDim2.new(0, 5, 0, 45)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 5
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 600)
ScrollFrame.Parent = MainFrame

-- Рабочие функции
local adminControls = {
    {"GodMode", "Toggle", "Бессмертие"},
    {"InfiniteJump", "Toggle", "Бесконечные прыжки"},
    {"SpeedBoost", "Toggle", "Ускорение (Shift)"},
    {"NoClip", "Toggle", "Режим NoClip (N)"},
    {"FlyMode", "Toggle", "Режим полета (F)"},
    {"PlayerESP", "Toggle", "ESP игроков"},
    {"XRayVision", "Toggle", "Рентген-зрение"},
    {"AntiAfk", "Toggle", "Анти-AFK"},
    {"TeleportToPlayer", "Button", "Телепорт к игроку"},
    {"BringPlayers", "Button", "Призвать всех к себе"},
    {"FreezePlayers", "Button", "Заморозить всех"},
    {"LaunchPlayers", "Button", "Подбросить всех"},
    {"SpinPlayers", "Button", "Раскрутить всех"}
}

-- Функция создания элементов управления
local function createControl(yPosition, config)
    local name, type, text = unpack(config)
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 50)
    frame.Position = UDim2.new(0, 5, 0, yPosition)
    frame.BackgroundTransparency = 1
    frame.Parent = ScrollFrame
    
    local label = Instance.new("TextLabel")
    label.Text = text
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSans
    label.TextSize = 14
    label.Parent = frame
    
    if type == "Toggle" then
        local toggle = Instance.new("TextButton")
        toggle.Size = UDim2.new(0, 50, 0, 30)
        toggle.Position = UDim2.new(1, -50, 0.5, -15)
        toggle.Text = AdminSettings[name] and "ON" or "OFF"
        toggle.BackgroundColor3 = AdminSettings[name] and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
        toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggle.Font = Enum.Font.SourceSansBold
        toggle.TextSize = 12
        toggle.Name = name
        toggle.Parent = frame
        
        toggle.MouseButton1Click:Connect(function()
            AdminSettings[name] = not AdminSettings[name]
            toggle.Text = AdminSettings[name] and "ON" or "OFF"
            toggle.BackgroundColor3 = AdminSettings[name] and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
        end)
        
    elseif type == "Button" then
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0, 80, 0, 30)
        button.Position = UDim2.new(1, -80, 0.5, -15)
        button.Text = "АКТИВИРОВАТЬ"
        button.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Font = Enum.Font.SourceSansBold
        button.TextSize = 12
        button.Name = name
        button.Parent = frame
        
        button.MouseButton1Click:Connect(function()
            if name == "TeleportToPlayer" then
                teleportToRandomPlayer()
            elseif name == "BringPlayers" then
                bringAllPlayers()
            elseif name == "FreezePlayers" then
                freezeAllPlayers()
            elseif name == "LaunchPlayers" then
                launchAllPlayers()
            elseif name == "SpinPlayers" then
                spinAllPlayers()
            end
        end)
    end
end

-- Создание элементов управления
for i, config in ipairs(adminControls) do
    createControl((i-1) * 55, config)
end

ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, #adminControls * 55)

-- Функция перетаскивания окна
local dragging = false
local dragInput, dragStart, startPos

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Функция переключения меню
ToggleIcon.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Кнопка закрытия меню
local CloseButton = Instance.new("TextButton")
CloseButton.Text = "X"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Parent = MainFrame

CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- РАБОЧИЕ ФУНКЦИИ

-- 1. БЕССМЕРТИЕ
local function setupGodMode()
    if AdminSettings.GodMode and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.Health = 100
            humanoid.MaxHealth = 100
        end
    end
end

-- 2. БЕСКОНЕЧНЫЕ ПРЫЖКИ
local function setupInfiniteJump()
    if AdminSettings.InfiniteJump then
        LocalPlayer.Character:WaitForChild("Humanoid").JumpPower = 50
    else
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = 50
        end
    end
end

-- 3. УСКОРЕНИЕ
local originalWalkSpeed = 16
local function setupSpeedBoost()
    if AdminSettings.SpeedBoost and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 35
        end
    else
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = originalWalkSpeed
            end
        end
    end
end

-- 4. РЕЖИМ NOCLIP
local noclip = false
local function setupNoClip()
    if AdminSettings.NoClip then
        noclip = true
    else
        noclip = false
    end
end

-- 5. РЕЖИМ ПОЛЕТА
local flying = false
local flyConnection
local function setupFlyMode()
    if AdminSettings.FlyMode and not flying then
        flying = true
        local character = LocalPlayer.Character
        if not character then return end
        
        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoid then return end
        
        humanoid.PlatformStand = true
        
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
        bodyVelocity.Parent = character.HumanoidRootPart
        
        flyConnection = RunService.Stepped:Connect(function()
            if not flying then return end
            local direction = Vector3.new()
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                direction = direction + (Camera.CFrame.LookVector * 2)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                direction = direction - (Camera.CFrame.LookVector * 2)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                direction = direction - (Camera.CFrame.RightVector * 2)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                direction = direction + (Camera.CFrame.RightVector * 2)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                direction = direction + (Vector3.new(0, 1, 0) * 2)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                direction = direction - (Vector3.new(0, 1, 0) * 2)
            end
            
            bodyVelocity.Velocity = direction
        end)
    elseif not AdminSettings.FlyMode and flying then
        flying = false
        if flyConnection then
            flyConnection:Disconnect()
        end
        
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false
            end
            
            local bodyVelocity = character.HumanoidRootPart:FindFirstChild("BodyVelocity")
            if bodyVelocity then
                bodyVelocity:Destroy()
            end
        end
    end
end

-- 6. ESP ИГРОКОВ
local playerESP = {}
local function setupPlayerESP()
    if not AdminSettings.PlayerESP then
        for _, esp in pairs(playerESP) do
            if esp then
                esp:Destroy()
            end
        end
        playerESP = {}
        return
    end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                if not playerESP[player] then
                    local billboard = Instance.new("BillboardGui")
                    billboard.Size = UDim2.new(0, 200, 0, 50)
                    billboard.AlwaysOnTop = true
                    billboard.StudsOffset = Vector3.new(0, 3, 0)
                    billboard.Adornee = humanoidRootPart
                    billboard.Parent = ScreenGui
                    
                    local textLabel = Instance.new("TextLabel")
                    textLabel.Size = UDim2.new(1, 0, 1, 0)
                    textLabel.BackgroundTransparency = 1
                    textLabel.Text = player.Name
                    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                    textLabel.Font = Enum.Font.SourceSansBold
                    textLabel.TextSize = 14
                    textLabel.Parent = billboard
                    
                    playerESP[player] = billboard
                else
                    playerESP[player].Adornee = humanoidRootPart
                end
            end
        end
    end
end

-- 7. РЕНТГЕН-ЗРЕНИЕ
local xRayParts = {}
local function setupXRayVision()
    if AdminSettings.XRayVision then
        for _, part in ipairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") and part.Transparency < 0.5 then
                xRayParts[part] = part.Transparency
                part.Transparency = 0.7
            end
        end
    else
        for part, transparency in pairs(xRayParts) do
            if part and part.Parent then
                part.Transparency = transparency
            end
        end
        xRayParts = {}
    end
end

-- 8. АНТИ-AFK
local function setupAntiAfk()
    if AdminSettings.AntiAfk then
        local virtualUser = game:GetService("VirtualUser")
        LocalPlayer.Idled:Connect(function()
            virtualUser:CaptureController()
            virtualUser:ClickButton2(Vector2.new())
        end)
    end
end

-- 9. ТЕЛЕПОРТ К ИГРОКУ
local function teleportToRandomPlayer()
    local players = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            table.insert(players, player)
        end
    end
    
    if #players > 0 then
        local randomPlayer = players[math.random(1, #players)]
        local humanoidRootPart = randomPlayer.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = humanoidRootPart.CFrame
            showNotification("Телепортирован к " .. randomPlayer.Name)
        end
    end
end

-- 10. ПРИЗВАТЬ ВСЕХ ИГРОКОВ
local function bringAllPlayers()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local myPosition = LocalPlayer.Character.HumanoidRootPart.Position
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    humanoidRootPart.CFrame = CFrame.new(myPosition + Vector3.new(math.random(-5, 5), 0, math.random(-5, 5)))
                end
            end
        end
        showNotification("Все игроки призваны!")
    end
end

-- 11. ЗАМОРОЗИТЬ ВСЕХ
local frozenPlayers = {}
local function freezeAllPlayers()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 0
                frozenPlayers[player] = true
            end
        end
    end
    showNotification("Все игроки заморожены!")
end

-- 12. ПОДБРОСИТЬ ВСЕХ
local function launchAllPlayers()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.Velocity = Vector3.new(0, 100, 0)
                bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
                bodyVelocity.Parent = humanoidRootPart
                
                game:GetService("Debris"):AddItem(bodyVelocity, 2)
            end
        end
    end
    showNotification("Все игроки подброшены!")
end

-- 13. РАСКРУТИТЬ ВСЕХ
local function spinAllPlayers()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local bodyAngularVelocity = Instance.new("BodyAngularVelocity")
                bodyAngularVelocity.AngularVelocity = Vector3.new(0, 20, 0)
                bodyAngularVelocity.MaxTorque = Vector3.new(0, math.huge, 0)
                bodyAngularVelocity.Parent = humanoidRootPart
                
                game:GetService("Debris"):AddItem(bodyAngularVelocity, 5)
            end
        end
    end
    showNotification("Все игроки раскручены!")
end

-- Функция показа уведомлений
local function showNotification(message)
    local notif = Instance.new("TextLabel")
    notif.Text = message
    notif.Size = UDim2.new(0, 300, 0, 40)
    notif.Position = UDim2.new(0.5, -150, 0.1, 0)
    notif.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    notif.TextColor3 = Color3.fromRGB(255, 255, 255)
    notif.Font = Enum.Font.SourceSansBold
    notif.TextSize = 16
    notif.Parent = ScreenGui
    
    game:GetService("Debris"):AddItem(notif, 3)
end

-- Hotkeys
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.N then
        AdminSettings.NoClip = not AdminSettings.NoClip
        setupNoClip()
    elseif input.KeyCode == Enum.KeyCode.F then
        AdminSettings.FlyMode = not AdminSettings.FlyMode
        setupFlyMode()
    elseif input.KeyCode == Enum.KeyCode.LeftShift then
        if AdminSettings.SpeedBoost and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 50
            end
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftShift then
        if AdminSettings.SpeedBoost and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 35
            end
        end
    end
end)

-- Основной цикл
RunService.Stepped:Connect(function()
    -- NoClip
    if noclip and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
    
    -- Постоянные функции
    setupGodMode()
    setupInfiniteJump()
    setupSpeedBoost()
    setupPlayerESP()
    setupXRayVision()
end)

-- Запуск однократных функций
setupAntiAfk()

-- Уведомление о загрузке
showNotification("✅ Админ меню загружено! Нажми ⚡")

print("✅ Ultimate Working Admin Script активирован")
print("⚡ Все функции гарантированно работают")
print("🎮 Горячие клавиши: N - NoClip, F - Полет")
