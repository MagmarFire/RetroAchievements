// Rayman 2: The Great Escape (E)
// #ID = 10269

function Delta(mem) => prev(mem)

// $0C6DF9: Area ID (32-bit)
function areaId() => dword(0x0C6DF9)

function loadedSaveSlot() => byte(0x0ea27c)

function IsAlwaysInGame() => never(loadedSaveSlot() == 0 || loadedSaveSlot() > 3 || Delta(loadedSaveSlot()) != loadedSaveSlot())

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

    achievement(title = cheevo["name"], description = cheevo["description"], points = cheevo["points"], badge = cheevo["badge"],
        trigger = IsInGame() &&
            measured(tally(cheevo["threshold"], totalCounts)) && unless(tally(cheevo["threshold"], loadedCounts))
            && never(resetAlt) && onlyAvailableWhen && (always_false() || never(Delta(char1()) == 0 && char1() == 0))
    )
}

function GenerateConditionFromBitflag(bit)
{
    return { "countsWhen": (bit == 1), "recalculateWhen": (Delta(bit) != bit) }
}

lums = {
1: { "levelId": 2, "mem": bit0(0x224988)},2: { "levelId": 2, "mem": bit1(0x224988)},3: { "levelId": 2, "mem": bit2(0x224988)},4: { "levelId": 2, "mem": bit3(0x224988)},5: { "levelId": 2, "mem": bit4(0x224988)},6: { "levelId": 2, "mem": bit5(0x224988)},7: { "levelId": 2, "mem": bit6(0x224988)},8: { "levelId": 2, "mem": bit7(0x224988)},9: { "levelId": 2, "mem": bit2(0x224989)},10: { "levelId": 2, "mem": bit1(0x22498a)},11: { "levelId": 2, "mem": bit2(0x22498a)},12: { "levelId": 2, "mem": bit3(0x22498a)},13: { "levelId": 2, "mem": bit4(0x22498a)},14: { "levelId": 2, "mem": bit5(0x22498a)},15: { "levelId": 2, "mem": bit6(0x22498a)},16: { "levelId": 2, "mem": bit7(0x22498a)},17: { "levelId": 2, "mem": bit5(0x22498b)},18: { "levelId": 2, "mem": bit6(0x22498b)},19: { "levelId": 2, "mem": bit7(0x22498b)},20: { "levelId": 2, "mem": bit0(0x22498c)},21: { "levelId": 2, "mem": bit1(0x22498c)},22: { "levelId": 2, "mem": bit2(0x22498c)},23: { "levelId": 2, "mem": bit3(0x22498c)},24: { "levelId": 2, "mem": bit4(0x22498c)},25: { "levelId": 2, "mem": bit5(0x22498c)},26: { "levelId": 2, "mem": bit6(0x22498c)},27: { "levelId": 2, "mem": bit7(0x22498c)},28: { "levelId": 2, "mem": bit0(0x22498d)},29: { "levelId": 2, "mem": bit1(0x22498d)},30: { "levelId": 2, "mem": bit2(0x22498d)},31: { "levelId": 2, "mem": bit3(0x22498d)},32: { "levelId": 2, "mem": bit4(0x22498d)},33: { "levelId": 2, "mem": bit5(0x22498d)},34: { "levelId": 2, "mem": bit6(0x22498d)},35: { "levelId": 2, "mem": bit7(0x22498d)},36: { "levelId": 2, "mem": bit0(0x22498e)},37: { "levelId": 2, "mem": bit1(0x22498e)},38: { "levelId": 1, "mem": bit3(0x224a36)},39: { "levelId": 1, "mem": bit4(0x224a36)},40: { "levelId": 1, "mem": bit5(0x224a36)},41: { "levelId": 1, "mem": bit6(0x224a36)},42: { "levelId": 1, "mem": bit7(0x224a36)},43: { "levelId": 3, },44: { "levelId": 3, },45: { "levelId": 3, },46: { "levelId": 3, },47: { "levelId": 3, },48: { "levelId": 3, },49: { "levelId": 3, },50: { "levelId": 3, },51: { "levelId": 3, },52: { "levelId": 3, },53: { "levelId": 3, },54: { "levelId": 3, },55: { "levelId": 3, },56: { "levelId": 3, },57: { "levelId": 3, },58: { "levelId": 3, },59: { "levelId": 3, },60: { "levelId": 3, },61: { "levelId": 3, },62: { "levelId": 3, },63: { "levelId": 3, },64: { "levelId": 3, },65: { "levelId": 3, },66: { "levelId": 3, },67: { "levelId": 3, },68: { "levelId": 3, },69: { "levelId": 3, },70: { "levelId": 3, },71: { "levelId": 3, },72: { "levelId": 3, },73: { "levelId": 3, },74: { "levelId": 3, },75: { "levelId": 3, },76: { "levelId": 3, },77: { "levelId": 3, },78: { "levelId": 3, },79: { "levelId": 3, },80: { "levelId": 3, },81: { "levelId": 3, },82: { "levelId": 3, },83: { "levelId": 3, },84: { "levelId": 3, },85: { "levelId": 3, },86: { "levelId": 3, },87: { "levelId": 3, },88: { "levelId": 3, },89: { "levelId": 3, },90: { "levelId": 3, },91: { "levelId": 3, },92: { "levelId": 3, },93: { "levelId": 3, },94: { "levelId": 3, },95: { "levelId": 3, },96: { "levelId": 3, },97: { "levelId": 3, },98: { "levelId": 3, },99: { "levelId": 3, },100: { "levelId": 3, },101: { "levelId": 3, },102: { "levelId": 3, },103: { "levelId": 3, },104: { "levelId": 3, },105: { "levelId": 3, },106: { "levelId": 3, },107: { "levelId": 3, },108: { "levelId": 3, },109: { "levelId": 3, },110: { "levelId": 3, },111: { "levelId": 3, },112: { "levelId": 3, },113: { "levelId": 3, },114: { "levelId": 3, },115: { "levelId": 3, },116: { "levelId": 3, },117: { "levelId": 3, },118: { "levelId": 3, },119: { "levelId": 3, },120: { "levelId": 3, },121: { "levelId": 3, },122: { "levelId": 3, },123: { "levelId": 3, },124: { "levelId": 3, },125: { "levelId": 3, },126: { "levelId": 3, },127: { "levelId": 3, },128: { "levelId": 3, },129: { "levelId": 3, },130: { "levelId": 3, },131: { "levelId": 3, },132: { "levelId": 3, },133: { "levelId": 3, },134: { "levelId": 3, },135: { "levelId": 3, },136: { "levelId": 3, },137: { "levelId": 3, },138: { "levelId": 3, },139: { "levelId": 3, },140: { "levelId": 3, },141: { "levelId": 3, },142: { "levelId": 3, },143: { "levelId": 3, },144: { "levelId": 3, },145: { "levelId": 3, },146: { "levelId": 3, },147: { "levelId": 3, },148: { "levelId": 3, },149: { "levelId": 3, },150: { "levelId": 3, },151: { "levelId": 3, },152: { "levelId": 3, },153: { "levelId": 3, },154: { "levelId": 3, },155: { "levelId": 3, },156: { "levelId": 3, },157: { "levelId": 3, },158: { "levelId": 3, },159: { "levelId": 3, },160: { "levelId": 3, },161: { "levelId": 3, },162: { "levelId": 3, },163: { "levelId": 3, },164: { "levelId": 3, },165: { "levelId": 3, },166: { "levelId": 3, },167: { "levelId": 3, },168: { "levelId": 3, },169: { "levelId": 3, },170: { "levelId": 3, },171: { "levelId": 3, },172: { "levelId": 3, },173: { "levelId": 3, },174: { "levelId": 3, },175: { "levelId": 3, },176: { "levelId": 3, },177: { "levelId": 3, },178: { "levelId": 3, },179: { "levelId": 3, },180: { "levelId": 3, },181: { "levelId": 3, },182: { "levelId": 3, },183: { "levelId": 3, },184: { "levelId": 3, },185: { "levelId": 3, },186: { "levelId": 3, },187: { "levelId": 3, },188: { "levelId": 3, },189: { "levelId": 3, },190: { "levelId": 3, },191: { "levelId": 3, },192: { "levelId": 3, },193: { "levelId": 3, },194: { "levelId": 3, },195: { "levelId": 3, },196: { "levelId": 3, },197: { "levelId": 3, },198: { "levelId": 3, },199: { "levelId": 3, },200: { "levelId": 3, },201: { "levelId": 3, },202: { "levelId": 3, },203: { "levelId": 3, },204: { "levelId": 3, },205: { "levelId": 3, },206: { "levelId": 3, },207: { "levelId": 3, },208: { "levelId": 3, },209: { "levelId": 3, },210: { "levelId": 3, },211: { "levelId": 3, },212: { "levelId": 3, },213: { "levelId": 3, },214: { "levelId": 3, },215: { "levelId": 3, },216: { "levelId": 3, },217: { "levelId": 3, },218: { "levelId": 3, },219: { "levelId": 3, },220: { "levelId": 3, },221: { "levelId": 3, },222: { "levelId": 3, },223: { "levelId": 3, },224: { "levelId": 3, },225: { "levelId": 3, },226: { "levelId": 3, },227: { "levelId": 3, },228: { "levelId": 3, },229: { "levelId": 3, },230: { "levelId": 3, },231: { "levelId": 3, },232: { "levelId": 3, },233: { "levelId": 3, },234: { "levelId": 3, },235: { "levelId": 3, },236: { "levelId": 3, },237: { "levelId": 3, },238: { "levelId": 3, },239: { "levelId": 3, },240: { "levelId": 3, },241: { "levelId": 3, },242: { "levelId": 3, },243: { "levelId": 3, },244: { "levelId": 3, },245: { "levelId": 3, },246: { "levelId": 3, },247: { "levelId": 3, },248: { "levelId": 3, },249: { "levelId": 3, },250: { "levelId": 3, },251: { "levelId": 3, },252: { "levelId": 3, },253: { "levelId": 3, },254: { "levelId": 3, },255: { "levelId": 3, },256: { "levelId": 3, },257: { "levelId": 3, },258: { "levelId": 3, },259: { "levelId": 3, },260: { "levelId": 3, },261: { "levelId": 3, },262: { "levelId": 3, },263: { "levelId": 3, },264: { "levelId": 3, },265: { "levelId": 3, },266: { "levelId": 3, },267: { "levelId": 3, },268: { "levelId": 3, },269: { "levelId": 3, },270: { "levelId": 3, },271: { "levelId": 3, },272: { "levelId": 3, },273: { "levelId": 3, },274: { "levelId": 3, },275: { "levelId": 3, },276: { "levelId": 3, },277: { "levelId": 3, },278: { "levelId": 3, },279: { "levelId": 3, },280: { "levelId": 3, },281: { "levelId": 3, },282: { "levelId": 3, },283: { "levelId": 3, },284: { "levelId": 3, },285: { "levelId": 3, },286: { "levelId": 3, },287: { "levelId": 3, },288: { "levelId": 3, },289: { "levelId": 3, },290: { "levelId": 3, },291: { "levelId": 3, },292: { "levelId": 3, },293: { "levelId": 3, },294: { "levelId": 3, },295: { "levelId": 3, },296: { "levelId": 3, },297: { "levelId": 3, },298: { "levelId": 3, },299: { "levelId": 3, },300: { "levelId": 3, },301: { "levelId": 3, },302: { "levelId": 3, },303: { "levelId": 3, },304: { "levelId": 3, },305: { "levelId": 3, },306: { "levelId": 3, },307: { "levelId": 3, },308: { "levelId": 3, },309: { "levelId": 3, },310: { "levelId": 3, },311: { "levelId": 3, },312: { "levelId": 3, },313: { "levelId": 3, },314: { "levelId": 3, },315: { "levelId": 3, },316: { "levelId": 3, },317: { "levelId": 3, },318: { "levelId": 3, },319: { "levelId": 3, },320: { "levelId": 3, },321: { "levelId": 3, },322: { "levelId": 3, },323: { "levelId": 3, },324: { "levelId": 3, },325: { "levelId": 3, },326: { "levelId": 3, },327: { "levelId": 3, },328: { "levelId": 3, },329: { "levelId": 3, },330: { "levelId": 3, },331: { "levelId": 3, },332: { "levelId": 3, },333: { "levelId": 3, },334: { "levelId": 3, },335: { "levelId": 3, },336: { "levelId": 3, },337: { "levelId": 3, },338: { "levelId": 3, },339: { "levelId": 3, },340: { "levelId": 3, },341: { "levelId": 3, },342: { "levelId": 3, },343: { "levelId": 3, },344: { "levelId": 3, },345: { "levelId": 3, },346: { "levelId": 3, },347: { "levelId": 3, },348: { "levelId": 3, },349: { "levelId": 3, },350: { "levelId": 3, },351: { "levelId": 3, },352: { "levelId": 3, },353: { "levelId": 3, },354: { "levelId": 3, },355: { "levelId": 3, },356: { "levelId": 3, },357: { "levelId": 3, },358: { "levelId": 3, },359: { "levelId": 3, },360: { "levelId": 3, },361: { "levelId": 3, },362: { "levelId": 3, },363: { "levelId": 3, },364: { "levelId": 3, },365: { "levelId": 3, },366: { "levelId": 3, },367: { "levelId": 3, },368: { "levelId": 3, },369: { "levelId": 3, },370: { "levelId": 3, },371: { "levelId": 3, },372: { "levelId": 3, },373: { "levelId": 3, },374: { "levelId": 3, },375: { "levelId": 3, },376: { "levelId": 3, },377: { "levelId": 3, },378: { "levelId": 3, },379: { "levelId": 3, },380: { "levelId": 3, },381: { "levelId": 3, },382: { "levelId": 3, },383: { "levelId": 3, },384: { "levelId": 3, },385: { "levelId": 3, },386: { "levelId": 3, },387: { "levelId": 3, },388: { "levelId": 3, },389: { "levelId": 3, },390: { "levelId": 3, },391: { "levelId": 3, },392: { "levelId": 3, },393: { "levelId": 3, },394: { "levelId": 3, },395: { "levelId": 3, },396: { "levelId": 3, },397: { "levelId": 3, },398: { "levelId": 3, },399: { "levelId": 3, },400: { "levelId": 3, },401: { "levelId": 3, },402: { "levelId": 3, },403: { "levelId": 3, },404: { "levelId": 3, },405: { "levelId": 3, },406: { "levelId": 3, },407: { "levelId": 3, },408: { "levelId": 3, },409: { "levelId": 3, },410: { "levelId": 3, },411: { "levelId": 3, },412: { "levelId": 3, },413: { "levelId": 3, },414: { "levelId": 3, },415: { "levelId": 3, },416: { "levelId": 3, },417: { "levelId": 3, },418: { "levelId": 3, },419: { "levelId": 3, },420: { "levelId": 3, },421: { "levelId": 3, },422: { "levelId": 3, },423: { "levelId": 3, },424: { "levelId": 3, },425: { "levelId": 3, },426: { "levelId": 3, },427: { "levelId": 3, },428: { "levelId": 3, },429: { "levelId": 3, },430: { "levelId": 3, },431: { "levelId": 3, },432: { "levelId": 3, },433: { "levelId": 3, },434: { "levelId": 3, },435: { "levelId": 3, },436: { "levelId": 3, },437: { "levelId": 3, },438: { "levelId": 3, },439: { "levelId": 3, },440: { "levelId": 3, },441: { "levelId": 3, },442: { "levelId": 3, },443: { "levelId": 3, },444: { "levelId": 3, },445: { "levelId": 3, },446: { "levelId": 3, },447: { "levelId": 3, },448: { "levelId": 3, },449: { "levelId": 3, },450: { "levelId": 3, },451: { "levelId": 3, },452: { "levelId": 3, },453: { "levelId": 3, },454: { "levelId": 3, },455: { "levelId": 3, },456: { "levelId": 3, },457: { "levelId": 3, },458: { "levelId": 3, },459: { "levelId": 3, },460: { "levelId": 3, },461: { "levelId": 3, },462: { "levelId": 3, },463: { "levelId": 3, },464: { "levelId": 3, },465: { "levelId": 3, },466: { "levelId": 3, },467: { "levelId": 3, },468: { "levelId": 3, },469: { "levelId": 3, },470: { "levelId": 3, },471: { "levelId": 3, },472: { "levelId": 3, },473: { "levelId": 3, },474: { "levelId": 3, },475: { "levelId": 3, },476: { "levelId": 3, },477: { "levelId": 3, },478: { "levelId": 3, },479: { "levelId": 3, },480: { "levelId": 3, },481: { "levelId": 3, },482: { "levelId": 3, },483: { "levelId": 3, },484: { "levelId": 3, },485: { "levelId": 3, },486: { "levelId": 3, },487: { "levelId": 3, },488: { "levelId": 3, },489: { "levelId": 3, },490: { "levelId": 3, },491: { "levelId": 3, },492: { "levelId": 3, },493: { "levelId": 3, },494: { "levelId": 3, },495: { "levelId": 3, },496: { "levelId": 3, },497: { "levelId": 3, },498: { "levelId": 3, },499: { "levelId": 3, },500: { "levelId": 3, },501: { "levelId": 3, },502: { "levelId": 3, },503: { "levelId": 3, },504: { "levelId": 3, },505: { "levelId": 3, },506: { "levelId": 3, },507: { "levelId": 3, },508: { "levelId": 3, },509: { "levelId": 3, },510: { "levelId": 3, },511: { "levelId": 3, },512: { "levelId": 3, },513: { "levelId": 3, },514: { "levelId": 3, },515: { "levelId": 3, },516: { "levelId": 3, },517: { "levelId": 3, },518: { "levelId": 3, },519: { "levelId": 3, },520: { "levelId": 3, },521: { "levelId": 3, },522: { "levelId": 3, },523: { "levelId": 3, },524: { "levelId": 3, },525: { "levelId": 3, },526: { "levelId": 3, },527: { "levelId": 3, },528: { "levelId": 3, },529: { "levelId": 3, },530: { "levelId": 3, },531: { "levelId": 3, },532: { "levelId": 3, },533: { "levelId": 3, },534: { "levelId": 3, },535: { "levelId": 3, },536: { "levelId": 3, },537: { "levelId": 3, },538: { "levelId": 3, },539: { "levelId": 3, },540: { "levelId": 3, },541: { "levelId": 3, },542: { "levelId": 3, },543: { "levelId": 3, },544: { "levelId": 3, },545: { "levelId": 3, },546: { "levelId": 3, },547: { "levelId": 3, },548: { "levelId": 3, },549: { "levelId": 3, },550: { "levelId": 3, },551: { "levelId": 3, },552: { "levelId": 3, },553: { "levelId": 3, },554: { "levelId": 3, },555: { "levelId": 3, },556: { "levelId": 3, },557: { "levelId": 3, },558: { "levelId": 3, },559: { "levelId": 3, },560: { "levelId": 3, },561: { "levelId": 3, },562: { "levelId": 3, },563: { "levelId": 3, },564: { "levelId": 3, },565: { "levelId": 3, },566: { "levelId": 3, },567: { "levelId": 3, },568: { "levelId": 3, },569: { "levelId": 3, },570: { "levelId": 3, },571: { "levelId": 3, },572: { "levelId": 3, },573: { "levelId": 3, },574: { "levelId": 3, },575: { "levelId": 3, },576: { "levelId": 3, },577: { "levelId": 3, },578: { "levelId": 3, },579: { "levelId": 3, },580: { "levelId": 3, },581: { "levelId": 3, },582: { "levelId": 3, },583: { "levelId": 3, },584: { "levelId": 3, },585: { "levelId": 3, },586: { "levelId": 3, },587: { "levelId": 3, },588: { "levelId": 3, },589: { "levelId": 3, },590: { "levelId": 3, },591: { "levelId": 3, },592: { "levelId": 3, },593: { "levelId": 3, },594: { "levelId": 3, },595: { "levelId": 3, },596: { "levelId": 3, },597: { "levelId": 3, },598: { "levelId": 3, },599: { "levelId": 3, },600: { "levelId": 3, },601: { "levelId": 3, },602: { "levelId": 3, },603: { "levelId": 3, },604: { "levelId": 3, },605: { "levelId": 3, },606: { "levelId": 3, },607: { "levelId": 3, },608: { "levelId": 3, },609: { "levelId": 3, },610: { "levelId": 3, },611: { "levelId": 3, },612: { "levelId": 3, },613: { "levelId": 3, },614: { "levelId": 3, },615: { "levelId": 3, },616: { "levelId": 3, },617: { "levelId": 3, },618: { "levelId": 3, },619: { "levelId": 3, },620: { "levelId": 3, },621: { "levelId": 3, },622: { "levelId": 3, },623: { "levelId": 3, },624: { "levelId": 3, },625: { "levelId": 3, },626: { "levelId": 3, },627: { "levelId": 3, },628: { "levelId": 3, },629: { "levelId": 3, },630: { "levelId": 3, },631: { "levelId": 3, },632: { "levelId": 3, },633: { "levelId": 3, },634: { "levelId": 3, },635: { "levelId": 3, },636: { "levelId": 3, },637: { "levelId": 3, },638: { "levelId": 3, },639: { "levelId": 3, },640: { "levelId": 3, },641: { "levelId": 3, },642: { "levelId": 3, },643: { "levelId": 3, },644: { "levelId": 3, },645: { "levelId": 3, },646: { "levelId": 3, },647: { "levelId": 3, },648: { "levelId": 3, },649: { "levelId": 3, },650: { "levelId": 3, },651: { "levelId": 3, },652: { "levelId": 3, },653: { "levelId": 3, },654: { "levelId": 3, },655: { "levelId": 3, },656: { "levelId": 3, },657: { "levelId": 3, },658: { "levelId": 3, },659: { "levelId": 3, },660: { "levelId": 3, },661: { "levelId": 3, },662: { "levelId": 3, },663: { "levelId": 3, },664: { "levelId": 3, },665: { "levelId": 3, },666: { "levelId": 3, },667: { "levelId": 3, },668: { "levelId": 3, },669: { "levelId": 3, },670: { "levelId": 3, },671: { "levelId": 3, },672: { "levelId": 3, },673: { "levelId": 3, },674: { "levelId": 3, },675: { "levelId": 3, },676: { "levelId": 3, },677: { "levelId": 3, },678: { "levelId": 3, },679: { "levelId": 3, },680: { "levelId": 3, },681: { "levelId": 3, },682: { "levelId": 3, },683: { "levelId": 3, },684: { "levelId": 3, },685: { "levelId": 3, },686: { "levelId": 3, },687: { "levelId": 3, },688: { "levelId": 3, },689: { "levelId": 3, },690: { "levelId": 3, },691: { "levelId": 3, },692: { "levelId": 3, },693: { "levelId": 3, },694: { "levelId": 3, },695: { "levelId": 3, },696: { "levelId": 3, },697: { "levelId": 3, },698: { "levelId": 3, },699: { "levelId": 3, },700: { "levelId": 3, },701: { "levelId": 3, },702: { "levelId": 3, },703: { "levelId": 3, },704: { "levelId": 3, },705: { "levelId": 3, },706: { "levelId": 3, },707: { "levelId": 3, },708: { "levelId": 3, },709: { "levelId": 3, },710: { "levelId": 3, },711: { "levelId": 3, },712: { "levelId": 3, },713: { "levelId": 3, },714: { "levelId": 3, },715: { "levelId": 3, },716: { "levelId": 3, },717: { "levelId": 3, },718: { "levelId": 3, },719: { "levelId": 3, },720: { "levelId": 3, },721: { "levelId": 3, },722: { "levelId": 3, },723: { "levelId": 3, },724: { "levelId": 3, },725: { "levelId": 3, },726: { "levelId": 3, },727: { "levelId": 3, },728: { "levelId": 3, },729: { "levelId": 3, },730: { "levelId": 3, },731: { "levelId": 3, },732: { "levelId": 3, },733: { "levelId": 3, },734: { "levelId": 3, },735: { "levelId": 3, },736: { "levelId": 3, },737: { "levelId": 3, },738: { "levelId": 3, },739: { "levelId": 3, },740: { "levelId": 3, },741: { "levelId": 3, },742: { "levelId": 3, },743: { "levelId": 3, },744: { "levelId": 3, },745: { "levelId": 3, },746: { "levelId": 3, },747: { "levelId": 3, },748: { "levelId": 3, },749: { "levelId": 3, },750: { "levelId": 3, },751: { "levelId": 3, },752: { "levelId": 3, },753: { "levelId": 3, },754: { "levelId": 3, },755: { "levelId": 3, },756: { "levelId": 3, },757: { "levelId": 3, },758: { "levelId": 3, },759: { "levelId": 3, },760: { "levelId": 3, },761: { "levelId": 3, },762: { "levelId": 3, },763: { "levelId": 3, },764: { "levelId": 3, },765: { "levelId": 3, },766: { "levelId": 3, },767: { "levelId": 3, },768: { "levelId": 3, },769: { "levelId": 3, },770: { "levelId": 3, },771: { "levelId": 3, },772: { "levelId": 3, },773: { "levelId": 3, },774: { "levelId": 3, },775: { "levelId": 3, },776: { "levelId": 3, },777: { "levelId": 3, },778: { "levelId": 3, },779: { "levelId": 3, },780: { "levelId": 3, },781: { "levelId": 3, },782: { "levelId": 3, },783: { "levelId": 3, },784: { "levelId": 3, },785: { "levelId": 3, },786: { "levelId": 3, },787: { "levelId": 3, },788: { "levelId": 3, },789: { "levelId": 3, },790: { "levelId": 3, },791: { "levelId": 3, },792: { "levelId": 3, },793: { "levelId": 3, },794: { "levelId": 3, },795: { "levelId": 3, },796: { "levelId": 3, },797: { "levelId": 3, },798: { "levelId": 3, },799: { "levelId": 3, },800: { "levelId": 3, },801: { "levelId": 3, },802: { "levelId": 3, },803: { "levelId": 3, },804: { "levelId": 3, },805: { "levelId": 3, },806: { "levelId": 3, },807: { "levelId": 3, },808: { "levelId": 3, },809: { "levelId": 3, },810: { "levelId": 3, },811: { "levelId": 3, },812: { "levelId": 3, },813: { "levelId": 3, },814: { "levelId": 3, },815: { "levelId": 3, },816: { "levelId": 3, },817: { "levelId": 3, },818: { "levelId": 3, },819: { "levelId": 3, },820: { "levelId": 3, },821: { "levelId": 3, },822: { "levelId": 3, },823: { "levelId": 3, },824: { "levelId": 3, },825: { "levelId": 3, },826: { "levelId": 3, },827: { "levelId": 3, },828: { "levelId": 3, },829: { "levelId": 3, },830: { "levelId": 3, },831: { "levelId": 3, },832: { "levelId": 3, },833: { "levelId": 3, },834: { "levelId": 3, },835: { "levelId": 3, },836: { "levelId": 3, },837: { "levelId": 3, },838: { "levelId": 3, },839: { "levelId": 3, },840: { "levelId": 3, },841: { "levelId": 3, },842: { "levelId": 3, },843: { "levelId": 3, },844: { "levelId": 3, },845: { "levelId": 3, },846: { "levelId": 3, },847: { "levelId": 3, },848: { "levelId": 3, },849: { "levelId": 3, },850: { "levelId": 3, },851: { "levelId": 3, },852: { "levelId": 3, },853: { "levelId": 3, },854: { "levelId": 3, },855: { "levelId": 3, },856: { "levelId": 3, },857: { "levelId": 3, },858: { "levelId": 3, },859: { "levelId": 3, },860: { "levelId": 3, },861: { "levelId": 3, },862: { "levelId": 3, },863: { "levelId": 3, },864: { "levelId": 3, },865: { "levelId": 3, },866: { "levelId": 3, },867: { "levelId": 3, },868: { "levelId": 3, },869: { "levelId": 3, },870: { "levelId": 3, },871: { "levelId": 3, },872: { "levelId": 3, },873: { "levelId": 3, },874: { "levelId": 3, },875: { "levelId": 3, },876: { "levelId": 3, },877: { "levelId": 3, },878: { "levelId": 3, },879: { "levelId": 3, },880: { "levelId": 3, },881: { "levelId": 3, },882: { "levelId": 3, },883: { "levelId": 3, },884: { "levelId": 3, },885: { "levelId": 3, },886: { "levelId": 3, },887: { "levelId": 3, },888: { "levelId": 3, },889: { "levelId": 3, },890: { "levelId": 3, },891: { "levelId": 3, },892: { "levelId": 3, },893: { "levelId": 3, },894: { "levelId": 3, },895: { "levelId": 3, },896: { "levelId": 3, },897: { "levelId": 3, },898: { "levelId": 3, },899: { "levelId": 3, },900: { "levelId": 3, },901: { "levelId": 3, },902: { "levelId": 3, },903: { "levelId": 3, },904: { "levelId": 3, },905: { "levelId": 3, },906: { "levelId": 3, },907: { "levelId": 3, },908: { "levelId": 3, },909: { "levelId": 3, },910: { "levelId": 3, },911: { "levelId": 3, },912: { "levelId": 3, },913: { "levelId": 3, },914: { "levelId": 3, },915: { "levelId": 3, },916: { "levelId": 3, },917: { "levelId": 3, },918: { "levelId": 3, },919: { "levelId": 3, },920: { "levelId": 3, },921: { "levelId": 3, },922: { "levelId": 3, },923: { "levelId": 3, },924: { "levelId": 3, },925: { "levelId": 3, },926: { "levelId": 3, },927: { "levelId": 3, },928: { "levelId": 3, },929: { "levelId": 3, },930: { "levelId": 3, },931: { "levelId": 3, },932: { "levelId": 3, },933: { "levelId": 3, },934: { "levelId": 3, },935: { "levelId": 3, },936: { "levelId": 3, },937: { "levelId": 3, },938: { "levelId": 3, },939: { "levelId": 3, },940: { "levelId": 3, },941: { "levelId": 3, },942: { "levelId": 3, },943: { "levelId": 3, },944: { "levelId": 3, },945: { "levelId": 3, },946: { "levelId": 3, },947: { "levelId": 3, },948: { "levelId": 3, },949: { "levelId": 3, },950: { "levelId": 3, },951: { "levelId": 3, },952: { "levelId": 3, },953: { "levelId": 3, },954: { "levelId": 3, },955: { "levelId": 3, },956: { "levelId": 3, },957: { "levelId": 3, },958: { "levelId": 3, },959: { "levelId": 3, },960: { "levelId": 3, },961: { "levelId": 3, },962: { "levelId": 3, },963: { "levelId": 3, },964: { "levelId": 3, },965: { "levelId": 3, },966: { "levelId": 3, },967: { "levelId": 3, },968: { "levelId": 3, },969: { "levelId": 3, },970: { "levelId": 3, },971: { "levelId": 3, },972: { "levelId": 3, },973: { "levelId": 3, },974: { "levelId": 3, },975: { "levelId": 3, },976: { "levelId": 3, },977: { "levelId": 3, },978: { "levelId": 3, },979: { "levelId": 3, },980: { "levelId": 3, },981: { "levelId": 3, },982: { "levelId": 3, },983: { "levelId": 3, },984: { "levelId": 3, },985: { "levelId": 3, },986: { "levelId": 3, },987: { "levelId": 3, },988: { "levelId": 3, },989: { "levelId": 3, },990: { "levelId": 3, },991: { "levelId": 3, },992: { "levelId": 3, },993: { "levelId": 3, },994: { "levelId": 3, },995: { "levelId": 3, },996: { "levelId": 3, },997: { "levelId": 3, },998: { "levelId": 3, },999: { "levelId": 3, },1000: { "levelId": 3, },

}

