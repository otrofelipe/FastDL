local LerpNumber = {}
local color = Color(200,200,200)
local ammo_color = Color(100,100,100)
local text_color = Color(150,150,150)
local grenade_color = Color(150,150,150)
local stims_color,nanoshots_color = Color(150,150,150),Color(150,150,150)
local icon = {
	glow = Material("vgui/advanced_warfare/glow"),
	nanoshot = Material("vgui/advanced_warfare/nanoshot"),
	frag = Material("vgui/advanced_warfare/frag"),
	ball = Material("vgui/advanced_warfare/AR2AltFire"),
	smg = Material("vgui/advanced_warfare/SMG1_Grenade")
}

local ammo2_icon = "AR2AltFire" or "SMG1_Grenade"
function Advanced.DrawAmmo(x,y,w,h)
	local ply = LocalPlayer()
	local fraction = FrameTime()*10
	local wep = ply:GetActiveWeapon()
	if not IsValid(wep) then return end
	local clip = wep:Clip1()
	local maxclip = wep:GetMaxClip1()
	local ammo = wep:GetPrimaryAmmoType()
	local ammo2 = wep:GetSecondaryAmmoType()
	local ammocount = ply:GetAmmoCount(ammo)
	local ammocount2 = ply:GetAmmoCount(ammo2)
	local SMG1_Grenades = ply:GetAmmoCount(9)
	local grenade = ply:GetAmmoCount(10)
	local wep_name = string.upper(language.GetPhrase(wep:GetPrintName()))
	local mw_stims_installed = GetConVar("mw_stims_hud") ~= nil
	local nanoshot_installed = GetConVar("iw_nanoshots_maxshotscarry") ~= nil
	local vmanip_m79_installed = GetConVar("vmanip_m79_hud") ~= nil

	if vmanip_m79_installed then
		GetConVar("vmanip_m79_hud"):SetBool(false)

		if (SMG1_Grenades > 0 && ammo2 ~= 9) then
			LerpNumber.SMGnades_alpha = Lerp(fraction,LerpNumber.SMGnades_alpha || 0,1)
		else
			LerpNumber.SMGnades_alpha = Lerp(fraction,LerpNumber.SMGnades_alpha || 0,0)
		end
	end

	if ammocount2 > 0 then
		if ammo2 ~= 9 then
			LerpNumber.SMGnades_y = Lerp(fraction,LerpNumber.SMGnades_y || 0,35)
		else
			LerpNumber.SMGnades_y = Lerp(fraction,LerpNumber.SMGnades_y || 0,0)
		end

		LerpNumber.ammo2_alpha = Lerp(fraction,LerpNumber.ammo2_alpha || 0,1)
	else
		LerpNumber.SMGnades_y = Lerp(fraction,LerpNumber.SMGnades_y || 0,0)
		LerpNumber.ammo2_alpha = Lerp(fraction,LerpNumber.ammo2_alpha || 0,0)
	end

	if ammo2 == 2 then
		ammo2_icon = icon.ball
	else
		ammo2_icon = icon.smg
	end

	if grenade <= 0 then
		grenade_color = Advanced.LerpColor(fraction,grenade_color,Color(100,100,100))
	else
		grenade_color = Advanced.LerpColor(fraction,grenade_color,Color(150,150,150))
	end

	if maxclip <= 0 then
		if ammo == -1 then
			clip = 1
			maxclip = clip
		else
			maxclip = 1
			clip = ammocount
			ammocount = 0
		end
	end

	if clip <= maxclip/4 then
		color = Advanced.LerpColor(fraction,color,Color(200,0,0))
	else
		color = Advanced.LerpColor(fraction,color,Color(200,200,200))
	end

	if ammocount <= maxclip && ammo ~= -1 then
		ammo_color = Advanced.LerpColor(fraction,ammo_color,Color(200,0,0))
	else
		ammo_color = Advanced.LerpColor(fraction,ammo_color,Color(100,100,100))
	end

	LerpNumber.clip = Lerp(fraction,LerpNumber.clip || 0,clip)
	LerpNumber.ammocount = Lerp(fraction,LerpNumber.ammocount || 0,ammocount)
	LerpNumber.ammocount2 = Lerp(fraction,LerpNumber.ammocount2 || 0,ammocount2)
	LerpNumber.SMGnades_count = Lerp(fraction,LerpNumber.SMGnades_count || 0,SMG1_Grenades)

	Advanced.DrawBackground(x-w*.47,y-h*.35,w,h)
	Advanced.DrawBackground(x+w*.54,y-h*.35,h,h)

	if nanoshot_installed then
		GetConVar("iw_nanoshots_hud"):SetBool(false)
		local nanoshots = ply:GetNanoShots()
		local position = .97

		if mw_stims_installed then
			position = 1.4
		end

		if nanoshots <= 0 then
			nanoshots_color = Advanced.LerpColor(fraction,nanoshots_color,Color(100,100,100))
		else
			nanoshots_color = Advanced.LerpColor(fraction,nanoshots_color,Color(150,150,150))
		end

		Advanced.DrawBackground(x+w*position,y-h*.35,h,h)

		surface.SetDrawColor(200,200,200)
		surface.SetMaterial(icon.nanoshot)
		surface.DrawTexturedRectRotated(x+w*position+h*.5,y,h*.5,h*.5,0)
		draw.SimpleTextOutlined( "x"..nanoshots,"AdvancedAmmo",x+w*position+h*.5,y+draw.GetFontHeight("AdvancedAmmo")*1.1,nanoshots_color,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2, Color(0, 0, 0, 20))
	end

	if mw_stims_installed then
		GetConVar("mw_stims_hud"):SetBool(false)
		local stims = ply:GetStims()
		if stims <= 0 then
			stims_color = Advanced.LerpColor(fraction,stims_color,Color(100,100,100))
		else
			stims_color = Advanced.LerpColor(fraction,stims_color,Color(150,150,150))
		end

		Advanced.DrawBackground(x+w*.97,y-h*.35,h,h)

		surface.SetDrawColor(200,200,200)
		surface.SetMaterial(Material("entities/mw_equipment_stim.png"))
		surface.DrawTexturedRectRotated(x+w*.97+h*.5,y,h*.5,h*.5,0)
		draw.SimpleTextOutlined( "x"..stims,"AdvancedAmmo",x+w*.97+h*.5,y+draw.GetFontHeight("AdvancedAmmo")*1.1,stims_color,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2, Color(0, 0, 0, 20))
	end

	surface.SetDrawColor(200,200,200)
	surface.SetMaterial(icon.frag)
	surface.DrawTexturedRectRotated(x+w*.45+h*.7,y,h*.5,h*.5,0)
	draw.SimpleTextOutlined( "x"..grenade,"AdvancedAmmo",x+w*.45+h*.68,y+draw.GetFontHeight("AdvancedAmmo")*1.1,grenade_color,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2, Color(0, 0, 0, 20))

	if Advanced.wep:GetBool() then
		draw.SimpleTextOutlined( wep_name,"AdvancedNick",x-w*.47,y-h*.35,text_color,TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM,2, Color(0, 0, 0, 20))
	end
	--draw.SimpleText( string.format("%.0f",LerpNumber.clip),"AdvancedClipB",x,y,ColorAlpha(color,150),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

	surface.SetDrawColor(ColorAlpha(color,150))
	surface.SetMaterial(icon.glow)
	surface.DrawTexturedRectRotated(x+w*.03,y,120,80,0)
	draw.SimpleTextOutlined( string.format("%.0f",LerpNumber.clip),"AdvancedClip",x+w*.03,y,color,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2, Color(0, 0, 0, 20))
	draw.SimpleTextOutlined( string.format("%.0f",LerpNumber.ammocount),"AdvancedAmmo",x+2+w*.03,y+draw.GetFontHeight("AdvancedAmmo")*1.1,ammo_color,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2, Color(0, 0, 0, 20))
	
	surface.SetDrawColor(200,200,200,255*LerpNumber.ammo2_alpha)
	surface.SetMaterial(ammo2_icon)
	surface.DrawTexturedRectRotated(x+w*.34,y-h*.1,35,35,0)	
	draw.SimpleTextOutlined( string.format("%.0f",LerpNumber.ammocount2),"AdvancedAmmo2",x+2+w*.4,y-h*.1,Color(150,150,150,255*LerpNumber.ammo2_alpha),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,2, Color(0, 0, 0, 20*LerpNumber.ammo2_alpha))
	
	if vmanip_m79_installed then
		surface.SetDrawColor(200,200,200,255*LerpNumber.SMGnades_alpha)
		surface.SetMaterial(icon.smg)
		surface.DrawTexturedRectRotated(x+w*.34,y-h*.1+LerpNumber.SMGnades_y,35,35,0)	
		draw.SimpleTextOutlined( string.format("%.0f",LerpNumber.SMGnades_count),"AdvancedAmmo2",x+2+w*.4,y-h*.1+LerpNumber.SMGnades_y,Color(150,150,150,255*LerpNumber.SMGnades_alpha),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,2, Color(0, 0, 0, 20*LerpNumber.SMGnades_alpha))
	end
end
