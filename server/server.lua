ESX = exports.es_extended:getSharedObject()

local stashBoss = {
    
    id = 'bossinventory',
    label = 'Boss Inventory',
    slots = 500,
    weight = 4000000,
    owner = true,
    groups = {
        ballas = 3,
        families = 3,
        cartello = 3,
        mercatonero = 3
    },
}
 
AddEventHandler('onServerResourceStart', function(resourceName)
    if resourceName == 'ox_inventory' or resourceName == GetCurrentResourceName() then
        local property = exports.ox_inventory:RegisterStash(stashBoss.id, stashBoss.label, stashBoss.slots, stashBoss.weight, stashBoss.owner, stashBoss.groups)
    end
end)

local stashPlayer = {
    
    id = 'inventory',
    label = 'Player Inventory',
    slots = 50,
    weight = 100000,
    owner = true,
    groups = {
        ballas = 1,
        families = 1,
        cartello = 1,
        mercatonero = 1
    },
}
 
AddEventHandler('onServerResourceStart', function(resourceName)
    if resourceName == 'ox_inventory' or resourceName == GetCurrentResourceName() then
        local property = exports.ox_inventory:RegisterStash(stashPlayer.id, stashPlayer.label, stashPlayer.slots, stashPlayer.weight, stashPlayer.owner, stashPlayer.groups)
    end
end)



lib.callback.register('krs_factions:onDuty', function(source)
    local Player = ESX.GetPlayerFromId(source)
    if not Player then 
        print('Player not found')
        return false 
    end

    local identifier = Player.identifier
    local job = Player.job.name  
    local grade = Player.job.grade

    print('Player identifier:', identifier)
    print('Job name:', job)
    print('Job grade:', grade)

    local updateJob = MySQL.update.await('UPDATE users SET job = ?, job_grade = ? WHERE identifier = ?', {
        job, grade, identifier
    })

    if not updateJob then
        print('Failed to update job status for identifier:', identifier)
    else
        print('Successfully updated job status for identifier:', identifier)
    end

    return updateJob ~= nil
end)

lib.callback.register('krs_factions:offDuty', function(source)
    local Player = ESX.GetPlayerFromId(source)
    if not Player then 
        print('Player not found')
        return false 
    end

    local identifier = Player.identifier
    local job = "unemployed"
    local grade = 0  

    print('Setting job to unemployed and grade to 0 for identifier:', identifier)

    local updateJob = MySQL.update.await('UPDATE users SET job = ?, job_grade = ? WHERE identifier = ?', {
        job, grade, identifier
    })

    if not updateJob then
        print('Failed to update job status for identifier:', identifier)
    end

    return updateJob ~= nil
end)

function registerSociety()
    for jobName, _ in pairs(factionData) do
        local societyExists = false
        
        local promise = promise.new()
        TriggerEvent('esx_society:getSocieties', function(societies)
            for _, society in pairs(societies) do
                if society.name == jobName then
                    societyExists = true
                    break
                end
            end
            promise:resolve()
        end)

        Citizen.Await(promise)
        
        print('Verifica della società', jobName, 'esiste:', societyExists)
        
        if not societyExists then
            TriggerEvent('esx_society:registerSociety', jobName, jobName, 'society_' .. jobName, 'society_' .. jobName, 'society_' .. jobName, {type = 'public'})
            print('Registrata società:', jobName)
        else
            print('Società già registrata:', jobName)
        end
    end
end

CreateThread(registerSociety)