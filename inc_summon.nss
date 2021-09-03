#include "70_inc_spells"
#include "nwnx_creature"
//This system serves for much more variety in summoning monster as ally for all spellcaster classes.
//Summoning spells called base blueprint of creature and give this creature progress based on Caster Level character who cast this spell.
//This progres covering: level progression, phisical ability, feat choice and bonus special effect like damage resistance or elemental damage bonus.

int bAdvancedSummon = 0;

//Function which manage howstrong summon you can conjure - unique class or feat can improve these feature
void GetAdvancedSummon(object oPC);

//Function is responsible for random appearance models for conjured creature - unique for varoius conjuring spell (undead, planar, beast, construct)
void RandAppearance(object oPC, object oSum);

//Function has control about lists of random effect, which creature has chance to receive.
effect RandEffect(object oPC, object oSum);

//Function for applying random effect for conjured creature (effect has selected in call of function RandEffect())
void ApplyRandEff(object oPC, object oSum);

//Function apply random choice of additional feats (like feats for weapon utility)
void AddRandomFeat(object oPC, object oSum);

//This function gives additional ability progres aside from normal level progresion, this feature serves to improve role of summoned creature - dps or tank)
void AddRawAbillity(object oPC, object oSum);

//This is function which privde level progresion, it is based on spellcaster level, so conjured creatures are usefullnes on whichever lvl for players
void AddLvlProgress(object oPC, object oSum);

//this is unique function for improve progression outsiders type summon, which don't have random effects like undeads or beast. Function can make choice between six types of elemental/energy presets
void ApplyEffPreset(object oPC, object oSum);

//Random name generation function for aesthetics, not utility
string RandName();

//Function which is rensponsible for creation random choice of weapon, which this creature will used for combat
void CreateWeaponForSummon(object oPC);

//This is function to expanded in future; it is additional progress from feats - magical talent in spellschool (for example - transmutation improved animate constructs spells)
void ApplyFocusFeat(object oPC, object oSum);

///////////////////////////////////////////////////////

void GetAdvancedSummon(object oPC)
{
    int nClericDomain1 = GetDomain(oPC, 1, 2);
    int nClericDomain2 = GetDomain(oPC, 2, 2);

    if (nClericDomain1 == 1 || nClericDomain2 == 1)
        bAdvancedSummon = 1;

    if (GetLevelByClass(CLASS_TYPE_PALE_MASTER) > 5)
        bAdvancedSummon = 2;

    if (GetHasFeat(1525, oPC) || ((nClericDomain1 || nClericDomain2 == 1) && (GetLevelByClass(CLASS_TYPE_PALE_MASTER) > 5)))
        bAdvancedSummon = 3;
}

