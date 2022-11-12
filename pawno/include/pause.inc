/**
* Pause (v1.1)
*
* Check for players pause/AFK status.
*
* Thread: https://forum.sa-mp.com/showthread.php?t=659604
*
* Defines: PAUSE_LIMIT (3)
* Events: OnPlayerPause(playerid),
*         OnPlayerResume(playerid, duration)
*
* by Amir Savand
*/

// Defines

#if !defined PAUSE_LIMIT
    #define  PAUSE_LIMIT (3)
#endif

// Includes

#include <YSI\y_hooks>

// Variables

new static lastPlayerUpdate[MAX_PLAYERS];
new static bool:isPlayerPaused[MAX_PLAYERS];
new static playerTimer[MAX_PLAYERS];

// Functions

stock bool:IsPlayerPaused(playerid)
{
    // Check player and pause status
    return IsPlayerConnected(playerid) && isPlayerPaused[playerid];
}

// Hooks

hook OnPlayerConnect(playerid)
{
    // Reset player var
    lastPlayerUpdate[playerid] = gettime();

    // Setup player timer
    playerTimer[playerid] = SetTimerEx("CheckPlayerPause", 1000, 1, "i", playerid);
}

hook OnPlayerDisconnect(playerid, reason)
{
    // Reset timer
    KillTimer(playerTimer[playerid]);
}

hook OnPlayerUpdate(playerid)
{
    // Player triggered an update and was paused
    if (IsPlayerPaused(playerid))
    {
        // Set to resumed
        isPlayerPaused[playerid] = false;

        // Trigger event
        CallLocalFunction("OnPlayerResume", "ii", playerid, gettime() - lastPlayerUpdate[playerid]);
    }

    // Store last update time
    lastPlayerUpdate[playerid] = gettime();
}

// Forwards

forward CheckPlayerPause(playerid);
public  CheckPlayerPause(playerid)
{
    // Players don't trigger update when in class selection
    new _state = GetPlayerState(playerid);
    new bool:_updates = (
        _state != PLAYER_STATE_NONE &&
        _state != PLAYER_STATE_SPECTATING
    );

    // How long since last update
    new lastUpdateDifference = gettime() - lastPlayerUpdate[playerid];

    // If player didn't send update for too long (and was not paused already)
    if (lastUpdateDifference > PAUSE_LIMIT && !IsPlayerPaused(playerid) && _updates)
    {
        // Set to paused
        isPlayerPaused[playerid] = true;

        // Trigger event
        CallLocalFunction("OnPlayerPause", "i", playerid);
    }
}
