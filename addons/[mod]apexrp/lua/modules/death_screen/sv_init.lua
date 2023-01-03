util.AddNetworkString("deathTimer");

local function jobSwitch(ply)
    ply.notJobSwitch = true;
end 

hook.Add("PlayerDeath", "hl2rp: death screen", jobSwitch);

local function deathThink(ply)
    if (ply.notJobSwitch) then      
        if not (timer.Exists( "death-timer:" .. ply:SteamID() )) and not (ply.canRespawn) then 
            local time = ((ply:IsAdmin() or ply:IsUserGroup("vip")) and GAMEMODE.Config.DeathTimerVIP) or GAMEMODE.Config.DeathTimer;

            net.Start("deathTimer");
                net.WriteInt(time, 8);
            net.Send(ply);

            timer.Create("death-timer:" .. ply:SteamID(), time, 1, function()
                  ply.canRespawn = true;      
            end );
        end 

        if ((ply:IsAdmin()) or (ply.canRespawn)) and (ply:KeyPressed( IN_ATTACK ) or ply:KeyPressed( IN_ATTACK2 ) or ply:KeyPressed( IN_JUMP )) then 
            if (timer.Exists("death-timer:" .. ply:SteamID())) then 
                timer.Remove("death-timer:" .. ply:SteamID());
            end 

            ply:Spawn();
            ply.canRespawn = nil;
            ply.notJobSwitch = nil;
        end 

        return false;
    end 
end 

hook.Add("PlayerDeathThink", "hl2rp: death screen", deathThink);