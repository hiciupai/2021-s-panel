-- ✅ Questo script è eseguibile ovunque lato client (StarterPlayerScripts, StarterGui, ecc.)
-- 📱 Compatibile con dispositivi mobili e tablet (GUI responsive e controlli touch)
-- 🚫 Nessuna dipendenza da posizione fissa o componenti server

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Autorizzazione solo per Coolkiddreal37
if LocalPlayer.Name ~= "Coolkiddreal37" then return end

local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "AdminPanel"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 280, 0, 540)
frame.Position = UDim2.new(0.5, -140, 0.5, -270)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -30, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "2021's Panel"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.Text = "-"
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 24
closeBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
end)

local dropdown = Instance.new("TextButton", frame)
dropdown.Size = UDim2.new(1, -20, 0, 30)
dropdown.Position = UDim2.new(0, 10, 0, 40)
dropdown.Text = "Seleziona Player"
dropdown.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
dropdown.TextColor3 = Color3.new(1, 1, 1)
dropdown.Font = Enum.Font.SourceSans
dropdown.TextSize = 18

local selectedPlayer = nil

dropdown.MouseButton1Click:Connect(function()
	if frame:FindFirstChild("PlayerMenu") then frame.PlayerMenu:Destroy() end
	local menu = Instance.new("ScrollingFrame", frame)
	menu.Name = "PlayerMenu"
	menu.Position = UDim2.new(0, 10, 0, 75)
	menu.Size = UDim2.new(1, -20, 0, 150)
	menu.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	menu.CanvasSize = UDim2.new(0, 0, 0, #Players:GetPlayers() * 30)
	menu.ScrollBarThickness = 6
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			local entry = Instance.new("TextButton", menu)
			entry.Size = UDim2.new(1, 0, 0, 30)
			entry.Position = UDim2.new(0, 0, 0, (#menu:GetChildren() - 1) * 30)
			entry.Text = p.Name
			entry.Font = Enum.Font.SourceSans
			entry.TextSize = 18
			entry.TextColor3 = Color3.new(1,1,1)
			entry.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
			entry.MouseButton1Click:Connect(function()
				selectedPlayer = p
				dropdown.Text = "Target: " .. p.Name
				menu:Destroy()
			end)
		end
	end
end)

local function makeButton(text, yOffset, callback)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(1, -20, 0, 35)
	btn.Position = UDim2.new(0, 10, 0, yOffset)
	btn.Text = text
	btn.Font = Enum.Font.SourceSans
	btn.TextSize = 18
	btn.TextColor3 = Color3.new(1,1,1)
	btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
	btn.MouseButton1Click:Connect(function()
		callback(selectedPlayer)
	end)
end

-- Moderazione
makeButton("Kick", 240, function(target)
	if target then target:Kick("Rimosso da Coolkiddreal37") end
end)

makeButton("Freeze", 280, function(target)
	if target and target.Character then
		local hrp = target.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			local freeze = Instance.new("BodyVelocity", hrp)
			freeze.Velocity = Vector3.new(0,0,0)
			freeze.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			task.delay(10, function() freeze:Destroy() end)
		end
	end
end)

makeButton("Speed Boost", 320, function(target)
	if target and target.Character then
		local hum = target.Character:FindFirstChildOfClass("Humanoid")
		if hum then
			local orig = hum.WalkSpeed
			hum.WalkSpeed = 100
			task.delay(10, function() hum.WalkSpeed = orig end)
		end
	end
end)

-- Comandi personali
makeButton("Invisible", 360, function()
	for _, p in ipairs(LocalPlayer.Character:GetDescendants()) do
		if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then p.Transparency = 1 end
	end
end)

makeButton("Visible", 400, function()
	for _, p in ipairs(LocalPlayer.Character:GetDescendants()) do
		if p:IsA("BasePart") then p.Transparency = 0 end
	end
end)

makeButton("Noclip", 440, function()
	for _, p in ipairs(LocalPlayer.Character:GetDescendants()) do
		if p:IsA("BasePart") then p.CanCollide = false end
	end
end)

-- 🕊️ Fly Toggle
local flyForce = nil
makeButton("Fly Toggle", 480, function()
	local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if hrp then
		if flyForce then
			flyForce:Destroy()
			flyForce = nil
		else
			flyForce = Instance.new("BodyVelocity", hrp)
			flyForce.Velocity = Vector3.new(0, 50, 0)
			flyForce.MaxForce = Vector3.new(1e5, 1e5, 1e5)
		end
	end
end)

-- Tasto M per riaprire
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.M then
		frame.Visible = not frame.Visible
	end
end)
