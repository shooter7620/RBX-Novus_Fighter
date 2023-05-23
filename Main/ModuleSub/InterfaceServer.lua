local modRef
for i,v in pairs(game.ServerScriptService:GetChildren()) do
	if v:IsA("Folder") and v.Name == "Novus_Container" then
		if v:FindFirstChild("MainModule") then
			local ms = v:FindFirstChild("MainModule")
			if ms:GetAttribute("SubName") ~= nil and ms:GetAttribute("SubName") == "NovusFighter" then
				modRef = ms
			end
		end
	end
end
local ns = require(modRef).new()
local Novus = table.clone(ns["nilIndex"]) --This is honestly a crappy workaround. Please, do not do what I do here. --shooter7620
local moveCDTbl = {
	--[[["Example"] = {true,5,false,{},true}]] --Format: Move name/index as key, value is a table with a debounce boolean, a current cooldown value in seconds, a GCD boolean, and a GCD table of moves it is on GCD with.
}
moveCDTbl = Novus.Global.moveCDTbl
for i,v in pairs(Novus.Moves) do
	moveCDTbl[i] = {false,v[2],v[6],v[7],false}
end
local moveTbl = {}
local moveModeTbl = {}
local modeChangeFuncs = {
	["Blaster"] = function(plr:Player)
		Novus.Global.Force.showForceEye(plr,false,Color3.new(1,1,0),Color3.new(0,0,0),false)
		task.wait(0.75)
		Novus.Global.Force.showForceEye(plr,true)
	end,
	["Telekinesis"] = function(plr:Player)
		local fs = Novus.Global.AudioFolderReference.ForceSound:Clone()
		fs.Parent = plr.Character.PrimaryPart
		fs:Play()
		Novus.Global.Force.flashForceEye(plr,0.75)
		fs:Destroy()
	end,
}
local isActive = false
local rmDB = false
local msDB = false
for i,v in pairs(Novus.Moves) do
	if table.find(moveTbl,v[3]) == nil then
		moveTbl[v[3]] = {{v[1],v[4]}}
	else
		table.insert(moveTbl[v[3]],{v[1],v[4]})
	end
	if table.find(moveModeTbl,v[3]) == nil then
		table.insert(moveModeTbl,v[3])
	end
end
local tt = tick()
local function timeRecorder():(number,number)
	local dt = tick()-tt
	tt = tick()
	return tt,dt
end
local function reduceCDWithDelta(deltaTime:number)
	for i,v in pairs(moveCDTbl) do
		if v[1] == false and v[4] ~= Novus.Moves[i][7] then
			--decided to make this ignore after further consideration
			v[4] = Novus.Moves[i][7]
		elseif v[2] <= 0 then
			v[1] = false
			v[4] = Novus.Moves[i][7]
			--moveCDTbl[i] = nil
		elseif v[2] > 0 then
			v[2] -= deltaTime
			if v[2] <= 0 then
				v[1] = false
				v[4] = Novus.Moves[i][7]
				--moveCDTbl[i] = nil
			end
		end
	end
end
local function requestMoveRemote(plr:Player,remoteName:string)
	if plr ~= Novus.Global.UserPlayer then
		plr:Kick("Illegal remote access detected (fired a remote which is not permitted to be used by other players).")
		return false
	end
	local rm = Instance.new("RemoteEvent")
	rm.Name = remoteName
	rm.Parent = script
	return true,rm
end
local function removeMoveRemote(plr:Player,remote:RemoteEvent|RemoteFunction)
	if plr ~= Novus.Global.UserPlayer then
		plr:Kick("Illegal remote access detected (fired a remote which is not permitted to be used by other players).")
		return false
	end
	if typeof(remote) == "Instance" and remote.Parent == script and remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
		remote:Destroy()
		return true
	else
		return false,"Remote was an invalid argument (it was either not an RemoteEvent/RemoteFunction, or its parent was not "..script:GetFullName()..")."
	end
