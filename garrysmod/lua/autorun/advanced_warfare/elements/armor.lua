local LerpNumber = {}
local color = Color(200,200,200)
local rect_color = Color(150,180,200)
local ap_icon = Material("vgui/advanced_warfare/ap.png")

function Advanced.DrawArmor(x,y,w,h)
	local ply = LocalPlayer()
	local fraction = FrameTime()*10
	local armor = ply:Armor()
	local maxarmor = ply:GetMaxArmor()

	if !Advanced.armor:GetBool() then return end

	if armor <= 0 then
		color = Advanced.LerpColor(fraction,color,Color(100,100,100))
	else
		color = Advanced.LerpColor(fraction,color,Color(150,150,150))
	end

	LerpNumber.Armor = Lerp(fraction,LerpNumber.Armor || 0,armor)

	Advanced.DrawBackground(x-w*.45,y-h*.46,w,h)

	surface.SetMaterial(ap_icon)
    surface.SetDrawColor(color)
	surface.DrawTexturedRectRotated(x-w*.2,y,35,35,0)

	draw.SimpleTextOutlined( string.format("%.0f",math.max(LerpNumber.Armor,0)),"AdvancedHP",x+w*.2,y,color,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2, Color(0, 0, 0, 20))
end
