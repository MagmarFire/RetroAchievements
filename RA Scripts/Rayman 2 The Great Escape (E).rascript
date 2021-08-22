// Rayman 2: The Great Escape (E)
// #ID = 10269

function TRUE() => 1
function FALSE() => 0

function Delta(mem) => prev(mem)

function Debug(string)
{
    achievement(title = string, description = "", points = 0, trigger = always_false())
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
1: { "levelId": 2, "mem": bit0(0x224988),"good": 1, "addr": 0x224988, "bit": 0},2: { "levelId": 2, "mem": bit1(0x224988),"good": 1, "addr": 0x224988, "bit": 1},3: { "levelId": 2, "mem": bit2(0x224988),"good": 1, "addr": 0x224988, "bit": 2},4: { "levelId": 2, "mem": bit3(0x224988),"good": 1, "addr": 0x224988, "bit": 3},5: { "levelId": 2, "mem": bit4(0x224988),"good": 1, "addr": 0x224988, "bit": 4},6: { "levelId": 2, "mem": bit5(0x224988),"good": 1, "addr": 0x224988, "bit": 5},7: { "levelId": 2, "mem": bit6(0x224988),"good": 1, "addr": 0x224988, "bit": 6},8: { "levelId": 2, "mem": bit7(0x224988),"good": 1, "addr": 0x224988, "bit": 7},9: { "levelId": 2, "mem": bit2(0x224989),"good": 1, "addr": 0x224989, "bit": 2},10: { "levelId": 2, "mem": bit1(0x22498a),"good": 1, "addr": 0x22498a, "bit": 1},11: { "levelId": 2, "mem": bit2(0x22498a),"good": 1, "addr": 0x22498a, "bit": 2},12: { "levelId": 2, "mem": bit3(0x22498a),"good": 1, "addr": 0x22498a, "bit": 3},13: { "levelId": 2, "mem": bit4(0x22498a),"good": 1, "addr": 0x22498a, "bit": 4},14: { "levelId": 2, "mem": bit5(0x22498a),"good": 1, "addr": 0x22498a, "bit": 5},15: { "levelId": 2, "mem": bit6(0x22498a),"good": 1, "addr": 0x22498a, "bit": 6},16: { "levelId": 2, "mem": bit7(0x22498a),"good": 1, "addr": 0x22498a, "bit": 7},17: { "levelId": 2, "mem": bit5(0x22498b),"good": 1, "addr": 0x22498b, "bit": 5},18: { "levelId": 2, "mem": bit6(0x22498b),"good": 1, "addr": 0x22498b, "bit": 6},19: { "levelId": 2, "mem": bit7(0x22498b),"good": 1, "addr": 0x22498b, "bit": 7},20: { "levelId": 2, "mem": bit0(0x22498c),"good": 1, "addr": 0x22498c, "bit": 0},21: { "levelId": 2, "mem": bit1(0x22498c),"good": 1, "addr": 0x22498c, "bit": 1},22: { "levelId": 2, "mem": bit2(0x22498c),"good": 1, "addr": 0x22498c, "bit": 2},23: { "levelId": 2, "mem": bit3(0x22498c),"good": 1, "addr": 0x22498c, "bit": 3},24: { "levelId": 2, "mem": bit4(0x22498c),"good": 1, "addr": 0x22498c, "bit": 4},25: { "levelId": 2, "mem": bit5(0x22498c),"good": 1, "addr": 0x22498c, "bit": 5},26: { "levelId": 2, "mem": bit6(0x22498c),"good": 1, "addr": 0x22498c, "bit": 6},27: { "levelId": 2, "mem": bit7(0x22498c),"good": 1, "addr": 0x22498c, "bit": 7},28: { "levelId": 2, "mem": bit0(0x22498d),"good": 1, "addr": 0x22498d, "bit": 0},29: { "levelId": 2, "mem": bit1(0x22498d),"good": 1, "addr": 0x22498d, "bit": 1},30: { "levelId": 2, "mem": bit2(0x22498d),"good": 1, "addr": 0x22498d, "bit": 2},31: { "levelId": 2, "mem": bit3(0x22498d),"good": 1, "addr": 0x22498d, "bit": 3},32: { "levelId": 2, "mem": bit4(0x22498d),"good": 1, "addr": 0x22498d, "bit": 4},33: { "levelId": 2, "mem": bit5(0x22498d),"good": 1, "addr": 0x22498d, "bit": 5},34: { "levelId": 2, "mem": bit6(0x22498d),"good": 1, "addr": 0x22498d, "bit": 6},35: { "levelId": 2, "mem": bit7(0x22498d),"good": 1, "addr": 0x22498d, "bit": 7},36: { "levelId": 2, "mem": bit0(0x22498e),"good": 1, "addr": 0x22498e, "bit": 0},37: { "levelId": 2, "mem": bit1(0x22498e),"good": 1, "addr": 0x22498e, "bit": 1},38: { "levelId": 5, "mem": bit2(0x22498e),"good": 1, "addr": 0x22498e, "bit": 2},39: { "levelId": 5, "mem": bit3(0x22498e),"good": 1, "addr": 0x22498e, "bit": 3},40: { "levelId": 5, "mem": bit4(0x22498e),"good": 1, "addr": 0x22498e, "bit": 4},41: { "levelId": 5, "mem": bit5(0x22498e),"good": 1, "addr": 0x22498e, "bit": 5},42: { "levelId": 5, "mem": bit6(0x22498e),"good": 1, "addr": 0x22498e, "bit": 6},43: { "levelId": 5, "mem": bit7(0x22498e),"good": 1, "addr": 0x22498e, "bit": 7},44: { "levelId": 5, "mem": bit0(0x22498f),"good": 1, "addr": 0x22498f, "bit": 0},45: { "levelId": 5, "mem": bit1(0x22498f),"good": 1, "addr": 0x22498f, "bit": 1},46: { "levelId": 5, "mem": bit2(0x22498f),"good": 1, "addr": 0x22498f, "bit": 2},47: { "levelId": 5, "mem": bit3(0x22498f),"good": 1, "addr": 0x22498f, "bit": 3},48: { "levelId": 5, "mem": bit4(0x22498f),"good": 1, "addr": 0x22498f, "bit": 4},49: { "levelId": 5, "mem": bit5(0x22498f),"good": 1, "addr": 0x22498f, "bit": 5},50: { "levelId": 5, "mem": bit6(0x22498f),"good": 1, "addr": 0x22498f, "bit": 6},51: { "levelId": 5, "mem": bit7(0x22498f),"good": 1, "addr": 0x22498f, "bit": 7},52: { "levelId": 5, "mem": bit0(0x224990),"good": 1, "addr": 0x224990, "bit": 0},53: { "levelId": 5, "mem": bit1(0x224990),"good": 1, "addr": 0x224990, "bit": 1},54: { "levelId": 5, "mem": bit2(0x224990),"good": 1, "addr": 0x224990, "bit": 2},55: { "levelId": 5, "mem": bit3(0x224990),"good": 1, "addr": 0x224990, "bit": 3},56: { "levelId": 5, "mem": bit4(0x224990),"good": 1, "addr": 0x224990, "bit": 4},57: { "levelId": 5, "mem": bit5(0x224990),"good": 1, "addr": 0x224990, "bit": 5},58: { "levelId": 5, "mem": bit6(0x224990),"good": 1, "addr": 0x224990, "bit": 6},59: { "levelId": 5, "mem": bit7(0x224990),"good": 1, "addr": 0x224990, "bit": 7},60: { "levelId": 5, "mem": bit0(0x224991),"good": 1, "addr": 0x224991, "bit": 0},61: { "levelId": 5, "mem": bit1(0x224991),"good": 1, "addr": 0x224991, "bit": 1},62: { "levelId": 5, "mem": bit2(0x224991),"good": 1, "addr": 0x224991, "bit": 2},63: { "levelId": 5, "mem": bit3(0x224991),"good": 1, "addr": 0x224991, "bit": 3},64: { "levelId": 5, "mem": bit4(0x224991),"good": 1, "addr": 0x224991, "bit": 4},65: { "levelId": 5, "mem": bit5(0x224991),"good": 1, "addr": 0x224991, "bit": 5},66: { "levelId": 5, "mem": bit6(0x224991),"good": 1, "addr": 0x224991, "bit": 6},67: { "levelId": 5, "mem": bit7(0x224991),"good": 1, "addr": 0x224991, "bit": 7},68: { "levelId": 5, "mem": bit0(0x224992),"good": 1, "addr": 0x224992, "bit": 0},69: { "levelId": 5, "mem": bit1(0x224992),"good": 1, "addr": 0x224992, "bit": 1},70: { "levelId": 5, "mem": bit2(0x224992),"good": 1, "addr": 0x224992, "bit": 2},71: { "levelId": 5, "mem": bit3(0x224992),"good": 1, "addr": 0x224992, "bit": 3},72: { "levelId": 5, "mem": bit4(0x224992),"good": 1, "addr": 0x224992, "bit": 4},73: { "levelId": 5, "mem": bit5(0x224992),"good": 1, "addr": 0x224992, "bit": 5},74: { "levelId": 5, "mem": bit6(0x224992),"good": 1, "addr": 0x224992, "bit": 6},75: { "levelId": 5, "mem": bit7(0x224992),"good": 1, "addr": 0x224992, "bit": 7},76: { "levelId": 5, "mem": bit0(0x224993),"good": 1, "addr": 0x224993, "bit": 0},77: { "levelId": 5, "mem": bit1(0x224993),"good": 1, "addr": 0x224993, "bit": 1},78: { "levelId": 5, "mem": bit2(0x224993),"good": 1, "addr": 0x224993, "bit": 2},79: { "levelId": 5, "mem": bit3(0x224993),"good": 1, "addr": 0x224993, "bit": 3},80: { "levelId": 5, "mem": bit4(0x224993),"good": 1, "addr": 0x224993, "bit": 4},81: { "levelId": 5, "mem": bit5(0x224993),"good": 1, "addr": 0x224993, "bit": 5},82: { "levelId": 5, "mem": bit6(0x224993),"good": 1, "addr": 0x224993, "bit": 6},83: { "levelId": 5, "mem": bit7(0x224993),"good": 1, "addr": 0x224993, "bit": 7},84: { "levelId": 5, "mem": bit0(0x224994),"good": 1, "addr": 0x224994, "bit": 0},85: { "levelId": 5, "mem": bit1(0x224994),"good": 1, "addr": 0x224994, "bit": 1},86: { "levelId": 5, "mem": bit2(0x224994),"good": 1, "addr": 0x224994, "bit": 2},87: { "levelId": 5, "mem": bit3(0x224994),"good": 1, "addr": 0x224994, "bit": 3},88: { "levelId": 6, "mem": bit4(0x224994),"good": 1, "addr": 0x224994, "bit": 4},89: { "levelId": 6, "mem": bit5(0x224994),"good": 1, "addr": 0x224994, "bit": 5},90: { "levelId": 6, "mem": bit6(0x224994),"good": 1, "addr": 0x224994, "bit": 6},91: { "levelId": 6, "mem": bit7(0x224994),"good": 1, "addr": 0x224994, "bit": 7},92: { "levelId": 6, "mem": bit0(0x224995),"good": 1, "addr": 0x224995, "bit": 0},93: { "levelId": 6, "mem": bit1(0x224995),"good": 1, "addr": 0x224995, "bit": 1},94: { "levelId": 6, "mem": bit2(0x224995),"good": 1, "addr": 0x224995, "bit": 2},95: { "levelId": 6, "mem": bit3(0x224995),"good": 1, "addr": 0x224995, "bit": 3},96: { "levelId": 6, "mem": bit4(0x224995),"good": 1, "addr": 0x224995, "bit": 4},97: { "levelId": 6, "mem": bit5(0x224995),"good": 1, "addr": 0x224995, "bit": 5},98: { "levelId": 6, "mem": bit6(0x224995),"good": 1, "addr": 0x224995, "bit": 6},99: { "levelId": 6, "mem": bit7(0x224995),"good": 1, "addr": 0x224995, "bit": 7},100: { "levelId": 6, "mem": bit0(0x224996),"good": 1, "addr": 0x224996, "bit": 0},101: { "levelId": 6, "mem": bit1(0x224996),"good": 1, "addr": 0x224996, "bit": 1},102: { "levelId": 6, "mem": bit2(0x224996),"good": 1, "addr": 0x224996, "bit": 2},103: { "levelId": 6, "mem": bit3(0x224996),"good": 1, "addr": 0x224996, "bit": 3},104: { "levelId": 6, "mem": bit4(0x224996),"good": 1, "addr": 0x224996, "bit": 4},105: { "levelId": 6, "mem": bit5(0x224996),"good": 1, "addr": 0x224996, "bit": 5},106: { "levelId": 6, "mem": bit6(0x224996),"good": 1, "addr": 0x224996, "bit": 6},107: { "levelId": 6, "mem": bit7(0x224996),"good": 1, "addr": 0x224996, "bit": 7},108: { "levelId": 6, "mem": bit0(0x224997),"good": 1, "addr": 0x224997, "bit": 0},109: { "levelId": 6, "mem": bit1(0x224997),"good": 1, "addr": 0x224997, "bit": 1},110: { "levelId": 6, "mem": bit2(0x224997),"good": 1, "addr": 0x224997, "bit": 2},111: { "levelId": 6, "mem": bit3(0x224997),"good": 1, "addr": 0x224997, "bit": 3},112: { "levelId": 6, "mem": bit4(0x224997),"good": 1, "addr": 0x224997, "bit": 4},113: { "levelId": 6, "mem": bit5(0x224997),"good": 1, "addr": 0x224997, "bit": 5},114: { "levelId": 6, "mem": bit6(0x224997),"good": 1, "addr": 0x224997, "bit": 6},115: { "levelId": 6, "mem": bit7(0x224997),"good": 1, "addr": 0x224997, "bit": 7},116: { "levelId": 6, "mem": bit0(0x224998),"good": 1, "addr": 0x224998, "bit": 0},117: { "levelId": 6, "mem": bit1(0x224998),"good": 1, "addr": 0x224998, "bit": 1},118: { "levelId": 6, "mem": bit2(0x224998),"good": 1, "addr": 0x224998, "bit": 2},119: { "levelId": 6, "mem": bit3(0x224998),"good": 1, "addr": 0x224998, "bit": 3},120: { "levelId": 6, "mem": bit4(0x224998),"good": 1, "addr": 0x224998, "bit": 4},121: { "levelId": 6, "mem": bit5(0x224998),"good": 1, "addr": 0x224998, "bit": 5},122: { "levelId": 6, "mem": bit6(0x224998),"good": 1, "addr": 0x224998, "bit": 6},123: { "levelId": 6, "mem": bit0(0x224999),"good": 1, "addr": 0x224999, "bit": 0},124: { "levelId": 6, "mem": bit1(0x224999),"good": 1, "addr": 0x224999, "bit": 1},125: { "levelId": 6, "mem": bit2(0x224999),"good": 1, "addr": 0x224999, "bit": 2},126: { "levelId": 6, "mem": bit3(0x224999),"good": 1, "addr": 0x224999, "bit": 3},127: { "levelId": 6, "mem": bit4(0x224999),"good": 1, "addr": 0x224999, "bit": 4},128: { "levelId": 6, "mem": bit5(0x224999),"good": 1, "addr": 0x224999, "bit": 5},129: { "levelId": 6, "mem": bit6(0x224999),"good": 1, "addr": 0x224999, "bit": 6},130: { "levelId": 6, "mem": bit7(0x224999),"good": 1, "addr": 0x224999, "bit": 7},131: { "levelId": 6, "mem": bit0(0x22499a),"good": 1, "addr": 0x22499a, "bit": 0},132: { "levelId": 6, "mem": bit1(0x22499a),"good": 1, "addr": 0x22499a, "bit": 1},133: { "levelId": 6, "mem": bit2(0x22499a),"good": 1, "addr": 0x22499a, "bit": 2},134: { "levelId": 6, "mem": bit3(0x22499a),"good": 1, "addr": 0x22499a, "bit": 3},135: { "levelId": 6, "mem": bit4(0x22499a),"good": 1, "addr": 0x22499a, "bit": 4},136: { "levelId": 6, "mem": bit5(0x22499a),"good": 1, "addr": 0x22499a, "bit": 5},137: { "levelId": 1, "mem": bit3(0x224a36),"good": 1, "addr": 0x224a36, "bit": 3},138: { "levelId": 1, "mem": bit4(0x224a36),"good": 1, "addr": 0x224a36, "bit": 4},139: { "levelId": 1, "mem": bit5(0x224a36),"good": 1, "addr": 0x224a36, "bit": 5},140: { "levelId": 1, "mem": bit6(0x224a36),"good": 1, "addr": 0x224a36, "bit": 6},141: { "levelId": 1, "mem": bit7(0x224a36),"good": 1, "addr": 0x224a36, "bit": 7},142: { "levelId": 6, "mem": bit7(0x224998),"good": 1, "addr": 0x224998, "bit": 7},143: { "levelId": 8, "mem": bit3(0x22499b),"good": 1, "addr": 0x22499b, "bit": 3},144: { "levelId": 8, "mem": bit4(0x22499b),"good": 1, "addr": 0x22499b, "bit": 4},145: { "levelId": 8, "mem": bit5(0x22499b),"good": 1, "addr": 0x22499b, "bit": 5},146: { "levelId": 8, "mem": bit5(0x22499c),"good": 1, "addr": 0x22499c, "bit": 5},147: { "levelId": 8, "mem": bit6(0x22499c),"good": 1, "addr": 0x22499c, "bit": 6},148: { "levelId": 8, "mem": bit7(0x22499c),"good": 1, "addr": 0x22499c, "bit": 7},149: { "levelId": 8, "mem": bit0(0x22499d),"good": 1, "addr": 0x22499d, "bit": 0},150: { "levelId": 8, "mem": bit1(0x22499d),"good": 1, "addr": 0x22499d, "bit": 1},151: { "levelId": 8, "mem": bit2(0x22499d),"good": 1, "addr": 0x22499d, "bit": 2},152: { "levelId": 8, "mem": bit3(0x22499d),"good": 1, "addr": 0x22499d, "bit": 3},153: { "levelId": 8, "mem": bit4(0x22499d),"good": 1, "addr": 0x22499d, "bit": 4},154: { "levelId": 8, "mem": bit5(0x22499d),"good": 1, "addr": 0x22499d, "bit": 5},155: { "levelId": 8, "mem": bit6(0x22499d),"good": 1, "addr": 0x22499d, "bit": 6},156: { "levelId": 8, "mem": bit7(0x22499d),"good": 1, "addr": 0x22499d, "bit": 7},157: { "levelId": 8, "mem": bit0(0x22499e),"good": 1, "addr": 0x22499e, "bit": 0},158: { "levelId": 8, "mem": bit1(0x22499e),"good": 1, "addr": 0x22499e, "bit": 1},159: { "levelId": 8, "mem": bit6(0x22499a),"good": 1, "addr": 0x22499a, "bit": 6},160: { "levelId": 8, "mem": bit7(0x22499a),"good": 1, "addr": 0x22499a, "bit": 7},161: { "levelId": 8, "mem": bit0(0x22499b),"good": 1, "addr": 0x22499b, "bit": 0},162: { "levelId": 8, "mem": bit1(0x22499b),"good": 1, "addr": 0x22499b, "bit": 1},163: { "levelId": 8, "mem": bit2(0x22499b),"good": 1, "addr": 0x22499b, "bit": 2},164: { "levelId": 8, "mem": bit6(0x22499b),"good": 1, "addr": 0x22499b, "bit": 6},165: { "levelId": 8, "mem": bit7(0x22499b),"good": 1, "addr": 0x22499b, "bit": 7},166: { "levelId": 8, "mem": bit0(0x22499c),"good": 1, "addr": 0x22499c, "bit": 0},167: { "levelId": 8, "mem": bit1(0x22499c),"good": 1, "addr": 0x22499c, "bit": 1},168: { "levelId": 8, "mem": bit2(0x22499c),"good": 1, "addr": 0x22499c, "bit": 2},169: { "levelId": 8, "mem": bit3(0x22499c),"good": 1, "addr": 0x22499c, "bit": 3},170: { "levelId": 8, "mem": bit4(0x22499c),"good": 1, "addr": 0x22499c, "bit": 4},171: { "levelId": 8, "mem": bit2(0x22499e),"good": 1, "addr": 0x22499e, "bit": 2},172: { "levelId": 8, "mem": bit3(0x22499e),"good": 1, "addr": 0x22499e, "bit": 3},173: { "levelId": 8, "mem": bit4(0x22499e),"good": 1, "addr": 0x22499e, "bit": 4},174: { "levelId": 8, "mem": bit5(0x22499e),"good": 1, "addr": 0x22499e, "bit": 5},175: { "levelId": 8, "mem": bit6(0x22499e),"good": 1, "addr": 0x22499e, "bit": 6},176: { "levelId": 8, "mem": bit7(0x22499e),"good": 1, "addr": 0x22499e, "bit": 7},177: { "levelId": 8, "mem": bit0(0x22499f),"good": 1, "addr": 0x22499f, "bit": 0},178: { "levelId": 8, "mem": bit1(0x22499f),"good": 1, "addr": 0x22499f, "bit": 1},179: { "levelId": 8, "mem": bit2(0x22499f),"good": 1, "addr": 0x22499f, "bit": 2},180: { "levelId": 8, "mem": bit3(0x22499f),"good": 1, "addr": 0x22499f, "bit": 3},181: { "levelId": 8, "mem": bit4(0x22499f),"good": 1, "addr": 0x22499f, "bit": 4},182: { "levelId": 8, "mem": bit5(0x22499f),"good": 1, "addr": 0x22499f, "bit": 5},183: { "levelId": 8, "mem": bit6(0x22499f),"good": 1, "addr": 0x22499f, "bit": 6},184: { "levelId": 8, "mem": bit7(0x22499f),"good": 1, "addr": 0x22499f, "bit": 7},185: { "levelId": 8, "mem": bit0(0x2249a0),"good": 1, "addr": 0x2249a0, "bit": 0},186: { "levelId": 8, "mem": bit1(0x2249a0),"good": 1, "addr": 0x2249a0, "bit": 1},187: { "levelId": 8, "mem": bit2(0x2249a0),"good": 1, "addr": 0x2249a0, "bit": 2},188: { "levelId": 8, "mem": bit3(0x2249a0),"good": 1, "addr": 0x2249a0, "bit": 3},189: { "levelId": 8, "mem": bit4(0x2249a0),"good": 1, "addr": 0x2249a0, "bit": 4},190: { "levelId": 8, "mem": bit5(0x2249a0),"good": 1, "addr": 0x2249a0, "bit": 5},191: { "levelId": 8, "mem": bit6(0x2249a0),"good": 1, "addr": 0x2249a0, "bit": 6},192: { "levelId": 8, "mem": bit7(0x2249a0),"good": 1, "addr": 0x2249a0, "bit": 7},193: { "levelId": 10, "mem": bit0(0x2249a1),"good": 1, "addr": 0x2249a1, "bit": 0},194: { "levelId": 10, "mem": bit1(0x2249a1),"good": 1, "addr": 0x2249a1, "bit": 1},195: { "levelId": 10, "mem": bit2(0x2249a1),"good": 1, "addr": 0x2249a1, "bit": 2},196: { "levelId": 10, "mem": bit3(0x2249a1),"good": 1, "addr": 0x2249a1, "bit": 3},197: { "levelId": 10, "mem": bit4(0x2249a1),"good": 1, "addr": 0x2249a1, "bit": 4},198: { "levelId": 10, "mem": bit2(0x2249a2),"good": 1, "addr": 0x2249a2, "bit": 2},199: { "levelId": 10, "mem": bit3(0x2249a2),"good": 1, "addr": 0x2249a2, "bit": 3},200: { "levelId": 10, "mem": bit4(0x2249a2),"good": 1, "addr": 0x2249a2, "bit": 4},201: { "levelId": 10, "mem": bit5(0x2249a2),"good": 1, "addr": 0x2249a2, "bit": 5},202: { "levelId": 10, "mem": bit6(0x2249a2),"good": 1, "addr": 0x2249a2, "bit": 6},203: { "levelId": 10, "mem": bit1(0x2249a4),"good": 1, "addr": 0x2249a4, "bit": 1},204: { "levelId": 10, "mem": bit5(0x2249a3),"good": 1, "addr": 0x2249a3, "bit": 5},205: { "levelId": 10, "mem": bit6(0x2249a3),"good": 1, "addr": 0x2249a3, "bit": 6},206: { "levelId": 10, "mem": bit7(0x2249a3),"good": 1, "addr": 0x2249a3, "bit": 7},207: { "levelId": 10, "mem": bit0(0x2249a4),"good": 1, "addr": 0x2249a4, "bit": 0},208: { "levelId": 10, "mem": bit3(0x2249a4),"good": 1, "addr": 0x2249a4, "bit": 3},209: { "levelId": 10, "mem": bit5(0x2249a4),"good": 1, "addr": 0x2249a4, "bit": 5},210: { "levelId": 10, "mem": bit6(0x2249a4),"good": 1, "addr": 0x2249a4, "bit": 6},211: { "levelId": 10, "mem": bit7(0x2249a4),"good": 1, "addr": 0x2249a4, "bit": 7},212: { "levelId": 10, "mem": bit0(0x2249a5),"good": 1, "addr": 0x2249a5, "bit": 0},213: { "levelId": 10, "mem": bit1(0x2249a5),"good": 1, "addr": 0x2249a5, "bit": 1},214: { "levelId": 10, "mem": bit2(0x2249a5),"good": 1, "addr": 0x2249a5, "bit": 2},215: { "levelId": 10, "mem": bit4(0x2249a4),"good": 1, "addr": 0x2249a4, "bit": 4},216: { "levelId": 11, "mem": bit6(0x2249e5),"good": 1, "addr": 0x2249e5, "bit": 6},217: { "levelId": 11, "mem": bit7(0x2249e5),"good": 1, "addr": 0x2249e5, "bit": 7},218: { "levelId": 11, "mem": bit0(0x2249e6),"good": 1, "addr": 0x2249e6, "bit": 0},219: { "levelId": 11, "mem": bit1(0x2249e6),"good": 1, "addr": 0x2249e6, "bit": 1},220: { "levelId": 11, "mem": bit2(0x2249e6),"good": 1, "addr": 0x2249e6, "bit": 2},221: { "levelId": 11, "mem": bit3(0x2249e6),"good": 1, "addr": 0x2249e6, "bit": 3},222: { "levelId": 11, "mem": bit4(0x2249e6),"good": 1, "addr": 0x2249e6, "bit": 4},223: { "levelId": 11, "mem": bit5(0x2249e6),"good": 1, "addr": 0x2249e6, "bit": 5},224: { "levelId": 11, "mem": bit6(0x2249e6),"good": 1, "addr": 0x2249e6, "bit": 6},225: { "levelId": 11, "mem": bit7(0x2249e6),"good": 1, "addr": 0x2249e6, "bit": 7},226: { "levelId": 11, "mem": bit0(0x2249e7),"good": 1, "addr": 0x2249e7, "bit": 0},227: { "levelId": 11, "mem": bit1(0x2249e7),"good": 1, "addr": 0x2249e7, "bit": 1},228: { "levelId": 11, "mem": bit2(0x2249e7),"good": 1, "addr": 0x2249e7, "bit": 2},229: { "levelId": 11, "mem": bit3(0x2249e7),"good": 1, "addr": 0x2249e7, "bit": 3},230: { "levelId": 11, "mem": bit4(0x2249e7),"good": 1, "addr": 0x2249e7, "bit": 4},231: { "levelId": 11, "mem": bit5(0x2249e7),"good": 1, "addr": 0x2249e7, "bit": 5},232: { "levelId": 11, "mem": bit6(0x2249e7),"good": 1, "addr": 0x2249e7, "bit": 6},233: { "levelId": 11, "mem": bit7(0x2249e7),"good": 1, "addr": 0x2249e7, "bit": 7},234: { "levelId": 11, "mem": bit0(0x2249e8),"good": 1, "addr": 0x2249e8, "bit": 0},235: { "levelId": 11, "mem": bit1(0x2249e8),"good": 1, "addr": 0x2249e8, "bit": 1},236: { "levelId": 11, "mem": bit2(0x2249e8),"good": 1, "addr": 0x2249e8, "bit": 2},237: { "levelId": 11, "mem": bit3(0x2249e8),"good": 1, "addr": 0x2249e8, "bit": 3},238: { "levelId": 11, "mem": bit4(0x2249e8),"good": 1, "addr": 0x2249e8, "bit": 4},239: { "levelId": 11, "mem": bit5(0x2249e8),"good": 1, "addr": 0x2249e8, "bit": 5},240: { "levelId": 11, "mem": bit6(0x2249e8),"good": 1, "addr": 0x2249e8, "bit": 6},241: { "levelId": 11, "mem": bit7(0x2249e8),"good": 1, "addr": 0x2249e8, "bit": 7},242: { "levelId": 11, "mem": bit0(0x2249e9),"good": 1, "addr": 0x2249e9, "bit": 0},243: { "levelId": 11, "mem": bit1(0x2249e9),"good": 1, "addr": 0x2249e9, "bit": 1},244: { "levelId": 11, "mem": bit2(0x2249e9),"good": 1, "addr": 0x2249e9, "bit": 2},245: { "levelId": 11, "mem": bit3(0x2249e9),"good": 1, "addr": 0x2249e9, "bit": 3},246: { "levelId": 11, "mem": bit4(0x2249e9),"good": 1, "addr": 0x2249e9, "bit": 4},247: { "levelId": 11, "mem": bit5(0x2249e9),"good": 1, "addr": 0x2249e9, "bit": 5},248: { "levelId": 11, "mem": bit6(0x2249e9),"good": 1, "addr": 0x2249e9, "bit": 6},249: { "levelId": 11, "mem": bit7(0x2249e9),"good": 1, "addr": 0x2249e9, "bit": 7},250: { "levelId": 11, "mem": bit0(0x2249ea),"good": 1, "addr": 0x2249ea, "bit": 0},251: { "levelId": 11, "mem": bit1(0x2249ea),"good": 1, "addr": 0x2249ea, "bit": 1},252: { "levelId": 11, "mem": bit2(0x2249ea),"good": 1, "addr": 0x2249ea, "bit": 2},253: { "levelId": 11, "mem": bit3(0x2249ea),"good": 1, "addr": 0x2249ea, "bit": 3},254: { "levelId": 11, "mem": bit4(0x2249ea),"good": 1, "addr": 0x2249ea, "bit": 4},255: { "levelId": 11, "mem": bit5(0x2249ea),"good": 1, "addr": 0x2249ea, "bit": 5},256: { "levelId": 11, "mem": bit6(0x2249ea),"good": 1, "addr": 0x2249ea, "bit": 6},257: { "levelId": 11, "mem": bit7(0x2249ea),"good": 1, "addr": 0x2249ea, "bit": 7},258: { "levelId": 11, "mem": bit0(0x2249eb),"good": 1, "addr": 0x2249eb, "bit": 0},259: { "levelId": 11, "mem": bit1(0x2249eb),"good": 1, "addr": 0x2249eb, "bit": 1},260: { "levelId": 11, "mem": bit2(0x2249eb),"good": 1, "addr": 0x2249eb, "bit": 2},261: { "levelId": 11, "mem": bit3(0x2249eb),"good": 1, "addr": 0x2249eb, "bit": 3},262: { "levelId": 11, "mem": bit4(0x2249eb),"good": 1, "addr": 0x2249eb, "bit": 4},263: { "levelId": 11, "mem": bit5(0x2249eb),"good": 1, "addr": 0x2249eb, "bit": 5},264: { "levelId": 11, "mem": bit6(0x2249eb),"good": 1, "addr": 0x2249eb, "bit": 6},265: { "levelId": 11, "mem": bit7(0x2249eb),"good": 1, "addr": 0x2249eb, "bit": 7},266: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},267: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},268: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},269: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},270: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},271: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},272: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},273: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},274: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},275: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},276: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},277: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},278: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},279: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},280: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},281: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},282: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},283: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},284: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},285: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},286: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},287: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},288: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},289: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},290: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},291: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},292: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},293: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},294: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},295: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},296: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},297: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},298: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},299: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},300: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},301: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},302: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},303: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},304: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},305: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},306: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},307: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},308: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},309: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},310: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},311: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},312: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},313: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},314: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},315: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},316: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},317: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},318: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},319: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},320: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},321: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},322: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},323: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},324: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},325: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},326: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},327: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},328: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},329: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},330: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},331: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},332: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},333: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},334: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},335: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},336: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},337: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},338: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},339: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},340: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},341: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},342: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},343: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},344: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},345: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},346: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},347: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},348: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},349: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},350: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},351: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},352: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},353: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},354: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},355: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},356: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},357: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},358: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},359: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},360: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},361: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},362: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},363: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},364: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},365: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},366: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},367: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},368: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},369: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},370: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},371: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},372: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},373: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},374: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},375: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},376: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},377: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},378: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},379: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},380: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},381: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},382: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},383: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},384: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},385: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},386: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},387: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},388: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},389: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},390: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},391: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},392: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},393: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},394: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},395: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},396: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},397: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},398: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},399: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},400: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},401: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},402: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},403: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},404: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},405: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},406: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},407: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},408: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},409: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},410: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},411: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},412: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},413: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},414: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},415: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},416: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},417: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},418: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},419: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},420: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},421: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},422: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},423: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},424: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},425: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},426: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},427: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},428: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},429: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},430: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},431: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},432: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},433: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},434: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},435: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},436: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},437: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},438: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},439: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},440: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},441: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},442: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},443: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},444: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},445: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},446: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},447: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},448: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},449: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},450: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},451: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},452: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},453: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},454: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},455: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},456: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},457: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},458: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},459: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},460: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},461: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},462: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},463: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},464: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},465: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},466: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},467: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},468: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},469: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},470: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},471: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},472: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},473: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},474: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},475: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},476: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},477: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},478: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},479: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},480: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},481: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},482: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},483: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},484: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},485: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},486: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},487: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},488: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},489: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},490: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},491: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},492: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},493: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},494: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},495: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},496: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},497: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},498: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},499: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},500: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},501: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},502: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},503: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},504: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},505: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},506: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},507: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},508: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},509: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},510: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},511: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},512: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},513: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},514: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},515: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},516: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},517: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},518: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},519: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},520: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},521: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},522: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},523: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},524: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},525: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},526: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},527: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},528: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},529: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},530: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},531: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},532: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},533: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},534: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},535: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},536: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},537: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},538: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},539: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},540: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},541: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},542: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},543: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},544: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},545: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},546: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},547: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},548: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},549: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},550: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},551: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},552: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},553: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},554: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},555: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},556: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},557: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},558: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},559: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},560: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},561: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},562: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},563: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},564: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},565: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},566: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},567: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},568: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},569: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},570: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},571: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},572: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},573: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},574: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},575: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},576: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},577: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},578: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},579: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},580: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},581: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},582: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},583: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},584: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},585: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},586: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},587: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},588: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},589: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},590: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},591: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},592: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},593: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},594: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},595: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},596: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},597: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},598: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},599: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},600: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},601: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},602: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},603: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},604: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},605: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},606: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},607: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},608: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},609: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},610: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},611: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},612: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},613: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},614: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},615: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},616: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},617: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},618: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},619: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},620: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},621: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},622: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},623: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},624: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},625: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},626: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},627: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},628: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},629: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},630: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},631: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},632: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},633: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},634: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},635: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},636: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},637: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},638: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},639: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},640: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},641: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},642: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},643: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},644: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},645: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},646: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},647: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},648: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},649: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},650: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},651: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},652: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},653: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},654: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},655: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},656: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},657: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},658: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},659: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},660: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},661: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},662: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},663: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},664: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},665: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},666: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},667: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},668: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},669: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},670: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},671: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},672: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},673: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},674: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},675: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},676: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},677: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},678: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},679: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},680: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},681: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},682: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},683: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},684: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},685: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},686: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},687: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},688: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},689: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},690: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},691: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},692: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},693: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},694: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},695: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},696: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},697: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},698: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},699: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},700: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},701: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},702: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},703: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},704: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},705: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},706: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},707: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},708: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},709: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},710: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},711: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},712: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},713: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},714: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},715: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},716: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},717: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},718: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},719: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},720: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},721: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},722: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},723: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},724: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},725: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},726: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},727: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},728: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},729: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},730: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},731: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},732: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},733: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},734: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},735: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},736: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},737: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},738: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},739: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},740: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},741: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},742: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},743: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},744: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},745: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},746: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},747: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},748: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},749: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},750: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},751: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},752: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},753: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},754: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},755: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},756: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},757: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},758: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},759: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},760: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},761: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},762: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},763: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},764: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},765: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},766: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},767: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},768: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},769: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},770: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},771: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},772: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},773: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},774: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},775: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},776: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},777: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},778: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},779: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},780: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},781: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},782: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},783: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},784: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},785: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},786: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},787: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},788: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},789: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},790: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},791: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},792: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},793: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},794: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},795: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},796: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},797: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},798: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},799: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},800: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},801: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},802: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},803: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},804: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},805: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},806: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},807: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},808: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},809: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},810: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},811: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},812: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},813: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},814: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},815: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},816: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},817: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},818: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},819: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},820: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},821: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},822: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},823: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},824: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},825: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},826: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},827: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},828: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},829: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},830: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},831: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},832: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},833: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},834: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},835: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},836: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},837: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},838: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},839: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},840: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},841: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},842: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},843: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},844: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},845: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},846: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},847: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},848: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},849: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},850: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},851: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},852: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},853: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},854: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},855: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},856: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},857: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},858: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},859: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},860: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},861: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},862: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},863: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},864: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},865: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},866: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},867: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},868: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},869: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},870: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},871: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},872: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},873: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},874: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},875: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},876: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},877: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},878: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},879: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},880: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},881: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},882: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},883: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},884: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},885: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},886: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},887: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},888: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},889: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},890: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},891: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},892: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},893: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},894: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},895: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},896: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},897: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},898: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},899: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},900: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},901: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},902: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},903: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},904: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},905: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},906: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},907: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},908: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},909: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},910: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},911: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},912: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},913: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},914: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},915: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},916: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},917: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},918: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},919: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},920: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},921: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},922: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},923: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},924: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},925: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},926: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},927: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},928: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},929: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},930: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},931: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},932: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},933: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},934: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},935: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},936: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},937: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},938: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},939: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},940: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},941: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},942: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},943: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},944: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},945: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},946: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},947: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},948: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},949: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},950: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},951: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},952: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},953: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},954: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},955: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},956: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},957: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},958: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},959: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},960: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},961: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},962: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},963: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},964: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},965: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},966: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},967: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},968: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},969: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},970: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},971: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},972: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},973: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},974: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},975: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},976: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},977: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},978: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},979: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},980: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},981: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},982: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},983: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},984: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},985: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},986: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},987: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},988: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},989: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},990: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},991: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},992: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},993: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},994: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},995: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},996: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},997: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},998: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},999: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},1000: { "levelId": 3, "good": 0, "addr": -1, "bit": -1},
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
    1: { "levelId": 1, "mem": bit7(0x2249f0),"good": 1},2: { "levelId": 2, "mem": bit0(0x2249f1),"good": 1},3: { "levelId": 2, "mem": bit1(0x2249f1),"good": 1},4: { "levelId": 2, "mem": bit5(0x2249f1),"good": 1},5: { "levelId": 2, "mem": bit6(0x2249f1),"good": 1},6: { "levelId": 1, "mem": bit7(0x2249f1),"good": 1},7: { "levelId": 5, "mem": bit0(0x2249f2),"good": 1},8: { "levelId": 5, "mem": bit1(0x2249f2),"good": 1},9: { "levelId": 5, "mem": bit2(0x2249f2),"good": 1},10: { "levelId": 5, "mem": bit3(0x2249f2),"good": 1},11: { "levelId": 5, "mem": bit4(0x2249f2),"good": 1},12: { "levelId": 6, "mem": bit5(0x2249f2),"good": 1},13: { "levelId": 6, "mem": bit7(0x2249f2),"good": 1},14: { "levelId": 6, "mem": bit1(0x2249f3),"good": 1},15: { "levelId": 6, "mem": bit6(0x2249f2),"good": 1},16: { "levelId": 6, "mem": bit0(0x2249f3),"good": 1},17: { "levelId": 6, "mem": bit3(0x2249f3),"good": 1},18: { "levelId": 6, "mem": bit2(0x2249f3),"good": 1},19: { "levelId": 8, "mem": bit5(0x2249f3),"good": 1},20: { "levelId": 8, "mem": bit4(0x2249f3),"good": 1},21: { "levelId": 10, "mem": bit0(0x2249f4),"good": 1},22: { "levelId": 10, "mem": bit6(0x2249f3),"good": 1},23: { "levelId": 3, "good": 0},24: { "levelId": 3, "good": 0},25: { "levelId": 3, "good": 0},26: { "levelId": 3, "good": 0},27: { "levelId": 3, "good": 0},28: { "levelId": 3, "good": 0},29: { "levelId": 3, "good": 0},30: { "levelId": 3, "good": 0},31: { "levelId": 3, "good": 0},32: { "levelId": 3, "good": 0},33: { "levelId": 3, "good": 0},34: { "levelId": 3, "good": 0},35: { "levelId": 3, "good": 0},36: { "levelId": 3, "good": 0},37: { "levelId": 3, "good": 0},38: { "levelId": 3, "good": 0},39: { "levelId": 3, "good": 0},40: { "levelId": 3, "good": 0},41: { "levelId": 3, "good": 0},42: { "levelId": 3, "good": 0},43: { "levelId": 3, "good": 0},44: { "levelId": 3, "good": 0},45: { "levelId": 3, "good": 0},46: { "levelId": 3, "good": 0},47: { "levelId": 3, "good": 0},48: { "levelId": 3, "good": 0},49: { "levelId": 3, "good": 0},50: { "levelId": 3, "good": 0},51: { "levelId": 3, "good": 0},52: { "levelId": 3, "good": 0},53: { "levelId": 3, "good": 0},54: { "levelId": 3, "good": 0},55: { "levelId": 3, "good": 0},56: { "levelId": 3, "good": 0},57: { "levelId": 3, "good": 0},58: { "levelId": 3, "good": 0},59: { "levelId": 3, "good": 0},60: { "levelId": 3, "good": 0},61: { "levelId": 3, "good": 0},62: { "levelId": 3, "good": 0},63: { "levelId": 3, "good": 0},64: { "levelId": 3, "good": 0},65: { "levelId": 3, "good": 0},66: { "levelId": 3, "good": 0},67: { "levelId": 3, "good": 0},68: { "levelId": 3, "good": 0},69: { "levelId": 3, "good": 0},70: { "levelId": 3, "good": 0},71: { "levelId": 3, "good": 0},72: { "levelId": 3, "good": 0},73: { "levelId": 3, "good": 0},74: { "levelId": 3, "good": 0},75: { "levelId": 3, "good": 0},76: { "levelId": 3, "good": 0},77: { "levelId": 3, "good": 0},78: { "levelId": 3, "good": 0},79: { "levelId": 3, "good": 0},80: { "levelId": 3, "good": 0},
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
            conditions[i] = GenerateConditionFromBitflag(lum["mem"])
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
0x784BFC: { "id": 0x784BFC, "areaName": "Menu", "displayName": "Main Menu", "levelName": "Menu" },0x789668: { "id": 0x789668, "areaName": "Intro", "displayName": "somewhere in the Glade of Dreams…", "levelName": "None" },0x778C74: { "id": 0x778C74, "areaName": "BuccaneerBrig", "displayName": "in the Buccaneer’s brig", "levelName": "None" },0x78D424: { "id": 0x78D424, "areaName": "WoodsOfLight", "displayName": "in the Woods of Light", "levelName": "Woods of Light" },0x790570: { "id": 0x790570, "areaName": "HallOfDoors", "displayName": "in the Hall of Doors", "levelName": "Hall of Doors" },0x7875A8: { "id": 0x7875A8, "areaName": "FairyGladeArea1", "displayName": "in the Fairy Glade", "levelName": "Fairy Glade" },0x78A320: { "id": 0x78A320, "areaName": "FairyGladeArea2", "displayName": "in the Fairy Glade", "levelName": "Fairy Glade" },0x7A1BD8: { "id": 0x7A1BD8, "areaName": "FairyGladeArea3", "displayName": "in the Fairy Glade", "levelName": "Fairy Glade" },0x77BFFC: { "id": 0x77BFFC, "areaName": "FairyGladeArea4", "displayName": "in the Fairy Glade", "levelName": "Fairy Glade" },0x771B74: { "id": 0x771B74, "areaName": "FairyGladeArea5", "displayName": "in the Fairy Glade", "levelName": "Fairy Glade" },0x74AAA8: { "id": 0x74AAA8, "areaName": "Results", "displayName": "viewing level results…", "levelName": "None" },0x788708: { "id": 0x788708, "areaName": "MarshesArea1", "displayName": "in the Marshes of Awakening", "levelName": "Marshes of Awakening" },0x7786E8: { "id": 0x7786E8, "areaName": "MarshesArea2", "displayName": "in the Marshes of Awakening", "levelName": "Marshes of Awakening" },0x790598: { "id": 0x790598, "areaName": "BayouArea1", "displayName": "in the Bayou", "levelName": "Bayou" },0x788764: { "id": 0x788764, "areaName": "BayouArea2", "displayName": "in the Bayou", "levelName": "Bayou" },0x7928A4: { "id": 0x7928A4, "areaName": "SoWaIArea1", "displayName": "in the Sanctuary of Water and Ice", "levelName": "Sanctuary of Water and Ice" },0x774694: { "id": 0x774694, "areaName": "SoWaIArea2", "displayName": "in the Sanctuary of Water and Ice", "levelName": "Sanctuary of Water and Ice" },0x76F100: { "id": 0x76F100, "areaName": "Polokus", "displayName": "in Polokus’s dream", "levelName": "Polokus" },0x0: { "id": 0x0, "areaName": "None", "displayName": "somewhere in the Glade of Dreams…", "levelName": "None" },0x751974: { "id": 0x751974, "areaName": "Bonus", "displayName": "in the bonus stage", "levelName": "None" },0x776C08: { "id": 0x776C08, "areaName": "MenhirArea1", "displayName": "in the Menhir Hills", "levelName": "Menhir Hills" },0x78FBD8: { "id": 0x78FBD8, "areaName": "MenhirArea2", "displayName": "in the Menhir Hills", "levelName": "Menhir Hills" },0x788950: { "id": 0x788950, "areaName": "MenhirArea3", "displayName": "in the Menhir Hills", "levelName": "Menhir Hills" },0x78402C: { "id": 0x78402C, "areaName": "BadDreamsArea1", "displayName": "in the Cave of Bad Dreams", "levelName": "Cave of Bad Dreams" },0x788148: { "id": 0x788148, "areaName": "BadDreamsArea2", "displayName": "in the Cave of Bad Dreams", "levelName": "Cave of Bad Dreams" },
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

