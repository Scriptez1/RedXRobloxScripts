local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")

local theme = {
    bg = Color3.fromRGB(17,17,17),
    panel = Color3.fromRGB(24,24,24),
    card = Color3.fromRGB(32,32,32),
    stroke = Color3.fromRGB(55,55,55),
    text = Color3.fromRGB(235,235,235),
    sub = Color3.fromRGB(160,160,160),
    accent = Color3.fromRGB(220,20,60)
}

local function corner(o,r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,r)
    c.Parent = o
end

local function stroke(o)
    local s = Instance.new("UIStroke")
    s.Color = theme.stroke
    s.Thickness = 1
    s.Parent = o
end

local function addHover(btn, normalColor, hoverColor)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = hoverColor}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = normalColor}):Play()
    end)
end

local RedX = {}
RedX.__index = RedX

function RedX.new(title)
    local self = setmetatable({},RedX)

    local gui = Instance.new("ScreenGui", guiParent)
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.IgnoreGuiInset = true

    -- Minimize için küçük ikon
    local miniIcon = Instance.new("Frame", gui)
    miniIcon.Size = UDim2.new(0,60,0,60)
    miniIcon.Position = UDim2.new(0,20,0,20)
    miniIcon.BackgroundColor3 = theme.panel
    miniIcon.Visible = false
    miniIcon.BorderSizePixel = 0
    corner(miniIcon,12)
    stroke(miniIcon)

    local miniText = Instance.new("TextLabel", miniIcon)
    miniText.Text = "RX"
    miniText.Font = Enum.Font.GothamBold
    miniText.TextSize = 18
    miniText.TextColor3 = theme.accent
    miniText.BackgroundTransparency = 1
    miniText.Size = UDim2.new(1,0,1,0)
    miniText.TextXAlignment = Enum.TextXAlignment.Center
    miniText.TextYAlignment = Enum.TextYAlignment.Center

    local miniBtn = Instance.new("TextButton", miniIcon)
    miniBtn.Size = UDim2.new(1,0,1,0)
    miniBtn.BackgroundTransparency = 1
    miniBtn.Text = ""
    miniBtn.ZIndex = 2

    -- Mini icon draggable
    local miniDragging = false
    local miniDragInput, miniMousePos, miniFramePos

    miniIcon.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            miniDragging = true
            miniMousePos = input.Position
            miniFramePos = miniIcon.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    miniDragging = false
                end
            end)
        end
    end)

    miniIcon.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            miniDragInput = input
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == miniDragInput and miniDragging then
            local delta = input.Position - miniMousePos
            miniIcon.Position = UDim2.new(
                miniFramePos.X.Scale, miniFramePos.X.Offset + delta.X,
                miniFramePos.Y.Scale, miniFramePos.Y.Offset + delta.Y
            )
        end
    end)

    local main = Instance.new("Frame", gui)
    main.Size = UDim2.fromScale(0.75,0.8)
    main.Position = UDim2.fromScale(0.125,0.1)
    main.BackgroundColor3 = theme.bg
    main.BorderSizePixel = 0
    main.ClipsDescendants = false
    main.Active = false
    corner(main,14)

    -- Sidebar
    local sidebar = Instance.new("Frame", main)
    sidebar.Size = UDim2.new(0,200,1,0)
    sidebar.Position = UDim2.new(0,0,0,0)
    sidebar.BackgroundColor3 = theme.panel
    sidebar.BorderSizePixel = 0
    sidebar.ZIndex = 2
    sidebar.ClipsDescendants = false
    corner(sidebar,14)

    local sidebarMask = Instance.new("Frame", sidebar)
    sidebarMask.Size = UDim2.new(0,20,1,0)
    sidebarMask.Position = UDim2.new(1,-20,0,0)
    sidebarMask.BackgroundColor3 = theme.panel
    sidebarMask.BorderSizePixel = 0
    sidebarMask.ZIndex = 2

    -- Sidebar logosu (Absolute position - UIListLayout etkilemeyecek)
    local logoFrame = Instance.new("Frame", sidebar)
    logoFrame.Size = UDim2.new(1,0,0,65)
    logoFrame.Position = UDim2.new(0,0,0,0)
    logoFrame.BackgroundTransparency = 1
    logoFrame.ZIndex = 5

    local logoText = Instance.new("TextLabel", logoFrame)
    logoText.Text = "RedX"
    logoText.Font = Enum.Font.GothamBold
    logoText.TextSize = 20
    logoText.TextColor3 = theme.accent
    logoText.BackgroundTransparency = 1
    logoText.Size = UDim2.new(1,0,1,0)
    logoText.TextXAlignment = Enum.TextXAlignment.Center
    logoText.TextYAlignment = Enum.TextYAlignment.Center
    logoText.ZIndex = 5

    -- ScrollingFrame için butonlar (Logo'nun altında)
    local buttonsScroll = Instance.new("ScrollingFrame", sidebar)
    buttonsScroll.Size = UDim2.new(1,0,1,-75)
    buttonsScroll.Position = UDim2.new(0,0,0,75)
    buttonsScroll.BackgroundTransparency = 1
    buttonsScroll.BorderSizePixel = 0
    buttonsScroll.ScrollBarThickness = 0
    buttonsScroll.CanvasSize = UDim2.new(0,0,0,0)
    buttonsScroll.ZIndex = 3

    local buttonsPadding = Instance.new("UIPadding", buttonsScroll)
    buttonsPadding.PaddingLeft = UDim.new(0,8)
    buttonsPadding.PaddingRight = UDim.new(0,8)
    buttonsPadding.PaddingTop = UDim.new(0,0)
    buttonsPadding.PaddingBottom = UDim.new(0,8)

    local buttonsLayout = Instance.new("UIListLayout", buttonsScroll)
    buttonsLayout.Padding = UDim.new(0,8)
    buttonsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    buttonsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    buttonsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        buttonsScroll.CanvasSize = UDim2.new(0,0,0,buttonsLayout.AbsoluteContentSize.Y + 8)
    end)

    -- Header bar
    local headerBar = Instance.new("Frame", main)
    headerBar.Size = UDim2.new(1,-200,0,50)
    headerBar.Position = UDim2.new(0,200,0,0)
    headerBar.BackgroundColor3 = theme.bg
    headerBar.BorderSizePixel = 0
    headerBar.ZIndex = 2
    headerBar.ClipsDescendants = true
    headerBar.Active = true

    local headerCorner = Instance.new("UICorner", headerBar)
    headerCorner.CornerRadius = UDim.new(0,14)

    local headerLine = Instance.new("Frame", headerBar)
    headerLine.Size = UDim2.new(1,0,0,1)
    headerLine.Position = UDim2.new(0,0,1,0)
    headerLine.BackgroundColor3 = theme.stroke
    headerLine.BorderSizePixel = 0

    -- Draggable
    local dragging = false
    local dragInput, mousePos, framePos

    headerBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = main.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    headerBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            main.Position = UDim2.new(
                framePos.X.Scale, framePos.X.Offset + delta.X,
                framePos.Y.Scale, framePos.Y.Offset + delta.Y
            )
        end
    end)


    local header = Instance.new("TextLabel", headerBar)
    header.Text = title
    header.Font = Enum.Font.GothamBold
    header.TextSize = 20
    header.TextColor3 = theme.text
    header.BackgroundTransparency = 1
    header.Position = UDim2.new(0,20,0,0)
    header.Size = UDim2.new(1,-120,1,0)
    header.TextXAlignment = Enum.TextXAlignment.Left

    local rightButtons = Instance.new("Frame", headerBar)
    rightButtons.Size = UDim2.new(0,220,1,0)
    rightButtons.Position = UDim2.new(1,-220,0,0)
    rightButtons.BackgroundTransparency = 1
    
    local pad = Instance.new("UIPadding", rightButtons)
    pad.PaddingRight = UDim.new(0,30)

    local rightLayout = Instance.new("UIListLayout", rightButtons)
    rightLayout.FillDirection = Enum.FillDirection.Horizontal
    rightLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    rightLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    rightLayout.Padding = UDim.new(0,8)

    -- Minimize button
    local minimizeBtn = Instance.new("TextButton", rightButtons)
    minimizeBtn.Size = UDim2.new(0,32,0,32)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    minimizeBtn.Text = "−"
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.TextSize = 18
    minimizeBtn.TextColor3 = theme.text
    corner(minimizeBtn,6)
    addHover(minimizeBtn, Color3.fromRGB(40,40,40), Color3.fromRGB(50,50,50))

    local closeBtn = Instance.new("TextButton", rightButtons)
    closeBtn.Size = UDim2.new(0,32,0,32)
    closeBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    closeBtn.Text = "×"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 24
    closeBtn.TextColor3 = theme.text
    corner(closeBtn,6)
    addHover(closeBtn, Color3.fromRGB(40,40,40), theme.accent)

    -- Minimize functionality
    local isMinimized = false
    minimizeBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                Size = UDim2.new(0,0,0,0),
                Position = UDim2.new(0,20,0,20)
            }):Play()
            task.wait(0.3)
            main.Visible = false
            miniIcon.Visible = true
        end
    end)

    miniBtn.MouseButton1Click:Connect(function()
        miniIcon.Visible = false
        main.Visible = true
        main.Size = UDim2.new(0,0,0,0)
        main.Position = UDim2.new(0,20,0,20)
        TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
            Size = UDim2.fromScale(0.75,0.8),
            Position = UDim2.fromScale(0.125,0.1)
        }):Play()
        isMinimized = false
    end)

    -- Close functionality
    closeBtn.MouseButton1Click:Connect(function()
        TweenService:Create(main, TweenInfo.new(0.2), {
            BackgroundTransparency = 1,
            Size = UDim2.new(0,0,0,0),
            Position = UDim2.new(0,20,0,20)
        }):Play()
        
        for _, child in pairs(main:GetDescendants()) do
            if child:IsA("GuiObject") then
                pcall(function()
                    TweenService:Create(child, TweenInfo.new(0.2), {
                        BackgroundTransparency = 1
                    }):Play()
                end)
                
                if child:IsA("TextLabel") or child:IsA("TextButton") then
                    pcall(function()
                        TweenService:Create(child, TweenInfo.new(0.2), {
                            TextTransparency = 1
                        }):Play()
                    end)
                end
                
                if child:IsA("ImageLabel") then
                    pcall(function()
                        TweenService:Create(child, TweenInfo.new(0.2), {
                            ImageTransparency = 1
                        }):Play()
                    end)
                end
            end
        end
        
        task.wait(0.25)
        gui:Destroy()
    end)

    self.Main = main
    self.ButtonsScroll = buttonsScroll
    self.HeaderBar = headerBar
    self.Pages = {}
    self.CurrentPage = nil

    return self
