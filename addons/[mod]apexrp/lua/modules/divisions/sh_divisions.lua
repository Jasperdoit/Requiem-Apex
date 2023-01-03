---------------------------------------------------------------------------
	-- Global table
---------------------------------------------------------------------------
	
divisions = divisions or {
	Data = {},
	Vendor = {},
	Tags = {},
	city = "C08",
	xp = 5,
	sc = 1,
	timer = 300,
	rate = 150,
};

---------------------------------------------------------------------------
	-- Functions.
---------------------------------------------------------------------------

function divisions:Add( data )
	local division = data;
	local id = table.insert( self.Data, division );
    
	hook.Run( "divisionAdded", division );

	return id;
end 

---------------------------------------------------------------------------
	-- Methods.
---------------------------------------------------------------------------

local meta = FindMetaTable( "Player" );

function meta:getDivision()
	return self:GetNWInt( "division", 0 );
end 

function meta:getDivisionData()
	if ( self:getDivision() == 0 ) then return 0; end 

	return divisions.Data[ self:getDivision() ];
end 

function meta:getDivisionRankData()
	if ( self:getDivision() == 0 ) then return 0; end 
	if ( self:getDivisionRank() == 0 ) then return 0; end 
	
	return divisions.Data[ self:getDivision() ].ranks[ self:getDivisionRank() ];
end 

function meta:getDivisionXP()
	if ( self:getDivision() == 0 ) then return 0; end 

	local divData = self:getDivisionData();

	return self:GetNWInt( divData.name .. ":xp", 0 );
end 

function meta:getDivisionReqXP()
	if ( self:getDivision() == 0 ) then return 0; end 

	local divData = self:getDivisionData();

	return divData.required_xp or 0;
end 

function meta:getDivisionRank() 
	return self:GetNWInt( "divisionRank", 0 );
end 


function meta:getDivisionRankReqXP()
	if ( self:getDivision() == 0 ) then return 0; end 
	if ( self:getDivisionRank() == 0 ) then return 0; end

	local divData = self:getDivisionData();
		
	return divData.ranks[ self:getDivisionRank() ].rank_xp or 0;
end 

function meta:getSC()
	return self:GetNWInt( "sCredits", 0 );
end 

function meta:getDigits()
	return self:GetNWInt( "digits", 0 );
end 