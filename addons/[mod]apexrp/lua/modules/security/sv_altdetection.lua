--[[
local function WarnAdminsAboutAlt(ply, code)
for _, SuperAdmin in pairs(player.GetHumans()) do
        if SuperAdmin:IsAdmin() then
            SuperAdmin:ChatPrint("[ALT-DETECTOR]: WARNING! " .. ply:Name() .. "(" .. ply:SteamID() .. ") joined on an alt! (CODE " .. code .. ")")
        end
    end
end

hook.Add("PlayerInitialSpawn", "AltDetector", function(ply)
    timer.Simple(2, function()
        if not ply:IsValid() then return end
        local IP = ply:IPAddress()
        local IPList = util.JSONToTable(file.Read("altfinder.txt", "DATA"))
        if not IPList[IP] then
            IPList[IP] = ply:SteamID()
            file.Write("altfinder.txt", util.TableToJSON(IPList))
        else
            if ply:SteamID() ~= IPList[IP] then
                for _, SuperAdmin in pairs(player.GetHumans()) do
                    if SuperAdmin:IsSuperAdmin() then
                        SuperAdmin:ChatPrint("[ALT-DETECTOR]: WARNING! " .. ply:Name() .. "(" .. ply:SteamID() .. ") joined on an alt! (IP Based Detection)" .. IPList[IP] .. " + " .. ply:IPAddress() )
                    end
                end
                -- ply:Kick("Duplicate IP Match")
            end
        end
    end)
end)
]]