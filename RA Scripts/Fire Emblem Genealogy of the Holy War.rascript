// Fire Emblem: Genealogy of the Holy War
// #ID = 2878

function Delta(addr) => prev(addr)

function Min(x, y)
{
    if (x > y)
    {
        return x
    }
    else
    {
        return y
    }
}

function IsBitflagSetInGame(bit)
{
    return IsValueSetInGame(bit, 0, 1)
}

function WasBitflagSetInGame(bit)
{
    return WasValueSetInGame(bit, 0, 1)
}

function IsValueSetInGame(bit)
{
    return IsValueSet(bit, 0, 1)
}

function WasValueSetInGame(mem, oldValue, newValue)
{
    return WasValueSet(mem, oldValue, newValue)
        && never(IsLoadingSaveFile()) && never(!TurnNumberIsPlausible())
}

function IsValueSetInGame(mem, oldValue, newValue)
{
    return IsValueSet(mem, oldValue, newValue)
        && never(IsLoadingSaveFile()) && never(!TurnNumberIsPlausible())
}

function WasValueSet(mem, oldValue, newValue)
{
    return once(Delta(mem) == oldValue && mem == newValue)
}

function IsValueSet(mem, oldValue, newValue)
{
    return Delta(mem) == oldValue && mem == newValue
}

function DidValueBecomeGreaterThanGivenInGame(mem, value)
{
    return once(Delta(mem) <= value && mem > value) && never(IsLoadingSaveFile())
}

// $000768: Cursor - X coord relative position
// $00076A: Cursor - Y coord relative position

// $000CC2: Times game has been cleared
function gameClearTimes() => byte(0x000CC2)

// $000D6A: Chapter
function chapter() => byte(0x000D6A)

chapters = {
    0x0: { "pretitle": "Prologue", "name": "Birth of a Crusader", "rescuableVillageSlotIds": [ 3, 4, 5, 6, 7 ], "keepIds": [ 0, 1, 2 ] },
    0x1: { "pretitle": "Chapter 1", "name": "The Spirit Forest's Maiden", "rescuableVillageSlotIds": [ 5, 6, 7 ], "keepIds": [ 0, 1, 2, 3, 4 ] },
    0x2: { "pretitle": "Chapter 2", "name": "Crisis in Agustria", "rescuableVillageSlotIds": [ 6, 8, 9, 10, 11, 12, 13, 14, 15 ], "keepIds": [ 0, 1, 2, 3, 4, 5 ] },
    0x3: { "pretitle": "Chapter 3", "name": "Eldigan the Lionheart", "rescuableVillageSlotIds": [ 4, 5, 6, 7, 8, 9, 10, 11 ], "keepIds": [ 0, 1, 2, 3 ] },
    0x4: { "pretitle": "Chapter 4", "name": "Dance in the Skies", "rescuableVillageSlotIds": [ 4, 5, 6, 7, 8, 9, 10, 11 ], "keepIds": [ 0, 1, 2, 3 ] },
    0x5: { "pretitle": "Chapter 5", "name": "Threshold of Fate", "rescuableVillageSlotIds": [ 5, 6, 7, 8, 9, 10, 11 ], "keepIds": [ 0, 1, 2, 3, 4 ] },
    0x6: { "pretitle": "Chapter 6", "name": "Heirs to the Light", "rescuableVillageSlotIds": [ 5, 6, 7, 8, 9, 10 ], "keepIds": [ 0, 1, 2, 3, 4 ] },
    0x7: { "pretitle": "Chapter 7", "name": "Beyond the Desert", "rescuableVillageSlotIds": [ 6, 7, 8, 9, 10, 11 ], "keepIds": [ 0, 1, 2, 3, 4, 5] },
    0x8: { "pretitle": "Chapter 8", "name": "The Dracoknights of Thracia", "rescuableVillageSlotIds": [ 5, 6, 7, 8, 9, 10 ], "keepIds": [ 0, 1, 2, 3, 4 ] },
    0x9: { "pretitle": "Chapter 9", "name": "For Whose Sake", "rescuableVillageSlotIds": [ 5, 6, 7, 8, 9, 10 ], "keepIds": [ 0, 1, 2, 3, 4 ] },
    0xA: { "pretitle": "Chapter 10", "name": "Light and Darkness", "rescuableVillageSlotIds": [ 5, 6, 7, 8, 9, 10 ], "keepIds": [ 0, 1, 2, 3, 4 ] },
    0xB: { "pretitle": "Endgame", "name": "The Final Holy War", "rescuableVillageSlotIds": [ 6, 7 ], "keepIds": [ 0, 1, 2, 3, 4, 5 ] },
    0xFF: { "pretitle": "", "name": "Epilogue/Credits", "rescuableVillageSlotIds": [ ], "keepIds": [] },
}

function GetChapterIds()
{
    chapterIds = []
    for i in chapters
    {
        array_push(chapterIds, i)
    }
    return chapterIds
}

// $000D73: Number of player castles captured by the enemy (affects Tactics ranking)
function playerCastlesCaptured() => byte(0x000d73)

// $000D8F: [2 Byte] Days
function turns() => word(0x000D8F)

function TurnNumberIsPlausible() => turns() < 65535 && turns() > 0

// $000D91: Current Phase
function phase() => byte(0x000d91)

function IsPlayerPhase() => phase() == 0x0
function IsAlliedPhase() => phase() == 0x1

// $000D93: [2 Byte] Total Days - Prologue
function turnsElapsedInPrologueBaseAddr() => 0x000D93
function turnsElapsedInPrologue() => word(0x000D93)

// $000D95: [2 Byte] Total Days - Chapter 1
function turnsElapsedInChapter1() => word(0x000D95)

// $000D97: [2 Byte] Total Days - Chapter 2
function turnsElapsedInChapter2() => word(0x000D97)

// $000D99: [2 Byte] Total Days - Chapter 3
function turnsElapsedInChapter3() => word(0x000D99)

// $000D9B: [2 Byte] Total Days - Chapter 4
function turnsElapsedInChapter4() => word(0x000D9B)

// $000D9D: [2 Byte] Total Days - Chapter 5
function turnsElapsedInChapter5() => word(0x000D9D)

// $000D9F: [2 Byte] Total Days - Chapter 6
function turnsElapsedInChapter6() => word(0x000D9F)

// $000DA1: [2 Byte] Total Days - Chapter 7
function turnsElapsedInChapter7() => word(0x000DA1)

// $000DA3: [2 Byte] Total Days - Chapter 8
function turnsElapsedInChapter8() => word(0x000DA3)

// $000DA5: [2 Byte] Total Days - Chapter 9
function turnsElapsedInChapter9() => word(0x000DA5)

// $000DA7: [2 Byte] Total Days - Chapter 10
function turnsElapsedInChapter10() => word(0x000DA7)

// $000DA9: [2 Byte] Total Days - Endgame
function turnsElapsedInEndgame() => word(0x000DA9)

function gen1UnitBaseAddr() => 0x002d31 // Sigurd's arena LV address in actuality.
function gen2UnitBaseAddr() => 0x0030fd // Seliph's arena LV address in actuality.
function GetUnitObjectByAddr(addr)
{
    // For the purposes of keeping things uniform, we're assuming that arena LV is the head address for each unit.
    return {
        "header": byte(addr - 1),
        "arenaLevel": low4(addr),
        "status": byte(addr + 1),
        "isDead": bit1(addr + 1),
        "isTurnOver": bit6(addr + 1),
        "isSortied": bit7(addr + 1),
        "lover": byte(addr + 3),
        "affiliation": byte(addr + 6),
        "condition": byte(addr + 8),
        "bonusStats": byte(addr + 10),
        "hp": byte(addr + 13),
        "maxHp": byte(addr + 15),
        "strength": byte(addr + 16),
        "magic": byte(addr + 17),
        "skill": byte(addr + 18),
        "speed": byte(addr + 19),
        "defense": byte(addr + 20),
        "resistance": byte(addr + 21),
        "luck": byte(addr + 22),
        "class": byte(addr + 23),
        "level": byte(addr + 24),
        "authority": byte(addr + 25),
        "gold": word(addr + 27),
        "exp": byte(addr + 28),
        "talkTo": byte(addr + 29)
    }
}

function GetGen1UnitObjectByIndex(index)
{
    // Gen 1 units are 0x24 bytes wide, and so to get the next one in a sequence, simply subtract 0x24.
    return GetUnitObjectByAddr(gen1UnitBaseAddr() - index * 0x24)
}

function GetGen2UnitObjectByIndex(index)
{
    // Gen 2 units are 0x3a bytes wide, and so to get the next one in a sequence, simply subtract 0x3a.
    return GetUnitObjectByAddr(gen2UnitBaseAddr() - index * 0x3a)
}

