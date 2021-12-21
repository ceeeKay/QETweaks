// The variable we use to hold tweak-enabling flags
float qetweaks;

// 1 of 3: Add flag definition
float QETWEAK_AXE_100_DAMAGE  = 1;
float QETWEAK_MAP_START_OPEN  = 2;
float QETWEAK_MAP_DM1_UPGRADE = 4;
float QETWEAK_DOUBLE_JUMP     = 8;
float QETWEAK_GRAPPLING_HOOK  = 16;
float QETWEAK_GAME_TIMER      = 32;

// 2 of 3: Add string description
string QETWEAK_S_AXE_100_DAMAGE  = "1: Axe does 100 damage\n";
string QETWEAK_S_MAP_START_OPEN  = "2: start map stairs open\n";
string QETWEAK_S_MAP_DM1_UPGRADE = "4: dm1 map weapons upgraded\n";
string QETWEAK_S_DOUBLE_JUMP     = "8: Double-jump\n";
string QETWEAK_S_GRAPPLING_HOOK  = "16: Grappling hook\n";
string QETWEAK_S_GAME_TIMER      = "32: Game timer abd ammo counts\n";

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
    if (qetweaks & QETWEAK_GAME_TIMER)
    {
        sprint(self, QETWEAK_S_GAME_TIMER);
    }
}

// For QETWEAK_GAME_TIMER
float qetweaks_game_timer_last_tick;

// Initialization
void() QETweaksInit = {

    // Initialize from "saved1" CVAR
    qetweaks = cvar("saved1");

    if (qetweaks & QETWEAK_GAME_TIMER)
    {
        qetweaks_game_timer_last_tick = 0;
    }
}

// Run function for game timer
void QETweaksGameTimerRun(entity client) =
{
    // Let the welcome message print
	if (time < 5)
		return;

    // Get current time as a whole (truncated) number
    local float cur_time = floor(time);

	// Only update once per second
	if (cur_time <= (qetweaks_game_timer_last_tick))
	{
        return;
    }

    // Store last tick
    qetweaks_game_timer_last_tick = cur_time;

    // Calculate time values for display
    local float cur_sec = cur_time % 60;
    local float cur_min = floor(cur_time / 60);

	// centerprint can do 7 strings, 40 lines, 50 characters wide

    msg_entity = client;
    WriteByte (MSG_ONE, SVC_CENTERPRINT);

    // 1 base(?) + 1 format string + 7 format parameters
    WriteShort (MSG_ONE, 9); // QE reserved

    // Print 16 newlines to push "hud" to bottom of screen
    local float i;
    for(i = 0; i < 16; i = i + 1)
    {
        WriteByte (MSG_ONE, '\n');
    }

    // Write format string
    WriteString(MSG_ONE, "{}:{}{}  s {}   n {}   r {}   c {}\n");

    WriteString(MSG_ONE, ftos(cur_min));
    if (cur_sec < 10)
    {
        // Leading zero on seconds
        WriteString(MSG_ONE, "0");
    }
    else
    {
        WriteString(MSG_ONE, "");
    }
    WriteString(MSG_ONE, ftos(cur_sec));

    WriteString(MSG_ONE, ftos(client.ammo_shells));
    WriteString(MSG_ONE, ftos(client.ammo_nails));
    WriteString(MSG_ONE, ftos(client.ammo_rockets));
    WriteString(MSG_ONE, ftos(client.ammo_cells));

    // Everything after the format string parameters gets eaten

    WriteByte (MSG_ONE, 0);
}
