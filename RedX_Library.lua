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

    self.Gui = gui
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

    local icon
    if iconUrl and iconUrl ~= "" then
        icon = Instance.new("ImageLabel", btn)
        icon.Size = UDim2.new(0,22,0,22)
        icon.Position = UDim2.new(0,10,0.5,-11)
        icon.BackgroundTransparency = 1
        icon.Image = iconUrl
        icon.ZIndex = 5
    end


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

function RedX:Dropdown(parent, text, options, default, callback)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1,0,0,60)
    row.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", row)
    label.Size = UDim2.new(1,0,0,20)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextColor3 = theme.sub
    label.TextXAlignment = Enum.TextXAlignment.Left

    local btn = Instance.new("TextButton", row)
    btn.Position = UDim2.new(0,0,0,24)
    btn.Size = UDim2.new(1,0,0,32)
    btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
    btn.Text = "  " .. (default or "Select...")
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.TextColor3 = theme.text
    btn.TextXAlignment = Enum.TextXAlignment.Left
    corner(btn,6)
    stroke(btn)

    local list = Instance.new("ScrollingFrame", self.Gui) -- ScreenGui üzerine koyalım ki kesilmesin
    list.Size = UDim2.new(0, btn.AbsoluteSize.X, 0, 0)
    list.BackgroundColor3 = Color3.fromRGB(35,35,35)
    list.BorderSizePixel = 0
    list.Visible = false
    list.ZIndex = 100
    list.ScrollBarThickness = 2
    corner(list,6)
    stroke(list)

    local listLayout = Instance.new("UIListLayout", list)
    listLayout.Padding = UDim.new(0,2)

    local function updateList()
        for _,child in pairs(list:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        for _,opt in pairs(options) do
            local oBtn = Instance.new("TextButton", list)
            oBtn.Size = UDim2.new(1,0,0,28)
            oBtn.BackgroundTransparency = 1
            oBtn.Text = opt
            oBtn.Font = Enum.Font.Gotham
            oBtn.TextSize = 12
            oBtn.TextColor3 = theme.text
            oBtn.ZIndex = 101

            oBtn.MouseButton1Click:Connect(function()
                btn.Text = "  " .. opt
                list.Visible = false
                if callback then callback(opt) end
            end)
        end
        list.CanvasSize = UDim2.new(0,0,0, #options * 30)
    end

    btn.MouseButton1Click:Connect(function()
        list.Visible = not list.Visible
        if list.Visible then
            updateList()
            list.Position = UDim2.new(0, btn.AbsolutePosition.X, 0, btn.AbsolutePosition.Y + 35)
            list.Size = UDim2.new(0, btn.AbsoluteSize.X, 0, math.min(#options * 30, 150))
        end
    end)

    return {
        SetValues = function(newOpts)
            options = newOpts
        end
    }
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

function RedX:Slider(parent, text, min, max, default, callback)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1,0,0,46)
    row.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", row)
    label.Size = UDim2.new(1,0,0,18)
    label.BackgroundTransparency = 1
    label.Text = text .. " : " .. tostring(default)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextColor3 = theme.sub
    label.TextXAlignment = Enum.TextXAlignment.Left

    local bar = Instance.new("Frame", row)
    bar.Position = UDim2.new(0,0,0,24)
    bar.Size = UDim2.new(1,0,0,12)
    bar.BackgroundColor3 = Color3.fromRGB(50,50,50)
    bar.BorderSizePixel = 0
    corner(bar,6)

    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new((default-min)/(max-min),0,1,0)
    fill.BackgroundColor3 = theme.accent
    fill.BorderSizePixel = 0
    corner(fill,6)

    local dragging = false

    local function setValueFromX(x)
        local percent = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        fill.Size = UDim2.new(percent,0,1,0)
        local value = math.floor(min + (max-min)*percent)
        label.Text = text .. " : " .. tostring(value)
        if callback then
            callback(value)
        end
    end

    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            setValueFromX(input.Position.X)
        end
    end)

    bar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            setValueFromX(input.Position.X)
        end
    end)
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

function RedX:Button(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1,0,0,32)
    btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
    btn.Text = text
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.TextColor3 = theme.text
    corner(btn,6)
    stroke(btn)
    
    addHover(btn, Color3.fromRGB(45,45,45), Color3.fromRGB(55,55,55))
    
    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
end

local ui = RedX.new("RedX Hub : Blox Fruits")

local mainMenu = ui:CreatePage("Main Menu", "rbxassetid://7733960981")
local mainMenuSec = ui:Section(mainMenu, "Main Menu")

local farm = ui:CreatePage("Farm", "rbxassetid://7733674079")
local farmSec = ui:Section(farm, "Farm")

local quests = ui:CreatePage("Quests/Items", "rbxassetid://7733914390")
local questsSec = ui:Section(quests, "Quests/Items")

local sea = ui:CreatePage("Sea", "rbxassetid://10747376931")
local seaSec = ui:Section(sea, "Sea")

local fruit = ui:CreatePage("Fruit", "rbxassetid://10709770005")
local fruitSec = ui:Section(fruit, "Fruit")

local raid = ui:CreatePage("Raid", "rbxassetid://7734056608")
local raidSec = ui:Section(raid, "Raid")

local stats = ui:CreatePage("Stats", "rbxassetid://18351727024")
local statsSec = ui:Section(stats, "Stats")

local teleport = ui:CreatePage("Teleport", "rbxassetid://6723742952")
local teleportSec = ui:Section(teleport, "Teleport")

local status = ui:CreatePage("Status", "rbxassetid://7743871002")
local statusSec = ui:Section(status, "Status")

local visual = ui:CreatePage("Visual", "rbxassetid://6031763426")
local visualSec = ui:Section(visual, "Visual")

local shop = ui:CreatePage("Shop", "rbxassetid://7734056813")
local shopSec = ui:Section(shop, "Shop")

local misc = ui:CreatePage("Misc", "rbxassetid://6031280882")
local miscSec = ui:Section(misc, "Misc")

local function toTarget(...)
    local args = {...}
    local target = args[1]
    local cf = (type(target) == "userdata" and target) or CFrame.new(unpack(args))
    
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local dist = (cf.Position - player.Character.HumanoidRootPart.Position).Magnitude
    local speed = dist > 1000 and 300 or 315
    
    local tween = TweenService:Create(player.Character.HumanoidRootPart, TweenInfo.new(dist/speed, Enum.KeyCode.Linear), {CFrame = cf})
    tween:Play()
    return tween
end

local function AttackNoCoolDown()
    local AC = debug.getupvalues(require(player.PlayerScripts.CombatFramework))[2].activeController
    if not AC then return end
    
    local bladehit = require(game.ReplicatedStorage.CombatFramework.RigLib).getBladeHits(
        player.Character,
        {player.Character.HumanoidRootPart},
        60
    )
    
    if #bladehit > 0 then
        local u8 = debug.getupvalue(AC.attack, 5)
        local u9 = debug.getupvalue(AC.attack, 6)
        local u7 = debug.getupvalue(AC.attack, 4)
        local u10 = debug.getupvalue(AC.attack, 7)
        u10 = u10 + 1
        debug.setupvalue(AC.attack, 7, u10)
        
        game:GetService("ReplicatedStorage").RigControllerEvent:FireServer("hit", bladehit, 1, "")
    end
end

local function AutoHaki()
    if not player.Character:FindFirstChild("HasBuso") then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
    end
end

local function EquipWeapon(toolName)
    if player.Backpack:FindFirstChild(toolName) then
        player.Character.Humanoid:EquipTool(player.Backpack[toolName])
    end
end

-- Variables for farming
_G.AutoLevel = false
_G.SelectMonster = ""
local Ms, NameQuest, QuestLv, NameMon, CFrameQ, CFrameMon
local posX, posY, posZ = 0, 25, 0

local First_Sea, Second_Sea, Third_Sea = false, false, false
local placeId = game.PlaceId
if placeId == 2753915549 then First_Sea = true elseif placeId == 4442272183 then Second_Sea = true elseif placeId == 7449423635 then Third_Sea = true end

local function CheckLevel()
    local Lv = player.Data.Level.Value
    if First_Sea then
        if Lv >= 1 and Lv <= 9 then
            Ms = "Bandit"; NameQuest = "BanditQuest1"; QuestLv = 1; NameMon = "Bandit"
            CFrameQ = CFrame.new(1060.9, 16.5, 1547.8); CFrameMon = CFrame.new(1038.5, 41.3, 1576.5)
        elseif Lv >= 10 and Lv <= 14 then
            Ms = "Monkey"; NameQuest = "JungleQuest"; QuestLv = 1; NameMon = "Monkey"
            CFrameQ = CFrame.new(-1601.7, 36.9, 153.4); CFrameMon = CFrame.new(-1448.1, 50.9, 63.6)
        elseif Lv >= 15 and Lv <= 29 then
            Ms = "Gorilla"; NameQuest = "JungleQuest"; QuestLv = 2; NameMon = "Gorilla"
            CFrameQ = CFrame.new(-1601.7, 36.9, 153.4); CFrameMon = CFrame.new(-1142.6, 40.5, -515.4)
        elseif Lv >= 30 and Lv <= 39 then
            Ms = "Pirate"; NameQuest = "BuggyQuest1"; QuestLv = 1; NameMon = "Pirate"
            CFrameQ = CFrame.new(-1140.2, 4.8, 3827.4); CFrameMon = CFrame.new(-1201.1, 40.6, 3857.6)
        elseif Lv >= 40 and Lv <= 59 then
            Ms = "Brute"; NameQuest = "BuggyQuest1"; QuestLv = 2; NameMon = "Brute"
            CFrameQ = CFrame.new(-1140.2, 4.8, 3827.4); CFrameMon = CFrame.new(-1387.5, 24.6, 4101.0)
        elseif Lv >= 60 and Lv <= 74 then
            Ms = "Desert Bandit"; NameQuest = "DesertQuest"; QuestLv = 1; NameMon = "Desert Bandit"
            CFrameQ = CFrame.new(896.5, 6.4, 4390.1); CFrameMon = CFrame.new(985.0, 16.1, 4417.9)
        elseif Lv >= 75 and Lv <= 89 then
            Ms = "Desert Officer"; NameQuest = "DesertQuest"; QuestLv = 2; NameMon = "Desert Officer"
            CFrameQ = CFrame.new(896.5, 6.4, 4390.1); CFrameMon = CFrame.new(1547.2, 14.5, 4381.8)
        elseif Lv >= 90 and Lv <= 99 then
            Ms = "Snow Bandit"; NameQuest = "SnowQuest"; QuestLv = 1; NameMon = "Snow Bandit"
            CFrameQ = CFrame.new(1386.8, 87.3, -1298.4); CFrameMon = CFrame.new(1356.3, 105.8, -1328.2)
        elseif Lv >= 100 and Lv <= 119 then
            Ms = "Snowman"; NameQuest = "SnowQuest"; QuestLv = 2; NameMon = "Snowman"
            CFrameQ = CFrame.new(1386.8, 87.3, -1298.4); CFrameMon = CFrame.new(1218.8, 138.0, -1488.0)
        elseif Lv >= 120 and Lv <= 149 then
            Ms = "Chief Petty Officer"; NameQuest = "MarineQuest2"; QuestLv = 1; NameMon = "Chief Petty Officer"
            CFrameQ = CFrame.new(-5035.5, 28.7, 4324.2); CFrameMon = CFrame.new(-4931.2, 65.8, 4121.8)
        elseif Lv >= 150 and Lv <= 174 then
            Ms = "Sky Bandit"; NameQuest = "SkyQuest"; QuestLv = 1; NameMon = "Sky Bandit"
            CFrameQ = CFrame.new(-4842.1, 717.7, -2623.0); CFrameMon = CFrame.new(-4955.6, 365.5, -2908.2)
        elseif Lv >= 175 and Lv <= 189 then
            Ms = "Dark Master"; NameQuest = "SkyQuest"; QuestLv = 2; NameMon = "Dark Master"
            CFrameQ = CFrame.new(-4842.1, 717.7, -2623.0); CFrameMon = CFrame.new(-5148.2, 439.0, -2333.0)
        elseif Lv >= 190 and Lv <= 209 then
            Ms = "Prisoner"; NameQuest = "PrisonerQuest"; QuestLv = 1; NameMon = "Prisoner"
            CFrameQ = CFrame.new(5310.6, 0.4, 474.9); CFrameMon = CFrame.new(4937.3, 0.3, 649.6)
        elseif Lv >= 210 and Lv <= 249 then
            Ms = "Dangerous Prisoner"; NameQuest = "PrisonerQuest"; QuestLv = 2; NameMon = "Dangerous Prisoner"
            CFrameQ = CFrame.new(5310.6, 0.4, 474.9); CFrameMon = CFrame.new(5099.7, 0.4, 1055.8)
        elseif Lv >= 250 and Lv <= 274 then
            Ms = "Toga Warrior"; NameQuest = "ColosseumQuest"; QuestLv = 1; NameMon = "Toga Warrior"
            CFrameQ = CFrame.new(-1577.8, 7.4, -2984.5); CFrameMon = CFrame.new(-1872.5, 49.1, -2913.8)
        elseif Lv >= 275 and Lv <= 299 then
            Ms = "Gladiator"; NameQuest = "ColosseumQuest"; QuestLv = 2; NameMon = "Gladiator"
            CFrameQ = CFrame.new(-1577.8, 7.4, -2984.5); CFrameMon = CFrame.new(-1521.4, 81.2, -3066.3)
        elseif Lv >= 300 and Lv <= 324 then
            Ms = "Military Soldier"; NameQuest = "MagmaQuest"; QuestLv = 1; NameMon = "Military Soldier"
            CFrameQ = CFrame.new(-5316.1, 12.3, 8517.0); CFrameMon = CFrame.new(-5369.0, 61.2, 8556.5)
        elseif Lv >= 325 and Lv <= 374 then
            Ms = "Military Spy"; NameQuest = "MagmaQuest"; QuestLv = 2; NameMon = "Military Spy"
            CFrameQ = CFrame.new(-5316.1, 12.3, 8517.0); CFrameMon = CFrame.new(-5787.0, 75.8, 8651.7)
        elseif Lv >= 375 and Lv <= 399 then
            Ms = "Fishman Warrior"; NameQuest = "FishmanQuest"; QuestLv = 1; NameMon = "Fishman Warrior"
            CFrameQ = CFrame.new(61122.7, 18.5, 1569.4); CFrameMon = CFrame.new(60844.1, 98.5, 1298.4)
        elseif Lv >= 400 and Lv <= 449 then
            Ms = "Fishman Commando"; NameQuest = "FishmanQuest"; QuestLv = 2; NameMon = "Fishman Commando"
            CFrameQ = CFrame.new(61122.7, 18.5, 1569.4); CFrameMon = CFrame.new(61738.4, 64.2, 1433.8)
        elseif Lv >= 450 and Lv <= 474 then
            Ms = "God's Guard"; NameQuest = "SkyExp1Quest"; QuestLv = 1; NameMon = "God's Guard"
            CFrameQ = CFrame.new(-4721.9, 845.3, -1953.8); CFrameMon = CFrame.new(-4628.0, 866.9, -1931.2)
        elseif Lv >= 475 and Lv <= 524 then
            Ms = "Shanda"; NameQuest = "SkyExp1Quest"; QuestLv = 2; NameMon = "Shanda"
            CFrameQ = CFrame.new(-7863.2, 5545.5, -378.4); CFrameMon = CFrame.new(-7685.1, 5601.1, -441.4)
        elseif Lv >= 525 and Lv <= 549 then
            Ms = "Royal Squad"; NameQuest = "SkyExp2Quest"; QuestLv = 1; NameMon = "Royal Squad"
            CFrameQ = CFrame.new(-7903.4, 5636.0, -1410.9); CFrameMon = CFrame.new(-7654.3, 5637.1, -1407.8)
        elseif Lv >= 550 and Lv <= 624 then
            Ms = "Royal Soldier"; NameQuest = "SkyExp2Quest"; QuestLv = 2; NameMon = "Royal Soldier"
            CFrameQ = CFrame.new(-7903.4, 5636.0, -1410.9); CFrameMon = CFrame.new(-7760.4, 5679.9, -1884.8)
        elseif Lv >= 625 and Lv <= 649 then
            Ms = "Galley Pirate"; NameQuest = "FountainQuest"; QuestLv = 1; NameMon = "Galley Pirate"
            CFrameQ = CFrame.new(5258.3, 38.5, 4050.0); CFrameMon = CFrame.new(5557.2, 152.3, 3998.8)
        elseif Lv >= 650 then
            Ms = "Galley Captain"; NameQuest = "FountainQuest"; QuestLv = 2; NameMon = "Galley Captain"
            CFrameQ = CFrame.new(5258.3, 38.5, 4050.0); CFrameMon = CFrame.new(5677.7, 92.8, 4966.6)
        end
    elseif Second_Sea then
        if Lv >= 700 and Lv <= 724 then
            Ms = "Raider"; NameQuest = "Area1Quest"; QuestLv = 1; NameMon = "Raider"
            CFrameQ = CFrame.new(-427.7, 73.0, 1835.9); CFrameMon = CFrame.new(68.9, 93.6, 2429.7)
        elseif Lv >= 725 and Lv <= 774 then
            Ms = "Mercenary"; NameQuest = "Area1Quest"; QuestLv = 2; NameMon = "Mercenary"
            CFrameQ = CFrame.new(-427.7, 73.0, 1835.9); CFrameMon = CFrame.new(-864.9, 122.5, 1453.2)
        elseif Lv >= 775 and Lv <= 799 then
            Ms = "Swan Pirate"; NameQuest = "Area2Quest"; QuestLv = 1; NameMon = "Swan Pirate"
            CFrameQ = CFrame.new(635.6, 73.1, 917.8); CFrameMon = CFrame.new(1065.4, 137.6, 1324.4)
        elseif Lv >= 800 and Lv <= 874 then
            Ms = "Factory Staff"; NameQuest = "Area2Quest"; QuestLv = 2; NameMon = "Factory Staff"
            CFrameQ = CFrame.new(635.6, 73.1, 917.8); CFrameMon = CFrame.new(533.2, 128.5, 355.6)
        elseif Lv >= 875 and Lv <= 899 then
            Ms = "Marine Lieutenant"; NameQuest = "MarineQuest3"; QuestLv = 1; NameMon = "Marine Lieutenant"
            CFrameQ = CFrame.new(-2441.0, 73.0, -3217.7); CFrameMon = CFrame.new(-2489.3, 84.6, -3151.9)
        elseif Lv >= 900 and Lv <= 949 then
            Ms = "Marine Captain"; NameQuest = "MarineQuest3"; QuestLv = 2; NameMon = "Marine Captain"
            CFrameQ = CFrame.new(-2441.0, 73.0, -3217.7); CFrameMon = CFrame.new(-2335.2, 79.8, -3245.9)
        elseif Lv >= 950 and Lv <= 974 then
            Ms = "Zombie"; NameQuest = "ZombieQuest"; QuestLv = 1; NameMon = "Zombie"
            CFrameQ = CFrame.new(-5494.3, 48.5, -794.6); CFrameMon = CFrame.new(-5536.5, 101.1, -835.6)
        elseif Lv >= 975 and Lv <= 999 then
            Ms = "Vampire"; NameQuest = "ZombieQuest"; QuestLv = 2; NameMon = "Vampire"
            CFrameQ = CFrame.new(-5494.3, 48.5, -794.6); CFrameMon = CFrame.new(-5806.1, 16.7, -1164.4)
        elseif Lv >= 1000 and Lv <= 1049 then
            Ms = "Snow Trooper"; NameQuest = "SnowMountainQuest"; QuestLv = 1; NameMon = "Snow Trooper"
            CFrameQ = CFrame.new(607.1, 401.4, -5370.6); CFrameMon = CFrame.new(535.2, 432.7, -5484.9)
        elseif Lv >= 1050 and Lv <= 1099 then
            Ms = "Winter Warrior"; NameQuest = "SnowMountainQuest"; QuestLv = 2; NameMon = "Winter Warrior"
            CFrameQ = CFrame.new(607.1, 401.4, -5370.6); CFrameMon = CFrame.new(1234.4, 457.0, -5174.1)
        elseif Lv >= 1100 and Lv <= 1124 then
            Ms = "Lab Subordinate"; NameQuest = "IceSideQuest"; QuestLv = 1; NameMon = "Lab Subordinate"
            CFrameQ = CFrame.new(-6061.8, 15.9, -4902.0); CFrameMon = CFrame.new(-5720.6, 63.3, -4784.6)
        elseif Lv >= 1125 and Lv <= 1174 then
            Ms = "Horned Warrior"; NameQuest = "IceSideQuest"; QuestLv = 2; NameMon = "Horned Warrior"
            CFrameQ = CFrame.new(-6061.8, 15.9, -4902.0); CFrameMon = CFrame.new(-6292.8, 91.2, -5502.6)
        elseif Lv >= 1175 and Lv <= 1199 then
            Ms = "Magma Ninja"; NameQuest = "FireSideQuest"; QuestLv = 1; NameMon = "Magma Ninja"
            CFrameQ = CFrame.new(-5429.0, 16.0, -5298.0); CFrameMon = CFrame.new(-5461.8, 130.4, -5836.5)
        elseif Lv >= 1200 and Lv <= 1249 then
            Ms = "Lava Pirate"; NameQuest = "FireSideQuest"; QuestLv = 2; NameMon = "Lava Pirate"
            CFrameQ = CFrame.new(-5429.0, 16.0, -5298.0); CFrameMon = CFrame.new(-5251.2, 55.2, -4774.4)
        elseif Lv >= 1250 and Lv <= 1274 then
            Ms = "Ship Deckhand"; NameQuest = "ShipQuest1"; QuestLv = 1; NameMon = "Ship Deckhand"
            CFrameQ = CFrame.new(1040.3, 125.1, 32911.0); CFrameMon = CFrame.new(921.1, 126.0, 33088.3)
        elseif Lv >= 1275 and Lv <= 1299 then
            Ms = "Ship Engineer"; NameQuest = "ShipQuest1"; QuestLv = 2; NameMon = "Ship Engineer"
            CFrameQ = CFrame.new(1040.3, 125.1, 32911.0); CFrameMon = CFrame.new(886.3, 40.5, 32800.8)
        elseif Lv >= 1300 and Lv <= 1324 then
            Ms = "Ship Steward"; NameQuest = "ShipQuest2"; QuestLv = 1; NameMon = "Ship Steward"
            CFrameQ = CFrame.new(971.4, 125.1, 33245.5); CFrameMon = CFrame.new(943.9, 129.6, 33444.4)
        elseif Lv >= 1325 and Lv <= 1349 then
            Ms = "Ship Officer"; NameQuest = "ShipQuest2"; QuestLv = 2; NameMon = "Ship Officer"
            CFrameQ = CFrame.new(971.4, 125.1, 33245.5); CFrameMon = CFrame.new(955.4, 181.1, 33331.9)
        elseif Lv >= 1350 and Lv <= 1374 then
            Ms = "Arctic Warrior"; NameQuest = "FrostQuest"; QuestLv = 1; NameMon = "Arctic Warrior"
            CFrameQ = CFrame.new(5668.1, 28.2, -6484.6); CFrameMon = CFrame.new(5935.5, 77.3, -6472.8)
        elseif Lv >= 1375 and Lv <= 1424 then
            Ms = "Snow Lurker"; NameQuest = "FrostQuest"; QuestLv = 2; NameMon = "Snow Lurker"
            CFrameQ = CFrame.new(5668.1, 28.2, -6484.6); CFrameMon = CFrame.new(5628.5, 57.6, -6618.3)
        elseif Lv >= 1425 and Lv <= 1449 then
            Ms = "Sea Soldier"; NameQuest = "ForgottenQuest"; QuestLv = 1; NameMon = "Sea Soldier"
            CFrameQ = CFrame.new(-3054.6, 236.9, -10147.8); CFrameMon = CFrame.new(-3185.0, 58.8, -9663.6)
        elseif Lv >= 1450 then
            Ms = "Water Fighter"; NameQuest = "ForgottenQuest"; QuestLv = 2; NameMon = "Water Fighter"
            CFrameQ = CFrame.new(-3054.6, 236.9, -10147.8); CFrameMon = CFrame.new(-3262.9, 298.7, -10552.5)
        end
    elseif Third_Sea then
        if Lv >= 1500 and Lv <= 1524 then
            Ms = "Pirate Millionaire"; NameQuest = "PiratePortQuest"; QuestLv = 1; NameMon = "Pirate Millionaire"
            CFrameQ = CFrame.new(-289.6, 43.8, 5580.1); CFrameMon = CFrame.new(-435.7, 189.7, 5551.1)
        elseif Lv >= 1525 and Lv <= 1574 then
            Ms = "Pistol Billionaire"; NameQuest = "PiratePortQuest"; QuestLv = 2; NameMon = "Pistol Billionaire"
            CFrameQ = CFrame.new(-289.6, 43.8, 5580.1); CFrameMon = CFrame.new(-236.5, 217.5, 6006.1)
        -- [Diğer leveller buraya eklenecek]
        end
    end
end

local tableMon, AreaList = {}, {}
if First_Sea then
    tableMon = {"Bandit","Monkey","Gorilla","Pirate","Brute","Desert Bandit","Desert Officer","Snow Bandit","Snowman","Chief Petty Officer","Sky Bandit","Dark Master","Prisoner","Dangerous Prisoner","Toga Warrior","Gladiator","Military Soldier","Military Spy","Fishman Warrior","Fishman Commando","God's Guard","Shanda","Royal Squad","Royal Soldier","Galley Pirate","Galley Captain"}
    AreaList = {'Jungle', 'Buggy', 'Desert', 'Snow', 'Marine', 'Sky', 'Prison', 'Colosseum', 'Magma', 'Fishman', 'Sky Island', 'Fountain'}
elseif Second_Sea then
    tableMon = {"Raider","Mercenary","Swan Pirate","Factory Staff","Marine Lieutenant","Marine Captain","Zombie","Vampire","Snow Trooper","Winter Warrior","Lab Subordinate","Horned Warrior","Magma Ninja","Lava Pirate","Ship Deckhand","Ship Engineer","Ship Steward","Ship Officer","Arctic Warrior","Snow Lurker","Sea Soldier","Water Fighter"}
    AreaList = {'Area 1', 'Area 2', 'Zombie', 'Marine', 'Snow Mountain', 'Ice fire', 'Ship', 'Frost', 'Forgotten'}
elseif Third_Sea then
    tableMon = {"Pirate Millionaire","Dragon Crew Warrior","Dragon Crew Archer","Female Islander","Giant Islander","Marine Commodore","Marine Rear Admiral","Fishman Raider","Fishman Captain","Forest Pirate","Mythological Pirate","Jungle Pirate","Musketeer Pirate","Reborn Skeleton","Living Zombie","Demonic Soul","Posessed Mummy","Peanut Scout","Peanut President","Ice Cream Chef","Ice Cream Commander","Cookie Crafter","Cake Guard","Baking Staff","Head Baker","Cocoa Warrior","Chocolate Bar Battler","Sweet Thief","Candy Rebel","Candy Pirate","Snow Demon","Isle Outlaw","Island Boy","Isle Champion"}
    AreaList = {'Pirate Port', 'Amazon', 'Marine Tree', 'Deep Forest', 'Haunted Castle', 'Nut Island', 'Ice Cream Island', 'Cake Island', 'Choco Island', 'Candy Island','Tiki Outpost'}
end

local BossList, MaterialList = {}, {}
if First_Sea then
    BossList = {"The Gorilla King", "Bobby", "The Saw", "Yeti", "Mob Leader", "Vice Admiral", "Saber Expert", "Warden", "Chief Warden", "Swan", "Magma Admiral", "Fishman Lord", "Wysper", "Thunder God", "Cyborg", "Ice Admiral", "Greybeard"}
elseif Second_Sea then
    BossList = {"Diamond", "Jeremy", "Fajita", "Don Swan", "Smoke Admiral", "Awakened Ice Admiral", "Tide Keeper", "Darkbeard", "Cursed Captain", "Order"}
elseif Third_Sea then
    BossList = {"Stone", "Island Empress", "Kilo Admiral", "Captain Elephant", "Beautiful Pirate", "Cake Queen", "Longma", "Soul Reaper", "rip_indra True Form"}
end
MaterialList = {"Radioactive Material", "Mystic Droplet", "Magma Ore", "Angel Wings", "Leather", "Scrap Metal", "Fish Tail", "Demonic Wisp", "Vampire Fang", "Conjured Cocoa", "Dragon Scale", "Gunpowder", "Mini Tusk"}

local BossMon, NameBoss, NameQuestBoss, QuestLvBoss, CFrameQBoss, CFrameBoss
local function CheckBossQuest()
    if First_Sea then
        if _G.SelectBoss == "The Gorilla King" then
            BossMon = "The Gorilla King"; NameBoss = "The Gorilla King"; NameQuestBoss = "JungleQuest"; QuestLvBoss = 3
            CFrameQBoss = CFrame.new(-1601.7, 36.9, 153.4); CFrameBoss = CFrame.new(-1088.8, 8.1, -488.6)
        -- ... [Diğer bosslar eklenebilir]
        end
    end
end

local MMon, MPos
local function MaterialMon()
    if _G.SelectMaterial == "Radioactive Material" then
        MMon = "Factory Staff"; MPos = CFrame.new(295,73,-56)
    elseif _G.SelectMaterial == "Mystic Droplet" then
        MMon = "Water Fighter"; MPos = CFrame.new(-3385,239,-10542)
    -- ... [Diğer materyaller]
    end
end

ui:Dropdown(questsSec, "Select Boss", BossList, "None", function(v) _G.SelectBoss = v end)
ui:Toggle(questsSec, "Auto Farm Boss", function(v) _G.AutoBoss = v end)

ui:Dropdown(questsSec, "Select Material", MaterialList, "None", function(v) _G.SelectMaterial = v end)
ui:Toggle(questsSec, "Auto Farm Material", function(v) _G.AutoMaterial = v end)

-- ESP Functions
local function CreateESP(part, text, color)
    if part:FindFirstChild("RedX_ESP") then return end
    local bg = Instance.new("BillboardGui", part)
    bg.Name = "RedX_ESP"
    bg.AlwaysOnTop = true
    bg.Size = UDim2.new(0, 200, 0, 50)
    bg.StudsOffset = Vector3.new(0, 3, 0)
    
    local tl = Instance.new("TextLabel", bg)
    tl.BackgroundTransparency = 1
    tl.Size = UDim2.new(1, 0, 1, 0)
    tl.Text = text
    tl.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    tl.Font = Enum.Font.GothamBold
    tl.TextSize = 14
    tl.TextStrokeTransparency = 0.5
end

ui:Toggle(visualSec, "Player ESP", function(v)
    _G.PlayerESP = v
    if not v then
        for _,p in pairs(game.Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("Head") and p.Character.Head:FindFirstChild("RedX_ESP") then
                p.Character.Head.RedX_ESP:Destroy()
            end
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        if _G.PlayerESP then
            for _,p in pairs(game.Players:GetPlayers()) do
                if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
                    CreateESP(p.Character.Head, p.Name, Color3.fromRGB(255, 50, 50))
                end
            end
        end
    end
end)

ui:Toggle(miscSec, "Anti AFK", function(v)
    _G.AntiAFK = v
end)

ui:Button(miscSec, "FPS Booster", function()
    local decalsyeeted = true
    local g = game
    local w = g.Workspace
    local l = g.Lighting
    local t = w.Terrain
    sethiddenproperty(l,"Technology",2)
    sethiddenproperty(t,"Decoration",false)
    t.WaterWaveSize = 0
    t.WaterWaveSpeed = 0
    t.WaterReflectance = 0
    t.WaterTransparency = 0
    l.GlobalShadows = false
    l.FogEnd = 9e9
    l.Brightness = 0
    settings().Rendering.QualityLevel = "Level01"
    for i, v in pairs(g:GetDescendants()) do
        if v:IsA("Part") or v:IsA("Union") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
            v.Material = "Plastic"; v.Reflectance = 0
        elseif v:IsA("Decal") or v:IsA("Texture") and decalsyeeted then
            v.Transparency = 1
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Lifetime = NumberRange.new(0)
        end
    end
end)

ui:Button(miscSec, "Auto Redeem Codes", function()
    local codes = {"CHANDLER", "REWARDSCODE", "NEWTROLL", "KITT_RESET", "Sub2CaptainMaui"}
    for _,c in pairs(codes) do
        game:GetService("ReplicatedStorage").Remotes.Redeem:InvokeServer(c)
    end
end)

ui:Toggle(farmSec, "Auto Chest Farm", function(v)
    _G.AutoChest = v
end)

ui:Toggle(miscSec, "Speed Hack", function(v)
    if v then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 50
    else
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

ui:Toggle(miscSec, "High Jump", function(v)
    if v then
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = 100
    else
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
    end
end)

ui:Toggle(miscSec, "Fly", function(v)
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

-- Farm Settings
ui:Toggle(farmSec, "Auto Farm Level", function(v)
    _G.AutoLevel = v
end)

ui:Dropdown(farmSec, "Select Weapon", {"Melee", "Sword", "Blox Fruit"}, "Melee", function(v)
    _G.SelectWeaponType = v
end)

ui:Dropdown(farmSec, "Select Monster", tableMon, "None", function(v)
    _G.SelectMonster = v
end)

ui:Dropdown(farmSec, "Select Area", AreaList, "None", function(v)
    _G.SelectArea = v
end)

local function GetWeapon()
    for _,v in pairs(player.Backpack:GetChildren()) do
        if v:IsA("Tool") and v.ToolTip == _G.SelectWeaponType then
            return v.Name
        end
    end
    for _,v in pairs(player.Character:GetChildren()) do
        if v:IsA("Tool") and v.ToolTip == _G.SelectWeaponType then
            return v.Name
        end
    end
end

task.spawn(function()
    while task.wait() do
        if _G.AutoLevel then
            pcall(function()
                CheckLevel()
                local questTitle = player.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
                if not string.find(questTitle, NameMon or "") or not player.PlayerGui.Main.Quest.Visible then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                    toTarget(CFrameQ)
                    if (CFrameQ.Position - player.Character.HumanoidRootPart.Position).Magnitude <= 15 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", NameQuest, QuestLv)
                    end
                else
                    for _,v in pairs(game.Workspace.Enemies:GetChildren()) do
                        if v.Name == Ms and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                            repeat task.wait()
                                AutoHaki()
                                EquipWeapon(GetWeapon())
                                toTarget(v.HumanoidRootPart.CFrame * CFrame.new(0, 25, 0))
                                AttackNoCoolDown()
                            until not _G.AutoLevel or v.Humanoid.Health <= 0 or not v.Parent
                        end
                    end
                end
            end)
        elseif _G.AutoBoss then
            pcall(function()
                CheckBossQuest()
                -- Benzer boss farm mantığı
            end)
        elseif _G.AutoMaterial then
            pcall(function()
                MaterialMon()
                -- Benzer materyal farm mantığı
            end)
        elseif _G.AutoChest then
            pcall(function()
                for _,v in pairs(game.Workspace:GetChildren()) do
                    if string.find(v.Name, "Chest") and (v.Position - player.Character.HumanoidRootPart.Position).Magnitude < 5000 then
                        repeat task.wait()
                            toTarget(v.CFrame)
                        until not _G.AutoChest or not v.Parent or (v.Position - player.Character.HumanoidRootPart.Position).Magnitude < 5
                    end
                end
            end)
        end
    end
end)

-- Background Anti AFK
player.Idled:connect(function()
    if _G.AntiAFK then
        game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        task.wait(1)
        game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end
end)

return RedX;
