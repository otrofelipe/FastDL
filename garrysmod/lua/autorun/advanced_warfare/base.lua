Advanced.IncludeFile("elements/health.lua")
Advanced.IncludeFile("elements/auxpower.lua")
Advanced.IncludeFile("elements/armor.lua")
Advanced.IncludeFile("elements/ammo.lua")
Advanced.IncludeFile("elements/history.lua")
Advanced.IncludeFile("elements/indicator.lua")
Advanced.IncludeFile("elements/menu.lua")

local hide = {
		["CHudHealth"] = true,
		["CHudBattery"] = true,
		["CHudAmmo"] = true,
		["CHudSecondaryAmmo"] = true,
		["CHudPoisonDamageIndicator"]  = true,
		["CHudDamageIndicator"]  = true,
		["CHudSuitPower"] = true,
}

Advanced.Blur = Material("vgui/advanced_warfare/blur")

hook.Add( "HUDShouldDraw", "advanced_warfareHideHUD", function( name )
	if ( hide[ name ] ) then
		return false
	end
end )

local lagger = Angle()

local function DrawHistory(sway_x,sway_y)
	if !Advanced.history:GetBool() then return end
	local x,y = ScreenScale(0.325*-ScrW()*.3)+Advanced.history_x:GetFloat(),ScreenScale(0.325*-ScrH()*.3)+Advanced.history_y:GetFloat()
	cam.Start3D(Vector(0,0,0), Angle(0,0,0),106,0, 0, ScrW(),ScrH(), 4,512)
		cam.Start3D2D(Vector(24,-24-sway_x*0.1,-15+sway_y*0.1),Angle(180,80-sway_x*0.2,265+sway_y*0.5),0.026*Advanced.scale:GetFloat())
			Advanced.History(x,y)
		cam.End3D2D()
	cam.End3D()
end

local function DrawIndicator(sway_x,sway_y)
	if !Advanced.indicator:GetBool() then return end
	local x,y = ScreenScale(0.325*ScrW()*.24)+Advanced.indicator_x:GetFloat(),ScreenScale(0.325*-ScrH()*.2)+Advanced.indicator_y:GetFloat()
	cam.Start3D(Vector(0,0,0), Angle(0,0,0),106,0, 0, ScrW(),ScrH(), 4,512)
		cam.Start3D2D(Vector(24,28-sway_x*0.1,-12+sway_y*0.1),Angle(0,-80-sway_x*0.2,-275+sway_y*0.5),0.024*Advanced.scale:GetFloat())
			Advanced.Indicator(x,y)
		cam.End3D2D()
	cam.End3D()
	if Advanced.grenade:GetBool() then
		Advanced.GrenadeIndicator()
	end
end

local function DrawStatus(sway_x,sway_y)
	local x,y = 40,80
	--local w,h = 355,28
	local w,h = draw.GetFontHeight("AdvancedHP")*2,draw.GetFontHeight("AdvancedHP")
	cam.Start3D(Vector(0,0,0), Angle(0,0,0),106,0, 0, ScrW(),ScrH(), 4,512)
		cam.Start3D2D(Vector(24,28-sway_x*0.1,-12+sway_y*0.1),Angle(0,-80-sway_x*0.2,-275+sway_y*0.5),0.026*Advanced.scale:GetFloat())
			Advanced.DrawName(ScreenScale(0.325*(x+w*.525))+Advanced.mode_x:GetFloat(),ScreenScale(0.325*(y+h*.15))+Advanced.mode_y:GetFloat(),w*2.05,h)
			Advanced.DrawHealth(ScreenScale(0.325*x)+Advanced.health_x:GetFloat(),ScreenScale(0.325*y)+Advanced.health_y:GetFloat(),w,h)
			Advanced.DrawArmor(ScreenScale(0.325*(x+w))+Advanced.armor_x:GetFloat(),ScreenScale(0.325*y)+Advanced.armor_y:GetFloat(),w,h)
			Advanced.DrawAux(ScreenScale(0.325*(x+w*.26))+Advanced.aux_x:GetFloat(),ScreenScale(0.325*(y+h*.65))+Advanced.aux_y:GetFloat(),w*1.5,6)
		cam.End3D2D()
	cam.End3D()
