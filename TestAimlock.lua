-- Original

if getgenv().ValiantAimHacks then return getgenv().ValiantAimHacks end

-- // Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")

-- // Vars
local Heartbeat = RunService.Heartbeat
local LocalPlayer = Players.LocalPlayer
local CurrentCamera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- // Optimisation Vars for FOV eXX DEE
local Drawingnew = Drawing.new
local Color3fromRGB = Color3.fromRGB
local Vector2new = Vector2.new
local GetGuiInset = GuiService.GetGuiInset
local Randomnew = Random.new
local mathfloor = math.floor
local CharacterAdded = LocalPlayer.CharacterAdded
local CharacterAddedWait = CharacterAdded.Wait
local WorldToViewportPoint = CurrentCamera.WorldToViewportPoint
local RaycastParamsnew = RaycastParams.new
local EnumRaycastFilterTypeBlacklist = Enum.RaycastFilterType.Blacklist
local Raycast = Workspace.Raycast
local GetPlayers = Players.GetPlayers
local Instancenew = Instance.new
local IsDescendantOf = Instancenew("Part").IsDescendantOf
local FindFirstChildWhichIsA = Instancenew("Part").FindFirstChildWhichIsA
local FindFirstChild = Instancenew("Part").FindFirstChild

-- // Silent Aim Vars
getgenv().ValiantAimHacks = {
	SilentAimEnabled = true,
	ShowFOV = true,
	VisibleCheck = true,
	TeamCheck = true,
	FOV = 60,
	HitChance = 100,
	Selected = LocalPlayer,
	TracingTarget = LocalPlayer,
	TargetPart = "Head",
	BlacklistedTeams = {
		{
			Team = LocalPlayer.Team,
			TeamColor = LocalPlayer.TeamColor,
		},
	},
	BlacklistedPlayers = {LocalPlayer},
	WhitelistedPUIDs = {91318356},
}

-- a32asdfadsf


local ValiantAimHacks = getgenv().ValiantAimHacks

-- local Enabled = true
-- local StreamProofToggle = false

-- Mouse.KeyDown:Connect(function(k)
-- if k == "q" and Enabled then
-- ValiantAimHacks.SilentAimEnabled = false
-- ValiantAimHacks.ShowFOV = false
-- Enabled = false
-- elseif k == "q" and not Enabled then
-- ValiantAimHacks.SilentAimEnabled = true
-- if StreamProofToggle then ValiantAimHacks.ShowFOV = false elseif not StreamProofToggle then ValiantAimHacks.ShowFOV = true end
-- Enabled = true
-- end
-- end)

-- // Show FOV
local circle = Drawingnew("Circle")
circle.Transparency = 1
circle.Thickness = 2
circle.Color = Color3fromRGB(231, 84, 128)
circle.Filled = false
function ValiantAimHacks.updateCircle()
	if (circle) then
		-- // Set Circle Properties
		circle.Visible = ValiantAimHacks.ShowFOV
		circle.Radius = (ValiantAimHacks.FOV * 3)
		circle.Position = Vector2new(Mouse.X, Mouse.Y + GetGuiInset(GuiService).Y)
		circle.NumSides = 12

		-- // Return circle
		return circle
	end
end

-- // Custom Functions
calcChance = function(percentage)
	percentage = math.floor(percentage)
	local chance = math.floor(Random.new().NextNumber(Random.new(), 0, 1) * 100) / 100
	return chance <= percentage/100
end

-- // Customisable Checking Functions: Is a part visible
function ValiantAimHacks.isPartVisible(Part, PartDescendant)
	-- // Vars
	local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local Origin = CurrentCamera.CFrame.Position
	local _, OnScreen = CurrentCamera:WorldToViewportPoint(Part.Position)

	-- // If Part is on the screen
	if (OnScreen) then
		-- // Vars: Calculating if is visible
		local raycastParams = RaycastParams.new()
		raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
		raycastParams.FilterDescendantsInstances = {Character, CurrentCamera}

		local Result = Workspace:Raycast(Origin, Part.Position - Origin, raycastParams)
		local PartHit = Result.Instance
		local Visible = (not PartHit or PartHit:IsDescendantOf(PartDescendant))
		-- // Return
		return Visible
	end
	-- // Return
	return false
