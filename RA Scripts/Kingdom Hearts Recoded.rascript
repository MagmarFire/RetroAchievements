// Kingdom Hearts Re:coded
// #ID = 14828

function Delta(addr) => prev(addr)

function GenerateConditionFromBitflag(bit) => { "countsWhen": (bit == 1), "recalculateWhen": (Delta(bit) != bit) }

// Game status(?) (Changes depending on game state and appears to have a detrimental effect when frozen)
//
// 0x0 = various; also seems to be a value this address flickers to when transitioning between some game states
// 0x3 = on the Title Screen
// 0x7 = text cutscene
// 0xc = Menu
// 0xf = in the field
function status() => word(0x056f50)

function worldId() => byte(0x19836c)
function areaId() => byte(0x19836d)

systemSectorAddr = 0x19ecf4
function IsInSystemSector() => dword(systemSectorAddr) != 0x0 && byte(systemSectorAddr + 3) == 0x2
function KeyholeCheckpointPassed() => minigamePopupState() == 0x3

function TitleScreenAlmostReady() => titleScreenStatus() == 5

function TitleScreenReady() => titleScreenStatus() == 6

function IsWatchingOpeningMovie() => titleScreenStatus() == 0xc

function IsOnTheatreMenu() => titleScreenStatus() == 0xa

function IsOnTitleScreen() => TitleScreenAlmostReady() || TitleScreenReady() || IsWatchingOpeningMovie() || IsOnTheatreMenu()

function SecondsToFormat(value)
{
    leadingZero = ""
    if (value % 60 < 10)
    {
        leadingZero = "0"
    }
    return value / 60 + ":" + leadingZero + value % 60
}

worlds = {
    0: "Destiny Islands",
    1: "Traverse Town",
    2: "Wonderland",
    3: "Olympus Coliseum",
    4: "Agrabah",
    5: "Hollow Bastion",
    6: "Hollow Bastion",
    7: "Castle Oblivion"
}

areas = {
0: { "worldId": 0x0, "name": "Null", "display": "Somewhere in the datascape...", "areaId": 0x0, },
1: { "worldId": 0x0, "name": "SoA1", "display": "Station of Awakening", "areaId": 0x1, },
2: { "worldId": 0x0, "name": "SoA2", "display": "Station of Awakening", "areaId": 0x2, },
3: { "worldId": 0x0, "name": "Destiny", "display": "Destiny Islands", "areaId": 0x3, },
4: { "worldId": 0x0, "name": "DestinySecret", "display": "Secret Place", "areaId": 0x5, },
6: { "worldId": 0x0, "name": "DestinyStorm", "display": "Storm-tossed Island", "areaId": 0x4, },
7: { "worldId": 0x1, "name": "TraverseFirst", "display": "First District", "areaId": 0x1, },
8: { "worldId": 0x1, "name": "TraverseSecond", "display": "Second District", "areaId": 0x2, },
9: { "worldId": 0x1, "name": "TraverseAlley", "display": "Alleyway", "areaId": 0x4, },
10: { "worldId": 0x1, "name": "TraverseKeyholeSecond", "display": "Keyhole / Second District", "areaId": 0x6, },
11: { "worldId": 0x1, "name": "TraverseKeyholeThird", "display": "Keyhole / Third District", "areaId": 0x7, },
12: { "worldId": 0x1, "name": "TraverseSector2F3", "display": "Traverse Town System Sector 2, Floor 3", "areaId": 0xd, },
13: { "worldId": 0x1, "name": "TraverseThird", "display": "Third District", "areaId": 0x3, },
14: { "worldId": 0x1, "name": "TraverseSecondCorrupted", "display": "Second District", "areaId": 0xa, },
15: { "worldId": 0x1, "name": "TraverseKeyholeFirst", "display": "Keyhole / First District", "areaId": 0x5, },
16: { "worldId": 0x1, "name": "TraverseKeyholeFall", "display": "Keyhole / Terminus", "areaId": 0x8, },
17: { "worldId": 0x1, "name": "TraverseKeyholeTerminus", "display": "Keyhole / Terminus", "areaId": 0x9, },
18: { "worldId": 0x2, "name": "WonderlandClearing", "display": "Clearing", "areaId": 0x6, },
19: { "worldId": 0x2, "name": "WonderlandRoseGarden", "display": "Rose Garden", "areaId": 0x9, },
20: { "worldId": 0x2, "name": "WonderlandLotus", "display": "Lotus Forest", "areaId": 0x8, },
21: { "worldId": 0x2, "name": "WonderlandAimless", "display": "Aimless Path", "areaId": 0x5, },
22: { "worldId": 0x2, "name": "WonderlandMaze", "display": "Hedge Maze", "areaId": 0x4, },
23: { "worldId": 0x2, "name": "WonderlandBizarreSmall", "display": "Bizarre Room", "areaId": 0x7, },
24: { "worldId": 0x2, "name": "WonderlandBizarreBig", "display": "Bizarre Room", "areaId": 0x1, },
25: { "worldId": 0x2, "name": "WonderlandTea", "display": "Tea Party Garden", "areaId": 0x3, },
26: { "worldId": 0x2, "name": "WonderlandQueen", "display": "The Queen’s Castle", "areaId": 0x2, },
27: { "worldId": 0x2, "name": "WonderlandKeyholeFirst", "display": "Keyhole / The Falsewood", "areaId": 0xa, },
28: { "worldId": 0x2, "name": "WonderlandKeyholeSecond", "display": "Keyhole / Fleeting Forest", "areaId": 0xb, },
29: { "worldId": 0x2, "name": "WonderlandKeyholeTerminus", "display": "Keyhole / Terminus", "areaId": 0xc, },
30: { "worldId": 0x3, "name": "OlympusOutside", "display": "Outside the Coliseum", "areaId": 0x1d, },
31: { "worldId": 0x3, "name": "OlympusVestibule", "display": "Vestibule", "areaId": 0x1e, },
32: { "worldId": 0x3, "name": "OlympusLayer1", "display": "Layer 1", "areaId": 0x1, },
33: { "worldId": 0x3, "name": "OlympusSave", "display": "Save Room", "areaId": 0x1f, },
34: { "worldId": 0x3, "name": "OlympusLayer2", "display": "Layer 2", "areaId": 0x2, },
35: { "worldId": 0x3, "name": "OlympusLayer3", "display": "Layer 3", "areaId": 0x3, },
36: { "worldId": 0x3, "name": "OlympusLayer4", "display": "Layer 4", "areaId": 0x4, },
37: { "worldId": 0x3, "name": "OlympusLayer5", "display": "Layer 5", "areaId": 0x5, },
38: { "worldId": 0x3, "name": "OlympusLayer6", "display": "Layer 6", "areaId": 0x6, },
39: { "worldId": 0x3, "name": "OlympusLayer7", "display": "Layer 7", "areaId": 0x7, },
40: { "worldId": 0x3, "name": "OlympusLayer8", "display": "Layer 8", "areaId": 0x8, },
41: { "worldId": 0x3, "name": "OlympusLayer9", "display": "Layer 9", "areaId": 0x9, },
42: { "worldId": 0x3, "name": "OlympusLayer10", "display": "Layer 10", "areaId": 0xa, },
43: { "worldId": 0x3, "name": "OlympusLayer11", "display": "Layer 11", "areaId": 0xb, },
44: { "worldId": 0x3, "name": "OlympusLayer12", "display": "Layer 12", "areaId": 0xc, },
45: { "worldId": 0x3, "name": "OlympusLayer13", "display": "Layer 13", "areaId": 0xd, },
46: { "worldId": 0x3, "name": "OlympusLayer14", "display": "Layer 14", "areaId": 0xe, },
47: { "worldId": 0x3, "name": "OlympusLayer15", "display": "Layer 15", "areaId": 0x21, },
48: { "worldId": 0x4, "name": "AgrabahPlaza", "display": "Plaza", "areaId": 0x6, },
49: { "worldId": 0x4, "name": "AgrabahAlley", "display": "Alley", "areaId": 0x8, },
50: { "worldId": 0x4, "name": "AgrabahStreet", "display": "Main Street", "areaId": 0x2, },
51: { "worldId": 0x4, "name": "AgrabahPalace", "display": "Palace Gates", "areaId": 0x3, },
52: { "worldId": 0x4, "name": "AgrabahPlazaFrozen", "display": "Plaza", "areaId": 0xa, },
53: { "worldId": 0x4, "name": "AgrabahPalaceFrozen", "display": "Palace Gates", "areaId": 0xc, },
54: { "worldId": 0x4, "name": "AgrabahStreetFrozen", "display": "Main Street", "areaId": 0xb, },
55: { "worldId": 0x4, "name": "AgrabahAlleyFrozen", "display": "Alley", "areaId": 0xd, },
56: { "worldId": 0x4, "name": "AgrabahCaveEntranceNoEntry", "display": "Cave / Entrance", "areaId": 0x12, },
57: { "worldId": 0x4, "name": "AgrabahBazaarFrozen", "display": "Bazaar", "areaId": 0xe, },
58: { "worldId": 0x4, "name": "AgrabahBazaar", "display": "Bazaar", "areaId": 0x9, },
59: { "worldId": 0x4, "name": "AgrabahCaveEntrance", "display": "Cave / Entrance", "areaId": 0x1, },
60: { "worldId": 0x4, "name": "AgrabahCaveBeginnings", "display": "Cave / Hall of Beginnings", "areaId": 0x4, },
61: { "worldId": 0x4, "name": "AgrabahGauntlet", "display": "Cave / Gauntlet", "areaId": 0x5, },
62: { "worldId": 0x4, "name": "AgrabahGauntletLower", "display": "Cave / Gauntlet", "areaId": 0x11, },
63: { "worldId": 0x4, "name": "AgrabahLamp", "display": "Cave / Lamp Chamber", "areaId": 0x7, },
64: { "worldId": 0x4, "name": "AgrabahKeyholeTerminus", "display": "Keyhole / Terminus", "areaId": 0xf, },
65: { "worldId": 0x5, "name": "HollowBastionGates", "display": "Castle Gates", "areaId": 0x2, },
66: { "worldId": 0x5, "name": "HollowBastionWaterway", "display": "Waterway", "areaId": 0x3, },
67: { "worldId": 0x5, "name": "HollowBastionEntranceLower", "display": "Entrance Hall (Lower Level)", "areaId": 0x4, },
68: { "worldId": 0x5, "name": "HollowBastionLibrary1", "display": "Library 1", "areaId": 0x6, },
69: { "worldId": 0x5, "name": "HollowBastionLibrary3", "display": "Library 3", "areaId": 0x8, },
70: { "worldId": 0x5, "name": "HollowBastionLibrary4", "display": "Library 4", "areaId": 0x9, },
71: { "worldId": 0x5, "name": "HollowBastionLibrary2", "display": "Library 2", "areaId": 0x7, },
72: { "worldId": 0x5, "name": "HollowBastionEntranceUpper", "display": "Entrance Hall (Upper Level)", "areaId": 0x5, },
73: { "worldId": 0x5, "name": "HollowBastionCrest", "display": "Great Crest", "areaId": 0xa, },
74: { "worldId": 0x5, "name": "HollowBastionTower", "display": "High Tower", "areaId": 0xb, },
75: { "worldId": 0x5, "name": "HollowBastionGrandHall", "display": "Grand Hall", "areaId": 0xd, },
76: { "worldId": 0x5, "name": "HollowBastionKeyholeEntrance", "display": "Somewhere in the datascape…", "areaId": 0x0, },
77: { "worldId": 0x5, "name": "HollowBastionKeyholeChapel", "display": "Keyhole / Chapel", "areaId": 0xc, },
78: { "worldId": 0x6, "name": "HollowBastionIIInsideRiku", "display": "Inside Riku’s Data", "areaId": 0x8, },
79: { "worldId": 0x4, "name": "AgrabahCaveGauntletLower2", "display": "Cave / Gauntlet", "areaId": 0x10, },
80: { "worldId": 0x6, "name": "HollowBastionDestinyIslands", "display": "Destiny Islands", "areaId": 0x9, },
81: { "worldId": 0x6, "name": "HollowBastionFirstDistrict", "display": "First District", "areaId": 0xa, },
82: { "worldId": 0x6, "name": "HollowBastionSecondDistrict", "display": "Second District", "areaId": 0xb, },
83: { "worldId": 0x6, "name": "HollowBastionClearing", "display": "Clearing", "areaId": 0x4, },
84: { "worldId": 0x6, "name": "HollowBastionLotusForest", "display": "Lotus Forest", "areaId": 0x5, },
85: { "worldId": 0x6, "name": "HollowBastionCaveBeginnings", "display": "Cave / Hall of Beginnings", "areaId": 0x7, },
86: { "worldId": 0x6, "name": "HollowBastionCaveEntrance", "display": "Cave / Entrance", "areaId": 0x6, },
87: { "worldId": 0x6, "name": "HollowBastionChapelRiku", "display": "Chapel", "areaId": 0x3, },
88: { "worldId": 0x6, "name": "HollowBastionEscapeRiku", "display": "Inside Riku’s Data", "areaId": 0xc, },
89: { "worldId": 0x6, "name": "HollowBastionDragon", "display": "Chapel (Dragon’s Lair)", "areaId": 0x2, },
90: { "worldId": 0x6, "name": "HollowBastionGrandHall2", "display": "Grand Hall", "areaId": 0xe, },
91: { "worldId": 0x6, "name": "HollowBastionDataTunnel", "display": "Data Tunnel", "areaId": 0xd, },
92: { "worldId": 0x6, "name": "HollowBastionCentralCorruption", "display": "Central Corruption", "areaId": 0x1, },
93: { "worldId": 0x7, "name": "CastleOblivionHall", "display": "Entrance Hall", "areaId": 0x7, },
94: { "worldId": 0x7, "name": "CastleOblivionSomewhere", "display": "Somewhere in the datascape…", "areaId": 0x1, },
95: { "worldId": 0x7, "name": "CastleOblivionSomewhere2", "display": "Somewhere in the datascape…", "areaId": 0xa, },
96: { "worldId": 0x7, "name": "CastleOblivionDestinyIslands", "display": "Destiny Islands", "areaId": 0x9, },
97: { "worldId": 0x7, "name": "CastleOblivionTraverseTown", "display": "Traverse Town", "areaId": 0x1, },
98: { "worldId": 0x7, "name": "CastleOblivionWonderland", "display": "Wonderland", "areaId": 0x2, },
99: { "worldId": 0x7, "name": "CastleOblivionOlympusColiseum", "display": "Olympus Coliseum", "areaId": 0x3, },
100: { "worldId": 0x7, "name": "CastleOblivionAgrabah", "display": "Agrabah", "areaId": 0x4, },
101: { "worldId": 0x7, "name": "CastleOblivionHollowBastionObstacleCourse", "display": "Hollow Bastion", "areaId": 0x6, },
102: { "worldId": 0x7, "name": "CastleOblivionSorrow", "display": "Station of Sorrow", "areaId": 0x8, },
103: { "worldId": 0x7, "name": "CastleOblivionHollowBastion", "display": "Hollow Bastion", "areaId": 0x5, },
104: { "worldId": 0x3, "name": "OlympusLayer16", "display": "Layer 16", "areaId": 0xf, },
105: { "worldId": 0x3, "name": "OlympusLayer17", "display": "Layer 17", "areaId": 0x10, },
106: { "worldId": 0x3, "name": "OlympusLayer18", "display": "Layer 18", "areaId": 0x11, },
107: { "worldId": 0x3, "name": "OlympusSave2", "display": "Save Room", "areaId": 0x20, },
108: { "worldId": 0x3, "name": "OlympusLayer19", "display": "Layer 19", "areaId": 0x12, },
109: { "worldId": 0x3, "name": "OlympusLayer20", "display": "Layer 20", "areaId": 0x13, },
110: { "worldId": 0x3, "name": "OlympusLayer21", "display": "Layer 21", "areaId": 0x14, },
111: { "worldId": 0x3, "name": "OlympusLayer22", "display": "Layer 22", "areaId": 0x15, },
112: { "worldId": 0x3, "name": "OlympusLayer23", "display": "Layer 23", "areaId": 0x16, },
113: { "worldId": 0x3, "name": "OlympusLayer24", "display": "Layer 24", "areaId": 0x17, },
114: { "worldId": 0x3, "name": "OlympusLayer25", "display": "Layer 25", "areaId": 0x18, },
115: { "worldId": 0x3, "name": "OlympusLayer26", "display": "Layer 26", "areaId": 0x19, },
116: { "worldId": 0x3, "name": "OlympusLayer27", "display": "Layer 27", "areaId": 0x1a, },
117: { "worldId": 0x3, "name": "OlympusLayer28", "display": "Layer 28", "areaId": 0x1b, },
118: { "worldId": 0x3, "name": "OlympusLayer29", "display": "Layer 29", "areaId": 0x1c, },
119: { "worldId": 0x3, "name": "OlympusLayer30", "display": "Layer 30", "areaId": 0x22, },

}

function GetLocationByName(name)
{
    for i in areas
    {
        area = areas[i]
        if (area["name"] == name)
        {
            return area
        }
    }
}

function GetWorldIdByName(name)
{
    for i in worlds
    {
        world = worlds[i]
        if (world == name)
        {
            return i
        }
    }
}

function IsInLocation(name)
{
    area = GetLocationByName(name)
    return areaId() == area["areaId"] && worldId() == area["worldId"]
}

function IsInWorld(name)
{
    world = GetWorldIdByName(name)
    return worldId() == world
}

function WasInLocation(name)
{
    area = GetLocationByName(name)
    return Delta(areaId()) == area["areaId"] && Delta(worldId()) == area["worldId"]
}

function GetAreaRPLookup(worldId)
{
    ret = {}
    for id in areas
    {
        area = areas[id]
        if (area["worldId"] == worldId)
        {
            ret[area["areaId"]] = area["display"]
        }
    }
    return ret
}

function baseScore() => dword(0x19eda0)
function bossScorePointerBaseAddr() => 0x0c0880
function bossScorePointer() => tbyte(bossScorePointerBaseAddr())
function IsBossScorePointerActive() => dword(bossScorePointerBaseAddr() + 4) == 0x0 && bossScorePointerBaseAddr() != 0
function bossScoreDisplayStatusPointer() => bossScorePointer() + 0x10
function IsBossRankJustDisplayed() => Delta(byte(bossScoreDisplayStatusPointer())) == 0xa && byte(bossScoreDisplayStatusPointer()) == 0x7

// We have a hit target here because the status value cycles through numbers a couple times.
function IsTotalScoreJustDisplayed() => once(byte(bossScoreDisplayStatusPointer()) == 1) && Delta(byte(bossScoreDisplayStatusPointer())) == 0xa && byte(bossScoreDisplayStatusPointer()) == 0x7
    && never(!IsBossScorePointerActive())
    
function IsTotalScoreJustDisplayedForAchievement() => once(byte(bossScoreDisplayStatusPointer()) == 1) && Delta(byte(bossScoreDisplayStatusPointer())) == 0xa
    && byte(bossScoreDisplayStatusPointer()) == 0x7
    && IsBossScorePointerActive()

function BossScoreIsDisplayedAndAtLeast(threshold)
{
    return IsBossScorePointerActive() && dword(bossScorePointer() + 8) >= threshold && IsBossRankJustDisplayed()
}

function BossTimeIsDisplayedAndAtMost(milliseconds)
{
    return IsBossScorePointerActive() && bossMilliseconds() <= milliseconds && IsBossRankJustDisplayed()
}

// Title screen status
// 
// 0 = Licensed by Nintendo
// 1 = Square Enix
// 2 = h.a.n.d.
// 3 = lawyer stuff lol
// 4 = Kingdom Hearts animation
// 5 = Title Screen almost ready
// 6 = Title Screen ready
// 8 = Load Menu
function titleScreenStatus() => dword(0x19c494)

function sessionPlayTime() => dword(0x056e9c)
function savedPlayTime() => dword(0x198360)
function PlayTimeToFrames()
{
    return sessionPlayTime() * 215543160 / 28704724 + savedPlayTime() * 60
}

soa1 = GetLocationByName("SoA1")
soa2 = GetLocationByName("SoA2")
rich_presence_conditional_display(IsOnTitleScreen(), "On the title screen")

rich_presence_conditional_display(worldId() == 0 && areaId() == 0x1, soa1["display"] + " | Play Time: {0}",
    rich_presence_value("PlayTime", PlayTimeToFrames(), "FRAMES")
)

rich_presence_conditional_display(worldId() == 0 && areaId() == 0x2, soa2["display"] + " | Play Time: {0}",
    rich_presence_value("PlayTime", PlayTimeToFrames(), "FRAMES")
)

for world in worlds
{
    rich_presence_conditional_display(IsInSystemSector() && worldId() == world, worlds[world] + ": System Sector | Play Time: {0}",
        rich_presence_value("PlayTime", PlayTimeToFrames(), "FRAMES")
    )
    rich_presence_conditional_display(worldId() == world, worlds[world] + ": {0} | Play Time: {1}",
        rich_presence_lookup("Areas" + world, areaId(), GetAreaRPLookup(world)),
        rich_presence_value("PlayTime", PlayTimeToFrames(), "FRAMES")
    )
}

rich_presence_display("Somewhere in the datascape...")

function IsPointer(addr) => byte(addr + 3) == 0x2
function WasPointer(addr) => prior(byte(addr + 3)) == 0x2

// Returns a new pointer address at the given half-address with a given negative offset.
// Intended to standardize usages of negative pointer offsets, since those are not supported with the current tools.
// ---
// halfPointer (16-bit): The value of a tbyte pointer, truncated to a 16-bit value.
// pointerMayBeAtLeast (int): The value that the pointer is expected to not be less than.
//                            It should generally be the pointer's original value minus its truncated value.
// negativeOffset (int): The negative offset to apply in order to get the ultimate, desired address.
function GetAddressWithNegativeOffset(halfPointer, pointerMayBeAtLeast, negativeOffset)
{
    return halfPointer + pointerMayBeAtLeast - negativeOffset
}

// $056130: Steps taken (?) (32-bit)

// $0569CC: System timer (32-bit)
//          
//          Increments by 1 every frame.
function systemTimer() => dword(0x0569CC)

// $056E9C: Total time played. Increments by 1 every seven or eight frames (alternates between the two) - 32-bit
//          
//          8 'ticks' ~= 1 second
function playTime() => dword(0x056E9C)

// $0604FC: Button input
//          Bit 0 - A
//          Bit 1 - B
//          Bit 2 - Select
//          Bit 3 - Start
//          Bit 4 - Right
//          Bit 5 - Left
//          Bit 6 - Up
//          Bit 7 - Down
// $0604FD: Button input
//          Bit 0 - R
//          Bit 1 - L
//          Bit 2 - X
//          Bit 3 - Y
// $0608D4: Ability set for clock level 2 - 16-bit
// $0608D6: Ability set for clock level 3 - 16-bit
// $0608D8: Ability set for clock level MAX - 16-bit

// $060B51: < LV PLAYER SORA >
function Level() => byte(0x060B51) + 1

// $060B52: < HP PLAYER - SORA >
function hp() => byte(0x060B52)

// $060B54: Sora's max HP - 16-bit
function maxHP() => word(0x060B54)

// $060B56: < STRENGTH STATS - SORA >
function strength() => byte(0x060B56)

// $060B58: < MAGIC  STATS - SORA >
function magic() => byte(0x060B58)

// $060B5A: < DEFENSE STATS - SORA >
function defense() => byte(0x060B5A)

// $060B5C: Sora's Luck - 16-bit
function luck() => word(0x060B5C)

// 0x0a04cc: Pointer to minigame state (32-bit)
//           Offset 0x10c to get minigame state (8-bit)
//           0x1 = "Get Ready!" sliding in
//           0x2 = "Get Ready!" about stopped
//           0x3 = "Get Ready!" sliding out
minigameStatePointerBaseAddr = 0xa04cc
popupOffset = 0x10c
minigameActiveOffset = 0xf0

function minigameStatePointer() => tbyte(minigameStatePointerBaseAddr)
function minigameStateHalfPointer() => word(minigameStatePointerBaseAddr)
function minigamePopupState() => byte(minigameStatePointer() + popupOffset)
function IsMinigameActive() => byte(minigameStatePointer() + minigameActiveOffset) == 1

