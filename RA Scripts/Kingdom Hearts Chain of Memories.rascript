// Kingdom Hearts: Chain of Memories
// #ID = 768

// $03D0B2: Title screen index
//
//          0x0 = new game
//          0x1 = load game

TRUE = 1
FALSE = 0

function Debug(text)
{
    achievement(title = text + "", description = "", points = 0, trigger = always_false())
}

function MergeArrays(arr1, arr2)
{
    newArr = arr1
    for i in arr2
    {
        array_push(newArr, i)
    }
    return newArr
}

function Delta(mem)
{
    return prev(mem)
}

function SecondsToFormat(value)
{
    leadingZero = ""
    if (value % 60 < 10)
    {
        leadingZero = "0"
    }
    return value / 60 + ":" + leadingZero + value % 60
}

function SecondsToFrames(seconds) => seconds * 60

// This function allows the creation of achievements with built-in save protection that deal with a collection of values being set
// throughout the game. The schemas for both parameters are as follows:
//
// cheevo: "name": title
//         "description": self-explanatory
//         "points": self-explanatory
//         "threshold": how many values in the "addresses" dictionary must be set before this achievement is triggered
//
// conditions: "countsWhen": the condition that must be true in order for it to be counted in the total
//             "recalculateWhen": the condition that indicates that relevant values in the condition have changed,
//                                and so everything must be recalculated
//
// onlyAvailableWhen: A condition that must be true in all conditions for the achievement to trigger.
function GenerateCheevoFromConditions(cheevo, conditions, onlyAvailableWhen)
{
    loadedCounts = []
    suspendedCounts = []
    totalCounts = []
    resetAlt = always_false()

    for i in conditions
    {
        condition = conditions[i]
        
        // This is the score when the game is loaded. If the loaded score is greater than or equal to the threshold--that is,
        // if the save file would satisfy enough conditions to trigger the achievement on load--this should trigger a
        // permanant pauselock to serve as save protection.
        array_push(loadedCounts, once(condition["countsWhen"] && IsLoadingSaveFileForMainGame()))
        
        // We want both loaded and session counts here (that is, we don't care if we're loading a save file when these are tallied).
        // This way, loading a save doesn't invalidate the achievement outright if a player hasn't actually earned it yet.
        array_push(totalCounts, once(condition["countsWhen"]))
        
        resetAlt = resetAlt || condition["recalculateWhen"]
    }
    
    trigger = tally(0, [ !IsLoadingSaveFileForMainGame() ]) // Force this into an OrNext construct to optimize the resulting code.
                && measured(tally(cheevo["threshold"], totalCounts), onlyAvailableWhen) && unless(tally(cheevo["threshold"], loadedCounts))
                && never(resetAlt)
                || never(PressStartReady()) && always_false() // Create an alt that resets everything when the player first sees the title screen.

    if (length(cheevo) == 6) // No better way currently of checking for the existence of "id" or "badge", so we need to count the number of keys.
    {
        achievement(title = cheevo["name"], description = cheevo["description"], points = cheevo["points"], id = cheevo["id"], badge = cheevo["badge"],
            trigger = trigger
        )
    }
    else
    {
        // We need to copy the above without the ID or badge parameters because there's no easy way to ignore certain paramters if they don't exist.
        achievement(title = cheevo["name"], description = cheevo["description"], points = cheevo["points"], badge = cheevo["badge"],
            trigger = trigger
        )
    }
}

function GenerateCheevoFromBitflags(cheevo, bitflags, onlyAvailableWhen)
{
    conditions = {}
    for i in range(0, length(bitflags) - 1)
    {
        bit = bitflags[i]
        conditions[i] = GenerateConditionFromBitflag(bit)
    }
    
    GenerateCheevoFromConditions(cheevo, conditions, onlyAvailableWhen)
}

function GenerateConditionFromBitflag(mem)
{
    return { "countsWhen": (mem == 1), "recalculateWhen": (Delta(mem) != mem) }
}

// $03bfc2: Appears to affect what screen the game transitions to in certain situations.
//
//          For instance, it changes from 0 to 1 when loading a game, and if it's frozen at 0 when attempting to load a game, you get booted back to the title screen.
//
//          Can probably be used for save protection.
function gameTransitionState() => byte(0x03bfc2)

// $03bc8: Loading animation ID (16-bit)
//
//          0x9189 = load menu is static
//          0x9279 = "Load" header moving left
//          0x92b9 = top and bottom borders dilating
//          0x930d = fading out
//
//          Can probably be used for save protection.
function loadAnimationState() => word(0x03bfc8)

// 0x5 = "Press Start" ready
// 0x6 -> 0x8 (final) = "New Game"/"Load"
// 0x9 = Load menu/In game
function titleScreenState() => byte(0x03d088)

function PressStartReady() => titleScreenState() == 0x5

// 0x0 = New Game
// 0x1 = Load Game
// 0x2 = Link
// 0x3 = Continue
// 0x4 = New Game (Sora)
// 0x5 = New Game (Riku)
function titleScreenIndex() => byte(0x03d0b2)

function IsLoadingSaveFileForMainGame()
{
    return Delta(floor1WorldId()) == 0x0 && floor1WorldId() == GetWorldIdByName("Traverse Town")
}

function WasValueSet(mem, oldValue, newValue)
{
    return Delta(mem) == oldValue && mem == newValue
}

function WasValueSetInMainGame(mem, oldValue, newValue)
{
    return WasValueSet(mem, oldValue, newValue) && !IsLoadingSaveFileForMainGame()
}

function WasBitflagSetInMainGame(mem)
{
    return WasValueSetInMainGame(mem, 0, 1)
}

function worldId() => byte(0x0421CC)

function roomId() => byte(0x044b86)

function systemTimer() => dword(0x006c68)

function FrameHasAdvanced() => Delta(systemTimer()) != systemTimer()

LocationLookup = {
    0: "Castle Oblivion, Hall",
    1: "Agrabah",
    2: "Atlantica",
    3: "Olympus Coliseum",
    4: "Wonderland",
    5: "Monstro",
    6: "Halloween Town",
    7: "Never Land",
    8: "Hollow Bastion",
    9: "Destiny Islands",
    10: "Traverse Town",
    11: "Twilight Town",
    12: "Castle Oblivion",
    13: "the Hundred Acre Wood",
}

function GetWorldIdByName(name)
{
    for i in LocationLookup
    {
        if (LocationLookup[i] == name)
        {
            return i
        }
    }
}

function IsInWorld(name)
{
    for i in LocationLookup
    {
        if (LocationLookup[i] == name)
        {
            return worldId() == i
        }
    }
}

function WasInWorld(name)
{
    for i in LocationLookup
    {
        if (LocationLookup[i] == name)
        {
            return Delta(worldId()) == i
        }
    }
}

function encounterId() => word(0x00749c)

function AlwaysInEncounterWithId(id) => never(encounterId() != id)

function PassedBattleCheckpoint() => once(Delta(battlePointer()) == 0 && battlePointer() > 0)

function PlayerIsAlwaysAliveInBattle() => never(IsInMainStory() && Delta(playerHp()) > 0 && playerHp() == 0 && battlePointer() > 0)
    && never(IsInReverseRebirth() && Delta(rikuPlayerHp()) > 0 && rikuPlayerHp() == 0 && battlePointer() > 0)
    
function DefeatedCheckpointedEncounterWithId(id, useTrigger) => AlwaysInEncounterWithId(id) && PassedBattleCheckpoint() && PlayerIsAlwaysAliveInBattle() && FinishedEncounter(useTrigger)

function FinishedEncounter(useTrigger)
{
    finishedEncounter = Delta(battlePointer()) > 0 && battlePointer() == 0
    if (useTrigger == TRUE)
    {
        finishedEncounter = trigger_when(finishedEncounter)
    }
    
    return finishedEncounter
}

// $0421CD: Battlefield ID (EU)
function battlefieldId() => byte(0x0421CD)

// $0421CE: Floor (EU)
function floor() => byte(0x0421CE)

function IsOnFloor(floor) => floor() + 1 == floor

function floor1WorldId() => byte(0x042346)

function IsInMainStory() => floor1WorldId() == GetWorldIdByName("Traverse Town")
function JustLoadedMainStory() => Delta(floor1WorldId()) == 0x0 && IsInMainStory()

function IsInReverseRebirth() => floor1WorldId() == GetWorldIdByName("Hollow Bastion")
function JustloadedReverseRebirth() => Delta(floor1WorldId()) == 0x0 && IsInReverseRebirth()

// $0422B8: Max HP (16-bit)
function maxHp() => word(0x0422B8)

// $0422BA: Max CP (16-bit)
function maxCp() => word(0x0422BA)

// $0422BE: Attack Points
function attackPoints() => byte(0x0422BE)

// $0422C8: Level
function level() => byte(0x0422C8)

// $042334: Moogle Points (16-bit)

FloorLookup = {
    0: "1F",
    1: "2F",
    2: "3F",
    3: "4F",
    4: "5F",
    5: "6F",
    6: "7F",
    7: "8F",
    8: "9F",
    9: "10F",
    10: "11F",
    11: "12F",
    12: "13F",
    16: "B12",
    17: "B11",
    18: "B10",
    19: "B9",
    20: "B8",
    21: "B7",
    22: "B6",
    23: "B5",
    24: "B4",
    25: "B3",
    26: "B2",
    27: "B1",
}

function RichPresenceTemplateString() => "{0} ({1}) | Play Time: {2}"

function playTime() => dword(0x04239c)

rich_presence_conditional_display(IsInReverseRebirth(),
    "Riku is in " + RichPresenceTemplateString(),
    rich_presence_lookup("Location", byte(0x0421CC), LocationLookup),
    rich_presence_lookup("Floor", byte(0x0421CE) + 16, FloorLookup),
    rich_presence_value("PlayTime", playTime(), "SECS")
)

rich_presence_display("Sora is in " + RichPresenceTemplateString(),
    rich_presence_lookup("Location", byte(0x0421CC), LocationLookup),
    rich_presence_lookup("Floor", byte(0x0421CE), FloorLookup),
    rich_presence_value("PlayTime", playTime(), "SECS")
)

// 0x03c000: Bit 0: A button
//           Bit 1: B button
//           Bit 2: Select button
//           Bit 3: Start button
//           Bit 4: D-pad Right
//           Bit 5: D-pad Left
//           Bit 6: D-pad Up
//           Bit 7: D-pad Down
// 0x03c001: Bit 0: R button
//           Bit 1: L button
function inputFlagsAddr() => 0x03c000
function inputFlags2Addr() => 0x03c001
function dpadFlags() => high4(inputFlagsAddr())
function aIsPressed() => bit0(inputFlagsAddr())
function bIsPressed() => bit1(inputFlagsAddr())
function selectIsPressed() => bit2(inputFlagsAddr())
function startIsPressed() => bit3(inputFlagsAddr())
function dpadRightPressed() => bit4(inputFlagsAddr())
function dpadLeftPressed() => bit5(inputFlagsAddr())
function dpadUpPressed() => bit6(inputFlagsAddr())
function dpadDownPressed() => bit7(inputFlagsAddr())
function rIsPressed() => bit0(inputFlags2Addr())
function lIsPressed() => bit1(inputFlags2Addr())

function DpadIsPressed() => dpadFlags() > 0

function deck1BaseAddr() => 0x0423f0
function deck2BaseAddr() => 0x0424d0
function deck3BaseAddr() => 0x0425b0
function inventoryBaseAddr() => 0x042690

