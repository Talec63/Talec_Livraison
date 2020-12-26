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

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

-- The distance to check in front of the player for a vehicle   
local distanceToCheck = 5.0

-- The number of times to retry deleting a vehicle if it fails the first time 
local numRetries = 5

-- Add an event handler for the deleteVehicle event. Gets called when a user types in /dv in chat
RegisterNetEvent( "wk:deleteVehicle" )
AddEventHandler( "wk:deleteVehicle", function()
    local ped = GetPlayerPed( -1 )

    if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then 
        local pos = GetEntityCoords( ped )

        if ( IsPedSittingInAnyVehicle( ped ) ) then 
            local vehicle = GetVehiclePedIsIn( ped, false )

            if ( GetPedInVehicleSeat( vehicle, -1 ) == ped ) then 
                DeleteGivenVehicle( vehicle, numRetries )
            else 
                Notify( "You must be in the driver's seat!" )
            end 
        else
            local inFrontOfPlayer = GetOffsetFromEntityInWorldCoords( ped, 0.0, distanceToCheck, 0.0 )
            local vehicle = GetVehicleInDirection( ped, pos, inFrontOfPlayer )

            if ( DoesEntityExist( vehicle ) ) then 
                DeleteGivenVehicle( vehicle, numRetries )
            else 
                Notify( "~y~Vous devez être près d'un vehicule pour le supprimer." )
            end 
        end 
    end 
end )

function DeleteGivenVehicle( veh, timeoutMax )
    local timeout = 0 

    SetEntityAsMissionEntity( veh, true, true )
    DeleteVehicle( veh )

    if ( DoesEntityExist( veh ) ) then
        Notify( "~r~Echec, reessayez..." )

        -- Fallback if the vehicle doesn't get deleted
        while ( DoesEntityExist( veh ) and timeout < timeoutMax ) do 
            DeleteVehicle( veh )

            -- The vehicle has been banished from the face of the Earth!
            if ( not DoesEntityExist( veh ) ) then 
                Notify( "~g~Vehicule supprimé." )
            end 

            -- Increase the timeout counter and make the system wait
            timeout = timeout + 1 
            Citizen.Wait( 500 )

            -- We've timed out and the vehicle still hasn't been deleted. 
            if ( DoesEntityExist( veh ) and ( timeout == timeoutMax - 1 ) ) then
                Notify( "~r~Echec après " .. timeoutMax .. " essaies." )
            end 
        end 
    else 
        Notify( "~g~Vehicule supprimé." )
    end 
end 

-- Gets a vehicle in a certain direction
-- Credit to Konijima
function GetVehicleInDirection( entFrom, coordFrom, coordTo )
	local rayHandle = StartShapeTestCapsule( coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 5.0, 10, entFrom, 7 )
    local _, _, _, _, vehicle = GetShapeTestResult( rayHandle )
    
    if ( IsEntityAVehicle( vehicle ) ) then 
        return vehicle
    end 
end

-- Shows a notification on the player's screen 
function Notify( text )
    SetNotificationTextEntry( "STRING" )
    AddTextComponentString( text )
    DrawNotification( false, false )
end

-- fonction blip jaune
function blipy()
    local ped = PlayerPedId()
                    local currentPos = GetEntityCoords(ped)
                    print(currentPos)
                    destBlip = AddBlipForCoord(random.x, random.y, random.z)
                    SetBlipSprite(destBlip, 1)
                    SetBlipDisplay(destBlip, 4)
                    SetBlipScale(destBlip, 1.0)

                    -- Couleur jaune
                    SetBlipColour(destBlip, 5)

                    SetBlipAsShortRange(destBlip, false)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentString("Emplacement de la livraison")
                    EndTextCommandSetBlipName(destBlip)

                    -- Mettre en tant que destination
                    SetBlipRoute(destBlip, true)
end
local spawnLocations = 
{
    [1] = {x = -207.03, y = -659.44, z = 33.66},
    [2] = {x = -421.37, y = -666.25, z = 30.41},
    [3] = {x = -607.6, y = -667.54, z = 31.68},
    [4] = {x = -753.09, y = -641.67, z = 30.17},
}

