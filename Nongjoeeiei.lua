-- [[ NONGKAO NEW VERSION - OPTIMIZED FOR DELTA 100% ]] --
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

local Window = OrionLib:MakeWindow({
    Name = "UI น้องเก้า | NEW GENERATION", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "NongKaoNew",
    IntroText = "ระบบพร้อมใช้งานโดย NYX CN"
})

-- Variables
local SpeedEnabled = false
local SpeedMultiplier = 16
local GhostMode = false
local Flying = false
local SavedPos = nil

-- [ TAB: การเคลื่อนที่ ]
local MoveTab = Window:MakeTab({Name = "เคลื่อนที่", Icon = "rbxassetid://4483345998"})

MoveTab:AddToggle({
    Name = "เปิดสถานะวิ่งไว",
    Default = false,
    Callback = function(v) SpeedEnabled = v end    
})

MoveTab:AddDropdown({
    Name = "เลือกความเร็ว",
    Default = "16",
    Options = {"50", "100", "150", "200"},
    Callback = function(v) SpeedMultiplier = tonumber(v) end    
})

-- ระบบวิ่งไวแบบ No Bug (ใช้ Stepped เพื่อความสมูท)
RunService.Stepped:Connect(function()
    if SpeedEnabled and Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.WalkSpeed = SpeedMultiplier
    end
end)

MoveTab:AddToggle({
    Name = "เดินทะลุ + กันตกแมพ",
    Default = false,
    Callback = function(v) 
        GhostMode = v 
        task.spawn(function()
            while GhostMode do
                if Player.Character then
                    for _, p in pairs(Player.Character:GetDescendants()) do
                        if p:IsA("BasePart") then p.CanCollide = false end
                    end
                    -- Safety Platform กันตกแมพตาย
                    if Player.Character.PrimaryPart.Position.Y < -400 then
                        local plat = Instance.new("Part", workspace)
                        plat.Size, plat.Anchored = Vector3.new(20, 1, 20), true
                        plat.CFrame = Player.Character.PrimaryPart.CFrame * CFrame.new(0, -4, 0)
                        task.wait(0.1)
                        plat:Destroy()
                    end
                end
                task.wait()
            end
        end)
    end    
})

MoveTab:AddToggle({
    Name = "กระโดดบิน (FLY)",
    Default = false,
    Callback = function(v)
        Flying = v
        if v then
            local bv = Instance.new("BodyVelocity", Player.Character.PrimaryPart)
            bv.Name = "NK_Fly"
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            task.spawn(function()
                while Flying do
                    bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * SpeedMultiplier
                    task.wait()
                end
                if Player.Character.PrimaryPart:FindFirstChild("NK_Fly") then
                    Player.Character.PrimaryPart.NK_Fly:Destroy()
                end
            end)
        end
    end    
})

-- [ TAB: ความสามารถพิเศษ ]
local SpecTab = Window:MakeTab({Name = "พิเศษ", Icon = "rbxassetid://4483345998"})

SpecTab:AddToggle({
    Name = "ถอดจิต (Ghost & Warp)",
    Default = false,
    Callback = function(v)
        if v then
            SavedPos = Player.Character.PrimaryPart.CFrame
        else
            if SavedPos then
                Player.Character:SetPrimaryPartCFrame(Player.Character.PrimaryPart.CFrame)
                SavedPos = nil
            end
        end
    end    
})

SpecTab:AddToggle({
    Name = "เพิ่มดาเมจสูงสุด (VIP)",
    Default = false,
    Callback = function(v)
        if v then
            for _, item in pairs(Player.Backpack:GetDescendants()) do
                if item:IsA("NumberValue") or item:IsA("IntValue") then
                    if item.Name:lower():find("damage") or item.Name:lower():find("dmg") then
                        item.Value = 999999
                    end
                end
            end
        end
    end    
})

OrionLib:Init()