///////////////////////////////////////////////////////
void RandAppearance(object oPC, object oSum)
{
    int nSpellID = GetLocalInt(oPC, "SPELLID");
    int clvl = GetLocalInt(oPC, "CASTERLVL");
    int AppType, nRoll;

    if (GetTag(oSum) == "szc_sum001" && GetLevelByClass(CLASS_TYPE_DRUID, oPC))
    {
        switch (nSpellID)
        {
            case SPELL_SUMMON_CREATURE_I: nRoll = d10(); break;
            case SPELL_SUMMON_CREATURE_II: nRoll = d10() + 4; break;
            case SPELL_SUMMON_CREATURE_III: nRoll = d10() + 8; break;
            case SPELL_SUMMON_CREATURE_IV: nRoll = d10() + 12; break;
            case SPELL_SUMMON_CREATURE_V: nRoll = d10() + 16; break;
            case SPELL_SUMMON_CREATURE_VI: nRoll = d10() + 20; break;
            case SPELL_SUMMON_CREATURE_VII: nRoll = d10() + 24; break;
            case SPELL_SUMMON_CREATURE_VIII: nRoll = d10() + 28; break;
            case SPELL_SUMMON_CREATURE_IX: nRoll = d10() + 31; break;
        }

        // Summon I-IX natural appearances from content of appearance.2da game file
        switch (nRoll)
        {
            case 1: AppType = 1001; break; // Twig Blight
            case 2: AppType = 3134; break; // Firebat
            case 3: AppType = 202; break; // Cat-panther
            case 4: AppType = 1060; break; // Vegepygmy
            case 5: AppType = 1061; break; // Thorny
            case 6: AppType = 1055; break; // Myconid
            case 7: AppType = 1884; break; // Swine boar, razor
            case 8: AppType = 8141; break; // Giant Wasp
            case 9: AppType = 175; break; // Dog, wolf, dire
            case 10: AppType = 178; break; // Snake, cobra, black
            case 11: AppType = 1497; break; // Assassin Vine, horizon
            case 12: AppType = 1243; break; // Ant:G iant Soldier
            case 13: AppType = 8180; break; // Bear - black
            case 14: AppType = 6469; break; // Topiary guard boar
            case 15: AppType = 1333; break; // Antelope: Black*
            case 16: AppType = 1299; break; // Cat: Tiger (Storvik)
            case 17: AppType = 3908; break; // DG_Rhino_Mt
            case 18: AppType = 3300; break; // Anhkheg, medium
            case 19: AppType = 3474; break; // Slug: Large
            case 20: AppType = 1057; break; // Myconid, Elder
            case 21: AppType = 3137; break; // Elemental: Animental: Water Snake
            case 22: AppType = 3309; break; // Bear: Great Claw
            case 23: AppType = 3135; break; // Animental stone bear
            case 24: AppType = 1178; break; // Scorpion, Giant 2
            case 25: AppType = 52; break; // Elemental Base: air
            case 26: AppType = 1820; break; // Dog, Wolf, Legendary SB
            case 27: AppType = 481; break; // Bulette
            case 28: AppType = 1873; break; // Elemental: Floral
            case 29: AppType = 1378; break; //Elemental Quasi, Salt, Large
            case 30: AppType = 57; break; // Elemental Base: Earth, Elder
            case 31: AppType = 367; break; // Gorgon
            case 32: AppType = 68; break; // Elemental Base: Water, Elder
            case 33: AppType = 6298; break; // Black manticore
            case 34: AppType = 3893; break; // Shambling Mound
            case 35: AppType = 3471; break; // Shambling Mound
            case 36: AppType = 3130; break; // Elemental: air, grue
            case 37: AppType = 6437; break; // Forrestal
            case 38: AppType = 8075; break; // Elemental base: earth, elder
            case 39: AppType = 8076; break; // Elemental base: water, elder
            case 40: AppType = 61; break; // Elemental base: fire, elder
            case 41: AppType = 1492; break; // Treant 1
        }
    }
    else if (GetTag(oSum) == "szc_sum001")
    {
        switch (nSpellID)
        {
            case SPELL_SUMMON_CREATURE_I: nRoll = d6(); break;
            case SPELL_SUMMON_CREATURE_II: nRoll = d6() + 3; break;
            case SPELL_SUMMON_CREATURE_III: nRoll = d6() + 6; break;
            case SPELL_SUMMON_CREATURE_IV: nRoll = d6() + 9; break;
            case SPELL_SUMMON_CREATURE_V: nRoll = d6() + 12; break;
            case SPELL_SUMMON_CREATURE_VI: nRoll = d6() + 15; break;
            case SPELL_SUMMON_CREATURE_VII: nRoll = d6() + 18; break;
            case SPELL_SUMMON_CREATURE_VIII: nRoll = d6() + 21; break;
            case SPELL_SUMMON_CREATURE_IX: nRoll = d6() + 24; break;
        }

        switch (nRoll)
        {
            case 1: AppType = APPEARANCE_TYPE_WILL_O_WISP; break;
            case 2: AppType = 3134; break; // Firebat
            case 3: AppType = 202; break; // Cat-panther
            case 4: AppType = APPEARANCE_TYPE_BEETLE_FIRE; break;
            case 5: AppType = 870; break; // Troglodyte 3
            case 6: AppType = 1056; break; // Myconid, sprout
            case 7: AppType = 1884; break; // Swine boar, razor
            case 8: AppType = 3073; break; // Diamond raven
            case 9: AppType = 175; break; // Dog, wolf, dire
            case 10: AppType = 178; break; // Snake, cobra, black
            case 11: AppType = APPEARANCE_TYPE_SPIDER_SWORD; break;
            case 12: AppType = 2993; break; // Ettercap purple
            case 13: AppType = 8180; break; // Bear - black
            case 14: AppType = 3985; break; // Gigant rat, mechanical
            case 15: AppType = 1554; break; // Gnoll, vishtani
            case 16: AppType = 6315; break; // Scutellus
            case 17: AppType = APPEARANCE_TYPE_TROLL_CHIEFTAIN; break;
            case 18: AppType = 6311; break; // Horror, black, small
            case 19: AppType = 1911; break; // Ape carnivorus
            case 20: AppType = 6317; break; // Bug GF: squitty
            case 21: AppType = 3135; break; // Animental stone bear
            case 22: AppType = 367; break; // Gorgon
            case 23: AppType = 168; break; // Umber hulk
            case 24: AppType = 1536; break; // Basilisk abyssal
            case 25: AppType = 6298; break; // Black manticore
            case 26: AppType = 1488; break; // Golem, gem citrine 2
            case 27: AppType = 8075; break; // Elemental base: earth, elder
            case 28: AppType = 8076; break; // Elemental base: water, elder
            case 29: AppType = 3130; break; // Elemental: air, grue
            case 30: AppType = 61; break; // Elemental base: fire, elder
        }
    }
    else if (GetTag(oSum) == "szc_sum002")
    {
        switch (nSpellID)
        {
            case SPELL_ANIMATE_DEAD: nRoll = d12(); break;
            case SPELL_CREATE_UNDEAD: nRoll = d12() + 10; break;
            case SPELL_CREATE_GREATER_UNDEAD: nRoll = d12() + 21; break;
        }

        switch (nRoll)
        {
            /// Undead appearances
            case 1: AppType = 146; break; // Shadow
            case 2: AppType = 186; break; // Alip
            case 3: AppType = 88; break; // Golem: flesh
            case 4: AppType = 3955; break; // Mummy: rat
            case 5: AppType = 197; break; // Zombie: Warrior 2
            case 6: AppType = 198; break; // Zombie: Common
            case 7: AppType = 63; break; // Skeleton_Common
            case 8: AppType = 76; break; // Ghoul
            case 9: AppType = 74; break; // Ghast
            case 10: AppType = 62; break; // Skeleton: Priest
            case 11: AppType = 182; break; // Skeleton: Chieftain
            case 12: AppType = 3084; break; // Technomantic: Undead Animal B
            case 13: AppType = 199; break; // Zombie: Tyrant Fog
            case 14: AppType = 8169; break; // Dog - zombie
            case 15: AppType = 23; break; // Bodak
            case 16: AppType = 123; break; // Mohrg
            case 17: AppType = 1281; break; // Bat: battle
            case 18: AppType = 1099; break; // Visage*
            case 19: AppType = 156; break; // Spectre
            case 20: AppType = 147; break; // Shadow Fiend
            case 21: AppType = 40; break; // Doom knight
            case 22: AppType = 951; break; // Vampire: Captain, Male
            case 23: AppType = 36; break; // Intellect devourer: skeletal
            case 24: AppType = 16; break; // Curst Swordsman
            case 25: AppType = 8071; break; // Zombie_Warrior_2
            case 26: AppType = 8158; break; // Skeleton_Chieftain_RD
            case 27: AppType = 1104; break; // Belker
            case 28: AppType = 24; break; // Golem: bone
            case 29: AppType = 1572; break; // Darklord
            case 30: AppType = 1095; break; // Wraith, Hooded
            case 31: AppType = 8079; break; // Wraith 2
            case 32: AppType = 1872; break; // Elemental: death
            case 33: AppType = 1100; break; // Visage, Greater
        }
    }
    else if (GetTag(oSum) == "szc_sum003")
    {
        int nAlign = GetAlignmentGoodEvil(oPC);
        if (nAlign == ALIGNMENT_GOOD)
        {
            nRoll = Random(9) + 1;
            switch (nRoll)
            {
                case 1: AppType = 103; break; // Lantern archon
                case 2: AppType = 6422; break; // Salamander: Flame Brother
                case 3: AppType = 295; break; // Archon hound
                case 4: AppType = 293; break; // Rakshasa tiger male
                case 5: AppType = 294; break; // Bear avenger
                case 6: AppType = 3026; break; // Marut
                case 7: AppType = 904; break; // Oni guard
                case 8: AppType = 905; break; // Oni guard
                case 9: AppType = 906; break; // Oni guard
            }
        }
        else if (nAlign == ALIGNMENT_NEUTRAL)
        {
            nRoll = Random(10) + 1;
            switch (nRoll)
            {
                case 1: AppType = 106; break;
                case 2: AppType = 107; break;
                case 3: AppType = 111; break; // Mephits
                case 4: AppType = 1415; break; // Kyoht 1
                case 5: AppType = 154; break; // Slaad green 1
                case 6: AppType = 8112; break; // Bulezau
                case 7: AppType = 3367; break; // Displacer beast
                case 8: AppType = 151; break; // Slaad blue
                case 9: AppType = 3011; break; // Aoskarian Hound
                case 10: AppType = 3288; break; // Canisecta
            }
        }
        else if (nAlign == ALIGNMENT_EVIL)
        {
            nRoll = Random(11) + 1;
            switch (nRoll)
            {
                case 1: AppType = 104; break; // Quasit
                case 2: AppType = 1260; break; // Oni red
                case 3: AppType = 3871; break; // Demon: Babau
                case 4: AppType = 1731; break; // Demon: Nabassu
                case 5: AppType = 101; break; // Demon: Vrock 1
                case 6: AppType = 152; break; // slaad death
                case 7: AppType = 1501; break; // Devil: Osyluth 1 Codi
                case 8: AppType = 426; break; // Slaad: Black
                case 9: AppType = 1937; break; // Devil: Tanar'ri
                case 10: AppType = 1570; break; // Devil: Abishai Q, White
                case 11: AppType = 1434; break; // Devil: Horned
            }
        }

        float nWeaponScale = StringToFloat(Get2DAString("appearance", "WEAPONSCALE", AppType));
        if (nWeaponScale != 0.0)
        {
            SendMessageToPC(oPC, "Istota mo¿e trzymaæ broñ " + FloatToString(nWeaponScale));

            int nSelectWeapon = d4();
            int nBaseItem;
            switch (nSelectWeapon)
            {
                case 1: nBaseItem = BASE_ITEM_GREATSWORD; break;
                case 2: nBaseItem = BASE_ITEM_HEAVYFLAIL; break;
                case 3: nBaseItem = BASE_ITEM_TRIDENT; break;
                case 4: nBaseItem = BASE_ITEM_SCIMITAR; break;
            }

            SetLocalInt(oSum, "WeaponType", nBaseItem);
        }

    }

    SetCreatureAppearanceType(oSum, AppType);
}

