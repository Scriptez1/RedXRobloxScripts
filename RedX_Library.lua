local Players = game:GetService("Players")
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

local RedX = {}
RedX.__index = RedX

function RedX.new(title)
    local self = setmetatable({},RedX)

    local gui = Instance.new("ScreenGui", guiParent)
    gui.ResetOnSpawn = false

    local main = Instance.new("Frame", gui)
    main.Size = UDim2.fromScale(0.75,0.8)
    main.Position = UDim2.fromScale(0.125,0.1)
    main.BackgroundColor3 = theme.bg
    corner(main,14)

    local sidebar = Instance.new("Frame", main)
    sidebar.Size = UDim2.new(0,190,1,0)
    sidebar.BackgroundColor3 = theme.panel
    corner(sidebar,14)

    local sidebarLayout = Instance.new("UIListLayout", sidebar)
    sidebarLayout.Padding = UDim.new(0,6)

    local header = Instance.new("TextLabel", main)
    header.Text = title
    header.Font = Enum.Font.GothamBold
    header.TextSize = 20
    header.TextColor3 = theme.text
    header.BackgroundTransparency = 1
    header.Position = UDim2.new(0,210,0,15)
    header.Size = UDim2.new(1,-220,0,30)
    header.TextXAlignment = Enum.TextXAlignment.Left

    local pages = Instance.new("Folder", main)

    self.Main = main
    self.Sidebar = sidebar
    self.Pages = pages
    self.CurrentPage = nil

    return self
end

function RedX:CreatePage(name)
    local btn = Instance.new("TextButton", self.Sidebar)
    btn.Size = UDim2.new(1,-12,0,36)
    btn.Position = UDim2.new(0,6,0,0)
    btn.BackgroundColor3 = Color3.fromRGB(28,28,28)
    btn.Text = "   "..name
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.TextColor3 = theme.sub
    btn.TextXAlignment = Enum.TextXAlignment.Left
    corner(btn,8)

    local page = Instance.new("ScrollingFrame", self.Main)
    page.Position = UDim2.new(0,210,0,60)
    page.Size = UDim2.new(1,-220,1,-70)
    page.CanvasSize = UDim2.new(0,0,0,0)
    page.ScrollBarThickness = 4
    page.Visible = false
    page.BackgroundTransparency = 1

    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0,10)

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+10)
    end)

    btn.MouseButton1Click:Connect(function()
        for _,p in pairs(self.Main:GetChildren()) do
            if p:IsA("ScrollingFrame") then
                p.Visible = false
            end
        end
        page.Visible = true
        self.CurrentPage = page
    end)

    return page
end

function RedX:Section(page, title)
    local card = Instance.new("Frame", page)
    card.Size = UDim2.new(1,0,0,70)
    card.BackgroundColor3 = theme.card
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

    local on = false
    toggle.MouseButton1Click:Connect(function()
        on = not on
        toggle.BackgroundColor3 = on and theme.accent or Color3.fromRGB(60,60,60)
        if callback then callback(on) end
    end)
end

return RedX
