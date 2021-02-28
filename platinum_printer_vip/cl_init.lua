include("shared.lua")

function ENT:Initialize()
end

function ENT:Draw()
	self:DrawModel()

	local Pos = self:GetPos()
	local Ang = self:GetAngles()

	local owner = self:Getowning_ent()
	owner = (IsValid(owner) and owner:Nick()) or DarkRP.getPhrase("unknown")

	local money = "$"..self:GetmoneyAmount() or 0
	
	surface.SetFont("HUDNumber5")
	local text = "Level ".. self:GetLevel().. "/4"
	local TextWidth = surface.GetTextSize(text)
	local TextWidth2 = surface.GetTextSize(owner)
	local text1 = "INK"
	local txt = "VIP"
	Ang:RotateAroundAxis(Ang:Up(), 90)

	cam.Start3D2D(Pos + Ang:Up() * 10.6, Ang, 0.11)
		--draw.WordBox(2, -TextWidth*0.5, -30, text, "HUDNumber5", Color(140, 0, 0, 100), Color(255,255,255,255))
		--draw.WordBox(2, -TextWidth2*0.5, 18, owner, "HUDNumber5", Color(140, 0, 0, 100), Color(255,255,255,255))
		--draw.WordBox(2, -TextWidth2*0.5, 68, money, "HUDNumber5", Color(140, 0, 0, 100), Color(255,255,255,255))
		cam.Start3D2D(Pos + Ang:Up() * 10.6, Ang, 0.11)
            draw.RoundedBox(0, -135, -139, 273, 233, Color(0,0,0,255))
			draw.RoundedBox(0, -135, -139, 273, 233, Color(0,0,0,255))

			local ink = math.Clamp(self:GetinkAmount(),0,100)
			draw.RoundedBox(0, -125, -89, 255, 33, Color(72,72,72,255))
			draw.RoundedBox(0, -125, -89, (255)*(ink/100), 33, Color(0,255,255,255)) --ink light blue

			draw.RoundedBox(0, -130, -130, 260, 31, Color(72,72,72,255))
			draw.SimpleText(""..owner, "HUDNumber5", 0, -115, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.RoundedBox(0, -130, -44, 260, 33, Color(72,72,72,255)) -- box under money$
            draw.RoundedBox(0, -130, -0, 260, 33, Color(72,72,72,255)) -- under user

			draw.SimpleText("Money: "..money, "HUDNumber5", 0, -30, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.RoundedBox(0, -130, 45, 260, 33, Color(144,144,144,255)) -- under printer txt

            draw.SimpleText(text, "HUDNumber5", 0, 60, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(text1, "HUDNumber5", 0, -70, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			
			draw.SimpleText(txt, "HUDNumber5", 0, 16, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.RoundedBox(0, -133, -139, 11, 233, Color(0,0,0,255))
			draw.RoundedBox(0, 125, -139, 13, 233, Color(0,0,0,255))
        cam.End3D2D()
		
	cam.End3D2D()
end

function ENT:Think()
end
