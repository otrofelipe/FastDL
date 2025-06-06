local LerpNumber = {}
local color = Color(200,200,200)
local glow = Material("vgui/advanced_warfare/glow")

function Advanced.DrawName(x,y,w,h)
	if !Advanced.mode:GetBool() then return end
	local time = "%H"
	local mode = engine.ActiveGamemode()
	local map = game.GetMap():gsub("_", " ")
	if !Advanced.time:GetBool() then
		time = "%I"
	end
	if Advanced.map:GetBool() then
		mode = map
	end
	Advanced.DrawBackground(x-w*.5,y-h*1.26,w,draw.GetFontHeight("AdvancedNick"))
	draw.SimpleTextOutlined( os.date(time..":%M:%S",os.time()),"AdvancedNick",x,y-h*1.5,Color(150,150,150),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2, Color(0, 0, 0, 20))
	draw.SimpleTextOutlined( string.upper(mode),"AdvancedNick",x,y-h*.95,Color(150,150,150),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2, Color(0, 0, 0, 20))
end

function Advanced.DrawHealth(x,y,w,h)
	local ply = LocalPlayer()
	local fraction = FrameTime()*10
	local health = ply:Health()
	local maxhealth = ply:GetMaxHealth()

	if !Advanced.health:GetBool() then return end

	if health <= 30 then
		color = Advanced.LerpColor(fraction,color,Color(200,0,0))
	else
		color = Advanced.LerpColor(fraction,color,Color(200,200,200))
	end

	LerpNumber.Health = Lerp(fraction,LerpNumber.Health || 0,health)

	Advanced.DrawBackground(x-w*.5,y-h*.46,w,h)

	--draw.SimpleTextOutlined( string.format("%.0f",math.max(LerpNumber.Health,0)),"AdvancedHealth",x,y,color,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER,2, Color(0, 0, 0, 20))
	local length = math.min(LerpNumber.Health/maxhealth,1)*w
	--draw.SimpleTextOutlined( "HEALTH","AdvancedStatus",x,y,color,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER,2, Color(0, 0, 0, 20))
	surface.SetDrawColor(ColorAlpha(color,150))
	surface.SetMaterial(glow)
	surface.DrawTexturedRectRotated(x,y,120,80,0)
	draw.SimpleTextOutlined( string.format("%.0f",math.max(LerpNumber.Health,0)),"AdvancedHP",x,y,color,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2, Color(0, 0, 0, 20))
end

local low_effect = 0

hook.Add("RenderScreenspaceEffects", "LowHealthEffect", function()
	if !Advanced.low:GetBool() then return end
    local ply = LocalPlayer()    
	if ply:Health() <= 30 then
		low_effect = Lerp(FrameTime()*5,low_effect,1)
	else
		low_effect = Lerp(FrameTime()*5,low_effect,0)
	end
    DrawColorModify( {
		[ "$pp_colour_addr" ] = 0.15*low_effect,
		[ "$pp_colour_addg" ] = 0,
		[ "$pp_colour_addb" ] = 0,
        [ "$pp_colour_contrast" ] = 1,
        [ "$pp_colour_colour" ] = 1,
        [ "$pp_colour_brightness" ] = 0
    })
end)