// $001075: Cursor - X coord relative position (copy)
// $001076: Cursor - X coord shift
// $001095: Cursor - Y coord relative position (copy)
// $001096: Cursor - Y coord shift
// $001864: Save Game menu - File Cursor
// $001B19: Play Time
function playTime() => dword(0x001b19)
// $0029F5: Claude's Arena Progress
// $002A19: Taillte's Arena Progress
// $002A3D: Brigid's Arena Progress
// $002A61: Erin's Arena Progress
// $002A85: Sylvia's Arena Progress
// $002AA9: Levin's Arena Progress
// $002ACD: Beowolf's Arena Progress
// $002AF1: Holin's Arena Progress
// $002B15: Raquesis' Arena Progress
// $002B39: Deirdre's Arena Progress
// $002B5D: Jamke's Arena Progress
// $002B81: Dew's Arena Progress
// $002BA5: Aideen's Arena Progress
// $002BC9: Ira's Arena Progress
// $002BED: Midir's Arena Progress
// $002C11: Ethlyn's Arena Progress
// $002C35: Finn's Arena Progress
// $002C59: Quan's Arena Progress
// $002C7D: Lex's Arena Progress
// $002CA1: Azel's Arena Progress
// $002CB8: Azel's class
// $002CC5: Arden's Arena Progress
// $002CC6: Arden Status
// $002CC8: Arden Lover
// $002CC9: Arden Character ID
// $002CCB: Arden Affiliation
// $002CD0: Arden stat bonuses
// $002CD2: Adan/Oifaye/Yuria HP
// $002CD4: Adan/Oifaye/Yuria Max HP
// $002CE9: Alec's Arena Progress
// $002CEA: Alec Status
// $002CEC: Alec Lover
// $002CED: Alec Character ID
// $002CEF: Alec Affiliation
// $002CF3: Alec stat bonuses
// $002CF6: Alec Current HP
// $002CF8: Alec max HP
// $002CF9: Alec strength
// $002CFA: Alec Magic
// $002CFB: Alec Skill
// $002CFC: Alec Speed
// $002CFD: Alec Defence
// $002CFE: Alec Resistance
// $002CFF: Alec Luck
// $002D00: Alec Class
// $002D01: Alec Level
// $002D03: Alec Money
// $002D05: Alec experience
// $002D06: Alec Talk to
// $002D0D: Noish's Arena Progress
// $002D0E: Noish Status
// $002D10: Noish Lover
// $002D11: Noish character ID
// $002D13: Noish Affiliation (0 for ally, 1 for enemy)
// $002D17: Noish stat bonuses
// $002D1A: Noish current HP
// $002D1C: Noish Max HP
// $002D1D: Noish Strength
// $002D1E: Noish Magic
// $002D1F: Noish Skill
// $002D20: Noish Speed
// $002D21: Noish Defence
// $002D22: Noish Resistence
// $002D23: Noish Luck
// $002D24: Noish Class
// $002D25: Noish Level
// $002D27: Noish Money
// $002D29: Noish EXP
// $002D2A: Noish talk to
// $002D31: Sigurd's Arena Progress
// $002D32: Sigurd's Status
// $002D34: Sigurd's Lover
// $002D35: Sigurd character ID
// $002D39: Sigurd's Condition
// $002D3B: Sigurd's Bonus Stats
// $002D3E: Sigurd's Current HP
// $002D40: Sigurd's Total HP
// $002D41: Sigurd's Strength
// $002D42: Sigurd's Magic
// $002D43: Sigurd's Skill
// $002D44: Sigurd's Speed
// $002D45: Sigurd's Defense
// $002D46: Sigurd's Resistance
// $002D47: Sigurd's Luck
// $002D48: Sigurd's Class Modifier
// $002D49: Sigurd's Level
// $002D4A: Sigurd's Authority
// $002D4B: [2 Byte] Sigurd's Money
// $002D4D: Sigurd's Experience
// $002D4E: Sigurd's Talk To
// $002D56: ?
// $002D5D: Nanna's Arena Progress
// $002D97: Dermott's Arena Progress
// $002DD1: Larcei's Arena Progress
// $002E0B: Ulster's Arena Progress
// $002E45: Fee's Arena Progress
// $002E7F: Ced's Arena Progress
// $002EB9: Tinni's Arena Progress
// $002EF3: Arthur's Arena Progress
// $002F2D: Lene's Arena Progress
// $002F67: Cairpre's Arena Progress
// $002FA1: Lana's Arena Progress
// $002FDB: Lester's Arena Progress
// $003015: Patty's Arena Progress
// $00304F: Faval's Arena Progress
// $003089: Altena's Arena Progress
// $0030C3: Leif's Arena Progress
// $0030F7: Seliph's Available in a level?!
// $0030FD: Seliph's Arena Progress
// $0030FE: Seliph's Status
// $003100: Seliph's Lover
// $003103: Seliph's Turf
// $003105: Seliph's Condition
// $003107: Seliph's Bonus Stats
// $00310A: Seliph's Current HP
// $00310C: Seliph's Total HP
// $00310D: Seliph's Strength
// $00310E: Seliph's Magic
// $00310F: Seliph's Skill
// $003110: Seliph's Speed
// $003111: Seliph's Defense
// $003112: Seliph's Resistance
// $003113: Seliph's Luck
// $003114: Seliph's Class
// $003115: Seliph's Level
// $003116: Seliph's Authority
// $003117: [2 Byte] Seliph's Money
// $003119: Seliph's Experience
// $00311A: Seliph's Talk To
// $00311B: [2 Byte] Seliph's Sprite
// $00311D: [2 Byte] Seliph's Name
// $00312A: Seliph's Skills (1/3)
// $00312B: Seliph's Skills (2/3)
// $00312C: Seliph's Skills (3/3)
// $00312D: Seliph's Holy Blood (1/4)
// $00312E: Seliph's Holy Blood (2/4)
// $00312F: Seliph's Holy Blood (3/4)
// $003130: Seliph's Holy Blood (4/4)
// $003137: ?'s Arena Progress
// $0033D7: Enemy XX - Current Hp
// $0033D8: Enemy XX - Funds x100
// $0033EC: Enemy XX - Current Hp
// $003401: Enemy XX - Current Hp
// $003416: Enemy XX - Current Hp
// $00342B: Enemy XX - Current Hp
// $0036ac: Bridget inventory count
function bridgetInventoryCountAddr() => 0x0036ac
// $0036BE: Seliph's Weapon Slot equipped
// $0036BF: Seliph's Inventory Quantity
// $0036C0: Seliph's 1st item ID
// $0036C1: Seliph's 2nd item ID
// $0036C2: Seliph's 3rd item ID
// $0036C3: Seliph's 4th item ID
// $0036C4: Seliph's 5th item ID
// $0036C5: Seliph's 6th item ID
// $0036C6: Seliph's 7th item ID
// $0036D1: Lester's Weapon Slot equipped
// $0036E4: ?'s Weapon Slot equipped
// $0036F7: ?'s Weapon Slot equipped
// $00370A: ?'s Weapon Slot equipped
// $00371D: ?'s Weapon Slot equipped
// $003730: ?'s Weapon Slot equipped
// $003743: ?'s Weapon Slot equipped
// $003756: ?'s Weapon Slot equipped
// $003769: ?'s Weapon Slot equipped
// $00377C: ?'s Weapon Slot equipped
// $00378F: ?'s Weapon Slot equipped
// $0037A2: ?'s Weapon Slot equipped
// $0037B5: ?'s Weapon Slot equipped
// $0037C8: ?'s Weapon Slot equipped
// $0037DB: ?'s Weapon Slot equipped
// $0037EE: ?'s Weapon Slot equipped
// $003801: ?'s Weapon Slot equipped
// $003814: ?'s Weapon Slot equipped
// $003827: ?'s Weapon Slot equipped
// $00383A: ?'s Weapon Slot equipped
// $00384D: Julia's Weapon Slot equipped
function juliaInventoryCountAddr() => 0x00384e
// $003860: Nanna's Weapon Slot equipped
// $003873: ?'s Weapon Slot equipped
// $003886: ?'s Weapon Slot equipped
// $003899: ?'s Weapon Slot equipped
// $0038AC: ?'s Weapon Slot equipped
// $0038BF: ?'s Weapon Slot equipped
// $0038D2: ?'s Weapon Slot equipped
// $0038E5: ?'s Weapon Slot equipped
// $0038F8: ?'s Weapon Slot equipped
// $00390B: ?'s Weapon Slot equipped
// $00391E: ?'s Weapon Slot equipped
// $003931: ?'s Weapon Slot equipped
// $003944: ?'s Weapon Slot equipped
// $003957: ?'s Weapon Slot equipped
// $00396A: ?'s Weapon Slot equipped
// $00397D: ?'s Weapon Slot equipped
// $003990: ?'s Weapon Slot equipped
// $0039A3: ?'s Weapon Slot equipped
// $0039B6: ?'s Weapon Slot equipped
// $0039C9: ?'s Weapon Slot equipped
// $0039DC: ?'s Weapon Slot equipped
// $0039EF: ?'s Weapon Slot equipped
// $003A02: ?'s Weapon Slot equipped
// $003A15: ?'s Weapon Slot equipped
// $003A28: ?'s Weapon Slot equipped
// $003A3B: ?'s Weapon Slot equipped
// $003A4E: ?'s Weapon Slot equipped
// $003A61: Sylvia's Weapon Slot equipped
function sylviaInventoryCountAddr() => 0x003a62
// $003A74: Lewyn's Weapon Slot equipped
function lewynInventoryCountAddr() => 0x003a75
// $003A87: ?'s Weapon Slot equipped
// $003A9A: ?'s Weapon Slot equipped
// $003AAD: Raquesis's Weapon Slot equipped
function raquesisInventoryCountAddr() => 0x003aae
function raquesisInventoryCount() => byte(raquesisInventoryCountAddr())

