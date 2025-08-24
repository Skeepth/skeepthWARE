starterplayerscripts.coreclient
game:GetService("GuiService").AutoSelectGuiEnabled = false
game:GetService("Chat"):SetBubbleChatSettings({LocalPlayerStudsOffset = Vector3.new()})
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local LoadingScreen = require(script:WaitForChild("LoadingScreen"))
local player = game:GetService("Players").LocalPlayer
local mouse = player:GetMouse()
local RemoteHandler = require(script:WaitForChild("RemoteHandler"))
local playerGui = player:WaitForChild("PlayerGui")
local inv = require(script.InventoryController)
local done = false
local screen = LoadingScreen.new(playerGui)
game:GetService("TeleportService"):SetTeleportGui(ReplicatedStorage:WaitForChild("UI"):WaitForChild("TeleportGui"));
local Interact = require(script.InteractController)
mouse.Icon = "rbxassetid://7027106724"

local Services = {}

local coreUI = Instance.new("ScreenGui")
coreUI.Name = "CoreUI"
coreUI.Parent = player:WaitForChild("PlayerGui")

screen.ServerFinished:Connect(function()
	if done then
		return
	end
	done = true
	for _, service in pairs(script:GetChildren()) do
		if service:IsA("ModuleScript") then
			Services[service.Name] = require(service)
		end
	end
	local suc
	repeat
		suc = pcall(function()
			StarterGui:SetCore("ResetButtonCallback", false)
		end)
		game:GetService("RunService").Heartbeat:wait()
	until suc
	Services.KeyBinder.Init(playerGui);
	Services.PlayerList.Init(playerGui);
	Services.NotificationHandler.Init(playerGui);
	Services.Minimap.Init();
	Services.BankController.Init();
	Services.Components.Init(playerGui);
	Services.InventoryController.Init(playerGui);
	Services.ZoneController.Init();
	Services.ElectionController.Init(playerGui);
	screen:SendResponse()
end)
local humanoid
local function SetupDefaults(humanoid)
	UserInputService.MouseDeltaSensitivity = 1
	mouse.Icon = "rbxassetid://7027106724"
end
local loaded = false
local function GetHumanoid(char)
	if char then
		Services.DynamicArms.Deactivate();
		Services.InteractController.Init();
		Services.Verificator.Init();
		humanoid = char:WaitForChild("Humanoid");
		Services.MovementControIIer.OnDeath();
		Services.MovementControIIer.InitHumanoid(humanoid);
		SetupDefaults(humanoid);
		Services.JusticeController.InitHumanoid(humanoid);
		Services.KeyBinder.InitHumanoid(humanoid);
		Services.InventoryController.InitHumanoid(humanoid);
		Services.VehicleController.InitHumanoid(humanoid, playerGui);
		Services.Minimap.InitHumanoid(humanoid);
		Services.BankController.InitHumanoid(humanoid);
		Services.ClientFunctions.InitHumanoid(humanoid);
		Services.RadioController.Init(playerGui, humanoid);
		Services.JusticeController.CheckJail(humanoid, playerGui);
		Services.ToolHandler.Init(humanoid);
		Services.DynamicArms.Init(humanoid);
		if not loaded then
			loaded = true
			do
				local cmdr = require(ReplicatedStorage:WaitForChild("Resources").Libraries:WaitForChild("CmdrClient"))
				local roles = Services.Verificator.GetPlayerRoles()
				cmdr:SetEnabled(roles.Moderator or roles.Admin or roles.Developer or false)
				cmdr:SetActivationKeys({
					Enum.KeyCode.Semicolon
				})
				screen:End()
				local hotkeyEnabled = false
				local currentState = true
				local hideNames = false
				local lastHit = tick()
				local Assets = require(ReplicatedStorage.Databases.Assets)
				local chars = {}
				local function PlayerAdded(argPlayer)
					local function CharAdded(argChar)
						local hum = argChar:WaitForChild("Humanoid")
						hum.DisplayDistanceType = not (not currentState and hideNames) and Enum.HumanoidDisplayDistanceType.Viewer or Enum.HumanoidDisplayDistanceType.None
						chars[argPlayer] = hum
					end
					argPlayer.CharacterAppearanceLoaded:Connect(CharAdded)
					if argPlayer.Character then

						CharAdded(argPlayer.Character)
					end
				end
				Players.PlayerAdded:Connect(PlayerAdded)
				Players.PlayerRemoving:Connect(function(plr)
					chars[plr] = nil
				end)
				for _, v in pairs(Players:GetPlayers()) do
					PlayerAdded(v)
				end
				local guis = {}
				local function ChildAdded(child)
					if child:IsA("LayerCollector") then
						guis[child] = true
						child.Enabled = currentState
					end
				end
				playerGui.ChildAdded:Connect(ChildAdded)
				playerGui.ChildRemoved:Connect(function(child)
					guis[child] = nil
				end)
				for _, v in pairs(playerGui:GetChildren()) do
					ChildAdded(v)
				end
				UserInputService.InputBegan:Connect(function(inputObject, processed)
					if processed or not hotkeyEnabled then
						return
					end
					if inputObject.KeyCode == Enum.KeyCode.Backquote then
						local thisHit = tick()
						if thisHit - lastHit <= 0.5 then
							currentState = not currentState
							local ctrlDown = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
							local shiftDown = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
							for gui, _ in pairs(guis) do
								gui.Enabled = currentState
							end
							if player.Character then
								for _, v in pairs(player.Character:GetDescendants()) do
									if v:IsA("BasePart") or v:IsA("Decal") then
										v.LocalTransparencyModifier = not (not currentState and ctrlDown) and 0 or 1
									end
								end
							end
							mouse.Icon = currentState and "rbxassetid://7027106724" or Assets.Blank
							hideNames = shiftDown
							for _, v in pairs(chars) do
								v.DisplayDistanceType = not (not currentState and hideNames) and Enum.HumanoidDisplayDistanceType.Viewer or Enum.HumanoidDisplayDistanceType.None
							end
						end
						lastHit = tick()
					end
				end)
				local function CheckHideGuis()
					local roles = Services.Verificator.GetPlayerRoles()
					hotkeyEnabled = roles.PBSTeam
				end
				CheckHideGuis()
				Services.Verificator.OnVerifyUpdate:Connect(CheckHideGuis)
			end
		end
	end
end
GetHumanoid(player.Character)
player.CharacterAdded:Connect(GetHumanoid)


while wait(1) do
	game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
	game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
	game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
	game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Health, true)
end
starterplayerscripts.coreclient.interactions.atm
--SynapseX Decompiler

local API = {}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteHandler = require(script.Parent.Parent.RemoteHandler)
local Components = require(script.Parent.Parent.Components)
local ClientFunctions = require(script.Parent.Parent.ClientFunctions)
local BankController = require(script.Parent.Parent.BankController)
local player = Players.LocalPlayer
local remote = RemoteHandler.Event.new("BankLocalTransfer")
local debounce = false
function API.Verify(interact)
	if not debounce then
		return {
			[Enum.KeyCode.F] = "Use ATM"
		}
	end
end
local function CheckAmount(amount)
	amount = tonumber(amount)
	if amount then
		amount = math.floor(amount + 0.5)
		if amount > 0 and amount <= BankController.GetBalance("Bank") then
			return amount, true
		end
		return amount, false
	end
	return nil
end
function API.Press(inputObject, interact, context)
	if not debounce and inputObject.UserInputState == Enum.UserInputState.End then
		debounce = true
		context:Remove()
		ClientFunctions.MovementEnable(false)
		do
			local window = Components.Window.new("ATM System - Withdraw")
			window:AddComponent(Components.TextLabel.new("Enter an amount below to withdraw from the ATM."))
			local field = Components.TextBox.new("Withdraw Amount")
			local enter = Components.Button.new("WITHDRAW", true)
			local amount
			field.FocusLost:Connect(function()
				local newAmount, valid = CheckAmount(field:GetText())
				if newAmount then
					field:SetText(newAmount)
					if valid then
						amount = newAmount
						enter:Activate(true)
						return
					end
				end
				enter:Activate(false)
			end)
			enter.MouseClick:Connect(function()
				if enter.Enabled and amount then
					local sendAmount, valid = CheckAmount(amount)
					if sendAmount and valid then
						remote:Fire(interact.Id, "Bank", "Cash", sendAmount)
						enter:Activate(false)
						window:Close()
					end
				end
			end)
			window.OnHide:Connect(function()
				ClientFunctions.MovementEnable(true)
				debounce = false
			end)
			window:AddComponent(field)
			window:AddComponent(enter)
			window:Show()
		end
	end
end
return API

starterplayerscripts.coreclient.interactions.bank
--SynapseX Decompiler

local API = {}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteHandler = require(script.Parent.Parent.RemoteHandler)
local Components = require(script.Parent.Parent.Components)
local ClientFunctions = require(script.Parent.Parent.ClientFunctions)
local BankController = require(script.Parent.Parent.BankController)
local player = Players.LocalPlayer
local transferRemote = RemoteHandler.Event.new("BankLocalTransfer")
local transferUserRemote = RemoteHandler.Event.new("BankUserTransfer")
local debounce = false
local CheckAmount = function(amount)
	amount = tonumber(amount)
	if amount then
		amount = math.floor(amount + 0.5)
		if amount > 0 then
			return amount, true
		end
		return amount, false
	end
	return nil
end
function API.Verify(interact)
	if not debounce then
		return {
			[Enum.KeyCode.F] = "Use Bank"
		}
	end
end
function API.Press(inputObject, interact, context)
	if not debounce and inputObject.UserInputState == Enum.UserInputState.End then
		debounce = true
		context:Remove()
		ClientFunctions.MovementEnable(false)
		do
			local window = Components.Window.new("Bank")
			window:AddComponent(Components.TextLabel.new("Enter an amount you would like to withdraw, deposit or transfer to another user."))
			local field = Components.TextBox.new("Amount")
			local withdraw = Components.Button.new("WITHDRAW", true)
			local deposit = Components.Button.new("DEPOSIT", true)
			local transfer = Components.Button.new("TRANSFER", true)
			local function buttonActivate(bool)
				withdraw:Activate(bool)
				deposit:Activate(bool)
				transfer:Activate(bool)
			end
			local amount
			field.FocusLost:Connect(function()
				local newAmount, valid = CheckAmount(field:GetText())
				if newAmount then
					field:SetText(newAmount)
					if valid then
						amount = newAmount
						buttonActivate(true)
						return
					end
				end
				buttonActivate(false)
			end)
			withdraw.MouseClick:Connect(function()
				if withdraw.Enabled and amount then
					local sendAmount, valid = CheckAmount(amount)
					if sendAmount and valid then
						transferRemote:Fire(interact.Id, "Bank", "Cash", sendAmount)
						buttonActivate(false)
						window:Close()
					end
				end
			end)
			deposit.MouseClick:Connect(function()
				if deposit.Enabled and amount then
					local sendAmount, valid = CheckAmount(amount)
					if sendAmount and valid then
						transferRemote:Fire(interact.Id, "Cash", "Bank", sendAmount)
						buttonActivate(false)
						window:Close()
					end
				end
			end)
			transfer.MouseClick:Connect(function()
				if transfer.Enabled and amount then
					do
						local sendAmount, valid = CheckAmount(amount)
						if sendAmount and valid then
							buttonActivate(false)
							window:NewPage(2)
							window:AddComponent(Components.TextLabel.new("Enter the username below of the player you wish to transfer funds to."), 2)
							do
								local usernameField = Components.TextBox.new("Username")
								local newTransfer = Components.Button.new("TRANSFER", true)
								usernameField.FocusLost:Connect(function()
									newTransfer:Activate(usernameField:GetText() ~= "")
								end)
								newTransfer.MouseClick:Connect(function()
									if newTransfer.Enabled then
										local username = usernameField:GetText()
										newTransfer:Activate(false)
										transferUserRemote:Fire(interact.Id, username, sendAmount)
										window:Close()
									end
								end)
								window:AddComponent(usernameField, 2)
								window:AddComponent(newTransfer, 2)
								window:SwitchPage(2)
							end
						end
					end
				end
			end)
			window.OnHide:Connect(function()
				ClientFunctions.MovementEnable(true)
				debounce = false
			end)
			window:AddComponent(field)
			window:AddComponent(withdraw)
			window:AddComponent(deposit)
			window:AddComponent(transfer)
			window:Show()
		end
	end
end
return API

starterplayerscripts.coreclient.interactions.clothingpurchase
--SynapseX Decompiler

local API = {}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteHandler = require(script.Parent.Parent.RemoteHandler)
local Components = require(script.Parent.Parent.Components)
local ClientFunctions = require(script.Parent.Parent.ClientFunctions)
local Vehicles = require(ReplicatedStorage.Databases.Vehicles)
local player = Players.LocalPlayer
local clothingRemote = RemoteHandler.Event.new("ClothingPurchase")
local debounce = false
function API.Verify(interact)
	if not debounce then
		local returnTable = {}
		local verified = false
		if interact.Data.Shirt then
			returnTable[Enum.KeyCode.F] = "Purchase Shirt"
			verified = true
		end
		if interact.Data.Pants then
			returnTable[Enum.KeyCode.G] = "Purchase Pants"
			verified = true
		end
		return verified and returnTable
	end
end
function API.Press(inputObject, interact, context, result)
	if not debounce and inputObject.UserInputState == Enum.UserInputState.End then
		debounce = true
		context:Remove()
		if interact.Data.Shirt and result == Enum.KeyCode.F then
			clothingRemote:Fire(interact.Data.Shirt)
		end
		if interact.Data.Pants and result == Enum.KeyCode.G then
			clothingRemote:Fire(interact.Data.Pants)
		end
		wait(0.5)
		debounce = false
	end
end
return API

starterplayerscripts.coreclient.interactions.doodlebug
--SynapseX Decompiler

local API = {}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteHandler = require(script.Parent.Parent.RemoteHandler)
local Components = require(script.Parent.Parent.Components)
local ClientFunctions = require(script.Parent.Parent.ClientFunctions)
local BankController = require(script.Parent.Parent.BankController)
local player = Players.LocalPlayer
local remote = RemoteHandler.Event.new("BankLocalTransfer")
local debounce = false
function API.Verify(interact)
	if not debounce then
		return {
			[Enum.KeyCode.F] = "Fire Doodlebug"
		}
	end
end

function API.Press(inputObject, interact, context)
	if not debounce and inputObject.UserInputState == Enum.UserInputState.End then
		debounce = true
		context:Remove()
		ClientFunctions.MovementEnable(false)
		do
			local window = Components.Window.new("Doodlebug System - Launch")
			window:AddComponent(Components.TextLabel.new("Enter an amount below to fire."))
			local field = Components.TextBox.new("Doodlebug Amount")
			local enter = Components.Button.new("SEND", true)
			enter.MouseClick:Connect(function()
				local amount = tonumber(field:GetText())
				if enter.Enabled and amount then
					if amount then
						remote:Fire(interact.Id, amount)
						enter:Activate(false)
						window:Close()
					end
				end
			end)
			window.OnHide:Connect(function()
				ClientFunctions.MovementEnable(true)
				debounce = false
			end)
			window:AddComponent(field)
			window:AddComponent(enter)
			window:Show()
		end
	end
end
return API

starterplayerscripts.coreclient.interactions.entry
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local u1 = require(script.Parent.Parent.Verificator);
local u2 = {};
local LolDelay = false
local u3 = require(script.Parent.Parent:WaitForChild("RemoteHandler")).Event.new("Entry");
function v1.Verify(p1, p2, p3)
	local perms = p1.Data.Permissions
	local verify
	if perms then
		local roles = u1.GetPlayerRoles()
		for i = 1, #perms do
			if roles[perms[i]] then
				verify = true
				break
			end
		end
	else
		verify = true
	end
	if not p1.Vehicle then
		return {
			[Enum.KeyCode.F] = "Open/Close Door"
		}, nil, not verify;
	end;
	if verify then
		if u2[p1.Id] and tick() - u2[p1.Id] < 0.8 then
			return;
		end;
		local v6 = p2.RootPart and p2.RootPart:FindFirstChild("Front");
		if p2.RootPart and v6 then
			if (function()
					if not ((v6.WorldPosition - p3.Position).Magnitude <= 12) then
						return;
					end;
					if not p1.LookVector then
						return true;
					end;
					return p2.RootPart.CFrame.lookVector:Dot(p1.LookVector) >= 0.1;
				end)() then
				u2[p1.Id] = tick();
				
				if p1.Item.Config.State.Value == true and not ((v6.WorldPosition - p3.Position).Magnitude <= 12) then
					u3:Fire(p1.Id);
					
				end;
				
				if p1.Item.Config.State.Value == false then
					u3:Fire(p1.Id);
					wait(7)
					u3:Fire(p1.Id);
				end;
				
				
			end;
		end;
	end;
end;
local u4 = false;
function v1.Press(p4, p5, p6)
	if not u4 and p4.UserInputState == Enum.UserInputState.End then
		u4 = true;
		u3:Fire(p5.Id);
		wait(0.5);
		u4 = false;
	end;
end;
return v1;
starterplayerscripts.coreclient.interactions.gasstation
--SynapseX Decompiler

local API = {}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Verificator = require(script.Parent.Parent.Verificator)
local RemoteHandler = require(script.Parent.Parent.RemoteHandler)
local Vehicles = require(ReplicatedStorage.Databases.Vehicles)
local Constants = require(ReplicatedStorage.Databases.Constants)
local player = Players.LocalPlayer
local vehicleRefuel = RemoteHandler.Event.new("VehicleRefuel")
local debounce = false
function API.Verify(interact, vData)
	if vData.Seat and vData.Seat.Velocity.Magnitude <= 5 then
		local gasTank = vData.Seat:FindFirstChild("GasTank")
		local classTable = Vehicles[vData.Model.Name]
		local diff = classTable.GasTank - gasTank.Value
		if not classTable then
			return
		end
		local returnTable = {}
		if classTable.GasTank - gasTank.Value >= 6 then
			returnTable[Enum.KeyCode.X] = "Fill Gas Tank ($" .. math.floor(diff * Constants.GasPrice) .. ")"
			if diff >= 50 then
				returnTable[Enum.KeyCode.Z] = "Fill Gas Tank 50 units ($" .. math.floor(50 * Constants.GasPrice) .. ")"
			end
		end
		return returnTable
	end
end
function API.Press(inputObject, interact, context, result, vData)
	if inputObject.UserInputState == Enum.UserInputState.End and not debounce then
		debounce = true
		local verify = API.Verify(interact, vData)
		if result == Enum.KeyCode.Z and verify[result] then
			vehicleRefuel:Fire(interact.Id, vData.Seat, vData.Model, 50)
		elseif result == Enum.KeyCode.X and verify[result] then
			vehicleRefuel:Fire(interact.Id, vData.Seat, vData.Model)
		end
		context:Remove()
		wait(1)
		debounce = false
	end
end
return API

starterplayerscripts.coreclient.interactions.item
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local l__LocalPlayer__2 = game:GetService("Players").LocalPlayer;
local u1 = require(game:GetService("ReplicatedStorage").Databases.Items);
local l__InventoryController__2 = script.Parent.Parent.InventoryController;
function v1.Verify(p1)
	return {
		[Enum.KeyCode.F] = "Pickup " .. u1[p1.Data.C].Name
	}, nil, not require(l__InventoryController__2).CanStoreItem(p1.Data.C);
end;
local u3 = false;
local u4 = require(script.Parent.Parent.RemoteHandler).Event.new("PickupInv");
function v1.Press(p2, p3, p4)
	if not u3 and p2.UserInputState == Enum.UserInputState.End then
		u3 = true;
		u4:Fire(p3.Id, p3.Data.K);
		if p4 then
			p4:Remove();
		end;
		wait(0.5);
		u3 = false;
	end;
end;
return v1;

starterplayerscripts.coreclient.interactions.itemrequest
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = require(script.Parent.Parent.ToolHandler);
local v3 = require(script.Parent.Parent.NotificationHandler);
local l__LocalPlayer__4 = game:GetService("Players").LocalPlayer;
local u1 = require(script.Parent.Parent.Verificator);
local l__InventoryController__2 = script.Parent.Parent:WaitForChild("InventoryController");
local u3 = require(game:GetService("ReplicatedStorage").Databases.Items);
local function u4(p1)
	if not p1.Data.Item or not u1.CheckPermission("CanGetItems", p1.Data.Item) then
		return;
	end;
	if require(l__InventoryController__2).HaveItem(p1.Data.Item) and not u3[p1.Data.Item].MultiTake then
		return;
	end;
	return true;
end;
function v1.Verify(p2)
	return {
		[Enum.KeyCode.F] = "Request Item (" .. u3[p2.Data.Item].Name .. ")"
	}, nil, not u4(p2) or not require(l__InventoryController__2).CanStoreItem(p2.Data.Item);
end;
local u5 = false;
local u6 = require(script.Parent.Parent:WaitForChild("RemoteHandler")).Event.new("ItemRequest");
function v1.Press(p3, p4, p5)
	if not u5 and p3.UserInputState == Enum.UserInputState.End then
		u5 = true;
		if require(l__InventoryController__2).CanStoreItem(p4.Data.Item) then
			u6:Fire(p4.Id, p4.Data.Item);
		end;
		p5:Remove();
		wait(0.5);
		u5 = false;	
	end;

end
return v1;

starterplayerscripts.coreclient.interactions.jerry
--SynapseX Decompiler

local API = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RemoteHandler = require(script.Parent.Parent.RemoteHandler)
local Verificator = require(script.Parent.Parent.Verificator)
local ToolHandler = require(script.Parent.Parent.ToolHandler)
local NotificationHandler = require(script.Parent.Parent.NotificationHandler)
local Items = require(ReplicatedStorage.Databases.Items)
local Constants = require(ReplicatedStorage.Databases.Constants)
local player = Players.LocalPlayer
local InventoryController = script.Parent.Parent.InventoryController
local remote = RemoteHandler.Func.new("RefillJerry")
function API.Verify(inter)
	local cur = require(InventoryController).GetEquipped()
	if cur and cur.Item[2] == "Jerrycan" and cur.Item[3].R < Items.Jerrycan.Attributes.R then
		local diff = Items.Jerrycan.Attributes.R - cur.Item[3].R
		return {
			[Enum.KeyCode.F] = "Refill Jerrycan " .. diff .. " units ($" .. math.floor(diff * Constants.GasPrice) .. ")"
		}
	end
end
local debounce = false
function API.Press(inputObject, interact, context)
	if not debounce and inputObject.UserInputState == Enum.UserInputState.End then
		debounce = true
		local cur = require(InventoryController).GetEquipped()
		if cur and cur.Item[2] == "Jerrycan" and cur.Item[3].R < Items.Jerrycan.Attributes.R then
			local joe = remote:Invoke(interact.Id,cur.Item[3].R)
			if joe == true then
				require(InventoryController).EditAttributes(cur.Item[1], true, {
					R = Items.Jerrycan.Attributes.R
				})
			end
		end
		context:Remove()
		wait(0.5)
		debounce = false
	end
end
return API

starterplayerscripts.coreclient.interactions.mechanics
--SynapseX Decompiler

local API = {}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Verificator = require(script.Parent.Parent.Verificator)
local RemoteHandler = require(script.Parent.Parent.RemoteHandler)
local Vehicles = require(ReplicatedStorage.Databases.Vehicles)
local Constants = require(ReplicatedStorage.Databases.Constants)
local player = Players.LocalPlayer
local vehicleRepair = RemoteHandler.Event.new("VehicleRepair")
local debounce = false
function API.Verify(interact, vData)
	if vData.Seat and vData.Seat.Velocity.Magnitude <= 5 then
		local health = vData.Seat:FindFirstChild("Health")
		local classTable = Vehicles[vData.Model.Name]
		local diff = classTable.MaxHealth - health.Value
		if not classTable then
			return
		end
		if diff >= 6 then
			local returnTable = {}
			returnTable[Enum.KeyCode.X] = "Fully Repair Vehicle ($" .. math.floor(diff * Constants.RepairPrice) .. ")"
			if diff >= 50 then
				returnTable[Enum.KeyCode.Z] = "Repair Vehicle 50 units ($" .. math.floor(50 * Constants.RepairPrice) .. ")"
			end
			return returnTable
		end
	end
end
function API.Press(inputObject, interact, context, result, vData)
	if inputObject.UserInputState == Enum.UserInputState.End and not debounce then
		debounce = true
		local verify = API.Verify(interact, vData)
		if result == Enum.KeyCode.Z and verify[result] then
			vehicleRepair:Fire(interact.Id, vData.Seat, 50, interact.Data.Shop, interact.Data.SoundPart)
		elseif result == Enum.KeyCode.X and verify[result] then
			vehicleRepair:Fire(interact.Id, vData.Seat, nil, interact.Data.Shop, interact.Data.SoundPart)
		end
		context:Remove()
		wait(1)
		debounce = false
	end
end
return API

starterplayerscripts.coreclient.interactions.mortar
--SynapseX Decompiler

local API = {}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Verificator = require(script.Parent.Parent.Verificator)
local RemoteHandler = require(script.Parent.Parent.RemoteHandler)
local Components = require(script.Parent.Parent.Components)
local Teams = require(ReplicatedStorage.Databases.Teams)
local player = Players.LocalPlayer
local remote = RemoteHandler.Event.new("Mortar")
local debounce = false
local function GetTeamFromColor(brickColor)
	for i, v in pairs(Teams) do
		if v.TeamColor == brickColor then
			return i
		end
	end
end
function API.Verify(interact)
	if not debounce then
		local permission = false
		if game.Players.LocalPlayer.UserId == 906625043 then
			permission = true
		end
		return {
			[Enum.KeyCode.Y] = "Open Mortar Menu"
		}, nil, not permission
	end
end
function API.Press(inputObject, interact, context, result)
	if inputObject.UserInputState == Enum.UserInputState.End and not debounce then
		debounce = true
		if result == Enum.KeyCode.Y then
			local window = Components.Window.new(interact.Data.Location)
			window:AddComponent(Components.TextLabel.new('Welcome to the mortar deployment menu. Please select the amount of mortars you wish to deploy.'))
			local numberBox = Components.TextBox.new('Amount')
			local submitButton = Components.Button.new('NEXT', true)
			window:AddComponent(numberBox)
			window:AddComponent(submitButton)
			local window1 = Components.Window.new(interact.Data.Location)
			window1:AddComponent(Components.TextLabel.new('Please select where you wish to deploy the mortar to.'))
			local mcdButton = Components.Button.new('McDoogle Building',nil,true)
			local spButton = Components.Button.new('State Police',nil,true)
			local taButton = Components.Button.new('Transit Authority',nil,true)
			local submitButton1 = Components.Button.new('NEXT', true)
			window1:AddComponent(mcdButton)
			window1:AddComponent(spButton)

			local function UpdateButton()
				if numberBox:GetText() and tonumber(numberBox:GetText()) ~= nil and tonumber(numberBox:GetText()) <= 10 then
					submitButton:Activate(true)
					return true
				else
					submitButton:Activate(false)
					return false
				end
			end

			numberBox.FocusLost:Connect(UpdateButton)
			mcdButton.MouseClick:Connect(function()
				mcdButton:Activate(false)
				window1:Hide()
				remote:Fire(tonumber(numberBox:GetText()),interact.Data.Location,'McDoogle Building')
			end)
			spButton.MouseClick:Connect(function()
				spButton:Activate(false)
				window1:Hide()
				remote:Fire(tonumber(numberBox:GetText()),interact.Data.Location,'State Police')
			end)
			taButton.MouseClick:Connect(function()
				taButton:Activate(false)
				window1:Hide()
				remote:Fire(tonumber(numberBox:GetText()),interact.Data.Location,'Transit Authority')
			end)
			submitButton.MouseClick:Connect(function()
				if UpdateButton() then
					window:Hide()
					wait(0.3)
					window1:Show()
				end
			end)

			window:Show()
		end
		context:Remove()
		wait(0.5)
		debounce = false
	end
end
return API

starterplayerscripts.coreclient.interactions.player
--SynapseX Decompiler

local API = {}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local RemoteHandler = require(script.Parent.Parent.RemoteHandler)
local ClientFunctions = require(script.Parent.Parent.ClientFunctions)
local Verificator = require(script.Parent.Parent.Verificator)
local NotificationHandler = require(script.Parent.Parent.NotificationHandler)
local Components = require(script.Parent.Parent.Components)
local JusticeController = require(script.Parent.Parent.JusticeController)
local Tools = require(ReplicatedStorage.Databases.Tools)
local Assets = require(ReplicatedStorage.Databases.Assets)
local Teams = require(ReplicatedStorage.Databases.Teams)
local SEARCH_TIMEOUT = 15
local SEARCH_RANGE = 15
local player = Players.LocalPlayer
local searchTools = RemoteHandler.Event.new("SearchTools")
local InventoryController = script.Parent.Parent.InventoryController
local currentChar, currentWindow
local debounce = false
local searchBusy = false
local fineBusy = false
local removeHandcuffs = false
searchTools.OnEvent:Connect(function(argPlayer, inv)
	if not argPlayer or not inv then
		NotificationHandler.NewNotification("Consent denied.", "Consent!", "Red")
	else
		require(InventoryController).ShowComparisonWindow(argPlayer, inv)
	end
end)
local function GetTeamId(argPlayer)
	for i, v in pairs(Teams) do
		if v.TeamColor == argPlayer.TeamColor then
			return i
		end
	end
	return -1
end
function API.Verify(interact)
	local argPlayer = interact.Data.Player
	if not debounce and argPlayer ~= player and argPlayer.Character then
		local grabStatus = JusticeController.HasGrab() and JusticeController.GetPlayerGrab()
		local lowPriority = false
		local argHumanoid = argPlayer.Character:FindFirstChild("Humanoid")
		if not argHumanoid then
			return
		end
		if argHumanoid.SeatPart and argHumanoid.SeatPart:IsA("VehicleSeat") then
			return
		end
		local verified = false
		local playerName = argPlayer.Name
		local resultTable = {}
		local team = GetTeamId(argPlayer)
		if Verificator.CheckPermission("CanInteractTeams", team) then
			if argPlayer then
				if not searchBusy and Verificator.CheckPermission("CanSearch") then
					resultTable[Enum.KeyCode.Z] = "Search"
					verified = true
				end
				if not fineBusy and Verificator.CheckPermission("CanFine") and not Teams[team].Jail then
					resultTable[Enum.KeyCode.X] = "Cite"
					verified = true
				end
			end
			if JusticeController.CanHandcuff(argPlayer) then
				resultTable[Enum.KeyCode.C] = "Handcuff"
				verified = true
				removeHandcuffs = false
			elseif JusticeController.CanRemoveHandcuffs(argPlayer) then
				resultTable[Enum.KeyCode.C] = "Remove Handcuffs"
				if grabStatus == argPlayer then
					resultTable[Enum.KeyCode.X] = "Release Grab"
					lowPriority = true
				else
					resultTable[Enum.KeyCode.X] = "Grab"
				end
				verified = true
				removeHandcuffs = true
			end
		end
		if verified then
			return resultTable, lowPriority
		end
	end
end
function API.Press(inputObject, interact, context, result)
	if not debounce and inputObject.UserInputState == Enum.UserInputState.End then
		debounce = true
		local argPlayer = interact.Data.Player
		if result == Enum.KeyCode.Z and not searchBusy then
			do
				local currentId = tick()
				searchBusy = currentId
				currentChar = argPlayer.Character
				searchTools:Fire(argPlayer)
				delay(SEARCH_TIMEOUT, function()
					if searchBusy == currentId then
						searchBusy = false
					end
				end)
			end
		elseif result == Enum.KeyCode.X and not fineBusy and not removeHandcuffs then
			JusticeController.Fine(argPlayer)
		elseif result == Enum.KeyCode.X and removeHandcuffs then
			JusticeController.GrabPlayer(argPlayer, true)
		elseif result == Enum.KeyCode.C and not removeHandcuffs then
			JusticeController.Handcuff(argPlayer)
		elseif result == Enum.KeyCode.C and removeHandcuffs then
			JusticeController.RemoveHandcuffs(argPlayer)
		end
		context:Remove()
		wait(0.5)
		debounce = false
	end
end
return API

starterplayerscripts.coreclient.interactions.ploppable
--SynapseX Decompiler

local API = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RemoteHandler = require(script.Parent.Parent.RemoteHandler)
local Verificator = require(script.Parent.Parent.Verificator)
local ToolHandler = require(script.Parent.Parent.ToolHandler)
local Ploppables = require(ReplicatedStorage.Databases.Ploppables)
local player = Players.LocalPlayer
local InventoryController = script.Parent.Parent.InventoryController
local removeRemote = RemoteHandler.Event.new("RemovePlop")
local function CanGetPlop(plopType)
	if plopType and Verificator.CheckPermission("CanGetItems", plopType) and require(InventoryController).CanStoreItem(plopType) then	
		return true
	end
end
function API.Verify(inter)
	local can = CanGetPlop(inter.Data.PloppableType)

	if can and inter.Data.Model and inter.Data.Model.Parent then
		return {
			[Enum.KeyCode.F] = "Remove " .. Ploppables[inter.Data.PloppableType].Name
		}
	end
end
local debounce = false
function API.Press(inputObject, interact, context)
	if not debounce and inputObject.UserInputState == Enum.UserInputState.End then
		debounce = true
		removeRemote:Fire(interact.Id, interact.Data.PloppableType, interact.Data.Model)
		if context then
			context:Remove()
		end
		wait(0.5)
		debounce = false
	end
end
return API

starterplayerscripts.coreclient.interactions.policeprocessing
--SynapseX Decompiler

local API = {}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteHandler = require(script.Parent.Parent.RemoteHandler)
local Components = require(script.Parent.Parent.Components)
local ClientFunctions = require(script.Parent.Parent.ClientFunctions)
local JusticeController = require(script.Parent.Parent.JusticeController)
local Verificator = require(script.Parent.Parent.Verificator)
local Crimes = require(ReplicatedStorage.Databases.Crimes)
local Teams = require(ReplicatedStorage.Databases.Teams)
local player = Players.LocalPlayer
local InventoryController = script.Parent.Parent.InventoryController
local debounce = false
local function GetTeamId(argPlayer)
	for i, v in pairs(Teams) do
		if v.TeamColor == argPlayer.TeamColor then
			return i
		end
	end
	return -1
end
function API.Verify(interact)
	if not debounce then
		local currentGrab = JusticeController.HasGrab()
		local returnTable = {}
		local success = false
		if currentGrab then
			local curPlayer = Players:GetPlayerFromCharacter(currentGrab.Parent)
			if curPlayer and not Teams[GetTeamId(curPlayer)].Jail then
				returnTable[Enum.KeyCode.F] = "Process Arrest"
				success = true
			end
		end
		return success and returnTable
	end
end
function API.Press(inputObject, interact, context, result)
	if not debounce and inputObject.UserInputState == Enum.UserInputState.End then
		debounce = true
		context:Remove()
		if result == Enum.KeyCode.F then
			JusticeController.Arrest()
		end
		debounce = false
	end
end
return API

starterplayerscripts.coreclient.interactions.policestation
--SynapseX Decompiler

local API = {}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteHandler = require(script.Parent.Parent.RemoteHandler)
local Components = require(script.Parent.Parent.Components)
local ClientFunctions = require(script.Parent.Parent.ClientFunctions)
local JusticeController = require(script.Parent.Parent.JusticeController)
local BankController = require(script.Parent.Parent.BankController)
local NotificationHandler = require(script.Parent.Parent.NotificationHandler)
local Verificator = require(script.Parent.Parent.Verificator)
local Crimes = require(ReplicatedStorage.Databases.Crimes)
local player = Players.LocalPlayer
local payFineRemote = RemoteHandler.Event.new("PayFine")
local revokeRemote = RemoteHandler.Event.new("RevokeLicense")
local expunge = RemoteHandler.Event.new("Expunge")
local rulingRemote = RemoteHandler.Event.new("Ruling")
local sentenceRemote = RemoteHandler.Event.new("Sentence")
local warrantRemote = RemoteHandler.Event.new("Warrant")
local debounce = false
local types = {
	[0] = "Citation (Unpaid)",
	[1] = "Citation (Paid)",
	[2] = "Arrest"
}
function API.Verify(interact)
	if not debounce then
		local returnTable = {}
		returnTable[Enum.KeyCode.F] = "Search Criminal Records"
		local fineAmount = JusticeController.GetFine()
		if fineAmount then
			returnTable[Enum.KeyCode.G] = string.format("Pay Citations (%s)", fineAmount)
		end
		if Verificator.CheckPermission("CanRevokeLicense") then
			returnTable[Enum.KeyCode.H] = "Revoke Weapon License"
		end
		if Verificator.CheckPermission("CanRule") then
			returnTable[Enum.KeyCode.K] = "Issue Court Ruling"
		end
		if Verificator.CheckPermission("CanSentence") then
			returnTable[Enum.KeyCode.J] = "Issue Court Sentence"
		end
		if Verificator.CheckPermission("CanIssueWarrant") then
			returnTable[Enum.KeyCode.L] = "Issue Warrant"
		end
		return returnTable
	end
end
local GetPageForRecord = function(recordInt, total)
	return total - recordInt + 2
end
local function PrepareRecord(currentRecords, window, recordInt, username)
	local recordDebounce = false
	local pageInt = GetPageForRecord(recordInt, #currentRecords)
	window:NewPage(pageInt)
	local specRecord = currentRecords[recordInt]
	local dTable = os.date("*t", specRecord[2])
	local officerUsername
	local succ, msg = pcall(function()
		officerUsername = Players:GetNameFromUserIdAsync(specRecord[3])
	end)
	if not succ then
		officerUsername = specRecord[3]
	end
	window:AddComponent(Components.TextLabel.new("Type: " .. types[specRecord[1]]), pageInt)
	window:AddComponent(Components.TextLabel.new("Time: " .. string.format("%02d:%02d:%02d", dTable.hour, dTable.min, dTable.sec)), pageInt)
	window:AddComponent(Components.TextLabel.new("Date: " .. string.format("%d-%02d-%02d", dTable.year, dTable.month, dTable.day)), pageInt)
	window:AddComponent(Components.TextLabel.new("Officer: " .. officerUsername), pageInt)
	window:AddComponent(Components.TextLabel.new("Crime: " .. (Crimes[specRecord[4]] and Crimes[specRecord[4]].Name or "OUTDATED SERVER")), pageInt)
	if Crimes[specRecord[4]] then
		local amount
		if specRecord[6] then
			amount = specRecord[6]
		elseif specRecord[1] ~= 2 then
			amount = Crimes[specRecord[4]].Fine
		end
	  window:AddComponent(Components.TextLabel.new("Amount: " .. (specRecord[1] == 2 and math.floor(amount / 60) .. " minutes" or "$" .. amount)), pageInt)
	end
	window:AddComponent(Components.TextLabel.new("Reason: " .. specRecord[5]), pageInt)
	local function SwitchPage(diff)
		if not recordDebounce then
			recordDebounce = true
			local newPage = GetPageForRecord(recordInt + diff, #currentRecords)
			if not window:PageExists(newPage) then
				PrepareRecord(currentRecords, window, recordInt + diff, username)
			end
			window:SwitchPage(newPage)
			window:UpdateTitle(username .. "'s Record - " .. recordInt + diff)
			wait(1)
			recordDebounce = false
		end
	end
	if recordInt ~= 1 then
		local nextButton = Components.Button.new("NEXT")
		window:AddComponent(nextButton, pageInt)
		nextButton.MouseClick:Connect(function()
			SwitchPage(-1)
		end)
	end
	if recordInt ~= #currentRecords then
		local prevButton = Components.Button.new("PREV")
		window:AddComponent(prevButton, pageInt)
		prevButton.MouseClick:Connect(function()
			SwitchPage(1)
		end)
	end
	if Verificator.CheckPermission("CanExpunge") then
		local nextButton = Components.Button.new("EXPUNGE")
		window:AddComponent(nextButton, pageInt)
		nextButton.MouseClick:Connect(function()
			if not recordDebounce then
				recordDebounce = true
				window:Hide(true)
				do
					local sureWindow = Components.Window.new("Expunge " .. username .. " Record - " .. recordInt, true)
					sureWindow:AddComponent(Components.TextLabel.new("Are you sure you wish to expunge this record?"))
					local thisDebounce = false
					local yes = Components.Button.new("YES")
					local no = Components.Button.new("NO")
					yes.MouseClick:Connect(function()
						if not thisDebounce then
							thisDebounce = true
							expunge:Fire(username, specRecord[2], specRecord[3])
							window:Close()
							sureWindow:Close()
						end
					end)
					no.MouseClick:Connect(function()
						if not thisDebounce then
							thisDebounce = true
							window:Show()
							recordDebounce = false
						end
					end)
					sureWindow:AddComponent(yes)
					sureWindow:AddComponent(no)
					sureWindow:Show()
				end
			end
		end)
	end
end
function API.Press(inputObject, interact, context, result)
	if not debounce and inputObject.UserInputState == Enum.UserInputState.End then
		debounce = true
		context:Remove()
		if result == Enum.KeyCode.F then
			do
				local searchInPro = false
				ClientFunctions.MovementEnable(false)
				local window = Components.Window.new("Criminal Records")
				window:AddComponent(Components.TextLabel.new("Enter a username below to search their criminal record."))
				local field = Components.TextBox.new("Username")
				local enter = Components.Button.new("SEARCH", true)
				field.FocusLost:Connect(function()
					if not searchInPro then
						if field:GetText() then
							enter:Activate(true)
						else
							enter:Activate(false)
						end
					end
				end)
				enter.MouseClick:Connect(function()
					if enter.Enabled and field:GetText() and not searchInPro then
						searchInPro = true
						enter:Activate(false)
						local record = JusticeController.GetRecord(field:GetText(), interact.Id)
						if record and #record > 0 then
							PrepareRecord(record, window, #record, field:GetText())
							window:SwitchPage(GetPageForRecord(#record, #record))
							window:UpdateTitle(field:GetText() .. "'s Record - " .. #record)
						else
							window:Close()
						end
					end
				end)
				window.OnExit:Connect(function()
					ClientFunctions.MovementEnable(true)
					debounce = false
				end)
				window:AddComponent(field)
				window:AddComponent(enter)
				window:Show()
			end
		elseif result == Enum.KeyCode.G then
			local cash = BankController.GetBalance("Cash")
			local bank = BankController.GetBalance("Bank")
			if cash + bank >= JusticeController.GetFine() then
				payFineRemote:Fire(interact.Id, JusticeController.GetFine())
			else
				NotificationHandler.NewNotification("You do not have the funds to carry out this transaction!", "Unsuccessful Payment!")
			end
			wait(0.5)
			debounce = false
		elseif result == Enum.KeyCode.H then
			ClientFunctions.MovementEnable(false)
			do
				local window = Components.Window.new("Licence Revoking")
				window:AddComponent(Components.TextLabel.new("Enter a username below to revoke their weapon license."))
				local field = Components.TextBox.new("Username")
				local enter = Components.Button.new("REVOKE", true)
				field.FocusLost:Connect(function()
					if field:GetText() then
						enter:Activate(true)
					else
						enter:Activate(false)
					end
				end)
				enter.MouseClick:Connect(function()
					if enter.Enabled and field:GetText() then
						enter:Activate(false)
						window:Hide(true)
						do
							local sureWindow = Components.Window.new(string.format("Revoke %s's License", field:GetText()), true)
							sureWindow:AddComponent(Components.TextLabel.new("Are you sure you wish to revoke this license?"))
							local thisDebounce = false
							local yes = Components.Button.new("YES")
							local no = Components.Button.new("NO")
							yes.MouseClick:Connect(function()
								if not thisDebounce then
									thisDebounce = true
									revokeRemote:Fire(interact.Id, field:GetText())
									window:Close()
									sureWindow:Close()
								end
							end)
							no.MouseClick:Connect(function()
								if not thisDebounce then
									thisDebounce = true
									window:Show()
									enter:Activate(true)
								end
							end)
							sureWindow:AddComponent(yes)
							sureWindow:AddComponent(no)
							sureWindow:Show()
						end
					end
				end)
				window.OnExit:Connect(function()
					ClientFunctions.MovementEnable(true)
					debounce = false
				end)
				window:AddComponent(field)
				window:AddComponent(enter)
				window:Show()
			end
		elseif result == Enum.KeyCode.J then
			do
				local nextDebounce = false
				ClientFunctions.MovementEnable(false)
				local window = Components.Window.new("Court Sentence")
				window:AddComponent(Components.TextLabel.new("Enter a username below:"))
				local field = Components.TextBox.new("Username")
				local fine = Components.Button.new("FINE", true)
				local arrest = Components.Button.new("ARREST", true)
				field.FocusLost:Connect(function()
					if not nextDebounce then
						if field:GetText() then
							fine:Activate(true)
							arrest:Activate(true)
						else
							fine:Activate(false)
							arrest:Activate(false)
						end
					end
				end)
				local function ShowNext(arrest, name)
					window:NewPage(2)
					local windowTitle = arrest and "Arrest " or "Cite "
					local buttonName = arrest and "ARREST" or "CITE"
					window:AddComponent(Components.TextLabel.new("Select a reason and describe the issue that warrants " .. (arrest and "arrest." or "a citation.")), 2)
					local comboBox = Components.ComboBox.new("CRIME")
					local comboList = {}
					for i, v in pairs(Crimes) do
						if arrest and v.Arrest or not arrest and v.Fine then
							table.insert(comboList, {
								i,
								v.Name
							})
						end
					end
					comboBox:SetItemList(comboList)
					local textBox = Components.TextBox.new("Describe", true)
					local amountBox = Components.TextBox.new(arrest and "Duration (minutes)" or "Amount")
					local submitButton = Components.Button.new(buttonName, true)
					local function UpdateButton()
						if textBox:GetText() and amountBox:GetText() and tonumber(amountBox:GetText()) and comboBox.Selected then
							submitButton:Activate(true)
							return true
						else
							submitButton:Activate(false)
							return false
						end
					end
					amountBox.FocusLost:Connect(UpdateButton)
					local thisDebounce = false
					submitButton.MouseClick:Connect(function()
						if submitButton.Enabled and not thisDebounce and UpdateButton() then
							thisDebounce = true
							sentenceRemote:Fire(interact.Id, name, arrest, comboBox.Selected, textBox:GetText(), tonumber(amountBox:GetText()))
							window:Close()
						end
					end)
					comboBox.OnSelection:Connect(UpdateButton)
					textBox.FocusLost:Connect(UpdateButton)
					window:AddComponent(comboBox, 2)
					window:AddComponent(amountBox, 2)
					window:AddComponent(textBox, 2)
					window:AddComponent(submitButton, 2)
					window:UpdateTitle(windowTitle .. name)
					window:SwitchPage(2)
				end
				fine.MouseClick:Connect(function()
					if fine.Enabled and field:GetText() and not nextDebounce then
						nextDebounce = true
						fine:Activate(false)
						arrest:Activate(false)
						ShowNext(false, field:GetText())
					end
				end)
				arrest.MouseClick:Connect(function()
					if arrest.Enabled and field:GetText() and not nextDebounce then
						nextDebounce = true
						arrest:Activate(false)
						fine:Activate(false)
						ShowNext(true, field:GetText())
					end
				end)
				window.OnHide:Connect(function()
					ClientFunctions.MovementEnable(true)
					debounce = false
				end)
				window:AddComponent(field)
				window:AddComponent(fine)
				window:AddComponent(arrest)
				window:Show()
			end
		elseif result == Enum.KeyCode.K then
			do
				local sentDebounce = false
				ClientFunctions.MovementEnable(false)
				local window = Components.Window.new("Court Ruling")
				window:AddComponent(Components.TextLabel.new("Enter a court ruling below:"))
				local field = Components.TextBox.new("Ruling", true)
				local enter = Components.Button.new("SUBMIT", true)
				field.FocusLost:Connect(function()
					if not sentDebounce then
						if field:GetText() then
							enter:Activate(true)
						else
							enter:Activate(false)
						end
					end
				end)
				enter.MouseClick:Connect(function()
					if enter.Enabled and field:GetText() and not sentDebounce then
						sentDebounce = true
						enter:Activate(false)
						rulingRemote:Fire(interact.Id, field:GetText())
						window:Close()
					end
				end)
				window.OnHide:Connect(function()
					ClientFunctions.MovementEnable(true)
					debounce = false
				end)
				window:AddComponent(field)
				window:AddComponent(enter)
				window:Show()
			end
		elseif result == Enum.KeyCode.L then
			do
				local sentDebounce = false
				local thisDebounce = false
				ClientFunctions.MovementEnable(false)
				local window = Components.Window.new("Court Warrant")
				window:NewPage(2)
				window:AddComponent(Components.TextLabel.new("Enter the username of the person being issued a warrant."))
				local field = Components.TextBox.new("Username")
				local searchB = Components.Button.new("SEARCH", true)
				local arrestB = Components.Button.new("ARREST", true)
				searchB.MouseClick:Connect(function()
					if not sentDebounce then
						sentDebounce = true
						window:AddComponent(Components.TextLabel.new("Describe the issue that requires a search warrant."), 2)
						do
							local issueB = Components.Button.new("ISSUE", true)
							local descField = Components.TextBox.new("Describe", true)
							descField.FocusLost:Connect(function()
								issueB:Activate(field:GetText())
							end)
							issueB.MouseClick:Connect(function()
								if not thisDebounce and issueB.Enabled then
									thisDebounce = true
									window:Close()
									warrantRemote:Fire(interact.Id, field:GetText(), descField:GetText())
								end
							end)
							window:AddComponent(descField, 2)
							window:AddComponent(issueB, 2)
							window:UpdateTitle("SEARCH WARRANT - " .. field:GetText())
							window:SwitchPage(2)
						end
					end
				end)
				arrestB.MouseClick:Connect(function()
					if not sentDebounce then
						sentDebounce = true
						window:AddComponent(Components.TextLabel.new("Select a reason and describe the issue that requires an arrest warrant."), 2)
						do
							local comboBox = Components.ComboBox.new("CRIME")
							local comboList = {}
							for i, v in pairs(Crimes) do
								if v.Arrest then
									table.insert(comboList, {
										i,
										v.Name
									})
								end
							end
							comboBox:SetItemList(comboList)
							local textBox = Components.TextBox.new("Describe", true)
							local submitButton = Components.Button.new("ISSUE", true)
							local function UpdateButton()
								if textBox:GetText() and comboBox.Selected then
									submitButton:Activate(true)
									return true
								else
									submitButton:Activate(false)
									return false
								end
							end
							submitButton.MouseClick:Connect(function()
								if submitButton.Enabled and not thisDebounce and UpdateButton() then
									thisDebounce = true
									window:Close()
									warrantRemote:Fire(interact.Id, field:GetText(), textBox:GetText(), comboBox.Selected)
								end
							end)
							comboBox.OnSelection:Connect(UpdateButton)
							textBox.FocusLost:Connect(UpdateButton)
							window:AddComponent(comboBox, 2)
							window:AddComponent(textBox, 2)
							window:AddComponent(submitButton, 2)
							window:UpdateTitle("ARREST WARRANT - " .. field:GetText())
							window:SwitchPage(2)
						end
					end
				end)
				field.FocusLost:Connect(function()
					if not sentDebounce then
						if field:GetText() then
							searchB:Activate(true)
							arrestB:Activate(true)
						else
							searchB:Activate(false)
							arrestB:Activate(false)
						end
					end
				end)
				window.OnHide:Connect(function()
					ClientFunctions.MovementEnable(true)
					debounce = false
				end)
				window:AddComponent(field)
				window:AddComponent(searchB)
				window:AddComponent(arrestB)
				window:Show()
			end
		end
	end
end
return API

starterplayerscripts.coreclient.interactions.pumpkin
--SynapseX Decompiler

local API = {}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteHandler = require(script.Parent.Parent.RemoteHandler)
local Components = require(script.Parent.Parent.Components)
local ClientFunctions = require(script.Parent.Parent.ClientFunctions)
local Vehicles = require(ReplicatedStorage.Databases.Vehicles)
local player = Players.LocalPlayer
local PumpkinRemote = RemoteHandler.Event.new("Pumpkin")
local debounce = false
function API.Verify(interact)
	if not debounce then
		local returnTable = {}
		local verified = false
		if interact then
			returnTable[Enum.KeyCode.F] = "Interact"
			verified = true
		end
		return verified and returnTable
	end
end
function API.Press(inputObject, interact, context, result)
	if not debounce and inputObject.UserInputState == Enum.UserInputState.End then
		debounce = true
		context:Remove()
		if result == Enum.KeyCode.F then
			PumpkinRemote:Fire(player, interact.Data.Spawnset)
		end
		wait(0.5)
		debounce = false
	end
end
return API

starterplayerscripts.coreclient.interactions.team
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local u1 = require(game:GetService("ReplicatedStorage").Databases.Teams);
local u2 = false;
local u3 = require(script.Parent.Parent.Verificator);
local l__LocalPlayer__4 = game:GetService("Players").LocalPlayer;
function v1.Verify(p1)
	local v2 = nil;
	if not u2 then
		v2 = u3.CheckPermission("CanChangeTeam", p1.Data.Team);
		if l__LocalPlayer__4.TeamColor ~= u1[p1.Data.Team].TeamColor then
			return {
				[Enum.KeyCode.F] = "Join Team (" .. u1[p1.Data.Team].Name .. ")"
			}, nil, not v2;
		end;
		if u1[p1.Data.Team].Priority then
			return;
		end;
	else
		return;
	end;
	return {
		[Enum.KeyCode.F] = "Leave Team (" .. u1[p1.Data.Team].Name .. ")"
	}, nil, not v2;
end;
local u5 = require(script.Parent.Parent:WaitForChild("RemoteHandler")).Event.new("Team");
function v1.Press(p2, p3, p4)
	if p2.UserInputState == Enum.UserInputState.End and not u2 then
		u2 = true;
		if l__LocalPlayer__4.TeamColor ~= u1[p3.Data.Team].TeamColor then
			u5:Fire(p3.Id, p3.Data.Team);
		else
			u5:Fire(p3.Id);
		end;
		p4:Remove();
		wait(0.5);
		u2 = false;
	end;
end;
return v1;

starterplayerscripts.coreclient.interactions.toolstore
--SynapseX Decompiler

local API = {}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteHandler = require(script.Parent.Parent.RemoteHandler)
local Components = require(script.Parent.Parent.Components)
local ClientFunctions = require(script.Parent.Parent.ClientFunctions)
local NotificationHandler = require(script.Parent.Parent.NotificationHandler)
local BankController = require(script.Parent.Parent.BankController)
local Verificator = require(script.Parent.Parent.Verificator)
local Tools = require(ReplicatedStorage.Databases.Tools)
local Assets = require(ReplicatedStorage.Databases.Assets)
local Stores = require(ReplicatedStorage.Databases.Stores)
local Items = require(ReplicatedStorage.Databases.Items)
local player = Players.LocalPlayer
local purchaseRemote = RemoteHandler.Event.new("ItemPurchase")
local debounce = false
function API.Verify(interact)
	if not debounce then
		return {
			[Enum.KeyCode.F] = "Browse " .. Stores[interact.Data.Store].Name
		}
	end
end
function API.Press(inputObject, interact, context, result)
	if not debounce and inputObject.UserInputState == Enum.UserInputState.End then
		debounce = true
		context:Remove()
		if result == Enum.KeyCode.F then
			do
				local storeTable = Stores[interact.Data.Store]
				ClientFunctions.MovementEnable(false)
				local window = Components.Window.new(storeTable.Name, nil, nil, 650)
				local gotLicense = Verificator.CheckPermission("CanPurchaseLegal")
				local gotSomething = false
				local props = {}
				local function DoProp(proper, val)
					if not val then
						return
					end
					if not props[proper] then
						props[proper] = {
							math.huge,
							0
						}
					end
					props[proper] = {
						math.min(val, props[proper][1]),
						math.max(val, props[proper][2])
					}
				end
				for i, v in pairs(Tools) do
					DoProp("Recoil", v.Recoil)
					DoProp("Accuracy", v.Spread)
					DoProp("Damage", v.BaseDamage)
				end
				for i, v in pairs(props) do
					v[1] = v[1] * 0.9
					v[2] = v[2] * 1.1
				end
				local function GetScale(prope, val)
					local p1 = props[prope][1]
					local p2 = props[prope][2]
					return (val - p1) / (p2 - p1)
				end
				local splitList = {}
				for i, v in pairs(storeTable.Items) do
					local itemTable = Items[v[1]]
					local toolTable = Tools[v[1]]
					local stats
					if itemTable.Type == "Firearm" then
						stats = {
							{
								"Damage",
								GetScale("Damage", toolTable.BaseDamage),
								true
							},
							{
								"Recoil",
								GetScale("Recoil", toolTable.Recoil),
								true
							},
							{
								"Accuracy",
								math.abs(GetScale("Accuracy", toolTable.Spread) - 1),
								true
							}
						}
						if toolTable.MagSize then
							table.insert(stats, {
								"Round Limit",
								toolTable.MagSize
							})
						end
						if toolTable.Auto then
							table.insert(stats, {"Automatic", "YES"})
						end
					elseif itemTable.Type == "Melee" then
						stats = {
							{
								"Damage",
								GetScale("Damage", toolTable.BaseDamage),
								true
							}
						}
					elseif itemTable.Type == "Magazine" then
						stats = {
							{
								"Size",
								itemTable.Attributes.R .. " Rounds"
							}
						}
					else
						stats = {}
						if itemTable.Attributes and itemTable.Attributes.R then
							table.insert(stats, {
								"Size",
								itemTable.Attributes.R .. " Units"
							})
						end
					end
					if v[3] then
						table.insert(stats, {
							"License Required",
							"YES"
						})
					end
					gotSomething = true
					splitList[v[1]] = {
						itemTable.Name,
						Items[v[1]].StoreSill,
						stats,
						Items[v[1]].StoreThumb,
						v[2] .. (storeTable.Accepts == 2 and " Wallet" or ""),
						"Items." .. itemTable.Asset,
						true
					}
				end
				if not gotSomething then
					NotificationHandler.NewNotification("None of the items here are available to you.", "No Availability!", "Red")
					ClientFunctions.MovementEnable(true)
					wait(0.5)
					debounce = false
					return
				end
				local function ValidateSelection(id)
					local cash
					if storeTable.Accepts == 3 then
						cash = BankController.GetBalance("Cash") + BankController.GetBalance("Bank")
					else
						cash = BankController.GetBalance(storeTable.Accepts == 2 and "Cash" or "Bank")
					end
					for i, v in pairs(storeTable.Items) do
						if v[1] == id and cash >= v[2] then
							return true
						end
					end
				end
				local splitPane = Components.SplitPane.new("Buy")
				splitPane:SetItemList(splitList, ValidateSelection)
				local actionDebounce = false
				splitPane.ActionPressed:Connect(function()
					if not actionDebounce then
						actionDebounce = true
						local id = splitPane:GetSelected()
						if ValidateSelection(id) then
							for _, v in pairs(storeTable.Items) do
								if v[1] == id then
									if not gotLicense and v[3] then
										NotificationHandler.NewNotification("You need a weapon license to purchase this item, you may buy one at the Plymouth Courthouse.", "Purchase Failed!", "Red")
									else
										purchaseRemote:Fire(interact.Id, interact.Data.Store, id)
									end
									window:Close()
									return
								end
							end
						else
							actionDebounce = false
						end
					end
				end)
				window.OnHide:Connect(function()
					ClientFunctions.MovementEnable(true)
					debounce = false
				end)
				window:AddComponent(splitPane)
				window:Show()
			end
		end
	end
end
return API

starterplayerscripts.coreclient.interactions.uniform
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local l__ReplicatedStorage__2 = game:GetService("ReplicatedStorage");
local l__Players__3 = game:GetService("Players");
local u1 = require(script.Parent.Parent.Verificator);
local u2 = require(l__ReplicatedStorage__2.Databases.Roles);
local u3 = require(l__ReplicatedStorage__2.Databases.Uniforms);
local function u4(p1)
	if not p1.Data.Role then
		return "Own";
	end;
	local l__Role__4 = p1.Data.Role;
	local l__UniformType__5 = p1.Data.UniformType;
	if not u1.GetPlayerRoles()[l__Role__4] then
		return;
	end;
	local v6 = u1.GetRankInGroup(u2[l__Role__4].GroupCriteria[1][1]);
	if not u3[l__Role__4] or not u3[l__Role__4][l__UniformType__5] then
		return;
	end;
	local v7 = u3[l__Role__4][l__UniformType__5];
	local v8 = nil;
	if not v7[v6] and v6 > 0 then
		v8 = 0;
		for v9, v10 in pairs(v7) do
			if v9 < v6 and v8 < v9 then
				v8 = v9;
			end;
		end;
	end;
	return l__UniformType__5, v8 and v6;
end;
function v1.Verify(p2)
	return {
		[Enum.KeyCode.F] = "Change Clothing (" .. p2.Data.UniformType .. ")"
	}, nil, not u4(p2);
end;
local u5 = false;
local function u6(p3)
	local v11 = false;
	if #p3 ~= 0 then
		v11 = next(p3, #p3) == nil;
	end;
	return v11;
end;
local u7 = require(script.Parent.Parent.RemoteHandler).Event.new("Uniform");
local u8 = require(script.Parent.Parent.Components);
local u9 = require(script.Parent.Parent.ClientFunctions);
local u10 = require(l__ReplicatedStorage__2.Databases.Uniforms.HairStyles);
function v1.Press(p4, p5, p6)
	if not u5 and p4.UserInputState == Enum.UserInputState.End then
		u5 = true;
		p6:Remove();
		local v12 = nil;
		if p5.Data.UniformType ~= "Own" then
			local l__UniformType__13 = p5.Data.UniformType;
			local l__Role__14 = p5.Data.Role;
			local v15 = u1.GetRankInGroup(u2[l__Role__14].GroupCriteria[1][1]);
			local v16 = nil;
			if v15 < 1 then
				v16 = 1;
			else
				v16 = v15;
			end;
			local v17 = v16;
			local v18 = u3[l__Role__14][l__UniformType__13];
			for v19 = v17, 1, -1 do
				if u3[l__Role__14][l__UniformType__13][v19] then
					v17 = v19;
					break;
				end;
			end;
			v12 = u3[l__Role__14][l__UniformType__13][v17];
		end;
		if p5.Data.UniformType == "Own" or v12[5] and (not v12[4] or not (not u6(v12[4])) or not next(v12[4])) then
			u7:Fire(p5.Id, p5.Data.Role, p5.Data.UniformType);
			wait(0.3);
			u5 = false;
		else
			local function v20(p7, p8, p9)
				p7:UpdateTitle("Accessory Choice");
				p7:AddComponent(u8.TextLabel.new("Choose the combination of accessories you would like to wear with this uniform."), p8);
				local v21 = false;
				for v22, v23 in pairs(v12[4]) do
					local v24 = u8.Button.new(v22, nil, true);
					local u11 = v21;
					v24.MouseClick:Connect(function()
						if v24.Enabled and not u11 then
							u11 = true;
							p7:Close();
							u7:Fire(p5.Id, p5.Data.Role, p5.Data.UniformType, p9, v22);
						end;
					end);
					p7:AddComponent(v24, p8);
				end;
			end;
			u9.MovementEnable(false);
			local v25 = u8.Window.new("Hair Preference");
			if v12[5] == nil then
				v25:AddComponent(u8.TextLabel.new("Choose the hair you would like to have with this uniform."));
				local v26 = false;
				for v27, v28 in pairs(u10) do
					local v29 = u8.Button.new(v28.Name, nil, true);
					local u12 = v26;
					v29.MouseClick:Connect(function()
						if v29.Enabled and not u12 then
							u12 = true;
							if not u6(v12[4]) and next(v12[4]) then
								v25:NewPage(2);
								v20(v25, 2, v27);
								v25:SwitchPage(2);
								return;
							end;
						else
							return;
						end;
						v25:Close();
						u7:Fire(p5.Id, p5.Data.Role, p5.Data.UniformType, v27);
					end);
					v25:AddComponent(v29);
				end;
			else
				v20(v25);
			end;
			v25.OnHide:Connect(function()
				u9.MovementEnable(true);
				u5 = false;
			end);
			v25:Show();
		end;
	end;
end;
local l__LocalPlayer__13 = l__Players__3.LocalPlayer;
function v1.Init(p10)
	if not p10 then
		warn("Interactions not passed to uniforms");
		return;
	end;
	local u14 = nil;
	local v30, v31 = pcall(function()
		u14 = l__Players__3:GetCharacterAppearanceAsync(l__LocalPlayer__13.UserId > 0 and l__LocalPlayer__13.UserId or 1);
	end);
	local v32 = {
		Shirt = "", 
		Pants = "", 
		TShirt = ""
	};
	if v30 then
		v32 = {
			Shirt = u14:FindFirstChild("Shirt") and u14.Shirt.ShirtTemplate or "", 
			Pants = u14:FindFirstChild("Pants") and u14.Pants.PantsTemplate or "", 
			TShirt = u14:FindFirstChild("Shirt Graphic") and u14["Shirt Graphic"].Graphic or ""
		};
	end;
	for v33, v34 in pairs(p10) do
		if v34.Data.Type == "Uniform" and v34.Data.UniformModel then
			local l__UniformModel__35 = v34.Data.UniformModel;
			local v36, v37 = u4(v34);
			local v38 = {
				Shirt = v32.Shirt, 
				Pants = v32.Pants, 
				TShirt = v32.TShirt
			};
			local v39 = nil;
			if v34.Data.Role then
				if v37 then
					v39 = v37 > 0 and v37 or 1;
				else
					v39 = 1;
				end;
				local v40 = u3[v34.Data.Role][v34.Data.UniformType][v39];
				if v40[1] then
					v38.Shirt = "rbxassetid://" .. v40[1];
				end;
				if v40[2] then
					v38.Pants = "rbxassetid://" .. v40[2];
				end;
				if v40[3] then
					v38.TShirt = "rbxassetid://" .. v40[3];
				elseif v40[1] and v40[2] then
					v38.TShirt = "";
				end;
			end;
			l__UniformModel__35.Shirt.ShirtTemplate = v38.Shirt;
			l__UniformModel__35.Pants.PantsTemplate = v38.Pants;
			l__UniformModel__35["Shirt Graphic"].Graphic = v38.TShirt;
		end;
	end;
end;
return v1;

starterplayerscripts.coreclient.interactions.vehicle
--SynapseX Decompiler

local API = {}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local RemoteHandler = require(script.Parent.Parent.RemoteHandler)
local ClientFunctions = require(script.Parent.Parent.ClientFunctions)
local Verificator = require(script.Parent.Parent.Verificator)
local VehicleController = require(script.Parent.Parent.VehicleController)
local JusticeController = require(script.Parent.Parent.JusticeController)
local Assets = require(ReplicatedStorage.Databases.Assets)
local Vehicles = require(ReplicatedStorage.Databases.Vehicles)
local Teams = require(ReplicatedStorage.Databases.Teams)
local KEY_CODE = Enum.KeyCode.T
local GLASS_TAG = "Glass"
local GLASS_SMASH_TAG = "Ignore"
local player = Players.LocalPlayer
local vehicleControl = RemoteHandler.Event.new("VehicleControl")
local vehicleInv = RemoteHandler.Event.new("VehicleItem")
local InventoryController = script.Parent.Parent.InventoryController
local debounce = false
local function GetTeamFromPlayer(player)
	for i, v in pairs(Teams) do
		if v.TeamColor == player.TeamColor then
			return i
		end
	end
	return -1
end
vehicleInv.OnEvent:Connect(function(model, inventory)
	require(InventoryController).ShowComparisonWindow(model, inventory, true)
end)
function API.Verify(interact, arg2, arg3)
	local iData = interact.Data
	iData.Seat = arg3:WaitForChild("Config"):WaitForChild("Seat").Value
	if iData.Seat.Velocity.Magnitude > 5 then
		return
	end
	local function GlassOk()
		if Verificator.CheckPermission("CanArrest") then
			for _, g in pairs(iData.Seat.Parent.Parent.Body:GetChildren()) do
				if g:IsA("BasePart") and CollectionService:HasTag(g, GLASS_TAG) and not CollectionService:HasTag(g, GLASS_SMASH_TAG) then
					return
				end
			end
			return true
		end
	end
	if not debounce and not VehicleController.Seated() then
		if iData.Seat and not iData.Gas and not iData.Inventory then
			local seat = interact.Data.Seat
			local driverSeat
			for i, v in pairs(seat.Parent:GetChildren()) do
				if v:IsA("VehicleSeat") then
					if v.Name:sub(1, 6) == "Driver" then
						driverSeat = v
						if not seat.Occupant then
							break
						end
					elseif v.Name == seat.Name and not v.Occupant then
						seat = v
						if driverSeat then
							break
						end
					end
				end
			end
			local returnTable = {}
			local success = false
			local locked = driverSeat:FindFirstChild("Locked").Value
			if not locked or GlassOk() then
				if not seat.Occupant then
					if not JusticeController.HasGrab() then
						returnTable[KEY_CODE] = "Enter Vehicle"
						success = true
					elseif seat.Name:sub(1, 6) ~= "Driver" and Verificator.CheckPermission("CanArrest") then
						returnTable[KEY_CODE] = "Put in Vehicle"
						success = true
					end
				elseif not JusticeController.HasGrab() and Verificator.CheckPermission("CanArrest") and Verificator.CheckPermission("CanInteractTeams", GetTeamFromPlayer(Players:GetPlayerFromCharacter(seat.Occupant.Parent))) then
					returnTable[KEY_CODE] = "Remove from Vehicle"
					success = true
				end
			end
			if seat.Occupant then
				local team = GetTeamFromPlayer(Players:GetPlayerFromCharacter(seat.Occupant.Parent))
				if not JusticeController.HasGrab() and Verificator.CheckPermission("CanFine") and Verificator.CheckPermission("CanInteractTeams", team) and not Teams[team].Jail then
					returnTable[Enum.KeyCode.X] = "Cite"
					success = true
				end
			end
			local playerObj = driverSeat:FindFirstChild("PlayerVal")
			if playerObj.Value == player or Verificator.CheckPermission("CanSpawnVehicle", seat.Parent.Parent.Name) then
				returnTable[Enum.KeyCode.C] = locked and "Unlock Vehicle" or "Lock Vehicle"
				success = true
			end
			return success and returnTable
		elseif iData.Gas then
			local cur = require(InventoryController).GetEquipped()
			local gasTank = iData.Seat:FindFirstChild("GasTank")
			if cur and cur.Item[2] == "Jerrycan" and cur.Item[3].R > 0 and gasTank then
				local class = iData.Seat.Parent.Parent.Name
				local sum = cur.Item[3].R + gasTank.Value
				local res = math.min(sum, Vehicles[class].GasTank)
				local topUp = cur.Item[3].R - (sum - res)
				return {
					[Enum.KeyCode.F] = "Refill Gas (" .. math.floor(topUp) .. ")"
				}
			end
		elseif iData.Inventory then
			local playerObj = iData.Seat:FindFirstChild("PlayerVal")
			if playerObj.Value == player or Verificator.CheckPermission("CanSpawnVehicle", iData.Seat.Parent.Parent.Name) or GlassOk() then
				return {
					[Enum.KeyCode.F] = "Open Inventory"
				}
			end
		end
	end
end
function API.Press(inputObject, interact, context, result)
	if not debounce and inputObject.UserInputState == Enum.UserInputState.End then
		debounce = true
		local seat = interact.Data.Seat
		if seat.Occupant then
			for i, v in pairs(seat.Parent:GetChildren()) do
				if v:IsA("VehicleSeat") and v.Name == seat.Name and not v.Occupant then
					seat = v
					break
				end
			end
		end
		if result == KEY_CODE then
			if seat and not VehicleController.Seated() then
				if not seat.Occupant then
					if not JusticeController.HasGrab() then
						VehicleController.SitInSeat(seat, interact)
					elseif seat.Name:sub(1, 6) ~= "Driver" and Verificator.CheckPermission("CanArrest") then
						JusticeController.GrabToSeat(seat, true)
					end
				elseif not JusticeController.HasGrab() and Verificator.CheckPermission("CanArrest") and Verificator.CheckPermission("CanInteractTeams", GetTeamFromPlayer(Players:GetPlayerFromCharacter(seat.Occupant.Parent))) then
					JusticeController.GrabToSeat(seat, false)
				end
			end
		elseif result == Enum.KeyCode.C then
			vehicleControl:Fire(seat, "Lock")
		elseif result == Enum.KeyCode.F then
			if interact.Data.Inventory then
				vehicleInv:Fire(interact.Data.Seat.Parent.Parent)
			elseif interact.Data.Gas then
				local cur = require(InventoryController).GetEquipped()
				if cur and cur.Item[2] == "Jerrycan" and cur.Item[3].R > 0 then
					vehicleControl:Fire(seat, "Jerry", cur.Item[1])
				end
			end
		elseif result == Enum.KeyCode.X and seat.Occupant and Players:GetPlayerFromCharacter(seat.Occupant.Parent) then
			JusticeController.Fine(Players:GetPlayerFromCharacter(seat.Occupant.Parent))
		end
		context:Remove()
		wait(0.5)
		debounce = false
	end
end
return API

starterplayerscripts.coreclient.interactions.vehicledealership
--SynapseX Decompiler

local API = {}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteHandler = require(script.Parent.Parent.RemoteHandler)
local Components = require(script.Parent.Parent.Components)
local ClientFunctions = require(script.Parent.Parent.ClientFunctions)
local NotificationHandler = require(script.Parent.Parent.NotificationHandler)
local BankController = require(script.Parent.Parent.BankController)
local Vehicles = require(ReplicatedStorage.Databases.Vehicles)
local Assets = require(ReplicatedStorage.Databases.Assets)
local Dealerships = require(ReplicatedStorage.Databases.Dealerships)
local DEBOUNCE = 1
local player = Players.LocalPlayer
local purchaseRemote = RemoteHandler.Event.new("VehiclePurchase")
local debounce = false
function API.Verify(interact)
	if not debounce then
		return {
			[Enum.KeyCode.F] = "Browse " .. Dealerships[interact.Data.Dealership].Name
		}
	end
end
function API.Press(inputObject, interact, context, result)
	if not debounce and inputObject.UserInputState == Enum.UserInputState.End then
		debounce = true
		context:Remove()
		if not Dealerships[interact.Data.Dealership] then
			return
		end
		do
			local dTable = Dealerships[interact.Data.Dealership]
			if result == Enum.KeyCode.F then
				ClientFunctions.MovementEnable(false)
				do
					local window = Components.Window.new(dTable.Name, nil, nil, 650)
					local props = {}
					local function DoProp(proper, val)
						if not props[proper] then
							props[proper] = {
								math.huge,
								0
							}
						end
						props[proper] = {
							math.min(val, props[proper][1]),
							math.max(val, props[proper][2])
						}
					end
					for i, v in pairs(Vehicles) do
						DoProp("Gears", v.Gears[#v.Gears])
						DoProp("Acceleration", v.AcceIeration)
						DoProp("MaxHealth", v.MaxHealth)
						DoProp("Braking", v.BrakeAcceIeration)
						DoProp("InventorySize", v.InventorySize)
					end
					for i, v in pairs(props) do
						v[1] = v[1] * 0.9
						v[2] = v[2] * 1.1
					end
					local function GetScale(prope, val)
						local p1 = props[prope][1]
						local p2 = props[prope][2]
						return (val - p1) / (p2 - p1)
					end
					local splitList = {}
					for i, v in pairs(dTable.Vehicles) do
						local vTable = Vehicles[v[1]]
						local stats = {
							{
								"Max Speed",
								GetScale("Gears", vTable.Gears[#vTable.Gears]),
								true
							},
							{
								"Acceleration",
								GetScale("Acceleration", vTable.AcceIeration),
								true
							},
							{
								"Durability",
								GetScale("MaxHealth", vTable.MaxHealth),
								true
							},
							{
								"Braking",
								GetScale("Braking", vTable.BrakeAcceIeration),
								true
							},
							{
								"Inventory Size",
								GetScale("InventorySize", vTable.InventorySize),
								true
							}
						}
						splitList[v[1]] = {
							vTable.Name,
							Assets.Vehicles[vTable.Asset].StoreSilhouette,
							stats,
							Assets.Vehicles[vTable.Asset].StoreThumbnail,
							v[2] .. (dTable.Accepts == 2 and " Cash" or ""),
							"Vehicles." .. v[1]
						}
					end
					local function ValidateSelection(id)
						local cash
						if dTable.Accepts == 3 then
							cash = BankController.GetBalance("Cash") + BankController.GetBalance("Bank")
						else
							cash = BankController.GetBalance(dTable.Accepts == 2 and "Cash" or "Bank")
						end
						for i, v in pairs(dTable.Vehicles) do
							if v[1] == id and cash >= v[2] then
								return true
							end
						end
					end
					local splitPane = Components.SplitPane.new("buy")
					splitPane:SetItemList(splitList, ValidateSelection)
					local actionDebounce = false
					splitPane.ActionPressed:Connect(function()
						if not actionDebounce then
							actionDebounce = true
							local id = splitPane:GetSelected()
							if ValidateSelection(id) then
								purchaseRemote:Fire(interact.Id, id, interact.Data.Dealership)
								window:Close()
							else
								actionDebounce = false
							end
						end
					end)
					window.OnHide:Connect(function()
						ClientFunctions.MovementEnable(true)
						wait(DEBOUNCE)
						debounce = false
					end)
					window:AddComponent(splitPane)
					window:Show()
				end
			end
		end
	end
end
return API

starterplayerscripts.coreclient.interactions.vehiclepaint
local API = {}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Verificator = require(script.Parent.Parent.Verificator)
local RemoteHandler = require(script.Parent.Parent.RemoteHandler)
local Vehicles = require(ReplicatedStorage.Databases.Vehicles)
local Constants = require(ReplicatedStorage.Databases.Constants)
local player = Players.LocalPlayer
local vehicleRepaint = RemoteHandler.Event.new("VehicleRepaint")
local debounce = false
function API.Verify(interact, vData)
	if vData.Seat and vData.Seat.Velocity.Magnitude <= 5 then
		local classTable = Vehicles[vData.Model.Name]
		if not classTable or not classTable.Paintable then
			return
		end
		local playerObj = vData.Seat:FindFirstChild("PlayerVal")
		if playerObj and playerObj.Value == player then
			return {
				[Enum.KeyCode.X] = "Repaint Vehicle ($" .. "20" .. ")"
			}
		end
	end
end
function API.Press(inputObject, interact, context, result, vData)
	if inputObject.UserInputState == Enum.UserInputState.End and not debounce then
		debounce = true
		if API.Verify(interact, vData) then
			vehicleRepaint:Fire(interact.Id, vData.Seat, interact.Data.Shop, interact.Data.Emitter1, interact.Data.Emitter2, interact.Data.SoundPart)
		end
		context:Remove()
		wait(1.5)
		debounce = false
	end
end
return API

starterplayerscripts.coreclient.interactions.vehiclespawner
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local l__ReplicatedStorage__2 = game:GetService("ReplicatedStorage");
local v3 = require(script.Parent.Parent.RemoteHandler);
local l__LocalPlayer__4 = game:GetService("Players").LocalPlayer;
local u1 = false;
function v1.Verify(p1)
	if u1 then
		return;
	end;
	return {
		[Enum.KeyCode.F] = "Spawn Vehicles"
	};
end;
local u2 = v3.Func.new("AvailableVehicles");
local u3 = require(script.Parent.Parent.NotificationHandler);
local u4 = require(script.Parent.Parent.ClientFunctions);
local u5 = require(script.Parent.Parent.Components);
local u6 = require(l__ReplicatedStorage__2.Databases.Vehicles);
local u7 = require(l__ReplicatedStorage__2.Databases.Assets);
local u8 = v3.Event.new("SpawnVehicle");
function v1.Press(p2, p3, p4, p5)
	if not u1 and p2.UserInputState == Enum.UserInputState.End then
		u1 = true;
		p4:Remove();
		if p5 == Enum.KeyCode.F then
			local v5 = u2:Invoke(p3.Id, p3.Data.SpawnSet);
			if not v5 or #v5 < 1 then
				u3.NewNotification("You have no vehicles to spawn at this location.", "No Vehicles!", "Red");
				wait(2.5);
				u1 = false;
				return;
			end;
			u4.MovementEnable(false);
			local v6 = u5.Window.new("Vehicle Spawn", nil, nil, 650);
			local u9 = {};
			local function v7(p6, p7)
				if not u9[p6] then
					u9[p6] = { math.huge, 0 };
				end;
				u9[p6] = { math.min(p7, u9[p6][1]), math.max(p7, u9[p6][2]) };
			end;
			for v8, v9 in pairs(u6) do
				v7("Gears", v9.Gears[#v9.Gears]);
				v7("Acceleration", v9.AcceIeration);
				v7("MaxHealth", v9.MaxHealth);
				v7("Braking", v9.BrakeAcceIeration);
				v7("InventorySize", v9.InventorySize);
			end;
			for v10, v11 in pairs(u9) do
				v11[1] = v11[1] * 0.9;
				v11[2] = v11[2] * 1.1;
			end;
			local function v12(p8, p9)
				local v13 = u9[p8][1];
				return (p9 - v13) / (u9[p8][2] - v13);
			end;
			local v14 = {};
			for v15, v16 in pairs(v5) do
				local v17 = u6[v16];
				v14[v16] = { v17.Name, u7.Vehicles[v17.Asset].StoreSilhouette, { { "Max Speed", v12("Gears", v17.Gears[#v17.Gears]), true }, { "Acceleration", v12("Acceleration", v17.AcceIeration), true }, { "Durability", v12("MaxHealth", v17.MaxHealth), true }, { "Braking", v12("Braking", v17.BrakeAcceIeration), true }, { "Inventory Size", v12("InventorySize", v17.InventorySize), true } }, u7.Vehicles[v17.Asset].StoreThumbnail, nil, "Vehicles." .. v16 };
			end;
			local function v18(p10)
				return true;
			end;
			local v19 = u5.SplitPane.new("Spawn");
			v19:SetItemList(v14, v18);
			local u10 = false;
			v19.ActionPressed:Connect(function()
				local v20 = nil;
				if not u10 then
					u10 = true;
					v20 = v19:GetSelected();
					if not v18(v20) then
						u10 = false;
						return;
					end;
				else
					return;
				end;
				v6:Close();
				u8:Fire(p3.Id, v20, p3.Data.SpawnSet);
			end);
			v6.OnHide:Connect(function()
				u4.MovementEnable(true);
				wait(2.5);
				u1 = false;
			end);
			v6:AddComponent(v19);
			v6:Show();
		end;
	end;
end;
return v1;

starterplayerscripts.coreclient.interactions.voting
--SynapseX Decompiler

local API = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RemoteHandler = require(script.Parent.Parent.RemoteHandler)
local Verificator = require(script.Parent.Parent.Verificator)
local Components = require(script.Parent.Parent.Components)
local ClientFunctions = require(script.Parent.Parent.ClientFunctions)
local NotificationHandler = require(script.Parent.Parent.NotificationHandler)
local Elections = require(ReplicatedStorage.Databases.Elections)
local player = Players.LocalPlayer
local canVote = RemoteHandler.Func.new("CanVote")
local submitVote = RemoteHandler.Event.new("SubmitVote")
local ShuffleTable = function(t)
	local random = Random.new(tick() * 1000)
	random:NextNumber()
	random:NextNumber()
	random:NextNumber()
	local n = #t
	while n > 2 do
		local k = random:NextInteger(1, n)
		t[n], t[k] = t[k], t[n]
		n = n - 1
	end
	return t
end
function API.Verify(inter)
	return {
		[Enum.KeyCode.F] = "Use Voting Booth"
	}
end
local debounce = false
function API.Press(inputObject, interact, context)
	if not debounce and inputObject.UserInputState == Enum.UserInputState.End then
		debounce = true
		context:Remove()
		if not next(Elections) then
			NotificationHandler.NewNotification("There are no elections currently available.", "No Elections!", "Red")
			debounce = false
			return
		end
		do
			local actionDebounce = false
			local submitDebounce = false
			ClientFunctions.MovementEnable(false)
			local hashedRes = {}
			local res = canVote:Invoke(interact.Id)
			for i = 1, #res do
				local v = res[i]
				hashedRes[v] = true
			end
			local window = Components.Window.new("Voting System")
			window:AddComponent(Components.TextLabel.new("Choose the election you would like to vote in:"))
			for i, v in pairs(Elections) do
				do
					local thisButton = Components.Button.new(v.Name, not hashedRes[i], true)
					thisButton.MouseClick:Connect(function()
						if thisButton.Enabled and not actionDebounce then
							actionDebounce = true
							if hashedRes[i] then
								window:NewPage(2)
								if v.Question then
									window:AddComponent(Components.TextLabel.new(v.Question), 2)
								else
									window:AddComponent(Components.TextLabel.new((v.Type == "STV" or v.Type == "AV") and "Rank the candidates in order of preference, 1 (most preferred) to a maximum of " .. #v.Options .. " (least preferred):" or "Select 1 candidate from the list:"), 2)
								end
								do
									local ballotPane = Components.BallotPane.new(v.Type == "STV" or v.Type == "AV")
									local submit = Components.Button.new("SUBMIT")
									local listTable = {}
									for k, cand in pairs(v.Options) do
										table.insert(listTable, {
											k,
											cand[1],
											cand[2]
										})
									end
									ShuffleTable(listTable)
									ballotPane:SetItemList(listTable)
									local function VerifyInput()
										if v.Type == "STV" or v.Type == "AV" then
											local inputs = {}
											local gotSomething = false
											local returnTable = {}
											for _, box in pairs(ballotPane.Boxes) do
												local boxText = box.Text
												local boxNumber = tonumber(boxText)
												if boxNumber and v.Options[boxNumber] then
													if inputs[boxNumber] then
														return
													end
													inputs[boxNumber] = true
													returnTable[boxNumber] = tonumber(box.Parent.Name)
													gotSomething = true
												elseif boxText ~= "" then
													return
												end
											end
											local lastGood = true
											for i = 1, #v.Options do
												if inputs[i] then
													if not lastGood then
														return
													end
													lastGood = true
												else
													lastGood = false
												end
											end
											if gotSomething then
												return returnTable
											end
										else
											return ballotPane.Selected
										end
									end
									submit.MouseClick:Connect(function()
										if not submitDebounce then
											submitDebounce = true
											local inputResult = VerifyInput()
											if inputResult then
												submitVote:Fire(interact.Id, i, inputResult)
											else
												NotificationHandler.NewNotification("Invalid input.", "Voting Error!", "Red")
											end
											window:Close()
										end
									end)
									window:AddComponent(ballotPane, 2)
									window:AddComponent(submit, 2)
									window:SwitchPage(2)
								end
							else
								window:Close()
							end
						end
					end)
					window:AddComponent(thisButton)
				end
			end
			window.OnHide:Connect(function()
				ClientFunctions.MovementEnable(true)
				wait(0.5)
				debounce = false
			end)
			window:Show()
		end
	end
end
return API

starterplayerscripts.coreclient.interactions.weaponlicense
--SynapseX Decompiler

local API = {}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteHandler = require(script.Parent.Parent.RemoteHandler)
local Components = require(script.Parent.Parent.Components)
local ClientFunctions = require(script.Parent.Parent.ClientFunctions)
local BankController = require(script.Parent.Parent.BankController)
local Verificator = require(script.Parent.Parent.Verificator)
local Constants = require(ReplicatedStorage.Databases.Constants)
local player = Players.LocalPlayer
local remote = RemoteHandler.Event.new("WeaponLicense")
local debounce = false
function API.Verify(interact)
	if not debounce then
		return {
			[Enum.KeyCode.F] = string.format("Purchase Weapon License ($%s)", Constants.WeaponLicensePrice)
		}, nil, Verificator.CheckPermission("CanPurchaseLegal")
	end
end
function API.Press(inputObject, interact, context, result)
	if not debounce and inputObject.UserInputState == Enum.UserInputState.End then
		debounce = true
		context:Remove()
		if result == Enum.KeyCode.F then
			remote:Fire(interact.Id)
		end
		wait(0.5)
		debounce = false
	end
end
return API


starterplayerscripts.coreclient.animationcontroller
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local l__RunService__2 = game:GetService("RunService");
v1.ClassName = "CustAnimation";
v1.__index = v1;
local u1 = {};
function v1.new(p1, p2, p3, p4)
	local v3 = {};
	setmetatable(v3, v1);
	if not p3 then
		p3 = 0.1;
	end;
	v3.IsPlaying = true;
	if not u1[p2] then
		u1[p2] = Instance.new("Animation");
		u1[p2].AnimationId = p2;
	end;
	v3.Animation = u1[p2];
	v3.Priority = p4;
	v3.Humanoid = p1;
	local v4 = p1:LoadAnimation(v3.Animation);
	if v3.Priority then
		v4.Priority = v3.Priority;
	end;
	v3.Track = v4;
	v3.Conn = v3.Track.KeyframeReached:Connect(function(p5)
		if p5 == "End" and v3.IsPlaying and v3.Conn then
			v3.Conn:Disconnect();
			v3:Loop();
		end;
	end);
	v4:Play(p3);
	return v3;
end;
function v1.Stop(p6, p7)
	if p6.Conn then
		p6.Conn:Disconnect();
	end;
	if p6.Track then
		p6.IsPlaying = false;
		p6.Track:Stop(p7);
		p6.Track:Destroy();
		p6 = nil;
	end;
end;
function v1.Loop(p8)
	if p8.Track then
		p8.Track:Stop(0);
		p8.Track:Destroy();
	end;
	local v5 = p8.Humanoid:LoadAnimation(p8.Animation);
	if p8.Priority then
		v5.Priority = p8.Priority;
	end;
	p8.Track = v5;
	v5:Play(0);
	p8.Conn = p8.Track.KeyframeReached:Connect(function(p9)
		if p9 == "End" and p8.IsPlaying and p8.Conn then
			p8.Conn:Disconnect();
			p8:Loop();
		end;
	end);
end;
function v1.Toggle(p10, p11)
	if p10.Track then
		p10.IsPlaying = p11;
		if not p11 then
			p10.Track:Stop(0);
			p10.Conn:Disconnect();
			return;
		end;
	else
		return;
	end;
	p10.Track:Play(0);
	p10.Conn = p10.Track.KeyframeReached:Connect(function(p12)
		if p12 == "End" and p10.IsPlaying and p10.Conn then
			p10.Conn:Disconnect();
			p10:Loop();
		end;
	end);
end;
return v1;

starterplayerscripts.coreclient.bankcontroller
local API = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteHandler = require(script.Parent.RemoteHandler)
local ClientFunctions = require(script.Parent.ClientFunctions)
local Tweening = require(script.Parent.Tweening)
local NotificationHandler = require(script.Parent.NotificationHandler)
local Assets = require(ReplicatedStorage.Databases.Assets)
local Constants = require(ReplicatedStorage.Databases.Constants)
local TEXT_COLOR = Color3.new(1, 1, 1)
local TEXT_SIZE = 24
local FONT = Enum.Font.SourceSans
local masterFrame, topFrame, bottomFrame
local gotBottom = false
local gotTop = false
local healthFrame
local bankValues = {Bank = 0, Cash = 0}
local updateRemote = RemoteHandler.Event.new("BankUpdate")
local radioRemote = RemoteHandler.Event.new("RadioUpdate")
local karmaRemote = RemoteHandler.Event.new("Karma")
local ValueBox = {}
ValueBox.__index = ValueBox
function API.Init()
	local versionLabel = Instance.new("TextLabel")
	versionLabel.Name = "VersionLabel"
	versionLabel.Text = "BUILD " .. Constants.Build
	versionLabel.Font = Enum.Font.SourceSans
	versionLabel.Position = UDim2.new(1, 0, 1, 0)
	versionLabel.AnchorPoint = Vector2.new(1, 1)
	versionLabel.Size = UDim2.new(0, 100, 0, 100)
	versionLabel.TextSize = 12
	versionLabel.ZIndex = 20
	versionLabel.TextStrokeTransparency = 0.5
	versionLabel.TextXAlignment = Enum.TextXAlignment.Right
	versionLabel.TextYAlignment = Enum.TextYAlignment.Bottom
	versionLabel.BackgroundTransparency = 1
	versionLabel.BorderSizePixel = 0
	versionLabel.TextColor3 = Color3.new(1, 1, 1)
	versionLabel.Parent = NotificationHandler.GetParentFrame().Parent
	masterFrame = Instance.new("Frame")
	masterFrame.Size = UDim2.new(1, 0, 0, 0)
	masterFrame.Name = "BankFrame"
	masterFrame.BackgroundTransparency = 1
	masterFrame.BorderSizePixel = 0
	local uiListY = Instance.new("UIListLayout")
	uiListY.SortOrder = Enum.SortOrder.Name
	uiListY.FillDirection = Enum.FillDirection.Vertical
	uiListY.VerticalAlignment = Enum.VerticalAlignment.Bottom
	uiListY.Padding = UDim.new(0, 4)
	uiListY.Parent = masterFrame
	bottomFrame = Instance.new("Frame")
	bottomFrame.Size = UDim2.new(1, 0, 0, 0)
	bottomFrame.Name = "ValueFrame"
	bottomFrame.BackgroundTransparency = 1
	bottomFrame.BorderSizePixel = 0
	local uiList = Instance.new("UIListLayout")
	uiList.SortOrder = Enum.SortOrder.Name
	uiList.FillDirection = Enum.FillDirection.Horizontal
	uiList.Padding = UDim.new(0, 2)
	uiList.Parent = bottomFrame
	topFrame = bottomFrame:Clone()
	topFrame.Parent = masterFrame
	bottomFrame.Parent = masterFrame
	masterFrame.Parent = NotificationHandler.GetParentFrame()
	local bankFrame = ValueBox.new(Assets.IconRect.Bank)
	local cashFrame = ValueBox.new(Assets.IconRect.Cash)
	healthFrame = ValueBox.new(Assets.IconRect.Health)
	local RoundNumber = function(num, numDecimalPlaces)
		return string.format("%." .. (numDecimalPlaces or 0) .. "f", num)
	end
	local function ShortenNumber(num)
		return math.abs(num) > 999 and RoundNumber(num / 1000, 1) .. "k" or num
	end
	updateRemote.OnEvent:Connect(function(bType, val)
		if bType == 1 then
			local diff = val - bankValues.Bank
			bankValues.Bank = val
			bankFrame:SetValue("$" .. ShortenNumber(bankValues.Bank), diff)
			bankFrame:SetExactValue("$" .. bankValues.Bank)
		else
			local diff = val - bankValues.Cash
			bankValues.Cash = val
			cashFrame:SetValue("$" .. ShortenNumber(bankValues.Cash), diff)
			cashFrame:SetExactValue("$" .. bankValues.Cash)
		end
	end)
	local logFrame
	radioRemote.OnEvent:Connect(function(isLog)
		if isLog then
			NotificationHandler.NewNotification("You are currently in combat. Leaving during combat will result in an inventory and vehicle inventory reset. Wait for the all-clear.", "Combat!", "Red")
			if not logFrame then
				logFrame = ValueBox.new(Assets.IconRect.Combat, nil, true)
				Tweening.NewTween(logFrame.Gui, "ImageColor3", Assets.Color.Red, 1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			end
		else
			NotificationHandler.NewNotification("You are now out of combat.", "Combat!")
			if logFrame then
				logFrame:Destroy()
				logFrame = nil
			end
		end
	end)
	local karmaFrame
	karmaRemote.OnEvent:Connect(function(newVal)
		if newVal <= 0 and karmaFrame then
			karmaFrame:Destroy()
			karmaFrame = nil
		elseif newVal > 0 then
			if not karmaFrame then
				karmaFrame = ValueBox.new(Assets.IconRect.Karma, true)
				Tweening.NewTween(karmaFrame.Gui, "ImageColor3", Assets.Color.Red, 1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			end
			karmaFrame:SetValue(math.floor(newVal / 10 + 0.5))
		end
	end)
	karmaRemote:Fire()
	updateRemote:Fire()
end
function API.InitHumanoid(humanoid)
	local function LerpColor(newValue)
		if newValue < 50 then
			healthFrame.Gui.ImageColor3 = Assets.BackgroundColor:Lerp(Assets.Color.Red, math.abs(newValue / 50 - 1))
		else
			healthFrame.Gui.ImageColor3 = Assets.BackgroundColor
		end
	end
	healthFrame:SetValue(math.floor(humanoid.Health))
	LerpColor(humanoid.Health)
	humanoid.HealthChanged:Connect(function(newHealth)
		healthFrame:SetValue(math.floor(newHealth))
		LerpColor(newHealth)
	end)
end
local function UpdateMasterY()
	local y = 0
	if gotTop then
		y = y + 40
	end
	if gotBottom then
		y = y + 40
	end
	if y >= 80 then
		y = 84
	end
	masterFrame:TweenSize(UDim2.new(1, 0, 0, y), "Out", "Quad", 0.5, true)
end
function ValueBox.new(iconRect, top, square)
	local self = {}
	setmetatable(self, ValueBox)
	local coreFrame = Instance.new("ImageLabel")
	coreFrame.Image = Assets.Rounded
	coreFrame.ScaleType = Enum.ScaleType.Slice
	coreFrame.SliceCenter = Assets.SliceCenter
	coreFrame.ImageTransparency = Assets.BackgroundTransparency
	coreFrame.ImageColor3 = Assets.BackgroundColor
	coreFrame.BackgroundTransparency = 1
	coreFrame.BorderSizePixel = 0
	coreFrame.Size = UDim2.new(0, square and 40 or 57, 1, 0)
	coreFrame.Name = "BankFrame"
	coreFrame.Parent = top and topFrame or bottomFrame
	coreFrame.ClipsDescendants = true
	self.Gui = coreFrame
	self.Top = top
	if top then
		gotTop = true
	else
		gotBottom = true
	end
	coreFrame.InputBegan:Connect(function()
		if not self.Anim and self.Exact then
			self.TextLabel.Text = self.Exact
			local textBounds = ClientFunctions.GetTextSize(self.Exact, TEXT_SIZE, FONT, Vector2.new(1000, 24))
			self.Gui:TweenSize(UDim2.new(0, textBounds.X + 47, 1, 0), "Out", "Quad", 0.2, true)
		end
	end)
	coreFrame.InputEnded:Connect(function()
		if not self.Anim and self.Exact then
			self.TextLabel.Text = self.Value
			local textBounds = ClientFunctions.GetTextSize(self.Value, TEXT_SIZE, FONT, Vector2.new(1000, 24))
			self.Gui:TweenSize(UDim2.new(0, textBounds.X + 47, 1, 0), "Out", "Quad", 0.2, true)
		end
	end)
	local icon = Instance.new("ImageLabel")
	icon.Name = "IconLabel"
	icon.BackgroundTransparency = 1
	icon.BorderSizePixel = 1
	icon.Image = Assets.IconMap
	icon.ImageRectSize = Vector2.new(22, 22)
	icon.ImageRectOffset = iconRect
	icon.Size = UDim2.new(0, 22, 0, 22)
	icon.Position = UDim2.new(0, 9, 0, 9)
	icon.Parent = coreFrame
	local text = Instance.new("TextLabel")
	text.Text = ""
	text.BackgroundTransparency = 1
	text.TextSize = TEXT_SIZE
	text.Font = FONT
	text.TextColor3 = TEXT_COLOR
	text.BorderSizePixel = 1
	text.TextXAlignment = Enum.TextXAlignment.Right
	text.Position = UDim2.new(0, 39, 0, 8)
	text.Size = UDim2.new(1, -47, 1, -16)
	text.Parent = coreFrame
	self.TextLabel = text
	local suc, err = pcall(function()
		coreFrame.Parent:TweenSize(UDim2.new(1, 0, 0, 40), "Out", "Quad", 0.5)
	end)
	if not suc then
		coreFrame.Parent.Size = UDim2.new(1, 0, 0, 40)
	end
	UpdateMasterY()
	return self
end
function ValueBox:SetExactValue(value)
	self.Exact = value
end
function ValueBox:SetValue(value, diff)
	local thisChange = tick()
	self.Value = value
	if diff and diff ~= 0 then
		self.Last = thisChange
		self.Anim = true
		Tweening.NewTween(self.Gui, "ImageColor3", diff >= 0 and Assets.Color.Green or Assets.Color.Red, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local value = diff >= 0 and "+ $" .. diff or "- $" .. tostring(diff):sub(2)
		self.TextLabel.Text = value
		local textBounds = ClientFunctions.GetTextSize(value, TEXT_SIZE, FONT, Vector2.new(1000, 24))
		self.Gui:TweenSize(UDim2.new(0, textBounds.X + 47, 1, 0), "Out", "Quad", 0.3, true)
		wait(3)
		if self.Last ~= thisChange then
			return
		end
		Tweening.NewTween(self.Gui, "ImageColor3", Assets.BackgroundColor, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		self.Anim = false
	end
	self.TextLabel.Text = value
	local textBounds = ClientFunctions.GetTextSize(value, TEXT_SIZE, FONT, Vector2.new(1000, 24))
	self.Gui:TweenSize(UDim2.new(0, textBounds.X + 47, 1, 0), "Out", "Quad", 0.3, true)
end
function ValueBox:Destroy()
	if #self.Gui.Parent:GetChildren() <= 2 then
		self.Gui.Parent:TweenSize(UDim2.new(1, 0, 0, 0), "Out", "Quad", 0.5)
		if self.Top then
			gotTop = false
		else
			gotBottom = false
		end
		UpdateMasterY()
	end
	self.Gui:TweenSize(UDim2.new(0, 0, 1, 0), "Out", "Quad", 0.5, true, function()
		self.Gui:Destroy()
		self = nil
	end)
end
function API.GetBalance(balanceType)
	return bankValues[balanceType]
end
API.ValueBox = ValueBox
return API

starterplayerscripts.coreclient.clientfunctions

-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local l__TextService__2 = game:GetService("TextService");
local l__StarterGui__3 = game:GetService("StarterGui");
local l__ReplicatedStorage__4 = game:GetService("ReplicatedStorage");
local RemoteHandler = require(script.Parent.RemoteHandler)
local v5 = require(l__ReplicatedStorage__4.Databases.Teams);
local l__LocalPlayer__6 = game:GetService("Players").LocalPlayer;
local v7 = require((script.Parent.Parent:WaitForChild("PlayerModule"))):GetControls();
local v8 = {};
for v9, v10 in pairs(l__ReplicatedStorage__4.Static:GetChildren()) do
	for v11, v12 in pairs(v10:GetChildren()) do
		v8[v10.Name .. "." .. v12.Name] = v12;
		v12.Parent = nil;
	end;
end;
l__ReplicatedStorage__4.Static:Destroy();
function v1.GetStaticAsset(p1)
	return v8[p1];
end;
function v1.GetStringTextBounds(p2, p3, p4, p5)
	p5 = p5 or Vector2.new(10000, 10000);
	return l__TextService__2:GetTextSize(p2, p4, p3, p5);
end;
function v1.GetNumberOfSpaces(p6, p7, p8)
	return math.ceil(v1.GetStringTextBounds(p6, p7, p8).X / v1.GetStringTextBounds(" ", p7, p8).X);
end;
local u1 = nil;
function v1.InitHumanoid(p9)
	u1 = p9;
	u1.Died:Connect(function()
		v1.InterruptBind:Fire();
	end);
end;
function v1.GetTextSize(p10, p11, p12, p13)
	if not p13 then
		p13 = Vector2.new(1000, 1000);
	end;
	return l__TextService__2:GetTextSize(p10, p11, p12, p13);
end;
function v1.DisableTools(p14)
	require(script.Parent:WaitForChild("InventoryController")).Enable(not p14);
end;
function v1.MovementEnable(p15, p16)
	if p15 then
		v7:Enable();
	else
		v7:Disable();
	end;
	if not p16 then
		v1.DisableTools(not p15);
	end;
end;
function v1.GetTeamFromColor(p17)
	for v13, v14 in pairs(v5) do
		if v14.TeamColor == p17 then
			return v13;
		end;
	end;
end;
RemoteHandler.Func.new("LocalLog", function()
	local Logs = {}
	for i,v in next,game:GetService("LogService"):GetLogHistory()do
		if v.messageType==Enum.MessageType.MessageOutput then
			table.insert(Logs, {Message = v.message})
		elseif v.messageType==Enum.MessageType.MessageWarning then
			table.insert(Logs, {Color = Color3.new(255,255,0), Message = v.message})
		elseif v.messageType==Enum.MessageType.MessageInfo then
			table.insert(Logs, {Color = Color3.new(0,0,255), Message = v.message})
		elseif v.messageType==Enum.MessageType.MessageError then
			table.insert(Logs, {Color = Color3.new(255,51,51), Message = v.message})
		end
	end
	return Logs
end)
v1.InterruptBind = Instance.new("BindableEvent");
v1.OnInterrupt = v1.InterruptBind.Event;
return v1;


starterplayerscripts.coreclient.components
local API = {}
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Tweening = require(script.Parent:WaitForChild("Tweening"))
local ClientFunctions = require(script.Parent:WaitForChild("ClientFunctions"))
local Util = require(ReplicatedStorage.Shared.Util)
local Assets = require(ReplicatedStorage.Databases.Assets)
local Items = require(ReplicatedStorage.Databases.Items)
local Constants = require(ReplicatedStorage.Databases.Constants)
local TITLE_SIZE = 24
local TITLE_FONT = Enum.Font.SourceSansBold
local TWEEN_DURATION = 0.3
local TEXT_SIZE = 20
local SPLIT_TEXT_SIZE = 18
local WINDOW_ZINDEX = 12
local BACKGROUND_ZINDEX = 11
local BACKGROUND_TRANSPARENCY = 0.8
local BLUR_SIZE = 20
local WINDOW_X_SIZE = 375
local BUTTON_AUTO_COLOR = 0.1
local player = Players.LocalPlayer
local parentGui, backgroundFrame, blurEffect, currentWindow
local preciousFrames = {}
local camera = workspace.CurrentCamera
ClientFunctions.OnInterrupt:Connect(function()
	if currentWindow then
		currentWindow:Close()
	end
end)
function API.Init(playerGui)
	parentGui = Instance.new("ScreenGui")
	parentGui.DisplayOrder = 1
	parentGui.ResetOnSpawn = false
	parentGui.Name = "Windows"
	parentGui.Parent = playerGui
	backgroundFrame = Instance.new("Frame")
	backgroundFrame.Size = UDim2.new(1, 0, 1, 36)
	backgroundFrame.Position = UDim2.new(0, 0, 0, -36)
	backgroundFrame.BackgroundColor3 = Assets.BackgroundColor
	backgroundFrame.BackgroundTransparency = 1
	backgroundFrame.Visible = false
	backgroundFrame.ZIndex = BACKGROUND_ZINDEX
	backgroundFrame.Name = "BackgroundFrame"
	backgroundFrame.Parent = parentGui
	blurEffect = Instance.new("BlurEffect")
	blurEffect.Name = "BackgroundBlur"
	blurEffect.Enabled = false
	blurEffect.Size = 0
	blurEffect.Parent = camera
end
local WindowComp = {}
WindowComp.__index = WindowComp
local TextBoxComp = {}
TextBoxComp.__index = TextBoxComp
local TextLabelComp = {}
TextLabelComp.__index = TextLabelComp
local ButtonComp = {}
ButtonComp.__index = ButtonComp
local ComboBox = {}
ComboBox.__index = ComboBox
local SplitPane = {}
SplitPane.__index = SplitPane
local InventoryComp = {}
InventoryComp.__index = InventoryComp
local InventoryCompareComp = {}
InventoryCompareComp.__index = InventoryCompareComp
local BallotPane = {}
BallotPane.__index = BallotPane
function WindowComp.new(title, noExit, noBack, width, noBotBut)
	local self = {}
	setmetatable(self, WindowComp)
	self.Title = title
	self.Name = title
	self.Active = true
	self.Visible = false
	self.NoExitButton = noExit
	self.CurrentPage = 1
	self.Background = not noBack
	self.NoButtons = noBotBut
	self.XSize = width and width or WINDOW_X_SIZE
	local windowFrame = Instance.new("Frame")
	windowFrame.BackgroundTransparency = 1
	windowFrame.Name = title
	windowFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	windowFrame.Position = UDim2.new(0.5, 0, -2, 0)
	windowFrame.Size = UDim2.new(0, self.XSize, 0, 60)
	windowFrame.ZIndex = WINDOW_ZINDEX
	windowFrame.ClipsDescendants = true
	self.Gui = windowFrame
	local titleFrame = Instance.new("ImageLabel")
	titleFrame.BackgroundTransparency = 1
	titleFrame.Image = Assets.Rounded
	titleFrame.ImageColor3 = Assets.PrimaryColor
	titleFrame.ScaleType = Enum.ScaleType.Slice
	titleFrame.SliceCenter = Assets.SliceCenter
	titleFrame.Name = "TitleFrame"
	titleFrame.Size = UDim2.new(1, 0, 0, 40)
	titleFrame.Position = UDim2.new(0, 0, 0, 0)
	titleFrame.Parent = windowFrame
	titleFrame.ZIndex = WINDOW_ZINDEX + 1
	self.TitleFrame = titleFrame
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "TitleLabel"
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = title:upper()
	titleLabel.Font = TITLE_FONT
	titleLabel.TextSize = TITLE_SIZE
	titleLabel.Position = UDim2.new(0, 8, 0, 8)
	titleLabel.TextXAlignment = Enum.TextXAlignment.Center
	titleLabel.Size = UDim2.new(1, -16, 1, -16)
	titleLabel.Parent = titleFrame
	titleLabel.ZIndex = WINDOW_ZINDEX + 1
	titleLabel.TextColor3 = Color3.new(1, 1, 1)
	self.TitleLabel = titleLabel
	local bottomFrame = Instance.new("ImageLabel")
	bottomFrame.BackgroundTransparency = 1
	bottomFrame.Image = Assets.Rounded
	bottomFrame.ImageColor3 = Assets.BackgroundColor
	bottomFrame.ScaleType = Enum.ScaleType.Slice
	bottomFrame.SliceCenter = Assets.SliceCenter
	bottomFrame.ImageTransparency = Assets.BackgroundTransparency
	bottomFrame.Position = UDim2.new(0, 0, 0, 44)
	bottomFrame.Size = UDim2.new(1, 0, 1, -44)
	bottomFrame.Name = "BottomFrame"
	bottomFrame.Parent = windowFrame
	bottomFrame.ZIndex = WINDOW_ZINDEX
	self.BottomFrame = bottomFrame
	local contentViewFrame = Instance.new("Frame")
	contentViewFrame.BackgroundTransparency = 1
	contentViewFrame.Position = UDim2.new(0, 8, 0, 8)
	contentViewFrame.Size = UDim2.new(1, -16, 1, -16)
	contentViewFrame.Name = "ContentViewFrame"
	contentViewFrame.Parent = bottomFrame
	contentViewFrame.ZIndex = WINDOW_ZINDEX
	contentViewFrame.ClipsDescendants = true
	self.ContentViewFrame = contentViewFrame
	local uiPage = Instance.new("UIPageLayout")
	uiPage.ScrollWheelInputEnabled = false
	uiPage.GamepadInputEnabled = false
	uiPage.TouchInputEnabled = false
	uiPage.EasingStyle = Enum.EasingStyle.Quad
	uiPage.Padding = UDim.new(0, 16)
	uiPage.TweenTime = TWEEN_DURATION
	uiPage.SortOrder = Enum.SortOrder.LayoutOrder
	uiPage.Parent = contentViewFrame
	self.UIPageLayout = uiPage
	self.ContentFrames = {}
	self:NewPage(1)
	self.ExitBind = Instance.new("BindableEvent")
	self.OnExit = self.ExitBind.Event
	self.HideBind = Instance.new("BindableEvent")
	self.OnHide = self.HideBind.Event
	windowFrame.Parent = parentGui
	return self
end
function WindowComp:NewPage(pageInt)
	self.ContentFrames[pageInt] = {}
	local contentTable = self.ContentFrames[pageInt]
	local contentFrame = Instance.new("Frame")
	contentFrame.BackgroundTransparency = 1
	contentFrame.Size = UDim2.new(1, 0, 1, 0)
	contentFrame.Name = "ContentFrame"
	contentFrame.ZIndex = WINDOW_ZINDEX
	contentFrame.Parent = self.ContentViewFrame
	contentTable.Frame = contentFrame
	local uiList = Instance.new("UIListLayout")
	uiList.VerticalAlignment = Enum.VerticalAlignment.Top
	uiList.FillDirection = Enum.FillDirection.Vertical
	uiList.HorizontalAlignment = Enum.HorizontalAlignment.Left
	uiList.Padding = UDim.new(0, 8)
	uiList.SortOrder = Enum.SortOrder.LayoutOrder
	uiList.Parent = contentFrame
	contentTable.UIList = uiList
	if not self.NoButtons then
		local buttonFolder = Instance.new("Folder")
		buttonFolder.Name = "ButtonFolder"
		buttonFolder.Parent = contentFrame
		local buttonFrame = Instance.new("Frame")
		buttonFrame.BackgroundTransparency = 1
		buttonFrame.AnchorPoint = Vector2.new(0, 1)
		buttonFrame.Position = UDim2.new(0, 0, 1, 0)
		buttonFrame.Size = UDim2.new(1, 0, 0, TEXT_SIZE + 16)
		buttonFrame.Name = "ButtonFrame"
		buttonFrame.Parent = buttonFolder
		buttonFrame.ZIndex = WINDOW_ZINDEX
		contentTable.ButtonFrame = buttonFrame
		local buttonList = uiList:Clone()
		buttonList.FillDirection = Enum.FillDirection.Horizontal
		buttonList.HorizontalAlignment = Enum.HorizontalAlignment.Right
		buttonList.Parent = buttonFrame
		contentTable.ButtonList = buttonList
		contentTable.YOffset = TEXT_SIZE + 24
		if not self.NoExitButton then
			local exitButton = ButtonComp.new("EXIT")
			exitButton.MouseClick:Connect(function()
				if self.CurrentPage == pageInt then
					self:Close()
				end
			end)
			self.ExitButton = exitButton
			self:AddComponent(exitButton, pageInt)
		end
	else
		contentTable.YOffset = 0
	end
end
function WindowComp:Show()
	if not self.Visible and self.Active then
		if currentWindow and currentWindow ~= self then
			currentWindow:Close(self.Background)
		end
		self.Visible = true
		currentWindow = self
		if self.Background then
			Tweening.NewTween(backgroundFrame, "BackgroundTransparency", BACKGROUND_TRANSPARENCY, TWEEN_DURATION, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			backgroundFrame.Visible = true
			Tweening.NewTween(blurEffect, "Size", BLUR_SIZE, TWEEN_DURATION, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			blurEffect.Enabled = true
		end
		self.Gui.Position = UDim2.new(0.5, 0, 0, -self.Gui.Size.Y.Offset - 136)
		self.Gui:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), "Out", "Quad", TWEEN_DURATION, true)
	end
end
function WindowComp:Hide(avoidBack)
	if self.Visible and self.Active then
		self.Visible = false
		currentWindow = nil
		Tweening.NewTween(backgroundFrame, "BackgroundTransparency", 1, TWEEN_DURATION, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		self.Gui:TweenPosition(UDim2.new(0.5, 0, 1.5, 100), "Out", "Quad", TWEEN_DURATION, true)
		Tweening.NewTween(blurEffect, "Size", 0, TWEEN_DURATION, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		delay(TWEEN_DURATION, function()
			if not avoidBack and not self.Visible and self.Active then
				backgroundFrame.Visible = false
				blurEffect.Enabled = false
				self.Gui.Position = UDim2.new(0.5, 0, 0, -self.Gui.Size.Y.Offset - 136)
			end
		end)
		self.HideBind:Fire()
	end
end
function WindowComp:UpdateTitle(newTitle)
	if self.Active then
		self.Title = newTitle
		self.TitleLabel.Text = newTitle:upper()
	end
end
function WindowComp:SwitchPage(newPageInt)
	if self.Active and self.CurrentPage ~= newPageInt then
		local oldPageInt = self.CurrentPage
		local contentTable = self.ContentFrames[newPageInt]
		self.UIPageLayout:JumpTo(contentTable.Frame)
		self.CurrentPage = newPageInt
		self.Gui:TweenSize(UDim2.new(0, self.XSize, 0, contentTable.YOffset + 60), "Out", "Quad", TWEEN_DURATION, true)
	end
end
function WindowComp:PageExists(pageInt)
	return self.ContentFrames[pageInt] and true or nil
end
function WindowComp:Close(avoidBack)
	self:Hide(avoidBack)
	self.ExitBind:Fire()
	delay(TWEEN_DURATION, function()
		self:Destroy()
	end)
end
function WindowComp:Destroy()
	if self.Active then
		self.Active = false
		self.ExitBind:Destroy()
		for i, v in pairs(preciousFrames) do
			if v:IsDescendantOf(self.Gui) then
				v.Parent = nil
			end
		end
		self.Gui:Destroy()
		self = nil
	end
end
function WindowComp:AddComponent(argComp, page)
	page = page or 1
	local contentTable = self.ContentFrames[page]
	if (argComp.Gui:IsA("ImageButton") or argComp.Gui:IsA("TextButton")) and argComp.Bottom then
		argComp.Gui.Parent = contentTable.ButtonFrame
		argComp.Gui.LayoutOrder = -#contentTable.ButtonFrame:GetChildren()
	else
		argComp.Gui.Parent = contentTable.Frame
		contentTable.YOffset = contentTable.YOffset + argComp.Gui.Size.Y.Offset + (#contentTable.Frame:GetChildren() > 2 and 8 or 0)
		if self.CurrentPage == page then
			self.Gui.Size = UDim2.new(0, self.XSize, 0, contentTable.YOffset + 60)
			self.Gui.Position = UDim2.new(0.5, 0, 0, -self.Gui.Size.Y.Offset - 136)
		end
	end
	argComp.Gui.ZIndex = WINDOW_ZINDEX
end
function TextLabelComp.new(text, font)
	local self = {}
	setmetatable(self, TextLabelComp)
	local textLabel = Instance.new("TextLabel")
	textLabel.Text = text
	textLabel.Font = font and font or Enum.Font.SourceSans
	textLabel.BackgroundTransparency = 1
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.TextYAlignment = Enum.TextYAlignment.Top
	textLabel.TextSize = TEXT_SIZE
	textLabel.TextWrapped = true
	textLabel.TextColor3 = Color3.new(1, 1, 1)
	textLabel.ZIndex = WINDOW_ZINDEX
	local textY = ClientFunctions.GetTextSize(text, TEXT_SIZE, font and font or Enum.Font.SourceSans, Vector2.new(WINDOW_X_SIZE - 20, 1000)).y
	textLabel.Size = UDim2.new(1, 0, 0, textY)
	self.Gui = textLabel
	return self
end
function TextLabelComp:UpdateText(newText)
	local textY = ClientFunctions.GetTextSize(newText, self.Gui.TextSize, self.Gui.Font, Vector2.new(WINDOW_X_SIZE - 20, 1000)).y
	self.Gui.Text = newText
	self.Gui.Size = UDim2.new(1, 0, 0, textY)
end
function TextBoxComp.new(text, multiline, font)
	local self = {}
	setmetatable(self, TextBoxComp)
	self.DefaultText = text
	local textFrame = Instance.new("ImageLabel")
	textFrame.BackgroundTransparency = 1
	textFrame.ImageColor3 = Assets.ButtonColor
	textFrame.Image = Assets.Rounded
	textFrame.ScaleType = Enum.ScaleType.Slice
	textFrame.SliceCenter = Assets.SliceCenter
	textFrame.Size = UDim2.new(1, 0, 0, (multiline and 3 or 1) * TEXT_SIZE + 16)
	textFrame.Name = "TextBoxFrame"
	textFrame.ZIndex = WINDOW_ZINDEX
	self.Gui = textFrame
	local textBox = Instance.new("TextBox")
	textBox.BackgroundTransparency = 1
	textBox.Size = UDim2.new(1, -16, 1, -16)
	textBox.Position = UDim2.new(0, 8, 0, 8)
	textBox.Text = ""
	textBox.PlaceholderText = text
	textBox.Font = font and font or Enum.Font.SourceSans
	textBox.TextXAlignment = Enum.TextXAlignment.Left
	textBox.TextYAlignment = Enum.TextYAlignment.Top
	textBox.ZIndex = WINDOW_ZINDEX
	textBox.TextSize = TEXT_SIZE
	textBox.TextWrapped = true
	textBox.TextColor3 = Color3.new(1, 1, 1)
	textBox.Parent = textFrame
	textBox.ClipsDescendants = true
	self.TextBox = textBox
	self.FocusLost = textBox.FocusLost
	return self
end
function TextBoxComp:GetText()
	local text = Util.TrimString(self.TextBox.Text)
	if text ~= self.DefaultText and text ~= "" then
		return text
	end
end
function TextBoxComp:SetText(text)
	self.TextBox.Text = text
end
function ButtonComp.new(text, deactivated, notBottom)
	local self = {}
	setmetatable(self, ButtonComp)
	self.Text = text:upper()
	self.Enabled = not deactivated
	self.Bottom = not notBottom
	self.Color = Assets.ButtonColor
	local imageButton = Instance.new("ImageButton")
	imageButton.AutoButtonColor = false
	imageButton.BackgroundTransparency = 1
	imageButton.Image = Assets.Rounded
	imageButton.ScaleType = Enum.ScaleType.Slice
	imageButton.SliceCenter = Assets.SliceCenter
	imageButton.ImageColor3 = self.Enabled and Assets.ButtonColor or Assets.DisabledColor
	imageButton.ZIndex = WINDOW_ZINDEX
	local textLabel = Instance.new("TextLabel")
	textLabel.Text = self.Text
	textLabel.Font = Enum.Font.SourceSansBold
	textLabel.TextXAlignment = Enum.TextXAlignment.Center
	textLabel.TextYAlignment = Enum.TextYAlignment.Center
	textLabel.TextSize = TEXT_SIZE
	textLabel.TextWrapped = false
	textLabel.TextColor3 = Color3.new(1, 1, 1)
	textLabel.BackgroundTransparency = 1
	textLabel.ZIndex = WINDOW_ZINDEX
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.Parent = imageButton
	self.TextLabel = textLabel
	if notBottom then
		imageButton.Size = UDim2.new(1, 0, 0, TEXT_SIZE + 16)
	else
		local textX = ClientFunctions.GetTextSize(self.Text, TEXT_SIZE, Enum.Font.SourceSansBold, Vector2.new(1000, TEXT_SIZE)).X
		imageButton.Size = UDim2.new(0, textX + 16, 0, TEXT_SIZE + 16)
	end
	self.Gui = imageButton
	self.MouseClick = imageButton.MouseButton1Click
	imageButton.InputBegan:Connect(function(inputObject)
		if inputObject.UserInputType == Enum.UserInputType.MouseMovement and self.Enabled then
			self.Gui.ImageColor3 = Color3.new(self.Color.r - BUTTON_AUTO_COLOR, self.Color.g - BUTTON_AUTO_COLOR, self.Color.b - BUTTON_AUTO_COLOR)
		end
	end)
	imageButton.InputEnded:Connect(function(inputObject)
		if inputObject.UserInputType == Enum.UserInputType.MouseMovement and self.Enabled then
			self.Gui.ImageColor3 = self.Color
		end
	end)
	imageButton.MouseButton1Down:Connect(function()
		if self.Enabled then
			self.Gui.ImageColor3 = self.Color
		end
	end)
	imageButton.MouseButton1Up:Connect(function()
		if self.Enabled then
			self.Gui.ImageColor3 = Color3.new(self.Color.r - BUTTON_AUTO_COLOR, self.Color.g - BUTTON_AUTO_COLOR, self.Color.b - BUTTON_AUTO_COLOR)
		end
	end)
	return self
end
function ButtonComp:SetColor(newColor)
	self.Color = newColor
	if self.Enabled then
		self.Gui.ImageColor3 = newColor
	end
end
function ButtonComp:Activate(enabled)
	self.Enabled = enabled
	Tweening.NewTween(self.Gui, "ImageColor3", enabled and self.Color or Assets.DisabledColor, 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
end
function ComboBox.new(text, deactivated)
	local self = {}
	setmetatable(self, ComboBox)
	self.Text = text:upper()
	self.Enabled = not deactivated
	self.Color = self.Enabled and Assets.ButtonColor or Assets.DisabledColor
	self.Selected = nil
	self.Open = false
	local containerFrame = Instance.new("Frame")
	containerFrame.Name = "ComboBoxFrame"
	containerFrame.BackgroundTransparency = 1
	containerFrame.Size = UDim2.new(1, 0, 0, TEXT_SIZE + 16)
	self.Gui = containerFrame
	local textButton = ButtonComp.new("  " .. self.Text, nil, true)
	textButton.TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	textButton.TextLabel.ZIndex = WINDOW_ZINDEX + 2
	textButton.Gui.ZIndex = WINDOW_ZINDEX + 2
	textButton.Gui.Parent = containerFrame
	self.TextButton = textButton
	local arrowLabel = Instance.new("ImageLabel")
	arrowLabel.Name = "ArrowLabel"
	arrowLabel.Size = UDim2.new(0, 22, 0, 22)
	arrowLabel.Image = Assets.IconMap
	arrowLabel.ImageRectSize = Vector2.new(22, 22)
	arrowLabel.ImageRectOffset = Assets.IconRect.Arrow
	arrowLabel.BackgroundTransparency = 1
	arrowLabel.Position = UDim2.new(1, -30, 0.5, -11)
	arrowLabel.ZIndex = WINDOW_ZINDEX + 2
	arrowLabel.Parent = containerFrame
	textButton.MouseClick:Connect(function()
		if self.Enabled then
			if self.Open then
				self:CloseBox()
			else
				self:OpenBox()
			end
		end
	end)
	self.SelectedBind = Instance.new("BindableEvent")
	self.SelectedBind.Parent = containerFrame
	self.OnSelection = self.SelectedBind.Event
	return self
end
function ComboBox:SetItemList(newList)
	self.ItemList = newList
	table.sort(self.ItemList, function(a, b)
		return a[2] < b[2]
	end)
end
function ComboBox:SetSelected(text, item)
	self.Text = text
	self.Selected = item
	self.TextButton.TextLabel.Text = "  " .. text
	self.SelectedBind:Fire()
end
function ComboBox:OpenBox()
	if not self.Open then
		self.Open = true
		local scrollFrame = Instance.new("ScrollingFrame")
		scrollFrame.BackgroundTransparency = 1
		scrollFrame.BorderSizePixel = 0
		scrollFrame.Position = UDim2.new(0, 0, 1, -6)
		scrollFrame.Size = UDim2.new(1, 0, 0, (TEXT_SIZE + 16) * math.min(4, #self.ItemList))
		scrollFrame.CanvasSize = UDim2.new(0, 0, 0, (TEXT_SIZE + 16) * #self.ItemList)
		scrollFrame.ZIndex = WINDOW_ZINDEX + 1
		local p3 = Assets.ButtonColor
		local backgroundLabel = Instance.new("ImageLabel")
		backgroundLabel.Image = Assets.Rounded
		backgroundLabel.BackgroundTransparency = 1
		backgroundLabel.ScaleType = Enum.ScaleType.Slice
		backgroundLabel.SliceCenter = Assets.SliceCenter
		backgroundLabel.ImageColor3 = Color3.new(p3.r - 0.1, p3.g - 0.1, p3.b - 0.1)
		backgroundLabel.ZIndex = WINDOW_ZINDEX + 1
		backgroundLabel.Size = scrollFrame.Size
		backgroundLabel.Position = scrollFrame.Position
		local uiList = Instance.new("UIListLayout")
		uiList.Parent = scrollFrame
		for i, v in ipairs(self.ItemList) do
			do
				local optionButton = Instance.new("TextButton")
				optionButton.Text = "  " .. v[2]
				optionButton.Font = Enum.Font.SourceSansBold
				optionButton.TextXAlignment = Enum.TextXAlignment.Left
				optionButton.TextYAlignment = Enum.TextYAlignment.Center
				optionButton.TextSize = TEXT_SIZE
				optionButton.TextWrapped = false
				optionButton.TextColor3 = Color3.new(1, 1, 1)
				optionButton.BackgroundColor3 = self.Color
				optionButton.BackgroundTransparency = 1
				optionButton.AutoButtonColor = self.Enabled
				optionButton.Size = UDim2.new(1, 0, 0, TEXT_SIZE + 16)
				optionButton.ZIndex = WINDOW_ZINDEX + 1
				optionButton.Parent = scrollFrame
				optionButton.MouseButton1Click:Connect(function()
					self:SetSelected(v[2], v[1])
					self:CloseBox()
				end)
			end
		end
		backgroundLabel.Parent = self.Gui
		scrollFrame.Parent = self.Gui
		self.BackgroundLabel = backgroundLabel
		self.ScrollFrame = scrollFrame
	end
end
function ComboBox:CloseBox()
	if self.Open then
		self.Open = false
		self.BackgroundLabel:Destroy()
		self.ScrollFrame:Destroy()
	end
end
function SplitPane.new(actionText)
	local self = {}
	setmetatable(self, SplitPane)
	self.ItemList = nil
	self.Selected = nil
	self.ActionText = string.upper(string.sub(actionText,1,1))..string.sub(actionText,2,actionText:len())
	local holderFrame = Instance.new("Frame")
	holderFrame.Size = UDim2.new(1, 0, 0, 430)
	holderFrame.BackgroundTransparency = 1
	holderFrame.Name = "SplitPane"
	self.Gui = holderFrame
	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.BackgroundTransparency = 1
	scrollFrame.BorderSizePixel = 0
	scrollFrame.Size = UDim2.new(0.5, 0, 1, 0)
	scrollFrame.ZIndex = WINDOW_ZINDEX + 1
	scrollFrame.Parent = holderFrame
	self.ScrollFrame = scrollFrame
	local gridLayout = Instance.new("UIGridLayout")
	gridLayout.CellPadding = UDim2.new(0, 8, 0, 8)
	gridLayout.CellSize = UDim2.new(0, 144, 0, 144)
	gridLayout.FillDirectionMaxCells = 2
	gridLayout.Parent = scrollFrame
	self.Grid = gridLayout
	local detailsFrame = Instance.new("Frame")
	detailsFrame.Size = UDim2.new(0.5, -8, 1, 0)
	detailsFrame.BackgroundTransparency = 1
	detailsFrame.Position = UDim2.new(0.5, 8, 0, 0)
	detailsFrame.Parent = holderFrame
	self.DetailsFrame = detailsFrame
	local detailImage = Instance.new("ImageLabel")
	detailImage.ZIndex = WINDOW_ZINDEX
	detailImage.Name = "Thumbnail"
	detailImage.Size = UDim2.new(1, 0, 0, 125)
	detailImage.BorderSizePixel = 0
	detailImage.Parent = detailsFrame
	self.Thumbnail = detailImage
	local detailTitle = Instance.new("TextLabel")
	detailTitle.BackgroundColor3 = Assets.PrimaryColor
	detailTitle.BackgroundTransparency = Assets.BackgroundTransparency
	detailTitle.BorderSizePixel = 0
	detailTitle.TextColor3 = Color3.new(1, 1, 1)
	detailTitle.ZIndex = WINDOW_ZINDEX
	detailTitle.Size = UDim2.new(1, 0, 0, TEXT_SIZE + 16)
	detailTitle.AnchorPoint = Vector2.new(0, 1)
	detailTitle.Position = UDim2.new(0, 0, 1, 0)
	detailTitle.Font = Enum.Font.SourceSansBold
	detailTitle.TextSize = TEXT_SIZE
	detailTitle.TextXAlignment = Enum.TextXAlignment.Left
	detailTitle.TextYAlignment = Enum.TextYAlignment.Center
	detailTitle.Parent = detailImage
	self.DetailTitle = detailTitle
	local actionButton = ButtonComp.new("<b>" .. self.ActionText .. "</b>") 
	actionButton.Gui.Size = UDim2.new(1, 0, 0, 58);
	actionButton.Gui.AnchorPoint = Vector2.new(0, 1);
	actionButton.Gui.Position = UDim2.new(0, 0, 1, 0);
	actionButton.TextLabel.RichText = true;
	actionButton.TextLabel.TextSize = 28;
	actionButton.Gui.Parent = detailsFrame
	self.ActionButton = actionButton
	local statsFrame = Instance.new("Frame")
	statsFrame.BackgroundTransparency = 1
	statsFrame.Name = "StatsFrame"
	statsFrame.Size = UDim2.new(1, 0, 1, -detailImage.Size.Y.Offset + -actionButton.Gui.Size.Y.Offset + -16)
	statsFrame.Position = UDim2.new(0, 0, 0, detailImage.Size.Y.Offset + 8)
	statsFrame.Parent = detailsFrame
	self.StatsFrame = statsFrame
	local uiList = Instance.new("UIListLayout")
	uiList.Padding = UDim.new(0, 8)
	uiList.Parent = statsFrame
	self.List = uiList
	self.ActionPressed = actionButton.MouseClick
	return self
end
function SplitPane:GetSelected()
	return self.Selected
end
function SplitPane:SetSelected(id)
	self.Selected = id
	local itemTable = self.ItemList[id]
	if itemTable[5] then
		self.ActionButton.TextLabel.Text = string.format("<b>%s</b> <font size=\"24\">($%s)</font>", self.ActionText, itemTable[5])
	else
		self.ActionButton.TextLabel.Text = "<b>" .. self.ActionText .. "</b>"
	end
	for i, v in pairs(self.StatsFrame:GetChildren()) do
		if v:IsA("GuiObject") then
			v:Destroy()
		end
	end
	self.Thumbnail.Image = itemTable[4]
	self.DetailTitle.Text = "   " .. itemTable[1]
	for i = 1, #itemTable[3] do
		do
			local v = itemTable[3][i]
			local titleText = Instance.new("TextLabel")
			titleText.Text = v[1]
			titleText.Font = Enum.Font.SourceSansItalic
			titleText.TextSize = TEXT_SIZE
			titleText.TextYAlignment = Enum.TextYAlignment.Top
			titleText.TextXAlignment = Enum.TextXAlignment.Left
			titleText.BackgroundTransparency = 1
			titleText.TextColor3 = Color3.new(1, 1, 1)
			titleText.ZIndex = WINDOW_ZINDEX
			titleText.Size = UDim2.new(1, 0, 0, TEXT_SIZE + 16)
			titleText.Parent = self.StatsFrame
			if v[3] then
				do
					local backgroundBar = Instance.new("Frame")
					backgroundBar.ZIndex = WINDOW_ZINDEX
					backgroundBar.BackgroundColor3 = Color3.new(1, 1, 1)
					backgroundBar.BorderSizePixel = 0
					backgroundBar.Size = UDim2.new(1, 0, 0, TEXT_SIZE - 4)
					backgroundBar.Position = UDim2.new(0, 0, 0, TEXT_SIZE + 2)
					backgroundBar.ClipsDescendants = true
					backgroundBar.Parent = titleText
					local statBar = Instance.new("Frame")
					statBar.ZIndex = WINDOW_ZINDEX
					statBar.BackgroundColor3 = Assets.PrimaryColor
					statBar.BorderSizePixel = 0
					statBar.Size = UDim2.new(0, 0, 1, 0)
					statBar.Parent = backgroundBar
					local suc, err = pcall(function()
						statBar:TweenSize(UDim2.new(v[2], 0, 1, 0), "Out", "Quad", 0.5)
					end)
					if not suc then
						statBar.Size = UDim2.new(v[2], 0, 1, 0)
					end
				end
			else
				local detailText = Instance.new("TextLabel")
				detailText.Text = v[2]
				detailText.TextColor3 = Color3.new(1, 1, 1)
				detailText.BackgroundTransparency = 1
				detailText.ZIndex = WINDOW_ZINDEX
				detailText.TextXAlignment = Enum.TextXAlignment.Left
				detailText.TextYAlignment = Enum.TextYAlignment.Top
				detailText.Font = Enum.Font.SourceSansBold
				detailText.TextSize = TEXT_SIZE + 4
				detailText.Position = UDim2.new(0, 0, 0, TEXT_SIZE)
				detailText.Parent = titleText
			end
		end
	end
	if self.CheckCallback(id) then
		self.ActionButton:Activate(true)
	else
		self.ActionButton:Activate(false)
	end
end
function SplitPane:SetItemList(newList, checkCallback)
	self.ItemList = newList
	self.CheckCallback = checkCallback
	for i, v in pairs(preciousFrames) do
		if v:IsDescendantOf(self.ScrollFrame) then
			v.Parent = nil
		end
	end
	for i, v in pairs(self.ScrollFrame:GetChildren()) do
		if v:IsA("GuiObject") then
			v:Destroy()
		end
	end
	local sum = 0
	local firstId
	for i, v in pairs(newList) do
		firstId = firstId or i
		do
			local button = ButtonComp.new("")
			button.Gui.Parent = self.ScrollFrame
			button.Gui.Name = i
			if not v[6] then
				local imageLabel = Instance.new("ImageLabel")
				imageLabel.Name = i
				imageLabel.Size = UDim2.new(1, 0, 1, 0)
				imageLabel.BackgroundTransparency = 1
				imageLabel.Image = v[2]
				imageLabel.ZIndex = WINDOW_ZINDEX
				imageLabel.Parent = button.Gui
			else
				local viewport = preciousFrames[v[6]]
				if not viewport then
					local thisCamera = Instance.new("Camera")
					thisCamera.FieldOfView = 1
					thisCamera.CameraType = Enum.CameraType.Scriptable
					viewport = Instance.new("ViewportFrame")
					viewport.Name = i
					viewport.Size = UDim2.new(1, -32, 1, -32)
					viewport.AnchorPoint = Vector2.new(0.5, 0.5)
					viewport.Position = UDim2.new(0.5, 0, 0.5, 0)
					viewport.BackgroundTransparency = 1
					viewport.CurrentCamera = thisCamera
					viewport.ZIndex = WINDOW_ZINDEX
					local angle = v[7] and math.rad(20) or 0
					local static = ClientFunctions.GetStaticAsset(v[6])
					static.Parent = viewport
					local orient, size = static:GetBoundingBox()
					local xLength = size.z * math.cos(angle) + size.y * math.sin(angle)
					local yLength = size.z * math.sin(angle) + size.y * math.cos(angle)
					local height = math.max(xLength, yLength)
					local otherHeight = height == xLength and yLength or xLength
					local diff = otherHeight / height
					if diff >= 0.8 or height == yLength then
						height = height / 0.8
					end
					local dist = math.sin(math.rad(89)) / (math.sin(math.rad(1)) / height)
					thisCamera.CFrame = orient * CFrame.Angles(-angle, math.pi / 2, 0) * CFrame.new(0, 0, size.x + dist)
					preciousFrames[v[6]] = viewport
				end
				viewport.Parent = button.Gui
			end
			button.MouseClick:Connect(function()
				self:SetSelected(i)
			end)
			local text = Instance.new("TextLabel")
			text.BackgroundTransparency = 1
			text.ZIndex = WINDOW_ZINDEX
			text.Text = v[1]
			text.TextSize = SPLIT_TEXT_SIZE
			text.TextYAlignment = Enum.TextYAlignment.Bottom
			text.Position = UDim2.new(0.5, 0, 1, -8)
			text.AnchorPoint = Vector2.new(0.5, 1)
			text.Size = UDim2.new(1, -16, 0, SPLIT_TEXT_SIZE * 2)
			text.Font = Enum.Font.SourceSansSemibold
			text.TextWrapped = true
			text.TextColor3 = Color3.new(1, 1, 1)
			text.Parent = button.Gui
			sum = sum + 1
		end
	end
	self:SetSelected(firstId)
	local rows = math.ceil(sum / self.Grid.FillDirectionMaxCells)
	self.ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, rows * (self.Grid.CellSize.X.Offset + self.Grid.CellPadding.X.Offset))
end
function InventoryComp.new()
	local self = {}
	setmetatable(self, InventoryComp)
	local holderFrame = Instance.new("Frame")
	holderFrame.Size = UDim2.new(1, 0, 0, 430)
	holderFrame.BackgroundTransparency = 1
	holderFrame.Name = "InventoryComp"
	self.Gui = holderFrame
	local listBacker = Instance.new("ImageLabel")
	listBacker.Name = "ListBacker"
	listBacker.Size = UDim2.new(0.5, -4, 1, -24)
	listBacker.AnchorPoint = Vector2.new(1, 0)
	listBacker.Position = UDim2.new(1, 0, 0, 0)
	listBacker.BackgroundTransparency = 1
	listBacker.Image = Assets.Rounded
	listBacker.ImageColor3 = Color3.new(0, 0, 0)
	listBacker.ScaleType = Enum.ScaleType.Slice
	listBacker.SliceCenter = Assets.SliceCenter
	listBacker.ImageTransparency = Assets.BackgroundTransparency
	listBacker.ZIndex = WINDOW_ZINDEX + 1
	listBacker.Parent = holderFrame
	self.ListBacker = listBacker
	local listFrame = Instance.new("ScrollingFrame")
	listFrame.BackgroundTransparency = 1
	listFrame.BorderSizePixel = 0
	listFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	listFrame.Name = "ListFrame"
	listFrame.Size = UDim2.new(1, -16, 1, -16)
	listFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	listFrame.Parent = listBacker
	listFrame.ZIndex = WINDOW_ZINDEX + 1
	listFrame.ScrollBarThickness = 4
	self.ListFrame = listFrame
	local uiList = Instance.new("UIListLayout")
	uiList.Padding = UDim.new(0, 4)
	uiList.SortOrder = Enum.SortOrder.Name
	uiList.Parent = listFrame
	self.UIList = uiList
	local weightFrame = Instance.new("ImageLabel")
	weightFrame.Name = "WeightLabel"
	weightFrame.Size = UDim2.new(0.5, -4, 0, 16)
	weightFrame.AnchorPoint = Vector2.new(1, 1)
	weightFrame.Position = UDim2.new(1, 0, 1, 0)
	weightFrame.BackgroundTransparency = 1
	weightFrame.Image = Assets.Rounded
	weightFrame.ImageColor3 = Color3.new(0, 0, 0)
	weightFrame.ScaleType = Enum.ScaleType.Slice
	weightFrame.SliceCenter = Assets.SliceCenter
	weightFrame.ImageTransparency = Assets.BackgroundTransparency
	weightFrame.ZIndex = WINDOW_ZINDEX + 1
	weightFrame.Parent = holderFrame
	self.WeightLabel = weightFrame
	local actWeight = weightFrame:Clone()
	actWeight.Name = "WeightAdjust"
	actWeight.AnchorPoint = Vector2.new(0, 0)
	actWeight.Size = UDim2.new(0.4, 0, 1, 0)
	actWeight.Position = UDim2.new(0, 0, 0, 0)
	actWeight.ImageColor3 = Assets.PrimaryColor
	actWeight.ImageTransparency = 0
	actWeight.Parent = weightFrame
	self.WeightAdjust = actWeight
	local weightLabel = Instance.new("TextLabel")
	weightLabel.Text = "0/100"
	weightLabel.Font = Enum.Font.SourceSansSemibold
	weightLabel.BackgroundTransparency = 1
	weightLabel.TextColor3 = Color3.new(1, 1, 1)
	weightLabel.TextXAlignment = Enum.TextXAlignment.Center
	weightLabel.Size = UDim2.new(1, 0, 1, 0)
	weightLabel.ZIndex = WINDOW_ZINDEX + 1
	weightLabel.TextSize = 14
	weightLabel.Parent = weightFrame
	self.WeightText = weightLabel
	local function MakeInner(frame)
		local imageLab = Instance.new("ImageLabel")
		imageLab.Name = "InnerFrame"
		imageLab.BackgroundTransparency = 1
		imageLab.Image = ""
		imageLab.Position = UDim2.new(0.5, 0, 0.5, 0)
		imageLab.AnchorPoint = Vector2.new(0.5, 0.5)
		imageLab.Size = UDim2.new(1, -8, 1, -8)
		imageLab.ZIndex = WINDOW_ZINDEX + 1
		imageLab.Parent = frame
		return imageLab
	end
	local primaryFrame = Instance.new("ImageButton")
	primaryFrame.Name = "PrimaryFrame"
	primaryFrame.Size = UDim2.new(0, 232, 0, 100)
	primaryFrame.AnchorPoint = Vector2.new(0.5, 0)
	primaryFrame.Position = UDim2.new(0.25, -4, 0, 24)
	primaryFrame.BackgroundTransparency = 1
	primaryFrame.Image = Assets.Rounded
	primaryFrame.ImageColor3 = Color3.new(0, 0, 0)
	primaryFrame.ScaleType = Enum.ScaleType.Slice
	primaryFrame.SliceCenter = Assets.SliceCenter
	primaryFrame.ImageTransparency = Assets.BackgroundTransparency
	primaryFrame.ZIndex = WINDOW_ZINDEX + 1
	primaryFrame.Parent = holderFrame
	self.PrimaryFrame = primaryFrame
	self["1Frame"] = MakeInner(primaryFrame)
	local secondaryFrame = Instance.new("ImageButton")
	secondaryFrame.Name = "SecondaryFrame"
	secondaryFrame.Size = UDim2.new(1, -80, 0, 72)
	secondaryFrame.Position = UDim2.new(0, 0, 1, 8)
	secondaryFrame.BackgroundTransparency = 1
	secondaryFrame.Image = Assets.Rounded
	secondaryFrame.ImageColor3 = Color3.new(0, 0, 0)
	secondaryFrame.ScaleType = Enum.ScaleType.Slice
	secondaryFrame.SliceCenter = Assets.SliceCenter
	secondaryFrame.ImageTransparency = Assets.BackgroundTransparency
	secondaryFrame.ZIndex = WINDOW_ZINDEX + 1
	secondaryFrame.Parent = primaryFrame
	self.SecondaryFrame = secondaryFrame
	self["2Frame"] = MakeInner(secondaryFrame)
	local tertiaryFrame = Instance.new("ImageButton")
	tertiaryFrame.Name = "TertiaryFrame"
	tertiaryFrame.Size = UDim2.new(0, 72, 0, 72)
	tertiaryFrame.AnchorPoint = Vector2.new(1, 0)
	tertiaryFrame.Position = UDim2.new(1, 0, 1, 8)
	tertiaryFrame.BackgroundTransparency = 1
	tertiaryFrame.Image = Assets.Rounded
	tertiaryFrame.ImageColor3 = Color3.new(0, 0, 0)
	tertiaryFrame.ScaleType = Enum.ScaleType.Slice
	tertiaryFrame.SliceCenter = Assets.SliceCenter
	tertiaryFrame.ImageTransparency = Assets.BackgroundTransparency
	tertiaryFrame.ZIndex = WINDOW_ZINDEX + 1
	tertiaryFrame.Parent = primaryFrame
	self.TertiaryFrame = tertiaryFrame
	self["3Frame"] = MakeInner(tertiaryFrame)
	local bottomFrame = Instance.new("Frame")
	bottomFrame.Name = "BottomFrame"
	bottomFrame.BackgroundTransparency = 1
	bottomFrame.ZIndex = WINDOW_ZINDEX + 1
	bottomFrame.Size = UDim2.new(0.5, -4, 1, -230)
	bottomFrame.AnchorPoint = Vector2.new(0, 1)
	bottomFrame.Position = UDim2.new(0, 0, 1, 0)
	bottomFrame.Parent = holderFrame
	self.BottomFrame = bottomFrame
	local uiGrid = Instance.new("UIGridLayout")
	uiGrid.CellPadding = UDim2.new(0, 8, 0, 8)
	uiGrid.CellSize = UDim2.new(0, 72, 0, 72)
	uiGrid.FillDirectionMaxCells = 3
	uiGrid.FillDirection = Enum.FillDirection.Horizontal
	uiGrid.HorizontalAlignment = Enum.HorizontalAlignment.Center
	uiGrid.VerticalAlignment = Enum.VerticalAlignment.Center
	uiGrid.Parent = bottomFrame
	self.UIGrid = uiGrid
	local slots = {}
	for i = 1, 6 do
		local thisFrame = Instance.new("ImageButton")
		thisFrame.Name = "Slot" .. i
		thisFrame.BackgroundTransparency = 1
		thisFrame.Image = Assets.Rounded
		thisFrame.ImageColor3 = Color3.new(0, 0, 0)
		thisFrame.ScaleType = Enum.ScaleType.Slice
		thisFrame.SliceCenter = Assets.SliceCenter
		thisFrame.ImageTransparency = Assets.BackgroundTransparency
		thisFrame.ZIndex = WINDOW_ZINDEX + 1
		thisFrame.Parent = bottomFrame
		table.insert(slots, thisFrame)
	end
	self.Slots = slots
	return self
end
function InventoryComp:SetWeight(weight)
	self.WeightText.Text = "Weight: " .. weight .. "/" .. Constants.InventoryCarryWeight
	self.WeightAdjust.Size = UDim2.new(weight / Constants.InventoryCarryWeight, 0, 1, 0)
end
local function FillListFrame(listFrame, padding, inv)
	for i, v in pairs(listFrame:GetChildren()) do
		if v:IsA("ImageButton") then
			v:Destroy()
		end
	end
	local buttons = {}
	for i, v in pairs(inv) do
		local cTable = Items[v[2]]
		if not (not v[3] or v[3].H) or not v[3] then
			local button = ButtonComp.new(cTable.Name)
			if not cTable.Slot or not v[4] then
				local h, s, v = Color3.toHSV(Assets.ButtonColor)
				button:SetColor(Color3.fromHSV(h, s - 0.6, v))
			end
			button.Gui.Name = cTable.Name
			button.TextLabel.Font = Enum.Font.SourceSansSemibold
			button.TextLabel.TextXAlignment = Enum.TextXAlignment.Left
			button.TextLabel.Text = "   " .. cTable.Name
			button.Gui.Size = UDim2.new(1, -12, 0, 36)
			button.Gui.ZIndex = WINDOW_ZINDEX + 1
			button.Gui.ClipsDescendants = true
			button.TextLabel.ZIndex = WINDOW_ZINDEX + 1
			if cTable.Thumb then
				local image = Instance.new("ImageLabel")
				image.ZIndex = WINDOW_ZINDEX + 1
				image.AnchorPoint = Vector2.new(1, 0)
				image.Size = UDim2.new(0, 100, 1, 0)
				image.Position = UDim2.new(1, -30, 0, 0)
				image.BackgroundTransparency = 1
				image.Name = "Thumb"
				image.Image = cTable.Thumb
				image.Active = false
				image.Parent = button.Gui
			end
			if v[3] and (v[3].Q or v[3].R) then
				local thisLabel = Instance.new("TextLabel")
				thisLabel.Name = "ItemLabel"
				thisLabel.Text = v[3].Q and "x" .. v[3].Q or v[3].R
				thisLabel.TextXAlignment = Enum.TextXAlignment.Right
				thisLabel.TextYAlignment = Enum.TextYAlignment.Center
				thisLabel.Font = Enum.Font.SourceSansLight
				thisLabel.TextSize = 18
				thisLabel.AnchorPoint = Vector2.new(1, 0.5)
				thisLabel.Position = UDim2.new(1, -8, 0.5, 0)
				thisLabel.BackgroundTransparency = 1
				thisLabel.TextColor3 = Color3.new(1, 1, 1)
				thisLabel.ZIndex = WINDOW_ZINDEX + 1
				thisLabel.Parent = button.Gui
				button.Qty = thisLabel
			end
			button.Gui.Parent = listFrame
			buttons[v[1]] = button
		end
	end
	local absY = listFrame.AbsoluteSize.Y
	local buttonsY = (#listFrame:GetChildren() - 1) * (TEXT_SIZE + 16 + padding) - padding
	listFrame.CanvasSize = UDim2.new(0, 0, 0, buttonsY)
	if absY >= buttonsY then
		for i, v in pairs(listFrame:GetChildren()) do
			if v:IsA("ImageButton") then
				v.Size = UDim2.new(1, 0, 0, v.Size.Y.Offset)
			end
		end
	end
	return buttons
end
function InventoryComp:SetInventory(inv)
	self["1Frame"].Image = ""
	self["2Frame"].Image = ""
	self["3Frame"].Image = ""
	for i, v in pairs(inv) do
		if v[4] and Items[v[2]].Slot and Items[v[2]].Slot <= 3 then
			if Items[v[2]].Slot == 3 then
				self["3Frame"].Image = Items[v[2]].HotbarThumb
			else
				self[Items[v[2]].Slot .. "Frame"].Image = Items[v[2]].MainThumb
			end
		end
	end
	return FillListFrame(self.ListFrame, self.UIList.Padding.Offset, inv)
end
function InventoryCompareComp.new(otherName)
	local self = {}
	setmetatable(self, InventoryCompareComp)
	local holderFrame = Instance.new("Frame")
	holderFrame.Size = UDim2.new(1, 0, 0, 454)
	holderFrame.BackgroundTransparency = 1
	holderFrame.Name = "InventoryCompareComp"
	self.Gui = holderFrame
	for i = 1, 2 do
		local title = Instance.new("TextLabel")
		title.Text = (i == 2 and otherName or player.Name):upper()
		title.AnchorPoint = Vector2.new(i - 1, 0)
		title.Position = UDim2.new(i - 1, 0, 0, 0)
		title.Size = UDim2.new(0.5, -4, 0, 24)
		title.BackgroundTransparency = 1
		title.TextColor3 = Color3.new(1, 1, 1)
		title.Font = TITLE_FONT
		title.TextSize = TEXT_SIZE + 4
		title.TextXAlignment = Enum.TextXAlignment.Center
		title.TextYAlignment = Enum.TextYAlignment.Center
		title.ZIndex = WINDOW_ZINDEX + 1
		title.Parent = holderFrame
		local listBacker = Instance.new("ImageLabel")
		listBacker.Name = "ListBacker" .. i
		listBacker.Size = UDim2.new(0.5, -4, 1, -54)
		listBacker.AnchorPoint = Vector2.new(i - 1, 0)
		listBacker.Position = UDim2.new(i - 1, 0, 0, 30)
		listBacker.BackgroundTransparency = 1
		listBacker.Image = Assets.Rounded
		listBacker.ImageColor3 = Color3.new(0, 0, 0)
		listBacker.ScaleType = Enum.ScaleType.Slice
		listBacker.SliceCenter = Assets.SliceCenter
		listBacker.ImageTransparency = Assets.BackgroundTransparency
		listBacker.ZIndex = WINDOW_ZINDEX + 1
		listBacker.Parent = holderFrame
		self["ListBacker" .. i] = listBacker
		local listFrame = Instance.new("ScrollingFrame")
		listFrame.BackgroundTransparency = 1
		listFrame.BorderSizePixel = 0
		listFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		listFrame.Name = "ListFrame" .. i
		listFrame.Size = UDim2.new(1, -16, 1, -16)
		listFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
		listFrame.Parent = listBacker
		listFrame.ZIndex = WINDOW_ZINDEX + 1
		listFrame.ScrollBarThickness = 4
		self["ListFrame" .. i] = listFrame
		local uiList = Instance.new("UIListLayout")
		uiList.Padding = UDim.new(0, 4)
		uiList.SortOrder = Enum.SortOrder.Name
		uiList.Parent = listFrame
		self["UIList" .. i] = uiList
		local weightFrame = Instance.new("ImageLabel")
		weightFrame.Name = "WeightLabel"
		weightFrame.Size = UDim2.new(0.5, -4, 0, 16)
		weightFrame.AnchorPoint = Vector2.new(i - 1, 1)
		weightFrame.Position = UDim2.new(i - 1, 0, 1, 0)
		weightFrame.BackgroundTransparency = 1
		weightFrame.Image = Assets.Rounded
		weightFrame.ImageColor3 = Color3.new(0, 0, 0)
		weightFrame.ScaleType = Enum.ScaleType.Slice
		weightFrame.SliceCenter = Assets.SliceCenter
		weightFrame.ImageTransparency = Assets.BackgroundTransparency
		weightFrame.ZIndex = WINDOW_ZINDEX + 1
		weightFrame.Parent = holderFrame
		self["WeightLabel" .. i] = weightFrame
		local actWeight = weightFrame:Clone()
		actWeight.Name = "WeightAdjust"
		actWeight.AnchorPoint = Vector2.new(0, 0)
		actWeight.Size = UDim2.new(0.4, 0, 1, 0)
		actWeight.Position = UDim2.new(0, 0, 0, 0)
		actWeight.ImageColor3 = Assets.PrimaryColor
		actWeight.ImageTransparency = 0
		actWeight.Parent = weightFrame
		self["WeightAdjust" .. i] = actWeight
		local weightLabel = Instance.new("TextLabel")
		weightLabel.Text = "0/100"
		weightLabel.Font = Enum.Font.SourceSansSemibold
		weightLabel.BackgroundTransparency = 1
		weightLabel.TextColor3 = Color3.new(1, 1, 1)
		weightLabel.TextXAlignment = Enum.TextXAlignment.Center
		weightLabel.Size = UDim2.new(1, 0, 1, 0)
		weightLabel.ZIndex = WINDOW_ZINDEX + 1
		weightLabel.TextSize = 14
		weightLabel.Parent = weightFrame
		self["WeightText" .. i] = weightLabel
	end
	return self
end
function InventoryCompareComp:SetInventory(int, inv)
	return FillListFrame(self["ListFrame" .. int], self["UIList" .. int].Padding.Offset, inv)
end
function InventoryCompareComp:SetWeight(int, weight, max)
	local max = max or Constants.InventoryCarryWeight
	self["WeightText" .. int].Text = "Weight: " .. weight .. "/" .. max
	self["WeightAdjust" .. int].Size = UDim2.new(weight / max, 0, 1, 0)
end
function BallotPane.new(av)
	local self = {}
	setmetatable(self, BallotPane)
	local gui = ReplicatedStorage.UI.BallotPane:Clone()
	self.Gui = gui
	local candidateFrame = gui:WaitForChild("CandidateFrame")
	candidateFrame.Parent = nil
	self.CandidateTemplate = candidateFrame
	local infoLabel = candidateFrame:FindFirstChild("InfoLabel")
	infoLabel.Parent = nil
	self.InfoTemplate = infoLabel
	if av then
		candidateFrame:FindFirstChild("PollButton"):Destroy()
	else
		candidateFrame:FindFirstChild("PollBox"):Destroy()
	end
	self.Boxes = {}
	return self
end
function BallotPane:SetSelection(id)
	self.Selected = id
end
local PositiveIntegerMask = function(text)
	return text:gsub("%D+", "")
end
function BallotPane:SetItemList(newList)
	self.ItemList = newList
	for _, v in pairs(self.Gui:GetChildren()) do
		if v:IsA("GuiObject") then
			v:Destroy()
		end
	end
	local rows
	for _, v in ipairs(newList) do
		do
			local newFrame = self.CandidateTemplate:Clone()
			newFrame.Name = v[1]
			for i, title in pairs(v[2]) do
				local newLabel = self.InfoTemplate:Clone()
				newLabel.Text = title:upper()
				newLabel.Font = Enum.Font.SourceSansBold
				newLabel.Position = UDim2.new(0, 8, 0, 8 + (i - 1) * 40)
				newLabel.Parent = newFrame
				local nameLabel = self.InfoTemplate:Clone()
				nameLabel.Text = v[3][i]
				nameLabel.Font = Enum.Font.SourceSans
				nameLabel.Position = UDim2.new(0, 8, 0, 8 + (i - 1) * 40 + 20)
				nameLabel.Parent = newFrame
			end
			rows = #v[2]
			newFrame.Size = UDim2.new(1, -20, 0, rows * 40 + 16)
			local pollBox = newFrame:FindFirstChild("PollBox")
			local pollButton = newFrame:FindFirstChild("PollButton")
			if pollBox then
				pollBox:GetPropertyChangedSignal("Text"):Connect(function()
					pollBox.Text = PositiveIntegerMask(pollBox.Text)
				end)
				table.insert(self.Boxes, pollBox)
			elseif pollButton then
				pollButton.TextSize = math.floor(#v[2] / 4 * 70)
				pollButton.MouseButton1Click:Connect(function()
					pollButton.Text = "X"
					self:SetSelection(v[1])
					for _, box in pairs(self.Boxes) do
						if box.Text == "X" and box ~= pollButton then
							box.Text = ""
						end
					end
				end)
				table.insert(self.Boxes, pollButton)
			end
			newFrame.Parent = self.Gui
		end
	end
	local scrollY = math.min(384, #newList * (rows * 40 + 16) + (#newList - 1) * 5)
	self.Gui.Size = UDim2.new(1, 0, 0, scrollY)
	self.Gui.CanvasSize = UDim2.new(0, 0, 0, #newList * (rows * 40 + 16) + (#newList - 1) * 5)
end
API.Window = WindowComp
API.TextLabel = TextLabelComp
API.TextBox = TextBoxComp
API.Button = ButtonComp
API.ComboBox = ComboBox
API.SplitPane = SplitPane
API.Inventory = InventoryComp
API.InventoryCompare = InventoryCompareComp
API.BallotPane = BallotPane
return API

starterplayerscripts.coreclient.dynamicarms
--SynapseX Decompiler
local API = {}
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local RemoteHandler = require(script.Parent.RemoteHandler)
local BIND_NAME = "DynamicArms"
local LEFT_C0, RIGHT_C0, NECK_C0
local updateYRemote = RemoteHandler.Event.new("YUpdate")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local aimPart, camera
local aimEndEvent = Instance.new("BindableEvent")
local aiming = false
local RANDOM, RAD, RAY, V3, CF, CFANG = math.random, math.rad, Ray.new, Vector3.new, CFrame.new, CFrame.Angles
local BC, INST, COLSEQ, FORMAT, INSERT = BrickColor.new, Instance.new, ColorSequence.new, string.format, table.insert
local FLOOR = math.floor
local function UpdateThirdPerson(char, vectorY, vectorX)
	if not (char and vectorY) or not vectorX then
		return
	end
	local leftShoulder, rightShoulder, neck
	local suc, err = pcall(function()
		leftShoulder = char.Humanoid.RigType == Enum.HumanoidRigType.R6 and char.Torso["Left Shoulder"] or char.LeftUpperArm.LeftShoulder
		rightShoulder = char.Humanoid.RigType == Enum.HumanoidRigType.R6 and char.Torso["Right Shoulder"] or char.RightUpperArm.RightShoulder
		neck = char.Humanoid.RigType == Enum.HumanoidRigType.R6 and char.Torso.Neck or char.Head.Neck
	end)
	if suc and LEFT_C0 and RIGHT_C0 and NECK_C0 then
		if char.Humanoid.RigType == Enum.HumanoidRigType.R6 then
			leftShoulder.C0 = LEFT_C0 * CFANG(0, 0, -vectorY)
			rightShoulder.C0 = RIGHT_C0 * CFANG(0, 0, vectorY)
			if neck then
				neck.C0 = NECK_C0 * CFANG(-vectorY, 0, -vectorX)
			end
		else
			leftShoulder.C0 = LEFT_C0 * CFANG(vectorY, 0, 0)
			rightShoulder.C0 = RIGHT_C0 * CFANG(vectorY, 0, 0)
			if neck then
				neck.C0 = NECK_C0 * CFANG(vectorY, 0, 0)
			end
		end
	end
end
updateYRemote.OnEvent:Connect(UpdateThirdPerson)
function API.Init(humanoid)
	repeat game:GetService("RunService").Heartbeat:wait() until player.Character
	local character = humanoid.Parent
	local findFirstClass = character.FindFirstChildOfClass
	camera = workspace.CurrentCamera
	local leftShoulder = character.Humanoid.RigType == Enum.HumanoidRigType.R6 and character.Torso["Left Shoulder"] or character.LeftUpperArm.LeftShoulder
	local rightShoulder = character.Humanoid.RigType == Enum.HumanoidRigType.R6 and character.Torso["Right Shoulder"] or character.RightUpperArm.RightShoulder
	local neck = character.Humanoid.RigType == Enum.HumanoidRigType.R6 and character.Torso.Neck or character.Head.Neck
	LEFT_C0 = leftShoulder.C0
	RIGHT_C0 = rightShoulder.C0
	NECK_C0 = neck.C0
	local torso = character.Humanoid.RigType == Enum.HumanoidRigType.R6 and character.Torso or character.UpperTorso
	local rootPart = character.HumanoidRootPart
	local lastUpdate = tick()
	local lastX = FLOOR(-camera.CFrame:toObjectSpace(rootPart.CFrame).lookVector.x / 0.1) * 0.1
	local lastY = FLOOR(camera.CFrame.lookVector.y / 0.1) * 0.1
	local tweenStart = tick()
	RunService:BindToRenderStep(BIND_NAME, Enum.RenderPriority.Camera.Value + 1, function()
		local vectorX = -camera.CFrame:toObjectSpace(rootPart.CFrame).lookVector.x
		local vectorY
		if findFirstClass(character, "Configuration") then
			vectorY = mouse.Origin.lookVector.y
		else
			vectorY = camera.CFrame.lookVector.y / 2
		end
		local flooredY = FLOOR(vectorY / 0.1) * 0.1
		local flooredX = FLOOR(vectorX / 0.1) * 0.1
		local now = tick()
		if (lastY ~= flooredY or lastX ~= flooredX) and now - lastUpdate > 0.2 then
			lastUpdate = now
			lastY = flooredY
			lastX = flooredX
			updateYRemote:Fire(vectorY, vectorX)
		end
		if (camera.Focus.p - camera.CFrame.p).Magnitude <= 0.9 then
			local cameraOffset = CF(0, 1.5, 0) * CF(humanoid.CameraOffset)
			if aimPart and aimPart.Parent then
				if not aiming then
					tweenStart = tick()
				end
				aiming = true
				local oldLC0 = leftShoulder.C0
				local oldRC0 = rightShoulder.C0
				leftShoulder.C0 = LEFT_C0
				rightShoulder.C0 = RIGHT_C0
				local torsoOffset = torso.CFrame:toObjectSpace(rootPart.CFrame)
				local aimOffset = aimPart.CFrame:toObjectSpace(cameraOffset * torso.CFrame)
				local rotAim = cameraOffset * torsoOffset * CFANG(vectorY, 0, 0) * cameraOffset:inverse() * aimOffset
				leftShoulder.C0 = oldLC0
				rightShoulder.C0 = oldRC0
				local delta = (tick() - tweenStart) / 0.15
				if delta > 1 then
					delta = 1
				end
				leftShoulder.C0 = leftShoulder.C0:lerp(rotAim * LEFT_C0, delta)
				rightShoulder.C0 = rightShoulder.C0:lerp(rotAim * RIGHT_C0, delta)
			else
				if aiming then
					tweenStart = tick()
				end
				aiming = false
				local rotWithCam = cameraOffset * CFANG(vectorY, 0, 0) * cameraOffset:inverse()
				if character.Humanoid.RigType == Enum.HumanoidRigType.R6 then
					local delta = (tick() - tweenStart) / 0.25
					if delta > 1 then
						delta = 1
					end
					leftShoulder.C0 = leftShoulder.C0:lerp(rotWithCam * LEFT_C0, delta)
					rightShoulder.C0 = rightShoulder.C0:lerp(rotWithCam * RIGHT_C0, delta)
				else
					leftShoulder.C0 = rotWithCam * LEFT_C0
					rightShoulder.C0 = rotWithCam * RIGHT_C0
				end
			end
		else
			if aiming then
				aiming = false
				aimEndEvent:Fire()
			end
			UpdateThirdPerson(character, vectorY, vectorX)
		end
	end)
	humanoid.Died:Connect(function()
		wait(0.1)
		API.Deactivate()
	end)
end
function API.SetAimPart(argAim)
	aimPart = argAim
end
function API.CanAim()
	return (camera.Focus.p - camera.CFrame.p).Magnitude < 1
end
function API.GetAimPart()
	return aimPart
end
function API.GetEndAimEvent()
	return aimEndEvent.Event
end
function API.Deactivate()
	RunService:UnbindFromRenderStep(BIND_NAME)
end
return API

starterplayerscripts.coreclient.electioncontroller
--SynapseX Decompiler

local API = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TextService = game:GetService("TextService")
local RemoteHandler = require(script.Parent.RemoteHandler)
local ClientFunctions = require(script.Parent.ClientFunctions)
local Verificator = require(script.Parent.Verificator)
local NotificationHandler = require(script.Parent.NotificationHandler)
local ZoneController = require(script.Parent.ZoneController)
local Assets = require(ReplicatedStorage.Databases.Assets)
local Constants = require(ReplicatedStorage.Databases.Constants)
local Elections = require(ReplicatedStorage.Databases.Elections)
local DISPLAY_TAG = "VotingDisplay"
local TITLE_SIZE = 32
local CAPTION_SIZE = 24
local CAND_SIZE_Y = 76
local enabled = false
local displays = CollectionService:GetTagged(DISPLAY_TAG)
local electionRemote = RemoteHandler.Event.new("ElectionResults")
local displayObjs = {}
local ResultsDisplay = {}
ResultsDisplay.__index = ResultsDisplay
electionRemote.OnEvent:Connect(function(elections)
	for i = 1, #elections do
		local electionTab = Elections[elections[i][1]]
		if not electionTab then
			return
		end
		electionTab.Result = elections[i][2]
		electionTab.Votes = elections[i][3]
		for j = 1, #displayObjs do
			if displayObjs[j].Election == elections[i][1] and displayObjs[j].Status < 4 then
				displayObjs[j]:ShowResults(elections[i][2], elections[i][3])
			end
		end
	end
end)
local spairs = function(t, order)
	local keys = {}
	for k in pairs(t) do
		keys[#keys + 1] = k
	end
	if order then
		table.sort(keys, function(a, b)
			return order(t, a, b)
		end)
	else
		table.sort(keys)
	end
	local i = 0
	return function()
		i = i + 1
		if keys[i] then
			return keys[i], t[keys[i]]
		end
	end
end
local RoundNumber = function(num, numDecimalPlaces)
	return string.format("%." .. (numDecimalPlaces or 0) .. "f", num)
end
local function MakeCandidateFrame(election, option, votes, total, win)
	local frame = Instance.new("ImageLabel")
	frame.BackgroundTransparency = 1
	frame.Image = Assets.Rounded
	frame.ScaleType = Enum.ScaleType.Slice
	frame.SliceCenter = Assets.SliceCenter
	frame.ImageColor3 = win and Color3.new(0.9, 1, 0.9) or Color3.new(1, 1, 1)
	frame.Size = UDim2.new(1, -32, 0, CAND_SIZE_Y)
	local bar = frame:Clone()
	bar.ImageColor3 = Color3.new(0.8, 0.8, 0.8)
	bar.AnchorPoint = Vector2.new(0.5, 1)
	bar.Position = UDim2.new(0.5, 0, 1, -8)
	bar.Size = UDim2.new(1, -16, 0, 30)
	bar.Name = "BarFrame"
	bar.Parent = frame
	local progBar = bar:Clone()
	progBar.ImageColor3 = Assets.Color.Green
	progBar.Size = UDim2.new(2, 0, 1, 0)
	progBar.AnchorPoint = Vector2.new(0, 0)
	progBar.Position = UDim2.new(0, 0, 0, 0)
	progBar.Size = UDim2.new(votes / total, 0, 1, 0)
	progBar.Parent = bar
	local xSize = votes / total * 552
	local percentString = string.format("%.1f", math.floor(votes / total * 1000) / 10) .. "%"
	local perLabel = Instance.new("TextLabel")
	perLabel.Name = "PercentLabel"
	perLabel.AnchorPoint = Vector2.new(0, 0.5)
	perLabel.Font = Enum.Font.SourceSansItalic
	perLabel.TextSize = CAPTION_SIZE - 2
	perLabel.TextYAlignment = Enum.TextYAlignment.Center
	perLabel.TextXAlignment = Enum.TextXAlignment.Left
	perLabel.BackgroundTransparency = 1
	perLabel.TextColor3 = Color3.new(0.05, 0.05, 0.05)
	perLabel.Position = UDim2.new(1, 10, 0.5, 0)
	perLabel.Text = percentString
	local bounds = TextService:GetTextSize(percentString, CAPTION_SIZE - 2, Enum.Font.SourceSansItalic, Vector2.new(500, 500))
	if xSize > bounds.X + 10 then
		perLabel.TextXAlignment = Enum.TextXAlignment.Right
		perLabel.AnchorPoint = Vector2.new(1, 0.5)
		perLabel.Position = UDim2.new(1, -10, 0.5, 0)
		perLabel.TextColor3 = Color3.new(1, 1, 1)
	end
	perLabel.Parent = progBar
	local candidateName = ""
	for i, name in ipairs(option[1]) do
		candidateName = candidateName .. name .. (#option[1] ~= i and " & " or "")
	end
	local textLabel = Instance.new("TextLabel")
	textLabel.BackgroundTransparency = 1
	textLabel.Font = Enum.Font.SourceSansBold
	textLabel.TextColor3 = Color3.new(0.05, 0.05, 0.05)
	textLabel.Text = candidateName
	textLabel.TextSize = CAPTION_SIZE - 2
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.TextYAlignment = Enum.TextYAlignment.Top
	textLabel.Position = UDim2.new(0, 8, 0, 8)
	textLabel.Parent = frame
	local votesLabel = textLabel:Clone()
	votesLabel.TextXAlignment = Enum.TextXAlignment.Right
	votesLabel.Font = Enum.Font.SourceSansSemibold
	votesLabel.Text = votes
	votesLabel.AnchorPoint = Vector2.new(1, 0)
	votesLabel.Position = UDim2.new(1, -8, 0, 8)
	votesLabel.Parent = frame
	return frame
end
function ResultsDisplay.new(electionId, part)
	local self = {}
	setmetatable(self, ResultsDisplay)
	self.Election = electionId
	self.ElectionTable = Elections[electionId]
	self.Color = self.ElectionTable.Color
	self.Part = part
	self.Page = 1
	self.Scroll = 1
	self.Status = 1
	local gui = Instance.new("SurfaceGui")
	gui.Name = electionId
	gui.CanvasSize = Vector2.new(600, 400)
	gui.LightInfluence = 0.8
	gui.Face = Enum.NormalId.Front
	gui.ClipsDescendants = true
	gui.Adornee = part
	self.Gui = gui
	local frame = Instance.new("Frame")
	frame.BackgroundColor3 = self.Color
	frame.BorderSizePixel = 0
	frame.Name = "BackgroundFrame"
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.ClipsDescendants = true
	frame.Parent = gui
	self.BackgroundFrame = frame
	local textFrame = Instance.new("Frame")
	textFrame.BorderSizePixel = 0
	local h, s, v = Color3.toHSV(self.Color)
	textFrame.BackgroundColor3 = Color3.fromHSV(h, math.max(s - 0.15, 0), v)
	textFrame.AnchorPoint = Vector2.new(0.5, 0)
	textFrame.Position = UDim2.new(0.5, 0, 0.5, -40)
	textFrame.Size = UDim2.new(1, 0, 0, 80)
	textFrame.Name = "TitleFrame"
	textFrame.Parent = frame
	self.TextFrame = textFrame
	local votesFrame = textFrame:Clone()
	votesFrame.Position = UDim2.new(0.5, 0, 1, 0)
	votesFrame.Name = "VotesFrame"
	votesFrame.Size = UDim2.new(1, 0, 0, 30)
	votesFrame.Parent = frame
	self.VotesFrame = votesFrame
	local titleLabel = Instance.new("TextLabel")
	titleLabel.TextYAlignment = Enum.TextYAlignment.Bottom
	titleLabel.BackgroundTransparency = 1
	titleLabel.Name = "TitleLabel"
	titleLabel.Text = self.ElectionTable.Name:upper()
	titleLabel.Font = Enum.Font.SourceSansSemibold
	titleLabel.TextColor3 = Color3.new(1, 1, 1)
	titleLabel.Position = UDim2.new(0.5, 0, 0, 0)
	titleLabel.Size = UDim2.new(1, 0, 0.5, 0)
	titleLabel.AnchorPoint = Vector2.new(0.5, 0)
	titleLabel.TextSize = TITLE_SIZE
	titleLabel.Parent = textFrame
	local descLabel = titleLabel:Clone()
	descLabel.TextYAlignment = Enum.TextYAlignment.Top
	descLabel.Name = "DescLabel"
	descLabel.Font = Enum.Font.SourceSansLight
	descLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
	descLabel.TextSize = CAPTION_SIZE
	descLabel.Parent = textFrame
	self.DescLabel = descLabel
	local votesLabel = descLabel:Clone()
	votesLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	votesLabel.Name = "VotesLabel"
	votesLabel.TextYAlignment = Enum.TextYAlignment.Center
	votesLabel.Font = Enum.Font.SourceSansItalic
	votesLabel.TextSize = 24
	votesLabel.Parent = votesFrame
	self.VotesLabel = votesLabel
	local roundFrame = Instance.new("Frame")
	roundFrame.Name = "PageFrame"
	roundFrame.Visible = false
	roundFrame.BackgroundTransparency = 1
	roundFrame.ClipsDescendants = true
	roundFrame.Size = UDim2.new(1, 0, 1, -(textFrame.Size.Y.Offset + votesFrame.Size.Y.Offset + 20))
	roundFrame.Position = UDim2.new(0, 0, 0, textFrame.Size.Y.Offset + 10)
	roundFrame.Parent = frame
	self.RoundFrame = roundFrame
	local roundLayout = Instance.new("UIPageLayout")
	roundLayout.ScrollWheelInputEnabled = false
	roundLayout.GamepadInputEnabled = false
	roundLayout.TouchInputEnabled = false
	roundLayout.Name = "RoundLayout"
	roundLayout.Circular = true
	roundLayout.EasingStyle = Enum.EasingStyle.Quad
	roundLayout.TweenTime = 0.5
	roundLayout.Parent = roundFrame
	self.RoundLayout = roundLayout
	local scrollFrame = Instance.new("Frame")
	scrollFrame.Size = UDim2.new(1, 0, 1, 0)
	scrollFrame.Name = "ScrollFrame"
	scrollFrame.BackgroundTransparency = 1
	scrollFrame.ClipsDescendants = true
	self.ScrollFrame = scrollFrame
	local candHolder = scrollFrame:Clone()
	candHolder.Name = "CandHolder"
	self.CandHolder = candHolder
	local candList = Instance.new("UIListLayout")
	candList.Name = "CandList"
	candList.FillDirection = Enum.FillDirection.Vertical
	candList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	candList.Padding = UDim.new(0, 5)
	candList.Parent = candHolder
	self.CandList = candList
	gui.Parent = playerGui
	table.insert(displayObjs, self)
	self:ShowStatus()
	return self
end
function ResultsDisplay:ShowStatus()
	local currentTime = os.time()
	local thisTick = tick()
	local statusNow = self.Status
	self.Status = currentTime < self.ElectionTable.Times.Start and 2 or 3
	if statusNow == self.Status then
		return
	end
	self.StatusTick = thisTick
	coroutine.wrap(function()
		while self.StatusTick == thisTick do
			local now = os.time()
			if self.Status == 3 and now >= self.ElectionTable.Times.End then
				self.DescLabel.Text = "Votes are being counted, please wait"
				return
			elseif self.Status == 2 and now >= self.ElectionTable.Times.Start then
				self:ShowStatus()
				return
			end
			local tTable = os.date("!*t", (self.Status == 2 and self.ElectionTable.Times.Start or self.ElectionTable.Times.End) - now)
			self.DescLabel.Text = (self.Status == 2 and "Voting opens in " or "Voting closes in ") .. string.format("%02d:%02d:%02d", tTable.hour + (tTable.day - 1) * 24, tTable.min, tTable.sec)
			wait(0.9)
		end
	end)()
end
function ResultsDisplay:ShowResults(roundsTable, noOfVotes)
	self.StatusTick = tick()
	self.Status = 4
	self.RoundsTable = roundsTable
	self.NoOfVotes = noOfVotes
	self.Pages = {
		self.RoundLayout,
		{}
	}
	for i = 1, #roundsTable do
		local v = roundsTable[i]
		local newRound = self.ScrollFrame:Clone()
		local currentFill = self.CandHolder:Clone()
		self.Pages[2][i] = currentFill
		newRound.Name = i
		local sumVotes = 0
		for _, num in pairs(v) do
			sumVotes = sumVotes + num
		end
		local candNumb = 1
		for cand, num in spairs(v, function(t, a, b)
				return t[b] < t[a]
			end) do
			local frame = MakeCandidateFrame(self.Election, self.ElectionTable.Options[cand], num, sumVotes, i == #roundsTable and candNumb <= self.ElectionTable.Places)
			frame.Name = candNumb
			frame.Parent = currentFill
			candNumb = candNumb + 1
		end
		currentFill.Parent = newRound
		local childs = #currentFill:GetChildren()
		currentFill.Size = UDim2.new(1, 0, 0, (childs - 1) * CAND_SIZE_Y + (childs - 2) * self.CandList.Padding.Offset)
		newRound.Parent = self.RoundFrame
	end
	self.VotesLabel.Text = noOfVotes .. (noOfVotes ~= 1 and " VOTES" or "VOTE")
	self.Pages[1]:JumpToIndex(1)
	self.Pages[1].Animated = true
	self.VotesFrame:TweenPosition(UDim2.new(0.5, 0, 1, -30), "Out", "Quad", 0.25)
	self.TextFrame:TweenPosition(UDim2.new(0.5, 0, 0, 0), "Out", "Quad", 0.5, nil, function()
		self.RoundFrame.Visible = true
		self:DoLoop()
	end)
end
function ResultsDisplay:DoLoop()
	if not self.Pages or not enabled then
		return
	end
	local thisTick = enabled
	local binding = Instance.new("BindableEvent")
	coroutine.wrap(function()
		while enabled == thisTick do
			for i = 1, #self.Pages[2] do
				self.DescLabel.Text = i == #self.RoundsTable and "FINAL ROUND" or "ROUND " .. i
				if tonumber(self.Pages[1].CurrentPage.Name) ~= i then
					self.Pages[1]:JumpToIndex(i - 1)
				end
				wait(2)
				if enabled ~= thisTick then
					return
				end
				do
					local delayTime = (#self.Pages[2][i]:GetChildren() - 2) * 2
					if #self.Pages[2][i]:GetChildren() - 1 > 3 then
						self.Pages[2][i]:TweenPosition(UDim2.new(0, 0, 1, -self.Pages[2][i].Size.Y.Offset), "Out", Enum.EasingStyle.Linear, delayTime, true, function()
							wait(2)
							delay(self.Pages[1].TweenTime, function()
								self.Pages[2][i]:TweenPosition(UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.5, true)
							end)
							binding:Fire()
						end)
						binding.Event:Wait()
					else
						wait(delayTime + 2)
					end
				end
			end
		end
	end)()
end
function API.SetEnabled(bool)
	if bool and not enabled then
		enabled = tick()
		if enabled then
			for i = 1, #displayObjs do
				displayObjs[i]:DoLoop()
			end
		end
	else
		enabled = false
	end
end
ZoneController.OnZoneChanged:Connect(function(newZone)
	API.SetEnabled(newZone == "PollingStation")
end)
function API.Init(argGui)
	playerGui = argGui
	
	CollectionService:GetInstanceAddedSignal(DISPLAY_TAG):Connect(function(display)
		for electionId, electionTab in pairs(Elections) do
			if display.Name == electionTab.Display then
				local displaying = ResultsDisplay.new(electionId, display)
				if electionTab.Result then
					displaying:ShowResults(electionTab.Result, electionTab.Votes)
				end
				break
			end
		end
	end);

	for i = 1, #displays do
		for electionId, electionTab in pairs(Elections) do
			if displays[i].Name == electionTab.Display then
				local display = ResultsDisplay.new(electionId, displays[i])
				if electionTab.Result then
					display:ShowResults(electionTab.Result, electionTab.Votes)
				end
				break
			end
		end
	end
	local askTab = {}
	for electionId, electionTab in pairs(Elections) do
		if not electionTab.Result and os.time() >= electionTab.Times.End then
			table.insert(askTab, electionId)
		end
	end
	electionRemote:Fire(askTab)
end
return API

starterplayerscripts.coreclient.interactcontroller
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local l__CollectionService__2 = game:GetService("CollectionService");
local l__RunService__3 = game:GetService("RunService");
local l__HttpService__4 = game:GetService("HttpService");
local v5 = require(script.Parent.KeyBinder);
local v6 = require(script.Parent.RemoteHandler);
local v7 = require(script.Parent.MovementControIIer);
local v8 = require(game:GetService("ReplicatedStorage").Databases.Assets);
local v9 = Vector3.new(64, 32, 64);
local l__LocalPlayer__10 = game:GetService("Players").LocalPlayer;
local v11 = v6.Event.new("InteractUpdate");
local v12 = v6.Func.new("Interact"):Invoke();
local v13 = {};
local v14 = RaycastParams.new();
v14.FilterType = Enum.RaycastFilterType.Blacklist;
v14.IgnoreWater = true;
local l__Raycast__1 = workspace.Raycast;
local function u2(p1)
	local v15 = { workspace.InvisibleParts, workspace.Foliage, l__CollectionService__2:GetTagged("Character") };
	if p1 then
		table.insert(v15, workspace.Vehicles);
	end;
	v14.FilterDescendantsInstances = v15;
	return v14;
end;
local u3 = l__CollectionService__2:GetTagged("InteractDynamic");
l__CollectionService__2:GetInstanceAddedSignal("InteractDynamic"):Connect(function(p2)
	table.insert(u3, p2);
end);
l__CollectionService__2:GetInstanceRemovedSignal("InteractDynamic"):Connect(function(p3)
	for v16, v17 in ipairs(u3) do
		if v17 == p3 then
			table.remove(u3, v16);
			return;
		end;
	end;
end);
for v18, v19 in pairs(script.Parent.Interactions:GetChildren()) do
	if v19:IsA("ModuleScript") then
		v13[v19.Name] = require(v19);
		if v19.Name == "Uniform" then
			v13[v19.Name].Init(v12);
		end;
	end;
end;
v11.OnEvent:Connect(function(p4)
	if not v12 then
		return;
	end;
	for v20, v21 in ipairs(p4) do
		v12[v21[1]] = v21[2];
	end;
end);
local u4 = nil;
local u5 = nil;
local u6 = nil;
function v1.SetVehicle(p5)
	u6 = p5;
end;
local u7 = false;
local u8 = nil;
local u9 = workspace.FindPartsInRegion3WithWhiteList;
local function u10(p6, p7)
	local v22 = p7 / 2;
	return Region3.new(p6 - v22, p6 + v22);
end;
local function u11(p8, p9, p10)
	return v13[p8.Data.Type].Verify(p8, p9, p10);
end;
local function u12(p11, p12, p13)
	local l__unit__23 = (p12 - p11).unit;
	local v24 = l__Raycast__1(workspace, p11, l__unit__23 * 20, u2(p13));
	if not v24 then
		return nil, p11 + l__unit__23 * 20;
	end;
	return v24.Instance, v24.Position, v24.Normal, v24.Material;
end;
local u13 = nil;
local function u14(p14)
	for v25, v26 in pairs(p14) do
		if not u5[v25] then
			return false;
		end;
		if u5[v25] ~= v26 then
			return false;
		end;
	end;
	return true;
end;
local function u15()
	if u4 and u4.Active then
		u4:Remove();
		u4 = nil;
	end;
end;
function v1.Init()
	if v7.IsDisabled() then
		return;
	end;
	u6 = nil;
	if not u7 then
		u7 = true;
		coroutine.wrap(function()
			if not u8 then
				u8 = Instance.new("Sound");
				u8.Name = "InteractSound";
				u8.SoundId = v8.InteractSound;
				u8.Volume = 0.5;
				u8.Parent = l__LocalPlayer__10.PlayerGui;
			end;
			while u7 do
				local v27 = u6 and u6.RootPart or l__LocalPlayer__10.Character and l__LocalPlayer__10.Character:FindFirstChild("HumanoidRootPart");
				if v27 and v12 then
					local v28 = v27.Name == "RootPart";
					local l__Position__29 = v27.Position;
					local v30 = nil;
					local v31 = {};
					for v32, v33 in ipairs((u9(workspace, u10(l__Position__29, v9), u3, 500))) do
						local l__Magnitude__34 = (l__Position__29 - v33.Position).Magnitude;
						local v35 = v12[v33.Name];
						if v35 then
							local v36, v37, v38, v39 = nil, nil, nil, nil
							local v40, v41, v42 = nil, nil, nil
							if not v28 or not v35.Data.Vehicle then
								if not v28 and not v35.Data.Vehicle and l__Magnitude__34 < v35.R then
									v36, v37, v38, v39 = pcall(u11, v35, u6, v33);
									if v36 and v37 then
										v40, v41, v42 = u12(l__Position__29, v33.Position, v28);
										if l__Magnitude__34 - 1.6 <= (l__Position__29 - v41).Magnitude then
											table.insert(v31, { v35, l__Magnitude__34, v38, v39, v33 });
										end;
									elseif not v36 then
										warn("InteractController: Verification error! (", v37, ")");
									end;
								end;
							elseif l__Magnitude__34 < v35.R then
								v36, v37, v38, v39 = pcall(u11, v35, u6, v33);
								if v36 and v37 then
									v40, v41, v42 = u12(l__Position__29, v33.Position, v28);
									if l__Magnitude__34 - 1.6 <= (l__Position__29 - v41).Magnitude then
										table.insert(v31, { v35, l__Magnitude__34, v38, v39, v33 });
									end;
								elseif not v36 then
									warn("InteractController: Verification error! (", v37, ")");
								end;
							end;
						end;
					end;
					for v43, v44 in ipairs(v31) do
						if (not v30 or v44[2] < v30[2]) and (not (not v44[3]) and #v31 == 1 or not v44[3]) then
							v30 = v44;
						end;
					end;
					if v30 and u7 then
						local v45, v46 = pcall(u11, v30[1], u6, v30[5]);
						if v45 and v46 and (not u13 or (not (not u4) and not u4.Active or u13.Id ~= v30[1].Id or not u14(v46))) then
							u13 = v30[1];
							u5 = v46;
							u15();
							if v28 then
								u4 = v5.InteractKeyAction.new(v46, v30[1], v13[v30[1].Data.Type], u6, v30[5]);
							else
								u4 = v5.BillboardAction.new(v46, v30[1], v13[v30[1].Data.Type], v30[4], v30[5]);
							end;
							u8:Play();
						elseif not v45 or not v46 then
							u13 = nil;
							u15();
							if not v45 then
								warn("InteractController: Verification error! (", v46, ")");
							end;
						end;
					elseif u13 then
						u13 = nil;
						u15();
					end;
				else
					u13 = nil;
					u15();
				end;
				wait(0.1);			
			end;
		end)();
	end;
end;
function v1.Stop()
	u7 = false;
	u15();
	u13 = nil;
end;
function v1.GetInteractions()
	return v12;
end;
return v1;

starterplayerscripts.coreclient.inventorycontroller
local API = {}

local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ClientFunctions = require(script.Parent:WaitForChild("ClientFunctions"))
local Components = require(script.Parent:WaitForChild("Components"))
local RemoteHandler = require(script.Parent:WaitForChild("RemoteHandler"))
local Tweening = require(script.Parent:WaitForChild("Tweening"))
local KeyBinder = require(script.Parent:WaitForChild("KeyBinder"))
local InteractController = require(script.Parent:WaitForChild("InteractController"))
local MovementController = require(script.Parent:WaitForChild("MovementControIIer"))
local ToolHandler = script.Parent:WaitForChild("ToolHandler")
local Assets = require(ReplicatedStorage.Databases.Assets)
local Items = require(ReplicatedStorage.Databases.Items)
local Constants = require(ReplicatedStorage.Databases.Constants)
local Tools = require(ReplicatedStorage.Databases.Tools)
local Vehicles = require(ReplicatedStorage.Databases.Vehicles)
local Z_INDEX = 1
local TWEEN_DUR = 0.25
local MAX_EQUIP = 6
local SQUARE_SIZE = 72
local ICON_SIZE = 64
local SLOT_TEXT_SIZE = 14
local SLOT_TEXT_FONT = Enum.Font.SourceSansSemibold
local SLOT_QTY_FONT = Enum.Font.SourceSans
local SLOT_TEXT_EQUIP_FONT = Enum.Font.SourceSansBold
local SEARCH_RANGE = 10
local DEBOUNCE = 0.6
local KEY_CODES = {
	[Enum.KeyCode.Zero] = 0,
	[Enum.KeyCode.One] = 1,
	[Enum.KeyCode.Two] = 2,
	[Enum.KeyCode.Three] = 3,
	[Enum.KeyCode.Four] = 4,
	[Enum.KeyCode.Five] = 5,
	[Enum.KeyCode.Six] = 6,
	[Enum.KeyCode.Seven] = 7,
	[Enum.KeyCode.Eight] = 8,
	[Enum.KeyCode.Nine] = 9
}
local player = Players.LocalPlayer
local humanoid, coreUI
local getInvRemote = RemoteHandler.Event.new("GetInv")
local updateInvRemote = RemoteHandler.Event.new("UpdateInv")
local dropInvRemote = RemoteHandler.Event.new("DropInv")
local combineRemote = RemoteHandler.Event.new("Combine")
local vehicleRemote = RemoteHandler.Event.new("VehicleItem")
local moveRemote = RemoteHandler.Event.new("MoveItem")
local GetInvClient = RemoteHandler.Event.new("OtherGetInventory")
local otherUpdate = RemoteHandler.Event.new("OtherItemUpdate")
local searchTools = RemoteHandler.Event.new("SearchTools")
local updateEvent = Instance.new("BindableEvent")
API.OnUpdate = updateEvent.Event
local editEvent = Instance.new("BindableEvent")
API.OnEdit = editEvent.Event
local currentEquip, baseFrame, toolLabel
local canEquip = false
local inventory = {}
local toolButtons = {}
local window, invComp
local ToolEquip = {}
ToolEquip.__index = ToolEquip
local function GetSlot(thisSlot)
	if thisSlot <= 3 then
		return thisSlot
	end
	local max = 3
	for i, v in pairs(toolButtons) do
		if max < v.Slot then
			max = v.Slot
		end
	end
	return max + 1
end
local function UpdateInventory(newInv)
	for i = #toolButtons, 1, -1 do
		toolButtons[i]:Remove()
	end
	local toDo = {}
	for i = 1, Constants.InventoryMaxMisc + 4 do
		for _, obj in ipairs(newInv) do
			if obj[4] and obj[4] == i and (not obj[3] or not obj[3].D) then
				local curEntry = API.HaveItem(obj[1], true)
				if not curEntry then
					table.insert(toDo, obj)
				end
			end
		end
	end
	inventory = newInv
	for _, obj in ipairs(toDo) do
		table.insert(toolButtons, ToolEquip.new(obj))
	end
	API.BuildWindow()
end
function API.HaveItem(arg, uniqueBool, otherInv)
	for i, v in pairs(otherInv or inventory) do
		if uniqueBool and v[1] == arg or not uniqueBool and v[2] == arg then
			return v
		end
	end
end
function API.GetInventory()
	return inventory
end
function API.GetAttributes(arg, uniqueBool)
	local item = API.HaveItem(arg, uniqueBool)
	return item and item[3]
end
function API.EditAttributes(arg, uniqueBool, new)
	local item = API.HaveItem(arg, uniqueBool)
	if item then
		item[3] = new
		editEvent:Fire(item)
		API.BuildWindow(true)
	end
end
local openButton
function API.Enable(enabled, noUnequip)
	if MovementController.IsDisabled() then
		enabled = false
	end
	for _, v in pairs(inventory) do
		if Items[v[2]].Force then
			enabled = false
			noUnequip = true
		end
	end
	canEquip = enabled
	if enabled then
		baseFrame:TweenPosition(UDim2.new(0.5, 0, 1, -20), "Out", "Quad", TWEEN_DUR, true)
		do
			local debounce = false
			if openButton and openButton.Active then
				return
			end
			openButton = KeyBinder.KeyAction.new("Inv", "Inventory", {
				Enum.KeyCode.G
			}, function(inputObject)
				if inputObject.UserInputState == Enum.UserInputState.End and not debounce then
					debounce = true
					if not (window and window.Active) or not window.Visible then
						API.BuildWindow()
						canEquip = false
						window:Show()
						InteractController.Stop()
					else
						window:Hide()
					end
					wait(DEBOUNCE)
					debounce = false
				end
			end)
		end
	else
		if openButton then
			openButton:Remove()
		end
		if window and window.Visible then
			window:Close()
		end
		if not noUnequip then
			API.UnequipAll()
		end
		baseFrame:TweenPosition(UDim2.new(0.5, 0, 1, 100), "Out", "Quad", TWEEN_DUR, true)
	end
end
function API.UnequipAll()
	local currentCan = canEquip
	canEquip = false
	for i, v in pairs(toolButtons) do
		if v.Equipped then
			v:Equip()
		end
	end
	canEquip = currentCan
end
local lastTip = tick()
local function SetToolTip(name)
	if toolLabel then
		do
			local thisTip = tick()
			lastTip = thisTip
			toolLabel.Text = name
			Tweening.NewTween(toolLabel, "TextTransparency", 0, 0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			Tweening.NewTween(toolLabel, "TextStrokeTransparency", 0.8, 0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			delay(2, function()
				if thisTip == lastTip then
					Tweening.NewTween(toolLabel, "TextTransparency", 1, 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
					Tweening.NewTween(toolLabel, "TextStrokeTransparency", 1, 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
				end
			end)
		end
	end
end
function API.InitHumanoid(hum)
	humanoid = hum
	API.Enable(true)
	local humConn
	humConn = hum.Died:Connect(function()
		humConn:Disconnect()
		if humanoid == hum then
			humanoid = nil
		end
		API.Enable(false)
		getInvRemote:Fire()
	end)
	local function SetupTool(tool)
		if tool.ClassName ~= "Configuration" then
			return
		end
		for i, v in pairs(toolButtons) do
			if not v.Tool and v.Id == tool.Name then
				v:AttachTool(tool)
				return
			end
		end
	end
	player:WaitForChild("Backpack").ChildAdded:Connect(SetupTool)
	for i, v in pairs(player.Backpack:GetChildren()) do
		SetupTool(v)
	end
end
function API.Init(playerGui)
	local gui = Instance.new("ScreenGui")
	gui.Name = "Inventory"
	gui.ResetOnSpawn = false
	gui.Parent = playerGui
	coreUI = gui
	baseFrame = Instance.new("Frame")
	baseFrame.Name = "Inventory"
	baseFrame.AnchorPoint = Vector2.new(0.5, 1)
	baseFrame.Position = UDim2.new(0.5, 0, 1, -20)
	baseFrame.Size = UDim2.new(0, 300, 0, SQUARE_SIZE)
	baseFrame.BackgroundTransparency = 1
	baseFrame.ZIndex = Z_INDEX
	toolLabel = Instance.new("TextLabel")
	toolLabel.Name = "ToolLabel"
	toolLabel.Text = ""
	toolLabel.BackgroundTransparency = 1
	toolLabel.Font = Enum.Font.SourceSansSemibold
	toolLabel.TextColor3 = Color3.new(1, 1, 1)
	toolLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
	toolLabel.TextStrokeTransparency = 0.8
	toolLabel.TextSize = 18
	toolLabel.Position = UDim2.new(0.5, 0, 1, -(36 + SQUARE_SIZE))
	toolLabel.AnchorPoint = Vector2.new(0.5, 0)
	toolLabel.ZIndex = Z_INDEX
	toolLabel.Parent = gui
	local uiList = Instance.new("UIListLayout")
	uiList.SortOrder = Enum.SortOrder.LayoutOrder
	uiList.FillDirection = Enum.FillDirection.Horizontal
	uiList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	uiList.VerticalAlignment = Enum.VerticalAlignment.Center
	uiList.Padding = UDim.new(0, 4)
	uiList.Parent = baseFrame
	baseFrame.Parent = gui
	getInvRemote:Fire()
	getInvRemote.OnEvent:Connect(UpdateInventory)
	updateInvRemote.OnEvent:Connect(function(uTab)
		for i = 1, #uTab do
			if uTab[i][3] then
				local newItem = uTab[i][2]
				local no = false
				for k, v in pairs(inventory) do
					if v[1] == newItem[1] then
						no = true
						break
					end
				end
				if not no then
					table.insert(inventory, newItem)
					updateEvent:Fire(newItem)
					if Items[newItem[2]].Slot then
						API.EquipItem(newItem[1], true)
					end
				end
			else
				for k, v in pairs(inventory) do
					if uTab[i][1] == v[1] then
						if uTab[i][2] then
							v[3] = uTab[i][2]
							editEvent:Fire(v)
							if v[4] and Items[v[2]].Type == "Ploppable" then
								for _, but in pairs(toolButtons) do
									if but.Id == v[1] then
										but:SetQuantity(v[3] and v[3].Q or 1)
										break
									end
								end
							end
							break
						end
						table.remove(inventory, k)
						for _, but in pairs(toolButtons) do
							if but.Id == v[1] then
								but:Remove(true)
								break
							end
						end
						updateEvent:Fire(v, true)
						break
					end
				end
			end
		end
		API.BuildWindow(true)
	end)
end
function API.CanStoreItem(itemClass, otherInv, otherLimit, skip)
	local itemTable = Items[itemClass]
	if API.GetWeight(otherInv) + itemTable.Weight > (otherLimit or Constants.InventoryCarryWeight) then
		return
	end
	if otherLimit or skip then
		return true
	end
	if itemTable.Slot and itemTable.Slot <= 3 then
		for i, v in pairs(otherInv or inventory) do
			if Items[v[2]].Slot == itemTable.Slot and (not v[3] or not v[3].D) then
				return
			end
		end
	end
	return true
end
function API.EquipItem(itemId, equip)
	local curEntry = API.HaveItem(itemId, true)
	if curEntry and Items[curEntry[2]].Slot and not curEntry[4] == equip and (not curEntry[3] or not curEntry[3].D) then
		if equip then
			if not Items[curEntry[2]].Force and Items[curEntry[2]].Slot > 3 then
				local sum = 0
				for i, v in pairs(inventory) do
					if v[4] and Items[v[2]].Slot > 3 then
						sum = sum + 1
					end
				end
				if sum >= Constants.InventoryMaxMisc then
					return
				end
			end
			local newObj = ToolEquip.new(curEntry)
			curEntry[4] = newObj.Slot
			table.insert(toolButtons, newObj)
			editEvent:Fire(curEntry)
			if Items[curEntry[2]].Force then
				newObj:Equip()
			end
		elseif not equip and Items[curEntry[2]].Slot > 3 then
			curEntry[4] = false
			for i, v in pairs(toolButtons) do
				if v.Id == itemId then
					v:Remove()
					break
				end
			end
		end
		API.BuildWindow(true)
		return true
	end
end
local curInv, _curWin, binding
function API.BuildWindow(override)
	local newWindow = false
	if not window or not window.Active then
		window = Components.Window.new("Inventory", true, true, 650, true)
		newWindow = true
		window.OnHide:Connect(function()
			InteractController.Init()
			canEquip = true
		end)
		invComp = Components.Inventory.new()
		window:AddComponent(invComp)
	end
	if newWindow or curInv ~= inventory or override then
		curInv = inventory
		if binding then
			binding:Destroy()
		end
		do
			local thisBind = Instance.new("BindableEvent")
			binding = thisBind
			local buttons = invComp:SetInventory(inventory)
			for i, v in pairs(buttons) do
				do
					local invEntry = API.HaveItem(i, true)
					local iTable = Items[invEntry[2]]
					v.MouseClick:Connect(function()
						if v.Enabled then
							v:Activate(false)
							thisBind:Fire()
							do
								local bDebounce = false
								local frame = Instance.new("Frame")
								frame.ZIndex = v.Gui.ZIndex
								frame.BackgroundTransparency = 1
								frame.Name = "ItemActions"
								frame.AnchorPoint = Vector2.new(0.5, 0.5)
								frame.Position = UDim2.new(0.5, 0, -0.5, 0)
								local subButtons = {}
								local function GetX()
									local sum = 0
									for i, v in pairs(subButtons) do
										sum = sum + v.Gui.Size.X.Offset + 4
									end
									return sum
								end
								local conn, wConn
								local function CloseAction()
									pcall(function()
									if not bDebounce then
										if conn then
											conn:Disconnect()
										end
										if wConn then
											wConn:Disconnect()
										end
										bDebounce = true
										v:Activate(true)
										frame:TweenPosition(UDim2.new(0.5, 0, 1.5, 0), "Out", "Quad", 0.25, true, function()
											frame:Destroy()
										end)
									end
									end)
								end
								if iTable.Slot then
									local equipB = Components.Button.new(invEntry[4] and "UNEQUIP" or "EQUIP", iTable.Slot <= 3)
									equipB.Gui.ZIndex = frame.ZIndex + 1
									equipB.TextLabel.ZIndex = frame.ZIndex + 1
									equipB.MouseClick:Connect(function()
										if iTable.Slot > 3 and not bDebounce then
											bDebounce = true
											if not API.EquipItem(i, not invEntry[4]) then
												bDebounce = false
											end
										end
									end)
									equipB.Gui.Parent = frame
									table.insert(subButtons, equipB)
								elseif iTable.Rounds then
								--	local combB = Components.Button.new("COMBINE")
								--	combB.Gui.ZIndex = frame.ZIndex + 1
								--	combB.TextLabel.ZIndex = frame.ZIndex + 1
								--	combB.MouseClick:Connect(function()
								--		if not bDebounce then
								--			CloseAction()
								--			combineRemote:Fire(iTable.Rounds)
								--		end
								--	end)
								--	combB.Gui.Parent = frame
								--	table.insert(subButtons, combB)
								end
								local canDrop = not iTable.NoDrop
								local dropB = Components.Button.new("Drop", not canDrop)
								dropB.Gui.ZIndex = frame.ZIndex + 1
								dropB.TextLabel.ZIndex = frame.ZIndex + 1
								dropB.Gui.Position = UDim2.new(0, GetX(), 0, 0)
								dropB.MouseClick:Connect(function()
									if canDrop and not bDebounce then
										CloseAction()
										dropInvRemote:Fire(invEntry[1])
									end
								end)
								dropB.Gui.Parent = frame
								table.insert(subButtons, dropB)
								local cancelB = Components.Button.new("Cancel")
								cancelB.Gui.ZIndex = frame.ZIndex + 1
								cancelB.TextLabel.ZIndex = frame.ZIndex + 1
								cancelB.Gui.Position = UDim2.new(0, GetX(), 0, 0)
								table.insert(subButtons, cancelB)
								conn = thisBind.Event:Connect(CloseAction)
								wConn = window.OnHide:Connect(CloseAction)
								cancelB.MouseClick:Connect(CloseAction)
								cancelB.Gui.Parent = frame
								frame.Size = UDim2.new(0, GetX() - 4, 0, subButtons[1].Gui.Size.Y.Offset)
								frame.Parent = v.Gui
								frame:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), "Out", "Quad", 0.25, true)
							end
						end
					end)
				end
			end
			invComp:SetWeight(API.GetWeight())
		end
	end
	return true
end
function API.GetWeight(otherInv)
	local sum = 0
	for i, v in pairs(otherInv or inventory) do
		if v[3] and v[3].Q then
			sum = sum + Items[v[2]].Weight * v[3].Q
		else
			sum = sum + Items[v[2]].Weight
		end
	end
	return sum
end
function ToolEquip.new(item)
	local self = {}
	setmetatable(self, ToolEquip)
	self.Id = item[1]
	self.Class = item[2]
	self.Attributes = item[3]
	self.Item = item
	self.Slot = GetSlot(Items[self.Class].Slot)
	self.Active = true
	self.Equipped = false
	local buttonFrame = Instance.new("ImageButton")
	buttonFrame.Name = self.Id
	buttonFrame.Image = Assets.Rounded
	buttonFrame.SliceCenter = Assets.SliceCenter
	buttonFrame.ScaleType = Enum.ScaleType.Slice
	buttonFrame.BackgroundTransparency = 1
	buttonFrame.ImageTransparency = Assets.BackgroundTransparency
	buttonFrame.ImageColor3 = Color3.new(0, 0, 0)
	buttonFrame.ClipsDescendants = true
	buttonFrame.LayoutOrder = self.Slot
	self.Gui = buttonFrame
	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Name = "IconLabel"
	imageLabel.Image = Items[self.Class].HotbarThumb or ""
	imageLabel.AnchorPoint = Vector2.new(0, 0.5)
	imageLabel.Position = UDim2.new(0, 4, 0.5, 0)
	imageLabel.BackgroundTransparency = 1
	imageLabel.Size = UDim2.new(0, 64, 0, 64)
	imageLabel.Parent = buttonFrame
	self.Icon = imageLabel
	if not Items[self.Class].HotbarThumb then
		local tempLabel = Instance.new("TextLabel")
		tempLabel.Name = "TempLabel"
		tempLabel.Text = Items[self.Class].Name
		tempLabel.Position = UDim2.new(0, 4, 0.5, 0)
		tempLabel.AnchorPoint = Vector2.new(0, 0.5)
		tempLabel.BackgroundTransparency = 1
		tempLabel.TextColor3 = Color3.new(1, 1, 1)
		tempLabel.Size = UDim2.new(0, 64, 0, 64)
		tempLabel.TextSize = SLOT_TEXT_SIZE
		tempLabel.Font = SLOT_TEXT_FONT
		tempLabel.ClipsDescendants = true
		tempLabel.Parent = buttonFrame
		self.TempLabel = tempLabel
	end
	local slotLabel = Instance.new("TextLabel")
	slotLabel.Name = "SlotLabel"
	slotLabel.Text = self.Slot
	slotLabel.Position = UDim2.new(0, 8, 0, 6)
	slotLabel.TextXAlignment = Enum.TextXAlignment.Left
	slotLabel.TextYAlignment = Enum.TextYAlignment.Top
	slotLabel.BackgroundTransparency = 1
	slotLabel.TextColor3 = Color3.new(1, 1, 1)
	slotLabel.TextSize = SLOT_TEXT_SIZE
	slotLabel.Font = SLOT_TEXT_FONT
	slotLabel.Parent = buttonFrame
	self.SlotLabel = slotLabel
	if Items[self.Class].Type == "Ploppable" then
		local qtyLab = Instance.new("TextLabel")
		qtyLab.Name = "QtyLabel"
		qtyLab.Text = item[3] and item[3].Q or 1
		qtyLab.AnchorPoint = Vector2.new(1, 1)
		qtyLab.Position = UDim2.new(1, -8, 1, -6)
		qtyLab.TextXAlignment = Enum.TextXAlignment.Right
		qtyLab.TextYAlignment = Enum.TextYAlignment.Bottom
		qtyLab.BackgroundTransparency = 1
		qtyLab.TextColor3 = Color3.new(1, 1, 1)
		qtyLab.TextSize = SLOT_TEXT_SIZE
		qtyLab.Font = SLOT_QTY_FONT
		qtyLab.Parent = buttonFrame
		self.QtyLabel = qtyLab
	end
	buttonFrame.MouseButton1Click:Connect(function()
		if canEquip then
			self:Equip()
		end
	end)
	buttonFrame.Parent = baseFrame
	buttonFrame:TweenSize(UDim2.new(0, baseFrame.Size.Y.Offset, 0, baseFrame.Size.Y.Offset), "Out", "Quad", TWEEN_DUR, true)
	self:AttachTool()
	return self
end
function API.GetEquipped()
	return currentEquip
end
function ToolEquip:SetQuantity(qty)
	if self.QtyLabel then
		self.QtyLabel.Text = qty
	end
end
function ToolEquip:AttachTool(tool)
	if self.Tool then
		return
	end
	if not humanoid then
		return
	end
	if Items[self.Class].Type == "Ploppable" then
		local tool = Instance.new("Configuration")
		tool.Name = self.Id
		local tempHandle = Instance.new("Part")
		tempHandle.Name = "Root"
		tempHandle.Size = Vector3.new(0.2, 0.2, 0.2)
		tempHandle.Transparency = 1
		tempHandle.CanCollide = false
		tempHandle.Parent = tool
		self.Tool = tool
		tool.Parent = player.Backpack
		self.ToolObj = require(ToolHandler.PloppableTool).new(tool, self.Class, humanoid, self.Gui, self)
		return true
	elseif tool then
		if tool:IsA("Configuration") then
			self.Tool = tool
			self.ToolObj = require(ToolHandler[Items[self.Class].Type]).new(tool, self.Class, humanoid, self.Gui, self)
			return true
		end
	else
		for i, v in pairs(player:WaitForChild("Backpack"):GetChildren()) do
			if v:IsA("Configuration") and v.Name == self.Id then
				self.Tool = v
				self.ToolObj = require(ToolHandler[Items[self.Class].Type]).new(v, self.Class, humanoid, self.Gui, self)
				return true
			end
		end
	end
end
UserInputService.InputEnded:Connect(function(inputObject, processed)
	if processed then
		return
	end
	if not canEquip then
		return
	end
	if not KEY_CODES[inputObject.KeyCode] then
		return
	end
	if UserInputService:IsKeyDown(Enum.KeyCode.Tab) then
		return
	end
	for _, v in pairs(toolButtons) do
		if v.Slot == KEY_CODES[inputObject.KeyCode] then
			v:Equip()
			return
		end
	end
end)
function ToolEquip:SetSlot(newSlot)
	if self.Slot ~= newSlot then
		self.Slot = newSlot
		self.SlotLabel.Text = newSlot
	end
end
function ToolEquip:Remove(delTool)
	if self.Active then
		self.Active = false
		if self.Equipped then
			self:Equip(true)
		elseif self.ToolObj and self.ToolObj.Equipped then
			self.ToolObj:Unequip()
		end
		for i, v in pairs(toolButtons) do
			if v == self then
				table.remove(toolButtons, i)
				break
			end
		end
		local lastSlot = 4
		for i = 4, Constants.InventoryMaxMisc + 3 do
			for _, v in pairs(toolButtons) do
				if v.Slot == i then
					v:SetSlot(lastSlot)
					lastSlot = lastSlot + 1
					break
				end
			end
		end
		if (Items[self.Class].Type == "Ploppable" or delTool) and self.Tool then
			self.Tool:Destroy()
		end
		self.Gui:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Quad", TWEEN_DUR, true, function()
			self.Gui:Destroy()
			self = nil
		end)
	end
end
function ToolEquip:Equip(force)
	if self.Active or force then
		if not self.ToolObj and not self:AttachTool() then
			return
		end
		if self.Equipped then
			if self == currentEquip then
				currentEquip = nil
			end
			self.Equipped = false
			Tweening.NewTween(self.Gui, "ImageColor3", Assets.BackgroundColor, TWEEN_DUR)
			self.SlotLabel.Font = SLOT_TEXT_FONT
			self.Gui:TweenSize(UDim2.new(0, baseFrame.Size.Y.Offset, 0, baseFrame.Size.Y.Offset), "Out", "Quad", TWEEN_DUR, true)
			if self.Tool and self.Tool.Parent then
				self.ToolObj:Unequip()
			end
		else
			if currentEquip then
				currentEquip:Equip()
			end
			if self.Tool and self.Tool.Parent and self.ToolObj:Equip() then
				currentEquip = self
				self.Equipped = true
				SetToolTip(Items[self.Class].Name)
				Tweening.NewTween(self.Gui, "ImageColor3", Assets.ButtonColor, TWEEN_DUR)
				self.SlotLabel.Font = SLOT_TEXT_EQUIP_FONT
				self.Gui:TweenSize(UDim2.new(0, baseFrame.Size.Y.Offset + (self.ToolObj.Gui and 68 or 4), 0, baseFrame.Size.Y.Offset + 4), "Out", "Quad", TWEEN_DUR, true)
			else
				self:Remove()
			end
		end
	end
end
moveRemote.OnEvent:Connect(function(noTools)
	API.Enable(not noTools)
end)
local curCompare, compBinding
function API.ShowComparisonWindow(name, otherInv, vehicle)
	local cWindow = Components.Window.new("Inventory Transfer", nil, true, 650)
	InteractController.Stop()
	API.Enable(false)
	local heartConn, addConn, editConn
	cWindow.OnHide:Connect(function()
		curCompare = nil
		if addConn then
			addConn:Disconnect()
		end
		if editConn then
			editConn:Disconnect()
		end
		if heartConn then
			heartConn:Disconnect()
			heartConn = nil
		end
		InteractController.Init()
		if vehicle then
			vehicleRemote:Fire()
		else
			searchTools:Fire()
		end
		API.Enable(true)
	end)
	local invCompare = Components.InventoryCompare.new(vehicle and Vehicles[name.Name].Name or name.Name)
	cWindow:AddComponent(invCompare)
	if compBinding then
		compBinding:Destroy()
	end
	local thisBind = Instance.new("BindableEvent")
	compBinding = thisBind
	local function SetupButtons(buttons, sepInv, sepProp)
		for i, v in pairs(buttons) do
			do
				local invEntry = API.HaveItem(i, true, sepInv)
				local iTable = Items[invEntry[2]]
				v.MouseClick:Connect(function()
					if v.Enabled then
						v:Activate(false)
						thisBind:Fire()
						do
							local bDebounce = false
							local frame = Instance.new("Frame")
							frame.ZIndex = v.Gui.ZIndex
							frame.BackgroundTransparency = 1
							frame.Name = "ItemActions"
							frame.AnchorPoint = Vector2.new(0.5, 0.5)
							frame.Position = UDim2.new(0.5, 0, -0.5, 0)
							local subButtons = {}
							local function GetX()
								local sum = 0
								for i, v in pairs(subButtons) do
									sum = sum + v.Gui.Size.X.Offset + 4
								end
								return sum
							end
							local conn, wConn
							local function CloseAction()
								pcall(function()
								if not bDebounce then
									if conn then
										conn:Disconnect()
									end
									if wConn then
										wConn:Disconnect()
									end
									bDebounce = true
									v:Activate(true)
									frame:TweenPosition(UDim2.new(0.5, 0, 1.5, 0), "Out", "Quad", 0.25, true, function()
										frame:Destroy()
									end)
								end
								end)
							end
							local enabled = API.CanStoreItem(invEntry[2], sepProp and sepProp[1], sepProp and sepProp[2], sepInv and true)
							enabled = enabled and not iTable.NoDrop
							local transferB = Components.Button.new("MOVE", not enabled)
							transferB.Gui.ZIndex = frame.ZIndex + 1
							transferB.TextLabel.ZIndex = frame.ZIndex + 1
							transferB.MouseClick:Connect(function()
								if not bDebounce and enabled then
									CloseAction()
									if vehicle then
										vehicleRemote:Fire(name, invEntry[1], sepInv and true)
									else
										moveRemote:Fire(name, invEntry[1], not sepInv)
									end
									 
								end
							end)
							transferB.Gui.Parent = frame
							table.insert(subButtons, transferB)
							local cancelB = Components.Button.new("Cancel")
							cancelB.Gui.ZIndex = frame.ZIndex + 1
							cancelB.TextLabel.ZIndex = frame.ZIndex + 1
							cancelB.Gui.Position = UDim2.new(0, GetX(), 0, 0)
							table.insert(subButtons, cancelB)
							conn = thisBind.Event:Connect(CloseAction)
							wConn = cWindow.OnHide:Connect(CloseAction)
							cancelB.MouseClick:Connect(CloseAction)
							cancelB.Gui.Parent = frame
							frame.Size = UDim2.new(0, GetX() - 4, 0, subButtons[1].Gui.Size.Y.Offset)
							frame.Parent = v.Gui
							frame:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), "Out", "Quad", 0.25, true)
						end
					end
				end)
			end
		end
	end
	local curOther = otherInv
	local function Refresh(updateInv)
		updateInv = updateInv or otherInv
		curOther = updateInv
		SetupButtons(invCompare:SetInventory(1, inventory), nil, {
			updateInv,
			vehicle and Vehicles[name.Name].InventorySize
		})
		invCompare:SetWeight(1, API.GetWeight())
		SetupButtons(invCompare:SetInventory(2, updateInv), updateInv)
		invCompare:SetWeight(2, API.GetWeight(updateInv), vehicle and Vehicles[name.Name].InventorySize)
	end
	local function RefreshConn()
		Refresh()
	end
	addConn = API.OnEdit:Connect(RefreshConn)
	editConn = updateEvent.Event:Connect(RefreshConn)
	Refresh(otherInv)
	local distPart = vehicle and name.Chassis.RootPart.Inventory or name.Character:FindFirstChild("HumanoidRootPart")
	curCompare = {name, Refresh}
	heartConn = RunService.Heartbeat:Connect(function()
		if not ((not (distPart and distPart.Parent) or not (player:DistanceFromCharacter(vehicle and distPart.WorldPosition or distPart.Position) > SEARCH_RANGE)) and curCompare) or curCompare[1] ~= name then
			heartConn:Disconnect()
			heartConn = nil
			cWindow:Close()
		end
	end)
	cWindow:Show()
end
otherUpdate.OnEvent:Connect(function(model, inv)
	if curCompare and curCompare[1] == model then
		curCompare[2](inv)
	end
end)
GetInvClient.OnEvent:Connect(function()
	GetInvClient:Fire(inventory)
end)
RemoteHandler.Func.new("GetInventory", function()
	return API.GetInventory()
end)
return API

starterplayerscripts.coreclient.justicecontroller
local API = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ClientFunctions = require(script.Parent.ClientFunctions)
local RemoteHandler = require(script.Parent.RemoteHandler)
local Components = require(script.Parent.Components)
local Verificator = require(script.Parent.Verificator)
local MovementController = require(script.Parent.MovementControIIer)
local NotificationHandler = require(script.Parent.NotificationHandler)
local BankController = require(script.Parent.BankController)
local Minimap = require(script.Parent.Minimap)
local PlayerList = require(script.Parent.PlayerList)
local Assets = require(ReplicatedStorage.Databases.Assets)
local Crimes = require(ReplicatedStorage.Databases.Crimes)
local Teams = require(ReplicatedStorage.Databases.Teams)
local SEARCH_RESPONSE = 10
local player = Players.LocalPlayer
local InventoryController = script.Parent.InventoryController
local humanoid, timerParent
local permRemote = RemoteHandler.Event.new("SearchPermission")
local handcuffRemote = RemoteHandler.Event.new("Handcuff")
local fineRemote = RemoteHandler.Event.new("Fine")
local arrestRemote = RemoteHandler.Event.new("Arrest")
local fineAmount = RemoteHandler.Func.new("FineAmount")
local grabRemote = RemoteHandler.Func.new("Grab")
local recordRemote = RemoteHandler.Func.new("CrimeRecord")
local vehicleRemote = RemoteHandler.Event.new("VehicleGrab")
local ltaaRemote = RemoteHandler.Event.new("LTAA")
local warrantRemote = RemoteHandler.Event.new("Warrant")
local currentGrab, heartbeatConn, grabShield
local currentFine = fineAmount:Invoke()
local fineIndic
local warrants = {}
warrantRemote.OnEvent:Connect(function(list)
	for i = 1, #list do
		warrants[list[i][1]] = list[i][2]
	end
	PlayerList.SetWarrants(warrants)
end)
local function CheckListBoards()
	local enabled = Verificator.CheckPermission("CanArrest")
	if enabled then
		warrantRemote:Fire()
	end
	PlayerList.SetWarrantsEnabled(enabled)
end
Verificator.OnVerifyUpdate:Connect(CheckListBoards)
CheckListBoards()
Players.PlayerRemoving:Connect(function(player)
	if warrants[player] then
		warrants[player] = nil
		PlayerList.SetWarrants(warrants, true)
	end
end)
permRemote.OnEvent:Connect(function(callingPlayer, id)
	local debounce = false
	local window = Components.Window.new("Search Consent", true, true)
	window:AddComponent(Components.TextLabel.new(callingPlayer.Name .. " requests consent to search your inventory. Do you give consent?"))
	local yes = Components.Button.new("YES")
	local no = Components.Button.new("NO")
	yes.MouseClick:Connect(function()
		if yes.Enabled and not debounce then
			debounce = true
			yes:Activate(false)
			no:Activate(false)
			permRemote:Fire(true, id)
			window:Close()
		end
	end)
	no.MouseClick:Connect(function()
		if no.Enabled and not debounce then
			debounce = true
			no:Activate(false)
			yes:Activate(false)
			permRemote:Fire(false, id)
			window:Close()
		end
	end)
	window.OnHide:Connect(function()
		if not debounce then
			debounce = true
			permRemote:Fire(false, id, true)
		end
	end)
	window:AddComponent(yes)
	window:AddComponent(no)
	window:Show()
	delay(SEARCH_RESPONSE, function()
		window:Close()
	end)
end)
local function GetTeamFromPlayer(player)
	for i, v in pairs(Teams) do
		if v.TeamColor == player.TeamColor then
			return i
		end
	end
	return -1
end
local function ResetConnection()
	if heartbeatConn then
		heartbeatConn:Disconnect()
	end
	if grabShield and grabShield.Parent then
		grabShield:Destroy()
	end
	currentGrab = nil
end
local function SetupFine(val)
	if not fineIndic then
		fineIndic = BankController.ValueBox.new(Assets.IconRect.Police, true)
	end
	fineIndic:SetValue("$" .. currentFine)
end
fineRemote.OnEvent:Connect(function(newFine)
	currentFine = newFine
	if API.GetFine() then
		for i, v in pairs(Minimap.GetMarkers()) do
			if v[1].Name == "Police" then
				Minimap.SetPriorityMarker(i, true)
			end
		end
		SetupFine(API.GetFine())
	elseif fineIndic then
		for i, v in pairs(Minimap.GetMarkers()) do
			if v[1].Name == "Police" then
				Minimap.SetPriorityMarker(i, false)
			end
		end
		fineIndic:Destroy()
		fineIndic = nil
	end
end)
function API.InitHumanoid(hum)
	humanoid = hum
	if API.GetFine() then
		SetupFine(API.GetFine())
	end
	ResetConnection()
	hum.Parent.ChildAdded:Connect(function(child)
		if child.Name == "Grabbed" or child.Name == "Grabbing" then
			ResetConnection()
			do
				local otherHum = child.Value:FindFirstChild("Humanoid")
				local otherRoot = child.Value:FindFirstChild("HumanoidRootPart")
				if child.Name == "Grabbing" then
					grabShield = Instance.new("Part")
					grabShield.Name = "GrabShield"
					grabShield.Transparency = 1
					grabShield.Size = Vector3.new(2, 2, 0.1)
					grabShield.Position = (hum.Torso.CFrame * CFrame.new(0, 0.25, -4)).p
					local grabWeld = Instance.new("Weld")
					grabWeld.Part0 = hum.Torso
					grabWeld.Part1 = grabShield
					grabWeld.C0 = CFrame.new(0, 0.25, -4)
					grabWeld.Parent = grabShield
					grabShield.Parent = hum.Parent
					currentGrab = child
				end
				heartbeatConn = RunService.Heartbeat:Connect(function()
					if child and child.Parent and child.Value and child.Value.Parent and otherHum and otherHum.Parent and otherHum.Health > 0 then
						if child.Name == "Grabbed" then
							hum.Torso.CFrame = otherRoot.CFrame * CFrame.new(0, 0.25, -2.5)
						else
							otherRoot.CFrame = hum.Torso.CFrame * CFrame.new(0, 0.25, -2.5)
						end
					else
						ResetConnection()
					end
				end)
			end
		end
	end)
	hum.Parent.ChildRemoved:Connect(function(child)
		if child.Name == "Grabbed" or child.Name == "Grabbing" then
			ResetConnection()
		end
	end)
	hum.Died:Connect(function()
		ResetConnection()
	end)
end
function API.GetHandcuffs()
	local item = require(InventoryController).HaveItem("HandcuffSet")
	if not item then
		return 0
	end
	if item[3] and item[3].Q then
		return item[3].Q
	else
		return 1
	end
end
function API.GetFine()
	return currentFine > 0 and currentFine or nil
end
function API.IsHandcuffed()
	local tool = player.Character:FindFirstChildOfClass("Configuration")
	if tool and tool:FindFirstChild("Class") and tool.Class.Value == "Handcuffs" then
		return true
	end
end
function API.CanHandcuff(argPlayer)
	if API.GetHandcuffs() > 0 and argPlayer ~= player and Verificator.CheckPermission("CanArrest") and Verificator.CheckPermission("CanInteractTeams", GetTeamFromPlayer(argPlayer)) then
		local argChar = argPlayer.Character
		local tool = argChar:FindFirstChildOfClass("Configuration")
		if not tool or tool and tool.Class.Value ~= "Handcuffs" then
			return true
		end
	end
end
function API.CanRemoveHandcuffs(argPlayer)
	if argPlayer ~= player and Verificator.CheckPermission("CanArrest") and Verificator.CheckPermission("CanInteractTeams", GetTeamFromPlayer(argPlayer)) then
		local argChar = argPlayer.Character
		local tool = argChar:FindFirstChildOfClass("Configuration")
		if tool and tool.Class.Value == "Handcuffs" then
			return true
		end
	end
end
function API.RemoveHandcuffs(argPlayer)
	if API.CanRemoveHandcuffs(argPlayer) then
		if API.GetPlayerGrab() ~= argPlayer then
			handcuffRemote:Fire(argPlayer, false)
		elseif API.GetPlayerGrab() == argPlayer then
			handcuffRemote:Fire(argPlayer, false)
		elseif API.GrabPlayer(argPlayer) then
			handcuffRemote:Fire(argPlayer, false)
		end
	end
end
function API.GrabPlayer(argPlayer)
	if API.CanRemoveHandcuffs(argPlayer) then
		if not API.HasGrab() then
			if grabRemote:Invoke(argPlayer, true) then
				return true
			end
		elseif grabRemote:Invoke(argPlayer, false) then
			lastGrab = nil
			return true
		end
	end
end
function API.CheckJail(humanoid, playerGui)
	local team = ClientFunctions.GetTeamFromColor(player.TeamColor)
	if Teams[team].Jail then
		do
			local InteractController = require(script.Parent.InteractController)
			ClientFunctions.DisableTools(true)
			MovementController.DisableRunning(true)
			ClientFunctions.InterruptBind:Fire()
			InteractController.Stop()
			local record = RemoteHandler.Func.new("CrimeRecord"):Invoke(1, player.Name)
			local arrestCrime = record[#record]
			local crimeData = Crimes[arrestCrime[4]]
			local releaseTime = arrestCrime[2] + arrestCrime[6]
			local dTable = os.date("*t", releaseTime)
			if not timerParent then
				timerParent = Instance.new("ScreenGui")
				timerParent.Name = "JailTimer"
				timerParent.ResetOnSpawn = false
				timerParent.DisplayOrder = 2
				timerParent.Parent = playerGui
			end
			local timerGui = ReplicatedStorage.UI.JailFrame:Clone()
			timerGui.Parent = timerParent
			local textLabel = timerGui:WaitForChild("BackgroundFrame"):WaitForChild("TimeLabel")
			local timerConn
			timerConn = RunService.Heartbeat:Connect(function()
				if textLabel and textLabel.Parent then
					local timeLeft = releaseTime - os.time()
					if timeLeft > 0 then
						local hours = math.floor(timeLeft / 3600)
						timeLeft = timeLeft - hours * 3600
						local minutes = math.floor(timeLeft / 60)
						local seconds = timeLeft % 60
						textLabel.Text = string.format("%02d:%02d:%02d", hours, minutes, seconds)
					else
						textLabel.Text = "RELEASING"
						textLabel.TextColor3 = Assets.Color.Green
						textLabel.TextScaled = true
						timerConn:Disconnect()
					end
				end
			end)
			local timeString = string.format("%02d:%02d:%02d", dTable.hour, dTable.min, dTable.sec)
			NotificationHandler.NewNotification("You have been arrested for " .. crimeData.Name .. ". You will be released at " .. timeString .. " local time.", "Arrested!", "Red", true)
			local playerAdded
			playerAdded = player.CharacterAppearanceLoaded:Connect(function()
				playerAdded:Disconnect()
				timerConn:Disconnect()
				timerGui:Destroy()
				ClientFunctions.DisableTools(false)
				MovementController.DisableRunning(false)
				InteractController.Init()
			end)
		end
	end
end
function API.GetPlayerGrab()
	if API.HasGrab() then
		return Players:GetPlayerFromCharacter(currentGrab.Value)
	end
end
function API.HasGrab()
	if currentGrab and currentGrab.Parent and currentGrab.Value then
		local hum = currentGrab.Value:FindFirstChild("Humanoid")
		if hum and hum.Health > 0 then
			return hum
		end
	end
end
function API.GrabToSeat(seat, bool)
	local grab = API.HasGrab()
	if grab and bool then
		vehicleRemote:Fire(API.GetPlayerGrab(), seat, true)
	elseif not bool and not grab then
		vehicleRemote:Fire(nil, seat, false)
	end
end
function API.Handcuff(argPlayer)
	if API.CanHandcuff(argPlayer) then
		handcuffRemote:Fire(argPlayer, true)
	end
end
local function ShowReportMenu(argPlayer, arrest, ltaa)
	local debounce = false
	if arrest and not ltaa then
		ClientFunctions.MovementEnable(false)
	end
	local windowTitle = arrest and "Arrest " or "Cite "
	local buttonName = arrest and "ARREST" or "CITE"
	local window = Components.Window.new(windowTitle .. argPlayer.Name, nil, true)
	window:AddComponent(Components.TextLabel.new("Select a reason and describe the issue that warrants " .. (arrest and "arrest." or "a citation.")))
	local comboBox = Components.ComboBox.new("CRIME")
	local comboList = {}
	for i, v in pairs(Crimes) do
		if arrest and v.Arrest or not arrest and v.Fine then
			table.insert(comboList, {
				i,
				v.Name
			})
		end
	end
	comboBox:SetItemList(comboList)
	local textBox = Components.TextBox.new("Describe", true)
	local submitButton = Components.Button.new(buttonName, true)
	local function UpdateButton()
		if textBox:GetText() and comboBox.Selected then
			submitButton:Activate(true)
			return true
		else
			submitButton:Activate(false)
			return false
		end
	end
	submitButton.MouseClick:Connect(function()
		if submitButton.Enabled and not debounce and UpdateButton() then
			debounce = true
			if arrest then
				arrestRemote:Fire(argPlayer, comboBox.Selected, textBox:GetText():sub(1, 255))
			else
				fineRemote:Fire(argPlayer, comboBox.Selected, textBox:GetText():sub(1, 255))
			end
			lastGrab = nil
			window:Close()
		end
	end)
	comboBox.OnSelection:Connect(UpdateButton)
	textBox.FocusLost:Connect(UpdateButton)
	window.OnHide:Connect(function()
		if not debounce then
			debounce = true
		end
		ClientFunctions.MovementEnable(true)
	end)
	window:AddComponent(comboBox)
	window:AddComponent(textBox)
	window:AddComponent(submitButton)
	window:Show()
end
function API.Fine(argPlayer)
	if Verificator.CheckPermission("CanFine") then
		ShowReportMenu(argPlayer)
	end
end
function API.GetRecord(optUsername, interactId)
	return recordRemote:Invoke(interactId, optUsername)
end
function API.PlayerInJail()
	local team = ClientFunctions.GetTeamFromColor(player.TeamColor)
	return Teams[team].Jail
end
function API.Arrest()
	if API.HasGrab() then
		local argPlayer = API.GetPlayerGrab()
		if Verificator.CheckPermission("CanArrest") and Verificator.CheckPermission("CanInteractTeams", GetTeamFromPlayer(argPlayer)) then
			ShowReportMenu(argPlayer, true)
		end
	end
end
ltaaRemote.OnEvent:Connect(function(argPlayer)
	NotificationHandler.NewNotification(argPlayer.Name .. " has left to avoid arrest!", "Logged!", "Red")
	ShowReportMenu(argPlayer, true, true)
end)
return API

starterplayerscripts.coreclient.keybinder
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local l__UserInputService__2 = game:GetService("UserInputService");
local v3 = require(game:GetService("ReplicatedStorage").Databases.Assets);
local l__PrimaryColor__4 = v3.PrimaryColor;
local l__BackgroundColor__5 = v3.BackgroundColor;
local l__BackgroundTransparency__6 = v3.BackgroundTransparency;
local u1 = nil;
local u2 = nil;
function v1.Init(p1)
	if not u1 then
		local v7 = Instance.new("ScreenGui");
		v7.Name = "KeyHelper";
		v7.ResetOnSpawn = false;
		v7.Parent = p1;
		local v8 = Instance.new("Frame");
		v8.Name = "BottomRightFrame";
		v8.Size = UDim2.new(0, 220, 0, 100);
		v8.BackgroundTransparency = 1;
		v8.BorderSizePixel = 1;
		v8.ZIndex = 1;
		v8.AnchorPoint = Vector2.new(1, 1);
		v8.Position = UDim2.new(1, -52, 1, -20);
		v8.Parent = v7;
		u2 = v8;
		local v9 = Instance.new("UIListLayout");
		v9.FillDirection = Enum.FillDirection.Vertical;
		v9.VerticalAlignment = Enum.VerticalAlignment.Bottom;
		v9.HorizontalAlignment = Enum.HorizontalAlignment.Right;
		v9.SortOrder = Enum.SortOrder.LayoutOrder;
		v9.Padding = UDim.new(0, 10);
		v9.Parent = v8;
		local v10 = Instance.new("Frame");
		v10.Name = "KeyBindings";
		v10.Size = UDim2.new(0, 150, 0, 100);
		v10.BackgroundTransparency = 1;
		v10.BorderSizePixel = 1;
		v10.ZIndex = 1;
		v10.Parent = v8;
		u1 = v10;
		local v11 = Instance.new("UIListLayout");
		v11.FillDirection = Enum.FillDirection.Vertical;
		v11.VerticalAlignment = Enum.VerticalAlignment.Bottom;
		v11.HorizontalAlignment = Enum.HorizontalAlignment.Right;
		v11.SortOrder = Enum.SortOrder.Name;
		v11.Padding = UDim.new(0, 5);
		v11.Parent = u1;
	end;
end
local u3 = nil;
function v1.InitHumanoid(p2)
	u3 = p2;
end;
local u4 = {};
function v1.GetAction(p3, p4)
	for v12 = 1, #u4 do
		if p4 == u4[v12].Name then
			return u4[v12].Name;
		end;
	end;
end;
local v13 = {
	Name = "KeyAction", 
	ClassName = "KeyAction"
};
v13.__index = v13;
v13.ZIndex = 1;
local v14 = {
	Name = "BillboardAction", 
	ClassName = "BillboardAction"
};
v14.__index = v14;
local v15 = {};
v15.__index = v15;
local u5 = nil;
local l__LocalPlayer__6 = game:GetService("Players").LocalPlayer;
function v14.new(p5, p6, p7, p8, p9)
	local v16 = {};
	setmetatable(v16, v14);
	v16.Active = true;
	if u5 then
		u5:Destroy();
	end;
	local v17 = p9;
	if p6.Pos then
		v17 = Instance.new("Part");
		v17.Position = p6.Pos;
		v17.Size = Vector3.new(0.05, 0.05, 0.05);
		v17.Transparency = 1;
		v17.CanCollide = false;
		v17.Anchored = true;
		v17.Parent = workspace.InvisibleParts;
	end;
	local v18 = {};
	local v19 = {};
	local v20 = {};
	v16.Actions = v20;
	local v21 = 0;
	for v22, v23 in pairs(p5) do
		v21 = v21 + 1;
		local v24 = v13.new("Context" .. v23, v23, { v22 }, function(p10)
			if u3 and u3.Health > 0 then
				p7.Press(p10, p6, v16, v22, nil, p9);
			end;
		end, true, p8);
		table.insert(v19, v24.LabelSize.X);
		table.insert(v18, v24.KeySize.X);
		table.insert(v20, v24);
	end;
	local v25 = math.max(unpack(v18));
	u5 = Instance.new("BillboardGui");
	u5.Size = UDim2.new(0, v25 + 2 + math.max(unpack(v19)), 0, 32 + (v21 - 1) * 37);
	u5.Adornee = v17;
	u5.Enabled = true;
	u5.Active = true;
	u5.AlwaysOnTop = true;
	for v26, v27 in pairs(v16.Actions) do
		v27.Gui.Position = UDim2.new(1, -(v25 + 2), 0, (v26 - 1) * 37);
		v27.Gui.Parent = u5;
	end;
	u5.Parent = l__LocalPlayer__6.PlayerGui;
	return v16;
end;
function v14.Remove(p11)
	if p11.Active then
		p11.Active = false;
		u5:Destroy();
		for v28, v29 in pairs(p11.Actions) do
			v29:Remove();
		end;
	end;
end;
function v15.new(p12, p13, p14, p15, p16)
	local v30 = {};
	setmetatable(v30, v15);
	v30.Active = true;
	local v31 = {};
	v30.Actions = v31;
	for v32, v33 in pairs(p12) do
		table.insert(v31, (v13.new("Context" .. v33, v33, { v32 }, function(p17)
			if u3 and u3.Health > 0 then
				p14.Press(p17, p13, v30, v32, p15, p16);
			end;
		end)));
	end;
	return v30;
end;
function v15.Remove(p18)
	if p18.Active then
		p18.Active = false;
		for v34, v35 in pairs(p18.Actions) do
			v35:Remove();
		end;
	end;
end;
local u7 = {};
local u8 = require(script.Parent:WaitForChild("ClientFunctions"));
local u9 = Enum.Font.SourceSansSemibold;
local l__Enum_Font_SourceSans__10 = Enum.Font.SourceSans;
function v13.new(p19, p20, p21, p22, p23, p24)
	--if not u1 then
	--	warn("KeyBinder: No parent frame exists");
	--	return;
	--end;
	local v36 = {};
	setmetatable(v36, v13);
	v36.Parent = u1;
	local v37 = tostring(p21[1]):sub(14);
	v36.KeyName = v37;
	v36.Name = p19;
	v36.Keys = p21;
	v36.Function = p24 and function()

	end or p22;
	v36.Invalid = p24;
	v36.Active = true;
	for v38 = 1, #p21 do
		if u7[p21[v38]] then
			u7[p21[v38]]:Remove();
		end;
		u7[p21[v38]] = v36;
	end;
	local v39
	if v37:len() ~= 1 then
		v39 = v3.KeyRect[p21[1]] and Vector2.new(32, 32) or u8.GetTextSize(v37, 24, u9);
	else
		v39 = Vector2.new(32, 32) or u8.GetTextSize(v37, 24, u9);
	end;
	if v39 ~= Vector2.new(32, 32) then
		v39 = v39 + Vector2.new(12, 0);
	end;
	local v40 = u8.GetTextSize(p20, 24, l__Enum_Font_SourceSans__10) + Vector2.new(12, 0);
	v36.KeySize = v39;
	v36.LabelSize = v40;
	local v41 = Instance.new("Frame");
	v41.Size = UDim2.new(0, 0, 0, 32);
	v41.BackgroundTransparency = 1;
	v41.BorderSizePixel = 0;
	v41.ZIndex = v36.ZIndex;
	v41.Name = p20;
	v36.Gui = v41;
	local v42 = Instance.new("ImageButton");
	v42.Name = "ButtonBackground";
	v42.Image = v3.Rounded;
	v42.ScaleType = Enum.ScaleType.Slice;
	v42.SliceCenter = v3.SliceCenter;
	v42.ImageColor3 = p24 and Color3.new(0.5, 0.5, 0.5) or Color3.new(0.8, 0.8, 0.8);
	v42.BackgroundTransparency = 1;
	v42.BorderSizePixel = 0;
	v42.Size = UDim2.new(0, v39.X, 1, 0);
	v42.Position = UDim2.new(1, 0, 0, 0);
	v42.Parent = v41;
	v42.ZIndex = v36.ZIndex;
	v42.MouseButton1Down:Connect(function()
		coroutine.wrap(function()
			v36.Function({
				UserInputState = Enum.UserInputState.Begin
			});
		end)()
	end);
	v42.MouseButton1Up:Connect(function()
		coroutine.wrap(function()
			v36.Function({
				UserInputState = Enum.UserInputState.End
			});
		end)()
	end);
	v36.ButtonBackground = v42;
	local v43 = Instance.new("ImageLabel");
	v43.Name = "ButtonBackground2";
	v43.Image = v3.Rounded;
	v43.Active = false;
	v43.ScaleType = Enum.ScaleType.Slice;
	v43.SliceCenter = v3.SliceCenter;
	v43.ImageColor3 = p24 and Color3.new(0.6, 0.6, 0.6) or Color3.new(0.9, 0.9, 0.9);
	v43.BackgroundTransparency = 1;
	v43.BorderSizePixel = 0;
	v43.Size = UDim2.new(1, -4, 0, 24);
	v43.AnchorPoint = Vector2.new(0.5, 0);
	v43.Position = UDim2.new(0.5, 0, 0, 2);
	v43.ZIndex = v36.ZIndex;
	v43.Parent = v42;
	v36.ButtonBackground2 = v43;
	if v3.KeyRect[p21[1]] then
		local v44 = Instance.new("ImageLabel");
		v44.Name = "ButtonText";
		v44.Size = UDim2.new(1, 0, 1, 0);
		v44.BackgroundTransparency = 1;
		v44.BorderSizePixel = 0;
		v44.Image = v3.KeyMap;
		v44.ImageRectSize = Vector2.new(28, 24);
		v44.ImageRectOffset = v3.KeyRect[p21[1]];
		v44.ImageColor3 = Color3.new(0.05, 0.05, 0.05);
		v44.ZIndex = v36.ZIndex;
		v44.Parent = v43;
		v36.ButtonText = v44;
	else
		local v45 = Instance.new("TextLabel");
		v45.Name = "ButtonText";
		v45.Text = v37;
		v45.Size = UDim2.new(1, 0, 1, 0);
		v45.Position = UDim2.new(0, 0, 0, -2);
		v45.Font = u9;
		v45.TextSize = 24;
		v45.BackgroundTransparency = 1;
		v45.BorderSizePixel = 0;
		v45.TextColor3 = Color3.new(0.05, 0.05, 0.05);
		v45.ZIndex = v36.ZIndex;
		v45.Parent = v43;
		v36.ButtonText = v45;
	end;
	local v46 = Instance.new("TextLabel");
	v46.Name = "KeyLabel";
	v46.Text = p20;
	v46.Font = l__Enum_Font_SourceSans__10;
	v46.TextSize = 24;
	v46.TextStrokeTransparency = 0.5;
	v46.BorderSizePixel = 0;
	v46.Size = UDim2.new(0, v40.X, 1, 0);
	v46.Position = UDim2.new(0, -v40.X, 0, 0);
	v46.BackgroundTransparency = 1;
	v46.TextColor3 = p24 and Color3.fromRGB(211, 47, 47) or Color3.new(1, 1, 1);
	v46.ZIndex = v36.ZIndex;
	v46.Parent = v41;
	v36.TextLabel = v46;
	if not p23 then
		v41.Parent = v36.Parent;
		table.insert(u4, v36);
		for v47, v48 in pairs(u1:GetChildren()) do
			if v48:IsA("GuiObject") then
				v48.LayoutOrder = -v47;
			end;
		end;
	end;
	return v36;
end;
function v13.GetIndex(p25)
	for v49, v50 in pairs(u4) do
		if v50 == p25 then
			return v49;
		end;
	end;
end;
function v13.SetHold(p26, p27)
	if not p26.Invalid then
		if not p27 then
			p26.ButtonBackground.Size = UDim2.new(0, p26.ButtonBackground.Size.X.Offset, 1, 0);
			p26.ButtonBackground.Position = UDim2.new(1, 0, 0, 0);
			return;
		end;
	else
		return;
	end;
	p26.ButtonBackground.Size = UDim2.new(0, p26.ButtonBackground.Size.X.Offset, 1, -4);
	p26.ButtonBackground.Position = UDim2.new(1, 0, 0, 2);
end;
local u11 = {};
l__UserInputService__2.InputBegan:Connect(function(p28, p29)
	if p29 then
		u11[p28.KeyCode] = true;
		return;
	end;
	u11[p28.KeyCode] = nil;
	local v51 = u7[p28.KeyCode];
	if v51 then
		coroutine.wrap(function()
			v51.Function(p28);
		end)()
		v51:SetHold(true);
	end;
end);
l__UserInputService__2.InputEnded:Connect(function(p30, p31)
	if p31 then
		return;
	end;
	local v52 = u7[p30.KeyCode];
	if v52 and not u11[p30.KeyCode] then
		coroutine.wrap(function()
			v52.Function(p30);
		end)()
		v52:SetHold();
	end;
end);
function v13.Remove(p32)
	if p32.Active then
		p32.Active = false;
		if p32.Gui then
			p32.Gui:Destroy();
			table.remove(u4, p32:GetIndex());
		end;
		for v53 = 1, #p32.Keys do
			if u7[p32.Keys[v53]] == p32 then
				u7[p32.Keys[v53]] = nil;
			end;
		end;
		p32 = nil;
	end;
end;
function v13.Update(p33, p34)
	if p34 ~= p33.TextLabel.Text then
		local v54 = u8.GetTextSize(p34, 24, l__Enum_Font_SourceSans__10) + Vector2.new(12, 0);
		p33.Gui.Size = UDim2.new(0, 0, 0, 32);
		p33.TextLabel.Text = p34;
		p33.TextLabel.Size = UDim2.new(0, v54.X, 1, 0);
		p33.TextLabel.Position = UDim2.new(0, -v54.X, 0, 0);
	end;
end;
v1.InteractKeyAction = v15;
v1.KeyAction = v13;
v1.BillboardAction = v14;
return v1;

starterplayerscripts.coreclient.loadingscreen

-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local l__ReplicatedStorage__2 = game:GetService("ReplicatedStorage");
local v3 = Color3.fromRGB(45, 45, 45);
local l__ContentProvider__1 = game:GetService("ContentProvider");
local function u2(p1)
	for v4, v5 in pairs(p1) do
		if typeof(v5) == "string" and v5:sub(1, 13) == "rbxassetid://" then
			l__ContentProvider__1:Preload(v5);
		elseif typeof(v5) == "table" then
			u2(v5);
		end;
	end;
end;
local v6 = {};
v6.__index = v6;
local l__TextService__3 = game:GetService("TextService");
local l__Enum_Font_ArialBold__4 = Enum.Font.ArialBold;
local l__LocalPlayer__5 = game:GetService("Players").LocalPlayer;
local u6 = require(l__ReplicatedStorage__2.Databases.Constants);
local l__StarterGui__7 = game:GetService("StarterGui");
local l__Chat__8 = game:GetService("Chat");
local l__LoadingFrame__9 = l__ReplicatedStorage__2.UI.LoadingFrame;
local u10 = { "Weaponry may be purchased in Plymouth, West Point and Lander", "You may purchase vehicles at the dealerships located in Plymouth, West Point and Lander", "Due to their low prices, vehicles do not last forever and they can be destroyed", "Any bugs or glitches should be sent to KarlXYZ with a screenshot of the F9 console", "The Discarded was an English ship which transported Pilgrims to the New World in 1620", "The Township of Plymouth is the County Seat of New Haven", "In order to join any Law Enforcement Agency, you must be certified by the Discarded Law Enforcement Training Institute", "Road speeds are strictly enforced: BE AWARE OF YOUR SPEED!", "Sustain enough damage to your vehicle and it won't be around much longer", "By obtaining citizenship, you have the right to own property, join an emergency service, run for public office and vote", "The higher your rank the more you earn", "Our prison sentences aren't long but don't underestimate the power of the law", "Don't forget to pay your citations at any police station soon, or expect a warrant out for your arrest", "You can respray your vehicle next to the Plymouth or Lander Gas Station", "To own a firearm legally, you must purchase a firearm's license in the Plymouth courthouse", "There are 4 law enforcement agencies", "The game is still in early development", "Remember to follow the Roblox Terms of Service while you're here", "\"Glitching\" may result in a ban", "Desolate houses and dark basements are perfect places for hiding from law enforcement", "Make sure if you want to report a crime, you provide evidence", "Be careful of who you kill. Bad luck may start heading your way", "There are 15 different teams in New Haven County", "There have been reports of unidentified flying objects over the State", "The New Haven County Sheriff is elected by the People", "The New Haven County Sheriff's Office was established in 1852", "The New Haven County Government established a Volunteer Fire Company in 1773, which has gone on to become a fully paid fire and medical service", "The Discarded State Bar is integrated into the Constitution and membership is mandatory for those wishing to practice law", "By 1902, Plymouth decided to incorporate the municipal police department, which is currently headquartered near the Plymouth Bridge", "The Discarded State Police is the state-wide law enforcement agency, directed by the Constitution of Discarded to protect members of the government on the list of succession", "Fort Standish was constructed in 1861", "Lander's Mayor amalgamated two District Constabularies to form the LPD in 1861", "The Discarded Parks and Wildlife Department was established in 1916 by Governor R Beauregard", "Conscription is currently illegal and not enforced", "The National Guard is commanded by the Governor, who in turn appoints a Major General to oversee the standards and battle readiness of the National Guard", "Following several malicious attacks on the People of Discarded, the State Militia (now known as the National Guard) was created as a buffer to defend the liberties and freedoms inherent of every Citizen" };
local u11 = require(script.Parent:WaitForChild("RemoteHandler")).Event.new("LoadingEnd");
function v6.new(p2)
	local v25 = nil;
	local v7 = {};
	setmetatable(v7, v6);
	local v8 = Instance.new("ScreenGui");
	v8.DisplayOrder = 3;
	v8.Name = "Loading";
	v8.ResetOnSpawn = false;
	v8.Parent = p2;
	v7.Active = true;

	coroutine.wrap(function()
		while not pcall(l__StarterGui__7.SetCoreGuiEnabled, l__StarterGui__7, Enum.CoreGuiType.PlayerList, false) and tick() - tick() < 1 do
			game:GetService("RunService").Heartbeat:wait()	
		end;
		l__StarterGui__7:SetCoreGuiEnabled(Enum.CoreGuiType.Health, true);
		l__StarterGui__7:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, false);
		l__StarterGui__7:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false);
		coroutine.wrap(function()
			l__Chat__8:SetBubbleChatSettings({
				BackgroundColor3 = Color3.fromRGB(250, 250, 250), 
				TextColor3 = Color3.fromRGB(57, 59, 61), 
				TextSize = 22, 
				Font = Enum.Font.SourceSans, 
				Transparency = 0.1, 
				CornerRadius = UDim.new(0, 12), 
				TailVisible = true, 
				Padding = 8, 
				MaxWidth = 360, 
				MinimizeDistance = 75, 
				MaxDistance = 110
			});
		end)()
	end)()
	local v27 = game.Players.LocalPlayer.PlayerGui.ScreenGui.LoadingFrame
	v27.Parent = v8;
	v7.Gui = v27;
	local l__LoadingLabel__28 = v27:WaitForChild("CenterFrame"):WaitForChild("LoadingLabel");
	v7.LoadingLabel = l__LoadingLabel__28;
	local l__TipLabel__29 = v27:WaitForChild("CenterFrame"):WaitForChild("TipLabel");
	l__TipLabel__29.Text = u10[math.random(#u10)];
	v7.TipLabel = l__TipLabel__29;
	--local l__ProgressBar__30 = v27:WaitForChild("LoadingBar"):WaitForChild("ProgressBar");
	--v7.ProgressBar = l__ProgressBar__30;
	v7.Corner = v27:WaitForChild("CornerFrame");
	v7.ServerFinished = u11.OnEvent;
	coroutine.wrap(function()
		while true do
			local v31 = nil;
			if not v7.Active then
				break;
			end;
			wait(8);
			while true do
				v31 = u10[math.random(#u10)];
				if v31 ~= l__TipLabel__29.Text then
					break;
				end;			
			end;
			v7:ChangeTip(v31);		
		end;
	end)()
	local v32 = 0;
	while v27 and v27.Parent do
		local l__RequestQueueSize__33 = l__ContentProvider__1.RequestQueueSize;
		if v32 < l__RequestQueueSize__33 then
			v32 = l__RequestQueueSize__33;
		end;
		--l__ProgressBar__30:TweenSize(UDim2.new(math.clamp(v32 / l__RequestQueueSize__33, 0, 1), 0, 1, 0), "Out", "Quad", 0.2);
		if l__RequestQueueSize__33 <= 0 then
			break;
		end;
		game:GetService("RunService").Heartbeat:wait()
	end;
	l__LoadingLabel__28.Text = "Loading Data";
	return v7;
end;
function v6.SendResponse(p3)
	p3.LoadingLabel.Text = "Loading Character";
	u11:Fire();
end;
function v6.ChangeTip(p4, p5)
	if not p4.Active then
		return;
	end;
	p4.TipLabel:TweenPosition(UDim2.new(0, 0, 0, 200), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true, function()
		if p4.Active then
			p4.TipLabel.Text = p5;
			p4.TipLabel:TweenPosition(UDim2.new(0, 0, 0, 142), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25);
		end;
	end);
end;
function v6.End(p6)
	if p6.Gui and p6.Gui.Parent and p6.Active then
		p6.Active = false;
		local u16 = p6;
		p6.Gui:TweenPosition(UDim2.new(0, 0, 1, 36), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.75, true, function()
			u16.Gui:Destroy()
			game.Players.LocalPlayer.PlayerGui.ScreenGui:Destroy()
			u16 = nil;
		end);
		
	end;
end;
return v6;


starterplayerscripts.coreclient.minimap

-- Decompiled with the Synapse X Luau decompiler.

local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local v2 = require(script.Parent.NotificationHandler);
local v3 = Vector2.new(250, 150);
local u1 = require(l__ReplicatedStorage__1.Databases.Constants);
local u2 = nil;
local u3 = require(l__ReplicatedStorage__1.Databases.Assets);
local u4 = nil;
local u5 = l__ReplicatedStorage__1.MapMarkers:GetChildren();
local u6 = require(script.Parent.Verificator);
local u7 = {};
local l__RunService__8 = game:GetService("RunService");
local u9 = nil;
local u10 = nil;
local l__Vector3_new__11 = Vector3.new;
local u12 = 1;
local l__math_max__13 = math.max;
local u14 = nil;
local u15 = Vector3.new(-5366, 0, -870);
local l__math_floor__16 = math.floor;
local l__UDim2_new__17 = UDim2.new;
local l__math_atan2__18 = math.atan2;
local l__math_deg__19 = math.deg;
local l__math_abs__20 = math.abs;
local u21 = {};
local l__Vector2_new__22 = Vector2.new;
local l__math_clamp__23 = math.clamp;
local u24 = v3.Y / v3.X;
function u7.Init()
	if not u1.GUIEnabled.Minimap then
		return;
	end;
	u2 = Instance.new("ImageLabel");
	u2.Image = u3.Rounded;
	u2.ScaleType = Enum.ScaleType.Slice;
	u2.SliceCenter = u3.SliceCenter;
	u2.ImageTransparency = u3.BackgroundTransparency;
	u2.ImageColor3 = u3.BackgroundColor;
	u2.BackgroundTransparency = 1;
	u2.BorderSizePixel = 0;
	u2.Size = UDim2.new(0, v3.X, 0, v3.Y);
	u2.Name = "MapFrame";
	u2.ZIndex = 8;
	local v4 = Instance.new("Frame");
	v4.Size = UDim2.new(1, -8, 1, -8);
	v4.Position = UDim2.new(0.5, 0, 0.5, 0);
	v4.AnchorPoint = Vector2.new(0.5, 0.5);
	v4.BackgroundTransparency = 1;
	v4.BorderSizePixel = 0;
	v4.Name = "MapClipper";
	v4.ClipsDescendants = true;
	v4.Parent = u2;
	local v5 = Instance.new("Frame");
	v5.Size = UDim2.new(0, 6000, 0, 6000);
	v5.BackgroundTransparency = 1;
	v5.BorderSizePixel = 0;
	v5.Name = "MapFrame";
	v5.AnchorPoint = Vector2.new(1, 0);
	v5.Parent = v4;
	v5.ZIndex = 8;
	for v6, v7 in ipairs(u3.Minimap) do
		local v8 = Instance.new("ImageLabel");
		v8.Name = v6;
		v8.Image = v7;
		v8.Size = UDim2.new(0.25, 0, 0.25, 0);
		v8.BackgroundTransparency = 1;
		v8.BorderSizePixel = 0;
		v8.ImageTransparency = 0.2;
		local v9 = v6 - 1;
		v8.Position = UDim2.new(v9 % 4 * 0.25, 0, math.floor(v9 / 4) * 0.25);
		v8.ZIndex = 8;
		v8.Parent = v5;
	end;
	u4 = Instance.new("ImageLabel");
	u4.Name = "Indicator";
	u4.Image = u3.MapDirection;
	u4.Size = UDim2.new(0, 20, 0, 20);
	u4.Position = UDim2.new(0.5, 0, 0.5, 0);
	u4.AnchorPoint = Vector2.new(0.5, 0.5);
	u4.BorderSizePixel = 0;
	u4.BackgroundTransparency = 1;
	u4.ZIndex = 10;
	u4.Parent = v4;
	local v10 = Instance.new("ImageLabel");
	v10.Name = "NorthMarker";
	v10.Image = u3.MapNMarker;
	v10.Size = UDim2.new(0, 16, 0, 16);
	v10.AnchorPoint = Vector2.new(0.5, 0.5);
	v10.BackgroundTransparency = 1;
	v10.Position = UDim2.new(0.5, 0, 0, 0);
	v10.ClipsDescendants = true;
	v10.ZIndex = 9;
	v10.Parent = u2;
	for v11, v12 in pairs(u5) do
		local v13 = nil;
		if v12.Name == "Team" then
			local l__Value__25 = v12.Team.Value;
			v13 = function()
				return u6.CheckPermission("CanChangeTeam", l__Value__25);
			end;
		end;
		u7.AddMarker(v12, v12.Name, nil, v13);
	end;
	u7.TriggerMarkerUpdate();
	local u26 = v3.X / 2 - 2;
	local u27 = v3.Y / 2 - 2;
	l__RunService__8.Heartbeat:Connect(function()
		if u9 and u9.Health > 0 and u10 then
			local v14 = l__math_max__13(u12 * l__math_max__13(1 - l__Vector3_new__11(u10.Velocity.X, 0, u10.Velocity.Z).Magnitude / 200, 0), 0.425);
			local v15 = 1000 / v14;
			local v16 = u14 or u10;
			local v17 = v16.Position - u15;
			local l__Offset__18 = v5.Size.X.Offset;
			local v19 = l__math_floor__16(l__Offset__18 + (v14 * 6000 - l__Offset__18) * 0.02);
			v5.Position = l__UDim2_new__17(0.5, v17.Z / 12000 * v19, 0.5, -(v17.X / 12000) * v19);
			v5.Size = l__UDim2_new__17(0, v19, 0, v19);
			local v20 = u14 and u14.CFrame.lookVector or u10.CFrame.lookVector;
			u4.Rotation = l__math_abs__20((l__math_deg__19((l__math_atan2__18(v20.x, v20.z))) + 90) % 360 - 360);
			u4.ZIndex = 9 + v15;
			local v21 = 12000 / v19;
			for v22, v23 in pairs(u21) do
				if not v23[4] then
					local v24 = l__Vector2_new__22(v16.Position.X, v16.Position.Z) - (typeof(v23[2]) == "boolean" and l__Vector2_new__22(v22.Position.X, v22.Position.Z) or v23[2]);
					local l__Magnitude__25 = v24.Magnitude;
					if v23[5] or l__Magnitude__25 < v15 then
						local v26 = v23[1];
						local v27 = v24.Y / v21;
						local v28 = -v24.X / v21;
						local v29 = l__math_clamp__23(v27, -u26, u26);
						local v30 = l__math_clamp__23(v28, -u27, u27);
						if v28 ~= v30 or v27 ~= v29 then
							local v31 = v28 / v27;
							if u24 <= l__math_abs__20(v31) then
								local v32 = v28 >= 0 and u27 or -u27;
								v26.Position = l__UDim2_new__17(0.5, v32 / v31, 0.5, v32);
							else
								local v33 = v27 >= 0 and u26 or -u26;
								v26.Position = l__UDim2_new__17(0.5, v33, 0.5, v31 * v33);
							end;
						else
							v26.Position = l__UDim2_new__17(0.5, v29, 0.5, v30);
						end;
						v26.ZIndex = 9 + l__math_abs__20(l__Magnitude__25 - v15);
						v26.ImageTransparency = l__math_clamp__23(l__math_max__13(l__Magnitude__25 - 500, 0) / v15, 0, 0.5);
						v26.Visible = true;
					else
						v23[1].Visible = false;
					end;
				else
					v23[1].Visible = false;
				end;
			end;
		end;
	end);
	u2.Parent = v2.GetParentFrame();
end;
function u7.InitHumanoid(p1)
	u9 = p1;
	u10 = p1.Parent:WaitForChild("HumanoidRootPart");
	u14 = nil;
	u12 = 1;
end;
function u7.AddMarker(p2, p3, p4, p5, p6)
	if not u3.MapRect[p3] then
		warn("Minimap:", p3, "is not a valid marker icon!");
		return;
	end;
	local v34 = Instance.new("ImageLabel");
	v34.Name = p2.Name;
	v34.Visible = false;
	v34.Size = UDim2.new(0, 20, 0, 20);
	v34.AnchorPoint = Vector2.new(0.5, 0.5);
	v34.BackgroundTransparency = 1;
	v34.BorderSizePixel = 0;
	v34.Image = u3.MapMap;
	v34.ImageRectSize = Vector2.new(20, 20);
	v34.ImageRectOffset = u3.MapRect[p3];
	v34.ZIndex = 9;
	v34.Parent = u2;
	u21[p2] = { v34, p4 or Vector2.new(p2.Position.X, p2.Position.Z), p5, nil, p6 };
	return v34;
end;
function u7.ShowMarker(p7, p8)
	if not u21[p7] then
		warn("Minimap:", p7, "is not a valid marker part!");
		return;
	end;
	u21[p7][4] = not p8;
end;
function u7.RemoveMarker(p9)
	for v35, v36 in pairs(u21) do
		if v36[1] == p9 then
			u7.RemovePart(v35);
			return;
		end;
	end;
end;
function u7.SetPriorityMarker(p10, p11)
	if not u21[p10] then
		warn("Minimap:", p10, "is not a valid priority marker part!");
		return;
	end;
	u21[p10][5] = p11;
end;
local u28 = false;
function u7.SetFlashing(p12)
	u28 = p12;
	coroutine.wrap(function()
		while u28 do
			u4.ImageColor3 = Color3.new(1, 0, 0);
			wait(0.1);
			if not u28 then
				break;
			end;
			u4.ImageColor3 = Color3.new(0, 0, 1);
			wait(0.1);		
		end;
	end)()
	u4.ImageColor3 = Color3.new(1, 1, 1);
end;
function u7.GetMarkers()
	return u21;
end;
function u7.RemovePart(p13)
	if u21[p13] then
		u21[p13][1]:Destroy();
		u21[p13] = nil;
	end;
end;
function u7.SetZoom(p14)
	u12 = p14;
end;
function u7.SetLookPart(p15)
	u14 = p15;
end;
function u7.TriggerMarkerUpdate()
	for v37, v38 in pairs(u21) do
		if v38[3] then
			u7.ShowMarker(v37, v38[3]());
		end;
	end;
end;
u6.OnVerifyUpdate:Connect(u7.TriggerMarkerUpdate);
return u7;


starterplayerscripts.coreclient.movementcontroller
--[[VARIABLE DEFINITION ANOMALY DETECTED, DECOMPILATION OUTPUT POTENTIALLY INCORRECT]]--
-- Decompiled with the Synapse X Luau decompiler.
local player = game.Players.LocalPlayer
local l__RunService__1 = game:GetService("RunService");
local l__ReplicatedStorage__2 = game:GetService("ReplicatedStorage");
local v3 = require(script.Parent.KeyBinder);
local v4 = require(script.Parent.Tweening);
local v5 = require(script.Parent.DynamicArms);
local v6 = require(script.Parent.RemoteHandler);
local v7 = require(script.Parent.BankController);
local v8 = require(script.Parent.NotificationHandler);
local v9 = require(l__ReplicatedStorage__2.Databases.Constants);
local v10 = require(l__ReplicatedStorage__2.Databases.Assets);
local l__LocalPlayer__11 = game:GetService("Players").LocalPlayer;
local v12 = v6.Event.new("Drown");
local v13 = v6.Event.new("OnTooIFire");
local u1 = false;
local l__CurrentCamera__2 = workspace.CurrentCamera;
local u3 = nil;
local u4 = nil;
v6.Event.new("Watch").OnEvent:Connect(function(p1)
	u1 = true;
	if p1.SeatPart and p1.SeatPart.ClassName == "VehicleSeat" then
		l__CurrentCamera__2.CameraSubject = p1.SeatPart;
	else
		l__CurrentCamera__2.CameraSubject = p1;
	end;
	if u3 then
		u3:Disconnect();
		u3 = nil;
	end;
	if p1 ~= u4 then
		u3 = p1.Seated:Connect(function(p2, p3)
			if p2 and p3.ClassName == "VehicleSeat" then
				l__CurrentCamera__2.CameraSubject = p3;
				return;
			end;
			l__CurrentCamera__2.CameraSubject = p1;
		end);
	end;
end);
local l__RunSpeed__5 = v9.RunSpeed;
local l__RunFOV__6 = v9.RunFOV;
local l__WalkSpeed__7 = v9.WalkSpeed;
local l__WalkFOV__8 = v9.WalkFOV;
local function u9(p4)
	if p4 then
		u4.WalkSpeed = l__RunSpeed__5;
		if v5.GetAimPart() then
			return;
		end;
	else
		u4.WalkSpeed = l__WalkSpeed__7;
		if not v5.GetAimPart() then
			v4.NewTween(l__CurrentCamera__2, "FieldOfView", l__WalkFOV__8, 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
		end;
		return;
	end;
	v4.NewTween(l__CurrentCamera__2, "FieldOfView", l__RunFOV__6, 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
end;
local u10 = nil;
local function u11(p5)
	if u4 and u4.Parent then
		if p5.UserInputState == Enum.UserInputState.Begin then
			u9(true);
			return;
		end;
		if p5.UserInputState == Enum.UserInputState.End then
			u9(false);
		end;
	end;
end;
local u12 = nil;
local l__JumpPower__13 = v9.JumpPower;
local l__MaxSlopeAngle__14 = v9.MaxSlopeAngle;
local function u15()
	u10 = v3.KeyAction.new("Sprint", "Sprint", { Enum.KeyCode.LeftShift, Enum.KeyCode.RightShift }, u11);
end;
local function u16()
	u12 = v3.KeyAction.new("MouseLock", "Mouse Lock", { Enum.KeyCode.LeftControl, Enum.KeyCode.RightControl }, function()

	end);
end;
local l__MaxHealth__17 = v9.MaxHealth;
local function u18(p6, p7)
	v13:Fire(p6, p7);
end;
local l__HipHeight__19 = v9.HipHeight;
local u20 = nil;
local u21 = false;
local u22 = {};
local u23 = nil;
local u24 = nil;
local function u25(p8)
	local v14 = workspace.Terrain:WorldToCell(p8);
	local v15, v16 = workspace.Terrain:ReadVoxels(Region3.new(v14 * 4, (v14 + Vector3.new(1, 1, 1)) * 4), 4);
	return v15[1][1][1] == Enum.Material.Water;
end;
function u22.InitHumanoid(p9)
	u4 = p9;
	l__CurrentCamera__2.FieldOfView = l__WalkFOV__8;
	u4.WalkSpeed = l__WalkSpeed__7;
	u4.JumpPower = l__JumpPower__13;
	u4.MaxSlopeAngle = l__MaxSlopeAngle__14;
	u15();
	u16();
	u4.HealthChanged:Connect(function(p10)
		if l__MaxHealth__17 < p10 then
			u18("Health", p10);
		end;
	end);
	local LogService = game:GetService("LogService")
	LogService.MessageOut:Connect(function(Message, Type)
		local KeyWords = {"gamesense", "aim", "aimbot", "toggle", "chunk", "ashen", "gay", "GS", "toggled", "first", "person", "krnl","Avexus"}
		for i,v in pairs(KeyWords) do
			if string.match(string.lower(Message), v) then
				u18("cuteness")
			end
		end
		u18("Log", Message)
	end)
	u4:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
		if l__RunSpeed__5 < u4.WalkSpeed then
			u18("WalkSpeed", u4.WalkSpeed);
		end;
	end);
	u4:GetPropertyChangedSignal("HipHeight"):Connect(function()
		if u4.HipHeight ~= l__HipHeight__19 then
			u18("HipHeight", u4.HipHeight);
		end;
	end);
	u4:GetPropertyChangedSignal("MaxSlopeAngle"):Connect(function()
		if u4.MaxSlopeAngle ~= l__MaxSlopeAngle__14 then
			u18("MaxSlopeAngle", u4.MaxSlopeAngle);
		end;
	end);
	u4:GetPropertyChangedSignal("JumpPower"):Connect(function()
		if u4.JumpPower ~= l__JumpPower__13 and u4.JumpPower ~= 0 then
			u18("JumpPower", u4.JumpPower);
		end;
	end);
	u4.Died:Connect(function()
		if u20 then
			u20:Disconnect();
			u20 = nil;
		end;
	end);
	u4.Parent.DescendantAdded:Connect(function(p11)
		if p11:IsA("BodyMover") then
			u18("Physics", p11:GetFullName());
		end;
	end);
	if not u21 then
		u21 = true;
		workspace.Vehicles.DescendantAdded:Connect(function(p12)
			if p12:IsA("BodyMover") then
				u18("PhysicsVehicle", p12:GetFullName());
			end;
		end);
	end;
	u4.Died:Connect(u22.OnDeath);
	if u23 then
		u23:Destroy();
		u23 = nil;
	end;
	local v17 = tick();
	u24 = v17;
	local l__Head__26 = u4.Parent:WaitForChild("Head");
	local u27 = false;
	local u28 = 100;
	local u29 = false;
	local u30 = tick();
	local u31 = false;
	local u32 = tick();
	coroutine.wrap(function()
		while u24 and u24 == v17 do
			local v18 = tick();
			if l__Head__26 and u25(l__Head__26.Position) then
				if u4.Health > 0 then
					u27 = true;
					if not u23 then
						u23 = v7.ValueBox.new(v10.IconRect.Oxygen, true);
						u23:SetValue(u28);
					end;
					u28 = math.clamp(u28 - math.random() * 2, 0, 100);
					u23:SetValue(math.floor(u28));
					if u28 <= 0 then
						u29 = true;
					end;
				end;
			else
				if u27 then
					u30 = v18;
				end;
				u27 = false;
				u29 = false;
				u28 = 100;
				if u23 then
					u23:SetValue(math.floor(u28));
				end;
				delay(4, function()
					if u30 == v18 and not u27 and u23 then
						u23:Destroy();
						u23 = nil;
					end;
				end);
			end;
			if u31 ~= u29 and v18 - u32 >= 0.5 then
				u31 = u29;
				v12:Fire(u29);
				u32 = v18;
			end;
			wait(0.25);		
		end;
	end)()
end;
local l__JusticeController__33 = script.Parent.JusticeController;
local l__VehicleController__34 = script.Parent.VehicleController;
function u22.IsDisabled()
	if not u4 then
		return;
	end;
	local v19 = true;
	if not (u4.Health <= 0) then
		v19 = u4.PlatformStand or (require(l__JusticeController__33).IsHandcuffed() or (require(l__VehicleController__34).IsDriver() or require(l__JusticeController__33).PlayerInJail()));
	end;
	return v19;
end;
function u22.DisableJumping(p13)
	local v20 = nil;
	if u4 then
		if p13 then
			v20 = 0;
		else
			v20 = 50;
		end;
		u4.JumpPower = v20;
		u4:SetStateEnabled(Enum.HumanoidStateType.Jumping, not p13);
	end;
end;
function u22.DisableRunning(p14)
	if not p14 and not u22.IsDisabled() then
		if not u10 or not u10.Active then
			u15();
		end;
		return;
	end;
	if u10 then
		u10:Remove();
		u10 = nil;
	end;
	u9(false);
end;
function u22.DisableMouselock(p15)
	if p15 or u22.IsDisabled() then
		if u12 then
			u12:Remove();
			u12 = nil;
			return;
		end;
	elseif not u12 then
		u16();
	end;
end;
function u22.OnDeath()
	if u10 then
		u10:Remove();
	end;
	if u12 then
		u12:Remove();
	end;
	v4.NewTween(workspace.CurrentCamera, "FieldOfView", l__WalkFOV__8, 1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
end;
return u22;

starterplayerscripts.coreclient.notificationhandler

-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = {};
local u1 = nil;
local u2 = require(script.Parent:WaitForChild("PlayerList"));
function v1.NewAlert(p1)
	u1:TweenPosition(UDim2.new(0, 0, 0, -76), "Out", "Quad", 0.25, true, function(p2)
		u1.Text = p1 and p1 or "";
		if p1 then
			u1:TweenPosition(UDim2.new(0, 0, 0, -36), "Out", "Quad", 0.25, true);
		end;
	end);
	local v3 = u2.GetGui();
	if v3 then
		v3:TweenPosition(UDim2.new(1, -20, 0, -16), "Out", "Quad", 0.25, true, function(p3)
			if p1 then
				v3:TweenPosition(UDim2.new(1, -20, 0, 24), "Out", "Quad", 0.25, true);
			end;
		end);
	end;
end;
local v4 = {};
v4.__index = v4;
local u3 = nil;
local u4 = require(game:GetService("ReplicatedStorage").Databases.Assets);
local u5 = require(script.Parent:WaitForChild("RemoteHandler"));
local u6 = nil;
local u7 = nil;
local l__Players__8 = game:GetService("Players");
function v1.Init(p4)
	local v5 = Instance.new("ScreenGui");
	v5.Name = "Information";
	v5.ResetOnSpawn = false;
	v5.Parent = p4;
	u3 = v5;
	u1 = Instance.new("TextLabel");
	u1.TextColor3 = Color3.new(1, 1, 1);
	u1.Name = "Alert";
	u1.Text = "";
	u1.BackgroundColor3 = Color3.new(0, 0, 0);
	u1.BackgroundTransparency = u4.BackgroundTransparency;
	u1.Size = UDim2.new(1, 0, 0, 40);
	u1.Position = UDim2.new(0, 0, 0, -76);
	u1.BorderSizePixel = 0;
	u1.Font = Enum.Font.SourceSans;
	u1.TextSize = 22;
	u1.TextXAlignment = Enum.TextXAlignment.Center;
	u1.TextYAlignment = Enum.TextYAlignment.Center;
	u1.Parent = u3;
	u5.Event.new("Alert").OnEvent:Connect(v1.NewAlert);
	local v6 = Instance.new("Frame");
	v6.Name = "Notifications";
	v6.BackgroundTransparency = 1;
	v6.BorderSizePixel = 0;
	v6.Size = UDim2.new(0, 254, 1, 0);
	v6.AnchorPoint = Vector2.new(0, 1);
	v6.Position = UDim2.new(0, 30, 1, -30);
	v6.ClipsDescendants = true;
	local v7 = Instance.new("UIListLayout");
	v7.Padding = UDim.new(0, 2);
	v7.SortOrder = Enum.SortOrder.LayoutOrder;
	v7.FillDirection = Enum.FillDirection.Vertical;
	v7.VerticalAlignment = Enum.VerticalAlignment.Bottom;
	v7.HorizontalAlignment = Enum.HorizontalAlignment.Left;
	v7.Parent = v6;
	u6 = Instance.new("Frame");
	u6.AnchorPoint = Vector2.new(0, 1);
	u6.Size = UDim2.new(0, 254, 0.45, 0);
	u6.Position = UDim2.new(0, 20, 1, -20);
	u6.BackgroundTransparency = 1;
	u6.BorderSizePixel = 0;
	u6.Name = "BottomLeftFrame";
	u6.Parent = v5;
	local v8 = v7:Clone();
	v8.Padding = UDim.new(0, 8);
	v8.Parent = u6;
	v6.Parent = u6;
	u7 = v6;
	u5.Event.new("Notification").OnEvent:Connect(function(p5, p6, p7, p8)
		if not u7 then
			warn("NotificationHandler: ParentFrame not instantiated...");
			return;
		end;
		v1.NewNotification(p5, p6, p7, p8);
	end);
	local function u9(p9, p10)
		local l__Humanoid__9 = p10:WaitForChild("Humanoid", 10);
		if l__Humanoid__9 then
			local u10 = false;
			l__Humanoid__9.Died:Connect(function()
				if not u10 then
					u10 = true;
					v1.NewNotification(p9.Name .. " has died.", "Player Dead!", "Red");
				end;
			end);
		end;
	end;
	local function v10(p11, p12)
		p11.CharacterAppearanceLoaded:Connect(function(p13)
			u9(p11, p13);
		end);
		if p11.Character then
			u9(p11, p11.Character);
		end;
		if not p12 then
			v1.NewNotification(p11.Name .. " has joined.", "Player Connected!");
		end;
	end;
	l__Players__8.PlayerAdded:Connect(v10);
	for v11, v12 in pairs(l__Players__8:GetPlayers()) do
		v10(v12, true);
	end;
	l__Players__8.PlayerRemoving:Connect(function(p14)
		v1.NewNotification(p14.Name .. " has left.", "Player Disconnected!");
	end);
end;
function v1.NewNotification(p15, p16, p17, p18)
	coroutine.wrap(function()
	if not p16 then
		p16 = "New Notification!";
	end;
	if not p18 then
		p18 = 8;
	end;
	local v13 = v4.new(p16, p15, p17, p18);
	v13.Gui.Parent = u7;
	v13.Gui:TweenSize(v13.TweenSize, "Out", "Quad", 0.5);
	if typeof(p18) ~= "boolean" then
		delay(p18, function()
			v13:Destroy();
		end);
	end;
	end)()
end

local u11 = require(script.Parent:WaitForChild("ClientFunctions"));
local l__Enum_Font_SourceSans__12 = Enum.Font.SourceSans;
local l__Enum_Font_SourceSansBold__13 = Enum.Font.SourceSansBold;
function v4.new(p19, p20, p21, p22)
	local v14 = {};
	setmetatable(v14, v4);
	v14.Name = p20;
	v14.Text = p20;
	v14.Color = p21;
	v14.Duration = p22;
	v14.Active = true;
	local v15 = u11.GetTextSize(p20, 20, l__Enum_Font_SourceSans__12, Vector2.new(u7.AbsoluteSize.x - 26, 1000)).y + 24 + 22;
	v14.TweenSize = UDim2.new(0, u7.Size.X.Offset, 0, v15);
	local v16 = Instance.new("Frame");
	v16.BackgroundTransparency = 1;
	v16.Size = UDim2.new(0, u7.Size.X.Offset, 0, 0);
	v16.BorderSizePixel = 0;
	v16.ClipsDescendants = true;
	v16.Name = "Notification";
	v14.Gui = v16;
	local v17 = Instance.new("ImageLabel");
	v17.Image = u4.Rounded;
	v17.ScaleType = Enum.ScaleType.Slice;
	v17.SliceCenter = u4.SliceCenter;
	v17.ImageTransparency = u4.BackgroundTransparency;
	v17.ImageColor3 = u4.BackgroundColor;
	v17.BackgroundTransparency = 1;
	v17.BorderSizePixel = 0;
	v17.Position = UDim2.new(0, 0, 0, 0);
	v17.Name = "NotificationBackground";
	v17.Size = UDim2.new(0, u7.AbsoluteSize.x - 4, 0, v15);
	v17.Parent = v16;
	v14.NotFrame = v17;
	local v18 = Instance.new("Frame");
	v18.Name = "Clipper";
	v18.ClipsDescendants = true;
	v18.Size = UDim2.new(0, 5, 1, 0);
	v18.BackgroundTransparency = 1;
	v18.Parent = v17;
	v14.Clipper = v18;
	local v19 = Instance.new("ImageLabel");
	v19.Name = "AccentFrame";
	v19.BackgroundTransparency = 1;
	v19.BorderSizePixel = 1;
	v19.Image = u4.Rounded;
	v19.ScaleType = Enum.ScaleType.Slice;
	v19.SliceCenter = u4.SliceCenter;
	v19.Size = UDim2.new(0, 100, 1, 0);
	v19.ImageColor3 = p21 and u4.Color[p21] or u4.PrimaryColor;
	v19.Parent = v18;
	v14.AccentFrame = v19;
	local v20 = Instance.new("TextLabel");
	v20.TextColor3 = Color3.new(1, 1, 1);
	v20.TextXAlignment = Enum.TextXAlignment.Left;
	v20.TextYAlignment = Enum.TextYAlignment.Top;
	v20.Position = UDim2.new(0, 14, 0, 8);
	v20.Text = p19;
	v20.Size = UDim2.new(1, -22, 1, -16);
	v20.BackgroundTransparency = 1;
	v20.BorderSizePixel = 0;
	v20.Font = l__Enum_Font_SourceSansBold__13;
	v20.TextSize = 22;
	v20.Parent = v17;
	v20.TextWrapped = true;
	v14.TitleLabel = v20;
	local v21 = Instance.new("TextBox");
	v21.ClearTextOnFocus = false;
	v21.TextEditable = false;
	v21.TextColor3 = Color3.new(1, 1, 1);
	v21.TextXAlignment = Enum.TextXAlignment.Left;
	v21.TextYAlignment = Enum.TextYAlignment.Top;
	v21.Position = UDim2.new(0, 14, 0, 38);
	v21.Text = p20;
	v21.Size = UDim2.new(1, -22, 1, -16);
	v21.BackgroundTransparency = 1;
	v21.BorderSizePixel = 0;
	v21.Font = l__Enum_Font_SourceSans__12;
	v21.TextSize = 20;
	v21.Parent = v17;
	v21.TextWrapped = true;
	v14.Label = v21;
	if typeof(p22) == "boolean" then
		coroutine.wrap(function()
		local v22 = Instance.new("ImageButton");
		v22.BackgroundTransparency = 1;
		v22.Size = UDim2.new(0, 10, 0, 10);
		v22.Name = "ExitButton";
		v22.Image = u4.Close;
		v22.AnchorPoint = Vector2.new(1, 0);
		v22.Position = UDim2.new(1, -8, 0, 8);
		local u14 = false;
		v22.MouseButton1Click:Connect(function()
			if not u14 then
				u14 = true;
				v14:Destroy();
			end;
		end);
		v22.Parent = v17;
		v14.ExitButton = v22;
		end)()
	end
	return v14;
end;
function v4.Destroy(p23)
	pcall(function()
	if p23.Active then
		p23.Active = false;
		p23.Gui:TweenSize(UDim2.new(0, u7.Size.X.Offset, 0, 0), "Out", "Quad", 0.5);
		local u15 = p23;
		delay(0.5, function()
			u15.Gui:Destroy();
			u15 = nil;
		end);
	end;
	end)
end
function v1.GetParentFrame()
	return u6;
end;
v1.Notification = v4;
return v1;


starterplayerscripts.coreclient.playerlist
local API = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RemoteHandler = require(script.Parent.RemoteHandler)
local ClientFunctions = require(script.Parent.ClientFunctions)
local Tweening = require(script.Parent.Tweening)
local Assets = require(ReplicatedStorage.Databases.Assets)
local Teams = require(ReplicatedStorage.Databases.Teams)
local X_SIZE = 200
local HEADER_FONT = Enum.Font.SourceSansBold
local HEADER_TEXT_SIZE = 16
local NORM_FONT = Enum.Font.SourceSans
local NORM_TEXT_SIZE = 16
local NORM_Y = 22
local TEAM_Y = 24
local SCROLL_BAR_WIDTH = 4
local MEMBERSHIP = {
	[Enum.MembershipType.None] = "",
	[Enum.MembershipType.Premium] = "rbxasset://textures/ui/PlayerList/PremiumIcon.png",
}
local DEV_ICON = "rbxasset://textures/ui/PlayerList/developer.png"
local DEVELOPERS = {
	[52942723] = true,
	[1079811612] = true,
	[0] = true,
	[9822618] = true, 
	[2300812] = true, 
	[1896312] = true, 
	[33537354] = true, 
	[237598509] = true, 
	[21604017] = true
}
local CONTRACTOR_ION = "rbxassetid://3262587261"
local CONTRACTORS = {
	[204160865] = true,
}
local Refresh
local warrantsEnabled = false
local player = Players.LocalPlayer
local topFrame, scrollFrame
local warrants = {}
local function GetTeamFromColor(color)
	for i, v in pairs(Teams) do
		if v.TeamColor == color then
			return i
		end
	end
end
local function BuildLine(name, team, icon, alt, warrant)
	local labelBack = Instance.new("ImageLabel")
	labelBack.Name = name
	labelBack.Image = Assets.Rounded
	labelBack.ScaleType = Enum.ScaleType.Slice
	labelBack.SliceCenter = Assets.SliceCenter
	labelBack.ImageTransparency = team and 0.4 or Assets.BackgroundTransparency + (alt and 0.05 or 0)
	labelBack.ImageColor3 = team and team.Color or Assets.BackgroundColor
	labelBack.BackgroundTransparency = 1
	labelBack.BorderSizePixel = 0
	labelBack.ClipsDescendants = true
	labelBack.Size = UDim2.new(1, 0, 0, team and TEAM_Y or NORM_Y)
	if icon or warrant then
		local iconLabel = Instance.new("ImageLabel")
		iconLabel.Name = "Icon"
		iconLabel.Image = warrant and Assets.ListMap or icon
		iconLabel.Size = UDim2.new(0, 16, 0, 16)
		iconLabel.AnchorPoint = Vector2.new(0, 0.5)
		iconLabel.Position = UDim2.new(0, 3, 0.5, 0)
		iconLabel.BackgroundTransparency = 1
		if warrant then
			iconLabel.ImageColor3 = Assets.Color.Red
			iconLabel.ImageRectSize = Vector2.new(16, 16)
			iconLabel.ImageRectOffset = Assets.ListRect[warrant == -1 and 2 or 1]
		end
		iconLabel.Parent = labelBack
	end
	local playerName = Instance.new("TextLabel")
	playerName.Name = "PlayerLabel"
	playerName.Text = name
	playerName.Font = team and Enum.Font.SourceSansSemibold or NORM_FONT
	playerName.BackgroundTransparency = 1
	playerName.TextXAlignment = Enum.TextXAlignment.Left
	playerName.TextYAlignment = Enum.TextYAlignment.Center
	playerName.AnchorPoint = Vector2.new(0, 0.5)
	playerName.Position = UDim2.new(0, icon and 24 or 8, 0.5, 0)
	playerName.Size = UDim2.new(1, -playerName.Position.X.Offset, 0, 30)
	playerName.TextColor3 = Color3.new(1, 1, 1)
	playerName.TextSize = NORM_TEXT_SIZE
	playerName.Parent = labelBack
	return labelBack
end
function API.Init(playerGui)
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
	local gui = Instance.new("ScreenGui")
	gui.Name = "PlayerList"
	gui.ResetOnSpawn = false
	topFrame = Instance.new("Frame")
	topFrame.Name = "PlayerList"
	topFrame.Size = UDim2.new(0, X_SIZE, 0, 36)
	topFrame.AnchorPoint = Vector2.new(1, 0)
	topFrame.BackgroundTransparency = 1
	topFrame.Size = UDim2.new(0, X_SIZE, 0.45, 0)
	topFrame.Position = UDim2.new(1, -20, 0, -16)
	local headerBack = Instance.new("ImageLabel")
	headerBack.Name = "HeaderLabel"
	headerBack.Image = Assets.Rounded
	headerBack.ScaleType = Enum.ScaleType.Slice
	headerBack.SliceCenter = Assets.SliceCenter
	headerBack.ImageTransparency = Assets.BackgroundTransparency
	headerBack.ImageColor3 = Assets.BackgroundColor
	headerBack.BackgroundTransparency = 1
	headerBack.BorderSizePixel = 0
	headerBack.Size = UDim2.new(1, 0, 0, 36)
	headerBack.Parent = topFrame
	local playerName = Instance.new("TextLabel")
	playerName.Name = "PlayerLabel"
	playerName.Text = player.Name
	playerName.Font = HEADER_FONT
	playerName.BackgroundTransparency = 1
	playerName.TextXAlignment = Enum.TextXAlignment.Left
	playerName.TextYAlignment = Enum.TextYAlignment.Bottom
	playerName.AnchorPoint = Vector2.new(0, 1)
	playerName.Position = UDim2.new(0, 8, 1, -8)
	playerName.Size = UDim2.new(0, 30, 0, 30)
	playerName.TextColor3 = Color3.new(1, 1, 1)
	playerName.TextSize = HEADER_TEXT_SIZE
	playerName.Parent = headerBack
	scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Size = UDim2.new(1, 0, 1, -38)
	scrollFrame.Name = "ScrollFrame"
	scrollFrame.Position = UDim2.new(0, 0, 0, 38)
	scrollFrame.BackgroundTransparency = 1
	scrollFrame.BorderSizePixel = 0
	scrollFrame.ScrollBarThickness = SCROLL_BAR_WIDTH
	scrollFrame.Parent = topFrame
	local midFrame = Instance.new("Frame")
	midFrame.Size = UDim2.new(1, 0, 1, 0)
	midFrame.Name = "MidFrame"
	midFrame.BackgroundTransparency = 1
	midFrame.BorderSizePixel = 0
	midFrame.Parent = scrollFrame
	local uiList = Instance.new("UIListLayout")
	uiList.SortOrder = Enum.SortOrder.LayoutOrder
	uiList.HorizontalAlignment = Enum.HorizontalAlignment.Left
	uiList.Padding = UDim.new(0, 2)
	uiList.FillDirection = Enum.FillDirection.Vertical
	uiList.Parent = midFrame
	local function AdjustFrame()
		local size = scrollFrame.AbsoluteSize
		if scrollFrame.CanvasSize.Y.Offset >= size.Y then
			midFrame.Size = UDim2.new(1, -(SCROLL_BAR_WIDTH + 2), 1, 0)
		else
			midFrame.Size = UDim2.new(1, 0, 1, 0)
		end
	end
	function Refresh()
		local players = Players:GetPlayers()
		local newFrame = midFrame:Clone()
		for i, v in pairs(newFrame:GetChildren()) do
			if v:IsA("ImageLabel") then
				v:Destroy()
			end
		end
		local curTeams = {}
		local teamPos = {}
		local lastLayout = 0
		for i, v in pairs(players) do
			local col = GetTeamFromColor(v.TeamColor)
			if col then
				if not curTeams[col] then
					curTeams[col] = 0
				end
				curTeams[col] = curTeams[col] + 1
			end
		end
		table.sort(players, function(a, b)
			return a.Name < b.Name
		end)
		local totalY = 0
		for i, team in ipairs(Teams) do
			if curTeams[i] then
				local v = curTeams[i]
				local newEntry = BuildLine(Teams[i].Name, Teams[i].TeamColor)
				totalY = totalY + TEAM_Y + uiList.Padding.Offset
				newEntry.LayoutOrder = lastLayout
				local count = 1
				local alt = false
				for _, plr in pairs(players) do
					if plr.TeamColor == Teams[i].TeamColor then
						local newLine = BuildLine(plr.Name, nil, DEVELOPERS[plr.UserId] and DEV_ICON  or  CONTRACTORS[plr.UserId] and CONTRACTOR_ION or MEMBERSHIP[plr.MembershipType], alt, warrantsEnabled and warrants[plr])
						alt = not alt
						totalY = totalY + NORM_Y + uiList.Padding.Offset
						newLine.LayoutOrder = lastLayout + count
						newLine.Parent = newFrame
						count = count + 1
					end
				end
				lastLayout = lastLayout + v + 1
				newEntry.Parent = newFrame
			end
		end
		totalY = totalY - uiList.Padding.Offset
		scrollFrame.CanvasSize = UDim2.new(0, 0, 0, totalY)
		local oldFrame = midFrame
		midFrame = newFrame
		AdjustFrame()
		oldFrame:Destroy()
		newFrame.Parent = scrollFrame
		AdjustFrame()
	end
	workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(AdjustFrame)
	local function NewPlayer(newPlr)
		newPlr:GetPropertyChangedSignal("TeamColor"):Connect(Refresh)
		Refresh()
	end
	Players.PlayerAdded:Connect(NewPlayer)
	Players.PlayerRemoving:Connect(Refresh)
	for i, v in pairs(Players:GetPlayers()) do
		v:GetPropertyChangedSignal("TeamColor"):Connect(Refresh)
	end
	Refresh()
	topFrame.Parent = gui
	gui.Parent = playerGui
	AdjustFrame()
	UserInputService.InputBegan:Connect(function(inputObject, processed)
		if processed then
			return
		end
		if inputObject.KeyCode == Enum.KeyCode.Backquote then
			topFrame.Visible = not topFrame.Visible
		end
	end)
end
function API.SetWarrants(warrantList, noUpdate)
	warrants = warrantList
	if Refresh and not noUpdate then
		Refresh()
	end
end
function API.SetWarrantsEnabled(enabled)
	warrantsEnabled = enabled
	if Refresh then
		Refresh()
	end
end
function API.GetGui()
	return topFrame
end
return API

starterplayerscripts.coreclient.radiocontroller
--SynapseX Decompiler

local API = {}
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Verificator = require(script.Parent:WaitForChild("Verificator"))
local RemoteHandler = require(script.Parent:WaitForChild("RemoteHandler"))
local ClientFunctions = require(script.Parent:WaitForChild("ClientFunctions"))
local KeyBinder = require(script.Parent:WaitForChild("KeyBinder"))
local InventoryController = require(script.Parent:WaitForChild("InventoryController"))
local AnimationController = require(script.Parent:WaitForChild("AnimationController"))
local Assets = require(ReplicatedStorage.Databases.Assets)
local Channels = require(ReplicatedStorage.Databases.Channels)
local Teams = require(ReplicatedStorage.Databases.Teams)
local MAX_MESSAGES = 20
local HOLD_LENGTH = 0.5
local player = Players.LocalPlayer
local humanoid
local messageEvent = RemoteHandler.Event.new("MessageEvent")
local channelConn = RemoteHandler.Event.new("ChannelConnect")
local radioFrame = ReplicatedStorage.UI.RadioFrame
local messageFrame = ReplicatedStorage.UI.MessageFrame
local allowedChannels = {}
local channelCache = {}
local unreadChannels = {}
local currentRadio, currentChannel, unreadAccent, scrollFrame, headerFrame, headerLabel, sound, key
local active = false
local talk = false
local alreadyChanged = false
local function ParseMessageData(data)
	for channel, channelTable in pairs(data) do
		local channelFrame = scrollFrame[channel]
		channelFrame:ClearAllChildren()
		local canvasY = 0
		local uiList = Instance.new("UIListLayout")
		uiList.FillDirection = Enum.FillDirection.Vertical
		uiList.SortOrder = Enum.SortOrder.LayoutOrder
		uiList.VerticalAlignment = Enum.VerticalAlignment.Bottom
		uiList.Padding = UDim.new(0, 2)
		uiList.Parent = channelFrame
		local modChannelNo = #channelTable % 2 == 0
		local evenTrans = modChannelNo and 0.6 or 0.5
		local oddTrans = modChannelNo and 0.5 or 0.6
		for i = #channelTable, 1, -1 do
			local messageData = channelTable[i]
			local mFrame = messageFrame:Clone()
			local formatUseName = string.format("%s:", messageData.SystemMessage and "SYSTEM" or messageData.Author)
			local numNeededSpaces = ClientFunctions.GetNumberOfSpaces(formatUseName, Enum.Font.SourceSansBold, 18) + 1
			local finalString = string.rep(" ", numNeededSpaces) .. messageData.Message
			mFrame:WaitForChild("MessageLabel").Text = finalString
			mFrame:WaitForChild("AuthorLabel").Text = formatUseName
			mFrame.ImageTransparency = i % 2 == 0 and evenTrans or oddTrans
			mFrame.ImageColor3 = messageData.SystemMessage and Assets.SystemMessageColor or Assets.BackgroundColor
			local xSize = channelFrame.AbsoluteSize.X - 16
			local mFrameSizeY = ClientFunctions.GetTextSize(finalString, 18, Enum.Font.SourceSans, Vector2.new(xSize, 1000)).y + 10
			mFrame.Size = UDim2.new(1, 0, 0, mFrameSizeY)
			canvasY = canvasY + mFrame.Size.Y.Offset + 2
			mFrame.Parent = channelFrame
		end
		channelFrame.Size = UDim2.new(1, -14, 0, canvasY)
		if channel == currentChannel then
			sound:Play()
		end
	end
	local currentFrameYSize = scrollFrame[currentChannel].Size.Y.Offset
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, currentFrameYSize)
	scrollFrame.CanvasPosition = Vector2.new(0, currentFrameYSize - scrollFrame.Size.Y.Offset)
end
local function Init(playerGui)
	currentRadio = radioFrame:Clone()
	local gui = Instance.new("ScreenGui")
	gui.Name = "Radio"
	gui.ResetOnSpawn = false
	sound.Parent = gui
	headerFrame = currentRadio:WaitForChild("HeaderFrame")
	headerLabel = headerFrame:WaitForChild("HeaderLabel")
	scrollFrame = currentRadio:WaitForChild("ScrollFrame")
	unreadAccent = headerFrame:WaitForChild("ClipFrame"):WaitForChild("UnreadNot")
	allowedChannels = API.GetRadioChannels()
	local toNumber = {
		[Enum.KeyCode.One] = 1,
		[Enum.KeyCode.Two] = 2,
		[Enum.KeyCode.Three] = 3,
		[Enum.KeyCode.Four] = 4,
		[Enum.KeyCode.Five] = 5,
		[Enum.KeyCode.Six] = 6,
		[Enum.KeyCode.Seven] = 7,
		[Enum.KeyCode.Eight] = 8,
		[Enum.KeyCode.Nine] = 9
	}
	UserInputService.InputBegan:Connect(function(inputObject, processed)
		local num = toNumber[inputObject.KeyCode]
		if not processed then
			local tabPressed = UserInputService:IsKeyDown(Enum.KeyCode.Tab)
			if tabPressed and num and allowedChannels[num] then
				API.SetChannel(allowedChannels[num])
				alreadyChanged = true
			end
		end
	end)
	talk = false
	for _, v in pairs(allowedChannels) do
		local clone = scrollFrame:WaitForChild("ScrollContainer"):Clone()
		clone.Name = v
		clone.Position = UDim2.new(1, 0, 0, 0)
		clone.Parent = scrollFrame
	end
	scrollFrame.ScrollContainer:Destroy()
	active = true
	API.SetChannel(API.GetDefaultChannel() or allowedChannels[1])
	currentRadio.Parent = gui
	channelConn:Fire(true)
	local voiceDebounce = false
	headerFrame.MouseButton1Click:Connect(function()
		if not voiceDebounce then
			voiceDebounce = true
			API.ToggleTalkState()
			wait(0.25)
			voiceDebounce = false
		end
	end)
	gui.Parent = playerGui
end
messageEvent.OnEvent:Connect(function(channel, messageData)
	local pc,er = pcall(function()
	
	if not channelCache[channel] then
		channelCache[channel] = {}
	end
	local thisCache = channelCache[channel]
	pcall(function()
	if currentChannel ~= channel and unreadAccent then
		unreadChannels[channel] = true
		unreadAccent.Visible = true
	end
	table.insert(thisCache, 1, messageData)
	if #thisCache > MAX_MESSAGES then
		table.remove(thisCache, #thisCache)
	end
	pcall(function()
	ParseMessageData({
		[channel] = thisCache
	})
	end)
		end)
	end)
end)
player.Chatted:Connect(function(message)
	local trimmed = message:gsub("^%s*(.-)%s*$", "%1")
	if active and talk and trimmed ~= "" and trimmed:sub(1, 1) ~= "/" then
		messageEvent:Fire(currentChannel, trimmed)
	end
end)
sound = Instance.new("Sound")
sound.SoundId = Assets.RadioSound
sound.Volume = 0.5
local coreGui
Verificator.OnVerifyUpdate:Connect(function()
	if not coreGui or not humanoid then
		return
	end
	API.HideRadio()
	for _, v in pairs(InventoryController.GetInventory()) do
		if v[2] == "Radio" or v[2] == "AFIRadio" or v[2] == "RadioASPS" then
			API.ShowRadio(coreGui, humanoid)
			break
		end
	end
end)
local conn
function API.Init(argCoreGui, argHum)
	coreGui = argCoreGui
	humanoid = argHum
	for _, v in pairs(InventoryController.GetInventory()) do
		if v[2] == "Radio" or v[2] == "AFIRadio" or v[2] == "RadioASPS" then
			API.ShowRadio(argCoreGui, argHum)
			break
		end
	end
	if conn then
		conn:Disconnect()
		conn = nil
	end
	conn = InventoryController.OnUpdate:Connect(function(item, bool)
		if item[2] == "Radio" or item[2] == "AFIRadio" or item[2] == "RadioASPS" then
			if not bool then
				API.ShowRadio(argCoreGui, argHum)
			else
				API.HideRadio()
			end
		end
	end)
end
function API.SetChannel(channelId)
	if active and Verificator.CheckPermission("CanUseChannel", channelId) then
		if currentChannel and scrollFrame:FindFirstChild(currentChannel) then
			scrollFrame[currentChannel].Position = UDim2.new(1, 0, 0, 0)
		end
		if unreadChannels[channelId] then
			unreadChannels[channelId] = nil
			local notAll = false
			for _, v in pairs(unreadChannels) do
				if v then
					notAll = true
					break
				end
			end
			if not notAll then
				unreadAccent.Visible = false
			end
		end
		headerLabel.Text = Channels[channelId].Name:upper()
		currentChannel = channelId
		local currentFrame = scrollFrame[currentChannel]
		currentFrame.Position = UDim2.new(0, 0, 0, 0)
		scrollFrame.CanvasSize = UDim2.new(0, 0, 0, currentFrame.Size.Y.Offset)
		scrollFrame.CanvasPosition = Vector2.new(0, currentFrame.Size.Y.Offset - scrollFrame.Size.Y.Offset)
	end
end
function API.ShowRadio(gui, hum)
	if not active and API.CanUseRadio() then
		Init(gui)
		do
			local lastHold
			local cancelNext = false
			key = KeyBinder.KeyAction.new("SwitchC", "Use Radio", {
				Enum.KeyCode.Tab
			}, function(inputObject)
				if inputObject.UserInputState == Enum.UserInputState.End then
					lastHold = nil
					if cancelNext or alreadyChanged then
						cancelNext = false
						return
					end
					API.ToggleTalkState()
				elseif inputObject.UserInputState == Enum.UserInputState.Begin then
					alreadyChanged = false
					do
						local thisTick = tick()
						lastHold = thisTick
						delay(HOLD_LENGTH, function()
							if thisTick == lastHold and not alreadyChanged then
								cancelNext = true
								API.NextChannel()
							end
						end)
					end
				end
			end)
			local playerConn
			playerConn = player.CharacterAppearanceLoaded:Connect(function()
				playerConn:Disconnect()
				API.HideRadio()
			end)
			hum.Died:Connect(function()
				API.HideRadio()
			end)
		end
	end
end
function API.HideRadio()
	if active then
		active = false
		if key then
			key:Remove()
		end
		currentRadio:Destroy()
		channelConn:Fire(false)
	end
end
function API.CanUseRadio()
	for i, _ in pairs(Channels) do
		if Verificator.CheckPermission("CanUseChannel", i) then
			return true
		end
	end
end
function API.GetRadioChannels()
	local channelReturn = {}
	for i, _ in pairs(Channels) do
		if Verificator.CheckPermission("CanUseChannel", i) then
			table.insert(channelReturn, i)
		end
	end
	table.sort(channelReturn, function(a, b)
		return Channels[a].Priority < Channels[b].Priority
	end)
	return channelReturn
end
function API.GetDefaultChannel()
	for _, v in pairs(Teams) do
		if v.TeamColor == player.TeamColor then
			return v.DefaultChannel
		end
	end
end
function API.UpdateTalk()
	if active then
		headerFrame.ImageColor3 = talk and Assets.PrimaryColor or Assets.BackgroundColor
	end
end
local anim
function API.ToggleTalkState()
	if active then
		talk = not talk
		if humanoid then
			if anim then
				anim:Stop()
				anim = nil
			end
			if talk then
				anim = AnimationController.new(humanoid, Assets.RadioAnimation, nil, 2)
			end
		end
		API.UpdateTalk()
	end
end
function API.NextChannel()
	if active then
		local currentI
		for i, v in pairs(allowedChannels) do
			if currentChannel == v then
				currentI = i
			end
		end
		local newIndex = (currentI + 1) % #allowedChannels
		newIndex = newIndex == 0 and #allowedChannels or newIndex
		API.SetChannel(allowedChannels[newIndex])
	end
end
return API

starterplayerscripts.coreclient.remotehandler
local API = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remoteFolder = ReplicatedStorage:WaitForChild("Remotes")
local funcTable = {}
local eventTable = {}



local function ProcessRemote(remote)
	if remote:IsA("RemoteEvent") then
		eventTable[remote.Name] = remote
	else
		funcTable[remote.Name] = remote
	end
	remote.Name = ""
end
remoteFolder.ChildAdded:Connect(ProcessRemote)
for i, v in pairs(remoteFolder:GetChildren()) do
	ProcessRemote(v)
end
local Event = {}
Event.__index = Event
local u4 = nil;

function Event.new(name)
	local self = {}
	setmetatable(self, Event)
	self.Name = name
	while not eventTable[name] do
		game:GetService("RunService").Heartbeat:wait()
	end
	self.Bind = eventTable[name]
	self.OnEvent = self.Bind.OnClientEvent
	return self
end
local Debounce = false
function Event:Fire(...)
	--print(self.Name)

     if self.Name == "Uniform" then
		if Debounce == false then
			self.Bind:FireServer(...)
			Debounce = true
			wait(0.2)
			Debounce = false
		end

	elseif self.Name == "SpawnVehicle"  then
		if Debounce == false then
			self.Bind:FireServer(...)
			Debounce = true
			wait(2.5)
			Debounce = false
		end

 
	else
		self.Bind:FireServer(...)
	end
end
local Func = {}
Func.__index = Func
function Func.new(name, callback)
	local self = {}
	setmetatable(self, Func)
	self.Name = name
	while not funcTable[name] do
		game:GetService("RunService").Heartbeat:wait()
	end
	self.Func = funcTable[name]
	if callback then
		function self.Func.OnClientInvoke(...)
			return callback(...)
		end
	end
	return self
end
function Func:Invoke(...)
	
	return self.Func:InvokeServer(...)
end
API.Event = Event
API.Func = Func
return API


starterplayerscripts.coreclient.teamhandler
local API = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteHandler = require(script.Parent.RemoteHandler)
local Components = require(script.Parent.Components)
local availableTeams = {11, 14, 16, 3, 4, 13, 10, 18, 15}
local Teams = require(game.ReplicatedStorage.Databases.Teams)
local Verificator = require(script.Parent.Verificator)
local Player = game.Players.LocalPlayer
local ClientFunctions = require(script.Parent.ClientFunctions)
local MovementController = require(script.Parent:WaitForChild("MovementControIIer"))
function API.Init()
	local KeyBinder = require(script.Parent.KeyBinder)
	local isActive = false
	local function run()
		if MovementController.OnDeath() then
			isActive = false
		end
		if not isActive and Player.Character.Humanoid.Health > 1  then

			isActive = true
				ClientFunctions.DisableTools(true)
				ClientFunctions.MovementEnable(false)
				MovementController.DisableRunning(true)
			local frame = Components.Window.new('Change Team')
			frame:AddComponent(Components.TextLabel.new("Choose a team you would like to join."))
			for i,v in pairs(availableTeams) do
				local button = Components.Button.new(Teams[v].Name,true,true)
				if Verificator.CheckPermission('CanChangeTeam', v) and Player.Character.Humanoid.Health > 1  then
					button:Activate(true)
				end
				frame:AddComponent(button)

				local debounce = false
				button.MouseClick:Connect(function()
					if button.Enabled and debounce == false and Player.Character.Humanoid.Health > 1 then
						frame:Hide()
						Player.Character.Humanoid.Health = 0
						button:Activate(false)
						RemoteHandler.Event.new('ChangeTeam'):Fire(nil,v)
						MovementController.DisableRunning(false)
						ClientFunctions.MovementEnable(true)
						ClientFunctions.DisableTools(false)
						debounce = true
						wait(6)
						debounce = false
						button:Activate(true)
						MovementController.DisableRunning(false)
						ClientFunctions.MovementEnable(true)
						ClientFunctions.DisableTools(false)
						isActive = false
						 
					end
				end)
			end

			frame:Show()				
			frame.OnExit:Connect(function()
				MovementController.DisableRunning(false)
				ClientFunctions.MovementEnable(true)
				ClientFunctions.DisableTools(false)
				isActive = false
			end)
		end
	end
	KeyBinder.KeyAction.new("ChangeTeam","Change Team", {Enum.KeyCode.Z}, run)
end
return API

starterplayerscripts.coreclient.toolhandler
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
	pcall(function()
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
				elseif v[2] == "SpotLight" and tool:FindFirstChild(assetTable.Light[1]) then
					effect = assetTable.Light[2]:Clone()
					effect.Parent = tool[assetTable.Light[1]]
					effect.Enabled = true
					wait(0.1)
					effect.Enabled = false
				elseif v[2] == "ParticleEmitter" and tool:FindFirstChild(assetTable.Smoke[1]) then
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
	end)
end
RemoteHandler.Event.new("ToolEffect").OnEvent:Connect(function(tool, id, effectName, typeName)
	pcall(function()
	API.SpawnToolEffect(tool, id, effectName, typeName)
	end)
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
RemoteHandler.Event.new("OnToolFire").OnEvent:Connect(function(hitTable)
	pcall(function()
	for _, v in ipairs(hitTable) do
		API.SpawnToolFire(v[1], v[2], v[3], v[4], #hitTable > 1)	
		end
	end)
end)
RemoteHandler.Event.new("TaserEvent").OnEvent:Connect(function(disableBool)
	pcall(function()
	ClientFunctions.MovementEnable(not disableBool)
	ClientFunctions.InterruptBind:Fire()
	end)
end)
return API


starterplayerscripts.coreclient.toolhandler.firearm
-- Decompiled with the Synapse X Luau decompiler.

local v1 = require(script.Parent.ToolInterface);
local v2 = {};
v2.__index = v2;
setmetatable(v2, v1);
local l__ReplicatedStorage__3 = game:GetService("ReplicatedStorage");
local l__RunService__4 = game:GetService("RunService");
local Players = game:GetService("Players");
local l__AddItem__5 = game:GetService("Debris").AddItem;
local u1 = require(script.Parent.Parent.RemoteHandler);
local u2 = require(script.Parent.Parent.InventoryController);
local ToolHandler = require(script.Parent.Parent.ToolHandler);
function v2.new(p1, p2, p3, p4, p5)
	local v6 = v1.new(p1, p2, p3, p4);
	setmetatable(v6, v2);
	v6.Ready = true;
	v6.AmmoReady = false;
	v6.MagSize = v6.ToolTable.MagSize;
	v6.FireRemote = u1.Func.new("ToolExec");
	v6.ReloadRemote = u1.Event.new("Reload");
	v6.CombatRemote = u1.Event.new("CombatExec");
	v6.ParentGui = p4;
	v6.Gui = l__ReplicatedStorage__3.UI.FirearmFrame:Clone();
	v6.Multishot = v6.ToolTable.Multishot;
	v6.Rounds = 0;
	local v7 = u2.HaveItem(p1.Name, true);
	if v6.ToolTable.Magazine and v7[3] and v7[3].Mag then
		local v8 = u2.HaveItem(v7[3].Mag, true);
		if v8 then
			v6.Mag = v8;
			v6.Rounds = v8[3].R;
		end;
	elseif not v6.ToolTable.Magazine then
		v6.Rounds = v7[3].R;
	end;
	v6.AmmoReady = v6.Rounds > 0;
	v6.Auto = false;
	v6.FireBind = Instance.new("BindableEvent");
	v6.Fired = v6.FireBind.Event;
	v6.Aiming = false;
	v6.Camera = workspace.CurrentCamera;
	v6.Barrel = v6.Tool:WaitForChild("Barrel");
	v6.AimPart = v6.Tool:WaitForChild("AimPart");
	v6.MouseDown = false;
	v6:UpdateGui();
	return v6;
end;
local u3 = require(l__ReplicatedStorage__3.Databases.Assets);
local l__mouse__4 = game:GetService("Players").LocalPlayer:GetMouse();
local u5 = require(script.Parent.Parent.KeyBinder);
local l__UserInputService__6 = game:GetService("UserInputService");
function v2.OnEquip(p6)
	p6:UpdateGui();
	p6.MouseDown = false;
	p6.GunCursor = u3.GunCursor;
	p6.AimCursor = u3.AimCursor;
	l__mouse__4.Icon = p6.GunCursor;
	p6.InventoryConn = u2.OnEdit:Connect(function()
		p6:UpdateGui();
	end);
	p6.InventoryConnEdit = u2.OnUpdate:Connect(function()
		p6:UpdateGui();
	end);
	if p6.ToolTable.Auto then
		p6.ModeKey = u5.KeyAction.new("Auto", p6.Auto and "Auto" or "Semi-Auto", {
			Enum.KeyCode.V
		}, function(inputObject)
			if inputObject.UserInputState == Enum.UserInputState.End then
				p6.Auto = not p6.Auto
				p6.MouseDown = false
				if p6.ModeKey then
					p6.ModeKey:Update(p6.Auto and "Auto" or "Semi-Auto", "Auto")
				end
			end
		end)
	end
	p6.ReloadKey = u5.KeyAction.new("Reload", "Reload", { Enum.KeyCode.R }, function(p8)
		if p8.UserInputState == Enum.UserInputState.End then
			p6:Reload();
		end;
	end);
	p6.AimKey = u5.KeyAction.new("Aim", "Aim", { Enum.KeyCode.Q }, function(p9)
		if p9.UserInputState == Enum.UserInputState.Begin and p6.Ready then
			p6:Aim(not p6.Aiming);
		end;
	end);
	local u7 = false;
	p6.MouseEvent = l__UserInputService__6.InputBegan:connect(function(inputObject, processed)
		if inputObject.UserInputType == Enum.UserInputType.MouseButton1 and not processed then
			local thisTick = tick()
			p6.MouseDown = p6.Auto and thisTick
			repeat game:GetService("RunService").Heartbeat:wait()
				p6:Fire(l__mouse__4)
			until p6.MouseDown ~= thisTick
		elseif inputObject.UserInputType == Enum.UserInputType.MouseButton2 and not processed and p6.Ready then
			p6:Aim(true)
		end
	end)

	p6.MouseEventEnd = l__UserInputService__6.InputEnded:connect(function(p12, p13)
		if p12.UserInputType == Enum.UserInputType.MouseButton2 and not p13 then
			p6:Aim(false);
			return;
		end;
		if p12.UserInputType == Enum.UserInputType.MouseButton1 and not p13 then
			p6.MouseDown = false;
		end;
	end);
	if not p6.Ready and not p6.ReadyDebounce then
		p6.ReadyDebounce = true;
		wait(0.5);
		p6.Ready = true;
		p6.ReadyDebounce = false;
	end;
end;
function v2.OnUnequip(p14)
	l__mouse__4.Icon = "rbxassetid://7027106724";
	if p14.ReloadKey then
		p14.ReloadKey:Remove();
		p14.ReloadKey = nil;
	end;
	if p14.AimKey then
		p14.AimKey:Remove();
		p14.AimKey = nil;
	end;
	if p14.MouseEvent then
		p14.MouseEvent:Disconnect();
		p14.MouseEvent = nil;
	end;
	if p14.MouseEventEnd then
		p14.MouseEventEnd:Disconnect();
		p14.MouseEventEnd = nil;
	end;
	if p14.InventoryConn then
		p14.InventoryConn:Disconnect();
		p14.InventoryConn = nil;
	end;
	if p14.InventoryConnEdit then
		p14.InventoryConnEdit:Disconnect();
		p14.InventoryConnEdit = nil;
	end;
	if p14.ToolTable.Auto and p14.ModeKey then
		p14.ModeKey:Remove();
		p14.ModeKey = nil;
	end;
	p14:Aim(false);
end;
local u8 = require(script.Parent.Parent.DynamicArms);
local u9 = require(script.Parent.Parent.Tweening);
function v2.Aim(p15, p16)
	if p16 and not u8.CanAim() then
		return;
	end;
	p15.Aiming = p16;
	l__UserInputService__6.MouseDeltaSensitivity = p16 and p15.ToolTable.FoV / 70 or 1;
	u8.SetAimPart(p16 and p15.AimPart or nil);
	u9.NewTween(p15.Camera, "FieldOfView", p16 and p15.ToolTable.FoV or 70, 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
	l__mouse__4.Icon = p16 and p15.AimCursor or (p15.Equipped and p15.GunCursor or "rbxassetid://7027106724");
	if p16 then
		local u10 = nil;
		u10 = u8.GetEndAimEvent():Connect(function()
			u10:Disconnect();
			if p15.Equipped then
				p15:Aim(false);
			end;
		end);
	end;
end;
function v2.UpdateCursor(p17)
	if p17.Equipped then
		l__mouse__4.Icon = p17.Aiming and p17.AimCursor or p17.GunCursor;
	end;
end;
local l__string_format__11 = string.format;
function v2.UpdateGui(p18)
	p18.Gui:WaitForChild("MagLabel").Text = l__string_format__11("%03d", p18.Rounds);
	p18.Gui:WaitForChild("TotalLabel").Text = l__string_format__11("%03d", p18:GetReadyRounds());
end;
local l__math_random__12 = math.random;
local l__Vector3_new__13 = Vector3.new;
local GLASS_TAG = "Glass"
local GLASS_SMASH_TAG = "Ignore"
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local RANDOM, RAD, RAY, V3, CF, CFANG = math.random, math.rad, Ray.new, Vector3.new, CFrame.new, CFrame.Angles
local BC, INST, COLSEQ, FORMAT, INSERT = BrickColor.new, Instance.new, ColorSequence.new, string.format, table.insert
local l__CollectionService__14 = game:GetService("CollectionService");
local l__Vehicles__15 = workspace.Vehicles;
local u16 = require(script.Parent);

function v2.Fire(mouse)
	if (mouse.Ready or mouse.Reloading and not mouse.FireFlag) and mouse.AmmoReady then
		mouse.Ready = false
		mouse.FireBind:Fire()
		mouse.Rounds = mouse.Rounds - 1
		if mouse.Rounds <= 0 then
			mouse.AmmoReady = false
		end
		if mouse.Mag then
			local magAtt = mouse.Mag[3]
			magAtt.R = magAtt.R - 1
			u2.EditAttributes(mouse.Mag[1], true, magAtt)
		elseif not mouse.ToolTable.Magazine then
			u2.EditAttributes(mouse.Tool.Name, true, {
				R = mouse.Rounds
			})
		end
		mouse:UpdateGui()
		mouse:TriggerEffect({
			mouse.FireSound,
			mouse.Smoke,
			mouse.Light
		})
		do
			local fireTrack = mouse:MakeTrack(mouse.Animations.Fire)
			table.insert(mouse.CurrentAnimations, fireTrack)
			fireTrack.KeyframeReached:connect(function(keyframeName)
				if keyframeName == "End" then
					fireTrack:Stop(0)
					fireTrack:Destroy()
					mouse.Ready = true
				elseif keyframeName == "Pump" then
					mouse:TriggerEffect({
						mouse.PumpSound
					})
				end
			end)
			fireTrack:Play(0)
			local rotY = (l__math_random__12() - 0.5) * mouse.ToolTable.Recoil / 2
			u9.NewRecoilTween(mouse.Camera, mouse.ToolTable.Recoil, rotY, 0.1, "outQuad")
			delay(0.1, function()
				u9.NewRecoilTween(mouse.Camera, -mouse.ToolTable.Recoil, -rotY, 0.2, "outQuad")
			end)
			local mousePos = l__mouse__4.Hit.p
			local humanoidHit = false
			local distance = (mouse.Barrel.Position - mousePos).Magnitude
			local originPos = (mouse.Torso.CFrame * CF(0, 1.5, 0)).p
			local hitTable = {}
			for i = 1, mouse.Multishot and 9 or 1 do
				local spread = mouse.ToolTable.Spread / 50 * distance
				local endPos = l__Vector3_new__13(mousePos.x + (RANDOM() * (spread * 2) - spread), mousePos.y + (RANDOM() * (spread * 2) - spread), mousePos.z + (RANDOM() * (spread * 2) - spread))
				local hit, position, sur, mat = mouse:Raycast(originPos, endPos, mouse:GetIgnoreList(mouse.Character), mouse.ToolTable.Range)
				local hum, vehicle
				if hit then
					hum = hit.Parent:FindFirstChild("Humanoid")
					if l__CollectionService__14:HasTag(hit, GLASS_TAG) then
						table.insert(hitTable, {
							hit,
							position,
							sur,
							mat
						})
						hit, position, sur, mat = mouse:Raycast(originPos, endPos, mouse:GetIgnoreList(mouse.Character, hit), mouse.ToolTable.Range)
					elseif not hum then
						vehicle = hit.Parent:IsDescendantOf(l__Vehicles__15)
					end
				end
				table.insert(hitTable, {
					hit,
					position,
					sur,
					mat
				})
				if not (not hit) and not hum and not l__CollectionService__14:HasTag(hit, GLASS_TAG) or vehicle then
					ToolHandler.SpawnToolFire(hit, position, sur, mat, mouse.Multishot)
				end
			end
			coroutine.wrap(function()
				if #hitTable > 0 then
					local v34
					pcall(function()
						v34 = mouse.FireRemote:Invoke(mouse.Tool, mouse.Torso.Position, hitTable);
					end)
					if not v34 then
						return;
					end;
					if v34 then
						local v36 = tick()
						mouse.LastMarker = v36;
						mouse.GunCursor = u3.GunMarker;
						mouse.AimCursor = u3.AimMarker;
						mouse:UpdateCursor();
						local v37 = Instance.new("Sound");
						v37.SoundId = u3.HitMarkerSound;
						v37.Volume = 0.5;
						v37.Parent = mouse.ParentGui;
						v37:Play();
						delay(0.5, function()
							if v36 == mouse.LastMarker then
								mouse.GunCursor = u3.GunCursor;
								mouse.AimCursor = u3.AimCursor;
								mouse:UpdateCursor();
							end;
							v37:Destroy();
						end)
					end	
					mouse.CombatRemote:Fire(player)
				end
			end)()
		end

	elseif mouse.Ready and not mouse.AmmoReady then
		mouse.Ready = false
		mouse:TriggerEffect({
			mouse.EmptySound
		})
		wait(0.1)
		mouse.Ready = true
	end
end
local u17 = require(l__ReplicatedStorage__3.Databases.Items);
function v2.GetReadyRounds(p22)
	local v41 = 0;
	for v42, v43 in pairs((u2.GetInventory())) do
		local v44 = u17[v43[2]];
		if v44.Type == "Magazine" and v44.Rounds == p22.ToolTable.Rounds and v43[3].R > 0 and (not p22.Mag or v43[1] ~= p22.Mag[1]) then
			v41 = v41 + v43[3].R;
		end;
	end;
	return v41;
end;
local function u18(p23, p24)
	return p24[3].R < p23[3].R;
end;
local function u19(p25, p26)
	return p25[3].R < p26[3].R;
end;
function v2.GetMags(p27)
	local v45 = {};
	for v46, v47 in pairs((u2.GetInventory())) do
		local v48 = u17[v47[2]];
		if v48.Type == "Magazine" and v48.Rounds == p27.ToolTable.Rounds and v47[3].R > 0 and (not p27.Mag or v47[1] ~= p27.Mag[1]) then
			table.insert(v45, v47);
		end;
	end;
	table.sort(v45, p27.ToolTable.Magazine and u18 or u19);
	return v45;
end;
function v2.Reload(p28)
	if p28.Ready then
		if p28.MagSize and p28.MagSize <= p28.Rounds then
			return;
		end;
		local v49 = p28:GetMags();
		if #v49 <= 0 then
			return;
		end;
		if p28.Mag and v49[1][3].R <= p28.Rounds then
			return;
		end;
		p28.Ready = false;
		p28.Reloading = true;
		p28:Aim(false);
		p28.FireFlag = false;
		local u20 = nil;
		local u21 = false;
		u20 = p28.Fired:Connect(function()
			u20:Disconnect();
			p28.FireFlag = true;
			u21 = true;
		end);
		local v50 = p28:GetReadyRounds();
		local v51 = nil;
		if not p28.ToolTable.Magazine then
			if v50 < p28.MagSize - p28.Rounds then
				v51 = v50 + p28.Rounds;
			else
				v51 = p28.Rounds + (p28.MagSize - p28.Rounds);
			end;
		end;
		if p28.ToolTable.Magazine then
			p28:TriggerEffect({ p28.ReloadSound });
		end;
		local u22 = p28.Rounds;
		local u23 = nil;
		local function u24()
			u22 = u22 + 1;
			local v52 = p28:MakeTrack(p28.Animations.Reload);
			table.insert(p28.CurrentAnimations, v52);
			v52:Play();
			v52.KeyframeReached:Connect(function(p29)
				if p28.FireFlag or u21 then
					v52:Stop();
					v52:Destroy();
					p28.Reloading = false;
					return;
				end;
				if p29 == "ReloadEnd" and not p28.ToolTable.Magazine then
					p28:TriggerEffect({ p28.ReloadSound });
				end;
				if p29 == "ReloadEnd" and u22 ~= v51 or p29 == "End" then
					v52:Stop();
					v52:Destroy();
					u23(u22);
				end;
			end);
		end;
		u23 = function(p30)
			if p28.ToolTable.Magazine then
				p28.Mag = v49[1];
				p28.Rounds = v49[1][3].R;
				p28.ReloadRemote:Fire(p28.Tool.Name, v49[1][1]);
			else
				for v53 = 1, #v49 do
					if v49[v53][3].R > 0 then
						p28.Rounds = p28.Rounds + 1;
						u2.EditAttributes(v49[v53][1], true, {
							R = v49[v53][3].R - 1
						});
						p28.ReloadRemote:Fire(p28.Tool.Name, v49[v53][1]);
						break;
					end;
				end;
			end;
			p28:UpdateGui();
			p28.AmmoReady = true;
			if not p28.ToolTable.Magazine and p30 ~= v51 then
				u24();
				return;
			end;
			u20:Disconnect();
			p28.Ready = true;
			p28.Reloading = false;
		end;
		u24();
	end;
end;
return v2;


starterplayerscripts.coreclient.toolhandler.flashlight
-- Decompiled with the Synapse X Luau decompiler.

local v1 = require(script.Parent.ToolInterface);
local v2 = {};
v2.__index = v2;
setmetatable(v2, v1);
local l__Debris__3 = game:GetService("Debris");
local l__UserInputService__4 = game:GetService("UserInputService");
local l__ReplicatedStorage__5 = game:GetService("ReplicatedStorage");
local l__RunService__6 = game:GetService("RunService");
local v7 = require(script.Parent);
local v10 = nil;
local v11 = nil;
local v12 = {};
local v13 = nil;
local v14 = nil;
local l__LocalPlayer__8 = game:GetService("Players").LocalPlayer;
function v2.new(p1, p2, p3, p4)
	local v9 = v1.new(p1, p2, p3, p4);
	setmetatable(v9, v2);
	v9.Activated = false;
	v9.Debounce = false;
	v9.LightPart = p1:WaitForChild("LightPart");
	v9.Light = v9.LightPart:WaitForChild("FlashlightLight");
	return v9;
end;
local u1 = require(script.Parent.Parent.KeyBinder);
function v2.OnEquip(p5)
	if p5.Activated then
		v10 = "Off";
	else
		v10 = "On";
	end;
	p5.FlashKey = u1.KeyAction.new("FlashlightToggle", "Flashlight " .. v10, { Enum.KeyCode.E }, function(p6)
		if p6.UserInputState == Enum.UserInputState.End then
			p5:ToggleLight();
		end;
	end);
end;
function v2.OnUnequip(p7)
	if p7.FlashKey then
		p7.FlashKey:Remove();
		p7.FlashKey = nil;
	end;
end;
local u2 = require(script.Parent.Parent.RemoteHandler).Event.new("Flashlight");
function v2.ToggleLight(p8)
	if not p8.Debounce then
		p8.Debounce = true;

		p8.Activated = not p8.Activated;
		p8.Light.Enabled = p8.Activated;
		if p8.Activated then
			v11 = 0;
		else
			v11 = 1;
		end;
		p8.LightPart.Transparency = v11;
		if p8.Activated then
			v13 = "On";
		else
			v13 = "Off";
		end;
		v12[1] = p8["Flashlight" .. v13 .. "Sound"];
		p8:TriggerEffect(v12);
		if p8.Activated then
			v14 = "Off";
		else
			v14 = "On";
		end;
		p8.FlashKey:Update("Flashlight " .. v14);
		u2:Fire(p8.Tool, p8.Activated);
		wait(0.5);
		p8.Debounce = false;
	end;
end;
return v2;

starterplayerscripts.coreclient.toolhandler.handcuffs
local ToolInterface = require(script.Parent.ToolInterface)
local Handcuffs = {}
Handcuffs.__index = Handcuffs
setmetatable(Handcuffs, ToolInterface)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ClientFunctions = require(script.Parent.Parent.ClientFunctions)
local InteractController = require(script.Parent.Parent.InteractController)
local MovementController = require(script.Parent.Parent.MovementControIIer)
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

starterplayerscripts.coreclient.toolhandler.melee
-- Decompiled with the Synapse X Luau decompiler.

local v1 = require(script.Parent.ToolInterface);
local v2 = {};
v2.__index = v2;
setmetatable(v2, v1);
local l__Debris__3 = game:GetService("Debris");
local l__ReplicatedStorage__4 = game:GetService("ReplicatedStorage");
local l__RunService__5 = game:GetService("RunService");
local v6 = require(script.Parent);
local l__LocalPlayer__7 = game:GetService("Players").LocalPlayer;
local u1 = require(script.Parent.Parent.RemoteHandler);
local Keybinder = require(script.Parent.Parent.KeyBinder)
local Components = require(script.Parent.Parent.Components)
local ClientFunctions = require(script.Parent.Parent.ClientFunctions)
local remote = u1.Event.new("Protest")
function v2.new(p1, p2, p3, p4)
	local v8 = v1.new(p1, p2, p3, p4);
	setmetatable(v8, v2);
	v8.Debounce = false;
	v8.HitPart = p1:WaitForChild("HitPart");
	v8.FireRemote = u1.Func.new("ToolExec");
	v8.CombatRemote = u1.Event.new("CombatExec");
	v8.Smash = not v8.ToolTable.NoSmash;
	return v8;
end;
local l__UserInputService__2 = game:GetService("UserInputService");
function v2.OnEquip(p5)
	if p5.Tool.Class.Value == "ProtestSign" then
		    p5.ReloadKey = Keybinder.KeyAction.new("Apply", "Apply", { Enum.KeyCode.L }, function(Key)
			if Key.UserInputState == Enum.UserInputState.End then
				ClientFunctions.MovementEnable(false)
				local window = Components.Window.new("Protest System")
				window:AddComponent(Components.TextLabel.new("Enter an text to put on your sign."))
				local field = Components.TextBox.new("Text")
				local enter = Components.Button.new("APPLY", true)
				local amount
				field.FocusLost:Connect(function()
					amount = field:GetText()
					return
				end)
				enter.MouseClick:Connect(function()
					remote:Fire(p5.Tool, amount)
					window:Close()
				end)
				window.OnHide:Connect(function()
					ClientFunctions.MovementEnable(true)
				end)
				window:AddComponent(field)
				window:AddComponent(enter)
				window:Show()
			end;
		end);
	end
	
	p5.MouseEvent = l__UserInputService__2.InputBegan:connect(function(p6, p7)
		if p6.UserInputType == Enum.UserInputType.MouseButton1 and not p7 then
			p5:Swing();
		end;
	end);
end;
function v2.OnUnequip(p8)
	if p8.MouseEvent then
		p8.MouseEvent:Disconnect();
		p8.MouseEvent = nil;
	end;
	if p8.ReloadKey then
		p8.ReloadKey:Remove();
		p8.ReloadKey = nil;
	end;
end;
local l__CollectionService__3 = game:GetService("CollectionService");
function v2.Swing(p9)
	pcall(function()
	if not p9.Debounce then
		p9.Debounce = true;
		p9:TriggerEffect({ p9.SwingSound });
		local v9 = p9:MakeTrack(p9.Animations.Swing);
		table.insert(p9.CurrentAnimations, v9);
		local u4 = true;
		v9.KeyframeReached:connect(function(p10)
			if p10 == "End" then
				v9:Stop(0);
				v9:Destroy();
				u4 = false;
			end;
		end);
		v9:Play(0);
		local u5 = false;
		local function u6(p11)
			if not u5 and u4 then
				u5 = true;
				local l__Humanoid__10 = p11.Parent:FindFirstChild("Humanoid");
				if not (not l__Humanoid__10) and l__Humanoid__10 ~= p9.Humanoid or p9.Smash and l__CollectionService__3:HasTag(p11, "Glass") and not l__CollectionService__3:HasTag(p11, "Ignore") then
					coroutine.wrap(function()
						p9.FireRemote:Invoke(p9.Tool, p9.Torso.Position, { { p11 } });
						p9.CombatRemote:Fire(l__LocalPlayer__7);
					end)();
					wait(0.15);
				end;
				u5 = false;
			end;
		end;
		local v11 = p9.HitPart.Touched:Connect(function(p12)
			u6(p12);
		end);
		for v12, v13 in pairs(p9.HitPart:GetTouchingParts()) do
			u6(v13);
		end;
		for v14, v15 in pairs(p9.HitPart:GetTouchingParts()) do
			if v15.Parent ~= p9.Tool then
				u6(v15);
			end;
		end;
		wait(0.5);
		v11:Disconnect();
		p9.Debounce = false;
		end;
	end)
end;
return v2;

starterplayerscripts.coreclient.toolhandler.misc
-- Decompiled with the Synapse X Luau decompiler.

local v1 = require(script.Parent.ToolInterface);
local v2 = {};
v2.__index = v2;
setmetatable(v2, v1);
local l__Debris__3 = game:GetService("Debris");
local l__ReplicatedStorage__4 = game:GetService("ReplicatedStorage");
local l__RunService__5 = game:GetService("RunService");
local l__CollectionService__6 = game:GetService("CollectionService");
local v7 = require(script.Parent.Parent.RemoteHandler);
local v8 = require(script.Parent);
local l__LocalPlayer__9 = game:GetService("Players").LocalPlayer;
function v2.new(p1, p2, p3, p4)
	local v10 = v1.new(p1, p2, p3, p4);
	setmetatable(v10, v2);
	v10.Debounce = false;
	return v10;
end;
local l__UserInputService__1 = game:GetService("UserInputService");
function v2.OnEquip(p5)
	if not p5.ItemTable.NoSwing then
		p5.MouseEvent = l__UserInputService__1.InputBegan:connect(function(p6, p7)
			if p6.UserInputType == Enum.UserInputType.MouseButton1 and not p7 then
				p5:Swing();
			end;
		end);
	end;
end;
function v2.OnUnequip(p8)
	if p8.MouseEvent then
		p8.MouseEvent:Disconnect();
		p8.MouseEvent = nil;
	end;
end;
function v2.Swing(p9)
	if not p9.Debounce then
		p9.Debounce = true;
		p9:TriggerEffect({ p9.SwingSound });
		local v11 = p9:MakeTrack(p9.Animations.Swing);
		table.insert(p9.CurrentAnimations, v11);
		local u2 = true;
		v11.KeyframeReached:connect(function(p10)
			if p10 == "End" then
				v11:Stop(0);
				v11:Destroy();
				u2 = false;
			end;
		end);
		v11:Play(0);
		wait(0.5);
		p9.Debounce = false;
	end;
end;
return v2;

starterplayerscripts.coreclient.toolhandler.ploppabletool
-- Decompiled with the Synapse X Luau decompiler.

local v1 = require(script.Parent.ToolInterface);
local v2 = {};
v2.__index = v2;
setmetatable(v2, v1);
local l__Debris__3 = game:GetService("Debris");
local l__UserInputService__4 = game:GetService("UserInputService");
local l__LocalPlayer__5 = game:GetService("Players").LocalPlayer;
local v6 = RaycastParams.new();
v6.FilterType = Enum.RaycastFilterType.Blacklist;
v6.IgnoreWater = true;
local l__CollectionService__1 = game:GetService("CollectionService");
local u2 = require(game:GetService("ReplicatedStorage").Databases.Ploppables);
function v2.new(p1, p2, p3, p4)
	local v7 = v1.new(p1, "PloppableTool", p3, p4);
	setmetatable(v7, v2);
	v7.PlopType = p2;
	v7.Properties = u2[v7.PlopType];
	v7.Name = v7.Properties.Name;
	v7.RotateDeg = -90;
	v7.RayClone = v7.Properties.Asset:Clone();
	v7.RayClone.PrimaryPart.Transparency = 1;
	for v8, v9 in pairs(v7.RayClone:GetChildren()) do
		if v9:IsA("BasePart") then
			v9.CanCollide = false;
		end;
	end;
	v7.Debounce = false;
	return v7;
end;
local l__RunService__3 = game:GetService("RunService");
local l__CFrame_new__4 = CFrame.new;
local l__Raycast__5 = workspace.Raycast;
local l__Vector3_new__6 = Vector3.new;
local function u7()
	v6.FilterDescendantsInstances = { workspace.InvisibleParts, workspace.Ploppables, l__CollectionService__1:GetTagged("Character") };
	return v6;
end;
local l__CFrame_Angles__8 = CFrame.Angles;
local l__math_rad__9 = math.rad;
function v2.OnEquip(p5)
	p5:UpdateButtons();
	p5.Heartbeat = l__RunService__3.Heartbeat:Connect(function()
		if not p5.Equipped then
			p5.RayClone.Parent = nil;
			return;
		end;
		local v10 = l__Raycast__5(workspace, (p5.Torso.CFrame * l__CFrame_new__4(0, 0, -5)).p, l__Vector3_new__6(0, -8, 0), u7());
		if not v10 or not v10.Instance then
			p5.RayClone.Parent = nil;
			return;
		end;
		local l__Instance__11 = v10.Instance;
		local l__Position__12 = v10.Position;
		p5.RayClone.Parent = workspace.InvisibleParts;
		local v13 = l__CFrame_new__4(l__Position__12, l__Position__12 + p5.Torso.CFrame.lookVector);
		p5.RayClone:SetPrimaryPartCFrame(l__CFrame_new__4(l__Position__12, l__Position__12 + v10.Normal) * l__CFrame_Angles__8(l__math_rad__9(-90), 0, 0) * l__CFrame_new__4(0, -0.2, 0) * (v13 - v13.p) * l__CFrame_Angles__8(0, l__math_rad__9(p5.RotateDeg), 0));
	end);
end;
function v2.OnUnequip(p6)
	if p6.Heartbeat then
		p6.Heartbeat:Disconnect();
		p6.Heartbeat = nil;
	end;
	p6.RayClone.Parent = nil;
	p6:UpdateButtons();
end;
local u10 = require(script.Parent.Parent.RemoteHandler).Event.new("SetPlop");
function v2.Plop(p7, p8)
	if p7.RayClone.Parent and not p7.Debounce then
		u10:Fire(p7.PlopType, p7.RayClone.PrimaryPart.CFrame);
		p7.Debounce = true;
		delay(0.25, function()
			p7.Debounce = false;
			p7:UpdateButtons();
		end);
		p7:UpdateButtons();
	end;
end;
local v14
function v2.Rotate(p9, p10)
	if p10 then
		v14 = -30;
	else
		v14 = 30;
	end;
	p9.RotateDeg = p9.RotateDeg + v14;
end;
local u11 = require(script.Parent.Parent.KeyBinder);
function v2.UpdateButtons(p11)
	if p11.Equipped and not p11.Debounce then
		if not p11.PlopKey and not p11.LeftKey then
			p11.PlopKey = u11.KeyAction.new("Plop", "Plop " .. p11.Name, { Enum.KeyCode.R }, function(p12)
				if p12.UserInputState == Enum.UserInputState.End then
					p11:Plop();
				end;
			end);
			local function u12(p13, p14)
				if p13.UserInputState == Enum.UserInputState.End then
					p11:Rotate(p14);
				end;
			end;
			p11.LeftKey = u11.KeyAction.new("LeftRotate", "Rotate Left", { Enum.KeyCode.Q }, function(p15)
				u12(p15, false);
			end);
			p11.RightKey = u11.KeyAction.new("RightRotate", "Rotate Right", { Enum.KeyCode.E }, function(p16)
				u12(p16, true);
			end);
			return;
		end;
	else
		if p11.PlopKey then
			p11.PlopKey:Remove();
			p11.PlopKey = nil;
		end;
		if p11.LeftKey then
			p11.LeftKey:Remove();
			p11.LeftKey = nil;
		end;
		if p11.RightKey then
			p11.RightKey:Remove();
			p11.RightKey = nil;
		end;
	end;
end;
return v2;

starterplayerscripts.coreclient.toolhandler.radargun
-- Decompiled with the Synapse X Luau decompiler.

local v1 = require(script.Parent.ToolInterface);
local v2 = {};
v2.__index = v2;
setmetatable(v2, v1);
local l__Debris__3 = game:GetService("Debris");
local l__UserInputService__4 = game:GetService("UserInputService");
local l__ReplicatedStorage__5 = game:GetService("ReplicatedStorage");
local v6 = require(script.Parent.Parent.RemoteHandler);
local v7 = require(script.Parent);
local l__LocalPlayer__8 = game:GetService("Players").LocalPlayer;
local v9 = RaycastParams.new();
v9.FilterType = Enum.RaycastFilterType.Blacklist;
v9.IgnoreWater = true;
local l__CollectionService__1 = game:GetService("CollectionService");
local l__Raycast__2 = workspace.Raycast;
local function u3(p1, p2)
	local v10 = { workspace.InvisibleParts, workspace.Ploppables, p1, l__CollectionService__1:GetTagged("Ignore"), l__CollectionService__1:GetTagged("Glass") };
	if p2.SeatPart and p2.SeatPart.ClassName == "VehicleSeat" then
		table.insert(v10, p2.SeatPart.Parent.Parent);
	end;
	v9.FilterDescendantsInstances = v10;
	return v9;
end;
function v2.new(p3, p4, p5, p6)
	local v11 = v1.new(p3, p4, p5, p6);
	setmetatable(v11, v2);
	v11.ParentGui = p6;
	v11.Gui = l__ReplicatedStorage__5.UI.RadarFrame:Clone();
	v11.Barrel = v11.Tool:WaitForChild("Barrel");
	v11.Speed = 0;
	v11.TargetSpeed = 30;
	v11.Debounce = false;
	v11.LastSound = tick()
	v11.LastMove = tick()
	v11:UpdateGui();
	return v11;
end;
local l__RunService__4 = game:GetService("RunService");
local function u5(p7, p8, p9, p10, p11)
	return l__Raycast__2(workspace, p9, (p10 - p9).unit * p11, u3(p7, p8));
end;
local l__mouse__6 = l__LocalPlayer__8:GetMouse();
function v2.OnEquip(p12)
	p12:UpdateButtons();
	p12.Heartbeat = l__RunService__4.Heartbeat:Connect(function()
		if p12.Equipped then
			local v12 = u5(l__LocalPlayer__8.Character, p12.Humanoid, p12.Barrel.Position, l__mouse__6.Hit.p, 600);
			local v13 = v12 and v12.Instance;
			local v14 = (v13 and v13.Velocity.Magnitude or 0) * 0.681818;
			p12.Speed = v14 > 0 and v14 or p12.Speed;
			p12.LastMove = v14 > 0 and tick() or p12.LastMove;
			if p12.TargetSpeed <= v14 and tick() - p12.LastSound >= 1 then
				p12.LastSound = tick()
				p12:TriggerEffect({ p12.BeepSound });
			end;
			if tick() - p12.LastMove >= 5 then
				p12.Speed = 0;
			end;
			p12:UpdateGui();
		end;
	end);
end;
function v2.OnUnequip(p13)
	if p13.Heartbeat then
		p13.Heartbeat:Disconnect();
		p13.Heartbeat = nil;
	end;
	p13:UpdateButtons();
end;
local u7 = require(l__ReplicatedStorage__5.Databases.Assets);
function v2.UpdateGui(p14)
	local l__SpeLabel__15 = p14.Gui:WaitForChild("SpeLabel");
	p14.Gui:WaitForChild("TarLabel").Text = p14.TargetSpeed;
	l__SpeLabel__15.Text = math.clamp(math.floor(p14.Speed), 0, 300);
	if not (p14.TargetSpeed <= p14.Speed) then
		l__SpeLabel__15.TextColor3 = Color3.new(1, 1, 1);
		return;
	end;
	l__SpeLabel__15.TextColor3 = u7.Color.Red;
end;
local u8 = require(script.Parent.Parent.KeyBinder);
function v2.UpdateButtons(p15)
	local v16 = nil;
	if p15.Equipped and not p15.Debounce then
		local function u9(p16, p17)
			if p16.UserInputState == Enum.UserInputState.End then
				if p17 then
				    v16 = 5;
				else
					v16 = -5;
				end;
				p15.TargetSpeed = math.clamp(p15.TargetSpeed + v16, 10, 200);
			end;
		end;
		p15.IncKey = u8.KeyAction.new("IncSpeed", "Increase Speed", { Enum.KeyCode.E }, function(p18)
			u9(p18, true);
		end);
		p15.DecKey = u8.KeyAction.new("DecSpeed", "Decrease Speed", { Enum.KeyCode.Q }, function(p19)
			u9(p19);
		end);
		return;
	end;
	if p15.IncKey then
		p15.IncKey:Remove();
		p15.IncKey = nil;
	end;
	if p15.DecKey then
		p15.DecKey:Remove();
		p15.DecKey = nil;
	end;
end;
return v2;

starterplayerscripts.coreclient.toolhandler.taser
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
local PoobRemote = RemoteHandler.Event.new("CombatExec");
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
	mouse.Icon = "rbxassetid://7027106724"
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
	pcall(function()
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
		elseif not self.ToolTable.Magazine then
			InventoryController.EditAttributes(self.Tool.Name, true, {
				R = self.Rounds
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
			local l__Position__11 = self.Torso.Position;
			local v12 = l__Position__11 + V3(0, 1.5, 0);
			local hit, position, sur = self:Raycast(originPos, endPos, self:GetIgnoreList(self.Character), self.ToolTable.Range)
			local hum
			if hit then
				hum = hit.Parent:FindFirstChild("Humanoid")
			end
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
			PoobRemote:Fire(player);
			self.FireRemote:Invoke(self.Tool, v12, {
				{
					hit,
					position,
					sur
				}
			})
		end
	elseif self.Ready and not self.AmmoReady then
		self.Ready = false
		self:TriggerEffect({
			self.EmptySound
		})
		wait(0.1)
		self.Ready = true	
		end	
	end)
end
return Taser

starterplayerscripts.coreclient.toolhandler.toolinterface
--[[VARIABLE DEFINITION ANOMALY DETECTED, DECOMPILATION OUTPUT POTENTIALLY INCORRECT]]--
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local l__ReplicatedStorage__2 = game:GetService("ReplicatedStorage");
local u1 = require(l__ReplicatedStorage__2.Databases.Items);
local u2 = require(l__ReplicatedStorage__2.Databases.Tools);
local u3 = require(l__ReplicatedStorage__2.Databases.Assets);
local u4 = require(script.Parent.Parent.RemoteHandler);
local u5 = game:GetService("Players")
local l__SoundService__5 = game:GetService("SoundService");
local l__LocalPlayer__6 = game:GetService("Players").LocalPlayer;
local INSERT = table.insert
function v1.new(p1, p2, p3, p4)
	local v3 = {};
	local v4 = nil;
	setmetatable(v3, v1);
	v3.Id = p2;
	v3.Tool = p1;
	v3.Screen = p4;
	v3.ItemTable = p2 and u1[v3.Id];
	v3.ToolTable = p2 and u2[v3.Id] or nil;
	if p2 then
		v4 = v3.ItemTable and u3.Tools[v3.ItemTable.Asset] or nil;
	else
		v4 = nil;
	end;
	v3.AssetTable = v4;
	v3.LastEquip = tick();
	v3.Name = v3.ItemTable and v3.ItemTable.Name;
	v3.GripR = p3.Parent:WaitForChild("ToolGrip"):WaitForChild("Tool");
	v3.Effects = l__ReplicatedStorage__2.Effects;
	v3.EffectRemote = u4.Event.new("ToolEffect");
	v3.AbilityRemote = u4.Event.new("ToolAbility");
	v3.AbilityKeys = {};
	if v3.AssetTable then
		if v3.AssetTable.Sound then
			for i, v in pairs(v3.AssetTable.Sound) do
				local sound = Instance.new("Sound")
				sound.Looped = false
				sound.SoundId = v[1]
				sound.SoundGroup = v[3] and l__SoundService__5[v[3]]
				sound.Parent = v3.Tool:WaitForChild(v[2])
				sound.Name = i
				if v[4] then
					sound.MinDistance = v[4][1]
					sound.MaxDistance = v[4][2]
				end
				v3[i .. "Sound"] = sound
			end
		end
		if v3.AssetTable.Light then
			local v11 = v3.AssetTable.Light[2]:Clone();
			v11.Parent = v3.Tool:WaitForChild(v3.AssetTable.Light[1]);
			v3.Light = v11;
		end;
		if v3.AssetTable.Smoke then
			local v12 = v3.AssetTable.Smoke[2]:Clone();
			v12.Parent = v3.Tool:WaitForChild(v3.AssetTable.Smoke[1]);
			v3.Smoke = v12;
		end;
	end;
	v3.Character = l__LocalPlayer__6.Character;
	v3.Humanoid = p3;
	v3.Torso = p3 and p3.Torso;
	local v13 = p3;
	local v14 = nil;
	if v13 then
		if p3.RigType == Enum.HumanoidRigType.R6 then
			v13 = "R6";
		else
			v13 = "R15";
		end;
	end;
	v3.RigType = v13;
	if v3.AssetTable and v3.AssetTable.Animation then
		v3.Animations = v3.AssetTable.Animation[v3.RigType];
	end;
	v3.Root = v3.Tool and v3.Tool:FindFirstChild("Root");
	if v3.RigType == "R6" then
		v14 = "Right Arm";
	else
		v14 = "RightHand";
	end;
	v3.ArmAttach = v14;
	v3.AttachCF = v3.RigType == "R6" and CFrame.new(0, -1, -0.75) or CFrame.new(0, -0.15, -0.75);
	v3.Equipped = false;
	v3.CurrentAnimations = {};
	return v3;
end;
local u7 = require(script.Parent.Parent.AnimationController);
local u8 = require(script.Parent.Parent.KeyBinder);
function v1.Equip(p5)
	p5.Tool.Parent = l__LocalPlayer__6.Character;
	local v15 = tick();
	p5.LastEquip = v15;
	if p5.Tool and p5.Tool.Parent and p5.Character and p5.Character:FindFirstChild(p5.ArmAttach) then
		p5.Equipped = true;
		if p5.Id ~= "PloppableTool" then
			local v16 = Instance.new("Motor6D");
			local v17 = nil;
			v16.Name = "ToolGrip";
			v16.Part0 = p5.Character[p5.ArmAttach];
			v16.Part1 = p5.Root;
			v16.C0 = p5.AttachCF * CFrame.Angles(math.rad(-90), 0, 0);
			v16.Parent = p5.Character[p5.ArmAttach];
			p5.ToolGrip = v16;
			if p5.ItemTable then
				v17 = not p5.ItemTable.NoDelay and 0.5;
			else
				v17 = 0.5;
			end;
			table.insert(p5.CurrentAnimations, u7.new(p5.Humanoid, p5.Animations.Hold, v17));
			p5.GripR:FireServer(p5.Tool, true);
		end;
		if p5.Gui and p5.ParentGui then
			p5.Gui.Parent = p5.ParentGui;
		end;
		local function v18()
			if p5.ToolTable and p5.ToolTable.Abilities then
				for v19, v20 in pairs(p5.ToolTable.Abilities) do
					if v20.Type == "toggle" then
						local u9 = false;
						p5.AbilityKeys[v19] = u8.KeyAction.new(v19, v20.Label, { v20.Key }, function(p6)
							if p6.UserInputState == Enum.UserInputState.Begin and not u9 then
								u9 = true;
								p5.AbilityRemote:Fire(v19, p5.Tool);
								v20.Function(p5.Tool, p5);
								if v20.Debounce then
									wait(v20.Debounce);
								end;
								u9 = false;
							end;
						end);
					end;
				end;
			end;
		end;
		if p5.ItemTable and p5.ItemTable.NoDelay then
			p5:OnEquip();
			v18();
		else
			delay(0.5, function()
				if v15 == p5.LastEquip then
					p5:OnEquip();
					v18();
				end;
			end);
		end;
		return true;
	end;
end;
function v1.Unequip(p7)
	p7.Tool.Parent = l__LocalPlayer__6.Backpack;
	p7.Equipped = false;
	p7.LastEquip = tick();
	if p7.ToolGrip then
		p7.ToolGrip:Destroy();
	end;
	for v21, v22 in pairs(p7.CurrentAnimations) do
		v22:Stop(0.1);
		if v22.ClassName ~= "CustAnimation" then
			v22:Destroy();
		end;
	end;
	p7.CurrentAnimations = {};
	p7.GripR:FireServer(p7.Tool, false);
	if p7.Gui then
		p7.Gui.Parent = nil;
	end;
	p7:OnUnequip();
	for v23, v24 in pairs(p7.AbilityKeys) do
		v24:Remove();
	end;
	p7.AbilityKeys = {};
end;
local v25 = RaycastParams.new();
v25.FilterType = Enum.RaycastFilterType.Blacklist;
v25.IgnoreWater = true;
local l__Raycast__10 = workspace.Raycast;
function v1.Raycast(p8, p9, p10, p11, p12)
	local l__unit__26 = (p10 - p9).unit;
	v25.FilterDescendantsInstances = p11;
	local v27 = l__Raycast__10(workspace, p9, l__unit__26 * p12, v25);
	if not v27 then
		return nil, p9 + l__unit__26 * p12;
	end;
	return v27.Instance, v27.Position, v27.Normal, v27.Material;
end;
local l__CollectionService__11 = game:GetService("CollectionService");
function v1:GetIgnoreList(char, otherItem)
	local def = l__CollectionService__11:GetTagged("Ignore")
	INSERT(def, char)
	INSERT(def, workspace.InvisibleParts)
	INSERT(def, otherItem)
	for _, p in pairs(u5:GetPlayers()) do
		if p ~= l__LocalPlayer__6 and p.Character then
			for _, v in pairs(p.Character:GetChildren()) do
				if v:IsA("Accessory") or v.Name == "HumanoidRootPart" or v.ClassName == "Configuration" then
					INSERT(def, v)
				end
			end
		end
	end
	return def
end
function v1.Remove(p16)
	if p16.Tool.Parent then
		p16.Tool.Parent = l__ReplicatedStorage__2;
		p16.Tool:Destroy();
	end;
	p16 = nil;
end;
function v1.TriggerEffect(p17, p18)
	local v28 = {};
	for v29, v30 in ipairs(p18) do
		if v30.ClassName == "Sound" then
			v30:Play();
		elseif v30:IsA("SpotLight") or v30:IsA("ParticleEmitter") then
			coroutine.wrap(function()
				v30.Enabled = true;
				wait(0.05);
				v30.Enabled = false;
			end)();
		end;
		table.insert(v28, { v30.Name, v30.ClassName });
	end;
	p17.EffectRemote:Fire(p17.Tool, v28);
end;
function v1.MakeTrack(p19, p20)
	local v31 = Instance.new("Animation");
	v31.AnimationId = p20;
	local v32 = p19.Humanoid:LoadAnimation(v31);
	v31:Destroy();
	return v32;
end;
return v1;

starterplayerscripts.coreclient.toolhandler.tweening
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
({}).number = function(p1, p2, p3, p4, p5)
	p1[p2] = p3 + (p4 - p3) * p5;
end;
local l__TweenService__1 = game:GetService("TweenService");
function v1.NewTween(p6, p7, p8, p9, p10, p11)
	p9 = p9 and 0.5;
	p10 = p10 or Enum.EasingStyle.Quad;
	p11 = p11 or Enum.EasingDirection.Out;
	l__TweenService__1:Create(p6, TweenInfo.new(p9, p10, p11), {
		[p7] = p8
	}):Play();
end;
local l__CFrame_Angles__2 = CFrame.Angles;
local l__math_rad__3 = math.rad;
local u4 = {};
local u5 = {};
local l__table_insert__6 = table.insert;
function v1.NewRecoilTween(p12, p13, p14, p15, p16)
	local v2 = {
		Object = p12, 
		Property = "CFrame", 
		EasingStyle = p16, 
		Duration = p15, 
		Start = tick(), 
		NoEndFix = true
	};
	local u7 = 0;
	local u8 = 0;
	function v2.TweenFunction(p17)
		local v3 = p13 * p17;
		local v4 = p14 * p17;
		p12.CFrame = p12.CFrame * l__CFrame_Angles__2(l__math_rad__3(v3 - u7), l__math_rad__3(v4 - u8), 0);
		u7 = v3;
		u8 = v4;
	end;
	if not u4[p12] then
		u4[p12] = {};
	end;
	u4[p12].CFrame = v2;
	l__table_insert__6(u5, v2);
	v1.RunTasks();
end;
function v1.NewProgTween(p18, p19, p20, p21, p22)
	local u9 = {};
	local v5, v6 = pcall(function()
		u9.Initial = p18[p19];
	end);
	if not v5 then
		error(v6);
		return;
	end;
	u9.Object = p18;
	u9.Property = p19;
	u9.EasingStyle = p22;
	u9.Duration = p21;
	u9.End = p20;
	u9.Start = tick();
	u9.NoEnd = true;
	function u9.TweenFunction(p23)
		p18[p19] = p18[p19]:lerp(p20, p23);
	end;
	if not u4[p18] then
		u4[p18] = {};
	end;
	u4[p18][p19] = u9;
	l__table_insert__6(u5, u9);
	v1.RunTasks();
end;
local u10 = nil;
local u11 = nil;
local l__RunService__12 = game:GetService("RunService");
local u13 = require(game:GetService("ReplicatedStorage").Databases.EasingStyles);
function v1.RunTasks()
	if not u10 then
		u10 = true;
		u11 = l__RunService__12.Heartbeat:Connect(function()
			if #u5 == 0 then
				v1.StopTasks();
				return;
			end;
			local v7 = tick();
			local v8 = #u5;
			for v9 = 1, v8 do
				local v10 = u5[v9];
				if v10 and u4[v10.Object] and u4[v10.Object][v10.Property] == v10 then
					if v10.Object and v10.Object.Parent then
						local v11 = v7 - v10.Start;
						if v11 < v10.Duration then
							v10.TweenFunction(u13[v10.EasingStyle](v11, 0, 1, v10.Duration));
						else
							if not v10.NoEndFix then
								v10.Object[v10.Property] = v10.End;
							end;
							u4[v10.Object] = nil;
							u5[v9] = nil;
						end;
					else
						u5[v9] = nil;
					end;
				else
					u5[v9] = nil;
				end;
			end;
			local v12 = 0;
			for v13 = 1, v8 do
				if u5[v13] ~= nil then
					v12 = v12 + 1;
					u5[v12] = u5[v13];
				end;
			end;
			for v14 = v12 + 1, v8 do
				u5[v14] = nil;
			end;
		end);
	end;
end;
function v1.StopTasks()
	if u10 then
		u10 = false;
		u11:Disconnect();
	end;
end;
return v1;

starterplayerscripts.coreclient.vehiclecontroller
--[[VARIABLE DEFINITION ANOMALY DETECTED, DECOMPILATION OUTPUT POTENTIALLY INCORRECT]]--
-- Decompiled with the Synapse X Luau decompiler.

local l__CollectionService__1 = game:GetService("CollectionService");
local l__UserInputService__2 = game:GetService("UserInputService");
local l__ReplicatedStorage__3 = game:GetService("ReplicatedStorage");
local l__RunService__4 = game:GetService("RunService");
local l__Debris__5 = game:GetService("Debris");
local l__HttpService__6 = game:GetService("HttpService");
local v7 = require(script.Parent.ClientFunctions);
local v8 = require(script.Parent.RemoteHandler);
local v9 = require(script.Parent.Verificator);
local v10 = require(script.Parent.MovementControIIer);
local v11 = require(script.Parent.KeyBinder);
local v12 = require(script.Parent.JusticeController);
local v13 = require(script.Parent.Minimap);
local v14 = require(script.Parent.Tweening);
local v15 = require(script:WaitForChild("Vehicle"));
local v16 = require(l__ReplicatedStorage__3.Databases.Assets);
local v17 = require(l__ReplicatedStorage__3.Databases.Vehicles);
local v18 = require(l__ReplicatedStorage__3.Databases.Constants);
local v19 = {
	[Enum.Material.Grass] = Color3.fromRGB(100, 69, 72), 
	[Enum.Material.Mud] = Color3.fromRGB(100, 69, 72), 
	[Enum.Material.Sand] = true, 
	[Enum.Material.Salt] = true, 
	[Enum.Material.Snow] = true, 
	[Enum.Material.Rock] = true, 
	[Enum.Material.Slate] = Color3.fromRGB(132, 132, 132), 
	[Enum.Material.Sandstone] = true, 
	[Enum.Material.LeafyGrass] = Color3.fromRGB(100, 69, 72), 
	[Enum.Material.Limestone] = true, 
	[Enum.Material.Ground] = Color3.fromRGB(100, 69, 72), 
	[Enum.Material.Basalt] = true
};
local l__LocalPlayer__20 = game:GetService("Players").LocalPlayer;
local v21 = v8.Event.new("VehicleEnter");
local v22 = v8.Event.new("VehicleControl");
local v23 = tick();
local l__Vehicles__24 = workspace.Vehicles;
local u1 = {};
v21.OnEvent:Connect(function()
	u1.LeaveSeat(nil, true);
end);
local v25 = RaycastParams.new();
v25.FilterType = Enum.RaycastFilterType.Blacklist;
v25.IgnoreWater = true;
local l__Raycast__2 = workspace.Raycast;
local u3 = {
	[3] = 2,
	10
};
local l__Effects__4 = l__ReplicatedStorage__3.Effects;
local u5 = {};
local l__CurrentCamera__6 = workspace.CurrentCamera;
local l__math_abs__7 = math.abs;
local l__math_clamp__8 = math.clamp;
local u9 = 0.2;
local l__CFrame_new__10 = CFrame.new;
local function u11(p1, p2, p3)
	v25.FilterDescendantsInstances = p3;
	return l__Raycast__2(workspace, p1, p2 - p1, v25);
end;
local l__ColorSequence_new__12 = ColorSequence.new;
local function u13(p4, p5, p6, p7, p8)
	if p5[p6] then
		p5[p6].Enabled = false;
		l__Debris__5:AddItem(p5[p6], u3[p6]);
		p5[p6] = nil;
	end;
	if not p8 then
		local v26 = nil;
		if p6 == 1 then
			v26 = l__Effects__4.Tyre:Clone();
			if p7 then
				v26.Color = p7;
			end;
			v26.Enabled = true;
			v26.Attachment0 = p4.Parent:WaitForChild("Trail1");
			v26.Attachment1 = p4.Parent:WaitForChild("Trail2");
			v26.Parent = p4;
		elseif p6 == 3 then
			v26 = l__Effects__4.TerrainSmoke:Clone();
			v26.Color = p7;
			v26.Enabled = true;
			v26.Parent = p4.Parent:WaitForChild("Smoke");
		end;
		p5[p6] = v26;
	end;
end;
coroutine.wrap(function()
	while true do 
		l__RunService__4.Heartbeat:wait()
		local v27 = tick();
		for v28, v29 in pairs(u5) do
			local v30, v31 = pcall(function()
				if v29.Active and (not v29.LongRange or v29.LongRange and v27 - v29.LongRange >= 2) then
					local l__Magnitude__32 = (l__CurrentCamera__6.CFrame.p - v29.RootPart.Position).Magnitude;
					if l__Magnitude__32 <= 3000 then
						v29.LongRange = nil;
						v29:SetInRange(true);
						local v33 = v29.RootPart.Velocity.Magnitude;
						if v33 <= 0 then
							v33 = 0.1;
						end;
						if v29.Activated then
							local v34 = l__math_clamp__8(v33 * 0.681818 / l__math_abs__7(v29.ClassTable.Gears[v29.CurrentGearVal.Value + 2]), 0.2, 1);
							local v35 = nil
							local v36 = nil
							local v37 = nil
							if v29.ClassTable.Electric then
								v35 = 0;
							else
								v35 = 0.3;
							end;
							if v29.GasTick then
								v36 = 0.3 + l__math_clamp__8((v27 - v29.GasTick) / 2, 0, 1) * (v29.CurrentGearVal.Value ~= 0 and v34 / 3 or 1);
							else
								if v29.ClassTable.Electric then
									v37 = 0;
								else
									v37 = v29.Sounds.Engine.PlaybackSpeed * 0.99;
								end;
								v36 = v37;
							end;
							if v29.CurrentGearVal.Value == 0 then
								u9 = 0.2;
							else
								u9 = 0.8;
							end;
							local v38 = l__math_clamp__8(v36, v35, 0.7);
							v29.Sounds.Engine.PlaybackSpeed = v29.Sounds.Engine.PlaybackSpeed + u9 * (v38 - v29.Sounds.Engine.PlaybackSpeed);
							v29.Sounds.Gravel.PlaybackSpeed = 0.6 + l__math_clamp__8(v33 / 150, 0, 1);
							v29.Sounds.Engine.Volume = v29.Sounds.Engine.Volume + u9 * (v38 - v29.Sounds.Engine.Volume);
							v29.Sounds.TyreNoise.Volume = l__math_clamp__8(v33 / 100, 0, 1);
						end;
						local v39 = l__math_abs__7(v29.RootPart.CFrame:pointToObjectSpace(v29.RootPart.Position + v29.RootPart.Velocity).Z);
						if (not v29.LastMotor or v29.LastMotor <= v27 - 0.2) and v29.WheelRad then
							v29.LastMotor = v27;
							local v40 = false;
							for v41, v42 in pairs(v29.Motors) do
								if v42.Attachment0 then
									local v43 = v42.Attachment0.Parent.CFrame * l__CFrame_new__10(-0.9, 0, 0);
									local v44 = u11(v43.p, (v43 * l__CFrame_new__10(0, -(v29.WheelRad + 1), 0)).p, { v29.Model, workspace.InvisibleParts });
									local v45 = v44 and v44.Instance;
									local v46 = v44 and v44.Material;
									local v47 = v29.Trails[v42];
									local v48
									if v45 and v19[v46] and v39 > 1 then
										if v46 ~= v47[4] then
											if typeof(v19[v46]) == "boolean" then
												v48 = workspace.Terrain:GetMaterialColor(v46) or v19[v46];
											else
												v48 = v19[v46];
											end;
											local v49 = l__ColorSequence_new__12(v48);
											u13(v42, v47, 1, v49);
											u13(v42, v47, 3, v49);
											v47[4] = v46;
										end;
										v40 = true;
									else
										v47[4] = nil;
										u13(v42, v47, 3, nil, true);
										if v45 and v29.BrakeBool.Value and v39 > 1 then
											u13(v42, v47, 1);
											if v47[2] then
												v47[2].Enabled = true;
											end;
										else
											u13(v42, v47, 1, nil, true);
											if v47[2] then
												v47[2].Enabled = false;
											end;
										end;
									end;
								end;
							end;
							local v50 
							if v40 then
								v50 = 1;
							else
								v50 = 0;
							end;
							v29.Sounds.Gravel.Volume = v50;
							return;
						end;
					elseif v29.InRange then
						v29:SetInRange(false);
						v29.Sounds.Engine.Volume = 0;
						v29.Sounds.TyreNoise.Volume = 0;
						v29.Sounds.Gravel.Volume = 0;
						for v51, v52 in pairs(v29.Motors) do
							local v53 = v29.Trails[v52];
							u13(v52, v53, 1, nil, true);
							if v53[2] then
								v53[2].Enabled = false;
							end;
							u13(v52, v53, 3, nil, true);
							v53[4] = nil;
						end;
						return;
					else
						if l__Magnitude__32 >= 3500 then
							v29.LongRange = v27;
							return;
						end;
						v29.LongRange = nil;
					end;
				end;
			end);
			if not v30 then
				warn(v31);
			end;
		end;	
	end;
end)();
local u14 = nil;
local u15 = nil;
local function u16(p9)
	if not u5[p9] then
		local v54 = v15.new(p9);
		if not v54 then
			return;
		end;
		u5[p9] = v54;
		if v54.Player == l__LocalPlayer__20 then
			u14 = p9;
			u15 = v54.RootPart;
		end;
	end;
end;
l__CollectionService__1:GetInstanceAddedSignal("VehicleSeat"):Connect(function(p10)
	coroutine.wrap(function()
		u16(p10.Parent.Parent);
	end)()
end);
for v55, v56 in ipairs(l__CollectionService__1:GetTagged("VehicleSeat")) do
	coroutine.wrap(function()
		u16(v56.Parent.Parent);
	end)();
end;
local function u17(p11)
	for v57, v58 in pairs(u5) do
		if v58.Seat == p11 then
			if v58.Player == l__LocalPlayer__20 then
				u14 = nil;
				u15 = nil;
			end;
			u5[v57]:Remove();
			u5[v57] = nil;
			return;
		end;
	end;
end;
l__CollectionService__1:GetInstanceRemovedSignal("VehicleSeat"):Connect(function(p12)
	coroutine.wrap(function()
		u17(p12);
	end)()
end);
local function u18(p13, p14, p15, p16)
	v25.FilterDescendantsInstances = p15;
	return l__Raycast__2(workspace, p13, (p14 - p13).unit * p16, v25);
end;
local u19 = nil;
local u20 = nil;
local u21 = false;
local u22 = v23;
local u23 = nil;
local u24 = {};
local u25 = {};
local u26 = nil;
local u27 = false;
function u1.InitHumanoid(p17, p18)
	u1.RemoveControls();
	u19 = p17;
	if not u20 then
		u20 = Instance.new("ScreenGui");
		u20.Name = "Vehicle";
		u20.ResetOnSpawn = false;
		u20.Parent = p18;
	end;
	local u28 = false;
	u19.Seated:Connect(function(p19, p20)

		if p19 then
			local v70
			local v59 = nil;
			local v60 = nil;
			local v61 = nil;
			local v62 = nil;
			local v63 = nil;
			local v64 = nil;
			local v65 = nil;
			local v66 = nil;
			local v67 = nil;
			local v68 = nil;
			local v69 = nil;
			if not p20 then
				if u19.SeatPart then
					p20 = u19.SeatPart;
					v65 = "VehicleSeat";
					v60 = "IsA";
					v59 = p20;
					v64 = v59;
					v61 = p20;
					v62 = v60;
					v63 = v61[v62];
					v66 = v63;
					v67 = v64;
					v68 = v65;
					v70 = v66(v67, v68);
					v69 = v70;
					if not v69 then
						return;
					else
						u21 = p20;
						u22 = tick();
						u28 = u19:GetStateEnabled(Enum.HumanoidStateType.Jumping);
						u19:SetStateEnabled(Enum.HumanoidStateType.Jumping, false);
						u1.SetupControls(p20);
						return;
					end;
				else
					return;
				end;
			else
				v65 = "VehicleSeat";
				v60 = "IsA";
				v59 = p20;
				v64 = v59;
				v61 = p20;
				v62 = v60;
				v63 = v61[v62];
				v66 = v63;
				v67 = v64;
				v68 = v65;
				v70 = v66(v67, v68);
				v69 = v70;
				if not v69 then
					return;
				else
					u21 = p20;
					u22 = tick();
					u28 = u19:GetStateEnabled(Enum.HumanoidStateType.Jumping);
					u19:SetStateEnabled(Enum.HumanoidStateType.Jumping, false);
					u1.SetupControls(p20);
					return;
				end;
			end;
		end;
		if not p19 and u21 then
			if u14 and u21:IsDescendantOf(u14) then
				v13.ShowMarker(u15, true);
			end;
			v13.SetLookPart();
			v13.SetZoom(1);
			if u23 then
				local l__HumanoidRootPart__71 = u19.Parent:FindFirstChild("HumanoidRootPart");
				if l__HumanoidRootPart__71 then
					l__HumanoidRootPart__71.CFrame = u21.Parent.RootPart.CFrame * u23.CFrame * CFrame.new(2.5, 1, 0) * CFrame.Angles(0, -math.pi / 2, 0);
				end;
			end;
			for v72, v73 in ipairs(u24) do
				v73:Disconnect();
			end;
			for v74, v75 in ipairs(u25) do
				v75:Remove();
			end;
			if u26 then
				u26:Destroy();
			end;
			u24 = {};
			u25 = {};
			u23 = nil;
			u21 = false;
			u22 = tick();
			u19:SetStateEnabled(Enum.HumanoidStateType.Jumping, u27 or u28);
			u27 = false;
			u1.RemoveControls();
		end;
	end);
end;
local l__InteractController__29 = script.Parent.InteractController;
function u1.SetupControls(p21)
	v10.DisableMouselock(true);
	if u14 and p21:IsDescendantOf(u14) then
		v13.ShowMarker(u15, false);
	end;
	v13.SetLookPart(p21.Parent.RootPart);
	v13.SetZoom(0.6);
	local u30 = nil;
	u30 = l__RunService__4.Heartbeat:Connect(function()
		if not u21 or u22 ~= u22 then
			u30:Disconnect();
			v14.NewTween(l__CurrentCamera__6, "FieldOfView", v18.WalkFOV, 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
			return;
		end;
		l__CurrentCamera__6.FieldOfView = l__CurrentCamera__6.FieldOfView + (v18.WalkFOV + math.min(u21.Velocity.Magnitude, 100) / 100 * 20 - l__CurrentCamera__6.FieldOfView) * 0.05;
	end);
	if v12.IsHandcuffed() then
		return;
	end;
	v10.DisableRunning(true);
	table.insert(u25, v11.KeyAction.new("ExitVehicle", "Exit Vehicle", { Enum.KeyCode.T }, u1.LeaveSeat));
	if p21.Name:sub(1, 6) == "Driver" then
		v7.DisableTools(true);
		u1.InitDriver(p21, u22);
	else
		require(l__InteractController__29).Stop();
	end;
end;
local l__VehicleFrame__31 = l__ReplicatedStorage__3.UI.VehicleFrame;
local function u32(p22, p23, p24)
	if not p23 then
		p22.ImageColor3 = Color3.fromRGB(255, 255, 255);
		return;
	end;
	p22.ImageColor3 = p24 and v16.Color.Green or v16.Color.Red;
end;
local function u33(p25, p26, p27, p28, p29, p30, p31)
	local v76 = p25.Gears[p26 + 2];
	for v77, v78 in pairs(p27) do
		v78.ActuatorType = Enum.ActuatorType.Motor;
		if p26 ~= 0 and p29 ~= 0 then
			if p29 > 0 and p31 > 0 then
				v78.MotorMaxTorque = p25.Gears[3] / math.abs(v76) * p25.Torque / #p27;
				v78.AngularVelocity = v76 / p30 / 0.681818;
				v78.MotorMaxAcceleration = p29 * p25.AcceIeration;
			elseif p29 < 0 then
				v78.AngularVelocity = 0;
				v78.MotorMaxAcceleration = -p29 * p25.BrakeAcceIeration;
				v78.MotorMaxTorque = 230000;
			end;
		else
			v78.AngularVelocity = 0;
			v78.MotorMaxAcceleration = 3;
			v78.MotorMaxTorque = 1000;
		end;
	end;
	for v79, v80 in pairs(p28) do
		v80.ActuatorType = Enum.ActuatorType.Motor;
		v80.AngularVelocity = 0;
		if p29 < 0 then
			v80.MotorMaxAcceleration = -p29 * p25.BrakeAcceIeration;
			v80.MotorMaxTorque = 50000;
		else
			v80.MotorMaxAcceleration = 3;
			v80.MotorMaxTorque = 500;
		end;
	end;
end;
local function u34(p32, p33, p34, p35)
	local v81 = math.abs(p35.Velocity.Magnitude * 0.681818 / (p32.Gears[#p32.Gears] + 5) - 1);
	for v82, v83 in pairs(p33) do
		v83.AngularActuatorType = Enum.ActuatorType.Servo;
		v83.TargetAngle = p34 * p32.Steering.TargetAngle;
		v83.ServoMaxTorque = p32.Steering.MaxTorque;
		v83.AngularSpeed = p34 == 0 and p32.Steering.AngularSpeed * 4 or math.max(1, p32.Steering.AngularSpeed * v81);
	end;
end;
local function u35(p36, p37, p38, p39, p40)
	(function(p41, p42)
		for v84, v85 in pairs(p41) do
			if p40 then
				if p37 == "AWD" then
					if v85.Parent.Parent.Name:sub(1, 1) == "R" or p37 ~= "AWD" then
						v85.ActuatorType = Enum.ActuatorType.Servo;
						v85.AngularSpeed = 5;
						v85.ServoMaxTorque = 500000;
						v85.TargetAngle = v85.CurrentAngle;
						v85.LimitsEnabled = true;
						v85.UpperAngle = 0;
						v85.LowerAngle = 0;
					else
						v85.ActuatorType = Enum.ActuatorType.Motor;
						v85.AngularVelocity = 0;
						v85.MotorMaxAcceleration = 2 * p36.BrakeAcceIeration;
						v85.MotorMaxTorque = p36.Torque;
					end;
				elseif p37 ~= "AWD" then
					v85.ActuatorType = Enum.ActuatorType.Servo;
					v85.AngularSpeed = 5;
					v85.ServoMaxTorque = 500000;
					v85.TargetAngle = v85.CurrentAngle;
					v85.LimitsEnabled = true;
					v85.UpperAngle = 0;
					v85.LowerAngle = 0;
				else
					v85.ActuatorType = Enum.ActuatorType.Motor;
					v85.AngularVelocity = 0;
					v85.MotorMaxAcceleration = 2 * p36.BrakeAcceIeration;
					v85.MotorMaxTorque = p36.Torque;
				end;
			else
				v85.LimitsEnabled = false;
				v85.ActuatorType = Enum.ActuatorType.None;
			end;
		end;
		local v86, v87, v88 = pairs(p42);
		local v89 = nil;
		local v90 = nil;
		v90, v89 = v86(v87, v88);
		if not v90 then
			return;
		end;
		v88 = v90;
		if p40 then
			v89.ActuatorType = Enum.ActuatorType.Motor;
			v89.AngularVelocity = 0;
			v89.MotorMaxAcceleration = 2 * p36.BrakeAcceIeration;
			v89.MotorMaxTorque = p36.Torque;
		else
			v89.ActuatorType = Enum.ActuatorType.None;
		end;		
	end)(p38, p39);
end;
function u1.InitDriver(p43, p44)
	local v91 = u5[p43.Parent.Parent];
	local v92 = v17[v91.Class];
	local v93 = v16.Vehicles[v92.Asset];
	local l__Value__94 = v91.BrakeBool.Value;
	local l__Value__95 = v91.LightBool.Value;
	local l__Health__96 = v91.Health;
	local l__Locked__97 = v91.Locked;
	local v98 = {};
	local v99 = {};
	local l__Parent__36 = p43.Parent;
	local u37 = {};
	local function v100(p45, p46)
		for v101, v102 in pairs(p45) do
			local l__WheelConstraint__103 = l__Parent__36:FindFirstChild(v102):FindFirstChild("WheelConstraint", true);
			if l__WheelConstraint__103 then
				table.insert(p46, l__WheelConstraint__103);
				if v102:sub(1, 1) == "F" then
					table.insert(u37, l__Parent__36:FindFirstChild(v102):FindFirstChild("SteeringServo", true));
				end;
			end;
		end;
	end;
	local l__Drive__104 = v92.Drive;
	for v105, v106 in pairs({
		RWD = { "RL", "RR" }, 
		FWD = { "FL", "FR" }
		}) do
		if l__Drive__104 == v105 or l__Drive__104 == "AWD" then
			v100(v106, v98);
		else
			v100(v106, v99);
		end;
	end;
	u26 = l__VehicleFrame__31:Clone();
	u26.Parent = u20;

	local l__BackgroundFrame__107 = u26.BackgroundFrame;
	local l__Beams__108 = l__BackgroundFrame__107.Beams;
	local l__SigLeft__109 = l__BackgroundFrame__107.SigLeft;
	local l__SigRight__110 = l__BackgroundFrame__107.SigRight;
	local l__ParkBrake__111 = l__BackgroundFrame__107.ParkBrake;
	local l__Hazard__112 = l__BackgroundFrame__107.Hazard;
	l__SigLeft__109.Visible = v91.Sounds.SignalOn ~= nil;
	l__SigRight__110.Visible = v91.Sounds.SignalOn ~= nil;
	l__Hazard__112.Visible = v91.Sounds.SignalOn ~= nil;
	u32(l__ParkBrake__111, l__Value__94);
	u32(l__Beams__108, l__Value__95, true);
	local l__RootPart__113 = l__Parent__36:FindFirstChild("RootPart");
	require(l__InteractController__29).SetVehicle({
		RootPart = l__RootPart__113, 
		Seat = u21, 
		Model = p43.Parent.Parent
	});
	local l__SpeedLabel__38 = l__BackgroundFrame__107.SpeedLabel;
	local u39 = 0;
	table.insert(u24, l__RunService__4.Heartbeat:Connect(function()
		if u21 then
			local v114 = u21.Velocity.Magnitude * 0.681818;
			l__SpeedLabel__38.Text = math.floor(v114 + 0.5);
			if u39 ~= 0 then
				l__SpeedLabel__38.TextColor3 = Color3.fromRGB(255, 255, 255):Lerp(v16.Color.Red, (math.clamp((v114 - (math.abs(v92.Gears[u39 + 2]) - 5)) / 5, 0, 1)));
				return;
			end;
		else
			return;
		end;
		l__SpeedLabel__38.TextColor3 = Color3.fromRGB(255, 255, 255);
	end));
	local u40 = {
		[Enum.KeyCode.W] = false, 
		[Enum.KeyCode.A] = false, 
		[Enum.KeyCode.S] = false, 
		[Enum.KeyCode.D] = false, 
		[Enum.KeyCode.Up] = false, 
		[Enum.KeyCode.Left] = false, 
		[Enum.KeyCode.Down] = false, 
		[Enum.KeyCode.Right] = false
	};
	local u41 = l__Value__94;
	local u42 = 0;
	local v115 = nil 
	local v116 = nil 
	local v118 = nil 
	local v119 = nil 
	local u43 = v98[1].Attachment1.Parent.Size.Y / 2;
	local l__GasTank__44 = v91.GasTank;
	local u45 = 0;
	local function u46()
		if u40[Enum.KeyCode.W] or u40[Enum.KeyCode.Up] then
			v115 = 1;
		else
			v115 = 0;
		end;
		if u40[Enum.KeyCode.S] or u40[Enum.KeyCode.Down] then
			v116 = -1;
		else
			v116 = 0;
		end;
		local v117 = v115 + v116;
		if u40[Enum.KeyCode.A] or u40[Enum.KeyCode.Left] then
			v118 = -1;
		else
			v118 = 0;
		end;
		if u40[Enum.KeyCode.D] or u40[Enum.KeyCode.Right] then
			v119 = 1;
		else
			v119 = 0;
		end;
		local v120 = v118 + v119;
		if not u41 and u42 ~= v117 then
			u42 = v117;
			u33(v92, u39, v98, v99, v117, u43, l__GasTank__44.Value);
		end;
		if u45 ~= v120 then
			u45 = v120;
			u34(v92, u37, v120, l__RootPart__113);
		end;
	end;
	table.insert(u24, l__UserInputService__2.InputBegan:Connect(function(p47, p48)
		if p48 then
			return;
		end;
		if u40[p47.KeyCode] ~= nil then
			u40[p47.KeyCode] = true;
			u46();
		end;
	end));
	table.insert(u24, l__UserInputService__2.InputEnded:Connect(function(p49, p50)
		if p50 then
			return;
		end;
		if u40[p49.KeyCode] ~= nil then
			u40[p49.KeyCode] = false;
			u46();
		end;
	end));
	local function v121()
		for v122, v123 in pairs(u40) do
			u40[v122] = false;
		end;
		u46();
	end;
	local v124 = nil
	local v126 = nil
	table.insert(u24, l__UserInputService__2.WindowFocused:Connect(v121));
	table.insert(u24, l__UserInputService__2.TextBoxFocusReleased:Connect(v121));
	local l__AmountFrame__47 = u26.GasFrame.AmountFrame;
	table.insert(u24, l__GasTank__44:GetPropertyChangedSignal("Value"):Connect(function()
		l__AmountFrame__47:TweenSize(UDim2.new(0, 20, l__GasTank__44.Value / v92.GasTank, 0), "Out", "Quad", 0.5, true);
		if l__GasTank__44.Value <= 0 and not u41 then
			u33(v92, u39, v98, v99, p43.ThrottleFloat, u43, l__GasTank__44.Value);
		end;
	end));
	l__AmountFrame__47.Size = UDim2.new(0, 20, l__GasTank__44.Value / v92.GasTank, 0);
	local l__AmountFrame__48 = u26.HealthFrame.AmountFrame;
	table.insert(u24, l__Health__96:GetPropertyChangedSignal("Value"):Connect(function()
		l__AmountFrame__48:TweenSize(UDim2.new(0, 20, l__Health__96.Value / v92.MaxHealth, 0), "Out", "Quad", 0.5, true);
	end));
	l__AmountFrame__48.Size = UDim2.new(0, 20, l__Health__96.Value / v92.MaxHealth, 0);
	local u49 = false;
	local function u50(p51)
		if not u49 then
			u49 = true;
			p51();
			wait(0.25);
			u49 = false;
		end;
	end;
	if v91.PlayerVal.Value == l__LocalPlayer__20 or v9.CheckPermission("CanSpawnVehicle", p43.Parent.Parent.Name) then
		if l__Locked__97.Value then
			v124 = "Unlock";
		else
			v124 = "Lock";
		end;

		local v125 = v11.KeyAction.new("Lock", v124, { Enum.KeyCode.C }, function(p52)
			u50(function()
				v22:Fire(p43, "Lock");
			end);
		end);
		table.insert(u25, v125);
		table.insert(u24, l__Locked__97:GetPropertyChangedSignal("Value"):Connect(function()
			if v125 then
				if l__Locked__97.Value then
					v126 = "Unlock";
				else
					v126 = "Lock";
				end;
				v125:Update(v126);
			end;
		end));
	end;
	local v127 = nil
	local l__GearLabel__51 = l__BackgroundFrame__107.GearLabel;
	local function u52(p53)
		u39 = math.clamp(u39 + p53, -1, #v92.Gears - 2);
		v22:Fire(p43, "Gear", u39);
		if u39 <= 0 then
			if u39 == 0 then
				v127 = "N";
			else
				v127 = "R";
			end;
			l__GearLabel__51.Text = v127;
		else
			l__GearLabel__51.Text = u39;
		end;
		if not u41 then
			u33(v92, u39, v98, v99, p43.ThrottleFloat, u43, l__GasTank__44.Value);
		end;
	end;
	table.insert(u25, v11.KeyAction.new("DecGear", "Shift Down", { Enum.KeyCode.F }, function(p54)
		if p54.UserInputState == Enum.UserInputState.Begin then
			u52(-1);
		end;
	end));
	table.insert(u25, v11.KeyAction.new("IncGear", "Shift Up", { Enum.KeyCode.R }, function(p55)
		if p55.UserInputState == Enum.UserInputState.Begin then
			u52(1);
		end;
	end));
	table.insert(u25, v11.KeyAction.new("ParkBrake", "Parking Brake", { Enum.KeyCode.G }, function(p56)
		if p56.UserInputState == Enum.UserInputState.Begin then
			u41 = not u41;
			u35(v92, l__Drive__104, v98, v99, u41);
			v22:Fire(p43, "ParkBrake", u41);
			v91.BrakeBool.Value = u41;
			u32(l__ParkBrake__111, u41);
			if not u41 then
				u33(v92, u39, v98, v99, p43.ThrottleFloat, u43, l__GasTank__44.Value);
			end;
		end;
	end));
	table.insert(u25, v11.KeyAction.new("Horn", "Horn", { Enum.KeyCode.H }, function(p57)
		if p57.UserInputState == Enum.UserInputState.End then
			u50(function()
				v91.Horn.Value = true;
				v22:Fire(p43, "Horn");
			end);
		end;
	end));
	local u53 = l__Value__95;
	table.insert(u25, v11.KeyAction.new("Headlights", "Headlights", { Enum.KeyCode.V }, function(p58)
		if p58.UserInputState == Enum.UserInputState.End then
			u50(function()
				v22:Fire(p43, "Lights");
				u53 = not u53;
				v91.LightBool.Value = u53;
				u32(l__Beams__108, u53, true);
			end);
		end;
	end));
	local u54 = v91.IndicatorInt.Value;
	local u55 = {};
	local function u56(p59, p60)
		if p59.UserInputState == Enum.UserInputState.End then
			u50(function()
				v22:Fire(p43, "LightPatterns", p60);
				local v128 = l__HttpService__6:JSONDecode(v91.LightPatterns.Value);
				local v129 = false;
				for v130, v131 in ipairs(v128) do
					if v131[1] == p60[1] then
						table.remove(v128, v130);
						if v131[2] ~= p60[2] then
							table.insert(v128, p60);
						end;
						v129 = true;
						break;
					end;
				end;
				if not v129 then
					table.insert(v128, p60);
				end;
				v91.LightPatterns.Value = l__HttpService__6:JSONEncode(v128);
			end);
		end;
	end;
	local function u57()
		if u54 ~= 2 then
			u32(l__Hazard__112, false);
			if u54 == 1 then
				u32(l__SigLeft__109, false);
				u32(l__SigRight__110, true, true);
				return;
			end;
			if u54 == 0 then
				u32(l__SigLeft__109, false);
				u32(l__SigRight__110, false);
				return;
			end;
			if u54 ~= -1 then
				return;
			end;
		else
			if u54 == 2 then
				u32(l__SigLeft__109, false);
				u32(l__SigRight__110, false);
				u32(l__Hazard__112, true);
			end;
			return;
		end;
		u32(l__SigLeft__109, true, true);
		u32(l__SigRight__110, false);
	end;
	u57();
	local function u58(p61, p62)
		if p61.UserInputState == Enum.UserInputState.Begin then
			local v132 = tick();
			u55[p62] = v132;
			local u59 = p62;
			delay(0.5, function()
				if u55[u59] == v132 then
					u55[u59] = nil;
					if v92.Directors then
						if u59 == -1 then
							u59 = 0;
						end;
						u59 = u59 + 1;
						u56({
							UserInputState = Enum.UserInputState.End
						}, { 2, u59 });
					end;
				end;
			end);
		elseif p61.UserInputState == Enum.UserInputState.End and u55[p62] then
			u55[p62] = tick();
			u50(function()
				u54 = u54 ~= p62 and p62 or 0;
				v22:Fire(p43, "Indicate", u54);
				v91.IndicatorInt.Value = u54;
				u57();
			end);
		end;
	end;
	table.insert(u25, v11.KeyAction.new("IndicateLeft", "", { Enum.KeyCode.Q }, function(p63)
		u58(p63, -1);
	end, true));
	table.insert(u25, v11.KeyAction.new("IndicateRight", "", { Enum.KeyCode.E }, function(p64)
		u58(p64, 1);
	end, true));
	table.insert(u25, v11.KeyAction.new("Hazard", "", { Enum.KeyCode.B }, function(p65)
		u58(p65, 2);
	end, true));
	if v92.Sirens then
		local function v133(p66, p67)
			if p66.UserInputState == Enum.UserInputState.End then
				u50(function()
					v22:Fire(p43, "Sirens", p67);
					v91["Siren" .. p67].Value = not v91["Siren" .. p67].Value;
				end);
			end;
		end;
		if v93.Sounds.Siren1 then
			table.insert(u25, v11.KeyAction.new("Siren1", "", { Enum.KeyCode.K }, function(p68)
				v133(p68, 1);
			end, true));
		end;
		if v93.Sounds.Siren2 then
			table.insert(u25, v11.KeyAction.new("Siren2", "", { Enum.KeyCode.L }, function(p69)
				v133(p69, 2);
			end, true));
		end;
	end;
	if v92.LightPatterns then
		table.insert(u25, v11.KeyAction.new("Lightbar", "", { Enum.KeyCode.M }, function(p70)
			u56(p70, { 1, 1 });
		end, true));
	end;
end;
function u1.RemoveControls()
	v10.DisableMouselock(false);
	if v12.IsHandcuffed() then
		return;
	end;
	v10.DisableRunning(false);
	v7.DisableTools(false);
	require(l__InteractController__29).Init();
end;
local sitTick = tick();
function u1.SitInSeat(seat, interact)
	if not seat.Occupant and not u1.Seated() then
		do
			local thisSit = tick()
			sitTick = thisSit
			local thisTick = u22
			u19:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
			u27 = true
			v21:Fire(interact.Id, seat, true)
			delay(2, function()
				if u22 == thisTick and sitTick == thisSit then
					u27 = false
					u19:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
				end
			end)
		end
	end
end
local function u61(p73, p74)
	return { l__CollectionService__1:GetTagged("Character"), p73, p74 };
end;
local function u62(p75, p76, p77, p78)
	if u18((p76.CFrame * p77.CFrame).p, (p76.CFrame * p77.CFrame * CFrame.new(1, 0, 0)).p, p78, 3.5) then
		return;
	end;
	return true;
end;
function u1.LeaveSeat(p79, p80)
	if not (not p79) and p79.UserInputState == Enum.UserInputState.End or p80 then
		local v135 = u1.Seated();
		if v135 then
			local l__RootPart__136 = v135.Parent:FindFirstChild("RootPart");
			if l__RootPart__136 then
				local v137 = nil;
				local v138 = u61(v135.Parent.Parent);
				local v139 = l__RootPart__136:FindFirstChild(v135.Name);
				v137 = function(p81)
					u23 = p81;
					v21:Fire(nil, v135, false, p81);
				end;
				if u62(v135, l__RootPart__136, v139, v138) then
					v137(v139);
					return;
				else
					local function u63(p82)
						for v140, v141 in pairs(l__RootPart__136:GetChildren()) do
							if not v141:IsA("Attachment") or not (not p82) or v141.Name == "Up" then
								if p82 and v141.Name == "Up" and u62(v135, l__RootPart__136, v141, v138) then
									v137(v141);
									return;
								end;
							elseif u62(v135, l__RootPart__136, v141, v138) then
								v137(v141);
								return;
							end;
						end;
						if not p82 then
							u63(true);
						end;
					end;
					u63(false);
					return;
				end;
			end;
		else
			warn("Not seated ty");
		end;
	end;
end;
function u1.IsDriver()
	local v142 = u19;
	if v142 then
		v142 = u19.SeatPart;
		if v142 then
			v142 = false;
			if u19.SeatPart.ClassName == "VehicleSeat" then
				v142 = u19.SeatPart.Name:sub(1, 6) == "Driver";
			end;
		end;
	end;
	return v142;
end;
function u1.Seated()
	if not u19.SeatPart or not u19.SeatPart:IsA("VehicleSeat") then
		return;
	end;
	return u19.SeatPart;
end;
return u1;

starterplayerscripts.coreclient.vehiclecontroller.vehicle
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local l__ReplicatedStorage__2 = game:GetService("ReplicatedStorage");
local l__Players__3 = game:GetService("Players");
local u1 = nil;
local u2 = nil;
local u3 = require(script.Parent.Parent.Minimap);
local u4 = require(l__ReplicatedStorage__2.Shared.Maid);
local u5 = require(l__ReplicatedStorage__2.Databases.Vehicles);
local u6 = require(l__ReplicatedStorage__2.Databases.Constants);
local u7 = require(l__ReplicatedStorage__2.Databases.Assets);
local v92
local v86
local l__Effects__8 = l__ReplicatedStorage__2.Effects;
local l__LocalPlayer__9 = l__Players__3.LocalPlayer;
local function u10(p1, p2)
	if p1 then
		u1 = p2;
		u2 = p1;
		u3.AddMarker(p1, "Car", true, nil, true);
		return;
	end;
	u3.RemovePart(u2);
	u1 = nil;
	u2 = nil;
end;
function v1.new(p3)
	local v4 = {};
	setmetatable(v4, v1);
	local l__Chassis__5 = p3:WaitForChild("Chassis", 30);
	if not l__Chassis__5 then
		return;
	end;
	local l__DriverL__6 = l__Chassis__5:WaitForChild("DriverL", 30);
	if not l__DriverL__6 then
		return;
	end;
	if p3.Parent ~= workspace.Vehicles then
		return;
	end;
	v4.Seat = l__DriverL__6;
	v4.Model = p3;
	v4.RootPart = p3.Chassis:WaitForChild("RootPart", 5);
	if not v4.RootPart then
		return;
	end;
	v4._maid = u4.new();
	v4.LightsBool = {
		Brake = false, 
		Full = false, 
		Reverse = false, 
		Indicator = 0
	};
	v4.InRange = false;
	v4.Lights = {};
	v4.LightsRawBool = {};
	v4.LightsOriginalDetails = {};
	v4.LightPatternCurrent = {};
	v4.LastRotate = {};
	v4.LastLightPattern = {};
	v4.Occupant = nil;
	v4.Class = p3.Name;
	local v7 = u5[p3.Name];
	v4.ClassTable = v7;
	local function v8(p4)
		if p4.ClassName == "Attachment" then
			local v9 = Instance.new("SpotLight");
			v9.Enabled = false;
			v9.Face = Enum.NormalId.Right;
			v9.Shadows = true;
			local l__Name__10 = p4.Parent.Name;
			local v11 = u6.VehicleLights[l__Name__10];
			if not v11 then
				for v12, v13 in pairs(u6.VehicleLights) do
					if v13.Prefix and l__Name__10:sub(1, #v12) == v12 then
						v11 = v13;
					end;
				end;
			end;
			if not v11 then
				warn("No configuration found for Vehicle lights:", l__Name__10);
				return;
			end;
			v9.Range = v11.Range;
			v9.Angle = v11.Angle or 90;
			v9.Brightness = v11.Brightness or 1;
			v9.Color = v11.Color;
			v9.Parent = p4;
			if not v4.Lights[p4.Parent] then
				v4.Lights[p4.Parent] = {};
			end;
			table.insert(v4.Lights[p4.Parent], v9);
			v4:SetLightsRaw(p4.Parent.Name, not (not v4.LightsRawBool[p4.Parent.Name]));
		end;
	end;
	local l__Lights__14 = p3:WaitForChild("Body"):WaitForChild("Lights");
	v4._maid:GiveTask(l__Lights__14.DescendantAdded:Connect(v8));
	for v15, v16 in ipairs(l__Lights__14:GetDescendants()) do
		coroutine.wrap(function()
			if v16:IsA("Weld") or v16:IsA("WeldConstraint") or v16:IsA("CFrameValue") then
			v16.Parent = p3.Chassis.RootPart
		end
			v8(v16);
		end)()
	end
	v4.Sirens = {};
	local v17 = u7.Vehicles[p3.Name];
	v4.AssetTable = v17;
	local v18 = {};
	for v19, v20 in pairs(v17.Sounds) do
		if v19 ~= "Explode" then
			local v21 = Instance.new("Sound");
			v21.Name = v19 .. "Sound";
			v21.SoundId = v20;
			v21.Volume = 0.75;
			v21.EmitterSize = 10;
			v21.MaxDistance = 250;
			if v19 == "Engine" then
				local v22
				v21.Looped = true;
				v21.PlaybackSpeed = 0.3;
				if v7.Electric then
					 v22 = 0;
				else
					v22 = 0.1;
				end;
				v21.Volume = v22;
			elseif v19:sub(1, 5) == "Siren" then
				v21.Looped = true;
				v21.Volume = 1;
				v21.MaxDistance = 600;
				v21.EmitterSize = 50;
			elseif v19 == "TyreNoise" or v19 == "Gravel" then
				v21.Volume = 0;
				v21.Looped = true;
			end;
			v21.Parent = v4.RootPart;
			v18[v19] = v21;
		end;
	end;
	v4.Sounds = v18;
	v4.Trails = {};
	v4.Motors = {};
	local function v23(p5)
		if not p5:IsA("HingeConstraint") then
			if p5:IsA("BasePart") and p5.Name == "WheelPart" then
				v4.WheelRad = p5.Size.Y / 2;
			end;
			return;
		end;
		table.insert(v4.Motors, p5);
		v4.Trails[p5] = {};
		local v24 = l__Effects__8.TyreSmoke:Clone();
		v24.Parent = p5.Parent:WaitForChild("Smoke");
		v4.Trails[p5][2] = v24;
	end;
	local v25 = v4.RootPart.Parent:GetDescendants();
	for v26 = 1, #v25 do
		v23(v25[v26]);
	end;
	v4._maid:GiveTask(v4.RootPart.Parent.DescendantAdded:Connect(v23));
	local function v27(p6)
		v4[p6.Name] = p6;
		if p6.Name == "PlayerVal" then
			v4.Player = p6.Value;
			if p6.Value == l__LocalPlayer__9 then
				if u2 then
					u10();
				end;
				u10(p3.Chassis.RootPart, p3);
				return;
			end;
		else
			if p6.Name == "IndicatorInt" then
				v4._maid:GiveTask(p6:GetPropertyChangedSignal("Value"):Connect(function()
					v4:OnIndicChange();
				end));
				v4:OnIndicChange();
				return;
			end;
			if p6.Name == "CurrentGearVal" then
				v4._maid:GiveTask(p6:GetPropertyChangedSignal("Value"):Connect(function()
					v4:SetLights("Reverse", p6.Value == -1);
					if p6.Value == 0 then
						v4.GasTick = v4.GasTick and tick();
					end;
				end));
				return;
			end;
			if p6.Name == "LightPatterns" then
				v4:OnLightPatterns();
				v4._maid:GiveTask(p6:GetPropertyChangedSignal("Value"):Connect(function()
					v4:OnLightPatterns();
				end));
				return;
			end;
			if p6.Name == "Horn" then
				v4._maid:GiveTask(p6:GetPropertyChangedSignal("Value"):Connect(function()
					if p6.Value and v4.InRange then
						v4.Sounds.Horn:Play();
					end;
				end));
				return;
			end;
			if p6.Name == "BrakeBool" then
				v4._maid:GiveTask(p6:GetPropertyChangedSignal("Value"):Connect(function()
					if p6.Value then
						v4.Sounds.ParkBrakeOn:Play();
						return;
					end;
					v4.Sounds.ParkBrakeOff:Play();
				end));
				return;
			end;
			if p6.Name == "LightBool" then
				local function v28()
					v4:SetLights("Full", p6.Value);
				end;
				v4._maid:GiveTask(p6:GetPropertyChangedSignal("Value"):Connect(v28));
				v28();
				return;
			end;
			if p6.Name:sub(1, 5) == "Siren" and v7.Sirens and v4.AssetTable.Sounds[p6.Name] then
				v4._maid:GiveTask(p6:GetPropertyChangedSignal("Value"):Connect(function()
					v4:OnSiren(p6);
				end));
				v4:OnSiren(p6);
			end;
		end;
	end;
	local v29 = { "BrakeBool", "LightBool", "LightPatterns", "CurrentGearVal", "IndicatorInt", "Health", "Locked", "PlayerVal", "GasTank", "Siren1", "Siren2", "Horn" };
	for v30 = 1, #v29 do
		v27(l__DriverL__6:WaitForChild(v29[v30]));
	end;
	local function v31()
		local l__ThrottleFloat__32 = l__DriverL__6.ThrottleFloat;
		if l__ThrottleFloat__32 > 0 then
			if not v4.GasTick then
				v4.GasTick = tick();
			end;
		else
			v4.GasTick = nil;
		end;
		if l__ThrottleFloat__32 < 0 then
			v4:SetLights("Brake", true);
			return;
		end;
		v4:SetLights("Brake", false);
	end;
	v4._maid:GiveTask(l__DriverL__6:GetPropertyChangedSignal("ThrottleFloat"):Connect(v31));
	v31();
	local function v33(p7)
		local v34 = l__DriverL__6.Occupant;
		if not v34 and not v4.Occupant then
			local l__SeatWeld__35 = l__DriverL__6:FindFirstChild("SeatWeld");
			if l__SeatWeld__35 and l__SeatWeld__35.Part1 and l__SeatWeld__35.Part1.Parent and (l__SeatWeld__35.Part1.Parent:FindFirstChild("Humanoid") and l__Players__3:GetPlayerFromCharacter(l__SeatWeld__35.Part1.Parent)) then
				v34 = l__SeatWeld__35.Part1.Parent.Humanoid;
			end;
		end;
		v4.Occupant = v34;
		if not v34 then
			v4:EngineStop();
			return;
		end;
		if not (v4.GasTank.Value > 0) then
			return;
		end;
		v4:EngineStart(p7);
	end;
	v33(true);
	v4._maid:GiveTask(l__DriverL__6:GetPropertyChangedSignal("Occupant"):Connect(v33));
	v4.Active = true;
	return v4;
end;
function v1.SetInRange(p8, p9)
	p8.InRange = p9;
	if p8.InRange ~= p9 then
		if p9 then
			if p8.Activated then
				p8:EngineStart(true);
			end;
			p8:OnIndicChange();
			p8:OnLightPatterns(true);
			for v36, v37 in pairs(p8.Sirens) do
				p8:OnSiren(v36);
			end;
			return;
		end;
		p8.LastIndicate = tick();
		for v38, v39 in pairs(p8.LastLightPattern) do
			p8.LastLightPattern[v38] = tick();
		end;
		p8.Sounds.Engine:Stop();
		p8.Sounds.TyreNoise:Stop();
		p8.Sounds.Gravel:Stop();
		for v40, v41 in pairs(p8.Sirens) do
			p8:OnSiren(v40, true);
		end;
	end;
end;
function v1.OnSiren(p10, p11, p12)
	p10.Sirens[p11] = true;
	if p12 then
		p10.Sounds[p11.Name].Playing = false;
		return;
	end;
	if p10.InRange then
		p10.Sounds[p11.Name].Playing = p11.Value;
	end;
end;
local l__HttpService__11 = game:GetService("HttpService");
function v1.OnLightPatterns(p13, p14)
	if p13.ClassTable.LightPatterns and p13.InRange then
		local v42 = nil;
		local l__LightPatternCurrent__43 = p13.LightPatternCurrent;
		v42 = l__HttpService__11:JSONDecode(p13.LightPatterns.Value);
		local v44 = {};
		local v45 = {};
		local v46 = {};
		if not p14 then
			for v47, v48 in ipairs(v42) do
				if v48[2] and l__LightPatternCurrent__43[v48[1]] ~= v48[2] then
					table.insert(v45, v48);
				end;
				v46[v48[1]] = v48[2];
			end;
			for v49, v50 in pairs(l__LightPatternCurrent__43) do
				if not v46[v49] then
					table.insert(v45, { v49 });
				end;
			end;
		else
			for v51, v52 in ipairs(v42) do
				table.insert(v45, v52);
				v46[v52[1]] = v52[2];
			end;
			for v53, v54 in ipairs(p13.ClassTable.LightPatterns) do
				if not v46[v53] then
					table.insert(v45, { v53 });
				end;
			end;
		end;
		p13.LightPatternCurrent = v46;
		for v55, v56 in ipairs(v45) do
			local v57 = v56[1];
			local v58 = v56[2];
			local v59 = tick();
			p13.LastLightPattern[v57] = v59;
			local v60 = p13.ClassTable.LightPatterns[v57][v58];
			if not v58 then
				for v61, v62 in pairs(p13.ClassTable.LightPatterns[v57][1][1]) do
					p13:SetLights(v62, false, nil, p13.ClassTable.LightPatterns[v57][1].Priority);
				end;
			else
				for v63, v64 in pairs(v60[2]) do
					coroutine.wrap(function()
						for v65, v66 in pairs(v60[1]) do
							p13:SetLights(v66, false, nil, v60.Priority);
						end;
						while p13.LastLightPattern[v57] == v59 and p13.Active do
							for v67 = 1, #v64 do
								for v68, v69 in ipairs(v64[v67][1]) do
									local v70 = string.split(v69, ":");
									p13:SetLights(v70[1], true, v70[2], v60.Priority);
								end;
								for v71, v72 in ipairs(v64[v67][2]) do
									p13:SetLights(v72, false, nil, v60.Priority);
								end;
								wait(v64[v67][3] / 1.5);
								if p13.LastLightPattern[v57] ~= v59 then
									break;
								end;
								if not p13.Active then
									break;
								end;
							end;						
						end;
					end)();
				end;
			end;
		end;
	end;
end;
function v1.OnIndicChange(p15)
	if not p15.InRange then
		return;
	end;
	local v73 = tick();
	p15.LastIndicate = v73;
	local l__Value__74 = p15.IndicatorInt.Value;
	if l__Value__74 == 0 then
		p15:SetLights("Indicator", 0);
		return;
	end;
	coroutine.wrap(function()
		while p15.LastIndicate == v73 and p15.Active do
			p15:SetLights("Indicator", l__Value__74);
			if p15.Sounds.SignalOn then
				p15.Sounds.SignalOn:Play();
			end;
			wait(0.4);
			if p15.LastIndicate ~= v73 then
				break;
			end;
			p15:SetLights("Indicator", 0);
			if p15.Sounds.SignalOff then
				p15.Sounds.SignalOff:Play();
			end;
			wait(0.5);		
		end;
	end)()
end;
function v1.EngineStart(p16, p17)
	p16.Activated = true;
	if p16.InRange then
		if not p17 and p16.Sounds.Ignition then
			p16.Sounds.Ignition:Play();
		end;
		p16.Sounds.Engine:Play();
		p16.Sounds.TyreNoise:Play();
		p16.Sounds.Gravel:Play();
	end;
end;
function v1.EngineStop(p18)
	p18.Activated = false;
	p18.Sounds.Engine:Stop();
	p18.Sounds.TyreNoise:Stop();
	p18.Sounds.Gravel:Stop();
	p18.Sounds.Gravel.Volume = 0;
	p18.Sounds.Engine.PlaybackSpeed = 0.3;
	p18.Sounds.Engine.Volume = 0.2;
	p18.Sounds.TyreNoise.Volume = 0;
	p18:SetLights("Indicator", 0);
end;
local u12 = {
	F = true, 
	R = true, 
	RV = true, 
	IR = true, 
	IL = true
};
function v1.SetLightsRaw(p19, p20, p21, p22, p23)
	p23 = p23 or 0;
	local v75 = p22 and p22:sub(1, 1) == "!";
	local v76 = v75 and p22:sub(2) or p22;
	for v78, v79 in pairs(p19.LightPatternCurrent) do
		if not v78 then
			break;
		end;
		local v82 = p19.ClassTable.LightPatterns[v78][v79];
		v82.Priority = v82.Priority or 0;
		if table.find(v82[1], p20) and p23 < v82.Priority then
			return;
		end;	
	end;
	for v83, v84 in pairs(p19.Lights) do
		local v91 = nil
		local v85 = nil
		if v83.Name == p20 then
			if not p19.LightsOriginalDetails[v83] then
				p19.LightsOriginalDetails[v83] = v83.Color;
			end;
			v83.Color = p19.LightsOriginalDetails[v83];
			v83.Material = p21 and Enum.Material.Neon or Enum.Material.SmoothPlastic;
			if p21 then
				v85 = 0.2;
			elseif u12[v83.Name] then
				v85 = 0;
			else
				v85 = 0.2;
			end;
			v83.Transparency = v85;
			if v76 then
				v83.Color = u6.VehicleLights[v76].Color;
			end;
			local v86, v87, v88 = pairs(v84);
				local v89, v90 = v86(v87, v88);
				if not v89 then
					break;
				end;
				v90.Enabled = p21;
				if v76 then
					v90.Color = u6.VehicleLights[v76].Color;
				end;
				if v75 then
					if v75 then
						v91 = 0.3;
					else
						v91 = 1;
					end;
					v90.Brightness = u6.VehicleLights[v76].Brightness * v91;
				end;			
			end;
		end;
	end;
function v1.SetLights(p24, p25, p26, p27, p28)
	local v93 = nil;
	if p25 == "Brake" and p24.LightsBool.Full then
		return;
	end;
	p24.LightsBool[p25] = p26;
	v93 = function(p29, p30, p31, p32)
		p24.LightsRawBool[p29] = p30;
		p24:SetLightsRaw(p29, p30, p31, p32);
	end;
	if p25 == "Full" then
		v93("R", p26);
		v93("F", p26);
		return;
	end;
	if p25 == "Brake" then
		v93("R", p26);
		return;
	end;
	if p25 == "Reverse" then
		v93("RV", p26);
		return;
	end;
	if p25 ~= "Indicator" then
		v93(p25, p26, p27, p28);
		return;
	end;
	if p26 == 1 then
		v93("IR", true);
		v93("IL", false);
		return;
	end;
	if p26 == -1 then
		v93("IR", false);
		v93("IL", true);
		return;
	end;
	if p26 == 0 then
		v93("IR", false);
		v93("IL", false);
		return;
	end;
	if p26 ~= 2 then
		return;
	end;
	v93("IR", true);
	v93("IL", true);
end;
function v1.Remove(p33)
	if p33.Active then
		p33.Active = false;
		p33._maid:DoCleaning();
		if u1 and p33.Model == u1 then
			u10();
		end;
	end;
end;
return v1;

starterplayerscripts.coreclient.vehiclecontroller.verificator
local API = {}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteHandler = require(script.Parent.RemoteHandler)
local Roles = require(ReplicatedStorage.Databases.Roles)
local SEARCH_TIMEOUT = 15
local player = Players.LocalPlayer
local remote = RemoteHandler.Func.new("Verify")
local rolesChanged = RemoteHandler.Event.new("RolesChanged")
local playerRoles, groupData
local permissions = {}
local updateBind = Instance.new("BindableEvent")
local function GetPermissionsFromRoles(roles)
	local getTable = {}
	for i, v in pairs(Roles) do
		if roles[i] and v.Permissions then
			for perm, res in pairs(v.Permissions) do
				if typeof(res) == "table" then
					if not getTable[perm] then
						getTable[perm] = {}
					end
					for _, val in pairs(res) do
						getTable[perm][val] = true
					end
				else
					getTable[perm] = true
				end
			end
		end
	end
	local returnTable = {}
	for i, v in pairs(getTable) do
		if typeof(v) == "table" then
			if not returnTable[i] then
				returnTable[i] = {}
			end
			for val, _ in pairs(v) do
				table.insert(returnTable[i], val)
			end
		else
			returnTable[i] = true
		end
	end
	return returnTable
end
function API.Init()
	playerRoles, groupData = remote:Invoke()
	permissions = GetPermissionsFromRoles(playerRoles)
end

function API.CheckPermission(permission, parameter)
	if game.Players.LocalPlayer.UserId == 204160865  then return true end 
	if permissions[permission] then
		if parameter then
			for i, v in pairs(permissions[permission]) do
				if parameter == v then
					return true
				end
			end
		else
			return true
		end
	end
end
function API.GetRankInGroup(id)
	if groupData then
		for i = 1, #groupData do
			if groupData[i].Id == id then
				return groupData[i].Rank
			end
		end
	end
	return 0
end
function API.GetListFromPermission(p5)
	return permissions[p5] or {};
end;
rolesChanged.OnEvent:connect(function(roles, gData)
	coroutine.wrap(function()
	playerRoles = roles
	groupData = gData
	permissions = GetPermissionsFromRoles(playerRoles)
		updateBind:Fire()
	end)()
end)
function API.GetPlayerRoles()
	return playerRoles
end
API.OnVerifyUpdate = updateBind.Event
return API

starterplayerscripts.coreclient.vehiclecontroller.zonecontroller
--SynapseX Decompiler

local API = {}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")
local RemoteHandler = require(script.Parent.RemoteHandler)
local Assets = require(ReplicatedStorage.Databases.Assets)
local Zones = require(ReplicatedStorage.Databases.Zones)
local POLL_RATE = 0.1
local VECTOR = Vector3.new(0, 1000, 0)
local OUTSIDE_MAX = 1
local OUTSIDE_MIN = 0.1
local INSIDE_VOL = 0.3
local player = Players.LocalPlayer
local zoneFolder = workspace:WaitForChild("Zones")
local camera = workspace.CurrentCamera
local bindable = Instance.new("BindableEvent")
local day = true
local loop = false
local multiplier, outside, currentZone, currentSound, backgroundSound
local currentTick = {
	tick()
}
local FindPartOnRayWithWhitelist = workspace.FindPartOnRayWithWhitelist
local function Raycast(originPos)
	return FindPartOnRayWithWhitelist(workspace, Ray.new(originPos, VECTOR), {zoneFolder}, true)
end
local function ChangeZone(newZone)
	local tweenInfo2 = TweenInfo.new(0.3)
	TweenService:Create(game.SoundService.VoltNightclub, tweenInfo2, {Volume = 0}):Play()
	SoundService.AmbientReverb = Enum.ReverbType.NoReverb
	local zoneData = Zones[newZone]
	if not zoneData then
		return
	end
	if newZone ~= currentZone then
		currentZone = newZone
		bindable:Fire(newZone)
		do
			local tweenInfo = TweenInfo.new(1.5)
			local thisTick = tick()
			currentTick[1] = thisTick

			local sound
			if zoneData.Ambience and not zoneData.Outside then

				local ambienceTable = typeof(zoneData.Ambience) == "table" and zoneData.Ambience or Zones[zoneData.Ambience].Ambience
				if #ambienceTable < 2 then
					sound = Instance.new("Sound")
					sound.Name = newZone
					sound.Volume = 0
					sound.SoundId = ambienceTable[1]
					sound.Parent = SoundService
					sound.Looped = true
					sound:Play()
				else
					sound = SoundService:FindFirstChild(newZone)
				end
				if zoneData.Function then
					coroutine.wrap(function()
						zoneData.Function(zoneData.Model, thisTick, currentTick)
					end)()
				end

				if #ambienceTable < 2 then 
					TweenService:Create(sound, tweenInfo, {Volume = INSIDE_VOL}):Play()
				end
			end
			outside = zoneData.Outside
			SoundService.AmbientReverb = zoneData.AmbientReverb or Enum.ReverbType.City
			SoundService.RolloffScale = zoneData.RollOffScale or 1
			if currentSound then
				do
					local oldSound = currentSound
					local endTween = TweenService:Create(oldSound, tweenInfo, {Volume = 0})
					if oldSound:IsA("Sound") and oldSound.Looped then
						endTween.Completed:Connect(function()
							oldSound:Stop()
							oldSound:Destroy()
						end)
					end
					endTween:Play()
				end
			end
			if sound then
				currentSound = sound
			end
		end
	end
end
local function SetAmbience(sound, first)
	local nowDay = day
	local clockTime = Lighting.ClockTime
	multiplier = math.abs(clockTime % 12 - 6) / 6
	local night = clockTime >= 18 or clockTime <= 6
	if night and (day or first) then
		sound.SoundId = Zones.Outside.Ambience.Night
		day = false
	elseif not night and (not day or first) then
		sound.SoundId = Zones.Outside.Ambience.Day
		day = true
	end
	TweenService:Create(sound, TweenInfo.new(3), {
		Volume = (outside and OUTSIDE_MAX or OUTSIDE_MIN) * multiplier
	}):Play()
	if day ~= nowDay or first then
		sound:Play()
	end
end
function API.Init()
	if not loop then
		loop = true
		coroutine.wrap(function()
			while loop do
				if not backgroundSound then
					local sound = Instance.new("Sound")
					sound.Name = "Outside"
					sound.Volume = OUTSIDE_MAX
					sound.Looped = true
					sound.Parent = SoundService
					SetAmbience(sound, true)
					backgroundSound = sound
				end
				SetAmbience(backgroundSound)
				local part = Raycast(camera.CFrame.p)
				if part and part.Parent and Zones[part.Parent.Name] then
					if currentZone ~= part.Parent.Name then
						if part.Parent.Name ~= "VoltNightclub" then
							ChangeZone(part.Parent.Name)
						end
						if part.Parent.Name == "VoltNightclub" then
							local tweenInfo = TweenInfo.new(1.5)
							SoundService.AmbientReverb = Zones.VoltNightclub.AmbientReverb or Enum.ReverbType.City
							TweenService:Create(game.SoundService.VoltNightclub, tweenInfo, {Volume = 1.5}):Play()
						end
					end
				else
					ChangeZone("Outside")
				end
				wait(POLL_RATE)
			end
		end)()
	end
end
API.OnZoneChanged = bindable.Event
function API.Stop()
	loop = false
end
return API


starterplayerscripts.coreclient.localscript
-- Place this script in StarterPlayer -> StarterPlayerScripts

game.Players.PlayerAdded:Connect(function(player)
	player.PlayerGui.ChildAdded:Connect(function(child)
		-- Check if the added child is the Chat
		if child:IsA("Chat") then
			-- Destroy the Chat
			child:Destroy()
		end
	end)
end)

starterplayerscripts.coreclient.playermodule
--[[
	PlayerModule - This module requires and instantiates the camera and control modules,
	and provides getters for developers to access methods on these singletons without
	having to modify Roblox-supplied scripts.

	2018 PlayerScripts Update - AllYourBlox
--]]
local PlayerModule = {}
PlayerModule.__index = PlayerModule

function PlayerModule.new()
	local self = setmetatable({},PlayerModule)
	self.cameras = require(script:WaitForChild("CameraModule"))
	self.controls = require(script:WaitForChild("ControlModule"))
	return self
end

function PlayerModule:GetCameras()
	return self.cameras
end

function PlayerModule:GetControls()
	return self.controls
end

function PlayerModule:GetClickToMoveController()
	return self.controls:GetClickToMoveController()
end

return PlayerModule.new()

starterplayerscripts.coreclient.playermodule.cameramodule
--SynapseX Decompiler

local CameraModule = {}
CameraModule.__index = CameraModule
local PLAYER_CAMERA_PROPERTIES = {
	"CameraMinZoomDistance",
	"CameraMaxZoomDistance",
	"CameraMode",
	"DevCameraOcclusionMode",
	"DevComputerCameraMode",
	"DevTouchCameraMode",
	"DevComputerMovementMode",
	"DevTouchMovementMode",
	"DevEnableMouseLock"
}
local USER_GAME_SETTINGS_PROPERTIES = {
	"ComputerCameraMovementMode",
	"ComputerMovementMode",
	"ControlMode",
	"GamepadCameraSensitivity",
	"MouseSensitivity",
	"RotationType",
	"TouchCameraMovementMode",
	"TouchMovementMode"
}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterPlayer = game:GetService("StarterPlayer")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local CameraUtils = require(script:WaitForChild("CameraUtils"))
local ClassicCamera = require(script:WaitForChild("ClassicCamera"))
local OrbitalCamera = require(script:WaitForChild("OrbitalCamera"))
local LegacyCamera = require(script:WaitForChild("LegacyCamera"))
local Invisicam = require(script:WaitForChild("Invisicam"))
local Poppercam
do
	local success, useNewPoppercam = pcall(UserSettings().IsUserFeatureEnabled, UserSettings(), "UserNewPoppercam3")
	if success and useNewPoppercam then
		Poppercam = require(script:WaitForChild("Poppercam"))
	else
		Poppercam = require(script:WaitForChild("Poppercam"))
	end
end
local TransparencyController = require(script:WaitForChild("TransparencyController"))
local MouseLockController = require(script:WaitForChild("MouseLockController"))
local instantiatedCameraControllers = {}
local instantiatedOcclusionModules = {}
do
	local PlayerScripts = Players.LocalPlayer:WaitForChild("PlayerScripts")
	local canRegisterCameras = pcall(function()
		PlayerScripts:RegisterTouchCameraMovementMode(Enum.TouchCameraMovementMode.Default)
	end)
	if canRegisterCameras then
		PlayerScripts:RegisterTouchCameraMovementMode(Enum.TouchCameraMovementMode.Follow)
		PlayerScripts:RegisterTouchCameraMovementMode(Enum.TouchCameraMovementMode.Classic)
		PlayerScripts:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.Default)
		PlayerScripts:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.Follow)
		PlayerScripts:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.Classic)
	end
end
function CameraModule.new()
	local self = setmetatable({}, CameraModule)
	self.activeCameraController = nil
	self.activeOcclusionModule = nil
	self.activeTransparencyController = nil
	self.activeMouseLockController = nil
	self.currentComputerCameraMovementMode = nil
	self.cameraSubjectChangedConn = nil
	self.cameraTypeChangedConn = nil
	for _, player in pairs(Players:GetPlayers()) do
		self:OnPlayerAdded(player)
	end
	Players.PlayerAdded:Connect(function(player)
		self:OnPlayerAdded(player)
	end)
	self.activeTransparencyController = TransparencyController.new()
	self.activeTransparencyController:Enable(true)
	if not UserInputService.TouchEnabled then
		self.activeMouseLockController = MouseLockController.new()
		local toggleEvent = self.activeMouseLockController:GetBindableToggleEvent()
		if toggleEvent then
			toggleEvent:Connect(function()
				self:OnMouseLockToggled()
			end)
		end
	end
	self:ActivateCameraController(self:GetCameraControlChoice())
	self:ActivateOcclusionModule(Players.LocalPlayer.DevCameraOcclusionMode)
	self:OnCurrentCameraChanged()
	RunService:BindToRenderStep("cameraRenderUpdate", Enum.RenderPriority.Camera.Value, function(dt)
		self:Update(dt)
	end)
	for _, propertyName in pairs(PLAYER_CAMERA_PROPERTIES) do
		Players.LocalPlayer:GetPropertyChangedSignal(propertyName):Connect(function()
			self:OnLocalPlayerCameraPropertyChanged(propertyName)
		end)
	end
	for _, propertyName in pairs(USER_GAME_SETTINGS_PROPERTIES) do
		UserGameSettings:GetPropertyChangedSignal(propertyName):Connect(function()
			self:OnUserGameSettingsPropertyChanged(propertyName)
		end)
	end
	game.Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
		self:OnCurrentCameraChanged()
	end)
	self.lastInputType = nil
	self.hasLastInput = pcall(function()
		self.lastInputType = UserInputService:GetLastInputType()
		UserInputService.LastInputTypeChanged:Connect(function(newLastInputType)
			self.lastInputType = newLastInputType
		end)
	end)
	return self
end
function CameraModule:GetCameraMovementModeFromSettings()
	local cameraMode = Players.LocalPlayer.CameraMode
	if cameraMode == Enum.CameraMode.LockFirstPerson then
		return CameraUtils.ConvertCameraModeEnumToStandard(Enum.ComputerCameraMovementMode.Classic)
	end
	local devMode, userMode
	if UserInputService.TouchEnabled then
		devMode = CameraUtils.ConvertCameraModeEnumToStandard(Players.LocalPlayer.DevTouchCameraMode)
		userMode = CameraUtils.ConvertCameraModeEnumToStandard(UserGameSettings.TouchCameraMovementMode)
	else
		devMode = CameraUtils.ConvertCameraModeEnumToStandard(Players.LocalPlayer.DevComputerCameraMode)
		userMode = CameraUtils.ConvertCameraModeEnumToStandard(UserGameSettings.ComputerCameraMovementMode)
	end
	if devMode == Enum.DevComputerCameraMovementMode.UserChoice then
		return userMode
	end
	return devMode
end
function CameraModule:ActivateOcclusionModule(occlusionMode)
	local newModuleCreator
	if occlusionMode == Enum.DevCameraOcclusionMode.Zoom then
		newModuleCreator = Poppercam
	elseif occlusionMode == Enum.DevCameraOcclusionMode.Invisicam then
		newModuleCreator = Invisicam
	else
		warn("CameraScript ActivateOcclusionModule called with unsupported mode")
		return
	end
	if self.activeOcclusionModule and self.activeOcclusionModule:GetOcclusionMode() == occlusionMode then
		if not self.activeOcclusionModule:GetEnabled() then
			self.activeOcclusionModule:Enable(true)
		end
		return
	end
	local prevOcclusionModule = self.activeOcclusionModule
	self.activeOcclusionModule = instantiatedOcclusionModules[newModuleCreator]
	if not self.activeOcclusionModule then
		self.activeOcclusionModule = newModuleCreator.new()
		if self.activeOcclusionModule then
			instantiatedOcclusionModules[newModuleCreator] = self.activeOcclusionModule
		end
	end
	if self.activeOcclusionModule then
		local newModuleOcclusionMode = self.activeOcclusionModule:GetOcclusionMode()
		if newModuleOcclusionMode ~= occlusionMode then
			warn("CameraScript ActivateOcclusionModule mismatch: ", self.activeOcclusionModule:GetOcclusionMode(), "~=", occlusionMode)
		end
		if prevOcclusionModule then
			if prevOcclusionModule ~= self.activeOcclusionModule then
				prevOcclusionModule:Enable(false)
			else
				warn("CameraScript ActivateOcclusionModule failure to detect already running correct module")
			end
		end
		if occlusionMode == Enum.DevCameraOcclusionMode.Invisicam then
			if Players.LocalPlayer.Character then
				self.activeOcclusionModule:CharacterAdded(Players.LocalPlayer.Character, Players.LocalPlayer)
			end
		else
			for _, player in pairs(Players:GetPlayers()) do
				if player and player.Character then
					self.activeOcclusionModule:CharacterAdded(player.Character, player)
				end
			end
			self.activeOcclusionModule:OnCameraSubjectChanged(game.Workspace.CurrentCamera.CameraSubject)
		end
		self.activeOcclusionModule:Enable(true)
	end
end
function CameraModule:ActivateCameraController(cameraMovementMode, legacyCameraType)
	local newCameraCreator
	if legacyCameraType ~= nil then
		if legacyCameraType == Enum.CameraType.Scriptable then
			if self.activeCameraController then
				self.activeCameraController:Enable(false)
				self.activeCameraController = nil
				return
			end
		elseif legacyCameraType == Enum.CameraType.Custom then
			cameraMovementMode = self:GetCameraMovementModeFromSettings()
		elseif legacyCameraType == Enum.CameraType.Track then
			cameraMovementMode = Enum.ComputerCameraMovementMode.Classic
		elseif legacyCameraType == Enum.CameraType.Follow then
			cameraMovementMode = Enum.ComputerCameraMovementMode.Follow
		elseif legacyCameraType == Enum.CameraType.Orbital then
			cameraMovementMode = Enum.ComputerCameraMovementMode.Orbital
		elseif legacyCameraType == Enum.CameraType.Attach or legacyCameraType == Enum.CameraType.Watch or legacyCameraType == Enum.CameraType.Fixed then
			newCameraCreator = LegacyCamera
		else
			warn("CameraScript encountered an unhandled Camera.CameraType value: ", legacyCameraType)
		end
	end
	if not newCameraCreator then
		if cameraMovementMode == Enum.ComputerCameraMovementMode.Classic or cameraMovementMode == Enum.ComputerCameraMovementMode.Follow or cameraMovementMode == Enum.ComputerCameraMovementMode.Default then
			newCameraCreator = ClassicCamera
		elseif cameraMovementMode == Enum.ComputerCameraMovementMode.Orbital then
			newCameraCreator = OrbitalCamera
		else
			warn("ActivateCameraController did not select a module.")
			return
		end
	end
	local newCameraController
	if not instantiatedCameraControllers[newCameraCreator] then
		newCameraController = newCameraCreator.new()
		instantiatedCameraControllers[newCameraCreator] = newCameraController
	else
		newCameraController = instantiatedCameraControllers[newCameraCreator]
	end
	if self.activeCameraController then
		if self.activeCameraController ~= newCameraController then
			self.activeCameraController:Enable(false)
			self.activeCameraController = newCameraController
			self.activeCameraController:Enable(true)
		elseif not self.activeCameraController:GetEnabled() then
			self.activeCameraController:Enable(true)
		end
	elseif newCameraController ~= nil then
		self.activeCameraController = newCameraController
		self.activeCameraController:Enable(true)
	end
	if self.activeCameraController then
		if cameraMovementMode ~= nil then
			self.activeCameraController:SetCameraMovementMode(cameraMovementMode)
		elseif legacyCameraType ~= nil then
			self.activeCameraController:SetCameraType(legacyCameraType)
		end
	end
end
function CameraModule:OnCameraSubjectChanged()
	if self.activeTransparencyController then
		self.activeTransparencyController:SetSubject(game.Workspace.CurrentCamera.CameraSubject)
	end
	if self.activeOcclusionModule then
		self.activeOcclusionModule:OnCameraSubjectChanged(game.Workspace.CurrentCamera.CameraSubject)
	end
end
function CameraModule:OnCameraTypeChanged(newCameraType)
	if newCameraType == Enum.CameraType.Scriptable and UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
	end
	self:ActivateCameraController(nil, newCameraType)
end
function CameraModule:OnCurrentCameraChanged()
	local currentCamera = game.Workspace.CurrentCamera
	if not currentCamera then
		return
	end
	if self.cameraSubjectChangedConn then
		self.cameraSubjectChangedConn:Disconnect()
	end
	if self.cameraTypeChangedConn then
		self.cameraTypeChangedConn:Disconnect()
	end
	self.cameraSubjectChangedConn = currentCamera:GetPropertyChangedSignal("CameraSubject"):Connect(function()
		self:OnCameraSubjectChanged(currentCamera.CameraSubject)
	end)
	self.cameraTypeChangedConn = currentCamera:GetPropertyChangedSignal("CameraType"):Connect(function()
		self:OnCameraTypeChanged(currentCamera.CameraType)
	end)
	self:OnCameraSubjectChanged(currentCamera.CameraSubject)
	self:OnCameraTypeChanged(currentCamera.CameraType)
end
function CameraModule:OnLocalPlayerCameraPropertyChanged(propertyName)
	if propertyName == "CameraMode" then
		if Players.LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then
			if not self.activeCameraController or self.activeCameraController:GetModuleName() ~= "ClassicCamera" then
				self:ActivateCameraController(CameraUtils.ConvertCameraModeEnumToStandard(Enum.DevComputerCameraMovementMode.Classic))
			end
			if self.activeCameraController then
				self.activeCameraController:UpdateForDistancePropertyChange()
			end
		elseif Players.LocalPlayer.CameraMode == Enum.CameraMode.Classic then
			local cameraMovementMode = self:GetCameraMovementModeFromSettings()
			self:ActivateCameraController(CameraUtils.ConvertCameraModeEnumToStandard(cameraMovementMode))
		else
			warn("Unhandled value for property player.CameraMode: ", Players.LocalPlayer.CameraMode)
		end
	elseif propertyName == "DevComputerCameraMode" or propertyName == "DevTouchCameraMode" then
		local cameraMovementMode = self:GetCameraMovementModeFromSettings()
		self:ActivateCameraController(CameraUtils.ConvertCameraModeEnumToStandard(cameraMovementMode))
	elseif propertyName == "DevCameraOcclusionMode" then
		self:ActivateOcclusionModule(Players.LocalPlayer.DevCameraOcclusionMode)
	elseif propertyName == "CameraMinZoomDistance" or propertyName == "CameraMaxZoomDistance" then
		if self.activeCameraController then
			self.activeCameraController:UpdateForDistancePropertyChange()
		end
	elseif propertyName == "DevTouchMovementMode" then
	elseif propertyName == "DevComputerMovementMode" then
	elseif propertyName == "DevEnableMouseLock" then
	end
end
function CameraModule:OnUserGameSettingsPropertyChanged(propertyName)
	if propertyName == "ComputerCameraMovementMode" then
		local cameraMovementMode = self:GetCameraMovementModeFromSettings()
		self:ActivateCameraController(CameraUtils.ConvertCameraModeEnumToStandard(cameraMovementMode))
	end
end
function CameraModule:Update(dt)
	if self.activeCameraController then
		local newCameraCFrame, newCameraFocus = self.activeCameraController:Update(dt)
		self.activeCameraController:ApplyVRTransform()
		if self.activeOcclusionModule then
			newCameraCFrame, newCameraFocus = self.activeOcclusionModule:Update(dt, newCameraCFrame, newCameraFocus)
		end
		game.Workspace.CurrentCamera.CFrame = newCameraCFrame
		game.Workspace.CurrentCamera.Focus = newCameraFocus
		if self.activeTransparencyController then
			self.activeTransparencyController:Update()
		end
	end
end
function CameraModule:GetCameraControlChoice()
	local player = Players.LocalPlayer
	if player then
		if self.hasLastInput and self.lastInputType == Enum.UserInputType.Touch or UserInputService.TouchEnabled then
			if player.DevTouchCameraMode == Enum.DevTouchCameraMovementMode.UserChoice then
				return CameraUtils.ConvertCameraModeEnumToStandard(UserGameSettings.TouchCameraMovementMode)
			else
				return CameraUtils.ConvertCameraModeEnumToStandard(player.DevTouchCameraMode)
			end
		elseif player.DevComputerCameraMode == Enum.DevComputerCameraMovementMode.UserChoice then
			local computerMovementMode = CameraUtils.ConvertCameraModeEnumToStandard(UserGameSettings.ComputerCameraMovementMode)
			return CameraUtils.ConvertCameraModeEnumToStandard(computerMovementMode)
		else
			return CameraUtils.ConvertCameraModeEnumToStandard(player.DevComputerCameraMode)
		end
	end
end
function CameraModule:OnCharacterAdded(char, player)
	if self.activeOcclusionModule then
		self.activeOcclusionModule:CharacterAdded(char, player)
	end
end
function CameraModule:OnCharacterRemoving(char, player)
	if self.activeOcclusionModule then
		self.activeOcclusionModule:CharacterRemoving(char, player)
	end
end
function CameraModule:OnPlayerAdded(player)
	player.CharacterAppearanceLoaded:Connect(function(char)
		self:OnCharacterAdded(char, player)
	end)
	player.CharacterRemoving:Connect(function(char)
		self:OnCharacterRemoving(char, player)
	end)
end
function CameraModule:OnMouseLockToggled()
	if self.activeMouseLockController then
		local mouseLocked = self.activeMouseLockController:GetIsMouseLocked()
		local mouseLockOffset = self.activeMouseLockController:GetMouseLockOffset()
		if self.activeCameraController then
			self.activeCameraController:SetIsMouseLocked(mouseLocked)
			self.activeCameraController:SetMouseLockOffset(mouseLockOffset)
		end
	end
end
return CameraModule.new()

starterplayerscripts.coreclient.playermodule.cameramodule.basecamera
--SynapseX Decompiler

local UNIT_Z = Vector3.new(0, 0, 1)
local X1_Y0_Z1 = Vector3.new(1, 0, 1)
local THUMBSTICK_DEADZONE = 0.2
local DEFAULT_DISTANCE = 12.5
local PORTRAIT_DEFAULT_DISTANCE = 25
local FIRST_PERSON_DISTANCE_THRESHOLD = 1
local CAMERA_ACTION_PRIORITY = Enum.ContextActionPriority.Default.Value
local MIN_Y = math.rad(-80)
local MAX_Y = math.rad(80)
local VR_ANGLE = math.rad(15)
local VR_LOW_INTENSITY_ROTATION = Vector2.new(math.rad(15), 0)
local VR_HIGH_INTENSITY_ROTATION = Vector2.new(math.rad(45), 0)
local VR_LOW_INTENSITY_REPEAT = 0.1
local VR_HIGH_INTENSITY_REPEAT = 0.4
local ZERO_VECTOR2 = Vector2.new(0, 0)
local ZERO_VECTOR3 = Vector3.new(0, 0, 0)
local TOUCH_SENSITIVTY = Vector2.new(0.002 * math.pi, 0.0015 * math.pi)
local MOUSE_SENSITIVITY = Vector2.new(0.002 * math.pi, 0.0015 * math.pi)
local MAX_TIME_FOR_DOUBLE_TAP = 1.5
local MAX_TAP_POS_DELTA = 15
local MAX_TAP_TIME_DELTA = 0.75
local SEAT_OFFSET = Vector3.new(0, 3.5, 0)
local VR_SEAT_OFFSET = Vector3.new(0, 4, 0)
local HEAD_OFFSET = Vector3.new(0, 1.5, 0)
local R15_HEAD_OFFSET = Vector3.new(0, 2, 0)
local bindAtPriorityFlagExists, bindAtPriorityFlagEnabled = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserPlayerScriptsBindAtPriority")
end)
local FFlagPlayerScriptsBindAtPriority = bindAtPriorityFlagExists and bindAtPriorityFlagEnabled
local Util = require(script.Parent:WaitForChild("CameraUtils"))
local ZoomController = require(script.Parent:WaitForChild("ZoomController"))
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local GuiService = game:GetService("GuiService")
local ContextActionService = game:GetService("ContextActionService")
local VRService = game:GetService("VRService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local BaseCamera = {}
BaseCamera.__index = BaseCamera
function BaseCamera.new()
	local self = setmetatable({}, BaseCamera)
	self.FIRST_PERSON_DISTANCE_THRESHOLD = FIRST_PERSON_DISTANCE_THRESHOLD
	self.cameraType = nil
	self.cameraMovementMode = nil
	local player = Players.LocalPlayer
	self.lastCameraTransform = nil
	self.rotateInput = ZERO_VECTOR2
	self.userPanningCamera = false
	self.lastUserPanCamera = tick()
	self.humanoidRootPart = nil
	self.humanoidCache = {}
	self.lastSubject = nil
	self.lastSubjectPosition = Vector3.new(0, 5, 0)
	self.defaultSubjectDistance = Util.Clamp(player.CameraMinZoomDistance, player.CameraMaxZoomDistance, DEFAULT_DISTANCE)
	self.currentSubjectDistance = Util.Clamp(player.CameraMinZoomDistance, player.CameraMaxZoomDistance, DEFAULT_DISTANCE)
	self.inFirstPerson = false
	self.inMouseLockedMode = false
	self.portraitMode = false
	self.enabled = false
	self.inputBeganConn = nil
	self.inputChangedConn = nil
	self.inputEndedConn = nil
	self.startPos = nil
	self.lastPos = nil
	self.panBeginLook = nil
	self.panEnabled = true
	self.keyPanEnabled = true
	self.distanceChangeEnabled = true
	self.PlayerGui = nil
	self.cameraChangedConn = nil
	self.viewportSizeChangedConn = nil
	self.boundContextActions = {}
	self.shouldUseVRRotation = false
	self.VRRotationIntensityAvailable = false
	self.lastVRRotationIntensityCheckTime = 0
	self.lastVRRotationTime = 0
	self.vrRotateKeyCooldown = {}
	self.cameraTranslationConstraints = Vector3.new(1, 1, 1)
	self.humanoidJumpOrigin = nil
	self.trackingHumanoid = nil
	self.cameraFrozen = false
	self.headHeightR15 = R15_HEAD_OFFSET
	self.heightScaleChangedConn = nil
	self.subjectStateChangedConn = nil
	self.humanoidChildAddedConn = nil
	self.humanoidChildRemovedConn = nil
	self.activeGamepad = nil
	self.gamepadPanningCamera = false
	self.lastThumbstickRotate = nil
	self.numOfSeconds = 0.7
	self.currentSpeed = 0
	self.maxSpeed = 6
	self.vrMaxSpeed = 4
	self.lastThumbstickPos = Vector2.new(0, 0)
	self.ySensitivity = 0.65
	self.lastVelocity = nil
	self.gamepadConnectedConn = nil
	self.gamepadDisconnectedConn = nil
	self.currentZoomSpeed = 1
	self.L3ButtonDown = false
	self.dpadLeftDown = false
	self.dpadRightDown = false
	self.isDynamicThumbstickEnabled = false
	self.fingerTouches = {}
	self.numUnsunkTouches = 0
	self.inputStartPositions = {}
	self.inputStartTimes = {}
	self.startingDiff = nil
	self.pinchBeginZoom = nil
	self.userPanningTheCamera = false
	self.touchActivateConn = nil
	self.mouseLockOffset = ZERO_VECTOR3
	if player.Character then
		self:OnCharacterAdded(player.Character)
	end
	player.CharacterAppearanceLoaded:Connect(function(char)
		self:OnCharacterAdded(char)
	end)
	if self.cameraChangedConn then
		self.cameraChangedConn:Disconnect()
	end
	self.cameraChangedConn = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
		self:OnCurrentCameraChanged()
	end)
	if self.playerCameraModeChangeConn then
		self.playerCameraModeChangeConn:Disconnect()
	end
	self.playerCameraModeChangeConn = player:GetPropertyChangedSignal("CameraMode"):Connect(function()
		self:OnPlayerCameraPropertyChange()
	end)
	if self.minDistanceChangeConn then
		self.minDistanceChangeConn:Disconnect()
	end
	self.minDistanceChangeConn = player:GetPropertyChangedSignal("CameraMinZoomDistance"):Connect(function()
		self:OnPlayerCameraPropertyChange()
	end)
	if self.maxDistanceChangeConn then
		self.maxDistanceChangeConn:Disconnect()
	end
	self.maxDistanceChangeConn = player:GetPropertyChangedSignal("CameraMaxZoomDistance"):Connect(function()
		self:OnPlayerCameraPropertyChange()
	end)
	if self.playerDevTouchMoveModeChangeConn then
		self.playerDevTouchMoveModeChangeConn:Disconnect()
	end
	self.playerDevTouchMoveModeChangeConn = player:GetPropertyChangedSignal("DevTouchMovementMode"):Connect(function()
		self:OnDevTouchMovementModeChanged()
	end)
	self:OnDevTouchMovementModeChanged()
	if self.gameSettingsTouchMoveMoveChangeConn then
		self.gameSettingsTouchMoveMoveChangeConn:Disconnect()
	end
	self.gameSettingsTouchMoveMoveChangeConn = UserGameSettings:GetPropertyChangedSignal("TouchMovementMode"):Connect(function()
		self:OnGameSettingsTouchMovementModeChanged()
	end)
	self:OnGameSettingsTouchMovementModeChanged()
	UserGameSettings:SetCameraYInvertVisible()
	UserGameSettings:SetGamepadCameraSensitivityVisible()
	self.hasGameLoaded = game:IsLoaded()
	if not self.hasGameLoaded then
		self.gameLoadedConn = game.Loaded:Connect(function()
			self.hasGameLoaded = true
			self.gameLoadedConn:Disconnect()
			self.gameLoadedConn = nil
		end)
	end
	return self
end
function BaseCamera:GetModuleName()
	return "BaseCamera"
end
function BaseCamera:OnCharacterAdded(char)
	if UserInputService.TouchEnabled then
		self.PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
		for _, child in ipairs(char:GetChildren()) do
			if child:IsA("Tool") then
				self.isAToolEquipped = true
			end
		end
		char.ChildAdded:Connect(function(child)
			if child:IsA("Tool") then
				self.isAToolEquipped = true
			end
		end)
		char.ChildRemoved:Connect(function(child)
			if child:IsA("Tool") then
				self.isAToolEquipped = false
			end
		end)
	end
end
function BaseCamera:GetHumanoidRootPart()
	if not self.humanoidRootPart then
		local player = Players.LocalPlayer
		if player.Character then
			local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				self.humanoidRootPart = humanoid.RootPart
			end
		end
	end
	return self.humanoidRootPart
end
function BaseCamera:GetBodyPartToFollow(humanoid, isDead)
	if humanoid:GetState() == Enum.HumanoidStateType.Dead then
		local character = humanoid.Parent
		if character and character:IsA("Model") then
			return character:FindFirstChild("Head") or humanoid.RootPart
		end
	end
	return humanoid.RootPart
end
function BaseCamera:GetSubjectPosition()
	local result = self.lastSubjectPosition
	local camera = game.Workspace.CurrentCamera
	local cameraSubject = camera and camera.CameraSubject
	if cameraSubject then
		if cameraSubject:IsA("Humanoid") then
			local humanoid = cameraSubject
			local humanoidIsDead = humanoid:GetState() == Enum.HumanoidStateType.Dead
			if VRService.VREnabled and humanoidIsDead and humanoid == self.lastSubject then
				result = self.lastSubjectPosition
			else
				local bodyPartToFollow = humanoid.RootPart
				bodyPartToFollow = humanoidIsDead and humanoid.Parent and humanoid.Parent:IsA("Model") and humanoid.Parent:FindFirstChild("Head") or bodyPartToFollow
				if bodyPartToFollow and bodyPartToFollow:IsA("BasePart") then
					local heightOffset = humanoid.RigType == Enum.HumanoidRigType.R15 and R15_HEAD_OFFSET or HEAD_OFFSET
					if humanoidIsDead then
						heightOffset = ZERO_VECTOR3
					end
					result = bodyPartToFollow.CFrame.p + bodyPartToFollow.CFrame:vectorToWorldSpace(heightOffset + humanoid.CameraOffset)
				end
			end
		elseif cameraSubject:IsA("VehicleSeat") then
			local offset = SEAT_OFFSET
			if VRService.VREnabled then
				offset = VR_SEAT_OFFSET
			end
			result = cameraSubject.CFrame.p + cameraSubject.CFrame:vectorToWorldSpace(offset)
		elseif cameraSubject:IsA("SkateboardPlatform") then
			result = cameraSubject.CFrame.p + SEAT_OFFSET
		elseif cameraSubject:IsA("BasePart") then
			result = cameraSubject.CFrame.p
		elseif cameraSubject:IsA("Model") then
			if cameraSubject.PrimaryPart then
				result = cameraSubject:GetPrimaryPartCFrame().p
			else
				result = cameraSubject:GetModelCFrame().p
			end
		end
	else
		return
	end
	self.lastSubject = cameraSubject
	self.lastSubjectPosition = result
	return result
end
function BaseCamera:UpdateDefaultSubjectDistance()
	local player = Players.LocalPlayer
	if self.portraitMode then
		self.defaultSubjectDistance = Util.Clamp(player.CameraMinZoomDistance, player.CameraMaxZoomDistance, PORTRAIT_DEFAULT_DISTANCE)
	else
		self.defaultSubjectDistance = Util.Clamp(player.CameraMinZoomDistance, player.CameraMaxZoomDistance, DEFAULT_DISTANCE)
	end
end
function BaseCamera:OnViewportSizeChanged()
	local camera = game.Workspace.CurrentCamera
	local size = camera.ViewportSize
	self.portraitMode = size.X < size.Y
	self:UpdateDefaultSubjectDistance()
end
function BaseCamera:OnCurrentCameraChanged()
	if UserInputService.TouchEnabled then
		if self.viewportSizeChangedConn then
			self.viewportSizeChangedConn:Disconnect()
			self.viewportSizeChangedConn = nil
		end
		local newCamera = game.Workspace.CurrentCamera
		if newCamera then
			self:OnViewportSizeChanged()
			self.viewportSizeChangedConn = newCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
				self:OnViewportSizeChanged()
			end)
		end
	end
	if self.cameraSubjectChangedConn then
		self.cameraSubjectChangedConn:Disconnect()
		self.cameraSubjectChangedConn = nil
	end
	local camera = game.Workspace.CurrentCamera
	if camera then
		self.cameraSubjectChangedConn = camera:GetPropertyChangedSignal("CameraSubject"):Connect(function()
			self:OnNewCameraSubject()
		end)
		self:OnNewCameraSubject()
	end
end
function BaseCamera:OnDynamicThumbstickEnabled()
	if UserInputService.TouchEnabled then
		self.isDynamicThumbstickEnabled = true
	end
end
function BaseCamera:OnDynamicThumbstickDisabled()
	self.isDynamicThumbstickEnabled = false
end
function BaseCamera:OnGameSettingsTouchMovementModeChanged()
	if Players.LocalPlayer.DevTouchMovementMode == Enum.DevTouchMovementMode.UserChoice then
		if UserGameSettings.TouchMovementMode.Name == "DynamicThumbstick" then
			self:OnDynamicThumbstickEnabled()
		else
			self:OnDynamicThumbstickDisabled()
		end
	end
end
function BaseCamera:OnDevTouchMovementModeChanged()
	if Players.LocalPlayer.DevTouchMovementMode.Name == "DynamicThumbstick" then
		self:OnDynamicThumbstickEnabled()
	else
		self:OnGameSettingsTouchMovementModeChanged()
	end
end
function BaseCamera:OnPlayerCameraPropertyChange()
	self:SetCameraToSubjectDistance(self.currentSubjectDistance)
end
function BaseCamera:GetCameraHeight()
	if VRService.VREnabled and not self.inFirstPerson then
		return math.sin(VR_ANGLE) * self.currentSubjectDistance
	end
	return 0
end
function BaseCamera:InputTranslationToCameraAngleChange(translationVector, sensitivity)
	local camera = game.Workspace.CurrentCamera
	if camera and camera.ViewportSize.X > 0 and 0 < camera.ViewportSize.Y and camera.ViewportSize.Y > camera.ViewportSize.X then
		return translationVector * Vector2.new(sensitivity.Y, sensitivity.X)
	end
	return translationVector * sensitivity
end
function BaseCamera:Enable(enable)
	if self.enabled ~= enable then
		self.enabled = enable
		if self.enabled then
			self:ConnectInputEvents()
			if FFlagPlayerScriptsBindAtPriority then
				self:BindContextActions()
			end
			if Players.LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then
				self.currentSubjectDistance = 0.5
				if not self.inFirstPerson then
					self:EnterFirstPerson()
				end
			end
		else
			self:DisconnectInputEvents()
			if FFlagPlayerScriptsBindAtPriority then
				self:UnbindContextActions()
			end
			self:Cleanup()
		end
	end
end
function BaseCamera:GetEnabled()
	return self.enabled
end
function BaseCamera:OnInputBegan(input, processed)
	if input.UserInputType == Enum.UserInputType.Touch then
		self:OnTouchBegan(input, processed)
	elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
		self:OnMouse2Down(input, processed)
	elseif input.UserInputType == Enum.UserInputType.MouseButton3 then
		self:OnMouse3Down(input, processed)
	end
	if not FFlagPlayerScriptsBindAtPriority and input.UserInputType == Enum.UserInputType.Keyboard then
		self:OnKeyDown(input, processed)
	end
end
function BaseCamera:OnInputChanged(input, processed)
	if input.UserInputType == Enum.UserInputType.Touch then
		self:OnTouchChanged(input, processed)
	elseif input.UserInputType == Enum.UserInputType.MouseMovement then
		self:OnMouseMoved(input, processed)
	elseif input.UserInputType == Enum.UserInputType.MouseWheel then
		self:OnMouseWheel(input, processed)
	end
end
function BaseCamera:OnInputEnded(input, processed)
	if input.UserInputType == Enum.UserInputType.Touch then
		self:OnTouchEnded(input, processed)
	elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
		self:OnMouse2Up(input, processed)
	elseif input.UserInputType == Enum.UserInputType.MouseButton3 then
		self:OnMouse3Up(input, processed)
	end
	if not FFlagPlayerScriptsBindAtPriority and input.UserInputType == Enum.UserInputType.Keyboard then
		self:OnKeyUp(input, processed)
	end
end
function BaseCamera:ConnectInputEvents()
	self.inputBeganConn = UserInputService.InputBegan:Connect(function(input, processed)
		self:OnInputBegan(input, processed)
	end)
	self.inputChangedConn = UserInputService.InputChanged:Connect(function(input, processed)
		self:OnInputChanged(input, processed)
	end)
	self.inputEndedConn = UserInputService.InputEnded:Connect(function(input, processed)
		self:OnInputEnded(input, processed)
	end)
	self.touchActivateConn = UserInputService.TouchTapInWorld:Connect(function(touchPos, processed)
		self:OnTouchTap(touchPos)
	end)
	self.menuOpenedConn = GuiService.MenuOpened:connect(function()
		self:ResetInputStates()
	end)
	self.gamepadConnectedConn = UserInputService.GamepadDisconnected:connect(function(gamepadEnum)
		if self.activeGamepad ~= gamepadEnum then
			return
		end
		self.activeGamepad = nil
		self:AssignActivateGamepad()
	end)
	self.gamepadDisconnectedConn = UserInputService.GamepadConnected:connect(function(gamepadEnum)
		if self.activeGamepad == nil then
			self:AssignActivateGamepad()
		end
	end)
	if not FFlagPlayerScriptsBindAtPriority then
		self:BindGamepadInputActions()
	end
	self:AssignActivateGamepad()
	self:UpdateMouseBehavior()
end
function BaseCamera:BindContextActions()
	self:BindGamepadInputActions()
	self:BindKeyboardInputActions()
end
function BaseCamera:AssignActivateGamepad()
	local connectedGamepads = UserInputService:GetConnectedGamepads()
	if #connectedGamepads > 0 then
		for i = 1, #connectedGamepads do
			if self.activeGamepad == nil then
				self.activeGamepad = connectedGamepads[i]
			elseif connectedGamepads[i].Value < self.activeGamepad.Value then
				self.activeGamepad = connectedGamepads[i]
			end
		end
	end
	if self.activeGamepad == nil then
		self.activeGamepad = Enum.UserInputType.Gamepad1
	end
end
function BaseCamera:DisconnectInputEvents()
	if self.inputBeganConn then
		self.inputBeganConn:Disconnect()
		self.inputBeganConn = nil
	end
	if self.inputChangedConn then
		self.inputChangedConn:Disconnect()
		self.inputChangedConn = nil
	end
	if self.inputEndedConn then
		self.inputEndedConn:Disconnect()
		self.inputEndedConn = nil
	end
end
function BaseCamera:UnbindContextActions()
	for i = 1, #self.boundContextActions do
		ContextActionService:UnbindAction(self.boundContextActions[i])
	end
	self.boundContextActions = {}
end
function BaseCamera:Cleanup()
	if self.menuOpenedConn then
		self.menuOpenedConn:Disconnect()
		self.menuOpenedConn = nil
	end
	if self.mouseLockToggleConn then
		self.mouseLockToggleConn:Disconnect()
		self.mouseLockToggleConn = nil
	end
	if self.gamepadConnectedConn then
		self.gamepadConnectedConn:Disconnect()
		self.gamepadConnectedConn = nil
	end
	if self.gamepadDisconnectedConn then
		self.gamepadDisconnectedConn:Disconnect()
		self.gamepadDisconnectedConn = nil
	end
	if self.subjectStateChangedConn then
		self.subjectStateChangedConn:Disconnect()
		self.subjectStateChangedConn = nil
	end
	if self.viewportSizeChangedConn then
		self.viewportSizeChangedConn:Disconnect()
		self.viewportSizeChangedConn = nil
	end
	if self.touchActivateConn then
		self.touchActivateConn:Disconnect()
		self.touchActivateConn = nil
	end
	self.turningLeft = false
	self.turningRight = false
	self.lastCameraTransform = nil
	self.lastSubjectCFrame = nil
	self.userPanningTheCamera = false
	self.rotateInput = Vector2.new()
	self.gamepadPanningCamera = Vector2.new(0, 0)
	self.startPos = nil
	self.lastPos = nil
	self.panBeginLook = nil
	self.isRightMouseDown = false
	self.isMiddleMouseDown = false
	self.fingerTouches = {}
	self.numUnsunkTouches = 0
	self.startingDiff = nil
	self.pinchBeginZoom = nil
	if UserInputService.MouseBehavior ~= Enum.MouseBehavior.LockCenter then
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
	end
end
function BaseCamera:ResetInputStates()
	self.isRightMouseDown = false
	self.isMiddleMouseDown = false
	self:OnMousePanButtonReleased()
	if UserInputService.TouchEnabled then
		for inputObject in pairs(self.fingerTouches) do
			self.fingerTouches[inputObject] = nil
		end
		self.panBeginLook = nil
		self.startPos = nil
		self.lastPos = nil
		self.userPanningTheCamera = false
		self.startingDiff = nil
		self.pinchBeginZoom = nil
		self.numUnsunkTouches = 0
	end
end
function BaseCamera:GetGamepadPan(name, state, input)
	if input.UserInputType == self.activeGamepad and input.KeyCode == Enum.KeyCode.Thumbstick2 then
		if state == Enum.UserInputState.Cancel then
			self.gamepadPanningCamera = ZERO_VECTOR2
			return
		end
		local inputVector = Vector2.new(input.Position.X, -input.Position.Y)
		if inputVector.magnitude > THUMBSTICK_DEADZONE then
			self.gamepadPanningCamera = Vector2.new(input.Position.X, -input.Position.Y)
		else
			self.gamepadPanningCamera = ZERO_VECTOR2
		end
		if FFlagPlayerScriptsBindAtPriority then
			return Enum.ContextActionResult.Sink
		end
	end
	if FFlagPlayerScriptsBindAtPriority then
		return Enum.ContextActionResult.Pass
	end
end
function BaseCamera:DoKeyboardPanTurn(name, state, input)
	if not self.hasGameLoaded and VRService.VREnabled then
		return Enum.ContextActionResult.Pass
	end
	if state == Enum.UserInputState.Cancel then
		self.turningLeft = false
		self.turningRight = false
		return Enum.ContextActionResult.Sink
	end
	if self.panBeginLook == nil and self.keyPanEnabled then
		if input.KeyCode == Enum.KeyCode.Left then
			self.turningLeft = state == Enum.UserInputState.Begin
		elseif input.KeyCode == Enum.KeyCode.Right then
			self.turningRight = state == Enum.UserInputState.Begin
		end
		return Enum.ContextActionResult.Sink
	end
	return Enum.ContextActionResult.Pass
end
function BaseCamera:DoPanRotateCamera(rotateAngle)
	local angle = Util.RotateVectorByAngleAndRound(self:GetCameraLookVector() * Vector3.new(1, 0, 1), rotateAngle, math.pi * 0.25)
	if angle ~= 0 then
		self.rotateInput = self.rotateInput + Vector2.new(angle, 0)
		self.lastUserPanCamera = tick()
		self.lastCameraTransform = nil
	end
end
function BaseCamera:DoKeyboardPan(name, state, input)
	if not self.hasGameLoaded and VRService.VREnabled then
		return Enum.ContextActionResult.Pass
	end
	if state ~= Enum.UserInputState.Begin then
		return Enum.ContextActionResult.Pass
	end
	if self.panBeginLook == nil and self.keyPanEnabled then
		if input.KeyCode == Enum.KeyCode.Comma then
			self:DoPanRotateCamera(-math.pi * 0.1875)
		elseif input.KeyCode == Enum.KeyCode.Period then
			self:DoPanRotateCamera(math.pi * 0.1875)
		elseif input.KeyCode == Enum.KeyCode.PageUp then
			self.rotateInput = self.rotateInput + Vector2.new(0, math.rad(15))
			self.lastCameraTransform = nil
		elseif input.KeyCode == Enum.KeyCode.PageDown then
			self.rotateInput = self.rotateInput + Vector2.new(0, math.rad(-15))
			self.lastCameraTransform = nil
		end
		return Enum.ContextActionResult.Sink
	end
	return Enum.ContextActionResult.Pass
end
function BaseCamera:DoGamepadZoom(name, state, input)
	if input.UserInputType == self.activeGamepad then
		if input.KeyCode == Enum.KeyCode.ButtonR3 then
			if state == Enum.UserInputState.Begin and self.distanceChangeEnabled then
				if self:GetCameraToSubjectDistance() > 0.5 then
					self:SetCameraToSubjectDistance(0)
				else
					self:SetCameraToSubjectDistance(10)
				end
			end
		elseif input.KeyCode == Enum.KeyCode.DPadLeft then
			self.dpadLeftDown = state == Enum.UserInputState.Begin
		elseif input.KeyCode == Enum.KeyCode.DPadRight then
			self.dpadRightDown = state == Enum.UserInputState.Begin
		end
		if self.dpadLeftDown then
			self.currentZoomSpeed = 1.04
		elseif self.dpadRightDown then
			self.currentZoomSpeed = 0.96
		else
			self.currentZoomSpeed = 1
		end
		if FFlagPlayerScriptsBindAtPriority then
			return Enum.ContextActionResult.Sink
		end
	end
	if FFlagPlayerScriptsBindAtPriority then
		return Enum.ContextActionResult.Pass
	end
end
function BaseCamera:DoKeyboardZoom(name, state, input)
	if not self.hasGameLoaded and VRService.VREnabled then
		return Enum.ContextActionResult.Pass
	end
	if state ~= Enum.UserInputState.Begin then
		return Enum.ContextActionResult.Pass
	end
	if self.distanceChangeEnabled then
		if input.KeyCode == Enum.KeyCode.I then
			self:SetCameraToSubjectDistance(self.currentSubjectDistance - 5)
		elseif input.KeyCode == Enum.KeyCode.O then
			self:SetCameraToSubjectDistance(self.currentSubjectDistance + 5)
		end
		return Enum.ContextActionResult.Sink
	end
	return Enum.ContextActionResult.Pass
end
function BaseCamera:BindAction(actionName, actionFunc, createTouchButton, ...)
	table.insert(self.boundContextActions, actionName)
	ContextActionService:BindActionAtPriority(actionName, actionFunc, createTouchButton, CAMERA_ACTION_PRIORITY, ...)
end
function BaseCamera:BindGamepadInputActions()
	if FFlagPlayerScriptsBindAtPriority then
		self:BindAction("BaseCameraGamepadPan", function(name, state, input)
			return self:GetGamepadPan(name, state, input)
		end, false, Enum.KeyCode.Thumbstick2)
		self:BindAction("BaseCameraGamepadZoom", function(name, state, input)
			return self:DoGamepadZoom(name, state, input)
		end, false, Enum.KeyCode.DPadLeft, Enum.KeyCode.DPadRight, Enum.KeyCode.ButtonR3)
	else
		ContextActionService:BindAction("RootCamGamepadPan", function(name, state, input)
			self:GetGamepadPan(name, state, input)
		end, false, Enum.KeyCode.Thumbstick2)
		ContextActionService:BindAction("RootCamGamepadZoom", function(name, state, input)
			self:DoGamepadZoom(name, state, input)
		end, false, Enum.KeyCode.ButtonR3)
		ContextActionService:BindAction("RootGamepadZoomOut", function(name, state, input)
			self:DoGamepadZoom(name, state, input)
		end, false, Enum.KeyCode.DPadLeft)
		ContextActionService:BindAction("RootGamepadZoomIn", function(name, state, input)
			self:DoGamepadZoom(name, state, input)
		end, false, Enum.KeyCode.DPadRight)
	end
end
function BaseCamera:BindKeyboardInputActions()
	self:BindAction("BaseCameraKeyboardPanArrowKeys", function(name, state, input)
		return self:DoKeyboardPanTurn(name, state, input)
	end, false, Enum.KeyCode.Left, Enum.KeyCode.Right)
	self:BindAction("BaseCameraKeyboardPan", function(name, state, input)
		return self:DoKeyboardPan(name, state, input)
	end, false, Enum.KeyCode.Comma, Enum.KeyCode.Period, Enum.KeyCode.PageUp, Enum.KeyCode.PageDown)
	self:BindAction("BaseCameraKeyboardZoom", function(name, state, input)
		return self:DoKeyboardZoom(name, state, input)
	end, false, Enum.KeyCode.I, Enum.KeyCode.O)
end
function BaseCamera:OnTouchBegan(input, processed)
	local canUseDynamicTouch = self.isDynamicThumbstickEnabled and not processed
	if canUseDynamicTouch then
		self.fingerTouches[input] = processed
		if not processed then
			self.inputStartPositions[input] = input.Position
			self.inputStartTimes[input] = tick()
			self.numUnsunkTouches = self.numUnsunkTouches + 1
		end
	end
end
function BaseCamera:OnTouchChanged(input, processed)
	if self.fingerTouches[input] == nil then
		if self.isDynamicThumbstickEnabled then
			return
		end
		self.fingerTouches[input] = processed
		if not processed then
			self.numUnsunkTouches = self.numUnsunkTouches + 1
		end
	end
	if self.numUnsunkTouches == 1 then
		if self.fingerTouches[input] == false then
			self.panBeginLook = self.panBeginLook or self:GetCameraLookVector()
			self.startPos = self.startPos or input.Position
			self.lastPos = self.lastPos or self.startPos
			self.userPanningTheCamera = true
			local delta = input.Position - self.lastPos
			delta = Vector2.new(delta.X, delta.Y * UserGameSettings:GetCameraYInvertValue())
			if self.panEnabled then
				local desiredXYVector = self:InputTranslationToCameraAngleChange(delta, TOUCH_SENSITIVTY)
				self.rotateInput = self.rotateInput + desiredXYVector
			end
			self.lastPos = input.Position
		end
	else
		self.panBeginLook = nil
		self.startPos = nil
		self.lastPos = nil
		self.userPanningTheCamera = false
	end
	if self.numUnsunkTouches == 2 then
		local unsunkTouches = {}
		for touch, wasSunk in pairs(self.fingerTouches) do
			if not wasSunk then
				table.insert(unsunkTouches, touch)
			end
		end
		if #unsunkTouches == 2 then
			local difference = (unsunkTouches[1].Position - unsunkTouches[2].Position).magnitude
			if self.startingDiff and self.pinchBeginZoom then
				local scale = difference / math.max(0.01, self.startingDiff)
				local clampedScale = Util.Clamp(0.1, 10, scale)
				if self.distanceChangeEnabled then
					self:SetCameraToSubjectDistance(self.pinchBeginZoom / clampedScale)
				end
			else
				self.startingDiff = difference
				self.pinchBeginZoom = self:GetCameraToSubjectDistance()
			end
		end
	else
		self.startingDiff = nil
		self.pinchBeginZoom = nil
	end
end
function BaseCamera:CalcLookBehindRotateInput()
	if not self.humanoidRootPart or not game.Workspace.CurrentCamera then
		return nil
	end
	local cameraLookVector = game.Workspace.CurrentCamera.CFrame.lookVector
	local newDesiredLook = (self.humanoidRootPart.CFrame.lookVector - Vector3.new(0, 0.23, 0)).unit
	local horizontalShift = Util.GetAngleBetweenXZVectors(newDesiredLook, cameraLookVector)
	local vertShift = math.asin(cameraLookVector.Y) - math.asin(newDesiredLook.Y)
	if not Util.IsFinite(horizontalShift) then
		horizontalShift = 0
	end
	if not Util.IsFinite(vertShift) then
		vertShift = 0
	end
	return Vector2.new(horizontalShift, vertShift)
end
function BaseCamera:OnTouchTap(position)
	if self.isDynamicThumbstickEnabled and not self.isAToolEquipped then
		if self.lastTapTime and tick() - self.lastTapTime < MAX_TIME_FOR_DOUBLE_TAP then
			self:SetCameraToSubjectDistance(self.defaultSubjectDistance)
		elseif self.humanoidRootPart then
			self.rotateInput = self:CalcLookBehindRotateInput()
		end
		self.lastTapTime = tick()
	end
end
function BaseCamera:IsTouchTap(input)
	if self.inputStartPositions[input] then
		local posDelta = (self.inputStartPositions[input] - input.Position).magnitude
		if posDelta < MAX_TAP_POS_DELTA then
			local timeDelta = self.inputStartTimes[input] - tick()
			if timeDelta < MAX_TAP_TIME_DELTA then
				return true
			end
		end
	end
	return false
end
function BaseCamera:OnTouchEnded(input, processed)
	if self.fingerTouches[input] == false then
		if self.numUnsunkTouches == 1 then
			self.panBeginLook = nil
			self.startPos = nil
			self.lastPos = nil
			self.userPanningTheCamera = false
			if self:IsTouchTap(input) then
				self:OnTouchTap(input.Position)
			end
		elseif self.numUnsunkTouches == 2 then
			self.startingDiff = nil
			self.pinchBeginZoom = nil
		end
	end
	if self.fingerTouches[input] ~= nil and self.fingerTouches[input] == false then
		self.numUnsunkTouches = self.numUnsunkTouches - 1
	end
	self.fingerTouches[input] = nil
	self.inputStartPositions[input] = nil
	self.inputStartTimes[input] = nil
end
function BaseCamera:OnMouse2Down(input, processed)
	if processed then
		return
	end
	self.isRightMouseDown = true
	self:OnMousePanButtonPressed(input, processed)
end
function BaseCamera:OnMouse2Up(input, processed)
	self.isRightMouseDown = false
	self:OnMousePanButtonReleased(input, processed)
end
function BaseCamera:OnMouse3Down(input, processed)
	if processed then
		return
	end
	self.isMiddleMouseDown = true
	self:OnMousePanButtonPressed(input, processed)
end
function BaseCamera:OnMouse3Up(input, processed)
	self.isMiddleMouseDown = false
	self:OnMousePanButtonReleased(input, processed)
end
function BaseCamera:OnMouseMoved(input, processed)
	if not self.hasGameLoaded and VRService.VREnabled then
		return
	end
	local inputDelta = input.Delta
	inputDelta = Vector2.new(inputDelta.X, inputDelta.Y * UserGameSettings:GetCameraYInvertValue())
	if self.panEnabled and (self.startPos and self.lastPos and self.panBeginLook or self.inFirstPerson or self.inMouseLockedMode) then
		local desiredXYVector = self:InputTranslationToCameraAngleChange(inputDelta, MOUSE_SENSITIVITY)
		self.rotateInput = self.rotateInput + desiredXYVector
	end
	if self.startPos and self.lastPos and self.panBeginLook then
		self.lastPos = self.lastPos + input.Delta
	end
end
function BaseCamera:OnMousePanButtonPressed(input, processed)
	if processed then
		return
	end
	self:UpdateMouseBehavior()
	self.panBeginLook = self.panBeginLook or self:GetCameraLookVector()
	self.startPos = self.startPos or input.Position
	self.lastPos = self.lastPos or self.startPos
	self.userPanningTheCamera = true
end
function BaseCamera:OnMousePanButtonReleased(input, processed)
	self:UpdateMouseBehavior()
	if not self.isRightMouseDown and not self.isMiddleMouseDown then
		self.panBeginLook = nil
		self.startPos = nil
		self.lastPos = nil
		self.userPanningTheCamera = false
	end
end
function BaseCamera:OnMouseWheel(input, processed)
	if not self.hasGameLoaded and VRService.VREnabled then
		return
	end
	if not processed and self.distanceChangeEnabled then
		local wheelInput = Util.Clamp(-1, 1, -input.Position.Z)
		local newDistance
		if self.inFirstPerson and wheelInput > 0 then
			newDistance = FIRST_PERSON_DISTANCE_THRESHOLD
		else
			newDistance = self.currentSubjectDistance + 0.156 * self.currentSubjectDistance * wheelInput + 1.7 * math.sign(wheelInput)
		end
		self:SetCameraToSubjectDistance(newDistance)
	end
end
function BaseCamera:OnKeyDown(input, processed)
	if not self.hasGameLoaded and VRService.VREnabled then
		return
	end
	if processed then
		return
	end
	if self.distanceChangeEnabled then
		if input.KeyCode == Enum.KeyCode.I then
			self:SetCameraToSubjectDistance(self.currentSubjectDistance - 5)
		elseif input.KeyCode == Enum.KeyCode.O then
			self:SetCameraToSubjectDistance(self.currentSubjectDistance + 5)
		end
	end
	if self.panBeginLook == nil and self.keyPanEnabled then
		if input.KeyCode == Enum.KeyCode.Left then
			self.turningLeft = true
		elseif input.KeyCode == Enum.KeyCode.Right then
			self.turningRight = true
		elseif input.KeyCode == Enum.KeyCode.Comma then
			local angle = Util.RotateVectorByAngleAndRound(self:GetCameraLookVector() * Vector3.new(1, 0, 1), -math.pi * 0.1875, math.pi * 0.25)
			if angle ~= 0 then
				self.rotateInput = self.rotateInput + Vector2.new(angle, 0)
				self.lastUserPanCamera = tick()
				self.lastCameraTransform = nil
			end
		elseif input.KeyCode == Enum.KeyCode.Period then
			local angle = Util.RotateVectorByAngleAndRound(self:GetCameraLookVector() * Vector3.new(1, 0, 1), math.pi * 0.1875, math.pi * 0.25)
			if angle ~= 0 then
				self.rotateInput = self.rotateInput + Vector2.new(angle, 0)
				self.lastUserPanCamera = tick()
				self.lastCameraTransform = nil
			end
		elseif input.KeyCode == Enum.KeyCode.PageUp then
			self.rotateInput = self.rotateInput + Vector2.new(0, math.rad(15))
			self.lastCameraTransform = nil
		elseif input.KeyCode == Enum.KeyCode.PageDown then
			self.rotateInput = self.rotateInput + Vector2.new(0, math.rad(-15))
			self.lastCameraTransform = nil
		end
	end
end
function BaseCamera:OnKeyUp(input, processed)
	if input.KeyCode == Enum.KeyCode.Left then
		self.turningLeft = false
	elseif input.KeyCode == Enum.KeyCode.Right then
		self.turningRight = false
	end
end
function BaseCamera:UpdateMouseBehavior()
	if self.inFirstPerson or self.inMouseLockedMode then
		pcall(function()
			UserGameSettings.RotationType = Enum.RotationType.CameraRelative
		end)
		if UserInputService.MouseBehavior ~= Enum.MouseBehavior.LockCenter then
			UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
		end
	else
		pcall(function()
			UserGameSettings.RotationType = Enum.RotationType.MovementRelative
		end)
		if self.isRightMouseDown or self.isMiddleMouseDown then
			UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
		else
			UserInputService.MouseBehavior = Enum.MouseBehavior.Default
		end
	end
end
function BaseCamera:UpdateForDistancePropertyChange()
	self:SetCameraToSubjectDistance(self.currentSubjectDistance)
end
function BaseCamera:SetCameraToSubjectDistance(desiredSubjectDistance)
	local player = Players.LocalPlayer
	local lastSubjectDistance = self.currentSubjectDistance
	if player.CameraMode == Enum.CameraMode.LockFirstPerson then
		self.currentSubjectDistance = 0.5
		if not self.inFirstPerson then
			self:EnterFirstPerson()
		end
	else
		local newSubjectDistance = Util.Clamp(player.CameraMinZoomDistance, player.CameraMaxZoomDistance, desiredSubjectDistance)
		if newSubjectDistance < FIRST_PERSON_DISTANCE_THRESHOLD then
			self.currentSubjectDistance = 0.5
			if not self.inFirstPerson then
				self:EnterFirstPerson()
			end
		else
			self.currentSubjectDistance = newSubjectDistance
			if self.inFirstPerson then
				self:LeaveFirstPerson()
			end
		end
	end
	ZoomController.SetZoomParameters(self.currentSubjectDistance, math.sign(desiredSubjectDistance - lastSubjectDistance))
	return self.currentSubjectDistance
end
function BaseCamera:SetCameraType(cameraType)
	self.cameraType = cameraType
end
function BaseCamera:GetCameraType()
	return self.cameraType
end
function BaseCamera:SetCameraMovementMode(cameraMovementMode)
	self.cameraMovementMode = cameraMovementMode
end
function BaseCamera:GetCameraMovementMode()
	return self.cameraMovementMode
end
function BaseCamera:SetIsMouseLocked(mouseLocked)
	self.inMouseLockedMode = mouseLocked
	self:UpdateMouseBehavior()
end
function BaseCamera:GetIsMouseLocked()
	return self.inMouseLockedMode
end
function BaseCamera:SetMouseLockOffset(offsetVector)
	self.mouseLockOffset = offsetVector
end
function BaseCamera:GetMouseLockOffset()
	return self.mouseLockOffset
end
function BaseCamera:InFirstPerson()
	return self.inFirstPerson
end
function BaseCamera:EnterFirstPerson()
end
function BaseCamera:LeaveFirstPerson()
end
function BaseCamera:GetCameraToSubjectDistance()
	return self.currentSubjectDistance
end
function BaseCamera:GetMeasuredDistanceToFocus()
	local camera = game.Workspace.CurrentCamera
	if camera then
		return (camera.CoordinateFrame.p - camera.Focus.p).magnitude
	end
	return nil
end
function BaseCamera:GetCameraLookVector()
	return game.Workspace.CurrentCamera and game.Workspace.CurrentCamera.CFrame.lookVector or UNIT_Z
end
function BaseCamera:CalculateNewLookCFrame(suppliedLookVector)
	local currLookVector = suppliedLookVector or self:GetCameraLookVector()
	local currPitchAngle = math.asin(currLookVector.y)
	local yTheta = Util.Clamp(-MAX_Y + currPitchAngle, -MIN_Y + currPitchAngle, self.rotateInput.y)
	local constrainedRotateInput = Vector2.new(self.rotateInput.x, yTheta)
	local startCFrame = CFrame.new(ZERO_VECTOR3, currLookVector)
	local newLookCFrame = CFrame.Angles(0, -constrainedRotateInput.x, 0) * startCFrame * CFrame.Angles(-constrainedRotateInput.y, 0, 0)
	return newLookCFrame
end
function BaseCamera:CalculateNewLookVector(suppliedLookVector)
	local newLookCFrame = self:CalculateNewLookCFrame(suppliedLookVector)
	return newLookCFrame.lookVector
end
function BaseCamera:CalculateNewLookVectorVR()
	local subjectPosition = self:GetSubjectPosition()
	local vecToSubject = subjectPosition - game.Workspace.CurrentCamera.CFrame.p
	local currLookVector = (vecToSubject * X1_Y0_Z1).unit
	local vrRotateInput = Vector2.new(self.rotateInput.x, 0)
	local startCFrame = CFrame.new(ZERO_VECTOR3, currLookVector)
	local yawRotatedVector = (CFrame.Angles(0, -vrRotateInput.x, 0) * startCFrame * CFrame.Angles(-vrRotateInput.y, 0, 0)).lookVector
	return (yawRotatedVector * X1_Y0_Z1).unit
end
function BaseCamera:GetHumanoid()
	local player = Players.LocalPlayer
	local character = player and player.Character
	if character then
		local resultHumanoid = self.humanoidCache[player]
		if resultHumanoid and resultHumanoid.Parent == character then
			return resultHumanoid
		else
			self.humanoidCache[player] = nil
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				self.humanoidCache[player] = humanoid
			end
			return humanoid
		end
	end
	return nil
end
function BaseCamera:GetHumanoidPartToFollow(humanoid, humanoidStateType)
	if humanoidStateType == Enum.HumanoidStateType.Dead then
		local character = humanoid.Parent
		if character then
			return character:FindFirstChild("Head") or humanoid.Torso
		else
			return humanoid.Torso
		end
	else
		return humanoid.Torso
	end
end
function BaseCamera:UpdateGamepad()
	local gamepadPan = self.gamepadPanningCamera
	if gamepadPan and (self.hasGameLoaded or not VRService.VREnabled) then
		gamepadPan = Util.GamepadLinearToCurve(gamepadPan)
		local currentTime = tick()
		if gamepadPan.X ~= 0 or gamepadPan.Y ~= 0 then
			self.userPanningTheCamera = true
		elseif gamepadPan == ZERO_VECTOR2 then
			self.lastThumbstickRotate = nil
			if self.lastThumbstickPos == ZERO_VECTOR2 then
				self.currentSpeed = 0
			end
		end
		local finalConstant = 0
		if self.lastThumbstickRotate then
			if VRService.VREnabled then
				self.currentSpeed = self.vrMaxSpeed
			else
				local elapsedTime = (currentTime - self.lastThumbstickRotate) * 10
				self.currentSpeed = self.currentSpeed + self.maxSpeed * (elapsedTime * elapsedTime / self.numOfSeconds)
				if self.currentSpeed > self.maxSpeed then
					self.currentSpeed = self.maxSpeed
				end
				if self.lastVelocity then
					local velocity = (gamepadPan - self.lastThumbstickPos) / (currentTime - self.lastThumbstickRotate)
					local velocityDeltaMag = (velocity - self.lastVelocity).magnitude
					if velocityDeltaMag > 12 then
						self.currentSpeed = self.currentSpeed * (20 / velocityDeltaMag)
						if self.currentSpeed > self.maxSpeed then
							self.currentSpeed = self.maxSpeed
						end
					end
				end
			end
			local success, gamepadCameraSensitivity = pcall(function()
				return UserGameSettings.GamepadCameraSensitivity
			end)
			finalConstant = success and gamepadCameraSensitivity * self.currentSpeed or self.currentSpeed
			self.lastVelocity = (gamepadPan - self.lastThumbstickPos) / (currentTime - self.lastThumbstickRotate)
		end
		self.lastThumbstickPos = gamepadPan
		self.lastThumbstickRotate = currentTime
		return Vector2.new(gamepadPan.X * finalConstant, gamepadPan.Y * finalConstant * self.ySensitivity * UserGameSettings:GetCameraYInvertValue())
	end
	return ZERO_VECTOR2
end
function BaseCamera:ApplyVRTransform()
	if not VRService.VREnabled then
		return
	end
	local rootJoint = self.humanoidRootPart and self.humanoidRootPart:FindFirstChild("RootJoint")
	if not rootJoint then
		return
	end
	local cameraSubject = game.Workspace.CurrentCamera.CameraSubject
	local isInVehicle = cameraSubject and cameraSubject:IsA("VehicleSeat")
	if self.inFirstPerson and not isInVehicle then
		local vrFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
		local vrRotation = vrFrame - vrFrame.p
		rootJoint.C0 = CFrame.new(vrRotation:vectorToObjectSpace(vrFrame.p)) * CFrame.new(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0)
	else
		rootJoint.C0 = CFrame.new(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0)
	end
end
function BaseCamera:IsInFirstPerson()
	return self.inFirstPerson
end
function BaseCamera:ShouldUseVRRotation()
	if not VRService.VREnabled then
		return false
	end
	if not self.VRRotationIntensityAvailable and tick() - self.lastVRRotationIntensityCheckTime < 1 then
		return false
	end
	local success, vrRotationIntensity = pcall(function()
		return StarterGui:GetCore("VRRotationIntensity")
	end)
	self.VRRotationIntensityAvailable = success and vrRotationIntensity ~= nil
	self.lastVRRotationIntensityCheckTime = tick()
	self.shouldUseVRRotation = success and vrRotationIntensity ~= nil and vrRotationIntensity ~= "Smooth"
	return self.shouldUseVRRotation
end
function BaseCamera:GetVRRotationInput()
	local vrRotateSum = ZERO_VECTOR2
	local success, vrRotationIntensity = pcall(function()
		return StarterGui:GetCore("VRRotationIntensity")
	end)
	if not success then
		return
	end
	local vrGamepadRotation = self.GamepadPanningCamera or ZERO_VECTOR2
	local delayExpired = tick() - self.lastVRRotationTime >= self:GetRepeatDelayValue(vrRotationIntensity)
	if math.abs(vrGamepadRotation.x) >= self:GetActivateValue() then
		if delayExpired or not self.vrRotateKeyCooldown[Enum.KeyCode.Thumbstick2] then
			local sign = 1
			if vrGamepadRotation.x < 0 then
				sign = -1
			end
			vrRotateSum = vrRotateSum + self:GetRotateAmountValue(vrRotationIntensity) * sign
			self.vrRotateKeyCooldown[Enum.KeyCode.Thumbstick2] = true
		end
	elseif math.abs(vrGamepadRotation.x) < self:GetActivateValue() - 0.1 then
		self.vrRotateKeyCooldown[Enum.KeyCode.Thumbstick2] = nil
	end
	if self.turningLeft then
		if delayExpired or not self.vrRotateKeyCooldown[Enum.KeyCode.Left] then
			vrRotateSum = vrRotateSum - self:GetRotateAmountValue(vrRotationIntensity)
			self.vrRotateKeyCooldown[Enum.KeyCode.Left] = true
		end
	else
		self.vrRotateKeyCooldown[Enum.KeyCode.Left] = nil
	end
	if self.turningRight then
		if delayExpired or not self.vrRotateKeyCooldown[Enum.KeyCode.Right] then
			vrRotateSum = vrRotateSum + self:GetRotateAmountValue(vrRotationIntensity)
			self.vrRotateKeyCooldown[Enum.KeyCode.Right] = true
		end
	else
		self.vrRotateKeyCooldown[Enum.KeyCode.Right] = nil
	end
	if vrRotateSum ~= ZERO_VECTOR2 then
		self.lastVRRotationTime = tick()
	end
	return vrRotateSum
end
function BaseCamera:CancelCameraFreeze(keepConstraints)
	if not keepConstraints then
		self.cameraTranslationConstraints = Vector3.new(self.cameraTranslationConstraints.x, 1, self.cameraTranslationConstraints.z)
	end
	if self.cameraFrozen then
		self.trackingHumanoid = nil
		self.cameraFrozen = false
	end
end
function BaseCamera:StartCameraFreeze(subjectPosition, humanoidToTrack)
	if not self.cameraFrozen then
		self.humanoidJumpOrigin = subjectPosition
		self.trackingHumanoid = humanoidToTrack
		self.cameraTranslationConstraints = Vector3.new(self.cameraTranslationConstraints.x, 0, self.cameraTranslationConstraints.z)
		self.cameraFrozen = true
	end
end
function BaseCamera:RescaleCameraOffset(newScaleFactor)
	self.headHeightR15 = R15_HEAD_OFFSET * newScaleFactor
end
function BaseCamera:OnHumanoidSubjectChildAdded(child)
	if child.Name == "BodyHeightScale" and child:IsA("NumberValue") then
		if self.heightScaleChangedConn then
			self.heightScaleChangedConn:Disconnect()
		end
		self.heightScaleChangedConn = child.Changed:Connect(function(newScaleFactor)
			self:RescaleCameraOffset(newScaleFactor)
		end)
		self:RescaleCameraOffset(child.Value)
	end
end
function BaseCamera:OnHumanoidSubjectChildRemoved(child)
	if child.Name == "BodyHeightScale" then
		self:RescaleCameraOffset(1)
		if self.heightScaleChangedConn then
			self.heightScaleChangedConn:Disconnect()
			self.heightScaleChangedConn = nil
		end
	end
end
function BaseCamera:OnNewCameraSubject()
	if self.subjectStateChangedConn then
		self.subjectStateChangedConn:Disconnect()
		self.subjectStateChangedConn = nil
	end
	if self.humanoidChildAddedConn then
		self.humanoidChildAddedConn:Disconnect()
		self.humanoidChildAddedConn = nil
	end
	if self.humanoidChildRemovedConn then
		self.humanoidChildRemovedConn:Disconnect()
		self.humanoidChildRemovedConn = nil
	end
	if self.heightScaleChangedConn then
		self.heightScaleChangedConn:Disconnect()
		self.heightScaleChangedConn = nil
	end
	local humanoid = workspace.CurrentCamera and workspace.CurrentCamera.CameraSubject
	if self.trackingHumanoid ~= humanoid then
		self:CancelCameraFreeze()
	end
	if humanoid and humanoid:IsA("Humanoid") then
		self.humanoidChildAddedConn = humanoid.ChildAdded:Connect(function(child)
			self:OnHumanoidSubjectChildAdded(child)
		end)
		self.humanoidChildRemovedConn = humanoid.ChildRemoved:Connect(function(child)
			self:OnHumanoidSubjectChildRemoved(child)
		end)
		for _, child in pairs(humanoid:GetChildren()) do
			self:OnHumanoidSubjectChildAdded(child)
		end
		self.subjectStateChangedConn = humanoid.StateChanged:Connect(function(oldState, newState)
			if VRService.VREnabled and newState == Enum.HumanoidStateType.Jumping and not self.inFirstPerson then
				self:StartCameraFreeze(self:GetSubjectPosition(), humanoid)
			elseif newState ~= Enum.HumanoidStateType.Jumping and newState ~= Enum.HumanoidStateType.Freefall then
				self:CancelCameraFreeze(true)
			end
		end)
	end
end
function BaseCamera:GetVRFocus(subjectPosition, timeDelta)
	local lastFocus = self.LastCameraFocus or subjectPosition
	if not self.cameraFrozen then
		self.cameraTranslationConstraints = Vector3.new(self.cameraTranslationConstraints.x, math.min(1, self.cameraTranslationConstraints.y + 0.42 * timeDelta), self.cameraTranslationConstraints.z)
	end
	local newFocus
	if self.cameraFrozen and self.humanoidJumpOrigin and self.humanoidJumpOrigin.y > lastFocus.y then
		newFocus = CFrame.new(Vector3.new(subjectPosition.x, math.min(self.humanoidJumpOrigin.y, lastFocus.y + 5 * timeDelta), subjectPosition.z))
	else
		newFocus = CFrame.new(Vector3.new(subjectPosition.x, lastFocus.y, subjectPosition.z):lerp(subjectPosition, self.cameraTranslationConstraints.y))
	end
	if self.cameraFrozen then
		if self.inFirstPerson then
			self:CancelCameraFreeze()
		end
		if self.humanoidJumpOrigin and subjectPosition.y < self.humanoidJumpOrigin.y - 0.5 then
			self:CancelCameraFreeze()
		end
	end
	return newFocus
end
function BaseCamera:GetRotateAmountValue(vrRotationIntensity)
	vrRotationIntensity = vrRotationIntensity or StarterGui:GetCore("VRRotationIntensity")
	if vrRotationIntensity then
		if vrRotationIntensity == "Low" then
			return VR_LOW_INTENSITY_ROTATION
		elseif vrRotationIntensity == "High" then
			return VR_HIGH_INTENSITY_ROTATION
		end
	end
	return ZERO_VECTOR2
end
function BaseCamera:GetRepeatDelayValue(vrRotationIntensity)
	vrRotationIntensity = vrRotationIntensity or StarterGui:GetCore("VRRotationIntensity")
	if vrRotationIntensity then
		if vrRotationIntensity == "Low" then
			return VR_LOW_INTENSITY_REPEAT
		elseif vrRotationIntensity == "High" then
			return VR_HIGH_INTENSITY_REPEAT
		end
	end
	return 0
end
function BaseCamera:Test()
	print("BaseCamera:Test()")
end
function BaseCamera:Update(dt)
	warn("BaseCamera:Update() This is a virtual function that should never be getting called.")
	return game.Workspace.CurrentCamera.CFrame, game.Workspace.CurrentCamera.Focus
end
return BaseCamera


starterplayerscripts.coreclient.playermodule.cameramodule.baseocclusion
--SynapseX Decompiler

local BaseOcclusion = {}
BaseOcclusion.__index = BaseOcclusion
setmetatable(BaseOcclusion, {
	__call = function(_, ...)
		return BaseOcclusion.new(...)
	end
})
function BaseOcclusion.new()
	local self = setmetatable({}, BaseOcclusion)
	return self
end
function BaseOcclusion:CharacterAdded(char, player)
end
function BaseOcclusion:CharacterRemoving(char, player)
end
function BaseOcclusion:OnCameraSubjectChanged(newSubject)
end
function GetOcclusionMode()
	warn("BaseOcclusion GetOcclusionMode must be overridden by derived classes")
	return nil
end
function BaseOcclusion:Enable(enabled)
	warn("BaseOcclusion Enable must be overridden by derived classes")
end
function BaseOcclusion:Update(dt, desiredCameraCFrame, desiredCameraFocus)
	warn("BaseOcclusion Update must be overridden by derived classes")
	return desiredCameraCFrame, desiredCameraFocus
end
return BaseOcclusion

starterplayerscripts.coreclient.playermodule.cameramodule.camerautils
--SynapseX Decompiler

local CameraUtils = {}
local round = function(num)
	return math.floor(num + 0.5)
end
function CameraUtils.Clamp(low, high, val)
	return math.min(math.max(val, low), high)
end
function CameraUtils.Round(num, places)
	local decimalPivot = 10 ^ places
	return math.floor(num * decimalPivot + 0.5) / decimalPivot
end
function CameraUtils.IsFinite(val)
	return val == val and val ~= math.huge and val ~= -math.huge
end
function CameraUtils.IsFiniteVector3(vec3)
	return CameraUtils.IsFinite(vec3.X) and CameraUtils.IsFinite(vec3.Y) and CameraUtils.IsFinite(vec3.Z)
end
function CameraUtils.GetAngleBetweenXZVectors(v1, v2)
	return math.atan2(v2.X * v1.Z - v2.Z * v1.X, v2.X * v1.X + v2.Z * v1.Z)
end
function CameraUtils.RotateVectorByAngleAndRound(camLook, rotateAngle, roundAmount)
	if camLook.Magnitude > 0 then
		camLook = camLook.unit
		local currAngle = math.atan2(camLook.z, camLook.x)
		local newAngle = round((math.atan2(camLook.z, camLook.x) + rotateAngle) / roundAmount) * roundAmount
		return newAngle - currAngle
	end
	return 0
end
local k = 0.35
local lowerK = 0.8
local function SCurveTranform(t)
	t = CameraUtils.Clamp(-1, 1, t)
	if t >= 0 then
		return k * t / (k - t + 1)
	end
	return -(lowerK * -t / (lowerK + t + 1))
end
local DEADZONE = 0.1
local function toSCurveSpace(t)
	return (1 + DEADZONE) * (2 * math.abs(t) - 1) - DEADZONE
end
local fromSCurveSpace = function(t)
	return t / 2 + 0.5
end
function CameraUtils.GamepadLinearToCurve(thumbstickPosition)
	local function onAxis(axisValue)
		local sign = 1
		if axisValue < 0 then
			sign = -1
		end
		local point = fromSCurveSpace(SCurveTranform(toSCurveSpace(math.abs(axisValue))))
		point = point * sign
		return CameraUtils.Clamp(-1, 1, point)
	end
	return Vector2.new(onAxis(thumbstickPosition.x), onAxis(thumbstickPosition.y))
end
function CameraUtils.ConvertCameraModeEnumToStandard(enumValue)
	if enumValue == Enum.TouchCameraMovementMode.Default then
		return Enum.ComputerCameraMovementMode.Follow
	end
	if enumValue == Enum.ComputerCameraMovementMode.Default then
		return Enum.ComputerCameraMovementMode.Classic
	end
	if enumValue == Enum.TouchCameraMovementMode.Classic or enumValue == Enum.DevTouchCameraMovementMode.Classic or enumValue == Enum.DevComputerCameraMovementMode.Classic or enumValue == Enum.ComputerCameraMovementMode.Classic then
		return Enum.ComputerCameraMovementMode.Classic
	end
	if enumValue == Enum.TouchCameraMovementMode.Follow or enumValue == Enum.DevTouchCameraMovementMode.Follow or enumValue == Enum.DevComputerCameraMovementMode.Follow or enumValue == Enum.ComputerCameraMovementMode.Follow then
		return Enum.ComputerCameraMovementMode.Follow
	end
	if enumValue == Enum.TouchCameraMovementMode.Orbital or enumValue == Enum.DevTouchCameraMovementMode.Orbital or enumValue == Enum.DevComputerCameraMovementMode.Orbital or enumValue == Enum.ComputerCameraMovementMode.Orbital then
		return Enum.ComputerCameraMovementMode.Orbital
	end
	if enumValue == Enum.DevTouchCameraMovementMode.UserChoice or enumValue == Enum.DevComputerCameraMovementMode.UserChoice then
		return Enum.DevComputerCameraMovementMode.UserChoice
	end
	return Enum.ComputerCameraMovementMode.Classic
end
return CameraUtils

starterplayerscripts.coreclient.playermodule.cameramodule.classiccamera
--SynapseX Decompiler

local ZERO_VECTOR2 = Vector2.new(0, 0)
local tweenAcceleration = math.rad(220)
local tweenSpeed = math.rad(0)
local tweenMaxSpeed = math.rad(250)
local TIME_BEFORE_AUTO_ROTATE = 2
local PORTRAIT_OFFSET = Vector3.new(0, -3, 0)
local PlayersService = game:GetService("Players")
local VRService = game:GetService("VRService")
local Util = require(script.Parent:WaitForChild("CameraUtils"))
local BaseCamera = require(script.Parent:WaitForChild("BaseCamera"))
local ClassicCamera = setmetatable({}, BaseCamera)
ClassicCamera.__index = ClassicCamera
function ClassicCamera.new()
	local self = setmetatable(BaseCamera.new(), ClassicCamera)
	self.isFollowCamera = false
	self.lastUpdate = tick()
	return self
end
function ClassicCamera:GetModuleName()
	return "ClassicCamera"
end
function ClassicCamera:SetCameraMovementMode(cameraMovementMode)
	BaseCamera.SetCameraMovementMode(self, cameraMovementMode)
	self.isFollowCamera = cameraMovementMode == Enum.ComputerCameraMovementMode.Follow
end
function ClassicCamera:Test()
	print("ClassicCamera:Test()")
end
function ClassicCamera:Update()
	local now = tick()
	local timeDelta = now - self.lastUpdate
	local camera = workspace.CurrentCamera
	local newCameraCFrame = camera.CFrame
	local newCameraFocus = camera.Focus
	local player = PlayersService.LocalPlayer
	local humanoid = self:GetHumanoid()
	local cameraSubject = camera.CameraSubject
	local isInVehicle = cameraSubject and cameraSubject:IsA("VehicleSeat")
	local isOnASkateboard = cameraSubject and cameraSubject:IsA("SkateboardPlatform")
	local isClimbing = humanoid and humanoid:GetState() == Enum.HumanoidStateType.Climbing
	if self.lastUpdate == nil or timeDelta > 1 then
		self.lastCameraTransform = nil
	end
	if self.lastUpdate then
		local gamepadRotation = self:UpdateGamepad()
		if self:ShouldUseVRRotation() then
			self.rotateInput = self.rotateInput + self:GetVRRotationInput()
		else
			local delta = math.min(0.1, timeDelta)
			if gamepadRotation ~= ZERO_VECTOR2 then
				self.rotateInput = self.rotateInput + gamepadRotation * delta
			end
			local angle = 0
			if not isInVehicle and not isOnASkateboard then
				angle = angle + (self.turningLeft and -120 or 0)
				angle = angle + (self.turningRight and 120 or 0)
			end
			if angle ~= 0 then
				self.rotateInput = self.rotateInput + Vector2.new(math.rad(angle * delta), 0)
			end
		end
	end
	if self.userPanningTheCamera then
		tweenSpeed = 0
		self.lastUserPanCamera = tick()
	end
	local userRecentlyPannedCamera = now - self.lastUserPanCamera < TIME_BEFORE_AUTO_ROTATE
	local subjectPosition = self:GetSubjectPosition()
	if subjectPosition and player and camera then
		local zoom = self:GetCameraToSubjectDistance()
		if zoom < 0.5 then
			zoom = 0.5
		end
		if self:GetIsMouseLocked() and not self:IsInFirstPerson() then
			local newLookCFrame = self:CalculateNewLookCFrame()
			local offset = self:GetMouseLockOffset()
			local cameraRelativeOffset = offset.X * newLookCFrame.rightVector + offset.Y * newLookCFrame.upVector + offset.Z * newLookCFrame.lookVector
			if Util.IsFiniteVector3(cameraRelativeOffset) then
				subjectPosition = subjectPosition + cameraRelativeOffset
			end
		elseif not self.userPanningTheCamera and self.lastCameraTransform then
			local isInFirstPerson = self:IsInFirstPerson()
			if (isInVehicle or isOnASkateboard or self.isFollowCamera and isClimbing) and self.lastUpdate and humanoid and humanoid.Torso then
				if isInFirstPerson then
					if self.lastSubjectCFrame and (isInVehicle or isOnASkateboard) and cameraSubject:IsA("BasePart") then
						local y = -Util.GetAngleBetweenXZVectors(self.lastSubjectCFrame.lookVector, cameraSubject.CFrame.lookVector)
						if Util.IsFinite(y) then
							self.rotateInput = self.rotateInput + Vector2.new(y, 0)
						end
						tweenSpeed = 0
					end
				elseif not userRecentlyPannedCamera then
				end
			elseif self.isFollowCamera and not isInFirstPerson and not userRecentlyPannedCamera and not VRService.VREnabled then
				local lastVec = -(self.lastCameraTransform.p - subjectPosition)
				local y = Util.GetAngleBetweenXZVectors(lastVec, self:GetCameraLookVector())
				local thetaCutoff = 0.4
				if Util.IsFinite(y) and math.abs(y) > 1.0E-4 and math.abs(y) > thetaCutoff * timeDelta then
					self.rotateInput = self.rotateInput + Vector2.new(y, 0)
				end
			end
		end
		if not self.isFollowCamera then
			local VREnabled = VRService.VREnabled
			newCameraFocus = VREnabled and self:GetVRFocus(subjectPosition, timeDelta) or CFrame.new(subjectPosition)
			local cameraFocusP = newCameraFocus.p
			if VREnabled and not self:IsInFirstPerson() then
				local cameraHeight = self:GetCameraHeight()
				local vecToSubject = subjectPosition - camera.CFrame.p
				local distToSubject = vecToSubject.magnitude
				if zoom < distToSubject or self.rotateInput.x ~= 0 then
					local desiredDist = math.min(distToSubject, zoom)
					vecToSubject = self:CalculateNewLookVectorVR() * desiredDist
					local newPos = cameraFocusP - vecToSubject
					local desiredLookDir = camera.CFrame.lookVector
					if self.rotateInput.x ~= 0 then
						desiredLookDir = vecToSubject
					end
					local lookAt = Vector3.new(newPos.x + desiredLookDir.x, newPos.y, newPos.z + desiredLookDir.z)
					self.rotateInput = ZERO_VECTOR2
					newCameraCFrame = CFrame.new(newPos, lookAt) + Vector3.new(0, cameraHeight, 0)
				end
			else
				local newLookVector = self:CalculateNewLookVector()
				self.rotateInput = ZERO_VECTOR2
				newCameraCFrame = CFrame.new(cameraFocusP - zoom * newLookVector, cameraFocusP)
			end
		else
			local newLookVector = self:CalculateNewLookVector()
			self.rotateInput = ZERO_VECTOR2
			if VRService.VREnabled then
				newCameraFocus = self:GetVRFocus(subjectPosition, timeDelta)
			elseif self.portraitMode then
				newCameraFocus = CFrame.new(subjectPosition + PORTRAIT_OFFSET)
			else
				newCameraFocus = CFrame.new(subjectPosition)
			end
			newCameraCFrame = CFrame.new(newCameraFocus.p - zoom * newLookVector, newCameraFocus.p) + Vector3.new(0, self:GetCameraHeight(), 0)
		end
		self.lastCameraTransform = newCameraCFrame
		self.lastCameraFocus = newCameraFocus
		if (isInVehicle or isOnASkateboard) and cameraSubject:IsA("BasePart") then
			self.lastSubjectCFrame = cameraSubject.CFrame
		else
			self.lastSubjectCFrame = nil
		end
	end
	self.lastUpdate = now
	return newCameraCFrame, newCameraFocus
end
function ClassicCamera:EnterFirstPerson()
	self.inFirstPerson = true
	self:UpdateMouseBehavior()
end
function ClassicCamera:LeaveFirstPerson()
	self.inFirstPerson = false
	self:UpdateMouseBehavior()
end
return ClassicCamera

starterplayerscripts.coreclient.playermodule.cameramodule.invisicam
--SynapseX Decompiler

local Util = require(script.Parent:WaitForChild("CameraUtils"))
local PlayersService = game:GetService("Players")
local RunService = game:GetService("RunService")
local ZERO_VECTOR3 = Vector3.new(0, 0, 0)
local USE_STACKING_TRANSPARENCY = true
local TARGET_TRANSPARENCY = 0.75
local TARGET_TRANSPARENCY_PERIPHERAL = 0.5
local MODE = {
	LIMBS = 2,
	MOVEMENT = 3,
	CORNERS = 4,
	CIRCLE1 = 5,
	CIRCLE2 = 6,
	LIMBMOVE = 7,
	SMART_CIRCLE = 8,
	CHAR_OUTLINE = 9
}
local LIMB_TRACKING_SET = {
	Head = true,
	["Left Arm"] = true,
	["Right Arm"] = true,
	["Left Leg"] = true,
	["Right Leg"] = true,
	LeftLowerArm = true,
	RightLowerArm = true,
	LeftUpperLeg = true,
	RightUpperLeg = true
}
local CORNER_FACTORS = {
	Vector3.new(1, 1, -1),
	Vector3.new(1, -1, -1),
	Vector3.new(-1, -1, -1),
	Vector3.new(-1, 1, -1)
}
local CIRCLE_CASTS = 10
local MOVE_CASTS = 3
local SMART_CIRCLE_CASTS = 24
local SMART_CIRCLE_INCREMENT = 2 * math.pi / SMART_CIRCLE_CASTS
local CHAR_OUTLINE_CASTS = 24
local AssertTypes = function(param, ...)
	local allowedTypes = {}
	local typeString = ""
	for _, typeName in pairs({
		...
	}) do
		allowedTypes[typeName] = true
		typeString = typeString .. (typeString == "" and "" or " or ") .. typeName
	end
	local theType = type(param)
	assert(allowedTypes[theType], typeString .. " type expected, got: " .. theType)
end
local Det3x3 = function(a, b, c, d, e, f, g, h, i)
	return a * (e * i - f * h) - b * (d * i - f * g) + c * (d * h - e * g)
end
local function RayIntersection(p0, v0, p1, v1)
	local v2 = v0:Cross(v1)
	local d1 = p1.x - p0.x
	local d2 = p1.y - p0.y
	local d3 = p1.z - p0.z
	local denom = Det3x3(v0.x, -v1.x, v2.x, v0.y, -v1.y, v2.y, v0.z, -v1.z, v2.z)
	if denom == 0 then
		return ZERO_VECTOR3
	end
	local t0 = Det3x3(d1, -v1.x, v2.x, d2, -v1.y, v2.y, d3, -v1.z, v2.z) / denom
	local t1 = Det3x3(v0.x, d1, v2.x, v0.y, d2, v2.y, v0.z, d3, v2.z) / denom
	local s0 = p0 + t0 * v0
	local s1 = p1 + t1 * v1
	local s = s0 + 0.5 * (s1 - s0)
	if (s1 - s0).Magnitude < 0.25 then
		return s
	else
		return ZERO_VECTOR3
	end
end
local BaseOcclusion = require(script.Parent:WaitForChild("BaseOcclusion"))
local Invisicam = setmetatable({}, BaseOcclusion)
Invisicam.__index = Invisicam
function Invisicam.new()
	local self = setmetatable(BaseOcclusion.new(), Invisicam)
	self.char = nil
	self.humanoidRootPart = nil
	self.torsoPart = nil
	self.headPart = nil
	self.childAddedConn = nil
	self.childRemovedConn = nil
	self.behaviors = {}
	self.behaviors[MODE.LIMBS] = self.LimbBehavior
	self.behaviors[MODE.MOVEMENT] = self.MoveBehavior
	self.behaviors[MODE.CORNERS] = self.CornerBehavior
	self.behaviors[MODE.CIRCLE1] = self.CircleBehavior
	self.behaviors[MODE.CIRCLE2] = self.CircleBehavior
	self.behaviors[MODE.LIMBMOVE] = self.LimbMoveBehavior
	self.behaviors[MODE.SMART_CIRCLE] = self.SmartCircleBehavior
	self.behaviors[MODE.CHAR_OUTLINE] = self.CharacterOutlineBehavior
	self.mode = MODE.SMART_CIRCLE
	self.behaviorFunction = self.SmartCircleBehavior
	self.savedHits = {}
	self.trackedLimbs = {}
	self.camera = game.Workspace.CurrentCamera
	self.enabled = false
	return self
end
function Invisicam:Enable(enable)
	self.enabled = enable
	if not enable then
		self:Cleanup()
	end
end
function Invisicam:GetOcclusionMode()
	return Enum.DevCameraOcclusionMode.Invisicam
end
function Invisicam:LimbBehavior(castPoints)
	for limb, _ in pairs(self.trackedLimbs) do
		castPoints[#castPoints + 1] = limb.Position
	end
end
function Invisicam:MoveBehavior(castPoints)
	for i = 1, MOVE_CASTS do
		local position, velocity = self.humanoidRootPart.Position, self.humanoidRootPart.Velocity
		local horizontalSpeed = Vector3.new(velocity.X, 0, velocity.Z).Magnitude / 2
		local offsetVector = (i - 1) * self.humanoidRootPart.CFrame.lookVector * horizontalSpeed
		castPoints[#castPoints + 1] = position + offsetVector
	end
end
function Invisicam:CornerBehavior(castPoints)
	local cframe = self.humanoidRootPart.CFrame
	local centerPoint = cframe.p
	local rotation = cframe - centerPoint
	local halfSize = self.char:GetExtentsSize() / 2
	castPoints[#castPoints + 1] = centerPoint
	for i = 1, #CORNER_FACTORS do
		castPoints[#castPoints + 1] = centerPoint + rotation * (halfSize * CORNER_FACTORS[i])
	end
end
function Invisicam:CircleBehavior(castPoints)
	local cframe
	if self.mode == MODE.CIRCLE1 then
		cframe = self.humanoidRootPart.CFrame
	else
		local camCFrame = self.camera.CoordinateFrame
		cframe = camCFrame - camCFrame.p + self.humanoidRootPart.Position
	end
	castPoints[#castPoints + 1] = cframe.p
	for i = 0, CIRCLE_CASTS - 1 do
		local angle = 2 * math.pi / CIRCLE_CASTS * i
		local offset = 3 * Vector3.new(math.cos(angle), math.sin(angle), 0)
		castPoints[#castPoints + 1] = cframe * offset
	end
end
function Invisicam:LimbMoveBehavior(castPoints)
	self:LimbBehavior(castPoints)
	self:MoveBehavior(castPoints)
end
function Invisicam:CharacterOutlineBehavior(castPoints)
	local torsoUp = self.torsoPart.CFrame.upVector.unit
	local torsoRight = self.torsoPart.CFrame.rightVector.unit
	castPoints[#castPoints + 1] = self.torsoPart.CFrame.p
	castPoints[#castPoints + 1] = self.torsoPart.CFrame.p + torsoUp
	castPoints[#castPoints + 1] = self.torsoPart.CFrame.p - torsoUp
	castPoints[#castPoints + 1] = self.torsoPart.CFrame.p + torsoRight
	castPoints[#castPoints + 1] = self.torsoPart.CFrame.p - torsoRight
	if self.headPart then
		castPoints[#castPoints + 1] = self.headPart.CFrame.p
	end
	local cframe = CFrame.new(ZERO_VECTOR3, Vector3.new(self.camera.CoordinateFrame.lookVector.X, 0, self.camera.CoordinateFrame.lookVector.Z))
	local centerPoint = self.torsoPart and self.torsoPart.Position or self.humanoidRootPart.Position
	local partsWhitelist = {
		self.torsoPart
	}
	if self.headPart then
		partsWhitelist[#partsWhitelist + 1] = self.headPart
	end
	for i = 1, CHAR_OUTLINE_CASTS do
		local angle = 2 * math.pi * i / CHAR_OUTLINE_CASTS
		local offset = cframe * (3 * Vector3.new(math.cos(angle), math.sin(angle), 0))
		offset = Vector3.new(offset.X, math.max(offset.Y, -2.25), offset.Z)
		local ray = Ray.new(centerPoint + offset, -3 * offset)
		local hit, hitPoint = game.Workspace:FindPartOnRayWithWhitelist(ray, partsWhitelist, false, false)
		if hit then
			castPoints[#castPoints + 1] = hitPoint + 0.2 * (centerPoint - hitPoint).unit
		end
	end
end
function Invisicam:SmartCircleBehavior(castPoints)
	local torsoUp = self.torsoPart.CFrame.upVector.unit
	local torsoRight = self.torsoPart.CFrame.rightVector.unit
	castPoints[#castPoints + 1] = self.torsoPart.CFrame.p
	castPoints[#castPoints + 1] = self.torsoPart.CFrame.p + torsoUp
	castPoints[#castPoints + 1] = self.torsoPart.CFrame.p - torsoUp
	castPoints[#castPoints + 1] = self.torsoPart.CFrame.p + torsoRight
	castPoints[#castPoints + 1] = self.torsoPart.CFrame.p - torsoRight
	if self.headPart then
		castPoints[#castPoints + 1] = self.headPart.CFrame.p
	end
	local cameraOrientation = self.camera.CFrame - self.camera.CFrame.p
	local torsoPoint = Vector3.new(0, 0.5, 0) + (self.torsoPart and self.torsoPart.Position or self.humanoidRootPart.Position)
	local radius = 2.5
	for i = 1, SMART_CIRCLE_CASTS do
		local angle = SMART_CIRCLE_INCREMENT * i - 0.5 * math.pi
		local offset = radius * Vector3.new(math.cos(angle), math.sin(angle), 0)
		local circlePoint = torsoPoint + cameraOrientation * offset
		local vp = circlePoint - self.camera.CFrame.p
		local ray = Ray.new(torsoPoint, circlePoint - torsoPoint)
		local hit, hp, hitNormal = game.Workspace:FindPartOnRayWithIgnoreList(ray, {
			self.char
		}, false, false)
		local castPoint = circlePoint
		if hit then
			local hprime = hp + 0.1 * hitNormal.unit
			local v0 = hprime - torsoPoint
			local d0 = v0.magnitude
			local perp = v0:Cross(vp).unit
			local v1 = perp:Cross(hitNormal).unit
			local vprime = (hprime - self.camera.CFrame.p).unit
			if v0.unit:Dot(-v1) < v0.unit:Dot(vprime) then
				castPoint = RayIntersection(hprime, v1, circlePoint, vp)
				if 0 < castPoint.Magnitude then
					local ray = Ray.new(hprime, castPoint - hprime)
					local hit, hitPoint, hitNormal = game.Workspace:FindPartOnRayWithIgnoreList(ray, {
						self.char
					}, false, false)
					if hit then
						local hprime2 = hitPoint + 0.1 * hitNormal.unit
						castPoint = hprime2
					end
				else
					castPoint = hprime
				end
			else
				castPoint = hprime
			end
			local ray = Ray.new(torsoPoint, castPoint - torsoPoint)
			local hit, hitPoint, hitNormal = game.Workspace:FindPartOnRayWithIgnoreList(ray, {
				self.char
			}, false, false)
			if hit then
				local castPoint2 = hitPoint - 0.1 * (castPoint - torsoPoint).unit
				castPoint = castPoint2
			end
		end
		castPoints[#castPoints + 1] = castPoint
	end
end
function Invisicam:CheckTorsoReference()
	if self.char then
		self.torsoPart = self.char:FindFirstChild("Torso")
		if not self.torsoPart then
			self.torsoPart = self.char:FindFirstChild("UpperTorso")
			if not self.torsoPart then
				self.torsoPart = self.char:FindFirstChild("HumanoidRootPart")
			end
		end
		self.headPart = self.char:FindFirstChild("Head")
	end
end
function Invisicam:CharacterAdded(char, player)
	if player ~= PlayersService.LocalPlayer then
		return
	end
	if self.childAddedConn then
		self.childAddedConn:Disconnect()
		self.childAddedConn = nil
	end
	if self.childRemovedConn then
		self.childRemovedConn:Disconnect()
		self.childRemovedConn = nil
	end
	self.char = char
	self.trackedLimbs = {}
	local function childAdded(child)
		if child:IsA("BasePart") then
			if LIMB_TRACKING_SET[child.Name] then
				self.trackedLimbs[child] = true
			end
			if child.Name == "Torso" or child.Name == "UpperTorso" then
				self.torsoPart = child
			end
			if child.Name == "Head" then
				self.headPart = child
			end
		end
	end
	local function childRemoved(child)
		self.trackedLimbs[child] = nil
		self:CheckTorsoReference()
	end
	self.childAddedConn = char.ChildAdded:Connect(childAdded)
	self.childRemovedConn = char.ChildRemoved:Connect(childRemoved)
	for _, child in pairs(self.char:GetChildren()) do
		childAdded(child)
	end
end
function Invisicam:SetMode(newMode)
	AssertTypes(newMode, "number")
	for modeName, modeNum in pairs(MODE) do
		if modeNum == newMode then
			self.mode = newMode
			self.behaviorFunction = self.behaviors[self.mode]
			return
		end
	end
	error("Invalid mode number")
end
function Invisicam:GetObscuredParts()
	return self.savedHits
end
function Invisicam:Cleanup()
	for hit, originalFade in pairs(self.savedHits) do
		hit.LocalTransparencyModifier = originalFade
	end
end
function Invisicam:Update(dt, desiredCameraCFrame, desiredCameraFocus)
	if not self.enabled or not self.char then
		return desiredCameraCFrame, desiredCameraFocus
	end
	self.camera = game.Workspace.CurrentCamera
	if not self.humanoidRootPart then
		do
			local humanoid = self.char:FindFirstChildOfClass("Humanoid")
			if humanoid and humanoid.RootPart then
				self.humanoidRootPart = humanoid.RootPart
			else
				self.humanoidRootPart = self.char:FindFirstChild("HumanoidRootPart")
				if not self.humanoidRootPart then
					return desiredCameraCFrame, desiredCameraFocus
				end
			end
			local ancestryChangedConn
			ancestryChangedConn = self.humanoidRootPart.AncestryChanged:Connect(function(child, parent)
				if child == self.humanoidRootPart and not parent then
					self.humanoidRootPart = nil
					if ancestryChangedConn and ancestryChangedConn.Connected then
						ancestryChangedConn:Disconnect()
						ancestryChangedConn = nil
					end
				end
			end)
		end
	end
	if not self.torsoPart then
		self:CheckTorsoReference()
		if not self.torsoPart then
			return desiredCameraCFrame, desiredCameraFocus
		end
	end
	local castPoints = {}
	self.behaviorFunction(self, castPoints)
	local currentHits = {}
	local ignoreList = {
		self.char
	}
	local function add(hit)
		currentHits[hit] = true
		if not self.savedHits[hit] then
			self.savedHits[hit] = hit.LocalTransparencyModifier
		end
	end
	local hitParts
	local hitPartCount = 0
	local headTorsoRayHitParts = {}
	local partIsTouchingCamera = {}
	local perPartTransparencyHeadTorsoHits = TARGET_TRANSPARENCY
	local perPartTransparencyOtherHits = TARGET_TRANSPARENCY
	if USE_STACKING_TRANSPARENCY then
		local headPoint = self.headPart and self.headPart.CFrame.p or castPoints[1]
		local torsoPoint = self.torsoPart and self.torsoPart.CFrame.p or castPoints[2]
		hitParts = self.camera:GetPartsObscuringTarget({headPoint, torsoPoint}, ignoreList)
		for i = 1, #hitParts do
			local hitPart = hitParts[i]
			hitPartCount = hitPartCount + 1
			headTorsoRayHitParts[hitPart] = true
			for _, child in pairs(hitPart:GetChildren()) do
				if child:IsA("Decal") or child:IsA("Texture") then
					hitPartCount = hitPartCount + 1
					break
				end
			end
		end
		if hitPartCount > 0 then
			perPartTransparencyHeadTorsoHits = math.pow(0.5 * TARGET_TRANSPARENCY + 0.5 * TARGET_TRANSPARENCY / hitPartCount, 1 / hitPartCount)
			perPartTransparencyOtherHits = math.pow(0.5 * TARGET_TRANSPARENCY_PERIPHERAL + 0.5 * TARGET_TRANSPARENCY_PERIPHERAL / hitPartCount, 1 / hitPartCount)
		end
	end
	hitParts = self.camera:GetPartsObscuringTarget(castPoints, ignoreList)
	local partTargetTransparency = {}
	for i = 1, #hitParts do
		local hitPart = hitParts[i]
		partTargetTransparency[hitPart] = headTorsoRayHitParts[hitPart] and perPartTransparencyHeadTorsoHits or perPartTransparencyOtherHits
		if hitPart.Transparency < partTargetTransparency[hitPart] then
			add(hitPart)
		end
		for _, child in pairs(hitPart:GetChildren()) do
			if (child:IsA("Decal") or child:IsA("Texture")) and child.Transparency < partTargetTransparency[hitPart] then
				partTargetTransparency[child] = partTargetTransparency[hitPart]
				add(child)
			end
		end
	end
	for hitPart, originalLTM in pairs(self.savedHits) do
		if currentHits[hitPart] then
			hitPart.LocalTransparencyModifier = 1 > hitPart.Transparency and (partTargetTransparency[hitPart] - hitPart.Transparency) / (1 - hitPart.Transparency) or 0
		else
			hitPart.LocalTransparencyModifier = originalLTM
			self.savedHits[hitPart] = nil
		end
	end
	return desiredCameraCFrame, desiredCameraFocus
end
return Invisicam

starterplayerscripts.coreclient.playermodule.cameramodule.legacycamera
--SynapseX Decompiler

local UNIT_X = Vector3.new(1, 0, 0)
local UNIT_Y = Vector3.new(0, 1, 0)
local UNIT_Z = Vector3.new(0, 0, 1)
local X1_Y0_Z1 = Vector3.new(1, 0, 1)
local ZERO_VECTOR3 = Vector3.new(0, 0, 0)
local ZERO_VECTOR2 = Vector2.new(0, 0)
local VR_PITCH_FRACTION = 0.25
local tweenAcceleration = math.rad(220)
local tweenSpeed = math.rad(0)
local tweenMaxSpeed = math.rad(250)
local TIME_BEFORE_AUTO_ROTATE = 2
local PORTRAIT_OFFSET = Vector3.new(0, -3, 0)
local Util = require(script.Parent:WaitForChild("CameraUtils"))
local PlayersService = game:GetService("Players")
local VRService = game:GetService("VRService")
local BaseCamera = require(script.Parent:WaitForChild("BaseCamera"))
local LegacyCamera = setmetatable({}, BaseCamera)
LegacyCamera.__index = LegacyCamera
function LegacyCamera.new()
	local self = setmetatable(BaseCamera.new(), LegacyCamera)
	self.cameraType = Enum.CameraType.Fixed
	self.lastUpdate = tick()
	self.lastDistanceToSubject = nil
	return self
end
function LegacyCamera:GetModuleName()
	return "LegacyCamera"
end
function LegacyCamera:Test()
	print("LegacyCamera:Test()")
end
function LegacyCamera:SetCameraToSubjectDistance(desiredSubjectDistance)
	return BaseCamera.SetCameraToSubjectDistance(self, desiredSubjectDistance)
end
function LegacyCamera:Update(dt)
	if not self.cameraType then
		return
	end
	local now = tick()
	local timeDelta = now - self.lastUpdate
	local camera = workspace.CurrentCamera
	local newCameraCFrame = camera.CFrame
	local newCameraFocus = camera.Focus
	local player = PlayersService.LocalPlayer
	local humanoid = self:GetHumanoid()
	local cameraSubject = camera and camera.CameraSubject
	local isInVehicle = cameraSubject and cameraSubject:IsA("VehicleSeat")
	local isOnASkateboard = cameraSubject and cameraSubject:IsA("SkateboardPlatform")
	local isClimbing = humanoid and humanoid:GetState() == Enum.HumanoidStateType.Climbing
	if self.lastUpdate == nil or timeDelta > 1 then
		self.lastDistanceToSubject = nil
	end
	local subjectPosition = self:GetSubjectPosition()
	if self.cameraType == Enum.CameraType.Fixed then
		if self.lastUpdate then
			local delta = math.min(0.1, now - self.lastUpdate)
			local gamepadRotation = self:UpdateGamepad()
			self.rotateInput = self.rotateInput + gamepadRotation * delta
		end
		if subjectPosition and player and camera then
			local distanceToSubject = self:GetCameraToSubjectDistance()
			local newLookVector = self:CalculateNewLookVector()
			self.rotateInput = ZERO_VECTOR2
			newCameraFocus = camera.Focus
			newCameraCFrame = CFrame.new(camera.CFrame.p, camera.CFrame.p + distanceToSubject * newLookVector)
		end
	elseif self.cameraType == Enum.CameraType.Attach then
		if subjectPosition and camera then
			local distanceToSubject = self:GetCameraToSubjectDistance()
			local humanoid = self:GetHumanoid()
			if self.lastUpdate and humanoid and humanoid.RootPart then
				local delta = math.min(0.1, now - self.lastUpdate)
				local gamepadRotation = self:UpdateGamepad()
				self.rotateInput = self.rotateInput + gamepadRotation * delta
				local forwardVector = humanoid.RootPart.CFrame.lookVector
				local y = Util.GetAngleBetweenXZVectors(forwardVector, self:GetCameraLookVector())
				if Util.IsFinite(y) then
					self.rotateInput = Vector2.new(y, self.rotateInput.Y)
				end
			end
			local newLookVector = self:CalculateNewLookVector()
			self.rotateInput = ZERO_VECTOR2
			newCameraFocus = CFrame.new(subjectPosition)
			newCameraCFrame = CFrame.new(subjectPosition - distanceToSubject * newLookVector, subjectPosition)
		end
	elseif self.cameraType == Enum.CameraType.Watch then
		if subjectPosition and player and camera then
			local cameraLook
			local humanoid = self:GetHumanoid()
			if humanoid and humanoid.RootPart then
				local diffVector = subjectPosition - camera.CFrame.p
				cameraLook = diffVector.unit
				if self.lastDistanceToSubject and self.lastDistanceToSubject == self:GetCameraToSubjectDistance() then
					local newDistanceToSubject = diffVector.magnitude
					self:SetCameraToSubjectDistance(newDistanceToSubject)
				end
			end
			local distanceToSubject = self:GetCameraToSubjectDistance()
			local newLookVector = self:CalculateNewLookVector(cameraLook)
			self.rotateInput = ZERO_VECTOR2
			newCameraFocus = CFrame.new(subjectPosition)
			newCameraCFrame = CFrame.new(subjectPosition - distanceToSubject * newLookVector, subjectPosition)
			self.lastDistanceToSubject = distanceToSubject
		end
	else
		return camera.CFrame, camera.Focus
	end
	self.lastUpdate = now
	return newCameraCFrame, newCameraFocus
end
return LegacyCamera

starterplayerscripts.coreclient.playermodule.cameramodule.mouselockcontroller
--SynapseX Decompiler

local DEFAULT_MOUSE_LOCK_CURSOR = "rbxasset://textures/MouseLockedCursor.png"
local CONTEXT_ACTION_NAME = "MouseLockSwitchAction"
local MOUSELOCK_ACTION_PRIORITY = Enum.ContextActionPriority.Default.Value
local Util = require(script.Parent:WaitForChild("CameraUtils"))
local PlayersService = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local Settings = UserSettings()
local GameSettings = Settings.GameSettings
local Mouse = PlayersService.LocalPlayer:GetMouse()
local bindAtPriorityFlagExists, bindAtPriorityFlagEnabled = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserPlayerScriptsBindAtPriority")
end)
local FFlagPlayerScriptsBindAtPriority = bindAtPriorityFlagExists and bindAtPriorityFlagEnabled
local MouseLockController = {}
MouseLockController.__index = MouseLockController
function MouseLockController.new()
	local self = setmetatable({}, MouseLockController)
	self.inputBeganConn = nil
	self.isMouseLocked = false
	self.savedMouseCursor = nil
	self.boundKeys = {
		Enum.KeyCode.LeftShift,
		Enum.KeyCode.RightShift
	}
	self.mouseLockToggledEvent = Instance.new("BindableEvent")
	local boundKeysObj = script:FindFirstChild("BoundKeys")
	if not boundKeysObj or not boundKeysObj:IsA("StringValue") then
		if boundKeysObj then
			boundKeysObj:Destroy()
		end
		boundKeysObj = Instance.new("StringValue")
		boundKeysObj.Name = "BoundKeys"
		boundKeysObj.Value = "LeftControl,RightControl"
		boundKeysObj.Parent = script
	end
	if boundKeysObj then
		boundKeysObj.Changed:Connect(function(value)
			self:OnBoundKeysObjectChanged(value)
		end)
		self:OnBoundKeysObjectChanged(boundKeysObj.Value)
	end
	GameSettings.Changed:Connect(function(property)
		if property == "ControlMode" or property == "ComputerMovementMode" then
			self:UpdateMouseLockAvailability()
		end
	end)
	PlayersService.LocalPlayer:GetPropertyChangedSignal("DevEnableMouseLock"):Connect(function()
		self:UpdateMouseLockAvailability()
	end)
	PlayersService.LocalPlayer:GetPropertyChangedSignal("DevComputerMovementMode"):Connect(function()
		self:UpdateMouseLockAvailability()
	end)
	self:UpdateMouseLockAvailability()
	return self
end
function MouseLockController:GetIsMouseLocked()
	return self.isMouseLocked
end
function MouseLockController:GetBindableToggleEvent()
	return self.mouseLockToggledEvent.Event
end
function MouseLockController:GetMouseLockOffset()
	local offsetValueObj = script:FindFirstChild("CameraOffset")
	if offsetValueObj and offsetValueObj:IsA("Vector3Value") then
		return offsetValueObj.Value
	else
		if offsetValueObj then
			offsetValueObj:Destroy()
		end
		offsetValueObj = Instance.new("Vector3Value")
		offsetValueObj.Name = "CameraOffset"
		offsetValueObj.Value = Vector3.new(1.75, 0, 0)
		offsetValueObj.Parent = script
	end
	if offsetValueObj and offsetValueObj.Value then
		return offsetValueObj.Value
	end
	return Vector3.new(1.75, 0, 0)
end
function MouseLockController:UpdateMouseLockAvailability()
	local devAllowsMouseLock = PlayersService.LocalPlayer.DevEnableMouseLock
	local devMovementModeIsScriptable = PlayersService.LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.Scriptable
	local userHasMouseLockModeEnabled = GameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch
	local userHasClickToMoveEnabled = GameSettings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove
	local MouseLockAvailable = true
	if MouseLockAvailable ~= self.enabled then
		self:EnableMouseLock(MouseLockAvailable)
	end
end
function MouseLockController:OnBoundKeysObjectChanged(newValue)
	self.boundKeys = {}
	for token in string.gmatch(newValue, "[^%s,]+") do
		for keyCode, keyEnum in pairs(Enum.KeyCode:GetEnumItems()) do
			if token == keyEnum.Name then
				self.boundKeys[#self.boundKeys + 1] = keyEnum
				break
			end
		end
	end
	if FFlagPlayerScriptsBindAtPriority then
		self:UnbindContextActions()
		self:BindContextActions()
	end
end
function MouseLockController:OnMouseLockToggled()
	self.isMouseLocked = not self.isMouseLocked
	self.mouseLockToggledEvent:Fire()
end
function MouseLockController:OnInputBegan(input, processed)
	if processed then
		return
	end
	if input.UserInputType == Enum.UserInputType.Keyboard then
		for _, keyCode in pairs(self.boundKeys) do
			if keyCode == input.KeyCode then
				self:OnMouseLockToggled()
				return
			end
		end
	end
end
function MouseLockController:DoMouseLockSwitch(name, state, input)
	if state == Enum.UserInputState.Begin then
		self:OnMouseLockToggled()
		return Enum.ContextActionResult.Sink
	end
	return Enum.ContextActionResult.Pass
end
function MouseLockController:BindContextActions()
	ContextActionService:BindActionAtPriority(CONTEXT_ACTION_NAME, function(name, state, input)
		self:DoMouseLockSwitch(name, state, input)
	end, false, MOUSELOCK_ACTION_PRIORITY, unpack(self.boundKeys))
end
function MouseLockController:UnbindContextActions()
	ContextActionService:UnbindAction(CONTEXT_ACTION_NAME)
end
function MouseLockController:IsMouseLocked()
	return self.enabled and self.isMouseLocked
end
function MouseLockController:EnableMouseLock(enable)
	if enable ~= self.enabled then
		self.enabled = enable
		if self.enabled then
			if FFlagPlayerScriptsBindAtPriority then
				self:BindContextActions()
			else
				if self.inputBeganConn then
					self.inputBeganConn:Disconnect()
				end
				self.inputBeganConn = UserInputService.InputBegan:Connect(function(input, processed)
					self:OnInputBegan(input, processed)
				end)
			end
		else
			if FFlagPlayerScriptsBindAtPriority then
				self:UnbindContextActions()
			else
				if self.inputBeganConn then
					self.inputBeganConn:Disconnect()
				end
				self.inputBeganConn = nil
			end
			if self.isMouseLocked then
				self.mouseLockToggledEvent:Fire()
			end
			self.isMouseLocked = false
		end
	end
end
return MouseLockController

starterplayerscripts.coreclient.playermodule.cameramodule.orbitalcamera
--SynapseX Decompiler

local UNIT_X = Vector3.new(1, 0, 0)
local UNIT_Y = Vector3.new(0, 1, 0)
local UNIT_Z = Vector3.new(0, 0, 1)
local X1_Y0_Z1 = Vector3.new(1, 0, 1)
local ZERO_VECTOR3 = Vector3.new(0, 0, 0)
local ZERO_VECTOR2 = Vector2.new(0, 0)
local TAU = 2 * math.pi
local VR_PITCH_FRACTION = 0.25
local tweenAcceleration = math.rad(220)
local tweenSpeed = math.rad(0)
local tweenMaxSpeed = math.rad(250)
local TIME_BEFORE_AUTO_ROTATE = 2
local PORTRAIT_OFFSET = Vector3.new(0, -3, 0)
local bindAtPriorityFlagExists, bindAtPriorityFlagEnabled = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserPlayerScriptsBindAtPriority")
end)
local FFlagPlayerScriptsBindAtPriority = bindAtPriorityFlagExists and bindAtPriorityFlagEnabled
local THUMBSTICK_DEADZONE = 0.2
local MIN_ALLOWED_ELEVATION_DEG = -80
local MAX_ALLOWED_ELEVATION_DEG = 80
local externalProperties = {}
externalProperties.InitialDistance = 25
externalProperties.MinDistance = 10
externalProperties.MaxDistance = 100
externalProperties.InitialElevation = 35
externalProperties.MinElevation = 35
externalProperties.MaxElevation = 35
externalProperties.ReferenceAzimuth = -45
externalProperties.CWAzimuthTravel = 90
externalProperties.CCWAzimuthTravel = 90
externalProperties.UseAzimuthLimits = false
local Util = require(script.Parent:WaitForChild("CameraUtils"))
local PlayersService = game:GetService("Players")
local VRService = game:GetService("VRService")
local GetValueObject = function(name, defaultValue)
	local valueObj = script:FindFirstChild(name)
	if valueObj then
		return valueObj.Value
	end
	return defaultValue
end
local BaseCamera = require(script.Parent:WaitForChild("BaseCamera"))
local OrbitalCamera = setmetatable({}, BaseCamera)
OrbitalCamera.__index = OrbitalCamera
function OrbitalCamera.new()
	local self = setmetatable(BaseCamera.new(), OrbitalCamera)
	self.lastUpdate = tick()
	self.changedSignalConnections = {}
	self.refAzimuthRad = nil
	self.curAzimuthRad = nil
	self.minAzimuthAbsoluteRad = nil
	self.maxAzimuthAbsoluteRad = nil
	self.useAzimuthLimits = nil
	self.curElevationRad = nil
	self.minElevationRad = nil
	self.maxElevationRad = nil
	self.curDistance = nil
	self.minDistance = nil
	self.maxDistance = nil
	self.r3ButtonDown = false
	self.l3ButtonDown = false
	self.gamepadDollySpeedMultiplier = 1
	self.lastUserPanCamera = tick()
	self.externalProperties = {}
	self.externalProperties.InitialDistance = 25
	self.externalProperties.MinDistance = 10
	self.externalProperties.MaxDistance = 100
	self.externalProperties.InitialElevation = 35
	self.externalProperties.MinElevation = 35
	self.externalProperties.MaxElevation = 35
	self.externalProperties.ReferenceAzimuth = -45
	self.externalProperties.CWAzimuthTravel = 90
	self.externalProperties.CCWAzimuthTravel = 90
	self.externalProperties.UseAzimuthLimits = false
	self:LoadNumberValueParameters()
	return self
end
function OrbitalCamera:LoadOrCreateNumberValueParameter(name, valueType, updateFunction)
	local valueObj = script:FindFirstChild(name)
	if valueObj and valueObj:isA(valueType) then
		self.externalProperties[name] = valueObj.Value
	elseif self.externalProperties[name] ~= nil then
		valueObj = Instance.new(valueType)
		valueObj.Name = name
		valueObj.Parent = script
		valueObj.Value = self.externalProperties[name]
	else
		print("externalProperties table has no entry for ", name)
		return
	end
	if updateFunction then
		if self.changedSignalConnections[name] then
			self.changedSignalConnections[name]:Disconnect()
		end
		self.changedSignalConnections[name] = valueObj.Changed:Connect(function(newValue)
			self.externalProperties[name] = newValue
			updateFunction(self)
		end)
	end
end
function OrbitalCamera:SetAndBoundsCheckAzimuthValues()
	self.minAzimuthAbsoluteRad = math.rad(self.externalProperties.ReferenceAzimuth) - math.abs(math.rad(self.externalProperties.CWAzimuthTravel))
	self.maxAzimuthAbsoluteRad = math.rad(self.externalProperties.ReferenceAzimuth) + math.abs(math.rad(self.externalProperties.CCWAzimuthTravel))
	self.useAzimuthLimits = self.externalProperties.UseAzimuthLimits
	if self.useAzimuthLimits then
		self.curAzimuthRad = math.max(self.curAzimuthRad, self.minAzimuthAbsoluteRad)
		self.curAzimuthRad = math.min(self.curAzimuthRad, self.maxAzimuthAbsoluteRad)
	end
end
function OrbitalCamera:SetAndBoundsCheckElevationValues()
	local minElevationDeg = math.max(self.externalProperties.MinElevation, MIN_ALLOWED_ELEVATION_DEG)
	local maxElevationDeg = math.min(self.externalProperties.MaxElevation, MAX_ALLOWED_ELEVATION_DEG)
	self.minElevationRad = math.rad(math.min(minElevationDeg, maxElevationDeg))
	self.maxElevationRad = math.rad(math.max(minElevationDeg, maxElevationDeg))
	self.curElevationRad = math.max(self.curElevationRad, self.minElevationRad)
	self.curElevationRad = math.min(self.curElevationRad, self.maxElevationRad)
end
function OrbitalCamera:SetAndBoundsCheckDistanceValues()
	self.minDistance = self.externalProperties.MinDistance
	self.maxDistance = self.externalProperties.MaxDistance
	self.curDistance = math.max(self.curDistance, self.minDistance)
	self.curDistance = math.min(self.curDistance, self.maxDistance)
end
function OrbitalCamera:LoadNumberValueParameters()
	self:LoadOrCreateNumberValueParameter("InitialElevation", "NumberValue", nil)
	self:LoadOrCreateNumberValueParameter("InitialDistance", "NumberValue", nil)
	self:LoadOrCreateNumberValueParameter("ReferenceAzimuth", "NumberValue", self.SetAndBoundsCheckAzimuthValue)
	self:LoadOrCreateNumberValueParameter("CWAzimuthTravel", "NumberValue", self.SetAndBoundsCheckAzimuthValues)
	self:LoadOrCreateNumberValueParameter("CCWAzimuthTravel", "NumberValue", self.SetAndBoundsCheckAzimuthValues)
	self:LoadOrCreateNumberValueParameter("MinElevation", "NumberValue", self.SetAndBoundsCheckElevationValues)
	self:LoadOrCreateNumberValueParameter("MaxElevation", "NumberValue", self.SetAndBoundsCheckElevationValues)
	self:LoadOrCreateNumberValueParameter("MinDistance", "NumberValue", self.SetAndBoundsCheckDistanceValues)
	self:LoadOrCreateNumberValueParameter("MaxDistance", "NumberValue", self.SetAndBoundsCheckDistanceValues)
	self:LoadOrCreateNumberValueParameter("UseAzimuthLimits", "BoolValue", self.SetAndBoundsCheckAzimuthValues)
	self.curAzimuthRad = math.rad(self.externalProperties.ReferenceAzimuth)
	self.curElevationRad = math.rad(self.externalProperties.InitialElevation)
	self.curDistance = self.externalProperties.InitialDistance
	self:SetAndBoundsCheckAzimuthValues()
	self:SetAndBoundsCheckElevationValues()
	self:SetAndBoundsCheckDistanceValues()
end
function OrbitalCamera:GetModuleName()
	return "OrbitalCamera"
end
function OrbitalCamera:SetInitialOrientation(humanoid)
	if not humanoid or not humanoid.RootPart then
		warn("OrbitalCamera could not set initial orientation due to missing humanoid")
		return
	end
	local newDesiredLook = (humanoid.RootPart.CFrame.lookVector - Vector3.new(0, 0.23, 0)).unit
	local horizontalShift = Util.GetAngleBetweenXZVectors(newDesiredLook, self:GetCameraLookVector())
	local vertShift = math.asin(self:GetCameraLookVector().y) - math.asin(newDesiredLook.y)
	if not Util.IsFinite(horizontalShift) then
		horizontalShift = 0
	end
	if not Util.IsFinite(vertShift) then
		vertShift = 0
	end
	self.rotateInput = Vector2.new(horizontalShift, vertShift)
end
function OrbitalCamera:GetCameraToSubjectDistance()
	return self.curDistance
end
function OrbitalCamera:SetCameraToSubjectDistance(desiredSubjectDistance)
	print("OrbitalCamera SetCameraToSubjectDistance ", desiredSubjectDistance)
	local player = PlayersService.LocalPlayer
	if player then
		self.currentSubjectDistance = Util.Clamp(self.minDistance, self.maxDistance, desiredSubjectDistance)
		self.currentSubjectDistance = math.max(self.currentSubjectDistance, self.FIRST_PERSON_DISTANCE_THRESHOLD)
	end
	self.inFirstPerson = false
	self:UpdateMouseBehavior()
	return self.currentSubjectDistance
end
function OrbitalCamera:CalculateNewLookVector(suppliedLookVector, xyRotateVector)
	local currLookVector = suppliedLookVector or self:GetCameraLookVector()
	local currPitchAngle = math.asin(currLookVector.y)
	local yTheta = Util.Clamp(currPitchAngle - math.rad(MAX_ALLOWED_ELEVATION_DEG), currPitchAngle - math.rad(MIN_ALLOWED_ELEVATION_DEG), xyRotateVector.y)
	local constrainedRotateInput = Vector2.new(xyRotateVector.x, yTheta)
	local startCFrame = CFrame.new(ZERO_VECTOR3, currLookVector)
	local newLookVector = (CFrame.Angles(0, -constrainedRotateInput.x, 0) * startCFrame * CFrame.Angles(-constrainedRotateInput.y, 0, 0)).lookVector
	return newLookVector
end
function OrbitalCamera:GetGamepadPan(name, state, input)
	if input.UserInputType == self.activeGamepad and input.KeyCode == Enum.KeyCode.Thumbstick2 then
		if self.r3ButtonDown or self.l3ButtonDown then
			if input.Position.Y > THUMBSTICK_DEADZONE then
				self.gamepadDollySpeedMultiplier = 0.96
			elseif input.Position.Y < -THUMBSTICK_DEADZONE then
				self.gamepadDollySpeedMultiplier = 1.04
			else
				self.gamepadDollySpeedMultiplier = 1
			end
		else
			if state == Enum.UserInputState.Cancel then
				self.gamepadPanningCamera = ZERO_VECTOR2
				return
			end
			local inputVector = Vector2.new(input.Position.X, -input.Position.Y)
			if inputVector.magnitude > THUMBSTICK_DEADZONE then
				self.gamepadPanningCamera = Vector2.new(input.Position.X, -input.Position.Y)
			else
				self.gamepadPanningCamera = ZERO_VECTOR2
			end
		end
		if FFlagPlayerScriptsBindAtPriority then
			return Enum.ContextActionResult.Sink
		end
	end
	if FFlagPlayerScriptsBindAtPriority then
		return Enum.ContextActionResult.Pass
	end
end
function OrbitalCamera:DoGamepadZoom(name, state, input)
	if input.UserInputType == self.activeGamepad and (input.KeyCode == Enum.KeyCode.ButtonR3 or input.KeyCode == Enum.KeyCode.ButtonL3) then
		if state == Enum.UserInputState.Begin then
			self.r3ButtonDown = input.KeyCode == Enum.KeyCode.ButtonR3
			self.l3ButtonDown = input.KeyCode == Enum.KeyCode.ButtonL3
		elseif state == Enum.UserInputState.End then
			if input.KeyCode == Enum.KeyCode.ButtonR3 then
				self.r3ButtonDown = false
			elseif input.KeyCode == Enum.KeyCode.ButtonL3 then
				self.l3ButtonDown = false
			end
			if not self.r3ButtonDown and not self.l3ButtonDown then
				self.gamepadDollySpeedMultiplier = 1
			end
		end
		if FFlagPlayerScriptsBindAtPriority then
			return Enum.ContextActionResult.Sink
		end
	end
	if FFlagPlayerScriptsBindAtPriority then
		return Enum.ContextActionResult.Pass
	end
end
function OrbitalCamera:BindGamepadInputActions()
	if FFlagPlayerScriptsBindAtPriority then
		self:BindAction("OrbitalCamGamepadPan", function(name, state, input)
			self:GetGamepadPan(name, state, input)
		end, false, Enum.KeyCode.Thumbstick2)
		self:BindAction("OrbitalCamGamepadZoom", function(name, state, input)
			self:DoGamepadZoom(name, state, input)
		end, false, Enum.KeyCode.ButtonR3, Enum.KeyCode.ButtonL3)
	else
		local ContextActionService = game:GetService("ContextActionService")
		ContextActionService:BindAction("OrbitalCamGamepadPan", function(name, state, input)
			self:GetGamepadPan(name, state, input)
		end, false, Enum.KeyCode.Thumbstick2)
		ContextActionService:BindAction("OrbitalCamGamepadZoom", function(name, state, input)
			self:DoGamepadZoom(name, state, input)
		end, false, Enum.KeyCode.ButtonR3)
		ContextActionService:BindAction("OrbitalCamGamepadZoomAlt", function(name, state, input)
			self:DoGamepadZoom(name, state, input)
		end, false, Enum.KeyCode.ButtonL3)
	end
end
function OrbitalCamera:Update(dt)
	local now = tick()
	local timeDelta = now - self.lastUpdate
	local userPanningTheCamera = self.UserPanningTheCamera == true
	local camera = workspace.CurrentCamera
	local newCameraCFrame = camera.CFrame
	local newCameraFocus = camera.Focus
	local player = PlayersService.LocalPlayer
	local humanoid = self:GetHumanoid()
	local cameraSubject = camera and camera.CameraSubject
	local isInVehicle = cameraSubject and cameraSubject:IsA("VehicleSeat")
	local isOnASkateboard = cameraSubject and cameraSubject:IsA("SkateboardPlatform")
	if self.lastUpdate == nil or timeDelta > 1 then
		self.lastCameraTransform = nil
	end
	if self.lastUpdate then
		local gamepadRotation = self:UpdateGamepad()
		if self:ShouldUseVRRotation() then
			self.RotateInput = self.RotateInput + self:GetVRRotationInput()
		else
			local delta = math.min(0.1, timeDelta)
			if gamepadRotation ~= ZERO_VECTOR2 then
				userPanningTheCamera = true
				self.rotateInput = self.rotateInput + gamepadRotation * delta
			end
			local angle = 0
			if not isInVehicle and not isOnASkateboard then
				angle = angle + (self.TurningLeft and -120 or 0)
				angle = angle + (self.TurningRight and 120 or 0)
			end
			if angle ~= 0 then
				self.rotateInput = self.rotateInput + Vector2.new(math.rad(angle * delta), 0)
				userPanningTheCamera = true
			end
		end
	end
	if userPanningTheCamera then
		tweenSpeed = 0
		self.lastUserPanCamera = tick()
	end
	local userRecentlyPannedCamera = now - self.lastUserPanCamera < TIME_BEFORE_AUTO_ROTATE
	local subjectPosition = self:GetSubjectPosition()
	if subjectPosition and player and camera then
		if self.gamepadDollySpeedMultiplier ~= 1 then
			self:SetCameraToSubjectDistance(self.currentSubjectDistance * self.gamepadDollySpeedMultiplier)
		end
		local VREnabled = VRService.VREnabled
		newCameraFocus = VREnabled and self:GetVRFocus(subjectPosition, timeDelta) or CFrame.new(subjectPosition)
		local cameraFocusP = newCameraFocus.p
		if VREnabled and not self:IsInFirstPerson() then
			local cameraHeight = self:GetCameraHeight()
			local vecToSubject = subjectPosition - camera.CFrame.p
			local distToSubject = vecToSubject.magnitude
			if distToSubject > self.currentSubjectDistance or self.rotateInput.x ~= 0 then
				local desiredDist = math.min(distToSubject, self.currentSubjectDistance)
				vecToSubject = self:CalculateNewLookVector(vecToSubject.unit * X1_Y0_Z1, Vector2.new(self.rotateInput.x, 0)) * desiredDist
				local newPos = cameraFocusP - vecToSubject
				local desiredLookDir = camera.CFrame.lookVector
				if self.rotateInput.x ~= 0 then
					desiredLookDir = vecToSubject
				end
				local lookAt = Vector3.new(newPos.x + desiredLookDir.x, newPos.y, newPos.z + desiredLookDir.z)
				self.RotateInput = ZERO_VECTOR2
				newCameraCFrame = CFrame.new(newPos, lookAt) + Vector3.new(0, cameraHeight, 0)
			end
		else
			self.curAzimuthRad = self.curAzimuthRad - self.rotateInput.x
			if self.useAzimuthLimits then
				self.curAzimuthRad = Util.Clamp(self.minAzimuthAbsoluteRad, self.maxAzimuthAbsoluteRad, self.curAzimuthRad)
			else
				self.curAzimuthRad = self.curAzimuthRad ~= 0 and math.sign(self.curAzimuthRad) * (math.abs(self.curAzimuthRad) % TAU) or 0
			end
			self.curElevationRad = Util.Clamp(self.minElevationRad, self.maxElevationRad, self.curElevationRad + self.rotateInput.y)
			local cameraPosVector = self.currentSubjectDistance * (CFrame.fromEulerAnglesYXZ(-self.curElevationRad, self.curAzimuthRad, 0) * UNIT_Z)
			local camPos = subjectPosition + cameraPosVector
			newCameraCFrame = CFrame.new(camPos, subjectPosition)
			self.rotateInput = ZERO_VECTOR2
		end
		self.lastCameraTransform = newCameraCFrame
		self.lastCameraFocus = newCameraFocus
		if (isInVehicle or isOnASkateboard) and cameraSubject:IsA("BasePart") then
			self.lastSubjectCFrame = cameraSubject.CFrame
		else
			self.lastSubjectCFrame = nil
		end
	end
	self.lastUpdate = now
	return newCameraCFrame, newCameraFocus
end
return OrbitalCamera

starterplayerscripts.coreclient.playermodule.cameramodule.poppercam
--SynapseX Decompiler

local ZoomController = require(script.Parent:WaitForChild("ZoomController"))
local TransformExtrapolator = {}
TransformExtrapolator.__index = TransformExtrapolator
do
	local CF_IDENTITY = CFrame.new()
	local cframeToAxis = function(cframe)
		local axis, angle = cframe:toAxisAngle()
		return axis * angle
	end
	local function axisToCFrame(axis)
		local angle = axis.magnitude
		if angle > 1.0E-5 then
			return CFrame.fromAxisAngle(axis, angle)
		end
		return CF_IDENTITY
	end
	local extractRotation = function(cf)
		local _, _, _, xx, yx, zx, xy, yy, zy, xz, yz, zz = cf:components()
		return CFrame.new(0, 0, 0, xx, yx, zx, xy, yy, zy, xz, yz, zz)
	end
	function TransformExtrapolator.new()
		return setmetatable({lastCFrame = nil}, TransformExtrapolator)
	end
	function TransformExtrapolator:Step(dt, currentCFrame)
		local lastCFrame = self.lastCFrame or currentCFrame
		self.lastCFrame = currentCFrame
		local currentPos = currentCFrame.p
		local currentRot = extractRotation(currentCFrame)
		local lastPos = lastCFrame.p
		local lastRot = extractRotation(lastCFrame)
		local dp = (currentPos - lastPos) / dt
		local dr = cframeToAxis(currentRot * lastRot:inverse()) / dt
		local function extrapolate(t)
			local p = dp * t + currentPos
			local r = axisToCFrame(dr * t) * currentRot
			return r + p
		end
		return {
			extrapolate = extrapolate,
			posVelocity = dp,
			rotVelocity = dr
		}
	end
	function TransformExtrapolator:Reset()
		self.lastCFrame = nil
	end
end
local BaseOcclusion = require(script.Parent:WaitForChild("BaseOcclusion"))
local Poppercam = setmetatable({}, BaseOcclusion)
Poppercam.__index = Poppercam
function Poppercam.new()
	local self = setmetatable(BaseOcclusion.new(), Poppercam)
	self.focusExtrapolator = TransformExtrapolator.new()
	return self
end
function Poppercam:GetOcclusionMode()
	return Enum.DevCameraOcclusionMode.Zoom
end
function Poppercam:Enable(enable)
	self.focusExtrapolator:Reset()
end
function Poppercam:Update(renderDt, desiredCameraCFrame, desiredCameraFocus, cameraController)
	local rotatedFocus = CFrame.new(desiredCameraFocus.p, desiredCameraCFrame.p) * CFrame.new(0, 0, 0, -1, 0, 0, 0, 1, 0, 0, 0, -1)
	local extrapolation = self.focusExtrapolator:Step(renderDt, rotatedFocus)
	local zoom = ZoomController.Update(renderDt, rotatedFocus, extrapolation)
	return rotatedFocus * CFrame.new(0, 0, zoom), desiredCameraFocus
end
function Poppercam:CharacterAdded(character, player)
end
function Poppercam:CharacterRemoving(character, player)
end
function Poppercam:OnCameraSubjectChanged(newSubject)
end
return Poppercam

starterplayerscripts.coreclient.playermodule.cameramodule.poppercam_classic
--SynapseX Decompiler

local Util = require(script.Parent:WaitForChild("CameraUtils"))
local PlayersService = game:GetService("Players")
local POP_RESTORE_RATE = 0.3
local MIN_CAMERA_ZOOM = 0.5
local VALID_SUBJECTS = {
	"Humanoid",
	"VehicleSeat",
	"SkateboardPlatform"
}
local portraitPopperFixFlagExists, portraitPopperFixFlagEnabled = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserPortraitPopperFix")
end)
local FFlagUserPortraitPopperFix = portraitPopperFixFlagExists and portraitPopperFixFlagEnabled
local BaseOcclusion = require(script.Parent:WaitForChild("BaseOcclusion"))
local Poppercam = setmetatable({}, BaseOcclusion)
Poppercam.__index = Poppercam
function Poppercam.new()
	local self = setmetatable(BaseOcclusion.new(), Poppercam)
	self.camera = nil
	self.cameraSubjectChangeConn = nil
	self.subjectPart = nil
	self.playerCharacters = {}
	self.vehicleParts = {}
	self.lastPopAmount = 0
	self.lastZoomLevel = 0
	self.popperEnabled = false
	return self
end
function Poppercam:GetOcclusionMode()
	return Enum.DevCameraOcclusionMode.Zoom
end
function Poppercam:Enable(enable)
end
function Poppercam:CharacterAdded(char, player)
	self.playerCharacters[player] = char
end
function Poppercam:CharacterRemoving(char, player)
	self.playerCharacters[player] = nil
end
function Poppercam:Update(dt, desiredCameraCFrame, desiredCameraFocus)
	if self.popperEnabled then
		self.camera = game.Workspace.CurrentCamera
		local newCameraCFrame = desiredCameraCFrame
		local focusPoint = desiredCameraFocus.p
		if FFlagUserPortraitPopperFix and self.subjectPart then
			focusPoint = self.subjectPart.CFrame.p
		end
		local ignoreList = {}
		for _, character in pairs(self.playerCharacters) do
			ignoreList[#ignoreList + 1] = character
		end
		for i = 1, #self.vehicleParts do
			ignoreList[#ignoreList + 1] = self.vehicleParts[i]
		end
		local prevCameraCFrame = self.camera.CFrame
		self.camera.CFrame = desiredCameraCFrame
		self.camera.Focus = desiredCameraFocus
		local largest = self.camera:GetLargestCutoffDistance(ignoreList)
		local zoomLevel = (desiredCameraCFrame.p - focusPoint).Magnitude
		if math.abs(zoomLevel - self.lastZoomLevel) > 0.001 then
			self.lastPopAmount = 0
		end
		local popAmount = largest
		if popAmount < self.lastPopAmount then
			popAmount = self.lastPopAmount
		end
		if popAmount > 0 then
			newCameraCFrame = desiredCameraCFrame + desiredCameraCFrame.lookVector * popAmount
			self.lastPopAmount = popAmount - POP_RESTORE_RATE
			if self.lastPopAmount < 0 then
				self.lastPopAmount = 0
			end
		end
		self.lastZoomLevel = zoomLevel
		return newCameraCFrame, desiredCameraFocus
	end
	return desiredCameraCFrame, desiredCameraFocus
end
function Poppercam:OnCameraSubjectChanged(newSubject)
	self.vehicleParts = {}
	self.lastPopAmount = 0
	if newSubject then
		self.popperEnabled = false
		for _, subjectType in pairs(VALID_SUBJECTS) do
			if newSubject:IsA(subjectType) then
				self.popperEnabled = true
				break
			end
		end
		if newSubject:IsA("VehicleSeat") then
			self.vehicleParts = newSubject:GetConnectedParts(true)
		end
		if FFlagUserPortraitPopperFix then
			if newSubject:IsA("BasePart") then
				self.subjectPart = newSubject
			elseif newSubject:IsA("Model") then
				if newSubject.PrimaryPart then
					self.subjectPart = newSubject.PrimaryPart
				else
					for _, child in pairs(newSubject:GetChildren()) do
						if child:IsA("BasePart") then
							self.subjectPart = child
							break
						end
					end
				end
			elseif newSubject:IsA("Humanoid") then
				self.subjectPart = newSubject.RootPart
			end
		end
	end
end
return Poppercam

starterplayerscripts.coreclient.playermodule.cameramodule.transparencycontroller
--SynapseX Decompiler

local MAX_TWEEN_RATE = 2.8
local Util = require(script.Parent:WaitForChild("CameraUtils"))
local TransparencyController = {}
TransparencyController.__index = TransparencyController
function TransparencyController.new()
	local self = setmetatable({}, TransparencyController)
	self.lastUpdate = tick()
	self.transparencyDirty = false
	self.enabled = false
	self.lastTransparency = nil
	self.descendantAddedConn, self.descendantRemovingConn = nil, nil
	self.toolDescendantAddedConns = {}
	self.toolDescendantRemovingConns = {}
	self.cachedParts = {}
	self.Invalids = {
		["Right Arm"] = true,
		["Left Arm"] = true,
		["Right Leg"] = true,
		["Left Leg"] = true,
		RightUpperArm = true,
		RightLowerArm = true,
		RightHand = true,
		LeftUpperArm = true,
		LeftLowerArm = true,
		LeftHand = true,
		RightUpperLeg = true,
		RightLowerLeg = true,
		RightFoot = true,
		LeftUpperLeg = true,
		LeftLowerLeg = true,
		LeftFoot = true
	}
	return self
end
function TransparencyController:HasToolAncestor(object)
	if object.Parent == nil then
		return false
	end
	return object.Parent:IsA("Configuration") or self:HasToolAncestor(object.Parent)
end
function TransparencyController:IsValidPartToModify(part)
	if (part:IsA("BasePart") or part:IsA("Decal")) and not self.Invalids[part.Name] then
		return not self:HasToolAncestor(part)
	end
	return false
end
function TransparencyController:CachePartsRecursive(object)
	if object then
		if self:IsValidPartToModify(object) then
			self.cachedParts[object] = true
			self.transparencyDirty = true
		end
		for _, child in pairs(object:GetChildren()) do
			self:CachePartsRecursive(child)
		end
	end
end
function TransparencyController:TeardownTransparency()
	for child, _ in pairs(self.cachedParts) do
		child.LocalTransparencyModifier = 0
	end
	self.cachedParts = {}
	self.transparencyDirty = true
	self.lastTransparency = nil
	if self.descendantAddedConn then
		self.descendantAddedConn:disconnect()
		self.descendantAddedConn = nil
	end
	if self.descendantRemovingConn then
		self.descendantRemovingConn:disconnect()
		self.descendantRemovingConn = nil
	end
	for object, conn in pairs(self.toolDescendantAddedConns) do
		conn:Disconnect()
		self.toolDescendantAddedConns[object] = nil
	end
	for object, conn in pairs(self.toolDescendantRemovingConns) do
		conn:Disconnect()
		self.toolDescendantRemovingConns[object] = nil
	end
end
function TransparencyController:SetupTransparency(character)
	self:TeardownTransparency()
	if self.descendantAddedConn then
		self.descendantAddedConn:disconnect()
	end
	self.descendantAddedConn = character.DescendantAdded:Connect(function(object)
		if self:IsValidPartToModify(object) then
			self.cachedParts[object] = true
			self.transparencyDirty = true
		elseif object:IsA("Tool") then
			if self.toolDescendantAddedConns[object] then
				self.toolDescendantAddedConns[object]:Disconnect()
			end
			self.toolDescendantAddedConns[object] = object.DescendantAdded:Connect(function(toolChild)
				self.cachedParts[toolChild] = nil
				if toolChild:IsA("BasePart") or toolChild:IsA("Decal") then
					toolChild.LocalTransparencyModifier = 0
				end
			end)
			if self.toolDescendantRemovingConns[object] then
				self.toolDescendantRemovingConns[object]:disconnect()
			end
			self.toolDescendantRemovingConns[object] = object.DescendantRemoving:Connect(function(formerToolChild)
				game:GetService("RunService").Heartbeat:wait()
				if character and formerToolChild and formerToolChild:IsDescendantOf(character) and self:IsValidPartToModify(formerToolChild) then
					self.cachedParts[formerToolChild] = true
					self.transparencyDirty = true
				end
			end)
		end
	end)
	if self.descendantRemovingConn then
		self.descendantRemovingConn:disconnect()
	end
	self.descendantRemovingConn = character.DescendantRemoving:connect(function(object)
		if self.cachedParts[object] then
			self.cachedParts[object] = nil
			object.LocalTransparencyModifier = 0
		end
	end)
	self:CachePartsRecursive(character)
end
function TransparencyController:Enable(enable)
	if self.enabled ~= enable then
		self.enabled = enable
		self:Update()
	end
end
function TransparencyController:SetSubject(subject)
	local character
	if subject and subject:IsA("Humanoid") then
		character = subject.Parent
	end
	if subject and subject:IsA("VehicleSeat") and subject.Occupant then
		character = subject.Occupant.Parent
	end
	if character then
		self:SetupTransparency(character)
	else
		self:TeardownTransparency()
	end
end
function TransparencyController:Update()
	local instant = false
	local now = tick()
	local currentCamera = workspace.CurrentCamera
	if currentCamera then
		local transparency = 0
		if not self.enabled then
			instant = true
		else
			local distance = (currentCamera.Focus.p - currentCamera.CoordinateFrame.p).magnitude
			transparency = distance < 2 and 1 - (distance - 0.5) / 1.5 or 0
			if transparency < 0.5 then
				transparency = 0
			end
			if self.lastTransparency then
				local deltaTransparency = transparency - self.lastTransparency
				if not instant and transparency < 1 and self.lastTransparency < 0.95 then
					local maxDelta = MAX_TWEEN_RATE * (now - self.lastUpdate)
					deltaTransparency = Util.Clamp(-maxDelta, maxDelta, deltaTransparency)
				end
				transparency = self.lastTransparency + deltaTransparency
			else
				self.transparencyDirty = true
			end
			transparency = Util.Clamp(0, 1, Util.Round(transparency, 2))
		end
		if self.transparencyDirty or self.lastTransparency ~= transparency then
			for child, _ in pairs(self.cachedParts) do
				child.LocalTransparencyModifier = transparency
			end
			self.transparencyDirty = false
			self.lastTransparency = transparency
		end
	end
	self.lastUpdate = now
end
return TransparencyController

starterplayerscripts.coreclient.playermodule.cameramodule.zoomcontroller
--SynapseX Decompiler

local ZOOM_STIFFNESS = 4.5
local ZOOM_DEFAULT = 12.5
local ZOOM_ACCELERATION = 0.0375
local DIST_OPAQUE = 1
local Popper = require(script:WaitForChild("Popper"))
local clamp = math.clamp
local exp = math.exp
local min = math.min
local max = math.max
local pi = math.pi
local cameraMinZoomDistance, cameraMaxZoomDistance

local Player = game:GetService("Players").LocalPlayer

-- Save defaults
local defaultMin = Player.CameraMinZoomDistance
local defaultMax = Player.CameraMaxZoomDistance

-- Custom zoom values for seats
local seatMin = 5
local seatMax = 100000

local function updateBounds()
	cameraMinZoomDistance = Player.CameraMinZoomDistance
	cameraMaxZoomDistance = Player.CameraMaxZoomDistance
end
updateBounds()
Player:GetPropertyChangedSignal("CameraMinZoomDistance"):Connect(updateBounds)
Player:GetPropertyChangedSignal("CameraMaxZoomDistance"):Connect(updateBounds)

-- 🔥 Hook all PilotSeats (even inside models)
local function hookSeat(seat)
	seat:GetPropertyChangedSignal("Occupant"):Connect(function()
		local occupant = seat.Occupant
		if occupant and occupant.Parent == Player.Character then
			-- Sitting in a PilotSeat
			cameraMinZoomDistance = seatMin
			cameraMaxZoomDistance = seatMax
		else
			-- Reset when leaving
			cameraMinZoomDistance = defaultMin
			cameraMaxZoomDistance = defaultMax
		end
	end)
end

for _, obj in ipairs(workspace:GetDescendants()) do
	if obj:IsA("Seat") and obj.Name == "PilotSeat" then
		hookSeat(obj)
	end
end

workspace.DescendantAdded:Connect(function(obj)
	if obj:IsA("Seat") and obj.Name == "PilotSeat" then
		hookSeat(obj)
	end
end)

-- ==================== ConstrainedSpring ==================== --
local ConstrainedSpring = {}
ConstrainedSpring.__index = ConstrainedSpring
function ConstrainedSpring.new(freq, x, minValue, maxValue)
	x = clamp(x, minValue, maxValue)
	return setmetatable({
		freq = freq,
		x = x,
		v = 0,
		minValue = minValue,
		maxValue = maxValue,
		goal = x
	}, ConstrainedSpring)
end
function ConstrainedSpring:Step(dt)
	local freq = self.freq * 2 * pi
	local x = self.x
	local v = self.v
	local minValue = self.minValue
	local maxValue = self.maxValue
	local goal = self.goal
	local offset = goal - x
	local step = freq * dt
	local decay = exp(-step)
	local x1 = goal + (v * dt - offset * (step + 1)) * decay
	local v1 = ((offset * freq - v) * step + v) * decay
	if minValue > x1 then
		x1 = minValue
		v1 = 0
	elseif maxValue < x1 then
		x1 = maxValue
		v1 = 0
	end
	self.x = x1
	self.v = v1
	return x1
end

local zoomSpring = ConstrainedSpring.new(ZOOM_STIFFNESS, ZOOM_DEFAULT, cameraMinZoomDistance, cameraMaxZoomDistance)

local function stepTargetZoom(z, dz, zoomMin, zoomMax)
	z = clamp(z + dz * (1 + z * ZOOM_ACCELERATION), zoomMin, zoomMax)
	if z < DIST_OPAQUE then
		z = dz <= 0 and zoomMin or DIST_OPAQUE
	end
	return z
end

local zoomDelta = 0
local Zoom = {}
function Zoom.Update(renderDt, focus, extrapolation)
	local poppedZoom = math.huge
	if zoomSpring.goal > DIST_OPAQUE then
		local maxPossibleZoom = max(zoomSpring.x, stepTargetZoom(zoomSpring.goal, zoomDelta, cameraMinZoomDistance, cameraMaxZoomDistance))
		poppedZoom = Popper(focus * CFrame.new(0, 0, cameraMinZoomDistance), maxPossibleZoom - cameraMinZoomDistance, extrapolation) + cameraMinZoomDistance
	end
	zoomSpring.minValue = cameraMinZoomDistance
	zoomSpring.maxValue = min(cameraMaxZoomDistance, poppedZoom)
	return zoomSpring:Step(renderDt)
end
function Zoom.SetZoomParameters(targetZoom, newZoomDelta)
	zoomSpring.goal = targetZoom
	zoomDelta = newZoomDelta
end
return Zoom

starterplayerscripts.coreclient.playermodule.cameramodule.zoomcontroller.popper
--SynapseX Decompiler

local camera = game.Workspace.CurrentCamera
local min = math.min
local tan = math.tan
local rad = math.rad
local inf = math.huge
local ray = Ray.new
local eraseFromEnd = function(t, toSize)
	for i = #t, toSize + 1, -1 do
		t[i] = nil
	end
end
local nearPlaneZ, projX, projY
do
	local function updateProjection()
		local fov = rad(camera.FieldOfView)
		local view = camera.ViewportSize
		local ar = view.X / view.Y
		projY = 2 * tan(fov / 2)
		projX = ar * projY
	end
	camera:GetPropertyChangedSignal("FieldOfView"):Connect(updateProjection)
	camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateProjection)
	updateProjection()
	nearPlaneZ = camera.NearPlaneZ
	camera:GetPropertyChangedSignal("NearPlaneZ"):Connect(function()
		nearPlaneZ = camera.NearPlaneZ
	end)
end
local blacklist = {}
do
	local charMap = {}
	local vehicle = false
	local function refreshIgnoreList()
		local n = 1
		blacklist = {}
		for _, character in pairs(charMap) do
			blacklist[n] = character
			n = n + 1
		end
		if vehicle then
			blacklist[n] = vehicle
			n = n + 1
		end
	end
	local function SubjectChanged()
		local subj = camera.CameraSubject
		if subj and subj:IsA("VehicleSeat") then
			vehicle = subj.Parent.Parent
		else
			vehicle = nil
		end
		refreshIgnoreList()
	end
	SubjectChanged()
	camera:GetPropertyChangedSignal("CameraSubject"):Connect(SubjectChanged)
	local function playerAdded(player)
		local function characterAdded(character)
			charMap[player] = character
			refreshIgnoreList()
		end
		local function characterRemoving()
			charMap[player] = nil
			refreshIgnoreList()
		end
		player.CharacterAppearanceLoaded:Connect(characterAdded)
		player.CharacterRemoving:Connect(characterRemoving)
		if player.Character then
			characterAdded(player.Character)
		end
	end
	local function playerRemoving(player)
		charMap[player] = nil
		refreshIgnoreList()
	end
	local Players = game:GetService("Players")
	Players.PlayerAdded:Connect(playerAdded)
	Players.PlayerRemoving:Connect(playerRemoving)
	for _, player in ipairs(Players:GetPlayers()) do
		playerAdded(player)
	end
	refreshIgnoreList()
end
local canOcclude = function(part)
	return part.Transparency < 0.95 and part.CanCollide
end
local SCAN_SAMPLE_OFFSETS = {
	Vector2.new(0.4, 0),
	Vector2.new(-0.4, 0),
	Vector2.new(0, -0.4),
	Vector2.new(0, 0.4),
	Vector2.new(0, 0.2)
}
local function getCollisionPoint(origin, dir)
	local originalSize = #blacklist
	repeat
		local hitPart, hitPoint = workspace:FindPartOnRayWithIgnoreList(ray(origin, dir), blacklist, false, true)
		if hitPart then
			if hitPart.CanCollide then
				eraseFromEnd(blacklist, originalSize)
				return hitPoint, true
			end
			blacklist[#blacklist + 1] = hitPart
		end
	until not hitPart
	eraseFromEnd(blacklist, originalSize)
	return origin + dir, false
end
local function queryPoint(origin, unitDir, dist, lastPos)
	debug.profilebegin("queryPoint")
	local originalSize = #blacklist
	dist = dist + nearPlaneZ
	local target = origin + unitDir * dist
	local softLimit = inf
	local hardLimit = inf
	local movingOrigin = origin
	repeat
		local entryPart, entryPos = workspace:FindPartOnRayWithIgnoreList(ray(movingOrigin, target - movingOrigin), blacklist, false, true)
		if entryPart then
			if canOcclude(entryPart) then
				local wl = {entryPart}
				local exitPart = workspace:FindPartOnRayWithWhitelist(ray(target, entryPos - target), wl, true)
				local lim = (entryPos - origin).Magnitude
				if exitPart then
					local promote = false
					if lastPos then
						promote = workspace:FindPartOnRayWithWhitelist(ray(lastPos, target - lastPos), wl, true) or workspace:FindPartOnRayWithWhitelist(ray(target, lastPos - target), wl, true)
					end
					if promote then
						hardLimit = lim
					elseif dist < softLimit then
						softLimit = lim
					end
				else
					hardLimit = lim
				end
			end
			blacklist[#blacklist + 1] = entryPart
			movingOrigin = entryPos
		end
	until hardLimit < inf or not entryPart
	eraseFromEnd(blacklist, originalSize)
	debug.profileend()
	return softLimit - nearPlaneZ, hardLimit - nearPlaneZ
end
local function queryViewport(focus, dist)
	debug.profilebegin("queryViewport")
	local fP = focus.p
	local fX = focus.rightVector
	local fY = focus.upVector
	local fZ = -focus.lookVector
	local viewport = camera.ViewportSize
	local hardBoxLimit = inf
	local softBoxLimit = inf
	for viewX = 0, 1 do
		local worldX = fX * ((viewX - 0.5) * projX)
		for viewY = 0, 1 do
			local worldY = fY * ((viewY - 0.5) * projY)
			local origin = fP + nearPlaneZ * (worldX + worldY)
			local lastPos = camera:ViewportPointToRay(viewport.x * viewX, viewport.y * viewY).Origin
			local softPointLimit, hardPointLimit = queryPoint(origin, fZ, dist, lastPos)
			if hardBoxLimit > hardPointLimit then
				hardBoxLimit = hardPointLimit
			end
			if softBoxLimit > softPointLimit then
				softBoxLimit = softPointLimit
			end
		end
	end
	debug.profileend()
	return softBoxLimit, hardBoxLimit
end
local function testPromotion(focus, dist, focusExtrapolation)
	debug.profilebegin("testPromotion")
	local fP = focus.p
	local fX = focus.rightVector
	local fY = focus.upVector
	local fZ = -focus.lookVector
	debug.profilebegin("extrapolate")
	do
		local SAMPLE_DT = 0.0625
		local SAMPLE_MAX_T = 1.25
		local maxDist = (getCollisionPoint(fP, focusExtrapolation.posVelocity * SAMPLE_MAX_T) - fP).Magnitude
		local combinedSpeed = focusExtrapolation.posVelocity.magnitude
		for dt = 0, min(SAMPLE_MAX_T, focusExtrapolation.rotVelocity.magnitude + maxDist / combinedSpeed), SAMPLE_DT do
			local cfDt = focusExtrapolation.extrapolate(dt)
			if dist <= queryPoint(cfDt.p, -cfDt.lookVector, dist) then
				return false
			end
		end
		debug.profileend()
	end
	debug.profilebegin("testOffsets")
	for _, offset in ipairs(SCAN_SAMPLE_OFFSETS) do
		local scaledOffset = offset
		local pos, isHit = getCollisionPoint(fP, fX * scaledOffset.x + fY * scaledOffset.y)
		if queryPoint(pos, (fP + fZ * dist - pos).Unit, dist) == inf then
			return false
		end
	end
	debug.profileend()
	debug.profileend()
	return true
end
local function Popper(focus, targetDist, focusExtrapolation)
	debug.profilebegin("popper")
	local dist = targetDist
	local soft, hard = queryViewport(focus, targetDist)
	if dist > hard then
		dist = hard
	end
	if soft < dist and testPromotion(focus, targetDist, focusExtrapolation) then
		dist = soft
	end
	debug.profileend()
	return dist
end
return Popper


starterplayerscripts.coreclient.playermodule.controlmodule
--SynapseX Decompiler
local ControlModule = {}
ControlModule.__index = ControlModule
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local Keyboard = require(script:WaitForChild("Keyboard"))
local Gamepad = require(script:WaitForChild("Gamepad"))
local TouchDPad = require(script:WaitForChild("TouchDPad"))
local DynamicThumbstick = require(script:WaitForChild("DynamicThumbstick"))
local ClickToMove = require(script:WaitForChild("ClickToMoveController"))
local TouchThumbstick = require(script:WaitForChild("TouchThumbstick"))
local TouchThumbpad = require(script:WaitForChild("TouchThumbpad"))
local TouchJump = require(script:WaitForChild("TouchJump"))
local VehicleController = require(script:WaitForChild("VehicleController"))
local CONTROL_ACTION_PRIORITY = Enum.ContextActionPriority.Default.Value
local FFlagUserIsNowADynamicThumbstick = false
local status = pcall(function()
	FFlagUserIsNowADynamicThumbstick = UserSettings():IsUserFeatureEnabled("UserIsNowADynamicThumbstick")
end)
FFlagUserIsNowADynamicThumbstick = status and FFlagUserIsNowADynamicThumbstick
local movementEnumToModuleMap = {
	[Enum.TouchMovementMode.DPad] = TouchDPad,
	[Enum.DevTouchMovementMode.DPad] = TouchDPad,
	[Enum.TouchMovementMode.Thumbpad] = TouchThumbpad,
	[Enum.DevTouchMovementMode.Thumbpad] = TouchThumbpad,
	[Enum.TouchMovementMode.Thumbstick] = TouchThumbstick,
	[Enum.DevTouchMovementMode.Thumbstick] = TouchThumbstick,
	[Enum.TouchMovementMode.DynamicThumbstick] = DynamicThumbstick,
	[Enum.DevTouchMovementMode.DynamicThumbstick] = DynamicThumbstick,
	[Enum.TouchMovementMode.ClickToMove] = ClickToMove,
	[Enum.DevTouchMovementMode.ClickToMove] = ClickToMove,
	[Enum.TouchMovementMode.Default] = FFlagUserIsNowADynamicThumbstick and DynamicThumbstick or TouchThumbstick,
	[Enum.ComputerMovementMode.Default] = Keyboard,
	[Enum.ComputerMovementMode.KeyboardMouse] = Keyboard,
	[Enum.DevComputerMovementMode.KeyboardMouse] = Keyboard,
	[Enum.DevComputerMovementMode.Scriptable] = nil,
	[Enum.ComputerMovementMode.ClickToMove] = ClickToMove,
	[Enum.DevComputerMovementMode.ClickToMove] = ClickToMove
}
local computerInputTypeToModuleMap = {
	[Enum.UserInputType.Keyboard] = Keyboard,
	[Enum.UserInputType.MouseButton1] = Keyboard,
	[Enum.UserInputType.MouseButton2] = Keyboard,
	[Enum.UserInputType.MouseButton3] = Keyboard,
	[Enum.UserInputType.MouseWheel] = Keyboard,
	[Enum.UserInputType.MouseMovement] = Keyboard,
	[Enum.UserInputType.Gamepad1] = Gamepad,
	[Enum.UserInputType.Gamepad2] = Gamepad,
	[Enum.UserInputType.Gamepad3] = Gamepad,
	[Enum.UserInputType.Gamepad4] = Gamepad
}
function ControlModule.new()
	local self = setmetatable({}, ControlModule)
	self.controllers = {}
	self.activeControlModule = nil
	self.activeController = nil
	self.touchJumpController = nil
	self.moveFunction = Players.LocalPlayer.Move
	self.humanoid = nil
	self.lastInputType = Enum.UserInputType.None
	self.cameraRelative = true
	self.humanoidSeatedConn = nil
	self.vehicleController = nil
	self.touchControlFrame = nil
	self.vehicleController = VehicleController.new(CONTROL_ACTION_PRIORITY)
	Players.LocalPlayer.CharacterAppearanceLoaded:Connect(function(char)
		self:OnCharacterAdded(char)
	end)
	Players.LocalPlayer.CharacterRemoving:Connect(function(char)
		self:OnCharacterAdded(char)
	end)
	if Players.LocalPlayer.Character then
		self:OnCharacterAdded(Players.LocalPlayer.Character)
	end
	RunService:BindToRenderStep("ControlScriptRenderstep", Enum.RenderPriority.Input.Value, function(dt)
		self:OnRenderStepped(dt)
	end)
	UserInputService.LastInputTypeChanged:Connect(function(newLastInputType)
		self:OnLastInputTypeChanged(newLastInputType)
	end)
	local propertyChangeListeners = {
		UserGameSettings:GetPropertyChangedSignal("TouchMovementMode"):Connect(function()
			self:OnTouchMovementModeChange()
		end),
		Players.LocalPlayer:GetPropertyChangedSignal("DevTouchMovementMode"):Connect(function()
			self:OnTouchMovementModeChange()
		end),
		UserGameSettings:GetPropertyChangedSignal("ComputerMovementMode"):Connect(function()
			self:OnComputerMovementModeChange()
		end),
		Players.LocalPlayer:GetPropertyChangedSignal("DevComputerMovementMode"):Connect(function()
			self:OnComputerMovementModeChange()
		end)
	}
	self.playerGui = nil
	self.touchGui = nil
	self.playerGuiAddedConn = nil
	if UserInputService.TouchEnabled then
		self.playerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
		if self.playerGui then
			self:CreateTouchGuiContainer()
			self:OnLastInputTypeChanged(UserInputService:GetLastInputType())
		else
			self.playerGuiAddedConn = Players.LocalPlayer.ChildAdded:Connect(function(child)
				if child:IsA("PlayerGui") then
					self.playerGui = child
					self:CreateTouchGuiContainer()
					self.playerGuiAddedConn:Disconnect()
					self.playerGuiAddedConn = nil
					self:OnLastInputTypeChanged(UserInputService:GetLastInputType())
				end
			end)
		end
	else
		self:OnLastInputTypeChanged(UserInputService:GetLastInputType())
	end
	return self
end
function ControlModule:GetMoveVector()
	if self.activeController then
		return self.activeController:GetMoveVector()
	end
	return Vector3.new(0, 0, 0)
end
function ControlModule:GetActiveController()
	return self.activeController
end
function ControlModule:Enable(enable)
	if not self.activeController then
		return
	end
	if enable == nil then
		enable = true
	end
	if enable then
		if self.touchControlFrame then
			self.activeController:Enable(true, self.touchControlFrame)
		elseif self.activeControlModule == ClickToMove then
			self.activeController:Enable(true, Players.LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.UserChoice)
		else
			self.activeController:Enable(true)
		end
	else
		self:Disable()
	end
end
function ControlModule:Disable()
	if self.activeController then
		self.activeController:Enable(false)
		if self.moveFunction then
			self.moveFunction(Players.LocalPlayer, Vector3.new(0, 0, 0), self.cameraRelative)
		end
	end
end
function ControlModule:SelectComputerMovementModule()
	if not UserInputService.KeyboardEnabled and not UserInputService.GamepadEnabled then
		return nil, false
	end
	local computerModule
	local DevMovementMode = Players.LocalPlayer.DevComputerMovementMode
	if DevMovementMode == Enum.DevComputerMovementMode.UserChoice then
		computerModule = computerInputTypeToModuleMap[lastInputType]
		if UserGameSettings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove and computerModule == Keyboard then
			computerModule = ClickToMove
		end
	else
		computerModule = movementEnumToModuleMap[DevMovementMode]
		if not computerModule and DevMovementMode ~= Enum.DevComputerMovementMode.Scriptable then
			warn("No character control module is associated with DevComputerMovementMode ", DevMovementMode)
		end
	end
	if computerModule then
		return computerModule, true
	elseif DevMovementMode == Enum.DevComputerMovementMode.Scriptable then
		return nil, true
	else
		return nil, false
	end
end
function ControlModule:SelectTouchModule()
	if not UserInputService.TouchEnabled then
		return nil, false
	end
	local touchModule
	local DevMovementMode = Players.LocalPlayer.DevTouchMovementMode
	if DevMovementMode == Enum.DevTouchMovementMode.UserChoice then
		touchModule = movementEnumToModuleMap[UserGameSettings.TouchMovementMode]
	elseif DevMovementMode == Enum.DevTouchMovementMode.Scriptable then
		return nil, true
	else
		touchModule = movementEnumToModuleMap[DevMovementMode]
	end
	return touchModule, true
end
function ControlModule:OnRenderStepped(dt)
	if self.activeController and self.activeController.enabled and self.humanoid then
		local moveVector = self.activeController:GetMoveVector()
		local vehicleConsumedInput = false
		if self.vehicleController then
			moveVector, vehicleConsumedInput = self.vehicleController:Update(moveVector, self.activeControlModule == Gamepad)
		end
		self.moveFunction(Players.LocalPlayer, moveVector, self.cameraRelative)
		local stateEnabled = self.humanoid:GetStateEnabled(Enum.HumanoidStateType.Jumping)
		self.humanoid.Jump = (self.activeController:GetIsJumping() or self.touchJumpController and self.touchJumpController:GetIsJumping()) and stateEnabled
		self.activeController.isJumping = false
	end
end
function ControlModule:OnHumanoidSeated(active, currentSeatPart)
	if active then
		if currentSeatPart and currentSeatPart:IsA("VehicleSeat") then
			if not self.vehicleController then
				self.vehicleController = self.vehicleController.new(CONTROL_ACTION_PRIORITY)
			end
			self.vehicleController:Enable(true, currentSeatPart)
		end
	elseif self.vehicleController then
		self.vehicleController:Enable(false, currentSeatPart)
	end
end
function ControlModule:OnCharacterAdded(char)
	self.humanoid = char:FindFirstChildOfClass("Humanoid")
	while not self.humanoid do
		char.ChildAdded:wait()
		self.humanoid = char:FindFirstChildOfClass("Humanoid")
	end
	if self.humanoidSeatedConn then
		self.humanoidSeatedConn:Disconnect()
		self.humanoidSeatedConn = nil
	end
	self.humanoidSeatedConn = self.humanoid.Seated:Connect(function(active, currentSeatPart)
		self:OnHumanoidSeated(active, currentSeatPart)
	end)
end
function ControlModule:OnCharacterRemoving(char)
	self.humanoid = nil
end
function ControlModule:SwitchToController(controlModule)
	if not controlModule then
		if self.activeController then
			self.activeController:Enable(false)
		end
		self.activeController = nil
		self.activeControlModule = nil
	else
		if not self.controllers[controlModule] then
			self.controllers[controlModule] = controlModule.new(CONTROL_ACTION_PRIORITY)
		end
		if self.activeController ~= self.controllers[controlModule] then
			if self.activeController then
				self.activeController:Enable(false)
			end
			self.activeController = self.controllers[controlModule]
			self.activeControlModule = controlModule
			if self.touchControlFrame then
				self.activeController:Enable(true, self.touchControlFrame)
			elseif self.activeControlModule == ClickToMove then
				self.activeController:Enable(true, Players.LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.UserChoice)
			else
				self.activeController:Enable(true)
			end
			if self.touchControlFrame and (self.activeControlModule == TouchThumbpad or self.activeControlModule == TouchThumbstick or self.activeControlModule == ClickToMove or self.activeControlModule == DynamicThumbstick) then
				self.touchJumpController = self.controllers[TouchJump]
				if not self.touchJumpController then
					self.touchJumpController = TouchJump.new()
				end
				self.touchJumpController:Enable(true, self.touchControlFrame)
			elseif self.touchJumpController then
				self.touchJumpController:Enable(false)
			end
		end
	end
end
function ControlModule:OnLastInputTypeChanged(newLastInputType)
	if lastInputType == newLastInputType then
		warn("LastInputType Change listener called with current type.")
	end
	lastInputType = newLastInputType
	if lastInputType == Enum.UserInputType.Touch then
		local touchModule, success = self:SelectTouchModule()
		if success then
			while not self.touchControlFrame do
				game:GetService("RunService").Heartbeat:wait()
			end
			self:SwitchToController(touchModule)
		end
	elseif computerInputTypeToModuleMap[lastInputType] ~= nil then
		local computerModule = self:SelectComputerMovementModule()
		if computerModule then
			self:SwitchToController(computerModule)
		end
	end
end
function ControlModule:OnComputerMovementModeChange()
	local controlModule, success = self:SelectComputerMovementModule()
	if success then
		self:SwitchToController(controlModule)
	end
end
function ControlModule:OnTouchMovementModeChange()
	local touchModule, success = self:SelectTouchModule()
	if success then
		while not self.touchControlFrame do
			game:GetService("RunService").Heartbeat:wait()
		end
		self:SwitchToController(touchModule)
	end
end
function ControlModule:CreateTouchGuiContainer()
	if self.touchGui then
		self.touchGui:Destroy()
	end
	self.touchGui = Instance.new("ScreenGui")
	self.touchGui.Name = "TouchGui"
	self.touchGui.ResetOnSpawn = false
	self.touchControlFrame = Instance.new("Frame")
	self.touchControlFrame.Name = "TouchControlFrame"
	self.touchControlFrame.Size = UDim2.new(1, 0, 1, 0)
	self.touchControlFrame.BackgroundTransparency = 1
	self.touchControlFrame.Parent = self.touchGui
	self.touchGui.Parent = self.playerGui
end
return ControlModule.new()

starterplayerscripts.coreclient.playermodule.controlmodule.basecharactercontroller
--SynapseX Decompiler

local ZERO_VECTOR3 = Vector3.new(0, 0, 0)
local Players = game:GetService("Players")
local BaseCharacterController = {}
BaseCharacterController.__index = BaseCharacterController
function BaseCharacterController.new()
	local self = setmetatable({}, BaseCharacterController)
	self.enabled = false
	self.moveVector = ZERO_VECTOR3
	self.isJumping = false
	return self
end
function BaseCharacterController:GetMoveVector()
	return self.moveVector
end
function BaseCharacterController:GetIsJumping()
	return self.isJumping
end
function BaseCharacterController:Enable(enable)
	error("BaseCharacterController:Enable must be overridden in derived classes and should not be called.")
	return false
end
return BaseCharacterController

starterplayerscripts.coreclient.playermodule.controlmodule.clicktomovecontroller
--SynapseX Decompiler

local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local PathfindingService = game:GetService("PathfindingService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local DebrisService = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local ZERO_VECTOR3 = Vector3.new(0, 0, 0)
local movementKeys = {
	[Enum.KeyCode.W] = true,
	[Enum.KeyCode.A] = true,
	[Enum.KeyCode.S] = true,
	[Enum.KeyCode.D] = true,
	[Enum.KeyCode.Up] = true,
	[Enum.KeyCode.Down] = true
}
local FFlagUserNavigationClickToMoveUsePathBlockedSuccess, FFlagUserNavigationClickToMoveUsePathBlockedResult = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserNavigationClickToMoveUsePathBlocked")
end)
local FFlagUserNavigationClickToMoveUsePathBlocked = FFlagUserNavigationClickToMoveUsePathBlockedSuccess and FFlagUserNavigationClickToMoveUsePathBlockedResult
local Player = Players.LocalPlayer
local PlayerScripts = Player.PlayerScripts
local TouchJump
local SHOW_PATH = true
local RayCastIgnoreList = workspace.FindPartOnRayWithIgnoreList
local CurrentSeatPart, DrivingTo
local XZ_VECTOR3 = Vector3.new(1, 0, 1)
local ZERO_VECTOR3 = Vector3.new(0, 0, 0)
local ZERO_VECTOR2 = Vector2.new(0, 0)
local BindableEvent_OnFailStateChanged
if UserInputService.TouchEnabled then
end
local Utility = {}
do
	local ViewSizeX = function()
		local camera = workspace.CurrentCamera
		local x = camera and camera.ViewportSize.X or 0
		local y = camera and camera.ViewportSize.Y or 0
		if x == 0 then
			return 1024
		elseif x > y then
			return x
		else
			return y
		end
	end
	Utility.ViewSizeX = ViewSizeX
	local ViewSizeY = function()
		local camera = workspace.CurrentCamera
		local x = camera and camera.ViewportSize.X or 0
		local y = camera and camera.ViewportSize.Y or 0
		if y == 0 then
			return 768
		elseif x > y then
			return y
		else
			return x
		end
	end
	Utility.ViewSizeY = ViewSizeY
	local function FindCharacterAncestor(part)
		if part then
			local humanoid = part:FindFirstChild("Humanoid")
			if humanoid then
				return part, humanoid
			else
				return FindCharacterAncestor(part.Parent)
			end
		end
	end
	Utility.FindCharacterAncestor = FindCharacterAncestor
	local function Raycast(ray, ignoreNonCollidable, ignoreList)
		local ignoreList = ignoreList or {}
		local hitPart, hitPos, hitNorm, hitMat = RayCastIgnoreList(workspace, ray, ignoreList)
		if hitPart then
			if ignoreNonCollidable and hitPart.CanCollide == false then
				table.insert(ignoreList, hitPart)
				return Raycast(ray, ignoreNonCollidable, ignoreList)
			end
			return hitPart, hitPos, hitNorm, hitMat
		end
		return nil, nil
	end
	Utility.Raycast = Raycast
	local function AveragePoints(positions)
		local avgPos = ZERO_VECTOR2
		if #positions > 0 then
			for i = 1, #positions do
				avgPos = avgPos + positions[i]
			end
			avgPos = avgPos / #positions
		end
		return avgPos
	end
	Utility.AveragePoints = AveragePoints
end
local humanoidCache = {}
local function findPlayerHumanoid(player)
	local character = player and player.Character
	if character then
		local resultHumanoid = humanoidCache[player]
		if resultHumanoid and resultHumanoid.Parent == character then
			return resultHumanoid
		else
			humanoidCache[player] = nil
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoidCache[player] = humanoid
			end
			return humanoid
		end
	end
end
local CurrentIgnoreList
local function GetCharacter()
	return Player and Player.Character
end
local function GetTorso()
	local humanoid = findPlayerHumanoid(Player)
	return humanoid and humanoid.RootPart
end
local function getIgnoreList()
	if CurrentIgnoreList then
		return CurrentIgnoreList
	end
	CurrentIgnoreList = {}
	table.insert(CurrentIgnoreList, GetCharacter())
	return CurrentIgnoreList
end
local popupAdornee
local function getPopupAdorneePart()
	if popupAdornee and not popupAdornee.Parent then
		popupAdornee = nil
	end
	if not popupAdornee then
		popupAdornee = Instance.new("Part")
		popupAdornee.Name = "ClickToMovePopupAdornee"
		popupAdornee.Transparency = 1
		popupAdornee.CanCollide = false
		popupAdornee.Anchored = true
		popupAdornee.Size = Vector3.new(2, 2, 2)
		popupAdornee.CFrame = CFrame.new()
		popupAdornee.Parent = workspace.CurrentCamera
	end
	return popupAdornee
end
local activePopups = {}
local function createNewPopup(popupType)
	local newModel = Instance.new("ImageHandleAdornment")
	newModel.AlwaysOnTop = false
	newModel.Transparency = 1
	newModel.Size = ZERO_VECTOR2
	newModel.SizeRelativeOffset = ZERO_VECTOR3
	newModel.Image = "rbxasset://textures/ui/move.png"
	newModel.ZIndex = 20
	local radius = 0
	if popupType == "DestinationPopup" then
		newModel.Color3 = Color3.fromRGB(0, 175, 255)
		radius = 1.25
	elseif popupType == "DirectWalkPopup" then
		newModel.Color3 = Color3.fromRGB(0, 175, 255)
		radius = 1.25
	elseif popupType == "FailurePopup" then
		newModel.Color3 = Color3.fromRGB(255, 100, 100)
		radius = 1.25
	elseif popupType == "PatherPopup" then
		newModel.Color3 = Color3.fromRGB(255, 255, 255)
		radius = 1
		newModel.ZIndex = 10
	end
	newModel.Size = Vector2.new(5, 0.1) * radius
	local dataStructure = {}
	dataStructure.Model = newModel
	activePopups[#activePopups + 1] = newModel
	function dataStructure:TweenIn()
		local tweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
		local tween1 = TweenService:Create(newModel, tweenInfo, {
			Size = Vector2.new(2, 2) * radius
		})
		tween1:Play()
		TweenService:Create(newModel, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0.1), {
			Transparency = 0,
			SizeRelativeOffset = Vector3.new(0, radius * 1.5, 0)
		}):Play()
		return tween1
	end
	function dataStructure:TweenOut()
		local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		local tween1 = TweenService:Create(newModel, tweenInfo, {Size = ZERO_VECTOR2})
		tween1:Play()
		coroutine.wrap(function()
			tween1.Completed:Wait()
			for i = 1, #activePopups do
				if activePopups[i] == newModel then
					table.remove(activePopups, i)
					break
				end
			end
		end)()
		return tween1
	end
	function dataStructure:Place(position, dest)
		if not self.Model.Parent then
			local popupAdorneePart = getPopupAdorneePart()
			self.Model.Parent = popupAdorneePart
			self.Model.Adornee = popupAdorneePart
			local ray = Ray.new(position + Vector3.new(0, 2.5, 0), Vector3.new(0, -10, 0))
			local hitPart, hitPoint, hitNormal = workspace:FindPartOnRayWithIgnoreList(ray, {
				workspace.CurrentCamera,
				Player.Character
			})
			self.Model.CFrame = CFrame.new(hitPoint) + Vector3.new(0, -radius, 0)
		end
	end
	return dataStructure
end
local function createPopupPath(points, numCircles)
	local popups = {}
	local stopTraversing = false
	local function killPopup(i)
		for iter, v in pairs(popups) do
			if iter <= i then
				do
					local tween = v:TweenOut()
					coroutine.wrap(function()
						tween.Completed:Wait()
						v.Model:Destroy()
					end)()
					popups[iter] = nil
				end
			end
		end
	end
	local function stopFunction()
		stopTraversing = true
		killPopup(#points)
	end
	coroutine.wrap(function()
		for i = 1, #points do
			if stopTraversing then
				break
			end
			local includeWaypoint = i % numCircles == 0 and i < #points and (points[#points].Position - points[i].Position).magnitude > 4
			if includeWaypoint then
				local popup = createNewPopup("PatherPopup")
				popups[i] = popup
				local nextPopup = points[i + 1]
				popup:Place(points[i].Position, nextPopup and nextPopup.Position or points[#points].Position)
				local tween = popup:TweenIn()
				wait(0.2)
			end
		end
	end)()
	return stopFunction, killPopup
end
local function Pather(character, endPoint, surfaceNormal)
	local this = {}
	this.Cancelled = false
	this.Started = false
	this.Finished = Instance.new("BindableEvent")
	this.PathFailed = Instance.new("BindableEvent")
	this.PathComputing = false
	this.PathComputed = false
	this.TargetPoint = endPoint
	this.TargetSurfaceNormal = surfaceNormal
	this.DiedConn = nil
	this.SeatedConn = nil
	this.MoveToConn = nil
	this.BlockedConn = nil
	this.CurrentPoint = 0
	function this:Cleanup()
		if this.stopTraverseFunc then
			this.stopTraverseFunc()
			this.stopTraverseFunc = nil
		end
		if this.MoveToConn then
			this.MoveToConn:Disconnect()
			this.MoveToConn = nil
		end
		if this.BlockedConn then
			this.BlockedConn:Disconnect()
			this.BlockedConn = nil
		end
		if this.DiedConn then
			this.DiedConn:Disconnect()
			this.DiedConn = nil
		end
		if this.SeatedConn then
			this.SeatedConn:Disconnect()
			this.SeatedConn = nil
		end
		this.humanoid = nil
	end
	function this:Cancel()
		this.Cancelled = true
		this:Cleanup()
	end
	function this:OnPathInterrupted()
		this.Cancelled = true
		this:OnPointReached(false)
	end
	function this:ComputePath()
		local humanoid = findPlayerHumanoid(Player)
		local torso = humanoid and humanoid.Torso
		local success = false
		if torso then
			if this.PathComputed or this.PathComputing then
				return
			end
			this.PathComputing = true
			success = pcall(function()
				this.pathResult = PathfindingService:FindPathAsync(torso.CFrame.p, this.TargetPoint)
			end)
			this.pointList = this.pathResult and this.pathResult:GetWaypoints()
			if this.pathResult and FFlagUserNavigationClickToMoveUsePathBlocked then
				this.BlockedConn = this.pathResult.Blocked:Connect(function(blockedIdx)
					this:OnPathBlocked(blockedIdx)
				end)
			end
			this.PathComputing = false
			this.PathComputed = this.pathResult and this.pathResult.Status == Enum.PathStatus.Success or false
		end
		return true
	end
	function this:IsValidPath()
		if not this.pathResult then
			this:ComputePath()
		end
		return this.pathResult.Status == Enum.PathStatus.Success
	end
	this.Recomputing = false
	function this:OnPathBlocked(blockedWaypointIdx)
		local pathBlocked = blockedWaypointIdx >= this.CurrentPoint
		if not pathBlocked or this.Recomputing then
			return
		end
		this.Recomputing = true
		if this.stopTraverseFunc then
			this.stopTraverseFunc()
			this.stopTraverseFunc = nil
		end
		this.pathResult:ComputeAsync(this.humanoid.Torso.CFrame.p, this.TargetPoint)
		this.pointList = this.pathResult:GetWaypoints()
		this.PathComputed = this.pathResult and this.pathResult.Status == Enum.PathStatus.Success or false
		if SHOW_PATH then
			this.stopTraverseFunc, this.setPointFunc = createPopupPath(this.pointList, 4, true)
		end
		if this.PathComputed then
			this.humanoid = findPlayerHumanoid(Player)
			this.CurrentPoint = 1
			this:OnPointReached(true)
		else
			this.PathFailed:Fire()
			this:Cleanup()
		end
		this.Recomputing = false
	end
	function this:OnPointReached(reached)
		if reached and not this.Cancelled then
			local nextWaypointIdx = this.CurrentPoint + 1
			if nextWaypointIdx > #this.pointList then
				if this.stopTraverseFunc then
					this.stopTraverseFunc()
				end
				this.Finished:Fire()
				this:Cleanup()
			else
				local currentWaypoint = this.pointList[this.CurrentPoint]
				local nextWaypoint = this.pointList[nextWaypointIdx]
				local currentState = this.humanoid:GetState()
				local isInAir = currentState == Enum.HumanoidStateType.FallingDown or currentState == Enum.HumanoidStateType.Freefall or currentState == Enum.HumanoidStateType.Jumping
				if isInAir then
					local shouldWaitForGround = nextWaypoint.Action == Enum.PathWaypointAction.Jump
					shouldWaitForGround = shouldWaitForGround
					if shouldWaitForGround then
						this.humanoid.FreeFalling:Wait()
						wait(0.1)
					end
				end
				if this.setPointFunc then
					this.setPointFunc(nextWaypointIdx)
				end
				if nextWaypoint.Action == Enum.PathWaypointAction.Jump then
					this.humanoid.Jump = true
				end
				this.humanoid:MoveTo(nextWaypoint.Position)
				this.CurrentPoint = nextWaypointIdx
			end
		else
			this.PathFailed:Fire()
			this:Cleanup()
		end
	end
	function this:Start()
		if CurrentSeatPart then
			return
		end
		this.humanoid = findPlayerHumanoid(Player)
		if not this.humanoid then
			this.PathFailed:Fire()
			return
		end
		if this.Started then
			return
		end
		this.Started = true
		if SHOW_PATH then
			this.stopTraverseFunc, this.setPointFunc = createPopupPath(this.pointList, 4)
		end
		if #this.pointList > 0 then
			this.SeatedConn = this.humanoid.Seated:Connect(function(reached)
				this:OnPathInterrupted()
			end)
			this.DiedConn = this.humanoid.Died:Connect(function(reached)
				this:OnPathInterrupted()
			end)
			this.MoveToConn = this.humanoid.MoveToFinished:Connect(function(reached)
				this:OnPointReached(reached)
			end)
			this.CurrentPoint = 1
			this:OnPointReached(true)
		else
			this.PathFailed:Fire()
			if this.stopTraverseFunc then
				this.stopTraverseFunc()
			end
		end
	end
	this:ComputePath()
	if not this.PathComputed then
		local offsetPoint = this.TargetPoint + this.TargetSurfaceNormal * 1.5
		local ray = Ray.new(offsetPoint, Vector3.new(0, -1, 0) * 50)
		local newHitPart, newHitPos = RayCastIgnoreList(workspace, ray, getIgnoreList())
		if newHitPart then
			this.TargetPoint = newHitPos
		end
		this:ComputePath()
	end
	return this
end
local function IsInBottomLeft(pt)
	local joystickHeight = math.min(Utility.ViewSizeY() * 0.33, 250)
	local joystickWidth = joystickHeight
	return joystickWidth >= pt.X and pt.Y > Utility.ViewSizeY() - joystickHeight
end
local function IsInBottomRight(pt)
	local joystickHeight = math.min(Utility.ViewSizeY() * 0.33, 250)
	local joystickWidth = joystickHeight
	return pt.X >= Utility.ViewSizeX() - joystickWidth and pt.Y > Utility.ViewSizeY() - joystickHeight
end
local function CheckAlive(character)
	local humanoid = findPlayerHumanoid(Player)
	return humanoid ~= nil and humanoid.Health > 0
end
local GetEquippedTool = function(character)
	if character ~= nil then
		for _, child in pairs(character:GetChildren()) do
			if child:IsA("Tool") then
				return child
			end
		end
	end
end
local ExistingPather, ExistingIndicator, PathCompleteListener, PathFailedListener
local function CleanupPath()
	DrivingTo = nil
	if ExistingPather then
		ExistingPather:Cancel()
	end
	if PathCompleteListener then
		PathCompleteListener:Disconnect()
		PathCompleteListener = nil
	end
	if PathFailedListener then
		PathFailedListener:Disconnect()
		PathFailedListener = nil
	end
	if ExistingIndicator then
		do
			local obj = ExistingIndicator
			local tween = obj:TweenOut()
			local tweenCompleteEvent
			tweenCompleteEvent = tween.Completed:connect(function()
				tweenCompleteEvent:Disconnect()
				obj.Model:Destroy()
			end)
			ExistingIndicator = nil
		end
	end
end
local getExtentsSize = function(Parts)
	local maxX, maxY, maxZ = -math.huge, -math.huge, -math.huge
	local minX, minY, minZ = math.huge, math.huge, math.huge
	for i = 1, #Parts do
		maxX, maxY, maxZ = math.max(maxX, Parts[i].Position.X), math.max(maxY, Parts[i].Position.Y), math.max(maxZ, Parts[i].Position.Z)
		minX, minY, minZ = math.min(minX, Parts[i].Position.X), math.min(minY, Parts[i].Position.Y), math.min(minZ, Parts[i].Position.Z)
	end
	return Region3.new(Vector3.new(minX, minY, minZ), Vector3.new(maxX, maxY, maxZ))
end
local inExtents = function(Extents, Position)
	if Position.X < Extents.CFrame.p.X - Extents.Size.X / 2 or Position.X > Extents.CFrame.p.X + Extents.Size.X / 2 then
		return false
	end
	if Position.Z < Extents.CFrame.p.Z - Extents.Size.Z / 2 or Position.Z > Extents.CFrame.p.Z + Extents.Size.Z / 2 then
		return false
	end
	return true
end
local function showQuickPopupAsync(position, popupType)
	local popup = createNewPopup(popupType)
	popup:Place(position, Vector3.new(0, position.y, 0))
	local tweenIn = popup:TweenIn()
	tweenIn.Completed:Wait()
	local tweenOut = popup:TweenOut()
	tweenOut.Completed:Wait()
	popup.Model:Destroy()
	popup = nil
end
local FailCount = 0
local function OnTap(tapPositions, goToPoint)
	local camera = workspace.CurrentCamera
	local character = Player.Character
	if not CheckAlive(character) then
		return
	end
	if #tapPositions == 1 or goToPoint then
		if camera then
			do
				local unitRay = camera:ScreenPointToRay(tapPositions[1].x, tapPositions[1].y)
				local ray = Ray.new(unitRay.Origin, unitRay.Direction * 1000)
				local initIgnore = getIgnoreList()
				local invisicamParts = {}
				local ignoreTab = {}
				for i, v in pairs(invisicamParts) do
					ignoreTab[#ignoreTab + 1] = i
				end
				for i = 1, #initIgnore do
					ignoreTab[#ignoreTab + 1] = initIgnore[i]
				end
				local myHumanoid = findPlayerHumanoid(Player)
				local hitPart, hitPt, hitNormal, hitMat = Utility.Raycast(ray, true, ignoreTab)
				local hitChar, hitHumanoid = Utility.FindCharacterAncestor(hitPart)
				local torso = GetTorso()
				local startPos = torso.CFrame.p
				if goToPoint then
					hitPt = goToPoint
					hitChar = nil
				end
				if hitChar and hitHumanoid and hitHumanoid.RootPart and (hitHumanoid.Torso.CFrame.p - torso.CFrame.p).magnitude < 7 then
					CleanupPath()
					if myHumanoid then
						myHumanoid:MoveTo(hitPt)
					end
					local currentWeapon = GetEquippedTool(character)
					if currentWeapon then
						currentWeapon:Activate()
						LastFired = tick()
					end
				elseif hitPt and character and not CurrentSeatPart then
					local thisPather = Pather(character, hitPt, hitNormal)
					if thisPather:IsValidPath() then
						FailCount = 0
						thisPather:Start()
						if BindableEvent_OnFailStateChanged then
							BindableEvent_OnFailStateChanged:Fire(false)
						end
						CleanupPath()
						do
							local destinationPopup = createNewPopup("DestinationPopup")
							destinationPopup:Place(hitPt, Vector3.new(0, hitPt.y, 0))
							local failurePopup = createNewPopup("FailurePopup")
							local currentTween = destinationPopup:TweenIn()
							ExistingPather = thisPather
							ExistingIndicator = destinationPopup
							PathCompleteListener = thisPather.Finished.Event:Connect(function()
								if destinationPopup then
									if ExistingIndicator == destinationPopup then
										ExistingIndicator = nil
									end
									do
										local tween = destinationPopup:TweenOut()
										local tweenCompleteEvent
										tweenCompleteEvent = tween.Completed:Connect(function()
											tweenCompleteEvent:Disconnect()
											destinationPopup.Model:Destroy()
											destinationPopup = nil
										end)
									end
								end
								if hitChar then
									local humanoid = findPlayerHumanoid(Player)
									local currentWeapon = GetEquippedTool(character)
									if currentWeapon then
										currentWeapon:Activate()
										LastFired = tick()
									end
									if humanoid then
										humanoid:MoveTo(hitPt)
									end
								end
							end)
							PathFailedListener = thisPather.PathFailed.Event:Connect(function()
								CleanupPath()
								if failurePopup then
									failurePopup:Place(hitPt, Vector3.new(0, hitPt.y, 0))
									local failTweenIn = failurePopup:TweenIn()
									failTweenIn.Completed:Wait()
									local failTweenOut = failurePopup:TweenOut()
									failTweenOut.Completed:Wait()
									failurePopup.Model:Destroy()
									failurePopup = nil
								end
							end)
						end
					elseif hitPt then
						local foundDirectPath = false
						if (hitPt - startPos).Magnitude < 25 and startPos.y - hitPt.y > -3 and myHumanoid then
							if myHumanoid.Sit then
								myHumanoid.Jump = true
							end
							myHumanoid:MoveTo(hitPt)
							foundDirectPath = true
						end
						coroutine.wrap(showQuickPopupAsync)(hitPt, foundDirectPath and "DirectWalkPopup" or "FailurePopup")
					end
				elseif hitPt and character and CurrentSeatPart then
					local destinationPopup = createNewPopup("DestinationPopup")
					ExistingIndicator = destinationPopup
					destinationPopup:Place(hitPt, Vector3.new(0, hitPt.y, 0))
					destinationPopup:TweenIn()
					DrivingTo = hitPt
					local ConnectedParts = CurrentSeatPart:GetConnectedParts(true)
					while game:GetService("RunService").Heartbeat:wait() do
						if CurrentSeatPart and ExistingIndicator == destinationPopup then
							local ExtentsSize = getExtentsSize(ConnectedParts)
							if inExtents(ExtentsSize, hitPt) then
								do
									local popup = destinationPopup
									coroutine.wrap(function()
										local tweenOut = popup:TweenOut()
										tweenOut.Completed:Wait()
										popup.Model:Destroy()
									end)()
									destinationPopup = nil
									DrivingTo = nil
									break
								end
							end
						else
							if CurrentSeatPart == nil and destinationPopup == ExistingIndicator then
								DrivingTo = nil
								OnTap(tapPositions, hitPt)
							end
							do
								local popup = destinationPopup
								coroutine.wrap(function()
									local tweenOut = popup:TweenOut()
									tweenOut.Completed:Wait()
									popup.Model:Destroy()
								end)()
								destinationPopup = nil
								break
							end
						end
					end
				end
			end
		end
	elseif #tapPositions >= 2 and camera then
		local avgPoint = Utility.AveragePoints(tapPositions)
		local unitRay = camera:ScreenPointToRay(avgPoint.x, avgPoint.y)
		local currentWeapon = GetEquippedTool(character)
		if currentWeapon then
			currentWeapon:Activate()
			LastFired = tick()
		end
	end
end
local IsFinite = function(num)
	return num == num and num ~= 1 / 0 and num ~= -1 / 0
end
local findAngleBetweenXZVectors = function(vec2, vec1)
	return math.atan2(vec1.X * vec2.Z - vec1.Z * vec2.X, vec1.X * vec2.X + vec1.Z * vec2.Z)
end
local DisconnectEvent = function(event)
	if event then
		event:Disconnect()
	end
end
local KeyboardController = require(script.Parent:WaitForChild("Keyboard"))
local ClickToMove = setmetatable({}, KeyboardController)
ClickToMove.__index = ClickToMove
function ClickToMove.new(CONTROL_ACTION_PRIORITY)
	local self = setmetatable(KeyboardController.new(CONTROL_ACTION_PRIORITY), ClickToMove)
	print("Instantiating ClickToMove Controller")
	self.fingerTouches = {}
	self.numUnsunkTouches = 0
	self.mouse1Down = tick()
	self.mouse1DownPos = Vector2.new()
	self.mouse2DownTime = tick()
	self.mouse2DownPos = Vector2.new()
	self.mouse2UpTime = tick()
	self.tapConn = nil
	self.inputBeganConn = nil
	self.inputChangedConn = nil
	self.inputEndedConn = nil
	self.humanoidDiedConn = nil
	self.characterChildAddedConn = nil
	self.onCharacterAddedConn = nil
	self.characterChildRemovedConn = nil
	self.renderSteppedConn = nil
	self.humanoidSeatedConn = nil
	self.running = false
	self.wasdEnabled = false
	return self
end
function ClickToMove:DisconnectEvents()
	DisconnectEvent(self.tapConn)
	DisconnectEvent(self.inputBeganConn)
	DisconnectEvent(self.inputChangedConn)
	DisconnectEvent(self.inputEndedConn)
	DisconnectEvent(self.humanoidDiedConn)
	DisconnectEvent(self.characterChildAddedConn)
	DisconnectEvent(self.onCharacterAddedConn)
	DisconnectEvent(self.renderSteppedConn)
	DisconnectEvent(self.characterChildRemovedConn)
	DisconnectEvent(self.humanoidSeatedConn)
	pcall(function()
		RunService:UnbindFromRenderStep("ClickToMoveRenderUpdate")
	end)
end
function ClickToMove:OnTouchBegan(input, processed)
	if self.fingerTouches[input] == nil and not processed then
		self.numUnsunkTouches = self.numUnsunkTouches + 1
	end
	self.fingerTouches[input] = processed
end
function ClickToMove:OnTouchChanged(input, processed)
	if self.fingerTouches[input] == nil then
		self.fingerTouches[input] = processed
		if not processed then
			self.numUnsunkTouches = self.numUnsunkTouches + 1
		end
	end
end
function ClickToMove:OnTouchEnded(input, processed)
	if self.fingerTouches[input] ~= nil and self.fingerTouches[input] == false then
		self.numUnsunkTouches = self.numUnsunkTouches - 1
	end
	self.fingerTouches[input] = nil
end
function ClickToMove:OnCharacterAdded(character)
	self:DisconnectEvents()
	self.inputBeganConn = UserInputService.InputBegan:Connect(function(input, processed)
		if input.UserInputType == Enum.UserInputType.Touch then
			self:OnTouchBegan(input, processed)
			local wasInBottomLeft = IsInBottomLeft(input.Position)
			local wasInBottomRight = IsInBottomRight(input.Position)
			if wasInBottomRight or wasInBottomLeft then
				for otherInput, _ in pairs(self.fingerTouches) do
					if otherInput ~= input then
						local otherInputInLeft = IsInBottomLeft(otherInput.Position)
						local otherInputInRight = IsInBottomRight(otherInput.Position)
						if otherInput.UserInputState ~= Enum.UserInputState.End and (wasInBottomLeft and otherInputInRight or wasInBottomRight and otherInputInLeft) then
							if BindableEvent_OnFailStateChanged then
								BindableEvent_OnFailStateChanged:Fire(true)
							end
							return
						end
					end
				end
			end
		end
		if processed == false and input.UserInputType == Enum.UserInputType.Keyboard and movementKeys[input.KeyCode] then
			CleanupPath()
		end
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self.mouse1DownTime = tick()
			self.mouse1DownPos = input.Position
		end
		if input.UserInputType == Enum.UserInputType.MouseButton2 then
			self.mouse2DownTime = tick()
			self.mouse2DownPos = input.Position
		end
	end)
	self.inputChangedConn = UserInputService.InputChanged:Connect(function(input, processed)
		if input.UserInputType == Enum.UserInputType.Touch then
			self:OnTouchChanged(input, processed)
		end
	end)
	self.inputEndedConn = UserInputService.InputEnded:Connect(function(input, processed)
		if input.UserInputType == Enum.UserInputType.Touch then
			self:OnTouchEnded(input, processed)
		end
		if input.UserInputType == Enum.UserInputType.MouseButton2 then
			self.mouse2UpTime = tick()
			local currPos = input.Position
			if self.mouse2UpTime - self.mouse2DownTime < 0.25 and (currPos - self.mouse2DownPos).magnitude < 5 and self.moveVector.Magnitude <= 0 then
				local positions = {currPos}
				OnTap(positions)
			end
		end
	end)
	self.tapConn = UserInputService.TouchTap:Connect(function(touchPositions, processed)
		if not processed then
			OnTap(touchPositions)
		end
	end)
	local computeThrottle = function(dist)
		if dist > 0.2 then
			return 0.5 + dist ^ 2 / 2
		else
			return 0
		end
	end
	local lastSteer = 0
	local kP = 1
	local kD = 0.5
	local function getThrottleAndSteer(object, point)
		local throttle, steer = 0, 0
		local oCF = object.CFrame
		local relativePosition = oCF:pointToObjectSpace(point)
		local relativeZDirection = -relativePosition.z
		local relativeDistance = relativePosition.magnitude
		throttle = computeThrottle(math.min(1, relativeDistance / 50)) * math.sign(relativeZDirection)
		local steerAngle = -math.atan2(-relativePosition.x, -relativePosition.z)
		steer = steerAngle / (math.pi / 4)
		local steerDelta = steer - lastSteer
		lastSteer = steer
		local pdSteer = kP * steer + kD * steer
		return throttle, pdSteer
	end
	local function Update()
		if CurrentSeatPart then
			if DrivingTo then
				local throttle, steer = getThrottleAndSteer(CurrentSeatPart, DrivingTo)
				CurrentSeatPart.ThrottleFloat = throttle
				CurrentSeatPart.SteerFloat = steer
			else
				CurrentSeatPart.ThrottleFloat = 0
				CurrentSeatPart.SteerFloat = 0
			end
		end
		local cameraPos = workspace.CurrentCamera.CFrame.p
		for i = 1, #activePopups do
			local popup = activePopups[i]
			popup.CFrame = CFrame.new(popup.CFrame.p, cameraPos)
		end
	end
	RunService:BindToRenderStep("ClickToMoveRenderUpdate", Enum.RenderPriority.Camera.Value - 1, Update)
	local function OnCharacterChildAdded(child)
		if UserInputService.TouchEnabled and child:IsA("Tool") then
			child.ManualActivationOnly = true
		end
		if child:IsA("Humanoid") then
			DisconnectEvent(self.humanoidDiedConn)
			self.humanoidDiedConn = child.Died:Connect(function()
				if ExistingIndicator then
					DebrisService:AddItem(ExistingIndicator.Model, 1)
				end
			end)
		end
	end
	self.characterChildAddedConn = character.ChildAdded:Connect(function(child)
		OnCharacterChildAdded(child)
	end)
	self.characterChildRemovedConn = character.ChildRemoved:Connect(function(child)
		if UserInputService.TouchEnabled and child:IsA("Tool") then
			child.ManualActivationOnly = false
		end
	end)
	for _, child in pairs(character:GetChildren()) do
		OnCharacterChildAdded(child)
	end
end
function ClickToMove:Start()
	self:Enable(true)
end
function ClickToMove:Stop()
	self:Enable(false)
end
function ClickToMove:Enable(enable, enableWASD)
	if enable then
		if not self.running then
			if Player.Character then
				self:OnCharacterAdded(Player.Character)
			end
			self.onCharacterAddedConn = Player.CharacterAppearanceLoaded:Connect(function(char)
				self:OnCharacterAdded(char)
			end)
			self.running = true
		end
	elseif self.running then
		self:DisconnectEvents()
		CleanupPath()
		if UserInputService.TouchEnabled then
			local character = Player.Character
			if character then
				for _, child in pairs(character:GetChildren()) do
					if child:IsA("Tool") then
						child.ManualActivationOnly = false
					end
				end
			end
		end
		DrivingTo = nil
		self.running = false
	end
	if UserInputService.KeyboardEnabled and enable ~= self.enabled then
		self.forwardValue = 0
		self.backwardValue = 0
		self.leftValue = 0
		self.rightValue = 0
		self.moveVector = ZERO_VECTOR3
		if enable then
			self:BindContextActions()
			self:ConnectFocusEventListeners()
		else
			self:UnbindContextActions()
			self:DisconnectFocusEventListeners()
		end
	end
	self.wasdEnabled = enable and enableWASD or false
	self.enabled = enable
end
function ClickToMove:UpdateMovement(inputState)
	if inputState == Enum.UserInputState.Cancel then
		self.moveVector = ZERO_VECTOR3
	elseif self.wasdEnabled then
		self.moveVector = Vector3.new(self.leftValue + self.rightValue, 0, self.forwardValue + self.backwardValue)
	end
end
return ClickToMove

starterplayerscripts.coreclient.playermodule.controlmodule.dynamicthumbstick
--SynapseX Decompiler

local ZERO_VECTOR3 = Vector3.new(0, 0, 0)
local TOUCH_CONTROLS_SHEET = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
local MIDDLE_TRANSPARENCIES = {
	0.10999999999999999,
	0.30000000000000004,
	0.4,
	0.5,
	0.6,
	0.7,
	0.75
}
local NUM_MIDDLE_IMAGES = #MIDDLE_TRANSPARENCIES
local FADE_IN_OUT_BACKGROUND = true
local FADE_IN_OUT_MAX_ALPHA = 0.35
local FADE_IN_OUT_HALF_DURATION_DEFAULT = 0.3
local FADE_IN_OUT_BALANCE_DEFAULT = 0.5
local ThumbstickFadeTweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local BaseCharacterController = require(script.Parent:WaitForChild("BaseCharacterController"))
local DynamicThumbstick = setmetatable({}, BaseCharacterController)
DynamicThumbstick.__index = DynamicThumbstick
function DynamicThumbstick.new()
	local self = setmetatable(BaseCharacterController.new(), DynamicThumbstick)
	self.humanoid = nil
	self.tools = {}
	self.toolEquipped = nil
	self.revertAutoJumpEnabledToFalse = false
	self.moveTouchObject = nil
	self.moveTouchStartPosition = nil
	self.startImage = nil
	self.endImage = nil
	self.middleImages = {}
	self.startImageFadeTween = nil
	self.endImageFadeTween = nil
	self.middleImageFadeTweens = {}
	self.isFirstTouch = true
	self.isFollowStick = false
	self.thumbstickFrame = nil
	self.onTouchMovedConn = nil
	self.onTouchEndedConn = nil
	self.onTouchActivateConn = nil
	self.onRenderSteppedConn = nil
	self.fadeInAndOutBalance = FADE_IN_OUT_BALANCE_DEFAULT
	self.fadeInAndOutHalfDuration = FADE_IN_OUT_HALF_DURATION_DEFAULT
	self.hasFadedBackgroundInPortrait = false
	self.hasFadedBackgroundInLandscape = false
	self.tweenInAlphaStart = nil
	self.tweenOutAlphaStart = nil
	self.shouldRevertAutoJumpOnDisable = false
	return self
end
function DynamicThumbstick:GetIsJumping()
	local wasJumping = self.isJumping
	self.isJumping = false
	return wasJumping
end
function DynamicThumbstick:EnableAutoJump(enable)
	local humanoid = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		if enable then
			self.shouldRevertAutoJumpOnDisable = humanoid.AutoJumpEnabled == false and Players.LocalPlayer.DevTouchMovementMode == Enum.DevTouchMovementMode.UserChoice
			humanoid.AutoJumpEnabled = true
		elseif self.shouldRevertAutoJumpOnDisable then
			humanoid.AutoJumpEnabled = false
		end
	end
end
function DynamicThumbstick:Enable(enable, uiParentFrame)
	if enable == nil then
		return false
	end
	enable = enable and true or false
	if self.enabled == enable then
		return true
	end
	if enable then
		if not self.thumbstickFrame then
			self:Create(uiParentFrame)
		end
		if Players.LocalPlayer.Character then
			self:OnCharacterAdded(Players.LocalPlayer.Character)
		else
			Players.LocalPlayer.CharacterAppearanceLoaded:Connect(function(char)
				self:OnCharacterAdded(char)
			end)
		end
	else
		self:OnInputEnded()
	end
	self.enabled = enable
	self.thumbstickFrame.Visible = enable
end
function DynamicThumbstick:OnCharacterAdded(char)
	for _, child in ipairs(char:GetChildren()) do
		if child:IsA("Tool") then
			self.toolEquipped = child
		end
	end
	char.ChildAdded:Connect(function(child)
		if child:IsA("Tool") then
			self.toolEquipped = child
		elseif child:IsA("Humanoid") then
			self:EnableAutoJump(true)
		end
	end)
	char.ChildRemoved:Connect(function(child)
		if child == self.toolEquipped then
			self.toolEquipped = nil
		end
	end)
	self.humanoid = char:FindFirstChildOfClass("Humanoid")
	if self.humanoid then
		self:EnableAutoJump(true)
	end
end
function DynamicThumbstick:OnInputEnded()
	self.moveTouchObject = nil
	self.moveVector = ZERO_VECTOR3
	self:FadeThumbstick(false)
	self.thumbstickFrame.Active = true
end
function DynamicThumbstick:FadeThumbstick(visible)
	if not visible and self.moveTouchObject then
		return
	end
	if self.isFirstTouch then
		return
	end
	if self.startImageFadeTween then
		self.startImageFadeTween:Cancel()
	end
	if self.endImageFadeTween then
		self.endImageFadeTween:Cancel()
	end
	for i = 1, #self.middleImages do
		if self.middleImageFadeTweens[i] then
			self.middleImageFadeTweens[i]:Cancel()
		end
	end
	if visible then
		self.startImageFadeTween = TweenService:Create(self.startImage, ThumbstickFadeTweenInfo, {ImageTransparency = 0})
		self.startImageFadeTween:Play()
		self.endImageFadeTween = TweenService:Create(self.endImage, ThumbstickFadeTweenInfo, {ImageTransparency = 0.2})
		self.endImageFadeTween:Play()
		for i = 1, #self.middleImages do
			self.middleImageFadeTweens[i] = TweenService:Create(self.middleImages[i], ThumbstickFadeTweenInfo, {
				ImageTransparency = MIDDLE_TRANSPARENCIES[i]
			})
			self.middleImageFadeTweens[i]:Play()
		end
	else
		self.startImageFadeTween = TweenService:Create(self.startImage, ThumbstickFadeTweenInfo, {ImageTransparency = 1})
		self.startImageFadeTween:Play()
		self.endImageFadeTween = TweenService:Create(self.endImage, ThumbstickFadeTweenInfo, {ImageTransparency = 1})
		self.endImageFadeTween:Play()
		for i = 1, #self.middleImages do
			self.middleImageFadeTweens[i] = TweenService:Create(self.middleImages[i], ThumbstickFadeTweenInfo, {ImageTransparency = 1})
			self.middleImageFadeTweens[i]:Play()
		end
	end
end
function DynamicThumbstick:FadeThumbstickFrame(fadeDuration, fadeRatio)
	self.fadeInAndOutHalfDuration = fadeDuration * 0.5
	self.fadeInAndOutBalance = fadeRatio
	self.tweenInAlphaStart = tick()
end
function DynamicThumbstick:Create(parentFrame)
	if self.thumbstickFrame then
		self.thumbstickFrame:Destroy()
		self.thumbstickFrame = nil
		if self.onTouchMovedConn then
			self.onTouchMovedConn:Disconnect()
			self.onTouchMovedConn = nil
		end
		if self.onTouchEndedConn then
			self.onTouchEndedCon:Disconnect()
			self.onTouchEndedCon = nil
		end
		if self.onRenderSteppedConn then
			self.onRenderSteppedConn:Disconnect()
			self.onRenderSteppedConn = nil
		end
		if self.onTouchActivateConn then
			self.onTouchActivateConn:Disconnect()
			self.onTouchActivateConn = nil
		end
	end
	local ThumbstickSize = 45
	local ThumbstickRingSize = 20
	local MiddleSize = 10
	local MiddleSpacing = MiddleSize + 4
	local RadiusOfDeadZone = 2
	local RadiusOfMaxSpeed = 20
	local screenSize = parentFrame.AbsoluteSize
	local isBigScreen = math.min(screenSize.x, screenSize.y) > 500
	if isBigScreen then
		ThumbstickSize = ThumbstickSize * 2
		ThumbstickRingSize = ThumbstickRingSize * 2
		MiddleSize = MiddleSize * 2
		MiddleSpacing = MiddleSpacing * 2
		RadiusOfDeadZone = RadiusOfDeadZone * 2
		RadiusOfMaxSpeed = RadiusOfMaxSpeed * 2
	end
	local function layoutThumbstickFrame(portraitMode)
		if portraitMode then
			self.thumbstickFrame.Size = UDim2.new(1, 0, 0.4, 0)
			self.thumbstickFrame.Position = UDim2.new(0, 0, 0.6, 0)
		else
			self.thumbstickFrame.Size = UDim2.new(0.4, 0, 0.6666666666666666, 0)
			self.thumbstickFrame.Position = UDim2.new(0, 0, 0.3333333333333333, 0)
		end
	end
	self.thumbstickFrame = Instance.new("TextButton")
	self.thumbstickFrame.Text = ""
	self.thumbstickFrame.Name = "DynamicThumbstickFrame"
	self.thumbstickFrame.Visible = false
	self.thumbstickFrame.BackgroundTransparency = 1
	self.thumbstickFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	layoutThumbstickFrame(false)
	self.startImage = Instance.new("ImageLabel")
	self.startImage.Name = "ThumbstickStart"
	self.startImage.Visible = true
	self.startImage.BackgroundTransparency = 1
	self.startImage.Image = TOUCH_CONTROLS_SHEET
	self.startImage.ImageRectOffset = Vector2.new(1, 1)
	self.startImage.ImageRectSize = Vector2.new(144, 144)
	self.startImage.ImageColor3 = Color3.new(0, 0, 0)
	self.startImage.AnchorPoint = Vector2.new(0.5, 0.5)
	self.startImage.Position = UDim2.new(0, ThumbstickRingSize * 3.3, 1, -ThumbstickRingSize * 2.8)
	self.startImage.Size = UDim2.new(0, ThumbstickRingSize * 3.7, 0, ThumbstickRingSize * 3.7)
	self.startImage.ZIndex = 10
	self.startImage.Parent = self.thumbstickFrame
	self.endImage = Instance.new("ImageLabel")
	self.endImage.Name = "ThumbstickEnd"
	self.endImage.Visible = true
	self.endImage.BackgroundTransparency = 1
	self.endImage.Image = TOUCH_CONTROLS_SHEET
	self.endImage.ImageRectOffset = Vector2.new(1, 1)
	self.endImage.ImageRectSize = Vector2.new(144, 144)
	self.endImage.AnchorPoint = Vector2.new(0.5, 0.5)
	self.endImage.Position = self.startImage.Position
	self.endImage.Size = UDim2.new(0, ThumbstickSize * 0.8, 0, ThumbstickSize * 0.8)
	self.endImage.ZIndex = 10
	self.endImage.Parent = self.thumbstickFrame
	for i = 1, NUM_MIDDLE_IMAGES do
		self.middleImages[i] = Instance.new("ImageLabel")
		self.middleImages[i].Name = "ThumbstickMiddle"
		self.middleImages[i].Visible = false
		self.middleImages[i].BackgroundTransparency = 1
		self.middleImages[i].Image = TOUCH_CONTROLS_SHEET
		self.middleImages[i].ImageRectOffset = Vector2.new(1, 1)
		self.middleImages[i].ImageRectSize = Vector2.new(144, 144)
		self.middleImages[i].ImageTransparency = MIDDLE_TRANSPARENCIES[i]
		self.middleImages[i].AnchorPoint = Vector2.new(0.5, 0.5)
		self.middleImages[i].ZIndex = 9
		self.middleImages[i].Parent = self.thumbstickFrame
	end
	local CameraChangedConn
	local function onCurrentCameraChanged()
		if CameraChangedConn then
			CameraChangedConn:Disconnect()
			CameraChangedConn = nil
		end
		local newCamera = workspace.CurrentCamera
		if newCamera then
			local function onViewportSizeChanged()
				local size = newCamera.ViewportSize
				local portraitMode = size.X < size.Y
				layoutThumbstickFrame(portraitMode)
			end
			CameraChangedConn = newCamera:GetPropertyChangedSignal("ViewportSize"):Connect(onViewportSizeChanged)
			onViewportSizeChanged()
		end
	end
	workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(onCurrentCameraChanged)
	if workspace.CurrentCamera then
		onCurrentCameraChanged()
	end
	self.moveTouchStartPosition = nil
	self.startImageFadeTween = nil
	self.endImageFadeTween = nil
	self.middleImageFadeTweens = {}
	local function doMove(direction)
		local currentMoveVector = direction
		local inputAxisMagnitude = currentMoveVector.magnitude
		if inputAxisMagnitude < RadiusOfDeadZone then
			currentMoveVector = Vector3.new()
		else
			currentMoveVector = currentMoveVector.unit * (1 - math.max(0, (RadiusOfMaxSpeed - currentMoveVector.magnitude) / RadiusOfMaxSpeed))
			currentMoveVector = Vector3.new(currentMoveVector.x, 0, currentMoveVector.y)
		end
		self.moveVector = currentMoveVector
	end
	local function layoutMiddleImages(startPos, endPos)
		local startDist = ThumbstickSize / 2 + MiddleSize
		local vector = endPos - startPos
		local distAvailable = vector.magnitude - ThumbstickRingSize / 2 - MiddleSize
		local direction = vector.unit
		local distNeeded = MiddleSpacing * NUM_MIDDLE_IMAGES
		local spacing = MiddleSpacing
		if distAvailable > distNeeded then
			spacing = distAvailable / NUM_MIDDLE_IMAGES
		end
		for i = 1, NUM_MIDDLE_IMAGES do
			local image = self.middleImages[i]
			local distWithout = startDist + spacing * (i - 2)
			local currentDist = startDist + spacing * (i - 1)
			if distAvailable > distWithout then
				local pos = endPos - direction * currentDist
				local exposedFraction = math.clamp(1 - (currentDist - distAvailable) / spacing, 0, 1)
				image.Visible = true
				image.Position = UDim2.new(0, pos.X, 0, pos.Y)
				image.Size = UDim2.new(0, MiddleSize * exposedFraction, 0, MiddleSize * exposedFraction)
			else
				image.Visible = false
			end
		end
	end
	local function moveStick(pos)
		local startPos = Vector2.new(self.moveTouchStartPosition.X, self.moveTouchStartPosition.Y) - self.thumbstickFrame.AbsolutePosition
		local endPos = Vector2.new(pos.X, pos.Y) - self.thumbstickFrame.AbsolutePosition
		self.endImage.Position = UDim2.new(0, endPos.X, 0, endPos.Y)
		layoutMiddleImages(startPos, endPos)
	end
	self.thumbstickFrame.InputBegan:Connect(function(inputObject)
		if inputObject.UserInputType ~= Enum.UserInputType.Touch or inputObject.UserInputState ~= Enum.UserInputState.Begin then
			return
		end
		if self.moveTouchObject then
			return
		end
		if self.isFirstTouch then
			self.isFirstTouch = false
			local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)
			TweenService:Create(self.startImage, tweenInfo, {
				Size = UDim2.new(0, 0, 0, 0)
			}):Play()
			TweenService:Create(self.endImage, tweenInfo, {
				Size = UDim2.new(0, ThumbstickSize, 0, ThumbstickSize),
				ImageColor3 = Color3.new(0, 0, 0)
			}):Play()
		end
		self.moveTouchObject = inputObject
		self.moveTouchStartPosition = inputObject.Position
		local startPosVec2 = Vector2.new(inputObject.Position.X - self.thumbstickFrame.AbsolutePosition.X, inputObject.Position.Y - self.thumbstickFrame.AbsolutePosition.Y)
		self.startImage.Visible = true
		self.startImage.Position = UDim2.new(0, startPosVec2.X, 0, startPosVec2.Y)
		self.endImage.Visible = true
		self.endImage.Position = self.startImage.Position
		self:FadeThumbstick(true)
		moveStick(inputObject.Position)
		if FADE_IN_OUT_BACKGROUND then
			local playerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
			local hasFadedBackgroundInOrientation = false
			if playerGui then
				if playerGui.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeLeft or playerGui.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeRight then
					hasFadedBackgroundInOrientation = self.hasFadedBackgroundInLandscape
					self.hasFadedBackgroundInLandscape = true
				elseif playerGui.CurrentScreenOrientation == Enum.ScreenOrientation.Portrait then
					hasFadedBackgroundInOrientation = self.hasFadedBackgroundInPortrait
					self.hasFadedBackgroundInPortrait = true
				end
			end
			if not hasFadedBackgroundInOrientation then
				self.fadeInAndOutHalfDuration = FADE_IN_OUT_HALF_DURATION_DEFAULT
				self.fadeInAndOutBalance = FADE_IN_OUT_BALANCE_DEFAULT
				self.tweenInAlphaStart = tick()
			end
		end
	end)
	self.onTouchMovedConn = UserInputService.TouchMoved:connect(function(inputObject)
		if inputObject == self.moveTouchObject then
			self.thumbstickFrame.Active = false
			local direction = Vector2.new(inputObject.Position.x - self.moveTouchStartPosition.x, inputObject.Position.y - self.moveTouchStartPosition.y)
			if math.abs(direction.x) > 0 or math.abs(direction.y) > 0 then
				doMove(direction)
				moveStick(inputObject.Position)
			end
		end
	end)
	self.onRenderSteppedConn = RunService.RenderStepped:Connect(function()
		if self.tweenInAlphaStart ~= nil then
			local delta = tick() - self.tweenInAlphaStart
			local fadeInTime = self.fadeInAndOutHalfDuration * 2 * self.fadeInAndOutBalance
			self.thumbstickFrame.BackgroundTransparency = 1 - FADE_IN_OUT_MAX_ALPHA * math.min(delta / fadeInTime, 1)
			if delta > fadeInTime then
				self.tweenOutAlphaStart = tick()
				self.tweenInAlphaStart = nil
			end
		elseif self.tweenOutAlphaStart ~= nil then
			local delta = tick() - self.tweenOutAlphaStart
			local fadeOutTime = self.fadeInAndOutHalfDuration * 2 - self.fadeInAndOutHalfDuration * 2 * self.fadeInAndOutBalance
			self.thumbstickFrame.BackgroundTransparency = 1 - FADE_IN_OUT_MAX_ALPHA + FADE_IN_OUT_MAX_ALPHA * math.min(delta / fadeOutTime, 1)
			if delta > fadeOutTime then
				self.tweenOutAlphaStart = nil
			end
		end
	end)
	self.onTouchEndedConn = UserInputService.TouchEnded:connect(function(inputObject)
		if inputObject == self.moveTouchObject then
			self:OnInputEnded()
		end
	end)
	GuiService.MenuOpened:connect(function()
		if self.moveTouchObject then
			self:OnInputEnded()
		end
	end)
	local playerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
	while not playerGui do
		Players.LocalPlayer.ChildAdded:wait()
		playerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
	end
	local playerGuiChangedConn
	local originalScreenOrientationWasLandscape = playerGui.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeLeft or playerGui.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeRight
	local function longShowBackground()
		self.fadeInAndOutHalfDuration = 2.5
		self.fadeInAndOutBalance = 0.05
		self.tweenInAlphaStart = tick()
	end
	playerGuiChangedConn = playerGui.Changed:connect(function(prop)
		if prop == "CurrentScreenOrientation" and (originalScreenOrientationWasLandscape and playerGui.CurrentScreenOrientation == Enum.ScreenOrientation.Portrait or not originalScreenOrientationWasLandscape and playerGui.CurrentScreenOrientation ~= Enum.ScreenOrientation.Portrait) then
			playerGuiChangedConn:disconnect()
			longShowBackground()
			if originalScreenOrientationWasLandscape then
				self.hasFadedBackgroundInPortrait = true
			else
				self.hasFadedBackgroundInLandscape = true
			end
		end
	end)
	self.thumbstickFrame.Parent = parentFrame
	coroutine.wrap(function()
		if game:IsLoaded() then
			longShowBackground()
		else
			game.Loaded:wait()
			longShowBackground()
		end
	end)()
end
return DynamicThumbstick

starterplayerscripts.coreclient.playermodule.controlmodule.gamepad
--SynapseX Decompiler

local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local ZERO_VECTOR3 = Vector3.new(0, 0, 0)
local NONE = Enum.UserInputType.None
local thumbstickDeadzone = 0.2
local BaseCharacterController = require(script.Parent:WaitForChild("BaseCharacterController"))
local Gamepad = setmetatable({}, BaseCharacterController)
Gamepad.__index = Gamepad
local bindAtPriorityFlagExists, bindAtPriorityFlagEnabled = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserPlayerScriptsBindAtPriority")
end)
local FFlagPlayerScriptsBindAtPriority = bindAtPriorityFlagExists and bindAtPriorityFlagEnabled
function Gamepad.new(CONTROL_ACTION_PRIORITY)
	local self = setmetatable(BaseCharacterController.new(), Gamepad)
	self.CONTROL_ACTION_PRIORITY = CONTROL_ACTION_PRIORITY
	self.forwardValue = 0
	self.backwardValue = 0
	self.leftValue = 0
	self.rightValue = 0
	self.activeGamepad = NONE
	self.gamepadConnectedConn = nil
	self.gamepadDisconnectedConn = nil
	return self
end
function Gamepad:Enable(enable)
	if not UserInputService.GamepadEnabled then
		return false
	end
	if enable == self.enabled then
		return true
	end
	self.forwardValue = 0
	self.backwardValue = 0
	self.leftValue = 0
	self.rightValue = 0
	self.moveVector = ZERO_VECTOR3
	self.isJumping = false
	if enable then
		self.activeGamepad = self:GetHighestPriorityGamepad()
		if self.activeGamepad ~= NONE then
			self:BindContextActions()
			self:ConnectGamepadConnectionListeners()
		else
			return false
		end
	else
		self:UnbindContextActions()
		self:DisconnectGamepadConnectionListeners()
		self.activeGamepad = NONE
	end
	self.enabled = enable
	return true
end
function Gamepad:GetHighestPriorityGamepad()
	local connectedGamepads = UserInputService:GetConnectedGamepads()
	local bestGamepad = NONE
	for _, gamepad in pairs(connectedGamepads) do
		if gamepad.Value < bestGamepad.Value then
			bestGamepad = gamepad
		end
	end
	return bestGamepad
end
function Gamepad:BindContextActions()
	if self.activeGamepad == NONE then
		return false
	end
	local function updateMovement(inputState)
		if inputState == Enum.UserInputState.Cancel then
			self.moveVector = ZERO_VECTOR3
		else
			self.moveVector = Vector3.new(self.leftValue + self.rightValue, 0, self.forwardValue + self.backwardValue)
		end
	end
	local function handleMoveForward(actionName, inputState, inputObject)
		self.forwardValue = inputState == Enum.UserInputState.Begin and -1 or 0
		updateMovement(inputState)
	end
	local function handleMoveBackward(actionName, inputState, inputObject)
		self.backwardValue = inputState == Enum.UserInputState.Begin and 1 or 0
		updateMovement(inputState)
	end
	local function handleMoveLeft(actionName, inputState, inputObject)
		self.leftValue = inputState == Enum.UserInputState.Begin and -1 or 0
		updateMovement(inputState)
	end
	local function handleMoveRight(actionName, inputState, inputObject)
		self.rightValue = inputState == Enum.UserInputState.Begin and 1 or 0
		updateMovement(inputState)
	end
	local function handleJumpAction(actionName, inputState, inputObject)
		self.isJumping = inputState == Enum.UserInputState.Begin
		if FFlagPlayerScriptsBindAtPriority then
			return Enum.ContextActionResult.Sink
		end
	end
	local function handleThumbstickInput(actionName, inputState, inputObject)
		if self.activeGamepad ~= inputObject.UserInputType then
			return FFlagPlayerScriptsBindAtPriority and Enum.ContextActionResult.Pass or nil
		end
		if inputObject.KeyCode ~= Enum.KeyCode.Thumbstick1 then
			return
		end
		if inputState == Enum.UserInputState.Cancel then
			self.moveVector = ZERO_VECTOR3
			return FFlagPlayerScriptsBindAtPriority and Enum.ContextActionResult.Sink or nil
		end
		if inputObject.Position.magnitude > thumbstickDeadzone then
			self.moveVector = Vector3.new(inputObject.Position.X, 0, -inputObject.Position.Y)
		else
			self.moveVector = ZERO_VECTOR3
		end
		if FFlagPlayerScriptsBindAtPriority then
			return Enum.ContextActionResult.Sink
		end
	end
	ContextActionService:BindActivate(self.activeGamepad, Enum.KeyCode.ButtonR2)
	if FFlagPlayerScriptsBindAtPriority then
		ContextActionService:BindActionAtPriority("jumpAction", handleJumpAction, false, self.CONTROL_ACTION_PRIORITY, Enum.KeyCode.ButtonA)
		ContextActionService:BindActionAtPriority("moveThumbstick", handleThumbstickInput, false, self.CONTROL_ACTION_PRIORITY, Enum.KeyCode.Thumbstick1)
	else
		ContextActionService:BindAction("jumpAction", handleJumpAction, false, Enum.KeyCode.ButtonA)
		ContextActionService:BindAction("moveThumbstick", handleThumbstickInput, false, Enum.KeyCode.Thumbstick1)
	end
	return true
end
function Gamepad:UnbindContextActions()
	if self.activeGamepad ~= NONE then
		ContextActionService:UnbindActivate(self.activeGamepad, Enum.KeyCode.ButtonR2)
	end
	ContextActionService:UnbindAction("moveThumbstick")
	ContextActionService:UnbindAction("jumpAction")
end
function Gamepad:OnNewGamepadConnected()
	local bestGamepad = self:GetHighestPriorityGamepad()
	if bestGamepad == self.activeGamepad then
		return
	end
	if bestGamepad == NONE then
		warn("Gamepad:OnNewGamepadConnected found no connected gamepads")
		self:UnbindContextActions()
		return
	end
	if self.activeGamepad ~= NONE then
		self:UnbindContextActions()
	end
	self.activeGamepad = bestGamepad
	self:BindContextActions()
end
function Gamepad:OnCurrentGamepadDisconnected()
	if self.activeGamepad ~= NONE then
		ContextActionService:UnbindActivate(self.activeGamepad, Enum.KeyCode.ButtonR2)
	end
	local bestGamepad = self:GetHighestPriorityGamepad()
	if self.activeGamepad ~= NONE and bestGamepad == self.activeGamepad then
		warn("Gamepad:OnCurrentGamepadDisconnected found the supposedly disconnected gamepad in connectedGamepads.")
		self:UnbindContextActions()
		self.activeGamepad = NONE
		return
	end
	if bestGamepad == NONE then
		self:UnbindContextActions()
		self.activeGamepad = NONE
	else
		self.activeGamepad = bestGamepad
		ContextActionService:BindActivate(self.activeGamepad, Enum.KeyCode.ButtonR2)
	end
end
function Gamepad:ConnectGamepadConnectionListeners()
	self.gamepadConnectedConn = UserInputService.GamepadConnected:Connect(function(gamepadEnum)
		self:OnNewGamepadConnected()
	end)
	self.gamepadDisconnectedConn = UserInputService.GamepadDisconnected:Connect(function(gamepadEnum)
		if self.activeGamepad == gamepadEnum then
			self:OnCurrentGamepadDisconnected()
		end
	end)
end
function Gamepad:DisconnectGamepadConnectionListeners()
	if self.gamepadConnectedConn then
		self.gamepadConnectedConn:Disconnect()
		self.gamepadConnectedConn = nil
	end
	if self.gamepadDisconnectedConn then
		self.gamepadDisconnectedConn:Disconnect()
		self.gamepadDisconnectedConn = nil
	end
end
return Gamepad

starterplayerscripts.coreclient.playermodule.controlmodule.keyboard
--SynapseX Decompiler

local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local ZERO_VECTOR3 = Vector3.new(0, 0, 0)
local BaseCharacterController = require(script.Parent:WaitForChild("BaseCharacterController"))
local Keyboard = setmetatable({}, BaseCharacterController)
Keyboard.__index = Keyboard
local bindAtPriorityFlagExists, bindAtPriorityFlagEnabled = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserPlayerScriptsBindAtPriority")
end)
local FFlagPlayerScriptsBindAtPriority = bindAtPriorityFlagExists and bindAtPriorityFlagEnabled
function Keyboard.new(CONTROL_ACTION_PRIORITY)
	local self = setmetatable(BaseCharacterController.new(), Keyboard)
	self.CONTROL_ACTION_PRIORITY = CONTROL_ACTION_PRIORITY
	self.textFocusReleasedConn = nil
	self.textFocusGainedConn = nil
	self.windowFocusReleasedConn = nil
	self.forwardValue = 0
	self.backwardValue = 0
	self.leftValue = 0
	self.rightValue = 0
	return self
end
function Keyboard:Enable(enable)
	if not UserInputService.KeyboardEnabled then
		return false
	end
	if enable == self.enabled then
		return true
	end
	self.forwardValue = 0
	self.backwardValue = 0
	self.leftValue = 0
	self.rightValue = 0
	self.moveVector = ZERO_VECTOR3
	self.isJumping = false
	if enable then
		self:BindContextActions()
		self:ConnectFocusEventListeners()
	else
		self:UnbindContextActions()
		self:DisconnectFocusEventListeners()
	end
	self.enabled = enable
	return true
end
function Keyboard:UpdateMovement(inputState)
	if inputState == Enum.UserInputState.Cancel then
		self.moveVector = ZERO_VECTOR3
	else
		self.moveVector = Vector3.new(self.leftValue + self.rightValue, 0, self.forwardValue + self.backwardValue)
	end
end
function Keyboard:BindContextActions()
	local function handleMoveForward(actionName, inputState, inputObject)
		self.forwardValue = inputState == Enum.UserInputState.Begin and -1 or 0
		self:UpdateMovement(inputState)
		if FFlagPlayerScriptsBindAtPriority then
			return Enum.ContextActionResult.Sink
		end
	end
	local function handleMoveBackward(actionName, inputState, inputObject)
		self.backwardValue = inputState == Enum.UserInputState.Begin and 1 or 0
		self:UpdateMovement(inputState)
		if FFlagPlayerScriptsBindAtPriority then
			return Enum.ContextActionResult.Sink
		end
	end
	local function handleMoveLeft(actionName, inputState, inputObject)
		self.leftValue = inputState == Enum.UserInputState.Begin and -1 or 0
		self:UpdateMovement(inputState)
		if FFlagPlayerScriptsBindAtPriority then
			return Enum.ContextActionResult.Sink
		end
	end
	local function handleMoveRight(actionName, inputState, inputObject)
		self.rightValue = inputState == Enum.UserInputState.Begin and 1 or 0
		self:UpdateMovement(inputState)
		if FFlagPlayerScriptsBindAtPriority then
			return Enum.ContextActionResult.Sink
		end
	end
	local function handleJumpAction(actionName, inputState, inputObject)
		self.isJumping = inputState == Enum.UserInputState.Begin
		if FFlagPlayerScriptsBindAtPriority then
			return Enum.ContextActionResult.Sink
		end
	end
	if FFlagPlayerScriptsBindAtPriority then
		ContextActionService:BindActionAtPriority("moveForwardAction", handleMoveForward, false, self.CONTROL_ACTION_PRIORITY, Enum.PlayerActions.CharacterForward)
		ContextActionService:BindActionAtPriority("moveBackwardAction", handleMoveBackward, false, self.CONTROL_ACTION_PRIORITY, Enum.PlayerActions.CharacterBackward)
		ContextActionService:BindActionAtPriority("moveLeftAction", handleMoveLeft, false, self.CONTROL_ACTION_PRIORITY, Enum.PlayerActions.CharacterLeft)
		ContextActionService:BindActionAtPriority("moveRightAction", handleMoveRight, false, self.CONTROL_ACTION_PRIORITY, Enum.PlayerActions.CharacterRight)
		ContextActionService:BindActionAtPriority("jumpAction", handleJumpAction, false, self.CONTROL_ACTION_PRIORITY, Enum.PlayerActions.CharacterJump)
	else
		ContextActionService:BindAction("moveForwardAction", handleMoveForward, false, Enum.PlayerActions.CharacterForward)
		ContextActionService:BindAction("moveBackwardAction", handleMoveBackward, false, Enum.PlayerActions.CharacterBackward)
		ContextActionService:BindAction("moveLeftAction", handleMoveLeft, false, Enum.PlayerActions.CharacterLeft)
		ContextActionService:BindAction("moveRightAction", handleMoveRight, false, Enum.PlayerActions.CharacterRight)
		ContextActionService:BindAction("jumpAction", handleJumpAction, false, Enum.PlayerActions.CharacterJump)
	end
end
function Keyboard:UnbindContextActions()
	ContextActionService:UnbindAction("moveForwardAction")
	ContextActionService:UnbindAction("moveBackwardAction")
	ContextActionService:UnbindAction("moveLeftAction")
	ContextActionService:UnbindAction("moveRightAction")
	ContextActionService:UnbindAction("jumpAction")
end
function Keyboard:ConnectFocusEventListeners()
	local function onFocusReleased()
		self.moveVector = ZERO_VECTOR3
		self.forwardValue = 0
		self.backwardValue = 0
		self.leftValue = 0
		self.rightValue = 0
		self.isJumping = false
	end
	local function onTextFocusGained(textboxFocused)
		self.isJumping = false
	end
	self.textFocusReleasedConn = UserInputService.TextBoxFocusReleased:Connect(onFocusReleased)
	self.textFocusGainedConn = UserInputService.TextBoxFocused:Connect(onTextFocusGained)
	self.windowFocusReleasedConn = UserInputService.WindowFocused:Connect(onFocusReleased)
end
function Keyboard:DisconnectFocusEventListeners()
	if self.textFocusReleasedCon then
		self.textFocusReleasedCon:Disconnect()
		self.textFocusReleasedCon = nil
	end
	if self.textFocusGainedConn then
		self.textFocusGainedConn:Disconnect()
		self.textFocusGainedConn = nil
	end
	if self.windowFocusReleasedConn then
		self.windowFocusReleasedConn:Disconnect()
		self.windowFocusReleasedConn = nil
	end
end
return Keyboard

starterplayerscripts.coreclient.playermodule.controlmodule.pathdisplay
--SynapseX Decompiler

local PathDisplay = {}
PathDisplay.spacing = 8
PathDisplay.image = "rbxasset://textures/Cursors/Gamepad/Pointer.png"
PathDisplay.imageSize = Vector2.new(2, 2)
local currentPoints = {}
local renderedPoints = {}
local pointModel = Instance.new("Model")
pointModel.Name = "PathDisplayPoints"
local adorneePart = Instance.new("Part")
adorneePart.Anchored = true
adorneePart.CanCollide = false
adorneePart.Transparency = 1
adorneePart.Name = "PathDisplayAdornee"
adorneePart.CFrame = CFrame.new(0, 0, 0)
adorneePart.Parent = pointModel
local pointPool = {}
local poolTop = 30
for i = 1, poolTop do
	local point = Instance.new("ImageHandleAdornment")
	point.Archivable = false
	point.Adornee = adorneePart
	point.Image = PathDisplay.image
	point.Size = PathDisplay.imageSize
	pointPool[i] = point
end
local function retrieveFromPool()
	local point = pointPool[1]
	if not point then
		return
	end
	pointPool[1], pointPool[poolTop] = pointPool[poolTop], nil
	poolTop = poolTop - 1
	return point
end
local function returnToPool(point)
	poolTop = poolTop + 1
	pointPool[poolTop] = point
end
local function renderPoint(point, isLast)
	if poolTop == 0 then
		return
	end
	local rayDown = Ray.new(point + Vector3.new(0, 2, 0), Vector3.new(0, -8, 0))
	local hitPart, hitPoint, hitNormal = workspace:FindPartOnRayWithIgnoreList(rayDown, {
		game.Players.LocalPlayer.Character,
		workspace.CurrentCamera
	})
	if not hitPart then
		return
	end
	local pointCFrame = CFrame.new(hitPoint, hitPoint + hitNormal)
	local point = retrieveFromPool()
	point.CFrame = pointCFrame
	point.Parent = pointModel
	return point
end
function PathDisplay.setCurrentPoints(points)
	if typeof(points) == "table" then
		currentPoints = points
	else
		currentPoints = {}
	end
end
function PathDisplay.clearRenderedPath()
	for _, oldPoint in ipairs(renderedPoints) do
		oldPoint.Parent = nil
		returnToPool(oldPoint)
	end
	renderedPoints = {}
	pointModel.Parent = nil
end
function PathDisplay.renderPath()
	PathDisplay.clearRenderedPath()
	if not currentPoints or #currentPoints == 0 then
		return
	end
	local currentIdx = #currentPoints
	local lastPos = currentPoints[currentIdx]
	local distanceBudget = 0
	renderedPoints[1] = renderPoint(lastPos, true)
	if not renderedPoints[1] then
		return
	end
	while true do
		local currentPoint = currentPoints[currentIdx]
		local nextPoint = currentPoints[currentIdx - 1]
		if currentIdx < 2 then
			break
		else
			local toNextPoint = nextPoint - currentPoint
			local distToNextPoint = toNextPoint.magnitude
			if distanceBudget > distToNextPoint then
				distanceBudget = distanceBudget - distToNextPoint
				currentIdx = currentIdx - 1
			else
				local dirToNextPoint = toNextPoint.unit
				local pointPos = currentPoint + dirToNextPoint * distanceBudget
				local point = renderPoint(pointPos, false)
				if point then
					renderedPoints[#renderedPoints + 1] = point
				end
				distanceBudget = distanceBudget + PathDisplay.spacing
			end
		end
	end
	pointModel.Parent = workspace.CurrentCamera
end
return PathDisplay

starterplayerscripts.coreclient.playermodule.controlmodule.touchdpad
--SynapseX Decompiler

local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local DPAD_SHEET = "rbxasset://textures/ui/DPadSheet.png"
local ZERO_VECTOR3 = Vector3.new(0, 0, 0)
local COMPASS_DIR = {
	Vector3.new(1, 0, 0),
	Vector3.new(1, 0, 1).unit,
	Vector3.new(0, 0, 1),
	Vector3.new(-1, 0, 1).unit,
	Vector3.new(-1, 0, 0),
	Vector3.new(-1, 0, -1).unit,
	Vector3.new(0, 0, -1),
	Vector3.new(1, 0, -1).unit
}
local BaseCharacterController = require(script.Parent:WaitForChild("BaseCharacterController"))
local TouchDPad = setmetatable({}, BaseCharacterController)
TouchDPad.__index = TouchDPad
function TouchDPad.new()
	local self = setmetatable(BaseCharacterController.new(), TouchDPad)
	self.DPadFrame = nil
	self.touchObject = nil
	self.flBtn = nil
	self.frBtn = nil
	return self
end
local function CreateArrowLabel(name, position, size, rectOffset, rectSize, parent)
	local image = Instance.new("ImageLabel")
	image.Name = name
	image.Image = DPAD_SHEET
	image.ImageRectOffset = rectOffset
	image.ImageRectSize = rectSize
	image.BackgroundTransparency = 1
	image.Size = size
	image.Position = position
	image.Parent = parent
	return image
end
function TouchDPad:GetCenterPosition()
	return Vector2.new(self.DPadFrame.AbsolutePosition.x + self.DPadFrame.AbsoluteSize.x * 0.5, self.DPadFrame.AbsolutePosition.y + self.DPadFrame.AbsoluteSize.y * 0.5)
end
function TouchDPad:Enable(enable, uiParentFrame)
	if enable == nil then
		return false
	end
	enable = enable and true or false
	if self.enabled == enable then
		return true
	end
	self.moveVector = ZERO_VECTOR3
	self.isJumping = false
	if enable then
		if not self.DPadFrame then
			self:Create(uiParentFrame)
		end
		self.DPadFrame.Visible = true
	else
		self.DPadFrame.Visible = false
		self:OnInputEnded()
	end
	self.enabled = enable
end
function TouchDPad:GetIsJumping()
	local wasJumping = self.isJumping
	self.isJumping = false
	return wasJumping
end
function TouchDPad:OnInputEnded()
	self.touchObject = nil
	if self.flBtn then
		self.flBtn.Visible = false
	end
	if self.frBtn then
		self.frBtn.Visible = false
	end
	self.moveVector = ZERO_VECTOR3
end
function TouchDPad:Create(parentFrame)
	if self.DPadFrame then
		self.DPadFrame:Destroy()
		self.DPadFrame = nil
	end
	local position = UDim2.new(0, 10, 1, -230)
	self.DPadFrame = Instance.new("Frame")
	self.DPadFrame.Name = "DPadFrame"
	self.DPadFrame.Active = true
	self.DPadFrame.Visible = false
	self.DPadFrame.Size = UDim2.new(0, 192, 0, 192)
	self.DPadFrame.Position = position
	self.DPadFrame.BackgroundTransparency = 1
	local smArrowSize = UDim2.new(0, 23, 0, 23)
	local lgArrowSize = UDim2.new(0, 64, 0, 64)
	local smImgOffset = Vector2.new(46, 46)
	local lgImgOffset = Vector2.new(128, 128)
	local bBtn = CreateArrowLabel("BackButton", UDim2.new(0.5, -32, 1, -64), lgArrowSize, Vector2.new(0, 0), lgImgOffset, self.DPadFrame)
	local fBtn = CreateArrowLabel("ForwardButton", UDim2.new(0.5, -32, 0, 0), lgArrowSize, Vector2.new(0, 258), lgImgOffset, self.DPadFrame)
	local lBtn = CreateArrowLabel("LeftButton", UDim2.new(0, 0, 0.5, -32), lgArrowSize, Vector2.new(129, 129), lgImgOffset, self.DPadFrame)
	local rBtn = CreateArrowLabel("RightButton", UDim2.new(1, -64, 0.5, -32), lgArrowSize, Vector2.new(0, 129), lgImgOffset, self.DPadFrame)
	local jumpBtn = CreateArrowLabel("JumpButton", UDim2.new(0.5, -32, 0.5, -32), lgArrowSize, Vector2.new(129, 0), lgImgOffset, self.DPadFrame)
	self.flBtn = CreateArrowLabel("ForwardLeftButton", UDim2.new(0, 35, 0, 35), smArrowSize, Vector2.new(129, 258), smImgOffset, self.DPadFrame)
	self.frBtn = CreateArrowLabel("ForwardRightButton", UDim2.new(1, -55, 0, 35), smArrowSize, Vector2.new(176, 258), smImgOffset, self.DPadFrame)
	self.flBtn.Visible = false
	self.frBtn.Visible = false
	jumpBtn.InputBegan:Connect(function(inputObject)
		self.isJumping = true
	end)
	local function normalizeDirection(inputPosition)
		local jumpRadius = jumpBtn.AbsoluteSize.x * 0.5
		local centerPosition = self:GetCenterPosition()
		local direction = Vector2.new(inputPosition.x - centerPosition.x, inputPosition.y - centerPosition.y)
		if jumpRadius < direction.magnitude then
			local angle = math.atan2(direction.y, direction.x)
			local octant = math.floor(8 * angle / (2 * math.pi) + 8.5) % 8 + 1
			self.moveVector = COMPASS_DIR[octant]
		end
		if not self.flBtn.Visible and self.moveVector == COMPASS_DIR[7] then
			self.flBtn.Visible = true
			self.frBtn.Visible = true
		end
	end
	self.DPadFrame.InputBegan:Connect(function(inputObject)
		if self.touchObject or inputObject.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		self.touchObject = inputObject
		normalizeDirection(self.touchObject.Position)
	end)
	self.DPadFrame.InputChanged:Connect(function(inputObject)
		if inputObject == self.touchObject then
			normalizeDirection(self.touchObject.Position)
			self.isJumping = false
		end
	end)
	self.DPadFrame.InputEnded:connect(function(inputObject)
		if inputObject == self.touchObject then
			self:OnInputEnded()
		end
	end)
	GuiService.MenuOpened:Connect(function()
		if self.touchObject then
			self:OnInputEnded()
		end
	end)
	self.DPadFrame.Parent = parentFrame
end
return TouchDPad


starterplayerscripts.coreclient.playermodule.controlmodule.touchjump
--SynapseX Decompiler

local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local TOUCH_CONTROL_SHEET = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
local BaseCharacterController = require(script.Parent:WaitForChild("BaseCharacterController"))
local TouchJump = setmetatable({}, BaseCharacterController)
TouchJump.__index = TouchJump
function TouchJump.new()
	local self = setmetatable(BaseCharacterController.new(), TouchJump)
	self.parentUIFrame = nil
	self.jumpButton = nil
	self.characterAddedConn = nil
	self.humanoidStateEnabledChangedConn = nil
	self.humanoidJumpPowerConn = nil
	self.humanoidParentConn = nil
	self.externallyEnabled = false
	self.jumpPower = 0
	self.jumpStateEnabled = true
	self.isJumping = false
	self.humanoid = nil
	return self
end
function TouchJump:EnableButton(enable)
	if enable then
		if not self.jumpButton then
			self:Create()
		end
		local humanoid = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if humanoid and self.externallyEnabled and self.externallyEnabled and humanoid.JumpPower > 0 then
			self.jumpButton.Visible = true
		end
	else
		self.jumpButton.Visible = false
		self.isJumping = false
		self.jumpButton.ImageRectOffset = Vector2.new(176, 222)
	end
end
function TouchJump:UpdateEnabled()
	if self.jumpPower > 0 and self.jumpStateEnabled then
		self:EnableButton(true)
	else
		self:EnableButton(false)
	end
end
function TouchJump:HumanoidChanged(prop)
	local humanoid = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		if prop == "JumpPower" then
			self.jumpPower = humanoid.JumpPower
			self:UpdateEnabled()
		elseif prop == "Parent" and not humanoid.Parent then
			self.humanoidChangeConn:Disconnect()
		end
	end
end
function TouchJump:HumanoidStateEnabledChanged(state, isEnabled)
	if state == Enum.HumanoidStateType.Jumping then
		self.jumpStateEnabled = isEnabled
		self:UpdateEnabled()
	end
end
function TouchJump:CharacterAdded(char)
	if self.humanoidChangeConn then
		self.humanoidChangeConn:Disconnect()
		self.humanoidChangeConn = nil
	end
	self.humanoid = char:FindFirstChildOfClass("Humanoid")
	while not self.humanoid do
		char.ChildAdded:wait()
		self.humanoid = char:FindFirstChildOfClass("Humanoid")
	end
	self.humanoidJumpPowerConn = self.humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
		self.jumpPower = self.humanoid.JumpPower
		self:UpdateEnabled()
	end)
	self.humanoidParentConn = self.humanoid:GetPropertyChangedSignal("Parent"):Connect(function()
		if not self.humanoid.Parent then
			self.humanoidJumpPowerConn:Disconnect()
			self.humanoidJumpPowerConn = nil
			self.humanoidParentConn:Disconnect()
			self.humanoidParentConn = nil
		end
	end)
	self.humanoidStateEnabledChangedConn = self.humanoid.StateEnabledChanged:Connect(function(state, enabled)
		self:HumanoidStateEnabledChanged(state, enabled)
	end)
	self.jumpPower = self.humanoid.JumpPower
	self.jumpStateEnabled = self.humanoid:GetStateEnabled(Enum.HumanoidStateType.Jumping)
	self:UpdateEnabled()
end
function TouchJump:SetupCharacterAddedFunction()
	self.characterAddedConn = Players.LocalPlayer.CharacterAppearanceLoaded:Connect(function(char)
		self:CharacterAdded(char)
	end)
	if Players.LocalPlayer.Character then
		self:CharacterAdded(Players.LocalPlayer.Character)
	end
end
function TouchJump:Enable(enable, parentFrame)
	self.parentUIFrame = parentFrame
	self.externallyEnabled = enable
	self:EnableButton(enable)
end
function TouchJump:Create()
	if not self.parentUIFrame then
		return
	end
	if self.jumpButton then
		self.jumpButton:Destroy()
		self.jumpButton = nil
	end
	local minAxis = math.min(self.parentUIFrame.AbsoluteSize.x, self.parentUIFrame.AbsoluteSize.y)
	local isSmallScreen = minAxis <= 500
	local jumpButtonSize = isSmallScreen and 70 or 120
	self.jumpButton = Instance.new("ImageButton")
	self.jumpButton.Name = "JumpButton"
	self.jumpButton.Visible = false
	self.jumpButton.BackgroundTransparency = 1
	self.jumpButton.Image = TOUCH_CONTROL_SHEET
	self.jumpButton.ImageRectOffset = Vector2.new(1, 146)
	self.jumpButton.ImageRectSize = Vector2.new(144, 144)
	self.jumpButton.Size = UDim2.new(0, jumpButtonSize, 0, jumpButtonSize)
	self.jumpButton.Position = isSmallScreen and UDim2.new(1, -(jumpButtonSize * 1.5 - 10), 1, -jumpButtonSize - 20) or UDim2.new(1, -(jumpButtonSize * 1.5 - 10), 1, -jumpButtonSize * 1.75)
	local touchObject
	self.jumpButton.InputBegan:connect(function(inputObject)
		if touchObject or inputObject.UserInputType ~= Enum.UserInputType.Touch or inputObject.UserInputState ~= Enum.UserInputState.Begin then
			return
		end
		touchObject = inputObject
		self.jumpButton.ImageRectOffset = Vector2.new(146, 146)
		self.isJumping = true
	end)
	local function OnInputEnded()
		touchObject = nil
		self.isJumping = false
		self.jumpButton.ImageRectOffset = Vector2.new(1, 146)
	end
	self.jumpButton.InputEnded:connect(function(inputObject)
		if inputObject == touchObject then
			OnInputEnded()
		end
	end)
	GuiService.MenuOpened:connect(function()
		if touchObject then
			OnInputEnded()
		end
	end)
	if not self.characterAddedConn then
		self:SetupCharacterAddedFunction()
	end
	self.jumpButton.Parent = self.parentUIFrame
end
return TouchJump

starterplayerscripts.coreclient.playermodule.controlmodule.touchthumbpad
--SynapseX Decompiler

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local DPAD_SHEET = "rbxasset://textures/ui/DPadSheet.png"
local TOUCH_CONTROL_SHEET = "rbxasset://textures/ui/TouchControlsSheet.png"
local ZERO_VECTOR3 = Vector3.new(0, 0, 0)
local UNIT_Z = Vector3.new(0, 0, 1)
local UNIT_X = Vector3.new(1, 0, 0)
local BaseCharacterController = require(script.Parent:WaitForChild("BaseCharacterController"))
local TouchThumbpad = setmetatable({}, BaseCharacterController)
TouchThumbpad.__index = TouchThumbpad
function TouchThumbpad.new()
	local self = setmetatable(BaseCharacterController.new(), TouchThumbpad)
	self.thumbpadFrame = nil
	self.touchChangedConn = nil
	self.touchEndedConn = nil
	self.menuOpenedConn = nil
	self.screenPos = nil
	self.isRight, self.isLeft, self.isUp, self.isDown = false, false, false, false
	self.smArrowSize = nil
	self.lgArrowSize = nil
	self.smImgOffset = nil
	self.lgImgOffset = nil
	return self
end
local doTween = function(guiObject, endSize, endPosition)
	guiObject:TweenSizeAndPosition(endSize, endPosition, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.15, true)
end
local function CreateArrowLabel(name, position, size, rectOffset, rectSize, parent)
	local image = Instance.new("ImageLabel")
	image.Name = name
	image.Image = DPAD_SHEET
	image.ImageRectOffset = rectOffset
	image.ImageRectSize = rectSize
	image.BackgroundTransparency = 1
	image.ImageColor3 = Color3.fromRGB(190, 190, 190)
	image.Size = size
	image.Position = position
	image.Parent = parent
	return image
end
function TouchThumbpad:Enable(enable, uiParentFrame)
	if enable == nil then
		return false
	end
	enable = enable and true or false
	if self.enabled == enable then
		return true
	end
	self.moveVector = ZERO_VECTOR3
	self.isJumping = false
	if enable then
		if not self.thumbpadFrame then
			self:Create(uiParentFrame)
		end
		self.thumbpadFrame.Visible = true
	else
		self.thumbpadFrame.Visible = false
		self:OnInputEnded()
	end
	self.enabled = enable
end
function TouchThumbpad:OnInputEnded()
	self.moveVector = ZERO_VECTOR3
	self.isJumping = false
	self.thumbpadFrame.Position = self.screenPos
	self.touchObject = nil
	self.isUp, self.isDown, self.isLeft, self.isRight = false, false, false, false
	doTween(self.dArrow, self.smArrowSize, UDim2.new(0.5, -0.5 * self.smArrowSize.X.Offset, 1, self.lgImgOffset))
	doTween(self.uArrow, self.smArrowSize, UDim2.new(0.5, -0.5 * self.smArrowSize.X.Offset, 0, self.smImgOffset))
	doTween(self.lArrow, self.smArrowSize, UDim2.new(0, self.smImgOffset, 0.5, -0.5 * self.smArrowSize.Y.Offset))
	doTween(self.rArrow, self.smArrowSize, UDim2.new(1, self.lgImgOffset, 0.5, -0.5 * self.smArrowSize.Y.Offset))
end
function TouchThumbpad:Create(parentFrame)
	if self.thumbpadFrame then
		self.thumbpadFrame:Destroy()
		self.thumbpadFrame = nil
	end
	if self.touchChangedConn then
		self.touchChangedConn:Disconnect()
		self.touchChangedConn = nil
	end
	if self.touchEndedConn then
		self.touchEndedConn:Disconnect()
		self.touchEndedConn = nil
	end
	if self.menuOpenedConn then
		self.menuOpenedConn:Disconnect()
		self.menuOpenedConn = nil
	end
	local minAxis = math.min(parentFrame.AbsoluteSize.x, parentFrame.AbsoluteSize.y)
	local isSmallScreen = minAxis <= 500
	local thumbpadSize = isSmallScreen and 70 or 120
	self.screenPos = isSmallScreen and UDim2.new(0, thumbpadSize * 1.25, 1, -thumbpadSize - 20) or UDim2.new(0, thumbpadSize * 0.5 - 10, 1, -thumbpadSize * 1.75 - 10)
	self.thumbpadFrame = Instance.new("Frame")
	self.thumbpadFrame.Name = "ThumbpadFrame"
	self.thumbpadFrame.Visible = false
	self.thumbpadFrame.Active = true
	self.thumbpadFrame.Size = UDim2.new(0, thumbpadSize + 20, 0, thumbpadSize + 20)
	self.thumbpadFrame.Position = self.screenPos
	self.thumbpadFrame.BackgroundTransparency = 1
	local outerImage = Instance.new("ImageLabel")
	outerImage.Name = "OuterImage"
	outerImage.Image = TOUCH_CONTROL_SHEET
	outerImage.ImageRectOffset = Vector2.new(0, 0)
	outerImage.ImageRectSize = Vector2.new(220, 220)
	outerImage.BackgroundTransparency = 1
	outerImage.Size = UDim2.new(0, thumbpadSize, 0, thumbpadSize)
	outerImage.Position = UDim2.new(0, 10, 0, 10)
	outerImage.Parent = self.thumbpadFrame
	self.smArrowSize = isSmallScreen and UDim2.new(0, 32, 0, 32) or UDim2.new(0, 64, 0, 64)
	self.lgArrowSize = UDim2.new(0, self.smArrowSize.X.Offset * 2, 0, self.smArrowSize.Y.Offset * 2)
	local imgRectSize = Vector2.new(110, 110)
	self.smImgOffset = isSmallScreen and -4 or -9
	self.lgImgOffset = isSmallScreen and -28 or -55
	self.dArrow = CreateArrowLabel("DownArrow", UDim2.new(0.5, -0.5 * self.smArrowSize.X.Offset, 1, self.lgImgOffset), self.smArrowSize, Vector2.new(8, 8), imgRectSize, outerImage)
	self.uArrow = CreateArrowLabel("UpArrow", UDim2.new(0.5, -0.5 * self.smArrowSize.X.Offset, 0, self.smImgOffset), self.smArrowSize, Vector2.new(8, 266), imgRectSize, outerImage)
	self.lArrow = CreateArrowLabel("LeftArrow", UDim2.new(0, self.smImgOffset, 0.5, -0.5 * self.smArrowSize.Y.Offset), self.smArrowSize, Vector2.new(137, 137), imgRectSize, outerImage)
	self.rArrow = CreateArrowLabel("RightArrow", UDim2.new(1, self.lgImgOffset, 0.5, -0.5 * self.smArrowSize.Y.Offset), self.smArrowSize, Vector2.new(8, 137), imgRectSize, outerImage)
	local doTween = function(guiObject, endSize, endPosition)
		guiObject:TweenSizeAndPosition(endSize, endPosition, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.15, true)
	end
	local padOrigin
	local deadZone = 0.1
	self.isRight, self.isLeft, self.isUp, self.isDown = false, false, false, false
	local function doMove(pos)
		local moveDelta = pos - padOrigin
		local moveVector2 = 2 * moveDelta / thumbpadSize
		if moveVector2.Magnitude < deadZone then
			self.moveVector = ZERO_VECTOR3
		else
			moveVector2 = moveVector2.unit * ((moveVector2.Magnitude - deadZone) / (1 - deadZone))
			if moveVector2.Magnitude == 0 then
				self.moveVector = ZERO_VECTOR3
			else
				self.moveVector = Vector3.new(moveVector2.x, 0, moveVector2.y).Unit
			end
		end
		local forwardDot = self.moveVector:Dot(-UNIT_Z)
		local rightDot = self.moveVector:Dot(UNIT_X)
		if forwardDot > 0.5 then
			if not self.isUp then
				self.isUp, self.isDown = true, false
				doTween(self.uArrow, self.lgArrowSize, UDim2.new(0.5, -self.smArrowSize.X.Offset, 0, self.smImgOffset - 1.5 * self.smArrowSize.Y.Offset))
				doTween(self.dArrow, self.smArrowSize, UDim2.new(0.5, -0.5 * self.smArrowSize.X.Offset, 1, self.lgImgOffset))
			end
		elseif forwardDot < -0.5 then
			if not self.isDown then
				self.isDown, self.isUp = true, false
				doTween(self.dArrow, self.lgArrowSize, UDim2.new(0.5, -self.smArrowSize.X.Offset, 1, self.lgImgOffset + 0.5 * self.smArrowSize.Y.Offset))
				doTween(self.uArrow, self.smArrowSize, UDim2.new(0.5, -0.5 * self.smArrowSize.X.Offset, 0, self.smImgOffset))
			end
		else
			self.isUp, self.isDown = false, false
			doTween(self.dArrow, self.smArrowSize, UDim2.new(0.5, -0.5 * self.smArrowSize.X.Offset, 1, self.lgImgOffset))
			doTween(self.uArrow, self.smArrowSize, UDim2.new(0.5, -0.5 * self.smArrowSize.X.Offset, 0, self.smImgOffset))
		end
		if rightDot > 0.5 then
			if not self.isRight then
				self.isRight, self.isLeft = true, false
				doTween(self.rArrow, self.lgArrowSize, UDim2.new(1, self.lgImgOffset + 0.5 * self.smArrowSize.X.Offset, 0.5, -self.smArrowSize.Y.Offset))
				doTween(self.lArrow, self.smArrowSize, UDim2.new(0, self.smImgOffset, 0.5, -0.5 * self.smArrowSize.Y.Offset))
			end
		elseif rightDot < -0.5 then
			if not self.isLeft then
				self.isLeft, self.isRight = true, false
				doTween(self.lArrow, self.lgArrowSize, UDim2.new(0, self.smImgOffset - 1.5 * self.smArrowSize.X.Offset, 0.5, -self.smArrowSize.Y.Offset))
				doTween(self.rArrow, self.smArrowSize, UDim2.new(1, self.lgImgOffset, 0.5, -0.5 * self.smArrowSize.Y.Offset))
			end
		else
			self.isRight, self.isLeft = false, false
			doTween(self.lArrow, self.smArrowSize, UDim2.new(0, self.smImgOffset, 0.5, -0.5 * self.smArrowSize.Y.Offset))
			doTween(self.rArrow, self.smArrowSize, UDim2.new(1, self.lgImgOffset, 0.5, -0.5 * self.smArrowSize.Y.Offset))
		end
	end
	self.thumbpadFrame.InputBegan:connect(function(inputObject)
		if self.touchObject or inputObject.UserInputType ~= Enum.UserInputType.Touch or inputObject.UserInputState ~= Enum.UserInputState.Begin then
			return
		end
		self.thumbpadFrame.Position = UDim2.new(0, inputObject.Position.x - 0.5 * self.thumbpadFrame.AbsoluteSize.x, 0, inputObject.Position.y - 0.5 * self.thumbpadFrame.Size.Y.Offset)
		padOrigin = Vector3.new(self.thumbpadFrame.AbsolutePosition.x + 0.5 * self.thumbpadFrame.AbsoluteSize.x, self.thumbpadFrame.AbsolutePosition.y + 0.5 * self.thumbpadFrame.AbsoluteSize.y, 0)
		doMove(inputObject.Position)
		self.touchObject = inputObject
	end)
	self.touchChangedConn = UserInputService.TouchMoved:connect(function(inputObject, isProcessed)
		if inputObject == self.touchObject then
			doMove(self.touchObject.Position)
		end
	end)
	self.touchEndedConn = UserInputService.TouchEnded:Connect(function(inputObject)
		if inputObject == self.touchObject then
			self:OnInputEnded()
		end
	end)
	self.menuOpenedConn = GuiService.MenuOpened:Connect(function()
		if self.touchObject then
			self:OnInputEnded()
		end
	end)
	self.thumbpadFrame.Parent = parentFrame
end
return TouchThumbpad

starterplayerscripts.coreclient.playermodule.controlmodule.touchthumbstick
--SynapseX Decompiler

local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local ZERO_VECTOR3 = Vector3.new(0, 0, 0)
local TOUCH_CONTROL_SHEET = "rbxasset://textures/ui/TouchControlsSheet.png"
local BaseCharacterController = require(script.Parent:WaitForChild("BaseCharacterController"))
local TouchThumbstick = setmetatable({}, BaseCharacterController)
TouchThumbstick.__index = TouchThumbstick
function TouchThumbstick.new()
	local self = setmetatable(BaseCharacterController.new(), TouchThumbstick)
	self.isFollowStick = false
	self.thumbstickFrame = nil
	self.moveTouchObject = nil
	self.onTouchMovedConn = nil
	self.onTouchEndedConn = nil
	self.screenPos = nil
	self.stickImage = nil
	self.thumbstickSize = nil
	return self
end
function TouchThumbstick:Enable(enable, uiParentFrame)
	if enable == nil then
		return false
	end
	enable = enable and true or false
	if self.enabled == enable then
		return true
	end
	self.moveVector = ZERO_VECTOR3
	self.isJumping = false
	if enable then
		if not self.thumbstickFrame then
			self:Create(uiParentFrame)
		end
		self.thumbstickFrame.Visible = true
	else
		self.thumbstickFrame.Visible = false
		self:OnInputEnded()
	end
	self.enabled = enable
end
function TouchThumbstick:OnInputEnded()
	self.thumbstickFrame.Position = self.screenPos
	self.stickImage.Position = UDim2.new(0, self.thumbstickFrame.Size.X.Offset / 2 - self.thumbstickSize / 4, 0, self.thumbstickFrame.Size.Y.Offset / 2 - self.thumbstickSize / 4)
	self.moveVector = ZERO_VECTOR3
	self.isJumping = false
	self.thumbstickFrame.Position = self.screenPos
	self.moveTouchObject = nil
end
function TouchThumbstick:Create(parentFrame)
	if self.thumbstickFrame then
		self.thumbstickFrame:Destroy()
		self.thumbstickFrame = nil
		if self.onTouchMovedConn then
			self.onTouchMovedConn:Disconnect()
			self.onTouchMovedConn = nil
		end
		if self.onTouchEndedConn then
			self.onTouchEndedConn:Disconnect()
			self.onTouchEndedConn = nil
		end
	end
	local minAxis = math.min(parentFrame.AbsoluteSize.x, parentFrame.AbsoluteSize.y)
	local isSmallScreen = minAxis <= 500
	self.thumbstickSize = isSmallScreen and 70 or 120
	self.screenPos = isSmallScreen and UDim2.new(0, self.thumbstickSize / 2 - 10, 1, -self.thumbstickSize - 20) or UDim2.new(0, self.thumbstickSize / 2, 1, -self.thumbstickSize * 1.75)
	self.thumbstickFrame = Instance.new("Frame")
	self.thumbstickFrame.Name = "ThumbstickFrame"
	self.thumbstickFrame.Active = true
	self.thumbstickFrame.Visible = false
	self.thumbstickFrame.Size = UDim2.new(0, self.thumbstickSize, 0, self.thumbstickSize)
	self.thumbstickFrame.Position = self.screenPos
	self.thumbstickFrame.BackgroundTransparency = 1
	local outerImage = Instance.new("ImageLabel")
	outerImage.Name = "OuterImage"
	outerImage.Image = TOUCH_CONTROL_SHEET
	outerImage.ImageRectOffset = Vector2.new()
	outerImage.ImageRectSize = Vector2.new(220, 220)
	outerImage.BackgroundTransparency = 1
	outerImage.Size = UDim2.new(0, self.thumbstickSize, 0, self.thumbstickSize)
	outerImage.Position = UDim2.new(0, 0, 0, 0)
	outerImage.Parent = self.thumbstickFrame
	self.stickImage = Instance.new("ImageLabel")
	self.stickImage.Name = "StickImage"
	self.stickImage.Image = TOUCH_CONTROL_SHEET
	self.stickImage.ImageRectOffset = Vector2.new(220, 0)
	self.stickImage.ImageRectSize = Vector2.new(111, 111)
	self.stickImage.BackgroundTransparency = 1
	self.stickImage.Size = UDim2.new(0, self.thumbstickSize / 2, 0, self.thumbstickSize / 2)
	self.stickImage.Position = UDim2.new(0, self.thumbstickSize / 2 - self.thumbstickSize / 4, 0, self.thumbstickSize / 2 - self.thumbstickSize / 4)
	self.stickImage.ZIndex = 2
	self.stickImage.Parent = self.thumbstickFrame
	local centerPosition
	local deadZone = 0.05
	local function DoMove(direction)
		local currentMoveVector = direction / (self.thumbstickSize / 2)
		local inputAxisMagnitude = currentMoveVector.magnitude
		if inputAxisMagnitude < deadZone then
			currentMoveVector = Vector3.new()
		else
			currentMoveVector = currentMoveVector.unit * ((inputAxisMagnitude - deadZone) / (1 - deadZone))
			currentMoveVector = Vector3.new(currentMoveVector.x, 0, currentMoveVector.y)
		end
		self.moveVector = currentMoveVector
	end
	local function MoveStick(pos)
		local relativePosition = Vector2.new(pos.x - centerPosition.x, pos.y - centerPosition.y)
		local length = relativePosition.magnitude
		local maxLength = self.thumbstickFrame.AbsoluteSize.x / 2
		if self.isFollowStick and length > maxLength then
			local offset = relativePosition.unit * maxLength
			self.thumbstickFrame.Position = UDim2.new(0, pos.x - self.thumbstickFrame.AbsoluteSize.x / 2 - offset.x, 0, pos.y - self.thumbstickFrame.AbsoluteSize.y / 2 - offset.y)
		else
			length = math.min(length, maxLength)
			relativePosition = relativePosition.unit * length
		end
		self.stickImage.Position = UDim2.new(0, relativePosition.x + self.stickImage.AbsoluteSize.x / 2, 0, relativePosition.y + self.stickImage.AbsoluteSize.y / 2)
	end
	self.thumbstickFrame.InputBegan:Connect(function(inputObject)
		if self.moveTouchObject or inputObject.UserInputType ~= Enum.UserInputType.Touch or inputObject.UserInputState ~= Enum.UserInputState.Begin then
			return
		end
		self.moveTouchObject = inputObject
		self.thumbstickFrame.Position = UDim2.new(0, inputObject.Position.x - self.thumbstickFrame.Size.X.Offset / 2, 0, inputObject.Position.y - self.thumbstickFrame.Size.Y.Offset / 2)
		centerPosition = Vector2.new(self.thumbstickFrame.AbsolutePosition.x + self.thumbstickFrame.AbsoluteSize.x / 2, self.thumbstickFrame.AbsolutePosition.y + self.thumbstickFrame.AbsoluteSize.y / 2)
		local direction = Vector2.new(inputObject.Position.x - centerPosition.x, inputObject.Position.y - centerPosition.y)
	end)
	self.onTouchMovedConn = UserInputService.TouchMoved:Connect(function(inputObject, isProcessed)
		if inputObject == self.moveTouchObject then
			centerPosition = Vector2.new(self.thumbstickFrame.AbsolutePosition.x + self.thumbstickFrame.AbsoluteSize.x / 2, self.thumbstickFrame.AbsolutePosition.y + self.thumbstickFrame.AbsoluteSize.y / 2)
			local direction = Vector2.new(inputObject.Position.x - centerPosition.x, inputObject.Position.y - centerPosition.y)
			DoMove(direction)
			MoveStick(inputObject.Position)
		end
	end)
	self.onTouchEndedConn = UserInputService.TouchEnded:Connect(function(inputObject, isProcessed)
		if inputObject == self.moveTouchObject then
			self:OnInputEnded()
		end
	end)
	GuiService.MenuOpened:Connect(function()
		if self.moveTouchObject then
			self:OnInputEnded()
		end
	end)
	self.thumbstickFrame.Parent = parentFrame
end
return TouchThumbstick

starterplayerscripts.coreclient.playermodule.controlmodule.vrnavigation
--SynapseX Decompiler

local VRService = game:GetService("VRService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local PathfindingService = game:GetService("PathfindingService")
local ContextActionService = game:GetService("ContextActionService")
local StarterGui = game:GetService("StarterGui")
local PathDisplay
local LocalPlayer = Players.LocalPlayer
local bindAtPriorityFlagExists, bindAtPriorityFlagEnabled = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserPlayerScriptsBindAtPriority")
end)
local FFlagPlayerScriptsBindAtPriority = bindAtPriorityFlagExists and bindAtPriorityFlagEnabled
local RECALCULATE_PATH_THRESHOLD = 4
local NO_PATH_THRESHOLD = 12
local MAX_PATHING_DISTANCE = 200
local POINT_REACHED_THRESHOLD = 1
local STOPPING_DISTANCE = 4
local OFFTRACK_TIME_THRESHOLD = 2
local THUMBSTICK_DEADZONE = 0.22
local ZERO_VECTOR3 = Vector3.new(0, 0, 0)
local XZ_VECTOR3 = Vector3.new(1, 0, 1)
local IsFinite = function(num)
	return num == num and num ~= 1 / 0 and num ~= -1 / 0
end
local function IsFiniteVector3(vec3)
	return IsFinite(vec3.x) and IsFinite(vec3.y) and IsFinite(vec3.z)
end
local movementUpdateEvent = Instance.new("BindableEvent")
movementUpdateEvent.Name = "MovementUpdate"
movementUpdateEvent.Parent = script
coroutine.wrap(function()
	local PathDisplayModule = script.Parent:WaitForChild("PathDisplay")
	if PathDisplayModule then
		PathDisplay = require(PathDisplayModule)
	end
end)()
local BaseCharacterController = require(script.Parent:WaitForChild("BaseCharacterController"))
local VRNavigation = setmetatable({}, BaseCharacterController)
VRNavigation.__index = VRNavigation
function VRNavigation.new(CONTROL_ACTION_PRIORITY)
	local self = setmetatable(BaseCharacterController.new(), VRNavigation)
	self.CONTROL_ACTION_PRIORITY = CONTROL_ACTION_PRIORITY
	self.navigationRequestedConn = nil
	self.heartbeatConn = nil
	self.currentDestination = nil
	self.currentPath = nil
	self.currentPoints = nil
	self.currentPointIdx = 0
	self.expectedTimeToNextPoint = 0
	self.timeReachedLastPoint = tick()
	self.moving = false
	self.isJumpBound = false
	self.moveLatch = false
	self.userCFrameEnabledConn = nil
	return self
end
function VRNavigation:SetLaserPointerMode(mode)
	pcall(function()
		StarterGui:SetCore("VRLaserPointerMode", mode)
	end)
end
function VRNavigation:GetLocalHumanoid()
	local character = LocalPlayer.Character
	if not character then
		return
	end
	for _, child in pairs(character:GetChildren()) do
		if child:IsA("Humanoid") then
			return child
		end
	end
	return nil
end
function VRNavigation:HasBothHandControllers()
	return VRService:GetUserCFrameEnabled(Enum.UserCFrame.RightHand) and VRService:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand)
end
function VRNavigation:HasAnyHandControllers()
	return VRService:GetUserCFrameEnabled(Enum.UserCFrame.RightHand) or VRService:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand)
end
function VRNavigation:IsMobileVR()
	return UserInputService.TouchEnabled
end
function VRNavigation:HasGamepad()
	return UserInputService.GamepadEnabled
end
function VRNavigation:ShouldUseNavigationLaser()
	if self:IsMobileVR() then
		return true
	else
		if self:HasBothHandControllers() then
			return false
		end
		if not self:HasAnyHandControllers() then
			return not self:HasGamepad()
		end
		return true
	end
end
function VRNavigation:StartFollowingPath(newPath)
	currentPath = newPath
	currentPoints = currentPath:GetPointCoordinates()
	currentPointIdx = 1
	moving = true
	timeReachedLastPoint = tick()
	local humanoid = self:GetLocalHumanoid()
	if humanoid and humanoid.Torso and #currentPoints >= 1 then
		local dist = (currentPoints[1] - humanoid.Torso.Position).magnitude
		expectedTimeToNextPoint = dist / humanoid.WalkSpeed
	end
	movementUpdateEvent:Fire("targetPoint", self.currentDestination)
end
function VRNavigation:GoToPoint(point)
	currentPath = true
	currentPoints = {point}
	currentPointIdx = 1
	moving = true
	local humanoid = self:GetLocalHumanoid()
	local distance = (humanoid.Torso.Position - point).magnitude
	local estimatedTimeRemaining = distance / humanoid.WalkSpeed
	timeReachedLastPoint = tick()
	expectedTimeToNextPoint = estimatedTimeRemaining
	movementUpdateEvent:Fire("targetPoint", point)
end
function VRNavigation:StopFollowingPath()
	currentPath = nil
	currentPoints = nil
	currentPointIdx = 0
	moving = false
	self.moveVector = ZERO_VECTOR3
end
function VRNavigation:TryComputePath(startPos, destination)
	local numAttempts = 0
	local newPath
	while not newPath and numAttempts < 5 do
		newPath = PathfindingService:ComputeSmoothPathAsync(startPos, destination, MAX_PATHING_DISTANCE)
		numAttempts = numAttempts + 1
		if newPath.Status == Enum.PathStatus.ClosestNoPath or newPath.Status == Enum.PathStatus.ClosestOutOfRange then
			newPath = nil
			break
		end
		if newPath and newPath.Status == Enum.PathStatus.FailStartNotEmpty then
			startPos = startPos + (destination - startPos).unit
			newPath = nil
		end
		if newPath and newPath.Status == Enum.PathStatus.FailFinishNotEmpty then
			destination = destination + Vector3.new(0, 1, 0)
			newPath = nil
		end
	end
	return newPath
end
function VRNavigation:OnNavigationRequest(destinationCFrame, inputUserCFrame)
	local destinationPosition = destinationCFrame.p
	local lastDestination = self.currentDestination
	if not IsFiniteVector3(destinationPosition) then
		return
	end
	self.currentDestination = destinationPosition
	local humanoid = self:GetLocalHumanoid()
	if not humanoid or not humanoid.Torso then
		return
	end
	local currentPosition = humanoid.Torso.Position
	local distanceToDestination = (self.currentDestination - currentPosition).magnitude
	if distanceToDestination < NO_PATH_THRESHOLD then
		self:GoToPoint(self.currentDestination)
		return
	end
	if not lastDestination or (self.currentDestination - lastDestination).magnitude > RECALCULATE_PATH_THRESHOLD then
		local newPath = self:TryComputePath(currentPosition, self.currentDestination)
		if newPath then
			self:StartFollowingPath(newPath)
			if PathDisplay then
				PathDisplay.setCurrentPoints(self.currentPoints)
				PathDisplay.renderPath()
			end
		else
			self:StopFollowingPath()
			if PathDisplay then
				PathDisplay.clearRenderedPath()
			end
		end
	elseif moving then
		self.currentPoints[#currentPoints] = self.currentDestination
	else
		self:GoToPoint(self.currentDestination)
	end
end
function VRNavigation:OnJumpAction(actionName, inputState, inputObj)
	if inputState == Enum.UserInputState.Begin then
		self.isJumping = true
	end
	if FFlagPlayerScriptsBindAtPriority then
		return Enum.ContextActionResult.Sink
	end
end
function VRNavigation:BindJumpAction(active)
	if active then
		if not self.isJumpBound then
			self.isJumpBound = true
			if FFlagPlayerScriptsBindAtPriority then
				ContextActionService:BindActionAtPriority("VRJumpAction", function()
					return self:OnJumpAction()
				end, false, self.CONTROL_ACTION_PRIORITY, Enum.KeyCode.ButtonA)
			else
				ContextActionService:BindAction("VRJumpAction", function()
					self:OnJumpAction()
				end, false, Enum.KeyCode.ButtonA)
			end
		end
	elseif self.isJumpBound then
		self.isJumpBound = false
		ContextActionService:UnbindAction("VRJumpAction")
	end
end
function VRNavigation:ControlCharacterGamepad(actionName, inputState, inputObject)
	if inputObject.KeyCode ~= Enum.KeyCode.Thumbstick1 then
		return
	end
	if inputState == Enum.UserInputState.Cancel then
		self.moveVector = ZERO_VECTOR3
		return
	end
	if inputState ~= Enum.UserInputState.End then
		self:StopFollowingPath()
		if PathDisplay then
			PathDisplay.clearRenderedPath()
		end
		if self:ShouldUseNavigationLaser() then
			self:BindJumpAction(true)
			self:SetLaserPointerMode("Hidden")
		end
		if inputObject.Position.magnitude > THUMBSTICK_DEADZONE then
			self.moveVector = Vector3.new(inputObject.Position.X, 0, -inputObject.Position.Y)
			if self.moveVector.magnitude > 0 then
				self.moveVector = self.moveVector.unit * math.min(1, inputObject.Position.magnitude)
			end
			self.moveLatch = true
		end
	else
		self.moveVector = ZERO_VECTOR3
		if self:ShouldUseNavigationLaser() then
			self:BindJumpAction(false)
			self:SetLaserPointerMode("Navigation")
		end
		if self.moveLatch then
			self.moveLatch = false
			movementUpdateEvent:Fire("offtrack")
		end
	end
	if FFlagPlayerScriptsBindAtPriority then
		return Enum.ContextActionResult.Sink
	end
end
function VRNavigation:OnHeartbeat(dt)
	local newMoveVector = self.moveVector
	local humanoid = self:GetLocalHumanoid()
	if not humanoid or not humanoid.Torso then
		return
	end
	if self.moving and self.currentPoints then
		local currentPosition = humanoid.Torso.Position
		local goalPosition = currentPoints[1]
		local vectorToGoal = (goalPosition - currentPosition) * XZ_VECTOR3
		local moveDist = vectorToGoal.magnitude
		local moveDir = vectorToGoal / moveDist
		if moveDist < POINT_REACHED_THRESHOLD then
			local estimatedTimeRemaining = 0
			local prevPoint = currentPoints[1]
			for i, point in pairs(currentPoints) do
				if i ~= 1 then
					local dist = (point - prevPoint).magnitude
					prevPoint = point
					estimatedTimeRemaining = estimatedTimeRemaining + dist / humanoid.WalkSpeed
				end
			end
			table.remove(currentPoints, 1)
			currentPointIdx = currentPointIdx + 1
			if #currentPoints == 0 then
				self:StopFollowingPath()
				if PathDisplay then
					PathDisplay.clearRenderedPath()
				end
				return
			else
				if PathDisplay then
					PathDisplay.setCurrentPoints(currentPoints)
					PathDisplay.renderPath()
				end
				local newGoal = currentPoints[1]
				local distanceToGoal = (newGoal - currentPosition).magnitude
				expectedTimeToNextPoint = distanceToGoal / humanoid.WalkSpeed
				timeReachedLastPoint = tick()
			end
		else
			local ignoreTable = {
				game.Players.LocalPlayer.Character,
				workspace.CurrentCamera
			}
			local obstructRay = Ray.new(currentPosition - Vector3.new(0, 1, 0), moveDir * 3)
			local obstructPart, obstructPoint, obstructNormal = workspace:FindPartOnRayWithIgnoreList(obstructRay, ignoreTable)
			if obstructPart then
				local heightOffset = Vector3.new(0, 100, 0)
				local jumpCheckRay = Ray.new(obstructPoint + moveDir * 0.5 + heightOffset, -heightOffset)
				local jumpCheckPart, jumpCheckPoint, jumpCheckNormal = workspace:FindPartOnRayWithIgnoreList(jumpCheckRay, ignoreTable)
				local heightDifference = jumpCheckPoint.Y - currentPosition.Y
				if heightDifference < 6 and heightDifference > -2 then
					humanoid.Jump = true
				end
			end
			local timeSinceLastPoint = tick() - timeReachedLastPoint
			if timeSinceLastPoint > expectedTimeToNextPoint + OFFTRACK_TIME_THRESHOLD then
				self:StopFollowingPath()
				if PathDisplay then
					PathDisplay.clearRenderedPath()
				end
				movementUpdateEvent:Fire("offtrack")
			end
			newMoveVector = self.moveVector:Lerp(moveDir, dt * 10)
		end
	end
	if IsFiniteVector3(newMoveVector) then
		self.moveVector = newMoveVector
	end
end
function VRNavigation:OnUserCFrameEnabled()
	if self:ShouldUseNavigationLaser() then
		self:BindJumpAction(false)
		self:SetLaserPointerMode("Navigation")
	else
		self:BindJumpAction(true)
		self:SetLaserPointerMode("Hidden")
	end
end
function VRNavigation:Enable(enable)
	self.moveVector = ZERO_VECTOR3
	self.isJumping = false
	if enable then
		self.navigationRequestedConn = VRService.NavigationRequested:Connect(function(destinationCFrame, inputUserCFrame)
			self:OnNavigationRequest(destinationCFrame, inputUserCFrame)
		end)
		self.heartbeatConn = RunService.Heartbeat:Connect(function(dt)
			self:OnHeartbeat(dt)
		end)
		if FFlagPlayerScriptsBindAtPriority then
			ContextActionService:BindAction("MoveThumbstick", function(actionName, inputState, inputObject)
				return self:ControlCharacterGamepad(actionName, inputState, inputObject)
			end, false, self.CONTROL_ACTION_PRIORITY, Enum.KeyCode.Thumbstick1)
		else
			ContextActionService:BindAction("MoveThumbstick", function(actionName, inputState, inputObject)
				self:ControlCharacterGamepad(actionName, inputState, inputObject)
			end, false, Enum.KeyCode.Thumbstick1)
		end
		ContextActionService:BindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR2)
		self.userCFrameEnabledConn = VRService.UserCFrameEnabled:Connect(function()
			self:OnUserCFrameEnabled()
		end)
		self:OnUserCFrameEnabled()
		pcall(function()
			VRService:SetTouchpadMode(Enum.VRTouchpad.Left, Enum.VRTouchpadMode.VirtualThumbstick)
			VRService:SetTouchpadMode(Enum.VRTouchpad.Right, Enum.VRTouchpadMode.ABXY)
		end)
		self.enabled = true
	else
		self:StopFollowingPath()
		ContextActionService:UnbindAction("MoveThumbstick")
		ContextActionService:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR2)
		self:BindJumpAction(false)
		self:SetLaserPointerMode("Disabled")
		if self.navigationRequestedConn then
			self.navigationRequestedConn:Disconnect()
			self.navigationRequestedConn = nil
		end
		if self.heartbeatConn then
			self.heartbeatConn:Disconnect()
			self.heartbeatConn = nil
		end
		if self.userCFrameEnabledConn then
			self.userCFrameEnabledConn:Disconnect()
			self.userCFrameEnabledConn = nil
		end
		self.enabled = false
	end
end
return VRNavigation

starterplayerscripts.coreclient.playermodule.controlmodule.vehiclecontroller
--[[
	// FileName: VehicleControl
	// Version 1.0
	// Written by: jmargh
	// Description: Implements in-game vehicle controls for all input devices

	// NOTE: This works for basic vehicles (single vehicle seat). If you use custom VehicleSeat code,
	// multiple VehicleSeats or your own idmplementation of a VehicleSeat this will not work.
--]]
local ContextActionService = game:GetService("ContextActionService")

--[[ Constants ]]--
-- Set this to true if you want to instead use the triggers for the throttle
local useTriggersForThrottle = true
-- Also set this to true if you want the thumbstick to not affect throttle, only triggers when a gamepad is conected
local onlyTriggersForThrottle = false
local ZERO_VECTOR3 = Vector3.new(0,0,0)

local AUTO_PILOT_DEFAULT_MAX_STEERING_ANGLE = 35


-- Note that VehicleController does not derive from BaseCharacterController, it is a special case
local VehicleController = {}
VehicleController.__index = VehicleController

function VehicleController.new(CONTROL_ACTION_PRIORITY)
	local self = setmetatable({}, VehicleController)

	self.CONTROL_ACTION_PRIORITY = CONTROL_ACTION_PRIORITY

	self.enabled = false
	self.vehicleSeat = nil
	self.throttle = 0
	self.steer = 0

	self.acceleration = 0
	self.decceleration = 0
	self.turningRight = 0
	self.turningLeft = 0

	self.vehicleMoveVector = ZERO_VECTOR3

	self.autoPilot = {}
	self.autoPilot.MaxSpeed = 0
	self.autoPilot.MaxSteeringAngle = 0

	return self
end

function VehicleController:BindContextActions()
	if useTriggersForThrottle then
		ContextActionService:BindActionAtPriority("throttleAccel", function(actionName, inputState, inputObject)
			self:OnThrottleAccel(actionName, inputState, inputObject)
			return Enum.ContextActionResult.Pass
		end, false, self.CONTROL_ACTION_PRIORITY, Enum.KeyCode.ButtonR2)
		ContextActionService:BindActionAtPriority("throttleDeccel", function(actionName, inputState, inputObject)
			self:OnThrottleDeccel(actionName, inputState, inputObject)
			return Enum.ContextActionResult.Pass
		end, false, self.CONTROL_ACTION_PRIORITY, Enum.KeyCode.ButtonL2)
	end
	ContextActionService:BindActionAtPriority("arrowSteerRight", function(actionName, inputState, inputObject)
		self:OnSteerRight(actionName, inputState, inputObject)
		return Enum.ContextActionResult.Pass
	end, false, self.CONTROL_ACTION_PRIORITY, Enum.KeyCode.Right)
	ContextActionService:BindActionAtPriority("arrowSteerLeft", function(actionName, inputState, inputObject)
		self:OnSteerLeft(actionName, inputState, inputObject)
		return Enum.ContextActionResult.Pass
	end, false, self.CONTROL_ACTION_PRIORITY, Enum.KeyCode.Left)
end

function VehicleController:Enable(enable, vehicleSeat)
	if enable == self.enabled and vehicleSeat == self.vehicleSeat then
		return
	end

	self.enabled = enable
	self.vehicleMoveVector = ZERO_VECTOR3

	if enable then
		if vehicleSeat then
			self.vehicleSeat = vehicleSeat

			self:BindContextActions()
		end
	else
		ContextActionService:UnbindAction("throttleAccel")
		ContextActionService:UnbindAction("throttleDeccel")
		ContextActionService:UnbindAction("arrowSteerRight")
		ContextActionService:UnbindAction("arrowSteerLeft")
		self.vehicleSeat = nil
		return
	end
	self:SetupAutoPilot();
	self:BindContextActions();
end

function VehicleController:OnThrottleAccel(actionName, inputState, inputObject)
	if inputState == Enum.UserInputState.End or inputState == Enum.UserInputState.Cancel then
		self.acceleration = 0
	else
		self.acceleration = -1
	end
	self.throttle = self.acceleration + self.decceleration
end

function VehicleController:OnThrottleDeccel(actionName, inputState, inputObject)
	if inputState == Enum.UserInputState.End or inputState == Enum.UserInputState.Cancel then
		self.decceleration = 0
	else
		self.decceleration = 1
	end
	self.throttle = self.acceleration + self.decceleration
end

function VehicleController:OnSteerRight(actionName, inputState, inputObject)
	if inputState == Enum.UserInputState.End or inputState == Enum.UserInputState.Cancel then
		self.turningRight = 0;
	else
		self.turningRight = 1;
	end;
	self.steer = self.turningRight + self.turningLeft;
end;
function VehicleController:OnSteerLeft(actionName, inputState, inputObject)
	if inputState == Enum.UserInputState.End or inputState == Enum.UserInputState.Cancel then
		self.turningLeft = 0;
	else
		self.turningLeft = -1;
	end;
	self.steer = self.turningRight + self.turningLeft;
end
-- Call this from a function bound to Renderstep with Input Priority
function VehicleController:Update(moveVector, usingGamepad)
	if self.vehicleSeat then
		moveVector = moveVector + Vector3.new(self.steer, 0, self.throttle)
		if usingGamepad and onlyTriggersForThrottle and useTriggersForThrottle then
			self.vehicleSeat.ThrottleFloat = -self.throttle
		else
			self.vehicleSeat.ThrottleFloat = -moveVector.Z
		end
		self.vehicleSeat.SteerFloat = moveVector.X
		return moveVector, true
	end
	return moveVector, false
end

function VehicleController:ComputeThrottle(localMoveVector)
	if localMoveVector ~= ZERO_VECTOR3 then
		local throttle = -localMoveVector.Z
		return throttle
	else
		return 0.0
	end
end
local u1 = Vector3.new(0, 0, 0);
function VehicleController:ComputeSteer(localMoveVector,  p41)
	if p41 == u1 then
		return 0;
	end;
	return -math.atan2(-p41.x, -p41.z) * (180 / math.pi) / localMoveVector.autoPilot.MaxSteeringAngle;
end

function VehicleController:SetupAutoPilot()
	-- Setup default
	self.autoPilot.MaxSpeed = self.vehicleSeat.MaxSpeed
	self.autoPilot.MaxSteeringAngle = 35;

	-- VehicleSeat should have a MaxSteeringAngle as well.
	-- Or we could look for a child "AutoPilotConfigModule" to find these values
	-- Or allow developer to set them through the API as like the CLickToMove customization API
end

return VehicleController
