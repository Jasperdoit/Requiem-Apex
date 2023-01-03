AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
include('shared.lua')


function ENT:Initialize()

	self:SetModel( "models/props/de_inferno/wine_barrel.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType(SOLID_VPHYSICS)   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self:SetUseType( SIMPLE_USE )
	self:SetTrigger(true)
	--self:SetMaterial( "sprops/trans/misc/ls_m1" )
        local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	self.damage = 100;
	self.IsBrewing = false;
	self.Percent = 0;
	self.hasYeast = false;
	self.hasWater = false;
	self.AlcoholA = 0
	self.IsGinning = false

end

function ENT:GetAlcohol()
   return self.AlcoholA or 0
end

function ENT:Use(ply)
    local destroyValue = 380
    if ply:Team() == TEAM_OVERWATCH then
        self:Remove()
        return
    end
end

function ENT:Use(ply)
    local destroyValue = 380
    if ply:Team() == TEAM_CP then
        self:Remove()
        return
    end

	if self.IsBrewing then
	    if self.IsGinning then
		    ply:notify("Gin brewing is at "..self.Percent.."%")
		else
		    ply:notify("Alcohol brewing is currently at "..self.Percent.."%")
		end
		return
	end

	if not (self.hasYeast or self.hasWater) then
		ply:notify("First, you have to add yeast..")
		return
	end
	if not self.hasYeast then
		ply:notify("Now that you added special water, you have to add yeast to start brewing.")
		return
	end
    if self:GetAlcohol() >= 1 then
        if self:GetAlcohol() <= 2 then
		    ply:notify("Now that you have added alcohol to the mixture, you need " .. 3 - self.AlcoholA .." more bottles of alcohol to brew gin.")
		    return
		else
			ply:notify("Now you have to add some special water start making gin.")
			return
		end
	elseif not self.hasWater then
		ply:notify("Now you have to add some special water or alcohol start brewing.")
		return
	end
end

function ENT:OnTakeDamage(dmg)
	if self.burningup then return end

	self.damage = (self.damage or 100) - dmg:GetDamage()
	if self.damage <= 0 then
--		local rnd = math.random(1, 10)
			self:BurstIntoFlames()
	end
end

function ENT:Destruct()
	local vPoint = self:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart(vPoint)
	effectdata:SetOrigin(vPoint)
	effectdata:SetScale(1)
	util.Effect("Explosion", effectdata)
end

function ENT:BurstIntoFlames()
	self.burningup = true
	local burntime = math.random(8, 18)
	self:Ignite(burntime, 0)
	timer.Simple(burntime, function() self:Fireball() end)
end

function ENT:Fireball()
	if not self:IsOnFire() then self.burningup = false return end
	local dist = math.random(5, 50) -- Explosion radius
	if self.IsBrewing then
	self:Destruct()
	for k, v in pairs(ents.FindInSphere(self:GetPos(), dist)) do
		if not v:IsPlayer() and not v:IsWeapon() and v:GetClass() ~= "predicted_viewmodel" and not v.IsMoneyPrinter then
			v:Ignite(math.random(5, 22), 0)
		elseif v:IsPlayer() then
			local distance = v:GetPos():Distance(self:GetPos())
			v:TakeDamage(distance / dist * 100, self, self)
		end
	end
	end
	self:Remove()
end

function ENT:Touch( hitEnt )
    if self.IsBrewing == true then return end
    if self:GetAlcohol() <= 2 then
        if self.hasYeast then
        	if IsValid(hitEnt) and hitEnt:GetClass() == "hl2rp_alcohol" then
        	    if hitEnt.atouched or hitEnt.brewed then return end

        	    hitEnt.atouched = true
    			self.AlcoholA = self.AlcoholA + 1
    			SafeRemoveEntity(hitEnt);
    			self:CheckBrewing();
    			return

            end
        end
    end


	if not self.hasYeast then
		if IsValid(hitEnt) and hitEnt:GetClass() == "hl2rp_yeast" then
			self.hasYeast = true;
			SafeRemoveEntity(hitEnt);
			self:CheckBrewing();
			return

		end

	end
	if not self.hasWater then
		if IsValid(hitEnt) and hitEnt:GetClass() == "spawned_food" and hitEnt.brewing then
			self.hasWater = true;
			SafeRemoveEntity(hitEnt);
			self:CheckBrewing();
		end
	end

end

function ENT:CheckBrewing()
	if self.hasYeast and self.hasWater then
	    if self:GetAlcohol() >= 1 then
	        if self:GetAlcohol() >= 3 then
	            self.IsGinning = true
			    self.IsBrewing = true;
				self.AlcoholA =0
			end
	    else
			 self.IsBrewing = true;
			self.AlcoholA =0
	    end
	end
end

function ENT:Think()
	if self.Percent >= 100 and self.IsBrewing then
			self.IsBrewing = false;
			self.Percent = 0;
			self.hasYeast = false;
			self.hasWater = false;
            if self.IsGinning then
                self.IsGinning = false
				local SpawnedFood = ents.Create("hl2rp_gin")
				SpawnedFood:SetPos(self:GetPos()+Vector(0,0,60))
				SpawnedFood:Spawn();
				self.AlcoholA =0
            else
				local SpawnedFood = ents.Create("hl2rp_alcohol")
				SpawnedFood:SetPos(self:GetPos()+Vector(0,0,60))
				SpawnedFood.brewed = true
				timer.Simple(5, function() if IsValid(SpawnedFood) then SpawnedFood.brewed = false end end)
				SpawnedFood:Spawn();
			end

	end
	if self.IsBrewing and self.Percent != 100 then
	    if self.IsGinning then
	        self.Percent = self.Percent + 0.25
	    else
		    self.Percent = self.Percent+0.5;
	    end
		--print(self.Percent)
	end
	self:NextThink( CurTime() + 1.3 )
	return true -- Note: You need to return true to override the default next think time
end