end

function RedX:CreatePage(name, iconUrl)
    print("Creating page:", name) -- DEBUG
    
    local btn = Instance.new("TextButton", self.ButtonsScroll)
    btn.Size = UDim2.new(1,-16,0,42) -- Genişliği biraz azalttık
    btn.BackgroundColor3 = Color3.fromRGB(32,32,32)
    btn.Text = ""
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.ZIndex = 4
    corner(btn,8)
    
    print("Button created, parent:", btn.Parent.Name) -- DEBUG

    addHover(btn, Color3.fromRGB(32,32,32), Color3.fromRGB(38,38,38))

    local icon = Instance.new("ImageLabel", btn)
    icon.Size = UDim2.new(0,22,0,22)
    icon.Position = UDim2.new(0,10,0.5,-11)
    icon.BackgroundTransparency = 1
    icon.Image = iconUrl or ""
    icon.ZIndex = 5

    local txt = Instance.new("TextLabel", btn)
    txt.Text = name
    txt.Font = Enum.Font.Gotham
    txt.TextSize = 13
    txt.TextColor3 = theme.sub
    txt.BackgroundTransparency = 1
    txt.Position = UDim2.new(0,40,0,0)
    txt.Size = UDim2.new(1,-45,1,0)
    txt.TextXAlignment = Enum.TextXAlignment.Left
    txt.ZIndex = 5

    local indicator = Instance.new("Frame", btn)
    indicator.Size = UDim2.new(0,3,0,24)
    indicator.Position = UDim2.new(0,0,0.5,-12)
    indicator.BackgroundColor3 = theme.accent
    indicator.BorderSizePixel = 0
    indicator.Visible = false
    indicator.ZIndex = 5
    corner(indicator,2)

    local page = Instance.new("ScrollingFrame", self.Main)
    page.Position = UDim2.new(0,210,0,60)
    page.Size = UDim2.new(1,-220,1,-70)
    page.CanvasSize = UDim2.new(0,0,0,0)
    page.ScrollBarThickness = 4
    page.Visible = false
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ZIndex = 1

    local pagePadding = Instance.new("UIPadding", page)
    pagePadding.PaddingTop = UDim.new(0,10)
    pagePadding.PaddingLeft = UDim.new(0,10)
    pagePadding.PaddingRight = UDim.new(0,10)
    pagePadding.PaddingBottom = UDim.new(0,10)

    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0,10)

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+20)
    end)

    btn.MouseButton1Click:Connect(function()
        for _,p in pairs(self.Pages) do
            p.Visible = false
        end
        
        for _,child in pairs(self.ButtonsScroll:GetChildren()) do
            if child:IsA("TextButton") then
                local ind = child:FindFirstChild("Frame")
                if ind then ind.Visible = false end
                TweenService:Create(child, TweenInfo.new(0.15), {
                    BackgroundColor3 = Color3.fromRGB(32,32,32)
                }):Play()
            end
        end
        
        indicator.Visible = true
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(40,40,40)
        }):Play()
        page.Visible = true
        self.CurrentPage = page
        page.CanvasPosition = Vector2.new(0,0)
    end)

    table.insert(self.Pages,page)
    
    if #self.Pages == 1 then
        page.Visible = true
        indicator.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
        self.CurrentPage = page
    end
    
    return page