achievement(
    title = "King of Teensies", description = "Meet the... king?", points = 5,
    id = 71511, badge = "165863", published = "2/5/2019 4:38:34 AM", modified = "4/5/2021 3:03:33 PM",
    trigger = prev(word(0x0E5C34)) == 24946 && word(0x0E5C34) == 28781
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
    name = "Freedom for the Forest Dwellers", description = "Find everything in The Fairy Glade.", points = 5,
    id = 54209, badge = "165866",
    conditions = GetConditionsByLevel("Fairy Glade"),
    threshold = GetCollectableTotalsByLevel("Fairy Glade")
)

// todo: document changes in plan
GenerateCheevoFromConditions(
    name = "Skiway Rescue", description = "Find everything in the Marshes of Awakening.", points = 5,
    id = 54210, badge = "165894",
    conditions = GetConditionsByLevel("Marshes of Awakening"),
    threshold = GetCollectableTotalsByLevel("Marshes of Awakening")
)

// todo: document changes in plan
GenerateCheevoFromConditions(name = "Combing the Everglades", description = "Find everything in the Bayou.", points = 5,
    id = 54212, badge = "165895",
    conditions = GetConditionsByLevel("Bayou"),
    threshold = GetCollectableTotalsByLevel("Bayou")
)

achievement(
    title = "I feel alive", description = "Find every lums in \"The Walk of Life\"", points = 5,
    id = 54213, badge = "165896", published = "11/2/2017 7:04:04 PM", modified = "4/5/2021 3:03:46 PM",
    trigger = unless(word(0x0E5C34) != 24369) && word(0x0E5C34) == 24369 && byte(0x22493C) < prev(byte(0x22493C)) && 
              byte(0x22493C) == 0
)