cards = {
0x0: { "idMostSigNib": 0, "idLeastSigByte": 0x0, "name": "Kingdom Key", "value": 0, "type": "Attack", "cpCost": 19, "element": "Physical", },
0x1: { "idMostSigNib": 0, "idLeastSigByte": 0x1, "name": "Kingdom Key", "value": 1, "type": "Attack", "cpCost": 10, "element": "Physical", },
0x2: { "idMostSigNib": 0, "idLeastSigByte": 0x2, "name": "Kingdom Key", "value": 2, "type": "Attack", "cpCost": 11, "element": "Physical", },
0x3: { "idMostSigNib": 0, "idLeastSigByte": 0x3, "name": "Kingdom Key", "value": 3, "type": "Attack", "cpCost": 12, "element": "Physical", },
0x4: { "idMostSigNib": 0, "idLeastSigByte": 0x4, "name": "Kingdom Key", "value": 4, "type": "Attack", "cpCost": 13, "element": "Physical", },
0x5: { "idMostSigNib": 0, "idLeastSigByte": 0x5, "name": "Kingdom Key", "value": 5, "type": "Attack", "cpCost": 14, "element": "Physical", },
0x6: { "idMostSigNib": 0, "idLeastSigByte": 0x6, "name": "Kingdom Key", "value": 6, "type": "Attack", "cpCost": 15, "element": "Physical", },
0x7: { "idMostSigNib": 0, "idLeastSigByte": 0x7, "name": "Kingdom Key", "value": 7, "type": "Attack", "cpCost": 16, "element": "Physical", },
0x8: { "idMostSigNib": 0, "idLeastSigByte": 0x8, "name": "Kingdom Key", "value": 8, "type": "Attack", "cpCost": 17, "element": "Physical", },
0x9: { "idMostSigNib": 0, "idLeastSigByte": 0x9, "name": "Kingdom Key", "value": 9, "type": "Attack", "cpCost": 18, "element": "Physical", },
0xA: { "idMostSigNib": 0, "idLeastSigByte": 0xA, "name": "Three Wishes", "value": 0, "type": "Attack", "cpCost": 24, "element": "Physical", },
0xB: { "idMostSigNib": 0, "idLeastSigByte": 0xB, "name": "Three Wishes", "value": 1, "type": "Attack", "cpCost": 15, "element": "Physical", },
0xC: { "idMostSigNib": 0, "idLeastSigByte": 0xC, "name": "Three Wishes", "value": 2, "type": "Attack", "cpCost": 16, "element": "Physical", },
0xD: { "idMostSigNib": 0, "idLeastSigByte": 0xD, "name": "Three Wishes", "value": 3, "type": "Attack", "cpCost": 17, "element": "Physical", },
0xE: { "idMostSigNib": 0, "idLeastSigByte": 0xE, "name": "Three Wishes", "value": 4, "type": "Attack", "cpCost": 18, "element": "Physical", },
0xF: { "idMostSigNib": 0, "idLeastSigByte": 0xF, "name": "Three Wishes", "value": 5, "type": "Attack", "cpCost": 19, "element": "Physical", },
0x10: { "idMostSigNib": 0, "idLeastSigByte": 0x10, "name": "Three Wishes", "value": 6, "type": "Attack", "cpCost": 20, "element": "Physical", },
0x11: { "idMostSigNib": 0, "idLeastSigByte": 0x11, "name": "Three Wishes", "value": 7, "type": "Attack", "cpCost": 21, "element": "Physical", },
0x12: { "idMostSigNib": 0, "idLeastSigByte": 0x12, "name": "Three Wishes", "value": 8, "type": "Attack", "cpCost": 22, "element": "Physical", },
0x13: { "idMostSigNib": 0, "idLeastSigByte": 0x13, "name": "Three Wishes", "value": 9, "type": "Attack", "cpCost": 23, "element": "Physical", },
0x14: { "idMostSigNib": 0, "idLeastSigByte": 0x14, "name": "Crabclaw", "value": 0, "type": "Attack", "cpCost": 38, "element": "Physical", },
0x15: { "idMostSigNib": 0, "idLeastSigByte": 0x15, "name": "Crabclaw", "value": 1, "type": "Attack", "cpCost": 20, "element": "Physical", },
0x16: { "idMostSigNib": 0, "idLeastSigByte": 0x16, "name": "Crabclaw", "value": 2, "type": "Attack", "cpCost": 22, "element": "Physical", },
0x17: { "idMostSigNib": 0, "idLeastSigByte": 0x17, "name": "Crabclaw", "value": 3, "type": "Attack", "cpCost": 24, "element": "Physical", },
0x18: { "idMostSigNib": 0, "idLeastSigByte": 0x18, "name": "Crabclaw", "value": 4, "type": "Attack", "cpCost": 26, "element": "Physical", },
0x19: { "idMostSigNib": 0, "idLeastSigByte": 0x19, "name": "Crabclaw", "value": 5, "type": "Attack", "cpCost": 28, "element": "Physical", },
0x1A: { "idMostSigNib": 0, "idLeastSigByte": 0x1A, "name": "Crabclaw", "value": 6, "type": "Attack", "cpCost": 30, "element": "Physical", },
0x1B: { "idMostSigNib": 0, "idLeastSigByte": 0x1B, "name": "Crabclaw", "value": 7, "type": "Attack", "cpCost": 32, "element": "Physical", },
0x1C: { "idMostSigNib": 0, "idLeastSigByte": 0x1C, "name": "Crabclaw", "value": 8, "type": "Attack", "cpCost": 34, "element": "Physical", },
0x1D: { "idMostSigNib": 0, "idLeastSigByte": 0x1D, "name": "Crabclaw", "value": 9, "type": "Attack", "cpCost": 36, "element": "Physical", },
0x1E: { "idMostSigNib": 0, "idLeastSigByte": 0x1E, "name": "Pumpkinhead", "value": 0, "type": "Attack", "cpCost": 24, "element": "Physical", },
0x1F: { "idMostSigNib": 0, "idLeastSigByte": 0x1F, "name": "Pumpkinhead", "value": 1, "type": "Attack", "cpCost": 15, "element": "Physical", },
0x20: { "idMostSigNib": 0, "idLeastSigByte": 0x20, "name": "Pumpkinhead", "value": 2, "type": "Attack", "cpCost": 16, "element": "Physical", },
0x21: { "idMostSigNib": 0, "idLeastSigByte": 0x21, "name": "Pumpkinhead", "value": 3, "type": "Attack", "cpCost": 17, "element": "Physical", },
0x22: { "idMostSigNib": 0, "idLeastSigByte": 0x22, "name": "Pumpkinhead", "value": 4, "type": "Attack", "cpCost": 18, "element": "Physical", },
0x23: { "idMostSigNib": 0, "idLeastSigByte": 0x23, "name": "Pumpkinhead", "value": 5, "type": "Attack", "cpCost": 19, "element": "Physical", },
0x24: { "idMostSigNib": 0, "idLeastSigByte": 0x24, "name": "Pumpkinhead", "value": 6, "type": "Attack", "cpCost": 20, "element": "Physical", },
0x25: { "idMostSigNib": 0, "idLeastSigByte": 0x25, "name": "Pumpkinhead", "value": 7, "type": "Attack", "cpCost": 21, "element": "Physical", },
0x26: { "idMostSigNib": 0, "idLeastSigByte": 0x26, "name": "Pumpkinhead", "value": 8, "type": "Attack", "cpCost": 22, "element": "Physical", },
0x27: { "idMostSigNib": 0, "idLeastSigByte": 0x27, "name": "Pumpkinhead", "value": 9, "type": "Attack", "cpCost": 23, "element": "Physical", },
0x28: { "idMostSigNib": 0, "idLeastSigByte": 0x28, "name": "Fairy Harp", "value": 0, "type": "Attack", "cpCost": 38, "element": "Physical", },
0x29: { "idMostSigNib": 0, "idLeastSigByte": 0x29, "name": "Fairy Harp", "value": 1, "type": "Attack", "cpCost": 20, "element": "Physical", },
0x2A: { "idMostSigNib": 0, "idLeastSigByte": 0x2A, "name": "Fairy Harp", "value": 2, "type": "Attack", "cpCost": 22, "element": "Physical", },
0x2B: { "idMostSigNib": 0, "idLeastSigByte": 0x2B, "name": "Fairy Harp", "value": 3, "type": "Attack", "cpCost": 24, "element": "Physical", },
0x2C: { "idMostSigNib": 0, "idLeastSigByte": 0x2C, "name": "Fairy Harp", "value": 4, "type": "Attack", "cpCost": 26, "element": "Physical", },
0x2D: { "idMostSigNib": 0, "idLeastSigByte": 0x2D, "name": "Fairy Harp", "value": 5, "type": "Attack", "cpCost": 28, "element": "Physical", },
0x2E: { "idMostSigNib": 0, "idLeastSigByte": 0x2E, "name": "Fairy Harp", "value": 6, "type": "Attack", "cpCost": 30, "element": "Physical", },
0x2F: { "idMostSigNib": 0, "idLeastSigByte": 0x2F, "name": "Fairy Harp", "value": 7, "type": "Attack", "cpCost": 32, "element": "Physical", },
0x30: { "idMostSigNib": 0, "idLeastSigByte": 0x30, "name": "Fairy Harp", "value": 8, "type": "Attack", "cpCost": 34, "element": "Physical", },
0x31: { "idMostSigNib": 0, "idLeastSigByte": 0x31, "name": "Fairy Harp", "value": 9, "type": "Attack", "cpCost": 36, "element": "Physical", },
0x32: { "idMostSigNib": 0, "idLeastSigByte": 0x32, "name": "Wishing Star", "value": 0, "type": "Attack", "cpCost": 24, "element": "Physical", },
0x33: { "idMostSigNib": 0, "idLeastSigByte": 0x33, "name": "Wishing Star", "value": 1, "type": "Attack", "cpCost": 15, "element": "Physical", },
0x34: { "idMostSigNib": 0, "idLeastSigByte": 0x34, "name": "Wishing Star", "value": 2, "type": "Attack", "cpCost": 16, "element": "Physical", },
0x35: { "idMostSigNib": 0, "idLeastSigByte": 0x35, "name": "Wishing Star", "value": 3, "type": "Attack", "cpCost": 17, "element": "Physical", },
0x36: { "idMostSigNib": 0, "idLeastSigByte": 0x36, "name": "Wishing Star", "value": 4, "type": "Attack", "cpCost": 18, "element": "Physical", },
0x37: { "idMostSigNib": 0, "idLeastSigByte": 0x37, "name": "Wishing Star", "value": 5, "type": "Attack", "cpCost": 19, "element": "Physical", },
0x38: { "idMostSigNib": 0, "idLeastSigByte": 0x38, "name": "Wishing Star", "value": 6, "type": "Attack", "cpCost": 20, "element": "Physical", },
0x39: { "idMostSigNib": 0, "idLeastSigByte": 0x39, "name": "Wishing Star", "value": 7, "type": "Attack", "cpCost": 21, "element": "Physical", },
0x3A: { "idMostSigNib": 0, "idLeastSigByte": 0x3A, "name": "Wishing Star", "value": 8, "type": "Attack", "cpCost": 22, "element": "Physical", },
0x3B: { "idMostSigNib": 0, "idLeastSigByte": 0x3B, "name": "Wishing Star", "value": 9, "type": "Attack", "cpCost": 23, "element": "Physical", },
0x3C: { "idMostSigNib": 0, "idLeastSigByte": 0x3C, "name": "Spellbinder", "value": 0, "type": "Attack", "cpCost": 38, "element": "Lightning", },
0x3D: { "idMostSigNib": 0, "idLeastSigByte": 0x3D, "name": "Spellbinder", "value": 1, "type": "Attack", "cpCost": 20, "element": "Lightning", },
0x3E: { "idMostSigNib": 0, "idLeastSigByte": 0x3E, "name": "Spellbinder", "value": 2, "type": "Attack", "cpCost": 22, "element": "Lightning", },
0x3F: { "idMostSigNib": 0, "idLeastSigByte": 0x3F, "name": "Spellbinder", "value": 3, "type": "Attack", "cpCost": 24, "element": "Lightning", },
0x40: { "idMostSigNib": 0, "idLeastSigByte": 0x40, "name": "Spellbinder", "value": 4, "type": "Attack", "cpCost": 26, "element": "Lightning", },
0x41: { "idMostSigNib": 0, "idLeastSigByte": 0x41, "name": "Spellbinder", "value": 5, "type": "Attack", "cpCost": 28, "element": "Lightning", },
0x42: { "idMostSigNib": 0, "idLeastSigByte": 0x42, "name": "Spellbinder", "value": 6, "type": "Attack", "cpCost": 30, "element": "Lightning", },
0x43: { "idMostSigNib": 0, "idLeastSigByte": 0x43, "name": "Spellbinder", "value": 7, "type": "Attack", "cpCost": 32, "element": "Lightning", },
0x44: { "idMostSigNib": 0, "idLeastSigByte": 0x44, "name": "Spellbinder", "value": 8, "type": "Attack", "cpCost": 34, "element": "Lightning", },
0x45: { "idMostSigNib": 0, "idLeastSigByte": 0x45, "name": "Spellbinder", "value": 9, "type": "Attack", "cpCost": 36, "element": "Lightning", },
0x46: { "idMostSigNib": 0, "idLeastSigByte": 0x46, "name": "Metal Chocobo", "value": 0, "type": "Attack", "cpCost": 38, "element": "Neutral", },
0x47: { "idMostSigNib": 0, "idLeastSigByte": 0x47, "name": "Metal Chocobo", "value": 1, "type": "Attack", "cpCost": 20, "element": "Neutral", },
0x48: { "idMostSigNib": 0, "idLeastSigByte": 0x48, "name": "Metal Chocobo", "value": 2, "type": "Attack", "cpCost": 22, "element": "Neutral", },
0x49: { "idMostSigNib": 0, "idLeastSigByte": 0x49, "name": "Metal Chocobo", "value": 3, "type": "Attack", "cpCost": 24, "element": "Neutral", },
0x4A: { "idMostSigNib": 0, "idLeastSigByte": 0x4A, "name": "Metal Chocobo", "value": 4, "type": "Attack", "cpCost": 26, "element": "Neutral", },
0x4B: { "idMostSigNib": 0, "idLeastSigByte": 0x4B, "name": "Metal Chocobo", "value": 5, "type": "Attack", "cpCost": 28, "element": "Neutral", },
0x4C: { "idMostSigNib": 0, "idLeastSigByte": 0x4C, "name": "Metal Chocobo", "value": 6, "type": "Attack", "cpCost": 30, "element": "Neutral", },
0x4D: { "idMostSigNib": 0, "idLeastSigByte": 0x4D, "name": "Metal Chocobo", "value": 7, "type": "Attack", "cpCost": 32, "element": "Neutral", },
0x4E: { "idMostSigNib": 0, "idLeastSigByte": 0x4E, "name": "Metal Chocobo", "value": 8, "type": "Attack", "cpCost": 34, "element": "Neutral", },
0x4F: { "idMostSigNib": 0, "idLeastSigByte": 0x4F, "name": "Metal Chocobo", "value": 9, "type": "Attack", "cpCost": 36, "element": "Neutral", },
0x50: { "idMostSigNib": 0, "idLeastSigByte": 0x50, "name": "Olympia", "value": 0, "type": "Attack", "cpCost": 24, "element": "Physical", },
0x51: { "idMostSigNib": 0, "idLeastSigByte": 0x51, "name": "Olympia", "value": 1, "type": "Attack", "cpCost": 15, "element": "Physical", },
0x52: { "idMostSigNib": 0, "idLeastSigByte": 0x52, "name": "Olympia", "value": 2, "type": "Attack", "cpCost": 16, "element": "Physical", },
0x53: { "idMostSigNib": 0, "idLeastSigByte": 0x53, "name": "Olympia", "value": 3, "type": "Attack", "cpCost": 17, "element": "Physical", },
0x54: { "idMostSigNib": 0, "idLeastSigByte": 0x54, "name": "Olympia", "value": 4, "type": "Attack", "cpCost": 18, "element": "Physical", },
0x55: { "idMostSigNib": 0, "idLeastSigByte": 0x55, "name": "Olympia", "value": 5, "type": "Attack", "cpCost": 19, "element": "Physical", },
0x56: { "idMostSigNib": 0, "idLeastSigByte": 0x56, "name": "Olympia", "value": 6, "type": "Attack", "cpCost": 20, "element": "Physical", },
0x57: { "idMostSigNib": 0, "idLeastSigByte": 0x57, "name": "Olympia", "value": 7, "type": "Attack", "cpCost": 21, "element": "Physical", },
0x58: { "idMostSigNib": 0, "idLeastSigByte": 0x58, "name": "Olympia", "value": 8, "type": "Attack", "cpCost": 22, "element": "Physical", },
0x59: { "idMostSigNib": 0, "idLeastSigByte": 0x59, "name": "Olympia", "value": 9, "type": "Attack", "cpCost": 23, "element": "Physical", },
0x5A: { "idMostSigNib": 0, "idLeastSigByte": 0x5A, "name": "Lionheart", "value": 0, "type": "Attack", "cpCost": 38, "element": "Fire", },
0x5B: { "idMostSigNib": 0, "idLeastSigByte": 0x5B, "name": "Lionheart", "value": 1, "type": "Attack", "cpCost": 20, "element": "Fire", },
0x5C: { "idMostSigNib": 0, "idLeastSigByte": 0x5C, "name": "Lionheart", "value": 2, "type": "Attack", "cpCost": 22, "element": "Fire", },
0x5D: { "idMostSigNib": 0, "idLeastSigByte": 0x5D, "name": "Lionheart", "value": 3, "type": "Attack", "cpCost": 24, "element": "Fire", },
0x5E: { "idMostSigNib": 0, "idLeastSigByte": 0x5E, "name": "Lionheart", "value": 4, "type": "Attack", "cpCost": 26, "element": "Fire", },
0x5F: { "idMostSigNib": 0, "idLeastSigByte": 0x5F, "name": "Lionheart", "value": 5, "type": "Attack", "cpCost": 28, "element": "Fire", },
0x60: { "idMostSigNib": 0, "idLeastSigByte": 0x60, "name": "Lionheart", "value": 6, "type": "Attack", "cpCost": 30, "element": "Fire", },
0x61: { "idMostSigNib": 0, "idLeastSigByte": 0x61, "name": "Lionheart", "value": 7, "type": "Attack", "cpCost": 32, "element": "Fire", },
0x62: { "idMostSigNib": 0, "idLeastSigByte": 0x62, "name": "Lionheart", "value": 8, "type": "Attack", "cpCost": 34, "element": "Fire", },
0x63: { "idMostSigNib": 0, "idLeastSigByte": 0x63, "name": "Lionheart", "value": 9, "type": "Attack", "cpCost": 36, "element": "Fire", },
0x64: { "idMostSigNib": 0, "idLeastSigByte": 0x64, "name": "Lady Luck", "value": 0, "type": "Attack", "cpCost": 24, "element": "Physical", },
0x65: { "idMostSigNib": 0, "idLeastSigByte": 0x65, "name": "Lady Luck", "value": 1, "type": "Attack", "cpCost": 15, "element": "Physical", },
0x66: { "idMostSigNib": 0, "idLeastSigByte": 0x66, "name": "Lady Luck", "value": 2, "type": "Attack", "cpCost": 16, "element": "Physical", },
0x67: { "idMostSigNib": 0, "idLeastSigByte": 0x67, "name": "Lady Luck", "value": 3, "type": "Attack", "cpCost": 17, "element": "Physical", },
0x68: { "idMostSigNib": 0, "idLeastSigByte": 0x68, "name": "Lady Luck", "value": 4, "type": "Attack", "cpCost": 18, "element": "Physical", },
0x69: { "idMostSigNib": 0, "idLeastSigByte": 0x69, "name": "Lady Luck", "value": 5, "type": "Attack", "cpCost": 19, "element": "Physical", },
0x6A: { "idMostSigNib": 0, "idLeastSigByte": 0x6A, "name": "Lady Luck", "value": 6, "type": "Attack", "cpCost": 20, "element": "Physical", },
0x6B: { "idMostSigNib": 0, "idLeastSigByte": 0x6B, "name": "Lady Luck", "value": 7, "type": "Attack", "cpCost": 21, "element": "Physical", },
0x6C: { "idMostSigNib": 0, "idLeastSigByte": 0x6C, "name": "Lady Luck", "value": 8, "type": "Attack", "cpCost": 22, "element": "Physical", },
0x6D: { "idMostSigNib": 0, "idLeastSigByte": 0x6D, "name": "Lady Luck", "value": 9, "type": "Attack", "cpCost": 23, "element": "Physical", },
0x6E: { "idMostSigNib": 0, "idLeastSigByte": 0x6E, "name": "Divine Rose", "value": 0, "type": "Attack", "cpCost": 38, "element": "Physical", },
0x6F: { "idMostSigNib": 0, "idLeastSigByte": 0x6F, "name": "Divine Rose", "value": 1, "type": "Attack", "cpCost": 20, "element": "Physical", },
0x70: { "idMostSigNib": 0, "idLeastSigByte": 0x70, "name": "Divine Rose", "value": 2, "type": "Attack", "cpCost": 22, "element": "Physical", },
0x71: { "idMostSigNib": 0, "idLeastSigByte": 0x71, "name": "Divine Rose", "value": 3, "type": "Attack", "cpCost": 24, "element": "Physical", },
0x72: { "idMostSigNib": 0, "idLeastSigByte": 0x72, "name": "Divine Rose", "value": 4, "type": "Attack", "cpCost": 26, "element": "Physical", },
0x73: { "idMostSigNib": 0, "idLeastSigByte": 0x73, "name": "Divine Rose", "value": 5, "type": "Attack", "cpCost": 28, "element": "Physical", },
0x74: { "idMostSigNib": 0, "idLeastSigByte": 0x74, "name": "Divine Rose", "value": 6, "type": "Attack", "cpCost": 30, "element": "Physical", },
0x75: { "idMostSigNib": 0, "idLeastSigByte": 0x75, "name": "Divine Rose", "value": 7, "type": "Attack", "cpCost": 32, "element": "Physical", },
0x76: { "idMostSigNib": 0, "idLeastSigByte": 0x76, "name": "Divine Rose", "value": 8, "type": "Attack", "cpCost": 34, "element": "Physical", },
0x77: { "idMostSigNib": 0, "idLeastSigByte": 0x77, "name": "Divine Rose", "value": 9, "type": "Attack", "cpCost": 36, "element": "Physical", },
0x78: { "idMostSigNib": 0, "idLeastSigByte": 0x78, "name": "Oathkeeper", "value": 0, "type": "Attack", "cpCost": 43, "element": "Physical", },
0x79: { "idMostSigNib": 0, "idLeastSigByte": 0x79, "name": "Oathkeeper", "value": 1, "type": "Attack", "cpCost": 25, "element": "Physical", },
0x7A: { "idMostSigNib": 0, "idLeastSigByte": 0x7A, "name": "Oathkeeper", "value": 2, "type": "Attack", "cpCost": 27, "element": "Physical", },
0x7B: { "idMostSigNib": 0, "idLeastSigByte": 0x7B, "name": "Oathkeeper", "value": 3, "type": "Attack", "cpCost": 29, "element": "Physical", },
0x7C: { "idMostSigNib": 0, "idLeastSigByte": 0x7C, "name": "Oathkeeper", "value": 4, "type": "Attack", "cpCost": 31, "element": "Physical", },
0x7D: { "idMostSigNib": 0, "idLeastSigByte": 0x7D, "name": "Oathkeeper", "value": 5, "type": "Attack", "cpCost": 33, "element": "Physical", },
0x7E: { "idMostSigNib": 0, "idLeastSigByte": 0x7E, "name": "Oathkeeper", "value": 6, "type": "Attack", "cpCost": 35, "element": "Physical", },
0x7F: { "idMostSigNib": 0, "idLeastSigByte": 0x7F, "name": "Oathkeeper", "value": 7, "type": "Attack", "cpCost": 37, "element": "Physical", },
0x80: { "idMostSigNib": 0, "idLeastSigByte": 0x80, "name": "Oathkeeper", "value": 8, "type": "Attack", "cpCost": 39, "element": "Physical", },
0x81: { "idMostSigNib": 0, "idLeastSigByte": 0x81, "name": "Oathkeeper", "value": 9, "type": "Attack", "cpCost": 41, "element": "Physical", },
0x82: { "idMostSigNib": 0, "idLeastSigByte": 0x82, "name": "Oblivion", "value": 0, "type": "Attack", "cpCost": 43, "element": "Neutral", },
0x83: { "idMostSigNib": 0, "idLeastSigByte": 0x83, "name": "Oblivion", "value": 1, "type": "Attack", "cpCost": 25, "element": "Neutral", },
0x84: { "idMostSigNib": 0, "idLeastSigByte": 0x84, "name": "Oblivion", "value": 2, "type": "Attack", "cpCost": 27, "element": "Neutral", },
0x85: { "idMostSigNib": 0, "idLeastSigByte": 0x85, "name": "Oblivion", "value": 3, "type": "Attack", "cpCost": 29, "element": "Neutral", },
0x86: { "idMostSigNib": 0, "idLeastSigByte": 0x86, "name": "Oblivion", "value": 4, "type": "Attack", "cpCost": 31, "element": "Neutral", },
0x87: { "idMostSigNib": 0, "idLeastSigByte": 0x87, "name": "Oblivion", "value": 5, "type": "Attack", "cpCost": 33, "element": "Neutral", },
0x88: { "idMostSigNib": 0, "idLeastSigByte": 0x88, "name": "Oblivion", "value": 6, "type": "Attack", "cpCost": 35, "element": "Neutral", },
0x89: { "idMostSigNib": 0, "idLeastSigByte": 0x89, "name": "Oblivion", "value": 7, "type": "Attack", "cpCost": 37, "element": "Neutral", },
0x8A: { "idMostSigNib": 0, "idLeastSigByte": 0x8A, "name": "Oblivion", "value": 8, "type": "Attack", "cpCost": 39, "element": "Neutral", },
0x8B: { "idMostSigNib": 0, "idLeastSigByte": 0x8B, "name": "Oblivion", "value": 9, "type": "Attack", "cpCost": 41, "element": "Neutral", },
0x8C: { "idMostSigNib": 0, "idLeastSigByte": 0x8C, "name": "Diamond Dust", "value": 0, "type": "Attack", "cpCost": 43, "element": "Ice", },
0x8D: { "idMostSigNib": 0, "idLeastSigByte": 0x8D, "name": "Diamond Dust", "value": 1, "type": "Attack", "cpCost": 25, "element": "Ice", },
0x8E: { "idMostSigNib": 0, "idLeastSigByte": 0x8E, "name": "Diamond Dust", "value": 2, "type": "Attack", "cpCost": 27, "element": "Ice", },
0x8F: { "idMostSigNib": 0, "idLeastSigByte": 0x8F, "name": "Diamond Dust", "value": 3, "type": "Attack", "cpCost": 29, "element": "Ice", },
0x90: { "idMostSigNib": 0, "idLeastSigByte": 0x90, "name": "Diamond Dust", "value": 4, "type": "Attack", "cpCost": 31, "element": "Ice", },
0x91: { "idMostSigNib": 0, "idLeastSigByte": 0x91, "name": "Diamond Dust", "value": 5, "type": "Attack", "cpCost": 33, "element": "Ice", },
0x92: { "idMostSigNib": 0, "idLeastSigByte": 0x92, "name": "Diamond Dust", "value": 6, "type": "Attack", "cpCost": 35, "element": "Ice", },
0x93: { "idMostSigNib": 0, "idLeastSigByte": 0x93, "name": "Diamond Dust", "value": 7, "type": "Attack", "cpCost": 37, "element": "Ice", },
0x94: { "idMostSigNib": 0, "idLeastSigByte": 0x94, "name": "Diamond Dust", "value": 8, "type": "Attack", "cpCost": 39, "element": "Ice", },
0x95: { "idMostSigNib": 0, "idLeastSigByte": 0x95, "name": "Diamond Dust", "value": 9, "type": "Attack", "cpCost": 41, "element": "Ice", },
0x96: { "idMostSigNib": 0, "idLeastSigByte": 0x96, "name": "One-Winged Angel", "value": 0, "type": "Attack", "cpCost": 43, "element": "Fire", },
0x97: { "idMostSigNib": 0, "idLeastSigByte": 0x97, "name": "One-Winged Angel", "value": 1, "type": "Attack", "cpCost": 25, "element": "Fire", },
0x98: { "idMostSigNib": 0, "idLeastSigByte": 0x98, "name": "One-Winged Angel", "value": 2, "type": "Attack", "cpCost": 27, "element": "Fire", },
0x99: { "idMostSigNib": 0, "idLeastSigByte": 0x99, "name": "One-Winged Angel", "value": 3, "type": "Attack", "cpCost": 29, "element": "Fire", },
0x9A: { "idMostSigNib": 0, "idLeastSigByte": 0x9A, "name": "One-Winged Angel", "value": 4, "type": "Attack", "cpCost": 31, "element": "Fire", },
0x9B: { "idMostSigNib": 0, "idLeastSigByte": 0x9B, "name": "One-Winged Angel", "value": 5, "type": "Attack", "cpCost": 33, "element": "Fire", },
0x9C: { "idMostSigNib": 0, "idLeastSigByte": 0x9C, "name": "One-Winged Angel", "value": 6, "type": "Attack", "cpCost": 35, "element": "Fire", },
0x9D: { "idMostSigNib": 0, "idLeastSigByte": 0x9D, "name": "One-Winged Angel", "value": 7, "type": "Attack", "cpCost": 37, "element": "Fire", },
0x9E: { "idMostSigNib": 0, "idLeastSigByte": 0x9E, "name": "One-Winged Angel", "value": 8, "type": "Attack", "cpCost": 39, "element": "Fire", },
0x9F: { "idMostSigNib": 0, "idLeastSigByte": 0x9F, "name": "One-Winged Angel", "value": 9, "type": "Attack", "cpCost": 41, "element": "Fire", },
0xA0: { "idMostSigNib": 0, "idLeastSigByte": 0xA0, "name": "Ultima Weapon", "value": 0, "type": "Attack", "cpCost": 57, "element": "Physical", },
0xA1: { "idMostSigNib": 0, "idLeastSigByte": 0xA1, "name": "Ultima Weapon", "value": 1, "type": "Attack", "cpCost": 30, "element": "Physical", },
0xA2: { "idMostSigNib": 0, "idLeastSigByte": 0xA2, "name": "Ultima Weapon", "value": 2, "type": "Attack", "cpCost": 33, "element": "Physical", },
0xA3: { "idMostSigNib": 0, "idLeastSigByte": 0xA3, "name": "Ultima Weapon", "value": 3, "type": "Attack", "cpCost": 36, "element": "Physical", },
0xA4: { "idMostSigNib": 0, "idLeastSigByte": 0xA4, "name": "Ultima Weapon", "value": 4, "type": "Attack", "cpCost": 39, "element": "Physical", },
0xA5: { "idMostSigNib": 0, "idLeastSigByte": 0xA5, "name": "Ultima Weapon", "value": 5, "type": "Attack", "cpCost": 42, "element": "Physical", },
0xA6: { "idMostSigNib": 0, "idLeastSigByte": 0xA6, "name": "Ultima Weapon", "value": 6, "type": "Attack", "cpCost": 45, "element": "Physical", },
0xA7: { "idMostSigNib": 0, "idLeastSigByte": 0xA7, "name": "Ultima Weapon", "value": 7, "type": "Attack", "cpCost": 48, "element": "Physical", },
0xA8: { "idMostSigNib": 0, "idLeastSigByte": 0xA8, "name": "Ultima Weapon", "value": 8, "type": "Attack", "cpCost": 51, "element": "Physical", },
0xA9: { "idMostSigNib": 0, "idLeastSigByte": 0xA9, "name": "Ultima Weapon", "value": 9, "type": "Attack", "cpCost": 54, "element": "Physical", },
0xAA: { "idMostSigNib": 0, "idLeastSigByte": 0xAA, "name": "Fire", "value": 0, "type": "Magic", "cpCost": 24, "element": "Fire", },
0xAB: { "idMostSigNib": 0, "idLeastSigByte": 0xAB, "name": "Fire", "value": 1, "type": "Magic", "cpCost": 15, "element": "Fire", },
0xAC: { "idMostSigNib": 0, "idLeastSigByte": 0xAC, "name": "Fire", "value": 2, "type": "Magic", "cpCost": 16, "element": "Fire", },
0xAD: { "idMostSigNib": 0, "idLeastSigByte": 0xAD, "name": "Fire", "value": 3, "type": "Magic", "cpCost": 17, "element": "Fire", },
0xAE: { "idMostSigNib": 0, "idLeastSigByte": 0xAE, "name": "Fire", "value": 4, "type": "Magic", "cpCost": 18, "element": "Fire", },
0xAF: { "idMostSigNib": 0, "idLeastSigByte": 0xAF, "name": "Fire", "value": 5, "type": "Magic", "cpCost": 19, "element": "Fire", },
0xB0: { "idMostSigNib": 0, "idLeastSigByte": 0xB0, "name": "Fire", "value": 6, "type": "Magic", "cpCost": 20, "element": "Fire", },
0xB1: { "idMostSigNib": 0, "idLeastSigByte": 0xB1, "name": "Fire", "value": 7, "type": "Magic", "cpCost": 21, "element": "Fire", },
0xB2: { "idMostSigNib": 0, "idLeastSigByte": 0xB2, "name": "Fire", "value": 8, "type": "Magic", "cpCost": 22, "element": "Fire", },
0xB3: { "idMostSigNib": 0, "idLeastSigByte": 0xB3, "name": "Fire", "value": 9, "type": "Magic", "cpCost": 23, "element": "Fire", },
0xB4: { "idMostSigNib": 0, "idLeastSigByte": 0xB4, "name": "Blizzard", "value": 0, "type": "Magic", "cpCost": 24, "element": "Ice", },
0xB5: { "idMostSigNib": 0, "idLeastSigByte": 0xB5, "name": "Blizzard", "value": 1, "type": "Magic", "cpCost": 15, "element": "Ice", },
0xB6: { "idMostSigNib": 0, "idLeastSigByte": 0xB6, "name": "Blizzard", "value": 2, "type": "Magic", "cpCost": 16, "element": "Ice", },
0xB7: { "idMostSigNib": 0, "idLeastSigByte": 0xB7, "name": "Blizzard", "value": 3, "type": "Magic", "cpCost": 17, "element": "Ice", },
0xB8: { "idMostSigNib": 0, "idLeastSigByte": 0xB8, "name": "Blizzard", "value": 4, "type": "Magic", "cpCost": 18, "element": "Ice", },
0xB9: { "idMostSigNib": 0, "idLeastSigByte": 0xB9, "name": "Blizzard", "value": 5, "type": "Magic", "cpCost": 19, "element": "Ice", },
0xBA: { "idMostSigNib": 0, "idLeastSigByte": 0xBA, "name": "Blizzard", "value": 6, "type": "Magic", "cpCost": 20, "element": "Ice", },
0xBB: { "idMostSigNib": 0, "idLeastSigByte": 0xBB, "name": "Blizzard", "value": 7, "type": "Magic", "cpCost": 21, "element": "Ice", },
0xBC: { "idMostSigNib": 0, "idLeastSigByte": 0xBC, "name": "Blizzard", "value": 8, "type": "Magic", "cpCost": 22, "element": "Ice", },
0xBD: { "idMostSigNib": 0, "idLeastSigByte": 0xBD, "name": "Blizzard", "value": 9, "type": "Magic", "cpCost": 23, "element": "Ice", },
0xBE: { "idMostSigNib": 0, "idLeastSigByte": 0xBE, "name": "Thunder", "value": 0, "type": "Magic", "cpCost": 24, "element": "Lightning", },
0xBF: { "idMostSigNib": 0, "idLeastSigByte": 0xBF, "name": "Thunder", "value": 1, "type": "Magic", "cpCost": 15, "element": "Lightning", },
0xC0: { "idMostSigNib": 0, "idLeastSigByte": 0xC0, "name": "Thunder", "value": 2, "type": "Magic", "cpCost": 16, "element": "Lightning", },
0xC1: { "idMostSigNib": 0, "idLeastSigByte": 0xC1, "name": "Thunder", "value": 3, "type": "Magic", "cpCost": 17, "element": "Lightning", },
0xC2: { "idMostSigNib": 0, "idLeastSigByte": 0xC2, "name": "Thunder", "value": 4, "type": "Magic", "cpCost": 18, "element": "Lightning", },
0xC3: { "idMostSigNib": 0, "idLeastSigByte": 0xC3, "name": "Thunder", "value": 5, "type": "Magic", "cpCost": 19, "element": "Lightning", },
0xC4: { "idMostSigNib": 0, "idLeastSigByte": 0xC4, "name": "Thunder", "value": 6, "type": "Magic", "cpCost": 20, "element": "Lightning", },
0xC5: { "idMostSigNib": 0, "idLeastSigByte": 0xC5, "name": "Thunder", "value": 7, "type": "Magic", "cpCost": 21, "element": "Lightning", },
0xC6: { "idMostSigNib": 0, "idLeastSigByte": 0xC6, "name": "Thunder", "value": 8, "type": "Magic", "cpCost": 22, "element": "Lightning", },
0xC7: { "idMostSigNib": 0, "idLeastSigByte": 0xC7, "name": "Thunder", "value": 9, "type": "Magic", "cpCost": 23, "element": "Lightning", },
0xC8: { "idMostSigNib": 0, "idLeastSigByte": 0xC8, "name": "Cure", "value": 0, "type": "Magic", "cpCost": 43, "element": "N/A", },
0xC9: { "idMostSigNib": 0, "idLeastSigByte": 0xC9, "name": "Cure", "value": 1, "type": "Magic", "cpCost": 25, "element": "N/A", },
0xCA: { "idMostSigNib": 0, "idLeastSigByte": 0xCA, "name": "Cure", "value": 2, "type": "Magic", "cpCost": 27, "element": "N/A", },
0xCB: { "idMostSigNib": 0, "idLeastSigByte": 0xCB, "name": "Cure", "value": 3, "type": "Magic", "cpCost": 29, "element": "N/A", },
0xCC: { "idMostSigNib": 0, "idLeastSigByte": 0xCC, "name": "Cure", "value": 4, "type": "Magic", "cpCost": 31, "element": "N/A", },
0xCD: { "idMostSigNib": 0, "idLeastSigByte": 0xCD, "name": "Cure", "value": 5, "type": "Magic", "cpCost": 33, "element": "N/A", },
0xCE: { "idMostSigNib": 0, "idLeastSigByte": 0xCE, "name": "Cure", "value": 6, "type": "Magic", "cpCost": 35, "element": "N/A", },
0xCF: { "idMostSigNib": 0, "idLeastSigByte": 0xCF, "name": "Cure", "value": 7, "type": "Magic", "cpCost": 37, "element": "N/A", },
0xD0: { "idMostSigNib": 0, "idLeastSigByte": 0xD0, "name": "Cure", "value": 8, "type": "Magic", "cpCost": 39, "element": "N/A", },
0xD1: { "idMostSigNib": 0, "idLeastSigByte": 0xD1, "name": "Cure", "value": 9, "type": "Magic", "cpCost": 41, "element": "N/A", },
0xD2: { "idMostSigNib": 0, "idLeastSigByte": 0xD2, "name": "Gravity", "value": 0, "type": "Magic", "cpCost": 38, "element": "N/A", },
0xD3: { "idMostSigNib": 0, "idLeastSigByte": 0xD3, "name": "Gravity", "value": 1, "type": "Magic", "cpCost": 20, "element": "N/A", },
0xD4: { "idMostSigNib": 0, "idLeastSigByte": 0xD4, "name": "Gravity", "value": 2, "type": "Magic", "cpCost": 22, "element": "N/A", },
0xD5: { "idMostSigNib": 0, "idLeastSigByte": 0xD5, "name": "Gravity", "value": 3, "type": "Magic", "cpCost": 24, "element": "N/A", },
0xD6: { "idMostSigNib": 0, "idLeastSigByte": 0xD6, "name": "Gravity", "value": 4, "type": "Magic", "cpCost": 26, "element": "N/A", },
0xD7: { "idMostSigNib": 0, "idLeastSigByte": 0xD7, "name": "Gravity", "value": 5, "type": "Magic", "cpCost": 28, "element": "N/A", },
0xD8: { "idMostSigNib": 0, "idLeastSigByte": 0xD8, "name": "Gravity", "value": 6, "type": "Magic", "cpCost": 30, "element": "N/A", },
0xD9: { "idMostSigNib": 0, "idLeastSigByte": 0xD9, "name": "Gravity", "value": 7, "type": "Magic", "cpCost": 32, "element": "N/A", },
0xDA: { "idMostSigNib": 0, "idLeastSigByte": 0xDA, "name": "Gravity", "value": 8, "type": "Magic", "cpCost": 34, "element": "N/A", },
0xDB: { "idMostSigNib": 0, "idLeastSigByte": 0xDB, "name": "Gravity", "value": 9, "type": "Magic", "cpCost": 36, "element": "N/A", },
0xDC: { "idMostSigNib": 0, "idLeastSigByte": 0xDC, "name": "Stop", "value": 0, "type": "Magic", "cpCost": 38, "element": "N/A", },
0xDD: { "idMostSigNib": 0, "idLeastSigByte": 0xDD, "name": "Stop", "value": 1, "type": "Magic", "cpCost": 20, "element": "N/A", },
0xDE: { "idMostSigNib": 0, "idLeastSigByte": 0xDE, "name": "Stop", "value": 2, "type": "Magic", "cpCost": 22, "element": "N/A", },
0xDF: { "idMostSigNib": 0, "idLeastSigByte": 0xDF, "name": "Stop", "value": 3, "type": "Magic", "cpCost": 24, "element": "N/A", },
0xE0: { "idMostSigNib": 0, "idLeastSigByte": 0xE0, "name": "Stop", "value": 4, "type": "Magic", "cpCost": 26, "element": "N/A", },
0xE1: { "idMostSigNib": 0, "idLeastSigByte": 0xE1, "name": "Stop", "value": 5, "type": "Magic", "cpCost": 28, "element": "N/A", },
0xE2: { "idMostSigNib": 0, "idLeastSigByte": 0xE2, "name": "Stop", "value": 6, "type": "Magic", "cpCost": 30, "element": "N/A", },
0xE3: { "idMostSigNib": 0, "idLeastSigByte": 0xE3, "name": "Stop", "value": 7, "type": "Magic", "cpCost": 32, "element": "N/A", },
0xE4: { "idMostSigNib": 0, "idLeastSigByte": 0xE4, "name": "Stop", "value": 8, "type": "Magic", "cpCost": 34, "element": "N/A", },
0xE5: { "idMostSigNib": 0, "idLeastSigByte": 0xE5, "name": "Stop", "value": 9, "type": "Magic", "cpCost": 36, "element": "N/A", },
0xE6: { "idMostSigNib": 0, "idLeastSigByte": 0xE6, "name": "Aero", "value": 0, "type": "Magic", "cpCost": 38, "element": "N/A", },
0xE7: { "idMostSigNib": 0, "idLeastSigByte": 0xE7, "name": "Aero", "value": 1, "type": "Magic", "cpCost": 20, "element": "N/A", },
0xE8: { "idMostSigNib": 0, "idLeastSigByte": 0xE8, "name": "Aero", "value": 2, "type": "Magic", "cpCost": 22, "element": "N/A", },
0xE9: { "idMostSigNib": 0, "idLeastSigByte": 0xE9, "name": "Aero", "value": 3, "type": "Magic", "cpCost": 24, "element": "N/A", },
0xEA: { "idMostSigNib": 0, "idLeastSigByte": 0xEA, "name": "Aero", "value": 4, "type": "Magic", "cpCost": 26, "element": "N/A", },
0xEB: { "idMostSigNib": 0, "idLeastSigByte": 0xEB, "name": "Aero", "value": 5, "type": "Magic", "cpCost": 28, "element": "N/A", },
0xEC: { "idMostSigNib": 0, "idLeastSigByte": 0xEC, "name": "Aero", "value": 6, "type": "Magic", "cpCost": 30, "element": "N/A", },
0xED: { "idMostSigNib": 0, "idLeastSigByte": 0xED, "name": "Aero", "value": 7, "type": "Magic", "cpCost": 32, "element": "N/A", },
0xEE: { "idMostSigNib": 0, "idLeastSigByte": 0xEE, "name": "Aero", "value": 8, "type": "Magic", "cpCost": 34, "element": "N/A", },
0xEF: { "idMostSigNib": 0, "idLeastSigByte": 0xEF, "name": "Aero", "value": 9, "type": "Magic", "cpCost": 36, "element": "N/A", },
0xF0: { "idMostSigNib": 0, "idLeastSigByte": 0xF0, "name": "Donald Duck", "value": 0, "type": "Friend", "cpCost": 38, "element": "N/A", },
0xF1: { "idMostSigNib": 0, "idLeastSigByte": 0xF1, "name": "Donald Duck", "value": 1, "type": "Friend", "cpCost": 20, "element": "N/A", },
0xF2: { "idMostSigNib": 0, "idLeastSigByte": 0xF2, "name": "Donald Duck", "value": 2, "type": "Friend", "cpCost": 22, "element": "N/A", },
0xF3: { "idMostSigNib": 0, "idLeastSigByte": 0xF3, "name": "Donald Duck", "value": 3, "type": "Friend", "cpCost": 24, "element": "N/A", },
0xF4: { "idMostSigNib": 0, "idLeastSigByte": 0xF4, "name": "Donald Duck", "value": 4, "type": "Friend", "cpCost": 26, "element": "N/A", },
0xF5: { "idMostSigNib": 0, "idLeastSigByte": 0xF5, "name": "Donald Duck", "value": 5, "type": "Friend", "cpCost": 28, "element": "N/A", },
0xF6: { "idMostSigNib": 0, "idLeastSigByte": 0xF6, "name": "Donald Duck", "value": 6, "type": "Friend", "cpCost": 30, "element": "N/A", },
0xF7: { "idMostSigNib": 0, "idLeastSigByte": 0xF7, "name": "Donald Duck", "value": 7, "type": "Friend", "cpCost": 32, "element": "N/A", },
0xF8: { "idMostSigNib": 0, "idLeastSigByte": 0xF8, "name": "Donald Duck", "value": 8, "type": "Friend", "cpCost": 34, "element": "N/A", },
0xF9: { "idMostSigNib": 0, "idLeastSigByte": 0xF9, "name": "Donald Duck", "value": 9, "type": "Friend", "cpCost": 36, "element": "N/A", },
0xFA: { "idMostSigNib": 0, "idLeastSigByte": 0xFA, "name": "Goofy", "value": 0, "type": "Friend", "cpCost": 38, "element": "N/A", },
0xFB: { "idMostSigNib": 0, "idLeastSigByte": 0xFB, "name": "Goofy", "value": 1, "type": "Friend", "cpCost": 20, "element": "N/A", },
0xFC: { "idMostSigNib": 0, "idLeastSigByte": 0xFC, "name": "Goofy", "value": 2, "type": "Friend", "cpCost": 22, "element": "N/A", },
0xFD: { "idMostSigNib": 0, "idLeastSigByte": 0xFD, "name": "Goofy", "value": 3, "type": "Friend", "cpCost": 24, "element": "N/A", },
0xFE: { "idMostSigNib": 0, "idLeastSigByte": 0xFE, "name": "Goofy", "value": 4, "type": "Friend", "cpCost": 26, "element": "N/A", },
0xFF: { "idMostSigNib": 0, "idLeastSigByte": 0xFF, "name": "Goofy", "value": 5, "type": "Friend", "cpCost": 28, "element": "N/A", },
0x100: { "idMostSigNib": 1, "idLeastSigByte": 0x0, "name": "Goofy", "value": 6, "type": "Friend", "cpCost": 30, "element": "N/A", },
0x101: { "idMostSigNib": 1, "idLeastSigByte": 0x1, "name": "Goofy", "value": 7, "type": "Friend", "cpCost": 32, "element": "N/A", },
0x102: { "idMostSigNib": 1, "idLeastSigByte": 0x2, "name": "Goofy", "value": 8, "type": "Friend", "cpCost": 34, "element": "N/A", },
0x103: { "idMostSigNib": 1, "idLeastSigByte": 0x3, "name": "Goofy", "value": 9, "type": "Friend", "cpCost": 36, "element": "N/A", },
0x104: { "idMostSigNib": 1, "idLeastSigByte": 0x4, "name": "Simba", "value": 0, "type": "Magic", "cpCost": 38, "element": "N/A", },
0x105: { "idMostSigNib": 1, "idLeastSigByte": 0x5, "name": "Simba", "value": 1, "type": "Magic", "cpCost": 20, "element": "N/A", },
0x106: { "idMostSigNib": 1, "idLeastSigByte": 0x6, "name": "Simba", "value": 2, "type": "Magic", "cpCost": 22, "element": "N/A", },
0x107: { "idMostSigNib": 1, "idLeastSigByte": 0x7, "name": "Simba", "value": 3, "type": "Magic", "cpCost": 24, "element": "N/A", },
0x108: { "idMostSigNib": 1, "idLeastSigByte": 0x8, "name": "Simba", "value": 4, "type": "Magic", "cpCost": 26, "element": "N/A", },
0x109: { "idMostSigNib": 1, "idLeastSigByte": 0x9, "name": "Simba", "value": 5, "type": "Magic", "cpCost": 28, "element": "N/A", },
0x10A: { "idMostSigNib": 1, "idLeastSigByte": 0xA, "name": "Simba", "value": 6, "type": "Magic", "cpCost": 30, "element": "N/A", },
0x10B: { "idMostSigNib": 1, "idLeastSigByte": 0xB, "name": "Simba", "value": 7, "type": "Magic", "cpCost": 32, "element": "N/A", },
0x10C: { "idMostSigNib": 1, "idLeastSigByte": 0xC, "name": "Simba", "value": 8, "type": "Magic", "cpCost": 34, "element": "N/A", },
0x10D: { "idMostSigNib": 1, "idLeastSigByte": 0xD, "name": "Simba", "value": 9, "type": "Magic", "cpCost": 36, "element": "N/A", },
0x10E: { "idMostSigNib": 1, "idLeastSigByte": 0xE, "name": "Genie", "value": 0, "type": "Magic", "cpCost": 38, "element": "N/A", },
0x10F: { "idMostSigNib": 1, "idLeastSigByte": 0xF, "name": "Genie", "value": 1, "type": "Magic", "cpCost": 20, "element": "N/A", },
0x110: { "idMostSigNib": 1, "idLeastSigByte": 0x10, "name": "Genie", "value": 2, "type": "Magic", "cpCost": 22, "element": "N/A", },
0x111: { "idMostSigNib": 1, "idLeastSigByte": 0x11, "name": "Genie", "value": 3, "type": "Magic", "cpCost": 24, "element": "N/A", },
0x112: { "idMostSigNib": 1, "idLeastSigByte": 0x12, "name": "Genie", "value": 4, "type": "Magic", "cpCost": 26, "element": "N/A", },
0x113: { "idMostSigNib": 1, "idLeastSigByte": 0x13, "name": "Genie", "value": 5, "type": "Magic", "cpCost": 28, "element": "N/A", },
0x114: { "idMostSigNib": 1, "idLeastSigByte": 0x14, "name": "Genie", "value": 6, "type": "Magic", "cpCost": 30, "element": "N/A", },
0x115: { "idMostSigNib": 1, "idLeastSigByte": 0x15, "name": "Genie", "value": 7, "type": "Magic", "cpCost": 32, "element": "N/A", },
0x116: { "idMostSigNib": 1, "idLeastSigByte": 0x16, "name": "Genie", "value": 8, "type": "Magic", "cpCost": 34, "element": "N/A", },
0x117: { "idMostSigNib": 1, "idLeastSigByte": 0x17, "name": "Genie", "value": 9, "type": "Magic", "cpCost": 36, "element": "N/A", },
0x118: { "idMostSigNib": 1, "idLeastSigByte": 0x18, "name": "Bambi", "value": 0, "type": "Magic", "cpCost": 38, "element": "N/A", },
0x119: { "idMostSigNib": 1, "idLeastSigByte": 0x19, "name": "Bambi", "value": 1, "type": "Magic", "cpCost": 20, "element": "N/A", },
0x11A: { "idMostSigNib": 1, "idLeastSigByte": 0x1A, "name": "Bambi", "value": 2, "type": "Magic", "cpCost": 22, "element": "N/A", },
0x11B: { "idMostSigNib": 1, "idLeastSigByte": 0x1B, "name": "Bambi", "value": 3, "type": "Magic", "cpCost": 24, "element": "N/A", },
0x11C: { "idMostSigNib": 1, "idLeastSigByte": 0x1C, "name": "Bambi", "value": 4, "type": "Magic", "cpCost": 26, "element": "N/A", },
0x11D: { "idMostSigNib": 1, "idLeastSigByte": 0x1D, "name": "Bambi", "value": 5, "type": "Magic", "cpCost": 28, "element": "N/A", },
0x11E: { "idMostSigNib": 1, "idLeastSigByte": 0x1E, "name": "Bambi", "value": 6, "type": "Magic", "cpCost": 30, "element": "N/A", },
0x11F: { "idMostSigNib": 1, "idLeastSigByte": 0x1F, "name": "Bambi", "value": 7, "type": "Magic", "cpCost": 32, "element": "N/A", },
0x120: { "idMostSigNib": 1, "idLeastSigByte": 0x20, "name": "Bambi", "value": 8, "type": "Magic", "cpCost": 34, "element": "N/A", },
0x121: { "idMostSigNib": 1, "idLeastSigByte": 0x21, "name": "Bambi", "value": 9, "type": "Magic", "cpCost": 36, "element": "N/A", },
0x122: { "idMostSigNib": 1, "idLeastSigByte": 0x22, "name": "Dumbo", "value": 0, "type": "Magic", "cpCost": 38, "element": "Ice", },
0x123: { "idMostSigNib": 1, "idLeastSigByte": 0x23, "name": "Dumbo", "value": 1, "type": "Magic", "cpCost": 20, "element": "Ice", },
0x124: { "idMostSigNib": 1, "idLeastSigByte": 0x24, "name": "Dumbo", "value": 2, "type": "Magic", "cpCost": 22, "element": "Ice", },
0x125: { "idMostSigNib": 1, "idLeastSigByte": 0x25, "name": "Dumbo", "value": 3, "type": "Magic", "cpCost": 24, "element": "Ice", },
0x126: { "idMostSigNib": 1, "idLeastSigByte": 0x26, "name": "Dumbo", "value": 4, "type": "Magic", "cpCost": 26, "element": "Ice", },
0x127: { "idMostSigNib": 1, "idLeastSigByte": 0x27, "name": "Dumbo", "value": 5, "type": "Magic", "cpCost": 28, "element": "Ice", },
0x128: { "idMostSigNib": 1, "idLeastSigByte": 0x28, "name": "Dumbo", "value": 6, "type": "Magic", "cpCost": 30, "element": "Ice", },
0x129: { "idMostSigNib": 1, "idLeastSigByte": 0x29, "name": "Dumbo", "value": 7, "type": "Magic", "cpCost": 32, "element": "Ice", },
0x12A: { "idMostSigNib": 1, "idLeastSigByte": 0x2A, "name": "Dumbo", "value": 8, "type": "Magic", "cpCost": 34, "element": "Ice", },
0x12B: { "idMostSigNib": 1, "idLeastSigByte": 0x2B, "name": "Dumbo", "value": 9, "type": "Magic", "cpCost": 36, "element": "Ice", },
0x12C: { "idMostSigNib": 1, "idLeastSigByte": 0x2C, "name": "Tinker Bell", "value": 0, "type": "Magic", "cpCost": 38, "element": "N/A", },
0x12D: { "idMostSigNib": 1, "idLeastSigByte": 0x2D, "name": "Tinker Bell", "value": 1, "type": "Magic", "cpCost": 20, "element": "N/A", },
0x12E: { "idMostSigNib": 1, "idLeastSigByte": 0x2E, "name": "Tinker Bell", "value": 2, "type": "Magic", "cpCost": 22, "element": "N/A", },
0x12F: { "idMostSigNib": 1, "idLeastSigByte": 0x2F, "name": "Tinker Bell", "value": 3, "type": "Magic", "cpCost": 24, "element": "N/A", },
0x130: { "idMostSigNib": 1, "idLeastSigByte": 0x30, "name": "Tinker Bell", "value": 4, "type": "Magic", "cpCost": 26, "element": "N/A", },
0x131: { "idMostSigNib": 1, "idLeastSigByte": 0x31, "name": "Tinker Bell", "value": 5, "type": "Magic", "cpCost": 28, "element": "N/A", },
0x132: { "idMostSigNib": 1, "idLeastSigByte": 0x32, "name": "Tinker Bell", "value": 6, "type": "Magic", "cpCost": 30, "element": "N/A", },
0x133: { "idMostSigNib": 1, "idLeastSigByte": 0x33, "name": "Tinker Bell", "value": 7, "type": "Magic", "cpCost": 32, "element": "N/A", },
0x134: { "idMostSigNib": 1, "idLeastSigByte": 0x34, "name": "Tinker Bell", "value": 8, "type": "Magic", "cpCost": 34, "element": "N/A", },
0x135: { "idMostSigNib": 1, "idLeastSigByte": 0x35, "name": "Tinker Bell", "value": 9, "type": "Magic", "cpCost": 36, "element": "N/A", },
0x136: { "idMostSigNib": 1, "idLeastSigByte": 0x36, "name": "Mushu", "value": 0, "type": "Magic", "cpCost": 43, "element": "Fire", },
0x137: { "idMostSigNib": 1, "idLeastSigByte": 0x37, "name": "Mushu", "value": 1, "type": "Magic", "cpCost": 25, "element": "Fire", },
0x138: { "idMostSigNib": 1, "idLeastSigByte": 0x38, "name": "Mushu", "value": 2, "type": "Magic", "cpCost": 27, "element": "Fire", },
0x139: { "idMostSigNib": 1, "idLeastSigByte": 0x39, "name": "Mushu", "value": 3, "type": "Magic", "cpCost": 29, "element": "Fire", },
0x13A: { "idMostSigNib": 1, "idLeastSigByte": 0x3A, "name": "Mushu", "value": 4, "type": "Magic", "cpCost": 31, "element": "Fire", },
0x13B: { "idMostSigNib": 1, "idLeastSigByte": 0x3B, "name": "Mushu", "value": 5, "type": "Magic", "cpCost": 33, "element": "Fire", },
0x13C: { "idMostSigNib": 1, "idLeastSigByte": 0x3C, "name": "Mushu", "value": 6, "type": "Magic", "cpCost": 35, "element": "Fire", },
0x13D: { "idMostSigNib": 1, "idLeastSigByte": 0x3D, "name": "Mushu", "value": 7, "type": "Magic", "cpCost": 37, "element": "Fire", },
0x13E: { "idMostSigNib": 1, "idLeastSigByte": 0x3E, "name": "Mushu", "value": 8, "type": "Magic", "cpCost": 39, "element": "Fire", },
0x13F: { "idMostSigNib": 1, "idLeastSigByte": 0x3F, "name": "Mushu", "value": 9, "type": "Magic", "cpCost": 41, "element": "Fire", },
0x140: { "idMostSigNib": 1, "idLeastSigByte": 0x40, "name": "Cloud", "value": 0, "type": "Magic", "cpCost": 43, "element": "N/A", },
0x141: { "idMostSigNib": 1, "idLeastSigByte": 0x41, "name": "Cloud", "value": 1, "type": "Magic", "cpCost": 25, "element": "N/A", },
0x142: { "idMostSigNib": 1, "idLeastSigByte": 0x42, "name": "Cloud", "value": 2, "type": "Magic", "cpCost": 27, "element": "N/A", },
0x143: { "idMostSigNib": 1, "idLeastSigByte": 0x43, "name": "Cloud", "value": 3, "type": "Magic", "cpCost": 29, "element": "N/A", },
0x144: { "idMostSigNib": 1, "idLeastSigByte": 0x44, "name": "Cloud", "value": 4, "type": "Magic", "cpCost": 31, "element": "N/A", },
0x145: { "idMostSigNib": 1, "idLeastSigByte": 0x45, "name": "Cloud", "value": 5, "type": "Magic", "cpCost": 33, "element": "N/A", },
0x146: { "idMostSigNib": 1, "idLeastSigByte": 0x46, "name": "Cloud", "value": 6, "type": "Magic", "cpCost": 35, "element": "N/A", },
0x147: { "idMostSigNib": 1, "idLeastSigByte": 0x47, "name": "Cloud", "value": 7, "type": "Magic", "cpCost": 37, "element": "N/A", },
0x148: { "idMostSigNib": 1, "idLeastSigByte": 0x48, "name": "Cloud", "value": 8, "type": "Magic", "cpCost": 39, "element": "N/A", },
0x149: { "idMostSigNib": 1, "idLeastSigByte": 0x49, "name": "Cloud", "value": 9, "type": "Magic", "cpCost": 41, "element": "N/A", },
0x14A: { "idMostSigNib": 1, "idLeastSigByte": 0x4A, "name": "Aladdin", "value": 0, "type": "Friend", "cpCost": 43, "element": "N/A", },
0x14B: { "idMostSigNib": 1, "idLeastSigByte": 0x4B, "name": "Aladdin", "value": 1, "type": "Friend", "cpCost": 25, "element": "N/A", },
0x14C: { "idMostSigNib": 1, "idLeastSigByte": 0x4C, "name": "Aladdin", "value": 2, "type": "Friend", "cpCost": 27, "element": "N/A", },
0x14D: { "idMostSigNib": 1, "idLeastSigByte": 0x4D, "name": "Aladdin", "value": 3, "type": "Friend", "cpCost": 29, "element": "N/A", },
0x14E: { "idMostSigNib": 1, "idLeastSigByte": 0x4E, "name": "Aladdin", "value": 4, "type": "Friend", "cpCost": 31, "element": "N/A", },
0x14F: { "idMostSigNib": 1, "idLeastSigByte": 0x4F, "name": "Aladdin", "value": 5, "type": "Friend", "cpCost": 33, "element": "N/A", },
0x150: { "idMostSigNib": 1, "idLeastSigByte": 0x50, "name": "Aladdin", "value": 6, "type": "Friend", "cpCost": 35, "element": "N/A", },
0x151: { "idMostSigNib": 1, "idLeastSigByte": 0x51, "name": "Aladdin", "value": 7, "type": "Friend", "cpCost": 37, "element": "N/A", },
0x152: { "idMostSigNib": 1, "idLeastSigByte": 0x52, "name": "Aladdin", "value": 8, "type": "Friend", "cpCost": 39, "element": "N/A", },
0x153: { "idMostSigNib": 1, "idLeastSigByte": 0x53, "name": "Aladdin", "value": 9, "type": "Friend", "cpCost": 41, "element": "N/A", },
0x154: { "idMostSigNib": 1, "idLeastSigByte": 0x54, "name": "Ariel", "value": 0, "type": "Friend", "cpCost": 43, "element": "N/A", },
0x155: { "idMostSigNib": 1, "idLeastSigByte": 0x55, "name": "Ariel", "value": 1, "type": "Friend", "cpCost": 25, "element": "N/A", },
0x156: { "idMostSigNib": 1, "idLeastSigByte": 0x56, "name": "Ariel", "value": 2, "type": "Friend", "cpCost": 27, "element": "N/A", },
0x157: { "idMostSigNib": 1, "idLeastSigByte": 0x57, "name": "Ariel", "value": 3, "type": "Friend", "cpCost": 29, "element": "N/A", },
0x158: { "idMostSigNib": 1, "idLeastSigByte": 0x58, "name": "Ariel", "value": 4, "type": "Friend", "cpCost": 31, "element": "N/A", },
0x159: { "idMostSigNib": 1, "idLeastSigByte": 0x59, "name": "Ariel", "value": 5, "type": "Friend", "cpCost": 33, "element": "N/A", },
0x15A: { "idMostSigNib": 1, "idLeastSigByte": 0x5A, "name": "Ariel", "value": 6, "type": "Friend", "cpCost": 35, "element": "N/A", },
0x15B: { "idMostSigNib": 1, "idLeastSigByte": 0x5B, "name": "Ariel", "value": 7, "type": "Friend", "cpCost": 37, "element": "N/A", },
0x15C: { "idMostSigNib": 1, "idLeastSigByte": 0x5C, "name": "Ariel", "value": 8, "type": "Friend", "cpCost": 39, "element": "N/A", },
0x15D: { "idMostSigNib": 1, "idLeastSigByte": 0x5D, "name": "Ariel", "value": 9, "type": "Friend", "cpCost": 41, "element": "N/A", },
0x15E: { "idMostSigNib": 1, "idLeastSigByte": 0x5E, "name": "Jack", "value": 0, "type": "Friend", "cpCost": 43, "element": "N/A", },
0x15F: { "idMostSigNib": 1, "idLeastSigByte": 0x5F, "name": "Jack", "value": 1, "type": "Friend", "cpCost": 25, "element": "N/A", },
0x160: { "idMostSigNib": 1, "idLeastSigByte": 0x60, "name": "Jack", "value": 2, "type": "Friend", "cpCost": 27, "element": "N/A", },
0x161: { "idMostSigNib": 1, "idLeastSigByte": 0x61, "name": "Jack", "value": 3, "type": "Friend", "cpCost": 29, "element": "N/A", },
0x162: { "idMostSigNib": 1, "idLeastSigByte": 0x62, "name": "Jack", "value": 4, "type": "Friend", "cpCost": 31, "element": "N/A", },
0x163: { "idMostSigNib": 1, "idLeastSigByte": 0x63, "name": "Jack", "value": 5, "type": "Friend", "cpCost": 33, "element": "N/A", },
0x164: { "idMostSigNib": 1, "idLeastSigByte": 0x64, "name": "Jack", "value": 6, "type": "Friend", "cpCost": 35, "element": "N/A", },
0x165: { "idMostSigNib": 1, "idLeastSigByte": 0x65, "name": "Jack", "value": 7, "type": "Friend", "cpCost": 37, "element": "N/A", },
0x166: { "idMostSigNib": 1, "idLeastSigByte": 0x66, "name": "Jack", "value": 8, "type": "Friend", "cpCost": 39, "element": "N/A", },
0x167: { "idMostSigNib": 1, "idLeastSigByte": 0x67, "name": "Jack", "value": 9, "type": "Friend", "cpCost": 41, "element": "N/A", },
0x168: { "idMostSigNib": 1, "idLeastSigByte": 0x68, "name": "Peter Pan", "value": 0, "type": "Friend", "cpCost": 43, "element": "N/A", },
0x169: { "idMostSigNib": 1, "idLeastSigByte": 0x69, "name": "Peter Pan", "value": 1, "type": "Friend", "cpCost": 25, "element": "N/A", },
0x16A: { "idMostSigNib": 1, "idLeastSigByte": 0x6A, "name": "Peter Pan", "value": 2, "type": "Friend", "cpCost": 27, "element": "N/A", },
0x16B: { "idMostSigNib": 1, "idLeastSigByte": 0x6B, "name": "Peter Pan", "value": 3, "type": "Friend", "cpCost": 29, "element": "N/A", },
0x16C: { "idMostSigNib": 1, "idLeastSigByte": 0x6C, "name": "Peter Pan", "value": 4, "type": "Friend", "cpCost": 31, "element": "N/A", },
0x16D: { "idMostSigNib": 1, "idLeastSigByte": 0x6D, "name": "Peter Pan", "value": 5, "type": "Friend", "cpCost": 33, "element": "N/A", },
0x16E: { "idMostSigNib": 1, "idLeastSigByte": 0x6E, "name": "Peter Pan", "value": 6, "type": "Friend", "cpCost": 35, "element": "N/A", },
0x16F: { "idMostSigNib": 1, "idLeastSigByte": 0x6F, "name": "Peter Pan", "value": 7, "type": "Friend", "cpCost": 37, "element": "N/A", },
0x170: { "idMostSigNib": 1, "idLeastSigByte": 0x70, "name": "Peter Pan", "value": 8, "type": "Friend", "cpCost": 39, "element": "N/A", },
0x171: { "idMostSigNib": 1, "idLeastSigByte": 0x71, "name": "Peter Pan", "value": 9, "type": "Friend", "cpCost": 41, "element": "N/A", },
0x172: { "idMostSigNib": 1, "idLeastSigByte": 0x72, "name": "The Beast", "value": 0, "type": "Friend", "cpCost": 43, "element": "N/A", },
0x173: { "idMostSigNib": 1, "idLeastSigByte": 0x73, "name": "The Beast", "value": 1, "type": "Friend", "cpCost": 25, "element": "N/A", },
0x174: { "idMostSigNib": 1, "idLeastSigByte": 0x74, "name": "The Beast", "value": 2, "type": "Friend", "cpCost": 27, "element": "N/A", },
0x175: { "idMostSigNib": 1, "idLeastSigByte": 0x75, "name": "The Beast", "value": 3, "type": "Friend", "cpCost": 29, "element": "N/A", },
0x176: { "idMostSigNib": 1, "idLeastSigByte": 0x76, "name": "The Beast", "value": 4, "type": "Friend", "cpCost": 31, "element": "N/A", },
0x177: { "idMostSigNib": 1, "idLeastSigByte": 0x77, "name": "The Beast", "value": 5, "type": "Friend", "cpCost": 33, "element": "N/A", },
0x178: { "idMostSigNib": 1, "idLeastSigByte": 0x78, "name": "The Beast", "value": 6, "type": "Friend", "cpCost": 35, "element": "N/A", },
0x179: { "idMostSigNib": 1, "idLeastSigByte": 0x79, "name": "The Beast", "value": 7, "type": "Friend", "cpCost": 37, "element": "N/A", },
0x17A: { "idMostSigNib": 1, "idLeastSigByte": 0x7A, "name": "The Beast", "value": 8, "type": "Friend", "cpCost": 39, "element": "N/A", },
0x17B: { "idMostSigNib": 1, "idLeastSigByte": 0x7B, "name": "The Beast", "value": 9, "type": "Friend", "cpCost": 41, "element": "N/A", },
0x17C: { "idMostSigNib": 1, "idLeastSigByte": 0x7C, "name": "Potion", "value": 0, "type": "Item", "cpCost": 57, "element": "N/A", },
0x17D: { "idMostSigNib": 1, "idLeastSigByte": 0x7D, "name": "Potion", "value": 1, "type": "Item", "cpCost": 30, "element": "N/A", },
0x17E: { "idMostSigNib": 1, "idLeastSigByte": 0x7E, "name": "Potion", "value": 2, "type": "Item", "cpCost": 33, "element": "N/A", },
0x17F: { "idMostSigNib": 1, "idLeastSigByte": 0x7F, "name": "Potion", "value": 3, "type": "Item", "cpCost": 36, "element": "N/A", },
0x180: { "idMostSigNib": 1, "idLeastSigByte": 0x80, "name": "Potion", "value": 4, "type": "Item", "cpCost": 39, "element": "N/A", },
0x181: { "idMostSigNib": 1, "idLeastSigByte": 0x81, "name": "Potion", "value": 5, "type": "Item", "cpCost": 42, "element": "N/A", },
0x182: { "idMostSigNib": 1, "idLeastSigByte": 0x82, "name": "Potion", "value": 6, "type": "Item", "cpCost": 45, "element": "N/A", },
0x183: { "idMostSigNib": 1, "idLeastSigByte": 0x83, "name": "Potion", "value": 7, "type": "Item", "cpCost": 48, "element": "N/A", },
0x184: { "idMostSigNib": 1, "idLeastSigByte": 0x84, "name": "Potion", "value": 8, "type": "Item", "cpCost": 51, "element": "N/A", },
0x185: { "idMostSigNib": 1, "idLeastSigByte": 0x85, "name": "Potion", "value": 9, "type": "Item", "cpCost": 54, "element": "N/A", },
0x186: { "idMostSigNib": 1, "idLeastSigByte": 0x86, "name": "Hi-Potion", "value": 0, "type": "Item", "cpCost": 76, "element": "N/A", },
0x187: { "idMostSigNib": 1, "idLeastSigByte": 0x87, "name": "Hi-Potion", "value": 1, "type": "Item", "cpCost": 40, "element": "N/A", },
0x188: { "idMostSigNib": 1, "idLeastSigByte": 0x88, "name": "Hi-Potion", "value": 2, "type": "Item", "cpCost": 44, "element": "N/A", },
0x189: { "idMostSigNib": 1, "idLeastSigByte": 0x89, "name": "Hi-Potion", "value": 3, "type": "Item", "cpCost": 48, "element": "N/A", },
0x18A: { "idMostSigNib": 1, "idLeastSigByte": 0x8A, "name": "Hi-Potion", "value": 4, "type": "Item", "cpCost": 52, "element": "N/A", },
0x18B: { "idMostSigNib": 1, "idLeastSigByte": 0x8B, "name": "Hi-Potion", "value": 5, "type": "Item", "cpCost": 56, "element": "N/A", },
0x18C: { "idMostSigNib": 1, "idLeastSigByte": 0x8C, "name": "Hi-Potion", "value": 6, "type": "Item", "cpCost": 60, "element": "N/A", },
0x18D: { "idMostSigNib": 1, "idLeastSigByte": 0x8D, "name": "Hi-Potion", "value": 7, "type": "Item", "cpCost": 64, "element": "N/A", },
0x18E: { "idMostSigNib": 1, "idLeastSigByte": 0x8E, "name": "Hi-Potion", "value": 8, "type": "Item", "cpCost": 68, "element": "N/A", },
0x18F: { "idMostSigNib": 1, "idLeastSigByte": 0x8F, "name": "Hi-Potion", "value": 9, "type": "Item", "cpCost": 72, "element": "N/A", },
0x190: { "idMostSigNib": 1, "idLeastSigByte": 0x90, "name": "Mega-Potion", "value": 0, "type": "Item", "cpCost": 81, "element": "N/A", },
0x191: { "idMostSigNib": 1, "idLeastSigByte": 0x91, "name": "Mega-Potion", "value": 1, "type": "Item", "cpCost": 45, "element": "N/A", },
0x192: { "idMostSigNib": 1, "idLeastSigByte": 0x92, "name": "Mega-Potion", "value": 2, "type": "Item", "cpCost": 49, "element": "N/A", },
0x193: { "idMostSigNib": 1, "idLeastSigByte": 0x93, "name": "Mega-Potion", "value": 3, "type": "Item", "cpCost": 53, "element": "N/A", },
0x194: { "idMostSigNib": 1, "idLeastSigByte": 0x94, "name": "Mega-Potion", "value": 4, "type": "Item", "cpCost": 57, "element": "N/A", },
0x195: { "idMostSigNib": 1, "idLeastSigByte": 0x95, "name": "Mega-Potion", "value": 5, "type": "Item", "cpCost": 61, "element": "N/A", },
0x196: { "idMostSigNib": 1, "idLeastSigByte": 0x96, "name": "Mega-Potion", "value": 6, "type": "Item", "cpCost": 65, "element": "N/A", },
0x197: { "idMostSigNib": 1, "idLeastSigByte": 0x97, "name": "Mega-Potion", "value": 7, "type": "Item", "cpCost": 69, "element": "N/A", },
0x198: { "idMostSigNib": 1, "idLeastSigByte": 0x98, "name": "Mega-Potion", "value": 8, "type": "Item", "cpCost": 73, "element": "N/A", },
0x199: { "idMostSigNib": 1, "idLeastSigByte": 0x99, "name": "Mega-Potion", "value": 9, "type": "Item", "cpCost": 77, "element": "N/A", },
0x19A: { "idMostSigNib": 1, "idLeastSigByte": 0x9A, "name": "Ether", "value": 0, "type": "Item", "cpCost": 38, "element": "N/A", },
0x19B: { "idMostSigNib": 1, "idLeastSigByte": 0x9B, "name": "Ether", "value": 1, "type": "Item", "cpCost": 20, "element": "N/A", },
0x19C: { "idMostSigNib": 1, "idLeastSigByte": 0x9C, "name": "Ether", "value": 2, "type": "Item", "cpCost": 22, "element": "N/A", },
0x19D: { "idMostSigNib": 1, "idLeastSigByte": 0x9D, "name": "Ether", "value": 3, "type": "Item", "cpCost": 24, "element": "N/A", },
0x19E: { "idMostSigNib": 1, "idLeastSigByte": 0x9E, "name": "Ether", "value": 4, "type": "Item", "cpCost": 26, "element": "N/A", },
0x19F: { "idMostSigNib": 1, "idLeastSigByte": 0x9F, "name": "Ether", "value": 5, "type": "Item", "cpCost": 28, "element": "N/A", },
0x1A0: { "idMostSigNib": 1, "idLeastSigByte": 0xA0, "name": "Ether", "value": 6, "type": "Item", "cpCost": 30, "element": "N/A", },
0x1A1: { "idMostSigNib": 1, "idLeastSigByte": 0xA1, "name": "Ether", "value": 7, "type": "Item", "cpCost": 32, "element": "N/A", },
0x1A2: { "idMostSigNib": 1, "idLeastSigByte": 0xA2, "name": "Ether", "value": 8, "type": "Item", "cpCost": 34, "element": "N/A", },
0x1A3: { "idMostSigNib": 1, "idLeastSigByte": 0xA3, "name": "Ether", "value": 9, "type": "Item", "cpCost": 36, "element": "N/A", },
0x1A4: { "idMostSigNib": 1, "idLeastSigByte": 0xA4, "name": "Mega-Ether", "value": 0, "type": "Item", "cpCost": 62, "element": "N/A", },
0x1A5: { "idMostSigNib": 1, "idLeastSigByte": 0xA5, "name": "Mega-Ether", "value": 1, "type": "Item", "cpCost": 35, "element": "N/A", },
0x1A6: { "idMostSigNib": 1, "idLeastSigByte": 0xA6, "name": "Mega-Ether", "value": 2, "type": "Item", "cpCost": 38, "element": "N/A", },
0x1A7: { "idMostSigNib": 1, "idLeastSigByte": 0xA7, "name": "Mega-Ether", "value": 3, "type": "Item", "cpCost": 41, "element": "N/A", },
0x1A8: { "idMostSigNib": 1, "idLeastSigByte": 0xA8, "name": "Mega-Ether", "value": 4, "type": "Item", "cpCost": 44, "element": "N/A", },
0x1A9: { "idMostSigNib": 1, "idLeastSigByte": 0xA9, "name": "Mega-Ether", "value": 5, "type": "Item", "cpCost": 47, "element": "N/A", },
0x1AA: { "idMostSigNib": 1, "idLeastSigByte": 0xAA, "name": "Mega-Ether", "value": 6, "type": "Item", "cpCost": 50, "element": "N/A", },
0x1AB: { "idMostSigNib": 1, "idLeastSigByte": 0xAB, "name": "Mega-Ether", "value": 7, "type": "Item", "cpCost": 53, "element": "N/A", },
0x1AC: { "idMostSigNib": 1, "idLeastSigByte": 0xAC, "name": "Mega-Ether", "value": 8, "type": "Item", "cpCost": 56, "element": "N/A", },
0x1AD: { "idMostSigNib": 1, "idLeastSigByte": 0xAD, "name": "Mega-Ether", "value": 9, "type": "Item", "cpCost": 59, "element": "N/A", },
0x1AE: { "idMostSigNib": 1, "idLeastSigByte": 0xAE, "name": "Elixir", "value": 0, "type": "Item", "cpCost": 81, "element": "N/A", },
0x1AF: { "idMostSigNib": 1, "idLeastSigByte": 0xAF, "name": "Elixir", "value": 1, "type": "Item", "cpCost": 45, "element": "N/A", },
0x1B0: { "idMostSigNib": 1, "idLeastSigByte": 0xB0, "name": "Elixir", "value": 2, "type": "Item", "cpCost": 49, "element": "N/A", },
0x1B1: { "idMostSigNib": 1, "idLeastSigByte": 0xB1, "name": "Elixir", "value": 3, "type": "Item", "cpCost": 53, "element": "N/A", },
0x1B2: { "idMostSigNib": 1, "idLeastSigByte": 0xB2, "name": "Elixir", "value": 4, "type": "Item", "cpCost": 57, "element": "N/A", },
0x1B3: { "idMostSigNib": 1, "idLeastSigByte": 0xB3, "name": "Elixir", "value": 5, "type": "Item", "cpCost": 61, "element": "N/A", },
0x1B4: { "idMostSigNib": 1, "idLeastSigByte": 0xB4, "name": "Elixir", "value": 6, "type": "Item", "cpCost": 65, "element": "N/A", },
0x1B5: { "idMostSigNib": 1, "idLeastSigByte": 0xB5, "name": "Elixir", "value": 7, "type": "Item", "cpCost": 69, "element": "N/A", },
0x1B6: { "idMostSigNib": 1, "idLeastSigByte": 0xB6, "name": "Elixir", "value": 8, "type": "Item", "cpCost": 73, "element": "N/A", },
0x1B7: { "idMostSigNib": 1, "idLeastSigByte": 0xB7, "name": "Elixir", "value": 9, "type": "Item", "cpCost": 77, "element": "N/A", },
0x1B8: { "idMostSigNib": 1, "idLeastSigByte": 0xB8, "name": "Megalixir", "value": 0, "type": "Item", "cpCost": 95, "element": "N/A", },
0x1B9: { "idMostSigNib": 1, "idLeastSigByte": 0xB9, "name": "Megalixir", "value": 1, "type": "Item", "cpCost": 50, "element": "N/A", },
0x1BA: { "idMostSigNib": 1, "idLeastSigByte": 0xBA, "name": "Megalixir", "value": 2, "type": "Item", "cpCost": 55, "element": "N/A", },
0x1BB: { "idMostSigNib": 1, "idLeastSigByte": 0xBB, "name": "Megalixir", "value": 3, "type": "Item", "cpCost": 60, "element": "N/A", },
0x1BC: { "idMostSigNib": 1, "idLeastSigByte": 0xBC, "name": "Megalixir", "value": 4, "type": "Item", "cpCost": 65, "element": "N/A", },
0x1BD: { "idMostSigNib": 1, "idLeastSigByte": 0xBD, "name": "Megalixir", "value": 5, "type": "Item", "cpCost": 70, "element": "N/A", },
0x1BE: { "idMostSigNib": 1, "idLeastSigByte": 0xBE, "name": "Megalixir", "value": 6, "type": "Item", "cpCost": 75, "element": "N/A", },
0x1BF: { "idMostSigNib": 1, "idLeastSigByte": 0xBF, "name": "Megalixir", "value": 7, "type": "Item", "cpCost": 80, "element": "N/A", },
0x1C0: { "idMostSigNib": 1, "idLeastSigByte": 0xC0, "name": "Megalixir", "value": 8, "type": "Item", "cpCost": 85, "element": "N/A", },
0x1C1: { "idMostSigNib": 1, "idLeastSigByte": 0xC1, "name": "Megalixir", "value": 9, "type": "Item", "cpCost": 90, "element": "N/A", },
0x1C2: { "idMostSigNib": 1, "idLeastSigByte": 0xC2, "name": "Shadow", "value": -1, "type": "Enemy", "cpCost": 25, "element": "N/A", },
0x1C3: { "idMostSigNib": 1, "idLeastSigByte": 0xC3, "name": "Shadow", "value": -1, "type": "Enemy", "cpCost": 25, "element": "N/A", },
0x1C4: { "idMostSigNib": 1, "idLeastSigByte": 0xC4, "name": "Shadow", "value": -1, "type": "Enemy", "cpCost": 25, "element": "N/A", },
0x1C5: { "idMostSigNib": 1, "idLeastSigByte": 0xC5, "name": "Soldier", "value": -1, "type": "Enemy", "cpCost": 25, "element": "N/A", },
0x1C6: { "idMostSigNib": 1, "idLeastSigByte": 0xC6, "name": "Soldier", "value": -1, "type": "Enemy", "cpCost": 25, "element": "N/A", },
0x1C7: { "idMostSigNib": 1, "idLeastSigByte": 0xC7, "name": "Soldier", "value": -1, "type": "Enemy", "cpCost": 25, "element": "N/A", },
0x1C8: { "idMostSigNib": 1, "idLeastSigByte": 0xC8, "name": "Large Body", "value": -1, "type": "Enemy", "cpCost": 40, "element": "N/A", },
0x1C9: { "idMostSigNib": 1, "idLeastSigByte": 0xC9, "name": "Large Body", "value": -1, "type": "Enemy", "cpCost": 40, "element": "N/A", },
0x1CA: { "idMostSigNib": 1, "idLeastSigByte": 0xCA, "name": "Large Body", "value": -1, "type": "Enemy", "cpCost": 40, "element": "N/A", },
0x1CB: { "idMostSigNib": 1, "idLeastSigByte": 0xCB, "name": "Red Nocturne", "value": -1, "type": "Enemy", "cpCost": 20, "element": "N/A", },
0x1CC: { "idMostSigNib": 1, "idLeastSigByte": 0xCC, "name": "Red Nocturne", "value": -1, "type": "Enemy", "cpCost": 20, "element": "N/A", },
0x1CD: { "idMostSigNib": 1, "idLeastSigByte": 0xCD, "name": "Red Nocturne", "value": -1, "type": "Enemy", "cpCost": 20, "element": "N/A", },
0x1CE: { "idMostSigNib": 1, "idLeastSigByte": 0xCE, "name": "Blue Rhapsody", "value": -1, "type": "Enemy", "cpCost": 20, "element": "N/A", },
0x1CF: { "idMostSigNib": 1, "idLeastSigByte": 0xCF, "name": "Blue Rhapsody", "value": -1, "type": "Enemy", "cpCost": 20, "element": "N/A", },
0x1D0: { "idMostSigNib": 1, "idLeastSigByte": 0xD0, "name": "Blue Rhapsody", "value": -1, "type": "Enemy", "cpCost": 20, "element": "N/A", },
0x1D1: { "idMostSigNib": 1, "idLeastSigByte": 0xD1, "name": "Yellow Opera", "value": -1, "type": "Enemy", "cpCost": 20, "element": "N/A", },
0x1D2: { "idMostSigNib": 1, "idLeastSigByte": 0xD2, "name": "Yellow Opera", "value": -1, "type": "Enemy", "cpCost": 20, "element": "N/A", },
0x1D3: { "idMostSigNib": 1, "idLeastSigByte": 0xD3, "name": "Yellow Opera", "value": -1, "type": "Enemy", "cpCost": 20, "element": "N/A", },
0x1D4: { "idMostSigNib": 1, "idLeastSigByte": 0xD4, "name": "Green Requiem", "value": -1, "type": "Enemy", "cpCost": 20, "element": "N/A", },
0x1D5: { "idMostSigNib": 1, "idLeastSigByte": 0xD5, "name": "Green Requiem", "value": -1, "type": "Enemy", "cpCost": 20, "element": "N/A", },
0x1D6: { "idMostSigNib": 1, "idLeastSigByte": 0xD6, "name": "Green Requiem", "value": -1, "type": "Enemy", "cpCost": 20, "element": "N/A", },
0x1D7: { "idMostSigNib": 1, "idLeastSigByte": 0xD7, "name": "Powerwild", "value": -1, "type": "Enemy", "cpCost": 40, "element": "N/A", },
0x1D8: { "idMostSigNib": 1, "idLeastSigByte": 0xD8, "name": "Powerwild", "value": -1, "type": "Enemy", "cpCost": 40, "element": "N/A", },
0x1D9: { "idMostSigNib": 1, "idLeastSigByte": 0xD9, "name": "Powerwild", "value": -1, "type": "Enemy", "cpCost": 40, "element": "N/A", },
0x1DA: { "idMostSigNib": 1, "idLeastSigByte": 0xDA, "name": "Bouncywild", "value": -1, "type": "Enemy", "cpCost": 10, "element": "N/A", },
0x1DB: { "idMostSigNib": 1, "idLeastSigByte": 0xDB, "name": "Bouncywild", "value": -1, "type": "Enemy", "cpCost": 10, "element": "N/A", },
0x1DC: { "idMostSigNib": 1, "idLeastSigByte": 0xDC, "name": "Bouncywild", "value": -1, "type": "Enemy", "cpCost": 10, "element": "N/A", },
0x1DD: { "idMostSigNib": 1, "idLeastSigByte": 0xDD, "name": "Air Soldier", "value": -1, "type": "Enemy", "cpCost": 30, "element": "N/A", },
0x1DE: { "idMostSigNib": 1, "idLeastSigByte": 0xDE, "name": "Air Soldier", "value": -1, "type": "Enemy", "cpCost": 30, "element": "N/A", },
0x1DF: { "idMostSigNib": 1, "idLeastSigByte": 0xDF, "name": "Air Soldier", "value": -1, "type": "Enemy", "cpCost": 30, "element": "N/A", },
0x1E0: { "idMostSigNib": 1, "idLeastSigByte": 0xE0, "name": "Bandit", "value": -1, "type": "Enemy", "cpCost": 30, "element": "N/A", },
0x1E1: { "idMostSigNib": 1, "idLeastSigByte": 0xE1, "name": "Bandit", "value": -1, "type": "Enemy", "cpCost": 30, "element": "N/A", },
0x1E2: { "idMostSigNib": 1, "idLeastSigByte": 0xE2, "name": "Bandit", "value": -1, "type": "Enemy", "cpCost": 30, "element": "N/A", },
0x1E3: { "idMostSigNib": 1, "idLeastSigByte": 0xE3, "name": "Fat Bandit", "value": -1, "type": "Enemy", "cpCost": 40, "element": "N/A", },
0x1E4: { "idMostSigNib": 1, "idLeastSigByte": 0xE4, "name": "Fat Bandit", "value": -1, "type": "Enemy", "cpCost": 40, "element": "N/A", },
0x1E5: { "idMostSigNib": 1, "idLeastSigByte": 0xE5, "name": "Fat Bandit", "value": -1, "type": "Enemy", "cpCost": 40, "element": "N/A", },
0x1E6: { "idMostSigNib": 1, "idLeastSigByte": 0xE6, "name": "Barrel Spider", "value": -1, "type": "Enemy", "cpCost": 30, "element": "N/A", },
0x1E7: { "idMostSigNib": 1, "idLeastSigByte": 0xE7, "name": "Barrel Spider", "value": -1, "type": "Enemy", "cpCost": 30, "element": "N/A", },
0x1E8: { "idMostSigNib": 1, "idLeastSigByte": 0xE8, "name": "Barrel Spider", "value": -1, "type": "Enemy", "cpCost": 30, "element": "N/A", },
0x1E9: { "idMostSigNib": 1, "idLeastSigByte": 0xE9, "name": "Search Ghost", "value": -1, "type": "Enemy", "cpCost": 35, "element": "N/A", },
0x1EA: { "idMostSigNib": 1, "idLeastSigByte": 0xEA, "name": "Search Ghost", "value": -1, "type": "Enemy", "cpCost": 35, "element": "N/A", },
0x1EB: { "idMostSigNib": 1, "idLeastSigByte": 0xEB, "name": "Search Ghost", "value": -1, "type": "Enemy", "cpCost": 35, "element": "N/A", },
0x1EC: { "idMostSigNib": 1, "idLeastSigByte": 0xEC, "name": "Sea Neon", "value": -1, "type": "Enemy", "cpCost": 20, "element": "N/A", },
0x1ED: { "idMostSigNib": 1, "idLeastSigByte": 0xED, "name": "Sea Neon", "value": -1, "type": "Enemy", "cpCost": 20, "element": "N/A", },
0x1EE: { "idMostSigNib": 1, "idLeastSigByte": 0xEE, "name": "Sea Neon", "value": -1, "type": "Enemy", "cpCost": 20, "element": "N/A", },
0x1EF: { "idMostSigNib": 1, "idLeastSigByte": 0xEF, "name": "Screwdiver", "value": -1, "type": "Enemy", "cpCost": 15, "element": "N/A", },
0x1F0: { "idMostSigNib": 1, "idLeastSigByte": 0xF0, "name": "Screwdiver", "value": -1, "type": "Enemy", "cpCost": 15, "element": "N/A", },
0x1F1: { "idMostSigNib": 1, "idLeastSigByte": 0xF1, "name": "Screwdiver", "value": -1, "type": "Enemy", "cpCost": 15, "element": "N/A", },
0x1F2: { "idMostSigNib": 1, "idLeastSigByte": 0xF2, "name": "Aquatank", "value": -1, "type": "Enemy", "cpCost": 30, "element": "N/A", },
0x1F3: { "idMostSigNib": 1, "idLeastSigByte": 0xF3, "name": "Aquatank", "value": -1, "type": "Enemy", "cpCost": 30, "element": "N/A", },
0x1F4: { "idMostSigNib": 1, "idLeastSigByte": 0xF4, "name": "Aquatank", "value": -1, "type": "Enemy", "cpCost": 30, "element": "N/A", },
0x1F5: { "idMostSigNib": 1, "idLeastSigByte": 0xF5, "name": "Wight Night", "value": -1, "type": "Enemy", "cpCost": 15, "element": "N/A", },
0x1F6: { "idMostSigNib": 1, "idLeastSigByte": 0xF6, "name": "Wight Night", "value": -1, "type": "Enemy", "cpCost": 15, "element": "N/A", },
0x1F7: { "idMostSigNib": 1, "idLeastSigByte": 0xF7, "name": "Wight Night", "value": -1, "type": "Enemy", "cpCost": 15, "element": "N/A", },
0x1F8: { "idMostSigNib": 1, "idLeastSigByte": 0xF8, "name": "Gargoyle", "value": -1, "type": "Enemy", "cpCost": 30, "element": "N/A", },
0x1F9: { "idMostSigNib": 1, "idLeastSigByte": 0xF9, "name": "Gargoyle", "value": -1, "type": "Enemy", "cpCost": 30, "element": "N/A", },
0x1FA: { "idMostSigNib": 1, "idLeastSigByte": 0xFA, "name": "Gargoyle", "value": -1, "type": "Enemy", "cpCost": 30, "element": "N/A", },
0x1FB: { "idMostSigNib": 1, "idLeastSigByte": 0xFB, "name": "Pirate", "value": -1, "type": "Enemy", "cpCost": 30, "element": "N/A", },
0x1FC: { "idMostSigNib": 1, "idLeastSigByte": 0xFC, "name": "Pirate", "value": -1, "type": "Enemy", "cpCost": 30, "element": "N/A", },
0x1FD: { "idMostSigNib": 1, "idLeastSigByte": 0xFD, "name": "Pirate", "value": -1, "type": "Enemy", "cpCost": 30, "element": "N/A", },
0x1FE: { "idMostSigNib": 1, "idLeastSigByte": 0xFE, "name": "Air Pirate", "value": -1, "type": "Enemy", "cpCost": 30, "element": "N/A", },
0x1FF: { "idMostSigNib": 1, "idLeastSigByte": 0xFF, "name": "Air Pirate", "value": -1, "type": "Enemy", "cpCost": 30, "element": "N/A", },
0x200: { "idMostSigNib": 2, "idLeastSigByte": 0x0, "name": "Air Pirate", "value": -1, "type": "Enemy", "cpCost": 30, "element": "N/A", },
0x201: { "idMostSigNib": 2, "idLeastSigByte": 0x1, "name": "Darkball", "value": -1, "type": "Enemy", "cpCost": 25, "element": "N/A", },
0x202: { "idMostSigNib": 2, "idLeastSigByte": 0x2, "name": "Darkball", "value": -1, "type": "Enemy", "cpCost": 25, "element": "N/A", },
0x203: { "idMostSigNib": 2, "idLeastSigByte": 0x3, "name": "Darkball", "value": -1, "type": "Enemy", "cpCost": 25, "element": "N/A", },
0x204: { "idMostSigNib": 2, "idLeastSigByte": 0x4, "name": "Defender", "value": -1, "type": "Enemy", "cpCost": 25, "element": "N/A", },
0x205: { "idMostSigNib": 2, "idLeastSigByte": 0x5, "name": "Defender", "value": -1, "type": "Enemy", "cpCost": 25, "element": "N/A", },
0x206: { "idMostSigNib": 2, "idLeastSigByte": 0x6, "name": "Defender", "value": -1, "type": "Enemy", "cpCost": 25, "element": "N/A", },
0x207: { "idMostSigNib": 2, "idLeastSigByte": 0x7, "name": "Wyvern", "value": -1, "type": "Enemy", "cpCost": 25, "element": "N/A", },
0x208: { "idMostSigNib": 2, "idLeastSigByte": 0x8, "name": "Wyvern", "value": -1, "type": "Enemy", "cpCost": 25, "element": "N/A", },
0x209: { "idMostSigNib": 2, "idLeastSigByte": 0x9, "name": "Wyvern", "value": -1, "type": "Enemy", "cpCost": 25, "element": "N/A", },
0x20A: { "idMostSigNib": 2, "idLeastSigByte": 0xA, "name": "Wizard", "value": -1, "type": "Enemy", "cpCost": 30, "element": "N/A", },
0x20B: { "idMostSigNib": 2, "idLeastSigByte": 0xB, "name": "Wizard", "value": -1, "type": "Enemy", "cpCost": 30, "element": "N/A", },
0x20C: { "idMostSigNib": 2, "idLeastSigByte": 0xC, "name": "Wizard", "value": -1, "type": "Enemy", "cpCost": 30, "element": "N/A", },
0x20D: { "idMostSigNib": 2, "idLeastSigByte": 0xD, "name": "Neoshadow", "value": -1, "type": "Enemy", "cpCost": 25, "element": "N/A", },
0x20E: { "idMostSigNib": 2, "idLeastSigByte": 0xE, "name": "Neoshadow", "value": -1, "type": "Enemy", "cpCost": 25, "element": "N/A", },
0x20F: { "idMostSigNib": 2, "idLeastSigByte": 0xF, "name": "Neoshadow", "value": -1, "type": "Enemy", "cpCost": 25, "element": "N/A", },
0x210: { "idMostSigNib": 2, "idLeastSigByte": 0x10, "name": "White Mushroom", "value": -1, "type": "Enemy", "cpCost": 25, "element": "N/A", },
0x211: { "idMostSigNib": 2, "idLeastSigByte": 0x11, "name": "Black Fungus", "value": -1, "type": "Enemy", "cpCost": 20, "element": "N/A", },
0x212: { "idMostSigNib": 2, "idLeastSigByte": 0x12, "name": "Black Fungus", "value": -1, "type": "Enemy", "cpCost": 20, "element": "N/A", },
0x213: { "idMostSigNib": 2, "idLeastSigByte": 0x13, "name": "Black Fungus", "value": -1, "type": "Enemy", "cpCost": 20, "element": "N/A", },
0x214: { "idMostSigNib": 2, "idLeastSigByte": 0x14, "name": "Creeper Plant", "value": -1, "type": "Enemy", "cpCost": 35, "element": "N/A", },
0x215: { "idMostSigNib": 2, "idLeastSigByte": 0x15, "name": "Creeper Plant", "value": -1, "type": "Enemy", "cpCost": 35, "element": "N/A", },
0x216: { "idMostSigNib": 2, "idLeastSigByte": 0x16, "name": "Creeper Plant", "value": -1, "type": "Enemy", "cpCost": 35, "element": "N/A", },
0x217: { "idMostSigNib": 2, "idLeastSigByte": 0x17, "name": "Tornado Step", "value": -1, "type": "Enemy", "cpCost": 25, "element": "N/A", },
0x218: { "idMostSigNib": 2, "idLeastSigByte": 0x18, "name": "Tornado Step", "value": -1, "type": "Enemy", "cpCost": 25, "element": "N/A", },
0x219: { "idMostSigNib": 2, "idLeastSigByte": 0x19, "name": "Tornado Step", "value": -1, "type": "Enemy", "cpCost": 25, "element": "N/A", },
0x21A: { "idMostSigNib": 2, "idLeastSigByte": 0x1A, "name": "Crescendo", "value": -1, "type": "Enemy", "cpCost": 20, "element": "N/A", },
0x21B: { "idMostSigNib": 2, "idLeastSigByte": 0x1B, "name": "Crescendo", "value": -1, "type": "Enemy", "cpCost": 20, "element": "N/A", },
0x21C: { "idMostSigNib": 2, "idLeastSigByte": 0x1C, "name": "Crescendo", "value": -1, "type": "Enemy", "cpCost": 20, "element": "N/A", },
0x21D: { "idMostSigNib": 2, "idLeastSigByte": 0x1D, "name": "Guard Armor", "value": -1, "type": "Enemy", "cpCost": 30, "element": "N/A", },
0x21E: { "idMostSigNib": 2, "idLeastSigByte": 0x1E, "name": "Parasite Cage", "value": -1, "type": "Enemy", "cpCost": 60, "element": "N/A", },
0x21F: { "idMostSigNib": 2, "idLeastSigByte": 0x1F, "name": "Trickmaster", "value": -1, "type": "Enemy", "cpCost": 25, "element": "N/A", },
0x220: { "idMostSigNib": 2, "idLeastSigByte": 0x20, "name": "Darkside", "value": -1, "type": "Enemy", "cpCost": 99, "element": "N/A", },
0x221: { "idMostSigNib": 2, "idLeastSigByte": 0x21, "name": "Card Soldier", "value": -1, "type": "Enemy", "cpCost": 55, "element": "N/A", },
0x222: { "idMostSigNib": 2, "idLeastSigByte": 0x22, "name": "Card Soldier", "value": -1, "type": "Enemy", "cpCost": 55, "element": "N/A", },
0x223: { "idMostSigNib": 2, "idLeastSigByte": 0x23, "name": "Card Soldier", "value": -1, "type": "Enemy", "cpCost": 55, "element": "N/A", },
0x224: { "idMostSigNib": 2, "idLeastSigByte": 0x24, "name": "Card Soldier", "value": -1, "type": "Enemy", "cpCost": 55, "element": "N/A", },
0x225: { "idMostSigNib": 2, "idLeastSigByte": 0x25, "name": "Card Soldier", "value": -1, "type": "Enemy", "cpCost": 55, "element": "N/A", },
0x226: { "idMostSigNib": 2, "idLeastSigByte": 0x26, "name": "Card Soldier", "value": -1, "type": "Enemy", "cpCost": 55, "element": "N/A", },
0x227: { "idMostSigNib": 2, "idLeastSigByte": 0x27, "name": "Hades", "value": -1, "type": "Enemy", "cpCost": 40, "element": "N/A", },
0x228: { "idMostSigNib": 2, "idLeastSigByte": 0x28, "name": "Jafar", "value": -1, "type": "Enemy", "cpCost": 65, "element": "N/A", },
0x229: { "idMostSigNib": 2, "idLeastSigByte": 0x29, "name": "Oogie Boogie", "value": -1, "type": "Enemy", "cpCost": 40, "element": "N/A", },
0x22A: { "idMostSigNib": 2, "idLeastSigByte": 0x2A, "name": "Ursula", "value": -1, "type": "Enemy", "cpCost": 50, "element": "N/A", },
0x22B: { "idMostSigNib": 2, "idLeastSigByte": 0x2B, "name": "Hook", "value": -1, "type": "Enemy", "cpCost": 35, "element": "N/A", },
0x22C: { "idMostSigNib": 2, "idLeastSigByte": 0x2C, "name": "Dragon Maleficent", "value": -1, "type": "Enemy", "cpCost": 70, "element": "N/A", },
0x22D: { "idMostSigNib": 2, "idLeastSigByte": 0x2D, "name": "Riku", "value": -1, "type": "Enemy", "cpCost": 80, "element": "N/A", },
0x22E: { "idMostSigNib": 2, "idLeastSigByte": 0x2E, "name": "Axel", "value": -1, "type": "Enemy", "cpCost": 75, "element": "N/A", },
0x22F: { "idMostSigNib": 2, "idLeastSigByte": 0x2F, "name": "Larxene", "value": -1, "type": "Enemy", "cpCost": 60, "element": "N/A", },
0x230: { "idMostSigNib": 2, "idLeastSigByte": 0x30, "name": "Vexen", "value": -1, "type": "Enemy", "cpCost": 60, "element": "N/A", },
0x231: { "idMostSigNib": 2, "idLeastSigByte": 0x31, "name": "Marluxia", "value": -1, "type": "Enemy", "cpCost": 99, "element": "N/A", },
0x232: { "idMostSigNib": 2, "idLeastSigByte": 0x32, "name": "Marluxia 2", "value": -1, "type": "Enemy", "cpCost": 0, "element": "N/A", },
0x233: { "idMostSigNib": 2, "idLeastSigByte": 0x33, "name": "Lexaeus", "value": -1, "type": "Enemy", "cpCost": 99, "element": "N/A", },
0x234: { "idMostSigNib": 2, "idLeastSigByte": 0x34, "name": "Ansem", "value": -1, "type": "Enemy", "cpCost": 60, "element": "N/A", },
}

