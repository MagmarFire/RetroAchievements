// Rayman 2: The Great Escape (E)
// #ID = 10269

function TRUE() => 1
function FALSE() => 0

function Delta(mem) => prev(mem)

function Debug(string)
{
    achievement(title = string, description = "", points = 0, trigger = always_false())
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

// $0C6DF9: Area ID (24-bit)
function areaId() => tbyte(0x0C6DF8)

function IsPaused() => byte(0x0e6911) == 1

function loadedSaveSlot() => byte(0x0ea27c)

function IsOnMainOrPauseMenu() => IsPaused() || IsInLocation("Menu")

function IsInGame() => loadedSaveSlot() > 0 && loadedSaveSlot() < 4

function IsAlwaysInGame() => never(!IsInGame() || ChangedFile())

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

function CreateHitTargetedAndNextChain(permutation)
{
    trigger = always_true()
    
    for condition in permutation
    {
        trigger = once(trigger && once(condition))
    }
    
    return trigger
}

// $0C6E59: 43 treasure maybe
// $0C8CA1: Golden Gloves
//          00= No Golden Gloves
//          01= Golden Gloves
// $0C9470: Text appearing (gameplay or cutscene)
//          01= No text
//          02>= Text appeared
// $0CDDC6: lums rougemaybe
// $0E14BC: globox race better
// $0E5C34: Level ID 16bits (These do not seem correct)
//          
//          6172 = The Woods of Light
//          6172 = The Fairy Glade
//          6e75= Main Menu/Bonus Stage
//          706d= Main Hub (Hall of Doors)
//          7963= Results Screen
// $0E6911: Pause Mode
//          01= Paused
// $0EA27C: Current Slot Loaded (01/02/03)
// $1768B4: Music 1
function musicId() => dword(0x1768b4)

// $17691E: Camera X Coordinates 16bits
// $1FA240: Animation relatde
// $1FA780: 0c basketball
// $1FA781: ad Basketball
// $21A288: Rayman Animation ID 1 16bits
//          4428= Elixir of Life
//          43bc= Respawn
//          43c8= Static
//          45a8= Basketball idle
//          44ac= Yeah!
// $21A289: 45 basket
// $21A28C: Last Rayman Animation loaded 16bits
// $21A28D: 43 basket
// $2248C8: Cages Destroyed in this Level
// $22493C: Lums remaining current level
// $224941: Cages total
// $224942: Current Lums 8bits
//          Resets to 0 when you enter a level (even if you re-enter to someone)
//          If you enter a level through other level (like Bad Dreams Cave), the variable doesn't restart to 0
// $22494E: Cutscene Mode
//          0c= cutscene playing
// $224988: Fairy Glade Total Lums 16bits
//          ffff= All lums collected
// $224994: Marais fin Bayou debut
// $22499A: Santuary of Water Lums 01 8bits
//          ff= All Lums Collected
// $2249BA: Echoing caves debut
// $2249C0: Echoing caves fin precipice debut
// $2249C6: Precipice fin The top of the world debut
// $2249CC: Top of the world fin Sanctuary1 debut
// $2249D2: Sanctuary of rock and lava1 fin
// $2249DE: Tomb of the anciens fin
// $224A00: 7f power shots
// $224A10: 2d nwhite shots 6d blue
// $224A13: df all mask
// $224A16: Charging shots
// $224A2B: Final debut
// $224A31: avant dernier niveau quelque part
// $224A35: Final final
// $224A36: Bit 3: Yellow Lum 2 - Woods of Light, Area 1 (free)
//          Bit 4: Yellow Lum 5 - Woods of Light, Area 1 (wall)
//          Bit 5: Yellow Lum 3 - Woods of Light, Area 1 (free)
//          Bit 6: Yellow Lum 1 - Woods of Light, Area 1 (Cage)
//          Bit 7: Yellow Lum 4 - Woods of Light, Area 2 (waterfall)
// $5D4C62: Input stable
// $5DE45C: Total Lums 16bits (at Main Hub)
// $5E976E: SWITCH obus
// $5E9AC0: Walk of Life Timer (ms) 16bits
// $5E9AC2: Walk of Life Timer (mm/ss) 16bits
// $5ECF34: Walk of Power Timer 2 (ms) 16bits
// $5ECF36: Walk of Power Timer 1 (mm/ss) 16bits
// $5ECF37: Timer race positive 2
// $5F01BF: Final Fight Unlimited Ammo Flag
//          01= Unlocked
// $5FD47E: lums vert ancient1
// $74CEE8: Globox Son Animation 16bits
//          cb88= Race haven´t started
//          cba8= Race have just started
//          ccc8= Race Won
// $74E2F2: Bonus Race Timer 1 16bits
// $76ED14: lumsrazor
// $76ED30: lumsrazor2
// $76ED31: lumsrazor 3
// $76ED32: lumsrazor4
// $77AB93: Iron Mountains Switch 1
//          08= Switch pressed
// $77B44B: Iron Mountains Switch 2
//          08= Switch pressed
// $780970: Rayman Animation ID (Only at Hall of Doors)
//          b8 = Static
//          38 = Jumping
//          18 = Falling from a Jump
// $7871CC: Menezis Current Score 16bits
// $787F62: Barbe a HP
// $787F6C: Menezis Current Score 16bits
// $78863C: Menezis Current Score 16bits
// $7A08E6: 1000th lum
//          2e= Lum spawned
//          2b= Lum taked
// $7A325E: lums vert ancien 2
// $7A325F: lums vert ancient suite

function ChangedFile() => Delta(loadedSaveSlot()) != loadedSaveSlot()

// This function allows the creation of achievements with built-in save protection that deal with a collection of values being set
// throughout the game. The schemas for both parameters are as follows:
//
// name: title
// description: self-explanatory
// points: self-explanatory
// threshold: how many values in the "conditions" dictionary must be set before this achievement is triggered
// conditions: "countsWhen": the condition that must be true in order for it to be counted in the total
//             "recalculateWhen": the condition that indicates that relevant values in the condition have changed,
//                                and so everything must be recalculated
// onlyAvailableWhen: A condition that must be true in all conditions for the achievement to trigger.
// id: self-explanatory
// badge: self-explanatory
function GenerateCheevoFromConditions(name, description, points, threshold, conditions, onlyAvailableWhen = always_true(), id = 0, badge = "00000")
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
        array_push(loadedCounts, once(condition["countsWhen"] && IsOnMainOrPauseMenu()))

        // We want both loaded and session counts here (that is, we don't care if we're loading a save file when these are tallied).
        // This way, loading a save doesn't invalidate the achievement outright if a player hasn't actually earned it yet.
        array_push(totalCounts, once(condition["countsWhen"]))

        resetAlt = resetAlt || condition["recalculateWhen"]
    }

    achievement(title = name, description = description, points = points, badge = badge, id = id,
        trigger = IsInGame() &&
            measured(tally(threshold, totalCounts)) && unless(tally(threshold, loadedCounts))
            && never(resetAlt) && onlyAvailableWhen && (always_false() || never(ChangedFile()))
    )
}

// This function allows the creation of achievements with built-in save protection that deal with a collection of values being set
// throughout the game. The schemas for both parameters are as follows:
//
// name: title
// description: self-explanatory
// points: self-explanatory
// threshold: how many values in the "conditions" dictionary must be set before this achievement is triggered
// addresses: a list of address accessors that need to have their bits summed (each address must have an "addr" and "bit" value in order to be properly aggregated)
// onlyAvailableWhen: a condition that must be true in all conditions for the achievement to trigger.
// id: self-explanatory
// badge: self-explanatory
function GenerateCheevoFromBits(name, description, points, threshold, addresses, onlyAvailableWhen = always_true(), id = 0, badge = "00000")
{
    bitcounts = GenerateBitcountFromCountableObjects(GetCountableAccessorArrayFromAddressBits(lums))

    // This is the score when the game is loaded. If the loaded score is greater than or equal to the threshold--that is,
    // if the save file would satisfy enough conditions to trigger the achievement on load--this should trigger a
    // permanant pauselock to serve as save protection.
    shouldTriggerPauselock = once(bitcounts >= threshold && IsOnMainOrPauseMenu())
    
    // We want both loaded and session counts here (that is, we don't care if we're loading a save file when these are tallied).
    // This way, loading a save doesn't invalidate the achievement outright if a player hasn't actually earned it yet.
    trigger = bitcounts >= threshold

    achievement(title = name, description = description, points = points, badge = badge, id = id,
        trigger = IsInGame() && measured(trigger) && unless(shouldTriggerPauselock) && onlyAvailableWhen
            && (always_false() || never(ChangedFile())) // Reset any potential pauselock when changing save files.
    )
}

function GenerateBitcountFromCountableObjects(addresses)
{
    finalBitcount = 0
    for address in addresses
    {
        if (address["type"] == "byte")
        {
            finalBitcount = finalBitcount + bitcount(address["address"])
        }
        else
        {
            finalBitcount = finalBitcount + address["mem"]
        }
    }
    return finalBitcount
}

function GenerateConditionFromBitflag(bit)
{
    return { "countsWhen": (bit == 1), "recalculateWhen": (Delta(bit) != bit) }
}

levels = {
1: { "id": 1, "name": "Woods of Light", "lums": 5, "cages": 2 },
2: { "id": 2, "name": "Fairy Glade", "lums": 50, "cages": 7 },
3: { "id": 3, "name": "None", "lums": 0, "cages": 0 },
4: { "id": 4, "name": "Hall of Doors", "lums": 0, "cages": 0 },
5: { "id": 5, "name": "Marshes of Awakening", "lums": 50, "cages": 5 },
6: { "id": 6, "name": "Bayou", "lums": 50, "cages": 7 },
7: { "id": 7, "name": "Menu", "lums": 0, "cages": 0 },
8: { "id": 8, "name": "Sanctuary of Water and Ice", "lums": 50, "cages": 2 },
9: { "id": 9, "name": "Polokus", "lums": 0, "cages": 0 },
10: { "id": 10, "name": "Menhir Hills", "lums": 50, "cages": 8 },
11: { "id": 11, "name": "Cave of Bad Dreams", "lums": 50, "cages": 0 },
12: { "id": 12, "name": "Canopy", "lums": 50, "cages": 4 },
13: { "id": 13, "name": "Whale Bay", "lums": 50, "cages": 4 },
14: { "id": 14, "name": "Sanctuary of Stone and Fire", "lums": 50, "cages": 8 },
15: { "id": 15, "name": "Echoing Caves", "lums": 50, "cages": 5 },
16: { "id": 16, "name": "Precipice", "lums": 50, "cages": 6 },
17: { "id": 17, "name": "Top of the World", "lums": 50, "cages": 2 },
18: { "id": 18, "name": "Sanctuary of Rock and Lava", "lums": 50, "cages": 7 },
19: { "id": 19, "name": "Beneath the Sanctuary of Rock and Lava", "lums": 50, "cages": 4 },
20: { "id": 20, "name": "Tomb of the Ancients", "lums": 50, "cages": 6 },
21: { "id": 21, "name": "Iron Mountains", "lums": 50, "cages": 3 },
22: { "id": 22, "name": "Prison Ship", "lums": 94, "cages": 0 },
23: { "id": 23, "name": "Crow’s Nest", "lums": 0, "cages": 0 },
24: { "id": 24, "name": "Walk of Life", "lums": 50, "cages": 0 },
25: { "id": 25, "name": "Walk of Power", "lums": 50, "cages": 0 },
}

function GetLevelByName(levelName)
{
    for i in levels
    {
        level = levels[i]
        if (level["name"] == levelName)
        {
            return level
        }
    }
}