end

function RedX:Section(page, title)
    local card = Instance.new("Frame", page)
    card.Size = UDim2.new(1,0,0,40)
    card.BackgroundColor3 = theme.card
    card.BorderSizePixel = 0
    corner(card,10)
    stroke(card)

    local label = Instance.new("TextLabel", card)
    label.Text = title
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextColor3 = theme.text
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0,12,0,8)
    label.Size = UDim2.new(1,-24,0,20)
    label.TextXAlignment = Enum.TextXAlignment.Left

    local holder = Instance.new("Frame", card)
    holder.Position = UDim2.new(0,10,0,32)
    holder.Size = UDim2.new(1,-20,0,0)
    holder.BackgroundTransparency = 1

    local layout = Instance.new("UIListLayout", holder)
    layout.Padding = UDim.new(0,6)

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        holder.Size = UDim2.new(1,-20,0,layout.AbsoluteContentSize.Y)
        card.Size = UDim2.new(1,0,0,layout.AbsoluteContentSize.Y + 42)
    end)

    return holder
end

function RedX:Toggle(parent, text, callback)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1,0,0,32)
    row.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", row)
    label.Size = UDim2.new(0.7,0,1,0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextColor3 = theme.sub
    label.TextXAlignment = Enum.TextXAlignment.Left

    local toggle = Instance.new("TextButton", row)
    toggle.Size = UDim2.new(0,42,0,22)
    toggle.Position = UDim2.new(1,-50,0.5,-11)
    toggle.Text = ""
    toggle.BackgroundColor3 = Color3.fromRGB(60,60,60)
    corner(toggle,20)

    local knob = Instance.new("Frame", toggle)
    knob.Size = UDim2.new(0,16,0,16)
    knob.Position = UDim2.new(0,3,0.5,-8)
    knob.BackgroundColor3 = Color3.fromRGB(200,200,200)
    corner(knob,12)

    local on = false
    toggle.MouseButton1Click:Connect(function()
        on = not on
        
        TweenService:Create(toggle, TweenInfo.new(0.2), {
            BackgroundColor3 = on and theme.accent or Color3.fromRGB(60,60,60)
        }):Play()
        
        TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            Position = on and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8),
            BackgroundColor3 = on and Color3.fromRGB(255,255,255) or Color3.fromRGB(200,200,200)
        }):Play()
        
        if callback then callback(on) end
    end)
