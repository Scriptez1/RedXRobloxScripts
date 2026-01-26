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
    sidebar.ClipsDescendants = true  -- ÖNEMLİ: Taşmaları önler
    corner(sidebar,14)

    local sidebarMask = Instance.new("Frame", sidebar)
    sidebarMask.Size = UDim2.new(0,20,1,0)
    sidebarMask.Position = UDim2.new(1,-20,0,0)
    sidebarMask.BackgroundColor3 = theme.panel
    sidebarMask.BorderSizePixel = 0
    sidebarMask.ZIndex = 2

    -- Sidebar logosu (ListLayout'tan ÖNCE eklenmeli)
    local logoFrame = Instance.new("Frame", sidebar)
    logoFrame.Size = UDim2.new(1,0,0,65)
    logoFrame.Position = UDim2.new(0,0,0,0)  -- Manuel pozisyon
    logoFrame.BackgroundTransparency = 1
    logoFrame.ZIndex = 5
    logoFrame.LayoutOrder = -1000  -- En üstte olması için

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

    -- Butonlar için container (Logo altında başlar)
    local buttonsContainer = Instance.new("Frame", sidebar)
    buttonsContainer.Size = UDim2.new(1,0,1,-75)  -- Logo için 65 + 10 padding = 75
    buttonsContainer.Position = UDim2.new(0,0,0,75)
    buttonsContainer.BackgroundTransparency = 1
    buttonsContainer.ZIndex = 3

    local sidebarPadding = Instance.new("UIPadding", buttonsContainer)
    sidebarPadding.PaddingTop = UDim.new(0,0)
    sidebarPadding.PaddingLeft = UDim.new(0,8)
    sidebarPadding.PaddingRight = UDim.new(0,8)
    sidebarPadding.PaddingBottom = UDim.new(0,8)

    local sidebarLayout = Instance.new("UIListLayout", buttonsContainer)
    sidebarLayout.Padding = UDim.new(0,8)
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    sidebarLayout.FillDirection = Enum.FillDirection.Vertical

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

    -- Minimize button
    local minimizeBtn = Instance.new("TextButton", headerBar)
    minimizeBtn.Size = UDim2.new(0,32,0,32)
    minimizeBtn.Position = UDim2.new(1,-72,0.5,-16)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    minimizeBtn.Text = "−"
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.TextSize = 18
    minimizeBtn.TextColor3 = theme.text
    minimizeBtn.ZIndex = 3
    corner(minimizeBtn,6)
    addHover(minimizeBtn, Color3.fromRGB(40,40,40), Color3.fromRGB(50,50,50))

    -- Close button
    local closeBtn = Instance.new("TextButton", headerBar)
    closeBtn.Size = UDim2.new(0,32,0,32)
    closeBtn.Position = UDim2.new(1,-32,0.5,-16)
    closeBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    closeBtn.Text = "×"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 24
    closeBtn.TextColor3 = theme.text
    closeBtn.ZIndex = 3
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
    self.Sidebar = buttonsContainer  -- ButtonsContainer kullan
    self.HeaderBar = headerBar
    self.Pages = {}
    self.CurrentPage = nil

    return self
end

function RedX:CreatePage(name, iconUrl)
    local btn = Instance.new("TextButton", self.Sidebar)
    btn.Size = UDim2.new(1,0,0,42)
    btn.BackgroundColor3 = Color3.fromRGB(32,32,32)
    btn.Text = ""
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.ZIndex = 3
    corner(btn,8)

    addHover(btn, Color3.fromRGB(32,32,32), Color3.fromRGB(38,38,38))

    local icon = Instance.new("ImageLabel", btn)
    icon.Size = UDim2.new(0,22,0,22)
    icon.Position = UDim2.new(0,10,0.5,-11)
    icon.BackgroundTransparency = 1
    icon.Image = iconUrl or ""
    icon.ZIndex = 4

    local txt = Instance.new("TextLabel", btn)
    txt.Text = name
    txt.Font = Enum.Font.Gotham
    txt.TextSize = 13
    txt.TextColor3 = theme.sub
    txt.BackgroundTransparency = 1
    txt.Position = UDim2.new(0,40,0,0)
    txt.Size = UDim2.new(1,-45,1,0)
    txt.TextXAlignment = Enum.TextXAlignment.Left
    txt.ZIndex = 4

    local indicator = Instance.new("Frame", btn)
    indicator.Size = UDim2.new(0,3,0,24)
    indicator.Position = UDim2.new(0,0,0.5,-12)
    indicator.BackgroundColor3 = theme.accent
    indicator.BorderSizePixel = 0
    indicator.Visible = false
    indicator.ZIndex = 4
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
        
        for _,child in pairs(self.Sidebar:GetChildren()) do
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
    card.Size = UDim2.new(1,0,0,70)
    card.BackgroundColor3 = theme.card
    card.BorderSizePixel = 0
    corner(card,10)
    stroke(card)

    local innerShadow = Instance.new("Frame", card)
    innerShadow.Size = UDim2.new(1,0,0,1)
    innerShadow.Position = UDim2.new(0,0,0,0)
    innerShadow.BackgroundColor3 = Color3.fromRGB(255,255,255)
    innerShadow.BackgroundTransparency = 0.97
    innerShadow.BorderSizePixel = 0

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
    holder.Size = UDim2.new(1,-20,0,30)
    holder.BackgroundTransparency = 1

    return holder
end

function RedX:Toggle(parent, text, callback)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1,0,1,0)
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

local ui = RedX.new("RedX Hub : Blox Fruits")
local farm = ui:CreatePage("Farm", "rbxassetid://7733674079")
local farmSec = ui:Section(farm, "Farm")
ui:Toggle(farmSec, "Auto Farm Level", function(v) 
    print("Auto Farm:", v and "Açık" or "Kapalı")
end)

return RedX