end

local function DrawWeaponStatus(sway_x,sway_y)
	if !Advanced.ammo:GetBool() then return end
	local x,y = ScreenScale(0.325*-80)+Advanced.ammo_x:GetFloat(),ScreenScale(0.325*-50)+Advanced.ammo_y:GetFloat()
	local w,h = draw.GetFontHeight("AdvancedClip")*3,(draw.GetFontHeight("AdvancedClip")+draw.GetFontHeight("AdvancedAmmo"))*.85
	local mw_stims_installed = GetConVar("mw_stims_hud") ~= nil
	local nanoshot_installed = GetConVar("iw_nanoshots_maxshotscarry") ~= nil

	if mw_stims_installed && nanoshot_installed then
		x = ScreenScale(0.325*-235)+Advanced.ammo_x:GetFloat()
	else
		x = ScreenScale(0.325*-130)+Advanced.ammo_x:GetFloat()
	end

	cam.Start3D(Vector(0,0,0), Angle(0,0,0),106,0, 0, ScrW(),ScrH(), 4,512)
		cam.Start3D2D(Vector(24,-24-sway_x*0.1,-15+sway_y*0.1),Angle(180,80-sway_x*0.2,265+sway_y*0.5),0.026*Advanced.scale:GetFloat())
			Advanced.DrawAmmo(x,y,w,h)
		cam.End3D2D()
	cam.End3D()
end

local function HUDPaint()
	if !Advanced.hud:GetBool() then return end
	local eyeAng = LocalPlayer():EyeAngles()
	lagger = LerpAngle(FrameTime()*10,lagger,eyeAng)
	local sway_x = math.AngleDifference(eyeAng.y,lagger.y)
	local sway_y = math.AngleDifference(eyeAng.p,lagger.p)

	if !Advanced.sway:GetBool() then 
		sway_x,sway_y = 0,0
	end

	surface.DisableClipping(true)
	DrawStatus(sway_x,sway_y)
	DrawWeaponStatus(sway_x,sway_y)
	DrawHistory(sway_x,sway_y)
	DrawIndicator(sway_x,sway_y)
end

hook.Add("HUDPaint","advanced_warfareHUD",HUDPaint)

if SERVER then
	local function Alarm(victim,dmginfo)
		if victim:IsPlayer() then
			victim:EmitSound("hit/hit" .. math.random(1, 6) .. ".wav")
		end
	end
	hook.Add( "EntityTakeDamage", "AdvancedAlarmSound", Alarm)
end

local function CreateFont()
	if SERVER then return end
	surface.CreateFont("AdvancedNick", {
		font = "Kapra Neue Pro",
		extended = false,
		size = 35, 
		weight = 500,
		antialias = true,
	})

	surface.CreateFont("AdvancedPick", {
		font = "Kapra Neue Pro",
		extended = false,
		size = 35, 
		weight = 500,
		antialias = true,
	})

	surface.CreateFont("AdvancedHP", {
		font = "Kapra Neue Pro",
		extended = false,
		size = 60, 
		weight = 500,
		antialias = true,
	})

	surface.CreateFont("AdvancedStatus", {
		font = "Kapra Neue Pro",
		extended = false,
		size = 40, 
		weight = 500,
		antialias = true,
	})

	surface.CreateFont("AdvancedAux", {
		font = "Kapra Neue Pro",
		extended = false,
		size = 20, 
		weight = 500,
		antialias = true,
	})

	surface.CreateFont("AdvancedClip", {
		font = "Kapra Neue Pro",
		extended = false,
		size = 75, 
		weight = 500,
		antialias = true,
	})

	surface.CreateFont("AdvancedAmmo", {
		font = "Kapra Neue Pro",
		extended = false,
		size = 35, 
		weight = 500,
		antialias = true,
	})

	surface.CreateFont("AdvancedAmmo2", {
		font = "Kapra Neue Pro",
		extended = false,
		size = 40, 
		weight = 500,
		antialias = true,
	})
end

CreateFont()