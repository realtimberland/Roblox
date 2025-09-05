-- Variables

local toggleWeaponRF = script:WaitForChild("RemoteFunction")
local animsFolder = script.Parent:WaitForChild("Animations")

local soundFolder = game.ReplicatedStorage.Sound
local unsheatheSound = soundFolder.SwordUnsheath
local sheatheSound = soundFolder.SwordSheath

local contentProvider = game:GetService("ContentProvider")

--Preload Anims

for i, v in pairs(animsFolder:GetChildren()) do
	contentProvider:PreloadAsync({v})
end
	
toggleWeaponRF.OnServerInvoke = function(plr)
	local char = plr.Character	
	local hum = char:WaitForChild("Humanoid")
	
	local inactiveWepFolder = char:FindFirstChild("InactiveWeapon")
	local activateWepFolder = char:FindFirstChild("ActiveWeapon")
	
	if inactiveWepFolder:GetChildren()[1] then
		--more variables
		
		local oldWep = inactiveWepFolder:GetChildren()[1]
		
		local weapon = oldWep:Clone()
		local handle = weapon:FindFirstChild("Handle")
		
		local rightArm = char:FindFirstChild("Right Arm")
		
		local activatedCFvalue = weapon:FindFirstChild("Activated")
		
		-- anim variables
		
		local reachforWepAnim = animsFolder.Reach
		local unsheathe = animsFolder.Unsheathe
		local sheathe = animsFolder.Sheathe
		
		local reachTrack = hum:LoadAnimation(reachforWepAnim)
		local unsheatheTrack = hum:LoadAnimation(unsheathe)
		
		-- delete any motor6ds in the handle just incase
		
		for i, v in pairs(handle:GetChildren()) do
			if v:IsA("Motor6D") then
				v:Destroy()
			end
		end
		
		-- set attributes to the player for other systems to see
		
		char:SetAttribute("WeaponEquipped", true)
		char:SetAttribute("Sword", true)
		
		--play sounds
		
		unsheatheSound:Play()

		reachTrack:Play()
		
		task.wait(reachTrack.Length) -- wait till the unsheathe anim is over
		
		oldWep:Destroy() -- delete the sheathed weapon
		
		weapon.Parent = activateWepFolder -- parent the new weapon to a folder within the player
		
		--weld the weapon to the players arm
		
		local motor6d = Instance.new("Motor6D")
		motor6d.Part0 = rightArm
		motor6d.Part1 = handle
		motor6d.C1 = activatedCFvalue.Value
		motor6d.Parent = handle
		
		--play the unsheathe track and wait for the anim to end
		
		unsheatheTrack:Play()
				
		task.wait(unsheatheTrack.Length)
		
	else
		--the same but in reverse for sheathing
		
		local oldWeapon = activateWepFolder:GetChildren()[1]
		local weapon = oldWeapon:Clone()
		local handle = weapon:FindFirstChild("Handle")
		
		local torso = char:FindFirstChild("Torso")
		
		local deactivatedCFvalue = weapon:FindFirstChild("Deactivated")
		
		local sheathe = animsFolder:WaitForChild("Sheathe")
		local sheatheTrack = hum:LoadAnimation(sheathe)
		
		for i, v in pairs(handle:GetChildren()) do
			if v:IsA("Motor6D") then
				v:Destroy()
			end
		end
		
		sheatheTrack:Play()
		
		sheatheSound:Play()
		
		task.wait(sheatheTrack.Length)
		
		oldWeapon:Destroy()
		
		weapon.Parent = inactiveWepFolder
		
		local motor6d = Instance.new("Motor6D")
		motor6d.Part0 = torso
		motor6d.Part1 = handle
		motor6d.C1 = deactivatedCFvalue.Value
		motor6d.Parent = handle
		
		char:SetAttribute("WeaponEquipped", false)

	end
	
end
