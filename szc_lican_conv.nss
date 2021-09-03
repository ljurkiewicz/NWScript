#include "inc_moonhunter"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    string sSubrace = GetStringLowerCase(GetSubRace(oPC));
    int isLican = GetCampaignInt("bs_lican", "isLican", oPC);

    if (sSubrace == "likantrop" && (GetLevelByClass(CLASS_TYPE_MOONHUNTER, oPC) == 1 || GetLevelByClass(CLASS_TYPE_MOONHUNTER, oPC) == 2) && GetHasFeat(FEAT_MOONHUNT_HYBRIDE, oPC) && isLican == 1)
        return TRUE;
    else
    {
        return FALSE;//while FALSE, this mean character has variable flags before (e.g. character rebuild)
    }
}