function raquesisInventorySlot1() => byte(0x003ab2)
// $003AC0: ?'s Weapon Slot equipped
// $003AD3: ?'s Weapon Slot equipped
// $003AE6: Dew's Weapon Slot equipped
function dewInventoryCountAddr() => 0x003ae7
// $003AF9: ?'s Weapon Slot equipped
// $003B0C: ?'s Weapon Slot equipped
// $003B1F: ?'s Weapon Slot equipped
// $003B32: ?'s Weapon Slot equipped
// $003B45: ?'s Weapon Slot equipped
// $003B58: Quan's Weapon Slot equipped
function quanInventoryCountAddr() => 0x003b59
// $003B6B: Lex's Weapon Slot equipped
function lexInventoryCountAddr() => 0x003b6c

// $003B7E: ?'s Weapon Slot equipped
// $003B91: ?'s Weapon Slot equipped
// $003BA4: ?'s Weapon Slot equipped
// $003BB7: Noish's Weapon Item no. equipped?!
// $003BB8: Noish number of items in inventory
// $003BCA: Sigurd's Weapon Slot equipped
// $003BCB: Sigurd's  Inventory Quantity
function sigurdInventoryCountAddr() => 0x003bcb
// $003BCC: Sigurd's 1st item ID
// $003BCD: Sigurd's 2nd item ID
// $003BCE: Sigurd's 3rd item ID
// $003BCF: Sigurd's 4th item ID
// $003BD0: Sigurd's 5th item ID
// $003BD1: Sigurd's 6th item ID
// $003BD2: Sigurd's 7th item ID
// $003BE5: [2 Byte] *Love Points: Taillte / Sigurd [Fee / Seliph]
// $003BE7: [2 Byte] Love Points: Taillte / Noish
// $003BE9: [2 Byte] Love Points: Taillte / Alec
// $003BEB: [2 Byte] Love Points: Taillte / Arden
// $003BED: [2 Byte] Love Points: Taillte / Finn
// $003BEF: [2 Byte] *Love Points: Taillte / Quan
// $003BF1: [2 Byte] Love Points: Taillte / Midir
// $003BF3: [2 Byte] Love Points: Taillte / Lewyn
// $003BF5: [2 Byte] Love Points: Taillte / Holyn
// $003BF7: [2 Byte] Love Points: Taillte / Azel
// $003BF9: [2 Byte] Love Points: Taillte / Jamke
// $003BFB: [2 Byte] Love Points: Taillte / Claude
// $003BFD: [2 Byte] Love Points: Taillte / Beowolf
// $003BFF: [2 Byte] Love Points: Taillte / Lex
// $003C01: [2 Byte] Love Points: Taillte / Dew
// $003C09: [2 Byte] *Love Points: Bridget / Sigurd [Lana / Seliph]
// $003C0B: [2 Byte] Love Points: Bridget / Noish
// $003C0D: [2 Byte] Love Points: Bridget / Alec
// $003C0F: [2 Byte] Love Points: Bridget / Arden
// $003C11: [2 Byte] Love Points: Bridget / Finn
// $003C13: [2 Byte] *Love Points: Bridget / Quan
// $003C15: [2 Byte] Love Points: Bridget / Midir
// $003C17: [2 Byte] Love Points: Bridget / Lewyn
// $003C19: [2 Byte] Love Points: Bridget / Holyn
// $003C1B: [2 Byte] Love Points: Bridget / Azel
// $003C1D: [2 Byte] Love Points: Bridget / Jamke
// $003C1F: [2 Byte] Love Points: Bridget / Claude
// $003C21: [2 Byte] Love Points: Bridget / Beowolf
// $003C23: [2 Byte] Love Points: Bridget / Lex
// $003C25: [2 Byte] Love Points: Bridget / Dew
// $003C2D: [2 Byte] Love Points: Erin / Sigurd [Larcei / Seliph]
// $003C51: [2 Byte] Love Points: Sylvia / Sigurd [ ? / Seliph]
// $003C75: [2 Byte] Love Points: Raquesis / Sigurd [Julia / Seliph]
// $003C99: [2 Byte] Love Points: Deidre / Sigurd [Altena? / Seliph]
// $003CBD: [2 Byte] Love Points: Aideen / Sigurd [ ? / Seliph]
// $003CE1: [2 Byte] Love Points: Ayra / Sigurd [? / Seliph]
// $003D05: [2 Byte] Love Points: Ethlyn / Sigurd [Patty / Seliph]

// $003D23: [2 Byte] Sigurd - Kills
function sigurdKills() => word(0x003D23)

// $003D25: [2 Byte] Noish - Kills
// $003D27: [2 Byte] Alec - Kills
// $003D29: [2 Byte] Arden - Kills
// $003D2B: [2 Byte] Finn - Kills
// $003D2D: [2 Byte] Quan - Kills
// $003D2F: [2 Byte] Midir - Kills
// $003D31: [2 Byte] Lewyn - Kills
// $003D33: [2 Byte] Holyn - Kills
// $003D35: [2 Byte] Azel - Kills
// $003D37: [2 Byte] Jamke - Kills
// $003D39: [2 Byte] Claude - Kills
// $003D3B: [2 Byte] Beowolf - Kills
// $003D3D: [2 Byte] Lex - Kills
// $003D3F: [2 Byte] Dew - Kills
// $003D41: [2 Byte] Deirdre - Kills
// $003D43: [2 Byte] Ethlyn - Kills
// $003D45: [2 Byte] Raquesis - Kills
// $003D47: [2 Byte] Ayra - Kills
// $003D49: [2 Byte] Erin - Kills
// $003D4B: [2 Byte] Taillte - Kills
// $003D4D: [2 Byte] Sylvia - Kills
// $003D4F: [2 Byte] Aideen - Kills
// $003D51: [2 Byte] Bridget - Kills
// $003D53: [2 Byte] Seliph - Kills
// $003D55: [2 Byte] Shanan - Kills
// $003D57: [2 Byte] Ulster - Kills
// $003D59: [2 Byte] Faval - Kills
// $003D5B: [2 Byte] Leif - Kills
// $003D5D: [2 Byte] Johan - Kills
// $003D5F: [2 Byte] Cairpre - Kills
// $003D61: [2 Byte] Ced - Kills
// $003D63: [2 Byte] Dermott - Kills
// $003D65: [2 Byte] Finn - Kills
// $003D67: [2 Byte] Lester - Kills
// $003D69: [2 Byte] Hannibal - Kills
// $003D6B: [2 Byte] Ares - Kills
// $003D6D: [2 Byte] Arthur - Kills
// $003D6F: [2 Byte] Oifey - Kills
// $003D71: [2 Byte] Patty - Kills
// $003D73: [2 Byte] Larcei - Kills
// $003D75: [2 Byte] Lana - Kills
// $003D77: [2 Byte] Julia - Kills
// $003D79: [2 Byte] Altena - Kills
// $003D7B: [2 Byte] Fee - Kills
// $003D7D: [2 Byte] Tinni - Kills
// $003D7F: [2 Byte] Lene - Kills
// $003D81: [2 Byte] Nanna - Kills
// $003D83: [2 Byte] Player Rank - Experience (collective exp of all characters)
function experiencePlayerRank() => word(0x3D83)
// $003D85: Player Rank - Survival (characters joined and alive)
function survivalPlayerRank() => word(0x3D85)
// $003D8B: Weapon 01 - ID
// $003D8C: Weapon 01 - Usage
// $003D8D: Weapon 01 - Location
// $003D90: Weapon 01 - Kills
// $003D91: Weapon 02 - ID
// $003D97: Weapon 03 - ID
// $003D9D: Weapon 04 - ID
// $003DA3: Weapon 05 - ID
// $003DA9: Weapon 06 - ID
// $003DAF: Weapon 07 - ID
// $003DB5: Weapon 08 - ID
// $003DBB: Weapon 09 - ID
// $003DC1: Weapon 10 - ID
// $00438D: Character Status - Claude (START?)
// $004419: Character Status - Sigurd/Fiin(2) (END?)
// $00441D: X coord - Claude (START?)
// $00441F: X coord - Taillte
// $004451: X coord - Holyn
// $004453: X coord - Sylvia
// $004455: X coord - Lewyn
// $004457: X coord - Jamke
// $004459: X coord - Midir
// $00445D: X coord - Finn
// $004471: X coord - Dew
// $004473: X coord - Aideen
// $00447D: X coord - ?/Hannibal
// $00447F: X coord - ?/Ares
// $004481: X coord - Erin/Shanan
// $004483: X coord - Oifey/Julia
// $004485: X coord - ?/Johan-lven
// $004487: X coord - Lex/Nanna
// $004489: X coord - Azel/Dermott
// $00448B: X coord - ?/Larcei
// $00448D: X coord - ?/Ulster
// $00448F: X coord - ?/Fee
// $004491: X coord - ?/Ced
// $004493: X coord - ?/Tinni
// $004495: X coord - ?/Arthur
// $004497: X coord - ?/Lene
// $004499: X coord - Ayra/Cairpre
// $00449B: X coord - ?/Lana
// $00449D: X coord - ?/Lester
// $00449F: X coord - ?/Patty
// $0044A1: X coord - Bridget/Faval
// $0044A3: X coord - Arden/Altena
// $0044A5: X coord - Alec/Leif
// $0044A7: X coord - Noish/Seliph
// $0044A9: X coord - Sigurd/Finn(2)
// $0044AD: Y coord - Claude (START?)
// $0044AF: Y coord - Taillte
// $0044C5: X coord - Deirdre
// $0044E1: Y coord - Holyn
// $0044E3: Y coord - Sylvia
// $0044E5: Y coord - Lewyn
// $0044E7: Y coord - Jamke
// $0044E9: Y coord - Midir
// $0044ED: Y coord - Finn
// $004501: Y coord - Dew
// $004503: Y coord - Aideen
// $00450D: Y coord - ?/Hannibal
// $00450F: Y coord - ?/Ares
// $004511: Y coord - Erin/Shanan
// $004513: Y coord - Oifey/Julia
// $004515: Y coord - ?/Johan-vier
// $004517: Y coord - Lex/Nanna
// $004519: Y coord - Azel/Dermott
// $00451B: Y coord - ?/Larcei
// $00451D: Y coord - ?/Ulster
// $00451F: Y coord - ?/Fee
// $004521: Y coord - ?/Ced
// $004523: Y coord - ?/Tinni
// $004525: Y coord - ?/Arthur
// $004527: Y coord - ?/Lene
// $004529: Y coord - Ayra/Cairpre
// $00452B: Y coord - ?/Lana
// $00452D: Y coord - ?/Lester
// $00452F: Y coord - ?/Patty
// $004531: Y coord - Bridget/Faval
// $004533: Y coord - Arden/Altena
// $004535: Y coord - Alec/Leif
// $004537: Y coord - Noish/Seliph
// $004539: Y coord - Sigurd/Finn(2)
// $004555: Y coord - Deirdre