end
local function initMove(plr:Player,moveName:string,...)
	if plr ~= Novus.Global.UserPlayer then
		plr:Kick("Illegal remote access detected (fired remote "..script.UseMove:GetFullName().." which is not permitted to be used by other players).")
		return false
	end
	if isActive then
		if not rmDB then
			rmDB = true
			local moveExists:boolean = false
			for i,v in pairs(Novus.Moves) do
				if moveName == i then
					moveExists = true
				end
			end
			if moveExists then
				if not moveCDTbl[moveName] or moveCDTbl[moveName][1] == true then
					rmDB = false
					return false
				else
					for i,v in pairs(moveCDTbl) do
						for i2,v2 in pairs(moveCDTbl[moveName][4]) do
							if v2 == i and v[1] == true and table.find(v[4],moveName) ~= nil and v[5] == true then
								rmDB = false
								return false
							end
						end
						if v[1] == true then
							if v[3] == true and Novus.Moves[moveName][6] == true and v[5] == true then
								rmDB = false
								return false
							end
							for i3,v3 in pairs(v[4]) do
								if v3 == moveName and moveCDTbl[v3][5] == true then
									rmDB = false
									return false
								end
							end
						end
					end
				end
				local argTbl = {plr,...}
				local moveDictionary = Novus.Moves[moveName]
				local fArgTbl = {
					["Katana_Barrage"] = {"Player","RemoteEvent"},
					["Katana_Zone"] = {"Player","CFrame","Ray"},
					["Blue_Katana_Zone"] = {"Player","CFrame","Ray"},
					["Katana_Sliders"] = {"Player","RemoteEvent"},
					["Blue_Katana_Sliders"] = {"Player","RemoteEvent"},
					["Large_Katana_Zones"] = {"Player","CFrame","Ray"},
					["Rail_Blaster"] = {"Player","CFrame"},
					["Large_Rail_Blaster"] = {"Player","CFrame"},
					["Revolving_Rail_Blasters"] = {"Player","RemoteEvent"},
					["Quad_Rail_Blasters"] = {"Player","CFrame","BasePart","Ray"},
					["Homing_Blasters"] = {"Player"},
					["Blaster_Barrage"] = {"Player"},
					["Blaster_Circle"] = {"Player","CFrame","BasePart","Ray"},
					["Rail_Blaster_Defense"] = {"Player"},
					--["Super_Blaster_Circle"] = {"Player","CFrame","BasePart","Ray"},
					--Once again, the move above was disabled because it was impractical to fix the performance issues with it, so it was replaced... still need a better replacement. -shooter7620
					["Telekinetic_Suspension"] = {"Player","BasePart","RemoteEvent","CFrame","CFrame"},
					["Telekinetic_Slam"] = {"Player","BasePart","CFrame","CFrame"},
					["Telekinetic_Repulse"] = {"Player"},
					["Blink"] = {"Player","CFrame"},
					["Booster_Kit"] = {"Player"}
				}
				local argsTuple = {}
				for i,v in pairs(fArgTbl) do
					if moveName == i then
						for i2,v2 in ipairs(argTbl) do
							if i2 <= #v and typeof(v2) == v[i2] or typeof(v2) == "Instance" and v2:IsA(v[i2]) then
								table.insert(argsTuple,v2)
							else
								if typeof(v2) == "Instance" then
									warn("Improper parameter type for argument #"..i2..", type was "..v2.ClassName.."; requested type is "..v[i2]..".")
								else
									warn("Improper parameter type for argument #"..i2..", type was "..typeof(v2).."; requested type is "..v[i2]..".")
								end
								rmDB = false
								return false
							end --Hopefully a much more elegant solution that doesn't look so ugly.
						end
					end
				end
				task.spawn(moveDictionary[5],table.unpack(argsTuple))
				moveCDTbl[moveName] = {true,moveDictionary[2],moveDictionary[6],moveDictionary[7],true}
				rmDB = false
				return true,moveDictionary[2]
			else
				rmDB = false
				return false,warn("Invalid move name (something went wrong, report this to the creator please).")
			end
		end
	end
end

local function ServeMenu(plr:Player,menuName:string)
	if plr ~= Novus.Global.UserPlayer then
		plr:Kick("Illegal remote access detected (fired a remote which is not permitted to be used by other players).")
		return false
	end
	if Novus.Global.UIFolderReference.Novus_UI.Main[menuName] ~= nil and plr.PlayerGui.Novus_UI.Main:FindFirstChild(menuName) == nil then
		Novus.Global.UIFolderReference.Novus_UI.Main[menuName]:Clone().Parent = plr.PlayerGui.Novus_UI.Main
	end
