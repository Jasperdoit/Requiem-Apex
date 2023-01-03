---------------------------------------------------------------------------
	-- Methods.
---------------------------------------------------------------------------

local meta = FindMetaTable( "Player" );

---------------------------------------------------------------------------
	-- Caching net messages.
---------------------------------------------------------------------------
	
util.AddNetworkString( "divisionSelect" );
util.AddNetworkString( "scConvert");
util.AddNetworkString( "scBuy");

CreateConVar("divisions_xp_multiplier", 1);

---------------------------------------------------------------------------
	-- Functions.
---------------------------------------------------------------------------

function divisions:setDivision( ply, div, rank )
	if not ( IsValid( ply ) ) then return; end 

	self:resetDivision( ply );

	if not ( self.Data[ div ] ) then 
		return;
	end 

	if not ( rank ) then 
		rank = 0;
	end 

	local health = (self.Data[div].health or 100) + ((self.Data[div].ranks and self.Data[div].ranks[rank].additional_health) or 0);
	local armor = (self.Data[div].armor or 0) + ((self.Data[div].ranks and self.Data[div].ranks[rank].additional_armor) or 0);
	
	ply:SetMaxHealth(health);
	ply:SetHealth(health);
	ply:SetMaxArmor(armor);
	ply:SetArmor(armor);
	ply:SetNWInt( "division", div );
	ply:SetNWInt( "divisionRank", rank );
	ply:StripWeapons();
	ply.issuedLoadout = {}

	gamemode.Call("PlayerLoadout", ply);
	
	for _, wep in ipairs(self.Data[div].loadout or {}) do 
		table.insert(ply.issuedLoadout, wep)
		ply:Give(wep);
	end  

	local sc = (self.Data[ div ].sc or 0) + ((self.Data[div].ranks and self.Data[div].ranks[rank].additional_sc) or 0);
	local divName = self.Data[ div ].name;
	local rankName;
		
	if ( rank > 0 ) then
		for k, v in ipairs( self.Data[ div ].ranks ) do 
			if ( rank < k ) then break; end 		
			
			for _, wep in ipairs(self.Data[div].ranks[k].additional_loadout or {}) do 
				table.insert(ply.issuedLoadout, wep)
				ply:Give(wep);
			end 
		end 
		
		rankName = self.Data[div].ranks[rank].name;
	end  

	self:setSC( ply, sc );
	
	if (RPExtraTeams[ply:Team()].nameTemplate) then 
		local template = RPExtraTeams[ ply:Team() ].nameTemplate; 
		template = string.gsub( template, "<city>", self.city or "UNKNOWN" );
		template = string.gsub( template, "<division>", divName or "UNKNOWN");
		template = string.gsub( template, "<rank>", rankName or "UU" ); 
		template = string.gsub( template, "<digits>", ply:getDigits() ); 
		template = string.gsub( template, "<tag>", (self.Tags[ply:Team()] and self.Tags[ply:Team()][math.random(1, #self.Tags[ply:Team()])]) or self.Tags[-1][math.random(1, #self.Tags[-1])]);
		
		ply:setDarkRPVar( "rpname", template );
	end 
	
	if (rankName) then 
		ply:updateJob(RPExtraTeams[ply:Team()].name .. " (" ..  divName .. "-" .. rankName .. ")");
	else 
		ply:updateJob(RPExtraTeams[ply:Team()].name .. " (" .. divName .. ")");
	end 
	
	ply:SetModel((self.Data[div].ranks and self.Data[div].ranks[rank].model) or self.Data[ div ].model);
   	ply:SetSkin((self.Data[div].ranks and self.Data[ div ].ranks[ rank ].skin) or self.Data[ div ].skin or 0);

	if ( combineMessages ) then 
		combineMessages:addFiltered( player.GetAll(), Color( 255, 255, 255), "Unit " .. ply:Name() .. " is now on duty, 10-8" );
	
		timer.Simple( 2, function()
			if not ( IsValid( ply ) ) then return; end 

			if ( sc > 0 ) then 
				combineMessages:add( ply, Color( 0, 255, 0), "Issuing " .. sc .. " sterilized credits." );
			else 
				combineMessages:add( ply, Color( 255, 0, 0), "Issuing no sterilized credits." );
			end 
		end );
	end 
    
    local name = "div-xp:" .. ply:SteamID();
    
	timer.Create( name, self.timer or 300, 0, function()
		if not (IsValid(ply)) then 
			timer.Remove(name);
           	return; 
       	end
            
       	if (ply:getDarkRPVar("afk")) then return; end
            
        local amount = self.xp * (GetConVar("divisions_xp_multiplier"):GetInt() or 1);
        local sc = self.sc;
        
        if (ply:IsUserGroup("vip")) or (ply:IsAdmin()) then 
            amount = amount * 2;
            sc = sc * 3;
        end 
            
        self:addXP( ply, amount or 5);
		self:addSC(ply, sc or 1);
		
		if (combineMessages ) then 
			combineMessages:add( ply, Color(0, 255, 0), "Issuing " .. sc .. " sterilized credits." );
		else 
			ply:notify("Dispatch has awarded you with " .. sc .. " sterilized credit.");
		end
	end  )
end 

function divisions:resetDivision( ply )
	if not ( IsValid( ply ) ) then return; end 
	ply.issuedLoadout = nil
	timer.Remove( "div-xp:" .. ply:SteamID() );
	ply:SetNWInt( "division", 0 );
	ply:SetNWInt( "divisionRank", 0 );
end 

function divisions:addXP( ply, amount )
	if not ( IsValid( ply ) ) or ( ply:getDivision() == 0 ) then return; end 

	local division = ply:getDivision();
	local divName = ply:getDivisionData().name;
	local oldXP = ply:getDivisionXP();

	ply:notify( "You have been awarded " .. ( amount or 5 ) .. " xp for playing as " .. divName .. "." );
	ply:SetNWInt( divName .. ":xp", oldXP + amount or 5 );
	ply:SetPData( divName .. ":xp", oldXP + amount or 5 );
end 

function divisions:updateXP( ply )			
	if not ( ply ) then 
        for _, ply in pairs(player.GetAll()) do 
            for id, div in pairs( self.Data ) do
                if not ( ply:GetPData( div.name .. ":xp" ) ) then 
                    ply:SetPData( div.name .. ":xp", 0 );
                    ply:SetNWInt( div.name .. ":xp", 0 );
                else 
                    ply:SetNWInt( div.name .. ":xp", tonumber( ply:GetPData( div.name .. ":xp", 0 ) ) );
                end 
            end  
        end 
        
        return; 
    end 

	for id, div in pairs( self.Data ) do
		if not ( ply:GetPData( div.name .. ":xp" ) ) then 
			ply:SetPData( div.name .. ":xp", 0 );
			ply:SetNWInt( div.name .. ":xp", 0 );
		else 
			ply:SetNWInt( div.name .. ":xp", tonumber( ply:GetPData( div.name .. ":xp", 0 ) ) );
		end 
	end  
end 

function divisions:setDigits(ply, digits)
	if not (IsValid(ply)) then return; end 
	ply:SetNWInt("digits", digits)
end 

function divisions:setSC(ply, amount)
	if not (IsValid(ply)) then return; end 
	ply:SetNWInt("sCredits", tonumber(amount) or 0);
end 	
	
function divisions:addSC(ply, amount)
	if not (IsValid(ply)) then return; end 
	ply:SetNWInt("sCredits", ply:getSC() + tonumber(amount) or 0);
end

---------------------------------------------------------------------------
	-- Callbacks.
---------------------------------------------------------------------------

net.Receive( "divisionSelect", function( len, ply )
	if (ply.nextDivisionSelectTime or 0) > CurTime() then return end
	ply.nextDivisionSelectTime = CurTime() + 1
	local divs = divisions.Data;
	local div = net.ReadInt( 8 );
	local rank = net.ReadInt( 8 );
        
    -- Distance check;
    
    local notNear = true;
        
    for _, ent in pairs(ents.FindByClass("divisions_npc")) do 
        if (ply:GetPos():DistToSqr(ent:GetPos()) < 40000)  then 
                notNear = false;
                break;
        end 
    end 
        
    if (notNear) then return; end 

	if not ( divs[ div ] ) then -- Checking if division exists
		return; 
	else 
		if not ( divs[ div ].access[ ply:Team() ] ) then 
			return;
		end 

		if (divs[div].xp ) and ( divs[ div ].xp > ply:getXP() ) then -- Checking if player has enough XP
			return;
		end 
		
		if (divs[div].custom_check) and not (divs[div].custom_check(ply)) then 
			return;
		end 
	end 

	local hasRank = false; 

	if not ( rank == 0 ) and ( divs[ div ].ranks ) then -- Checking if rank exists
		if (divs[ div ].ranks[ rank ].xp) and ( divs[ div ].ranks[ rank ].xp > ply:GetNWInt( divs[ div ].name .. ":xp", 0 ) ) then  
			return;
		end 
		
		if (divs[div].ranks[rank].custom_check) and not (divs[div].ranks[rank].custom_check(ply)) then 
			return;
		end 

		hasRank = true;
	end 

	if ( hasRank ) then 
		if ( ply:getDivisionRank() == rank ) and ( ply:getDivision() == div ) then 
			return; 
		end 
		
		if (divs[div].ranks[rank].slots) then
			local amount = 0;
			
			for _, cp in ipairs(player.GetAll()) do 
				if (cp:getDivisionRank() == rank) and (cp:getDivision() == div) and (cp != ply) then 
					amount = amount + 1
				
					if (amount == divs[div].ranks[rank].slots) then 
						return;
					end 
				end 
			end 
			if (amount == divs[div].ranks[rank].slots) then 
				return;
			end
		end 
	else 
		if ( ply:getDivision() == div ) then 
			return;
		end
	end  
	
	if (divs[div].slots) then 
		local amount = 0;
		
		for _, cp in ipairs(player.GetAll()) do 
			if (cp:getDivision() == div) and (cp != ply) then 
				amount = amount + 1;
				
				if (amount == divs[div].slots) then 
					return;
				end 
			end 
		end
            
		if (amount == divs[div].slots) then 
			return;
		end 
	end 

	divisions:setDivision( ply, div, rank );
end );

net.Receive("scConvert", function(len, ply)
	if (ply.nextConvertTime or 0) > CurTime() then return end
	ply.nextConvertTime = CurTime() + 1
	if not (ply:isCombine()) then return; end

    local notNear = true;

    for _, ent in pairs(ents.FindByClass("vendor_npc")) do 
        if (ply:GetPos():DistToSqr(ent:GetPos()) < 40000)  then 
                notNear = false;
                break;
        end 
    end 

    if (notNear) then return; end 

	
	local tokens = net.ReadInt(16);
	local wallet = ply:getDarkRPVar("money", 0);
	local conversion = math.floor((math.abs(tokens) or 0) / divisions.rate);
	
	print(tokens, wallet, conversion);
	
	if (math.abs(tokens) > wallet) then return; end
	if (conversion == 0) then return; end 
	
	ply:AddMoney(-(conversion * divisions.rate));
	divisions:addSC(ply, conversion);
	ply:notify("You have converted " .. tokens .. "T to " .. conversion .. "SC!");
end );

net.Receive("scBuy", function(len, ply)
	if (ply.nextBuyTime or 0) > CurTime() then return end
	ply.nextBuyTime = CurTime() + 1
	if not (ply:isCombine()) then return; end

    local notNear = true;

    for _, ent in pairs(ents.FindByClass("vendor_npc")) do 
        if (ply:GetPos():DistToSqr(ent:GetPos()) < 40000)  then 
                notNear = false;
                break;
        end
    end

    if (notNear) then return; end 
	
	local tbl = net.ReadTable();
	local balance = ply:getSC();
	
	for _, id in ipairs(tbl) do 
		if (ply:getSC() - divisions.Vendor[id].cost < 0) then continue; end 
		
		divisions:addSC(ply, -divisions.Vendor[id].cost);
		
		if (type(divisions.Vendor[id].class) == "string") then 
			ply:Give(divisions.Vendor[id].class);
		else 
			divisions.Vendor[id].class(ply);
		end 
	end 
end );

---------------------------------------------------------------------------
	-- Console commands.
---------------------------------------------------------------------------

local function printXP( ply )
	for id, div in pairs( divisions.Data ) do 
		print( "XP for " .. div.name .. ":" .. ply:GetNWInt( div.name .. ":xp" ) );
	end 
end 

concommand.Add( "divisions_checkxp", printXP );

local function giveXP(ply, cmd, args)
    if not (ply:IsSuperAdmin()) then return; end 
    
    for _, ply in ipairs(player.GetAll()) do 
        if (args[1] == ply:Name()) then 
        	divisions:addXP(ply, tonumber(args[2]))
            
            break;
        end 
    end 
end 

concommand.Add("rg_divxp", giveXP);

local function addSC(ply, cmd, args)
    if not (ply:IsSuperAdmin()) then return; end 
    
    for _, ply in ipairs(player.GetAll()) do 
        if (args[1] == ply:Name()) then 
        	divisions:addSC(ply, tonumber(args[2]))
            
            break;
        end 
    end 
end 

concommand.Add("rg_givesc", addSC);

local function xpMultiplier(ply, cmd, args)
    if not (ply:IsSuperAdmin()) then return; end
    
    GetConVar("divisions_xp_multiplier"):SetInt(tonumber(args[1]))
end 

concommand.Add("rg_divxp_multiplier", xpMultiplier);

---------------------------------------------------------------------------
	-- Hooks.
---------------------------------------------------------------------------
	
local function divisionSpawn( ply )
	if ( ply:getDivision() > 0 ) then 
		divisions:resetDivision( ply );
		ply.issuedLoadout = nil;
	end 

	if ( ply:isCombine() ) and ( RPExtraTeams[ ply:Team() ].nameTemplate ) then 
		local digits = math.random( 1, 99 );
		divisions:setDigits( ply, digits );
		ply:updateJob(RPExtraTeams[ply:Team()].name .. " (UNASSIGNED)");
        
		timer.Simple( .2, function()
			if not ( IsValid( ply ) ) then return; end 

			local template = RPExtraTeams[ ply:Team() ].nameTemplate; 

			template = string.gsub( template, "<city>", divisions.city or "UNKNOWN" );
			template = string.gsub( template, "<division>", "UNSG" );
			template = string.gsub( template, "<rank>", "UNSG" ); 
			template = string.gsub( template, "<digits>", digits ); 
			template = string.gsub( template, "<tag>", "UNSG");
			
			ply:setDarkRPVar( "rpname", template );
		end );
	elseif ply:isCombine() and ply:Team() ~= TEAM_DISPATCH then
        ply:updateJob(RPExtraTeams[ply:Team()].name .. " (UNASSIGNED)");
        
		if ( ply:getDigits() > 0 ) then 
			divisions:setDigits( ply, nil );
		end 
	end 
end 

hook.Add( "PlayerSpawn", "[module] divisions: player spawn", divisionSpawn );

local function changeName( ply, name )
	if ( ply:isCombine() ) and ( RPExtraTeams[ ply:Team() ].nameTemplate ) then 
		return false;
	end  
end 

hook.Add( "CanChangeRPName", "[module] divisions: can change name", changeName );

local function handleXP( ply )
	if not ( ply ) then 
		for _, client in ipairs( player.GetAll() ) do 
			divisions:updateXP( client )
		end 
	else 
		divisions:updateXP( ply );
	end 
end 

hook.Add( "PlayerInitialSpawn", "[module] divisions: div update", handleXP)

local function awardKill(victim, inflictor, attacker) 
    if (divisions) and (attacker:IsValid()) and (attacker:IsPlayer()) and (attacker:getDivision() > 0) then
        if (victim:GetNWBool("IsRebelScum", false)) then 
            divisions:addSC(attacker, 3);
            if (combineMessages) then 
           		combineMessages:add( attacker, Color(0, 255, 0), "Issuing 3SC for a 647E.");
			else 
                attacker:notify("You have been awarded 3SC for killing a 647E.");
            end 
        elseif (victim:GetNWBool("HasbeenDefunct", false)) then 
            divisions:addSC(attacker, 5);
            if (combineMessages) then 
           		combineMessages:add( attacker, Color(0, 255, 0), "Issuing 5SC for killing a defunct unit.");
			else 
                attacker:notify("You have been awarded 5SC for killing a defunct unit.");
            end 
        elseif (victim:GetNWBool("IsRogue", false)) then 
            divisions:addSC(attacker, 5);
            if (combineMessages) then 
           		combineMessages:add( attacker, Color(0, 255, 0), "Issuing 5SC for killing a rogue unit.");
			else 
                attacker:notify("You have been awarded 5SC for killing a rogue unit.");
            end 
        end 
    end
end 
hook.Add("PlayerDeath", "[module] divisions: player death", awardKill)

local function awardNPCKill(npc, attacker, inflictor)
    if (divisions) and (attacker:IsValid()) and (attacker:IsPlayer()) and (attacker:getDivision() > 0) then 
        if (npc:GetClass():find("zombie")) or (npc:GetClass():find("headcrab")) or (npc:GetClass():find("antlion")) then 
        	divisions:addSC(attacker, 3);
           	if (combineMessages) then 
           		combineMessages:add( attacker, Color(0, 255, 0), "Issuing 3SC for killing a defunct unit.");
			else 
                attacker:notify("You have been awarded 3SC for killing a defunct unit.");
            end 
       end  
   end 
end 
hook.Add("OnNPCKilled", "[module] divisions: npc death", awardNPCKill);

local function fixName(ply, old, new)
	if not RPExtraTeams or not RPExtraTeams[old] or not RPExtraTeams[new] then return; end 
	
	if (RPExtraTeams[new].nameTemplate) and not (RPExtraTeams[old].nameTemplate) then 
		ply.oldNick = ply:Name();
	end 
	
	if not (RPExtraTeams[new].nameTemplate) and (ply.oldNick) then 
		DarkRP.storeRPName(ply, ply.oldNick);
		ply:setDarkRPVar("rpname", ply.oldNick);
		ply.oldNick = nil;
	end 
end 

hook.Add("PlayerChangedTeam", "fix names pls", fixName);