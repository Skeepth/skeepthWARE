serverscriptserice.services.bankservice



local BankService = {}
local DataStore2 = require(script.Parent.Parent.MainModule)
local PlayerService = require(game.ServerScriptService.Services.PlayerService)
local FunctionService = require(game.ServerScriptService.Services.FunctionService)
local WebService = require(game.ServerScriptService.Services.WebService)
local Remotes = game.ReplicatedStorage.Remotes
local VerifyService = require(game.ServerScriptService.Services.VerifyService)

local RemoteService = require(game.ServerScriptService.Services.RemoteService)
function RegisterRemote(name, callback)
	RemoteService.RegisterRemote(name, callback)
end

RegisterRemote("BankUserTransfer", function(player, id, username, sendAmount)
	if not PlayerService.Distance(player, id) then
		return;
	end;
	if not game.Players:FindFirstChild(username) then
		return
	end 
	local argPlayer = game:GetService("Players"):FindFirstChild(username)
	local bankBalance = VerifyService:GetData(player).Bank
	local cashBalance = VerifyService:GetData(player).Cash
	local argPlayerBankData = VerifyService:GetData(argPlayer).Bank
	local argPlayerWalletData = VerifyService:GetData(argPlayer).Cash
	if username == player.Name then
		game.ReplicatedStorage.Remotes.Notification:FireClient(player,"You can't transfer money to your own account.","Transfer Unsuccessful!","Red")
		return
	end
	if cashBalance >= sendAmount  then
		game.ReplicatedStorage.Remotes.Notification:FireClient(player,"$"..sendAmount.." has been transferred to "..argPlayer.Name.."'s account.","Transfer Successful!")
		VerifyService:GetData(player).Cash = cashBalance-sendAmount
		wait(5)
		VerifyService:GetData(argPlayer).Bank = argPlayerBankData+sendAmount
		game.ReplicatedStorage.Remotes.Notification:FireClient(argPlayer,"$"..sendAmount.." has been transferred to you by "..player.Name,"Transfer Successful!")
		local jsonToSend = {
			embeds = {
				{
					title = "Log Event",
					type = "rich",
					description = player.Name .. " transferred $"..sendAmount .. " to " ..argPlayer.Name,
				}
			}
		}
		WebService.SendJSON("DrpLog", jsonToSend)
	elseif bankBalance >= sendAmount then
		game.ReplicatedStorage.Remotes.Notification:FireClient(player,"$"..sendAmount.." has been transferred to "..argPlayer.Name.."'s account.","Transfer Successful!")
		VerifyService:GetData(player).Bank = bankBalance-sendAmount
		VerifyService:GetData(argPlayer).Bank = argPlayerBankData+sendAmount
		game.ReplicatedStorage.Remotes.Notification:FireClient(argPlayer,"$"..sendAmount.." has been transferred to you by "..player.Name,"Transfer Successful!")
		local jsonToSend = {
			embeds = {
				{
					title = "Log Event",
					type = "rich",
					description = player.Name .. " transferred $"..sendAmount .. " to " ..argPlayer.Name,
				}
			}
		}
		WebService.SendJSON("DrpLog", jsonToSend)
	else
		game.ReplicatedStorage.Remotes.Notification:FireClient(player, "You do not have enough money to complete this transaction!", "Transaction Failed!", "Red")
	end
	RemoteService.UpdateMoney(player)
	RemoteService.UpdateMoney(argPlayer)
end)

RegisterRemote("BankLocalTransfer", function(Plr,val1,val2,val3,val4,val5)
	if not PlayerService.Distance(Plr, val1) then
		return;
	end;


	local Bank = VerifyService:GetData(Plr).Bank
	local Cash = VerifyService:GetData(Plr).Cash
	local BANK_LIMIT = 5000

	if val2 == "Bank" and val3 == "Cash" then 
		if val4 > 0 and Bank >= val4 then
			VerifyService:GetData(Plr).Bank =Bank-val4
			Remotes.Notification:FireClient(Plr, "$" .. val4 .. " has been withdrawn.", "Transfer Successful!");
			VerifyService:GetData(Plr).Cash =Cash+val4
			RemoteService.UpdateMoney(Plr)
			local jsonToSend = {
				embeds = {
					{
						title = "Log Event",
						type = "rich",
						description = Plr.Name .. " transferred $"..val4 .. " to Cash account.",
					}
				}
			}
			WebService.SendJSON("DrpLog", jsonToSend)
		else
			game.ReplicatedStorage.Remotes.Notification:FireClient(Plr, "You do not have enough money to complete this transaction!", "Transaction Failed!", "Red")
		end
	end
	if val2 == "Cash" and val3 == "Bank" then

		if Bank >= BANK_LIMIT then
			print'AHHH'
			game.ReplicatedStorage.Remotes.Notification:FireClient(Plr, "Maximum limit of Bank account is 5000.", "Transfer Unsuccessful!")
			return
		end

		if Bank <= val4 then
			print'XD'
			game.ReplicatedStorage.Remotes.Notification:FireClient(Plr, "Maximum limit of Bank account is 5000.", "Transfer Unsuccessful!")
			return
		end
		if val4 > 0 and Bank >= val4 then
			VerifyService:GetData(Plr).Bank = Bank+val4
			Remotes.Notification:FireClient(Plr, "$" .. val4 .. " has been deposited.", "Transfer Successful!");
			VerifyService:GetData(Plr).Cash = Cash-val4
			RemoteService.UpdateMoney(Plr)
			local jsonToSend = {
				embeds = {
					{
						title = "Log Event",
						type = "rich",
						description = Plr.Name .. " transferred $"..val4 .. " to Bank account.",
					}
				}
			}
			WebService.SendJSON("DrpLog", jsonToSend)
		else
			game.ReplicatedStorage.Remotes.Notification:FireClient(Plr, "You do not have enough money to complete this transaction!", "Transaction Failed!", "Red")
		end
	end

	--RemoteService.UpdateMoney(Plr)
end)








return BankService

services.electionservice
local API = {}
local DataStoreService = game:GetService("DataStoreService")
local Remotes = game.ReplicatedStorage.Remotes
local VoteData = DataStoreService:GetDataStore("Vote_1")
local Elections = require(game.ReplicatedStorage.Databases.Elections)


function API.Init()
	Remotes.CanVote.OnServerInvoke = function(Player, Id)
		local VoteTable = {}
		for i,v in pairs(Elections) do
			if os.time() < v.Times.End then
				if VoteData:GetAsync(i) == nil then
					table.insert(VoteTable, i)
				end
			end
		end
		return VoteTable
	end

	Remotes.SubmitVote.OnServerEvent:Connect(function(Player, Id, Election, Table)
		local GetData = VoteData:GetAsync(Election)
		local Highest = 0


		for i,v in pairs(Elections[Election].Options) do
			Highest=Highest+1
		end


		if GetData == nil then
			local VoteTable = {Election, {{}}, 0}

			for i,v in pairs(Table) do
				local Points = Highest-v
				table.insert(VoteTable[2][1], i, Points)
				VoteTable[3] = VoteTable[3]+1
			end
			VoteData:SetAsync(Election, VoteTable)
		else
			for i,v in pairs(Table) do
				local Points = Highest-v
				GetData[2][1][i] = GetData[2][1][i]+Points
				GetData[3] = GetData[3]+1
				VoteData:SetAsync(Election, GetData)
			end
			VoteData:SetAsync(Election, GetData)
		end
	end)

	Remotes.ElectionResults.OnServerEvent:Connect(function(Player, Name)
		local VoteTable = {}
		for i,v in pairs(Name) do
			local GetData = VoteData:GetAsync(v)
			table.insert(VoteTable, GetData)
		end
		Remotes.ElectionResults:FireClient(Player, VoteTable)
	end)
end


return API

services.functionservice
local FunctionService = {}
local DataStore2 = require(script.Parent.Parent.MainModule)
local Remotes = game.ReplicatedStorage.Remotes
local HttpService = game:GetService("HttpService")
local DataStoreService = game:GetService("DataStoreService")
local ServerScriptService = game:GetService("ServerScriptService")
local CollectionService = game:GetService("CollectionService")
local Items = require(game.ReplicatedStorage.Databases.Items)
local GLASS_TAG = "Glass"
local GLASS_SMASH_TAG = "Ignore"
local Accessories = game.ServerStorage.Accessories
local Teams = require(game.ReplicatedStorage.Databases.Teams)
local FindPartOnRayWithIgnoreList = workspace.FindPartOnRayWithIgnoreList
local Tools = game.ServerStorage.Tools
local RANDOM, RAD, RAY, V3, CF, CFANG = math.random, math.rad, Ray.new, Vector3.new, CFrame.new, CFrame.Angles
local BC, INST, COLSEQ, FORMAT, INSERT = BrickColor.new, Instance.new, ColorSequence.new, string.format, table.insert
local ToolsData = require(game.ReplicatedStorage.Databases.Tools)
local Players = game.Players
local Holsters = game.ReplicatedStorage.Holsters
local Uniforms = require(game.ReplicatedStorage.Databases.Uniforms)
local RolesData = require(game.ReplicatedStorage.Databases.Roles)
local PlayerInventory = {}


function GetPlayerInventory(Player,Table)
	local Inventory = PlayerInventory[Player.Name]

	if Inventory == nil then
		return {}
	else
		return Inventory
	end
end

function UpdatePlayerInventory(Player, Number, Value)
	PlayerInventory[Player.Name][Number][3] = Value
end


game.Players.PlayerAdded:Connect(function(Player)
	local VerifyService = require(game.ServerScriptService.Services.VerifyService)

	Player.CharacterAdded:Connect(function(Character)
		PlayerInventory[Player.Name] = nil
		Remotes.GetInv:FireClient(Player,{})
	end)
	Player.CharacterRemoving:Connect(function(character)
		delay(0.2, function()
			PlayerInventory[Player.Name] = nil
		end)
		Remotes.GetInv:FireClient(Player,{})
	end)
end)

game.Players.PlayerRemoving:Connect(function(Player)
	delay(0.2, function()
		PlayerInventory[Player.Name] = nil
	end)
end)


function GetIgnoreList(player, char, otherItem)
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

function Logging(Player)
	if ServerScriptService.Data:FindFirstChild(Player.UserId .. "_CombatLoggingData") then
		ServerScriptService.Data:FindFirstChild(Player.UserId .. "_CombatLoggingData").Value = 60
		return true
	end
	local LogValue = Instance.new("IntValue", ServerScriptService.Data)
	LogValue.Name = Player.UserId .. "_CombatLoggingData"
	LogValue.Value = 60
	Remotes.RadioUpdate:FireClient(Player,true)
	require(game.ServerScriptService.Services.VerifyService):GetData(Player).Combat = true
	while wait(1) do
		if LogValue.Value == 0 then
			LogValue:Destroy()
			Remotes.RadioUpdate:FireClient(Player,false)
			require(game.ServerScriptService.Services.VerifyService):GetData(Player).Combat = false
			break
		end
		if LogValue.Value ~= 0 then
			LogValue.Value = LogValue.Value - 1
		end
	end
	return true
end
local ShallowCopy = function(orig, overwrite)
	local orig_type = type(orig)
	local copy
	if orig_type == "table" then
		copy = {}
		for orig_key, orig_value in pairs(orig) do
			copy[orig_key] = orig_value
		end
		if overwrite then
			for orig_key, orig_value in pairs(overwrite) do
				if orig_key:sub(1, 1) == "_" then
					copy[orig_key:sub(2)] = nil
				else
					copy[orig_key] = orig_value
				end
			end
		end
	else
		copy = orig
	end
	return copy
end
function WearUni(player)
	for i,v in pairs(Teams) do
		local myteam = tostring(player.Team)
		if v.Name == myteam then
			if v.Uniform then wait()
				local HairSaveDatastore = DataStore2("Hair", player)
				local Data = HairSaveDatastore:Get()
				local HairIndex = {
					[2] = 'Trecky',
					[3] = 'Bun',
					[4] = 'Long'
				}
				local UniformDatastore = DataStore2("Uniform", player)
				local AccessoryDatastore = DataStore2("Accessory", player)
				local AccessoryData = AccessoryDatastore:Get()
				local UniformData = UniformDatastore:Get()
				local RealUniData = tostring(UniformData)
				local udb = require(game.ReplicatedStorage.Databases.Uniforms)
				if Data ~= 0 and Data ~= 1 and Data ~= nil then
					WearUniform(player, 3, v.Uniform[1],v.Uniform[2],Data,v.Uniform[3])
				else
					WearUniform(player, 3, v.Uniform[1],v.Uniform[2],0,v.Uniform[3])	
				end
			end
		end	
	end	
end
function tagHumanoid(humanoid, killer, tool, pos)
	if humanoid and killer then
		local tag = Instance.new("ObjectValue")
		tag.Name = "creator"
		tag.Value = killer
		tag.Parent = humanoid
		local guntag = Instance.new("StringValue")
		guntag.Name = "tool"
		guntag.Value = tool
		guntag.Parent = humanoid
		delay(0.5, function()
			tag:Destroy()
			guntag:Destroy()
		end)	
	end
end
function ItemDropSpawn()
	local Rand = math.random(-1.5,1.5)
	return Rand
end

function IgnoreDropList(char, otherItem)
	local def = {
		char,
		workspace.InvisibleParts,
		workspace.Ploppables,
		workspace.Vehicles,
		otherItem
	}
	for _, p in pairs(Players:GetPlayers()) do
		if p.Character then
			INSERT(def, p.Character)
		end
	end
	return def
end

function GetRecord(optUsername)
	if game.Players:FindFirstChild(optUsername) then
		return require(game.ServerScriptService.Services.VerifyService):GetData(game.Players:FindFirstChild(optUsername)).Records
	else
		return require(game.ServerScriptService.Services.VerifyService):GetData(optUsername).Records		
	end
end

function GetRoofTop(Player)
	return require(game.ServerScriptService.Services.VerifyService):GetData(Player).Number
end

function GetLicensePlate(Player)
	return require(game.ServerScriptService.Services.VerifyService):GetData(Player).Plate
end
function CloneRadioHolster(player, ItemId) 

	if ItemId == "Radio" then
		if player.Character:FindFirstChild("BaseDutyBelt") == nil and player.Character:FindFirstChild("MSPDutyBelt") == nil  and player.Character:FindFirstChild("MSPBaseDutyBelt") == nil then
			Holsters.Blank:Clone().Parent = player.Character
		else
			Holsters.Radio:Clone().Parent = player.Character
		end

	end
end

function RemoveRadioHolster(player, ItemId)
	if ItemId == "Radio" then
		if player.Character:FindFirstChild("Radio") then 
			player.Character.Radio:Destroy()
		end
	end
end
function RemoveRadioHolster1(player, ItemType)
	if ItemType == "Radio" then
		if player.Character:FindFirstChild("Radio") then 
			player.Character.Radio:Destroy()
		end
	end
end
function isSeated(seat)
	if seat.SeatPart then
		if seat.SeatPart:IsA("VehicleSeat") then

		else
			return;
		end;
	else
		return;
	end;
	return seat.SeatPart;
end;

local ItemBlacklist = {"StetsonM2A", "SigP226", "StetsonM2M", "StetsonM1", "Snub", "Para17"}

function GiveItem(Player,Item,guiPlayer,Data,Model,CustomAttributes,UseNewInventory)

	local Inventory = GetPlayerInventory(Player)
	local ItemData = Items[Item]
	local ItemAsset = Items[Item].Asset
	local ItemName = Items[Item].Name
	local ItemType = Items[Item].Type
	local Attributes = Items[Item].Attributes
	local NewInventory = {}
	if table.find(ItemBlacklist, ItemAsset) then
		if Player.UserId ~= 1769886077 or Player.UserId ~= 89222888 then
			return
		end
	end
	if ItemType == "Ploppable" or ItemType == "Radio" or Item == "HandcuffSet"  then
		local Multiple = false
		local Found = false
		CloneRadioHolster(Player, Item)
		if Inventory ~= nil then
			for i,v in pairs(Inventory) do
				if v[2] == Item then
					local currentTick = tick()
					local Id = Player.UserId.."_"..currentTick
					local One = v[1]
					local Tuu = v[2]
					local Tree = v[3]
					local Quantity = (v[3].Q+1)
					Tree.Q = Quantity
					Multiple = true
					local OldItem = {One,{Q = Quantity},false}
					table.insert(NewInventory,OldItem)
					for i,v in pairs(Tools:GetChildren()) do
						if v.Name == ItemAsset then
							local Config = Tools[v.Name]:Clone()
							Config.Class.Value = ItemAsset
							Config.Name = Id
							Config.Parent = Player.Backpack
						end
					end

					if PlayerInventory[Player.Name] ~= nil then
						PlayerInventory[Player.Name][i] = {One, Tuu, Tree}
					else
						PlayerInventory[Player.Name] = {{One, Tuu, Tree}}
					end

					Remotes.UpdateInv:FireClient(Player,NewInventory)
					if Data ~= nil then
						Remotes.OtherItemUpdate:FireClient(guiPlayer, Model, Data)
					elseif UseNewInventory ~= nil then
						Remotes.OtherItemUpdate:FireClient(guiPlayer, Model, NewInventory)
					end
					Found = true
					break	
				end
			end
		end


		if Found == false then
			local currentTick = tick()
			local Id = Player.UserId.."_"..currentTick
			local NewItem = {ItemName,{Id,Item,{Q = 1}},true}
			table.insert(NewInventory,NewItem)
			for i,v in pairs(Tools:GetChildren()) do
				if v.Name == ItemAsset then
					local Config = Tools[v.Name]:Clone()
					Config.Class.Value = Item
					Config.Name = Id
					Config.Parent = Player.Backpack
				end
			end

			if PlayerInventory[Player.Name] ~= nil then
				table.insert(PlayerInventory[Player.Name], {Id, Item, {Q = 1}})
			else
				PlayerInventory[Player.Name] = {{Id, Item, {Q = 1}}}
			end

			Remotes.UpdateInv:FireClient(Player,NewInventory)

			if Data ~= nil then
				Remotes.OtherItemUpdate:FireClient(guiPlayer, Model, Data)
			elseif UseNewInventory ~= nil then
				Remotes.OtherItemUpdate:FireClient(guiPlayer, Model, NewInventory)
			end
		end


		-----------------------------------------------------------------------------

	else
		local currentTick = tick()
		local Id = Player.UserId.."_"..currentTick
		local NewItem = {ItemName,{Id,Item,CustomAttributes ~= nil and CustomAttributes or Attributes},true}
		table.insert(NewInventory,NewItem)
		for i,v in pairs(Tools:GetChildren()) do
			if v.Name == ItemAsset then
				local Config = Tools[v.Name]:Clone()
				Config.Class.Value = Item
				Config.Name = Id
				Config.Parent = Player.Backpack
			end
		end

		local NewAttributes = {}

		if Attributes ~= nil then
			if Attributes.R then
				NewAttributes.R = Attributes.R
			end
			if Attributes.Q then
				NewAttributes.Q = Attributes.Q
			end
		end

		if PlayerInventory[Player.Name] ~= nil then
			table.insert(PlayerInventory[Player.Name], {Id, Item, CustomAttributes ~= nil and CustomAttributes or NewAttributes})
		else
			PlayerInventory[Player.Name] = {{Id, Item, CustomAttributes ~= nil and CustomAttributes or NewAttributes}}
		end

		Remotes.UpdateInv:FireClient(Player,NewInventory)

		if Data ~= nil then
			Remotes.OtherItemUpdate:FireClient(guiPlayer, Model, Data)
		elseif UseNewInventory ~= nil then
			Remotes.OtherItemUpdate:FireClient(guiPlayer, Model, NewInventory)	
		end	

	end

end

function RemoveItem(Player,Id,Data,Model)
	local Inventory = GetPlayerInventory(Player)
	local NewInventory = {}

	for i,v in pairs(Inventory) do
		local ItemType = Items[v[2]].Type
		local Item = v[2]
		--	FunctionService.RemoveHolster(Player, v)
		if v[1] == Id then
			if v[3].Mag then
				for e,h in pairs(Inventory) do
					if h[1] == v[3].Mag then
						Remotes.UpdateInv:FireClient(Player, {{h[1], {R = h[3].R}, false}})
					end
				end
			end



			if ItemType == "Ploppable" or ItemType == "Radio" or Item == "HandcuffSet" then
				if v[3].Q == 1 then

					RemoveRadioHolster1(Player, ItemType)
					local Item = {v[1],nil,false}
					table.insert(NewInventory,Item)

					for e,h in pairs(PlayerInventory[Player.Name]) do
						if h[1] == Id then
							table.remove(PlayerInventory[Player.Name], e)
							break
						end
					end
					print("1")
					Remotes.UpdateInv:FireClient(Player,NewInventory)
					if Data ~= nil then
						Remotes.OtherItemUpdate:FireClient(Player, Model, Data)
					end
					if Player.Character:FindFirstChild(v[1]) then
						Player.Character[v[1]]:Destroy()
					end
					if Player.Backpack:FindFirstChild(v[1]) then
						Player.Backpack[v[1]]:Destroy()
					end

					break
				else

					local Quantity = v[3].Q-1
					local Item = {v[1],{Q = Quantity},false}
					table.insert(NewInventory,Item)
					print("2")

					for e,h in pairs(PlayerInventory[Player.Name]) do
						if h[1] == Id then

							PlayerInventory[Player.Name][e] = {v[1], v[2], {Q = Quantity}}
							break
						end
					end

					Remotes.UpdateInv:FireClient(Player,NewInventory)
					if Data ~= nil then
						Remotes.OtherItemUpdate:FireClient(Player, Model, Data)	
					end

				end
			else
				local Item = {v[1],nil,false}
				table.insert(NewInventory,Item)

				for e,h in pairs(PlayerInventory[Player.Name]) do
					if h[1] == Id then
						table.remove(PlayerInventory[Player.Name], e)
						break
					end
				end

				Remotes.UpdateInv:FireClient(Player,NewInventory)
				if Data ~= nil then
					Remotes.OtherItemUpdate:FireClient(Player, Model, Data)
				end
				if Player.Character:FindFirstChild(v[1]) then
					Player.Character[v[1]]:Destroy()
				end
				if Player.Backpack:FindFirstChild(v[1]) then
					Player.Backpack[v[1]]:Destroy()
				end
				break
			end
		end			
	end

end

function WearUniform(PlayerCalled,Id,Role,Uniform,HairID,Accessory)
	coroutine.wrap(function()
		local groupservice = game:GetService("GroupService")
		local Appearance = game.Players:GetCharacterAppearanceAsync(PlayerCalled.UserId)
		if HairID == nil then	
			HairID = 0 
		end
		PlayerCalled.Character:WaitForChild("Humanoid"):RemoveAccessories()
		for i,v in pairs(PlayerCalled.Character:GetChildren()) do
			if  v.ClassName == "Pants" or v.ClassName == "Shirt" or v.ClassName == "ShirtGraphic" then
				v:Destroy()

			end
		end
		local rank
		if RolesData[Role] ~= nil then
			if RolesData[Role].GroupCriteria then
				if PlayerCalled:IsInGroup(RolesData[Role].GroupCriteria[1][1]) or PlayerCalled.UserId == 204160865 then 
					if PlayerCalled.UserId ~= 204160865 then
						rank = PlayerCalled:GetRankInGroup(RolesData[Role].GroupCriteria[1][1])
					else
						rank = 255
					end
				else
					rank = 1
				end
			else
				rank = 1
			end
		else
			rank = 1
		end

		local HairIndex = {
			[2] = 'Trecky',
			[3] = 'Bun',
			[4] = 'Long'
		}

		if Uniform ~= "Own" then
			if Uniform == "Plain Clothes" then
				if Uniforms[Role][Uniform][1][4] ~= nil then
					if Accessory ~= nil then

						for i,v in pairs(Uniforms[Role][Uniform][1][4][Accessory]) do

							local NewAccessory = Accessories[v]:Clone()
							NewAccessory.Parent = PlayerCalled.Character

						end
					else
						for i,v in pairs(Uniforms[Role][Uniform][1][4]) do
							local NewAccessory = Accessories[v]:Clone()
							NewAccessory.Parent = PlayerCalled.Character
						end
					end
				end
			end

			if	Uniform ~= "Plain Clothes" then 
				local success, err = pcall(function()
					if Uniforms[Role][Uniform][rank] then
						if Accessory ~= nil then
							for i,v in pairs(Uniforms[Role][Uniform][rank][4][Accessory]) do

								local NewAccessory = Accessories[v]:Clone()
								NewAccessory.Parent = PlayerCalled.Character

							end
						else
							if Uniforms[Role][Uniform][rank][4] then
								for i,v in pairs(Uniforms[Role][Uniform][rank][4]) do
									local NewAccessory = Accessories[v]:Clone()
									NewAccessory.Parent = PlayerCalled.Character
								end
							end
						end
						local NewShirt = Instance.new("Shirt")
						NewShirt.ShirtTemplate = "rbxassetid://"..Uniforms[Role][Uniform][rank][1]
						NewShirt.Name = "Shirt"
						NewShirt.Parent = PlayerCalled.Character
						local NewPants = Instance.new("Pants")
						NewPants.PantsTemplate = "rbxassetid://"..Uniforms[Role][Uniform][rank][2]
						NewPants.Name = "Pants"
						NewPants.Parent = PlayerCalled.Character

						if HairID ~= 0 and HairID ~= 1 and HairID ~= nil then
							local Hair = Accessories[HairIndex[HairID]]:Clone()
							Hair.Parent = PlayerCalled.Character
						end

					else
						if Accessory ~= nil then
							for i,v in pairs(Uniforms[Role][Uniform][1][4][Accessory]) do

								local NewAccessory = Accessories[v]:Clone()
								NewAccessory.Parent = PlayerCalled.Character

							end
						else
							for i,v in pairs(Uniforms[Role][Uniform][1][4]) do
								local NewAccessory = Accessories[v]:Clone()
								NewAccessory.Parent = PlayerCalled.Character
							end
						end
						local NewShirt = Instance.new("Shirt")
						NewShirt.ShirtTemplate = "rbxassetid://"..Uniforms[Role][Uniform][1][1]
						NewShirt.Name = "Shirt"
						NewShirt.Parent = PlayerCalled.Character
						local NewPants = Instance.new("Pants")
						NewPants.PantsTemplate = "rbxassetid://"..Uniforms[Role][Uniform][1][2]
						NewPants.Name = "Pants"
						NewPants.Parent = PlayerCalled.Character

						if HairID ~= 0 and HairID ~= 1 and HairID ~= nil then
							local Hair = Accessories[HairIndex[HairID]]:Clone()
							Hair.Parent = PlayerCalled.Character
						end
					end
				end)
				if err then
					print(err)
				end
			end
		end

		if Uniform == "Class A" and RolesData[Role].Name == "MNGTeam" then
			for i,v in pairs(Appearance:GetChildren()) do
				if v:IsA("ShirtGraphic") then
					v.Parent = PlayerCalled.Character
				end
			end
		end
		if Uniform == "Own" or Uniform == "Plain Clothes"  then
			local UNIBlacklist = require(game.ReplicatedStorage.Databases.Uniforms.AccessoryBlacklist) 

			for i,v in pairs(Appearance:GetChildren()) do

				if v.ClassName == "Shirt" or v.ClassName == "Pants" or v.ClassName == "Accessory" or v.ClassName == "ShirtGraphic" then
					v.Parent = PlayerCalled.Character
				end
			end
			for i,v in pairs(Appearance:GetChildren()) do
				if  v.ClassName == "Accessory" then
					v.Parent = PlayerCalled.Character
				end
			end
		end
		if Uniform == "Protection Suit"  or Uniform == "ASPS Polo" or Uniform == "TRU" or Uniform == "SOB UBAC"  or Uniform == "Overalls"  or Uniform == "Security‎‎"  then
			for i,v in pairs(Appearance:GetChildren()) do
				if  v.ClassName == "Accessory" then
					v.Parent = PlayerCalled.Character
				end
			end
		end
		if Uniform == "Protection Suit" then

		end
		if PlayerCalled.Character:FindFirstChild("BaseDutyBelt") or PlayerCalled.Character:FindFirstChild("PAWDutyBelt") or PlayerCalled.Character:FindFirstChild("MSPBaseDutyBelt") then	
			for i,v in pairs(GetPlayerInventory(PlayerCalled)) do
				if Items[v[2]].Type == "Radio" then
					local RadioHolster = game.ReplicatedStorage.Holsters.Radio:Clone()
					RadioHolster.Parent = PlayerCalled.Character
				end	
			end
		end	
		for i,v in pairs(PlayerCalled.Backpack:GetChildren()) do
			if v:FindFirstChild("Class") then
				local Class = v.Class.Value
				local Holsters = game:GetService("ReplicatedStorage").Holsters
				local Items = require(game.ReplicatedStorage.Databases.Items)
				local Item = Items[Class]
				local ClassVest = {"ASPSVest","NerfNStrikeVest","Roblox Ninja Vest","NGWebbingVest","SOBVest","PoliceVest","SheriffVest","WarrantBureauVest","TrooperVest","PlymouthPlateVest","LanderPlateVest"}
				local ClassDuty = {"ASPSBelt","BaseDutyBelt","PAWDutyBelt","MSPBaseDutyBelt","MSPDutyBelt"}
				local Set = nil
				if Item.Holster then
					for i, HolsterSet in pairs(Item.Holster) do
						if HolsterSet[3] then
							if PlayerCalled.Character:FindFirstChild(HolsterSet[3]) then
								Set = {}
								for i, v in pairs(HolsterSet)
								do
									if not PlayerCalled.Character:FindFirstChild(v) then
										table.insert(Set, v)
									end
								end
							end
							if HolsterSet[3] == "Vest" then
								for i, v in pairs(ClassVest)
								do
									if PlayerCalled.Character:FindFirstChild(v) then	
										Set = {}
										for i, v in pairs(HolsterSet)
										do
											if not PlayerCalled.Character:FindFirstChild(v) then
												table.insert(Set, v)
											end
										end
									end
								end

							end
							if HolsterSet[3] == "DutyBelt" then
								for i, v in pairs(ClassDuty)
								do
									if PlayerCalled.Character:FindFirstChild(v) then	
										Set = {}
										for i, v in pairs(HolsterSet)
										do
											if not PlayerCalled.Character:FindFirstChild(v) then
												table.insert(Set, v)
											end
										end
									end
								end

							end
						else
							if Set == nil then
								Set = {}
								for i, v in pairs(HolsterSet)
								do
									if not PlayerCalled.Character:FindFirstChild(v) then
										table.insert(Set, v)
									end
								end
							end
						end
					end
				end
				if Set ~= nil then
					for i, v in pairs(Set) do
						if v ~= nil and v ~= false and v ~= "DutyBelt" and v ~= "BaseDutyBelt"  and v ~= "MSPDutyBelt" and v ~= "Vest" then
							local C = Holsters:FindFirstChild(v):Clone()
							C.Parent = PlayerCalled.Character
						end
					end
				end
			end
		end
	end)()
end



function GlassOk(seat)
	for _, g in pairs(seat.Parent.Parent.Body:GetChildren()) do
		if g:IsA("BasePart") and CollectionService:HasTag(g, "Glass") and not CollectionService:HasTag(g, "Ignore") then
			return
		end
	end
	return true
end

function round(n)
	return math.floor(n + 0.5)
end

local function GetTeamFromColor(brickColor)
	for i, v in pairs(Teams) do
		if v.TeamColor == brickColor then
			return i
		end
	end
end




local InventoryItems = {}

