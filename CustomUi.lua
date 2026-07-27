-- CustomUI v3
-- Rayfield Inspired UI Framework

local Library = {}

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer


Library.Theme = {

    Background = Color3.fromRGB(18,18,22),
    Secondary = Color3.fromRGB(25,25,32),
    Element = Color3.fromRGB(32,32,42),

    Accent = Color3.fromRGB(90,120,255),

    Text = Color3.fromRGB(240,240,240),
    SubText = Color3.fromRGB(160,160,170)

}



local function Create(class, props)

    local obj = Instance.new(class)

    for i,v in pairs(props) do
        obj[i] = v
    end

    return obj
end



local function Corner(obj, size)

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,size or 8)
    c.Parent=obj

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


    local ScreenGui = Create("ScreenGui",{

        Name="CustomUI",
        ResetOnSpawn=false,
        Parent=Player.PlayerGui

    })



    local Main = Create("Frame",{

        Size=UDim2.fromOffset(
            options.Size and options.Size.X or 650,
            options.Size and options.Size.Y or 450
        ),

        Position=UDim2.fromScale(.5,.5),

        AnchorPoint=Vector2.new(.5,.5),

        BackgroundColor3=self.Theme.Background,

        Parent=ScreenGui

    })

    Corner(Main,12)



    local Top = Create("Frame",{

        Size=UDim2.new(1,0,0,45),

        BackgroundColor3=self.Theme.Secondary,

        Parent=Main

    })

    Corner(Top,12)



    local Title = Create("TextLabel",{

        Size=UDim2.new(1,-20,1,0),

        Position=UDim2.fromOffset(10,0),

        BackgroundTransparency=1,

        Text=options.Name or "Custom UI",

        TextColor3=self.Theme.Text,

        Font=Enum.Font.GothamBold,

        TextSize=18,

        TextXAlignment=Enum.TextXAlignment.Left,

        Parent=Top

    })



    -- Sidebar

    local Sidebar = Create("Frame",{

        Position=UDim2.fromOffset(10,55),

        Size=UDim2.new(0,140,1,-65),

        BackgroundColor3=self.Theme.Secondary,

        Parent=Main

    })


    Corner(Sidebar,10)



    local SideList = Instance.new("UIListLayout")
    SideList.Padding=UDim.new(0,6)
    SideList.Parent=Sidebar




    -- Content

    local Content = Create("Frame",{

        Position=UDim2.fromOffset(160,55),

        Size=UDim2.new(1,-170,1,-65),

        BackgroundTransparency=1,

        Parent=Main

    })



    local Window = {}

    local Tabs={}

    local Current



    function Window:CreateTab(name,image)


        local Tab={}


        local Button = Create("TextButton",{

            Size=UDim2.new(1,-10,0,38),

            BackgroundColor3=self.Theme.Element,

            Text="",

            Parent=Sidebar

        })

        Corner(Button,8)



        local Icon = Create("ImageLabel",{

            Size=UDim2.fromOffset(22,22),

            Position=UDim2.fromOffset(8,8),

            BackgroundTransparency=1,

            Image="rbxassetid://"..(image or 0),

            Parent=Button

        })



        local Text = Create("TextLabel",{

            Position=UDim2.fromOffset(38,0),

            Size=UDim2.new(1,-40,1,0),

            BackgroundTransparency=1,

            Text=name,

            TextColor3=self.Theme.Text,

            Font=Enum.Font.Gotham,

            TextSize=14,

            TextXAlignment=Enum.TextXAlignment.Left,

            Parent=Button

        })




        local Page = Create("ScrollingFrame",{

            Size=UDim2.fromScale(1,1),

            BackgroundTransparency=1,

            Visible=false,

            ScrollBarThickness=3,

            Parent=Content

        })



        local Layout=Instance.new("UIListLayout")
        Layout.Padding=UDim.new(0,8)
        Layout.Parent=Page





        function Tab:SetTitle(new)

            Text.Text=new

        end




        function Tab:Show()

            if Current then
                Current.Page.Visible=false
            end


            Current=self

            Page.Visible=true


            Tween(
                Button,
                .2,
                {
                    BackgroundColor3=self.Theme.Accent
                }
            )

        end




        function Tab:CreateSection(title)

            local Section={}


            local Label=Create("TextLabel",{

                Size=UDim2.new(1,0,0,30),

                BackgroundTransparency=1,

                Text=title,

                TextColor3=self.Theme.SubText,

                Font=Enum.Font.GothamBold,

                TextSize=14,

                TextXAlignment=Enum.TextXAlignment.Left,

                Parent=Page

            })



            function Section:Set(new)

                Label.Text=new

            end


            return Section

        end




        Button.MouseButton1Click:Connect(function()

            Tab:Show()

        end)



        Tab.Page=Page

        table.insert(Tabs,Tab)



        if #Tabs==1 then
            Tab:Show()
        end



        return Tab

    end



    return Window

end



return Library