//////////////////////////////////////////////////////////////////////////////////
effect RandEffect(object oPC, object oSum)
{
    int nSpellID = GetLocalInt(oPC, "SPELLID");
    int clvl = GetLocalInt(oPC, "CASTERLVL");

    GetAdvancedSummon(oPC);

    effect RandEff;
    int nSumType;

    switch (nSpellID)
    {
        case SPELL_SUMMON_CREATURE_I: nSumType = 1; break;
        case SPELL_SUMMON_CREATURE_II: nSumType = 1; break;
        case SPELL_SUMMON_CREATURE_III: nSumType = 1; break;
        case SPELL_SUMMON_CREATURE_IV: nSumType = 1; break;
        case SPELL_SUMMON_CREATURE_V: nSumType = 1; break;
        case SPELL_SUMMON_CREATURE_VI: nSumType = 1; break;
        case SPELL_SUMMON_CREATURE_VII: nSumType = 1; break;
        case SPELL_SUMMON_CREATURE_VIII: nSumType = 1; break;
        case SPELL_SUMMON_CREATURE_IX: nSumType = 1; break;
        case SPELL_ANIMATE_DEAD: nSumType = 2; break;
        case SPELL_CREATE_UNDEAD: nSumType = 2; break;
        case SPELL_CREATE_GREATER_UNDEAD: nSumType = 2; break;
        case SPELL_PLANAR_ALLY: nSumType = 3; break;
        case SPELL_LESSER_PLANAR_BINDING: nSumType = 3; break;
        case SPELL_PLANAR_BINDING: nSumType = 3; break;
        case SPELL_GREATER_PLANAR_BINDING: nSumType = 3; break;
        case SPELL_SHELGARNS_PERSISTENT_BLADE: nSumType = 4; break;
        case SPELL_MORDENKAINENS_SWORD: nSumType = 4; break;
    }

    if (nSumType == 1)
    {
        int nRoll = Random(46) + 1;
        switch (nRoll)
        {
            case 1: RandEff = EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 30); break;
            case 2: RandEff = EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 30); break;
            case 3: RandEff = EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING, 30); break;
            case 4: RandEff = EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID, 30); break;
            case 5: RandEff = EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, 30); break;
            case 6: RandEff = EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING, 30); break;
            case 7: RandEff = EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, 30); break;
            case 8: RandEff = EffectDamageIncrease(3, DAMAGE_TYPE_FIRE); break;
            case 9: RandEff = EffectDamageIncrease(3, DAMAGE_TYPE_ELECTRICAL); break;
            case 10: RandEff = EffectDamageIncrease(3, DAMAGE_TYPE_SONIC); break;
            case 11: RandEff = EffectDamageIncrease(3, DAMAGE_TYPE_BLUDGEONING); break;
            case 12: RandEff = EffectDamageIncrease(3, DAMAGE_TYPE_ACID); break;
            case 13: RandEff = EffectDamageIncrease(3, DAMAGE_TYPE_COLD); break;
            case 14: RandEff = EffectDamageShield(1, DAMAGE_BONUS_2d6, DAMAGE_TYPE_SLASHING); break;
            case 15: RandEff = EffectAttackIncrease(3); break;
            case 16: RandEff = EffectSpellLevelAbsorption(9, 15); break;
            case 17: RandEff = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS); break;
            case 18: RandEff = EffectImmunity(IMMUNITY_TYPE_DEATH); break;
            case 19: RandEff = EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT); break;
            case 20: RandEff = EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE); break;
            case 21: RandEff = EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK); break;
            case 22: RandEff = EffectImmunity(IMMUNITY_TYPE_FEAR); break;
            case 23: RandEff = EffectImmunity(IMMUNITY_TYPE_PARALYSIS); break;
            case 24: RandEff = EffectImmunity(IMMUNITY_TYPE_POISON); break;
            case 25: RandEff = EffectImmunity(IMMUNITY_TYPE_SLOW); break;
            case 26: RandEff = EffectImmunity(IMMUNITY_TYPE_STUN); break;
            case 27: RandEff = EffectImmunity(IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE); break;
            case 28: RandEff = EffectImmunity(IMMUNITY_TYPE_CONFUSED); break;
            case 29: RandEff = EffectImmunity(IMMUNITY_TYPE_DAZED); break;
            case 30: RandEff = EffectModifyAttacks(1); break;
            case 31: RandEff = EffectRegenerate(3, 6.0); break;
            case 32: RandEff = EffectTemporaryHitpoints(clvl * 4); break;
            case 33: RandEff = EffectDamageShield(1, DAMAGE_BONUS_2d4, DAMAGE_TYPE_FIRE); break;
            case 34: RandEff = EffectACIncrease(5, AC_DODGE_BONUS); break;
            case 35: RandEff = EffectSavingThrowIncrease(SAVING_THROW_ALL, 4); break;
            case 36: RandEff = EffectDamageReduction(10, DAMAGE_POWER_PLUS_FIVE, 0); break;
            case 37: RandEff = EffectDamageReduction(10, DAMAGE_POWER_PLUS_SIX, 150); break;
            case 38: RandEff = EffectHaste(); break;
            case 39: RandEff = EffectMovementSpeedIncrease(50); break;
            case 40: RandEff = EffectSpellResistanceIncrease(clvl + 10); break;
            case 41: RandEff = EffectDamageResistance(DAMAGE_TYPE_PIERCING, 7, 0); break;
            case 42: RandEff = EffectDamageResistance(DAMAGE_TYPE_SLASHING, 7, 0); break;
            case 43: RandEff = EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING, 7, 0); break;
            case 44: RandEff = EffectDamageResistance(DAMAGE_TYPE_NEGATIVE, 7, 0); break;
            case 45: RandEff = EffectSkillIncrease(SKILL_DISCIPLINE, 15); break;
            case 46: RandEff = EffectSkillIncrease(SKILL_ALL_SKILLS, 10); break;
        }
    }
    else if (nSumType == 2)
    {
        int nRoll = Random(26) + 1;
        switch (nRoll)
        {
            case 1: RandEff = EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 30); break;
            case 2: RandEff = EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 30); break;
            case 3: RandEff = EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING, 30); break;
            case 4: RandEff = EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID, 30); break;
            case 5: RandEff = EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, 30); break;
            case 6: RandEff = EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING, 30); break;
            case 7: RandEff = EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, 30); break;
            case 8: RandEff = EffectDamageReduction(10, DAMAGE_POWER_PLUS_SIX, 150); break;
            case 9: RandEff = EffectDamageReduction(10, DAMAGE_POWER_PLUS_FIVE, 0); break;
            case 10: RandEff = EffectDamageResistance(DAMAGE_TYPE_PIERCING, 10, 0); break;
            case 11: RandEff = EffectDamageResistance(DAMAGE_TYPE_SLASHING, 10, 0); break;
            case 12: RandEff = EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING, 10, 0); break;
            case 13: RandEff = EffectDamageIncrease(5, DAMAGE_TYPE_NEGATIVE); break;
            case 14: RandEff = EffectACIncrease(3, AC_DODGE_BONUS); break;
            case 15: RandEff = EffectACIncrease(3, AC_SHIELD_ENCHANTMENT_BONUS); break;
            case 16: RandEff = EffectACIncrease(3, AC_NATURAL_BONUS); break;
            case 17: RandEff = EffectACIncrease(3, AC_ARMOUR_ENCHANTMENT_BONUS); break;
            case 18: RandEff = EffectACIncrease(3, AC_DEFLECTION_BONUS); break;
            case 19: RandEff = EffectSpellResistanceIncrease(clvl + 10); break;
            case 20: RandEff = EffectHaste(); break;
            case 21: RandEff = EffectSavingThrowIncrease(SAVING_THROW_ALL, 4); break;
            case 22: RandEff = EffectRegenerate(3, 6.0); break;
            case 23: RandEff = EffectDamageShield(1, DAMAGE_BONUS_2d6, DAMAGE_TYPE_SLASHING); break;
            case 24: RandEff = EffectTemporaryHitpoints(clvl * 4); break;
            case 25: RandEff = EffectSpellLevelAbsorption(9, 15); break;
            case 26: RandEff = EffectSkillIncrease(SKILL_ALL_SKILLS, 10); break;
        }
    }

    return RandEff;
}