// $004E45: Building 0 attributes
//
//          Bits 0-2 = affiliation
//          Bit 3 = razed (especially if a village)
//          Bit 5 = rescued (especially if a village)
//          Bit 7 = unit garrisoned (especially if a keep)
function baseBuildingAddr() => 0x004E45
function building0Attr() => byte(baseBuildingAddr())

// $004E46: Building 01 - attributes: 1-7=Affiliation?, 20=Village Rescued, 40=Castle Seized
function building1Attr() => byte(baseBuildingAddr() + 1)

// $004E47: Building 02 - attributes
// $004E48: Building 03 - attributes
// $004E49: Building 04 - attributes
// $004E4A: Building 05 - attributes
// $004E4B: Building 06 - attributes
// $004E4C: Building 07 - attributes
// $004E4D: Building 08 - attributes
// $004E4E: Building 09 - attributes
// $004E4F: Building 10 - attributes
// $004E50: Building 11 - attributes
// $004E51: Building 12 - attributes
// $004E52: Building 13 - attributes
// $004E53: Building 14 - attributes
// $004E54: Building 15 - attributes
// $004E55: Building 16? - attributes

function GetBuildingAttrAddrBySlot(slotId)
{
    return baseBuildingAddr() + slotId
}

// $004EC5: Player - Current Hp
function forecastPlayerHP() => word(0x004EC5)

// $004EC7: Player - Total Hp
function forecastPlayerMaxHP() => word(0x004EC7)

// $004EC9: [2 Byte] Player - Level
function forecastPlayerLV() => word(0x004EC9)

// $004EE7: [2 Byte] Player - Hit
function forecastPlayerHit() => word(0x004EE7)

// $004EEF: [2 Byte] Player - Attack
function forecastPlayerAttack() => word(0x004EEF)

// $004EF1: [2 Byte] Player - Defense
function forecastPlayerDefense() => word(0x004EF1)

// $004F25: Enemy - Current Hp
function forecastEnemyHP() => word(0x004F25)

// $004F27: Enemy - Total Hp
function forecastEnemyMaxHP() => word(0x004F27)

// $004F29: [2 Byte] Enemy - Level
function forecastEnemyLV() => word(0x004F29)

// $004F47: [2 Byte] Enemy - Hit
function forecastEnemyHit() => word(0x004F47)

// $004F4F: [2 Byte] Enemy - Attack
function forecastEnemyAttack() => word(0x004F4F)

// $004F51: [2 Byte] Enemy - Defense
function forecastEnemyDefense() => word(0x004F51)

// $000302: 0x2 = booting
//          0x3 (while 0x000304 == 0x0) = Nintendo logo
//          0x5 (0x000304 == 0) = main menu
//          0x6 (while 0x000304 is various values) = main menu
//          0x12 (while 0x000304 == 0x7) = viewing map grid
//          0x1b (while 0x000304 == 0x0) = opening, title screen
function state1() => byte(0x000302)

// $000304: Appears to determine state.
//
//          Setting to 4 on the main menu will load a game as if from a save file.
//
//          0x8 = loading a game (if on the load menu)
function state2() => byte(0x000304)

function IsPlayerRankShown() => state1() == 0x37 && state2() == 0x10

function IsOutsideGameplay() => state1() == 0x2 || state1() == 0x3 && state2() == 0x0 || state1() == 0x5 && state2() == 0x0
    || state1() == 0x6 || state1() == 0x1b && state2() == 0x0

function IsLoadingSaveFile() => state2() == 0x8 || state2() == 0x23

// 0x55 on immediate boot is unique to the Snes9x line of cores.
function IsBooting() => state1() == 0x2 || state1() == 0x3 && state2() == 0x0 || state1() == 0x55

// This function allows the creation of achievements with built-in save protection that deal with a collection of values being set
// throughout the game. The schemas for both parameters are as follows:
//
// cheevo: "name": title
//         "description": self-explanatory
//         "points": self-explanatory
//         "threshold": how many values in the "addresses" dictionary must be set before this achievement is triggered
//         "id": the ID of the achievement on the RA server
//
// conditions: "countsWhen": the condition that must be true in order for it to be counted in the total
//             "recalculateWhen": the condition that indicates that relevant values in the condition have changed,
//                                and so everything must be recalculated
function GenerateSaveProtectedAchievementFromConditions(cheevo, conditions)
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

    achievement(title = cheevo["name"], description = cheevo["description"], points = cheevo["points"], id = cheevo["id"],
        trigger = !IsLoadingSaveFile() && never(IsBooting())
            && measured(tally(cheevo["threshold"], totalCounts)) && unless(tally(cheevo["threshold"], loadedCounts))
            && never(resetAlt)
    )
}

// $0052A3: 01=Related to credits?
// $0052BB: Chapter (copy)
// $0084D4: Something at unit screen
// $008514: Something at unit screen
// $018400: Option Settings - Menu Position
// $018402: Option Settings - Animations: 0=On, 1=Off, 2=By Unit
// $018404: Option Settings - Terrain Window: 0=On, 1=Off
// $018406: Option Settings - Unit Window: 0=On, 1=Off
// $018408: Option Settings - Text Speed
// $01840A: Option Settings - Enemy Speed: 0=Normal, 1=Fast
// $01840C: Option Settings - Audio Settings: 0=Stereo, 1=Mono, 2=Off
// $01840E: Option Settings - Auto Save: 0=Off, n=File N
// $018410: Option Settings - Auto Cursor: 0=On, 1=Off
// $018412: Option Settings - Enemy AI Level: 0=Normal, 1=Clever

gen1UnitMetadata = {
"Sigurd": { "index": 0, "name": "Sigurd", "mandatedRomance": 1, "deathStatusIndex": 0, }, 
"Noish": { "index": 1, "name": "Noish", "mandatedRomance": 0, "deathStatusIndex": 1, }, 
"Alec": { "index": 2, "name": "Alec", "mandatedRomance": 0, "deathStatusIndex": 2, }, 
"Arden": { "index": 3, "name": "Arden", "mandatedRomance": 0, "deathStatusIndex": 3, }, 
"Azel": { "index": 4, "name": "Azel", "mandatedRomance": 0, "deathStatusIndex": 9, }, 
"Lex": { "index": 5, "name": "Lex", "mandatedRomance": 0, "deathStatusIndex": 13, }, 
"Quan": { "index": 6, "name": "Quan", "mandatedRomance": 1, "deathStatusIndex": 5, }, 
"Finn": { "index": 7, "name": "Finn", "mandatedRomance": 0, "deathStatusIndex": 4, }, 
"Ethlyn": { "index": 8, "name": "Ethlyn", "mandatedRomance": 1, "deathStatusIndex": 16, }, 
"Midir": { "index": 9, "name": "Midir", "mandatedRomance": 0, "deathStatusIndex": 6, }, 
"Ayra": { "index": 10, "name": "Ayra", "mandatedRomance": 0, "deathStatusIndex": 18, }, 
"Aideen": { "index": 11, "name": "Aideen", "mandatedRomance": 0, "deathStatusIndex": 22, }, 
"Dew": { "index": 12, "name": "Dew", "mandatedRomance": 0, "deathStatusIndex": 14, }, 
"Jamke": { "index": 13, "name": "Jamke", "mandatedRomance": 0, "deathStatusIndex": 10, }, 
"Deirdre": { "index": 14, "name": "Deirdre", "mandatedRomance": 1, "deathStatusIndex": 15, }, 
"Raquesis": { "index": 15, "name": "Raquesis", "mandatedRomance": 0, "deathStatusIndex": 17, }, 
"Holyn": { "index": 16, "name": "Holyn", "mandatedRomance": 0, "deathStatusIndex": 8, }, 
"Beowulf": { "index": 17, "name": "Beowulf", "mandatedRomance": 0, "deathStatusIndex": 12, }, 
"Lewyn": { "index": 18, "name": "Lewyn", "mandatedRomance": 0, "deathStatusIndex": 7, }, 
"Sylvia": { "index": 19, "name": "Sylvia", "mandatedRomance": 0, "deathStatusIndex": 21, }, 
"Erin": { "index": 20, "name": "Erin", "mandatedRomance": 0, "deathStatusIndex": 19, }, 
"Bridget": { "index": 21, "name": "Bridget", "mandatedRomance": 0, "deathStatusIndex": 23, }, 
"Taillte": { "index": 22, "name": "Taillte", "mandatedRomance": 0, "deathStatusIndex": 20, }, 
"Claude": { "index": 23, "name": "Claude", "mandatedRomance": 0, "deathStatusIndex": 11, }, 
}