end
local function changeMoveMode(plr:Player,modeName:string)
	if plr ~= Novus.Global.UserPlayer then
		plr:Kick("Illegal remote access detected (fired a remote which is not permitted to be used by other players).")
		return false
	end
	if isActive then
		if not msDB then
			msDB = true
			for i,v in pairs(moveModeTbl) do
				if v == modeName and v ~= "Universal" then
					for i2,v2 in pairs(modeChangeFuncs) do
						if i2 == modeName then
							task.spawn(v2,plr)
						end
					end
					msDB = false
					return true,modeName
				end
			end
			msDB = false
			return false,"The given mode index was not found or is \"Universal\", try again."
		end
	end
end
local function serveMoveList(plr:Player)
	if plr ~= Novus.Global.UserPlayer then
		plr:Kick("Illegal remote access detected (fired a remote which is not permitted to be used by other players).")
		return false
	end
	local tbl = {}
	for i,v in pairs(Novus.Moves) do
		tbl[i] = {v[4],v[3],v[2],v[8],v[1]}
	end
	return true,tbl
end

if script:FindFirstAncestorOfClass("Model") and game.Players:GetPlayerFromCharacter(script:FindFirstAncestorOfClass("Model")) ~= nil then
	Novus:Load(game.Players:GetPlayerFromCharacter(script:FindFirstAncestorOfClass("Model")))
	task.spawn(function ()
		timeRecorder()
		while Novus.Global.UserPlayer.Character.Humanoid.Health ~= 0 do
			local tt,dt = timeRecorder()
			reduceCDWithDelta(dt)
			task.wait()
		end
	end)
	for i,v in pairs(Novus.Moves) do
		if table.find(moveModeTbl,v[3]) == nil then
			table.insert(moveModeTbl,v[3])
		end
	end
	local baseUI = Novus.Global.UIFolderReference.Novus_UI:Clone()
	for i,v in pairs(baseUI.Main:GetChildren()) do
		v:Destroy()
	end
	baseUI.Parent = Novus.Global.UserPlayer.PlayerGui
	script.EnableChar.OnServerInvoke = function (plr)
		Novus.Passives.EnableReflexes(plr)
		isActive = true
		script.InterfaceClient:SetAttribute("CharStamina",150)
		script.InterfaceClient:SetAttribute("CharHealth",10)
		local AUI = Novus.Global.UIFolderReference.Novus_UI.Main.AttackUI:Clone()
		AUI.Parent = plr.PlayerGui.Novus_UI.Main
		local CharInfoUI = Novus.Global.UIFolderReference.Novus_UI.Main.CharInfoUI:Clone()
		CharInfoUI.Parent = plr.PlayerGui.Novus_UI.Main
		task.spawn(function ()
			while Novus.Global.UserPlayer.PlayerGui.Novus_UI ~= nil do
				script.InterfaceClient:SetAttribute("CharStamina",Novus.Passives.Variables.Stamina)
				script.InterfaceClient:SetAttribute("CharHealth",Novus.Passives.Variables.RealHealth)
				task.wait()
			end
		end)
		return true,"Sword","Novus Character is now active."
	end
	script.UseMove.OnServerInvoke = initMove
	script.ChangeMoveMode.OnServerInvoke = changeMoveMode
	script.OpenMenu.OnServerEvent:Connect(ServeMenu)
	script.GetMoves.OnServerInvoke = serveMoveList
	script.RequestRemote.OnServerInvoke = requestMoveRemote
	script.RemoveRemote.OnServerInvoke = removeMoveRemote
	script.EnableLoadingForPlayer.OnServerInvoke = function(plr:Player,enable:boolean,doOnce:boolean)
		if plr ~= Novus.Global.UserPlayer then
			plr:Kick("Illegal remote access detected (fired a remote which is not permitted to be used by other players).")
			return false
		end
		local s,v = Novus.Global.HomeReference.Init.EnableLoadingServer:Invoke(plr,enable,doOnce)
		if s then
			return true,v
		else
			return false,v
		end
	end
	script.UnloadFromChar.OnServerEvent:Connect(function (plr)
		if plr ~= Novus.Global.UserPlayer then
			plr:Kick("Illegal remote access detected (fired a remote which is not permitted to be used by other players).")
			return false
		end
		if plr.PlayerGui:FindFirstChild("Novus_UI") ~= nil then
			plr.PlayerGui.Novus_UI:Destroy()
		end
		table.clear(Novus)
		table.clear(moveCDTbl)
		table.clear(moveTbl)
		table.clear(moveModeTbl)
		changeMoveMode = nil
		ServeMenu = nil
		timeRecorder = nil
		initMove = nil
		reduceCDWithDelta = nil
		script.InterfaceClient.Enabled = false
		script:Destroy()
		script.Enabled = false --Basically, just nuke EVERYTHING to try to minimize memory leak issues (not saying that there are any, just to minimize risk). -shooter7620
	end)
	script.InterfaceClient.Enabled = true