/////////////////////////////////////////////////////////////////////////////////
void ApplyRandEff(object oPC, object oSum)
{
    int nSpellID = GetLocalInt(oPC, "SPELLID");
    int clvl = GetLocalInt(oPC, "CASTERLVL");
    GetAdvancedSummon(oPC);
    effect RandEff;

    int iter;
    // Summon I_IX
    if (GetTag(oSum) == "szc_sum001")
    {
        if (bAdvancedSummon == 1 || bAdvancedSummon == 3)
        {
            if (clvl >= 30)
                iter = 8;
            else if (clvl >= 25)
                iter = 7;
            else if (clvl >= 20)
                iter = 6;
            else if (clvl >= 15)
                iter = 5;
            else if (clvl >= 10)
                iter = 4;
            else if (clvl >= 5)
                iter = 3;
            else if (clvl >= 1)
                iter = 2;
        }
        else
        {
            if (clvl >= 25)
                iter = 6;
            else if (clvl >= 20)
                iter = 5;
            else if (clvl >= 15)
                iter = 4;
            else if (clvl >= 10)
                iter = 3;
            else if (clvl >= 5)
                iter = 2;
            else if (clvl >= 1)
                iter = 1;
        }
        int i;
        for (i = 0; i < iter; i++)
        {
            RandEff = RandEffect(oPC, oSum);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, RandEff, oSum);
        }
    }

    // Summon Undead
    if (GetTag(oSum) == "szc_sum002")
    {
        if (bAdvancedSummon == 2 || bAdvancedSummon == 3)
        {
            if (clvl >= 25)
                iter = 5;
            else if (clvl >= 20)
                iter = 4;
            else if (clvl >= 15)
                iter = 3;
            else if (clvl >= 10)
                iter = 2;
        }
        else
        {
            if (clvl >= 20)
                iter = 4;
            else if (clvl >= 15)
                iter = 3;
            else if (clvl >= 10)
                iter = 2;
        }

        int i;
        for (i = 0; i < iter; i++)
        {
            RandEff = RandEffect(oPC, oSum);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, RandEff, oSum);
        }

    }

    // Summon Outsider
    if (GetTag(oSum) == "szc_sum003")
    {
        if (bAdvancedSummon == 3)
        {
            effect eAdvanced1 = EffectDamageResistance(DAMAGE_TYPE_PIERCING, 10, 0);
            effect eAdvanced2 = EffectDamageResistance(DAMAGE_TYPE_SLASHING, 10, 0);
            effect eAdvanced3 = EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING, 10, 0);
            effect eLink = EffectLinkEffects(eAdvanced1, eAdvanced2);
            eLink = EffectLinkEffects(eLink, eAdvanced3);

            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oSum);
        }
    }

    // Summon Construct/animate weapon
    if (GetTag(oSum) == "szc_sum004")
    {
        if (bAdvancedSummon == 3)
        {
            int nAmount = 10 + clvl;
            effect eAdvanced1 = EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING, nAmount);
            effect eAdvanced2 = EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING, nAmount);
            effect eAdvanced3 = EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, nAmount);
            effect eLink = EffectLinkEffects(eAdvanced1, eAdvanced2);
            eLink = EffectLinkEffects(eLink, eAdvanced3);

            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oSum);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////