end

-- AUTO LOAD DEMO
local ui = RedX.new("RedX Hub : Blox Fruits")
local farm = ui:CreatePage("Farm", "rbxassetid://7733674079")
local farmSec = ui:Section(farm, "Farm")
ui:Toggle(farmSec, "Auto Farm Level", function(v) 
    print("Auto Farm:", v and "Açık" or "Kapalı")
end)

-- Combat Scripts
local combat = ui:CreatePage("Combat", "rbxassetid://7734051562")
local combatSec = ui:Section(combat, "Combat Features")
ui:Toggle(combatSec, "Auto Attack", function(v)
    if v then
        _G.autoAttack = true
        while _G.autoAttack do
            local plr = game.Players.LocalPlayer
            if plr.Character and plr.Character:FindFirstChild("Humanoid") then
                local enemies = workspace.Enemies:GetChildren()
                for _, enemy in pairs(enemies) do
                    if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                        plr.Character.Humanoid:MoveTo(enemy.PrimaryPart.Position)
                        task.wait(0.5)
                        if (enemy.PrimaryPart.Position - plr.Character.PrimaryPart.Position).Magnitude < 10 then
                            game:GetService("ReplicatedStorage").Remotes.CommE:FireServer("Attack", enemy)
                        end
                    end
                end
            end
            task.wait(1)
        end
    else
        _G.autoAttack = false
    end
end)

