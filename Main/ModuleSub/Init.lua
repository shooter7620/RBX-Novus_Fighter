local nv = require(script.Parent)

local enabledPlrTbl = {}
local connTbl = {}
local function loadScript(plr:Player,reload:boolean)
	if reload then
		if plr:GetRankInGroup(3149674) >= 30 or nv.Global.ManualWhitelist[tostring(plr.UserId)] ~= nil then
			if plr.Character == nil then
				plr.CharacterAdded:Wait()
			end
			if plr.Character:FindFirstChild("InterfaceServer") == nil then
				local IS = script.Parent.InterfaceServer:Clone()
				if plr.Character == nil then
					plr.CharacterAdded:Wait()
				end
				IS.Parent = plr.Character
				IS.Enabled = true
				table.insert(enabledPlrTbl,plr)
				local conn = plr.CharacterAdded:Connect(function()
					if plr.Character == nil then
						plr.CharacterAdded:Wait()
					end
					local I2 = script.Parent.InterfaceServer:Clone()
					I2.Parent = plr.Character
					I2.Enabled = true
				end)
				connTbl[plr] = conn
				print(connTbl)
			else
				if table.find(enabledPlrTbl,plr) == nil and reload then
					local conn = plr.CharacterAdded:Connect(function()
						if plr.Character == nil then
							plr.CharacterAdded:Wait()
						end
						local I2 = script.Parent.InterfaceServer:Clone()
						I2.Parent = plr.Character
						I2.Enabled = true
					end)
					connTbl[plr] = conn
					print(connTbl)
				end
			end
		end
	else
		if plr:GetRankInGroup(3149674) >= 30 or nv.Global.ManualWhitelist[plr.UserId] ~= nil then
			if plr.Character == nil then
				plr.CharacterAdded:Wait()
			end
			if plr.Character:FindFirstChild("InterfaceServer") ~= nil then
				if table.find(enabledPlrTbl,plr) == nil then
					return false,"Loading is already disabled for player."
				else
					connTbl[plr]:Disconnect()
					table.remove(enabledPlrTbl,table.find(enabledPlrTbl,plr))
					return true,"Loading disabled."
				end
			end
			local IS = script.Parent.InterfaceServer:Clone()
			wait(plr.Character ~= nil)
			IS.Parent = plr.Character
			IS.Enabled = true
		else
			warn("Failure to load script onto player "..plr.Name)
		end
	end
end

game.Players.PlayerAdded:Connect(function (plr)
	if plr:GetRankInGroup(3149674) >= 30 or nv.Global.ManualWhitelist[plr.UserId] ~= nil then
		loadScript(plr,false)
	end
end)
script.EnableLoadingServer.OnInvoke = function(plr:Player,enable:boolean,doOnce:boolean)
	if not enable then
		if table.find(enabledPlrTbl,plr) == nil then
			return false,"Loading is already disabled for player."
		else
			connTbl[plr]:Disconnect()
			table.remove(enabledPlrTbl,table.find(enabledPlrTbl,plr))
			return true,"Loading disabled."
		end
	else
		local s,v = pcall(loadScript,plr,enable)
		if s then
			return true,"Novus loaded for player."
		else
			return false,v
		end
	end
end
wait(5)
for i,plr in pairs(game.Players:GetPlayers()) do
	if plr:GetRankInGroup(3149674) >= 30 or nv.Global.ManualWhitelist[plr.UserId] ~= nil then
		task.spawn(loadScript,plr,false)
	end
end
