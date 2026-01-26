local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

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
    Instance.new("UICorner",o).CornerRadius = UDim.new(0,r)
end

local function stroke(o)
    local s = Instance.new("UIStroke",o)
    s.Color = theme.stroke
end

local function dragify(frame)
    local dragToggle, dragInput, dragStart, startPos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragToggle = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragToggle then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

local RedX = {}
RedX.__index = RedX

function RedX.new(title)
    local self = setmetatable({},RedX)

    local gui = Instance.new("ScreenGui", guiParent)
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true

    local main = Instance.new("Frame", gui)
    main.Size = UDim2.fromScale(0.75,0.8)
    main.Position = UDim2.fromScale(0.125,0.1)
    main.BackgroundColor3 = theme.bg
    main.BorderSizePixel = 0
    corner(main,14)
    dragify(main)

    local sidebar = Instance.new("Frame", main)
    sidebar.Size = UDim2.new(0,200,1,0)
    sidebar.BackgroundColor3 = theme.panel
    sidebar.BorderSizePixel = 0
    corner(sidebar,14)

    local sidebarLayout = Instance.new("UIListLayout", sidebar)
    sidebarLayout.Padding = UDim.new(0,8)

    local logo = Instance.new("TextLabel", sidebar)
    logo.Size = UDim2.new(1,0,0,50)
    logo.Text = "RedX"
    logo.Font = Enum.Font.GothamBold
    logo.TextSize = 20
    logo.TextColor3 = theme.accent
    logo.BackgroundTransparency = 1
    logo.LayoutOrder = -1

    local header = Instance.new("Frame", main)
    header.Size = UDim2.new(1,-200,0,50)
    header.Position = UDim2.new(0,200,0,0)
    header.BackgroundTransparency = 1

    local titleLbl = Instance.new("TextLabel", header)
    titleLbl.Size = UDim2.new(1,-100,1,0)
    titleLbl.Position = UDim2.new(0,20,0,0)
    titleLbl.Text = title
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 20
    titleLbl.TextColor3 = theme.text
    titleLbl.BackgroundTransparency = 1
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left

    local minimize = Instance.new("TextButton", header)
    minimize.Size = UDim2.new(0,32,0,32)
    minimize.Position = UDim2.new(1,-70,0.5,-16)
    minimize.Text = "−"
    minimize.BackgroundColor3 = Color3.fromRGB(40,40,40)
    corner(minimize,6)

    local close = Instance.new("TextButton", header)
    close.Size = UDim2.new(0,32,0,32)
    close.Position = UDim2.new(1,-32,0.5,-16)
    close.Text = "×"
    close.BackgroundColor3 = Color3.fromRGB(40,40,40)
    corner(close,6)

    local mini = Instance.new("Frame", gui)
    mini.Size = UDim2.new(0,60,0,60)
    mini.Position = UDim2.new(0,20,0,20)
    mini.BackgroundColor3 = theme.panel
    mini.Visible = false
    corner(mini,12)
    dragify(mini)

    local miniBtn = Instance.new("TextButton", mini)
    miniBtn.Size = UDim2.fromScale(1,1)
    miniBtn.Text = "RX"
    miniBtn.BackgroundTransparency = 1
    miniBtn.TextColor3 = theme.accent
    miniBtn.Font = Enum.Font.GothamBold

    minimize.MouseButton1Click:Connect(function()
        TweenService:Create(main,TweenInfo.new(0.25),{
            Size = UDim2.fromOffset(0,0)
        }):Play()
        task.wait(0.25)
        main.Visible = false
        mini.Visible = true
    end)

    miniBtn.MouseButton1Click:Connect(function()
        main.Visible = true
        main.Size = UDim2.fromOffset(0,0)
        TweenService:Create(main,TweenInfo.new(0.25),{
            Size = UDim2.fromScale(0.75,0.8)
        }):Play()
        mini.Visible = false
    end)

    close.MouseButton1Click:Connect(function()
        TweenService:Create(main,TweenInfo.new(0.2),{
            Position = UDim2.new(0,0,0,0),
            Size = UDim2.fromOffset(0,0)
        }):Play()
        task.wait(0.2)
        gui:Destroy()
    end)

    self.Main = main
    self.Sidebar = sidebar
    self.Pages = {}

    return self
end

function RedX:CreatePage(name)
    local btn = Instance.new("TextButton", self.Sidebar)
    btn.Size = UDim2.new(1,0,0,40)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(32,32,32)
    btn.TextColor3 = theme.text
    corner(btn,8)

    local page = Instance.new("ScrollingFrame", self.Main)
    page.Position = UDim2.new(0,210,0,60)
    page.Size = UDim2.new(1,-220,1,-70)
    page.CanvasSize = UDim2.new(0,0,0,0)
    page.ScrollBarThickness = 4
    page.Visible = false
    page.BackgroundTransparency = 1

    btn.MouseButton1Click:Connect(function()
        for _,p in pairs(self.Pages) do
            p.Visible = false
        end
        page.Visible = true
    end)

    table.insert(self.Pages,page)

    if #self.Pages == 1 then
        page.Visible = true
    end

    return page
end

function RedX:Section(page,title)
    local f = Instance.new("Frame",page)
    f.Size = UDim2.new(1,-10,0,60)
    f.BackgroundColor3 = theme.card
    corner(f,10)
    stroke(f)

    local l = Instance.new("TextLabel",f)
    l.Size = UDim2.new(1,0,1,0)
    l.Text = title
    l.BackgroundTransparency = 1
    l.TextColor3 = theme.text

    return f
end

function RedX:Toggle(parent,text,callback)
    local b = Instance.new("TextButton",parent)
    b.Size = UDim2.new(1,0,1,0)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(50,50,50)
    b.TextColor3 = theme.text
    corner(b,8)

    local on = false
    b.MouseButton1Click:Connect(function()
        on = not on
        b.BackgroundColor3 = on and theme.accent or Color3.fromRGB(50,50,50)
        if callback then callback(on) end
    end)
end

return RedX
