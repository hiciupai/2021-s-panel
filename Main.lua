local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- 🔗 Link al tuo file .lua su GitHub
local githubRawURL = "https://raw.githubusercontent.com/hiciupai/2021-s-panel/refs/heads/main/localscript.lua"

local function injectPanel(player)
	local success, content = pcall(function()
		return HttpService:GetAsync(githubRawURL)
	end)

	if success then
		local scriptInstance = Instance.new("LocalScript")
		scriptInstance.Name = "CoolkiddPanel"
		scriptInstance.Source = content
		scriptInstance.Parent = player:WaitForChild("PlayerScripts")
	else
		warn("⚠️ Errore durante il download del pannello:", content)
	end
end

Players.PlayerAdded:Connect(injectPanel)

-- ✅ Se vuoi che venga rieseguito durante il gioco, puoi anche ripetere l'iniezione manualmente:
-- for _, player in pairs(Players:GetPlayers()) do
--     injectPanel(player)
-- end
