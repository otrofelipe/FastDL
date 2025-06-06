if SERVER then
	util.AddNetworkString("Advanced_Damaged")
end
local blur = Material("vgui/advanced_warfare/blur")
local key,key0 = 0,0
local warning = {}
local exist = {}
local existbuff = {}
local buff = {}

--[[local function AddBuff(icon,color)
	if key0 > 4 then
        key0 = key0 - 1
        table.remove(buff, key0-3)
    end

    if !table.HasValue(existbuff,icon) then
    	key0 = key0 + 1
    	buff[key0] = buff[key0] or {}
    	buff[key0].rectalpha = 1
    	buff[key0].alpha = 0
    	buff[key0].life = CurTime()+3+(key0-1)*0.5
    	buff[key0].height = 0
    	buff[key0].x = 50*key0
    	buff[key0].color = color
    	buff[key0].icon = icon
    	existbuff[key0] = icon
    else
    	if buff[table.KeyFromValue(existbuff,icon)].life > CurTime() then
    		buff[table.KeyFromValue(existbuff,icon)].life = CurTime()+1+(table.KeyFromValue(existbuff,icon)-1)*0.5
    	end
    end
end]]

local function AddWarning(name,color,icon)
    local textH = draw.GetFontHeight("AdvancedPick")*1.5
   
    if key > 3 then
        key = key - 1
        table.remove(warning, key-3)
    end

	if !table.HasValue(exist,name) then
	    key = key + 1
	    warning[key] = warning[key] or {}
	    warning[key].name = name
	    exist[key] = name
	    warning[key].alpha = 0
	    warning[key].rectalpha = 1
	    warning[key].life = CurTime()+3+(key-1)*0.5
	    warning[key].length = 0
	    --warning[key].height = textH
	    warning[key].y = 50*key
	    warning[key].color = color 
	    warning[key].icon = icon
	else
		if warning[table.KeyFromValue(exist,name)].life > CurTime() then
			warning[table.KeyFromValue(exist,name)].life = CurTime()+1+(table.KeyFromValue(exist,name)-1)*0.5
		end
	end
end

local Warning = {
	hp = false,
	ap = false,
	clip = false,
	bt = false,
	rogue = false,
	manhunt = false,
}

net.Receive("Advanced_Damaged",function()
	local dmgtype = net.ReadFloat()
	if dmgtype == 131072 || dmgtype == 65536 then
		AddWarning("NEUROTOXIN  DETECTED",Color(150, 150, 20),"poison")
		timer.Create("injecting",2,1,function()
			AddWarning("INJECTING  ANTIDOTE",Color(200,200,200),"kit")
		end)
	elseif dmgtype == 1048576 then	
		AddWarning("STRONGLY  CORROSION  DETECTED",Color(150, 150, 20),"acid")
	elseif dmgtype == 262144 then
		AddWarning("HIGH  LEVEL  RADIATION  EXPOSURE",Color(150, 150, 20),"radiation")
	elseif dmgtype == 64 then	
		AddWarning("BLAST  IMPACT  DETECTED",Color(255, 170, 64),"blast")
	elseif dmgtype == 8 then	
		AddWarning("EXTREME  HEAT  DETECTED",Color(255, 64, 64),"burn")
	elseif dmgtype == 32 then
		AddWarning("MAJOR FRACTURE DETECTED",Color(255,50,50),"fall")
	elseif dmgtype == 256 then	
		AddWarning("ELECTRICAL DAMAGE DETECTED",Color(255,200,0),"shock")
	elseif dmgtype == 16384 then	
		AddWarning("LOW OXYGEN LEVEL",Color(255,50,50),"drown")	
	elseif dmgtype == 67108864 then	
		AddWarning("DARK ENERGY IMPACT DETECTED",Color(255,50,50),"AR2AltFire")
	end
end)

local function HazardThink()
	if SERVER then return end
	local ply = LocalPlayer()
	local hp = ply:Health()
	local ap = ply:Armor()
	local wep = ply:GetActiveWeapon()

	if !IsValid(wep) then return end
	local clip = wep:Clip1()
	local maxclip = wep:GetMaxClip1()
	local ammo = wep:GetPrimaryAmmoType()
	local ammocount = ply:GetAmmoCount(ammo)

	--[[if ply:GetNWBool("rogue") then
		if !Warning.rogue then
			Warning.rogue = true
			AddWarning("GONE  ROGUE",Color(255,50,50),"rogue")
		end
	else
		Warning.rogue = false
	end

	if ply:GetNWBool("manhunt") then
		if !Warning.manhunt then
			Warning.manhunt = true
			AddWarning("MANHUNT  STATUS  ACTIVE",Color(255,150,0),"rogue")
		end
	else
		Warning.manhunt = false
	end]]

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

	if hp <= 30 then
		--AddBuff("hp",Color(255, 0, 0))
		if !Warning.hp then
			AddWarning("SERIOUS  TRAUMA  DETECTED",Color(255,50,50),"kit")
			Warning.hp = true
		end
	else
		Warning.hp = false
	end

	if ap <= 0 then
		--AddBuff("item_battery",Color(255, 0, 0))
		if !Warning.ap then
			AddWarning("SHIELD  SYSTEM  OFFLINE",Color(200,200,200),"item_battery")
			Warning.ap = true
		end
	else
		Warning.ap = false
	end

	if wep:GetClass() ~= "weaponholster" then
		if clip <= maxclip/4 then
			AddWarning("LOW  AMMUNITION",Color(200,200,200),"ammo")
		end
	end
