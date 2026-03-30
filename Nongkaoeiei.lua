-- [[ SOURCE: https://raw.githubusercontent.com/GAO-67/NONGJOE/refs/heads/main/Nongjoeeiei.lua ]] --
-- [[ UI NAME: "น้องเก้า" | 100% FOR DELTA EXECUTOR ]] --

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

-- สร้างหน้าต่างหลัก (เน้นขนาดพอดีมือถือ อ่านง่าย)
local Window = OrionLib:MakeWindow({
    Name = "UI น้องเก้า | Delta Edition", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "NongKaoEiei",
    IntroText = "กำลังโหลดระบบ... NYX CN"
})

-- ตัวแปรควบคุม
local SpeedEnabled = false
local SpeedMultiplier = 16
local GhostMode = false
local Flying = false
local SavedPos = nil

-- [ TAB: การเคลื่อนที่ ]
local MoveTab = Window:MakeTab({
    Name = "เคลื่อนที่",
    Icon = "rbxassetid://4483345998"
})

MoveTab:AddToggle({
    Name = "เปิดสถานะวิ่งไว",
    Default = false,
    Callback = function(v) SpeedEnabled = v end    
})

MoveTab:AddDropdown({
    Name = "ระดับความเร็ว",
    Default = "16",
    Options = {"50", "100", "150", "200"},
    Callback = function(v) SpeedMultiplier = tonumber(v) end    
})

-- วิ่งไวแบบ No Bug (ใช้ Stepped จะไม่เด้งกลับ)
RunService.Stepped:Connect(function()
    pcall(function()
        if SpeedEnabled and Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.WalkSpeed = SpeedMultiplier
        end
    end)
end)

MoveTab:AddToggle({
    Name = "เดินทะลุ + กันตกแมพ",
    Default = false,
    Callback = function(v) 
        GhostMode = v 
        task.spawn(function()
            while GhostMode do
                pcall(function()
                    if Player.Character then
                        for _, p in pairs(Player.Character:GetDescendants()) do
                            if p:IsA("BasePart") then p.CanCollide = false end
                        end
                        -- ระบบ Safety Platform กันตกแมพ
                        if Player.Character.PrimaryPart.Position.Y < -400 then
                            local plat = Instance.new("Part", workspace)
                            plat.Size, plat.Anchored = Vector3.new(25, 1, 25), true
                            plat.CFrame = Player.Character.PrimaryPart.CFrame * CFrame.new(0, -4, 0)
                            plat.Transparency = 1
                            task.wait(0.1)
                            plat:Destroy()
                        end
                    end
                end)
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
            bv.Name = "NK_Fly_Eiei"
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            task.spawn(function()
                while Flying do
                    bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * SpeedMultiplier
                    task.wait()
                end
                if Player.Character.PrimaryPart:FindFirstChild("NK_Fly_Eiei") then
                    Player.Character.PrimaryPart.NK_Fly_Eiei:Destroy()
                end
            end)
        end
    end    
})

-- [ TAB: พิเศษ ]
local SpecTab = Window:MakeTab({
    Name = "พิเศษ",
    Icon = "rbxassetid://4483345998"
})

SpecTab:AddToggle({
    Name = "ถอดจิต (ทิ้งร่างแล้ววาร์ป)",
    Default = false,
    Callback = function(v)
        if v then
            SavedPos = Player.Character.PrimaryPart.CFrame
            OrionLib:MakeNotification({Name = "ถอดจิต", Content = "บันทึกตำแหน่งเดิมแล้ว", Duration = 2})
        else
            if SavedPos then
                Player.Character:SetPrimaryPartCFrame(Player.Character.PrimaryPart.CFrame)
                SavedPos = nil
                OrionLib:MakeNotification({Name = "วาร์ป", Content = "Sync ตำแหน่งเรียบร้อย", Duration = 2})
            end
        end
    end    
})

SpecTab:AddToggle({
    Name = "เพิ่มดาเมจสูงสุด (VIP)",
    Default = false,
    Callback = function(v)
        if v then
            pcall(function()
                for _, item in pairs(Player.Backpack:GetDescendants()) do
                    if item:IsA("NumberValue") or item:IsA("IntValue") then
                        local n = item.Name:lower()
                        if n:find("damage") or n:find("dmg") or n:find("power") then
                            item.Value = 999999
                        end
                    end
                end
            end)
            OrionLib:MakeNotification({Name = "Damage", Content = "ปรับค่าพลังสูงสุดเรียบร้อย", Duration = 2})
        end
    end    
})

OrionLib:Init()

