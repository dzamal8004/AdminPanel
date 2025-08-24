-- Ultimate Admin Script для Roblox
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

-- Конфигурация админ-функций
local AdminSettings = {
    GodMode = false, -- Бессмертие
    InfiniteAmmo = false, -- Бесконечные патроны
    InfiniteStamina = false, -- Бесконечная выносливость
    PlayerESP = true, -- ESP игроков
    PlayerTeleport = false, -- Телепорт к игрокам
    FreezePlayer = false, -- Заморозка игроков
    KickPlayer = false, -- Выгон игроков
    BringPlayer = false, -- Призыв игроков
    NoClip = false, -- Режим NoClip
    FlyMode = false, -- Режим полета
    SpeedBoost = false, -- Ускорение
    Invisibility = false, -- Невидимость
    XRayVision = false, -- Рентген-зрение
    AntiAfk = true, -- Анти-AFK
    AutoRespawn = true, -- Авто-респавн
    ChatLogger = false, -- Логгирование чата
    PlayerInfo = true -- Информация об игроках
}

-- Очистка предыдущего GUI
if CoreGui:FindFirstChild("AdminGUI") then
    CoreGui.AdminGUI:Destroy()
end

-- Создание GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdminGUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Иконка меню
local ToggleIcon = Instance.new("TextButton")
ToggleIcon.Text = "🛡️"
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
MainFrame.Size = UDim2.new(0, 350, 0, 500)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(80, 80, 80)
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Text = "Ultimate Admin Panel"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.Parent = MainFrame

-- Контейнер настроек
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -10, 1, -50)
ScrollFrame.Position = UDim2.new(0, 5, 0, 45)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 5
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 800)
ScrollFrame.Parent = MainFrame

