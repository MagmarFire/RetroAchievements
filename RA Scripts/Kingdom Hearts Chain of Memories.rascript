// Kingdom Hearts: Chain of Memories
// #ID = 768

// $005B30: Load Menu
// $033190: Otra vida jefe
// $03A9CC: Riku III
// $03D0B2: Title screen index
//
//          0x0 = new game
//          0x1 = load game

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

function IsLoadingSaveFile()
{
    return Delta(gameTransitionState()) == 0 && (loadAnimationState() == 0x9189 || loadAnimationState() == 0x9279)
}

function WasValueSet(mem, oldValue, newValue)
{
    return Delta(mem) == oldValue && mem == newValue
}

function WasValueSetInGame(mem, oldValue, newValue)
{
    return WasValueSet(mem, oldValue, newValue) && !IsLoadingSaveFile()
}

function WasBitflagSetInGame(mem)
{
    return WasValueSetInGame(mem, 0, 1)
}

function worldId() => byte(0x0421CC)

function roomId() => byte(0x044b86)

function systemTimer() => dword(0x006c68)

function FrameHasAdvanced() => Delta(systemTimer()) != systemTimer()

function IsPaused() => byte(0x03be70) == 1

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
    13: "100-Acre Wood",
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

// $0421CD: Battlefield ID (EU)
function battlefieldId() => byte(0x0421CD)

// $0421CE: Floor (EU)
function floor() => byte(0x0421CE)

function IsOnFloor(floor) => floor == floor() + 1

// $0422B8: Max HP (16-bit)
function maxHp() => word(0x0422B8)

// $0422BA: Max CP (16-bit)
function maxCp() => word(0x0422BA)

// $0422BE: Riku
//          Puntos Ataque
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

// 0x03c000: Bit 0: A button
//           Bit 1: B button
//           Bit 4: D-pad Right
//           Bit 5: D-pad Left
//           Bit 6: D-pad Up
//           Bit 7: D-pad Down
function inputFlagsAddr() => 0x03c000
function dpadFlags() => high4(inputFlagsAddr())
function aIsPressed() => bit0(inputFlagsAddr())
function bIsPressed() => bit1(inputFlagsAddr())

function DpadIsPressed() => dpadFlags() > 0

function deck1BaseAddr() => 0x0423f0
function inventoryBaseAddr() => 0x042690

