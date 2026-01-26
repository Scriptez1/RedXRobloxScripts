local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local RedX = {}
RedX.__index = RedX

local theme = {
    Primary = Color3.fromRGB(220,20,60),
    Dark = Color3.fromRGB(30,30,30),
    Gray = Color3.fromRGB(55,55,55),
    White = Color3.fromRGB(255,255,255)
}

local function tween(o,p,t)
    TweenService:Create(o,TweenInfo.new(t,Enum.EasingStyle.Back,Enum.EasingDirection.Out),p):Play()
end

local function corner(o,r)
    local c=Instance.new("UICorner")
    c.CornerRadius=UDim.new(0,r)
    c.Parent=o
end

function RedX.new(title)
    local self=setmetatable({},RedX)

    self.Gui=Instance.new("ScreenGui",playerGui)
    self.Gui.ResetOnSpawn=false

    self.Frame=Instance.new("Frame",self.Gui)
    self.Frame.Size=UDim2.new(0,0,0,0)
    self.Frame.Position=UDim2.new(0.5,0,0.5,0)
    self.Frame.AnchorPoint=Vector2.new(0.5,0.5)
    self.Frame.BackgroundColor3=theme.Dark
    corner(self.Frame,14)

    local header=Instance.new("Frame",self.Frame)
    header.Size=UDim2.new(1,0,0,50)
    header.BackgroundColor3=theme.Primary
    corner(header,14)

    local titleLabel=Instance.new("TextLabel",header)
    titleLabel.Size=UDim2.new(1,-60,1,0)
    titleLabel.Position=UDim2.new(0,10,0,0)
    titleLabel.BackgroundTransparency=1
    titleLabel.Text=title
    titleLabel.Font=Enum.Font.GothamBold
    titleLabel.TextSize=18
    titleLabel.TextColor3=theme.White
    titleLabel.TextXAlignment=Enum.TextXAlignment.Left

    local close=Instance.new("TextButton",header)
    close.Size=UDim2.new(0,40,0,40)
    close.Position=UDim2.new(1,-45,0,5)
    close.Text="X"
    close.Font=Enum.Font.GothamBold
    close.TextSize=18
    close.BackgroundColor3=theme.Gray
    close.TextColor3=theme.White
    corner(close,8)

    self.Content=Instance.new("ScrollingFrame",self.Frame)
    self.Content.Size=UDim2.new(1,-20,1,-70)
    self.Content.Position=UDim2.new(0,10,0,60)
    self.Content.CanvasSize=UDim2.new(0,0,0,0)
    self.Content.ScrollBarThickness=4
    self.Content.BackgroundTransparency=1

    self.Layout=Instance.new("UIListLayout",self.Content)
    self.Layout.Padding=UDim.new(0,8)

    self.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.Content.CanvasSize=UDim2.new(0,0,0,self.Layout.AbsoluteContentSize.Y+10)
    end)

    close.MouseButton1Click:Connect(function()
        self:Destroy()
    end)

    local size=isMobile and UDim2.new(0.9,0,0.8,0) or UDim2.new(0.4,0,0.6,0)
    tween(self.Frame,{Size=size},0.35)

    return self
end

function RedX:Destroy()
    tween(self.Frame,{Size=UDim2.new(0,0,0,0)},0.25)
    task.delay(0.3,function()
        self.Gui:Destroy()
    end)
end

function RedX:Label(t)
    local l=Instance.new("TextLabel",self.Content)
    l.Size=UDim2.new(1,0,0,30)
    l.BackgroundTransparency=1
    l.Text=t
    l.Font=Enum.Font.Gotham
    l.TextSize=14
    l.TextColor3=theme.White
    l.TextXAlignment=Enum.TextXAlignment.Left
end

function RedX:Button(t,f)
    local b=Instance.new("TextButton",self.Content)
    b.Size=UDim2.new(1,0,0,35)
    b.BackgroundColor3=theme.Gray
    b.Text=t
    b.Font=Enum.Font.Gotham
    b.TextSize=14
    b.TextColor3=theme.White
    corner(b,8)
    b.MouseButton1Click:Connect(function()
        if f then f() end
    end)
end

return RedX
