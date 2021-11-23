// The variable we use to hold tweak-enabling flags
float qetweaks;

// Initialize from "saved1" CVAR
void() QETweaksInit = {
    qetweaks = cvar("saved1");
}

// 1 of 3: Add flag definition
float QETWEAK_AXE_100_DAMAGE  = 1;
float QETWEAK_MAP_START_OPEN  = 2;
float QETWEAK_MAP_DM1_UPGRADE = 4;
float QETWEAK_DOUBLE_JUMP     = 8;
float QETWEAK_GRAPPLING_HOOK  = 16;

// 2 of 3: Add string description
string QETWEAK_S_AXE_100_DAMAGE  = "1: Axe does 100 damage\n";
string QETWEAK_S_MAP_START_OPEN  = "2: start map stairs open\n";
string QETWEAK_S_MAP_DM1_UPGRADE = "4: dm1 map weapons upgraded\n";
string QETWEAK_S_DOUBLE_JUMP     = "8: Double-jump\n";
string QETWEAK_S_GRAPPLING_HOOK  = "16: Grappling hook\n";

// 3 of 3: Add to welcome message
void() QETweaksWelcome = {
    centerprint(self,
        "Welcome to QETweaks\n"
        "\n"
        "Any bugs are probably related to the mod\n"
        "Tweaks server value: ",ftos(qetweaks),"\n"
        "\n"
        "Have fun!");

    if (qetweaks & QETWEAK_AXE_100_DAMAGE)
    {
        sprint(self, QETWEAK_S_AXE_100_DAMAGE);
    }
    if (qetweaks & QETWEAK_MAP_START_OPEN)
    {
        sprint(self, QETWEAK_S_MAP_START_OPEN);
    }
    if (qetweaks & QETWEAK_MAP_DM1_UPGRADE)
    {
        sprint(self, QETWEAK_S_MAP_DM1_UPGRADE);
    }
    if (qetweaks & QETWEAK_DOUBLE_JUMP)
    {
        sprint(self, QETWEAK_S_DOUBLE_JUMP);
    }
    if (qetweaks & QETWEAK_GRAPPLING_HOOK)
    {
        sprint(self, QETWEAK_S_GRAPPLING_HOOK);
    }
}
