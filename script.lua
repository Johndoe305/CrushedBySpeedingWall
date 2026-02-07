--// SERVICES
local Players = game:GetService("Players")
local lp = Players.LocalPlayer

--// CONTROLE
local enabled = false
local loopThread

--// GUI
local gui = Instance.new("ScreenGui")
gui.Name = "LifeBrickTouchGui"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(200, 170)
main.Position = UDim2.fromOffset(40, 200)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
main.BorderSizePixel = 0
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

--// TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Crushed Speeding Wall Gui"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = main

--// TOGGLE
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0.9, 0, 0, 32)
toggle.Position = UDim2.new(0.05, 0, 0, 40)
toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
toggle.Text = "AutoFarm OFF"
toggle.TextColor3 = Color3.fromRGB(255,255,255)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 14
toggle.Parent = main
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 10)

--// REMOVE WALL BUTTON
local removeWall = Instance.new("TextButton")
removeWall.Size = UDim2.new(0.9, 0, 0, 28)
removeWall.Position = UDim2.new(0.05, 0, 0, 80)
removeWall.BackgroundColor3 = Color3.fromRGB(160, 80, 80)
removeWall.Text = "Remove Wall"
removeWall.TextColor3 = Color3.new(1,1,1)
removeWall.Font = Enum.Font.GothamBold
removeWall.TextSize = 13
removeWall.Parent = main
Instance.new("UICorner", removeWall).CornerRadius = UDim.new(0, 10)

--// TELEPORT VIP BUTTON
local vipBtn = Instance.new("TextButton")
vipBtn.Size = UDim2.new(0.9, 0, 0, 28)
vipBtn.Position = UDim2.new(0.05, 0, 0, 115)
vipBtn.BackgroundColor3 = Color3.fromRGB(80, 120, 200)
vipBtn.Text = "Teleport Área VIP"
vipBtn.TextColor3 = Color3.new(1,1,1)
vipBtn.Font = Enum.Font.GothamBold
vipBtn.TextSize = 13
vipBtn.Parent = main
Instance.new("UICorner", vipBtn).CornerRadius = UDim.new(0, 10)

--// DRAG (PC + MOBILE)
local dragging, dragStart, startPos
main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

main.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

--// LIFE BRICK TOUCH
local function touchAllLifeBricks(char)
    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    if not hrp then return end

    local lifebricks = workspace:FindFirstChild("Lifebricks")
    if not lifebricks then return end

    for i = 1, 8 do
        local brick = lifebricks:FindFirstChild(tostring(i))
        if brick and brick:FindFirstChild("TouchInterest") then
            firetouchinterest(hrp, brick, 0)
            task.wait(0.05)
            firetouchinterest(hrp, brick, 1)
        end
    end
end

--// LOOP PRINCIPAL
local function startLoop()
    loopThread = task.spawn(function()
        while enabled do
            local char = lp.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then hum.Health = 0 end
            end

            lp.CharacterAdded:Wait()
            task.wait(0.9)

            if enabled and lp.Character then
                touchAllLifeBricks(lp.Character)
            end

            task.wait(0.1)
        end
    end)
end

--// TOGGLE CLICK
toggle.MouseButton1Click:Connect(function()
    enabled = not enabled
    if enabled then
        toggle.Text = "AutoFarm ON"
        toggle.BackgroundColor3 = Color3.fromRGB(80, 180, 120)
        startLoop()
    else
        toggle.Text = "AutoFarm OFF"
        toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    end
end)

--// REMOVE WALL
removeWall.MouseButton1Click:Connect(function()
    local wall = workspace:FindFirstChild("Map")
        and workspace.Map:FindFirstChild("Tunnel")
        and workspace.Map.Tunnel:FindFirstChild("Wall")
    if wall then wall:Destroy() end
end)

--// TELEPORT VIP (VAI / VOLTA)
local vipCFrame = CFrame.new(
    1521.02246, 60.9800072, 326.278015,
    -0.999901175, -0.000150106382, -0.0140644563,
    -0.000541077519, 0.999613523, -0.027793517,
    0.014054408, -0.0277985482, -0.999513984
)

local savedCFrame
local atVip = false

vipBtn.MouseButton1Click:Connect(function()
    local char = lp.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if not atVip then
        savedCFrame = hrp.CFrame
        hrp.CFrame = vipCFrame
        vipBtn.Text = "Voltar"
        atVip = true
    else
        if savedCFrame then hrp.CFrame = savedCFrame end
        vipBtn.Text = "Teleport Área VIP"
        atVip = false
    end
end)

-- NOTIFICAÇÃO
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Made By Old Scripts";
    Text = "Script loaded";
    Icon = "rbxassetid://288817482"; -- icone de virus so pra dar um pouco de susto kkkk
    Duration = 6;
    Button1 = "OK";
    Callback = callback;
})

-- Somzinho de carregado
task.spawn(function()
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://3023237993"
    s.Volume = 0.4
    s.Parent = game:GetService("SoundService")
    s:Play()
    task.delay(3, function() s:Destroy() end)
end)

print("[loaded]")