function GetCardsByProperty(property, propertyValue)
{
    ret = []
    for i in cards
    {
        card = cards[i]
        if (card[property] == propertyValue)
        {
            card["id"] = i
            array_push(ret, card)
        }
    }
    return ret
}

// A cluster is defined as an array whose elements all differ by a single quantum value with at least one element.
// For instance, an array containing the values [ 1, 2, 3, 4, 6, 7, 9 ] has three clusters:
// [ 1, 2, 3, 4 ], [ 6, 7 ], and [ 9 ]
function GenerateClustersFromList(data)
{
    clusters = []
    currentElement = -1
    currentCluster = []
    for i in data
    {
        if (i == currentElement + 1 || currentElement == -1)
        {
            currentElement = i
            array_push(currentCluster, currentElement)
        }
        else
        {
            array_push(clusters, currentCluster)
            currentElement = i
            currentCluster = [ currentElement ]
        }
    }
    
    // Get the range we were just working on if it has elements.
    if (length(currentCluster) > 0)
    {
        array_push(clusters, currentCluster)
    }
    
    return clusters
}

function ConvertClustersToRanges(clusters)
{
    ranges = []
    
    for cluster in clusters
    {
        min = cluster[0]
        max = cluster[length(cluster) - 1]
        array_push(ranges, { "min": min, "max": max })
    }
    
    // todo: sort and then merge ranges whose mins are one greater than another's maxes, and vice versa.
    
    return ranges
}