lums = {
1: { "levelId": 2, "mem": bit0(0x224988),"good": 1, "addr": 0x224988, "bit": 0},2: { "levelId": 2, "mem": bit1(0x224988),"good": 1, "addr": 0x224988, "bit": 1},3: { "levelId": 2, "mem": bit2(0x224988),"good": 1, "addr": 0x224988, "bit": 2},4: { "levelId": 2, "mem": bit3(0x224988),"good": 1, "addr": 0x224988, "bit": 3},5: { "levelId": 2, "mem": bit4(0x224988),"good": 1, "addr": 0x224988, "bit": 4},6: { "levelId": 2, "mem": bit5(0x224988),"good": 1, "addr": 0x224988, "bit": 5},7: { "levelId": 2, "mem": bit6(0x224988),"good": 1, "addr": 0x224988, "bit": 6},8: { "levelId": 2, "mem": bit7(0x224988),"good": 1, "addr": 0x224988, "bit": 7},9: { "levelId": 2, "mem": bit2(0x224989),"good": 1, "addr": 0x224989, "bit": 2},10: { "levelId": 2, "mem": bit1(0x22498a),"good": 1, "addr": 0x22498a, "bit": 1},11: { "levelId": 2, "mem": bit2(0x22498a),"good": 1, "addr": 0x22498a, "bit": 2},12: { "levelId": 2, "mem": bit3(0x22498a),"good": 1, "addr": 0x22498a, "bit": 3},13: { "levelId": 2, "mem": bit4(0x22498a),"good": 1, "addr": 0x22498a, "bit": 4},14: { "levelId": 2, "mem": bit5(0x22498a),"good": 1, "addr": 0x22498a, "bit": 5},15: { "levelId": 2, "mem": bit6(0x22498a),"good": 1, "addr": 0x22498a, "bit": 6},16: { "levelId": 2, "mem": bit7(0x22498a),"good": 1, "addr": 0x22498a, "bit": 7},17: { "levelId": 2, "mem": bit5(0x22498b),"good": 1, "addr": 0x22498b, "bit": 5},18: { "levelId": 2, "mem": bit6(0x22498b),"good": 1, "addr": 0x22498b, "bit": 6},19: { "levelId": 2, "mem": bit7(0x22498b),"good": 1, "addr": 0x22498b, "bit": 7},20: { "levelId": 2, "mem": bit0(0x22498c),"good": 1, "addr": 0x22498c, "bit": 0},21: { "levelId": 2, "mem": bit1(0x22498c),"good": 1, "addr": 0x22498c, "bit": 1},22: { "levelId": 2, "mem": bit2(0x22498c),"good": 1, "addr": 0x22498c, "bit": 2},23: { "levelId": 2, "mem": bit3(0x22498c),"good": 1, "addr": 0x22498c, "bit": 3},24: { "levelId": 2, "mem": bit4(0x22498c),"good": 1, "addr": 0x22498c, "bit": 4},25: { "levelId": 2, "mem": bit5(0x22498c),"good": 1, "addr": 0x22498c, "bit": 5},26: { "levelId": 2, "mem": bit6(0x22498c),"good": 1, "addr": 0x22498c, "bit": 6},27: { "levelId": 2, "mem": bit7(0x22498c),"good": 1, "addr": 0x22498c, "bit": 7},28: { "levelId": 2, "mem": bit0(0x22498d),"good": 1, "addr": 0x22498d, "bit": 0},29: { "levelId": 2, "mem": bit1(0x22498d),"good": 1, "addr": 0x22498d, "bit": 1},30: { "levelId": 2, "mem": bit2(0x22498d),"good": 1, "addr": 0x22498d, "bit": 2},31: { "levelId": 2, "mem": bit3(0x22498d),"good": 1, "addr": 0x22498d, "bit": 3},32: { "levelId": 2, "mem": bit4(0x22498d),"good": 1, "addr": 0x22498d, "bit": 4},33: { "levelId": 2, "mem": bit5(0x22498d),"good": 1, "addr": 0x22498d, "bit": 5},34: { "levelId": 2, "mem": bit6(0x22498d),"good": 1, "addr": 0x22498d, "bit": 6},35: { "levelId": 2, "mem": bit7(0x22498d),"good": 1, "addr": 0x22498d, "bit": 7},36: { "levelId": 2, "mem": bit0(0x22498e),"good": 1, "addr": 0x22498e, "bit": 0},37: { "levelId": 2, "mem": bit1(0x22498e),"good": 1, "addr": 0x22498e, "bit": 1},38: { "levelId": 5, "mem": bit2(0x22498e),"good": 1, "addr": 0x22498e, "bit": 2},39: { "levelId": 5, "mem": bit3(0x22498e),"good": 1, "addr": 0x22498e, "bit": 3},40: { "levelId": 5, "mem": bit4(0x22498e),"good": 1, "addr": 0x22498e, "bit": 4},41: { "levelId": 5, "mem": bit5(0x22498e),"good": 1, "addr": 0x22498e, "bit": 5},42: { "levelId": 5, "mem": bit6(0x22498e),"good": 1, "addr": 0x22498e, "bit": 6},43: { "levelId": 5, "mem": bit7(0x22498e),"good": 1, "addr": 0x22498e, "bit": 7},44: { "levelId": 5, "mem": bit0(0x22498f),"good": 1, "addr": 0x22498f, "bit": 0},45: { "levelId": 5, "mem": bit1(0x22498f),"good": 1, "addr": 0x22498f, "bit": 1},46: { "levelId": 5, "mem": bit2(0x22498f),"good": 1, "addr": 0x22498f, "bit": 2},47: { "levelId": 5, "mem": bit3(0x22498f),"good": 1, "addr": 0x22498f, "bit": 3},48: { "levelId": 5, "mem": bit4(0x22498f),"good": 1, "addr": 0x22498f, "bit": 4},49: { "levelId": 5, "mem": bit5(0x22498f),"good": 1, "addr": 0x22498f, "bit": 5},50: { "levelId": 5, "mem": bit6(0x22498f),"good": 1, "addr": 0x22498f, "bit": 6},51: { "levelId": 5, "mem": bit7(0x22498f),"good": 1, "addr": 0x22498f, "bit": 7},52: { "levelId": 5, "mem": bit0(0x224990),"good": 1, "addr": 0x224990, "bit": 0},53: { "levelId": 5, "mem": bit1(0x224990),"good": 1, "addr": 0x224990, "bit": 1},54: { "levelId": 5, "mem": bit2(0x224990),"good": 1, "addr": 0x224990, "bit": 2},55: { "levelId": 5, "mem": bit3(0x224990),"good": 1, "addr": 0x224990, "bit": 3},56: { "levelId": 5, "mem": bit4(0x224990),"good": 1, "addr": 0x224990, "bit": 4},57: { "levelId": 5, "mem": bit5(0x224990),"good": 1, "addr": 0x224990, "bit": 5},58: { "levelId": 5, "mem": bit6(0x224990),"good": 1, "addr": 0x224990, "bit": 6},59: { "levelId": 5, "mem": bit7(0x224990),"good": 1, "addr": 0x224990, "bit": 7},60: { "levelId": 5, "mem": bit0(0x224991),"good": 1, "addr": 0x224991, "bit": 0},61: { "levelId": 5, "mem": bit1(0x224991),"good": 1, "addr": 0x224991, "bit": 1},62: { "levelId": 5, "mem": bit2(0x224991),"good": 1, "addr": 0x224991, "bit": 2},63: { "levelId": 5, "mem": bit3(0x224991),"good": 1, "addr": 0x224991, "bit": 3},64: { "levelId": 5, "mem": bit4(0x224991),"good": 1, "addr": 0x224991, "bit": 4},65: { "levelId": 5, "mem": bit5(0x224991),"good": 1, "addr": 0x224991, "bit": 5},66: { "levelId": 5, "mem": bit6(0x224991),"good": 1, "addr": 0x224991, "bit": 6},67: { "levelId": 5, "mem": bit7(0x224991),"good": 1, "addr": 0x224991, "bit": 7},68: { "levelId": 5, "mem": bit0(0x224992),"good": 1, "addr": 0x224992, "bit": 0},69: { "levelId": 5, "mem": bit1(0x224992),"good": 1, "addr": 0x224992, "bit": 1},70: { "levelId": 5, "mem": bit2(0x224992),"good": 1, "addr": 0x224992, "bit": 2},71: { "levelId": 5, "mem": bit3(0x224992),"good": 1, "addr": 0x224992, "bit": 3},72: { "levelId": 5, "mem": bit4(0x224992),"good": 1, "addr": 0x224992, "bit": 4},73: { "levelId": 5, "mem": bit5(0x224992),"good": 1, "addr": 0x224992, "bit": 5},74: { "levelId": 5, "mem": bit6(0x224992),"good": 1, "addr": 0x224992, "bit": 6},75: { "levelId": 5, "mem": bit7(0x224992),"good": 1, "addr": 0x224992, "bit": 7},76: { "levelId": 5, "mem": bit0(0x224993),"good": 1, "addr": 0x224993, "bit": 0},77: { "levelId": 5, "mem": bit1(0x224993),"good": 1, "addr": 0x224993, "bit": 1},78: { "levelId": 5, "mem": bit2(0x224993),"good": 1, "addr": 0x224993, "bit": 2},79: { "levelId": 5, "mem": bit3(0x224993),"good": 1, "addr": 0x224993, "bit": 3},80: { "levelId": 5, "mem": bit4(0x224993),"good": 1, "addr": 0x224993, "bit": 4},81: { "levelId": 5, "mem": bit5(0x224993),"good": 1, "addr": 0x224993, "bit": 5},82: { "levelId": 5, "mem": bit6(0x224993),"good": 1, "addr": 0x224993, "bit": 6},83: { "levelId": 5, "mem": bit7(0x224993),"good": 1, "addr": 0x224993, "bit": 7},84: { "levelId": 5, "mem": bit0(0x224994),"good": 1, "addr": 0x224994, "bit": 0},85: { "levelId": 5, "mem": bit1(0x224994),"good": 1, "addr": 0x224994, "bit": 1},86: { "levelId": 5, "mem": bit2(0x224994),"good": 1, "addr": 0x224994, "bit": 2},87: { "levelId": 5, "mem": bit3(0x224994),"good": 1, "addr": 0x224994, "bit": 3},88: { "levelId": 6, "mem": bit4(0x224994),"good": 1, "addr": 0x224994, "bit": 4},89: { "levelId": 6, "mem": bit5(0x224994),"good": 1, "addr": 0x224994, "bit": 5},90: { "levelId": 6, "mem": bit6(0x224994),"good": 1, "addr": 0x224994, "bit": 6},91: { "levelId": 6, "mem": bit7(0x224994),"good": 1, "addr": 0x224994, "bit": 7},92: { "levelId": 6, "mem": bit0(0x224995),"good": 1, "addr": 0x224995, "bit": 0},93: { "levelId": 6, "mem": bit1(0x224995),"good": 1, "addr": 0x224995, "bit": 1},94: { "levelId": 6, "mem": bit2(0x224995),"good": 1, "addr": 0x224995, "bit": 2},95: { "levelId": 6, "mem": bit3(0x224995),"good": 1, "addr": 0x224995, "bit": 3},96: { "levelId": 6, "mem": bit4(0x224995),"good": 1, "addr": 0x224995, "bit": 4},97: { "levelId": 6, "mem": bit5(0x224995),"good": 1, "addr": 0x224995, "bit": 5},98: { "levelId": 6, "mem": bit6(0x224995),"good": 1, "addr": 0x224995, "bit": 6},99: { "levelId": 6, "mem": bit7(0x224995),"good": 1, "addr": 0x224995, "bit": 7},100: { "levelId": 6, "mem": bit0(0x224996),"good": 1, "addr": 0x224996, "bit": 0},101: { "levelId": 6, "mem": bit1(0x224996),"good": 1, "addr": 0x224996, "bit": 1},102: { "levelId": 6, "mem": bit2(0x224996),"good": 1, "addr": 0x224996, "bit": 2},103: { "levelId": 6, "mem": bit3(0x224996),"good": 1, "addr": 0x224996, "bit": 3},104: { "levelId": 6, "mem": bit4(0x224996),"good": 1, "addr": 0x224996, "bit": 4},105: { "levelId": 6, "mem": bit5(0x224996),"good": 1, "addr": 0x224996, "bit": 5},106: { "levelId": 6, "mem": bit6(0x224996),"good": 1, "addr": 0x224996, "bit": 6},107: { "levelId": 6, "mem": bit7(0x224996),"good": 1, "addr": 0x224996, "bit": 7},108: { "levelId": 6, "mem": bit0(0x224997),"good": 1, "addr": 0x224997, "bit": 0},109: { "levelId": 6, "mem": bit1(0x224997),"good": 1, "addr": 0x224997, "bit": 1},110: { "levelId": 6, "mem": bit2(0x224997),"good": 1, "addr": 0x224997, "bit": 2},111: { "levelId": 6, "mem": bit3(0x224997),"good": 1, "addr": 0x224997, "bit": 3},112: { "levelId": 6, "mem": bit4(0x224997),"good": 1, "addr": 0x224997, "bit": 4},113: { "levelId": 6, "mem": bit5(0x224997),"good": 1, "addr": 0x224997, "bit": 5},114: { "levelId": 6, "mem": bit6(0x224997),"good": 1, "addr": 0x224997, "bit": 6},115: { "levelId": 6, "mem": bit7(0x224997),"good": 1, "addr": 0x224997, "bit": 7},116: { "levelId": 6, "mem": bit0(0x224998),"good": 1, "addr": 0x224998, "bit": 0},117: { "levelId": 6, "mem": bit1(0x224998),"good": 1, "addr": 0x224998, "bit": 1},118: { "levelId": 6, "mem": bit2(0x224998),"good": 1, "addr": 0x224998, "bit": 2},119: { "levelId": 6, "mem": bit3(0x224998),"good": 1, "addr": 0x224998, "bit": 3},120: { "levelId": 6, "mem": bit4(0x224998),"good": 1, "addr": 0x224998, "bit": 4},121: { "levelId": 6, "mem": bit5(0x224998),"good": 1, "addr": 0x224998, "bit": 5},122: { "levelId": 6, "mem": bit6(0x224998),"good": 1, "addr": 0x224998, "bit": 6},123: { "levelId": 6, "mem": bit0(0x224999),"good": 1, "addr": 0x224999, "bit": 0},124: { "levelId": 6, "mem": bit1(0x224999),"good": 1, "addr": 0x224999, "bit": 1},125: { "levelId": 6, "mem": bit2(0x224999),"good": 1, "addr": 0x224999, "bit": 2},126: { "levelId": 6, "mem": bit3(0x224999),"good": 1, "addr": 0x224999, "bit": 3},127: { "levelId": 6, "mem": bit4(0x224999),"good": 1, "addr": 0x224999, "bit": 4},128: { "levelId": 6, "mem": bit5(0x224999),"good": 1, "addr": 0x224999, "bit": 5},129: { "levelId": 6, "mem": bit6(0x224999),"good": 1, "addr": 0x224999, "bit": 6},130: { "levelId": 6, "mem": bit7(0x224999),"good": 1, "addr": 0x224999, "bit": 7},131: { "levelId": 6, "mem": bit0(0x22499a),"good": 1, "addr": 0x22499a, "bit": 0},132: { "levelId": 6, "mem": bit1(0x22499a),"good": 1, "addr": 0x22499a, "bit": 1},133: { "levelId": 6, "mem": bit2(0x22499a),"good": 1, "addr": 0x22499a, "bit": 2},134: { "levelId": 6, "mem": bit3(0x22499a),"good": 1, "addr": 0x22499a, "bit": 3},135: { "levelId": 6, "mem": bit4(0x22499a),"good": 1, "addr": 0x22499a, "bit": 4},136: { "levelId": 6, "mem": bit5(0x22499a),"good": 1, "addr": 0x22499a, "bit": 5},137: { "levelId": 1, "mem": bit3(0x224a36),"good": 1, "addr": 0x224a36, "bit": 3},138: { "levelId": 1, "mem": bit4(0x224a36),"good": 1, "addr": 0x224a36, "bit": 4},139: { "levelId": 1, "mem": bit5(0x224a36),"good": 1, "addr": 0x224a36, "bit": 5},140: { "levelId": 1, "mem": bit6(0x224a36),"good": 1, "addr": 0x224a36, "bit": 6},141: { "levelId": 1, "mem": bit7(0x224a36),"good": 1, "addr": 0x224a36, "bit": 7},142: { "levelId": 6, "mem": bit7(0x224998),"good": 1, "addr": 0x224998, "bit": 7},143: { "levelId": 8, "mem": bit3(0x22499b),"good": 1, "addr": 0x22499b, "bit": 3},144: { "levelId": 8, "mem": bit4(0x22499b),"good": 1, "addr": 0x22499b, "bit": 4},145: { "levelId": 8, "mem": bit5(0x22499b),"good": 1, "addr": 0x22499b, "bit": 5},146: { "levelId": 8, "mem": bit5(0x22499c),"good": 1, "addr": 0x22499c, "bit": 5},147: { "levelId": 8, "mem": bit6(0x22499c),"good": 1, "addr": 0x22499c, "bit": 6},148: { "levelId": 8, "mem": bit7(0x22499c),"good": 1, "addr": 0x22499c, "bit": 7},149: { "levelId": 8, "mem": bit0(0x22499d),"good": 1, "addr": 0x22499d, "bit": 0},150: { "levelId": 8, "mem": bit1(0x22499d),"good": 1, "addr": 0x22499d, "bit": 1},151: { "levelId": 8, "mem": bit2(0x22499d),"good": 1, "addr": 0x22499d, "bit": 2},152: { "levelId": 8, "mem": bit3(0x22499d),"good": 1, "addr": 0x22499d, "bit": 3},153: { "levelId": 8, "mem": bit4(0x22499d),"good": 1, "addr": 0x22499d, "bit": 4},154: { "levelId": 8, "mem": bit5(0x22499d),"good": 1, "addr": 0x22499d, "bit": 5},155: { "levelId": 8, "mem": bit6(0x22499d),"good": 1, "addr": 0x22499d, "bit": 6},156: { "levelId": 8, "mem": bit7(0x22499d),"good": 1, "addr": 0x22499d, "bit": 7},157: { "levelId": 8, "mem": bit0(0x22499e),"good": 1, "addr": 0x22499e, "bit": 0},158: { "levelId": 8, "mem": bit1(0x22499e),"good": 1, "addr": 0x22499e, "bit": 1},159: { "levelId": 8, "mem": bit6(0x22499a),"good": 1, "addr": 0x22499a, "bit": 6},160: { "levelId": 8, "mem": bit7(0x22499a),"good": 1, "addr": 0x22499a, "bit": 7},161: { "levelId": 8, "mem": bit0(0x22499b),"good": 1, "addr": 0x22499b, "bit": 0},162: { "levelId": 8, "mem": bit1(0x22499b),"good": 1, "addr": 0x22499b, "bit": 1},163: { "levelId": 8, "mem": bit2(0x22499b),"good": 1, "addr": 0x22499b, "bit": 2},164: { "levelId": 8, "mem": bit6(0x22499b),"good": 1, "addr": 0x22499b, "bit": 6},165: { "levelId": 8, "mem": bit7(0x22499b),"good": 1, "addr": 0x22499b, "bit": 7},166: { "levelId": 8, "mem": bit0(0x22499c),"good": 1, "addr": 0x22499c, "bit": 0},167: { "levelId": 8, "mem": bit1(0x22499c),"good": 1, "addr": 0x22499c, "bit": 1},168: { "levelId": 8, "mem": bit2(0x22499c),"good": 1, "addr": 0x22499c, "bit": 2},169: { "levelId": 8, "mem": bit3(0x22499c),"good": 1, "addr": 0x22499c, "bit": 3},170: { "levelId": 8, "mem": bit4(0x22499c),"good": 1, "addr": 0x22499c, "bit": 4},171: { "levelId": 8, "mem": bit2(0x22499e),"good": 1, "addr": 0x22499e, "bit": 2},172: { "levelId": 8, "mem": bit3(0x22499e),"good": 1, "addr": 0x22499e, "bit": 3},173: { "levelId": 8, "mem": bit4(0x22499e),"good": 1, "addr": 0x22499e, "bit": 4},174: { "levelId": 8, "mem": bit5(0x22499e),"good": 1, "addr": 0x22499e, "bit": 5},175: { "levelId": 8, "mem": bit6(0x22499e),"good": 1, "addr": 0x22499e, "bit": 6},176: { "levelId": 8, "mem": bit7(0x22499e),"good": 1, "addr": 0x22499e, "bit": 7},177: { "levelId": 8, "mem": bit0(0x22499f),"good": 1, "addr": 0x22499f, "bit": 0},178: { "levelId": 8, "mem": bit1(0x22499f),"good": 1, "addr": 0x22499f, "bit": 1},179: { "levelId": 8, "mem": bit2(0x22499f),"good": 1, "addr": 0x22499f, "bit": 2},180: { "levelId": 8, "mem": bit3(0x22499f),"good": 1, "addr": 0x22499f, "bit": 3},181: { "levelId": 8, "mem": bit4(0x22499f),"good": 1, "addr": 0x22499f, "bit": 4},182: { "levelId": 8, "mem": bit5(0x22499f),"good": 1, "addr": 0x22499f, "bit": 5},183: { "levelId": 8, "mem": bit6(0x22499f),"good": 1, "addr": 0x22499f, "bit": 6},184: { "levelId": 8, "mem": bit7(0x22499f),"good": 1, "addr": 0x22499f, "bit": 7},185: { "levelId": 8, "mem": bit0(0x2249a0),"good": 1, "addr": 0x2249a0, "bit": 0},186: { "levelId": 8, "mem": bit1(0x2249a0),"good": 1, "addr": 0x2249a0, "bit": 1},187: { "levelId": 8, "mem": bit2(0x2249a0),"good": 1, "addr": 0x2249a0, "bit": 2},188: { "levelId": 8, "mem": bit3(0x2249a0),"good": 1, "addr": 0x2249a0, "bit": 3},189: { "levelId": 8, "mem": bit4(0x2249a0),"good": 1, "addr": 0x2249a0, "bit": 4},190: { "levelId": 8, "mem": bit5(0x2249a0),"good": 1, "addr": 0x2249a0, "bit": 5},191: { "levelId": 8, "mem": bit6(0x2249a0),"good": 1, "addr": 0x2249a0, "bit": 6},192: { "levelId": 8, "mem": bit7(0x2249a0),"good": 1, "addr": 0x2249a0, "bit": 7},193: { "levelId": 10, "mem": bit0(0x2249a1),"good": 1, "addr": 0x2249a1, "bit": 0},194: { "levelId": 10, "mem": bit1(0x2249a1),"good": 1, "addr": 0x2249a1, "bit": 1},195: { "levelId": 10, "mem": bit2(0x2249a1),"good": 1, "addr": 0x2249a1, "bit": 2},196: { "levelId": 10, "mem": bit3(0x2249a1),"good": 1, "addr": 0x2249a1, "bit": 3},197: { "levelId": 10, "mem": bit4(0x2249a1),"good": 1, "addr": 0x2249a1, "bit": 4},198: { "levelId": 10, "mem": bit2(0x2249a2),"good": 1, "addr": 0x2249a2, "bit": 2},199: { "levelId": 10, "mem": bit3(0x2249a2),"good": 1, "addr": 0x2249a2, "bit": 3},200: { "levelId": 10, "mem": bit4(0x2249a2),"good": 1, "addr": 0x2249a2, "bit": 4},201: { "levelId": 10, "mem": bit5(0x2249a2),"good": 1, "addr": 0x2249a2, "bit": 5},202: { "levelId": 10, "mem": bit6(0x2249a2),"good": 1, "addr": 0x2249a2, "bit": 6},203: { "levelId": 10, "mem": bit1(0x2249a4),"good": 1, "addr": 0x2249a4, "bit": 1},204: { "levelId": 10, "mem": bit5(0x2249a3),"good": 1, "addr": 0x2249a3, "bit": 5},205: { "levelId": 10, "mem": bit6(0x2249a3),"good": 1, "addr": 0x2249a3, "bit": 6},206: { "levelId": 10, "mem": bit7(0x2249a3),"good": 1, "addr": 0x2249a3, "bit": 7},207: { "levelId": 10, "mem": bit0(0x2249a4),"good": 1, "addr": 0x2249a4, "bit": 0},208: { "levelId": 10, "mem": bit3(0x2249a4),"good": 1, "addr": 0x2249a4, "bit": 3},209: { "levelId": 10, "mem": bit5(0x2249a4),"good": 1, "addr": 0x2249a4, "bit": 5},210: { "levelId": 10, "mem": bit6(0x2249a4),"good": 1, "addr": 0x2249a4, "bit": 6},211: { "levelId": 10, "mem": bit7(0x2249a4),"good": 1, "addr": 0x2249a4, "bit": 7},212: { "levelId": 10, "mem": bit0(0x2249a5),"good": 1, "addr": 0x2249a5, "bit": 0},213: { "levelId": 10, "mem": bit1(0x2249a5),"good": 1, "addr": 0x2249a5, "bit": 1},214: { "levelId": 10, "mem": bit2(0x2249a5),"good": 1, "addr": 0x2249a5, "bit": 2},215: { "levelId": 10, "mem": bit4(0x2249a4),"good": 1, "addr": 0x2249a4, "bit": 4},216: { "levelId": 11, "mem": bit6(0x2249e5),"good": 1, "addr": 0x2249e5, "bit": 6},217: { "levelId": 11, "mem": bit7(0x2249e5),"good": 1, "addr": 0x2249e5, "bit": 7},218: { "levelId": 11, "mem": bit0(0x2249e6),"good": 1, "addr": 0x2249e6, "bit": 0},219: { "levelId": 11, "mem": bit1(0x2249e6),"good": 1, "addr": 0x2249e6, "bit": 1},220: { "levelId": 11, "mem": bit2(0x2249e6),"good": 1, "addr": 0x2249e6, "bit": 2},221: { "levelId": 11, "mem": bit3(0x2249e6),"good": 1, "addr": 0x2249e6, "bit": 3},222: { "levelId": 11, "mem": bit4(0x2249e6),"good": 1, "addr": 0x2249e6, "bit": 4},223: { "levelId": 11, "mem": bit5(0x2249e6),"good": 1, "addr": 0x2249e6, "bit": 5},224: { "levelId": 11, "mem": bit6(0x2249e6),"good": 1, "addr": 0x2249e6, "bit": 6},225: { "levelId": 11, "mem": bit7(0x2249e6),"good": 1, "addr": 0x2249e6, "bit": 7},226: { "levelId": 11, "mem": bit0(0x2249e7),"good": 1, "addr": 0x2249e7, "bit": 0},227: { "levelId": 11, "mem": bit1(0x2249e7),"good": 1, "addr": 0x2249e7, "bit": 1},228: { "levelId": 11, "mem": bit2(0x2249e7),"good": 1, "addr": 0x2249e7, "bit": 2},229: { "levelId": 11, "mem": bit3(0x2249e7),"good": 1, "addr": 0x2249e7, "bit": 3},230: { "levelId": 11, "mem": bit4(0x2249e7),"good": 1, "addr": 0x2249e7, "bit": 4},231: { "levelId": 11, "mem": bit5(0x2249e7),"good": 1, "addr": 0x2249e7, "bit": 5},232: { "levelId": 11, "mem": bit6(0x2249e7),"good": 1, "addr": 0x2249e7, "bit": 6},233: { "levelId": 11, "mem": bit7(0x2249e7),"good": 1, "addr": 0x2249e7, "bit": 7},234: { "levelId": 11, "mem": bit0(0x2249e8),"good": 1, "addr": 0x2249e8, "bit": 0},235: { "levelId": 11, "mem": bit1(0x2249e8),"good": 1, "addr": 0x2249e8, "bit": 1},236: { "levelId": 11, "mem": bit2(0x2249e8),"good": 1, "addr": 0x2249e8, "bit": 2},237: { "levelId": 11, "mem": bit3(0x2249e8),"good": 1, "addr": 0x2249e8, "bit": 3},238: { "levelId": 11, "mem": bit4(0x2249e8),"good": 1, "addr": 0x2249e8, "bit": 4},239: { "levelId": 11, "mem": bit5(0x2249e8),"good": 1, "addr": 0x2249e8, "bit": 5},240: { "levelId": 11, "mem": bit6(0x2249e8),"good": 1, "addr": 0x2249e8, "bit": 6},241: { "levelId": 11, "mem": bit7(0x2249e8),"good": 1, "addr": 0x2249e8, "bit": 7},242: { "levelId": 11, "mem": bit0(0x2249e9),"good": 1, "addr": 0x2249e9, "bit": 0},243: { "levelId": 11, "mem": bit1(0x2249e9),"good": 1, "addr": 0x2249e9, "bit": 1},244: { "levelId": 11, "mem": bit2(0x2249e9),"good": 1, "addr": 0x2249e9, "bit": 2},245: { "levelId": 11, "mem": bit3(0x2249e9),"good": 1, "addr": 0x2249e9, "bit": 3},246: { "levelId": 11, "mem": bit4(0x2249e9),"good": 1, "addr": 0x2249e9, "bit": 4},247: { "levelId": 11, "mem": bit5(0x2249e9),"good": 1, "addr": 0x2249e9, "bit": 5},248: { "levelId": 11, "mem": bit6(0x2249e9),"good": 1, "addr": 0x2249e9, "bit": 6},249: { "levelId": 11, "mem": bit7(0x2249e9),"good": 1, "addr": 0x2249e9, "bit": 7},250: { "levelId": 11, "mem": bit0(0x2249ea),"good": 1, "addr": 0x2249ea, "bit": 0},251: { "levelId": 11, "mem": bit1(0x2249ea),"good": 1, "addr": 0x2249ea, "bit": 1},252: { "levelId": 11, "mem": bit2(0x2249ea),"good": 1, "addr": 0x2249ea, "bit": 2},253: { "levelId": 11, "mem": bit3(0x2249ea),"good": 1, "addr": 0x2249ea, "bit": 3},254: { "levelId": 11, "mem": bit4(0x2249ea),"good": 1, "addr": 0x2249ea, "bit": 4},255: { "levelId": 11, "mem": bit5(0x2249ea),"good": 1, "addr": 0x2249ea, "bit": 5},256: { "levelId": 11, "mem": bit6(0x2249ea),"good": 1, "addr": 0x2249ea, "bit": 6},257: { "levelId": 11, "mem": bit7(0x2249ea),"good": 1, "addr": 0x2249ea, "bit": 7},258: { "levelId": 11, "mem": bit0(0x2249eb),"good": 1, "addr": 0x2249eb, "bit": 0},259: { "levelId": 11, "mem": bit1(0x2249eb),"good": 1, "addr": 0x2249eb, "bit": 1},260: { "levelId": 11, "mem": bit2(0x2249eb),"good": 1, "addr": 0x2249eb, "bit": 2},261: { "levelId": 11, "mem": bit3(0x2249eb),"good": 1, "addr": 0x2249eb, "bit": 3},262: { "levelId": 11, "mem": bit4(0x2249eb),"good": 1, "addr": 0x2249eb, "bit": 4},263: { "levelId": 11, "mem": bit5(0x2249eb),"good": 1, "addr": 0x2249eb, "bit": 5},264: { "levelId": 11, "mem": bit6(0x2249eb),"good": 1, "addr": 0x2249eb, "bit": 6},265: { "levelId": 11, "mem": bit7(0x2249eb),"good": 1, "addr": 0x2249eb, "bit": 7},266: { "levelId": 10, "mem": bit2(0x2249a4),"good": 1, "addr": 0x2249a4, "bit": 2},267: { "levelId": 10, "mem": bit2(0x2249a3),"good": 1, "addr": 0x2249a3, "bit": 2},268: { "levelId": 10, "mem": bit3(0x2249a3),"good": 1, "addr": 0x2249a3, "bit": 3},269: { "levelId": 10, "mem": bit4(0x2249a3),"good": 1, "addr": 0x2249a3, "bit": 4},270: { "levelId": 10, "mem": bit0(0x2249a6),"good": 1, "addr": 0x2249a6, "bit": 0},271: { "levelId": 10, "mem": bit1(0x2249a6),"good": 1, "addr": 0x2249a6, "bit": 1},272: { "levelId": 10, "mem": bit2(0x2249a6),"good": 1, "addr": 0x2249a6, "bit": 2},273: { "levelId": 10, "mem": bit3(0x2249a6),"good": 1, "addr": 0x2249a6, "bit": 3},274: { "levelId": 10, "mem": bit6(0x2249a6),"good": 1, "addr": 0x2249a6, "bit": 6},275: { "levelId": 10, "mem": bit7(0x2249a6),"good": 1, "addr": 0x2249a6, "bit": 7},276: { "levelId": 10, "mem": bit0(0x2249a7),"good": 1, "addr": 0x2249a7, "bit": 0},277: { "levelId": 10, "mem": bit1(0x2249a7),"good": 1, "addr": 0x2249a7, "bit": 1},278: { "levelId": 10, "mem": bit5(0x2249a1),"good": 1, "addr": 0x2249a1, "bit": 5},279: { "levelId": 10, "mem": bit6(0x2249a1),"good": 1, "addr": 0x2249a1, "bit": 6},280: { "levelId": 10, "mem": bit7(0x2249a1),"good": 1, "addr": 0x2249a1, "bit": 7},281: { "levelId": 10, "mem": bit0(0x2249a2),"good": 1, "addr": 0x2249a2, "bit": 0},282: { "levelId": 10, "mem": bit1(0x2249a2),"good": 1, "addr": 0x2249a2, "bit": 1},283: { "levelId": 10, "mem": bit7(0x2249a2),"good": 1, "addr": 0x2249a2, "bit": 7},284: { "levelId": 10, "mem": bit0(0x2249a3),"good": 1, "addr": 0x2249a3, "bit": 0},285: { "levelId": 10, "mem": bit1(0x2249a3),"good": 1, "addr": 0x2249a3, "bit": 1},286: { "levelId": 10, "mem": bit3(0x2249a5),"good": 1, "addr": 0x2249a5, "bit": 3},287: { "levelId": 10, "mem": bit4(0x2249a5),"good": 1, "addr": 0x2249a5, "bit": 4},288: { "levelId": 10, "mem": bit5(0x2249a5),"good": 1, "addr": 0x2249a5, "bit": 5},289: { "levelId": 10, "mem": bit6(0x2249a5),"good": 1, "addr": 0x2249a5, "bit": 6},290: { "levelId": 10, "mem": bit7(0x2249a5),"good": 1, "addr": 0x2249a5, "bit": 7},291: { "levelId": 10, "mem": bit4(0x2249a6),"good": 1, "addr": 0x2249a6, "bit": 4},292: { "levelId": 10, "mem": bit5(0x2249a6),"good": 1, "addr": 0x2249a6, "bit": 5},293: { "levelId": 12, "mem": bit2(0x2249a7),"good": 1, "addr": 0x2249a7, "bit": 2},294: { "levelId": 12, "mem": bit3(0x2249a7),"good": 1, "addr": 0x2249a7, "bit": 3},295: { "levelId": 12, "mem": bit4(0x2249a7),"good": 1, "addr": 0x2249a7, "bit": 4},296: { "levelId": 12, "mem": bit5(0x2249a7),"good": 1, "addr": 0x2249a7, "bit": 5},297: { "levelId": 12, "mem": bit6(0x2249a7),"good": 1, "addr": 0x2249a7, "bit": 6},298: { "levelId": 12, "mem": bit7(0x2249a7),"good": 1, "addr": 0x2249a7, "bit": 7},299: { "levelId": 12, "mem": bit0(0x2249a8),"good": 1, "addr": 0x2249a8, "bit": 0},300: { "levelId": 12, "mem": bit1(0x2249a8),"good": 1, "addr": 0x2249a8, "bit": 1},301: { "levelId": 12, "mem": bit2(0x2249a8),"good": 1, "addr": 0x2249a8, "bit": 2},302: { "levelId": 12, "mem": bit3(0x2249a8),"good": 1, "addr": 0x2249a8, "bit": 3},303: { "levelId": 12, "mem": bit4(0x2249a8),"good": 1, "addr": 0x2249a8, "bit": 4},304: { "levelId": 12, "mem": bit5(0x2249a8),"good": 1, "addr": 0x2249a8, "bit": 5},305: { "levelId": 12, "mem": bit6(0x2249a8),"good": 1, "addr": 0x2249a8, "bit": 6},306: { "levelId": 12, "mem": bit7(0x2249a8),"good": 1, "addr": 0x2249a8, "bit": 7},307: { "levelId": 12, "mem": bit0(0x2249a9),"good": 1, "addr": 0x2249a9, "bit": 0},308: { "levelId": 12, "mem": bit1(0x2249a9),"good": 1, "addr": 0x2249a9, "bit": 1},309: { "levelId": 12, "mem": bit2(0x2249a9),"good": 1, "addr": 0x2249a9, "bit": 2},310: { "levelId": 12, "mem": bit3(0x2249a9),"good": 1, "addr": 0x2249a9, "bit": 3},311: { "levelId": 12, "mem": bit4(0x2249a9),"good": 1, "addr": 0x2249a9, "bit": 4},312: { "levelId": 12, "mem": bit5(0x2249a9),"good": 1, "addr": 0x2249a9, "bit": 5},313: { "levelId": 12, "mem": bit6(0x2249a9),"good": 1, "addr": 0x2249a9, "bit": 6},314: { "levelId": 12, "mem": bit1(0x2249aa),"good": 1, "addr": 0x2249aa, "bit": 1},315: { "levelId": 12, "mem": bit2(0x2249aa),"good": 1, "addr": 0x2249aa, "bit": 2},316: { "levelId": 12, "mem": bit2(0x2249ab),"good": 1, "addr": 0x2249ab, "bit": 2},317: { "levelId": 12, "mem": bit3(0x2249aa),"good": 1, "addr": 0x2249aa, "bit": 3},318: { "levelId": 12, "mem": bit4(0x2249ab),"good": 1, "addr": 0x2249ab, "bit": 4},319: { "levelId": 12, "mem": bit7(0x2249a9),"good": 1, "addr": 0x2249a9, "bit": 7},320: { "levelId": 12, "mem": bit0(0x2249aa),"good": 1, "addr": 0x2249aa, "bit": 0},321: { "levelId": 12, "mem": bit4(0x2249aa),"good": 1, "addr": 0x2249aa, "bit": 4},322: { "levelId": 12, "mem": bit5(0x2249aa),"good": 1, "addr": 0x2249aa, "bit": 5},323: { "levelId": 12, "mem": bit6(0x2249aa),"good": 1, "addr": 0x2249aa, "bit": 6},324: { "levelId": 12, "mem": bit7(0x2249aa),"good": 1, "addr": 0x2249aa, "bit": 7},325: { "levelId": 12, "mem": bit1(0x2249ab),"good": 1, "addr": 0x2249ab, "bit": 1},326: { "levelId": 12, "mem": bit3(0x2249ab),"good": 1, "addr": 0x2249ab, "bit": 3},327: { "levelId": 12, "mem": bit5(0x2249ab),"good": 1, "addr": 0x2249ab, "bit": 5},328: { "levelId": 12, "mem": bit0(0x2249ab),"good": 1, "addr": 0x2249ab, "bit": 0},329: { "levelId": 12, "mem": bit6(0x2249ab),"good": 1, "addr": 0x2249ab, "bit": 6},330: { "levelId": 12, "mem": bit7(0x2249ab),"good": 1, "addr": 0x2249ab, "bit": 7},331: { "levelId": 12, "mem": bit0(0x2249ac),"good": 1, "addr": 0x2249ac, "bit": 0},332: { "levelId": 12, "mem": bit1(0x2249ac),"good": 1, "addr": 0x2249ac, "bit": 1},333: { "levelId": 12, "mem": bit2(0x2249ac),"good": 1, "addr": 0x2249ac, "bit": 2},334: { "levelId": 12, "mem": bit3(0x2249ac),"good": 1, "addr": 0x2249ac, "bit": 3},335: { "levelId": 12, "mem": bit4(0x2249ac),"good": 1, "addr": 0x2249ac, "bit": 4},336: { "levelId": 12, "mem": bit5(0x2249ac),"good": 1, "addr": 0x2249ac, "bit": 5},337: { "levelId": 12, "mem": bit6(0x2249ac),"good": 1, "addr": 0x2249ac, "bit": 6},338: { "levelId": 12, "mem": bit7(0x2249ac),"good": 1, "addr": 0x2249ac, "bit": 7},339: { "levelId": 12, "mem": bit0(0x2249ad),"good": 1, "addr": 0x2249ad, "bit": 0},340: { "levelId": 12, "mem": bit1(0x2249ad),"good": 1, "addr": 0x2249ad, "bit": 1},341: { "levelId": 12, "mem": bit2(0x2249ad),"good": 1, "addr": 0x2249ad, "bit": 2},342: { "levelId": 12, "mem": bit3(0x2249ad),"good": 1, "addr": 0x2249ad, "bit": 3},343: { "levelId": 13, "mem": bit4(0x2249ad),"good": 1, "addr": 0x2249ad, "bit": 4},344: { "levelId": 13, "mem": bit5(0x2249ad),"good": 1, "addr": 0x2249ad, "bit": 5},345: { "levelId": 13, "mem": bit6(0x2249ad),"good": 1, "addr": 0x2249ad, "bit": 6},346: { "levelId": 13, "mem": bit7(0x2249ad),"good": 1, "addr": 0x2249ad, "bit": 7},347: { "levelId": 13, "mem": bit0(0x2249ae),"good": 1, "addr": 0x2249ae, "bit": 0},348: { "levelId": 13, "mem": bit1(0x2249ae),"good": 1, "addr": 0x2249ae, "bit": 1},349: { "levelId": 13, "mem": bit2(0x2249ae),"good": 1, "addr": 0x2249ae, "bit": 2},350: { "levelId": 13, "mem": bit3(0x2249ae),"good": 1, "addr": 0x2249ae, "bit": 3},351: { "levelId": 13, "mem": bit4(0x2249ae),"good": 1, "addr": 0x2249ae, "bit": 4},352: { "levelId": 13, "mem": bit5(0x2249ae),"good": 1, "addr": 0x2249ae, "bit": 5},353: { "levelId": 13, "mem": bit6(0x2249ae),"good": 1, "addr": 0x2249ae, "bit": 6},354: { "levelId": 13, "mem": bit7(0x2249ae),"good": 1, "addr": 0x2249ae, "bit": 7},355: { "levelId": 13, "mem": bit0(0x2249af),"good": 1, "addr": 0x2249af, "bit": 0},356: { "levelId": 13, "mem": bit1(0x2249af),"good": 1, "addr": 0x2249af, "bit": 1},357: { "levelId": 13, "mem": bit2(0x2249af),"good": 1, "addr": 0x2249af, "bit": 2},358: { "levelId": 13, "mem": bit3(0x2249af),"good": 1, "addr": 0x2249af, "bit": 3},359: { "levelId": 13, "mem": bit4(0x2249af),"good": 1, "addr": 0x2249af, "bit": 4},360: { "levelId": 13, "mem": bit5(0x2249af),"good": 1, "addr": 0x2249af, "bit": 5},361: { "levelId": 13, "mem": bit6(0x2249af),"good": 1, "addr": 0x2249af, "bit": 6},362: { "levelId": 13, "mem": bit7(0x2249af),"good": 1, "addr": 0x2249af, "bit": 7},363: { "levelId": 13, "mem": bit0(0x2249b0),"good": 1, "addr": 0x2249b0, "bit": 0},364: { "levelId": 13, "mem": bit1(0x2249b0),"good": 1, "addr": 0x2249b0, "bit": 1},365: { "levelId": 13, "mem": bit2(0x2249b0),"good": 1, "addr": 0x2249b0, "bit": 2},366: { "levelId": 13, "mem": bit3(0x2249b0),"good": 1, "addr": 0x2249b0, "bit": 3},367: { "levelId": 13, "mem": bit4(0x2249b0),"good": 1, "addr": 0x2249b0, "bit": 4},368: { "levelId": 13, "mem": bit5(0x2249b0),"good": 1, "addr": 0x2249b0, "bit": 5},369: { "levelId": 13, "mem": bit6(0x2249b0),"good": 1, "addr": 0x2249b0, "bit": 6},370: { "levelId": 13, "mem": bit7(0x2249b0),"good": 1, "addr": 0x2249b0, "bit": 7},371: { "levelId": 13, "mem": bit0(0x2249b1),"good": 1, "addr": 0x2249b1, "bit": 0},372: { "levelId": 13, "mem": bit1(0x2249b1),"good": 1, "addr": 0x2249b1, "bit": 1},373: { "levelId": 13, "mem": bit2(0x2249b1),"good": 1, "addr": 0x2249b1, "bit": 2},374: { "levelId": 13, "mem": bit3(0x2249b1),"good": 1, "addr": 0x2249b1, "bit": 3},375: { "levelId": 13, "mem": bit4(0x2249b1),"good": 1, "addr": 0x2249b1, "bit": 4},376: { "levelId": 13, "mem": bit5(0x2249b1),"good": 1, "addr": 0x2249b1, "bit": 5},377: { "levelId": 13, "mem": bit6(0x2249b1),"good": 1, "addr": 0x2249b1, "bit": 6},378: { "levelId": 13, "mem": bit7(0x2249b1),"good": 1, "addr": 0x2249b1, "bit": 7},379: { "levelId": 13, "mem": bit0(0x2249b2),"good": 1, "addr": 0x2249b2, "bit": 0},380: { "levelId": 13, "mem": bit1(0x2249b2),"good": 1, "addr": 0x2249b2, "bit": 1},381: { "levelId": 13, "mem": bit2(0x2249b2),"good": 1, "addr": 0x2249b2, "bit": 2},382: { "levelId": 13, "mem": bit3(0x2249b2),"good": 1, "addr": 0x2249b2, "bit": 3},383: { "levelId": 13, "mem": bit4(0x2249b2),"good": 1, "addr": 0x2249b2, "bit": 4},384: { "levelId": 13, "mem": bit5(0x2249b2),"good": 1, "addr": 0x2249b2, "bit": 5},385: { "levelId": 13, "mem": bit6(0x2249b2),"good": 1, "addr": 0x2249b2, "bit": 6},386: { "levelId": 13, "mem": bit7(0x2249b2),"good": 1, "addr": 0x2249b2, "bit": 7},387: { "levelId": 13, "mem": bit0(0x2249b3),"good": 1, "addr": 0x2249b3, "bit": 0},388: { "levelId": 13, "mem": bit1(0x2249b3),"good": 1, "addr": 0x2249b3, "bit": 1},389: { "levelId": 13, "mem": bit2(0x2249b3),"good": 1, "addr": 0x2249b3, "bit": 2},390: { "levelId": 13, "mem": bit3(0x2249b3),"good": 1, "addr": 0x2249b3, "bit": 3},391: { "levelId": 13, "mem": bit4(0x2249b3),"good": 1, "addr": 0x2249b3, "bit": 4},392: { "levelId": 13, "mem": bit5(0x2249b3),"good": 1, "addr": 0x2249b3, "bit": 5},393: { "levelId": 14, "mem": bit6(0x2249b3),"good": 1, "addr": 0x2249b3, "bit": 6},394: { "levelId": 14, "mem": bit7(0x2249b3),"good": 1, "addr": 0x2249b3, "bit": 7},395: { "levelId": 14, "mem": bit0(0x2249b4),"good": 1, "addr": 0x2249b4, "bit": 0},396: { "levelId": 14, "mem": bit1(0x2249b4),"good": 1, "addr": 0x2249b4, "bit": 1},397: { "levelId": 14, "mem": bit2(0x2249b4),"good": 1, "addr": 0x2249b4, "bit": 2},398: { "levelId": 14, "mem": bit3(0x2249b4),"good": 1, "addr": 0x2249b4, "bit": 3},399: { "levelId": 14, "mem": bit4(0x2249b4),"good": 1, "addr": 0x2249b4, "bit": 4},400: { "levelId": 14, "mem": bit5(0x2249b4),"good": 1, "addr": 0x2249b4, "bit": 5},401: { "levelId": 14, "mem": bit6(0x2249b4),"good": 1, "addr": 0x2249b4, "bit": 6},402: { "levelId": 14, "mem": bit7(0x2249b4),"good": 1, "addr": 0x2249b4, "bit": 7},403: { "levelId": 14, "mem": bit0(0x2249b5),"good": 1, "addr": 0x2249b5, "bit": 0},404: { "levelId": 14, "mem": bit1(0x2249b5),"good": 1, "addr": 0x2249b5, "bit": 1},405: { "levelId": 14, "mem": bit2(0x2249b5),"good": 1, "addr": 0x2249b5, "bit": 2},406: { "levelId": 14, "mem": bit3(0x2249b5),"good": 1, "addr": 0x2249b5, "bit": 3},407: { "levelId": 14, "mem": bit4(0x2249b5),"good": 1, "addr": 0x2249b5, "bit": 4},408: { "levelId": 14, "mem": bit5(0x2249b5),"good": 1, "addr": 0x2249b5, "bit": 5},409: { "levelId": 14, "mem": bit6(0x2249b5),"good": 1, "addr": 0x2249b5, "bit": 6},410: { "levelId": 14, "mem": bit7(0x2249b5),"good": 1, "addr": 0x2249b5, "bit": 7},411: { "levelId": 14, "mem": bit0(0x2249b6),"good": 1, "addr": 0x2249b6, "bit": 0},412: { "levelId": 14, "mem": bit1(0x2249b6),"good": 1, "addr": 0x2249b6, "bit": 1},413: { "levelId": 14, "mem": bit2(0x2249b6),"good": 1, "addr": 0x2249b6, "bit": 2},414: { "levelId": 14, "mem": bit3(0x2249b6),"good": 1, "addr": 0x2249b6, "bit": 3},415: { "levelId": 14, "mem": bit4(0x2249b6),"good": 1, "addr": 0x2249b6, "bit": 4},416: { "levelId": 14, "mem": bit5(0x2249b6),"good": 1, "addr": 0x2249b6, "bit": 5},417: { "levelId": 14, "mem": bit6(0x2249b6),"good": 1, "addr": 0x2249b6, "bit": 6},418: { "levelId": 14, "mem": bit7(0x2249b6),"good": 1, "addr": 0x2249b6, "bit": 7},419: { "levelId": 14, "mem": bit0(0x2249b7),"good": 1, "addr": 0x2249b7, "bit": 0},420: { "levelId": 14, "mem": bit1(0x2249b7),"good": 1, "addr": 0x2249b7, "bit": 1},421: { "levelId": 14, "mem": bit2(0x2249b7),"good": 1, "addr": 0x2249b7, "bit": 2},422: { "levelId": 14, "mem": bit3(0x2249b7),"good": 1, "addr": 0x2249b7, "bit": 3},423: { "levelId": 14, "mem": bit4(0x2249b7),"good": 1, "addr": 0x2249b7, "bit": 4},424: { "levelId": 14, "mem": bit5(0x2249b7),"good": 1, "addr": 0x2249b7, "bit": 5},425: { "levelId": 14, "mem": bit6(0x2249b7),"good": 1, "addr": 0x2249b7, "bit": 6},426: { "levelId": 14, "mem": bit7(0x2249b7),"good": 1, "addr": 0x2249b7, "bit": 7},427: { "levelId": 14, "mem": bit0(0x2249b8),"good": 1, "addr": 0x2249b8, "bit": 0},428: { "levelId": 14, "mem": bit1(0x2249b8),"good": 1, "addr": 0x2249b8, "bit": 1},429: { "levelId": 14, "mem": bit2(0x2249b8),"good": 1, "addr": 0x2249b8, "bit": 2},430: { "levelId": 14, "mem": bit3(0x2249b8),"good": 1, "addr": 0x2249b8, "bit": 3},431: { "levelId": 14, "mem": bit4(0x2249b8),"good": 1, "addr": 0x2249b8, "bit": 4},432: { "levelId": 14, "mem": bit5(0x2249b8),"good": 1, "addr": 0x2249b8, "bit": 5},433: { "levelId": 14, "mem": bit6(0x2249b8),"good": 1, "addr": 0x2249b8, "bit": 6},434: { "levelId": 14, "mem": bit7(0x2249b8),"good": 1, "addr": 0x2249b8, "bit": 7},435: { "levelId": 14, "mem": bit0(0x2249b9),"good": 1, "addr": 0x2249b9, "bit": 0},436: { "levelId": 14, "mem": bit1(0x2249b9),"good": 1, "addr": 0x2249b9, "bit": 1},437: { "levelId": 14, "mem": bit2(0x2249b9),"good": 1, "addr": 0x2249b9, "bit": 2},438: { "levelId": 14, "mem": bit3(0x2249b9),"good": 1, "addr": 0x2249b9, "bit": 3},439: { "levelId": 14, "mem": bit4(0x2249b9),"good": 1, "addr": 0x2249b9, "bit": 4},440: { "levelId": 14, "mem": bit5(0x2249b9),"good": 1, "addr": 0x2249b9, "bit": 5},441: { "levelId": 14, "mem": bit6(0x2249b9),"good": 1, "addr": 0x2249b9, "bit": 6},442: { "levelId": 14, "mem": bit7(0x2249b9),"good": 1, "addr": 0x2249b9, "bit": 7},443: { "levelId": 15, "mem": bit0(0x2249ba),"good": 1, "addr": 0x2249ba, "bit": 0},444: { "levelId": 15, "mem": bit1(0x2249ba),"good": 1, "addr": 0x2249ba, "bit": 1},445: { "levelId": 15, "mem": bit2(0x2249ba),"good": 1, "addr": 0x2249ba, "bit": 2},446: { "levelId": 15, "mem": bit3(0x2249ba),"good": 1, "addr": 0x2249ba, "bit": 3},447: { "levelId": 15, "mem": bit4(0x2249ba),"good": 1, "addr": 0x2249ba, "bit": 4},448: { "levelId": 15, "mem": bit5(0x2249ba),"good": 1, "addr": 0x2249ba, "bit": 5},449: { "levelId": 15, "mem": bit6(0x2249ba),"good": 1, "addr": 0x2249ba, "bit": 6},450: { "levelId": 15, "mem": bit7(0x2249ba),"good": 1, "addr": 0x2249ba, "bit": 7},451: { "levelId": 15, "mem": bit0(0x2249bb),"good": 1, "addr": 0x2249bb, "bit": 0},452: { "levelId": 15, "mem": bit1(0x2249bb),"good": 1, "addr": 0x2249bb, "bit": 1},453: { "levelId": 15, "mem": bit2(0x2249bb),"good": 1, "addr": 0x2249bb, "bit": 2},454: { "levelId": 15, "mem": bit3(0x2249bb),"good": 1, "addr": 0x2249bb, "bit": 3},455: { "levelId": 15, "mem": bit4(0x2249bb),"good": 1, "addr": 0x2249bb, "bit": 4},456: { "levelId": 15, "mem": bit5(0x2249bb),"good": 1, "addr": 0x2249bb, "bit": 5},457: { "levelId": 15, "mem": bit6(0x2249bb),"good": 1, "addr": 0x2249bb, "bit": 6},458: { "levelId": 15, "mem": bit7(0x2249bb),"good": 1, "addr": 0x2249bb, "bit": 7},459: { "levelId": 15, "mem": bit0(0x2249bc),"good": 1, "addr": 0x2249bc, "bit": 0},460: { "levelId": 15, "mem": bit1(0x2249bc),"good": 1, "addr": 0x2249bc, "bit": 1},461: { "levelId": 15, "mem": bit2(0x2249bc),"good": 1, "addr": 0x2249bc, "bit": 2},462: { "levelId": 15, "mem": bit3(0x2249bc),"good": 1, "addr": 0x2249bc, "bit": 3},463: { "levelId": 15, "mem": bit4(0x2249bc),"good": 1, "addr": 0x2249bc, "bit": 4},464: { "levelId": 15, "mem": bit5(0x2249bc),"good": 1, "addr": 0x2249bc, "bit": 5},465: { "levelId": 15, "mem": bit6(0x2249bc),"good": 1, "addr": 0x2249bc, "bit": 6},466: { "levelId": 15, "mem": bit7(0x2249bc),"good": 1, "addr": 0x2249bc, "bit": 7},467: { "levelId": 15, "mem": bit0(0x2249bd),"good": 1, "addr": 0x2249bd, "bit": 0},468: { "levelId": 15, "mem": bit1(0x2249bd),"good": 1, "addr": 0x2249bd, "bit": 1},469: { "levelId": 15, "mem": bit2(0x2249bd),"good": 1, "addr": 0x2249bd, "bit": 2},470: { "levelId": 15, "mem": bit3(0x2249bd),"good": 1, "addr": 0x2249bd, "bit": 3},471: { "levelId": 15, "mem": bit4(0x2249bd),"good": 1, "addr": 0x2249bd, "bit": 4},472: { "levelId": 15, "mem": bit5(0x2249bd),"good": 1, "addr": 0x2249bd, "bit": 5},473: { "levelId": 15, "mem": bit6(0x2249bd),"good": 1, "addr": 0x2249bd, "bit": 6},474: { "levelId": 15, "mem": bit7(0x2249bd),"good": 1, "addr": 0x2249bd, "bit": 7},475: { "levelId": 15, "mem": bit0(0x2249be),"good": 1, "addr": 0x2249be, "bit": 0},476: { "levelId": 15, "mem": bit1(0x2249be),"good": 1, "addr": 0x2249be, "bit": 1},477: { "levelId": 15, "mem": bit2(0x2249be),"good": 1, "addr": 0x2249be, "bit": 2},478: { "levelId": 15, "mem": bit3(0x2249be),"good": 1, "addr": 0x2249be, "bit": 3},479: { "levelId": 15, "mem": bit4(0x2249be),"good": 1, "addr": 0x2249be, "bit": 4},480: { "levelId": 15, "mem": bit5(0x2249be),"good": 1, "addr": 0x2249be, "bit": 5},481: { "levelId": 15, "mem": bit6(0x2249be),"good": 1, "addr": 0x2249be, "bit": 6},482: { "levelId": 15, "mem": bit7(0x2249be),"good": 1, "addr": 0x2249be, "bit": 7},483: { "levelId": 15, "mem": bit0(0x2249bf),"good": 1, "addr": 0x2249bf, "bit": 0},484: { "levelId": 15, "mem": bit1(0x2249bf),"good": 1, "addr": 0x2249bf, "bit": 1},485: { "levelId": 15, "mem": bit2(0x2249bf),"good": 1, "addr": 0x2249bf, "bit": 2},486: { "levelId": 15, "mem": bit3(0x2249bf),"good": 1, "addr": 0x2249bf, "bit": 3},487: { "levelId": 15, "mem": bit4(0x2249bf),"good": 1, "addr": 0x2249bf, "bit": 4},488: { "levelId": 15, "mem": bit5(0x2249bf),"good": 1, "addr": 0x2249bf, "bit": 5},489: { "levelId": 15, "mem": bit6(0x2249bf),"good": 1, "addr": 0x2249bf, "bit": 6},490: { "levelId": 15, "mem": bit7(0x2249bf),"good": 1, "addr": 0x2249bf, "bit": 7},491: { "levelId": 15, "mem": bit0(0x2249c0),"good": 1, "addr": 0x2249c0, "bit": 0},492: { "levelId": 15, "mem": bit1(0x2249c0),"good": 1, "addr": 0x2249c0, "bit": 1},493: { "levelId": 2, "mem": bit0(0x224989),"good": 1, "addr": 0x224989, "bit": 0},494: { "levelId": 2, "mem": bit1(0x224989),"good": 1, "addr": 0x224989, "bit": 1},495: { "levelId": 2, "mem": bit3(0x224989),"good": 1, "addr": 0x224989, "bit": 3},496: { "levelId": 2, "mem": bit4(0x224989),"good": 1, "addr": 0x224989, "bit": 4},497: { "levelId": 2, "mem": bit5(0x224989),"good": 1, "addr": 0x224989, "bit": 5},498: { "levelId": 2, "mem": bit6(0x224989),"good": 1, "addr": 0x224989, "bit": 6},499: { "levelId": 2, "mem": bit7(0x224989),"good": 1, "addr": 0x224989, "bit": 7},500: { "levelId": 2, "mem": bit0(0x22498a),"good": 1, "addr": 0x22498a, "bit": 0},501: { "levelId": 2, "mem": bit0(0x22498b),"good": 1, "addr": 0x22498b, "bit": 0},502: { "levelId": 2, "mem": bit1(0x22498b),"good": 1, "addr": 0x22498b, "bit": 1},503: { "levelId": 2, "mem": bit2(0x22498b),"good": 1, "addr": 0x22498b, "bit": 2},504: { "levelId": 2, "mem": bit3(0x22498b),"good": 1, "addr": 0x22498b, "bit": 3},505: { "levelId": 2, "mem": bit4(0x22498b),"good": 1, "addr": 0x22498b, "bit": 4},506: { "levelId": 16, "mem": bit2(0x2249c0),"good": 1, "addr": 0x2249c0, "bit": 2},507: { "levelId": 16, "mem": bit3(0x2249c0),"good": 1, "addr": 0x2249c0, "bit": 3},508: { "levelId": 16, "mem": bit4(0x2249c0),"good": 1, "addr": 0x2249c0, "bit": 4},509: { "levelId": 16, "mem": bit5(0x2249c0),"good": 1, "addr": 0x2249c0, "bit": 5},510: { "levelId": 16, "mem": bit6(0x2249c0),"good": 1, "addr": 0x2249c0, "bit": 6},511: { "levelId": 16, "mem": bit7(0x2249c0),"good": 1, "addr": 0x2249c0, "bit": 7},512: { "levelId": 16, "mem": bit0(0x2249c1),"good": 1, "addr": 0x2249c1, "bit": 0},513: { "levelId": 16, "mem": bit1(0x2249c1),"good": 1, "addr": 0x2249c1, "bit": 1},514: { "levelId": 16, "mem": bit2(0x2249c1),"good": 1, "addr": 0x2249c1, "bit": 2},515: { "levelId": 16, "mem": bit3(0x2249c1),"good": 1, "addr": 0x2249c1, "bit": 3},516: { "levelId": 16, "mem": bit4(0x2249c1),"good": 1, "addr": 0x2249c1, "bit": 4},517: { "levelId": 16, "mem": bit5(0x2249c1),"good": 1, "addr": 0x2249c1, "bit": 5},518: { "levelId": 16, "mem": bit6(0x2249c1),"good": 1, "addr": 0x2249c1, "bit": 6},519: { "levelId": 16, "mem": bit7(0x2249c1),"good": 1, "addr": 0x2249c1, "bit": 7},520: { "levelId": 16, "mem": bit0(0x2249c2),"good": 1, "addr": 0x2249c2, "bit": 0},521: { "levelId": 16, "mem": bit1(0x2249c2),"good": 1, "addr": 0x2249c2, "bit": 1},522: { "levelId": 16, "mem": bit2(0x2249c2),"good": 1, "addr": 0x2249c2, "bit": 2},523: { "levelId": 16, "mem": bit3(0x2249c2),"good": 1, "addr": 0x2249c2, "bit": 3},524: { "levelId": 16, "mem": bit4(0x2249c2),"good": 1, "addr": 0x2249c2, "bit": 4},525: { "levelId": 16, "mem": bit5(0x2249c2),"good": 1, "addr": 0x2249c2, "bit": 5},526: { "levelId": 16, "mem": bit6(0x2249c2),"good": 1, "addr": 0x2249c2, "bit": 6},527: { "levelId": 16, "mem": bit7(0x2249c2),"good": 1, "addr": 0x2249c2, "bit": 7},528: { "levelId": 16, "mem": bit0(0x2249c3),"good": 1, "addr": 0x2249c3, "bit": 0},529: { "levelId": 16, "mem": bit1(0x2249c3),"good": 1, "addr": 0x2249c3, "bit": 1},530: { "levelId": 16, "mem": bit2(0x2249c3),"good": 1, "addr": 0x2249c3, "bit": 2},531: { "levelId": 16, "mem": bit3(0x2249c3),"good": 1, "addr": 0x2249c3, "bit": 3},532: { "levelId": 16, "mem": bit4(0x2249c3),"good": 1, "addr": 0x2249c3, "bit": 4},533: { "levelId": 16, "mem": bit5(0x2249c3),"good": 1, "addr": 0x2249c3, "bit": 5},534: { "levelId": 16, "mem": bit6(0x2249c3),"good": 1, "addr": 0x2249c3, "bit": 6},535: { "levelId": 16, "mem": bit7(0x2249c3),"good": 1, "addr": 0x2249c3, "bit": 7},536: { "levelId": 16, "mem": bit0(0x2249c4),"good": 1, "addr": 0x2249c4, "bit": 0},537: { "levelId": 16, "mem": bit1(0x2249c4),"good": 1, "addr": 0x2249c4, "bit": 1},538: { "levelId": 16, "mem": bit2(0x2249c4),"good": 1, "addr": 0x2249c4, "bit": 2},539: { "levelId": 16, "mem": bit3(0x2249c4),"good": 1, "addr": 0x2249c4, "bit": 3},540: { "levelId": 16, "mem": bit4(0x2249c4),"good": 1, "addr": 0x2249c4, "bit": 4},541: { "levelId": 16, "mem": bit5(0x2249c4),"good": 1, "addr": 0x2249c4, "bit": 5},542: { "levelId": 16, "mem": bit6(0x2249c4),"good": 1, "addr": 0x2249c4, "bit": 6},543: { "levelId": 16, "mem": bit7(0x2249c4),"good": 1, "addr": 0x2249c4, "bit": 7},544: { "levelId": 16, "mem": bit0(0x2249c5),"good": 1, "addr": 0x2249c5, "bit": 0},545: { "levelId": 16, "mem": bit1(0x2249c5),"good": 1, "addr": 0x2249c5, "bit": 1},546: { "levelId": 16, "mem": bit2(0x2249c5),"good": 1, "addr": 0x2249c5, "bit": 2},547: { "levelId": 16, "mem": bit3(0x2249c5),"good": 1, "addr": 0x2249c5, "bit": 3},548: { "levelId": 16, "mem": bit4(0x2249c5),"good": 1, "addr": 0x2249c5, "bit": 4},549: { "levelId": 16, "mem": bit5(0x2249c5),"good": 1, "addr": 0x2249c5, "bit": 5},550: { "levelId": 16, "mem": bit6(0x2249c5),"good": 1, "addr": 0x2249c5, "bit": 6},551: { "levelId": 16, "mem": bit7(0x2249c5),"good": 1, "addr": 0x2249c5, "bit": 7},552: { "levelId": 16, "mem": bit0(0x2249c6),"good": 1, "addr": 0x2249c6, "bit": 0},553: { "levelId": 16, "mem": bit1(0x2249c6),"good": 1, "addr": 0x2249c6, "bit": 1},554: { "levelId": 16, "mem": bit2(0x2249c6),"good": 1, "addr": 0x2249c6, "bit": 2},555: { "levelId": 16, "mem": bit3(0x2249c6),"good": 1, "addr": 0x2249c6, "bit": 3},556: { "levelId": 17, "mem": bit4(0x2249c6),"good": 1, "addr": 0x2249c6, "bit": 4},557: { "levelId": 17, "mem": bit5(0x2249c6),"good": 1, "addr": 0x2249c6, "bit": 5},558: { "levelId": 17, "mem": bit6(0x2249c6),"good": 1, "addr": 0x2249c6, "bit": 6},559: { "levelId": 17, "mem": bit7(0x2249c6),"good": 1, "addr": 0x2249c6, "bit": 7},560: { "levelId": 17, "mem": bit0(0x2249c7),"good": 1, "addr": 0x2249c7, "bit": 0},561: { "levelId": 17, "mem": bit1(0x2249c7),"good": 1, "addr": 0x2249c7, "bit": 1},562: { "levelId": 17, "mem": bit2(0x2249c7),"good": 1, "addr": 0x2249c7, "bit": 2},563: { "levelId": 17, "mem": bit3(0x2249c7),"good": 1, "addr": 0x2249c7, "bit": 3},564: { "levelId": 17, "mem": bit4(0x2249c7),"good": 1, "addr": 0x2249c7, "bit": 4},565: { "levelId": 17, "mem": bit5(0x2249c7),"good": 1, "addr": 0x2249c7, "bit": 5},566: { "levelId": 17, "mem": bit6(0x2249c7),"good": 1, "addr": 0x2249c7, "bit": 6},567: { "levelId": 17, "mem": bit7(0x2249c7),"good": 1, "addr": 0x2249c7, "bit": 7},568: { "levelId": 17, "mem": bit0(0x2249c8),"good": 1, "addr": 0x2249c8, "bit": 0},569: { "levelId": 17, "mem": bit1(0x2249c8),"good": 1, "addr": 0x2249c8, "bit": 1},570: { "levelId": 17, "mem": bit2(0x2249c8),"good": 1, "addr": 0x2249c8, "bit": 2},571: { "levelId": 17, "mem": bit3(0x2249c8),"good": 1, "addr": 0x2249c8, "bit": 3},572: { "levelId": 17, "mem": bit4(0x2249c8),"good": 1, "addr": 0x2249c8, "bit": 4},573: { "levelId": 17, "mem": bit5(0x2249c8),"good": 1, "addr": 0x2249c8, "bit": 5},574: { "levelId": 17, "mem": bit6(0x2249c8),"good": 1, "addr": 0x2249c8, "bit": 6},575: { "levelId": 17, "mem": bit7(0x2249c8),"good": 1, "addr": 0x2249c8, "bit": 7},576: { "levelId": 17, "mem": bit0(0x2249c9),"good": 1, "addr": 0x2249c9, "bit": 0},577: { "levelId": 17, "mem": bit1(0x2249c9),"good": 1, "addr": 0x2249c9, "bit": 1},578: { "levelId": 17, "mem": bit2(0x2249c9),"good": 1, "addr": 0x2249c9, "bit": 2},579: { "levelId": 17, "mem": bit3(0x2249c9),"good": 1, "addr": 0x2249c9, "bit": 3},580: { "levelId": 17, "mem": bit4(0x2249c9),"good": 1, "addr": 0x2249c9, "bit": 4},581: { "levelId": 17, "mem": bit5(0x2249c9),"good": 1, "addr": 0x2249c9, "bit": 5},582: { "levelId": 17, "mem": bit6(0x2249c9),"good": 1, "addr": 0x2249c9, "bit": 6},583: { "levelId": 17, "mem": bit7(0x2249c9),"good": 1, "addr": 0x2249c9, "bit": 7},584: { "levelId": 17, "mem": bit0(0x2249ca),"good": 1, "addr": 0x2249ca, "bit": 0},585: { "levelId": 17, "mem": bit1(0x2249ca),"good": 1, "addr": 0x2249ca, "bit": 1},586: { "levelId": 17, "mem": bit2(0x2249ca),"good": 1, "addr": 0x2249ca, "bit": 2},587: { "levelId": 17, "mem": bit3(0x2249ca),"good": 1, "addr": 0x2249ca, "bit": 3},588: { "levelId": 17, "mem": bit4(0x2249ca),"good": 1, "addr": 0x2249ca, "bit": 4},589: { "levelId": 17, "mem": bit5(0x2249ca),"good": 1, "addr": 0x2249ca, "bit": 5},590: { "levelId": 17, "mem": bit6(0x2249ca),"good": 1, "addr": 0x2249ca, "bit": 6},591: { "levelId": 17, "mem": bit7(0x2249ca),"good": 1, "addr": 0x2249ca, "bit": 7},592: { "levelId": 17, "mem": bit0(0x2249cb),"good": 1, "addr": 0x2249cb, "bit": 0},593: { "levelId": 17, "mem": bit1(0x2249cb),"good": 1, "addr": 0x2249cb, "bit": 1},594: { "levelId": 17, "mem": bit2(0x2249cb),"good": 1, "addr": 0x2249cb, "bit": 2},595: { "levelId": 17, "mem": bit3(0x2249cb),"good": 1, "addr": 0x2249cb, "bit": 3},596: { "levelId": 17, "mem": bit4(0x2249cb),"good": 1, "addr": 0x2249cb, "bit": 4},597: { "levelId": 17, "mem": bit5(0x2249cb),"good": 1, "addr": 0x2249cb, "bit": 5},598: { "levelId": 17, "mem": bit6(0x2249cb),"good": 1, "addr": 0x2249cb, "bit": 6},599: { "levelId": 17, "mem": bit7(0x2249cb),"good": 1, "addr": 0x2249cb, "bit": 7},600: { "levelId": 17, "mem": bit0(0x2249cc),"good": 1, "addr": 0x2249cc, "bit": 0},601: { "levelId": 17, "mem": bit1(0x2249cc),"good": 1, "addr": 0x2249cc, "bit": 1},602: { "levelId": 17, "mem": bit2(0x2249cc),"good": 1, "addr": 0x2249cc, "bit": 2},603: { "levelId": 17, "mem": bit3(0x2249cc),"good": 1, "addr": 0x2249cc, "bit": 3},604: { "levelId": 17, "mem": bit4(0x2249cc),"good": 1, "addr": 0x2249cc, "bit": 4},605: { "levelId": 17, "mem": bit5(0x2249cc),"good": 1, "addr": 0x2249cc, "bit": 5},606: { "levelId": 18, "mem": bit6(0x2249cc),"good": 1, "addr": 0x2249cc, "bit": 6},607: { "levelId": 18, "mem": bit7(0x2249cc),"good": 1, "addr": 0x2249cc, "bit": 7},608: { "levelId": 18, "mem": bit0(0x2249cd),"good": 1, "addr": 0x2249cd, "bit": 0},609: { "levelId": 18, "mem": bit1(0x2249cd),"good": 1, "addr": 0x2249cd, "bit": 1},610: { "levelId": 18, "mem": bit2(0x2249cd),"good": 1, "addr": 0x2249cd, "bit": 2},611: { "levelId": 18, "mem": bit3(0x2249cd),"good": 1, "addr": 0x2249cd, "bit": 3},612: { "levelId": 18, "mem": bit4(0x2249cd),"good": 1, "addr": 0x2249cd, "bit": 4},613: { "levelId": 18, "mem": bit5(0x2249cd),"good": 1, "addr": 0x2249cd, "bit": 5},614: { "levelId": 18, "mem": bit6(0x2249cd),"good": 1, "addr": 0x2249cd, "bit": 6},615: { "levelId": 18, "mem": bit7(0x2249cd),"good": 1, "addr": 0x2249cd, "bit": 7},616: { "levelId": 18, "mem": bit0(0x2249ce),"good": 1, "addr": 0x2249ce, "bit": 0},617: { "levelId": 18, "mem": bit1(0x2249ce),"good": 1, "addr": 0x2249ce, "bit": 1},618: { "levelId": 18, "mem": bit2(0x2249ce),"good": 1, "addr": 0x2249ce, "bit": 2},619: { "levelId": 18, "mem": bit3(0x2249ce),"good": 1, "addr": 0x2249ce, "bit": 3},620: { "levelId": 18, "mem": bit4(0x2249ce),"good": 1, "addr": 0x2249ce, "bit": 4},621: { "levelId": 18, "mem": bit5(0x2249ce),"good": 1, "addr": 0x2249ce, "bit": 5},622: { "levelId": 18, "mem": bit6(0x2249ce),"good": 1, "addr": 0x2249ce, "bit": 6},623: { "levelId": 18, "mem": bit7(0x2249ce),"good": 1, "addr": 0x2249ce, "bit": 7},624: { "levelId": 18, "mem": bit0(0x2249cf),"good": 1, "addr": 0x2249cf, "bit": 0},625: { "levelId": 18, "mem": bit1(0x2249cf),"good": 1, "addr": 0x2249cf, "bit": 1},626: { "levelId": 18, "mem": bit2(0x2249cf),"good": 1, "addr": 0x2249cf, "bit": 2},627: { "levelId": 18, "mem": bit3(0x2249cf),"good": 1, "addr": 0x2249cf, "bit": 3},628: { "levelId": 18, "mem": bit4(0x2249cf),"good": 1, "addr": 0x2249cf, "bit": 4},629: { "levelId": 18, "mem": bit5(0x2249cf),"good": 1, "addr": 0x2249cf, "bit": 5},630: { "levelId": 18, "mem": bit6(0x2249cf),"good": 1, "addr": 0x2249cf, "bit": 6},631: { "levelId": 18, "mem": bit7(0x2249cf),"good": 1, "addr": 0x2249cf, "bit": 7},632: { "levelId": 18, "mem": bit0(0x2249d0),"good": 1, "addr": 0x2249d0, "bit": 0},633: { "levelId": 18, "mem": bit1(0x2249d0),"good": 1, "addr": 0x2249d0, "bit": 1},634: { "levelId": 18, "mem": bit2(0x2249d0),"good": 1, "addr": 0x2249d0, "bit": 2},635: { "levelId": 18, "mem": bit3(0x2249d0),"good": 1, "addr": 0x2249d0, "bit": 3},636: { "levelId": 18, "mem": bit4(0x2249d0),"good": 1, "addr": 0x2249d0, "bit": 4},637: { "levelId": 18, "mem": bit5(0x2249d0),"good": 1, "addr": 0x2249d0, "bit": 5},638: { "levelId": 18, "mem": bit6(0x2249d0),"good": 1, "addr": 0x2249d0, "bit": 6},639: { "levelId": 18, "mem": bit7(0x2249d0),"good": 1, "addr": 0x2249d0, "bit": 7},640: { "levelId": 18, "mem": bit0(0x2249d1),"good": 1, "addr": 0x2249d1, "bit": 0},641: { "levelId": 18, "mem": bit1(0x2249d1),"good": 1, "addr": 0x2249d1, "bit": 1},642: { "levelId": 18, "mem": bit2(0x2249d1),"good": 1, "addr": 0x2249d1, "bit": 2},643: { "levelId": 18, "mem": bit3(0x2249d1),"good": 1, "addr": 0x2249d1, "bit": 3},644: { "levelId": 18, "mem": bit4(0x2249d1),"good": 1, "addr": 0x2249d1, "bit": 4},645: { "levelId": 18, "mem": bit5(0x2249d1),"good": 1, "addr": 0x2249d1, "bit": 5},646: { "levelId": 18, "mem": bit6(0x2249d1),"good": 1, "addr": 0x2249d1, "bit": 6},647: { "levelId": 18, "mem": bit7(0x2249d1),"good": 1, "addr": 0x2249d1, "bit": 7},648: { "levelId": 18, "mem": bit0(0x2249d2),"good": 1, "addr": 0x2249d2, "bit": 0},649: { "levelId": 18, "mem": bit1(0x2249d2),"good": 1, "addr": 0x2249d2, "bit": 1},650: { "levelId": 18, "mem": bit2(0x2249d2),"good": 1, "addr": 0x2249d2, "bit": 2},651: { "levelId": 18, "mem": bit3(0x2249d2),"good": 1, "addr": 0x2249d2, "bit": 3},652: { "levelId": 18, "mem": bit4(0x2249d2),"good": 1, "addr": 0x2249d2, "bit": 4},653: { "levelId": 18, "mem": bit5(0x2249d2),"good": 1, "addr": 0x2249d2, "bit": 5},654: { "levelId": 18, "mem": bit6(0x2249d2),"good": 1, "addr": 0x2249d2, "bit": 6},655: { "levelId": 18, "mem": bit7(0x2249d2),"good": 1, "addr": 0x2249d2, "bit": 7},656: { "levelId": 19, "mem": bit0(0x2249d3),"good": 1, "addr": 0x2249d3, "bit": 0},657: { "levelId": 19, "mem": bit1(0x2249d3),"good": 1, "addr": 0x2249d3, "bit": 1},658: { "levelId": 19, "mem": bit2(0x2249d3),"good": 1, "addr": 0x2249d3, "bit": 2},659: { "levelId": 19, "mem": bit3(0x2249d3),"good": 1, "addr": 0x2249d3, "bit": 3},660: { "levelId": 19, "mem": bit4(0x2249d3),"good": 1, "addr": 0x2249d3, "bit": 4},661: { "levelId": 19, "mem": bit5(0x2249d3),"good": 1, "addr": 0x2249d3, "bit": 5},662: { "levelId": 19, "mem": bit6(0x2249d3),"good": 1, "addr": 0x2249d3, "bit": 6},663: { "levelId": 19, "mem": bit7(0x2249d3),"good": 1, "addr": 0x2249d3, "bit": 7},664: { "levelId": 19, "mem": bit0(0x2249d4),"good": 1, "addr": 0x2249d4, "bit": 0},665: { "levelId": 19, "mem": bit1(0x2249d4),"good": 1, "addr": 0x2249d4, "bit": 1},666: { "levelId": 19, "mem": bit2(0x2249d4),"good": 1, "addr": 0x2249d4, "bit": 2},667: { "levelId": 19, "mem": bit3(0x2249d4),"good": 1, "addr": 0x2249d4, "bit": 3},668: { "levelId": 19, "mem": bit4(0x2249d4),"good": 1, "addr": 0x2249d4, "bit": 4},669: { "levelId": 19, "mem": bit5(0x2249d4),"good": 1, "addr": 0x2249d4, "bit": 5},670: { "levelId": 19, "mem": bit6(0x2249d4),"good": 1, "addr": 0x2249d4, "bit": 6},671: { "levelId": 19, "mem": bit7(0x2249d4),"good": 1, "addr": 0x2249d4, "bit": 7},672: { "levelId": 19, "mem": bit0(0x2249d5),"good": 1, "addr": 0x2249d5, "bit": 0},673: { "levelId": 19, "mem": bit1(0x2249d5),"good": 1, "addr": 0x2249d5, "bit": 1},674: { "levelId": 19, "mem": bit2(0x2249d5),"good": 1, "addr": 0x2249d5, "bit": 2},675: { "levelId": 19, "mem": bit3(0x2249d5),"good": 1, "addr": 0x2249d5, "bit": 3},676: { "levelId": 19, "mem": bit4(0x2249d5),"good": 1, "addr": 0x2249d5, "bit": 4},677: { "levelId": 19, "mem": bit5(0x2249d5),"good": 1, "addr": 0x2249d5, "bit": 5},678: { "levelId": 19, "mem": bit6(0x2249d5),"good": 1, "addr": 0x2249d5, "bit": 6},679: { "levelId": 19, "mem": bit7(0x2249d5),"good": 1, "addr": 0x2249d5, "bit": 7},680: { "levelId": 19, "mem": bit0(0x2249d6),"good": 1, "addr": 0x2249d6, "bit": 0},681: { "levelId": 19, "mem": bit1(0x2249d6),"good": 1, "addr": 0x2249d6, "bit": 1},682: { "levelId": 19, "mem": bit2(0x2249d6),"good": 1, "addr": 0x2249d6, "bit": 2},683: { "levelId": 19, "mem": bit3(0x2249d6),"good": 1, "addr": 0x2249d6, "bit": 3},684: { "levelId": 19, "mem": bit4(0x2249d6),"good": 1, "addr": 0x2249d6, "bit": 4},685: { "levelId": 19, "mem": bit5(0x2249d6),"good": 1, "addr": 0x2249d6, "bit": 5},686: { "levelId": 19, "mem": bit6(0x2249d6),"good": 1, "addr": 0x2249d6, "bit": 6},687: { "levelId": 19, "mem": bit7(0x2249d6),"good": 1, "addr": 0x2249d6, "bit": 7},688: { "levelId": 19, "mem": bit0(0x2249d7),"good": 1, "addr": 0x2249d7, "bit": 0},689: { "levelId": 19, "mem": bit1(0x2249d7),"good": 1, "addr": 0x2249d7, "bit": 1},690: { "levelId": 19, "mem": bit2(0x2249d7),"good": 1, "addr": 0x2249d7, "bit": 2},691: { "levelId": 19, "mem": bit3(0x2249d7),"good": 1, "addr": 0x2249d7, "bit": 3},692: { "levelId": 19, "mem": bit4(0x2249d7),"good": 1, "addr": 0x2249d7, "bit": 4},693: { "levelId": 19, "mem": bit5(0x2249d7),"good": 1, "addr": 0x2249d7, "bit": 5},694: { "levelId": 19, "mem": bit6(0x2249d7),"good": 1, "addr": 0x2249d7, "bit": 6},695: { "levelId": 19, "mem": bit7(0x2249d7),"good": 1, "addr": 0x2249d7, "bit": 7},696: { "levelId": 19, "mem": bit0(0x2249d8),"good": 1, "addr": 0x2249d8, "bit": 0},697: { "levelId": 19, "mem": bit1(0x2249d8),"good": 1, "addr": 0x2249d8, "bit": 1},698: { "levelId": 19, "mem": bit2(0x2249d8),"good": 1, "addr": 0x2249d8, "bit": 2},699: { "levelId": 19, "mem": bit3(0x2249d8),"good": 1, "addr": 0x2249d8, "bit": 3},700: { "levelId": 19, "mem": bit4(0x2249d8),"good": 1, "addr": 0x2249d8, "bit": 4},701: { "levelId": 19, "mem": bit5(0x2249d8),"good": 1, "addr": 0x2249d8, "bit": 5},702: { "levelId": 19, "mem": bit6(0x2249d8),"good": 1, "addr": 0x2249d8, "bit": 6},703: { "levelId": 19, "mem": bit7(0x2249d8),"good": 1, "addr": 0x2249d8, "bit": 7},704: { "levelId": 19, "mem": bit0(0x2249d9),"good": 1, "addr": 0x2249d9, "bit": 0},705: { "levelId": 19, "mem": bit1(0x2249d9),"good": 1, "addr": 0x2249d9, "bit": 1},706: { "levelId": 20, "mem": bit2(0x2249d9),"good": 1, "addr": 0x2249d9, "bit": 2},707: { "levelId": 20, "mem": bit3(0x2249d9),"good": 1, "addr": 0x2249d9, "bit": 3},708: { "levelId": 20, "mem": bit4(0x2249d9),"good": 1, "addr": 0x2249d9, "bit": 4},709: { "levelId": 20, "mem": bit5(0x2249d9),"good": 1, "addr": 0x2249d9, "bit": 5},710: { "levelId": 20, "mem": bit6(0x2249d9),"good": 1, "addr": 0x2249d9, "bit": 6},711: { "levelId": 20, "mem": bit7(0x2249d9),"good": 1, "addr": 0x2249d9, "bit": 7},712: { "levelId": 20, "mem": bit0(0x2249da),"good": 1, "addr": 0x2249da, "bit": 0},713: { "levelId": 20, "mem": bit1(0x2249da),"good": 1, "addr": 0x2249da, "bit": 1},714: { "levelId": 20, "mem": bit2(0x2249da),"good": 1, "addr": 0x2249da, "bit": 2},715: { "levelId": 20, "mem": bit3(0x2249da),"good": 1, "addr": 0x2249da, "bit": 3},716: { "levelId": 20, "mem": bit4(0x2249da),"good": 1, "addr": 0x2249da, "bit": 4},717: { "levelId": 20, "mem": bit5(0x2249da),"good": 1, "addr": 0x2249da, "bit": 5},718: { "levelId": 20, "mem": bit6(0x2249da),"good": 1, "addr": 0x2249da, "bit": 6},719: { "levelId": 20, "mem": bit7(0x2249da),"good": 1, "addr": 0x2249da, "bit": 7},720: { "levelId": 20, "mem": bit0(0x2249db),"good": 1, "addr": 0x2249db, "bit": 0},721: { "levelId": 20, "mem": bit1(0x2249db),"good": 1, "addr": 0x2249db, "bit": 1},722: { "levelId": 20, "mem": bit2(0x2249db),"good": 1, "addr": 0x2249db, "bit": 2},723: { "levelId": 20, "mem": bit3(0x2249db),"good": 1, "addr": 0x2249db, "bit": 3},724: { "levelId": 20, "mem": bit4(0x2249db),"good": 1, "addr": 0x2249db, "bit": 4},725: { "levelId": 20, "mem": bit5(0x2249db),"good": 1, "addr": 0x2249db, "bit": 5},726: { "levelId": 20, "mem": bit6(0x2249db),"good": 1, "addr": 0x2249db, "bit": 6},727: { "levelId": 20, "mem": bit7(0x2249db),"good": 1, "addr": 0x2249db, "bit": 7},728: { "levelId": 20, "mem": bit0(0x2249dc),"good": 1, "addr": 0x2249dc, "bit": 0},729: { "levelId": 20, "mem": bit1(0x2249dc),"good": 1, "addr": 0x2249dc, "bit": 1},730: { "levelId": 20, "mem": bit2(0x2249dc),"good": 1, "addr": 0x2249dc, "bit": 2},731: { "levelId": 20, "mem": bit3(0x2249dc),"good": 1, "addr": 0x2249dc, "bit": 3},732: { "levelId": 20, "mem": bit4(0x2249dc),"good": 1, "addr": 0x2249dc, "bit": 4},733: { "levelId": 20, "mem": bit5(0x2249dc),"good": 1, "addr": 0x2249dc, "bit": 5},734: { "levelId": 20, "mem": bit6(0x2249dc),"good": 1, "addr": 0x2249dc, "bit": 6},735: { "levelId": 20, "mem": bit7(0x2249dc),"good": 1, "addr": 0x2249dc, "bit": 7},736: { "levelId": 20, "mem": bit0(0x2249dd),"good": 1, "addr": 0x2249dd, "bit": 0},737: { "levelId": 20, "mem": bit1(0x2249dd),"good": 1, "addr": 0x2249dd, "bit": 1},738: { "levelId": 20, "mem": bit2(0x2249dd),"good": 1, "addr": 0x2249dd, "bit": 2},739: { "levelId": 20, "mem": bit3(0x2249dd),"good": 1, "addr": 0x2249dd, "bit": 3},740: { "levelId": 20, "mem": bit4(0x2249dd),"good": 1, "addr": 0x2249dd, "bit": 4},741: { "levelId": 20, "mem": bit5(0x2249dd),"good": 1, "addr": 0x2249dd, "bit": 5},742: { "levelId": 20, "mem": bit6(0x2249dd),"good": 1, "addr": 0x2249dd, "bit": 6},743: { "levelId": 20, "mem": bit7(0x2249dd),"good": 1, "addr": 0x2249dd, "bit": 7},744: { "levelId": 20, "mem": bit0(0x2249de),"good": 1, "addr": 0x2249de, "bit": 0},745: { "levelId": 20, "mem": bit1(0x2249de),"good": 1, "addr": 0x2249de, "bit": 1},746: { "levelId": 20, "mem": bit2(0x2249de),"good": 1, "addr": 0x2249de, "bit": 2},747: { "levelId": 20, "mem": bit3(0x2249de),"good": 1, "addr": 0x2249de, "bit": 3},748: { "levelId": 20, "mem": bit4(0x2249de),"good": 1, "addr": 0x2249de, "bit": 4},749: { "levelId": 20, "mem": bit5(0x2249de),"good": 1, "addr": 0x2249de, "bit": 5},750: { "levelId": 20, "mem": bit6(0x2249de),"good": 1, "addr": 0x2249de, "bit": 6},751: { "levelId": 20, "mem": bit7(0x2249de),"good": 1, "addr": 0x2249de, "bit": 7},752: { "levelId": 20, "mem": bit0(0x2249df),"good": 1, "addr": 0x2249df, "bit": 0},753: { "levelId": 20, "mem": bit1(0x2249df),"good": 1, "addr": 0x2249df, "bit": 1},754: { "levelId": 20, "mem": bit2(0x2249df),"good": 1, "addr": 0x2249df, "bit": 2},755: { "levelId": 20, "mem": bit3(0x2249df),"good": 1, "addr": 0x2249df, "bit": 3},756: { "levelId": 21, "mem": bit4(0x2249df),"good": 1, "addr": 0x2249df, "bit": 4},757: { "levelId": 21, "mem": bit5(0x2249df),"good": 1, "addr": 0x2249df, "bit": 5},758: { "levelId": 21, "mem": bit6(0x2249df),"good": 1, "addr": 0x2249df, "bit": 6},759: { "levelId": 21, "mem": bit7(0x2249df),"good": 1, "addr": 0x2249df, "bit": 7},760: { "levelId": 21, "mem": bit0(0x2249e0),"good": 1, "addr": 0x2249e0, "bit": 0},761: { "levelId": 21, "mem": bit1(0x2249e0),"good": 1, "addr": 0x2249e0, "bit": 1},762: { "levelId": 21, "mem": bit2(0x2249e0),"good": 1, "addr": 0x2249e0, "bit": 2},763: { "levelId": 21, "mem": bit3(0x2249e0),"good": 1, "addr": 0x2249e0, "bit": 3},764: { "levelId": 21, "mem": bit4(0x2249e0),"good": 1, "addr": 0x2249e0, "bit": 4},765: { "levelId": 21, "mem": bit5(0x2249e0),"good": 1, "addr": 0x2249e0, "bit": 5},766: { "levelId": 21, "mem": bit6(0x2249e0),"good": 1, "addr": 0x2249e0, "bit": 6},767: { "levelId": 21, "mem": bit7(0x2249e0),"good": 1, "addr": 0x2249e0, "bit": 7},768: { "levelId": 21, "mem": bit0(0x2249e1),"good": 1, "addr": 0x2249e1, "bit": 0},769: { "levelId": 21, "mem": bit1(0x2249e1),"good": 1, "addr": 0x2249e1, "bit": 1},770: { "levelId": 21, "mem": bit2(0x2249e1),"good": 1, "addr": 0x2249e1, "bit": 2},771: { "levelId": 21, "mem": bit3(0x2249e1),"good": 1, "addr": 0x2249e1, "bit": 3},772: { "levelId": 21, "mem": bit4(0x2249e1),"good": 1, "addr": 0x2249e1, "bit": 4},773: { "levelId": 21, "mem": bit5(0x2249e1),"good": 1, "addr": 0x2249e1, "bit": 5},774: { "levelId": 21, "mem": bit6(0x2249e1),"good": 1, "addr": 0x2249e1, "bit": 6},775: { "levelId": 21, "mem": bit7(0x2249e1),"good": 1, "addr": 0x2249e1, "bit": 7},776: { "levelId": 21, "mem": bit0(0x2249e2),"good": 1, "addr": 0x2249e2, "bit": 0},777: { "levelId": 21, "mem": bit1(0x2249e2),"good": 1, "addr": 0x2249e2, "bit": 1},778: { "levelId": 21, "mem": bit2(0x2249e2),"good": 1, "addr": 0x2249e2, "bit": 2},779: { "levelId": 21, "mem": bit3(0x2249e2),"good": 1, "addr": 0x2249e2, "bit": 3},780: { "levelId": 21, "mem": bit4(0x2249e2),"good": 1, "addr": 0x2249e2, "bit": 4},781: { "levelId": 21, "mem": bit5(0x2249e2),"good": 1, "addr": 0x2249e2, "bit": 5},782: { "levelId": 21, "mem": bit6(0x2249e2),"good": 1, "addr": 0x2249e2, "bit": 6},783: { "levelId": 21, "mem": bit7(0x2249e2),"good": 1, "addr": 0x2249e2, "bit": 7},784: { "levelId": 21, "mem": bit0(0x2249e3),"good": 1, "addr": 0x2249e3, "bit": 0},785: { "levelId": 21, "mem": bit1(0x2249e3),"good": 1, "addr": 0x2249e3, "bit": 1},786: { "levelId": 21, "mem": bit2(0x2249e3),"good": 1, "addr": 0x2249e3, "bit": 2},787: { "levelId": 21, "mem": bit3(0x2249e3),"good": 1, "addr": 0x2249e3, "bit": 3},788: { "levelId": 21, "mem": bit4(0x2249e3),"good": 1, "addr": 0x2249e3, "bit": 4},789: { "levelId": 21, "mem": bit5(0x2249e3),"good": 1, "addr": 0x2249e3, "bit": 5},790: { "levelId": 21, "mem": bit6(0x2249e3),"good": 1, "addr": 0x2249e3, "bit": 6},791: { "levelId": 21, "mem": bit7(0x2249e3),"good": 1, "addr": 0x2249e3, "bit": 7},792: { "levelId": 21, "mem": bit0(0x2249e4),"good": 1, "addr": 0x2249e4, "bit": 0},793: { "levelId": 21, "mem": bit1(0x2249e4),"good": 1, "addr": 0x2249e4, "bit": 1},794: { "levelId": 21, "mem": bit2(0x2249e4),"good": 1, "addr": 0x2249e4, "bit": 2},795: { "levelId": 21, "mem": bit3(0x2249e4),"good": 1, "addr": 0x2249e4, "bit": 3},796: { "levelId": 21, "mem": bit4(0x2249e4),"good": 1, "addr": 0x2249e4, "bit": 4},797: { "levelId": 21, "mem": bit5(0x2249e4),"good": 1, "addr": 0x2249e4, "bit": 5},798: { "levelId": 21, "mem": bit6(0x2249e4),"good": 1, "addr": 0x2249e4, "bit": 6},799: { "levelId": 21, "mem": bit7(0x2249e4),"good": 1, "addr": 0x2249e4, "bit": 7},800: { "levelId": 21, "mem": bit0(0x2249e5),"good": 1, "addr": 0x2249e5, "bit": 0},801: { "levelId": 21, "mem": bit1(0x2249e5),"good": 1, "addr": 0x2249e5, "bit": 1},802: { "levelId": 21, "mem": bit2(0x2249e5),"good": 1, "addr": 0x2249e5, "bit": 2},803: { "levelId": 21, "mem": bit3(0x2249e5),"good": 1, "addr": 0x2249e5, "bit": 3},804: { "levelId": 21, "mem": bit4(0x2249e5),"good": 1, "addr": 0x2249e5, "bit": 4},805: { "levelId": 21, "mem": bit5(0x2249e5),"good": 1, "addr": 0x2249e5, "bit": 5},806: { "levelId": 22, "mem": bit4(0x224a2a),"good": 1, "addr": 0x224a2a, "bit": 4},807: { "levelId": 22, "mem": bit5(0x224a2a),"good": 1, "addr": 0x224a2a, "bit": 5},808: { "levelId": 22, "mem": bit6(0x224a2a),"good": 1, "addr": 0x224a2a, "bit": 6},809: { "levelId": 22, "mem": bit7(0x224a2a),"good": 1, "addr": 0x224a2a, "bit": 7},810: { "levelId": 22, "mem": bit0(0x224a2b),"good": 1, "addr": 0x224a2b, "bit": 0},811: { "levelId": 22, "mem": bit1(0x224a2b),"good": 1, "addr": 0x224a2b, "bit": 1},812: { "levelId": 22, "mem": bit2(0x224a2b),"good": 1, "addr": 0x224a2b, "bit": 2},813: { "levelId": 22, "mem": bit3(0x224a2b),"good": 1, "addr": 0x224a2b, "bit": 3},814: { "levelId": 22, "mem": bit4(0x224a2b),"good": 1, "addr": 0x224a2b, "bit": 4},815: { "levelId": 22, "mem": bit5(0x224a2b),"good": 1, "addr": 0x224a2b, "bit": 5},816: { "levelId": 22, "mem": bit6(0x224a2b),"good": 1, "addr": 0x224a2b, "bit": 6},817: { "levelId": 22, "mem": bit7(0x224a2b),"good": 1, "addr": 0x224a2b, "bit": 7},818: { "levelId": 22, "mem": bit0(0x224a2c),"good": 1, "addr": 0x224a2c, "bit": 0},819: { "levelId": 22, "mem": bit1(0x224a2c),"good": 1, "addr": 0x224a2c, "bit": 1},820: { "levelId": 22, "mem": bit2(0x224a2c),"good": 1, "addr": 0x224a2c, "bit": 2},821: { "levelId": 22, "mem": bit3(0x224a2c),"good": 1, "addr": 0x224a2c, "bit": 3},822: { "levelId": 22, "mem": bit4(0x224a2c),"good": 1, "addr": 0x224a2c, "bit": 4},823: { "levelId": 22, "mem": bit5(0x224a2c),"good": 1, "addr": 0x224a2c, "bit": 5},824: { "levelId": 22, "mem": bit6(0x224a2c),"good": 1, "addr": 0x224a2c, "bit": 6},825: { "levelId": 22, "mem": bit7(0x224a2c),"good": 1, "addr": 0x224a2c, "bit": 7},826: { "levelId": 22, "mem": bit0(0x224a2d),"good": 1, "addr": 0x224a2d, "bit": 0},827: { "levelId": 22, "mem": bit1(0x224a2d),"good": 1, "addr": 0x224a2d, "bit": 1},828: { "levelId": 22, "mem": bit2(0x224a2d),"good": 1, "addr": 0x224a2d, "bit": 2},829: { "levelId": 22, "mem": bit3(0x224a2d),"good": 1, "addr": 0x224a2d, "bit": 3},830: { "levelId": 22, "mem": bit4(0x224a2d),"good": 1, "addr": 0x224a2d, "bit": 4},831: { "levelId": 22, "mem": bit5(0x224a2d),"good": 1, "addr": 0x224a2d, "bit": 5},832: { "levelId": 22, "mem": bit6(0x224a2d),"good": 1, "addr": 0x224a2d, "bit": 6},833: { "levelId": 22, "mem": bit7(0x224a2d),"good": 1, "addr": 0x224a2d, "bit": 7},834: { "levelId": 22, "mem": bit0(0x224a2e),"good": 1, "addr": 0x224a2e, "bit": 0},835: { "levelId": 22, "mem": bit1(0x224a2e),"good": 1, "addr": 0x224a2e, "bit": 1},836: { "levelId": 22, "mem": bit2(0x224a2e),"good": 1, "addr": 0x224a2e, "bit": 2},837: { "levelId": 22, "mem": bit3(0x224a2e),"good": 1, "addr": 0x224a2e, "bit": 3},838: { "levelId": 22, "mem": bit4(0x224a2e),"good": 1, "addr": 0x224a2e, "bit": 4},839: { "levelId": 22, "mem": bit5(0x224a2e),"good": 1, "addr": 0x224a2e, "bit": 5},840: { "levelId": 22, "mem": bit6(0x224a2e),"good": 1, "addr": 0x224a2e, "bit": 6},841: { "levelId": 22, "mem": bit7(0x224a2e),"good": 1, "addr": 0x224a2e, "bit": 7},842: { "levelId": 22, "mem": bit0(0x224a2f),"good": 1, "addr": 0x224a2f, "bit": 0},843: { "levelId": 22, "mem": bit1(0x224a2f),"good": 1, "addr": 0x224a2f, "bit": 1},844: { "levelId": 22, "mem": bit2(0x224a2f),"good": 1, "addr": 0x224a2f, "bit": 2},845: { "levelId": 22, "mem": bit3(0x224a2f),"good": 1, "addr": 0x224a2f, "bit": 3},846: { "levelId": 22, "mem": bit4(0x224a2f),"good": 1, "addr": 0x224a2f, "bit": 4},847: { "levelId": 22, "mem": bit5(0x224a2f),"good": 1, "addr": 0x224a2f, "bit": 5},848: { "levelId": 22, "mem": bit6(0x224a2f),"good": 1, "addr": 0x224a2f, "bit": 6},849: { "levelId": 22, "mem": bit7(0x224a2f),"good": 1, "addr": 0x224a2f, "bit": 7},850: { "levelId": 22, "mem": bit0(0x224a30),"good": 1, "addr": 0x224a30, "bit": 0},851: { "levelId": 22, "mem": bit1(0x224a30),"good": 1, "addr": 0x224a30, "bit": 1},852: { "levelId": 22, "mem": bit2(0x224a30),"good": 1, "addr": 0x224a30, "bit": 2},853: { "levelId": 22, "mem": bit3(0x224a30),"good": 1, "addr": 0x224a30, "bit": 3},854: { "levelId": 22, "mem": bit4(0x224a30),"good": 1, "addr": 0x224a30, "bit": 4},855: { "levelId": 22, "mem": bit5(0x224a30),"good": 1, "addr": 0x224a30, "bit": 5},856: { "levelId": 22, "mem": bit6(0x224a30),"good": 1, "addr": 0x224a30, "bit": 6},857: { "levelId": 22, "mem": bit7(0x224a30),"good": 1, "addr": 0x224a30, "bit": 7},858: { "levelId": 22, "mem": bit0(0x224a31),"good": 1, "addr": 0x224a31, "bit": 0},859: { "levelId": 22, "mem": bit1(0x224a31),"good": 1, "addr": 0x224a31, "bit": 1},860: { "levelId": 22, "mem": bit2(0x224a31),"good": 1, "addr": 0x224a31, "bit": 2},861: { "levelId": 22, "mem": bit3(0x224a31),"good": 1, "addr": 0x224a31, "bit": 3},862: { "levelId": 22, "mem": bit4(0x224a31),"good": 1, "addr": 0x224a31, "bit": 4},863: { "levelId": 22, "mem": bit5(0x224a31),"good": 1, "addr": 0x224a31, "bit": 5},864: { "levelId": 22, "mem": bit6(0x224a31),"good": 1, "addr": 0x224a31, "bit": 6},865: { "levelId": 22, "mem": bit7(0x224a31),"good": 1, "addr": 0x224a31, "bit": 7},866: { "levelId": 22, "mem": bit0(0x224a32),"good": 1, "addr": 0x224a32, "bit": 0},867: { "levelId": 22, "mem": bit1(0x224a32),"good": 1, "addr": 0x224a32, "bit": 1},868: { "levelId": 22, "mem": bit2(0x224a32),"good": 1, "addr": 0x224a32, "bit": 2},869: { "levelId": 22, "mem": bit3(0x224a32),"good": 1, "addr": 0x224a32, "bit": 3},870: { "levelId": 22, "mem": bit4(0x224a32),"good": 1, "addr": 0x224a32, "bit": 4},871: { "levelId": 22, "mem": bit5(0x224a32),"good": 1, "addr": 0x224a32, "bit": 5},872: { "levelId": 22, "mem": bit6(0x224a32),"good": 1, "addr": 0x224a32, "bit": 6},873: { "levelId": 22, "mem": bit7(0x224a32),"good": 1, "addr": 0x224a32, "bit": 7},874: { "levelId": 22, "mem": bit0(0x224a33),"good": 1, "addr": 0x224a33, "bit": 0},875: { "levelId": 22, "mem": bit1(0x224a33),"good": 1, "addr": 0x224a33, "bit": 1},876: { "levelId": 22, "mem": bit2(0x224a33),"good": 1, "addr": 0x224a33, "bit": 2},877: { "levelId": 22, "mem": bit3(0x224a33),"good": 1, "addr": 0x224a33, "bit": 3},878: { "levelId": 22, "mem": bit4(0x224a33),"good": 1, "addr": 0x224a33, "bit": 4},879: { "levelId": 22, "mem": bit5(0x224a33),"good": 1, "addr": 0x224a33, "bit": 5},880: { "levelId": 22, "mem": bit6(0x224a33),"good": 1, "addr": 0x224a33, "bit": 6},881: { "levelId": 22, "mem": bit7(0x224a33),"good": 1, "addr": 0x224a33, "bit": 7},882: { "levelId": 22, "mem": bit0(0x224a34),"good": 1, "addr": 0x224a34, "bit": 0},883: { "levelId": 22, "mem": bit1(0x224a34),"good": 1, "addr": 0x224a34, "bit": 1},884: { "levelId": 22, "mem": bit2(0x224a34),"good": 1, "addr": 0x224a34, "bit": 2},885: { "levelId": 22, "mem": bit3(0x224a34),"good": 1, "addr": 0x224a34, "bit": 3},886: { "levelId": 22, "mem": bit4(0x224a34),"good": 1, "addr": 0x224a34, "bit": 4},887: { "levelId": 22, "mem": bit5(0x224a34),"good": 1, "addr": 0x224a34, "bit": 5},888: { "levelId": 22, "mem": bit6(0x224a34),"good": 1, "addr": 0x224a34, "bit": 6},889: { "levelId": 22, "mem": bit7(0x224a34),"good": 1, "addr": 0x224a34, "bit": 7},890: { "levelId": 22, "mem": bit0(0x224a35),"good": 1, "addr": 0x224a35, "bit": 0},891: { "levelId": 22, "mem": bit1(0x224a35),"good": 1, "addr": 0x224a35, "bit": 1},892: { "levelId": 22, "mem": bit2(0x224a35),"good": 1, "addr": 0x224a35, "bit": 2},893: { "levelId": 22, "mem": bit3(0x224a35),"good": 1, "addr": 0x224a35, "bit": 3},894: { "levelId": 22, "mem": bit4(0x224a35),"good": 1, "addr": 0x224a35, "bit": 4},895: { "levelId": 22, "mem": bit5(0x224a35),"good": 1, "addr": 0x224a35, "bit": 5},896: { "levelId": 22, "mem": bit6(0x224a35),"good": 1, "addr": 0x224a35, "bit": 6},897: { "levelId": 22, "mem": bit7(0x224a35),"good": 1, "addr": 0x224a35, "bit": 7},898: { "levelId": 22, "mem": bit0(0x224a36),"good": 1, "addr": 0x224a36, "bit": 0},899: { "levelId": 22, "mem": bit1(0x224a36),"good": 1, "addr": 0x224a36, "bit": 1},900: { "levelId": 24, "mem": bit0(0x224a1e),"good": 1, "addr": 0x224a1e, "bit": 0},901: { "levelId": 24, "mem": bit1(0x224a1e),"good": 1, "addr": 0x224a1e, "bit": 1},902: { "levelId": 24, "mem": bit2(0x224a1e),"good": 1, "addr": 0x224a1e, "bit": 2},903: { "levelId": 24, "mem": bit3(0x224a1e),"good": 1, "addr": 0x224a1e, "bit": 3},904: { "levelId": 24, "mem": bit4(0x224a1e),"good": 1, "addr": 0x224a1e, "bit": 4},905: { "levelId": 24, "mem": bit5(0x224a1e),"good": 1, "addr": 0x224a1e, "bit": 5},906: { "levelId": 24, "mem": bit6(0x224a1e),"good": 1, "addr": 0x224a1e, "bit": 6},907: { "levelId": 24, "mem": bit7(0x224a1e),"good": 1, "addr": 0x224a1e, "bit": 7},908: { "levelId": 24, "mem": bit0(0x224a1f),"good": 1, "addr": 0x224a1f, "bit": 0},909: { "levelId": 24, "mem": bit1(0x224a1f),"good": 1, "addr": 0x224a1f, "bit": 1},910: { "levelId": 24, "mem": bit2(0x224a1f),"good": 1, "addr": 0x224a1f, "bit": 2},911: { "levelId": 24, "mem": bit3(0x224a1f),"good": 1, "addr": 0x224a1f, "bit": 3},912: { "levelId": 24, "mem": bit4(0x224a1f),"good": 1, "addr": 0x224a1f, "bit": 4},913: { "levelId": 24, "mem": bit5(0x224a1f),"good": 1, "addr": 0x224a1f, "bit": 5},914: { "levelId": 24, "mem": bit6(0x224a1f),"good": 1, "addr": 0x224a1f, "bit": 6},915: { "levelId": 24, "mem": bit7(0x224a1f),"good": 1, "addr": 0x224a1f, "bit": 7},916: { "levelId": 24, "mem": bit0(0x224a20),"good": 1, "addr": 0x224a20, "bit": 0},917: { "levelId": 24, "mem": bit1(0x224a20),"good": 1, "addr": 0x224a20, "bit": 1},918: { "levelId": 24, "mem": bit2(0x224a20),"good": 1, "addr": 0x224a20, "bit": 2},919: { "levelId": 24, "mem": bit3(0x224a20),"good": 1, "addr": 0x224a20, "bit": 3},920: { "levelId": 24, "mem": bit4(0x224a20),"good": 1, "addr": 0x224a20, "bit": 4},921: { "levelId": 24, "mem": bit5(0x224a20),"good": 1, "addr": 0x224a20, "bit": 5},922: { "levelId": 24, "mem": bit6(0x224a20),"good": 1, "addr": 0x224a20, "bit": 6},923: { "levelId": 24, "mem": bit7(0x224a20),"good": 1, "addr": 0x224a20, "bit": 7},924: { "levelId": 24, "mem": bit0(0x224a21),"good": 1, "addr": 0x224a21, "bit": 0},925: { "levelId": 24, "mem": bit1(0x224a21),"good": 1, "addr": 0x224a21, "bit": 1},926: { "levelId": 24, "mem": bit2(0x224a21),"good": 1, "addr": 0x224a21, "bit": 2},927: { "levelId": 24, "mem": bit3(0x224a21),"good": 1, "addr": 0x224a21, "bit": 3},928: { "levelId": 24, "mem": bit4(0x224a21),"good": 1, "addr": 0x224a21, "bit": 4},929: { "levelId": 24, "mem": bit5(0x224a21),"good": 1, "addr": 0x224a21, "bit": 5},930: { "levelId": 24, "mem": bit6(0x224a21),"good": 1, "addr": 0x224a21, "bit": 6},931: { "levelId": 24, "mem": bit7(0x224a21),"good": 1, "addr": 0x224a21, "bit": 7},932: { "levelId": 24, "mem": bit0(0x224a22),"good": 1, "addr": 0x224a22, "bit": 0},933: { "levelId": 24, "mem": bit1(0x224a22),"good": 1, "addr": 0x224a22, "bit": 1},934: { "levelId": 24, "mem": bit2(0x224a22),"good": 1, "addr": 0x224a22, "bit": 2},935: { "levelId": 24, "mem": bit3(0x224a22),"good": 1, "addr": 0x224a22, "bit": 3},936: { "levelId": 24, "mem": bit4(0x224a22),"good": 1, "addr": 0x224a22, "bit": 4},937: { "levelId": 24, "mem": bit5(0x224a22),"good": 1, "addr": 0x224a22, "bit": 5},938: { "levelId": 24, "mem": bit6(0x224a22),"good": 1, "addr": 0x224a22, "bit": 6},939: { "levelId": 24, "mem": bit7(0x224a22),"good": 1, "addr": 0x224a22, "bit": 7},940: { "levelId": 24, "mem": bit0(0x224a23),"good": 1, "addr": 0x224a23, "bit": 0},941: { "levelId": 24, "mem": bit1(0x224a23),"good": 1, "addr": 0x224a23, "bit": 1},942: { "levelId": 24, "mem": bit2(0x224a23),"good": 1, "addr": 0x224a23, "bit": 2},943: { "levelId": 24, "mem": bit3(0x224a23),"good": 1, "addr": 0x224a23, "bit": 3},944: { "levelId": 24, "mem": bit4(0x224a23),"good": 1, "addr": 0x224a23, "bit": 4},945: { "levelId": 24, "mem": bit5(0x224a23),"good": 1, "addr": 0x224a23, "bit": 5},946: { "levelId": 24, "mem": bit6(0x224a23),"good": 1, "addr": 0x224a23, "bit": 6},947: { "levelId": 24, "mem": bit7(0x224a23),"good": 1, "addr": 0x224a23, "bit": 7},948: { "levelId": 24, "mem": bit0(0x224a24),"good": 1, "addr": 0x224a24, "bit": 0},949: { "levelId": 24, "mem": bit1(0x224a24),"good": 1, "addr": 0x224a24, "bit": 1},950: { "levelId": 25, "mem": bit2(0x224a24),"good": 1, "addr": 0x224a24, "bit": 2},951: { "levelId": 25, "mem": bit3(0x224a24),"good": 1, "addr": 0x224a24, "bit": 3},952: { "levelId": 25, "mem": bit4(0x224a24),"good": 1, "addr": 0x224a24, "bit": 4},953: { "levelId": 25, "mem": bit5(0x224a24),"good": 1, "addr": 0x224a24, "bit": 5},954: { "levelId": 25, "mem": bit6(0x224a24),"good": 1, "addr": 0x224a24, "bit": 6},955: { "levelId": 25, "mem": bit7(0x224a24),"good": 1, "addr": 0x224a24, "bit": 7},956: { "levelId": 25, "mem": bit0(0x224a25),"good": 1, "addr": 0x224a25, "bit": 0},957: { "levelId": 25, "mem": bit1(0x224a25),"good": 1, "addr": 0x224a25, "bit": 1},958: { "levelId": 25, "mem": bit2(0x224a25),"good": 1, "addr": 0x224a25, "bit": 2},959: { "levelId": 25, "mem": bit3(0x224a25),"good": 1, "addr": 0x224a25, "bit": 3},960: { "levelId": 25, "mem": bit4(0x224a25),"good": 1, "addr": 0x224a25, "bit": 4},961: { "levelId": 25, "mem": bit5(0x224a25),"good": 1, "addr": 0x224a25, "bit": 5},962: { "levelId": 25, "mem": bit6(0x224a25),"good": 1, "addr": 0x224a25, "bit": 6},963: { "levelId": 25, "mem": bit7(0x224a25),"good": 1, "addr": 0x224a25, "bit": 7},964: { "levelId": 25, "mem": bit0(0x224a26),"good": 1, "addr": 0x224a26, "bit": 0},965: { "levelId": 25, "mem": bit1(0x224a26),"good": 1, "addr": 0x224a26, "bit": 1},966: { "levelId": 25, "mem": bit2(0x224a26),"good": 1, "addr": 0x224a26, "bit": 2},967: { "levelId": 25, "mem": bit3(0x224a26),"good": 1, "addr": 0x224a26, "bit": 3},968: { "levelId": 25, "mem": bit4(0x224a26),"good": 1, "addr": 0x224a26, "bit": 4},969: { "levelId": 25, "mem": bit5(0x224a26),"good": 1, "addr": 0x224a26, "bit": 5},970: { "levelId": 25, "mem": bit6(0x224a26),"good": 1, "addr": 0x224a26, "bit": 6},971: { "levelId": 25, "mem": bit7(0x224a26),"good": 1, "addr": 0x224a26, "bit": 7},972: { "levelId": 25, "mem": bit0(0x224a27),"good": 1, "addr": 0x224a27, "bit": 0},973: { "levelId": 25, "mem": bit1(0x224a27),"good": 1, "addr": 0x224a27, "bit": 1},974: { "levelId": 25, "mem": bit2(0x224a27),"good": 1, "addr": 0x224a27, "bit": 2},975: { "levelId": 25, "mem": bit3(0x224a27),"good": 1, "addr": 0x224a27, "bit": 3},976: { "levelId": 25, "mem": bit4(0x224a27),"good": 1, "addr": 0x224a27, "bit": 4},977: { "levelId": 25, "mem": bit5(0x224a27),"good": 1, "addr": 0x224a27, "bit": 5},978: { "levelId": 25, "mem": bit6(0x224a27),"good": 1, "addr": 0x224a27, "bit": 6},979: { "levelId": 25, "mem": bit7(0x224a27),"good": 1, "addr": 0x224a27, "bit": 7},980: { "levelId": 25, "mem": bit0(0x224a28),"good": 1, "addr": 0x224a28, "bit": 0},981: { "levelId": 25, "mem": bit1(0x224a28),"good": 1, "addr": 0x224a28, "bit": 1},982: { "levelId": 25, "mem": bit2(0x224a28),"good": 1, "addr": 0x224a28, "bit": 2},983: { "levelId": 25, "mem": bit3(0x224a28),"good": 1, "addr": 0x224a28, "bit": 3},984: { "levelId": 25, "mem": bit4(0x224a28),"good": 1, "addr": 0x224a28, "bit": 4},985: { "levelId": 25, "mem": bit5(0x224a28),"good": 1, "addr": 0x224a28, "bit": 5},986: { "levelId": 25, "mem": bit6(0x224a28),"good": 1, "addr": 0x224a28, "bit": 6},987: { "levelId": 25, "mem": bit7(0x224a28),"good": 1, "addr": 0x224a28, "bit": 7},988: { "levelId": 25, "mem": bit0(0x224a29),"good": 1, "addr": 0x224a29, "bit": 0},989: { "levelId": 25, "mem": bit1(0x224a29),"good": 1, "addr": 0x224a29, "bit": 1},990: { "levelId": 25, "mem": bit2(0x224a29),"good": 1, "addr": 0x224a29, "bit": 2},991: { "levelId": 25, "mem": bit3(0x224a29),"good": 1, "addr": 0x224a29, "bit": 3},992: { "levelId": 25, "mem": bit4(0x224a29),"good": 1, "addr": 0x224a29, "bit": 4},993: { "levelId": 25, "mem": bit5(0x224a29),"good": 1, "addr": 0x224a29, "bit": 5},994: { "levelId": 25, "mem": bit6(0x224a29),"good": 1, "addr": 0x224a29, "bit": 6},995: { "levelId": 25, "mem": bit7(0x224a29),"good": 1, "addr": 0x224a29, "bit": 7},996: { "levelId": 25, "mem": bit0(0x224a2a),"good": 1, "addr": 0x224a2a, "bit": 0},997: { "levelId": 25, "mem": bit1(0x224a2a),"good": 1, "addr": 0x224a2a, "bit": 1},998: { "levelId": 25, "mem": bit2(0x224a2a),"good": 1, "addr": 0x224a2a, "bit": 2},999: { "levelId": 25, "mem": bit3(0x224a2a),"good": 1, "addr": 0x224a2a, "bit": 3},1000: { "levelId": 3, "mem": bit5(0x224a06),"good": 1, "addr": 0x224a06, "bit": 5},
}

