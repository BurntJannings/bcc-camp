--------------------- Variables Used ----------------------------------
local tentcreated, benchcreated, campfirecreated, storagechestcreated, hitchpostcreated, fasttravelpostcreated,polecreated = false,
    false, false, false, false, false,false
local hitchpost, tent, bench, campfire, storagechest, fasttravelpost, broll,pole, blip, outoftown

------- Event To Register Inv After Char Selection ------
RegisterNetEvent('vorp:SelectedCharacter')
AddEventHandler('vorp:SelectedCharacter', function(charid)
    Wait(7000)
    TriggerServerEvent('bcc-camp:CampInvCreation', charid)
end)

---------------------- Prop Spawning -----------------------------------
function spawnPole(campname)
    local model = GetHashKey('mp001_s_mpcorona01x')
    local infrontofplayer = IsThereAnyPropInFrontOfPed(PlayerPedId())
    if infrontofplayer or polecreated then
        VORPcore.NotifyRightTip(_U('CantBuild'), 4000)
    else
        progressbarfunc(Config.SetupTime.TentSetuptime, _U('SettingTentPbar'))
        modelload(model)
        --TentSpawn
        local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, 0))
        pole = CreateObject(model, x, y, z, true, true, false)
        PropCorrection(pole)
        polecreated = true
        if Config.CampBlips.enable then
            blip = BccUtils.Blips:SetBlip(Config.CampBlips.BlipName, Config.CampBlips.BlipHash, 0.2, x, y, z)
        end
		exports['bcc-posse']:CreatePosseExport(campname)

        while DoesEntityExist(pole) do
            Wait(5)
            local x2, y2, z2 = table.unpack(GetEntityCoords(PlayerPedId()))
            local dist = GetDistanceBetweenCoords(x, y, z, x2, y2, z2, true)
            if dist < 2 then
                BccUtils.Misc.DrawText3D(x, y, z, _U('OpenCampMenu'))
                if IsControlJustReleased(0, 0x760A9C6F) then
                    MainCampmenu() --opens the menu
                end
            elseif dist > 200 then
                Wait(2000)
            end
        end
    end
end


function spawnTent(model)
    local infrontofplayer = IsThereAnyPropInFrontOfPed(PlayerPedId())
    if infrontofplayer or tentcreated then
        VORPcore.NotifyRightTip(_U('CantBuild'), 4000)
    else
        progressbarfunc(Config.SetupTime.TentSetuptime, _U('SettingTentPbar'))
        local model2 = 'p_bedrollopen01x'
        modelload(model)
        modelload(model2)
        --TentSpawn
        local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, 0))
        tent = CreateObject(model, x, y, z, true, true, false)
        PropCorrection(tent)
        tentcreated = true
        broll = CreateObject(model2, x, y, z, true, true, false)
        PropCorrection(broll)
        SetEntityHeading(broll, GetEntityHeading(broll) + 90) --this sets the beroll properly headed
    end
end

function spawnItem(furntype, model)
    local infrontofplayer = IsThereAnyPropInFrontOfPed(PlayerPedId())
    local notneartent = notneartentdistcheck(tent)
    local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, 0))
    if infrontofplayer or notneartent then
        VORPcore.NotifyRightTip(_U('CantBuild'), 4000)
    else
        modelload(model)
        if furntype == 'bench' then
            if benchcreated then
                VORPcore.NotifyRightTip(_U('CantBuild'), 4000)
            else
                progressbarfunc(Config.SetupTime.BenchSetupTime, _U('SettingBucnhPbar'))
                bench = CreateObject(model, x, y, z, true, true, false)
                benchcreated = true
                PropCorrection(bench)
            end
        elseif furntype == 'campfire' then
            if campfirecreated then
                VORPcore.NotifyRightTip(_U('CantBuild'), 4000)
            else
                progressbarfunc(Config.SetupTime.FireSetupTime, _U('FireSetup'))
                campfire = CreateObject(model, x, y, z, true, true, false)
                PropCorrection(campfire)
                campfirecreated = true
            end
            while DoesEntityExist(campfire) do
                Wait(5)
                local x2, y2, z2 = table.unpack(GetEntityCoords(PlayerPedId()))
                local dist = GetDistanceBetweenCoords(x, y, z, x2, y2, z2, true)
                if dist < 2 then
                    BccUtils.Misc.DrawText3D(x, y, z, _U('RemoveFire'))
                    if IsControlJustReleased(0, 0x156F7119) then
                        extinguishedCampfire()
                    end
                elseif dist > 200 then
                    Wait(2000)
                end
            end
        elseif furntype == 'hitchingpost' then
            if hitchpostcreated then
                VORPcore.NotifyRightTip(_U('CantBuild'), 4000)
            else
                progressbarfunc(Config.SetupTime.HitchingPostTime, _('HitchingPostSetup'))
                hitchpost = CreateObject(model, x, y, z, true, true, false)
                PropCorrection(hitchpost)
                hitchpostcreated = true
            end
        end
    end
end