function ConvertListToRanges(list)
{
    clusters = GenerateClustersFromList(list)
    return ConvertClustersToRanges(clusters)
}

function CardRangeParameterConstructor(minIdMostSigNib, minIdLeastSigByte, maxIdMostSigNib, maxIdLeastSigByte)
{
    return {
        "minIdMostSigNib": minIdMostSigNib,
        "minIdLeastSigByte": minIdLeastSigByte,
        "maxIdMostSigNib": maxIdMostSigNib,
        "maxIdLeastSigByte": maxIdLeastSigByte
    }
}

function GetCardRangeParameters(cardList)
{
    ranges = ConvertCardsToListOfIdRanges(cardList)
    convertedRanges = []
    
    for range in ranges
    {
        lowCard = cards[range["min"]]
        highCard = cards[range["max"]]
        
        // Split each range by most-significant nibble to clarify the implementation.
        for i in range(lowCard["idMostSigNib"], highCard["idMostSigNib"])
        {
            lowestLeastSigByte = 0x0
            highestLeastSigByte = 0x0
            if (i != highCard["idMostSigNib"])
            {
                highestLeastSigByte = 0xff
            }
            else
            {
                highestLeastSigByte  = highCard["idLeastSigByte"]
            }
            
            if (i == lowCard["idMostSigNib"])
            {
                lowestLeastSigByte = lowCard["idLeastSigByte"]
            }
            
            array_push(convertedRanges, CardRangeParameterConstructor(i, lowestLeastSigByte, i, highestLeastSigByte))
        }
    }
    
    return convertedRanges
}