// $060B6E: Level of current Keyblade?
// $0A04A8: Pointer for the clock gauge
//          {Offset 0x0474} - Clock gauge level
//          - 0x00 - Level 1
//          - 0x01 - Level 2
//          - 0x02 - Level 3
//          - 0x03 - MAX
//          {Offset 0x0476} - Clock gauge meter - 16-bit
//          - 0x0000 through 0x03e8 (1,000) - Level 1
//          - 0x03e8 through 0x0f3c (3,900) - Level 2
//          - 0x0f3c through 0x1b58 (7,000) - Level 3
//          - 0x1b58 through 0x283c (10,300) - MAX
// $0A04B4: Pointer for commands
//          {Offset 0xec} - Index of currently selected command
//          {Offset 0xf0} - Index of last selected command
// $0BEEA8: Start of the rewards items' data for the system sector on Destiny Islands
//          
//          Type of item 1 at the end of the system sector on Destiny Islands - 16-bit
// $0BEEAA: Level of item 1 at the end of the system sector on Destiny Islands
// $0BEEAC: Price of item 1 at the end of the system sector on Destiny Islands - 32-bit
// $0BEEB0: 0x01 - Makes item 1 at the end of the system sector on Destiny Islands purchasable only once
// $0BEEE4: End of the rewards items' data for the system sector on Destiny Islands
// $0BEFA4: Start of the rewards items' data for the system sector in Traverse Town: Second District
// $0BEFE0: End of the rewards items' data for the system sector in Traverse Town: Second District
// $0D18E0: Pointer for cursor coordinates in the Stat Matrix
//          {Offset 0x28} - x position of cursor in the Stat Matrix - 16-bit
//          {Offset 0x2a} - y position of cursor in the Stat Matrix - 16-bit
// $195B3B: Rare prize blox flags
//          Bit 5 - Destiny Islands - Blank Chip
//          Bit 7 - Destiny Islands - HP +2 chip
// $195B4B: Bit 6 - Found the first backdoor on Destiny Islands
// $195B68: Start of defeated enemies in Enemy Profiles. Each enemy's count is represented by a 17-bit (WTF, Square?) value, which means each enemy shares a byte with another.
//          
//          Bit 0 - Darkside - 4
//          Bit 1 - Darkside - 8
//          Bit 2 - Darkside - 16
//          Bit 3 - Darkside - 32
//          Bit 4 - Darkside - 64
//          Bit 5 - Darkside - 128
//          Bit 6 - Darkside - 256
//          Bit 7 - Darkside - 512
// $195B69: Bit 0 - Darkside - 1,024
//          Bit 1 - Darkside - 2,048
//          Bit 2 - Darkside - 4,096
//          Bit 3 - Darkside - 8,192
//          Bit 4 - Darkside - 16,384
//          Bit 5 - Darkside - 32,768
//          Bit 6 - Darkside - 65,536
//          Bit 7 - Shadow - 1
// $195B6A: Bit 0 - Shadow - 2
//          Bit 1 - Shadow - 4
//          Bit 2 - Shadow - 8
//          Bit 3 - Shadow - 16
//          Bit 4 - Shadow - 32
//          Bit 5 - Shadow - 64
//          Bit 6 - Shadow - 128
//          Bit 7 - Shadow - 256
// $195B6B: Bit 0 - Shadow - 512
//          Bit 1 - Shadow - 1,024
//          Bit 2 - Shadow - 2,048
//          Bit 3 - Shadow - 4,096
//          Bit 4 - Shadow - 8,192
//          Bit 5 - Shadow - 16,384
//          Bit 6 - Shadow - 32,768
//          Bit 7 - Shadow - 65,536
// $195B6C: Bit 0 - Soldier - 16
//          Bit 1 - Soldier - 32
//          Bit 2 - Soldier - 64
//          Bit 3 - Soldier - 128
//          Bit 4 - Soldier - 256
//          Bit 5 - Soldier - 512
//          Bit 6 - Soldier - 1,024
//          Bit 7 - Soldier - 2,048
// $195B6D: Bit 0 - Soldier - 4,096
//          Bit 1 - Soldier - 8,192
//          Bit 2 - Soldier - 16,384
//          Bit 3 - Soldier - 32,768
//          Bit 4 - Soldier - 65,536
//          Bit 5 - Tidus - 1
//          Bit 6 - Tidus - 2
//          Bit 7 - Tidus - 4
// $195B6E: Bit 0 - Tidus - 8
//          Bit 1 - Tidus - 16
//          Bit 2 - Tidus - 32
//          Bit 3 - Tidus - 64
//          Bit 4 - Tidus - 128
//          Bit 5 - Tidus - 256
//          Bit 6 - Tidus - 512
//          Bit 7 - Tidus - 1,024
// $195B6F: Bit 0 - Tidus - 2,048
//          Bit 1 - Tidus - 4,096
//          Bit 2 - Tidus - 8,192
//          Bit 3 - Tidus - 16,384
//          Bit 4 - Tidus - 32,768
//          Bit 5 - Tidus - 65,536
//          Bit 6 - Darkside - 1
//          Bit 7 - Darkside - 2
// $195B70: Bit 0 - Red Nocturne - 64
//          Bit 1 - Red Nocturne - 128
//          Bit 2 - Red Nocturne - 256
//          Bit 3 - Red Nocturne - 512
//          Bit 4 - Red Nocturne - 1,024
//          Bit 5 - Red Nocturne - 2,048
//          Bit 6 - Red Nocturne - 4,096
//          Bit 7 - Red Nocturne - 8,192
// $195B71: Bit 0 - Red Nocturne - 16,384
//          Bit 1 - Red Nocturne - 32,768
//          Bit 2 - Red Nocturne - 65,536
//          Bit 3 - Large Body - 1
//          Bit 4 - Large Body - 2
//          Bit 5 - Large Body - 4
//          Bit 6 - Large Body - 8
//          Bit 7 - Large Body - 16
// $195B72: Bit 0 - Large Body - 32
//          Bit 1 - Large Body - 64
//          Bit 2 - Large Body - 128
//          Bit 3 - Large Body - 256
//          Bit 4 - Large Body - 512
//          Bit 5 - Large Body - 1,024
//          Bit 6 - Large Body - 2,048
//          Bit 7 - Large Body - 4,096
// $195B73: Bit 0 - Large Body - 8,192
//          Bit 1 - Large Body - 16,384
//          Bit 2 - Large Body - 32,768
//          Bit 3 - Large Body - 65,536
//          Bit 4 - Soldier - 1
//          Bit 5 - Soldier - 2
//          Bit 6 - Soldier - 4
//          Bit 7 - Soldier - 8
// $195B74: Bit 0 - Yellow Opera - 256
//          Bit 1 - Yellow Opera - 512
//          Bit 2 - Yellow Opera - 1,024
//          Bit 3 - Yellow Opera - 2,048
//          Bit 4 - Yellow Opera - 4,096
//          Bit 5 - Yellow Opera - 8,192
//          Bit 6 - Yellow Opera - 16,384
//          Bit 7 - Yellow Opera - 32,768
// $195B75: Bit 0 - Yellow Opera - 65,536
//          Bit 1 - Guard Armor - 1
//          Bit 2 - Guard Armor - 2
//          Bit 3 - Guard Armor - 4
//          Bit 4 - Guard Armor - 8
//          Bit 5 - Guard Armor - 16
//          Bit 6 - Guard Armor - 32
//          Bit 7 - Guard Armor - 64
// $195B76: Bit 0 - Guard Armor - 128
//          Bit 1 - Guard Armor - 256
//          Bit 2 - Guard Armor - 512
//          Bit 3 - Guard Armor - 1,024
//          Bit 4 - Guard Armor - 2,048
//          Bit 5 - Guard Armor - 4,096
//          Bit 6 - Guard Armor - 8,192
//          Bit 7 - Guard Armor - 16,384
// $195B77: Bit 0 - Guard Armor - 32,768
//          Bit 1 - Guard Armor - 65,536
//          Bit 2 - Red Nocturne - 1
//          Bit 3 - Red Nocturne - 2
//          Bit 4 - Red Nocturne - 4
//          Bit 5 - Red Nocturne - 8
//          Bit 6 - Red Nocturne - 16
//          Bit 7 - Red Nocturne - 32
// $195BDE: Bits 5-7: Worlds completed with 1 HP
// $195BDF: Bits 0-4: Worlds completed with 1 HP cheat
//          Bits 5-7: Worlds completed on Critical
// $195BF8: Bit 0 - Magic casts - 64
//          Bit 1 - Magic casts - 128
//          Bit 2 - Magic casts - 256
//          Bit 3 - Magic casts - 512
//          Bit 4 - Magic casts - 1,024
//          Bit 5 - Magic casts - 2,048
//          Bit 6 - Magic casts - 4,096
//          Bit 7 - Magic casts - 8,192
// $195BF9: Bit 0 - Magic casts - 16,384
//          Bit 1 - Magic casts - 32,768
//          Bit 2 - Magic casts - 65,536
//          Bit 3 - Command conversions - 1
//          Bit 4 - Command conversions - 2
//          Bit 5 - Command conversions - 4
//          Bit 6 - Command conversions - 8
//          Bit 7 - Command conversions - 16
// $195BFA: Bit 0 - Command conversions - 32
//          Bit 1 - Command conversions - 64
//          Bit 2 - Command conversions - 128
//          Bit 3 - Command conversions - 256
//          Bit 4 - Command conversions - 512
//          Bit 5 - Command conversions - 1,024
//          Bit 6 - Command conversions - 2,048
//          Bit 7 - Command conversions - 4,096
// $195BFB: Bit 0 - Command conversions - 8,192
//          Bit 1 - Command conversions - 16,384
//          Bit 2 - Command conversions - 32,768
//          Bit 3 - Command conversions - 65,536
//          Bit 4 - Blox destroyed - 1
//          Bit 5 - Blox destroyed - 2
//          Bit 6 - Blox destroyed - 4
//          Bit 7 - Blox destroyed - 8
// $195BFF: Bit 2 - Magic casts - 1
//          Bit 3 - Magic casts - 2
//          Bit 4 - Magic casts - 4
//          Bit 5 - Magic casts - 8
//          Bit 6 - Magic casts - 16
//          Bit 7 - Magic casts - 32
// $195C15: Amount of chips installed in the Stat Matrix?
// $195C78: Bit 0: Champion Collector trophy
//          Bit 1: Cheater trophy
//          Bit 2: Sultan of Slot trophy
//          Bit 3: Sector Sweeper trophy
//          Bit 4: Lord of Loot trophy
//          Bit 5: Rare Prize Roundup trophy
// $195C7D: Bit 0: W8 Speed Runner trophy
//          Bit 1: W7 Speed Runner trophy
//          Bit 2: W6 Speed Runner trophy
//          Bit 3: W5 Speed Runner trophy
//          Bit 4: W4 Speed Runner trophy
//          Bit 5: W3 Speed Runner trophy
//          Bit 6: W2 Speed Runner trophy
//          Bit 7: W1 Speed Runner trophy
// $195C7E: Bit 0: Technician trophy
//          Bit 1: Fatal Flawless trophy (?)
//          Bit 2: Critical Acclaim trophy
//          Bit 3: Proud Achievement trophy
//          Bit 4: Quest Bester trophy
//          Bit 5: Closed Book trophy
//          Bit 6: Command Master trophy
//          Bit 7: Converter CR LV 100 trophy
// $195C7F: Bit 0: Converter LV 100 trophy
//          Bit 1: Weapon Wizard trophy
//          Bit 2: Justice for All trophy
//          Bit 3: Twilight Triumph trophy
//          Bit 4: Eliminator's End trophy
//          Bit 5: Icer of Titans trophy
//          Bit 6: Avatar Sweeper trophy
//          Bit 7: Avatar Collector trophy
// $195C80: Bit 1 - Viewed Installing Chips tutorial in the Stat Matrix
//          Bit 2 - Viewed The Stat Matrix tutorial in the Stat Matrix
//          Bit 3 - Viewed The Debug Reports tutorial in the Debug Reports
//          Bit 4 - Viewed one of the tutorials on the field (it is not known which)
//          Bit 5 - Viewed one of the tutorials on the field (it is not known which)
//          Bit 6 - Viewed EXP (Experience) tutorial on the field
//          Bit 7 - Viewed Prizes tutorial on the field
// $195C81: Bit 1 - Viewed The Command Deck tutorial on the field
//          Bits 2 and 3 - Viewed The "Attack" Command and The HP Gauge tutorials on the field
//          Bit 4 - Viewed the message telling the player to examine the strange door in the Station of Awakening
//          Bit 6 - Viewed the Controls tutorial on the field
// $195C85: Bit 2 - Viewed Installing Commands tutorial in the Command Matrix
//          Bit 3 - Viewed The Command Matrix tutorial in the Command Matrix
//          Bit 5 - Viewed Auto-Jump tutorial on the field
//          Bit 6 - Viewed The Map tutorial on the field
//          Bit 7 - Viewed Save Points tutorial on the field
// $195C86: Bit 6 - Viewed CPUs tutorial in the Stat Matrix
// $195C87: Bit 1 - Viewed Bonus Boosters tutorial in the Stat Matrix
//          Bit 6 - Viewed The Difficulty Cheat tutorial in the Stat Matrix
// $195C88: Bit 0 - Viewed The Clock Ability Tree tutorial on the field
//          Bit 1 - Viewed Overclocks tutorial on the field
//          Bit 5 - Viewed Accessory Chips tutorial in the Gear Matrix
//          Bit 6 - Viewed Finish Command Chips tutorial in the Gear Matrix
// $195C89: Bit 4 - Viewed Keyblade Chips tutorial in the Gear Matrix
//          Bit 5 - Viewed The Gear Matrix tutorial in the Gear Matrix
// $195C8A: Bit 0 - Viewed Locking On tutorial on the field
//          Bit 3 - Viewed SP (Sector Points) tutorial on the field
//          Bit 7 - Viewed Sector Debug tutorial on the field
// $195C8B: Bit 0 - Viewed System Sectors tutorial on the field
//          Bits 2 and 3 - Viewed Locating Backdoors tutorial on the field
//          Bit 4 - Viewed Stat Chips tutorial on the field
//          Bit 6 - Viewed the Blox Types or Rare Prize Blox tutorial on the field
//          Bit 7 - Viewed Blox tutorial on the field
// $195C8C: Bit 2 - Viewed Adjusting the Camera tutorial on the field
// $195C8E: Bit 7 - Viewed the Blox Types or Rare Prize Blox tutorial on the field
// $195C8F: Bit 1 - Viewed one of the tutorials on the field (it is not known which)
//          Bit 3 - Viewed Links tutorial on the field
//          Bit 4 - Viewed the second part of Finish Commands tutorial on the field
//          Bit 5 - Viewed the first part of Finish Commands tutorial on the field
// $195C97: Bit 0 - Viewed Choosing Abilities tutorial on the field
//          Bit 5 - Viewed Upgrading Keyblades tutorial on the field
// $195C98: Flags for the Tutorials menu
//          Bit 1 - Viewed Installing Chips
//          Bit 2 - Viewed The Stat Matrix
//          Bits 5 and 6 - Viewed EXP (Experience)
//          Bit 7 - Viewed Prizes
// $195C99: Flags for the Tutorials menu
//          Bit 1 - Viewed The Command Deck
//          Bit 2 - Viewed The HP Gauge
//          Bit 3 - Viewed The "Attack" Command
//          Bit 6 - Viewed Controls
// $195C9E: Flags for the Tutorials menu
//          Bit 6 - Viewed CPUs
// $195CA0: Flags for the Tutorials menu
//          Bit 1 - Viewed Overclocks
// $195CA2: Flags for the Tutorials menu
//          Bit 0 - Viewed Locking On
// $195CA4: Flags for the Tutorials menu
//          Bit 2 - Viewed Adjusting the Camera
// $195CA7: Flags for the Tutorials menu
//          Bits 4 and 5 - Viewed Finish Commands tutorial
// $195CB1: Story flags
//          Bit 3 - Entered the Secret Place on Destiny Islands
//          Bit 5 - Examined the strange door in the Station of Awakening that takes the player to Destiny Islands
//          Bit 6 - Viewed the cutscene where Sora finds out he can use the Keyblade
//          Bit 7 - Viewed the opening movies at the beginning of the game
// $195CC5: Bit 5 - Opened the Debug Reports for the first time
// $195CDF: Flags for Enemy Profiles in the Debug Reports
//          Bit 1 - Viewed Large Body
//          Bit 3 - Viewed Tidus
//          Bit 4 - Viewed Darkside
//          Bit 5 - Viewed Shadow
// $195CE4: Flags for Character Files in the Debug Reports
//          Bit 3 - Viewed Tidus
//          Bit 4 - Viewed Wakka
//          Bit 5 - Viewed Selphie
//          Bit 6 - Viewed ? ? ?
//          Bit 7 - Viewed Jiminy Cricket
// $195CE5: Flags for Character Files in the Debug Reports
//          Bit 0 - Viewed Dale
//          Bit 1 - Viewed Chip
//          Bit 2 - Viewed King Mickey
//          Bit 3 - Viewed Goofy
//          Bit 4 - Viewed Donald Duck
//          Bit 5 - Viewed Sora
// $195CE7: Flags for Story in the Debug Reports
//          Bit 5 - Viewed Destiny Islands
// $198310: Bits 1 and 2: Difficulty level (2-bit)
//          - 0x0 = Beginner Mode
//          - 0x1 = Standard Mode
//          - 0x2 = Proud Mode
//          - 0x3 = Critical Mode
//          Bit 5: Camera y-axis is inverted
//          Bit 6: Camera x-axis is inverted
//          Bits 3 and 4: Camera speed
//          - !3 and !4 = slow
//          - 3 and !4 = normal
//          - !3 and 4 = fast
function difficulty() => bit0(0x1986fa) + bit1(0x1986fa) + bit1(0x1986fa) // Can't multiply by 2 because reasons.

function IsOnBeginnerMode() => difficulty() == 0x0

function IsAtLeastOnDifficulty(value)
{
    if (value == "Beginner")
    {
        return IsOnBeginnerMode()
    }
    else if (value == "Standard")
    {
        return difficulty() >= 0x1
    }
    else if (value == "Proud")
    {
        return difficulty() >= 0x2
    }
    else if (value == "Critical")
    {
        return difficulty() >= 0x3
    }
}
// $198322: Flags for one-time items redeemed in system sectors
//          Bit 0 - Destiny Islands - Power Armlet
//          Bit 1 - Destiny Islands - Strength +1
//          Bit 2 - Destiny Islands - Magic +1
//          Bit 3 - Destiny Islands - Defense +1
//          Bit 4 - Destiny Islands - Blank Chip
// $198328: Flags for one-time items redeemed in system sectors
//          Bit 0 - Traverse Town: Second District - Fire Charm
//          Bit 1 - Traverse Town: Second District - HP +2
//          Bit 2 - Traverse Town: Second District - Magic +1
// $198364: EXP (32-bit)
// $198368: Munny (32-bit)
// $19836D: Music ID(?) (8-bit)
// $198370: Bit 0 - Chose the power of the warrior?
// $198371: Bit 0 - Gave up the power of the guardian?
// $198372: Bit 0 - Chose the power of the guardian?
// $198374: Bit 0 - Gave up the power of the mystic?
// $1983A7: Bit 0 - Chose the power of the mystic?
// $1983B6: Bit 0 - Gave up the power of the warrior?
// $198400: Amount of Level Up chips obtained
// $198401: Amount of Blank Chips obtained
// $198402: Amount of HP +2 chips obtained
// $198403: Amount of HP +4 chips obtained
// $198404: Amount of HP +6 chips obtained
// $198405: Amount of HP +8 chips obtained
// $198406: Amount of Strength +1 chips obtained
// $198407: Amount of Strength +2 chips obtained
// $198408: Amount of Strength +3 chips obtained
// $198409: Amount of Strength +4 chips obtained
// $19840A: Amount of Magic +1 chips obtained
// $19840B: Amount of Magic +2 chips obtained
// $19840C: Amount of Magic +3 chips obtained
// $19840D: Amount of Magic +4 chips obtained
// $19840E: Amount of Defense +1 chips obtained
// $19840F: Amount of Defense +2 chips obtained
// $198410: Amount of Defense +3 chips obtained
// $198411: Amount of Defense +4 chips obtained
// $198412: Amount of Lucky Strike chips obtained
// $1986F0: Active abilities
//          Bit 0 - Dodge Roll
//          Bit 1 - Scan
//          Bit 2 - Combo Plus
//          Bit 3 - Block
//          Bit 4 - High Jump
//          Bit 5 - Aerial Recovery
//          Bit 6 - Air Combo Plus
//          Bit 7 - Air Slide
// $1986F1: Active abilities
//          Bit 0 - Scan
//          Bit 1 - Haste
//          Bit 2 - Leaf Bracer
//          Bit 3 - Combo Plus
//          Bit 4 - Air Combo Plus
//          Bit 5 - Aerial Payback
//          Bit 6 - Dodge Roll
//          Bit 7 - Finishing Plus
// $1986F2: Active abilities
//          Bit 0 - Air Slide
//          Bit 1 - Air Slide
//          Bit 2 - Haste
//          Bit 3 - Scan
//          Bit 4 - Air Combo Plus
//          Bit 5 - Combo Plus
//          Bit 6 - Finishing Plus
//          Bit 7 - Glide
// $1986F3: Active abilities
//          Bit 0 - Scan
//          Bit 1 - Glide
//          Bit 2 - Combo Master
//          Bit 3 - Attack Haste
//          Bit 4 - Targeting Scope
//          Bit 5 - All Critical
//          Bit 6 - Full Swing
//          Bit 7 - Zantetsu Prime
// $1986FA: Difficulty
//          0x00 - Beginner
//          0x01 - Standard
//          0x02 - Proud
//          0x03 - Critical
// $1986FB: Sora's and enemies' HP modifier. 0x64 is 100 percent
// $198704: Bit 0 - The Difficulty Cheat is useable
// $1987B6: Start of chips in the Stat Matrix
//          0x00 - Level Up
//          0x01 - Blank Chip
//          0x02 - HP +2
//          0x03 - HP +4
//          0x04 - HP +6
//          0x05 - HP +8
//          0x06 - Strength +1
//          0x07 - Strength +2
//          0x08 - Strength +3
//          0x09 - Strength +4
//          0x0a - Magic +1
//          0x0b - Magic +2
//          0x0c - Magic +3
//          0x0d - Magic +4
//          0x0e - Defense +1
//          0x0f - Defense +2
//          0x10 - Defense +3
//          0x11 - Defense +4
//          0x12 - Lucky Strike
// $19884C: Current Keyblade. Values left out are higher level versions of the Keyblades - 16-bit
//          0x00d0 - Kingdom Key
//          0x00d5 - Wishing Star
//          0x00da - Lady Luck
//          0x00df - Olympia
//          0x00e4 - Three Wishes
//          0x00e9 - Oblivion
//          0x00ee - Zero/One
//          0x00f3 - Oathkeeper
//          0x00f8 - Metal Chocobo
//          0x00fd - Lionheart
//          0x0102 - Ultima Weapon
// $19884E: Current Finish command - 16-bit
//          0x0110 - Blade Rush
//          0x0111 - Energy Bomb
//          0x0112 - Faith
//          0x0113 - Mega Flare
//          0x0114 - Meteor Rain
//          0x0115 - Zone of Ruin
//          0x0116 - Speed Combo
//          0x0117 - Star Rave
//          0x0118 - Spinner Saw
//          0x0119 - D-Fira
//          0x011a - D-Blizzara
//          0x011b - D-Thundara
//          0x011c - D-Firaga
//          0x011d - D-Blizzaga
//          0x011e - D-Thundaga
// $198850: Accessory 1 - 16-bit
//          0x0120 - Armor Bangle
//          0x0121 - Counter Ring
//          0x0122 - Command Ring
//          0x0123 - Payback Ring
//          0x0124 - Energy Earring
//          0x0125 - Power Armlet
//          0x0126 - Wizard's Armlet
//          0x0127 - Safeguard Armlet
//          0x0128 - Half-moon Armlet
//          0x0129 - Strike Armlet
//          0x012a - CMOS Armlet
//          0x012b - CMOS Necklace
//          0x012c - Immortal Charm
//          0x012d - Eternity Charm
//          0x012e - Fire Charm
//          0x012f - Blizzard Charm
//          0x0130 - Thunder Charm
//          0x0131 - Heavy Chain
//          0x0132 - Zip Watch
//          0x0133 - Compass
//          0x0134 - Feather Chain
//          0x0135 - Night Lenses
//          0x0136 - Adamant Belt
//          0x0137 - Liberty Crown
//          0x0138 - Heat Sink Belt