void AddLvlProgress(object oPC, object oSum)
{
    int nSpellID = GetLocalInt(oPC, "SPELLID");
    int clvl = GetLocalInt(oPC, "CASTERLVL");

    GetAdvancedSummon(oPC);

    int currentlvl = clvl;
    int maxlvl;
    switch (nSpellID)
    {
        case SPELL_SUMMON_CREATURE_I: maxlvl = 5; break;
        case SPELL_SUMMON_CREATURE_II: maxlvl = 8; break;
        case SPELL_SUMMON_CREATURE_III: maxlvl = 10; break;
        case SPELL_SUMMON_CREATURE_IV: maxlvl = 13; break;
        case SPELL_SUMMON_CREATURE_V: maxlvl = 16; break;
        case SPELL_SUMMON_CREATURE_VI: maxlvl = 20; break;
        case SPELL_SUMMON_CREATURE_VII: maxlvl = 23; break;
        case SPELL_SUMMON_CREATURE_VIII: maxlvl = 25; break;
        case SPELL_SUMMON_CREATURE_IX: maxlvl = 28; break;
        case SPELL_ANIMATE_DEAD: maxlvl = 15; break;
        case SPELL_CREATE_UNDEAD: maxlvl = 20; break;
        case SPELL_CREATE_GREATER_UNDEAD: maxlvl = 28; break;
        case SPELL_LESSER_PLANAR_BINDING: maxlvl = 20; break;
        case SPELL_PLANAR_BINDING: maxlvl = 25; break;
        case SPELL_PLANAR_ALLY: maxlvl = 25; break;
        case SPELL_GREATER_PLANAR_BINDING: maxlvl = 28; break;
        case SPELL_SHELGARNS_PERSISTENT_BLADE: maxlvl = 15; break;
        case SPELL_MORDENKAINENS_SWORD: maxlvl = 28; break;
    }

    if (currentlvl > maxlvl)
        currentlvl = maxlvl;

    if (GetTag(oSum) == "szc_sum001")
    {
        if (bAdvancedSummon == 1 || bAdvancedSummon == 3)
            NWNX_Creature_LevelUp(oSum, CLASS_TYPE_MAGICAL_BEAST, currentlvl - 1);//this is class with higher base attack bonus
        else
            NWNX_Creature_LevelUp(oSum, CLASS_TYPE_BEAST, (currentlvl - 1));
    }

    if (GetTag(oSum) == "szc_sum002")
    {
        if (bAdvancedSummon == 2 || bAdvancedSummon == 3)
            NWNX_Creature_LevelUp(oSum, CLASS_TYPE_MONSTROUS, currentlvl - 1); //this is class with higher base attack bonus
        else
            NWNX_Creature_LevelUp(oSum, CLASS_TYPE_UNDEAD, (currentlvl - 1));

        NWNX_Creature_SetBaseAC(oSum, clvl);
    }
    if (GetTag(oSum) == "szc_sum003")
    {
        NWNX_Creature_LevelUp(oSum, CLASS_TYPE_OUTSIDER, (currentlvl - 1));
    }
    if (GetTag(oSum) == "szc_sum004")
    {
        NWNX_Creature_LevelUp(oSum, CLASS_TYPE_CONSTRUCT, (currentlvl - 1));
    }
}

