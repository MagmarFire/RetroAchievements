// Rayman 2: The Great Escape (E)
// #ID = 10269

function Delta(mem) => prev(mem)

// $0C6DF9: Area ID (24-bit)
function areaId() => tbyte(0x0C6DF8)

function loadedSaveSlot() => byte(0x0ea27c)

function IsLoadingSaveFile() => Delta(loadedSaveSlot()) != loadedSaveSlot()

function IsInGame() => loadedSaveSlot() > 0 && loadedSaveSlot() < 4

function IsAlwaysInGame() => never(loadedSaveSlot() == 0 || loadedSaveSlot() > 3 || IsLoadingSaveFile())

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
        array_push(loadedCounts, once(condition["countsWhen"] && IsLoadingSaveFile()))

        // We want both loaded and session counts here (that is, we don't care if we're loading a save file when these are tallied).
        // This way, loading a save doesn't invalidate the achievement outright if a player hasn't actually earned it yet.
        array_push(totalCounts, once(condition["countsWhen"]))

        resetAlt = resetAlt || condition["recalculateWhen"]
    }

    achievement(title = name, description = description, points = points, badge = badge, id = id,
        trigger = IsInGame() &&
            measured(tally(threshold, totalCounts)) && unless(tally(threshold, loadedCounts))
            && never(resetAlt) && onlyAvailableWhen && (always_false() || IsAlwaysInGame())
    )
}

function GenerateConditionFromBitflag(bit)
{
    return { "countsWhen": (bit == 1), "recalculateWhen": (Delta(bit) != bit) }
}