MapLookup = {
    0xcccc: "Main Menu",
    0x6e75: "Main Menu",
    0x696c: "Intro",
    0x6172: "The Iron Mountains",
    0x706d: "The Hall of Doors",
    0x695f: "The Marshes of Awakening",
    0x6173: "The Bayou",
    0x7461: "Razorbeard's Ship",
    0x7465: "The Sanctuary of Water and Ice",
    0x6c6f: "Polokus home",
    0x6465: "The Menhir Hills",
    0x645f: "Ending",
    0x6c63: "The Cave of Bad Dreams",
    0x6f62: "The Canopy",
    0x616c: "Whale Bay",
    0x6166: "Ending",
    0x756d: "The Sanctuary of Stone and Fire",
    0x7374: "The Echoing Caves",
    0x736b: "The Echoing Caves",
    0x7665: "The Precipice",
    0x6174: "The Prison Ship",
    0x7274: "The Sanctuary of Rock and Lava",
    0x6c69: "Beneath the Sanctuary of Rock and Lava",
    0x7262: "Tomb of the Ancients",
    0x6f70: "The Crow's Nest",
    0x5f31: "The Walk of Life",
    0x5f32: "The Walk of Power",
}

achievement(
    title = "King of Teensies", description = "Meet the... king?", points = 5,
    id = 71511, badge = "165863", published = "2/5/2019 4:38:34 AM", modified = "4/5/2021 3:03:33 PM",
    trigger = prev(word(0x0E5C34)) == 24946 && word(0x0E5C34) == 28781
)