gen2UnitMetadata = {
"Seliph": { "index": 0, "name": "Seliph", "mandatedRomance": 0, "deathStatusIndex": 24, "bred": 0, }, 
"Leif": { "index": 1, "name": "Leif", "mandatedRomance": 0, "deathStatusIndex": 28, "bred": 0, }, 
"Altena": { "index": 2, "name": "Altena", "mandatedRomance": 0, "deathStatusIndex": 43, "bred": 0, }, 
"Faval": { "index": 3, "name": "Faval", "mandatedRomance": 0, "deathStatusIndex": 50, "bred": 1, }, 
"Patty": { "index": 4, "name": "Patty", "mandatedRomance": 0, "deathStatusIndex": 56, "bred": 1, }, 
"Lester": { "index": 5, "name": "Lester", "mandatedRomance": 0, "deathStatusIndex": 54, "bred": 1, }, 
"Lana": { "index": 6, "name": "Lana", "mandatedRomance": 0, "deathStatusIndex": 58, "bred": 1, }, 
"Cairpre": { "index": 7, "name": "Cairpre", "mandatedRomance": 0, "deathStatusIndex": 51, "bred": 1, }, 
"Lene": { "index": 8, "name": "Lene", "mandatedRomance": 0, "deathStatusIndex": 61, "bred": 1, }, 
"Arthur": { "index": 9, "name": "Arthur", "mandatedRomance": 0, "deathStatusIndex": 55, "bred": 1, }, 
"Tinni": { "index": 10, "name": "Tinni", "mandatedRomance": 0, "deathStatusIndex": 60, "bred": 1, }, 
"Ced": { "index": 11, "name": "Ced", "mandatedRomance": 0, "deathStatusIndex": 52, "bred": 1, }, 
"Fee": { "index": 12, "name": "Fee", "mandatedRomance": 0, "deathStatusIndex": 59, "bred": 1, }, 
"Ulster": { "index": 13, "name": "Ulster", "mandatedRomance": 0, "deathStatusIndex": 49, "bred": 1, }, 
"Larcei": { "index": 14, "name": "Larcei", "mandatedRomance": 0, "deathStatusIndex": 57, "bred": 1, }, 
"Dermott": { "index": 15, "name": "Dermott", "mandatedRomance": 0, "deathStatusIndex": 53, "bred": 1, }, 
"Nanna": { "index": 16, "name": "Nanna", "mandatedRomance": 0, "deathStatusIndex": 62, "bred": 1, }, 
"Shanan": { "index": 17, "name": "Shanan", "mandatedRomance": 0, "deathStatusIndex": 25, "bred": 0, }, 
"Rodolbahn": { "index": 18, "name": "Rodolbahn", "mandatedRomance": 0, "deathStatusIndex": 26, "bred": 0, }, 
"Asaello": { "index": 19, "name": "Asaello", "mandatedRomance": 0, "deathStatusIndex": 27, "bred": 0, }, 
"Johan": { "index": 20, "name": "Johan", "mandatedRomance": 0, "deathStatusIndex": 29, "bred": 0, }, 
"Sharlow": { "index": 21, "name": "Sharlow", "mandatedRomance": 0, "deathStatusIndex": 30, "bred": 0, }, 
"Hawke": { "index": 22, "name": "Hawke", "mandatedRomance": 0, "deathStatusIndex": 31, "bred": 0, }, 
"Tristan": { "index": 23, "name": "Tristan", "mandatedRomance": 0, "deathStatusIndex": 32, "bred": 0, }, 
"Dimna": { "index": 24, "name": "Dimna", "mandatedRomance": 0, "deathStatusIndex": 34, "bred": 0, }, 
"Hannibal": { "index": 25, "name": "Hannibal", "mandatedRomance": 0, "deathStatusIndex": 35, "bred": 0, }, 
"Ares": { "index": 26, "name": "Ares", "mandatedRomance": 0, "deathStatusIndex": 36, "bred": 0, }, 
"Amid": { "index": 27, "name": "Amid", "mandatedRomance": 0, "deathStatusIndex": 37, "bred": 0, }, 
"Oifey": { "index": 28, "name": "Oifey", "mandatedRomance": 0, "deathStatusIndex": 38, "bred": 0, }, 
"Daisy": { "index": 29, "name": "Daisy", "mandatedRomance": 0, "deathStatusIndex": 39, "bred": 0, }, 
"Radney": { "index": 30, "name": "Radney", "mandatedRomance": 0, "deathStatusIndex": 40, "bred": 0, }, 
"Mana": { "index": 31, "name": "Mana", "mandatedRomance": 0, "deathStatusIndex": 41, "bred": 0, }, 
"Julia": { "index": 32, "name": "Julia", "mandatedRomance": 0, "deathStatusIndex": 42, "bred": 0, }, 
"Femina": { "index": 33, "name": "Femina", "mandatedRomance": 0, "deathStatusIndex": 44, "bred": 0, }, 
"Linda": { "index": 34, "name": "Linda", "mandatedRomance": 0, "deathStatusIndex": 45, "bred": 0, }, 
"Leylia": { "index": 35, "name": "Leylia", "mandatedRomance": 0, "deathStatusIndex": 46, "bred": 0, }, 
"Jeanne": { "index": 36, "name": "Jeanne", "mandatedRomance": 0, "deathStatusIndex": 47, "bred": 0, }, 
"Johalvier": { "index": 37, "name": "Johalvier", "mandatedRomance": 0, "deathStatusIndex": 48, "bred": 0, }, 
"Finn (older)": { "index": 38, "name": "Finn (older)", "mandatedRomance": 0, "deathStatusIndex": 33, "bred": 0, }, 
}

function GetGen1UnitMetadataByIndex(index)
{
    for name in gen1UnitMetadata
    {
        meta = gen1UnitMetadata[name]
        if (meta["index"] == index)
        {
            return meta
        }
    }
}

function GetGen2UnitMetadataByIndex(index)
{
    for name in gen2UnitMetadata
    {
        meta = gen2UnitMetadata[name]
        if (meta["index"] == index)
        {
            return meta
        }
    }
}

function GetBredBiologicalChildren()
{
    substitutes = []
    for name in gen2UnitMetadata
    {
        meta = gen2UnitMetadata[name]
        if (meta["bred"] == 1)
        {
            array_push(substitutes, meta)
        }
    }
    
    return substitutes
}

function GetGen1UnitObjectByName(name)
{
    meta = gen1UnitMetadata[name]
    return GetGen1UnitObjectByIndex(meta["index"])
}

// Do Gen 1 unit-related things here.
gen1UnitLeveledUpTo10 = always_false()
gen1UnitLeveledUpTo30 = always_false()
gen1UnitMaxedOutArena = always_false()
gen1UnitChangedClass = always_false()
gen1OptionalUnitFellInLove = always_false()
gen2UnitLeveledUpTo10 = always_false()
gen2UnitLeveledUpTo30 = always_false()
gen2UnitMaxedOutArena = always_false()
gen2UnitChangedClass = always_false()
gen2UnitFellInLove = always_false()
for i in range(0, 23)
{
    unit = GetGen1UnitObjectByIndex(i)
    unitMeta = GetGen1UnitMetadataByIndex(i)
    
    gen1UnitLeveledUpTo10 = gen1UnitLeveledUpTo10 || WasValueSetInGame(unit["level"], 9, 10)
    gen1UnitLeveledUpTo30 = gen1UnitLeveledUpTo30 || WasValueSetInGame(unit["level"], 29, 30)
    gen1UnitMaxedOutArena = gen1UnitMaxedOutArena || WasValueSetInGame(unit["arenaLevel"], 6, 7)
    gen1UnitChangedClass = gen1UnitChangedClass || once(Delta(unit["class"]) != unit["class"] && Delta(unit["header"]) == 0x7e)
        // We need to check for header being equal to 0x7e to ensure the achievement doesn't pop the moment a unit's level loads into memory.
        && never(!TurnNumberIsPlausible())
        && unit["class"] != 0x0 && never(IsLoadingSaveFile())
    
    if (unitMeta["mandatedRomance"] == 0)
    {
        gen1OptionalUnitFellInLove = gen1OptionalUnitFellInLove || once(Delta(unit["lover"]) != unit["lover"] && Delta(unit["lover"]) == 0x0)
            && unit["lover"] != 0x0 && never(IsLoadingSaveFile())
    }
}