lumsFound = 0

for i in lums
{
    lum = lums[i]
    
    if (lum["good"] == 1)
    {
        lumsFound = lumsFound + lum["mem"]
    }
}

cages = {
    1: { "levelId": 1, "mem": bit7(0x2249f0),"good": 1},2: { "levelId": 2, "mem": bit0(0x2249f1),"good": 1},3: { "levelId": 2, "mem": bit1(0x2249f1),"good": 1},4: { "levelId": 2, "mem": bit5(0x2249f1),"good": 1},5: { "levelId": 2, "mem": bit6(0x2249f1),"good": 1},6: { "levelId": 1, "mem": bit7(0x2249f1),"good": 1},7: { "levelId": 5, "mem": bit0(0x2249f2),"good": 1},8: { "levelId": 5, "mem": bit1(0x2249f2),"good": 1},9: { "levelId": 5, "mem": bit2(0x2249f2),"good": 1},10: { "levelId": 5, "mem": bit3(0x2249f2),"good": 1},11: { "levelId": 5, "mem": bit4(0x2249f2),"good": 1},12: { "levelId": 6, "mem": bit5(0x2249f2),"good": 1},13: { "levelId": 6, "mem": bit7(0x2249f2),"good": 1},14: { "levelId": 6, "mem": bit1(0x2249f3),"good": 1},15: { "levelId": 6, "mem": bit6(0x2249f2),"good": 1},16: { "levelId": 6, "mem": bit0(0x2249f3),"good": 1},17: { "levelId": 6, "mem": bit3(0x2249f3),"good": 1},18: { "levelId": 6, "mem": bit2(0x2249f3),"good": 1},19: { "levelId": 8, "mem": bit5(0x2249f3),"good": 1},20: { "levelId": 8, "mem": bit4(0x2249f3),"good": 1},21: { "levelId": 10, "mem": bit0(0x2249f4),"good": 1},22: { "levelId": 10, "mem": bit6(0x2249f3),"good": 1},23: { "levelId": 10, "mem": bit3(0x2249f4),"good": 1},24: { "levelId": 10, "mem": bit5(0x2249f4),"good": 1},25: { "levelId": 10, "mem": bit7(0x2249f3),"good": 1},26: { "levelId": 10, "mem": bit1(0x2249f4),"good": 1},27: { "levelId": 10, "mem": bit2(0x2249f4),"good": 1},28: { "levelId": 10, "mem": bit4(0x2249f4),"good": 1},29: { "levelId": 12, "mem": bit6(0x2249f4),"good": 1},30: { "levelId": 12, "mem": bit7(0x2249f4),"good": 1},31: { "levelId": 12, "mem": bit1(0x2249f5),"good": 1},32: { "levelId": 12, "mem": bit0(0x2249f5),"good": 1},33: { "levelId": 13, "mem": bit2(0x2249f5),"good": 1},34: { "levelId": 13, "mem": bit3(0x2249f5),"good": 1},35: { "levelId": 13, "mem": bit4(0x2249f5),"good": 1},36: { "levelId": 13, "mem": bit5(0x2249f5),"good": 1},37: { "levelId": 14, "mem": bit6(0x2249f5),"good": 1},38: { "levelId": 14, "mem": bit7(0x2249f5),"good": 1},39: { "levelId": 14, "mem": bit0(0x2249f6),"good": 1},40: { "levelId": 14, "mem": bit1(0x2249f6),"good": 1},41: { "levelId": 14, "mem": bit2(0x2249f6),"good": 1},42: { "levelId": 14, "mem": bit3(0x2249f6),"good": 1},43: { "levelId": 14, "mem": bit4(0x2249f6),"good": 1},44: { "levelId": 14, "mem": bit5(0x2249f6),"good": 1},45: { "levelId": 15, "mem": bit6(0x2249f6),"good": 1},46: { "levelId": 15, "mem": bit7(0x2249f6),"good": 1},47: { "levelId": 15, "mem": bit0(0x2249f7),"good": 1},48: { "levelId": 15, "mem": bit1(0x2249f7),"good": 1},49: { "levelId": 15, "mem": bit2(0x2249f7),"good": 1},50: { "levelId": 2, "mem": bit3(0x2249f1),"good": 1},51: { "levelId": 2, "mem": bit2(0x2249f1),"good": 1},52: { "levelId": 2, "mem": bit4(0x2249f1),"good": 1},53: { "levelId": 16, "mem": bit3(0x2249f7),"good": 1},54: { "levelId": 16, "mem": bit4(0x2249f7),"good": 1},55: { "levelId": 16, "mem": bit5(0x2249f7),"good": 1},56: { "levelId": 16, "mem": bit6(0x2249f7),"good": 1},57: { "levelId": 16, "mem": bit7(0x2249f7),"good": 1},58: { "levelId": 16, "mem": bit0(0x2249f8),"good": 1},59: { "levelId": 17, "mem": bit1(0x2249f8),"good": 1},60: { "levelId": 17, "mem": bit2(0x2249f8),"good": 1},61: { "levelId": 18, "mem": bit3(0x2249f8),"good": 1},62: { "levelId": 18, "mem": bit4(0x2249f8),"good": 1},63: { "levelId": 18, "mem": bit5(0x2249f8),"good": 1},64: { "levelId": 18, "mem": bit6(0x2249f8),"good": 1},65: { "levelId": 18, "mem": bit7(0x2249f8),"good": 1},66: { "levelId": 18, "mem": bit0(0x2249f9),"good": 1},67: { "levelId": 18, "mem": bit1(0x2249f9),"good": 1},68: { "levelId": 19, "mem": bit2(0x2249f9),"good": 1},69: { "levelId": 19, "mem": bit3(0x2249f9),"good": 1},70: { "levelId": 19, "mem": bit4(0x2249f9),"good": 1},71: { "levelId": 19, "mem": bit5(0x2249f9),"good": 1},72: { "levelId": 20, "mem": bit6(0x2249f9),"good": 1},73: { "levelId": 20, "mem": bit7(0x2249f9),"good": 1},74: { "levelId": 20, "mem": bit0(0x2249fa),"good": 1},75: { "levelId": 20, "mem": bit1(0x2249fa),"good": 1},76: { "levelId": 20, "mem": bit2(0x2249fa),"good": 1},77: { "levelId": 20, "mem": bit3(0x2249fa),"good": 1},78: { "levelId": 21, "mem": bit4(0x2249fa),"good": 1},79: { "levelId": 21, "mem": bit5(0x2249fa),"good": 1},80: { "levelId": 21, "mem": bit6(0x2249fa),"good": 1},
}