function accessory1() => word(0x198850)
function accessory2() => word(0x198852)
function accessory3() => word(0x198854)
function accessory4() => word(0x198856)
function HasAccessoryEquipped(accessoryId)
{
    return accessory1() == accessoryId
        || accessory2() == accessoryId
        || accessory3() == accessoryId
        || accessory4() == accessoryId
}

// $198858: Amount of uses left of the command in slot 1 if it is an item
// $19885C: Amount of uses left of the command in slot 2 if it is an item
// $198860: Amount of uses left of the command in slot 3 if it is an item
// $198878: Keyblade EXP - 16-bit
// $198898: Controls various things about command 1 in the inventory. CP is 11-bit, starting at bit 5
// $19889A: Bit 0 - Command 1 in the inventory is useable
// $19889B: Type of command 1 in the inventory
//          0x00 - Quick Blitz
//          0x01 - Sliding Dash
//          0x02 - Round Blitz
//          0x03 - Strike Raid
//          0x04 - Rising Strike
//          0x05 - Sliding Rush
//          0x06 - Aerial Sweep
//          0x07 - Air Sweep
//          0x08 - Aerial Slam
//          0x09 - Land Crash
//          0x0a - Fire Edge
//          0x0b - Blizzard Edge
//          0x0c - Thunder Edge
//          0x0d - Aero Edge
//          0x0e - Heat Dash
//          0x0f - Ice Dash
//          0x10 - Spark Dash
//          0x11 - Wind Dash
//          0x12 - Fire Blast
//          0x13 - Blizzard Blast
//          0x14 - Thunder Blast
//          0x15 - Aero Blast
//          0x16 - Fire Raid
//          0x17 - Blizzard Raid
//          0x18 - Thunder Raid
//          0x19 - Aero Raid
//          0x1a - Fire Buster
//          0x1b - Blizzard Buster
//          0x1c - Thunder Buster
//          0x1d - Aero Buster
//          0x1e - Heat Sweep
//          0x1f - Ice Sweep
//          0x20 - Spark Sweep
//          0x21 - Wind Sweep
//          0x22 - Heat Storm
//          0x23 - Ice Storm
//          0x24 - Spark Storm
//          0x25 - Wind Storm
//          0x26 - Fire Slam
//          0x27 - Blizzard Slam
//          0x28 - Thunder Slam
//          0x29 - Aero Slam
//          0x2a - Heat Dive
//          0x2b - Ice Dive
//          0x2c - Spark Dive
//          0x2d - Wind Dive
//          0x2e - Stun Impact
//          0x2f - Muscle Strike
//          0x30 - Chain Rave
//          0x31 - Rising Rush
//          0x32 - Zantetsuken
//          0x33 - Eruption
//          0x34 - Gravity Drop
//          0x35 - Shock Fall
//          0x36 - Judgment Triad
//          0x37 - Fire
//          0x38 - Fira
//          0x39 - Firaga
//          0x3a - Blizzard
//          0x3b - Blizzara
//          0x3c - Blizzaga
//          0x3d - Thunder
//          0x3e - Thundara
//          0x3f - Thundaga
//          0x40 - Aero
//          0x41 - Aerora
//          0x42 - Aeroga
//          0x43 - Magnet
//          0x44 - Magnera
//          0x45 - Magnega
//          0x46 - Cure
//          0x47 - Cura
//          0x48 - Curaga
//          0x49 - Slow
//          0x4a - Stop
//          0x4b - Confuse
//          0x4c - Firaga Burst
//          0x4d - Triple Firaga
//          0x4e - Triple Burst
//          0x4f - Blizzaga Pursuit
//          0x50 - Triple Blizzaga
//          0x51 - Triple Pursuit
//          0x52 - Thunder Tracer
//          0x53 - Pulse Tracer
//          0x54 - Tornado Tracer
//          0x55 - Wind Tracer
//          0x56 - Magnet Grab
//          0x57 - Esuna
//          0x58 - Flame Fall
//          0x59 - Icicle Mine
//          0x5a - Exo Spark
//          0x5b - Cyclone
//          0x5c - Quake
// $19C513: Bits 1-7 - Amount of blox destroyed on Destiny Islands for Selphie
// $19C542: Temporary flags for Destiny Islands (only one flag is active at a time)?
//          Bit 6 - Triggered the cutscene where Wakka spots a rare prize blox
//          Bit 7 - Wakka asks Sora to find Tidus
// $19C543: Temporary flags for Destiny Islands (only one flag is active at a time)?
//          Bit 1 - Viewed the cutscene with Selphie when first arriving at Destiny Islands
//          Bit 2 - Selphie asks Sora to get rid of some blox
//          Bit 3 - Destroyed 20 blox for Selphie
// $19ED10: Area ID of some sort?
// $19EDA4: Sector Points. Does not update when redeeming them at the end of a system sector. Caps at 0x98967f (32-bit)
// $19EDA8: Amount of Sector Points acquired on the current floor of a system sector. Caps at 0x98967f - 32-bit
// $19EDAC: Amount of times the player has used action commands. Caps at 0x3e7 - 32-bit
//          
//          Resets under certain conditions.
// $19EDB0: Amount of times the player has used magic. Caps at 0x3e7 - 32-bit
//          
//          Resets under certain conditions.
// $19EDB4: Amount of times the player has used Cure magic or healing items. Caps at 0x3e7 - 32-bit
//          
//          Resets under certain conditions.
// $19EDB8: Amount of times the player has used a Finish command - 32-bit
//          
//          Resets under certain conditions.
// $19EDC0: Amount of critical hits Sora has landed. Caps at 0x3e7 - 32-bit
//          
//          Resets under certain conditions.
// $19EDC4: Amount of times the player has jumped. Caps at 0x3e7 - 32-bit
//          
//          Resets under certain conditions.
// $19EDC8: Amount of items the player has picked up from enemies or blox - 32-bit
//          
//          Resets under certain conditions.
// $19EDCC: Amount of times the player has taken damage. Caps at 0x3e7 - 32-bit
//          
//          Resets under certain conditions.
function timesPlayerWasHit() => dword(0x19EDCC)
function PlayerIsHit() => Delta(timesPlayerWasHit()) < timesPlayerWasHit()
// $19EDD0: Amount of times the player has used melee attacks. Caps at 0x3e7 - 32-bit
//          
//          Resets under certain conditions.
// $19EDD4: Amount of times the player has missed with melee attacks. Hitting walls and objects does not increment it. Caps at 0x3e7 - 32-bit
//          
//          Resets under certain conditions.
// $19EDD8: Amount of time the player has spent on the ground. Increments by 1 every other frame. Caps at 0xf423f - 32-bit
//          
//          Resets under certain conditions.
// $19EDDC: Amount of time the player has spent in the air. Increments by 1 every other frame. Caps at 0xf423f - 32-bit
//          
//          Resets under certain conditions.
// $19EDE4: Amount of enemies defeated while the clock level is at MAX. Caps at 0x1869f - 32-bit
//          
//          Resets under certain conditions.
// $19EDEC: Enemies defeated. Caps at 0x1869f - 32-bit
//          
//          Resets under certain conditions.
// $19EDF0: Amount of times the player has defeated enemies with Fire magic? Caps at 0x1869f - 32-bit
//          
//          Resets under certain conditions.
// $19EDFC: Amount of times the player has paralyzed enemies with Thunder magic?
//          
//          Resets under certain conditions.
// $19EE0C: Amount of bug baddies defeated. Caps at 0x1869f - 32-bit
//          
//          Resets under certain conditions.
// $19EE10: Amount of blox destroyed. Caps at 0x1869f - 32-bit
//          
//          Resets under certain conditions.
// $1A3AF8: Start of chips in the Stat Matrix
// $1A47B4: Pointer for the player's coordinates ouside of system sectors
//          {Offset 0xb8} - Player's x position - 32-bit
//          {Offset 0xbc} - Player's y position - 32-bit
//          {Offset 0xc0} - Player's z position - 32-bit
// $1A48B4: Pointer for the player's coordinates in system sectors
//          {Offset 0xb8} - Player's x position - 32-bit
//          {Offset 0xbc} - Player's y position - 32-bit
//          {Offset 0xc0} - Player's z position - 32-bit
// $1AB518: x position of one enemy - 32-bit
//          
//          Enemy data like this seems to be about 0x3c8 bytes long, as the same information for the next enemy is that far ahead of the last
// $1AB8E0: x position of one enemy - 32-bit
// $1ABCA8: x position of one enemy - 32-bit
// $1AC070: x position of one enemy - 32-bit
// $1AC438: x position of one enemy - 32-bit
// $1D86D4: Enemy 1's status?
//          0x01 - First loading in when Sora is near
//          0x02 - Appearing animation
//          0x03 - Normal combat behavior
//          0x05 - Taken damage
//          0x06 - Disappearing when Sora gets too far away
//          0x07 - Death animation
//          0x08 - Disappearing due to death
// $1D8744: Enemy 1's HP outside of system sectors - 32-bit
// $1D8874: Time until enemy 1 does an action outside of a system sector. Decrements by 0x1000 every two frames - 32-bit
// $1EFC88: Milliseconds elapsed during boss battle (32-bit)
function bossMilliseconds() => dword(0x1efc88)
// $225E48: Index of currently selected command
// $244058: Main menu - Option index
// $2EA17B: Health of one rare prize blox
// $2EB0FB: Health of one rare prize blox
// $3D8034: Scrolling x position for the map - 32-bit
// $3D8038: Scrolling y position for the map - 32-bit
// $3D8055: Player's icon's x position on the map (relative to the screen) - 16-bit
// $3D8059: Player's icon's y position on the map (relative to the screen) - 16-bit
// $3D805C: Bit 3 - Turns on the pointer arrow for the player's icon on the map
// $3DE2AC: Sector Points. Updates when finishing a floor or redeeming them at the end of a system sector - 32-bit
// $3DE2BC: Displayed amount of enemies defeated on the current system sector floor - 16-bit
// $3DE2BE: Display cap for the amount of bug baddies defeated on the current system sector floor - 16-bit

function IsInMenu() => status() == 0xc || status() == 0x0

// Menu ID (?) (16-bit)
// 
// 0xffff = transitioning/not in menu
// 0x0 = Main Menu
// 0x1 = Stat Matrix
// 0x2 = Command Matrix
// 0x3 = Gear Matrix
// 0x5 = Config
// 0x6 = Save/Load Menu
// 0xb = Debug Reports
// 0xc = Trophies
// 0xd = Collection
// 0xe = Story
// 0xf = Enemy Profiles
// 0x10 = Character Files
// 0x12 = Tutorials
function menuId() => word(0x0bea84)

function saveLoadPtrAddr() => 0x0c5e00
function saveLoadPtr() => tbyte(saveLoadPtrAddr())
function loadState() => byte(saveLoadPtr() + 4)
function OldSaveLoadState() => byte(prior(saveLoadPtr()) + 4)

// 0x9 means that it's transitioning to a loaded save file; it's what we're using to determine when a pauselock can activate.
function IsLoadingSaveFile() => !IsPointer(saveLoadPtrAddr()) && WasPointer(saveLoadPtrAddr()) && OldSaveLoadState() == 0x9

function IsOnSaveOrLoadMenu() => menuId() == 0x6

function IsOnLoadMenu() => titleScreenStatus() == 8

function IsAlwaysInGame() => unless(IsOnSaveOrLoadMenu()) && never(IsOnLoadMenu()) && never(IsOnTitleScreen())
    && unless(!IsPointer(saveLoadPtrAddr()) && WasPointer(saveLoadPtrAddr()) && Delta(OldSaveLoadState()) == 0x9)

function WasValueSet(mem, oldValue, newValue)
{
    return once(IsValueJustSet(mem, oldValue, newValue))
}

function IsValueJustSet(mem, oldValue, newValue)
{
    return Delta(mem) == oldValue && mem == newValue
}

function WasValueSetInGame(mem, oldValue, newValue)
{
    return IsAlwaysInGame() && WasValueSet(mem, oldValue, newValue)
}

function WasBitflagSetInGame(mem)
{
    return WasValueSetInGame(mem, 0, 1)
}

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
function GenerateSaveProtectedAchievementFromConditions(cheevo, conditions, onlyAvailableWhen)
{
    loadedCounts = []
    totalCounts = []
    resetAlt = always_false()

    for i in conditions
    {
        condition = conditions[i]
        
        // This is the score when the game is loaded. If the loaded score is greater than or equal to the threshold--that is,
        // if the save file would satisfy enough conditions to trigger the achievement on load--this should trigger a
        // permanant pauselock to serve as save protection.
        array_push(loadedCounts, once(condition["countsWhen"] && IsLoadingSaveFile()))
        
        // We want both loaded and session counts here (that is, we don't care if we're loading a save file when these are tallied).
        // This way, loading a save doesn't invalidate the achievement outright if a player hasn't actually earned it yet.
        array_push(totalCounts, once(condition["countsWhen"]))
        
        resetAlt = resetAlt || condition["recalculateWhen"]
    }

    achievement(title = cheevo["name"], description = cheevo["description"], points = cheevo["points"],
        trigger = !IsOnSaveOrLoadMenu() &&
            measured(tally(cheevo["threshold"], totalCounts)) && unless(tally(cheevo["threshold"], loadedCounts))
            && never(resetAlt) && onlyAvailableWhen && (always_false() || IsAlwaysInGame())
    )
}

