wait(game.Players.LocalPlayer ~= nil)
local plr:Player = game.Players.LocalPlayer
wait(plr.Character ~= nil)
local char:Model = plr.Character
local mouse:Mouse = plr:GetMouse()
wait(plr.PlayerGui:FindFirstChild("Novus_UI") ~= nil)
local TS = game:GetService("TweenService")
local UTI = TweenInfo.new(
	0.5,
	Enum.EasingStyle.Sine,
	Enum.EasingDirection.In,
	0,
	false,
	0
)

script.Parent.OpenMenu:FireServer("MenuUI")
plr.PlayerGui.Novus_UI.Main:WaitForChild("MenuUI",5)
assert(plr.PlayerGui.Novus_UI.Main.MenuUI ~= nil,"Epic UI replication fail ("..plr.PlayerGui.Novus_UI.Main:GetFullName()..".MenuiUI is nil)!")
plr.PlayerGui.Novus_UI.Main.MenuUI.Visible = true
local UIS = game:GetService("UserInputService")

local slots:Frame
local UIMain:Frame = plr.PlayerGui.Novus_UI.Main
local selectionMenu:Frame = plr.PlayerGui.Novus_UI.Main.MenuUI.SelectionFrm
local loadButton:TextButton = selectionMenu.LoadDefault
local creditsButton:TextButton = selectionMenu.Credits
local infoButton:TextButton = selectionMenu.Info
local settingsButton:TextButton = plr.PlayerGui.Novus_UI.Main.MenuUI.SettingsButton
local usgHelpButton:TextButton
local charInfoButton:TextButton
local userSettings = {
	scriptReload = false
}
local atkUI:Frame
local CHInfoUI:Frame
local currentMode:string
local movesTbl = {}
local blsMovesTbl = {}
local ktMovesTbl = {}
local tkMovesTbl = {}
local univMovesTbl = {}
local connTbl = {}
local modeIndex
local refTbl = {
	["Sword"] = ktMovesTbl,
	["Blaster"] = blsMovesTbl,
	["Telekinesis"] = tkMovesTbl,
	["Universal"] = univMovesTbl
}
local function createAnimCDUI(Frm:Frame,cdTime:number)
	local frmCl = Frm:Clone()
	frmCl.Parent = Frm
	frmCl.TextButton:Destroy()
	local frmText:TextButton = Frm.TextButton
	local ot = Frm:GetAttribute("Default")
	local currCD = cdTime
	frmCl.BorderSizePixel = 0
	frmCl.Position = UDim2.fromScale(0,0)
	frmCl.Size = UDim2.fromScale(1,1)
	frmCl.ZIndex = Frm.ZIndex - 1
	frmCl.BackgroundColor3 = Color3.new(1,0,0)
	task.spawn(function ()
		local ct = tick()
		while currCD > 0 do
			currCD -= tick()-ct
			frmText.Text = math.floor(currCD*10)/10
			frmCl.Size = UDim2.fromScale(1,math.clamp(currCD/cdTime,0,1))
			ct = tick()
			task.wait()
		end
		frmText.Text = ot
		frmCl:Destroy()
	end)
end
local function changeMode(modeName:string,atkFrm:Frame)
	for i,v in pairs(atkUI:GetChildren()) do
		if v.Name ~= "UniversalMovesFrm" and v.Name ~= "MoveInfo" and v.Name ~= "UsgHelp" and not v:IsA("UIAspectRatioConstraint") and v.Visible == true then
			v.Visible = false
		end
	end
	atkFrm.Visible = true
	local slotFrm = atkFrm.AttackMovesFrm
	local s,v = script.Parent.ChangeMoveMode:InvokeServer(modeName)
	if s then
		currentMode = v
	end
	slots = slotFrm
	local twC:TextLabel = atkFrm.ModeTitleFrm.Title:Clone()
	twC.Parent = atkFrm.ModeTitleFrm
	twC.Transparency = 0.4
	TS:Create(twC,UTI,{Transparency = 1}):Play()
	twC:TweenSize(UDim2.fromScale(twC.Size.X.Scale*2,twC.Size.Y.Scale*2),Enum.EasingDirection.In,Enum.EasingStyle.Sine,0.5,false,function ()
		twC:Destroy()
	end)
