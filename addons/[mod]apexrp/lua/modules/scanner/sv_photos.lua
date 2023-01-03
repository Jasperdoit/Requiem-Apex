util.AddNetworkString("nutScannerData")
util.AddNetworkString("nutScannerPicture")
util.AddNetworkString("nutScannerClearPicture")

net.Receive("nutScannerData", function(length, client)
    if (IsValid(client.nutScn) and client:GetViewEntity() == client.nutScn and (client.nutNextPic or 0) < CurTime()) then
        local delay = GAMEMODE.Config.scannerPictureDelay or 15;
        client.nutNextPic = CurTime() + delay - 1

        local length = net.ReadUInt(16)
        local data = net.ReadData(length)

        if (length != #data) then
            return
        end

        local receivers = {}

        for k, v in ipairs(player.GetAll()) do
            if (hook.Run("CanPlayerReceiveScan", v, client)) then
                receivers[#receivers + 1] = v
                v:EmitSound("npc/overwatch/radiovoice/preparevisualdownload.wav")
            end
        end

        if (#receivers > 0) then
            net.Start("nutScannerData")
                net.WriteUInt(#data, 16)
                net.WriteData(data, #data)
            net.Send(receivers)

            if ( combineMessages ) then -- If this module exists we are gonna use it 
                combineMessages:addFiltered( receivers, Color( 255, 255, 0 ), "Prepare to receive visual download" );
            end 
        end
    end
end)

net.Receive("nutScannerPicture", function(length, client)
    if (client.nextscannertime or 0) > CurTime() or not client:IsValid() then return end
	client.nextscannertime = CurTime() + 1
    if (not IsValid(client.nutScn)) then return end
    if (client:GetViewEntity() ~= client.nutScn) then return end
    if ((client.nutNextFlash or 0) >= CurTime()) then return end

    client.nutNextFlash = CurTime() + 1
    client.nutScn:flash()

    for _, victims in pairs(ents.FindInCone(client.nutScn:GetPos() + Vector(0, 0, 5), client:GetAimVector(), 450, math.cos(math.rad(client:GetFOV())))) do
        if not victims:IsPlayer() then continue end
        if victims == client then continue end
        if victims:isCombine() then continue end
        for _, entities in pairs(ents.FindInCone(victims:GetPos(), victims:GetAimVector(), 450, math.cos(math.rad(victims:GetFOV())))) do
            if entities == client.nutScn then
                victims:ScreenFade(SCREENFADE.IN, color_white, 1, 2)
            end
        end
    end
    local malignantlist = {}
    for _, target in pairs(ents.FindInCone(client.nutScn:GetPos() + Vector(0, 0, 5), client:GetAimVector(), 450, math.cos(math.rad(22)))) do
        if not target:IsPlayer() then continue end
        if ((not target:GetNWBool("IsRebelscum", false) and not (target:GetActiveWeapon():GetClass():find("fl_"))) or target:GetNWBool("citizenshipRevoked", false) and not target:isCombine()) then continue end
        local strings = {name = client:Name(), msg = "[AUTOMATED] Anti-Citizen Detected" or false, steamid = client:SteamID()}
        local transmitstring = util.TableToJSON(strings)
        net.Start("waypointmarker")
            net.WriteVector(target:GetPos())
            net.WriteString(transmitstring)
			net.Broadcast()
        table.insert(malignantlist, target)
    end
    citizenship:setMalignant(unpack(malignantlist))
end)