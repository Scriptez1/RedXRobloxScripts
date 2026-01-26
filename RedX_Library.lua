local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")

local RedX = {}
RedX.__index = RedX

local theme = {
    Bg = Color3.fromRGB(18,18,18),
    Panel = Color3.fromRGB(28,28,28),
    Card = Color3.fromRGB(36,36,36),
    Accent = Color3.fromRGB(220,20,60),
    Text = Color3.fromRGB(240,240,240),
    Sub = Color3.fromRGB(170,170,170)
}

local function corner(o,r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,r)
    c.Parent = o
end

local function stroke(o,t)
    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(60,60,60)
    s.Thickness = t
    s.Parent = o
end

function RedX.new(title)
    local self = setmetatable({}, RedX)

    self.Gui = Instance.new("ScreenGui", guiParent)
    self.Gui.ResetOnSpawn = false

    local main = Instance.new("Frame", self.Gui)
    main.Size = UDim2.new(0.7,0,0.75,0)
    main.Position = UDim2.new(0.15,0,0.12,0)
    main.BackgroundColor3 = theme.Bg
    corner(main,16)

    local sidebar = Instance.new("Frame", main)
    sidebar.Size = UDim2.new(0,180,1,0)
    sidebar.BackgroundColor3 = theme.Panel
    corner(sidebar,16)

    local header = Instance.new("TextLabel", main)
    header.Size = UDim2.new(1,-200,0,50)
    header.Position = UDim2.new(0,190,0,10)
    header.BackgroundTransparency = 1
    header.Text = title
    header.Font = Enum.Font.GothamBold
    header.TextSize = 20
    header.TextColor3 = theme.Text
    header.TextXAlignment = Enum.TextXAlignment.Left

    local content = Instance.new("ScrollingFrame", main)
    content.Position = UDim2.new(0,190,0,60)
    content.Size = UDim2.new(1,-200,1,-70)
    content.CanvasSize = UDim2.new(0,0,0,0)
    content.ScrollBarThickness = 4
    content.BackgroundTransparency = 1

    local layout = Instance.new("UIListLayout", content)
    layout.Padding = UDim.new(0,10)

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        content.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+10)
    end)

    self.Content = content
    self.Sidebar = sidebar

    return self
end

function RedX:Section(name)
    local card = Instance.new("Frame", self.Content)
    card.Size = UDim2.new(1,0,0,80)
    card.BackgroundColor3 = theme.Card
    corner(card,12)
    stroke(card,1)

    local title = Instance.new("TextLabel", card)
    title.Position = UDim2.new(0,15,0,10)
    title.Size = UDim2.new(1,-30,0,25)
    title.BackgroundTransparency = 1
    title.Text = name
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.TextColor3 = theme.Text
    title.TextXAlignment = Enum.TextXAlignment.Left

    local holder = Instance.new("Frame", card)
    holder.Position = UDim2.new(0,10,0,40)
    holder.Size = UDim2.new(1,-20,0,30)
    holder.BackgroundTransparency = 1

    return holder
end

function RedX:Toggle(parent, text, callback)
    local toggle = Instance.new("Frame", parent)
    toggle.Size = UDim2.new(1,0,1,0)
    toggle.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", toggle)
    label.Size = UDim2.new(0.7,0,1,0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextColor3 = theme.Sub
    label.TextXAlignment = Enum.TextXAlignment.Left

    local button = Instance.new("TextButton", toggle)
    button.Size = UDim2.new(0,40,0,20)
    button.Position = UDim2.new(1,-45,0.5,-10)
    button.BackgroundColor3 = Color3.fromRGB(60,60,60)
    button.Text = ""
    corner(button,20)

    local on = false

    button.MouseButton1Click:Connect(function()
        on = not on
        button.BackgroundColor3 = on and theme.Accent or Color3.fromRGB(60,60,60)
        if callback then callback(on) end
    end)
end
