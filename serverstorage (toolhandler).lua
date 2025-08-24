    serverstorage.toolhandler
    --SynapseX Decompiler

local API = {}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Soundscape = game:GetService("SoundService")
local Debris = game:GetService("Debris")
local StarterGui = game:GetService("StarterGui")
local RemoteHandler = require(script.Parent.RemoteHandler)
local AnimationController = require(script.Parent.AnimationController)
local ClientFunctions = require(script.Parent.ClientFunctions)
local Items = require(ReplicatedStorage.Databases.Items)
local Tools = require(ReplicatedStorage.Databases.Tools)
local Assets = require(ReplicatedStorage.Databases.Assets)
local player = Players.LocalPlayer
local humanoid
local lastRem = tick()
local radioRem = RemoteHandler.Event.new("RadioUpdate")
local RANDOM, RAD, RAY, V3, CF, CFANG = math.random, math.rad, Ray.new, Vector3.new, CFrame.new, CFrame.Angles
local BC, INST, COLSEQ, FORMAT, INSERT = BrickColor.new, Instance.new, ColorSequence.new, string.format, table.insert
local addItem = Debris.AddItem
local LOG_DISTANCE = 35
local LOG_DELAY = 2
function API.Init(hum)
	humanoid = hum
end
function API.SpawnToolEffect(tool, id, effectTable)
	if tool and tool:IsDescendantOf(workspace) then
		local assetTable = Assets.Tools[Items[id].Asset]
		for i, v in ipairs(effectTable) do
			do
				local effect
				if v[2] == "Sound" then
					local soundTable = assetTable.Sound[v[1]]
					effect = INST("Sound")
					effect.Looped = false
					effect.SoundId = soundTable[1]
					effect.SoundGroup = soundTable[3] and Soundscape[soundTable[3]]
					effect.Parent = tool[soundTable[2]]
					if soundTable[4] then
						effect.MinDistance = soundTable[4][1]
						effect.MaxDistance = soundTable[4][2]
					end
					effect:Play()
					pcall(function()
						if v[1] == "Fire" and humanoid and humanoid.Health > 0 and Tools[id] and tick() - lastRem >= LOG_DELAY then
							local dist = player:DistanceFromCharacter(tool:FindFirstChildWhichIsA("BasePart").Position)
							if dist ~= 0 and dist <= LOG_DISTANCE then
								lastRem = tick()
								radioRem:Fire()
							end
						end
					end)
				elseif v[2] == "SpotLight" then
					effect = assetTable.Light[2]:Clone()
					effect.Parent = tool[assetTable.Light[1]]
					effect.Enabled = true
					wait(0.1)
					effect.Enabled = false
				elseif v[2] == "ParticleEmitter" then
					effect = assetTable.Smoke[2]:Clone()
					effect.Parent = tool[assetTable.Smoke[1]]
					effect.Enabled = true
					wait(0.1)
					effect.Enabled = false
				end
				if effect then
					addItem(Debris, effect, 5)
				end
			end
		end
	end
end
RemoteHandler.Event.new("ToolEffect").OnEvent:Connect(function(tool, id, effectName, typeName)
	API.SpawnToolEffect(tool, id, effectName, typeName)
end)
function API.SpawnToolFire(hitPart, position, surfaceNormal, mat, less)
	pcall(function()
	local part = INST("Part")
	part.CanCollide = false
	part.Transparency = 1
	part.CFrame = CF(position, position + surfaceNormal)
	part.Size = V3(0.2, 0.2, 0.2)
	part.Anchored = true
	part.Parent = game.Workspace.InvisibleParts
	if mat then
		local sound = INST("Sound")
		sound.Volume = less and 0.1 or 0.7
		sound.SoundId = Assets.ImpactSounds[mat] or Assets.ImpactSounds[Enum.Material.Plastic]
		sound.EmitterSize = 10
		sound.MaxDistance = 60
		sound.Parent = part
		sound:Play()
	end
		if hitPart and hitPart:IsA("BasePart") then
			
		local debrisEffect = ReplicatedStorage.Effects.DebrisEffect:Clone()
		debrisEffect.Color = COLSEQ(hitPart.BrickColor.Color)
		debrisEffect.Parent = part
		debrisEffect:Emit(less and 10 or 50)
	end
	addItem(Debris, part, 4)
	pcall(function()
		if humanoid and humanoid.Health > 0 and tick() - lastRem >= LOG_DELAY then
			local dist = player:DistanceFromCharacter(position)
			if dist ~= 0 and dist <= LOG_DISTANCE then
				lastRem = tick()
				radioRem:Fire()	
				end
			end
		end)	
	end)