// todo: document changes in plan
GenerateCheevoFromConditions(name = "Colder than Ice", description = "Find everything in the Sanctuary of Water and Ice.", points = 10,
    id = 54215, badge = "165897",
    conditions = GetConditionsByLevel("Sanctuary of Water and Ice"),
    threshold = GetCollectableTotalsByLevel("Sanctuary of Water and Ice")
)

// todo: document changes in plan
achievement(
    title = "Water and Ice", description = "Defeat the Guardian Axel and obtain the Water Mask.", points = 5,
    id = 71513, badge = "165865", published = "2/5/2019 4:38:40 AM", modified = "4/5/2021 3:03:48 PM",
    trigger = CreateHitTargetedAndNextChain([IsInArea("SoWaIArea2"), IsInArea("None"), IsInArea("Polokus")])
        && never(IsInLocation("Hall of Doors"))
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

achievement(
    title = "What the hell are you doing Obelix?!", description = "Find everything in \"The Menhir Hills\"", points = 5,
    id = 54218, badge = "165899", published = "11/2/2017 7:04:44 PM", modified = "4/5/2021 3:03:54 PM",
    trigger = unless(word(0x0E5C34) != 25701) && word(0x0E5C34) == 25701 &&
              ((byte(0x22493C) < prev(byte(0x22493C)) && byte(0x22493C) == 0 && byte(0x2248C8) == 8) ||
               (byte(0x2248C8) > prev(byte(0x2248C8)) && byte(0x2248C8) == 8 && byte(0x22493C) == 0))
)

achievement(
    title = "Globox not afraid", description = "Get the ability to charge", points = 10,
    id = 71516, badge = "165869", published = "2/5/2019 4:38:46 AM", modified = "4/5/2021 3:03:55 PM",
    trigger = never(word(0x0E5C34) != 28514) && never(areaId() != 30916) && never(byte(0x22494E) != 12) && 
              repeated(60, word(0x17691E) == 65483)
)

achievement(
    title = "Rayman VS Wild", description = "Find everything in \"The Canopy\"", points = 5,
    id = 54220, badge = "165900", published = "11/2/2017 7:04:50 PM", modified = "4/5/2021 3:03:56 PM",
    trigger = unless(word(0x0E5C34) != 28514) && word(0x0E5C34) == 28514 &&
              ((byte(0x22493C) < prev(byte(0x22493C)) && byte(0x22493C) == 0 && byte(0x2248C8) == 4) ||
               (byte(0x2248C8) > prev(byte(0x2248C8)) && byte(0x2248C8) == 4 && byte(0x22493C) == 0))
)

achievement(
    title = "Breathing whale farts", description = "Find everything in \"The Whale Bay\"", points = 5,
    id = 54223, badge = "165901", published = "11/2/2017 7:05:12 PM", modified = "4/5/2021 3:03:58 PM",
    trigger = unless(word(0x0E5C34) != 24940) && word(0x0E5C34) == 24940 &&
              ((byte(0x22493C) < prev(byte(0x22493C)) && byte(0x22493C) == 0 && byte(0x2248C8) == 4) ||
               (byte(0x2248C8) > prev(byte(0x2248C8)) && byte(0x2248C8) == 4 && byte(0x22493C) == 0))
)

achievement(
    title = "Harder like Souls", description = "Beat the Guardian Umber and get the second mask", points = 10,
    id = 71517, badge = "165870", published = "2/5/2019 4:38:47 AM", modified = "4/5/2021 3:03:59 PM",
    trigger = prev(word(0x0E5C34)) == 30061 && word(0x0E5C34) == 27759 && byte(0x22494E) == 12
)

achievement(
    title = "The Plump Master", description = "Find everything in \"The Sanctuary of Stone and Fire\"", points = 5,
    id = 54225, badge = "165902", published = "11/2/2017 7:05:27 PM", modified = "4/5/2021 3:04:01 PM",
    trigger = unless(word(0x0E5C34) != 30061) && word(0x0E5C34) == 30061 &&
              ((byte(0x22493C) < prev(byte(0x22493C)) && byte(0x22493C) == 0 && byte(0x2248C8) == 8) ||
               (byte(0x2248C8) > prev(byte(0x2248C8)) && byte(0x2248C8) == 8 && byte(0x22493C) == 0))
)

achievement(
    title = "Do a barrel roll", description = "Find everything in \"The Echoing Caves\"", points = 10,
    id = 54226, badge = "165903", published = "11/2/2017 7:05:31 PM", modified = "4/5/2021 3:04:02 PM",
    trigger = ((byte(0x22493C) < prev(byte(0x22493C)) && byte(0x22493C) == 0 && byte(0x2248C8) == 5 && 
                word(0x0E5C34) == 29547) ||
               (byte(0x2248C8) > prev(byte(0x2248C8)) && byte(0x2248C8) == 5 && byte(0x22493C) == 0 && 
                word(0x0E5C34) == 29547) ||
               (byte(0x22493C) < prev(byte(0x22493C)) && byte(0x22493C) == 0 && byte(0x2248C8) == 5 && 
                word(0x0E5C34) == 29556) ||
               (byte(0x2248C8) > prev(byte(0x2248C8)) && byte(0x2248C8) == 5 && byte(0x22493C) == 0 && 
                word(0x0E5C34) == 29556))
)

achievement(
    title = "Run Forrest run!", description = "Find everything in \"The Precipice\"", points = 5,
    id = 54227, badge = "165904", published = "11/2/2017 7:05:34 PM", modified = "4/5/2021 3:04:03 PM",
    trigger = unless(word(0x0E5C34) != 30309) && word(0x0E5C34) == 30309 &&
              ((byte(0x22493C) < prev(byte(0x22493C)) && byte(0x22493C) == 0 && byte(0x2248C8) == 6) ||
               (byte(0x2248C8) > prev(byte(0x2248C8)) && byte(0x2248C8) == 6 && byte(0x22493C) == 0))
)

achievement(
    title = "Deadly stairlift", description = "Find everything in \"The top of the World\"", points = 5,
    id = 54228, badge = "165905", published = "11/2/2017 7:05:38 PM", modified = "4/5/2021 3:04:04 PM",
    trigger = unless(word(0x0E5C34) != 24948) && word(0x0E5C34) == 24948 &&
              ((byte(0x22493C) < prev(byte(0x22493C)) && byte(0x22493C) == 0 && byte(0x2248C8) == 2) ||
               (byte(0x2248C8) > prev(byte(0x2248C8)) && byte(0x2248C8) == 2 && byte(0x22493C) == 0))
)

achievement(
    title = "Hotter than lava", description = "Find everything in \"The Sanctuary of Rock and Lava\"", points = 5,
    id = 54230, badge = "165906", published = "11/2/2017 7:05:53 PM", modified = "4/5/2021 3:04:05 PM",
    trigger = unless(word(0x0E5C34) != 29300) && word(0x0E5C34) == 29300 &&
              ((byte(0x22493C) < prev(byte(0x22493C)) && byte(0x22493C) == 0 && byte(0x2248C8) == 7) ||
               (byte(0x2248C8) > prev(byte(0x2248C8)) && byte(0x2248C8) == 7 && byte(0x22493C) == 0))
)

achievement(
    title = "Fast and fairies", description = "Find everything in \"The Walk of Power\"", points = 5,
    id = 54231, badge = "165907", published = "11/2/2017 7:05:57 PM", modified = "4/5/2021 3:04:11 PM",
    trigger = unless(word(0x0E5C34) != 24370) && word(0x0E5C34) == 24370 && byte(0x22493C) < prev(byte(0x22493C)) && 
              byte(0x22493C) == 0
)

achievement(
    title = "Rock and Lava", description = "Beat the Guardian Foutch and get the third mask", points = 10,
    id = 71518, badge = "165871", published = "2/5/2019 4:38:49 AM", modified = "4/5/2021 3:04:12 PM",
    trigger = prev(word(0x0E5C34)) == 27753 && word(0x0E5C34) == 27759 && byte(0x22494E) == 12
)

achievement(
    title = "Use your head", description = "Find everything in \"Beneath the Sanctuary of Rock and Lava\"", points = 5,
    id = 54234, badge = "165908", published = "11/2/2017 7:06:18 PM", modified = "4/5/2021 3:04:14 PM",
    trigger = unless(word(0x0E5C34) != 27753) && word(0x0E5C34) == 27753 &&
              ((byte(0x22493C) < prev(byte(0x22493C)) && byte(0x22493C) == 0 && byte(0x2248C8) == 4) ||
               (byte(0x2248C8) > prev(byte(0x2248C8)) && byte(0x2248C8) == 4 && byte(0x22493C) == 0))
)

achievement(
    title = "Uh, oh...", description = "Beat Clark", points = 10,
    id = 71519, badge = "165872", published = "2/5/2019 4:38:50 AM", modified = "4/5/2021 3:04:15 PM",
    trigger = never(word(0x0E5C34) != 29282) && never(areaId() != 30900) && never(byte(0x22494E) != 12) && 
              repeated(100, word(0x17691E) == 34)
)

achievement(
    title = "I'm not afraid (or just a little)", description = "Find everything in \"The Tomb of the Ancients\"", points = 5,
    id = 54236, badge = "165909", published = "11/2/2017 7:06:25 PM", modified = "4/5/2021 3:04:18 PM",
    trigger = unless(word(0x0E5C34) != 29282) && word(0x0E5C34) == 29282 &&
              ((byte(0x22493C) < prev(byte(0x22493C)) && byte(0x22493C) == 0 && byte(0x2248C8) == 6) ||
               (byte(0x2248C8) > prev(byte(0x2248C8)) && byte(0x2248C8) == 6 && byte(0x22493C) == 0))
)

achievement(
    title = "Hi, mama", description = "Save Globox sons and get the last mask", points = 10,
    id = 71520, badge = "165873", published = "2/5/2019 4:38:52 AM", modified = "4/5/2021 3:04:19 PM",
    trigger = never(word(0x0E5C34) != 28261) && never(areaId() != 31136) && never(byte(0x22494E) != 12) && 
              repeated(100, word(0x17691E) == 65528)
)

achievement(
    title = "Globox... why so many babies?!", description = "Find everything in \"The Iron Mountains\"", points = 5,
    id = 54238, badge = "165910", published = "11/2/2017 7:06:33 PM", modified = "4/5/2021 3:04:21 PM",
    trigger = unless(word(0x0E5C34) != 28261) && word(0x0E5C34) == 28261 &&
              ((byte(0x22493C) < prev(byte(0x22493C)) && byte(0x22493C) == 0 && byte(0x2248C8) == 3) ||
               (byte(0x2248C8) > prev(byte(0x2248C8)) && byte(0x2248C8) == 3 && byte(0x22493C) == 0))
)

achievement(
    title = "That's a great escape", description = "Beat Razorbeard", points = 25,
    id = 71521, badge = "165874", published = "2/5/2019 4:38:53 AM", modified = "4/5/2021 3:04:26 PM",
    trigger = prev(word(0x0E5C34)) == 28528 && word(0x0E5C34) == 25695 && byte(0x22494E) == 12
)

achievement(
    title = "Eating Screws", description = "Find everything in \"The Prison Ship\"", points = 5,
    id = 71959, badge = "165911", published = "2/14/2019 12:42:31 AM", modified = "4/5/2021 3:04:38 PM",
    trigger = byte(0x22493C) < prev(byte(0x22493C)) && byte(0x22493C) == 0 &&
              ((word(0x0E5C34) == 24948) ||
               (word(0x0E5C34) == 29810))
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

achievement(
    title = "Thanks for playing", description = "Get the 1000th lum", points = 25,
    id = 71540, badge = "165893", published = "2/5/2019 4:39:26 AM", modified = "4/5/2021 3:05:50 PM",
    trigger = word(0x0E5C34) == 29282 && areaId() == 31242 && byte(0x7A08E6) == 43
)

achievement(
    title = "You and how many more?", description = "Beat the Sanctuary of Stone and Fire without losing the Golden Fists", points = 10,
    id = 71960, badge = "165892", published = "2/14/2019 11:54:54 PM", modified = "4/5/2021 3:05:28 PM",
    trigger = prev(word(0x0E5C34)) == 30061 && word(0x0E5C34) == 31075 && byte(0x0C8CA1) == 1
)

achievement(
    title = "Thanks, navi", description = "Beat the Bonus Stage", points = 10,
    id = 71530, badge = "165883", published = "2/5/2019 4:39:09 AM", modified = "4/5/2021 3:05:32 PM",
    trigger = word(0x0E5C34) == 28277 && areaId() == 29977 && byte(0x0EF5BB) == 65
)

function bonusRaceTimer() => word(0x74e2f2)
achievement(
    title = "Faster than daddy", description = "Beat the Bonus stage in 21s 77ms or less", points = 10,
    id = 71531, badge = "165884", published = "2/5/2019 4:39:11 AM", modified = "4/5/2021 3:05:33 PM",
    trigger = unless(word(0x0E5C34) != 28277) && unless(areaId() != 29977) && once(word(0x74CEE8) == 52136) && 
              never(word(0x176940) == 64213) && never(word(0x74E2F2) > 1085) && word(0x74CEE8) == 52424
)

achievement(
    title = "That was very fast!", description = "Beat the Walk of Life at 01 45 98ms or less", points = 25,
    id = 71532, badge = "165885", published = "2/5/2019 4:39:12 AM", modified = "4/5/2021 3:05:36 PM",
    trigger = word(0x0E5C34) == 24369 && areaId() == 30905 && byte(0x0C9470) == 2 && dword(0x5E9AC0) <= 1204748416
)

achievement(
    title = "Make a good hero", description = "Beat the Walk of Power at 01 35 23ms or less", points = 25,
    id = 71533, badge = "165886", published = "2/5/2019 4:39:14 AM", modified = "4/5/2021 3:05:37 PM",
    trigger = word(0x0E5C34) == 24370 && areaId() == 30717 && byte(0x0C9470) == 2 && dword(0x5ECF34) <= 1203372032
)

achievement(
    title = "Rayman the handyman", description = "At the Echoing Caves open the main door in 1m37s or less", points = 10,
    id = 71534, badge = "165887", published = "2/5/2019 4:39:15 AM", modified = "4/5/2021 3:05:38 PM",
    trigger = never(byte(0x22494E) == 12) && word(0x0E5C34) == 29556 && areaId() == 30920 &&
              (always_false() || (unless(byte(0x22493B) == 1) && unless(repeated(5820, word(0x0E5C34) == 29556)) && 
                word(0x21A288) == 17580))
)

achievement(
    title = "Think of the Children", description = "In Iron Mountains, save Globox's children from the Reformatory for Disturbing Children.", points = 10,
    id = 71535, badge = "165888", published = "2/5/2019 4:39:17 AM", modified = "4/21/2021 4:00:12 PM",
    trigger = word(0x0E5C34) == 25951 && areaId() == 30727 && byte(0x77AB93) == 8 && byte(0x77B44B) == 8
)

achievement(
    title = "Wasn't like my childhood", description = "At the final fight spawn the blue orb", points = 10,
    id = 71536, badge = "165889", published = "2/5/2019 4:39:19 AM", modified = "4/5/2021 3:05:42 PM",
    trigger = byte(0x22494E) != 12 && word(0x0E5C34) == 28528 && areaId() == 31153 && byte(0x5F01BF) == 1
)

achievement(
    title = "Mini shootem up", description = "Play some Menezis", points = 10,
    id = 71538, badge = "165891", published = "2/5/2019 4:39:23 AM", modified = "4/5/2021 3:05:47 PM",
    trigger = word(0x0E5C34) == 24934 && areaId() == 30767 && word(0x17691E) == 65492
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

achievement(
    title = "Still the best in the arcade", description = "In a Menezis minigame score 250 points ", points = 20,
    id = 71539, badge = "76569", published = "2/5/2019 4:39:24 AM", modified = "2/5/2019 4:40:24 AM",
    trigger = word(0x0E5C34) == 24934 && areaId() == 30767 &&
              ((word(0x78863C) == 250) ||
               (word(0x787F6C) == 250) ||
               (word(0x7871CC) == 250))
)

achievement(
    title = "Ski challenge", description = "Complete the ski part without pressing the jump or turbo button", points = 25,
    id = 54211, badge = "55942", published = "11/2/2017 7:03:57 PM", modified = "11/3/2017 11:30:32 AM",
    trigger = once(byte(0x1768B4) == 236) && once(byte(0x1768B4) == 76) && once(byte(0x1768B4) == 108) && 
              never(byte(0x5D4C62) == 23) && never(byte(0x5D4C62) == 25) && byte(0x1768B4) == 236 && once(word(0x22495C) == 46312) && 
              once(word(0x22495E) == 50066) && once(word(0x224960) == 11328) && never(word(0x22495C) == 33776)
)


function lum1000Consumed() => bit0(0x224a11)

function TotalLums()
{
    return 1000 - lum1000Consumed()
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