/////////////////////////////////////////////////////////////////////////////////
void AddRandomFeat(object oPC, object oSum)
{
    int nSpellID = GetLocalInt(oPC, "SPELLID");
    int clvl = GetLocalInt(oPC, "CASTERLVL");

    GetAdvancedSummon(oPC);

    int nFeat;
    int nBaseItem = GetLocalInt(oSum, "WeaponType");

    int iter;

    if (bAdvancedSummon > 0)
    {
        if (clvl >= 25)
            iter = 3;
        else if (clvl >= 20)
            iter = 2;
        else if (clvl >= 10)
            iter = 1;
    }
    else
    {
        if (clvl >= 20)
            iter = 2;
        else if (clvl >= 10)
            iter = 1;
    }

    int i;
    int nRoll;
    for (i = 0; i < iter; i++)
    {
        nRoll = d8();
        // Unarmed
        if ((GetTag(oSum) == "szc_sum001" || GetTag(oSum) == "szc_sum002" || GetTag(oSum) == "szc_sum003") && (nBaseItem == 0))
        {
            switch (nRoll)
            {
                case 1: nFeat = 62; break; // Impr crit unarm
                case 2: nFeat = 290; break; // Weapon spec Creature
                case 3: nFeat = FEAT_EPIC_ARMOR_SKIN; break;//natural armor class bonus
                case 4: nFeat = 333; break; // Damage red 3
                case 5: nFeat = 221; break; // Sneak attack
                case 6: nFeat = 656; break; // Epic weapon focus creature
                case 7: nFeat = 291; break; // Weapon focus Creature
                case 8: nFeat = 408; break; // Blindfight
            }
        }
        else if ((GetTag(oSum) == "szc_sum003") && nBaseItem > 0)
        {
            int number = d4();
            if (nBaseItem == BASE_ITEM_GREATSWORD)
            {
                switch (number)
                {
                    case 1: nFeat = FEAT_WEAPON_FOCUS_GREAT_SWORD; break;
                    case 2: nFeat = FEAT_EPIC_WEAPON_FOCUS_GREATSWORD; break;
                    case 3: nFeat = FEAT_IMPROVED_CRITICAL_GREAT_SWORD; break;
                    case 4: nFeat = FEAT_WEAPON_SPECIALIZATION_GREAT_SWORD; break;
                }
            }

            if (nBaseItem == BASE_ITEM_HEAVYFLAIL)
            {
                switch (number)
                {
                    case 1: nFeat = FEAT_WEAPON_FOCUS_HEAVY_FLAIL; break;
                    case 2: nFeat = FEAT_EPIC_WEAPON_FOCUS_HEAVYFLAIL; break;
                    case 3: nFeat = FEAT_IMPROVED_CRITICAL_HEAVY_FLAIL; break;
                    case 4: nFeat = FEAT_WEAPON_SPECIALIZATION_HEAVY_FLAIL; break;
                }
            }

            if (nBaseItem == BASE_ITEM_TRIDENT)
            {
                switch (number)
                {
                    case 1: nFeat = FEAT_WEAPON_FOCUS_TRIDENT; break;
                    case 2: nFeat = FEAT_EPIC_WEAPON_FOCUS_TRIDENT; break;
                    case 3: nFeat = FEAT_IMPROVED_CRITICAL_TRIDENT; break;
                    case 4: nFeat = FEAT_WEAPON_SPECIALIZATION_TRIDENT; break;
                }
            }

            if (nBaseItem == BASE_ITEM_SCIMITAR)
            {
                switch (number)
                {
                    case 1: nFeat = FEAT_WEAPON_FOCUS_SCIMITAR; break;
                    case 2: nFeat = FEAT_EPIC_WEAPON_FOCUS_SCIMITAR; break;
                    case 3: nFeat = FEAT_IMPROVED_CRITICAL_SCIMITAR; break;
                    case 4: nFeat = FEAT_WEAPON_SPECIALIZATION_SCIMITAR; break;
                }
            }
        }
        else if (GetTag(oSum) == "szc_sum004")
        {
          int number = d4();
          if (nSpellID == SPELL_SHELGARNS_PERSISTENT_BLADE)
            {
                switch (number)
                {
                    case 1: nFeat = FEAT_WEAPON_FOCUS_DAGGER; break;
                    case 2: nFeat = FEAT_EPIC_WEAPON_FOCUS_DAGGER; break;
                    case 3: nFeat = FEAT_IMPROVED_CRITICAL_DAGGER; break;
                    case 4: nFeat = FEAT_WEAPON_SPECIALIZATION_DAGGER; break;
                }
            }
           if (nSpellID == SPELL_MORDENKAINENS_SWORD)
           {
                switch (number)
                {
                    case 1: nFeat = FEAT_WEAPON_FOCUS_LONG_SWORD; break;
                    case 2: nFeat = FEAT_EPIC_WEAPON_FOCUS_LONGSWORD; break;
                    case 3: nFeat = FEAT_IMPROVED_CRITICAL_LONG_SWORD; break;
                    case 4: nFeat = FEAT_WEAPON_SPECIALIZATION_LONG_SWORD; break;
                }
            }
        }

        NWNX_Creature_AddFeat(oSum, nFeat);
    }

    NWNX_Creature_RemoveFeat(oSum, FEAT_POWER_ATTACK);
    NWNX_Creature_RemoveFeat(oSum, FEAT_KNOCKDOWN);
    NWNX_Creature_RemoveFeat(oSum, FEAT_IMPROVED_POWER_ATTACK);
}

////////////////////////////////////////////////////////////////////////////////
void AddRawAbility(object oPC, object oSum)
{
    int nSpellID = GetLocalInt(oPC, "SPELLID");
    int clvl = GetLocalInt(oPC, "CASTERLVL");

    GetAdvancedSummon(oPC);

    int nPreSTR = NWNX_Creature_GetRawAbilityScore(oSum, ABILITY_STRENGTH);
    int nPreDEX = NWNX_Creature_GetRawAbilityScore(oSum, ABILITY_DEXTERITY);
    int nPreCON = NWNX_Creature_GetRawAbilityScore(oSum, ABILITY_CONSTITUTION);

    if (GetTag(oSum) == "szc_sum001")
    {
        NWNX_Creature_SetRawAbilityScore(oSum, ABILITY_STRENGTH, (nPreSTR + clvl / 5));
        NWNX_Creature_SetRawAbilityScore(oSum, ABILITY_DEXTERITY, (nPreDEX + clvl / 2));
        NWNX_Creature_SetRawAbilityScore(oSum, ABILITY_CONSTITUTION, (nPreCON + clvl / 4));
    }

    if (GetTag(oSum) == "szc_sum002")
    {
        NWNX_Creature_SetRawAbilityScore(oSum, ABILITY_STRENGTH, (nPreSTR + clvl / 5));
        NWNX_Creature_SetRawAbilityScore(oSum, ABILITY_DEXTERITY, (nPreDEX + clvl / 6));
        NWNX_Creature_SetRawAbilityScore(oSum, ABILITY_CONSTITUTION, (nPreCON + clvl / 8));
    }
     if (GetTag(oSum) == "szc_sum003")
    {
        NWNX_Creature_SetRawAbilityScore(oSum, ABILITY_STRENGTH, (nPreSTR + clvl / 4));
        NWNX_Creature_SetRawAbilityScore(oSum, ABILITY_DEXTERITY, (nPreDEX + clvl / 2));
        NWNX_Creature_SetRawAbilityScore(oSum, ABILITY_CONSTITUTION, (nPreCON + clvl / 5));
    }
     if (GetTag(oSum) == "szc_sum004")
    {
        NWNX_Creature_SetRawAbilityScore(oSum, ABILITY_STRENGTH, (nPreSTR + clvl / 2));
        NWNX_Creature_SetRawAbilityScore(oSum, ABILITY_DEXTERITY, (nPreDEX + clvl / 5));
        NWNX_Creature_SetRawAbilityScore(oSum, ABILITY_CONSTITUTION, (nPreCON + clvl / 8));
    }
}