lums = {
1: { "levelId": 2, "mem": bit0(0x224988),"good": 1},2: { "levelId": 2, "mem": bit1(0x224988),"good": 1},3: { "levelId": 2, "mem": bit2(0x224988),"good": 1},4: { "levelId": 2, "mem": bit3(0x224988),"good": 1},5: { "levelId": 2, "mem": bit4(0x224988),"good": 1},6: { "levelId": 2, "mem": bit5(0x224988),"good": 1},7: { "levelId": 2, "mem": bit6(0x224988),"good": 1},8: { "levelId": 2, "mem": bit7(0x224988),"good": 1},9: { "levelId": 2, "mem": bit2(0x224989),"good": 1},10: { "levelId": 2, "mem": bit1(0x22498a),"good": 1},11: { "levelId": 2, "mem": bit2(0x22498a),"good": 1},12: { "levelId": 2, "mem": bit3(0x22498a),"good": 1},13: { "levelId": 2, "mem": bit4(0x22498a),"good": 1},14: { "levelId": 2, "mem": bit5(0x22498a),"good": 1},15: { "levelId": 2, "mem": bit6(0x22498a),"good": 1},16: { "levelId": 2, "mem": bit7(0x22498a),"good": 1},17: { "levelId": 2, "mem": bit5(0x22498b),"good": 1},18: { "levelId": 2, "mem": bit6(0x22498b),"good": 1},19: { "levelId": 2, "mem": bit7(0x22498b),"good": 1},20: { "levelId": 2, "mem": bit0(0x22498c),"good": 1},21: { "levelId": 2, "mem": bit1(0x22498c),"good": 1},22: { "levelId": 2, "mem": bit2(0x22498c),"good": 1},23: { "levelId": 2, "mem": bit3(0x22498c),"good": 1},24: { "levelId": 2, "mem": bit4(0x22498c),"good": 1},25: { "levelId": 2, "mem": bit5(0x22498c),"good": 1},26: { "levelId": 2, "mem": bit6(0x22498c),"good": 1},27: { "levelId": 2, "mem": bit7(0x22498c),"good": 1},28: { "levelId": 2, "mem": bit0(0x22498d),"good": 1},29: { "levelId": 2, "mem": bit1(0x22498d),"good": 1},30: { "levelId": 2, "mem": bit2(0x22498d),"good": 1},31: { "levelId": 2, "mem": bit3(0x22498d),"good": 1},32: { "levelId": 2, "mem": bit4(0x22498d),"good": 1},33: { "levelId": 2, "mem": bit5(0x22498d),"good": 1},34: { "levelId": 2, "mem": bit6(0x22498d),"good": 1},35: { "levelId": 2, "mem": bit7(0x22498d),"good": 1},36: { "levelId": 2, "mem": bit0(0x22498e),"good": 1},37: { "levelId": 2, "mem": bit1(0x22498e),"good": 1},38: { "levelId": 5, "mem": bit2(0x22498e),"good": 1},39: { "levelId": 5, "mem": bit3(0x22498e),"good": 1},40: { "levelId": 5, "mem": bit4(0x22498e),"good": 1},41: { "levelId": 5, "mem": bit5(0x22498e),"good": 1},42: { "levelId": 5, "mem": bit6(0x22498e),"good": 1},43: { "levelId": 5, "mem": bit7(0x22498e),"good": 1},44: { "levelId": 5, "mem": bit0(0x22498f),"good": 1},45: { "levelId": 5, "mem": bit1(0x22498f),"good": 1},46: { "levelId": 5, "mem": bit2(0x22498f),"good": 1},47: { "levelId": 5, "mem": bit3(0x22498f),"good": 1},48: { "levelId": 5, "mem": bit4(0x22498f),"good": 1},49: { "levelId": 5, "mem": bit5(0x22498f),"good": 1},50: { "levelId": 5, "mem": bit6(0x22498f),"good": 1},51: { "levelId": 5, "mem": bit7(0x22498f),"good": 1},52: { "levelId": 5, "mem": bit0(0x224990),"good": 1},53: { "levelId": 5, "mem": bit1(0x224990),"good": 1},54: { "levelId": 5, "mem": bit2(0x224990),"good": 1},55: { "levelId": 5, "mem": bit3(0x224990),"good": 1},56: { "levelId": 5, "mem": bit4(0x224990),"good": 1},57: { "levelId": 5, "mem": bit5(0x224990),"good": 1},58: { "levelId": 5, "mem": bit6(0x224990),"good": 1},59: { "levelId": 5, "mem": bit7(0x224990),"good": 1},60: { "levelId": 5, "mem": bit0(0x224991),"good": 1},61: { "levelId": 5, "mem": bit1(0x224991),"good": 1},62: { "levelId": 5, "mem": bit2(0x224991),"good": 1},63: { "levelId": 5, "mem": bit3(0x224991),"good": 1},64: { "levelId": 5, "mem": bit4(0x224991),"good": 1},65: { "levelId": 5, "mem": bit5(0x224991),"good": 1},66: { "levelId": 5, "mem": bit6(0x224991),"good": 1},67: { "levelId": 5, "mem": bit7(0x224991),"good": 1},68: { "levelId": 5, "mem": bit0(0x224992),"good": 1},69: { "levelId": 5, "mem": bit1(0x224992),"good": 1},70: { "levelId": 5, "mem": bit2(0x224992),"good": 1},71: { "levelId": 5, "mem": bit3(0x224992),"good": 1},72: { "levelId": 5, "mem": bit4(0x224992),"good": 1},73: { "levelId": 5, "mem": bit5(0x224992),"good": 1},74: { "levelId": 5, "mem": bit6(0x224992),"good": 1},75: { "levelId": 5, "mem": bit7(0x224992),"good": 1},76: { "levelId": 5, "mem": bit0(0x224993),"good": 1},77: { "levelId": 5, "mem": bit1(0x224993),"good": 1},78: { "levelId": 5, "mem": bit2(0x224993),"good": 1},79: { "levelId": 5, "mem": bit3(0x224993),"good": 1},80: { "levelId": 5, "mem": bit4(0x224993),"good": 1},81: { "levelId": 5, "mem": bit5(0x224993),"good": 1},82: { "levelId": 5, "mem": bit6(0x224993),"good": 1},83: { "levelId": 5, "mem": bit7(0x224993),"good": 1},84: { "levelId": 5, "mem": bit0(0x224994),"good": 1},85: { "levelId": 5, "mem": bit1(0x224994),"good": 1},86: { "levelId": 5, "mem": bit2(0x224994),"good": 1},87: { "levelId": 5, "mem": bit3(0x224994),"good": 1},88: { "levelId": 1, "mem": bit3(0x224a36),"good": 1},89: { "levelId": 1, "mem": bit4(0x224a36),"good": 1},90: { "levelId": 1, "mem": bit5(0x224a36),"good": 1},91: { "levelId": 1, "mem": bit6(0x224a36),"good": 1},92: { "levelId": 1, "mem": bit7(0x224a36),"good": 1},93: { "levelId": 6, "mem": bit1(0x224997),"good": 1},94: { "levelId": 6, "mem": bit2(0x224997),"good": 1},95: { "levelId": 6, "mem": bit4(0x224994),"good": 1},96: { "levelId": 6, "mem": bit5(0x224994),"good": 1},97: { "levelId": 6, "mem": bit6(0x224994),"good": 1},98: { "levelId": 6, "mem": bit7(0x224996),"good": 1},99: { "levelId": 6, "mem": bit0(0x224997),"good": 1},100: { "levelId": 6, "mem": bit7(0x224997),"good": 1},101: { "levelId": 6, "mem": bit0(0x224998),"good": 1},102: { "levelId": 6, "mem": bit1(0x224998),"good": 1},103: { "levelId": 6, "mem": bit2(0x224998),"good": 1},104: { "levelId": 3, "good": 0},105: { "levelId": 3, "good": 0},106: { "levelId": 3, "good": 0},107: { "levelId": 3, "good": 0},108: { "levelId": 3, "good": 0},109: { "levelId": 3, "good": 0},110: { "levelId": 3, "good": 0},111: { "levelId": 3, "good": 0},112: { "levelId": 3, "good": 0},113: { "levelId": 3, "good": 0},114: { "levelId": 3, "good": 0},115: { "levelId": 3, "good": 0},116: { "levelId": 3, "good": 0},117: { "levelId": 3, "good": 0},118: { "levelId": 3, "good": 0},119: { "levelId": 3, "good": 0},120: { "levelId": 3, "good": 0},121: { "levelId": 3, "good": 0},122: { "levelId": 3, "good": 0},123: { "levelId": 3, "good": 0},124: { "levelId": 3, "good": 0},125: { "levelId": 3, "good": 0},126: { "levelId": 3, "good": 0},127: { "levelId": 3, "good": 0},128: { "levelId": 3, "good": 0},129: { "levelId": 3, "good": 0},130: { "levelId": 3, "good": 0},131: { "levelId": 3, "good": 0},132: { "levelId": 3, "good": 0},133: { "levelId": 3, "good": 0},134: { "levelId": 3, "good": 0},135: { "levelId": 3, "good": 0},136: { "levelId": 3, "good": 0},137: { "levelId": 3, "good": 0},138: { "levelId": 3, "good": 0},139: { "levelId": 3, "good": 0},140: { "levelId": 3, "good": 0},141: { "levelId": 3, "good": 0},142: { "levelId": 3, "good": 0},143: { "levelId": 3, "good": 0},144: { "levelId": 3, "good": 0},145: { "levelId": 3, "good": 0},146: { "levelId": 3, "good": 0},147: { "levelId": 3, "good": 0},148: { "levelId": 3, "good": 0},149: { "levelId": 3, "good": 0},150: { "levelId": 3, "good": 0},151: { "levelId": 3, "good": 0},152: { "levelId": 3, "good": 0},153: { "levelId": 3, "good": 0},154: { "levelId": 3, "good": 0},155: { "levelId": 3, "good": 0},156: { "levelId": 3, "good": 0},157: { "levelId": 3, "good": 0},158: { "levelId": 3, "good": 0},159: { "levelId": 3, "good": 0},160: { "levelId": 3, "good": 0},161: { "levelId": 3, "good": 0},162: { "levelId": 3, "good": 0},163: { "levelId": 3, "good": 0},164: { "levelId": 3, "good": 0},165: { "levelId": 3, "good": 0},166: { "levelId": 3, "good": 0},167: { "levelId": 3, "good": 0},168: { "levelId": 3, "good": 0},169: { "levelId": 3, "good": 0},170: { "levelId": 3, "good": 0},171: { "levelId": 3, "good": 0},172: { "levelId": 3, "good": 0},173: { "levelId": 3, "good": 0},174: { "levelId": 3, "good": 0},175: { "levelId": 3, "good": 0},176: { "levelId": 3, "good": 0},177: { "levelId": 3, "good": 0},178: { "levelId": 3, "good": 0},179: { "levelId": 3, "good": 0},180: { "levelId": 3, "good": 0},181: { "levelId": 3, "good": 0},182: { "levelId": 3, "good": 0},183: { "levelId": 3, "good": 0},184: { "levelId": 3, "good": 0},185: { "levelId": 3, "good": 0},186: { "levelId": 3, "good": 0},187: { "levelId": 3, "good": 0},188: { "levelId": 3, "good": 0},189: { "levelId": 3, "good": 0},190: { "levelId": 3, "good": 0},191: { "levelId": 3, "good": 0},192: { "levelId": 3, "good": 0},193: { "levelId": 3, "good": 0},194: { "levelId": 3, "good": 0},195: { "levelId": 3, "good": 0},196: { "levelId": 3, "good": 0},197: { "levelId": 3, "good": 0},198: { "levelId": 3, "good": 0},199: { "levelId": 3, "good": 0},200: { "levelId": 3, "good": 0},201: { "levelId": 3, "good": 0},202: { "levelId": 3, "good": 0},203: { "levelId": 3, "good": 0},204: { "levelId": 3, "good": 0},205: { "levelId": 3, "good": 0},206: { "levelId": 3, "good": 0},207: { "levelId": 3, "good": 0},208: { "levelId": 3, "good": 0},209: { "levelId": 3, "good": 0},210: { "levelId": 3, "good": 0},211: { "levelId": 3, "good": 0},212: { "levelId": 3, "good": 0},213: { "levelId": 3, "good": 0},214: { "levelId": 3, "good": 0},215: { "levelId": 3, "good": 0},216: { "levelId": 3, "good": 0},217: { "levelId": 3, "good": 0},218: { "levelId": 3, "good": 0},219: { "levelId": 3, "good": 0},220: { "levelId": 3, "good": 0},221: { "levelId": 3, "good": 0},222: { "levelId": 3, "good": 0},223: { "levelId": 3, "good": 0},224: { "levelId": 3, "good": 0},225: { "levelId": 3, "good": 0},226: { "levelId": 3, "good": 0},227: { "levelId": 3, "good": 0},228: { "levelId": 3, "good": 0},229: { "levelId": 3, "good": 0},230: { "levelId": 3, "good": 0},231: { "levelId": 3, "good": 0},232: { "levelId": 3, "good": 0},233: { "levelId": 3, "good": 0},234: { "levelId": 3, "good": 0},235: { "levelId": 3, "good": 0},236: { "levelId": 3, "good": 0},237: { "levelId": 3, "good": 0},238: { "levelId": 3, "good": 0},239: { "levelId": 3, "good": 0},240: { "levelId": 3, "good": 0},241: { "levelId": 3, "good": 0},242: { "levelId": 3, "good": 0},243: { "levelId": 3, "good": 0},244: { "levelId": 3, "good": 0},245: { "levelId": 3, "good": 0},246: { "levelId": 3, "good": 0},247: { "levelId": 3, "good": 0},248: { "levelId": 3, "good": 0},249: { "levelId": 3, "good": 0},250: { "levelId": 3, "good": 0},251: { "levelId": 3, "good": 0},252: { "levelId": 3, "good": 0},253: { "levelId": 3, "good": 0},254: { "levelId": 3, "good": 0},255: { "levelId": 3, "good": 0},256: { "levelId": 3, "good": 0},257: { "levelId": 3, "good": 0},258: { "levelId": 3, "good": 0},259: { "levelId": 3, "good": 0},260: { "levelId": 3, "good": 0},261: { "levelId": 3, "good": 0},262: { "levelId": 3, "good": 0},263: { "levelId": 3, "good": 0},264: { "levelId": 3, "good": 0},265: { "levelId": 3, "good": 0},266: { "levelId": 3, "good": 0},267: { "levelId": 3, "good": 0},268: { "levelId": 3, "good": 0},269: { "levelId": 3, "good": 0},270: { "levelId": 3, "good": 0},271: { "levelId": 3, "good": 0},272: { "levelId": 3, "good": 0},273: { "levelId": 3, "good": 0},274: { "levelId": 3, "good": 0},275: { "levelId": 3, "good": 0},276: { "levelId": 3, "good": 0},277: { "levelId": 3, "good": 0},278: { "levelId": 3, "good": 0},279: { "levelId": 3, "good": 0},280: { "levelId": 3, "good": 0},281: { "levelId": 3, "good": 0},282: { "levelId": 3, "good": 0},283: { "levelId": 3, "good": 0},284: { "levelId": 3, "good": 0},285: { "levelId": 3, "good": 0},286: { "levelId": 3, "good": 0},287: { "levelId": 3, "good": 0},288: { "levelId": 3, "good": 0},289: { "levelId": 3, "good": 0},290: { "levelId": 3, "good": 0},291: { "levelId": 3, "good": 0},292: { "levelId": 3, "good": 0},293: { "levelId": 3, "good": 0},294: { "levelId": 3, "good": 0},295: { "levelId": 3, "good": 0},296: { "levelId": 3, "good": 0},297: { "levelId": 3, "good": 0},298: { "levelId": 3, "good": 0},299: { "levelId": 3, "good": 0},300: { "levelId": 3, "good": 0},301: { "levelId": 3, "good": 0},302: { "levelId": 3, "good": 0},303: { "levelId": 3, "good": 0},304: { "levelId": 3, "good": 0},305: { "levelId": 3, "good": 0},306: { "levelId": 3, "good": 0},307: { "levelId": 3, "good": 0},308: { "levelId": 3, "good": 0},309: { "levelId": 3, "good": 0},310: { "levelId": 3, "good": 0},311: { "levelId": 3, "good": 0},312: { "levelId": 3, "good": 0},313: { "levelId": 3, "good": 0},314: { "levelId": 3, "good": 0},315: { "levelId": 3, "good": 0},316: { "levelId": 3, "good": 0},317: { "levelId": 3, "good": 0},318: { "levelId": 3, "good": 0},319: { "levelId": 3, "good": 0},320: { "levelId": 3, "good": 0},321: { "levelId": 3, "good": 0},322: { "levelId": 3, "good": 0},323: { "levelId": 3, "good": 0},324: { "levelId": 3, "good": 0},325: { "levelId": 3, "good": 0},326: { "levelId": 3, "good": 0},327: { "levelId": 3, "good": 0},328: { "levelId": 3, "good": 0},329: { "levelId": 3, "good": 0},330: { "levelId": 3, "good": 0},331: { "levelId": 3, "good": 0},332: { "levelId": 3, "good": 0},333: { "levelId": 3, "good": 0},334: { "levelId": 3, "good": 0},335: { "levelId": 3, "good": 0},336: { "levelId": 3, "good": 0},337: { "levelId": 3, "good": 0},338: { "levelId": 3, "good": 0},339: { "levelId": 3, "good": 0},340: { "levelId": 3, "good": 0},341: { "levelId": 3, "good": 0},342: { "levelId": 3, "good": 0},343: { "levelId": 3, "good": 0},344: { "levelId": 3, "good": 0},345: { "levelId": 3, "good": 0},346: { "levelId": 3, "good": 0},347: { "levelId": 3, "good": 0},348: { "levelId": 3, "good": 0},349: { "levelId": 3, "good": 0},350: { "levelId": 3, "good": 0},351: { "levelId": 3, "good": 0},352: { "levelId": 3, "good": 0},353: { "levelId": 3, "good": 0},354: { "levelId": 3, "good": 0},355: { "levelId": 3, "good": 0},356: { "levelId": 3, "good": 0},357: { "levelId": 3, "good": 0},358: { "levelId": 3, "good": 0},359: { "levelId": 3, "good": 0},360: { "levelId": 3, "good": 0},361: { "levelId": 3, "good": 0},362: { "levelId": 3, "good": 0},363: { "levelId": 3, "good": 0},364: { "levelId": 3, "good": 0},365: { "levelId": 3, "good": 0},366: { "levelId": 3, "good": 0},367: { "levelId": 3, "good": 0},368: { "levelId": 3, "good": 0},369: { "levelId": 3, "good": 0},370: { "levelId": 3, "good": 0},371: { "levelId": 3, "good": 0},372: { "levelId": 3, "good": 0},373: { "levelId": 3, "good": 0},374: { "levelId": 3, "good": 0},375: { "levelId": 3, "good": 0},376: { "levelId": 3, "good": 0},377: { "levelId": 3, "good": 0},378: { "levelId": 3, "good": 0},379: { "levelId": 3, "good": 0},380: { "levelId": 3, "good": 0},381: { "levelId": 3, "good": 0},382: { "levelId": 3, "good": 0},383: { "levelId": 3, "good": 0},384: { "levelId": 3, "good": 0},385: { "levelId": 3, "good": 0},386: { "levelId": 3, "good": 0},387: { "levelId": 3, "good": 0},388: { "levelId": 3, "good": 0},389: { "levelId": 3, "good": 0},390: { "levelId": 3, "good": 0},391: { "levelId": 3, "good": 0},392: { "levelId": 3, "good": 0},393: { "levelId": 3, "good": 0},394: { "levelId": 3, "good": 0},395: { "levelId": 3, "good": 0},396: { "levelId": 3, "good": 0},397: { "levelId": 3, "good": 0},398: { "levelId": 3, "good": 0},399: { "levelId": 3, "good": 0},400: { "levelId": 3, "good": 0},401: { "levelId": 3, "good": 0},402: { "levelId": 3, "good": 0},403: { "levelId": 3, "good": 0},404: { "levelId": 3, "good": 0},405: { "levelId": 3, "good": 0},406: { "levelId": 3, "good": 0},407: { "levelId": 3, "good": 0},408: { "levelId": 3, "good": 0},409: { "levelId": 3, "good": 0},410: { "levelId": 3, "good": 0},411: { "levelId": 3, "good": 0},412: { "levelId": 3, "good": 0},413: { "levelId": 3, "good": 0},414: { "levelId": 3, "good": 0},415: { "levelId": 3, "good": 0},416: { "levelId": 3, "good": 0},417: { "levelId": 3, "good": 0},418: { "levelId": 3, "good": 0},419: { "levelId": 3, "good": 0},420: { "levelId": 3, "good": 0},421: { "levelId": 3, "good": 0},422: { "levelId": 3, "good": 0},423: { "levelId": 3, "good": 0},424: { "levelId": 3, "good": 0},425: { "levelId": 3, "good": 0},426: { "levelId": 3, "good": 0},427: { "levelId": 3, "good": 0},428: { "levelId": 3, "good": 0},429: { "levelId": 3, "good": 0},430: { "levelId": 3, "good": 0},431: { "levelId": 3, "good": 0},432: { "levelId": 3, "good": 0},433: { "levelId": 3, "good": 0},434: { "levelId": 3, "good": 0},435: { "levelId": 3, "good": 0},436: { "levelId": 3, "good": 0},437: { "levelId": 3, "good": 0},438: { "levelId": 3, "good": 0},439: { "levelId": 3, "good": 0},440: { "levelId": 3, "good": 0},441: { "levelId": 3, "good": 0},442: { "levelId": 3, "good": 0},443: { "levelId": 3, "good": 0},444: { "levelId": 3, "good": 0},445: { "levelId": 3, "good": 0},446: { "levelId": 3, "good": 0},447: { "levelId": 3, "good": 0},448: { "levelId": 3, "good": 0},449: { "levelId": 3, "good": 0},450: { "levelId": 3, "good": 0},451: { "levelId": 3, "good": 0},452: { "levelId": 3, "good": 0},453: { "levelId": 3, "good": 0},454: { "levelId": 3, "good": 0},455: { "levelId": 3, "good": 0},456: { "levelId": 3, "good": 0},457: { "levelId": 3, "good": 0},458: { "levelId": 3, "good": 0},459: { "levelId": 3, "good": 0},460: { "levelId": 3, "good": 0},461: { "levelId": 3, "good": 0},462: { "levelId": 3, "good": 0},463: { "levelId": 3, "good": 0},464: { "levelId": 3, "good": 0},465: { "levelId": 3, "good": 0},466: { "levelId": 3, "good": 0},467: { "levelId": 3, "good": 0},468: { "levelId": 3, "good": 0},469: { "levelId": 3, "good": 0},470: { "levelId": 3, "good": 0},471: { "levelId": 3, "good": 0},472: { "levelId": 3, "good": 0},473: { "levelId": 3, "good": 0},474: { "levelId": 3, "good": 0},475: { "levelId": 3, "good": 0},476: { "levelId": 3, "good": 0},477: { "levelId": 3, "good": 0},478: { "levelId": 3, "good": 0},479: { "levelId": 3, "good": 0},480: { "levelId": 3, "good": 0},481: { "levelId": 3, "good": 0},482: { "levelId": 3, "good": 0},483: { "levelId": 3, "good": 0},484: { "levelId": 3, "good": 0},485: { "levelId": 3, "good": 0},486: { "levelId": 3, "good": 0},487: { "levelId": 3, "good": 0},488: { "levelId": 3, "good": 0},489: { "levelId": 3, "good": 0},490: { "levelId": 3, "good": 0},491: { "levelId": 3, "good": 0},492: { "levelId": 3, "good": 0},493: { "levelId": 3, "good": 0},494: { "levelId": 3, "good": 0},495: { "levelId": 3, "good": 0},496: { "levelId": 3, "good": 0},497: { "levelId": 3, "good": 0},498: { "levelId": 3, "good": 0},499: { "levelId": 3, "good": 0},500: { "levelId": 3, "good": 0},501: { "levelId": 3, "good": 0},502: { "levelId": 3, "good": 0},503: { "levelId": 3, "good": 0},504: { "levelId": 3, "good": 0},505: { "levelId": 3, "good": 0},506: { "levelId": 3, "good": 0},507: { "levelId": 3, "good": 0},508: { "levelId": 3, "good": 0},509: { "levelId": 3, "good": 0},510: { "levelId": 3, "good": 0},511: { "levelId": 3, "good": 0},512: { "levelId": 3, "good": 0},513: { "levelId": 3, "good": 0},514: { "levelId": 3, "good": 0},515: { "levelId": 3, "good": 0},516: { "levelId": 3, "good": 0},517: { "levelId": 3, "good": 0},518: { "levelId": 3, "good": 0},519: { "levelId": 3, "good": 0},520: { "levelId": 3, "good": 0},521: { "levelId": 3, "good": 0},522: { "levelId": 3, "good": 0},523: { "levelId": 3, "good": 0},524: { "levelId": 3, "good": 0},525: { "levelId": 3, "good": 0},526: { "levelId": 3, "good": 0},527: { "levelId": 3, "good": 0},528: { "levelId": 3, "good": 0},529: { "levelId": 3, "good": 0},530: { "levelId": 3, "good": 0},531: { "levelId": 3, "good": 0},532: { "levelId": 3, "good": 0},533: { "levelId": 3, "good": 0},534: { "levelId": 3, "good": 0},535: { "levelId": 3, "good": 0},536: { "levelId": 3, "good": 0},537: { "levelId": 3, "good": 0},538: { "levelId": 3, "good": 0},539: { "levelId": 3, "good": 0},540: { "levelId": 3, "good": 0},541: { "levelId": 3, "good": 0},542: { "levelId": 3, "good": 0},543: { "levelId": 3, "good": 0},544: { "levelId": 3, "good": 0},545: { "levelId": 3, "good": 0},546: { "levelId": 3, "good": 0},547: { "levelId": 3, "good": 0},548: { "levelId": 3, "good": 0},549: { "levelId": 3, "good": 0},550: { "levelId": 3, "good": 0},551: { "levelId": 3, "good": 0},552: { "levelId": 3, "good": 0},553: { "levelId": 3, "good": 0},554: { "levelId": 3, "good": 0},555: { "levelId": 3, "good": 0},556: { "levelId": 3, "good": 0},557: { "levelId": 3, "good": 0},558: { "levelId": 3, "good": 0},559: { "levelId": 3, "good": 0},560: { "levelId": 3, "good": 0},561: { "levelId": 3, "good": 0},562: { "levelId": 3, "good": 0},563: { "levelId": 3, "good": 0},564: { "levelId": 3, "good": 0},565: { "levelId": 3, "good": 0},566: { "levelId": 3, "good": 0},567: { "levelId": 3, "good": 0},568: { "levelId": 3, "good": 0},569: { "levelId": 3, "good": 0},570: { "levelId": 3, "good": 0},571: { "levelId": 3, "good": 0},572: { "levelId": 3, "good": 0},573: { "levelId": 3, "good": 0},574: { "levelId": 3, "good": 0},575: { "levelId": 3, "good": 0},576: { "levelId": 3, "good": 0},577: { "levelId": 3, "good": 0},578: { "levelId": 3, "good": 0},579: { "levelId": 3, "good": 0},580: { "levelId": 3, "good": 0},581: { "levelId": 3, "good": 0},582: { "levelId": 3, "good": 0},583: { "levelId": 3, "good": 0},584: { "levelId": 3, "good": 0},585: { "levelId": 3, "good": 0},586: { "levelId": 3, "good": 0},587: { "levelId": 3, "good": 0},588: { "levelId": 3, "good": 0},589: { "levelId": 3, "good": 0},590: { "levelId": 3, "good": 0},591: { "levelId": 3, "good": 0},592: { "levelId": 3, "good": 0},593: { "levelId": 3, "good": 0},594: { "levelId": 3, "good": 0},595: { "levelId": 3, "good": 0},596: { "levelId": 3, "good": 0},597: { "levelId": 3, "good": 0},598: { "levelId": 3, "good": 0},599: { "levelId": 3, "good": 0},600: { "levelId": 3, "good": 0},601: { "levelId": 3, "good": 0},602: { "levelId": 3, "good": 0},603: { "levelId": 3, "good": 0},604: { "levelId": 3, "good": 0},605: { "levelId": 3, "good": 0},606: { "levelId": 3, "good": 0},607: { "levelId": 3, "good": 0},608: { "levelId": 3, "good": 0},609: { "levelId": 3, "good": 0},610: { "levelId": 3, "good": 0},611: { "levelId": 3, "good": 0},612: { "levelId": 3, "good": 0},613: { "levelId": 3, "good": 0},614: { "levelId": 3, "good": 0},615: { "levelId": 3, "good": 0},616: { "levelId": 3, "good": 0},617: { "levelId": 3, "good": 0},618: { "levelId": 3, "good": 0},619: { "levelId": 3, "good": 0},620: { "levelId": 3, "good": 0},621: { "levelId": 3, "good": 0},622: { "levelId": 3, "good": 0},623: { "levelId": 3, "good": 0},624: { "levelId": 3, "good": 0},625: { "levelId": 3, "good": 0},626: { "levelId": 3, "good": 0},627: { "levelId": 3, "good": 0},628: { "levelId": 3, "good": 0},629: { "levelId": 3, "good": 0},630: { "levelId": 3, "good": 0},631: { "levelId": 3, "good": 0},632: { "levelId": 3, "good": 0},633: { "levelId": 3, "good": 0},634: { "levelId": 3, "good": 0},635: { "levelId": 3, "good": 0},636: { "levelId": 3, "good": 0},637: { "levelId": 3, "good": 0},638: { "levelId": 3, "good": 0},639: { "levelId": 3, "good": 0},640: { "levelId": 3, "good": 0},641: { "levelId": 3, "good": 0},642: { "levelId": 3, "good": 0},643: { "levelId": 3, "good": 0},644: { "levelId": 3, "good": 0},645: { "levelId": 3, "good": 0},646: { "levelId": 3, "good": 0},647: { "levelId": 3, "good": 0},648: { "levelId": 3, "good": 0},649: { "levelId": 3, "good": 0},650: { "levelId": 3, "good": 0},651: { "levelId": 3, "good": 0},652: { "levelId": 3, "good": 0},653: { "levelId": 3, "good": 0},654: { "levelId": 3, "good": 0},655: { "levelId": 3, "good": 0},656: { "levelId": 3, "good": 0},657: { "levelId": 3, "good": 0},658: { "levelId": 3, "good": 0},659: { "levelId": 3, "good": 0},660: { "levelId": 3, "good": 0},661: { "levelId": 3, "good": 0},662: { "levelId": 3, "good": 0},663: { "levelId": 3, "good": 0},664: { "levelId": 3, "good": 0},665: { "levelId": 3, "good": 0},666: { "levelId": 3, "good": 0},667: { "levelId": 3, "good": 0},668: { "levelId": 3, "good": 0},669: { "levelId": 3, "good": 0},670: { "levelId": 3, "good": 0},671: { "levelId": 3, "good": 0},672: { "levelId": 3, "good": 0},673: { "levelId": 3, "good": 0},674: { "levelId": 3, "good": 0},675: { "levelId": 3, "good": 0},676: { "levelId": 3, "good": 0},677: { "levelId": 3, "good": 0},678: { "levelId": 3, "good": 0},679: { "levelId": 3, "good": 0},680: { "levelId": 3, "good": 0},681: { "levelId": 3, "good": 0},682: { "levelId": 3, "good": 0},683: { "levelId": 3, "good": 0},684: { "levelId": 3, "good": 0},685: { "levelId": 3, "good": 0},686: { "levelId": 3, "good": 0},687: { "levelId": 3, "good": 0},688: { "levelId": 3, "good": 0},689: { "levelId": 3, "good": 0},690: { "levelId": 3, "good": 0},691: { "levelId": 3, "good": 0},692: { "levelId": 3, "good": 0},693: { "levelId": 3, "good": 0},694: { "levelId": 3, "good": 0},695: { "levelId": 3, "good": 0},696: { "levelId": 3, "good": 0},697: { "levelId": 3, "good": 0},698: { "levelId": 3, "good": 0},699: { "levelId": 3, "good": 0},700: { "levelId": 3, "good": 0},701: { "levelId": 3, "good": 0},702: { "levelId": 3, "good": 0},703: { "levelId": 3, "good": 0},704: { "levelId": 3, "good": 0},705: { "levelId": 3, "good": 0},706: { "levelId": 3, "good": 0},707: { "levelId": 3, "good": 0},708: { "levelId": 3, "good": 0},709: { "levelId": 3, "good": 0},710: { "levelId": 3, "good": 0},711: { "levelId": 3, "good": 0},712: { "levelId": 3, "good": 0},713: { "levelId": 3, "good": 0},714: { "levelId": 3, "good": 0},715: { "levelId": 3, "good": 0},716: { "levelId": 3, "good": 0},717: { "levelId": 3, "good": 0},718: { "levelId": 3, "good": 0},719: { "levelId": 3, "good": 0},720: { "levelId": 3, "good": 0},721: { "levelId": 3, "good": 0},722: { "levelId": 3, "good": 0},723: { "levelId": 3, "good": 0},724: { "levelId": 3, "good": 0},725: { "levelId": 3, "good": 0},726: { "levelId": 3, "good": 0},727: { "levelId": 3, "good": 0},728: { "levelId": 3, "good": 0},729: { "levelId": 3, "good": 0},730: { "levelId": 3, "good": 0},731: { "levelId": 3, "good": 0},732: { "levelId": 3, "good": 0},733: { "levelId": 3, "good": 0},734: { "levelId": 3, "good": 0},735: { "levelId": 3, "good": 0},736: { "levelId": 3, "good": 0},737: { "levelId": 3, "good": 0},738: { "levelId": 3, "good": 0},739: { "levelId": 3, "good": 0},740: { "levelId": 3, "good": 0},741: { "levelId": 3, "good": 0},742: { "levelId": 3, "good": 0},743: { "levelId": 3, "good": 0},744: { "levelId": 3, "good": 0},745: { "levelId": 3, "good": 0},746: { "levelId": 3, "good": 0},747: { "levelId": 3, "good": 0},748: { "levelId": 3, "good": 0},749: { "levelId": 3, "good": 0},750: { "levelId": 3, "good": 0},751: { "levelId": 3, "good": 0},752: { "levelId": 3, "good": 0},753: { "levelId": 3, "good": 0},754: { "levelId": 3, "good": 0},755: { "levelId": 3, "good": 0},756: { "levelId": 3, "good": 0},757: { "levelId": 3, "good": 0},758: { "levelId": 3, "good": 0},759: { "levelId": 3, "good": 0},760: { "levelId": 3, "good": 0},761: { "levelId": 3, "good": 0},762: { "levelId": 3, "good": 0},763: { "levelId": 3, "good": 0},764: { "levelId": 3, "good": 0},765: { "levelId": 3, "good": 0},766: { "levelId": 3, "good": 0},767: { "levelId": 3, "good": 0},768: { "levelId": 3, "good": 0},769: { "levelId": 3, "good": 0},770: { "levelId": 3, "good": 0},771: { "levelId": 3, "good": 0},772: { "levelId": 3, "good": 0},773: { "levelId": 3, "good": 0},774: { "levelId": 3, "good": 0},775: { "levelId": 3, "good": 0},776: { "levelId": 3, "good": 0},777: { "levelId": 3, "good": 0},778: { "levelId": 3, "good": 0},779: { "levelId": 3, "good": 0},780: { "levelId": 3, "good": 0},781: { "levelId": 3, "good": 0},782: { "levelId": 3, "good": 0},783: { "levelId": 3, "good": 0},784: { "levelId": 3, "good": 0},785: { "levelId": 3, "good": 0},786: { "levelId": 3, "good": 0},787: { "levelId": 3, "good": 0},788: { "levelId": 3, "good": 0},789: { "levelId": 3, "good": 0},790: { "levelId": 3, "good": 0},791: { "levelId": 3, "good": 0},792: { "levelId": 3, "good": 0},793: { "levelId": 3, "good": 0},794: { "levelId": 3, "good": 0},795: { "levelId": 3, "good": 0},796: { "levelId": 3, "good": 0},797: { "levelId": 3, "good": 0},798: { "levelId": 3, "good": 0},799: { "levelId": 3, "good": 0},800: { "levelId": 3, "good": 0},801: { "levelId": 3, "good": 0},802: { "levelId": 3, "good": 0},803: { "levelId": 3, "good": 0},804: { "levelId": 3, "good": 0},805: { "levelId": 3, "good": 0},806: { "levelId": 3, "good": 0},807: { "levelId": 3, "good": 0},808: { "levelId": 3, "good": 0},809: { "levelId": 3, "good": 0},810: { "levelId": 3, "good": 0},811: { "levelId": 3, "good": 0},812: { "levelId": 3, "good": 0},813: { "levelId": 3, "good": 0},814: { "levelId": 3, "good": 0},815: { "levelId": 3, "good": 0},816: { "levelId": 3, "good": 0},817: { "levelId": 3, "good": 0},818: { "levelId": 3, "good": 0},819: { "levelId": 3, "good": 0},820: { "levelId": 3, "good": 0},821: { "levelId": 3, "good": 0},822: { "levelId": 3, "good": 0},823: { "levelId": 3, "good": 0},824: { "levelId": 3, "good": 0},825: { "levelId": 3, "good": 0},826: { "levelId": 3, "good": 0},827: { "levelId": 3, "good": 0},828: { "levelId": 3, "good": 0},829: { "levelId": 3, "good": 0},830: { "levelId": 3, "good": 0},831: { "levelId": 3, "good": 0},832: { "levelId": 3, "good": 0},833: { "levelId": 3, "good": 0},834: { "levelId": 3, "good": 0},835: { "levelId": 3, "good": 0},836: { "levelId": 3, "good": 0},837: { "levelId": 3, "good": 0},838: { "levelId": 3, "good": 0},839: { "levelId": 3, "good": 0},840: { "levelId": 3, "good": 0},841: { "levelId": 3, "good": 0},842: { "levelId": 3, "good": 0},843: { "levelId": 3, "good": 0},844: { "levelId": 3, "good": 0},845: { "levelId": 3, "good": 0},846: { "levelId": 3, "good": 0},847: { "levelId": 3, "good": 0},848: { "levelId": 3, "good": 0},849: { "levelId": 3, "good": 0},850: { "levelId": 3, "good": 0},851: { "levelId": 3, "good": 0},852: { "levelId": 3, "good": 0},853: { "levelId": 3, "good": 0},854: { "levelId": 3, "good": 0},855: { "levelId": 3, "good": 0},856: { "levelId": 3, "good": 0},857: { "levelId": 3, "good": 0},858: { "levelId": 3, "good": 0},859: { "levelId": 3, "good": 0},860: { "levelId": 3, "good": 0},861: { "levelId": 3, "good": 0},862: { "levelId": 3, "good": 0},863: { "levelId": 3, "good": 0},864: { "levelId": 3, "good": 0},865: { "levelId": 3, "good": 0},866: { "levelId": 3, "good": 0},867: { "levelId": 3, "good": 0},868: { "levelId": 3, "good": 0},869: { "levelId": 3, "good": 0},870: { "levelId": 3, "good": 0},871: { "levelId": 3, "good": 0},872: { "levelId": 3, "good": 0},873: { "levelId": 3, "good": 0},874: { "levelId": 3, "good": 0},875: { "levelId": 3, "good": 0},876: { "levelId": 3, "good": 0},877: { "levelId": 3, "good": 0},878: { "levelId": 3, "good": 0},879: { "levelId": 3, "good": 0},880: { "levelId": 3, "good": 0},881: { "levelId": 3, "good": 0},882: { "levelId": 3, "good": 0},883: { "levelId": 3, "good": 0},884: { "levelId": 3, "good": 0},885: { "levelId": 3, "good": 0},886: { "levelId": 3, "good": 0},887: { "levelId": 3, "good": 0},888: { "levelId": 3, "good": 0},889: { "levelId": 3, "good": 0},890: { "levelId": 3, "good": 0},891: { "levelId": 3, "good": 0},892: { "levelId": 3, "good": 0},893: { "levelId": 3, "good": 0},894: { "levelId": 3, "good": 0},895: { "levelId": 3, "good": 0},896: { "levelId": 3, "good": 0},897: { "levelId": 3, "good": 0},898: { "levelId": 3, "good": 0},899: { "levelId": 3, "good": 0},900: { "levelId": 3, "good": 0},901: { "levelId": 3, "good": 0},902: { "levelId": 3, "good": 0},903: { "levelId": 3, "good": 0},904: { "levelId": 3, "good": 0},905: { "levelId": 3, "good": 0},906: { "levelId": 3, "good": 0},907: { "levelId": 3, "good": 0},908: { "levelId": 3, "good": 0},909: { "levelId": 3, "good": 0},910: { "levelId": 3, "good": 0},911: { "levelId": 3, "good": 0},912: { "levelId": 3, "good": 0},913: { "levelId": 3, "good": 0},914: { "levelId": 3, "good": 0},915: { "levelId": 3, "good": 0},916: { "levelId": 3, "good": 0},917: { "levelId": 3, "good": 0},918: { "levelId": 3, "good": 0},919: { "levelId": 3, "good": 0},920: { "levelId": 3, "good": 0},921: { "levelId": 3, "good": 0},922: { "levelId": 3, "good": 0},923: { "levelId": 3, "good": 0},924: { "levelId": 3, "good": 0},925: { "levelId": 3, "good": 0},926: { "levelId": 3, "good": 0},927: { "levelId": 3, "good": 0},928: { "levelId": 3, "good": 0},929: { "levelId": 3, "good": 0},930: { "levelId": 3, "good": 0},931: { "levelId": 3, "good": 0},932: { "levelId": 3, "good": 0},933: { "levelId": 3, "good": 0},934: { "levelId": 3, "good": 0},935: { "levelId": 3, "good": 0},936: { "levelId": 3, "good": 0},937: { "levelId": 3, "good": 0},938: { "levelId": 3, "good": 0},939: { "levelId": 3, "good": 0},940: { "levelId": 3, "good": 0},941: { "levelId": 3, "good": 0},942: { "levelId": 3, "good": 0},943: { "levelId": 3, "good": 0},944: { "levelId": 3, "good": 0},945: { "levelId": 3, "good": 0},946: { "levelId": 3, "good": 0},947: { "levelId": 3, "good": 0},948: { "levelId": 3, "good": 0},949: { "levelId": 3, "good": 0},950: { "levelId": 3, "good": 0},951: { "levelId": 3, "good": 0},952: { "levelId": 3, "good": 0},953: { "levelId": 3, "good": 0},954: { "levelId": 3, "good": 0},955: { "levelId": 3, "good": 0},956: { "levelId": 3, "good": 0},957: { "levelId": 3, "good": 0},958: { "levelId": 3, "good": 0},959: { "levelId": 3, "good": 0},960: { "levelId": 3, "good": 0},961: { "levelId": 3, "good": 0},962: { "levelId": 3, "good": 0},963: { "levelId": 3, "good": 0},964: { "levelId": 3, "good": 0},965: { "levelId": 3, "good": 0},966: { "levelId": 3, "good": 0},967: { "levelId": 3, "good": 0},968: { "levelId": 3, "good": 0},969: { "levelId": 3, "good": 0},970: { "levelId": 3, "good": 0},971: { "levelId": 3, "good": 0},972: { "levelId": 3, "good": 0},973: { "levelId": 3, "good": 0},974: { "levelId": 3, "good": 0},975: { "levelId": 3, "good": 0},976: { "levelId": 3, "good": 0},977: { "levelId": 3, "good": 0},978: { "levelId": 3, "good": 0},979: { "levelId": 3, "good": 0},980: { "levelId": 3, "good": 0},981: { "levelId": 3, "good": 0},982: { "levelId": 3, "good": 0},983: { "levelId": 3, "good": 0},984: { "levelId": 3, "good": 0},985: { "levelId": 3, "good": 0},986: { "levelId": 3, "good": 0},987: { "levelId": 3, "good": 0},988: { "levelId": 3, "good": 0},989: { "levelId": 3, "good": 0},990: { "levelId": 3, "good": 0},991: { "levelId": 3, "good": 0},992: { "levelId": 3, "good": 0},993: { "levelId": 3, "good": 0},994: { "levelId": 3, "good": 0},995: { "levelId": 3, "good": 0},996: { "levelId": 3, "good": 0},997: { "levelId": 3, "good": 0},998: { "levelId": 3, "good": 0},999: { "levelId": 3, "good": 0},1000: { "levelId": 3, "good": 0},

}