else
	if game.Players:GetPlayerFromCharacter(script:FindFirstAncestorOfClass("Model")) == nil then
		local bl = true
		while bl do
			if game.Players:GetPlayerFromCharacter(script:FindFirstAncestorOfClass("Model")) ~= nil then
				bl = false
				break
			end
			task.wait()
		end
	end
	Novus:Load(game.Players:GetPlayerFromCharacter(script:FindFirstAncestorOfClass("Model")))
	task.spawn(function ()
		timeRecorder()
		while Novus.Global.UserPlayer.Character.Humanoid.Health ~= 0 do
			local tt,dt = timeRecorder()
			reduceCDWithDelta(dt)
			task.wait()
		end
	end)
	for i,v in pairs(Novus.Moves) do
		if table.find(moveModeTbl,v[3]) == nil then
			table.insert(v[3])
		end
	end
	local baseUI = script.Parent.UI.Novus_UI:Clone()
	for i,v in pairs(baseUI.Main:GetChildren()) do
		v:Destroy()
	end
	baseUI.Parent = Novus.Global.UserPlayer.PlayerGui
	script.EnableChar.OnServerInvoke = function (plr)
		Novus.Passives.EnableReflexes(plr)
		isActive = true
		script.InterfaceClient:SetAttribute("CharStamina",150)
		script.InterfaceClient:SetAttribute("CharHealth",10)
		local AUI = Novus.Global.UIFolderReference.Novus_UI.Main.AttackUI:Clone()
		AUI.Parent = plr.PlayerGui.Novus_UI.Main
		local CharInfoUI = Novus.Global.UIFolderReference.Novus_UI.Main.CharInfoUI:Clone()
		CharInfoUI.Parent = plr.PlayerGui.Novus_UI.Main
		task.spawn(function ()
			while Novus.Global.UserPlayer.PlayerGui.Novus_UI ~= nil do
				script.InterfaceClient:SetAttribute("CharStamina",Novus.Passives.Variables.Stamina)
				script.InterfaceClient:SetAttribute("CharHealth",Novus.Passives.Variables.RealHealth)
				task.wait()
			end
		end)
		return true,"Sword","Novus Character is now active."
	end
	script.EnableLoadingForPlayer.OnServerInvoke = function(plr:Player,enable:boolean,doOnce:boolean)
		if plr ~= Novus.Global.UserPlayer then
			plr:Kick("Illegal remote access detected (fired a remote which is not permitted to be used by other players).")
			return false
		end
		local s,v = Novus.Global.HomeReference.Init.EnableLoadingServer:Invoke(plr,enable,doOnce)
		if s then
			return true,v
		else
			return false,v
		end
	end
	script.UseMove.OnServerInvoke = initMove
	script.ChangeMoveMode.OnServerInvoke = changeMoveMode
	script.OpenMenu.OnServerEvent:Connect(ServeMenu)
	script.GetMoves.OnServerInvoke = serveMoveList
	script.RequestRemote.OnServerInvoke = requestMoveRemote
	script.RemoveRemote.OnServerInvoke = removeMoveRemote
	script.UnloadFromChar.OnServerEvent:Connect(function (plr)
		if plr ~= Novus.Global.UserPlayer then
			plr:Kick("Illegal remote access detected (fired a remote which is not permitted to be used by other players).")
			return false
		end
		if plr.PlayerGui:FindFirstChild("Novus_UI") ~= nil then
			plr.PlayerGui.Novus_UI:Destroy()
		end
		Novus.Global.ModelFolderReference:Destroy()
		Novus.Global.AudioFolderReference:Destroy()
		Novus.Global.UIFolderReference:Destroy()
		table.clear(Novus)
		table.clear(moveCDTbl)
		table.clear(moveTbl)
		table.clear(moveModeTbl)
		changeMoveMode = nil
		ServeMenu = nil
		timeRecorder = nil
		initMove = nil
		reduceCDWithDelta = nil
		script.InterfaceClient.Enabled = false
		script:Destroy()
		script.Enabled = false --Basically, just nuke EVERYTHING to try to minimize memory leak issues (not saying that there are any, just to minimize risk). -shooter7620
	end)
	script.InterfaceClient.Enabled = true
end
