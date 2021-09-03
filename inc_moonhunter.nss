//////////////////////////////////
// #include "inc_moonhunter"
////////////////////////////////

#include "inc_colors"
#include "inc_const"
#include "inc_pc_func"
#include "x2_inc_itemprop"
#include "x3_inc_skin"

//This is functions library for custom prestige class - Moon Hunter. This is licantrop class mainly for ranger/druid/barbarian.


//This function apply bonuses for skill Blood Call, which is state after charge stamina level (on nwnx damage event script). This function has control to flags on/off bloodcall
void ApplyBloodCall(object oPC);

//Display information about stamina charging
void StaminaInfo(object oPC);

//Passive class bonus to skills based on senses (spot,listen, hide, move silently)
void ApplyWolfSense(object oPC, object oSkin);

//This function cares about properly remove class bonuses or variables which are placed on creature skin (e.g, for character rebuild or remove licanthrop curse)
void RemoveMoonhunterBonuses(object oPC, object oSkin);

//This skill give level progress to animal companion (ranger/druid only), and turn companion in wolf for aesthetics
void SummonWolfCompanion(object oMaster);

//Function for licantrop curse, which make chance to randomly transform in werewolf form in night(i realised it on nwnx event calendar)
void MissControlPoly(object oPC, int Random1, int Random2);

//Function make control about class prerequisities or class choices by set of flags which are save as clocal and global variables.
void SetLicantropVar(object oPC, object oSkin);

//Function which clear field of character subrace and remove variable flags, and call function RemoveMoonhunterBonuses()
void ClearSubrace(object oPC, object oSkin);

//Function which give player opportunity to select appearance (mainly - color) of hybrid werewolf form
void AbilityColorChoice(object oPC);

//Another function which apply class bonus to creature skin
void SetRege(object oPC, object oSkin);


void ApplyBloodCall(object oPC)
{
    int nRege = GetSkillRank(SKILL_ANIMAL_EMPATHY, oPC, TRUE) / 8;
    int nSpeed = GetSkillRank(SKILL_ANIMAL_EMPATHY, oPC, TRUE);

    int nDuration = GetSkillRank(SKILL_ANIMAL_EMPATHY, oPC, FALSE) / 4;

    effect eVis = EffectVisualEffect(VFX_DUR_AURA_PULSE_RED_BLACK);

    effect eDamImmunB = EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, 5);
    effect eDamImmunP = EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING, 5);
    effect eDamImmunS = EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING, 5);

    effect eRege = EffectRegenerate(nRege, 3.0);

    effect eSpeed = EffectMovementSpeedIncrease(nSpeed);

    effect eLink = EffectLinkEffects(eDamImmunB, eDamImmunP);
    eLink = EffectLinkEffects(eLink, eDamImmunS);
    effect eLink1 = EffectLinkEffects(eLink, eVis);
    eLink1 =  SupernaturalEffect(eLink1);
    effect eLink2 = EffectLinkEffects(eLink1, eRege);
    eLink2 =  SupernaturalEffect(eLink2);
    effect eLink3 = EffectLinkEffects(eLink2, eSpeed);
    eLink3 =  SupernaturalEffect(eLink3);

    if (GetLocalInt(oPC, "Stamina") >= 100)
    {
        if (GetHasFeat(FEAT_MOONHUNT_BLD_CALL, oPC) && GetLevelByClass(CLASS_TYPE_MOONHUNTER, oPC) >= 10)
        {
            eLink3 = TagEffect(eLink3, "zew");
            DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink3, oPC, RoundsToSeconds(nDuration)));
            FloatingTextStringOnCreature(HexColorString("Na³o¿ono tier 3!", COLOR_INFO), oPC, FALSE);
        }
        else if (GetHasFeat(FEAT_MOONHUNT_BLD_CALL, oPC) && GetLevelByClass(CLASS_TYPE_MOONHUNTER, oPC) >= 6)
        {
            eLink2 = TagEffect(eLink3, "zew");
            DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oPC, RoundsToSeconds(nDuration)));
            FloatingTextStringOnCreature(HexColorString("Na³o¿ono tier 2!", COLOR_INFO), oPC, FALSE);
        }
        else if (GetHasFeat(FEAT_MOONHUNT_BLD_CALL, oPC) && GetLevelByClass(CLASS_TYPE_MOONHUNTER, oPC) >= 3)
        {
            eLink1 = TagEffect(eLink3, "zew");
            DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink1, oPC, RoundsToSeconds(nDuration)));
            FloatingTextStringOnCreature(HexColorString("Na³o¿ono tier 1!", COLOR_INFO), oPC, FALSE);
        }

        DeleteLocalInt(oPC, "Stamina");
        // End of recharge stamina
        SetLocalInt(oPC, "blood_call_on", FALSE);
        // Apply bonuses from blood call
        SetLocalInt(oPC, "blood_call", TRUE);
    }
}

