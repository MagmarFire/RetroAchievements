// World Ends with You, The
// #ID = 4887

// UTILITY

framesPerSecond = 60

function Delta(addr) => prev(addr)

function WasBitflagSetInGame(bit)
{
    return once(Delta(bit) != bit && bit == 1)
        && never(IsLoadingSaveFile())
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

enemyNamesToIds = {
    "Metal Corehog": {  }
}

// $074194: 0x1 = transitioning into game mode after clicking Adventure or Battle
function IsLoadingSaveFile() => Delta(isOnTitleScreen()) == 0x1 && isOnTitleScreen() == 0x0

function isOnTitleScreen() => byte(0x074194)

// $071D1C: Money (32-bit)
// $071D28: Partner ID (8-bit)
//          
//          0x0 = Shiki
//          0x1 = Joshua
//          0x2 = Beat
// $071D84: Deck 1, Slot 1, Pin ID (16-bit)
// $0737B8: ESP'er Points
// $07415C: Overworld x-coordinate (32-bit)
// $074160: Overworld y-coordinate (32-bit)
// $074168: Map ID (16-bit)
// $074171: Bit 3: "Noise!?"
function noiseInterrobang() => bit3(0x074171)

// $074E52: Battle state:
//          
//          0x0 = switch to battle
//          0x1 = in battle
//          0x2 = victory
function InBattle() => byte(0x074e52) == 0x1
function OutOfBattle() => byte(0x074e52) == 0x2

// $074E98: Time elapsed in battle (frames) (32-bit)
// $074E9C: Number of consecutive hits in battle (16-bit)
// $074E9F: Hits taken in battle
// $3984C4: Slot 1 pin ID (pins screen) (16-bit)
//          
//          Set to 0xffff if there is no pin in that slot.
// $3984DA: Slot 1 is in a sub-slot
// $398BE4: ID of pin in Slot 1 of your inventory
// $398BF8: Stockpile pin, Slot 1 - Level (8-bit)
// $398C30: ID of pin in Slot 2 of stockpile

function currentRankingGraphic() => byte(0x06879c)

function whipSoundEffect() => byte(0x39d544)
function WhipSoundEffectPlayed() => Delta(whipSoundEffect()) == 0x0 && whipSoundEffect() == 0x1

rankingGraphicIndices = {
    "Star": { "index": 0x10 },
    "A": { "index": 0x80 },
    "B": { "index": 0x30 },
    "C": { "index": 0x70 },
    "D": { "index": 0x40 },
    "E": { "index": 0x50 }
}

function GetRankingGraphicIndexByName(name)
{
    for index in rankingGraphicIndices
    {
        if (index == name)
        {
            return rankingGraphicIndices[index]["index"]
        }
    }
}

function IsRankingRevealed()
{
    return OutOfBattle() && WhipSoundEffectPlayed()
}

// Pin-related functionality
// ---
// The data structures for pins vary depending on whether or not they're in a player's deck/stockpile or if they're in the Mastered collection.
//
// DECK/STOCKPILE (11 bytes each)
// ***
// Bytes 0-1: Pin ID. Equal to 0xffff if there is no pin equipped in that slot. IDs go from 0x0 to 0x12f.
// Bytes 2-3: Battle PP.
// Bytes 4-5: Mingle PP.
// Bytes 6-7: Shutdown PP.
// Byte 9: Bit 0 determines if a pin is in a subslot.
// Byte A: Pin LV (lower 4 only)
//
// MASTERED (4 bytes each)
// ***
// Bytes 0-1: Pin ID. Equal to 0xffff if there is no pin in that slot.
// Byte 2: Count.
// Byte 3: Pin LV (lower 4 only; probably redundant?)
//
// To check mastery, we'll have to check both the deck and Mastered collection.

pins = {
    0x0: { "ID": 0x0, "Name": "Ice Blow", "MaxLevel": 7 },
0x1: { "ID": 0x1, "Name": "Ice Risers", "MaxLevel": 10 },
0x2: { "ID": 0x2, "Name": "Frozen Cool", "MaxLevel": 4 },
0x3: { "ID": 0x3, "Name": "Blizzard Cool", "MaxLevel": 4 },
0x4: { "ID": 0x4, "Name": "Earthshake", "MaxLevel": 5 },
0x5: { "ID": 0x5, "Name": "Sexy D", "MaxLevel": 4 },
0x6: { "ID": 0x6, "Name": "Sexy +", "MaxLevel": 4 },
0x7: { "ID": 0x7, "Name": "Sexy B", "MaxLevel": 5 },
0x8: { "ID": 0x8, "Name": "Straitjacket", "MaxLevel": 5 },
0x9: { "ID": 0x9, "Name": "Blown Kiss", "MaxLevel": 2 },
0xA: { "ID": 0xA, "Name": "D+B", "MaxLevel": 3 },
0xB: { "ID": 0xB, "Name": "Happy Beam", "MaxLevel": 6 },
0xC: { "ID": 0xC, "Name": "Natural Magnum", "MaxLevel": 5 },
0xD: { "ID": 0xD, "Name": "Wonder Magnum", "MaxLevel": 4 },
0xE: { "ID": 0xE, "Name": "Beauty Launcher", "MaxLevel": 5 },
0xF: { "ID": 0xF, "Name": "One Love Magnum", "MaxLevel": 6 },
0x10: { "ID": 0x10, "Name": "Hounder Magnum", "MaxLevel": 5 },
0x11: { "ID": 0x11, "Name": "Bear Hug Magnum", "MaxLevel": 5 },
0x12: { "ID": 0x12, "Name": "Sparkle Beam", "MaxLevel": 4 },
0x13: { "ID": 0x13, "Name": "Lil' Terror Bazooka", "MaxLevel": 3 },
0x14: { "ID": 0x14, "Name": "Angel Magnum", "MaxLevel": 4 },
0x15: { "ID": 0x15, "Name": "Cutie Beam", "MaxLevel": 5 },
0x16: { "ID": 0x16, "Name": "Lovely Beam", "MaxLevel": 6 },
0x17: { "ID": 0x17, "Name": "Sexy Beam", "MaxLevel": 7 },
0x18: { "ID": 0x18, "Name": "Superfine Beam", "MaxLevel": 8 },
0x19: { "ID": 0x19, "Name": "Playmate Beam", "MaxLevel": 3 },
0x1A: { "ID": 0x1A, "Name": "Purity Launcher", "MaxLevel": 3 },
0x1B: { "ID": 0x1B, "Name": "Innocence Beam", "MaxLevel": 5 },
0x1C: { "ID": 0x1C, "Name": "Pop Pendulum", "MaxLevel": 5 },
0x1D: { "ID": 0x1D, "Name": "Casual Pendulum", "MaxLevel": 3 },
0x1E: { "ID": 0x1E, "Name": "Love Me Tether", "MaxLevel": 5 },
0x1F: { "ID": 0x1F, "Name": "Pamper Me Tether", "MaxLevel": 5 },
0x20: { "ID": 0x20, "Name": "Sweet Talk Tether", "MaxLevel": 5 },
0x21: { "ID": 0x21, "Name": "Natural Puppy", "MaxLevel": 3 },
0x22: { "ID": 0x22, "Name": "Frantic", "MaxLevel": 3 },
0x23: { "ID": 0x23, "Name": "Blink Step", "MaxLevel": 3 },
0x24: { "ID": 0x24, "Name": "First Gear", "MaxLevel": 5 },
0x25: { "ID": 0x25, "Name": "Top Gear", "MaxLevel": 3 },
0x26: { "ID": 0x26, "Name": "Egg Bomb", "MaxLevel": 4 },
0x27: { "ID": 0x27, "Name": "Meteor Magnet", "MaxLevel": 6 },
0x28: { "ID": 0x28, "Name": "Meteor Hook", "MaxLevel": 7 },
0x29: { "ID": 0x29, "Name": "Meteor Spike", "MaxLevel": 8 },
0x2A: { "ID": 0x2A, "Name": "Strong Heart", "MaxLevel": 5 },
0x2B: { "ID": 0x2B, "Name": "Strong Spirit", "MaxLevel": 5 },
0x2C: { "ID": 0x2C, "Name": "Strong Body", "MaxLevel": 5 },
0x2D: { "ID": 0x2D, "Name": "Strong 'n Proud", "MaxLevel": 5 },
0x2E: { "ID": 0x2E, "Name": "Poison Scorpion", "MaxLevel": 2 },
0x2F: { "ID": 0x2F, "Name": "Poison Skull", "MaxLevel": 2 },
0x30: { "ID": 0x30, "Name": "Poison Bones", "MaxLevel": 3 },
0x31: { "ID": 0x31, "Name": "Poison Chains", "MaxLevel": 3 },
0x32: { "ID": 0x32, "Name": "Rapier Glance", "MaxLevel": 3 },
0x33: { "ID": 0x33, "Name": "Love Charge", "MaxLevel": 1 },
0x34: { "ID": 0x34, "Name": "Guardian Angel", "MaxLevel": 5 },
0x35: { "ID": 0x35, "Name": "Archangel", "MaxLevel": 3 },
0x36: { "ID": 0x36, "Name": "Energy Factor", "MaxLevel": 5 },
0x37: { "ID": 0x37, "Name": "Speed Factor", "MaxLevel": 1 },
0x38: { "ID": 0x38, "Name": "Supply Factor", "MaxLevel": 3 },
0x39: { "ID": 0x39, "Name": "Chaos", "MaxLevel": 3 },
0x3A: { "ID": 0x3A, "Name": "Pavo Real", "MaxLevel": 3 },
0x3B: { "ID": 0x3B, "Name": "Lightning Moon", "MaxLevel": 5 },
0x3C: { "ID": 0x3C, "Name": "Lightning Storm", "MaxLevel": 5 },
0x3D: { "ID": 0x3D, "Name": "Burning Cherry", "MaxLevel": 5 },
0x3E: { "ID": 0x3E, "Name": "Burning Melon", "MaxLevel": 5 },
0x3F: { "ID": 0x3F, "Name": "Burning Berry", "MaxLevel": 5 },
0x40: { "ID": 0x40, "Name": "Aqua Monster", "MaxLevel": 4 },
0x41: { "ID": 0x41, "Name": "Aqua Ghost", "MaxLevel": 5 },
0x42: { "ID": 0x42, "Name": "Aqua Demon", "MaxLevel": 5 },
0x43: { "ID": 0x43, "Name": "Cornered Rat", "MaxLevel": 5 },
0x44: { "ID": 0x44, "Name": "Blast Warning", "MaxLevel": 5 },
0x45: { "ID": 0x45, "Name": "Candle Service", "MaxLevel": 3 },
0x46: { "ID": 0x46, "Name": "Shock Warning", "MaxLevel": 5 },
0x47: { "ID": 0x47, "Name": "Kinetic Warning", "MaxLevel": 5 },
0x48: { "ID": 0x48, "Name": "Impact Warning", "MaxLevel": 5 },
0x49: { "ID": 0x49, "Name": "Storm Warning", "MaxLevel": 5 },
0x4A: { "ID": 0x4A, "Name": "Electric Warning", "MaxLevel": 1 },
0x4B: { "ID": 0x4B, "Name": "Teleport Warning", "MaxLevel": 3 },
0x4C: { "ID": 0x4C, "Name": "Shout", "MaxLevel": 5 },
0x4D: { "ID": 0x4D, "Name": "Psych Support", "MaxLevel": 3 },
0x4E: { "ID": 0x4E, "Name": "Stopper Spark", "MaxLevel": 1 },
0x4F: { "ID": 0x4F, "Name": "Mus Rattus", "MaxLevel": 3 },
0x50: { "ID": 0x50, "Name": "Masamune", "MaxLevel": 7 },
0x51: { "ID": 0x51, "Name": "Onikiri", "MaxLevel": 7 },
0x52: { "ID": 0x52, "Name": "Nenekiri", "MaxLevel": 7 },
0x53: { "ID": 0x53, "Name": "Kanesada", "MaxLevel": 7 },
0x54: { "ID": 0x54, "Name": "Enju", "MaxLevel": 7 },
0x55: { "ID": 0x55, "Name": "Yoshimitsu", "MaxLevel": 7 },
0x56: { "ID": 0x56, "Name": "Ichimonji", "MaxLevel": 5 },
0x57: { "ID": 0x57, "Name": "Nikkari", "MaxLevel": 5 },
0x58: { "ID": 0x58, "Name": "Mikazuki", "MaxLevel": 3 },
0x59: { "ID": 0x59, "Name": "Shiro", "MaxLevel": 20 },
0x5A: { "ID": 0x5A, "Name": "Unjo", "MaxLevel": 5 },
0x5B: { "ID": 0x5B, "Name": "Izanagi", "MaxLevel": 5 },
0x5C: { "ID": 0x5C, "Name": "Murasame", "MaxLevel": 4 },
0x5D: { "ID": 0x5D, "Name": "Rakuyo", "MaxLevel": 4 },
0x5E: { "ID": 0x5E, "Name": "Kusanagi", "MaxLevel": 4 },
0x5F: { "ID": 0x5F, "Name": "Ohabari", "MaxLevel": 7 },
0x60: { "ID": 0x60, "Name": "Zantetsu", "MaxLevel": 10 },
0x61: { "ID": 0x61, "Name": "Mitama", "MaxLevel": 6 },
0x62: { "ID": 0x62, "Name": "Izanami", "MaxLevel": 1 },
0x63: { "ID": 0x63, "Name": "Onmyo", "MaxLevel": 5 },
0x64: { "ID": 0x64, "Name": "Konohana", "MaxLevel": 3 },
0x65: { "ID": 0x65, "Name": "Konohana Sakuya", "MaxLevel": 4 },
0x66: { "ID": 0x66, "Name": "Jupiter of the Monkey", "MaxLevel": 3 },
0x67: { "ID": 0x67, "Name": "Long Live the Rock", "MaxLevel": 4 },
0x68: { "ID": 0x68, "Name": "Long Live the Ice", "MaxLevel": 5 },
0x69: { "ID": 0x69, "Name": "Long Live the Floe", "MaxLevel": 5 },
0x6A: { "ID": 0x6A, "Name": "Eyes Full of Hope", "MaxLevel": 5 },
0x6B: { "ID": 0x6B, "Name": "Eyes Full of Light", "MaxLevel": 5 },
0x6C: { "ID": 0x6C, "Name": "Hot Gaze", "MaxLevel": 4 },
0x6D: { "ID": 0x6D, "Name": "Sizzling Gaze", "MaxLevel": 4 },
0x6E: { "ID": 0x6E, "Name": "Cold Stare", "MaxLevel": 10 },
0x6F: { "ID": 0x6F, "Name": "Icy Stare", "MaxLevel": 10 },
0x70: { "ID": 0x70, "Name": "Wassup Thunder!", "MaxLevel": 5 },
0x71: { "ID": 0x71, "Name": "Wassup Lightning!", "MaxLevel": 5 },
0x72: { "ID": 0x72, "Name": "Wassup Voltage!", "MaxLevel": 6 },
0x73: { "ID": 0x73, "Name": "Indestructo Man", "MaxLevel": 1 },
0x74: { "ID": 0x74, "Name": "Hip Snake", "MaxLevel": 3 },
0x75: { "ID": 0x75, "Name": "Octo Squeeze", "MaxLevel": 6 },
0x76: { "ID": 0x76, "Name": "Snail Squeeze", "MaxLevel": 5 },
0x77: { "ID": 0x77, "Name": "Vacu Squeeze", "MaxLevel": 5 },
0x78: { "ID": 0x78, "Name": "Gimme Dat Sheep", "MaxLevel": 2 },
0x79: { "ID": 0x79, "Name": "Gimme Dat Elephant", "MaxLevel": 2 },
0x7A: { "ID": 0x7A, "Name": "Gimme Dat Hippo", "MaxLevel": 2 },
0x7B: { "ID": 0x7B, "Name": "Crackle Pop Barrier", "MaxLevel": 5 },
0x7C: { "ID": 0x7C, "Name": "Splish Splash Barrier", "MaxLevel": 5 },
0x7D: { "ID": 0x7D, "Name": "Creepy Weepy Barrier", "MaxLevel": 3 },
0x7E: { "ID": 0x7E, "Name": "Whirlygig Juggle", "MaxLevel": 3 },
0x7F: { "ID": 0x7F, "Name": "Healing Bunny", "MaxLevel": 2 },
0x80: { "ID": 0x80, "Name": "Healing Flamingo", "MaxLevel": 4 },
0x81: { "ID": 0x81, "Name": "Healing Whale", "MaxLevel": 3 },
0x82: { "ID": 0x82, "Name": "Croc Leisure", "MaxLevel": 5 },
0x83: { "ID": 0x83, "Name": "Monkey Leisure", "MaxLevel": 6 },
0x84: { "ID": 0x84, "Name": "Bear Leisure", "MaxLevel": 4 },
0x85: { "ID": 0x85, "Name": "Squirrel Leisure", "MaxLevel": 5 },
0x86: { "ID": 0x86, "Name": "Sparkle Charge", "MaxLevel": 3 },
0x87: { "ID": 0x87, "Name": "Handsfree Healing", "MaxLevel": 1 },
0x88: { "ID": 0x88, "Name": "Sheep Heavenly", "MaxLevel": 1 },
0x89: { "ID": 0x89, "Name": "Distortion", "MaxLevel": 4 },
0x8A: { "ID": 0x8A, "Name": "Velocity Attack", "MaxLevel": 5 },
0x8B: { "ID": 0x8B, "Name": "Velocity Tackle", "MaxLevel": 10 },
0x8C: { "ID": 0x8C, "Name": "Demon's Hatred", "MaxLevel": 1 },
0x8D: { "ID": 0x8D, "Name": "Go 2 Hell", "MaxLevel": 5 },
0x8E: { "ID": 0x8E, "Name": "Go 2 Heaven", "MaxLevel": 4 },
0x8F: { "ID": 0x8F, "Name": "Lightning Anger", "MaxLevel": 10 },
0x90: { "ID": 0x90, "Name": "Lightning Rage", "MaxLevel": 5 },
0x91: { "ID": 0x91, "Name": "LIVE!", "MaxLevel": 5 },
0x92: { "ID": 0x92, "Name": "Peace Full", "MaxLevel": 5 },
0x93: { "ID": 0x93, "Name": "Thanx", "MaxLevel": 3 },
0x94: { "ID": 0x94, "Name": "D.I.Y.", "MaxLevel": 1 },
0x95: { "ID": 0x95, "Name": "Tigre Punks", "MaxLevel": 3 },
0x96: { "ID": 0x96, "Name": "One Stone, Many Birds", "MaxLevel": 6 },
0x97: { "ID": 0x97, "Name": "One Stroke, Vast Wealth", "MaxLevel": 10 },
0x98: { "ID": 0x98, "Name": "One Grain, Infinite Promise", "MaxLevel": 7 },
0x99: { "ID": 0x99, "Name": "Self Found, Others Lost", "MaxLevel": 4 },
0x9A: { "ID": 0x9A, "Name": "Fiery Spirit, Spirited Fire", "MaxLevel": 5 },
0x9B: { "ID": 0x9B, "Name": "Flames Afar, Foes Aflame", "MaxLevel": 5 },
0x9C: { "ID": 0x9C, "Name": "Final Pyre, All Expired", "MaxLevel": 5 },
0x9D: { "ID": 0x9D, "Name": "Blue Blood Burns Blue", "MaxLevel": 3 },
0x9E: { "ID": 0x9E, "Name": "Live Slow, Die Fast", "MaxLevel": 6 },
0x9F: { "ID": 0x9F, "Name": "Local Fire, Distant Sea", "MaxLevel": 5 },
0xA0: { "ID": 0xA0, "Name": "June Hearth, January Fan", "MaxLevel": 4 },
0xA1: { "ID": 0xA1, "Name": "Swift Storm, Swift End", "MaxLevel": 5 },
0xA2: { "ID": 0xA2, "Name": "Black Sky, White Bolt", "MaxLevel": 5 },
0xA3: { "ID": 0xA3, "Name": "Follow Suit, Fall in Turn", "MaxLevel": 5 },
0xA4: { "ID": 0xA4, "Name": "Dragon Couture", "MaxLevel": 3 },
0xA5: { "ID": 0xA5, "Name": "Lolita Bat", "MaxLevel": 5 },
0xA6: { "ID": 0xA6, "Name": "Skull Rabbit", "MaxLevel": 5 },
0xA7: { "ID": 0xA7, "Name": "Kaleidoscope", "MaxLevel": 10 },
0xA8: { "ID": 0xA8, "Name": "Lolita Emblem", "MaxLevel": 3 },
0xA9: { "ID": 0xA9, "Name": "Lolita Chopper", "MaxLevel": 4 },
0xAA: { "ID": 0xAA, "Name": "Link Spider", "MaxLevel": 5 },
0xAB: { "ID": 0xAB, "Name": "Web Spider", "MaxLevel": 5 },
0xAC: { "ID": 0xAC, "Name": "Network Spider", "MaxLevel": 5 },
0xAD: { "ID": 0xAD, "Name": "Lolita Mic", "MaxLevel": 1 },
0xAE: { "ID": 0xAE, "Name": "Spider's Silk", "MaxLevel": 15 },
0xAF: { "ID": 0xAF, "Name": "Leopard", "MaxLevel": 4 },
0xB0: { "ID": 0xB0, "Name": "Lolita Skull", "MaxLevel": 4 },
0xB1: { "ID": 0xB1, "Name": "Black Rose", "MaxLevel": 3 },
0xB2: { "ID": 0xB2, "Name": "Lapin Angelique", "MaxLevel": 3 },
0xB3: { "ID": 0xB3, "Name": "Thunder Pawn", "MaxLevel": 5 },
0xB4: { "ID": 0xB4, "Name": "Lightning Pawn", "MaxLevel": 4 },
0xB5: { "ID": 0xB5, "Name": "Aqua Pawn", "MaxLevel": 3 },
0xB6: { "ID": 0xB6, "Name": "Swing Bishop", "MaxLevel": 7 },
0xB7: { "ID": 0xB7, "Name": "Pegaso Bishop", "MaxLevel": 5 },
0xB8: { "ID": 0xB8, "Name": "King Arthur", "MaxLevel": 3 },
0xB9: { "ID": 0xB9, "Name": "Excalibur", "MaxLevel": 5 },
0xBA: { "ID": 0xBA, "Name": "Thunder Rook", "MaxLevel": 3 },
0xBB: { "ID": 0xBB, "Name": "Lightning Rook", "MaxLevel": 4 },
0xBC: { "ID": 0xBC, "Name": "Jack's Knight", "MaxLevel": 4 },
0xBD: { "ID": 0xBD, "Name": "King's Knight", "MaxLevel": 4 },
0xBE: { "ID": 0xBE, "Name": "Queen's Knight", "MaxLevel": 4 },
0xBF: { "ID": 0xBF, "Name": "Her Royal Highness", "MaxLevel": 3 },
0xC0: { "ID": 0xC0, "Name": "Pegaso", "MaxLevel": 3 },
0xC1: { "ID": 0xC1, "Name": "Lazy Bomber", "MaxLevel": 7 },
0xC2: { "ID": 0xC2, "Name": "Flower of Flame", "MaxLevel": 3 },
0xC3: { "ID": 0xC3, "Name": "Flower of Fire", "MaxLevel": 4 },
0xC4: { "ID": 0xC4, "Name": "Kewl Line", "MaxLevel": 5 },
0xC5: { "ID": 0xC5, "Name": "Dope Line", "MaxLevel": 5 },
0xC6: { "ID": 0xC6, "Name": "Wild Line", "MaxLevel": 4 },
0xC7: { "ID": 0xC7, "Name": "Fly Line", "MaxLevel": 5 },
0xC8: { "ID": 0xC8, "Name": "Fresh Line", "MaxLevel": 5 },
0xC9: { "ID": 0xC9, "Name": "Microcosmic Pull", "MaxLevel": 4 },
0xCA: { "ID": 0xCA, "Name": "Cosmic Pull", "MaxLevel": 3 },
0xCB: { "ID": 0xCB, "Name": "Macrocosmic Pull", "MaxLevel": 2 },
0xCC: { "ID": 0xCC, "Name": "Diss", "MaxLevel": 1 },
0xCD: { "ID": 0xCD, "Name": "Wild Boar", "MaxLevel": 3 },
0xCE: { "ID": 0xCE, "Name": "Big Bang", "MaxLevel": 10 },
0xCF: { "ID": 0xCF, "Name": "Big Crunch", "MaxLevel": 10 },
0xD0: { "ID": 0xD0, "Name": "Swift as the Wind", "MaxLevel": 10 },
0xD1: { "ID": 0xD1, "Name": "Hushed as the Wood", "MaxLevel": 10 },
0xD2: { "ID": 0xD2, "Name": "Fierce as the Flame", "MaxLevel": 10 },
0xD3: { "ID": 0xD3, "Name": "Stalwart as the Mount", "MaxLevel": 10 },
0xD4: { "ID": 0xD4, "Name": "Black Mars", "MaxLevel": 10 },
0xD5: { "ID": 0xD5, "Name": "Black Jupiter", "MaxLevel": 10 },
0xD6: { "ID": 0xD6, "Name": "Black Uranus", "MaxLevel": 10 },
0xD7: { "ID": 0xD7, "Name": "Black Venus", "MaxLevel": 10 },
0xD8: { "ID": 0xD8, "Name": "Black Saturn", "MaxLevel": 10 },
0xD9: { "ID": 0xD9, "Name": "Black Mercury", "MaxLevel": 10 },
0xDA: { "ID": 0xDA, "Name": "Righty Cat", "MaxLevel": 3 },
0xDB: { "ID": 0xDB, "Name": "Brainy Cat", "MaxLevel": 3 },
0xDC: { "ID": 0xDC, "Name": "Lefty Cat", "MaxLevel": 3 },
0xDD: { "ID": 0xDD, "Name": "One Jump from Eden", "MaxLevel": 5 },
0xDE: { "ID": 0xDE, "Name": "One Skip from Eden", "MaxLevel": 5 },
0xDF: { "ID": 0xDF, "Name": "One Hop from Eden", "MaxLevel": 5 },
0xE0: { "ID": 0xE0, "Name": "One Step from Eden", "MaxLevel": 5 },
0xE1: { "ID": 0xE1, "Name": "Eden's Door", "MaxLevel": 5 },
0xE2: { "ID": 0xE2, "Name": "Visionary Blend", "MaxLevel": 1 },
0xE3: { "ID": 0xE3, "Name": "Red Skull", "MaxLevel": 1 },
0xE4: { "ID": 0xE4, "Name": "Gatito", "MaxLevel": 1 },
0xE5: { "ID": 0xE5, "Name": "Tin Pin Fire", "MaxLevel": 4 },
0xE6: { "ID": 0xE6, "Name": "Tin Pin Custom", "MaxLevel": 1 },
0xE7: { "ID": 0xE7, "Name": "Tin Pin Wind", "MaxLevel": 6 },
0xE8: { "ID": 0xE8, "Name": "Tin Pin Blade", "MaxLevel": 6 },
0xE9: { "ID": 0xE9, "Name": "Tin Pin Wheel", "MaxLevel": 3 },
0xEA: { "ID": 0xEA, "Name": "Tin Pin Dash", "MaxLevel": 4 },
0xEB: { "ID": 0xEB, "Name": "Tin Pin Thrift", "MaxLevel": 3 },
0xEC: { "ID": 0xEC, "Name": "Tin Pin Hellfire", "MaxLevel": 7 },
0xED: { "ID": 0xED, "Name": "Tin Pin Sunscorch", "MaxLevel": 3 },
0xEE: { "ID": 0xEE, "Name": "Tin Pin Rocker", "MaxLevel": 2 },
0xEF: { "ID": 0xEF, "Name": "Tin Pin Artist", "MaxLevel": 4 },
0xF0: { "ID": 0xF0, "Name": "Tin Pin Devil", "MaxLevel": 8 },
0xF1: { "ID": 0xF1, "Name": "Tin Pin Ifrit", "MaxLevel": 3 },
0xF2: { "ID": 0xF2, "Name": "Tin Pin Shiva", "MaxLevel": 4 },
0xF3: { "ID": 0xF3, "Name": "Tin Pin Golem", "MaxLevel": 5 },
0xF4: { "ID": 0xF4, "Name": "Tin Pin Bahamut", "MaxLevel": 6 },
0xF5: { "ID": 0xF5, "Name": "1 Yen", "MaxLevel": 2 },
0xF6: { "ID": 0xF6, "Name": "5 Yen", "MaxLevel": 2 },
0xF7: { "ID": 0xF7, "Name": "10 Yen", "MaxLevel": 2 },
0xF8: { "ID": 0xF8, "Name": "50 Yen", "MaxLevel": 2 },
0xF9: { "ID": 0xF9, "Name": "100 Yen", "MaxLevel": 2 },
0xFA: { "ID": 0xFA, "Name": "500 Yen", "MaxLevel": 2 },
0xFB: { "ID": 0xFB, "Name": "1,000 Yen", "MaxLevel": 2 },
0xFC: { "ID": 0xFC, "Name": "5,000 Yen", "MaxLevel": 2 },
0xFD: { "ID": 0xFD, "Name": "10,000 Yen", "MaxLevel": 1 },
0xFE: { "ID": 0xFE, "Name": "Scarletite", "MaxLevel": 1 },
0xFF: { "ID": 0xFF, "Name": "Rare Metal", "MaxLevel": 1 },
0x100: { "ID": 0x100, "Name": "Tektite", "MaxLevel": 1 },
0x101: { "ID": 0x101, "Name": "Adamantite", "MaxLevel": 1 },
0x102: { "ID": 0x102, "Name": "Orichalcum", "MaxLevel": 1 },
0x103: { "ID": 0x103, "Name": "Shadow Matter", "MaxLevel": 1 },
0x104: { "ID": 0x104, "Name": "Dark Matter", "MaxLevel": 1 },
0x105: { "ID": 0x105, "Name": "Rhyme", "MaxLevel": 1 },
0x106: { "ID": 0x106, "Name": "Lucky Star", "MaxLevel": 3 },
0x107: { "ID": 0x107, "Name": "Lady Luck", "MaxLevel": 3 },
0x108: { "ID": 0x108, "Name": "Lucky Panda", "MaxLevel": 3 },
0x109: { "ID": 0x109, "Name": "Pyrokinesis", "MaxLevel": 3 },
0x10A: { "ID": 0x10A, "Name": "Shockwave", "MaxLevel": 3 },
0x10B: { "ID": 0x10B, "Name": "Cure Drink", "MaxLevel": 3 },
0x10C: { "ID": 0x10C, "Name": "Force Rounds", "MaxLevel": 3 },
0x10D: { "ID": 0x10D, "Name": "Psychokinesis", "MaxLevel": 2 },
0x10E: { "ID": 0x10E, "Name": "Thunderbolt", "MaxLevel": 2 },
0x10F: { "ID": 0x10F, "Name": "The Eyes Have It", "MaxLevel": 3 },
0x110: { "ID": 0x110, "Name": "I Live for Food", "MaxLevel": 3 },
0x111: { "ID": 0x111, "Name": "Walk on, Walk off", "MaxLevel": 3 },
0x112: { "ID": 0x112, "Name": "Me Time is Free Time", "MaxLevel": 3 },
0x113: { "ID": 0x113, "Name": "Fuji Yama", "MaxLevel": 5 },
0x114: { "ID": 0x114, "Name": "Daruma", "MaxLevel": 5 },
0x115: { "ID": 0x115, "Name": "Sushi", "MaxLevel": 5 },
0x116: { "ID": 0x116, "Name": "Shinobi", "MaxLevel": 5 },
0x117: { "ID": 0x117, "Name": "Tigris", "MaxLevel": 10 },
0x118: { "ID": 0x118, "Name": "Corehog", "MaxLevel": 5 },
0x119: { "ID": 0x119, "Name": "Jelly", "MaxLevel": 7 },
0x11A: { "ID": 0x11A, "Name": "Shark", "MaxLevel": 3 },
0x11B: { "ID": 0x11B, "Name": "Leo", "MaxLevel": 3 },
0x11C: { "ID": 0x11C, "Name": "Ovis", "MaxLevel": 9 },
0x11D: { "ID": 0x11D, "Name": "Cornix", "MaxLevel": 4 },
0x11E: { "ID": 0x11E, "Name": "Popguin", "MaxLevel": 3 },
0x11F: { "ID": 0x11F, "Name": "Pteropus", "MaxLevel": 6 },
0x120: { "ID": 0x120, "Name": "Mink", "MaxLevel": 4 },
0x121: { "ID": 0x121, "Name": "Boomer", "MaxLevel": 5 },
0x122: { "ID": 0x122, "Name": "Sprog", "MaxLevel": 4 },
0x123: { "ID": 0x123, "Name": "Fox", "MaxLevel": 3 },
0x124: { "ID": 0x124, "Name": "Bat", "MaxLevel": 5 },
0x125: { "ID": 0x125, "Name": "Rhino", "MaxLevel": 4 },
0x126: { "ID": 0x126, "Name": "Shrew", "MaxLevel": 6 },
0x127: { "ID": 0x127, "Name": "Woolly", "MaxLevel": 4 },
0x128: { "ID": 0x128, "Name": "Raven", "MaxLevel": 9 },
0x129: { "ID": 0x129, "Name": "Drake", "MaxLevel": 15 },
0x12A: { "ID": 0x12A, "Name": "Anguis", "MaxLevel": 20 },
0x12B: { "ID": 0x12B, "Name": "Pig", "MaxLevel": 1 },
0x12C: { "ID": 0x12C, "Name": "Carcin", "MaxLevel": 3 },
0x12D: { "ID": 0x12D, "Name": "Grizzly", "MaxLevel": 3 },
0x12E: { "ID": 0x12E, "Name": "Wolf", "MaxLevel": 5 },
0x12F: { "ID": 0x12F, "Name": "Frog", "MaxLevel": 4 },
}

function GetPinById(id)
{
    for i in pins
    {
        if (id == i)
        {
            return pins[i]
        }
    }
}

function deckSlot1BaseAddr() => 0x071d84
function deckPinByteSize() => 10

function IsDeckPinMasteredByAddr(baseAddr)
{
    id = word(baseAddr)
    level = low4(baseAddr + 0x9)
    result = always_false()
    
    for i in pins
    {
        pin = pins[i]
        result = result || level == pin["MaxLevel"] && pin["ID"] == id
    }

    return result
}

function IsDeckPinMastered(slotId)
{
    return IsDeckPinMasteredByAddr(deckSlot1BaseAddr() + slotId * deckPinByteSize())
}

function IsAnyDeckPinMastered()
{
    result = always_false()
    for i in range(0, 5)
    {
        result = result || IsDeckPinMastered(i)
    }
    return result
}

achievement(title = "Save Protection Test", points = 0,
    description = "If this pops when the game loads, save protection is bugged!",
    trigger = WasBitflagSetInGame(noiseInterrobang())
)

achievement(title = "Pin Mastery Test", points = 0,
    description = "Master a pin in your deck.",
    trigger = IsAnyDeckPinMastered() && isOnTitleScreen() == 0x0
)

achievement(title = "Battle Star", points = 5,
    description = "Attain a 🟊 ranking in battle on Hard or Ultimate difficulty.",
    trigger = currentRankingGraphic() == GetRankingGraphicIndexByName("Star") && IsRankingRevealed()
)

timeLimit = 30
achievement(title = "Don't Kill Me Slowly", points = 5,
    description = "Defeat the Metal Corehog on Week 1, Day 2, within " + SecondsToFormat(timeLimit) + " on Normal difficulty or higher.",
    trigger = always_false()
)