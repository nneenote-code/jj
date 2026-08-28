--[[ 
   Blox Fruits Auto Farm Script (Delta Executor Supported)
   Features: Auto Farm Level, Auto Quest, Bring Mobs, Auto Island
--]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Blox Fruits | Auto Farm Hub",
   LoadingTitle = "Delta Executor Ready",
   LoadingSubtitle = "by Assistant",
   ConfigurationSaving = { Enabled = false }
})

local FarmTab = Window:CreateTab("Auto Farm", 4483362458)

-- Variables
getgenv().AutoFarm = false
getgenv().BringMob = true

-- Function: Bring Mobs (ดึงมอนสเตอร์มารวมกัน)
task.spawn(function()
    while task.wait(0.5) do
        if getgenv().AutoFarm and getgenv().BringMob then
            pcall(function()
                local player = game.Players.LocalPlayer
                local myPos = player.Character.HumanoidRootPart.Position
                for _, mob in pairs(game.Workspace.Enemies:GetChildren()) do
                    if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                        if (mob.HumanoidRootPart.Position - myPos).Magnitude < 300 then
                            mob.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
                            mob.HumanoidRootPart.CanCollide = false
                            mob.Humanoid.WalkSpeed = 0
                        end
                    end
                end
            end)
        end
    end
end)

-- Main Auto Farm Loop (ย้ายเกาะ / รับเควส / โจมตี)
task.spawn(function()
    while true do
        task.wait(0.1)
        if getgenv().AutoFarm then
            pcall(function()
                local player = game.Players.LocalPlayer
                local level = player.Data.Level.Value
                
                -- ตรวจสอบ Level เพื่อกำหนดเป้าหมาย (ตัวอย่างโครงสร้างระบบย้ายเกาะและรับเควส)
                local targetQuest, questName, mobName, targetCFrame
                
                if level >= 1 and level <= 14 then
                    targetQuest = "BanditQuest1"
                    questName = "Bandit"
                    mobName = "Bandit"
                    targetCFrame = CFrame.new(1059, 16, 1549) -- เกาะแรก (Bandit Island)
                elseif level >= 15 and level <= 29 then
                    targetQuest = "JungleQuest"
                    questName = "Jungle1"
                    mobName = "Monkey"
                    targetCFrame = CFrame.new(-1611, 37, 148) -- เกาะลิง (Jungle)
                else
                    -- สามารถเพิ่มเกาะและเลเวลอื่นๆ ถัดไปได้ตรงนี้
                    targetQuest = "BanditQuest1"
                    questName = "Bandit"
                    mobName = "Bandit"
                    targetCFrame = CFrame.new(1059, 16, 1549)
                end

                -- 1. เช็คเควส ถ้ายังไม่มีให้วาร์ปไปรับเควส
                if not player.PlayerGui.Main:FindFirstChild("Quest") or not player.PlayerGui.Main.Quest.Visible then
                    -- คำสั่งรับเควสผ่าน Remote
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", targetQuest, 1)
                end

                -- 2. วาร์ปไปจุดฟาร์ม/มอนสเตอร์ และโจมตี
                local targetMob = game.Workspace.Enemies:FindFirstChild(mobName)
                if targetMob and targetMob:FindFirstChild("HumanoidRootPart") then
                    -- วาร์ปไปอยู่เหนือหัวมอนสเตอร์เล็กน้อยเพื่อความปลอดภัย
                    player.Character.HumanoidRootPart.CFrame = targetMob.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                    
                    -- จำลองการโจมตี (Virtual User Click)
                    game:GetService("VirtualUser"):CaptureController()
                    game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0))
                else
                    -- ถ้ารถมอนสเตอร์ยังไม่เกิด ให้วาร์ปไปรอที่จุดเกิดของเกาะนั้น
                    player.Character.HumanoidRootPart.CFrame = targetCFrame
                end
            end)
        end
    end
end)

-- UI Controls (ปุ่มเปิด-ปิดการทำงาน)
local Toggle = FarmTab:CreateToggle({
   Name = "เปิดใช้งาน Auto Farm Level + Auto Quest",
   CurrentValue = false,
   Flag = "AutoFarmToggle",
   Callback = function(Value)
      getgenv().AutoFarm = Value
   end,
})

local BringToggle = FarmTab:CreateToggle({
   Name = "รวมมอนสเตอร์ (Bring Mob)",
   CurrentValue = true,
   Flag = "BringMobToggle",
   Callback = function(Value)
      getgenv().BringMob = Value
   end,
})
