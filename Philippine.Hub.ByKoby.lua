local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "Koby Hub",
   Theme = "Dark Blue",
   LoadingTitle = "Koby Interface Suite",
   LoadingSubtitle = "By Koby",
   ConfigurationSaving = {
      Enabled = true,
      FileName = "KobyHubConfig"
   },
   KeySystem = false
})

-- Tabs
local MainTab = Window:CreateTab("Settings", nil)
local FishingTab = Window:CreateTab("Fishing", nil)
local AutosTab = Window:CreateTab("Autos", nil)
local AreasTab = Window:CreateTab("Areas", nil)
local MarketTab = Window:CreateTab("Market", nil)

-- Notify on load
Rayfield:Notify({
   Title = "Script Loaded",
   Content = "Welcome to Koby Hub!",
   Duration = 5,
})

-- Infinite Jump Toggle
MainTab:CreateButton({
   Name = "Infinite Jump Toggle",
   Callback = function()
       _G.InfiniteJump = not _G.InfiniteJump
       Rayfield:Notify({
           Title = "Infinite Jump",
           Content = _G.InfiniteJump and "Enabled!" or "Disabled!",
           Duration = 5,
       })

       if not _G.InfiniteJumpStarted then
           _G.InfiniteJumpStarted = true
           local UIS = game:GetService("UserInputService")
           UIS.InputBegan:Connect(function(input, isProcessed)
               if not isProcessed and input.KeyCode == Enum.KeyCode.Space and _G.InfiniteJump then
                   local char = game.Players.LocalPlayer.Character
                   if char and char:FindFirstChildOfClass("Humanoid") then
                       char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
                   end
               end
           end)
       end
   end
})

-- WalkSpeed Slider
MainTab:CreateSlider({
   Name = "WalkSpeed Slider",
   Range = {16, 350},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Callback = function(Value)
       local char = game.Players.LocalPlayer.Character
       if char and char:FindFirstChildOfClass("Humanoid") then
           char:FindFirstChildOfClass("Humanoid").WalkSpeed = Value
       end
   end,
})

-- JumpPower Slider
MainTab:CreateSlider({
   Name = "JumpPower Slider",
   Range = {50, 350},
   Increment = 1,
   Suffix = "JumpPower",
   CurrentValue = 50,
   Callback = function(Value)
       local char = game.Players.LocalPlayer.Character
       if char and char:FindFirstChildOfClass("Humanoid") then
           char:FindFirstChildOfClass("Humanoid").JumpPower = Value
       end
   end,
})

-- Freeze Character
FishingTab:CreateToggle({
   Name = "Freeze Character",
   CurrentValue = false,
   Callback = function(Value)
       local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
       local rootPart = char:FindFirstChild("HumanoidRootPart")
       if rootPart then
           rootPart.Anchored = Value
       end
   end
})

-- Auto Equip Rod
FishingTab:CreateToggle({
   Name = "Auto Equip Rod",
   CurrentValue = false,
   Callback = function(Value)
       _G.AutoEquipRod = Value
       task.spawn(function()
           while _G.AutoEquipRod do
               local player = game.Players.LocalPlayer
               local backpack = player:FindFirstChild("Backpack")
               local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
               if backpack and humanoid then
                   for _, tool in ipairs(backpack:GetChildren()) do
                       if tool:IsA("Tool") and string.lower(tool.Name):find("rod") then
                           humanoid:EquipTool(tool)
                           break
                       end
                   end
               end
               task.wait(1)
           end
       end)
   end,
})

-- Auto Catch (Fishing System)
FishingTab:CreateToggle({
   Name = "Instant Cast and Catch",
   CurrentValue = false,
   Callback = function(Value)
       _G.InstantFishing = Value
       task.spawn(function()
           while _G.InstantFishing do
               local player = game.Players.LocalPlayer
               local character = player.Character or player.CharacterAdded:Wait()
               local backpack = player:FindFirstChild("Backpack")
               local humanoid = character:FindFirstChildOfClass("Humanoid")

               -- Equip any rod from the backpack if none is equipped
               if backpack and humanoid and not character:FindFirstChildWhichIsA("Tool") then
                   for _, tool in ipairs(backpack:GetChildren()) do
                       if tool:IsA("Tool") and string.lower(tool.Name):find("rod") then
                           humanoid:EquipTool(tool)
                           break
                       end
                   end
               end

               -- Use the equipped rod
               local equippedRod = character:FindFirstChildWhichIsA("Tool")
               if equippedRod and string.lower(equippedRod.Name):find("rod") then
                   local rodEvents = equippedRod:FindFirstChild("events")
                   if rodEvents and rodEvents:FindFirstChild("cast") then
                       rodEvents.cast:FireServer(100, 1) -- Cast with max power
                   end

                   local reelEvent = game:GetService("ReplicatedStorage"):FindFirstChild("events") and
                       game:GetService("ReplicatedStorage").events:FindFirstChild("reelfinished")
                   if reelEvent then
                       reelEvent:FireServer(100, true) -- Reel immediately
                   end
               end
               task.wait(0.1)
           end
       end)
   end,
})

-- Fishing Tab Placeholder
MarketTab:CreateLabel("Fishing And Catching tools here")

-- Autos Tab Placeholder
AutosTab:CreateLabel("Automated systems will appear here.")

-- Areas Tab Placeholder
AreasTab:CreateLabel("Teleport or explore different areas here.")

-- Market Tab Placeholder
MarketTab:CreateLabel("Market and trading tools will be here.")