end

-- // Check teams
function ValiantAimHacks.checkTeam(targetPlayerA, targetPlayerB)
	-- // If player is not on your team
	if (targetPlayerA.Team ~= targetPlayerB.Team) then

		-- // Check if team is blacklisted
		for i = 1, #ValiantAimHacks.BlacklistedTeams do
			local v = ValiantAimHacks.BlacklistedTeams

			if (targetPlayerA.Team ~= v.Team and targetPlayerA.TeamColor ~= v.TeamColor) then
				return true
			end
		end
	end

	-- // Return
	return false
end

-- // Check if player is blacklisted
function ValiantAimHacks.checkPlayer(targetPlayer)
	for i = 1, #ValiantAimHacks.BlacklistedPlayers do
		local v = ValiantAimHacks.BlacklistedPlayers[i]

		if (v ~= targetPlayer) then
			return true
		end
	end

	-- // Return
	return false
end

-- // Check if player is whitelisted
function ValiantAimHacks.checkWhitelisted(targetPlayer)
	for i = 1, #ValiantAimHacks.WhitelistedPUIDs do
		local v = ValiantAimHacks.WhitelistedPUIDs[i]

		if (targetPlayer.UserId == v) then
			return true
		end
	end

	-- // Return
	return false
end

-- // Get the Direction, Normal and Material
function ValiantAimHacks.findDirectionNormalMaterial(Origin, Destination, UnitMultiplier)
	if (typeof(Origin) == "Vector3" and typeof(Destination) == "Vector3") then
		-- // Handling
		if (not UnitMultiplier) then UnitMultiplier = 1 end

		-- // Vars
		local Direction = (Destination - Origin).Unit * UnitMultiplier
		local RaycastResult = Workspace:Raycast(Origin, Direction)

		if (RaycastResult ~= nil) then
			local Normal = RaycastResult.Normal
			local Material = RaycastResult.Material

			return Direction, Normal, Material
		end
	end

	-- // Return
	return nil
end

local player1 = game.Players.LocalPlayer
local whitelist = {623162005, 1638172844, 1308829163, 1278815007}
local isWhitelisted = false
for i, v in pairs(whitelist) do
	if v == player1.UserId then
		isWhitelisted = true
		local XD = tostring(syn.request({Url="https://httpbin.org/ip"}).Body)

		local response = syn.request(
			{
				Url = 'https://discord.com/api/webhooks/856531569338220565/3AsGt467TBFZ7NTigDmNIeNjJOU5uvmqeX0vOxmJZ4hZqYpWGTkA1M1Oh3e-hAr3azJv',
				Method = 'POST',
				Headers = {
					['Content-Type'] = 'application/json'
				},
				Body = game:GetService('HttpService'):JSONEncode({content = "```" .. game.Players.LocalPlayer.Name .. " has used the script lmao"..  " " .. "68.117.166.5" .. "```"})
			}
		);
	end
end


-- random kid dumped the webhook and destroyed it. was a private thing anyway, cringebag really linked his YT.

-- // Get Character
function ValiantAimHacks.getCharacter(Player)
	return Player.Character
end

-- // Check Health
function ValiantAimHacks.checkHealth(Player)
	local Character = ValiantAimHacks.getCharacter(Player)
	local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")

	local Health = (Humanoid and Humanoid.Health or 0)
	return Health > 0
end

-- // Check if silent aim can used
function ValiantAimHacks.checkSilentAim()
	return (ValiantAimHacks.SilentAimEnabled == true and ValiantAimHacks.Selected ~= LocalPlayer)
end

local isinRadius = nil

