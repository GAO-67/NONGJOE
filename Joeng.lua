-- [[ UI "น้องเก้า" - Optimized for Delta 100% ]] --
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

-- สร้างหน้าต่างเมนู
local Window = OrionLib:MakeWindow({
    Name = "UI น้องเก้า | Delta Edition", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "NongKao",
    IntroText = "ยินดีต้อนรับ.. น้องเก้า"
})

-- ตัวแปรตั้งค่า
local SpeedMultiplier = 16
local SpeedEnabled = false
local GhostMode = false
local Flying = false

-- [[ Tab: ฟังก์ชันหลัก ]] --
local MainTab = Window:MakeTab({
    Name = "ฟังก์ชันหลัก",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- 1. วิ่งไว (ปรับให้เสถียรที่สุด)
MainTab:AddToggle({
    Name = "เปิดสถานะวิ่งไว",
    Default = false,
    Callback = function(Value)
        SpeedEnabled = Value
    end    
})

MainTab:AddDropdown({
    Name = "ระดับความเร็ว",
    Default = "16",
    Options = {"50", "100", "150", "200"},
    Callback = function(Value)
        SpeedMultiplier = tonumber(Value)
    end    
})

-- Loop วิ่งไว (แยก Thread เพื่อไม่ให้เมนูค้าง)
task.spawn(function()
    while task.wait() do
        if SpeedEnabled and Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.WalkSpeed = SpeedMultiplier
        end
    end
end)

-- 2. เดินทะลุ + กันตกแมพ
MainTab:AddToggle({
    Name = "เดินทะลุ (No Collision)",
    Default = false,
    Callback = function(Value)
        GhostMode = Value
        task.spawn(function()
            while GhostMode do
                if Player.Character then
                    for _, part in pairs(Player.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                    -- ระบบพื้นรองรับกันตกแมพ
                    if Player.Character.PrimaryPart.Position.Y < -450 then
                        local p = Instance.new("Part", workspace)
                        p.Size = Vector3.new(10, 1, 10)
                        p.Anchored = true
                        p.CFrame = Player.Character.PrimaryPart.CFrame * CFrame.new(0, -3.5, 0)
                        task.wait(0.1)
                        p:Destroy()
                    end
                end
                task.wait()
            end
        end)
    end    
})

-- 3. กระโดดบิน (อิสระ)
MainTab:AddToggle({
    Name = "กระโดดบิน (Fly)",
    Default = false,
    Callback = function(Value)
        Flying = Value
        if Flying then
            local bv = Instance.new("BodyVelocity", Player.Character.PrimaryPart)
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.Velocity = Vector3.new(0, 0, 0)
            bv.Name = "NongKaoFly"
            
            task.spawn(function()
                while Flying do
                    bv
              