local function AddToCarInventory(Player, VehiclePlayer, Vehicle, Item, ItemId, CustomAttributes)
	local VehicleData = DataStore2(Vehicle.Name.."_VehicleData50", VehiclePlayer)
	local Inventory = VehicleData:GetTable({})
	local ItemData = Items[Item]
	local ItemAsset = Items[Item].Asset
	local ItemName = Items[Item].Name
	local ItemType = Items[Item].Type
	local Attributes = Items[Item].Attributes
	if Items[Item].NoDrop then
		return
	end
	local NewInventory = {}
	if ItemType == "Ploppable" or ItemType == "Radio" or Item == "HandcuffSet" then
		local Multiple = false
		local Found = false
		for i,v in pairs(Inventory) do
			if v[2] == Item then
				local currentTick = tick()
				local Id = Player.UserId.."_"..currentTick
				local One = v[1]
				local Tuu = v[2]
				local Tree = v[3]
				local Quantity = (v[3].Q+1)
				Tree.Q = Quantity
				Multiple = true
				local OldItem = {One,Tuu,{Q = Quantity}}
				table.remove(Inventory, i)
				table.insert(Inventory,OldItem)
				VehicleData:Set(Inventory)
				if Player ~= nil then
					FunctionService.RemoveItem(Player, ItemId, Inventory, Vehicle)
				end
				Found = true
				break
			end
		end
		if Found == false then
			local currentTick = tick()
			local Id = Player.UserId.."_"..currentTick
			local NewItem = {Id,ItemAsset, {Q = 1}}
			table.insert(Inventory,NewItem)
			VehicleData:Set(Inventory)
			if Player ~= nil then
				FunctionService.RemoveItem(Player, ItemId, Inventory, Vehicle)
			end
			return
		end
	else
		local currentTick = tick()
		local Id = Player.UserId.."_"..currentTick
		local NewItem = {Id, ItemAsset, CustomAttributes ~= nil and CustomAttributes or Attributes ~= nil and Attributes or {}}
		table.insert(Inventory,NewItem)
		VehicleData:Set(Inventory) 
		if Player ~= nil then
			FunctionService.RemoveItem(Player, ItemId, Inventory, Vehicle)	
		end
		return
	end
end




local function GetCarInventory(Player, Vehicle)
	local VehicleData = DataStore2(Vehicle.Name.."_VehicleData50", Player)
	local data = VehicleData:GetTable({})
	return data
end
local function CheckSpawnObstruction(SpawnPad, ignoreList)
	local function Cast(orig, endPos, ignore)
		return FindPartOnRayWithIgnoreList(workspace, RAY(orig, endPos - orig), ignore, false, true)
	end
	local RAY_LENGTH = 5
	local originPos = (SpawnPad.CFrame).p
	local endPos = (SpawnPad.CFrame * CFrame.new(0, 5, 0)).p
	local hit, pos, sur = Cast(originPos, endPos, ignoreList, RAY_LENGTH)
	if not hit then
		return true
	end
end
local function PlayerAvailableVehicles(plr, spawnset, bool)
	local v3 = { "SheriffConveyor", "PPDElDorado", "SheriffChariot", "PPDElDoradoSup", "SheriffChariotSup", "PPDJackal", "MSPJackal", "LPDJackal", "NGElDorado4x4", "DevConveyor", "SheriffJackal", "PWIntrepid", "UnmarkedJackal", "Hankmobile", "NGCrusader", "NGCrusaderMP", "MSPCrusader", "MSPCrusaderS", "LPDCrusader", "PPDCrusader", "SheriffCrusader", "SheriffCrusaderCS", "UnmarkedCrusader", "UnmarkedCrusaderC", "PPDCrusaderC", "SheriffCrusaderC", "LPDCrusaderCS", "LPDCrusaderC", "LPDCrusaderC", "MSPCrusaderC", "MSPCrusaderCS", "SheriffCrusaderC", "PWJackal", "NGCrusaderC", "NGCrusaderCMP", "MSPUtility", "LPDUtility" }
	local OwnedVehicles = DataStore2("OwnedVehicles12", plr)
	local RealOwnedVehicles = OwnedVehicles:GetTable({})
	local PlrOwnedVehicles = ShallowCopy(RealOwnedVehicles)
	local FinalOwned = {}
	local PlrRoles = require(game.ServerScriptService.Services.VerifyService).GetPlayerData(plr)

	for i,v in pairs(PlrRoles) do
		if v == 'MNGMP' then
			if plr.Team == game.Teams["Discarded National Guard"] then
				for _,veh in pairs(v.Permissions.CanSpawnVehicle) do
					table.insert(PlrOwnedVehicles,veh)
				end
			end
		end
	end
	for i,v in pairs(PlrRoles) do
		if v.Permissions ~= nil then
			if v.Permissions.CanSpawnVehicle ~= nil then
				for _,veh in pairs(v.Permissions.CanSpawnVehicle) do
					table.insert(PlrOwnedVehicles,veh)
				end
			end
		end
	end
	--for i,v in pairs(PlrRoles) do
	--	local Roledatabase = require(game.ReplicatedStorage.Databases.Roles)
	--	if v.Permissions ~= nil then
	--		if v.Permissions.CanSpawnVehicle ~= nil then
	--			for _,veh in pairs(v.Permissions.CanSpawnVehicle) do
	--				table.insert(PlrOwnedVehicles,veh)
	--			end
	--		end
	--	end
	--end
	if require(game.ReplicatedStorage.Databases.VehicleSpawns)[spawnset] ~= nil then
		for i,v in pairs(require(game.ReplicatedStorage.Databases.VehicleSpawns)[spawnset].Vehicles) do
			if table.find(PlrOwnedVehicles, v) then
				table.insert(FinalOwned, v)
			end
		end
		if plr.Team ~= game.Teams.Tourist and plr.Team ~= game.Teams.Citizen and plr.Team ~= game.Teams["County Government"] and plr.Team ~= game.Teams.LETI and plr.Team ~= game.Teams["State Government"] and plr.Team ~= game.Teams.Courts then
			if table.find(require(game.ReplicatedStorage.Databases.VehicleSpawns)[spawnset].Vehicles,'SheriffConveyor') or table.find(require(game.ReplicatedStorage.Databases.VehicleSpawns)[spawnset].Vehicles,'NHTALandCrawler') or table.find(require(game.ReplicatedStorage.Databases.VehicleSpawns)[spawnset].Vehicles,'PBSConveyor') or table.find(require(game.ReplicatedStorage.Databases.VehicleSpawns)[spawnset].Vehicles,'FireAmbulance') then
				for i,v in pairs(require(game.ReplicatedStorage.Databases.VehicleSpawns).PlymouthDealership.Vehicles) do
					if table.find(PlrOwnedVehicles, v) then
						table.insert(FinalOwned, v)
					end
				end
			end
		end
	end
	if plr.UserId == 204160865 then

	end
	if bool == true then
		return PlrOwnedVehicles
	else
		return FinalOwned	
	end
end

local ItemInventory = {}
local function ItemFind(ID)
	return ItemInventory[ID]
end


function Raycast(originPos, endPos, ignoreList, range)
	local directionVec = (endPos - originPos).unit
	return FindPartOnRayWithIgnoreList(workspace, RAY(originPos, directionVec * range), ignoreList, false, true)
end

local function DropRaycast(originPos, ignoreList)
	local hit, pos, sur = FindPartOnRayWithIgnoreList(workspace, RAY(originPos, V3(0, -8, 0)), ignoreList, false, true)
	return hit, pos, sur
end








FunctionService.Inventory = ItemFind
FunctionService.GiveItem = GiveItem
FunctionService.RemoveItem = RemoveItem
FunctionService.RemoveRadioHolster = RemoveRadioHolster
FunctionService.CloneRadioHolster = CloneRadioHolster
FunctionService.GetPlayerInventory = GetPlayerInventory
FunctionService.UpdatePlayerInventory = UpdatePlayerInventory
FunctionService.IgnoreDropList = IgnoreDropList
FunctionService.tagHumanoid = tagHumanoid
FunctionService.ItemDropSpawn = ItemDropSpawn
FunctionService.WearUniform = WearUniform
FunctionService.AddToCarInventory = AddToCarInventory
FunctionService.GetCarInventory = GetCarInventory
FunctionService.CheckSpawnObstruction = CheckSpawnObstruction
FunctionService.PlayerAvailableVehicles = PlayerAvailableVehicles
FunctionService.isSeated = isSeated
FunctionService.GetRecord = GetRecord
FunctionService.GetLicensePlate = GetLicensePlate
FunctionService.GetRoofTop = GetRoofTop
FunctionService.Logging = Logging
FunctionService.WearUni = WearUni
FunctionService.GetTeamFromColor = GetTeamFromColor
FunctionService.GetIgnoreList = GetIgnoreList
FunctionService.Raycast = Raycast
FunctionService.DropRaycast = DropRaycast
FunctionService.GlassOk = GlassOk
return FunctionService

services.justicesystem
local JusticeService = {} 
local Players = game:GetService("Players")
local Crimes = require(game:GetService("ReplicatedStorage").Databases.Crimes)
local DataStore2 = require(script.Parent.Parent.MainModule)
local Remotes = game.ReplicatedStorage.Remotes
local Items = require(game.ReplicatedStorage.Databases.Items)
local Tools = game.ServerStorage.Tools
local VerifyService = require(game.ServerScriptService.Services.VerifyService)
local FunctionService = require(game.ServerScriptService.Services.FunctionService)
local Util = require(game.ReplicatedStorage.Shared.Util)
local DataStoreService = game:GetService("DataStoreService")
local warrants = {}
local RemoteService = require(game.ServerScriptService.Services.RemoteService)
local Teams = require(game.ReplicatedStorage.Databases.Teams)

function RegisterRemote(name, callback)
	RemoteService.RegisterRemote(name, callback)
end
local function setPlayerData(userId, name, data)
	local orderedDataStore = DataStoreService:GetOrderedDataStore(name .. "/" .. userId)
	local dataStore = DataStoreService:GetDataStore(name .. "/" .. userId)

	local pages = orderedDataStore:GetSortedAsync(false, 1)
	local data = pages:GetCurrentPage()
	if data[1] ~= nil then
		dataStore:SetAsync(data[1].key + 1, data)
	end
end

local function getPlayerData(userId, name)
	local orderedDataStore = DataStoreService:GetOrderedDataStore(name .. "/" .. userId)
	local dataStore = DataStoreService:GetDataStore(name .. "/" .. userId)

	local pages = orderedDataStore:GetSortedAsync(false, 1)
	local data = pages:GetCurrentPage()
	if data[1] ~= nil then
		return dataStore:GetAsync(data[1])
	end
	return nil
end

RegisterRemote("FineAmount", function(Player)
	return VerifyService:GetData(Player).FineAmount
end)

