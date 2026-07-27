-- CustomUI Library v1
-- Single file UI framework

local Library = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer


--// Theme
Library.Theme = {
    Background = Color3.fromRGB(20,20,25),
    Secondary = Color3.fromRGB(30,30,38),
    Accent = Color3.fromRGB(90,120,255),
    Text = Color3.fromRGB(240,240,240),
    Muted = Color3.fromRGB(150,150,150)
}


--// Utility
local function Create(class, properties)
    local obj = Instance.new(class)

    for i,v in pairs(properties) do
        obj[i] = v
    end

    return obj
end


local function Round(obj, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,radius or 8)
    corner.Parent = obj
end


local function Tween(obj, info, properties)
    TweenService:Create(
        obj,
        TweenInfo.new(
            info or 0.25,
            Enum.EasingStyle.Quart,
            Enum.EasingDirection.Out
        ),
        properties
    ):Play()
end



--// Window
function Library:CreateWindow(options)

    options = options or {}

    local Gui = Create("ScreenGui", {
        Name = "CustomUI",
        ResetOnSpawn = false,
        Parent = Player.PlayerGui
    })


    local Main = Create("Frame", {
        Size = UDim2.fromOffset(0,0),
        Position = UDim2.fromScale(.5,.5),
        AnchorPoint = Vector2.new(.5,.5),
        BackgroundColor3 = self.Theme.Background,
        Parent = Gui
    })

    Round(Main,12)


    local Scale = Instance.new("UIScale")
    Scale.Scale = 0
    Scale.Parent = Main


    Tween(Scale,.35,{
        Scale = 1
    })


    Main.Size = UDim2.fromOffset(
        options.Width or 600,
        options.Height or 400
    )


    -- title bar

    local Title = Create("TextLabel",{

        Size = UDim2.new(1,0,0,45),

        BackgroundColor3 = self.Theme.Secondary,

        Text = options.Title or "Custom UI",

        TextColor3 = self.Theme.Text,

        Font = Enum.Font.GothamBold,

        TextSize = 18,

        Parent = Main
    })


    Round(Title,12)



    -- dragging

    local dragging = false
    local dragStart
    local startPos


    Title.InputBegan:Connect(function(input)

        if input.UserInputType == Enum.UserInputType.MouseButton1 then

            dragging = true

            dragStart = input.Position
            startPos = Main.Position

        end

    end)


    Title.InputEnded:Connect(function(input)

        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end

    end)


    UserInputService.InputChanged:Connect(function(input)

        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then

            local delta = input.Position - dragStart

            Main.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )

        end

    end)



    local Window = {}


    -- tabs container

    local Tabs = Create("Frame",{

        Position = UDim2.new(0,10,0,55),

        Size = UDim2.new(0,130,1,-65),

        BackgroundColor3 = self.Theme.Secondary,

        Parent = Main

    })

    Round(Tabs,10)



    function Window:CreateTab(name)

        local Tab = {}

        local Button = Create("TextButton",{

            Size = UDim2.new(1,-10,0,35),

            Position = UDim2.new(0,5,0,#Tabs:GetChildren()*40),

            BackgroundColor3 = self.Theme.Background,

            Text = name,

            TextColor3 = self.Theme.Text,

            Font = Enum.Font.Gotham,

            TextSize = 14,

            Parent = Tabs

        })


        Round(Button,8)


        return Tab

    end


    return Window

end


return Library