function GetListOfIdsFromCards(cardList)
{
    idList = []
    for card in cardList
    {
        array_push(idList, card["id"])
    }
    return idList
}

function SplitArrayIntoBatches(array, batchSize)
{
    batches = []
    currentBatch = []
    for i in array
    {
        if (length(currentBatch) < batchSize)
        {
            array_push(currentBatch, i)
        }
        else
        {
            array_push(batches, currentBatch)
            currentBatch = []
        }
    }
    
    array_push(batches, currentBatch)
    return batches
}

function ConvertCardsToListOfIdRanges(cardList)
{
    cardIdList = ConvertListToRanges(GetListOfIdsFromCards(cardList))
    return cardIdList
}

function AnyCardsAreEquippedInDeck(cardList, deckAddr, highestSlotIndex, debug)
{
    anyCardsAreEquipped = always_false()
    parameters = GetCardRangeParameters(cardList)
    
    for i in range(0, highestSlotIndex)
    {
        currentDeckIndexAddr = deckAddr + i * 2
        slotAddr = inventoryBaseAddr() + word(currentDeckIndexAddr) * 2
        
        for parameter in parameters
        {
            anyCardInRangeIsEquippedInThisSlot = always_true()
            
            if (debug != 0)
            {
                Debug((parameter["minIdMostSigNib"] * 256 + parameter["minIdLeastSigByte"]) + ", " + (parameter["maxIdMostSigNib"] * 256 + parameter["maxIdLeastSigByte"]))
            }
            
            mostSigNib = low4(slotAddr + 1)
            leastSigByte = byte(slotAddr)
            
            // Optimize the generated subtrigger if the range only covers a single element.
            if (parameter["minIdMostSigNib"] == parameter["maxIdMostSigNib"] && parameter["maxIdLeastSigByte"] == parameter["minIdLeastSigByte"])
            {
                anyCardInRangeIsEquippedInThisSlot = anyCardInRangeIsEquippedInThisSlot
                    && mostSigNib == parameter["maxIdMostSigNib"] && leastSigByte == parameter["maxIdLeastSigByte"]
            }
            else // Otherwise, go the whole nine yards.
            {
                for j in range(parameter["minIdMostSigNib"], parameter["maxIdMostSigNib"])
                {
                    anyCardInRangeIsEquippedInThisSlot = anyCardInRangeIsEquippedInThisSlot && mostSigNib == j && leastSigByte >= parameter["minIdLeastSigByte"]
                        && leastSigByte <= parameter["maxIdLeastSigByte"]
                }
            }
            
            anyCardsAreEquipped = anyCardsAreEquipped || anyCardInRangeIsEquippedInThisSlot
        }
    }
    
    return anyCardsAreEquipped
}

function currentDeck() => byte(0x03cacc)

function deck1TotalCards() => byte(0x0424cc)
function deck1TotalCp() => word(0x0424ca)

function deck2TotalCards() => byte(0x0425ac)
function deck2TotalCp() => word(0x0425aa)

function deck3TotalCards() => byte(0x04268c)
function deck3TotalCp() => word(0x04268a)

function BossHPValueCheckpointIsSet(bossHp, bossHpMap, worldName, roomId)
{
    trigger = always_false()
    for floor in bossHpMap
    {
        hpValue = bossHpMap[floor]
        trigger = trigger || once(BossHPValueCheckpointIsSetForAnyFloor(bossHp, hpValue, worldName, roomId) && IsOnFloor(floor))
    }
    
    return trigger
}

function BossHPValueCheckpointIsSetForAnyFloor(bossHp, maxBossHp, worldName, roomId)
{
    return roomId() == roomId && IsInWorld(worldName) && BattleStartedCheckpoint() && bossHp == maxBossHp
}

// Not to be used for a checkpoint.
function BossHPValueIsExpected(bossHp, bossHpMap, worldName, roomId)
{
    trigger = always_false()
    for floor in bossHpMap
    {
        hpValue = bossHpMap[floor]
        trigger = trigger || roomId() == roomId && IsInWorld(worldName) && IsOnFloor(floor) && bossHp == hpValue
    }
    
    return trigger
}

// 0x0423e4: Appears to be a pointer to battle data. Null when not in battle. (32-bit)
//
//           +0x80fc for the player's reload counter (16-bit). = the number on the reload card - 1
//           and becomes 0xffff when a reload happens. After that, increases by 1 for each reload until it reaches a max of 2.
//
//           +0x80fe for the enemy's reload counter (16-bit)
//
//           +0x8f0c for enemy HP(?)
function battlePointer() => tbyte(0x0423e4)
function numberOfStockedCardsForPlayer() => byte(battlePointer() + 0x80de)
function playerReloadCounter() => word(battlePointer() + 0x80fc)
function enemyReloadCounter() => word(battlePointer() + 0x80fe)
function cardValueInPlay() => byte(battlePointer() + 0x80c2)
function IsManuallyReloading() => byte(battlePointer() + 0x8888) == 1
function IsPaused() => byte(battlePointer() + 0x8ab0) == 1