end

hook.Add("Think","AdvancedHazardThink",HazardThink)

--[[function Advanced.Buff(x,y,w,h)
	local FT = FrameTime()
	for k, v in pairs(buff) do
		if v.life > CurTime() then
			v.height = math.Approach(v.height,h,h*.1)
			if v.height == h then
				v.alpha = Lerp(FT*10,v.alpha,1)
				v.rectalpha = Lerp(FT*10,v.rectalpha,0)
			end
		else
            v.alpha = math.Approach(v.alpha,0,0.1)
            if v.alpha == 0 then
                key0 = key0 - 1
                table.remove(buff, k)
                table.remove(existbuff, k)
            end			
		end
		v.x = Lerp(FT*10,v.x,k*50)

		surface.SetDrawColor(255,255,255,150*v.alpha)
		surface.SetMaterial(Material("vgui/advanced_warfare/skill.png"))
		surface.DrawTexturedRect(x+v.x-50,y,w,h)

		surface.SetDrawColor(ColorAlpha(v.color,255*v.alpha))
		surface.SetMaterial(Material("vgui/advanced_warfare/"..v.icon..".png"))
		surface.DrawTexturedRect(x+v.x-50,y,w,h)

		draw.RoundedBox(4,x+v.x-50,y-v.height+h,w,v.height,ColorAlpha(v.color,255*v.rectalpha))
	end
end]]

local frag = Material("vgui/advanced_warfare/frag")
local arrow = Material("vgui/advanced_warfare/arrow")
local frag_x,frag_y = 0,0
local grenade_removed = {}

function Advanced.GrenadeIndicator()
	local ply = LocalPlayer()
	local eyePos = ply:EyePos() -- 获取玩家眼睛的位置
    local eyeAng = ply:EyeAngles()
	
	for _, ent in ipairs(ents.GetAll()) do
	    if ent:GetClass() == "npc_grenade_frag" then -- 判断是否是手雷实体
	    	ent.dist = ply:GetPos():Distance(ent:GetPos())
	        ent.screenPos = (ent:GetPos() + Vector(0, 0, 20)):ToScreen() -- 将手雷位置转换为屏幕空间坐标
	        ent.dx = ent.screenPos.x - ScrW() / 2 -- 计算屏幕中心和手雷位置之间的水平偏移
	        ent.dy = ent.screenPos.y - ScrH() / 2 -- 计算屏幕中心和手雷位置之间的垂直偏移
	        ent.angle = math.atan2(ent.dy, ent.dx) -- 计算偏移角度
	
	        -- 将偏移角度和距离转换为图标位置
	        ent.iconX = ScrW() / 2 + math.cos(ent.angle) * (ScrW() / 2 - 50)*.5
	        ent.iconY = ScrH() / 2 + math.sin(ent.angle) * (ScrH() / 2 - 50)*.5
	        ent.frag_x = Lerp(FrameTime()*10,ent.frag_x || 0,ent.iconX)
	        ent.frag_y = Lerp(FrameTime()*10,ent.frag_y || 0,ent.iconY)

	        if ent.dist > 350 then
	        	ent.alpha = Lerp(FrameTime()*10,ent.alpha || 0,0)
	        else
	        	ent.alpha = Lerp(FrameTime()*10,ent.alpha || 0,1)
	        end
	        -- 绘制威胁提示图标
	        surface.SetDrawColor(200, 200, 200,255*ent.alpha)
	        surface.SetMaterial(frag)
	        surface.DrawTexturedRect(ent.frag_x - 30, ent.frag_y - 30, 60, 60)

            ent.offset = ent:GetPos() - eyePos
            ent.offset:Rotate(Angle(0, -eyeAng.yaw, 0)) -- 根据玩家的视角旋转偏移量

            -- 将偏移量投影到玩家视角的水平平面上
            ent.direction = Vector(ent.offset.x, ent.offset.y, 0):GetNormalized()

            -- 绘制箭头
            surface.SetMaterial(arrow)
            surface.SetDrawColor(200, 200, 200, 255*ent.alpha)
            surface.DrawTexturedRectRotated(ent.frag_x, ent.frag_y, 100, 100, math.deg(math.atan2(ent.direction.y, ent.direction.x))-180)
	    end
	end

	for count, grenade in pairs(grenade_removed) do
		grenade.dist = ply:GetPos():Distance(grenade.lastPos)
	    grenade.screenPos = (grenade.lastPos + Vector(0, 0, 20)):ToScreen() -- 将手雷位置转换为屏幕空间坐标
	    grenade.dx = grenade.screenPos.x - ScrW() / 2 -- 计算屏幕中心和手雷位置之间的水平偏移
	    grenade.dy = grenade.screenPos.y - ScrH() / 2 -- 计算屏幕中心和手雷位置之间的垂直偏移
	    grenade.angle = math.atan2(grenade.dy, grenade.dx) -- 计算偏移角度
		
	    -- 将偏移角度和距离转换为图标位置
	    grenade.iconX = ScrW() / 2 + math.cos(grenade.angle) * (ScrW() / 2 - 50)*.5
	    grenade.iconY = ScrH() / 2 + math.sin(grenade.angle) * (ScrH() / 2 - 50)*.5
	    grenade.frag_x = Lerp(FrameTime()*10,grenade.frag_x || grenade.iconX,grenade.iconX)
	    grenade.frag_y = Lerp(FrameTime()*10,grenade.frag_y || grenade.iconY,grenade.iconY)

	    if grenade.dist > 350 then
	        grenade.alpha = Lerp(FrameTime()*10,grenade.alpha || 0,0)
	    end

	    grenade.alpha = Lerp(FrameTime()*5,grenade.alpha || 1,0)
	    -- 绘制威胁提示图标
	    surface.SetDrawColor(255, 0, 0, 255*grenade.alpha)
	    surface.SetMaterial(frag)
	    surface.DrawTexturedRect(grenade.frag_x - 30, grenade.frag_y - 30, 60, 60)

	    if grenade.alpha == 0 then
	    	table.RemoveByValue(grenade_removed,grenade)
	    end
	end
