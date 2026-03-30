-- [[ NYX CN - PREMIUM HUB (VERSION: น้องเก้าซิกเซเว่น) ]]
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

local Window = Library.CreateLib("           <font color='rgb(255,0,0)'>น้องเก้าซิกเซเว่น</font>           ", "Light")

local MainTab = Window:NewTab("Main Mods")
local MainSection = MainTab:NewSection("ฟังก์ชันตัวละคร")

local VisualTab = Window:NewTab("Visuals")
local VisualSection = VisualTab:NewSection("มองทะลุ")

local CombatTab = Window:NewTab("Combat")
local CombatSection = CombatTab:NewSection("ล็อค")

local Noclipping = nil
MainSection:NewToggle("เดินทะลุ", "ทะลุสิ่งที่ชนแต่ไม่ตกพื้น + NPC มองไม่เห็น", function(state)
    if state then
        Noclipping = game:GetService("RunService").Stepped:Connect(function()
            if game.Players.LocalPlayer.Character ~= nil then
                for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") and v.CanCollide == true then
                        v.CanCollide = false
                    end
                end
            end
        end)
        game.Players.LocalPlayer.Character.HumanoidRootPart.Transparency = 0.5
    else
        if Noclipping then Noclipping:Disconnect() end
        for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = true end
        end
    end
end)

local Flying = false
MainSection:NewToggle("โหมดบิน", "กดกระโดดค้างเพื่อบินและหันตามหน้าจอ", function(state)
    Flying = state
    game:GetService("RunService").RenderStepped:Connect(function()
        if Flying and game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
            game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = workspace.CurrentCamera.CFrame.LookVector * 100
        end
    end)
end)

MainSection:NewSlider("วิ่งเร็ว", "ปรับระดับความเร็ว (มีตัวเลขบอกข้างบน)", 320, 16, function(s)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
end)

VisualSection:NewButton("มองทะลุ", "แสดงผลเรียลไทม์ Line/Box/HP", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/ic3w0lf22/Unnamed-ESP/master/UnnamedESP.lua'))()
end)

local FOVring = Drawing.new("Circle")
FOVring.Visible = true
FOVring.Thickness = 1.5
FOVring.Radius = 45
FOVring.Transparency = 1
FOVring.Color = Color3.fromRGB(255, 0, 0)
FOVring.Position = game:GetService("Workspace").CurrentCamera.ViewportSize / 2

CombatSection:NewToggle("ล็อค", "ล็อคเป้า 100% ในวง FOV (ไม่ล็อคหลังกำแพง)", function(state)
    local AimEnabled = state
    game:GetService("RunService").RenderStepped:Connect(function()
        if AimEnabled then
            local target = nil
            local dist = math.huge
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local screenPos, onScreen = game:GetService("Workspace").CurrentCamera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                    local mousePos = game:GetService("UserInputService"):GetMouseLocation()
                    local mag = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if mag < FOVring.Radius and mag < dist then
                        local origin = game:GetService("Workspace").CurrentCamera.CFrame.p
                        local direction = (v.Character.HumanoidRootPart.Position - origin).Unit * 500
                        local raycastParams = RaycastParams.new()
                        raycastParams.FilterDescendantsInstances = {game.Players.LocalPlayer.Character}
                        local result = workspace:Raycast(origin, direction, raycastParams)
                        if result and result.Instance:IsDescendantOf(v.Character) then
                            target = v
                            dist = mag
                        end
                    end
                end
            end
            if target then
                game:GetService("Workspace").CurrentCamera.CFrame = CFrame.new(game:GetService("Workspace").CurrentCamera.CFrame.p, target.Character.HumanoidRootPart.Position)
            end
        end
    end)
end)