// Data representing a card in combat is twelve bytes wide.
// [Card ID (16-bit)][byte][byte][byte][byte][byte][0x1 = is stocked (8-bit)][0x1 = is consumed, such as by a reload (8-bit)][byte][0x1 = is used]
// Note: For this and all subsequent functions, a deck offset is the offset between the address in the battle pointer and the address of the ID of the first card in the dynamic deck memory,
// which may vary from battle to battle.
function topOfDeckBaseAddr(deckOffset) => battlePointer() + deckOffset
function headOfDynamicCardAddrInSlot(slotIndex, deckOffset) => topOfDeckBaseAddr(deckOffset) + slotIndex * 12
function GetIdOfDynamicCardInSlot(slotIndex, deckOffset)
{
    headOfCardAddr = headOfDynamicCardAddrInSlot(slotIndex, deckOffset)
    return word(headOfCardAddr)
}

function DynamicCardInSlotWasJustUsed(slotIndex, deckOffset)
{
    headOfCardAddr = headOfDynamicCardAddrInSlot(slotIndex, deckOffset)
    usedBit = byte(headOfCardAddr + 8)
    return Delta(usedBit) == 0 && usedBit == 1
}

function DynamicCardInSlotWasJustReloaded(slotIndex, deckOffset)
{
    headOfCardAddr = headOfDynamicCardAddrInSlot(slotIndex, deckOffset)
    usedByte = byte(headOfCardAddr + 8)
    return Delta(usedByte) == 1 && usedByte == 0
}

function ReloadedNumberOfCards(cardsReloaded, deckOffset, numberOfCardsInDeck)
{
    reloaded = []
    
    for i in range(0, numberOfCardsInDeck - 1)
    {
        array_push(reloaded, DynamicCardInSlotWasJustReloaded(i, deckOffset))
    }
    
    return tally(cardsReloaded, reloaded)
}

// One of three pointers that appear to influence battles in some way, like HP and the like
// It's misleading to call it a battle pointer, though, as it does not consistently nullify when in the field. (32-bit)
//
// +0x7e6c to get the player's vertical acceleration when in battle (32-bit)
// +0x7e8c to get the player's current (dynamic) HP when in battle (16-bit)
// +0x7cd0 to get Riku's current (dynamic) HP when in battle (16-bit)
function playerBattlePointer() => tbyte(0x03ca28)

// One of two pointers that appear related to boss information (32-bit)
//
// +0x7f28 for boss state (8-bit)
// +0x7f74 for boss HP (16-bit)
function bossPointer() => tbyte(0x034988)

function playerHp() => word(playerBattlePointer() + 0x7e8c)

function rikuPlayerHp() => word(playerBattlePointer() + 0x7cd0)

function soraBattleState() => word(playerBattlePointer() + 0x7e58)

function rikuBattleState() => word(playerBattlePointer() + 0x7c9c)

function rikuXCoord() => dword(playerBattlePointer() + 0x7ca8)

function IsUsingKingMickey() => rikuBattleState() == 0x1a

function IsActivatingDarkMode() => rikuBattleState() == 0x20

function IsInBattle() => battlePointer() != 0

function BattleStartedCheckpoint() => once(Delta(battlePointer()) == 0x0 && battlePointer() != 0x0)

function EnemyWithSpecificAddressWasJustDefeated(enemyHp, useIndicator)
{
    trigger = Delta(enemyHp) > 0 && enemyHp == 0
    if (useIndicator == 1)
    {
        trigger = trigger_when(trigger)
    }
    
    return trigger && never(!IsInBattle())
}

function CurrentDeckHasACPCostOfAtMost(cpLimit)
{
    return currentDeck() == 0 && deck1TotalCp() <= cpLimit
        || currentDeck() == 1 && deck2TotalCp() <= cpLimit
        || currentDeck() == 2 && deck3TotalCp() <= cpLimit
}

function CurrentDeckHasASizeOfAtMost(sizeLimit)
{
    return currentDeck() == 0 && deck1TotalCards() <= sizeLimit
        || currentDeck() == 1 && deck2TotalCards() <= sizeLimit
        || currentDeck() == 2 && deck3TotalCards() <= sizeLimit
}

function CurrentDeckHasASizeOfAtLeast(sizeLimit)
{
    return currentDeck() == 0 && deck1TotalCards() >= sizeLimit
        || currentDeck() == 1 && deck2TotalCards() >= sizeLimit
        || currentDeck() == 2 && deck3TotalCards() >= sizeLimit
}

// * = free card, or a card that a player will get just by progressing through the game anyway
collectorBitflags = [
    // Attack cards
    bit0(0x042303), // Three Wishes
    bit1(0x042303), // Crabclaw
    bit2(0x042303), // Pumpkinhead
    bit3(0x042303), // Fairy Harp
    bit4(0x042303), // Wishing Star
    bit5(0x042303), // Spellbinder
    bit6(0x042303), // Metal Chocobo
    bit7(0x042303), // Olympia
    bit0(0x042304), // Lionheart
    bit1(0x042304), // Lady Luck
    bit2(0x042304), // Divine Rose
    bit3(0x042304), // Oathkeeper*
    bit4(0x042304), // Oblivion*
    bit5(0x042304), // Ultima Weapon
    bit6(0x042304), // Diamond Dust
    bit7(0x042304), // One-Winged Angel
    
    // Magic cards
    bit0(0x042305), // Fire*
    bit1(0x042305), // Blizzard*
    bit2(0x042305), // Thunder*
    bit3(0x042305), // Cure*
    bit4(0x042305), // Gravity
    bit5(0x042305), // Stop
    bit6(0x042305), // Aero*
    bit7(0x042305), // Simba*
    bit0(0x042306), // Genie*
    bit1(0x042306), // Bambi*
    bit2(0x042306), // Dumbo*
    bit3(0x042306), // Tinker Bell*
    bit4(0x042306), // Mushu
    bit5(0x042306), // Cloud*
    
    // Item cards
    bit6(0x042306), // Potion*
    bit7(0x042306), // Hi-Potion*
    bit0(0x042307), // Mega-Potion*
    bit1(0x042307), // Ether*
    bit2(0x042307), // Mega-Ether*
    bit3(0x042307), // Elixir
    bit4(0x042307), // Megalixir
    
    // Friend cards
    bit5(0x042307), // Donald*
    bit6(0x042307), // Goofy*
    bit7(0x042307), // Aladdin*
    bit0(0x042308), // Ariel*
    bit1(0x042308), // Jack*
    bit2(0x042308), // Peter Pan*
    bit3(0x042308), // Beast*
    
    // Enemy cards
    bit4(0x042308), // Shadow
    bit5(0x042308), // Red Nocturne
    bit6(0x042308), // Blue Rhapsody
    bit7(0x042308), // Yellow Opera
    bit0(0x042309), // Green Requiem
    bit1(0x042309), // Sea Neon
    bit2(0x042309), // White Mushroom
    bit3(0x042309), // Black Fungus
    bit4(0x042309), // Soldier
    bit5(0x042309), // Powerwild
    bit6(0x042309), // Bouncywild
    bit7(0x042309), // Air Soldier
    bit0(0x04230a), // Bandit
    bit1(0x04230a), // Barrel Spider
    bit2(0x04230a), // Search Ghost
    bit3(0x04230a), // Screwdiver
    bit4(0x04230a), // Wight Knight
    bit5(0x04230a), // Gargoyle
    bit6(0x04230a), // Pirate
    bit7(0x04230a), // Air Pirate
    bit0(0x04230b), // Darkball
    bit1(0x04230b), // Wyvern
    bit2(0x04230b), // Wizard
    bit3(0x04230b), // Neoshadow
    bit4(0x04230b), // Large Body
    bit5(0x04230b), // Fat Bandit
    bit6(0x04230b), // Aquatank
    bit7(0x04230b), // Defender
    bit0(0x04230c), // Tornado Step
    bit1(0x04230c), // Crescendo
    bit2(0x04230c), // Creeper Plant
    bit3(0x04230c), // Guard Armor*
    bit4(0x04230c), // Hades*
    bit5(0x04230c), // Trickmaster*
    bit6(0x04230c), // Jafar*
    bit7(0x04230c), // Ursula*
    bit0(0x04230d), // Oogie Boogie*
    bit1(0x04230d), // Parasite Cage*
    bit2(0x04230d), // Hook*
    bit3(0x04230d), // Dragon Maleficent*
    bit4(0x04230d), // Darkside*
    bit5(0x04230d), // Larxene*
    bit6(0x04230d), // Axel*
    bit7(0x04230d), // Vexen*
    bit0(0x04230e), // Marluxia*
    bit6(0x042312), // Card Soldier*
    bit7(0x042312), // Riku*
    bit0(0x042313), // Lexaeus
    bit1(0x042313), // Ansem
]

// The number of cards the player will get just by playing the game anyway. This affects the card thresholds below.
// Adjust as necessary.
freeCards = 41

rookieThreshold = freeCards + (length(collectorBitflags) - freeCards) / 10
GenerateCheevoFromBitflags({
    "name": "Rookie Collector",
    "description": ("Collect " + rookieThreshold + " non-map cards in Sora's story."),
    "points": 5,
    "threshold": rookieThreshold,
    "id": 156793,
    "badge": "180269",
}, collectorBitflags, IsInMainStory())

regularThreshold = freeCards + (length(collectorBitflags) - freeCards) / 4
GenerateCheevoFromBitflags({
    "name": "Regular Collector",
    "description": ("Collect " + regularThreshold + " non-map cards in Sora's story."),
    "points": 10,
    "threshold": regularThreshold,
    "id": 160403,
    "badge": "180262"
}, collectorBitflags, IsInMainStory())

veteranThreshold = freeCards + (length(collectorBitflags) - freeCards) / 2
GenerateCheevoFromBitflags({
    "name": "Veteran Collector",
    "description": ("Collect " + veteranThreshold + " non-map cards in Sora's story."),
    "points": 25,
    "threshold": veteranThreshold,
    "id": 160404,
    "badge": "180263"
}, collectorBitflags, IsInMainStory())

GenerateCheevoFromBitflags({
    "name": "Legendary Collector",
    "description": "Collect all non-map cards in Sora's story.",
    "points": 50,
    "threshold": length(collectorBitflags),
    "id": 160405,
    "badge": "180264"
}, collectorBitflags, IsInMainStory())


// Free sleights, or sleights that the player would get normally as they progress through the game, are commented out.
sleightBitflags = [
    bit0(0x0422cc), // Sliding Dash
    bit1(0x0422cc), // Blitz
    bit2(0x0422cc), // Stun Impact
    bit3(0x0422cc), // Zantetsuken
    bit4(0x0422cc), // Strike Raid
    bit5(0x0422cc), // Sonic Blade
    bit6(0x0422cc), // Ars Arcanum
    bit7(0x0422cc), // Ragnarok
    
    //bit0(0x0422cd), // Trinity Limit
    //bit1(0x0422cd), // Fira
    //bit2(0x0422cd), // Firaga
    //bit3(0x0422cd), // Blizzara
    //bit4(0x0422cd), // Blizzaga
    //bit5(0x0422cd), // Thundara
    //bit6(0x0422cd), // Thundaga
    //bit7(0x0422cd), // Cura
    
    //bit0(0x0422ce), // Curaga
    bit1(0x0422ce), // Gravira
    bit2(0x0422ce), // Graviga
    bit3(0x0422ce), // Stopra
    bit4(0x0422ce), // Stopga
    //bit5(0x0422ce), // Aerora
    //bit6(0x0422ce), // Aeroga
    bit7(0x0422ce), // Fire Raid
    
    bit0(0x0422cf), // Blizzard Raid
    bit1(0x0422cf), // Thunder Raid
    bit2(0x0422cf), // Gravity Raid
    bit3(0x0422cf), // Stop Raid
    bit4(0x0422cf), // Judgment
    bit5(0x0422cf), // Reflect Raid
    bit6(0x0422cf), // Homing Fira
    
    bit0(0x0422d4), // Firaga Break
    bit1(0x0422d4), // Mega Flare
    bit2(0x0422d4), // Homing Blizzara
    bit3(0x0422d4), // Aqua Splash
    bit4(0x0422d4), // Shock Impact
    bit5(0x0422d4), // Tornado
    bit6(0x0422d4), // Quake
    //bit7(0x0422d4), // Warpinator
    
    bit0(0x0422d5), // Warp
    bit1(0x0422d5), // Bind
    bit2(0x0422d5), // Confuse
    //bit3(0x0422d5), // Terror
    bit4(0x0422d5), // Synchro
    bit5(0x0422d5), // Gifted Miracle
    bit6(0x0422d5), // Teleport
    bit7(0x0422d5), // Holy
    
    //bit0(0x0422d6), // Proud Roar
    //bit1(0x0422d6), // Splash
    //bit2(0x0422d6), // Paradise
    bit3(0x0422d6), // Idyll Romp
    bit4(0x0422d6), // Flare Breath
    //bit5(0x0422d6), // Showtime
    //bit6(0x0422d6), // Twinkle
    //bit7(0x0422d6), // Cross-slash
    
    //bit0(0x0422d7), // Omnislash
    bit1(0x0422d7), // Cross-slash+
    //bit2(0x0422d7), // Magic
    bit3(0x0422d7), // Blazing Donald
    //bit4(0x0422d7), // Goofy Charge
    //bit5(0x0422d7), // Goofy Tornado
    //bit6(0x0422d7), // Sandstorm
    bit7(0x0422d7), // Surprise!
    
    //bit0(0x0422d8), // Spiral Wave
    //bit1(0x0422d8), // Hummingbird
    //bit2(0x0422d8), // Ferocious Lunge
]

beginnerSleightThreshold = length(sleightBitflags) / 10
GenerateCheevoFromBitflags({
    "name": "Beginner Legerdemain",
    "description": "Learn 10% of all optional sleights.",
    "points": 3,
    "threshold": beginnerSleightThreshold,
    "id": 160406,
    "badge": "180265",
}, sleightBitflags, IsInMainStory())

standardSleightThreshold = length(sleightBitflags) / 4
GenerateCheevoFromBitflags({
    "name": "Standard Legerdemain",
    "description": "Learn 25% of all optional sleights.",
    "points": 5,
    "threshold": standardSleightThreshold,
    "id": 160407,
    "badge": "180266",
}, sleightBitflags, IsInMainStory())

proudSleightThreshold = length(sleightBitflags) / 2
GenerateCheevoFromBitflags({
    "name": "Proud Legerdemain",
    "description": "Learn 50% of all optional sleights.",
    "points": 10,
    "threshold": proudSleightThreshold,
    "id": 160408,
    "badge": "180267",
}, sleightBitflags, IsInMainStory())

criticalSleightThreshold = length(sleightBitflags)
GenerateCheevoFromBitflags({
    "name": "Critical Legerdemain",
    "description": "Learn all optional sleights.",
    "points": 25,
    "threshold": criticalSleightThreshold,
    "id": 160409,
    "badge": "180268",
}, sleightBitflags, IsInMainStory())

function shadowJournalEntry() => bit4(0x0422fe)
achievement(
    title = "Heartless Hunter", description = "Defeat your first Heartless in Castle Oblivion.", points = 1,
    id = 15580, badge = "12277", published = "10/16/2014 6:04:37 AM", modified = "11/8/2016 6:46:53 PM",
    trigger = WasBitflagSetInMainGame(shadowJournalEntry()) && IsInMainStory()
)

function backgroundColorComponent() => dword(0x002d00)
function backgroundColorTransitionFramesLeft() => dword(0x002d0c)
function guardArmorEncounterId() => 0x94
function guardArmorCardObtained() => bit3(0x04230c)
function UsedGimmickCard() => backgroundColorComponent() == 0x1f00 && Delta(backgroundColorTransitionFramesLeft()) == 0 && backgroundColorTransitionFramesLeft() == 8
achievement(
    title = "No Scheming Allowed [m]", points = 5, id = 160363, badge = "180222",
    description = "Defeat the Guard Armor in Sora's story without using any Gimmick Cards.",
    trigger = DefeatedCheckpointedEncounterWithId(guardArmorEncounterId(), TRUE) && IsInMainStory()
        && never(UsedGimmickCard()) // Loss condition
)

function fireCardEntry() => bit0(0x042305)
achievement(
    title = "Memory of Worlds Lost", description = "Complete Traverse Town in Sora's story.", points = 5,
    id = 15582, badge = "14839", published = "10/16/2014 6:06:16 AM", modified = "7/7/2020 2:12:27 AM",
    trigger = roomId() == 0x7 && WasInWorld("Traverse Town") && IsInWorld("Castle Oblivion, Hall") && fireCardEntry() == 0 && IsInMainStory()
)

function axelFirstFloorEncounterId() => 0xa2
achievement(
    title = "The Flurry of Dancing Flames", description = "Defeat Axel on the first floor.", points = 3,
    id = 15583, badge = "180412", published = "10/16/2014 6:07:43 AM", modified = "7/7/2020 2:12:51 AM",
    trigger = DefeatedCheckpointedEncounterWithId(axelFirstFloorEncounterId(), FALSE) && IsInMainStory()
)

achievement(title = "Heat-Resistant Glue [m]", description = "Defeat Axel on the first floor without using the D-pad.", points = 5, id = 160364, badge = "180223",
    trigger = DefeatedCheckpointedEncounterWithId(axelFirstFloorEncounterId(), TRUE)
        && never(DpadIsPressed()) && IsInMainStory()
)

jafarHpMap = {
    2: 0x224,
    3: 0x255,
    4: 0x286,
    5: 0x2b7,
    6: 0x2e8
}

jumpLimit = 45
function jafarEncounterId() => 0x95
achievement(title = "Delicate Springs [m]", description = "Defeat Jafar in Sora's story without pressing B more than " + jumpLimit + " times.", points = 10,
    id = 160365, badge = "180224",
    trigger = never(repeated(jumpLimit + 1, Delta(bIsPressed()) != bIsPressed() && bIsPressed() == 1))
        && DefeatedCheckpointedEncounterWithId(jafarEncounterId(), TRUE) && FinishedEncounter(TRUE) && IsInMainStory()
)

function agrabahStoryEntry() => bit7(0x0422f4)
achievement(
    title = "Memory of Treasure", description = "Complete Agrabah in Sora's story.", points = 5,
    id = 15584, badge = "14870", published = "10/16/2014 6:07:55 AM", modified = "7/7/2020 2:12:56 AM",
    trigger = WasBitflagSetInMainGame(agrabahStoryEntry()) && IsInMainStory()
)

oogieBoogieHpMap = {
    2: 0x224,
    3: 0x255,
    4: 0x286,
    5: 0x2b7,
    6: 0x2e8,
    7: 0x318,
    8: 0x349,
    9: 0x37a,
    10: 0x3ab
}

function oogieBoogieEncounterId() => 0x9b
achievement(
    title = "Card Disadvantage [m]", points = 10, id = 160366, badge = "180225",
    description = "Defeat Oogie Boogie in Sora's story with a deck of only nine cards or less.",
    trigger = DefeatedCheckpointedEncounterWithId(oogieBoogieEncounterId(), TRUE)
        && CurrentDeckHasASizeOfAtMost(9) && IsInMainStory()
)

function halloweenTownEntry() => bit0(0x0422f5)
achievement(
    title = "Memory of Memory", description = "Complete Halloween Town in Sora's story.", points = 5,
    id = 15585, badge = "14878", published = "10/16/2014 6:08:08 AM", modified = "7/7/2020 2:13:00 AM",
    trigger = WasBitflagSetInMainGame(halloweenTownEntry()) && IsInMainStory()
)

timeLimit = 180
function parasiteCageHp() => word(battlePointer() + 0x9040)
parasiteCageHpMap = {
    2: 0x25b,
    3: 0x291,
    4: 0x2c7,
    5: 0x2fc,
    6: 0x332
}

achievement(title = "Rapid Digestion [m]", description = "Defeat the Parasite Cage in Sora's story within " + SecondsToFormat(timeLimit) + ".",
    points = 5, id = 160367, badge = "180226",
    trigger = BossHPValueCheckpointIsSet(parasiteCageHp(), parasiteCageHpMap, "Monstro", 0x4)
        && never(repeated(SecondsToFrames(timeLimit), IsInBattle() && FrameHasAdvanced()))
        && EnemyWithSpecificAddressWasJustDefeated(parasiteCageHp(), TRUE)
        && never(!IsInBattle()) && unless(IsPaused()) && IsInMainStory()
)

function monstroEntry() => bit1(0x0422f5)
achievement(
    title = "Memory of a Wish", description = "Complete Monstro in Sora's story.", points = 5,
    id = 15587, badge = "14883", published = "10/16/2014 6:08:32 AM", modified = "7/7/2020 2:13:09 AM",
    trigger = WasBitflagSetInMainGame(monstroEntry()) && IsInMainStory()
)

function cloudHp() => word(battlePointer() + 0x8d2c)
function cloudMaxHp() => word(battlePointer() + 0x8d2e)
cloudHpMap = {
    2: 0x112,
    3: 0x12a,
    4: 0x143,
    5: 0x15b,
    6: 0x174
}

survivalLimit = 90
function EnoughTimeHasAdvancedForWarOfAttrition() => repeated(SecondsToFrames(survivalLimit), FrameHasAdvanced())
achievement(title = "War of Attrition [m]", points = 5, id = 160368, badge = "180227",
    description = "Survive for " + SecondsToFormat(survivalLimit) + " against Cloud without pressing A or stocking cards, and then defeat him.",
    trigger = BossHPValueIsExpected(cloudMaxHp(), cloudHpMap, "Olympus Coliseum", 0x1)
        && EnemyWithSpecificAddressWasJustDefeated(cloudHp(), TRUE)
        && EnoughTimeHasAdvancedForWarOfAttrition() && unless(IsPaused()) && IsInMainStory()
        && (
            never(!IsInBattle()) // Reset the pauselock when not in battle.
            // Prevent an A press or stocking of cards to reset the time a player has survived.
            || never(aIsPressed() == 1) && never(Delta(numberOfStockedCardsForPlayer()) != numberOfStockedCardsForPlayer()) && unless(!IsPaused() && EnoughTimeHasAdvancedForWarOfAttrition())
           )
)

function hadesHp() => word(battlePointer() + 0x8d0c)

hadesHpMap = {
    2: 0x1b7,
    3: 0x1de,
    4: 0x205,
    5: 0x22c,
    6: 0x253,
    7: 0x27a,
    8: 0x2a1,
    9: 0x2c8,
    10: 0x2ef
}

achievement(title = "Burning the Candle at Both Ends [m]", points = 10, id = 160369, badge = "180228",
    description = "Defeat Hades in Sora's story before he has the chance to reload three times via his reload card.",
    trigger = BossHPValueCheckpointIsSet(hadesHp(), hadesHpMap, "Olympus Coliseum", 0x7)
        && EnemyWithSpecificAddressWasJustDefeated(hadesHp(), TRUE) && never(!IsInBattle())
        && never(repeated(3, enemyReloadCounter() == 0xffff && Delta(enemyReloadCounter()) != 0xffff)) && IsInMainStory()
)

// Without a way to count the number of cards a player has equipped in the first X slots of their deck
// and compare that with an in-memory value to audit their deck comp, this achievement will not be possible
// without there being a blind spot. So I'm putting this on the cutting room floor until the toolkit supports this use case.
if (0 == 1)
{
    zeroCards = GetCardsByProperty("value", 0)
    firstCardSlotsAllowed = 25
    achievement(title = "Non-nullary Counter [m]", points = 10,
        description = "Defeat Cloud without equipping any zero cards (Deck 1 only; first " + firstCardSlotsAllowed + " card slots only).",
        trigger = never(AnyCardsAreEquippedInDeck(zeroCards, deck1BaseAddr(), firstCardSlotsAllowed - 1)) && currentDeck() == 0
    )
}

function olympusColiseumStoryEntry() => bit6(0x0422f4)
achievement(
    title = "Memory of Heroism", description = "Complete Olympus Coliseum in Sora's story.", points = 5,
    id = 15588, badge = "14912", published = "10/16/2014 6:09:40 AM", modified = "7/7/2020 2:13:21 AM",
    trigger = WasBitflagSetInMainGame(olympusColiseumStoryEntry()) && IsInMainStory()
)

trickmasterHpMap = {
    2: 0x224,
    3: 0x255,
    4: 0x286,
    5: 0x2b7,
    6: 0x2e8,
    7: 0x318,
    8: 0x349,
    9: 0x37a,
    10: 0x3ab
}

function trickmasterHp() => word(battlePointer() + 0x94b8)

hitLimit = 3
achievement(title = "Double Jeopardy [m]", points = 5, id = 160370, badge = "180229",
    description = "Defeat the Trickmaster in Sora's story without getting hit more than twice.",
    trigger = BossHPValueCheckpointIsSet(trickmasterHp(), trickmasterHpMap, "Wonderland", 0x1)
        && EnemyWithSpecificAddressWasJustDefeated(trickmasterHp(), TRUE) && never(!IsInBattle())
        && never(repeated(hitLimit, Delta(playerHp()) > playerHp())) && IsInMainStory()
)

