float QETWEAK_AXE_100_DAMAGE  = 1;
float QETWEAK_MAP_START_OPEN  = 2;
float QETWEAK_MAP_DM1_UPGRADE = 4;

string QETWEAK_S_AXE_100_DAMAGE  = "1: Axe does 100 damage\n";
string QETWEAK_S_MAP_START_OPEN  = "2: start map stairs open\n";
string QETWEAK_S_MAP_DM1_UPGRADE = "4: dm1 map weapons upgraded\n";

float() GetQETweaks = {
    return cvar("saved2");
}

void() QETweaksWelcome = {
    centerprint(self,
        "Welcome to QETweaks\n"
        "\n"
        "Any bugs are probably related to the mod\n"
        "Tweaks server value: ",ftos(GetQETweaks()),"\n"
        "\n"
        "Have fun!");

    if ((GetQETweaks() & QETWEAK_AXE_100_DAMAGE))
    {
        sprint(self, QETWEAK_S_AXE_100_DAMAGE);
    }
    if ((GetQETweaks() & QETWEAK_MAP_START_OPEN))
    {
        sprint(self, QETWEAK_S_MAP_START_OPEN);
    }
    if ((GetQETweaks() & QETWEAK_MAP_DM1_UPGRADE))
    {
        sprint(self, QETWEAK_S_MAP_DM1_UPGRADE);
    }
}
