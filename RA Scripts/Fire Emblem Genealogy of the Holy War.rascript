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

function WasBitflagSetInGame(bit)
{
    return WasValueSetInGame(bit, 0, 1)
}

function WasBitflagSet(bit)
{
    return WasValueSet(bit, 0, 1)
}

function WasValueSetInGame(mem, oldValue, newValue)
{
    return WasValueSet(mem, oldValue, newValue)
        && never(IsLoadingSaveFile())
}

function WasValueSet(mem, oldValue, newValue)
{
    return once(Delta(mem) == oldValue && mem == newValue)
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
    0x1: { "pretitle": "Chapter 1", "name": "The Spirit Forest's Maiden", "rescuableVillageSlotIds": [ ], "keepIds": [] },
    0x2: { "pretitle": "Chapter 2", "name": "Crisis in Agustria", "rescuableVillageSlotIds": [ ], "keepIds": [] },
    0x3: { "pretitle": "Chapter 3", "name": "Eldigan the Lionheart", "rescuableVillageSlotIds": [ ], "keepIds": [] },
    0x4: { "pretitle": "Chapter 4", "name": "Dance in the Skies", "rescuableVillageSlotIds": [ ], "keepIds": [] },
    0x5: { "pretitle": "Chapter 5", "name": "Threshold of Fate", "rescuableVillageSlotIds": [ ], "keepIds": [] },
    0x6: { "pretitle": "Chapter 6", "name": "Heirs to the Light", "rescuableVillageSlotIds": [ ], "keepIds": [] },
    0x7: { "pretitle": "Chapter 7", "name": "Beyond the Desert", "rescuableVillageSlotIds": [ ], "keepIds": [] },
    0x8: { "pretitle": "Chapter 8", "name": "The Dracoknights of Thracia", "rescuableVillageSlotIds": [ ], "keepIds": [] },
    0x9: { "pretitle": "Chapter 9", "name": "For Whose Sake", "rescuableVillageSlotIds": [ ], "keepIds": [] },
    0xA: { "pretitle": "Chapter 10", "name": "Light and Darkness", "rescuableVillageSlotIds": [ ], "keepIds": [] },
    0xB: { "pretitle": "Endgame", "name": "The Final Holy War", "rescuableVillageSlotIds": [ ], "keepIds": [] },
    0xF: { "pretitle": "", "name": "Credits", "rescuableVillageSlotIds": [ ], "keepIds": [] },
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

// $000D8F: [2 Byte] Days
function turns() => word(0x000D8F)

// $000D91: Turf's Phase

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
function GetGen1UnitObjectByAddr(addr)
{
    // For the purposes of keeping things uniform, we're assuming that arena LV is the head address for each unit.
    return {
        "arenaLevel": byte(addr),
        "status": byte(addr + 1),
        "isDead": bit1(addr + 1),
        "lover": byte(addr + 3),
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
        "classId": byte(addr + 23),
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
    return GetGen1UnitObjectByAddr(gen1UnitBaseAddr() - index * 0x24)
}

// $001075: Cursor - X coord relative position (copy)
// $001076: Cursor - X coord shift
// $001095: Cursor - Y coord relative position (copy)
// $001096: Cursor - Y coord shift
// $001864: Save Game menu - File Cursor
// $001B19: Timer (Related to clock?)
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
// $00384D: ?'s Weapon Slot equipped
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
// $003A61: ?'s Weapon Slot equipped
// $003A74: ?'s Weapon Slot equipped
// $003A87: ?'s Weapon Slot equipped
// $003A9A: ?'s Weapon Slot equipped
// $003AAD: ?'s Weapon Slot equipped
// $003AC0: ?'s Weapon Slot equipped
// $003AD3: ?'s Weapon Slot equipped
// $003AE6: ?'s Weapon Slot equipped
// $003AF9: ?'s Weapon Slot equipped
// $003B0C: ?'s Weapon Slot equipped
// $003B1F: ?'s Weapon Slot equipped
// $003B32: ?'s Weapon Slot equipped
// $003B45: ?'s Weapon Slot equipped
// $003B58: ?'s Weapon Slot equipped
// $003B6B: ?'s Weapon Slot equipped
// $003B7E: ?'s Weapon Slot equipped
// $003B91: ?'s Weapon Slot equipped
// $003BA4: ?'s Weapon Slot equipped
// $003BB7: Noish's Weapon Item no. equipped?!
// $003BB8: Noish number of items in inventory
// $003BCA: Sigurd's Weapon Slot equipped
// $003BCB: Sigurd's  Inventory Quantity
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
// $003D85: Player Rank - Survival (characters joined and alive)
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

function IsLoadingSaveFile() => state2() == 0x8 || state2() == 0x23

function IsBooting() => state1() == 0x2 || state1() == 0x3 && state2() == 0x0

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

    achievement(title = cheevo["name"], description = cheevo["description"], points = cheevo["points"],
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

GenerateSaveProtectedAchievementFromConditions({
    "name": "Save Protection Test",
    "description": "If this triggers when the game loads, save protection is broken!",
    "points": 0,
    "threshold": 1
}, {
    0x0: { "countsWhen": (sigurdKills() > 0), "recalculateWhen": (Delta(sigurdKills()) != sigurdKills()) }
})

gen1UnitMetadata = {
"Sigurd": { "index": 0, "name": "Sigurd", },
"Noish": { "index": 1, "name": "Noish", },
"Alec": { "index": 2, "name": "Alec", },
"Arden": { "index": 3, "name": "Arden", },
"Azel": { "index": 4, "name": "Azel", },
"Lex": { "index": 5, "name": "Lex", },
"Quan": { "index": 6, "name": "Quan", },
"Finn": { "index": 7, "name": "Finn", },
"Ethlyn": { "index": 8, "name": "Ethlyn", },
"Midir": { "index": 9, "name": "Midir", },
"Ayra": { "index": 10, "name": "Ayra", },
"Aideen": { "index": 11, "name": "Aideen", },
"Dew": { "index": 12, "name": "Dew", },
"Jamke": { "index": 13, "name": "Jamke", },
"Deirdre": { "index": 14, "name": "Deirdre", },
"Raquesis": { "index": 15, "name": "Raquesis", },
"Holin": { "index": 16, "name": "Holin", },
"Beowulf": { "index": 17, "name": "Beowulf", },
"Levin": { "index": 18, "name": "Levin", },
"Sylvia": { "index": 19, "name": "Sylvia", },
"Erin": { "index": 20, "name": "Erin", },
"Brigid": { "index": 21, "name": "Brigid", },
"Taillte": { "index": 22, "name": "Taillte", },
"Claude": { "index": 23, "name": "Claude", },
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

function GetGen1UnitObjectByName(name)
{
    meta = gen1UnitMetadata[name]
    return GetGen1UnitObjectByIndex(meta["index"])
}

// Do Gen 1 unit-related things here.
gen1UnitLeveledUpTo10 = always_false()
gen2UnitLeveledUpTo10 = always_false()
for i in range(0, 23)
{
    unit = GetGen1UnitObjectByIndex(i)
    unitMeta = GetGen1UnitMetadataByIndex(i)
    achievement(title = unitMeta["name"] + " Test", description = "Level up " + unitMeta["name"] + "'s arena level to trigger.",
        points = 0,
        trigger = WasValueSetInGame(unit["arenaLevel"], 0, 1)
    )
    
    gen1UnitLeveledUpTo10 = gen1UnitLeveledUpTo10 || Delta(unit["level"]) < 10 && unit["level"] >= 10
}

achievement(title = "It Gets Worse from Here", points = 3,
    description = "Raise a unit to Level 10.",
    trigger = never(IsLoadingSaveFile()) && (gen1UnitLeveledUpTo10 || gen2UnitLeveledUpTo10)
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
                = { "countsWhen": (bit5(buildingAttrAddr) == 1 && chapter() == i), "recalculateWhen": (Delta(bit5(buildingAttrAddr)) != bit5(buildingAttrAddr)) }
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
            rescueConditions = rescueConditions ||
                // Count only when the player's army seizes a keep.
                bit0(buildingAttrAddr) == 0 && bit1(buildingAttrAddr) == 0 && bit2(buildingAttrAddr) == 0 && chapter() == i
                && Delta(bit6(buildingAttrAddr)) == 0 && WasBitflagSetInGame(bit6(buildingAttrAddr))
        }
    }
    
    return rescueConditions
}

GenerateSaveProtectedAchievementFromConditions({
    "name": "Village Savior",
    "description": "Rescue a village before it is razed to the ground.",
    "points": 1,
    "threshold": 1,
}, GetRescuableVillagesByChapterIds(GetChapterIds()))

achievement(title = "Conqueror", points = 1,
    description = "Seize a keep from an enemy faction's control.",
    trigger = GetSeizableKeepsByChapterIds(GetChapterIds())
)

GenerateSaveProtectedAchievementFromConditions({
    "name": "Defender of Chalphy",
    "description": "Rescue all villages in the Prologue.",
    "points": 5,
    "threshold": 5
}, GetRescuableVillagesByChapterIds([ 0 ]))

// CHAPTER-RELATED CHEEVOS
blitzkriegCheevos = {
    0: { "turnLimit": 24, "points": 5 } // my record: 21 turns
}

chapterCheevos = {
    0: { "name": "And So the Crusade Begins", "description": "Complete the prologue.", "points": 3 }
}

for i in blitzkriegCheevos
{
    chapter = chapters[i]
    cheevo = blitzkriegCheevos[i]
    turnsElapsed = word(turnsElapsedInPrologueBaseAddr() + 2 * i)
    achievement(title = "Blitzkrieg (" + chapter["pretitle"] + ")", points = cheevo["points"],
        description = "Complete '" + chapter["name"] + "' within " + cheevo["turnLimit"] + " turns.",
        trigger = chapter() == i && Delta(turnsElapsed) == 0 && turnsElapsed > 0 && turnsElapsed <= cheevo["turnLimit"] && never(IsLoadingSaveFile())
    )
    
    cheevo = chapterCheevos[i]
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
// End of chapter-related cheevos

// CHAPTER CHEEVOS


for i in chapterCheevos
{
    chapter = chapters[i]
    cheevo = chapterCheevos[i]
    
    
}
// End of chapter cheevos

achievement(title = "A Father to His Men", points = 25,
    description = "Complete the game with all possible recruits and without any of them dying.",
    trigger = always_false()
)

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

function ShouldShowTurnNumber() => state1() != 0xf && turns() < 65535 && turns() > 0

rich_presence_conditional_display(!ShouldShowTurnNumber(), "{0}{1}",
    rich_presence_lookup("ChapterPretitles", chapter(), GetChapterPretitlesForRichPresence()),
    rich_presence_lookup("Chapter", chapter(), GetChapterNamesForRichPresence())
)

rich_presence_display("{0}{1} | Turn {2}",
    rich_presence_lookup("ChapterPretitles", chapter(), GetChapterPretitlesForRichPresence()),
    rich_presence_lookup("Chapter", chapter(), GetChapterNamesForRichPresence()),
    rich_presence_value("Turn", turns())
)