function GetConditionsByLevel(levelName)
{
    level = GetLevelByName(levelName)
    conditions = {}
    j = 0
    for i in cages
    {
        cage = cages[i]
        
        if (cage["levelId"] == level["id"] && cage["good"] == 1)
        {
            conditions[j] = GenerateConditionFromBitflag(cage["mem"])
        }
        
        j = j + 1
    }
    
    for i in lums
    {
        lum = lums[i]
        
        if (lum["levelId"] == level["id"] && lum["good"] == 1)
        {
            conditions[j] = GenerateConditionFromBitflag(lum["mem"])
        }
        
        j = j + 1
    }
    
    return conditions
}

function GetCollectableTotalsByLevel(levelName)
{
    level = GetLevelByName(levelName)
    return level["lums"] + level["cages"]
}

areas = {
0x784BFC: { "id": 0x784BFC, "areaName": "Menu", "displayName": "Main Menu", "levelName": "Menu" },0x789668: { "id": 0x789668, "areaName": "Intro", "displayName": "somewhere in the Glade of Dreams…", "levelName": "None" },0x778C74: { "id": 0x778C74, "areaName": "BuccaneerBrig", "displayName": "in the Buccaneer’s brig", "levelName": "None" },0x78D424: { "id": 0x78D424, "areaName": "WoodsOfLight", "displayName": "in the Woods of Light", "levelName": "Woods of Light" },0x790570: { "id": 0x790570, "areaName": "HallOfDoors", "displayName": "in the Hall of Doors", "levelName": "Hall of Doors" },0x7875A8: { "id": 0x7875A8, "areaName": "FairyGladeArea1", "displayName": "in the Fairy Glade", "levelName": "Fairy Glade" },0x78A320: { "id": 0x78A320, "areaName": "FairyGladeArea2", "displayName": "in the Fairy Glade", "levelName": "Fairy Glade" },0x7A1BD8: { "id": 0x7A1BD8, "areaName": "FairyGladeArea3", "displayName": "in the Fairy Glade", "levelName": "Fairy Glade" },0x77BFFC: { "id": 0x77BFFC, "areaName": "FairyGladeArea4", "displayName": "in the Fairy Glade", "levelName": "Fairy Glade" },0x771B74: { "id": 0x771B74, "areaName": "FairyGladeArea5", "displayName": "in the Fairy Glade", "levelName": "Fairy Glade" },0x74AAA8: { "id": 0x74AAA8, "areaName": "Results", "displayName": "viewing level results…", "levelName": "None" },0x788708: { "id": 0x788708, "areaName": "MarshesArea1", "displayName": "in the Marshes of Awakening", "levelName": "Marshes of Awakening" },0x7786E8: { "id": 0x7786E8, "areaName": "MarshesArea2", "displayName": "in the Marshes of Awakening", "levelName": "Marshes of Awakening" },0x790598: { "id": 0x790598, "areaName": "BayouArea1", "displayName": "in the Bayou", "levelName": "Bayou" },0x788764: { "id": 0x788764, "areaName": "BayouArea2", "displayName": "in the Bayou", "levelName": "Bayou" },0x7928A4: { "id": 0x7928A4, "areaName": "SoWaIArea1", "displayName": "in the Sanctuary of Water and Ice", "levelName": "Sanctuary of Water and Ice" },0x774694: { "id": 0x774694, "areaName": "SoWaIArea2", "displayName": "in the Sanctuary of Water and Ice", "levelName": "Sanctuary of Water and Ice" },0x76F100: { "id": 0x76F100, "areaName": "Polokus", "displayName": "in Polokus’s dream", "levelName": "Polokus" },0x0: { "id": 0x0, "areaName": "None", "displayName": "somewhere in the Glade of Dreams…", "levelName": "None" },0x751974: { "id": 0x751974, "areaName": "Bonus", "displayName": "in the bonus stage", "levelName": "None" },0x776C08: { "id": 0x776C08, "areaName": "MenhirArea1", "displayName": "in the Menhir Hills", "levelName": "Menhir Hills" },0x78FBD8: { "id": 0x78FBD8, "areaName": "MenhirArea2", "displayName": "in the Menhir Hills", "levelName": "Menhir Hills" },0x788950: { "id": 0x788950, "areaName": "MenhirArea3", "displayName": "in the Menhir Hills", "levelName": "Menhir Hills" },0x78402C: { "id": 0x78402C, "areaName": "BadDreamsArea1", "displayName": "in the Cave of Bad Dreams", "levelName": "Cave of Bad Dreams" },0x788148: { "id": 0x788148, "areaName": "BadDreamsArea2", "displayName": "in the Cave of Bad Dreams", "levelName": "Cave of Bad Dreams" },0x75AADC: { "id": 0x75AADC, "areaName": "MenhirArea4", "displayName": "in the Menhir Hills", "levelName": "Menhir Hills" },0x75BE94: { "id": 0x75BE94, "areaName": "CanopyArea1", "displayName": "in the Canopy", "levelName": "Canopy" },0x78C480: { "id": 0x78C480, "areaName": "CanopyArea2", "displayName": "in the Canopy", "levelName": "Canopy" },0x790A4C: { "id": 0x790A4C, "areaName": "CanopyArea3", "displayName": "in the Canopy", "levelName": "Canopy" },0x78AB50: { "id": 0x78AB50, "areaName": "WhaleBay1", "displayName": "in Whale Bay", "levelName": "Whale Bay" },0x77295C: { "id": 0x77295C, "areaName": "WhaleBay2", "displayName": "in Whale Bay", "levelName": "Whale Bay" },0x783C54: { "id": 0x783C54, "areaName": "WhaleBay3", "displayName": "in Whale Bay", "levelName": "Whale Bay" },0x78FD50: { "id": 0x78FD50, "areaName": "SoSaFArea1", "displayName": "in the Sanctuary of Stone and Fire", "levelName": "Sanctuary of Stone and Fire" },0x78BD50: { "id": 0x78BD50, "areaName": "SoSaFArea2", "displayName": "in the Sanctuary of Stone and Fire", "levelName": "Sanctuary of Stone and Fire" },0x782EE0: { "id": 0x782EE0, "areaName": "SoSaFArea3", "displayName": "in the Sanctuary of Stone and Fire", "levelName": "Sanctuary of Stone and Fire" },0x780F8C: { "id": 0x780F8C, "areaName": "SoSaFArea4", "displayName": "in the Sanctuary of Stone and Fire", "levelName": "Sanctuary of Stone and Fire" },0x79EA98: { "id": 0x79EA98, "areaName": "SosaFArea5", "displayName": "in the Sanctuary of Stone and Fire", "levelName": "Sanctuary of Stone and Fire" },0x7869E4: { "id": 0x7869E4, "areaName": "SosAFArea6", "displayName": "in the Sanctuary of Stone and Fire", "levelName": "Sanctuary of Stone and Fire" },0x78134C: { "id": 0x78134C, "areaName": "SoSaFArea7", "displayName": "in the Sanctuary of Stone and Fire", "levelName": "Sanctuary of Stone and Fire" },0x72BA74: { "id": 0x72BA74, "areaName": "EchoingCavesArea1", "displayName": "in the Echoing Caves", "levelName": "Echoing Caves" },0x78C8B4: { "id": 0x78C8B4, "areaName": "EchoingCavesArea2", "displayName": "in the Echoing Caves", "levelName": "Echoing Caves" },0x782920: { "id": 0x782920, "areaName": "EchoingCavesArea3", "displayName": "in the Echoing Caves", "levelName": "Echoing Caves" },0x7980D4: { "id": 0x7980D4, "areaName": "EchoingCavesArea4", "displayName": "in the Echoing Caves", "levelName": "Echoing Caves" },0x78A7A0: { "id": 0x78A7A0, "areaName": "PrecipiceArea1", "displayName": "on the Precipice", "levelName": "Precipice" },0x7844C0: { "id": 0x7844C0, "areaName": "PrecipiceArea2", "displayName": "on the Precipice", "levelName": "Precipice" },0x791414: { "id": 0x791414, "areaName": "PrecipiceArea3", "displayName": "on the Precipice", "levelName": "Precipice" },0x78CBB8: { "id": 0x78CBB8, "areaName": "TotWArea1", "displayName": "on the Top of the World", "levelName": "Top of the World" },0x775D9C: { "id": 0x775D9C, "areaName": "TotWArea2", "displayName": "on the Top of the World", "levelName": "Top of the World" },0x7971E4: { "id": 0x7971E4, "areaName": "SoRaLArea1", "displayName": "in the Sanctuary of Rock and Lava", "levelName": "Sanctuary of Rock and Lava" },0x77CEA8: { "id": 0x77CEA8, "areaName": "SoRaLArea2", "displayName": "in the Sanctuary of Rock and Lava", "levelName": "Sanctuary of Rock and Lava" },0x77AB34: { "id": 0x77AB34, "areaName": "SoRaLArea3", "displayName": "in the Sanctuary of Rock and Lava", "levelName": "Sanctuary of Rock and Lava" },0x78BF64: { "id": 0x78BF64, "areaName": "CouncilChamber", "displayName": "in the Council Chamber of the Teensies", "levelName": "None" },0x796874: { "id": 0x796874, "areaName": "BSoRaLArea1", "displayName": "beneath the Sanctuary of Rock and Lava", "levelName": "Beneath the Sanctuary of Rock and Lava" },0x77EB2C: { "id": 0x77EB2C, "areaName": "BSoRaLArea2", "displayName": "beneath the Sanctuary of Rock and Lava", "levelName": "Beneath the Sanctuary of Rock and Lava" },0x76FDAC: { "id": 0x76FDAC, "areaName": "BSoRaLArea3", "displayName": "beneath the Sanctuary of Rock and Lava", "levelName": "Beneath the Sanctuary of Rock and Lava" },0x76E05C: { "id": 0x76E05C, "areaName": "Polokus2", "displayName": "in Polokus’s dream", "levelName": "Polokus" },0x7A0A08: { "id": 0x7A0A08, "areaName": "TombArea1", "displayName": "in the Tomb of the Ancients", "levelName": "Tomb of the Ancients" },0x78797C: { "id": 0x78797C, "areaName": "TombArea2", "displayName": "in the Tomb of the Ancients", "levelName": "Tomb of the Ancients" },0x787014: { "id": 0x787014, "areaName": "TombArea3", "displayName": "in the Tomb of the Ancients", "levelName": "Tomb of the Ancients" },0x785CB4: { "id": 0x785CB4, "areaName": "TombArea4", "displayName": "in the Tomb of the Ancients", "levelName": "Tomb of the Ancients" },0x78B43C: { "id": 0x78B43C, "areaName": "TombArea5", "displayName": "in the Tomb of the Ancients", "levelName": "Tomb of the Ancients" },0x79BBD4: { "id": 0x79BBD4, "areaName": "IronMountainsArea1", "displayName": "in the Iron Mountains", "levelName": "Iron Mountains" },0x75FF30: { "id": 0x75FF30, "areaName": "IronMountainsArea2", "displayName": "in the Iron Mountains", "levelName": "Iron Mountains" },0x78075C: { "id": 0x78075C, "areaName": "IronMountainsArea3", "displayName": "in the Iron Mountains", "levelName": "Iron Mountains" },0x79A05C: { "id": 0x79A05C, "areaName": "IronMountainsArea4", "displayName": "in the Iron Mountains", "levelName": "Iron Mountains" },0x75A9DC: { "id": 0x75A9DC, "areaName": "PrisonShipArea1", "displayName": "on the Prison Ship", "levelName": "Prison Ship" },0x7697FC: { "id": 0x7697FC, "areaName": "PrisonShipArea2", "displayName": "on the Prison Ship", "levelName": "Prison Ship" },0x76D6FC: { "id": 0x76D6FC, "areaName": "PrisonShipArea3", "displayName": "on the Prison Ship", "levelName": "Prison Ship" },0x79B1DC: { "id": 0x79B1DC, "areaName": "CrowNest", "displayName": "on the Crow’s Nest", "levelName": "Prison Ship" },0x78BCBC: { "id": 0x78BCBC, "areaName": "FinalCutscene", "displayName": "somewhere in the Glade of Dreams…", "levelName": "Prison Ship" },0x78B9A8: { "id": 0x78B9A8, "areaName": "WalkOfLife", "displayName": "on the Walk of Life", "levelName": "Walk of Life" },0x77FD48: { "id": 0x77FD48, "areaName": "WalkOfPower", "displayName": "on the Walk of Power", "levelName": "Walk of Power" },0x782F14: { "id": 0x782F14, "areaName": "Credits", "displayName": "somewhere in the Glade of Dreams…", "levelName": "Prison Ship" },
}

