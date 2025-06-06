Advanced = {}

function Advanced.IncludeFile(file)
    if SERVER then
        include(file)
        AddCSLuaFile(file)
    end

    if CLIENT then
        include(file)
    end
end

Advanced.IncludeFile("advanced_warfare/base.lua")
Advanced.IncludeFile("advanced_warfare/functions.lua")