lumConditions = {}
lumsFound = 0

for i in lums
{
    lum = lums[i]
    
    if (lum["good"] == 1)
    {
        lumConditions[i] = GenerateConditionFromBitflag(lum["mem"])
        lumsFound = lumsFound + lum["mem"]
    }
}

areas = {
0x784BFC: { "id": 0x784BFC, "areaName": "Menu", "displayName": "Main Menu", "levelName": "Menu" },0x789668: { "id": 0x789668, "areaName": "Intro", "displayName": "somewhere in the Glade of Dreams…", "levelName": "None" },0x778C74: { "id": 0x778C74, "areaName": "BuccaneerBrig", "displayName": "in the Buccaneer’s brig", "levelName": "None" },0x78D424: { "id": 0x78D424, "areaName": "WoodsOfLight", "displayName": "in the Woods of Light", "levelName": "Woods of Light" },0x790570: { "id": 0x790570, "areaName": "HallOfDoors", "displayName": "in the Hall of Doors", "levelName": "Hall of Doors" },0x7875A8: { "id": 0x7875A8, "areaName": "FairyGladeArea1", "displayName": "in the Fairy Glade", "levelName": "Fairy Glade" },0x78A320: { "id": 0x78A320, "areaName": "FairyGladeArea2", "displayName": "in the Fairy Glade", "levelName": "Fairy Glade" },0x7A1BD8: { "id": 0x7A1BD8, "areaName": "FairyGladeArea3", "displayName": "in the Fairy Glade", "levelName": "Fairy Glade" },0x77BFFC: { "id": 0x77BFFC, "areaName": "FairyGladeArea4", "displayName": "in the Fairy Glade", "levelName": "Fairy Glade" },0x771B74: { "id": 0x771B74, "areaName": "FairyGladeArea5", "displayName": "in the Fairy Glade", "levelName": "Fairy Glade" },0x74AAA8: { "id": 0x74AAA8, "areaName": "Results", "displayName": "viewing level results…", "levelName": "None" },0x788708: { "id": 0x788708, "areaName": "MarshesArea1", "displayName": "in the Marshes of Awakening", "levelName": "Marshes of Awakening" },0x7786E8: { "id": 0x7786E8, "areaName": "MarshesArea2", "displayName": "in the Marshes of Awakening", "levelName": "Marshes of Awakening" },0x790598: { "id": 0x790598, "areaName": "BayouArea1", "displayName": "in the Bayou", "levelName": "Bayou" },

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

achievement(
    title = "King of Teensies", description = "Meet the... king?", points = 5,
    id = 71511, badge = "165863", published = "2/5/2019 4:38:34 AM", modified = "4/5/2021 3:03:33 PM",
    trigger = prev(word(0x0E5C34)) == 24946 && word(0x0E5C34) == 28781
)

// todo: document changes in plan
function canGrabPurpleLums() => bit6(0x224a10)
achievement(
    title = "The Gift of Swing", description = "Obtain the power to swing.", points = 5,
    id = 71512, badge = "165864", published = "2/5/2019 4:38:38 AM", modified = "4/5/2021 3:03:35 PM",
    trigger = WasBitflagSetInGame(canGrabPurpleLums())
)

achievement(
    title = "Sorry Rayman our missing lums are in another level", description = "Find everything in \"The Fairy Glade\"", points = 5,
    id = 54209, badge = "165866", published = "11/2/2017 7:03:50 PM", modified = "4/5/2021 3:03:40 PM",
    trigger = unless(word(0x0E5C34) != 24946) && word(0x0E5C34) == 24946 &&
              ((byte(0x2248C8) == 7 && prev(byte(0x22493C)) == 1 && byte(0x22493C) == 0) ||
               (byte(0x22493C) == 0 && prev(byte(0x2248C8)) == 6 && byte(0x2248C8) == 7))
)

achievement(
    title = "SSSSO easy", description = "Find everything in \"The Marshes of Awakening\"", points = 5,
    id = 54210, badge = "165894", published = "11/2/2017 7:03:54 PM", modified = "4/5/2021 3:03:42 PM",
    trigger = unless(word(0x0E5C34) != 26975) && word(0x0E5C34) == 26975 &&
              ((byte(0x22493C) < prev(byte(0x22493C)) && byte(0x22493C) == 0 && byte(0x2248C8) == 5) ||
               (byte(0x2248C8) > prev(byte(0x2248C8)) && byte(0x2248C8) == 5 && byte(0x22493C) == 0))
)

achievement(
    title = "Easier than Bayou Billy", description = "Find everything in \"The Bayou\"", points = 5,
    id = 54212, badge = "165895", published = "11/2/2017 7:04:01 PM", modified = "4/5/2021 3:03:44 PM",
    trigger = unless(word(0x0E5C34) != 24947) && word(0x0E5C34) == 24947 &&
              ((byte(0x22493C) < prev(byte(0x22493C)) && byte(0x22493C) == 0 && byte(0x2248C8) == 7) ||
               (prev(byte(0x2248C8)) > 2246856 && byte(0x2248C8) == 7 && byte(0x22493C) == 0))
)

achievement(
    title = "I feel alive", description = "Find every lums in \"The Walk of Life\"", points = 5,
    id = 54213, badge = "165896", published = "11/2/2017 7:04:04 PM", modified = "4/5/2021 3:03:46 PM",
    trigger = unless(word(0x0E5C34) != 24369) && word(0x0E5C34) == 24369 && byte(0x22493C) < prev(byte(0x22493C)) && 
              byte(0x22493C) == 0
)

achievement(
    title = "Colder than ice", description = "Find everything in \"The Sanctuary of Water and Ice\"", points = 5,
    id = 54215, badge = "165897", published = "11/2/2017 7:04:34 PM", modified = "4/5/2021 3:03:47 PM",
    trigger = unless(word(0x0E5C34) != 29797) && word(0x0E5C34) == 29797 &&
              ((byte(0x22493C) < prev(byte(0x22493C)) && byte(0x22493C) == 0 && byte(0x2248C8) == 2) ||
               (byte(0x2248C8) > prev(byte(0x2248C8)) && byte(0x2248C8) == 2 && byte(0x22493C) == 0))
)

achievement(
    title = "Water and Ice", description = "Beat the Guardian Axel and get the first mask", points = 10,
    id = 71513, badge = "165865", published = "2/5/2019 4:38:40 AM", modified = "4/5/2021 3:03:48 PM",
    trigger = prev(word(0x0E5C34)) == 29797 && word(0x0E5C34) == 27759 && byte(0x22494E) == 12
)

achievement(
    title = "Game over", description = "Give me money", points = 5,
    id = 71514, badge = "165867", published = "2/5/2019 4:38:42 AM", modified = "4/5/2021 3:03:50 PM",
    trigger = never(word(0x0E5C34) != 27747) && never(areaId() != 30849) && never(byte(0x22494E) != 12) && 
              repeated(200, word(0x17691E) == 65516)
)

achievement(
    title = "You deserve this!", description = "Get the Elixir of Life", points = 10,
    id = 71515, badge = "165868", published = "2/5/2019 4:38:44 AM", modified = "4/5/2021 3:03:51 PM",
    trigger = unless(byte(0x0E6911) == 1) && unless(byte(0x22494E) != 12) && never(word(0x0E5C34) == 28781) && 
              prev(word(0x0E5C34)) == 27747 && word(0x0E5C34) == 26975
)

achievement(
    title = "The dream master", description = "Find everything in \"The Cave of Bad Dreams\"", points = 5,
    id = 54217, badge = "165898", published = "11/2/2017 7:04:40 PM", modified = "4/5/2021 3:03:52 PM",
    trigger = unless(word(0x0E5C34) != 27747) && unless(byte(0x22494E) == 12) && word(0x0E5C34) == 27747 && 
              byte(0x22493C) < prev(byte(0x22493C)) && byte(0x22493C) == 0
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
GenerateCheevoFromConditions(name = "Naive Hero", description = "Find 100 Lums.", points = 3, id = 71522, badge = "165875",
    conditions = lumConditions, threshold = 100
)

// todo: document changes in plan
GenerateCheevoFromConditions(name = "Novice Hero", description = "Find 250 Lums.", points = 5, id = 71523, badge = "165876",
    conditions = lumConditions, threshold = 250
)

// todo: document changes in plan
GenerateCheevoFromConditions(name = "Enlightened Hero", description = "Find 500 Lums.", points = 10, id = 71524, badge = "165877",
    conditions = lumConditions, threshold = 500
)

// todo: document changes in plan
GenerateCheevoFromConditions(name = "Wise Hero", description = "Find 750 Lums.", points = 25, id = 71525, badge = "165878",
    conditions = lumConditions, threshold = 750
)

// todo: document changes in plan
GenerateCheevoFromConditions(name = "Omniscient Hero", description = "Find 999 Lums.", points = 50, id = 71526, badge = "165879",
    conditions = lumConditions, threshold = 999
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
    title = "No fairy can beat me !", description = "Beat race under 01 37 00 in the walk of power", points = 15,
    id = 54232, badge = "55960", published = "11/2/2017 7:06:10 PM", modified = "11/4/2017 8:00:13 PM",
    trigger = byte(0x008000) == 0 && byte(0x5ECF37) <= 71 && byte(0x5ECF36) <= 189 && byte(0x1768B4) == 172 && 
              word(0x1FA780) == 44312
)

achievement(
    title = "Eating screws", description = "Find every lums and prisoners in the level \"The prison ship\"", points = 10,
    id = 54243, badge = "55951", published = "11/2/2017 7:07:13 PM", modified = "11/4/2017 1:47:13 PM",
    trigger = byte(0x224A2B) == 255 && byte(0x224A2C) == 255 && byte(0x224A2D) == 255 && byte(0x224A2E) == 255 && 
              byte(0x224A2F) == 255 && byte(0x224A30) == 255 && byte(0x224A31) == 255 && byte(0x224A32) == 255 && byte(0x224A33) == 255 && 
              byte(0x224A34) == 255 && byte(0x224A35) == 255 && byte(0x224A36) == 255
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

achievement(
    title = "Ho-Ly shit !", description = "Beat the race under a time of 01 45 00 in the walk of life", points = 15,
    id = 54214, badge = "55943", published = "11/2/2017 7:04:07 PM", modified = "11/4/2017 7:59:42 PM",
    trigger = byte(0x5E9AC2) <= 205 && byte(0x5E9AC3) <= 71 && byte(0x5E9AC2) != 0 && byte(0x1768B4) == 172 && 
              word(0x1FA780) == 44312 && word(0x22495C) == 51792
)

achievement(
    title = "Faster than daddy !", description = "Win the bonus race in the canopy", points = 3,
    id = 54221, badge = "55964", published = "11/2/2017 7:05:04 PM", modified = "11/2/2017 7:28:36 PM",
    trigger = byte(0x1768B4) == 236 && byte(0x22495C) == 57316 && byte(0x0E14BC) == 91 && byte(0x0E14BD) == 41 && 
              byte(0x0E14BE) == 12
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