enemies = {
0: { "name": "Shadow", "bits": { 1: { "addr": 0x00195B6A, "bit": 0 }, 2: { "addr": 0x00195B6A, "bit": 1 }, 3: { "addr": 0x00195B6A, "bit": 2 }, 4: { "addr": 0x00195B6A, "bit": 3 }, 5: { "addr": 0x00195B6A, "bit": 4 }, 6: { "addr": 0x00195B6A, "bit": 5 }, 7: { "addr": 0x00195B6A, "bit": 6 }, 8: { "addr": 0x00195B6A, "bit": 7 }, 9: { "addr": 0x00195B6B, "bit": 0 }, 10: { "addr": 0x00195B6B, "bit": 1 }, 11: { "addr": 0x00195B6B, "bit": 2 }, 12: { "addr": 0x00195B6B, "bit": 3 }, 13: { "addr": 0x00195B6B, "bit": 4 }, 14: { "addr": 0x00195B6B, "bit": 5 }, 15: { "addr": 0x00195B6B, "bit": 6 }, 16: { "addr": 0x00195B6B, "bit": 7 }, }, },
1: { "name": "Darkside", "bits": { 0: { "addr": 0x00195B6F, "bit": 6 }, 1: { "addr": 0x00195B6F, "bit": 7 }, 2: { "addr": 0x00195B68, "bit": 0 }, 3: { "addr": 0x00195B68, "bit": 1 }, 4: { "addr": 0x00195B68, "bit": 2 }, 5: { "addr": 0x00195B68, "bit": 3 }, 6: { "addr": 0x00195B68, "bit": 4 }, 7: { "addr": 0x00195B68, "bit": 5 }, 8: { "addr": 0x00195B68, "bit": 6 }, 9: { "addr": 0x00195B68, "bit": 7 }, 10: { "addr": 0x00195B69, "bit": 0 }, 11: { "addr": 0x00195B69, "bit": 1 }, 12: { "addr": 0x00195B69, "bit": 2 }, 13: { "addr": 0x00195B69, "bit": 3 }, 14: { "addr": 0x00195B69, "bit": 4 }, 15: { "addr": 0x00195B69, "bit": 5 }, 16: { "addr": 0x00195B69, "bit": 6 }, }, },
2: { "name": "Soldier", "bits": { 0: { "addr": 0x00195B73, "bit": 4 }, 1: { "addr": 0x00195B73, "bit": 5 }, 2: { "addr": 0x00195B73, "bit": 6 }, 3: { "addr": 0x00195B73, "bit": 7 }, 4: { "addr": 0x00195B6C, "bit": 0 }, 5: { "addr": 0x00195B6C, "bit": 1 }, 6: { "addr": 0x00195B6C, "bit": 2 }, 7: { "addr": 0x00195B6C, "bit": 3 }, 8: { "addr": 0x00195B6C, "bit": 4 }, 9: { "addr": 0x00195B6C, "bit": 5 }, 10: { "addr": 0x00195B6C, "bit": 6 }, 11: { "addr": 0x00195B6C, "bit": 7 }, 12: { "addr": 0x00195B6D, "bit": 0 }, 13: { "addr": 0x00195B6D, "bit": 1 }, 14: { "addr": 0x00195B6D, "bit": 2 }, 15: { "addr": 0x00195B6D, "bit": 3 }, 16: { "addr": 0x00195B6D, "bit": 4 }, }, },
3: { "name": "Tidus", "bits": { 0: { "addr": 0x00195B6D, "bit": 5 }, 1: { "addr": 0x00195B6D, "bit": 6 }, 2: { "addr": 0x00195B6D, "bit": 7 }, 3: { "addr": 0x00195B6E, "bit": 0 }, 4: { "addr": 0x00195B6E, "bit": 1 }, 5: { "addr": 0x00195B6E, "bit": 2 }, 6: { "addr": 0x00195B6E, "bit": 3 }, 7: { "addr": 0x00195B6E, "bit": 4 }, 8: { "addr": 0x00195B6E, "bit": 5 }, 9: { "addr": 0x00195B6E, "bit": 6 }, 10: { "addr": 0x00195B6E, "bit": 7 }, 11: { "addr": 0x00195B6F, "bit": 0 }, 12: { "addr": 0x00195B6F, "bit": 1 }, 13: { "addr": 0x00195B6F, "bit": 2 }, 14: { "addr": 0x00195B6F, "bit": 3 }, 15: { "addr": 0x00195B6F, "bit": 4 }, 16: { "addr": 0x00195B6F, "bit": 5 }, }, },
4: { "name": "Red Nocturne", "bits": { 0: { "addr": 0x00195B77, "bit": 2 }, 1: { "addr": 0x00195B77, "bit": 3 }, 2: { "addr": 0x00195B77, "bit": 4 }, 3: { "addr": 0x00195B77, "bit": 5 }, 4: { "addr": 0x00195B77, "bit": 6 }, 5: { "addr": 0x00195B77, "bit": 7 }, 6: { "addr": 0x00195B70, "bit": 0 }, 7: { "addr": 0x00195B70, "bit": 1 }, 8: { "addr": 0x00195B70, "bit": 2 }, 9: { "addr": 0x00195B70, "bit": 3 }, 10: { "addr": 0x00195B70, "bit": 4 }, 11: { "addr": 0x00195B70, "bit": 5 }, 12: { "addr": 0x00195B70, "bit": 6 }, 13: { "addr": 0x00195B70, "bit": 7 }, 14: { "addr": 0x00195B71, "bit": 0 }, 15: { "addr": 0x00195B71, "bit": 1 }, 16: { "addr": 0x00195B71, "bit": 2 }, }, },
5: { "name": "Large Body", "bits": { 0: { "addr": 0x00195B71, "bit": 3 }, 1: { "addr": 0x00195B71, "bit": 4 }, 2: { "addr": 0x00195B71, "bit": 5 }, 3: { "addr": 0x00195B71, "bit": 6 }, 4: { "addr": 0x00195B71, "bit": 7 }, 5: { "addr": 0x00195B72, "bit": 0 }, 6: { "addr": 0x00195B72, "bit": 1 }, 7: { "addr": 0x00195B72, "bit": 2 }, 8: { "addr": 0x00195B72, "bit": 3 }, 9: { "addr": 0x00195B72, "bit": 4 }, 10: { "addr": 0x00195B72, "bit": 5 }, 11: { "addr": 0x00195B72, "bit": 6 }, 12: { "addr": 0x00195B72, "bit": 7 }, 13: { "addr": 0x00195B73, "bit": 0 }, 14: { "addr": 0x00195B73, "bit": 1 }, 15: { "addr": 0x00195B73, "bit": 2 }, 16: { "addr": 0x00195B73, "bit": 3 }, }, },
6: { "name": "Yellow Opera", "bits": { 0: { "addr": 0x00195B7B, "bit": 0 }, 1: { "addr": 0x00195B7B, "bit": 1 }, 2: { "addr": 0x00195B7B, "bit": 2 }, 3: { "addr": 0x00195B7B, "bit": 3 }, 4: { "addr": 0x00195B7B, "bit": 4 }, 5: { "addr": 0x00195B7B, "bit": 5 }, 6: { "addr": 0x00195B7B, "bit": 6 }, 7: { "addr": 0x00195B7B, "bit": 7 }, 8: { "addr": 0x00195B74, "bit": 0 }, 9: { "addr": 0x00195B74, "bit": 1 }, 10: { "addr": 0x00195B74, "bit": 2 }, 11: { "addr": 0x00195B74, "bit": 3 }, 12: { "addr": 0x00195B74, "bit": 4 }, 13: { "addr": 0x00195B74, "bit": 5 }, 14: { "addr": 0x00195B74, "bit": 6 }, 15: { "addr": 0x00195B74, "bit": 7 }, 16: { "addr": 0x00195B75, "bit": 0 }, }, },
7: { "name": "Guard Armor", "bits": { 0: { "addr": 0x00195B75, "bit": 1 }, 1: { "addr": 0x00195B75, "bit": 2 }, 2: { "addr": 0x00195B75, "bit": 3 }, 3: { "addr": 0x00195B75, "bit": 4 }, 4: { "addr": 0x00195B75, "bit": 5 }, 5: { "addr": 0x00195B75, "bit": 6 }, 6: { "addr": 0x00195B75, "bit": 7 }, 7: { "addr": 0x00195B76, "bit": 0 }, 8: { "addr": 0x00195B76, "bit": 1 }, 9: { "addr": 0x00195B76, "bit": 2 }, 10: { "addr": 0x00195B76, "bit": 3 }, 11: { "addr": 0x00195B76, "bit": 4 }, 12: { "addr": 0x00195B76, "bit": 5 }, 13: { "addr": 0x00195B76, "bit": 6 }, 14: { "addr": 0x00195B76, "bit": 7 }, 15: { "addr": 0x00195B77, "bit": 0 }, 16: { "addr": 0x00195B77, "bit": 1 }, }, },
8: { "name": "Green Requiem", "bits": { 0: { "addr": 0x00195B7E, "bit": 6 }, 1: { "addr": 0x00195B7E, "bit": 7 }, 2: { "addr": 0x00195B7F, "bit": 0 }, 3: { "addr": 0x00195B7F, "bit": 1 }, 4: { "addr": 0x00195B7F, "bit": 2 }, 5: { "addr": 0x00195B7F, "bit": 3 }, 6: { "addr": 0x00195B7F, "bit": 4 }, 7: { "addr": 0x00195B7F, "bit": 5 }, 8: { "addr": 0x00195B7F, "bit": 6 }, 9: { "addr": 0x00195B7F, "bit": 7 }, 10: { "addr": 0x00195B78, "bit": 0 }, 11: { "addr": 0x00195B78, "bit": 1 }, 12: { "addr": 0x00195B78, "bit": 2 }, 13: { "addr": 0x00195B78, "bit": 3 }, 14: { "addr": 0x00195B78, "bit": 4 }, 15: { "addr": 0x00195B78, "bit": 5 }, 16: { "addr": 0x00195B78, "bit": 6 }, }, },
9: { "name": "Blue Rhapsody", "bits": { 0: { "addr": 0x00195B78, "bit": 7 }, 1: { "addr": 0x00195B79, "bit": 0 }, 2: { "addr": 0x00195B79, "bit": 1 }, 3: { "addr": 0x00195B79, "bit": 2 }, 4: { "addr": 0x00195B79, "bit": 3 }, 5: { "addr": 0x00195B79, "bit": 4 }, 6: { "addr": 0x00195B79, "bit": 5 }, 7: { "addr": 0x00195B79, "bit": 6 }, 8: { "addr": 0x00195B79, "bit": 7 }, 9: { "addr": 0x00195B7A, "bit": 0 }, 10: { "addr": 0x00195B7A, "bit": 1 }, 11: { "addr": 0x00195B7A, "bit": 2 }, 12: { "addr": 0x00195B7A, "bit": 3 }, 13: { "addr": 0x00195B7A, "bit": 4 }, 14: { "addr": 0x00195B7A, "bit": 5 }, 15: { "addr": 0x00195B7A, "bit": 6 }, 16: { "addr": 0x00195B7A, "bit": 7 }, }, },
10: { "name": "Black Fungus", "bits": { 0: { "addr": 0x00195B82, "bit": 4 }, 1: { "addr": 0x00195B82, "bit": 5 }, 2: { "addr": 0x00195B82, "bit": 6 }, 3: { "addr": 0x00195B82, "bit": 7 }, 4: { "addr": 0x00195B83, "bit": 0 }, 5: { "addr": 0x00195B83, "bit": 1 }, 6: { "addr": 0x00195B83, "bit": 2 }, 7: { "addr": 0x00195B83, "bit": 3 }, 8: { "addr": 0x00195B83, "bit": 4 }, 9: { "addr": 0x00195B83, "bit": 5 }, 10: { "addr": 0x00195B83, "bit": 6 }, 11: { "addr": 0x00195B83, "bit": 7 }, 12: { "addr": 0x00195B7C, "bit": 0 }, 13: { "addr": 0x00195B7C, "bit": 1 }, 14: { "addr": 0x00195B7C, "bit": 2 }, 15: { "addr": 0x00195B7C, "bit": 3 }, 16: { "addr": 0x00195B7C, "bit": 4 }, }, },
11: { "name": "Trickmaster", "bits": { 0: { "addr": 0x00195B7C, "bit": 5 }, 1: { "addr": 0x00195B7C, "bit": 6 }, 2: { "addr": 0x00195B7C, "bit": 7 }, 3: { "addr": 0x00195B7D, "bit": 0 }, 4: { "addr": 0x00195B7D, "bit": 1 }, 5: { "addr": 0x00195B7D, "bit": 2 }, 6: { "addr": 0x00195B7D, "bit": 3 }, 7: { "addr": 0x00195B7D, "bit": 4 }, 8: { "addr": 0x00195B7D, "bit": 5 }, 9: { "addr": 0x00195B7D, "bit": 6 }, 10: { "addr": 0x00195B7D, "bit": 7 }, 11: { "addr": 0x00195B7E, "bit": 0 }, 12: { "addr": 0x00195B7E, "bit": 1 }, 13: { "addr": 0x00195B7E, "bit": 2 }, 14: { "addr": 0x00195B7E, "bit": 3 }, 15: { "addr": 0x00195B7E, "bit": 4 }, 16: { "addr": 0x00195B7E, "bit": 5 }, }, },
12: { "name": "Hades", "bits": { 0: { "addr": 0x00195B86, "bit": 2 }, 1: { "addr": 0x00195B86, "bit": 3 }, 2: { "addr": 0x00195B86, "bit": 4 }, 3: { "addr": 0x00195B86, "bit": 5 }, 4: { "addr": 0x00195B86, "bit": 6 }, 5: { "addr": 0x00195B86, "bit": 7 }, 6: { "addr": 0x00195B87, "bit": 0 }, 7: { "addr": 0x00195B87, "bit": 1 }, 8: { "addr": 0x00195B87, "bit": 2 }, 9: { "addr": 0x00195B87, "bit": 3 }, 10: { "addr": 0x00195B87, "bit": 4 }, 11: { "addr": 0x00195B87, "bit": 5 }, 12: { "addr": 0x00195B87, "bit": 6 }, 13: { "addr": 0x00195B87, "bit": 7 }, 14: { "addr": 0x00195B80, "bit": 0 }, 15: { "addr": 0x00195B80, "bit": 1 }, 16: { "addr": 0x00195B80, "bit": 2 }, }, },
13: { "name": "Cerberus", "bits": { 0: { "addr": 0x00195B80, "bit": 3 }, 1: { "addr": 0x00195B80, "bit": 4 }, 2: { "addr": 0x00195B80, "bit": 5 }, 3: { "addr": 0x00195B80, "bit": 6 }, 4: { "addr": 0x00195B80, "bit": 7 }, 5: { "addr": 0x00195B81, "bit": 0 }, 6: { "addr": 0x00195B81, "bit": 1 }, 7: { "addr": 0x00195B81, "bit": 2 }, 8: { "addr": 0x00195B81, "bit": 3 }, 9: { "addr": 0x00195B81, "bit": 4 }, 10: { "addr": 0x00195B81, "bit": 5 }, 11: { "addr": 0x00195B81, "bit": 6 }, 12: { "addr": 0x00195B81, "bit": 7 }, 13: { "addr": 0x00195B82, "bit": 0 }, 14: { "addr": 0x00195B82, "bit": 1 }, 15: { "addr": 0x00195B82, "bit": 2 }, 16: { "addr": 0x00195B82, "bit": 3 }, }, },
14: { "name": "Behemoth", "bits": { 0: { "addr": 0x00195B8A, "bit": 0 }, 1: { "addr": 0x00195B8A, "bit": 1 }, 2: { "addr": 0x00195B8A, "bit": 2 }, 3: { "addr": 0x00195B8A, "bit": 3 }, 4: { "addr": 0x00195B8A, "bit": 4 }, 5: { "addr": 0x00195B8A, "bit": 5 }, 6: { "addr": 0x00195B8A, "bit": 6 }, 7: { "addr": 0x00195B8A, "bit": 7 }, 8: { "addr": 0x00195B8B, "bit": 0 }, 9: { "addr": 0x00195B8B, "bit": 1 }, 10: { "addr": 0x00195B8B, "bit": 2 }, 11: { "addr": 0x00195B8B, "bit": 3 }, 12: { "addr": 0x00195B8B, "bit": 4 }, 13: { "addr": 0x00195B8B, "bit": 5 }, 14: { "addr": 0x00195B8B, "bit": 6 }, 15: { "addr": 0x00195B8B, "bit": 7 }, 16: { "addr": 0x00195B84, "bit": 0 }, }, },
15: { "name": "Rock Titan", "bits": { 0: { "addr": 0x00195B84, "bit": 1 }, 1: { "addr": 0x00195B84, "bit": 2 }, 2: { "addr": 0x00195B84, "bit": 3 }, 3: { "addr": 0x00195B84, "bit": 4 }, 4: { "addr": 0x00195B84, "bit": 5 }, 5: { "addr": 0x00195B84, "bit": 6 }, 6: { "addr": 0x00195B84, "bit": 7 }, 7: { "addr": 0x00195B85, "bit": 0 }, 8: { "addr": 0x00195B85, "bit": 1 }, 9: { "addr": 0x00195B85, "bit": 2 }, 10: { "addr": 0x00195B85, "bit": 3 }, 11: { "addr": 0x00195B85, "bit": 4 }, 12: { "addr": 0x00195B85, "bit": 5 }, 13: { "addr": 0x00195B85, "bit": 6 }, 14: { "addr": 0x00195B85, "bit": 7 }, 15: { "addr": 0x00195B86, "bit": 0 }, 16: { "addr": 0x00195B86, "bit": 1 }, }, },
16: { "name": "Ice Titan", "bits": { 0: { "addr": 0x00195B8F, "bit": 7 }, 1: { "addr": 0x00195B88, "bit": 0 }, 2: { "addr": 0x00195B88, "bit": 1 }, 3: { "addr": 0x00195B88, "bit": 2 }, 4: { "addr": 0x00195B88, "bit": 3 }, 5: { "addr": 0x00195B88, "bit": 4 }, 6: { "addr": 0x00195B88, "bit": 5 }, 7: { "addr": 0x00195B88, "bit": 6 }, 8: { "addr": 0x00195B88, "bit": 7 }, 9: { "addr": 0x00195B89, "bit": 0 }, 10: { "addr": 0x00195B89, "bit": 1 }, 11: { "addr": 0x00195B89, "bit": 2 }, 12: { "addr": 0x00195B89, "bit": 3 }, 13: { "addr": 0x00195B89, "bit": 4 }, 14: { "addr": 0x00195B89, "bit": 5 }, 15: { "addr": 0x00195B89, "bit": 6 }, 16: { "addr": 0x00195B89, "bit": 7 }, }, },
17: { "name": "Blox Bug", "bits": { 0: { "addr": 0x00195B93, "bit": 5 }, 1: { "addr": 0x00195B93, "bit": 6 }, 2: { "addr": 0x00195B93, "bit": 7 }, 3: { "addr": 0x00195B8C, "bit": 0 }, 4: { "addr": 0x00195B8C, "bit": 1 }, 5: { "addr": 0x00195B8C, "bit": 2 }, 6: { "addr": 0x00195B8C, "bit": 3 }, 7: { "addr": 0x00195B8C, "bit": 4 }, 8: { "addr": 0x00195B8C, "bit": 5 }, 9: { "addr": 0x00195B8C, "bit": 6 }, 10: { "addr": 0x00195B8C, "bit": 7 }, 11: { "addr": 0x00195B8D, "bit": 0 }, 12: { "addr": 0x00195B8D, "bit": 1 }, 13: { "addr": 0x00195B8D, "bit": 2 }, 14: { "addr": 0x00195B8D, "bit": 3 }, 15: { "addr": 0x00195B8D, "bit": 4 }, 16: { "addr": 0x00195B8D, "bit": 5 }, }, },
18: { "name": "Air Soldier", "bits": { 0: { "addr": 0x00195B8D, "bit": 6 }, 1: { "addr": 0x00195B8D, "bit": 7 }, 2: { "addr": 0x00195B8E, "bit": 0 }, 3: { "addr": 0x00195B8E, "bit": 1 }, 4: { "addr": 0x00195B8E, "bit": 2 }, 5: { "addr": 0x00195B8E, "bit": 3 }, 6: { "addr": 0x00195B8E, "bit": 4 }, 7: { "addr": 0x00195B8E, "bit": 5 }, 8: { "addr": 0x00195B8E, "bit": 6 }, 9: { "addr": 0x00195B8E, "bit": 7 }, 10: { "addr": 0x00195B8F, "bit": 0 }, 11: { "addr": 0x00195B8F, "bit": 1 }, 12: { "addr": 0x00195B8F, "bit": 2 }, 13: { "addr": 0x00195B8F, "bit": 3 }, 14: { "addr": 0x00195B8F, "bit": 4 }, 15: { "addr": 0x00195B8F, "bit": 5 }, 16: { "addr": 0x00195B8F, "bit": 6 }, }, },
19: { "name": "Metal Bug", "bits": { 0: { "addr": 0x00195B97, "bit": 3 }, 1: { "addr": 0x00195B97, "bit": 4 }, 2: { "addr": 0x00195B97, "bit": 5 }, 3: { "addr": 0x00195B97, "bit": 6 }, 4: { "addr": 0x00195B97, "bit": 7 }, 5: { "addr": 0x00195B90, "bit": 0 }, 6: { "addr": 0x00195B90, "bit": 1 }, 7: { "addr": 0x00195B90, "bit": 2 }, 8: { "addr": 0x00195B90, "bit": 3 }, 9: { "addr": 0x00195B90, "bit": 4 }, 10: { "addr": 0x00195B90, "bit": 5 }, 11: { "addr": 0x00195B90, "bit": 6 }, 12: { "addr": 0x00195B90, "bit": 7 }, 13: { "addr": 0x00195B91, "bit": 0 }, 14: { "addr": 0x00195B91, "bit": 1 }, 15: { "addr": 0x00195B91, "bit": 2 }, 16: { "addr": 0x00195B91, "bit": 3 }, }, },
20: { "name": "Danger Bug", "bits": { 0: { "addr": 0x00195B91, "bit": 4 }, 1: { "addr": 0x00195B91, "bit": 5 }, 2: { "addr": 0x00195B91, "bit": 6 }, 3: { "addr": 0x00195B91, "bit": 7 }, 4: { "addr": 0x00195B92, "bit": 0 }, 5: { "addr": 0x00195B92, "bit": 1 }, 6: { "addr": 0x00195B92, "bit": 2 }, 7: { "addr": 0x00195B92, "bit": 3 }, 8: { "addr": 0x00195B92, "bit": 4 }, 9: { "addr": 0x00195B92, "bit": 5 }, 10: { "addr": 0x00195B92, "bit": 6 }, 11: { "addr": 0x00195B92, "bit": 7 }, 12: { "addr": 0x00195B93, "bit": 0 }, 13: { "addr": 0x00195B93, "bit": 1 }, 14: { "addr": 0x00195B93, "bit": 2 }, 15: { "addr": 0x00195B93, "bit": 3 }, 16: { "addr": 0x00195B93, "bit": 4 }, }, },
21: { "name": "Bandit", "bits": { 0: { "addr": 0x00195B9B, "bit": 1 }, 1: { "addr": 0x00195B9B, "bit": 2 }, 2: { "addr": 0x00195B9B, "bit": 3 }, 3: { "addr": 0x00195B9B, "bit": 4 }, 4: { "addr": 0x00195B9B, "bit": 5 }, 5: { "addr": 0x00195B9B, "bit": 6 }, 6: { "addr": 0x00195B9B, "bit": 7 }, 7: { "addr": 0x00195B94, "bit": 0 }, 8: { "addr": 0x00195B94, "bit": 1 }, 9: { "addr": 0x00195B94, "bit": 2 }, 10: { "addr": 0x00195B94, "bit": 3 }, 11: { "addr": 0x00195B94, "bit": 4 }, 12: { "addr": 0x00195B94, "bit": 5 }, 13: { "addr": 0x00195B94, "bit": 6 }, 14: { "addr": 0x00195B94, "bit": 7 }, 15: { "addr": 0x00195B95, "bit": 0 }, 16: { "addr": 0x00195B95, "bit": 1 }, }, },
22: { "name": "Prize Bug", "bits": { 0: { "addr": 0x00195B95, "bit": 2 }, 1: { "addr": 0x00195B95, "bit": 3 }, 2: { "addr": 0x00195B95, "bit": 4 }, 3: { "addr": 0x00195B95, "bit": 5 }, 4: { "addr": 0x00195B95, "bit": 6 }, 5: { "addr": 0x00195B95, "bit": 7 }, 6: { "addr": 0x00195B96, "bit": 0 }, 7: { "addr": 0x00195B96, "bit": 1 }, 8: { "addr": 0x00195B96, "bit": 2 }, 9: { "addr": 0x00195B96, "bit": 3 }, 10: { "addr": 0x00195B96, "bit": 4 }, 11: { "addr": 0x00195B96, "bit": 5 }, 12: { "addr": 0x00195B96, "bit": 6 }, 13: { "addr": 0x00195B96, "bit": 7 }, 14: { "addr": 0x00195B97, "bit": 0 }, 15: { "addr": 0x00195B97, "bit": 1 }, 16: { "addr": 0x00195B97, "bit": 2 }, }, },
23: { "name": "Jafar", "bits": { 0: { "addr": 0x00195B9E, "bit": 7 }, 1: { "addr": 0x00195B9F, "bit": 0 }, 2: { "addr": 0x00195B9F, "bit": 1 }, 3: { "addr": 0x00195B9F, "bit": 2 }, 4: { "addr": 0x00195B9F, "bit": 3 }, 5: { "addr": 0x00195B9F, "bit": 4 }, 6: { "addr": 0x00195B9F, "bit": 5 }, 7: { "addr": 0x00195B9F, "bit": 6 }, 8: { "addr": 0x00195B9F, "bit": 7 }, 9: { "addr": 0x00195B98, "bit": 0 }, 10: { "addr": 0x00195B98, "bit": 1 }, 11: { "addr": 0x00195B98, "bit": 2 }, 12: { "addr": 0x00195B98, "bit": 3 }, 13: { "addr": 0x00195B98, "bit": 4 }, 14: { "addr": 0x00195B98, "bit": 5 }, 15: { "addr": 0x00195B98, "bit": 6 }, 16: { "addr": 0x00195B98, "bit": 7 }, }, },
24: { "name": "Fat Bandit", "bits": { 0: { "addr": 0x00195B99, "bit": 0 }, 1: { "addr": 0x00195B99, "bit": 1 }, 2: { "addr": 0x00195B99, "bit": 2 }, 3: { "addr": 0x00195B99, "bit": 3 }, 4: { "addr": 0x00195B99, "bit": 4 }, 5: { "addr": 0x00195B99, "bit": 5 }, 6: { "addr": 0x00195B99, "bit": 6 }, 7: { "addr": 0x00195B99, "bit": 7 }, 8: { "addr": 0x00195B9A, "bit": 0 }, 9: { "addr": 0x00195B9A, "bit": 1 }, 10: { "addr": 0x00195B9A, "bit": 2 }, 11: { "addr": 0x00195B9A, "bit": 3 }, 12: { "addr": 0x00195B9A, "bit": 4 }, 13: { "addr": 0x00195B9A, "bit": 5 }, 14: { "addr": 0x00195B9A, "bit": 6 }, 15: { "addr": 0x00195B9A, "bit": 7 }, 16: { "addr": 0x00195B9B, "bit": 0 }, }, },
25: { "name": "Darkball", "bits": { 0: { "addr": 0x00195BA2, "bit": 5 }, 1: { "addr": 0x00195BA2, "bit": 6 }, 2: { "addr": 0x00195BA2, "bit": 7 }, 3: { "addr": 0x00195BA3, "bit": 0 }, 4: { "addr": 0x00195BA3, "bit": 1 }, 5: { "addr": 0x00195BA3, "bit": 2 }, 6: { "addr": 0x00195BA3, "bit": 3 }, 7: { "addr": 0x00195BA3, "bit": 4 }, 8: { "addr": 0x00195BA3, "bit": 5 }, 9: { "addr": 0x00195BA3, "bit": 6 }, 10: { "addr": 0x00195BA3, "bit": 7 }, 11: { "addr": 0x00195B9C, "bit": 0 }, 12: { "addr": 0x00195B9C, "bit": 1 }, 13: { "addr": 0x00195B9C, "bit": 2 }, 14: { "addr": 0x00195B9C, "bit": 3 }, 15: { "addr": 0x00195B9C, "bit": 4 }, 16: { "addr": 0x00195B9C, "bit": 5 }, }, },
26: { "name": "Jafar (Genie)", "bits": { 0: { "addr": 0x00195B9C, "bit": 6 }, 1: { "addr": 0x00195B9C, "bit": 7 }, 2: { "addr": 0x00195B9D, "bit": 0 }, 3: { "addr": 0x00195B9D, "bit": 1 }, 4: { "addr": 0x00195B9D, "bit": 2 }, 5: { "addr": 0x00195B9D, "bit": 3 }, 6: { "addr": 0x00195B9D, "bit": 4 }, 7: { "addr": 0x00195B9D, "bit": 5 }, 8: { "addr": 0x00195B9D, "bit": 6 }, 9: { "addr": 0x00195B9D, "bit": 7 }, 10: { "addr": 0x00195B9E, "bit": 0 }, 11: { "addr": 0x00195B9E, "bit": 1 }, 12: { "addr": 0x00195B9E, "bit": 2 }, 13: { "addr": 0x00195B9E, "bit": 3 }, 14: { "addr": 0x00195B9E, "bit": 4 }, 15: { "addr": 0x00195B9E, "bit": 5 }, 16: { "addr": 0x00195B9E, "bit": 6 }, }, },
27: { "name": "Pete", "bits": { 0: { "addr": 0x00195BA6, "bit": 3 }, 1: { "addr": 0x00195BA6, "bit": 4 }, 2: { "addr": 0x00195BA6, "bit": 5 }, 3: { "addr": 0x00195BA6, "bit": 6 }, 4: { "addr": 0x00195BA6, "bit": 7 }, 5: { "addr": 0x00195BA7, "bit": 0 }, 6: { "addr": 0x00195BA7, "bit": 1 }, 7: { "addr": 0x00195BA7, "bit": 2 }, 8: { "addr": 0x00195BA7, "bit": 3 }, 9: { "addr": 0x00195BA7, "bit": 4 }, 10: { "addr": 0x00195BA7, "bit": 5 }, 11: { "addr": 0x00195BA7, "bit": 6 }, 12: { "addr": 0x00195BA7, "bit": 7 }, 13: { "addr": 0x00195BA0, "bit": 0 }, 14: { "addr": 0x00195BA0, "bit": 1 }, 15: { "addr": 0x00195BA0, "bit": 2 }, 16: { "addr": 0x00195BA0, "bit": 3 }, }, },
28: { "name": "Wyvern", "bits": { 0: { "addr": 0x00195BA0, "bit": 4 }, 1: { "addr": 0x00195BA0, "bit": 5 }, 2: { "addr": 0x00195BA0, "bit": 6 }, 3: { "addr": 0x00195BA0, "bit": 7 }, 4: { "addr": 0x00195BA1, "bit": 0 }, 5: { "addr": 0x00195BA1, "bit": 1 }, 6: { "addr": 0x00195BA1, "bit": 2 }, 7: { "addr": 0x00195BA1, "bit": 3 }, 8: { "addr": 0x00195BA1, "bit": 4 }, 9: { "addr": 0x00195BA1, "bit": 5 }, 10: { "addr": 0x00195BA1, "bit": 6 }, 11: { "addr": 0x00195BA1, "bit": 7 }, 12: { "addr": 0x00195BA2, "bit": 0 }, 13: { "addr": 0x00195BA2, "bit": 1 }, 14: { "addr": 0x00195BA2, "bit": 2 }, 15: { "addr": 0x00195BA2, "bit": 3 }, 16: { "addr": 0x00195BA2, "bit": 4 }, }, },
29: { "name": "Wizard", "bits": { 0: { "addr": 0x00195BAA, "bit": 1 }, 1: { "addr": 0x00195BAA, "bit": 2 }, 2: { "addr": 0x00195BAA, "bit": 3 }, 3: { "addr": 0x00195BAA, "bit": 4 }, 4: { "addr": 0x00195BAA, "bit": 5 }, 5: { "addr": 0x00195BAA, "bit": 6 }, 6: { "addr": 0x00195BAA, "bit": 7 }, 7: { "addr": 0x00195BAB, "bit": 0 }, 8: { "addr": 0x00195BAB, "bit": 1 }, 9: { "addr": 0x00195BAB, "bit": 2 }, 10: { "addr": 0x00195BAB, "bit": 3 }, 11: { "addr": 0x00195BAB, "bit": 4 }, 12: { "addr": 0x00195BAB, "bit": 5 }, 13: { "addr": 0x00195BAB, "bit": 6 }, 14: { "addr": 0x00195BAB, "bit": 7 }, 15: { "addr": 0x00195BA4, "bit": 0 }, 16: { "addr": 0x00195BA4, "bit": 1 }, }, },
30: { "name": "Data-Riku", "bits": { 0: { "addr": 0x00195BA4, "bit": 2 }, 1: { "addr": 0x00195BA4, "bit": 3 }, 2: { "addr": 0x00195BA4, "bit": 4 }, 3: { "addr": 0x00195BA4, "bit": 5 }, 4: { "addr": 0x00195BA4, "bit": 6 }, 5: { "addr": 0x00195BA4, "bit": 7 }, 6: { "addr": 0x00195BA5, "bit": 0 }, 7: { "addr": 0x00195BA5, "bit": 1 }, 8: { "addr": 0x00195BA5, "bit": 2 }, 9: { "addr": 0x00195BA5, "bit": 3 }, 10: { "addr": 0x00195BA5, "bit": 4 }, 11: { "addr": 0x00195BA5, "bit": 5 }, 12: { "addr": 0x00195BA5, "bit": 6 }, 13: { "addr": 0x00195BA5, "bit": 7 }, 14: { "addr": 0x00195BA6, "bit": 0 }, 15: { "addr": 0x00195BA6, "bit": 1 }, 16: { "addr": 0x00195BA6, "bit": 2 }, }, },
31: { "name": "Defender", "bits": { 0: { "addr": 0x00195BA8, "bit": 0 }, 1: { "addr": 0x00195BA8, "bit": 1 }, 2: { "addr": 0x00195BA8, "bit": 2 }, 3: { "addr": 0x00195BA8, "bit": 3 }, 4: { "addr": 0x00195BA8, "bit": 4 }, 5: { "addr": 0x00195BA8, "bit": 5 }, 6: { "addr": 0x00195BA8, "bit": 6 }, 7: { "addr": 0x00195BA8, "bit": 7 }, 8: { "addr": 0x00195BA9, "bit": 0 }, 9: { "addr": 0x00195BA9, "bit": 1 }, 10: { "addr": 0x00195BA9, "bit": 2 }, 11: { "addr": 0x00195BA9, "bit": 3 }, 12: { "addr": 0x00195BA9, "bit": 4 }, 13: { "addr": 0x00195BA9, "bit": 5 }, 14: { "addr": 0x00195BA9, "bit": 6 }, 15: { "addr": 0x00195BA9, "bit": 7 }, 16: { "addr": 0x00195BAA, "bit": 0 }, }, },
32: { "name": "Sora’s Heartless", "bits": { 0: { "addr": 0x00195BB3, "bit": 6 }, 1: { "addr": 0x00195BB3, "bit": 7 }, 2: { "addr": 0x00195BAC, "bit": 0 }, 3: { "addr": 0x00195BAC, "bit": 1 }, 4: { "addr": 0x00195BAC, "bit": 2 }, 5: { "addr": 0x00195BAC, "bit": 3 }, 6: { "addr": 0x00195BAC, "bit": 4 }, 7: { "addr": 0x00195BAC, "bit": 5 }, 8: { "addr": 0x00195BAC, "bit": 6 }, 9: { "addr": 0x00195BAC, "bit": 7 }, 10: { "addr": 0x00195BAD, "bit": 0 }, 11: { "addr": 0x00195BAD, "bit": 1 }, 12: { "addr": 0x00195BAD, "bit": 2 }, 13: { "addr": 0x00195BAD, "bit": 3 }, 14: { "addr": 0x00195BAD, "bit": 4 }, 15: { "addr": 0x00195BAD, "bit": 5 }, 16: { "addr": 0x00195BAD, "bit": 6 }, }, },
33: { "name": "Dragon", "bits": { 0: { "addr": 0x00195BAD, "bit": 7 }, 1: { "addr": 0x00195BAE, "bit": 0 }, 2: { "addr": 0x00195BAE, "bit": 1 }, 3: { "addr": 0x00195BAE, "bit": 2 }, 4: { "addr": 0x00195BAE, "bit": 3 }, 5: { "addr": 0x00195BAE, "bit": 4 }, 6: { "addr": 0x00195BAE, "bit": 5 }, 7: { "addr": 0x00195BAE, "bit": 6 }, 8: { "addr": 0x00195BAE, "bit": 7 }, 9: { "addr": 0x00195BAF, "bit": 0 }, 10: { "addr": 0x00195BAF, "bit": 1 }, 11: { "addr": 0x00195BAF, "bit": 2 }, 12: { "addr": 0x00195BAF, "bit": 3 }, 13: { "addr": 0x00195BAF, "bit": 4 }, 14: { "addr": 0x00195BAF, "bit": 5 }, 15: { "addr": 0x00195BAF, "bit": 6 }, 16: { "addr": 0x00195BAF, "bit": 7 }, }, },
34: { "name": "Invisible", "bits": { 0: { "addr": 0x00195BB7, "bit": 4 }, 1: { "addr": 0x00195BB7, "bit": 5 }, 2: { "addr": 0x00195BB7, "bit": 6 }, 3: { "addr": 0x00195BB7, "bit": 7 }, 4: { "addr": 0x00195BB0, "bit": 0 }, 5: { "addr": 0x00195BB0, "bit": 1 }, 6: { "addr": 0x00195BB0, "bit": 2 }, 7: { "addr": 0x00195BB0, "bit": 3 }, 8: { "addr": 0x00195BB0, "bit": 4 }, 9: { "addr": 0x00195BB0, "bit": 5 }, 10: { "addr": 0x00195BB0, "bit": 6 }, 11: { "addr": 0x00195BB0, "bit": 7 }, 12: { "addr": 0x00195BB1, "bit": 0 }, 13: { "addr": 0x00195BB1, "bit": 1 }, 14: { "addr": 0x00195BB1, "bit": 2 }, 15: { "addr": 0x00195BB1, "bit": 3 }, 16: { "addr": 0x00195BB1, "bit": 4 }, }, },
35: { "name": "Sora’s Heartless (Humanoid)", "bits": { 0: { "addr": 0x00195BB1, "bit": 5 }, 1: { "addr": 0x00195BB1, "bit": 6 }, 2: { "addr": 0x00195BB1, "bit": 7 }, 3: { "addr": 0x00195BB2, "bit": 0 }, 4: { "addr": 0x00195BB2, "bit": 1 }, 5: { "addr": 0x00195BB2, "bit": 2 }, 6: { "addr": 0x00195BB2, "bit": 3 }, 7: { "addr": 0x00195BB2, "bit": 4 }, 8: { "addr": 0x00195BB2, "bit": 5 }, 9: { "addr": 0x00195BB2, "bit": 6 }, 10: { "addr": 0x00195BB2, "bit": 7 }, 11: { "addr": 0x00195BB3, "bit": 0 }, 12: { "addr": 0x00195BB3, "bit": 1 }, 13: { "addr": 0x00195BB3, "bit": 2 }, 14: { "addr": 0x00195BB3, "bit": 3 }, 15: { "addr": 0x00195BB3, "bit": 4 }, 16: { "addr": 0x00195BB3, "bit": 5 }, }, },
36: { "name": "Data-Roxas", "bits": { 0: { "addr": 0x00195BBB, "bit": 2 }, 1: { "addr": 0x00195BBB, "bit": 3 }, 2: { "addr": 0x00195BBB, "bit": 4 }, 3: { "addr": 0x00195BBB, "bit": 5 }, 4: { "addr": 0x00195BBB, "bit": 6 }, 5: { "addr": 0x00195BBB, "bit": 7 }, 6: { "addr": 0x00195BB4, "bit": 0 }, 7: { "addr": 0x00195BB4, "bit": 1 }, 8: { "addr": 0x00195BB4, "bit": 2 }, 9: { "addr": 0x00195BB4, "bit": 3 }, 10: { "addr": 0x00195BB4, "bit": 4 }, 11: { "addr": 0x00195BB4, "bit": 5 }, 12: { "addr": 0x00195BB4, "bit": 6 }, 13: { "addr": 0x00195BB4, "bit": 7 }, 14: { "addr": 0x00195BB5, "bit": 0 }, 15: { "addr": 0x00195BB5, "bit": 1 }, 16: { "addr": 0x00195BB5, "bit": 2 }, }, },
37: { "name": "Angel Star", "bits": { 0: { "addr": 0x00195BB5, "bit": 3 }, 1: { "addr": 0x00195BB5, "bit": 4 }, 2: { "addr": 0x00195BB5, "bit": 5 }, 3: { "addr": 0x00195BB5, "bit": 6 }, 4: { "addr": 0x00195BB5, "bit": 7 }, 5: { "addr": 0x00195BB6, "bit": 0 }, 6: { "addr": 0x00195BB6, "bit": 1 }, 7: { "addr": 0x00195BB6, "bit": 2 }, 8: { "addr": 0x00195BB6, "bit": 3 }, 9: { "addr": 0x00195BB6, "bit": 4 }, 10: { "addr": 0x00195BB6, "bit": 5 }, 11: { "addr": 0x00195BB6, "bit": 6 }, 12: { "addr": 0x00195BB6, "bit": 7 }, 13: { "addr": 0x00195BB7, "bit": 0 }, 14: { "addr": 0x00195BB7, "bit": 1 }, 15: { "addr": 0x00195BB7, "bit": 2 }, 16: { "addr": 0x00195BB7, "bit": 3 }, }, },
38: { "name": "Gold Tricholoma", "bits": { 0: { "addr": 0x00195BBF, "bit": 0 }, 1: { "addr": 0x00195BBF, "bit": 1 }, 2: { "addr": 0x00195BBF, "bit": 2 }, 3: { "addr": 0x00195BBF, "bit": 3 }, 4: { "addr": 0x00195BBF, "bit": 4 }, 5: { "addr": 0x00195BBF, "bit": 5 }, 6: { "addr": 0x00195BBF, "bit": 6 }, 7: { "addr": 0x00195BBF, "bit": 7 }, 8: { "addr": 0x00195BB8, "bit": 0 }, 9: { "addr": 0x00195BB8, "bit": 1 }, 10: { "addr": 0x00195BB8, "bit": 2 }, 11: { "addr": 0x00195BB8, "bit": 3 }, 12: { "addr": 0x00195BB8, "bit": 4 }, 13: { "addr": 0x00195BB8, "bit": 5 }, 14: { "addr": 0x00195BB8, "bit": 6 }, 15: { "addr": 0x00195BB8, "bit": 7 }, 16: { "addr": 0x00195BB9, "bit": 0 }, }, },
39: { "name": "Eliminator", "bits": { 0: { "addr": 0x00195BB9, "bit": 1 }, 1: { "addr": 0x00195BB9, "bit": 2 }, 2: { "addr": 0x00195BB9, "bit": 3 }, 3: { "addr": 0x00195BB9, "bit": 4 }, 4: { "addr": 0x00195BB9, "bit": 5 }, 5: { "addr": 0x00195BB9, "bit": 6 }, 6: { "addr": 0x00195BB9, "bit": 7 }, 7: { "addr": 0x00195BBA, "bit": 0 }, 8: { "addr": 0x00195BBA, "bit": 1 }, 9: { "addr": 0x00195BBA, "bit": 2 }, 10: { "addr": 0x00195BBA, "bit": 3 }, 11: { "addr": 0x00195BBA, "bit": 4 }, 12: { "addr": 0x00195BBA, "bit": 5 }, 13: { "addr": 0x00195BBA, "bit": 6 }, 14: { "addr": 0x00195BBA, "bit": 7 }, 15: { "addr": 0x00195BBB, "bit": 0 }, 16: { "addr": 0x00195BBB, "bit": 1 }, }, },
}