random = spawnLocations[math.random(1, #spawnLocations)]
print(random.x, random.y, random.z)
-- fonction spawn de vehicule 

function spawnCar(car)
    local car = GetHashKey(car)

    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(50)
    end

    local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), false))
    local vehicle = CreateVehicle(car, -299.88, -900.09, 31.08, 114.07, GetEntityHeading(PlayerPedId()), true, false)

    
    SetEntityAsNoLongerNeeded(vehicle)
    SetModelAsNoLongerNeeded(vehicleName)
    
end

-- Création du blip

local blips = { 
     {title="PrimeEat", colour=4, id=77, x = -305.94, y = -897.82, z = 31.08}
}

Citizen.CreateThread(function()

    for _, info in pairs(blips) do
        info.blip = AddBlipForCoord(info.x, info.y, info.z)
        SetBlipSprite(info.blip, info.id)
        SetBlipDisplay(info.blip, 4)
        SetBlipScale(info.blip, 1.0)
        SetBlipColour(info.blip, info.colour)
        SetBlipAsShortRange(info.blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(info.title)
        EndTextCommandSetBlipName(info.blip)
    end
end)

-- Création du ped

Citizen.CreateThread(function()
    for a,b in pairs(Config.Pos) do
        for c,d in pairs(b) do
            local hash = GetHashKey(d.Ped)
            while not HasModelLoaded(hash) do
                RequestModel(hash)
                Wait(20)
            end
            ped = CreatePed("PED_TYPE_CIVFEMALE", d.Ped, d.Position, false, true)
            SetBlockingOfNonTemporaryEvents(ped, true)
            SetEntityInvincible(ped, true)
            FreezeEntityPosition(ped, true)
        end
    end
end)


function ShowNotification( text )
    SetNotificationTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
    DrawNotification(false, false)
end

vMenu.Add('boss', 'main', ValUI.CreateMenu("PrimeEat", "Pour gagner un peu de sous"))
vMenu.Add('boss', 'livraison', ValUI.CreateSubMenu(vMenu:Get('boss', 'main'), "PrimeEat", "Pour gagner un peu de sous"))

Citizen.CreateThread(function()
    while true do
        ValUI.IsVisible(vMenu:Get('boss', 'main'), true, true, true, function()
            ValUI.Button("Voir les missions disponibles", "Voyez quelle mission vous pouvez faire !", {RightLabel = "→→→"},true, function()
            end, vMenu:Get('boss', 'livraison'))
            ValUI.Button('Ranger le scooter', 'Permet de ranger son scooter', {RightLabel = ""}, true, function (Hovered, Active, Selected)
                if Selected then
                    TriggerEvent('wk:deleteVehicle')
                end
            end)

        end, function()
        end)

        ValUI.IsVisible(vMenu:Get('boss', 'livraison'), true, true, true, function()
            ValUI.Button("Commencer à livrer une pizza", "La caution du scooter vous coutera ~g~200$", {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if (Selected) then
                    blipy()
                    TriggerServerEvent('talec:item')
                    --PlaySoundFrontend(-1, "CHECKPOINT_MISSED", "HUD_MINI_GAME_SOUNDSET", 1)
                    spawnCar('faggio') 
                    ESX.ShowNotification("Va livrer ta pizza sur le point de la ~g~carte.")    
                end
            end)
            ValUI.Button('Commencer à livrer un tacos', 'La caution du scooter vous coutera ~g~200$', {RightLabel = ""}, true, function (Hovered, Active, Selected)
                if (Selected) then
                    blipy()
                    TriggerServerEvent('talec:item')
                    --PlaySoundFrontend(-1, "CHECKPOINT_MISSED", "HUD_MINI_GAME_SOUNDSET", 1)
                    spawnCar('faggio') 
                    ESX.ShowNotification("Va livrer ton tacos sur le point de la ~g~carte.")  
                end
            end)

        end, function()
        end)

    
            Citizen.Wait(0)
        end
    
    end)



    local position = {
        {x = -305.93 , y = -899.93, z = 31.08, }
    }    
    
    
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
    
            for k in pairs(position) do
    
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, position[k].x, position[k].y, position[k].z)
    
                if dist <= 1.0 then

                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour parler au ~b~patron")
                    if IsControlJustPressed(1,51) then
                        ValUI.Visible(vMenu:Get('boss', 'main'), not ValUI.Visible(vMenu:Get('boss', 'main')))
                    end
                end
            end
        end
    end)