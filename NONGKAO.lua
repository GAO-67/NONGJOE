-- [[ DELTA OPTIMIZED - น้องเก้าซิกเซเว่น PREMIUM HUB ]]
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

-- ตั้งค่าหน้าต่าง (ใช้ชื่อน้องเก้าสีแดงตามสั่ง)
local Window = Library.CreateLib("           <font color='rgb(255,0,0)'>น้องเก้าซิกเซเว่น</font>           ", "Light")

-- แท็บหลัก
local MainTab = Window:NewTab("Main Mods")
local MainSection = MainTab:NewSection("ฟังก์ชันตัวละคร")

-- 1. เดินทะลุ (Noclip)
MainSection:NewToggle("เดินทะลุ", "ทะลุสิ่งที่ชนแต่ไม่ตกพื้น", function(state)
    _G.Noclip = state
    game:GetService("RunService").Stepped:Connect(function()
        if _G.Noclip and game.Players.LocalPlayer.Character then
            for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
end)

-- 2. วิ่งเร็ว (Speed Slider)
MainSection:NewSlider("วิ่งเร็ว", "ปรับระดับความเร็ว x1.5 - x20", 320, 16, function(s)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
end)

-- แท็บการมองเห็น
local VisualTab = Window:NewTab("Visuals")
local VisualSection = VisualTab:NewSection("มองทะลุ")

VisualSection:NewButton("เปิด ESP", "แสดงผลเรียลไทม์", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/ic3w0lf22/Unnamed-ESP/master/UnnamedESP.lua'))()
end)

-- แท็บล็อคเป้า
local CombatTab = Window:NewTab("Combat")
local CombatSection = CombatTab:NewSection("ล็อค")

CombatSection:NewToggle("ล็อคเป้า (Aimbot)", "ล็อคเป้าอัตโนมัติ", function(state)
    _G.Aimbot = state
    game:GetService("RunService").RenderStepped:Connect(function()
        if _G.Aimbot then
            -- ระบบล็อคเป้าเบื้องต้นสำหรับ Delta
            local target = nil
            local dist = math.huge
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local mag = (v.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                    if mag < dist then
                        target = v
                        dist = mag
                    end
                end
            end
            if target then
                workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.p, target.Character.HumanoidRootPart.Position)
            end
        end
    end)
end)