void StaminaInfo(object oPC)
{
    int nValue = d8();
    int nCurrentValue = GetLocalInt(oPC, "Stamina");
    int nDE = nCurrentValue + nValue;
    string sDE = IntToString(nDE);

    SetLocalInt(oPC, "Stamina", nDE);

    if (GetLocalInt(oPC, "StaminaInfo") != 1)
    {
        FloatingTextStringOnCreature(HexColorString("Poziom adrenaliny roœnie! " + sDE + "%.", COLOR_INFO), oPC, FALSE);
        SetLocalInt(oPC, "StaminaInfo", 1);
        DelayCommand(6.0, SetLocalInt(oPC, "StaminaInfo", 0));
    }

    if (GetLocalInt(oPC, "Stamina") >= 100)
    {
        FloatingTextStringOnCreature(HexColorString("Osi¹gniêto pe³ny poziom adrenaliny.", COLOR_INFO), oPC, FALSE);
        SetLocalInt(oPC, "Stamina", 100);
        ApplyBloodCall(oPC);
    }
}

void ApplyWolfSense(object oPC, object oSkin)
{
    RemoveMoonhunterBonuses(oPC, oSkin);
    itemproperty iProp;

    if (GetHasFeat(FEAT_MOONHUNT_WOLF_SENSE, oPC))
    {
        int nBonus = GetSkillRank(SKILL_ANIMAL_EMPATHY, oPC, FALSE) / 10;

        iProp =  ItemPropertySkillBonus(SKILL_HIDE, nBonus);
        iProp = TagItemProperty(iProp, "iHide");
        AddItemProperty(DURATION_TYPE_PERMANENT, iProp, oSkin, 0.0f);

        iProp =  ItemPropertySkillBonus(SKILL_LISTEN, nBonus);
        iProp = TagItemProperty(iProp, "iList");
        AddItemProperty(DURATION_TYPE_PERMANENT, iProp, oSkin, 0.0f);

        iProp =  ItemPropertySkillBonus(SKILL_MOVE_SILENTLY, nBonus);
        iProp = TagItemProperty(iProp, "iSilm");
        AddItemProperty(DURATION_TYPE_PERMANENT, iProp, oSkin, 0.0f);

        iProp =  ItemPropertySkillBonus(SKILL_SPOT, nBonus);
        iProp = TagItemProperty(iProp, "iSpot");
        AddItemProperty(DURATION_TYPE_PERMANENT, iProp, oSkin, 0.0f);
    }
}

void RemoveMoonhunterBonuses(object oPC, object oSkin)
{
    itemproperty ipLoop = GetFirstItemProperty(oSkin);
    while (GetIsItemPropertyValid(ipLoop))
    {
        if (GetItemPropertyTag(ipLoop) == "iHide" || GetItemPropertyTag(ipLoop) == "iList" || GetItemPropertyTag(ipLoop) == "iSilm" ||
            GetItemPropertyTag(ipLoop) == "iSpot") //|| GetItemPropertyTag(ipLoop) == "iLicanCurse" || GetItemPropertyTag(ipLoop) == "iRege")
            RemoveItemProperty(oSkin, ipLoop);

        ipLoop = GetNextItemProperty(oSkin);
    }
}

