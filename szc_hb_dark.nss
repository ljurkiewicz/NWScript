#include "inc_effect"
#include "nw_i0_spells"
#include "x0_i0_spells"

//this is one of few scripts which pull together to scenario of boss battle. The boss is shadow dragon which hide in shadow.
//Lair of dragon is covered by darkness, on event damage while dragon reached to 25% endurance, he turn in rage and is immortal.
//In that moment players need to collect parts of light crystal and put it in empty bowl, after that dragon can be mortal again.
//There are 4 bowl and this process need to be repeated.

//This is script for event heartbeats for area (this means, this script is executing after each 6 second) of dragon lair, which caused permanent darkness on this location. Darkness ended after dragon death.


void main()
{
    effect eDark = EffectDarkness();
    effect eBlind = EffectBlindness();

    object oPC = GetFirstObjectInArea(OBJECT_SELF);
    while (GetIsObjectValid(oPC))
    {
        if (GetIsPC(oPC) && !GetIsDead(GetObjectByTag("szc_boss_zc")))
        {
            if (!GetHasTaggedEffect(oPC, "DARK") && !GetHasTaggedEffect(oPC, "BLIND"))
            {
                ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, eDark, oPC, "DARK", 0.0f, SUBTYPE_SUPERNATURAL);
                SendMessageToPC(oPC, "Chamber is fullfill of deep darknes, which limiting your senses");

                if (GetHasTaggedEffect(oPC, "UVision") || GetHasTaggedEffect(oPC, "TruVision"))
                {
                    RemoveTaggedEffects(oPC, "UVision");
                    RemoveTaggedEffects(oPC, "TruVision");
                    SendMessageToPC(oPC, "Spells of sharp senses quickly expired");
                }
            }
         }

         if ((GetHasTaggedEffect(oPC, "DARK") || GetHasTaggedEffect(oPC, "BLIND")) && GetIsDead(GetObjectByTag("szc_boss_zc")))
         {
            RemoveTaggedEffects(oPC, "DARK");
            RemoveTaggedEffects(oPC, "BLIND");
            SendMessageToPC(oPC, "Darkness slowly has removed");
         }

        oPC = GetNextObjectInArea(OBJECT_SELF);
    }
}
