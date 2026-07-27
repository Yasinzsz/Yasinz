-- CustomUI Library v2
-- Rayfield style tab system

local Library = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer


Library.Theme = {

    Background = Color3.fromRGB(20,20,25),
    Secondary = Color3.fromRGB(30,30,38),
    Accent = Color3.fromRGB(90,120,255),
    Text = Color3.fromRGB(240,240,240),
    Muted = Color3.fromRGB(150,150,150)

}


local function Create(class, props)

    local obj = Instance.new(class)

    for i,v in pairs(props) do
        obj[i] = v
    end

    return obj
end


local function Corner(obj,r)

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,r or 8)
    c.Parent = obj

end


local function Tween(obj,time,props)

    TweenService:Create(
        obj,
        TweenInfo.new(
            time or .25,
            Enum.EasingStyle.Quart,
            Enum.EasingDirection.Out
        ),
        props
    ):Play()

end



function Library:CreateWindow(options)

    options = options or {}


    local Gui = Create("ScreenGui",{
        Name="CustomUI",
        ResetOnSpawn=false,
        Parent=Player.PlayerGui
    })


    local Main = Create("Frame",{

        Size=UDim2.fromOffset(
            options.Width or 650,
            options.Height or 450
        ),

        Position=UDim2.fromScale(.5,.5),

        AnchorPoint=Vector2.new(.5,.5),

        BackgroundColor3=self.Theme.Background,

        Parent=Gui

    })

    Corner(Main,12)



    -- Title

    local Title = Create("TextLabel",{

        Size=UDim2.new(1,0,0,45),

        BackgroundColor3=self.Theme.Secondary,

        Text=options.Title or "Custom UI",

        TextColor3=self.Theme.Text,

        Font=Enum.Font.GothamBold,

        TextSize=18,

        Parent=Main

    })

    Corner(Title,12)



    -- Sidebar

    local Sidebar = Create("Frame",{

        Position=UDim2.new(0,10,0,55),

        Size=UDim2.new(0,140,1,-65),

        BackgroundColor3=self.Theme.Secondary,

        Parent=Main

    })

    Corner(Sidebar,10)



    local SideLayout = Instance.new("UIListLayout")
    SideLayout.Padding=UDim.new(0,6)
    SideLayout.Parent=Sidebar



    -- Pages

    local Pages = Create("Frame",{

        Position=UDim2.new(0,160,0,55),

        Size=UDim2.new(1,-170,1,-65),

        BackgroundTransparency=1,

        Parent=Main

    })


    local Tabs = {}

    local CurrentTab



    local Window = {}



    function Window:CreateTab(name)


        local Tab = {}


        -- page

        local Page = Create("ScrollingFrame",{

            Size=UDim2.fromScale(1,1),

            BackgroundTransparency=1,

            ScrollBarThickness=3,

            Visible=false,

            Parent=Pages

        })


        local Layout = Instance.new("UIListLayout")
        Layout.Padding=UDim.new(0,8)
        Layout.Parent=Page



        -- button

        local Button = Create("TextButton",{

            Size=UDim2.new(1,-10,0,35),

            BackgroundColor3=self.Theme.Background,

            Text=name,

            TextColor3=self.Theme.Text,

            Font=Enum.Font.Gotham,

            TextSize=14,

            Parent=Sidebar

        })


        Corner(Button,8)



        function Tab:Set(newName)

            Button.Text=newName

        end



        function Tab:Show()

            if CurrentTab then

                CurrentTab.Page.Visible=false

            end


            CurrentTab=self

            Page.Visible=true


            Tween(
                Button,
                .2,
                {
                    BackgroundColor3=self.Theme.Accent
                }
            )

        end



        function Tab:Hide()

            Page.Visible=false

        end



        Button.MouseButton1Click:Connect(function()

            Tab:Show()

        end)



        Tab.Page=Page
        Tab.Button=Button


        table.insert(Tabs,Tab)


        if #Tabs==1 then
            Tab:Show()
        end



        return Tab

    end



    return Window

end



return Library