void MissControlPoly(object oPC, int Random1, int Random2)
{
    int nHour = GetTimeHour();
    effect eConf = EffectConfused();
    int nPoly = GetCampaignInt("bs_lican", "isLican", oPC);
    int nTail;
    effect ePoly;

    if (nPoly == 1)
        ePoly = EffectPolymorph(126, TRUE);
    if (nPoly == 2)
    {
        ePoly = EffectPolymorph(131, TRUE);
        nTail = 1011;
    }
    if (nPoly == 3)
    {
        ePoly = EffectPolymorph(133, TRUE);
        nTail = 1011;
    }
    if (nPoly == 4)
    {
        ePoly = EffectPolymorph(127, TRUE);
        nTail = 1012;
    }
    if (nPoly == 5)
    {
        ePoly = EffectPolymorph(129, TRUE);
        nTail = 1012;
    }

    int nSaveDC = 10 + GetLevel(oPC);

    if ((nHour == Random1) || (nHour == Random2))
    {
        if (GetLevelByClass(CLASS_TYPE_MOONHUNTER, oPC) >= 7 && GetHasFeat(FEAT_MOONHUNT_SHAPE_CONTROL, oPC))
            FloatingTextStringOnCreature(HexColorString("Zachowano kontrolê nad kszta³tem.", COLOR_INFO), oPC, FALSE);
        else if (GetLevelByClass(CLASS_TYPE_MOONHUNTER, oPC) >= 1)
        {
            if (!GetIsSkillSuccessful(oPC, SKILL_ANIMAL_EMPATHY, nSaveDC))
            {
                FloatingTextStringOnCreature(HexColorString("Argghh! Utracono kontrolê.", COLOR_FAIL), oPC, FALSE);

                if (!GetHasSpellEffect(1000, oPC) && !GetHasSpellEffect(1001, oPC))
                {
                    DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, oPC, HoursToSeconds(1)));
                    SetCreatureTailType(nTail, oPC);
                }

                DelayCommand(3.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eConf, oPC, RoundsToSeconds(10)));
            }
        }
        else if (GetStringLowerCase(GetSubRace(oPC)) == "likantrop" && !GetLevelByClass(CLASS_TYPE_MOONHUNTER, oPC))
        {
            if (!WillSave(oPC, nSaveDC, SAVING_THROW_TYPE_MIND_SPELLS, oPC))
            {
                FloatingTextStringOnCreature(HexColorString("Argghh! Utracono kontrolê.", COLOR_FAIL), oPC, FALSE);

                if (!GetHasSpellEffect(1000, oPC) && !GetHasSpellEffect(1001, oPC))
                {
                    DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, oPC, HoursToSeconds(1)));
                    SetCreatureTailType(nTail, oPC);
                }

                DelayCommand(3.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eConf, oPC, RoundsToSeconds(10)));
            }
        }
    }
}

void SetLicantropVar(object oPC, object oSkin)
{
    itemproperty iProp = ItemPropertyBonusFeat(65);
    iProp = TagItemProperty(iProp, "iLicanCurse");
    oSkin = SKIN_SupportGetSkin(oPC);
    SetSubRace(oPC, "Likantrop");

    FloatingTextStringOnCreature(HexColorString("Uzyskujesz w³aœciwoœci Likantropa.", COLOR_INFO), oPC, FALSE);

    SetLocalInt(oPC, "BS_AllowMH", 13);
    // IsLican: 0 - no lican, 1 - is lican, 2 - is black strong lican, 3 is black dex lican, 4 is grey strong lican, 5 is grey dex lican

    if (GetLocalInt(oPC, "BS_AllowMH") == 13)
        FloatingTextStringOnCreature(HexColorString("Uzyskujesz zmienn¹ 13, mo¿esz awansowaæ jako drapie¿nik cichych nocy.", COLOR_INFO), oPC, FALSE);

    if (!GetHasFeat(FEAT_LICANTROP_CURSE, oPC))
        IPSafeAddItemProperty(oSkin, iProp, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE , FALSE);
    else
        RemoveItemProperty(oSkin, iProp);
}

void ClearSubrace(object oPC, object oSkin)
{
    SetSubRace(oPC, "");
    FloatingTextStringOnCreature(HexColorString("Jesteœ normalny.", COLOR_INFO), oPC, FALSE);

    DeleteLocalInt(oPC, "BS_AllowMH");
    DeleteLocalInt(oSkin, "isLican");
    DeleteCampaignVariable("bs_lican", "isLican",oPC);
    RemoveMoonhunterBonuses(oPC, oSkin);
}

void AbilityColorChoice(object oPC)
{
    string sRace = GetStringLowerCase(GetSubRace(oPC));
    int isLican = GetCampaignInt("bs_lican", "isLican", oPC);

    if (!GetIsPC(oPC) || GetIsDM(oPC))
        return;

    if (sRace != "likantrop")
        return;

    if (isLican > 1)
    {
        FloatingTextStringOnCreature(HexColorString("Nie spelniasz warunku funkcji AbilityColorChoice!", COLOR_FAIL), oPC, FALSE);
        return;
    }

    AssignCommand(oPC, ActionStartConversation(oPC, "c_moonhunt_conv", TRUE, FALSE));
}

void SetRege(object oPC, object oSkin)
{
    itemproperty iProp;

    if (GetHasFeat(FEAT_MOONHUNT_REGE, oPC))
    {
        if (GetLevelByClass(CLASS_TYPE_MOONHUNTER, oPC) >= 10)
            iProp = ItemPropertyRegeneration(3);
        else if (GetLevelByClass(CLASS_TYPE_MOONHUNTER, oPC) >= 4)
            iProp = ItemPropertyRegeneration(2);
        else if (GetLevelByClass(CLASS_TYPE_MOONHUNTER, oPC) >= 1)
            iProp = ItemPropertyRegeneration(1);
    }

    iProp = TagItemProperty(iProp, "iRege");
    IPSafeAddItemProperty(oSkin, iProp, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE , FALSE);
}
