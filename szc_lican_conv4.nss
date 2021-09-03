void main()
{
    object oPC = GetPCSpeaker();

    SetLocalInt(oPC, "LicanGrey", 1);
    SetLocalInt(oPC, "LicanBLACK", 0);

    SendMessageToPC(oPC,"This is grey werewolf appearance");

    if(GetLocalInt(oPC, "LicanSTR") == 1 && GetLocalInt(oPC, "LicanGrey") == 1)
        SetCampaignInt("bs_lican", "isLican", 4, oPC);

    if(GetLocalInt(oPC, "LicanDEX") == 1 && GetLocalInt(oPC, "LicanGrey") == 1)
        SetCampaignInt("bs_lican", "isLican", 5, oPC);
}