end
RemoteHandler.Event.new("ToolExec").OnEvent:Connect(function(hitTable)
	for _, v in ipairs(hitTable) do
		API.SpawnToolFire(v[1], v[2], v[3], v[4], #hitTable > 1)
	end
end)
RemoteHandler.Event.new("TaserEvent").OnEvent:Connect(function(disableBool)
	ClientFunctions.MovementEnable(not disableBool)
	ClientFunctions.InterruptBind:Fire()
end)
return API

  toolhandler.firearm
  --SynapseX Decompiler

local ToolInterface = require(script.Parent.ToolInterface)
local Firearm = {}
Firearm.__index = Firearm
setmetatable(Firearm, ToolInterface)
local Debris = game:GetService("Debris")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local KeyBinder = require(script.Parent.Parent.KeyBinder)
local RemoteHandler = require(script.Parent.Parent.RemoteHandler)
local ToolHandler = require(script.Parent)
local Tweening = require(script.Parent.Parent.Tweening)
local DynamicArms = require(script.Parent.Parent.DynamicArms)
local InventoryController = require(script.Parent.Parent.InventoryController)
local Assets = require(ReplicatedStorage.Databases.Assets)
local Items = require(ReplicatedStorage.Databases.Items)
local GLASS_TAG = "Glass"
local GLASS_SMASH_TAG = "Ignore"
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local vehicleFolder = workspace.Vehicles
local addItem = Debris.AddItem
local RANDOM, RAD, RAY, V3, CF, CFANG = math.random, math.rad, Ray.new, Vector3.new, CFrame.new, CFrame.Angles
local BC, INST, COLSEQ, FORMAT, INSERT = BrickColor.new, Instance.new, ColorSequence.new, string.format, table.insert
function Firearm.new(tool, id, humanoid, gui, noEvents)
	local self = ToolInterface.new(tool, id, humanoid, gui)
	setmetatable(self, Firearm)
	self.Ready = true
	self.AmmoReady = false
	self.MagSize = self.ToolTable.MagSize
	self.FireRemote = RemoteHandler.Event.new("ToolExec")
	self.ReloadRemote = RemoteHandler.Event.new("Reload")
	self.ParentGui = gui
	self.Gui = ReplicatedStorage.UI.FirearmFrame:Clone()
	self.Multishot = self.ToolTable.Multishot
	self.Rounds = 0
	local item = InventoryController.HaveItem(tool.Name, true)
	if self.ToolTable.Magazine and item[3] and item[3].Mag then
		local mag = InventoryController.HaveItem(item[3].Mag, true)
		if mag then
			self.Mag = mag
			self.Rounds = mag[3].R
		end
	elseif not self.ToolTable.Magazine then
		self.Rounds = item[3].R
	end
	self.AmmoReady = self.Rounds > 0
	self.Auto = false
	self.FireBind = Instance.new("BindableEvent")
	self.Fired = self.FireBind.Event
	self.Aiming = false
	self.Camera = workspace.CurrentCamera
	self.Barrel = self.Tool:WaitForChild("Barrel")
	self.AimPart = self.Tool:WaitForChild("AimPart")
	self.MouseDown = false
	self:UpdateGui()
	return self
end
function Firearm:OnEquip()
	self:UpdateGui()
	self.MouseDown = false
	self.GunCursor = Assets.GunCursor
	self.AimCursor = Assets.AimCursor
	mouse.Icon = self.GunCursor
	self.InventoryConn = InventoryController.OnEdit:Connect(function()
		self:UpdateGui()
	end)
	self.InventoryConnEdit = InventoryController.OnUpdate:Connect(function()
		self:UpdateGui()
	end)
	local function TriggerReload(inputObject)
		if inputObject.UserInputState == Enum.UserInputState.End then
			self:Reload()
		end
	end
	if self.ToolTable.Auto then
		self.ModeKey = KeyBinder.KeyAction.new("Auto", self.Auto and "Auto" or "Semi-Auto", {
			Enum.KeyCode.V
		}, function(inputObject)
			if inputObject.UserInputState == Enum.UserInputState.End then
				self.Auto = not self.Auto
				self.MouseDown = false
				if self.ModeKey then
					self.ModeKey:Update(self.Auto and "Auto" or "Semi-Auto", "Auto")
				end
			end
		end)
	end
	self.ReloadKey = KeyBinder.KeyAction.new("Reload", "Reload", {
		Enum.KeyCode.R
	}, TriggerReload)
	self.AimKey = KeyBinder.KeyAction.new("Aim", "Aim", {
		Enum.KeyCode.Q
	}, function(inputObject)
		if inputObject.UserInputState == Enum.UserInputState.Begin and self.Ready then
			self:Aim(not self.Aiming)
		end
	end)
	self.MouseEvent = UserInputService.InputBegan:connect(function(inputObject, processed)
		if inputObject.UserInputType == Enum.UserInputType.MouseButton1 and not processed then
			local thisTick = tick()
			self.MouseDown = self.Auto and thisTick
			repeat
				self:Fire(mouse)
				wait()
			until self.MouseDown ~= thisTick
		elseif inputObject.UserInputType == Enum.UserInputType.MouseButton2 and not processed and self.Ready then
			self:Aim(true)
		end
	end)
	self.MouseEventEnd = UserInputService.InputEnded:connect(function(inputObject, processed)
		if inputObject.UserInputType == Enum.UserInputType.MouseButton2 and not processed then
			self:Aim(false)
		elseif inputObject.UserInputType == Enum.UserInputType.MouseButton1 and not processed then
			self.MouseDown = false
		end
	end)
	if not self.Ready and not self.ReadyDebounce then
		self.ReadyDebounce = true
		wait(0.5)
		self.Ready = true
		self.ReadyDebounce = false
	end
end
function Firearm:OnUnequip()
	mouse.Icon = ""
	if self.ReloadKey then
		self.ReloadKey:Remove()
		self.ReloadKey = nil
	end
	if self.AimKey then
		self.AimKey:Remove()
		self.AimKey = nil
	end
	if self.MouseEvent then
		self.MouseEvent:Disconnect()
		self.MouseEvent = nil
	end
	if self.MouseEventEnd then
		self.MouseEventEnd:Disconnect()
		self.MouseEventEnd = nil
	end
	if self.InventoryConn then
		self.InventoryConn:Disconnect()
		self.InventoryConn = nil
	end
	if self.InventoryConnEdit then
		self.InventoryConnEdit:Disconnect()
		self.InventoryConnEdit = nil
	end
	if self.ToolTable.Auto and self.ModeKey then
		self.ModeKey:Remove()
		self.ModeKey = nil
	end
	self:Aim(false)
end
function Firearm:Aim(aimBool)
	if aimBool and not DynamicArms.CanAim() then
		return
	end
	self.Aiming = aimBool
	UserInputService.MouseDeltaSensitivity = aimBool and self.ToolTable.FoV / 70 or 1
	DynamicArms.SetAimPart(aimBool and self.AimPart or nil)
	Tweening.NewTween(self.Camera, "FieldOfView", aimBool and self.ToolTable.FoV or 70, 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	mouse.Icon = aimBool and self.AimCursor or self.Equipped and self.GunCursor or ""
	if aimBool then
		do
			local endConn
			endConn = DynamicArms.GetEndAimEvent():Connect(function()
				endConn:Disconnect()
				if self.Equipped then
					self:Aim(false)
				end
			end)
		end
	end
end
function Firearm:UpdateCursor()
	if self.Equipped then
		mouse.Icon = self.Aiming and self.AimCursor or self.GunCursor
	end
end
function Firearm:UpdateGui()
	local pattern = "%03d"
	self.Gui:WaitForChild("MagLabel").Text = FORMAT(pattern, self.Rounds)
	self.Gui:WaitForChild("TotalLabel").Text = FORMAT(pattern, self:GetReadyRounds())
end
function Firearm:Fire(mouse)
	if (self.Ready or self.Reloading and not self.FireFlag) and self.AmmoReady then
		self.Ready = false
		self.FireBind:Fire()
		self.Rounds = self.Rounds - 1
		if self.Rounds <= 0 then
			self.AmmoReady = false
		end
		if self.Mag then
			local magAtt = self.Mag[3]
			magAtt.R = magAtt.R - 1
			InventoryController.EditAttributes(self.Mag[1], true, magAtt)
		elseif not self.ToolTable.Magazine then
			InventoryController.EditAttributes(self.Tool.Name, true, {
				R = self.Rounds
			})
		end
		self:UpdateGui()
		self:TriggerEffect({
			self.FireSound,
			self.Smoke,
			self.Light
		})
		do
			local fireTrack = self:MakeTrack(self.Animations.Fire)
			table.insert(self.CurrentAnimations, fireTrack)
			fireTrack.KeyframeReached:connect(function(keyframeName)
				if keyframeName == "End" then
					fireTrack:Stop(0)
					fireTrack:Destroy()
					self.Ready = true
				elseif keyframeName == "Pump" then
					self:TriggerEffect({
						self.PumpSound
					})
				end
			end)
			fireTrack:Play(0)
			local rotY = (RANDOM() - 0.5) * self.ToolTable.Recoil / 2
			Tweening.NewRecoilTween(self.Camera, self.ToolTable.Recoil, rotY, 0.1, "outQuad")
			delay(0.1, function()
				Tweening.NewRecoilTween(self.Camera, -self.ToolTable.Recoil, -rotY, 0.2, "outQuad")
			end)
			local mousePos = mouse.Hit.p
			local humanoidHit = false
			local distance = (self.Barrel.Position - mousePos).Magnitude
			local originPos = (self.Torso.CFrame * CF(0, 1.5, 0)).p
			local hitTable = {}
			for i = 1, self.Multishot and 9 or 1 do
				local spread = self.ToolTable.Spread / 50 * distance
				local endPos = V3(mousePos.x + (RANDOM() * (spread * 2) - spread), mousePos.y + (RANDOM() * (spread * 2) - spread), mousePos.z + (RANDOM() * (spread * 2) - spread))
				local hit, position, sur, mat = self:Raycast(originPos, endPos, self:GetIgnoreList(self.Character), self.ToolTable.Range)
				local hum, vehicle
				if hit then
					hum = hit.Parent:FindFirstChild("Humanoid")
					if CollectionService:HasTag(hit, GLASS_TAG) then
						table.insert(hitTable, {
							hit,
							position,
							sur,
							mat
						})
						hit, position, sur, mat = self:Raycast(originPos, endPos, self:GetIgnoreList(self.Character, hit), self.ToolTable.Range)
					elseif not hum then
						vehicle = hit.Parent:IsDescendantOf(vehicleFolder)
					end
				end
				table.insert(hitTable, {
					hit,
					position,
					sur,
					mat
				})
				if not (not hit or hum or CollectionService:HasTag(hit, GLASS_TAG)) or vehicle then
					ToolHandler.SpawnToolFire(hit, position, sur, mat, self.Multishot)
				end
				if hum or vehicle then
					humanoidHit = true
				end
			end
			if #hitTable > 0 then
				self.FireRemote:Fire(self.Tool, hitTable)
			end
			if humanoidHit then
				do
					local hitTick = tick()
					self.LastMarker = hitTick
					self.GunCursor = Assets.GunMarker
					self.AimCursor = Assets.AimMarker
					self:UpdateCursor()
					local hitSound = Instance.new("Sound")
					hitSound.SoundId = Assets.HitMarkerSound
					hitSound.Volume = 0.5
					hitSound.Parent = self.ParentGui
					hitSound:Play()
					delay(0.5, function()
						if hitTick == self.LastMarker then
							self.GunCursor = Assets.GunCursor
							self.AimCursor = Assets.AimCursor
							self:UpdateCursor()
						end
						hitSound:Destroy()
					end)
				end
			end
		end
	elseif self.Ready and not self.AmmoReady then
		self.Ready = false
		self:TriggerEffect({
			self.EmptySound
		})
		wait(0.1)
		self.Ready = true
	end
end
local SortAmmo = function(a, b)
	return a[3].R > b[3].R
end
local SortAmmoO = function(a, b)
	return a[3].R < b[3].R
end
function Firearm:GetReadyRounds()
	local sum = 0
	local inv = InventoryController.GetInventory()
	for i, v in pairs(inv) do
		local iTable = Items[v[2]]
		if iTable.Type == "Magazine" and iTable.Rounds == self.ToolTable.Rounds and 0 < v[3].R and (self.Mag and v[1] ~= self.Mag[1] or not self.Mag) then
			sum = sum + v[3].R
		end
	end
	return sum
end
function Firearm:GetMags()
	local mags = {}
	local inv = InventoryController.GetInventory()
	for i, v in pairs(inv) do
		local iTable = Items[v[2]]
		if iTable.Type == "Magazine" and iTable.Rounds == self.ToolTable.Rounds and v[3].R > 0 and (self.Mag and v[1] ~= self.Mag[1] or not self.Mag) then
			table.insert(mags, v)
		end
	end
	table.sort(mags, self.ToolTable.Magazine and SortAmmo or SortAmmoO)
	return mags
end
function Firearm:Reload()
	if self.Ready then
		if self.MagSize and self.Rounds >= self.MagSize then
			return
		end
		do
			local mags = self:GetMags()
			if #mags <= 0 then
				return
			end
			if self.Mag and mags[1][3].R <= self.Rounds then
				return
			end
			self.Ready = false
			self.Reloading = true
			self:Aim(false)
			self.FireFlag = false
			local localFlag = false
			local fireConn
			fireConn = self.Fired:Connect(function()
				fireConn:Disconnect()
				self.FireFlag = true
				localFlag = true
			end)
			local currentRounds = self.Rounds
			local totalRounds = self:GetReadyRounds()
			local target
			if not self.ToolTable.Magazine then
				if totalRounds < self.MagSize - self.Rounds then
					target = totalRounds + self.Rounds
				else
					target = self.Rounds + (self.MagSize - self.Rounds)
				end
			end
			if self.ToolTable.Magazine then
				self:TriggerEffect({
					self.ReloadSound
				})
			end
			local AfterThread
			local function ReloadThread()
				currentRounds = currentRounds + 1
				local reloadTrack = self:MakeTrack(self.Animations.Reload)
				table.insert(self.CurrentAnimations, reloadTrack)
				reloadTrack:Play()
				reloadTrack.KeyframeReached:Connect(function(keyframeName)
					if self.FireFlag or localFlag then
						reloadTrack:Stop()
						reloadTrack:Destroy()
						self.Reloading = false
						return
					end
					if keyframeName == "ReloadEnd" and not self.ToolTable.Magazine then
						self:TriggerEffect({
							self.ReloadSound
						})
					end
					if keyframeName == "ReloadEnd" and currentRounds ~= target or keyframeName == "End" then
						reloadTrack:Stop()
						reloadTrack:Destroy()
						AfterThread(currentRounds, nil)
					end
				end)
			end
			function AfterThread(i, reloadTrack)
				if self.ToolTable.Magazine then
					self.Mag = mags[1]
					self.Rounds = mags[1][3].R
					self.ReloadRemote:Fire(self.Tool.Name, mags[1][1])
				else
					for i = 1, #mags do
						if mags[i][3].R > 0 then
							self.Rounds = self.Rounds + 1
							InventoryController.EditAttributes(mags[1][1], true, {
								R = mags[1][3].R - 1
							})
							self.ReloadRemote:Fire(self.Tool.Name, mags[i][1])
							break
						end
					end
				end
				self:UpdateGui()
				self.AmmoReady = true
				if self.ToolTable.Magazine or i == target then
					fireConn:Disconnect()
					self.Ready = true
					self.Reloading = false
				else
					ReloadThread()
				end
			end
			ReloadThread()
		end
	end
end
return Firearm

    toolhandler.flashlight
    --SynapseX Decompiler

local ToolInterface = require(script.Parent.ToolInterface)
local Flashlight = {}
Flashlight.__index = Flashlight
setmetatable(Flashlight, ToolInterface)
local Debris = game:GetService("Debris")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local KeyBinder = require(script.Parent.Parent.KeyBinder)
local RemoteHandler = require(script.Parent.Parent.RemoteHandler)
local ToolHandler = require(script.Parent)
local DEBOUNCE_TIME = 0.5
local player = Players.LocalPlayer
local lightRemote = RemoteHandler.Event.new("Flashlight")
local RANDOM, RAD, RAY, V3, CF, CFANG = math.random, math.rad, Ray.new, Vector3.new, CFrame.new, CFrame.Angles
local BC, INST, COLSEQ, FORMAT, INSERT = BrickColor.new, Instance.new, ColorSequence.new, string.format, table.insert
function Flashlight.new(tool, id, humanoid, gui)
	local self = ToolInterface.new(tool, id, humanoid, gui)
	setmetatable(self, Flashlight)
	self.Activated = false
	self.Debounce = false
	self.LightPart = tool:WaitForChild("LightPart")
	self.Light = self.LightPart:WaitForChild("FlashlightLight")
	return self
end
function Flashlight:OnEquip()
	self.FlashKey = KeyBinder.KeyAction.new("FlashlightToggle", "Flashlight " .. (self.Activated and "Off" or "On"), {
		Enum.KeyCode.E
	}, function(inputObject)
		if inputObject.UserInputState == Enum.UserInputState.End then
			self:ToggleLight()
		end
	end)
end
function Flashlight:OnUnequip()
	if self.FlashKey then
		self.FlashKey:Remove()
		self.FlashKey = nil
	end
end
function Flashlight:ToggleLight()
	if not self.Debounce then
		self.Debounce = true
		self.Activated = not self.Activated
		self.Light.Enabled = self.Activated
		self.LightPart.Transparency = self.Activated and 0 or 1
		self:TriggerEffect({
			self["Flashlight" .. (self.Activated and "On" or "Off") .. "Sound"]
		})
		self.FlashKey:Update("Flashlight " .. (self.Activated and "Off" or "On"))
		lightRemote:Fire(self.Tool, self.Activated)
		wait(DEBOUNCE_TIME)
		self.Debounce = false
	end
end
return Flashlight

      toolhandler.handcuffs
      --SynapseX Decompiler

local ToolInterface = require(script.Parent.ToolInterface)
local Handcuffs = {}
Handcuffs.__index = Handcuffs
setmetatable(Handcuffs, ToolInterface)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ClientFunctions = require(script.Parent.Parent.ClientFunctions)
local InteractController = require(script.Parent.Parent.InteractController)
local MovementController = require(script.Parent.Parent.MovementController)
local JusticeController = require(script.Parent.Parent.JusticeController)
local NotificationHandler = require(script.Parent.Parent.NotificationHandler)
local player = Players.LocalPlayer
local seats = {}
for _, v in pairs(workspace:GetDescendants()) do
	if v.ClassName == "Seat" then
		seats[#seats + 1] = v
	end
end
function Handcuffs.new(tool, id, humanoid, gui, button)
	local self = ToolInterface.new(tool, id, humanoid, gui)
	setmetatable(self, Handcuffs)
	return self
end
local function SetSeats(enabled)
	enabled = not enabled
	for _, v in pairs(seats) do
		v.Disabled = enabled
	end
end
function Handcuffs:OnEquip()
	ClientFunctions.InterruptBind:Fire()
	ClientFunctions.DisableTools(true)
	MovementController.DisableRunning(true)
	MovementController.DisableJumping(true)
	InteractController.Stop()
	SetSeats(false)
	self.Humanoid.Sit = false
	NotificationHandler.NewNotification("You have been handcuffed. Leaving the game may result in a temporary ban.", "Handcuffed!", "Red", true)
	if JusticeController.HasGrab() then
		JusticeController.GrabPlayer(JusticeController.GetPlayerGrab())
	end
end
function Handcuffs:OnUnequip()
	SetSeats(true)
	ClientFunctions.DisableTools(false)
	MovementController.DisableRunning(false)
	MovementController.DisableJumping(false)
	InteractController.Init()
end
return Handcuffs

  toolhandler
  --SynapseX Decompiler

local ToolInterface = require(script.Parent.ToolInterface)
local Melee = {}
Melee.__index = Melee
setmetatable(Melee, ToolInterface)
local Debris = game:GetService("Debris")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local RemoteHandler = require(script.Parent.Parent.RemoteHandler)
local ToolHandler = require(script.Parent)
local DEBOUNCE_TIME = 0.5
local DAMAGE_COOLDOWN = 0.15
local GLASS_TAG = "Glass"
local IGNORE_TAG = "Ignore"
local player = Players.LocalPlayer
local RANDOM, RAD, RAY, V3, CF, CFANG = math.random, math.rad, Ray.new, Vector3.new, CFrame.new, CFrame.Angles
local BC, INST, COLSEQ, FORMAT, INSERT = BrickColor.new, Instance.new, ColorSequence.new, string.format, table.insert
function Melee.new(tool, id, humanoid, gui)
	local self = ToolInterface.new(tool, id, humanoid, gui)
	setmetatable(self, Melee)
	self.Debounce = false
	self.HitPart = tool:WaitForChild("HitPart")
	self.FireRemote = RemoteHandler.Event.new("ToolExec")
	self.Smash = not self.ToolTable.NoSmash
	return self
end
function Melee:OnEquip()
	self.MouseEvent = UserInputService.InputBegan:connect(function(inputObject, processed)
		if inputObject.UserInputType == Enum.UserInputType.MouseButton1 and not processed then
			self:Swing()
		end
	end)
end
function Melee:OnUnequip()
	if self.MouseEvent then
		self.MouseEvent:Disconnect()
		self.MouseEvent = nil
	end
end
function Melee:Swing()
	if not self.Debounce then
		self.Debounce = true
		self:TriggerEffect({
			self.SwingSound
		})
		do
			local swingTrack = self:MakeTrack(self.Animations.Swing)
			table.insert(self.CurrentAnimations, swingTrack)
			local ready = true
			swingTrack.KeyframeReached:connect(function(keyframeName)
				if keyframeName == "End" then
					swingTrack:Stop(0)
					swingTrack:Destroy()
					ready = false
				end
			end)
			swingTrack:Play(0)
			local damageDebounce = false
			local function OnHit(hit)
				if not damageDebounce and ready then
					damageDebounce = true
					local humanoid = hit.Parent:FindFirstChild("Humanoid")
					if humanoid and humanoid ~= self.Humanoid or self.Smash and CollectionService:HasTag(hit, GLASS_TAG) and not CollectionService:HasTag(hit, IGNORE_TAG) then
						self.FireRemote:Fire(self.Tool, {
							{hit}
						})
						wait(DAMAGE_COOLDOWN)
					end
					damageDebounce = false
				end
			end
			local hitConn
			hitConn = self.HitPart.Touched:Connect(function(hit)
				OnHit(hit)
			end)
			for i, v in pairs(self.HitPart:GetTouchingParts()) do
				OnHit(v)
			end
			for i, v in pairs(self.HitPart:GetTouchingParts()) do
				if v.Parent ~= self.Tool then
					OnHit(v)
				end
			end
			wait(DEBOUNCE_TIME)
			hitConn:Disconnect()
			self.Debounce = false
		end
	end
end
return Melee

        toolhandler.misc
        --SynapseX Decompiler

local ToolInterface = require(script.Parent.ToolInterface)
local Misc = {}
Misc.__index = Misc
setmetatable(Misc, ToolInterface)
local Debris = game:GetService("Debris")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local RemoteHandler = require(script.Parent.Parent.RemoteHandler)
local ToolHandler = require(script.Parent)
local DEBOUNCE_TIME = 0.5
local DAMAGE_COOLDOWN = 0.15
local GLASS_TAG = "Glass"
local IGNORE_TAG = "Ignore"
local player = Players.LocalPlayer
local RANDOM, RAD, RAY, V3, CF, CFANG = math.random, math.rad, Ray.new, Vector3.new, CFrame.new, CFrame.Angles
local BC, INST, COLSEQ, FORMAT, INSERT = BrickColor.new, Instance.new, ColorSequence.new, string.format, table.insert
function Misc.new(tool, id, humanoid, gui)
	local self = ToolInterface.new(tool, id, humanoid, gui)
	setmetatable(self, Misc)
	self.Debounce = false
	return self
end
function Misc:OnEquip()
	if not self.ItemTable.NoSwing then
		self.MouseEvent = UserInputService.InputBegan:connect(function(inputObject, processed)
			if inputObject.UserInputType == Enum.UserInputType.MouseButton1 and not processed then
				self:Swing()
			end
		end)
	end
end
function Misc:OnUnequip()
	if self.MouseEvent then
		self.MouseEvent:Disconnect()
		self.MouseEvent = nil
	end
end
function Misc:Swing()
	if not self.Debounce then
		self.Debounce = true
		self:TriggerEffect({
			self.SwingSound
		})
		do
			local swingTrack = self:MakeTrack(self.Animations.Swing)
			table.insert(self.CurrentAnimations, swingTrack)
			local ready = true
			swingTrack.KeyframeReached:connect(function(keyframeName)
				if keyframeName == "End" then
					swingTrack:Stop(0)
					swingTrack:Destroy()
					ready = false
				end
			end)
			swingTrack:Play(0)
			wait(DEBOUNCE_TIME)
			self.Debounce = false
		end
	end
end
return Misc

        toolhandler.ploppabletool
        --SynapseX Decompiler

local ToolInterface = require(script.Parent.ToolInterface)
local PloppableTool = {}
PloppableTool.__index = PloppableTool
setmetatable(PloppableTool, ToolInterface)
local Debris = game:GetService("Debris")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local KeyBinder = require(script.Parent.Parent.KeyBinder)
local RemoteHandler = require(script.Parent.Parent.RemoteHandler)
local Ploppables = require(ReplicatedStorage.Databases.Ploppables)
local ROTATE_INCREMENT = 30
local PLOP_COOLDOWN = 0.25
local player = Players.LocalPlayer
local FindPartOnRayWithIgnoreList = workspace.FindPartOnRayWithIgnoreList
local setPlop = RemoteHandler.Event.new("SetPlop")
local RANDOM, RAD, RAY, V3, CF, CFANG = math.random, math.rad, Ray.new, Vector3.new, CFrame.new, CFrame.Angles
local BC, INST, COLSEQ, FORMAT, INSERT = BrickColor.new, Instance.new, ColorSequence.new, string.format, table.insert
local function Raycast(originPos, ignoreList)
	local hit, pos, sur = FindPartOnRayWithIgnoreList(workspace, RAY(originPos, V3(0, -8, 0)), ignoreList, false, true)
	return hit, pos, sur
end
local function IgnoreList(char, otherItem)
	local def = {
		char,
		workspace.InvisibleParts,
		workspace.Ploppables,
		otherItem
	}
	for _, p in pairs(Players:GetPlayers()) do
		if p.Character then
			INSERT(def, p.Character)
		end
	end
	return def
end
function PloppableTool.new(tool, id, humanoid, gui)
	local self = ToolInterface.new(tool, "PloppableTool", humanoid, gui)
	setmetatable(self, PloppableTool)
	self.PlopType = id
	self.Properties = Ploppables[self.PlopType]
	self.Name = self.Properties.Name
	self.RotateDeg = -90
	self.RayClone = self.Properties.Asset:Clone()
	self.RayClone.PrimaryPart.Transparency = 1
	for i, v in pairs(self.RayClone:GetChildren()) do
		if v:IsA("BasePart") then
			v.CanCollide = false
		end
	end
	self.Debounce = false
	return self
end
function PloppableTool:OnEquip()
	self:UpdateButtons()
	self.Heartbeat = RunService.Heartbeat:Connect(function()
		if self.Equipped then
			local frontPos = (self.Torso.CFrame * CF(0, 0, -5)).p
			local hit, pos, sur = Raycast(frontPos, IgnoreList(self.Character))
			if hit then
				self.RayClone.Parent = workspace.InvisibleParts
				local origCFrame = CF(pos, pos + sur) * CFANG(RAD(-90), 0, 0) * CF(0, -0.2, 0)
				local lookVector = CF(pos, pos + self.Torso.CFrame.lookVector)
				self.RayClone:SetPrimaryPartCFrame(origCFrame * (lookVector - lookVector.p) * CFANG(0, RAD(self.RotateDeg), 0))
			else
				self.RayClone.Parent = nil
			end
		else
			self.RayClone.Parent = nil
		end
	end)
end
function PloppableTool:OnUnequip()
	if self.Heartbeat then
		self.Heartbeat:Disconnect()
		self.Heartbeat = nil
	end
	self.RayClone.Parent = nil
	self:UpdateButtons()
end
function PloppableTool:Plop(inputObject)
	if self.RayClone.Parent and not self.Debounce then
		setPlop:Fire(self.PlopType, self.RayClone.PrimaryPart.CFrame)
		self.Debounce = true
		delay(PLOP_COOLDOWN, function()
			self.Debounce = false
			self:UpdateButtons()
		end)
		self:UpdateButtons()
	end
end
function PloppableTool:Rotate(right)
	self.RotateDeg = self.RotateDeg + (right and -ROTATE_INCREMENT or ROTATE_INCREMENT)
end
function PloppableTool:UpdateButtons()
	local function PlopModel(inputObject)
		if inputObject.UserInputState == Enum.UserInputState.End then
			self:Plop()
		end
	end
	local function RotateModel(inputObject, right)
		if inputObject.UserInputState == Enum.UserInputState.End then
			self:Rotate(right)
		end
	end
	if self.Equipped and not self.Debounce then
		if not self.PlopKey and not self.LeftKey then
			self.PlopKey = KeyBinder.KeyAction.new("Plop", "Plop " .. self.Name, {
				Enum.KeyCode.R
			}, PlopModel)
			self.LeftKey = KeyBinder.KeyAction.new("LeftRotate", "Rotate Left", {
				Enum.KeyCode.Q
			}, function(inputObject)
				RotateModel(inputObject, false)
			end)
			self.RightKey = KeyBinder.KeyAction.new("RightRotate", "Rotate Right", {
				Enum.KeyCode.E
			}, function(inputObject)
				RotateModel(inputObject, true)
			end)
		end
	else
		if self.PlopKey then
			self.PlopKey:Remove()
			self.PlopKey = nil
		end
		if self.LeftKey then
			self.LeftKey:Remove()
			self.LeftKey = nil
		end
		if self.RightKey then
			self.RightKey:Remove()
			self.RightKey = nil
		end
	end
end
return PloppableTool

  toolhandler.radargun
  --SynapseX Decompiler

local ToolInterface = require(script.Parent.ToolInterface)
local RadarGun = {}
RadarGun.__index = RadarGun
setmetatable(RadarGun, ToolInterface)
local Debris = game:GetService("Debris")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local RemoteHandler = require(script.Parent.Parent.RemoteHandler)
local KeyBinder = require(script.Parent.Parent.KeyBinder)
local ToolHandler = require(script.Parent)
local Assets = require(ReplicatedStorage.Databases.Assets)
local GLASS_TAG = "Glass"
local IGNORE_TAG = "Ignore"
local BEEP_BETWEEN = 1
local MPH_MULTIPLIER = 0.681818
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local FindPartOnRayWithIgnoreList = workspace.FindPartOnRayWithIgnoreList
local RANDOM, RAD, RAY, V3, CF, CFANG = math.random, math.rad, Ray.new, Vector3.new, CFrame.new, CFrame.Angles
local BC, INST, COLSEQ, FORMAT, INSERT = BrickColor.new, Instance.new, ColorSequence.new, string.format, table.insert
local function Raycast(originPos, endPos, ignoreList, range)
	local directionVec = (endPos - originPos).unit
	local hit, pos, sur = FindPartOnRayWithIgnoreList(workspace, RAY(originPos, directionVec * range), ignoreList, false, true)
	return hit, pos, sur
end
local function IgnoreList(char)
	local tags = CollectionService:GetTagged(IGNORE_TAG)
	for _, v in ipairs(CollectionService:GetTagged(GLASS_TAG)) do
		table.insert(tags, v)
	end
	table.insert(tags, char)
	table.insert(tags, workspace.Ploppables)
	table.insert(tags, workspace.InvisibleParts)
	return tags
end
function RadarGun.new(tool, id, humanoid, gui)
	local self = ToolInterface.new(tool, id, humanoid, gui)
	setmetatable(self, RadarGun)
	self.ParentGui = gui
	self.Gui = ReplicatedStorage.UI.RadarFrame:Clone()
	self.Barrel = self.Tool:WaitForChild("Barrel")
	self.Speed = 0
	self.TargetSpeed = 30
	self.Debounce = false
	self.LastSound = tick()
	self.LastMove = tick()
	self:UpdateGui()
	return self
end
function RadarGun:OnEquip()
	self:UpdateButtons()
	self.Heartbeat = RunService.Heartbeat:Connect(function()
		if self.Equipped then
			local hit, pos, sur = Raycast(self.Barrel.Position, mouse.Hit.p, IgnoreList(player.Character), 600)
			local newSpeed = (hit and hit.Velocity.Magnitude or 0) * MPH_MULTIPLIER
			self.Speed = newSpeed > 0 and newSpeed or self.Speed
			self.LastMove = newSpeed > 0 and tick() or self.LastMove
			if newSpeed >= self.TargetSpeed and tick() - self.LastSound >= BEEP_BETWEEN then
				self.LastSound = tick()
				self:TriggerEffect({
					self.BeepSound
				})
			end
			if tick() - self.LastMove >= 5 then
				self.Speed = 0
			end
			self:UpdateGui()
		end
	end)
end
function RadarGun:OnUnequip()
	if self.Heartbeat then
		self.Heartbeat:Disconnect()
		self.Heartbeat = nil
	end
	self:UpdateButtons()
end
function RadarGun:UpdateGui()
	local spe = self.Gui:WaitForChild("SpeLabel")
	self.Gui:WaitForChild("TarLabel").Text = self.TargetSpeed
	spe.Text = math.clamp(math.floor(self.Speed), 0, 300)
	if self.Speed >= self.TargetSpeed then
		spe.TextColor3 = Assets.Color.Red
	else
		spe.TextColor3 = Color3.new(1, 1, 1)
	end
end
function RadarGun:UpdateButtons()
	local function ChangeTarget(inputObject, inc)
		if inputObject.UserInputState == Enum.UserInputState.End then
			self.TargetSpeed = math.clamp(self.TargetSpeed + (inc and 5 or -5), 10, 200)
		end
	end
	if self.Equipped and not self.Debounce then
		self.IncKey = KeyBinder.KeyAction.new("IncSpeed", "Increase Speed", {
			Enum.KeyCode.E
		}, function(inputObject)
			ChangeTarget(inputObject, true)
		end)
		self.DecKey = KeyBinder.KeyAction.new("DecSpeed", "Decrease Speed", {
			Enum.KeyCode.Q
		}, function(inputObject)
			ChangeTarget(inputObject)
		end)
	else
		if self.IncKey then
			self.IncKey:Remove()
			self.IncKey = nil
		end
		if self.DecKey then
			self.DecKey:Remove()
			self.DecKey = nil
		end
	end
end
return RadarGun

    toolhandler.taser
    --SynapseX Decompiler

local Firearm = require(script.Parent.Firearm)
local Taser = {}
Taser.__index = Taser
setmetatable(Taser, Firearm)
local Debris = game:GetService("Debris")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local KeyBinder = require(script.Parent.Parent.KeyBinder)
local RemoteHandler = require(script.Parent.Parent.RemoteHandler)
local ToolHandler = require(script.Parent)
local Tweening = require(script.Parent.Parent.Tweening)
local DynamicArms = require(script.Parent.Parent.DynamicArms)
local InventoryController = require(script.Parent.Parent.InventoryController)
local Assets = require(ReplicatedStorage.Databases.Assets)
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local addItem = Debris.AddItem
local taserRemove = RemoteHandler.Event.new("TaserEvent")
local RANDOM, RAD, RAY, V3, CF, CFANG = math.random, math.rad, Ray.new, Vector3.new, CFrame.new, CFrame.Angles
local BC, INST, COLSEQ, FORMAT, INSERT = BrickColor.new, Instance.new, ColorSequence.new, string.format, table.insert
function Taser.new(tool, id, humanoid, gui)
	local self = Firearm.new(tool, id, humanoid, gui, true)
	setmetatable(self, Taser)
	return self
end
function Taser:OnEquip()
	self:UpdateGui()
	self.GunCursor = Assets.GunCursor
	self.AimCursor = Assets.AimCursor
	mouse.Icon = self.GunCursor
	self.InventoryConn = InventoryController.OnEdit:Connect(function()
		self:UpdateGui()
	end)
	self.InventoryConnEdit = InventoryController.OnUpdate:Connect(function()
		self:UpdateGui()
	end)
	self.ReloadKey = KeyBinder.KeyAction.new("Reload", "Reload", {
		Enum.KeyCode.R
	}, function(inputObject)
		if inputObject.UserInputState == Enum.UserInputState.End then
			self:RemoveWire()
			self:Reload()
		end
	end)
	self.MouseEvent = UserInputService.InputBegan:connect(function(inputObject, processed)
		if inputObject.UserInputType == Enum.UserInputType.MouseButton1 and not processed then
			self:Fire(mouse)
		elseif inputObject.UserInputType == Enum.UserInputType.MouseButton2 and not processed and self.Ready then
			self:Aim(true)
		end
	end)
	self.MouseEventEnd = UserInputService.InputEnded:connect(function(inputObject, processed)
		if inputObject.UserInputType == Enum.UserInputType.MouseButton2 and not processed then
			self:Aim(false)
		end
	end)
	if not self.Ready and not self.ReadyDebounce then
		self.ReadyDebounce = true
		wait(0.5)
		self.Ready = true
		self.ReadyDebounce = false
	end
end
function Taser:OnUnequip()
	mouse.Icon = ""
	if self.ReloadKey then
		self.ReloadKey:Remove()
		self.ReloadKey = nil
	end
	if self.MouseEvent then
		self.MouseEvent:Disconnect()
		self.MouseEvent = nil
	end
	if self.MouseEventEnd then
		self.MouseEventEnd:Disconnect()
		self.MouseEventEnd = nil
	end
	if self.InventoryConn then
		self.InventoryConn:Disconnect()
		self.InventoryConn = nil
	end
	if self.InventoryConnEdit then
		self.InventoryConnEdit:Disconnect()
		self.InventoryConnEdit = nil
	end
	self:Aim(false)
end
function Taser:RemoveWire()
	if self.Wire then
		taserRemove:Fire()
		self.Wire = false
	end
end
function Taser:Fire(mouse)
	if (self.Ready or self.Reloading and not self.FireFlag) and self.AmmoReady then
		self.Ready = false
		self.FireBind:Fire()
		self.Rounds = self.Rounds - 1
		if self.Rounds <= 0 then
			self.AmmoReady = false
		end
		if self.Mag then
			InventoryController.EditAttributes(self.Mag[1], true, {
				R = self.Mag[3].R - 1
			})
		end
		self:UpdateGui()
		self:TriggerEffect({
			self.FireSound,
			self.Light
		})
		do
			local fireTrack = self:MakeTrack(self.Animations.Fire)
			table.insert(self.CurrentAnimations, fireTrack)
			fireTrack.KeyframeReached:connect(function(keyframeName)
				if keyframeName == "End" then
					fireTrack:Stop(0)
					fireTrack:Destroy()
					self.Ready = true
				elseif keyframeName == "Pump" then
					self:TriggerEffect({
						self.PumpSound
					})
				end
			end)
			fireTrack:Play(0)
			local rotY = (RANDOM() - 0.5) * self.ToolTable.Recoil / 2
			Tweening.NewRecoilTween(self.Camera, self.ToolTable.Recoil, rotY, 0.1, "outQuad")
			delay(0.1, function()
				Tweening.NewRecoilTween(self.Camera, -self.ToolTable.Recoil, -rotY, 0.2, "outQuad")
			end)
			local mousePos = mouse.Hit.p
			local distance = (self.Barrel.Position - mousePos).Magnitude
			local humanoidHit = false
			local spread = self.ToolTable.Spread / 50 * distance
			local endPos = V3(mousePos.x + (RANDOM() * (spread * 2) - spread), mousePos.y + (RANDOM() * (spread * 2) - spread), mousePos.z + (RANDOM() * (spread * 2) - spread))
			local originPos = (self.Torso.CFrame * CF(0, 1.5, 0)).p
			local hit, position, sur = self:Raycast(originPos, endPos, self:GetIgnoreList(self.Character), self.ToolTable.Range)
			local hum
			if hit then
				hum = hit.Parent:FindFirstChild("Humanoid")
			end
			self.FireRemote:Fire(self.Tool, {
				{
					hit,
					position,
					sur
				}
			})
			if hit and not hum then
				ToolHandler.SpawnToolFire(hit, position, sur)
			end
			if hum then
				self.Wire = true
				do
					local hitTick = tick()
					self.LastMarker = hitTick
					self.GunCursor = Assets.GunMarker
					self.AimCursor = Assets.AimMarker
					self:UpdateCursor()
					local hitSound = Instance.new("Sound")
					hitSound.SoundId = Assets.HitMarkerSound
					hitSound.Volume = 0.5
					hitSound.Parent = self.ParentGui
					hitSound:Play()
					delay(0.5, function()
						if hitTick == self.LastMarker then
							self.GunCursor = Assets.GunCursor
							self.AimCursor = Assets.AimCursor
							self:UpdateCursor()
						end
						hitSound:Destroy()
					end)
				end
			end
		end
	elseif self.Ready and not self.AmmoReady then
		self.Ready = false
		self:TriggerEffect({
			self.EmptySound
		})
		wait(0.1)
		self.Ready = true
	end
end
return Taser

        toolhandler.toolinterface
        --SynapseX Decompiler

local ToolInterface = {}
ToolInterface.__index = ToolInterface
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Soundscape = game:GetService("SoundService")
local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local RemoteHandler = require(script.Parent.Parent.RemoteHandler)
local AnimationController = require(script.Parent.Parent.AnimationController)
local Tools = require(ReplicatedStorage.Databases.Tools)
local Assets = require(ReplicatedStorage.Databases.Assets)
local Items = require(ReplicatedStorage.Databases.Items)
local GLASS_TAG = "Glass"
local GLASS_SMASH_TAG = "Ignore"
local player = Players.LocalPlayer
local FindPartOnRayWithIgnoreList = workspace.FindPartOnRayWithIgnoreList
local RANDOM, RAD, RAY, V3, CF, CFANG = math.random, math.rad, Ray.new, Vector3.new, CFrame.new, CFrame.Angles
local BC, INST, COLSEQ, FORMAT, INSERT = BrickColor.new, Instance.new, ColorSequence.new, string.format, table.insert
function ToolInterface.new(tool, id, humanoid, gui)
	local self = {}
	setmetatable(self, ToolInterface)
	self.Id = id
	self.Tool = tool
	self.Screen = gui
	self.ItemTable = id and Items[self.Id]
	self.ToolTable = id and Tools[self.Id] or nil
	self.AssetTable = id and self.ItemTable and Assets.Tools[self.ItemTable.Asset] or nil
	self.LastEquip = tick()
	self.Name = self.ItemTable and self.ItemTable.Name
	self.GripR = humanoid.Parent:WaitForChild("ToolGrip"):WaitForChild("Tool")
	self.Effects = ReplicatedStorage.Effects
	self.EffectRemote = RemoteHandler.Event.new("ToolEffect")
	if self.AssetTable then
		if self.AssetTable.Sound then
			for i, v in pairs(self.AssetTable.Sound) do
				local sound = Instance.new("Sound")
				sound.Looped = false
				sound.SoundId = v[1]
				sound.SoundGroup = v[3] and Soundscape[v[3]]
				sound.Parent = self.Tool:WaitForChild(v[2])
				sound.Name = i
				if v[4] then
					sound.MinDistance = v[4][1]
					sound.MaxDistance = v[4][2]
				end
				self[i .. "Sound"] = sound
			end
		end
		if self.AssetTable.Light then
			local light = self.AssetTable.Light[2]:Clone()
			light.Parent = self.Tool:WaitForChild(self.AssetTable.Light[1])
			self.Light = light
		end
		if self.AssetTable.Smoke then
			local smoke = self.AssetTable.Smoke[2]:Clone()
			smoke.Parent = self.Tool:WaitForChild(self.AssetTable.Smoke[1])
			self.Smoke = smoke
		end
	end
	self.Character = player.Character
	self.Humanoid = humanoid
	self.Torso = humanoid and humanoid.Torso
	self.RigType = humanoid and (humanoid.RigType == Enum.HumanoidRigType.R6 and "R6" or "R15")
	if self.AssetTable and self.AssetTable.Animation then
		self.Animations = self.AssetTable.Animation[self.RigType]
	end
	self.Root = self.Tool and self.Tool:FindFirstChild("Root")
	self.ArmAttach = self.RigType == "R6" and "Right Arm" or "RightHand"
	self.AttachCF = self.RigType == "R6" and CFrame.new(0, -1, -0.75) or CFrame.new(0, -0.15, -0.75)
	self.Equipped = false
	self.CurrentAnimations = {}
	return self
end
function ToolInterface:Equip()
	self.Tool.Parent = player.Character
	local thisEquip = tick()
	self.LastEquip = thisEquip
	if self.Tool and self.Tool.Parent and self.Character and self.Character:FindFirstChild(self.ArmAttach) then
		self.Equipped = true
		if self.Id ~= "PloppableTool" then
			local motor = Instance.new("Motor6D")
			motor.Name = "ToolGrip"
			motor.Part0 = self.Character[self.ArmAttach]
			motor.Part1 = self.Root
			motor.C0 = self.AttachCF * CFrame.Angles(math.rad(-90), 0, 0)
			motor.Parent = self.Character[self.ArmAttach]
			self.ToolGrip = motor
			table.insert(self.CurrentAnimations, AnimationController.new(self.Humanoid, self.Animations.Hold, (not self.ItemTable or not self.ItemTable.NoDelay) and 0.5))
			self.GripR:FireServer(self.Tool, true)
		end
		if self.Gui and self.ParentGui then
			self.Gui.Parent = self.ParentGui
		end
		if self.ItemTable and self.ItemTable.NoDelay then
			self:OnEquip()
			return true
		else
			delay(0.5, function()
				if thisEquip == self.LastEquip then
					self:OnEquip()
				end
			end)
			return true
		end
	end
end
function ToolInterface:Unequip()
	self.Tool.Parent = player.Backpack
	self.Equipped = false
	local thisEquip = tick()
	self.LastEquip = thisEquip
	if self.ToolGrip then
		self.ToolGrip:Destroy()
	end
	for i, v in pairs(self.CurrentAnimations) do
		v:Stop(0.1)
		if v.ClassName ~= "CustAnimation" then
			v:Destroy()
		end
	end
	self.CurrentAnimations = {}
	self.GripR:FireServer(self.Tool, false)
	if self.Gui then
		self.Gui.Parent = nil
	end
	self:OnUnequip()
end
function ToolInterface:Raycast(originPos, endPos, ignoreList, range)
	local directionVec = (endPos - originPos).unit
	return FindPartOnRayWithIgnoreList(workspace, RAY(originPos, directionVec * range), ignoreList, false, true)
end
function ToolInterface:GetIgnoreList(char, otherItem)
	local def = CollectionService:GetTagged(GLASS_SMASH_TAG)
	INSERT(def, char)
	INSERT(def, workspace.InvisibleParts)
	INSERT(def, otherItem)
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= player and p.Character then
			for _, v in pairs(p.Character:GetChildren()) do
				if v:IsA("Accessory") or v.Name == "HumanoidRootPart" or v.ClassName == "Configuration" then
					INSERT(def, v)
				end
			end
		end
	end
	return def
end
function ToolInterface:Remove()
	if self.Tool.Parent then
		self.Tool.Parent = ReplicatedStorage
		self.Tool:Destroy()
	end
	self = nil
end
function ToolInterface:TriggerEffect(effectTable)
	local sendTable = {}
	for i, v in ipairs(effectTable) do
		if v.ClassName == "Sound" then
			v:Play()
		elseif v:IsA("SpotLight") or v:IsA("ParticleEmitter") then
			spawn(function()
				v.Enabled = true
				wait(0.05)
				v.Enabled = false
			end)
		end
		table.insert(sendTable, {
			v.Name,
			v.ClassName
		})
	end
	self.EffectRemote:Fire(self.Tool, sendTable)
end
function ToolInterface:MakeTrack(id)
	local animation = Instance.new("Animation")
	animation.AnimationId = id
	local track = self.Humanoid:LoadAnimation(animation)
	animation:Destroy()
	return track
end
return ToolInterface

 

  