ui:Toggle(combatSec, "Kill Aura", function(v)
    if v then
        _G.killAura = true
        while _G.killAura do
            local plr = game.Players.LocalPlayer
            if plr.Character and plr.Character:FindFirstChild("Humanoid") then
                local enemies = workspace.Enemies:GetChildren()
                for _, enemy in pairs(enemies) do
                    if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                        if (enemy.PrimaryPart.Position - plr.Character.PrimaryPart.Position).Magnitude < 15 then
                            game:GetService("ReplicatedStorage").Remotes.CommE:FireServer("Attack", enemy)
                        end
                    end
                end
            end
            task.wait(0.1)
        end
    else
        _G.killAura = false
    end
end)

-- Movement Scripts
local movement = ui:CreatePage("Movement", "rbxassetid://7733986726")
local moveSec = ui:Section(movement, "Movement Features")
ui:Toggle(moveSec, "Speed Hack", function(v)
    if v then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 50
    else
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

ui:Toggle(moveSec, "High Jump", function(v)
    if v then
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = 100
    else
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
    end
end)

ui:Toggle(moveSec, "Fly", function(v)
    if v then
        _G.flying = true
        local plr = game.Players.LocalPlayer
        local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(4000,4000,4000)
        bodyVelocity.P = 1250
        bodyVelocity.Velocity = Vector3.new(0,0,0)
        bodyVelocity.Parent = humanoid.RootPart
        
        while _G.flying do
            if humanoid.MoveDirection.Magnitude > 0 then
                bodyVelocity.Velocity = humanoid.MoveDirection * 50
            else
                bodyVelocity.Velocity = Vector3.new(0,0,0)
            end
            task.wait()
        end
        bodyVelocity:Destroy()
    else
        _G.flying = false
    end
end)

-- Farm Scripts
local farm2 = ui:Section(farm, "Auto Farm")
ui:Toggle(farm2, "Auto Fruit", function(v)
    if v then
        _G.autoFruit = true
        while _G.autoFruit do
            for _, fruit in pairs(workspace:GetChildren()) do
                if fruit:IsA("Tool") and fruit:FindFirstChild("Handle") then
                    local plr = game.Players.LocalPlayer
                    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
                        plr.Character.Humanoid:MoveTo(fruit.Handle.Position)
                        task.wait(0.5)
                        if (fruit.Handle.Position - plr.Character.PrimaryPart.Position).Magnitude < 5 then
                            firetouchinterest(fruit.Handle, plr.Character.PrimaryPart, 0)
                            firetouchinterest(fruit.Handle, plr.Character.PrimaryPart, 1)
                        end
                    end
                end
            end
            task.wait(2)
        end
    else
        _G.autoFruit = false
    end
end)

ui:Toggle(farm2, "Auto Chest", function(v)
    if v then
        _G.autoChest = true
        while _G.autoChest do
            for _, chest in pairs(workspace:GetDescendants()) do
                if chest.Name:lower():find("chest") and chest:IsA("Model") then
                    local plr = game.Players.LocalPlayer
                    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
                        plr.Character.Humanoid:MoveTo(chest:GetModelCFrame().Position)
                        task.wait(0.5)
                        if (chest:GetModelCFrame().Position - plr.Character.PrimaryPart.Position).Magnitude < 5 then
                            fireclickdetector(chest:FindFirstChildOfClass("ClickDetector"))
                        end
                    end
                end
            end
            task.wait(3)
        end
    else
        _G.autoChest = false
    end
end)

-- ESP Scripts
local esp = ui:CreatePage("ESP", "rbxassetid://7734028415")
local espSec = ui:Section(esp, "ESP Features")
ui:Toggle(espSec, "Player ESP", function(v)
    if v then
        _G.playerESP = true
        while _G.playerESP do
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local highlight = player.Character:FindFirstChild("ESP_Highlight")
                    if not highlight then
                        highlight = Instance.new("Highlight")
                        highlight.FillColor = Color3.new(1, 0, 0)
                        highlight.OutlineColor = Color3.new(1, 1, 1)
                        highlight.FillTransparency = 0.5
                        highlight.OutlineTransparency = 0
                        highlight.Parent = player.Character
                    end
                end
            end
            task.wait(1)
        end
    else
        _G.playerESP = false
        for _, player in pairs(game.Players:GetPlayers()) do
            if player.Character then
                local highlight = player.Character:FindFirstChild("ESP_Highlight")
                if highlight then
                    highlight:Destroy()
                end
            end
        end
    end
end)

ui:Toggle(espSec, "Item ESP", function(v)
    if v then
        _G.itemESP = true
        while _G.itemESP do
            for _, item in pairs(workspace:GetDescendants()) do
                if item:IsA("Tool") and item:FindFirstChild("Handle") then
                    local billboard = item:FindFirstChild("ESP_Billboard")
                    if not billboard then
                        billboard = Instance.new("BillboardGui")
                        billboard.Size = UDim2.new(0, 100, 0, 40)
                        billboard.StudsOffset = Vector3.new(0, 2, 0)
                        billboard.AlwaysOnTop = true
                        billboard.Parent = item.Handle
                        
                        local label = Instance.new("TextLabel")
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.BackgroundTransparency = 1
                        label.Text = item.Name
                        label.TextColor3 = Color3.new(1, 1, 0)
                        label.TextStrokeTransparency = 0
                        label.TextSize = 14
                        label.Font = Enum.Font.Bold
                        label.Parent = billboard
                    end
                end
            end
            task.wait(2)
        end
    else
        _G.itemESP = false
        for _, item in pairs(workspace:GetDescendants()) do
            local billboard = item:FindFirstChild("ESP_Billboard")
            if billboard then
                billboard:Destroy()
            end
        end
    end
end)

-- Misc Scripts
local misc = ui:CreatePage("Misc", "rbxassetid://7734063219")
local miscSec = ui:Section(misc, "Miscellaneous")
ui:Toggle(miscSec, "No Clip", function(v)
    if v then
        _G.noClip = true
        while _G.noClip do
            local plr = game.Players.LocalPlayer
            if plr.Character and plr.Character:FindFirstChild("Humanoid") then
                for _, part in pairs(plr.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
            task.wait(0.1)
        end
    else
        _G.noClip = false
        local plr = game.Players.LocalPlayer
        if plr.Character then
            for _, part in pairs(plr.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end)

ui:Toggle(miscSec, "Infinite Yield", function(v)
    if v then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Edge-IY/infiniteyield/master/source"))()
    end
end)

return RedX