/////////////////////////////////////////////////////////////////////////////////////
void ApplyEffPreset(object oPC, object oSum)
{
    int nSpellID = GetLocalInt(oPC, "SPELLID");
    int clvl = GetLocalInt(oPC, "CASTERLVL");
    string sName, sSubtype;
    int nDamageType, nDmg, nAuraID;
    int maxlvl = 30;
    int currentlvl = clvl;
    if (currentlvl > maxlvl)
        currentlvl = maxlvl;

    switch (currentlvl)
    {
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
            nDmg = DAMAGE_BONUS_1d6;
        break;
        case 6:
        case 7:
        case 8:
        case 9:
        case 10:
            nDmg = DAMAGE_BONUS_2d4;
        break;
        case 11:
        case 12:
        case 13:
        case 14:
        case 15:
            nDmg = DAMAGE_BONUS_10;
        break;
        case 16:
        case 17:
        case 18:
        case 19:
        case 20:
            nDmg = DAMAGE_BONUS_2d8;
        break;
        case 21:
        case 22:
        case 23:
        case 24:
        case 25:
            nDmg = DAMAGE_BONUS_2d10;
        break;
        case 26:
        case 27:
        case 28:
        case 29:
        case 30:
            nDmg = DAMAGE_BONUS_2d12;
        break;
    }

    int nAlign = GetAlignmentGoodEvil(oPC);

    int nSubtype = Random(5);
    // Fire
    if (nSubtype == 0)
    {
        nDamageType = DAMAGE_TYPE_FIRE;
        sSubtype = "P³omieni";
        nAuraID =  SPELLABILITY_AURA_FIRE;
    }

    // Cold
    if (nSubtype == 1)
    {
        nDamageType = DAMAGE_TYPE_COLD;
        sSubtype = "Mrozu";
        nAuraID =  SPELLABILITY_AURA_COLD;
    }

    // Acid
    if (nSubtype == 2)
    {
        nDamageType = DAMAGE_TYPE_ACID;
        sSubtype = "Jadu";
        nAuraID = SPELLABILITY_AURA_MENACE;
    }

    // Air
    if (nSubtype == 3)
    {
        nDamageType = DAMAGE_TYPE_ELECTRICAL;
        sSubtype = "Niebosk³onu";
        nAuraID =  SPELLABILITY_AURA_ELECTRICITY;
    }

    // Dark or light
    if (nSubtype == 4)
    {
        int nRoll = d2();
        if ((nAlign == ALIGNMENT_EVIL) || (nAlign == ALIGNMENT_NEUTRAL && nRoll == 1)) {
            nDamageType = DAMAGE_TYPE_NEGATIVE;
            sSubtype = "Ciemnoœci";
            nAuraID =  SPELLABILITY_AURA_BLINDING;
        }
        else if ((nAlign == ALIGNMENT_GOOD) || (nAlign == ALIGNMENT_NEUTRAL && nRoll == 2))
        {
            nDamageType = DAMAGE_TYPE_POSITIVE;
            sSubtype = "Blasku";
            nAuraID =  SPELLABILITY_AURA_PROTECTION;
        }
    }

    AssignCommand(oSum, ActionCastSpellAtObject(nAuraID, oSum, METAMAGIC_NONE, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, FALSE));
    effect eElem1 = EffectDamageIncrease(nDmg, nDamageType);
    effect eElem2 = EffectDamageImmunityIncrease(nDamageType, 50);
    effect eElem3 = EffectDamageShield((clvl / 4), DAMAGE_BONUS_2d4, nDamageType);
    effect eLink = EffectLinkEffects(eElem1, eElem2);
    eLink = EffectLinkEffects(eLink, eElem3);

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oSum);

    SetLocalString(oSum, "SubType", sSubtype);

    string sTitle;
    sName = RandName() + " " + sSubtype;
    SetName(oSum, sName);
}

//////////////////////////////////////////////////////////////////////////////////
string RandName()
{
    int number = d10();
    string sName, sTitle, sPrefix, sSufix, sMiddle1, sMiddle2;
    int nlength = d4();
    // Prefix
    switch (number)
    {
        case 1: sPrefix = "Sam"; break;
        case 2: sPrefix = "Kai"; break;
        case 3: sPrefix = "Hul"; break;
        case 4: sPrefix = "Bau"; break;
        case 5: sPrefix = "Cym"; break;
        case 6: sPrefix = "Ged"; break;
        case 7: sPrefix = "Lup"; break;
        case 8: sPrefix = "Slav"; break;
        case 9: sPrefix = "Biez"; break;
        case 10: sPrefix = "Dyl"; break;
    }

    // Sufix
    number = d10();
    switch (number)
    {
        case 1: sSufix = "bor"; break;
        case 2: sSufix = "trach"; break;
        case 3: sSufix = "nol"; break;
        case 4: sSufix = "ger"; break;
        case 5: sSufix = "dach"; break;
        case 6: sSufix = "not"; break;
        case 7: sSufix = "tor"; break;
        case 8: sSufix = "nor"; break;
        case 9: sSufix = "boj"; break;
        case 10: sSufix = "ran"; break;
    }

    // Middle1
    number = d10();
    switch (number)
    {
        case 1: sMiddle1 = "ba"; break;
        case 2: sMiddle1 = "och"; break;
        case 3: sMiddle1 = "at"; break;
        case 4: sMiddle1 = "da"; break;
        case 5: sMiddle1 = "po"; break;
        case 6: sMiddle1 = "ni"; break;
        case 7: sMiddle1 = "ke"; break;
        case 8: sMiddle1 = "ru"; break;
        case 9: sMiddle1 = "to"; break;
        case 10: sMiddle1 = "ga"; break;
    }

    number = d10();
    // Middle2
    switch (number)
    {
        case 1: sMiddle2 = "ba"; break;
        case 2: sMiddle2 = "och"; break;
        case 3: sMiddle2 = "ad"; break;
        case 4: sMiddle2 = "da"; break;
        case 5: sMiddle2 = "po"; break;
        case 6: sMiddle2 = "ni"; break;
        case 7: sMiddle2 = "ke"; break;
        case 8: sMiddle2 = "ru"; break;
        case 9: sMiddle2 = "to"; break;
        case 10: sMiddle2 = "ga"; break;
    }

    number = d8();
    // Title
    switch (number)
    {
        case 1: sTitle = "W³adca"; break;
        case 2: sTitle = "Archont"; break;
        case 3: sTitle = "Suweren"; break;
        case 4: sTitle = "Hegemon"; break;
        case 5: sTitle = "W³odarz"; break;
        case 6: sTitle = "KniaŸ"; break;
        case 7: sTitle = "Piewca"; break;
        case 8: sTitle = "Herold"; break;
    }

    if (nlength > 3)
        sName = sPrefix + sMiddle1 + sMiddle2 + sSufix;
    else if (nlength > 2)
        sName = sPrefix + sMiddle1 + sSufix;
    else if (nlength >= 1)
        sName = sPrefix + sSufix;

    sName = sName + " " + sTitle;

    return sName;
}