function IsInLocation(levelName)
{
    isInLevel = always_false()
    
    for i in areas
    {
        area = areas[i]
        if (area["levelName"] == levelName)
        {
            isInLevel = isInLevel || areaId() == i
        }
    }
    
    return isInLevel
}

function IsInArea(areaName)
{
    for i in areas
    {
        area = areas[i]
        if (area["areaName"] == areaName)
        {
            return areaId() == i
        }
    }
}

function WasInArea(areaName)
{
    for i in areas
    {
        area = areas[i]
        if (area["areaName"] == areaName)
        {
            return Delta(areaId()) == i
        }
    }
}

function DictionaryKeyExists(dict, key)
{
    for i in dict
    {
        if (i == key)
        {
            return TRUE()
        }
    }
    
    return FALSE()
}

// Dictionary elements must have "addr" and "bit" fields.
// Returns a result like the following:
// {
//    <address>: [ <bit indices> ]
// }
function AggregateBitsFromAddressBits(dict)
{
    ret = {}
    for i in dict
    {
        element = dict[i]
        
        if (element["addr"] != -1)
        {
            if (DictionaryKeyExists(ret, element["addr"]) == TRUE())
            {
                arr = ret[element["addr"]]
                array_push(arr, element["bit"])
                ret[element["addr"]] = arr
            }
            else
            {
                ret[element["addr"]] = [ element["bit"] ]
            }
        }
    }
    
    return ret
}