for i in range(0, 16)
{
    unit = GetGen2UnitObjectByIndex(i)
    unitMeta = GetGen2UnitMetadataByIndex(i)
    
    gen2UnitLeveledUpTo10 = gen2UnitLeveledUpTo10 || WasValueSetInGame(unit["level"], 9, 10)
    gen2UnitLeveledUpTo30 = gen2UnitLeveledUpTo30 || WasValueSetInGame(unit["level"], 29, 30)
    gen2UnitMaxedOutArena = gen2UnitMaxedOutArena || WasValueSetInGame(unit["arenaLevel"], 6, 7)
    gen2UnitChangedClass = gen2UnitChangedClass || once(Delta(unit["class"]) != unit["class"] && Delta(unit["header"]) == 0x7e)
        // We need to check for header being equal to 0x7e to ensure the achievement doesn't pop the moment a unit's level loads into memory.
        && chapter() > 5
        && unit["class"] != 0x0 && never(IsLoadingSaveFile()) && never(!TurnNumberIsPlausible())
    
    if (unitMeta["mandatedRomance"] == 0)
    {
        gen2UnitFellInLove = gen2UnitFellInLove || once(Delta(unit["lover"]) != unit["lover"] && Delta(unit["lover"]) == 0x0)
            && unit["lover"] != 0x0 && never(IsLoadingSaveFile())
    }
}

achievement(title = "It Gets Harder", points = 3, id = 130693, badge = "143890",
    description = "Raise a unit to Level 10.",
    trigger = gen1UnitLeveledUpTo10 || gen2UnitLeveledUpTo10
)

achievement(title = "The Key to Mastery", points = 5, id = 130731, badge = "143928",
    description = "Raise a unit to Level 30.",
    trigger = gen1UnitLeveledUpTo30 || gen2UnitLeveledUpTo30
)

achievement(title = "The Culmination of Years of Training!", points = 5, badge = "143910", id = 130713,
    description = "Change a unit's class.",
    trigger = gen1UnitChangedClass || gen2UnitChangedClass
)

achievement(title = "That Special Someone", points = 5,
    description = "Have two units fall in love with each other, excluding predetermined romances.",
    trigger = gen1OptionalUnitFellInLove || gen2UnitFellInLove
)

achievement(title = "Gladiator", description = "Max out a unit's arena level.", id = 130704, badge = "143901",
    points = 5,
    trigger = gen1UnitMaxedOutArena || gen2UnitMaxedOutArena
)

function GetRescuableVillagesByChapterIds(chapterIds)
{
    rescueConditions = {}
    rescueConditionIndex = 0
    for i in chapterIds
    {
        chapter = chapters[i]
        for j in chapter["rescuableVillageSlotIds"]
        {
            buildingAttrAddr = GetBuildingAttrAddrBySlot(j)
            rescueConditions[rescueConditionIndex]
                = { "countsWhen": (bit5(buildingAttrAddr) == 1 && chapter() == i && TurnNumberIsPlausible()), "recalculateWhen": (Delta(bit5(buildingAttrAddr)) != bit5(buildingAttrAddr)) }
            rescueConditionIndex = rescueConditionIndex + 1
        }
    }
    
    return rescueConditions
}

function GetSeizableKeepsByChapterIds(chapterIds)
{
    rescueConditions = always_false()
    rescueConditionIndex = 0
    for i in chapterIds
    {
        chapter = chapters[i]
        for j in chapter["keepIds"]
        {
            buildingAttrAddr = GetBuildingAttrAddrBySlot(j)
            rescueConditions = rescueConditions || PlayerHasCapturedKeepBySlot(j) && chapter() == i
        }
    }
    
    return rescueConditions
}

function PlayerHasCapturedKeepBySlot(slotId)
{
    buildingAttrAddr = GetBuildingAttrAddrBySlot(slotId)
    return KeepIsUnderControlByPlayer(slotId)
                && Delta(bit6(buildingAttrAddr)) == 0 && WasBitflagSetInGame(bit6(buildingAttrAddr))
}

function KeepIsUnderControlByPlayer(slotId)
{
    buildingAttrAddr = GetBuildingAttrAddrBySlot(slotId)
    return bit0(buildingAttrAddr) == 0 && bit1(buildingAttrAddr) == 0 && bit2(buildingAttrAddr) == 0
}

GenerateSaveProtectedAchievementFromConditions({
    "name": "Village Savior",
    "description": "Rescue a village before it is razed to the ground.",
    "points": 1,
    "threshold": 1,
    "id": 130690,
    "badge": 143887,
}, GetRescuableVillagesByChapterIds(GetChapterIds()))

achievement(title = "Conqueror", points = 1, id = 130694, badge = "143891",
    description = "Seize a keep from an enemy faction's control.",
    trigger = GetSeizableKeepsByChapterIds(GetChapterIds()) && never(IsBooting())
)

// VILLAGE ACHIEVEMENTS

villageCheevos = {
    0: { "name": "Defender of Chalphy", "description": "Rescue all villages in the Prologue.", "points": 5, "id": 130691 },
    1: { "name": "Verdanite Annexation", "description": "Rescue all villages in Chapter 1.", "points": 5, "id": 130697 },
    2: { "name": "Nordion Calls for Aid", "description": "Rescue all villages in Chapter 2.", "points": 10, "id": 130706 },
    3: { "name": "Pirates of Orgahil", "description": "Rescue all villages in Chapter 3.", "points": 10, "id": 130714 },
    4: { "name": "Frozen Demolition", "description": "Rescue all villages in Chapter 4.", "points": 10, "id": 130721 },
    5: { "name": "Traveler of Belhalla", "description": "Rescue all villages in Chapter 5.", "points": 5, "id": 130727 },
    6: { "name": "The Liberation of Isaach", "description": "Rescue all villages in Chapter 6.", "points": 10, "id": 130735 },
    7: { "name": "Oasis Rescue", "description": "Rescue all villages in Chapter 7.", "points": 5, "id": 130741 },
    8: { "name": "Thracia's Plea", "description": "Rescue all villages in Chapter 8.", "points": 5, "id": 130747 },
    9: { "name": "The City's Evacuation", "description": "Rescue all villages in Chapter 9.", "points": 3, "id": 130752 },
    10: { "name": "Adoration of the New Crusaders", "description": "Rescue all villages in Chapter 10.", "points": 3, "id": 130757 },
    11: { "name": "Grannvale Spared", "description": "Rescue all villages in the final chapter.", "points": 3, "id": 130762 },
}

for i in villageCheevos
{
    cheevo = villageCheevos[i]
    villages = GetRescuableVillagesByChapterIds([ i ])
    GenerateSaveProtectedAchievementFromConditions({
        "name": (cheevo["name"] + " [m]"),
        "description": cheevo["description"],
        "points": cheevo["points"],
        "threshold": length(villages),
        "id": cheevo["id"]
    }, villages)
}

// End village achievements

// CHAPTER-RELATED CHEEVOS
blitzkriegCheevos = {
    0: { "turnLimit": 15, "points": 5, "id": 130695 }, // my record: 21 turns
    1: { "turnLimit": 35, "points": 5, "id": 130701 }, // my record: 40 turns
    2: { "turnLimit": 42, "points": 10, "id": 130711 }, // my record: 51 turns
    3: { "turnLimit": 38, "points": 5, "id": 130719 }, // my record: 40 turns
    4: { "turnLimit": 40, "points": 5, "id": 130723 }, // my record: 40 turns
    5: { "turnLimit": 30, "points": 10, "id": 130732 }, // my record: 45 turns
    6: { "turnLimit": 33, "points": 5, "id": 130739 }, // my record: 38 turns
    7: { "turnLimit": 44, "points": 10, "id": 130745 }, // my record: 55 turns
    8: { "turnLimit": 25, "points": 5, "id": 130750 }, // my record: 25 turns
    9: { "turnLimit": 34, "points": 25, "id": 130755 }, // my record: 53 turns
    10: { "turnLimit": 24, "points": 10, "id": 130759 }, // my record: 35 turns
    11: { "turnLimit": 36, "points": 25, "id": 130764 }, // my record: 57 turns
}

chapterCheevos = {
    0: { "name": "And So the Crusade Begins", "description": "Complete the prologue.", "points": 3, "id": 130696 },
    1: { "name": "The Red Twine Unravels", "description": "", "points": 3, "id": 130702 },
    2: { "name": "The Agustrian Occupation", "description": "", "points": 3, "id": 130703 },
    3: { "name": "Another Such Victory and We Are Undone", "description": "", "points": 3, "id": 130720 },
    4: { "name": "The Reunification of Silesse", "description": "", "points": 3, "id": 130724 },
    5: { "name": "Night Is Darkest", "description": "", "points": 3, "id": 130726 },
    6: { "name": "From the Brink", "description": "", "points": 3, "id": 130740 },
    7: { "name": "Merging of Theatres", "description": "", "points": 3, "id": 130746 },
    8: { "name": "An Unpleasant Peninsula Around You", "description": "", "points": 3, "id": 130751 },
    9: { "name": "For Those We've Lost", "description": "", "points": 3, "id": 130760 },
    10: { "name": "The Light Returns Home", "description": "", "points": 3, "id": 130761 },
}