function GetEnemyByName(name)
{
    for i in enemies
    {
        enemy = enemies[i]
        if (enemy["name"] == name)
        {
            return enemy
        }
    }
}

function GetBitFromBits(bitIndex, bits)
{
    for i in bits
    {
        if (i == bitIndex)
        {
            return bits[i]
        }
    }
}

function JustDefeatedEnemy(name)
{
    enemy = GetEnemyByName(name)
    defeated = always_false()
    for i in enemy["bits"]
    {
        bit = enemy["bits"][i]
        
        // We only need to check to see if a bit changes from 0 to 1 because the overall enemy defeated count will only ever increase if it changes in game.
        // Therefore, we don't also need to check to see if the value goes down at all.
        defeated = defeated || IsValueJustSet(bit(bit["bit"], bit["addr"]), 0, 1)
    }
    return defeated
}

function DidDefeatEnemy(name)
{
    enemy = GetEnemyByName(name)
    defeated = always_false()
    for i in enemy["bits"]
    {
        bit = enemy["bits"][i]
        
        // We only need to check to see if a bit changes from 0 to 1 because the overall enemy defeated count will only ever increase if it changes in game.
        // Therefore, we don't also need to check to see if the value goes down at all.
        defeated = defeated || once(IsValueJustSet(bit(bit["bit"], bit["addr"]), 0, 1))
    }
    return defeated
}

function GenerateConditionForEnemy(enemy)
{
    countsWhen = always_false()
    recalculateWhen = always_false()
    
    for j in enemy["bits"]
    {
        bit = enemy["bits"][j]
        mem = bit(bit["bit"], bit["addr"])
        countsWhen = countsWhen || mem == 1
        recalculateWhen = recalculateWhen || Delta(mem) != mem
    }
    
    return { "countsWhen": countsWhen, "recalculateWhen": recalculateWhen }
}

enemiesConditions = {}

for i in enemies
{
    enemiesConditions[i] = GenerateConditionForEnemy(enemies[i])
}

// ============================== COMMANDS ============================== //
commands = {
0xFF: { "id": 0xFF, "name": "N/A", "category": "N/A", "isBasic": 1 },
0x00: { "id": 0x00, "name": "Quick Blitz", "category": "Melee", "isBasic": 1 },
0x01: { "id": 0x01, "name": "Sliding Dash", "category": "Melee", "isBasic": 1 },
0x02: { "id": 0x02, "name": "Round Blitz", "category": "Melee", "isBasic": 1 },
0x03: { "id": 0x03, "name": "Strike Raid", "category": "Ranged", "isBasic": 1 },
0x04: { "id": 0x04, "name": "Rising Strike", "category": "Melee", "isBasic": 0 },
0x05: { "id": 0x05, "name": "Sliding Rush", "category": "Melee", "isBasic": 1 },
0x06: { "id": 0x06, "name": "Aerial Sweep", "category": "Melee", "isBasic": 0 },
0x07: { "id": 0x07, "name": "Air Sweep", "category": "Melee", "isBasic": 1 },
0x08: { "id": 0x08, "name": "Aerial Slam", "category": "Melee", "isBasic": 1 },
0x09: { "id": 0x09, "name": "Land Crash", "category": "Melee", "isBasic": 1 },
0x0a: { "id": 0x0a, "name": "Fire Edge", "category": "Melee", "isBasic": 0 },
0x0b: { "id": 0x0b, "name": "Blizzard Edge", "category": "Melee", "isBasic": 0 },
0x0c: { "id": 0x0c, "name": "Thunder Edge", "category": "Melee", "isBasic": 0 },
0x0d: { "id": 0x0d, "name": "Aero Edge", "category": "Melee", "isBasic": 0 },
0x0e: { "id": 0x0e, "name": "Heat Dash", "category": "Melee", "isBasic": 0 },
0x0f: { "id": 0x0f, "name": "Ice Dash", "category": "Melee", "isBasic": 0 },
0x10: { "id": 0x10, "name": "Spark Dash", "category": "Melee", "isBasic": 0 },
0x11: { "id": 0x11, "name": "Wind Dash", "category": "Melee", "isBasic": 0 },
0x12: { "id": 0x12, "name": "Fire Blast", "category": "Melee", "isBasic": 0 },
0x13: { "id": 0x13, "name": "Blizzard Blast", "category": "Melee", "isBasic": 0 },
0x14: { "id": 0x14, "name": "Thunder Blast", "category": "Melee", "isBasic": 0 },
0x15: { "id": 0x15, "name": "Aero Blast", "category": "Melee", "isBasic": 0 },
0x16: { "id": 0x16, "name": "Fire Raid", "category": "Ranged", "isBasic": 0 },
0x17: { "id": 0x17, "name": "Blizzard Raid", "category": "Ranged", "isBasic": 0 },
0x18: { "id": 0x18, "name": "Thunder Raid", "category": "Ranged", "isBasic": 0 },
0x19: { "id": 0x19, "name": "Aero Raid", "category": "Ranged", "isBasic": 0 },
0x1a: { "id": 0x1a, "name": "Fire Buster", "category": "Melee", "isBasic": 0 },
0x1b: { "id": 0x1b, "name": "Blizzard Buster", "category": "Melee", "isBasic": 0 },
0x1c: { "id": 0x1c, "name": "Thunder Buster", "category": "Melee", "isBasic": 0 },
0x1d: { "id": 0x1d, "name": "Aero Buster", "category": "Melee", "isBasic": 0 },
0x1e: { "id": 0x1e, "name": "Heat Sweep", "category": "Melee", "isBasic": 0 },
0x1f: { "id": 0x1f, "name": "Ice Sweep", "category": "Melee", "isBasic": 0 },
0x20: { "id": 0x20, "name": "Spark Sweep", "category": "Melee", "isBasic": 0 },
0x21: { "id": 0x21, "name": "Wind Sweep", "category": "Melee", "isBasic": 0 },
0x22: { "id": 0x22, "name": "Heat Storm", "category": "Melee", "isBasic": 0 },
0x23: { "id": 0x23, "name": "Ice Storm", "category": "Melee", "isBasic": 0 },
0x24: { "id": 0x24, "name": "Spark Storm", "category": "Melee", "isBasic": 0 },
0x25: { "id": 0x25, "name": "Wind Storm", "category": "Melee", "isBasic": 0 },
0x26: { "id": 0x26, "name": "Fire Slam", "category": "Melee", "isBasic": 0 },
0x27: { "id": 0x27, "name": "Blizzard Slam", "category": "Melee", "isBasic": 0 },
0x28: { "id": 0x28, "name": "Thunder Slam", "category": "Melee", "isBasic": 0 },
0x29: { "id": 0x29, "name": "Aero Slam", "category": "Melee", "isBasic": 0 },
0x2a: { "id": 0x2a, "name": "Heat Dive", "category": "Melee", "isBasic": 0 },
0x2b: { "id": 0x2b, "name": "Ice Dive", "category": "Melee", "isBasic": 0 },
0x2c: { "id": 0x2c, "name": "Spark Dive", "category": "Melee", "isBasic": 0 },
0x2d: { "id": 0x2d, "name": "Wind Dive", "category": "Melee", "isBasic": 0 },
0x2e: { "id": 0x2e, "name": "Stun Impact", "category": "Melee", "isBasic": 0 },
0x2f: { "id": 0x2f, "name": "Muscle Strike", "category": "Melee", "isBasic": 0 },
0x30: { "id": 0x30, "name": "Chain Rave", "category": "Melee", "isBasic": 0 },
0x31: { "id": 0x31, "name": "Rising Rush", "category": "Melee", "isBasic": 0 },
0x32: { "id": 0x32, "name": "Zantetsuken", "category": "Melee", "isBasic": 0 },
0x33: { "id": 0x33, "name": "Eruption", "category": "Melee", "isBasic": 0 },
0x34: { "id": 0x34, "name": "Gravity Drop", "category": "Melee", "isBasic": 0 },
0x35: { "id": 0x35, "name": "Shock Fall", "category": "Melee", "isBasic": 0 },
0x36: { "id": 0x36, "name": "Judgment Triad", "category": "Ranged", "isBasic": 0 },
0x37: { "id": 0x37, "name": "Fire", "category": "Ranged", "isBasic": 1 },
0x38: { "id": 0x38, "name": "Fira", "category": "Ranged", "isBasic": 0 },
0x39: { "id": 0x39, "name": "Firaga", "category": "Ranged", "isBasic": 0 },
0x3a: { "id": 0x3a, "name": "Blizzard", "category": "Ranged", "isBasic": 1 },
0x3b: { "id": 0x3b, "name": "Blizzara", "category": "Ranged", "isBasic": 0 },
0x3c: { "id": 0x3c, "name": "Blizzaga", "category": "Ranged", "isBasic": 0 },
0x3d: { "id": 0x3d, "name": "Thunder", "category": "Ranged", "isBasic": 1 },
0x3e: { "id": 0x3e, "name": "Thundara", "category": "Ranged", "isBasic": 0 },
0x3f: { "id": 0x3f, "name": "Thundaga", "category": "Ranged", "isBasic": 0 },
0x40: { "id": 0x40, "name": "Aero", "category": "Ranged", "isBasic": 1 },
0x41: { "id": 0x41, "name": "Aerora", "category": "Ranged", "isBasic": 0 },
0x42: { "id": 0x42, "name": "Aeroga", "category": "Ranged", "isBasic": 0 },
0x43: { "id": 0x43, "name": "Magnet", "category": "Ranged", "isBasic": 1 },
0x44: { "id": 0x44, "name": "Magnera", "category": "Ranged", "isBasic": 0 },
0x45: { "id": 0x45, "name": "Magnega", "category": "Ranged", "isBasic": 0 },
0x46: { "id": 0x46, "name": "Cure", "category": "Curative", "isBasic": 1 },
0x47: { "id": 0x47, "name": "Cura", "category": "Curative", "isBasic": 0 },
0x48: { "id": 0x48, "name": "Curaga", "category": "Curative", "isBasic": 0 },
0x49: { "id": 0x49, "name": "Slow", "category": "Ranged", "isBasic": 1 },
0x4a: { "id": 0x4a, "name": "Stop", "category": "Ranged", "isBasic": 1 },
0x4b: { "id": 0x4b, "name": "Confuse", "category": "Ranged", "isBasic": 1 },
0x4c: { "id": 0x4c, "name": "Firaga Burst", "category": "Ranged", "isBasic": 0 },
0x4d: { "id": 0x4d, "name": "Triple Firaga", "category": "Ranged", "isBasic": 0 },
0x4e: { "id": 0x4e, "name": "Triple Burst", "category": "Ranged", "isBasic": 0 },
0x4f: { "id": 0x4f, "name": "Blizzaga Pursuit", "category": "Ranged", "isBasic": 0 },
0x50: { "id": 0x50, "name": "Triple Blizzaga", "category": "Ranged", "isBasic": 0 },
0x51: { "id": 0x51, "name": "Triple Pursuit", "category": "Ranged", "isBasic": 0 },
0x52: { "id": 0x52, "name": "Thunder Tracer", "category": "Ranged", "isBasic": 0 },
0x53: { "id": 0x53, "name": "Pulse Tracer", "category": "Ranged", "isBasic": 0 },
0x54: { "id": 0x54, "name": "Tornado Tracer", "category": "Ranged", "isBasic": 0 },
0x55: { "id": 0x55, "name": "Wind Tracer", "category": "Ranged", "isBasic": 0 },
0x56: { "id": 0x56, "name": "Magnet Grab", "category": "Ranged", "isBasic": 0 },
0x57: { "id": 0x57, "name": "Esuna", "category": "Curative", "isBasic": 1 },
0x58: { "id": 0x58, "name": "Flame Fall", "category": "Ranged", "isBasic": 0 },
0x59: { "id": 0x59, "name": "Icicle Mine", "category": "Ranged", "isBasic": 0 },
0x5a: { "id": 0x5a, "name": "Exo Spark", "category": "Ranged", "isBasic": 0 },
0x5b: { "id": 0x5b, "name": "Cyclone", "category": "Ranged", "isBasic": 0 },
0x5c: { "id": 0x5c, "name": "Quake", "category": "Ranged", "isBasic": 0 },
}

