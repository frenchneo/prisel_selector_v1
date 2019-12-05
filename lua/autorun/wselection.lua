if SERVER then return end

WeaponSelection = {}

local Time = 0

local Weapon_ID = 0

local WeaponsCount = 0

local Weapons = {}

local TitleOffset = 0



local function GetWeaponType(class)

    if (string.find(class, "fas2_") or class == "fists_weapon" or class == "weapon_fists" or class == "ultra_fists" or class == "stungun") then

        return "weapon"

    elseif (string.find(class, "weapon_") or string.find(class, "gmod_")) then

        return "job"

    else

        return "normal"

    end

end



local function GetWeaponCaching(weps)

    local tmp = {}



    for k, v in pairs(weps) do

        table.insert(tmp, v)

    end



    return tmp

end



local function drawRectOutline(x, y, w, h, color)

    surface.SetDrawColor(color)

    surface.DrawOutlinedRect(x, y, w, h)

end



function WeaponSelection:Draw()

    local Counter = 0

    local offset = (table.Count(Weapons) * 14)

    TitleOffset = offset



    for k, v in pairs(Weapons) do

        if (v and IsValid(v)) then

            Counter = Counter + 1

            local type = GetWeaponType(v:GetClass())



            if (Counter == Weapon_ID) then

                if (type == "weapon" and v:GetClass() ~= "fists_weapon" and v:GetClass() ~= "weapon_fists" and v:GetClass() ~= "ultra_fists" and v:GetClass() ~= "stungun") then

                    WeaponSelection:DrawAmmo(v, ScrW() - 155, (ScrH() / 2) - (TitleOffset) - 30)

                end



                WeaponSelection:DrawWeaponItem(v:GetPrintName(), ScrW() - 140, (ScrH() / 2) - offset, type)

            else

                WeaponSelection:DrawWeaponItem(v:GetPrintName(), ScrW() - 155, (ScrH() / 2) - offset, type)

            end



            offset = offset - 22

        end

    end

end



function WeaponSelection:DrawWeaponItem(name, posx, posy, type)

    local BoxSize_W = 150

    local BoxSize_H = 20

    local BoxColor = Color(40, 40, 40, 220)

    local TextColor = Color(255, 255, 255, 255)

    local LineColor = Color(255, 0, 0)

    local LineDecal = 5



    if (type == "weapon") then

        LineColor = Color(180, 50, 50)

    elseif (type == "job") then

        LineColor = Color(100, 180, 50)

    else

        LineColor = Color(30, 120, 150)

    end



    draw.RoundedBox(0, posx - ScrW() + 180, posy, BoxSize_W, BoxSize_H, BoxColor)

    drawRectOutline(posx - ScrW() + 180, posy, BoxSize_W, BoxSize_H, Color(255, 255, 255, 10))

    draw.SimpleText(name, "PriselFront8", (posx - ScrW() + 180) + (BoxSize_W * 0.5), posy + (BoxSize_H * 0.5), TextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    surface.SetDrawColor(LineColor)

    surface.DrawRect(posx - ScrW() + 180, posy, 3, BoxSize_H)

end



function WeaponSelection:ShouldDraw()

    if (Time and Time + 1.5 > CurTime()) then return true end



    return false

end



function WeaponSelection:InitialCall()

    Weapons = GetWeaponCaching(LocalPlayer():GetWeapons())

    local Current_Weapon = LocalPlayer():GetActiveWeapon()

    WeaponsCount = table.Count(Weapons)

    Weapon_ID = table.KeyFromValue(Weapons, Current_Weapon)



    timer.Create("refresh_weapons", 0.5, 0, function()

        Weapons = GetWeaponCaching(LocalPlayer():GetWeapons())

        WeaponsCount = table.Count(Weapons)

    end)

end



function WeaponSelection:SetSelection(id)

    if (LocalPlayer():InVehicle()) then return false end

    Time = CurTime()

    WeaponSelection:InitialCall()

    Weapon_ID = id

end



function WeaponSelection:Call()

    if (WeaponSelection:ShouldDraw()) then

        Time = CurTime()

    else

        Time = CurTime()

        WeaponSelection:InitialCall()

    end

end



function WeaponSelection:NextWeapon()

    if (WeaponsCount > 0) then

        surface.PlaySound("blipers/blipweapon.wav")

    end



    if (not Weapon_ID) then

        Weapon_ID = 1

    end



    if (WeaponsCount == Weapon_ID) then

        Weapon_ID = 1

    else

        Weapon_ID = Weapon_ID + 1

    end

end



function WeaponSelection:PrevWeapon()

    if (WeaponsCount > 0) then

        surface.PlaySound("blipers/blipweapon.wav")

    end



    if (not Weapon_ID) then

        Weapon_ID = 1

    end



    if (Weapon_ID == 1) then

        Weapon_ID = WeaponsCount

    else

        Weapon_ID = Weapon_ID - 1

    end

end



function WeaponSelection:SelectWeapon()

    if (Weapon_ID and Weapons[Weapon_ID] and IsValid(Weapons[Weapon_ID])) then

        RunConsoleCommand("use", Weapons[Weapon_ID]:GetClass())

        timer.Destroy("refresh_weapons")

        Time = 0

    end

end



function WeaponSelection:Think()

end
