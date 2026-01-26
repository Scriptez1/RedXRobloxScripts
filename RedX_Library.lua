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

    local main = Instance.new("Frame", gui)
    main.Size = UDim2.fromScale(0.75,0.8)
    main.Position = UDim2.fromScale(0.125,0.1)
    main.BackgroundColor3 = theme.bg
    main.ClipsDescendants = true
    corner(main,14)

    -- Gölge efekti için
    local shadow = Instance.new("ImageLabel", main)
    shadow.Size = UDim2.new(1,30,1,30)
    shadow.Position = UDim2.new(0,-15,0,-15)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    shadow.ImageTransparency = 0.7
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10,10,118,118)
    shadow.ZIndex = 0

    local sidebar = Instance.new("Frame", main)
    sidebar.Size = UDim2.new(0,200,1,0)
    sidebar.BackgroundColor3 = theme.panel
    sidebar.BorderSizePixel = 0
    corner(sidebar,14)

    -- Sidebar için padding
    local sidebarPadding = Instance.new("UIPadding", sidebar)
    sidebarPadding.PaddingTop = UDim.new(0,60)
    sidebarPadding.PaddingLeft = UDim.new(0,6)
    sidebarPadding.PaddingRight = UDim.new(0,6)
    sidebarPadding.PaddingBottom = UDim.new(0,6)

    local sidebarLayout = Instance.new("UIListLayout", sidebar)
    sidebarLayout.Padding = UDim.new(0,8)
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder

    -- Header bar (üst kısım)
    local headerBar = Instance.new("Frame", main)
    headerBar.Size = UDim2.new(1,-200,0,50)
    headerBar.Position = UDim2.new(0,200,0,0)
    headerBar.BackgroundColor3 = theme.bg
    headerBar.BorderSizePixel = 0
    headerBar.ZIndex = 2

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
        TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
            Size = isMinimized and UDim2.fromScale(0.75,0.065) or UDim2.fromScale(0.75,0.8)
        }):Play()
        minimizeBtn.Text = isMinimized and "+" or "−"
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
    logoFrame.Size = UDim2.new(1,0,0,50)
    logoFrame.Position = UDim2.new(0,0,0,0)
    logoFrame.BackgroundTransparency = 1
    logoFrame.ZIndex = 3
    logoFrame.LayoutOrder = -1

    local logoText = Instance.new("TextLabel", logoFrame)
    logoText.Text = "RedX"
    logoText.Font = Enum.Font.GothamBold
    logoText.TextSize = 18
    logoText.TextColor3 = theme.accent
    logoText.BackgroundTransparency = 1
    logoText.Size = UDim2.new(1,0,1,0)
    logoText.TextXAlignment = Enum.TextXAlignment.Center

    self.Main = main
    self.Sidebar = sidebar
    self.HeaderBar = headerBar
    self.Pages = {}
    self.CurrentPage = nil

    return self
end

function RedX:CreatePage(name, iconUrl)
    local btn = Instance.new("TextButton", self.Sidebar)
    btn.Size = UDim2.new(1,0,0,40)
    btn.BackgroundColor3 = Color3.fromRGB(28,28,28)
    btn.Text = ""
    btn.BorderSizePixel = 0
    corner(btn,8)

    -- Hover efekti
    addHover(btn, Color3.fromRGB(28,28,28), Color3.fromRGB(35,35,35))

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

    -- Seçili gösterge
    local indicator = Instance.new("Frame", btn)
    indicator.Size = UDim2.new(0,3,0,20)
    indicator.Position = UDim2.new(0,0,0.5,-10)
    indicator.BackgroundColor3 = theme.accent
    indicator.BorderSizePixel = 0
    indicator.Visible = false
    corner(indicator,2)

    local page = Instance.new("ScrollingFrame", self.Main)
    page.Position = UDim2.new(0,220,0,60)
    page.Size = UDim2.new(1,-240,1,-70)
    page.CanvasSize = UDim2.new(0,0,0,0)
    page.ScrollBarThickness = 4
    page.Visible = false
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0

    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0,10)

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+10)
    end)

    btn.MouseButton1Click:Connect(function()
        for _,p in pairs(self.Pages) do
            p.Visible = false
        end
        -- Tüm butonların indicator'larını gizle
        for _,child in pairs(self.Sidebar:GetChildren()) do
            if child:IsA("TextButton") then
                local ind = child:FindFirstChild("Frame")
                if ind then ind.Visible = false end
            end
        end
        indicator.Visible = true
        page.Visible = true
        self.CurrentPage = page
        
        -- Smooth geçiş
        page.ScrollingFrame.CanvasPosition = Vector2.new(0,0)
    end)

    table.insert(self.Pages,page)
    return page
end

function RedX:Section(page, title)
    local card = Instance.new("Frame", page)
    card.Size = UDim2.new(1,0,0,70)
    card.BackgroundColor3 = theme.card
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
