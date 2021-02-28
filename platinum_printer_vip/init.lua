
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.SeizeReward = 950

local MoneyPrint = 5
local MoneyPrintTime = 1.5 -- Time it takes to print
local InkTake = .5 -- Amount to take when the printer prints

local InkPrice = 0 -- Price of the ink
local InkGive = 30 -- Amount of ink to give when they are holding E

local PrintMore

local Upgrades = {
	5,
	7,
	8,
	9
}

function ENT:Initialize()
	self:SetModel("models/props_c17/consolebox01a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	phys:Wake()

	self.sparking = false
	self.damage = 100
	self.IsMoneyPrinter = true
	self:SetinkAmount(100)
	self.holduse = false
	self:SetUseType(ONOFF_USE)
	timer.Simple(1, function() PrintMore(self) end)

end

function ENT:OnTakeDamage(dmg)
	if self.burningup then return end

	self.damage = (self.damage or 100) - dmg:GetDamage()
	if self.damage <= 0 then
		local rnd = math.random(1, 10)
		if rnd < 3 then
			self:BurstIntoFlames()
		else
			self:Destruct()
			self:Remove()
		end
	end
end

function ENT:Destruct()
	local vPoint = self:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart(vPoint)
	effectdata:SetOrigin(vPoint)
	effectdata:SetScale(1)
	util.Effect("Explosion", effectdata)
	DarkRP.notify(self:Getowning_ent(), 1, 4, DarkRP.getPhrase("money_printer_exploded"))
end
--[[
function ENT:BurstIntoFlames()
	DarkRP.notify(self:Getowning_ent(), 0, 4, DarkRP.getPhrase("money_printer_overheating"))
	self.burningup = true
	local burntime = math.random(8, 18)
	self:Ignite(burntime, 0)
	timer.Simple(burntime, function() self:Fireball() end)
end
]]
function ENT:Fireball()
	if not self:IsOnFire() then self.burningup = false return end
	local dist = math.random(20, 280) -- Explosion radius
	self:Destruct()
	for k, v in pairs(ents.FindInSphere(self:GetPos(), dist)) do
		if not v:IsPlayer() and not v:IsWeapon() and v:GetClass() ~= "predicted_viewmodel" and not v.IsMoneyPrinter then
			v:Ignite(math.random(5, 22), 0)
		elseif v:IsPlayer() then
			local distance = v:GetPos():Distance(self:GetPos())
			v:TakeDamage(distance / dist * 100, self, self)
		end
	end
	self:Remove()
end

PrintMore = function(ent)
	if not IsValid(ent) then return end

	ent.sparking = false
	timer.Simple(MoneyPrintTime, function()
		if not IsValid(ent) then return end
		ent:CreateMoneybag()
	end)
end

function ENT:CreateMoneybag()
	if self.IsPocketed then -- Check if the printer is inside the Printers Bag and return it false ( Make the printer stop working )
		return
	end
	if not IsValid(self) or self:IsOnFire() then return end

	local MoneyPos = self:GetPos()

	--DarkRP.createMoneyBag(Vector(MoneyPos.x + 15, MoneyPos.y, MoneyPos.z + 15), MoneyPrint)
	if self:GetinkAmount() > 0 then
		self:SetmoneyAmount(self:GetmoneyAmount()+Upgrades[self:GetLevel() or 1])
		self:SetinkAmount(math.Clamp(self:GetinkAmount()-InkTake,0,100))
		self.sparking = false
	end
	timer.Simple(.001, function() PrintMore(self) end)
end

function ENT:Think()
	if self.holduse then
		if CurTime() > self.holduse then
			self.holduse = CurTime()+1
			self.upgrade = true
			timer.Simple(-1,function()
				if IsValid(self) and IsValid(self.holduser) and self.holduse then
					if self:GetinkAmount() < 100 then
						if self.holduser:canAfford(InkPrice) then
							self:SetinkAmount(math.Clamp(self:GetinkAmount()+InkGive,0,100))
							self.holduser:addMoney(-InkPrice)

						else
							DarkRP.notify(self.holduser, 1, 4, "You cannot afford this!")
						end
					end
				end
			end)
		end
	end

	if self:WaterLevel() > 0 then
		self:Destruct()
		self:Remove()
		return
	end

	if not self.sparking then return end

	local effectdata = EffectData()
	effectdata:SetOrigin(self:GetPos())
	effectdata:SetMagnitude(1)
	effectdata:SetScale(1)
	effectdata:SetRadius(2)
	util.Effect("Sparks", effectdata)
end

function ENT:Use(act,call,uset,val)
	if uset == 1 then
		self.holduse = CurTime() + 1
		self.holduser = call
	else
		if IsValid(call) and !self.upgrade and self:GetmoneyAmount() > 0 then
			call:addMoney(self:GetmoneyAmount())
			DarkRP.notify(call, 0, 4, "You took $"..self:GetmoneyAmount())
			self:SetmoneyAmount(0)
		end
		self.upgrade = false
		self.holduse = false
		self.holduser = nil
	end
end