cards = {
    0x0: { "idMostSigNib": 0, "idLeastSigByte": 0x0, "name": "Kingdom Key", "value": 0, "type": "Attack", "cpCost": 19, },
0x1: { "idMostSigNib": 0, "idLeastSigByte": 0x1, "name": "Kingdom Key", "value": 1, "type": "Attack", "cpCost": 10, },
0x2: { "idMostSigNib": 0, "idLeastSigByte": 0x2, "name": "Kingdom Key", "value": 2, "type": "Attack", "cpCost": 11, },
0x3: { "idMostSigNib": 0, "idLeastSigByte": 0x3, "name": "Kingdom Key", "value": 3, "type": "Attack", "cpCost": 12, },
0x4: { "idMostSigNib": 0, "idLeastSigByte": 0x4, "name": "Kingdom Key", "value": 4, "type": "Attack", "cpCost": 13, },
0x5: { "idMostSigNib": 0, "idLeastSigByte": 0x5, "name": "Kingdom Key", "value": 5, "type": "Attack", "cpCost": 14, },
0x6: { "idMostSigNib": 0, "idLeastSigByte": 0x6, "name": "Kingdom Key", "value": 6, "type": "Attack", "cpCost": 15, },
0x7: { "idMostSigNib": 0, "idLeastSigByte": 0x7, "name": "Kingdom Key", "value": 7, "type": "Attack", "cpCost": 16, },
0x8: { "idMostSigNib": 0, "idLeastSigByte": 0x8, "name": "Kingdom Key", "value": 8, "type": "Attack", "cpCost": 17, },
0x9: { "idMostSigNib": 0, "idLeastSigByte": 0x9, "name": "Kingdom Key", "value": 9, "type": "Attack", "cpCost": 18, },
0xA: { "idMostSigNib": 0, "idLeastSigByte": 0xA, "name": "Three Wishes", "value": 0, "type": "Attack", "cpCost": 24, },
0xB: { "idMostSigNib": 0, "idLeastSigByte": 0xB, "name": "Three Wishes", "value": 1, "type": "Attack", "cpCost": 15, },
0xC: { "idMostSigNib": 0, "idLeastSigByte": 0xC, "name": "Three Wishes", "value": 2, "type": "Attack", "cpCost": 16, },
0xD: { "idMostSigNib": 0, "idLeastSigByte": 0xD, "name": "Three Wishes", "value": 3, "type": "Attack", "cpCost": 17, },
0xE: { "idMostSigNib": 0, "idLeastSigByte": 0xE, "name": "Three Wishes", "value": 4, "type": "Attack", "cpCost": 18, },
0xF: { "idMostSigNib": 0, "idLeastSigByte": 0xF, "name": "Three Wishes", "value": 5, "type": "Attack", "cpCost": 19, },
0x10: { "idMostSigNib": 0, "idLeastSigByte": 0x10, "name": "Three Wishes", "value": 6, "type": "Attack", "cpCost": 20, },
0x11: { "idMostSigNib": 0, "idLeastSigByte": 0x11, "name": "Three Wishes", "value": 7, "type": "Attack", "cpCost": 21, },
0x12: { "idMostSigNib": 0, "idLeastSigByte": 0x12, "name": "Three Wishes", "value": 8, "type": "Attack", "cpCost": 22, },
0x13: { "idMostSigNib": 0, "idLeastSigByte": 0x13, "name": "Three Wishes", "value": 9, "type": "Attack", "cpCost": 23, },
0x14: { "idMostSigNib": 0, "idLeastSigByte": 0x14, "name": "Crabclaw", "value": 0, "type": "Attack", "cpCost": 38, },
0x15: { "idMostSigNib": 0, "idLeastSigByte": 0x15, "name": "Crabclaw", "value": 1, "type": "Attack", "cpCost": 20, },
0x16: { "idMostSigNib": 0, "idLeastSigByte": 0x16, "name": "Crabclaw", "value": 2, "type": "Attack", "cpCost": 22, },
0x17: { "idMostSigNib": 0, "idLeastSigByte": 0x17, "name": "Crabclaw", "value": 3, "type": "Attack", "cpCost": 24, },
0x18: { "idMostSigNib": 0, "idLeastSigByte": 0x18, "name": "Crabclaw", "value": 4, "type": "Attack", "cpCost": 26, },
0x19: { "idMostSigNib": 0, "idLeastSigByte": 0x19, "name": "Crabclaw", "value": 5, "type": "Attack", "cpCost": 28, },
0x1A: { "idMostSigNib": 0, "idLeastSigByte": 0x1A, "name": "Crabclaw", "value": 6, "type": "Attack", "cpCost": 30, },
0x1B: { "idMostSigNib": 0, "idLeastSigByte": 0x1B, "name": "Crabclaw", "value": 7, "type": "Attack", "cpCost": 32, },
0x1C: { "idMostSigNib": 0, "idLeastSigByte": 0x1C, "name": "Crabclaw", "value": 8, "type": "Attack", "cpCost": 34, },
0x1D: { "idMostSigNib": 0, "idLeastSigByte": 0x1D, "name": "Crabclaw", "value": 9, "type": "Attack", "cpCost": 36, },
0x1E: { "idMostSigNib": 0, "idLeastSigByte": 0x1E, "name": "Pumpkinhead", "value": 0, "type": "Attack", "cpCost": 24, },
0x1F: { "idMostSigNib": 0, "idLeastSigByte": 0x1F, "name": "Pumpkinhead", "value": 1, "type": "Attack", "cpCost": 15, },
0x20: { "idMostSigNib": 0, "idLeastSigByte": 0x20, "name": "Pumpkinhead", "value": 2, "type": "Attack", "cpCost": 16, },
0x21: { "idMostSigNib": 0, "idLeastSigByte": 0x21, "name": "Pumpkinhead", "value": 3, "type": "Attack", "cpCost": 17, },
0x22: { "idMostSigNib": 0, "idLeastSigByte": 0x22, "name": "Pumpkinhead", "value": 4, "type": "Attack", "cpCost": 18, },
0x23: { "idMostSigNib": 0, "idLeastSigByte": 0x23, "name": "Pumpkinhead", "value": 5, "type": "Attack", "cpCost": 19, },
0x24: { "idMostSigNib": 0, "idLeastSigByte": 0x24, "name": "Pumpkinhead", "value": 6, "type": "Attack", "cpCost": 20, },
0x25: { "idMostSigNib": 0, "idLeastSigByte": 0x25, "name": "Pumpkinhead", "value": 7, "type": "Attack", "cpCost": 21, },
0x26: { "idMostSigNib": 0, "idLeastSigByte": 0x26, "name": "Pumpkinhead", "value": 8, "type": "Attack", "cpCost": 22, },
0x27: { "idMostSigNib": 0, "idLeastSigByte": 0x27, "name": "Pumpkinhead", "value": 9, "type": "Attack", "cpCost": 23, },
0x28: { "idMostSigNib": 0, "idLeastSigByte": 0x28, "name": "Fairy Harp", "value": 0, "type": "Attack", "cpCost": 38, },
0x29: { "idMostSigNib": 0, "idLeastSigByte": 0x29, "name": "Fairy Harp", "value": 1, "type": "Attack", "cpCost": 20, },
0x2A: { "idMostSigNib": 0, "idLeastSigByte": 0x2A, "name": "Fairy Harp", "value": 2, "type": "Attack", "cpCost": 22, },
0x2B: { "idMostSigNib": 0, "idLeastSigByte": 0x2B, "name": "Fairy Harp", "value": 3, "type": "Attack", "cpCost": 24, },
0x2C: { "idMostSigNib": 0, "idLeastSigByte": 0x2C, "name": "Fairy Harp", "value": 4, "type": "Attack", "cpCost": 26, },
0x2D: { "idMostSigNib": 0, "idLeastSigByte": 0x2D, "name": "Fairy Harp", "value": 5, "type": "Attack", "cpCost": 28, },
0x2E: { "idMostSigNib": 0, "idLeastSigByte": 0x2E, "name": "Fairy Harp", "value": 6, "type": "Attack", "cpCost": 30, },
0x2F: { "idMostSigNib": 0, "idLeastSigByte": 0x2F, "name": "Fairy Harp", "value": 7, "type": "Attack", "cpCost": 32, },
0x30: { "idMostSigNib": 0, "idLeastSigByte": 0x30, "name": "Fairy Harp", "value": 8, "type": "Attack", "cpCost": 34, },
0x31: { "idMostSigNib": 0, "idLeastSigByte": 0x31, "name": "Fairy Harp", "value": 9, "type": "Attack", "cpCost": 36, },
0x32: { "idMostSigNib": 0, "idLeastSigByte": 0x32, "name": "Wishing Star", "value": 0, "type": "Attack", "cpCost": 24, },
0x33: { "idMostSigNib": 0, "idLeastSigByte": 0x33, "name": "Wishing Star", "value": 1, "type": "Attack", "cpCost": 15, },
0x34: { "idMostSigNib": 0, "idLeastSigByte": 0x34, "name": "Wishing Star", "value": 2, "type": "Attack", "cpCost": 16, },
0x35: { "idMostSigNib": 0, "idLeastSigByte": 0x35, "name": "Wishing Star", "value": 3, "type": "Attack", "cpCost": 17, },
0x36: { "idMostSigNib": 0, "idLeastSigByte": 0x36, "name": "Wishing Star", "value": 4, "type": "Attack", "cpCost": 18, },
0x37: { "idMostSigNib": 0, "idLeastSigByte": 0x37, "name": "Wishing Star", "value": 5, "type": "Attack", "cpCost": 19, },
0x38: { "idMostSigNib": 0, "idLeastSigByte": 0x38, "name": "Wishing Star", "value": 6, "type": "Attack", "cpCost": 20, },
0x39: { "idMostSigNib": 0, "idLeastSigByte": 0x39, "name": "Wishing Star", "value": 7, "type": "Attack", "cpCost": 21, },
0x3A: { "idMostSigNib": 0, "idLeastSigByte": 0x3A, "name": "Wishing Star", "value": 8, "type": "Attack", "cpCost": 22, },
0x3B: { "idMostSigNib": 0, "idLeastSigByte": 0x3B, "name": "Wishing Star", "value": 9, "type": "Attack", "cpCost": 23, },
0x3C: { "idMostSigNib": 0, "idLeastSigByte": 0x3C, "name": "Spellbinder", "value": 0, "type": "Attack", "cpCost": 38, },
0x3D: { "idMostSigNib": 0, "idLeastSigByte": 0x3D, "name": "Spellbinder", "value": 1, "type": "Attack", "cpCost": 20, },
0x3E: { "idMostSigNib": 0, "idLeastSigByte": 0x3E, "name": "Spellbinder", "value": 2, "type": "Attack", "cpCost": 22, },
0x3F: { "idMostSigNib": 0, "idLeastSigByte": 0x3F, "name": "Spellbinder", "value": 3, "type": "Attack", "cpCost": 24, },
0x40: { "idMostSigNib": 0, "idLeastSigByte": 0x40, "name": "Spellbinder", "value": 4, "type": "Attack", "cpCost": 26, },
0x41: { "idMostSigNib": 0, "idLeastSigByte": 0x41, "name": "Spellbinder", "value": 5, "type": "Attack", "cpCost": 28, },
0x42: { "idMostSigNib": 0, "idLeastSigByte": 0x42, "name": "Spellbinder", "value": 6, "type": "Attack", "cpCost": 30, },
0x43: { "idMostSigNib": 0, "idLeastSigByte": 0x43, "name": "Spellbinder", "value": 7, "type": "Attack", "cpCost": 32, },
0x44: { "idMostSigNib": 0, "idLeastSigByte": 0x44, "name": "Spellbinder", "value": 8, "type": "Attack", "cpCost": 34, },
0x45: { "idMostSigNib": 0, "idLeastSigByte": 0x45, "name": "Spellbinder", "value": 9, "type": "Attack", "cpCost": 36, },
0x46: { "idMostSigNib": 0, "idLeastSigByte": 0x46, "name": "Metal Chocobo", "value": 0, "type": "Attack", "cpCost": 38, },
0x47: { "idMostSigNib": 0, "idLeastSigByte": 0x47, "name": "Metal Chocobo", "value": 1, "type": "Attack", "cpCost": 20, },
0x48: { "idMostSigNib": 0, "idLeastSigByte": 0x48, "name": "Metal Chocobo", "value": 2, "type": "Attack", "cpCost": 22, },
0x49: { "idMostSigNib": 0, "idLeastSigByte": 0x49, "name": "Metal Chocobo", "value": 3, "type": "Attack", "cpCost": 24, },
0x4A: { "idMostSigNib": 0, "idLeastSigByte": 0x4A, "name": "Metal Chocobo", "value": 4, "type": "Attack", "cpCost": 26, },
0x4B: { "idMostSigNib": 0, "idLeastSigByte": 0x4B, "name": "Metal Chocobo", "value": 5, "type": "Attack", "cpCost": 28, },
0x4C: { "idMostSigNib": 0, "idLeastSigByte": 0x4C, "name": "Metal Chocobo", "value": 6, "type": "Attack", "cpCost": 30, },
0x4D: { "idMostSigNib": 0, "idLeastSigByte": 0x4D, "name": "Metal Chocobo", "value": 7, "type": "Attack", "cpCost": 32, },
0x4E: { "idMostSigNib": 0, "idLeastSigByte": 0x4E, "name": "Metal Chocobo", "value": 8, "type": "Attack", "cpCost": 34, },
0x4F: { "idMostSigNib": 0, "idLeastSigByte": 0x4F, "name": "Metal Chocobo", "value": 9, "type": "Attack", "cpCost": 36, },
0x50: { "idMostSigNib": 0, "idLeastSigByte": 0x50, "name": "Olympia", "value": 0, "type": "Attack", "cpCost": 24, },
0x51: { "idMostSigNib": 0, "idLeastSigByte": 0x51, "name": "Olympia", "value": 1, "type": "Attack", "cpCost": 15, },
0x52: { "idMostSigNib": 0, "idLeastSigByte": 0x52, "name": "Olympia", "value": 2, "type": "Attack", "cpCost": 16, },
0x53: { "idMostSigNib": 0, "idLeastSigByte": 0x53, "name": "Olympia", "value": 3, "type": "Attack", "cpCost": 17, },
0x54: { "idMostSigNib": 0, "idLeastSigByte": 0x54, "name": "Olympia", "value": 4, "type": "Attack", "cpCost": 18, },
0x55: { "idMostSigNib": 0, "idLeastSigByte": 0x55, "name": "Olympia", "value": 5, "type": "Attack", "cpCost": 19, },
0x56: { "idMostSigNib": 0, "idLeastSigByte": 0x56, "name": "Olympia", "value": 6, "type": "Attack", "cpCost": 20, },
0x57: { "idMostSigNib": 0, "idLeastSigByte": 0x57, "name": "Olympia", "value": 7, "type": "Attack", "cpCost": 21, },
0x58: { "idMostSigNib": 0, "idLeastSigByte": 0x58, "name": "Olympia", "value": 8, "type": "Attack", "cpCost": 22, },
0x59: { "idMostSigNib": 0, "idLeastSigByte": 0x59, "name": "Olympia", "value": 9, "type": "Attack", "cpCost": 23, },
0x5A: { "idMostSigNib": 0, "idLeastSigByte": 0x5A, "name": "Lionheart", "value": 0, "type": "Attack", "cpCost": 38, },
0x5B: { "idMostSigNib": 0, "idLeastSigByte": 0x5B, "name": "Lionheart", "value": 1, "type": "Attack", "cpCost": 20, },
0x5C: { "idMostSigNib": 0, "idLeastSigByte": 0x5C, "name": "Lionheart", "value": 2, "type": "Attack", "cpCost": 22, },
0x5D: { "idMostSigNib": 0, "idLeastSigByte": 0x5D, "name": "Lionheart", "value": 3, "type": "Attack", "cpCost": 24, },
0x5E: { "idMostSigNib": 0, "idLeastSigByte": 0x5E, "name": "Lionheart", "value": 4, "type": "Attack", "cpCost": 26, },
0x5F: { "idMostSigNib": 0, "idLeastSigByte": 0x5F, "name": "Lionheart", "value": 5, "type": "Attack", "cpCost": 28, },
0x60: { "idMostSigNib": 0, "idLeastSigByte": 0x60, "name": "Lionheart", "value": 6, "type": "Attack", "cpCost": 30, },
0x61: { "idMostSigNib": 0, "idLeastSigByte": 0x61, "name": "Lionheart", "value": 7, "type": "Attack", "cpCost": 32, },
0x62: { "idMostSigNib": 0, "idLeastSigByte": 0x62, "name": "Lionheart", "value": 8, "type": "Attack", "cpCost": 34, },
0x63: { "idMostSigNib": 0, "idLeastSigByte": 0x63, "name": "Lionheart", "value": 9, "type": "Attack", "cpCost": 36, },
0x64: { "idMostSigNib": 0, "idLeastSigByte": 0x64, "name": "Lady Luck", "value": 0, "type": "Attack", "cpCost": 24, },
0x65: { "idMostSigNib": 0, "idLeastSigByte": 0x65, "name": "Lady Luck", "value": 1, "type": "Attack", "cpCost": 15, },
0x66: { "idMostSigNib": 0, "idLeastSigByte": 0x66, "name": "Lady Luck", "value": 2, "type": "Attack", "cpCost": 16, },
0x67: { "idMostSigNib": 0, "idLeastSigByte": 0x67, "name": "Lady Luck", "value": 3, "type": "Attack", "cpCost": 17, },
0x68: { "idMostSigNib": 0, "idLeastSigByte": 0x68, "name": "Lady Luck", "value": 4, "type": "Attack", "cpCost": 18, },
0x69: { "idMostSigNib": 0, "idLeastSigByte": 0x69, "name": "Lady Luck", "value": 5, "type": "Attack", "cpCost": 19, },
0x6A: { "idMostSigNib": 0, "idLeastSigByte": 0x6A, "name": "Lady Luck", "value": 6, "type": "Attack", "cpCost": 20, },
0x6B: { "idMostSigNib": 0, "idLeastSigByte": 0x6B, "name": "Lady Luck", "value": 7, "type": "Attack", "cpCost": 21, },
0x6C: { "idMostSigNib": 0, "idLeastSigByte": 0x6C, "name": "Lady Luck", "value": 8, "type": "Attack", "cpCost": 22, },
0x6D: { "idMostSigNib": 0, "idLeastSigByte": 0x6D, "name": "Lady Luck", "value": 9, "type": "Attack", "cpCost": 23, },
0x6E: { "idMostSigNib": 0, "idLeastSigByte": 0x6E, "name": "Divine Rose", "value": 0, "type": "Attack", "cpCost": 38, },
0x6F: { "idMostSigNib": 0, "idLeastSigByte": 0x6F, "name": "Divine Rose", "value": 1, "type": "Attack", "cpCost": 20, },
0x70: { "idMostSigNib": 0, "idLeastSigByte": 0x70, "name": "Divine Rose", "value": 2, "type": "Attack", "cpCost": 22, },
0x71: { "idMostSigNib": 0, "idLeastSigByte": 0x71, "name": "Divine Rose", "value": 3, "type": "Attack", "cpCost": 24, },
0x72: { "idMostSigNib": 0, "idLeastSigByte": 0x72, "name": "Divine Rose", "value": 4, "type": "Attack", "cpCost": 26, },
0x73: { "idMostSigNib": 0, "idLeastSigByte": 0x73, "name": "Divine Rose", "value": 5, "type": "Attack", "cpCost": 28, },
0x74: { "idMostSigNib": 0, "idLeastSigByte": 0x74, "name": "Divine Rose", "value": 6, "type": "Attack", "cpCost": 30, },
0x75: { "idMostSigNib": 0, "idLeastSigByte": 0x75, "name": "Divine Rose", "value": 7, "type": "Attack", "cpCost": 32, },
0x76: { "idMostSigNib": 0, "idLeastSigByte": 0x76, "name": "Divine Rose", "value": 8, "type": "Attack", "cpCost": 34, },
0x77: { "idMostSigNib": 0, "idLeastSigByte": 0x77, "name": "Divine Rose", "value": 9, "type": "Attack", "cpCost": 36, },
0x78: { "idMostSigNib": 0, "idLeastSigByte": 0x78, "name": "Oathkeeper", "value": 0, "type": "Attack", "cpCost": 43, },
0x79: { "idMostSigNib": 0, "idLeastSigByte": 0x79, "name": "Oathkeeper", "value": 1, "type": "Attack", "cpCost": 25, },
0x7A: { "idMostSigNib": 0, "idLeastSigByte": 0x7A, "name": "Oathkeeper", "value": 2, "type": "Attack", "cpCost": 27, },
0x7B: { "idMostSigNib": 0, "idLeastSigByte": 0x7B, "name": "Oathkeeper", "value": 3, "type": "Attack", "cpCost": 29, },
0x7C: { "idMostSigNib": 0, "idLeastSigByte": 0x7C, "name": "Oathkeeper", "value": 4, "type": "Attack", "cpCost": 31, },
0x7D: { "idMostSigNib": 0, "idLeastSigByte": 0x7D, "name": "Oathkeeper", "value": 5, "type": "Attack", "cpCost": 33, },
0x7E: { "idMostSigNib": 0, "idLeastSigByte": 0x7E, "name": "Oathkeeper", "value": 6, "type": "Attack", "cpCost": 35, },
0x7F: { "idMostSigNib": 0, "idLeastSigByte": 0x7F, "name": "Oathkeeper", "value": 7, "type": "Attack", "cpCost": 37, },
0x80: { "idMostSigNib": 0, "idLeastSigByte": 0x80, "name": "Oathkeeper", "value": 8, "type": "Attack", "cpCost": 39, },
0x81: { "idMostSigNib": 0, "idLeastSigByte": 0x81, "name": "Oathkeeper", "value": 9, "type": "Attack", "cpCost": 41, },
0x82: { "idMostSigNib": 0, "idLeastSigByte": 0x82, "name": "Oblivion", "value": 0, "type": "Attack", "cpCost": 43, },
0x83: { "idMostSigNib": 0, "idLeastSigByte": 0x83, "name": "Oblivion", "value": 1, "type": "Attack", "cpCost": 25, },
0x84: { "idMostSigNib": 0, "idLeastSigByte": 0x84, "name": "Oblivion", "value": 2, "type": "Attack", "cpCost": 27, },
0x85: { "idMostSigNib": 0, "idLeastSigByte": 0x85, "name": "Oblivion", "value": 3, "type": "Attack", "cpCost": 29, },
0x86: { "idMostSigNib": 0, "idLeastSigByte": 0x86, "name": "Oblivion", "value": 4, "type": "Attack", "cpCost": 31, },
0x87: { "idMostSigNib": 0, "idLeastSigByte": 0x87, "name": "Oblivion", "value": 5, "type": "Attack", "cpCost": 33, },
0x88: { "idMostSigNib": 0, "idLeastSigByte": 0x88, "name": "Oblivion", "value": 6, "type": "Attack", "cpCost": 35, },
0x89: { "idMostSigNib": 0, "idLeastSigByte": 0x89, "name": "Oblivion", "value": 7, "type": "Attack", "cpCost": 37, },
0x8A: { "idMostSigNib": 0, "idLeastSigByte": 0x8A, "name": "Oblivion", "value": 8, "type": "Attack", "cpCost": 39, },
0x8B: { "idMostSigNib": 0, "idLeastSigByte": 0x8B, "name": "Oblivion", "value": 9, "type": "Attack", "cpCost": 41, },
0x8C: { "idMostSigNib": 0, "idLeastSigByte": 0x8C, "name": "Diamond Dust", "value": 0, "type": "Attack", "cpCost": 43, },
0x8D: { "idMostSigNib": 0, "idLeastSigByte": 0x8D, "name": "Diamond Dust", "value": 1, "type": "Attack", "cpCost": 25, },
0x8E: { "idMostSigNib": 0, "idLeastSigByte": 0x8E, "name": "Diamond Dust", "value": 2, "type": "Attack", "cpCost": 27, },
0x8F: { "idMostSigNib": 0, "idLeastSigByte": 0x8F, "name": "Diamond Dust", "value": 3, "type": "Attack", "cpCost": 29, },
0x90: { "idMostSigNib": 0, "idLeastSigByte": 0x90, "name": "Diamond Dust", "value": 4, "type": "Attack", "cpCost": 31, },
0x91: { "idMostSigNib": 0, "idLeastSigByte": 0x91, "name": "Diamond Dust", "value": 5, "type": "Attack", "cpCost": 33, },
0x92: { "idMostSigNib": 0, "idLeastSigByte": 0x92, "name": "Diamond Dust", "value": 6, "type": "Attack", "cpCost": 35, },
0x93: { "idMostSigNib": 0, "idLeastSigByte": 0x93, "name": "Diamond Dust", "value": 7, "type": "Attack", "cpCost": 37, },
0x94: { "idMostSigNib": 0, "idLeastSigByte": 0x94, "name": "Diamond Dust", "value": 8, "type": "Attack", "cpCost": 39, },
0x95: { "idMostSigNib": 0, "idLeastSigByte": 0x95, "name": "Diamond Dust", "value": 9, "type": "Attack", "cpCost": 41, },
0x96: { "idMostSigNib": 0, "idLeastSigByte": 0x96, "name": "One-Winged Angel", "value": 0, "type": "Attack", "cpCost": 43, },
0x97: { "idMostSigNib": 0, "idLeastSigByte": 0x97, "name": "One-Winged Angel", "value": 1, "type": "Attack", "cpCost": 25, },
0x98: { "idMostSigNib": 0, "idLeastSigByte": 0x98, "name": "One-Winged Angel", "value": 2, "type": "Attack", "cpCost": 27, },
0x99: { "idMostSigNib": 0, "idLeastSigByte": 0x99, "name": "One-Winged Angel", "value": 3, "type": "Attack", "cpCost": 29, },
0x9A: { "idMostSigNib": 0, "idLeastSigByte": 0x9A, "name": "One-Winged Angel", "value": 4, "type": "Attack", "cpCost": 31, },
0x9B: { "idMostSigNib": 0, "idLeastSigByte": 0x9B, "name": "One-Winged Angel", "value": 5, "type": "Attack", "cpCost": 33, },
0x9C: { "idMostSigNib": 0, "idLeastSigByte": 0x9C, "name": "One-Winged Angel", "value": 6, "type": "Attack", "cpCost": 35, },
0x9D: { "idMostSigNib": 0, "idLeastSigByte": 0x9D, "name": "One-Winged Angel", "value": 7, "type": "Attack", "cpCost": 37, },
0x9E: { "idMostSigNib": 0, "idLeastSigByte": 0x9E, "name": "One-Winged Angel", "value": 8, "type": "Attack", "cpCost": 39, },
0x9F: { "idMostSigNib": 0, "idLeastSigByte": 0x9F, "name": "One-Winged Angel", "value": 9, "type": "Attack", "cpCost": 41, },
0xA0: { "idMostSigNib": 0, "idLeastSigByte": 0xA0, "name": "Ultima Weapon", "value": 0, "type": "Attack", "cpCost": 57, },
0xA1: { "idMostSigNib": 0, "idLeastSigByte": 0xA1, "name": "Ultima Weapon", "value": 1, "type": "Attack", "cpCost": 30, },
0xA2: { "idMostSigNib": 0, "idLeastSigByte": 0xA2, "name": "Ultima Weapon", "value": 2, "type": "Attack", "cpCost": 33, },
0xA3: { "idMostSigNib": 0, "idLeastSigByte": 0xA3, "name": "Ultima Weapon", "value": 3, "type": "Attack", "cpCost": 36, },
0xA4: { "idMostSigNib": 0, "idLeastSigByte": 0xA4, "name": "Ultima Weapon", "value": 4, "type": "Attack", "cpCost": 39, },
0xA5: { "idMostSigNib": 0, "idLeastSigByte": 0xA5, "name": "Ultima Weapon", "value": 5, "type": "Attack", "cpCost": 42, },
0xA6: { "idMostSigNib": 0, "idLeastSigByte": 0xA6, "name": "Ultima Weapon", "value": 6, "type": "Attack", "cpCost": 45, },
0xA7: { "idMostSigNib": 0, "idLeastSigByte": 0xA7, "name": "Ultima Weapon", "value": 7, "type": "Attack", "cpCost": 48, },
0xA8: { "idMostSigNib": 0, "idLeastSigByte": 0xA8, "name": "Ultima Weapon", "value": 8, "type": "Attack", "cpCost": 51, },
0xA9: { "idMostSigNib": 0, "idLeastSigByte": 0xA9, "name": "Ultima Weapon", "value": 9, "type": "Attack", "cpCost": 54, },
0xAA: { "idMostSigNib": 0, "idLeastSigByte": 0xAA, "name": "Fire", "value": 0, "type": "Magic", "cpCost": 24, },
0xAB: { "idMostSigNib": 0, "idLeastSigByte": 0xAB, "name": "Fire", "value": 1, "type": "Magic", "cpCost": 15, },
0xAC: { "idMostSigNib": 0, "idLeastSigByte": 0xAC, "name": "Fire", "value": 2, "type": "Magic", "cpCost": 16, },
0xAD: { "idMostSigNib": 0, "idLeastSigByte": 0xAD, "name": "Fire", "value": 3, "type": "Magic", "cpCost": 17, },
0xAE: { "idMostSigNib": 0, "idLeastSigByte": 0xAE, "name": "Fire", "value": 4, "type": "Magic", "cpCost": 18, },
0xAF: { "idMostSigNib": 0, "idLeastSigByte": 0xAF, "name": "Fire", "value": 5, "type": "Magic", "cpCost": 19, },
0xB0: { "idMostSigNib": 0, "idLeastSigByte": 0xB0, "name": "Fire", "value": 6, "type": "Magic", "cpCost": 20, },
0xB1: { "idMostSigNib": 0, "idLeastSigByte": 0xB1, "name": "Fire", "value": 7, "type": "Magic", "cpCost": 21, },
0xB2: { "idMostSigNib": 0, "idLeastSigByte": 0xB2, "name": "Fire", "value": 8, "type": "Magic", "cpCost": 22, },
0xB3: { "idMostSigNib": 0, "idLeastSigByte": 0xB3, "name": "Fire", "value": 9, "type": "Magic", "cpCost": 23, },
0xB4: { "idMostSigNib": 0, "idLeastSigByte": 0xB4, "name": "Blizzard", "value": 0, "type": "Magic", "cpCost": 24, },
0xB5: { "idMostSigNib": 0, "idLeastSigByte": 0xB5, "name": "Blizzard", "value": 1, "type": "Magic", "cpCost": 15, },
0xB6: { "idMostSigNib": 0, "idLeastSigByte": 0xB6, "name": "Blizzard", "value": 2, "type": "Magic", "cpCost": 16, },
0xB7: { "idMostSigNib": 0, "idLeastSigByte": 0xB7, "name": "Blizzard", "value": 3, "type": "Magic", "cpCost": 17, },
0xB8: { "idMostSigNib": 0, "idLeastSigByte": 0xB8, "name": "Blizzard", "value": 4, "type": "Magic", "cpCost": 18, },
0xB9: { "idMostSigNib": 0, "idLeastSigByte": 0xB9, "name": "Blizzard", "value": 5, "type": "Magic", "cpCost": 19, },
0xBA: { "idMostSigNib": 0, "idLeastSigByte": 0xBA, "name": "Blizzard", "value": 6, "type": "Magic", "cpCost": 20, },
0xBB: { "idMostSigNib": 0, "idLeastSigByte": 0xBB, "name": "Blizzard", "value": 7, "type": "Magic", "cpCost": 21, },
0xBC: { "idMostSigNib": 0, "idLeastSigByte": 0xBC, "name": "Blizzard", "value": 8, "type": "Magic", "cpCost": 22, },
0xBD: { "idMostSigNib": 0, "idLeastSigByte": 0xBD, "name": "Blizzard", "value": 9, "type": "Magic", "cpCost": 23, },
0xBE: { "idMostSigNib": 0, "idLeastSigByte": 0xBE, "name": "Thunder", "value": 0, "type": "Magic", "cpCost": 24, },
0xBF: { "idMostSigNib": 0, "idLeastSigByte": 0xBF, "name": "Thunder", "value": 1, "type": "Magic", "cpCost": 15, },
0xC0: { "idMostSigNib": 0, "idLeastSigByte": 0xC0, "name": "Thunder", "value": 2, "type": "Magic", "cpCost": 16, },
0xC1: { "idMostSigNib": 0, "idLeastSigByte": 0xC1, "name": "Thunder", "value": 3, "type": "Magic", "cpCost": 17, },
0xC2: { "idMostSigNib": 0, "idLeastSigByte": 0xC2, "name": "Thunder", "value": 4, "type": "Magic", "cpCost": 18, },
0xC3: { "idMostSigNib": 0, "idLeastSigByte": 0xC3, "name": "Thunder", "value": 5, "type": "Magic", "cpCost": 19, },
0xC4: { "idMostSigNib": 0, "idLeastSigByte": 0xC4, "name": "Thunder", "value": 6, "type": "Magic", "cpCost": 20, },
0xC5: { "idMostSigNib": 0, "idLeastSigByte": 0xC5, "name": "Thunder", "value": 7, "type": "Magic", "cpCost": 21, },
0xC6: { "idMostSigNib": 0, "idLeastSigByte": 0xC6, "name": "Thunder", "value": 8, "type": "Magic", "cpCost": 22, },
0xC7: { "idMostSigNib": 0, "idLeastSigByte": 0xC7, "name": "Thunder", "value": 9, "type": "Magic", "cpCost": 23, },
0xC8: { "idMostSigNib": 0, "idLeastSigByte": 0xC8, "name": "Cure", "value": 0, "type": "Magic", "cpCost": 43, },
0xC9: { "idMostSigNib": 0, "idLeastSigByte": 0xC9, "name": "Cure", "value": 1, "type": "Magic", "cpCost": 25, },
0xCA: { "idMostSigNib": 0, "idLeastSigByte": 0xCA, "name": "Cure", "value": 2, "type": "Magic", "cpCost": 27, },
0xCB: { "idMostSigNib": 0, "idLeastSigByte": 0xCB, "name": "Cure", "value": 3, "type": "Magic", "cpCost": 29, },
0xCC: { "idMostSigNib": 0, "idLeastSigByte": 0xCC, "name": "Cure", "value": 4, "type": "Magic", "cpCost": 31, },
0xCD: { "idMostSigNib": 0, "idLeastSigByte": 0xCD, "name": "Cure", "value": 5, "type": "Magic", "cpCost": 33, },
0xCE: { "idMostSigNib": 0, "idLeastSigByte": 0xCE, "name": "Cure", "value": 6, "type": "Magic", "cpCost": 35, },
0xCF: { "idMostSigNib": 0, "idLeastSigByte": 0xCF, "name": "Cure", "value": 7, "type": "Magic", "cpCost": 37, },
0xD0: { "idMostSigNib": 0, "idLeastSigByte": 0xD0, "name": "Cure", "value": 8, "type": "Magic", "cpCost": 39, },
0xD1: { "idMostSigNib": 0, "idLeastSigByte": 0xD1, "name": "Cure", "value": 9, "type": "Magic", "cpCost": 41, },
0xD2: { "idMostSigNib": 0, "idLeastSigByte": 0xD2, "name": "Gravity", "value": 0, "type": "Magic", "cpCost": 38, },
0xD3: { "idMostSigNib": 0, "idLeastSigByte": 0xD3, "name": "Gravity", "value": 1, "type": "Magic", "cpCost": 20, },
0xD4: { "idMostSigNib": 0, "idLeastSigByte": 0xD4, "name": "Gravity", "value": 2, "type": "Magic", "cpCost": 22, },
0xD5: { "idMostSigNib": 0, "idLeastSigByte": 0xD5, "name": "Gravity", "value": 3, "type": "Magic", "cpCost": 24, },
0xD6: { "idMostSigNib": 0, "idLeastSigByte": 0xD6, "name": "Gravity", "value": 4, "type": "Magic", "cpCost": 26, },
0xD7: { "idMostSigNib": 0, "idLeastSigByte": 0xD7, "name": "Gravity", "value": 5, "type": "Magic", "cpCost": 28, },
0xD8: { "idMostSigNib": 0, "idLeastSigByte": 0xD8, "name": "Gravity", "value": 6, "type": "Magic", "cpCost": 30, },
0xD9: { "idMostSigNib": 0, "idLeastSigByte": 0xD9, "name": "Gravity", "value": 7, "type": "Magic", "cpCost": 32, },
0xDA: { "idMostSigNib": 0, "idLeastSigByte": 0xDA, "name": "Gravity", "value": 8, "type": "Magic", "cpCost": 34, },
0xDB: { "idMostSigNib": 0, "idLeastSigByte": 0xDB, "name": "Gravity", "value": 9, "type": "Magic", "cpCost": 36, },
0xDC: { "idMostSigNib": 0, "idLeastSigByte": 0xDC, "name": "Stop", "value": 0, "type": "Magic", "cpCost": 38, },
0xDD: { "idMostSigNib": 0, "idLeastSigByte": 0xDD, "name": "Stop", "value": 1, "type": "Magic", "cpCost": 20, },
0xDE: { "idMostSigNib": 0, "idLeastSigByte": 0xDE, "name": "Stop", "value": 2, "type": "Magic", "cpCost": 22, },
0xDF: { "idMostSigNib": 0, "idLeastSigByte": 0xDF, "name": "Stop", "value": 3, "type": "Magic", "cpCost": 24, },
0xE0: { "idMostSigNib": 0, "idLeastSigByte": 0xE0, "name": "Stop", "value": 4, "type": "Magic", "cpCost": 26, },
0xE1: { "idMostSigNib": 0, "idLeastSigByte": 0xE1, "name": "Stop", "value": 5, "type": "Magic", "cpCost": 28, },
0xE2: { "idMostSigNib": 0, "idLeastSigByte": 0xE2, "name": "Stop", "value": 6, "type": "Magic", "cpCost": 30, },
0xE3: { "idMostSigNib": 0, "idLeastSigByte": 0xE3, "name": "Stop", "value": 7, "type": "Magic", "cpCost": 32, },
0xE4: { "idMostSigNib": 0, "idLeastSigByte": 0xE4, "name": "Stop", "value": 8, "type": "Magic", "cpCost": 34, },
0xE5: { "idMostSigNib": 0, "idLeastSigByte": 0xE5, "name": "Stop", "value": 9, "type": "Magic", "cpCost": 36, },
0xE6: { "idMostSigNib": 0, "idLeastSigByte": 0xE6, "name": "Aero", "value": 0, "type": "Magic", "cpCost": 38, },
0xE7: { "idMostSigNib": 0, "idLeastSigByte": 0xE7, "name": "Aero", "value": 1, "type": "Magic", "cpCost": 20, },
0xE8: { "idMostSigNib": 0, "idLeastSigByte": 0xE8, "name": "Aero", "value": 2, "type": "Magic", "cpCost": 22, },
0xE9: { "idMostSigNib": 0, "idLeastSigByte": 0xE9, "name": "Aero", "value": 3, "type": "Magic", "cpCost": 24, },
0xEA: { "idMostSigNib": 0, "idLeastSigByte": 0xEA, "name": "Aero", "value": 4, "type": "Magic", "cpCost": 26, },
0xEB: { "idMostSigNib": 0, "idLeastSigByte": 0xEB, "name": "Aero", "value": 5, "type": "Magic", "cpCost": 28, },
0xEC: { "idMostSigNib": 0, "idLeastSigByte": 0xEC, "name": "Aero", "value": 6, "type": "Magic", "cpCost": 30, },
0xED: { "idMostSigNib": 0, "idLeastSigByte": 0xED, "name": "Aero", "value": 7, "type": "Magic", "cpCost": 32, },
0xEE: { "idMostSigNib": 0, "idLeastSigByte": 0xEE, "name": "Aero", "value": 8, "type": "Magic", "cpCost": 34, },
0xEF: { "idMostSigNib": 0, "idLeastSigByte": 0xEF, "name": "Aero", "value": 9, "type": "Magic", "cpCost": 36, },
0xF0: { "idMostSigNib": 0, "idLeastSigByte": 0xF0, "name": "Donald Duck", "value": 0, "type": "Friend", "cpCost": 38, },
0xF1: { "idMostSigNib": 0, "idLeastSigByte": 0xF1, "name": "Donald Duck", "value": 1, "type": "Friend", "cpCost": 20, },
0xF2: { "idMostSigNib": 0, "idLeastSigByte": 0xF2, "name": "Donald Duck", "value": 2, "type": "Friend", "cpCost": 22, },
0xF3: { "idMostSigNib": 0, "idLeastSigByte": 0xF3, "name": "Donald Duck", "value": 3, "type": "Friend", "cpCost": 24, },
0xF4: { "idMostSigNib": 0, "idLeastSigByte": 0xF4, "name": "Donald Duck", "value": 4, "type": "Friend", "cpCost": 26, },
0xF5: { "idMostSigNib": 0, "idLeastSigByte": 0xF5, "name": "Donald Duck", "value": 5, "type": "Friend", "cpCost": 28, },
0xF6: { "idMostSigNib": 0, "idLeastSigByte": 0xF6, "name": "Donald Duck", "value": 6, "type": "Friend", "cpCost": 30, },
0xF7: { "idMostSigNib": 0, "idLeastSigByte": 0xF7, "name": "Donald Duck", "value": 7, "type": "Friend", "cpCost": 32, },
0xF8: { "idMostSigNib": 0, "idLeastSigByte": 0xF8, "name": "Donald Duck", "value": 8, "type": "Friend", "cpCost": 34, },
0xF9: { "idMostSigNib": 0, "idLeastSigByte": 0xF9, "name": "Donald Duck", "value": 9, "type": "Friend", "cpCost": 36, },
0xFA: { "idMostSigNib": 0, "idLeastSigByte": 0xFA, "name": "Goofy", "value": 0, "type": "Friend", "cpCost": 38, },
0xFB: { "idMostSigNib": 0, "idLeastSigByte": 0xFB, "name": "Goofy", "value": 1, "type": "Friend", "cpCost": 20, },
0xFC: { "idMostSigNib": 0, "idLeastSigByte": 0xFC, "name": "Goofy", "value": 2, "type": "Friend", "cpCost": 22, },
0xFD: { "idMostSigNib": 0, "idLeastSigByte": 0xFD, "name": "Goofy", "value": 3, "type": "Friend", "cpCost": 24, },
0xFE: { "idMostSigNib": 0, "idLeastSigByte": 0xFE, "name": "Goofy", "value": 4, "type": "Friend", "cpCost": 26, },
0xFF: { "idMostSigNib": 0, "idLeastSigByte": 0xFF, "name": "Goofy", "value": 5, "type": "Friend", "cpCost": 28, },
0x100: { "idMostSigNib": 1, "idLeastSigByte": 0x0, "name": "Goofy", "value": 6, "type": "Friend", "cpCost": 30, },
0x101: { "idMostSigNib": 1, "idLeastSigByte": 0x1, "name": "Goofy", "value": 7, "type": "Friend", "cpCost": 32, },
0x102: { "idMostSigNib": 1, "idLeastSigByte": 0x2, "name": "Goofy", "value": 8, "type": "Friend", "cpCost": 34, },
0x103: { "idMostSigNib": 1, "idLeastSigByte": 0x3, "name": "Goofy", "value": 9, "type": "Friend", "cpCost": 36, },
0x104: { "idMostSigNib": 1, "idLeastSigByte": 0x4, "name": "Simba", "value": 0, "type": "Magic", "cpCost": 38, },
0x105: { "idMostSigNib": 1, "idLeastSigByte": 0x5, "name": "Simba", "value": 1, "type": "Magic", "cpCost": 20, },
0x106: { "idMostSigNib": 1, "idLeastSigByte": 0x6, "name": "Simba", "value": 2, "type": "Magic", "cpCost": 22, },
0x107: { "idMostSigNib": 1, "idLeastSigByte": 0x7, "name": "Simba", "value": 3, "type": "Magic", "cpCost": 24, },
0x108: { "idMostSigNib": 1, "idLeastSigByte": 0x8, "name": "Simba", "value": 4, "type": "Magic", "cpCost": 26, },
0x109: { "idMostSigNib": 1, "idLeastSigByte": 0x9, "name": "Simba", "value": 5, "type": "Magic", "cpCost": 28, },
0x10A: { "idMostSigNib": 1, "idLeastSigByte": 0xA, "name": "Simba", "value": 6, "type": "Magic", "cpCost": 30, },
0x10B: { "idMostSigNib": 1, "idLeastSigByte": 0xB, "name": "Simba", "value": 7, "type": "Magic", "cpCost": 32, },
0x10C: { "idMostSigNib": 1, "idLeastSigByte": 0xC, "name": "Simba", "value": 8, "type": "Magic", "cpCost": 34, },
0x10D: { "idMostSigNib": 1, "idLeastSigByte": 0xD, "name": "Simba", "value": 9, "type": "Magic", "cpCost": 36, },
0x10E: { "idMostSigNib": 1, "idLeastSigByte": 0xE, "name": "Genie", "value": 0, "type": "Magic", "cpCost": 38, },
0x10F: { "idMostSigNib": 1, "idLeastSigByte": 0xF, "name": "Genie", "value": 1, "type": "Magic", "cpCost": 20, },
0x110: { "idMostSigNib": 1, "idLeastSigByte": 0x10, "name": "Genie", "value": 2, "type": "Magic", "cpCost": 22, },
0x111: { "idMostSigNib": 1, "idLeastSigByte": 0x11, "name": "Genie", "value": 3, "type": "Magic", "cpCost": 24, },
0x112: { "idMostSigNib": 1, "idLeastSigByte": 0x12, "name": "Genie", "value": 4, "type": "Magic", "cpCost": 26, },
0x113: { "idMostSigNib": 1, "idLeastSigByte": 0x13, "name": "Genie", "value": 5, "type": "Magic", "cpCost": 28, },
0x114: { "idMostSigNib": 1, "idLeastSigByte": 0x14, "name": "Genie", "value": 6, "type": "Magic", "cpCost": 30, },
0x115: { "idMostSigNib": 1, "idLeastSigByte": 0x15, "name": "Genie", "value": 7, "type": "Magic", "cpCost": 32, },
0x116: { "idMostSigNib": 1, "idLeastSigByte": 0x16, "name": "Genie", "value": 8, "type": "Magic", "cpCost": 34, },
0x117: { "idMostSigNib": 1, "idLeastSigByte": 0x17, "name": "Genie", "value": 9, "type": "Magic", "cpCost": 36, },
0x118: { "idMostSigNib": 1, "idLeastSigByte": 0x18, "name": "Bambi", "value": 0, "type": "Magic", "cpCost": 38, },
0x119: { "idMostSigNib": 1, "idLeastSigByte": 0x19, "name": "Bambi", "value": 1, "type": "Magic", "cpCost": 20, },
0x11A: { "idMostSigNib": 1, "idLeastSigByte": 0x1A, "name": "Bambi", "value": 2, "type": "Magic", "cpCost": 22, },
0x11B: { "idMostSigNib": 1, "idLeastSigByte": 0x1B, "name": "Bambi", "value": 3, "type": "Magic", "cpCost": 24, },
0x11C: { "idMostSigNib": 1, "idLeastSigByte": 0x1C, "name": "Bambi", "value": 4, "type": "Magic", "cpCost": 26, },
0x11D: { "idMostSigNib": 1, "idLeastSigByte": 0x1D, "name": "Bambi", "value": 5, "type": "Magic", "cpCost": 28, },
0x11E: { "idMostSigNib": 1, "idLeastSigByte": 0x1E, "name": "Bambi", "value": 6, "type": "Magic", "cpCost": 30, },
0x11F: { "idMostSigNib": 1, "idLeastSigByte": 0x1F, "name": "Bambi", "value": 7, "type": "Magic", "cpCost": 32, },
0x120: { "idMostSigNib": 1, "idLeastSigByte": 0x20, "name": "Bambi", "value": 8, "type": "Magic", "cpCost": 34, },
0x121: { "idMostSigNib": 1, "idLeastSigByte": 0x21, "name": "Bambi", "value": 9, "type": "Magic", "cpCost": 36, },
0x122: { "idMostSigNib": 1, "idLeastSigByte": 0x22, "name": "Dumbo", "value": 0, "type": "Magic", "cpCost": 38, },
0x123: { "idMostSigNib": 1, "idLeastSigByte": 0x23, "name": "Dumbo", "value": 1, "type": "Magic", "cpCost": 20, },
0x124: { "idMostSigNib": 1, "idLeastSigByte": 0x24, "name": "Dumbo", "value": 2, "type": "Magic", "cpCost": 22, },
0x125: { "idMostSigNib": 1, "idLeastSigByte": 0x25, "name": "Dumbo", "value": 3, "type": "Magic", "cpCost": 24, },
0x126: { "idMostSigNib": 1, "idLeastSigByte": 0x26, "name": "Dumbo", "value": 4, "type": "Magic", "cpCost": 26, },
0x127: { "idMostSigNib": 1, "idLeastSigByte": 0x27, "name": "Dumbo", "value": 5, "type": "Magic", "cpCost": 28, },
0x128: { "idMostSigNib": 1, "idLeastSigByte": 0x28, "name": "Dumbo", "value": 6, "type": "Magic", "cpCost": 30, },
0x129: { "idMostSigNib": 1, "idLeastSigByte": 0x29, "name": "Dumbo", "value": 7, "type": "Magic", "cpCost": 32, },
0x12A: { "idMostSigNib": 1, "idLeastSigByte": 0x2A, "name": "Dumbo", "value": 8, "type": "Magic", "cpCost": 34, },
0x12B: { "idMostSigNib": 1, "idLeastSigByte": 0x2B, "name": "Dumbo", "value": 9, "type": "Magic", "cpCost": 36, },
0x12C: { "idMostSigNib": 1, "idLeastSigByte": 0x2C, "name": "Tinker Bell", "value": 0, "type": "Magic", "cpCost": 38, },
0x12D: { "idMostSigNib": 1, "idLeastSigByte": 0x2D, "name": "Tinker Bell", "value": 1, "type": "Magic", "cpCost": 20, },
0x12E: { "idMostSigNib": 1, "idLeastSigByte": 0x2E, "name": "Tinker Bell", "value": 2, "type": "Magic", "cpCost": 22, },
0x12F: { "idMostSigNib": 1, "idLeastSigByte": 0x2F, "name": "Tinker Bell", "value": 3, "type": "Magic", "cpCost": 24, },
0x130: { "idMostSigNib": 1, "idLeastSigByte": 0x30, "name": "Tinker Bell", "value": 4, "type": "Magic", "cpCost": 26, },
0x131: { "idMostSigNib": 1, "idLeastSigByte": 0x31, "name": "Tinker Bell", "value": 5, "type": "Magic", "cpCost": 28, },
0x132: { "idMostSigNib": 1, "idLeastSigByte": 0x32, "name": "Tinker Bell", "value": 6, "type": "Magic", "cpCost": 30, },
0x133: { "idMostSigNib": 1, "idLeastSigByte": 0x33, "name": "Tinker Bell", "value": 7, "type": "Magic", "cpCost": 32, },
0x134: { "idMostSigNib": 1, "idLeastSigByte": 0x34, "name": "Tinker Bell", "value": 8, "type": "Magic", "cpCost": 34, },
0x135: { "idMostSigNib": 1, "idLeastSigByte": 0x35, "name": "Tinker Bell", "value": 9, "type": "Magic", "cpCost": 36, },
0x136: { "idMostSigNib": 1, "idLeastSigByte": 0x36, "name": "Mushu", "value": 0, "type": "Magic", "cpCost": 43, },
0x137: { "idMostSigNib": 1, "idLeastSigByte": 0x37, "name": "Mushu", "value": 1, "type": "Magic", "cpCost": 25, },
0x138: { "idMostSigNib": 1, "idLeastSigByte": 0x38, "name": "Mushu", "value": 2, "type": "Magic", "cpCost": 27, },
0x139: { "idMostSigNib": 1, "idLeastSigByte": 0x39, "name": "Mushu", "value": 3, "type": "Magic", "cpCost": 29, },
0x13A: { "idMostSigNib": 1, "idLeastSigByte": 0x3A, "name": "Mushu", "value": 4, "type": "Magic", "cpCost": 31, },
0x13B: { "idMostSigNib": 1, "idLeastSigByte": 0x3B, "name": "Mushu", "value": 5, "type": "Magic", "cpCost": 33, },
0x13C: { "idMostSigNib": 1, "idLeastSigByte": 0x3C, "name": "Mushu", "value": 6, "type": "Magic", "cpCost": 35, },
0x13D: { "idMostSigNib": 1, "idLeastSigByte": 0x3D, "name": "Mushu", "value": 7, "type": "Magic", "cpCost": 37, },
0x13E: { "idMostSigNib": 1, "idLeastSigByte": 0x3E, "name": "Mushu", "value": 8, "type": "Magic", "cpCost": 39, },
0x13F: { "idMostSigNib": 1, "idLeastSigByte": 0x3F, "name": "Mushu", "value": 9, "type": "Magic", "cpCost": 41, },
0x140: { "idMostSigNib": 1, "idLeastSigByte": 0x40, "name": "Cloud", "value": 0, "type": "Magic", "cpCost": 43, },
0x141: { "idMostSigNib": 1, "idLeastSigByte": 0x41, "name": "Cloud", "value": 1, "type": "Magic", "cpCost": 25, },
0x142: { "idMostSigNib": 1, "idLeastSigByte": 0x42, "name": "Cloud", "value": 2, "type": "Magic", "cpCost": 27, },
0x143: { "idMostSigNib": 1, "idLeastSigByte": 0x43, "name": "Cloud", "value": 3, "type": "Magic", "cpCost": 29, },
0x144: { "idMostSigNib": 1, "idLeastSigByte": 0x44, "name": "Cloud", "value": 4, "type": "Magic", "cpCost": 31, },
0x145: { "idMostSigNib": 1, "idLeastSigByte": 0x45, "name": "Cloud", "value": 5, "type": "Magic", "cpCost": 33, },
0x146: { "idMostSigNib": 1, "idLeastSigByte": 0x46, "name": "Cloud", "value": 6, "type": "Magic", "cpCost": 35, },
0x147: { "idMostSigNib": 1, "idLeastSigByte": 0x47, "name": "Cloud", "value": 7, "type": "Magic", "cpCost": 37, },
0x148: { "idMostSigNib": 1, "idLeastSigByte": 0x48, "name": "Cloud", "value": 8, "type": "Magic", "cpCost": 39, },
0x149: { "idMostSigNib": 1, "idLeastSigByte": 0x49, "name": "Cloud", "value": 9, "type": "Magic", "cpCost": 41, },
0x14A: { "idMostSigNib": 1, "idLeastSigByte": 0x4A, "name": "Aladdin", "value": 0, "type": "Friend", "cpCost": 43, },
0x14B: { "idMostSigNib": 1, "idLeastSigByte": 0x4B, "name": "Aladdin", "value": 1, "type": "Friend", "cpCost": 25, },
0x14C: { "idMostSigNib": 1, "idLeastSigByte": 0x4C, "name": "Aladdin", "value": 2, "type": "Friend", "cpCost": 27, },
0x14D: { "idMostSigNib": 1, "idLeastSigByte": 0x4D, "name": "Aladdin", "value": 3, "type": "Friend", "cpCost": 29, },
0x14E: { "idMostSigNib": 1, "idLeastSigByte": 0x4E, "name": "Aladdin", "value": 4, "type": "Friend", "cpCost": 31, },
0x14F: { "idMostSigNib": 1, "idLeastSigByte": 0x4F, "name": "Aladdin", "value": 5, "type": "Friend", "cpCost": 33, },
0x150: { "idMostSigNib": 1, "idLeastSigByte": 0x50, "name": "Aladdin", "value": 6, "type": "Friend", "cpCost": 35, },
0x151: { "idMostSigNib": 1, "idLeastSigByte": 0x51, "name": "Aladdin", "value": 7, "type": "Friend", "cpCost": 37, },
0x152: { "idMostSigNib": 1, "idLeastSigByte": 0x52, "name": "Aladdin", "value": 8, "type": "Friend", "cpCost": 39, },
0x153: { "idMostSigNib": 1, "idLeastSigByte": 0x53, "name": "Aladdin", "value": 9, "type": "Friend", "cpCost": 41, },
0x154: { "idMostSigNib": 1, "idLeastSigByte": 0x54, "name": "Ariel", "value": 0, "type": "Friend", "cpCost": 43, },
0x155: { "idMostSigNib": 1, "idLeastSigByte": 0x55, "name": "Ariel", "value": 1, "type": "Friend", "cpCost": 25, },
0x156: { "idMostSigNib": 1, "idLeastSigByte": 0x56, "name": "Ariel", "value": 2, "type": "Friend", "cpCost": 27, },
0x157: { "idMostSigNib": 1, "idLeastSigByte": 0x57, "name": "Ariel", "value": 3, "type": "Friend", "cpCost": 29, },
0x158: { "idMostSigNib": 1, "idLeastSigByte": 0x58, "name": "Ariel", "value": 4, "type": "Friend", "cpCost": 31, },
0x159: { "idMostSigNib": 1, "idLeastSigByte": 0x59, "name": "Ariel", "value": 5, "type": "Friend", "cpCost": 33, },
0x15A: { "idMostSigNib": 1, "idLeastSigByte": 0x5A, "name": "Ariel", "value": 6, "type": "Friend", "cpCost": 35, },
0x15B: { "idMostSigNib": 1, "idLeastSigByte": 0x5B, "name": "Ariel", "value": 7, "type": "Friend", "cpCost": 37, },
0x15C: { "idMostSigNib": 1, "idLeastSigByte": 0x5C, "name": "Ariel", "value": 8, "type": "Friend", "cpCost": 39, },
0x15D: { "idMostSigNib": 1, "idLeastSigByte": 0x5D, "name": "Ariel", "value": 9, "type": "Friend", "cpCost": 41, },
0x15E: { "idMostSigNib": 1, "idLeastSigByte": 0x5E, "name": "Jack", "value": 0, "type": "Friend", "cpCost": 43, },
0x15F: { "idMostSigNib": 1, "idLeastSigByte": 0x5F, "name": "Jack", "value": 1, "type": "Friend", "cpCost": 25, },
0x160: { "idMostSigNib": 1, "idLeastSigByte": 0x60, "name": "Jack", "value": 2, "type": "Friend", "cpCost": 27, },
0x161: { "idMostSigNib": 1, "idLeastSigByte": 0x61, "name": "Jack", "value": 3, "type": "Friend", "cpCost": 29, },
0x162: { "idMostSigNib": 1, "idLeastSigByte": 0x62, "name": "Jack", "value": 4, "type": "Friend", "cpCost": 31, },
0x163: { "idMostSigNib": 1, "idLeastSigByte": 0x63, "name": "Jack", "value": 5, "type": "Friend", "cpCost": 33, },
0x164: { "idMostSigNib": 1, "idLeastSigByte": 0x64, "name": "Jack", "value": 6, "type": "Friend", "cpCost": 35, },
0x165: { "idMostSigNib": 1, "idLeastSigByte": 0x65, "name": "Jack", "value": 7, "type": "Friend", "cpCost": 37, },
0x166: { "idMostSigNib": 1, "idLeastSigByte": 0x66, "name": "Jack", "value": 8, "type": "Friend", "cpCost": 39, },
0x167: { "idMostSigNib": 1, "idLeastSigByte": 0x67, "name": "Jack", "value": 9, "type": "Friend", "cpCost": 41, },
0x168: { "idMostSigNib": 1, "idLeastSigByte": 0x68, "name": "Peter Pan", "value": 0, "type": "Friend", "cpCost": 43, },
0x169: { "idMostSigNib": 1, "idLeastSigByte": 0x69, "name": "Peter Pan", "value": 1, "type": "Friend", "cpCost": 25, },
0x16A: { "idMostSigNib": 1, "idLeastSigByte": 0x6A, "name": "Peter Pan", "value": 2, "type": "Friend", "cpCost": 27, },
0x16B: { "idMostSigNib": 1, "idLeastSigByte": 0x6B, "name": "Peter Pan", "value": 3, "type": "Friend", "cpCost": 29, },
0x16C: { "idMostSigNib": 1, "idLeastSigByte": 0x6C, "name": "Peter Pan", "value": 4, "type": "Friend", "cpCost": 31, },
0x16D: { "idMostSigNib": 1, "idLeastSigByte": 0x6D, "name": "Peter Pan", "value": 5, "type": "Friend", "cpCost": 33, },
0x16E: { "idMostSigNib": 1, "idLeastSigByte": 0x6E, "name": "Peter Pan", "value": 6, "type": "Friend", "cpCost": 35, },
0x16F: { "idMostSigNib": 1, "idLeastSigByte": 0x6F, "name": "Peter Pan", "value": 7, "type": "Friend", "cpCost": 37, },
0x170: { "idMostSigNib": 1, "idLeastSigByte": 0x70, "name": "Peter Pan", "value": 8, "type": "Friend", "cpCost": 39, },
0x171: { "idMostSigNib": 1, "idLeastSigByte": 0x71, "name": "Peter Pan", "value": 9, "type": "Friend", "cpCost": 41, },
0x172: { "idMostSigNib": 1, "idLeastSigByte": 0x72, "name": "The Beast", "value": 0, "type": "Friend", "cpCost": 43, },
0x173: { "idMostSigNib": 1, "idLeastSigByte": 0x73, "name": "The Beast", "value": 1, "type": "Friend", "cpCost": 25, },
0x174: { "idMostSigNib": 1, "idLeastSigByte": 0x74, "name": "The Beast", "value": 2, "type": "Friend", "cpCost": 27, },
0x175: { "idMostSigNib": 1, "idLeastSigByte": 0x75, "name": "The Beast", "value": 3, "type": "Friend", "cpCost": 29, },
0x176: { "idMostSigNib": 1, "idLeastSigByte": 0x76, "name": "The Beast", "value": 4, "type": "Friend", "cpCost": 31, },
0x177: { "idMostSigNib": 1, "idLeastSigByte": 0x77, "name": "The Beast", "value": 5, "type": "Friend", "cpCost": 33, },
0x178: { "idMostSigNib": 1, "idLeastSigByte": 0x78, "name": "The Beast", "value": 6, "type": "Friend", "cpCost": 35, },
0x179: { "idMostSigNib": 1, "idLeastSigByte": 0x79, "name": "The Beast", "value": 7, "type": "Friend", "cpCost": 37, },
0x17A: { "idMostSigNib": 1, "idLeastSigByte": 0x7A, "name": "The Beast", "value": 8, "type": "Friend", "cpCost": 39, },
0x17B: { "idMostSigNib": 1, "idLeastSigByte": 0x7B, "name": "The Beast", "value": 9, "type": "Friend", "cpCost": 41, },
0x17C: { "idMostSigNib": 1, "idLeastSigByte": 0x7C, "name": "Potion", "value": 0, "type": "Item", "cpCost": 57, },
0x17D: { "idMostSigNib": 1, "idLeastSigByte": 0x7D, "name": "Potion", "value": 1, "type": "Item", "cpCost": 30, },
0x17E: { "idMostSigNib": 1, "idLeastSigByte": 0x7E, "name": "Potion", "value": 2, "type": "Item", "cpCost": 33, },
0x17F: { "idMostSigNib": 1, "idLeastSigByte": 0x7F, "name": "Potion", "value": 3, "type": "Item", "cpCost": 36, },
0x180: { "idMostSigNib": 1, "idLeastSigByte": 0x80, "name": "Potion", "value": 4, "type": "Item", "cpCost": 39, },
0x181: { "idMostSigNib": 1, "idLeastSigByte": 0x81, "name": "Potion", "value": 5, "type": "Item", "cpCost": 42, },
0x182: { "idMostSigNib": 1, "idLeastSigByte": 0x82, "name": "Potion", "value": 6, "type": "Item", "cpCost": 45, },
0x183: { "idMostSigNib": 1, "idLeastSigByte": 0x83, "name": "Potion", "value": 7, "type": "Item", "cpCost": 48, },
0x184: { "idMostSigNib": 1, "idLeastSigByte": 0x84, "name": "Potion", "value": 8, "type": "Item", "cpCost": 51, },
0x185: { "idMostSigNib": 1, "idLeastSigByte": 0x85, "name": "Potion", "value": 9, "type": "Item", "cpCost": 54, },
0x186: { "idMostSigNib": 1, "idLeastSigByte": 0x86, "name": "Hi-Potion", "value": 0, "type": "Item", "cpCost": 76, },
0x187: { "idMostSigNib": 1, "idLeastSigByte": 0x87, "name": "Hi-Potion", "value": 1, "type": "Item", "cpCost": 40, },
0x188: { "idMostSigNib": 1, "idLeastSigByte": 0x88, "name": "Hi-Potion", "value": 2, "type": "Item", "cpCost": 44, },
0x189: { "idMostSigNib": 1, "idLeastSigByte": 0x89, "name": "Hi-Potion", "value": 3, "type": "Item", "cpCost": 48, },
0x18A: { "idMostSigNib": 1, "idLeastSigByte": 0x8A, "name": "Hi-Potion", "value": 4, "type": "Item", "cpCost": 52, },
0x18B: { "idMostSigNib": 1, "idLeastSigByte": 0x8B, "name": "Hi-Potion", "value": 5, "type": "Item", "cpCost": 56, },
0x18C: { "idMostSigNib": 1, "idLeastSigByte": 0x8C, "name": "Hi-Potion", "value": 6, "type": "Item", "cpCost": 60, },
0x18D: { "idMostSigNib": 1, "idLeastSigByte": 0x8D, "name": "Hi-Potion", "value": 7, "type": "Item", "cpCost": 64, },
0x18E: { "idMostSigNib": 1, "idLeastSigByte": 0x8E, "name": "Hi-Potion", "value": 8, "type": "Item", "cpCost": 68, },
0x18F: { "idMostSigNib": 1, "idLeastSigByte": 0x8F, "name": "Hi-Potion", "value": 9, "type": "Item", "cpCost": 72, },
0x190: { "idMostSigNib": 1, "idLeastSigByte": 0x90, "name": "Mega-Potion", "value": 0, "type": "Item", "cpCost": 81, },
0x191: { "idMostSigNib": 1, "idLeastSigByte": 0x91, "name": "Mega-Potion", "value": 1, "type": "Item", "cpCost": 45, },
0x192: { "idMostSigNib": 1, "idLeastSigByte": 0x92, "name": "Mega-Potion", "value": 2, "type": "Item", "cpCost": 49, },
0x193: { "idMostSigNib": 1, "idLeastSigByte": 0x93, "name": "Mega-Potion", "value": 3, "type": "Item", "cpCost": 53, },
0x194: { "idMostSigNib": 1, "idLeastSigByte": 0x94, "name": "Mega-Potion", "value": 4, "type": "Item", "cpCost": 57, },
0x195: { "idMostSigNib": 1, "idLeastSigByte": 0x95, "name": "Mega-Potion", "value": 5, "type": "Item", "cpCost": 61, },
0x196: { "idMostSigNib": 1, "idLeastSigByte": 0x96, "name": "Mega-Potion", "value": 6, "type": "Item", "cpCost": 65, },
0x197: { "idMostSigNib": 1, "idLeastSigByte": 0x97, "name": "Mega-Potion", "value": 7, "type": "Item", "cpCost": 69, },
0x198: { "idMostSigNib": 1, "idLeastSigByte": 0x98, "name": "Mega-Potion", "value": 8, "type": "Item", "cpCost": 73, },
0x199: { "idMostSigNib": 1, "idLeastSigByte": 0x99, "name": "Mega-Potion", "value": 9, "type": "Item", "cpCost": 77, },
0x19A: { "idMostSigNib": 1, "idLeastSigByte": 0x9A, "name": "Ether", "value": 0, "type": "Item", "cpCost": 38, },
0x19B: { "idMostSigNib": 1, "idLeastSigByte": 0x9B, "name": "Ether", "value": 1, "type": "Item", "cpCost": 20, },
0x19C: { "idMostSigNib": 1, "idLeastSigByte": 0x9C, "name": "Ether", "value": 2, "type": "Item", "cpCost": 22, },
0x19D: { "idMostSigNib": 1, "idLeastSigByte": 0x9D, "name": "Ether", "value": 3, "type": "Item", "cpCost": 24, },
0x19E: { "idMostSigNib": 1, "idLeastSigByte": 0x9E, "name": "Ether", "value": 4, "type": "Item", "cpCost": 26, },
0x19F: { "idMostSigNib": 1, "idLeastSigByte": 0x9F, "name": "Ether", "value": 5, "type": "Item", "cpCost": 28, },
0x1A0: { "idMostSigNib": 1, "idLeastSigByte": 0xA0, "name": "Ether", "value": 6, "type": "Item", "cpCost": 30, },
0x1A1: { "idMostSigNib": 1, "idLeastSigByte": 0xA1, "name": "Ether", "value": 7, "type": "Item", "cpCost": 32, },
0x1A2: { "idMostSigNib": 1, "idLeastSigByte": 0xA2, "name": "Ether", "value": 8, "type": "Item", "cpCost": 34, },
0x1A3: { "idMostSigNib": 1, "idLeastSigByte": 0xA3, "name": "Ether", "value": 9, "type": "Item", "cpCost": 36, },
0x1A4: { "idMostSigNib": 1, "idLeastSigByte": 0xA4, "name": "Mega-Ether", "value": 0, "type": "Item", "cpCost": 62, },
0x1A5: { "idMostSigNib": 1, "idLeastSigByte": 0xA5, "name": "Mega-Ether", "value": 1, "type": "Item", "cpCost": 35, },
0x1A6: { "idMostSigNib": 1, "idLeastSigByte": 0xA6, "name": "Mega-Ether", "value": 2, "type": "Item", "cpCost": 38, },
0x1A7: { "idMostSigNib": 1, "idLeastSigByte": 0xA7, "name": "Mega-Ether", "value": 3, "type": "Item", "cpCost": 41, },
0x1A8: { "idMostSigNib": 1, "idLeastSigByte": 0xA8, "name": "Mega-Ether", "value": 4, "type": "Item", "cpCost": 44, },
0x1A9: { "idMostSigNib": 1, "idLeastSigByte": 0xA9, "name": "Mega-Ether", "value": 5, "type": "Item", "cpCost": 47, },
0x1AA: { "idMostSigNib": 1, "idLeastSigByte": 0xAA, "name": "Mega-Ether", "value": 6, "type": "Item", "cpCost": 50, },
0x1AB: { "idMostSigNib": 1, "idLeastSigByte": 0xAB, "name": "Mega-Ether", "value": 7, "type": "Item", "cpCost": 53, },
0x1AC: { "idMostSigNib": 1, "idLeastSigByte": 0xAC, "name": "Mega-Ether", "value": 8, "type": "Item", "cpCost": 56, },
0x1AD: { "idMostSigNib": 1, "idLeastSigByte": 0xAD, "name": "Mega-Ether", "value": 9, "type": "Item", "cpCost": 59, },
0x1AE: { "idMostSigNib": 1, "idLeastSigByte": 0xAE, "name": "Elixir", "value": 0, "type": "Item", "cpCost": 81, },
0x1AF: { "idMostSigNib": 1, "idLeastSigByte": 0xAF, "name": "Elixir", "value": 1, "type": "Item", "cpCost": 45, },
0x1B0: { "idMostSigNib": 1, "idLeastSigByte": 0xB0, "name": "Elixir", "value": 2, "type": "Item", "cpCost": 49, },
0x1B1: { "idMostSigNib": 1, "idLeastSigByte": 0xB1, "name": "Elixir", "value": 3, "type": "Item", "cpCost": 53, },
0x1B2: { "idMostSigNib": 1, "idLeastSigByte": 0xB2, "name": "Elixir", "value": 4, "type": "Item", "cpCost": 57, },
0x1B3: { "idMostSigNib": 1, "idLeastSigByte": 0xB3, "name": "Elixir", "value": 5, "type": "Item", "cpCost": 61, },
0x1B4: { "idMostSigNib": 1, "idLeastSigByte": 0xB4, "name": "Elixir", "value": 6, "type": "Item", "cpCost": 65, },
0x1B5: { "idMostSigNib": 1, "idLeastSigByte": 0xB5, "name": "Elixir", "value": 7, "type": "Item", "cpCost": 69, },
0x1B6: { "idMostSigNib": 1, "idLeastSigByte": 0xB6, "name": "Elixir", "value": 8, "type": "Item", "cpCost": 73, },
0x1B7: { "idMostSigNib": 1, "idLeastSigByte": 0xB7, "name": "Elixir", "value": 9, "type": "Item", "cpCost": 77, },
0x1B8: { "idMostSigNib": 1, "idLeastSigByte": 0xB8, "name": "Megalixir", "value": 0, "type": "Item", "cpCost": 95, },
0x1B9: { "idMostSigNib": 1, "idLeastSigByte": 0xB9, "name": "Megalixir", "value": 1, "type": "Item", "cpCost": 50, },
0x1BA: { "idMostSigNib": 1, "idLeastSigByte": 0xBA, "name": "Megalixir", "value": 2, "type": "Item", "cpCost": 55, },
0x1BB: { "idMostSigNib": 1, "idLeastSigByte": 0xBB, "name": "Megalixir", "value": 3, "type": "Item", "cpCost": 60, },
0x1BC: { "idMostSigNib": 1, "idLeastSigByte": 0xBC, "name": "Megalixir", "value": 4, "type": "Item", "cpCost": 65, },
0x1BD: { "idMostSigNib": 1, "idLeastSigByte": 0xBD, "name": "Megalixir", "value": 5, "type": "Item", "cpCost": 70, },
0x1BE: { "idMostSigNib": 1, "idLeastSigByte": 0xBE, "name": "Megalixir", "value": 6, "type": "Item", "cpCost": 75, },
0x1BF: { "idMostSigNib": 1, "idLeastSigByte": 0xBF, "name": "Megalixir", "value": 7, "type": "Item", "cpCost": 80, },
0x1C0: { "idMostSigNib": 1, "idLeastSigByte": 0xC0, "name": "Megalixir", "value": 8, "type": "Item", "cpCost": 85, },
0x1C1: { "idMostSigNib": 1, "idLeastSigByte": 0xC1, "name": "Megalixir", "value": 9, "type": "Item", "cpCost": 90, },
0x1C2: { "idMostSigNib": 1, "idLeastSigByte": 0xC2, "name": "Shadow", "value": -1, "type": "Enemy", "cpCost": 25, },
0x1C3: { "idMostSigNib": 1, "idLeastSigByte": 0xC3, "name": "Shadow", "value": -1, "type": "Enemy", "cpCost": 25, },
0x1C4: { "idMostSigNib": 1, "idLeastSigByte": 0xC4, "name": "Shadow", "value": -1, "type": "Enemy", "cpCost": 25, },
0x1C5: { "idMostSigNib": 1, "idLeastSigByte": 0xC5, "name": "Soldier", "value": -1, "type": "Enemy", "cpCost": 25, },
0x1C6: { "idMostSigNib": 1, "idLeastSigByte": 0xC6, "name": "Soldier", "value": -1, "type": "Enemy", "cpCost": 25, },
0x1C7: { "idMostSigNib": 1, "idLeastSigByte": 0xC7, "name": "Soldier", "value": -1, "type": "Enemy", "cpCost": 25, },
0x1C8: { "idMostSigNib": 1, "idLeastSigByte": 0xC8, "name": "Large Body", "value": -1, "type": "Enemy", "cpCost": 40, },
0x1C9: { "idMostSigNib": 1, "idLeastSigByte": 0xC9, "name": "Large Body", "value": -1, "type": "Enemy", "cpCost": 40, },
0x1CA: { "idMostSigNib": 1, "idLeastSigByte": 0xCA, "name": "Large Body", "value": -1, "type": "Enemy", "cpCost": 40, },
0x1CB: { "idMostSigNib": 1, "idLeastSigByte": 0xCB, "name": "Red Nocturne", "value": -1, "type": "Enemy", "cpCost": 20, },
0x1CC: { "idMostSigNib": 1, "idLeastSigByte": 0xCC, "name": "Red Nocturne", "value": -1, "type": "Enemy", "cpCost": 20, },
0x1CD: { "idMostSigNib": 1, "idLeastSigByte": 0xCD, "name": "Red Nocturne", "value": -1, "type": "Enemy", "cpCost": 20, },
0x1CE: { "idMostSigNib": 1, "idLeastSigByte": 0xCE, "name": "Blue Rhapsody", "value": -1, "type": "Enemy", "cpCost": 20, },
0x1CF: { "idMostSigNib": 1, "idLeastSigByte": 0xCF, "name": "Blue Rhapsody", "value": -1, "type": "Enemy", "cpCost": 20, },
0x1D0: { "idMostSigNib": 1, "idLeastSigByte": 0xD0, "name": "Blue Rhapsody", "value": -1, "type": "Enemy", "cpCost": 20, },
0x1D1: { "idMostSigNib": 1, "idLeastSigByte": 0xD1, "name": "Yellow Opera", "value": -1, "type": "Enemy", "cpCost": 20, },
0x1D2: { "idMostSigNib": 1, "idLeastSigByte": 0xD2, "name": "Yellow Opera", "value": -1, "type": "Enemy", "cpCost": 20, },
0x1D3: { "idMostSigNib": 1, "idLeastSigByte": 0xD3, "name": "Yellow Opera", "value": -1, "type": "Enemy", "cpCost": 20, },
0x1D4: { "idMostSigNib": 1, "idLeastSigByte": 0xD4, "name": "Green Requiem", "value": -1, "type": "Enemy", "cpCost": 20, },
0x1D5: { "idMostSigNib": 1, "idLeastSigByte": 0xD5, "name": "Green Requiem", "value": -1, "type": "Enemy", "cpCost": 20, },
0x1D6: { "idMostSigNib": 1, "idLeastSigByte": 0xD6, "name": "Green Requiem", "value": -1, "type": "Enemy", "cpCost": 20, },
0x1D7: { "idMostSigNib": 1, "idLeastSigByte": 0xD7, "name": "Powerwild", "value": -1, "type": "Enemy", "cpCost": 40, },
0x1D8: { "idMostSigNib": 1, "idLeastSigByte": 0xD8, "name": "Powerwild", "value": -1, "type": "Enemy", "cpCost": 40, },
0x1D9: { "idMostSigNib": 1, "idLeastSigByte": 0xD9, "name": "Powerwild", "value": -1, "type": "Enemy", "cpCost": 40, },
0x1DA: { "idMostSigNib": 1, "idLeastSigByte": 0xDA, "name": "Bouncywild", "value": -1, "type": "Enemy", "cpCost": 10, },
0x1DB: { "idMostSigNib": 1, "idLeastSigByte": 0xDB, "name": "Bouncywild", "value": -1, "type": "Enemy", "cpCost": 10, },
0x1DC: { "idMostSigNib": 1, "idLeastSigByte": 0xDC, "name": "Bouncywild", "value": -1, "type": "Enemy", "cpCost": 10, },
0x1DD: { "idMostSigNib": 1, "idLeastSigByte": 0xDD, "name": "Air Soldier", "value": -1, "type": "Enemy", "cpCost": 30, },
0x1DE: { "idMostSigNib": 1, "idLeastSigByte": 0xDE, "name": "Air Soldier", "value": -1, "type": "Enemy", "cpCost": 30, },
0x1DF: { "idMostSigNib": 1, "idLeastSigByte": 0xDF, "name": "Air Soldier", "value": -1, "type": "Enemy", "cpCost": 30, },
0x1E0: { "idMostSigNib": 1, "idLeastSigByte": 0xE0, "name": "Bandit", "value": -1, "type": "Enemy", "cpCost": 30, },
0x1E1: { "idMostSigNib": 1, "idLeastSigByte": 0xE1, "name": "Bandit", "value": -1, "type": "Enemy", "cpCost": 30, },
0x1E2: { "idMostSigNib": 1, "idLeastSigByte": 0xE2, "name": "Bandit", "value": -1, "type": "Enemy", "cpCost": 30, },
0x1E3: { "idMostSigNib": 1, "idLeastSigByte": 0xE3, "name": "Fat Bandit", "value": -1, "type": "Enemy", "cpCost": 40, },
0x1E4: { "idMostSigNib": 1, "idLeastSigByte": 0xE4, "name": "Fat Bandit", "value": -1, "type": "Enemy", "cpCost": 40, },
0x1E5: { "idMostSigNib": 1, "idLeastSigByte": 0xE5, "name": "Fat Bandit", "value": -1, "type": "Enemy", "cpCost": 40, },
0x1E6: { "idMostSigNib": 1, "idLeastSigByte": 0xE6, "name": "Barrel Spider", "value": -1, "type": "Enemy", "cpCost": 30, },
0x1E7: { "idMostSigNib": 1, "idLeastSigByte": 0xE7, "name": "Barrel Spider", "value": -1, "type": "Enemy", "cpCost": 30, },
0x1E8: { "idMostSigNib": 1, "idLeastSigByte": 0xE8, "name": "Barrel Spider", "value": -1, "type": "Enemy", "cpCost": 30, },
0x1E9: { "idMostSigNib": 1, "idLeastSigByte": 0xE9, "name": "Search Ghost", "value": -1, "type": "Enemy", "cpCost": 35, },
0x1EA: { "idMostSigNib": 1, "idLeastSigByte": 0xEA, "name": "Search Ghost", "value": -1, "type": "Enemy", "cpCost": 35, },
0x1EB: { "idMostSigNib": 1, "idLeastSigByte": 0xEB, "name": "Search Ghost", "value": -1, "type": "Enemy", "cpCost": 35, },
0x1EC: { "idMostSigNib": 1, "idLeastSigByte": 0xEC, "name": "Sea Neon", "value": -1, "type": "Enemy", "cpCost": 20, },
0x1ED: { "idMostSigNib": 1, "idLeastSigByte": 0xED, "name": "Sea Neon", "value": -1, "type": "Enemy", "cpCost": 20, },
0x1EE: { "idMostSigNib": 1, "idLeastSigByte": 0xEE, "name": "Sea Neon", "value": -1, "type": "Enemy", "cpCost": 20, },
0x1EF: { "idMostSigNib": 1, "idLeastSigByte": 0xEF, "name": "Screwdiver", "value": -1, "type": "Enemy", "cpCost": 15, },
0x1F0: { "idMostSigNib": 1, "idLeastSigByte": 0xF0, "name": "Screwdiver", "value": -1, "type": "Enemy", "cpCost": 15, },
0x1F1: { "idMostSigNib": 1, "idLeastSigByte": 0xF1, "name": "Screwdiver", "value": -1, "type": "Enemy", "cpCost": 15, },
0x1F2: { "idMostSigNib": 1, "idLeastSigByte": 0xF2, "name": "Aquatank", "value": -1, "type": "Enemy", "cpCost": 30, },
0x1F3: { "idMostSigNib": 1, "idLeastSigByte": 0xF3, "name": "Aquatank", "value": -1, "type": "Enemy", "cpCost": 30, },
0x1F4: { "idMostSigNib": 1, "idLeastSigByte": 0xF4, "name": "Aquatank", "value": -1, "type": "Enemy", "cpCost": 30, },
0x1F5: { "idMostSigNib": 1, "idLeastSigByte": 0xF5, "name": "Wight Night", "value": -1, "type": "Enemy", "cpCost": 15, },
0x1F6: { "idMostSigNib": 1, "idLeastSigByte": 0xF6, "name": "Wight Night", "value": -1, "type": "Enemy", "cpCost": 15, },
0x1F7: { "idMostSigNib": 1, "idLeastSigByte": 0xF7, "name": "Wight Night", "value": -1, "type": "Enemy", "cpCost": 15, },
0x1F8: { "idMostSigNib": 1, "idLeastSigByte": 0xF8, "name": "Gargoyle", "value": -1, "type": "Enemy", "cpCost": 30, },
0x1F9: { "idMostSigNib": 1, "idLeastSigByte": 0xF9, "name": "Gargoyle", "value": -1, "type": "Enemy", "cpCost": 30, },
0x1FA: { "idMostSigNib": 1, "idLeastSigByte": 0xFA, "name": "Gargoyle", "value": -1, "type": "Enemy", "cpCost": 30, },
0x1FB: { "idMostSigNib": 1, "idLeastSigByte": 0xFB, "name": "Pirate", "value": -1, "type": "Enemy", "cpCost": 30, },
0x1FC: { "idMostSigNib": 1, "idLeastSigByte": 0xFC, "name": "Pirate", "value": -1, "type": "Enemy", "cpCost": 30, },
0x1FD: { "idMostSigNib": 1, "idLeastSigByte": 0xFD, "name": "Pirate", "value": -1, "type": "Enemy", "cpCost": 30, },
0x1FE: { "idMostSigNib": 1, "idLeastSigByte": 0xFE, "name": "Air Pirate", "value": -1, "type": "Enemy", "cpCost": 30, },
0x1FF: { "idMostSigNib": 1, "idLeastSigByte": 0xFF, "name": "Air Pirate", "value": -1, "type": "Enemy", "cpCost": 30, },
0x200: { "idMostSigNib": 2, "idLeastSigByte": 0x0, "name": "Air Pirate", "value": -1, "type": "Enemy", "cpCost": 30, },
0x201: { "idMostSigNib": 2, "idLeastSigByte": 0x1, "name": "Darkball", "value": -1, "type": "Enemy", "cpCost": 25, },
0x202: { "idMostSigNib": 2, "idLeastSigByte": 0x2, "name": "Darkball", "value": -1, "type": "Enemy", "cpCost": 25, },
0x203: { "idMostSigNib": 2, "idLeastSigByte": 0x3, "name": "Darkball", "value": -1, "type": "Enemy", "cpCost": 25, },
0x204: { "idMostSigNib": 2, "idLeastSigByte": 0x4, "name": "Defender", "value": -1, "type": "Enemy", "cpCost": 25, },
0x205: { "idMostSigNib": 2, "idLeastSigByte": 0x5, "name": "Defender", "value": -1, "type": "Enemy", "cpCost": 25, },
0x206: { "idMostSigNib": 2, "idLeastSigByte": 0x6, "name": "Defender", "value": -1, "type": "Enemy", "cpCost": 25, },
0x207: { "idMostSigNib": 2, "idLeastSigByte": 0x7, "name": "Wyvern", "value": -1, "type": "Enemy", "cpCost": 25, },
0x208: { "idMostSigNib": 2, "idLeastSigByte": 0x8, "name": "Wyvern", "value": -1, "type": "Enemy", "cpCost": 25, },
0x209: { "idMostSigNib": 2, "idLeastSigByte": 0x9, "name": "Wyvern", "value": -1, "type": "Enemy", "cpCost": 25, },
0x20A: { "idMostSigNib": 2, "idLeastSigByte": 0xA, "name": "Wizard", "value": -1, "type": "Enemy", "cpCost": 30, },
0x20B: { "idMostSigNib": 2, "idLeastSigByte": 0xB, "name": "Wizard", "value": -1, "type": "Enemy", "cpCost": 30, },
0x20C: { "idMostSigNib": 2, "idLeastSigByte": 0xC, "name": "Wizard", "value": -1, "type": "Enemy", "cpCost": 30, },
0x20D: { "idMostSigNib": 2, "idLeastSigByte": 0xD, "name": "Neoshadow", "value": -1, "type": "Enemy", "cpCost": 25, },
0x20E: { "idMostSigNib": 2, "idLeastSigByte": 0xE, "name": "Neoshadow", "value": -1, "type": "Enemy", "cpCost": 25, },
0x20F: { "idMostSigNib": 2, "idLeastSigByte": 0xF, "name": "Neoshadow", "value": -1, "type": "Enemy", "cpCost": 25, },
0x210: { "idMostSigNib": 2, "idLeastSigByte": 0x10, "name": "White Mushroom", "value": -1, "type": "Enemy", "cpCost": 25, },
0x211: { "idMostSigNib": 2, "idLeastSigByte": 0x11, "name": "Black Fungus", "value": -1, "type": "Enemy", "cpCost": 20, },
0x212: { "idMostSigNib": 2, "idLeastSigByte": 0x12, "name": "Black Fungus", "value": -1, "type": "Enemy", "cpCost": 20, },
0x213: { "idMostSigNib": 2, "idLeastSigByte": 0x13, "name": "Black Fungus", "value": -1, "type": "Enemy", "cpCost": 20, },
0x214: { "idMostSigNib": 2, "idLeastSigByte": 0x14, "name": "Creeper Plant", "value": -1, "type": "Enemy", "cpCost": 35, },
0x215: { "idMostSigNib": 2, "idLeastSigByte": 0x15, "name": "Creeper Plant", "value": -1, "type": "Enemy", "cpCost": 35, },
0x216: { "idMostSigNib": 2, "idLeastSigByte": 0x16, "name": "Creeper Plant", "value": -1, "type": "Enemy", "cpCost": 35, },
0x217: { "idMostSigNib": 2, "idLeastSigByte": 0x17, "name": "Tornado Step", "value": -1, "type": "Enemy", "cpCost": 25, },
0x218: { "idMostSigNib": 2, "idLeastSigByte": 0x18, "name": "Tornado Step", "value": -1, "type": "Enemy", "cpCost": 25, },
0x219: { "idMostSigNib": 2, "idLeastSigByte": 0x19, "name": "Tornado Step", "value": -1, "type": "Enemy", "cpCost": 25, },
0x21A: { "idMostSigNib": 2, "idLeastSigByte": 0x1A, "name": "Crescendo", "value": -1, "type": "Enemy", "cpCost": 20, },
0x21B: { "idMostSigNib": 2, "idLeastSigByte": 0x1B, "name": "Crescendo", "value": -1, "type": "Enemy", "cpCost": 20, },
0x21C: { "idMostSigNib": 2, "idLeastSigByte": 0x1C, "name": "Crescendo", "value": -1, "type": "Enemy", "cpCost": 20, },
0x21D: { "idMostSigNib": 2, "idLeastSigByte": 0x1D, "name": "Guard Armor", "value": -1, "type": "Enemy", "cpCost": 30, },
0x21E: { "idMostSigNib": 2, "idLeastSigByte": 0x1E, "name": "Parasite Cage", "value": -1, "type": "Enemy", "cpCost": 60, },
0x21F: { "idMostSigNib": 2, "idLeastSigByte": 0x1F, "name": "Trickmaster", "value": -1, "type": "Enemy", "cpCost": 25, },
0x220: { "idMostSigNib": 2, "idLeastSigByte": 0x20, "name": "Darkside", "value": -1, "type": "Enemy", "cpCost": 99, },
0x221: { "idMostSigNib": 2, "idLeastSigByte": 0x21, "name": "Card Soldier", "value": -1, "type": "Enemy", "cpCost": 55, },
0x222: { "idMostSigNib": 2, "idLeastSigByte": 0x22, "name": "Card Soldier", "value": -1, "type": "Enemy", "cpCost": 55, },
0x223: { "idMostSigNib": 2, "idLeastSigByte": 0x23, "name": "Card Soldier", "value": -1, "type": "Enemy", "cpCost": 55, },
0x224: { "idMostSigNib": 2, "idLeastSigByte": 0x24, "name": "Card Soldier", "value": -1, "type": "Enemy", "cpCost": 55, },
0x225: { "idMostSigNib": 2, "idLeastSigByte": 0x25, "name": "Card Soldier", "value": -1, "type": "Enemy", "cpCost": 55, },
0x226: { "idMostSigNib": 2, "idLeastSigByte": 0x26, "name": "Card Soldier", "value": -1, "type": "Enemy", "cpCost": 55, },
0x227: { "idMostSigNib": 2, "idLeastSigByte": 0x27, "name": "Hades", "value": -1, "type": "Enemy", "cpCost": 40, },
0x228: { "idMostSigNib": 2, "idLeastSigByte": 0x28, "name": "Jafar", "value": -1, "type": "Enemy", "cpCost": 65, },
0x229: { "idMostSigNib": 2, "idLeastSigByte": 0x29, "name": "Oogie Boogie", "value": -1, "type": "Enemy", "cpCost": 40, },
0x22A: { "idMostSigNib": 2, "idLeastSigByte": 0x2A, "name": "Ursula", "value": -1, "type": "Enemy", "cpCost": 50, },
0x22B: { "idMostSigNib": 2, "idLeastSigByte": 0x2B, "name": "Hook", "value": -1, "type": "Enemy", "cpCost": 35, },
0x22C: { "idMostSigNib": 2, "idLeastSigByte": 0x2C, "name": "Dragon Maleficent", "value": -1, "type": "Enemy", "cpCost": 70, },
0x22D: { "idMostSigNib": 2, "idLeastSigByte": 0x2D, "name": "Riku", "value": -1, "type": "Enemy", "cpCost": 80, },
0x22E: { "idMostSigNib": 2, "idLeastSigByte": 0x2E, "name": "Axel", "value": -1, "type": "Enemy", "cpCost": 75, },
0x22F: { "idMostSigNib": 2, "idLeastSigByte": 0x2F, "name": "Larxene", "value": -1, "type": "Enemy", "cpCost": 60, },
0x230: { "idMostSigNib": 2, "idLeastSigByte": 0x30, "name": "Vexen", "value": -1, "type": "Enemy", "cpCost": 60, },
0x231: { "idMostSigNib": 2, "idLeastSigByte": 0x31, "name": "Marluxia", "value": -1, "type": "Enemy", "cpCost": 99, },
0x232: { "idMostSigNib": 2, "idLeastSigByte": 0x32, "name": "Marluxia 2", "value": -1, "type": "Enemy", "cpCost": 0, },
0x233: { "idMostSigNib": 2, "idLeastSigByte": 0x33, "name": "Lexaeus", "value": -1, "type": "Enemy", "cpCost": 99, },
0x234: { "idMostSigNib": 2, "idLeastSigByte": 0x34, "name": "Ansem", "value": -1, "type": "Enemy", "cpCost": 60, },
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

function currentDeck() => byte(0x03cacc)

function deck1TotalCards() => byte(0x0424cc)

function deck2TotalCards() => byte(0x0425ac)

function deck3TotalCards() => byte(0x04268c)

function BossHPValueCheckpointIsSet(bossHp, bossHpMap, worldName, roomId)
{
    trigger = always_false()
    for floor in bossHpMap
    {
        hpValue = bossHpMap[floor]
        trigger = trigger || once(roomId() == roomId && IsInWorld(worldName) && BattleStartedCheckpoint() && IsOnFloor(floor) && bossHp == hpValue)
    }
    
    return trigger
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
function enemyReloadCounter() => word(battlePointer() + 0x80fe)

// One of three pointers that appear to influence battles in some way, like HP and the like
// It's misleading to call it a battle pointer, though, as it does not consistently nullify when in the field. (32-bit)
//
// +0x7e6c to get the player's vertical acceleration when in battle (32-bit)
// +0x7e8c to get the player's current (dynamic) HP when in battle (16-bit)
function playerBattlePointer() => tbyte(0x03ca28)

// One of two pointers that appear related to boss information (32-bit)
//
// +0x7f28 for boss state (8-bit)
// +0x7f74 for boss HP (16-bit)
function bossPointer() => tbyte(0x034988)

function enemyHp() => word(bossPointer() + 0x7f74)

function playerHp() => word(playerBattlePointer() + 0x7e8c)

function bossState() => byte(bossPointer() + 0x7f28)

function IsInBattle() => battlePointer() != 0

function BattleStartedCheckpoint() => once(Delta(battlePointer()) == 0x0 && battlePointer() != 0x0)

function EnemyWasJustDefeated() => EnemyWithSpecificAddressWasJustDefeated(enemyHp())

function EnemyWithSpecificAddressWasJustDefeated(enemyHp) => Delta(enemyHp) > 0 && enemyHp == 0

function shadowJournalEntry() => bit4(0x0422fe)
achievement(
    title = "Heartless Hunter", description = "Defeat your first Heartless in Castle Oblivion.", points = 1,
    id = 15580, badge = "12277", published = "10/16/2014 6:04:37 AM", modified = "11/8/2016 6:46:53 PM",
    trigger = WasBitflagSetInGame(shadowJournalEntry())
)

function guardArmorCardObtained() => bit3(0x04230c)
function UsedGimmickCardWhileFightingGuardArmor() => Delta(bossState()) != 0xa && bossState() == 0xa
achievement(
    title = "No Scheming Allowed [m]", points = 5,
    description = "Defeat the Guard Armor in Sora's story without using any Gimmick Cards.",
    trigger = once(BattleStartedCheckpoint() && IsInWorld("Traverse Town") && enemyHp() == 0xc8) // Battle checkpoint
        && enemyHp() == 0 // Win condition
        && never(UsedGimmickCardWhileFightingGuardArmor()) // Loss condition
        && never(!IsInBattle())
)

function fireCardEntry() => bit0(0x042305)
achievement(
    title = "Memory of Worlds Lost", description = "Complete Traverse Town in Sora's story.", points = 5,
    id = 15582, badge = "14839", published = "10/16/2014 6:06:16 AM", modified = "7/7/2020 2:12:27 AM",
    trigger = roomId() == 0x7 && WasInWorld("Traverse Town") && IsInWorld("Castle Oblivion, Hall") && fireCardEntry() == 0
)

achievement(
    title = "The Flurry of Dancing Flames", description = "Defeat Axel on the first floor.", points = 3,
    id = 15583, badge = "15002", published = "10/16/2014 6:07:43 AM", modified = "7/7/2020 2:12:51 AM",
    trigger = never(!IsInWorld("Castle Oblivion, Hall")) && never(battlefieldId() != 0x0C) && BattleStartedCheckpoint() && EnemyWasJustDefeated()
        && never(!IsInBattle())
)

achievement(title = "Heat-Resistant Glue [m]", description = "Defeat Axel on the first floor without using the D-pad.", points = 5,
    trigger = never(!IsInWorld("Castle Oblivion, Hall")) && never(battlefieldId() != 0x0C) && BattleStartedCheckpoint()
        && EnemyWasJustDefeated() && never(DpadIsPressed()) && never(!IsInBattle())
)

jafarHpMap = {
    2: 0x224,
    3: 0x255,
    4: 0x286,
    5: 0x2b7,
    6: 0x2e8
}

jumpLimit = 45
achievement(title = "Delicate Springs [m]", description = "Defeat Jafar in Sora's story without pressing B more than " + jumpLimit + " times.", points = 10,
    trigger = BossHPValueCheckpointIsSet(enemyHp(), jafarHpMap, "Agrabah", 0x1)
        && EnemyWasJustDefeated() && never(!IsInBattle()) && never(repeated(jumpLimit + 1, Delta(bIsPressed()) != bIsPressed() && bIsPressed() == 1))
)

function agrabahStoryEntry() => bit7(0x0422f4)
achievement(
    title = "Memory of Treasure", description = "Complete Agrabah in Sora's story.", points = 5,
    id = 15584, badge = "14870", published = "10/16/2014 6:07:55 AM", modified = "7/7/2020 2:12:56 AM",
    trigger = WasBitflagSetInGame(agrabahStoryEntry())
)

oogieBoogieHpMap = {
    2: 0x224,
    3: 0x255,
    4: 0x286,
    5: 0x2b7,
    6: 0x2e8
}

achievement(
    title = "Card Disadvantage [m]", points = 10,
    description = "Defeat Oogie Boogie in Sora's story with a deck of only nine cards or less.",
    trigger = BossHPValueCheckpointIsSet(enemyHp(), oogieBoogieHpMap, "Halloween Town", 0x6)
        && EnemyWasJustDefeated() && never(!IsInBattle())
        && (currentDeck() == 0 && deck1TotalCards() <= 9
            || currentDeck() == 1 && deck2TotalCards() <= 9
            || currentDeck() == 2 && deck3TotalCards() <= 9)
)

function halloweenTownEntry() => bit0(0x0422f5)
achievement(
    title = "Memory of Memory", description = "Complete Halloween Town in Sora's story.", points = 5,
    id = 15585, badge = "14878", published = "10/16/2014 6:08:08 AM", modified = "7/7/2020 2:13:00 AM",
    trigger = WasBitflagSetInGame(halloweenTownEntry())
)

timeLimit = 180
function parasiteCageHp() => word(0x039060)
parasiteCageHpMap = {
    2: 0x25b,
    3: 0x291,
    4: 0x2c7,
    5: 0x2fc,
    6: 0x332
}

achievement(title = "Rapid Digestion [m]", description = "Defeat the Parasite Cage in Sora's story within " + SecondsToFormat(timeLimit) + ".",
    points = 5,
    trigger = BossHPValueCheckpointIsSet(parasiteCageHp(), parasiteCageHpMap, "Monstro", 0x4)
        && never(repeated(SecondsToFrames(timeLimit), IsInBattle() && FrameHasAdvanced()))
        && EnemyWithSpecificAddressWasJustDefeated(parasiteCageHp())
        && never(!IsInBattle()) && unless(IsPaused())
)

function monstroEntry() => bit1(0x0422f5)
achievement(
    title = "Memory of a Wish", description = "Complete Monstro in Sora's story.", points = 5,
    id = 15587, badge = "14883", published = "10/16/2014 6:08:32 AM", modified = "7/7/2020 2:13:09 AM",
    trigger = WasBitflagSetInGame(monstroEntry())
)

function cloudHp() => word(0x03abcc)
function cloudMaxHp() => word(0x03abce)
cloudHpMap = {
    2: 0x112,
    3: 0x12a,
    4: 0x143,
    5: 0x15b,
    6: 0x174
}

survivalLimit = 120
function EnoughTimeHasAdvancedForWarOfAttrition() => repeated(SecondsToFrames(survivalLimit), FrameHasAdvanced())
achievement(title = "War of Attrition [m]", points = 5,
    description = "Survive for " + SecondsToFormat(survivalLimit) + " against Cloud without pressing A or stocking cards, and then defeat him.",
    trigger = BossHPValueIsExpected(cloudMaxHp(), cloudHpMap, "Olympus Coliseum", 0x1)
        && EnemyWithSpecificAddressWasJustDefeated(cloudHp())
        && EnoughTimeHasAdvancedForWarOfAttrition() && unless(IsPaused())
        && (
            never(!IsInBattle()) // Reset the pauselock when not in battle.
            // Prevent an A press or stocking of cards to reset the time a player has survived.
            || never(aIsPressed() == 1) && never(Delta(numberOfStockedCardsForPlayer()) != numberOfStockedCardsForPlayer()) && unless(!IsPaused() && EnoughTimeHasAdvancedForWarOfAttrition())
           )
)

function hadesHp() => word(0x03aaec)

hadesHpMap = {
    2: 0x1b7,
    3: 0x1de,
    4: 0x205,
    5: 0x22c,
    6: 0x253
}

achievement(title = "Burning the Candle at Both Ends [m]", points = 10,
    description = "Defeat Hades in Sora's story before he has the chance to reload three times via his reload card.",
    trigger = BossHPValueCheckpointIsSet(hadesHp(), hadesHpMap, "Olympus Coliseum", 0x7)
        && EnemyWithSpecificAddressWasJustDefeated(hadesHp()) && never(!IsInBattle())
        && never(repeated(3, enemyReloadCounter() == 0xffff && Delta(enemyReloadCounter()) != 0xffff))
)

achievement(
    title = "Junior Hero", description = "Beat the Boss in Olympus Coliseum", points = 10,
    id = 15588, badge = "14912", published = "10/16/2014 6:09:40 AM", modified = "7/7/2020 2:13:21 AM",
    trigger = worldId() == 0x03 && battlefieldId() == 0x06 && once(bit4(0x04230C) == 0x0) && bit4(0x04230C) == 0x1 && 
              bit4(0x04232C) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Big Mistake", description = "Against a pack of Card Soldiers", points = 5,
    id = 15589, badge = "14913", published = "10/16/2014 6:09:46 AM", modified = "7/7/2020 2:13:30 AM",
    trigger = worldId() == 0x04 && battlefieldId() == 0x01 && once(bit6(0x042312) == 0x0) && bit6(0x042312) == 0x1 && 
              bit6(0x042332) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Alice in Wonderland", description = "Beat the Boss in Wonderland", points = 10,
    id = 15590, badge = "14924", published = "10/16/2014 6:09:55 AM", modified = "7/7/2020 2:13:36 AM",
    trigger = worldId() == 0x04 && battlefieldId() == 0x01 && once(bit5(0x04230C) == 0x0) && bit5(0x04230C) == 0x1 && 
              bit5(0x04232C) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Savage Nymph ", description = "Defeat Larxene in 7th Floor", points = 10,
    id = 15591, badge = "14925", published = "10/16/2014 6:10:01 AM", modified = "7/7/2020 2:13:41 AM",
    trigger = worldId() == 0x00 && battlefieldId() == 0x0C && once(bit2(0x042305) == 0x0) && bit2(0x042305) == 0x1 && 
              bit2(0x042325) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Friendly Fellows", description = "Get all the upgrades and cards from Pooh friends", points = 10,
    id = 15592, badge = "14926", published = "10/16/2014 6:10:10 AM", modified = "7/7/2020 2:13:48 AM",
    trigger = worldId() <= 0x0D && battlefieldId() == 0x0C && bit2(0x0422D5) == 0x1 && bit5(0x042303) == 0x1 && 
              bit3(0x042307) == 0x1 && bit3(0x0422D6) == 0x1 && bit1(0x0422D5) == 0x1 && bit4(0x0422D5) == 0x1 && bit1(0x042306) == 0x1 && 
              byte(0x042346) == 0x0A
)

achievement(
    title = "Searching for Riku", description = "In the Castle Oblivion...", points = 10,
    id = 15594, badge = "14932", published = "10/16/2014 6:11:05 AM", modified = "7/7/2020 2:13:55 AM",
    trigger = never(worldId() != 0x00) && battlefieldId() == 0x0C && once(bit6(0x042305) == 0x0) && 
              bit6(0x042305) == 0x1 && bit6(0x042325) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Under the Sea", description = "Beat the Boss in Atlantica", points = 10,
    id = 15595, badge = "15004", published = "10/16/2014 6:11:11 AM", modified = "7/7/2020 2:16:28 AM",
    trigger = worldId() == 0x02 && battlefieldId() == 0x04 && once(bit7(0x04230C) == 0x0) && bit7(0x04230C) == 0x1 && 
              bit7(0x04232C) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Finding for Riku", description = "In the Castle Oblivion...", points = 10,
    id = 15596, badge = "15005", published = "10/16/2014 6:11:18 AM", modified = "7/7/2020 2:16:42 AM",
    trigger = never(worldId() != 0x00) && battlefieldId() == 0x0C && once(bit7(0x0422D4) == 0x0) && 
              bit7(0x0422D4) == 0x1 && bit7(0x0422E4) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "End of the World", description = "Beat the Boss in Hollow Bastion", points = 10,
    id = 15597, badge = "15011", published = "10/16/2014 6:11:28 AM", modified = "7/7/2020 2:16:37 AM",
    trigger = worldId() == 0x08 && battlefieldId() == 0x0A && once(bit3(0x04230D) == 0x0) && bit3(0x04230D) == 0x1 && 
              bit3(0x04232D) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Pixie Dust", description = "Beat the Boss in Neverland", points = 10,
    id = 15598, badge = "15013", published = "10/16/2014 6:11:35 AM", modified = "7/7/2020 2:16:47 AM",
    trigger = worldId() == 0x07 && battlefieldId() == 0x08 && once(bit2(0x04230D) == 0x0) && bit2(0x04230D) == 0x1 && 
              bit2(0x04232D) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Chilly Academic", description = "Defeat Vexen in 11th Floor", points = 10,
    id = 15611, badge = "15015", published = "10/16/2014 6:15:04 AM", modified = "7/7/2020 2:16:53 AM",
    trigger = worldId() == 0x00 && battlefieldId() == 0x0C && once(bit2(0x042307) == 0x0) && bit2(0x042307) == 0x1 && 
              bit2(0x042327) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Taste of the Past", description = "Beat the Boss in Twilight Town", points = 10,
    id = 15599, badge = "15017", published = "10/16/2014 6:11:42 AM", modified = "7/7/2020 2:16:58 AM",
    trigger = worldId() == 0x0B && battlefieldId() == 0x0D && once(bit7(0x04230D) == 0x0) && bit7(0x04230D) == 0x1 && 
              bit7(0x04232D) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Old Friend", description = "In the Castle Oblivion...", points = 10,
    id = 15619, badge = "15018", published = "10/16/2014 6:17:47 AM", modified = "7/7/2020 2:17:03 AM",
    trigger = never(worldId() != 0x00) && battlefieldId() == 0x0C && once(bit0(0x042307) == 0x0) && 
              bit0(0x042307) == 0x1 && bit0(0x042327) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Darkside", description = "Beat the Darkside in Destiny Islands", points = 10,
    id = 15600, badge = "15020", published = "10/16/2014 6:11:58 AM", modified = "7/7/2020 2:17:08 AM",
    trigger = worldId() == 0x09 && battlefieldId() == 0x09 && once(bit4(0x04230D) == 0x0) && bit4(0x04230D) == 0x1 && 
              bit4(0x04232D) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Riku, for last time...", description = "In the Castle Oblivion...", points = 10,
    id = 15602, badge = "15022", published = "10/16/2014 6:12:11 AM", modified = "7/7/2020 2:17:13 AM",
    trigger = never(worldId() != 0x00) && battlefieldId() == 0x0C && once(bit7(0x042312) == 0x0) && 
              bit7(0x042312) == 0x1 && bit7(0x042332) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Revenge of the Nymph", description = "Floor 12th...", points = 10,
    id = 15601, badge = "15025", published = "10/16/2014 6:12:06 AM", modified = "7/7/2020 2:17:19 AM",
    trigger = worldId() == 0x00 && battlefieldId() == 0x0C && once(bit5(0x04230D) == 0x0) && bit5(0x04230D) == 0x1 && 
              bit5(0x04232D) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Extinguish the fire", description = "Floor 13th...", points = 10,
    id = 15603, badge = "15026", published = "10/16/2014 6:12:19 AM", modified = "7/7/2020 2:17:25 AM",
    trigger = worldId() == 0x0C && battlefieldId() == 0x0C && once(bit6(0x04230D) == 0x0) && bit6(0x04230D) == 0x1 && 
              bit6(0x04232D) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Final...", description = "Floor...", points = 25,
    id = 15604, badge = "15027", published = "10/16/2014 6:12:29 AM", modified = "7/7/2020 2:17:38 AM",
    trigger = worldId() == 0x00 && battlefieldId() == 0x0C && bit0(0x04230E) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Reach Out To The Truth", description = "True Memories...", points = 5,
    id = 15605, badge = "15028", published = "10/16/2014 6:12:38 AM", modified = "7/7/2020 2:17:42 AM",
    trigger = worldId() == 0x00 && battlefieldId() == 0x0C && bit0(0x04230E) == 0x1 && bit6(0x04230D) == 0x1 && 
              byte(0x033190) == 0x08 && byte(0x033191) == 0x21 && word(0x033190) == 0x2108 && once(byte(0x033190) == 0xFD)
)

achievement(
    title = "Cura+", description = "Reach 290 HP points", points = 5,
    id = 15608, badge = "14880", published = "10/16/2014 6:14:34 AM", modified = "7/7/2020 2:18:10 AM",
    trigger = once(maxHp() == 0x0113) && maxHp() == 0x0122 && byte(0x042346) == 0x0A
)

achievement(
    title = "Leveling Up", description = "Reach the MAX in Bonus A or Bonus B", points = 10,
    id = 15609, badge = "15007", published = "10/16/2014 6:14:45 AM", modified = "9/26/2019 11:37:01 AM",
    trigger = byte(0x042346) == 0x0A &&
              ((once(maxHp() == 0x0221) && maxHp() == 0x0230) ||
               (once(maxCp() == 0x0753) && maxCp() == 0x076C))
)

function keyToRewardsEntry() => bit2(0x042311)
achievement(
    title = "Room of Rewards", description = "Obtain a Key to Rewards for the first time.", points = 5,
    id = 15610, badge = "15008", published = "10/16/2014 6:14:53 AM", modified = "7/7/2020 2:18:19 AM",
    trigger = WasBitflagSetInGame(keyToRewardsEntry())
)

achievement(
    title = "All the Rooms", description = "Get all the Map Cards (In the Journal)", points = 10,
    id = 15612, badge = "15228", published = "10/16/2014 6:15:39 AM", modified = "7/7/2020 2:22:16 AM",
    trigger = byte(0x04230F) == 0xFF && byte(0x042310) == 0xFF && bit1(0x04230E) == 0x1 && bit2(0x04230E) == 0x1 && 
              bit3(0x04230E) == 0x1 && bit4(0x04230E) == 0x1 && bit5(0x04230E) == 0x1 && bit6(0x04230E) == 0x1 && bit7(0x04230E) == 0x1 && 
              bit0(0x042311) == 0x1 && bit1(0x042311) == 0x1 && bit2(0x042311) == 0x1
)

function lionheart() => bit0(0x042304)
achievement(
    title = "Lionheart", description = "Obtain a Lionheart card for the first time.", points = 5,
    id = 15581, badge = "14873", published = "10/16/2014 6:05:29 AM", modified = "7/7/2020 2:22:26 AM",
    trigger = WasBitflagSetInGame(lionheart())
)

function threeWishes() => bit0(0x042303)
achievement(
    title = "Three Wishes", description = "Obtain a Three Wishes card for the first time.", points = 5,
    id = 15627, badge = "14872", published = "10/16/2014 6:18:57 AM", modified = "7/7/2020 2:22:32 AM",
    trigger = WasBitflagSetInGame(threeWishes())
)

function oneWingedAngel() => bit7(0x042304)
achievement(
    title = "One-Winged Angel", description = "Obtain a One-Winged Angel card for the first time.", points = 5,
    id = 15628, badge = "15189", published = "10/16/2014 6:19:09 AM", modified = "7/7/2020 2:22:37 AM",
    trigger = WasBitflagSetInGame(oneWingedAngel())
)

function diamondDust() => bit6(0x042304)
achievement(
    title = "Diamond Dust", description = "Obtain a Diamond Dust card for the first time.", points = 5,
    id = 15629, badge = "15187", published = "10/16/2014 6:19:25 AM", modified = "7/7/2020 2:22:57 AM",
    trigger = WasBitflagSetInGame(diamondDust())
)

function ultimaWeapon() => bit5(0x042304)
achievement(
    title = "Ultima Weapon", description = "Obtain an Ultima Weapon card for the first time.", points = 5,
    id = 15630, badge = "15184", published = "10/16/2014 6:19:36 AM", modified = "9/29/2019 12:07:01 PM",
    trigger = WasBitflagSetInGame(ultimaWeapon())
)

function pumpkinheadEntry() => bit2(0x042303)
achievement(
    title = "Pumpkinhead", description = "Obtain a Pumpkinhead card for the first time.", points = 5,
    id = 15631, badge = "14874", published = "10/16/2014 6:19:59 AM", modified = "7/7/2020 2:23:04 AM",
    trigger = WasBitflagSetInGame(pumpkinheadEntry())
)

function wishingStar() => bit4(0x042303)
achievement(
    title = "Wishing Star", description = "Obtain a Wishing Star card for the first time.", points = 5,
    id = 15632, badge = "14879", published = "10/16/2014 6:20:07 AM", modified = "7/7/2020 2:23:09 AM",
    trigger = WasBitflagSetInGame(wishingStar())
)

function olympia() => bit7(0x042303)
achievement(
    title = "Olympia", description = "Obtain an Olympia card for the first time.", points = 5,
    id = 15634, badge = "14908", published = "10/16/2014 6:21:13 AM", modified = "7/7/2020 2:23:14 AM",
    trigger = WasBitflagSetInGame(olympia())
)

function metalChocobo() => bit6(0x042303)
achievement(
    title = "Metal Chocobo", description = "Obtain a Metal Chocobo card for the first time.", points = 5,
    id = 15635, badge = "14910", published = "10/16/2014 6:21:20 AM", modified = "7/7/2020 2:23:19 AM",
    trigger = WasBitflagSetInGame(metalChocobo())
)

function spellbinder() => bit5(0x042303)
achievement(
    title = "Spellbinder", description = "Obtain a Spellbinder card for the first time.", points = 5,
    id = 15636, badge = "14930", published = "10/16/2014 6:21:25 AM", modified = "7/7/2020 2:23:25 AM",
    trigger = WasBitflagSetInGame(spellbinder())
)

function divineRose() => bit2(0x042304)
achievement(
    title = "Divine Rose", description = "Obtain a Divine Rose card for the first time.", points = 5,
    id = 15637, badge = "15006", published = "10/16/2014 6:21:29 AM", modified = "7/7/2020 2:23:29 AM",
    trigger = WasBitflagSetInGame(divineRose())
)

function crabclaw() => bit1(0x042303)
achievement(
    title = "Crabclaw", description = "Obtain a Crabclaw card for the first time.", points = 5,
    id = 15638, badge = "14933", published = "10/16/2014 6:21:34 AM", modified = "7/7/2020 2:23:35 AM",
    trigger = WasBitflagSetInGame(crabclaw())
)

function fairyHarp() => bit3(0x042303)
achievement(
    title = "Fairy Harp", description = "Obtain a Fairy Harp card for the first time.", points = 5,
    id = 15639, badge = "15012", published = "10/16/2014 6:21:39 AM", modified = "7/7/2020 2:23:40 AM",
    trigger = WasBitflagSetInGame(fairyHarp())
)

function oathkeeper() => bit3(0x042304)
achievement(
    title = "Oathkeeper", description = "Obtain an Oathkeeper card for the first time.", points = 5,
    id = 15640, badge = "15021", published = "10/16/2014 6:21:43 AM", modified = "7/7/2020 2:23:47 AM",
    trigger = WasBitflagSetInGame(oathkeeper())
)

function ladyLuck() => bit1(0x042304)
achievement(
    title = "Lady Luck", description = "Obtain a Lady Luck card for the first time.", points = 5,
    id = 15641, badge = "14914", published = "10/16/2014 6:21:50 AM", modified = "7/7/2020 2:23:51 AM",
    trigger = WasBitflagSetInGame(ladyLuck())
)

function oblivion() => bit4(0x042304)
achievement(
    title = "Oblivion", description = "Obtain an Oblivion card for the first time.", points = 5,
    id = 15642, badge = "15024", published = "10/16/2014 6:21:56 AM", modified = "7/7/2020 2:23:56 AM",
    trigger = WasBitflagSetInGame(oblivion())
)

function slidingDash() => bit0(0x0422cc)
achievement(
    title = "The First of Many", description = "Learn the Sliding Dash sleight.", points = 1,
    id = 15613, badge = "15212", published = "10/16/2014 6:15:51 AM", modified = "7/7/2020 2:24:02 AM",
    trigger = WasBitflagSetInGame(slidingDash())
)

function blazingDonaldUnlocked() => bit3(0x0422d7)
achievement(
    title = "Blazing Donald", description = "Learn the Blazing Donald sleight.", points = 1,
    id = 15614, badge = "14868", published = "10/16/2014 6:16:30 AM", modified = "7/7/2020 2:24:09 AM",
    trigger = WasBitflagSetInGame(blazingDonaldUnlocked())
)

function stopRaid() => bit3(0x0422cf)
achievement(
    title = "Stop Raid", description = "Learn the Stop Raid sleight.", points = 3,
    id = 15615, badge = "14915", published = "10/16/2014 6:16:43 AM", modified = "10/16/2014 6:23:10 AM",
    trigger = WasBitflagSetInGame(stopRaid())
)

function quake() => bit6(0x0422d4)
achievement(
    title = "Quake", description = "Learn the Quake sleight.", points = 3,
    id = 15616, badge = "15003", published = "10/16/2014 6:17:15 AM", modified = "10/16/2014 6:23:13 AM",
    trigger = WasBitflagSetInGame(quake())
)

function thunderRaid() => bit1(0x0422cf)
achievement(
    title = "Thunder Raid", description = "Learn the Thunder Raid sleight.", points = 3,
    id = 15617, badge = "15009", published = "10/16/2014 6:17:24 AM", modified = "10/16/2014 6:23:15 AM",
    trigger = WasBitflagSetInGame(thunderRaid())
)

function warp() => bit0(0x0422D5)
achievement(
    title = "Warp", description = "Learn the Warp sleight.", points = 3,
    id = 15618, badge = "15016", published = "10/16/2014 6:17:31 AM", modified = "10/16/2014 6:23:17 AM",
    trigger = WasBitflagSetInGame(warp())
)

function firagaBreak() => bit0(0x0422d4)
achievement(
    title = "Firaga Break", description = "Learn the Firaga Break sleight.", points = 3,
    id = 15620, badge = "15221", published = "10/16/2014 6:17:58 AM", modified = "10/16/2014 6:23:21 AM",
    trigger = WasBitflagSetInGame(firagaBreak())
)

function fireBreak() => bit7(0x0422ce)
achievement(
    title = "Burner", description = "Learn the Fire Raid sleight.", points = 3,
    id = 15621, badge = "15218", published = "10/16/2014 6:18:02 AM", modified = "10/16/2014 6:23:24 AM",
    trigger = WasBitflagSetInGame(fireBreak())
)

function crossSlashPlus() => bit1(0x0422d7)
achievement(
    title = "Cross-Whip", description = "Learn the Cross-Slash+ sleight.", points = 3,
    id = 15622, badge = "15213", published = "10/16/2014 6:18:08 AM", modified = "8/14/2018 12:38:08 PM",
    trigger = WasBitflagSetInGame(crossSlashPlus())
)

function judgment() => bit4(0x0422cf)
achievement(
    title = "Divine Justice", description = "Learn the Judgment sleight.", points = 3,
    id = 15623, badge = "15210", published = "10/16/2014 6:18:13 AM", modified = "10/16/2014 6:23:28 AM",
    trigger = WasBitflagSetInGame(judgment())
)

function blizzardRaid() => bit0(0x0422cf)
achievement(
    title = "Blizzard Raid ", description = "Learn the Blizzard Raid sleight.", points = 3,
    id = 15624, badge = "15209", published = "10/16/2014 6:18:20 AM", modified = "10/16/2014 6:23:31 AM",
    trigger = WasBitflagSetInGame(blizzardRaid())
)

function homingBlizzara() => bit2(0x0422d4)
achievement(
    title = "Homing Blizzara", description = "Learn the Homing Blizzara sleight.", points = 3,
    id = 15625, badge = "15207", published = "10/16/2014 6:18:24 AM", modified = "10/16/2014 6:23:33 AM",
    trigger = WasBitflagSetInGame(homingBlizzara())
)

function gravityRaid() => bit2(0x0422cf)
achievement(
    title = "Gravity Raid", description = "Learn the Gravity Raid sleight.", points = 3,
    id = 15633, badge = "14876", published = "10/16/2014 6:21:08 AM", modified = "10/16/2014 6:23:50 AM",
    trigger = WasBitflagSetInGame(gravityRaid())
)

function megalixir() => bit4(0x042307)
achievement(
    title = "Megalixir", description = "Obtain a Megalixir card for the first time.", points = 3,
    id = 15647, badge = "15019", published = "10/16/2014 6:22:45 AM", modified = "11/8/2016 6:44:41 PM",
    trigger = WasBitflagSetInGame(megalixir())
)

function stop() => bit5(0x042305)
achievement(
    title = "Time Stop", description = "Obtain a Stop card for the first time.", points = 3,
    id = 15645, badge = "15204", published = "10/16/2014 6:22:27 AM", modified = "10/16/2014 6:24:18 AM",
    trigger = WasBitflagSetInGame(stop())
)

function gravityCardEntry() => bit4(0x042305)
achievement(
    title = "Always Down", description = "Obtain a Gravity card for the first time.", points = 3,
    id = 15646, badge = "15205", published = "10/16/2014 6:22:35 AM", modified = "10/16/2014 6:24:21 AM",
    trigger = WasBitflagSetInGame(gravityCardEntry())
)

function mushu() => bit4(0x042306)
achievement(
    title = "Mushu", description = "Get a Mushu card for the first time.", points = 3,
    id = 15644, badge = "15010", published = "10/16/2014 6:22:17 AM", modified = "10/16/2014 6:24:16 AM",
    trigger = WasBitflagSetInGame(mushu())
)

achievement(
    title = "Lexaeus", description = "Obtain the 'Lexaeus' Card", points = 5,
    id = 15650, badge = "15185", published = "10/16/2014 6:26:31 AM", modified = "11/8/2016 5:30:58 PM",
    trigger = worldId() == 0x0C && battlefieldId() == 0x0C && once(bit0(0x042313) == 0x0) && bit0(0x042313) == 0x1 && 
              bit0(0x042333) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Reverse Rebirth", description = "Another Story, Same Castle (Reb)", points = 2,
    id = 15648, badge = "15029", published = "10/16/2014 6:22:53 AM", modified = "11/8/2016 6:44:21 PM",
    trigger = once(byte(0x005B30) == 0x20) && byte(0x005B30) == 0x00 && byte(0x03D0B2) == 0x05 && byte(0x042692) == 0x9C
)

achievement(
    title = "Ansem", description = "Obtain the 'Ansem' Card", points = 5,
    id = 15649, badge = "15186", published = "10/16/2014 6:26:26 AM", modified = "10/16/2014 6:48:37 AM",
    trigger = worldId() == 0x0C && battlefieldId() == 0x0C && once(bit1(0x042313) == 0x0) && bit1(0x042313) == 0x1 && 
              bit1(0x042333) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Critical Competitor", description = "Beat the game with Sora without never upgrade the Vitality bar", points = 50,
    id = 41892, badge = "43183", published = "11/8/2016 6:47:54 PM", modified = "7/7/2020 2:25:02 AM",
    trigger = worldId() == 0x00 && battlefieldId() == 0x0C && bit0(0x04230E) == 0x1 && bit6(0x04230D) == 0x1 && 
              byte(0x033190) == 0x08 && byte(0x033191) == 0x21 && word(0x033190) == 0x2108 && once(byte(0x033190) == 0xFD) && 
              maxHp() == 0x0050
)

achievement(
    title = "Around Green Flames", description = "Floor 1st... (Reb)", points = 10,
    id = 15651, badge = "15121", published = "10/16/2014 6:27:09 AM", modified = "7/7/2020 2:26:33 AM",
    trigger = worldId() == 0x08 && battlefieldId() == 0x0A && once(bit3(0x04230D) == 0x0) && bit3(0x04230D) == 0x1 && 
              bit3(0x04232D) == 0x1 && byte(0x042692) == 0x9C && byte(0x042346) == 0x08
)

achievement(
    title = "Darkness...", description = "Floor 1st... (Reb)", points = 10,
    id = 15652, badge = "15104", published = "10/16/2014 6:27:15 AM", modified = "7/7/2020 2:26:27 AM",
    trigger = worldId() == 0x00 && battlefieldId() == 0x0C && once(floor() == 0x00) && floor() == 0x01 && 
              word(0x0421CE) == 0xFF01 && byte(0x042346) == 0x08
)

achievement(
    title = "In the Sea of Fire", description = "Floor... (Reb)", points = 10,
    id = 15653, badge = "15126", published = "10/16/2014 6:27:21 AM", modified = "7/7/2020 2:26:20 AM",
    trigger = worldId() == 0x01 && battlefieldId() == 0x03 && once(bit6(0x04230C) == 0x0) && bit6(0x04230C) == 0x1 && 
              bit6(0x04232C) == 0x1 && byte(0x042346) == 0x08
)

achievement(
    title = "More Parasites", description = "Floor... (Reb)", points = 10,
    id = 15654, badge = "15130", published = "10/16/2014 6:27:28 AM", modified = "7/7/2020 2:26:13 AM",
    trigger = worldId() == 0x05 && battlefieldId() == 0x05 && once(bit1(0x04230D) == 0x0) && bit1(0x04230D) == 0x1 && 
              bit1(0x04232D) == 0x1 && byte(0x042346) == 0x08
)

achievement(
    title = "One More...", description = "Basement 12th... (Reb)", points = 10,
    id = 15655, badge = "15144", published = "10/16/2014 6:27:34 AM", modified = "7/7/2020 2:26:08 AM",
    trigger = worldId() == 0x00 && battlefieldId() == 0x0C && once(floor() == 0x02) && floor() == 0x03 && 
              word(0x0421CE) == 0xFF03 && byte(0x042346) == 0x08
)

achievement(
    title = "You can Fly", description = "Floor... (Reb)", points = 10,
    id = 15656, badge = "15145", published = "10/16/2014 6:27:38 AM", modified = "7/7/2020 2:26:03 AM",
    trigger = worldId() == 0x07 && battlefieldId() == 0x08 && once(bit2(0x04230D) == 0x0) && bit2(0x04230D) == 0x1 && 
              bit2(0x04232D) == 0x1 && byte(0x042346) == 0x08
)

achievement(
    title = "Armors", description = "Floor... (Reb)", points = 10,
    id = 15657, badge = "15149", published = "10/16/2014 6:27:45 AM", modified = "7/7/2020 2:25:58 AM",
    trigger = once(bit3(0x04230C) == 0x0) && bit3(0x04230C) == 0x1 && worldId() == 0x0A && battlefieldId() == 0x0B && 
              bit3(0x04232C) == 0x1 && byte(0x042346) == 0x08
)

achievement(
    title = "And Another...", description = "Basement 7th... (Reb)", points = 10,
    id = 15658, badge = "15152", published = "10/16/2014 6:27:52 AM", modified = "7/7/2020 2:25:53 AM",
    trigger = worldId() == 0x00 && battlefieldId() == 0x0C && once(floor() == 0x04) && floor() == 0x05 && 
              word(0x0421CE) == 0xFF05 && byte(0x042346) == 0x08
)

achievement(
    title = "Tentacles...", description = "Floor... (Reb)", points = 10,
    id = 15659, badge = "15153", published = "10/16/2014 6:27:57 AM", modified = "7/7/2020 2:25:48 AM",
    trigger = worldId() == 0x02 && battlefieldId() == 0x04 && once(bit7(0x04230C) == 0x0) && bit7(0x04230C) == 0x1 && 
              bit7(0x04232C) == 0x1 && byte(0x042346) == 0x08
)

achievement(
    title = "Trick or Treat", description = "Floor... (Reb)", points = 10,
    id = 15660, badge = "15154", published = "10/16/2014 6:28:03 AM", modified = "7/7/2020 2:25:43 AM",
    trigger = worldId() == 0x06 && battlefieldId() == 0x07 && once(bit0(0x04230D) == 0x0) && bit0(0x04230D) == 0x1 && 
              bit0(0x04232D) == 0x1 && byte(0x042346) == 0x08
)

achievement(
    title = "Hero Test", description = "Floor... (Reb)", points = 10,
    id = 15661, badge = "15159", published = "10/16/2014 6:28:08 AM", modified = "7/7/2020 2:25:39 AM",
    trigger = worldId() == 0x03 && battlefieldId() == 0x06 && once(bit4(0x04230C) == 0x0) && bit4(0x04230C) == 0x1 && 
              bit4(0x04232C) == 0x1 && byte(0x042346) == 0x08
)

achievement(
    title = "The Rabbit Hole", description = "Floor... (Reb)", points = 10,
    id = 15662, badge = "15164", published = "10/16/2014 6:28:12 AM", modified = "7/7/2020 2:25:35 AM",
    trigger = worldId() == 0x04 && battlefieldId() == 0x01 && once(bit5(0x04230C) == 0x0) && bit5(0x04230C) == 0x1 && 
              bit5(0x04232C) == 0x1 && byte(0x042346) == 0x08
)

achievement(
    title = "Power...", description = "Basement 4th... (Reb)", points = 10,
    id = 15663, badge = "15166", published = "10/16/2014 6:28:17 AM", modified = "7/7/2020 2:25:27 AM",
    trigger = worldId() == 0x00 && battlefieldId() == 0x0C && once(bit0(0x042313) == 0x0) && bit0(0x042313) == 0x1 && 
              bit0(0x042333) == 0x1 && byte(0x042346) == 0x08
)

achievement(
    title = "Darker...", description = "Basement 3rd... (Reb)", points = 10,
    id = 15664, badge = "15174", published = "10/16/2014 6:28:24 AM", modified = "7/7/2020 2:25:23 AM",
    trigger = worldId() == 0x09 && battlefieldId() == 0x09 && once(bit4(0x04230D) == 0x0) && bit4(0x04230D) == 0x1 && 
              bit4(0x04232D) == 0x1 && byte(0x042346) == 0x08
)

achievement(
    title = "Light and Dark", description = "Basement 2nd... (Reb)", points = 10,
    id = 15665, badge = "15178", published = "10/16/2014 6:28:32 AM", modified = "7/7/2020 2:25:18 AM",
    trigger = worldId() == 0x00 && battlefieldId() == 0x0C && once(floor() == 0x0A) && floor() == 0x0B && 
              word(0x0421CE) == 0xFF0B && byte(0x042346) == 0x08
)

achievement(
    title = "Final II...", description = "Floor... (Reb)", points = 25,
    id = 15666, badge = "15179", published = "10/16/2014 6:28:40 AM", modified = "7/7/2020 2:25:14 AM",
    trigger = worldId() == 0x0C && battlefieldId() == 0x0C && once(byte(0x03A9CC) == 0x20) && byte(0x03A9CC) == 0x00 && 
              once(byte(0x03A9CD) == 0x08) && byte(0x03A9CD) == 0x00 && once(word(0x03A9CE) == 0x0820) && word(0x03A9CE) == 0x0000 && 
              bit4(0x04230D) == 0x1
)

achievement(
    title = "Level Boost", description = "Reach the MAX in Bonus A or Bonus B (Reb)", points = 10,
    id = 15667, badge = "15030", published = "10/16/2014 6:39:25 AM", modified = "10/8/2019 2:07:01 PM",
    trigger = byte(0x042346) == 0x08 &&
              ((once(maxHp() == 0x0221) && maxHp() == 0x0230) ||
               (once(attackPoints() == 0x1D) && attackPoints() == 0x1E))
)

achievement(
    title = "The Final Floor", description = "Floor...", points = 5,
    id = 41891, badge = "43185", published = "11/8/2016 6:47:41 PM", modified = "11/8/2016 6:47:41 PM",
    trigger = worldId() == 0x00 && battlefieldId() == 0x0C && once(bit0(0x04230E) == 0x0) && bit0(0x04230E) == 0x1 && 
              bit6(0x04232E) == 0x1 && bit6(0x04230D) == 0x1 && byte(0x042346) == 0x0A
)

leaderboard(title = "Time Attack - Parasite Cage (Sora's Story)",
    description = "Defeat the Parasite Cage in Sora's story as quickly as you can.",
    start = BossHPValueCheckpointIsSet(parasiteCageHp(), parasiteCageHpMap, "Monstro", 0x4) && never(!IsInBattle()),
    cancel = !IsInBattle(),
    submit = EnemyWithSpecificAddressWasJustDefeated(parasiteCageHp()),
    value = measured(FrameHasAdvanced() && !IsPaused())
)

rich_presence_display("Level {0} in {1} ({2})",
    rich_presence_value("Level", level()),
    rich_presence_lookup("Location", byte(0x0421CC), LocationLookup),
    rich_presence_lookup("Floor", byte(0x0421CE) + bit7(0x042692) * 16, FloorLookup)
)