///////////////////////////////////////////////////////////////////////////////
void CreateWeaponForSummon(object oPC)
{
    object oSum = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC);
    int nSpellID = GetLocalInt(oPC, "SPELLID");
    int clvl = GetLocalInt(oPC, "CASTERLVL");

    int nBaseItem = GetLocalInt(oSum, "WeaponType");
    string sSubtype = GetLocalString(oSum, "SubType");

    int nVisual;
    string sWeaponTag;
    if ((GetTag(oSum) == "szc_sum003") && nBaseItem > 0)
    {
        switch (nBaseItem)
        {
            case BASE_ITEM_GREATSWORD: sWeaponTag = "NW_WSWGS001"; break;
            case BASE_ITEM_HEAVYFLAIL: sWeaponTag = "NW_WBLFH001"; break;
            case BASE_ITEM_TRIDENT: sWeaponTag = "nw_wpltr001"; break;
            case BASE_ITEM_SCIMITAR: sWeaponTag = "NW_WSWSC001"; break;
        }

    if (sSubtype == "P³omieni")
        nVisual = ITEM_VISUAL_FIRE;
    if (sSubtype == "Niebosk³onu")
        nVisual = ITEM_VISUAL_ELECTRICAL;
    if (sSubtype == "Jadu")
        nVisual = ITEM_VISUAL_ACID;
    if (sSubtype == "Ciemnoœci")
        nVisual = ITEM_VISUAL_EVIL;
    if (sSubtype == "Blasku")
        nVisual = ITEM_VISUAL_HOLY;
    if (sSubtype == "Mrozu")
        nVisual = ITEM_VISUAL_COLD;
    }
    else if(GetTag(oSum) == "szc_sum004")
    {
        if (nSpellID == SPELL_SHELGARNS_PERSISTENT_BLADE)
            sWeaponTag = "NW_WSWDG001";

        if (nSpellID == SPELL_MORDENKAINENS_SWORD)
            sWeaponTag  = "NW_WSWLS001";
     }
    object oWeapon = CreateItemOnObject(sWeaponTag, oSum);

    if (GetIsObjectValid(oSum))
    {
        // Fix for weapon being dropped when killed
        SetDroppableFlag(oWeapon, FALSE);
        if((GetTag(oSum) == "szc_sum003") && nBaseItem > 0)
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyVisualEffect(nVisual), oWeapon);
        SendMessageToPC(oPC, "Utworzono broñ dla przywo³anej istoty.");

        object oCreWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oSum);
        if(GetIsObjectValid(oCreWeapon))
            DestroyObject(oCreWeapon);

        AssignCommand(oSum, ActionEquipItem(oWeapon, INVENTORY_SLOT_RIGHTHAND));
    }
}

/////////////////////////////////////////////////////////////////////////////
void ApplyFocusFeat(object oPC, object oSum)
{
    int nSpellID = GetLocalInt(oPC, "SPELLID");
    int clvl = GetLocalInt(oPC, "CASTERLVL");

    int nAttack, nCon;

    int nSumType;

    switch (nSpellID)
    {
        case SPELL_SUMMON_CREATURE_I: nSumType = 1; break;
        case SPELL_SUMMON_CREATURE_II: nSumType = 1; break;
        case SPELL_SUMMON_CREATURE_III: nSumType = 1; break;
        case SPELL_SUMMON_CREATURE_IV: nSumType = 1; break;
        case SPELL_SUMMON_CREATURE_V: nSumType = 1; break;
        case SPELL_SUMMON_CREATURE_VI: nSumType = 1; break;
        case SPELL_SUMMON_CREATURE_VII: nSumType = 1; break;
        case SPELL_SUMMON_CREATURE_VIII: nSumType = 1; break;
        case SPELL_SUMMON_CREATURE_IX: nSumType = 1; break;
        case SPELL_ANIMATE_DEAD: nSumType = 2; break;
        case SPELL_CREATE_UNDEAD: nSumType = 2; break;
        case SPELL_CREATE_GREATER_UNDEAD: nSumType = 2; break;
        case SPELL_PLANAR_ALLY: nSumType = 3; break;
        case SPELL_LESSER_PLANAR_BINDING: nSumType = 3; break;
        case SPELL_PLANAR_BINDING: nSumType = 3; break;
        case SPELL_GREATER_PLANAR_BINDING: nSumType = 3; break;
        case SPELL_SHELGARNS_PERSISTENT_BLADE: nSumType = 4; break;
        case SPELL_MORDENKAINENS_SWORD: nSumType = 4; break;
    }


    if (nSumType == 4 && GetHasFeat(FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION, oPC))
    {
        nAttack = 6;
        nCon = 6;
    }
    else if (nSumType == 4 && GetHasFeat(FEAT_GREATER_SPELL_FOCUS_TRANSMUTATION, oPC))
    {
        nAttack = 4;
        nCon = 4;
    }
    else if (nSumType == 4 &&GetHasFeat(FEAT_SPELL_FOCUS_TRANSMUTATION, oPC))
    {
        nAttack = 2;
        nCon = 2;
    }

    effect eAttack = EffectAttackIncrease(nAttack);
    effect eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION, nCon);
    effect eLink = EffectLinkEffects(eAttack, eCon);

    eLink = SupernaturalEffect(eLink);

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oSum);
}