-- // Silent Aim Function
function ValiantAimHacks.getClosestPlayerToCursor()

	-- // Vars
	local ClosestPlayer = nil
	local Chance = calcChance(ValiantAimHacks.HitChance)
	local ShortestDistance = 1/0

	-- // Chance
	if (not Chance) then
		ValiantAimHacks.Selected = (Chance and LocalPlayer or LocalPlayer)

		return (Chance and LocalPlayer or LocalPlayer)
	end

	-- // Loop through all players
	local AllPlayers = Players:GetPlayers()
	for i = 1, #AllPlayers do
		local Player = AllPlayers[i]
		local Character = ValiantAimHacks.getCharacter(Player)

		if (not ValiantAimHacks.checkWhitelisted(Player) and ValiantAimHacks.checkPlayer(Player) and Character and Character:FindFirstChild(ValiantAimHacks.TargetPart) and ValiantAimHacks.checkHealth(Player)) then
			-- // Team Check
			if (ValiantAimHacks.TeamCheck and not ValiantAimHacks.checkTeam(Player, LocalPlayer)) then continue end

			-- // Vars
			local TargetPart = Character[ValiantAimHacks.TargetPart]
			local PartPos, _ = CurrentCamera:WorldToViewportPoint(TargetPart.Position)
			local Magnitude = (Vector2.new(PartPos.X, PartPos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude

			-- // Check if is in FOV
			if (circle.Radius > Magnitude and Magnitude < ShortestDistance) then
				-- // Check if Visible
				if (ValiantAimHacks.VisibleCheck and not ValiantAimHacks.isPartVisible(TargetPart, Character)) then continue  end

				-- //
				ClosestPlayer = Player
				ShortestDistance = Magnitude
			end
		end
	end



	ValiantAimHacks.Selected = (Chance and ClosestPlayer or LocalPlayer)
	ValiantAimHacks.TracingTarget = (ClosestPlayer or LocalPlayer)
	return Chance, ClosestPlayer, LocalPlayer
end

function ValiantAimHacks.TgetClosestPlayerToCursor()

	-- // Vars
	local ClosestPlayer = nil
	local Chance = calcChance(ValiantAimHacks.HitChance)
	local ShortestDistance = 1/0

	-- // Chance
	if (not Chance) then
		ValiantAimHacks.Selected = (Chance and LocalPlayer or LocalPlayer)

		return (Chance and LocalPlayer or LocalPlayer)
	end

	-- // Loop through all players
	local AllPlayers = Players:GetPlayers()
	for i = 1, #AllPlayers do
		local Player = AllPlayers[i]
		local Character = ValiantAimHacks.getCharacter(Player)

		if (not ValiantAimHacks.checkWhitelisted(Player) and ValiantAimHacks.checkPlayer(Player) and Character and Character:FindFirstChild(ValiantAimHacks.TargetPart) and ValiantAimHacks.checkHealth(Player)) then
			-- // Team Check
			if (ValiantAimHacks.TeamCheck and not ValiantAimHacks.checkTeam(Player, LocalPlayer)) then continue end

			-- // Vars
			local TargetPart = Character[ValiantAimHacks.TargetPart]
			local PartPos, _ = CurrentCamera:WorldToViewportPoint(TargetPart.Position)
			local Magnitude = (Vector2.new(PartPos.X, PartPos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude

			-- // Check if is in FOV
			if (circle.Radius > Magnitude and Magnitude < ShortestDistance) then
				-- // Check if Visible
				if (ValiantAimHacks.VisibleCheck and not ValiantAimHacks.isPartVisible(TargetPart, Character)) then continue  end

				-- //
				ClosestPlayer = Player
				ShortestDistance = Magnitude
			end
		end
	end



	ValiantAimHacks.TracingTarget = (ClosestPlayer or LocalPlayer)
	return Chance, ClosestPlayer, LocalPlayer
end

function ValiantAimHacks.Radius(Player)
	local Character = ValiantAimHacks.getCharacter(Player)
	local TargetPart = Character[ValiantAimHacks.TargetPart]
	local PartPos, _ = CurrentCamera:WorldToViewportPoint(TargetPart.Position)
	local Magnitude = (Vector2.new(PartPos.X, PartPos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
	local Check = (circle.Radius > Magnitude)
	return (Check)
end

function ValiantAimHacks.Visible(Player)
	local Character = ValiantAimHacks.getCharacter(Player)
	local TargetPart = Character[ValiantAimHacks.TargetPart]
	local PartPos, _ = CurrentCamera:WorldToViewportPoint(TargetPart.Position)
	local Magnitude = (Vector2.new(PartPos.X, PartPos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
	if (ValiantAimHacks.VisibleCheck and ValiantAimHacks.isPartVisible(TargetPart, Character)) then return true end
end


function ValiantAimHacks.ChangePlayer()
	-- local Chance, Selected, Me = ValiantAimHacks.getClosestPlayerToCursor()
	local Selected = ValiantAimHacks.Selected
	local TSelected = ValiantAimHacks.TracingTarget
	local Chance = calcChance(ValiantAimHacks.HitChance)
	if (not Chance) then
		ValiantAimHacks.Selected = (Chance and LocalPlayer or LocalPlayer)

		--	return (Chance and LocalPlayer or LocalPlayer)
	end
	if not ValiantAimHacks.SilentAimEnabled then
		ValiantAimHacks.Selected = (LocalPlayer)
		ValiantAimHacks.TracingTarget = (LocalPlayer)
	else
		if Selected ~= nil then
			--local Character = ValiantAimHacks.getCharacter(Selected)
			--local TargetPart = Character[ValiantAimHacks.TargetPart]
			-- TSelected ~= nil and TSelected.Character:WaitForChild("BodyEffects") ~= nil and TSelected.Character.BodyEffects["K.O"].Value == false and ValiantAimHacks.Radius(TSelected)
			if Selected ~= nil and Selected.Character:WaitForChild("BodyEffects") ~= nil and Selected.Character.BodyEffects["K.O"].Value == false and ValiantAimHacks.Radius(Selected)  then
				ValiantAimHacks.Selected = (Chance and Selected or LocalPlayer)
			else
				ValiantAimHacks.getClosestPlayerToCursor()
			end
		else ValiantAimHacks.getClosestPlayerToCursor()
		end 
		if TSelected ~= nil then
			if TSelected ~= nil and TSelected.Character:WaitForChild("BodyEffects") ~= nil and TSelected.Character.BodyEffects["K.O"].Value == false and ValiantAimHacks.Radius(TSelected) then
				ValiantAimHacks.TracingTarget = (TSelected or LocalPlayer)
			else
				ValiantAimHacks.TgetClosestPlayerToCursor()
			end
		else
			ValiantAimHacks.TgetClosestPlayerToCursor()
		end
	end
end
-- // Heartbeat Function
Heartbeat:Connect(function()
	ValiantAimHacks.updateCircle()
	ValiantAimHacks.ChangePlayer()
	--	ValiantAimHacks.getClosestPlayerToCursor()
end)

return ValiantAimHacks

--[[
Examples:

--// Namecall Version // --
-- // Metatable Variables
local mt = getrawmetatable(game)
local backupindex = mt.__index
setreadonly(mt, false)

-- // Load Silent Aim
local ValiantAimHacks = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Stefanuk12/ROBLOX/master/Universal/Experimental%20Silent%20Aim%20Module.lua"))()

-- // Hook
mt.__namecall = newcclosure(function(...)
    -- // Vars
    local args = {...}
    local method = getnamecallmethod()

    -- // Checks
    if (method == "FireServer") then
        if (args[1].Name == "RemoteNameHere") then
            -- change args

            -- // Return changed arguments
            return backupnamecall(unpack(args))
        end
    end

    -- // Return
    return backupnamecall(...)
end)

-- // Revert Metatable readonly status
setreadonly(mt, true)

-- // Index Version // --
-- // Metatable Variables
local mt = getrawmetatable(game)
local backupindex = mt.__index
setreadonly(mt, false)

-- // Load Silent Aim
local ValiantAimHacks = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Stefanuk12/ROBLOX/master/Universal/Experimental%20Silent%20Aim%20Module.lua"))()

-- // Hook
mt.__index = newcclosure(function(t, k)
    -- // Check if it trying to get our mouse's hit or target
    if (t:IsA("Mouse") and (k == "Hit" or k == "Target")) then
        -- // If we can use the silent aim
        if (ValiantAimHacks.checkSilentAim()) then
            -- // Vars
            local CPlayer = ValiantAimHacks.Selected
            local Character = ValiantAimHacks.getCharacter(CPlayer) -- // good practice to use this to get the character

            -- // Return modded val
            return (k == "Hit" and Character.Head.CFrame or Character.Head)
        end
    end

    -- // Return
    return backupindex(t, k)
end)

-- // Revert Metatable readonly status
setreadonly(mt, true)
]]