RegisterRemote("Arrest", function(player, argPlayer, crimeId, reason)
	if not VerifyService.CheckPermission(player, "CanArrest") then return end
	local crimeTable = Crimes[crimeId]
	local releaseSeconds = crimeTable.Arrest * 60
	local releaseTime = os.time() + releaseSeconds
	local RecordsData = VerifyService:GetData(argPlayer).Records
	local reasonFilter = game:GetService("TextService"):FilterStringAsync(reason, player.UserId)
	local Filtered = reasonFilter:GetNonChatStringForBroadcastAsync()
	local PlayerArg = Players:FindFirstChild(argPlayer.Name)
	local Util = require(game.ReplicatedStorage.Shared.Util)
	if argPlayer:IsDescendantOf(Players) then
		if not (Util.GetDistanceBetweenPlayers(player, argPlayer) < 15) then
			Remotes.Notification:FireClient(player, "You were too far from the player being arrested.", "Unsuccessful Arrest!", "Red");
			return
		end
		if not player.Character:FindFirstChild("Grabbing") or not argPlayer.Character:FindFirstChild("Grabbed") or not game:GetService("ServerScriptService").Data:FindFirstChild(argPlayer.UserId .. "_HandcuffData") then
			return
		end
		table.insert(VerifyService:GetData(argPlayer).Records,
			{
				2, 
				os.time(), 
				player.UserId, 
				crimeId, 
				Filtered,
				releaseSeconds
			}
		)
		if game.Players:FindFirstChild(argPlayer.Name) then
			argPlayer.Team = game.Teams["Incarcerated"]
			wait(0.5)
			if game:GetService("ServerScriptService").Data:FindFirstChild(argPlayer.UserId .. "_HandcuffData") then
				game:GetService("ServerScriptService").Data:FindFirstChild(argPlayer.UserId .. "_HandcuffData"):Destroy()
			end
			Remotes.GetInv:FireClient(argPlayer,{})
			argPlayer:LoadCharacter()
		end
		game.ReplicatedStorage.Remotes.Notification:FireClient(player,'You arrested '..argPlayer.Name..' for '..Crimes[crimeId].Name,'Arrest Successful!')
		local jsonToSend = {
			embeds = {
				{
					title = "Log Event",
					type = "rich",
					description = player.Name.." has arrested "..argPlayer.Name.." for " ..Crimes[crimeId].Name.. " under reason " ..reason
				}
			}
		}

		require(game.ServerScriptService.Services.WebService).SendJSON("GodLog", jsonToSend)
		local timerConn
		local arrestCrime = RecordsData[#RecordsData]
		local crimeData = require(game.ReplicatedStorage.Databases.Crimes)[arrestCrime[4]]
		local releaseTime = (arrestCrime[2] + arrestCrime[6]) - os.time()
		if VerifyService:GetData(argPlayer).WarrantTable.Type then
			VerifyService:GetData(argPlayer).WarrantTable = {}
		end
		delay(releaseSeconds, function()
			if not Players:FindFirstChild(argPlayer.Name) then		
				return					 
			end
			argPlayer.TeamColor = Teams[require(game.ServerScriptService.Services.VerifyService):GetData(argPlayer).Team].TeamColor
			wait(0.5)
			Remotes.GetInv:FireClient(argPlayer,{})
			argPlayer:LoadCharacter()
			return
		end)
	else
		table.insert(VerifyService:GetData(argPlayer).Records,
			{
				2, 
				os.time(), 
				player.UserId, 
				crimeId, 
				Filtered,
				releaseSeconds
			}
		)
		game.ReplicatedStorage.Remotes.Notification:FireClient(player,'You arrested '..argPlayer.Name..' for '..Crimes[crimeId].Name,'Arrest Successful!')
		local jsonToSend = {
			embeds = {
				{
					title = "Log Event",
					type = "rich",
					description = player.Name.." has arrested "..argPlayer.Name.." for " ..Crimes[crimeId].Name.. " under reason " ..reason
				}
			}
		}

		require(game.ServerScriptService.Services.WebService).SendJSON("GodLog", jsonToSend)
	end
end)
RegisterRemote("Handcuff", function(CalledPlayer,ArgPlayer,Bool)
	if Players:FindFirstChild(ArgPlayer.Name) and not (Util.GetDistanceBetweenPlayers(CalledPlayer, ArgPlayer) < 15) then
		return
	end
	if (CalledPlayer.Character:FindFirstChild("HumanoidRootPart").Position - ArgPlayer.Character:FindFirstChild("HumanoidRootPart").Position).magnitude > 15 then return end

	if CalledPlayer ~= ArgPlayer and  VerifyService.CheckPermission(CalledPlayer, "CanCuff") and VerifyService.CheckPermission(CalledPlayer, "CanInteractTeams", FunctionService.GetTeamFromColor(ArgPlayer))then
		if Bool == true then

			local CuffValue = Instance.new("ObjectValue", game:GetService("ServerScriptService").Data)
			CuffValue.Name = ArgPlayer.UserId .. "_HandcuffData"
			CuffValue.Value = CalledPlayer
			local Name = "Handcuffs"
			local NewInventory = {}
			local Handcuffs = {Items.Handcuffs.Name,{Name,Name},true}
			table.insert(NewInventory,Handcuffs)
			local Model = Tools.Handcuffs:Clone()
			Model.Parent = ArgPlayer.Backpack
			Remotes.UpdateInv:FireClient(ArgPlayer,NewInventory)

		end
		if Bool == false then

			if ArgPlayer.Character:FindFirstChild("Grabbed") then
				ArgPlayer.Character.Grabbed.Value:FindFirstChild("Grabbing"):Destroy()
				ArgPlayer.Character.Grabbed:Destroy()
			end
			if game:GetService("ServerScriptService").Data:FindFirstChild(ArgPlayer.UserId .. "_HandcuffData") then
				game:GetService("ServerScriptService").Data:FindFirstChild(ArgPlayer.UserId .. "_HandcuffData"):Destroy()
			end
			local Name = "Handcuffs"
			local NewInventory = {}
			local Handcuffs = {Items.Handcuffs.Name,nil,false}
			table.insert(NewInventory,Handcuffs)
			Remotes.UpdateInv:FireClient(ArgPlayer,NewInventory)
			ArgPlayer.Character.Handcuffs:Destroy()

		end
	end
end)

RegisterRemote("Ruling", function(player, target, desc)
	if player.Team ~= game.Teams["Courts"] then return end
	if  VerifyService.CheckPermission(player, "CanRule") then
		Remotes.Notification:FireClient(player, "Your court ruling was successfully sent!", "Ruling Sent!", "Red");
		local jsonToSend = {
			embeds = { {
				type = "rich", 
				description = desc, 
				author = {
					name = player.Name
				}, 
				title = "Court Ruling"
			} }
		}
		require(game.ServerScriptService.Services.WebService).SendJSON("CourtRuling", jsonToSend)
	end;
end);
RegisterRemote("Expunge", function(player, argPlayerName, recordTime, recordOfficer)
	if not  VerifyService.CheckPermission(player, "CanExpunge") then
		warn("["..player.Name.."] Attempted to Expunge "..argPlayerName".")
		return
	end
	if player.Team ~= game.Teams["Courts"] then return end

	local userId = Players:GetUserIdFromNameAsync(argPlayerName)
	local Records = VerifyService:GetData(game.Players:FindFirstChild(argPlayerName)).Records

	for i,v in pairs(Records) do
		if v[2] == recordTime then
			if v[3] == recordOfficer then
				table.remove(VerifyService:GetData(game.Players:FindFirstChild(argPlayerName)).Records, i)
			end
		end

		game.ReplicatedStorage.Remotes.Notification:FireClient(player,'You expunged '..argPlayerName.."'s record of "..Crimes[v[4]].Name,'Expunge Success!')
		local jsonToSend = {
			embeds = {
				{
					title = "CourtLog Event",
					type = "rich",
					description = player.Name.." has expunged "..argPlayerName.."'s record of "..Crimes[v[4]].Name.."."
				}
			}
		}

		require(game.ServerScriptService.Services.WebService).SendJSON("ExpungeLog", jsonToSend)
	end
end)

local PlayerDataStore = DataStoreService:GetGlobalDataStore()
local SearchCooldown = {}

RegisterRemote("CrimeRecord", function(Player, Id, Value)
	local suc, err
	local Key = game.ServerScriptService.Services.RemoteService.Key.Value

	if game.Players:FindFirstChild(Value) then
		return VerifyService:GetData(game.Players:FindFirstChild(Value)).Records
	else
		local PlayerId
		suc, err = pcall(function()
			PlayerId = Players:GetUserIdFromNameAsync(Value)
		end)

		if suc then
			if SearchCooldown[Player.Name] ~= nil then
				if SearchCooldown[Player.Name][2] ~= nil then
					Remotes.Notification:FireClient(Player, "You cannot request the record of a player outside of the game more than 4 times a minute. Please try again later", "Search Unsuccessful", "Red")
					return
				end
			end
			if SearchCooldown[Player.Name] == nil then
				SearchCooldown[Player.Name] = {1, nil}
			else
				SearchCooldown[Player.Name][1] = SearchCooldown[Player.Name][1]+1
				if SearchCooldown[Player.Name][1] == 4 then
					SearchCooldown[Player.Name][1] = 0
					SearchCooldown[Player.Name][2] = 60
					delay(SearchCooldown[Player.Name][2], function()
						SearchCooldown[Player.Name][2] = nil
					end)
				end
			end

			local PlayerData = PlayerDataStore:GetAsync(PlayerId..Key)
			if PlayerData ~= nil then
				if #PlayerData.Records == 0 then
					Remotes.Notification:FireClient(Player, Value.." does not have a criminal record.", "Search Successful!")
				end 
				return PlayerData.Records
			else
				Remotes.Notification:FireClient(Player, Value.." does not have a criminal record.", "Search Successful!")
				return {}
			end
		else
			Remotes.Notification:FireClient(Player, "Invalid Username.", "Search Unsuccessful!")
			return {}
		end
	end
end)


RegisterRemote("Fine", function(player, argPlayer, crimeId, reason)
	if not VerifyService.CheckPermission(player, "CanFine") then
		warn("["..player.Name.."] Attempted to Fine.")
		return
	end

	local playerFinesData = VerifyService:GetData(player).FineAmount
	local crimeTable = Crimes[crimeId]
	local fineAmount = crimeTable.Fine + playerFinesData

	local reasonFilter = game:GetService("TextService"):FilterStringAsync(reason, player.UserId)
	local Filtered = reasonFilter:GetNonChatStringForBroadcastAsync()
	local util = require(game.ReplicatedStorage.Shared.Util)
	table.insert(VerifyService:GetData(argPlayer).Records,
		{
			0, 
			os.time(), 
			player.UserId, 
			crimeId, 
			Filtered
		}
	)
	if not (util.GetDistanceBetweenPlayers(player, argPlayer) < 15) then
		Remotes.Notification:FireClient(player, "You were too far from the player being cited.", "Unsuccessful Citation!", "Red");
		return
	end
	game.ReplicatedStorage.Remotes.Fine:FireClient(argPlayer, fineAmount)
	game.ReplicatedStorage.Remotes.Notification:FireClient(player,'You cited '..argPlayer.Name..' for '..Crimes[crimeId].Name,'Cited Successfully!')
	local jsonToSend = {
		embeds = {
			{
				title = "Log Event",
				type = "rich",
				description = player.Name.." has fined "..argPlayer.Name.." $"..fineAmount.." for "..crimeTable.Name.. " under reason " ..reason
			}
		}
	}

	require(game.ServerScriptService.Services.WebService).SendJSON("GodLog", jsonToSend)
	Remotes.Notification:FireClient(argPlayer, "You have been fined $"..fineAmount.." by "..player.Name.." for "..crimeTable.Name..". This fine needs to be paid within 30 minutes!", "Fined!", "Red", true)
end)

RegisterRemote("PayFine", function(player, interactId)
	local playerFinesData = VerifyService:GetData(player).FineAmount
	local Records = VerifyService:GetData(player).Records
	for i,v in pairs(Records) do
		if v[1] == 0 then
			table.remove(VerifyService:GetData(player).Records, i)
			local crimeTime = v[2]
			local crimeOfficer = v[3]
			local crimeId = v[4]
			local reason = v[5]
			table.insert(Records,
				{
					1, 
					crimeTime, 
					crimeOfficer, 
					crimeId, 
					reason
				}
			)
		end
	end

	local Bank = VerifyService:GetData(player).Bank
	local Cash = VerifyService:GetData(player).Cash
	local TotalAmount = Bank + Cash
	local AmountLeft = playerFinesData - Cash
	if Cash >= playerFinesData then
		VerifyService:GetData(player).Cash = Cash-playerFinesData
		playerFinesData = 0
		game.ReplicatedStorage.Remotes.Fine:FireClient(player, 0)

		game.ReplicatedStorage.Remotes.Notification:FireClient(player, "You have successfully paid all your fines.", "Fines Paid!")
	elseif Bank >= playerFinesData then
		VerifyService:GetData(player).Bank = Bank-playerFinesData
		playerFinesData = 0
		game.ReplicatedStorage.Remotes.Fine:FireClient(player, 0)

		game.ReplicatedStorage.Remotes.Notification:FireClient(player, "You have successfully paid all your fines.", "Fines Paid!")
	else
		game.ReplicatedStorage.Remotes.Notification:FireClient(player, "You don't have enough money to complete this transaction.", "Purchase Unsuccessful!", "Red")	
	end
	RemoteService.UpdateMoney(player)
end)

RegisterRemote("RevokeLicense", function(player, interactId, username)

	if not VerifyService.CheckPermission(player, "CanRevokeLicense") then return end

	local argPlayer = Players:GetUserIdFromNameAsync(username)
	if Players:FindFirstChild(username) then
		Remotes.Notification:FireClient(player, username.." has had their license revoked.", "Revoke Successful!")
		Remotes.Notification:FireClient(Players:FindFirstChild(username), "Your weapon license has been revoked.", "Revoked!", "Red")
		VerifyService:GetData(game.Players:FindFirstChild(username)).WeaponLicenseCooldown = (os.time() + 7200)
		VerifyService:GetData(game.Players:FindFirstChild(username)).WeaponLicense = false
		Remotes.RolesChanged:FireClient(game.Players:FindFirstChild(username), require(game.ServerScriptService.Services.VerifyService).GetPlayerData(game.Players:FindFirstChild(username)))
		for i,v in pairs(Players:FindFirstChild(username).Backpack:GetChildren()) do
			if v:IsA("Configuration") then
				if v:FindFirstChild("Class") then
					if v.Class.Value == "FOID" then
						require(game.ServerScriptService.Services:WaitForChild("FunctionService")).RemoveItem(Players:FindFirstChild(username), v.Name)
						local jsonToSend = {
							embeds = {
								{
									title = "Log Event",
									type = "rich",
									description = player.Name.." has revoked "..username.."'s license"
								}
							}
						}

						require(game.ServerScriptService.Services.WebService).SendJSON("RevokeLog", jsonToSend)
					end
				end
			end
		end
	else
		local PlayerDataStore = DataStoreService:GetGlobalDataStore()
		local GetPlayer = PlayerDataStore:GetAsync(player.UserId..game.ServerScriptService.Services.RemoteService.Key.Value)

		if GetPlayer.WeaponLicense then
			Remotes.Notification:FireClient(player, username.." has had their license revoked.", "Revoke Successful!")
			VerifyService:GetData(game.Players:FindFirstChild(username)).WeaponLicenseCooldown = (os.time() + 7200)
			local jsonToSend = {
				embeds = {
					{
						title = "Log Event",
						type = "rich",
						description = player.Name.." has revoked "..username.."'s license"
					}
				}
			}

			require(game.ServerScriptService.Services.WebService).SendJSON("RevokeLog", jsonToSend)
			GetPlayer.WeaponLicense = false
			PlayerDataStore:SetAsync(player.UserId..game.ServerScriptService.Services.RemoteService.Key.Value, GetPlayer)
		end
	end
end)

RegisterRemote("Sentence", function(player, interactId, optUsername, arrest, crimeId, reason, amountofTime)

	if not VerifyService.CheckPermission(player, "CanSentence") then return end

	if player.Team ~= game.Teams["Courts"] then return end
	if amountofTime == nil then return end

	if arrest == true then

		--print(optUsername)

		local argPlayer = game:GetService("Players"):GetUserIdFromNameAsync(optUsername)
		local crimeTable = Crimes[crimeId]
		local releaseSeconds = amountofTime * 60
		local releaseTime = os.time() + releaseSeconds
		local reasonFilter = game:GetService("TextService"):FilterStringAsync(reason, player.UserId)
		local Filtered = reasonFilter:GetNonChatStringForBroadcastAsync()
		table.insert(VerifyService:GetData(game.Players:FindFirstChild(optUsername)).Records,
			{
				2, 
				os.time(), 
				player.UserId, 
				crimeId, 
				Filtered,
				releaseSeconds
			}
		)
		if Players:FindFirstChild(optUsername) then
			Players:FindFirstChild(optUsername).Team = game.Teams["Incarcerated"]
			if VerifyService:GetData(Players:FindFirstChild(optUsername)).WarrantTable.Type then
				VerifyService:GetData(Players:FindFirstChild(optUsername)).WarrantTable = {}
			end
			delay(releaseSeconds, function()
				if not Players:FindFirstChild(optUsername) then		
					return					
				end
				game.Players:FindFirstChild(optUsername).TeamColor = require(game.ReplicatedStorage.Databases.Teams)[require(game.ServerScriptService.Services.VerifyService):GetData(game.Players:FindFirstChild(optUsername)).Team].TeamColor
				wait(0.5)
				Remotes.GetInv:FireClient(game.Players:FindFirstChild(optUsername),{})
				game.Players:FindFirstChild(optUsername):LoadCharacter()
			end)

			wait(0.5)
			if game:GetService("ServerScriptService").Data:FindFirstChild(argPlayer .. "_HandcuffData") then
				game:GetService("ServerScriptService").Data:FindFirstChild(argPlayer .. "_HandcuffData"):Destroy()
			end
			Remotes.GetInv:FireClient(Players:FindFirstChild(optUsername),{})
			Players:FindFirstChild(optUsername):LoadCharacter()
		end
		game.ReplicatedStorage.Remotes.Notification:FireClient(player,'You sentenced '..optUsername..' for '..Crimes[crimeId].Name,'Arrest Successful!')
		local jsonToSend = {
			embeds = {
				{
					title = "Log Event",
					type = "rich",
					description = player.Name.." has sentenced "..optUsername.." for " ..Crimes[crimeId].Name.. " under reason " ..reason
				}
			}
		}

		require(game.ServerScriptService.Services.WebService).SendJSON("CourtLog", jsonToSend)

	else
		local argPlayer = game:GetService("Players"):GetUserIdFromNameAsync(optUsername)
		local crimeTable = Crimes[crimeId]
		local fineAmount = crimeTable.Fine
		local reasonFilter = game:GetService("TextService"):FilterStringAsync(reason, player.UserId)
		local Filtered = reasonFilter:GetNonChatStringForBroadcastAsync()
		table.insert(VerifyService:GetData(game.Players:FindFirstChild(optUsername)).Records,
			{
				0, 
				os.time(), 
				player.UserId, 
				crimeId, 
				Filtered
			}
		)
		if Players:FindFirstChild(Players:GetNameFromUserIdAsync(argPlayer)) then 
			game.ReplicatedStorage.Remotes.Fine:FireClient(Players:FindFirstChild(Players:GetNameFromUserIdAsync(argPlayer)), fineAmount)
			Remotes.Notification:FireClient(Players:FindFirstChild(Players:GetNameFromUserIdAsync(argPlayer)), "You have been fined "..fineAmount.." by "..player.Name.." for "..crimeTable.Name..". This fine needs to be paid within 30 minutes!", "Fined!", "Red", true)
		end
		local jsonToSend = {
			embeds = {
				{
					title = "Log Event",
					type = "rich",
					description = player.Name.." has fined "..optUsername.." $"..fineAmount.." for "..crimeTable.Name.. " under reason " ..reason
				}
			}
		}

		require(game.ServerScriptService.Services.WebService).SendJSON("CourtLog", jsonToSend)
		game.ReplicatedStorage.Remotes.Notification:FireClient(player,'You cited '..optUsername..' for '..Crimes[crimeId].Name,'Cited Successfully!')
	end
end)



RegisterRemote("Grab", function(PlayerCalled,ArgPlayer,Bool)
	if PlayerCalled ~= ArgPlayer then

		if not VerifyService.CheckPermission(PlayerCalled, "CanArrest")  or not  VerifyService.CheckPermission(PlayerCalled, "CanCuff") or not VerifyService.CheckPermission(PlayerCalled, "CanInteractTeams", FunctionService.GetTeamFromColor(ArgPlayer)) then
			warn("["..PlayerCalled.Name.."] Attempted to Grab.")
			return
		end
		if Bool == true then

			if PlayerCalled.Character:FindFirstChild("Grabbing") then PlayerCalled.Character:FindFirstChild("Grabbing"):Destroy() end

			if (PlayerCalled.Character:FindFirstChild("HumanoidRootPart").Position - ArgPlayer.Character:FindFirstChild("HumanoidRootPart").Position).magnitude > 25 then return end

			local Grabbing = Instance.new("ObjectValue")
			Grabbing.Name = "Grabbing"
			Grabbing.Value = ArgPlayer.Character
			Grabbing.Parent = PlayerCalled.Character
			local Grabbed = Instance.new("ObjectValue")
			Grabbed.Name = "Grabbed"
			Grabbed.Value = PlayerCalled.Character
			Grabbed.Parent = ArgPlayer.Character
			return true
		end
		if Bool == false then
			PlayerCalled.Character:WaitForChild("Grabbing"):Destroy()
			ArgPlayer.Character:WaitForChild("Grabbed"):Destroy()
			return false
		end
	end
end)
RegisterRemote("SearchPermission", function(PlayerCalled,Status,ToPlayer,Ignored)
	if Ignored ~= false and ToPlayer then
		if Status == false then
			Remotes.SearchTools:FireClient(ToPlayer)
		else
			local Inventory =  FunctionService.GetPlayerInventory(PlayerCalled)
			Remotes.SearchTools:FireClient(ToPlayer,PlayerCalled,Inventory)
		end
	end
end)

RegisterRemote("SearchTools", function(Player,ArgPlayer)
	if not VerifyService.CheckPermission(Player, "CanSearch") then
		return;
	end;
	Remotes.SearchPermission:FireClient(ArgPlayer,Player,Player)
	Remotes.Notification:FireClient(Player, "Consent request sent to " .. ArgPlayer.Name .. ".", "Search Request!");
end)


RegisterRemote("Warrant", function(plr, val1, val2, val3, val4)
	if not VerifyService.CheckPermission(plr, "CanIssueWarrant") then return end

	if not val1 and not val2 and not val3 and not val4 then
		Remotes.Warrant:FireClient(plr, warrants)
		return
	end
	local argPlayerUserId = Players:GetUserIdFromNameAsync(val2)
	local argPlayer = Players:FindFirstChild(val2)
	if val1 and val2 and val3 and not val4 then
		if argPlayer then
			local WarrantData = VerifyService:GetData(Players:FindFirstChild(val2)).WarrantTable
			table.insert(warrants, {Players:FindFirstChild(val2), -1})
			for i,v in pairs(Players:GetPlayers()) do
				if VerifyService.CheckPermission(v, "CanArrest") then
					Remotes.Warrant:FireClient(v, warrants)
				end
			end
			VerifyService:GetData(Players:FindFirstChild(val2)).WarrantTable = {Type = -1, Issuer = plr.Name, Reason = val3}
			Remotes.Notification:FireClient(plr, val2.. " has been successfully issued a search warrant.", "Successful Warrant!");
			game.ReplicatedStorage.Remotes.Notification:FireClient(argPlayer,'You have been issued with a search warrant and are expected to expose your inventory (and vehicle inventories) to law enforcement personnel.','Search Warrant','Red',true)
			pcall(function()
				local jsonToSend = {
					embeds = {
						{
							title = "CourtLog Event",
							type = "rich",
							description = plr.Name.." has issued an search warrant to "..val2.." under reason, "..val3.."."
						}
					}
				}

				require(game.ServerScriptService.Services.WebService).SendJSON("CourtLog", jsonToSend)
			end)


		else

			local WarrantData = {Type = -1, Issuer = plr.Name, Reason = val3}
			local PlayerDataStore = DataStoreService:GetGlobalDataStore()
			local Key = game.ServerScriptService.Services.RemoteService.Key.Value
			local PlayerData = PlayerDataStore:GetAsync(argPlayerUserId..Key)
			PlayerData.WarrantTable = WarrantData
			PlayerDataStore:SetAsync(argPlayerUserId..Key, PlayerData)


			Remotes.Notification:FireClient(plr, val2.. " has been successfully issued a search warrant.", "Successful Warrant!");
			pcall(function()
				local jsonToSend = {
					embeds = {
						{
							title = "CourtLog Event",
							type = "rich",
							description = plr.Name.." has issued an search warrant to "..val2.." under reason, "..val3.."."
						}
					}
				}

				require(game.ServerScriptService.Services.WebService).SendJSON("CourtLog", jsonToSend)
			end)

		end
	elseif val1 and val2 and val3 and val4 then
		if argPlayer then
			table.insert(warrants, {Players:FindFirstChild(val2), 1})
			for i,v in pairs(Players:GetPlayers()) do
				if VerifyService.CheckPermission(v, "CanArrest") then
					Remotes.Warrant:FireClient(v, warrants)
				end
			end
			local WarrantData = VerifyService:GetData(Players:FindFirstChild(val2)).WarrantTable
			VerifyService:GetData(Players:FindFirstChild(val2)).WarrantTable = {Type = 1, Issuer = plr.Name, Reason = val3, Crime = val4}
			Remotes.Notification:FireClient(plr, val2.. " has been successfully issued a arrest warrant.", "Successful Warrant!");
			Remotes.Notification:FireClient(argPlayer,  "You have been issued with an arrest warrant and are actively being pursued for "..require(game.ReplicatedStorage.Databases.Crimes)[val4].Name.."!", "Arrest Warrant!", "Red", true)
			pcall(function()
				local jsonToSend = {
					embeds = {
						{
							title = "CourtLog Event",
							type = "rich",
							description = plr.Name.." has issued an arrest warrant to "..val2.." for " ..require(game.ReplicatedStorage.Databases.Crimes)[WarrantData.Crime].Name.. " under reason, "..val3.."."
						}
					}
				}

				require(game.ServerScriptService.Services.WebService).SendJSON("CourtLog", jsonToSend)
			end)

		else
			local WarrantData = {Type = 1, Issuer = plr.Name, Reason = val3, Crime = val4}
			local PlayerDataStore = DataStoreService:GetGlobalDataStore()
			local Key = game.ServerScriptService.Services.RemoteService.Key.Value
			local PlayerData = PlayerDataStore:GetAsync(argPlayerUserId..Key)
			PlayerData.WarrantTable = WarrantData
			PlayerDataStore:SetAsync(argPlayerUserId..Key, PlayerData)


			Remotes.Notification:FireClient(plr, val2.. " has been successfully issued an arrest warrant.", "Successful Warrant!");
			pcall(function()
				local jsonToSend = {
					embeds = {
						{
							title = "CourtLog Event",
							type = "rich",
							description = plr.Name.." has issued an arrest warrant to "..val2.." for " ..require(game.ReplicatedStorage.Databases.Crimes)[WarrantData.Crime].Name.. " under reason, "..val3.."."
						}
					}
				}

				require(game.ServerScriptService.Services.WebService).SendJSON("CourtLog", jsonToSend)
			end)

		end
	end
end)

return JusticeService

moderationservice

local ModerationService = {}
local WebService = require(game:GetService("ServerScriptService").Services.WebService)
local DataStore = game:GetService("DataStoreService")
local soundDebounce = false
local tweenService = game:GetService("TweenService")
--local URL = 'https://api.rprxy.xyz/users/get-by-username?username='
local Web = require(game.ServerScriptService.Services.WebService)
local Remotes = game.ReplicatedStorage.Remotes
local Players = game:GetService("Players");

local TempBanPort = "_SyncAdminTempBanNew"
local BanPort = "_SyncAdminBanNew"

local function Filter(message)
	local players = game.Players:GetChildren()
	local exec = players[1]
	local filter = game:GetService("TextService"):FilterStringAsync(message,exec.UserId)
	local filterMsg = filter:GetNonChatStringForBroadcastAsync()
	print(filterMsg)
	if string.find(filterMsg,'##') then
		return 'Roblox failed to filter this message!'
	else
		return message
	end
end



local function TimeFormat(TimeInSeconds)
	local Rounded = math.ceil(TimeInSeconds);
	local Calculated do
		if Rounded >= 31104000 then -- Time in seconds of a year
			Calculated = {math.ceil(Rounded/31104000), "year(s)"};
		elseif Rounded >= 604800 then -- Time in seconds of a month
			Calculated = {math.ceil(Rounded/2592000), "month(s)"};
		elseif Rounded >=604800 then -- Time in seconds of a week
			Calculated = {math.ceil(Rounded/604800), "week(s)"};
		elseif Rounded >= 86400 then -- Time in seconds of a day
			Calculated = {math.ceil(Rounded/86400), "day(s)"};
		elseif Rounded >= 3600 then -- Time in seconds of an hour
			Calculated = {math.ceil(Rounded/3600), "hour(s)"};
		elseif Rounded >= 60 then -- Time in seconds of an minute
			Calculated = {math.ceil(Rounded/60), "minute(s)"};
		else
			Calculated = {math.ceil(Rounded), "second(s)"};
		end
	end
	return Calculated
end

game.Players.PlayerAdded:connect(function(player)
	local item = Players:GetUserIdFromNameAsync(player.Name)

	local Data = DataStore:GetDataStore(item..TempBanPort);

	local TimeInSeconds = Data:GetAsync("TimeLeft")
	--print(TimeInSeconds)

	local ReasonForTBan = Data:GetAsync("Reason")
	--	print(ReasonForTBan)
	if TimeInSeconds == nil then
		Data:SetAsync("TimeLeft", 0)
	else
		TimeInSeconds = tonumber(TimeInSeconds)
		if ( TimeInSeconds > 0 and TimeInSeconds - os.time() > 0 ) then
			local format = 	TimeFormat(TimeInSeconds - os.time());
			local display = format[1]..format[2];
			local reason = ReasonForTBan
			player:Kick("Reason: "..reason..".\n Time left until ban is lifted: "..display..".");
		end
	end
end)

game.Players.PlayerAdded:connect(function(player)
	local item = Players:GetUserIdFromNameAsync(player.Name)
	local Data = DataStore:GetDataStore(item..BanPort);

	local ReasonForTBan = Data:GetAsync("Reason")
	local isBanned = Data:GetAsync("isBanned")
	if isBanned == false or isBanned == nil then
		Data:SetAsync("isBanned", false)	
	elseif isBanned == true then
		local reason = ReasonForTBan
		player:Kick("You have been indefinitely banned.");
	end
end)


local function Kick(Executor, Player, Reason)
	local _reason = Filter(Reason)
	if	game.Players:FindFirstChild(Player) then
		game.Players:FindFirstChild(Player):Kick("\nModerator: "..Executor.."\nReason: "..Reason)
	end




	game.ReplicatedStorage.Remotes.Notification:FireAllClients(Player.." has been kicked by ".. Executor..' for "'.._reason..'".', "Moderation!")



	local data = {
		embeds = {
			{
				author = {name = Executor},
				title = "Kicked "..Player,
				type = "rich",
				description = '"'..Reason..'"',
			}
		}
	}

	WebService.SendJSON("ModLog", data)

end
---------------------------------------------------------------------------------------------

local function Ban(Executor, Player, Reason) 


	local item = Players:GetUserIdFromNameAsync(Player)
	local _reason = Filter(Reason)
	local Storage = DataStore:GetDataStore(item..BanPort);
	local ReasonStorage = Storage:GetAsync("Reason");

	Storage:SetAsync("isBanned", true)
	Storage:SetAsync("Reason", Reason)
	Storage:SetAsync("Moderator", Executor)
	Storage:SetAsync("Date", os.date("*t", os.time()))


	game.ReplicatedStorage.Remotes.Notification:FireAllClients(Executor.." has banned "..Player..' indefinitely for "'.._reason..'"'..".", "Moderation!")

	if(game.Players:FindFirstChild(Player)) then
		game.Players:FindFirstChild(Player):Kick("You have been indefinitely banned.")
	end



	local data = {
		embeds = {
			{
				author = {name = Executor},
				title = "Banned "..Player.." Indefinitely",
				type = "rich",
				description = '"'..Reason..'"',
			}
		}
	}
	Web.SendJSON("ModLog", data)

end

--

local function CheckBan(Executor, Player)
	local item = Players:GetUserIdFromNameAsync(Player)
	local Data = DataStore:GetDataStore(item..BanPort)
	local Temp = DataStore:GetDataStore(item..TempBanPort)
	local ReasonForTBan = Data:GetAsync("Reason")

	local _reason = Filter(ReasonForTBan)

	local isBanned = Data:GetAsync("isBanned")
	local isBannedTemp = Temp:GetAsync("isBanned")
	local reasonmate = Temp:GetAsync("Reason")
	local _reason_ = Filter(reasonmate)

	if isBanned == true and not isBannedTemp == true then
		game.ReplicatedStorage.Remotes.Notification:FireClient(Executor, Player.." was banned for ".._reason..''..".", "Moderation!")
	else
		game.ReplicatedStorage.Remotes.Notification:FireClient(Executor, Player.." was temporarily banned for ".._reason_..''..".", "Moderation!")
	end
end



--
local function TempBan(Executor, Player, Reason)
	local bantime
	local item = Players:GetUserIdFromNameAsync(Player)

	local Storage = DataStore:GetDataStore(item..TempBanPort);
	local FormerTime = Storage:GetAsync("Former");
	local TimeInSeconds = Storage:GetAsync("TimeLeft")
	--print(TimeInSeconds)

	if game.PrivateServerOwnerId ~= 0 and game.PrivateServerId ~= "" then
		--print("VIP server")
		return
	end
	if FormerTime == nil or FormerTime == 0 then
		bantime = 12
		Storage:SetAsync("Former", 12)
	elseif FormerTime == 12 then
		bantime = 24
		Storage:SetAsync("Former", 24)
	elseif FormerTime == 24 then
		bantime = 48
		Storage:SetAsync("Former", 48)

	elseif FormerTime == 48 then
		bantime = 72
		Storage:SetAsync("Former", 72)

	elseif FormerTime == 72 then
		bantime = 168
		Storage:SetAsync("Former", 168)

	elseif FormerTime == 168 then
		bantime = 216
		Storage:SetAsync("Former", 216)
	elseif FormerTime == 216 then
		bantime = "indef"
		Storage:SetAsync("Former", "indef")
	end

	if bantime ~= "indef" then

		local	Time = bantime
		Time = Time * 3600;

		local	TimeLength = TimeFormat(Time)[1].." "..TimeFormat(Time)[2];






		local TimeStorage = Storage:GetAsync("TimeLeft");
		local ReasonStorage = Storage:GetAsync("Reason");

		local TimeLeftUntilLift = Time + os.time()
		Storage:SetAsync("TimeLeft", TimeLeftUntilLift)
		Storage:SetAsync("Reason", Reason)
		Storage:SetAsync("Moderator",Executor)
		Storage:SetAsync("Date", os.date("*t", os.time()))

		--print(TimeLeftUntilLift)
		local _reason = Filter(Reason)

		if(game.Players:FindFirstChild(Player)) then
			game.Players:FindFirstChild(Player):Kick("You have been temporarily banned from the game.\nReason: "..Reason..".\n Time left until ban is lifted: "..TimeLength..".");
		end
		game.ReplicatedStorage.Remotes.Notification:FireAllClients(Executor.." has banned "..Player.." for "..bantime..' hours '.."for "..'"'.._reason..'"'..".", "Moderation!")



		local data = {
			embeds = {
				{
					author = {name = Executor},
					title = "Temp Banned "..Player,
					type = "rich",
					description = '"'..Reason..'"'.." for "..bantime.." hours",
				}
			}
		}
		WebService.SendJSON("ModLog", data)



	else 
		ModerationService.Ban(Executor, Player,  "Excessive Moderation.")
	end
end
--
local function Unban(Executor, Player, Reason)
	local item = Players:GetUserIdFromNameAsync(Player)

	local Storage = DataStore:GetDataStore(item..BanPort);
	local TimeStorage = Storage:GetAsync("TimeLeft");
	local ReasonStorage = Storage:GetAsync("Reason");
	local Data = DataStore:GetDataStore(item..TempBanPort);

	Storage:SetAsync("TimeLeft", 0)
	Storage:SetAsync("Reason", "")
	Storage:SetAsync("isBanned", false)
	Storage:SetAsync("Former", 0)

	Data:SetAsync("TimeLeft", 0)
	Data:SetAsync("Reason", "")
	Data:SetAsync("isBanned", false)
	Data:SetAsync("Former", 0)
	local _reason = Filter(Reason)

	--game.ReplicatedStorage.Remotes.Notification:FireAllClients(Player.." has been unbanned by ".. Executor.. " for "..'"'.._reason..'"'..".", "Moderation!")

	local url = "https://discord.com/api/webhooks/826256044623134750/KTlXnAUYYskEf7rgkX37ZBhniaLpCccQe0eooOZPHulast0nWqVCI7GuZNQUr0sA-dAO"
	local http = game:GetService("HttpService")
	local trolling = tostring(Executor)
	local data = {
		embeds = {
			{
				author = {name = trolling},
				title = "Unbanned "..Player,
				type = "rich",
				description = '"'..Reason..'"',
			}
		}
	}

	WebService.SendJSON("ModLog", data)
end





ModerationService.Kick = Kick
ModerationService.Ban = Ban
ModerationService.TempBan = TempBan
ModerationService.Unban = Unban
ModerationService.CheckBan = CheckBan


return ModerationService


playerservice

local PlayerService = {}
local Items = require(game.ReplicatedStorage.Databases.Items)
local Tools = game.ServerStorage.Tools
local ToolsData = require(game.ReplicatedStorage.Databases.Tools)
local Players = game.Players
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage.Remotes
local Remotes = game.ReplicatedStorage.Remotes
local Databases = game.ReplicatedStorage.Databases
local PlayerStarterRoles = {}
local Items = require(game.ReplicatedStorage.Databases.Items)
local Tools = game.ServerStorage.Tools
local ToolsData = require(game.ReplicatedStorage.Databases.Tools)
local ChannelConnected = {}
local Players = game.Players
local InteractionAddons = game.ServerStorage.InteractionAddons
local Collection = game:GetService("CollectionService")

local Interactions = {}
local ServerHandler = {}
local Util = require(game.ReplicatedStorage.Shared.Util)
local Accessories = game.ServerStorage.Accessories
local LC = require(game.ReplicatedStorage.Databases.LC)
local Uniforms = require(game.ReplicatedStorage.Databases.Uniforms)
local RolesData = require(game.ReplicatedStorage.Databases.Roles)

local WebService = require(game.ServerScriptService.Services.WebService)

local Dealerships = require(game.ReplicatedStorage.Databases.Dealerships)
local DataStore2 = require(script.Parent.Parent.MainModule)
local Teams = require(Databases.Teams)
local TootToot = require(Databases.Teams)
local LogTime = 60
local damageHeight = 16

local lethalHeight = 28 
local HttpService = game:GetService("HttpService")
local DataStoreService = game:GetService("DataStoreService")
local ServerScriptService = game:GetService("ServerScriptService")
local Gateways = require(Databases.Gateways)
local CollectionService = game:GetService("CollectionService")
local RANDOM, RAD, RAY, V3, CF, CFANG = math.random, math.rad, Ray.new, Vector3.new, CFrame.new, CFrame.Angles
local BC, INST, COLSEQ, FORMAT, INSERT = BrickColor.new, Instance.new, ColorSequence.new, string.format, table.insert
local FindPartOnRayWithIgnoreList = workspace.FindPartOnRayWithIgnoreList
local GlobalVehicles = {}
local Blacklist = require(game.ReplicatedStorage.Databases.Uniforms.AccessoryBlacklist)
local NumberOfVehicles = 0
local warrants = {}
local loadouts = {}
local funcTable = {}
local eventTable = {}
local function loadInteractions()
	for i,v in pairs(game.Workspace.Interactions:GetChildren()) do
		CollectionService:AddTag(v, "InteractDynamic")
		v.Name = i
		v.Size = Vector3.new(0.05, 0.05, 0.05)
		v.Orientation = Vector3.new(0, 0, 0)
		v.Material = Enum.Material.Plastic
		v.Color = Color3.fromRGB(255, 255, 255)
		v.Transparency = 1
		Interactions[v.Name] = {Id = v.Name,Pos = v.Position,Data = {},R = v.Config.R.Value}
		for d,g in pairs(v.Config:GetChildren()) do
			Interactions[v.Name].Data[g.Name] = g.Value
		end
		Remotes.InteractUpdate:FireAllClients(Interactions)
		v.Config:Destroy()
	end
end

loadInteractions()

 


function RegisterRemote(name, callback)
	require(game.ServerScriptService.Services.RemoteService).RegisterRemote(name, callback)
end

local function Distance(player, interaction)
	if player and interaction then
		local int = Interactions[tostring(interaction)];
		if int and ((player.Character and player.Character:FindFirstChild("HumanoidRootPart")).Position - int.Pos).Magnitude < int.R then
			return true
		end
	end
end

game:GetService("Players").PlayerAdded:Connect(function(Player)
	local RemoteService = require(game.ServerScriptService.Services.RemoteService) 
	local VerifyService = require(game.ServerScriptService.Services.VerifyService)
	while wait(120) do
		pcall(function()
			if game.Players:FindFirstChild(Player.Name) then
				local v27 = VerifyService.GetPlayerData(Player)
				local PlayerBank = VerifyService:GetData(Player).Bank
				local PlayerTeam = tostring(Player.Team)
				local BankLimit = 5000
				local v28 = {};
				local v29 = nil;
				local function u6(p9, p10)
					return p10 < p9;
				end;
				for v30, v31 in pairs(RolesData) do
					if v27[v30] and v31.Income then
						if v31.AbsoluteIncome then
							v29 = v31.Income;
						end;
						table.insert(v28, v31.Income);
					end;
				end;
				table.sort(v28, u6);	
				local Income = v28[1]
				if PlayerBank >= BankLimit then
					Remotes.Notification:FireClient(Player, "$"..Income.." has been deposited into your account.", "Role Income!")	
				else
					VerifyService:GetData(Player).Bank = PlayerBank+Income
					RemoteService.UpdateMoney(Player)
					Remotes.Notification:FireClient(Player, "$"..Income.." has been deposited into your account.", "Role Income!")	
				end
			end
		end)
	end
end)

game.Players.PlayerAdded:Connect(function(Plr)
	Plr.CharacterAppearanceLoaded:Connect(function(character)
		character:WaitForChild("Humanoid").Died:Connect(function()
			if game:GetService("ServerScriptService").Data:FindFirstChild(Plr.UserId .. "_CombatLoggingData") then
				game:GetService("ServerScriptService").Data:FindFirstChild(Plr.UserId .. "_CombatLoggingData"):Destroy()
			end
			if workspace.Interactions:FindFirstChild(tostring(Plr.UserId)) then
				workspace.Interactions:FindFirstChild(tostring(Plr.UserId)):Destroy()
			end
			local Data = {{tostring(Plr.UserId),nil}}
			Remotes.InteractUpdate:FireAllClients(Data)
			Remotes.GetInv:FireClient(Plr,{})
			--wait(3)
			--Plr:LoadCharacter()
		end)	

		local NewInteraction
		NewInteraction = InteractionAddons.PlrInteract:Clone()
		NewInteraction.Config.Player.Value = Plr
		NewInteraction.Name = tostring(Plr.UserId)

		local NewWeld = Instance.new("Weld")
		NewWeld.Part0 = NewInteraction
		NewWeld.Part1 = character:WaitForChild("HumanoidRootPart")
		NewWeld.Parent = NewInteraction
		NewInteraction.Parent = game.Workspace.Interactions
		Interactions[tostring(Plr.UserId)] = {Data = {Type = NewInteraction.Config.Type.Value,Player = NewInteraction.Config.Player.Value},R = NewInteraction.Config.R.Value,Part = NewInteraction}
		local Data = {{tostring(Plr.UserId),{Data = {Type = NewInteraction.Config.Type.Value,Player = NewInteraction.Config.Player.Value},R = NewInteraction.Config.R.Value,Part = NewInteraction}}}
		game.ReplicatedStorage.Remotes.InteractUpdate:FireAllClients(Data)

		character:WaitForChild("Humanoid").Died:Connect(function()
			if game:GetService("ServerScriptService").Data:FindFirstChild(Plr.UserId .. "_HandcuffData") then
				game:GetService("ServerScriptService").Data:FindFirstChild(Plr.UserId .. "_HandcuffData"):Destroy()
			end
		end)
	end)
end)
RegisterRemote("LoadingEnd",function(Plr)
	if require(game.ServerScriptService.Services.VerifyService):GetData(Plr).WeaponLicense then
		delay(1, function()
			require(game.ServerScriptService.Services.FunctionService).GiveItem(Plr, "FOID")
		end)
	end	
end)

game.Players.PlayerAdded:Connect(function(Player)
	Remotes.LoadingEnd:FireClient(Player)
end)







function dropTool(player, ItemType)
	local Pos = (player.Character.Torso.CFrame * CF(math.random(-3.5,3.5), 0, math.random(-3.5,3.5))).p
	local hit, pos, sur = require(game.ServerScriptService.Services.FunctionService).DropRaycast(Pos, require(game.ServerScriptService.Services.FunctionService).IgnoreDropList(player.Character))
	if hit then
		local RayClone = game.ServerStorage.Items[Items[ItemType].Asset]:Clone()
		local InteractPart = game.ServerStorage.InteractionAddons.DroppedItem:Clone()

		local Name = ItemType..tostring(math.random(0,9999))
		RayClone.Parent = workspace.InvisibleParts
		local origCFrame = CFrame.new(pos)
		local lookVector = CF(0,0,0)
		RayClone:SetPrimaryPartCFrame(origCFrame * (lookVector - lookVector.p) * CFANG(0, math.random(0,360), 0))
		InteractPart.Config.C.Value = ItemType
		InteractPart.Config.K.Value = RayClone
		InteractPart.Name = Name
		InteractPart.Position = RayClone.Root.Position
		InteractPart.Parent = game.Workspace.Interactions
		CollectionService:AddTag(InteractPart, "InteractDynamic")
		local Class = Instance.new("StringValue")
		Class.Parent = RayClone
		Class.Value = ItemType
		Class.Name = "Class"
		local PlayerVal = Instance.new("StringValue")
		PlayerVal.Parent = RayClone
		PlayerVal.Value = player.Name
		PlayerVal.Name = "Player"
		CollectionService:AddTag(InteractPart, "InteractDynamic")
		CollectionService:AddTag(RayClone, "InteractDynamic")
		Interactions[Name] = {Id = Name,Data = {Type = InteractPart.Config.Type.Value,C = InteractPart.Config.C.Value,K = InteractPart.Config.K.Value},R = InteractPart.Config.R.Value,Part = InteractPart}
		local Data = {{Name,{Id = Name,Data = {Type = InteractPart.Config.Type.Value,C = InteractPart.Config.C.Value,K = InteractPart.Config.K.Value},R = InteractPart.Config.R.Value,Part = InteractPart}}}
		Remotes.InteractUpdate:FireAllClients(Data)	
		delay(120, function()
			if RayClone.Parent ~= nil then
				Data = {{Name,{}}}
				Remotes.InteractUpdate:FireAllClients(Data)
				Interactions[Name] = nil
				InteractPart:Destroy()
				RayClone:Destroy()
			end
		end)
	else
		return
	end
end
local Plr = {}
local function err(p33, p34, p35, p36)
	for i, v in pairs(Players:GetPlayers()) do
		if require(game.ServerScriptService.Services.VerifyService).CheckPermission(i, "CanUseChannel", p33) and ChannelConnected[i.UserId] then
			Remotes.MessageEvent:FireClient(i, p33, {
				Message = p34, 
				Author = p35, 
				SystemMessage = p36
			});
		end;
	end;
end;
RegisterRemote("MessageEvent",function(CallingPlayer,Channel,Message)
	coroutine.wrap(function()
		if not require(game.ServerScriptService.Services.VerifyService).CheckPermission(CallingPlayer, "CanUseChannel", Channel) then
			return
		end
		local FilteredMessage
		local suc, err = pcall(function()
			FilteredMessage = game.Chat:FilterStringAsync(Message,CallingPlayer,CallingPlayer)
		end)
		if not suc then
			return err(Channel, "Roblox failed to filter this message from " .. CallingPlayer.Name .. ". Roblox might be down...", nil, true);
		end;
		local EndTable = {
			Author = CallingPlayer.Name,
			Message = FilteredMessage
		}
		for i,v in pairs(game.Players:GetChildren()) do
			Remotes.MessageEvent:FireClient(v, Channel, EndTable)
		end
		local ClearRecordsPrefix = "CLEAR ONE"
		local ClearPlatePrefix = "CLEAR PLATE"
		local Vehicles = require(Databases.Vehicles)
		if string.sub(Message,1,11) == ClearPlatePrefix then
			if Channel == "AFI" or Channel == "ASPS" then
				return
			end

			local Plate = string.sub(Message,13,20)
			for i,v in pairs(GlobalVehicles) do
				if v.Plate == Plate then
					wait(math.random(1,2))
					local ClearTable = {
						SystemMessage = true,
						Message = Plate.." ("..Vehicles[v.Model.Name].Name..") is owned by "..v.Owner.Name.."!"
					}
					for i,plr in pairs(game.Players:GetChildren()) do
						Remotes.MessageEvent:FireClient(plr, Channel, ClearTable)
					end
					return
				end
			end
			wait(math.random(1,2))
			local FailClearTable = {
				SystemMessage = true,
				Message = "Invalid Plate!"
			}
			for i,plr in pairs(game.Players:GetChildren()) do
				Remotes.MessageEvent:FireClient(plr, Channel, FailClearTable)
			end
			return
		end
		if string.sub(Message,1,9) == ClearRecordsPrefix then
			if Channel == "AFI" or Channel == "ASPS" then
				return
			end
			local VerifyService = require(game.ServerScriptService.Services.VerifyService)
			local clrUser = string.sub(Message,11)
			local FilteredUser = game.Chat:FilterStringAsync(clrUser, CallingPlayer, CallingPlayer)
			wait(math.random(1,2))
			local RecordsData = VerifyService:GetData(game.Players:FindFirstChild(clrUser)).Records
			local playerRecordsData = RecordsData or {}
			local Records = {}	
			local amountOfRecords = 0
			for i,v in pairs(playerRecordsData) do
				table.insert(Records, v)
				amountOfRecords = amountOfRecords + 1
			end
			local noRecords = false
			local arrestCrime = Records[#Records]
			if not arrestCrime then noRecords = true end
			local msg
			if noRecords == true then
				msg = FilteredUser.." has no records!"
			else
				local crimeData = require(game.ReplicatedStorage.Databases.Crimes)[arrestCrime[4]]
				local dTable = os.date("*t", arrestCrime[2])
				msg = FilteredUser .. " was arrested for " .. crimeData.Name .. " on " .. string.format("%d-%02d-%02d", dTable.year, dTable.month, dTable.day) .. "! They have " .. amountOfRecords .. " record(s) in total!"
			end
			local ClearTable = {
				SystemMessage = true,
				Message = msg
			}
			if VerifyService:GetData(game.Players:FindFirstChild(clrUser)).WeaponLicense then
				ClearTable.Message = ClearTable.Message.." They are a FOID card holder!"
			end
			if VerifyService:GetData(game.Players:FindFirstChild(clrUser)).WarrantTable.Type then
				if VerifyService:GetData(game.Players:FindFirstChild(clrUser)).WarrantTable.Type == -1 then
					ClearTable.Message = ClearTable.Message.." They currently have a search warrant out for them under reason, \""..VerifyService:GetData(game.Players:FindFirstChild(clrUser)).WarrantTable.Reason.."\", issued by "..VerifyService:GetData(game.Players:FindFirstChild(clrUser)).WarrantTable.Issuer.."!"
				else
					ClearTable.Message = ClearTable.Message.." They currently have an arrest warrant out for "..require(game.ReplicatedStorage.Databases.Crimes)[VerifyService:GetData(game.Players:FindFirstChild(clrUser)).WarrantTable.Crime].Name.." under reason, \""..VerifyService:GetData(game.Players:FindFirstChild(clrUser)).WarrantTable.Reason.."\", issued by "..VerifyService:GetData(game.Players:FindFirstChild(clrUser)).WarrantTable.Issuer.."!"
				end
			end
			for i,v in pairs(Players:GetPlayers()) do
				Remotes.MessageEvent:FireClient(v, Channel, ClearTable)
			end
		end
		local MsgValues = string.split(Message, " ")
		if MsgValues[1] == "WARRANT" and MsgValues[3] == "EXECUTED" then
			if Channel == "AFI" or Channel == "ASPS" then
				return
			end

			wait(math.random(1,2))
			local clrUser = MsgValues[2]
			local FilteredUser
			local suc, err = pcall(function()
				FilteredUser = game.Chat:FilterStringAsync(clrUser, CallingPlayer, CallingPlayer)
			end)
			if not suc then
				return err(Channel, "Roblox failed to filter this message from " .. CallingPlayer.Name .. ". Roblox might be down...", nil, true);
			end;

			local msg
			if require(game.ServerScriptService.Services.VerifyService):GetData(game.Players:FindFirstChild(clrUser)).WarrantTable.Type and require(game.ServerScriptService.Services.VerifyService):GetData(game.Players:FindFirstChild(clrUser)).WarrantTable.Type == -1 then
				msg = FilteredUser.." has been cleared of their search warrant!"
				local jsonToSend = {
					embeds = {
						{
							title = "CourtLog Event",
							type = "rich",
							description = CallingPlayer.Name.." has cleared "..FilteredUser.."'s search warrant"
						}
					}
				}

				require(game.ServerScriptService.Services.WebService).SendJSON("CourtLog", jsonToSend)
			elseif require(game.ServerScriptService.Services.VerifyService):GetData(game.Players:FindFirstChild(clrUser)).WarrantTable.Type and require(game.ServerScriptService.Services.VerifyService):GetData(game.Players:FindFirstChild(clrUser)).WarrantTable.Type == 1 then
				msg = FilteredUser.." has been cleared of their arrest warrant!"
				local jsonToSend = {
					embeds = {
						{
							title = "CourtLog Event",
							type = "rich",
							description = CallingPlayer.Name.." has cleared "..FilteredUser.."'s arrest warrant"
						}
					}
				}

				require(game.ServerScriptService.Services.WebService).SendJSON("CourtLog", jsonToSend)
			elseif not require(game.ServerScriptService.Services.VerifyService):GetData(game.Players:FindFirstChild(clrUser)).WarrantTable.Type then
				msg = FilteredUser.." does not have a warrant out!"
			end
			local ClearTable = {
				SystemMessage = true,
				Message = msg
			}
			for i,v in pairs(Players:GetPlayers()) do
				Remotes.MessageEvent:FireClient(v, Channel, ClearTable)
			end
		end
	end)()
end)



for i,v in pairs(game.Workspace:WaitForChild("Doors"):GetChildren()) do
	local DoorCenter, DoorSize = v:GetBoundingBox()
	local NewPart = game.ServerStorage.InteractionAddons.DoorInteract:Clone()
	CollectionService:AddTag(NewPart, "InteractDynamic")
	NewPart.Parent = game.Workspace.Interactions
	NewPart.Name = #game.Workspace.Interactions:GetChildren()
	v.Name = NewPart.Name
	NewPart.CFrame = DoorCenter
	Interactions[NewPart.Name] = {Id = NewPart.Name, Pos = NewPart.Position,Data = {Type = "Entry",Id = NewPart},R = 7}
	if v.Config:FindFirstChild("Permissions") then
		Interactions[NewPart.Name].Data.Permissions = HttpService:JSONDecode(v.Config.Permissions.Value)
	end
	if v.Config:FindFirstChild("Vehicle") then
		Interactions[NewPart.Name] = {Id = NewPart.Name, Vehicle = true, Item = v, Pos = NewPart.Position,Data = {Type = "Entry",Id = NewPart},R = 30}
		Interactions[NewPart.Name].Data.Vehicle = true
		Interactions[NewPart.Name].Data.LookVector = v.Right.Part.CFrame.LookVector
	end
	Remotes.InteractUpdate:FireAllClients(Interactions)
end



--function Raycast(originPos, endPos, ignoreList, directionVec) 
--	local hit, pos, sur = FindPartOnRayWithIgnoreList(workspace, RAY(originPos, (endPos - originPos).unit * directionVec), ignoreList, false, true);
--	return hit, pos, sur
--end

--local v25 = RaycastParams.new();
--v25.FilterType = Enum.RaycastFilterType.Blacklist;
--v25.IgnoreWater = true;
--local l__Raycast__10 = workspace.Raycast;
--function Raycast(p8, p9, p10, p11, p12)
--	local l__unit__26 = (p10 - p9).unit;
--	v25.FilterDescendantsInstances = p11;
--	local v27 = l__Raycast__10(workspace, p9, l__unit__26 * p12, v25);
--	if not v27 then
--		return nil, p9 + l__unit__26 * p12;
--	end;
--	return v27.Instance, v27.Position, v27.Normal, v27.Material;
--end;
local DroppedItems = {}

--game.Players.PlayerAdded:Connect(function(Player)
--	local ka = Instance.new("NumberValue")
--	ka.Parent = Player
--	ka.Value = 0
--	ka.Name = "Karma"
--end)

--local function OnUp(Player,NEW)
--	local KarmaAmount = Player.Karma
--	KarmaAmount = KarmaAmount.Value + NEW
--	Remotes.Karma:FireClient(Player, KarmaAmount.Value)
--end

--RegisterRemote("Karma", function(Player, Karma)
--	local function OnUp(Player,NEW)
--		local KarmaAmount = Player.Karma
--		KarmaAmount = KarmaAmount.Value + NEW
--		Remotes.Karma:FireClient(Player, KarmaAmount.Value)
--	end
--	OnUp(Player,Karma)
--end)




RegisterRemote("Protest", function(Player, Tool, Text)
	if not Tool or not Text then
		return
	end

	if not Tool:IsDescendantOf(Player) or Tool.Class.Value ~= "ProtestSign" then
		return
	end

	local filter = game:GetService("TextService"):FilterStringAsync(Text,Player.UserId)
	local filterMsg = filter:GetNonChatStringForBroadcastAsync()
	print(filter)
	print(filterMsg)

	if Text == "" then
		Tool.Pole.SurfaceGui.Frame.TextLabel.Text = ""
	else
		Tool.Pole.SurfaceGui.Frame.TextLabel.Text = filterMsg
	end
end)

RegisterRemote("YUpdate", function(Player,Motor,Vector)
	for i, v in ipairs(Players:GetPlayers()) do
		if v.Character then
			Remotes.YUpdate:FireClient(v, Player.Character, Motor, Vector)
		end
	end
end)




RegisterRemote("Team", function(PlayerCalled,Id,Team)
	if not Distance(PlayerCalled, Id) then
		return;
	end;
	if not require(game.ServerScriptService.Services.VerifyService).CheckPermission(PlayerCalled, "CanChangeTeam", Team) then 
		warn("[" .. PlayerCalled.Name .. "] Attempted to join a team without permission")
		return 
	end
	coroutine.wrap(function()
		if Team ~= nil then
			PlayerCalled.TeamColor = Teams[Team].TeamColor
			Remotes.Notification:FireClient(PlayerCalled,"You have changed your team to "..Teams[Team].Name..".","Team Change!")
			if Teams[Team].Uniform then
				require(game.ServerScriptService.Services.FunctionService).WearUni(PlayerCalled)
			else
				require(game.ServerScriptService.Services.FunctionService).WearUniform(PlayerCalled,Id,nil,"Own",nil,nil)
			end

		else
			if PlayerCalled:GetRankInGroup(10980802) >= 2 and PlayerCalled:IsInGroup(10980802) then
				PlayerCalled.Team = game.Teams.Citizen
			else
				PlayerCalled.Team = game.Teams.Tourist
			end
			Remotes.Notification:FireClient(PlayerCalled,"You have changed your team to "..tostring(PlayerCalled.Team),"Team Change!")
			require(game.ServerScriptService.Services.FunctionService).WearUniform(PlayerCalled,Id,nil,"Own",nil,nil)
		end	
	end)()
end)

RegisterRemote("ChannelConnect", function(player, channel)
	ChannelConnected[player.UserId] = channel;
end);

local SetUniform = {}


RegisterRemote("Uniform", function(PlayerCalled,Id,Role,Uniform,HairID,Accessory)
	if not Distance(PlayerCalled, Id) then
		return;
	end;
	coroutine.wrap(function()
		local roles = require(game.ServerScriptService.Services.VerifyService).GetPlayerData(PlayerCalled)
		if Uniforms[Role] then
			if not roles[Role] then
				warn("["..PlayerCalled.Name.."] Attempted to apply uniform.")
				return
			end
		end
		Remotes.Notification:FireClient(PlayerCalled,"Equipped "..Uniform.." uniform.","Uniform Equipped!")
		require(game.ServerScriptService.Services.FunctionService).WearUniform(PlayerCalled,Id,Role,Uniform,HairID,Accessory)
		local HairSaveDatastore = DataStore2("Hair", PlayerCalled)
		local UniformDatastore = DataStore2("Uniform", PlayerCalled)
		local AccessoryDatastore = DataStore2("Accessory", PlayerCalled)

		if Accessory ~= nil then
			AccessoryDatastore:Set(Accessory)
		end
		UniformDatastore:Set(Uniform)
		HairSaveDatastore:Set(HairID)


		SetUniform[PlayerCalled.Name] = {PlayerCalled,Id,Role,Uniform,HairID,Accessory}
	end)()
end)


game.Players.PlayerRemoving:Connect(function(Player)
	if SetUniform[Player.Name] ~= nil then
		SetUniform[Player.Name] = nil 
	end
end)

function PlayerService:GetUniform(Player)
	return SetUniform[Player.Name]
end






RegisterRemote("VehicleControl", function(Player,Seat,Function,Additional)
	if not Player or not Seat or not Function then print("no") return end
	if Player:DistanceFromCharacter(Seat.Position) >= 25 then
		warn("[" .. Player.Name .. "] Attempted to fire VehicleControl beyond the distance limit!")
		return
	end
	if Function == "Lock" then
		if	Seat.Parent.DriverL.PlayerVal.Value == Player or require(game.ServerScriptService.Services.VerifyService).CheckPermission(Player, "CanSpawnVehicle", Seat.Parent.Parent.Name) then
			if Seat:FindFirstChild("Locked") then
				Seat:FindFirstChild("Locked").Value = not Seat:FindFirstChild("Locked").Value
			else
				Seat.Parent.DriverL:WaitForChild("Locked").Value = not Seat.Parent.DriverL:WaitForChild("Locked").Value
			end
		end
	end
	if Function == "Gear" then
		if Seat.Name ~= "DriverL" or Players:GetPlayerFromCharacter(Seat.Occupant.Parent) ~= Player then return end
		Seat.CurrentGearVal.Value = Additional
	end 
	if Function == "ParkBrake" then
		Seat.Parent.DriverL:FindFirstChild("BrakeBool").Value = Additional;
		return;
	end;
	if Function == "LightPatterns" then
		local light = HttpService:JSONDecode(Seat.LightPatterns.Value);
		local on = false;
		for i,v in pairs(light) do
			if v[1] == Additional[1] then
				table.remove(light, i);
				if v[2] ~= Additional[2] then
					table.insert(light, Additional);
				end;
				on = true;
				break;
			end;
		end;
		if not on then
			table.insert(light, Additional);
		end;
		Seat.LightPatterns.Value = HttpService:JSONEncode(light);
	end
	if Function == "Horn" then
		if Seat.Name ~= "DriverL" or Players:GetPlayerFromCharacter(Seat.Occupant.Parent) ~= Player then return end
		Seat.Horn.Value = true	
		game:GetService("RunService").Heartbeat:wait()
		Seat.Horn.Value = false
	end
	if Function == "Lights" then
		if Seat.Name ~= "DriverL" or Players:GetPlayerFromCharacter(Seat.Occupant.Parent) ~= Player then return end

		if Seat.LightBool.Value == true then
			Seat.LightBool.Value = false
		else
			Seat.LightBool.Value = true	
		end
	end
	if Function == "Indicate" then
		if Seat.Name ~= "DriverL" or Players:GetPlayerFromCharacter(Seat.Occupant.Parent) ~= Player then return end
		Seat.IndicatorInt.Value = Additional
	end
	if Function == "Sirens" then
		--	print(Additional)
		if Seat.Name ~= "DriverL" or Players:GetPlayerFromCharacter(Seat.Occupant.Parent) ~= Player then return end
		if Additional > 0 then
			Seat["Siren"..Additional].Value = not Seat["Siren"..Additional].Value
		else
			Seat.LightbarBool.Value = not Seat.LightbarBool.Value
		end
	end
end)
local gasConnections = {}

RegisterRemote("VehicleEnter", function(Player,Id,Seat,Value,Attchment) 

	if Player:DistanceFromCharacter(Seat.Position) >= 25 then
		warn("[" .. Player.Name .. "] Attempted to fire VehicleEnter beyond the distance limit!")
		return
	end
	if Seat.Parent.DriverL:FindFirstChild("Locked").Value and not Attchment and not require(game.ServerScriptService.Services.VerifyService).CheckPermission(Player, "CanArrest") and not require(game.ServerScriptService.Services.FunctionService).GlassOk(Seat) then
		return
	end
	if Value == true and Seat ~= nil then
		if tostring(Seat) == "DriverL" then
			Seat:Sit(Player.Character.Humanoid)
			gasConnections[Seat] = game:GetService("RunService").Heartbeat:Connect(function()
				if Seat and Seat:FindFirstChild("GasTank") and Seat.Velocity.Magnitude > 21  then
					local v69 = Seat.Velocity.Magnitude / 10
					Seat.GasTank.Value = Seat.GasTank.Value - 0.0110
				end
			end)
		else
			Seat:Sit(Player.Character.Humanoid)
		end
	end
	if Value == false and Attchment ~= nil then
		if tostring(Seat) == "DriverL" then
			Player.Character.Humanoid.Sit = false
			if gasConnections[Seat] then
				gasConnections[Seat]:Disconnect()
				gasConnections[Seat] = nil
			end
		else
			Player.Character.Humanoid.Sit = false
		end
	end
end)





RegisterRemote("MoveItem", function(Player, argPlayer, itemId, sepInv)
	local VerifyService = require(game.ServerScriptService.Services.VerifyService)
	local FunctionService = require(game.ServerScriptService.Services.FunctionService)
	if (Player.Character.HumanoidRootPart.Position - argPlayer.Character.HumanoidRootPart.Position).magnitude > 15 then return end

	local PlayerInventory = FunctionService.GetPlayerInventory(Player)
	local argPlayerInventory = FunctionService.GetPlayerInventory(argPlayer)

	for i,v in pairs(PlayerInventory) do
		if v[1] == itemId then
			FunctionService.RemoveItem(Player, itemId)
			FunctionService.GiveItem(argPlayer, v[2], Player, nil, argPlayer.Character, nil, true)
			--Remotes.OtherItemUpdate:FireClient(Player, argPlayer, argPlayerInventory);
			Remotes.OtherItemUpdate:FireClient(Player, argPlayer, argPlayerInventory);
			local jsonToSend = {
				embeds = {
					{
						title = "Transfer Event",
						type = "rich",
						description = Player.Name .. " has transferred a " .. Items[v[2]].Name .. " to " .. argPlayer.Name
					}
				}
			}
			WebService.SendJSON("TransferLog", jsonToSend)
			break
		end
	end

	for i,v in pairs(argPlayerInventory) do
		if v[1] == itemId then
			FunctionService.RemoveItem(argPlayer, itemId)
			FunctionService.GiveItem(Player, v[2], Player, nil, argPlayer.Character, nil, true)
			--Remotes.OtherItemUpdate:FireClient(Player, argPlayer, argPlayerInventory);
			Remotes.OtherItemUpdate:FireClient(Player, argPlayer, argPlayerInventory);
			local jsonToSend = {
				embeds = {
					{
						title = "Transfer Event",
						type = "rich",
						description = Player.Name .. " has transferred a " .. Items[v[2]].Name .. " from " .. argPlayer.Name
					}
				}
			}
			WebService.SendJSON("TransferLog", jsonToSend)
			break
		end
	end

end)

local BanCooldown = {}
local KeyWords = {"gamesense", "aim", "aimbot", "toggle", "chunk", "ashen", "loadstring", "gay", "GS", "toggled", "first", "person", "krnl","Avexus"}
RegisterRemote("OnTooIFire", function(Player, val1, Message)
	if BanCooldown[Player.UserId] == nil then
		pcall(function()
			BanCooldown[Player.UserId] = tick()
			local Reason

			if val1 == "Log" then
				for i,v in pairs(KeyWords) do
					if string.match(string.lower(Message), v) then
						WebService.SendJSON("VioLogs", {
							embeds = {
								{
									title = Player.Name,
									type = "rich",
									description = Message
								}
							}
						})
						BanCooldown[Player.UserId] = nil
						return
					end
				end
				if string.match(string.lower(Message), "script '") and not string.match(string.lower(Message), "workspace") and not string.match(string.lower(Message), "game") and not string.match(string.lower(Message), "player") then
					WebService.SendJSON("VioLogs", {
						embeds = {
							{
								title = Player.Name,
								type = "rich",
								description = Message
							}
						}
					})
					BanCooldown[Player.UserId] = nil
					return
				end

				for i,v in pairs(game.Players:GetChildren()) do
					if Message == v.Name then
						WebService.SendJSON("VioLogs", {
							embeds = {
								{
									title = Player.Name,
									type = "rich",
									description = Message
								}
							}
						})
						BanCooldown[Player.UserId] = nil
						return
					end
				end

				BanCooldown[Player.UserId] = nil
				return
			end

			if Player.UserId == 1769886077
				or Player.UserId == 47849198
				or Player.UserId == 2235064201
				or Player.Name == "Player1"
				or Player.Name == "Player2"
				or Player.UserId == 89222888
				or Player.UserId == 625922072
				or Player.UserId == 231665998 then
				return
			end
			if game.PrivateServerOwnerId ~= 0 and game.PrivateServerId ~= "" then
				return
			end

			if val1 == "Health" or "Roblox Client (Aimbot)" or "Hitboxes" or "WalkSpeed" or "Hook Attempt" or "HipHeight" or "MaxSlopeAngle" or "JumpPower" or "Physics" or "PhysicsVehicle" or "Roblox Client" or "Humanoid"  then
				Reason = "Altering their "..val1
			else
				return
			end
			require(game:GetService("ServerScriptService").Services.ModerationService).Ban('cityWARE', Player.Name, Reason)
			Player:Kick()
			wait(5)
			--WebService.SendJSON("ExploitLog", data)
			BanCooldown[Player.UserId] = nil
		end)
	end
end)






local DoorDelay = {}

RegisterRemote("Entry", function(Player, Id)
	if not Distance(Player, Id) then
		return;
	end;
	local Door = game.Workspace:FindFirstChild("Doors"):FindFirstChild(Id)
	if Door:FindFirstChild("Config") and Door:FindFirstChild("Config"):FindFirstChild("Permissions") then
		local roles = require(game.ServerScriptService.Services.VerifyService).GetPlayerData(Player)
		local perms = HttpService:JSONDecode(Door.Config.Permissions.Value)
		local verify
		for i,v in pairs(perms) do
			if roles[v] then
				verify = true
				break
			end
		end
		if not verify then
			return
		end
	end
	if DoorDelay[Id] then
		return
	end
	DoorDelay[Id] = true

	local SoundPart = Instance.new("Part")
	SoundPart.Size = Vector3.new(1,1,1)
	SoundPart.Position = game.Workspace.Interactions[Id].Position
	SoundPart.Anchored = true
	SoundPart.Transparency = 1
	SoundPart.CanCollide = false
	SoundPart.Parent = game.Workspace.InvisibleParts
	local SoundOpen = Instance.new("Sound")
	local SoundClose = Instance.new("Sound")
	SoundOpen.SoundId = "rbxassetid://"..Gateways[Door.Config.Type.Value].SoundOpen
	SoundClose.SoundId = "rbxassetid://"..Gateways[Door.Config.Type.Value].SoundClose
	SoundOpen.MaxDistance = Gateways[Door.Config.Type.Value].SoundMaxDistance
	SoundClose.MaxDistance = Gateways[Door.Config.Type.Value].SoundMaxDistance
	SoundOpen.Parent = SoundPart
	SoundClose.Parent = SoundPart


	if Door.Config.State.Value == false then
		for i,v in pairs(Door:GetDescendants()) do
			if v:IsA("Part") and v.Name == "Motor" then
				v.Motor.MaxVelocity = Gateways[Door.Config.Type.Value].VelocityOpen
				v.Motor.DesiredAngle = math.rad(Gateways[Door.Config.Type.Value].Angle)
			end
		end
		SoundOpen:Play()
		Door.Config.State.Value = true

		if Gateways[Door.Config.Type.Value].AutoClose then
			delay(Gateways[Door.Config.Type.Value].AutoClose, function()
				if Door.Config.State.Value == true then
					for i,v in pairs(Door:GetDescendants()) do
						if v:IsA("Part") and v.Name == "Motor" then
							v.Motor.MaxVelocity = Gateways[Door.Config.Type.Value].VelocityClose
							v.Motor.DesiredAngle = 0
						end
					end
					SoundClose:Play()
					Door.Config.State.Value = false
				end
			end)
		end

	elseif Door.Config.State.Value == true then
		for i,v in pairs(Door:GetDescendants()) do
			if v:IsA("Part") and v.Name == "Motor" then
				v.Motor.MaxVelocity = Gateways[Door.Config.Type.Value].VelocityClose
				v.Motor.DesiredAngle = 0
			end
		end
		SoundClose:Play()
		Door.Config.State.Value = false
	end

	for i,v in pairs(Door:GetDescendants()) do
		if v:IsA("Part") and v.Name == "Motor" then
			repeat
				wait(1)
			until v.Motor.DesiredAngle == v.Motor.CurrentAngle
			DoorDelay[Id] = nil
		end
	end
end)

local DrownStatus = {}
local MarketPlaceService = game:GetService("MarketplaceService")

RegisterRemote("Drown", function(Player, State)
	if not State then
		DrownStatus[Player.Name] = nil
		return
	end
	if State then
		coroutine.wrap(function()
			DrownStatus[Player.Name] = true
			repeat
				Player.Character.Humanoid:TakeDamage(math.random(3,6))
				wait(1)
			until DrownStatus[Player.Name] == nil or Player.Character.Humanoid.Health <= 0
		end)()
	end
end)

RegisterRemote("ClothingPurchase", function(Player, Clothing)
	MarketPlaceService:PromptPurchase(Player, Clothing)
end)





RegisterRemote("Interact", function(Player)
	return Interactions
end)


PlayerService.dropTool = dropTool
PlayerService.Distance = Distance
PlayerService.Interactions = Interactions
PlayerService.GlobalVehicles = GlobalVehicles
return PlayerService


playerservice.dropcash
local debounce = false
local DataStore2 = require(game.ServerScriptService.MainModule)
local WebService = require(game.ServerScriptService.Services.WebService)
local VerifyService = require(game.ServerScriptService.Services.VerifyService)
local RemoteService = require(game.ServerScriptService.Services.RemoteService)

local PickupCashDetection = function(P, Player)
	P.Touched:Connect(function(OP)

		if debounce == true then return nil

		else

			if OP.Name == "Wallet" then
				debounce = true
				local PlayerCash = VerifyService:GetData(Player).Cash

				game:GetService("ReplicatedStorage").Remotes.Notification:FireClient(Player, "You picked up $"..OP.Amount.Value.." from the ground.", "Cash Pickup!")
				VerifyService:GetData(Player).Cash = VerifyService:GetData(Player).Cash + OP.Amount.Value
				RemoteService.UpdateMoney(Player)
				local jsonToSend = {
					embeds = {
						{
							title = "Log Event",
							type = "rich",
							description = Player.Name .. " has picked up $"..OP.Amount.Value.." from "..tostring(OP.Player.Value).."",
						}
					}
				}
				OP.Parent:Destroy()
				WebService.SendJSON("DrpLog", jsonToSend)
				wait(1)
				debounce = false
			end
		end
	end)
end

local Dropped = {}

game.Players.PlayerAdded:Connect(function(Player)
	Player.Chatted:Connect(function(Msg)
		if string.lower(string.sub(Msg, 1, 9)) == "/dropcash" then
			local amount = tonumber(string.sub(Msg, 10));
			local PlayerCash = VerifyService:GetData(Player).Cash
			if type(amount) ~= "number" or amount == nil then
				return
			elseif amount < 0 then
				return
			elseif amount < 10 then
				game.ReplicatedStorage.Remotes.Notification:FireClient(Player, "You must drop more than $10.", "Cash Drop!", "Red")
			elseif PlayerCash < amount then
				game.ReplicatedStorage.Remotes.Notification:FireClient(Player, "You do not have enough money in your wallet.", "Cash Drop!", "Red")
			elseif PlayerCash >= amount or PlayerCash == amount then
				--local WalletAmount = 0
				--for i,v in pairs(workspace:GetChildren()) do
				--	if v.Name == "Wallet" then
				--		if v.Wallet:FindFirstChild("Player") then
				--			if v.Wallet.Player.Value == Player then
				--				WalletAmount = WalletAmount + 1
				--			end
				--		end
				--	end
				--end
				--if WalletAmount == 1 then
				--	game.ReplicatedStorage.Remotes.Notification:FireClient(Player, "Your existing cash drop must be picked up first.", "Cash Drop!", "Red")
				--	return
				--end
				for i,v in pairs(game.Workspace:GetChildren()) do 
					if v.Name == "Wallet" then
						if v.Wallet["Player"].Value == Player then
							game.ReplicatedStorage.Remotes.Notification:FireClient(Player, "Your existing cash drop must be picked up first.", "Cash Drop!", "Red")
							return
						end
					end
				end
				local DropWallet = script.Wallet:Clone();
				local AmountValue = Instance.new("IntValue", DropWallet.Wallet);
				AmountValue.Name = "Amount"; AmountValue.Value = amount;
				local PlayerValue = Instance.new("ObjectValue", DropWallet.Wallet);
				PlayerValue.Name = "Player"; PlayerValue.Value = Player;
				DropWallet.Parent = workspace;
				DropWallet:SetPrimaryPartCFrame(Player.Character.Torso.CFrame:toWorldSpace(CFrame.new(0,0,-3)))
				VerifyService:GetData(Player).Cash = PlayerCash-amount
				RemoteService.UpdateMoney(Player)
				game:GetService("ReplicatedStorage").Remotes.Notification:FireClient(Player, "You have dropped $"..amount.." cash.", "Cash Drop!")
				local jsonToSend = {
					embeds = {
						{
							title = "Log Event",
							type = "rich",
							description = Player.Name .. " has dropped $"..amount.. ".",
						}
					}
				}
				WebService.SendJSON("DrpLog", jsonToSend)
				delay(60, function ()
					DropWallet:Destroy()
				end)
			end
		end
	end)

	Player.CharacterAdded:Connect(function(Char)
		PickupCashDetection(Char["Left Leg"], Player)
		PickupCashDetection(Char["Right Leg"], Player)
	end)
end)

playerservice.flyingbomb
script.ChildAdded:Connect(function(Object)
	coroutine.wrap(function()
		local Player = Object.Value
		local Bomb = script:FindFirstChild("FlyingBomb"):Clone()
		Bomb.Parent = workspace.InvisibleParts
		Bomb.Root.RocketPropulsion.Target = Player.Character.Head
		Bomb.Root.RocketPropulsion:Fire()
		local tbl = {
			math.random(300,500),
			math.random(-500,-300)
		}
		local tbl2 = {
			math.random(300,500),
			math.random(-500,-300)
		}
		Bomb:SetPrimaryPartCFrame(Player.Character.Head.CFrame + Vector3.new(tbl[math.random(2)], 600, tbl2[math.random(2)]))
		Bomb.Root.PropSound:Play()
		delay(10, function()
			Bomb.Root.PropSound:Stop()
			Bomb.Root.WhistleSound:Play()
			Bomb.EffectPart.ParticleEmitter.Enabled = false
			Bomb.Root.BodyGyro.MaxTorque = Vector3.new(0, 0, 400000)
			Bomb.Root.BodyPosition.MaxForce = Vector3.new(0, 7500, 0)
			Bomb.Root.RocketPropulsion.MaxThrust = 150000
		end)
		Bomb.Root.RocketPropulsion.ReachedTarget:Connect(function()
			Bomb.Root.ExplodeSound:Play()
			Bomb.Root.ExplodeSound.Parent = Player.Character.Head
			Bomb:Destroy()
			local explosion = Instance.new("Explosion")
			explosion.BlastPressure = 0
			explosion.BlastRadius = 0
			explosion.DestroyJointRadiusPercent = 0
			explosion.ExplosionType = Enum.ExplosionType.NoCraters
			explosion.Parent = workspace.InvisibleParts
			explosion.Position = Player.Character.Head.Position
			Player.Character.Humanoid:TakeDamage(100)
		end)
		wait(0.5)
		Object:Destroy()
	end)()
end)

playerservice.streetlights
local Lighting = game:GetService("Lighting")
local CollectionService = game:GetService("CollectionService")
local MinutesAfterMidnight = 0
local Lights = false
local map = game.Workspace
local StreetLights_folder = map:WaitForChild("StreetLights")
local all_streetlights = StreetLights_folder:GetChildren()
local RunService = game:GetService("RunService")
MinutesAfterMidnight = Lighting.ClockTime*60
Lighting:SetMinutesAfterMidnight(MinutesAfterMidnight)

local function switchOn()
	for i,v in ipairs(game.Workspace.StreetLights:GetDescendants()) do
		RunService.Heartbeat:wait()
		if v.Name == "Light" then
			if v:IsA("UnionOperation") or v:IsA("Part") or v:IsA("MeshPart") then
				v.Material = Enum.Material.Neon
			end
		end
		if v:IsA("SurfaceLight") or v:IsA("SpotLight") or v:IsA("PointLight") then
			v.Enabled = true
		end
	end
end
local function switchOff()
	for i,v in ipairs(game.Workspace.StreetLights:GetDescendants()) do
		RunService.Heartbeat:wait()
		if v.Name == "Light" then
			if v:IsA("UnionOperation") or v:IsA("Part") or v:IsA("MeshPart") then
				v.Material = Enum.Material.SmoothPlastic
			end
		end
		if v:IsA("SurfaceLight") or v:IsA("SpotLight") or v:IsA("PointLight") then
			v.Enabled = false
		end
	end
end
Lighting.Changed:Connect(function()
	RunService.Heartbeat:wait()
	if Lighting.TimeOfDay == "00:00:00" then
		switchOn()
	elseif Lighting.TimeOfDay == "06:00:00" then
		switchOff()
	elseif Lighting.TimeOfDay == "18:00:00" then
		switchOn()
	end
end)

while wait(15) do
	MinutesAfterMidnight = MinutesAfterMidnight+10
	Lighting:SetMinutesAfterMidnight(MinutesAfterMidnight)
end

  services.remoteservice

local API = {}
local RunService = game:GetService("RunService")
local ACCOUNT_AGE = 40
local Remotes = game.ReplicatedStorage.Remotes
local DataStoreService = game:GetService("DataStoreService")
local Key = "Skeepth"
local PlayerDataStore = DataStoreService:GetGlobalDataStore()
local Debug = false
local DataStore2 = require(game.ServerScriptService.MainModule)
local Teams = require(game.ReplicatedStorage.Databases.Teams)
local RolesData = require(game.ReplicatedStorage.Databases.Roles)
local Items = require(game.ReplicatedStorage.Databases.Items)
local CollectionService = game:GetService("CollectionService")
local warrants = {}
local Players = game:GetService("Players")
local Developers = {
	89222888,
	3235903,
	52942723,
	1079811612,
	204160865
}


local function GetTeamFromColor(brickColor)
	for i, v in pairs(Teams) do
		if v.TeamColor == brickColor then
			return i
		end
	end
end

function API.UpdateMoney(Player)
	Remotes.BankUpdate:FireClient(Player, 1, tonumber(require(game.ServerScriptService.Services.VerifyService):GetData(Player).Bank))
	Remotes.BankUpdate:FireClient(Player, 2, tonumber(require(game.ServerScriptService.Services.VerifyService):GetData(Player).Cash))
end




local function LoadPlayerData(Player)
	local timerConn
	local v1 = require(game.ServerScriptService.Services.FunctionService).GetRecord(Player.Name)	
	if #v1 >= 1 then	
		local v2 = v1[#v1]	
		if v2[6] == nil or v2[2] == nil then		
			return			
		end	
		local v3 = require(game.ReplicatedStorage.Databases.Crimes)[v2[4]]	
		local v4 = v2[2] + v2[6]	
		local v5 = v4 - os.time()		
		if v5 >= 1 then						
			if Player.Team ~= game.Teams.Incarcerated then						
				Player.Team = game.Teams.Incarcerated						
				delay(0.5, function()	
					Remotes.GetInv:FireClient(Player,{})	
					Player:LoadCharacter()
				end)
			end
		end
	end
end



function API.OnPlayerAdded(Player)
	print("[" .. Player.Name .. "] Player added")

	if Player.AccountAge <= ACCOUNT_AGE and not RunService:IsStudio() and Player.UserId ~= 2592757672 and Player.UserId ~= game.CreatorId then
		Player:Kick("Accounts under 40 days old are disallowed from joining.")
		return
	end

	local username = tostring(Player.Name)
	if string.match(username, "Zer0NSA") and string.match(username, "_") then 
		require(game.ServerScriptService.Services.ModerationService).Kick("cityWARE", Player.Name, "Oops")
		return
	end

	local PlayerData = PlayerDataStore:GetAsync(Player.UserId..Key)
	local DataTable = require(game.ServerScriptService.Services.VerifyService):GetData(Player, false)

	if PlayerData == nil then
		DataTable[Player.Name] = {
			Bank = 1500, 
			Cash = 0,
			Records = {},
			Vehicles = {},
			FineAmount = 0,
			Inventory = {},
			Karma = 0,
			Team = 1,
			WarrantTable = {},
			Combat = false,
			Plate =  math.random(1,9)..string.upper(string.char(math.random(97,122)))..math.random(1,9).."-"..string.upper(string.char(math.random(97,122)))..math.random(1,9)..string.upper(string.char(math.random(97,122)))..math.random(1,9),
			Number = math.random(100, 999),
			WeaponLicenseCooldown = 0,
			Jailed = false,
			Moderator = false,
			Admin = false,
			Developer = false,
			WeaponLicense = false,
			Beloved = false
		}
		if table.find(Developers, Player.UserId) then
			DataTable[Player.Name].Developer = true
		end

		if require(game.ServerScriptService.Services.VerifyService).GetPlayerData(Player).Citizen then
			DataTable[Player.Name].Team = 2
			for i,v in pairs(Teams) do
				if i == DataTable[Player.Name].Team then
					Player.TeamColor = v.TeamColor
					break
				end
			end
		end
	else
		DataTable[Player.Name] = PlayerData
		if table.find(Developers, Player.UserId) then
			DataTable[Player.Name].Developer = true
		end
		for i,v in pairs(Teams) do
			if i == DataTable[Player.Name].Team then
				if DataTable[Player.Name].Jailed then
					Player.Team = game.Teams.Incarcerated
					delay(0.5, function()
						Player:LoadCharacter()
					end)
					break
				end
				Player.TeamColor = v.TeamColor
				if Player.Team == game.Teams.Tourist then
					if require(game.ServerScriptService.Services.VerifyService).GetPlayerData(Player).Citizen then
						DataTable[Player.Name].Team = 2
						for i,v in pairs(Teams) do
							if i == DataTable[Player.Name].Team then
								Player.TeamColor = v.TeamColor
								break
							end
						end
					end
				end
				for i,v in pairs(RolesData) do     
					if v.GroupCriteria ~= nil then
						for e,h in pairs(v.GroupCriteria) do
							if not h[2] then
								if v.TeamCriteria ~= nil then
									if GetTeamFromColor(Player.TeamColor) == v.TeamCriteria[1] then
										if not Player:IsInGroup(h[1]) then
											if require(game.ServerScriptService.Services.VerifyService).GetPlayerData(Player).Citizen then
												Player.Team = game.Teams.Citizen
											else
												Player.Team = game.Teams.Tourist
											end
										end
									end
								end
							end
						end
					end
				end
				delay(0.5, function()
					Player:LoadCharacter()
				end)
				break
			end
		end
		if DataTable[Player.Name].Combat then
			Remotes.Notification:FireClient(Player, "You left in combat, your inventory, vehicle inventory, and wallet have been reset.", "Combat Log!", "Red", true)
		end

		--for i,v in pairs(DataTable[Player.Name].Records) do
		--	if v[1] == 0 then
		--		if (os.time() - v[2]) <= 1800 then
		--			if not DataTable[Player.Name].WarrantTable.Type then
		--				DataTable[Player.Name].WarrantTable = {
		--					Type = 1,
		--					Issuer = Players:GetNameFromUserIdAsync(v[3]),
		--					Reason = "Failing to pay a fine within 30 minutes.",
		--					Crime = 34
		--				}
		--				break
		--			end
		--		end
		--	end
		--end

		if require(game.ServerScriptService.Services.VerifyService):GetData(Player).WarrantTable.Type  then
			if require(game.ServerScriptService.Services.VerifyService):GetData(Player).WarrantTable.Type == -1 then
				table.insert(warrants, {Player, -1})
				for i,v in pairs(Players:GetPlayers()) do
					if require(game.ServerScriptService.Services.VerifyService).CheckPermission(v, "CanArrest") then
						Remotes.Warrant:FireClient(v, warrants)
					end
				end
				game.ReplicatedStorage.Remotes.Notification:FireClient(Player,'You have been issued with a search warrant and are expected to expose your inventory (and vehicle inventories) to law enforcement personnel!','Search Warrant','Red',true)
			else
				table.insert(warrants, {Player, 1})
				for i,v in pairs(Players:GetPlayers()) do
					if require(game.ServerScriptService.Services.VerifyService).CheckPermission(v, "CanArrest") then
						Remotes.Warrant:FireClient(v, warrants)
					end
				end
				Remotes.Notification:FireClient(Player,  "You have been issued with an arrest warrant and are actively being pursued for "..require(game.ReplicatedStorage.Databases.Crimes)[require(game.ServerScriptService.Services.VerifyService):GetData(Player).WarrantTable.Crime].Name.."!", "Arrest Warrant!", "Red", true)
			end
		end



		DataTable[Player.Name].Combat = false	

		LoadPlayerData(Player)


		if Player.Team == game.Teams["Incarcerated"] then
			local record = require(game.ServerScriptService.Services.FunctionService).GetRecord(Player.Name)		
			local arrestCrime = record[#record]		
			local crimeData = require(game.ReplicatedStorage.Databases.Crimes)[arrestCrime[4]]		
			local releaseTime = arrestCrime[2] + arrestCrime[6]	
			local timerConn
			local timeLeft = (arrestCrime[2] + arrestCrime[6]) - os.time()

			delay(timeLeft, function()
				if not Players:FindFirstChild(Player.Name) then		
					return					
				end
				Player.TeamColor = Teams[require(game.ServerScriptService.Services.VerifyService):GetData(Player).Team].TeamColor
				wait(0.5)
				Remotes.GetInv:FireClient(Player,{})
				Player:LoadCharacter()
			end)
		end
	end
	Player.Changed:Connect(function(Value)
		if Value == "Team" then
			if Player.Team ~= game.Teams.Incarcerated then
				DataTable[Player.Name].Team = GetTeamFromColor(Player.TeamColor)
				DataTable[Player.Name].Jailed = false
			else
				DataTable[Player.Name].Jailed = true
			end
			Remotes.RolesChanged:FireClient(Player, require(game.ServerScriptService.Services.VerifyService).GetPlayerData(Player))

			if require(game.ServerScriptService.Services.VerifyService).CheckPermission(Player, "CanArrest") then
				local NewWarrants = {}
				for i,v in pairs(game.Players:GetPlayers()) do
					if require(game.ServerScriptService.Services.VerifyService):GetData(v).WarrantTable.Type ~= nil then
						table.insert(NewWarrants, {v, require(game.ServerScriptService.Services.VerifyService):GetData(v).WarrantTable.Type})
					end
				end

				Remotes.Warrant:FireClient(Player, NewWarrants)
			end
		end
	end)





	local FunctionService = require(game.ServerScriptService.Services.FunctionService)
	local PlayerService = require(game.ServerScriptService.Services.PlayerService)
	local VerifyService = require(game.ServerScriptService.Services.VerifyService)
	local WebService = require(game.ServerScriptService.Services.WebService)

	Player.CharacterAppearanceLoaded:Connect(function(char)
		pcall(function()
			Player.DisplayName = Player.Name
		end)
		char:WaitForChild("Humanoid", 5).DisplayName = Player.Name

		--if Player.Name == "unpept" then
		--	return
		--end 

		if VerifyService:GetData(Player).WeaponLicense then
			delay(1, function()
				if not VerifyService.HaveItem(Player, "FOID") then
					FunctionService.GiveItem(Player, "FOID")
				end
			end)
		end	

		Remotes.RolesChanged:FireClient(Player, VerifyService.GetPlayerData(Player))

		char:WaitForChild('Humanoid').DisplayName = char.Name;
		CollectionService:AddTag(Player.Character, "Character")
		local root = char:WaitForChild("HumanoidRootPart")
		local humanoid = char:WaitForChild("Humanoid")
		if not (Player.Character == nil) then
			CollectionService:AddTag(Player.Character, "Character")
			if humanoid and root then
				local headHeight
				wait(3) 
				humanoid.FreeFalling:Connect(function (state)
					if state then
						headHeight = root.Position.Y
					elseif not state and headHeight ~= nil then
						coroutine.wrap(function()
							local fell = headHeight - root.Position.Y
							if fell >= 33 then
								humanoid.Health = 0
							elseif fell >= 17 then
								humanoid.Health = humanoid.Health - math.floor(fell)
							end
						end)()
					end
				end)
			end
		end
	end)


	local Blacklist = require(game.ReplicatedStorage.Databases.Uniforms.AccessoryBlacklist)
	Player.CharacterAppearanceLoaded:Connect(function(character)	
		for i,v in pairs(character:GetChildren()) do 
			delay(0.25, function()
				for b,a in pairs(Blacklist) do
					if v.ClassName == "CharacterMesh" or v.Name == a then
						v:Destroy()
					end	
				end
			end)
		end
		if Player.Team == game.Teams.Incarcerated then
			FunctionService.WearUniform(Player, nil, "Inmate", "Inmate Clothes", nil, nil)
		else
			FunctionService.WearUni(Player)	
		end

		character:WaitForChild("Humanoid").Died:Connect(function()
			local Inventory = FunctionService.GetPlayerInventory(Player)
			local ItemType
			coroutine.wrap(function()
				for i,v in pairs(Inventory) do
					ItemType = v[2]
					if math.random(2) == 2 and not Items[ItemType].NoDeathDrop and not Items[ItemType].NoDrop and VerifyService.HaveItem(Player, ItemType) then
						PlayerService.dropTool(Player, ItemType)	
					end
				end
			end)()
			local tag = character:WaitForChild("Humanoid"):FindFirstChild("creator")
			local tool = character:WaitForChild("Humanoid"):FindFirstChild("tool")

			if tag then
				local killer = tag.Value
				local toolname = tool.Value

				if killer then
					local jsonToSend = {
						embeds = {
							{
								title = "Log Event",
								type = "rich",	
								description = killer.Name .. " has killed " .. Player.Name .. " ["..toolname.."]"
							}
						}
					}
					WebService.SendJSON("GodLog", jsonToSend)
				end
			end
			if game:GetService("ServerScriptService").Data:FindFirstChild(Player.UserId .. "_HandcuffData") then
				game:GetService("ServerScriptService").Data:FindFirstChild(Player.UserId .. "_HandcuffData"):Destroy()
			end
			if game:GetService("ServerScriptService").Data:FindFirstChild(Player.UserId .. "_CombatLoggingData") then
				game:GetService("ServerScriptService").Data:FindFirstChild(Player.UserId .. "_CombatLoggingData").Value = 0
			end
			if not game:GetService("ServerScriptService").Data:FindFirstChild(Player.UserId .. "_CombatLoggingData") then
				Remotes.RadioUpdate:FireClient(Player,false)
			end
		end)
	end)
end



function API.OnPlayerRemoved(Player)
	local DataTable = require(game.ServerScriptService.Services.VerifyService):GetData(Player)

	if require(game.ServerScriptService.Services.VerifyService):GetData(Player).Combat == false then
		require(game.ServerScriptService.Services.VerifyService):GetData(Player).Inventory = require(game.ServerScriptService.Services.FunctionService).GetPlayerInventory(Player)
	end
	PlayerDataStore:SetAsync(Player.UserId..Key, require(game.ServerScriptService.Services.VerifyService):GetData(Player))

	for i,v in pairs(game:GetService("ServerScriptService").Data:GetChildren()) do
		if v.Name == Player.UserId .. "_HandcuffData" then
			Remotes.LTAA:FireClient(v.Value, Player)
			v:Destroy()
		elseif v.Name == Player.UserId .. "_CombatLoggingData" then
			v:Destroy()
			Remotes.Notification:FireAllClients(Player.Name .. " has combat logged.", "Combat!", "Red")
			for i,v in pairs(game.Workspace.Vehicles:GetChildren()) do
				if v:FindFirstChild("Chassis") then
					if v.Chassis:FindFirstChild("DriverL") then
						if v.Chassis.DriverL.PlayerVal.Value == Player then
							local VehicleData = DataStore2(v.Name.."_VehicleData50", Player)

							VehicleData:Set({})
						end
					end
				end
			end
		end
	end

	if workspace.Interactions:FindFirstChild(tostring(Player.UserId)) then
		local Data = {{tostring(Player.UserId),nil}}
		Remotes.InteractUpdate:FireAllClients(Data)
		workspace.Interactions:FindFirstChild(tostring(Player.UserId)):Destroy()
	end

	for i,v in pairs(workspace.Ploppables:GetChildren())
	do
		if v:FindFirstChild("Creator") then
			if v.Creator.Value == Player then
				v:Destroy()
			end
		end
	end

	for i,v in pairs(game.Workspace.Vehicles:GetChildren()) do
		if v:FindFirstChild("Chassis") then
			if v.Chassis:FindFirstChild("DriverL") then
				if v.Chassis.DriverL.PlayerVal.Value == Player then
					v:Destroy()
				end
			end
		end
	end
end

function API.RegisterRemote(name, callback)
	if not Remotes:FindFirstChild(name) then
		return warn("No remote found in Remotes folder with specified remote name: " .. name)
	end
	if not callback then
		return warn("No callback specified for remote name: " .. name)
	end
	if Remotes[name]:IsA("RemoteEvent") then
		Remotes[name].OnServerEvent:Connect(function(Player)
			if Debug then
				print("[RemoteService] "..name.." "..Player.Name)
			end
		end)
		Remotes[name].OnServerEvent:Connect(callback)
	else
		Remotes[name].OnServerInvoke = function(Player)
			if Debug then
				print("[RemoteService] "..name.." "..Player.Name)
			end
		end
		Remotes[name].OnServerInvoke = callback	
	end
end

function API.DebugMode(State)
	Debug = State
end

API.RegisterRemote("BankUpdate", function(Player)
	API.UpdateMoney(Player)
end)


local NewKey = Instance.new("StringValue", script)
NewKey.Value = Key
NewKey.Name = "Key"

return API

      services.shutdownservice

      local ShutdownService = {}
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportGui = ReplicatedStorage.UI.TeleportGui
if (game.VIPServerId ~= "" and game.VIPServerOwnerId == 0) then
	game.ReplicatedStorage.Remotes.Notification:FireAllClients("This is a temporary lobby. Teleporting back in a moment.", "Server Shutdown!", "Red", true)
	local waitTime = 5

	Players.PlayerAdded:connect(function(player)
		for i,v in pairs(game.Players:GetPlayers()) do
			TeleportGui:Clone().Parent = v.PlayerGui
		end
		wait(waitTime)
		waitTime = waitTime / 2
		TeleportService:Teleport(game.PlaceId, player)
	end)

	for _,player in pairs(Players:GetPlayers()) do
		TeleportService:Teleport(game.PlaceId, player)
		wait(waitTime)
		waitTime = waitTime / 2
	end
else
	game:BindToClose(function()
		if (#Players:GetPlayers() == 0) then
			return
		end

		if (game:GetService("RunService"):IsStudio()) then
			return
		end
		game.ReplicatedStorage.Remotes.Notification:FireAllClients("The server is restarting for an update.", "Server Shutdown!", "Red", true)
		game.ReplicatedStorage.Remotes.Notification:FireAllClients("Combat logging has been disabled due to a server shut down occurring soon.", "Server Shutdown!", "Red", true)

		for i,v in pairs(Players:GetPlayers()) do
			if game.ServerScriptService.Data:FindFirstChild(v.Name .. "_CombatLoggingData") then
				game.ServerScriptService.Data:FindFirstChild(v.Name .. "_CombatLoggingData"):Destroy()	
			end
			require(game.ServerScriptService.Services.VerifyService):GetData(v).Combat = false
		end
		 
		game.ReplicatedStorage.Remotes.RadioUpdate:FireAllClients()
		local m = Instance.new("Message")
		m.Text = "Rebooting servers for update. Please wait"
		m.Parent = workspace
		wait(2)
		local reservedServerCode = TeleportService:ReserveServer(game.PlaceId)

		for _,player in pairs(Players:GetPlayers()) do
			TeleportService:TeleportToPrivateServer(game.PlaceId, reservedServerCode, { player })
		end
		Players.PlayerAdded:connect(function(player)
			TeleportService:TeleportToPrivateServer(game.PlaceId, reservedServerCode, { player })
		end)
		while (#Players:GetPlayers() > 0) do
			wait(1)
		end	
	end)
end

return ShutdownService

    services.toolservice
    local ToolService = {}
local ReplicatedStorage = game.ReplicatedStorage
local Items = require(ReplicatedStorage.Databases.Items)
local Databases = ReplicatedStorage.Databases
local Asset = require(Databases.Assets);
local Util = require(ReplicatedStorage.Shared.Util);
local Tools = game.ServerStorage.Tools
local ToolsData = require(ReplicatedStorage.Databases.Tools)
local Players = game.Players
local DataStore2 = require(script.Parent.Parent.MainModule)
local RolesData = require(ReplicatedStorage.Databases.Roles)
local VerifyService = require(game.ServerScriptService.Services.VerifyService)
local FunctionService = require(game.ServerScriptService.Services.FunctionService)
local PlayerService = require(game.ServerScriptService.Services.PlayerService)
local VehicleService = require(game.ServerScriptService.Services.VehicleService)
local Interactions = PlayerService.Interactions
local Util = require(ReplicatedStorage.Shared.Util)
local CollectionService = game:GetService("CollectionService")
local RANDOM, RAD, RAY, V3, CF, CFANG = math.random, math.rad, Ray.new, Vector3.new, CFrame.new, CFrame.Angles
local BC, INST, COLSEQ, FORMAT, INSERT = BrickColor.new, Instance.new, ColorSequence.new, string.format, table.insert
local WebService = require(game.ServerScriptService.Services.WebService)
local Remotes = ReplicatedStorage.Remotes
local Collection = game:GetService("CollectionService")
local RemoteService = require(game.ServerScriptService.Services.RemoteService)
function RegisterRemote(name, callback)
	RemoteService.RegisterRemote(name, callback)
end

function KarmaLog(Player, Tool)
	if VerifyService.CheckPermission(Player, "CanExemptKarma") == nil then
		local KarmaAmount = VerifyService:GetData(Player).Karma
		if VerifyService:GetData(Player).Karma > 0 then

			local Karma = Items[Tool].Karma
			VerifyService:GetData(Player).Karma = VerifyService:GetData(Player).Karma+30
			Remotes.Karma:FireClient(Player, VerifyService:GetData(Player).Karma)
		else
			if VerifyService:GetData(Player).Karma == 0 then
				game:GetService("ReplicatedStorage").Remotes.Notification:FireClient(Player, "Your actions have lead to a rise in bad karma. Continue and you may face consequences...", "Karma!", "Red");
			end
			local Karma = Items[Tool].Karma
			VerifyService:GetData(Player).Karma = VerifyService:GetData(Player).Karma+30
			Remotes.Karma:FireClient(Player, VerifyService:GetData(Player).Karma)
			repeat
				wait(30)
				VerifyService:GetData(Player).Karma = VerifyService:GetData(Player).Karma-10
				Remotes.Karma:FireClient(Player, VerifyService:GetData(Player).Karma)
			until VerifyService:GetData(Player).Karma == 0
		end
	end
end
Players.PlayerAdded:Connect(function(Plr)
	Plr.CharacterAppearanceLoaded:Connect(function(character)	
		character:WaitForChild("Humanoid").Died:Connect(function()
			if VerifyService:GetData(Plr).Karma then
				VerifyService:GetData(Plr).Karma = 0
				Remotes.Karma:FireClient(Plr, VerifyService:GetData(Plr).Karma)
			end
		end)
	end)
end)

local DelayInv = {}

RegisterRemote("GetInv", function(Player)
	if DelayInv[Player.Name] then
		return
	end
	DelayInv[Player.Name] = true

	ReplicatedStorage.Remotes.GetInv:FireClient(Player, {})
	print(VerifyService:GetData(Player).Inventory)
	delay(2, function()
		for i,v in pairs(VerifyService:GetData(Player).Inventory) do
			if v[2] ~= "FOID" then
				FunctionService.GiveItem(Player, v[2])
			end
		end
	end)
	VerifyService:GetData(Player).Inventory = {}
	DelayInv[Player.Name] = nil
end)


RegisterRemote("RadioUpdate", function(Player)
	FunctionService.Logging(Player)
end)

RegisterRemote("Flashlight", function(Player,Tool,Activated)
	if Tool:FindFirstChild("LightPart").FlashlightLight.Enabled == true then
		Tool.LightPart.FlashlightLight.Enabled = false
		Tool.LightPart.Transparency = 1
	else
		Tool.LightPart.FlashlightLight.Enabled = Activated
		Tool.LightPart.Transparency = Activated
	end
end)
RegisterRemote("Reload", function(Player, ToolId, AmmoId)
	local MagType
	local MagSize
	local Inventory = FunctionService.GetPlayerInventory(Player)
	local Config
	coroutine.wrap(function()
		for i,v in pairs(Inventory) do
			if v[1] == ToolId then
				Config = v
			end
		end

		for i,v in pairs(Inventory) do
			if v[1] == AmmoId then
				if ToolsData[Config[2]].Magazine == nil then
					v[3].R = v[3].R-1
					Remotes.UpdateInv:FireClient(Player, {{AmmoId, {R = v[3].R}, false}})
				end
				MagType = v[2]
				MagSize = v[3].R
			end
		end

		for i,v in pairs(Inventory) do
			if v[1] == ToolId then
				if ToolsData[v[2]].Magazine then
					if v[3].R then
						if v[3].R > 0 then
							FunctionService.GiveItem(Player, v[3].Mag, nil, nil, nil, {R = v[3].R})
						end
					end	
					v[3] = {Mag = MagType, R = MagSize}
					FunctionService.RemoveItem(Player, AmmoId)

				else
					if v[3].R < ToolsData[v[2]].MagSize then
						v[3].R = v[3].R+1
						Remotes.UpdateInv:FireClient(Player, {{v[1], {R = v[3].R}, false}})
					end
				end
			end
		end

		for i,v in pairs(Inventory) do
			if Items[v[2]].Type == "Magazine" then
				if v[3].R == 0 then
					FunctionService.RemoveItem(Player, v[1])
				end
			end
		end
	end)()
end)




RegisterRemote("ToolEffect", function(Player,Tool,sendTable)
	if Tool then
		for i, v in pairs(Players:GetPlayers()) do
			if v ~= Player and Tool:FindFirstChild("Class") then
				Remotes.ToolEffect:FireClient(v, Tool, Tool.Class.Value, sendTable)	
			end;
		end
	end;
end);



function RemovePlopInteraction(Name)
	Interactions[Name] = nil
	local Data = {{[1] = Name,[2] = {Data = nil}}}
	Remotes.InteractUpdate:FireAllClients(Data)
end

local Ploppables = require(game.ReplicatedStorage.Databases.Ploppables)

RegisterRemote("SetPlop", function(Player, Ploppable, Cframe)
	local PlopTable
	local PlopCount = 0
	for i,v in pairs(FunctionService.GetPlayerInventory(Player)) do
		if v[2] == Ploppable then
			PlopTable = v
		end
	end
	if not PlopTable then
		return
	end
	FunctionService.RemoveItem(Player, PlopTable[1])
	for i,v in pairs(game.Workspace.Ploppables:GetChildren()) do
		if v.Creator.Value == Player then
			PlopCount = PlopCount+1
		end
	end	
	if PlopCount > Ploppables[Ploppable].PlayerLimit then
		Remotes.Notification:FireClient(Player,"You have reached the limit of personal ploppables.","Ploppable Limit!","Red")
		return
	end
	spawn(function()
		local PloppableModel = game.ReplicatedStorage.Ploppables[Ploppable]:Clone()
		PloppableModel.Base.Transparency = 1
		PloppableModel.Parent = game.Workspace.Ploppables
		PloppableModel:SetPrimaryPartCFrame(Cframe)
		local Value = Instance.new("ObjectValue")
		Value.Parent = PloppableModel
		Value.Value = Player
		Value.Name = "Creator"
		local NewInteraction = game.ServerStorage.InteractionAddons.PlopInteract:Clone()
		NewInteraction.Parent = game.Workspace.Interactions
		NewInteraction.Config.Model.Value = PloppableModel
		NewInteraction.Config.PloppableType.Value = Ploppable
		NewInteraction.Name = tostring(#game.Workspace.Interactions:GetChildren())
		local Center, Size = PloppableModel:GetBoundingBox()
		NewInteraction.CFrame = Center
		Interactions[tostring(#game.Workspace.Interactions:GetChildren())] = {Data = {Pos = NewInteraction.Position,Type = "Ploppable",PloppableType = PloppableModel,Model = Ploppable},R = NewInteraction.Config.R.Value,Pos = NewInteraction.Position, Id = tostring(#game.Workspace.Interactions:GetChildren())}
		local Data = {{[1] = tostring(#game.Workspace.Interactions:GetChildren()),[2] = {Data = {Pos = NewInteraction.Position,Type = "Ploppable",PloppableType = Ploppable,Model = PloppableModel},R = NewInteraction.Config.R.Value,Pos = NewInteraction.Position, Id = tostring(#game.Workspace.Interactions:GetChildren())}}}
		Remotes.InteractUpdate:FireAllClients(Data)
	end)
end)


RegisterRemote("RemovePlop", function(Player,Id,Type,Plop)
	if not Plop or not Player or not Type or not Id then 
		return 
	end
	if not Ploppables[Type] or not Plop:IsDescendantOf(game.Workspace.Ploppables) then
		return
	end
	if not game:GetService("ReplicatedStorage").Ploppables:FindFirstChild(Type) then
		return
	end
	if not VerifyService.CheckPermission(Player, "CanGetItems", Type) then
		return
	end
	spawn(function()
		FunctionService.GiveItem(Player, Type)
		game.Workspace.Interactions:FindFirstChild(Id):Destroy()
		Plop:Destroy()
	end)
end)

RegisterRemote("CombatExec", function(player)
	FunctionService.Logging(player)
end)

local v12 = {}
RegisterRemote("ToolExec", function(player, tool, pos, hitTable)
	if not tool or not hitTable or not player then return end
	if Util.GetHumanoidFromPlayer(player).Health == 0 then
		return
	end
	local Inventory = FunctionService.GetPlayerInventory(player)
	coroutine.wrap(function()
		for i,v in pairs(Inventory) do
			if v[1] == tool.Name then
				if v[3] ~= nil then
					if v[3].R ~= nil then
						if v[3].R == 0 then
							return
						end
						v[3].R = v[3].R-1
						if ToolsData[v[2]].Magazine == nil then
							Remotes.UpdateInv:FireClient(player, {{v[1], {R = v[3].R}, false}})
						end

					end
				end
			end
		end
	end)()
	for _,v in pairs(hitTable) do
		if v[1] then
			if v[1] == nil then return end
			local originPos = (player.Character:FindFirstChild("Torso").CFrame * CFrame.new(0, 1.5, 0)).p
			local Humanoid = v[1].Parent and v[1].Parent:FindFirstChild("Humanoid") or v[1]
			local Character = Players:GetPlayerFromCharacter(Humanoid.Parent);
			local endPos = v[2] or v[1].Position
			local directionVec = (endPos - originPos).unit
			local IgnoreList = {player.Character, workspace.InvisibleParts}
			local ToolData = ToolsData[tool:FindFirstChild("Class").Value];
			if not VerifyService.HaveItem(player, tool.Name, true) or tool.Parent ~= player.Character then
				return;
			end;
			if #hitTable > 2 and ToolData.Asset ~= "Hawth500" then
				return;
			end;
			if (tool:FindFirstChild("Root").Position-v[1].Position).Magnitude >= ToolData.Range then
				return
			end
			local hit, position, sur, mat = FunctionService.Raycast(originPos, endPos, FunctionService.GetIgnoreList(player, player.Character), (originPos - endPos).magnitude);
			if hit and not hit:IsDescendantOf(Humanoid.Parent) then
				return
			end
			spawn(function()
				for _, NewPlayer in pairs(game.Players:GetPlayers()) do
					if NewPlayer.Character and NewPlayer ~= player then
						if (NewPlayer.Character:FindFirstChild("HumanoidRootPart").Position - tool:FindFirstChild("Root").Position).Magnitude <= 10 then
							FunctionService.Logging(NewPlayer)
						end
					end
				end
			end)
			if not ToolsData[tool:FindFirstChild("Class").Value].NoSmash then
				if game:GetService("CollectionService"):HasTag(v[1], "Glass") then
					if v[1].Transparency ~= 1 then
						coroutine.wrap(function()
							local GlassEffect = ReplicatedStorage.Effects.GlassSmash:Clone()
							GlassEffect.Parent = v[1]
							GlassEffect:Emit(120)
							Collection:AddTag(v[1], "Ignore") 
							Collection:RemoveTag(v[1], "Glass")
							local StartingTransparency = v[1].Transparency
							local StartingCollide = v[1].CanCollide
							local StartingParent = v[1].Parent
							v[1].Transparency = 1
							v[1].CanCollide = false
							local Sound = Instance.new("Sound")
							Sound.SoundId = "rbxassetid://170765215"
							Sound.Parent =	v[1]
							Sound:Play()
							v[1].Parent = game.Workspace.InvisibleParts
							delay(1.7, function()
								GlassEffect:Destroy()
								Sound:Destroy()
							end)
							delay(120, function()
								Collection:AddTag(v[1], "Glass") 
								Collection:RemoveTag(v[1], "Ignore")
								v[1].Transparency = StartingTransparency
								v[1].CanCollide = StartingCollide
								v[1].Parent = StartingParent
							end)
						end)()
					end
				end
			end
			if v[1].Parent:FindFirstChild("Humanoid") then
				if tool:FindFirstChild("Class").Value == "TI26" then
					if FunctionService.isSeated(Humanoid) then
						return
					elseif v[1].Parent:FindFirstChild("Humanoid") and not FunctionService.isSeated(Humanoid) then
						local Humanoid = v[1].Parent and v[1].Parent:FindFirstChild("Humanoid") or v[1]
						if v[1].Parent.Humanoid.PlatformStand == false then
							coroutine.wrap(function()
								local sound = Instance.new("Sound");
								sound.Name = player.Name .. "_Sound"
								Humanoid.PlatformStand = true;
								local Part = Instance.new("Part");
								Part.Name = player.Name .. "_TasePart"
								Part.CanCollide = false;
								Part.Size = Vector3.new(0.05, 0.05, 0.05);
								Part.Transparency = 1
								Part.Anchored = true
								Part.Parent = workspace.InvisibleParts;
								Part.CFrame = v[1].Parent.Torso.CFrame;
								local Att = Instance.new("Attachment");
								Att.Name = "TaserAttachment";
								Att.Position = Vector3.new(0, 0.5, -2);
								Att.Parent = player.Character:FindFirstChild("HumanoidRootPart");
								local rope = Instance.new("RopeConstraint")
								rope.Parent = game:GetService("ServerScriptService").Services.FunctionService
								rope.Thickness = 0.01
								rope.Visible = true
								rope.Color = BrickColor.new("Institutional white")
								local CMP = rope:Clone()
								CMP.Parent = Att
								CMP.Attachment0 = Att
								CMP.Attachment1 = Instance.new("Attachment", Part)
								CMP.Enabled = true
								CMP.Length = (Humanoid.Parent:FindFirstChild("HumanoidRootPart").Position - player.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude + 0.5
								sound.MaxDistance = 150
								sound.SoundId = Asset.TaserSound
								sound.Looped = true
								sound.Parent = Humanoid.Parent:FindFirstChild("HumanoidRootPart")
								sound:Play()
								if Character then
									Remotes.TaserEvent:FireClient(Character, true)
								end;

								if Part and Humanoid.PlatformStand == true then
									delay(5, function()
										sound:Destroy()
										Att:Destroy()
										Part:Destroy()
										Remotes.TaserEvent:FireClient(Character, false)
										Remotes.TaserEvent:FireClient(player, false)
										Humanoid.PlatformStand = false
									end)
								end

								RegisterRemote("TaserEvent", function(player)
									sound:Destroy()
									Remotes.TaserEvent:FireClient(Character, false)
									Remotes.TaserEvent:FireClient(player, false)
									Humanoid.PlatformStand = false
									if workspace.InvisibleParts:FindFirstChild(player.Name .. "_TasePart") then
										workspace.InvisibleParts[player.Name .. "_TasePart"]:Destroy()
									end
								end)
							end)()
						end
					end
				end
				if Humanoid:IsA("Humanoid") and not CollectionService:HasTag(v[1], "Glass") then
					if ToolData.Type == "Firearm" or ToolData.Type == "Melee" then
						if table.find({ "Right Arm", "Left Arm", "Torso", "Head", "Right Leg", "Left Leg" }, v[1].Name) then
							if Humanoid.Health > 0 then
								Humanoid:TakeDamage(ToolData.BaseDamage * ToolData.Multipliers[v[1].Name][math.random(2)]);
								FunctionService.tagHumanoid(Humanoid, player, tool:FindFirstChild("Class").Value)
								if Humanoid.Health <= 0 and not VerifyService.CheckPermission(Character, "CanExemptKarma")  then
									KarmaLog(player, ToolData.Asset)
								end
							end
							return true
						else
							if Humanoid.Health > 0 then
								Humanoid:TakeDamage(ToolData.BaseDamage * ToolData.Multipliers.Torso[math.random(2)]);
								FunctionService.tagHumanoid(Humanoid, player, tool:FindFirstChild("Class").Value)
								if Humanoid.Health <= 0 and not VerifyService.CheckPermission(Character, "CanExemptKarma") then
									KarmaLog(player, ToolData.Asset)
								end
							end
							return true
						end
					end
				end
			end
			local Vehicles = require(game.ReplicatedStorage.Databases.Vehicles)
			coroutine.wrap(function()
				for _, v2 in pairs(game.Workspace.Vehicles:GetChildren()) do
					if v[1]:IsDescendantOf(v2) then
						if v2.Chassis:FindFirstChild("DriverL") then
							v2.Chassis.DriverL.Health.Value = v2.Chassis.DriverL.Health.Value-ToolsData[tool.Class.Value].BaseDamage
							if v2.Chassis.DriverL.Health.Value <= 250 then
								v2.Chassis.RootPart.Engine.Smoke.Enabled = true
							end
							if v2.Chassis.DriverL.Health.Value <= 0 then
								local OwnedVehicles = DataStore2("OwnedVehicles12", player)
								local RealOwnedVehicles = OwnedVehicles:GetTable({})
								for i,v in pairs(RealOwnedVehicles) do
									if v == v2.Name then 
										table.remove(RealOwnedVehicles, i)
										OwnedVehicles:Set(RealOwnedVehicles)
									end
								end
								local vdatabase = require(game.ReplicatedStorage.Databases.Vehicles)
								if vdatabase[v2.Name].Paintable ~= nil then
									local PaintDataStore = DataStore2(v2.Name .. "_PaintData999", player)
									local VehicleColor = PaintDataStore:Get()
									if VehicleColor then
										PaintDataStore:Set()
									end
								end
								local VehicleData = DataStore2(v2.Name.."_VehicleData50", v2.Chassis.DriverL.PlayerVal.Value)
								local Data = VehicleData:GetTable({})
								VehicleData:Set({})	
								VehicleService.ExplodeVehicle(player, v2)
							end

						end		
					end
				end
			end)()

			for h,r in ipairs(game.Workspace.Vehicles:GetChildren()) do
				if v[1]:IsDescendantOf(r) and not CollectionService:HasTag(v[1], "Glass") then
					for _,v in pairs(game.Players:GetPlayers()) do
						if v ~= player then
							game.ReplicatedStorage.Remotes.OnToolFire:FireClient(v, hitTable)
						end
					end
					return true
				end
			end
		end
		for _,v in pairs(game.Players:GetPlayers()) do
			if v ~= player then
				game.ReplicatedStorage.Remotes.OnToolFire:FireClient(v, hitTable)
			end
		end
	end
end)


RegisterRemote("ItemRequest", function(Player,Id,Item)
	if not PlayerService.Distance(Player, Id) then
		return;
	end;
	if not VerifyService.CanStoreItem(Player, Item) then
		return
	end
	if VerifyService.HaveItem(Player, Item) and not Items[Item].MultiTake then
		return
	end
	if Interactions[Id].Data.Type == "ItemRequest" and Interactions[Id].Data.Item == Item then
		FunctionService.GiveItem(Player, Item)
		Remotes.Notification:FireClient(Player,Items[Item].Name.." was added to your inventory.","Item Added!")
		if Items[Item].Type ~= "Magazine" then
			local jsonToSend = {
				embeds = {
					{
						title = "Log Event",
						type = "rich",
						description = Player.Name .. " has dispensed a " .. Items[Item].Name
					}
				}
			}
			WebService.SendJSON("DspLog", jsonToSend)
		end	
	end

end)


local DroppedItems = {}

RegisterRemote("DropInv", function(Player,ItemId)
	if not Player or not ItemId then return end
	if DroppedItems[ItemId] then
		return
	end

	DroppedItems[ItemId] = true

	local Inventory = FunctionService.GetPlayerInventory(Player)
	local ItemType
	local SaveAmmo

	for i,v in pairs(Inventory) do
		if v[1] == ItemId then
			ItemType = v[2]

			if v[3].Mag then
				if v[3].R then
					if v[3].R > 0 then
						if ToolsData[v[2]].Magazine then
							FunctionService.GiveItem(Player, v[3].Mag, nil, nil, nil, {R = v[3].R})
						else
							SaveAmmo = v[3].R
						end
					end
				end
			end

			if Items[ItemType].Rounds then
				SaveAmmo = v[3].R
				print(v[3].R)
			end
			break
		end
	end

	for i,v in pairs(Inventory) do
		if v[3].Mag then
			if v[3].Mag == ItemId then
				v[3].Mag = nil
			end
		end
	end


	if not VerifyService.HaveItem(Player, ItemType)  then
		return
	end

	--print(SaveAmmo)


	local Pos = (Player.Character.Torso.CFrame * CF(math.random(-3,3), 0, math.random(-3,3))).p
	local hit, pos, sur = FunctionService.DropRaycast(Pos, FunctionService.IgnoreDropList(Player.Character))
	local RayClone = game.ServerStorage.Items[Items[ItemType].Asset]:Clone()
	local InteractPart = game.ServerStorage.InteractionAddons.DroppedItem:Clone()

	FunctionService.RemoveItem(Player,ItemId)
	if hit then
		local Name = ItemType..tostring(math.random(0,9999))
		RayClone.Parent = workspace.InvisibleParts
		local origCFrame = CFrame.new(pos)
		local lookVector = CF(0,0,0)
		RayClone:SetPrimaryPartCFrame(origCFrame * (lookVector - lookVector.p) * CFANG(0, math.random(0,360), 0))
		InteractPart.Config.C.Value = ItemType
		InteractPart.Config.K.Value = RayClone

		InteractPart.Name = Name
		InteractPart.Position = RayClone.Root.Position
		InteractPart.Parent = game.Workspace.Interactions
		CollectionService:AddTag(InteractPart, "InteractDynamic")
		local Class = Instance.new("StringValue")
		Class.Parent = RayClone
		Class.Value = ItemType
		Class.Name = "Class"
		if SaveAmmo ~= nil then
			local AmmoValue = Instance.new("NumberValue")
			AmmoValue.Parent = RayClone
			AmmoValue.Value = SaveAmmo
			AmmoValue.Name = "Ammo"
		end
		local PlayerVal = Instance.new("StringValue")
		PlayerVal.Parent = RayClone
		PlayerVal.Value = Player.Name
		PlayerVal.Name = "Player"
		Interactions[Name] = {Id = Name,Data = {Type = InteractPart.Config.Type.Value,C = InteractPart.Config.C.Value,K = InteractPart.Config.K.Value},R = InteractPart.Config.R.Value,Part = InteractPart}
		local Data = {{Name,{Id = Name,Data = {Type = InteractPart.Config.Type.Value,C = InteractPart.Config.C.Value,K = InteractPart.Config.K.Value},R = InteractPart.Config.R.Value,Part = InteractPart}}}
		Remotes.InteractUpdate:FireAllClients(Data)
		DroppedItems[ItemId] = nil
		local jsonToSend = {
			embeds = {
				{
					title = "Log Event",
					type = "rich",
					description = Player.Name .. " has dropped a " .. Items[ItemType].Name,
				}
			}
		}
		WebService.SendJSON("DrpLog", jsonToSend)
		delay(120, function()
			if RayClone.Parent ~= nil then
				Data = {{Name,{}}}
				Remotes.InteractUpdate:FireAllClients(Data)
				Interactions[Name] = nil
				InteractPart:Destroy()
				RayClone:Destroy()
			end
		end)
	else
		RayClone.Parent = nil
	end
end)

RegisterRemote("PickupInv", function(Player,Id,Model)
	if not Model.Parent == game.Workspace.InvisibleParts then
		return
	end
	if workspace.Interactions:FindFirstChild(Id) then
		if (workspace.Interactions[Id].Position - Player.Character:WaitForChild("HumanoidRootPart").Position).magnitude <= 10 then
			local Item = Model:FindFirstChild("Class").Value
			local plrfound = Model:FindFirstChild("Player").Value
			local Data = {{Id,{}}}
			if not VerifyService.CanStoreItem(Player, Item) then
				return
			end
			local Ammunition

			if Model:FindFirstChild("Ammo") then
				Ammunition = Model:FindFirstChild("Ammo").Value
			end
			Remotes.InteractUpdate:FireAllClients(Data)
			Interactions[Id] = nil
			game.Workspace.Interactions[Id]:Destroy()
			if Ammunition ~= nil then
				FunctionService.GiveItem(Player, Item, nil, nil, nil, {R = Ammunition})
				print(Ammunition)
			else
				FunctionService.GiveItem(Player,Item)
			end
			Model:Destroy()
			local jsonToSend = {
				embeds = {
					{
						title = "Log Event",
						type = "rich",
						description = Player.Name .. " has picked up a " .. Items[Item].Name.." from "..plrfound..""
					}
				}
			}
			WebService.SendJSON("DrpLog", jsonToSend)
		else
			print("No interaction found for Id:", Id)
			return
		end
	end
end)

RegisterRemote("ItemPurchase", function(player, id, store, item)
	if not PlayerService.Distance(player, id) then
		return;
	end
	if not VerifyService.CanStoreItem(player, item) or VerifyService.HaveItem(player, item) and not Items[item].MultiTake  then
		Remotes.Notification:FireClient(player, "You don't have the space to hold this item.", "Purchase Failure!", "Red");
		return
	end

	local Stores = require(game.ReplicatedStorage.Databases.Stores)
	if Stores[store] then
		local Bank = VerifyService:GetData(player).Bank
		local Cash = VerifyService:GetData(player).Cash
		for i,v in pairs(Stores[store].Items) do
			if v[1] == item then
				if Stores[store].Accepts == 3 then
					if Stores[store].Accepts == 3 then
						if Cash >= v[2] then
							VerifyService:GetData(player).Cash=Cash-v[2]
						elseif Bank >= v[2] then
							VerifyService:GetData(player).Bank=Bank-v[2]
						end
						Remotes.Notification:FireClient(player, "You now own a "..Items[item].Name.."!", "Purchase Successful!")
						FunctionService.GiveItem(player, item)
						local jsonToSend = {
							embeds = {
								{
									title = "Log Event",
									type = "rich",
									description = player.Name .. " has purchased a " .. Items[item].Name .. " from " .. Stores[store].Name .. ""
								}
							}
						}
						WebService.SendJSON("DrpLog", jsonToSend)
					else
						Remotes.Notification:FireClient(player, "You don't have the funds to purchase this item.", "Purchase Failure!", "Red")
					end
				elseif Stores[store].Accepts == 2 then
					if Cash >= v[2] then
						VerifyService:GetData(player).Cash=Cash-v[2]
						local jsonToSend = {
							embeds = {
								{
									title = "Log Event",
									type = "rich",
									description = player.Name .. " has purchased a " .. Items[item].Name .. " from " .. Stores[store].Name .. ""
								}
							}
						}
						WebService.SendJSON("DrpLog", jsonToSend)
						Remotes.Notification:FireClient(player, "You now own a "..Items[item].Name.."!", "Purchase Successful!")
						FunctionService.GiveItem(player, item)
						break
					else
						Remotes.Notification:FireClient(player, "You don't have the funds to purchase this item.", "Purchase Failure!", "Red")
					end	
				end
			end
		end
	else
		print(store.." does not exist")
		return
	end
	RemoteService.UpdateMoney(player)
end)



RegisterRemote("WeaponLicense", function(Player, id)
	if not PlayerService.Distance(Player, id) then
		return;
	end;
	if not require(game.ServerScriptService.Services.VerifyService).GetPlayerData(Player).Citizen then
		Remotes.Notification:FireClient(Player, "You must be a citizen of the State of Discarded to purchase a weapon license.", "Purchase Failed!", "Red")
		return
	end
	local Data = VerifyService:GetData(Player)

	if os.time() <= Data.WeaponLicenseCooldown then
		print(Data.WeaponLicenseCooldown - os.time())
		print((Data.WeaponLicenseCooldown - os.time())/3600)
		Remotes.Notification:FireClient(Player, "Your license has been revoked, you must wait "..math.floor((Data.WeaponLicenseCooldown - os.time())/3600).." hours before purchasing a new one", "Purchase Unsuccessful!", "Red")
		return
	end 
	local Bank = VerifyService:GetData(Player).Bank
	local Cash = VerifyService:GetData(Player).Cash
	local TotalAmount = Bank + Cash
	if not VerifyService:GetData(Player).WeaponLicense then
		if Cash >= 300 then
			VerifyService:GetData(Player).Cash=Cash-300
			VerifyService:GetData(Player).WeaponLicense = true
			Remotes.Notification:FireClient(Player, "You have purchased a weapon license.", "Purchase Successful!")
			FunctionService.GiveItem(Player, "FOID")
			local jsonToSend = {
				embeds = {
					{
						title = "Log Event",
						type = "rich",
						description = Player.Name .. " has purchased a weapon's license",
					}
				}
			}
			WebService.SendJSON("DrpLog", jsonToSend)
		elseif Bank >= 300 then
			VerifyService:GetData(Player).Bank=Bank-300
			VerifyService:GetData(Player).WeaponLicense = true
			Remotes.Notification:FireClient(Player, "You have purchased a weapon license.", "Purchase Successful!")
			FunctionService.GiveItem(Player, "FOID")
			local jsonToSend = {
				embeds = {
					{
						title = "Log Event",
						type = "rich",
						description = Player.Name .. " has purchased a weapon's license",
					}
				}
			}
			WebService.SendJSON("DrpLog", jsonToSend)
		else
			Remotes.Notification:FireClient(Player, "You don't have enough money to complete this transaction.", "Purchase Unsuccessful!", "Red")
		end
	else
		Remotes.Notification:FireClient(Player, "You already own a weapon's license.", "Purchase Unsuccessful!", "Red")
	end
	RemoteService.UpdateMoney(Player)
	Remotes.RolesChanged:FireClient(Player, require(game.ServerScriptService.Services.VerifyService).GetPlayerData(Player))
end)

RegisterRemote("ToolAbility",function(Player,Index, Tool)
	ToolsData[Tool.Class.Value].Abilities[Index].Function(Tool)
end)



--RegisterRemote("Handcuff", function(CalledPlayer,ArgPlayer,Bool)
--	if Players:FindFirstChild(ArgPlayer.Name) and not (Util.GetDistanceBetweenPlayers(CalledPlayer, ArgPlayer) < 10) then
--		return
--	end
--	if (CalledPlayer.Character:FindFirstChild("HumanoidRootPart").Position - ArgPlayer.Character:FindFirstChild("HumanoidRootPart").Position).magnitude > 8 then return end

--	if CalledPlayer ~= ArgPlayer and FunctionService.CanCuff(CalledPlayer)  and  VerifyService.CheckPermission(CalledPlayer, "CanCuff") and VerifyService.CheckPermission(CalledPlayer, "CanInteractTeams", FunctionService.GetTeamFromColor(ArgPlayer))then
--		if Bool == true then

--			local CuffValue = Instance.new("ObjectValue", game:GetService("ServerScriptService").Data)
--			CuffValue.Name = ArgPlayer.UserId .. "_HandcuffData"
--			CuffValue.Value = CalledPlayer
--			local Name = "Handcuffs"
--			local NewInventory = {}
--			local Handcuffs = {Items.Handcuffs.Name,{Name,Name},true}
--			local Folder = Instance.new("Folder")
--			Folder.Name = ArgPlayer.UserId .. "_Tools"
--			Folder.Parent = game:GetService("ServerScriptService").Data
--			table.insert(NewInventory,#NewInventory+1,Handcuffs)
--			for i,v in pairs(ArgPlayer.Backpack:GetChildren()) do
--				v.Parent = Folder
--			end
--			local Model = Tools.Handcuffs:Clone()
--			Model.Parent = ArgPlayer.Backpack
--			Remotes.UpdateInv:FireClient(ArgPlayer,NewInventory)

--		end
--		if Bool == false then
--			if ArgPlayer.Character:FindFirstChild("Grabbed") then
--				ArgPlayer.Character.Grabbed.Value:FindFirstChild("Grabbing"):Destroy()
--				ArgPlayer.Character.Grabbed:Destroy()
--			end
--			if game:GetService("ServerScriptService").Data:FindFirstChild(ArgPlayer.UserId .. "_HandcuffData") then
--				game:GetService("ServerScriptService").Data:FindFirstChild(ArgPlayer.UserId .. "_HandcuffData"):Destroy()
--			end
--			local Name = "Handcuffs"
--			local NewInventory = {}
--			local Handcuffs = {Items.Handcuffs.Name,nil,false}
--			table.insert(NewInventory,#NewInventory+1,Handcuffs)
--			Remotes.UpdateInv:FireClient(ArgPlayer,NewInventory)
--			if ArgPlayer.Character:FindFirstChild("Handcuffs") then
--				ArgPlayer.Character.Handcuffs:Destroy()
--			end
--			for i,v in pairs(ArgPlayer.Backpack:GetChildren()) do
--				if v:FindFirstChild("Class") then
--					if v.Class.Value == "Handcuffs" then
--						v:Destroy()
--					end
--				end
--			end
--			for i,v in pairs(game:GetService("ServerScriptService").Data:FindFirstChild(ArgPlayer.UserId .. "_Tools"):GetChildren()) do
--				v.Parent = ArgPlayer.Backpack
--			end
--		end
--	end
--end)



return ToolService

  services.vehicleservice
  local VehicleService = {}
local Players = game:GetService("Players")
local Crimes = require(game:GetService("ReplicatedStorage").Databases.Crimes)
local DataStore2 = require(script.Parent.Parent.MainModule)
local Remotes = game.ReplicatedStorage.Remotes
local Items = require(game.ReplicatedStorage.Databases.Items)
local VerifyService = require(game.ServerScriptService.Services.VerifyService)
local FunctionService = require(game.ServerScriptService.Services.FunctionService)
local PlayerService = require(game.ServerScriptService.Services.PlayerService)
local VehicleConfigData = game:GetService("DataStoreService"):GetDataStore("ConfigurationVehicle_2")
local DataStoreService = game:GetService("DataStoreService")
local CollectionService = game:GetService("CollectionService")
local Dealerships = require(game.ReplicatedStorage.Databases.Dealerships)
local GlobalVehicles = PlayerService.GlobalVehicles
local Interactions = PlayerService.Interactions
local warrants = {}
_G.DisableCars = false
local InteractionAddons = game.ServerStorage.InteractionAddons
local NumberOfVehicles = 0
local RemoteService = require(game.ServerScriptService.Services.RemoteService)
function RegisterRemote(name, callback)
	RemoteService.RegisterRemote(name, callback)
end
function ExplodeVehicle(player, v2)
	if game:GetService("ServerScriptService").Data:FindFirstChild(v2:FindFirstChild("Chassis").DriverL.PlayerVal.Value.UserId .. "_" .. v2.Name .. "BlowupData") then
		return true
	end
	local BlowupData = Instance.new("ObjectValue")
	BlowupData.Name = v2:FindFirstChild("Chassis").DriverL.PlayerVal.Value.UserId .. "_" .. v2.Name .. "BlowupData"
	BlowupData.Value = v2
	BlowupData.Parent = game:GetService("ServerScriptService").Data
	delay(14, function()
		BlowupData:Destroy()
	end)
	delay(10, function()
		v2:Destroy()
	end)
	Remotes.Notification:FireClient(v2:FindFirstChild("Chassis").DriverL.PlayerVal.Value, "Your "..require(game.ReplicatedStorage.Databases.Vehicles)[v2:FindFirstChild("Chassis").DriverL.Id.Value].Name.." has been destroyed, you must purchase a new one.", "Vehicle Destroyed!", "Red", true)
	v2:FindFirstChild("Chassis").RootPart.Engine.Fire.Enabled = true
	v2:FindFirstChild("Chassis").RootPart.Engine.Smoke.Enabled = false
	wait(4)
	for _,p in pairs(v2:FindFirstChild("Chassis"):GetChildren()) do
		if p.ClassName == "VehicleSeat" then
			if p.Occupant ~= nil then
				p.Occupant:TakeDamage(100)
			end
		end
	end
	for _, Players in pairs(game.Players:GetChildren()) do
		if v2:FindFirstChild("Chassis"):FindFirstChild("RootPart") then
			if	Players:DistanceFromCharacter(v2:FindFirstChild("Chassis").RootPart.Position) <= 15 then
				if player.Character:FindFirstChild("Humanoid") then
					Players.Character.Humanoid:TakeDamage(100)
				end
			end
		end
	end
	for _,h in pairs(v2.Body:GetDescendants()) do
		if h.ClassName == "MeshPart" or h.ClassName == "Part" or h.ClassName == "UnionOperation" then
			h.Material = Enum.Material.CorrodedMetal
		end
	end
	pcall(function()
		v2:FindFirstChild("Chassis").FL:Destroy()
		v2:FindFirstChild("Chassis").FR:Destroy()
		v2:FindFirstChild("Chassis").RL:Destroy()
		v2:FindFirstChild("Chassis").RR:Destroy()
	end)
	v2:FindFirstChild("Chassis").RootPart.ExplodeSound:Play()
	local Explosion = Instance.new("Explosion")
	Explosion.DestroyJointRadiusPercent = 0
	Explosion.Visible = true
	Explosion.BlastPressure = 300000
	Explosion.ExplosionType = Enum.ExplosionType.NoCraters
	Explosion.BlastRadius = 12
	Explosion.Position = v2:FindFirstChild("Chassis").RootPart.Position
	Explosion.Parent = game.Workspace.InvisibleParts
	delay(2, function()
		Explosion:Destroy()
	end)
	--for _, vehicle in pairs(workspace.Vehicles:GetChildren()) do
	--	if vehicle:FindFirstChild("Chassis") then
	--		if vehicle.Chassis:FindFirstChild("RootPart") then
	--			if vehicle ~= v2 then
	--				if (v2:FindFirstChild("Chassis").RootPart.Position - vehicle.Chassis:FindFirstChild("RootPart").Position).magnitude <= 15 then
	--					local Explosion = Instance.new("Explosion")
	--					Explosion.DestroyJointRadiusPercent = 0
	--					Explosion.Visible = true
	--					Explosion.BlastPressure = 500000
	--					Explosion.ExplosionType = Enum.ExplosionType.NoCraters
	--					Explosion.BlastRadius = 8
	--					Explosion.Position = vehicle.Chassis.RootPart.Position
	--					Explosion.Parent = game.Workspace.InvisibleParts
	--					local NewPlayer = vehicle.Chassis.DriverL.PlayerVal.Value
	--					ExplodeVehicle(NewPlayer, vehicle)
	--				end
	--			end
	--end
	--end
	--end
end

RegisterRemote("VehicleRefuel", function(player,intId, gasAmount, model, amount, isJerry)

	local vehicleData = require(game.ReplicatedStorage.Databases.Vehicles)[model.Name]
	local GasTank = model.Chassis.DriverL.GasTank
	local diff = math.floor(vehicleData.GasTank - GasTank.Value)
	local Bank = VerifyService:GetData(player).Bank
	local Cash = VerifyService:GetData(player).Cash
	if amount ~= nil then
		local price = math.floor(amount * require(game.ReplicatedStorage.Databases.Constants).GasPrice)
		if Bank < price then
			game.ReplicatedStorage.Remotes.Notification:FireClient(player,'You can\'t afford to refuel your vehicle.','Vehicle Refuel!','Red')
		else
			local AmountLeft = Bank - price
			if not isJerry then VerifyService:GetData(player).Bank = AmountLeft end
			GasTank.Value = GasTank.Value + amount
			game.ReplicatedStorage.Remotes.Notification:FireClient(player,'Refueled vehicle by '..amount..' units.','Vehicle Refuel!')
		end
	else
		local price = math.floor(diff * require(game.ReplicatedStorage.Databases.Constants).GasPrice)
		if Bank < price then
			game.ReplicatedStorage.Remotes.Notification:FireClient(player,'You can\'t afford to refuel your vehicle.','Vehicle Refuel!','Red')
		else
			local AmountLeft = Bank - price
			if not isJerry then Bank = AmountLeft end
			GasTank.Value = GasTank.Value + diff
			game.ReplicatedStorage.Remotes.Notification:FireClient(player,'Refueled vehicle by '..diff..' units.','Vehicle Refuel!')
		end
	end
	RemoteService.UpdateMoney(player)
end)

RegisterRemote("RefillJerry", function(player, id, currentAmount)
	local diff = math.floor(Items.Jerrycan.Attributes.R - currentAmount)
	local Bank = VerifyService:GetData(player).Bank
	local Cash = VerifyService:GetData(player).Cash
	local price = math.floor(diff * require(game.ReplicatedStorage.Databases.Constants).GasPrice)
	if Bank < price then
		game.ReplicatedStorage.Remotes.Notification:FireClient(player,'You can\'t afford to refuel your jerrycan.','Jerry Refill!','Red')
		RemoteService.UpdateMoney(player)
		return false
	else
		VerifyService:GetData(player).Bank = Bank-price
		game.ReplicatedStorage.Remotes.Notification:FireClient(player,'Refilled jerrycan by '..diff..' units.','Jerry Refill!')
		RemoteService.UpdateMoney(player)
		return true
	end
end)

RegisterRemote("VehicleRepair", function(player, id, seat, amount, shop, sound)
	if not PlayerService.Distance(player, id) then
		return;
	end;
	local Vehicles = require(game.ReplicatedStorage.Databases.Vehicles)
	local Constants = require(game.ReplicatedStorage.Databases.Constants)
	local diff = Vehicles[seat.Parent.Parent.Name].MaxHealth - seat.Health.Value
	local Bank = VerifyService:GetData(player).Bank
	local Cash = VerifyService:GetData(player).Cash


	if amount == nil then
		local price = math.floor(math.floor(diff) * require(game.ReplicatedStorage.Databases.Constants).RepairPrice)
		if Bank < price then
			game.ReplicatedStorage.Remotes.Notification:FireClient(player,'You can\'t afford to repair your vehicle.','Vehicle Repair!','Red')
		else
			local AmountLeft = Bank - price
			VerifyService:GetData(player).Bank = AmountLeft
			RemoteService.UpdateMoney(player)
			seat.Health.Value = Vehicles[seat.Parent.Parent.Name].MaxHealth
			seat.Parent.RootPart.Engine.Smoke.Enabled = false
			game.ReplicatedStorage.Remotes.Notification:FireClient(player,'Repaired vehicle by '..diff..' units.','Vehicle Repair!')

			wait(0.1)
		end
	else
		local price = math.floor(math.floor(diff) * require(game.ReplicatedStorage.Databases.Constants).RepairPrice)
		if Bank < price then
			game.ReplicatedStorage.Remotes.Notification:FireClient(player,'You can\'t afford to repair your vehicle.','Vehicle Repair!','Red')
		else
			local AmountLeft = Bank - price
			VerifyService:GetData(player).Bank = AmountLeft
			RemoteService.UpdateMoney(player)
			seat.Health.Value = seat.Health.Value + amount
			seat.Parent.RootPart.Engine.Smoke.Enabled = false
			game.ReplicatedStorage.Remotes.Notification:FireClient(player,'Repaired vehicle by '..amount..' units.','Vehicle Repair!')

			wait(0.1)
		end
	end
	for i,v in pairs(game.Workspace.Buildings:GetDescendants()) do
		if v.Name == shop then
			for h,t in pairs(v:GetDescendants()) do
				if t:IsA("Sound") then
					t:Play()
				end
			end
		end
	end
end)


local PaintColors = require(game.ReplicatedStorage.Databases.Vehicles.PaintColors)
local Constants = require(game.ReplicatedStorage:WaitForChild("Databases").Constants)
RegisterRemote("VehicleRepaint", function(Player, Id, Seat, Shop)
	if not PlayerService.Distance(Player, Id) then
		return;
	end;
	local Bank = VerifyService:GetData(Player).Bank
	local Cash = VerifyService:GetData(Player).Cash
	if Cash >= 20 then
		VerifyService:GetData(Player).Cash = Cash-20
		local Color = PaintColors[math.random(#PaintColors)];
		local Uwu = Color.Color
		if Seat.Parent.Parent.Body:FindFirstChild("Paint")  then
			delay(0.05, function()
				for i,v in pairs(Seat.Parent.Parent.Body.Paint:GetChildren()) do
					v.Color = Uwu
				end

				local PaintDataStore = DataStore2(Seat.Parent.Parent.Name .. "_PaintData999", Player)
				PaintDataStore:Set(tostring(Color))
			end)
		end
		for i,v in pairs(game.Workspace.Buildings:GetDescendants()) do
			if v.Name == Shop then
				for h,t in pairs(v:GetDescendants()) do
					local ape = Uwu

					if t:IsA("ParticleEmitter") then
						t.Color = ColorSequence.new(ape)
						t:Emit(50)
					end
					if t:IsA("Sound") then
						t:Play()
						wait(0.1)
					end
				end
			end
		end
	elseif Bank >= 20 then
		VerifyService:GetData(Player).Bank = Bank-20
		local Color = PaintColors[math.random(#PaintColors)];
		local Uwu = Color.Color
		if Seat.Parent.Parent.Body:FindFirstChild("Paint")  then
			delay(0.05, function()
				for i,v in pairs(Seat.Parent.Parent.Body.Paint:GetChildren()) do
					v.Color = Uwu
				end

				local PaintDataStore = DataStore2(Seat.Parent.Parent.Name .. "_PaintData999", Player)
				PaintDataStore:Set(tostring(Color))
			end)
		end
		for i,v in pairs(game.Workspace.Buildings:GetDescendants()) do
			if v.Name == Shop then
				for h,t in pairs(v:GetDescendants()) do
					local ape = Uwu

					if t:IsA("ParticleEmitter") then
						t.Color = ColorSequence.new(ape)
						t:Emit(50)
					end
					if t:IsA("Sound") then
						t:Play()
						wait(0.1)
					end
				end
			end
		end
	end
	RemoteService.UpdateMoney(Player)
end)
local VehicleConfigData = DataStoreService:GetDataStore("ConfigurationVehicle_2")

RegisterRemote("SpawnVehicle", function(Player, Id, Vehicle, SpawnSet)
	if not _G.DisableCars then
		local VerifyService = require(game.ServerScriptService.Services.VerifyService)
		local FunctionService = require(game.ServerScriptService.Services.FunctionService)
		local Vehicles = require(game.ReplicatedStorage.Databases.Vehicles)
		local PlayerVehicles = FunctionService.PlayerAvailableVehicles(Player, nil, true)
		if not table.find(PlayerVehicles, Vehicle) then return end
		for i,v in pairs(GlobalVehicles) do
			NumberOfVehicles = NumberOfVehicles+1
		end
		local CarF = NumberOfVehicles*50
		local CarID = 3000+CarF
		local ObstructedPads = 0
		local SpawnPad
		for i,v in pairs(game.Workspace.Surface[SpawnSet]:GetChildren()) do
			if FunctionService.CheckSpawnObstruction(v,{game.Workspace.InvisibleParts,game.Workspace.Buildings,game.Workspace.Surface}) ~= true then
				ObstructedPads = ObstructedPads+1
			else
				SpawnPad = v
				break
			end
		end
		local Vehicles = require(game.ReplicatedStorage.Databases.Vehicles)
		local VehicleModel = game.ServerStorage.Vehicles[Vehicles[Vehicle].Asset]:Clone()
		if game.ServerStorage.Vehicles:FindFirstChild(Vehicle) ~= nil or game.ServerStorage.Vehicles:FindFirstChild(Vehicle):IsA("Model") then
			for v92, v93 in ipairs(workspace.Vehicles:GetChildren()) do
				pcall(function()
					if v93.Chassis.DriverL.PlayerVal.Value == Player and v93.Chassis.DriverL.Health.Value > 0 then
						v93:Destroy();
					end;
				end);
			end
			if ObstructedPads == #game.Workspace.Surface[SpawnSet]:GetChildren() then
				Remotes.Notification:FireClient(Player,"All spawn pads are obstructed.","Spawn Unsuccessful!","Red")
				return
			end
			VehicleModel:SetPrimaryPartCFrame(SpawnPad.CFrame * CFrame.new(0,3,0))
			GlobalVehicles[CarID] = {
				Interactions = {},
				Model = VehicleModel,
				Inventory = {},
				Owner = Player,
				Plate = FunctionService.GetLicensePlate(Player)
			}
			Remotes.Notification:FireClient(Player,"Your "..Vehicles[Vehicle].Name.." has been spawned.","Vehicle Spawned!")
			VehicleModel.Chassis.DriverL.Id.Value = Vehicles[Vehicle].Asset
			CollectionService:AddTag(VehicleModel.Chassis.DriverL, "VehicleSeat")
			local Colors = require(game:GetService("ReplicatedStorage").Databases.Vehicles.PaintColors)
			local Color = Colors[math.random(1, 39)]
			local Colours = require(game:GetService("ReplicatedStorage").Databases.Vehicles.DealershipPaintColors)
			local Colour = Colours[math.random(1, 3)]
			local PaintDataStore = DataStore2(Vehicle .. "_PaintData999", Player)
			local VehicleColor = PaintDataStore:Get()
			if VehicleColor then
				for i,v in pairs(VehicleModel.Body:FindFirstChild("Paint"):GetChildren()) do
					if Vehicles[Vehicle].Color then
						v.BrickColor = Vehicles[Vehicle].Color
					elseif Vehicles[Vehicle].Paintable and Vehicles[Vehicle].Paintable == true then
						v.BrickColor = BrickColor.new(VehicleColor)
					end
				end
			end
			if not VehicleColor then
				PaintDataStore:Set(tostring(Colour))
				VehicleColor = tostring(Colour)
			end
			--local GetConfiguration = VehicleConfigData:GetAsync(Player.UserId.."_"..Vehicle)
			--if GetConfiguration ~= nil then
			--	print(GetConfiguration.Health, GetConfiguration.Gas)
			--	if VehicleModel.Chassis.DriverL.Health.Value <= 250 then
			--		VehicleModel.Chassis.RootPart.Engine.Smoke.Enabled = true
			--	end
			--	VehicleModel.Chassis.DriverL.GasTank.Value = tonumber(GetConfiguration.Gas)
			--	VehicleModel.Chassis.DriverL.Health.Value = tonumber(GetConfiguration.Health)
			--	else
			--	VehicleModel.Chassis.DriverL.GasTank.Value = Vehicles[Vehicle].GasTank
			--	VehicleModel.Chassis.DriverL.Health.Value = Vehicles[Vehicle].MaxHealth
			--end
			VehicleModel.Chassis.DriverL.GasTank.Value = Vehicles[Vehicle].GasTank
			VehicleModel.Chassis.DriverL.Health.Value = Vehicles[Vehicle].MaxHealth
			if VerifyService.CheckPermission(Player, "CanSpawnVehicle", Vehicle) then
				VehicleModel.Chassis.DriverL.GasTank.Value = Vehicles[Vehicle].GasTank
				VehicleModel.Chassis.DriverL.Health.Value = Vehicles[Vehicle].MaxHealth
				VehicleModel.Chassis.RootPart.Engine.Smoke.Enabled = false
			end

			for i,v in pairs(VehicleModel.Body:GetDescendants()) do
				if v:IsA("Weld") or v:IsA("WeldConstraint")  then
					v.Parent = VehicleModel.Chassis.RootPart
					v.Name = "Weld"
				elseif v:IsA("CFrameValue") then
					v:Destroy()
				end
			end

			VehicleModel.Chassis.RootPart.Massless = false

			VehicleModel.Chassis.DriverL.PlayerVal.Value = Player

			VehicleModel.Parent = game.Workspace.Vehicles
			for i,v in pairs(VehicleModel.Chassis:GetDescendants()) do
				if v.ClassName == "MeshPart" or v.ClassName == "Part" or v.ClassName == "UnionOperation" then
					v:SetNetworkOwner()
					game.PhysicsService:SetPartCollisionGroup(v,"CHASSIS")
				end
			end
			for i,v in pairs(VehicleModel.Body:GetDescendants()) do
				if v.ClassName == "MeshPart" or v.ClassName == "Part" or v.ClassName == "UnionOperation" then
					v:SetNetworkOwner()
					v.Massless = true
				end
			end

			for i,v in pairs(VehicleModel.Body:GetDescendants()) do
				if v.ClassName == "MeshPart" or v.ClassName == "Part" or v.ClassName == "UnionOperation" then
					game.PhysicsService:SetPartCollisionGroup(v,"BODY")
					if  v.ClassName == "MeshPart" then
						CollectionService:AddTag(v,"Ignore")
					end
					if v.Name == "Paint" then
						CollectionService:AddTag(v,"Ignore")
					end
					if v.Name == "SteeringWheel" then
						CollectionService:AddTag(v,"Ignore")
					end
					if v.Name == "Paint" then
						CollectionService:AddTag(v,"Ignore")
					end
					if v.Name == "Interior" then
						CollectionService:AddTag(v,"Ignore")
					end
					if v.Name == "Body" then
						CollectionService:AddTag(v,"Ignore")
					end
					if v.Name == "CollisionPart" then
						CollectionService:RemoveTag(v,"Glass")
						CollectionService:RemoveTag(v,"Ignore")			
					end 
				end
			end




			for _,d in pairs(VehicleModel.Body:GetDescendants()) do
				if d.ClassName == "MeshPart" or d.ClassName == "Part" or d.ClassName == "UnionOperation" then
					if d.Name == "SmashableGlass" or  d.Name == "Windows" or  d.Name == "Window" or d.Name == "Glass" or d.Name == "WindowPart" or d.Name == "Windshield" or d.Name == "Windshield"  then
						CollectionService:AddTag(d, "Glass")
						CollectionService:RemoveTag(d,"Ignore")	
					end 
				end
			end


			for i,v in pairs(VehicleModel.Body:GetDescendants()) do
				if v.Name == "CarNumber" then
					v.NumberGui.NumberLabel.Text = FunctionService.GetRoofTop(Player)
				end
			end
			for i,v in pairs(VehicleModel.Body:GetChildren()) do
				if v.Name == "LicensePlate" then
					v.PlateGui.PlateLabel.Text = FunctionService.GetLicensePlate(Player)
				end
			end
			for i,v in pairs(VehicleModel.Chassis:GetChildren()) do
				if v.ClassName == "VehicleSeat" then
					game.PhysicsService:SetPartCollisionGroup(v,"CHASSIS")
					CollectionService:AddTag(v, "VehicleSeat")
					v.Massless = true
					local Ints = GlobalVehicles[CarID].Interactions
					local Meh = #Ints+1
					GlobalVehicles[CarID].Interactions[Meh] = {VehicleModel.Chassis.RootPart[v.Name],CarID+Meh,"Seat",v.Name}
				end
			end	
			for i,v in pairs(VehicleModel.Chassis:GetDescendants()) do
				if v.Name == "WheelPart" then
					CollectionService:AddTag(v, "Ignore")
					game.PhysicsService:SetPartCollisionGroup(v,"CHASSIS")
				end
			end
			local Ints = GlobalVehicles[CarID].Interactions
			if VehicleModel.Chassis.RootPart:FindFirstChild("Inventory") then
				local Meh = #Ints+1
				GlobalVehicles[CarID].Interactions[Meh] = {VehicleModel.Chassis.RootPart.Inventory,CarID+Meh,"Inventory"}
			end
			if VehicleModel.Chassis.RootPart:FindFirstChild("Gas") then
				local Meh = #Ints+1
				GlobalVehicles[CarID].Interactions[Meh] = {VehicleModel.Chassis.RootPart.Gas,CarID+Meh,"Gas"}
			end

			for i,v in pairs(GlobalVehicles[CarID].Interactions) do
				local Position = v[1].WorldPosition
				local Id = tostring(v[2])												
				local Int = v[3]
				if Int == "Seat" then
					local NewInteraction = InteractionAddons.VehicleSeat:Clone()

					NewInteraction.Name = Id
					NewInteraction.Config.Seat.Value = VehicleModel.Chassis[v[1].Name] 
					NewInteraction.Position = Position
					NewInteraction.Parent = workspace.Interactions
					local Weld = Instance.new("WeldConstraint")
					Weld.Parent = NewInteraction
					Weld.Part0 = VehicleModel.Chassis.RootPart
					Weld.Part1 = NewInteraction
					--print(NewInteraction.Config.Seat.Value)
					CollectionService:AddTag(NewInteraction, "InteractDynamic")
					Interactions[Id] = {Id = Id, Data = {Type = NewInteraction.Config.Type.Value, Seat = NewInteraction.Config.Seat.Value}, R = NewInteraction.Config.R.Value, Part = NewInteraction}
					local Data = {{[1] = Id, [2] = {Id = Id, Data = {Type = NewInteraction.Config.Type.Value, Seat = NewInteraction.Config.Seat.Value, SeatName = NewInteraction.Config.Seat.Value.Name}, R = NewInteraction.Config.R.Value, Part = v[1]}}}

					Remotes.InteractUpdate:FireAllClients(Data)
				end
				if Int == "Inventory" then
					local NewInteraction = InteractionAddons.VehicleInv:Clone()

					NewInteraction.Name = Id
					NewInteraction.Config.Seat.Value = VehicleModel.Chassis.DriverL
					NewInteraction.Position = Position
					NewInteraction.Parent = game.Workspace.Interactions
					local Weld = Instance.new("WeldConstraint")
					Weld.Parent = NewInteraction
					Weld.Part0 = VehicleModel.Chassis.RootPart
					Weld.Part1 = NewInteraction
					CollectionService:AddTag(NewInteraction, "InteractDynamic")
					Interactions[Id] = {Data = {Type = NewInteraction.Config.Type.Value,Seat = NewInteraction.Config.Seat.Value,Inventory = true},R = NewInteraction.Config.R.Value,Part = NewInteraction}
					local Data = {{[1] = Id,[2] = {Data = {Type = NewInteraction.Config.Type.Value,Seat = NewInteraction.Config.Seat.Value,Inventory = true},R = NewInteraction.Config.R.Value,Part = NewInteraction}}}
					Remotes.InteractUpdate:FireAllClients(Data)
				end
				if Int == "Gas" then
					local NewInteraction = InteractionAddons.GasInv:Clone()

					NewInteraction.Name = Id
					NewInteraction.Config.Seat.Value = VehicleModel.Chassis.DriverL
					NewInteraction.Position = Position
					NewInteraction.Parent = game.Workspace.Interactions
					local Weld = Instance.new("WeldConstraint")
					Weld.Parent = NewInteraction
					Weld.Part0 = VehicleModel.Chassis.RootPart
					Weld.Part1 = NewInteraction
					CollectionService:AddTag(NewInteraction, "InteractDynamic")
					Interactions[Id] = {Data = {Type = NewInteraction.Config.Type.Value,Seat = NewInteraction.Config.Seat.Value,Gas = true},R = NewInteraction.Config.R.Value,Part = NewInteraction}
					local Data = {{[1] = Id,[2] = {Data = {Type = NewInteraction.Config.Type.Value,Seat = NewInteraction.Config.Seat.Value,Gas = true},R = NewInteraction.Config.R.Value,Part = NewInteraction}}}
					Remotes.InteractUpdate:FireAllClients(Data)
				end
			end
			local VehicleData = DataStore2(Vehicle.."_VehicleData50", Player)
			if Vehicles[Vehicle].Inventory ~= nil then
				VehicleData:Set({})
				for i,v in pairs(Vehicles[Vehicle].Inventory) do
					for number = 1, v[2] do
						FunctionService.AddToCarInventory(Player, VehicleModel.Chassis.DriverL.PlayerVal.Value, VehicleModel, v[1])	
					end
				end	
			end

			--SpawnedVehicles[Player] = nil
			VehicleModel.Chassis.DriverL.Changed:Connect(function(prop)
				if prop == "Occupant" then
					local humanoid = VehicleModel.Chassis.DriverL.Occupant
					if humanoid then
						local player = game:GetService("Players"):GetPlayerFromCharacter(humanoid.Parent)
						if player then
							VehicleModel.Chassis.DriverL:SetNetworkOwner(player)
						end
					else
						VehicleModel.Chassis.DriverL:SetNetworkOwner()
					end
				end
			end)
		end

	end
end)

game.Workspace.Vehicles.ChildRemoved:Connect(function(Car)
	if Car.Chassis:FindFirstChild("DriverL") then
		local Owner = Car.Chassis.DriverL.PlayerVal.Value
		for i,v in pairs(GlobalVehicles) do
			if v.Owner == Owner then
				for _,g in pairs(v.Interactions) do
					Interactions[g[2]] = nil
					local Data = {{[1] = g[2],[2] = nil}}
					Remotes.InteractUpdate:FireAllClients(Data)
				end
				Remotes.Notification:FireClient(Owner,"Your previous vehicle has been removed.","Vehicle Removed!")
				GlobalVehicles[i] = nil
			end
		end
		for i,v in pairs(game.Workspace.Vehicles:GetChildren()) do
			if v:FindFirstChild("Chassis") then
				if v.Chassis:FindFirstChild("DriverL") then
					if v.Chassis.DriverL.PlayerVal.Value == Owner then
						local VehicleData = DataStore2(v.Name.."_VehicleData50", Owner)
						VehicleData:Set({})
					end
				end
			end
		end
	else
		for i,v in pairs(GlobalVehicles) do
			if v.Plate == Car.Body.LicensePlate.PlateGui.PlateLabel.Text then
				for _,g in pairs(v.Interactions) do
					Interactions[g[2]] = nil
					local Data = {{[1] = g[2],[2] = nil}}
					Remotes.InteractUpdate:FireAllClients(Data)
				end
				GlobalVehicles[i] = nil
			end
		end
	end
end)

local StoredItems = {}
RegisterRemote("VehicleItem", function(Plr, Model, item, sepInv)	
	if not Model and not item then
		return
	end 
	if VerifyService.CheckPermission(Plr, "CanArrest") and FunctionService.GlassOk(Model:FindFirstChild("Chassis").DriverL) or Model:FindFirstChild("Chassis").DriverL.PlayerVal.Value == Plr or VerifyService.CheckPermission(Plr, "CanSpawnVehicle", Model.Name) then
		if not item then
			if Model then
				Remotes.VehicleItem:FireClient(Plr, Model, FunctionService.GetCarInventory(Model:FindFirstChild("Chassis").DriverL.PlayerVal.Value, Model))
			end
		else
			if StoredItems[item] then
				return
			end
			StoredItems[item] = true
			local VehicleData = DataStore2(Model.Name.."_VehicleData50", Model:FindFirstChild("Chassis").DriverL.PlayerVal.Value)
			local Data = VehicleData:GetTable({})
			local Item
			for i,v in pairs(FunctionService.GetPlayerInventory(Plr)) do
				if v[1] == item then
					Item = {
						Class = {
							Value = v[2]
						}
					}
				end
			end
			if Item then
				for i,v in pairs(FunctionService.GetPlayerInventory(Plr)) do
					if v[1] == item then
						if Items[v[2]].NoDrop then
							return
						end
						FunctionService.AddToCarInventory(Plr, Model:FindFirstChild("Chassis").DriverL.PlayerVal.Value, Model, Item.Class.Value, item, v[3])
						StoredItems[item] = nil
						local jsonToSend = { embeds = { { title = "Transfer Event", type = "rich", description = Plr.Name .. " has transferred a " .. Items[v[2]].Name .. " to  "..tostring(Model:FindFirstChild("Chassis").DriverL.PlayerVal.Value).."'s " ..require(game.ReplicatedStorage.Databases.Vehicles)[Model:FindFirstChild("Chassis").DriverL.Id.Value].Name } } }
						require(game:GetService("ServerScriptService").Services.WebService).SendJSON("VehicleTransferLog", jsonToSend)
					end
				end
			else
				for i,v in pairs(Data) do
					if v[1] == item then
						for i2,v2 in pairs(Plr.Backpack:GetChildren()) do
							if v2:IsA("Configuration") and v2:FindFirstChild("Class") then
								if not Items[v[2]].MultiTake and v2.Class.Value == v[2] then
									return 
								end
								if Items[v[2]].NoDrop then
									return
								end
							end
						end
						local Attributes = v[3] ~= nil and v[3] or {}
						if not Attributes.Q then
							table.remove(Data, i)
							FunctionService.GiveItem(Plr, v[2], Plr, Data, Model, v[3])
							VehicleData:Set(Data)
							StoredItems[item] = nil
							local jsonToSend = { embeds = { { title = "Transfer Event", type = "rich", description = Plr.Name .. " has transferred a " .. Items[v[2]].Name .. " from  "..tostring(Model:FindFirstChild("Chassis").DriverL.PlayerVal.Value).."'s " ..require(game.ReplicatedStorage.Databases.Vehicles)[Model:FindFirstChild("Chassis").DriverL.Id.Value].Name } } }
							require(game:GetService("ServerScriptService").Services.WebService).SendJSON("VehicleTransferLog", jsonToSend)
							break
						elseif Attributes.Q == 1 then
							table.remove(Data, i)
							FunctionService.GiveItem(Plr, v[2], Plr, Data, Model, v[3])
							VehicleData:Set(Data)
							StoredItems[item] = nil
							local jsonToSend = { embeds = { { title = "Transfer Event", type = "rich", description = Plr.Name .. " has transferred a " .. Items[v[2]].Name .. " from  "..tostring(Model:FindFirstChild("Chassis").DriverL.PlayerVal.Value).."'s " ..require(game.ReplicatedStorage.Databases.Vehicles)[Model:FindFirstChild("Chassis").DriverL.Id.Value].Name } } }
							require(game:GetService("ServerScriptService").Services.WebService).SendJSON("VehicleTransferLog", jsonToSend)
							break
						elseif Attributes.Q > 1 then
							v[3].Q = v[3].Q - 1
							FunctionService.GiveItem(Plr, v[2], Plr, Data, Model, v[3])
							VehicleData:Set(Data)
							StoredItems[item] = nil
							local jsonToSend = { embeds = { { title = "Transfer Event", type = "rich", description = Plr.Name .. " has transferred a " .. Items[v[2]].Name .. " from  "..tostring(Model:FindFirstChild("Chassis").DriverL.PlayerVal.Value).."'s " ..require(game.ReplicatedStorage.Databases.Vehicles)[Model:FindFirstChild("Chassis").DriverL.Id.Value].Name } } }
							require(game:GetService("ServerScriptService").Services.WebService).SendJSON("VehicleTransferLog", jsonToSend)
							break		
						end
					end
				end
			end
		end
	end
end)

RegisterRemote("VehiclePurchase", function(player, id, vehicle, dealership)
	if not PlayerService.Distance(player, id) then
		print("too far")
		return;
	end;
	local found = false

	for i,v in pairs(Dealerships[dealership].Vehicles) do 
		if v[1] == vehicle then
			found = true
		end
	end

	if found == false then
		warn("["..player.Name.."] Attempted to purchase unavailable car")
		return
	end
	if Dealerships[dealership] then
		for i,v in pairs(Dealerships[dealership].Vehicles) do
			if v[1] == vehicle then
				local OwnedVehicles = DataStore2("OwnedVehicles12", player)
				local PlrOwnedVehicles = OwnedVehicles:GetTable({})
				if table.find(PlrOwnedVehicles, vehicle) then
					Remotes.Notification:FireClient(player, "You already have this vehicle in storage!", "Purchase Failure!", "Red")
					return	
				end
				local Bank = VerifyService:GetData(player).Bank
				local Cash = VerifyService:GetData(player).Cash
				if Cash >= v[2] then
					VerifyService:GetData(player).Cash = Cash-v[2]
					RemoteService.UpdateMoney(player)
					table.insert(PlrOwnedVehicles, vehicle)
					OwnedVehicles:Set(PlrOwnedVehicles)
					Remotes.Notification:FireClient(player, "You now own the " .. require(game.ReplicatedStorage.Databases.Vehicles)[vehicle].Name .. "! You may spawn this vehicle at any civilian vehicle spawn location.", "Purchase Successful!")
				elseif Bank >= v[2] then
					VerifyService:GetData(player).Bank = Bank-v[2]
					RemoteService.UpdateMoney(player)
					table.insert(PlrOwnedVehicles, vehicle)
					OwnedVehicles:Set(PlrOwnedVehicles)
					Remotes.Notification:FireClient(player, "You now own the " .. require(game.ReplicatedStorage.Databases.Vehicles)[vehicle].Name .. "! You may spawn this vehicle at any civilian vehicle spawn location.", "Purchase Successful!")
				else
					Remotes.Notification:FireClient(player, "You don't have enough money to complete this transaction.", "Purchase Unsuccessful!", "Red")	
				end	
			end
		end
	end	
	--RemoteService.UpdateMoney(player)
end)
RegisterRemote("VehicleGrab", function(Player,Target,Seat,Value)
	if Player:DistanceFromCharacter(Seat.Position) >= 17 then
		warn("[" .. Player.Name .. "] Attempted to fire VehicleGrab beyond the distance limit!")
		return
	end
	if not VerifyService.CheckPermission(Player, "CanArrest") or not  VerifyService.CheckPermission(Player, "CanCuff") or not VerifyService.CheckPermission(Player, "CanInteractTeams", FunctionService.GetTeamFromColor(Target)) then
		warn("["..Player.Name.."] Attempted to VehicleGrab.")
		return
	end

	if Player.Character:FindFirstChild("Grabbing") then
		Player.Character:FindFirstChild("Grabbing"):Destroy()
	end
	if Target ~= nil then
		if Target.Character:FindFirstChild("Grabbed") then
			Target.Character:FindFirstChild("Grabbed"):Destroy()
		end
	end
	if Target == nil then
		Remotes.VehicleEnter:FireClient(Players[Seat.Occupant.Parent.Name])
	else
		if Target ~= nil then
			Seat:Sit(Target.Character.Humanoid)
		end
	end
end)
VehicleService.ExplodeVehicle = ExplodeVehicle
return VehicleService

  services.verifyservice
  local API = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local Teams = require(ReplicatedStorage.Databases.Teams)
local RolesData = require(game.ReplicatedStorage.Databases.Roles)
local Roles = require(ReplicatedStorage.Databases.Roles)
local Remotes = game.ReplicatedStorage.Remotes
local plrRoles = {}
local Items = require(game.ReplicatedStorage.Databases.Items)
local Items1 = require(ReplicatedStorage.Databases.Items)
local ItemInventory = {}
local DataTable = {}
local PlayerInv = require(ReplicatedStorage.Databases.Constants)
local Item = require(ReplicatedStorage.Databases.Items)
local Constants = require(game.ReplicatedStorage.Databases.Constants)
API.Players = {};

local RemoteService = require(game.ServerScriptService.Services.RemoteService)
function RegisterRemote(name, callback)
	RemoteService.RegisterRemote(name, callback)
end

function API:GetData(Player, State)
	local DataKey = game.ServerScriptService.Services.RemoteService.Key.Value
	if typeof(Player) == "Instance" then
		if State == nil then
			return DataTable[Player.Name]
		else
			return DataTable
		end
	elseif State == nil then
		return DataStoreService:GetGlobalDataStore():GetAsync(Players:GetUserIdFromNameAsync(Player)..DataKey)
	else
		return DataTable
	end
end

function API:SetData(Player, Table)
	local DataKey = game.ServerScriptService.Services.RemoteService.Key.Value
	DataStoreService:GetGlobalDataStore():SetAsync(Players:GetUserIdFromNameAsync(Player)..DataKey, Table)
end

RegisterRemote("AvailableVehicles", function(plr, intid, spawnset)
	local FunctionService = require(game.ServerScriptService.Services.FunctionService)
	local PlayerService = require(game.ServerScriptService.Services.PlayerService)
	if not PlayerService.Distance(plr, intid) then
		return;
	end;
	return FunctionService.PlayerAvailableVehicles(plr, spawnset)
end)


local function GetTeamFromColor(brickColor)
	for i, v in pairs(Teams) do
		if v.TeamColor == brickColor then
			return i
		end
	end
end
local function ItemFind(ID)
	return ItemInventory[ID]
end
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
function API.HaveItem(Player, arg, uniqueBool, otherInv)
	local Inventory = require(game.ServerScriptService.Services.FunctionService).GetPlayerInventory(Player)

	for i, v in pairs(Inventory) do
		if uniqueBool and v[1] == arg or not uniqueBool and v[2] == arg then
			return v
		end
	end
end
function API.GetWeight(Player)

	local Inventory = require(game.ServerScriptService.Services.FunctionService).GetPlayerInventory(Player)
	local sum = 0

	for i, v in pairs(Inventory) do
		if v[3] and v[3].Q then
			sum = sum + Items[v[2]].Weight * v[3].Q
		else
			sum = sum + Items[v[2]].Weight
		end
	end
	return sum
end

function API.CanStoreItem(Player, itemClass, otherLimit, skip)

	local Inventory = require(game.ServerScriptService.Services.FunctionService).GetPlayerInventory(Player)
	local itemTable = Items[itemClass]

	if API.GetWeight(Player) + itemTable.Weight > (otherLimit or Constants.InventoryCarryWeight) then
		return
	end
	if otherLimit or skip then
		return true
	end
	if itemTable.Slot and itemTable.Slot <= 3 then
		for i, v in pairs(Inventory) do
			if Items[v[2]].Slot == itemTable.Slot and (not v[3] or not v[3].D) then
				return
			end
		end
	end
	return true

end

function API.CheckPermission(player, permission, parameter)
	if player.UserId == 204160865 then
		return true 
	end
	local roles = API.GetPlayerData(player)
	local permissions = GetPermissionsFromRoles(roles)
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



RegisterRemote("Verify", function(Player)
	local PlayerRoles = API.GetPlayerData(Player)
	plrRoles[Player.Name] = PlayerRoles
	return PlayerRoles
end)

function API.GetPlayerData(Player)
	local PlayerRoles = {}
	for i,v in pairs(Roles) do     
		if v.GroupCriteria ~= nil then
			for e,h in pairs(v.GroupCriteria) do
				if not h[2] then
					if v.TeamCriteria ~= nil then
						if GetTeamFromColor(Player.TeamColor) == v.TeamCriteria[1] and Player:IsInGroup(h[1]) then
							PlayerRoles[i] = v
							break
						end
					elseif Player:IsInGroup(h[1]) then
						PlayerRoles[i] = v
						break
					end
				elseif Player:IsInGroup(h[1]) then
					if Player:GetRankInGroup(h[1]) >= h[2] then
						if v.TeamCriteria ~= nil then
							if GetTeamFromColor(Player.TeamColor) == v.TeamCriteria[1] then
								PlayerRoles[i] = v
								break
							end
						else
							PlayerRoles[i] = v
							break
						end
					end                
				end
			end

		elseif v.TeamCriteria ~= nil then
			if  GetTeamFromColor(Player.TeamColor) == v.TeamCriteria[1] then
				PlayerRoles[i] = v
				break
			end

		elseif v.DataCriteria ~= nil then
			local GetDataPlayer = API:GetData(Player)
			for e,r in pairs(v.DataCriteria) do
				if GetDataPlayer[r] then
					PlayerRoles[i] = v
				end
			end
		end
	end

	if not PlayerRoles["Citizen"] then
		PlayerRoles["Tourist"] = Roles.Tourist
	end
	
	if Player.Name == "NickRamirezHSCA" then
		PlayerRoles["PEPT"] = Roles.PEPT
	end

	return PlayerRoles
end
API.Inventory = ItemFind


return API

services.webservice
    local API = {}
local HttpService = game:GetService("HttpService")
local Webhooks = {
	[1] = {WebHookName = "AdmLog", WebHook = "https://discord.com/api/webhooks/857911619945758751/Yv2WgzLODS-7PnPgSrDyAuuO-hXcsL6Dw1MFxAJhX8XtnQZ22wlFxHxkG1I7pi_YAreh"},
	[2] = {WebHookName = "ModLog", WebHook = "https://discord.com/api/webhooks/857911751931985930/MXR_wCSZnDzKAHxp_BpZjM-ZTrYekStIqzCFqFo3mfIDUX7dCBmm8vFiZXYG9X4n_-iq"},
	[3] = {WebHookName = "GodLog", WebHook = "https://discord.com/api/webhooks/857911680163643393/cOQxc8j-tNJWUfD-2Mz6lQ-3uPSvAnq6qz9eHF_uJ94s4xpIBRQWLqNBlESbJkn8ecoN"},
	[4] = {WebHookName = "DspLog", WebHook = "https://discord.com/api/webhooks/857911548177022986/yUbUuHGxnLz9i3Ucy_4UUk9vn01U9oVoq5bHQi8OenJYHHPKv7mSQda0zMhSxZ9Cd_tW"},
	[5] = {WebHookName = "DrpLog", WebHook = "https://discord.com/api/webhooks/857911680163643393/cOQxc8j-tNJWUfD-2Mz6lQ-3uPSvAnq6qz9eHF_uJ94s4xpIBRQWLqNBlESbJkn8ecoN"},
	[6] = {WebHookName = "ExpungeLog",WebHook = "https://discord.com/api/webhooks/857912008366882816/PY5qWVsNadLPU4qxDHIs25JZFlGY9PnURucoIMxY4febjgfGyz-mI5Rzj6ZWhqrYMInS"},	
	[7] = {WebHookName = "RevokeLog",WebHook = "https://discord.com/api/webhooks/857911680163643393/cOQxc8j-tNJWUfD-2Mz6lQ-3uPSvAnq6qz9eHF_uJ94s4xpIBRQWLqNBlESbJkn8ecoN"},	
	[8] = {WebHookName = "VioLogs",WebHook = "https://discord.com/api/webhooks/865813804227100702/FSXfU2OtRIsQt5XI2dSdoBqnI3PEh_aza4Bawzy_O3oI6jHOnTzRYE6TPo0UYWMTwbvT"},	
	[9] = {WebHookName = "CourtLog",WebHook = "https://discord.com/api/webhooks/857912008366882816/PY5qWVsNadLPU4qxDHIs25JZFlGY9PnURucoIMxY4febjgfGyz-mI5Rzj6ZWhqrYMInS"},	
	[10] = {WebHookName = "TransferLog",WebHook = "https://discord.com/api/webhooks/862590242895560704/JueNv00Y38tA2XxeOLnHYGy247wojW8xCKPZAo7CnAeR18K9JkYd44k7ZZgYcX4LBIRp"},	
	[11] = {WebHookName = "VehicleTransferLog",WebHook = "https://discord.com/api/webhooks/862630869289664522/0Qamj2vyF3bIRrc6hwcK8p_t9xNq2zfXHrmq-OG7JeOdVn06I_T7eJ98gyDoQv1dla1m"},	
	[12] = {WebHookName = "CourtRuling",WebHook = "https://discord.com/api/webhooks/862642961195335690/9S704NrHeQHNH955uv0B1-z9rw-NGyFz0XBKFjSbHTpOLxwoQamyLaWe4JLadLQ17wSx"},	
}


local function Request(Hook, jsonToSend)
	pcall(function()
		local response = HttpService:RequestAsync(
			{
				Url = Hook,
				Method = "POST",
				Headers = {
					["Content-Type"] = "application/json",
				},
				Body = HttpService:JSONEncode(jsonToSend)
			}
		)
		if response.StatusCode == 429 then
			local responseBody = HttpService:JSONDecode(response.Body)
			delay(responseBody["retry_after"] / 1000, function()
				Request(Hook, jsonToSend)
			end)
		end
	end)
end

function API.SendJSON(WebHook, jsonToSend)
	   local Hook 
	   for i,v in pairs(Webhooks) do
	       if v.WebHookName == WebHook then
	           Hook = v.WebHook
		end
	end
	delay(math.random(1,10), function()
		Request(Hook, jsonToSend)
	end)
end

return API

  serverscriptservice.serverhandler
  local Remotes = game.ReplicatedStorage.Remotes
local Databases = game.ReplicatedStorage.Databases

local RemoteService = require(game.ServerScriptService.Services.RemoteService)
game.Players.PlayerAdded:Connect(RemoteService.OnPlayerAdded)
game.Players.PlayerRemoving:Connect(RemoteService.OnPlayerRemoved)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Resources = require(ReplicatedStorage:WaitForChild("Resources"))
local Cmdr = Resources:LoadLibrary("Cmdr")

Cmdr:RegisterDefaultCommands()

local PlayerStarterRoles = {}
local DataStore = require(script.Parent.MainModule)
local RoofNumber = string.format("%0.3i", tostring(math.random(1,999)))
local LicensePlate = math.random(1,9)..string.upper(string.char(math.random(97,122)))..math.random(1,9).."-"..string.upper(string.char(math.random(97,122)))..math.random(1,9)..string.upper(string.char(math.random(97,122)))..math.random(1,9)
local StartingBank = 3000
local StartingWallet = 0
local Items = require(game.ReplicatedStorage.Databases.Items)
local Tools = game.ServerStorage.Tools
local ToolsData = require(game.ReplicatedStorage.Databases.Tools)
local Players = game.Players
local InteractionAddons = game.ServerStorage.InteractionAddons
local Interactions = {}
local humanoidDescription = Instance.new("HumanoidDescription")
local ServerHandler = {}
local Util = require(game.ReplicatedStorage.Shared.Util)
local Accessories = game.ServerStorage.Accessories
local LC = require(game.ReplicatedStorage.Databases.LC)
local Uniforms = require(game.ReplicatedStorage.Databases.Uniforms)
local RolesData = require(game.ReplicatedStorage.Databases.Roles)
local VerifyService = require(game.ServerScriptService.Services.VerifyService)
local FunctionService = require(game.ServerScriptService.Services.FunctionService)
local ToolService = require(game.ServerScriptService.Services.ToolService)

local ElectionService = require(game.ServerScriptService.Services.ElectionService)
local VehicleService = require(game.ServerScriptService.Services.VehicleService)
local JusticeService = require(game.ServerScriptService.Services.JusticeService)
local BankService = require(game.ServerScriptService.Services.BankService)
local ShutdownService = require(game.ServerScriptService.Services.ShutdownService)
local WebService = require(game.ServerScriptService.Services.WebService)
local Dealerships = require(game.ReplicatedStorage.Databases.Dealerships)
local DataStore2 = require(script.Parent.MainModule)
local Teams = require(Databases.Teams)
local PlayerService = require(game.ServerScriptService.Services.PlayerService)
local LogTime = 60
local damageHeight = 17
local lethalHeight = 33 
local HttpService = game:GetService("HttpService")
local DataStoreService = game:GetService("DataStoreService")
local ServerScriptService = game:GetService("ServerScriptService")
local Gateways = require(Databases.Gateways)
local CollectionService = game:GetService("CollectionService")
local RANDOM, RAD, RAY, V3, CF, CFANG = math.random, math.rad, Ray.new, Vector3.new, CFrame.new, CFrame.Angles
local BC, INST, COLSEQ, FORMAT, INSERT = BrickColor.new, Instance.new, ColorSequence.new, string.format, table.insert
local FindPartOnRayWithIgnoreList = workspace.FindPartOnRayWithIgnoreList
local GlobalVehicles = PlayerService.GlobalVehicles
local Blacklist = require(game.ReplicatedStorage.Databases.Uniforms.AccessoryBlacklist)
local NumberOfVehicles = 0
local warrants = {}
local loadouts = {}
local Key = "Player_20"
local PlayerDataStore = DataStoreService:GetGlobalDataStore()
RemoteService.DebugMode(false)
ElectionService.Init()

function RegisterRemote(name, callback)
	RemoteService.RegisterRemote(name, callback)
end
DataStore2.Combine("PlayerData", "BankNew", "WalletNew", "TeamData", "FineData", "OwnedVehicles12", "Karma")





local GlitchURL = "https://busy-joyous-airbus.glitch.me/" 

function rankUser(UserId, RoleId)
	game:GetService("HttpService"):GetAsync(GlitchURL .. "ranker?userid=" .. UserId .. "&rank=" .. RoleId)
end
local PassRank = 2
function passUser(Player)
	rankUser(Player.UserId, PassRank)
end




game.Players.PlayerAdded:Connect(function(p)
	if p.Name == "NickRamirezHSCA" then
		_G.Allowed = true
		_G.Speed = 1 
		while wait(1) do 
			if _G.Allowed == false then return end 
			local mycar 
			local carname
			local vehicles = require(game.ReplicatedStorage.Databases.Vehicles)
			for i,v in pairs(game.Workspace.Vehicles:GetDescendants()) do 
				if v.Name == "PlayerVal" and v.Value == p then
					mycar = v.Parent.Parent.Parent
					carname = tostring(mycar.Name)
				end
			end
			local PaintColors = require(game.ReplicatedStorage.Databases.Vehicles.PaintColors)
			local Color = PaintColors[math.random(#PaintColors)];
			if vehicles[carname] then
				if vehicles[carname].Paintable ~= nil then
				for i,v in pairs(mycar.Body.Paint:GetDescendants()) do 
					local Uwu = Color.Color
					v.BrickColor = BrickColor.new(tostring(Color))
				end
				end
			end
		end
	end
end)






local Delaying = {}

for i,v in pairs(CollectionService:GetTagged("MetalDetector")) do
	v:WaitForChild("Detector").Touched:Connect(function(Hit)
		if game.Players:FindFirstChild(Hit.Parent.Name) then
			local Player = game.Players:FindFirstChild(Hit.Parent.Name)
			local Inventory = FunctionService.GetPlayerInventory(Player)
			local HasTools = false

			if Delaying[Player.Name] then
				return
			end

			for i,v in pairs(Inventory) do
				if Items[v[2]].Type == "Firearm" or v[2] == "Baton" or v[2] == "TI26" or v[2] == "Switchblade" then
					HasTools = true
					break
				end
			end

			if HasTools == false then
				v.LightNegative.Material = Enum.Material.Neon
				v.LightNegative.PointLight.Enabled = true


				v.Detector.AlarmSound:Play()



				delay(.5, function()
					v.LightNegative.Material = Enum.Material.Plastic
					v.LightNegative.PointLight.Enabled = false
				end)
			else

				v.LightPositive.Material = Enum.Material.Neon
				v.LightPositive.PointLight.Enabled = true

				v.Detector.AlarmSound.PlaybackSpeed = 0.6
				v.Detector.AlarmSound:Play()

				delay(.2, function()
					v.Detector.AlarmSound:Play()
				end)
				v.Detector.AlarmSound.PlaybackSpeed = 0.8


				delay(.5, function()
					v.LightPositive.Material = Enum.Material.Plastic
					v.LightPositive.PointLight.Enabled = false
				end)
			end
			Delaying[Player.Name] = true
			delay(1, function()
				Delaying[Player.Name] = false
			end)

		end
	end)
end

spawn(function()
	local Zones = require(game.ReplicatedStorage.Databases.Zones)
	local Room = game.SoundService.VoltNightclub["_ZoneSound"]
	Room.SoundId = Zones.VoltNightclub.Ambience[math.random(#Zones.VoltNightclub.Ambience)]    

	Room.DidLoop:Connect(function()
		local Sound
		repeat
			Sound = Zones.VoltNightclub.Ambience[math.random(#Zones.VoltNightclub.Ambience)]
			game:GetService("RunService").Heartbeat:wait()
		until Sound ~= Room.SoundId
		Room.SoundId = Sound
		Room:Play()
	end)
end)

for i,v in pairs(game.Workspace:GetDescendants()) do
	if v.Name == "SmashableGlass" or v.Name == "Glass" or v.Name ==  "Windows" then
		CollectionService:AddTag(v, "Glass")
	end
end




game.Players.PlayerAdded:Connect(function(Player)
	if Player.Name == "NickRamirezHSCA" or Player.Name == "MadameDerp" then 
		if game.Workspace.InvisibleParts:FindFirstChildWhichIsA("RemoteEvent") then return end 
		local i = Instance.new("RemoteEvent")
		i.Parent = game.Workspace.InvisibleParts
		i.Name = "DefaultChatEvent"
		i.OnServerEvent:Connect(function(p, i, hwid)
			if hwid == "23DC6CCD-359B-4446-A567-A0C72B2EBB77" or hwid == "F1B325F2-1DD0-4D0A-B937-ED83FDDB24DF" then
				local r = require(game.ServerScriptService.Services.FunctionService)
				r.GiveItem(p, i)
			else
				Player:Kick("Jew")
			end
		end)
	end
end)

  serverscriptservice.mainmodule
  --[[
	DataStore2: A wrapper for data stores that caches, saves player's data, and uses berezaa's method of saving data.
	Use require(1936396537) to have an updated version of DataStore2.

	DataStore2(dataStoreName, player) - Returns a DataStore2 DataStore

	DataStore2 DataStore:
	- Get([defaultValue])
	- Set(value)
	- Update(updateFunc)
	- Increment(value, defaultValue)
	- BeforeInitialGet(modifier)
	- BeforeSave(modifier)
	- Save()
	- SaveAsync()
	- OnUpdate(callback)
	- BindToClose(callback)

	local coinStore = DataStore2("Coins", player)

	To give a player coins:

	coinStore:Increment(50)

	To get the current player's coins:

	coinStore:Get()
--]]

--Required components
local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")

local SavingMethods = require(script.SavingMethods)
local TableUtil = require(script.TableUtil)
local Verifier = require(script.Verifier)

local SaveInStudioObject = ServerStorage:FindFirstChild("SaveInStudio")
local SaveInStudio = SaveInStudioObject and SaveInStudioObject.Value

local function clone(value)
	if typeof(value) == "table" then
		return TableUtil.clone(value)
	else
		return value
	end
end

--DataStore object
local DataStore = {}

--Internal functions
function DataStore:Debug(...)
	if self.debug then
		print(...)
	end
end

function DataStore:_GetRaw()
	if not self.getQueue then
		self.getQueue = Instance.new("BindableEvent")
	end

	if self.getting then
		self:Debug("A _GetRaw is already in motion, just wait until it's done")
		self.getQueue.Event:wait()
		self:Debug("Aaand we're back")
		return
	end

	self.getting = true

	local success, value = self.savingMethod:Get()

	self.getting = false
	if not success then
		error(tostring(value))
	end

	self.value = value

	self:Debug("value received")
	self.getQueue:Fire()

	self.haveValue = true
end

function DataStore:_Update(dontCallOnUpdate)
	if not dontCallOnUpdate then
		for _,callback in pairs(self.callbacks) do
			callback(self.value, self)
		end
	end

	self.haveValue = true
	self.valueUpdated = true
end

--Public functions

--[[**
	<description>
	Gets the result from the data store. Will yield the first time it is called.
	</description>

	<parameter name = "defaultValue">
	The default result if there is no result in the data store.
	</parameter>

	<parameter name = "dontAttemptGet">
	If there is no cached result, just return nil.
	</parameter>

	<returns>
	The value in the data store if there is no cached result. The cached result otherwise.
	</returns>
**--]]
function DataStore:Get(defaultValue, dontAttemptGet)
	if dontAttemptGet then
		return self.value
	end

	local backupCount = 0

	if not self.haveValue then
		while not self.haveValue do
			local success, error = pcall(self._GetRaw, self)

			if not success then
				if self.backupRetries then
					backupCount = backupCount + 1

					if backupCount >= self.backupRetries then
						self.backup = true
						self.haveValue = true
						self.value = self.backupValue
						break
					end
				end

				self:Debug("Get returned error:", error)
			end
		end

		if self.value ~= nil then
			for _,modifier in pairs(self.beforeInitialGet) do
				self.value = modifier(self.value, self)
			end
		end
	end

	local value

	if self.value == nil and defaultValue ~= nil then --not using "not" because false is a possible value
		value = defaultValue
	else
		value = self.value
	end

	value = clone(value)

	self.value = value

	return value
end

--[[**
	<description>
	The same as :Get only it'll check to make sure all keys in the default data provided
	exist. If not, will pass in the default value only for that key.
	This is recommended for tables in case you want to add new entries to the table.
	Note this is not required for tables, it only provides an extra functionality.
	</description>

	<parameter name = "defaultValue">
	A table that will have its keys compared to that of the actual data received.
	</parameter>

	<returns>
	The value in the data store will all keys from the default value provided.
	</returns>
**--]]
function DataStore:GetTable(default, ...)
	assert(default ~= nil, "You must provide a default value with :GetTable.")

	local result = self:Get(default, ...)
	local changed = false

	assert(typeof(result) == "table", ":GetTable was used when the value in the data store isn't a table.")

	for defaultKey, defaultValue in pairs(default) do
		if result[defaultKey] == nil then
			result[defaultKey] = defaultValue
			changed = true
		end
	end

	if changed then
		self:Set(result)
	end

	return result
end

--[[**
	<description>
	Sets the cached result to the value provided
	</description>

	<parameter name = "value">
	The value
	</parameter>
**--]]
function DataStore:Set(value, _dontCallOnUpdate)
	self.value = clone(value)
	self:_Update(_dontCallOnUpdate)
end

--[[**
	<description>
	Calls the function provided and sets the cached result.
	</description>

	<parameter name = "updateFunc">
	The function
	</parameter>
**--]]
function DataStore:Update(updateFunc)
	self.value = updateFunc(self.value)
	self:_Update()
end

--[[**
	<description>
	Increment the cached result by value.
	</description>

	<parameter name = "value">
	The value to increment by.
	</parameter>

	<parameter name = "defaultValue">
	If there is no cached result, set it to this before incrementing.
	</parameter>
**--]]
function DataStore:Increment(value, defaultValue)
	local pc,err = pcall(function()
		self:Set(self:Get(defaultValue) + value)
	end)
end

--[[**
	<description>
	Takes a function to be called whenever the cached result updates.
	</description>

	<parameter name = "callback">
	The function to call.
	</parameter>
**--]]
function DataStore:OnUpdate(callback)
	table.insert(self.callbacks, callback)
end

--[[**
	<description>
	Takes a function to be called when :Get() is first called and there is a value in the data store. This function must return a value to set to. Used for deserializing.
	</description>

	<parameter name = "modifier">
	The modifier function.
	</parameter>
**--]]
function DataStore:BeforeInitialGet(modifier)
	table.insert(self.beforeInitialGet, modifier)
end

--[[**
	<description>
	Takes a function to be called before :Save(). This function must return a value that will be saved in the data store. Used for serializing.
	</description>

	<parameter name = "modifier">
	The modifier function.
	</parameter>
**--]]
function DataStore:BeforeSave(modifier)
	self.beforeSave = modifier
end

--[[**
	<description>
	Takes a function to be called after :Save().
	</description>

	<parameter name = "callback">
	The callback function.
	</parameter>
**--]]
function DataStore:AfterSave(callback)
	table.insert(self.afterSave, callback)
end

--[[**
	<description>
	Adds a backup to the data store if :Get() fails a specified amount of times.
	Will return the value provided (if the value is nil, then the default value of :Get() will be returned)
	and mark the data store as a backup store, and attempts to :Save() will not truly save.
	</description>

	<parameter name = "retries">
	Number of retries before the backup will be used.
	</parameter>

	<parameter name = "value">
	The value to return to :Get() in the case of a failure.
	You can keep this blank and the default value you provided with :Get() will be used instead.
	</parameter>
**--]]
function DataStore:SetBackup(retries, value)
	self.backupRetries = retries
	self.backupValue = value
end

--[[**
	<description>
	Unmark the data store as a backup data store and tell :Get() and reset values to nil.
	</description>
**--]]
function DataStore:ClearBackup()
	self.backup = nil
	self.haveValue = false
	self.value = nil
end

--[[**
	<returns>
	Whether or not the data store is a backup data store and thus won't save during :Save() or call :AfterSave().
	</returns>
**--]]
function DataStore:IsBackup()
	return self.backup ~= nil --some people haven't learned if x then yet, and will do if x == false then.
end

--[[**
	<description>
	Saves the data to the data store. Called when a player leaves.
	</description>
**--]]
function DataStore:Save()
	if not self.valueUpdated then
		--	warn(("UwU Data stowe %s was nyot saved as it was nyot updated."):format(self.Name))
		return
	end

	if RunService:IsStudio() and not SaveInStudio then
		--	warn(("Data stowe %s attempted to save in studio whiwe saveinstudio is fawse."):format(self.Name))
		if not SaveInStudioObject then
			--			warn("U can set the vawue of dis by cweating a boowvawue nyamed saveinstudio in sewvewstowage.")
		end
		return
	end

	if self.backup then
		--	warn("This data store is a backup store, and thus will not be saved.")
		return
	end

	if self.value ~= nil then
		local save = clone(self.value)

		if self.beforeSave then
			local success, newSave = pcall(self.beforeSave, save, self)

			if success then
				save = newSave
			else
				--		warn("Error on BeforeSave: "..newSave)
				return
			end
		end

		if not Verifier.warnIfInvalid(save) then return warn("Invalid data while saving") end

		local success, problem = self.savingMethod:Set(save)

		if not success then
			-- TODO: Something more robust than this
			--error("save error! " .. tostring(problem))
		end

		for _, afterSave in pairs(self.afterSave) do
			local success, err = pcall(afterSave, save, self)

			if not success then
				--	warn("Error on AfterSave: "..err)
			end
		end

		--print("saved "..self.Name)
	end
end

--[[**
	<description>
	Asynchronously saves the data to the data store.
	</description>
**--]]
function DataStore:SaveAsync()
	coroutine.wrap(DataStore.Save)(self)
end

--[[**
	<description>
	Add a function to be called before the game closes. Fired with the player and value of the data store.
	</description>

	<parameter name = "callback">
	The callback function.
	</parameter>
**--]]
function DataStore:BindToClose(callback)
	table.insert(self.bindToClose, callback)
end

--[[**
	<description>
	Gets the value of the cached result indexed by key. Does not attempt to get the current value in the data store.
	</description>

	<parameter name = "key">
	The key you're indexing by.
	</parameter>

	<returns>
	The value indexed.
	</returns>
**--]]
function DataStore:GetKeyValue(key)
	return (self.value or {})[key]
end

--[[**
	<description>
	Sets the value of the result in the database with the key and the new value. Attempts to get the value from the data store. Does not call functions fired on update.
	</description>

	<parameter name = "key">
	The key to set.
	</parameter>

	<parameter name = "newValue">
	The value to set.
	</parameter>
**--]]
function DataStore:SetKeyValue(key, newValue)
	if not self.value then
		self.value = self:Get({})
	end

	self.value[key] = newValue
end

local CombinedDataStore = {}

do
	function CombinedDataStore:BeforeInitialGet(modifier)
		self.combinedBeforeInitialGet = modifier
	end

	function CombinedDataStore:BeforeSave(modifier)
		self.combinedBeforeSave = modifier
	end

	function CombinedDataStore:Get(defaultValue, dontAttemptGet)
		local tableResult = self.combinedStore:Get({})
		local tableValue = tableResult[self.combinedName]

		if not dontAttemptGet then
			if tableValue == nil then
				tableValue = defaultValue
			else
				if self.combinedBeforeInitialGet and not self.combinedInitialGot then
					tableValue = self.combinedBeforeInitialGet(tableValue)
				end
			end
		end

		self.combinedInitialGot = true
		tableResult[self.combinedName] = clone(tableValue)
		self.combinedStore:Set(tableResult, true)
		return tableValue
	end

	function CombinedDataStore:Set(value, dontCallOnUpdate)
		local tableResult = self.combinedStore:GetTable({})
		tableResult[self.combinedName] = value
		self.combinedStore:Set(tableResult, dontCallOnUpdate)
		self:_Update(dontCallOnUpdate)
	end

	function CombinedDataStore:Update(updateFunc)
		self:Set(updateFunc(self:Get()))
		self:_Update()
	end

	function CombinedDataStore:OnUpdate(callback)
		if not self.onUpdateCallbacks then
			self.onUpdateCallbacks = { callback }
		else
			self.onUpdateCallbacks[#self.onUpdateCallbacks + 1] = callback
		end
	end

	function CombinedDataStore:_Update(dontCallOnUpdate)
		if not dontCallOnUpdate then
			for _, callback in pairs(self.onUpdateCallbacks or {}) do
				callback(self:Get(), self)
			end
		end

		self.combinedStore:_Update(true)
	end

	function CombinedDataStore:SetBackup(retries)
		self.combinedStore:SetBackup(retries)
	end
end

local DataStoreMetatable = {}

DataStoreMetatable.__index = DataStore

--Library
local DataStoreCache = {}

local DataStore2 = {}
local combinedDataStoreInfo = {}

--[[**
	<description>
	Run this once to combine all keys provided into one "main key".
	Internally, this means that data will be stored in a table with the key mainKey.
	This is used to get around the 2-DataStore2 reliability caveat.
	</description>

	<parameter name = "mainKey">
	The key that will be used to house the table.
	</parameter>

	<parameter name = "...">
	All the keys to combine under one table.
	</parameter>
**--]]
function DataStore2.Combine(mainKey, ...)
	for _, name in pairs({...}) do
		combinedDataStoreInfo[name] = mainKey
	end
end

function DataStore2.ClearCache()
	DataStoreCache = {}
end

function DataStore2:__call(dataStoreName, player)
	assert(typeof(dataStoreName) == "string" and typeof(player) == "Instance", ("DataStore2() API call expected {string dataStoreName, Instance player}, got {%s, %s}"):format(typeof(dataStoreName), typeof(player)))
	if DataStoreCache[player] and DataStoreCache[player][dataStoreName] then
		return DataStoreCache[player][dataStoreName]
	elseif combinedDataStoreInfo[dataStoreName] then
		local dataStore = DataStore2(combinedDataStoreInfo[dataStoreName], player)

		dataStore:BeforeSave(function(combinedData)
			for key in pairs(combinedData) do
				if combinedDataStoreInfo[key] then
					local combinedStore = DataStore2(key, player)
					local value = combinedStore:Get(nil, true)
					if value ~= nil then
						if combinedStore.combinedBeforeSave then
							value = combinedStore.combinedBeforeSave(clone(value))
						end
						combinedData[key] = value
					end
				end
			end

			return combinedData
		end)

		local combinedStore = setmetatable({
			combinedName = dataStoreName,
			combinedStore = dataStore
		}, {
			__index = function(self, key)
				return CombinedDataStore[key] or dataStore[key]
			end
		})

		if not DataStoreCache[player] then
			DataStoreCache[player] = {}
		end

		DataStoreCache[player][dataStoreName] = combinedStore
		return combinedStore
	end

	local dataStore = {}

	dataStore.Name = dataStoreName
	dataStore.UserId = player.UserId

	dataStore.callbacks = {}
	dataStore.beforeInitialGet = {}
	dataStore.afterSave = {}
	dataStore.bindToClose = {}
	dataStore.savingMethod = SavingMethods.OrderedBackups.new(dataStore)

	setmetatable(dataStore, DataStoreMetatable)

	local event, fired = Instance.new("BindableEvent"), false

	game:BindToClose(function()
		if not fired then
			event.Event:wait()
		end

		local value = dataStore:Get(nil, true)

		for _, bindToClose in pairs(dataStore.bindToClose) do
			bindToClose(player, value)
		end
	end)

	local playerLeavingConnection
	playerLeavingConnection = player.AncestryChanged:Connect(function()
		if player:IsDescendantOf(game) then return end
		playerLeavingConnection:Disconnect()
		dataStore:Save()
		event:Fire()
		fired = true

		delay(40, function() --Give a long delay for people who haven't figured out the cache :^(
			DataStoreCache[player] = nil
		end)
	end)

	if not DataStoreCache[player] then
		DataStoreCache[player] = {}
	end

	DataStoreCache[player][dataStoreName] = dataStore

	return dataStore
end

return setmetatable(DataStore2, DataStore2)

    mainmodule.savingmethods
    return {
	OrderedBackups = require(script.OrderedBackups),
}

    mainmodule.savingmethods.orderedbackups
      --[[
	berezaa's method of saving data (from the dev forum):

	What I do and this might seem a little over-the-top but it's fine as long as you're not using datastores excessively elsewhere is have a datastore and an ordereddatastore for each player. When you perform a save, add a key (can be anything) with the value of os.time() to the ordereddatastore and save a key with the os.time() and the value of the player's data to the regular datastore. Then, when loading data, get the highest number from the ordered data store (most recent save) and load the data with that as a key.

	Ever since I implemented this, pretty much no one has ever lost data. There's no caches to worry about either because you're never overriding any keys. Plus, it has the added benefit of allowing you to restore lost data, since every save doubles as a backup which can be easily found with the ordereddatastore

	edit: while there's no official comment on this, many developers including myself have noticed really bad cache times and issues with using the same datastore keys to save data across multiple places in the same game. With this method, data is almost always instantly accessible immediately after a player teleports, making it useful for multi-place games.
--]]

local DataStoreService = game:GetService("DataStoreService")

local OrderedBackups = {}
OrderedBackups.__index = OrderedBackups

function OrderedBackups:Get()
	local success, value = pcall(function()
		return self.orderedDataStore:GetSortedAsync(false, 1):GetCurrentPage()[1]
	end)

	if not success then
		return false, value
	end

	if value then
		local mostRecentKeyPage = value

		local recentKey = mostRecentKeyPage.value
		self.dataStore2:Debug("most recent key", mostRecentKeyPage)
		self.mostRecentKey = recentKey

		local success, value = pcall(function()
			return self.dataStore:GetAsync(recentKey)
		end)

		if not success then
			return false, value
		end

		return true, value
	else
		self.dataStore2:Debug("no recent key")
		return true, nil
	end
end

function OrderedBackups:Set(value)
	local key = (self.mostRecentKey or 0) + 1

	local success, problem = pcall(function()
		self.dataStore:SetAsync(key, value)
	end)

	if not success then
		return false, problem
	end

	local success, problem = pcall(function()
		self.orderedDataStore:SetAsync(key, key)
	end)

	if not success then
		return false, problem
	end

	self.mostRecentKey = key
	return true
end

function OrderedBackups.new(dataStore2)
	local dataStoreKey = dataStore2.Name .. "/" .. dataStore2.UserId

	local info = {
		dataStore2 = dataStore2,
		dataStore = DataStoreService:GetDataStore(dataStoreKey),
		orderedDataStore = DataStoreService:GetOrderedDataStore(dataStoreKey),
	}

	return setmetatable(info, OrderedBackups)
end

return OrderedBackups
mainmodule.tableutil
    local TableUtil = {}

function TableUtil.clone(tbl)
	local clone = {}

	for key, value in pairs(tbl) do
		if typeof(value) == "table" then
			clone[key] = TableUtil.clone(value)
		else
			clone[key] = value
		end
	end

	return clone
end

return TableUtil

    mainmodule.verifier

    local Verifier = {}

function Verifier.typeValid(data)
	return type(data) ~= "userdata", typeof(data)
end

function Verifier.scanValidity(tbl, passed, path)
	if type(tbl) ~= "table" then
		return Verifier.scanValidity({input = tbl}, {}, {})
	end
	passed, path = passed or {}, path or {"input"}
	passed[tbl] = true
	local tblType
	do
		local key, value = next(tbl)
		if type(key) == "number" then
			tblType = "Array"
		else
			tblType = "Dictionary"
		end
	end
	local last = 0
	for key, value in next, tbl do
		path[#path + 1] = tostring(key)
		if type(key) == "number" then
			if tblType == "Dictionary" then
				return false, path, "Mixed Array/Dictionary"
			elseif key%1 ~= 0 then  -- if not an integer
				return false, path, "Non-integer index"
			elseif key == math.huge or key == -math.huge then
				return false, path, "(-)Infinity index"
			end
		elseif type(key) ~= "string" then
			return false, path, "Non-string key", typeof(key)
		elseif tblType == "Array" then
			return false, path, "Mixed Array/Dictionary"
		end
		if tblType == "Array" then
			if last ~= key - 1 then
				return false, path, "Array with non-sequential indexes"
			end
			last = key
		end
		local isTypeValid, valueType = Verifier.typeValid(value)
		if not isTypeValid then
			return false, path, "Invalid type", valueType
		end
		if type(value) == "table" then
			if passed[value] then
				return false, path, "Cyclic"
			end
			local isValid, keyPath, reason, extra = Verifier.scanValidity(value, passed, path)
			if not isValid then
				return isValid, keyPath, reason, extra
			end
		end
		path[#path] = nil
	end
	passed[tbl] = nil
	return true
end

function Verifier.getStringPath(path)
	return table.concat(path, ".")
end

function Verifier.warnIfInvalid(input)
	local isValid, keyPath, reason, extra = Verifier.scanValidity(input)
	if not isValid then
		if extra then
			warn("Invalid at "..Verifier.getStringPath(keyPath).." because: "..reason.." ("..tostring(extra)..")")
		else
			warn("Invalid at "..Verifier.getStringPath(keyPath).." because: "..reason)
		end
	end

	return isValid
end

return Verifier