end

local modeSwitchDB = false

loadButton.MouseButton1Click:Once(function()
	local s,v,i = script.Parent.EnableChar:InvokeServer()
	if s then
		atkUI = UIMain.AttackUI
		CHInfoUI = UIMain.CharInfoUI
		usgHelpButton = atkUI.UsgHelp
		charInfoButton = atkUI.MoveInfo
		UIMain:FindFirstChild("MenuUI"):Destroy() --Why is this nil sometimes? Edit: Noticed it only happens in Studio. Might be an issue with that, then.
		atkUI.Visible = true
		modeIndex = {
			["Sword"] = atkUI.SwordFrm,
			["Blaster"] = atkUI.BlsFrm,
			["Telekinesis"] = atkUI.TkFrm
		}
		slots = atkUI.SwordFrm.AttackMovesFrm
		CHInfoUI.Visible = true
		task.spawn(function ()
			while char.Humanoid.Health > 1 do
				CHInfoUI.StmOverhead.Bar.StmValue.Text = script:GetAttribute("CharStamina").."/150"
				CHInfoUI.StmOverhead.Bar.Indicator.Size = UDim2.fromScale(math.clamp(script:GetAttribute("CharStamina")/150,0,1),1)
				task.wait()
			end
		end)
		local s2,v2 = script.Parent.ChangeMoveMode:InvokeServer(v)
		if s2 then
			local twC:TextLabel = atkUI.SwordFrm.ModeTitleFrm.Title:Clone()
			twC.Parent = atkUI.SwordFrm.ModeTitleFrm
			twC.Transparency = 0.4
			TS:Create(twC,UTI,{Transparency = 1}):Play()
			twC:TweenSize(UDim2.fromScale(twC.Size.X.Scale*2,twC.Size.Y.Scale*2),Enum.EasingDirection.In,Enum.EasingStyle.Sine,0.5,false,function ()
				twC:Destroy()
			end)
			currentMode = v2
		end
		local s,t = script.Parent.GetMoves:InvokeServer()
		movesTbl = t
		for i,v in pairs(movesTbl) do
			if v[2] == "Sword" then
				ktMovesTbl[i] = v[1]
			elseif v[2] == "Blaster" then
				blsMovesTbl[i] = v[1]
			elseif v[2] == "Telekinesis" then
				tkMovesTbl[i] = v[1]
			elseif v[2] == "Universal" then
				univMovesTbl[i] = v[1]
			end
		end
		usgHelpButton.MouseButton1Click:Connect(function()
			if UIMain:FindFirstChild("UsgInfo") == nil then
				script.Parent.OpenMenu:FireServer("UsgInfo")
				UIMain:WaitForChild("UsgInfo",5)
				UIMain.UsgInfo.Visible = true
				local conn:RBXScriptConnection
				conn = UIMain.UsgInfo.TitleFrm.CloseButton.MouseButton1Click:Connect(function()
					UIMain.UsgInfo.Visible = false
				end)
				UIMain.UsgInfo:GetPropertyChangedSignal("Visible"):Connect(function()
					if UIMain.UsgInfo.Visible == false then
						conn:Disconnect()
					elseif UIMain.UsgInfo.Visible == true then
						conn = UIMain.UsgInfo.TitleFrm.CloseButton.MouseButton1Click:Connect(function()
							UIMain.UsgInfo.Visible = false
						end)
					end
				end)
			else
				UIMain.UsgInfo.Visible = true
			end
		end)
		charInfoButton.MouseButton1Click:Connect(function()
			if UIMain:FindFirstChild("NovusCharInfo") == nil then
				script.Parent.OpenMenu:FireServer("NovusCharInfo")
				UIMain:WaitForChild("NovusCharInfo",5)
				local osRef:Frame = UIMain.NovusCharInfo.MoveInfoFrm.MoveInfo
				local clc = osRef.LayoutOrder
				local ft = true
				for i,v in pairs(movesTbl) do
					if ft then
						local miClone = osRef:Clone()
						miClone.Parent = UIMain.NovusCharInfo.MoveInfoFrm
						miClone.Title.Text = v[2].." Mode - "..v[5].."["..v[1].."]"
						miClone.Section.Text = "Base Damage: "..v[4]["dmg"].." Decay Damage: "..v[4]["decayDmg"].." Description: "..v[4]["desc"]
						ft = false
					else
						local miClone = osRef:Clone()
						miClone.Parent = UIMain.NovusCharInfo.MoveInfoFrm
						miClone.Title.Text = v[2].." Mode - "..v[5].."["..v[1].."]"
						miClone.Section.Text = "Base Damage: "..v[4]["dmg"].." Decay Damage: "..v[4]["decayDmg"].." Description: "..v[4]["desc"]
						clc += 1
						miClone.LayoutOrder = clc
					end
				end
				osRef:Destroy()
				UIMain.NovusCharInfo.Visible = true
				local conn:RBXScriptConnection
				conn = UIMain.NovusCharInfo.TitleFrm.CloseButton.MouseButton1Click:Connect(function()
					UIMain.NovusCharInfo.Visible = false
				end)
				UIMain.NovusCharInfo:GetPropertyChangedSignal("Visible"):Connect(function()
					if UIMain.NovusCharInfo.Visible == false then
						conn:Disconnect()
					elseif UIMain.NovusCharInfo.Visible == true then
						conn = UIMain.NovusCharInfo.TitleFrm.CloseButton.MouseButton1Click:Connect(function()
							UIMain.NovusCharInfo.Visible = false
						end)
					end
				end)
			else
				UIMain.NovusCharInfo.Visible = true
			end
		end)
		local conn = UIS.InputBegan:Connect(function (input,isProcessed)
			if not isProcessed and not modeSwitchDB then --Added a reference to the debounce for switching modes so you don't accidentally use moves from a different mode while switching... if you have lag. -shooter7620
				if input.KeyCode == Enum.KeyCode.Q then
					if not modeSwitchDB then
						modeSwitchDB = true
						if currentMode == "Sword" then
							changeMode("Blaster",atkUI.BlsFrm)
						elseif currentMode == "Blaster" then
							changeMode("Telekinesis",atkUI.TkFrm)
						elseif currentMode == "Telekinesis" then
							changeMode("Sword",atkUI.SwordFrm)
						end
						task.wait(0.25)
						modeSwitchDB = false
					end
				end
				if input.KeyCode == Enum.KeyCode.E then
					for i,v in pairs(univMovesTbl) do
						if v == 1 then
							local s,v = script.Parent.UseMove:InvokeServer(i,mouse.Hit)
							if s then
								createAnimCDUI(atkUI.UniversalMovesFrm.UniMove1,v)
							end
						end
					end
				end
				if input.KeyCode == Enum.KeyCode.R then
					for i,v in pairs(univMovesTbl) do
						if v == 2 then
							local s,v = script.Parent.UseMove:InvokeServer(i)
							if s then
								createAnimCDUI(atkUI.UniversalMovesFrm.UniMove2,v)
							end
						end
					end
				end
				if input.KeyCode == Enum.KeyCode.One then
					for i,v in pairs(refTbl[currentMode]) do
						if v == 1 then
							if currentMode == "Blaster" then
								local s,v = script.Parent.UseMove:InvokeServer(i,mouse.Hit)
								if s then
									createAnimCDUI(slots.Move1,v)
								end
							elseif currentMode == "Sword" then
								local b,rm:RemoteEvent = script.Parent.RequestRemote:InvokeServer("SwordThrow")
								if not b then
									return false
								end
								task.spawn(function()
									rm.OnClientEvent:Wait()
									for i = 1,15,1 do
										rm:FireServer(mouse.Hit)
										task.wait(0.1)
									end
									script.Parent.RemoveRemote:InvokeServer(rm)
								end)
								local s,v = script.Parent.UseMove:InvokeServer(i,rm)
								if s then
									createAnimCDUI(slots.Move1,v)
								end
							elseif currentMode == "Telekinesis" then
								if (mouse.Hit.Position-mouse.Origin.Position).Magnitude > 100 then
									return false
								end
								local b,rm:RemoteEvent = script.Parent.RequestRemote:InvokeServer("TKSusp")
								if not b then
									return false
								end
								local conn = UIS.InputEnded:Once(function(input,isProcessed)
									local val = rm.OnClientEvent:Wait()
									if val == true then
									else
										return false
									end
									if input.KeyCode == Enum.KeyCode.One then
										rm:FireServer(mouse.Hit)
									end
									script.Parent.RemoveRemote:InvokeServer(rm)
								end)
								local s,v = script.Parent.UseMove:InvokeServer(i,mouse.Target,rm)
								if s then
									createAnimCDUI(slots.Move1,v)
								end
							end
						end
					end
				elseif input.KeyCode == Enum.KeyCode.Two then
					for i,v in pairs(refTbl[currentMode]) do
						if v == 2 then
							if currentMode == "Blaster" then
								local s,v = script.Parent.UseMove:InvokeServer(i,mouse.Hit)
								if s then
									createAnimCDUI(slots.Move2,v)
								end
							elseif currentMode == "Sword" then
								if (mouse.Hit.Position-mouse.Origin.Position).Magnitude > 500 then
									return false
								end
								local s,v = script.Parent.UseMove:InvokeServer(i,mouse.Origin,mouse.UnitRay)
								if s then
									createAnimCDUI(slots.Move2,v)
								end
							elseif currentMode == "Telekinesis" then
								if (mouse.Hit.Position-mouse.Origin.Position).Magnitude > 100 then
									return false
								end
								local s,v = script.Parent.UseMove:InvokeServer(i,mouse.Target)
								if s then
									createAnimCDUI(slots.Move2,v)
								end
							end
						end
					end
				elseif input.KeyCode == Enum.KeyCode.Three then
					for i,v in pairs(refTbl[currentMode]) do
						if v == 3 then
							if currentMode == "Blaster" then
								local b,rm:RemoteEvent = script.Parent.RequestRemote:InvokeServer("RevolvBls")
								if not b then
									return false
								end
								task.spawn(function()
									rm.OnClientEvent:Wait()
									for i = 1,3,1 do
										rm:FireServer(mouse.Hit)
										task.wait(1)
									end
									script.Parent.RemoveRemote:InvokeServer(rm)
								end)
								local s,v = script.Parent.UseMove:InvokeServer(i,rm)
								if s then
									createAnimCDUI(slots.Move3,v)
								end
							elseif currentMode == "Sword" then
								if (mouse.Hit.Position-mouse.Origin.Position).Magnitude > 500 then
									return false
								end
								local s,v = script.Parent.UseMove:InvokeServer(i,mouse.Origin,mouse.UnitRay)
								if s then
									createAnimCDUI(slots.Move3,v)
								end
							elseif currentMode == "Telekinesis" then
								local s,v = script.Parent.UseMove:InvokeServer(i,mouse.Target)
								if s then
									createAnimCDUI(slots.Move3,v)
								end
							end
						end
					end
				elseif input.KeyCode == Enum.KeyCode.Four then
					for i,v in pairs(refTbl[currentMode]) do
						if v == 4 then
							if currentMode == "Blaster" then
								local s,v = script.Parent.UseMove:InvokeServer(i,mouse.Origin,mouse.Target,mouse.UnitRay)
								if s then
									createAnimCDUI(slots.Move4,v)
								end
							elseif currentMode == "Sword" then
								local b,rm:RemoteEvent = script.Parent.RequestRemote:InvokeServer("KtSliders")
								if not b then
									return false
								end
								task.spawn(function()
									rm.OnClientEvent:Wait()
									for i = 1,5,1 do
										rm:FireServer(mouse.Hit)
										task.wait(0.3)
									end
									script.Parent.RemoveRemote:InvokeServer(rm)
								end)
								local s,v = script.Parent.UseMove:InvokeServer(i,rm)
								if s then
									createAnimCDUI(slots.Move4,v)
								end
							end
						end
					end
				elseif input.KeyCode == Enum.KeyCode.Five then
					for i,v in pairs(refTbl[currentMode]) do
						if v == 5 then
							if currentMode == "Blaster" then
								local s,v = script.Parent.UseMove:InvokeServer(i)
								if s then
									createAnimCDUI(slots.Move5,v)
								end
							elseif currentMode == "Sword" then
								local b,rm:RemoteEvent = script.Parent.RequestRemote:InvokeServer("BlKtSliders")
								if not b then
									return false
								end
								task.spawn(function()
									rm.OnClientEvent:Wait()
									for i = 1,5,1 do
										rm:FireServer(mouse.Hit)
										task.wait(0.3)
									end
									script.Parent.RemoveRemote:InvokeServer(rm)
								end)
								local s,v = script.Parent.UseMove:InvokeServer(i,rm)
								if s then
									createAnimCDUI(slots.Move5,v)
								end
							end
						end
					end
				elseif input.KeyCode == Enum.KeyCode.F then
					for i,v in pairs(refTbl[currentMode]) do
						if v == 6 then
							if currentMode == "Blaster" then
								local s,v = script.Parent.UseMove:InvokeServer(i)
								if s then
									createAnimCDUI(slots.Move6,v)
								end
							elseif currentMode == "Sword" then
								if (mouse.Hit.Position-mouse.Origin.Position).Magnitude > 500 then
									return false
								end
								local s,v = script.Parent.UseMove:InvokeServer(i,mouse.Origin,mouse.Target,mouse.UnitRay)
								if s then
									createAnimCDUI(slots.Move6,v)
								end
							end
						end
					end
				elseif input.KeyCode == Enum.KeyCode.C then
					for i,v in pairs(refTbl[currentMode]) do
						if v == 7 then
							if currentMode == "Blaster" then
								local s,v = script.Parent.UseMove:InvokeServer(i,mouse.Origin,mouse.Target,mouse.UnitRay)
								if s then
									createAnimCDUI(slots.Move7,v)
								end
							end
						end
					end
				elseif input.KeyCode == Enum.KeyCode.V then
					for i,v in pairs(refTbl[currentMode]) do
						if v == 8 then
							if currentMode == "Blaster" then
								local s,v = script.Parent.UseMove:InvokeServer(i)
								if s then
									createAnimCDUI(slots.Move8,v)
								end
							end
						end
					end
				end
			end
		end)
		plr.Character.Humanoid.Died:Once(function()
			script.Parent.UnloadFromChar:FireServer()
		end)
	end
end)
creditsButton.MouseButton1Click:Connect(function()
	if UIMain:FindFirstChild("CreditsMenu") == nil then
		script.Parent.OpenMenu:FireServer("CreditsMenu")
		UIMain:WaitForChild("CreditsMenu",5)
		UIMain.CreditsMenu.Visible = true
		local conn:RBXScriptConnection
		conn = UIMain.CreditsMenu.TitleFrm.CloseButton.MouseButton1Click:Connect(function()
			UIMain.CreditsMenu.Visible = false
		end)
		UIMain.CreditsMenu:GetPropertyChangedSignal("Visible"):Connect(function()
			if UIMain.CreditsMenu.Visible == false then
				conn:Disconnect()
			elseif UIMain.CreditsMenu.Visible == true then
				conn = UIMain.CreditsMenu.TitleFrm.CloseButton.MouseButton1Click:Connect(function()
					UIMain.CreditsMenu.Visible = false
				end)
			end
		end)
	else
		UIMain.CreditsMenu.Visible = true
	end
end)
infoButton.MouseButton1Click:Connect(function()
	if UIMain:FindFirstChild("InfoMenu") == nil then
		script.Parent.OpenMenu:FireServer("InfoMenu")
		UIMain:WaitForChild("InfoMenu",5)
		UIMain.InfoMenu.Visible = true
		local conn:RBXScriptConnection
		conn = UIMain.InfoMenu.TitleFrm.CloseButton.MouseButton1Click:Connect(function()
			UIMain.InfoMenu.Visible = false
		end)
		UIMain.InfoMenu:GetPropertyChangedSignal("Visible"):Connect(function()
			if UIMain.InfoMenu.Visible == false then
				conn:Disconnect()
			elseif UIMain.InfoMenu.Visible == true then
				conn = UIMain.InfoMenu.TitleFrm.CloseButton.MouseButton1Click:Connect(function()
					UIMain.InfoMenu.Visible = false
				end)
			end
		end)
	else
		UIMain.InfoMenu.Visible = true
	end
end)
settingsButton.MouseButton1Click:Connect(function()
	if UIMain:FindFirstChild("SettingsMenu") == nil then
		script.Parent.OpenMenu:FireServer("SettingsMenu")
		UIMain:WaitForChild("SettingsMenu",5)
		UIMain.SettingsMenu.Visible = true
		local conn:RBXScriptConnection
		conn = UIMain.SettingsMenu.TitleFrm.CloseButton.MouseButton1Click:Connect(function()
			UIMain.SettingsMenu.Visible = false
		end)
		local conn2 = UIMain.SettingsMenu.SettingsFrm.DestroyAndUnload.Button.MouseButton1Click:Once(function()
			script.Parent.UnloadFromChar:FireServer()
		end)
		local conn3 = UIMain.SettingsMenu.SettingsFrm.Setting.Button.MouseButton1Click:Connect(function()
			if UIMain.SettingsMenu.SettingsFrm.Setting:GetAttribute("EnableScriptReload") == true then
				UIMain.SettingsMenu.SettingsFrm.Setting:SetAttribute("EnableScriptReload",false)
				userSettings.scriptReload = false
				UIMain.SettingsMenu.SettingsFrm.Setting.Button.Text = "Enable"
				script.Parent.EnableLoadingForPlayer:InvokeServer(false)
			else
				UIMain.SettingsMenu.SettingsFrm.Setting:SetAttribute("EnableScriptReload",true)
				userSettings.scriptReload = true
				UIMain.SettingsMenu.SettingsFrm.Setting.Button.Text = "Disable"
				script.Parent.EnableLoadingForPlayer:InvokeServer(true,true)
			end
		end)
		UIMain.SettingsMenu:GetPropertyChangedSignal("Visible"):Connect(function()
			if UIMain.SettingsMenu.Visible == false then
				conn:Disconnect()
				conn2:Disconnect()
				conn3:Disconnect()
			elseif UIMain.SettingsMenu.Visible == true then
				conn = UIMain.SettingsMenu.TitleFrm.CloseButton.MouseButton1Click:Connect(function()
					UIMain.SettingsMenu.Visible = false
				end)
				conn2 = UIMain.SettingsMenu.SettingsFrm.DestroyAndUnload.Button.MouseButton1Click:Once(function()
					script.Parent.UnloadFromChar:FireServer()
				end)
				conn3 = UIMain.SettingsMenu.SettingsFrm.Setting.Button.MouseButton1Click:Connect(function()
					if UIMain.SettingsMenu.SettingsFrm.Setting:GetAttribute("EnableScriptReload") == true then
						UIMain.SettingsMenu.SettingsFrm.Setting:SetAttribute("EnableScriptReload",false)
						userSettings.scriptReload = false
						UIMain.SettingsMenu.SettingsFrm.Setting.Button.Text = "Enable"
						script.Parent.EnableLoadingForPlayer:InvokeServer(false)
					else
						UIMain.SettingsMenu.SettingsFrm.Setting:SetAttribute("EnableScriptReload",true)
						userSettings.scriptReload = true
						UIMain.SettingsMenu.SettingsFrm.Setting.Button.Text = "Disable"
						script.Parent.EnableLoadingForPlayer:InvokeServer(true,true)
					end
				end)
			end
		end)
	else
		UIMain.SettingsMenu.Visible = true
	end
end)
