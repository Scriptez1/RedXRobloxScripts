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

-- Smooth hover animasyonu
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
    miniIcon.Active = true
    miniIcon.Draggable = true
    corner(miniIcon,12)

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

    local main = Instance.new("Frame", gui)
    main.Size = UDim2.fromScale(0.75,0.8)
    main.Position = UDim2.fromScale(0.125,0.1)
    main.BackgroundColor3 = theme.bg
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.Active = true
    corner(main,14)

    -- Draggable yapma
    local dragging = false
    local dragInput, mousePos, framePos

    main.InputBegan:Connect(function(input)
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

    main.InputChanged:Connect(function(input)
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

    local sidebar = Instance.new("Frame", main)
    sidebar.Size = UDim2.new(0,200,1,0)
    sidebar.Position = UDim2.new(0,0,0,0)
    sidebar.BackgroundColor3 = theme.panel
    sidebar.BorderSizePixel = 0
    sidebar.ZIndex = 2
    corner(sidebar,14)

    -- Sidebar için sağ kenar (köşeleri düzelt)
    local sidebarMask = Instance.new("Frame", sidebar)
    sidebarMask.Size = UDim2.new(0,20,1,0)
    sidebarMask.Position = UDim2.new(1,-20,0,0)
    sidebarMask.BackgroundColor3 = theme.panel
    sidebarMask.BorderSizePixel = 0
    sidebarMask.ZIndex = 2

    -- Sidebar için padding
    local sidebarPadding = Instance.new("UIPadding", sidebar)
    sidebarPadding.PaddingTop = UDim.new(0,10)
    sidebarPadding.PaddingLeft = UDim.new(0,8)
    sidebarPadding.PaddingRight = UDim.new(0,8)
    sidebarPadding.PaddingBottom = UDim.new(0,8)

    local sidebarLayout = Instance.new("UIListLayout", sidebar)
    sidebarLayout.Padding = UDim.new(0,8)
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    sidebarLayout.FillDirection = Enum.FillDirection.Vertical

    -- Header bar (üst kısım)
    local headerBar = Instance.new("Frame", main)
    headerBar.Size = UDim2.new(1,-200,0,50)
    headerBar.Position = UDim2.new(0,200,0,0)
    headerBar.BackgroundColor3 = theme.bg
    headerBar.BorderSizePixel = 0
    headerBar.ZIndex = 2
    headerBar.ClipsDescendants = true
    
    -- Sağ üst köşe
    local headerCorner = Instance.new("UICorner", headerBar)
    headerCorner.CornerRadius = UDim.new(0,14)

    -- Alt çizgi
    local headerLine = Instance.new("Frame", headerBar)
    headerLine.Size = UDim2.new(1,0,0,1)
    headerLine.Position = UDim2.new(0,0,1,0)
    headerLine.BackgroundColor3 = theme.stroke
    headerLine.BorderSizePixel = 0

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
    corner(closeBtn,6)
    addHover(closeBtn, Color3.fromRGB(40,40,40), theme.accent)

    -- Minimize functionality
    local isMinimized = false
    minimizeBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            -- Minimize - küçük ikona dönüş
            TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                Size = UDim2.fromScale(0,0),
                Position = UDim2.fromScale(0.5,0.5)
            }):Play()
            wait(0.3)
            main.Visible = false
            miniIcon.Visible = true
        end
    end)

    -- Mini icon'a tıklayınca geri aç
    miniBtn.MouseButton1Click:Connect(function()
        miniIcon.Visible = false
        main.Visible = true
        main.Size = UDim2.fromScale(0,0)
        main.Position = UDim2.fromScale(0.5,0.5)
        TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
            Size = UDim2.fromScale(0.75,0.8),
            Position = UDim2.fromScale(0.125,0.1)
        }):Play()
    end)

    -- Close functionality
    closeBtn.MouseButton1Click:Connect(function()
        TweenService:Create(main, TweenInfo.new(0.2), {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(0.65,0.7)
        }):Play()
        wait(0.2)
        gui:Destroy()
    end)

    -- Sidebar logosunu ekle (üst kısım)
    local logoFrame = Instance.new("Frame", sidebar)
    logoFrame.Size = UDim2.new(1,0,0,55)
    logoFrame.Position = UDim2.new(0,0,0,0)
    logoFrame.BackgroundTransparency = 1
    logoFrame.ZIndex = 5
    logoFrame.LayoutOrder = -1

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

    self.Main = main
    self.Sidebar = sidebar
    self.HeaderBar = headerBar
    self.Pages = {}
    self.CurrentPage = nil

    return self
