local aw = "advanced_warfare_"
Advanced.hud = CreateClientConVar(aw.."hud", 1, {FCVAR_USERINFO, FCVAR_ARCHIVE})
Advanced.background = CreateClientConVar(aw.."background", 1, {FCVAR_USERINFO, FCVAR_ARCHIVE})
Advanced.alpha = CreateClientConVar(aw.."alpha", 40, {FCVAR_USERINFO, FCVAR_ARCHIVE})
Advanced.scale = CreateClientConVar(aw.."scale", 1, {FCVAR_USERINFO, FCVAR_ARCHIVE})

Advanced.sway = CreateClientConVar(aw.."sway", 1, {FCVAR_USERINFO, FCVAR_ARCHIVE})

Advanced.mode = CreateClientConVar(aw.."mode", 1, {FCVAR_USERINFO, FCVAR_ARCHIVE})
Advanced.time = CreateClientConVar(aw.."time", 1, {FCVAR_USERINFO, FCVAR_ARCHIVE})
Advanced.map = CreateClientConVar(aw.."map", 0, {FCVAR_USERINFO, FCVAR_ARCHIVE})
Advanced.mode_x = CreateClientConVar(aw.."mode_x", 0, {FCVAR_USERINFO, FCVAR_ARCHIVE})
Advanced.mode_y = CreateClientConVar(aw.."mode_y", 0, {FCVAR_USERINFO, FCVAR_ARCHIVE})

Advanced.aux = CreateClientConVar(aw.."aux", 1, {FCVAR_USERINFO, FCVAR_ARCHIVE})
Advanced.aux_x = CreateClientConVar(aw.."aux_x", 0, {FCVAR_USERINFO, FCVAR_ARCHIVE})
Advanced.aux_y = CreateClientConVar(aw.."aux_y", 0, {FCVAR_USERINFO, FCVAR_ARCHIVE})

Advanced.health = CreateClientConVar(aw.."health", 1, {FCVAR_USERINFO, FCVAR_ARCHIVE})
Advanced.low = CreateClientConVar(aw.."low", 1, {FCVAR_USERINFO, FCVAR_ARCHIVE})
Advanced.health_x = CreateClientConVar(aw.."health_x", 0, {FCVAR_USERINFO, FCVAR_ARCHIVE})
Advanced.health_y = CreateClientConVar(aw.."health_y", 0, {FCVAR_USERINFO, FCVAR_ARCHIVE})

Advanced.armor = CreateClientConVar(aw.."armor", 1, {FCVAR_USERINFO, FCVAR_ARCHIVE})
Advanced.armor_x = CreateClientConVar(aw.."armor_x", 0, {FCVAR_USERINFO, FCVAR_ARCHIVE})
Advanced.armor_y = CreateClientConVar(aw.."armor_y", 0, {FCVAR_USERINFO, FCVAR_ARCHIVE})

Advanced.wep = CreateClientConVar(aw.."wep", 1, {FCVAR_USERINFO, FCVAR_ARCHIVE})
Advanced.ammo = CreateClientConVar(aw.."ammo", 1, {FCVAR_USERINFO, FCVAR_ARCHIVE})
Advanced.ammo_x = CreateClientConVar(aw.."ammo_x", 0, {FCVAR_USERINFO, FCVAR_ARCHIVE})
Advanced.ammo_y = CreateClientConVar(aw.."ammo_y", 0, {FCVAR_USERINFO, FCVAR_ARCHIVE})

Advanced.history = CreateClientConVar(aw.."history", 1, {FCVAR_USERINFO, FCVAR_ARCHIVE})
Advanced.history_x = CreateClientConVar(aw.."history_x", 0, {FCVAR_USERINFO, FCVAR_ARCHIVE})
Advanced.history_y = CreateClientConVar(aw.."history_y", 0, {FCVAR_USERINFO, FCVAR_ARCHIVE})

Advanced.indicator = CreateClientConVar(aw.."indicator", 1, {FCVAR_USERINFO, FCVAR_ARCHIVE})
Advanced.grenade = CreateClientConVar(aw.."grenade", 1, {FCVAR_USERINFO, FCVAR_ARCHIVE})
Advanced.indicator_x = CreateClientConVar(aw.."indicator_x", 0, {FCVAR_USERINFO, FCVAR_ARCHIVE})
Advanced.indicator_y = CreateClientConVar(aw.."indicator_y", 0, {FCVAR_USERINFO, FCVAR_ARCHIVE})

hook.Add("AddToolMenuCategories", "Advanced HUD Menu", function()
    spawnmenu.AddToolCategory("Utilities", "Advanced Warfare HUD", "#Advanced Warfare HUD")
end)

hook.Add("PopulateToolMenu", "Advanced HUD Menu", function()
    spawnmenu.AddToolMenuOption("Utilities", "Advanced Warfare HUD", "Advanced Warfare HUD Settings", "Settings", "", "", function(panel)
        panel:ClearControls()

        panel:CheckBox("Enable HUD", aw.."hud")
        panel:CheckBox("Display Background", aw.."background")
        panel:NumSlider("Background Alpha", aw.."alpha", 0, 100, 2)
        panel:CheckBox("Enable HUD Sway", aw.."sway")
        panel:CheckBox("Enable Time and GameMode", aw.."mode")
        panel:CheckBox("Disiplay in 24 hours", aw.."time")
        panel:CheckBox("Disiplay Name Of Map Instead Of GameMode", aw.."map")
        panel:NumSlider("Scale", aw.."scale", 0.1, 10, 2)
        panel:NumSlider("x", aw.."mode_x", -ScrW(), ScrW(), 2)
        panel:NumSlider("y", aw.."mode_y", -ScrH(), ScrH(), 2)

        panel:CheckBox("Enable Health", aw.."health")
        panel:CheckBox("Enable Low Health Effect", aw.."low")
        panel:NumSlider("x", aw.."health_x", -ScrW(), ScrW(), 2)
        panel:NumSlider("y", aw.."health_y", -ScrH(), ScrH(), 2)

        panel:CheckBox("Enable Aux Power", aw.."aux")
        panel:NumSlider("x", aw.."aux_x", -ScrW(), ScrW(), 2)
        panel:NumSlider("y", aw.."aux_y", -ScrH(), ScrH(), 2)


        panel:CheckBox("Enable Armor", aw.."armor")
        panel:NumSlider("x", aw.."armor_x", -ScrW(), ScrW(), 2)
        panel:NumSlider("y", aw.."armor_y", -ScrH(), ScrH(), 2)

        panel:CheckBox("Enable Ammo", aw.."ammo")
        panel:CheckBox("Display Weapon Name", aw.."wep")
        panel:NumSlider("x", aw.."ammo_x", -ScrW(), ScrW(), 2)
        panel:NumSlider("y", aw.."ammo_y", -ScrH(), ScrH(), 2)

        panel:CheckBox("Enable history", aw.."history")
        panel:NumSlider("x", aw.."history_x", -ScrW(), ScrW(), 2)
        panel:NumSlider("y", aw.."history_y", -ScrH(), ScrH(), 2)

        panel:CheckBox("Enable indicator", aw.."indicator")
        panel:CheckBox("Enable Grenade indicator", aw.."grenade")
        panel:NumSlider("x", aw.."indicator_x", -ScrW(), ScrW(), 2)
        panel:NumSlider("y", aw.."indicator_y", -ScrH(), ScrH(), 2)
    end)
end)