for i in blitzkriegCheevos
{
    chapter = chapters[i]
    cheevo = blitzkriegCheevos[i]
    turnsElapsed = word(turnsElapsedInPrologueBaseAddr() + 2 * i)
    achievement(title = "Blitzkrieg (" + chapter["pretitle"] + ") [m]", points = cheevo["points"], id = cheevo["id"],
        description = "Complete '" + chapter["name"] + "' within " + cheevo["turnLimit"] + " turns.",
        trigger = chapter() == i && Delta(turnsElapsed) == 0 && turnsElapsed > 0 && turnsElapsed <= cheevo["turnLimit"] && never(IsLoadingSaveFile())
    )
    
    leaderboard(title = chapter["pretitle"] + ": " + chapter["name"], description = "Complete the chapter in as few turns as possible.",
        start = chapter() == i && Delta(turnsElapsed) == 0 && turnsElapsed > 0 && never(IsLoadingSaveFile()),
        cancel = IsLoadingSaveFile(),
        submit = chapter() == i && Delta(turnsElapsed) == 0 && turnsElapsed > 0 && never(IsLoadingSaveFile()),
        value = turnsElapsed
    )
}

for i in chapterCheevos
{
    chapter = chapters[i]
    cheevo = chapterCheevos[i]
    turnsElapsed = word(turnsElapsedInPrologueBaseAddr() + 2 * i)
    description = ""
    if (cheevo["description"] == "")
    {
        description = "Complete " + chapter["pretitle"] + "."
    }
    else
    {
        description = cheevo["description"]
    }
    
    achievement(title = cheevo["name"], points = cheevo["points"],
        description = description,
        trigger = chapter() == i && Delta(turnsElapsed) == 0 && turnsElapsed > 0 && never(IsLoadingSaveFile())
    )
}

achievement(title = "Before the Dawn", points = 25,
    description = "Complete the final chapter.",
    trigger = chapter() == 0xff && state1() == 0x37 && state2() == 0xe
)

// End of chapter-related cheevos

// RECRUITMENT CHEEVOS

ayra = GetGen1UnitObjectByName("Ayra")
achievement(title = "Lady of Wrath [m]", points = 5, id = 130698, badge = "143895",
    description = "Recruit Ayra.",
    trigger = chapter() == 1 && WasValueSetInGame(ayra["affiliation"], 3, 0)
)

jamke = GetGen1UnitObjectByName("Jamke")
achievement(title = "The Traitorous Prince [m]", points = 10, id = 130699, badge = "143896",
    description = "Recruit Jamke.",
    trigger = chapter() == 1 && WasValueSetInGame(jamke["affiliation"], 3, 0)
)

deirdre = GetGen1UnitObjectByName("Deirdre")
achievement(title = "The Maiden of the Forest", points = 3, id = 130700, badge = "143897",
    description = "Recruit Deirdre.",
    trigger = chapter() == 1 && WasBitflagSetInGame(deirdre["isSortied"])
)

holyn = GetGen1UnitObjectByName("Holyn")
achievement(title = "From Merc to Squire [m]", points = 5, id = 130705, badge = "143902",
    description = "Recruit Holyn.",
    trigger = chapter() == 2 && WasValueSetInGame(holyn["affiliation"], 7, 0)
)

raquesis = GetGen1UnitObjectByName("Raquesis")
achievement(title = "A Princess Conscripted", points = 5, id = 130708, badge = "143905",
    description = "Recruit Raquesis.",
    trigger = chapter() == 2 && WasValueSetInGame(raquesis["affiliation"], 1, 0)
)

function beowulfWasRecruited() => bit3(0x0052c5)
achievement(title = "Sellsword for Hire [m]", points = 10, id = 130709, badge = "143906",
    description = "Recruit Beowulf.",
    trigger = chapter() == 2 && WasBitflagSetInGame(beowulfWasRecruited())
)

erin = GetGen1UnitObjectByName("Erin")
achievement(title = "Devoted but Gullible [m]", points = 5, id = 130710, badge = "143907",
    description = "Recruit Erin.",
    trigger = chapter() == 2 && WasValueSetInGame(erin["affiliation"], 5, 0)
)

function larceiRecruitsJohanOrJohalvier() => bit5(0x0052c5)
achievement(title = "Combatting Roosters [m]", points = 5, id = 130736, badge = "143933",
    description = "Recruit Johan or Johalvier.",
    trigger = chapter() == 6 && WasBitflagSetInGame(larceiRecruitsJohanOrJohalvier())
)

function aresRescuesDancerFromDarna() => bit6(0x0052c6)
achievement(title = "Atonement Almost Lost [m]", points = 3, id = 130743, badge = "143940",
    description = "Have Ares rescue Lene or Laylea from Darna.",
    trigger = chapter() == 7 && WasBitflagSetInGame(aresRescuesDancerFromDarna())
)

function arthurRecruitsTinni() => bit0(0x0052c7)
achievement(title = "A Long-Belated Reunion [m]", points = 10, id = 130744, badge = "143941",
    description = "Reunite Arthur or Amid with Tinni or Linda.",
    trigger = chapter() == 7 && WasBitflagSetInGame(arthurRecruitsTinni())
)

function pattyRecruitsFavel() => bit2(0x0052c7)
achievement(title = "Back to His Senses [m]", points = 5, id = 130748, badge = "143945",
    description = "Have Patty or Daisy recruit Faval or Asaello.",
    trigger = chapter() == 8 && WasBitflagSetInGame(pattyRecruitsFavel())
)
    
function seliphRecruitsCed() => bit1(0x0052c7)
achievement(title = "Face Death with Valor [m]", points = 3, id = 130749, badge = "143946",
    description = "Have Seliph recruit Ced or Hawke.",
    trigger = chapter() == 8 && WasBitflagSetInGame(seliphRecruitsCed())
)

function altenaJoinsSeliph() => bit2(0x0052c7)
achievement(title = "The Luminous Rider [m]", points = 3, id = 130753, badge = "143950",
    description = "Have Altena join your army.",
    trigger = chapter() == 9 && WasBitflagSetInGame(altenaJoinsSeliph())
)

function cairpreRecruitsHannibal() => bit1(0x0052c7)
achievement(title = "Not by Blood but by Spirit [m]", points = 10, id = 130754, badge = "143951",
    description = "Recruit Hannibal.",
    trigger = chapter() == 9 && WasBitflagSetInGame(cairpreRecruitsHannibal())
)

// End recruitment cheevos

function deirdreSilenceStaffDurability() => byte(0x004032)
achievement(title = "A Brief Silence [m]", points = 5, id = 130766, badge = "143964",
    description = "Capture Verdane in Chapter 1 without using Deirdre's Silence staff more than once.",
    trigger = chapter() == 1 && deirdreSilenceStaffDurability() >= 2 && PlayerHasCapturedKeepBySlot(4)
)

braveAxeId = 0x45
function lexGotBraveAxe() => bit3(0x0052c8)
achievement(title = "The Honest Woodcutter [m]", points = 3, id = 130707, badge = "143904",
    description = "Have Lex retrieve the Brave Axe on the eastern Verdanite peninsula in Chapter 1.",
    trigger = chapter() == 1 && WasBitflagSetInGame(lexGotBraveAxe())
)

function ardenGotPursuitBand() => bit1(0x0052c9)
achievement(title = "Arden's Ambition [m]", points = 3, id = 130738, badge = "143935",
    description = "Have Arden find the Pursuit Band on the western Agustrian peninsula in Chapter 2.",
    trigger = chapter() == 2 && WasBitflagSetInGame(ardenGotPursuitBand())
)

knightRingId = 0x88
function raquesisRetainersSurvived() => bit2(0x0052c8)
achievement(title = "Into the Deepest Valley [m]", points = 10, id = 130712, badge = "143909",
    description = "Ensure all of Raquesis's retainers survive to the end of Chapter 2.",
    trigger = chapter() == 2 && IsBitflagSetInGame(raquesisRetainersSurvived())
)

windSwordId = 0x24
function dewReceivedWindSword() => bit4(0x0052c7)
achievement(title = "Consolation Loot [m]", points = 10, id = 130718, badge = "143915",
    description = "Have Dew retrieve the Wind Sword from the Tower of Bragi in Chapter 3.",
    trigger = chapter() == 3 && IsBitflagSetInGame(dewReceivedWindSword())
)

earthSwordId = 0x22
function raquesisRetrievedEarthSword() => bit7(0x0052c4)
achievement(title = "Siblings' Last Quarrel [m]", points = 10, id = 130715, badge = "143912",
    description = "Receive the Earth Sword from Eldigan in Chapter 3.",
    trigger = chapter() == 3 && WasBitflagSetInGame(raquesisRetrievedEarthSword())
)

achievement(title = "Arden's Resolve", points = 3, id = 130730, badge = "143927",
    description = "Have Arden find the stat boost in Chapter 5.",
    trigger = chapter() == 5 && WasBitflagSetInGame(bit2(0x0052c8))
)

gaeBolgId = 0x3e
ethlyn = GetGen1UnitObjectByName("Ethlyn")
achievement(title = "The Spear of Cuhullin [m]", points = 3, id = 130716, badge = "143913",
    description = "Receive Gae Bolg in Chapter 3.",
    trigger = chapter() == 3 && IsPlayerPhase() && WasValueSetInGame(ethlyn["talkTo"], 0x6, 0x0) && TurnNumberIsPlausible()
)