-- Админ-функции
local adminControls = {
    {"GodMode", "Toggle", "Бессмертие"},
    {"InfiniteAmmo", "Toggle", "Бесконечные патроны"},
    {"InfiniteStamina", "Toggle", "Бесконечная выносливость"},
    {"PlayerESP", "Toggle", "ESP игроков"},
    {"PlayerTeleport", "Toggle", "Телепорт к игрокам"},
    {"FreezePlayer", "Toggle", "Заморозка игроков"},
    {"KickPlayer", "Toggle", "Выгон игроков"},
    {"BringPlayer", "Toggle", "Призыв игроков"},
    {"NoClip", "Toggle", "Режим NoClip"},
    {"FlyMode", "Toggle", "Режим полета"},
    {"SpeedBoost", "Toggle", "Ускорение"},
    {"Invisibility", "Toggle", "Невидимость"},
    {"XRayVision", "Toggle", "Рентген-зрение"},
    {"AntiAfk", "Toggle", "Анти-AFK"},
    {"AutoRespawn", "Toggle", "Авто-респавн"},
    {"ChatLogger", "Toggle", "Логгирование чата"},
    {"PlayerInfo", "Toggle", "Информация об игроках"}
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
    label.TextSize = 16
    label.Parent = frame
    
    if type == "Toggle" then
        local toggle = Instance.new("TextButton")
        toggle.Size = UDim2.new(0, 50, 0, 30)
        toggle.Position = UDim2.new(1, -50, 0.5, -15)
        toggle.Text = AdminSettings[name] and "ON" or "OFF"
        toggle.BackgroundColor3 = AdminSettings[name] and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
        toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggle.Font = Enum.Font.SourceSansBold
        toggle.Name = name
        toggle.Parent = frame
        
        toggle.MouseButton1Click:Connect(function()
            AdminSettings[name] = not AdminSettings[name]
            toggle.Text = AdminSettings[name] and "ON" or "OFF"
            toggle.BackgroundColor3 = AdminSettings[name] and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
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

-- АДМИН-ФУНКЦИИ

-- 1. БЕССМЕРТИЕ
local function setupGodMode()
    if AdminSettings.GodMode and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.Health = math.huge
            humanoid.MaxHealth = math.huge
        end
    end
end

-- 2. БЕСКОНЕЧНЫЕ ПАТРОНЫ
local function setupInfiniteAmmo()
    if AdminSettings.InfiniteAmmo and LocalPlayer.Character then
        local gun = LocalPlayer.Character:FindFirstChild("Gun") or LocalPlayer.Backpack:FindFirstChild("Gun")
        if gun and gun:FindFirstChild("Ammo") then
            gun.Ammo.Value = math.huge
        end
    end
end

-- 3. ESP ИГРОКОВ
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
                    textLabel.TextSize = 16
                    textLabel.Parent = billboard
                    
                    playerESP[player] = billboard
                else
                    playerESP[player].Adornee = humanoidRootPart
                end
            end
        end
    end
    
    -- Удаляем ESP для игроков, которые вышли
    for player, esp in pairs(playerESP) do
        if not player or not player.Parent then
            esp:Destroy()
            playerESP[player] = nil
        end
    end
end

-- 4. ТЕЛЕПОРТ К ИГРОКАМ
local function teleportToPlayer(playerName)
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Name:lower():find(playerName:lower()) and player.Character then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = humanoidRootPart.CFrame
                return true
            end
        end
    end
    return false
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

-- 6. УСКОРЕНИЕ
local originalWalkSpeed = 16
local function setupSpeedBoost()
    if AdminSettings.SpeedBoost and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 50
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

-- 7. РЕЖИМ NOCLIP
local noclipConnection
local function setupNoClip()
    if AdminSettings.NoClip then
        if noclipConnection then noclipConnection:Disconnect() end
        noclipConnection = RunService.Stepped:Connect(function()
            if not AdminSettings.NoClip then return end
            local character = LocalPlayer.Character
            if character then
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConnection then
            noclipConnection:Disconnect()
        end
        local character = LocalPlayer.Character
        if character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
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

-- 9. АВТО-РЕСПАВН
local function setupAutoRespawn()
    if AdminSettings.AutoRespawn then
        LocalPlayer.CharacterAdded:Connect(function()
            wait(1)
            if LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.Health = 0
            end
        end)
    end
end

-- 10. РЕНТГЕН-ЗРЕНИЕ
local xRayParts = {}
local function setupXRayVision()
    if not AdminSettings.XRayVision then
        for _, part in pairs(xRayParts) do
            if part then
                part.LocalTransparencyModifier = 0
            end
        end
        xRayParts = {}
        return
    end
    
    for _, part in ipairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart") and part.Transparency < 0.5 then
            part.LocalTransparencyModifier = 0.7
            table.insert(xRayParts, part)
        end
    end
end

-- 11. ИНФОРМАЦИЯ ОБ ИГРОКАХ
local playerInfoFrame = Instance.new("Frame")
playerInfoFrame.Size = UDim2.new(0, 200, 0, 150)
playerInfoFrame.Position = UDim2.new(1, -210, 0, 10)
playerInfoFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
playerInfoFrame.BackgroundTransparency = 0.7
playerInfoFrame.BorderSizePixel = 0
playerInfoFrame.Visible = AdminSettings.PlayerInfo
playerInfoFrame.Parent = ScreenGui

local playerInfoTitle = Instance.new("TextLabel")
playerInfoTitle.Text = "Информация об игроках"
playerInfoTitle.Size = UDim2.new(1, 0, 0, 20)
playerInfoTitle.BackgroundTransparency = 1
playerInfoTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
playerInfoTitle.Font = Enum.Font.SourceSansBold
playerInfoTitle.TextSize = 14
playerInfoTitle.Parent = playerInfoFrame

local playerInfoText = Instance.new("TextLabel")
playerInfoText.Text = ""
playerInfoText.Size = UDim2.new(1, -10, 1, -25)
playerInfoText.Position = UDim2.new(0, 5, 0, 25)
playerInfoText.BackgroundTransparency = 1
playerInfoText.TextColor3 = Color3.fromRGB(255, 255, 255)
playerInfoText.Font = Enum.Font.SourceSans
playerInfoText.TextSize = 12
playerInfoText.TextXAlignment = Enum.TextXAlignment.Left
playerInfoText.TextYAlignment = Enum.TextYAlignment.Top
playerInfoText.Parent = playerInfoFrame

local function updatePlayerInfo()
    if not AdminSettings.PlayerInfo then
        playerInfoFrame.Visible = false
        return
    end
    
    playerInfoFrame.Visible = true
    local infoText = ""
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            local health = humanoid and math.floor(humanoid.Health) or 0
            local role = "Невиновный"
            
            if player.Character:FindFirstChild("Knife") then
                role = "Убийца"
            elseif player.Character:FindFirstChild("Gun") then
                role = "Шериф"
            end
            
            infoText = infoText .. player.Name .. " (" .. role .. ") - " .. health .. " HP\n"
        end
    end
    
    playerInfoText.Text = infoText
end

-- Запускаем все системы
RunService.Heartbeat:Connect(function()
    setupGodMode()
    setupInfiniteAmmo()
    setupPlayerESP()
    setupFlyMode()
    setupSpeedBoost()
    setupNoClip()
    setupXRayVision()
    updatePlayerInfo()
end)

setupAntiAfk()
setupAutoRespawn()

-- Кнопка для телепорта к игроку
local teleportButton = Instance.new("TextButton")
teleportButton.Text = "🚀"
teleportButton.Size = UDim2.new(0, 50, 0, 50)
teleportButton.Position = UDim2.new(0, 130, 0, 10)
teleportButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
teleportButton.BackgroundTransparency = 0.5
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.Font = Enum.Font.SourceSansBold
teleportButton.TextSize = 24
teleportButton.Parent = ScreenGui

teleportButton.MouseButton1Click:Connect(function()
    local playerName = "Player" -- Замените на имя игрока
    if teleportToPlayer(playerName) then
        local notif = Instance.new("TextLabel")
        notif.Text = "Телепортирован к " .. playerName
        notif.Size = UDim2.new(0, 300, 0, 40)
        notif.Position = UDim2.new(0.5, -150, 0.1, 0)
        notif.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        notif.TextColor3 = Color3.fromRGB(255, 255, 255)
        notif.Font = Enum.Font.SourceSansBold
        notif.TextSize = 16
        notif.Parent = ScreenGui
        
        game:GetService("Debris"):AddItem(notif, 3)
    end
end)

-- Уведомление о загрузке
local notif = Instance.new("TextLabel")
notif.Text = "✅ Ultimate Admin Script загружен!"
notif.Size = UDim2.new(0, 300, 0, 40)
notif.Position = UDim2.new(0.5, -150, 0.1, 0)
notif.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
notif.TextColor3 = Color3.fromRGB(255, 255, 255)
notif.Font = Enum.Font.SourceSansBold
notif.TextSize = 16
notif.Parent = ScreenGui

game:GetService("Debris"):AddItem(notif, 5)

print("✅ Ultimate Admin Script активирован")
print("🛡️ Админ-панель доступна по кнопке 🛡️")
print("🚀 Телепорт к игрокам: Нажмите кнопку 🚀")
