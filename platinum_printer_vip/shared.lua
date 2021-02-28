ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Money Printer"
ENT.Author = "RE RE"
ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "moneyAmount")
	self:NetworkVar("Int", 1, "inkAmount")
	self:NetworkVar("Int", 2, "Level")
	self:NetworkVar("Entity", 0, "owning_ent")

	self:SetLevel(1)
end