conversionCombinations = {
0: { "targetId": 0x46, "command1Id": 0x02, "command2Id": 0x49, },
1: { "targetId": 0x47, "command1Id": 0x17, "command2Id": 0x46, },
2: { "targetId": 0x47, "command1Id": 0x44, "command2Id": 0x46, },
3: { "targetId": 0x47, "command1Id": 0x49, "command2Id": 0x46, },
4: { "targetId": 0x47, "command1Id": 0x4a, "command2Id": 0x46, },
5: { "targetId": 0x48, "command1Id": 0x2a, "command2Id": 0x47, },
6: { "targetId": 0x48, "command1Id": 0x4b, "command2Id": 0x47, },
7: { "targetId": 0x48, "command1Id": 0x57, "command2Id": 0x47, },
8: { "targetId": 0x16, "command1Id": 0x03, "command2Id": 0x01, },
9: { "targetId": 0x16, "command1Id": 0x04, "command2Id": 0x19, },
10: { "targetId": 0x16, "command1Id": 0x08, "command2Id": 0x0e, },
11: { "targetId": 0x16, "command1Id": 0x37, "command2Id": 0x03, },
12: { "targetId": 0x16, "command1Id": 0x38, "command2Id": 0x03, },
13: { "targetId": 0x17, "command1Id": 0x03, "command2Id": 0x01, },
14: { "targetId": 0x17, "command1Id": 0x04, "command2Id": 0x16, },
15: { "targetId": 0x17, "command1Id": 0x08, "command2Id": 0x0f, },
16: { "targetId": 0x17, "command1Id": 0x3a, "command2Id": 0x03, },
17: { "targetId": 0x17, "command1Id": 0x3b, "command2Id": 0x03, },
18: { "targetId": 0x18, "command1Id": 0x03, "command2Id": 0x02, },
19: { "targetId": 0x18, "command1Id": 0x04, "command2Id": 0x17, },
20: { "targetId": 0x18, "command1Id": 0x08, "command2Id": 0x10, },
21: { "targetId": 0x18, "command1Id": 0x3d, "command2Id": 0x03, },
22: { "targetId": 0x18, "command1Id": 0x3e, "command2Id": 0x03, },
23: { "targetId": 0x19, "command1Id": 0x09, "command2Id": 0x09, },
24: { "targetId": 0x19, "command1Id": 0x08, "command2Id": 0x11, },
25: { "targetId": 0x19, "command1Id": 0x11, "command2Id": 0x18, },
26: { "targetId": 0x19, "command1Id": 0x40, "command2Id": 0x03, },
27: { "targetId": 0x19, "command1Id": 0x41, "command2Id": 0x03, },
28: { "targetId": 0x36, "command1Id": 0x2f, "command2Id": 0x55, },
29: { "targetId": 0x38, "command1Id": 0x0a, "command2Id": 0x02, },
30: { "targetId": 0x38, "command1Id": 0x37, "command2Id": 0x0a, },
31: { "targetId": 0x38, "command1Id": 0x37, "command2Id": 0x46, },
32: { "targetId": 0x38, "command1Id": 0x37, "command2Id": 0x49, },
33: { "targetId": 0x38, "command1Id": 0x46, "command2Id": 0x0a, },
34: { "targetId": 0x38, "command1Id": 0x49, "command2Id": 0x0a, },
35: { "targetId": 0x38, "command1Id": 0x4a, "command2Id": 0x0a, },
36: { "targetId": 0x39, "command1Id": 0x12, "command2Id": 0x16, },
37: { "targetId": 0x39, "command1Id": 0x38, "command2Id": 0x22, },
38: { "targetId": 0x39, "command1Id": 0x4b, "command2Id": 0x22, },
39: { "targetId": 0x39, "command1Id": 0x57, "command2Id": 0x22, },
40: { "targetId": 0x3b, "command1Id": 0x0f, "command2Id": 0x00, },
41: { "targetId": 0x3b, "command1Id": 0x3a, "command2Id": 0x0b, },
42: { "targetId": 0x3b, "command1Id": 0x3a, "command2Id": 0x37, },
43: { "targetId": 0x3b, "command1Id": 0x3a, "command2Id": 0x3d, },
44: { "targetId": 0x3b, "command1Id": 0x3a, "command2Id": 0x46, },
45: { "targetId": 0x3b, "command1Id": 0x3a, "command2Id": 0x49, },
46: { "targetId": 0x3b, "command1Id": 0x46, "command2Id": 0x0b, },
47: { "targetId": 0x3b, "command1Id": 0x49, "command2Id": 0x0b, },
48: { "targetId": 0x3b, "command1Id": 0x4a, "command2Id": 0x0b, },
49: { "targetId": 0x3c, "command1Id": 0x0f, "command2Id": 0x14, },
50: { "targetId": 0x3c, "command1Id": 0x1d, "command2Id": 0x23, },
51: { "targetId": 0x3c, "command1Id": 0x2b, "command2Id": 0x3b, },
52: { "targetId": 0x3c, "command1Id": 0x4b, "command2Id": 0x23, },
53: { "targetId": 0x3c, "command1Id": 0x57, "command2Id": 0x23, },
54: { "targetId": 0x3e, "command1Id": 0x0c, "command2Id": 0x37, },
55: { "targetId": 0x3e, "command1Id": 0x10, "command2Id": 0x02, },
56: { "targetId": 0x3e, "command1Id": 0x3d, "command2Id": 0x0c, },
57: { "targetId": 0x3e, "command1Id": 0x3d, "command2Id": 0x37, },
58: { "targetId": 0x3e, "command1Id": 0x3d, "command2Id": 0x46, },
59: { "targetId": 0x3e, "command1Id": 0x3d, "command2Id": 0x49, },
60: { "targetId": 0x3e, "command1Id": 0x46, "command2Id": 0x0c, },
61: { "targetId": 0x3e, "command1Id": 0x49, "command2Id": 0x0c, },
62: { "targetId": 0x3e, "command1Id": 0x4a, "command2Id": 0x0c, },
63: { "targetId": 0x3f, "command1Id": 0x0c, "command2Id": 0x19, },
64: { "targetId": 0x3f, "command1Id": 0x0c, "command2Id": 0x21, },
65: { "targetId": 0x3f, "command1Id": 0x3e, "command2Id": 0x24, },
66: { "targetId": 0x3f, "command1Id": 0x4b, "command2Id": 0x24, },
67: { "targetId": 0x3f, "command1Id": 0x57, "command2Id": 0x24, },
68: { "targetId": 0x41, "command1Id": 0x40, "command2Id": 0x0d, },
69: { "targetId": 0x41, "command1Id": 0x46, "command2Id": 0x0d, },
70: { "targetId": 0x41, "command1Id": 0x49, "command2Id": 0x0d, },
71: { "targetId": 0x41, "command1Id": 0x4a, "command2Id": 0x0d, },
72: { "targetId": 0x42, "command1Id": 0x21, "command2Id": 0x46, },
73: { "targetId": 0x42, "command1Id": 0x21, "command2Id": 0x49, },
74: { "targetId": 0x42, "command1Id": 0x41, "command2Id": 0x25, },
75: { "targetId": 0x42, "command1Id": 0x4b, "command2Id": 0x25, },
76: { "targetId": 0x42, "command1Id": 0x57, "command2Id": 0x25, },
77: { "targetId": 0x44, "command1Id": 0x27, "command2Id": 0x43, },
78: { "targetId": 0x44, "command1Id": 0x46, "command2Id": 0x43, },
79: { "targetId": 0x44, "command1Id": 0x49, "command2Id": 0x43, },
80: { "targetId": 0x44, "command1Id": 0x4a, "command2Id": 0x43, },
81: { "targetId": 0x45, "command1Id": 0x48, "command2Id": 0x44, },
82: { "targetId": 0x45, "command1Id": 0x4b, "command2Id": 0x44, },
83: { "targetId": 0x45, "command1Id": 0x57, "command2Id": 0x44, },
84: { "targetId": 0x49, "command1Id": 0x01, "command2Id": 0x46, },
85: { "targetId": 0x49, "command1Id": 0x04, "command2Id": 0x46, },
86: { "targetId": 0x4c, "command1Id": 0x2e, "command2Id": 0x31, },
87: { "targetId": 0x4c, "command1Id": 0x38, "command2Id": 0x4e, },
88: { "targetId": 0x4c, "command1Id": 0x39, "command2Id": 0x26, },
89: { "targetId": 0x4c, "command1Id": 0x39, "command2Id": 0x4e, },
90: { "targetId": 0x4d, "command1Id": 0x2a, "command2Id": 0x39, },
91: { "targetId": 0x4d, "command1Id": 0x2f, "command2Id": 0x31, },
92: { "targetId": 0x4d, "command1Id": 0x39, "command2Id": 0x4c, },
93: { "targetId": 0x4d, "command1Id": 0x4e, "command2Id": 0x39, },
94: { "targetId": 0x4e, "command1Id": 0x30, "command2Id": 0x31, },
95: { "targetId": 0x4e, "command1Id": 0x38, "command2Id": 0x16, },
96: { "targetId": 0x4e, "command1Id": 0x38, "command2Id": 0x4d, },
97: { "targetId": 0x4e, "command1Id": 0x39, "command2Id": 0x4d, },
98: { "targetId": 0x4f, "command1Id": 0x17, "command2Id": 0x3c, },
99: { "targetId": 0x4f, "command1Id": 0x2f, "command2Id": 0x2e, },
100: { "targetId": 0x4f, "command1Id": 0x3c, "command2Id": 0x50, },
101: { "targetId": 0x4f, "command1Id": 0x51, "command2Id": 0x3c, },
102: { "targetId": 0x50, "command1Id": 0x30, "command2Id": 0x2e, },
103: { "targetId": 0x50, "command1Id": 0x3c, "command2Id": 0x51, },
104: { "targetId": 0x50, "command1Id": 0x53, "command2Id": 0x3c, },
105: { "targetId": 0x50, "command1Id": 0x54, "command2Id": 0x3c, },
106: { "targetId": 0x51, "command1Id": 0x30, "command2Id": 0x2f, },
107: { "targetId": 0x51, "command1Id": 0x3b, "command2Id": 0x2f, },
108: { "targetId": 0x51, "command1Id": 0x3c, "command2Id": 0x30, },
109: { "targetId": 0x51, "command1Id": 0x4f, "command2Id": 0x50, },
110: { "targetId": 0x52, "command1Id": 0x3e, "command2Id": 0x53, },
111: { "targetId": 0x52, "command1Id": 0x3f, "command2Id": 0x14, },
112: { "targetId": 0x52, "command1Id": 0x3f, "command2Id": 0x39, },
113: { "targetId": 0x52, "command1Id": 0x3f, "command2Id": 0x53, },
114: { "targetId": 0x53, "command1Id": 0x20, "command2Id": 0x3f, },
115: { "targetId": 0x53, "command1Id": 0x3e, "command2Id": 0x3f, },
116: { "targetId": 0x53, "command1Id": 0x3f, "command2Id": 0x42, },
117: { "targetId": 0x53, "command1Id": 0x3f, "command2Id": 0x52, },
118: { "targetId": 0x54, "command1Id": 0x39, "command2Id": 0x48, },
119: { "targetId": 0x54, "command1Id": 0x41, "command2Id": 0x11, },
120: { "targetId": 0x54, "command1Id": 0x41, "command2Id": 0x55, },
121: { "targetId": 0x54, "command1Id": 0x42, "command2Id": 0x55, },
122: { "targetId": 0x54, "command1Id": 0x45, "command2Id": 0x39, },
123: { "targetId": 0x55, "command1Id": 0x42, "command2Id": 0x39, },
124: { "targetId": 0x55, "command1Id": 0x54, "command2Id": 0x42, },
125: { "targetId": 0x55, "command1Id": 0x57, "command2Id": 0x42, },
126: { "targetId": 0x56, "command1Id": 0x44, "command2Id": 0x45, },
127: { "targetId": 0x56, "command1Id": 0x45, "command2Id": 0x3c, },
128: { "targetId": 0x56, "command1Id": 0x4a, "command2Id": 0x45, },
129: { "targetId": 0x56, "command1Id": 0x55, "command2Id": 0x45, },
130: { "targetId": 0x58, "command1Id": 0x4f, "command2Id": 0x3f, },
131: { "targetId": 0x59, "command1Id": 0x4f, "command2Id": 0x56, },
132: { "targetId": 0x5a, "command1Id": 0x50, "command2Id": 0x3f, },
133: { "targetId": 0x5b, "command1Id": 0x55, "command2Id": 0x53, },
134: { "targetId": 0x5c, "command1Id": 0x32, "command2Id": 0x5b, },
}

function GetConversionCombosByTargetId(targetId)
{
    combos = []
    
    for i in conversionCombinations
    {
        combo = conversionCombinations[i]
        if (combo["targetId"] == targetId)
        {
            array_push(combos, combo)
        }
    }
    
    return combos
}

function GetCommandByName(commandName)
{
    return GetCommandByProperty("name", commandName)
}

function GetCommandByProperty(propertyName, propertyValue)
{
    for id in commands
    {
        command = commands[id]
        if (command[propertyName] == propertyValue)
        {
            return command
        }
    }
}

function GetCommandsByProperty(propertyName, propertyValue)
{
    batches = GetCommandBatchesByProperty(propertyName, propertyValue, 0)
    return batches[0]
}

function GetCommandBatchesByProperty(propertyName, propertyValue, batchSize)
{
    retCommandBatches = []
    currentBatch = []
    for id in commands
    {
        command = commands[id]
        if (command[propertyName] == propertyValue)
        {
            array_push(currentBatch, command)
        }
        
        if (length(currentBatch) >= batchSize && batchSize != 0)
        {
            array_push(retCommandBatches, currentBatch)
            currentBatch = []
        }
    }
    
    if (length(currentBatch) > 0)
    {
        array_push(retCommandBatches, currentBatch)
    }
    
    return retCommandBatches
}

// Returns the ID of the command in a given subslot. A subslot is one of the two slots in a command group.
// Group 1 has subslots 0 and 1, Group 2 has subslots 2 and 3, and so on.
function commandBaseAddr() => 0x05ffc8
function installedInventoryBaseAddr() => 0x19881c
function GetCommandIdBySubslotId(subslotId)
{
    return byte(commandBaseAddr() + subslotId * 12 + 11)
}

// Normally, this holds indices to the command that's installed, but if it's an item, an ID is used.
// As such, this function is primarily used to see if a player has a particular item command installed.
function GetInstalledItemIdByCommandGroupId(groupId)
{
    return byte(installedInventoryBaseAddr() + groupId * 4)
}

function IsCommandInstalledInSubslot(subslotId)
{
    return bit1(commandBaseAddr() + subslotId * 12) == 1
}

function HasAnyCommandsEquipped()
{
    commandInstalled = always_false()
    for i in range(0, 7) // One loop per command group
    {
        commandInstalled = commandInstalled || IsCommandInstalledInSubslot(2 * i)
    }
    return commandInstalled
}

function NamedCommandIsInstalledInGivenGroup(namedCommand, groupId)
{
    slotAId = GetCommandIdBySubslotId(groupId * 2)
    slotAInstalled = IsCommandInstalledInSubslot(groupId * 2)
    
    // We only care about Subslot A, as that is what determines what the final command is if it's not a command conversion.
    return slotAInstalled && slotAId == namedCommand["id"]
}

function HasCommandEquipped(commandName)
{
    rawCommandInstalled = always_false()
    commandConversionInstalled = always_false()
    namedCommand = GetCommandByName(commandName)
    
    for i in range(0, 7) // One loop per command group
    {
        slotAId = GetCommandIdBySubslotId(i * 2)
        slotAInstalled = IsCommandInstalledInSubslot(i * 2)
        slotBId = GetCommandIdBySubslotId(i * 2 + 1)
        slotBInstalled = IsCommandInstalledInSubslot(i * 2 + 1)
        
        // We only care about Subslot A, as that is what determines what the final command is if it's not a command conversion.
        namedCommandIsInstalledInThisGroup = NamedCommandIsInstalledInGivenGroup(namedCommand, i)
        namedCommandIsInstalledInThisGroupViaConversion
            = SubslotCombinationResultsInGivenCommandConversion(slotAId, slotAInstalled, slotBId, slotBInstalled, namedCommand)
        rawCommandInstalled = rawCommandInstalled || namedCommandIsInstalledInThisGroup
        commandConversionInstalled = commandConversionInstalled || namedCommandIsInstalledInThisGroupViaConversion
    }
    
    return rawCommandInstalled || commandConversionInstalled
}

function HasAnyCommandEquippedInAnySubslotB()
{
    trigger = always_false()
    for i in range(0, 7) // One loop per command group
    {
        slotBInstalled = IsCommandInstalledInSubslot(i * 2 + 1)
        
        trigger = trigger || slotBInstalled
    }
    
    return trigger
}

function HasAnyGivenCommandsEquipped(namedCommands)
{
    trigger = always_false()
    for command in namedCommands
    {
        trigger = trigger || HasCommandEquipped(command["name"])
    }
    
    return trigger
}

function HasGivenRawCommandsEquipped(namedCommands)
{
    trigger = always_false()
    for command in namedCommands
    {
        for i in range(0, 7) // One loop per command group
        {
            trigger = trigger || NamedCommandIsInstalledInGivenGroup(command, i)
        }
    }
    
    return trigger
}

function SubslotCombinationResultsInGivenCommandConversion(slotAId, slotAInstalled, slotBId, slotBInstalled, command)
{
    combos = GetConversionCombosByTargetId(command["id"])
    trigger = always_false()
    
    for combo in combos
    {
        trigger = trigger || slotAId == combo["command1Id"] && slotBId == combo["command2Id"] && slotAInstalled && slotBInstalled
        trigger = trigger || slotAId == combo["command2Id"] && slotBId == combo["command1Id"] && slotAInstalled && slotBInstalled
    }
    
    return trigger
}

function NumberOfHealingItemCommandsEquipped()
{
    conditions = []
    for i in range(0, 7) // One loop per command group
    {
        itemId = GetInstalledItemIdByCommandGroupId(i)
        array_push(conditions, once(itemId == 0x80 || itemId == 0x81 || itemId == 0x85 || itemId == 0x86))
    }
    
    return conditions
}

// ============================== /COMMANDS ============================== //

function mapTutorial() => bit6(0x195c85)
achievement(title = "The Arguments You Have Presented Seem Believable", description = "Receive your first instructions from King Mickey on the Destiny Islands.",
    points = 1,
    trigger = WasBitflagSetInGame(mapTutorial()) // Technically triggers after viewing the map tutorial, but the player doesn't need to know that... >.>
)

function destinyIslandsStoryEntry() => bit4(0x195bda)
achievement(title = "Typecastaway", description = "Complete the Destiny Islands.",
    points = 3,
    trigger = WasBitflagSetInGame(destinyIslandsStoryEntry())
)

function traverseTownStoryEntry() => bit3(0x195bda)
achievement(title = "Town Watch", description = "Complete Traverse Town.",
    points = 3,
    trigger = WasBitflagSetInGame(traverseTownStoryEntry())
)

function wonderlandStoryEntry() => bit2(0x195bda)
achievement(title = "Released Candidate", description = "Complete Wonderland.",
    points = 3,
    trigger = WasBitflagSetInGame(wonderlandStoryEntry())
)

function olympusColiseumStoryEntry() => bit1(0x195bda)
achievement(title = "Race Condition", description = "Complete Olympus Coliseum.",
    points = 3,
    trigger = WasBitflagSetInGame(olympusColiseumStoryEntry())
)

function agrabahStoryEntry() => bit0(0x195bda)
achievement(title = "Key Cracking", description = "Complete Agrabah.",
    points = 3,
    trigger = WasBitflagSetInGame(agrabahStoryEntry())
)

function dialoguePtr() => tbyte(0x0c9f38)
function currentCharInDialoguePtr() => tbyte(dialoguePtr())
function currentChar() => word(currentCharInDialoguePtr())

function CharToInt(char)
{
    // Not including every ASCII character because this function is probably only being used once, and only the following characters are used.
    chars = {
        ".": 0x2e,
        "W": 0x57,
        "a": 0x61,
        "h": 0x68,
        "j": 0x6a,
        "s": 0x73,
        "t": 0x74,
        "u": 0x75,
    }
    
    return chars[char]
}

function TextIsDisplayed(charArray)
{
    trigger = always_true()
    
    for char in charArray
    {
        trigger = trigger && once(currentChar() == CharToInt(char))
    }
    
    return once(trigger)
}

function hollowBastionPt1StoryEntry() => bit7(0x195bd9)
achievement(title = "My Friends Are My Power, I Guess", description = "Reclaim your Keyblade.",
    points = 1,
    trigger = never((dialoguePtr() == 0 || currentCharInDialoguePtr() == 0) && IsInLocation("HollowBastionGrandHall"))
        && hollowBastionPt1StoryEntry() == 0 // We neither need nor want players to earn this achievement on subsequent visits to this world.
        && (once(IsInLocation("HollowBastionGrandHall") && TextIsDisplayed(["W", "h", "a", "t", ".", ".", ".", "j", "u", "s", "t", ".", ".", "."])) // If specific dialogue is encountered, sans skipping.
            // Failsafe condition; merely check to see if you're entering the Keyhole.
            || WasInLocation("HollowBastionGrandHall") && IsInLocation("HollowBastionKeyholeEntrance"))
            
)

function hollowBastionStoryEntry() => bit7(0x195bd9)
achievement(title = "Endless QA", description = "Complete Hollow Bastion, Part I.",
    points = 3,
    trigger = WasBitflagSetInGame(hollowBastionStoryEntry())
)

function hollowBastionIIStoryEntry() => bit6(0x195bd9)
achievement(title = "Escape Sequence", description = "Complete Hollow Bastion, Part II.",
    points = 3,
    trigger = WasBitflagSetInGame(hollowBastionIIStoryEntry())
)

function dodgeRollActive() => bit0(0x1986f0)
achievement(title = "Smooth Operator", description = "Defeat the Darkside without the Dodge Roll ability equipped (Critical Mode; Level 2 or below).",
    points = 5,
    trigger = IsAtLeastOnDifficulty("Critical") && dodgeRollActive() == 0 && JustDefeatedEnemy("Darkside") && Level() <= 2
)

achievement(title = "I Am the New God", description = "Earn a Star rank against the Darkside (Proud Mode or higher; Level 5 or below).",
    points = 10,
    trigger = IsAtLeastOnDifficulty("Proud") && Level() <= 5 && never(!IsInLocation("DestinyStorm")) && BossScoreIsDisplayedAndAtLeast(40000)
)

soraSidescrollStateOffset = 0x2d32
function soraSidescrollingState() => byte(minigameStatePointer() + soraSidescrollStateOffset)
function JustFellOrGotCaughtInSidescrollingStages() => soraSidescrollingState() == 0x6 && Delta(soraSidescrollingState()) != soraSidescrollingState()
function IsAlwaysInTraverseTownKeyhole() => never(!IsInLocation("TraverseKeyholeFirst") && !IsInLocation("TraverseKeyholeSecond")
        && !IsInLocation("TraverseKeyholeThird") && !IsInLocation("TraverseKeyholeFall") && !IsInLocation("TraverseKeyholeTerminus"))
achievement(title = "Saved a Framerule", points = 25,
    description = "Complete the Traverse Town Keyhole without falling into pits, getting caught behind blox, or dying (Critical Mode; Level 7 or below).",
    trigger = IsAtLeastOnDifficulty("Critical") && Level() <= 7 && IsAlwaysInTraverseTownKeyhole()
        && once(KeyholeCheckpointPassed() && !IsMinigameActive() && IsInLocation("TraverseKeyholeFirst"))
        && never(hp() <= 0) && JustDefeatedEnemy("Guard Armor") && never(JustFellOrGotCaughtInSidescrollingStages())
)

minigameMiscPointerAddr = 0x0a04c4
function minigameMiscHalfPointer() => word(minigameMiscPointerAddr)

fireLungeUsesNegativeOffset = 0x9f6
function fireLungeUsesLeft() => byte(GetAddressWithNegativeOffset(minigameMiscHalfPointer(), 0x230000, fireLungeUsesNegativeOffset))

thunderRainUsesNegativeOffset = 0x9ba
function thunderRainUsesLeft() => byte(GetAddressWithNegativeOffset(minigameMiscHalfPointer(), 0x230000, thunderRainUsesNegativeOffset))

blizzardDartUsesNegativeOffset = 0x97e
function blizzardDartUsesLeft() => byte(GetAddressWithNegativeOffset(minigameMiscHalfPointer(), 0x230000, blizzardDartUsesNegativeOffset))

windSpinUsesNegativeOffset = 0x942
function windSpinDartUsesLeft() => byte(GetAddressWithNegativeOffset(minigameMiscHalfPointer(), 0x230000, windSpinUsesNegativeOffset))

function UsedOverlayCommand(addr) => once(Delta(addr) == addr + 1)
achievement(title = "Dedicated Specialist", points = 5,
    description = "Complete the Traverse Town Keyhole using at most one type of overlay command.",
    trigger = IsAlwaysInTraverseTownKeyhole() && unless(IsInLocation("TraverseKeyholeFall"))
        && once(KeyholeCheckpointPassed() && !IsMinigameActive() && IsInLocation("TraverseKeyholeFirst"))
        && JustDefeatedEnemy("Guard Armor")
        && never(tally(2, [ UsedOverlayCommand(fireLungeUsesLeft()), UsedOverlayCommand(thunderRainUsesLeft()), UsedOverlayCommand(blizzardDartUsesLeft()),
            UsedOverlayCommand(windSpinDartUsesLeft()) ]))
)

achievement(title = "Our Princess of Heart Is in Another World", description = "Earn a Star rank against the Guard Armor (Proud Mode or higher; Level 9 or below).",
    points = 10,
    trigger = IsAtLeastOnDifficulty("Proud") && Level() <= 9 && never(!IsInLocation("TraverseKeyholeTerminus")) && BossScoreIsDisplayedAndAtLeast(30000)
)