function spawnStorageChest(model)
    local infrontofplayer = IsThereAnyPropInFrontOfPed(PlayerPedId())
    local notneartent = notneartentdistcheck(tent)
    if infrontofplayer or storagechestcreated or notneartent then
        VORPcore.NotifyRightTip(_U('CantBuild'), 4000)
    else
        progressbarfunc(Config.SetupTime.StorageChestTime, _U('StorageChestSetup'))
        modelload(model)
        local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, 0))
        storagechest = CreateObject(model, x, y, z, true, true, false)
        PropCorrection(storagechest)
        storagechestcreated = true
        while DoesEntityExist(storagechest) do
            Wait(10)
            local x2, y2, z2 = table.unpack(GetEntityCoords(PlayerPedId()))
            local dist = GetDistanceBetweenCoords(x, y, z, x2, y2, z2, true)
            if dist < 2 then
                BccUtils.Misc.DrawText3D(x, y, z - 1, _U('OpenCampStorage'))
                if IsControlJustReleased(0, 0x760A9C6F) then
                    TriggerServerEvent('bcc-camp:OpenInv')
                end
            elseif dist > 200 then
                Wait(2000)
            end
        end
    end
end

function spawnFastTravelPost()
    local infrontofplayer = IsThereAnyPropInFrontOfPed(PlayerPedId())
    local notneartent = notneartentdistcheck(tent)
    if infrontofplayer or fasttravelpostcreated or notneartent then
        VORPcore.NotifyRightTip(_U('CantBuild'), 4000)
    else
        progressbarfunc(Config.SetupTime.FastTravelPostTime, _U('FastTravelPostSetup'))
        local model = 'mp001_s_fasttravelmarker01x'
        modelload(model)
        local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, 0))
        fasttravelpost = CreateObject(model, x, y, z, true, true, false)
        PropCorrection(fasttravelpost)
        fasttravelpostcreated = true
        while DoesEntityExist(fasttravelpost) do
            Wait(5)
            local x2, y2, z2 = table.unpack(GetEntityCoords(PlayerPedId()))
            local dist = GetDistanceBetweenCoords(x, y, z, x2, y2, z2, true)
            if dist < 2 then
                BccUtils.Misc.DrawText3D(x, y, z, _U('OpenFastTravel'))
                if IsControlJustReleased(0, 0x760A9C6F) then
                    Tpmenu()
                end
            elseif dist > 200 then
                Wait(2000)
            end
        end
    end
end

------------------Player Left Handler--------------------
--Event to detect if player leaves
AddEventHandler('playerDropped', function()
    delcamp()
end)

------------------- Destroy Camp Setup ------------------------------
function delcamp()
    if tentcreated then
        if Config.CampBlips then
            BccUtils.Blip:RemoveBlip(blip.rawblip)
        end
        tentcreated = false
        DeleteObject(tent)
        DeleteObject(broll)
    end
    if benchcreated then
        benchcreated = false
        DeleteObject(bench)
    end
    if campfirecreated then
        campfirecreated = false
        DeleteObject(campfire)
    end
    if storagechestcreated then
        storagechestcreated = false
        DeleteObject(storagechest)
    end
    if hitchpostcreated then
        hitchpostcreated = false
        DeleteObject(hitchpost)
    end
    if fasttravelpostcreated then
        fasttravelpostcreated = false
        DeleteObject(fasttravelpost)
    end
end

-- Command Setup
CreateThread(function()
    if Config.CampCommand then
        RegisterCommand(Config.CommandName, function()
            TriggerEvent('bcc-camp:NearTownCheck')
        end)
    end
end)

----------------------- Distance Check for player to town coordinates --------------------------------
local cdown = false
RegisterNetEvent('bcc-camp:NearTownCheck')
AddEventHandler('bcc-camp:NearTownCheck', function()
    if not Config.SetCampInTowns then
        outoftown = true
        if Config.CampItem.enabled and Config.CampItem.RemoveItem then
            TriggerServerEvent('bcc-camp:RemoveCampItem')
        end
    else
        local pl2 = PlayerPedId()
        for k, e in pairs(Config.Towns) do
            local pl = GetEntityCoords(pl2)
            if GetDistanceBetweenCoords(pl.x, pl.y, pl.z, e.coordinates.x, e.coordinates.y, e.coordinates.z, false) > e.range then
                outoftown = true
            else
                VORPcore.NotifyRightTip(_U('Tooclosetotown'), 4000)
                outoftown = false
                break
            end
        end
    end
    if outoftown then
        if Config.Cooldown then
            if not cdown then
                if Config.CampItem.enabled then
                    TriggerServerEvent('bcc-camp:RemoveCampItem')
                end
                cdown = true
                TriggerInput('Create', 'Name of Camp', 'Setup')
            else
                VORPcore.NotifyRightTip(_U('Cdown'), 4000)
            end
        else
            if Config.CampItem.enabled then
                TriggerServerEvent('bcc-camp:RemoveCampItem')
            end
            TriggerInput('Create', 'Name of Camp', 'Setup')
        end
    end
end)
----------------------------------- Delete camp fire -----------------------
function extinguishedCampfire()
    if campfirecreated then
        local objectCoords = GetEntityCoords(campfire)
        progressbarfunc(Config.SetupTime.FireSetupTime, _U('FireSetup'))
        DeleteObject(campfire)
        campfirecreated = false
    end
end

----------------------- Delete camp when resource stops -----------------------------------
AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        delcamp()
    end
end)
