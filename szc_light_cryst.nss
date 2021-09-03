#include "x0_i0_position"
//this is one of few scripts which pull together to scenario of boss battle. The boss is shadow dragon which hide in shadow.
//Lair of dragon is covered by darkness, on event damage while dragon reached to 25% endurance, he turn in rage and is immortal.
//In that moment players need to collect parts of light crystal and put it in empty bowl, after that dragon can be mortal again.
//There are 4 bowl and this process need to be repeated.

//This is script for random location for spawn broken light crystal

object RollWaypoint()
{
    int nRoll = d4();
    object oWayPoint;
    switch (nRoll)
    {
        case 1: oWayPoint = GetWaypointByTag("light_crystal001"); break;
        case 2: oWayPoint = GetWaypointByTag("light_crystal002"); break;
        case 3: oWayPoint = GetWaypointByTag("light_crystal003"); break;
        case 4: oWayPoint = GetWaypointByTag("light_crystal004"); break;
    }

    return oWayPoint;
}

void main()
{
    object oArea = GetArea(OBJECT_SELF);

    object oWay;
    int nHeal = GetLocalInt(GetObjectByTag("szc_boss_zc"), "HEAL");

    object oPC = GetFirstObjectInArea(oArea);
    while (GetIsObjectValid(oPC))
    {
        SendMessageToPC(oPC, "One of bowls, which radiate weakly light suddenly crashed, chamber was fulfill sound of rumbling crushed glass");

        oPC = GetNextObjectInArea(oArea);
    }

    location lTg, lExplo;
    switch (nHeal)
    {
        case 1:
            lExplo = Location(oArea, Vector(15.50f, 14.50f, 7.20f), 180.0f);
            DestroyObject(GetObjectByTag("szc_fire001"));
        break;
        case 2:
            lExplo = Location(oArea, Vector(14.50f, 75.50f, 7.20f), 180.0f);
            DestroyObject(GetObjectByTag("szc_fire002"));
        break;
        case 3:
            lExplo = Location(oArea, Vector(74.40f, 75.50f, 7.20f), 180.0f);
            DestroyObject(GetObjectByTag("szc_fire003"));
        break;
        case 4:
            lExplo = Location(oArea, Vector(75.40f, 14.40f, 7.20f), 180.0f);
            DestroyObject(GetObjectByTag("szc_fire004"));
        break;
    }

    effect eExplode = EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION);

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lExplo);

    oWay = RollWaypoint();
    lTg = GetRandomLocation(oArea, oWay, 0.0f);
    CreateObject(OBJECT_TYPE_PLACEABLE, "szc_pla_lcry001", lTg);

    oWay = RollWaypoint();
    lTg = GetRandomLocation(oArea, oWay, 0.0f);
    CreateObject(OBJECT_TYPE_PLACEABLE, "szc_pla_lcry001", lTg);

    oWay = RollWaypoint();
    lTg = GetRandomLocation(oArea, oWay, 0.0f);
    CreateObject(OBJECT_TYPE_PLACEABLE, "szc_pla_lcry001", lTg);

    oWay = RollWaypoint();
    lTg = GetRandomLocation(oArea, oWay, 0.0f);
    CreateObject(OBJECT_TYPE_PLACEABLE, "szc_pla_lcry001", lTg);

    oWay = RollWaypoint();
    lTg = GetRandomLocation(oArea, oWay, 0.0f);
    CreateObject(OBJECT_TYPE_PLACEABLE, "szc_pla_lcry001", lTg);
}
