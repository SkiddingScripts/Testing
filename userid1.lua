local player1 = game.Players.LocalPlayer
local whitelist = {1638172844}
local isWhitelisted = false
	for i, v in pairs(whitelist) do
		if v == player1.UserId then
			isWhitelisted = true
		end
	end
if isWhitelisted == false then
print("bruh?")
--	player1:Kick("Not whitelisted")
end