// The current save protection algorithm won't work here because the bits appear to be loaded after all the other save's data is loaded.
// This will be on the cutting room floor until I update the save protection to accommodate it, which...honestly, it may be more trouble than it's worth.
if (1 == 0)
{
    i = -1
    baseInklingAddr1 = 0x19c512
    baseInklingAddr2 = 0x19c513
    inklingConditions = { }

    for j in range(0, 7)
    {
        bit1 = bit(j, baseInklingAddr1)
        bit2 = bit(j, baseInklingAddr2)
    
        i = i + 1
        inklingConditions[i] = { "countsWhen": (bit1 == 1), "recalculateWhen": (Delta(bit1) != bit1) }
    
        i = i + 1
        inklingConditions[i] = { "countsWhen": (bit2 == 1), "recalculateWhen": (Delta(bit2) != bit2) }
    }

    GenerateSaveProtectedAchievementFromConditions({
        "name": "Forget-Me-Never (backtrack?)",
        "description": "Find all the Inklings in Wonderland.",
        "points": 5,
        "threshold": 16
    }, inklingConditions, IsInWorld("Wonderland"))
}

// TODO: We're duplicating the WonderlandKeyholeTerminus check to work around a "Combination of &&s and ||s is too complex" error.
// This can be simplified after this is fixed.
function IsAlwaysInWonderlandKeyhole() => never(!IsInLocation("WonderlandKeyholeFirst") && !IsInLocation("WonderlandKeyholeSecond")
        && !IsInLocation("WonderlandKeyholeTerminus") && !IsInLocation("WonderlandKeyholeTerminus") && !IsInLocation("WonderlandKeyholeTerminus"))
achievement(title = "Avoided the Guillotine", points = 25,
    description = "Complete the Wonderland Keyhole on Critical Mode without dying or getting hit more than twelve times.",
    trigger = IsAtLeastOnDifficulty("Critical") && IsAlwaysInWonderlandKeyhole()
        && once(KeyholeCheckpointPassed() && IsInLocation("WonderlandKeyholeFirst"))
        && never(hp() <= 0) && never(repeated(12, PlayerIsHit())) && JustDefeatedEnemy("Trickmaster")
)

achievement(title = "Guilt and Penalty", points = 10,
    description = "Complete the Wonderland Keyhole with a score of 22000 or more (Proud Mode or higher; Level 15 or below).",
    trigger = IsAtLeastOnDifficulty("Proud") && Level() <= 15 && never(!IsInLocation("WonderlandKeyholeTerminus")) && BossScoreIsDisplayedAndAtLeast(22000)
)

achievement(title = "Astral Heir", points = 25,
    description = "Earn a Star rank in the Wonderland Keyhole (Proud Mode or higher; Level 15 or below).",
    trigger = IsAtLeastOnDifficulty("Proud") && Level() <= 15 && never(!IsInLocation("WonderlandKeyholeTerminus")) && BossScoreIsDisplayedAndAtLeast(45000)
)

function turnBasedBattlePtr() => tbyte(0x1a47c4)
function IsInTurnBasedBattle() => turnBasedBattlePtr() != 0x0 && IsInWorld("Olympus Coliseum")
function OlympusColiseumKeyholeCheckpoint() => Delta(turnBasedBattlePtr()) == 0x0 && turnBasedBattlePtr() != 0x0 && IsInWorld("Olympus Coliseum")
function licenseBaseAddr() => 0x0608e0
function ConsumedALicenseAtAddr(idAddr)
{
    return Delta(byte(idAddr + 4)) > byte(idAddr + 4)
}

function ConsumedALicense()
{
    consumedLicense = always_false()
    for i in range(0, 7) // Eight licenses total
    {
        consumedLicense = consumedLicense || ConsumedALicenseAtAddr(licenseBaseAddr() + i * 12) // License data appears to be twelve bytes in width.
    }
    return consumedLicense
}

function ConsumedALicenseOfType(type)
{
    consumedLicense = always_false()
    for i in range(0, 7) // Eight licenses total
    {
        licenseAddr = licenseBaseAddr() + i * 12
        consumedLicense = consumedLicense || ConsumedALicenseAtAddr(licenseAddr) // License data appears to be twelve bytes in width.
            && byte(licenseAddr) == type
    }
    return consumedLicense
}

achievement(title = "Lethal Force Authorized", points = 5,
    description = "Defeat both Cerberus and Hades without using any more than five licenses total between them (Proud Mode or higher; Level 20 or below.).",
    trigger = IsAtLeastOnDifficulty("Proud") && Level() <= 20
        && once(OlympusColiseumKeyholeCheckpoint())
        // A pauselock is used to ensure the checkpoint doesn't get re-established if the player uses too many licenses in the Cerberus fight.
        && unless(repeated(6, ConsumedALicense() && turnBasedBattlePtr() != 0x0))
        && (never(!IsInLocation("OlympusLayer5")) && always_false() // This is to reset the pauselock while also allowing us to create alts for Hades' defeat.
            || JustDefeatedEnemy("Hades"))
)

// TODO: Like Wonderland above, we're duplicating the OlympusLayer15 check to work around a "Combination of &&s and ||s is too complex" error.
// This can be simplified after this RATools bug is fixed.
achievement(title = "There Is No Escape", points = 5,
    description = "Earn a Star rank in the Olympus Coliseum Keyhole (Critical Mode; Level 20 or below).",
    trigger = IsAtLeastOnDifficulty("Critical") &&  BossScoreIsDisplayedAndAtLeast(30000)
        && never(!IsInLocation("OlympusLayer5") && !IsInLocation("OlympusLayer15") && !IsInLocation("OlympusLayer30")
         && !IsInLocation("OlympusLayer15") && !IsInLocation("OlympusLayer15"))
         && (Level() <= 20 || always_false()) // Trick RATools into generating the correct code by forcing use of OrNext.
)

achievement(title = "Martial Technique", points = 10,
    description = "Defeat the Rock Titan using neither Auto-Block-L nor Timing-L licenses (Critical Mode; Level 25 or below).",
    trigger = IsAtLeastOnDifficulty("Critical") && Level() <= 25
        && once(OlympusColiseumKeyholeCheckpoint()) && never(!IsInTurnBasedBattle())
        && JustDefeatedEnemy("Rock Titan") && never(ConsumedALicenseOfType(0xd7)) && never(ConsumedALicenseOfType(0xd8))
)

achievement(title = "Monster Hunter", points = 5,
    description = "Defeat the Behemoth without using the Reload-L license (Critical Mode; Level 37 or below)",
    trigger = IsAtLeastOnDifficulty("Critical") && Level() <= 37
        && once(OlympusColiseumKeyholeCheckpoint()) && never(!IsInTurnBasedBattle())
        && JustDefeatedEnemy("Behemoth") && never(ConsumedALicenseOfType(0xd4))
)

function cloudIsInParty() => bit6(0x19c513)
achievement(title = "Teamwork? Not Interested", points = 10,
    description = "Defeat the Ice Titan without Cloud in your party (Critical Mode; Level 40 or below)",
    trigger = IsAtLeastOnDifficulty("Critical") && Level() <= 40
        && once(OlympusColiseumKeyholeCheckpoint()) && never(!IsInTurnBasedBattle())
        && JustDefeatedEnemy("Ice Titan") && cloudIsInParty() == 0
)

// Putting this on the cutting room floor for now; their implementation for calculating time is a bit too complex for me to want to write code around for now.
// Plus, the achievement probably isn't that particularly challenging anyway, since you just get booted back to the entrance of the current room if you run out of time
// with all of your time put back into the pool.
if (1 == 0)
{
    function agrabahTimeElapsedInRoom() => dword(0x1efc8c)
    function agrabahTimeLimitInRoom() => dword(0x19ee18)
    achievement(title = "No Need for an Hourglass", points = 3,
        description = "Reclaim the magic lamp from Iago before time runs out the first time and without collecting any time prizes.",
        trigger = once(WasInLocation("AgrabahPlaza") && IsInLocation("AgrabahPlazaFrozen")) && IsInLocation("AgrabahCaveEntrance")
            && never(agrabahTimeElapsedInRoom() >= agrabahTimeLimitInRoom())
    ) 
}

achievement(title = "Mano-a-Many", points = 3,
    description = "Defeat Jafar in the Lamp Chamber without defeating any other enemy (Critical Mode; Level 20 or below).",
    trigger = never(JustDefeatedEnemy("Blox Bug")) && never(!IsInLocation("AgrabahLamp")) && Level() <= 20 && IsAtLeastOnDifficulty("Critical")
        && (once(WasInLocation("AgrabahGauntlet") && IsInLocation("AgrabahLamp")) && JustDefeatedEnemy("Jafar") // Initial entry into the room
            || once(Delta(hp()) == 0 && hp() == maxHP()) && JustDefeatedEnemy("Jafar")) // Cover a game over situation
)

eternityCharmId = 0x12d
achievement(title = "Keyblade Beats Rock", points = 25,
    description = "Defeat Jafar's genie form with 50 max HP or less and without Second Chance active (Critical Mode; Level 20 or below).",
    trigger = IsAtLeastOnDifficulty("Critical") && JustDefeatedEnemy("Jafar (Genie)")
        && never(!IsInLocation("AgrabahKeyholeTerminus")) && Level() <= 20 && maxHP() <= 50
        && !HasAccessoryEquipped(eternityCharmId)
)

achievement(title = "Exceptional Astronomical Abilities", points = 5,
    description = "Earn a Star rank in the Agrabah Keyhole (Proud Mode or higher; Level 20 or below).",
    trigger = IsAtLeastOnDifficulty("Proud") &&  BossScoreIsDisplayedAndAtLeast(35000)
        && never(!IsInLocation("AgrabahKeyholeTerminus")) && Level() <= 20
)

achievement(title = "Sour Stomach", points = 10,
    description = "Defeat Pete in Hollow Bastion without the Dodge Roll ability active (Critical Mode; Level 22 or below).",
    trigger = dodgeRollActive() == 0 && IsAtLeastOnDifficulty("Critical") && Level() <= 22 && JustDefeatedEnemy("Pete")
        && never(!IsInLocation("HollowBastionKeyholeChapel"))
)

curativeCommands = GetCommandsByProperty("category", "Curative")
achievement(title = "Waste Not, Want Not", points = 10,
    description = "Defeat Data-Riku in Hollow Bastion equipping only a single HP-restoring item command as your primary source of healing (Critical Mode; Level 22 or below).",
    trigger = Level() <= 22 && IsAtLeastOnDifficulty("Critical") && JustDefeatedEnemy("Data-Riku")
        && never(HasAnyGivenCommandsEquipped(curativeCommands))
        && never(tally(2, NumberOfHealingItemCommandsEquipped())) && never(!IsInLocation("HollowBastionKeyholeChapel"))
)

achievement(title = "Speed Deletion", points = 10,
    description = "Complete the Hollow Bastion Keyhole with a score of 23000 or more (Proud Mode or higher; Level 22 or below).",
    trigger = IsAtLeastOnDifficulty("Proud") && Level() <= 22 && never(!IsInLocation("HollowBastionKeyholeChapel")) && BossScoreIsDisplayedAndAtLeast(23000)
)

achievement(title = "Speed Shredding", points = 25,
    description = "Earn a Star rank in the Hollow Bastion Keyhole (Proud Mode or higher; Level 22 or below).",
    trigger = IsAtLeastOnDifficulty("Proud") && Level() <= 22 && never(!IsInLocation("HollowBastionKeyholeChapel")) && BossScoreIsDisplayedAndAtLeast(40000)
)

achievement(title = "Graceful Degradation", points = 10,
    description = "Defeat the Data-Riku inside Riku's data without equipping any commands (Critical Mode; Level 25 or below).",
    trigger = Level() <= 25 && IsAtLeastOnDifficulty("Critical") && JustDefeatedEnemy("Data-Riku")
        && never(HasAnyCommandsEquipped()) && never(!IsInLocation("HollowBastionChapelRiku"))
)

function HighJumpEquipped() => bit4(0x1986f0) == 1
function AirSlideEquipped() => bit7(0x1986f0) == 1 || bit0(0x1986f2) == 1 || bit1(0x1986f2) == 1
function GlideEquipped() => bit7(0x1986f2) == 1
achievement(title = "Resistance Training", points = 5,
    description = "Reach the Dragon's Lair with either High Jump, Air Slide, Glide, or none of the above equipped.",
    trigger = IsInLocation("HollowBastionDragon") && WasInLocation("HollowBastionEscapeRiku") && never(!IsInLocation("HollowBastionDragon")) &&
        never(tally(2, [ once(HighJumpEquipped()), once(AirSlideEquipped()), once(GlideEquipped()) ]))
)

achievement(title = "Grounded Mortal", points = 10,
    description = "Defeat Dragon Maleficent without High Jump, Air Slide, or Glide equipped (Critical Mode; Level 27 or below).",
    trigger = IsInLocation("HollowBastionDragon") && JustDefeatedEnemy("Dragon") && Level() <= 27 && IsAtLeastOnDifficulty("Critical")
        && never(HighJumpEquipped() || AirSlideEquipped() || GlideEquipped())
)

achievement(title = "Flame Damping", points = 5,
    description = "Get a score of 32000 or more during the escape from inside Riku's data (Proud Mode or higher; Level 27 or below).",
    trigger = IsAtLeastOnDifficulty("Proud") && Level() <= 27 && never(!IsInLocation("HollowBastionDragon")) && BossScoreIsDisplayedAndAtLeast(32000)
)

achievement(title = "Draconic Rage", points = 10,
    description = "Earn a Star rank escaping from inside Riku's data (Proud Mode or higher; Level 27 or below).",
    trigger = IsAtLeastOnDifficulty("Proud") && Level() <= 27 && never(!IsInLocation("HollowBastionDragon")) && BossScoreIsDisplayedAndAtLeast(50000)
)

achievement(title = "Underclocking", points = 10,
    description = "Defeat Sora's Heartless (Darkside form) at Level 1 on Standard Mode or higher.",
    trigger = IsAtLeastOnDifficulty("Standard") && Level() <= 1 && never(!IsInLocation("HollowBastionCentralCorruption"))
        && once(IsInLocation("HollowBastionCentralCorruption") && WasInLocation("HollowBastionDataTunnel")) // Battle checkpoint
        && JustDefeatedEnemy("Sora’s Heartless")
        && (always_false()
            || never(Level() > 1) && never(IsOnBeginnerMode()) && unless(IsInMenu()))
)

rangedCommands = GetCommandsByProperty("category", "Ranged")
achievement(title = "Dark Embrace", points = 25,
    description = "Defeat Sora's Heartless without equipping any ranged commands and with only one command per group (Critical Mode; Level 30 or below).",
    trigger = IsAtLeastOnDifficulty("Critical") && Level() <= 30 && never(!IsInLocation("HollowBastionCentralCorruption"))
        && once(WasInLocation("HollowBastionDataTunnel") && IsInLocation("HollowBastionCentralCorruption"))
        && never(HasAnyCommandEquippedInAnySubslotB()) && never(HasGivenRawCommandsEquipped(rangedCommands)) && unless(IsInMenu())
        // We can't check to see if we actually defeated Sora's humanoid Heartless because the game counts winning the first phase of that fight
        // and not the last. Instead, we need to check to see if the player actually completed all the fights--meaning we need to see if the score is displayed.
        && IsTotalScoreJustDisplayedForAchievement()
)

achievement(title = "Shallow Copy", points = 25,
    description = "Defeat Sora's Heartless with a score of 30000 or more (Proud Mode or higher; Level 30 or below).",
    trigger = IsAtLeastOnDifficulty("Proud") && Level() <= 30 && never(!IsInLocation("HollowBastionCentralCorruption")) && BossScoreIsDisplayedAndAtLeast(30000)
)

endingCards = [
    bit1(0x195e59), // W6 Extra Card
    bit2(0x195e59), // W6 Alternate Card
    bit3(0x195e59), // W6 Normal Card
    bit4(0x195e59), // W5 Extra Card
    bit5(0x195e59), // W5 Alternate Card
    bit6(0x195e59), // W5 Normal Card
    bit7(0x195e59), // W4 Extra Card
    bit0(0x195e5a), // W4 Alternate Card
    bit1(0x195e5a), // W4 Normal Card
    bit2(0x195e5a), // W3 Extra Card
    bit3(0x195e5a), // W3 Alternate Card
    bit4(0x195e5a), // W3 Normal Card
    bit5(0x195e5a), // W2 Extra Card
    bit6(0x195e5a), // W2 Alternate Card
    bit7(0x195e5a), // W2 Normal Card
    bit0(0x195e5b), // W1 Extra Card
    bit1(0x195e5b), // W1 Alternate Card
    bit2(0x195e5b), // W1 Normal Card
]
endingCardConditions = {}
i = 0
for addr in endingCards
{
    endingCardConditions[i] = { "countsWhen": (addr == 1), "recalculateWhen": (addr != Delta(addr)) }
    i = i + 1
}

GenerateSaveProtectedAchievementFromConditions({
    "name": "Hurt's Last Reward",
    "description": "Obtain all ending cards in Castle Oblivion.",
    "points": 5,
    "threshold": 18
}, endingCardConditions, always_true())

function accessory1() => word(0x198850)
function accessory2() => word(0x198852)
function accessory3() => word(0x198854)
function accessory4() => word(0x198856)

achievement(title = "Bite the Bullet", points = 10,
    description = "Defeat the final boss without any accessories equipped (Critical Mode; Level 35 or below).",
    trigger = IsInLocation("CastleOblivionSorrow") && JustDefeatedEnemy("Data-Roxas") && Level() <= 35 && IsAtLeastOnDifficulty("Critical")
        && accessory1() == 0xffff && accessory2() == 0xffff && accessory3() == 0xffff && accessory4() == 0xffff
)

timeLimit = 210
achievement(title = "Painkiller", points = 5,
    description = "Defeat the final boss within " + SecondsToFormat(timeLimit) + " (Proud Mode or higher; Level 35 or below).",
    trigger = IsAtLeastOnDifficulty("Proud") && Level() <= 35 && never(!IsInLocation("CastleOblivionSorrow")) && BossTimeIsDisplayedAndAtMost(timeLimit * 1000)
)

function extraCommandSlotsUnlocked() => byte(0x198700)
achievement(title = "Commander Sora", points = 5,
    description = "Unlock five extra command slots.",
    trigger = WasValueSetInGame(extraCommandSlotsUnlocked(), 4, 5) && measured(extraCommandSlotsUnlocked() == 5)
)

function extraAccessorySlotsUnlocked() => byte(0x198702)
achievement(title = "Bling, Bling!", points = 5,
    description = "Unlock three extra accessory slots.",
    trigger = WasValueSetInGame(extraAccessorySlotsUnlocked(), 2, 3) && measured(extraAccessorySlotsUnlocked() == 3)
)

function sectorPoints() => dword(0x3de2ac)
achievement(title = "Banco", points = 10,
    description = "Earn a total of 50,000 Sector Points or more from a single wager in a system sector.",
    trigger = IsInSystemSector() && sectorPoints() - Delta(sectorPoints()) >= 50000
        && sectorPoints() > Delta(sectorPoints()) // Ensure integer underflow doesn't happen.
)

achievement(title = "High-Stakes Gambler", points = 50,
    description = "Earn a total of 150,000 Sector Points or more from a single wager in a system sector.",
    trigger = IsInSystemSector() && sectorPoints() - Delta(sectorPoints()) >= 150000
        && sectorPoints() > Delta(sectorPoints()) // Ensure integer underflow doesn't happen.
)

function ultimaWeapon() => bit0(0x19834a)

sectorRewards = [
    bit0(0x198322), bit1(0x198322), bit2(0x198322), bit3(0x198322), bit4(0x198322),
    bit0(0x198328), bit1(0x198328), bit2(0x198328),
    bit0(0x19832a), bit1(0x19832a), bit2(0x19832a),
    bit0(0x19832c), bit1(0x19832c), bit2(0x19832c),
    bit0(0x19832e), bit1(0x19832e), bit2(0x19832e),
    bit0(0x198334), bit1(0x198334), bit2(0x198334), bit3(0x198334), bit4(0x198334),
    bit0(0x198336), bit1(0x198336), bit2(0x198336), bit3(0x198336),
    bit0(0x198338), bit1(0x198338), bit2(0x198338), bit3(0x198338), bit4(0x198338),
    bit0(0x198324), bit1(0x198324), bit2(0x198324), bit3(0x198324), bit4(0x198324), bit5(0x198324),
    bit0(0x198330), bit1(0x198330), bit2(0x198330), bit3(0x198330), bit4(0x198330), bit5(0x198330),
    bit0(0x198332), bit1(0x198332), bit2(0x198332), bit3(0x198332), bit4(0x198332),
    bit0(0x19833a), bit1(0x19833a), bit2(0x19833a), bit3(0x19833a), bit4(0x19833a),
    bit0(0x19833e), bit1(0x19833e), bit2(0x19833e), bit3(0x19833e), bit4(0x19833e), bit5(0x19833e),
    bit0(0x198340), bit1(0x198340), bit2(0x198340), bit3(0x198340), bit4(0x198340), bit5(0x198340),
    bit0(0x198342), bit1(0x198342), bit2(0x198342), bit3(0x198342), bit4(0x198342), bit5(0x198342),
    bit0(0x198346), bit1(0x198346), bit2(0x198346), bit3(0x198346),
    bit0(0x198348), bit1(0x198348), bit2(0x198348), bit3(0x198348), bit4(0x198348), bit5(0x198348), bit6(0x198348),
    bit0(0x19833c), bit1(0x19833c), bit2(0x19833c), bit3(0x19833c), bit4(0x19833c),
    bit0(0x198344), bit1(0x198344), bit2(0x198344), bit3(0x198344), bit4(0x198344),
    ultimaWeapon(), bit1(0x19834a), bit6(0x19834a),
    bit0(0x198350), bit1(0x198350), bit2(0x198350), bit3(0x198350), bit4(0x198350), bit5(0x198350),
    bit0(0x198352), bit1(0x198352), bit2(0x198352), bit3(0x198352), bit4(0x198352), bit5(0x198352),
]

// Generate conditions for sector rewards from the above addresses.
sectorRewardsConditions = {}
i = 0
for addr in sectorRewards
{
    sectorRewardsConditions[i] = GenerateConditionFromBitflag(addr)
    i = i + 1
}

GenerateSaveProtectedAchievementFromConditions({
    "name": "Rookie Cryptominer",
    "description": "Redeem 10% of all system sector rewards.",
    "points": 3,
    "threshold": (length(sectorRewards) / 10),
}, sectorRewardsConditions, always_true())

GenerateSaveProtectedAchievementFromConditions({
    "name": "Regular Cryptominer",
    "description": "Redeem 25% of all system sector rewards.",
    "points": 5,
    "threshold": (length(sectorRewards) / 4),
}, sectorRewardsConditions, always_true())

GenerateSaveProtectedAchievementFromConditions({
    "name": "Veteran Cryptominer",
    "description": "Redeem 50% of all system sector rewards.",
    "points": 10,
    "threshold": (length(sectorRewards) / 2),
}, sectorRewardsConditions, always_true())

GenerateSaveProtectedAchievementFromConditions({
    "name": "Legendary Cryptominer",
    "description": "Redeem all system sector rewards.",
    "points": 25,
    "threshold": length(sectorRewards),
}, sectorRewardsConditions, always_true())

achievement(title = "Threadripper", points = 25,
    description = "Obtain Ultima Weapon.",
    trigger = WasBitflagSetInGame(ultimaWeapon())
)