function wonderlandStoryEntry() => bit5(0x0422f4)
achievement(
    title = "Memory of the Rabbit Hole", description = "Complete Wonderland in Sora's story.", points = 5,
    id = 15590, badge = "14924", published = "10/16/2014 6:09:55 AM", modified = "7/7/2020 2:13:36 AM",
    trigger = WasBitflagSetInMainGame(wonderlandStoryEntry()) && IsInMainStory()
)

function larxeneHp() => word(battlePointer() + 0x8eec)
achievement(
    title = "The Savage Nymph", description = "Defeat Larxene on the sixth floor.", points = 3,
    id = 15591, badge = "180406", published = "10/16/2014 6:10:01 AM", modified = "7/7/2020 2:13:41 AM",
    trigger = never(!IsInWorld("Castle Oblivion, Hall")) && never(battlefieldId() != 0x0C) && BattleStartedCheckpoint() && IsOnFloor(6)
        && EnemyWithSpecificAddressWasJustDefeated(larxeneHp(), FALSE) && once(larxeneHp() == 0x460) && never(!IsInBattle()) && IsInMainStory()
)

maxStockedCards = 6
achievement(title = "Senary Hand [m]", points = 5, id = 160371, badge = "180230",
    description = "Defeat Larxene on the sixth floor without stocking more than six cards.",
    trigger = never(!IsInWorld("Castle Oblivion, Hall")) && never(battlefieldId() != 0x0C) && BattleStartedCheckpoint() && IsOnFloor(6)
        && EnemyWithSpecificAddressWasJustDefeated(larxeneHp(), TRUE) && once(larxeneHp() == 0x460)
        && never(repeated(maxStockedCards + 1, Delta(numberOfStockedCardsForPlayer()) < numberOfStockedCardsForPlayer())) && never(!IsInBattle()) && IsInMainStory()
)

function bambi() => bit1(0x042306)
function poohEnergyBars() => byte(0x0449d4)
achievement(title = "Save the Bees [m]", points = 5,
    description = "Earn the Bambi card from Pooh without having him restore energy more than once or letting it completely run out.",
    // Note: The Bambi bitflag is set slightly after the player leaves the world, so simply checking to see if the player is in the Hundred Acre Wood for the trigger
    // is incompatible with resetting if the player is not in the world. So we'll need to take a different approach here.
              // Ensure we reset after we leave the world, but only after the Bambi bitflag has a chance to flip.
    trigger = never(once(WasInWorld("the Hundred Acre Wood")) && repeated(2, !IsInWorld("the Hundred Acre Wood"))) && IsInMainStory()
        && once(!WasInWorld("the Hundred Acre Wood") && IsInWorld("the Hundred Acre Wood")) // Checkpoint when entering the world
        && trigger_when(WasBitflagSetInMainGame(bambi())) && never(poohEnergyBars() == 0)
        // Due to how we're programming this, we need to also make sure that the player is actually in the Hundred Acre Wood before increasing hit targets.
        && never(repeated(2, IsInWorld("the Hundred Acre Wood") && poohEnergyBars() > Delta(poohEnergyBars())))
)

poohGiftConditions = {
    0: GenerateConditionFromBitflag(bit2(0x0422D5)), // Confuse
    1: GenerateConditionFromBitflag(bit5(0x042303)), // Spellbinder
    2: GenerateConditionFromBitflag(bit3(0x042307)), // Elixir
    3: GenerateConditionFromBitflag(bit3(0x0422D6)), // Idyll Romp
    4: GenerateConditionFromBitflag(bit1(0x0422D5)), // Bind
    5: GenerateConditionFromBitflag(bit4(0x0422D5)), // Synchro
    6: GenerateConditionFromBitflag(bit1(0x042306)) // Bambi
}

GenerateCheevoFromConditions({
    "name": "Friendly Fellows",
    "description": "Acquire all card and sleight rewards from Pooh and his friends.",
    "points": 10,
    "id": 15592,
    "badge": "14926",
    "threshold": length(poohGiftConditions)
}, poohGiftConditions, IsInWorld("the Hundred Acre Wood") && IsInMainStory())

function rikuHp() => word(battlePointer() + 0x8d0c) // I, II, and III
achievement(
    title = "Driven to Seek", description = "Defeat Riku on the seventh floor in Sora's story.", points = 3,
    id = 15594, badge = "180404", published = "10/16/2014 6:11:05 AM", modified = "7/7/2020 2:13:55 AM",
    trigger = never(!IsInWorld("Castle Oblivion, Hall")) && never(battlefieldId() != 0x0C) && BattleStartedCheckpoint() && IsOnFloor(7)
        && EnemyWithSpecificAddressWasJustDefeated(rikuHp(), FALSE) && once(rikuHp() == 0x460) && IsInMainStory()
)

achievement(title = "Dark Leech [m]", points = 5, id = 160373, badge = "180232",
    description = "Defeat Riku on the seventh floor in Sora's story without healing.",
    trigger = never(!IsInWorld("Castle Oblivion, Hall")) && never(battlefieldId() != 0x0C) && BattleStartedCheckpoint() && IsOnFloor(7)
        && EnemyWithSpecificAddressWasJustDefeated(rikuHp(), TRUE) && once(rikuHp() == 0x460)
        && never(playerHp() > Delta(playerHp())) && IsInMainStory()
)

ursulaHpMap = {
    6: 0x253,
    7: 0x27a,
    8: 0x2a1,
    9: 0x2ca,
    10: 0x2ef,
}

// todo: retest!
theBendsTimeLimit = 45
function ursulaHp() => word(battlePointer() + 0x92d0)
achievement(title = "The Bends [m]", points = 25, id = 160376, badge = "180235",
    description = "Defeat Ursula in Sora's story without going more than " + theBendsTimeLimit + " seconds at a time without healing.",
    trigger = BossHPValueCheckpointIsSet(ursulaHp(), ursulaHpMap, "Atlantica", 0xb)
        && EnemyWithSpecificAddressWasJustDefeated(ursulaHp(), TRUE) && never(!IsInBattle())
        && disable_when(repeated(SecondsToFrames(theBendsTimeLimit), FrameHasAdvanced() && !IsPaused()), playerHp() > Delta(playerHp()) || !IsInBattle())
        && unless(IsPaused()) && IsInMainStory()
)

function atlanticaStoryEntry() => bit2(0x0422f5)
achievement(
    title = "Memory of Melodies", description = "Complete Atlantica in Sora's story.", points = 5,
    id = 15595, badge = "15004", published = "10/16/2014 6:11:11 AM", modified = "7/7/2020 2:16:28 AM",
    trigger = WasBitflagSetInMainGame(atlanticaStoryEntry()) && IsInMainStory()
)

function mainRikuIIHp() => word(battlePointer() + 0x8d4c)
itemCards = GetCardsByProperty("type", "Item")
magicCards = GetCardsByProperty("type", "Magic")
achievement(title = "Nothing but Fisticuffs [m]", points = 10, id = 160374, badge = "180233",
    description = "Defeat Riku on the eighth floor in Sora's story without equipping any item or magic cards (Deck 2 only).",
    trigger = never(!IsInWorld("Castle Oblivion, Hall")) && never(battlefieldId() != 0x0C) && BattleStartedCheckpoint() && IsOnFloor(8)
        && EnemyWithSpecificAddressWasJustDefeated(mainRikuIIHp(), TRUE) && once(mainRikuIIHp() == 0x460)
        && never(AnyCardsAreEquippedInDeck(MergeArrays(itemCards, magicCards), deck2BaseAddr(), 98, 0)) && currentDeck() == 1
        && IsInMainStory()
)

function warpinator() => bit7(0x0422D4)
achievement(
    title = "Driven to Seize", description = "Defeat Riku on the eighth floor in Sora's story.", points = 3,
    id = 15596, badge = "180402", published = "10/16/2014 6:11:18 AM", modified = "7/7/2020 2:16:42 AM",
    trigger = WasBitflagSetInMainGame(warpinator()) && IsInMainStory()
)

maleficentHpMap = {
    7: 0x3b7,
    8: 0x3f2,
    9: 0x42c,
    10: 0x467,
}

function maleficentHp() => word(battlePointer() + 0x8f34)
enemyCards = GetCardsByProperty("type", "Enemy")
achievement(title = "Benevolence vs. Malevolence [m]", points = 10, id = 160375, badge = "180234",
    description = "Defeat Maleficent in Sora's story without equipping any enemy cards (Deck 2 only).",
    trigger = BossHPValueCheckpointIsSet(maleficentHp(), maleficentHpMap, "Hollow Bastion", 0x7) && IsInMainStory()
        && EnemyWithSpecificAddressWasJustDefeated(maleficentHp(), TRUE)
        && never(AnyCardsAreEquippedInDeck(enemyCards, deck2BaseAddr(), 98, 0)) && currentDeck() == 1
)

function hollowBastionStoryEntry() => bit4(0x0422f5)
achievement(
    title = "Memory of Darkness", description = "Complete Hollow Bastion in Sora's story.", points = 5,
    id = 15597, badge = "15011", published = "10/16/2014 6:11:28 AM", modified = "7/7/2020 2:16:37 AM",
    trigger = WasBitflagSetInMainGame(hollowBastionStoryEntry()) && IsInMainStory()
)

hookHpMap = {
    1: 0x190,
    2: 0x1b7,
    3: 0x1d3,
    4: 0x205,
    5: 0x22c,
    6: 0x253,
    7: 0x27a,
    8: 0x2a1,
    9: 0x2c8,
    10: 0x2ef,
}

function hookHp() => word(battlePointer() + 0x8d8c)
achievement(title = "Amputated Hand [m]", points = 25, id = 160377, badge = "180236",
    description = "Defeat Hook in Sora's story using a deck with a CP cost of 350 or less.",
    trigger = BossHPValueCheckpointIsSet(hookHp(), hookHpMap, "Never Land", 0xe)
        && EnemyWithSpecificAddressWasJustDefeated(hookHp(), TRUE) && never(!IsInBattle())
        && CurrentDeckHasACPCostOfAtMost(350) && IsInMainStory()
)

function neverLandStoryEntry() => bit3(0x0422f5)
achievement(
    title = "Memory of Faith", description = "Complete Never Land in Sora's story.", points = 5,
    id = 15598, badge = "15013", published = "10/16/2014 6:11:35 AM", modified = "7/7/2020 2:16:47 AM",
    trigger = WasBitflagSetInMainGame(neverLandStoryEntry()) && IsInMainStory()
)

function mainVexenIHp() => word(battlePointer() + 0x91ec)
function vexenHp() => word(0x03ab4c)
vexenIHpMap = {
    10: 0x460
}

achievement(
    title = "The Chilly Academic", description = "Defeat Vexen on the tenth floor.", points = 3,
    id = 15611, badge = "180399", published = "10/16/2014 6:15:04 AM", modified = "7/7/2020 2:16:53 AM",
    trigger = BossHPValueCheckpointIsSet(mainVexenIHp(), vexenIHpMap, "Castle Oblivion, Hall", 0xf) && IsInMainStory()
        && EnemyWithSpecificAddressWasJustDefeated(mainVexenIHp(), FALSE) && never(!IsInBattle())
)

fireCards = GetCardsByProperty("element", "Fire")
achievement(title = "Broken Furnace [m]", points = 5, id = 160378, badge = "180237",
    description = "Defeat Vexen on the tenth floor in Sora's story without equipping any cards that deal fire-based damage (Deck 2 only).",
    trigger = BossHPValueCheckpointIsSet(mainVexenIHp(), vexenIHpMap, "Castle Oblivion, Hall", 0xf)
        && EnemyWithSpecificAddressWasJustDefeated(mainVexenIHp(), TRUE) && never(!IsInBattle()) && IsInMainStory()
        && never(AnyCardsAreEquippedInDeck(fireCards, deck2BaseAddr(), 98, FALSE))
)

function twilightTownStoryEntry() => bit6(0x0422f5)
achievement(
    title = "Memory of Dusk", description = "Complete Twilight Town in Sora's story.", points = 5,
    id = 15599, badge = "15017", published = "10/16/2014 6:11:42 AM", modified = "7/7/2020 2:16:58 AM",
    trigger = WasBitflagSetInMainGame(twilightTownStoryEntry()) && IsInMainStory()
)

vexenIIHpMap = {
    11: 0x460
}

function vexenEnemyCardEffect() => dword(0x03bcf4)
function VexenAutoLifeIsActive() => vexenEnemyCardEffect() == 0x1b

function PlayerSlipped() => Delta(soraBattleState()) != soraBattleState() && soraBattleState() == 0x24
function PlayerIsFrozen() => Delta(soraBattleState()) != soraBattleState() && soraBattleState() == 0x53
achievement(title = "Sturdy Footing [m]", points = 10,
    description = "Defeat Vexen in Twilight Town without slipping on ice or getting frozen more than once.",
    trigger = BossHPValueCheckpointIsSet(vexenHp(), vexenIIHpMap, "Twilight Town", 0x7) && IsInMainStory()
        && EnemyWithSpecificAddressWasJustDefeated(vexenHp(), TRUE) && never(!IsInBattle())
        && never(tally(2, [ PlayerSlipped(), PlayerIsFrozen() ]))
        && trigger_when(!VexenAutoLifeIsActive()) // The cheevo will trigger prematurely if Vexen's HP goes to zero when he has Auto-Life active, so we need to check for it.
)

function PlayerIsPerformingNormalAttack() => soraBattleState() == 0x10
achievement(title = "Prestidigitation [m]", points = 25,
    description = "Defeat Riku on the eleventh floor in Sora's story without using attack cards for anything but sleights, and without equipping magic cards (Deck 2 only).",
    trigger = never(!IsInWorld("Castle Oblivion, Hall")) && never(battlefieldId() != 0x0C) && BattleStartedCheckpoint() && IsOnFloor(11)
        && EnemyWithSpecificAddressWasJustDefeated(rikuHp(), TRUE) && once(rikuHp() == 0x460)
        && never(AnyCardsAreEquippedInDeck(magicCards, deck2BaseAddr(), 98, FALSE)) && currentDeck() == 1
        && never(PlayerIsPerformingNormalAttack()) && IsInMainStory()
)

achievement(
    title = "Driven to Atone", description = "Defeat Riku on the eleventh floor in Sora's story.", points = 3,
    id = 15619, badge = "15018", published = "10/16/2014 6:17:47 AM", modified = "7/7/2020 2:17:03 AM",
    trigger = never(!IsInWorld("Castle Oblivion, Hall")) && never(battlefieldId() != 0x0C) && BattleStartedCheckpoint() && IsOnFloor(11)
        && EnemyWithSpecificAddressWasJustDefeated(rikuHp(), FALSE) && once(rikuHp() == 0x460) && IsInMainStory()
)

darksideHpMap = {
    12: 0x77a
}

function darksideHp() => word(0x03ac9c)

attackCards = GetCardsByProperty("type", "Attack")

achievement(title = "Limited Pools [m]", points = 25,
    description = "Defeat Darkside in Sora's story without equipping any item cards and without manually reloading more than five times (Deck 2 only).",
    trigger = BossHPValueCheckpointIsSet(darksideHp(), darksideHpMap, "Destiny Islands", 0x6) && IsInMainStory()
        && EnemyWithSpecificAddressWasJustDefeated(darksideHp(), TRUE) && never(!IsInBattle())
        && never(AnyCardsAreEquippedInDeck(itemCards, deck2BaseAddr(), 98, FALSE))
        && never(repeated(6, Delta(playerReloadCounter()) != 0xffff && playerReloadCounter() == 0xffff))
)

function destinyIslandsStoryEntry() => bit7(0x0422f5)
achievement(
    title = "Memory of Paradise", description = "Complete the Destiny Islands in Sora's story.", points = 5,
    id = 15600, badge = "15020", published = "10/16/2014 6:11:58 AM", modified = "7/7/2020 2:17:08 AM",
    trigger = WasBitflagSetInMainGame(destinyIslandsStoryEntry()) && IsInMainStory()
)

nonKingdomKeyAttackCards = []

for card in attackCards
{
    if (card["name"] != "Kingdom Key")
    {
        array_push(nonKingdomKeyAttackCards, card)
    }
}

achievement(title = "Humble Roots [m]", points = 50,
    description = "Defeat Riku on the twelfth floor in Sora's story without equipping any attack cards that aren't the Kingdom Key (Deck 2 only).",
    trigger = never(!IsInWorld("Castle Oblivion, Hall")) && never(battlefieldId() != 0x0C) && BattleStartedCheckpoint() && IsOnFloor(12) && IsInMainStory()
        && EnemyWithSpecificAddressWasJustDefeated(rikuHp(), TRUE) && once(rikuHp() == 0x690)
        && never(AnyCardsAreEquippedInDeck(nonKingdomKeyAttackCards, deck2BaseAddr(), 98, FALSE)) && currentDeck() == 1
)

achievement(
    title = "Driven to Protect", description = "Defeat Riku on the twelfth floor in Sora's story.", points = 3,
    id = 15602, badge = "15022", published = "10/16/2014 6:12:11 AM", modified = "7/7/2020 2:17:13 AM",
    trigger = never(!IsInWorld("Castle Oblivion, Hall")) && never(battlefieldId() != 0x0C) && BattleStartedCheckpoint() && IsOnFloor(12) && IsInMainStory()
        && EnemyWithSpecificAddressWasJustDefeated(rikuHp(), FALSE) && once(rikuHp() == 0x690)
)

achievement(
    title = "Quelled Savagery", description = "Defeat Larxene on the twelfth floor.", points = 3,
    id = 15601, badge = "15025", published = "10/16/2014 6:12:06 AM", modified = "7/7/2020 2:17:19 AM",
    trigger = never(!IsInWorld("Castle Oblivion, Hall")) && never(battlefieldId() != 0x0C) && BattleStartedCheckpoint() && IsOnFloor(12) && IsInMainStory()
        && EnemyWithSpecificAddressWasJustDefeated(larxeneHp(), FALSE) && once(larxeneHp() == 0x690)
)

achievement(title = "A Weighty Decision [m]", points = 10,
    description = "Defeat Larxene on the twelfth floor using a deck with a size of at most 20 cards and a CP cost of 450 or less.",
    trigger = never(!IsInWorld("Castle Oblivion, Hall")) && never(battlefieldId() != 0x0C) && BattleStartedCheckpoint() && IsOnFloor(12) && IsInMainStory()
        && EnemyWithSpecificAddressWasJustDefeated(larxeneHp(), TRUE) && once(larxeneHp() == 0x690)
        && CurrentDeckHasACPCostOfAtMost(450) && CurrentDeckHasASizeOfAtMost(20)
)

function axelHp() => word(0x03ab2c)
achievement(
    title = "Got It Memorized?", description = "Defeat Axel on the thirteenth floor.", points = 3,
    id = 15603, badge = "15026", published = "10/16/2014 6:12:19 AM", modified = "7/7/2020 2:17:25 AM",
    trigger = never(!IsInWorld("Castle Oblivion")) && never(battlefieldId() != 0x0C) && BattleStartedCheckpoint() && IsOnFloor(13) && IsInMainStory()
        && EnemyWithSpecificAddressWasJustDefeated(axelHp(), FALSE) && once(axelHp() == 0x690)
)

achievement(title = "Portfolio in Hand [m]", points = 10,
    description = "Defeat Axel on the thirteenth floor using a deck containing at least 50 cards.",
    trigger = never(!IsInWorld("Castle Oblivion")) && never(battlefieldId() != 0x0C) && BattleStartedCheckpoint() && IsOnFloor(13) && IsInMainStory()
        && EnemyWithSpecificAddressWasJustDefeated(axelHp(), TRUE) && once(axelHp() == 0x690)
        && CurrentDeckHasASizeOfAtLeast(50)
)

function marluxiaHp() => word(0x03a9ac)
achievement(title = "Critical Duelist [m]", points = 25,
    description = "Defeat Marluxia's first phase using a deck with a CP cost of 275 or lower.",
    trigger = never(!IsInWorld("Castle Oblivion, Hall")) && never(battlefieldId() != 0x0C) && BattleStartedCheckpoint() && IsOnFloor(13) && IsInMainStory()
        && EnemyWithSpecificAddressWasJustDefeated(marluxiaHp(), TRUE) && once(marluxiaHp() == 0x8c0)
        && CurrentDeckHasACPCostOfAtMost(275)
)

achievement(
    title = "The Graceful Assassin", description = "Defeat Marluxia's first phase.", points = 5,
    id = 15604, badge = "15027", published = "10/16/2014 6:12:29 AM", modified = "7/7/2020 2:17:38 AM",
    trigger = never(!IsInWorld("Castle Oblivion, Hall")) && never(battlefieldId() != 0x0C) && BattleStartedCheckpoint() && IsOnFloor(13) && IsInMainStory()
        && EnemyWithSpecificAddressWasJustDefeated(marluxiaHp(), FALSE) && once(marluxiaHp() == 0x8c0)
)

marluxiaIIMaxHpValue = 0x8bd
function marluxiaIIHp() => word(0x039f50)
function marluxiaIIMaxHp() => word(0x039f52)
function PlayerIsUsingSummon() => Delta(soraBattleState()) == 0x12 || Delta(soraBattleState()) >= 0x17 && Delta(soraBattleState()) <= 0x1b

// Appears to affect which summon is used during Marluxia II (16-bit)
//
// 0x8cc4 = Cloud
// 0x8cdc = Bambi
// 0x8cf4 = Tinker Bell
// 0x8d24 = Simba
// 0x8d3c = Mushu
// 0x8d54 = Dumbo
// 0x8d6c = Genie
// 0x8d9c = Donald
// 0x8db4 = Goofy
function summonLastUsed() => word(0x03b26c)
function DonaldOrGoofyIsActive() => summonLastUsed() == 0x8d9c || summonLastUsed() == 0x8db4
    
achievement(title = "Come Forth, Blue-Eyes White Dragon! [m]", points = 5,
    description = "Finish off Marluxia's second phase with a summon.",
    trigger = never(!IsInWorld("Castle Oblivion, Hall")) && never(battlefieldId() != 0x0C) && BattleStartedCheckpoint() && IsOnFloor(13) && IsInMainStory()
        // We're not using EnemyWithSpecificAddressWasJustDefeated() because the battle pointer is set to NULL as soon as Marluxia's HP goes to zero.
        // So we need to make sure that it has time to recognize his HP as zero.
        && trigger_when(Delta(marluxiaIIHp()) > 0 && marluxiaIIHp() == 0)
        && once(marluxiaIIHp() == marluxiaIIMaxHpValue)
        && trigger_when(PlayerIsUsingSummon())
        && trigger_when(!DonaldOrGoofyIsActive())
        
        // Different reset conditions, since we can't rely on just the battle pointer.
        && never(playerHp() == 0)
        && never(roomId() != 0xfd)
        && never(!IsInBattle() && Delta(marluxiaIIMaxHp()) == marluxiaIIMaxHpValue && marluxiaIIMaxHp() != marluxiaIIMaxHpValue)
)

// Credits state (32-bit)
//
// <garbage; probably 0x21082108> -> 0x0 = transition to credits
// 0x0 -> 0x1 = credits start
// 0x1 -> 0x2 = crawling credits start
// 0x2 -> 0x3 = title drop at the end of the credits
// 0x3 -> 0x5 = sleeping pod still
// 0x5 -> 0x6 = KHII Sora sleeping still
// 0x6 -> 0x4 = poetic blurb
// 0x4 -> 0xa = "The End"

function CreateHitTargetedAndNextChain(permutation)
{
    trigger = always_true()
    
    for condition in permutation
    {
        trigger = once(trigger && once(condition))
    }
    
    return trigger
}

function creditsState() => dword(0x03bbc8)
function CreditsStarted() => never(creditsState() > 0x10) && CreateHitTargetedAndNextChain([
    Delta(creditsState()) != 0 && creditsState() == 0,
    Delta(creditsState()) == 0 && creditsState() == 1
])
function marluxiaCardEntry() => bit0(0x04230E)
achievement(
    title = "Memory of Her", description = "Complete Sora's story.", points = 25,
    id = 15605, badge = "15028", published = "10/16/2014 6:12:38 AM", modified = "7/7/2020 2:17:42 AM",
    trigger = never(!IsInWorld("Castle Oblivion, Hall")) && never(battlefieldId() != 0x0C) && IsOnFloor(13) && marluxiaCardEntry() == 1
        && CreditsStarted() && IsInMainStory()
)

achievement(
    title = "Critical Competitor [m]", description = "Complete Sora's story without upgrading HP.", points = 50,
    id = 41892, badge = "43183", published = "11/8/2016 6:47:54 PM", modified = "7/7/2020 2:25:02 AM",
    trigger = never(!IsInWorld("Castle Oblivion, Hall")) && never(battlefieldId() != 0x0C) && IsOnFloor(13) && marluxiaCardEntry() == 1
        && CreditsStarted() && maxHp() == 0x0050 && IsInMainStory()
)