end

function RedX:CreatePage(name, iconUrl)
    local btn = Instance.new("TextButton", self.Sidebar)
    btn.Size = UDim2.new(1,-16,0,42)
    btn.BackgroundColor3 = Color3.fromRGB(32,32,32)
    btn.Text = ""
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    corner(btn,8)

    -- Hover efekti
    addHover(btn, Color3.fromRGB(32,32,32), Color3.fromRGB(38,38,38))

    local icon = Instance.new("ImageLabel", btn)
    icon.Size = UDim2.new(0,22,0,22)
    icon.Position = UDim2.new(0,10,0.5,-11)
    icon.BackgroundTransparency = 1
    icon.Image = iconUrl or ""

    local txt = Instance.new("TextLabel", btn)
    txt.Text = name
    txt.Font = Enum.Font.Gotham
    txt.TextSize = 13
    txt.TextColor3 = theme.sub
    txt.BackgroundTransparency = 1
    txt.Position = UDim2.new(0,40,0,0)
    txt.Size = UDim2.new(1,-45,1,0)
    txt.TextXAlignment = Enum.TextXAlignment.Left

    -- Seçili gösterge (sol kırmızı çubuk)
    local indicator = Instance.new("Frame", btn)
    indicator.Size = UDim2.new(0,3,0,24)
    indicator.Position = UDim2.new(0,-8,0.5,-12)
    indicator.BackgroundColor3 = theme.accent
    indicator.BorderSizePixel = 0
    indicator.Visible = false
    corner(indicator,2)

    local page = Instance.new("ScrollingFrame", self.Main)
    page.Position = UDim2.new(0,210,0,60)
    page.Size = UDim2.new(1,-220,1,-70)
    page.CanvasSize = UDim2.new(0,0,0,0)
    page.ScrollBarThickness = 4
    page.Visible = false
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0

    -- Padding ekle
    local pagePadding = Instance.new("UIPadding", page)
    pagePadding.PaddingTop = UDim.new(0,10)
    pagePadding.PaddingLeft = UDim.new(0,10)
    pagePadding.PaddingRight = UDim.new(0,10)
    pagePadding.PaddingBottom = UDim.new(0,10)

    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0,10)

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+10)
    end)

    btn.MouseButton1Click:Connect(function()
        for _,p in pairs(self.Pages) do
            p.Visible = false
        end
        -- Tüm butonları normale döndür
        for _,child in pairs(self.Sidebar:GetChildren()) do
            if child:IsA("TextButton") then
                local ind = child:FindFirstChild("Frame")
                if ind then ind.Visible = false end
                TweenService:Create(child, TweenInfo.new(0.15), {
                    BackgroundColor3 = Color3.fromRGB(32,32,32)
                }):Play()
            end
        end
        -- Seçili olanı vurgula
        indicator.Visible = true
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(40,40,40)
        }):Play()
        page.Visible = true
        self.CurrentPage = page
        
        -- Smooth geçiş
        page.CanvasPosition = Vector2.new(0,0)
    end)

    table.insert(self.Pages,page)
    
    -- İlk sayfa otomatik seçili olsun
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
    card.Size = UDim2.new(1,-10,0,70)
    card.BackgroundColor3 = theme.card
    card.BorderSizePixel = 0
    corner(card,10)
    stroke(card)

    -- Hafif gölge efekti
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

    -- Toggle topu
    local knob = Instance.new("Frame", toggle)
    knob.Size = UDim2.new(0,16,0,16)
    knob.Position = UDim2.new(0,3,0.5,-8)
    knob.BackgroundColor3 = Color3.fromRGB(200,200,200)
    corner(knob,12)

    local on = false
    toggle.MouseButton1Click:Connect(function()
        on = not on
        
        -- Smooth animasyon
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

return RedX