end

local grenade_count = 1
hook.Add("EntityRemoved", "LastGrenadePosition", function(ent)
    -- 检查被移除的实体是否是手雷
    if ent:GetClass() == "npc_grenade_frag" then
        local lastPos = ent:GetPos()
        grenade_count = grenade_count + 1
        grenade_removed[grenade_count] =  grenade_removed[grenade_count] || {}
        grenade_removed[grenade_count].lastPos = lastPos
    end
end)



function Advanced.Indicator(x,y)
    local FT = FrameTime()
    local background_color = Color(0,0,0,50)
    local textH = draw.GetFontHeight("AdvancedPick")*1.5

    for k, v in pairs(warning) do
        if v.life > CurTime() then
            v.length = math.Approach(v.length,10*string.len(v.name)+textH*2.2,(15*string.len(v.name)+textH*1.1)*.1)
            if v.length == (10*string.len(v.name)+textH*2.2) then
                v.alpha = Lerp(FT*10,v.alpha,1)
                v.rectalpha = Lerp(FT*10,v.rectalpha,0)
            end
        else
            --v.height = math.Approach(v.height,0,textH*.2)
            v.alpha = math.Approach(v.alpha,0,0.1)
            if v.alpha == 0 then
                key = key - 1
                table.remove(warning, k)
                table.remove(exist, k)
            end
        end

    	v.y = Lerp(FT*10,v.y,k*60)

        surface.SetDrawColor(ColorAlpha(background_color,50*v.alpha))
        surface.SetMaterial(blur)
        surface.DrawTexturedRect(x+textH*1.1,y+v.y-textH*.5,10*string.len(v.name)+textH*1.1,textH)
        surface.DrawRect(x+textH*1.1,y+v.y-textH*.5,10*string.len(v.name)+textH*1.1,textH)
        
        draw.RoundedBox(0,x,y+v.y-textH*.5,textH,textH,Color(0,0,0,50*v.alpha))

        surface.SetDrawColor(ColorAlpha(v.color,255*v.alpha))
        surface.SetMaterial(Material("vgui/advanced_warfare/"..v.icon))
        surface.DrawTexturedRect(x,y+v.y-textH*.5,textH,textH)
               
        draw.SimpleTextOutlined( v.name,"AdvancedPick",x+textH*1.3,y+v.y,ColorAlpha(v.color,255*v.alpha),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,2, Color(0, 0, 0, 20*v.alpha))
    
        surface.SetDrawColor(Color(200,200,200,150*v.rectalpha))
        surface.DrawRect(x,y+v.y-textH*.5,v.length,textH)
    end
end

local function Damaged(ply,dmginfo)
	local attacker = dmginfo:GetAttacker()
	local dmg = dmginfo:GetDamage()
	local type = dmginfo:GetDamageType()
	if !ply:IsPlayer() then return end

	net.Start("Advanced_Damaged")
		net.WriteFloat(dmginfo:GetDamageType())
	net.Send(ply)
end

hook.Add("EntityTakeDamage","AdvancedDamaged",Damaged,-100)