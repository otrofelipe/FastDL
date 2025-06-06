local LerpNumber = {}
local color = Color(200,200,200)

function Advanced.DrawAux(x,y,w,h)
	if !Advanced.aux:GetBool() then return end
	local ply = LocalPlayer()
	local fraction = FrameTime()*10
	local auxpower = ply:GetSuitPower()
	local AuxInstalled = GetConVar("cl_auxpow_drawhud") ~= nil

	if AuxInstalled then
		GetConVar("cl_auxpow_drawhud"):SetBool(false)
		LerpNumber.aux = Lerp(fraction,LerpNumber.aux || 0,AUXPOW:GetPower()*100)
	else
		LerpNumber.aux = Lerp(fraction,LerpNumber.aux || 0,auxpower)
	end

	if LerpNumber.aux <= 30 then
		color = Advanced.LerpColor(fraction,color,Color(200,0,0))
	else
		color = Advanced.LerpColor(fraction,color,Color(200,200,200))
	end

	surface.SetDrawColor(0,0,0,150)
	surface.DrawRect(x-w*.15,y,w,h)

	surface.SetDrawColor(color)
	surface.DrawRect(x-w*.15,y,math.max(w*LerpNumber.aux*.01,0),h)

	draw.SimpleTextOutlined( "AUX POWER","AdvancedAux",x-w*.5,y+3,color,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,2, Color(0, 0, 0, 20))
end