architectBitflags = [
    bit0(0x04230F),
    bit1(0x04230F),
    bit2(0x04230F),
    bit3(0x04230F),
    bit4(0x04230F),
    bit5(0x04230F),
    bit6(0x04230F),
    bit7(0x04230F),
    bit0(0x042310),
    bit1(0x042310),
    bit2(0x042310),
    bit3(0x042310),
    bit4(0x042310),
    bit5(0x042310),
    bit6(0x042310),
    bit7(0x042310),
    bit1(0x04230E),
    bit2(0x04230E),
    bit3(0x04230E),
    bit4(0x04230E),
    bit5(0x04230E),
    bit6(0x04230E),
    bit7(0x04230E),
    bit0(0x042311),
    bit1(0x042311),
    bit2(0x042311),
]

GenerateCheevoFromBitflags({
    "name": "Architect",
    "description": "Complete the Map Cards section of Jiminy's journal.",
    "points": 10,
    "id": 15612,
    "badge": "15228",
    "threshold": length(architectBitflags)
}, architectBitflags, IsInMainStory())

function slidingDash() => bit0(0x0422cc)
function blazingDonaldUnlocked() => bit3(0x0422d7)
function stopRaid() => bit3(0x0422cf)
function quake() => bit6(0x0422d4)
function thunderRaid() => bit1(0x0422cf)
function warp() => bit0(0x0422D5)
function firagaBreak() => bit0(0x0422d4)
function fireBreak() => bit7(0x0422ce)
function crossSlashPlus() => bit1(0x0422d7)
function judgment() => bit4(0x0422cf)
function blizzardRaid() => bit0(0x0422cf)
function homingBlizzara() => bit2(0x0422d4)
function gravityRaid() => bit2(0x0422cf)
function megalixir() => bit4(0x042307)
function stop() => bit5(0x042305)
function gravityCardEntry() => bit4(0x042305)
function mushu() => bit4(0x042306)

maleficentDeckOffset = 0x74
function reloadStateDuringRikuMaleficentBattle() => byte(0x03a628)
function JustStartedReloadingDuringRikuMaleficentBattle() => Delta(reloadStateDuringRikuMaleficentBattle()) == 0 && reloadStateDuringRikuMaleficentBattle() == 1
maleficentHpMapReverse = {
    1: 0x12c
}
function maleficentHpReverse() => word(0x03ac14)

achievement(title = "Double Dipping [m]", points = 10,
    description = "Defeat Maleficent in Reverse/Rebirth without reloading more than once using your reload card.",
    trigger = BossHPValueCheckpointIsSet(maleficentHpReverse(), maleficentHpMapReverse, "Hollow Bastion", 0x8) && IsInReverseRebirth()
        && EnemyWithSpecificAddressWasJustDefeated(maleficentHpReverse(), TRUE) && never(!IsInBattle())
        && never(repeated(2, JustStartedReloadingDuringRikuMaleficentBattle()))
)

achievement(
    title = "The Depths of Darkness", description = "Defeat Maleficent in Reverse/Rebirth.", points = 5,
    id = 15651, badge = "15121", published = "10/16/2014 6:27:09 AM", modified = "7/7/2020 2:26:33 AM",
    trigger = BossHPValueCheckpointIsSet(maleficentHpReverse(), maleficentHpMapReverse, "Hollow Bastion", 0x8) && IsInReverseRebirth()
        && EnemyWithSpecificAddressWasJustDefeated(maleficentHpReverse(), FALSE) && never(!IsInBattle())
)

hpThreshold = 10
function ansemHp() => rikuHp()
function DefeatedAnsemOnFloorB12(useTrigger) => never(!IsInWorld("Castle Oblivion, Hall")) && never(battlefieldId() != 0x0C) && BattleStartedCheckpoint() && IsOnFloor(1)
        && EnemyWithSpecificAddressWasJustDefeated(ansemHp(), useTrigger) && once(ansemHp() == 0x190) && IsInReverseRebirth()
achievement(title = "Fighting Hearty [m]", points = 5,
    description = "Defeat Ansem on Floor B12 without your HP being at more than " + hpThreshold + " below its maximum.",
    trigger = DefeatedAnsemOnFloorB12(TRUE)
        && never(rikuPlayerHp() < maxHp() - hpThreshold)
)

achievement(
    title = "The Seeker of Darkness", description = "Defeat Ansem on Floor B12.", points = 3,
    id = 15652, badge = "15104", published = "10/16/2014 6:27:15 AM", modified = "7/7/2020 2:26:27 AM",
    trigger = DefeatedAnsemOnFloorB12(FALSE)
)

function jafarHp() => word(0x03abfc)
function jafarMaxHp() => word(0x03abfe)
function AlternativeNotInBattleCheck(maxHpMem, hpMap)
{
    trigger = always_true()
    
    for floor in hpMap
    {
        maxHpValue = hpMap[floor]
        trigger = trigger && never(!IsInBattle() && Delta(maxHpMem) == maxHpValue && maxHpMem != maxHpValue)
    }
    
    return trigger
}

function WasJafarJustDefeated(useTriggerWhen)
{
    finalTrigger = Delta(jafarHp()) > 0 && jafarHp() == 0
    
    if (useTriggerWhen == TRUE)
    {
        finalTrigger = trigger_when(finalTrigger)
    }
    
    return // We're not using EnemyWithSpecificAddressWasJustDefeated() because the battle pointer is set to NULL as soon as Jafar's HP goes to zero.
        // So we need to make sure that it has time to recognize his HP as zero.
        finalTrigger
        && BossHPValueCheckpointIsSet(jafarHp(), jafarHpMap, "Agrabah", 0x2)
        
        // Different reset conditions, since we can't rely on just the battle pointer.
        && never(rikuPlayerHp() == 0)
        && AlternativeNotInBattleCheck(jafarMaxHp(), jafarHpMap)
}

achievement(
    title = "The Depths of Treasure", description = "Defeat Jafar in Reverse/Rebirth.", points = 5,
    id = 15653, badge = "15126", published = "10/16/2014 6:27:21 AM", modified = "7/7/2020 2:26:20 AM",
    trigger = IsInReverseRebirth()
        && WasJafarJustDefeated(FALSE)
)

achievement(title = "Wishproof [m]", description = "Defeat Jafar in Reverse/Rebirth without getting hit.", points = 10,
    trigger = IsInReverseRebirth()
        && never(rikuPlayerHp() < Delta(rikuPlayerHp()))
        && WasJafarJustDefeated(TRUE)
)

function parasiteCageReverseRebirthHp() => word(0x038ea0)

function EnteredBattleWithParasiteCageInReverseRebirth() => BossHPValueCheckpointIsSet(parasiteCageReverseRebirthHp(), parasiteCageHpMap, "Monstro", 0x2) && never(!IsInBattle())

function DefeatedParasiteCageInReverseRebirth(useTrigger) => EnteredBattleWithParasiteCageInReverseRebirth()
    && EnemyWithSpecificAddressWasJustDefeated(parasiteCageReverseRebirthHp(), useTrigger)

achievement(
    title = "The Depths of a Wish", description = "Defeat the Parasite Cage in Reverse/Rebirth.", points = 5,
    id = 15654, badge = "15130", published = "10/16/2014 6:27:28 AM", modified = "7/7/2020 2:26:13 AM",
    trigger = IsInReverseRebirth() && DefeatedParasiteCageInReverseRebirth(FALSE)
)

function verticalPosition() => dword(playerBattlePointer() + 0x7cb0)

function IsOnGroundDuringParasiteCageFight()
{
    return verticalPosition() >= 0xfffff800 || verticalPosition() == 0x0
}

timeLimit = 60
achievement(title = "The Floor Is Poison [m]", points = 25,
    description = "Defeat the Parasite Cage in Reverse/Rebirth without touching the ground for longer than " + SecondsToFormat(timeLimit) + ".",
    trigger = IsInReverseRebirth() && DefeatedParasiteCageInReverseRebirth(TRUE)
        && never(repeated(SecondsToFrames(timeLimit), IsOnGroundDuringParasiteCageFight()))
        && unless(IsPaused())
)

function currentDarkPoints() => word(0x03bfc8)
function vexenReverseRebirthHp() => word(0x03a98c)

function WasVexenDefeatedInReverseRebirth(useTrigger) => never(!IsInWorld("Castle Oblivion, Hall")) && never(battlefieldId() != 0x0C) && BattleStartedCheckpoint() && IsOnFloor(3)
    && IsInReverseRebirth()
        && EnemyWithSpecificAddressWasJustDefeated(vexenReverseRebirthHp(), useTrigger) && once(vexenReverseRebirthHp() == 0x460)

achievement(
    title = "In Search of Data", description = "Defeat Vexen in Reverse/Rebirth.", points = 3,
    id = 15655, badge = "15144", published = "10/16/2014 6:27:34 AM", modified = "7/7/2020 2:26:08 AM",
    trigger = WasVexenDefeatedInReverseRebirth(FALSE) && !VexenAutoLifeIsActive()
)

achievement(title = "Endless Seething [m]", points = 10,
    description = "Defeat Vexen in Reverse/Rebirth without ever leaving Dark Mode, if activated.",
    trigger = WasVexenDefeatedInReverseRebirth(TRUE)
        && never(currentDarkPoints() == 0 && Delta(currentDarkPoints()) > 0)
        && trigger_when(!VexenAutoLifeIsActive()) // The cheevo will trigger prematurely if Vexen's HP goes to zero when he has Auto-Life active, so we need to check for it.
)

function hookReverseRebirthHp() => word(0x03a9ec)
function enemyCardsLeft() => byte(battlePointer() + 0x8856)

function HookReverseRebirthBattleCheckpointReachedAndBattleWon(useTrigger) => BossHPValueCheckpointIsSet(hookReverseRebirthHp(), hookHpMap, "Never Land", 0x6)
        && EnemyWithSpecificAddressWasJustDefeated(hookReverseRebirthHp(), useTrigger) && never(!IsInBattle())
        && IsInReverseRebirth()

achievement(
    title = "The Depths of Faith", description = "Defeat Hook in Reverse/Rebirth.", points = 5,
    id = 15656, badge = "15145", published = "10/16/2014 6:27:38 AM", modified = "7/7/2020 2:26:03 AM",
    trigger = HookReverseRebirthBattleCheckpointReachedAndBattleWon(FALSE)
)

achievement(title = "Retired, Extremely Dangerous [m]", points = 10,
    description = "Defeat Hook in Reverse/Rebirth without using any enemy cards.",
    trigger = HookReverseRebirthBattleCheckpointReachedAndBattleWon(TRUE) && never(enemyCardsLeft() < Delta(enemyCardsLeft()))
)

function guardArmorReverseRebirthHp() => word(0x03a32c)
function GuardArmorWasDefeatedInReverseRebirth(useTrigger) => once(BossHPValueCheckpointIsSetForAnyFloor(guardArmorReverseRebirthHp(), 0xc8, "Traverse Town", 0x7))
        && IsInReverseRebirth()
        && EnemyWithSpecificAddressWasJustDefeated(guardArmorReverseRebirthHp(), useTrigger) && never(!IsInBattle())

achievement(
    title = "The Depths of Worlds Lost", description = "Defeat the Guard Armor in Reverse/Rebirth.", points = 5,
    id = 15657, badge = "15149", published = "10/16/2014 6:27:45 AM", modified = "7/7/2020 2:25:58 AM",
    trigger = GuardArmorWasDefeatedInReverseRebirth(FALSE)
)

function AccumulatedGivenNumberOfDarkPoints(dpThreshold)
{
    conditions = []
    for i in range(1, 9) // Different number of increases that DP can possibly change by.
    {
        // We have to duplicate the conditions here in order to emulate MultHits, which, as of this writing, there don't appear to be plans to support.
        for j in range(1, i)
        {
            array_push(conditions, currentDarkPoints() - Delta(currentDarkPoints()) == i)
        }
    }
    
    return tally(dpThreshold, conditions)
}

dpLimit = 18
achievement(title = "Purity [m]", points = 10,
    description = "Defeat the Guard Armor in Reverse/Rebirth without accumulating a total of " + dpLimit + " Dark Points over the course of the battle.",
    trigger = GuardArmorWasDefeatedInReverseRebirth(TRUE)
        && never(AccumulatedGivenNumberOfDarkPoints(dpLimit))
)

function rikuReplicaB8Hp() => word(0x03a80c)
function WasRikuReplicaDefeatedOnFloorB8(useTrigger) => never(!IsInWorld("Castle Oblivion, Hall")) && never(battlefieldId() != 0x0C) && BattleStartedCheckpoint() && IsOnFloor(5)
    && IsInReverseRebirth() && EnemyWithSpecificAddressWasJustDefeated(rikuReplicaB8Hp(), useTrigger) && once(rikuReplicaB8Hp() == 0x460)

// todo: include this title change in a new revision proposal
achievement(
    title = "My Shadow", description = "Defeat the Riku replica on Floor B8.", points = 3,
    id = 15658, badge = "15152", published = "10/16/2014 6:27:52 AM", modified = "7/7/2020 2:25:53 AM",
    trigger = WasRikuReplicaDefeatedOnFloorB8(FALSE)
)

function TotalButtonsUsed(buttonThreshold)
{
    return tally(buttonThreshold, [ once(aIsPressed() == 1), once(bIsPressed() == 1), once(lIsPressed() == 1), once(rIsPressed() == 1),
        once(startIsPressed() == 1), once(selectIsPressed() == 1), once(dpadUpPressed() == 1), once(dpadDownPressed() == 1),
        once(dpadLeftPressed() == 1), once(dpadRightPressed() == 1) ])
}

buttonLimit = 4
achievement(title = "Technical Tightrope [m]", points = 10,
    description = "Defeat the Riku replica on Floor B8 without using any more than " + buttonLimit + " different buttons.",
    trigger = WasRikuReplicaDefeatedOnFloorB8(TRUE) && never(TotalButtonsUsed(buttonLimit + 1))
)

function ursulaReverseRebirthHp() => word(0x03ac10)
function WasUrsulaDefeatedInReverseRebirth(useTrigger) => BossHPValueCheckpointIsSet(ursulaReverseRebirthHp(), ursulaHpMap, "Atlantica", 0x7)
        && EnemyWithSpecificAddressWasJustDefeated(ursulaReverseRebirthHp(), useTrigger) && never(!IsInBattle())
        && IsInReverseRebirth()

achievement(
    title = "The Depths of Melodies", description = "Defeat Ursula in Reverse/Rebirth.", points = 5,
    id = 15659, badge = "15153", published = "10/16/2014 6:27:57 AM", modified = "7/7/2020 2:25:48 AM",
    trigger = WasUrsulaDefeatedInReverseRebirth(FALSE)
)

achievement(title = "Medical Negligence [m]", points = 5,
    description = "Defeat Ursula in Reverse/Rebirth without healing.",
    trigger = WasUrsulaDefeatedInReverseRebirth(TRUE) && never(rikuPlayerHp() > Delta(rikuPlayerHp()))
)

function oogieBoogieReverseRebirthHp() => word(0x03ac2c)
function WasOogieBoogieDefeatedInReverseRebirth(useTrigger) => BossHPValueCheckpointIsSet(oogieBoogieReverseRebirthHp(), oogieBoogieHpMap, "Halloween Town", 0x4)
        && EnemyWithSpecificAddressWasJustDefeated(oogieBoogieReverseRebirthHp(), useTrigger) && never(!IsInBattle())
        && IsInReverseRebirth()

achievement(
    title = "The Depths of Memory", description = "Defeat Oogie Boogie in Reverse/Rebirth.", points = 5,
    id = 15660, badge = "15154", published = "10/16/2014 6:28:03 AM", modified = "7/7/2020 2:25:43 AM",
    trigger = WasOogieBoogieDefeatedInReverseRebirth(FALSE)
)

function isReloadingDuringOogieBoogieReverseRebirthBattle() => byte(0x03a668) == 1 || IsUsingKingMickey() // King Mickey reloading, for some reason, counts as a card use, and we don't want that.
function oogieBoogieEnemyCardsLeft() => word(0x03a656)
function oogieBoogieRegularCardsLeft() => word(0x03a650)
function UsedCardInOogieBoogieBattle() => Delta(oogieBoogieRegularCardsLeft()) > oogieBoogieRegularCardsLeft()
    || Delta(oogieBoogieEnemyCardsLeft()) > oogieBoogieEnemyCardsLeft()
cardLimit = 40
achievement(title = "Underplay [m]", points = 10,
    description = "Defeat Oogie Boogie in Reverse/Rebirth using only " + cardLimit + " cards or less.",
    trigger = WasOogieBoogieDefeatedInReverseRebirth(TRUE)
        && never(repeated(cardLimit + 1, UsedCardInOogieBoogieBattle()))
        && unless(isReloadingDuringOogieBoogieReverseRebirthBattle())
)

function hadesReverseRebirthHp() => word(0x03a92c)
function WasHadesDefeatedInReverseRebirth(useTrigger) => BossHPValueCheckpointIsSet(hadesReverseRebirthHp(), hadesHpMap, "Olympus Coliseum", 0x8)
        && EnemyWithSpecificAddressWasJustDefeated(hadesReverseRebirthHp(), useTrigger) && never(!IsInBattle())
        && IsInReverseRebirth()

achievement(
    title = "The Depths of Heroism", description = "Defeat Hades in Reverse/Rebirth.", points = 5,
    id = 15661, badge = "15159", published = "10/16/2014 6:28:08 AM", modified = "7/7/2020 2:25:39 AM",
    trigger = WasHadesDefeatedInReverseRebirth(FALSE)
)

achievement(title = "Without Sin [m]", points = 25,
    description = "Defeat Hades in Reverse/Rebirth without activating Dark Mode.",
    trigger = WasHadesDefeatedInReverseRebirth(TRUE)
        && never(IsActivatingDarkMode())
)

function trickmasterReverseRebirthHp() => word(0x03a7b8)
function WasTrickmasterDefeatedInReverseRebirth(useTrigger) => BossHPValueCheckpointIsSet(trickmasterReverseRebirthHp(), trickmasterHpMap, "Wonderland", 0x6)
        && EnemyWithSpecificAddressWasJustDefeated(trickmasterReverseRebirthHp(), useTrigger) && never(!IsInBattle())
        && IsInReverseRebirth()

achievement(
    title = "The Depths of the Rabbit Hole", description = "Defeat the Trickmaster in Reverse/Rebirth.", points = 5,
    id = 15662, badge = "15164", published = "10/16/2014 6:28:12 AM", modified = "7/7/2020 2:25:35 AM",
    trigger = WasTrickmasterDefeatedInReverseRebirth(FALSE)
)

cardLimit = 32
function isManuallyReloadingDuringTrickmasterBattleInReverseRebirth() => byte(0x039ba8)
achievement(title = "From the Graveyard [m]", points = 10,
    description = "Defeat the Trickmaster in Reverse/Rebirth without reloading more than " + cardLimit + " cards, except via Dark Mode or MM Miracle.",
    trigger = WasTrickmasterDefeatedInReverseRebirth(TRUE)
        && never(ReloadedNumberOfCards(cardLimit + 1, 0x81e0, 12))
        && unless(IsActivatingDarkMode() || IsUsingKingMickey())
)

function lexaeusHp() => vexenReverseRebirthHp()
function WasLexaeusDefeated(useTrigger) => never(!IsInWorld("Castle Oblivion, Hall")) && never(battlefieldId() != 0x0C) && BattleStartedCheckpoint() && IsOnFloor(9)
    && IsInReverseRebirth()
    && EnemyWithSpecificAddressWasJustDefeated(lexaeusHp(), useTrigger) && once(lexaeusHp() == 0x690)

achievement(
    title = "The Silent Hero", description = "Defeat Lexaeus.", points = 3,
    id = 15663, badge = "15166", published = "10/16/2014 6:28:17 AM", modified = "7/7/2020 2:25:27 AM",
    trigger = WasLexaeusDefeated(FALSE)
)

halfwayPoint = 0x11100 // This is technically further right than the center of the battlefield, but I figure the extra buffer space will feel better and be more intuitive.
achievement(title = "Half the Floor Is Lava [m]", points = 10,
    description = "Defeat Lexaeus without crossing into the right half of the battlefield.",
    trigger = WasLexaeusDefeated(TRUE) && never(rikuXCoord() >= halfwayPoint)
)

function darksideReverseRebirthHp() => word(0x03aadc)
function WasDarksideDefeatedInReverseRebirth(useTrigger) => never(!IsInWorld("Destiny Islands")) && never(battlefieldId() != 0x9) && BattleStartedCheckpoint() && IsOnFloor(10)
    && IsInReverseRebirth()
    && EnemyWithSpecificAddressWasJustDefeated(darksideReverseRebirthHp(), useTrigger) && once(darksideReverseRebirthHp() == 0x467)

achievement(
    title = "The Depths of Paradise", description = "Defeat the Darkside in Reverse/Rebirth.", points = 5,
    id = 15664, badge = "15174", published = "10/16/2014 6:28:24 AM", modified = "7/7/2020 2:25:23 AM",
    trigger = WasDarksideDefeatedInReverseRebirth(FALSE)
)

darksideDeckSize = 19
cardLimit = 70
achievement(title = "Decked Out [m]", points = 25,
    description = "Defeat the Darkside in Reverse/Rebirth without reloading more than " + cardLimit + " cards.",
    trigger = WasDarksideDefeatedInReverseRebirth(TRUE)
        && never(ReloadedNumberOfCards(cardLimit + 1, 0x81e0, darksideDeckSize))
)

function rikuIIReverseRebirthHp() => rikuReplicaB8Hp()
function WasRikuReplicaDefeatedOnFloorB2(useTrigger) => never(!IsInWorld("Twilight Town")) && roomId() == 0x2 && BattleStartedCheckpoint() && IsOnFloor(11)
    && IsInReverseRebirth() && EnemyWithSpecificAddressWasJustDefeated(rikuIIReverseRebirthHp(), useTrigger) && once(rikuIIReverseRebirthHp() == 0x690)

achievement(
    title = "The Depths of Dusk", description = "Defeat the Riku replica on Floor B2.", points = 5,
    id = 15665, badge = "15178", published = "10/16/2014 6:28:32 AM", modified = "7/7/2020 2:25:18 AM",
    trigger = WasRikuReplicaDefeatedOnFloorB2(FALSE)
)

// todo: retest!
function IsInDarkMode() => rikuBattleState() == 0x20
achievement(title = "To the Shadow Realm with You! [m]", points = 5,
    description = "Finish off the Riku replica on Floor B2 in Dark Mode.",
    trigger = WasRikuReplicaDefeatedOnFloorB2(TRUE) && trigger_when(once(IsInDarkMode()))
        && disable_when(rikuBattleState() == 0x22, IsInDarkMode())
)

function ansemB1Hp() => word(0x03a9cc)
function WasAnsemDefeatedOnFloorB1(useTrigger) => never(!IsInWorld("Castle Oblivion")) && roomId() == 0x2 && BattleStartedCheckpoint() && IsOnFloor(12)
    && IsInReverseRebirth() && EnemyWithSpecificAddressWasJustDefeated(ansemB1Hp(), useTrigger) && once(ansemB1Hp() == 0x8c0)

achievement(
    title = "The Road to Dawn", description = "Escape Castle Oblivion in Reverse/Rebirth.", points = 25,
    id = 15666, badge = "15179", published = "10/16/2014 6:28:40 AM", modified = "7/7/2020 2:25:14 AM",
    trigger = never(!IsInWorld("Castle Oblivion")) && never(battlefieldId() != 0x0C) && IsOnFloor(12) && CreditsStarted() && IsInReverseRebirth()
)

achievement(title = "Nullary Hand [m]", points = 10,
    description = "Defeat Ansem on Floor B1 without stocking cards.",
    trigger = WasAnsemDefeatedOnFloorB1(TRUE) && never(numberOfStockedCardsForPlayer() > 0)
)

leaderboard(title = "Time Attack - Parasite Cage (Sora's Story)",
    description = "Defeat the Parasite Cage in Sora's story as quickly as you can.",
    start = BossHPValueCheckpointIsSet(parasiteCageHp(), parasiteCageHpMap, "Monstro", 0x4) && never(!IsInBattle()),
    cancel = !IsInBattle(),
    submit = EnemyWithSpecificAddressWasJustDefeated(parasiteCageHp(), FALSE),
    value = measured(FrameHasAdvanced() && !IsPaused())
)

leaderboard(title = "The Floor Is Poison, Best Times",
    description = "Defeat the Parasite Cage in Reverse/Rebirth while touching the ground for as little time as possible.",
	start = EnteredBattleWithParasiteCageInReverseRebirth(),
	cancel = !IsInBattle(),
	submit = EnemyWithSpecificAddressWasJustDefeated(parasiteCageReverseRebirthHp(), FALSE),
	value = measured(IsOnGroundDuringParasiteCageFight() && unless(IsPaused()))
)