prizeBlox = [
    bit0(0x195b38), bit1(0x195b38), bit2(0x195b38), bit3(0x195b38), bit4(0x195b38), bit5(0x195b38), bit6(0x195b38), bit7(0x195b38), // Wonderland
    bit0(0x195b3f), bit1(0x195b3f), bit2(0x195b3f), bit3(0x195b3f), bit4(0x195b3f), bit5(0x195b3f), bit6(0x195b3f), bit7(0x195b3f), 
    
    bit3(0x195b39), bit5(0x195b39), bit7(0x195b39), // Traverse Town
    bit0(0x195b3a), bit1(0x195b3a), bit2(0x195b3a), bit3(0x195b3a), bit4(0x195b3a), bit6(0x195b3a), bit7(0x195b3a),
    
    bit5(0x195b3b), bit6(0x195b3b), bit7(0x195b3b), // Destiny Islands
    
    bit0(0x195b3d), bit0(0x195b3d), bit0(0x195b3d), bit0(0x195b3d), bit0(0x195b3d), bit0(0x195b3d), bit0(0x195b3d), bit0(0x195b3d), // Olympus Coliseum
    bit0(0x195b3e), bit0(0x195b3e), bit0(0x195b3e), bit0(0x195b3e), bit0(0x195b3e), bit0(0x195b3e), bit0(0x195b3e), bit0(0x195b3e),
    bit1(0x195b3c), bit2(0x195b3c), bit3(0x195b3c), bit4(0x195b3c), bit5(0x195b3c), bit6(0x195b3c), bit7(0x195b3c),

    bit0(0x195b40), bit1(0x195b40), bit2(0x195b40), bit3(0x195b40), bit4(0x195b40), bit5(0x195b40), bit6(0x195b40), bit7(0x195b40), // Hollow Bastion, Part I
    bit0(0x195b41), bit1(0x195b41), bit2(0x195b41), bit3(0x195b41), bit4(0x195b41), bit5(0x195b41), bit6(0x195b41), bit7(0x195b41),
    
    bit0(0x195b42), bit1(0x195b42), bit2(0x195b42), bit3(0x195b42), bit4(0x195b42), bit5(0x195b42), bit6(0x195b42), bit7(0x195b42), // Agrabah
    bit0(0x195b43), bit1(0x195b43), bit2(0x195b43), bit3(0x195b43), bit4(0x195b43), bit5(0x195b43), bit6(0x195b43), bit7(0x195b43),
    
    bit3(0x195b44), bit4(0x195b44), bit6(0x195b44), // Castle Oblivion
    bit0(0x195b45), bit1(0x195b45), bit2(0x195b45), bit3(0x195b45), bit4(0x195b45), bit5(0x195b45), bit6(0x195b45), bit7(0x195b45),
    
    bit0(0x195b46), bit1(0x195b46), bit2(0x195b46), bit3(0x195b46), bit4(0x195b46), bit5(0x195b46), bit6(0x195b46), bit7(0x195b46), // Hollow Bastion, Part II
    bit0(0x195b47), bit1(0x195b47), bit2(0x195b47), bit3(0x195b47), bit4(0x195b47), bit5(0x195b47), bit6(0x195b47), bit7(0x195b47),
]

prizeBloxConditions = {}
i = 0
for j in prizeBlox
{
    prizeBloxConditions[i] = GenerateConditionFromBitflag(j)
    i = i + 1
}

GenerateSaveProtectedAchievementFromConditions({
    "name": "Rare Prize Pickup",
    "description": "Destroy 15 rare prize blox.",
    "points": 3,
    "threshold": 15
}, prizeBloxConditions, always_true())

GenerateSaveProtectedAchievementFromConditions({
    "name": "Rare Prize Hold Up",
    "description": "Destroy 30 rare prize blox.",
    "points": 5,
    "threshold": 30
}, prizeBloxConditions, always_true())

GenerateSaveProtectedAchievementFromConditions({
    "name": "Rare Prize Tally Up",
    "description": "Destroy 60 rare prize blox.",
    "points": 10,
    "threshold": 60
}, prizeBloxConditions, always_true())

function rarePrizeRoundup() => bit5(0x195c78)
GenerateSaveProtectedAchievementFromConditions({
    "name": "Rare Prize Roundup",
    "description": "Destroy all rare prize blox.",
    "points": 25,
    "threshold": 111
}, prizeBloxConditions, always_true())

function lordOfLoot() => bit4(0x195c78)
achievement(title = "Lord of Loot", description = "Collect at least 80% of enemy item drops, and then view the Trophies menu.", points = 25,
    trigger = WasBitflagSetInGame(lordOfLoot())
)

sectorsCompleted = [
    bit0(0x195bcc), bit1(0x195bcc), bit2(0x195bcc), bit3(0x195bcc), bit4(0x195bcc), bit5(0x195bcc), bit6(0x195bcc), bit7(0x195bcc),
    bit0(0x195bcd), bit1(0x195bcd), bit2(0x195bcd), bit3(0x195bcd), bit4(0x195bcd), bit5(0x195bcd), bit6(0x195bcd), bit7(0x195bcd),
    bit0(0x195bd3), bit1(0x195bd3), bit2(0x195bd3), bit3(0x195bd3), bit4(0x195bd3), bit5(0x195bd3), bit6(0x195bd3), bit7(0x195bd3),
    bit7(0x195bd2)
]
sectorsCompletedConditions = {}

i = 0
for j in sectorsCompleted
{
    sectorsCompletedConditions[i] = GenerateConditionFromBitflag(j)
    i = i + 1
}

function sectorSweeper() => bit3(0x195c78)
GenerateSaveProtectedAchievementFromConditions({
    "name": "Sector Sweeper",
    "description": "Complete all system sectors.",
    "points": 10,
    "threshold": length(sectorsCompleted)
}, sectorsCompletedConditions, always_true())

function sultanOfSlot() => bit2(0x195c78)
function chipsInstalled() => byte(0x195c15)
achievement(title = "Serf of Slot", description = "Install chips in 10% of slots in the Stat Matrix.", points = 3,
    trigger = WasValueSetInGame(chipsInstalled(), 19, 20) && measured(chipsInstalled() == 20)
)

achievement(title = "Sheriff of Slot", description = "Install chips in 25% of slots in the Stat Matrix.", points = 5,
    trigger = WasValueSetInGame(chipsInstalled(), 49, 50) && measured(chipsInstalled() == 50)
)

achievement(title = "Sergeant of Slot", description = "Install chips in 50% of slots in the Stat Matrix.", points = 10,
    trigger = WasValueSetInGame(chipsInstalled(), 99, 100) && measured(chipsInstalled() == 100)
)

achievement(title = "Sultan of Slot", description = "Install chips in every slot in the Stat Matrix.", points = 25,
    trigger = WasValueSetInGame(chipsInstalled(), 199, 200) && measured(chipsInstalled() == 200)
)

cheatsUsed = [
    bit0(0x195c16), bit1(0x195c16), bit2(0x195c16), bit3(0x195c16), bit4(0x195c16)
]

cheatsUsedConditions = {}

for j in cheatsUsed
{
    cheatsUsedConditions[i] = GenerateConditionFromBitflag(j)
    i = i + 1
}

function cheater() => bit1(0x195c78)
GenerateSaveProtectedAchievementFromConditions({
    "name": "Cheater",
    "description": "Use every kind of cheat.",
    "points": 3,
    "threshold": length(cheatsUsed)
}, cheatsUsedConditions, always_true())

function championCollector() => bit0(0x195c78)
achievement(title = "Champion Collector", description = "Collect 70% of all abilities, chips, cheats, weapons, and items; and then view the Trophies menu.", points = 10,
    trigger = WasBitflagSetInGame(championCollector())
)

function avatarCollector() => bit7(0x195c7f)
achievement(title = "Avatar Collector (?)", description = "Collect 50% avatar parts.", points = 10,
    trigger = WasBitflagSetInGame(avatarCollector())
)

function avatarSweeper() => bit6(0x195c7f)
achievement(title = "Avatar Sweeper (?)", description = "Complete all 100 floors of the Avatar Sector.", points = 25,
    trigger = WasBitflagSetInGame(avatarSweeper())
)

function icerOfTitans() => bit5(0x195c7f)
achievement(title = "Icer of Titans", description = "Defeat the Ice Titan.", points = 10,
    trigger = once(OlympusColiseumKeyholeCheckpoint()) && never(!IsInTurnBasedBattle()) && JustDefeatedEnemy("Ice Titan")
)

GenerateSaveProtectedAchievementFromConditions({
    "name": "Eliminator's End",
    "description": "Defeat an Eliminator.",
    "points": 10,
    "threshold": 1
}, { 0: GenerateConditionForEnemy(GetEnemyByName("Eliminator")) }, always_true())

GenerateSaveProtectedAchievementFromConditions({
    "name": "Justice for Few",
    "description": "Defeat 10% of all enemy types.",
    "points": 3,
    "threshold": (length(enemies) / 10),
}, enemiesConditions, always_true())

GenerateSaveProtectedAchievementFromConditions({
    "name": "Justice for Some",
    "description": "Defeat 25% of all enemy types.",
    "points": 5,
    "threshold": (length(enemies) / 4)
}, enemiesConditions, always_true())

GenerateSaveProtectedAchievementFromConditions({
    "name": "Justice for Most",
    "description": "Defeat 50% of all enemy types.",
    "points": 10,
    "threshold": (length(enemies) / 2)
}, enemiesConditions, always_true())

function justiceForAll() => bit2(0x195c7f)
GenerateSaveProtectedAchievementFromConditions({
    "name": "Justice for All",
    "description": "Defeat all enemy types.",
    "points": 25,
    "threshold": length(enemies),
}, enemiesConditions, always_true())

function weaponWizard() => bit1(0x195c7f)
achievement(title = "Weapon Wizard", description = "Completely upgrade every type of Keyblade, and then view the Trophies menu.", points = 25,
    trigger = WasBitflagSetInGame(weaponWizard())
)

function converterLv100() => bit0(0x195c7f)
achievement(title = "Converter LV 100", description = "Level up a command to Level 100, and then view the Trophies menu.", points = 5,
    trigger = WasBitflagSetInGame(converterLv100())
)

function converterCRLv100() => bit7(0x195c7e)
achievement(title = "Converter CR LV 100", description = "Level up a command to CR Level 100, and then view the Trophies menu.", points = 10,
    trigger = WasBitflagSetInGame(converterCRLv100())
)

function commandMaster() => bit6(0x195c7e)
achievement(title = "Command Master", description = "Upgrade every type of attack and magic command to CR, and then view the Trophies menu.", points = 50,
    trigger = WasBitflagSetInGame(commandMaster())
)

// NOTE: If the memory here is unstable, use the Castle Oblivion story entry flag instead.
// It'll trigger earlier than the credits, but it beats spending a crapload of time coming up with a convoluted implementation.
function creditsState() => dword(0x1acda8)
function DidCreditsStart() => once(once(once(creditsState() == 0x0) && creditsState() == 0xf0) && creditsState() == 0x1f0)
	&& never(creditsState() != 0x0 && creditsState() != 0xf0 && creditsState() != 0x1f0)
function closedBook() => bit5(0x195bd9)
achievement(title = "Closed Book", description = "Complete the story.", points = 25,
    trigger = DidCreditsStart() && WasBitflagSetInGame(closedBook())
)

characterQuestData = {
    "Selphie": { "bit0": bit7(0x195bd4), "bit1": bit0(0x195bd5) },
    "Cid": { "bit0": bit5(0x195bd4), "bit1": bit6(0x195bd4) },
    "Aladdin": { "bit0": bit7(0x195bdb), "bit1": bit0(0x195bd4) },
    "Alice": { "bit0": bit3(0x195bd4), "bit1": bit4(0x195bd4) },
    "Phil": { "bit0": bit1(0x195bd4), "bit1": bit2(0x195bd4) }
}

// Generate conditions for quests from the above addresses.
questConditions = {}
i = 0
for name in characterQuestData
{
    character = characterQuestData[name]
    bit0 = character["bit0"]
    bit1 = character["bit1"]
    questConditions[i] = { "countsWhen": (bit0 == 1), "recalculateWhen": (bit0 != Delta(bit0)) }
    questConditions[i + 1] = { "countsWhen": (bit1 == 1), "recalculateWhen": (bit1 != Delta(bit1)) }
    questConditions[i + 2] = { "countsWhen": (bit1 == 1), "recalculateWhen": (bit1 != Delta(bit1)) }
    i = i + 3
}

GenerateSaveProtectedAchievementFromConditions({
    "name": "What Am I, a Delivery Boy?",
    "description": "Complete three quests.",
    "points": 5,
    "threshold": 3,
}, questConditions, always_true())

GenerateSaveProtectedAchievementFromConditions({
    "name": "A Friend in Need",
    "description": "Complete seven quests.",
    "points": 10,
    "threshold": 7,
}, questConditions, always_true())

function questBester() => bit4(0x195c7e)
GenerateSaveProtectedAchievementFromConditions({
    "name": "Quest Bester",
    "description": "Complete all quests.",
    "points": 25,
    "threshold": (length(characterQuestData) * 3),
}, questConditions, always_true())

worldDifficulties = {
    "Destiny Islands": { "Proud": bit4(0x195bd9), "Critical": bit4(0x195bd8) },
    "Traverse Town": { "Proud": bit3(0x195bd9), "Critical": bit3(0x195bd8) },
    "Wonderland": { "Proud": bit2(0x195bd9), "Critical": bit2(0x195bd8) },
    "Olympus Coliseum": { "Proud": bit1(0x195bd9), "Critical": bit1(0x195bd8) },
    "Agrabah": { "Proud": bit0(0x195bd9), "Critical": bit0(0x195bd8) },
    "Hollow Bastion, Part I": { "Proud": bit7(0x195bd8), "Critical": bit7(0x195bdf) },
    "Hollow Bastion, Part II": { "Proud": bit6(0x195bd8), "Critical": bit6(0x195bdf) },
    "Castle Oblivion": { "Proud": bit5(0x195bd8), "Critical": bit5(0x195bdf) }
}

criticalModeConditions = {}
proudModeConditions = {}

i = 0
for j in worldDifficulties
{
    world = worldDifficulties[j]
    criticalModeConditions[i] = GenerateConditionFromBitflag(world["Critical"])
    proudModeConditions[i] = { "countsWhen": (world["Critical"] == 1 || world["Proud"] == 1),
        "recalculateWhen": (Delta(world["Critical"]) != world["Critical"] || Delta(world["Proud"]) != world["Proud"]) }
    i = i + 1
}

// We're naming this achievement different from the in-game trophy to help clue into the player that this achievement is not intended to trigger under the same conditions as the trophy itself.
// The "Proud Achievement" trophy will be earned if the player completes all worlds on Critical Mode, but it will *not* be earned if, say,
// one world is completed on Proud Mode and the rest are completed on Critical Mode.
function proudAchievement() => bit3(0x195c7e)
GenerateSaveProtectedAchievementFromConditions({
    "name": "Adventurer's Pride",
    "description": "Complete every world on Proud Mode or higher.",
    "points": 10,
    "threshold": 8
}, proudModeConditions, always_true())

function criticalAcclaim() => bit2(0x195c7e)
GenerateSaveProtectedAchievementFromConditions({
    "name": "Critical Acclaim",
    "description": "Complete every world on Critical Mode.",
    "points": 25,
    "threshold": 8
}, criticalModeConditions, always_true())

worldsCompletedWith1HP = [
    bit5(0x195bde), bit6(0x195bde), bit7(0x195bde),
    bit0(0x195bdf), bit1(0x195bdf), bit2(0x195bdf), bit3(0x195bdf), bit4(0x195bdf)
]

oneHpConditions = {}

for j in worldsCompletedWith1HP
{
    oneHpConditions[i] = GenerateConditionFromBitflag(j)
    i = i + 1
}

function fatalFlawless() => bit1(0x195c7e)
GenerateSaveProtectedAchievementFromConditions({
    "name": "Fatal Flawless",
    "description": "Complete a world with the HP Cheat set to 0%.",
    "points": 10,
    "threshold": 1
}, oneHpConditions, always_true())

function technician() => bit0(0x195c7e)
achievement(title = "Technician", description = "Replay and complete every world at Level 15 or lower, and then view the Trophies menu.", points = 10,
    trigger = WasBitflagSetInGame(technician())
)

speedrunnerTrophies = {
    1: { "bit": 7, "timeLimit": 5 },
    2: { "bit": 6, "timeLimit": 15 },
    3: { "bit": 5, "timeLimit": 15 },
    4: { "bit": 4, "timeLimit": 10 },
    5: { "bit": 3, "timeLimit": 15 },
    6: { "bit": 2, "timeLimit": 15 },
    7: { "bit": 1, "timeLimit": 30 },
    8: { "bit": 0, "timeLimit": 10 },
}


function twilightTriumph() => bit3(0x195c7f)
function eliminatorsEnd() => bit4(0x195c7f)
trophies = [
    championCollector(), cheater(), sultanOfSlot(), sectorSweeper(), lordOfLoot(), rarePrizeRoundup(),
    technician(), fatalFlawless(), criticalAcclaim(), proudAchievement(), questBester(), closedBook(),
    commandMaster(), converterCRLv100(), converterLv100(), weaponWizard(), justiceForAll(), twilightTriumph(),
    eliminatorsEnd(), icerOfTitans(), avatarSweeper(), avatarCollector()
]

for i in speedrunnerTrophies
{
    trophy = speedrunnerTrophies[i]
    trophyMem = bit(trophy["bit"], 0x195c7d)
    achievement(title = "W" + i + " Speed Runner", description = "Finish World " + i + " in " + trophy["timeLimit"] + ":00 or less, and then view the Trophies menu.", points = 10,
        trigger = WasBitflagSetInGame(trophyMem)
    )
    
    array_push(trophies, trophyMem) // Add the speedrunning tropies to the array defined above.
}

trophyConditions = {}

for j in trophies
{
    trophyConditions[i] = GenerateConditionFromBitflag(j)
    i = i + 1
}

GenerateSaveProtectedAchievementFromConditions({
    "name": "Overachiever",
    "description": "Earn twenty trophies, and then view the Trophies menu.",
    "points": 25,
    "threshold": 20
}, trophyConditions, always_true())

leaderboard(title = "Time Attack - Destiny Islands", description = "Seal the Destiny Islands Keyhole as quickly as you can.",
    start = IsInLocation("DestinyStorm") && !IsInSystemSector(),
    cancel = !IsInLocation("DestinyStorm") || IsInSystemSector(),
    submit = IsBossRankJustDisplayed(),
    value = bossMilliseconds() / 10
)

leaderboard(title = "Score Attack - Destiny Islands", description = "Get as many points as you can in the Destiny Islands Keyhole.",
    start = IsInLocation("DestinyStorm") && IsTotalScoreJustDisplayed() && !IsInSystemSector(),
    cancel = !IsInLocation("DestinyStorm") || IsInSystemSector(),
    submit = IsTotalScoreJustDisplayed(),
    value = dword(bossScorePointer() + 8)
)

leaderboard(title = "Score Attack - Traverse Town", description = "Get as many points as you can in the Traverse Town Keyhole.",
    start = IsInLocation("TraverseKeyholeTerminus") && IsTotalScoreJustDisplayed() && !IsInSystemSector(),
    cancel = !IsInLocation("TraverseKeyholeFirst") && !IsInLocation("TraverseKeyholeSecond")
        && !IsInLocation("TraverseKeyholeThird") && !IsInLocation("TraverseKeyholeFall") && !IsInLocation("TraverseKeyholeTerminus")
        || IsInSystemSector(),
    submit = IsTotalScoreJustDisplayed(),
    value = dword(bossScorePointer() + 8)
)

leaderboard(title = "Score Attack - Wonderland", description = "Get as many points as you can in the Wonderland Keyhole.",
    start = IsInLocation("WonderlandKeyholeTerminus") && IsTotalScoreJustDisplayed() && !IsInSystemSector(),
    cancel = !IsInLocation("WonderlandKeyholeFirst") && !IsInLocation("WonderlandKeyholeSecond")
        && !IsInLocation("WonderlandKeyholeTerminus") || IsInSystemSector(),
    submit = IsTotalScoreJustDisplayed(),
    value = dword(bossScorePointer() + 8)
)

leaderboard(title = "Score Attack - Olympus Coliseum, Layer 5", description = "Get as many points as you can in the Olympus Coliseum Keyhole, up to Layer 5.",
    start = IsInLocation("OlympusLayer5") && IsTotalScoreJustDisplayed() && !IsInSystemSector(),
    cancel = !IsInLocation("OlympusLayer5") || IsInSystemSector(),
    submit = IsTotalScoreJustDisplayed(),
    value = dword(bossScorePointer() + 8)
)

leaderboard(title = "Score Attack - Olympus Coliseum, Layer 15", description = "Get as many points as you can in the Olympus Coliseum Keyhole, up to Layer 15.",
    start = IsInLocation("OlympusLayer15") && IsTotalScoreJustDisplayed() && !IsInSystemSector(),
    cancel = !IsInLocation("OlympusLayer15") || IsInSystemSector(),
    submit = IsTotalScoreJustDisplayed(),
    value = dword(bossScorePointer() + 8)
)

leaderboard(title = "Score Attack - Olympus Coliseum, Layer 30", description = "Get as many points as you can in the Olympus Coliseum Keyhole, up to Layer 30.",
    start = IsInLocation("OlympusLayer30") && IsTotalScoreJustDisplayed() && !IsInSystemSector(),
    cancel = !IsInLocation("OlympusLayer30") || IsInSystemSector(),
    submit = IsTotalScoreJustDisplayed(),
    value = dword(bossScorePointer() + 8)
)

leaderboard(title = "Time Attack - Agrabah", description = "Seal the Agrabah Keyhole as quickly as you can.",
    start = IsInLocation("AgrabahKeyholeTerminus") && !IsInSystemSector(),
    cancel = !IsInLocation("AgrabahKeyholeTerminus") || IsInSystemSector(),
    submit = IsBossRankJustDisplayed(),
    value = bossMilliseconds() / 10
)

leaderboard(title = "Score Attack - Agrabah", description = "Get as many points as you can in the Agrabah Keyhole.",
    start = IsInLocation("AgrabahKeyholeTerminus") && IsTotalScoreJustDisplayed() && !IsInSystemSector(),
    cancel = !IsInLocation("AgrabahKeyholeTerminus") || IsInSystemSector(),
    submit = IsTotalScoreJustDisplayed(),
    value = dword(bossScorePointer() + 8)
)

leaderboard(title = "Time Attack - Hollow Bastion", description = "Seal the Hollow Bastion Keyhole as quickly as you can.",
    start = IsInLocation("HollowBastionKeyholeChapel") && !IsInSystemSector(),
    cancel = !IsInLocation("HollowBastionKeyholeChapel") || IsInSystemSector(),
    submit = IsBossRankJustDisplayed(),
    value = bossMilliseconds() / 10
)

leaderboard(title = "Score Attack - Hollow Bastion", description = "Get as many points as you can in the Hollow Bastion Keyhole.",
    start = IsInLocation("HollowBastionKeyholeChapel") && IsTotalScoreJustDisplayed() && !IsInSystemSector(),
    cancel = !IsInLocation("HollowBastionKeyholeChapel") || IsInSystemSector(),
    submit = IsTotalScoreJustDisplayed(),
    value = dword(bossScorePointer() + 8)
)

leaderboard(title = "Time Attack - Hollow Bastion II", description = "Escape from inside Riku's data as quickly as you can.",
    start = IsInLocation("HollowBastionDragon") && !IsInSystemSector(),
    cancel = !IsInLocation("HollowBastionDragon") || IsInSystemSector(),
    submit = IsBossRankJustDisplayed(),
    value = bossMilliseconds() / 10
)

leaderboard(title = "Score Attack - Hollow Bastion II", description = "Get as many points as you can escaping from inside Riku's data.",
    start = IsInLocation("HollowBastionDragon") && IsTotalScoreJustDisplayed() && !IsInSystemSector(),
    cancel = !IsInLocation("HollowBastionDragon") || IsInSystemSector(),
    submit = IsTotalScoreJustDisplayed(),
    value = dword(bossScorePointer() + 8)
)

leaderboard(title = "Time Attack - Hollow Bastion III", description = "Defeat Sora’s Heartless as quickly as you can.",
    start = IsInLocation("HollowBastionCentralCorruption") && !IsInSystemSector(),
    cancel = !IsInLocation("HollowBastionCentralCorruption") || IsInSystemSector(),
    submit = IsBossRankJustDisplayed(),
    value = bossMilliseconds() / 10
)

leaderboard(title = "Score Attack - Hollow Bastion III", description = "Get as many points as you can defeating Sora’s Heartless.",
    start = IsInLocation("HollowBastionCentralCorruption") && IsTotalScoreJustDisplayed() && !IsInSystemSector(),
    cancel = !IsInLocation("HollowBastionCentralCorruption") || IsInSystemSector(),
    submit = IsTotalScoreJustDisplayed(),
    value = dword(bossScorePointer() + 8)
)

leaderboard(title = "Time Attack - Castle Oblivion", description = "Defeat the final boss as quickly as you can.",
    start = IsInLocation("CastleOblivionSorrow") && !IsInSystemSector(),
    cancel = !IsInLocation("CastleOblivionSorrow") || IsInSystemSector(),
    submit = IsBossRankJustDisplayed(),
    value = bossMilliseconds() / 10
)

