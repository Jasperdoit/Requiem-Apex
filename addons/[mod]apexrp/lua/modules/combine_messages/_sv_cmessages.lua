return

---------------------------------------------------------------------------
	-- Global table.
---------------------------------------------------------------------------

combineMessages = combineMessages or {};

---------------------------------------------------------------------------
	-- Caching net messages.
---------------------------------------------------------------------------

util.AddNetworkString( "combineMessagesCreate" );
util.AddNetworkString( "combineMessagesAdd" );

---------------------------------------------------------------------------
	-- Functions.
---------------------------------------------------------------------------

function combineMessages:create( ply )
    if not ( IsValid( ply ) ) or not ( ply:isCombine() ) then 
        return; 
    end 

    net.Start( "combineMessagesCreate" );
    net.Send( ply );
end 

function combineMessages:add( ply, col, msg )
    if not ( IsValid( ply ) ) or not ( ply:isCombine() ) then 
        return;
    end 

    if not ( col ) or not ( msg ) then 
        return;
    end 

    local text = msg;
    local color = col;

    net.Start( "combineMessagesAdd" );
        net.WriteString( text );
        net.WriteColor( color ); 
    net.Send( ply ); 
end  

function combineMessages:addFiltered( filter, col, msg )
    if not ( col ) or not ( msg ) or not ( filter ) then 
        return;
    end 

    local text = msg;
    local color = col;

    net.Start( "combineMessagesAdd" );
         net.WriteString( text );
         net.WriteColor( color ); 
    net.Send( filter );  
end 

---------------------------------------------------------------------------
	-- Hooks.
---------------------------------------------------------------------------

hook.Add( "PlayerSpawn", "[module] combine messages: player spawn", function( ply ) 
    timer.Simple( .5, function() 
        if not ( IsValid( ply ) ) then return; end 
        
        if ( ply:isCombine() ) then 
            ply.dmgMsgTimer = 0;

            combineMessages:create( ply );  
        end 
    end );
end );
--[[
hook.Add( "PlayerHurt", "[module] combine messages: player hurt", function( ply, attacker, hpRemaining, dmgTaken )
    if not ( ply:isCombine() ) then return; end 

    if ( hpRemaining > 0 ) and ( ply.dmgMsgTimer < CurTime() ) then 
        if ( dmgTaken < 40 ) then 
            combineMessages:add( ply, Color( 255, 255, 0 ), "Local unit sustaining mild physical trauma!" );
        elseif ( dmgTaken >= 40 ) then 
            combineMessages:add( ply, Color( 255, 0, 0 ), "Local unit sustaining heavy physical trauma!" );

            if ( ply:Team() == TEAM_OTA ) then 
                timer.Simple( 2, function()
                    if not ( IsValid( ply ) ) then return; end 

                    combineMessages:add( ply, Color( 255, 0, 0 ), "Injecting stim-dose!" );

                    timer.Simple( 2, function()
                        if not ( IsValid( ply ) ) then return; end 

                        combineMessages:add( ply, Color( 0, 255, 0 ), "Injection successful, vitals stable." );
                    end );
                end );
            end 

            local filter = {};

            for _, target in ipairs( player.GetAll() ) do 
                if not ( target:isCombine() ) or ( target == ply ) then continue; end 

                table.insert( filter, target );
            end 

            combineMessages:addFiltered( filter, Color( 255, 0, 0 ), "Unit sustaining heavy physical trauma! Protection Teams, Code 3!" );
        end 

        ply.dmgMsgTimer = CurTime() + 10;
    elseif ( hpRemaining <= 0 ) then 
        local filter = {};

        for _, target in ipairs( player.GetAll() ) do 
            if not ( target:isCombine() ) then continue; end 
            
            target:EmitSound( "npc/overwatch/radiovoice/lostbiosignalforunit.wav" );
            
            if ( target == ply ) then continue; end 

            table.insert( filter, target );
        end 

        combineMessages:addFiltered( filter, Color( 255, 0, 0 ), "LOST BIOSIGNAL FOR PROTECTION TEAM UNIT " .. ply:Name():upper() );
    end 
end );
]]