ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('talec:sell')
AddEventHandler('talec:sell', function ()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    item = xPlayer.getInventoryItem('bread').count
    print(item)
    if item > 0 then
        xPlayer.removeInventoryItem('bread', 1)
        xPlayer.addMoney(400)
    end
    if item <= 0 then 
        TriggerClientEvent('esx:showNotification', source, "Vous n'avez plus de~r~ pizza à livrer!")
    end
end)

RegisterServerEvent('talec:item')
AddEventHandler('talec:item', function ()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.removeMoney(200)
    xPlayer.addInventoryItem('bread', 3)
end)

RegisterServerEvent('talec:tacos')
AddEventHandler('talec:tacos', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.removeMoney(200)
    xPlayer.addInventoryItem('water', 3)
end)