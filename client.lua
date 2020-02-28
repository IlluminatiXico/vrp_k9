local Proxy = module("vrp", "lib/Proxy")
tvRP = Proxy.getInterface("vRP")


    local k9_name = "Собака" -- name dog
    local spawned_ped = nil
    local following = false
    local attacking = false
    local searching = false

    local animations = {
        ['Normal'] = {
            sit = {
                dict = "creatures@rottweiler@amb@world_dog_sitting@idle_a",
                anim = "idle_b"
            },
            laydown = {
                dict = "creatures@rottweiler@amb@sleep_in_kennel@",
                anim = "sleep_in_kennel"
            },
            searchhit = {
                dict = "creatures@rottweiler@indication@",
                anim = "indicate_high"
            }
        }
    }

   local function GetPlayers()
        local players = {}
        for i = 0, 32 do
            if NetworkIsPlayerActive(i) then
                table.insert(players, i)
            end
        end
        return players
    end
    
    
    -- Gets Player ID
 local   function GetPlayerId(target_ped)
        local players = GetPlayers()
        for a = 1, #players do
            local ped = GetPlayerPed(players[a])
            local server_id = GetPlayerServerId(players[a])
            if target_ped == ped then
                return server_id
            end
        end
        return 0
    end
    

local function GetLocalPed()
        return GetPlayerPed(PlayerId())
end



local function PlayAnimation(dict, anim)
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(5)
        end
    
        TaskPlayAnim(spawned_ped, dict, anim, 8.0, -8.0, -1, 2, 0.0, 0, 0, 0)
    end

local function RequestNetworkControl(callback)
        local netId = NetworkGetNetworkIdFromEntity(spawned_ped)
        NetworkRequestControlOfNetworkId(netId)
        while not NetworkHasControlOfNetworkId(netId) do
            Wait(5)
            NetworkRequestControlOfNetworkId(netId)
                callback(false)
                break
            end
            callback(true)
        end
    
--]]

--[[ Main Event Handlers ]]--

    -- Spawns and Deletes K9
    RegisterNetEvent("K9:ToggleK9")
    AddEventHandler("K9:ToggleK9", function(model)
        if spawned_ped == nil then
            local ped = GetHashKey(model)
            RequestModel(ped)
            while not HasModelLoaded(ped) do
                Wait(5)
                RequestModel(ped)
            end
            local plyCoords = GetOffsetFromEntityInWorldCoords(GetLocalPed(), 0.0, 2.0, 0.0)
            local dog = CreatePed(28, ped, plyCoords.x, plyCoords.y, plyCoords.z, GetEntityHeading(GetLocalPed()), 1, 1)
            spawned_ped = dog
            SetBlockingOfNonTemporaryEvents(spawned_ped, true)
            SetPedFleeAttributes(spawned_ped, 0, 0)
            SetPedRelationshipGroupHash(spawned_ped, GetHashKey("k9"))
            local blip = AddBlipForEntity(spawned_ped)
            SetBlipAsFriendly(blip, true)
            SetBlipSprite(blip, 442)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(tostring("GPS: ".. k9_name))
            EndTextCommandSetBlipName(blip)
            NetworkRegisterEntityAsNetworked(spawned_ped)
            while not NetworkGetEntityIsNetworked(spawned_ped) do
                NetworkRegisterEntityAsNetworked(spawned_ped)
                Wait(5)
            end
        else
            local has_control = false
            RequestNetworkControl(function(cb)
                has_control = cb
            end)
            if has_control then
                SetEntityAsMissionEntity(spawned_ped, true, true)
                DeleteEntity(spawned_ped)
                spawned_ped = nil
                if attacking then
                    SetPedRelationshipGroupDefaultHash(target_ped, GetHashKey("CIVMALE"))
                    target_ped = nil
                    attacking = false
                end
                following = false
                searching = false
                playing_animation = false
            end
        end
    end)

    -- Toggles K9 to Follow / Heel
    RegisterNetEvent("K9:ToggleFollow")
    AddEventHandler("K9:ToggleFollow", function()
        if spawned_ped ~= nil then
            if not following then
                local has_control = false
                RequestNetworkControl(function(cb)
                    has_control = cb
                end)
                if has_control then
                    TaskFollowToOffsetOfEntity(spawned_ped, GetLocalPed(), 0.5, 0.0, 0.0, 5.0, -1, 0.0, 1)
                    SetPedKeepTask(spawned_ped, true)
                    following = true
                    attacking = false
                    tvRP.notify("~g~Собака слудет за тобой")
                end
            else
                local has_control = false
                RequestNetworkControl(function(cb)
                    has_control = cb
                end)
                if has_control then
                    SetPedKeepTask(spawned_ped, false)
                    ClearPedTasks(spawned_ped)
                    following = false
                    attacking = false
                    tvRP.notify("~r~Собака остановилась")
                end
            end
        end
    end)


    -- Triggers K9 to Attack
    RegisterNetEvent("K9:ToggleAttack")
    AddEventHandler("K9:ToggleAttack", function(target)
        if not attacking and not searching then
            if IsPedAPlayer(target) then
                local has_control = false
                RequestNetworkControl(function(cb)
                    has_control = cb
                end)
                if has_control then
                    local player = GetPlayerFromServerId(GetPlayerId(target))
                    SetCanAttackFriendly(spawned_ped, true, true)
                    TaskPutPedDirectlyIntoMelee(spawned_ped, GetPlayerPed(player), 0.0, -1.0, 0.0, 0)
                    attacked_player = player
                end
            else
                local has_control = false
                RequestNetworkControl(function(cb)
                    has_control = cb
                end)
                if has_control then
                    SetCanAttackFriendly(spawned_ped, true, true)
                    TaskPutPedDirectlyIntoMelee(spawned_ped, target, 0.0, -1.0, 0.0, 0)
                    attacked_player = 0
                end
            end
            attacking = true
            following = false
            tvRP.notify("~r~Собака атакует~o~")
        end
    end)

--]]

--[[ Threads ]]

    -- Controls Menu
    Citizen.CreateThread(function()
        while true do
            Wait(5)
            -- Trigger Attack
            if IsControlJustPressed(1, 47) and IsPlayerFreeAiming(PlayerId()) then
                local bool, target = GetEntityPlayerIsFreeAimingAt(PlayerId())

                if bool then
                    if IsEntityAPed(target) then
                        TriggerEvent("K9:ToggleAttack", target)
                    end
                end
            end

            -- Trigger Follow
            if IsControlJustPressed(1, 47) and not IsPlayerFreeAiming(PlayerId()) then
                TriggerEvent("K9:ToggleFollow")
            end

        end
    end)



RegisterNetEvent("vrp_dog:spawndog")
AddEventHandler("vrp_dog:spawndog", function()
        TriggerEvent("K9:ToggleK9", "a_c_rottweiler")
    end)


    RegisterNetEvent("vrp_dog:sit")
    AddEventHandler("vrp_dog:sit", function()
        if spawned_ped ~= nil then
            PlayAnimation(animations['Normal'].sit.dict, animations['Normal'].sit.anim)
        end
    end)

    RegisterNetEvent("vrp_dog:laydown")
    AddEventHandler("vrp_dog:laydown", function()
        if spawned_ped ~= nil then
            PlayAnimation(animations['Normal'].laydown.dict, animations['Normal'].laydown.anim)
        end
    end)