// Converts an aggregate dictionary to an array of objects like the following:
// {
//    "type": "bitX"/"byte"
//    "mem": <memory accessor>
//    "address": <memory address>
// }
function ConvertBitAggregatesToBitCountableMemoryAccessors(aggregates)
{
    accessors = []
    for address in aggregates
    {
        agg = aggregates[address]
        if (length(agg) == 8)
        {
            array_push(accessors, { "type": "byte", "mem": byte(address), "address": address })
        }
        else
        {
            // Simply return each bit instead, since we can't use bitcount() on anything but bytes.
            for bit in agg
            {
                if (bit != -1 && address != -1)
                {
                    array_push(accessors, { "type": "bit", "mem": bit(bit, address), "address": address })
                }
            }
        }
    }
    
    return accessors
}

function GetCountableAccessorArrayFromAddressBits(dict)
{
    return ConvertBitAggregatesToBitCountableMemoryAccessors(AggregateBitsFromAddressBits(dict))
}

function woodsOfLightTeensieCage() => bit0(0x2249f1)
achievement(
    title = "Royal Confusion", description = "Complete the Woods of Light.", points = 1,
    id = 71511, badge = "165863", published = "2/5/2019 4:38:34 AM", modified = "4/5/2021 3:03:33 PM",
    trigger = WasBitflagSetInGame(woodsOfLightTeensieCage()) && CreateHitTargetedAndNextChain([IsInArea("WoodsOfLight"), IsInArea("None"), IsInArea("HallOfDoors")])
)

