#include "nw_i0_plot"
#include "x2_inc_switches"
//this is one of few scripts which pull together to scenario of boss battle. The boss is shadow dragon which hide in shadow.
//Lair of dragon is covered by darkness, on event damage while dragon reached to 25% endurance, he turn in rage and is immortal.
//In that moment players need to collect parts of light crystal and put it in empty bowl, after that dragon can be mortal again.
//There are 4 bowl and this process need to be repeated.

//This is script for mechanism of broken light crystal collect and putting to columns/bowls in afiliation to dragon hit points (on his on damage event)


void GiveCrystal(object oItem, object oPC)
{
    object oArea = GetArea(OBJECT_SELF);
    int nCrystal = GetLocalInt(oArea, "CRYSTAL");
    if (GetIsObjectValid(oItem) && HasItem(oPC, "szc_light_cry") == TRUE)
    {
        int nCrystalStackSize = GetItemStackSize(oItem);

        if (nCrystalStackSize == 1)
            DestroyObject(oItem);
        else
            SetItemStackSize(oItem, nCrystalStackSize - 1);

        nCrystal++;

        SetLocalInt(oArea, "CRYSTAL", nCrystal);
    }
    else
    {
        SendMessageToPC(oPC, "You don't have any part of ligh crystal!");
        return;
    }
}

void main()
{
    object oPC = GetLastUsedBy();
    object oItem = GetItemPossessedBy(oPC, "szc_light_cry");
    object oArea = GetArea(OBJECT_SELF);
    int nCrystal = GetLocalInt(oArea, "CRYSTAL");
    int nColumn = GetLocalInt(oArea, "COLUMNISFULL");

    effect eLight = EffectVisualEffect(VFX_DUR_LIGHT_BLUE_10);

    location loc;
    if (GetTag(OBJECT_SELF) == "szc_pla_lcry")
    {
        CreateItemOnObject("szc_light_cry001", oPC);
        DestroyObject(OBJECT_SELF);
    }

    if (GetTag(OBJECT_SELF) == "szc_lcolumn001" && nColumn != 1)
    {
        nCrystal = GetLocalInt(oArea, "CRYSTAL");
        SendMessageToPC(oPC, "nCrystal = " + IntToString(nCrystal));
        if (nCrystal < 5)
            GiveCrystal(oItem, oPC);

        nCrystal = GetLocalInt(oArea, "CRYSTAL");
        SendMessageToPC(oPC, "nCrystal = " + IntToString(nCrystal));

        if (nCrystal == 5)
        {
            SetLocalInt(oArea, "COLUMNISFULL", 1);
            SendMessageToPC(oPC, "COLUMNISFULL: " + IntToString(nColumn));
            loc = Location(oArea, Vector(15.50f, 14.50f, 7.20f), 180.0f);
            CreateObject(OBJECT_TYPE_PLACEABLE, "zep_lightshft001", loc);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLight, GetObjectByTag("szc_lcolumn001"));

            SetPlotFlag(GetObjectByTag("szc_boss_zc"), FALSE);
        }
        else if (nCrystal > 5)
            SendMessageToPC(oPC, "Bowl of light is full");
    }

    if (GetTag(OBJECT_SELF) == "szc_lcolumn002" && nColumn != 2)
    {
        nCrystal = GetLocalInt(oArea, "CRYSTAL");
        SendMessageToPC(oPC, "nCrystal = " + IntToString(nCrystal));
        if (nCrystal >= 5 && nCrystal < 10)
            GiveCrystal(oItem, oPC);

        nCrystal = GetLocalInt(oArea, "CRYSTAL");
        SendMessageToPC(oPC, "nCrystal = " + IntToString(nCrystal));

        if (nCrystal == 10)
        {
            SetLocalInt(oArea, "COLUMNISFULL", 2);
            SendMessageToPC(oPC, "COLUMNISFULL: " + IntToString(nColumn));
            loc = Location(oArea, Vector(14.50f, 75.50f, 7.20f), 180.0f);
            CreateObject(OBJECT_TYPE_PLACEABLE, "zep_lightshft001", loc);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLight, GetObjectByTag("szc_lcolumn002"));

            SetPlotFlag(GetObjectByTag("szc_boss_zc"), FALSE);
        }
        else if (nCrystal > 10)
            SendMessageToPC(oPC, "Bowl of light is full");
    }

    if (GetTag(OBJECT_SELF) == "szc_lcolumn003" && nColumn != 3)
    {
        nCrystal = GetLocalInt(oArea, "CRYSTAL");
        SendMessageToPC(oPC, "nCrystal = " + IntToString(nCrystal));
        if (nCrystal >= 10 && nCrystal < 15)
            GiveCrystal(oItem, oPC);

        nCrystal = GetLocalInt(oArea, "CRYSTAL");
        SendMessageToPC(oPC, "nCrystal = " + IntToString(nCrystal));

        if (nCrystal == 15)
        {
            SetLocalInt(oArea, "COLUMNISFULL", 3);
            SendMessageToPC(oPC, "COLUMNISFULL: " + IntToString(nColumn));
            loc = Location(oArea, Vector(74.40f, 75.50f, 7.20f), 180.0f);
            CreateObject(OBJECT_TYPE_PLACEABLE, "zep_lightshft001", loc);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLight, GetObjectByTag("szc_lcolumn003"));

            SetPlotFlag(GetObjectByTag("szc_boss_zc"), FALSE);
        }
        else if (nCrystal > 15)
            SendMessageToPC(oPC, "Bowl of light is full");
    }

    if (GetTag(OBJECT_SELF) == "szc_lcolumn004" && nColumn != 4)
    {
        nCrystal = GetLocalInt(oArea, "CRYSTAL");
        SendMessageToPC(oPC, "nCrystal = " + IntToString(nCrystal));
        if (nCrystal >= 15 && nCrystal < 20)
            GiveCrystal(oItem, oPC);

        nCrystal = GetLocalInt(oArea, "CRYSTAL");
        SendMessageToPC(oPC, "nCrystal = " + IntToString(nCrystal));

        if (nCrystal == 20)
        {
            SetLocalInt(oArea, "COLUMNISFULL", 4);
            SendMessageToPC(oPC, "COLUMNISFULL: " + IntToString(nColumn));
            loc = Location(oArea, Vector(75.40f, 14.40f, 7.20f), 180.0f);
            CreateObject(OBJECT_TYPE_PLACEABLE, "zep_lightshft001", loc);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLight, GetObjectByTag("szc_lcolumn004"));

            SetPlotFlag(GetObjectByTag("szc_boss_zc"), FALSE);
        }
        else if (nCrystal > 20)
            SendMessageToPC(oPC, "Bowl of light is full");
    }
}
