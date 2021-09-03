#include "70_inc_spells"
#include "inc_summon"
#include "nwnx_creature"

//This is executive script for summoning system.
//Script uses function from inc_summon, and should be executed in all scripts of summoning spells for make progression.
//In these scripts you must change blueprint of creature to your own blueprints, e.g. my "szc_sum001" which is base scheme for beast monsters or "szc_sum002" which is scheme for undead minions.

void main()
{
    object oPC = OBJECT_SELF;
    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC);

    // Fix issues when summon is killed after appear but before apply progress
    int nPlot = GetPlotFlag(oSummon);

    int nSpellID = GetLocalInt(oPC, "SPELLID");
    int clvl = GetLocalInt(oPC, "CASTERLVL");

    if (GetTag(oSummon) == "szc_sum003")
        ApplyEffPreset(oPC, oSummon);

    RandAppearance(oPC, oSummon);

    ApplyRandEff(oPC, oSummon);

    GetAdvancedSummon(oPC);
    AddRawAbility(oPC, oSummon);

    AddLvlProgress(oPC, oSummon);

    if (GetTag(oSummon) != "szc_sum004")//this is set portrait based on standard portrait assigned to each creature appearance in appearance.2da game file
    {
        int nAppear = GetAppearanceType(oSummon);

        string sPortrait = Get2DAString("appearance", "PORTRAIT", nAppear);

        sPortrait = sPortrait + "_";
        sPortrait = GetStringLowerCase(sPortrait);

        SetPortraitResRef(oSummon, sPortrait);
    }

    if (GetTag(oSummon) == "szc_sum004")//construct is created as inisivible dynamic human model so it must have 0 parameters for all bodyparts to achieve effect of flying sword)
    {
        SetPhenoType(50, oSummon);
        SetCreatureBodyPart(CREATURE_PART_LEFT_HAND, 0, oSummon);
        SetCreatureBodyPart(CREATURE_PART_RIGHT_HAND, 0, oSummon);
    }

    if (GetLocalInt(oSummon, "WeaponType") > 0 || GetTag(oSummon) == "szc_sum004")
        DelayCommand(1.0, CreateWeaponForSummon(oPC));

    // Apply buffs from spell school focus (transmutation) for summon animate object
    if (GetTag(oSummon) == "szc_sum004")
        ApplyFocusFeat(oPC, oSummon);

    SetPlotFlag(oSummon, FALSE);

    DelayCommand(1.0, AddRandomFeat(oPC, oSummon));
}