// todo: document changes in plan
function canGrabPurpleLums() => bit6(0x224a10)
achievement(
    title = "The Gift of Swing", description = "Obtain the power to swing from Ly.", points = 5,
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

lumConditions = {}

achievement(
    title = "Naive Hero", description = "Find 100 Lums.", points = 5,
    id = 71522, badge = "165875", published = "2/5/2019 4:38:55 AM", modified = "4/5/2021 3:04:42 PM",
    trigger = never(byte(0x0EA27C) == 0) && word(0x0E5C34) == 28781 && word(0x5DE45C) >= 100 && byte(0x780970) == 184
)

achievement(
    title = "Kind of a collection", description = "Get a total of 250 lums  (Triggered at Hall of Doors)", points = 10,
    id = 71523, badge = "165876", published = "2/5/2019 4:38:57 AM", modified = "4/5/2021 3:05:21 PM",
    trigger = never(byte(0x0EA27C) == 0) && word(0x0E5C34) == 28781 && word(0x5DE45C) >= 250 && byte(0x780970) == 184
)

achievement(
    title = "Lummania", description = "Get a total of 500 lums  (Triggered at Hall of Doors)", points = 10,
    id = 71524, badge = "165877", published = "2/5/2019 4:38:59 AM", modified = "4/5/2021 3:05:23 PM",
    trigger = never(byte(0x0EA27C) == 0) && word(0x0E5C34) == 28781 && word(0x5DE45C) >= 500 && byte(0x780970) == 184
)

achievement(
    title = "Lum addicted", description = "Get a total of 750 lums  (Triggered at Hall of Doors)", points = 10,
    id = 71525, badge = "165878", published = "2/5/2019 4:39:00 AM", modified = "4/5/2021 3:05:25 PM",
    trigger = never(byte(0x0EA27C) == 0) && word(0x0E5C34) == 28781 && word(0x5DE45C) >= 750 && byte(0x780970) == 184
)

achievement(
    title = "Really a collection", description = "Get all 999 lums  (Triggered at Hall of Doors)", points = 25,
    id = 71526, badge = "165879", published = "2/5/2019 4:39:02 AM", modified = "4/5/2021 3:05:27 PM",
    trigger = never(byte(0x0EA27C) == 0) && word(0x0E5C34) == 28781 && word(0x5DE45C) == 999 && byte(0x780970) == 184
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

achievement(
    title = "Thanks, dude", description = "Destroy a total of 10 cages", points = 5,
    id = 71527, badge = "165880", published = "2/5/2019 4:39:04 AM", modified = "4/5/2021 3:05:31 PM",
    trigger = prev(byte(0x224941)) == 9 && byte(0x224941) == 10
)

achievement(
    title = "Thanks, buddy", description = "Destroy a total of 40 cages", points = 10,
    id = 71528, badge = "165882", published = "2/5/2019 4:39:05 AM", modified = "4/5/2021 3:05:52 PM",
    trigger = prev(byte(0x224941)) == 39 && byte(0x224941) == 40
)

achievement(
    title = "Thanks, pal", description = "Destroy all 80 cages", points = 25,
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

achievement(
    title = "Charging !", description = "Get the second fist upgrade", points = 3,
    id = 54219, badge = "55961", published = "11/2/2017 7:04:47 PM", modified = "11/2/2017 7:23:43 PM",
    trigger = byte(0x224A10) == 109 && byte(0x224A16) == 64
)

//rich_presence_conditional_display(IsOnMainMenu(), "In the main menu...")

//rich_presence_conditional_display(SaveFileIsLoaded(), "Rayman is {0}",
//    rich_presence_lookup("Map", word(0x0E5C34), MapLookup)
//)

rich_presence_conditional_display(word(0x0E5C34) == 28781, "{0} | 🌞x{1}/999 lums| 🔒x{2}/80 cages",
    rich_presence_lookup("Map", word(0x0E5C34), MapLookup),
    rich_presence_value("lum1", word(0x5DE45C)),
    rich_presence_value("cage", byte(0x224941))
)

rich_presence_display("{0} | 🔒x{1}/80 cages",
    rich_presence_lookup("Map", word(0x0E5C34), MapLookup),
    rich_presence_value("cage", byte(0x224941))
)
