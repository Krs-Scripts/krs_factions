local choiceAppearance = "illenium-appearance"  -- fivem-appearance / illenium-appearance

local function getPlayerData()
    ESX = exports.es_extended:getSharedObject()
    
    PlayerData = ESX.GetPlayerData()

    while not PlayerData or not PlayerData.job do
        Wait(100)
        PlayerData = ESX.GetPlayerData()
    end

    RegisterNetEvent('esx:playerLoaded', function()
        PlayerData = ESX.GetPlayerData()
    end)

    RegisterNetEvent('esx:setJob', function(job)
        PlayerData.job = job
    end)
end

CreateThread(getPlayerData)

RegisterCommand('test', function()
    print(PlayerData.job.name)
end)


local function openDutyMenu()
    lib.registerContext({
        id = 'duty_menu',
        title = 'Duty Menu',
        options = {
            {
                title = 'Go On Duty',
                description = 'Go on duty to begin your shift.',
                icon = 'fa-solid fa-id-badge', 
                iconAnimation = 'bounce',
                iconColor = '#20c997',
                onSelect = function()
                    local success = lib.callback.await('krs_factions:onDuty', 100)
                    if success then
                        lib.notify({title = 'Krs Factions', icon = 'fa-solid fa-id-badge', description = 'You are now on duty!', type = 'success'})
                    else
                        lib.notify({title = 'Krs Factions', icon = 'fa-solid fa-id-badge', description = 'Failed to go on duty.', type = 'error'})
                    end
                end
            },
            {
                title = 'Go Off Duty',
                description = 'Go off duty to end your shift.',
                icon = 'fa-solid fa-id-badge',
                iconAnimation = 'bounce',
                iconColor = '#fa5252',
                onSelect = function()
                    local success = lib.callback.await('krs_factions:offDuty', 100)
                    if success then
                        lib.notify({title = 'Krs Factions', icon = 'fa-solid fa-id-badge', description = 'You are now off duty!', type = 'success'})
                    else
                        lib.notify({title = 'Krs Factions', icon = 'fa-solid fa-id-badge', description = 'Failed to go off duty.', type = 'error'})
                    end
                end
            }
        }
    })
    lib.showContext('duty_menu')
end


local function openInventoryBoss()
    if PlayerData.job and PlayerData.job.grade_name == 'boss' then
        exports.ox_inventory:openInventory('stash', { id = 'bossinventory' })
    else
        lib.notify({title = 'Krs Factions', icon = 'fa-solid fa-id-badge', description = 'Non sei un capo.', type = 'error'})
    end
end

local function openBossMenu()
    if PlayerData.job then
        for faction, jobData in pairs(factionData) do
            if PlayerData.job.grade_name == 'boss' and PlayerData.job.name == faction then
                TriggerEvent('esx_society:openBossMenu', faction, function(data, menu)
                end, { wash = false })
                return
            end
        end
    end
    lib.notify({title = 'Krs Factions', icon = 'fa-solid fa-id-badge', description = 'Nessun lavoro valido o non sei un capo.', type = 'error'})
end

local function openOutfitBag()
    if choiceAppearance == 'illenium-appearance' then
        TriggerEvent("illenium-appearance:client:openOutfitMenu", function()
            OpenMenu(nil, "outfit")
        end)
    elseif choiceAppearance == 'fivem-appearance' then
        exports['fivem-appearance']:openWardrobe()
    end
end


local function openPlayerInventory()
    exports.ox_inventory:openInventory('stash', { id = 'inventory' })
end


local function openGarageFactions(garage)
    if not garage then
        print("Error: Garage object is nil")
        return
    end

    if not garage.titleMenu or not garage.posMenu or not garage.pos or not garage.spawnPoint or not garage.heading or not garage.plate or not garage.primaryColor or not garage.secondaryColor or not garage.car then
        print("Error: Garage object is missing required fields")
        return
    end

    print("Garage Configuration:")
    print("Title Menu: ", garage.titleMenu)
    print("Position Menu: ", garage.posMenu)
    print("Position: ", garage.pos)
    print("Spawn Point: ", garage.spawnPoint)
    print("Heading: ", garage.heading)
    print("Plate: ", garage.plate)
    print("Primary Color: ", table.concat(garage.primaryColor, ", "))
    print("Secondary Color: ", table.concat(garage.secondaryColor, ", "))
    print("Cars: ")
    for i, car in ipairs(garage.car) do
        print("  Car " .. i .. ": " .. car.label .. " (" .. car.value .. ")")
    end

    local options = {}

    for _, v in pairs(garage.car) do
        options[#options+1] = { 
            label = v.label,
            icon = 'fa-solid fa-car',
            args = { value = v.value }
        }
    end

    options[#options+1] = { 
        label = 'Deposit Vehicle',
        icon = 'fa-solid fa-warehouse',  
        args = { deposit = true }
    }

    lib.registerMenu({
        id = 'garageFazioni',
        title = garage.titleMenu,
        position = garage.posMenu,
        options = options
    }, function(selected, scrollIndex, args)
        if args.deposit then 
            local vehicle = GetVehiclePedIsIn(cache.ped, false)
            if vehicle then
                DeleteEntity(vehicle)
            end
        else
            local model = lib.requestModel(args.value) 
            if not model then return end

            local vehicle = CreateVehicle(model, garage.spawnPoint, true, false)
            SetVehicleCustomPrimaryColour(vehicle, garage.primaryColor[1], garage.primaryColor[2], garage.primaryColor[3])
            SetVehicleCustomSecondaryColour(vehicle, garage.secondaryColor[1], garage.secondaryColor[2], garage.secondaryColor[3])
            SetVehicleFuelLevel(vehicle, 100.0)
            SetEntityHeading(vehicle, garage.heading)
            SetVehicleNumberPlateText(vehicle, garage.plate)
            SetModelAsNoLongerNeeded(model)
            SetPedIntoVehicle(cache.ped, vehicle, -1)
        end
    end)

    lib.showMenu('garageFazioni')
