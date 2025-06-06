local key = 0
local history = {}
local blur = Material("vgui/advanced_warfare/blur")
local function AddHistory(name,color,icon)
    local textH = draw.GetFontHeight("AdvancedPick")*1.5
    if key > 3 then
        key = key - 1
        table.remove(history, key-3)
    end

    key = key + 1
    history[key] = history[key] or {}
    history[key].name = name
    history[key].alpha = 0
    history[key].rectalpha = 1
    history[key].life = CurTime()+3+(key-1)*0.5
    history[key].length = 0
    --history[key].height = textH
    history[key].y = 50*key
    history[key].color = color 
    history[key].icon = icon
end

function Advanced.History(x,y)
    local FT = FrameTime()
    local background_color = Color(0,0,0,50)
    local textH = draw.GetFontHeight("AdvancedPick")*1.5

    for k, v in pairs(history) do
        if v.life > CurTime() then
            v.length = math.Approach(v.length,13*string.len(v.name)+textH*1.1,(15*string.len(v.name)+textH*1.1+5)*.1)
            if v.length == (13*string.len(v.name)+textH*1.1) then
                v.alpha = Lerp(FT*10,v.alpha,1)
                v.rectalpha = Lerp(FT*10,v.rectalpha,0)
            end
        else
            --v.height = math.Approach(v.height,0,textH*.2)
            v.alpha = math.Approach(v.alpha,0,0.1)
            if v.alpha == 0 then
                key = key - 1
                table.remove(history, k)
            end
        end

    v.y = Lerp(FT*10,v.y,k*60)

        surface.SetDrawColor(ColorAlpha(background_color,50*v.alpha))
        surface.SetMaterial(blur)
        surface.DrawTexturedRect(x+textH*1.1,y+v.y-textH*.5,13*string.len(v.name),textH)
        surface.DrawRect(x+textH*1.1,y+v.y-textH*.5,13*string.len(v.name),textH)
        
        surface.SetDrawColor(255,255,255,255*v.alpha)
        surface.SetMaterial(Material("vgui/advanced_warfare/"..v.icon))
        surface.DrawTexturedRect(x,y+v.y-textH*.5,textH,textH)
        
        --draw.RoundedBox(0,x+textH,y+v.y-textH*.5,2,textH,Color(255,255,255,20*v.alpha))
        draw.RoundedBox(0,x,y+v.y-textH*.5,textH,textH,Color(0,0,0,50*v.alpha))
        
        draw.SimpleTextOutlined( v.name,"AdvancedPick",x+textH*1.35,y+v.y,Color(255,255,255,255*v.alpha),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,2, Color(0, 0, 0, 20*v.alpha))
    
        surface.SetDrawColor(Color(200,200,200,50*v.rectalpha))
        surface.DrawRect(x,y+v.y-textH*.5,v.length,textH)

    end
end

hook.Add("HUDDrawPickupHistory", "advanced_warfareHidePickHistory", function()
    return false
end)

local color = Color(200,200,200)
hook.Add( "HUDAmmoPickedUp", "advanced_warfareAmmoPickedUp", function(itemName, amount)
    local item = string.upper(language.GetPhrase("#" .. itemName .. "_ammo"))..' x '..amount
    local icon = "ammo"
    if itemName == "Grenade" or itemName == "SMG1_Grenade" or itemName == "Buckshot" or itemName == "AR2AltFire" or itemName == "RPG_Round" or itemName == "XBowBolt" then
        icon = itemName
    end
    AddHistory(item,color,icon)
end)

hook.Add( "HUDItemPickedUp", "advanced_warfareItemPickedUp", function(itemName)
    local item = string.upper(language.GetPhrase("#" .. itemName))..' x 1'
    local icon = "kit"
    if itemName == "item_battery" then
        icon = itemName
    end
    AddHistory(item,color,icon)
end)

hook.Add( "HUDWeaponPickedUp", "advanced_warfareWeaponPickedUp", function(weapon)
    local item = string.upper(language.GetPhrase(weapon:GetPrintName()))
    local icon = "weapon"
    if weapon:GetClass() == "weapon_frag" then return end
    AddHistory(item.." ",color,icon)
end)