// todo: document changes in plan
function canGrabPurpleLums() => bit6(0x224a10)
achievement(
    title = "The Gift of Swing", description = "Obtain the power to swing.", points = 3,
    id = 71512, badge = "165864", published = "2/5/2019 4:38:38 AM", modified = "4/5/2021 3:03:35 PM",
    trigger = WasBitflagSetInGame(canGrabPurpleLums())
)

// todo: document changes in plan
GenerateCheevoFromConditions(
    name = "Freedom for the Forest Dwellers", description = "Find everything in the Fairy Glade.", points = 5,
    id = 54209, badge = "165866",
    conditions = GetConditionsByLevel("Fairy Glade"),
    threshold = GetCollectableTotalsByLevel("Fairy Glade")
)

// todo: document changes and promotion in plan
function raymanAnimation() => word(0x21A288)
function StartedSkiing() => raymanAnimation() != Delta(raymanAnimation()) && raymanAnimation() == 0x4434 && IsInArea("MarshesArea1")
function Respawned() => raymanAnimation() != Delta(raymanAnimation()) && raymanAnimation() == 0x43bc
function AButtonPressed() => bit7(0x0cf263) == 1
function ZButtonPressed() => bit5(0x0cf263) == 1
achievement(
    title = "Slalom in the Swamp", description = "Complete the waterski section without pressing A or Z.", points = 5,
    id = 54211, badge = "55942", published = "11/2/2017 7:03:57 PM", modified = "11/3/2017 11:30:32 AM",
    trigger = once(StartedSkiing()) && trigger_when(dword(0x1768b4) == 0x801aaaec)
        && never(AButtonPressed()) && never(ZButtonPressed()) && never(Respawned() && IsInArea("MarshesArea1"))
)

// todo: document changes in plan
GenerateCheevoFromConditions(
    name = "Skiway Rescue", description = "Find everything in the Marshes of Awakening.", points = 5,
    id = 54210, badge = "165894",
    conditions = GetConditionsByLevel("Marshes of Awakening"),
    threshold = GetCollectableTotalsByLevel("Marshes of Awakening")
)

// todo: document changes in plan
// todo: name redundancy with "Combing the Beach"
GenerateCheevoFromConditions(name = "Combing the Everglades", description = "Find everything in the Bayou.", points = 5,
    id = 54212, badge = "165895",
    conditions = GetConditionsByLevel("Bayou"),
    threshold = GetCollectableTotalsByLevel("Bayou")
)

