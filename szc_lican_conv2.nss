void main()
{
    object oPC = GetPCSpeaker();

    SetLocalInt(oPC, "LicanSTR", 1);
    SetLocalInt(oPC, "LicanDEX", 0);

    SendMessageToPC(oPC, "This is strong werewolf");
}
