--Why did I barely make any comments in here... it's going to be painul for others to read this without the help of comments. :(
local Novus = {}
local NovusMeta = {}
Novus.Global = {}
local startInitTime = os.clock()

local TweenService = game:GetService("TweenService")

Novus.Global.ManualWhitelist = {
	--[[UserId (Num) = PermissionLevel (string, available permission levels are "Default" and "LoadChars")]]
}
Novus.Global.HomeReference = nil::ModuleScript
Novus.Global.moveCDTbl = {}
Novus.Global.ModelFolderReference = nil::Folder
Novus.Global.AudioFolderReference = nil::Folder
Novus.Global.UIFolderReference = nil::Folder
Novus.Global.UserPlayer = nil::Player
Novus.Global.DecayTable = {}
Novus.Variables = {}
Novus.Global.Blasters = {}
Novus.Global.Swords = {}
Novus.Global.Force = {}
Novus.Global.Universal = {}
Novus.Variables.BlasterRange = 1000 --Sort of a redundant variable... :/
Novus.Variables.tickDamage = 1
Novus.Variables.decayDamage = 1
Novus.Variables.mediumTickDamage = 1
Novus.Variables.mediumDecayDamage = 2
Novus.Variables.largeTickDamage = 2
Novus.Variables.largeDecayDamage = 3
Novus.Variables.SwordRange = 500
Novus.Variables.zoneDamage = 1
Novus.Variables.zoneDecayDamage = 1
Novus.Variables.throwDamage = 2
Novus.Variables.throwDecayDamage = 3
Novus.Variables.wallDamage = 3
Novus.Variables.wallDecayDamage = 5
Novus.Variables.forcePushRange = 150
Novus.Variables.forceEffectRange = 100
Novus.Variables.groupForceEffectRange = 400
Novus.Variables.forceSlamDamage = 50
Novus.Variables.forceSlamDecayDamage = 100
Novus.Variables.forceHeavySlamDamage = 100
Novus.Variables.forceHeavySlamDecayDamage = 250
Novus.Variables.blinkRange = 200
Novus.Variables.BlasterAmountCap = 20 --I forgot this existed, because I procrastinated on making an actual fix to the performance problem of rapid-fire blasters or large amounts of blasters being spawned at once. Will look into fixing that, though.
Novus.Global.BlasterTbl = {}
Novus.Variables.forceHoldAnim = Instance.new("Animation")
Novus.Variables.forceHoldAnim.AnimationId = "rbxassetid://12293793703"
Novus.Variables.forcePushAnim = Instance.new("Animation")
Novus.Variables.forcePushAnim.AnimationId = "rbxassetid://12293841223"
Novus.Variables.forceSlamAnim = Instance.new("Animation")
Novus.Variables.forceSlamAnim.AnimationId = "rbxassetid://12310777246"
Novus.Variables.fatalAnim = Instance.new("Animation")
Novus.Variables.fatalAnim.AnimationId = "rbxassetid://12371509159" --This is an animation... that I didn't necessarily test. I also didn't even test the death stuff (too lazy to add a temporary method for doing so), so uhhh...
Novus.Global.Blasters.TweeningInfo = {
	BlasterSummon = TweenInfo.new(
		1,
		Enum.EasingStyle.Exponential,
		Enum.EasingDirection.Out,
		0,
		false,
		0
	),
	HomingBlasterSummon = TweenInfo.new(
		0.5,
		Enum.EasingStyle.Exponential,
		Enum.EasingDirection.Out,
		0,
		false,
		0
	),
	MediumHomingBlasterSummon = TweenInfo.new(
		0.75,
		Enum.EasingStyle.Exponential,
		Enum.EasingDirection.Out,
		0,
		false,
		0
	),
	BlasterSummonVisible = TweenInfo.new(
		0.5,
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.Out,
		0,
		false,
		0
	),
	HomingBlasterSummonVisible = TweenInfo.new(
		0.3,
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.Out,
		0,
		false,
		0
	),
	LargeBlasterSummon = TweenInfo.new(
		1.1,
		Enum.EasingStyle.Exponential,
		Enum.EasingDirection.Out,
		0,
		false,
		0
	),
	BlasterFire = TweenInfo.new(
		0.25,
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.In,
		0,
		false,
		0
	),
	BlasterRecoil = TweenInfo.new(
		1.25,
		Enum.EasingStyle.Sine,
		Enum.EasingDirection.Out,
		0,
		false,
		0
	),
	BlasterOscillate = TweenInfo.new(
		0.1,
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.In,
		4,
		true,
		0
	),
	LargeBlasterOscillate = TweenInfo.new(
		0.2,
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.In,
		5,
		true,
		0
	),
	LargeBlasterRecoil = TweenInfo.new(
		1.65,
		Enum.EasingStyle.Exponential,
		Enum.EasingDirection.Out,
		0,
		false,
		0
	),
	BlasterFireDecay = TweenInfo.new(
		1,
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.In,
		0,
		false,
		0
	),
	BlasterVisible = TweenInfo.new(
		0.1,
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.In,
		0,
		false,
		0
	),
	BeamDimensions = {
		Size = Vector3.new(1000,15,15)
	},
	MediumBeamDimensions = {
		Size = Vector3.new(1000,35,35)
	},
	OscBeamDimensions = {
		Size = Vector3.new(1000,10,10)
	},
	OscMediumBeamDimensions = {
		Size = Vector3.new(1000,30,30)
	},
	BaseDimensions = {
		Size = Vector3.new(0.2,17,17)
	},
	MediumBaseDimensions = {
		Size = Vector3.new(0.4,40,40)
	},
	BaseRingDimensions = {
		Size = Vector3.new(100,0.5,100)
	},
	MediumBaseRingDimensions = {
		Size = Vector3.new(160,0.75,160)
	},
	LargeBeamDimensions = {
		Size = Vector3.new(1000,70,70)
	},
	OscLargeBeamDimensions = {
		Size = Vector3.new(1000,60,60)
	},
	LargeBaseDimensions = {
		Size = Vector3.new(0.8,85,85)
	},
	LargeRingDimensions = {
		Size = Vector3.new(260,1.25,260)
	},
	Visible = {
		Transparency = 0
	},
	Decay = {
		Transparency = 1
	},
	DecayBeamDimensions = {
		Size = Vector3.new(1000,1,1)
	},
	MediumDecayBeamDimensions = {
		Size = Vector3.new(1000,2,2)
	},
	DecayBaseDimensions = {
		Size = Vector3.new(0.2,2,2)
	},
	MediumDecayBaseDimensions = {
		Size = Vector3.new(0.4,4,4)
	},
	LargeDecayBeamDimensions = {
		Size = Vector3.new(1000,7,7)
	},
	LargeDecayBaseDimensions = {
		Size = Vector3.new(0.4,12,12)
	}
}
Novus.Global.Swords.TweeningInfo = {
	ZoneRaise = TweenInfo.new(
		0.25,
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.Out,
		0,
		false,
		0
	),
	SwordVisible = TweenInfo.new(
		0.5,
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.In,
		0,
		false,
		0
	),
	SwordSummon = TweenInfo.new(
		0.75,
		Enum.EasingStyle.Back,
		Enum.EasingDirection.Out,
		0,
		false,
		0
	),
	SwordFlight = TweenInfo.new(
		2,
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.In,
		0,
		false,
		0
	), --Too lazy to try to manually CFrame these projectiles so they'll just fly the defined range at a constant speed using a Tween. Sorry, lol. -shooter7620
	WallSlide = TweenInfo.new(
		3,
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.In,
		0,
		false,
		0
	)
}
Novus.Global.Force.TweeningInfo = {
	ForcePushAway = TweenInfo.new(
		0.5,
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.In,
		0,
		false,
		0
	),
	ForcePushDirect = TweenInfo.new(
		0.5,
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.In,
		0,
		false,
		0
	),
	ForcePushOrPull = TweenInfo.new(
		0.5,
		Enum.EasingStyle.Sine,
		Enum.EasingDirection.Out,
		0,
		false,
		0
	),
	SoulChangeIndicate = TweenInfo.new(
		0.5,
		Enum.EasingStyle.Sine,
		Enum.EasingDirection.Out,
		0,
		false,
		0
	),
	SoulDirectionIndicate = TweenInfo.new(
		0.25,
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.In,
		0,
		false,
		0
	),
	SoulOscillate = TweenInfo.new(
		0.5,
		Enum.EasingStyle.Sine,
		Enum.EasingDirection.InOut,
		2,
		true,
		0
	),
	FEIndicate = TweenInfo.new(
		0.5,
		Enum.EasingStyle.Sine,
		Enum.EasingDirection.Out,
		0,
		false,
		0
	)
}
Novus.Moves = {
	--[[Example = {"ExampleName",5,"Example Mode",1,function (plr:Player,tgt:BasePart)
		local charCF = plr.Character.HumanoidRootPart.CFrame
		--Do whatever here, I guess.
	end,false,{"ExampleGCDMoveReference1","ExampleGCDMoveReference2"}},{dmg = 0,decayDmg = 0,desc = "A template move for example purposes."}]] --Each move has seven available parameters (at the moment), move name (string), cooldown (in seconds), mode selector (which mode the move is attached to; if the moveset has a single mode it should be set to "Default", and "Universal" if it can be used across all modes), slot ID (the corresponding slot the move is assigned to for the mode), function (for carrying out the move), GCD (global cooldown), meaning that other moves will not be able to be used if they also have global cooldown; and finally, GCD move references, i.e. The moves which cannot be used while this move is on cooldown (leaving this nil won't throw an error).
	Blink = {"Blink",7,"Universal",1,function (plr:Player,targetCF:CFrame,plrMouseTarget:BasePart)
		if plr ~= Novus.Global.UserPlayer then
			plr:Kick("Illegal remote access detected (fired a remote which is not permitted to be used by other players).")
			return false
		end
		Novus.Global.Universal.Blink(plr,targetCF,plrMouseTarget)
	end,false,{},{dmg = "N/A",decayDmg = "N/A",desc = "Teleports yourself in the direction of the cursor."}},
	Booster_Kit = {"Booster Kit",90,"Universal",2,function (plr:Player)
		if plr ~= Novus.Global.UserPlayer then
			plr:Kick("Illegal remote access detected (fired a remote which is not permitted to be used by other players).")
			return false
		end
		Novus.Global.Universal.BoostStamina(plr)
	end,false,{},{dmg = "N/A",decayDmg = "N/A",desc = "Restores 50 units of stamina."}},
	Katana_Barrage = {"Katana Barrage",3,"Sword",1,function (plr:Player,CFRemote:RemoteEvent)
		if plr ~= Novus.Global.UserPlayer then
			plr:Kick("Illegal remote access detected (fired a remote which is not permitted to be used by other players).")
			return false
		end
		assert(plr:IsA("Player") and CFRemote:IsA("RemoteEvent"),"Argument #1 or #2 is of an invalid class/datatype (types: arg1 = "..typeof(plr)..", arg2 = "..CFRemote.ClassName or typeof(CFRemote)..").")
		local rdTbl = {
			"Normal",
			"Blue"
		}
		local ft = 0
		local conn:RBXScriptConnection = CFRemote.OnServerEvent:Connect(function(plr2,CF)
			task.spawn(Novus.Global.Swords.throwSwordGlobal,plr2,CF,rdTbl[Random.new():NextInteger(1,2)])
			ft += 1
		end)
		CFRemote:FireClient(plr,true)
		task.spawn(function ()
			while ft < 15 do
				task.wait()
			end
			conn:Disconnect()
			Novus.Global.moveCDTbl["Katana_Barrage"][5] = false
		end)
	end,false,{},{dmg = Novus.Variables.throwDamage.."/tick",decayDmg = Novus.Variables.throwDecayDamage.."/tick",desc = "Throws a mixed barrage of normal and blue (only does damage if hit target is moving) katanas."}},
	Katana_Zone = {"Katana Zone",3,"Sword",2,function (plr:Player,plrCameraOrigin:CFrame,plrMouseRay:Ray)
		if plr ~= Novus.Global.UserPlayer then
			plr:Kick("Illegal remote access detected (fired a remote which is not permitted to be used by other players).")
			return false
		end
		Novus.Global.Swords.summonKatanaZoneGlobal(plrCameraOrigin,plrMouseRay,"Normal")
		Novus.Global.moveCDTbl["Katana_Zone"][5] = false
	end,false,{"Large_Katana_Zones"},{dmg = Novus.Variables.zoneDamage.."/tick",decayDmg = Novus.Variables.zoneDecayDamage.."/tick",desc = "Raises a zone of Katanas from the ground at the cursor that does high damage to targets that stay within the zone over time."}},
	Blue_Katana_Zone = {"Blue Katana Zone",5,"Sword",3,function (plr:Player,plrCameraOrigin:CFrame,plrMouseRay:Ray)
		if plr ~= Novus.Global.UserPlayer then
			plr:Kick("Illegal remote access detected (fired a remote which is not permitted to be used by other players).")
			return false
		end
		Novus.Global.Swords.summonKatanaZoneGlobal(plrCameraOrigin,plrMouseRay,"Blue")
		Novus.Global.moveCDTbl["Blue_Katana_Zone"][5] = false
	end,false,{"Telekinetic_Supension","Large_Katana_Zones"},{dmg = "N/A",decayDmg = "N/A",desc = "Raises a zone of blue katanas from the ground at the pount of the cursor that does no damage, but forcefully prevents targets from moving for a few moments."}},
	Katana_Sliders = {"Katana Sliders",4,"Sword",4,function (plr:Player,CFRemote:RemoteEvent)
		local ft = 0
		local conn = CFRemote.OnServerEvent:Connect(function (plr,targetCF)
			assert(plr:IsA("Player") and typeof(targetCF) == "CFrame","Argument #1 or #2 is of an invalid class/datatype.")
			if plr ~= Novus.Global.UserPlayer then
				plr:Kick("Illegal remote access detected (fired a remote which is not permitted to be used by other players).")
				return false
			end
			local heightSelection = Random.new()
			local charCF = plr.Character.HumanoidRootPart.CFrame
			local summonCF = CFrame.lookAt(charCF.Position,targetCF.Position)
			local z,y,x = summonCF:ToEulerAnglesXYZ()
			if math.abs(math.deg(z)) >= 90 and math.abs(math.deg(x)) >= 90 then
				summonCF = CFrame.new(summonCF.Position) * CFrame.Angles(math.sign(x)*math.rad(180),y,math.sign(z)*math.rad(180))
			elseif math.abs(math.deg(z)) < 90 and math.abs(math.deg(x)) < 90 then
				summonCF = CFrame.new(summonCF.Position) * CFrame.Angles(0,y,0)
			end
			summonCF += summonCF.LookVector * 20
			local targetCF = summonCF + summonCF.LookVector * -Novus.Variables.SwordRange
			local beginCF
			local selection = heightSelection:NextInteger(1,3)
			if selection == 1 then
				summonCF += summonCF.UpVector * -0.5
				beginCF = summonCF + summonCF.UpVector * -4
			elseif selection == 2 then
				summonCF += summonCF.UpVector * 1.7
				beginCF = summonCF + summonCF.UpVector * -8
			elseif selection == 3 then
				summonCF += summonCF.UpVector * 4.5
				beginCF = summonCF + summonCF.UpVector * -12
			end
			task.spawn(Novus.Global.Swords.summonSliderInternal,beginCF,summonCF,targetCF,selection,"Normal")
			ft += 1
		end)
		CFRemote:FireClient(plr,true)
		task.spawn(function ()
			while ft < 5 do
				task.wait()
			end
			conn:Disconnect()
			Novus.Global.moveCDTbl["Katana_Sliders"][5] = false
		end)
	end,false,{"Blue_Katana_Sliders"},{dmg = Novus.Variables.wallDamage.."/tick",decayDmg = Novus.Variables.wallDecayDamage.."/tick",desc = "Summons a series of katana sliders that move across the ground in the direction of the cursor."}},
	Blue_Katana_Sliders = {"Blue Katana Sliders",5,"Sword",5,function (plr:Player,CFRemote:RemoteEvent)
		local ft = 0
		local conn = CFRemote.OnServerEvent:Connect(function(plr,targetCF)
			if plr ~= Novus.Global.UserPlayer then
				plr:Kick("Illegal remote access detected (fired a remote which is not permitted to be used by other players).")
				return false
			end
			assert(plr:IsA("Player") and typeof(targetCF) == "CFrame","Argument #1 or #2 is of an invalid class/datatype.")
			local heightSelection = Random.new()
			local charCF = plr.Character.HumanoidRootPart.CFrame
			local summonCF = CFrame.lookAt(charCF.Position,targetCF.Position)
			local z,y,x = summonCF:ToEulerAnglesXYZ()
			if math.abs(math.deg(z)) >= 90 and math.abs(math.deg(x)) >= 90 then
				summonCF = CFrame.new(summonCF.Position) * CFrame.Angles(math.sign(x)*math.rad(180),y,math.sign(z)*math.rad(180))
			elseif math.abs(math.deg(z)) < 90 and math.abs(math.deg(x)) < 90 then
				summonCF = CFrame.new(summonCF.Position) * CFrame.Angles(0,y,0)
			end
			summonCF += summonCF.LookVector * 15
			local targetCF = summonCF + summonCF.RightVector * -Novus.Variables.SwordRange
			local beginCF
			local selection = heightSelection:NextInteger(1,2)
			if selection == 1 then
				summonCF += summonCF.UpVector * -0.3
				beginCF = summonCF + summonCF.UpVector * -8
			elseif selection == 2 then
				summonCF += summonCF.UpVector * 1
				beginCF = summonCF + summonCF.UpVector * -12
			end
			task.spawn(Novus.Global.Swords.summonSliderInternal,beginCF,summonCF,targetCF,selection,"Blue")
			ft += 1
		end)
		CFRemote:FireClient(plr,true)
		task.spawn(function ()
			while ft < 5 do
				task.wait()
			end
			conn:Disconnect()
			Novus.Global.moveCDTbl["Blue_Katana_Sliders"][5] = false
		end)
	end,false,{"Katana_Sliders"},{dmg = Novus.Variables.wallDamage.."/tick",decayDmg = Novus.Variables.wallDecayDamage.."/tick",desc = "Summons a series of blue katana sliders that move across the ground in the direction of the cursor, which only do damage if a target is moving."}},
	Large_Katana_Zones = {"Large Normal/Blue Katana Zone",8,"Sword",6,function (plr:Player,plrCameraOrigin:CFrame,plrMouseRay:Ray)
		if plr ~= Novus.Global.UserPlayer then
			plr:Kick("Illegal remote access detected (fired a remote which is not permitted to be used by other players).")
			return false
		end
		local zoneTbl = {
			"NormalLarge",
			"BlueLarge"
		}
		local selection = zoneTbl[Random.new():NextInteger(1,2)]
		Novus.Global.Swords.summonKatanaZoneGlobal(plrCameraOrigin,plrMouseRay,selection)
		Novus.Global.moveCDTbl["Large_Katana_Zones"][5] = false
	end,true,{"Telekinetic_Suspension","Katana_Zone","Blue_Katana_Zone"},{dmg = Novus.Variables.zoneDamage.."/tick",decayDmg = Novus.Variables.zoneDecayDamage.."/tick",desc = "Summons a large variant of the Normal or Blue Katana Zone. Triggers global cooldown with any other moves which have that parameter enabled."}},
	Rail_Blaster = {"Rail Blaster",5,"Blaster",1,function (plr:Player,targetCF:CFrame)
		if plr ~= Novus.Global.UserPlayer then
			plr:Kick("Illegal remote access detected (fired a remote which is not permitted to be used by other players).")
			return false
		end
		assert(plr:IsA("Player") and typeof(targetCF) == "CFrame","Argument #1 or #2 is of an invalid class/datatype.")
		local charCF = plr.Character.HumanoidRootPart.CFrame
		local LR = math.random(-1,1)
		if LR <= 0 then
			LR = -1
		else
			math.ceil(LR)
		end
		local vectorToCF = CFrame.lookAt(charCF.Position,targetCF.Position)
		vectorToCF = vectorToCF + (vectorToCF.LookVector * (math.random(1.05,1.35) * 5.25)) + (vectorToCF.RightVector * (LR * math.random(17,27))) + (vectorToCF.UpVector * (math.random(1,4) * 7))
		local beginCF = vectorToCF + vectorToCF.LookVector * -56.25
		Novus.Global.Blasters.UseBlasterInternal(beginCF,vectorToCF,targetCF,"Medium")
		Novus.Global.moveCDTbl["Rail_Blaster"][5] = false
	end,false,{"Large_Rail_Blaster","Revolving_Rail_Blasters","Homing_Blasters","Blaster_Barrage","Blaster_Circle","Rail_Blaster_Defense"},{dmg = Novus.Variables.mediumTickDamage.."/tick (per blaster)",decayDmg = Novus.Variables.mediumDecayDamage.."/tick (per blaster)",desc = "Summons a Rail Blaster on either side of you aimed in the direction of the cursor, which fires after a short delay."}},
	Large_Rail_Blaster = {"Large Rail Blaster",10,"Blaster",2,function (plr:Player,targetCF:CFrame)
		if plr ~= Novus.Global.UserPlayer then
			plr:Kick("Illegal remote access detected (fired a remote which is not permitted to be used by other players).")
			return false
		end
		assert(plr:IsA("Player") and typeof(targetCF) == "CFrame","Argument #1 or #2 is of an invalid class/datatype.")
		local charCF = plr.Character.HumanoidRootPart.CFrame
		local LR = math.random(-1,1)
		if LR <= 0 then
			LR = -1
		else
			math.ceil(LR)
		end
		local vectorToCF = CFrame.lookAt(charCF.Position,targetCF.Position)
		vectorToCF = vectorToCF + (vectorToCF.LookVector * (math.random(1.1,1.4) * 7.5)) + (vectorToCF.RightVector * (LR * math.random(20,30))) + (vectorToCF.UpVector * (math.random(2,3) * 12))
		local beginCF = vectorToCF + vectorToCF.LookVector * -62.5
		Novus.Global.Blasters.UseBlasterInternal(beginCF,vectorToCF,targetCF,"Large")
		Novus.Global.moveCDTbl["Large_Rail_Blaster"][5] = false
	end,false,{"Rail_Blaster","Revolving_Blasters","Homing_Blasters","Blaster_Barrage","Blaster_Circle","Rail_Blaster_Defense"},{dmg = Novus.Variables.largeTickDamage.."/tick (per blaster)",decayDmg = Novus.Variables.largeDecayDamage.."/tick (per blaster)",desc = "Summons a large Rail Blaster on either side of you aimed in the direction of the cursor, which fires after a slightly longer delay; but does significantly more damage and has a much larger beam."}},
	Revolving_Rail_Blasters = {"Revolving Rail Blasters",12,"Blaster",3,function (plr:Player,CFRemote:RemoteEvent)
		local ft = 0
		local conn = CFRemote.OnServerEvent:Connect(function(plr:CFrame,targetCF:CFrame)
			if plr ~= Novus.Global.UserPlayer then
				plr:Kick("Illegal remote access detected (fired a remote which is not permitted to be used by other players).")
				return false
			end
			assert(plr:IsA("Player") and typeof(targetCF) == "CFrame","Argument #1 or #2 is of an invalid class/datatype.")
			local charCF = plr.Character.HumanoidRootPart.CFrame
			local vectorToCF = CFrame.lookAt(charCF.Position,targetCF.Position)
			vectorToCF = vectorToCF + (vectorToCF.LookVector * (math.random(1.05,1.35) * 5.25)) + (vectorToCF.RightVector * (math.random(17,27))) + (vectorToCF.UpVector * (math.random(1,4) * 7))
			local beginCF = vectorToCF + vectorToCF.LookVector * -56.25
			local vectorToCF2 = CFrame.lookAt(charCF.Position,targetCF.Position)
			vectorToCF2 = vectorToCF2 + (vectorToCF2.LookVector * (math.random(1.05,1.35) * 5.25)) + (vectorToCF2.RightVector * (-1 * math.random(17,27))) + (vectorToCF2.UpVector * (math.random(1,4) * 7))
			local beginCF2 = vectorToCF2 + vectorToCF2.LookVector * -56.25
			task.spawn(Novus.Global.Blasters.UseBlasterInternal,beginCF,vectorToCF,targetCF,"Medium")
			task.spawn(Novus.Global.Blasters.UseBlasterInternal,beginCF2,vectorToCF2,targetCF,"Medium")
			ft += 1
		end)
		CFRemote:FireClient(plr,true)
		task.spawn(function ()
			while ft < 3 do
				task.wait()
			end
			conn:Disconnect()
			Novus.Global.moveCDTbl["Revolving_Rail_Blasters"][5] = false
		end)
	end,false,{"Rail_Blaster","Large_Rail_Blaster","Revolving_Rail_Blasters","Homing_Blasters","Blaster_Barrage","Blaster_Circle","Rail_Blaster_Defense"},{dmg = Novus.Variables.mediumTickDamage.."/tick (per blaster)",decayDmg = Novus.Variables.mediumDecayDamage.."/tick (per blaster)",desc = "Sequentially summons three pairs of two Rail Blasters that fire one after another with a short delay."}},
	Quad_Rail_Blasters = {"Quad Rail Blasters",8,"Blaster",4,function (plr:Player,plrCameraOrigin:CFrame,plrMouseTarget:BasePart,plrMouseRay:Ray)
		if plr ~= Novus.Global.UserPlayer then
			plr:Kick("Illegal remote access detected (fired a remote which is not permitted to be used by other players).")
			return false
		end
		if plrMouseTarget == nil then
			return
		end
		local TargetCF
		local rtParams = RaycastParams.new()
		rtParams.FilterType = Enum.RaycastFilterType.Blacklist
		local blTbl = {}
		for i,v in ipairs(game.Workspace:GetDescendants()) do
			if v.Parent:FindFirstChild("Humanoid") ~= nil then
				table.insert(blTbl,v)
			end
		end
		rtParams.FilterDescendantsInstances = blTbl
		local rtResult = workspace:Raycast(plrCameraOrigin.Position,plrMouseRay.Direction*Novus.Variables.BlasterRange,rtParams)
		if rtResult ~= nil then
			TargetCF = CFrame.new(rtResult.Position)
		else
			return
		end
		TargetCF += TargetCF.UpVector * 4
		local BLCF1 = TargetCF + TargetCF.RightVector * 30
		local BLCF2 = TargetCF + TargetCF.RightVector * -30
		local BLCF3 = TargetCF + TargetCF.LookVector * 30
		local BLCF4 = TargetCF + TargetCF.LookVector * -30
		local VFCF1 = BLCF1 + BLCF1.LookVector * 30
		local VFCF2 = BLCF2 + BLCF2.LookVector * -30
		local VFCF3 = BLCF3 + BLCF3.RightVector * 30
		local VFCF4 = BLCF4 + BLCF4.RightVector * -30
		task.spawn(Novus.Global.Blasters.UseBlasterInternal,VFCF1,BLCF1,TargetCF,"Medium")
		task.spawn(Novus.Global.Blasters.UseBlasterInternal,VFCF2,BLCF2,TargetCF,"Medium")
		task.spawn(Novus.Global.Blasters.UseBlasterInternal,VFCF3,BLCF3,TargetCF,"Medium")
		task.spawn(Novus.Global.Blasters.UseBlasterInternal,VFCF4,BLCF4,TargetCF,"Medium") --I was incredibly lazy with the implementation of this... :|
		task.wait(2.25)
		Novus.Global.moveCDTbl["Quad_Rail_Blasters"][5] = false
	end,false,{},{dmg = Novus.Variables.mediumTickDamage.."/tick (per blaster)",decayDmg = Novus.Variables.mediumDecayDamage.."/tick (per blaster)",desc = "Summons a cross formation of Rail Blasters above the point of surface contact at the cursor."}},
	Homing_Blasters = {"Homing Blasters",15,"Blaster",5,function (plr:Player)
		if plr ~= Novus.Global.UserPlayer then
			plr:Kick("Illegal remote access detected (fired a remote which is not permitted to be used by other players).")
			return false
		end
		local charCF = plr.Character.HumanoidRootPart.CFrame
		local radius = 500
		local OLP = OverlapParams.new()
		OLP.RespectCanCollide = false
		OLP.MaxParts = 0
		OLP.FilterType = Enum.RaycastFilterType.Whitelist
		local blTbl = {}
		for i,v in pairs(workspace:GetChildren()) do
			if v:FindFirstChild("Humanoid") ~= nil and v ~= Novus.Global.UserPlayer.Character and v:FindFirstChild("Humanoid").Health ~= 0 then
				table.insert(blTbl,v)
			end
		end
		OLP.FilterDescendantsInstances = blTbl
		local hmPartTbl = workspace:GetPartBoundsInRadius(charCF.Position,radius,OLP)
		local charModelTbl = {}
		for i,v in pairs(hmPartTbl) do
			if v.Parent:IsA("Model") then
				if v.Parent.Humanoid.Health ~= 0 then
					if #charModelTbl >= 5 then --This is a harsh cap, because the delay is so low between each blaster being spawned. :/
						break
					end
					if table.find(charModelTbl,v.Parent) == nil then
						table.insert(charModelTbl,v.Parent)
					end
				end
			end
		end
		for i,v in pairs(charModelTbl) do
			if v:FindFirstChild("Humanoid") ~= nil and v ~= plr.Character then
				task.spawn(Novus.Global.Blasters.UseHomingBlasters,v,1,"Small",0.25,3)
			end
		end
		task.wait(1.6)
		Novus.Global.moveCDTbl["Homing_Blasters"][5] = false
	end,false,{"Rail_Blaster","Revolving_Rail_Blasters","Large_Rail_Blaster","Blaster_Barrage","Blaster_Circle","Rail_Blaster_Defense"},{dmg = Novus.Variables.tickDamage.."/tick (per blaster)",decayDmg = Novus.Variables.decayDamage.."/tick (per blaster)",desc = "A bit of a misnomer. Actually just summons three small Rail Blasters in quick succession on all targets within a 500 stud radius of you."}},
	Blaster_Barrage = {"Blaster Barrage",25,"Blaster",6,function (plr:Player)
		if plr ~= Novus.Global.UserPlayer then
			plr:Kick("Illegal remote access detected (fired a remote which is not permitted to be used by other players).")
			return false
		end
		local charCF = plr.Character.HumanoidRootPart.CFrame
		local radius = 500
		local OLP = OverlapParams.new()
		OLP.RespectCanCollide = false
		OLP.MaxParts = 0
		OLP.FilterType = Enum.RaycastFilterType.Blacklist
		local blTbl = {}
		for i,v in pairs(workspace:GetChildren()) do
			if v:FindFirstChild("Humanoid") == nil or v == Novus.Global.UserPlayer.Character or v:FindFirstChild("Humanoid").Health == 0 then
				table.insert(blTbl,v)
			end
		end
		OLP.FilterDescendantsInstances = blTbl
		local hmPartTbl = workspace:GetPartBoundsInRadius(charCF.Position,radius,OLP)
		local charModelTbl = {}
		for i,v in pairs(hmPartTbl) do
			if v.Parent.Humanoid.Health ~= 0 then
				if #charModelTbl >= 10 then --Putting a target cap... until I fix the performance issues with "Homing"-type Blasters altogether... AKA, actually making them track targets so I don't need to spam them.
					break
				end
				if table.find(charModelTbl,v.Parent) == nil then
					table.insert(charModelTbl,v.Parent)
				end
			end
		end
		for i,v in pairs(charModelTbl) do
			if v:FindFirstChild("Humanoid") ~= nil and v ~= plr.Character then
				task.spawn(Novus.Global.Blasters.UseHomingBlasters,v,1,"Medium",0.225,10) --Oh boy, I hope this doesn't cause lag. Edit: It most definitely will with a lot of characters. RIP.
			end
		end
		task.wait(9)
		Novus.Global.moveCDTbl["Blaster_Barrage"][5] = false
	end,true,{"Rail_Blaster","Revolving_Rail_Blasters","Large_Rail_Blaster","Quad_Rail_Blasters","Homing_Blasters","Blaster_Circle","Rail_Blaster_Defense"},{dmg = Novus.Variables.mediumTickDamage.."/tick (per blaster)",decayDmg = Novus.Variables.mediumDecayDamage.."/tick (per blaster)",desc = "[Prone to lag issues] Summons a barrage of Rail Blasters on all targets within a 500 stud radius of you. If you're fighting a crowd and this doesn't destroy them, then you may have a problem on your hands."}},
	Blaster_Circle = {"Blaster Circle",50,"Blaster",7,function (plr:Player,plrCameraOrigin:CFrame,plrMouseTarget:BasePart,plrMouseRay:Ray) --This is unfortunately... also quite cumbersome on the server and clients. Perhaps try preserving the blasters once they are spawned?
		if plr ~= Novus.Global.UserPlayer then
			plr:Kick("Illegal remote access detected (fired a remote which is not permitted to be used by other players).")
			return false
		end
		task.spawn(Novus.Global.Force.BlueHold,Novus.Global.UserPlayer,2.7)
		Novus.Global.Blasters.UseBlasterCircle(Novus.Global.UserPlayer,6,plrCameraOrigin,plrMouseTarget,plrMouseRay)
		Novus.Global.moveCDTbl["Blaster_Circle"][5] = false
	end,true,{"Rail_Blaster","Large_Rail_Blaster","Homing_Blasters","Quad_Rail_Blasters","Blaster_Barrage"},{dmg = Novus.Variables.tickDamage.."/tick (per blaster)",decayDmg = Novus.Variables.decayDamage.."/tick (per blaster)",desc = "You hold down all targets in a 500 stud radius with telekinetic force, preventing them from jumping; then you summon a rotating sequential circle of small Rail Blasters for a little while, before releasing your telekinetic force on all targets affected."}},
	--[[Super_Blaster_Circle = {"Super Blaster Circle",90,"Blaster",8,function (plr:Player,plrCameraOrigin:CFrame,plrMouseTarget:BasePart,plrMouseRay:Ray)
		if plr ~= Novus.Global.UserPlayer then
			plr:Kick("Illegal remote access detected (fired a remote which is not permitted to be used by other players).")
			return false
		end
		task.spawn(Novus.Global.Force.BlueHold,Novus.Global.UserPlayer,50)
		task.spawn(function ()
			if plrMouseTarget == nil then
				return
			end
			local TargetCF
			local rtParams = RaycastParams.new()
			rtParams.FilterType = Enum.RaycastFilterType.Blacklist
			local blTbl = {}
			for i,v in ipairs(game.Workspace:GetDescendants()) do
				if v.Parent:FindFirstChild("Humanoid") ~= nil then
					table.insert(blTbl,v)
				end
			end
			rtParams.FilterDescendantsInstances = blTbl
			local rtResult = workspace:Raycast(plrCameraOrigin.Position,plrMouseRay.Direction*1000,rtParams)
			if rtResult ~= nil then
				TargetCF = CFrame.new(rtResult.Position)
			else
				return
			end
			TargetCF += TargetCF.UpVector * 4
			for i = 1,12,1 do
				for i = 1,48,1 do
					TargetCF *= CFrame.fromAxisAngle(TargetCF.UpVector,math.rad(7.5))
					local sCF = TargetCF + TargetCF.LookVector * -150
					local bCF = sCF + sCF.LookVector * -50
					task.spawn(Novus.Global.Blasters.UseBlasterInternal,bCF,sCF,TargetCF,"Small")
					task.wait(0.065)
				end
			end
		end)
		task.wait(1.5)
		for i,v in pairs(workspace:GetChildren()) do
			if v:FindFirstChild("Humanoid") ~= nil and v ~= Novus.Global.UserPlayer.Character then
				task.spawn(Novus.Global.Blasters.UseHomingBlasters,v,1,"Small",2,58)
			end
		end
		task.wait(58.5)
		Novus.Global.moveCDTbl["Super_Blaster_Circle"][5] = false
	end,true,{"Rail_Blaster","Large_Rail_Blaster","Homing_Blasters","Quad_Rail_Blasters","Blaster_Barrage","Blaster_Circle"},{dmg = Novus.Variables.mediumTickDamage.."/tick (per blaster)",decayDmg = Novus.Variables.mediumDecayDamage.."/tick (per blaster)",desc = "\"Blaster Circle\", but the circle revolves even faster (and for much longer); and on top of that you continously summon blasters aimed at every target with a short delay, all for about a minute."}},]]
	--The move above in its entirety had to unfortunately be disabled, due to too much network load on the clients from the rate the models were being cloned into workspace. It also caused enough lag on the server to be problematic. :( -shooter7620
	Rail_Blaster_Defense = {"Rail Blaster Defense",60,"Blaster",8,function (plr:Player)
		if plr ~= Novus.Global.UserPlayer then
			plr:Kick("Illegal remote access detected (fired a remote which is not permitted to be used by other players).")
			return false
		end
		Novus.Global.Blasters.BlasterDefense(plr,150,30,2)
		Novus.Global.moveCDTbl["Rail_Blaster_Defense"][5] = false
	end,false,{"Blaster_Circle","Blaster_Barrage","Homing_Blasters"},{dmg = Novus.Variables.mediumTickDamage.."/tick (per blaster)",decayDmg = Novus.Variables.mediumDecayDamage.."/tick (per blaster)",desc = "Summons a pair of Rail Blasters every 2 seconds on every target within 150 studs of you, for a duration of 30 seconds."}},
	Telekinetic_Suspension = {"Telekinetic Suspension",6,"Telekinesis",1,function (plr:Player,plrMouseTarget:BasePart,CFRemote:RemoteEvent)
		if plr ~= Novus.Global.UserPlayer then
			plr:Kick("Illegal remote access detected (fired a remote which is not permitted to be used by other players).")
			return false
		end
		Novus.Global.Force.forceHold(Novus.Global.UserPlayer,plrMouseTarget,CFRemote)
		Novus.Global.moveCDTbl["Telekinetic_Suspension"][5] = false
	end,true,{"Rail_Blaster","Large_Rail_Blaster","Homing_Blasters","Quad_Rail_Blasters","Blaster_Barrage","Blaster_Circle","Rail_Blaster_Defense","Blue_Katana_Zone"},{dmg = Novus.Variables.forceSlamDamage.." (if target is pushed away into a surface)",decayDmg = Novus.Variables.forceSlamDecayDamage.." (if target is pushed away into a surface)",desc = "Suspends a humanoid target selected with the mouse cursor, and pushes them away in the direction of the cursor if the key used to initiate this move is released (i.e. You have to hold, not press the initiator key when using this in order to be able to push away your target. Although, just quickly pressing the key again can also work). If the target is pushed into a surface, they suffer damage."}},
	Telekinetic_Slam = {"Telekinetic Slam",12,"Telekinesis",2,function (plr:Player,plrMouseTarget:BasePart)
		if plr ~= Novus.Global.UserPlayer then
			plr:Kick("Illegal remote access detected (fired a remote which is not permitted to be used by other players).")
			return false
		end
		Novus.Global.Force.ForceSlam(Novus.Global.UserPlayer,plrMouseTarget)
		Novus.Global.moveCDTbl["Telekinetic_Slam"][5] = false
	end,true,{"Large_Rail_Blaster","Homing_Blasters","Blaster_Circle","Rail_Blaster_Defense","Blue_Katana_Zone"},{dmg = Novus.Variables.forceHeavySlamDamage.."",decayDmg = Novus.Variables.forceHeavySlamDecayDamage.."",desc = "Grabs a target selected by the mouse cursor with telekinetic force, lifts them into the air; and slams them down to the ground. Does significantly more damage than \"Telekinetic Suspension\"."}},
	Telekinetic_Repulse = {"Telekinetic Repulse",20,"Telekinesis",3,function (plr:Player)
		if plr ~= Novus.Global.UserPlayer then
			plr:Kick("Illegal remote access detected (fired a remote which is not permitted to be used by other players).")
			return false
		end
		Novus.Global.Force.Repulse(plr)
		Novus.Global.moveCDTbl["Telekinetic_Repulse"][5] = false
	end,true,{"Large_Rail_Blaster","Homing_Blasters","Blaster_Circle","Rail_Blaster_Defense","Blue_Katana_Zone"},{dmg = "N/A",decayDmg = "N/A",desc = "Does no damage, but instead pushes all targets within a large radius directly away from you."}}
}

Novus.Variables.hitsTracked = 0::number
Novus.Variables.hitDamageTracked = 0::number
Novus.Variables.baseTrackExpireDelta = 2::number
Novus.Variables.currentTrackExpireDelta = 2::number
Novus.Variables.lastHitTime = 0::number

function Novus.new()
	return setmetatable({},Novus)
end

function Novus:Load(plr:Player)
	if plr:FindFirstAncestorWhichIsA("Players") and plr:GetRankInGroup(3149674) >= 30 then
		wait(plr.Character ~= nil)
		Novus.Global.UserPlayer = plr
	end
end
function Novus:LoadInternal()
	Novus.Global.HomeReference = script
	Novus.Global.ModelFolderReference = script.Models
	Novus.Global.AudioFolderReference = script.Audios
	Novus.Global.UIFolderReference = script.UI
	local nf = Instance.new("Folder")
	nf.Parent = game.ServerScriptService
	nf.Name = "Novus_Container"
	local nsf = Instance.new("Folder")
	nsf.Name = "Novus_Assets"
	nsf.Parent = game.ServerStorage
	script.Models.Parent = nsf
	script.Audios.Parent = nsf
	script.UI.Parent = nsf
	script.Parent = nf
end

Novus.Passives = {}
Novus.Passives.Variables = {}
Novus.Passives.Variables.Stamina = 150
Novus.Passives.Variables.MaxStamina = 150
Novus.Passives.Variables.Speed = 28
Novus.Passives.Variables.BlockIFDuration = 0.65
Novus.Passives.Variables.FakeHealth = 9*10000
Novus.Passives.Variables.CurrentFakeHealth = nil::number
Novus.Passives.Variables.RealHealth = 10
Novus.Passives.Variables.cDB = false

function Novus.Passives.EnableReflexes(plr:Player)
	if plr ~= Novus.Global.UserPlayer then
		plr:Kick("Illegal remote access detected (fired a remote which is not permitted to be used by other players).")
		return false
	end
	wait(plr.Character ~= nil)
	local hm = plr.Character:FindFirstChild("Humanoid")::Humanoid
	plr.Character.Humanoid.MaxHealth = Novus.Passives.Variables.FakeHealth
	plr.Character.Humanoid.Health = Novus.Passives.Variables.FakeHealth
	plr.Character.Humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
	plr.Character.Humanoid.NameDisplayDistance = 100
	plr.Character.Humanoid.DisplayName = ""
	Novus.Passives.Variables.CurrentFakeHealth = plr.Character.Humanoid.Health
	plr.Character.Humanoid.WalkSpeed = Novus.Passives.Variables.Speed
	task.spawn(function()
		while Novus.Global.UserPlayer.Character.Humanoid.Health > 1 do
			for i,v in pairs(Novus.Global.DecayTable) do
				Novus.Global.doDecayDamage(v[1],2)
			end
			task.wait(0.25)
		end
	end)
	hm:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
		if hm.Health == 1 then
			return
		end
		if hm.WalkSpeed == 0 then
			hm:GetPropertyChangedSignal("WalkSpeed"):Wait()
			hm.WalkSpeed = 32
		else
			hm.WalkSpeed = 32
		end
	end)
	task.spawn(function()
		while hm.Health > 1 do
			hm:GetPropertyChangedSignal("Health"):Wait()
			if hm.Health == 0 then
				return
			end
			if not Novus.Passives.Variables.cDB then
				Novus.Passives.Variables.cDB = true
				if hm.Health < Novus.Passives.Variables.CurrentFakeHealth then
					if Novus.Passives.Variables.Stamina > 0 then
						local ff = Instance.new("ForceField")
						ff.Visible = false
						ff.Parent = hm.Parent
						hm.Health = Novus.Passives.Variables.FakeHealth
						local blkTI = TweenInfo.new(
							0.25,
							Enum.EasingStyle.Sine,
							Enum.EasingDirection.In,
							0,
							false,
							0
						)
						local clnTbl = {}
						local cln = hm.Parent.Torso:Clone()::BasePart
						cln.Parent = workspace
						for i,v in pairs(cln:GetChildren()) do
							if v:IsA("Motor6D") then
								v:Destroy()
							end
						end
						cln.Anchored = true
						cln.Material = Enum.Material.Neon
						cln.BrickColor = BrickColor.new("Institutional white")
						cln.CanCollide = false
						cln.CanQuery = false
						table.insert(clnTbl,cln)
						for i,v in pairs(hm.Parent:GetChildren()) do
							if v:IsA("BasePart") and v ~= hm.Parent.Torso and v.Name ~= "HumanoidRootPart" then
								local cln = v:Clone()
								cln.Anchored = true
								cln.Material = Enum.Material.Neon
								cln.BrickColor = BrickColor.new("Institutional white")
								cln.Parent = workspace
								cln.CanCollide = false
								cln.CanQuery = false
								table.insert(clnTbl,cln)
							end
						end
						for i,v in pairs(clnTbl) do
							if v:FindFirstChildOfClass("Decal") then
								v:FindFirstChildOfClass("Decal"):Destroy()
							end
							local tw = TweenService:Create(v,blkTI,{Size = Vector3.new(v.Size.X*5,v.Size.Y*5,v.Size.Z*5),Transparency = 1})
							tw:Play()
							task.spawn(function()
								tw.Completed:Wait()
								v:Destroy()
							end)
						end
						local blSound = Novus.Global.AudioFolderReference.BlockSound:Clone()
						blSound.Parent = hm.RootPart
						blSound:Play()
						task.spawn(function ()
							blSound.Ended:Wait()
							blSound:Destroy()
						end)
						local blIndicator:BillboardGui = Novus.Global.ModelFolderReference.BlockIndicator:Clone()
						blIndicator.Parent = hm.Parent.Head
						local tw = TweenService:Create(blIndicator,blkTI,{ExtentsOffsetWorldSpace = Vector3.new(0,10,0)})
						local rtw = TweenService:Create(blIndicator,blkTI,{ExtentsOffsetWorldSpace = Vector3.new(0,5,0)})
						task.spawn(function ()
							tw:Play()
							tw.Completed:Wait()
							rtw:Play()
							rtw.Completed:Wait()
							task.wait(0.25)
							blIndicator:Destroy()
						end)
						Novus.Passives.Variables.Stamina -= 1
						task.wait(Novus.Passives.Variables.BlockIFDuration)
						ff:Destroy()
						Novus.Passives.Variables.cDB = false
					else
						local aniTrack:AnimationTrack = plr.Character.Humanoid:LoadAnimation(Novus.Variables.fatalAnim)
						aniTrack:Play(0.1,1,1)
						local ff = Instance.new("ForceField")
						ff.Visible = false
						ff.Parent = plr.Character
						plr.Character.Humanoid.Health = 1
						Novus.Passives.Variables.RealHealth = 0.1
						plr.PlayerGui.Novus_UI.Main.CharInfoUI.HPOverhead.Bar.HPValue.Text = "0.1"
						plr.Character.Humanoid.WalkSpeed = 0
						plr.Character.Humanoid.JumpPower = 0
						task.wait(10)
						for i,v in pairs(plr.Character:GetDescendants()) do
							if v:IsA("BasePart") then
								TweenService:Create(v,TweenInfo.new(1,Enum.EasingStyle.Sine,Enum.EasingDirection.Out,0,false,0),{Transparency = 0}):Play()
							end
						end
						task.wait(1)
						plr:LoadCharacter()
					end
				end
			end
			Novus.Passives.Variables.cDB = false
		end	
	end)
end

function Novus.Global.HitComboDisplay(dmg:number):(number,number)
	if Novus.Variables.currentTrackExpireDelta == 0 then
		Novus.Variables.currentTrackExpireDelta = Novus.Variables.baseTrackExpireDelta
	end
	if Novus.Variables.lastHitTime == 0 then
		Novus.Variables.lastHitTime = tick()
	end
	if tick()-Novus.Variables.lastHitTime < 0.25 and tick()-Novus.Variables.lastHitTime <= Novus.Variables.currentTrackDelta then
		Novus.Variables.hitsTracked += 1
		Novus.Variables.hitDamageTracked += dmg
		Novus.Variables.currentTrackExpireDelta -= Novus.Variables.currentTrackExpireDelta * 0.1 --Expiration time will decrease by 10% each time there is a hit, so as to encourage accurate, quick attacking (if the user cares about the useless display, that is). -shooter7620
		Novus.Variables.lastHitTime = tick()
	elseif tick()-Novus.Variables.lastHitTime > Novus.Variables.currentTrackDelta then
		Novus.Variables.hitsTracked = 0
		Novus.Variables.hitDamageTracked = 0
		Novus.Variables.currentTrackExpireDelta = Novus.Variables.baseTrackExpireDelta
		Novus.Variables.lastHitTime = 0
	end
	return Novus.Variables.hitsTracked,Novus.Variables.hitDamageTracked
end
function Novus.Global.doDamageToHumanoid(humanoid:Humanoid,dmg:number,bypass:boolean,decayDmg:number)
	if bypass == nil then
		bypass = false
	end
	if typeof(humanoid) == "Instance" and typeof(dmg) == "number" and typeof(bypass) == "boolean" then
		if humanoid.Parent:FindFirstChildOfClass("ForceField") == nil then
			humanoid.Health -= dmg
		elseif bypass == true then
			humanoid.Health -= dmg
		end
		if decayDmg and typeof(decayDmg) == "number" then
			if Novus.Global.DecayTable[humanoid.Parent] == nil then
				Novus.Global.DecayTable[humanoid.Parent] = {humanoid,decayDmg}
				if humanoid.Parent.Head:FindFirstChild("DecayIndicator") == nil then
					local bbui = Novus.Global.ModelFolderReference.DecayIndicator:Clone()
					bbui.Parent = humanoid.Parent.Head
				end
			else
				Novus.Global.DecayTable[humanoid.Parent][2] += decayDmg
			end
		end
	else
		return false,warn("Type error in one of the arguments. Please check argument types. Types of arguments submitted: "..typeof(humanoid)..", "..typeof(dmg)..", "..typeof(bypass))
	end
end
function Novus.Global.doDamageWithPart(refPart:Part,dmg:number,decayDmg:number,isBlue:boolean)
	if isBlue == nil then
		isBlue = false
	end
	local OLP = OverlapParams.new()
	OLP.RespectCanCollide = false
	OLP.MaxParts = 0
	OLP.FilterType = Enum.RaycastFilterType.Blacklist
	local blTbl = {}
	for i,v in pairs(workspace:GetChildren()) do
		if v:FindFirstChild("Humanoid") == nil or v == Novus.Global.UserPlayer.Character then
			table.insert(blTbl,v)
		end
	end
	OLP.FilterDescendantsInstances = blTbl
	for i,part in pairs(workspace:GetPartsInPart(refPart,OLP)) do
		if isBlue then
			if part.Parent:FindFirstChild("Humanoid") ~= nil and part.Parent:FindFirstChild("Humanoid").Health ~= 0 and math.floor(part.Parent:FindFirstChild("HumanoidRootPart").AssemblyAngularVelocity.Magnitude) ~= 0 and math.floor(part.Parent:FindFirstChild("HumanoidRootPart").AssemblyLinearVelocity.Magnitude) ~= 0 then
				local curHP = part.Parent.Humanoid.Health
				Novus.Global.doDamageToHumanoid(part.Parent.Humanoid,dmg,false)
				if part.Parent.Humanoid.Health ~= curHP then
					local hm = part.Parent:FindFirstChild("Humanoid")
					if Novus.Global.DecayTable[hm.Parent] == nil then
						Novus.Global.DecayTable[hm.Parent] = {hm,decayDmg}
						if part.Parent.Head:FindFirstChild("DecayIndicator") == nil then
							local bbui = Novus.Global.ModelFolderReference.DecayIndicator:Clone()
							bbui.Parent = part.Parent.Head
						end
					else
						Novus.Global.DecayTable[hm.Parent][2] += decayDmg
					end
				end
			end
		else
			if part.Parent:FindFirstChild("Humanoid") ~= nil and part.Parent:FindFirstChild("Humanoid").Health ~= 0 then
				local curHP = part.Parent.Humanoid.Health
				Novus.Global.doDamageToHumanoid(part.Parent.Humanoid,dmg,false)
				if part.Parent.Humanoid.Health ~= curHP then
					local hm = part.Parent:FindFirstChild("Humanoid")
					if Novus.Global.DecayTable[hm.Parent] == nil then
						Novus.Global.DecayTable[hm.Parent] = {hm,decayDmg}
						if part.Parent.Head:FindFirstChild("DecayIndicator") == nil then
							local bbui = Novus.Global.ModelFolderReference.DecayIndicator:Clone()
							bbui.Parent = part.Parent.Head
						end
					else
						Novus.Global.DecayTable[hm.Parent][2] += decayDmg
					end
				end
			end
		end
	end
end
function Novus.Global.doDamageWithZone(refCF:CFrame,refSize:Vector3,dmg:number,decayDmg:number)
	local OLP = OverlapParams.new()
	OLP.RespectCanCollide = false
	OLP.MaxParts = 0
	OLP.FilterType = Enum.RaycastFilterType.Blacklist
	local blTbl = {}
	for i,v in pairs(workspace:GetChildren()) do
		if v:FindFirstChild("Humanoid") == nil or v == Novus.Global.UserPlayer.Character then
			table.insert(blTbl,v)
		end
	end
	OLP.FilterDescendantsInstances = blTbl
	for i,part in pairs(workspace:GetPartBoundsInBox(refCF,refSize,OLP)) do
		if part.Parent:FindFirstChild("Humanoid") ~= nil and part.Parent:FindFirstChild("Humanoid").Health ~= 0 then
			local curHP = part.Parent.Humanoid.Health
			Novus.Global.doDamageToHumanoid(part.Parent.Humanoid,dmg,false)
			if part.Parent.Humanoid.Health ~= curHP then
				local hm = part.Parent:FindFirstChild("Humanoid")
				if Novus.Global.DecayTable[hm.Parent] == nil then
					Novus.Global.DecayTable[hm.Parent] = {hm,decayDmg}
					if part.Parent.Head:FindFirstChild("DecayIndicator") == nil then
						local bbui = Novus.Global.ModelFolderReference.DecayIndicator:Clone()
						bbui.Parent = part.Parent.Head
					end
				else
					Novus.Global.DecayTable[hm.Parent][2] += decayDmg
				end
			end
		end
	end
end
function Novus.Global.doDecayDamage(hm:Humanoid,healthDmgPercent:number) --NOTE: "healthDmgPercent" is not a parameter expressed as a fraction alpha for the argument. Use a number (integer and float both work) through 0 to 100; the function automatically converts it to a fraction.
	assert(healthDmgPercent > 0 and healthDmgPercent <= 100,"Number for argument #2 must be a value between 0-100.")
	if Novus.Global.DecayTable[hm.Parent] ~= nil then
		local dtHMRef = Novus.Global.DecayTable[hm.Parent]
		if dtHMRef[1].Health - (healthDmgPercent/100)*dtHMRef[1].MaxHealth <= 0 and dtHMRef[2] >= (healthDmgPercent/100)*dtHMRef[1].MaxHealth then
			dtHMRef[1].Health = 1
			dtHMRef[2] = 0
			Novus.Global.DecayTable[hm.Parent] = nil
			hm.Parent.Head:FindFirstChild("DecayIndicator"):Destroy()
		elseif dtHMRef[1].Health - (healthDmgPercent/100)*dtHMRef[1].MaxHealth > 0 and dtHMRef[2] < (healthDmgPercent/100)*dtHMRef[1].MaxHealth then
			Novus.Global.doDamageToHumanoid(dtHMRef[1],dtHMRef[2],true)
			dtHMRef[2] = 0
			Novus.Global.DecayTable[hm.Parent] = nil
			hm.Parent.Head:FindFirstChild("DecayIndicator"):Destroy()
		elseif dtHMRef[1].Health - (healthDmgPercent/100)*dtHMRef[1].MaxHealth > 0 and dtHMRef[2] >= (healthDmgPercent/100)*dtHMRef[1].MaxHealth then
			Novus.Global.doDamageToHumanoid(dtHMRef[1],(healthDmgPercent/100)*dtHMRef[1].MaxHealth,true)
			dtHMRef[2] -= (healthDmgPercent/100)*dtHMRef[1].MaxHealth
		elseif dtHMRef[1].Health == 0 then
			Novus.Global.DecayTable[hm.Parent] = nil
			hm.Parent.Head:FindFirstChild("DecayIndicator"):Destroy()
		end
	end
end
function Novus.Global.Blasters.UseBlasterInternal(beginCF,summonCF,targetCF,blasterSize,isHoming)
	if isHoming == nil then
		isHoming = false
	end
	local dV = Novus.Variables
	local TI = Novus.Global.Blasters.TweeningInfo
	local rBR
	local rBSSound
	local rBFSound
	if blasterSize == "Small" then
		rBR = Novus.Global.ModelFolderReference.BlasterRoot:Clone()
		rBR.CFrame = beginCF
		rBR.Parent = workspace
		rBSSound = Novus.Global.AudioFolderReference.placeholderSummon3:Clone()
		rBSSound.Parent = rBR
		rBFSound = Novus.Global.AudioFolderReference.placeholderFire2:Clone()
		rBFSound.Parent = rBR
	elseif blasterSize == "Medium" then
		rBR = Novus.Global.ModelFolderReference.MediumBlasterRoot:Clone()
		rBR.CFrame = beginCF
		rBR.Parent = workspace
		rBSSound = Novus.Global.AudioFolderReference.placeholderSummon3:Clone()
		rBSSound.Parent = rBR
		rBFSound = Novus.Global.AudioFolderReference.placeholderFire2:Clone()
		rBFSound.Parent = rBR
	elseif blasterSize == "Large" then
		rBR = Novus.Global.ModelFolderReference.LargeBlasterRoot:Clone()
		rBR.CFrame = beginCF
		rBR.Parent = workspace
		rBSSound = Novus.Global.AudioFolderReference.placeholderSummon3:Clone()
		rBSSound.Parent = rBR
		rBSSound.PlaybackSpeed = 0.9
		rBFSound = Novus.Global.AudioFolderReference.placeholderFire2:Clone()
		rBFSound.Parent = rBR
		rBFSound.PlaybackSpeed = 0.9
	else
		return warn("Select a valid Blaster size (\"Small\", \"Medium\", or \"Large\").")
	end
	local beamDB = false
	local baseDB = false
	if blasterSize == "Large" then
		local rBRSTween = TweenService:Create(rBR,TI.LargeBlasterSummon,{CFrame = CFrame.lookAt(summonCF.Position,targetCF.Position)})
		local rBRVTween = TweenService:Create(rBR,TI.BlasterSummonVisible,TI.Visible)
		local rBRBFTween = TweenService:Create(rBR.ShootBase,TI.BlasterFire,TI.LargeBaseDimensions)
		local rBRBVTween = TweenService:Create(rBR.ShootBase,TI.BlasterVisible,TI.Visible)
		local rBRBRTween = TweenService:Create(rBR.RingBurst,TI.BlasterFireDecay,TI.LargeRingDimensions)
		local rBRBRVTween = TweenService:Create(rBR.RingBurst,TI.BlasterVisible,TI.Visible)
		local rBRBRIVTween = TweenService:Create(rBR.RingBurst,TI.BlasterVisible,TI.Decay)
		local rBRBBTween = TweenService:Create(rBR.ShootBeam,TI.BlasterFire,TI.LargeBeamDimensions)
		local rBRBBVTween = TweenService:Create(rBR.ShootBeam,TI.BlasterVisible,TI.Visible)
		local rBRBBOTween = TweenService:Create(rBR.ShootBeam,TI.LargeBlasterOscillate,TI.OscLargeBeamDimensions)
		local rBRDTween = TweenService:Create(rBR,TI.BlasterFire,TI.Decay)
		local rBRBFDTween = TweenService:Create(rBR.ShootBase,TI.BlasterFireDecay,TI.LargeDecayBaseDimensions)
		local rBRBIVTween = TweenService:Create(rBR.ShootBase,TI.BlasterFireDecay,TI.Decay)
		local rBRBBDTween = TweenService:Create(rBR.ShootBeam,TI.BlasterFireDecay,TI.LargeDecayBeamDimensions)
		local rBRBBIVTween = TweenService:Create(rBR.ShootBeam,TI.BlasterFireDecay,TI.Decay)
		rBRSTween:Play()
		rBRVTween:Play()
		rBSSound:Play()
		rBRSTween.Completed:Wait()
		local rBRRCTween = TweenService:Create(rBR,TI.LargeBlasterRecoil,{CFrame = rBR.CFrame + rBR.CFrame.LookVector * -120})
		rBFSound:Play()
		rBRBVTween:Play()
		rBRBFTween:Play()
		rBRBBVTween:Play()
		rBRBBTween:Play()
		rBR.ShootBase.CanTouch = true
		rBR.ShootBeam.CanTouch = true
		rBRBRVTween:Play()
		rBRBRTween:Play()
		rBR.RingBurst.Anchored = true
		task.spawn(function()
			task.wait(0.4)
			rBRBRIVTween:Play()
		end)
		task.spawn(function()
			while rBRDTween.PlaybackState ~= Enum.PlaybackState.Playing do
				if rBR.ShootBeam.Transparency <= 0.7 then
					Novus.Global.doDamageWithPart(rBR.ShootBeam,dV.largeTickDamage,dV.largeDecayDamage)
				end
				task.wait(0.025)
			end
		end)
		task.spawn(function()
			while rBRDTween.PlaybackState ~= Enum.PlaybackState.Playing do
				if rBR.ShootBase.Transparency <= 0.7 then
					Novus.Global.doDamageWithPart(rBR.ShootBase,dV.largeTickDamage,dV.largeDecayDamage)
				end
				task.wait(0.025)
			end
		end)
		task.spawn(function()
			rBRBBTween.Completed:Wait()
			rBRBBOTween:Play()
		end)
		task.wait(0.1)
		rBRRCTween:Play()
		task.wait(1.5)
		rBRBFDTween:Play()
		rBRBIVTween:Play()
		rBRBBDTween:Play()
		rBRBBIVTween:Play()
		rBRBFDTween.Completed:Wait()
		rBRDTween:Play()
		rBRDTween.Completed:Wait()
		rBR:Destroy()
	elseif blasterSize == "Medium" then
		local rBLSTween
		if isHoming then
			rBLSTween = TweenService:Create(rBR,TI.MediumHomingBlasterSummon,{CFrame = CFrame.lookAt(summonCF.Position,targetCF.Position)})
		else
			rBLSTween = TweenService:Create(rBR,TI.BlasterSummon,{CFrame = CFrame.lookAt(summonCF.Position,targetCF.Position)})
		end
		local rBLVTween = TweenService:Create(rBR,TI.BlasterSummonVisible,TI.Visible)
		local rBLBFTween = TweenService:Create(rBR.ShootBase,TI.BlasterFire,TI.MediumBaseDimensions)
		local rBLBVTween = TweenService:Create(rBR.ShootBase,TI.BlasterVisible,TI.Visible)
		local rBLBRTween = TweenService:Create(rBR.RingBurst,TI.BlasterFireDecay,TI.MediumBaseRingDimensions)
		local rBLBRVTween = TweenService:Create(rBR.RingBurst,TI.BlasterVisible,TI.Visible)
		local rBLBRIVTween = TweenService:Create(rBR.RingBurst,TI.BlasterVisible,TI.Decay)
		local rBLBBTween = TweenService:Create(rBR.ShootBeam,TI.BlasterFire,TI.MediumBeamDimensions)
		local rBLBBVTween = TweenService:Create(rBR.ShootBeam,TI.BlasterVisible,TI.Visible)
		local rBLBBOTween = TweenService:Create(rBR.ShootBeam,TI.BlasterOscillate,TI.OscMediumBeamDimensions)
		local rBLDTween = TweenService:Create(rBR,TI.BlasterFire,TI.Decay)
		local rBLBFDTween = TweenService:Create(rBR.ShootBase,TI.BlasterFireDecay,TI.MediumDecayBaseDimensions)
		local rBLBIVTween = TweenService:Create(rBR.ShootBase,TI.BlasterFireDecay,TI.Decay)
		local rBLBBDTween = TweenService:Create(rBR.ShootBeam,TI.BlasterFireDecay,TI.MediumDecayBeamDimensions)
		local rBLBBIVTween = TweenService:Create(rBR.ShootBeam,TI.BlasterFireDecay,TI.Decay)
		rBLSTween:Play()
		rBLVTween:Play()
		rBSSound:Play()
		rBLSTween.Completed:Wait()
		local rBLRCTween = TweenService:Create(rBR,TI.BlasterRecoil,{CFrame = rBR.CFrame + rBR.CFrame.LookVector * -110})
		rBFSound:Play()
		rBLBVTween:Play()
		rBLBFTween:Play()
		rBLBBVTween:Play()
		rBLBBTween:Play()
		rBR.ShootBase.CanTouch = true
		rBR.ShootBeam.CanTouch = true
		rBLBRVTween:Play()
		rBLBRTween:Play()
		rBR.RingBurst.Anchored = true
		task.spawn(function()
			task.wait(0.4)
			rBLBRIVTween:Play()
		end)
		task.spawn(function()
			while rBLDTween.PlaybackState ~= Enum.PlaybackState.Playing do
				if rBR.ShootBeam.Transparency <= 0.75 then
					Novus.Global.doDamageWithPart(rBR.ShootBeam,dV.mediumTickDamage,dV.mediumDecayDamage)
				end
				task.wait(0.025)
			end
		end)
		task.spawn(function()
			while rBLDTween.PlaybackState ~= Enum.PlaybackState.Playing do
				if rBR.ShootBase.Transparency <= 0.75 then
					Novus.Global.doDamageWithPart(rBR.ShootBase,dV.mediumTickDamage,dV.mediumDecayDamage)
				end
				task.wait(0.025)
			end
		end)
		task.spawn(function()
			rBLBBTween.Completed:Wait()
			rBLBBOTween:Play()
		end)
		task.wait(0.1)
		rBLRCTween:Play()
		task.wait(0.8)
		rBLBFDTween:Play()
		rBLBIVTween:Play()
		rBLBBDTween:Play()
		rBLBBIVTween:Play()
		rBLBFDTween.Completed:Wait()
		rBLDTween:Play()
		rBLDTween.Completed:Wait()
		rBR:Destroy()
	elseif blasterSize == "Small" then
		local rBLSTween
		if isHoming then
			rBLSTween = TweenService:Create(rBR,TI.HomingBlasterSummon,{CFrame = CFrame.lookAt(summonCF.Position,targetCF.Position)})
		else
			rBLSTween = TweenService:Create(rBR,TI.BlasterSummon,{CFrame = CFrame.lookAt(summonCF.Position,targetCF.Position)})
		end
		local rBLVTween = TweenService:Create(rBR,TI.BlasterSummonVisible,TI.Visible)
		local rBLBFTween = TweenService:Create(rBR.ShootBase,TI.BlasterFire,TI.BaseDimensions)
		local rBLBVTween = TweenService:Create(rBR.ShootBase,TI.BlasterVisible,TI.Visible)
		local rBLBRTween = TweenService:Create(rBR.RingBurst,TI.BlasterFireDecay,TI.BaseRingDimensions)
		local rBLBRVTween = TweenService:Create(rBR.RingBurst,TI.BlasterVisible,TI.Visible)
		local rBLBRIVTween = TweenService:Create(rBR.RingBurst,TI.BlasterVisible,TI.Decay)
		local rBLBBTween = TweenService:Create(rBR.ShootBeam,TI.BlasterFire,TI.BeamDimensions)
		local rBLBBVTween = TweenService:Create(rBR.ShootBeam,TI.BlasterVisible,TI.Visible)
		local rBLBBOTween = TweenService:Create(rBR.ShootBeam,TI.BlasterOscillate,TI.OscBeamDimensions)
		local rBLDTween = TweenService:Create(rBR,TI.BlasterFire,TI.Decay)
		local rBLBFDTween = TweenService:Create(rBR.ShootBase,TI.BlasterFireDecay,TI.DecayBaseDimensions)
		local rBLBIVTween = TweenService:Create(rBR.ShootBase,TI.BlasterFireDecay,TI.Decay)
		local rBLBBDTween = TweenService:Create(rBR.ShootBeam,TI.BlasterFireDecay,TI.DecayBeamDimensions)
		local rBLBBIVTween = TweenService:Create(rBR.ShootBeam,TI.BlasterFireDecay,TI.Decay)
		rBLSTween:Play()
		rBLVTween:Play()
		rBSSound:Play()
		rBLSTween.Completed:Wait()
		local rBLRCTween = TweenService:Create(rBR,TI.BlasterRecoil,{CFrame = rBR.CFrame + rBR.CFrame.LookVector * -100})
		rBFSound:Play()
		rBLBVTween:Play()
		rBLBFTween:Play()
		rBLBBVTween:Play()
		rBLBBTween:Play()
		rBR.ShootBase.CanTouch = true
		rBR.ShootBeam.CanTouch = true
		rBLBRVTween:Play()
		rBLBRTween:Play()
		rBR.RingBurst.Anchored = true
		task.spawn(function()
			task.wait(0.4)
			rBLBRIVTween:Play()
		end)
		task.spawn(function()
			while rBLDTween.PlaybackState ~= Enum.PlaybackState.Playing do
				if rBR.ShootBeam.Transparency <= 0.75 then
					Novus.Global.doDamageWithPart(rBR.ShootBeam,dV.tickDamage,dV.decayDamage)
				end
				task.wait(0.025)
			end
		end)
		task.spawn(function()
			while rBLDTween.PlaybackState ~= Enum.PlaybackState.Playing do
				if rBR.ShootBase.Transparency <= 0.75 then
					Novus.Global.doDamageWithPart(rBR.ShootBase,dV.tickDamage,dV.decayDamage)
				end
				task.wait(0.025)
			end
		end)
		task.spawn(function()
			rBLBBTween.Completed:Wait()
			rBLBBOTween:Play()
		end)
		task.wait(0.1)
		rBLRCTween:Play()
		task.wait(0.8)
		rBLBFDTween:Play()
		rBLBIVTween:Play()
		rBLBBDTween:Play()
		rBLBBIVTween:Play()
		rBLBFDTween.Completed:Wait()
		rBLDTween:Play()
		rBLDTween.Completed:Wait()
		rBR:Destroy()
	end
end
function Novus.Global.Blasters.UseHomingBlasters(target:Model,blasterCount:number,BlasterSize:string,blasterDelay:number,fireRepeats:number) --...Desperately needs a rework, or an alternate function. Too prone to performance issues when used in remotely large numbers or the delay is set too low.
	assert(target:FindFirstChild("Humanoid") ~= nil,"Target must be a character model.")
	if blasterCount <= 4 then
		if BlasterSize == "Medium" then
			blasterDelay *= 5
		end
		for i = 1,fireRepeats,1 do
			if target:FindFirstChild("HumanoidRootPart") == nil or target.Humanoid.Health == 0 then
				return
			end
			for i = 1,blasterCount,1 do
				local charCF = target.HumanoidRootPart.CFrame
				local vectorToCF = CFrame.new(charCF.Position) * CFrame.Angles(math.rad(math.random(-90,-0)),math.rad(math.random(0,360)),0)
				local z,y,x = vectorToCF:ToEulerAnglesXYZ()
				local rn = math.random(0,180)
				if math.abs(math.deg(z)) >= 90 and math.abs(math.deg(x)) >= 90 then
					vectorToCF = CFrame.new(vectorToCF.Position) * CFrame.Angles(math.sign(x)*math.rad(rn),y,math.sign(z)*math.rad(rn))
				end
				vectorToCF += vectorToCF.LookVector * -100
				vectorToCF = CFrame.lookAt(vectorToCF.Position,charCF.Position)
				local beginCF
				if BlasterSize == "Small" then
					beginCF = vectorToCF + vectorToCF.LookVector * -50
				elseif BlasterSize == "Medium" then
					vectorToCF += vectorToCF.LookVector * -10
					beginCF = vectorToCF + vectorToCF.LookVector * -56.25
				else
					vectorToCF += vectorToCF.LookVector * -10
					beginCF = vectorToCF + vectorToCF.LookVector * -56.25
					task.spawn(Novus.Global.Blasters.UseBlasterInternal,beginCF,vectorToCF,charCF,"Medium",true)
				end
				task.spawn(Novus.Global.Blasters.UseBlasterInternal,beginCF,vectorToCF,charCF,BlasterSize,true)
			end
			task.wait(blasterDelay)
		end
	end
end
function Novus.Global.Blasters.UseTrackingBlasters(plr:Player,radius:number,blsCount:number,repeatCount:number,blsDelay:number)

end
function Novus.Global.Blasters.BlasterDefense(plr:Player,radius:number,duration:number,defDelay:number)
	local defDelayTbl = {}
	local OLP = OverlapParams.new()
	OLP.RespectCanCollide = false
	OLP.FilterType = Enum.RaycastFilterType.Whitelist
	local ct = tick()
	while tick()-ct <= duration do
		local charCF = plr.Character.PrimaryPart.CFrame
		local wlTbl = {}
		for i,v in pairs(workspace:GetChildren()) do
			if v:FindFirstChild("Humanoid") and v.Humanoid.Health ~= 0 and v ~= Novus.Global.UserPlayer.Character then
				table.insert(wlTbl,v)
			end
		end
		OLP.FilterDescendantsInstances = wlTbl
		local partRef = workspace:GetPartBoundsInRadius(charCF.Position,radius,OLP)
		local tgtTbl = {}
		for i,v in pairs(partRef) do
			if #tgtTbl >= 8 then --Put a cap here premptively, not going to engage more than 8 targets at once for performance reasons.
				break
			end
			if table.find(tgtTbl,v.Parent) == nil then
				table.insert(tgtTbl,v.Parent)
			end
		end
		for i,v in pairs(tgtTbl) do
			if defDelayTbl[v] == nil or defDelayTbl[v] <= 0 then
				if v:FindFirstChild("HumanoidRootPart") then
					local targetCF = v:FindFirstChild("HumanoidRootPart").CFrame
					local vectorToCF = CFrame.lookAt(charCF.Position,targetCF.Position)
					vectorToCF = vectorToCF + (vectorToCF.LookVector * (math.random(1.05,1.35) * 5.25)) + (vectorToCF.RightVector * (math.random(17,30))) + (vectorToCF.UpVector * (math.random(1,6) * 7))
					local beginCF = vectorToCF + vectorToCF.LookVector * -56.25
					local vectorToCF2 = CFrame.lookAt(charCF.Position,targetCF.Position)
					vectorToCF2 = vectorToCF2 + (vectorToCF2.LookVector * (math.random(1.05,1.35) * 5.25)) + (vectorToCF2.RightVector * (-1 * math.random(17,30))) + (vectorToCF2.UpVector * (math.random(1,6) * 7))
					local beginCF2 = vectorToCF2 + vectorToCF2.LookVector * -56.25
					task.spawn(Novus.Global.Blasters.UseBlasterInternal,beginCF,vectorToCF,targetCF,"Medium")
					task.spawn(Novus.Global.Blasters.UseBlasterInternal,beginCF2,vectorToCF2,targetCF,"Medium")
					task.spawn(function()
						defDelayTbl[v] = defDelay
						task.wait(defDelay)
						defDelayTbl[v] = nil
					end)
				end
			end
		end
		task.wait(0.05)
	end
end
function Novus.Global.Swords.summonSliderInternal(beginCF,summonCF,TargetCF,height,sType)
	local TI = Novus.Global.Swords.TweeningInfo
	local dV = Novus.Variables
	if sType == "Normal" then
		local heightTbl = {
			Novus.Global.ModelFolderReference.KatanaJumpLow,
			Novus.Global.ModelFolderReference.KatanaJumpMedium,
			Novus.Global.ModelFolderReference.KatanaJumpLarge
		}
		local kj
		for i,v in pairs(heightTbl) do
			if i == height then
				kj = v
			end
		end
		if kj == nil then
			return warn("Not a valid height for type \"Normal\".")
		end
		local aKJ = kj:Clone()
		aKJ.Parent = workspace
		aKJ.PrimaryPart.CFrame = beginCF * aKJ.PrimaryPart.PivotOffset
		local kjRiseSound = Novus.Global.AudioFolderReference.ZoneRise:Clone()
		kjRiseSound.Parent = aKJ.PrimaryPart
		for k,v in pairs(aKJ:GetChildren()) do
			task.spawn(function()
				local ct = tick()
				while tick()-ct <= 3.25 do
					Novus.Global.doDamageWithPart(v,dV.wallDamage,dV.wallDecayDamage)
					task.wait(0.025)
				end
			end)
		end
		local riseTween = TweenService:Create(aKJ.PrimaryPart,TI.ZoneRaise,{CFrame = summonCF * aKJ.PrimaryPart.PivotOffset})
		riseTween:Play()
		kjRiseSound:Play()
		riseTween.Completed:Wait()
		local slideTween = TweenService:Create(aKJ.PrimaryPart,TI.WallSlide,{CFrame = aKJ.PrimaryPart.CFrame + aKJ.PrimaryPart.CFrame.LookVector * -dV.SwordRange})
		slideTween:Play()
		slideTween.Completed:Wait()
		aKJ:Destroy()
	elseif sType == "Blue" then
		local heightTbl = {
			Novus.Global.ModelFolderReference.BlueKatanaJumpMedium,
			Novus.Global.ModelFolderReference.BlueKatanaJumpLarge
		}
		local kj
		for k,v in pairs(heightTbl) do
			if k == height then
				kj = v
			end
		end
		if kj == nil then
			return warn("Not a valid height for type \"Blue\".")
		end
		local aKJ = kj:Clone()
		aKJ.Parent = workspace
		aKJ.PrimaryPart.CFrame = beginCF * aKJ.PrimaryPart.PivotOffset
		local kjRiseSound = Novus.Global.AudioFolderReference.ZoneRise:Clone()
		kjRiseSound.Parent = aKJ.PrimaryPart
		for k,v in pairs(aKJ:GetChildren()) do
			task.spawn(function()
				local ct = tick()
				while tick()-ct <= 3.25 do
					Novus.Global.doDamageWithPart(v,dV.wallDamage,dV.wallDecayDamage)
					task.wait(0.025)
				end
			end)
		end
		local riseTween = TweenService:Create(aKJ.PrimaryPart,TI.ZoneRaise,{CFrame = summonCF * aKJ.PrimaryPart.PivotOffset})
		riseTween:Play()
		kjRiseSound:Play()
		riseTween.Completed:Wait()
		local slideTween = TweenService:Create(aKJ.PrimaryPart,TI.WallSlide,{CFrame = aKJ.PrimaryPart.CFrame + aKJ.PrimaryPart.CFrame.RightVector * -dV.SwordRange})
		slideTween:Play()
		slideTween.Completed:Wait()
		aKJ:Destroy()
	else
		return warn("Wrong katana type selected. Valid types are \"Normal\", and \"Blue\".")
	end
end
function Novus.Global.Swords.throwSwordGlobal(plr,targetCF,swordType)
	local TI = Novus.Global.Swords.TweeningInfo
	local charCF = plr.Character.HumanoidRootPart.CFrame
	local summonCF = CFrame.lookAt(charCF.Position,targetCF.Position)
	local sideOffset = Random.new():NextNumber(1.0,1.5)
	sideOffset *= math.random(-1,1)
	if sideOffset == 0 then
		sideOffset = Random.new():NextNumber(1.0,1.5)
	end
	if swordType == "Normal" then
		local kp = Novus.Global.ModelFolderReference.KatanaMediumProjectile:Clone()
		kp.Parent = workspace
		summonCF = summonCF + (summonCF.RightVector * (sideOffset * 5)) + (summonCF.LookVector * 4)
		summonCF = CFrame.lookAt(summonCF.Position,targetCF.Position)
		summonCF *= kp.PivotOffset.Rotation
		local beginCF = summonCF + (summonCF.LookVector * -8)
		beginCF = beginCF * CFrame.Angles(math.rad(math.random(0,360)),math.rad(math.random(0,360)),math.rad(math.random(0,360)))
		local kpVisible = TweenService:Create(kp,TI.SwordVisible,{Transparency = 0})
		local kpSummon = TweenService:Create(kp,TI.SwordSummon,{CFrame = summonCF})
		local kpThrow = TweenService:Create(kp,TI.SwordFlight,{CFrame = summonCF + (summonCF.UpVector * Novus.Variables.SwordRange)})
		kp.CFrame = beginCF
		local summonSound = Novus.Global.AudioFolderReference.SwordSummon:Clone()
		summonSound.Parent = kp
		local throwSound = Novus.Global.AudioFolderReference.SwordThrow:Clone()
		throwSound.Parent = kp
		kpVisible:Play()
		kpSummon:Play()
		summonSound:Play()
		task.spawn(function()
			while kpThrow.PlaybackState ~= Enum.PlaybackState.Completed do
				Novus.Global.doDamageWithPart(kp.Hitbox,Novus.Variables.throwDamage,Novus.Variables.throwDecayDamage)
				task.wait(0.025)
			end
		end)
		kpSummon.Completed:Wait()
		task.wait(0.25)
		kpThrow:Play()
		throwSound:Play()
		kpThrow.Completed:Wait()
		kp:Destroy()
	elseif swordType == "Blue" then
		local kp = Novus.Global.ModelFolderReference.BlueKatanaMediumProjectile:Clone()
		kp.Parent = workspace
		summonCF = summonCF + (summonCF.RightVector * (sideOffset * 5)) + (summonCF.LookVector * 2)
		summonCF = CFrame.lookAt(summonCF.Position,targetCF.Position)
		summonCF = summonCF * kp.PivotOffset.Rotation
		local beginCF = summonCF + (summonCF.RightVector * -8)
		beginCF = beginCF * CFrame.Angles(math.rad(math.random(0,360)),math.rad(math.random(0,360)),math.rad(math.random(0,360)))
		local kpVisible = TweenService:Create(kp,TI.SwordVisible,{Transparency = 0})
		local kpSummon = TweenService:Create(kp,TI.SwordSummon,{CFrame = summonCF})
		local kpThrow = TweenService:Create(kp,TI.SwordFlight,{CFrame = summonCF + (summonCF.LookVector * -Novus.Variables.SwordRange)})
		kp.CFrame = beginCF
		local summonSound = Novus.Global.AudioFolderReference.SwordSummon:Clone()
		summonSound.Parent = kp
		local throwSound = Novus.Global.AudioFolderReference.SwordThrow:Clone()
		throwSound.Parent = kp
		kpVisible:Play()
		kpSummon:Play()
		summonSound:Play()
		task.spawn(function()
			while kpThrow.PlaybackState ~= Enum.PlaybackState.Completed do
				Novus.Global.doDamageWithPart(kp.Hitbox,Novus.Variables.throwDamage,Novus.Variables.throwDecayDamage,true)
				task.wait(0.025)
			end
		end)
		kpSummon.Completed:Wait()
		task.wait(0.25)
		kpThrow:Play()
		throwSound:Play()
		kpThrow.Completed:Wait()
		kp:Destroy()
	end
end
function Novus.Global.Swords.summonKatanaZoneGlobal(cameraOrigin:CFrame,targetRay:Ray,zoneType:string)
	local dV = Novus.Variables
	local TI = Novus.Global.Swords.TweeningInfo
	local rtParams = RaycastParams.new()
	local blTable = {}
	for k,v in pairs(workspace:GetDescendants()) do
		if v:IsA("BasePart") then
			if v.Transparency == 1 then
				table.insert(blTable,v)
			elseif v.Parent:FindFirstChild("Humanoid") then
				table.insert(blTable,v)
			end
		end
	end
	rtParams.FilterType = Enum.RaycastFilterType.Blacklist
	rtParams.IgnoreWater = true
	rtParams.RespectCanCollide = true
	rtParams.FilterDescendantsInstances = blTable
	local rtResult = workspace:Raycast(cameraOrigin.Position,targetRay.Direction*dV.SwordRange,rtParams)
	if zoneType == "Normal" then
		if rtResult ~= nil then
			local targetCF = CFrame.new(rtResult.Position)
			local normal = rtResult.Normal
			local kz = Novus.Global.ModelFolderReference.KatanaZone:Clone()
			kz.Parent = workspace
			kz.PrimaryPart.CFrame = targetCF
			if normal ~= Vector3.new(0,1,0) then
				local LACF = targetCF + (normal * 1)
				kz.PrimaryPart.CFrame = CFrame.lookAt(kz.PrimaryPart.CFrame.Position,LACF.Position)
				kz.PrimaryPart.CFrame *= CFrame.fromEulerAnglesXYZ(math.rad(-90),0,0)
			end
			kz.PrimaryPart.CFrame = kz.PrimaryPart.CFrame + (kz.PrimaryPart.CFrame.UpVector * -8.2)
			local kzShallowClone = kz:Clone()
			for i,v in pairs(kzShallowClone:GetChildren()) do
				v.Transparency = 1
				v.CanTouch = false
			end
			kzShallowClone.PrimaryPart.CFrame = kz.PrimaryPart.CFrame + kz.PrimaryPart.CFrame.UpVector * 9.75
			local cf, size = kzShallowClone:GetBoundingBox()
			local kzWBase = Instance.new("Part")
			kzWBase.Transparency = 1
			kzWBase.Size = size
			kzWBase.Parent = workspace
			kzWBase.CFrame = cf
			kzWBase.CanQuery = false
			kzWBase.CanCollide = false
			kzWBase.CanTouch = false
			kzWBase.Anchored = true
			kzShallowClone:Destroy()
			local warnSound = Novus.Global.AudioFolderReference.ZoneWarn:Clone()
			warnSound.Parent = kzWBase
			local raiseSound = Novus.Global.AudioFolderReference.ZoneRise:Clone()
			raiseSound.Parent = kz.PrimaryPart
			local kzWarner = Instance.new("SelectionBox")
			kzWarner.Parent = kzWBase
			kzWarner.Adornee = kzWBase
			kzWarner.Color3 = Color3.new(1,0,0)
			local riseParams = {
				CFrame = kz.PrimaryPart.CFrame + kz.PrimaryPart.CFrame.UpVector * 10.5
			}
			riseParams.CFrame = riseParams.CFrame
			local kzRise = TweenService:Create(kz.PrimaryPart,TI.ZoneRaise,riseParams)
			local kzLower = TweenService:Create(kz.PrimaryPart,TI.ZoneRaise,{CFrame = kz.PrimaryPart.CFrame})
			warnSound:Play()
			task.spawn(function()
				local notRising = true
				while notRising do
					if kzWarner.Color3 == Color3.new(1,0,0) then
						kzWarner.Color3 = Color3.new(1,1,0)
						task.wait(0.075)
					elseif kzWarner.Color3 == Color3.new(1,1,0) then
						kzWarner.Color3 = Color3.new(1,0,0)
						task.wait(0.075)
					end
				end
			end)
			task.wait(0.5)
			task.spawn(function()
				while kzLower.PlaybackState ~= Enum.PlaybackState.Playing do
					Novus.Global.doDamageWithZone(cf,size,dV.zoneDamage,dV.zoneDecayDamage)
					task.wait(0.025)
				end
			end)
			kzWarner:Destroy()
			kzWBase:Destroy()
			raiseSound:Play()
			kzRise:Play()
			task.wait(1.5)
			kzLower:Play()
			kzLower.Completed:Wait()
			kz:Destroy()
		end
	elseif zoneType == "Blue" then
		if rtResult ~= nil then
			local targetCF = CFrame.new(rtResult.Position)
			local normal = rtResult.Normal
			local kz = Novus.Global.ModelFolderReference.BlueKatanaZone:Clone()
			kz.Parent = workspace
			kz.PrimaryPart.CFrame = targetCF * kz.PrimaryPart.PivotOffset.Rotation
			if normal ~= Vector3.new(0,1,0) then
				local LACF = targetCF + (normal * 1)
				kz.PrimaryPart.CFrame = CFrame.lookAt(kz.PrimaryPart.CFrame.Position,LACF.Position) * kz.PrimaryPart.PivotOffset.Rotation
				kz.PrimaryPart.CFrame *= CFrame.fromEulerAnglesXYZ(0,math.rad(-90),0)
			end
			kz.PrimaryPart.CFrame = kz.PrimaryPart.CFrame + (kz.PrimaryPart.CFrame.ZVector * -8.2)
			local kzShallowClone = kz:Clone()
			for i,v in pairs(kzShallowClone:GetChildren()) do
				v.Transparency = 1
				v.CanTouch = false
			end
			kzShallowClone.PrimaryPart.CFrame += kzShallowClone.PrimaryPart.CFrame.ZVector * 9.75
			local cf, size = kzShallowClone:GetBoundingBox()
			local kzWBase = Instance.new("Part")
			kzWBase.Transparency = 1
			kzWBase.Size = size
			kzWBase.Parent = workspace
			kzWBase.CFrame = cf
			kzWBase.CanQuery = false
			kzWBase.CanCollide = false
			kzWBase.CanTouch = false
			kzWBase.Anchored = true
			kzShallowClone:Destroy()
			local warnSound = Novus.Global.AudioFolderReference.ZoneWarn:Clone()
			warnSound.Parent = kzWBase
			local raiseSound = Novus.Global.AudioFolderReference.ZoneRise:Clone()
			raiseSound.Parent = kz.PrimaryPart
			local kzWarner = Instance.new("SelectionBox")
			kzWarner.Parent = kzWBase
			kzWarner.Adornee = kzWBase
			kzWarner.Color3 = Color3.new(1,0,0)
			local riseParams = {
				CFrame = kz.PrimaryPart.CFrame + (kz.PrimaryPart.CFrame.ZVector * 10.5)
			}
			local kzRise = TweenService:Create(kz.PrimaryPart,TI.ZoneRaise,riseParams)
			local kzLower = TweenService:Create(kz.PrimaryPart,TI.ZoneRaise,{CFrame = kz.PrimaryPart.CFrame})
			warnSound:Play()
			task.spawn(function()
				local notRising = true
				while notRising do
					if kzWarner.Color3 == Color3.new(1,0,0) then
						kzWarner.Color3 = Color3.new(1,1,0)
						task.wait(0.075)
					elseif kzWarner.Color3 == Color3.new(1,1,0) then
						kzWarner.Color3 = Color3.new(1,0,0)
						task.wait(0.075)
					end
				end
			end)
			task.wait(0.5)
			local hmTbl = {}
			local connectionTbl = {}
			for i,v in pairs(kz:GetChildren()) do
				local c = v.Touched:Connect(function(part)
					if part:IsA("BasePart") and part.Name ~= "BlueKatanaMedium" and part ~= kz.PrimaryPart and part ~= v then
						if part.Parent:FindFirstChild("Humanoid") ~= nil then
							if part.Parent.Humanoid.Health ~= 0 and part.Parent ~= Novus.Global.UserPlayer.Character and hmTbl[part.Parent] == nil then
								hmTbl[part.Parent] = {part.Parent.Humanoid,part.Parent.Humanoid.WalkSpeed,part.Parent.Humanoid.JumpPower}
								part.Parent.Humanoid.WalkSpeed = 0
								part.Parent.Humanoid.JumpPower = 0
							end
						end
					end
				end)
				table.insert(connectionTbl,c)
			end
			kzWarner:Destroy()
			kzWBase:Destroy()
			raiseSound:Play()
			kzRise:Play()
			task.wait(1.5)
			for k,v in pairs(connectionTbl) do
				v:Disconnect()
			end
			for k,v in pairs(hmTbl) do
				v[1].WalkSpeed = v[2]
				v[1].JumpPower = v[3]
				--v[1].Parent.HumanoidRootPart.Anchored = false
			end
			kzLower:Play()
			kzLower.Completed:Wait()
			kz:Destroy()
		end
	elseif zoneType == "NormalLarge" then
		if rtResult ~= nil then
			local targetCF = CFrame.new(rtResult.Position)
			local normal = rtResult.Normal
			local kz = Novus.Global.ModelFolderReference.LargeKatanaZone:Clone()
			kz.Parent = workspace
			kz.PrimaryPart.CFrame = targetCF
			if normal ~= Vector3.new(0,1,0) then
				local LACF = targetCF + (normal * 1)
				kz.PrimaryPart.CFrame = CFrame.lookAt(kz.PrimaryPart.CFrame.Position,LACF.Position)
				kz.PrimaryPart.CFrame *= CFrame.fromEulerAnglesXYZ(math.rad(-90),0,0)
			end
			kz.PrimaryPart.CFrame = kz.PrimaryPart.CFrame + (kz.PrimaryPart.CFrame.UpVector * -8.16)
			local kzShallowClone = kz:Clone()
			for i,v in pairs(kzShallowClone:GetChildren()) do
				v.Transparency = 1
				v.CanTouch = false
			end
			kzShallowClone.PrimaryPart.CFrame = kz.PrimaryPart.CFrame + kz.PrimaryPart.CFrame.UpVector * 11
			local cf, size = kzShallowClone:GetBoundingBox()
			local kzWBase = Instance.new("Part")
			kzWBase.Transparency = 1
			kzWBase.Size = size
			kzWBase.Parent = workspace
			kzWBase.CFrame = cf
			kzWBase.CanQuery = false
			kzWBase.CanCollide = false
			kzWBase.CanTouch = false
			kzWBase.Anchored = true
			kzShallowClone:Destroy()
			local warnSound = Novus.Global.AudioFolderReference.ZoneWarn:Clone()
			warnSound.Parent = kzWBase
			local raiseSound = Novus.Global.AudioFolderReference.ZoneRise:Clone()
			raiseSound.Parent = kz.PrimaryPart
			local kzWarner = Instance.new("SelectionBox")
			kzWarner.Parent = kzWBase
			kzWarner.Adornee = kzWBase
			kzWarner.Color3 = Color3.new(1,0,0)
			local riseParams = {
				CFrame = kz.PrimaryPart.CFrame + kz.PrimaryPart.CFrame.UpVector * 12
			}
			local kzRise = TweenService:Create(kz.PrimaryPart,TI.ZoneRaise,riseParams)
			local kzLower = TweenService:Create(kz.PrimaryPart,TI.ZoneRaise,{CFrame = kz.PrimaryPart.CFrame})
			warnSound:Play()
			task.spawn(function()
				local notRising = true
				while notRising do
					if kzWarner.Color3 == Color3.new(1,0,0) then
						kzWarner.Color3 = Color3.new(1,1,0)
						task.wait(0.075)
					elseif kzWarner.Color3 == Color3.new(1,1,0) then
						kzWarner.Color3 = Color3.new(1,0,0)
						task.wait(0.075)
					end
				end
			end)
			task.wait(0.5)
			task.spawn(function()
				while kzLower.PlaybackState ~= Enum.PlaybackState.Playing do
					Novus.Global.doDamageWithZone(cf,size,dV.zoneDamage,dV.zoneDecayDamage)
					task.wait(0.025)
				end
			end)
			kzWarner:Destroy()
			kzWBase:Destroy()
			raiseSound:Play()
			kzRise:Play()
			task.wait(1.5)
			kzLower:Play()
			kzLower.Completed:Wait()
			kz:Destroy()
		end
	elseif zoneType == "BlueLarge" then
		if rtResult ~= nil then
			local targetCF = CFrame.new(rtResult.Position)
			local normal = rtResult.Normal
			local kz = Novus.Global.ModelFolderReference.BlueKatanaZoneLarge:Clone()
			kz.Parent = workspace
			kz.PrimaryPart.CFrame = targetCF * kz.PrimaryPart.PivotOffset
			if normal ~= Vector3.new(0,1,0) then
				local LACF = targetCF + (normal * 1)
				kz.PrimaryPart.CFrame = CFrame.lookAt(kz.PrimaryPart.CFrame.Position,LACF.Position) * kz.PrimaryPart.PivotOffset.Rotation
				kz.PrimaryPart.CFrame *= CFrame.fromEulerAnglesXYZ(0,math.rad(-90),0)
			end
			kz.PrimaryPart.CFrame = kz.PrimaryPart.CFrame + (kz.PrimaryPart.CFrame.ZVector * -8.5)
			local kzShallowClone = kz:Clone()
			for i,v in pairs(kzShallowClone:GetChildren()) do
				v.Transparency = 1
				v.CanTouch = false
			end
			kzShallowClone.PrimaryPart.CFrame += kzShallowClone.PrimaryPart.CFrame.ZVector * 10.7
			local cf, size = kzShallowClone:GetBoundingBox()
			local kzWBase = Instance.new("Part")
			kzWBase.Transparency = 1
			kzWBase.Size = size
			kzWBase.Parent = workspace
			kzWBase.CFrame = cf
			kzWBase.CanQuery = false
			kzWBase.CanCollide = false
			kzWBase.CanTouch = false
			kzWBase.Anchored = true
			kzShallowClone:Destroy()
			local warnSound = Novus.Global.AudioFolderReference.ZoneWarn:Clone()
			warnSound.Parent = kzWBase
			local raiseSound = Novus.Global.AudioFolderReference.ZoneRise:Clone()
			raiseSound.Parent = kz.PrimaryPart
			local kzWarner = Instance.new("SelectionBox")
			kzWarner.Parent = kzWBase
			kzWarner.Adornee = kzWBase
			kzWarner.Color3 = Color3.new(1,0,0)
			local riseParams = {
				CFrame = kz.PrimaryPart.CFrame + (kz.PrimaryPart.CFrame.ZVector * 12.7)
			}
			local kzRise = TweenService:Create(kz.PrimaryPart,TI.ZoneRaise,riseParams)
			local kzLower = TweenService:Create(kz.PrimaryPart,TI.ZoneRaise,{CFrame = kz.PrimaryPart.CFrame})
			warnSound:Play()
			task.spawn(function()
				local notRising = true
				while notRising do
					if kzWarner.Color3 == Color3.new(1,0,0) then
						kzWarner.Color3 = Color3.new(1,1,0)
						task.wait(0.075)
					elseif kzWarner.Color3 == Color3.new(1,1,0) then
						kzWarner.Color3 = Color3.new(1,0,0)
						task.wait(0.075)
					end
				end
			end)
			task.wait(0.5)
			local hmTbl = {}
			local connectionTbl = {}
			for i,v in pairs(kz:GetChildren()) do
				local c = v.Touched:Connect(function(part)
					if part:IsA("BasePart") and part.Name ~= "BlueKatanaLarge" and part ~= kz.PrimaryPart and part ~= v then
						if part.Parent:FindFirstChild("Humanoid") ~= nil then
							if part.Parent.Humanoid.Health ~= 0 and part.Parent ~= Novus.Global.UserPlayer.Character and hmTbl[part.Parent] == nil then
								hmTbl[part.Parent] = {part.Parent.Humanoid,part.Parent.Humanoid.WalkSpeed,part.Parent.Humanoid.JumpPower}
								part.Parent.Humanoid.WalkSpeed = 0
								part.Parent.Humanoid.JumpPower = 0
							end
						end
					end
				end)
				table.insert(connectionTbl,c)
			end
			kzWarner:Destroy()
			kzWBase:Destroy()
			raiseSound:Play()
			kzRise:Play()
			task.wait(1.5)
			for k,v in pairs(connectionTbl) do
				v:Disconnect()
			end
			for k,v in pairs(hmTbl) do
				v[1].WalkSpeed = v[2]
				v[1].JumpPower = v[3]
				--v[1].Parent.HumanoidRootPart.Anchored = false
			end
			kzLower:Play()
			kzLower.Completed:Wait()
			kz:Destroy()
		end
	else
		return false,warn("Invalid zone type (argument #3 has an invalid value).")
	end
end
function Novus.Global.Force.flashForceEye(plr:Player,timelen:number)
	if plr.UserId == 110154940 then
		local fe
		local cv1
		local cv2
		for i,v in pairs(Novus.Global.ModelFolderReference.CustomForceEyes:GetChildren()) do
			if v:GetAttribute("UserId") == 110154940 then
				fe = v
			end
		end
		cv1 = fe.Color1.Value
		cv2 = fe.Color2.Value
		local rFE:Part = fe:Clone()
		rFE.Parent = plr.Character.PrimaryPart
		local rw = Instance.new("WeldConstraint")
		rw.Parent = rFE
		rFE.CFrame = plr.Character.PrimaryPart.CFrame * rFE.PivotOffset
		rFE.CFrame += (rFE.CFrame.UpVector * 0.1) + (rFE.CFrame.RightVector * 0.605) + (rFE.CFrame.LookVector * 0.225)
		rw.Part0 = rFE
		rw.Part1 = plr.Character.PrimaryPart
		rw.Enabled = true
		local fi = rFE:Clone()
		fi.Parent = rFE.Parent
		fi.Transparency = 0.4
		local indTween = TweenService:Create(fi,Novus.Global.Force.TweeningInfo.FEIndicate,{["Size"] = Vector3.new(fi.Size.X*15,fi.Size.Y*15,fi.Size.Z*15), ["Transparency"] = 1})
		indTween:Play()
		task.spawn(function()
			indTween.Completed:Once(function()
				fi:Destroy()
			end)
		end)
		local ft = false
		task.spawn(function()
			while ft == false and rFE ~= nil do
				rFE.Color = cv2
				task.wait(0.1)
				rFE.Color = cv1
				task.wait(0.1)
			end
		end)
		task.wait(timelen)
		ft = true
		rFE:Destroy()
	end
end
function Novus.Global.Force.showForceEye(plr:Player,remove:boolean,color1:Color3,color2:Color3,alternate:boolean)
	if plr.UserId == 110154940 then
		if remove then
			plr.Character.PrimaryPart:FindFirstChild("ForceEye"):Destroy()
			plr.Character.PrimaryPart:FindFirstChild("ForceSound"):Destroy()
			return true
		end
		local fs = Novus.Global.AudioFolderReference.ForceSound:Clone()
		local fe
		local cv1
		local cv2
		for i,v in pairs(Novus.Global.ModelFolderReference.CustomForceEyes:GetChildren()) do
			if v:GetAttribute("UserId") == 110154940 then
				fe = v
			end
		end
		cv1 = color1
		cv2 = color2
		local rFE:Part = fe:Clone()
		rFE.Parent = plr.Character.PrimaryPart
		local rw = Instance.new("WeldConstraint")
		rw.Parent = rFE
		rFE.CFrame = plr.Character.PrimaryPart.CFrame * rFE.PivotOffset
		rFE.CFrame += (rFE.CFrame.UpVector * 0.1) + (rFE.CFrame.RightVector * 0.605) + (rFE.CFrame.LookVector * 0.225)
		rw.Part0 = rFE
		rw.Part1 = plr.Character.PrimaryPart
		rw.Enabled = true
		rFE.Color = color1
		rFE.Beam1.Color = ColorSequence.new(color1)
		if not alternate then
			rFE.Beam2.Color = ColorSequence.new(color1)
			rFE.Trail.Color = ColorSequence.new(color1)
		else
			rFE.Beam2.Color = ColorSequence.new(color2)
			rFE.Trail.Color = ColorSequence.new(color1,color2)
		end
		fs.Parent = plr.Character.PrimaryPart
		fs:Play()
		local fi = rFE:Clone()
		fi.Parent = rFE.Parent
		fi.Transparency = 0.4
		local indTween = TweenService:Create(fi,Novus.Global.Force.TweeningInfo.FEIndicate,{["Size"] = Vector3.new(fi.Size.X*15,fi.Size.Y*15,fi.Size.Z*15), ["Transparency"] = 1})
		indTween:Play()
		task.spawn(function()
			indTween.Completed:Once(function()
				fi:Destroy()
			end)
		end)
		if alternate then
			task.spawn(function()
				while rFE.Parent ~= nil and rFE ~= nil do
					rFE.Color = cv2
					task.wait(0.1)
					rFE.Color = cv1
					task.wait(0.1)
				end
			end)
		end
	end
end
function Novus.Global.Force.forcePushDirectional(plr:Player,hm:Humanoid,mousePos:CFrame)
	if plr ~= Novus.Global.UserPlayer then
		plr:Kick("Illegal remote access detected (fired a remote which is not permitted to be used by other players).")
		return false
	end
	local TI = Novus.Global.Force.TweeningInfo
	local dV = Novus.Variables
	local cs = hm.Parent:FindFirstChild("CoilSoul")
	local fs = plr.Character.Head:FindFirstChild("ForceSound")
	local sconn = fs.Played:Connect(function()
		Novus.Global.Force.flashForceEye(plr,fs.TimeLength*2)
	end)
	local animator = Instance.new("Animator")
	animator.Parent = plr.Character.Humanoid
	local aniTrack:AnimationTrack = animator:LoadAnimation(dV.forcePushAnim)
	local hmPointCF = CFrame.lookAt(hm.RootPart.CFrame.Position,mousePos.Position)
	local initPointerCF = hmPointCF + hmPointCF.LookVector * -1
	hmPointCF = CFrame.lookAt(hmPointCF.Position,initPointerCF.Position)
	local ifHitParams = RaycastParams.new()
	ifHitParams.FilterType = Enum.RaycastFilterType.Blacklist
	local blTbl = {}
	for i,v in pairs(workspace:GetDescendants()) do
		if v.Parent:FindFirstChild("Humanoid") ~= nil then
			table.insert(blTbl,v)
		end
	end
	ifHitParams.FilterDescendantsInstances = blTbl
	local ifHit = workspace:Raycast(hm.RootPart.CFrame.Position,hmPointCF.LookVector*-dV.forcePushRange,ifHitParams)
	if ifHit == nil then
		local cs2
		for i,v in pairs(hm.Parent:GetChildren()) do
			if v.Name == "CoilSoul" then
				cs2 = v
			end
		end
		local csIndicate = cs2:Clone()
		csIndicate.Parent = hm.RootPart
		csIndicate.Anchored = true
		local forceTween = TweenService:Create(hm.RootPart,TI.ForcePushOrPull,{CFrame = hmPointCF + hmPointCF.LookVector*-dV.forcePushRange})
		local indicateCF = TweenService:Create(csIndicate.Mesh,TI.SoulChangeIndicate,{Scale = Vector3.new(csIndicate.Mesh.Scale.X*2,csIndicate.Mesh.Scale.Y*2,csIndicate.Mesh.Scale.Z*2)})
		local fadeCF = TweenService:Create(csIndicate,TI.SoulChangeIndicate,{Transparency = 1})
		aniTrack:Play(0,1,1)
		fs:Play()
		indicateCF:Play()
		fadeCF:Play()
		task.spawn(function()
			aniTrack.Stopped:Wait()
			aniTrack:Stop(0.5)
		end)
		task.spawn(function()
			indicateCF.Completed:Wait()
			csIndicate:Destroy()
		end)
		forceTween:Play()
		forceTween.Completed:Wait()
		task.wait(0.25)
		cs.Mesh.TextureId = cs.Free.Value
		local ind2 = cs:Clone()
		ind2.Parent = hm.RootPart
		ind2.Anchored = true
		local indCF2 = TweenService:Create(ind2.Mesh,TI.SoulChangeIndicate,{Scale = Vector3.new(ind2.Mesh.Scale.X*2,ind2.Mesh.Scale.Y*2,ind2.Mesh.Scale.Z*2)})
		local indFade = TweenService:Create(ind2,TI.SoulChangeIndicate,{Transparency = 1})
		local csFade = TweenService:Create(cs,TI.SoulChangeIndicate,{Transparency = 1})
		hm:ChangeState(Enum.HumanoidStateType.Freefall)
		hm.RootPart.Anchored = false
		fs:Play()
		indCF2:Play()
		indFade:Play()
		task.spawn(function()
			indCF2.Completed:Wait()
			ind2:Destroy()
			csFade:Play()
		end)
		csFade.Completed:Wait()
		sconn:Disconnect()
		cs:Destroy()
		fs:Destroy()
		aniTrack:Destroy()
	elseif ifHit then
		local cs2 = hm.Parent:FindFirstChild("CoilSoul")
		local dist = ifHit.Distance
		local iniRange = dist/2
		local tDelta = iniRange/275
		local pointerCF = CFrame.new(ifHit.Position) + ifHit.Normal * 5
		local finalHMCF = CFrame.lookAt(ifHit.Position,pointerCF.Position)
		finalHMCF += finalHMCF.LookVector * 0.5
		local initHMCF = hmPointCF + hmPointCF.LookVector * -iniRange
		local init = {
			CFrame = initHMCF
		}
		local final = {
			CFrame = finalHMCF
		}
		local ForcePushDirectExp = TweenInfo.new(
			tDelta,
			Enum.EasingStyle.Linear,
			Enum.EasingDirection.In,
			0,
			false,
			0
		)
		local csIndicate = cs2:Clone()
		csIndicate.Parent = hm.RootPart
		csIndicate.Anchored = true
		local indicateCF = TweenService:Create(csIndicate.Mesh,TI.SoulChangeIndicate,{Scale = Vector3.new(csIndicate.Mesh.Scale.X*2,csIndicate.Mesh.Scale.Y*2,csIndicate.Mesh.Scale.Z*2)})
		local fadeCF = TweenService:Create(csIndicate,TI.SoulChangeIndicate,{Transparency = 1})
		local initForce = TweenService:Create(hm.RootPart,ForcePushDirectExp,init)
		local finalForce = TweenService:Create(hm.RootPart,ForcePushDirectExp,final)
		aniTrack:Play(0,1,0.75)
		fs:Play()
		indicateCF:Play()
		fadeCF:Play()
		initForce:Play()
		task.spawn(function()
			aniTrack.Stopped:Wait()
			aniTrack:Stop(1)
		end)
		task.spawn(function()
			indicateCF.Completed:Wait()
			csIndicate:Destroy()
		end)
		initForce.Completed:Wait()
		finalForce:Play()
		local hitSound = Novus.Global.AudioFolderReference.WallHit:Clone()
		hitSound.Parent = hm.RootPart
		finalForce.Completed:Wait()
		hitSound:Play()
		Novus.Global.doDamageToHumanoid(hm,dV.forceSlamDamage,false,dV.forceSlamDecayDamage)
		task.wait(0.5)
		cs.Mesh.TextureId = cs.Free.Value
		local ind2 = cs:Clone()
		ind2.Parent = hm.RootPart
		ind2.Anchored = true
		local indCF2 = TweenService:Create(ind2.Mesh,TI.SoulChangeIndicate,{Scale = Vector3.new(ind2.Mesh.Scale.X*2,ind2.Mesh.Scale.Y*2,ind2.Mesh.Scale.Z*2)})
		local indFade = TweenService:Create(ind2,TI.SoulChangeIndicate,{Transparency = 1})
		local csFade = TweenService:Create(cs,TI.SoulChangeIndicate,{Transparency = 1})
		hm:ChangeState(Enum.HumanoidStateType.FallingDown)
		hm.RootPart.Anchored = false
		fs:Play()
		indCF2:Play()
		indFade:Play()
		task.spawn(function()
			indCF2.Completed:Wait()
			ind2:Destroy()
			csFade:Play()
		end)
		csFade.Completed:Wait()
		sconn:Disconnect()
		cs:Destroy()
		fs:Destroy()
		aniTrack:Destroy()
	end
end
function Novus.Global.Force.forceHold(plr:Player,Target:BasePart,CFRemote:RemoteEvent)
	local TI = Novus.Global.Force.TweeningInfo
	local dV = Novus.Variables
	if Target ~= nil then
		if Target.Parent:FindFirstChild("Humanoid") ~= nil then
			if (plr.Character.HumanoidRootPart.Position-Target.Parent.HumanoidRootPart.Position).Magnitude <= dV.forceEffectRange then
				local isFired = false
				local cs = Novus.Global.ModelFolderReference.CoilSoul:Clone()
				cs.Parent = Target.Parent
				cs.CFrame = Target.Parent.HumanoidRootPart.CFrame
				cs.CFrame += (cs.CFrame.RightVector * -3) + (cs.CFrame.UpVector * 1.75)
				local csw = Instance.new("WeldConstraint")
				csw.Parent = Target.Parent.HumanoidRootPart
				csw.Name = "CSWeld"
				csw.Part0 = Target.Parent.HumanoidRootPart
				csw.Part1 = cs
				cs.Anchored = false
				local scSound = Novus.Global.AudioFolderReference.ForceSound:Clone()
				scSound.Parent = plr.Character.Head
				local sconn = scSound.Played:Connect(function()
					Novus.Global.Force.flashForceEye(plr,scSound.TimeLength*2)
				end)
				local animator = Instance.new("Animator")
				animator.Parent = plr.Character.Humanoid
				local aniTrack:AnimationTrack = animator:LoadAnimation(dV.forceHoldAnim)
				aniTrack.Priority = Enum.AnimationPriority.Action4
				cs.Mesh.TextureId = cs.Grav.Value
				local csIndicate = cs:Clone()
				csIndicate.Parent = Target.Parent.HumanoidRootPart
				csIndicate.Anchored = true
				local HoldTween = TweenService:Create(Target.Parent.HumanoidRootPart,TI.SoulChangeIndicate,{CFrame = Target.Parent.HumanoidRootPart.CFrame + Target.Parent.HumanoidRootPart.CFrame.UpVector * 3})
				local indicateCF = TweenService:Create(csIndicate.Mesh,TI.SoulChangeIndicate,{Scale = Vector3.new(csIndicate.Mesh.Scale.X*2,csIndicate.Mesh.Scale.Y*2,csIndicate.Mesh.Scale.Z*2)})
				local fadeCF = TweenService:Create(csIndicate,TI.SoulChangeIndicate,{Transparency = 1})
				Target.Parent.Humanoid:UnequipTools()
				Target.Parent.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
				Target.Parent.HumanoidRootPart.Anchored = true
				aniTrack:Play(0,1,0.5)
				task.spawn(function()
					aniTrack.Stopped:Wait()
					aniTrack:AdjustSpeed(0)
				end)
				scSound:Play()
				HoldTween:Play()
				indicateCF:Play()
				fadeCF:Play()
				task.spawn(function()
					indicateCF.Completed:Wait()
					csIndicate:Destroy()
				end)
				HoldTween.Completed:Wait()
				local OscTween = TweenService:Create(Target.Parent.HumanoidRootPart,TI.SoulOscillate,{CFrame = Target.Parent.HumanoidRootPart.CFrame + Target.Parent.HumanoidRootPart.CFrame.UpVector * -1})
				OscTween:Play()
				local conn = CFRemote.OnServerEvent:Once(function (plr,mousePos)
					if OscTween.PlaybackState == Enum.PlaybackState.Completed then
						return false
					end
					isFired = true
					OscTween:Cancel()
					aniTrack.Priority = Enum.AnimationPriority.Action3
					aniTrack:Destroy()
					Novus.Global.Force.forcePushDirectional(plr,Target.Parent.Humanoid,mousePos)
					sconn:Disconnect()
				end)
				CFRemote:FireClient(plr,true)
				OscTween:GetPropertyChangedSignal("PlaybackState"):Wait()
				if OscTween.PlaybackState == Enum.PlaybackState.Completed then
					if isFired == false then
						conn:Disconnect()
						cs.Mesh.TextureId = cs.Free.Value
						local ind2 = cs:Clone()
						ind2.Parent = Target.Parent.HumanoidRootPart
						ind2.Anchored = true
						local indCF2 = TweenService:Create(ind2.Mesh,TI.SoulChangeIndicate,{Scale = Vector3.new(ind2.Mesh.Scale.X*2,ind2.Mesh.Scale.Y*2,ind2.Mesh.Scale.Z*2)})
						local indFade = TweenService:Create(ind2,TI.SoulChangeIndicate,{Transparency = 1})
						local csFade = TweenService:Create(cs,TI.SoulChangeIndicate,{Transparency = 1})
						Target.Parent.Humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
						Target.Parent.HumanoidRootPart.Anchored = false
						aniTrack:AdjustSpeed(-0.5)
						scSound:Play()
						indCF2:Play()
						indFade:Play()
						task.spawn(function()
							indCF2.Completed:Wait()
							ind2:Destroy()
							csFade:Play()
						end)
						csFade.Completed:Wait()
						cs:Destroy()
						sconn:Disconnect()
						scSound:Destroy()
						aniTrack.Ended:Wait()
						aniTrack:Destroy()
					end
				else
					return false,"Target out of range"
				end
			end
		end
	end
end
function Novus.Global.Force.ForceSlam(plr,Target:BasePart)
	local TI = Novus.Global.Force.TweeningInfo
	local dV = Novus.Variables
	if Target ~= nil then
		if Target:FindFirstAncestorWhichIsA("Model"):FindFirstChild("Humanoid") ~= nil then
			if (plr.Character.HumanoidRootPart.Position-Target:FindFirstAncestorWhichIsA("Model").HumanoidRootPart.Position).Magnitude <= dV.forceEffectRange then
				local animator = Instance.new("Animator")
				animator.Parent = plr.Character.Humanoid
				local aniTrack:AnimationTrack = animator:LoadAnimation(dV.forceSlamAnim)
				local isFired = false
				local cs = Novus.Global.ModelFolderReference.CoilSoul:Clone()
				local charModel = Target:FindFirstAncestorWhichIsA("Model")
				cs.Parent = charModel
				cs.CFrame = charModel.HumanoidRootPart.CFrame
				cs.CFrame += (cs.CFrame.RightVector * -3) + (cs.CFrame.UpVector * 1.75)
				local csw = Instance.new("WeldConstraint")
				csw.Parent = charModel.HumanoidRootPart
				csw.Name = "CSWeld"
				csw.Part0 = charModel.HumanoidRootPart
				csw.Part1 = cs
				cs.Anchored = false
				local scSound = Novus.Global.AudioFolderReference.ForceSound:Clone()
				scSound.Parent = plr.Character.Head
				local sconn = scSound.Played:Connect(function()
					Novus.Global.Force.flashForceEye(plr,scSound.TimeLength*2)
				end)
				cs.Mesh.TextureId = cs.Grav.Value
				local csIndicate = cs:Clone()
				csIndicate.Parent = charModel.HumanoidRootPart
				csIndicate.Anchored = true
				local ForcePushOrPullExp = TweenInfo.new(
					1,
					Enum.EasingStyle.Sine,
					Enum.EasingDirection.Out,
					0,
					false,
					0
				)
				local HoldTween = TweenService:Create(charModel.HumanoidRootPart,ForcePushOrPullExp,{CFrame = charModel.HumanoidRootPart.CFrame + charModel.HumanoidRootPart.CFrame.UpVector * 20})
				local indicateCF = TweenService:Create(csIndicate.Mesh,TI.SoulChangeIndicate,{Scale = Vector3.new(csIndicate.Mesh.Scale.X*2,csIndicate.Mesh.Scale.Y*2,csIndicate.Mesh.Scale.Z*2)})
				local fadeCF = TweenService:Create(csIndicate,TI.SoulChangeIndicate,{Transparency = 1})
				charModel.Humanoid:UnequipTools()
				charModel.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
				charModel.HumanoidRootPart.Anchored = true
				scSound:Play()
				aniTrack:Play(0,1,1)
				HoldTween:Play()
				indicateCF:Play()
				fadeCF:Play()
				task.spawn(function()
					indicateCF.Completed:Wait()
					csIndicate:Destroy()
				end)
				HoldTween.Completed:Wait()
				local rtParams = RaycastParams.new()
				local blTable = {}
				for k,v in pairs(workspace:GetDescendants()) do
					if v:IsA("BasePart") then
						if v.Transparency == 1 then
							table.insert(blTable,v)
						elseif v.Parent:FindFirstChild("Humanoid") then
							table.insert(blTable,v)
						end
					end
				end
				rtParams.FilterType = Enum.RaycastFilterType.Blacklist
				rtParams.IgnoreWater = true
				rtParams.RespectCanCollide = true
				rtParams.FilterDescendantsInstances = blTable
				local rt = workspace:Raycast(charModel.HumanoidRootPart.CFrame.Position,charModel.HumanoidRootPart.CFrame.UpVector*-1000,rtParams)
				if rt then
					local ForcePushDirectExp = TweenInfo.new(
						rt.Distance/150,
						Enum.EasingStyle.Sine,
						Enum.EasingDirection.In,
						0,
						false,
						0
					)
					charModel.HumanoidRootPart.CFrame = CFrame.lookAt(charModel.HumanoidRootPart.CFrame.Position,rt.Position)
					charModel.HumanoidRootPart.CFrame *= CFrame.fromAxisAngle(charModel.HumanoidRootPart.CFrame.UpVector,math.rad(180))
					local slamCF = charModel.HumanoidRootPart.CFrame + charModel.HumanoidRootPart.CFrame.LookVector * (-rt.Distance + 0.5)
					local slamTween = TweenService:Create(charModel.HumanoidRootPart,ForcePushDirectExp,{CFrame = slamCF})
					slamTween:Play()
					local hitSound = Novus.Global.AudioFolderReference.WallHit:Clone()
					hitSound.Parent = charModel.HumanoidRootPart
					slamTween.Completed:Wait()
					hitSound:Play()
					Novus.Global.doDamageToHumanoid(charModel.Humanoid,dV.forceHeavySlamDamage,false,dV.forceHeavySlamDecayDamage)
					cs.Mesh.TextureId = cs.Free.Value
					local ind2 = cs:Clone()
					ind2.Parent = charModel.HumanoidRootPart
					ind2.Anchored = true
					local indCF2 = TweenService:Create(ind2.Mesh,TI.SoulChangeIndicate,{Scale = Vector3.new(ind2.Mesh.Scale.X*2,ind2.Mesh.Scale.Y*2,ind2.Mesh.Scale.Z*2)})
					local indFade = TweenService:Create(ind2,TI.SoulChangeIndicate,{Transparency = 1})
					local csFade = TweenService:Create(cs,TI.SoulChangeIndicate,{Transparency = 1})
					scSound:Play()
					indCF2:Play()
					indFade:Play()
					task.spawn(function()
						indCF2.Completed:Wait()
						ind2:Destroy()
						csFade:Play()
					end)
					charModel.HumanoidRootPart.Anchored = false
					task.spawn(function()
						csFade.Completed:Wait()
						cs:Destroy()
					end)
					task.wait(2)
					charModel.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
				elseif rt == nil then
					return false,warn("Downwards raycast failure. Cause unknown.")
				end
			end
		end
	else
		Novus.Global.moveCDTbl["Telekinetic_Slam"][5] = false
		return false,warn("Target out of range.")
	end
end
function Novus.Global.Force.Repulse(plr:Player)
	local TI = Novus.Global.Force.TweeningInfo
	local dV = Novus.Variables
	local charCF = plr.Character.HumanoidRootPart.CFrame
	local OL = OverlapParams.new()
	local hmBlTbl = {}
	local hmTbl = {}
	for i,v in pairs(workspace:GetChildren()) do
		if v:FindFirstChild("Humanoid") == nil or not v.Parent:IsA("Model") or v == plr.Character then
			table.insert(hmBlTbl,v)
		end
	end
	OL.FilterType = Enum.RaycastFilterType.Blacklist
	OL.FilterDescendantsInstances = hmBlTbl
	local partTbl = workspace:GetPartBoundsInRadius(charCF.Position,dV.groupForceEffectRange,OL)
	local rtParams = RaycastParams.new()
	rtParams.FilterType = Enum.RaycastFilterType.Blacklist
	local blTbl = {}
	for i,v in ipairs(game.Workspace:GetDescendants()) do
		if v.Parent:FindFirstChild("Humanoid") ~= nil then
			table.insert(blTbl,v)
		end
	end
	rtParams.FilterDescendantsInstances = blTbl
	local fs = Novus.Global.AudioFolderReference.ForceSound:Clone()
	local sconn = fs.Played:Connect(function()
		Novus.Global.Force.flashForceEye(plr,fs.TimeLength*2)
	end)
	fs.Parent = plr.Character.Head
	fs:Play()
	task.spawn(function()
		task.wait(0.5)
		fs:Play()
	end)
	for i,v in pairs(partTbl) do
		if v.Parent ~= plr.Character and v.Parent:IsA("Model") and table.find(hmTbl,v.Parent) == nil then
			table.insert(hmTbl,v.Parent)
		end
	end
	for i,v in pairs(hmTbl) do
		if v:FindFirstChild("Humanoid") ~= nil and v.Humanoid.Health ~= 0 and v ~= plr.Character then
			task.spawn(function()
				local hmrt = v.HumanoidRootPart
				hmrt.Anchored = true
				hmrt.CFrame = CFrame.lookAt(hmrt.Position,charCF.Position)
				local rt = workspace:Raycast(hmrt.Position,hmrt.CFrame.LookVector*-dV.forcePushRange,rtParams)
				local hmCF = hmrt.CFrame
				local ForcePushAwayExp
				if rt then
					hmCF = CFrame.lookAt(rt.Position,hmrt.Position)
					hmCF += hmCF.LookVector * 1
					ForcePushAwayExp = TweenInfo.new(
						rt.Distance/300,
						Enum.EasingStyle.Linear,
						Enum.EasingDirection.In,
						0,
						false,
						0
					)
				else
					hmCF += hmrt.CFrame.LookVector * -dV.forcePushRange
					ForcePushAwayExp = TweenInfo.new(
						dV.forcePushRange/300,
						Enum.EasingStyle.Linear,
						Enum.EasingDirection.In,
						0,
						false,
						0
					)
				end
				local cs = Novus.Global.ModelFolderReference.CoilSoul:Clone()
				cs.Mesh.TextureId = cs.Grav.Value
				cs.Name = "CoilSoul"
				local charModel = v
				cs.Parent = charModel
				cs.CFrame = charModel.HumanoidRootPart.CFrame
				cs.CFrame += (cs.CFrame.RightVector * -3) + (cs.CFrame.UpVector * 1.75)
				local csw = Instance.new("WeldConstraint")
				csw.Parent = charModel.HumanoidRootPart
				csw.Name = "CSWeld"
				csw.Part0 = charModel.HumanoidRootPart
				csw.Part1 = cs
				cs.Anchored = false
				local csIndicate = cs:Clone()
				csIndicate.Parent = charModel.HumanoidRootPart
				csIndicate.Name = "CSClone"
				csIndicate.Mesh.TextureId = csIndicate.Grav.Value
				csIndicate.Anchored = true
				local indicateCF = TweenService:Create(csIndicate.Mesh,TI.SoulChangeIndicate,{Scale = Vector3.new(csIndicate.Mesh.Scale.X*2,csIndicate.Mesh.Scale.Y*2,csIndicate.Mesh.Scale.Z*2)})
				local fadeCF = TweenService:Create(csIndicate,TI.SoulChangeIndicate,{Transparency = 1})
				local pushTween = TweenService:Create(hmrt,TI.ForcePushAway,{CFrame = hmCF})
				charModel.Humanoid:UnequipTools()
				charModel.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
				indicateCF:Play()
				fadeCF:Play()
				task.spawn(function()
					indicateCF.Completed:Wait()
					csIndicate:Destroy()
				end)
				pushTween:Play()
				pushTween.Completed:Wait()
				cs.Mesh.TextureId = cs.Free.Value
				local ind2 = cs:Clone()
				ind2.Parent = charModel.HumanoidRootPart
				ind2.Name = "CSClone2"
				ind2.Mesh.TextureId = ind2.Free.Value
				ind2.Anchored = true
				local indCF2 = TweenService:Create(ind2.Mesh,TI.SoulChangeIndicate,{Scale = Vector3.new(ind2.Mesh.Scale.X*2,ind2.Mesh.Scale.Y*2,ind2.Mesh.Scale.Z*2)})
				local indFade = TweenService:Create(ind2,TI.SoulChangeIndicate,{Transparency = 1})
				local csFade = TweenService:Create(cs,TI.SoulChangeIndicate,{Transparency = 1})
				indCF2:Play()
				indFade:Play()
				task.spawn(function()
					indCF2.Completed:Wait()
					ind2:Destroy()
					csFade:Play()
				end)
				charModel.Humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
				hmrt.Anchored = false
				task.spawn(function()
					csFade.Completed:Wait()
					cs:Destroy()
				end)
			end)
		end
	end
end
function Novus.Global.Force.BlueHold(plr:Player,resLen:number)
	local charCF = plr.Character.HumanoidRootPart.CFrame::CFrame
	local rstTbl = {}
	local fs:Sound = Novus.Global.AudioFolderReference.ForceSound:Clone()
	fs.Parent = plr.Character.Head
	local sconn = fs.Played:Connect(function ()
		Novus.Global.Force.flashForceEye(plr,fs.TimeLength*2)
	end)
	fs:Play()
	for i,v in pairs(workspace:GetChildren()) do
		if v:FindFirstChild("Humanoid") ~= nil and v ~= plr.Character then
			rstTbl[v] = {v.Humanoid,v.Humanoid.JumpPower}
			v.Humanoid.JumpPower = 0
		end
	end
	task.wait(resLen)
	fs.Volume = 0.5
	fs:Play()
	for i,v in pairs(rstTbl) do
		v[1].JumpPower = v[2]
	end
	table.clear(rstTbl)
	sconn:Disconnect()
	fs:Destroy()
end
function Novus.Global.Blasters.UseBlasterCircle(plr,repeats,mouseOrigin,Target,mouseRay)
	if Target == nil then
		return
	end
	local TargetCF
	local rtParams = RaycastParams.new()
	rtParams.FilterType = Enum.RaycastFilterType.Blacklist
	local blTbl = {}
	for i,v in ipairs(game.Workspace:GetDescendants()) do
		if v.Parent:FindFirstChild("Humanoid") ~= nil then
			table.insert(blTbl,v)
		end
	end
	rtParams.FilterDescendantsInstances = blTbl
	local rtResult = workspace:Raycast(mouseOrigin.Position,mouseRay.Direction*1000,rtParams)
	if rtResult ~= nil then
		TargetCF = CFrame.new(rtResult.Position)
	else
		return
	end
	TargetCF += TargetCF.UpVector * 4
	for i = 1,repeats,1 do
		for i = 1,48,1 do
			TargetCF *= CFrame.fromAxisAngle(TargetCF.UpVector,math.rad(7.5))
			local sCF = TargetCF + TargetCF.LookVector * -150
			local bCF = sCF + sCF.LookVector * -50
			task.spawn(Novus.Global.Blasters.UseBlasterInternal,bCF,sCF,TargetCF,"Small")
			task.wait(0.075)
		end
	end
end
function Novus.Global.Universal.Blink(plr:Player,mouseHit:CFrame)
	local tgt:BasePart = nil
	local charCF:CFrame = plr.Character.HumanoidRootPart.CFrame
	local hm:Humanoid = plr.Character.Humanoid
	local initCF = CFrame.lookAt(charCF.Position,mouseHit.Position)
	initCF += initCF.LookVector * Novus.Variables.blinkRange
	local posCF = CFrame.new(mouseHit.Position)
	local tpCF = CFrame.new(posCF.Position)
	tpCF += tpCF.UpVector * 4
	local boxSize = Vector3.new(3,5,1)
	local OLP = OverlapParams.new()
	OLP.RespectCanCollide = false
	OLP.MaxParts = 0
	OLP.FilterType = Enum.RaycastFilterType.Blacklist
	local blTbl = {}
	for i,v in pairs(workspace:GetChildren()) do
		if v:FindFirstChild("Humanoid") ~= nil then
			table.insert(blTbl,v)
		end
	end
	OLP.FilterDescendantsInstances = blTbl
	local ptTbl = {}
	ptTbl = workspace:GetPartBoundsInBox(tpCF,boxSize,OLP)
	for i,v in pairs(ptTbl) do
		if v then
			tgt = v
		end
	end
	if tgt == nil then
		tpCF = CFrame.new(initCF.Position)
		tpCF += tpCF.UpVector * 4
		local blkTI = TweenInfo.new(
			0.5,
			Enum.EasingStyle.Sine,
			Enum.EasingDirection.In,
			0,
			false,
			0
		)
		local clnTbl = {}
		local cln = hm.Parent.Torso:Clone()::BasePart
		cln.Parent = workspace
		for i,v in pairs(cln:GetChildren()) do
			if v:IsA("Motor6D") then
				v:Destroy()
			end
		end
		cln.Anchored = true
		cln.Material = Enum.Material.Neon
		cln.BrickColor = BrickColor.new("Black metallic")
		cln.CanCollide = false
		cln.CanQuery = false
		table.insert(clnTbl,cln)
		for i,v in pairs(hm.Parent:GetChildren()) do
			if v:IsA("BasePart") and v ~= hm.Parent.Torso and v.Name ~= "HumanoidRootPart" then
				local cln = v:Clone()
				cln.Anchored = true
				cln.Material = Enum.Material.Neon
				cln.BrickColor = BrickColor.new("Black metallic")
				cln.Parent = workspace
				cln.CanCollide = false
				cln.CanQuery = false
				table.insert(clnTbl,cln)
			end
		end
		for i,v in pairs(clnTbl) do
			local tw = TweenService:Create(v,blkTI,{Size = Vector3.new(v.Size.X*5,v.Size.Y*5,v.Size.Z*5),Transparency = 1})
			tw:Play()
			task.spawn(function()
				tw.Completed:Wait()
				v:Destroy()
			end)
		end
		local tpSound = Novus.Global.AudioFolderReference.Teleport:Clone()
		tpSound.Parent = plr.Character.PrimaryPart
		tpSound:Play()
		task.spawn(function()
			tpSound.Ended:Wait()
			tpSound:Destroy()
		end)
		plr.Character:MoveTo(tpCF.Position)
		local clnTbl2 = {}
		local cln2 = hm.Parent.Torso:Clone()::BasePart
		cln2.Parent = workspace
		for i,v in pairs(cln:GetChildren()) do
			if v:IsA("Motor6D") then
				v:Destroy()
			end
		end
		cln2.Anchored = true
		cln2.Material = Enum.Material.Neon
		cln2.BrickColor = BrickColor.new("Institutional white")
		cln2.CanCollide = false
		cln2.CanQuery = false
		table.insert(clnTbl2,cln2)
		for i,v in pairs(hm.Parent:GetChildren()) do
			if v:IsA("BasePart") and v ~= hm.Parent.Torso and v.Name ~= "HumanoidRootPart" then
				local cln3 = v:Clone()
				cln3.Anchored = true
				cln3.Material = Enum.Material.Neon
				cln3.BrickColor = BrickColor.new("Institutional white")
				cln3.Parent = workspace
				cln3.CanCollide = false
				cln3.CanQuery = false
				table.insert(clnTbl2,cln3)
			end
		end
		for i,v in pairs(clnTbl2) do
			local tw = TweenService:Create(v,blkTI,{Size = Vector3.new(v.Size.X*5,v.Size.Y*5,v.Size.Z*5),Transparency = 1})
			tw:Play()
			task.spawn(function()
				tw.Completed:Wait()
				v:Destroy()
			end)
		end
	else
		tpCF = CFrame.new(posCF.Position)
		tpCF += initCF.LookVector * -10
		tpCF += tpCF.UpVector * 4
		local blkTI = TweenInfo.new(
			0.5,
			Enum.EasingStyle.Sine,
			Enum.EasingDirection.In,
			0,
			false,
			0
		)
		local clnTbl = {}
		local cln = hm.Parent.Torso:Clone()::BasePart
		cln.Parent = workspace
		for i,v in pairs(cln:GetChildren()) do
			if v:IsA("Motor6D") then
				v:Destroy()
			end
		end
		cln.Anchored = true
		cln.Material = Enum.Material.Neon
		cln.BrickColor = BrickColor.new("Black metallic")
		cln.CanCollide = false
		cln.CanQuery = false
		table.insert(clnTbl,cln)
		for i,v in pairs(hm.Parent:GetChildren()) do
			if v:IsA("BasePart") and v ~= hm.Parent.Torso and v.Name ~= "HumanoidRootPart" then
				local cln = v:Clone()
				cln.Anchored = true
				cln.Material = Enum.Material.Neon
				cln.BrickColor = BrickColor.new("Black metallic")
				cln.Parent = workspace
				cln.CanCollide = false
				cln.CanQuery = false
				table.insert(clnTbl,cln)
			end
		end
		for i,v in pairs(clnTbl) do
			local tw = TweenService:Create(v,blkTI,{Size = Vector3.new(v.Size.X*5,v.Size.Y*5,v.Size.Z*5),Transparency = 1})
			tw:Play()
			task.spawn(function()
				tw.Completed:Wait()
				v:Destroy()
			end)
		end
		local tpSound = Novus.Global.AudioFolderReference.Teleport:Clone()
		tpSound.Parent = plr.Character.PrimaryPart
		tpSound:Play()
		task.spawn(function()
			tpSound.Ended:Wait()
			tpSound:Destroy()
		end)
		plr.Character:MoveTo(tpCF.Position)
		local clnTbl2 = {}
		local cln2 = hm.Parent.Torso:Clone()::BasePart
		cln2.Parent = workspace
		for i,v in pairs(cln:GetChildren()) do
			if v:IsA("Motor6D") then
				v:Destroy()
			end
		end
		cln2.Anchored = true
		cln2.Material = Enum.Material.Neon
		cln2.BrickColor = BrickColor.new("Institutional white")
		cln2.CanCollide = false
		cln2.CanQuery = false
		table.insert(clnTbl2,cln2)
		for i,v in pairs(hm.Parent:GetChildren()) do
			if v:IsA("BasePart") and v ~= hm.Parent.Torso and v.Name ~= "HumanoidRootPart" then
				local cln3 = v:Clone()
				cln3.Anchored = true
				cln3.Material = Enum.Material.Neon
				cln3.BrickColor = BrickColor.new("Institutional white")
				cln3.Parent = workspace
				cln3.CanCollide = false
				cln3.CanQuery = false
				table.insert(clnTbl2,cln3)
			end
		end
		for i,v in pairs(clnTbl2) do
			local tw = TweenService:Create(v,blkTI,{Size = Vector3.new(v.Size.X*5,v.Size.Y*5,v.Size.Z*5),Transparency = 1})
			tw:Play()
			task.spawn(function()
				tw.Completed:Wait()
				v:Destroy()
			end)
		end
	end
end
function Novus.Global.Universal.BoostStamina(plr:Player)
	local hm = plr.Character.Humanoid
	local blkTI = TweenInfo.new(
		0.5,
		Enum.EasingStyle.Sine,
		Enum.EasingDirection.In,
		0,
		false,
		0
	)
	local clnTbl = {}
	local cln = hm.Parent.Torso:Clone()::BasePart
	cln.Parent = workspace
	for i,v in pairs(cln:GetChildren()) do
		if v:IsA("Motor6D") then
			v:Destroy()
		end
	end
	cln.Anchored = true
	cln.Material = Enum.Material.Neon
	cln.BrickColor = BrickColor.new("Gold")
	cln.CanCollide = false
	table.insert(clnTbl,cln)
	for i,v in pairs(hm.Parent:GetChildren()) do
		if v:IsA("BasePart") and v ~= hm.Parent.Torso and v.Name ~= "HumanoidRootPart" then
			local cln = v:Clone()
			cln.Anchored = true
			cln.Material = Enum.Material.Neon
			cln.BrickColor = BrickColor.new("Gold")
			cln.Parent = workspace
			cln.CanCollide = false
			table.insert(clnTbl,cln)
		end
	end
	for i,v in pairs(clnTbl) do
		if v:FindFirstChildOfClass("Decal") then
			v:FindFirstChildOfClass("Decal"):Destroy()
		end
		local tw = TweenService:Create(v,blkTI,{Size = Vector3.new(v.Size.X*5,v.Size.Y*5,v.Size.Z*5),Transparency = 1})
		tw:Play()
		task.spawn(function()
			tw.Completed:Wait()
			v:Destroy()
		end)
	end
	local rsSound = Novus.Global.AudioFolderReference.StmRestoreSound:Clone()
	rsSound.Parent = plr.Character.PrimaryPart
	rsSound:Play()
	task.spawn(function ()
		local ns = Novus.Passives.Variables.Stamina + 50
		if ns >= 150 then
			Novus.Passives.Variables.Stamina = 150
		else
			Novus.Passives.Variables.Stamina = ns
		end
		rsSound.Ended:Wait()
		rsSound:Destroy()
	end)
end

Novus.__index = function (tbl,index)
	return Novus
end

print(script.Name..": Loaded module in "..os.clock()-startInitTime.." seconds.")

return Novus
