// Licantrop subrace at event on enter

#include "inc_moonhunter"
#include "x2_inc_itemprop"
#include "x3_inc_skin"

void main()
{
    object oPC = GetEnteringObject();
    object oSkin = SKIN_SupportGetSkin(oPC);

    string sSubrace = GetStringLowerCase(GetSubRace(oPC));

    if (sSubrace == "likantrop" && GetCampaignInt("bs_lican", "isLican", oPC) > 0)
        SetLicantropVar(oPC, oSkin);

    if (sSubrace == "likantrop" && !GetCampaignInt("bs_lican", "isLican", oPC))
        ClearSubrace(oPC, oSkin);

    if (GetHasFeat(FEAT_MOONHUNT_HYBRIDE, oPC) && GetHasFeat(FEAT_MOONHUNT_WOLF, oPC) && GetLevelByClass(CLASS_TYPE_MOONHUNTER, oPC) >= 1)
        AbilityColorChoice(oPC);

    if (sSubrace != "likantrop")
    {
        itemproperty ipLoop = GetFirstItemProperty(oSkin);
        while (GetIsItemPropertyValid(ipLoop))
        {
            if (GetItemPropertyTag(ipLoop) == "curse")
                RemoveItemProperty(oSkin, ipLoop);

            ipLoop = GetNextItemProperty(oSkin);
        }
    }
}