GenerateCheevoFromConditions(
    name = "Lifelight", description = "Find all Yellow Lums on the Walk of Life.", points = 5,
    id = 54213, badge = "165896",
    conditions = GetConditionsByLevel("Walk of Life"),
    threshold = GetCollectableTotalsByLevel("Walk of Life")
)

// todo: document changes in plan
GenerateCheevoFromConditions(name = "Colder than Ice", description = "Find everything in the Sanctuary of Water and Ice.", points = 10,
    id = 54215, badge = "165897",
    conditions = GetConditionsByLevel("Sanctuary of Water and Ice"),
    threshold = GetCollectableTotalsByLevel("Sanctuary of Water and Ice")
)

// todo: document changes in plan
function waterMask() => bit7(0x224a12)
achievement(
    title = "Water and Ice", description = "Defeat the Guardian Axel and obtain the first mask.", points = 5,
    id = 71513, badge = "165865", published = "2/5/2019 4:38:40 AM", modified = "4/5/2021 3:03:48 PM",
    trigger = WasBitflagSetInGame(waterMask())
)

function IsCutscenePlaying() => byte(0x22494e) == 0xc
function cameraXCoords() => word(0x17691E)
// todo: document changes in plan
achievement(
    title = "Jour de la Cupidite [m]", description = "Accept Jano's offer for treasure.", points = 1,
    id = 71514, badge = "165867", published = "2/5/2019 4:38:42 AM", modified = "4/5/2021 3:03:50 PM",
    trigger = repeated(200, cameraXCoords() == 65516)
              && never(!IsCutscenePlaying()) && never(!IsInArea("BadDreamsArea2"))
)

function elixirOfLife() => bit7(0x224a13)
// todo: document changes in plan
achievement(
    title = "Screw the Money; I Have Rules!", description = "Acquire the Elixir of Life.", points = 1,
    id = 71515, badge = "165868", published = "2/5/2019 4:38:44 AM", modified = "4/5/2021 3:03:51 PM",
    trigger = WasBitflagSetInGame(elixirOfLife())
)

// todo: document changes in plan
// Yes, the fact the title isn't a compound word is intentional; you're a catcher (of Lums) in a dream more than you are a catcher of dreams, as "dreamcatcher" implies.
GenerateCheevoFromConditions(name = "Dream Catcher", description = "Find everything in the Cave of Bad Dreams.", points = 5,
    id = 54217, badge = "165898",
    conditions = GetConditionsByLevel("Cave of Bad Dreams"),
    threshold = GetCollectableTotalsByLevel("Cave of Bad Dreams")
)

function preJanoMusicId() => 0x801aa7ac
function PreJanoChaseMusicIsPlaying() => musicId() == preJanoMusicId()
function PreJanoChaseMusicWasPlaying() => Delta(musicId()) == preJanoMusicId()
function JanoChaseMusicPlaying() => musicId() == 0x801aabec
function JanoEncounterMusicPlaying() => musicId() == 0x801aac0c
function IsShooting() => bit0(0x204263) == 1
achievement(title = "Appreciate the Scenery [m]", points = 10,
    description = "Complete the slide escape in the Cave of Bad Dreams without firing a shot.",
    trigger = once(PreJanoChaseMusicWasPlaying() && JanoChaseMusicPlaying())
        && trigger_when(JanoEncounterMusicPlaying())
        && never(IsShooting()) && never(PreJanoChaseMusicIsPlaying())
)

GenerateCheevoFromConditions(name = "Hidden in the Spires", description = "Find everything in the Menhir Hills.", points = 5,
    id = 54218, badge = "165899",
    conditions = GetConditionsByLevel("Menhir Hills"),
    threshold = GetCollectableTotalsByLevel("Menhir Hills")
)

// todo: document changes in plan
function canChargeShots() => bit6(0x224a16)
achievement(
    title = "Mr. Bigshot", description = "Obtain the ability to charge your shots.", points = 3,
    id = 71516, badge = "165869", published = "2/5/2019 4:38:46 AM", modified = "4/5/2021 3:03:55 PM",
    trigger = WasBitflagSetInGame(canChargeShots())
)

// todo: document changes in plan
GenerateCheevoFromConditions(
    name = "Rayman vs. Wild", description = "Find everything in the Canopy.", points = 5,
    id = 54220, badge = "165900",
    conditions = GetConditionsByLevel("Canopy"),
    threshold = GetCollectableTotalsByLevel("Canopy")
)

// todo: document changes in plan
GenerateCheevoFromConditions(
    name = "Combing the Beach", description = "Find everything in Whale Bay.", points = 5,
    id = 54223, badge = "165901",
    conditions = GetConditionsByLevel("Whale Bay"),
    threshold = GetCollectableTotalsByLevel("Whale Bay")
)

function earthMask() => bit0(0x224a13)
function CompletedSanctuaryOfStoneAndFireForTheFirstTime() => CreateHitTargetedAndNextChain([IsInArea("SosAFArea6"), IsInArea("None"), IsInArea("Polokus")])
achievement(
    title = "Stone and Fire", description = "Defeat the Guardian Umber and obtain the second mask.", points = 5,
    id = 71517, badge = "165870", published = "2/5/2019 4:38:47 AM", modified = "4/5/2021 3:03:59 PM",
    trigger = WasBitflagSetInGame(earthMask())
)

// todo: document changes in plan
// todo: add trigger_when()
// Note that there are multiple places in the level where you can get Golden Fists, and the original logic didn't check to see if you ever lost the fists; it only checked (incorrectly)
// if the fists were still there when you completed the level.
function HasGoldenFists() => byte(0x0c8ca1) == 1
achievement(
    title = "The Midas Touch [m]", description = "Finish the Sanctuary of Stone and Fire for the first time with the Golden Fists still in your possession.", points = 10,
    id = 71960, badge = "165892", published = "2/14/2019 11:54:54 PM", modified = "4/5/2021 3:05:28 PM",
    trigger = CompletedSanctuaryOfStoneAndFireForTheFirstTime() && never(!HasGoldenFists())
        && never(IsInLocation("Hall of Doors"))
)

// todo: document changes in plan
GenerateCheevoFromConditions(
    name = "The Plum Master", description = "Find everything in the Sanctuary of Stone and Fire.", points = 10,
    id = 54225, badge = "165902",
    conditions = GetConditionsByLevel("Sanctuary of Stone and Fire"),
    threshold = GetCollectableTotalsByLevel("Sanctuary of Stone and Fire")
)

// todo: document changes in plan
// todo: consider renaming
GenerateCheevoFromConditions(
    name = "Do a Barrel Roll!", description = "Find everything in the Echoing Caves.", points = 5,
    id = 54226, badge = "165903",
    conditions = GetConditionsByLevel("Echoing Caves"),
    threshold = GetCollectableTotalsByLevel("Echoing Caves")
)

function IsPausing() => byte(0x22493b) == 1
function systemTimer() => dword(0x021808)
function FrameAdvanced(onlyWhen = true) => Delta(systemTimer()) != systemTimer() && onlyWhen
function SecondsToFrames(seconds) => seconds * 50 // The PAL version runs at 50 FPS
function IsCutscenePlaying() => byte(0x22494e) == 0xc
function echoingCavesTimeLimit() => 117
function echoingCavesFrameBuffer() => 27 // This amount of time passes when transitioning between the cutscene area and the actual playable area. We don't want to count it against the player.
function RaymanIsCelebrating() => raymanAnimation() == 0x44ac
function EnteredEchoingCaves() => CreateHitTargetedAndNextChain([IsInArea("EchoingCavesArea1"), IsInArea("None"), IsInArea("EchoingCavesArea2")])
function FrameAdvancedWhilePlaying() => FrameAdvanced() && EnteredEchoingCaves() && !IsCutscenePlaying() && !IsPausing()

// todo: document changes in plan
achievement(
    title = "Rayman the Handyman", description = "Open the main door in the Echoing Caves within " + SecondsToFormat(echoingCavesTimeLimit()) + ".", points = 10,
    id = 71534, badge = "165887", published = "2/5/2019 4:39:15 AM", modified = "4/5/2021 3:05:38 PM",
    trigger = never(repeated(SecondsToFrames(echoingCavesTimeLimit()) + echoingCavesFrameBuffer(), FrameAdvancedWhilePlaying()))
        && trigger_when(RaymanIsCelebrating()) && EnteredEchoingCaves() && never(!IsInLocation("Echoing Caves") && !IsInLocation("None"))
)

// todo: document changes in plan
// todo: consider renaming
GenerateCheevoFromConditions(
    name = "Run, Rayman, Run!", description = "Find everything on the Precipice.", points = 5,
    id = 54227, badge = "165904",
    conditions = GetConditionsByLevel("Precipice"),
    threshold = GetCollectableTotalsByLevel("Precipice")
)

// todo: document changes in plan
GenerateCheevoFromConditions(
    name = "Deadly Stairlift", description = "Find everything on the Top of the World.", points = 5,
    id = 54228, badge = "165905",
    conditions = GetConditionsByLevel("Top of the World"),
    threshold = GetCollectableTotalsByLevel("Top of the World")
)

// todo: document changes in plan
GenerateCheevoFromConditions(
    name = "Hotter than Lava", description = "Find everything in the Sanctuary of Rock and Lava.", points = 5,
    id = 54230, badge = "165906",
    conditions = GetConditionsByLevel("Sanctuary of Rock and Lava"),
    threshold = GetCollectableTotalsByLevel("Sanctuary of Rock and Lava")
)

// todo: document changes in plan
GenerateCheevoFromConditions(
    name = "Fast and Fairy-ous", description = "Find all Yellow Lums on the Walk of Power.", points = 5,
    id = 54231, badge = "165907",
    conditions = GetConditionsByLevel("Walk of Power"),
    threshold = GetCollectableTotalsByLevel("Walk of Power")
)

// todo: document changes in plan
function fireMask() => bit1(0x224a13)
achievement(
    title = "Rock and Lava", description = "Defeat the Guardian Foutch and obtain the third mask.", points = 5,
    id = 71518, badge = "165871", published = "2/5/2019 4:38:49 AM", modified = "4/5/2021 3:04:12 PM",
    trigger = WasBitflagSetInGame(fireMask())
)

// todo: document changes in plan
GenerateCheevoFromConditions(
    name = "Use Your Head", description = "Find everything beneath the Sanctuary of Rock and Lava.", points = 10,
    id = 54234, badge = "165908",
    conditions = GetConditionsByLevel("Beneath the Sanctuary of Rock and Lava"),
    threshold = GetCollectableTotalsByLevel("Beneath the Sanctuary of Rock and Lava")
)

// todo: document changes in plan
function freedClarkFromMindControl() => bit7(0x224a18)
achievement(
    title = "Reapply the Tinfoil", description = "Free Clark from mind control.", points = 3,
    id = 71519, badge = "165872", published = "2/5/2019 4:38:50 AM", modified = "4/5/2021 3:04:15 PM",
    trigger = WasBitflagSetInGame(freedClarkFromMindControl())
)

// todo: document changes in plan
GenerateCheevoFromConditions(
    name = "Hope Within Hell", description = "Find everything in the Tomb of the Ancients.", points = 5,
    id = 54236, badge = "165909",
    conditions = GetConditionsByLevel("Tomb of the Ancients"),
    threshold = GetCollectableTotalsByLevel("Tomb of the Ancients")
)

function windMask() => bit2(0x224a13)
achievement(
    title = "Wind and Clouds", description = "Save Globox's and Uglette's children and obtain the final mask.", points = 5,
    id = 71520, badge = "165873", published = "2/5/2019 4:38:52 AM", modified = "4/5/2021 3:04:19 PM",
    trigger = WasBitflagSetInGame(windMask())
)

GenerateCheevoFromConditions(
    name = "From the Swamps to the Skies", description = "Find everything in the Iron Mountains.", points = 10,
    id = 54238, badge = "165910",
    conditions = GetConditionsByLevel("Iron Mountains"),
    threshold = GetCollectableTotalsByLevel("Iron Mountains")
)

// todo: document changes in plan
achievement(
    title = "The Great Escape", description = "Defeat Admiral Razorbeard.", points = 25,
    id = 71521, badge = "165874", published = "2/5/2019 4:38:53 AM", modified = "4/5/2021 3:04:26 PM",
    trigger = CreateHitTargetedAndNextChain([IsInArea("CrowNest"), IsInArea("None"), IsInArea("FinalCutscene")]) && IsCutscenePlaying()
        && never(IsInLocation("Hall of Doors"))
)

GenerateCheevoFromConditions(
    name = "Light's Liberation", description = "Collect all Yellow Lums on the Prison Ship.", points = 10,
    id = 71959, badge = "165911",
    conditions = GetConditionsByLevel("Prison Ship"),
    threshold = GetCollectableTotalsByLevel("Prison Ship")
)

// todo: document changes in plan
GenerateCheevoFromBits(name = "Naive Hero", description = "Find 100 Lums.", points = 3, id = 71522, badge = "165875",
    addresses = lums, threshold = 100
)

// todo: document changes in plan
GenerateCheevoFromBits(name = "Novice Hero", description = "Find 250 Lums.", points = 5, id = 71523, badge = "165876",
    addresses = lums, threshold = 250
)

// todo: document changes in plan
GenerateCheevoFromBits(name = "Enlightened Hero", description = "Find 500 Lums.", points = 10, id = 71524, badge = "165877",
    addresses = lums, threshold = 500
)

// todo: document changes in plan
GenerateCheevoFromBits(name = "Wise Hero", description = "Find 750 Lums.", points = 25, id = 71525, badge = "165878",
    addresses = lums, threshold = 750
)

// todo: document changes in plan
GenerateCheevoFromBits(name = "Omniscient Hero", description = "Find 999 Lums.", points = 50, id = 71526, badge = "165879",
    addresses = lums, threshold = 999
)

function oneThousandthYellowLum() => bit5(0x224a06)
achievement(
    title = "From the Bowels of Death", description = "Find the 1000th Yellow Lum.", points = 5,
    id = 71540, badge = "165893", published = "2/5/2019 4:39:26 AM", modified = "4/5/2021 3:05:50 PM",
    trigger = WasBitflagSetInGame(oneThousandthYellowLum())
)

function bonusAnimation() => word(0x74cee8)
function bonusRaceTimer() => word(0x74e2f2)
function IsPausing() => byte(0x0c86c3) == 1
function BonusRaceWaitingToStart() => bonusRaceTimer() == 1
function BonusRaceStarted() => Delta(bonusAnimation()) != bonusAnimation() && bonusAnimation() == 0xcba8
function WonBonusRace() => once(BonusRaceStarted()) && never(BonusRaceWaitingToStart()) && trigger_when(bonusAnimation() == 0xccc8)
function LostBonusRace() => Delta(bonusAnimation()) != bonusAnimation() && bonusAnimation() == 0xcce8
function BonusRaceTimerReset() => bonusRaceTimer() != Delta(bonusRaceTimer()) && bonusRaceTimer() == 1

// The framerate is 50 Hz in the PAL version, so each frame is 2ms.
function TimeElapsedInMilliseconds(timeLimit = 0, onlyWhen = true) => tally(timeLimit, [ FrameAdvanced(onlyWhen), FrameAdvanced(onlyWhen) ])
function BonusRaceCanceled() => !IsInArea("Bonus") || IsPausing() || LostBonusRace() || BonusRaceTimerReset()

// todo: rebalance bonus stage cheevos, as the implementation consistently makes the final times about .57 seconds slower than the in-game time.

// todo: document changes in plan
achievement(
    title = "A Quick Jog", description = "Beat the bonus stage.", points = 3,
    id = 71530, badge = "165883", published = "2/5/2019 4:39:09 AM", modified = "4/5/2021 3:05:32 PM",
    trigger = WonBonusRace() && never(BonusRaceCanceled())
)

function bonusTimeLimit() => 2177

// todo: document changes in plan
achievement(
    title = "Fairy Speedster", description = "Beat the bonus stage in 21.77 seconds or less.", points = 10,
    id = 71531, badge = "165884", published = "2/5/2019 4:39:11 AM", modified = "4/5/2021 3:05:33 PM",
    trigger = WonBonusRace() && never(BonusRaceCanceled()) && never(TimeElapsedInMilliseconds(bonusTimeLimit()))
)

leaderboard(title = "Bonus Stage", description = "Get a better time in the race against Spyglass.",
    start = IsInArea("Bonus") && BonusRaceStarted(),
    cancel = BonusRaceCanceled(),
    submit = WonBonusRace(),
    value = measured(TimeElapsedInMilliseconds())
)

// todo: document changes in plan
function walkOfLifeTimer() => dword(0x5E9AC0) // todo: actually a float
function StartedWalkOfLife() => IsInLocation("Walk of Life") && Delta(walkOfLifeTimer()) == 0 && walkOfLifeTimer() > 0
function CanceledWalkOfLife() => !IsInLocation("Walk of Life") || Delta(walkOfLifeTimer()) > 0 && walkOfLifeTimer() == 0
function FinishedWalkOfLife() => RaymanIsCelebrating()
function AbleToAdvanceTimeInWalkOfLife() => walkOfLifeTimer() > 0 && !IsPausing()
achievement(
    title = "Sprint of Life", description = "Complete the Walk of Life within 1:45.98.", points = 5,
    id = 71532, badge = "165885", published = "2/5/2019 4:39:12 AM", modified = "4/5/2021 3:05:36 PM",
    trigger = once(StartedWalkOfLife()) && trigger_when(FinishedWalkOfLife()) && never(TimeElapsedInMilliseconds(10599, AbleToAdvanceTimeInWalkOfLife()))
        && never(CanceledWalkOfLife())
)

leaderboard(title = "Walk of Life", description = "Complete the Walk of Life as quickly as you can.",
    start = StartedWalkOfLife(),
    cancel = CanceledWalkOfLife(),
    submit = FinishedWalkOfLife(),
    value = measured(TimeElapsedInMilliseconds(onlyWhen = AbleToAdvanceTimeInWalkOfLife()))
)

function walkOfPowerTimer() => dword(0x5ECF34) // todo: actually a float
function StartedWalkOfPower() => IsInLocation("Walk of Power") && Delta(walkOfPowerTimer()) == 0 && walkOfPowerTimer() > 0
function CanceledWalkOfPower() => !IsInLocation("Walk of Power") || Delta(walkOfPowerTimer()) > 0 && walkOfPowerTimer() == 0
function FinishedWalkOfPower() => RaymanIsCelebrating()
function AbleToAdvanceTimeInWalkOfPower() => walkOfPowerTimer() > 0 && !IsPausing()
achievement(
    title = "Sprint of Power", description = "Complete the Walk of Power within 1:35.23.", points = 10,
    id = 71533, badge = "165886", published = "2/5/2019 4:39:14 AM", modified = "4/5/2021 3:05:37 PM",
    trigger = once(StartedWalkOfPower()) && trigger_when(FinishedWalkOfPower()) && never(TimeElapsedInMilliseconds(9524, AbleToAdvanceTimeInWalkOfPower()))
        && never(CanceledWalkOfPower())
)

leaderboard(title = "Walk of Power", description = "Complete the Walk of Power as quickly as you can.",
    start = StartedWalkOfPower(),
    cancel = CanceledWalkOfPower(),
    submit = FinishedWalkOfPower(),
    value = measured(TimeElapsedInMilliseconds(onlyWhen = AbleToAdvanceTimeInWalkOfPower()))
)

// todo: consider demoting due to inability to fix
achievement(
    title = "Think of the Children", description = "In Iron Mountains, save Globox's children from the Reformatory for Disturbing Children.", points = 10,
    id = 71535, badge = "165888", published = "2/5/2019 4:39:17 AM", modified = "4/21/2021 4:00:12 PM",
    trigger = word(0x0E5C34) == 25951 && areaId() == 30727 && byte(0x77AB93) == 8 && byte(0x77B44B) == 8
)

// todo: document changes in plan
function ammoState() => byte(0x5F01BF)
function UnlimitedAmmoUnlockedDuringFinalBoss() => Delta(ammoState()) != ammoState() && ammoState() == 1
achievement(
    title = "Unlimited Reserves", description = "Find and obtain a blue orb during the fight against Admiral Razorbeard.", points = 10,
    id = 71536, badge = "165889", published = "2/5/2019 4:39:19 AM", modified = "4/5/2021 3:05:42 PM",
    trigger = IsInArea("CrowNest") && UnlimitedAmmoUnlockedDuringFinalBoss()
)

// todo: document changes in plan
function xcoord() => word(0x17691e) // Apparently.
achievement(
    title = "A Literal Character Shmup", description = "Unlock Menezis.", points = 1,
    id = 71538, badge = "165891", published = "2/5/2019 4:39:23 AM", modified = "4/5/2021 3:05:47 PM",
    trigger = IsInArea("Credits") && xcoord() == 65492
)

// todo: document changes in plan
achievement(
    title = "Regular Jailbreaker", description = "Destroy 10 cages.", points = 5,
    id = 71527, badge = "165880", published = "2/5/2019 4:39:04 AM", modified = "4/5/2021 3:05:31 PM",
    trigger = prev(byte(0x224941)) == 9 && byte(0x224941) == 10
)

// todo: document changes in plan
achievement(
    title = "Veteran Jailbreaker", description = "Destroy 40 cages.", points = 10,
    id = 71528, badge = "165882", published = "2/5/2019 4:39:05 AM", modified = "4/5/2021 3:05:52 PM",
    trigger = prev(byte(0x224941)) == 39 && byte(0x224941) == 40
)

// todo: document changes in plan
achievement(
    title = "Legendary Jailbreaker", description = "Destroy all 80 cages.", points = 25,
    id = 71529, badge = "165881", published = "2/5/2019 4:39:07 AM", modified = "4/5/2021 3:05:48 PM",
    trigger = prev(byte(0x224941)) == 79 && byte(0x224941) == 80
)

function lum1000Consumed() => bit0(0x224a11)

function TotalLums()
{
    return 1000 - lum1000Consumed() + oneThousandthYellowLum()
}

function GetAreaLookupForRichPresence()
{
    lookup = {}
    for i in areas
    {
        area = areas[i]
        lookup[i] = area["displayName"]
    }
    return lookup
}

rich_presence_conditional_display(!IsInGame() || IsInLocation("Menu"), "In the main menu...")

rich_presence_display("Rayman is {0} | {1}/{3} Lums | {2}/80 Cages",
    rich_presence_lookup("Map", areaId(), GetAreaLookupForRichPresence(), "somewhere in the Glade of Dreams..."),
    rich_presence_value("lum1", lumsFound),
    rich_presence_value("cage", byte(0x224941)),
    rich_presence_value("lumTotal", TotalLums())
)
