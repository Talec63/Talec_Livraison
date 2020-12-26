ESX              = nil
local PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer  
end)

--[[Citizen.CreateThread(function()
    for a,b in pairs(Config.Pos2) do
        for c,d in pairs(b) do
            local hash = GetHashKey(d.Ped2)
            while not HasModelLoaded(hash) do
                RequestModel(hash)
                Wait(20)
            end
            ped = CreatePed("PED_TYPE_CIVFEMALE", d.Ped2, d.Position2, false, true)
            SetBlockingOfNonTemporaryEvents(ped, true)
            SetEntityInvincible(ped, true)
            FreezeEntityPosition(ped, true)
        end
    end
end)--]]

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        --DrawMarker(21, -329.77, -981.14, 31.08, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 209, 45, 45, 155, false, true, 2, false, nil, nil, false)
    end
end)
vMenu.Add('shop2', 'main', ValUI.CreateMenu("PrimeEat", "Pour gagner un peu de sous"))
vMenu.Add("tacos2", 'tacos',ValUI.CreateSubMenu(vMenu:Get('tacos2', 'tacos'), 'PrimeEat', 'Pour gagner un peu de sous'))
Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(0)
        ValUI.IsVisible(vMenu:Get('shop2', 'main'), true, true, true, function() 
            ValUI.Button("Livrer votre nourriture pour ~g~400$", "Vender une pizza", {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if (Selected) then 
                print('test')
                TriggerServerEvent('talec:sell')
                end 
                end)
            ValUI.Separator("↓↓↓ ~b~Actions supplémentaires ~s~↓↓↓", nil, {}, true, function(_, _, _)
            end)
            ValUI.Button("Demander une nouvelle mission", "Voyez quelle mission vous pouvez faire !", {RightLabel = "→→→"},true, function()
            end, vMenu:Get('tacos2', 'tacos'))
            end, function() 
            end)
        ValUI.IsVisible(vMenu:Get('tacos2', 'tacos'), true, true, true, function()
            ValUI.Button('Livrer un tacos', 'Nouvelle mission', {RightLabel = ""}, true, function (Hovered, Active, Selected)
                if (Selected) then
                    blipy()
                    TriggerServerEvent('talec:item')
                    --PlaySoundFrontend(-1, "CHECKPOINT_MISSED", "HUD_MINI_GAME_SOUNDSET", 1)
                    spawnCar('faggio') 
                    ESX.ShowNotification("Va livrer ta pizza sur le point de la ~g~carte.")
                end
            end)
        end)

    end
end)

--[[local position = {
    {x = -329.83 , y = -980.54, z = 31.08, }
}--]]    
local position = 
{
    {x = -207.03, y = -659.44, z = 33.66},
    {x = -421.37, y = -666.25, z = 30.41},
    {x = -607.6, y = -667.54, z = 31.68},
    {x = -753.09, y = -641.67, z = 30.17},
}
--[[local spawnLocations = 
{
    [1] = {x = 2.42334, y = 13.1312, z = -12.4312},
    [2] = {x = 2.433234, y = 13.134562, z = -12.4312},
    [3] = {x = 2.2221111134, y = 13.132, z = -12.4312},
    [4] = {x = 2.42334, y = 13.132, z = -12.4312},
    [5] = {x = 2.43333333234, y = 13.132, z = -12.4312},
    [6] = {x = 2.4331234, y = 13.132, z = -12.4312},
    [7] = {x = 2.3, y = 13.132, z = -12.4312},
}

local random = spawnLocations[math.random(1, #spawnLocations)]
print(random.x, random.y, random.z)
local positional = spawnLocations[math.random(1,7)].x
local pos2 = spawnLocations[math.random(1,7)].y
local pos3 = spawnLocations[math.random(1,7)].z
print(positional)
print(pos2)
print(pos3)--]]

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        for k in pairs(position) do

            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, position[k].x, position[k].y, position[k].z)

            if dist <= 1.0 then

                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour parler au ~b~client")
                if IsControlJustPressed(1,51) then
                    ValUI.Visible(vMenu:Get('shop2', 'main'), not ValUI.Visible(vMenu:Get('shop2', 'main')))
                end
            end
        end
    end
end)