yewfelleId = 0x4f
aideen = GetGen1UnitObjectByName("Aideen")
achievement(title = "Strings of Ullr [m]", points = 3, id = 130717, badge = "143914",
    description = "Have Aideen bestow Yewfelle to Bridget following their reunion in Chapter 3.",
    trigger = chapter() == 3 && IsPlayerPhase() && WasValueSetInGame(aideen["talkTo"], 0x18, 0x0) && TurnNumberIsPlausible()
)

// Archived due to item gift addresses being inconsistent and there being no bitflag for me to use here.
// Perhaps I could get this to work if I figure out what unit is selected...
if (1 == 0)
{
    shieldSwordId = 0x20
    achievement(title = "Tattered Slippers", points = 5,
        description = "Have Sylvia retrieve the Shield Sword in Chapter 4.",
        trigger = chapter() == 4 && UnitJustReceivedItemById(sylviaInventoryCountAddr(), shieldSwordId)
    )   
}

forsetiId = 0x5c
function lewynReceivedForseti() => bit1(0x0052c6)
achievement(title = "Gales of Justice [m]", points = 5, id = 130722, badge = "143919",
    description = "Receive Forseti in Chapter 4.",
    trigger = chapter() == 4 && IsBitflagSetInGame(lewynReceivedForseti())
)

brokenTyrfingId = 0x27
function byronGiftedTyrfingToSigurd() => bit5(0x0052c6)
achievement(title = "The Blade of Curses [m]", points = 5, badge = "143925", id = 130728,
    description = "Receive Tyrfing from Lord Byron within two turns in Chapter 5.",
    trigger = chapter() == 5 && IsBitflagSetInGame(byronGiftedTyrfingToSigurd()) && turns() <= 2
)

nosferatuId = 0x5f
function juliaAndSeliphDiscussToGetItemInChapter6() => bit2(0x0052c7)
function IsaachIsControlledByPlayer() => KeepIsUnderControlByPlayer(3)
achievement(title = "Lifelight from Your Eyes [m]", points = 5, id = 130737, badge = "143934",
    description = "Receive Nosferatu for Julia after capturing Isaach in Chapter 6.",
    trigger = chapter() == 6 && IsaachIsControlledByPlayer() && IsBitflagSetInGame(juliaAndSeliphDiscussToGetItemInChapter6())
)

shanan = GetGen1UnitObjectByName("Lex") // Lex and Shanan share the same memory space.
achievement(title = "Bane of Fafnir [m]", points = 3, id = 130742, badge = "143939",
    description = "Receive Balmung.",
    trigger = chapter() == 7 && IsPlayerPhase() && WasValueSetInGame(shanan["talkTo"], 0x39, 0x0) && TurnNumberIsPlausible()
)

function palmarchGiftedTyrfingToSeliph() => bit3(0x0052c7)
achievement(title = "Inheritor of Baldur [m]", points = 3, id = 130729, badge = "143925",
    description = "Receive Tyrfing from Palmarch in Chapter 10.",
    trigger = chapter() == 10 && IsBitflagSetInGame(palmarchGiftedTyrfingToSeliph())
)

function juliaReceivesBookOfNaga() => bit7(0x0052c8)
achievement(title = "The Light of Heim [m]", points = 3, id = 130765, badge = "143963",
    description = "Receive the Book of Naga in the final chapter.",
    trigger = chapter() == 11 && IsBitflagSetInGame(juliaReceivesBookOfNaga())
)

function seliphTalkedToHisParents() => bit3(0x0052c8)
achievement(title = "The Same Loving Smile [m]", points = 5, id = 130758, badge = "143955",
    description = "Have Seliph speak with his parents one last time in Chapter 10.",
    trigger = chapter() == 10 && IsBitflagSetInGame(seliphTalkedToHisParents())
)

function altenaConvincesArion() => bit5(0x0052c9)
achievement(title = "Reason Before Pride [m]", points = 5, id = 130763, badge = "143961",
    description = "Convince Arion to take up arms against Julius in the final chapter.",
    trigger = chapter() == 11 && IsBitflagSetInGame(altenaConvincesArion())
)

function GetTacticsRankConditions()
{
    totalTurns = GetTotalTurns()
    conditions = []
    
    array_push(conditions, once(totalTurns < 1056))
    array_push(conditions, once(totalTurns < 800))
    array_push(conditions, once(totalTurns < 550))
    array_push(conditions, once(totalTurns < 400))
    return conditions
}

function GetExperienceRankConditions()
{
    exp = experiencePlayerRank()
    conditions = []
    
    array_push(conditions, once(exp > 0x18f))
    array_push(conditions, once(exp > 0x257))
    array_push(conditions, once(exp > 0x31f))
    array_push(conditions, once(exp > 0x3e7))
    return conditions
}

function GetSurvivalRankConditions()
{
    survival = survivalPlayerRank()
    conditions = []
    
    array_push(conditions, once(survival > 0x28))
    array_push(conditions, once(survival > 0x29))
    array_push(conditions, once(survival > 0x2a))
    array_push(conditions, once(survival > 0x2b))
    return conditions
}

function GetCombatRankConditions()
{
    totalLosses = GetTotalLosses()
    conditions = []
    
    array_push(conditions, once(totalLosses < 51))
    array_push(conditions, once(totalLosses < 31))
    array_push(conditions, once(totalLosses < 11))
    array_push(conditions, once(totalLosses < 4))
    return conditions
}

function GetTotalTurns()
{
    turnsBaseAddr = 0x000d93 // Prologue
    totalTurns = 0
    
    for i in chapters
    {
        if (i < 0xff)
        {
            totalTurns = totalTurns + word(turnsBaseAddr + 2 * i)
        }
    }
    
    return totalTurns
}

function GetTotalLosses()
{
    lossesBaseAddr = 0x007358
    totalLossSlots = 0x2f
    totalLosses = 0
    
    for i in range(0, totalLossSlots - 1)
    {
        totalLosses = totalLosses + byte(lossesBaseAddr + i)
    }
    
    return totalLosses
}

function GotExperienceARank() => word(0x3d83) >= 0x3e8

achievement(title = "A Father to His Men [m]", points = 25, id = 130692, badge = "143889",
    description = "Recruit all possible units and ensure they survive to the end of their story.",
    trigger = tally(4, GetSurvivalRankConditions()) && never(chapter() != 0xFF)
)

// I've given each letter rank a point value for use in averaging, ranging from 0 (for E) to 4 (for A).
// To get an overall ranking of A, players need to get a total of fifteen points (meaning one category can be B).
playerRankConditions = []
for i in GetTacticsRankConditions()
{
    array_push(playerRankConditions, i)
}

for i in GetExperienceRankConditions()
{
    array_push(playerRankConditions, i)
}

for i in GetSurvivalRankConditions()
{
    array_push(playerRankConditions, i)
}

for i in GetCombatRankConditions()
{
    array_push(playerRankConditions, i)
}

achievement(title = "Master Tactician [m]", points = 50, id = 130733, badge = "143930",
    description = "Complete the game with an overall player rank of A.",
    trigger = tally(15, playerRankConditions) && never(!IsPlayerRankShown()) && chapter() == 0xFF && playerCastlesCaptured() == 0 && GetTotalTurns() > 0
)

function DidNotRecruitBiologicalChildren()
{
    deathStatusBaseAddr = 0x01c54d
    children = GetBredBiologicalChildren()
    conditions = always_true()
    
    for i in range(0, length(children) - 1)
    {
        child = children[i]
        conditions = conditions && bit6(deathStatusBaseAddr + 2 * child["deathStatusIndex"]) == 1
    }
    
    return conditions
}

achievement(title = "Chastity [m]", points = 50, id = 130734, badge = "143931",
    description = "Complete the game without conceiving any optional biological children.",
    trigger = DidNotRecruitBiologicalChildren() && chapter() == 0xFF && IsPlayerRankShown()
)

// RICH PRESENCE

function GetChapterNamesForRichPresence()
{
    retValue = {}
    for chapterId in chapters
    {
        chapter = chapters[chapterId]
        retValue[chapterId] = chapter["name"]
    }
    return retValue
}

function GetChapterPretitlesForRichPresence()
{
    retValue = {}
    for chapterId in chapters
    {
        chapter = chapters[chapterId]
        if (chapter["pretitle"] != "")
        {
            retValue[chapterId] = chapter["pretitle"] + ": "
        }
        else
        {
            retValue[chapterId] = ""
        }
    }
    return retValue
}

function ShouldShowTurnNumber() => state1() != 0xf && TurnNumberIsPlausible()

rich_presence_conditional_display(IsOutsideGameplay(), "Title Screen/Main Menu")

rich_presence_conditional_display(!ShouldShowTurnNumber(), "{0}{1}",
    rich_presence_lookup("ChapterPretitles", chapter(), GetChapterPretitlesForRichPresence()),
    rich_presence_lookup("Chapter", chapter(), GetChapterNamesForRichPresence())
)

rich_presence_display("{0}{1} | Turn {2} | Play Time: {3}",
    rich_presence_lookup("ChapterPretitles", chapter(), GetChapterPretitlesForRichPresence()),
    rich_presence_lookup("Chapter", chapter(), GetChapterNamesForRichPresence()),
    rich_presence_value("Turn", turns()),
    rich_presence_value("PlayTime", playTime(), "FRAMES")
)