end

local function registerMarker(factionData)
    for faction, data in pairs(factionData) do

        -- Deposito giocatore
        if data.depositPlayer then
            TriggerEvent('gridsystem:registerMarker', {
                name = 'inventory_player_factions'..faction,
                pos = data.depositPlayer,
                scale = vector3(0.50, 0.50, 0.50),
                size = vector3(1.5, 1.5, 1.5),
                msg = '[E] - INVENTORY PLAYERS FACTIONS',
                control = 'E',
                color = { r = 51, g = 154, b = 240 },
                type = 21,
                permission = faction,
                jobGrade = 1,
                action = function()
                    openPlayerInventory()
                end
            })
        end

        -- Deposito boss
        if data.depositoboss then
            TriggerEvent('gridsystem:registerMarker', {
                name = 'deposito_boss_factions'..faction,
                pos = data.depositoboss,
                scale = vector3(0.50, 0.50, 0.50),
                size = vector3(1.5, 1.5, 1.5),
                msg = '[E] - INVENTORY BOSS FACTIONS',
                control = 'E',
                color = { r = 51, g = 154, b = 240 },
                type = 21,
                permission = faction,
                jobGrade = 1,
                action = function()
                    openInventoryBoss()
                end
            })
        end

        -- Boss menu
        if data.bossmenu then
            TriggerEvent('gridsystem:registerMarker', {
                name = 'boss_menu_factions'..faction,
                pos = data.bossmenu,
                scale = vector3(0.50, 0.50, 0.50),
                size = vector3(1.5, 1.5, 1.5),
                msg = '[E] - BOSS MENU FACTIONS',
                control = 'E',
                color = { r = 51, g = 154, b = 240 },
                type = 21,
                permission = faction,
                jobGrade = 1,
                action = function()
                    openBossMenu()
                end
            })
        end

        -- Camerino (duty job)
        if data.dutyJob then
            TriggerEvent('gridsystem:registerMarker', {
                name = 'duty_factions'..faction,
                pos = data.dutyJob,
                scale = vector3(0.50, 0.50, 0.50),
                size = vector3(1.5, 1.5, 1.5),
                msg = '[E] - DUTY FACTIONS',
                control = 'E',
                color = { r = 51, g = 154, b = 240 },
                type = 21,
                permission = faction,
                jobGrade = 1,
                action = function()
                    openDutyMenu()
                end
            })
        end

        -- Camerino (guardaroba)
        if data.wardrobe then
            TriggerEvent('gridsystem:registerMarker', {
                name = 'wardrobe_factions'..faction,
                pos = data.wardrobe,
                scale = vector3(0.50, 0.50, 0.50),
                size = vector3(1.5, 1.5, 1.5),
                msg = '[E] - WARDROBE FACTIONS',
                control = 'E',
                color = { r = 51, g = 154, b = 240 },
                type = 21,
                permission = faction,
                jobGrade = 1,
                action = function()
                    openOutfitBag()
                end
            })
        end

        -- Garage
        if data.garage and data.garage.pos then
            TriggerEvent('gridsystem:registerMarker', {
                name = 'garage_factions'..faction,
                pos = data.garage.pos,
                scale = vector3(1.50, 1.50, 1.50),
                size = vector3(1.5, 1.5, 1.5),
                drawDistance = 7.0,
                msg = '[E] - GARAGE FACTIONS',
                control = 'E',
                color = { r = 51, g = 154, b = 240 }, 
                type = 20,
                permission = faction,
                jobGrade = 1,
                action = function()
                    openGarageFactions(data.garage)
                end
            })
        end
    end
end

registerMarker(factionData)
