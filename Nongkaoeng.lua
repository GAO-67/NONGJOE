-- [[ UI Name: "น้องเก้า" for Delta Executor ]] --
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "UI น้องเก้า | Delta Edition",
   LoadingTitle = "กำลังโหลดฟังก์ชัน...",
   LoadingSubtitle = "by NYX CN",
   ConfigurationPath = "NongKaoConfig"
})

-- ตัวแปรสถานะ (Variables)
local RunService = game:GetService("RunService")
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

local SpeedMultiplier = 1
local Flying = false
local GhostMode = false
local OriginalPos = nil
local SafetyPlatform = nil

-- [[ Tab: หลัก ]] --
local MainTab = Window:CreateTab("ฟังก์ชันหลัก", 4483362458)

-- 1. ฟังก์ชัน: เปิดสถานะวิ่งไว (50x - 200x)
local SpeedSection = MainTab:CreateSection("ระบบเคลื่อนที่")
local SpeedEnabled = false

MainTab:CreateToggle({
   Name = "เปิดสถานะวิ่งไว",
   CurrentValue = false,
   Callback = function(Value)
      SpeedEnabled = Value
      if not Value then Humanoid.WalkSpeed = 16 end
   end,
})

MainTab:CreateDropdown({
   Name = "ระดับความเร็ว",
   Options = {"50x", "100x", "150x", "200x"},
   CurrentOption = {"50x"},
   Callback = function(Option)
      local val = tostring(Option[1]):gsub("x", "")
      SpeedMultiplier = tonumber(val)
   end,
})

-- Loop วิ่งไวแบบ Fix ค่า (No Bug)
RunService.Stepped:Connect(function()
    if SpeedEnabled and Humanoid then
        Humanoid.WalkSpeed = SpeedMultiplier
    end
end)

-- 2. ฟังก์ชัน: เดินทะลุ (Ghost Mode + กันตกแมพ)
MainTab:CreateToggle({
   Name = "เดินทะลุ (No Collision)",
   CurrentValue = false,
   Callback = function(Value)
      GhostMode = Value
      if Value then
          -- ระบบกันตกแมพ (Safety Platform)
          SafetyPlatform = Instance.new("Part", workspace)
          SafetyPlatform.Size = Vector3.new(20, 1, 20)
          SafetyPlatform.Transparency = 1
          SafetyPlatform.Anchored = true
          
          RunService.Stepped:Connect(function()
              if GhostMode then
                  for _, part in pairs(Character:GetDescendants()) do
                      if part:IsA("BasePart") and part.CanCollide then
                          part.CanCollide = false
                      end
                  end
                  -- วางแผ่นรองรับใต้เท้ากันตกแมพ
                  if Character.PrimaryPart.Position.Y < -500 then 
                      SafetyPlatform.CFrame = Character.PrimaryPart.CFrame * CFrame.new(0, -5, 0)
                  end
              end
          end)
      else
          if SafetyPlatform then SafetyPlatform:Destroy() end
          for _, part in pairs(Character:GetDescendants()) do
              if part:IsA("BasePart") then part.CanCollide = true end
          end
      end
   end,
})

-- 3. ฟังก์ชัน: กระโดดบิน (Air Walk)
MainTab:CreateToggle({
   Name = "กระโดดบิน (Fly)",
   CurrentValue = false,
   Callback = function(Value)
      Flying = Value
      local BodyGyro = Instance.new("BodyGyro", Character.PrimaryPart)
      local BodyVelocity = Instance.new("BodyVelocity", Character.PrimaryPart)
      BodyGyro.P = 9e4
      BodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
      BodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)

      spawn(function()
          while Flying do
              BodyGyro.cframe = workspace.CurrentCamera.CFrame
              local moveDir = Humanoid.MoveDirection
              BodyVelocity.velocity = moveDir * SpeedMultiplier -- ใช้คู่กับวิ่งเร็วได้
              task.wait()
          end
          BodyGyro:Destroy()
          BodyVelocity:Destroy()
      end)
   end,
})

-- [[ Tab: พิเศษ ]] --
local SpecialTab = Window:CreateTab("ฟังก์ชันพิเศษ", 4483362458)

-- 4. ฟังก์ชัน: ถอดจิต (Ghost View / Warp)
SpecialTab:CreateToggle({
   Name = "ถอดจิต (Ghost View)",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
          OriginalPos = Character.PrimaryPart.CFrame
          -- สร้างร่างจำลองไว้ที่เดิม (ฝั่งเราเห็น)
          print("ถอดจิต: บันทึกตำแหน่งเดิมเรียบร้อย")
      else
          if OriginalPos then
              Character:SetPrimaryPartCFrame(Character.PrimaryPart.CFrame) -- วาร์ปมาจุดปัจจุบัน
              OriginalPos = nil
          end
      end
   end,
})

-- 5. ฟังก์ชัน: เพิ่มดาเมจสูงสุด (VIP Damage)
SpecialTab:CreateToggle({
   Name =
    
